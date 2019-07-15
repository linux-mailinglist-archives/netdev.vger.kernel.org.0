Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB1A968A28
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 15:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730139AbfGONB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 09:01:29 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:59078 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730012AbfGONB3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 09:01:29 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6FD1ArN097246
        for <netdev@vger.kernel.org>; Mon, 15 Jul 2019 09:01:27 -0400
Received: from e16.ny.us.ibm.com (e16.ny.us.ibm.com [129.33.205.206])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2trrjpkytw-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 15 Jul 2019 09:01:25 -0400
Received: from localhost
        by e16.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <paulmck@linux.vnet.ibm.com>;
        Mon, 15 Jul 2019 14:01:09 +0100
Received: from b01cxnp23033.gho.pok.ibm.com (9.57.198.28)
        by e16.ny.us.ibm.com (146.89.104.203) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 15 Jul 2019 14:01:03 +0100
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6FD121X30605664
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Jul 2019 13:01:02 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 35EB5B2072;
        Mon, 15 Jul 2019 13:01:02 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 90466B206A;
        Mon, 15 Jul 2019 13:01:01 +0000 (GMT)
Received: from paulmck-ThinkPad-W541 (unknown [9.85.164.210])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 15 Jul 2019 13:01:01 +0000 (GMT)
Received: by paulmck-ThinkPad-W541 (Postfix, from userid 1000)
        id 30F5716C3FC8; Mon, 15 Jul 2019 06:01:01 -0700 (PDT)
Date:   Mon, 15 Jul 2019 06:01:01 -0700
From:   "Paul E. McKenney" <paulmck@linux.ibm.com>
To:     "Theodore Ts'o" <tytso@mit.edu>,
        Dmitry Vyukov <dvyukov@google.com>,
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
References: <20190705191055.GT26519@linux.ibm.com>
 <20190706042801.GD11665@mit.edu>
 <20190706061631.GV26519@linux.ibm.com>
 <20190706150226.GG11665@mit.edu>
 <20190706180311.GW26519@linux.ibm.com>
 <20190707011655.GA22081@linux.ibm.com>
 <CACT4Y+asYe-uH9OV5R0Nkb-JKP4erYUZ68S9gYNnGg6v+fD20w@mail.gmail.com>
 <20190714190522.GA24049@mit.edu>
 <20190714192951.GM26519@linux.ibm.com>
 <20190715031027.GA3336@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190715031027.GA3336@linux.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
