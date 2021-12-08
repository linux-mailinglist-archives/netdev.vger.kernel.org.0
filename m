Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3728146DD33
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 21:36:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237004AbhLHUkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 15:40:05 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:37661 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240647AbhLHUju (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 15:39:50 -0500
Received: by mail-io1-f72.google.com with SMTP id m127-20020a6b3f85000000b005f045ba51f9so4619735ioa.4
        for <netdev@vger.kernel.org>; Wed, 08 Dec 2021 12:36:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=1eMzVkjs4ptAGWAHJG5P5ADuL3kIbtQVEk8LuTc0n6o=;
        b=nFRIPBJx4kXG6ssrYXkNFpCGbBizhO05t/nguz+6H/SLN5QnEhC4XA1q0yAktAnWW7
         hftOre5AzojOCN0JxaQnkrs0SNSSm6RICYeGAvSrjfIfre4o5Ww7PdGiO70pmRK8/Pio
         xru3qWRSLq09RRIPOul5KaIRXOLuA5xgpJSIvW3HLQmD5NBnOIsU1G2yyVAsz4tWRzwr
         tTpaQ37gzRNWuT1A12IOvPHzDA2lwPnTwre3tJ1vxdLem0kCnUwvw8FgOQSUyR3GPJE1
         LnKC5blpf96lX5OvKpM7c0wgWXODqiVmpU4mHW1wmBrfBEPEyJF9QZIrM2TqfDEiBYno
         pedA==
X-Gm-Message-State: AOAM530o4AMRvP3hAp9st+h/rf4nEi3Vki6jqJkN9FcQ5LPpepQjmAnJ
        nEZW13LXS3lePpxFrEO3eKuxAmLMaYxyd6+TTgYK0XMv0+gg
X-Google-Smtp-Source: ABdhPJzII9D2sRys1tjUCkp39Gl6tn1SQHF7nbIqdPSjVsrn3IO1kL/8JicHBhWDnGUs5dIfcLJ0lRYt33ehF6XzPlCKqSaxQbhK
MIME-Version: 1.0
X-Received: by 2002:a92:8751:: with SMTP id d17mr10582237ilm.148.1638995778462;
 Wed, 08 Dec 2021 12:36:18 -0800 (PST)
Date:   Wed, 08 Dec 2021 12:36:18 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000029e89205d2a8718d@google.com>
Subject: [syzbot] BUG: sleeping function called from invalid context in hci_cmd_sync_cancel
From:   syzbot <syzbot+485cc00ea7cf41dfdbf1@syzkaller.appspotmail.com>
To:     changbin.du@intel.com, christian.brauner@ubuntu.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, yajun.deng@linux.dev
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    4eee8d0b64ec Add linux-next specific files for 20211208
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=13d1329db00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=20b74d9da4ce1ef1
dashboard link: https://syzkaller.appspot.com/bug?extid=485cc00ea7cf41dfdbf1
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13e7e955b00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10ed3641b00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+485cc00ea7cf41dfdbf1@syzkaller.appspotmail.com

BUG: sleeping function called from invalid context at kernel/workqueue.c:3039
in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 8, name: kworker/u4:0
preempt_count: 101, expected: 0
RCU nest depth: 0, expected: 0
5 locks held by kworker/u4:0/8:
 #0: ffff8880155d9938 ((wq_completion)netns){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff8880155d9938 ((wq_completion)netns){+.+.}-{0:0}, at: arch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]
 #0: ffff8880155d9938 ((wq_completion)netns){+.+.}-{0:0}, at: atomic_long_set include/linux/atomic/atomic-instrumented.h:1280 [inline]
 #0: ffff8880155d9938 ((wq_completion)netns){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:635 [inline]
 #0: ffff8880155d9938 ((wq_completion)netns){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:662 [inline]
 #0: ffff8880155d9938 ((wq_completion)netns){+.+.}-{0:0}, at: process_one_work+0x896/0x1690 kernel/workqueue.c:2289
 #1: ffffc90000cd7db0 (net_cleanup_work){+.+.}-{0:0}, at: process_one_work+0x8ca/0x1690 kernel/workqueue.c:2293
 #2: ffffffff8d308150 (pernet_ops_rwsem){++++}-{3:3}, at: cleanup_net+0x9b/0xb00 net/core/net_namespace.c:555
 #3: ffff88806f0ab8f0 (&ent->pde_unload_lock){+.+.}-{2:2}, at: spin_lock include/linux/spinlock.h:354 [inline]
 #3: ffff88806f0ab8f0 (&ent->pde_unload_lock){+.+.}-{2:2}, at: proc_entry_rundown+0xe7/0x1d0 fs/proc/inode.c:266
 #4: ffffc90000dc0d70 ((&dum_hcd->timer)){+.-.}-{0:0}, at: lockdep_copy_map include/linux/lockdep.h:35 [inline]
 #4: ffffc90000dc0d70 ((&dum_hcd->timer)){+.-.}-{0:0}, at: call_timer_fn+0xd5/0x6b0 kernel/time/timer.c:1411
irq event stamp: 268125
hardirqs last  enabled at (268124): [<ffffffff8956ab6f>] __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:159 [inline]
hardirqs last  enabled at (268124): [<ffffffff8956ab6f>] _raw_spin_unlock_irq+0x1f/0x40 kernel/locking/spinlock.c:202
hardirqs last disabled at (268125): [<ffffffff8956a99e>] __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:108 [inline]
hardirqs last disabled at (268125): [<ffffffff8956a99e>] _raw_spin_lock_irqsave+0x4e/0x50 kernel/locking/spinlock.c:162
softirqs last  enabled at (268062): [<ffffffff885ab700>] spin_unlock_bh include/linux/spinlock.h:399 [inline]
softirqs last  enabled at (268062): [<ffffffff885ab700>] rxrpc_release_sock net/rxrpc/af_rxrpc.c:876 [inline]
softirqs last  enabled at (268062): [<ffffffff885ab700>] rxrpc_release+0x1f0/0x5a0 net/rxrpc/af_rxrpc.c:917
softirqs last disabled at (268119): [<ffffffff8146b723>] invoke_softirq kernel/softirq.c:432 [inline]
softirqs last disabled at (268119): [<ffffffff8146b723>] __irq_exit_rcu+0x123/0x180 kernel/softirq.c:637
Preemption disabled at:
[<0000000000000000>] 0x0
CPU: 1 PID: 8 Comm: kworker/u4:0 Not tainted 5.16.0-rc4-next-20211208-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: netns cleanup_net
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 __might_resched.cold+0x222/0x26b kernel/sched/core.c:9583
 start_flush_work kernel/workqueue.c:3039 [inline]
 __flush_work+0x109/0xb10 kernel/workqueue.c:3103
 __cancel_work_timer+0x3f9/0x570 kernel/workqueue.c:3191
 hci_cmd_sync_cancel net/bluetooth/hci_sync.c:346 [inline]
 hci_cmd_sync_cancel+0xe1/0x170 net/bluetooth/hci_sync.c:338
 btusb_intr_complete+0x3d3/0x4a0 drivers/bluetooth/btusb.c:969
 __usb_hcd_giveback_urb+0x2b0/0x5c0 drivers/usb/core/hcd.c:1656
 usb_hcd_giveback_urb+0x367/0x410 drivers/usb/core/hcd.c:1726
 dummy_timer+0x11f9/0x32b0 drivers/usb/gadget/udc/dummy_hcd.c:1987
 call_timer_fn+0x1a5/0x6b0 kernel/time/timer.c:1421
 expire_timers kernel/time/timer.c:1466 [inline]
 __run_timers.part.0+0x675/0xa20 kernel/time/timer.c:1734
 __run_timers kernel/time/timer.c:1715 [inline]
 run_timer_softirq+0xb3/0x1d0 kernel/time/timer.c:1747
 __do_softirq+0x29b/0x9c2 kernel/softirq.c:558
 invoke_softirq kernel/softirq.c:432 [inline]
 __irq_exit_rcu+0x123/0x180 kernel/softirq.c:637
 irq_exit_rcu+0x5/0x20 kernel/softirq.c:649
 sysvec_apic_timer_interrupt+0x93/0xc0 arch/x86/kernel/apic/apic.c:1097
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:638
RIP: 0010:lock_acquire+0x1ef/0x510 kernel/locking/lockdep.c:5607
Code: 9d a5 7e 83 f8 01 0f 85 b4 02 00 00 9c 58 f6 c4 02 0f 85 9f 02 00 00 48 83 7c 24 08 00 74 01 fb 48 b8 00 00 00 00 00 fc ff df <48> 01 c3 48 c7 03 00 00 00 00 48 c7 43 08 00 00 00 00 48 8b 84 24
RSP: 0000:ffffc90000cd7928 EFLAGS: 00000206
RAX: dffffc0000000000 RBX: 1ffff9200019af27 RCX: 0000000000000001
RDX: 1ffff110021cfc44 RSI: 0000000000000001 RDI: 0000000000000000
RBP: 0000000000000001 R08: 00000000000c1948 R09: 0000000000000001
R10: fffffbfff2024ea1 R11: 1ffffffff1ee5241 R12: 0000000000000000
R13: 0000000000000000 R14: ffff88806f0ab8f0 R15: 0000000000000000
 __raw_spin_lock include/linux/spinlock_api_smp.h:133 [inline]
 _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:154
 spin_lock include/linux/spinlock.h:354 [inline]
 proc_entry_rundown+0xe7/0x1d0 fs/proc/inode.c:266
 remove_proc_subtree+0x25c/0x500 fs/proc/generic.c:767
 proc_remove fs/proc/generic.c:790 [inline]
 proc_remove+0x66/0x90 fs/proc/generic.c:787
 afs_proc_cleanup+0x34/0x70 fs/afs/proc.c:703
 afs_net_exit+0x17d/0x320 fs/afs/main.c:159
 ops_exit_list+0xb0/0x160 net/core/net_namespace.c:168
 cleanup_net+0x4ea/0xb00 net/core/net_namespace.c:593
 process_one_work+0x9b2/0x1690 kernel/workqueue.c:2318
 worker_thread+0x658/0x11f0 kernel/workqueue.c:2465
 kthread+0x405/0x4f0 kernel/kthread.c:345
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
 </TASK>
----------------
Code disassembly (best guess):
   0:	9d                   	popfq
   1:	a5                   	movsl  %ds:(%rsi),%es:(%rdi)
   2:	7e 83                	jle    0xffffff87
   4:	f8                   	clc
   5:	01 0f                	add    %ecx,(%rdi)
   7:	85 b4 02 00 00 9c 58 	test   %esi,0x589c0000(%rdx,%rax,1)
   e:	f6 c4 02             	test   $0x2,%ah
  11:	0f 85 9f 02 00 00    	jne    0x2b6
  17:	48 83 7c 24 08 00    	cmpq   $0x0,0x8(%rsp)
  1d:	74 01                	je     0x20
  1f:	fb                   	sti
  20:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  27:	fc ff df
* 2a:	48 01 c3             	add    %rax,%rbx <-- trapping instruction
  2d:	48 c7 03 00 00 00 00 	movq   $0x0,(%rbx)
  34:	48 c7 43 08 00 00 00 	movq   $0x0,0x8(%rbx)
  3b:	00
  3c:	48                   	rex.W
  3d:	8b                   	.byte 0x8b
  3e:	84                   	.byte 0x84
  3f:	24                   	.byte 0x24


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
