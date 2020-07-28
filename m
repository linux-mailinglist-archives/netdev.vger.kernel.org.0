Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B24323106E
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 19:06:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731813AbgG1RGW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 13:06:22 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:47999 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731794AbgG1RGW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 13:06:22 -0400
Received: by mail-il1-f198.google.com with SMTP id o2so14363177ilg.14
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 10:06:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=gxgsVNgMju6EFb0WmfcBE/0w/FhLwyo5HMozMxfMsks=;
        b=duAq9YsbhdqJSnGllQJ6cnPD/sRcPiCZ1eFuiauJii7iQsgmqpuEF6pOjze9yk3XSI
         AnCI4xHrlJHRPJuc7BkguGrRf9Pcsgf8i7rREKLyZ5gF6ujz9fa7xY5uUEYwT7jPtWnE
         r3gb/1PXEvCdSqDna+3RPBDktvadUrLg48W2rxSqYigdli57rrXqlEHyQdF+TfABp0vU
         lvukXQo733oLtPpm00Sx5v3GyRHi+9FRwOLFEYhbsiWonqvhQoIW4lHimMm+/aynC/S2
         Ot+zq96QhZ4d5GOfRObfHWO5PMfiFsw6g8r7RaIpwMZg5RgP5J8iovPQvumopBYA0tCq
         UK6Q==
X-Gm-Message-State: AOAM530loSNgz6BHX/GcAX8rZWj12FFbMn8Yk8IJg5bibkKcZgoynZto
        fzuZJ/+TS5qaKDFjgBr5y0ZDiIqq/kKhznURuHCsTchPyJPK
X-Google-Smtp-Source: ABdhPJyfumVwNMg7hYM9ynDDWhAUQv9Rn2C++jZ2YLGJwgOP1QWYGXa0QiStQHC+tN2CwyutCSwzfYReVkvtKMHU1aC5pKRzPKQY
MIME-Version: 1.0
X-Received: by 2002:a92:194d:: with SMTP id e13mr19463433ilm.125.1595955981022;
 Tue, 28 Jul 2020 10:06:21 -0700 (PDT)
Date:   Tue, 28 Jul 2020 10:06:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000537dfd05ab837526@google.com>
Subject: KASAN: out-of-bounds Read in ath9k_hif_usb_rx_cb (2)
From:   syzbot <syzbot+dbcf296f0cfda711b5c4@syzkaller.appspotmail.com>
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

Hello,

syzbot found the following issue on:

HEAD commit:    25252919 xhci: dbgtty: Make some functions static
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git usb-testing
console output: https://syzkaller.appspot.com/x/log.txt?x=164adf28900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fb6677a3d4f11788
dashboard link: https://syzkaller.appspot.com/bug?extid=dbcf296f0cfda711b5c4
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+dbcf296f0cfda711b5c4@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: out-of-bounds in ath9k_hif_usb_rx_stream drivers/net/wireless/ath/ath9k/hif_usb.c:637 [inline]
BUG: KASAN: out-of-bounds in ath9k_hif_usb_rx_cb+0xe82/0xf80 drivers/net/wireless/ath/ath9k/hif_usb.c:671
Read of size 4 at addr ffff8881a248c098 by task kworker/0:5/3249

