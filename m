Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA153B944A
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 17:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233588AbhGAPw4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 11:52:56 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:52172 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233239AbhGAPw4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 11:52:56 -0400
Received: by mail-io1-f71.google.com with SMTP id x21-20020a5d99150000b02904e00bb129f0so4715303iol.18
        for <netdev@vger.kernel.org>; Thu, 01 Jul 2021 08:50:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=LUftJssQDKFbnvBwg9auXX1HQDW4fKDeDOssrBpPhUc=;
        b=YfUFYtJesZMPUzXQcT6YJ0opD7hj7idyF4jURRk4aNAkFdGd7QjUvZFPDVC27h7qvT
         cL/lLilvsUyK9G9oY0whmqvCjBGkHVDVuCqlvWQIO2QHoAzJbi/x0xfAvFykdhVYcy5J
         Sss3T0frY9BF/48EWK/f7fh/FDq66SccEZbTFkQJV+4vkcTCwILktypT+t64xdxUiMWE
         XzeJNnwLC5iTFn0i8H+Ahe5NzHfdo0oBj4rsRm8E3HblioGMC43Ji8PDxBg9aqfpc1dV
         e7Zj339pbDT7prOgmcCOJZiOhmbwSKvGXmDSeJBApMeIpzK1oyws5iUrmE9fbiIiQ0rk
         WOAg==
X-Gm-Message-State: AOAM533FpvV6xxdkMruVMm1aTk7fgWOzoZ838U3VcLVLObZAX4jWp3ky
        wGDrI3DkXbfN2ThKmHE9mTuEkypPSAyAxZRoyNgmP6pGGokW
X-Google-Smtp-Source: ABdhPJwEgmL9UOtImysEbc3mR4mB6i8CpKZTwZDmXz1E5oW9mUu+KfZ92u1bDS2jUglBMfSPiMAkwfgMo7QRzFtrIia7LIKwktEE
MIME-Version: 1.0
X-Received: by 2002:a92:db4b:: with SMTP id w11mr63291ilq.194.1625154625372;
 Thu, 01 Jul 2021 08:50:25 -0700 (PDT)
Date:   Thu, 01 Jul 2021 08:50:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000026864605c611cc51@google.com>
Subject: [syzbot] INFO: rcu detected stall in net_tx_action
From:   syzbot <syzbot+3ba0493d523d007b3819@syzkaller.appspotmail.com>
To:     fweisbec@gmail.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    d6765985 Revert "be2net: disable bh with spin_lock in be_p..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=1085a0d8300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7ca96a2d153c74b0
dashboard link: https://syzkaller.appspot.com/bug?extid=3ba0493d523d007b3819
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14c9edc8300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=172463c8300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3ba0493d523d007b3819@syzkaller.appspotmail.com

rcu: INFO: rcu_preempt self-detected stall on CPU
rcu: 	1-...!: (11 ticks this GP) idle=eae/0/0x3 softirq=11934/11934 fqs=0 
	(t=13378 jiffies g=11625 q=43)
