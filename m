Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C37060F39
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 08:17:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726164AbfGFGRC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jul 2019 02:17:02 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:46210 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725973AbfGFGRB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jul 2019 02:17:01 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x66690oq022216;
        Sat, 6 Jul 2019 02:16:33 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2tjnsngkuv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 06 Jul 2019 02:16:33 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x66694lV022634;
        Sat, 6 Jul 2019 02:16:32 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2tjnsngkuq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 06 Jul 2019 02:16:32 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x6664SRP027778;
        Sat, 6 Jul 2019 06:16:32 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma01wdc.us.ibm.com with ESMTP id 2tjk95rtv1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 06 Jul 2019 06:16:32 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x666GVZt42795392
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 6 Jul 2019 06:16:31 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B09C1B205F;
        Sat,  6 Jul 2019 06:16:31 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7A76DB2065;
        Sat,  6 Jul 2019 06:16:31 +0000 (GMT)
Received: from paulmck-ThinkPad-W541 (unknown [9.80.215.71])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Sat,  6 Jul 2019 06:16:31 +0000 (GMT)
Received: by paulmck-ThinkPad-W541 (Postfix, from userid 1000)
        id 49D5216C6AC7; Fri,  5 Jul 2019 23:16:31 -0700 (PDT)
Date:   Fri, 5 Jul 2019 23:16:31 -0700
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
Message-ID: <20190706061631.GV26519@linux.ibm.com>
Reply-To: paulmck@linux.ibm.com
References: <000000000000d3f34b058c3d5a4f@google.com>
 <20190626184251.GE3116@mit.edu>
 <20190626210351.GF3116@mit.edu>
 <20190626224709.GH3116@mit.edu>
 <CACT4Y+YTpUErjEmjrqki-tJ0Lyx0c53MQDGVS4CixfmcAnuY=A@mail.gmail.com>
 <20190705151658.GP26519@linux.ibm.com>
 <CACT4Y+aNLHrYj1pYbkXO7CKESLeB-5enkSDK7ksgkMA3KtwJ+w@mail.gmail.com>
 <20190705191055.GT26519@linux.ibm.com>
 <20190706042801.GD11665@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190706042801.GD11665@mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-06_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907060080
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 06, 2019 at 12:28:01AM -0400, Theodore Ts'o wrote:
> On Fri, Jul 05, 2019 at 12:10:55PM -0700, Paul E. McKenney wrote:
> > 
> > Exactly, so although my patch might help for CONFIG_PREEMPT=n, it won't
> > help in your scenario.  But looking at the dmesg from your URL above,
> > I see the following:
> 
> I just tested with CONFIG_PREEMPT=n
> 
> % grep CONFIG_PREEMPT /build/ext4-64/.config
> CONFIG_PREEMPT_NONE=y
> # CONFIG_PREEMPT_VOLUNTARY is not set
> # CONFIG_PREEMPT is not set
> CONFIG_PREEMPT_COUNT=y
> CONFIG_PREEMPTIRQ_TRACEPOINTS=y
> # CONFIG_PREEMPTIRQ_EVENTS is not set
> 
> And with your patch, it's still not helping.
> 
> I think that's because SCHED_DEADLINE is a real-time style scheduler:
> 
>        In  order  to fulfill the guarantees that are made when a thread is ad‐
>        mitted to the SCHED_DEADLINE policy,  SCHED_DEADLINE  threads  are  the
>        highest  priority  (user  controllable)  threads  in the system; if any
>        SCHED_DEADLINE thread is runnable, it will preempt any thread scheduled
>        under one of the other policies.
> 
> So a SCHED_DEADLINE process is not going yield control of the CPU,
> even if it calls cond_resched() until the thread has run for more than
> the sched_runtime parameter --- which for the syzkaller repro, was set
> at 26 days.
> 
> There are some safety checks when using SCHED_DEADLINE:
> 
>        The kernel requires that:
> 
>            sched_runtime <= sched_deadline <= sched_period
> 
>        In  addition,  under  the  current implementation, all of the parameter
>        values must be at least 1024 (i.e., just over one microsecond, which is
>        the  resolution  of the implementation), and less than 2^63.  If any of
>        these checks fails, sched_setattr(2) fails with the error EINVAL.
> 
>        The  CBS  guarantees  non-interference  between  tasks,  by  throttling
>        threads that attempt to over-run their specified Runtime.
> 
>        To ensure deadline scheduling guarantees, the kernel must prevent situ‐
>        ations where the set of SCHED_DEADLINE threads is not feasible (schedu‐
>        lable)  within  the given constraints.  The kernel thus performs an ad‐
>        mittance test when setting or changing SCHED_DEADLINE  policy  and  at‐
>        tributes.   This admission test calculates whether the change is feasi‐
>        ble; if it is not, sched_setattr(2) fails with the error EBUSY.
> 
> The problem is that SCHED_DEADLINE is designed for sporadic tasks:
> 
>        A  sporadic  task is one that has a sequence of jobs, where each job is
>        activated at most once per period.  Each job also has a relative  dead‐
>        line,  before which it should finish execution, and a computation time,
>        which is the CPU time necessary for executing the job.  The moment when
>        a  task wakes up because a new job has to be executed is called the ar‐
>        rival time (also referred to as the request time or release time).  The
>        start time is the time at which a task starts its execution.  The abso‐
>        lute deadline is thus obtained by adding the relative deadline  to  the
>        arrival time.
> 
> It appears that kernel's admission control before allowing
> SCHED_DEADLINE to be set on a thread was designed for sane
> applications, and not abusive ones.  Given that process started doing
> abusive things *after* SCHED_DEADLINE policy was set, in order kernel
> to figure out that in fact SCHED_DEADLINE should be denied for any
> arbitrary kernel thread would require either (a) solving the halting
> problem, or (b) being able to anticipate the future (in which case,
> we should be using that kernel algorithm to play the stock market  :-)

26 days will definitely get you a large collection of RCU CPU stall
warnings!  Thank you for digging into this, Ted.

I suppose RCU could take the dueling-banjos approach and use increasingly
aggressive scheduler policies itself, up to and including SCHED_DEADLINE,
until it started getting decent forward progress.  However, that
sounds like the something that just might have unintended consequences,
particularly if other kernel subsystems were to also play similar
games of dueling banjos.

Alternatively, is it possible to provide stricter admission control?
For example, what sorts of policies do SCHED_DEADLINE users actually use?

							Thanx, Paul
