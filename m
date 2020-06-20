Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEC36202345
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 12:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728019AbgFTK5T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 06:57:19 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:57199 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727065AbgFTK5O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jun 2020 06:57:14 -0400
Received: by mail-io1-f72.google.com with SMTP id l22so8646895iob.23
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 03:57:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=8GDLcHKAWL6B36TT6Nf4rJzMiJsHjfM/kCOmAs5JEyA=;
        b=Bp8e81OuNkec09IyxMH+cmn3IaJv8LRzcH/uGKFmN9pX3dFvkcfm3qEzUxCCZLvBtC
         Qb7+uAEDYDI6jgEpEBFBZMcV8+28qUpjnKdDSqvupGkVrEWFEPEWWA13mC0+5ptFmO1z
         sn0x0pHnjPN3vFgXiGoRGsJamyvROVi9TjuxnaYSTVWwNpO87xefBbPBmbzBs4X5AaWI
         csMvXBzomyn1WDjfs+JrPbXuLwQ/9zrg2QuoCfR4JAY88s1+YPL2eez5mGwA7gbrRqPp
         pSQ6zeEVXxerfr0K5RF5/XePlymy88LQChSkYRVx4Xp7au0mOiYPEgWMVqdn8t5O5LO/
         RC3Q==
X-Gm-Message-State: AOAM532WaMsGGTxQyu+wLIA3LAF9e6NDQIRJ9S4QLx89v+r/6YaAJf14
        y+lVD1+UDjAYMQj3n5GscC/LokO6NqB3LVyXqTeY05Ygg/2b
X-Google-Smtp-Source: ABdhPJzw9wh1dy1bqFQBiniZPWvy/ZxKf3U9KDNXoj4Sw1dPBRj2fhfGeQ31pI0G7ZHvkGYXVWMCVTFlfBqqtRBQ79v+km0Ub4N2
MIME-Version: 1.0
X-Received: by 2002:a6b:9143:: with SMTP id t64mr3764177iod.55.1592650632570;
 Sat, 20 Jun 2020 03:57:12 -0700 (PDT)
Date:   Sat, 20 Jun 2020 03:57:12 -0700
In-Reply-To: <0000000000006bf03c05a86205bb@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000034ad2805a881df44@google.com>
Subject: Re: INFO: trying to register non-static key in ath9k_htc_rxep
From:   syzbot <syzbot+4d2d56175b934b9a7bf9@syzkaller.appspotmail.com>
To:     andreyknvl@google.com, ath9k-devel@qca.qualcomm.com,
        davem@davemloft.net, kuba@kernel.org, kvalo@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    f8f02d5c USB: OTG: rename product list of devices
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git usb-testing
console output: https://syzkaller.appspot.com/x/log.txt?x=15fd18a5100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f1981539b6376b73
dashboard link: https://syzkaller.appspot.com/bug?extid=4d2d56175b934b9a7bf9
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14519481100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=110318e9100000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+4d2d56175b934b9a7bf9@syzkaller.appspotmail.com

