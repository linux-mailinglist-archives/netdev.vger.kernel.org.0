Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB57122A0F4
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 22:52:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733005AbgGVUwZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 16:52:25 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:49975 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726642AbgGVUwY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 16:52:24 -0400
Received: by mail-il1-f199.google.com with SMTP id w10so1940609ilm.16
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 13:52:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=JdIfjEHL+4A5TZ1xt8pLCAOTUkFCQbJUUrKsXuvdFP4=;
        b=Z2Vz9tHxPXfQilu5TOMByBe+ulKyawIb0be6oZ+dseXvaEgoev9V8xKe6JnHKPvhXU
         M7tKK4N2rFeDar8KAT1wtwazWYvq4EuozEwCTfFKYDrt0IX05cOaT9Z/HI0Pa7VavVl+
         dVzAzEXlk+X7x4Akriolb36Wcp0eNF6bo6fO9uWq/bDyZggTwoVUOc/FNscmalkZzRn4
         98iQBZcto2ibx7d4Kq/kULNZpkcD1mcRVHfBTxpp9XSEVtwdf77DdRPy2JaRKykafEzS
         0HSbqluf4d6RREa6EVmkk8Sy8LvWPRzRgHQmpdWV+roeB3r5X+5TjR6ilggw60G5pWyD
         FDZQ==
X-Gm-Message-State: AOAM532C+DynmzKmy/WCN12CdzAnFAjJw6osgGTlweVIaIDxJYVQt1JI
        9y1HG7wFyETf3OmxKckqehPjt1jXIx2jx3qUohZNKy9n6kip
X-Google-Smtp-Source: ABdhPJyaYmph2NjkUB1AEgB66swQU3JjWn1Fb28H9aqxkbGfTM+QSLu9sHe36kygZ6JaG9FixRcAH7Ue8yW+p/138HbMaGXCW8mD
MIME-Version: 1.0
X-Received: by 2002:a6b:bc41:: with SMTP id m62mr1498917iof.95.1595451142845;
 Wed, 22 Jul 2020 13:52:22 -0700 (PDT)
Date:   Wed, 22 Jul 2020 13:52:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a03cc305ab0deaea@google.com>
Subject: INFO: task hung in ovs_dp_masks_rebalance
From:   syzbot <syzbot+bad6507e5db05017b008@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dev@openvswitch.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pshelar@ovn.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    fa56a987 Merge branch 'ionic-updates'
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1105f053100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2b7b67c0c1819c87
dashboard link: https://syzkaller.appspot.com/bug?extid=bad6507e5db05017b008
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+bad6507e5db05017b008@syzkaller.appspotmail.com

INFO: task kworker/1:8:10136 blocked for more than 143 seconds.
      Not tainted 5.8.0-rc4-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kworker/1:8     D27336 10136      2 0x00004000
Workqueue: events ovs_dp_masks_rebalance
Call Trace:
 context_switch kernel/sched/core.c:3453 [inline]
 __schedule+0x8e1/0x1eb0 kernel/sched/core.c:4178
 schedule+0xd0/0x2a0 kernel/sched/core.c:4253
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:4312
 __mutex_lock_common kernel/locking/mutex.c:1033 [inline]
 __mutex_lock+0x3e2/0x10d0 kernel/locking/mutex.c:1103
 ovs_lock net/openvswitch/datapath.c:105 [inline]
 ovs_dp_masks_rebalance+0x18/0x80 net/openvswitch/datapath.c:2355
 process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
 kthread+0x3b5/0x4a0 kernel/kthread.c:291
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293
INFO: task kworker/0:9:8606 blocked for more than 143 seconds.
      Not tainted 5.8.0-rc4-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kworker/0:9     D27792  8606      2 0x00004000
Workqueue: events ovs_dp_masks_rebalance
Call Trace:
 context_switch kernel/sched/core.c:3453 [inline]
 __schedule+0x8e1/0x1eb0 kernel/sched/core.c:4178
 schedule+0xd0/0x2a0 kernel/sched/core.c:4253
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:4312
 __mutex_lock_common kernel/locking/mutex.c:1033 [inline]
 __mutex_lock+0x3e2/0x10d0 kernel/locking/mutex.c:1103
 ovs_lock net/openvswitch/datapath.c:105 [inline]
 ovs_dp_masks_rebalance+0x18/0x80 net/openvswitch/datapath.c:2355
 process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
 kthread+0x3b5/0x4a0 kernel/kthread.c:291
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293
INFO: task syz-executor.2:9414 blocked for more than 143 seconds.
      Not tainted 5.8.0-rc4-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor.2  D27832  9414   7005 0x00004004
