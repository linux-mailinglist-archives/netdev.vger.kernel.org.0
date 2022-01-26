Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06D2449D61F
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 00:25:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230230AbiAZXZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 18:25:04 -0500
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:55228
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229825AbiAZXZD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 18:25:03 -0500
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 130663F1C4
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 23:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1643239502;
        bh=lfKSFrZdrqlpyeUaFf21cbx0E2/XUxdAgQ9hwpt5frY=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=lQIFQqF15h9mOcIDsuqFU0Ai1M6MMx3bZ/MXhxb/3U8wos7P88tjzebPOENyyTj4+
         orP65MZabojc/gNxdKAKAC7IMjhCVRoK6DpwvBs5ii26a6sLs1V4exWTReEmqvCyBd
         mRyi+ugh+pdWLUGW7PfeImkqsi9ghGycssU2vS3sc8CI/4Xj6M8khCTdVmuLGcRUkf
         PiMUO7UT0HfKKxSclZ1HI66zaT8nf00/L8x6YuOXEazIE9d3F4Vcl+6xnhwf/nMyWA
         gXKy6tsei+cxpwWjJZtFvta+Sl8rTQATrOxL82MoZ02y6njrtGbUlQDQdv1O3AZk+A
         eM+LyHhXe12iA==
Received: by mail-pl1-f198.google.com with SMTP id j1-20020a170903028100b0014b1f9e0068so506000plr.8
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 15:25:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references
         :comments:mime-version:content-id:content-transfer-encoding:date
         :message-id;
        bh=lfKSFrZdrqlpyeUaFf21cbx0E2/XUxdAgQ9hwpt5frY=;
        b=jxIE75fF9Pn+Ev/y0Kl/hjgWKyz+48ANJYnx4dAe64yWnGfTSWuLaXWS/mdiaZ22VY
         CsxP3jA+6HnTJVmddarWLwUrmnhCkewWFeA0JG8Gz3j7O5VW7ZFB/7RARYVHik8aBbZ9
         LqJnxCmpWZIe+1KVNPXUqnWQqPiQ6rtkH19MqzZyLPB4RuGPIcHoOm8LAixpvvUSly1I
         zdUwqNq1vIMEjcJt1oVaMG2m7SslA+sMvESTXtJxyNuNMkFgRGsKBUjvi4kA5vkV+eZL
         Zo85iCZJ69o+Xvg1HFHr+Hc+ibCkgQOXPJWRlXZwcraJxNJ9kAyNYD0p+M8lyH+lncP7
         2SyA==
X-Gm-Message-State: AOAM532/OgrD6NqOA1C+4vfyG98eziMlTIp3523DmHcydri9ZmRLxUts
        OJ76gFiSAJvlSi0DBPnXojUu/WNyLkdKjnvBMaAFxXVKQUmhByrs4x5asAFsAy3rVoezmaBuQqR
        jDPQvbir+43Q8QkoQWt84xeHnVywzdCXHjg==
X-Received: by 2002:a17:90a:17c6:: with SMTP id q64mr1273530pja.170.1643239500626;
        Wed, 26 Jan 2022 15:25:00 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyuP+JvE97PmO4KFL7QnCUlGlTcpkjlZCG3TfuY7Ifirihr779P/5LEy8shtlGLdsymJM+Yiw==
X-Received: by 2002:a17:90a:17c6:: with SMTP id q64mr1273503pja.170.1643239500350;
        Wed, 26 Jan 2022 15:25:00 -0800 (PST)
Received: from famine.localdomain ([50.125.80.157])
        by smtp.gmail.com with ESMTPSA id p8sm3313276pfo.41.2022.01.26.15.24.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Jan 2022 15:24:59 -0800 (PST)
Received: by famine.localdomain (Postfix, from userid 1000)
        id 7F35160DD1; Wed, 26 Jan 2022 15:24:59 -0800 (PST)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 77C2BA0B26;
        Wed, 26 Jan 2022 15:24:59 -0800 (PST)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Mahesh Bandewar <maheshb@google.com>
cc:     Netdev <netdev@vger.kernel.org>,
        Andy Gospodarek <andy@greyhouse.net>,
        Veaceslav Falico <vfalico@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mahesh Bandewar <mahesh@bandewar.net>
Subject: Re: [PATCH] bonding: rate-limit printing a warning message
In-reply-to: <20220126231229.4028998-1-maheshb@google.com>
References: <20220126231229.4028998-1-maheshb@google.com>
Comments: In-reply-to Mahesh Bandewar <maheshb@google.com>
   message dated "Wed, 26 Jan 2022 15:12:29 -0800."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <25070.1643239499.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Wed, 26 Jan 2022 15:24:59 -0800
Message-ID: <25071.1643239499@famine>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mahesh Bandewar <maheshb@google.com> wrote:

>dev.c:get_link_speed() schedules a work-queue aggressively when it
>fails to get the speed. If the link n question is a bond device which
>may have multiple links to iterate through to get the link
>speed. If the underlying link(s) has/have issues, bonding driver prints
>a link-status message and this doesn't go well with the aggressive
>work-queue scheduling and results in a rcu stall. This fix just
>adds a ratelimiter to the message printing to avoid the stall.

	I don't see a get_link_speed() function in net-next
net/core/dev.c; am I missing something?

	-J

>Call Trace:
> <IRQ>
> __dump_stack lib/dump_stack.c:17 [inline]
> dump_stack+0x14d/0x20b lib/dump_stack.c:53
> nmi_cpu_backtrace.cold+0x19/0x98 lib/nmi_backtrace.c:103
> nmi_trigger_cpumask_backtrace+0x16a/0x17e lib/nmi_backtrace.c:62
> arch_trigger_cpumask_backtrace+0x14/0x20 arch/x86/kernel/apic/hw_nmi.c:3=
8
> trigger_single_cpu_backtrace include/linux/nmi.h:161 [inline]
> rcu_dump_cpu_stacks+0x183/0x1cf kernel/rcu/tree.c:1210
> print_cpu_stall kernel/rcu/tree.c:1349 [inline]
> check_cpu_stall kernel/rcu/tree.c:1423 [inline]
> rcu_pending kernel/rcu/tree.c:3010 [inline]
> rcu_check_callbacks.cold+0x494/0x7d3 kernel/rcu/tree.c:2551
> update_process_times+0x32/0x80 kernel/time/timer.c:1641
> tick_sched_handle+0xa0/0x180 kernel/time/tick-sched.c:161
> tick_sched_timer+0x44/0x130 kernel/time/tick-sched.c:1193
> __run_hrtimer kernel/time/hrtimer.c:1396 [inline]
> __hrtimer_run_queues+0x304/0xd80 kernel/time/hrtimer.c:1458
> hrtimer_interrupt+0x2ea/0x730 kernel/time/hrtimer.c:1516
> local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1031 [inline]
> smp_apic_timer_interrupt+0x150/0x5e0 arch/x86/kernel/apic/apic.c:1056
> apic_timer_interrupt+0x93/0xa0 arch/x86/entry/entry_64.S:780
> </IRQ>
>RIP: 0010:arch_local_irq_restore arch/x86/include/asm/paravirt.h:783 [inl=
ine]
>RIP: 0010:console_unlock+0x82b/0xcc0 kernel/printk/printk.c:2302
> RSP: 0018:ffff8801966cb9e8 EFLAGS: 00000293 ORIG_RAX: ffffffffffffff12
>RAX: ffff8801968d0040 RBX: 0000000000000000 RCX: 0000000000000006
>RDX: 0000000000000000 RSI: ffffffff815a6515 RDI: 0000000000000293
>RBP: ffff8801966cba70 R08: ffff8801968d0040 R09: 0000000000000000
>R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
>R13: ffffffff82cc61b0 R14: dffffc0000000000 R15: 0000000000000001
> vprintk_emit+0x593/0x610 kernel/printk/printk.c:1836
> vprintk_default+0x28/0x30 kernel/printk/printk.c:1876
> vprintk_func+0x7a/0xed kernel/printk/printk_safe.c:379
> printk+0xba/0xed kernel/printk/printk.c:1909
> get_link_speed.cold+0x43/0x144 net/core/dev.c:1493
> get_link_speed_work+0x1e/0x30 net/core/dev.c:1515
> process_one_work+0x881/0x1560 kernel/workqueue.c:2147
> worker_thread+0x653/0x1150 kernel/workqueue.c:2281
> kthread+0x345/0x410 kernel/kthread.c:246
> ret_from_fork+0x3f/0x50 arch/x86/entry/entry_64.S:393
>
>Signed-off-by: Mahesh Bandewar <maheshb@google.com>
>---
> drivers/net/bonding/bond_main.c | 9 ++++++---
> 1 file changed, 6 insertions(+), 3 deletions(-)
>
>diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_m=
ain.c
>index 238b56d77c36..98b37af3fb6b 100644
>--- a/drivers/net/bonding/bond_main.c
>+++ b/drivers/net/bonding/bond_main.c
>@@ -2538,9 +2538,12 @@ static int bond_miimon_inspect(struct bonding *bon=
d)
> 				/* recovered before downdelay expired */
> 				bond_propose_link_state(slave, BOND_LINK_UP);
> 				slave->last_link_up =3D jiffies;
>-				slave_info(bond->dev, slave->dev, "link status up again after %d ms\=
n",
>-					   (bond->params.downdelay - slave->delay) *
>-					   bond->params.miimon);
>+				if (net_ratelimit())
>+					slave_info(bond->dev, slave->dev,
>+						   "link status up again after %d ms\n",
>+						   (bond->params.downdelay -
>+						    slave->delay) *
>+						   bond->params.miimon);
> 				commit++;
> 				continue;
> 			}
>-- =

>2.35.0.rc0.227.g00780c9af4-goog
>

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
