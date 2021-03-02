Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0417C32A370
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 16:17:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446368AbhCBI5U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 03:57:20 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:46241 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349109AbhCBILu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 03:11:50 -0500
Received: by mail-il1-f197.google.com with SMTP id j5so13959854ila.13
        for <netdev@vger.kernel.org>; Tue, 02 Mar 2021 00:10:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=lENl+ygXfuI4U13OijQQtdYBATbbeyHGFqkfZhZDnSQ=;
        b=silG04dlyRNA78t2j4LoqFKNTJV4pcNVyH0AnoxeY0qhyfRcnPTo092SGI78E1CM68
         +wgJCRgpkKKRqNnFjyWztX0hEv3o0d5kCKt+Q9XLC+UQ+1xqhGqS7CreIs4eHIcif2R7
         xVw4/TNDQEhYJFQ0dz0vSURr7wUXP0b+7cDo58Sb92TxPmeXHpFu47hW/Kg+u/t+rUEX
         xuBap1dLkESSPi00ZGt2IOoUvu64TmUBXxhM2a13aPEyvQ8ElEHj3MJeSVlgRYhSvRuy
         i7GiloEn+rZu8/qA8JsMLYwYo6j55B8ccdYNEn198gnI4piIs89SJkX4DJsfqg2dnnIC
         E3YQ==
X-Gm-Message-State: AOAM532CQtHOKNKaRzLylpfG32UnwEsa4+LqK2qgPZoc47n4+hzdnvkz
        7MgGt3LlpYKoXgrfEz06/kgU/UnBLdxOFLz/ZthGL1w5MeBZ
X-Google-Smtp-Source: ABdhPJz9hMN7MbhVTN4o1FQtNf/QBqaBIrou910FUJeAatGukIkJSmIeJUToitSIHraJd1vfTd8VjMZ9I/UTCz1k15io7LgX8bP6
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:4a7:: with SMTP id e7mr16621500ils.19.1614672622077;
 Tue, 02 Mar 2021 00:10:22 -0800 (PST)
Date:   Tue, 02 Mar 2021 00:10:22 -0800
In-Reply-To: <00000000000039404305bc049fa5@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000114a1905bc89445d@google.com>
Subject: Re: BUG: soft lockup in ieee80211_tasklet_handler
From:   syzbot <syzbot+27df43cf7ae73de7d8ee@syzkaller.appspotmail.com>
To:     davem@davemloft.net, hdanton@sina.com, johannes@sipsolutions.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    7a7fd0de Merge branch 'kmap-conversion-for-5.12' of git://..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14df34ead00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e0da2d01cc636e2c
dashboard link: https://syzkaller.appspot.com/bug?extid=27df43cf7ae73de7d8ee
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=154a476cd00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1152fb82d00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+27df43cf7ae73de7d8ee@syzkaller.appspotmail.com

