Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD91E22D506
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 06:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726726AbgGYE4Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jul 2020 00:56:24 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:51946 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbgGYE4Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jul 2020 00:56:24 -0400
Received: by mail-il1-f198.google.com with SMTP id s137so7060746ilc.18
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 21:56:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=9KVRjLors2ySg6gcXfpxGGvjcoTKeKoUGNiHR7H9iHY=;
        b=RRrONn7UxU1gjs0dhQd1GjoR92W9cZcB98U8NpiijWNPEmLH0YDb5mLFGXqi6Sfk68
         8Gc67igsPB34w/SVqzXmRKFQGQ8k4Yes3g7M70GNYkI1W/Tx+WNBPcYHegzyBFQjfc5V
         Il9SHCL6MOt3Kt4zcPNCQE22XKBon5lIYE6v2n8zxEX43oJX3tn6acmc5sf2UxErgemX
         aze8IlEAqlxlQ9mJUVs3sEyfcmSbT1n7u/pz1H5M5QTTCQ2Ki5oYNruSO1Zb/VnFx9Dh
         ETQ8jBn4FZzdqt2cts9w9ATI4+AzjUxYuIIHOTBNZomU281hRMlRTHikzOQt656gr9TT
         Wd+w==
X-Gm-Message-State: AOAM533GyNusEtqr+M48st82Oi3XpSyqCUXgeV0hhSRNZlLm/gKF4gWZ
        +NF+2ID+nzr04CTkLNK9CybvGJyOsWkse9jCg5ZFAbiyyXEG
X-Google-Smtp-Source: ABdhPJxM1LX644khymLTDZEWkSq4NIeCbrDZKJAwEVMsgj8wgiLpyCigw/oZYwU/L2EoYzKGFjPobuvmEmqlaJoN3yUOFyaIC2N+
MIME-Version: 1.0
X-Received: by 2002:a6b:ee15:: with SMTP id i21mr13788075ioh.25.1595652982273;
 Fri, 24 Jul 2020 21:56:22 -0700 (PDT)
Date:   Fri, 24 Jul 2020 21:56:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000317f1805ab3ce936@google.com>
Subject: INFO: task hung in ovs_dp_cmd_del
From:   syzbot <syzbot+1d3e60b5f711ff9872f4@syzkaller.appspotmail.com>
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

HEAD commit:    e0145983 Merge branch 'fix-bpf_get_stack-with-PEBS'
git tree:       bpf-next
console output: https://syzkaller.appspot.com/x/log.txt?x=16ce401f100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2b7b67c0c1819c87
dashboard link: https://syzkaller.appspot.com/bug?extid=1d3e60b5f711ff9872f4
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+1d3e60b5f711ff9872f4@syzkaller.appspotmail.com

INFO: task syz-executor.1:18190 blocked for more than 143 seconds.
      Not tainted 5.8.0-rc4-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor.1  D28320 18190   6934 0x00004004
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
 netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2470
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:742
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:671
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2363
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2417
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2450
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45c1f9
Code: Bad RIP value.
RSP: 002b:00007f18d3135c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 000000000002b3c0 RCX: 000000000045c1f9
RDX: 0000000000000000 RSI: 00000000200000c0 RDI: 0000000000000003
RBP: 000000000078bfe0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000078bfac
R13: 00007ffef201616f R14: 00007f18d31369c0 R15: 000000000078bfac

Showing all locks held in the system:
3 locks held by kworker/1:1/27:
 #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x82b/0x1670 kernel/workqueue.c:2240
 #1: ffffc90000e17da8 ((work_completion)(&(&dp->masks_rebalance)->work)){+.+.}-{0:0}, at: process_one_work+0x85f/0x1670 kernel/workqueue.c:2244
 #2: ffffffff8aa5e968 (ovs_mutex){+.+.}-{3:3}, at: ovs_lock net/openvswitch/datapath.c:105 [inline]
 #2: ffffffff8aa5e968 (ovs_mutex){+.+.}-{3:3}, at: ovs_dp_masks_rebalance+0x18/0x80 net/openvswitch/datapath.c:2355
1 lock held by khungtaskd/1148:
 #0: ffffffff89bc0ec0 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:5779
3 locks held by kworker/0:11/2521:
 #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x82b/0x1670 kernel/workqueue.c:2240
 #1: ffffc90007b87da8 ((work_completion)(&(&dp->masks_rebalance)->work)){+.+.}-{0:0}, at: process_one_work+0x85f/0x1670 kernel/workqueue.c:2244
 #2: ffffffff8aa5e968 (ovs_mutex){+.+.}-{3:3}, at: ovs_lock net/openvswitch/datapath.c:105 [inline]
 #2: ffffffff8aa5e968 (ovs_mutex){+.+.}-{3:3}, at: ovs_dp_masks_rebalance+0x18/0x80 net/openvswitch/datapath.c:2355
