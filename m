Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D600348093A
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 13:52:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231713AbhL1Mw3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 07:52:29 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:47025 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231132AbhL1Mw2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Dec 2021 07:52:28 -0500
Received: by mail-il1-f197.google.com with SMTP id i9-20020a056e021d0900b002b3e956903dso11396822ila.13
        for <netdev@vger.kernel.org>; Tue, 28 Dec 2021 04:52:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=11nooCWDtmvUpI55+wRB4ob0xvfeRFlvs5fIqAgkHbo=;
        b=zIt7mugpZ2QpgUWBJMqMM2EyvNt7rCzPQPDnk1/nOd/J7p3gzx7BDHZOYRxekyLAK3
         3r0DNgI4tBMXnY7shovLAiyvuZ/pZn6nacIVOdBLBAOrwuJlqmpkMlPwknF0ZmtfaBKp
         jPQdZWRkFfj0rGjxnp96rW5/s7vtFFVCPZ08XTMJ3993q8qcTv2lJ/mqRSyjXDMxPamB
         SpMpi13ci6SKCDLO+5DUnPywwTJGqpPjmeTlXMb1xPRniD9tKdBpO+NoKPZoPbhwYXrI
         fa0e/Mr1nejkgLJnI86EfIK4JbRyexab1cKfWF54ZhcoCzz0izPS61WvlBPLu1Orfjpl
         4pJQ==
X-Gm-Message-State: AOAM530Lbb2TysvG/bFm4iEb/HAcmHubqTmnj6sZoQpjQl92ECfaU0jk
        At3jYpzhUWUYNx6WQf6fqVvLQiV6eBQWFLlsiSqBnLmdUMJf
X-Google-Smtp-Source: ABdhPJwRk6mBOOEdLxiEKFf3BqHUTu280FpyfIsQH09g1gDlmrAgp6AI4OHM7M08bYcLPyFcmZfaZIUdc0Z5gKEmMG1Ipv0jZXTJ
MIME-Version: 1.0
X-Received: by 2002:a05:6602:204d:: with SMTP id z13mr7002170iod.13.1640695947684;
 Tue, 28 Dec 2021 04:52:27 -0800 (PST)
Date:   Tue, 28 Dec 2021 04:52:27 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000256dc405d4344bce@google.com>
Subject: [syzbot] INFO: rcu detected stall in tx (2)
From:   syzbot <syzbot+da7323ba082560434f17@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    a8ad9a2434dc Merge tag 'efi-urgent-for-v5.16-2' of git://g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1342610db00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1a86c22260afac2f
dashboard link: https://syzkaller.appspot.com/bug?extid=da7323ba082560434f17
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+da7323ba082560434f17@syzkaller.appspotmail.com

rcu: INFO: rcu_preempt self-detected stall on CPU
rcu: 	0-...!: (1 GPs behind) idle=cb1/1/0x4000000000000000 softirq=63991/63995 fqs=2539 
	(t=10502 jiffies g=99869 q=2637)
rcu: rcu_preempt kthread starved for 5423 jiffies! g99869 f0x0 RCU_GP_WAIT_FQS(5) ->state=0x0 ->cpu=1
rcu: 	Unless rcu_preempt kthread gets sufficient CPU time, OOM is now expected behavior.
rcu: RCU grace-period kthread stack dump:
task:rcu_preempt     state:R  running task     stack:28680 pid:   14 ppid:     2 flags:0x00004000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:4972 [inline]
 __schedule+0xa9a/0x4900 kernel/sched/core.c:6253
 schedule+0xd2/0x260 kernel/sched/core.c:6326
 schedule_timeout+0x14a/0x2a0 kernel/time/timer.c:1881
 rcu_gp_fqs_loop+0x186/0x810 kernel/rcu/tree.c:1955
 rcu_gp_kthread+0x1de/0x320 kernel/rcu/tree.c:2128
 kthread+0x405/0x4f0 kernel/kthread.c:327
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
 </TASK>
rcu: Stack dump where RCU GP kthread last ran:
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 PID: 11226 Comm: kworker/1:3 Not tainted 5.16.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events ser_release
RIP: 0010:pv_wait_head_or_lock kernel/locking/qspinlock_paravirt.h:434 [inline]
RIP: 0010:__pv_queued_spin_lock_slowpath+0x3ba/0xb40 kernel/locking/qspinlock.c:508
Code: eb c6 45 01 01 41 bc 00 80 00 00 48 c1 e9 03 83 e3 07 41 be 01 00 00 00 48 b8 00 00 00 00 00 fc ff df 4c 8d 2c 01 eb 0c f3 90 <41> 83 ec 01 0f 84 72 04 00 00 41 0f b6 45 00 38 d8 7f 08 84 c0 0f
RSP: 0018:ffffc900036278c0 EFLAGS: 00000206
RAX: 0000000000000003 RBX: 0000000000000000 RCX: 1ffff1100fcb8d10
RDX: 0000000000000001 RSI: 0000000000000202 RDI: 0000000000000000
RBP: ffff88807e5c6880 R08: 0000000000000001 R09: ffffffff8ff76b6f
R10: 0000000000000001 R11: 000000000000000f R12: 0000000000006327
R13: ffffed100fcb8d10 R14: 0000000000000001 R15: ffff8880b9d3a880
FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000561790f9c9e8 CR3: 000000000b88e000 CR4: 0000000000350ee0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
Call Trace:
 <TASK>
 pv_queued_spin_lock_slowpath arch/x86/include/asm/paravirt.h:591 [inline]
 queued_spin_lock_slowpath arch/x86/include/asm/qspinlock.h:51 [inline]
 queued_spin_lock include/asm-generic/qspinlock.h:85 [inline]
 do_raw_spin_lock+0x200/0x2b0 kernel/locking/spinlock_debug.c:115
 spin_lock include/linux/spinlock.h:349 [inline]
 __netif_tx_lock include/linux/netdevice.h:4406 [inline]
 netif_tx_lock include/linux/netdevice.h:4491 [inline]
 netif_tx_lock_bh include/linux/netdevice.h:4500 [inline]
 dev_watchdog_down net/sched/sch_generic.c:511 [inline]
 dev_deactivate_many+0x277/0xc60 net/sched/sch_generic.c:1278
 __dev_close_many+0x133/0x2e0 net/core/dev.c:1561
 dev_close_many+0x22c/0x620 net/core/dev.c:1599
 dev_close net/core/dev.c:1625 [inline]
 dev_close+0x16d/0x210 net/core/dev.c:1619
 ser_release+0x162/0x270 drivers/net/caif/caif_serial.c:309
 process_one_work+0x9b2/0x1660 kernel/workqueue.c:2298
 worker_thread+0x65d/0x1130 kernel/workqueue.c:2445
 kthread+0x405/0x4f0 kernel/kthread.c:327
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
 </TASK>
