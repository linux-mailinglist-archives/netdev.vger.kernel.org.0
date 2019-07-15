Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5343C68270
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 05:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728952AbfGODKy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jul 2019 23:10:54 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:34760 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726074AbfGODKy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Jul 2019 23:10:54 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6F37UCd087037;
        Sun, 14 Jul 2019 23:10:29 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tradytypd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 14 Jul 2019 23:10:29 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x6F386AO088799;
        Sun, 14 Jul 2019 23:10:29 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tradytynp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 14 Jul 2019 23:10:29 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x6F34Nr3011789;
        Mon, 15 Jul 2019 03:10:27 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma01wdc.us.ibm.com with ESMTP id 2tq6x5mng1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Jul 2019 03:10:27 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6F3ARWb34669020
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Jul 2019 03:10:27 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0E978B2065;
        Mon, 15 Jul 2019 03:10:27 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B7773B205F;
        Mon, 15 Jul 2019 03:10:26 +0000 (GMT)
Received: from paulmck-ThinkPad-W541 (unknown [9.85.203.247])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 15 Jul 2019 03:10:26 +0000 (GMT)
Received: by paulmck-ThinkPad-W541 (Postfix, from userid 1000)
        id 3781416C8F3E; Sun, 14 Jul 2019 20:10:27 -0700 (PDT)
Date:   Sun, 14 Jul 2019 20:10:27 -0700
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
Message-ID: <20190715031027.GA3336@linux.ibm.com>
Reply-To: paulmck@linux.ibm.com
References: <CACT4Y+aNLHrYj1pYbkXO7CKESLeB-5enkSDK7ksgkMA3KtwJ+w@mail.gmail.com>
 <20190705191055.GT26519@linux.ibm.com>
 <20190706042801.GD11665@mit.edu>
 <20190706061631.GV26519@linux.ibm.com>
 <20190706150226.GG11665@mit.edu>
 <20190706180311.GW26519@linux.ibm.com>
 <20190707011655.GA22081@linux.ibm.com>
 <CACT4Y+asYe-uH9OV5R0Nkb-JKP4erYUZ68S9gYNnGg6v+fD20w@mail.gmail.com>
 <20190714190522.GA24049@mit.edu>
 <20190714192951.GM26519@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190714192951.GM26519@linux.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-14_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907150037
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 14, 2019 at 12:29:51PM -0700, Paul E. McKenney wrote:
> On Sun, Jul 14, 2019 at 03:05:22PM -0400, Theodore Ts'o wrote:
> > On Sun, Jul 14, 2019 at 05:48:00PM +0300, Dmitry Vyukov wrote:
> > > But short term I don't see any other solution than stop testing
> > > sched_setattr because it does not check arguments enough to prevent
> > > system misbehavior. Which is a pity because syzkaller has found some
> > > bad misconfigurations that were oversight on checking side.
> > > Any other suggestions?
> > 
> > Or maybe syzkaller can put its own limitations on what parameters are
> > sent to sched_setattr?  In practice, there are any number of ways a
> > root user can shoot themselves in the foot when using sched_setattr or
> > sched_setaffinity, for that matter.  I imagine there must be some such
> > constraints already --- or else syzkaller might have set a kernel
> > thread to run with priority SCHED_BATCH, with similar catastrophic
> > effects --- or do similar configurations to make system threads
> > completely unschedulable.
> > 
> > Real time administrators who know what they are doing --- and who know
> > that their real-time threads are well behaved --- will always want to
> > be able to do things that will be catastrophic if the real-time thread
> > is *not* well behaved.  I don't it is possible to add safety checks
> > which would allow the kernel to automatically detect and reject unsafe
> > configurations.
> > 
> > An apt analogy might be civilian versus military aircraft.  Most
> > airplanes are designed to be "inherently stable"; that way, modulo
> > buggy/insane control systems like on the 737 Max, the airplane will
> > automatically return to straight and level flight.  On the other hand,
> > some military planes (for example, the F-16, F-22, F-36, the
> > Eurofighter, etc.) are sometimes designed to be unstable, since that
> > way they can be more maneuverable.
> > 
> > There are use cases for real-time Linux where this flexibility/power
> > vs. stability tradeoff is going to argue for giving root the
> > flexibility to crash the system.  Some of these systems might
> > literally involve using real-time Linux in military applications,
> > something for which Paul and I have had some experience.  :-)
> > 
> > Speaking of sched_setaffinity, one thing which we can do is have
> > syzkaller move all of the system threads to they run on the "system
> > CPU's", and then move the syzkaller processes which are testing the
> > kernel to be on the "system under test CPU's".  Then regardless of
> > what priority the syzkaller test programs try to run themselves at,
> > they can't crash the system.
> > 
> > Some real-time systems do actually run this way, and it's a
> > recommended configuration which is much safer than letting the
> > real-time threads take over the whole system:
> > 
> > http://linuxrealtime.org/index.php/Improving_the_Real-Time_Properties#Isolating_the_Application
> 
> Good point!  We might still have issues with some per-CPU kthreads,
> but perhaps use of nohz_full would help at least reduce these sorts
> of problems.  (There could still be issues on CPUs with more than
> one runnable threads.)

