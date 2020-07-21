Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79E472287ED
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 20:04:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730091AbgGUSCx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 14:02:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:43042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728042AbgGUSCu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 14:02:50 -0400
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29C3A22C9C
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 18:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595354569;
        bh=Dygy/vHGWzC5DtQBeg15WLnaBrQsPb2nhQiwgIJIQDI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Od2RUw+UF6ebjPTwpvyC1x92aDK7AP/PUbQtK+ob7tapkyF8uOQQVDnC+clh2WUIZ
         w//r1eSvZPWD0uh+6PEdE0+oGq2tZ+xsnmloDTHXzvyWOU1hD0dZllv6tThtm1j6Xb
         pUTyjYvK8CzWQsleTZmHjagQivG0AB5kXjxcMNr4=
Received: by mail-wm1-f45.google.com with SMTP id f139so3754674wmf.5
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 11:02:49 -0700 (PDT)
X-Gm-Message-State: AOAM530CKT/i/u7pgr1UknXKYO5DH6Sv/NrrkiELJIF08ie7pIHlTLxY
        hyFyaz/F+n3Bs6QFu7IawC/wO5NsxE8AqAwlTU7MIw==
X-Google-Smtp-Source: ABdhPJzt+CT6JPl1hYKeUo2s1F+qIzOeYfW3nI0LsqKaJj3HS4hPWNKHqhQgbEi85XJ7lHgJhP/FG3/k5J82SKC/yKE=
X-Received: by 2002:a1c:56c3:: with SMTP id k186mr3982529wmb.21.1595354567554;
 Tue, 21 Jul 2020 11:02:47 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000dee84305aaf72849@google.com>