NMI backtrace for cpu 0
CPU: 0 PID: 1224 Comm: aoe_tx0 Not tainted 5.16.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 nmi_cpu_backtrace.cold+0x47/0x144 lib/nmi_backtrace.c:111
 nmi_trigger_cpumask_backtrace+0x1b3/0x230 lib/nmi_backtrace.c:62
 trigger_single_cpu_backtrace include/linux/nmi.h:164 [inline]
 rcu_dump_cpu_stacks+0x25e/0x3f0 kernel/rcu/tree_stall.h:343
 print_cpu_stall kernel/rcu/tree_stall.h:627 [inline]
 check_cpu_stall kernel/rcu/tree_stall.h:711 [inline]
 rcu_pending kernel/rcu/tree.c:3878 [inline]
 rcu_sched_clock_irq.cold+0x5c/0x759 kernel/rcu/tree.c:2597
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
RIP: 0010:__raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:152 [inline]
RIP: 0010:_raw_spin_unlock_irqrestore+0x38/0x70 kernel/locking/spinlock.c:194
Code: 74 24 10 e8 fa db 15 f8 48 89 ef e8 b2 51 16 f8 81 e3 00 02 00 00 75 25 9c 58 f6 c4 02 75 2d 48 85 db 74 01 fb bf 01 00 00 00 <e8> f3 1b 09 f8 65 8b 05 0c a1 bb 76 85 c0 74 0a 5b 5d c3 e8 20 03
RSP: 0018:ffffc9000537fab8 EFLAGS: 00000206
RAX: 0000000000000002 RBX: 0000000000000200 RCX: 1ffffffff1fffe6e
RDX: 0000000000000000 RSI: 0000000000000202 RDI: 0000000000000001
RBP: ffffffff90790558 R08: 0000000000000001 R09: ffffffff8ff76b6f
R10: 0000000000000001 R11: 0000000000000001 R12: 00000000ffffffff
R13: ffff8880281b8001 R14: 0000000000000020 R15: 0000000000000020
 spin_unlock_irqrestore include/linux/spinlock.h:404 [inline]
 uart_write_room+0x174/0x2f0 drivers/tty/serial/serial_core.c:611
 tty_write_room+0x61/0x80 drivers/tty/tty_ioctl.c:79
 handle_tx+0x159/0x610 drivers/net/caif/caif_serial.c:226
 __netdev_start_xmit include/linux/netdevice.h:4994 [inline]
 netdev_start_xmit include/linux/netdevice.h:5008 [inline]
 xmit_one net/core/dev.c:3590 [inline]
 dev_hard_start_xmit+0x1eb/0x920 net/core/dev.c:3606
 __dev_queue_xmit+0x299a/0x3650 net/core/dev.c:4229
 tx+0x68/0xb0 drivers/block/aoe/aoenet.c:63
 kthread+0x1e7/0x3b0 drivers/block/aoe/aoecmd.c:1230
 kthread+0x405/0x4f0 kernel/kthread.c:327
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
 </TASK>
----------------
Code disassembly (best guess):
   0:	eb c6                	jmp    0xffffffc8
   2:	45 01 01             	add    %r8d,(%r9)
   5:	41 bc 00 80 00 00    	mov    $0x8000,%r12d
   b:	48 c1 e9 03          	shr    $0x3,%rcx
   f:	83 e3 07             	and    $0x7,%ebx
  12:	41 be 01 00 00 00    	mov    $0x1,%r14d
  18:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  1f:	fc ff df
  22:	4c 8d 2c 01          	lea    (%rcx,%rax,1),%r13
  26:	eb 0c                	jmp    0x34
  28:	f3 90                	pause
* 2a:	41 83 ec 01          	sub    $0x1,%r12d <-- trapping instruction
  2e:	0f 84 72 04 00 00    	je     0x4a6
  34:	41 0f b6 45 00       	movzbl 0x0(%r13),%eax
  39:	38 d8                	cmp    %bl,%al
  3b:	7f 08                	jg     0x45
  3d:	84 c0                	test   %al,%al
  3f:	0f                   	.byte 0xf


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
