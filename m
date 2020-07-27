Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D67A22F606
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 19:04:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729743AbgG0RER (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 13:04:17 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:55671 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728896AbgG0REQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 13:04:16 -0400
Received: by mail-il1-f198.google.com with SMTP id i78so6756515ill.22
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 10:04:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=OiWa3HwybKqXgssIc1IUb1GCgzCO1TaNjTNLJHZ22rc=;
        b=nNDFbKHQxZUpXkZ3o69qOmahypoRWyE551PqpNw3XBcna/jmCQkdf0iSK8RaVtGNzb
         a9FiZnVturJhEWkWBK21eOqbLEvX0oqnnWl6t9HWmqnERDtT1HPHRzM2hUo5XXNFVPuc
         VSlei+cDytVC1+ZbcPuy9NTsmvCtfyTOYZVn0CtCf8DNMD+RtDU727KxwyNiur6dhNdn
         E21GydPt7lR82Q/M2wZbuv/5h1FfG5TqmFZfAG9RWS54Yt1iNP/V40aGH98abFMSVnq5
         RsrFEjAURXm628fHV4EPhk6272LslyUA3tj4v5cQ8OlsoNfJmwUCxJh9fH6tYmnSw/qS
         LxNA==
X-Gm-Message-State: AOAM531ax6rcG8DQPWFu4ijsifxuQGWx/Saz24BMMkPxIIgXYWOgewdN
        Agffm9Ef6s4F4NUY77SwyqoGDQ04YQeBlTuMKdGIrfwn/4ET
X-Google-Smtp-Source: ABdhPJy8Vf1WZwDWJv63jGfzD8JMmuULHojQ36/BRKSjxkTPCpKtyJsBxTkZ9UGhy9Z1PQp8v2hjbj9RoTO8O/Kl7out4IlfNiPa
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2801:: with SMTP id d1mr18172703ioe.201.1595869455139;
 Mon, 27 Jul 2020 10:04:15 -0700 (PDT)
Date:   Mon, 27 Jul 2020 10:04:15 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000fb47cc05ab6f4f39@google.com>
Subject: INFO: task hung in switchdev_deferred_process_work (2)
From:   syzbot <syzbot+8ecc009e206a956ab317@syzkaller.appspotmail.com>
To:     davem@davemloft.net, ivecera@redhat.com, jiri@resnulli.us,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    d15be546 Merge tag 'media/v5.8-3' of git://git.kernel.org/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16ea7c64900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f87a5e4232fdb267
dashboard link: https://syzkaller.appspot.com/bug?extid=8ecc009e206a956ab317
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8ecc009e206a956ab317@syzkaller.appspotmail.com

INFO: task kworker/1:8:3807 blocked for more than 143 seconds.
      Not tainted 5.8.0-rc6-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kworker/1:8     D24832  3807      2 0x00004000
Workqueue: events switchdev_deferred_process_work
Call Trace:
 context_switch kernel/sched/core.c:3458 [inline]
 __schedule+0x91f/0x2250 kernel/sched/core.c:4215
 schedule+0xd0/0x2a0 kernel/sched/core.c:4290
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:4349
 __mutex_lock_common kernel/locking/mutex.c:1033 [inline]
 __mutex_lock+0x3e2/0x10d0 kernel/locking/mutex.c:1103
 switchdev_deferred_process_work+0xa/0x20 net/switchdev/switchdev.c:74
 process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
 kthread+0x3b5/0x4a0 kernel/kthread.c:291
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293
INFO: task kworker/1:0:20078 blocked for more than 143 seconds.
      Not tainted 5.8.0-rc6-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kworker/1:0     D25504 20078      2 0x00004000
Workqueue: events linkwatch_event
Call Trace:
 context_switch kernel/sched/core.c:3458 [inline]
 __schedule+0x91f/0x2250 kernel/sched/core.c:4215
 schedule+0xd0/0x2a0 kernel/sched/core.c:4290
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:4349
 __mutex_lock_common kernel/locking/mutex.c:1033 [inline]
 __mutex_lock+0x3e2/0x10d0 kernel/locking/mutex.c:1103
 linkwatch_event+0xb/0x60 net/core/link_watch.c:250
 process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
 kthread+0x3b5/0x4a0 kernel/kthread.c:291
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293
INFO: task syz-executor.1:30871 blocked for more than 144 seconds.
      Not tainted 5.8.0-rc6-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor.1  D28664 30871   6970 0x00000004
Call Trace:
 context_switch kernel/sched/core.c:3458 [inline]
 __schedule+0x91f/0x2250 kernel/sched/core.c:4215
 schedule+0xd0/0x2a0 kernel/sched/core.c:4290
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:4349
 __mutex_lock_common kernel/locking/mutex.c:1033 [inline]
 __mutex_lock+0x3e2/0x10d0 kernel/locking/mutex.c:1103
 rtnl_lock net/core/rtnetlink.c:72 [inline]
 rtnetlink_rcv_msg+0x3f9/0xad0 net/core/rtnetlink.c:5457
 netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2469
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2352
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2406
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2439
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45c1f9
Code: Bad RIP value.
RSP: 002b:00007fdf54395c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 000000000002b580 RCX: 000000000045c1f9
RDX: 0000000000000000 RSI: 0000000020000380 RDI: 0000000000000006
RBP: 000000000078bfe0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000078bfac
R13: 00007ffc325652af R14: 00007fdf543969c0 R15: 000000000078bfac
INFO: task syz-executor.1:30878 blocked for more than 144 seconds.
      Not tainted 5.8.0-rc6-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor.1  D29832 30878   6970 0x00000004
Call Trace:
 context_switch kernel/sched/core.c:3458 [inline]
 __schedule+0x91f/0x2250 kernel/sched/core.c:4215
 schedule+0xd0/0x2a0 kernel/sched/core.c:4290
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:4349
 __mutex_lock_common kernel/locking/mutex.c:1033 [inline]
 __mutex_lock+0x3e2/0x10d0 kernel/locking/mutex.c:1103
 sock_do_ioctl+0x1f2/0x2d0 net/socket.c:1061
 sock_ioctl+0x3b8/0x730 net/socket.c:1199
 vfs_ioctl fs/ioctl.c:48 [inline]
 ksys_ioctl+0x11a/0x180 fs/ioctl.c:753
 __do_sys_ioctl fs/ioctl.c:762 [inline]
 __se_sys_ioctl fs/ioctl.c:760 [inline]
 __x64_sys_ioctl+0x6f/0xb0 fs/ioctl.c:760
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45c1f9
Code: Bad RIP value.
RSP: 002b:00007fdf54374c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000011d80 RCX: 000000000045c1f9
RDX: 0000000000400200 RSI: 0000000000008912 RDI: 0000000000000005
RBP: 000000000078c080 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000078c04c
R13: 00007ffc325652af R14: 00007fdf543759c0 R15: 000000000078c04c
INFO: task syz-executor.1:30889 blocked for more than 145 seconds.
      Not tainted 5.8.0-rc6-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor.1  D28664 30889   6970 0x00000004
Call Trace:
 context_switch kernel/sched/core.c:3458 [inline]
 __schedule+0x91f/0x2250 kernel/sched/core.c:4215
 schedule+0xd0/0x2a0 kernel/sched/core.c:4290
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:4349
 __mutex_lock_common kernel/locking/mutex.c:1033 [inline]
 __mutex_lock+0x3e2/0x10d0 kernel/locking/mutex.c:1103
 rtnl_lock net/core/rtnetlink.c:72 [inline]
 rtnetlink_rcv_msg+0x3f9/0xad0 net/core/rtnetlink.c:5457
 netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2469
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2352
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2406
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2439
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45c1f9
Code: Bad RIP value.
RSP: 002b:00007fdf54353c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 000000000002b580 RCX: 000000000045c1f9
RDX: 0000000000000000 RSI: 0000000020000380 RDI: 0000000000000006
RBP: 000000000078c120 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000078c0ec
R13: 00007ffc325652af R14: 00007fdf543549c0 R15: 000000000078c0ec
INFO: task syz-executor.1:30890 blocked for more than 145 seconds.
      Not tainted 5.8.0-rc6-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor.1  D28664 30890   6970 0x00000004
Call Trace:
 context_switch kernel/sched/core.c:3458 [inline]
 __schedule+0x91f/0x2250 kernel/sched/core.c:4215
 schedule+0xd0/0x2a0 kernel/sched/core.c:4290
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:4349
 __mutex_lock_common kernel/locking/mutex.c:1033 [inline]
 __mutex_lock+0x3e2/0x10d0 kernel/locking/mutex.c:1103
 rtnl_lock net/core/rtnetlink.c:72 [inline]
 rtnetlink_rcv_msg+0x3f9/0xad0 net/core/rtnetlink.c:5457
 netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2469
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2352
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2406
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2439
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45c1f9
Code: Bad RIP value.
RSP: 002b:00007fdf54332c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 000000000002b580 RCX: 000000000045c1f9
RDX: 0000000000000000 RSI: 0000000020000140 RDI: 0000000000000007
RBP: 000000000078c1c0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000078c18c
R13: 00007ffc325652af R14: 00007fdf543339c0 R15: 000000000078c18c
INFO: task syz-executor.2:30867 blocked for more than 146 seconds.
      Not tainted 5.8.0-rc6-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor.2  D28664 30867   7073 0x00000004
Call Trace:
 context_switch kernel/sched/core.c:3458 [inline]
 __schedule+0x91f/0x2250 kernel/sched/core.c:4215
 schedule+0xd0/0x2a0 kernel/sched/core.c:4290
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:4349
 __mutex_lock_common kernel/locking/mutex.c:1033 [inline]
 __mutex_lock+0x3e2/0x10d0 kernel/locking/mutex.c:1103
 rtnl_lock net/core/rtnetlink.c:72 [inline]
 rtnetlink_rcv_msg+0x3f9/0xad0 net/core/rtnetlink.c:5457
 netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2469
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2352
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2406
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2439
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45c1f9
Code: Bad RIP value.
RSP: 002b:00007fb6eef7cc78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 000000000002b580 RCX: 000000000045c1f9
RDX: 0000000000000000 RSI: 0000000020000040 RDI: 0000000000000006
RBP: 000000000078bf40 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000078bf0c
R13: 00007ffec53b2bcf R14: 00007fb6eef7d9c0 R15: 000000000078bf0c
INFO: task syz-executor.2:30872 blocked for more than 146 seconds.
      Not tainted 5.8.0-rc6-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor.2  D27984 30872   7073 0x00004004
Call Trace:
 context_switch kernel/sched/core.c:3458 [inline]
 __schedule+0x91f/0x2250 kernel/sched/core.c:4215
 schedule+0xd0/0x2a0 kernel/sched/core.c:4290
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:4349
 __mutex_lock_common kernel/locking/mutex.c:1033 [inline]
 __mutex_lock+0x3e2/0x10d0 kernel/locking/mutex.c:1103
 rtnl_lock net/core/rtnetlink.c:72 [inline]
 rtnetlink_rcv_msg+0x3f9/0xad0 net/core/rtnetlink.c:5457
 netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2469
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2352
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2406
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2439
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45c1f9
Code: Bad RIP value.
RSP: 002b:00007fb6eef5bc78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 000000000002b580 RCX: 000000000045c1f9
RDX: 0000000000000000 RSI: 0000000020000080 RDI: 0000000000000004
RBP: 000000000078bfe0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000078bfac
R13: 00007ffec53b2bcf R14: 00007fb6eef5c9c0 R15: 000000000078bfac
INFO: task syz-executor.2:30877 blocked for more than 146 seconds.
      Not tainted 5.8.0-rc6-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor.2  D28664 30877   7073 0x00000004
Call Trace:
 context_switch kernel/sched/core.c:3458 [inline]
 __schedule+0x91f/0x2250 kernel/sched/core.c:4215
 schedule+0xd0/0x2a0 kernel/sched/core.c:4290
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:4349
 __mutex_lock_common kernel/locking/mutex.c:1033 [inline]
 __mutex_lock+0x3e2/0x10d0 kernel/locking/mutex.c:1103
 rtnl_lock net/core/rtnetlink.c:72 [inline]
 rtnetlink_rcv_msg+0x3f9/0xad0 net/core/rtnetlink.c:5457
 netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2469
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2352
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2406
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2439
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45c1f9
Code: Bad RIP value.
RSP: 002b:00007fb6eef3ac78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 000000000002b580 RCX: 000000000045c1f9
RDX: 0000000000000000 RSI: 0000000020000000 RDI: 0000000000000003
RBP: 000000000078c080 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000078c04c
R13: 00007ffec53b2bcf R14: 00007fb6eef3b9c0 R15: 000000000078c04c

Showing all locks held in the system:
2 locks held by kworker/u4:0/7:
 #0: ffff8880ae635e18 (&rq->lock){-.-.}-{2:2}, at: rq_lock kernel/sched/sched.h:1261 [inline]
 #0: ffff8880ae635e18 (&rq->lock){-.-.}-{2:2}, at: __schedule+0x25b/0x2250 kernel/sched/core.c:4140
 #1: ffff8880ae620f08 (&per_cpu_ptr(group->pcpu, cpu)->seq){-.-.}-{0:0}, at: psi_task_switch+0x2fb/0x400 kernel/sched/psi.c:817
1 lock held by khungtaskd/1153:
 #0: ffffffff89bc11c0 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:5779
3 locks held by kworker/1:8/3807:
 #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x82b/0x1670 kernel/workqueue.c:2240
 #1: ffffc90004bb7da8 (deferred_process_work){+.+.}-{0:0}, at: process_one_work+0x85f/0x1670 kernel/workqueue.c:2244
 #2: ffffffff8a7b8b28 (rtnl_mutex){+.+.}-{3:3}, at: switchdev_deferred_process_work+0xa/0x20 net/switchdev/switchdev.c:74
1 lock held by in:imklog/6504:
 #0: ffff8880a71efdb0 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xe9/0x100 fs/file.c:826
3 locks held by kworker/0:4/7824:
 #0: ffff888214f4fd38 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888214f4fd38 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff888214f4fd38 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888214f4fd38 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff888214f4fd38 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff888214f4fd38 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: process_one_work+0x82b/0x1670 kernel/workqueue.c:2240
 #1: ffffc9001627fda8 ((addr_chk_work).work){+.+.}-{0:0}, at: process_one_work+0x85f/0x1670 kernel/workqueue.c:2244
 #2: ffffffff8a7b8b28 (rtnl_mutex){+.+.}-{3:3}, at: addrconf_verify_work+0xa/0x20 net/ipv6/addrconf.c:4543
3 locks held by kworker/1:0/20078:
 #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x82b/0x1670 kernel/workqueue.c:2240
 #1: ffffc9000816fda8 ((linkwatch_work).work){+.+.}-{0:0}, at: process_one_work+0x85f/0x1670 kernel/workqueue.c:2244
 #2: ffffffff8a7b8b28 (rtnl_mutex){+.+.}-{3:3}, at: linkwatch_event+0xb/0x60 net/core/link_watch.c:250
2 locks held by syz-executor.1/30864:
 #0: ffffffff8a7b8b28 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:72 [inline]
 #0: ffffffff8a7b8b28 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x3f9/0xad0 net/core/rtnetlink.c:5457
 #1: ffffffff89bc5820 (rcu_state.exp_mutex){+.+.}-{3:3}, at: exp_funnel_lock kernel/rcu/tree_exp.h:290 [inline]
 #1: ffffffff89bc5820 (rcu_state.exp_mutex){+.+.}-{3:3}, at: synchronize_rcu_expedited+0x4e8/0x5f0 kernel/rcu/tree_exp.h:838
1 lock held by syz-executor.1/30871:
 #0: ffffffff8a7b8b28 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:72 [inline]
 #0: ffffffff8a7b8b28 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x3f9/0xad0 net/core/rtnetlink.c:5457
1 lock held by syz-executor.1/30878:
 #0: ffffffff8a7b8b28 (rtnl_mutex){+.+.}-{3:3}, at: sock_do_ioctl+0x1f2/0x2d0 net/socket.c:1061
1 lock held by syz-executor.1/30889:
 #0: ffffffff8a7b8b28 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:72 [inline]
 #0: ffffffff8a7b8b28 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x3f9/0xad0 net/core/rtnetlink.c:5457
1 lock held by syz-executor.1/30890:
 #0: ffffffff8a7b8b28 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:72 [inline]
 #0: ffffffff8a7b8b28 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x3f9/0xad0 net/core/rtnetlink.c:5457
1 lock held by syz-executor.2/30867:
 #0: ffffffff8a7b8b28 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:72 [inline]
 #0: ffffffff8a7b8b28 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x3f9/0xad0 net/core/rtnetlink.c:5457
1 lock held by syz-executor.2/30872:
 #0: ffffffff8a7b8b28 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:72 [inline]
 #0: ffffffff8a7b8b28 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x3f9/0xad0 net/core/rtnetlink.c:5457
1 lock held by syz-executor.2/30877:
 #0: ffffffff8a7b8b28 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:72 [inline]
 #0: ffffffff8a7b8b28 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x3f9/0xad0 net/core/rtnetlink.c:5457

=============================================

NMI backtrace for cpu 1
CPU: 1 PID: 1153 Comm: khungtaskd Not tainted 5.8.0-rc6-syzkaller #0
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
CPU: 0 PID: 7 Comm: kworker/u4:0 Not tainted 5.8.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: bat_events batadv_nc_worker
RIP: 0010:batadv_nc_purge_paths+0x9d/0x3a0 net/batman-adv/network-coding.c:437
Code: c7 44 24 0c 00 00 00 00 4c 01 f0 85 db 48 89 4c 24 28 48 89 44 24 30 0f 84 50 02 00 00 e8 ab 0a a9 f9 48 8b 44 24 30 80 38 00 <0f> 85 9e 02 00 00 48 8b 04 24 8b 5c 24 0c 48 8b 00 48 8d 2c d8 48
RSP: 0018:ffffc90000cdfc10 EFLAGS: 00000246
RAX: ffffed10143b1ec8 RBX: 0000000000000080 RCX: ffffffff87cab428
RDX: ffff8880a95e81c0 RSI: ffffffff87cab1e5 RDI: 0000000000000004
RBP: 0000000000000061 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000080 R11: 0000000000000000 R12: ffff888055ae96f0
R13: ffff888055ae8bc0 R14: dffffc0000000000 R15: ffffffff87cab790
FS:  0000000000000000(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fe4220ef500 CR3: 000000003a567000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 batadv_nc_worker+0x868/0xe50 net/batman-adv/network-coding.c:721
 process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
 kthread+0x3b5/0x4a0 kernel/kthread.c:291
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
