Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AED85215910
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 16:02:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729335AbgGFOC1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 10:02:27 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:37261 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729326AbgGFOCW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 10:02:22 -0400
Received: by mail-io1-f70.google.com with SMTP id 63so17888274ioy.4
        for <netdev@vger.kernel.org>; Mon, 06 Jul 2020 07:02:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=aMczGxmM1HSulrVavn4v21RrI9KjwYjRm8s4w2PRZ1Q=;
        b=osMQ/JmI30f2tsoufRdOZdtVkOEwPOQusQ+yJsUsb0EirDZb/oOvSuFniOyRCC0T8j
         IMjMFbAULGPfoMs9HTK6d2XfhjWuvQT2SD+J5EdsFiCuA1mb+SjLF/4/1Cg7tyvQoGdG
         dlChu79tj3CeACDAZG53JctgMsWLOSdf7ZORouOwb6Ne4G2/Qp3MW7DsFuFijJSt+OON
         nFNMdv0xL6qopBTDf1ccscpwhjuRHv0rV/LUYyn8+DY+p1GYvx+3ff6ghdvQyDW4V9AX
         4S1LFX+CUAxtdRdAVAwHacExo8lgJF+uTv0B1duLAqsWYzLXFgzG/ananw1EcZILeQ17
         ZoBw==
X-Gm-Message-State: AOAM5328mgPzCysL0WgO8avDC6TKBVD1lQmDz3Jumn+ZQ1RZqgEZTIab
        xb9zhDpxPC225/qC/BnpLVS33ojW40P0fkSUBOo8JzTvnNlp
X-Google-Smtp-Source: ABdhPJxI0WQtefc+nPpG3hrsh6K0ZrgDh6grcPRrjp7GvPJAI+qzrwipOkbC9/RoWiTQsZp5iDBquWyBmAxmN35HAmW8WBATmzGO
MIME-Version: 1.0
X-Received: by 2002:a02:a797:: with SMTP id e23mr26260311jaj.81.1594044139724;
 Mon, 06 Jul 2020 07:02:19 -0700 (PDT)
Date:   Mon, 06 Jul 2020 07:02:19 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b4698a05a9c65284@google.com>
Subject: INFO: task hung in rwlock_bug
From:   syzbot <syzbot+5c3a96e9b26271b2db8c@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org, mkl@pengutronix.de,
        netdev@vger.kernel.org, socketcan@hartkopp.net,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    115a5416 Merge branch 'fixes' of git://git.kernel.org/pub/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12b5067e100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9a8d9fdac44b778b
dashboard link: https://syzkaller.appspot.com/bug?extid=5c3a96e9b26271b2db8c
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+5c3a96e9b26271b2db8c@syzkaller.appspotmail.com

INFO: task syz-executor.3:19435 blocked for more than 143 seconds.
      Not tainted 5.7.0-rc6-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor.3  D29864 19435   7571 0x00000004
