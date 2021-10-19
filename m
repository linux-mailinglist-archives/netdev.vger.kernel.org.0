Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89DC8432C7E
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 05:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbhJSEBd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 00:01:33 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:55954 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbhJSEBc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 00:01:32 -0400
Received: by mail-io1-f70.google.com with SMTP id t16-20020a5d8850000000b005dc56fcd7e5so12298074ios.22
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 20:59:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=CXLu3Njd4HQy29X7aYrAHKb4yyo3yeWSYSnh0Cidu00=;
        b=mtSQiznZOAa7yQ/QZoADm7/vGQCtJ9MGO5I1AxCpPKm39vwKfF6iyjEvQN83RxkwZA
         BBR86ruO9z1PiYPz1vCHfW7k/sFJMLtUXhP9Oedj1fS7FF9b3uSw6ap5DsCcT0oJDp4k
         txAE1eV4PE8wDF7miMaqY6I3b9hkxx4DLIOp7OMD/7CzQ6OLuVQz9J+tmPVmcvvlNdM/
         5zvjW16t9pLaaFacwZNxf+on+uKbwB2k6ebm2gT2DUiIIroohIEtuZo/xT4SGVdwJao8
         DRBfIebxmZ0dF36OuaEYZgq0Xk6+cl6fLxrsTJCWSPUBvV4P/zYNcDU9Atpsq8w/yQ3z
         ogqA==
X-Gm-Message-State: AOAM533M8cAq2iMyJNdgjSd3levs54EWJUOPq8amNP3KEo2fmIBaMmDY
        DdMygFyzaCvQar99QoZ5VOaYAJ1vzFg7nV0PZAD6m33kyw4Q
X-Google-Smtp-Source: ABdhPJwiWLU6Niv1Rp7QH3jVOOdgdv8+XtU9gerOd1MjkaW+zGtzuHdjPoTXI1cVkcaajO9snerMGnco8ogcw1mYQMeNUXxFeI/e
MIME-Version: 1.0
X-Received: by 2002:a92:cdaa:: with SMTP id g10mr16367152ild.1.1634615960333;
 Mon, 18 Oct 2021 20:59:20 -0700 (PDT)
Date:   Mon, 18 Oct 2021 20:59:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a8f39905ceacaf6b@google.com>
Subject: [syzbot] INFO: rcu detected stall in prog_array_map_clear_deferred
From:   syzbot <syzbot+1e372cc42ba6b9d90a6b@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, john.fastabend@gmail.com, kafai@fb.com,
        kpsingh@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    7c832d2f9b95 Add linux-next specific files for 20211015
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=13d749ccb00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f6ac42766a768877
dashboard link: https://syzkaller.appspot.com/bug?extid=1e372cc42ba6b9d90a6b
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1702b644b00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16f91334b00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+1e372cc42ba6b9d90a6b@syzkaller.appspotmail.com

rcu: INFO: rcu_preempt self-detected stall on CPU
rcu: 	1-...!: (1 GPs behind) idle=38d/1/0x4000000000000000 softirq=10159/10160 fqs=234 
	(t=10500 jiffies g=11181 q=11)
rcu: rcu_preempt kthread starved for 9849 jiffies! g11181 f0x0 RCU_GP_WAIT_FQS(5) ->state=0x0 ->cpu=0
rcu: 	Unless rcu_preempt kthread gets sufficient CPU time, OOM is now expected behavior.
rcu: RCU grace-period kthread stack dump:
task:rcu_preempt     state:R  running task     stack:29304 pid:   14 ppid:     2 flags:0x00004000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:4965 [inline]
 __schedule+0xa9a/0x4940 kernel/sched/core.c:6246
 schedule+0xd2/0x260 kernel/sched/core.c:6319
 schedule_timeout+0x14a/0x2a0 kernel/time/timer.c:1881
 rcu_gp_fqs_loop+0x186/0x810 kernel/rcu/tree.c:1966
 rcu_gp_kthread+0x1de/0x320 kernel/rcu/tree.c:2139
 kthread+0x405/0x4f0 kernel/kthread.c:327
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
 </TASK>
rcu: Stack dump where RCU GP kthread last ran:
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 PID: 2713 Comm: kworker/0:3 Not tainted 5.15.0-rc5-next-20211015-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events prog_array_map_clear_deferred
RIP: 0010:check_preemption_disabled+0x2/0x170 lib/smp_processor_id.c:13
Code: 1f 44 00 00 e8 6f 16 4e f8 65 48 8b 3c 25 40 70 02 00 e8 41 43 05 f8 eb 99 0f 1f 44 00 00 0f 0b e9 23 ff ff ff cc cc cc 41 56 <41> 55 49 89 f5 41 54 55 48 89 fd 53 0f 1f 44 00 00 65 44 8b 25 cd
RSP: 0018:ffffc9000b95fa68 EFLAGS: 00000046
RAX: 0000000000000002 RBX: c8757c4f6cfa24cc RCX: ffffc9000b95fac8
RDX: 1ffff110046b014b RSI: ffffffff89ac08c0 RDI: ffffffff8a046f60
RBP: 1ffff9200172bf51 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000002
R13: 0000000000000003 R14: ffff888023580a60 R15: ffff888023580000
FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005555567352c0 CR3: 000000000b88e000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 lockdep_recursion_finish kernel/locking/lockdep.c:438 [inline]
 lock_release+0x3bb/0x720 kernel/locking/lockdep.c:5659
 __mutex_unlock_slowpath+0x99/0x5e0 kernel/locking/mutex.c:892
 fd_array_map_delete_elem+0x1b0/0x2e0 kernel/bpf/arraymap.c:824
 bpf_fd_array_map_clear kernel/bpf/arraymap.c:871 [inline]
 prog_array_map_clear_deferred+0x10b/0x1b0 kernel/bpf/arraymap.c:1050
 process_one_work+0x9b2/0x1690 kernel/workqueue.c:2297
 worker_thread+0x658/0x11f0 kernel/workqueue.c:2444
 kthread+0x405/0x4f0 kernel/kthread.c:327
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
 </TASK>
