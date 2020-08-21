Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A4B924D8BC
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 17:36:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728241AbgHUPgE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 11:36:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727892AbgHUPfl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 11:35:41 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 691A3C061573
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 08:35:40 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id k20so2249315wmi.5
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 08:35:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=wkZaf2fS0TRbgqB1TvCp3uNQXxIjOYG9m293JxctoWI=;
        b=M79Keox0M4DbWW10mmvqE4V+GwcyxPgb1gp3cA/S7VY6ho6+oPYVy8OZBO17qHQa8H
         VX8g9OFy1C0UMfHmXQNE2yrRdXMdWi6RWHp6d5tSsN6lx2ImQnqDkdpg1PEIpdNdrMkz
         JeEz6IkumP+dMetNUbRP4YrM7PZAh/sG0LUWsDDz0+Hz3RRne17s8kIAZCZC9J2d/r4c
         Cw0qNpGBB4YkUxUz0NhcWYSSGpkrZRzGEJIvINTBAbbKfjby8JghJCbvmZMyHECSYg0U
         cAsVZ+ONi8N8HAO6WYWQ5D7JvorJ4ShueUPBYdF/n/wWIRWCKe1ZOToy0r5JnfK77zP8
         DXbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=wkZaf2fS0TRbgqB1TvCp3uNQXxIjOYG9m293JxctoWI=;
        b=nc1R9OAVXu+oTrfrEubNQo66tBvgK0ar+RT2BKq2ufZ1ypHUdvgXk+PgJBB7+0spWW
         l3Dg6LUcqRwF8rXrfVnd2kw1fRPS9/69mihe1CXI+hSRdZNAC/vsS6+VE+pkuKsdpWtm
         MHa30X8+LLRIo8boXW1ft/TnB2/Tbp+PpIC/nNMoCbWe6DR8utUCa2sK4Psgd+8sCWmy
         JdcqS8yEI7oXsIQAGvVLyiHAosgksZoofBHB2HWoFr0IaVLDcIQxvUWwO5TqRcVMDxux
         jLg8qEHk1TL9x66RCB7XaeKj6Or8iJzyFtE4iax4e9zyyy23xPpNaOqOlPBeNAuOYWNo
         kAqg==
X-Gm-Message-State: AOAM5333byVsXvKhTkVc1MR+B1RLliJwrawMzZEnNX8xzx8DdnGQWNAp
        nTlnrDACk+0hosiYgHzKsRnVaw==
X-Google-Smtp-Source: ABdhPJwnwfcSVkUcMmU60mX6rj4bISfP4uRgTzwRJSmV2IqzEpKh+dN3bnEq9KMPvzkwkh+oR+dIhA==
X-Received: by 2002:a1c:6446:: with SMTP id y67mr3797277wmb.49.1598024138744;
        Fri, 21 Aug 2020 08:35:38 -0700 (PDT)
Received: from elver.google.com ([100.105.32.75])
        by smtp.gmail.com with ESMTPSA id 31sm4611928wrj.94.2020.08.21.08.35.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2020 08:35:38 -0700 (PDT)
Date:   Fri, 21 Aug 2020 17:35:32 +0200
From:   Marco Elver <elver@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] random32: Use rcuidle variant for tracepoint
Message-ID: <20200821153532.GA3205540@elver.google.com>
References: <20200821063043.1949509-1-elver@google.com>
 <20200821085907.GJ1362448@hirez.programming.kicks-ass.net>
 <CANn89i+1MQRCSRVg-af758en5e9nwQBes3aBSjQ6BY1pV5+HdQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89i+1MQRCSRVg-af758en5e9nwQBes3aBSjQ6BY1pV5+HdQ@mail.gmail.com>
User-Agent: Mutt/1.14.4 (2020-06-18)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 21, 2020 at 08:06AM -0700, Eric Dumazet wrote:
> On Fri, Aug 21, 2020 at 1:59 AM <peterz@infradead.org> wrote:
> >
> > On Fri, Aug 21, 2020 at 08:30:43AM +0200, Marco Elver wrote:
> > > With KCSAN enabled, prandom_u32() may be called from any context,
> > > including idle CPUs.
> > >
> > > Therefore, switch to using trace_prandom_u32_rcuidle(), to avoid various
> > > issues due to recursion and lockdep warnings when KCSAN and tracing is
> > > enabled.
> >
> > At some point we're going to have to introduce noinstr to idle as well.
> > But until that time this should indeed cure things.
> 
> I do not understand what the issue is.  This _rcuidle() is kind of opaque ;)
>
> Would this alternative patch work, or is it something more fundamental ?

There are 2 problems:

1. Recursion due to ending up in lockdep from the tracepoint. I need to
solve this either way. One way is to use _rcuidle() variant, which
doesn't call into lockdep.

2. Somehow running into trouble because we use tracing from an idle CPU.
At least that's what I gathered from the documentation -- but you'd have
to wait for Peter or Steven to get a better explanation.

