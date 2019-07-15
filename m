Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D0C468A8F
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 15:29:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730304AbfGON3q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 09:29:46 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:39731 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730305AbfGON3q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 09:29:46 -0400
Received: by mail-ed1-f65.google.com with SMTP id m10so15500946edv.6
        for <netdev@vger.kernel.org>; Mon, 15 Jul 2019 06:29:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=buEajWT+1jShDNDDmzeUQAsrsLgoZdl26EuhBKfYvFE=;
        b=iNcr3acwzMK3mLhrxGk1qUFsSrDtBLyupcgnAlBPohC0nsi7ACiN8sFs1iTJVaX2DH
         VxFisn1RpjdV3FmrKCEbxicEjmpSygdOipN+nqNNCKWQ/j/AGApD1oS8ZA8IJLOcFfmx
         TIpBaqceY5PIx/64QJ6Owkv3Hz+2B6o2QbXzGgyzrLxRmi+PO8HY3/Rd6lgHODIAJ1tw
         StjJRkBxaU0ojMK1oXy9RCmy0FG4tHH6fXF3m267W7am4dv0/xuIvKlObGUJLYWQg5dz
         tpQjh/Ew7CPhEjUH6VMhY4Iygc2XITJ6Sj2zuD5wKe5ldvt9cmVu3QExE4zHxK25Bm6E
         YC2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=buEajWT+1jShDNDDmzeUQAsrsLgoZdl26EuhBKfYvFE=;
        b=Oo5C02w48jxyyTeRMnnbW5f7dYaUggEyYWIOsXA1sirskc0bBxnII9K8MxTj5FwmMq
         uGFr7q95aFWE9CPaMI4EdCQBqYNU5hzn2/c2iDWH8Kge0SioycMzfoC4N0DAD66PcfJu
         Vuv4DPdiV9b5pef9W97Q1FSFA34iY1y/02UwM2Ew8TVYdkCt9hLr0LPH7XjknryTQHlv
         ToCOU6oNzJ238zMC6f7Eo+PjC7lJZnYpDQQ5dRXWimlbVQZfknKHAVUbUdtGIoK8JaQG
         9FqhKCjOlFGHYxP4hDsa4szOpXWLbSAOrGZRHAvsf3fqDKLTPStdWR94/a1kQLl3gP/h
         +1OQ==
X-Gm-Message-State: APjAAAXDxkclr4NAsvI2Bm8XIBqsert0nnpPT6gTpfm4CJTQFxOKx5Gz
        F8APS6pSZXVEwK1Dsg8VABxv6tudetVf0drZkiu3qw==
X-Google-Smtp-Source: APXvYqzek7Bo7XArBcfNuU44O8huZixFfM9kpJqCJ0dmWGvcOZnT2Xq+F2035UMbwuIKGwL2GLJ4HryDPsyzZYY4b1M=
X-Received: by 2002:a17:906:644c:: with SMTP id l12mr19807605ejn.142.1563197383529;
 Mon, 15 Jul 2019 06:29:43 -0700 (PDT)
MIME-Version: 1.0
References: <20190705191055.GT26519@linux.ibm.com> <20190706042801.GD11665@mit.edu>
 <20190706061631.GV26519@linux.ibm.com> <20190706150226.GG11665@mit.edu>
 <20190706180311.GW26519@linux.ibm.com> <20190707011655.GA22081@linux.ibm.com>
 <CACT4Y+asYe-uH9OV5R0Nkb-JKP4erYUZ68S9gYNnGg6v+fD20w@mail.gmail.com>
 <20190714190522.GA24049@mit.edu> <20190714192951.GM26519@linux.ibm.com>
 <20190715031027.GA3336@linux.ibm.com> <20190715130101.GA5527@linux.ibm.com>
In-Reply-To: <20190715130101.GA5527@linux.ibm.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Mon, 15 Jul 2019 15:29:31 +0200
Message-ID: <CACT4Y+ZXKyB-ApBzitHiYuuQRS5hPqZS0BM2SosYQqea8Xevdg@mail.gmail.com>
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

