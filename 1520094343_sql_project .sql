/* Welcome to the SQL mini project. For this project, you will use
Springboard' online SQL platform, which you can log into through the
following link:

https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

Note that, if you need to, you can also download these tables locally.

In the mini project, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */



/* Q1: Some of the facilities charge a fee to members, but some do not.
Please list the names of the facilities that do. */

SELECT * 
FROM  `Facilities` 
WHERE membercost >0

/* Q2: How many facilities do not charge a fee to members? */

SELECT count( *) 
FROM  `Facilities` 
WHERE membercost =0


/* Q3: How can you produce a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost?
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */

SELECT facid, name, membercost, monthlymaintenance 
FROM `Facilities` 
where membercost < 0.2 * monthlymaintenance


/* Q4: How can you retrieve the details of facilities with ID 1 and 5?
Write the query without using the OR operator. */

SELECT * FROM `Facilities` WHERE facid in (1, 5)



/* Q5: How can you produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100? Return the name and monthly maintenance of the facilities
in question. */

SELECT name, monthlymaintenance,
case when monthlymaintenance > 100 then 'Expensive' else 'Cheap' end as 'Group'
FROM `Facilities`




/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Do not use the LIMIT clause for your solution. */


SELECT firstname, surname, joindate
FROM Members
where joindate = (select max(joindate) from Members)



/* Q7: How can you produce a list of all members who have used a tennis court?
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */

select distinct (Concat(Members.surname," ", Members.firstname)) as Full_Name, Facilities.Name
from Members
right join Bookings on Bookings.memid = Members.memid
join Facilities on Facilities.facid = Bookings.facid
where Facilities.facid in (1, 0)
where Members.memid is not (0)
order by Full_Name
 


/* Q8: How can you produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30? Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */

select Facilities.Name ,Concat(Members.surname," ", Members.firstname) as Full_Name

,case when Members.Memid = 0 then Facilities.Guestcost*Bookings.Slots
else Facilities.Membercost*Bookings.Slots end as Total_Cost

from Members
right join Bookings on Bookings.memid = Members.memid
join Facilities on Facilities.facid = Bookings.facid
where DATE(Bookings.Starttime) = '2012-09-14'
group by Facilities.Name, Concat(Members.surname," ", Members.firstname)
Having Total_Cost > 30



/* Q9: This time, produce the same result as in Q8, but using a subquery. */
ELECT member, facility, cost
FROM (

SELECT CONCAT(mems.surname, ', ', mems.firstname) AS member, facs.name AS facility, 
CASE 
	WHEN mems.memid =0
		THEN bks.slots * facs.guestcost
	ELSE bks.slots * facs.membercost
	END AS cost
FROM  `Members` mems
	JOIN  `Bookings` bks ON mems.memid = bks.memid
	INNER JOIN  `Facilities` facs ON bks.facid = facs.facid
	WHERE bks.starttime >=  '2012-09-14' AND bks.starttime < '2012-09-15') AS bookings
	WHERE cost >30
ORDER BY cost DESC






/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */
select Facilities.Name ,case when Members.Memid = 0 then Facilities.Guestcost*Bookings.Slots
else Facilities.Membercost*Bookings.Slots end as Revenue

from Members
right join Bookings on Bookings.memid = Members.memid
join Facilities on Facilities.facid = Bookings.facid
group by Facilities.Name
Having Revenue < 1000
order by revenue desc
