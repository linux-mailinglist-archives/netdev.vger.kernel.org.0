Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8942E203D38
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 18:57:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729975AbgFVQ5O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 12:57:14 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:39288 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729881AbgFVQ5N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 12:57:13 -0400
Received: by mail-io1-f69.google.com with SMTP id r19so6644796iod.6
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 09:57:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=/tYqKIp3w739fwVS3SNd0WI3Mq8mwz9vCMWpDnBTWzc=;
        b=JT6ZUwoQ9jq82n9nZZFdreEP/gFAMNpORXw+46MwYYpgFsANFs20CmjjkZfsLQP5R0
         iY2L76Ec1Rghg6NGcesn8ewFbqJU3PptSBFDhI8ka7UhAOOb+/YhP+QdxUkOXDbMtmcA
         /3RaHOgETchqjx5G/v1cqMY3CxN44Dc5YB0Q7FUzbc4Lf8Nl/dsaqei0rwF7qUpI2Pou
         xtTndaiqXiXTj0XOnLKHvXPJNKDJ5k2zvvoGzNtAL80ZUHORgFfa77X4xXeEgKjrVpem
         gPVhAQQLOGGZVgK6rgA590+tQYOC5OrnbcuJxr+GH5rUrEr0rNZv3Me+gJCsa2A8Em03
         q9uQ==
X-Gm-Message-State: AOAM530ejAJ9b6EhVgeUW4asLWbYMYU31cqMCX5QRPORxEMIy3Dsp4GN
        kuT7B2xfM/PqTjuc20i2LMlKk20xBK5fudiHEOyvmWtGnwPS
X-Google-Smtp-Source: ABdhPJzQfc1w5CUXBr4Ohp9z3rjrpQ0KfJdv+hKTTA1bXg9+fvSQ7wpK8vMItpp1VmcPqVTiZfaZ+RgjnFO5MhhJPL6QDq/FZK73
MIME-Version: 1.0
X-Received: by 2002:a02:93ea:: with SMTP id z97mr14919283jah.40.1592845031963;
 Mon, 22 Jun 2020 09:57:11 -0700 (PDT)
Date:   Mon, 22 Jun 2020 09:57:11 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005003fe05a8af2231@google.com>
Subject: INFO: trying to register non-static key in skb_queue_tail
From:   syzbot <syzbot+743547b2a7fd655ffb6d@syzkaller.appspotmail.com>
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

syzbot found the following crash on:

HEAD commit:    f8f02d5c USB: OTG: rename product list of devices
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git usb-testing
console output: https://syzkaller.appspot.com/x/log.txt?x=17205bae100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f1981539b6376b73
dashboard link: https://syzkaller.appspot.com/bug?extid=743547b2a7fd655ffb6d
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11eab949100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10dc82ed100000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+743547b2a7fd655ffb6d@syzkaller.appspotmail.com

