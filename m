Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16B6B400780
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 23:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348517AbhICVlY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 17:41:24 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:38614 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242776AbhICVlX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 17:41:23 -0400
Received: by mail-io1-f69.google.com with SMTP id n8-20020a6b7708000000b005bd491bdb6aso246552iom.5
        for <netdev@vger.kernel.org>; Fri, 03 Sep 2021 14:40:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=vJJosjkjHEMd0EnJ8Iiy5enLhb3uk5Gy2JobC3CiLhQ=;
        b=FXcS6IbqiTF8san/ySs0chUvsNLVu3C8/r/p6C0akhG4dnqP3y2/9OlxvhQpPWOCMx
         gUzjJAy8Pu7GGktA1NvrUNq43H1VydfJg4ABvKTWCCKPrlr7BrdRMGiJ+rfKzHgfmV/d
         N1p7PKAjmR3ugGhMDfAMIS+En6fjqPYvCykBcRVXxNcGzpWwvAS9xStfIVSHPd9w+uu0
         2Mj2oxy1dcJPFTtiUSlWP2AOs44A9Kq15ZlTmlSYCSgVxOIRFZ5/MS/6QNStiEnAJ4Er
         diZ7mlbh8VmWyvnF0QBE9WF0GywNpd1RLI4LMuuGS0YwxxnhKbMF4gXqUdyei5gEhKPh
         0eKw==
X-Gm-Message-State: AOAM531GR+CASs64noc4DlEe+mJedWgyCkyUiE1AgykzFr8H/N6NAKOj
        fVQHs7qCexetYWHaEY/+Kni0YpmL86jwCiZm50Ya1d/Rf+9f
X-Google-Smtp-Source: ABdhPJzJqBTgjNgsWqbTpaNwZRZz0+EBMJVSmSe/Ixjt+Bya/SysGiQrmP4y/snBsXYG2k8dXNtvbcntenCgese2fXEhJ//RNULP
MIME-Version: 1.0
X-Received: by 2002:a92:cc01:: with SMTP id s1mr707826ilp.15.1630705222445;
 Fri, 03 Sep 2021 14:40:22 -0700 (PDT)
Date:   Fri, 03 Sep 2021 14:40:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000084733d05cb1e2585@google.com>
Subject: [syzbot] INFO: task hung in ovs_dp_masks_rebalance (2)
From:   syzbot <syzbot+45a5ef16ab5bc505d42a@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dev@openvswitch.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pshelar@ovn.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    7d2a07b76933 Linux 5.14
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=164cc59d300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3931e3b26cba5acf
dashboard link: https://syzkaller.appspot.com/bug?extid=45a5ef16ab5bc505d42a
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+45a5ef16ab5bc505d42a@syzkaller.appspotmail.com

INFO: task kworker/0:2:8001 blocked for more than 143 seconds.
      Not tainted 5.14.0-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/0:2     state:D stack:25088 pid: 8001 ppid:     2 flags:0x00004000
Workqueue: events ovs_dp_masks_rebalance
Call Trace:
 context_switch kernel/sched/core.c:4695 [inline]
 __schedule+0x93a/0x26f0 kernel/sched/core.c:6026
 schedule+0xd3/0x270 kernel/sched/core.c:6105
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6164
 __mutex_lock_common kernel/locking/mutex.c:1036 [inline]
 __mutex_lock+0x7b6/0x10a0 kernel/locking/mutex.c:1104
 ovs_lock net/openvswitch/datapath.c:106 [inline]
 ovs_dp_masks_rebalance+0x20/0xf0 net/openvswitch/datapath.c:2386
 process_one_work+0x98d/0x1630 kernel/workqueue.c:2276
 worker_thread+0x658/0x11f0 kernel/workqueue.c:2422
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
INFO: task kworker/1:0:13766 blocked for more than 143 seconds.
      Not tainted 5.14.0-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/1:0     state:D stack:22448 pid:13766 ppid:     2 flags:0x00004000
