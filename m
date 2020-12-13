Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 336E92D8EB1
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 17:24:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727484AbgLMQXw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Dec 2020 11:23:52 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:47800 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726136AbgLMQXw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Dec 2020 11:23:52 -0500
Received: by mail-il1-f197.google.com with SMTP id s23so11585361ilk.14
        for <netdev@vger.kernel.org>; Sun, 13 Dec 2020 08:23:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Iwni+YtbLHs3ZSKcjfrHyb75vai9D6cvVexI6znW6fw=;
        b=bxr8rwthtw3UCH+mJns/LsYM3ZLU5HEsRoIx9eXfeiTeFrNXK7+Qk/h0IPpJOBvFy8
         oMWvVnYekTQSVonkEGZhZ0pXG9Lw8OiS2TVESP1SYbZhK93Es5YZ3KJmsFMPrDiPwjnC
         9xpkCawUqyfEIL2c0q+G5Scdk1eXw3FNhvefvDsbyVQLIANDrJs6mUP2tUP6ohF1GuOp
         VICx/FOM75KvoRBulXkdFZFUfqu7w2D0hcO5wGXs/3RDancUzBuZNhGnpntmIcdIMJoQ
         YOE7lbDMmvqyvqA1TqC1rWSegbG8h+iADO1qdh+mbHr8XdvAN9SQWdR7qXIjCK065LNS
         /I1w==
X-Gm-Message-State: AOAM533FKOvuAnmi8VmhUJLOhQFTjYtMQaEMKLynknCVutImel23jvoH
        rTxTh3upZy0ixT4VPL/8UjLd2cFn269KBUAPLzyPUHOatdc3
X-Google-Smtp-Source: ABdhPJzXr/CSj32kbKj8ySQBnKWQM204VY06qiLLbMloZRxRHBlewY6tQxih03VUFOxB2uuviXPO1IswUhWhtdcI499xVATLd13r
MIME-Version: 1.0
X-Received: by 2002:a05:6638:153:: with SMTP id y19mr28157499jao.47.1607876590778;
 Sun, 13 Dec 2020 08:23:10 -0800 (PST)
Date:   Sun, 13 Dec 2020 08:23:10 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000009442305b65af1fa@google.com>
Subject: INFO: task hung in netdev_run_todo (2)
From:   syzbot <syzbot+9d77543f47951a63d5c1@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    7575fdda Merge tag 'platform-drivers-x86-v5.9-2' of git://..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1110b33f900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c06bcf3cc963d91c
dashboard link: https://syzkaller.appspot.com/bug?extid=9d77543f47951a63d5c1
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+9d77543f47951a63d5c1@syzkaller.appspotmail.com

INFO: task kworker/u4:2:26 blocked for more than 143 seconds.
      Not tainted 5.9.0-rc8-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/u4:2    state:D stack:24024 pid:   26 ppid:     2 flags:0x00004000
Workqueue: netns cleanup_net
Call Trace:
 context_switch kernel/sched/core.c:3778 [inline]
 __schedule+0xec9/0x2280 kernel/sched/core.c:4527
 schedule+0xd0/0x2a0 kernel/sched/core.c:4602
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:4661
 __mutex_lock_common kernel/locking/mutex.c:1033 [inline]
 __mutex_lock+0x3e2/0x10e0 kernel/locking/mutex.c:1103
 netdev_run_todo+0x8f8/0xdb0 net/core/dev.c:10183
 ip6gre_exit_batch_net+0x516/0x750 net/ipv6/ip6_gre.c:1610
 ops_exit_list+0x10d/0x160 net/core/net_namespace.c:189
 cleanup_net+0x4ea/0xa00 net/core/net_namespace.c:603
 process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
 kthread+0x3b5/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
INFO: task kworker/0:4:8175 blocked for more than 143 seconds.
      Not tainted 5.9.0-rc8-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/0:4     state:D stack:25936 pid: 8175 ppid:     2 flags:0x00004000
Workqueue: events linkwatch_event
Call Trace:
 context_switch kernel/sched/core.c:3778 [inline]
 __schedule+0xec9/0x2280 kernel/sched/core.c:4527
 schedule+0xd0/0x2a0 kernel/sched/core.c:4602
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:4661
 __mutex_lock_common kernel/locking/mutex.c:1033 [inline]
 __mutex_lock+0x3e2/0x10e0 kernel/locking/mutex.c:1103
 linkwatch_event+0xb/0x60 net/core/link_watch.c:250
 process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
 kthread+0x3b5/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
INFO: task syz-executor.5:8896 blocked for more than 144 seconds.
      Not tainted 5.9.0-rc8-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.5  state:D stack:27440 pid: 8896 ppid:  6920 flags:0x00004004