watchdog: BUG: soft lockup - CPU#0 stuck for 123s! [syz-executor290:22312]
Modules linked in:
irq event stamp: 18402725
hardirqs last  enabled at (18402724): [<ffffffff89200d42>] asm_sysvec_irq_work+0x12/0x20 arch/x86/include/asm/idtentry.h:658
hardirqs last disabled at (18402725): [<ffffffff8902dd0b>] sysvec_apic_timer_interrupt+0xb/0xc0 arch/x86/kernel/apic/apic.c:1100
softirqs last  enabled at (18165196): [<ffffffff8144d934>] invoke_softirq kernel/softirq.c:221 [inline]
softirqs last  enabled at (18165196): [<ffffffff8144d934>] __irq_exit_rcu kernel/softirq.c:422 [inline]
softirqs last  enabled at (18165196): [<ffffffff8144d934>] irq_exit_rcu+0x134/0x200 kernel/softirq.c:434
softirqs last disabled at (18165199): [<ffffffff8144d934>] invoke_softirq kernel/softirq.c:221 [inline]
softirqs last disabled at (18165199): [<ffffffff8144d934>] __irq_exit_rcu kernel/softirq.c:422 [inline]
softirqs last disabled at (18165199): [<ffffffff8144d934>] irq_exit_rcu+0x134/0x200 kernel/softirq.c:434
CPU: 0 PID: 22312 Comm: syz-executor290 Not tainted 5.12.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:write_comp_data kernel/kcov.c:218 [inline]
RIP: 0010:__sanitizer_cov_trace_switch+0x63/0xf0 kernel/kcov.c:320
Code: 4d 8b 10 31 c9 65 4c 8b 24 25 00 f0 01 00 4d 85 d2 74 6b 4c 89 e6 bf 03 00 00 00 4c 8b 4c 24 20 49 8b 6c c8 10 e8 2d ff ff ff <84> c0 74 47 49 8b 84 24 b8 14 00 00 41 8b bc 24 b4 14 00 00 48 8b
RSP: 0018:ffffc900000078d8 EFLAGS: 00000246
RAX: 0000000000000000 RBX: 0000000000000003 RCX: 0000000000000006
RDX: 0000000000000000 RSI: ffff88801c370000 RDI: 0000000000000003
RBP: 00000000000000b0 R08: ffffffff8a84bea0 R09: ffffffff885fcfcf
R10: 0000000000000008 R11: 0000000000000080 R12: ffff88801c370000
R13: 0000000000000080 R14: ffff888012b6a450 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000004d0110 CR3: 0000000027282000 CR4: 0000000000350ef0
Call Trace:
 <IRQ>
 ieee80211_rx_h_mgmt net/mac80211/rx.c:3588 [inline]
 ieee80211_rx_handlers+0x89ef/0xae60 net/mac80211/rx.c:3793
 ieee80211_invoke_rx_handlers net/mac80211/rx.c:3823 [inline]
 ieee80211_prepare_and_rx_handle+0x22ad/0x5070 net/mac80211/rx.c:4537
 __ieee80211_rx_handle_packet net/mac80211/rx.c:4635 [inline]
 ieee80211_rx_list+0x930/0x2680 net/mac80211/rx.c:4819
 ieee80211_rx_napi+0xf7/0x3d0 net/mac80211/rx.c:4842
 ieee80211_rx include/net/mac80211.h:4524 [inline]
 ieee80211_tasklet_handler+0xd4/0x130 net/mac80211/main.c:235
 tasklet_action_common.constprop.0+0x1d7/0x2d0 kernel/softirq.c:557
 __do_softirq+0x29b/0x9f6 kernel/softirq.c:345
 invoke_softirq kernel/softirq.c:221 [inline]
 __irq_exit_rcu kernel/softirq.c:422 [inline]
 irq_exit_rcu+0x134/0x200 kernel/softirq.c:434
 sysvec_apic_timer_interrupt+0x93/0xc0 arch/x86/kernel/apic/apic.c:1100
 </IRQ>
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:632
RIP: 0010:mm_update_next_owner+0x432/0x7a0 kernel/exit.c:388
Code: 8d ad b0 fb ff ff 48 81 fd 50 c8 cb 8b 0f 84 65 01 00 00 e8 90 e6 2e 00 48 8d bd dc fb ff ff 48 89 f8 48 c1 e8 03 0f b6 14 18 <48> 89 f8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 b5 02 00 00 44
RSP: 0018:ffffc9000ab77b18 EFLAGS: 00000217
RAX: 1ffff110041046f5 RBX: dffffc0000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff814470e0 RDI: ffff8880208237ac
RBP: ffff888020823bd0 R08: 0000000000000000 R09: ffffffff8bc0a083
R10: ffffffff8144711f R11: 0000000000000001 R12: ffff888018b00000
R13: ffff888020823780 R14: 0000000000200000 R15: ffff888011520010
 exit_mm kernel/exit.c:500 [inline]
 do_exit+0xb02/0x2a60 kernel/exit.c:812
 do_group_exit+0x125/0x310 kernel/exit.c:922
 get_signal+0x42c/0x2100 kernel/signal.c:2773
 arch_do_signal_or_restart+0x2a8/0x1eb0 arch/x86/kernel/signal.c:811
 handle_signal_work kernel/entry/common.c:147 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
 exit_to_user_mode_prepare+0x148/0x250 kernel/entry/common.c:208
 __syscall_exit_to_user_mode_work kernel/entry/common.c:290 [inline]
 syscall_exit_to_user_mode+0x19/0x50 kernel/entry/common.c:301
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x453dd9
Code: Unable to access opcode bytes at RIP 0x453daf.
RSP: 002b:00007fcbbf2d5218 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: fffffffffffffe00 RBX: 00000000004d8268 RCX: 0000000000453dd9
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00000000004d8268
RBP: 00000000004d8260 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004d826c
R13: 00007ffe178897df R14: 00007fcbbf2d5300 R15: 0000000000022000
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 PID: 22313 Comm: syz-executor290 Not tainted 5.12.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:queued_write_lock_slowpath+0x131/0x270 kernel/locking/qrwlock.c:76
Code: 00 00 00 00 fc ff df 49 01 c7 41 83 c6 03 41 0f b6 07 41 38 c6 7c 08 84 c0 0f 85 fe 00 00 00 8b 03 3d 00 01 00 00 74 19 f3 90 <41> 0f b6 07 41 38 c6 7c ec 84 c0 74 e8 48 89 df e8 8a 5c 5d 00 eb
RSP: 0018:ffffc9000a37fa60 EFLAGS: 00000006
RAX: 0000000000000300 RBX: ffffffff8bc0a080 RCX: ffffffff8159ecfa
RDX: fffffbfff1781411 RSI: 0000000000000004 RDI: ffffffff8bc0a080
RBP: 00000000000000ff R08: 0000000000000001 R09: ffffffff8bc0a083
R10: fffffbfff1781410 R11: 0000000000000000 R12: 1ffff9200146ff4d
R13: ffffffff8bc0a084 R14: 0000000000000003 R15: fffffbfff1781410
FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000004a0d38 CR3: 0000000027282000 CR4: 0000000000350ee0
Call Trace:
 queued_write_lock include/asm-generic/qrwlock.h:97 [inline]
 do_raw_write_lock+0x1ce/0x280 kernel/locking/spinlock_debug.c:207
 exit_notify kernel/exit.c:667 [inline]
 do_exit+0xc4a/0x2a60 kernel/exit.c:845
 do_group_exit+0x125/0x310 kernel/exit.c:922
 get_signal+0x42c/0x2100 kernel/signal.c:2773
 arch_do_signal_or_restart+0x2a8/0x1eb0 arch/x86/kernel/signal.c:811
 handle_signal_work kernel/entry/common.c:147 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
 exit_to_user_mode_prepare+0x148/0x250 kernel/entry/common.c:208
 __syscall_exit_to_user_mode_work kernel/entry/common.c:290 [inline]
 syscall_exit_to_user_mode+0x19/0x50 kernel/entry/common.c:301
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x453dd9
Code: Unable to access opcode bytes at RIP 0x453daf.
RSP: 002b:00007fcbbf2b4218 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: fffffffffffffe00 RBX: 00000000004d8278 RCX: 0000000000453dd9
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00000000004d8278
RBP: 00000000004d8270 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004d827c
R13: 00007ffe178897df R14: 00007fcbbf2b4300 R15: 0000000000022000

