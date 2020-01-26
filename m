Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 842EA149C77
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 20:17:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728235AbgAZTRN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 14:17:13 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:52954 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726922AbgAZTRN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 14:17:13 -0500
Received: by mail-il1-f198.google.com with SMTP id o5so3258928ilg.19
        for <netdev@vger.kernel.org>; Sun, 26 Jan 2020 11:17:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=L8NUDqJ5/9ffHvysFUQ1Gd7irrCU343ZTNBThpxErFc=;
        b=jLtnRS0XyrOrza/fH3TzBz26wYBwjTwd7oJo4DmwrDxKhHPsBPWLvgSDnU0wIZ4Z7o
         /YOXxnPZcy++E3lgQBcBoV7RFRwfoUinaBq8uFRx8tQ0vtANWl+5Z9fiVXKeWS4UI9WB
         F9SOMlTai8Fefu1u68pUR78kTbeSBaiXE3slZXLMk9j0amJuxPLhqcIwNvmI/DBan74Z
         f4nb32IbAUr2RABmZQ/gAgb6UPi0cDjHZPkuG/TxXDINlm3WhGerIkIRTj0vqgGzO+73
         BQJSimljmum85fa7K5BKoqYIvBUDdKNubzYyhMNMZ/eJE5PRLw/zWhs369Pgi++TUHWJ
         KyLA==
X-Gm-Message-State: APjAAAXaBw7cgiQ0NKIR19scMSc/0L2bhU9Ejz4P1L7Ank9dGkNcG9UC
        8ZXLUgxyzPlRTRVzt6zsHVs4hXAa+oROcauDD/GB1uq6zVhN
X-Google-Smtp-Source: APXvYqy2FO/kaugtkmh1l8sSHmjXteBOw+KAqpqW4d/ariDju9QlrS/pOq8s2AF0qY0YPfKLBA+pgNdsO1/Q1W0kWOx/iW4BrRny
MIME-Version: 1.0
X-Received: by 2002:a05:6638:34e:: with SMTP id x14mr10950046jap.38.1580066232718;
 Sun, 26 Jan 2020 11:17:12 -0800 (PST)
Date:   Sun, 26 Jan 2020 11:17:12 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000085dfc2059d0fd66d@google.com>
Subject: INFO: rcu detected stall in hash_ip4_gc
From:   syzbot <syzbot+68a806795ac89df3aa1c@syzkaller.appspotmail.com>
To:     bp@alien8.de, coreteam@netfilter.org, davem@davemloft.net,
        fw@strlen.de, hpa@zytor.com, kadlec@blackhole.kfki.hu,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, peterz@infradead.org,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        tony.luck@intel.com, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    6381b442 Merge tag 'iommu-fixes-v5.5-rc7' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14f44769e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cf8e288883e40aba
dashboard link: https://syzkaller.appspot.com/bug?extid=68a806795ac89df3aa1c
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
userspace arch: i386
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11fad479e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12f62f21e00000

The bug was bisected to:

commit 23c42a403a9cfdbad6004a556c927be7dd61a8ee
Author: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Date:   Sat Oct 27 13:07:40 2018 +0000

    netfilter: ipset: Introduction of new commands and protocol version 7

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1128b611e00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=1328b611e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=1528b611e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+68a806795ac89df3aa1c@syzkaller.appspotmail.com
Fixes: 23c42a403a9c ("netfilter: ipset: Introduction of new commands and protocol version 7")

rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
	(detected by 1, t=10502 jiffies, g=9453, q=929)
rcu: All QSes seen, last rcu_preempt kthread activity 10502 (4294981303-4294970801), jiffies_till_next_fqs=1, root ->qsmask 0x0
syz-executor596 R  running task    28776  9738   9733 0x20020008
Call Trace:
 <IRQ>
 sched_show_task kernel/sched/core.c:5954 [inline]
 sched_show_task.cold+0x2ee/0x35d kernel/sched/core.c:5929
 print_other_cpu_stall kernel/rcu/tree_stall.h:410 [inline]
 check_cpu_stall kernel/rcu/tree_stall.h:538 [inline]
 rcu_pending kernel/rcu/tree.c:2827 [inline]
 rcu_sched_clock_irq.cold+0xaf4/0xc0d kernel/rcu/tree.c:2271
 update_process_times+0x2d/0x70 kernel/time/timer.c:1726
 tick_sched_handle+0xa2/0x190 kernel/time/tick-sched.c:171
 tick_sched_timer+0x53/0x140 kernel/time/tick-sched.c:1314
 __run_hrtimer kernel/time/hrtimer.c:1517 [inline]
 __hrtimer_run_queues+0x364/0xe40 kernel/time/hrtimer.c:1579
 hrtimer_interrupt+0x314/0x770 kernel/time/hrtimer.c:1641
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1110 [inline]
 smp_apic_timer_interrupt+0x160/0x610 arch/x86/kernel/apic/apic.c:1135
 apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:829
