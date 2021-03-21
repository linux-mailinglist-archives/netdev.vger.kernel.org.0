Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D36D33431CF
	for <lists+netdev@lfdr.de>; Sun, 21 Mar 2021 10:15:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbhCUJOm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 05:14:42 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:36263 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbhCUJOR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Mar 2021 05:14:17 -0400
Received: by mail-il1-f200.google.com with SMTP id s13so37687931ilp.3
        for <netdev@vger.kernel.org>; Sun, 21 Mar 2021 02:14:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=US+G0JD7S4KbKfyEdCMvtxWOJvg1sh/YqSXocgiRnxc=;
        b=WINt3dnDYZdRH6PJEVoj5QxU5bF5UH/tREwOCoWrnlUcpGla3AH7MRbtwQXBYqbHtU
         CcRN8pNYGH8kSLjZbMjSrvpBB0lG2cytwM7u9eqIwlagFSyIggo82F9tpLiot4NhmWV1
         Ucc20ZkaeVYOpMJsVC04uFxEsFq1KC4VLyEKwk+canhaWY91S+mfwhjIn1dMtR5rbRpV
         96FaYnkajiBvNTri/ZnEAzBkCZGKBndeV7DcnwjMn0SeBf3U4LQs7njpRUznYSMtjuL3
         rUGUyqW7DhTaQW8YHEOWZNY2nqeHHANbs/FaxrvMbMLl+UH6mgxiYOFt1g2vf9cnlKLZ
         /G4g==
X-Gm-Message-State: AOAM533XW03O+uqeuEedc2mTd0UD6ZKjSxPijPjqXeNvwjrKx84zNpiJ
        yT+36A3UuDxqMar+VocW7X/CechQRZzb2arxiNL41WO46exs
X-Google-Smtp-Source: ABdhPJyp1f0RNHgeM0tZ0oOF5rIeafuJM2e7h7oD94N0cDyed+OA07hH1lwH+cRSK3yAGQmOOvC0idSp9AR44uIWMIUa87q0UX/f
MIME-Version: 1.0
X-Received: by 2002:a02:c8d4:: with SMTP id q20mr7142133jao.90.1616318056565;
 Sun, 21 Mar 2021 02:14:16 -0700 (PDT)