x-cbid: 19071513-0072-0000-0000-00000449168F
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011432; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01232525; UDB=6.00649364; IPR=6.01013826;
 MB=3.00027724; MTD=3.00000008; XFM=3.00000015; UTC=2019-07-15 13:01:07
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19071513-0073-0000-0000-00004CB95F9C
Message-Id: <20190715130101.GA5527@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-15_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907150156
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 14, 2019 at 08:10:27PM -0700, Paul E. McKenney wrote:
> On Sun, Jul 14, 2019 at 12:29:51PM -0700, Paul E. McKenney wrote:
> > On Sun, Jul 14, 2019 at 03:05:22PM -0400, Theodore Ts'o wrote:
> > > On Sun, Jul 14, 2019 at 05:48:00PM +0300, Dmitry Vyukov wrote:
> > > > But short term I don't see any other solution than stop testing
> > > > sched_setattr because it does not check arguments enough to prevent
> > > > system misbehavior. Which is a pity because syzkaller has found some
> > > > bad misconfigurations that were oversight on checking side.
> > > > Any other suggestions?
> > > 
> > > Or maybe syzkaller can put its own limitations on what parameters are
> > > sent to sched_setattr?  In practice, there are any number of ways a
> > > root user can shoot themselves in the foot when using sched_setattr or
> > > sched_setaffinity, for that matter.  I imagine there must be some such
> > > constraints already --- or else syzkaller might have set a kernel
> > > thread to run with priority SCHED_BATCH, with similar catastrophic
> > > effects --- or do similar configurations to make system threads
> > > completely unschedulable.
> > > 
> > > Real time administrators who know what they are doing --- and who know
> > > that their real-time threads are well behaved --- will always want to
> > > be able to do things that will be catastrophic if the real-time thread
> > > is *not* well behaved.  I don't it is possible to add safety checks
> > > which would allow the kernel to automatically detect and reject unsafe
> > > configurations.
> > > 
> > > An apt analogy might be civilian versus military aircraft.  Most
> > > airplanes are designed to be "inherently stable"; that way, modulo
> > > buggy/insane control systems like on the 737 Max, the airplane will
> > > automatically return to straight and level flight.  On the other hand,
> > > some military planes (for example, the F-16, F-22, F-36, the
> > > Eurofighter, etc.) are sometimes designed to be unstable, since that
> > > way they can be more maneuverable.
> > > 
> > > There are use cases for real-time Linux where this flexibility/power
> > > vs. stability tradeoff is going to argue for giving root the
> > > flexibility to crash the system.  Some of these systems might
> > > literally involve using real-time Linux in military applications,
> > > something for which Paul and I have had some experience.  :-)
> > > 
> > > Speaking of sched_setaffinity, one thing which we can do is have
> > > syzkaller move all of the system threads to they run on the "system
> > > CPU's", and then move the syzkaller processes which are testing the
> > > kernel to be on the "system under test CPU's".  Then regardless of
> > > what priority the syzkaller test programs try to run themselves at,
> > > they can't crash the system.
> > > 
> > > Some real-time systems do actually run this way, and it's a
> > > recommended configuration which is much safer than letting the
> > > real-time threads take over the whole system:
> > > 
> > > http://linuxrealtime.org/index.php/Improving_the_Real-Time_Properties#Isolating_the_Application
> > 
> > Good point!  We might still have issues with some per-CPU kthreads,
> > but perhaps use of nohz_full would help at least reduce these sorts
> > of problems.  (There could still be issues on CPUs with more than
> > one runnable threads.)
> 
> I looked at testing limitations in a bit more detail from an RCU
> viewpoint, and came up with the following rough rule of thumb (which of
> course might or might not survive actual testing experience, but should at
> least be a good place to start).  I believe that the sched_setaffinity()
> testing rule should be that the SCHED_DEADLINE cycle be no more than
> two-thirds of the RCU CPU stall warning timeout, which defaults to 21
> seconds in mainline and 60 seconds in many distro kernels.
> 
> That is, the SCHED_DEADLINE cycle should never exceed 14 seconds when
> testing mainline on the one hand or 40 seconds when testing enterprise
> distros on the other.
> 
> This assumes quite a bit, though:
> 
> o	The system has ample memory to spare, and isn't running a
> 	callback-hungry workload.  For example, if you "only" have 100MB
> 	of spare memory and you are also repeatedly and concurrently
> 	expanding (say) large source trees from tarballs and then deleting
> 	those source trees, the system might OOM.  The reason OOM might
> 	happen is that each close() of a file generates an RCU callback,
> 	and 40 seconds worth of waiting-for-a-grace-period structures
> 	takes up a surprisingly large amount of memory.
> 
> 	So please be careful when combining tests.  ;-)
> 
> o	There are no aggressive real-time workloads on the system.
> 	The reason for this is that RCU is going to start sending IPIs
> 	halfway to the RCU CPU stall timeout, and, in certain situations
> 	on CONFIG_NO_HZ_FULL kernels, much earlier.  (These situations
> 	constitute abuse of CONFIG_NO_HZ_FULL, but then again carefully
> 	calibrated abuse is what stress testing is all about.)
> 
> o	The various RCU kthreads will get a chance to run at least once
> 	during the SCHED_DEADLINE cycle.  If in real life, they only
> 	get a chance to run once per two SCHED_DEADLINE cycles, then of
> 	course the 14 seconds becomes 7 and the 40 seconds becomes 20.

And there are configurations and workloads that might require division
by three, so that (assuming one chance to run per cycle), the 14 seconds
becomes about 5 and the 40 seconds becomes about 15.