Call Trace:
 context_switch kernel/sched/core.c:3453 [inline]
 __schedule+0x8e1/0x1eb0 kernel/sched/core.c:4178
 schedule+0xd0/0x2a0 kernel/sched/core.c:4253
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:4312
 __mutex_lock_common kernel/locking/mutex.c:1033 [inline]
 __mutex_lock+0x3e2/0x10d0 kernel/locking/mutex.c:1103
 ovs_lock net/openvswitch/datapath.c:105 [inline]
 ovs_dp_cmd_new+0x69d/0x1160 net/openvswitch/datapath.c:1690
 genl_family_rcv_msg_doit net/netlink/genetlink.c:669 [inline]
 genl_family_rcv_msg net/netlink/genetlink.c:714 [inline]
 genl_rcv_msg+0x61d/0x980 net/netlink/genetlink.c:731
 netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2469
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:742
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:671
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2363
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2417
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2450
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45c1f9
Code: Bad RIP value.
RSP: 002b:00007f864e02dc78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 000000000002b400 RCX: 000000000045c1f9
RDX: 0000000000000000 RSI: 00000000200000c0 RDI: 0000000000000003
RBP: 000000000078bf40 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000078bf0c
R13: 00007ffc8c137ccf R14: 00007f864e02e9c0 R15: 000000000078bf0c
INFO: task syz-executor.2:9422 blocked for more than 144 seconds.
      Not tainted 5.8.0-rc4-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor.2  D27040  9422   7005 0x00004004
Call Trace:
 context_switch kernel/sched/core.c:3453 [inline]
 __schedule+0x8e1/0x1eb0 kernel/sched/core.c:4178
 schedule+0xd0/0x2a0 kernel/sched/core.c:4253
 schedule_timeout+0x1d8/0x250 kernel/time/timer.c:1873
 do_wait_for_common kernel/sched/completion.c:85 [inline]
 __wait_for_common kernel/sched/completion.c:106 [inline]
 wait_for_common kernel/sched/completion.c:117 [inline]
 wait_for_completion+0x163/0x260 kernel/sched/completion.c:138
 __flush_work+0x51f/0xab0 kernel/workqueue.c:3046
 __cancel_work_timer+0x5de/0x700 kernel/workqueue.c:3133
 ovs_dp_cmd_del+0x18c/0x270 net/openvswitch/datapath.c:1790
 genl_family_rcv_msg_doit net/netlink/genetlink.c:669 [inline]
 genl_family_rcv_msg net/netlink/genetlink.c:714 [inline]
 genl_rcv_msg+0x61d/0x980 net/netlink/genetlink.c:731
 netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2469
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:742
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:671
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2363
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2417
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2450
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45c1f9
Code: Bad RIP value.
RSP: 002b:00007f864e00cc78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 000000000002b400 RCX: 000000000045c1f9
RDX: 0000000000000000 RSI: 0000000020001980 RDI: 0000000000000004
RBP: 000000000078bfe0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000078bfac
R13: 00007ffc8c137ccf R14: 00007f864e00d9c0 R15: 000000000078bfac
INFO: task syz-executor.2:9427 blocked for more than 144 seconds.
      Not tainted 5.8.0-rc4-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor.2  D27688  9427   7005 0x00004004
Call Trace:
 context_switch kernel/sched/core.c:3453 [inline]
 __schedule+0x8e1/0x1eb0 kernel/sched/core.c:4178
 schedule+0xd0/0x2a0 kernel/sched/core.c:4253
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:4312
 __mutex_lock_common kernel/locking/mutex.c:1033 [inline]
 __mutex_lock+0x3e2/0x10d0 kernel/locking/mutex.c:1103
 ovs_lock net/openvswitch/datapath.c:105 [inline]
 ovs_dp_cmd_del+0x4a/0x270 net/openvswitch/datapath.c:1780
 genl_family_rcv_msg_doit net/netlink/genetlink.c:669 [inline]
 genl_family_rcv_msg net/netlink/genetlink.c:714 [inline]
 genl_rcv_msg+0x61d/0x980 net/netlink/genetlink.c:731
 netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2469
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:742
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:671
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2363
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2417
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2450
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45c1f9
Code: Bad RIP value.
RSP: 002b:00007f864dfebc78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 000000000002b400 RCX: 000000000045c1f9
RDX: 0000000000000000 RSI: 0000000020001980 RDI: 0000000000000004
RBP: 000000000078c080 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000078c04c
R13: 00007ffc8c137ccf R14: 00007f864dfec9c0 R15: 000000000078c04c