RIP: 0010:native_safe_halt+0xe/0x10 arch/x86/include/asm/irqflags.h:61
Code: 18 77 de f9 eb 8a cc cc cc cc cc cc e9 07 00 00 00 0f 00 2d c4 31 54 00 f4 c3 66 90 e9 07 00 00 00 0f 00 2d b4 31 54 00 fb f4 <c3> cc 55 48 89 e5 41 57 41 56 41 55 41 54 53 e8 fe 3f 8e f9 e8 c9
RSP: 0018:ffffc90000da8b10 EFLAGS: 00000286 ORIG_RAX: ffffffffffffff13
RAX: 1ffffffff1326676 RBX: ffff8880a46f6e20 RCX: 0000000000000002
RDX: dffffc0000000000 RSI: 0000000000000008 RDI: ffff8880a3224b14
RBP: ffffc90000da8b30 R08: 1ffffffff165e7b1 R09: fffffbfff165e7b2
R10: fffffbfff165e7b1 R11: ffffffff8b2f3d8f R12: 0000000000000003
R13: 0000000000000282 R14: 0000000000000000 R15: 0000000000000001
 pv_wait arch/x86/include/asm/paravirt.h:648 [inline]
 pv_wait_head_or_lock kernel/locking/qspinlock_paravirt.h:470 [inline]
 __pv_queued_spin_lock_slowpath+0x9ba/0xc40 kernel/locking/qspinlock.c:507
 pv_queued_spin_lock_slowpath arch/x86/include/asm/paravirt.h:638 [inline]
 queued_spin_lock_slowpath arch/x86/include/asm/qspinlock.h:50 [inline]
 queued_spin_lock include/asm-generic/qspinlock.h:81 [inline]
 do_raw_spin_lock+0x21d/0x2f0 kernel/locking/spinlock_debug.c:113
 __raw_spin_lock_bh include/linux/spinlock_api_smp.h:136 [inline]
 _raw_spin_lock_bh+0x3b/0x50 kernel/locking/spinlock.c:175
 spin_lock_bh include/linux/spinlock.h:343 [inline]
 hash_ip4_gc+0x49/0x150 net/netfilter/ipset/ip_set_hash_gen.h:532
 call_timer_fn+0x1ac/0x780 kernel/time/timer.c:1404
 expire_timers kernel/time/timer.c:1449 [inline]
 __run_timers kernel/time/timer.c:1773 [inline]
 __run_timers kernel/time/timer.c:1740 [inline]
 run_timer_softirq+0x6c3/0x1790 kernel/time/timer.c:1786
 __do_softirq+0x262/0x98c kernel/softirq.c:292
 invoke_softirq kernel/softirq.c:373 [inline]
 irq_exit+0x19b/0x1e0 kernel/softirq.c:413
 exiting_irq arch/x86/include/asm/apic.h:536 [inline]
 smp_apic_timer_interrupt+0x1a3/0x610 arch/x86/kernel/apic/apic.c:1137
 apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:829
 </IRQ>
RIP: 0010:schedule_debug kernel/sched/core.c:3878 [inline]
RIP: 0010:__schedule+0x119/0x1f90 kernel/sched/core.c:4013
Code: 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 ad 18 00 00 48 b8 00 00 00 00 00 fc ff df 4d 8b 7d 18 4c 89 fa 48 c1 ea 03 80 3c 02 00 <0f> 85 d2 18 00 00 49 81 3f 9d 6e ac 57 0f 85 47 1e 00 00 84 db 75
RSP: 0018:ffffc90001f17b70 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff839f64da
RDX: 1ffff920003e2000 RSI: ffffffff839f64e3 RDI: ffff8880a3224298
RBP: ffffc90001f17c38 R08: ffff8880a3224280 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffff8880ae937340
R13: ffff8880a3224280 R14: 0000000000037340 R15: ffffc90001f10000
 schedule+0xdc/0x2b0 kernel/sched/core.c:4155
 freezable_schedule include/linux/freezer.h:172 [inline]
 do_nanosleep+0x21f/0x640 kernel/time/hrtimer.c:1874
 hrtimer_nanosleep+0x297/0x550 kernel/time/hrtimer.c:1927
 __do_sys_nanosleep_time32 kernel/time/hrtimer.c:1981 [inline]
 __se_sys_nanosleep_time32 kernel/time/hrtimer.c:1968 [inline]
 __ia32_sys_nanosleep_time32+0x1ad/0x230 kernel/time/hrtimer.c:1968
 do_syscall_32_irqs_on arch/x86/entry/common.c:337 [inline]
 do_fast_syscall_32+0x27b/0xe16 arch/x86/entry/common.c:408
 entry_SYSENTER_compat+0x70/0x7f arch/x86/entry/entry_64_compat.S:139
RIP: 0023:0xf7f089a9
Code: 00 00 00 89 d3 5b 5e 5f 5d c3 b8 80 96 98 00 eb c4 8b 04 24 c3 8b 1c 24 c3 8b 34 24 c3 8b 3c 24 c3 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 eb 0d 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 002b:00000000ffe365ac EFLAGS: 00000246 ORIG_RAX: 00000000000000a2
RAX: ffffffffffffffda RBX: 00000000ffe365d8 RCX: 0000000000000000
RDX: 0000000000002611 RSI: 0000000000051fda RDI: 0000000000000000
RBP: 00000000ffe36628 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
rcu: rcu_preempt kthread starved for 10502 jiffies! g9453 f0x2 RCU_GP_WAIT_FQS(5) ->state=0x0 ->cpu=0
rcu: RCU grace-period kthread stack dump:
rcu_preempt     R  running task    29264    10      2 0x80004000
Call Trace:
 context_switch kernel/sched/core.c:3385 [inline]
 __schedule+0x934/0x1f90 kernel/sched/core.c:4081
 schedule+0xdc/0x2b0 kernel/sched/core.c:4155
 schedule_timeout+0x486/0xc50 kernel/time/timer.c:1895
 rcu_gp_fqs_loop kernel/rcu/tree.c:1661 [inline]
 rcu_gp_kthread+0x9b2/0x18d0 kernel/rcu/tree.c:1821
 kthread+0x361/0x430 kernel/kthread.c:255
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