Workqueue: events ovs_dp_masks_rebalance
Call Trace:
 context_switch kernel/sched/core.c:4695 [inline]
 __schedule+0x93a/0x26f0 kernel/sched/core.c:6026
 schedule+0xd3/0x270 kernel/sched/core.c:6105
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6164
 __mutex_lock_common kernel/locking/mutex.c:1036 [inline]
 __mutex_lock+0x7b6/0x10a0 kernel/locking/mutex.c:1104
 ovs_lock net/openvswitch/datapath.c:106 [inline]
 ovs_dp_masks_rebalance+0x20/0xf0 net/openvswitch/datapath.c:2386
 process_one_work+0x98d/0x1630 kernel/workqueue.c:2276
 worker_thread+0x658/0x11f0 kernel/workqueue.c:2422
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
INFO: task kworker/1:1:9214 blocked for more than 143 seconds.
      Not tainted 5.14.0-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/1:1     state:D stack:26048 pid: 9214 ppid:     2 flags:0x00004000
Workqueue: events ovs_dp_masks_rebalance
Call Trace:
 context_switch kernel/sched/core.c:4695 [inline]
 __schedule+0x93a/0x26f0 kernel/sched/core.c:6026
 schedule+0xd3/0x270 kernel/sched/core.c:6105
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6164
 __mutex_lock_common kernel/locking/mutex.c:1036 [inline]
 __mutex_lock+0x7b6/0x10a0 kernel/locking/mutex.c:1104
 ovs_lock net/openvswitch/datapath.c:106 [inline]
 ovs_dp_masks_rebalance+0x20/0xf0 net/openvswitch/datapath.c:2386
 process_one_work+0x98d/0x1630 kernel/workqueue.c:2276
 worker_thread+0x658/0x11f0 kernel/workqueue.c:2422
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
INFO: task kworker/1:7:27170 blocked for more than 143 seconds.
      Not tainted 5.14.0-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/1:7     state:D stack:25128 pid:27170 ppid:     2 flags:0x00004000
Workqueue: events ovs_dp_masks_rebalance
Call Trace:
 context_switch kernel/sched/core.c:4695 [inline]
 __schedule+0x93a/0x26f0 kernel/sched/core.c:6026
 schedule+0xd3/0x270 kernel/sched/core.c:6105
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6164
 __mutex_lock_common kernel/locking/mutex.c:1036 [inline]
 __mutex_lock+0x7b6/0x10a0 kernel/locking/mutex.c:1104
 ovs_lock net/openvswitch/datapath.c:106 [inline]
 ovs_dp_masks_rebalance+0x20/0xf0 net/openvswitch/datapath.c:2386
 process_one_work+0x98d/0x1630 kernel/workqueue.c:2276
 worker_thread+0x658/0x11f0 kernel/workqueue.c:2422
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
INFO: task kworker/0:10:27216 blocked for more than 143 seconds.
      Not tainted 5.14.0-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/0:10    state:D stack:27856 pid:27216 ppid:     2 flags:0x00004000
Workqueue: events ovs_dp_masks_rebalance
Call Trace:
 context_switch kernel/sched/core.c:4695 [inline]
 __schedule+0x93a/0x26f0 kernel/sched/core.c:6026
 schedule+0xd3/0x270 kernel/sched/core.c:6105
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6164
 __mutex_lock_common kernel/locking/mutex.c:1036 [inline]
 __mutex_lock+0x7b6/0x10a0 kernel/locking/mutex.c:1104
 ovs_lock net/openvswitch/datapath.c:106 [inline]
 ovs_dp_masks_rebalance+0x20/0xf0 net/openvswitch/datapath.c:2386
 process_one_work+0x98d/0x1630 kernel/workqueue.c:2276
 worker_thread+0x658/0x11f0 kernel/workqueue.c:2422
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
INFO: task syz-executor.0:28248 blocked for more than 144 seconds.
      Not tainted 5.14.0-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.0  state:D stack:27160 pid:28248 ppid: 27309 flags:0x00004004
