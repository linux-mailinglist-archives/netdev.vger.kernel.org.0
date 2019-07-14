Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 994CB680D3
	for <lists+netdev@lfdr.de>; Sun, 14 Jul 2019 20:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728719AbfGNStY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jul 2019 14:49:24 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:8038 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728125AbfGNStX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Jul 2019 14:49:23 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6EIlG71103309
        for <netdev@vger.kernel.org>; Sun, 14 Jul 2019 14:49:21 -0400
Received: from e14.ny.us.ibm.com (e14.ny.us.ibm.com [129.33.205.204])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2tqvy453sc-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 14 Jul 2019 14:49:21 -0400
Received: from localhost
        by e14.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <paulmck@linux.vnet.ibm.com>;
        Sun, 14 Jul 2019 19:49:21 +0100
Received: from b01cxnp23034.gho.pok.ibm.com (9.57.198.29)
        by e14.ny.us.ibm.com (146.89.104.201) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Sun, 14 Jul 2019 19:49:17 +0100
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6EInGX854526432
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 14 Jul 2019 18:49:16 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1DDB1B2064;
        Sun, 14 Jul 2019 18:49:16 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C5EAEB205F;
        Sun, 14 Jul 2019 18:49:15 +0000 (GMT)
Received: from paulmck-ThinkPad-W541 (unknown [9.85.203.247])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Sun, 14 Jul 2019 18:49:15 +0000 (GMT)
Received: by paulmck-ThinkPad-W541 (Postfix, from userid 1000)
        id B3C3016C8FBA; Sun, 14 Jul 2019 11:49:15 -0700 (PDT)
Date:   Sun, 14 Jul 2019 11:49:15 -0700
From:   "Paul E. McKenney" <paulmck@linux.ibm.com>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     "Theodore Ts'o" <tytso@mit.edu>,
        syzbot <syzbot+4bfbbf28a2e50ab07368@syzkaller.appspotmail.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        David Miller <davem@davemloft.net>, eladr@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        John Stultz <john.stultz@linaro.org>,
        linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: INFO: rcu detected stall in ext4_write_checks
Reply-To: paulmck@linux.ibm.com
References: <CACT4Y+YTpUErjEmjrqki-tJ0Lyx0c53MQDGVS4CixfmcAnuY=A@mail.gmail.com>
 <20190705151658.GP26519@linux.ibm.com>
 <CACT4Y+aNLHrYj1pYbkXO7CKESLeB-5enkSDK7ksgkMA3KtwJ+w@mail.gmail.com>
 <20190705191055.GT26519@linux.ibm.com>
 <20190706042801.GD11665@mit.edu>
 <20190706061631.GV26519@linux.ibm.com>
 <20190706150226.GG11665@mit.edu>
 <20190706180311.GW26519@linux.ibm.com>
 <20190707011655.GA22081@linux.ibm.com>
 <CACT4Y+asYe-uH9OV5R0Nkb-JKP4erYUZ68S9gYNnGg6v+fD20w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACT4Y+asYe-uH9OV5R0Nkb-JKP4erYUZ68S9gYNnGg6v+fD20w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
