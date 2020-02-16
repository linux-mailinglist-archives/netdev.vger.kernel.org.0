Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3337B1603B6
	for <lists+netdev@lfdr.de>; Sun, 16 Feb 2020 11:49:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728028AbgBPKtR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 05:49:17 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:42967 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727964AbgBPKtR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 05:49:17 -0500
Received: by mail-il1-f199.google.com with SMTP id s13so11881497ili.9
        for <netdev@vger.kernel.org>; Sun, 16 Feb 2020 02:49:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=q5a8VE4zmrILT9Zd6ZOG8HN54En4RuDTP286P2Roc7U=;
        b=K1wneDZgynNruHJHlX8+4NwQyXCYXytQCtKOHk9ITcPZM9opk2AK49VC1jecVy5rbG
         evQfySk98Vnddjs+aabMNc8Ki5pz4y85bOYZHJ6wA3AiTLCjvHKrY+S8oTKJMqHMbDiu
         vxPiPgemt85XeGSkUod+eb/GKFGl6HnAqbE0H8P5fPDKWpM5PFdt79rYa0jVFE3YXLQ5
         XcZqOqlw8MF35sFysFbHxlZVf4PspR7qIRUxHQl5zDgP3lcBCJjKUg600U/D+4Av1JxR
         Eva7jSUxyJjLfpm/5ZgHOmTQX64WqMCdFBJKKg5Padwa2IUvAZma8hrjqdHcPnXCQ5pw
         JDjA==
X-Gm-Message-State: APjAAAW7UBUNHvD35/nKwow2YdbTN4DSKt/TiRISoetWa35TzL+MRPkk
        twfyx/PjX37GGGyLdZ2gmczP4/4twpGlHJQHxLOI+J774YV6
X-Google-Smtp-Source: APXvYqwnPunf5eeriBqcDJxJCkf825bEgxHuah8alwu8Kwntpvi0bZkQBtMEx+T6PUCFzwI7A83eTm2H1J3ZDIB5txDXfuVxRcYQ
MIME-Version: 1.0
X-Received: by 2002:a92:901:: with SMTP id y1mr9975443ilg.274.1581850156729;
 Sun, 16 Feb 2020 02:49:16 -0800 (PST)
Date:   Sun, 16 Feb 2020 02:49:16 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ae0b2a059eaf303f@google.com>
Subject: INFO: rcu detected stall in mrp_join_timer (2)
From:   syzbot <syzbot+67edf33871a80247d3c0@syzkaller.appspotmail.com>
To:     davem@davemloft.net, gregkh@linuxfoundation.org, info@metux.net,
        keescook@chromium.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pankaj.laxminarayan.bharadiya@intel.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    0a679e13 Merge branch 'for-5.6-fixes' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11471395e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=735296e4dd620b10
dashboard link: https://syzkaller.appspot.com/bug?extid=67edf33871a80247d3c0
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+67edf33871a80247d3c0@syzkaller.appspotmail.com

rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
	(detected by 0, t=10502 jiffies, g=460357, q=845)
rcu: All QSes seen, last rcu_preempt kthread activity 10503 (4295191828-4295181325), jiffies_till_next_fqs=1, root ->qsmask 0x0
syz-executor.2  R  running task    25896 28853   9849 0x80004008
Call Trace:
 <IRQ>
 sched_show_task kernel/sched/core.c:5954 [inline]
 sched_show_task.cold+0x2ee/0x35d kernel/sched/core.c:5929
 print_other_cpu_stall kernel/rcu/tree_stall.h:430 [inline]
 check_cpu_stall kernel/rcu/tree_stall.h:558 [inline]
 rcu_pending kernel/rcu/tree.c:3030 [inline]
 rcu_sched_clock_irq.cold+0xb23/0xc37 kernel/rcu/tree.c:2276
 update_process_times+0x2d/0x70 kernel/time/timer.c:1726
 tick_sched_handle+0xa2/0x190 kernel/time/tick-sched.c:171
 tick_sched_timer+0x53/0x140 kernel/time/tick-sched.c:1314
 __run_hrtimer kernel/time/hrtimer.c:1517 [inline]
 __hrtimer_run_queues+0x364/0xe40 kernel/time/hrtimer.c:1579
 hrtimer_interrupt+0x314/0x770 kernel/time/hrtimer.c:1641
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1119 [inline]
 smp_apic_timer_interrupt+0x160/0x610 arch/x86/kernel/apic/apic.c:1144
 apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:829
