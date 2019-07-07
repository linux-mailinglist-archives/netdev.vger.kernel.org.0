Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC7686136A
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 03:17:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbfGGBRE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jul 2019 21:17:04 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:62560 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726985AbfGGBRD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jul 2019 21:17:03 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x671GwsY055885
        for <netdev@vger.kernel.org>; Sat, 6 Jul 2019 21:17:02 -0400
Received: from e16.ny.us.ibm.com (e16.ny.us.ibm.com [129.33.205.206])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tjr63vxq2-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 06 Jul 2019 21:17:02 -0400
Received: from localhost
        by e16.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <paulmck@linux.vnet.ibm.com>;
        Sun, 7 Jul 2019 02:17:01 +0100
Received: from b01cxnp22035.gho.pok.ibm.com (9.57.198.25)
        by e16.ny.us.ibm.com (146.89.104.203) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Sun, 7 Jul 2019 02:16:55 +0100
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x671GsRI49938908
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 7 Jul 2019 01:16:54 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A114DB2064;
        Sun,  7 Jul 2019 01:16:54 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 69EC2B205F;
        Sun,  7 Jul 2019 01:16:54 +0000 (GMT)
Received: from paulmck-ThinkPad-W541 (unknown [9.80.215.71])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Sun,  7 Jul 2019 01:16:54 +0000 (GMT)
Received: by paulmck-ThinkPad-W541 (Postfix, from userid 1000)
        id 6E06916C0EA4; Sat,  6 Jul 2019 18:16:55 -0700 (PDT)
Date:   Sat, 6 Jul 2019 18:16:55 -0700
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
References: <20190626210351.GF3116@mit.edu>
 <20190626224709.GH3116@mit.edu>
 <CACT4Y+YTpUErjEmjrqki-tJ0Lyx0c53MQDGVS4CixfmcAnuY=A@mail.gmail.com>
 <20190705151658.GP26519@linux.ibm.com>
 <CACT4Y+aNLHrYj1pYbkXO7CKESLeB-5enkSDK7ksgkMA3KtwJ+w@mail.gmail.com>
 <20190705191055.GT26519@linux.ibm.com>
 <20190706042801.GD11665@mit.edu>
 <20190706061631.GV26519@linux.ibm.com>
 <20190706150226.GG11665@mit.edu>
 <20190706180311.GW26519@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190706180311.GW26519@linux.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
