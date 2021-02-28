Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F111C326FDF
	for <lists+netdev@lfdr.de>; Sun, 28 Feb 2021 02:11:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbhB1BKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Feb 2021 20:10:00 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:42249 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbhB1BJ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Feb 2021 20:09:57 -0500
Received: by mail-io1-f71.google.com with SMTP id q5so10205597iot.9
        for <netdev@vger.kernel.org>; Sat, 27 Feb 2021 17:09:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=HkW3F1pgR4PjGUNwF4ddcyyGu+XajxAXN7obDkTjrD8=;
        b=e50M6nt01dN3xViaKFOoAZLpG9bI//OVUd6CoWbweh45m4zWgBR9Dbp+jmUwf6NSwz
         ZhLFZDgq3gA3q8Gr5W6157vnFXZAim15AGGvLT9AUcsHz+OgKDpFHzKEoZJjJg2Qtlg+
         i+4zRlBJYd1gP7ukPm+cgmCzDg6BVfrcAfM1nhaFp6J4Es3nEEG3iS2Tu7wHcpuH/Uvh
         DpcHl48rdzxkEZqWOP1hbkROQfsTh7xkpniXn/297L1brNXA8BIn6GEGOycJXr/sokTw
         p4uwJVdAz6DSNrD32xUCB5guwYMVbIv5H317FaKucTVh2UnpaK8Fs17n2xfjMv6GXrzi
         ZFQw==
X-Gm-Message-State: AOAM532W0M3bdAoPHXKE0m7v+QiJ1CW2Mb2MJT3v8cdgBhlRduw/X3Zh
        DyHjq7x3T+f3oeUeavQXq4+ciWGccjzQ1owGQ5csTnOqFFuI
X-Google-Smtp-Source: ABdhPJw2Iff1YwW+j4FKEwHzpOXuFzNVh1t43tQwIHolzEjlTtnpDJD95n2qWb9NmH1inqZQjmJYnvRDgqO+Rwec0Dh98GyvOeCb
MIME-Version: 1.0
X-Received: by 2002:a6b:6f14:: with SMTP id k20mr8625127ioc.52.1614474555710;
 Sat, 27 Feb 2021 17:09:15 -0800 (PST)
Date:   Sat, 27 Feb 2021 17:09:15 -0800
In-Reply-To: <000000000000fb47cc05ab6f4f39@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000064629205bc5b26c6@google.com>
Subject: Re: INFO: task hung in switchdev_deferred_process_work (2)
From:   syzbot <syzbot+8ecc009e206a956ab317@syzkaller.appspotmail.com>
To:     davem@davemloft.net, ivecera@redhat.com, jiri@resnulli.us,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    5695e516 Merge tag 'io_uring-worker.v3-2021-02-25' of git:..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=135da5cad00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8c76dad0946df1f3
dashboard link: https://syzkaller.appspot.com/bug?extid=8ecc009e206a956ab317
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15aaeff2d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16fbcb6cd00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8ecc009e206a956ab317@syzkaller.appspotmail.com

INFO: task kworker/1:0:8387 blocked for more than 143 seconds.
      Not tainted 5.11.0-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/1:0     state:D stack:25896 pid: 8387 ppid:     2 flags:0x00004000
Workqueue: events switchdev_deferred_process_work
Call Trace:
 context_switch kernel/sched/core.c:4324 [inline]
 __schedule+0x90c/0x21a0 kernel/sched/core.c:5075
 schedule+0xcf/0x270 kernel/sched/core.c:5154
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:5213
 __mutex_lock_common kernel/locking/mutex.c:1023 [inline]
 __mutex_lock+0x81f/0x1120 kernel/locking/mutex.c:1093
 switchdev_deferred_process_work+0xa/0x20 net/switchdev/switchdev.c:74
 process_one_work+0x98d/0x1600 kernel/workqueue.c:2275
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
INFO: task kworker/1:6:9697 blocked for more than 143 seconds.
      Not tainted 5.11.0-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/1:6     state:D stack:25688 pid: 9697 ppid:     2 flags:0x00004000
Workqueue: events rfkill_global_led_trigger_worker
Call Trace:
 context_switch kernel/sched/core.c:4324 [inline]
 __schedule+0x90c/0x21a0 kernel/sched/core.c:5075
 schedule+0xcf/0x270 kernel/sched/core.c:5154
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:5213
 __mutex_lock_common kernel/locking/mutex.c:1023 [inline]
 __mutex_lock+0x81f/0x1120 kernel/locking/mutex.c:1093
 rfkill_global_led_trigger_worker+0x17/0x110 net/rfkill/core.c:180
 process_one_work+0x98d/0x1600 kernel/workqueue.c:2275
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
INFO: task syz-executor417:12942 blocked for more than 143 seconds.
      Not tainted 5.11.0-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor417 state:D stack:23856 pid:12942 ppid: 12792 flags:0x00000000
