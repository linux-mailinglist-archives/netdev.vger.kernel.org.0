Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B3D41FFCFA
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 22:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727976AbgFRU5Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 16:57:24 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:43497 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726478AbgFRU5Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 16:57:16 -0400
Received: by mail-il1-f197.google.com with SMTP id e5so4882959ill.10
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 13:57:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=d4+iWLaVlBy8wzsOcjuAnUFW5E1j1kRl6+gfWh8J8Hk=;
        b=aBRDrTiin3AJhOdLxSdeczaRinn3nLFnwhrblv9tI2X1X4Ah5ERCkhJrhnhrl9XrjI
         qUAmEdQIQBLYxqOZtuK8tNfDlGP+AILPlW9u+UUkpu87OoXo6AhoSc1VWv5vld1t5D12
         KMY/k2+3cLpKsZMOkqeKLFWb+tdvV6XZVTn/DB50kqDbV04kT3Jw/lZI8SpcRCQChxvu
         2qRJj1oBHCojuC4DoyvlbKBRuRhwr7WwJyNMxTW07oTjm+ofuXNOfYNOU7LiY2xvqpHa
         3cvXRb6SFsfpJei8CuoLbMOAFx6r/Q2T03fYnbWVTvKJRVA/YpWg/BwtdfTUYBvp2R4X
         Qb6A==
X-Gm-Message-State: AOAM531g5LZpiX5CDLMnDz2SEj6WEwhlyMHpRGBss3ZczdmxAeS0kfRo
        K6DP4ZlPYB/yNNtL18mLIgRDuK2QgV1tNgKE6msKGxOzjVEq
X-Google-Smtp-Source: ABdhPJw4eac/XW53i+LMcaWE0Cd57xbpVKEng30kzh0FAwfMuCudWPv9v27oel9I+xEKgTlPlw44nRgE126xXcQ2DL0zIGQmWBcK
MIME-Version: 1.0
X-Received: by 2002:a05:6602:15ca:: with SMTP id f10mr682018iow.52.1592513834771;
 Thu, 18 Jun 2020 13:57:14 -0700 (PDT)
Date:   Thu, 18 Jun 2020 13:57:14 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006bf03c05a86205bb@google.com>
Subject: INFO: trying to register non-static key in ath9k_htc_rxep
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

Hello,

syzbot found the following crash on:

HEAD commit:    b791d1bd Merge tag 'locking-kcsan-2020-06-11' of git://git..
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git usb-testing
console output: https://syzkaller.appspot.com/x/log.txt?x=1522cc25100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=16c2467d4b6dbee2
dashboard link: https://syzkaller.appspot.com/bug?extid=4d2d56175b934b9a7bf9
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+4d2d56175b934b9a7bf9@syzkaller.appspotmail.com

INFO: trying to register non-static key.
the code is fine but needs lockdep annotation.
turning off the locking correctness validator.
CPU: 0 PID: 355 Comm: syz-executor.2 Not tainted 5.7.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0xf6/0x16e lib/dump_stack.c:118
 assign_lock_key kernel/locking/lockdep.c:894 [inline]
 register_lock_class+0x1442/0x17e0 kernel/locking/lockdep.c:1206
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
 invoke_softirq kernel/softirq.c:373 [inline]
 irq_exit+0x178/0x1a0 kernel/softirq.c:413
 exiting_irq arch/x86/include/asm/apic.h:546 [inline]
 smp_apic_timer_interrupt+0x141/0x540 arch/x86/kernel/apic/apic.c:1107
 apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:829
 </IRQ>
