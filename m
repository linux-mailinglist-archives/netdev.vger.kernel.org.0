Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 044AC22AAAA
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 10:32:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbgGWIcA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 04:32:00 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:24174 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725911AbgGWIcA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 04:32:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595493119;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GVpn7NmBtgGEUYuiTiV3gDEtD8NB5vaGRoeyaR+b6bQ=;
        b=iL/9+YlxB/87eDWu4xOC0W+pFEmioNOmf3KjtVQYbyVIpBShEGpiLR8z59gY7IyqMvRXso
        wxRkS/pb7csR1xhLcFbRjmbUl5N8UE9gVwjOVBNzZ+ycR8NW9zgeZV17BwmMvODJkakxfp
        FqE5u82LBTKkLN5lRfRBW9qZPCnFbxg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-150-vwjdJ4WENV2NwOl-YffekA-1; Thu, 23 Jul 2020 04:31:50 -0400
X-MC-Unique: vwjdJ4WENV2NwOl-YffekA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1FF8C57;
        Thu, 23 Jul 2020 08:31:49 +0000 (UTC)
Received: from [10.36.112.205] (ovpn-112-205.ams2.redhat.com [10.36.112.205])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 81A135D9E8;
        Thu, 23 Jul 2020 08:31:47 +0000 (UTC)
From:   "Eelco Chaudron" <echaudro@redhat.com>
To:     syzbot <syzbot+2c4ff3614695f75ce26c@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, dev@openvswitch.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pshelar@ovn.org, syzkaller-bugs@googlegroups.com
Subject: Re: [ovs-dev] INFO: task hung in ovs_exit_net
Date:   Thu, 23 Jul 2020 10:31:45 +0200
Message-ID: <0AE1A2C4-8055-4439-97CF-3C88E65DAEB3@redhat.com>
In-Reply-To: <000000000000c4a77205ab15f238@google.com>
References: <000000000000c4a77205ab15f238@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Looks like the same problem as “[ovs-dev] INFO: task hung in 
ovs_dp_masks_rebalance”.

//Eelco


On 23 Jul 2020, at 8:27, syzbot wrote:

> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    a6c0d093 net: explicitly include <linux/compat.h> in 
> net/c..
> git tree:       net-next
> console output: 
> https://syzkaller.appspot.com/x/log.txt?x=179ee640900000
> kernel config:  
> https://syzkaller.appspot.com/x/.config?x=2b7b67c0c1819c87
> dashboard link: 
> https://syzkaller.appspot.com/bug?extid=2c4ff3614695f75ce26c
> compiler:       gcc (GCC) 10.1.0-syz 20200507
>
> Unfortunately, I don't have any reproducer for this issue yet.
>
> IMPORTANT: if you fix the issue, please add the following tag to the 
> commit:
> Reported-by: syzbot+2c4ff3614695f75ce26c@syzkaller.appspotmail.com
>
> INFO: task kworker/u4:3:235 blocked for more than 143 seconds.
>       Not tainted 5.8.0-rc4-syzkaller #0
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this 
> message.
> kworker/u4:3    D24856   235      2 0x00004000
> Workqueue: netns cleanup_net
> Call Trace:
>  context_switch kernel/sched/core.c:3453 [inline]
>  __schedule+0x8e1/0x1eb0 kernel/sched/core.c:4178
>  schedule+0xd0/0x2a0 kernel/sched/core.c:4253
>  schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:4312
>  __mutex_lock_common kernel/locking/mutex.c:1033 [inline]
>  __mutex_lock+0x3e2/0x10d0 kernel/locking/mutex.c:1103
>  ovs_lock net/openvswitch/datapath.c:105 [inline]
>  ovs_exit_net+0x1de/0xba0 net/openvswitch/datapath.c:2491
>  ops_exit_list+0xb0/0x160 net/core/net_namespace.c:186
>  cleanup_net+0x4ea/0xa00 net/core/net_namespace.c:603
>  process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
>  worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
>  kthread+0x3b5/0x4a0 kernel/kthread.c:291
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293
> INFO: task kworker/0:5:9052 blocked for more than 143 seconds.
>       Not tainted 5.8.0-rc4-syzkaller #0
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this 
> message.
> kworker/0:5     D27408  9052      2 0x00004000
> Workqueue: events ovs_dp_masks_rebalance
> Call Trace:
>  context_switch kernel/sched/core.c:3453 [inline]
>  __schedule+0x8e1/0x1eb0 kernel/sched/core.c:4178
>  schedule+0xd0/0x2a0 kernel/sched/core.c:4253
>  schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:4312
>  __mutex_lock_common kernel/locking/mutex.c:1033 [inline]
>  __mutex_lock+0x3e2/0x10d0 kernel/locking/mutex.c:1103
>  ovs_lock net/openvswitch/datapath.c:105 [inline]
>  ovs_dp_masks_rebalance+0x18/0x80 net/openvswitch/datapath.c:2355
>  process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
>  worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
>  kthread+0x3b5/0x4a0 kernel/kthread.c:291
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293
> INFO: task syz-executor.3:21286 blocked for more than 143 seconds.
>       Not tainted 5.8.0-rc4-syzkaller #0
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this 
> message.
> syz-executor.3  D26160 21286   7072 0x00004004
> Call Trace:
>  context_switch kernel/sched/core.c:3453 [inline]
>  __schedule+0x8e1/0x1eb0 kernel/sched/core.c:4178
>  schedule+0xd0/0x2a0 kernel/sched/core.c:4253
>  schedule_timeout+0x1d8/0x250 kernel/time/timer.c:1873
>  do_wait_for_common kernel/sched/completion.c:85 [inline]
>  __wait_for_common kernel/sched/completion.c:106 [inline]
>  wait_for_common kernel/sched/completion.c:117 [inline]
>  wait_for_completion+0x163/0x260 kernel/sched/completion.c:138
>  __flush_work+0x51f/0xab0 kernel/workqueue.c:3046
>  __cancel_work_timer+0x5de/0x700 kernel/workqueue.c:3133
>  ovs_dp_cmd_del+0x18c/0x270 net/openvswitch/datapath.c:1790
>  genl_family_rcv_msg_doit net/netlink/genetlink.c:669 [inline]
>  genl_family_rcv_msg net/netlink/genetlink.c:714 [inline]
>  genl_rcv_msg+0x61d/0x980 net/netlink/genetlink.c:731
>  netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2470
>  genl_rcv+0x24/0x40 net/netlink/genetlink.c:742
>  netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
>  netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
>  netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1919
>  sock_sendmsg_nosec net/socket.c:651 [inline]
>  sock_sendmsg+0xcf/0x120 net/socket.c:671
>  ____sys_sendmsg+0x6e8/0x810 net/socket.c:2363
>  ___sys_sendmsg+0xf3/0x170 net/socket.c:2417
>  __sys_sendmsg+0xe5/0x1b0 net/socket.c:2450
>  do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> RIP: 0033:0x45c1f9
> Code: Bad RIP value.
> RSP: 002b:00007f75a409cc78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 000000000002b3c0 RCX: 000000000045c1f9
> RDX: 0000000000000000 RSI: 00000000200000c0 RDI: 0000000000000004
> RBP: 000000000078bf40 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 000000000078bf0c
> R13: 00007ffed0e2724f R14: 00007f75a409d9c0 R15: 000000000078bf0c
> INFO: task syz-executor.3:21355 blocked for more than 144 seconds.
>       Not tainted 5.8.0-rc4-syzkaller #0
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this 
> message.
> syz-executor.3  D27400 21355   7072 0x00004004
> Call Trace:
>  context_switch kernel/sched/core.c:3453 [inline]
>  __schedule+0x8e1/0x1eb0 kernel/sched/core.c:4178
>  schedule+0xd0/0x2a0 kernel/sched/core.c:4253
>  schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:4312
>  __mutex_lock_common kernel/locking/mutex.c:1033 [inline]
>  __mutex_lock+0x3e2/0x10d0 kernel/locking/mutex.c:1103
>  ovs_lock net/openvswitch/datapath.c:105 [inline]
>  ovs_dp_cmd_del+0x4a/0x270 net/openvswitch/datapath.c:1780
>  genl_family_rcv_msg_doit net/netlink/genetlink.c:669 [inline]
>  genl_family_rcv_msg net/netlink/genetlink.c:714 [inline]
>  genl_rcv_msg+0x61d/0x980 net/netlink/genetlink.c:731
>  netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2470
>  genl_rcv+0x24/0x40 net/netlink/genetlink.c:742
>  netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
>  netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
>  netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1919
>  sock_sendmsg_nosec net/socket.c:651 [inline]
>  sock_sendmsg+0xcf/0x120 net/socket.c:671
>  ____sys_sendmsg+0x6e8/0x810 net/socket.c:2363
>  ___sys_sendmsg+0xf3/0x170 net/socket.c:2417
>  __sys_sendmsg+0xe5/0x1b0 net/socket.c:2450
>  do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> RIP: 0033:0x45c1f9
> Code: Bad RIP value.
> RSP: 002b:00007f75a405ac78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 000000000002b3c0 RCX: 000000000045c1f9
> RDX: 0000000000000000 RSI: 00000000200000c0 RDI: 0000000000000004
> RBP: 000000000078c080 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 000000000078c04c
> R13: 00007ffed0e2724f R14: 00007f75a405b9c0 R15: 000000000078c04c
>
> Showing all locks held in the system:
> 4 locks held by kworker/u4:3/235:
>  #0: ffff8880a97ad138 ((wq_completion)netns){+.+.}-{0:0}, at: 
> arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
>  #0: ffff8880a97ad138 ((wq_completion)netns){+.+.}-{0:0}, at: 
> atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
>  #0: ffff8880a97ad138 ((wq_completion)netns){+.+.}-{0:0}, at: 
> atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
>  #0: ffff8880a97ad138 ((wq_completion)netns){+.+.}-{0:0}, at: 
> set_work_data kernel/workqueue.c:616 [inline]
>  #0: ffff8880a97ad138 ((wq_completion)netns){+.+.}-{0:0}, at: 
> set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
>  #0: ffff8880a97ad138 ((wq_completion)netns){+.+.}-{0:0}, at: 
> process_one_work+0x82b/0x1670 kernel/workqueue.c:2240
>  #1: ffffc90001847da8 (net_cleanup_work){+.+.}-{0:0}, at: 
> process_one_work+0x85f/0x1670 kernel/workqueue.c:2244
>  #2: ffffffff8a7ad4b0 (pernet_ops_rwsem){++++}-{3:3}, at: 
> cleanup_net+0x9b/0xa00 net/core/net_namespace.c:565
>  #3: ffffffff8aa5dfe8 (ovs_mutex){+.+.}-{3:3}, at: ovs_lock 
> net/openvswitch/datapath.c:105 [inline]
>  #3: ffffffff8aa5dfe8 (ovs_mutex){+.+.}-{3:3}, at: 
> ovs_exit_net+0x1de/0xba0 net/openvswitch/datapath.c:2491
> 1 lock held by khungtaskd/1150:
>  #0: ffffffff89bc0ec0 (rcu_read_lock){....}-{1:2}, at: 
> debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:5779
> 1 lock held by in:imklog/6505:
> 3 locks held by kworker/0:5/9052:
>  #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: 
> arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
>  #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: 
> atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
>  #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: 
> atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
>  #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: 
> set_work_data kernel/workqueue.c:616 [inline]
>  #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: 
> set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
>  #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: 
> process_one_work+0x82b/0x1670 kernel/workqueue.c:2240
>  #1: ffffc90001b17da8 
> ((work_completion)(&(&dp->masks_rebalance)->work)){+.+.}-{0:0}, at: 
> process_one_work+0x85f/0x1670 kernel/workqueue.c:2244
>  #2: ffffffff8aa5dfe8 (ovs_mutex){+.+.}-{3:3}, at: ovs_lock 
> net/openvswitch/datapath.c:105 [inline]
>  #2: ffffffff8aa5dfe8 (ovs_mutex){+.+.}-{3:3}, at: 
> ovs_dp_masks_rebalance+0x18/0x80 net/openvswitch/datapath.c:2355
> 2 locks held by syz-executor.3/21286:
>  #0: ffffffff8a817cf0 (cb_lock){++++}-{3:3}, at: genl_rcv+0x15/0x40 
> net/netlink/genetlink.c:741
>  #1: ffffffff8aa5dfe8 (ovs_mutex){+.+.}-{3:3}, at: ovs_lock 
> net/openvswitch/datapath.c:105 [inline]
>  #1: ffffffff8aa5dfe8 (ovs_mutex){+.+.}-{3:3}, at: 
> ovs_dp_cmd_del+0x4a/0x270 net/openvswitch/datapath.c:1780
> 2 locks held by syz-executor.3/21355:
>  #0: ffffffff8a817cf0 (cb_lock){++++}-{3:3}, at: genl_rcv+0x15/0x40 
> net/netlink/genetlink.c:741
>  #1: ffffffff8aa5dfe8 (ovs_mutex){+.+.}-{3:3}, at: ovs_lock 
> net/openvswitch/datapath.c:105 [inline]
>  #1: ffffffff8aa5dfe8 (ovs_mutex){+.+.}-{3:3}, at: 
> ovs_dp_cmd_del+0x4a/0x270 net/openvswitch/datapath.c:1780
>
> =============================================
>
> NMI backtrace for cpu 1
> CPU: 1 PID: 1150 Comm: khungtaskd Not tainted 5.8.0-rc4-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, 
> BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x18f/0x20d lib/dump_stack.c:118
>  nmi_cpu_backtrace.cold+0x70/0xb1 lib/nmi_backtrace.c:101
>  nmi_trigger_cpumask_backtrace+0x1b3/0x223 lib/nmi_backtrace.c:62
>  trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
>  check_hung_uninterruptible_tasks kernel/hung_task.c:209 [inline]
>  watchdog+0xd7d/0x1000 kernel/hung_task.c:295
>  kthread+0x3b5/0x4a0 kernel/kthread.c:291
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293
> Sending NMI from CPU 1 to CPUs 0:
> NMI backtrace for cpu 0 skipped: idling at native_safe_halt+0xe/0x10 
> arch/x86/include/asm/irqflags.h:60
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> _______________________________________________
> dev mailing list
> dev@openvswitch.org
> https://mail.openvswitch.org/mailman/listinfo/ovs-dev