Call Trace:
 context_switch kernel/sched/core.c:4324 [inline]
 __schedule+0x90c/0x21a0 kernel/sched/core.c:5075
 schedule+0xcf/0x270 kernel/sched/core.c:5154
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:5213
 __mutex_lock_common kernel/locking/mutex.c:1023 [inline]
 __mutex_lock+0x81f/0x1120 kernel/locking/mutex.c:1093
 rtnl_lock net/core/rtnetlink.c:72 [inline]
 rtnetlink_rcv_msg+0x3f9/0xad0 net/core/rtnetlink.c:5550
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2502
 netlink_unicast_kernel net/netlink/af_netlink.c:1312 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1338
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1927
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:674
 __sys_sendto+0x21c/0x320 net/socket.c:1977
 __do_sys_sendto net/socket.c:1989 [inline]
 __se_sys_sendto net/socket.c:1985 [inline]
 __x64_sys_sendto+0xdd/0x1b0 net/socket.c:1985
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x40c6dc
RSP: 002b:00000000005ffdf0 EFLAGS: 00000293 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 0000000000601080 RCX: 000000000040c6dc
RDX: 0000000000000020 RSI: 00000000006010d0 RDI: 0000000000000004
RBP: 0000000000000000 R08: 00000000005ffe44 R09: 000000000000000c
R10: 0000000000000000 R11: 0000000000000293 R12: 00000000005fff10
R13: 00000000006010d0 R14: 0000000000000004 R15: 0000000000000000
INFO: task kworker/0:28:21057 blocked for more than 144 seconds.
      Not tainted 5.11.0-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/0:28    state:D stack:27096 pid:21057 ppid:     2 flags:0x00004000
Workqueue: ipv6_addrconf addrconf_dad_work
Call Trace:
 context_switch kernel/sched/core.c:4324 [inline]
 __schedule+0x90c/0x21a0 kernel/sched/core.c:5075
 schedule+0xcf/0x270 kernel/sched/core.c:5154
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:5213
 __mutex_lock_common kernel/locking/mutex.c:1023 [inline]
 __mutex_lock+0x81f/0x1120 kernel/locking/mutex.c:1093
 addrconf_dad_work+0xa3/0x12b0 net/ipv6/addrconf.c:4031
 process_one_work+0x98d/0x1600 kernel/workqueue.c:2275
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
INFO: task kworker/1:14:21066 blocked for more than 144 seconds.
      Not tainted 5.11.0-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/1:14    state:D stack:27392 pid:21066 ppid:     2 flags:0x00004000
Workqueue: events linkwatch_event
Call Trace:
 context_switch kernel/sched/core.c:4324 [inline]
 __schedule+0x90c/0x21a0 kernel/sched/core.c:5075
 schedule+0xcf/0x270 kernel/sched/core.c:5154
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:5213
 __mutex_lock_common kernel/locking/mutex.c:1023 [inline]
 __mutex_lock+0x81f/0x1120 kernel/locking/mutex.c:1093
 linkwatch_event+0xb/0x60 net/core/link_watch.c:250
 process_one_work+0x98d/0x1600 kernel/workqueue.c:2275
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
INFO: task syz-executor417:21726 blocked for more than 144 seconds.
      Not tainted 5.11.0-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor417 state:D stack:28528 pid:21726 ppid:  8422 flags:0x00004004
Call Trace:
 context_switch kernel/sched/core.c:4324 [inline]
 __schedule+0x90c/0x21a0 kernel/sched/core.c:5075
 schedule+0xcf/0x270 kernel/sched/core.c:5154
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:5213
 __mutex_lock_common kernel/locking/mutex.c:1023 [inline]
 __mutex_lock+0x81f/0x1120 kernel/locking/mutex.c:1093
 cfg80211_rfkill_set_block net/wireless/core.c:304 [inline]
 cfg80211_rfkill_set_block+0x23/0x40 net/wireless/core.c:297
 rfkill_set_block+0x1f9/0x540 net/rfkill/core.c:343
 rfkill_fop_write+0x267/0x500 net/rfkill/core.c:1267
 vfs_write+0x28e/0xa30 fs/read_write.c:603
 ksys_write+0x1ee/0x250 fs/read_write.c:658
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x453a49
RSP: 002b:00007ff5d8620208 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00000000004f0028 RCX: 0000000000453a49
RDX: 0000000000000008 RSI: 0000000020000000 RDI: 0000000000000003
RBP: 00000000004f0020 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004f002c
R13: 00000000005ffbcf R14: 00007ff5d8620300 R15: 0000000000022000
INFO: task syz-executor417:21727 blocked for more than 144 seconds.
      Not tainted 5.11.0-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor417 state:D stack:28528 pid:21727 ppid:  8422 flags:0x00000004