x-cbid: 19070701-0072-0000-0000-000004454836
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011389; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01228505; UDB=6.00646923; IPR=6.01009754;
 MB=3.00027615; MTD=3.00000008; XFM=3.00000015; UTC=2019-07-07 01:17:00
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19070701-0073-0000-0000-00004CB58720
Message-Id: <20190707011655.GA22081@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-06_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907070016
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 06, 2019 at 11:03:11AM -0700, Paul E. McKenney wrote:
> On Sat, Jul 06, 2019 at 11:02:26AM -0400, Theodore Ts'o wrote:
> > On Fri, Jul 05, 2019 at 11:16:31PM -0700, Paul E. McKenney wrote:
> > > I suppose RCU could take the dueling-banjos approach and use increasingly
> > > aggressive scheduler policies itself, up to and including SCHED_DEADLINE,
> > > until it started getting decent forward progress.  However, that
> > > sounds like the something that just might have unintended consequences,
> > > particularly if other kernel subsystems were to also play similar
> > > games of dueling banjos.
> > 
> > So long as the RCU threads are well-behaved, using SCHED_DEADLINE
> > shouldn't have much of an impact on the system --- and the scheduling
> > parameters that you can specify on SCHED_DEADLINE allows you to
> > specify the worst-case impact on the system while also guaranteeing
> > that the SCHED_DEADLINE tasks will urn in the first place.  After all,
> > that's the whole point of SCHED_DEADLINE.
> > 
> > So I wonder if the right approach is during the the first userspace
> > system call to shced_setattr to enable a (any) real-time priority
> > scheduler (SCHED_DEADLINE, SCHED_FIFO or SCHED_RR) on a userspace
> > thread, before that's allowed to proceed, the RCU kernel threads are
> > promoted to be SCHED_DEADLINE with appropriately set deadline
> > parameters.  That way, a root user won't be able to shoot the system
> > in the foot, and since the vast majority of the time, there shouldn't
> > be any processes running with real-time priorities, we won't be
> > changing the behavior of a normal server system.
> 
> It might well be.  However, running the RCU kthreads at real-time
> priority does not come for free.  For example, it tends to crank up the
> context-switch rate.
> 
> Plus I have taken several runs at computing SCHED_DEADLINE parameters,
> but things like the rcuo callback-offload threads have computational
> requirements that are controlled not by RCU, and not just by the rest of
> the kernel, but also by userspace (keeping in mind the example of opening
> and closing a file in a tight loop, each pass of which queues a callback).
> I suspect that RCU is not the only kernel subsystem whose computational
> requirements are set not by the subsystem, but rather by external code.
> 
> OK, OK, I suppose I could just set insanely large SCHED_DEADLINE
> parameters, following syzkaller's example, and then trust my ability to
> keep the RCU code from abusing the resulting awesome power.  But wouldn't
> a much nicer approach be to put SCHED_DEADLINE between SCHED_RR/SCHED_FIFO
> priorities 98 and 99 or some such?  Then the same (admittedly somewhat
> scary) result could be obtained much more simply via SCHED_FIFO or
> SCHED_RR priority 99.
> 
> Some might argue that this is one of those situations where simplicity
> is not necessarily an advantage, but then again, you can find someone
> who will complain about almost anything.  ;-)
> 
> > (I suspect there might be some audio applications that might try to
> > set real-time priorities, but for desktop systems, it's probably more
> > important that the system not tie its self into knots since the
> > average desktop user isn't going to be well equipped to debug the
> > problem.)
> 
> Not only that, but if core counts continue to increase, and if reliance
> on cloud computing continues to grow, there are going to be an increasing
> variety of mixed workloads in increasingly less-controlled environments.
> 
> So, yes, it would be good to solve this problem in some reasonable way.
> 
> I don't see this as urgent just yet, but I am sure you all will let
> me know if I am mistaken on that point.
> 
> > > Alternatively, is it possible to provide stricter admission control?
> > 
> > I think that's an orthogonal issue; better admission control would be
> > nice, but it looks to me that it's going to be fundamentally an issue
> > of tweaking hueristics, and a fool-proof solution that will protect
> > against all malicious userspace applications (including syzkaller) is
> > going to require solving the halting problem.  So while it would be
> > nice to improve the admission control, I don't think that's a going to
> > be a general solution.
> 
> Agreed, and my earlier point about the need to trust the coding abilities
> of those writing ultimate-priority code is all too consistent with your
> point about needing to solve the halting problem.  Nevertheless,  I believe
> that we could make something that worked reasonably well in practice.
> 
> Here are a few components of a possible solution, in practice, but
> of course not in theory:
> 
> 1.	We set limits to SCHED_DEADLINE parameters, perhaps novel ones.
> 	For one example, insist on (say) 10 milliseconds of idle time
> 	every second on each CPU.  Yes, you can configure beyond that
> 	given sufficient permissions, but if you do so, you just voided
> 	your warranty.
> 
> 2.	Only allow SCHED_DEADLINE on nohz_full CPUs.  (Partial solution,
> 	given that such a CPU might be running in the kernel or have
> 	more than one runnable task.  Just for fun, I will suggest the
> 	option of disabling SCHED_DEADLINE during such times.)
> 
> 3.	RCU detects slowdowns, and does something TBD to increase its
> 	priority, but only while the slowdown persists.  This likely
> 	relies on scheduling-clock interrupts to detect the slowdowns,
> 	so there might be additional challenges on a fully nohz_full
> 	system.

4.	SCHED_DEADLINE treats the other three scheduling classes as each
	having a period, deadline, and a modest CPU consumption budget
	for the members of the class in aggregate.  But this has to have
	been discussed before.  How did that go?

> 5.	Your idea here.

							Thanx, Paul

