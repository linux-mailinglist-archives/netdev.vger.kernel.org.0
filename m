Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BE00413E79
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 02:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231646AbhIVAO6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 20:14:58 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:35667 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231416AbhIVAO5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 20:14:57 -0400
Received: by mail-il1-f197.google.com with SMTP id f4-20020a056e0204c400b0022dbd3f8b18so949276ils.2
        for <netdev@vger.kernel.org>; Tue, 21 Sep 2021 17:13:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=xTrUY2uA7AiKnyXvK/CrMXSVvhh4URRQOLghViNT4h0=;
        b=JXrcNeZvJBIuLTUMprrPf3gOoUHpeMb8iWymx5gf+zaxPQXZnU5cUwVa4mRXPy0TZA
         t4+PjVleq305yOFGqCOzW7s0JH3KiLTLh+8YAy2FgtQvBWe/LJzFykQ+4QIqme9uA3+I
         AE7b/aoyX8OZhWhUkG2+rRfLiBWAKY3ifgUquJUOqGKCtiLtBX54XO8uxAa5oxAmE6S3
         ybNNc7ouyDABhpUdNe6fWrVACLmp+dKgzkHJF06FbtzTYBCAR2WKBLk4RdrgcRcbp+E+
         x8ZqtUvGitAAe0mToShoxqELG6GM0cYYZbGh6g0yBpUVbeVwHBqXJ0H4vRXGFvWJmP0V
         fNZQ==
X-Gm-Message-State: AOAM530nu65ONm3KkOQZs0hIZU0OEBUV3SQFO7vEuiFOdhx6Qj8ElVvI
        RIwu+HS2Hrq3Ux1Y9WaVwakP88bMGQMsKKDImzMETe/aXv7K
X-Google-Smtp-Source: ABdhPJyhYVQd+eTR5J4ZGA6HbK2Oc0fZ6PYdwyP0wRslcK+1bMXY+IU6se6h42t/BLv/dbgVdhhmfgJF7RAzhu4QyGT0ceblWyRH
MIME-Version: 1.0
X-Received: by 2002:a02:cd17:: with SMTP id g23mr2342168jaq.29.1632269608554;
 Tue, 21 Sep 2021 17:13:28 -0700 (PDT)
Date:   Tue, 21 Sep 2021 17:13:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003216d705cc8a62d6@google.com>
Subject: [syzbot] INFO: rcu detected stall in sys_recvmmsg
From:   syzbot <syzbot+3360da629681aa0d22fe@syzkaller.appspotmail.com>
To:     axboe@kernel.dk, christian.brauner@ubuntu.com, davem@davemloft.net,
        dkadashev@gmail.com, kuba@kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, torvalds@linux-foundation.org,
        viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    1f77990c4b79 Add linux-next specific files for 20210920
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1383891d300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ab1346371f2e6884
dashboard link: https://syzkaller.appspot.com/bug?extid=3360da629681aa0d22fe
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1625f1ab300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17eb1b3b300000

The issue was bisected to:

commit 020250f31c4c75ac7687a673e29c00786582a5f4
Author: Dmitry Kadashev <dkadashev@gmail.com>
Date:   Thu Jul 8 06:34:43 2021 +0000

    namei: make do_linkat() take struct filename

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15f5ef77300000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=17f5ef77300000
console output: https://syzkaller.appspot.com/x/log.txt?x=13f5ef77300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3360da629681aa0d22fe@syzkaller.appspotmail.com
Fixes: 020250f31c4c ("namei: make do_linkat() take struct filename")

rcu: INFO: rcu_preempt self-detected stall on CPU
rcu: 	0-...!: (10499 ticks this GP) idle=0af/1/0x4000000000000000 softirq=10678/10678 fqs=1 
	(t=10500 jiffies g=13089 q=109)