Call Trace:
 context_switch kernel/sched/core.c:3367 [inline]
 __schedule+0x937/0x1ff0 kernel/sched/core.c:4083
 __sched_text_start+0x8/0x8
 atomic_try_cmpxchg include/asm-generic/atomic-instrumented.h:694 [inline]
 queued_spin_lock include/asm-generic/qspinlock.h:78 [inline]
 do_raw_spin_lock+0x129/0x2e0 kernel/locking/spinlock_debug.c:113
 rwlock_bug.part.0+0x90/0x90 include/linux/sched.h:1329
 schedule+0xd0/0x2a0 kernel/sched/core.c:4158
 rwsem_down_write_slowpath+0x706/0xf90 kernel/locking/rwsem.c:1235
 rwsem_mark_wake+0x8d0/0x8d0 include/linux/compiler.h:199
 lock_acquire+0x1f2/0x8f0 kernel/locking/lockdep.c:4934
 register_netdevice_notifier+0x1e/0x270 net/core/dev.c:1729
 pcpu_region_overlap mm/percpu.c:564 [inline]
 pcpu_block_update_hint_alloc+0x742/0xb00 mm/percpu.c:877
 lock_release+0x800/0x800 kernel/locking/lockdep.c:4689
 atomic64_cmpxchg include/asm-generic/atomic-instrumented.h:1463 [inline]
 atomic_long_cmpxchg_release include/asm-generic/atomic-long.h:424 [inline]
 __mutex_unlock_slowpath+0xe2/0x660 kernel/locking/mutex.c:1249
 __down_write kernel/locking/rwsem.c:1389 [inline]
 down_write+0x137/0x150 kernel/locking/rwsem.c:1532
 atomic64_try_cmpxchg include/asm-generic/atomic-instrumented.h:1504 [inline]
 atomic_long_try_cmpxchg_acquire include/asm-generic/atomic-long.h:442 [inline]
 __down_write kernel/locking/rwsem.c:1387 [inline]
 down_write+0xb2/0x150 kernel/locking/rwsem.c:1532
 __down_write kernel/locking/rwsem.c:1389 [inline]
 down_write+0x137/0x150 kernel/locking/rwsem.c:1532
 __down_timeout+0x2d0/0x2d0
 pcpu_alloc+0x128/0x13b0 mm/percpu.c:1740
 register_netdevice_notifier+0x1e/0x270 net/core/dev.c:1729
 raw_init+0x296/0x340 net/can/raw.c:339
 raw_sock_no_ioctlcmd+0x10/0x10 net/can/raw.c:843
 can_create+0x27c/0x500 net/can/af_can.c:168
 __sock_create+0x3cb/0x730 net/socket.c:1433
 sock_create net/socket.c:1484 [inline]
 __sys_socket+0xef/0x200 net/socket.c:1526
 move_addr_to_kernel+0x70/0x70 net/socket.c:195
 __do_sys_clock_gettime kernel/time/posix-timers.c:1094 [inline]
 __se_sys_clock_gettime kernel/time/posix-timers.c:1082 [inline]
 __x64_sys_clock_gettime+0x165/0x240 kernel/time/posix-timers.c:1082
 __ia32_sys_clock_settime+0x260/0x260 kernel/time/posix-timers.c:1410
 trace_hardirqs_off_caller+0x55/0x230 kernel/trace/trace_preemptirq.c:73
 __do_sys_socket net/socket.c:1535 [inline]
 __se_sys_socket net/socket.c:1533 [inline]
 __x64_sys_socket+0x6f/0xb0 net/socket.c:1533
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
INFO: task syz-executor.3:19444 blocked for more than 143 seconds.
      Not tainted 5.7.0-rc6-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor.3  D29864 19444   7571 0x00000004
