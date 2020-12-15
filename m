Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46C392DA732
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 05:43:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726009AbgLOEnI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 23:43:08 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:41136 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbgLOEmv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 23:42:51 -0500
Received: by mail-il1-f199.google.com with SMTP id f19so15485253ilk.8
        for <netdev@vger.kernel.org>; Mon, 14 Dec 2020 20:42:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=LqWaNQjCimm2ca6xInyGr6oMtdoqCwNA95xg3NR0eBs=;
        b=RW3Q52Itg1YZP/6L6GeHqFBFyr/MTFxwHAyvJ5bSQuPYDWEvlQn/nWSGiSdphgSQ7S
         ErbtiM1PKmw9DfqG/8yNfdeRNy/Qrcrtya4ANqMhxGappg0Ll5nD/kS7tO6DyxTdfMrk
         5MwdX2dwtLvJAIK0YdmGxP50nzzGiH9yQzDzJuaijL/oXGX5hEo2TS+ZqzHAcumy9BvC
         tHUKGgSQrVVZ+BB25s3xrAMzpvbtQB1uuSwsJcF2mOs10Mcrp5/cixaAN+QW7Aoum/ET
         QnG66J3LT0wIIAfauYQFXmtRUtTMGOXPyzqXia5dnmhXlCqNX2JEdzdL2XgJcq/VWn4Z
         yGXg==
X-Gm-Message-State: AOAM532xbR9M/XWuC0NN1G9qLDHja/c+MPang1S/GAwbqTLWMi5FSRxy
        zPkhwFl7kxtBreyMsdPtRH/ecIfMPqF4aWtAbgTV3MEQWL5S
X-Google-Smtp-Source: ABdhPJyZaXjecLYYIfdizclwvPhLlMvic1ogV9rB8egV0WLu+dS+5IBDd8HMqFEYG5EComEOdlQBCvQG+YMg1T+r9Zc60hGQDfta
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:5ab:: with SMTP id k11mr32494608ils.189.1608007330245;
 Mon, 14 Dec 2020 20:42:10 -0800 (PST)
Date:   Mon, 14 Dec 2020 20:42:10 -0800
In-Reply-To: <00000000000056307e05b08a4693@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b7334f05b67961a3@google.com>
Subject: Re: BUG: soft lockup in mac80211_hwsim_beacon
From:   syzbot <syzbot+d6219cf21f26bdfcc22e@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johannes@sipsolutions.net,
        keescook@chromium.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        mingo@kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    2c85ebc5 Linux 5.10
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=148fcc13500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8aff533d6c635e6
dashboard link: https://syzkaller.appspot.com/bug?extid=d6219cf21f26bdfcc22e
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1102527b500000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d6219cf21f26bdfcc22e@syzkaller.appspotmail.com

