Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19E8C436B6A
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 21:39:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231433AbhJUTlt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 15:41:49 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:37568 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbhJUTls (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 15:41:48 -0400
Received: by mail-io1-f69.google.com with SMTP id w8-20020a0566022c0800b005dc06acea8dso1207841iov.4
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 12:39:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=stILLCHo2x1Ny9sM198jHpFIvv7N48qafiXn5jmb3uA=;
        b=IoT5lJaAyuM+duOFgtgKs0ILmHUE4H+DRiKOxTNlmV0X8c0fi4xzUemNcU6joK9R2o
         ax4bmRdW8A5o2p2CVNeb+0qpsp4MILCKKaodUimJIssNaiMCQm2WZKrM4vSlhSD+Sjl/
         iLJDe0nLTSEyGeqp22Uv5NvD49gWdvgrCEM/p4EzFIHuIsjmewazWCovEa+b/K/055X9
         x5Zkowf2UY+lm3CUJqZ3eNqTHqgVb1uWpQVyEB9IJNPWXea4smCO6YYPyTI/F/Sj1w79
         4uK7yM0XJSNJXTRGXSLQ1luOjnqFDFOIbItLjdQeDm3knSjZoyMPgwJXNJeHB3MvVz3a
         Wf4g==
X-Gm-Message-State: AOAM530mw6JZKnQcrq846H3k6b7hqd6hOzM39loQyFTx8M2calWqA97O
        3bV5JTcHurC8uMc9SA20D5YG44GjEDknaddvIVP/dolGkLPY
X-Google-Smtp-Source: ABdhPJyjnXtRNBm5LmZF/aNPdYmF7rovk3gG+wruTt6nXMkApZpBSaJ6HU5fsZANTAyaq4y+QophbhIurNsKFxU1L0QWoZYbGnWF
MIME-Version: 1.0
X-Received: by 2002:a02:cf27:: with SMTP id s7mr5155877jar.71.1634845172370;
 Thu, 21 Oct 2021 12:39:32 -0700 (PDT)
Date:   Thu, 21 Oct 2021 12:39:32 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c3110805cee20d4e@google.com>
Subject: [syzbot] INFO: task hung in wg_netns_pre_exit (2)
From:   syzbot <syzbot+fa3b49ed40f26375a8ee@syzkaller.appspotmail.com>
To:     Jason@zx2c4.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, wireguard@lists.zx2c4.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    02d5e016800d Merge tag 'sound-5.15-rc4' of git://git.kerne..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16e21b17300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c76f0f4ac6e9f8d2
dashboard link: https://syzkaller.appspot.com/bug?extid=fa3b49ed40f26375a8ee
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+fa3b49ed40f26375a8ee@syzkaller.appspotmail.com

INFO: task kworker/u4:3:254 blocked for more than 143 seconds.
      Not tainted 5.15.0-rc3-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/u4:3    state:D stack:24064 pid:  254 ppid:     2 flags:0x00004000
Workqueue: netns cleanup_net
Call Trace:
 context_switch kernel/sched/core.c:4940 [inline]
 __schedule+0x940/0x26f0 kernel/sched/core.c:6287
 schedule+0xd3/0x270 kernel/sched/core.c:6366
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6425
 __mutex_lock_common kernel/locking/mutex.c:669 [inline]
 __mutex_lock+0xa34/0x12f0 kernel/locking/mutex.c:729
 wg_netns_pre_exit+0x15/0x190 drivers/net/wireguard/device.c:402
 ops_pre_exit_list net/core/net_namespace.c:158 [inline]
 cleanup_net+0x451/0xb00 net/core/net_namespace.c:579
 process_one_work+0x9bf/0x16b0 kernel/workqueue.c:2297
 worker_thread+0x658/0x11f0 kernel/workqueue.c:2444
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
INFO: task syz-executor.5:13115 blocked for more than 143 seconds.
      Not tainted 5.15.0-rc3-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.5  state:D stack:28440 pid:13115 ppid:  6871 flags:0x00004004
Call Trace:
 context_switch kernel/sched/core.c:4940 [inline]
 __schedule+0x940/0x26f0 kernel/sched/core.c:6287
 schedule+0xd3/0x270 kernel/sched/core.c:6366
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6425
 __mutex_lock_common kernel/locking/mutex.c:669 [inline]
 __mutex_lock+0xa34/0x12f0 kernel/locking/mutex.c:729
 smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
 smc_pnet_net_init+0x1f9/0x410 net/smc/smc_pnet.c:867
 ops_init+0xaf/0x470 net/core/net_namespace.c:140
 setup_net+0x40f/0xa30 net/core/net_namespace.c:326
 copy_net_ns+0x319/0x760 net/core/net_namespace.c:470
 create_new_namespaces+0x3f6/0xb20 kernel/nsproxy.c:110
 unshare_nsproxy_namespaces+0xc1/0x1f0 kernel/nsproxy.c:226
 ksys_unshare+0x445/0x920 kernel/fork.c:3077
 __do_sys_unshare kernel/fork.c:3151 [inline]
 __se_sys_unshare kernel/fork.c:3149 [inline]
 __x64_sys_unshare+0x2d/0x40 kernel/fork.c:3149
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f2348aa4709
RSP: 002b:00007f234601b188 EFLAGS: 00000246 ORIG_RAX: 0000000000000110
RAX: ffffffffffffffda RBX: 00007f2348ba8f60 RCX: 00007f2348aa4709
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000048040200
RBP: 00007f2348afecb4 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffe1dab5b5f R14: 00007f234601b300 R15: 0000000000022000
INFO: task syz-executor.5:13120 blocked for more than 144 seconds.
      Not tainted 5.15.0-rc3-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.5  state:D stack:26688 pid:13120 ppid:  6871 flags:0x00004004
Call Trace:
 context_switch kernel/sched/core.c:4940 [inline]
 __schedule+0x940/0x26f0 kernel/sched/core.c:6287
 schedule+0xd3/0x270 kernel/sched/core.c:6366
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6425
 __mutex_lock_common kernel/locking/mutex.c:669 [inline]
 __mutex_lock+0xa34/0x12f0 kernel/locking/mutex.c:729
 rtnl_lock net/core/rtnetlink.c:72 [inline]
 rtnetlink_rcv_msg+0x3be/0xb80 net/core/rtnetlink.c:5569
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:724
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2409
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2463
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2492
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f2348aa4709
RSP: 002b:00007f2345ffa188 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f2348ba9020 RCX: 00007f2348aa4709
RDX: 0000000000000000 RSI: 0000000020000100 RDI: 0000000000000003
RBP: 00007f2348afecb4 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffe1dab5b5f R14: 00007f2345ffa300 R15: 0000000000022000
INFO: task syz-executor.5:13156 blocked for more than 144 seconds.
      Not tainted 5.15.0-rc3-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.5  state:D stack:28696 pid:13156 ppid:  6871 flags:0x00004004
Call Trace:
 context_switch kernel/sched/core.c:4940 [inline]
 __schedule+0x940/0x26f0 kernel/sched/core.c:6287
 schedule+0xd3/0x270 kernel/sched/core.c:6366
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6425
 __mutex_lock_common kernel/locking/mutex.c:669 [inline]
 __mutex_lock+0xa34/0x12f0 kernel/locking/mutex.c:729
 smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
 smc_pnet_net_init+0x1f9/0x410 net/smc/smc_pnet.c:867
 ops_init+0xaf/0x470 net/core/net_namespace.c:140
 setup_net+0x40f/0xa30 net/core/net_namespace.c:326
 copy_net_ns+0x319/0x760 net/core/net_namespace.c:470
 create_new_namespaces+0x3f6/0xb20 kernel/nsproxy.c:110
 unshare_nsproxy_namespaces+0xc1/0x1f0 kernel/nsproxy.c:226
 ksys_unshare+0x445/0x920 kernel/fork.c:3077
 __do_sys_unshare kernel/fork.c:3151 [inline]
 __se_sys_unshare kernel/fork.c:3149 [inline]
 __x64_sys_unshare+0x2d/0x40 kernel/fork.c:3149
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f2348aa4709
RSP: 002b:00007f2345fd9188 EFLAGS: 00000246 ORIG_RAX: 0000000000000110
RAX: ffffffffffffffda RBX: 00007f2348ba90e0 RCX: 00007f2348aa4709
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000048040200
RBP: 00007f2348afecb4 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffe1dab5b5f R14: 00007f2345fd9300 R15: 0000000000022000
INFO: task syz-executor.5:13162 blocked for more than 145 seconds.
      Not tainted 5.15.0-rc3-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.5  state:D stack:28024 pid:13162 ppid:  6871 flags:0x00000004
Call Trace:
 context_switch kernel/sched/core.c:4940 [inline]
 __schedule+0x940/0x26f0 kernel/sched/core.c:6287
 schedule+0xd3/0x270 kernel/sched/core.c:6366
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6425
 __mutex_lock_common kernel/locking/mutex.c:669 [inline]
 __mutex_lock+0xa34/0x12f0 kernel/locking/mutex.c:729
 rtnl_lock net/core/rtnetlink.c:72 [inline]
 rtnetlink_rcv_msg+0x3be/0xb80 net/core/rtnetlink.c:5569
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:724
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2409
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2463
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2492
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f2348aa4709
RSP: 002b:00007f2345f97188 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f2348ba9260 RCX: 00007f2348aa4709
RDX: 0000000000000000 RSI: 0000000020000100 RDI: 0000000000000003
RBP: 00007f2348afecb4 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffe1dab5b5f R14: 00007f2345f97300 R15: 0000000000022000
INFO: task syz-executor.2:13147 blocked for more than 145 seconds.
      Not tainted 5.15.0-rc3-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.2  state:D stack:28072 pid:13147 ppid:  6566 flags:0x00000004
Call Trace:
 context_switch kernel/sched/core.c:4940 [inline]
 __schedule+0x940/0x26f0 kernel/sched/core.c:6287
 schedule+0xd3/0x270 kernel/sched/core.c:6366
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6425
 __mutex_lock_common kernel/locking/mutex.c:669 [inline]
 __mutex_lock+0xa34/0x12f0 kernel/locking/mutex.c:729
 rtnl_lock net/core/rtnetlink.c:72 [inline]
 rtnetlink_rcv_msg+0x3be/0xb80 net/core/rtnetlink.c:5569
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:724
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2409
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2463
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2492
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fccb83ee709
RSP: 002b:00007fccb5965188 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007fccb84f2f60 RCX: 00007fccb83ee709
RDX: 0000000000000000 RSI: 0000000020000040 RDI: 0000000000000006
RBP: 00007fccb8448cb4 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffd586b757f R14: 00007fccb5965300 R15: 0000000000022000
INFO: task syz-executor.2:13150 blocked for more than 145 seconds.
      Not tainted 5.15.0-rc3-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.2  state:D stack:28656 pid:13150 ppid:  6566 flags:0x00000004
Call Trace:
 context_switch kernel/sched/core.c:4940 [inline]
 __schedule+0x940/0x26f0 kernel/sched/core.c:6287
 schedule+0xd3/0x270 kernel/sched/core.c:6366
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6425
 __mutex_lock_common kernel/locking/mutex.c:669 [inline]
 __mutex_lock+0xa34/0x12f0 kernel/locking/mutex.c:729
 rtnl_lock net/core/rtnetlink.c:72 [inline]
 rtnetlink_rcv_msg+0x3be/0xb80 net/core/rtnetlink.c:5569
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:724
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2409
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2463
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2492
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fccb83ee709
RSP: 002b:00007fccb5944188 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007fccb84f3020 RCX: 00007fccb83ee709
RDX: 0000000000000000 RSI: 0000000020000180 RDI: 0000000000000005
RBP: 00007fccb8448cb4 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffd586b757f R14: 00007fccb5944300 R15: 0000000000022000
INFO: task syz-executor.2:13153 blocked for more than 146 seconds.
      Not tainted 5.15.0-rc3-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.2  state:D stack:28656 pid:13153 ppid:  6566 flags:0x00004004
Call Trace:
 context_switch kernel/sched/core.c:4940 [inline]
 __schedule+0x940/0x26f0 kernel/sched/core.c:6287
 schedule+0xd3/0x270 kernel/sched/core.c:6366
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6425
 __mutex_lock_common kernel/locking/mutex.c:669 [inline]
 __mutex_lock+0xa34/0x12f0 kernel/locking/mutex.c:729
 rtnl_lock net/core/rtnetlink.c:72 [inline]
 rtnetlink_rcv_msg+0x3be/0xb80 net/core/rtnetlink.c:5569
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:724
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2409
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2463
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2492
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fccb83ee709
RSP: 002b:00007fccb5923188 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007fccb84f30e0 RCX: 00007fccb83ee709
RDX: 0000000000000000 RSI: 0000000020000080 RDI: 0000000000000004
RBP: 00007fccb8448cb4 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffd586b757f R14: 00007fccb5923300 R15: 0000000000022000
INFO: task syz-executor.2:13167 blocked for more than 146 seconds.
      Not tainted 5.15.0-rc3-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.2  state:D stack:28656 pid:13167 ppid:  6566 flags:0x00000004
Call Trace:
 context_switch kernel/sched/core.c:4940 [inline]
 __schedule+0x940/0x26f0 kernel/sched/core.c:6287
 schedule+0xd3/0x270 kernel/sched/core.c:6366
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6425
 __mutex_lock_common kernel/locking/mutex.c:669 [inline]
 __mutex_lock+0xa34/0x12f0 kernel/locking/mutex.c:729
 rtnl_lock net/core/rtnetlink.c:72 [inline]
 rtnetlink_rcv_msg+0x3be/0xb80 net/core/rtnetlink.c:5569
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:724
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2409
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2463
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2492
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fccb83ee709
RSP: 002b:00007fccb58e1188 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007fccb84f3260 RCX: 00007fccb83ee709
RDX: 0000000000000000 RSI: 0000000020000040 RDI: 0000000000000006
RBP: 00007fccb8448cb4 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffd586b757f R14: 00007fccb58e1300 R15: 0000000000022000
INFO: task syz-executor.2:13168 blocked for more than 147 seconds.
      Not tainted 5.15.0-rc3-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.2  state:D stack:28656 pid:13168 ppid:  6566 flags:0x00004004
Call Trace:
 context_switch kernel/sched/core.c:4940 [inline]
 __schedule+0x940/0x26f0 kernel/sched/core.c:6287
 schedule+0xd3/0x270 kernel/sched/core.c:6366
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6425
 __mutex_lock_common kernel/locking/mutex.c:669 [inline]
 __mutex_lock+0xa34/0x12f0 kernel/locking/mutex.c:729
 rtnl_lock net/core/rtnetlink.c:72 [inline]
 rtnetlink_rcv_msg+0x3be/0xb80 net/core/rtnetlink.c:5569
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:724
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2409
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2463
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2492
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fccb83ee709
RSP: 002b:00007fccb58c0188 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007fccb84f3320 RCX: 00007fccb83ee709
RDX: 0000000000000000 RSI: 0000000020000180 RDI: 0000000000000005
RBP: 00007fccb8448cb4 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffd586b757f R14: 00007fccb58c0300 R15: 0000000000022000

Showing all locks held in the system:
1 lock held by khungtaskd/27:
 #0: ffffffff8b97d420 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:6446
4 locks held by kworker/u4:3/254:
 #0: ffff888140275938 ((wq_completion)netns){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888140275938 ((wq_completion)netns){+.+.}-{0:0}, at: arch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]
 #0: ffff888140275938 ((wq_completion)netns){+.+.}-{0:0}, at: atomic_long_set include/linux/atomic/atomic-instrumented.h:1198 [inline]
 #0: ffff888140275938 ((wq_completion)netns){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:634 [inline]
 #0: ffff888140275938 ((wq_completion)netns){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:661 [inline]
 #0: ffff888140275938 ((wq_completion)netns){+.+.}-{0:0}, at: process_one_work+0x8a3/0x16b0 kernel/workqueue.c:2268
 #1: ffffc90002107db0 (net_cleanup_work){+.+.}-{0:0}, at: process_one_work+0x8d7/0x16b0 kernel/workqueue.c:2272
 #2: ffffffff8d0cef50 (pernet_ops_rwsem){++++}-{3:3}, at: cleanup_net+0x9b/0xb00 net/core/net_namespace.c:553
 #3: ffffffff8d0e21a8 (rtnl_mutex){+.+.}-{3:3}, at: wg_netns_pre_exit+0x15/0x190 drivers/net/wireguard/device.c:402
3 locks held by kworker/1:3/2932:
 #0: ffff888027a77938 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888027a77938 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: arch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]
 #0: ffff888027a77938 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: atomic_long_set include/linux/atomic/atomic-instrumented.h:1198 [inline]
 #0: ffff888027a77938 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:634 [inline]
 #0: ffff888027a77938 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:661 [inline]
 #0: ffff888027a77938 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: process_one_work+0x8a3/0x16b0 kernel/workqueue.c:2268
 #1: ffffc9000c517db0 ((addr_chk_work).work){+.+.}-{0:0}, at: process_one_work+0x8d7/0x16b0 kernel/workqueue.c:2272
 #2: ffffffff8d0e21a8 (rtnl_mutex){+.+.}-{3:3}, at: addrconf_verify_work+0xa/0x20 net/ipv6/addrconf.c:4590
1 lock held by in:imklog/6229:
 #0: ffff88806fed6df0 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xe9/0x100 fs/file.c:990
3 locks held by kworker/0:4/8291:
 #0: ffff888010c67d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888010c67d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]
 #0: ffff888010c67d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic_long_set include/linux/atomic/atomic-instrumented.h:1198 [inline]
 #0: ffff888010c67d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:634 [inline]
 #0: ffff888010c67d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:661 [inline]
 #0: ffff888010c67d38 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x8a3/0x16b0 kernel/workqueue.c:2268
 #1: ffffc9001698fdb0 ((linkwatch_work).work){+.+.}-{0:0}, at: process_one_work+0x8d7/0x16b0 kernel/workqueue.c:2272
 #2: ffffffff8d0e21a8 (rtnl_mutex){+.+.}-{3:3}, at: linkwatch_event+0xb/0x60 net/core/link_watch.c:251
3 locks held by kworker/0:5/8480:
 #0: ffff888010c67d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888010c67d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]
 #0: ffff888010c67d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic_long_set include/linux/atomic/atomic-instrumented.h:1198 [inline]
 #0: ffff888010c67d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:634 [inline]
 #0: ffff888010c67d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:661 [inline]
 #0: ffff888010c67d38 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x8a3/0x16b0 kernel/workqueue.c:2268
 #1: ffffc900171cfdb0 (deferred_process_work){+.+.}-{0:0}, at: process_one_work+0x8d7/0x16b0 kernel/workqueue.c:2272
 #2: ffffffff8d0e21a8 (rtnl_mutex){+.+.}-{3:3}, at: switchdev_deferred_process_work+0xa/0x20 net/switchdev/switchdev.c:74
2 locks held by syz-executor.1/13097:
2 locks held by syz-executor.5/13115:
 #0: ffffffff8d0cef50 (pernet_ops_rwsem){++++}-{3:3}, at: copy_net_ns+0x2f5/0x760 net/core/net_namespace.c:466
 #1: ffffffff8d0e21a8 (rtnl_mutex){+.+.}-{3:3}, at: smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
 #1: ffffffff8d0e21a8 (rtnl_mutex){+.+.}-{3:3}, at: smc_pnet_net_init+0x1f9/0x410 net/smc/smc_pnet.c:867
1 lock held by syz-executor.5/13120:
 #0: ffffffff8d0e21a8 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:72 [inline]
 #0: ffffffff8d0e21a8 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x3be/0xb80 net/core/rtnetlink.c:5569
2 locks held by syz-executor.5/13156:
 #0: ffffffff8d0cef50 (pernet_ops_rwsem){++++}-{3:3}, at: copy_net_ns+0x2f5/0x760 net/core/net_namespace.c:466
 #1: ffffffff8d0e21a8 (rtnl_mutex){+.+.}-{3:3}, at: smc_pnet_create_pnetids_list net/smc/smc_pnet.c:798 [inline]
 #1: ffffffff8d0e21a8 (rtnl_mutex){+.+.}-{3:3}, at: smc_pnet_net_init+0x1f9/0x410 net/smc/smc_pnet.c:867
1 lock held by syz-executor.5/13162:
 #0: ffffffff8d0e21a8 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:72 [inline]
 #0: ffffffff8d0e21a8 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x3be/0xb80 net/core/rtnetlink.c:5569
1 lock held by syz-executor.2/13147:
 #0: ffffffff8d0e21a8 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:72 [inline]
 #0: ffffffff8d0e21a8 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x3be/0xb80 net/core/rtnetlink.c:5569
1 lock held by syz-executor.2/13150:
 #0: ffffffff8d0e21a8 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:72 [inline]
 #0: ffffffff8d0e21a8 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x3be/0xb80 net/core/rtnetlink.c:5569
1 lock held by syz-executor.2/13153:
 #0: ffffffff8d0e21a8 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:72 [inline]
 #0: ffffffff8d0e21a8 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x3be/0xb80 net/core/rtnetlink.c:5569
1 lock held by syz-executor.2/13167:
 #0: ffffffff8d0e21a8 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:72 [inline]
 #0: ffffffff8d0e21a8 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x3be/0xb80 net/core/rtnetlink.c:5569
1 lock held by syz-executor.2/13168:
 #0: ffffffff8d0e21a8 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:72 [inline]
 #0: ffffffff8d0e21a8 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x3be/0xb80 net/core/rtnetlink.c:5569

=============================================

NMI backtrace for cpu 0
CPU: 0 PID: 27 Comm: khungtaskd Not tainted 5.15.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 nmi_cpu_backtrace.cold+0x47/0x144 lib/nmi_backtrace.c:105
 nmi_trigger_cpumask_backtrace+0x1ae/0x220 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:210 [inline]
 watchdog+0xc1d/0xf50 kernel/hung_task.c:295
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 PID: 154 Comm: kworker/u4:2 Not tainted 5.15.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: phy8 ieee80211_iface_work
RIP: 0010:lock_acquire kernel/locking/lockdep.c:5628 [inline]
RIP: 0010:lock_acquire+0x1d3/0x510 kernel/locking/lockdep.c:5590
Code: ff ff 48 c7 c7 c0 e5 8b 89 48 83 c4 20 e8 45 b4 da 07 b8 ff ff ff ff 65 0f c1 05 a8 70 a7 7e 83 f8 01 0f 85 b4 02 00 00 9c 58 <f6> c4 02 0f 85 9f 02 00 00 48 83 7c 24 08 00 74 01 fb 48 b8 00 00
RSP: 0018:ffffc900011e6e58 EFLAGS: 00000046
RAX: 0000000000000046 RBX: 1ffff9200023cdcd RCX: ffffffff815a36bf
RDX: 1ffff11002293d46 RSI: 0000000000000001 RDI: 0000000000000000
RBP: 0000000000000001 R08: 0000000000000000 R09: ffffffff8fd00927
R10: fffffbfff1fa0124 R11: 000000000000003f R12: 0000000000000000
R13: 0000000000000000 R14: ffffffff90455b70 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f056bfab000 CR3: 00000000273a9000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
 _raw_spin_lock_irqsave+0x39/0x50 kernel/locking/spinlock.c:162
 __debug_check_no_obj_freed lib/debugobjects.c:980 [inline]
 debug_check_no_obj_freed+0xc7/0x420 lib/debugobjects.c:1023
 kfree+0xd1/0x2c0 mm/slab.c:3802
 ieee802_11_parse_elems_crc+0xac2/0xfe0 net/mac80211/util.c:1517
 ieee802_11_parse_elems net/mac80211/ieee80211_i.h:2207 [inline]
 ieee80211_bss_info_update+0x468/0xb60 net/mac80211/scan.c:212
 ieee80211_rx_bss_info net/mac80211/ibss.c:1119 [inline]
 ieee80211_rx_mgmt_probe_beacon+0xcce/0x17c0 net/mac80211/ibss.c:1608
 ieee80211_ibss_rx_queued_mgmt+0xd37/0x1610 net/mac80211/ibss.c:1635
 ieee80211_iface_process_skb net/mac80211/iface.c:1439 [inline]
 ieee80211_iface_work+0xa65/0xd00 net/mac80211/iface.c:1493
 process_one_work+0x9bf/0x16b0 kernel/workqueue.c:2297
 worker_thread+0x658/0x11f0 kernel/workqueue.c:2444
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
----------------
Code disassembly (best guess), 1 bytes skipped:
   0:	ff 48 c7             	decl   -0x39(%rax)
   3:	c7 c0 e5 8b 89 48    	mov    $0x48898be5,%eax
   9:	83 c4 20             	add    $0x20,%esp
   c:	e8 45 b4 da 07       	callq  0x7dab456
  11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  16:	65 0f c1 05 a8 70 a7 	xadd   %eax,%gs:0x7ea770a8(%rip)        # 0x7ea770c6
  1d:	7e
  1e:	83 f8 01             	cmp    $0x1,%eax
  21:	0f 85 b4 02 00 00    	jne    0x2db
  27:	9c                   	pushfq
  28:	58                   	pop    %rax
* 29:	f6 c4 02             	test   $0x2,%ah <-- trapping instruction
  2c:	0f 85 9f 02 00 00    	jne    0x2d1
  32:	48 83 7c 24 08 00    	cmpq   $0x0,0x8(%rsp)
  38:	74 01                	je     0x3b
  3a:	fb                   	sti
  3b:	48                   	rex.W
  3c:	b8                   	.byte 0xb8


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