> Thanks !
> 
> diff --git a/lib/random32.c b/lib/random32.c
> index 932345323af092a93fc2690b0ebbf4f7485ae4f3..17af2d1631e5ab6e02ad1e9288af7e007bed6d5f
> 100644
> --- a/lib/random32.c
> +++ b/lib/random32.c
> @@ -83,9 +83,10 @@ u32 prandom_u32(void)
>         u32 res;
> 
>         res = prandom_u32_state(state);
> -       trace_prandom_u32(res);
>         put_cpu_var(net_rand_state);
> 
> +       trace_prandom_u32(res);
> +
>         return res;
>  }
>  EXPORT_SYMBOL(prandom_u32);

That unfortunately still gets me the same warning:

| ------------[ cut here ]------------
| DEBUG_LOCKS_WARN_ON(lockdep_hardirqs_enabled())
| WARNING: CPU: 4 PID: 1861 at kernel/locking/lockdep.c:4875 check_flags.part.0+0x157/0x160 kernel/locking/lockdep.c:4875
| Modules linked in:
| CPU: 4 PID: 1861 Comm: kworker/u16:4 Not tainted 5.9.0-rc1+ #24
| Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1 04/01/2014
| RIP: 0010:check_flags.part.0+0x157/0x160 kernel/locking/lockdep.c:4875
| Code: c0 0f 84 70 5d 00 00 44 8b 0d fd 11 5f 06 45 85 c9 0f 85 60 5d 00 00 48 c7 c6 3e d0 f4 86 48 c7 c7 b2 49 f3 86 e8 8d 49 f6 ff <0f> 0b e9 46 5d 00 00 66 90 41 57 41 56 49 89 fe 41 55 41 89 d5 41
| RSP: 0000:ffffc900034bfcb0 EFLAGS: 00010082
| RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffffff8136161c
| RDX: ffff88881a9dcb00 RSI: ffffffff81363835 RDI: 0000000000000006
| RBP: ffffc900034bfd00 R08: 0000000000000000 R09: 0000ffffffffffff
| R10: 0000000000000104 R11: 0000ffff874efd6b R12: ffffffff874f26c0
| R13: 0000000000000244 R14: 0000000000000000 R15: 0000000000000046
| FS:  0000000000000000(0000) GS:ffff88881fc00000(0000) knlGS:0000000000000000
| CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
| CR2: 0000000000000000 CR3: 0000000007489001 CR4: 0000000000770ee0
| DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
| DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
| PKRU: 55555554
| Call Trace:
|  check_flags kernel/locking/lockdep.c:4871 [inline]
|  lock_is_held_type+0x42/0x100 kernel/locking/lockdep.c:5042
|  lock_is_held include/linux/lockdep.h:267 [inline]
|  rcu_read_lock_sched_held+0x41/0x80 kernel/rcu/update.c:136
|  trace_prandom_u32 include/trace/events/random.h:310 [inline]
|  prandom_u32+0x1bb/0x200 lib/random32.c:86
|  prandom_u32_max include/linux/prandom.h:46 [inline]
|  reset_kcsan_skip kernel/kcsan/core.c:277 [inline]
|  kcsan_setup_watchpoint+0x9b/0x600 kernel/kcsan/core.c:424
|  perf_lock_task_context+0x5e3/0x6e0 kernel/events/core.c:1491
|  perf_pin_task_context kernel/events/core.c:1506 [inline]
|  perf_event_exit_task_context kernel/events/core.c:12284 [inline]
|  perf_event_exit_task+0x1e2/0x910 kernel/events/core.c:12364
|  do_exit+0x70e/0x18b0 kernel/exit.c:815
|  call_usermodehelper_exec_async+0x2e2/0x2f0 kernel/umh.c:114
|  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
| irq event stamp: 107
| hardirqs last  enabled at (107): [<ffffffff815532ab>] perf_lock_task_context+0x5db/0x6e0 kernel/events/core.c:1491
| hardirqs last disabled at (106): [<ffffffff81552f12>] perf_lock_task_context+0x242/0x6e0 kernel/events/core.c:1459
| softirqs last  enabled at (0): [<ffffffff8129b95e>] copy_process+0xe9e/0x3970 kernel/fork.c:2004
| softirqs last disabled at (0): [<0000000000000000>] 0x0
| ---[ end trace a3058d9b157af5c4 ]---
| possible reason: unannotated irqs-off.
| irq event stamp: 107
| hardirqs last  enabled at (107): [<ffffffff815532ab>] perf_lock_task_context+0x5db/0x6e0 kernel/events/core.c:1491
| hardirqs last disabled at (106): [<ffffffff81552f12>] perf_lock_task_context+0x242/0x6e0 kernel/events/core.c:1459
| softirqs last  enabled at (0): [<ffffffff8129b95e>] copy_process+0xe9e/0x3970 kernel/fork.c:2004
| softirqs last disabled at (0): [<0000000000000000>] 0x0

I also have a patch which avoids the problem entirely by not using
prandom_u32(): https://lkml.kernel.org/r/20200821123126.3121494-1-elver@google.com
But that patch will likely only make it into the next merge window
(because of other conflicts).

So, if the _rcuidle() variant here doesn't break your usecase, there
should be no harm in using the _rcuidle() variant. This also lifts the
restriction on where prandom_u32() is usable to what it was before,
which should be any context.

Steven, Peter: What's the downside to of _rcuidle()?

Thanks,
-- Marco
