Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 187CA67F6C
	for <lists+netdev@lfdr.de>; Sun, 14 Jul 2019 16:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728476AbfGNOsP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jul 2019 10:48:15 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:41768 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728346AbfGNOsP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Jul 2019 10:48:15 -0400
Received: by mail-ed1-f67.google.com with SMTP id p15so13063350eds.8
        for <netdev@vger.kernel.org>; Sun, 14 Jul 2019 07:48:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hy169g8Lox0WjwNa4b+zp9/64BOx2Hykf6MoysyzbyM=;
        b=qDfJqkhv+PeM8i4Vhi7D1ipptr7S663xKsAmSBA2CKg+Umsac68Z3LKvOc1LthziJt
         uac1l65OCcZ/uWWwlX9T1JniSL3EiC06GffOb+e3uoOYGnBoxgoiFzRCeUWwSAv2Yvnf
         SYQEmCuGl2CenAC532BSRLxUEFwpatlHTBg59D9oAeN/Xm5pAwlimQ4/7kZ2qxBEhBLZ
         nW8poMpnV5QeFH4z5bPprqef+T4CBVanBUrmXIT2Od34P3knxOpdjOQwHBoXvicz1rLu
         oSgQoEaKpLEyD6k0b2iLzQSpUlgto57fqDJ/BmOOq89dWz1swDNTFhlzqr1XI/SNso42
         A/Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hy169g8Lox0WjwNa4b+zp9/64BOx2Hykf6MoysyzbyM=;
        b=PmCWnUbkdpBCvRqZFG9T/rf4PwJXM+WLcoUJRfMOdBJPqRDrrE1tl3pioxhaTOVUu4
         rqXWBdOsH7iFLQNuGbXN5x0hfLMXt6wYJDWMsXCqlLNoM/k19pbO3F9YgHSJF1Kwhnz7
         PN28lxwC7ZMn9fCq3/KE5CPrbg/LOrQ0y5M1av98C8hKdk69jyKJtFS8lmn2UcH+GynM
         yQikyF8qU7IrQcbTIyMmjNRDVJXs4UtfufwsgM53XkbatHJwoL6sMmY6L66zInyL/lsR
         2rGcwPPySbT/pdR84AQRDsnLXCsqKE8KXftADeSJtMvrFvIEXCr9qV39n/9LBeARI3Oo
         kaNQ==
X-Gm-Message-State: APjAAAWFCpzdhKhSaQ6QOE7A9Prr3RXZdlaq1qcCHXTzKotsonGGSAkr
        9lDIqTy5+/4BQKW9ayVCcszoXnskJfQb2Q8nkmO2BA==
X-Google-Smtp-Source: APXvYqwu8FY6LIl+s3s47q2KUxAhOGJHQqSYTQTDa938MOOpf93YR+WR/jyjgM1fffyG1L7qU0vEITvwu0QhD5js5qc=
X-Received: by 2002:a17:906:644c:: with SMTP id l12mr15866907ejn.142.1563115692435;
 Sun, 14 Jul 2019 07:48:12 -0700 (PDT)
MIME-Version: 1.0
References: <20190626210351.GF3116@mit.edu> <20190626224709.GH3116@mit.edu>
 <CACT4Y+YTpUErjEmjrqki-tJ0Lyx0c53MQDGVS4CixfmcAnuY=A@mail.gmail.com>
 <20190705151658.GP26519@linux.ibm.com> <CACT4Y+aNLHrYj1pYbkXO7CKESLeB-5enkSDK7ksgkMA3KtwJ+w@mail.gmail.com>
 <20190705191055.GT26519@linux.ibm.com> <20190706042801.GD11665@mit.edu>
 <20190706061631.GV26519@linux.ibm.com> <20190706150226.GG11665@mit.edu>
 <20190706180311.GW26519@linux.ibm.com> <20190707011655.GA22081@linux.ibm.com>