Call Trace:
 context_switch kernel/sched/core.c:4695 [inline]
 __schedule+0x93a/0x26f0 kernel/sched/core.c:6026
 schedule+0xd3/0x270 kernel/sched/core.c:6105
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6164
 __mutex_lock_common kernel/locking/mutex.c:1036 [inline]
 __mutex_lock+0x7b6/0x10a0 kernel/locking/mutex.c:1104
 ovs_lock net/openvswitch/datapath.c:106 [inline]
 ovs_dp_cmd_new+0x4b3/0xec0 net/openvswitch/datapath.c:1711
 genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:739
 genl_family_rcv_msg net/netlink/genetlink.c:783 [inline]
 genl_rcv_msg+0x328/0x580 net/netlink/genetlink.c:800
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:811
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
 sock_sendmsg_nosec net/socket.c:703 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:723
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2392
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2446
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2475
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4665f9
RSP: 002b:00007f5d23461188 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 000000000056bf80 RCX: 00000000004665f9
RDX: 000000000002b2a6 RSI: 0000000020000180 RDI: 0000000000000003
RBP: 00000000004bfcc4 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf80
R13: 00007ffd85f5e94f R14: 00007f5d23461300 R15: 0000000000022000
INFO: task syz-executor.2:28283 blocked for more than 144 seconds.
      Not tainted 5.14.0-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.2  state:D stack:27160 pid:28283 ppid: 27349 flags:0x00004004
Call Trace:
 context_switch kernel/sched/core.c:4695 [inline]
 __schedule+0x93a/0x26f0 kernel/sched/core.c:6026
 schedule+0xd3/0x270 kernel/sched/core.c:6105
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6164
 __mutex_lock_common kernel/locking/mutex.c:1036 [inline]
 __mutex_lock+0x7b6/0x10a0 kernel/locking/mutex.c:1104
 ovs_lock net/openvswitch/datapath.c:106 [inline]
 ovs_dp_cmd_new+0x4b3/0xec0 net/openvswitch/datapath.c:1711
 genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:739
 genl_family_rcv_msg net/netlink/genetlink.c:783 [inline]
 genl_rcv_msg+0x328/0x580 net/netlink/genetlink.c:800
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:811
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
 sock_sendmsg_nosec net/socket.c:703 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:723
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2392
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2446
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2475
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4665f9
RSP: 002b:00007f242eb75188 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 000000000056bf80 RCX: 00000000004665f9
RDX: 0000000000000000 RSI: 0000000020000180 RDI: 0000000000000003
RBP: 00000000004bfcc4 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf80
R13: 00007ffce17ce3ef R14: 00007f242eb75300 R15: 0000000000022000
INFO: task syz-executor.2:28287 blocked for more than 144 seconds.
      Not tainted 5.14.0-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.2  state:D stack:27272 pid:28287 ppid: 27349 flags:0x00004004
Call Trace:
 context_switch kernel/sched/core.c:4695 [inline]
 __schedule+0x93a/0x26f0 kernel/sched/core.c:6026
 schedule+0xd3/0x270 kernel/sched/core.c:6105
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6164
 __mutex_lock_common kernel/locking/mutex.c:1036 [inline]
 __mutex_lock+0x7b6/0x10a0 kernel/locking/mutex.c:1104
 ovs_lock net/openvswitch/datapath.c:106 [inline]
 ovs_dp_cmd_new+0x4b3/0xec0 net/openvswitch/datapath.c:1711
 genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:739
 genl_family_rcv_msg net/netlink/genetlink.c:783 [inline]
 genl_rcv_msg+0x328/0x580 net/netlink/genetlink.c:800
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:811
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
 sock_sendmsg_nosec net/socket.c:703 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:723
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2392
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2446
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2475
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4665f9
RSP: 002b:00007f242eb54188 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 000000000056c038 RCX: 00000000004665f9
RDX: 0000000000000000 RSI: 0000000020000180 RDI: 0000000000000003
RBP: 00000000004bfcc4 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056c038
R13: 00007ffce17ce3ef R14: 00007f242eb54300 R15: 0000000000022000
INFO: task syz-executor.3:28285 blocked for more than 145 seconds.
      Not tainted 5.14.0-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.3  state:D stack:27160 pid:28285 ppid: 27323 flags:0x00004004