RIP: 0010:arch_local_irq_restore arch/x86/include/asm/irqflags.h:85 [inline]
RIP: 0010:__raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:160 [inline]
RIP: 0010:_raw_spin_unlock_irqrestore+0x3b/0x40 kernel/locking/spinlock.c:191
Code: e8 1a 69 8d fb 48 89 ef e8 42 5d 8e fb f6 c7 02 75 11 53 9d e8 26 e6 ab fb 65 ff 0d 57 e4 68 7a 5b 5d c3 e8 e7 de ab fb 53 9d <eb> ed 0f 1f 00 55 48 89 fd 65 ff 05 3d e4 68 7a 45 31 c9 41 b8 01
RSP: 0018:ffff8881ae06fba0 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
RAX: 0000000000000000 RBX: 0000000000000246 RCX: 1ffffffff0fd4d4a
RDX: 1ffff11039bbe747 RSI: 0000000000000000 RDI: ffff8881cddf3a38
RBP: ffff8881db228400 R08: 0000000000000000 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000000 R12: dffffc0000000000
R13: ffff8881db228480 R14: ffff8881ae06fdf8 R15: ffff8881db228400
 unlock_hrtimer_base kernel/time/hrtimer.c:898 [inline]
 hrtimer_start_range_ns+0x5cd/0xb50 kernel/time/hrtimer.c:1136
 hrtimer_start_expires include/linux/hrtimer.h:435 [inline]
 hrtimer_sleeper_start_expires kernel/time/hrtimer.c:1800 [inline]
 do_nanosleep+0x1b9/0x650 kernel/time/hrtimer.c:1876
 hrtimer_nanosleep+0x1df/0x3a0 kernel/time/hrtimer.c:1932
 __do_sys_nanosleep kernel/time/hrtimer.c:1966 [inline]
 __se_sys_nanosleep kernel/time/hrtimer.c:1953 [inline]
 __x64_sys_nanosleep+0x1dc/0x260 kernel/time/hrtimer.c:1953
 do_syscall_64+0xb6/0x5a0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x45af70