CPU: 0 PID: 3249 Comm: kworker/0:5 Not tainted 5.8.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events request_firmware_work_func
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0xf6/0x16e lib/dump_stack.c:118
 print_address_description.constprop.0+0x1a/0x210 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report.cold+0x37/0x7c mm/kasan/report.c:530
 ath9k_hif_usb_rx_stream drivers/net/wireless/ath/ath9k/hif_usb.c:637 [inline]
 ath9k_hif_usb_rx_cb+0xe82/0xf80 drivers/net/wireless/ath/ath9k/hif_usb.c:671
 __usb_hcd_giveback_urb+0x32d/0x560 drivers/usb/core/hcd.c:1650
 usb_hcd_giveback_urb+0x367/0x410 drivers/usb/core/hcd.c:1716
 dummy_timer+0x11f2/0x3240 drivers/usb/gadget/udc/dummy_hcd.c:1967
 call_timer_fn+0x1ac/0x6e0 kernel/time/timer.c:1415
 expire_timers kernel/time/timer.c:1460 [inline]
 __run_timers.part.0+0x54c/0x9e0 kernel/time/timer.c:1784
 __run_timers kernel/time/timer.c:1756 [inline]
 run_timer_softirq+0x80/0x120 kernel/time/timer.c:1797
 __do_softirq+0x222/0x95b kernel/softirq.c:292
 asm_call_on_stack+0xf/0x20 arch/x86/entry/entry_64.S:711
 </IRQ>
 __run_on_irqstack arch/x86/include/asm/irq_stack.h:22 [inline]
 run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:48 [inline]
 do_softirq_own_stack+0xed/0x140 arch/x86/kernel/irq_64.c:77
 invoke_softirq kernel/softirq.c:387 [inline]
 __irq_exit_rcu kernel/softirq.c:417 [inline]
 irq_exit_rcu+0x150/0x1f0 kernel/softirq.c:429
 sysvec_apic_timer_interrupt+0x49/0xc0 arch/x86/kernel/apic/apic.c:1091
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:585
RIP: 0010:arch_local_irq_restore arch/x86/include/asm/irqflags.h:85 [inline]
RIP: 0010:console_unlock+0xbe2/0xcd0 kernel/printk/printk.c:2497
Code: fc ff ff e8 10 31 16 00 0f 0b e9 b1 fd ff ff e8 04 31 16 00 0f 0b e9 04 fe ff ff e8 f8 30 16 00 e8 43 bc 1b 00 ff 74 24 30 9d <e9> 6b fc ff ff e8 04 e0 3f 00 e9 65 f6 ff ff e8 0a e0 3f 00 e9 1f
RSP: 0018:ffff8881c8a3fa18 EFLAGS: 00000293
RAX: 0000000000465681 RBX: 0000000000000200 RCX: 0000000000000006
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff8129790d
RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: ffffffff82b05a80
R13: ffffffff876f53b0 R14: 0000000000000042 R15: dffffc0000000000
 vprintk_emit+0x1b2/0x460 kernel/printk/printk.c:2021
 vprintk_func+0x8b/0x133 kernel/printk/printk_safe.c:393
 printk+0xba/0xed kernel/printk/printk.c:2070
 ath9k_htc_hw_init.cold+0x17/0x2a drivers/net/wireless/ath/ath9k/htc_hst.c:502
 ath9k_hif_usb_firmware_cb+0x274/0x530 drivers/net/wireless/ath/ath9k/hif_usb.c:1220
 request_firmware_work_func+0x126/0x250 drivers/base/firmware_loader/main.c:1001
 process_one_work+0x94c/0x15f0 kernel/workqueue.c:2269
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
 kthread+0x392/0x470 kernel/kthread.c:291
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293