Call Trace:
 context_switch kernel/sched/core.c:4695 [inline]
 __schedule+0x93a/0x26f0 kernel/sched/core.c:6026
 schedule+0xd3/0x270 kernel/sched/core.c:6105
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6164
 __mutex_lock_common kernel/locking/mutex.c:1036 [inline]
 __mutex_lock+0x7b6/0x10a0 kernel/locking/mutex.c:1104
 ovs_lock net/openvswitch/datapath.c:106 [inline]
 ovs_dp_cmd_new+0x4b3/0xec0 net/openvswitch/datapath.c:1711
 genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:739
 genl_family_rcv_msg net/netlink/genetlink.c:783 [inline]
 genl_rcv_msg+0x328/0x580 net/netlink/genetlink.c:800
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:811
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
 sock_sendmsg_nosec net/socket.c:703 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:723
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2392
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2446
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2475
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4665f9
RSP: 002b:00007f4edb7df188 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 000000000056bf80 RCX: 00000000004665f9
RDX: 0000000000000000 RSI: 0000000020000180 RDI: 0000000000000003
RBP: 00000000004bfcc4 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf80
R13: 00007fffbecac43f R14: 00007f4edb7df300 R15: 0000000000022000
INFO: task syz-executor.3:28288 blocked for more than 145 seconds.
      Not tainted 5.14.0-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.3  state:D stack:27352 pid:28288 ppid: 27323 flags:0x00004004
Call Trace:
 context_switch kernel/sched/core.c:4695 [inline]
 __schedule+0x93a/0x26f0 kernel/sched/core.c:6026
 schedule+0xd3/0x270 kernel/sched/core.c:6105
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6164
 __mutex_lock_common kernel/locking/mutex.c:1036 [inline]
 __mutex_lock+0x7b6/0x10a0 kernel/locking/mutex.c:1104
 ovs_lock net/openvswitch/datapath.c:106 [inline]
 ovs_dp_cmd_new+0x4b3/0xec0 net/openvswitch/datapath.c:1711
 genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:739
 genl_family_rcv_msg net/netlink/genetlink.c:783 [inline]
 genl_rcv_msg+0x328/0x580 net/netlink/genetlink.c:800
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:811
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
 sock_sendmsg_nosec net/socket.c:703 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:723
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2392
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2446
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2475
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4665f9
RSP: 002b:00007f4edb7be188 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 000000000056c038 RCX: 00000000004665f9
RDX: 0000000000000000 RSI: 0000000020000180 RDI: 0000000000000003
RBP: 00000000004bfcc4 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056c038
R13: 00007fffbecac43f R14: 00007f4edb7be300 R15: 0000000000022000

Showing all locks held in the system:
3 locks held by kworker/0:1/7:
 #0: ffff888010867d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888010867d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:620 [inline]
 #0: ffff888010867d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888010867d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:617 [inline]
 #0: ffff888010867d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:644 [inline]
 #0: ffff888010867d38 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x871/0x1630 kernel/workqueue.c:2247
 #1: ffffc90000edfdb0 ((work_completion)(&(&ovs_net->masks_rebalance)->work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1630 kernel/workqueue.c:2251
 #2: ffffffff8d521268 (ovs_mutex){+.+.}-{3:3}, at: ovs_lock net/openvswitch/datapath.c:106 [inline]
 #2: ffffffff8d521268 (ovs_mutex){+.+.}-{3:3}, at: ovs_dp_masks_rebalance+0x20/0xf0 net/openvswitch/datapath.c:2386
2 locks held by kworker/u4:4/273:
1 lock held by khungtaskd/1643:
 #0: ffffffff8b979840 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:6446