Call Trace:
 context_switch kernel/sched/core.c:3367 [inline]
 __schedule+0x937/0x1ff0 kernel/sched/core.c:4083
 __sched_text_start+0x8/0x8
 atomic_try_cmpxchg include/asm-generic/atomic-instrumented.h:694 [inline]
 queued_spin_lock include/asm-generic/qspinlock.h:78 [inline]
 do_raw_spin_lock+0x129/0x2e0 kernel/locking/spinlock_debug.c:113
 rwsem_optimistic_spin+0x550/0x550 include/linux/compiler.h:226
 rwlock_bug.part.0+0x90/0x90 include/linux/sched.h:1329
 schedule+0xd0/0x2a0 kernel/sched/core.c:4158
 rwsem_down_write_slowpath+0x706/0xf90 kernel/locking/rwsem.c:1235
 rwsem_mark_wake+0x8d0/0x8d0 include/linux/compiler.h:199
 lock_acquire+0x1f2/0x8f0 kernel/locking/lockdep.c:4934
 register_netdevice_notifier+0x1e/0x270 net/core/dev.c:1729
 pcpu_region_overlap mm/percpu.c:564 [inline]
 pcpu_block_update_hint_alloc+0x742/0xb00 mm/percpu.c:877
 lock_release+0x800/0x800 kernel/locking/lockdep.c:4689
 atomic64_cmpxchg include/asm-generic/atomic-instrumented.h:1463 [inline]
 atomic_long_cmpxchg_release include/asm-generic/atomic-long.h:424 [inline]
 __mutex_unlock_slowpath+0xe2/0x660 kernel/locking/mutex.c:1249
 __down_write kernel/locking/rwsem.c:1389 [inline]
 down_write+0x137/0x150 kernel/locking/rwsem.c:1532
 atomic64_try_cmpxchg include/asm-generic/atomic-instrumented.h:1504 [inline]
 atomic_long_try_cmpxchg_acquire include/asm-generic/atomic-long.h:442 [inline]
 __down_write kernel/locking/rwsem.c:1387 [inline]
 down_write+0xb2/0x150 kernel/locking/rwsem.c:1532
 __down_write kernel/locking/rwsem.c:1389 [inline]
 down_write+0x137/0x150 kernel/locking/rwsem.c:1532
 __down_timeout+0x2d0/0x2d0
 pcpu_alloc+0x128/0x13b0 mm/percpu.c:1740
 register_netdevice_notifier+0x1e/0x270 net/core/dev.c:1729
 raw_init+0x296/0x340 net/can/raw.c:339
 raw_sock_no_ioctlcmd+0x10/0x10 net/can/raw.c:843
 can_create+0x27c/0x500 net/can/af_can.c:168
 __sock_create+0x3cb/0x730 net/socket.c:1433
 sock_create net/socket.c:1484 [inline]
 __sys_socket+0xef/0x200 net/socket.c:1526
 move_addr_to_kernel+0x70/0x70 net/socket.c:195
 __do_sys_clock_gettime kernel/time/posix-timers.c:1094 [inline]
 __se_sys_clock_gettime kernel/time/posix-timers.c:1082 [inline]
 __x64_sys_clock_gettime+0x165/0x240 kernel/time/posix-timers.c:1082
 __ia32_sys_clock_settime+0x260/0x260 kernel/time/posix-timers.c:1410
 trace_hardirqs_off_caller+0x55/0x230 kernel/trace/trace_preemptirq.c:73
 __do_sys_socket net/socket.c:1535 [inline]
 __se_sys_socket net/socket.c:1533 [inline]
 __x64_sys_socket+0x6f/0xb0 net/socket.c:1533
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
INFO: lockdep is turned off.
NMI backtrace for cpu 1
CPU: 1 PID: 1140 Comm: khungtaskd Not tainted 5.7.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 nmi_cpu_backtrace.cold+0x70/0xb1 lib/nmi_backtrace.c:101
 lapic_can_unplug_cpu.cold+0x3b/0x3b
 nmi_trigger_cpumask_backtrace+0x231/0x27e lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:205 [inline]
 watchdog+0xa8c/0x1010 kernel/hung_task.c:289
 reset_hung_task_detector+0x30/0x30 kernel/hung_task.c:243
 kthread+0x388/0x470 kernel/kthread.c:268
 kthread_mod_delayed_work+0x1a0/0x1a0 kernel/kthread.c:1090
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:351
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 PID: 37 Comm: kworker/u4:2 Not tainted 5.7.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: krdsd rds_connect_worker
RIP: 0010:ib_net include/net/inet_hashtables.h:95 [inline]
RIP: 0010:inet_csk_find_open_port net/ipv4/inet_connection_sock.c:226 [inline]
RIP: 0010:inet_csk_get_port+0xccc/0x2590 net/ipv4/inet_connection_sock.c:312
Code: 30 4d 85 ed 0f 84 1d 01 00 00 e8 ff 32 dc fa 49 83 ed 30 0f 84 0e 01 00 00 e8 f0 32 dc fa 4c 89 e8 48 c1 e8 03 42 80 3c 30 00 <0f> 85 69 13 00 00 4d 39 65 00 75 ac e8 d3 32 dc fa 49 8d 7d 08 48
RSP: 0018:ffffc90000e479b8 EFLAGS: 00000246
RAX: 1ffff11014ca0520 RBX: 000000000000aed1 RCX: ffffffff815a8879
RDX: 0000000000000000 RSI: ffffffff869703a0 RDI: ffffc9000588c9e8
RBP: ffffc90000e47b20 R08: 0000000000000004 R09: fffff520001c8f2a
R10: 0000000000000003 R11: fffff520001c8f29 R12: ffff888051efa180
R13: ffff8880a6502900 R14: dffffc0000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f28f326b000 CR3: 000000008b084000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 inet_csk_listen_stop+0xb20/0xb20 net/ipv4/inet_connection_sock.c:1041
 lock_downgrade+0x840/0x840 kernel/locking/lockdep.c:4579
 __inet6_bind+0x5d5/0x19c0 net/ipv6/af_inet6.c:404
 inet6_bind+0xf3/0x15c net/ipv6/af_inet6.c:454
 rds_tcp_conn_path_connect+0x39a/0x880 net/rds/tcp_connect.c:144
 rds_tcp_state_change+0x270/0x270 net/rds/tcp_connect.c:70
 lock_release+0x800/0x800 kernel/locking/lockdep.c:4689
 rds_connect_worker+0x1a5/0x2c0 net/rds/threads.c:176
 process_one_work+0x965/0x16a0 kernel/workqueue.c:2268
 lock_release+0x800/0x800 kernel/locking/lockdep.c:4689
 pwq_dec_nr_in_flight+0x310/0x310 kernel/workqueue.c:1198
 rwlock_bug.part.0+0x90/0x90 include/linux/sched.h:1329
 worker_thread+0x96/0xe20 kernel/workqueue.c:2414
 process_one_work+0x16a0/0x16a0 kernel/workqueue.c:2273
 kthread+0x388/0x470 kernel/kthread.c:268
 kthread_mod_delayed_work+0x1a0/0x1a0 kernel/kthread.c:1090
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:351


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