In-Reply-To: <000000000000dee84305aaf72849@google.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Tue, 21 Jul 2020 11:02:35 -0700
X-Gmail-Original-Message-ID: <CALCETrV9heuzwiL9aFB3WrKMidyOuxjRyzAEM=R+p3vqxe6AVw@mail.gmail.com>
Message-ID: <CALCETrV9heuzwiL9aFB3WrKMidyOuxjRyzAEM=R+p3vqxe6AVw@mail.gmail.com>
Subject: Re: BUG: stack guard page was hit in pvclock_clocksource_read
To:     syzbot <syzbot+33db977d6e575c4884b1@syzkaller.appspotmail.com>
Cc:     Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Juergen Gross <jgross@suse.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        syzkaller-bugs@googlegroups.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        X86 ML <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 21, 2020 at 10:43 AM syzbot
<syzbot+33db977d6e575c4884b1@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    473309fb net: dp83640: fix SIOCSHWTSTAMP to update the str..
> git tree:       net
> console output: https://syzkaller.appspot.com/x/log.txt?x=175443e7100000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=368e8612711aa2cc
> dashboard link: https://syzkaller.appspot.com/bug?extid=33db977d6e575c4884b1
> compiler:       gcc (GCC) 10.1.0-syz 20200507
>
> Unfortunately, I don't have any reproducer for this issue yet.
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+33db977d6e575c4884b1@syzkaller.appspotmail.com
>
> BUG: stack guard page was hit at 00000000568268d5 (stack is 00000000fd6fd35d..00000000fd6d22ec)
> kernel stack overflow (double-fault): 0000 [#1] PREEMPT SMP KASAN
> CPU: 0 PID: 30079 Comm: syz-executor.0 Not tainted 5.8.0-rc4-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:pvclock_clocksource_read+0x21/0x510 arch/x86/kernel/pvclock.c:68
> Code: 2e 0f 1f 84 00 00 00 00 00 48 ba 00 00 00 00 00 fc ff df 48 89 f8 41 57 48 c1 e8 03 41 56 41 55 41 54 4c 8d 67 03 55 4c 89 e1 <53> 48 c1 e9 03 48 89 fb 48 83 ec 58 0f b6 04 10 0f b6 14 11 48 89
> RSP: 0018:ffffc90016598000 EFLAGS: 00010806
> RAX: 1ffffffff17cec00 RBX: ffff8880ae620dc0 RCX: ffffffff8be76003
> RDX: dffffc0000000000 RSI: 0000000000000001 RDI: ffffffff8be76000
> RBP: ffff888059596380 R08: 0000000000000001 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff8be76003
> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> FS:  00007f3e110c1700(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffffc90016597ff8 CR3: 000000005d14d000 CR4: 00000000001406f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  kvm_clock_read arch/x86/kernel/kvmclock.c:90 [inline]
>  kvm_sched_clock_read+0x14/0x40 arch/x86/kernel/kvmclock.c:102
>  paravirt_sched_clock arch/x86/include/asm/paravirt.h:22 [inline]
>  sched_clock+0x2a/0x40 arch/x86/kernel/tsc.c:252
>  sched_clock_cpu+0x18/0x1b0 kernel/sched/clock.c:371
>  irqtime_account_irq+0x63/0x280 kernel/sched/cputime.c:60
>  account_irq_enter_time include/linux/vtime.h:109 [inline]
>  irq_enter_rcu+0x61/0x140 kernel/softirq.c:356
>  sysvec_apic_timer_interrupt+0x13/0x120 arch/x86/kernel/apic/apic.c:1091
>  asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:587
> RIP: 0010:__orc_find+0x9b/0xf0 arch/x86/kernel/unwind_orc.c:58
> Code: d8 83 e0 07 83 c0 03 38 d0 7c 04 84 d2 75 48 48 63 03 48 01 d8 48 39 c1 73 b0 4c 8d 63 fc 49 39 ec 73 b3 4d 29 ee 49 c1 fe 02 <4b> 8d 04 76 48 8d 04 46 48 83 c4 10 5b 5d 41 5c 41 5d 41 5e 41 5f
> RSP: 0018:ffffc90016598190 EFLAGS: 00000246
> RAX: ffffffff84b1c69e RBX: ffffffff8ae8fef8 RCX: ffffffff84b1cb81
> RDX: 0000000000000000 RSI: ffffffff8b5be90e RDI: ffffffff8ae8fef8
> RBP: ffffffff8ae8fefc R08: ffffffff8b5be944 R09: ffffffff8b5be90e
> R10: 000000000007201e R11: 00000000000c2499 R12: ffffffff8ae8fef8
> R13: ffffffff8ae8fef8 R14: 0000000000000000 R15: dffffc0000000000
>  orc_find arch/x86/kernel/unwind_orc.c:172 [inline]
>  unwind_next_frame+0x342/0x1f90 arch/x86/kernel/unwind_orc.c:446
>  arch_stack_walk+0x81/0xf0 arch/x86/kernel/stacktrace.c:25
>  stack_trace_save+0x8c/0xc0 kernel/stacktrace.c:123
>  save_stack+0x1b/0x40 mm/kasan/common.c:48
>  set_track mm/kasan/common.c:56 [inline]
>  __kasan_kmalloc.constprop.0+0xc2/0xd0 mm/kasan/common.c:494
>  __kmalloc_reserve net/core/skbuff.c:142 [inline]
>  pskb_expand_head+0x15a/0x1040 net/core/skbuff.c:1627
>  netlink_trim+0x1ea/0x240 net/netlink/af_netlink.c:1285
>  netlink_broadcast_filtered+0x65/0xdc0 net/netlink/af_netlink.c:1490
>  netlink_broadcast net/netlink/af_netlink.c:1535 [inline]
>  nlmsg_multicast include/net/netlink.h:1020 [inline]
>  nlmsg_notify+0x90/0x250 net/netlink/af_netlink.c:2512
>  rtnl_notify net/core/rtnetlink.c:737 [inline]
>  rtmsg_ifinfo_send net/core/rtnetlink.c:3725 [inline]
>  rtmsg_ifinfo_event net/core/rtnetlink.c:3740 [inline]
>  rtmsg_ifinfo_event net/core/rtnetlink.c:3728 [inline]
>  rtnetlink_event+0x193/0x1d0 net/core/rtnetlink.c:5511
>  notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
>  call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2027
>  call_netdevice_notifiers_extack net/core/dev.c:2039 [inline]
>  call_netdevice_notifiers net/core/dev.c:2053 [inline]
>  netdev_features_change net/core/dev.c:1443 [inline]
>  netdev_sync_lower_features net/core/dev.c:9056 [inline]
>  __netdev_update_features+0x88d/0x1360 net/core/dev.c:9187
>  netdev_change_features+0x61/0xb0 net/core/dev.c:9259
>  bond_compute_features+0x502/0xa00 drivers/net/bonding/bond_main.c:1188
>  bond_slave_netdev_event drivers/net/bonding/bond_main.c:3237 [inline]
>  bond_netdev_event+0x81f/0xb30 drivers/net/bonding/bond_main.c:3277
>  notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
>  call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2027
>  call_netdevice_notifiers_extack net/core/dev.c:2039 [inline]
>  call_netdevice_notifiers net/core/dev.c:2053 [inline]
>  netdev_features_change net/core/dev.c:1443 [inline]
>  netdev_sync_lower_features net/core/dev.c:9056 [inline]
>  __netdev_update_features+0x88d/0x1360 net/core/dev.c:9187
>  netdev_change_features+0x61/0xb0 net/core/dev.c:9259
>  bond_compute_features+0x502/0xa00 drivers/net/bonding/bond_main.c:1188
>  bond_slave_netdev_event drivers/net/bonding/bond_main.c:3237 [inline]
>  bond_netdev_event+0x81f/0xb30 drivers/net/bonding/bond_main.c:3277
>  notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
>  call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2027
>  call_netdevice_notifiers_extack net/core/dev.c:2039 [inline]
>  call_netdevice_notifiers net/core/dev.c:2053 [inline]
>  netdev_features_change net/core/dev.c:1443 [inline]
>  netdev_sync_lower_features net/core/dev.c:9056 [inline]
>  __netdev_update_features+0x88d/0x1360 net/core/dev.c:9187
>  netdev_change_features+0x61/0xb0 net/core/dev.c:9259
>  bond_compute_features+0x502/0xa00 drivers/net/bonding/bond_main.c:1188
>  bond_slave_netdev_event drivers/net/bonding/bond_main.c:3237 [inline]
>  bond_netdev_event+0x81f/0xb30 drivers/net/bonding/bond_main.c:3277
>  notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
>  call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2027
>  call_netdevice_notifiers_extack net/core/dev.c:2039 [inline]
>  call_netdevice_notifiers net/core/dev.c:2053 [inline]
>  netdev_features_change net/core/dev.c:1443 [inline]
>  netdev_sync_lower_features net/core/dev.c:9056 [inline]
>  __netdev_update_features+0x88d/0x1360 net/core/dev.c:9187
>  netdev_change_features+0x61/0xb0 net/core/dev.c:9259
>  bond_compute_features+0x502/0xa00 drivers/net/bonding/bond_main.c:1188
>  bond_slave_netdev_event drivers/net/bonding/bond_main.c:3237 [inline]
>  bond_netdev_event+0x81f/0xb30 drivers/net/bonding/bond_main.c:3277
> Lost 627 message(s)!
> ---[ end trace 203af1b41d4d3a41 ]---
> RIP: 0010:pvclock_clocksource_read+0x21/0x510 arch/x86/kernel/pvclock.c:68
> Code: 2e 0f 1f 84 00 00 00 00 00 48 ba 00 00 00 00 00 fc ff df 48 89 f8 41 57 48 c1 e8 03 41 56 41 55 41 54 4c 8d 67 03 55 4c 89 e1 <53> 48 c1 e9 03 48 89 fb 48 83 ec 58 0f b6 04 10 0f b6 14 11 48 89
> RSP: 0018:ffffc90016598000 EFLAGS: 00010806
> RAX: 1ffffffff17cec00 RBX: ffff8880ae620dc0 RCX: ffffffff8be76003
> RDX: dffffc0000000000 RSI: 0000000000000001 RDI: ffffffff8be76000
> RBP: ffff888059596380 R08: 0000000000000001 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff8be76003
> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> FS:  00007f3e110c1700(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffffc90016597ff8 CR3: 000000005d14d000 CR4: 00000000001406f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

#syz dup: BUG: stack guard page was hit in deref_stack_reg