2 locks held by in:imklog/8141:
2 locks held by agetty/8376:
 #0: ffff8880191be098 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x22/0x80 drivers/tty/tty_ldisc.c:252
 #1: ffffc900011f02e8 (&ldata->atomic_read_lock){+.+.}-{3:3}, at: n_tty_read+0xcf0/0x1230 drivers/tty/n_tty.c:2113
3 locks held by kworker/1:4/20830:
 #0: ffff888010867d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888010867d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:620 [inline]
 #0: ffff888010867d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888010867d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:617 [inline]
 #0: ffff888010867d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:644 [inline]
 #0: ffff888010867d38 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x871/0x1630 kernel/workqueue.c:2247
 #1: ffffc90001ef7db0 ((work_completion)(&(&ovs_net->masks_rebalance)->work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1630 kernel/workqueue.c:2251
 #2: ffffffff8d521268 (ovs_mutex){+.+.}-{3:3}, at: ovs_lock net/openvswitch/datapath.c:106 [inline]
 #2: ffffffff8d521268 (ovs_mutex){+.+.}-{3:3}, at: ovs_dp_masks_rebalance+0x20/0xf0 net/openvswitch/datapath.c:2386
3 locks held by kworker/0:2/8001:
 #0: ffff888010867d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888010867d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:620 [inline]
 #0: ffff888010867d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888010867d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:617 [inline]
 #0: ffff888010867d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:644 [inline]
 #0: ffff888010867d38 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x871/0x1630 kernel/workqueue.c:2247
 #1: ffffc900096f7db0 ((work_completion)(&(&ovs_net->masks_rebalance)->work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1630 kernel/workqueue.c:2251
 #2: ffffffff8d521268 (ovs_mutex){+.+.}-{3:3}, at: ovs_lock net/openvswitch/datapath.c:106 [inline]
 #2: ffffffff8d521268 (ovs_mutex){+.+.}-{3:3}, at: ovs_dp_masks_rebalance+0x20/0xf0 net/openvswitch/datapath.c:2386
3 locks held by kworker/1:0/13766:
 #0: ffff888010867d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888010867d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:620 [inline]
 #0: ffff888010867d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888010867d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:617 [inline]
 #0: ffff888010867d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:644 [inline]
 #0: ffff888010867d38 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x871/0x1630 kernel/workqueue.c:2247
 #1: ffffc90018e9fdb0 ((work_completion)(&(&ovs_net->masks_rebalance)->work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1630 kernel/workqueue.c:2251
 #2: ffffffff8d521268 (ovs_mutex){+.+.}-{3:3}, at: ovs_lock net/openvswitch/datapath.c:106 [inline]
 #2: ffffffff8d521268 (ovs_mutex){+.+.}-{3:3}, at: ovs_dp_masks_rebalance+0x20/0xf0 net/openvswitch/datapath.c:2386
5 locks held by kworker/u4:1/2483:
 #0: ffff888015bee138 ((wq_completion)netns){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888015bee138 ((wq_completion)netns){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:620 [inline]
 #0: ffff888015bee138 ((wq_completion)netns){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888015bee138 ((wq_completion)netns){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:617 [inline]
 #0: ffff888015bee138 ((wq_completion)netns){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:644 [inline]
 #0: ffff888015bee138 ((wq_completion)netns){+.+.}-{0:0}, at: process_one_work+0x871/0x1630 kernel/workqueue.c:2247
 #1: ffffc9000321fdb0 (net_cleanup_work){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1630 kernel/workqueue.c:2251
 #2: ffffffff8d0b8390 (pernet_ops_rwsem){++++}-{3:3}, at: cleanup_net+0x9b/0xb10 net/core/net_namespace.c:557
 #3: ffffffff8d521268 (ovs_mutex){+.+.}-{3:3}, at: ovs_lock net/openvswitch/datapath.c:106 [inline]
 #3: ffffffff8d521268 (ovs_mutex){+.+.}-{3:3}, at: ovs_exit_net+0x192/0xbc0 net/openvswitch/datapath.c:2534
 #4: ffffffff8b982bb0 (rcu_state.barrier_mutex){+.+.}-{3:3}, at: rcu_barrier+0x44/0x440 kernel/rcu/tree.c:4029
