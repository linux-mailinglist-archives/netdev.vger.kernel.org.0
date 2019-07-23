Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B79271467
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 10:51:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731209AbfGWIvs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 04:51:48 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:46523 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730930AbfGWIvs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 04:51:48 -0400
Received: by mail-io1-f67.google.com with SMTP id i10so80087965iol.13
        for <netdev@vger.kernel.org>; Tue, 23 Jul 2019 01:51:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jKZWXKcNg9v61aofsNn7pfpi8sojhmIuCOYr5uBtJUg=;
        b=dDyLgy1taxrD1RQdm4eNI7DbTMaTOveTgtYMehR7CdFTrjX1XO8CA+xfe5ohyJWLAU
         Rd9xcdsur+HnbAR5rLAij2rlF6gI1u1tNFGHOMfORwdj6FzeAhrs6UZ0ADqtJgwjTAk7
         Bhe5YMDVH2LcpRqkd/rNORTEgRE/JInjfMSa5cdP+CICGc8uMu6WJucKRy0ZasUYJJGw
         EarEt3cYsqMAjoZtG9B9dZZRJ9lYANPRG64iWrYP+XUAs/PmSq/Ta2qGMIp1TZA7vHJE
         wF6It7t2maBptfOsCxFH/RviFu935z7HOih0Nx/LcFZaS2beai0xXul5BbGRJ0UAtT4h
         ZE3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jKZWXKcNg9v61aofsNn7pfpi8sojhmIuCOYr5uBtJUg=;
        b=sTqZN7Qq657TevpHkN0tDgtZocjwGPZOe6SOsdlB1rtJWzDYMbYROHQiZVnsizT8dr
         naKkvjP9PYHf6bz9j1Tzsy8/sVS6xEGu2McJyrLS7Pzk71ktjcRoinwZ07LqZhk7xZTp
         PvvEPvG3IddrLP/CPRLZ9X2USFB7+TuIvFXAhYvlmmbmsN0xSFXC1NHqZGeIcYkarC5A
         YcVQ+ePgdkmvBzr+n7IRtwjqi4Kj8m4bC7OHJhDqihiuD5pqNOUGn+aRwZbVcglSfAD4
         /gvMknxgVzW6Wa8KZJFAMbMDyjyBXL6V5hU6qugV+YC5eh88+tmtfJM67OA42oZw1YSW
         r7dA==
X-Gm-Message-State: APjAAAWse05nERto/bVKMfTLGtB9H9ZOylFL8tVi2QEIEHsueTy5ZwuB
        KGRewM/13D1QWeSxdvIOFZjrjd0YjwUomyJfjiJQ4g==
X-Google-Smtp-Source: APXvYqywWFoajhq50ncpggzq1ue+aVOnNrhhF9uTgVHieKTwX0+kkYCQEU7rQ44IVmTYd0uj3MNjIRxN3y6hiPzyrMI=
X-Received: by 2002:a5e:c241:: with SMTP id w1mr65555660iop.58.1563871907136;
 Tue, 23 Jul 2019 01:51:47 -0700 (PDT)
MIME-Version: 1.0
References: <20190705191055.GT26519@linux.ibm.com> <20190706042801.GD11665@mit.edu>
 <20190706061631.GV26519@linux.ibm.com> <20190706150226.GG11665@mit.edu>
 <20190706180311.GW26519@linux.ibm.com> <20190707011655.GA22081@linux.ibm.com>
 <CACT4Y+asYe-uH9OV5R0Nkb-JKP4erYUZ68S9gYNnGg6v+fD20w@mail.gmail.com>
 <20190714184915.GK26519@linux.ibm.com> <20190715132911.GG3419@hirez.programming.kicks-ass.net>
 <CACT4Y+bmgdOExBHnLJ+jgWKWQzNK9CFT6_eTxFE3hoK=0YresQ@mail.gmail.com>
 <20190715134651.GI3419@hirez.programming.kicks-ass.net> <CACT4Y+bGgyZWbRQ7QNCHRLU0Zq2+cONSbyaycfzwvToqMwiwBQ@mail.gmail.com>
In-Reply-To: <CACT4Y+bGgyZWbRQ7QNCHRLU0Zq2+cONSbyaycfzwvToqMwiwBQ@mail.gmail.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Tue, 23 Jul 2019 10:51:35 +0200
Message-ID: <CACT4Y+biWSJvia2rcS9-Q0-GCiaQ9U7Qq=vDA+MY2Gz5mbxTNA@mail.gmail.com>
Subject: Re: INFO: rcu detected stall in ext4_write_checks
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     "Paul E. McKenney" <paulmck@linux.ibm.com>,
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
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 22, 2019 at 12:03 PM Dmitry Vyukov <dvyukov@google.com> wrote:
>
> On Mon, Jul 15, 2019 at 3:46 PM Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > On Mon, Jul 15, 2019 at 03:33:11PM +0200, Dmitry Vyukov wrote:
> > > On Mon, Jul 15, 2019 at 3:29 PM Peter Zijlstra <peterz@infradead.org> wrote:
> > > >
> > > > On Sun, Jul 14, 2019 at 11:49:15AM -0700, Paul E. McKenney wrote:
> > > > > On Sun, Jul 14, 2019 at 05:48:00PM +0300, Dmitry Vyukov wrote:
> > > > > > But short term I don't see any other solution than stop testing
> > > > > > sched_setattr because it does not check arguments enough to prevent
> > > > > > system misbehavior. Which is a pity because syzkaller has found some
> > > > > > bad misconfigurations that were oversight on checking side.
> > > > > > Any other suggestions?
> > > > >
> > > > > Keep the times down to a few seconds?  Of course, that might also
> > > > > fail to find interesting bugs.
> > > >
> > > > Right, if syzcaller can put a limit on the period/deadline parameters
> > > > (and make sure to not write "-1" to
> > > > /proc/sys/kernel/sched_rt_runtime_us) then per the in-kernel
> > > > access-control should not allow these things to happen.
> > >
> > > Since we are racing with emails, could you suggest a 100% safe
> > > parameters? Because I only hear people saying "safe", "sane",
> > > "well-behaving" :)
> > > If we move the check to user-space, it does not mean that we can get
> > > away without actually defining what that means.
> >
> > Right, well, that's part of the problem. I think Paul just did the
> > reverse math and figured that 95% of X must not be larger than my
> > watchdog timeout and landed on 14 seconds.
> >
> > I'm thinking 4 seconds (or rather 4.294967296) would be a very nice
> > number.
> >
> > > Now thinking of this, if we come up with some simple criteria, could
> > > we have something like a sysctl that would allow only really "safe"
> > > parameters?
> >
> > I suppose we could do that, something like:
> > sysctl_deadline_period_{min,max}. I'll have to dig back a bit on where
> > we last talked about that and what the problems where.
> >
> > For one, setting the min is a lot harder, but I suppose we can start at
> > TICK_NSEC or something.
>
>
> Now syzkaller will drop CAP_SYS_NICE for the test process:
> https://github.com/google/syzkaller/commit/f3ad68446455acbe562e0057931e6256b8b991e8
> I will close this bug report as invalid once the change reaches all
> syzbot instances, if nobody plans any other on this bug.

#syz invalid