Call Trace:
 context_switch kernel/sched/core.c:3778 [inline]
 __schedule+0xec9/0x2280 kernel/sched/core.c:4527
 schedule+0xd0/0x2a0 kernel/sched/core.c:4602
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:4661
 __mutex_lock_common kernel/locking/mutex.c:1033 [inline]
 __mutex_lock+0x3e2/0x10e0 kernel/locking/mutex.c:1103
 tc_new_tfilter+0x928/0x2130 net/sched/cls_api.c:2020
 rtnetlink_rcv_msg+0x80f/0xad0 net/core/rtnetlink.c:5554
 netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2470
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:671
 ____sys_sendmsg+0x331/0x810 net/socket.c:2353
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2407
 __sys_sendmmsg+0x195/0x480 net/socket.c:2497
 __do_sys_sendmmsg net/socket.c:2526 [inline]
 __se_sys_sendmmsg net/socket.c:2523 [inline]
 __x64_sys_sendmmsg+0x99/0x100 net/socket.c:2523
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45de29
Code: Bad RIP value.
RSP: 002b:00007f9e84d3cc78 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
RAX: ffffffffffffffda RBX: 0000000000027f40 RCX: 000000000045de29
RDX: 04924924924926d3 RSI: 0000000020000200 RDI: 0000000000000005
RBP: 000000000118c160 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000118c124
R13: 00007ffdec73781f R14: 00007f9e84d3d9c0 R15: 000000000118c124
INFO: task syz-executor.3:8909 blocked for more than 145 seconds.
      Not tainted 5.9.0-rc8-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.3  state:D stack:26800 pid: 8909 ppid:  6916 flags:0x00004004
Call Trace:
 context_switch kernel/sched/core.c:3778 [inline]
 __schedule+0xec9/0x2280 kernel/sched/core.c:4527
 schedule+0xd0/0x2a0 kernel/sched/core.c:4602
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:4661
 __mutex_lock_common kernel/locking/mutex.c:1033 [inline]
 __mutex_lock+0x3e2/0x10e0 kernel/locking/mutex.c:1103
 rtnl_lock net/core/rtnetlink.c:72 [inline]
 rtnetlink_rcv_msg+0x3f9/0xad0 net/core/rtnetlink.c:5560
 netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2470
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:671
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2353
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2407
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2440
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45de29
Code: Bad RIP value.
RSP: 002b:00007f269716ec78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 000000000002e5c0 RCX: 000000000045de29
RDX: 0000000000000000 RSI: 0000000020000140 RDI: 0000000000000005
RBP: 000000000118bf60 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000118bf2c
R13: 00007ffce0487dbf R14: 00007f269716f9c0 R15: 000000000118bf2c
INFO: task syz-executor.2:8929 blocked for more than 145 seconds.
      Not tainted 5.9.0-rc8-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.2  state:D stack:28360 pid: 8929 ppid:     1 flags:0x00000004
Call Trace:
 context_switch kernel/sched/core.c:3778 [inline]
 __schedule+0xec9/0x2280 kernel/sched/core.c:4527
 schedule+0xd0/0x2a0 kernel/sched/core.c:4602
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:4661
 __mutex_lock_common kernel/locking/mutex.c:1033 [inline]
 __mutex_lock+0x3e2/0x10e0 kernel/locking/mutex.c:1103
 rtnl_lock net/core/rtnetlink.c:72 [inline]
 rtnetlink_rcv_msg+0x3f9/0xad0 net/core/rtnetlink.c:5560
 netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2470
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:671
 __sys_sendto+0x21c/0x320 net/socket.c:1992
 __do_sys_sendto net/socket.c:2004 [inline]
 __se_sys_sendto net/socket.c:2000 [inline]
 __x64_sys_sendto+0xdd/0x1b0 net/socket.c:2000
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x4178a7
Code: Bad RIP value.
RSP: 002b:00007ffdfb298fd0 EFLAGS: 00000293 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 00000000016a4300 RCX: 00000000004178a7
RDX: 0000000000000028 RSI: 00000000016a4350 RDI: 0000000000000003
RBP: 0000000000000000 R08: 00007ffdfb298fe0 R09: 000000000000000c
R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000000000
R13: 0000000000000000 R14: 00000000016a4350 R15: 0000000000000003

Showing all locks held in the system:
4 locks held by kworker/u4:2/26:
 #0: ffff88821b047138 ((wq_completion)netns){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff88821b047138 ((wq_completion)netns){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff88821b047138 ((wq_completion)netns){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff88821b047138 ((wq_completion)netns){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff88821b047138 ((wq_completion)netns){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff88821b047138 ((wq_completion)netns){+.+.}-{0:0}, at: process_one_work+0x82b/0x1670 kernel/workqueue.c:2240
 #1: ffffc90000e27da8 (net_cleanup_work){+.+.}-{0:0}, at: process_one_work+0x85f/0x1670 kernel/workqueue.c:2244
 #2: ffffffff8b13d830 (pernet_ops_rwsem){++++}-{3:3}, at: cleanup_net+0x9b/0xa00 net/core/net_namespace.c:565
 #3: ffffffff8b14f0c8 (rtnl_mutex){+.+.}-{3:3}, at: netdev_run_todo+0x8f8/0xdb0 net/core/dev.c:10183