I looked at testing limitations in a bit more detail from an RCU
viewpoint, and came up with the following rough rule of thumb (which of
course might or might not survive actual testing experience, but should at
least be a good place to start).  I believe that the sched_setaffinity()
testing rule should be that the SCHED_DEADLINE cycle be no more than
two-thirds of the RCU CPU stall warning timeout, which defaults to 21
seconds in mainline and 60 seconds in many distro kernels.

That is, the SCHED_DEADLINE cycle should never exceed 14 seconds when
testing mainline on the one hand or 40 seconds when testing enterprise
distros on the other.

This assumes quite a bit, though:

o	The system has ample memory to spare, and isn't running a
	callback-hungry workload.  For example, if you "only" have 100MB
	of spare memory and you are also repeatedly and concurrently
	expanding (say) large source trees from tarballs and then deleting
	those source trees, the system might OOM.  The reason OOM might
	happen is that each close() of a file generates an RCU callback,
	and 40 seconds worth of waiting-for-a-grace-period structures
	takes up a surprisingly large amount of memory.

	So please be careful when combining tests.  ;-)

o	There are no aggressive real-time workloads on the system.
	The reason for this is that RCU is going to start sending IPIs
	halfway to the RCU CPU stall timeout, and, in certain situations
	on CONFIG_NO_HZ_FULL kernels, much earlier.  (These situations
	constitute abuse of CONFIG_NO_HZ_FULL, but then again carefully
	calibrated abuse is what stress testing is all about.)

o	The various RCU kthreads will get a chance to run at least once
	during the SCHED_DEADLINE cycle.  If in real life, they only
	get a chance to run once per two SCHED_DEADLINE cycles, then of
	course the 14 seconds becomes 7 and the 40 seconds becomes 20.

o	The current RCU CPU stall warning defaults remain in
	place.	These are set by the CONFIG_RCU_CPU_STALL_TIMEOUT
	Kconfig parameter, which may in turn be overridden by the
	rcupdate.rcu_cpu_stall_timeout kernel boot parameter.

o	The current SCHED_DEADLINE default for providing spare cycles
	for other uses remains in place.

o	Other kthreads might have other constraints, but given that you
	were seeing RCU CPU stall warnings instead of other failures,
	the needs of RCU's kthreads seem to be a good place to start.

Again, the candidate rough rule of thumb is that the the SCHED_DEADLINE
cycle be no more than 14 seconds when testing mainline kernels on the one
hand and 40 seconds when testing enterprise distro kernels on the other.

Dmitry, does that help?

							Thanx, Paul
