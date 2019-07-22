Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4C226FD5D
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 12:03:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729209AbfGVKDP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 06:03:15 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:41224 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726846AbfGVKDO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 06:03:14 -0400
Received: by mail-io1-f67.google.com with SMTP id j5so68422186ioj.8
        for <netdev@vger.kernel.org>; Mon, 22 Jul 2019 03:03:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4b1uAwM9umv+IY8/HnGfteiZXrlo/NSOu+cIPVvp1h0=;
        b=XglgEILo3rW9D3vL7A0pPJKvQjXuJIjm0yzulNQh37Bkvxk46652lpiq6aGUGfTvqS
         yw0q33nv4FulOutDW8O8FtbPhemeCLLbAYWuW70qi6R2REVITVQutMEDuC8nDEwwuQy2
         71fsmVuDZF+P22bgkOd7CkBLwBi3BR72dcaToUYSwGxNtZBS/EhMTh97Y/U+gqaXjS0f
         cpN4sjsyi+45KjkuDxrVwCXMWuZVaruaBliF/iNo1DTN7yM+Hx5zEoTBg3uI8QtXP+Fp
         80BlwxHoWTpLcQUd75TzDP2P3NzDsjA0DvhL8wj38b2ry2a2xMoPA2hq4TB8ye/C75XS
         eEWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4b1uAwM9umv+IY8/HnGfteiZXrlo/NSOu+cIPVvp1h0=;
        b=UnSVEdoyGPjpezB07URuesRzsu3WDybhMZPgT4vU4oWHRZ2voz2UYVoowPhgguRIs0
         FGYcUcIng1UvQnicZlFalADWJRMQ2BXx/BRQbdk0KZm0lppA+SVNu4+nsdqZi/mg4h5M
         /nJsAbYeCvYtz56Ltih+ohkM2HvUMUmWmkTm6zFWpy7EbvBi0V7mF60AxcDcJG45cU7j
         m//MPDVr31tsSOPJoxDxqbx3OmoKXmPWi8h6QuoBpie2cpxTn2Kez5ClJjHaHCAURftN
         UtGRjFWPY+bdt/zHiVrsm1hmnmNx+r+V1VOYinw9gG3BckuALJXyvc7EP9kQe83BuaJe
         NHIg==
X-Gm-Message-State: APjAAAU5pA9vjztCimN5rX/M8PhyEhIbel/ObEtzrs+6Uzp0rEHVsr89
        8tuyOfh8Anv7W+q97czhcYSpEQ/r4RPbzaiJGBseWA==
X-Google-Smtp-Source: APXvYqwL+M8Rgssa2ucPdgR/HDa1HVbuVJ+QRBULwshbyX+2VreyyBzq+g0gTT09x68VANTfGl21EY1W9jWIvu2wAng=
X-Received: by 2002:a6b:b556:: with SMTP id e83mr62253077iof.94.1563789793779;
 Mon, 22 Jul 2019 03:03:13 -0700 (PDT)
MIME-Version: 1.0
References: <20190705191055.GT26519@linux.ibm.com> <20190706042801.GD11665@mit.edu>
 <20190706061631.GV26519@linux.ibm.com> <20190706150226.GG11665@mit.edu>
 <20190706180311.GW26519@linux.ibm.com> <20190707011655.GA22081@linux.ibm.com>
 <CACT4Y+asYe-uH9OV5R0Nkb-JKP4erYUZ68S9gYNnGg6v+fD20w@mail.gmail.com>
 <20190714184915.GK26519@linux.ibm.com> <20190715132911.GG3419@hirez.programming.kicks-ass.net>
 <CACT4Y+bmgdOExBHnLJ+jgWKWQzNK9CFT6_eTxFE3hoK=0YresQ@mail.gmail.com> <20190715134651.GI3419@hirez.programming.kicks-ass.net>
In-Reply-To: <20190715134651.GI3419@hirez.programming.kicks-ass.net>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Mon, 22 Jul 2019 12:03:02 +0200
Message-ID: <CACT4Y+bGgyZWbRQ7QNCHRLU0Zq2+cONSbyaycfzwvToqMwiwBQ@mail.gmail.com>
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

On Mon, Jul 15, 2019 at 3:46 PM Peter Zijlstra <peterz@infradead.org> wrote:
>
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
>
> I'm thinking 4 seconds (or rather 4.294967296) would be a very nice
> number.
>
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


Now syzkaller will drop CAP_SYS_NICE for the test process:
https://github.com/google/syzkaller/commit/f3ad68446455acbe562e0057931e6256b8b991e8
I will close this bug report as invalid once the change reaches all
syzbot instances, if nobody plans any other on this bug.