NMI backtrace for cpu 1
CPU: 1 PID: 23 Comm: kworker/1:1 Not tainted 5.15.0-rc5-next-20211015-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events prog_array_map_clear_deferred
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 nmi_cpu_backtrace.cold+0x47/0x144 lib/nmi_backtrace.c:105
 nmi_trigger_cpumask_backtrace+0x1ae/0x220 lib/nmi_backtrace.c:62
 trigger_single_cpu_backtrace include/linux/nmi.h:164 [inline]
 rcu_dump_cpu_stacks+0x25e/0x3f0 kernel/rcu/tree_stall.h:343
 print_cpu_stall kernel/rcu/tree_stall.h:604 [inline]
 check_cpu_stall kernel/rcu/tree_stall.h:688 [inline]
 rcu_pending kernel/rcu/tree.c:3889 [inline]
 rcu_sched_clock_irq.cold+0x9d/0x746 kernel/rcu/tree.c:2608
 update_process_times+0x16d/0x200 kernel/time/timer.c:1785
 tick_sched_handle+0x9b/0x180 kernel/time/tick-sched.c:226
 tick_sched_timer+0x1b0/0x2d0 kernel/time/tick-sched.c:1428
 __run_hrtimer kernel/time/hrtimer.c:1685 [inline]
 __hrtimer_run_queues+0x1c0/0xe50 kernel/time/hrtimer.c:1749
 hrtimer_interrupt+0x31c/0x790 kernel/time/hrtimer.c:1811
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1086 [inline]
 __sysvec_apic_timer_interrupt+0x146/0x530 arch/x86/kernel/apic/apic.c:1103
 sysvec_apic_timer_interrupt+0x8e/0xc0 arch/x86/kernel/apic/apic.c:1097
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:638
RIP: 0010:lock_is_held_type+0xff/0x140 kernel/locking/lockdep.c:5685
Code: 00 00 b8 ff ff ff ff 65 0f c1 05 0c 1a b5 76 83 f8 01 75 29 9c 58 f6 c4 02 75 3d 48 f7 04 24 00 02 00 00 74 01 fb 48 83 c4 08 <44> 89 e8 5b 5d 41 5c 41 5d 41 5e 41 5f c3 45 31 ed eb b9 0f 0b 48
RSP: 0018:ffffc90000ddfa30 EFLAGS: 00000296
RAX: 0000000000000046 RBX: 0000000000000003 RCX: 0000000000000001
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: ffffffff8bb82de0 R08: 0000000000000000 R09: ffffffff8d8fd297
R10: fffffbfff1b1fa52 R11: 0000000000000000 R12: ffff8880157b0000
R13: 0000000000000000 R14: 00000000ffffffff R15: ffff8880157b0ab8
 lock_is_held include/linux/lockdep.h:283 [inline]
 rcu_read_lock_sched_held+0x3a/0x70 kernel/rcu/update.c:125
 trace_lock_release include/trace/events/lock.h:58 [inline]
 lock_release+0x522/0x720 kernel/locking/lockdep.c:5648
 __mutex_unlock_slowpath+0x99/0x5e0 kernel/locking/mutex.c:892
 fd_array_map_delete_elem+0x1b0/0x2e0 kernel/bpf/arraymap.c:824
 bpf_fd_array_map_clear kernel/bpf/arraymap.c:871 [inline]
 prog_array_map_clear_deferred+0x10b/0x1b0 kernel/bpf/arraymap.c:1050
 process_one_work+0x9b2/0x1690 kernel/workqueue.c:2297
 worker_thread+0x658/0x11f0 kernel/workqueue.c:2444
 kthread+0x405/0x4f0 kernel/kthread.c:327
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
 </TASK>
----------------
Code disassembly (best guess), 1 bytes skipped:
   0:	44 00 00             	add    %r8b,(%rax)
   3:	e8 6f 16 4e f8       	callq  0xf84e1677
   8:	65 48 8b 3c 25 40 70 	mov    %gs:0x27040,%rdi
   f:	02 00
  11:	e8 41 43 05 f8       	callq  0xf8054357
  16:	eb 99                	jmp    0xffffffb1
  18:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  1d:	0f 0b                	ud2
  1f:	e9 23 ff ff ff       	jmpq   0xffffff47
  24:	cc                   	int3
  25:	cc                   	int3
  26:	cc                   	int3
  27:	41 56                	push   %r14
* 29:	41 55                	push   %r13 <-- trapping instruction
  2b:	49 89 f5             	mov    %rsi,%r13
  2e:	41 54                	push   %r12
  30:	55                   	push   %rbp
  31:	48 89 fd             	mov    %rdi,%rbp
  34:	53                   	push   %rbx
  35:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  3a:	65                   	gs
  3b:	44                   	rex.R
  3c:	8b                   	.byte 0x8b
  3d:	25                   	.byte 0x25
  3e:	cd                   	.byte 0xcd


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