INFO: trying to register non-static key.
the code is fine but needs lockdep annotation.
turning off the locking correctness validator.
CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.8.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0xf6/0x16e lib/dump_stack.c:118
 assign_lock_key kernel/locking/lockdep.c:894 [inline]
 register_lock_class+0x1228/0x16d0 kernel/locking/lockdep.c:1206
 __lock_acquire+0x101/0x6270 kernel/locking/lockdep.c:4259
 lock_acquire+0x18b/0x7c0 kernel/locking/lockdep.c:4959
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
 _raw_spin_lock_irqsave+0x32/0x50 kernel/locking/spinlock.c:159
 ath9k_htc_rxep+0x31/0x210 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c:1128
 ath9k_htc_rx_msg+0x2d9/0xb00 drivers/net/wireless/ath/ath9k/htc_hst.c:459
 ath9k_hif_usb_rx_stream drivers/net/wireless/ath/ath9k/hif_usb.c:638 [inline]
 ath9k_hif_usb_rx_cb+0xc76/0x1050 drivers/net/wireless/ath/ath9k/hif_usb.c:671
 __usb_hcd_giveback_urb+0x29a/0x550 drivers/usb/core/hcd.c:1650
 usb_hcd_giveback_urb+0x368/0x420 drivers/usb/core/hcd.c:1716
 dummy_timer+0x125e/0x32b4 drivers/usb/gadget/udc/dummy_hcd.c:1967
 call_timer_fn+0x1ac/0x6e0 kernel/time/timer.c:1404
 expire_timers kernel/time/timer.c:1449 [inline]
 __run_timers kernel/time/timer.c:1773 [inline]
 __run_timers kernel/time/timer.c:1740 [inline]
 run_timer_softirq+0x5e5/0x14c0 kernel/time/timer.c:1786
 __do_softirq+0x21e/0x996 kernel/softirq.c:292
 asm_call_on_stack+0xf/0x20 arch/x86/entry/entry_64.S:711
 </IRQ>
 __run_on_irqstack arch/x86/include/asm/irq_stack.h:22 [inline]
 run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:48 [inline]
 do_softirq_own_stack+0x109/0x140 arch/x86/kernel/irq_64.c:77
 invoke_softirq kernel/softirq.c:387 [inline]
 __irq_exit_rcu kernel/softirq.c:417 [inline]
 irq_exit_rcu+0x16f/0x1a0 kernel/softirq.c:429
 sysvec_apic_timer_interrupt+0xd3/0x1b0 arch/x86/kernel/apic/apic.c:1091
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:596
RIP: 0010:native_irq_disable arch/x86/include/asm/irqflags.h:49 [inline]
RIP: 0010:arch_local_irq_disable arch/x86/include/asm/irqflags.h:89 [inline]
RIP: 0010:acpi_safe_halt drivers/acpi/processor_idle.c:112 [inline]
RIP: 0010:acpi_safe_halt+0x72/0x90 drivers/acpi/processor_idle.c:108
Code: 74 06 5b e9 c0 32 9f fb e8 bb 32 9f fb e8 c6 96 a4 fb e9 0c 00 00 00 e8 ac 32 9f fb 0f 00 2d 45 6e 84 00 e8 a0 32 9f fb fb f4 <fa> e8 b8 94 a4 fb 5b e9 92 32 9f fb 48 89 df e8 7a e1 c8 fb eb ab
RSP: 0018:ffff8881da22fc60 EFLAGS: 00000293
RAX: ffff8881da213200 RBX: 0000000000000000 RCX: 1ffffffff1014efa
RDX: 0000000000000000 RSI: ffffffff85a03aa0 RDI: ffff8881da213a38
RBP: ffff8881d8d2a864 R08: 0000000000000000 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000000 R12: ffff8881d8d2a864
R13: 1ffff1103b445f96 R14: ffff8881d8d2a865 R15: 0000000000000001
 acpi_idle_do_entry+0xa9/0xe0 drivers/acpi/processor_idle.c:525
 acpi_idle_enter+0x42b/0xac0 drivers/acpi/processor_idle.c:651
 cpuidle_enter_state+0xdb/0xc20 drivers/cpuidle/cpuidle.c:234
 cpuidle_enter+0x4a/0xa0 drivers/cpuidle/cpuidle.c:345
 call_cpuidle kernel/sched/idle.c:117 [inline]
 cpuidle_idle_call kernel/sched/idle.c:207 [inline]
 do_idle+0x3c2/0x500 kernel/sched/idle.c:269
 cpu_startup_entry+0x14/0x20 kernel/sched/idle.c:365
 start_secondary+0x294/0x370 arch/x86/kernel/smpboot.c:268
 secondary_startup_64+0xb6/0xc0 arch/x86/kernel/head_64.S:243