Showing all locks held in the system:
1 lock held by khungtaskd/1147:
 #0: ffffffff89bc0ec0 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:5779
1 lock held by in:imklog/6505:
 #0: ffff888095ffe8b0 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xe9/0x100 fs/file.c:826
3 locks held by kworker/1:8/10136:
 #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x82b/0x1670 kernel/workqueue.c:2240
 #1: ffffc900017f7da8 ((work_completion)(&(&dp->masks_rebalance)->work)){+.+.}-{0:0}, at: process_one_work+0x85f/0x1670 kernel/workqueue.c:2244
 #2: ffffffff8aa5d868 (ovs_mutex){+.+.}-{3:3}, at: ovs_lock net/openvswitch/datapath.c:105 [inline]
 #2: ffffffff8aa5d868 (ovs_mutex){+.+.}-{3:3}, at: ovs_dp_masks_rebalance+0x18/0x80 net/openvswitch/datapath.c:2355
3 locks held by kworker/0:9/8606:
 #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x82b/0x1670 kernel/workqueue.c:2240
 #1: ffffc90016617da8 ((work_completion)(&(&dp->masks_rebalance)->work)){+.+.}-{0:0}, at: process_one_work+0x85f/0x1670 kernel/workqueue.c:2244
 #2: ffffffff8aa5d868 (ovs_mutex){+.+.}-{3:3}, at: ovs_lock net/openvswitch/datapath.c:105 [inline]
 #2: ffffffff8aa5d868 (ovs_mutex){+.+.}-{3:3}, at: ovs_dp_masks_rebalance+0x18/0x80 net/openvswitch/datapath.c:2355
2 locks held by syz-executor.2/9414:
 #0: ffffffff8a817810 (cb_lock){++++}-{3:3}, at: genl_rcv+0x15/0x40 net/netlink/genetlink.c:741
 #1: ffffffff8aa5d868 (ovs_mutex){+.+.}-{3:3}, at: ovs_lock net/openvswitch/datapath.c:105 [inline]
 #1: ffffffff8aa5d868 (ovs_mutex){+.+.}-{3:3}, at: ovs_dp_cmd_new+0x69d/0x1160 net/openvswitch/datapath.c:1690
2 locks held by syz-executor.2/9422:
 #0: ffffffff8a817810 (cb_lock){++++}-{3:3}, at: genl_rcv+0x15/0x40 net/netlink/genetlink.c:741
 #1: ffffffff8aa5d868 (ovs_mutex){+.+.}-{3:3}, at: ovs_lock net/openvswitch/datapath.c:105 [inline]
 #1: ffffffff8aa5d868 (ovs_mutex){+.+.}-{3:3}, at: ovs_dp_cmd_del+0x4a/0x270 net/openvswitch/datapath.c:1780
2 locks held by syz-executor.2/9427:
 #0: ffffffff8a817810 (cb_lock){++++}-{3:3}, at: genl_rcv+0x15/0x40 net/netlink/genetlink.c:741
 #1: ffffffff8aa5d868 (ovs_mutex){+.+.}-{3:3}, at: ovs_lock net/openvswitch/datapath.c:105 [inline]
 #1: ffffffff8aa5d868 (ovs_mutex){+.+.}-{3:3}, at: ovs_dp_cmd_del+0x4a/0x270 net/openvswitch/datapath.c:1780

=============================================

NMI backtrace for cpu 1
CPU: 1 PID: 1147 Comm: khungtaskd Not tainted 5.8.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 nmi_cpu_backtrace.cold+0x70/0xb1 lib/nmi_backtrace.c:101
 nmi_trigger_cpumask_backtrace+0x1b3/0x223 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:209 [inline]
 watchdog+0xd7d/0x1000 kernel/hung_task.c:295
 kthread+0x3b5/0x4a0 kernel/kthread.c:291
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 PID: 3875 Comm: systemd-journal Not tainted 5.8.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0033:0x7fad4c407b07
Code: Bad RIP value.
RSP: 002b:00007ffef2a78c90 EFLAGS: 00000206
RAX: 00000000ffffffea RBX: 00005556a5c274b0 RCX: fffffffffffffe00
RDX: 00000000000001a0 RSI: 0000000000000001 RDI: 00005556a5c274b0
RBP: 0000000000000000 R08: 00000000000001c0 R09: 00000000ffffffff
R10: 0000000000000069 R11: 0000000000000246 R12: 00000000ffffffff
R13: 00000000fffffffe R14: 00007ffef2a78f90 R15: 00005556a5c274b0
FS:  00007fad4c7198c0 GS:  0000000000000000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