Date:   Sun, 21 Mar 2021 02:14:16 -0700
In-Reply-To: <000000000000d9e4bb05ad9ffaef@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009b15a205be085f0f@google.com>
Subject: Re: [syzbot] KMSAN: uninit-value in skb_trim
From:   syzbot <syzbot+e4534e8c1c382508312c@syzkaller.appspotmail.com>
To:     ath9k-devel@qca.qualcomm.com, davem@davemloft.net,
        glider@google.com, kuba@kernel.org, kvalo@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        maria@vitanaturapr.com, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    29ad81a1 arch/x86: add missing include to sparsemem.h
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=16b7e7b2d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9c7da2160236454
dashboard link: https://syzkaller.appspot.com/bug?extid=e4534e8c1c382508312c
compiler:       Debian clang version 11.0.1-2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12897ef6d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=143ee4aad00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e4534e8c1c382508312c@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in skb_trim+0x1fa/0x280 net/core/skbuff.c:1927
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.11.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x21c/0x280 lib/dump_stack.c:120
 kmsan_report+0xfb/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x5f/0xa0 mm/kmsan/kmsan_instr.c:197
 skb_trim+0x1fa/0x280 net/core/skbuff.c:1927
 ath9k_htc_rx_msg+0x631/0x1f30 drivers/net/wireless/ath/ath9k/htc_hst.c:455
 ath9k_hif_usb_rx_stream drivers/net/wireless/ath/ath9k/hif_usb.c:647 [inline]
 ath9k_hif_usb_rx_cb+0x184e/0x1d20 drivers/net/wireless/ath/ath9k/hif_usb.c:680
 __usb_hcd_giveback_urb+0x6ff/0x930 drivers/usb/core/hcd.c:1656
 usb_hcd_giveback_urb+0x1cb/0x730 drivers/usb/core/hcd.c:1726
 dummy_timer+0xda7/0x74f0 drivers/usb/gadget/udc/dummy_hcd.c:1971
 call_timer_fn+0x7d/0x450 kernel/time/timer.c:1417
 expire_timers+0x328/0x6c0 kernel/time/timer.c:1462
 __run_timers+0x624/0x9e0 kernel/time/timer.c:1731
 run_timer_softirq+0x2d/0x50 kernel/time/timer.c:1744
 __do_softirq+0x1b9/0x715 kernel/softirq.c:343
 asm_call_irq_on_stack+0xf/0x20
 </IRQ>
 __run_on_irqstack arch/x86/include/asm/irq_stack.h:26 [inline]
 run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:77 [inline]
 do_softirq_own_stack+0x6e/0x90 arch/x86/kernel/irq_64.c:77
 invoke_softirq kernel/softirq.c:226 [inline]
 __irq_exit_rcu+0x22f/0x280 kernel/softirq.c:420
 irq_exit_rcu+0xe/0x10 kernel/softirq.c:432
 sysvec_apic_timer_interrupt+0x106/0x130 arch/x86/kernel/apic/apic.c:1100
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:647
RIP: 0010:native_irq_disable arch/x86/include/asm/irqflags.h:49 [inline]
RIP: 0010:arch_local_irq_disable arch/x86/include/asm/irqflags.h:89 [inline]
RIP: 0010:acpi_safe_halt drivers/acpi/processor_idle.c:111 [inline]
RIP: 0010:acpi_idle_do_entry drivers/acpi/processor_idle.c:516 [inline]
RIP: 0010:acpi_idle_enter+0x61d/0x760 drivers/acpi/processor_idle.c:647
Code: f7 d3 44 21 e3 48 85 db 0f 84 ec 00 00 00 4d 85 e4 0f 85 f4 00 00 00 e9 0c 00 00 00 e8 1c b5 3a fb 0f 00 2d 5f e7 5d 09 fb f4 <fa> e9 e0 00 00 00 84 c0 8b 7d b8 0f 45 7d 98 e8 8f 3b bc fb e9 e5
RSP: 0018:ffffffff91403b70 EFLAGS: 00000246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 000000023eaec040
RDX: ffffffff91431040 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffffff91403c08 R08: ffffffff86809bde R09: ffff88813fffa000
R10: 0000000000000002 R11: ffffffff91431040 R12: 0000000000000000
R13: ffff888102fa0064 R14: 0000000000000000 R15: ffffffff91431ab8
 cpuidle_enter_state+0x99e/0x1750 drivers/cpuidle/cpuidle.c:237
 cpuidle_enter+0xe3/0x170 drivers/cpuidle/cpuidle.c:351
 call_cpuidle kernel/sched/idle.c:158 [inline]
 cpuidle_idle_call kernel/sched/idle.c:239 [inline]
 do_idle+0x5df/0x790 kernel/sched/idle.c:299
 cpu_startup_entry+0x45/0x50 kernel/sched/idle.c:396
 rest_init+0x1c8/0x1f0 init/main.c:721
 arch_call_rest_init+0x13/0x15
 start_kernel+0xa17/0xbd8 init/main.c:1064
 x86_64_start_reservations+0x2a/0x2c arch/x86/kernel/head64.c:525
 x86_64_start_kernel+0x86/0x89 arch/x86/kernel/head64.c:506
 secondary_startup_64_no_verify+0xb0/0xbb

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
 kmsan_internal_poison_shadow+0x5c/0xf0 mm/kmsan/kmsan.c:104
 kmsan_slab_alloc+0x8d/0xe0 mm/kmsan/kmsan_hooks.c:76
 slab_alloc_node mm/slub.c:2907 [inline]
 __kmalloc_node_track_caller+0xa37/0x1430 mm/slub.c:4527
 __kmalloc_reserve net/core/skbuff.c:142 [inline]
 __alloc_skb+0x2f8/0xb30 net/core/skbuff.c:210
 __netdev_alloc_skb+0x450/0x7f0 net/core/skbuff.c:446
 __dev_alloc_skb include/linux/skbuff.h:2839 [inline]
 ath9k_hif_usb_rx_stream drivers/net/wireless/ath/ath9k/hif_usb.c:629 [inline]
 ath9k_hif_usb_rx_cb+0xe58/0x1d20 drivers/net/wireless/ath/ath9k/hif_usb.c:680
 __usb_hcd_giveback_urb+0x6ff/0x930 drivers/usb/core/hcd.c:1656
 usb_hcd_giveback_urb+0x1cb/0x730 drivers/usb/core/hcd.c:1726
 dummy_timer+0xda7/0x74f0 drivers/usb/gadget/udc/dummy_hcd.c:1971
 call_timer_fn+0x7d/0x450 kernel/time/timer.c:1417
 expire_timers+0x328/0x6c0 kernel/time/timer.c:1462
 __run_timers+0x624/0x9e0 kernel/time/timer.c:1731
 run_timer_softirq+0x2d/0x50 kernel/time/timer.c:1744
 __do_softirq+0x1b9/0x715 kernel/softirq.c:343