rcu: rcu_preempt kthread starved for 13378 jiffies! g11625 f0x0 RCU_GP_WAIT_FQS(5) ->state=0x0 ->cpu=1
rcu: 	Unless rcu_preempt kthread gets sufficient CPU time, OOM is now expected behavior.
rcu: RCU grace-period kthread stack dump:
task:rcu_preempt     state:R  running task     stack:28800 pid:   14 ppid:     2 flags:0x00004000
Call Trace:
 context_switch kernel/sched/core.c:4339 [inline]
 __schedule+0x916/0x23e0 kernel/sched/core.c:5147
 schedule+0xcf/0x270 kernel/sched/core.c:5226
 schedule_timeout+0x14a/0x250 kernel/time/timer.c:1892
 rcu_gp_fqs_loop kernel/rcu/tree.c:2004 [inline]
 rcu_gp_kthread+0xd07/0x2300 kernel/rcu/tree.c:2177
 kthread+0x3b1/0x4a0 kernel/kthread.c:313
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
rcu: Stack dump where RCU GP kthread last ran:
NMI backtrace for cpu 1
CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.13.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x141/0x1d7 lib/dump_stack.c:120
 nmi_cpu_backtrace.cold+0x44/0xd7 lib/nmi_backtrace.c:105
 nmi_trigger_cpumask_backtrace+0x1b3/0x230 lib/nmi_backtrace.c:62
 trigger_single_cpu_backtrace include/linux/nmi.h:164 [inline]
 rcu_check_gp_kthread_starvation.cold+0x1cc/0x1d1 kernel/rcu/tree_stall.h:478
 print_cpu_stall kernel/rcu/tree_stall.h:622 [inline]
 check_cpu_stall kernel/rcu/tree_stall.h:699 [inline]
 rcu_pending kernel/rcu/tree.c:3911 [inline]
 rcu_sched_clock_irq.cold+0x3ec/0x74b kernel/rcu/tree.c:2649
 update_process_times+0x16d/0x200 kernel/time/timer.c:1796
 tick_sched_handle+0x9b/0x180 kernel/time/tick-sched.c:226
 tick_sched_timer+0x1b0/0x2d0 kernel/time/tick-sched.c:1374
 __run_hrtimer kernel/time/hrtimer.c:1537 [inline]
 __hrtimer_run_queues+0x1c0/0xe40 kernel/time/hrtimer.c:1601
 hrtimer_interrupt+0x330/0xa00 kernel/time/hrtimer.c:1663
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1089 [inline]
 __sysvec_apic_timer_interrupt+0x146/0x540 arch/x86/kernel/apic/apic.c:1106
 sysvec_apic_timer_interrupt+0x40/0xc0 arch/x86/kernel/apic/apic.c:1100
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:647
RIP: 0010:arch_safe_halt arch/x86/include/asm/irqflags.h:90 [inline]
RIP: 0010:kvm_wait arch/x86/kernel/kvm.c:888 [inline]
RIP: 0010:kvm_wait+0xb2/0x100 arch/x86/kernel/kvm.c:871
Code: 89 74 24 0c 48 89 3c 24 e8 2b 2e 48 00 8b 74 24 0c 48 8b 3c 24 eb 82 e8 4c 33 48 00 e9 07 00 00 00 0f 00 2d 90 10 36 08 fb f4 <eb> 98 e9 07 00 00 00 0f 00 2d 80 10 36 08 f4 eb bf 89 74 24 0c 48
RSP: 0018:ffffc90000dc0d98 EFLAGS: 00000202
RAX: 0000000000097204 RBX: 0000000000000000 RCX: 1ffffffff204f312
RDX: 0000000000000000 RSI: 0000000000000102 RDI: 0000000000000000
RBP: ffff8880312710f0 R08: 0000000000000001 R09: ffffffff90228977
R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000000
R13: ffffed100624e21e R14: 0000000000000001 R15: ffff8880b9d36400
 pv_wait arch/x86/include/asm/paravirt.h:597 [inline]
 pv_wait_head_or_lock kernel/locking/qspinlock_paravirt.h:470 [inline]
 __pv_queued_spin_lock_slowpath+0x8b8/0xb40 kernel/locking/qspinlock.c:508
 pv_queued_spin_lock_slowpath arch/x86/include/asm/paravirt.h:585 [inline]
 queued_spin_lock_slowpath arch/x86/include/asm/qspinlock.h:51 [inline]
 queued_spin_lock include/asm-generic/qspinlock.h:85 [inline]
 do_raw_spin_lock+0x200/0x2b0 kernel/locking/spinlock_debug.c:113
 spin_lock include/linux/spinlock.h:354 [inline]
 net_tx_action+0x437/0xe10 net/core/dev.c:5044
 __do_softirq+0x29b/0x9f6 kernel/softirq.c:559
 invoke_softirq kernel/softirq.c:433 [inline]
 __irq_exit_rcu+0x136/0x200 kernel/softirq.c:637
 irq_exit_rcu+0x5/0x20 kernel/softirq.c:649
 sysvec_apic_timer_interrupt+0x93/0xc0 arch/x86/kernel/apic/apic.c:1100
 </IRQ>
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:647
RIP: 0010:native_save_fl arch/x86/include/asm/irqflags.h:29 [inline]
RIP: 0010:arch_local_save_flags arch/x86/include/asm/irqflags.h:70 [inline]
RIP: 0010:arch_irqs_disabled arch/x86/include/asm/irqflags.h:132 [inline]
RIP: 0010:acpi_safe_halt drivers/acpi/processor_idle.c:109 [inline]
RIP: 0010:acpi_idle_do_entry+0x1c9/0x250 drivers/acpi/processor_idle.c:513
Code: 9d 1f 5b f8 84 db 75 ac e8 e4 18 5b f8 e8 ff 25 61 f8 e9 0c 00 00 00 e8 d5 18 5b f8 0f 00 2d 3e b7 b4 00 e8 c9 18 5b f8 fb f4 <9c> 5b 81 e3 00 02 00 00 fa 31 ff 48 89 de e8 d4 20 5b f8 48 85 db
RSP: 0018:ffffc90000d57d18 EFLAGS: 00000293
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff8880123d54c0 RSI: ffffffff8919c327 RDI: 0000000000000000
RBP: ffff8880190bb064 R08: 0000000000000001 R09: 0000000000000001
R10: ffffffff817ae948 R11: 0000000000000000 R12: 0000000000000001
R13: ffff8880190bb000 R14: ffff8880190bb064 R15: ffff88801c57c804
 acpi_idle_enter+0x361/0x500 drivers/acpi/processor_idle.c:648
 cpuidle_enter_state+0x1b1/0xc80 drivers/cpuidle/cpuidle.c:237
 cpuidle_enter+0x4a/0xa0 drivers/cpuidle/cpuidle.c:351
 call_cpuidle kernel/sched/idle.c:158 [inline]
 cpuidle_idle_call kernel/sched/idle.c:239 [inline]
 do_idle+0x3e8/0x590 kernel/sched/idle.c:306
 cpu_startup_entry+0x14/0x20 kernel/sched/idle.c:403
 start_secondary+0x274/0x350 arch/x86/kernel/smpboot.c:272
 secondary_startup_64_no_verify+0xb0/0xbb