Call Trace:
 context_switch kernel/sched/core.c:4324 [inline]
 __schedule+0x90c/0x21a0 kernel/sched/core.c:5075
 schedule+0xcf/0x270 kernel/sched/core.c:5154
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:5213
 __mutex_lock_common kernel/locking/mutex.c:1023 [inline]
 __mutex_lock+0x81f/0x1120 kernel/locking/mutex.c:1093
 rfkill_fop_open+0xfe/0x700 net/rfkill/core.c:1147
 misc_open+0x372/0x4a0 drivers/char/misc.c:141
 chrdev_open+0x266/0x770 fs/char_dev.c:414
 do_dentry_open+0x4b9/0x11b0 fs/open.c:826
 do_open fs/namei.c:3365 [inline]
 path_openat+0x1c0e/0x27e0 fs/namei.c:3498
 do_filp_open+0x17e/0x3c0 fs/namei.c:3525
 do_sys_openat2+0x16d/0x420 fs/open.c:1187
 do_sys_open fs/open.c:1203 [inline]
 __do_sys_openat fs/open.c:1219 [inline]
 __se_sys_openat fs/open.c:1214 [inline]
 __x64_sys_openat+0x13f/0x1f0 fs/open.c:1214
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x453a49
RSP: 002b:00007ff5d85ff208 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
RAX: ffffffffffffffda RBX: 00000000004f0038 RCX: 0000000000453a49
RDX: 0000000000000001 RSI: 0000000020000000 RDI: ffffffffffffff9c
RBP: 00000000004f0030 R08: 00007ff5d85ff700 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004f003c
R13: 00000000005ffbcf R14: 00007ff5d85ff300 R15: 0000000000022000

Showing all locks held in the system:
5 locks held by kworker/u4:5/826:
 #0: ffff888140753138 ((wq_completion)netns){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888140753138 ((wq_completion)netns){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff888140753138 ((wq_completion)netns){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888140753138 ((wq_completion)netns){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff888140753138 ((wq_completion)netns){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff888140753138 ((wq_completion)netns){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
 #1: ffffc900032dfda8 (net_cleanup_work){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
 #2: ffffffff8d669490 (pernet_ops_rwsem){++++}-{3:3}, at: cleanup_net+0x9b/0xb10 net/core/net_namespace.c:557
 #3: ffffffff8d67cbe8 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock_unregistering net/core/dev.c:11378 [inline]
 #3: ffffffff8d67cbe8 (rtnl_mutex){+.+.}-{3:3}, at: default_device_exit_batch+0xe8/0x3c0 net/core/dev.c:11416
 #4: ffffffff8bf7cd28 (rcu_state.exp_mutex){+.+.}-{3:3}, at: exp_funnel_lock kernel/rcu/tree_exp.h:290 [inline]
 #4: ffffffff8bf7cd28 (rcu_state.exp_mutex){+.+.}-{3:3}, at: synchronize_rcu_expedited+0x4fa/0x620 kernel/rcu/tree_exp.h:836
1 lock held by khungtaskd/1664:
 #0: ffffffff8bf74160 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:6327
1 lock held by in:imklog/8074:
 #0: ffff88801c2520f0 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xe9/0x100 fs/file.c:961
3 locks held by kworker/1:0/8387:
 #0: ffff888010864d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888010864d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff888010864d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888010864d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff888010864d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff888010864d38 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
 #1: ffffc9000172fda8 (deferred_process_work){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
 #2: ffffffff8d67cbe8 (rtnl_mutex){+.+.}-{3:3}, at: switchdev_deferred_process_work+0xa/0x20 net/switchdev/switchdev.c:74
3 locks held by kworker/1:6/9697:
 #0: ffff888010864d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888010864d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff888010864d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888010864d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff888010864d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff888010864d38 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
 #1: ffffc9000a9c7da8 ((work_completion)(&rfkill_global_led_trigger_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
 #2: ffffffff8da55548 (rfkill_global_mutex){+.+.}-{3:3}, at: rfkill_global_led_trigger_worker+0x17/0x110 net/rfkill/core.c:180