3 locks held by kworker/1:1/9214:
 #0: ffff888010867d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888010867d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:620 [inline]
 #0: ffff888010867d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888010867d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:617 [inline]
 #0: ffff888010867d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:644 [inline]
 #0: ffff888010867d38 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x871/0x1630 kernel/workqueue.c:2247
 #1: ffffc90006777db0 ((work_completion)(&(&ovs_net->masks_rebalance)->work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1630 kernel/workqueue.c:2251
 #2: ffffffff8d521268 (ovs_mutex){+.+.}-{3:3}, at: ovs_lock net/openvswitch/datapath.c:106 [inline]
 #2: ffffffff8d521268 (ovs_mutex){+.+.}-{3:3}, at: ovs_dp_masks_rebalance+0x20/0xf0 net/openvswitch/datapath.c:2386
3 locks held by kworker/0:0/11087:
 #0: ffff888010867d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888010867d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:620 [inline]
 #0: ffff888010867d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888010867d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:617 [inline]
 #0: ffff888010867d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:644 [inline]
 #0: ffff888010867d38 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x871/0x1630 kernel/workqueue.c:2247
 #1: ffffc9000a597db0 ((work_completion)(&(&ovs_net->masks_rebalance)->work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1630 kernel/workqueue.c:2251
 #2: ffffffff8d521268 (ovs_mutex){+.+.}-{3:3}, at: ovs_lock net/openvswitch/datapath.c:106 [inline]
 #2: ffffffff8d521268 (ovs_mutex){+.+.}-{3:3}, at: ovs_dp_masks_rebalance+0x20/0xf0 net/openvswitch/datapath.c:2386
3 locks held by kworker/0:4/26828:
 #0: ffff888010867d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888010867d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:620 [inline]
 #0: ffff888010867d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888010867d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:617 [inline]
 #0: ffff888010867d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:644 [inline]
 #0: ffff888010867d38 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x871/0x1630 kernel/workqueue.c:2247
 #1: ffffc90001a67db0 ((work_completion)(&(&ovs_net->masks_rebalance)->work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1630 kernel/workqueue.c:2251
 #2: ffffffff8d521268 (ovs_mutex){+.+.}-{3:3}, at: ovs_lock net/openvswitch/datapath.c:106 [inline]
 #2: ffffffff8d521268 (ovs_mutex){+.+.}-{3:3}, at: ovs_dp_masks_rebalance+0x20/0xf0 net/openvswitch/datapath.c:2386
3 locks held by kworker/1:7/27170:
 #0: ffff888010867d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888010867d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:620 [inline]
 #0: ffff888010867d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888010867d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:617 [inline]
 #0: ffff888010867d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:644 [inline]
 #0: ffff888010867d38 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x871/0x1630 kernel/workqueue.c:2247
 #1: ffffc90002897db0 ((work_completion)(&(&ovs_net->masks_rebalance)->work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1630 kernel/workqueue.c:2251
 #2: ffffffff8d521268 (ovs_mutex){+.+.}-{3:3}, at: ovs_lock net/openvswitch/datapath.c:106 [inline]
 #2: ffffffff8d521268 (ovs_mutex){+.+.}-{3:3}, at: ovs_dp_masks_rebalance+0x20/0xf0 net/openvswitch/datapath.c:2386
3 locks held by kworker/0:6/27171:
 #0: ffff888010867d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888010867d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:620 [inline]
 #0: ffff888010867d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888010867d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:617 [inline]
 #0: ffff888010867d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:644 [inline]
 #0: ffff888010867d38 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x871/0x1630 kernel/workqueue.c:2247
 #1: ffffc900028a7db0 ((work_completion)(&(&ovs_net->masks_rebalance)->work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1630 kernel/workqueue.c:2251
 #2: ffffffff8d521268 (ovs_mutex){+.+.}-{3:3}, at: ovs_lock net/openvswitch/datapath.c:106 [inline]
 #2: ffffffff8d521268 (ovs_mutex){+.+.}-{3:3}, at: ovs_dp_masks_rebalance+0x20/0xf0 net/openvswitch/datapath.c:2386