INFO: trying to register non-static key.
the code is fine but needs lockdep annotation.
turning off the locking correctness validator.
CPU: 0 PID: 323 Comm: systemd-udevd Not tainted 5.8.0-rc1-syzkaller #0
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
 skb_queue_tail+0x27/0x180 net/core/skbuff.c:3143
 ath9k_htc_txep+0x287/0x400 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c:707
 ath9k_htc_txcompletion_cb+0x1a1/0x2b0 drivers/net/wireless/ath/ath9k/htc_hst.c:346
 hif_usb_regout_cb+0x115/0x1c0 drivers/net/wireless/ath/ath9k/hif_usb.c:90
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
RIP: 0010:lock_release+0x3c9/0x710 kernel/locking/lockdep.c:4967
Code: 0f b6 14 02 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 bb 02 00 00 83 ad 84 08 00 00 01 0f 85 4a 01 00 00 ff 34 24 9d <48> b8 00 00 00 00 00 fc ff df 48 01 c3 48 c7 03 00 00 00 00 c7 43
RSP: 0018:ffff8881cd71f8f0 EFLAGS: 00000246
RAX: 0000000000000007 RBX: 1ffff11039ae3f21 RCX: 1ffff11039a85d8f
RDX: 0000000000000000 RSI: 1ffff11039a85d96 RDI: ffff8881cd42ec84
RBP: ffff8881cd42e400 R08: ffff8881cd42e400 R09: fffffbfff1014d0a
R10: ffffffff880a684f R11: fffffbfff1014d09 R12: f002853324f3be8d
R13: ffffffff816b05ef R14: ffff8881cd42ec80 R15: 0000000000000002
 zap_pte_range mm/memory.c:1089 [inline]
 zap_pmd_range mm/memory.c:1193 [inline]
 zap_pud_range mm/memory.c:1222 [inline]
 zap_p4d_range mm/memory.c:1243 [inline]
 unmap_page_range+0xe2f/0x1fc0 mm/memory.c:1264
 unmap_single_vma+0x196/0x300 mm/memory.c:1309
 unmap_vmas+0x174/0x2f0 mm/memory.c:1341
 exit_mmap+0x278/0x4d0 mm/mmap.c:3150
 __mmput kernel/fork.c:1093 [inline]
 mmput+0xce/0x3d0 kernel/fork.c:1114
 exit_mm kernel/exit.c:482 [inline]
 do_exit+0xaaf/0x2cb0 kernel/exit.c:792
 do_group_exit+0x125/0x340 kernel/exit.c:903
 __do_sys_exit_group kernel/exit.c:914 [inline]
 __se_sys_exit_group kernel/exit.c:912 [inline]
 __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:912
 do_syscall_64+0x50/0x90 arch/x86/entry/common.c:359
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7f7ad8c2a618
Code: Bad RIP value.
RSP: 002b:00007ffd37c486a8 EFLAGS: 00000206 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 00007ffd37c48770 RCX: 00007f7ad8c2a618
RDX: 0000000000000000 RSI: 000000000000003c RDI: 0000000000000000
RBP: 00007ffd37c48820 R08: 00000000000000e7 R09: fffffffffffffe50
R10: 00000000ffffffff R11: 0000000000000206 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000003 R15: 000000000000000e
general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 0 PID: 323 Comm: systemd-udevd Not tainted 5.8.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__skb_insert include/linux/skbuff.h:1895 [inline]
RIP: 0010:__skb_queue_before include/linux/skbuff.h:2001 [inline]
RIP: 0010:__skb_queue_tail include/linux/skbuff.h:2034 [inline]
RIP: 0010:skb_queue_tail+0xbb/0x180 net/core/skbuff.c:3144
Code: 00 00 00 00 fc ff df 48 c1 ea 03 80 3c 02 00 0f 85 82 00 00 00 4c 89 e2 48 89 6b 08 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <80> 3c 02 00 75 55 48 8d 7b 10 49 89 2c 24 48 b8 00 00 00 00 00 fc
RSP: 0018:ffff8881db2099f0 EFLAGS: 00010046
RAX: dffffc0000000000 RBX: ffff8881cd7ab590 RCX: ffffffff81274370
RDX: 0000000000000000 RSI: 0000000000000046 RDI: ffff8881cfdc1148
RBP: ffff8881cfdc1140 R08: 0000000000000004 R09: ffffed103b64132d
R10: 0000000000000003 R11: ffffed103b64132c R12: 0000000000000000
R13: ffff8881cd7ab598 R14: ffff8881cd7ab5a8 R15: ffffffff82dcf820
FS:  00007f7ad9dda8c0(0000) GS:ffff8881db200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000559104643e60 CR3: 00000001ce0ed000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
 ath9k_htc_txep+0x287/0x400 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c:707
 ath9k_htc_txcompletion_cb+0x1a1/0x2b0 drivers/net/wireless/ath/ath9k/htc_hst.c:346
 hif_usb_regout_cb+0x115/0x1c0 drivers/net/wireless/ath/ath9k/hif_usb.c:90
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
RIP: 0010:lock_release+0x3c9/0x710 kernel/locking/lockdep.c:4967
Code: 0f b6 14 02 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 bb 02 00 00 83 ad 84 08 00 00 01 0f 85 4a 01 00 00 ff 34 24 9d <48> b8 00 00 00 00 00 fc ff df 48 01 c3 48 c7 03 00 00 00 00 c7 43
RSP: 0018:ffff8881cd71f8f0 EFLAGS: 00000246
RAX: 0000000000000007 RBX: 1ffff11039ae3f21 RCX: 1ffff11039a85d8f
RDX: 0000000000000000 RSI: 1ffff11039a85d96 RDI: ffff8881cd42ec84
RBP: ffff8881cd42e400 R08: ffff8881cd42e400 R09: fffffbfff1014d0a
R10: ffffffff880a684f R11: fffffbfff1014d09 R12: f002853324f3be8d
R13: ffffffff816b05ef R14: ffff8881cd42ec80 R15: 0000000000000002
 zap_pte_range mm/memory.c:1089 [inline]
 zap_pmd_range mm/memory.c:1193 [inline]
 zap_pud_range mm/memory.c:1222 [inline]
 zap_p4d_range mm/memory.c:1243 [inline]
 unmap_page_range+0xe2f/0x1fc0 mm/memory.c:1264
 unmap_single_vma+0x196/0x300 mm/memory.c:1309
 unmap_vmas+0x174/0x2f0 mm/memory.c:1341
 exit_mmap+0x278/0x4d0 mm/mmap.c:3150
 __mmput kernel/fork.c:1093 [inline]
 mmput+0xce/0x3d0 kernel/fork.c:1114
 exit_mm kernel/exit.c:482 [inline]
 do_exit+0xaaf/0x2cb0 kernel/exit.c:792
 do_group_exit+0x125/0x340 kernel/exit.c:903
 __do_sys_exit_group kernel/exit.c:914 [inline]
 __se_sys_exit_group kernel/exit.c:912 [inline]
 __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:912
 do_syscall_64+0x50/0x90 arch/x86/entry/common.c:359
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7f7ad8c2a618
Code: Bad RIP value.
RSP: 002b:00007ffd37c486a8 EFLAGS: 00000206 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 00007ffd37c48770 RCX: 00007f7ad8c2a618
RDX: 0000000000000000 RSI: 000000000000003c RDI: 0000000000000000
RBP: 00007ffd37c48820 R08: 00000000000000e7 R09: fffffffffffffe50
R10: 00000000ffffffff R11: 0000000000000206 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000003 R15: 000000000000000e
Modules linked in:
---[ end trace 53afd8f120df8e51 ]---
RIP: 0010:__skb_insert include/linux/skbuff.h:1895 [inline]
RIP: 0010:__skb_queue_before include/linux/skbuff.h:2001 [inline]
RIP: 0010:__skb_queue_tail include/linux/skbuff.h:2034 [inline]
RIP: 0010:skb_queue_tail+0xbb/0x180 net/core/skbuff.c:3144
Code: 00 00 00 00 fc ff df 48 c1 ea 03 80 3c 02 00 0f 85 82 00 00 00 4c 89 e2 48 89 6b 08 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <80> 3c 02 00 75 55 48 8d 7b 10 49 89 2c 24 48 b8 00 00 00 00 00 fc
RSP: 0018:ffff8881db2099f0 EFLAGS: 00010046
RAX: dffffc0000000000 RBX: ffff8881cd7ab590 RCX: ffffffff81274370
RDX: 0000000000000000 RSI: 0000000000000046 RDI: ffff8881cfdc1148
RBP: ffff8881cfdc1140 R08: 0000000000000004 R09: ffffed103b64132d
R10: 0000000000000003 R11: ffffed103b64132c R12: 0000000000000000
R13: ffff8881cd7ab598 R14: ffff8881cd7ab5a8 R15: ffffffff82dcf820
FS:  00007f7ad9dda8c0(0000) GS:ffff8881db200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000559104643e60 CR3: 00000001ce0ed000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
