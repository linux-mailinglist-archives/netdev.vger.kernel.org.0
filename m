Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6420D49D6A1
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 01:19:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233728AbiA0ATJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 19:19:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbiA0ATI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 19:19:08 -0500
Received: from mail-ua1-x92f.google.com (mail-ua1-x92f.google.com [IPv6:2607:f8b0:4864:20::92f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29411C06161C
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 16:19:08 -0800 (PST)
Received: by mail-ua1-x92f.google.com with SMTP id l1so1746665uap.8
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 16:19:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=glXZWJHoJptPk1cK4OtwUl4sjvEMWqX7xZbQD9DZwzA=;
        b=mRVwYImb5Ilm8t3WdVa6ia9jf9thYHDHglrZTnAFhKV+eepK85Z8JQhuDabRlhBKhQ
         867k8rSxQnFwcqnosX9ec8PVXB1g6SyBRyDw2ah/DeTEN5/1k+rRWwQfFCJbH7ZmoRZm
         /0XX/LpFRgn18cSrUCQ+g8qahPUID0ND/AWe0HjY/GQDno+g1qG9xVhGISUxscmoSWXc
         KEHPyPFgAFDMWNU38PyNB1BS+vvFYYqUm6uTQKK/AXYPwQ+xkwgyxG+MvwAAGetFXzh7
         4HUpY27WX1RZ4pNUfz3Lq+X21XBKO2OAJviQ/lUSnLVamUklFTiAIt6ywAvsXl73XqhW
         1CVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=glXZWJHoJptPk1cK4OtwUl4sjvEMWqX7xZbQD9DZwzA=;
        b=lgHbVjL3yPxALTzmCmTt+8dnhlwm4QJzvki0/Kl+HgUd5ZtLsjdXXSszaPqet/BZAl
         jUD5ptIRgAu+/ZihJOte1epJkWFza/tCuKFwcnKKkS9/9xzYEAa+h/BYDm89Mnh/Yqtv
         gOOlM9Cw6/Ntp0sEXwgU09cnlETHQxc/j62nFCi6s8ajWcQHxd9T2/sNoJNZNFix2XKO
         yVpgV9naRPx9MoHmHVPHseDmX0mlSjLt6EWPlx4Bo7fejm6FGbYcSQT10RU4wcgUvXdA
         W7bIXy+1XKHtn1EbSaK7teaES22NbuVFu405UBKDHvxtPw3ot+94iRrJ31zyC0Ko/nVN
         jgrA==
X-Gm-Message-State: AOAM531/le5MTvRacdRunVIDCs+OfPqnDhfx5qWIh1/KVIyC8gvYNXoA
        ysZXR2ZjYPAI6nlKw2+7bP1djD/easWvthYQqREi0g==
X-Google-Smtp-Source: ABdhPJxF/vYO3nesz5F277hpnyCP/iFCzbp0LxR1YL1nmFWCLWCo4COKtaMid+uUR0FH5EfjuWRBMOv0vsppBWHHns8=
X-Received: by 2002:a67:ea10:: with SMTP id g16mr578436vso.24.1643242746967;
 Wed, 26 Jan 2022 16:19:06 -0800 (PST)
MIME-Version: 1.0
References: <20220126231229.4028998-1-maheshb@google.com> <25071.1643239499@famine>
In-Reply-To: <25071.1643239499@famine>
From:   =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS14KS+4KSwKQ==?= 
        <maheshb@google.com>
Date:   Wed, 26 Jan 2022 16:18:40 -0800
Message-ID: <CAF2d9jgrJg1VDYwxNtXmu75djG11WQWp3JYhrQ8VBkabwti2ow@mail.gmail.com>
Subject: Re: [PATCH] bonding: rate-limit printing a warning message
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Andy Gospodarek <andy@greyhouse.net>,
        Veaceslav Falico <vfalico@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mahesh Bandewar <mahesh@bandewar.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 26, 2022 at 3:25 PM Jay Vosburgh <jay.vosburgh@canonical.com> wrote:
>
> Mahesh Bandewar <maheshb@google.com> wrote:
>
> >dev.c:get_link_speed() schedules a work-queue aggressively when it
> >fails to get the speed. If the link n question is a bond device which
> >may have multiple links to iterate through to get the link
> >speed. If the underlying link(s) has/have issues, bonding driver prints
> >a link-status message and this doesn't go well with the aggressive
> >work-queue scheduling and results in a rcu stall. This fix just
> >adds a ratelimiter to the message printing to avoid the stall.
>
>         I don't see a get_link_speed() function in net-next
> net/core/dev.c; am I missing something?
>
Oops, looks like this case is relevant to our kernel only, please
ignore the patch.

>         -J
>
> >Call Trace:
> > <IRQ>
> > __dump_stack lib/dump_stack.c:17 [inline]
> > dump_stack+0x14d/0x20b lib/dump_stack.c:53
> > nmi_cpu_backtrace.cold+0x19/0x98 lib/nmi_backtrace.c:103
> > nmi_trigger_cpumask_backtrace+0x16a/0x17e lib/nmi_backtrace.c:62
> > arch_trigger_cpumask_backtrace+0x14/0x20 arch/x86/kernel/apic/hw_nmi.c:38
> > trigger_single_cpu_backtrace include/linux/nmi.h:161 [inline]
> > rcu_dump_cpu_stacks+0x183/0x1cf kernel/rcu/tree.c:1210
> > print_cpu_stall kernel/rcu/tree.c:1349 [inline]
> > check_cpu_stall kernel/rcu/tree.c:1423 [inline]
> > rcu_pending kernel/rcu/tree.c:3010 [inline]
> > rcu_check_callbacks.cold+0x494/0x7d3 kernel/rcu/tree.c:2551
> > update_process_times+0x32/0x80 kernel/time/timer.c:1641
> > tick_sched_handle+0xa0/0x180 kernel/time/tick-sched.c:161
> > tick_sched_timer+0x44/0x130 kernel/time/tick-sched.c:1193
> > __run_hrtimer kernel/time/hrtimer.c:1396 [inline]
> > __hrtimer_run_queues+0x304/0xd80 kernel/time/hrtimer.c:1458
> > hrtimer_interrupt+0x2ea/0x730 kernel/time/hrtimer.c:1516
> > local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1031 [inline]
> > smp_apic_timer_interrupt+0x150/0x5e0 arch/x86/kernel/apic/apic.c:1056
> > apic_timer_interrupt+0x93/0xa0 arch/x86/entry/entry_64.S:780
> > </IRQ>
> >RIP: 0010:arch_local_irq_restore arch/x86/include/asm/paravirt.h:783 [inline]
> >RIP: 0010:console_unlock+0x82b/0xcc0 kernel/printk/printk.c:2302
> > RSP: 0018:ffff8801966cb9e8 EFLAGS: 00000293 ORIG_RAX: ffffffffffffff12
> >RAX: ffff8801968d0040 RBX: 0000000000000000 RCX: 0000000000000006
> >RDX: 0000000000000000 RSI: ffffffff815a6515 RDI: 0000000000000293
> >RBP: ffff8801966cba70 R08: ffff8801968d0040 R09: 0000000000000000
> >R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
> >R13: ffffffff82cc61b0 R14: dffffc0000000000 R15: 0000000000000001
> > vprintk_emit+0x593/0x610 kernel/printk/printk.c:1836
> > vprintk_default+0x28/0x30 kernel/printk/printk.c:1876
> > vprintk_func+0x7a/0xed kernel/printk/printk_safe.c:379
> > printk+0xba/0xed kernel/printk/printk.c:1909
> > get_link_speed.cold+0x43/0x144 net/core/dev.c:1493
> > get_link_speed_work+0x1e/0x30 net/core/dev.c:1515
> > process_one_work+0x881/0x1560 kernel/workqueue.c:2147
> > worker_thread+0x653/0x1150 kernel/workqueue.c:2281
> > kthread+0x345/0x410 kernel/kthread.c:246
> > ret_from_fork+0x3f/0x50 arch/x86/entry/entry_64.S:393
> >
> >Signed-off-by: Mahesh Bandewar <maheshb@google.com>
> >---
> > drivers/net/bonding/bond_main.c | 9 ++++++---
> > 1 file changed, 6 insertions(+), 3 deletions(-)
> >
> >diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> >index 238b56d77c36..98b37af3fb6b 100644
> >--- a/drivers/net/bonding/bond_main.c
> >+++ b/drivers/net/bonding/bond_main.c
> >@@ -2538,9 +2538,12 @@ static int bond_miimon_inspect(struct bonding *bond)
> >                               /* recovered before downdelay expired */
> >                               bond_propose_link_state(slave, BOND_LINK_UP);
> >                               slave->last_link_up = jiffies;
> >-                              slave_info(bond->dev, slave->dev, "link status up again after %d ms\n",
> >-                                         (bond->params.downdelay - slave->delay) *
> >-                                         bond->params.miimon);
> >+                              if (net_ratelimit())
> >+                                      slave_info(bond->dev, slave->dev,
> >+                                                 "link status up again after %d ms\n",
> >+                                                 (bond->params.downdelay -
> >+                                                  slave->delay) *
> >+                                                 bond->params.miimon);
> >                               commit++;
> >                               continue;
> >                       }
> >--
> >2.35.0.rc0.227.g00780c9af4-goog
> >
>
> ---
>         -Jay Vosburgh, jay.vosburgh@canonical.com