> o	The current RCU CPU stall warning defaults remain in
> 	place.	These are set by the CONFIG_RCU_CPU_STALL_TIMEOUT
> 	Kconfig parameter, which may in turn be overridden by the
> 	rcupdate.rcu_cpu_stall_timeout kernel boot parameter.
> 
> o	The current SCHED_DEADLINE default for providing spare cycles
> 	for other uses remains in place.
> 
> o	Other kthreads might have other constraints, but given that you
> 	were seeing RCU CPU stall warnings instead of other failures,
> 	the needs of RCU's kthreads seem to be a good place to start.
> 
> Again, the candidate rough rule of thumb is that the the SCHED_DEADLINE
> cycle be no more than 14 seconds when testing mainline kernels on the one
> hand and 40 seconds when testing enterprise distro kernels on the other.
> 
> Dmitry, does that help?

I checked with the people running the Linux Plumbers Conference Scheduler
Microconference, and they said that they would welcome a proposal on
this topic, which I have submitted (please see below).  Would anyone
like to join as co-conspirator?

							Thanx, Paul

------------------------------------------------------------------------

Title: Making SCHED_DEADLINE safe for kernel kthreads

Abstract:

Dmitry Vyukov's testing work identified some (ab)uses of sched_setattr()
that can result in SCHED_DEADLINE tasks starving RCU's kthreads for
extended time periods, not millisecond, not seconds, not minutes, not even
hours, but days. Given that RCU CPU stall warnings are issued whenever
an RCU grace period fails to complete within a few tens of seconds,
the system did not suffer silently. Although one could argue that people
should avoid abusing sched_setattr(), people are human and humans make
mistakes. Responding to simple mistakes with RCU CPU stall warnings is
all well and good, but a more severe case could OOM the system, which
is a particularly unhelpful error message.

It would be better if the system were capable of operating reasonably
despite such abuse. Several approaches have been suggested.

First, sched_setattr() could recognize parameter settings that put
kthreads at risk and refuse to honor those settings. This approach
of course requires that we identify precisely what combinations of
sched_setattr() parameters settings are risky, especially given that there
are likely to be parameter settings that are both risky and highly useful.

Second, in theory, RCU could detect this situation and take the "dueling
banjos" approach of increasing its priority as needed to get the CPU time
that its kthreads need to operate correctly. However, the required amount
of CPU time can vary greatly depending on the workload. Furthermore,
non-RCU kthreads also need some amount of CPU time, and replicating
"dueling banjos" across all such Linux-kernel subsystems seems both
wasteful and error-prone. Finally, experience has shown that setting
RCU's kthreads to real-time priorities significantly harms performance
by increasing context-switch rates.

Third, stress testing could be limited to non-risky regimes, such that
kthreads get CPU time every 5-40 seconds, depending on configuration
and experience. People needing risky parameter settings could then test
the settings that they actually need, and also take responsibility for
ensuring that kthreads get the CPU time that they need. (This of course
includes per-CPU kthreads!)

Fourth, bandwidth throttling could treat tasks in other scheduling classes
as an aggregate group having a reasonable aggregate deadline and CPU
budget. This has the advantage of allowing "abusive" testing to proceed,
which allows people requiring risky parameter settings to rely on this
testing. Additionally, it avoids complex progress checking and priority
setting on the part of many kthreads throughout the system. However,
if this was an easy choice, the SCHED_DEADLINE developers would likely
have selected it. For example, it is necessary to determine what might
be a "reasonable" aggregate deadline and CPU budget. Reserving 5%
seems quite generous, and RCU's grace-period kthread would optimally
like a deadline in the milliseconds, but would do reasonably well with
many tens of milliseconds, and absolutely needs a few seconds. However,
for CONFIG_RCU_NOCB_CPU=y, the RCU's callback-offload kthreads might
well need a full CPU each! (This happens when the CPU being offloaded
generates a high rate of callbacks.)

The goal of this proposal is therefore to generate face-to-face
discussion, hopefully resulting in a good and sufficient solution to
this problem.