NMI backtrace for cpu 1
CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.13.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x141/0x1d7 lib/dump_stack.c:120
 nmi_cpu_backtrace.cold+0x44/0xd7 lib/nmi_backtrace.c:105
 nmi_trigger_cpumask_backtrace+0x1b3/0x230 lib/nmi_backtrace.c:62
 trigger_single_cpu_backtrace include/linux/nmi.h:164 [inline]
 rcu_dump_cpu_stacks+0x25e/0x3f0 kernel/rcu/tree_stall.h:341
 print_cpu_stall kernel/rcu/tree_stall.h:624 [inline]
 check_cpu_stall kernel/rcu/tree_stall.h:699 [inline]
 rcu_pending kernel/rcu/tree.c:3911 [inline]
 rcu_sched_clock_irq.cold+0x3f1/0x74b kernel/rcu/tree.c:2649
 update_process_times+0x16d/0x200 kernel/time/timer.c:1796
 tick_sched_handle+0x9b/0x180 kernel/time/tick-sched.c:226
 tick_sched_timer+0x1b0/0x2d0 kernel/time/tick-sched.c:1374
 __run_hrtimer kernel/time/hrtimer.c:1537 [inline]
 __hrtimer_run_queues+0x1c0/0xe40 kernel/time/hrtimer.c:1601
 hrtimer_interrupt+0x330/0xa00 kernel/time/hrtimer.c:1663
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1089 [inline]
 __sysvec_apic_timer_interrupt+0x146/0x540 arch/x86/kernel/apic/apic.c:1106
 sysvec_apic_timer_interrupt+0x40/0xc0 arch/x86/kernel/apic/apic.c:1100
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:647
RIP: 0010:arch_safe_halt arch/x86/include/asm/irqflags.h:90 [inline]
RIP: 0010:kvm_wait arch/x86/kernel/kvm.c:888 [inline]
RIP: 0010:kvm_wait+0xb2/0x100 arch/x86/kernel/kvm.c:871
Code: 89 74 24 0c 48 89 3c 24 e8 2b 2e 48 00 8b 74 24 0c 48 8b 3c 24 eb 82 e8 4c 33 48 00 e9 07 00 00 00 0f 00 2d 90 10 36 08 fb f4 <eb> 98 e9 07 00 00 00 0f 00 2d 80 10 36 08 f4 eb bf 89 74 24 0c 48
RSP: 0018:ffffc90000dc0d98 EFLAGS: 00000202
RAX: 0000000000097204 RBX: 0000000000000000 RCX: 1ffffffff204f312
RDX: 0000000000000000 RSI: 0000000000000102 RDI: 0000000000000000
RBP: ffff8880312710f0 R08: 0000000000000001 R09: ffffffff90228977
R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000000
R13: ffffed100624e21e R14: 0000000000000001 R15: ffff8880b9d36400
 pv_wait arch/x86/include/asm/paravirt.h:597 [inline]
 pv_wait_head_or_lock kernel/locking/qspinlock_paravirt.h:470 [inline]
 __pv_queued_spin_lock_slowpath+0x8b8/0xb40 kernel/locking/qspinlock.c:508
 pv_queued_spin_lock_slowpath arch/x86/include/asm/paravirt.h:585 [inline]
 queued_spin_lock_slowpath arch/x86/include/asm/qspinlock.h:51 [inline]
 queued_spin_lock include/asm-generic/qspinlock.h:85 [inline]
 do_raw_spin_lock+0x200/0x2b0 kernel/locking/spinlock_debug.c:113
 spin_lock include/linux/spinlock.h:354 [inline]
 net_tx_action+0x437/0xe10 net/core/dev.c:5044
 __do_softirq+0x29b/0x9f6 kernel/softirq.c:559
 invoke_softirq kernel/softirq.c:433 [inline]
 __irq_exit_rcu+0x136/0x200 kernel/softirq.c:637
 irq_exit_rcu+0x5/0x20 kernel/softirq.c:649
 sysvec_apic_timer_interrupt+0x93/0xc0 arch/x86/kernel/apic/apic.c:1100
 </IRQ>
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:647
RIP: 0010:native_save_fl arch/x86/include/asm/irqflags.h:29 [inline]
RIP: 0010:arch_local_save_flags arch/x86/include/asm/irqflags.h:70 [inline]
RIP: 0010:arch_irqs_disabled arch/x86/include/asm/irqflags.h:132 [inline]
RIP: 0010:acpi_safe_halt drivers/acpi/processor_idle.c:109 [inline]
RIP: 0010:acpi_idle_do_entry+0x1c9/0x250 drivers/acpi/processor_idle.c:513
Code: 9d 1f 5b f8 84 db 75 ac e8 e4 18 5b f8 e8 ff 25 61 f8 e9 0c 00 00 00 e8 d5 18 5b f8 0f 00 2d 3e b7 b4 00 e8 c9 18 5b f8 fb f4 <9c> 5b 81 e3 00 02 00 00 fa 31 ff 48 89 de e8 d4 20 5b f8 48 85 db
RSP: 0018:ffffc90000d57d18 EFLAGS: 00000293
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff8880123d54c0 RSI: ffffffff8919c327 RDI: 0000000000000000
RBP: ffff8880190bb064 R08: 0000000000000001 R09: 0000000000000001
R10: ffffffff817ae948 R11: 0000000000000000 R12: 0000000000000001
R13: ffff8880190bb000 R14: ffff8880190bb064 R15: ffff88801c57c804
 acpi_idle_enter+0x361/0x500 drivers/acpi/processor_idle.c:648
 cpuidle_enter_state+0x1b1/0xc80 drivers/cpuidle/cpuidle.c:237
 cpuidle_enter+0x4a/0xa0 drivers/cpuidle/cpuidle.c:351
 call_cpuidle kernel/sched/idle.c:158 [inline]
 cpuidle_idle_call kernel/sched/idle.c:239 [inline]
 do_idle+0x3e8/0x590 kernel/sched/idle.c:306
 cpu_startup_entry+0x14/0x20 kernel/sched/idle.c:403
 start_secondary+0x274/0x350 arch/x86/kernel/smpboot.c:272
 secondary_startup_64_no_verify+0xb0/0xbb


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