RIP: 0010:debug_spin_lock_before kernel/locking/spinlock_debug.c:85 [inline]
RIP: 0010:do_raw_spin_lock+0x10e/0x2f0 kernel/locking/spinlock_debug.c:112
Code: ea 48 c1 ea 03 0f b6 14 02 4c 89 e8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 85 01 00 00 41 8b 54 24 08 65 8b 05 e2 97 a5 7e <39> c2 0f 84 50 01 00 00 4c 89 e7 be 04 00 00 00 41 c7 47 c0 00 00
RSP: 0018:ffffc90000007c28 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
RAX: 0000000000000000 RBX: 1ffff92000000f86 RCX: 0000000000000000
RDX: 00000000ffffffff RSI: 0000000000000008 RDI: ffff88808e65f0a4
RBP: ffffc90000007cb8 R08: 00000000000077e3 R09: fffffbfff16a3386
R10: ffff8880326e4e28 R11: ffff8880326e4540 R12: ffff88808e65f0a0
R13: ffff88808e65f0a8 R14: ffff88808e65f0b0 R15: ffffc90000007c90
 __raw_spin_lock include/linux/spinlock_api_smp.h:143 [inline]
 _raw_spin_lock+0x37/0x40 kernel/locking/spinlock.c:151
 spin_lock include/linux/spinlock.h:338 [inline]
 mrp_join_timer+0x2b/0x80 net/802/mrp.c:590
 call_timer_fn+0x1ac/0x780 kernel/time/timer.c:1404
 expire_timers kernel/time/timer.c:1449 [inline]
 __run_timers kernel/time/timer.c:1773 [inline]
 __run_timers kernel/time/timer.c:1740 [inline]
 run_timer_softirq+0x6c3/0x1790 kernel/time/timer.c:1786
 __do_softirq+0x262/0x98c kernel/softirq.c:292
 invoke_softirq kernel/softirq.c:373 [inline]
 irq_exit+0x19b/0x1e0 kernel/softirq.c:413
 exiting_irq arch/x86/include/asm/apic.h:546 [inline]
 smp_apic_timer_interrupt+0x1a3/0x610 arch/x86/kernel/apic/apic.c:1146
 apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:829
 </IRQ>
RIP: 0010:__read_once_size include/linux/compiler.h:199 [inline]
RIP: 0010:check_kcov_mode kernel/kcov.c:155 [inline]
RIP: 0010:write_comp_data+0x17/0x70 kernel/kcov.c:208
Code: c2 01 48 39 d0 76 07 48 89 34 d1 48 89 11 5d c3 0f 1f 00 65 4c 8b 04 25 c0 1e 02 00 65 8b 05 28 90 8c 7e a9 00 01 1f 00 75 51 <41> 8b 80 80 13 00 00 83 f8 03 75 45 49 8b 80 88 13 00 00 45 8b 80
RSP: 0018:ffffc900059f7728 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
RAX: 0000000080000001 RBX: 00007fe19bff2000 RCX: ffffffff81a39e42
RDX: 00fffe0000000000 RSI: ffffffffffffffff RDI: 0000000000000007
RBP: ffffc900059f7730 R08: ffff8880326e4540 R09: ffff8880326e4dd0
R10: fffffbfff154b438 R11: ffffffff8aa5a1c7 R12: 00fffe0000000000
R13: ffff8880349a1f88 R14: dffffc0000000000 R15: ffffea0001737340
 PageSlab include/linux/page-flags.h:325 [inline]
 page_mapcount include/linux/mm.h:694 [inline]
 zap_pte_range mm/memory.c:1081 [inline]
 zap_pmd_range mm/memory.c:1184 [inline]
 zap_pud_range mm/memory.c:1213 [inline]
 zap_p4d_range mm/memory.c:1234 [inline]
 unmap_page_range+0xe52/0x28d0 mm/memory.c:1255
 unmap_single_vma+0x19d/0x300 mm/memory.c:1300
 unmap_vmas+0x184/0x2f0 mm/memory.c:1332
 exit_mmap+0x2ba/0x530 mm/mmap.c:3130
 __mmput kernel/fork.c:1082 [inline]
 mmput+0x179/0x4d0 kernel/fork.c:1103
 exit_mm kernel/exit.c:485 [inline]
 do_exit+0xac2/0x2f50 kernel/exit.c:788
 do_group_exit+0x135/0x360 kernel/exit.c:899
 get_signal+0x47c/0x24f0 kernel/signal.c:2734
 do_signal+0x87/0x1700 arch/x86/kernel/signal.c:813
 exit_to_usermode_loop+0x286/0x380 arch/x86/entry/common.c:160
 prepare_exit_to_usermode arch/x86/entry/common.c:195 [inline]
 syscall_return_slowpath arch/x86/entry/common.c:278 [inline]
 do_syscall_64+0x676/0x790 arch/x86/entry/common.c:304
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x45b3b9
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fe19b07fcf8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: fffffffffffffe00 RBX: 000000000075bf28 RCX: 000000000045b3b9
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 000000000075bf28
RBP: 000000000075bf20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000075bf2c
R13: 0000000000c6fb7f R14: 00007fe19b0809c0 R15: 000000000075bf2c
rcu: rcu_preempt kthread starved for 10572 jiffies! g460357 f0x2 RCU_GP_WAIT_FQS(5) ->state=0x0 ->cpu=0
rcu: RCU grace-period kthread stack dump:
rcu_preempt     R  running task    29264    10      2 0x80004000
Call Trace:
 context_switch kernel/sched/core.c:3386 [inline]
 __schedule+0x934/0x1f90 kernel/sched/core.c:4082
 schedule+0xdc/0x2b0 kernel/sched/core.c:4156
 schedule_timeout+0x486/0xc50 kernel/time/timer.c:1895
 rcu_gp_fqs_loop kernel/rcu/tree.c:1658 [inline]
 rcu_gp_kthread+0xa10/0x1940 kernel/rcu/tree.c:1818
 kthread+0x361/0x430 kernel/kthread.c:255
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