In-Reply-To: <20190707011655.GA22081@linux.ibm.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Sun, 14 Jul 2019 17:48:00 +0300
Message-ID: <CACT4Y+asYe-uH9OV5R0Nkb-JKP4erYUZ68S9gYNnGg6v+fD20w@mail.gmail.com>
Subject: Re: INFO: rcu detected stall in ext4_write_checks
To:     "Paul E. McKenney" <paulmck@linux.ibm.com>
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
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 7, 2019 at 4:17 AM Paul E. McKenney <paulmck@linux.ibm.com> wrote:
> > > > I suppose RCU could take the dueling-banjos approach and use increasingly
> > > > aggressive scheduler policies itself, up to and including SCHED_DEADLINE,
> > > > until it started getting decent forward progress.  However, that
> > > > sounds like the something that just might have unintended consequences,
> > > > particularly if other kernel subsystems were to also play similar
> > > > games of dueling banjos.
> > >
> > > So long as the RCU threads are well-behaved, using SCHED_DEADLINE
> > > shouldn't have much of an impact on the system --- and the scheduling
> > > parameters that you can specify on SCHED_DEADLINE allows you to
> > > specify the worst-case impact on the system while also guaranteeing
> > > that the SCHED_DEADLINE tasks will urn in the first place.  After all,
> > > that's the whole point of SCHED_DEADLINE.
> > >
> > > So I wonder if the right approach is during the the first userspace
> > > system call to shced_setattr to enable a (any) real-time priority
> > > scheduler (SCHED_DEADLINE, SCHED_FIFO or SCHED_RR) on a userspace
> > > thread, before that's allowed to proceed, the RCU kernel threads are
> > > promoted to be SCHED_DEADLINE with appropriately set deadline
> > > parameters.  That way, a root user won't be able to shoot the system
> > > in the foot, and since the vast majority of the time, there shouldn't
> > > be any processes running with real-time priorities, we won't be
> > > changing the behavior of a normal server system.
> >
> > It might well be.  However, running the RCU kthreads at real-time
> > priority does not come for free.  For example, it tends to crank up the
> > context-switch rate.
> >
> > Plus I have taken several runs at computing SCHED_DEADLINE parameters,
> > but things like the rcuo callback-offload threads have computational
> > requirements that are controlled not by RCU, and not just by the rest of
> > the kernel, but also by userspace (keeping in mind the example of opening
> > and closing a file in a tight loop, each pass of which queues a callback).
> > I suspect that RCU is not the only kernel subsystem whose computational
> > requirements are set not by the subsystem, but rather by external code.
> >
> > OK, OK, I suppose I could just set insanely large SCHED_DEADLINE
> > parameters, following syzkaller's example, and then trust my ability to
> > keep the RCU code from abusing the resulting awesome power.  But wouldn't
> > a much nicer approach be to put SCHED_DEADLINE between SCHED_RR/SCHED_FIFO
> > priorities 98 and 99 or some such?  Then the same (admittedly somewhat
> > scary) result could be obtained much more simply via SCHED_FIFO or
> > SCHED_RR priority 99.
> >
> > Some might argue that this is one of those situations where simplicity
> > is not necessarily an advantage, but then again, you can find someone
> > who will complain about almost anything.  ;-)
> >
> > > (I suspect there might be some audio applications that might try to
> > > set real-time priorities, but for desktop systems, it's probably more
> > > important that the system not tie its self into knots since the
> > > average desktop user isn't going to be well equipped to debug the
> > > problem.)
> >
> > Not only that, but if core counts continue to increase, and if reliance
> > on cloud computing continues to grow, there are going to be an increasing
> > variety of mixed workloads in increasingly less-controlled environments.
> >
> > So, yes, it would be good to solve this problem in some reasonable way.
> >
> > I don't see this as urgent just yet, but I am sure you all will let
> > me know if I am mistaken on that point.
> >
> > > > Alternatively, is it possible to provide stricter admission control?
> > >
> > > I think that's an orthogonal issue; better admission control would be
> > > nice, but it looks to me that it's going to be fundamentally an issue
> > > of tweaking hueristics, and a fool-proof solution that will protect
> > > against all malicious userspace applications (including syzkaller) is
> > > going to require solving the halting problem.  So while it would be
> > > nice to improve the admission control, I don't think that's a going to
> > > be a general solution.
> >
> > Agreed, and my earlier point about the need to trust the coding abilities
> > of those writing ultimate-priority code is all too consistent with your
> > point about needing to solve the halting problem.  Nevertheless,  I believe
> > that we could make something that worked reasonably well in practice.
> >
> > Here are a few components of a possible solution, in practice, but
> > of course not in theory:
> >
> > 1.    We set limits to SCHED_DEADLINE parameters, perhaps novel ones.
> >       For one example, insist on (say) 10 milliseconds of idle time
> >       every second on each CPU.  Yes, you can configure beyond that
> >       given sufficient permissions, but if you do so, you just voided
> >       your warranty.
> >
> > 2.    Only allow SCHED_DEADLINE on nohz_full CPUs.  (Partial solution,
> >       given that such a CPU might be running in the kernel or have
> >       more than one runnable task.  Just for fun, I will suggest the
> >       option of disabling SCHED_DEADLINE during such times.)
> >
> > 3.    RCU detects slowdowns, and does something TBD to increase its
> >       priority, but only while the slowdown persists.  This likely
> >       relies on scheduling-clock interrupts to detect the slowdowns,
> >       so there might be additional challenges on a fully nohz_full
> >       system.
>
> 4.      SCHED_DEADLINE treats the other three scheduling classes as each
>         having a period, deadline, and a modest CPU consumption budget
>         for the members of the class in aggregate.  But this has to have
>         been discussed before.  How did that go?
>
> > 5.    Your idea here.

Trying to digest this thread.

Do I understand correctly that setting rcutree.kthread_prio=99 won't
help because the deadline priority is higher?
And there are no other existing mechanisms to either fix the stalls
nor make kernel reject the non well-behaving parameters? Kernel tries
to filter out non well-behaving parameters, but the check detects only
obvious misconfigurations, right?
This reminds of priority inversion/inheritance problem. I wonder if
there are other kernel subsystems that suffer from the same problem.
E.g. the background kernel thread that destroys net namespaces and any
other type of async work. A high prio user process can overload the
queue and make kernel eat all memory. May be relatively easy to do
even unintentionally. I suspect the problem is not specific to rcu and
plumbing just rcu may just make the next problem pop up.
Should user be able to starve basic kernel services? User should be
able to prioritize across user processes (potentially in radical
ways), but perhaps it should not be able to badly starve kernel
functions that just happened to be asynchronous? I guess it's not as
simple as setting the highest prio for all kernel threads because in
normal case we want to reduce latency of user work by making the work
async. But user must not be able to starve kernel threads
infinitely... sounds like something similar to the deadline scheduling
-- kernel threads need to get at least some time slice per unit of
time.

But short term I don't see any other solution than stop testing
sched_setattr because it does not check arguments enough to prevent
system misbehavior. Which is a pity because syzkaller has found some
bad misconfigurations that were oversight on checking side.
Any other suggestions?
