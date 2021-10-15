Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 414BD42FB2B
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 20:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238149AbhJOSnh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 14:43:37 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:56977 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234886AbhJOSng (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 14:43:36 -0400
Received: by mail-io1-f72.google.com with SMTP id d7-20020a056602228700b005ddba37de42so5230697iod.23
        for <netdev@vger.kernel.org>; Fri, 15 Oct 2021 11:41:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=C9qzMgtikG7//mWRAn6u+TEQfkg+k6W7H+VEycaQP6c=;
        b=Xh0aFSr02vEoCLmyHsgAirko566WdOuywkgwX3ZK7Ayrh+/eNw1N7rfjSGGM960q4P
         Rg02Vwi9sia0TvndyD6EOCKDcizqjiepLUY6nF+0ApBlr25JvxSoCmcVfhIpHqA8xZOW
         rIzOxXjGGFebJI8pljOR66rspOUbiIys7ktcAgu7HdsY+Kg/K/tr2oyzftbj9XA/f5WG
         vBQgbLayQ1VqFOO5cPaqx7srU2C1ygK9gGOu0WLlCxIIwJ2draX7ZHzvTO+gKkfc11vz
         zfb8VnX0xjXU8d+TLyD5Mw1xpOxawyaMe83ePn1gpYGTwXMzbh997B9IwcKlo7aZ3c2k
         8vjQ==
X-Gm-Message-State: AOAM531tWsTVp5yNkcmSyN/U+P8Z3fB4UH4MKwSIjoDVEf17BpEv12e6
        wvIgwg0JQh4fTO6Tc4c0oxsOVpG6zWuVwlHCyfOdeiOsbQ4D
X-Google-Smtp-Source: ABdhPJwRTDpFWbInru7t3H6MNxB/H9UgGnrJZsvsuwEMwftkoGaAniJYfFPj+m1mbEDoTNXcQjDYYCKLGbpG63HHVI2HGC03dFcA
MIME-Version: 1.0
X-Received: by 2002:a05:6638:35a9:: with SMTP id v41mr5314058jal.67.1634323289945;
 Fri, 15 Oct 2021 11:41:29 -0700 (PDT)
Date:   Fri, 15 Oct 2021 11:41:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000253ad405ce688b39@google.com>
Subject: [syzbot] INFO: rcu detected stall in sys_exit_group (7)
From:   syzbot <syzbot+1c1c0d391f04584c1611@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        vinicius.gomes@intel.com, xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    64570fbc14f8 Linux 5.15-rc5
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14eb8094b00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=119202188070a966
dashboard link: https://syzkaller.appspot.com/bug?extid=1c1c0d391f04584c1611
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15eccf14b00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14428810b00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+1c1c0d391f04584c1611@syzkaller.appspotmail.com

rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
rcu: 	1-...!: (1 GPs behind) idle=d93/1/0x4000000000000000 softirq=8752/8753 fqs=1 
	(detected by 0, t=10502 jiffies, g=8413, q=152)
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 PID: 6876 Comm: syz-executor436 Not tainted 5.15.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__lock_release kernel/locking/lockdep.c:5332 [inline]
RIP: 0010:lock_release+0x2d3/0x720 kernel/locking/lockdep.c:5645
Code: 24 50 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 0f b6 04 02 84 c0 74 08 3c 03 0f 8e 7f 03 00 00 48 89 da 45 89 a7 f0 09 00 00 <48> b8 00 00 00 00 00 fc ff df 48 c1 ea 03 80 3c 02 00 0f 85 aa 03
RSP: 0018:ffffc90000dc0cf8 EFLAGS: 00000046
RAX: 0000000000000000 RBX: ffff88807ab85fa0 RCX: ffffc90000dc0d48
RDX: ffff88807ab85fa0 RSI: 0000000000000000 RDI: ffff88807ab85fc2
RBP: 1ffff920001b81a1 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000001
R13: 0000000000000002 R14: ffff88807ab85f70 R15: ffff88807ab85580
FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fb09f92e370 CR3: 000000006f7cc000 CR4: 0000000000350ee0
Call Trace:
 <IRQ>
 __raw_spin_unlock include/linux/spinlock_api_smp.h:150 [inline]
 _raw_spin_unlock+0x12/0x40 kernel/locking/spinlock.c:186
 spin_unlock include/linux/spinlock.h:403 [inline]
 advance_sched+0x435/0x9a0 net/sched/sch_taprio.c:759
 __run_hrtimer kernel/time/hrtimer.c:1685 [inline]
 __hrtimer_run_queues+0x609/0xe50 kernel/time/hrtimer.c:1749
 hrtimer_interrupt+0x31c/0x790 kernel/time/hrtimer.c:1811
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1086 [inline]
 __sysvec_apic_timer_interrupt+0x146/0x530 arch/x86/kernel/apic/apic.c:1103
 sysvec_apic_timer_interrupt+0x8e/0xc0 arch/x86/kernel/apic/apic.c:1097
 </IRQ>
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:638
RIP: 0010:test_bit include/asm-generic/bitops/instrumented-non-atomic.h:134 [inline]
RIP: 0010:cpumask_test_cpu include/linux/cpumask.h:344 [inline]
RIP: 0010:cpu_online include/linux/cpumask.h:895 [inline]
RIP: 0010:trace_lock_acquire include/trace/events/lock.h:13 [inline]
RIP: 0010:lock_acquire+0xa7/0x510 kernel/locking/lockdep.c:5596
Code: a8 00 00 00 31 c0 0f 1f 44 00 00 65 8b 15 79 3d a6 7e 83 fa 07 0f 87 dc 03 00 00 89 d2 be 08 00 00 00 48 89 d0 48 89 54 24 08 <48> c1 f8 06 48 8d 3c c5 90 59 6e 8d e8 28 ff 61 00 48 8b 54 24 08
RSP: 0018:ffffc900036cf8c8 EFLAGS: 00000297
RAX: 0000000000000001 RBX: 1ffff920006d9f1b RCX: 0000000000000000
RDX: 0000000000000001 RSI: 0000000000000008 RDI: ffff8880b9d2cb60
RBP: 0000000000000001 R08: 0000000000000001 R09: 0000000000000000
R10: ffffffff819f4f2c R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: ffff8880b9d2cb60 R15: 0000000000000000
 local_lock_acquire include/linux/local_lock_internal.h:29 [inline]
 activate_page mm/swap.c:334 [inline]
 mark_page_accessed+0x1062/0x19d0 mm/swap.c:422
 zap_pte_range mm/memory.c:1359 [inline]
 zap_pmd_range mm/memory.c:1481 [inline]
 zap_pud_range mm/memory.c:1510 [inline]
 zap_p4d_range mm/memory.c:1531 [inline]
 unmap_page_range+0xd45/0x2a10 mm/memory.c:1552
 unmap_single_vma+0x198/0x310 mm/memory.c:1597
 unmap_vmas+0x16d/0x2f0 mm/memory.c:1629
 exit_mmap+0x1d0/0x630 mm/mmap.c:3171
 __mmput+0x122/0x4b0 kernel/fork.c:1115
 mmput+0x58/0x60 kernel/fork.c:1136
 exit_mm kernel/exit.c:501 [inline]
 do_exit+0xabc/0x2a30 kernel/exit.c:812
 do_group_exit+0x125/0x310 kernel/exit.c:922
 __do_sys_exit_group kernel/exit.c:933 [inline]
 __se_sys_exit_group kernel/exit.c:931 [inline]
 __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:931
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fb09f8b0669
Code: Unable to access opcode bytes at RIP 0x7fb09f8b063f.
RSP: 002b:00007fff211b6b38 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 00007fb09f92b410 RCX: 00007fb09f8b0669
RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffffffffffffffc0 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fb09f92b410
R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000001
INFO: NMI handler (nmi_cpu_backtrace_handler) took too long to run: 1.102 msecs
rcu: rcu_preempt kthread starved for 10500 jiffies! g8413 f0x0 RCU_GP_WAIT_FQS(5) ->state=0x0 ->cpu=0
rcu: 	Unless rcu_preempt kthread gets sufficient CPU time, OOM is now expected behavior.
rcu: RCU grace-period kthread stack dump:
task:rcu_preempt     state:R  running task     stack:28696 pid:   14 ppid:     2 flags:0x00004000
Call Trace:
 context_switch kernel/sched/core.c:4940 [inline]
 __schedule+0x940/0x26f0 kernel/sched/core.c:6287
 schedule+0xd3/0x270 kernel/sched/core.c:6366
 schedule_timeout+0x14a/0x2a0 kernel/time/timer.c:1881
 rcu_gp_fqs_loop+0x186/0x800 kernel/rcu/tree.c:1957
 rcu_gp_kthread+0x1de/0x320 kernel/rcu/tree.c:2130
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
rcu: Stack dump where RCU GP kthread last ran:
NMI backtrace for cpu 0
CPU: 0 PID: 153 Comm: kworker/u4:2 Not tainted 5.15.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events_unbound toggle_allocation_gate
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 nmi_cpu_backtrace.cold+0x47/0x144 lib/nmi_backtrace.c:105
 nmi_trigger_cpumask_backtrace+0x1ae/0x220 lib/nmi_backtrace.c:62
 trigger_single_cpu_backtrace include/linux/nmi.h:164 [inline]
 rcu_check_gp_kthread_starvation.cold+0x1fb/0x200 kernel/rcu/tree_stall.h:481
 print_other_cpu_stall kernel/rcu/tree_stall.h:586 [inline]
 check_cpu_stall kernel/rcu/tree_stall.h:729 [inline]
 rcu_pending kernel/rcu/tree.c:3880 [inline]
 rcu_sched_clock_irq+0x2125/0x2200 kernel/rcu/tree.c:2599
 update_process_times+0x16d/0x200 kernel/time/timer.c:1785
 tick_sched_handle+0x9b/0x180 kernel/time/tick-sched.c:226
 tick_sched_timer+0x1b0/0x2d0 kernel/time/tick-sched.c:1421
 __run_hrtimer kernel/time/hrtimer.c:1685 [inline]
 __hrtimer_run_queues+0x1c0/0xe50 kernel/time/hrtimer.c:1749
 hrtimer_interrupt+0x31c/0x790 kernel/time/hrtimer.c:1811
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1086 [inline]
 __sysvec_apic_timer_interrupt+0x146/0x530 arch/x86/kernel/apic/apic.c:1103
 sysvec_apic_timer_interrupt+0x8e/0xc0 arch/x86/kernel/apic/apic.c:1097
 </IRQ>
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:638
RIP: 0010:csd_lock_wait kernel/smp.c:440 [inline]
RIP: 0010:smp_call_function_many_cond+0x452/0xc20 kernel/smp.c:969
Code: 0b 00 85 ed 74 4d 48 b8 00 00 00 00 00 fc ff df 4d 89 f4 4c 89 f5 49 c1 ec 03 83 e5 07 49 01 c4 83 c5 03 e8 10 48 0b 00 f3 90 <41> 0f b6 04 24 40 38 c5 7c 08 84 c0 0f 85 33 06 00 00 8b 43 08 31
RSP: 0018:ffffc9000178f9f8 EFLAGS: 00000293
RAX: 0000000000000000 RBX: ffff8880b9d367c0 RCX: 0000000000000000
RDX: ffff8880162fd580 RSI: ffffffff816ab670 RDI: 0000000000000003
RBP: 0000000000000003 R08: 0000000000000000 R09: 0000000000000001
R10: ffffffff816ab696 R11: 0000000000000000 R12: ffffed10173a6cf9
R13: 0000000000000001 R14: ffff8880b9d367c8 R15: 0000000000000001
 on_each_cpu_cond_mask+0x56/0xa0 kernel/smp.c:1135
 on_each_cpu include/linux/smp.h:71 [inline]
 text_poke_sync arch/x86/kernel/alternative.c:929 [inline]
 text_poke_bp_batch+0x1b3/0x560 arch/x86/kernel/alternative.c:1114
 text_poke_flush arch/x86/kernel/alternative.c:1268 [inline]
 text_poke_flush arch/x86/kernel/alternative.c:1265 [inline]
 text_poke_finish+0x16/0x30 arch/x86/kernel/alternative.c:1275
 arch_jump_label_transform_apply+0x13/0x20 arch/x86/kernel/jump_label.c:146
 jump_label_update+0x1d5/0x430 kernel/jump_label.c:830
 static_key_enable_cpuslocked+0x1b1/0x260 kernel/jump_label.c:177
 static_key_enable+0x16/0x20 kernel/jump_label.c:190
 toggle_allocation_gate mm/kfence/core.c:626 [inline]
 toggle_allocation_gate+0x100/0x390 mm/kfence/core.c:618
 process_one_work+0x9bf/0x16b0 kernel/workqueue.c:2297
 worker_thread+0x658/0x11f0 kernel/workqueue.c:2444
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
----------------
Code disassembly (best guess):
   0:	24 50                	and    $0x50,%al
   2:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
   9:	fc ff df
   c:	48 c1 ea 03          	shr    $0x3,%rdx
  10:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  14:	84 c0                	test   %al,%al
  16:	74 08                	je     0x20
  18:	3c 03                	cmp    $0x3,%al
  1a:	0f 8e 7f 03 00 00    	jle    0x39f
  20:	48 89 da             	mov    %rbx,%rdx
  23:	45 89 a7 f0 09 00 00 	mov    %r12d,0x9f0(%r15)
* 2a:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax <-- trapping instruction
  31:	fc ff df
  34:	48 c1 ea 03          	shr    $0x3,%rdx
  38:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1)
  3c:	0f                   	.byte 0xf
  3d:	85                   	.byte 0x85
  3e:	aa                   	stos   %al,%es:(%rdi)
  3f:	03                   	.byte 0x3


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