x-cbid: 19071418-0052-0000-0000-000003DEEAD0
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011428; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01232170; UDB=6.00649147; IPR=6.01013462;
 MB=3.00027716; MTD=3.00000008; XFM=3.00000015; UTC=2019-07-14 18:49:20
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19071418-0053-0000-0000-000061B0A53E
Message-Id: <20190714184915.GK26519@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-14_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907140234
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 14, 2019 at 05:48:00PM +0300, Dmitry Vyukov wrote:
> On Sun, Jul 7, 2019 at 4:17 AM Paul E. McKenney <paulmck@linux.ibm.com> wrote:
> > > > > I suppose RCU could take the dueling-banjos approach and use increasingly
> > > > > aggressive scheduler policies itself, up to and including SCHED_DEADLINE,
> > > > > until it started getting decent forward progress.  However, that
> > > > > sounds like the something that just might have unintended consequences,
> > > > > particularly if other kernel subsystems were to also play similar
> > > > > games of dueling banjos.
> > > >
> > > > So long as the RCU threads are well-behaved, using SCHED_DEADLINE
> > > > shouldn't have much of an impact on the system --- and the scheduling
> > > > parameters that you can specify on SCHED_DEADLINE allows you to
> > > > specify the worst-case impact on the system while also guaranteeing
> > > > that the SCHED_DEADLINE tasks will urn in the first place.  After all,
> > > > that's the whole point of SCHED_DEADLINE.
> > > >
> > > > So I wonder if the right approach is during the the first userspace
> > > > system call to shced_setattr to enable a (any) real-time priority
> > > > scheduler (SCHED_DEADLINE, SCHED_FIFO or SCHED_RR) on a userspace
> > > > thread, before that's allowed to proceed, the RCU kernel threads are
> > > > promoted to be SCHED_DEADLINE with appropriately set deadline
> > > > parameters.  That way, a root user won't be able to shoot the system
> > > > in the foot, and since the vast majority of the time, there shouldn't
> > > > be any processes running with real-time priorities, we won't be
> > > > changing the behavior of a normal server system.
> > >
> > > It might well be.  However, running the RCU kthreads at real-time
> > > priority does not come for free.  For example, it tends to crank up the
> > > context-switch rate.
> > >
> > > Plus I have taken several runs at computing SCHED_DEADLINE parameters,
> > > but things like the rcuo callback-offload threads have computational
> > > requirements that are controlled not by RCU, and not just by the rest of
> > > the kernel, but also by userspace (keeping in mind the example of opening
> > > and closing a file in a tight loop, each pass of which queues a callback).
> > > I suspect that RCU is not the only kernel subsystem whose computational
> > > requirements are set not by the subsystem, but rather by external code.
> > >
> > > OK, OK, I suppose I could just set insanely large SCHED_DEADLINE
> > > parameters, following syzkaller's example, and then trust my ability to
> > > keep the RCU code from abusing the resulting awesome power.  But wouldn't
> > > a much nicer approach be to put SCHED_DEADLINE between SCHED_RR/SCHED_FIFO
> > > priorities 98 and 99 or some such?  Then the same (admittedly somewhat
> > > scary) result could be obtained much more simply via SCHED_FIFO or
> > > SCHED_RR priority 99.
> > >
> > > Some might argue that this is one of those situations where simplicity
> > > is not necessarily an advantage, but then again, you can find someone
> > > who will complain about almost anything.  ;-)
> > >
> > > > (I suspect there might be some audio applications that might try to
> > > > set real-time priorities, but for desktop systems, it's probably more
> > > > important that the system not tie its self into knots since the
> > > > average desktop user isn't going to be well equipped to debug the
> > > > problem.)
> > >
> > > Not only that, but if core counts continue to increase, and if reliance
> > > on cloud computing continues to grow, there are going to be an increasing
> > > variety of mixed workloads in increasingly less-controlled environments.
> > >
> > > So, yes, it would be good to solve this problem in some reasonable way.
> > >
> > > I don't see this as urgent just yet, but I am sure you all will let
> > > me know if I am mistaken on that point.
> > >
> > > > > Alternatively, is it possible to provide stricter admission control?
> > > >
> > > > I think that's an orthogonal issue; better admission control would be
> > > > nice, but it looks to me that it's going to be fundamentally an issue
> > > > of tweaking hueristics, and a fool-proof solution that will protect
> > > > against all malicious userspace applications (including syzkaller) is
> > > > going to require solving the halting problem.  So while it would be
> > > > nice to improve the admission control, I don't think that's a going to
> > > > be a general solution.
> > >
> > > Agreed, and my earlier point about the need to trust the coding abilities
> > > of those writing ultimate-priority code is all too consistent with your
> > > point about needing to solve the halting problem.  Nevertheless,  I believe
> > > that we could make something that worked reasonably well in practice.
> > >
> > > Here are a few components of a possible solution, in practice, but
> > > of course not in theory:
> > >
> > > 1.    We set limits to SCHED_DEADLINE parameters, perhaps novel ones.
> > >       For one example, insist on (say) 10 milliseconds of idle time
> > >       every second on each CPU.  Yes, you can configure beyond that
> > >       given sufficient permissions, but if you do so, you just voided
> > >       your warranty.
> > >
> > > 2.    Only allow SCHED_DEADLINE on nohz_full CPUs.  (Partial solution,
> > >       given that such a CPU might be running in the kernel or have
> > >       more than one runnable task.  Just for fun, I will suggest the
> > >       option of disabling SCHED_DEADLINE during such times.)
> > >
> > > 3.    RCU detects slowdowns, and does something TBD to increase its
> > >       priority, but only while the slowdown persists.  This likely
> > >       relies on scheduling-clock interrupts to detect the slowdowns,
> > >       so there might be additional challenges on a fully nohz_full
> > >       system.
> >
> > 4.      SCHED_DEADLINE treats the other three scheduling classes as each
> >         having a period, deadline, and a modest CPU consumption budget
> >         for the members of the class in aggregate.  But this has to have
> >         been discussed before.  How did that go?
> >
> > > 5.    Your idea here.
> 
> Trying to digest this thread.
> 
> Do I understand correctly that setting rcutree.kthread_prio=99 won't
> help because the deadline priority is higher?
> And there are no other existing mechanisms to either fix the stalls
> nor make kernel reject the non well-behaving parameters? Kernel tries
> to filter out non well-behaving parameters, but the check detects only
> obvious misconfigurations, right?
> This reminds of priority inversion/inheritance problem. I wonder if
> there are other kernel subsystems that suffer from the same problem.
> E.g. the background kernel thread that destroys net namespaces and any
> other type of async work. A high prio user process can overload the
> queue and make kernel eat all memory. May be relatively easy to do
> even unintentionally. I suspect the problem is not specific to rcu and
> plumbing just rcu may just make the next problem pop up.
> Should user be able to starve basic kernel services? User should be
> able to prioritize across user processes (potentially in radical
> ways), but perhaps it should not be able to badly starve kernel
> functions that just happened to be asynchronous? I guess it's not as
> simple as setting the highest prio for all kernel threads because in
> normal case we want to reduce latency of user work by making the work
> async. But user must not be able to starve kernel threads
> infinitely... sounds like something similar to the deadline scheduling
> -- kernel threads need to get at least some time slice per unit of
> time.

As I understand it, there is provision for giving other threads slack
time even in SCHED_DEADLINE, but the timing of that slack time depends
on the other tasks' SCHED_DEADLINE settings.  And RCU's kthreads do
need some response time: Optimally a few milliseconds, preferably about
a hundred milliseconds, but definitely a second.  With the huge cycle
time specified, RCU might not get that.

And yes, I suspect that RCU is not the only thing in the system needing
a little CPU time fairly frequently, for some ill-defined notion of
"fairly frequently".

> But short term I don't see any other solution than stop testing
> sched_setattr because it does not check arguments enough to prevent
> system misbehavior. Which is a pity because syzkaller has found some
> bad misconfigurations that were oversight on checking side.
> Any other suggestions?

Keep the times down to a few seconds?  Of course, that might also
fail to find interesting bugs.

							Thanx, Paul

