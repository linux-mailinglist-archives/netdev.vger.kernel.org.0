Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FA1D68E11
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 16:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387642AbfGOOC1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 10:02:27 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:24608 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1733199AbfGOOC0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 10:02:26 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6FDvNuJ116908
        for <netdev@vger.kernel.org>; Mon, 15 Jul 2019 10:02:24 -0400
Received: from e16.ny.us.ibm.com (e16.ny.us.ibm.com [129.33.205.206])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2trrp3fa7t-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 15 Jul 2019 10:02:17 -0400
Received: from localhost
        by e16.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <paulmck@linux.vnet.ibm.com>;
        Mon, 15 Jul 2019 15:02:16 +0100
Received: from b01cxnp22033.gho.pok.ibm.com (9.57.198.23)
        by e16.ny.us.ibm.com (146.89.104.203) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 15 Jul 2019 15:02:10 +0100
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6FE29an44237218
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Jul 2019 14:02:09 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B3D36B2068;
        Mon, 15 Jul 2019 14:02:09 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 731A9B205F;
        Mon, 15 Jul 2019 14:02:09 +0000 (GMT)
Received: from paulmck-ThinkPad-W541 (unknown [9.85.164.210])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 15 Jul 2019 14:02:09 +0000 (GMT)
Received: by paulmck-ThinkPad-W541 (Postfix, from userid 1000)
        id 2038916C8E9B; Mon, 15 Jul 2019 07:02:09 -0700 (PDT)
Date:   Mon, 15 Jul 2019 07:02:09 -0700
From:   "Paul E. McKenney" <paulmck@linux.ibm.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Dmitry Vyukov <dvyukov@google.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
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
        Ingo Molnar <mingo@kernel.org>
Subject: Re: INFO: rcu detected stall in ext4_write_checks
Reply-To: paulmck@linux.ibm.com
References: <20190706042801.GD11665@mit.edu>
 <20190706061631.GV26519@linux.ibm.com>
 <20190706150226.GG11665@mit.edu>
 <20190706180311.GW26519@linux.ibm.com>
 <20190707011655.GA22081@linux.ibm.com>
 <CACT4Y+asYe-uH9OV5R0Nkb-JKP4erYUZ68S9gYNnGg6v+fD20w@mail.gmail.com>
 <20190714184915.GK26519@linux.ibm.com>
 <20190715132911.GG3419@hirez.programming.kicks-ass.net>
 <CACT4Y+bmgdOExBHnLJ+jgWKWQzNK9CFT6_eTxFE3hoK=0YresQ@mail.gmail.com>
 <20190715134651.GI3419@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190715134651.GI3419@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
x-cbid: 19071514-0072-0000-0000-000004491B87
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011432; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01232545; UDB=6.00649376; IPR=6.01013847;
 MB=3.00027725; MTD=3.00000008; XFM=3.00000015; UTC=2019-07-15 14:02:14
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19071514-0073-0000-0000-00004CB964A3
Message-Id: <20190715140209.GQ26519@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-15_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907150167
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 15, 2019 at 03:46:51PM +0200, Peter Zijlstra wrote:
> On Mon, Jul 15, 2019 at 03:33:11PM +0200, Dmitry Vyukov wrote:
> > On Mon, Jul 15, 2019 at 3:29 PM Peter Zijlstra <peterz@infradead.org> wrote:
> > >
> > > On Sun, Jul 14, 2019 at 11:49:15AM -0700, Paul E. McKenney wrote:
> > > > On Sun, Jul 14, 2019 at 05:48:00PM +0300, Dmitry Vyukov wrote:
> > > > > But short term I don't see any other solution than stop testing
> > > > > sched_setattr because it does not check arguments enough to prevent
> > > > > system misbehavior. Which is a pity because syzkaller has found some
> > > > > bad misconfigurations that were oversight on checking side.
> > > > > Any other suggestions?
> > > >
> > > > Keep the times down to a few seconds?  Of course, that might also
> > > > fail to find interesting bugs.
> > >
> > > Right, if syzcaller can put a limit on the period/deadline parameters
> > > (and make sure to not write "-1" to
> > > /proc/sys/kernel/sched_rt_runtime_us) then per the in-kernel
> > > access-control should not allow these things to happen.
> > 
> > Since we are racing with emails, could you suggest a 100% safe
> > parameters? Because I only hear people saying "safe", "sane",
> > "well-behaving" :)
> > If we move the check to user-space, it does not mean that we can get
> > away without actually defining what that means.
> 
> Right, well, that's part of the problem. I think Paul just did the
> reverse math and figured that 95% of X must not be larger than my
> watchdog timeout and landed on 14 seconds.

I was actually working backwards from thw 21-second RCU CPU stall
timeout, but there are likely many other limits to consider.

> I'm thinking 4 seconds (or rather 4.294967296) would be a very nice
> number.

Works for me!  That should give the various RCU kthreads ample
opportunities to execute within the RCU CPU stall timeout.

The rcuo callback-offload kthreads will need special handling, but if
someone has 100 CPUs wildly generating callbacks and allocates but one
CPU to invoke them, there is not much either the RCU or the scheduler
can do to make that work.  ;-)

							Thanx, Paul

> > Now thinking of this, if we come up with some simple criteria, could
> > we have something like a sysctl that would allow only really "safe"
> > parameters?
> 
> I suppose we could do that, something like:
> sysctl_deadline_period_{min,max}. I'll have to dig back a bit on where
> we last talked about that and what the problems where.
> 
> For one, setting the min is a lot harder, but I suppose we can start at
> TICK_NSEC or something.