1 lock held by khungtaskd/1175:
 #0: ffffffff8a067f40 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:5852
1 lock held by in:imklog/6574:
 #0: ffff888091a216b0 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xe9/0x100 fs/file.c:930
3 locks held by kworker/0:4/8175:
 #0: ffff8880aa063d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff8880aa063d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff8880aa063d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff8880aa063d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff8880aa063d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff8880aa063d38 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x82b/0x1670 kernel/workqueue.c:2240
 #1: ffffc90015e77da8 ((linkwatch_work).work){+.+.}-{0:0}, at: process_one_work+0x85f/0x1670 kernel/workqueue.c:2244
 #2: ffffffff8b14f0c8 (rtnl_mutex){+.+.}-{3:3}, at: linkwatch_event+0xb/0x60 net/core/link_watch.c:250
3 locks held by kworker/0:5/8220:
 #0: ffff888214886d38 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888214886d38 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff888214886d38 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888214886d38 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff888214886d38 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff888214886d38 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: process_one_work+0x82b/0x1670 kernel/workqueue.c:2240
 #1: ffffc90015fc7da8 ((addr_chk_work).work){+.+.}-{0:0}, at: process_one_work+0x85f/0x1670 kernel/workqueue.c:2244
 #2: ffffffff8b14f0c8 (rtnl_mutex){+.+.}-{3:3}, at: addrconf_verify_work+0xa/0x20 net/ipv6/addrconf.c:4568
2 locks held by syz-executor.5/8871:
1 lock held by syz-executor.5/8896:
 #0: ffffffff8b14f0c8 (rtnl_mutex){+.+.}-{3:3}, at: tc_new_tfilter+0x928/0x2130 net/sched/cls_api.c:2020
1 lock held by syz-executor.3/8909:
 #0: ffffffff8b14f0c8 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:72 [inline]
 #0: ffffffff8b14f0c8 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x3f9/0xad0 net/core/rtnetlink.c:5560
1 lock held by syz-executor.2/8929:
 #0: ffffffff8b14f0c8 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:72 [inline]
 #0: ffffffff8b14f0c8 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x3f9/0xad0 net/core/rtnetlink.c:5560

=============================================

NMI backtrace for cpu 0
CPU: 0 PID: 1175 Comm: khungtaskd Not tainted 5.9.0-rc8-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x198/0x1fd lib/dump_stack.c:118
 nmi_cpu_backtrace.cold+0x70/0xb1 lib/nmi_backtrace.c:101
 nmi_trigger_cpumask_backtrace+0x1b3/0x223 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:209 [inline]
 watchdog+0xd7d/0x1000 kernel/hung_task.c:295
 kthread+0x3b5/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 PID: 7 Comm: kworker/u4:0 Not tainted 5.9.0-rc8-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: bat_events batadv_nc_worker
RIP: 0010:lockdep_recursion_finish kernel/locking/lockdep.c:398 [inline]
RIP: 0010:lock_release+0x43a/0x8f0 kernel/locking/lockdep.c:5051
Code: 9a 02 00 00 65 4c 8b 24 25 c0 fe 01 00 49 8d bc 24 e4 08 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 0f b6 14 02 <48> 89 f8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 fe 02 00 00 41
RSP: 0018:ffffc90000cdfb38 EFLAGS: 00000803
RAX: dffffc0000000000 RBX: 0000000000000003 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffff8880472c8e98 RDI: ffff8880a960eaa4
RBP: 1ffff9200019bf69 R08: 0000000000000001 R09: ffff8880a960eaa0
R10: fffffbfff16b3019 R11: 0000000000000000 R12: ffff8880a960e1c0
R13: 0000000000000002 R14: ffffffff880a9b45 R15: ffff8880a960e1c0
FS:  0000000000000000(0000) GS:ffff8880ae500000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f33c36ef000 CR3: 00000000a7f77000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 __raw_spin_unlock_bh include/linux/spinlock_api_smp.h:174 [inline]
 _raw_spin_unlock_bh+0x12/0x30 kernel/locking/spinlock.c:207
 spin_unlock_bh include/linux/spinlock.h:399 [inline]
 batadv_nc_purge_paths+0x2a5/0x3a0 net/batman-adv/network-coding.c:470
 batadv_nc_worker+0x831/0xe50 net/batman-adv/network-coding.c:719
 process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
 kthread+0x3b5/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