3 locks held by kworker/0:10/27216:
 #0: ffff888010867d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888010867d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:620 [inline]
 #0: ffff888010867d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888010867d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:617 [inline]
 #0: ffff888010867d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:644 [inline]
 #0: ffff888010867d38 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x871/0x1630 kernel/workqueue.c:2247
 #1: ffffc90001907db0 ((work_completion)(&(&ovs_net->masks_rebalance)->work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1630 kernel/workqueue.c:2251
 #2: ffffffff8d521268 (ovs_mutex){+.+.}-{3:3}, at: ovs_lock net/openvswitch/datapath.c:106 [inline]
 #2: ffffffff8d521268 (ovs_mutex){+.+.}-{3:3}, at: ovs_dp_masks_rebalance+0x20/0xf0 net/openvswitch/datapath.c:2386
2 locks held by syz-executor.0/28248:
 #0: ffffffff8d15ddd0 (cb_lock){++++}-{3:3}, at: genl_rcv+0x15/0x40 net/netlink/genetlink.c:810
 #1: ffffffff8d521268 (ovs_mutex){+.+.}-{3:3}, at: ovs_lock net/openvswitch/datapath.c:106 [inline]
 #1: ffffffff8d521268 (ovs_mutex){+.+.}-{3:3}, at: ovs_dp_cmd_new+0x4b3/0xec0 net/openvswitch/datapath.c:1711
2 locks held by syz-executor.2/28283:
 #0: ffffffff8d15ddd0 (cb_lock){++++}-{3:3}, at: genl_rcv+0x15/0x40 net/netlink/genetlink.c:810
 #1: ffffffff8d521268 (ovs_mutex){+.+.}-{3:3}, at: ovs_lock net/openvswitch/datapath.c:106 [inline]
 #1: ffffffff8d521268 (ovs_mutex){+.+.}-{3:3}, at: ovs_dp_cmd_new+0x4b3/0xec0 net/openvswitch/datapath.c:1711
2 locks held by syz-executor.2/28287:
 #0: ffffffff8d15ddd0 (cb_lock){++++}-{3:3}, at: genl_rcv+0x15/0x40 net/netlink/genetlink.c:810
 #1: ffffffff8d521268 (ovs_mutex){+.+.}-{3:3}, at: ovs_lock net/openvswitch/datapath.c:106 [inline]
 #1: ffffffff8d521268 (ovs_mutex){+.+.}-{3:3}, at: ovs_dp_cmd_new+0x4b3/0xec0 net/openvswitch/datapath.c:1711
2 locks held by syz-executor.3/28285:
 #0: ffffffff8d15ddd0 (cb_lock){++++}-{3:3}, at: genl_rcv+0x15/0x40 net/netlink/genetlink.c:810
 #1: ffffffff8d521268 (ovs_mutex){+.+.}-{3:3}, at: ovs_lock net/openvswitch/datapath.c:106 [inline]
 #1: ffffffff8d521268 (ovs_mutex){+.+.}-{3:3}, at: ovs_dp_cmd_new+0x4b3/0xec0 net/openvswitch/datapath.c:1711
2 locks held by syz-executor.3/28288:
 #0: ffffffff8d15ddd0 (cb_lock){++++}-{3:3}, at: genl_rcv+0x15/0x40 net/netlink/genetlink.c:810
 #1: ffffffff8d521268 (ovs_mutex){+.+.}-{3:3}, at: ovs_lock net/openvswitch/datapath.c:106 [inline]
 #1: ffffffff8d521268 (ovs_mutex){+.+.}-{3:3}, at: ovs_dp_cmd_new+0x4b3/0xec0 net/openvswitch/datapath.c:1711

=============================================