3 locks held by kworker/1:4/2580:
 #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x82b/0x1670 kernel/workqueue.c:2240
 #1: ffffc90007d17da8 ((work_completion)(&(&dp->masks_rebalance)->work)){+.+.}-{0:0}, at: process_one_work+0x85f/0x1670 kernel/workqueue.c:2244
 #2: ffffffff8aa5e968 (ovs_mutex){+.+.}-{3:3}, at: ovs_lock net/openvswitch/datapath.c:105 [inline]
 #2: ffffffff8aa5e968 (ovs_mutex){+.+.}-{3:3}, at: ovs_dp_masks_rebalance+0x18/0x80 net/openvswitch/datapath.c:2355
3 locks held by kworker/1:8/2760:
 #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x82b/0x1670 kernel/workqueue.c:2240
 #1: ffffc90008447da8 ((work_completion)(&(&dp->masks_rebalance)->work)){+.+.}-{0:0}, at: process_one_work+0x85f/0x1670 kernel/workqueue.c:2244
 #2: ffffffff8aa5e968 (ovs_mutex){+.+.}-{3:3}, at: ovs_lock net/openvswitch/datapath.c:105 [inline]
 #2: ffffffff8aa5e968 (ovs_mutex){+.+.}-{3:3}, at: ovs_dp_masks_rebalance+0x18/0x80 net/openvswitch/datapath.c:2355
3 locks held by kworker/1:10/2763:
 #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x82b/0x1670 kernel/workqueue.c:2240
 #1: ffffc90008457da8 ((work_completion)(&(&dp->masks_rebalance)->work)){+.+.}-{0:0}, at: process_one_work+0x85f/0x1670 kernel/workqueue.c:2244
 #2: ffffffff8aa5e968 (ovs_mutex){+.+.}-{3:3}, at: ovs_lock net/openvswitch/datapath.c:105 [inline]
 #2: ffffffff8aa5e968 (ovs_mutex){+.+.}-{3:3}, at: ovs_dp_masks_rebalance+0x18/0x80 net/openvswitch/datapath.c:2355
1 lock held by in:imklog/6484:
 #0: ffff88809a6b96b0 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xe9/0x100 fs/file.c:826
8 locks held by kworker/u4:5/6544:
2 locks held by syz-executor.1/18189:
 #0: ffffffff8a818590 (cb_lock){++++}-{3:3}, at: genl_rcv+0x15/0x40 net/netlink/genetlink.c:741
 #1: ffffffff8aa5e968 (ovs_mutex){+.+.}-{3:3}, at: ovs_lock net/openvswitch/datapath.c:105 [inline]
 #1: ffffffff8aa5e968 (ovs_mutex){+.+.}-{3:3}, at: ovs_dp_cmd_del+0x4a/0x270 net/openvswitch/datapath.c:1780
2 locks held by syz-executor.1/18190:
 #0: ffffffff8a818590 (cb_lock){++++}-{3:3}, at: genl_rcv+0x15/0x40 net/netlink/genetlink.c:741
 #1: ffffffff8aa5e968 (ovs_mutex){+.+.}-{3:3}, at: ovs_lock net/openvswitch/datapath.c:105 [inline]
 #1: ffffffff8aa5e968 (ovs_mutex){+.+.}-{3:3}, at: ovs_dp_cmd_del+0x4a/0x270 net/openvswitch/datapath.c:1780
3 locks held by kworker/1:0/18221:
 #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x82b/0x1670 kernel/workqueue.c:2240
 #1: ffffc90002407da8 ((work_completion)(&(&dp->masks_rebalance)->work)){+.+.}-{0:0}, at: process_one_work+0x85f/0x1670 kernel/workqueue.c:2244
 #2: ffffffff8aa5e968 (ovs_mutex){+.+.}-{3:3}, at: ovs_lock net/openvswitch/datapath.c:105 [inline]
 #2: ffffffff8aa5e968 (ovs_mutex){+.+.}-{3:3}, at: ovs_dp_masks_rebalance+0x18/0x80 net/openvswitch/datapath.c:2355

=============================================

NMI backtrace for cpu 1
CPU: 1 PID: 1148 Comm: khungtaskd Not tainted 5.8.0-rc4-syzkaller #0
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
CPU: 0 PID: 3877 Comm: systemd-journal Not tainted 5.8.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:0xffffffffa0008180
Code: cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc <0f> 1f 44 00 00 55 48 89 e5 48 81 ec 00 00 00 00 53 41 55 41 56 41
RSP: 0018:ffffc90001077d40 EFLAGS: 00010246
RAX: 1ffff920001acc06 RBX: ffff888096d96300 RCX: dffffc0000000000
RDX: ffff888094558380 RSI: ffffc90000d66038 RDI: ffffc90001077ed0
RBP: ffffc90000d66000 R08: 0000000000000000 R09: 0000000000000000
R10: 000000007fff0000 R11: 0000000000000000 R12: dffffc0000000000
R13: 000000007fff0000 R14: 000000007fff0000 R15: ffffc90001077ed0
FS:  00007fcf9c3b78c0(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000c0000b7000 CR3: 00000000945b0000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
Call Trace:


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