general protection fault, probably for non-canonical address 0xdead000000000400: 0000 [#1] SMP KASAN
CPU: 0 PID: 3249 Comm: kworker/0:5 Not tainted 5.8.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events request_firmware_work_func
RIP: 0010:nearest_obj include/linux/slub_def.h:176 [inline]
RIP: 0010:print_address_description.constprop.0+0x18e/0x210 mm/kasan/report.c:388
Code: c4 60 5b 5d 41 5c 41 5d c3 4c 89 e6 48 2b 35 41 e2 a3 05 48 89 e8 49 8b 5c 24 18 48 c1 fe 06 48 c1 e6 0c 48 03 35 3a e2 a3 05 <8b> 4b 18 48 29 f0 48 99 48 89 cf 48 f7 f9 41 0f b7 44 24 2a 48 89
RSP: 0018:ffff8881db209838 EFLAGS: 00010086
RAX: ffff8881a248c098 RBX: dead000000000400 RCX: 0000000000000000
RDX: 0000000000000001 RSI: ffff8881a248c000 RDI: ffffed103b6412f9
RBP: ffff8881a248c098 R08: 0000000000000000 R09: ffff8881db21fe8b
R10: 0000000000000000 R11: 0000000000000004 R12: ffffea0006892300
R13: ffffffff82e223f2 R14: ffffffff82e223f2 R15: ffffed103a67ee10
FS:  0000000000000000(0000) GS:ffff8881db200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fda4b7b9000 CR3: 00000001d1c45000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report.cold+0x37/0x7c mm/kasan/report.c:530
 ath9k_hif_usb_rx_stream drivers/net/wireless/ath/ath9k/hif_usb.c:637 [inline]
 ath9k_hif_usb_rx_cb+0xe82/0xf80 drivers/net/wireless/ath/ath9k/hif_usb.c:671
 __usb_hcd_giveback_urb+0x32d/0x560 drivers/usb/core/hcd.c:1650
 usb_hcd_giveback_urb+0x367/0x410 drivers/usb/core/hcd.c:1716
 dummy_timer+0x11f2/0x3240 drivers/usb/gadget/udc/dummy_hcd.c:1967
 call_timer_fn+0x1ac/0x6e0 kernel/time/timer.c:1415
 expire_timers kernel/time/timer.c:1460 [inline]
 __run_timers.part.0+0x54c/0x9e0 kernel/time/timer.c:1784
 __run_timers kernel/time/timer.c:1756 [inline]
 run_timer_softirq+0x80/0x120 kernel/time/timer.c:1797
 __do_softirq+0x222/0x95b kernel/softirq.c:292
 asm_call_on_stack+0xf/0x20 arch/x86/entry/entry_64.S:711
 </IRQ>
 __run_on_irqstack arch/x86/include/asm/irq_stack.h:22 [inline]
 run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:48 [inline]
 do_softirq_own_stack+0xed/0x140 arch/x86/kernel/irq_64.c:77
 invoke_softirq kernel/softirq.c:387 [inline]
 __irq_exit_rcu kernel/softirq.c:417 [inline]
 irq_exit_rcu+0x150/0x1f0 kernel/softirq.c:429
 sysvec_apic_timer_interrupt+0x49/0xc0 arch/x86/kernel/apic/apic.c:1091
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:585
RIP: 0010:arch_local_irq_restore arch/x86/include/asm/irqflags.h:85 [inline]
RIP: 0010:console_unlock+0xbe2/0xcd0 kernel/printk/printk.c:2497
Code: fc ff ff e8 10 31 16 00 0f 0b e9 b1 fd ff ff e8 04 31 16 00 0f 0b e9 04 fe ff ff e8 f8 30 16 00 e8 43 bc 1b 00 ff 74 24 30 9d <e9> 6b fc ff ff e8 04 e0 3f 00 e9 65 f6 ff ff e8 0a e0 3f 00 e9 1f
RSP: 0018:ffff8881c8a3fa18 EFLAGS: 00000293
RAX: 0000000000465681 RBX: 0000000000000200 RCX: 0000000000000006
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff8129790d
RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: ffffffff82b05a80
R13: ffffffff876f53b0 R14: 0000000000000042 R15: dffffc0000000000
 vprintk_emit+0x1b2/0x460 kernel/printk/printk.c:2021
 vprintk_func+0x8b/0x133 kernel/printk/printk_safe.c:393
 printk+0xba/0xed kernel/printk/printk.c:2070
 ath9k_htc_hw_init.cold+0x17/0x2a drivers/net/wireless/ath/ath9k/htc_hst.c:502
 ath9k_hif_usb_firmware_cb+0x274/0x530 drivers/net/wireless/ath/ath9k/hif_usb.c:1220
 request_firmware_work_func+0x126/0x250 drivers/base/firmware_loader/main.c:1001
 process_one_work+0x94c/0x15f0 kernel/workqueue.c:2269
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
 kthread+0x392/0x470 kernel/kthread.c:291
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293
Modules linked in:
---[ end trace 6f3e98b95d1a4467 ]---
RIP: 0010:nearest_obj include/linux/slub_def.h:176 [inline]
RIP: 0010:print_address_description.constprop.0+0x18e/0x210 mm/kasan/report.c:388
Code: c4 60 5b 5d 41 5c 41 5d c3 4c 89 e6 48 2b 35 41 e2 a3 05 48 89 e8 49 8b 5c 24 18 48 c1 fe 06 48 c1 e6 0c 48 03 35 3a e2 a3 05 <8b> 4b 18 48 29 f0 48 99 48 89 cf 48 f7 f9 41 0f b7 44 24 2a 48 89
RSP: 0018:ffff8881db209838 EFLAGS: 00010086
RAX: ffff8881a248c098 RBX: dead000000000400 RCX: 0000000000000000
RDX: 0000000000000001 RSI: ffff8881a248c000 RDI: ffffed103b6412f9
RBP: ffff8881a248c098 R08: 0000000000000000 R09: ffff8881db21fe8b
R10: 0000000000000000 R11: 0000000000000004 R12: ffffea0006892300
R13: ffffffff82e223f2 R14: ffffffff82e223f2 R15: ffffed103a67ee10
FS:  0000000000000000(0000) GS:ffff8881db200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fda4b7b9000 CR3: 00000001d1c45000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