=====================================================
=====================================================
BUG: KMSAN: uninit-value in skb_trim+0x1fa/0x280 net/core/skbuff.c:1927
CPU: 0 PID: 0 Comm: swapper/0 Tainted: G    B             5.11.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x21c/0x280 lib/dump_stack.c:120
 kmsan_report+0xfb/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x5f/0xa0 mm/kmsan/kmsan_instr.c:197
 skb_trim+0x1fa/0x280 net/core/skbuff.c:1927
 ath9k_htc_rx_msg+0x631/0x1f30 drivers/net/wireless/ath/ath9k/htc_hst.c:455
 ath9k_hif_usb_rx_stream drivers/net/wireless/ath/ath9k/hif_usb.c:647 [inline]
 ath9k_hif_usb_rx_cb+0x184e/0x1d20 drivers/net/wireless/ath/ath9k/hif_usb.c:680
 __usb_hcd_giveback_urb+0x6ff/0x930 drivers/usb/core/hcd.c:1656
 usb_hcd_giveback_urb+0x1cb/0x730 drivers/usb/core/hcd.c:1726
 dummy_timer+0xda7/0x74f0 drivers/usb/gadget/udc/dummy_hcd.c:1971
 call_timer_fn+0x7d/0x450 kernel/time/timer.c:1417
 expire_timers+0x328/0x6c0 kernel/time/timer.c:1462
 __run_timers+0x624/0x9e0 kernel/time/timer.c:1731
 run_timer_softirq+0x2d/0x50 kernel/time/timer.c:1744
 __do_softirq+0x1b9/0x715 kernel/softirq.c:343
 asm_call_irq_on_stack+0xf/0x20
 </IRQ>
 __run_on_irqstack arch/x86/include/asm/irq_stack.h:26 [inline]
 run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:77 [inline]
 do_softirq_own_stack+0x6e/0x90 arch/x86/kernel/irq_64.c:77
 invoke_softirq kernel/softirq.c:226 [inline]
 __irq_exit_rcu+0x22f/0x280 kernel/softirq.c:420
 irq_exit_rcu+0xe/0x10 kernel/softirq.c:432
 sysvec_apic_timer_interrupt+0x106/0x130 arch/x86/kernel/apic/apic.c:1100
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:647
RIP: 0010:native_irq_disable arch/x86/include/asm/irqflags.h:49 [inline]
RIP: 0010:arch_local_irq_disable arch/x86/include/asm/irqflags.h:89 [inline]
RIP: 0010:acpi_safe_halt drivers/acpi/processor_idle.c:111 [inline]
RIP: 0010:acpi_idle_do_entry drivers/acpi/processor_idle.c:516 [inline]
RIP: 0010:acpi_idle_enter+0x61d/0x760 drivers/acpi/processor_idle.c:647
Code: f7 d3 44 21 e3 48 85 db 0f 84 ec 00 00 00 4d 85 e4 0f 85 f4 00 00 00 e9 0c 00 00 00 e8 1c b5 3a fb 0f 00 2d 5f e7 5d 09 fb f4 <fa> e9 e0 00 00 00 84 c0 8b 7d b8 0f 45 7d 98 e8 8f 3b bc fb e9 e5
RSP: 0018:ffffffff91403b70 EFLAGS: 00000246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 000000023eaec040
RDX: ffffffff91431040 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffffff91403c08 R08: ffffffff86809bde R09: ffff88813fffa000
R10: 0000000000000002 R11: ffffffff91431040 R12: 0000000000000000
R13: ffff888102fa0064 R14: 0000000000000000 R15: ffffffff91431ab8
 cpuidle_enter_state+0x99e/0x1750 drivers/cpuidle/cpuidle.c:237
 cpuidle_enter+0xe3/0x170 drivers/cpuidle/cpuidle.c:351
 call_cpuidle kernel/sched/idle.c:158 [inline]
 cpuidle_idle_call kernel/sched/idle.c:239 [inline]
 do_idle+0x5df/0x790 kernel/sched/idle.c:299
 cpu_startup_entry+0x45/0x50 kernel/sched/idle.c:396
 rest_init+0x1c8/0x1f0 init/main.c:721
 arch_call_rest_init+0x13/0x15
 start_kernel+0xa17/0xbd8 init/main.c:1064
 x86_64_start_reservations+0x2a/0x2c arch/x86/kernel/head64.c:525
 x86_64_start_kernel+0x86/0x89 arch/x86/kernel/head64.c:506
 secondary_startup_64_no_verify+0xb0/0xbb

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
 kmsan_internal_poison_shadow+0x5c/0xf0 mm/kmsan/kmsan.c:104
 kmsan_slab_alloc+0x8d/0xe0 mm/kmsan/kmsan_hooks.c:76
 slab_alloc_node mm/slub.c:2907 [inline]
 __kmalloc_node_track_caller+0xa37/0x1430 mm/slub.c:4527
 __kmalloc_reserve net/core/skbuff.c:142 [inline]
 __alloc_skb+0x2f8/0xb30 net/core/skbuff.c:210
 __netdev_alloc_skb+0x450/0x7f0 net/core/skbuff.c:446
 __dev_alloc_skb include/linux/skbuff.h:2839 [inline]
 ath9k_hif_usb_rx_stream drivers/net/wireless/ath/ath9k/hif_usb.c:629 [inline]
 ath9k_hif_usb_rx_cb+0xe58/0x1d20 drivers/net/wireless/ath/ath9k/hif_usb.c:680
 __usb_hcd_giveback_urb+0x6ff/0x930 drivers/usb/core/hcd.c:1656
 usb_hcd_giveback_urb+0x1cb/0x730 drivers/usb/core/hcd.c:1726
 dummy_timer+0xda7/0x74f0 drivers/usb/gadget/udc/dummy_hcd.c:1971
 call_timer_fn+0x7d/0x450 kernel/time/timer.c:1417
 expire_timers+0x328/0x6c0 kernel/time/timer.c:1462
 __run_timers+0x624/0x9e0 kernel/time/timer.c:1731
 run_timer_softirq+0x2d/0x50 kernel/time/timer.c:1744
 __do_softirq+0x1b9/0x715 kernel/softirq.c:343
=====================================================