1 lock held by syz-executor417/12942:
 #0: ffffffff8d67cbe8 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:72 [inline]
 #0: ffffffff8d67cbe8 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x3f9/0xad0 net/core/rtnetlink.c:5550
2 locks held by kworker/u4:8/20993:
2 locks held by kworker/0:27/21056:
 #0: ffff888010866538 ((wq_completion)rcu_gp){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888010866538 ((wq_completion)rcu_gp){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff888010866538 ((wq_completion)rcu_gp){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888010866538 ((wq_completion)rcu_gp){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff888010866538 ((wq_completion)rcu_gp){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff888010866538 ((wq_completion)rcu_gp){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
 #1: ffffc9000b457da8 ((work_completion)(&rew.rew_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
3 locks held by kworker/0:28/21057:
 #0: ffff888021399d38 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888021399d38 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff888021399d38 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888021399d38 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff888021399d38 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff888021399d38 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
 #1: ffffc9000b467da8 ((work_completion)(&(&ifa->dad_work)->work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
 #2: ffffffff8d67cbe8 (rtnl_mutex){+.+.}-{3:3}, at: addrconf_dad_work+0xa3/0x12b0 net/ipv6/addrconf.c:4031
3 locks held by kworker/1:14/21066:
 #0: ffff888010864d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888010864d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff888010864d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888010864d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff888010864d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff888010864d38 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
 #1: ffffc9000b4f7da8 ((linkwatch_work).work){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
 #2: ffffffff8d67cbe8 (rtnl_mutex){+.+.}-{3:3}, at: linkwatch_event+0xb/0x60 net/core/link_watch.c:250
2 locks held by syz-executor417/21726:
 #0: ffffffff8da55548 (rfkill_global_mutex){+.+.}-{3:3}, at: rfkill_fop_write+0xff/0x500 net/rfkill/core.c:1259
 #1: ffffffff8d67cbe8 (rtnl_mutex){+.+.}-{3:3}, at: cfg80211_rfkill_set_block net/wireless/core.c:304 [inline]
 #1: ffffffff8d67cbe8 (rtnl_mutex){+.+.}-{3:3}, at: cfg80211_rfkill_set_block+0x23/0x40 net/wireless/core.c:297
2 locks held by syz-executor417/21727:
 #0: ffffffff8c964868 (misc_mtx){+.+.}-{3:3}, at: misc_open+0x55/0x4a0 drivers/char/misc.c:107
 #1: ffffffff8da55548 (rfkill_global_mutex){+.+.}-{3:3}, at: rfkill_fop_open+0xfe/0x700 net/rfkill/core.c:1147

=============================================

NMI backtrace for cpu 0
CPU: 0 PID: 1664 Comm: khungtaskd Not tainted 5.11.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0xfa/0x151 lib/dump_stack.c:120
 nmi_cpu_backtrace.cold+0x44/0xd7 lib/nmi_backtrace.c:105
 nmi_trigger_cpumask_backtrace+0x1b3/0x230 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:209 [inline]
 watchdog+0xd48/0xfb0 kernel/hung_task.c:294
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 PID: 20993 Comm: kworker/u4:8 Not tainted 5.11.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: bat_events batadv_nc_worker
RIP: 0010:__lock_acquire+0x3c/0x54c0 kernel/locking/lockdep.c:4758
Code: 89 f5 53 48 81 ec e8 00 00 00 48 8b 84 24 20 01 00 00 48 c7 84 24 88 00 00 00 b3 8a b5 41 48 c7 84 24 90 00 00 00 05 be eb 8a <48> c7 84 24 98 00 00 00 e0 c9 58 81 44 89 44 24 08 48 89 44 24 20
RSP: 0018:ffffc9000b2d7a60 EFLAGS: 00000086
RAX: 0000000000000000 RBX: 1ffff9200165af76 RCX: 0000000000000002
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff8bf74160
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: fffffbfff1b8c4f1 R11: 0000000000000000 R12: 0000000000000002
R13: 0000000000000000 R14: ffffffff8bf74160 R15: 0000000000000002
FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f56f8869000 CR3: 000000001c7ee000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 lock_acquire kernel/locking/lockdep.c:5510 [inline]
 lock_acquire+0x1ab/0x730 kernel/locking/lockdep.c:5475
 rcu_lock_acquire include/linux/rcupdate.h:267 [inline]
 rcu_read_lock include/linux/rcupdate.h:656 [inline]
 batadv_nc_purge_orig_hash net/batman-adv/network-coding.c:404 [inline]
 batadv_nc_worker+0x12d/0xe50 net/batman-adv/network-coding.c:715
 process_one_work+0x98d/0x1600 kernel/workqueue.c:2275
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

