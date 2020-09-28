Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE7227A88B
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 09:27:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbgI1H1a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 03:27:30 -0400
Received: from mail-io1-f78.google.com ([209.85.166.78]:37465 "EHLO
        mail-io1-f78.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726516AbgI1H10 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 03:27:26 -0400
Received: by mail-io1-f78.google.com with SMTP id 80so115611iou.4
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 00:27:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=42TzkvZOLT3xsj9ZC1LQK/AGTghqAWoZLCZD62TJOFE=;
        b=g8ffVl4I4qT8Vq0AAfFEIJ+B2DBKF01eZRnqrtBneJ5Q5Ofc2zS4ZNqt0bbptTcEed
         IUevZCzeMUUT9kTJN/DkYRl+G6vGan1sdv/XK09xccI/qlQogqdEanRgvy/g8RVtQ7xq
         puipifhP4CY7wSAnKvw5lVWVuuxPk1Cogk5eaF71EgRxEXXsFIddIrIPORDK5XTMUhHO
         cT1SoDjaHKM8jussV9If3d+En9uiQ9fiH+p65TyyUEMko3xeUaCp4C+VG8swQyQoNB9z
         V5R01qsfvpY7KR+omY4rS1ksI9RKMq2Ts0oi1ZBlXMtVjiSa4ROqCIJIk0ENsUi2XcNT
         Vx+A==
X-Gm-Message-State: AOAM530Ey9YEcnN33xvm3ZYCYZzLaYpRpyBwErS6f+A5X4yeZbfrTmeV
        JE/usRptCcSzjnPftkWNlXZFQYZtX8DIZemskapwyrMz0o0s
X-Google-Smtp-Source: ABdhPJxJJESvFAHrd0q9wqPMXMActIEiTojv1v76VJOCCJZ9r4X3kpvQCtcGuxi3tWtGBEWuQrp8gBZC6uv0GcI3kltRjdwoR/1I
MIME-Version: 1.0
X-Received: by 2002:a02:780e:: with SMTP id p14mr143047jac.144.1601278044428;
 Mon, 28 Sep 2020 00:27:24 -0700 (PDT)
Date:   Mon, 28 Sep 2020 00:27:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000065deb05b05a99a5@google.com>
Subject: INFO: task hung in tcf_action_init_1
From:   syzbot <syzbot+82752bc5331601cf4899@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        kuba@kernel.org, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, xiyou.wangcong@gmail.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    5e46e43c MAINTAINERS: Add Vladimir as a maintainer for DSA
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=168d5a87900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=240e2ebab67245c7
dashboard link: https://syzkaller.appspot.com/bug?extid=82752bc5331601cf4899
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=115d8ebb900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17a9fa87900000

The issue was bisected to:

commit 0fedc63fadf0404a729e73a35349481c8009c02f
Author: Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed Sep 23 03:56:24 2020 +0000

    net_sched: commit action insertions together

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=123311d3900000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=113311d3900000
console output: https://syzkaller.appspot.com/x/log.txt?x=163311d3900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+82752bc5331601cf4899@syzkaller.appspotmail.com
Fixes: 0fedc63fadf0 ("net_sched: commit action insertions together")

INFO: task syz-executor923:6868 blocked for more than 143 seconds.
      Not tainted 5.9.0-rc6-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor923 state:D stack:25784 pid: 6868 ppid:  6862 flags:0x00004004
Call Trace:
 context_switch kernel/sched/core.c:3778 [inline]
 __schedule+0xec9/0x2280 kernel/sched/core.c:4527
 schedule+0xd0/0x2a0 kernel/sched/core.c:4602
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:4661
 __mutex_lock_common kernel/locking/mutex.c:1033 [inline]
 __mutex_lock+0x3e2/0x10e0 kernel/locking/mutex.c:1103
 tcf_action_init_1+0x85f/0xac0 net/sched/act_api.c:973
 tcf_action_init+0x265/0x4b0 net/sched/act_api.c:1054
 tcf_action_add+0xd9/0x360 net/sched/act_api.c:1467
 tc_ctl_action+0x33a/0x439 net/sched/act_api.c:1520
 rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5563
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
RIP: 0033:0x446c19
Code: Bad RIP value.
RSP: 002b:00007f7e9c86dd98 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000006dbc28 RCX: 0000000000446c19
RDX: 0000000000000000 RSI: 0000000020002980 RDI: 0000000000000003
RBP: 00000000006dbc20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000006dbc2c
R13: 0001008400000000 R14: 0000000000e60000 R15: 053b003000000098
INFO: task syz-executor923:6881 blocked for more than 143 seconds.
      Not tainted 5.9.0-rc6-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor923 state:D stack:28880 pid: 6881 ppid:  6862 flags:0x00004004
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
RIP: 0033:0x446c19
Code: Bad RIP value.
RSP: 002b:00007f7e9c84cd98 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000006dbc38 RCX: 0000000000446c19
RDX: 0000000000000000 RSI: 0000000020002980 RDI: 0000000000000004
RBP: 00000000006dbc30 R08: 000000000000000d R09: 0000000000000000
R10: 0000000000000050 R11: 0000000000000246 R12: 00000000006dbc3c
R13: 0001008400000000 R14: 0000000000e60000 R15: 053b003000000098
INFO: task syz-executor923:6877 blocked for more than 144 seconds.
      Not tainted 5.9.0-rc6-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor923 state:D stack:28656 pid: 6877 ppid:  6865 flags:0x00004004
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
RIP: 0033:0x446c19
Code: Bad RIP value.
RSP: 002b:00007f7e9c86dd98 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000006dbc28 RCX: 0000000000446c19
RDX: 0000000000000000 RSI: 0000000020002980 RDI: 0000000000000003
RBP: 00000000006dbc20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000006dbc2c
R13: 0001008400000000 R14: 0000000000e60000 R15: 053b003000000098
INFO: task syz-executor923:6883 blocked for more than 144 seconds.
      Not tainted 5.9.0-rc6-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor923 state:D stack:28904 pid: 6883 ppid:  6865 flags:0x00000004
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
RIP: 0033:0x446c19
Code: Bad RIP value.
RSP: 002b:00007f7e9c84cd98 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000006dbc38 RCX: 0000000000446c19
RDX: 0000000000000000 RSI: 0000000020002980 RDI: 0000000000000004
RBP: 00000000006dbc30 R08: 000000000000000d R09: 0000000000000000
R10: 0000000000000050 R11: 0000000000000246 R12: 00000000006dbc3c
R13: 0001008400000000 R14: 0000000000e60000 R15: 053b003000000098
INFO: task syz-executor923:6882 blocked for more than 144 seconds.
      Not tainted 5.9.0-rc6-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor923 state:D stack:28904 pid: 6882 ppid:  6867 flags:0x00000004
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
RIP: 0033:0x446c19
Code: Bad RIP value.
RSP: 002b:00007f7e9c84cd98 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000006dbc38 RCX: 0000000000446c19
RDX: 0000000000000000 RSI: 0000000020002980 RDI: 0000000000000004
RBP: 00000000006dbc30 R08: 000000000000000d R09: 0000000000000000
R10: 0000000000000050 R11: 0000000000000246 R12: 00000000006dbc3c
R13: 0001008400000000 R14: 0000000000e60000 R15: 053b003000000098
INFO: task syz-executor923:6878 blocked for more than 145 seconds.
      Not tainted 5.9.0-rc6-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor923 state:D stack:28904 pid: 6878 ppid:  6869 flags:0x00004004
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
RIP: 0033:0x446c19
Code: Bad RIP value.
RSP: 002b:00007f7e9c86dd98 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000006dbc28 RCX: 0000000000446c19
RDX: 0000000000000000 RSI: 0000000020002980 RDI: 0000000000000003
RBP: 00000000006dbc20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000006dbc2c
R13: 0001008400000000 R14: 0000000000e60000 R15: 053b003000000098
INFO: task syz-executor923:6884 blocked for more than 145 seconds.
      Not tainted 5.9.0-rc6-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor923 state:D stack:28904 pid: 6884 ppid:  6869 flags:0x00000004
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
RIP: 0033:0x446c19
Code: Bad RIP value.
RSP: 002b:00007f7e9c84cd98 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000006dbc38 RCX: 0000000000446c19
RDX: 0000000000000000 RSI: 0000000020002980 RDI: 0000000000000004
RBP: 00000000006dbc30 R08: 000000000000000d R09: 0000000000000000
R10: 0000000000000050 R11: 0000000000000246 R12: 00000000006dbc3c
R13: 0001008400000000 R14: 0000000000e60000 R15: 053b003000000098
INFO: task syz-executor923:6876 blocked for more than 145 seconds.
      Not tainted 5.9.0-rc6-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor923 state:D stack:28904 pid: 6876 ppid:  6866 flags:0x00004004
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
RIP: 0033:0x446c19
Code: Bad RIP value.
RSP: 002b:00007f7e9c86dd98 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000006dbc28 RCX: 0000000000446c19
RDX: 0000000000000000 RSI: 0000000020002980 RDI: 0000000000000003
RBP: 00000000006dbc20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000006dbc2c
R13: 0001008400000000 R14: 0000000000e60000 R15: 053b003000000098
INFO: task syz-executor923:6885 blocked for more than 146 seconds.
      Not tainted 5.9.0-rc6-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor923 state:D stack:28904 pid: 6885 ppid:  6866 flags:0x00000004
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
RIP: 0033:0x446c19
Code: Bad RIP value.
RSP: 002b:00007f7e9c84cd98 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000006dbc38 RCX: 0000000000446c19
RDX: 0000000000000000 RSI: 0000000020002980 RDI: 0000000000000004
RBP: 00000000006dbc30 R08: 000000000000000d R09: 0000000000000000
R10: 0000000000000050 R11: 0000000000000246 R12: 00000000006dbc3c
R13: 0001008400000000 R14: 0000000000e60000 R15: 053b003000000098
INFO: task syz-executor923:6879 blocked for more than 146 seconds.
      Not tainted 5.9.0-rc6-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor923 state:D stack:28904 pid: 6879 ppid:  6863 flags:0x00004004
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
RIP: 0033:0x446c19
Code: Bad RIP value.
RSP: 002b:00007f7e9c86dd98 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000006dbc28 RCX: 0000000000446c19
RDX: 0000000000000000 RSI: 0000000020002980 RDI: 0000000000000003
RBP: 00000000006dbc20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000006dbc2c
R13: 0001008400000000 R14: 0000000000e60000 R15: 053b003000000098

Showing all locks held in the system:
1 lock held by khungtaskd/1176:
 #0: ffffffff8a067f00 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:5852
1 lock held by in:imklog/6548:
 #0: ffff8880962a9870 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xe9/0x100 fs/file.c:930
3 locks held by kworker/1:1/6854:
 #0: ffff888099b59538 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888099b59538 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff888099b59538 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888099b59538 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff888099b59538 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff888099b59538 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: process_one_work+0x82b/0x1670 kernel/workqueue.c:2240
 #1: ffffc90005507da8 ((addr_chk_work).work){+.+.}-{0:0}, at: process_one_work+0x85f/0x1670 kernel/workqueue.c:2244
 #2: ffffffff8b14d828 (rtnl_mutex){+.+.}-{3:3}, at: addrconf_verify_work+0xa/0x20 net/ipv6/addrconf.c:4568
1 lock held by syz-executor923/6868:
 #0: ffffffff8b14d828 (rtnl_mutex){+.+.}-{3:3}, at: tcf_action_init_1+0x85f/0xac0 net/sched/act_api.c:973
1 lock held by syz-executor923/6881:
 #0: ffffffff8b14d828 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:72 [inline]
 #0: ffffffff8b14d828 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x3f9/0xad0 net/core/rtnetlink.c:5560
1 lock held by syz-executor923/6877:
 #0: ffffffff8b14d828 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:72 [inline]
 #0: ffffffff8b14d828 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x3f9/0xad0 net/core/rtnetlink.c:5560
1 lock held by syz-executor923/6883:
 #0: ffffffff8b14d828 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:72 [inline]
 #0: ffffffff8b14d828 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x3f9/0xad0 net/core/rtnetlink.c:5560
1 lock held by syz-executor923/6875:
1 lock held by syz-executor923/6882:
 #0: ffffffff8b14d828 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:72 [inline]
 #0: ffffffff8b14d828 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x3f9/0xad0 net/core/rtnetlink.c:5560
1 lock held by syz-executor923/6878:
 #0: ffffffff8b14d828 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:72 [inline]
 #0: ffffffff8b14d828 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x3f9/0xad0 net/core/rtnetlink.c:5560
1 lock held by syz-executor923/6884:
 #0: ffffffff8b14d828 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:72 [inline]
 #0: ffffffff8b14d828 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x3f9/0xad0 net/core/rtnetlink.c:5560
1 lock held by syz-executor923/6876:
 #0: ffffffff8b14d828 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:72 [inline]
 #0: ffffffff8b14d828 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x3f9/0xad0 net/core/rtnetlink.c:5560
1 lock held by syz-executor923/6885:
 #0: ffffffff8b14d828 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:72 [inline]
 #0: ffffffff8b14d828 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x3f9/0xad0 net/core/rtnetlink.c:5560
1 lock held by syz-executor923/6879:
 #0: ffffffff8b14d828 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:72 [inline]
 #0: ffffffff8b14d828 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x3f9/0xad0 net/core/rtnetlink.c:5560
1 lock held by syz-executor923/6886:
 #0: ffffffff8b14d828 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:72 [inline]
 #0: ffffffff8b14d828 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x3f9/0xad0 net/core/rtnetlink.c:5560

=============================================

NMI backtrace for cpu 0
CPU: 0 PID: 1176 Comm: khungtaskd Not tainted 5.9.0-rc6-syzkaller #0
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
CPU: 1 PID: 6875 Comm: syz-executor923 Not tainted 5.9.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__lock_acquire+0x18a/0x5780 kernel/locking/lockdep.c:4344
Code: 48 c7 c0 60 e1 43 8d 83 e0 07 83 c0 03 38 c8 7c 08 84 c9 0f 85 c9 12 00 00 44 8b 25 50 45 e8 0b 45 85 e4 75 0b 83 7c 24 10 2f <0f> 87 c6 10 00 00 48 8d b5 e8 08 00 00 48 81 ea 00 0e 0c 8d 48 b9
RSP: 0018:ffffc90005526b40 EFLAGS: 00000097
RAX: 0000000000000003 RBX: 0000000000000001 RCX: 0000000000000004
RDX: ffffffff8d1054a8 RSI: 0000000000000000 RDI: ffff888214df8670
RBP: ffff8880a17da380 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: ffff888214df8668 R15: 0000000000000000
FS:  00007f7e9c86e700(0000) GS:ffff8880ae500000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f4e31e0041c CR3: 0000000096863000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 lock_acquire+0x1f3/0xaf0 kernel/locking/lockdep.c:5029
 __mutex_lock_common kernel/locking/mutex.c:956 [inline]
 __mutex_lock+0x134/0x10e0 kernel/locking/mutex.c:1103
 tcf_idr_check_alloc+0x78/0x3b0 net/sched/act_api.c:499
 tcf_connmark_init+0x2de/0x910 net/sched/act_connmark.c:124
 tcf_action_init_1+0x6e8/0xac0 net/sched/act_api.c:995
 tcf_action_init+0x265/0x4b0 net/sched/act_api.c:1054
 tcf_action_add+0xd9/0x360 net/sched/act_api.c:1467
 tc_ctl_action+0x33a/0x439 net/sched/act_api.c:1520
 rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5563
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
RIP: 0033:0x446c19
Code: e8 0c e8 ff ff 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db 06 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f7e9c86dd98 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000006dbc28 RCX: 0000000000446c19
RDX: 0000000000000000 RSI: 0000000020002980 RDI: 0000000000000003
RBP: 00000000006dbc20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000006dbc2c
R13: 0001008400000000 R14: 0000000000e60000 R15: 053b003000000098


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