watchdog: BUG: soft lockup - CPU#1 stuck for 134s! [syz-executor.4:10844]
Modules linked in:
irq event stamp: 16682675
hardirqs last  enabled at (16682674): [<ffffffff89000d42>] asm_sysvec_irq_work+0x12/0x20 arch/x86/include/asm/idtentry.h:657
hardirqs last disabled at (16682675): [<ffffffff88e55e2c>] sysvec_apic_timer_interrupt+0xc/0x100 arch/x86/kernel/apic/apic.c:1091
softirqs last  enabled at (11305198): [<ffffffff89000eaf>] asm_call_irq_on_stack+0xf/0x20
softirqs last disabled at (11305201): [<ffffffff89000eaf>] asm_call_irq_on_stack+0xf/0x20
CPU: 1 PID: 10844 Comm: syz-executor.4 Not tainted 5.10.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__iterate_interfaces+0x14b/0x520 net/mac80211/util.c:786
Code: 31 ff 44 89 fe e8 05 a8 1d f9 45 85 ff 0f 84 9a 01 00 00 e8 a7 af 1d f9 48 8d bb 50 06 00 00 48 89 f8 48 c1 e8 03 0f b6 04 28 <84> c0 74 08 3c 03 0f 8e a8 03 00 00 8b 83 50 06 00 00 31 ff 83 e0
RSP: 0018:ffffc90000d90a68 EFLAGS: 00000212
RAX: 0000000000000000 RBX: ffff8880276ccc00 RCX: ffffffff885254eb
RDX: ffff8880213c3480 RSI: ffffffff885254f9 RDI: ffff8880276cd250
RBP: dffffc0000000000 R08: 0000000000000000 R09: ffffffff8ebb0667
R10: 0000000000000000 R11: 0000000000000000 R12: ffff8880276cde18
R13: 0000000000000000 R14: ffff88803d37a5b8 R15: 0000000000000002
FS:  0000000000000000(0000) GS:ffff8880b9f00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000016b9e60 CR3: 000000003ca03000 CR4: 0000000000350ee0
Call Trace:
 <IRQ>
 ieee80211_iterate_active_interfaces_atomic+0x8d/0x170 net/mac80211/util.c:828
 mac80211_hwsim_addr_match+0x128/0x180 drivers/net/wireless/mac80211_hwsim.c:1060
 mac80211_hwsim_tx_frame_no_nl.isra.0+0xb3d/0x1330 drivers/net/wireless/mac80211_hwsim.c:1498
 mac80211_hwsim_tx_frame+0x14f/0x1e0 drivers/net/wireless/mac80211_hwsim.c:1705
 mac80211_hwsim_beacon_tx+0x4ba/0x910 drivers/net/wireless/mac80211_hwsim.c:1759
 __iterate_interfaces+0x1e5/0x520 net/mac80211/util.c:792
 ieee80211_iterate_active_interfaces_atomic+0x8d/0x170 net/mac80211/util.c:828
 mac80211_hwsim_beacon+0xd5/0x1a0 drivers/net/wireless/mac80211_hwsim.c:1782
 __run_hrtimer kernel/time/hrtimer.c:1519 [inline]
 __hrtimer_run_queues+0x693/0xea0 kernel/time/hrtimer.c:1583
 hrtimer_run_softirq+0x17b/0x360 kernel/time/hrtimer.c:1600
 __do_softirq+0x2a0/0x9f6 kernel/softirq.c:298
 asm_call_irq_on_stack+0xf/0x20
 </IRQ>
 __run_on_irqstack arch/x86/include/asm/irq_stack.h:26 [inline]
 run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:77 [inline]
 do_softirq_own_stack+0xaa/0xd0 arch/x86/kernel/irq_64.c:77
 invoke_softirq kernel/softirq.c:393 [inline]
 __irq_exit_rcu kernel/softirq.c:423 [inline]
 irq_exit_rcu+0x132/0x200 kernel/softirq.c:435
 sysvec_apic_timer_interrupt+0x4d/0x100 arch/x86/kernel/apic/apic.c:1091
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:631
RIP: 0010:mm_update_next_owner+0x432/0x7a0 kernel/exit.c:387
Code: 8d ad 00 fc ff ff 48 81 fd 80 b3 09 8b 0f 84 65 01 00 00 e8 00 01 2e 00 48 8d bd 24 fc ff ff 48 89 f8 48 c1 e8 03 0f b6 14 18 <48> 89 f8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 b5 02 00 00 44
RSP: 0018:ffffc90001bafb28 EFLAGS: 00000213
RAX: 1ffff110035d4004 RBX: dffffc0000000000 RCX: ffffffff814203df
RDX: 0000000000000000 RSI: ffffffff814203a0 RDI: ffff88801aea0024
RBP: ffff88801aea0400 R08: 0000000000000001 R09: ffffffff8b00a083
R10: 0000000000000000 R11: 0000000000000000 R12: ffff88802f0c6c00
R13: ffff88801aea0000 R14: 0000000000200000 R15: ffff888140758010
 exit_mm kernel/exit.c:485 [inline]
 do_exit+0xa6a/0x29b0 kernel/exit.c:796
 do_group_exit+0x125/0x310 kernel/exit.c:906
 get_signal+0x42a/0x1f10 kernel/signal.c:2758
 arch_do_signal+0x82/0x2390 arch/x86/kernel/signal.c:811
 exit_to_user_mode_loop kernel/entry/common.c:161 [inline]
 exit_to_user_mode_prepare+0x100/0x1a0 kernel/entry/common.c:191
 irqentry_exit_to_user_mode+0x5/0x30 kernel/entry/common.c:279
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:631
RIP: 0033:0x45e159
Code: Unable to access opcode bytes at RIP 0x45e12f.
RSP: 002b:00007fabdf0dac68 EFLAGS: 00000246
RAX: 0000000020ffc000 RBX: 0000000000000006 RCX: 000000000045e159
RDX: 0000000000000000 RSI: 0000000000003000 RDI: 0000000020ffc000
RBP: 000000000119c080 R08: 0000000000000004 R09: 0000000000000000
R10: 0000000000000011 R11: 0000000000000246 R12: 000000000119c034
R13: 00007ffd91092c1f R14: 00007fabdf0db9c0 R15: 000000000119c034
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 PID: 10837 Comm: syz-executor.0 Not tainted 5.10.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:queued_write_lock_slowpath+0x131/0x270 kernel/locking/qrwlock.c:77
Code: 00 00 00 00 fc ff df 49 01 c7 41 83 c6 03 41 0f b6 07 41 38 c6 7c 08 84 c0 0f 85 fe 00 00 00 8b 03 3d 00 01 00 00 74 19 f3 90 <41> 0f b6 07 41 38 c6 7c ec 84 c0 74 e8 48 89 df e8 9a 9a 5a 00 eb
RSP: 0018:ffffc90001b7fa48 EFLAGS: 00000006
RAX: 0000000000000300 RBX: ffffffff8b00a080 RCX: ffffffff8156e6ba
RDX: fffffbfff1601411 RSI: 0000000000000004 RDI: ffffffff8b00a080
RBP: 00000000000000ff R08: 0000000000000001 R09: ffffffff8b00a083
R10: fffffbfff1601410 R11: 0000000000000000 R12: 1ffff9200036ff4a
R13: ffffffff8b00a084 R14: 0000000000000003 R15: fffffbfff1601410
FS:  0000000002f56940(0000) GS:ffff8880b9e00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f29a5e6adb8 CR3: 0000000011697000 CR4: 0000000000350ef0
Call Trace:
 queued_write_lock include/asm-generic/qrwlock.h:95 [inline]
 do_raw_write_lock+0x1ce/0x280 kernel/locking/spinlock_debug.c:207
 copy_process+0x3377/0x6e80 kernel/fork.c:2210
 kernel_clone+0xe7/0xab0 kernel/fork.c:2456
 __do_sys_clone+0xc8/0x110 kernel/fork.c:2573
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x460b29
Code: ff 48 85 f6 0f 84 37 8a fb ff 48 83 ee 10 48 89 4e 08 48 89 3e 48 89 d7 4c 89 c2 4d 89 c8 4c 8b 54 24 08 b8 38 00 00 00 0f 05 <48> 85 c0 0f 8c 0e 8a fb ff 74 01 c3 31 ed 48 f7 c7 00 00 01 00 75
RSP: 002b:00007ffdb57f41d8 EFLAGS: 00000202 ORIG_RAX: 0000000000000038
RAX: ffffffffffffffda RBX: 00007f29a5e6b700 RCX: 0000000000460b29
RDX: 00007f29a5e6b9d0 RSI: 00007f29a5e6adb0 RDI: 00000000003d0f00
RBP: 00007ffdb57f43f0 R08: 00007f29a5e6b700 R09: 00007f29a5e6b700
R10: 00007f29a5e6b9d0 R11: 0000000000000202 R12: 0000000000000000
R13: 00007ffdb57f428f R14: 00007f29a5e6b9c0 R15: 000000000119c37c