BUG: unable to handle page fault for address: ffffffffffffffc8
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 7226067 P4D 7226067 PUD 7228067 PMD 0 
Oops: 0000 [#1] SMP KASAN
CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.8.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:ath9k_htc_rxep+0xb5/0x210 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c:1130
Code: 8b 43 38 48 8d 58 c8 49 39 c4 0f 84 ee 00 00 00 e8 70 56 62 fe 48 89 d8 48 c1 e8 03 0f b6 04 28 84 c0 74 06 0f 8e 0a 01 00 00 <44> 0f b6 3b 31 ff 44 89 fe e8 ad 57 62 fe 45 84 ff 75 a8 e8 43 56
RSP: 0018:ffff8881db3098b0 EFLAGS: 00010046
RAX: 0000000000000000 RBX: ffffffffffffffc8 RCX: ffffffff81274370
RDX: 0000000000000000 RSI: ffffffff82dd16d0 RDI: ffff8881db309820
RBP: dffffc0000000000 R08: 0000000000000004 R09: ffffed103b661305
R10: 0000000000000003 R11: ffffed103b661304 R12: ffff8881cd69b538
R13: ffff8881cd69b100 R14: ffff8881cd69b548 R15: ffffed10392ce210
FS:  0000000000000000(0000) GS:ffff8881db300000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffffffffc8 CR3: 00000001cf9f6000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
 ath9k_htc_rx_msg+0x2d9/0xb00 drivers/net/wireless/ath/ath9k/htc_hst.c:459
 ath9k_hif_usb_rx_stream drivers/net/wireless/ath/ath9k/hif_usb.c:638 [inline]
 ath9k_hif_usb_rx_cb+0xc76/0x1050 drivers/net/wireless/ath/ath9k/hif_usb.c:671
 __usb_hcd_giveback_urb+0x29a/0x550 drivers/usb/core/hcd.c:1650
 usb_hcd_giveback_urb+0x368/0x420 drivers/usb/core/hcd.c:1716
 dummy_timer+0x125e/0x32b4 drivers/usb/gadget/udc/dummy_hcd.c:1967
 call_timer_fn+0x1ac/0x6e0 kernel/time/timer.c:1404
 expire_timers kernel/time/timer.c:1449 [inline]
 __run_timers kernel/time/timer.c:1773 [inline]
 __run_timers kernel/time/timer.c:1740 [inline]
 run_timer_softirq+0x5e5/0x14c0 kernel/time/timer.c:1786
 __do_softirq+0x21e/0x996 kernel/softirq.c:292
 asm_call_on_stack+0xf/0x20 arch/x86/entry/entry_64.S:711
 </IRQ>
 __run_on_irqstack arch/x86/include/asm/irq_stack.h:22 [inline]
 run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:48 [inline]
 do_softirq_own_stack+0x109/0x140 arch/x86/kernel/irq_64.c:77
 invoke_softirq kernel/softirq.c:387 [inline]
 __irq_exit_rcu kernel/softirq.c:417 [inline]
 irq_exit_rcu+0x16f/0x1a0 kernel/softirq.c:429
 sysvec_apic_timer_interrupt+0xd3/0x1b0 arch/x86/kernel/apic/apic.c:1091
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:596
RIP: 0010:native_irq_disable arch/x86/include/asm/irqflags.h:49 [inline]
RIP: 0010:arch_local_irq_disable arch/x86/include/asm/irqflags.h:89 [inline]
RIP: 0010:acpi_safe_halt drivers/acpi/processor_idle.c:112 [inline]
RIP: 0010:acpi_safe_halt+0x72/0x90 drivers/acpi/processor_idle.c:108
Code: 74 06 5b e9 c0 32 9f fb e8 bb 32 9f fb e8 c6 96 a4 fb e9 0c 00 00 00 e8 ac 32 9f fb 0f 00 2d 45 6e 84 00 e8 a0 32 9f fb fb f4 <fa> e8 b8 94 a4 fb 5b e9 92 32 9f fb 48 89 df e8 7a e1 c8 fb eb ab
RSP: 0018:ffff8881da22fc60 EFLAGS: 00000293
RAX: ffff8881da213200 RBX: 0000000000000000 RCX: 1ffffffff1014efa
RDX: 0000000000000000 RSI: ffffffff85a03aa0 RDI: ffff8881da213a38
RBP: ffff8881d8d2a864 R08: 0000000000000000 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000000 R12: ffff8881d8d2a864
R13: 1ffff1103b445f96 R14: ffff8881d8d2a865 R15: 0000000000000001
 acpi_idle_do_entry+0xa9/0xe0 drivers/acpi/processor_idle.c:525
 acpi_idle_enter+0x42b/0xac0 drivers/acpi/processor_idle.c:651
 cpuidle_enter_state+0xdb/0xc20 drivers/cpuidle/cpuidle.c:234
 cpuidle_enter+0x4a/0xa0 drivers/cpuidle/cpuidle.c:345
 call_cpuidle kernel/sched/idle.c:117 [inline]
 cpuidle_idle_call kernel/sched/idle.c:207 [inline]
 do_idle+0x3c2/0x500 kernel/sched/idle.c:269
 cpu_startup_entry+0x14/0x20 kernel/sched/idle.c:365
 start_secondary+0x294/0x370 arch/x86/kernel/smpboot.c:268
 secondary_startup_64+0xb6/0xc0 arch/x86/kernel/head_64.S:243
Modules linked in:
CR2: ffffffffffffffc8
---[ end trace 5a637b710bbf1999 ]---
RIP: 0010:ath9k_htc_rxep+0xb5/0x210 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c:1130
Code: 8b 43 38 48 8d 58 c8 49 39 c4 0f 84 ee 00 00 00 e8 70 56 62 fe 48 89 d8 48 c1 e8 03 0f b6 04 28 84 c0 74 06 0f 8e 0a 01 00 00 <44> 0f b6 3b 31 ff 44 89 fe e8 ad 57 62 fe 45 84 ff 75 a8 e8 43 56
RSP: 0018:ffff8881db3098b0 EFLAGS: 00010046
RAX: 0000000000000000 RBX: ffffffffffffffc8 RCX: ffffffff81274370
RDX: 0000000000000000 RSI: ffffffff82dd16d0 RDI: ffff8881db309820
RBP: dffffc0000000000 R08: 0000000000000004 R09: ffffed103b661305
R10: 0000000000000003 R11: ffffed103b661304 R12: ffff8881cd69b538
R13: ffff8881cd69b100 R14: ffff8881cd69b548 R15: ffffed10392ce210
FS:  0000000000000000(0000) GS:ffff8881db300000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffffffffc8 CR3: 00000001cf9f6000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400