rcu: rcu_preempt kthread starved for 10497 jiffies! g13089 f0x0 RCU_GP_WAIT_FQS(5) ->state=0x0 ->cpu=1
rcu: 	Unless rcu_preempt kthread gets sufficient CPU time, OOM is now expected behavior.
rcu: RCU grace-period kthread stack dump:
task:rcu_preempt     state:R  running task     stack:28696 pid:   14 ppid:     2 flags:0x00004000
Call Trace:
 context_switch kernel/sched/core.c:4955 [inline]
 __schedule+0x940/0x26f0 kernel/sched/core.c:6236
 schedule+0xd3/0x270 kernel/sched/core.c:6315
 schedule_timeout+0x14a/0x2a0 kernel/time/timer.c:1881
 rcu_gp_fqs_loop+0x186/0x810 kernel/rcu/tree.c:1955
 rcu_gp_kthread+0x1de/0x320 kernel/rcu/tree.c:2128
 kthread+0x405/0x4f0 kernel/kthread.c:327
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
rcu: Stack dump where RCU GP kthread last ran:
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 PID: 8510 Comm: syz-executor827 Not tainted 5.15.0-rc2-next-20210920-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:bytes_is_nonzero mm/kasan/generic.c:84 [inline]
RIP: 0010:memory_is_nonzero mm/kasan/generic.c:102 [inline]
RIP: 0010:memory_is_poisoned_n mm/kasan/generic.c:128 [inline]
RIP: 0010:memory_is_poisoned mm/kasan/generic.c:159 [inline]
RIP: 0010:check_region_inline mm/kasan/generic.c:180 [inline]
RIP: 0010:kasan_check_range+0xc8/0x180 mm/kasan/generic.c:189
Code: 38 00 74 ed 48 8d 50 08 eb 09 48 83 c0 01 48 39 d0 74 7a 80 38 00 74 f2 48 89 c2 b8 01 00 00 00 48 85 d2 75 56 5b 5d 41 5c c3 <48> 85 d2 74 5e 48 01 ea eb 09 48 83 c0 01 48 39 d0 74 50 80 38 00
RSP: 0018:ffffc9000cd676c8 EFLAGS: 00000283
RAX: ffffed100e9a110e RBX: ffffed100e9a110f RCX: ffffffff88ea062a
RDX: 0000000000000001 RSI: 0000000000000008 RDI: ffff888074d08870
RBP: ffffed100e9a110e R08: 0000000000000001 R09: ffff888074d08877
R10: ffffed100e9a110e R11: 0000000000000000 R12: ffff888074d08000
R13: ffff888074d08000 R14: ffff888074d08088 R15: ffff888074d08000
FS:  0000555556d8e300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000180 CR3: 0000000068909000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 instrument_atomic_read_write include/linux/instrumented.h:101 [inline]
 test_and_clear_bit include/asm-generic/bitops/instrumented-atomic.h:83 [inline]
 mptcp_release_cb+0x14a/0x210 net/mptcp/protocol.c:3016
 release_sock+0xb4/0x1b0 net/core/sock.c:3204
 mptcp_wait_data net/mptcp/protocol.c:1770 [inline]
 mptcp_recvmsg+0xfd1/0x27b0 net/mptcp/protocol.c:2080
 inet6_recvmsg+0x11b/0x5e0 net/ipv6/af_inet6.c:659
 sock_recvmsg_nosec net/socket.c:944 [inline]
 ____sys_recvmsg+0x527/0x600 net/socket.c:2626
 ___sys_recvmsg+0x127/0x200 net/socket.c:2670
 do_recvmmsg+0x24d/0x6d0 net/socket.c:2764
 __sys_recvmmsg net/socket.c:2843 [inline]
 __do_sys_recvmmsg net/socket.c:2866 [inline]
 __se_sys_recvmmsg net/socket.c:2859 [inline]
 __x64_sys_recvmmsg+0x20b/0x260 net/socket.c:2859
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fc200d2dc39
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 41 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc5758e5a8 EFLAGS: 00000246 ORIG_RAX: 000000000000012b
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007fc200d2dc39
RDX: 0000000000000002 RSI: 00000000200017c0 RDI: 0000000000000003
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000f0b5ff
R10: 0000000000000100 R11: 0000000000000246 R12: 0000000000000003
R13: 00007ffc5758e5d0 R14: 00007ffc5758e5c0 R15: 0000000000000003
INFO: NMI handler (nmi_cpu_backtrace_handler) took too long to run: 1.444 msecs
NMI backtrace for cpu 0
CPU: 0 PID: 8509 Comm: syz-executor827 Not tainted 5.15.0-rc2-next-20210920-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 nmi_cpu_backtrace.cold+0x47/0x144 lib/nmi_backtrace.c:105
 nmi_trigger_cpumask_backtrace+0x1ae/0x220 lib/nmi_backtrace.c:62
 trigger_single_cpu_backtrace include/linux/nmi.h:164 [inline]
 rcu_dump_cpu_stacks+0x25e/0x3f0 kernel/rcu/tree_stall.h:343
 print_cpu_stall kernel/rcu/tree_stall.h:627 [inline]
 check_cpu_stall kernel/rcu/tree_stall.h:711 [inline]
 rcu_pending kernel/rcu/tree.c:3878 [inline]
 rcu_sched_clock_irq.cold+0x9d/0x746 kernel/rcu/tree.c:2597
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
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:638
RIP: 0010:lock_release+0x3f1/0x720 kernel/locking/lockdep.c:5633
Code: 7e 83 f8 01 0f 85 8d 01 00 00 9c 58 f6 c4 02 0f 85 78 01 00 00 48 f7 04 24 00 02 00 00 74 01 fb 48 b8 00 00 00 00 00 fc ff df <48> 01 c5 48 c7 45 00 00 00 00 00 c7 45 08 00 00 00 00 48 8b 84 24
RSP: 0018:ffffc9000cde7660 EFLAGS: 00000206
RAX: dffffc0000000000 RBX: 70dbee1ebc366ab9 RCX: ffffc9000cde76b0
RDX: 1ffff11003a0bc2b RSI: 0000000000000201 RDI: 0000000000000000
RBP: 1ffff920019bcece R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000443 R12: 0000000000000001
R13: 0000000000000002 R14: ffff88801d05e160 R15: ffff88801d05d700
 __raw_spin_unlock_bh include/linux/spinlock_api_smp.h:174 [inline]
 _raw_spin_unlock_bh+0x12/0x30 kernel/locking/spinlock.c:210
 spin_unlock_bh include/linux/spinlock.h:413 [inline]
 unlock_sock_fast include/net/sock.h:1644 [inline]
 unlock_sock_fast include/net/sock.h:1636 [inline]
 mptcp_subflow_cleanup_rbuf net/mptcp/protocol.c:468 [inline]
 mptcp_cleanup_rbuf net/mptcp/protocol.c:499 [inline]
 mptcp_recvmsg+0xb8b/0x27b0 net/mptcp/protocol.c:2027
 inet6_recvmsg+0x11b/0x5e0 net/ipv6/af_inet6.c:659
 sock_recvmsg_nosec net/socket.c:944 [inline]
 ____sys_recvmsg+0x527/0x600 net/socket.c:2626
 ___sys_recvmsg+0x127/0x200 net/socket.c:2670
 do_recvmmsg+0x24d/0x6d0 net/socket.c:2764
 __sys_recvmmsg net/socket.c:2843 [inline]
 __do_sys_recvmmsg net/socket.c:2866 [inline]
 __se_sys_recvmmsg net/socket.c:2859 [inline]
 __x64_sys_recvmmsg+0x20b/0x260 net/socket.c:2859
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fc200d2dc39
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 41 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc5758e5a8 EFLAGS: 00000246 ORIG_RAX: 000000000000012b
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007fc200d2dc39
RDX: 0000000000000002 RSI: 00000000200017c0 RDI: 0000000000000003
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000f0b5ff
R10: 0000000000000100 R11: 0000000000000246 R12: 0000000000000003
R13: 00007ffc5758e5d0 R14: 00007ffc5758e5c0 R15: 0000000000000003
----------------
Code disassembly (best guess):
   0:	38 00                	cmp    %al,(%rax)
   2:	74 ed                	je     0xfffffff1
   4:	48 8d 50 08          	lea    0x8(%rax),%rdx
   8:	eb 09                	jmp    0x13
   a:	48 83 c0 01          	add    $0x1,%rax
   e:	48 39 d0             	cmp    %rdx,%rax
  11:	74 7a                	je     0x8d
  13:	80 38 00             	cmpb   $0x0,(%rax)
  16:	74 f2                	je     0xa
  18:	48 89 c2             	mov    %rax,%rdx
  1b:	b8 01 00 00 00       	mov    $0x1,%eax
  20:	48 85 d2             	test   %rdx,%rdx
  23:	75 56                	jne    0x7b
  25:	5b                   	pop    %rbx
  26:	5d                   	pop    %rbp
  27:	41 5c                	pop    %r12
  29:	c3                   	retq
* 2a:	48 85 d2             	test   %rdx,%rdx <-- trapping instruction
  2d:	74 5e                	je     0x8d
  2f:	48 01 ea             	add    %rbp,%rdx
  32:	eb 09                	jmp    0x3d
  34:	48 83 c0 01          	add    $0x1,%rax
  38:	48 39 d0             	cmp    %rdx,%rax
  3b:	74 50                	je     0x8d
  3d:	80 38 00             	cmpb   $0x0,(%rax)


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