NMI backtrace for cpu 0
CPU: 0 PID: 1643 Comm: khungtaskd Not tainted 5.14.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:105
 nmi_cpu_backtrace.cold+0x44/0xd7 lib/nmi_backtrace.c:105
 nmi_trigger_cpumask_backtrace+0x1b3/0x230 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:210 [inline]
 watchdog+0xd0a/0xfc0 kernel/hung_task.c:295
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 PID: 10393 Comm: kworker/u4:7 Not tainted 5.14.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: bat_events batadv_nc_worker
RIP: 0010:__kasan_check_read+0x4/0x10 mm/kasan/shadow.c:31
Code: 2e 07 48 85 db 0f 85 e5 a4 2f 07 48 83 c4 60 5b 5d 41 5c 41 5d c3 c3 e9 e5 a5 2f 07 cc cc cc cc cc cc cc cc cc cc 48 8b 0c 24 <89> f6 31 d2 e9 43 f9 ff ff 0f 1f 00 48 8b 0c 24 89 f6 ba 01 00 00
RSP: 0018:ffffc90005e9fbc8 EFLAGS: 00000246
RAX: 0000000000000000 RBX: 0000000000000001 RCX: ffffffff815a5631
RDX: ffff8880854c0300 RSI: 0000000000000008 RDI: ffffffff8d6c5150
RBP: 1ffff92000bd3f7c R08: 0000000000000000 R09: 0000000000000001
R10: ffffffff88c8c707 R11: 0000000000000000 R12: ffffffff8b979840
R13: 0000000000000000 R14: dffffc0000000000 R15: 000000000000012e
FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f534402da20 CR3: 0000000018c8b000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 instrument_atomic_read include/linux/instrumented.h:71 [inline]
 test_bit include/asm-generic/bitops/instrumented-non-atomic.h:134 [inline]
 cpumask_test_cpu include/linux/cpumask.h:344 [inline]
 cpu_online include/linux/cpumask.h:895 [inline]
 trace_lock_release include/trace/events/lock.h:58 [inline]
 lock_release+0xa1/0x720 kernel/locking/lockdep.c:5636
 rcu_lock_release include/linux/rcupdate.h:272 [inline]
 rcu_read_unlock include/linux/rcupdate.h:720 [inline]
 batadv_nc_purge_orig_hash net/batman-adv/network-coding.c:408 [inline]
 batadv_nc_worker+0x771/0xe50 net/batman-adv/network-coding.c:715
 process_one_work+0x98d/0x1630 kernel/workqueue.c:2276
 worker_thread+0x658/0x11f0 kernel/workqueue.c:2422
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
----------------
Code disassembly (best guess):
   0:	2e 07                	cs (bad)
   2:	48 85 db             	test   %rbx,%rbx
   5:	0f 85 e5 a4 2f 07    	jne    0x72fa4f0
   b:	48 83 c4 60          	add    $0x60,%rsp
   f:	5b                   	pop    %rbx
  10:	5d                   	pop    %rbp
  11:	41 5c                	pop    %r12
  13:	41 5d                	pop    %r13
  15:	c3                   	retq
  16:	c3                   	retq
  17:	e9 e5 a5 2f 07       	jmpq   0x72fa601
  1c:	cc                   	int3
  1d:	cc                   	int3
  1e:	cc                   	int3
  1f:	cc                   	int3
  20:	cc                   	int3
  21:	cc                   	int3
  22:	cc                   	int3
  23:	cc                   	int3
  24:	cc                   	int3
  25:	cc                   	int3
  26:	48 8b 0c 24          	mov    (%rsp),%rcx
* 2a:	89 f6                	mov    %esi,%esi <-- trapping instruction
  2c:	31 d2                	xor    %edx,%edx
  2e:	e9 43 f9 ff ff       	jmpq   0xfffff976
  33:	0f 1f 00             	nopl   (%rax)
  36:	48 8b 0c 24          	mov    (%rsp),%rcx
  3a:	89 f6                	mov    %esi,%esi
  3c:	ba                   	.byte 0xba
  3d:	01 00                	add    %eax,(%rax)


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