Code: Bad RIP value.
RSP: 002b:00007fff27bba8e8 EFLAGS: 00000246 ORIG_RAX: 0000000000000023
RAX: ffffffffffffffda RBX: 000000000009722e RCX: 000000000045af70
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00007fff27bba8f0
RBP: 00000000000001de R08: 0000000000000001 R09: 0000000001410940
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fff27bba940 R14: 000000000009722e R15: 00007fff27bba950
BUG: unable to handle page fault for address: ffffffffffffffc8
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 7026067 P4D 7026067 PUD 7028067 PMD 0 
Oops: 0000 [#1] SMP KASAN
CPU: 0 PID: 355 Comm: syz-executor.2 Not tainted 5.7.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:ath9k_htc_rxep+0xb5/0x210 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c:1130
Code: 8b 43 38 48 8d 58 c8 49 39 c4 0f 84 ee 00 00 00 e8 90 fd 61 fe 48 89 d8 48 c1 e8 03 0f b6 04 28 84 c0 74 06 0f 8e 0a 01 00 00 <44> 0f b6 3b 31 ff 44 89 fe e8 cd fe 61 fe 45 84 ff 75 a8 e8 63 fd
RSP: 0018:ffff8881db209870 EFLAGS: 00010046
RAX: 0000000000000000 RBX: ffffffffffffffc8 RCX: ffffc900004a7000
RDX: 0000000000040000 RSI: ffffffff82ddb320 RDI: ffff8881db2097e0
RBP: dffffc0000000000 R08: 0000000000000004 R09: ffffed103b6412fd
R10: 0000000000000003 R11: ffffed103b6412fc R12: ffff8881ac34b4d8
R13: ffff8881ac34b0a0 R14: ffff8881ac34b4e8 R15: ffffed10392efc10
FS:  0000000001410940(0000) GS:ffff8881db200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffffffffc8 CR3: 00000001ae02b000 CR4: 00000000001406f0
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
 invoke_softirq kernel/softirq.c:373 [inline]
 irq_exit+0x178/0x1a0 kernel/softirq.c:413
 exiting_irq arch/x86/include/asm/apic.h:546 [inline]
 smp_apic_timer_interrupt+0x141/0x540 arch/x86/kernel/apic/apic.c:1107
 apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:829
 </IRQ>
RIP: 0010:arch_local_irq_restore arch/x86/include/asm/irqflags.h:85 [inline]
RIP: 0010:__raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:160 [inline]
RIP: 0010:_raw_spin_unlock_irqrestore+0x3b/0x40 kernel/locking/spinlock.c:191
Code: e8 1a 69 8d fb 48 89 ef e8 42 5d 8e fb f6 c7 02 75 11 53 9d e8 26 e6 ab fb 65 ff 0d 57 e4 68 7a 5b 5d c3 e8 e7 de ab fb 53 9d <eb> ed 0f 1f 00 55 48 89 fd 65 ff 05 3d e4 68 7a 45 31 c9 41 b8 01
RSP: 0018:ffff8881ae06fba0 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
RAX: 0000000000000000 RBX: 0000000000000246 RCX: 1ffffffff0fd4d4a
RDX: 1ffff11039bbe747 RSI: 0000000000000000 RDI: ffff8881cddf3a38
RBP: ffff8881db228400 R08: 0000000000000000 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000000 R12: dffffc0000000000
R13: ffff8881db228480 R14: ffff8881ae06fdf8 R15: ffff8881db228400
 unlock_hrtimer_base kernel/time/hrtimer.c:898 [inline]
 hrtimer_start_range_ns+0x5cd/0xb50 kernel/time/hrtimer.c:1136
 hrtimer_start_expires include/linux/hrtimer.h:435 [inline]
 hrtimer_sleeper_start_expires kernel/time/hrtimer.c:1800 [inline]
 do_nanosleep+0x1b9/0x650 kernel/time/hrtimer.c:1876
 hrtimer_nanosleep+0x1df/0x3a0 kernel/time/hrtimer.c:1932
 __do_sys_nanosleep kernel/time/hrtimer.c:1966 [inline]
 __se_sys_nanosleep kernel/time/hrtimer.c:1953 [inline]
 __x64_sys_nanosleep+0x1dc/0x260 kernel/time/hrtimer.c:1953
 do_syscall_64+0xb6/0x5a0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x45af70
Code: Bad RIP value.
RSP: 002b:00007fff27bba8e8 EFLAGS: 00000246 ORIG_RAX: 0000000000000023
RAX: ffffffffffffffda RBX: 000000000009722e RCX: 000000000045af70
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00007fff27bba8f0
RBP: 00000000000001de R08: 0000000000000001 R09: 0000000001410940
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fff27bba940 R14: 000000000009722e R15: 00007fff27bba950
Modules linked in:
CR2: ffffffffffffffc8
---[ end trace 4488f3a2c836a427 ]---
RIP: 0010:ath9k_htc_rxep+0xb5/0x210 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c:1130
Code: 8b 43 38 48 8d 58 c8 49 39 c4 0f 84 ee 00 00 00 e8 90 fd 61 fe 48 89 d8 48 c1 e8 03 0f b6 04 28 84 c0 74 06 0f 8e 0a 01 00 00 <44> 0f b6 3b 31 ff 44 89 fe e8 cd fe 61 fe 45 84 ff 75 a8 e8 63 fd
RSP: 0018:ffff8881db209870 EFLAGS: 00010046
RAX: 0000000000000000 RBX: ffffffffffffffc8 RCX: ffffc900004a7000
RDX: 0000000000040000 RSI: ffffffff82ddb320 RDI: ffff8881db2097e0
RBP: dffffc0000000000 R08: 0000000000000004 R09: ffffed103b6412fd
R10: 0000000000000003 R11: ffffed103b6412fc R12: ffff8881ac34b4d8
R13: ffff8881ac34b0a0 R14: ffff8881ac34b4e8 R15: ffffed10392efc10
FS:  0000000001410940(0000) GS:ffff8881db200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffffffffc8 CR3: 00000001ae02b000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
