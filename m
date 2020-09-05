Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1637725E6E0
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 11:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728323AbgIEJ7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 05:59:17 -0400
Received: from mail-il1-f207.google.com ([209.85.166.207]:56129 "EHLO
        mail-il1-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726302AbgIEJ7Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Sep 2020 05:59:16 -0400
Received: by mail-il1-f207.google.com with SMTP id a15so6543092ilb.22
        for <netdev@vger.kernel.org>; Sat, 05 Sep 2020 02:59:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=pXVXqTZb1aLdA9z0rUCuaQ/VmiZQ7s5NQK1LxgHL0GE=;
        b=CpMGKkGyxKz3GlyINjZ7Ox2zc+oQ9vuld9QDcyniwPSOY47kSZmMLJOWozNZyhs3xj
         7CIkzMj13nAgmihUM6rTOx+PD9W2EYfX5Bs7Ycl21db5R8EcfKmlznYhnp5CAfWL5X0v
         ahHf6G6NQ5gW+2j6BvP58fd21cuWpPXBYtoTXTNgxU5Eu8giF9vG7x0VHNu6My5zjPAu
         AjErUBnnn1VI5wnMyZTAiFPmf1hlMILmBgHVC9xoBBvUSxBg+52VxVeHPiOqzNMcASXl
         xFFZ1jncwztx0AzaziC9+YVgFvcADjadWxhgku10Hkbvd4xgrDKSCbEwoE9gKEU/fFET
         3tHA==
X-Gm-Message-State: AOAM531SPxrFduIFOm0a2o3nur5z2jPb6Y5QHvkbSQf6cd/odVCbi1Jj
        5ui1fp/3WKOW781zhXq5j2UBMesgp1p64OQeptKqGayg6S7b
X-Google-Smtp-Source: ABdhPJxthAC3mcL8r5RDs33WriAkl8MUUwKJZfY1ltAqRVHCcUQpt/DlSVyEid1I6ZiiDQhEuCFmu0JO8qbHkgZ+DLZ1zmShDd3r
MIME-Version: 1.0
X-Received: by 2002:a92:c002:: with SMTP id q2mr12095044ild.171.1599299955503;
 Sat, 05 Sep 2020 02:59:15 -0700 (PDT)
Date:   Sat, 05 Sep 2020 02:59:15 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000bcb5e205ae8e0946@google.com>
Subject: INFO: rcu detected stall in __run_timers (5)
From:   syzbot <syzbot+60dac164de3cc11c67dc@syzkaller.appspotmail.com>
To:     fweisbec@gmail.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    29523c5e bpf: Fix build without BPF_LSM.
git tree:       bpf-next
console output: https://syzkaller.appspot.com/x/log.txt?x=112d38ae900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=230cd4f722256978
dashboard link: https://syzkaller.appspot.com/bug?extid=60dac164de3cc11c67dc
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=130e7656900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10d8a835900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+60dac164de3cc11c67dc@syzkaller.appspotmail.com

rcu: INFO: rcu_preempt self-detected stall on CPU
rcu: 	0-....: (10494 ticks this GP) idle=68e/1/0x4000000000000000 softirq=8763/8763 fqs=5239 
	(t=10501 jiffies g=9913 q=237618)
NMI backtrace for cpu 0
CPU: 0 PID: 17660 Comm: syz-executor686 Not tainted 5.9.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 nmi_cpu_backtrace.cold+0x70/0xb1 lib/nmi_backtrace.c:101
 nmi_trigger_cpumask_backtrace+0x1b3/0x223 lib/nmi_backtrace.c:62
 trigger_single_cpu_backtrace include/linux/nmi.h:164 [inline]
 rcu_dump_cpu_stacks+0x194/0x1cf kernel/rcu/tree_stall.h:318
 print_cpu_stall kernel/rcu/tree_stall.h:551 [inline]
 check_cpu_stall kernel/rcu/tree_stall.h:625 [inline]
 rcu_pending kernel/rcu/tree.c:3637 [inline]
 rcu_sched_clock_irq.cold+0x5b3/0xccd kernel/rcu/tree.c:2519
 update_process_times+0x25/0xa0 kernel/time/timer.c:1710
 tick_sched_handle+0x9b/0x180 kernel/time/tick-sched.c:176
 tick_sched_timer+0x1d1/0x2a0 kernel/time/tick-sched.c:1328
 __run_hrtimer kernel/time/hrtimer.c:1524 [inline]
 __hrtimer_run_queues+0x1d5/0xfc0 kernel/time/hrtimer.c:1588
 hrtimer_interrupt+0x32a/0x930 kernel/time/hrtimer.c:1650
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1080 [inline]
 __sysvec_apic_timer_interrupt+0x142/0x5e0 arch/x86/kernel/apic/apic.c:1097
 run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:50 [inline]
 sysvec_apic_timer_interrupt+0x4c/0xf0 arch/x86/kernel/apic/apic.c:1091
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:581
RIP: 0010:__raw_spin_unlock_irq include/linux/spinlock_api_smp.h:169 [inline]
RIP: 0010:_raw_spin_unlock_irq+0x4b/0x80 kernel/locking/spinlock.c:199
Code: c0 58 36 b6 89 48 ba 00 00 00 00 00 fc ff df 48 c1 e8 03 80 3c 10 00 75 31 48 83 3d c6 d0 bf 01 00 74 25 fb 66 0f 1f 44 00 00 <bf> 01 00 00 00 e8 cb 51 59 f9 65 8b 05 d4 98 0b 78 85 c0 74 02 5d
RSP: 0018:ffffc90000007e00 EFLAGS: 00000286
RAX: 1ffffffff136c6cb RBX: ffffffff86acdcf0 RCX: 0000000000000002
RDX: dffffc0000000000 RSI: 0000000000000000 RDI: ffffffff87f6656f
RBP: ffff8880ae625600 R08: 0000000000000001 R09: ffffffff8c5f5a9f
R10: fffffbfff18beb53 R11: 0000000000000001 R12: ffffc90000007e98
R13: 0000000000000000 R14: dffffc0000000000 R15: ffff8880ae625600
 expire_timers kernel/time/timer.c:1457 [inline]
 __run_timers.part.0+0x66c/0xaa0 kernel/time/timer.c:1755
 __run_timers kernel/time/timer.c:1736 [inline]
 run_timer_softirq+0xae/0x1a0 kernel/time/timer.c:1768
 __do_softirq+0x2de/0xa24 kernel/softirq.c:298
 asm_call_on_stack+0xf/0x20 arch/x86/entry/entry_64.S:706
 </IRQ>
 __run_on_irqstack arch/x86/include/asm/irq_stack.h:22 [inline]
 run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:48 [inline]
 do_softirq_own_stack+0x9d/0xd0 arch/x86/kernel/irq_64.c:77
 invoke_softirq kernel/softirq.c:393 [inline]
 __irq_exit_rcu kernel/softirq.c:423 [inline]
 irq_exit_rcu+0x1f3/0x230 kernel/softirq.c:435
 sysvec_apic_timer_interrupt+0x51/0xf0 arch/x86/kernel/apic/apic.c:1091
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:581
RIP: 0010:__raw_spin_unlock_irq include/linux/spinlock_api_smp.h:169 [inline]
RIP: 0010:_raw_spin_unlock_irq+0x4b/0x80 kernel/locking/spinlock.c:199
Code: c0 58 36 b6 89 48 ba 00 00 00 00 00 fc ff df 48 c1 e8 03 80 3c 10 00 75 31 48 83 3d c6 d0 bf 01 00 74 25 fb 66 0f 1f 44 00 00 <bf> 01 00 00 00 e8 cb 51 59 f9 65 8b 05 d4 98 0b 78 85 c0 74 02 5d
RSP: 0018:ffffc900059f7978 EFLAGS: 00000286
RAX: 1ffffffff136c6cb RBX: ffff88808333e140 RCX: 0000000000000006
RDX: dffffc0000000000 RSI: 0000000000000000 RDI: ffffffff87f6656f
RBP: ffff8880ae635e40 R08: 0000000000000001 R09: ffffffff8c5f5a9f
R10: fffffbfff18beb53 R11: 0000000000000001 R12: ffff8880ae635e40
R13: ffff8880a9624240 R14: ffff8880a17a7600 R15: 0000000000000001
 finish_lock_switch kernel/sched/core.c:3517 [inline]
 finish_task_switch+0x147/0x750 kernel/sched/core.c:3617
 context_switch kernel/sched/core.c:3781 [inline]
 __schedule+0x8ed/0x21e0 kernel/sched/core.c:4527
 preempt_schedule_common+0x45/0xc0 kernel/sched/core.c:4683
 preempt_schedule_thunk+0x16/0x18 arch/x86/entry/thunk_64.S:40
 smp_call_function_single+0x467/0x4f0 kernel/smp.c:384
 task_function_call+0xd7/0x160 kernel/events/core.c:116
 perf_install_in_context+0x2cb/0x550 kernel/events/core.c:2895
 __do_sys_perf_event_open+0x1c31/0x2cb0 kernel/events/core.c:11992
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x441519
Code: e8 ac e8 ff ff 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 6b 08 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fff66d94e38 EFLAGS: 00000246 ORIG_RAX: 000000000000012a
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 0000000000441519
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000020000180
RBP: 0000000000139f03 R08: 0000000000000000 R09: 00000000004002c8
R10: 00000000ffffffff R11: 0000000000000246 R12: 0000000000402210
R13: 00000000004022a0 R14: 0000000000000000 R15: 0000000000000000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