On Mon, Jul 15, 2019 at 3:01 PM Paul E. McKenney <paulmck@linux.ibm.com> wrote:
>
> On Sun, Jul 14, 2019 at 08:10:27PM -0700, Paul E. McKenney wrote:
> > On Sun, Jul 14, 2019 at 12:29:51PM -0700, Paul E. McKenney wrote:
> > > On Sun, Jul 14, 2019 at 03:05:22PM -0400, Theodore Ts'o wrote:
> > > > On Sun, Jul 14, 2019 at 05:48:00PM +0300, Dmitry Vyukov wrote:
> > > > > But short term I don't see any other solution than stop testing
> > > > > sched_setattr because it does not check arguments enough to prevent
> > > > > system misbehavior. Which is a pity because syzkaller has found some
> > > > > bad misconfigurations that were oversight on checking side.
> > > > > Any other suggestions?
> > > >
> > > > Or maybe syzkaller can put its own limitations on what parameters are
> > > > sent to sched_setattr?  In practice, there are any number of ways a
> > > > root user can shoot themselves in the foot when using sched_setattr or
> > > > sched_setaffinity, for that matter.  I imagine there must be some such
> > > > constraints already --- or else syzkaller might have set a kernel
> > > > thread to run with priority SCHED_BATCH, with similar catastrophic
> > > > effects --- or do similar configurations to make system threads
> > > > completely unschedulable.
> > > >
> > > > Real time administrators who know what they are doing --- and who know
> > > > that their real-time threads are well behaved --- will always want to
> > > > be able to do things that will be catastrophic if the real-time thread
> > > > is *not* well behaved.  I don't it is possible to add safety checks
> > > > which would allow the kernel to automatically detect and reject unsafe
> > > > configurations.
> > > >
> > > > An apt analogy might be civilian versus military aircraft.  Most
> > > > airplanes are designed to be "inherently stable"; that way, modulo
> > > > buggy/insane control systems like on the 737 Max, the airplane will
> > > > automatically return to straight and level flight.  On the other hand,
> > > > some military planes (for example, the F-16, F-22, F-36, the
> > > > Eurofighter, etc.) are sometimes designed to be unstable, since that
> > > > way they can be more maneuverable.
> > > >
> > > > There are use cases for real-time Linux where this flexibility/power
> > > > vs. stability tradeoff is going to argue for giving root the
> > > > flexibility to crash the system.  Some of these systems might
> > > > literally involve using real-time Linux in military applications,
> > > > something for which Paul and I have had some experience.  :-)
> > > >
> > > > Speaking of sched_setaffinity, one thing which we can do is have
> > > > syzkaller move all of the system threads to they run on the "system
> > > > CPU's", and then move the syzkaller processes which are testing the
> > > > kernel to be on the "system under test CPU's".  Then regardless of
> > > > what priority the syzkaller test programs try to run themselves at,
> > > > they can't crash the system.
> > > >
> > > > Some real-time systems do actually run this way, and it's a
> > > > recommended configuration which is much safer than letting the
> > > > real-time threads take over the whole system:
> > > >
> > > > http://linuxrealtime.org/index.php/Improving_the_Real-Time_Properties#Isolating_the_Application
> > >
> > > Good point!  We might still have issues with some per-CPU kthreads,
> > > but perhaps use of nohz_full would help at least reduce these sorts
> > > of problems.  (There could still be issues on CPUs with more than
> > > one runnable threads.)
> >
> > I looked at testing limitations in a bit more detail from an RCU
> > viewpoint, and came up with the following rough rule of thumb (which of
> > course might or might not survive actual testing experience, but should at
> > least be a good place to start).  I believe that the sched_setaffinity()
> > testing rule should be that the SCHED_DEADLINE cycle be no more than
> > two-thirds of the RCU CPU stall warning timeout, which defaults to 21
> > seconds in mainline and 60 seconds in many distro kernels.
> >
> > That is, the SCHED_DEADLINE cycle should never exceed 14 seconds when
> > testing mainline on the one hand or 40 seconds when testing enterprise
> > distros on the other.
> >
> > This assumes quite a bit, though:
> >
> > o     The system has ample memory to spare, and isn't running a
> >       callback-hungry workload.  For example, if you "only" have 100MB
> >       of spare memory and you are also repeatedly and concurrently
> >       expanding (say) large source trees from tarballs and then deleting
> >       those source trees, the system might OOM.  The reason OOM might
> >       happen is that each close() of a file generates an RCU callback,
> >       and 40 seconds worth of waiting-for-a-grace-period structures
> >       takes up a surprisingly large amount of memory.
> >
> >       So please be careful when combining tests.  ;-)
> >
> > o     There are no aggressive real-time workloads on the system.
> >       The reason for this is that RCU is going to start sending IPIs
> >       halfway to the RCU CPU stall timeout, and, in certain situations
> >       on CONFIG_NO_HZ_FULL kernels, much earlier.  (These situations
> >       constitute abuse of CONFIG_NO_HZ_FULL, but then again carefully
> >       calibrated abuse is what stress testing is all about.)
> >
> > o     The various RCU kthreads will get a chance to run at least once
> >       during the SCHED_DEADLINE cycle.  If in real life, they only
> >       get a chance to run once per two SCHED_DEADLINE cycles, then of
> >       course the 14 seconds becomes 7 and the 40 seconds becomes 20.
>
> And there are configurations and workloads that might require division
> by three, so that (assuming one chance to run per cycle), the 14 seconds
> becomes about 5 and the 40 seconds becomes about 15.
>
> > o     The current RCU CPU stall warning defaults remain in
> >       place.  These are set by the CONFIG_RCU_CPU_STALL_TIMEOUT
> >       Kconfig parameter, which may in turn be overridden by the
> >       rcupdate.rcu_cpu_stall_timeout kernel boot parameter.
> >
> > o     The current SCHED_DEADLINE default for providing spare cycles
> >       for other uses remains in place.
> >
> > o     Other kthreads might have other constraints, but given that you
> >       were seeing RCU CPU stall warnings instead of other failures,
> >       the needs of RCU's kthreads seem to be a good place to start.
> >
> > Again, the candidate rough rule of thumb is that the the SCHED_DEADLINE
> > cycle be no more than 14 seconds when testing mainline kernels on the one
> > hand and 40 seconds when testing enterprise distro kernels on the other.
> >
> > Dmitry, does that help?
>
> I checked with the people running the Linux Plumbers Conference Scheduler
> Microconference, and they said that they would welcome a proposal on
> this topic, which I have submitted (please see below).  Would anyone
> like to join as co-conspirator?
>
>                                                         Thanx, Paul
>
> ------------------------------------------------------------------------
>
> Title: Making SCHED_DEADLINE safe for kernel kthreads
>
> Abstract:
>
> Dmitry Vyukov's testing work identified some (ab)uses of sched_setattr()
> that can result in SCHED_DEADLINE tasks starving RCU's kthreads for
> extended time periods, not millisecond, not seconds, not minutes, not even
> hours, but days. Given that RCU CPU stall warnings are issued whenever
> an RCU grace period fails to complete within a few tens of seconds,
> the system did not suffer silently. Although one could argue that people
> should avoid abusing sched_setattr(), people are human and humans make
> mistakes. Responding to simple mistakes with RCU CPU stall warnings is
> all well and good, but a more severe case could OOM the system, which
> is a particularly unhelpful error message.
>
> It would be better if the system were capable of operating reasonably
> despite such abuse. Several approaches have been suggested.
>
> First, sched_setattr() could recognize parameter settings that put
> kthreads at risk and refuse to honor those settings. This approach
> of course requires that we identify precisely what combinations of
> sched_setattr() parameters settings are risky, especially given that there
> are likely to be parameter settings that are both risky and highly useful.
>
> Second, in theory, RCU could detect this situation and take the "dueling
> banjos" approach of increasing its priority as needed to get the CPU time
> that its kthreads need to operate correctly. However, the required amount
> of CPU time can vary greatly depending on the workload. Furthermore,
> non-RCU kthreads also need some amount of CPU time, and replicating
> "dueling banjos" across all such Linux-kernel subsystems seems both
> wasteful and error-prone. Finally, experience has shown that setting
> RCU's kthreads to real-time priorities significantly harms performance
> by increasing context-switch rates.
>
> Third, stress testing could be limited to non-risky regimes, such that
> kthreads get CPU time every 5-40 seconds, depending on configuration
> and experience. People needing risky parameter settings could then test
> the settings that they actually need, and also take responsibility for
> ensuring that kthreads get the CPU time that they need. (This of course
> includes per-CPU kthreads!)
>
> Fourth, bandwidth throttling could treat tasks in other scheduling classes
> as an aggregate group having a reasonable aggregate deadline and CPU
> budget. This has the advantage of allowing "abusive" testing to proceed,
> which allows people requiring risky parameter settings to rely on this
> testing. Additionally, it avoids complex progress checking and priority
> setting on the part of many kthreads throughout the system. However,
> if this was an easy choice, the SCHED_DEADLINE developers would likely
> have selected it. For example, it is necessary to determine what might
> be a "reasonable" aggregate deadline and CPU budget. Reserving 5%
> seems quite generous, and RCU's grace-period kthread would optimally
> like a deadline in the milliseconds, but would do reasonably well with
> many tens of milliseconds, and absolutely needs a few seconds. However,
> for CONFIG_RCU_NOCB_CPU=y, the RCU's callback-offload kthreads might
> well need a full CPU each! (This happens when the CPU being offloaded
> generates a high rate of callbacks.)
>
> The goal of this proposal is therefore to generate face-to-face
> discussion, hopefully resulting in a good and sufficient solution to
> this problem.


I would be happy to attend if this won't conflict with important
things on the testing and fuzzing MC.

If we restrict arguments for sched_attr, what would be the criteria
for 100% safe arguments? Moving the check from kernel to user-space
does not relief us from explicitly stating the condition in
black-and-white way. All of sched_runtime/sched_deadline/sched_period
be not larger than 1 second?

The problem is that syzkaller does not allow 100% reliable enforcement
for indirect arguments in memory. E.g. inputs arguments can overlap,
input/output can overlap, weird races affect what's actually being
passed to kernel, the memory being mapped from a weird device, etc.
And that's also useful as it can discover TOCTOU bugs, deadlocks, etc.
We could try to wrap sched_setattr and do some additional restrictions
by giving up on TOCTOU, device-mapped memory, etc.

I am also thinking about dropping CAP_SYS_NICE, it should still allow
some configurations, but no inherently unsafe ones.
