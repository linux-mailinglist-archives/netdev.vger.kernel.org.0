Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 830AB259F6A
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 21:50:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732018AbgIATuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 15:50:25 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:54012 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729348AbgIATuY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 15:50:24 -0400
Received: by mail-il1-f199.google.com with SMTP id o18so1738564ill.20
        for <netdev@vger.kernel.org>; Tue, 01 Sep 2020 12:50:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=QCcUk6PDJ66T5rY64nvFgrqzOsiBnvjDHR8LfK6QB6w=;
        b=P+KWY438ylJ4BuYTW3wWAf897Z5PJoNzkKmop2EQ2AxWxAS06/ALcD5PobSJZo1811
         PbBpfz4N2L43BvSGUzTCMCGP3EDG0tbSIY9BK8B+1aE/J6X7mzNkqyHtDFpfUdrP9wX6
         sUbaRF3pQFKOFVEKtpMrVO1LiVGWM7wNmTtpLMvUxvgMJz1RxdT+x9DL4MayFmZfBQZi
         +cFoE02bOI+ZCzrTNxPtzJ7+rE6JGWLigFIraKagQa6b3rqDaptRzQ/T+YI91mQnaJmy
         fUxzVnQmKVQFSXUoWUmTRKGnh18y6msbsu872+zLzpXMGXCTgi2OmX+cKP3JCpCnG9jk
         OEzg==
X-Gm-Message-State: AOAM532f1wV8Q6A1KoBio8CTLoZAPbp5EoO5EnxlzOHO0RSQ6ytdmRPx
        AA2A5CRO4G9QR98FEH7FvtS04fIPzKYZnxPR3nZvNDu8CXuB
X-Google-Smtp-Source: ABdhPJxiYFujkpS7nBzuzp8GpXCF2cbV4LuRtjQLL2CXA/QBzPK3lBB9PlerEbjYZDQ9Sj8fB40lmIkZgytC4lHDz+r0+w2dkPEv
MIME-Version: 1.0
X-Received: by 2002:a02:820b:: with SMTP id o11mr2893214jag.136.1598989822335;
 Tue, 01 Sep 2020 12:50:22 -0700 (PDT)
Date:   Tue, 01 Sep 2020 12:50:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005c1dc605ae45d401@google.com>
Subject: INFO: task can't die in register_netdevice_notifier
From:   syzbot <syzbot+df649192fec7dd1beaa7@syzkaller.appspotmail.com>
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

syzbot found the following issue on:

HEAD commit:    b36c9697 Add linux-next specific files for 20200828
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=16660271900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5e3cf99580b5542c
dashboard link: https://syzkaller.appspot.com/bug?extid=df649192fec7dd1beaa7
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+df649192fec7dd1beaa7@syzkaller.appspotmail.com

INFO: task syz-executor.4:10877 can't die for more than 143 seconds.
task:syz-executor.4  state:D stack:29424 pid:10877 ppid:  6874 flags:0x00004004
Call Trace:
 context_switch kernel/sched/core.c:3778 [inline]
 __schedule+0x8e5/0x21e0 kernel/sched/core.c:4527
 schedule+0xd0/0x2a0 kernel/sched/core.c:4602
 rwsem_down_write_slowpath+0x603/0xc60 kernel/locking/rwsem.c:1235
 __down_write kernel/locking/rwsem.c:1389 [inline]
 down_write+0x137/0x150 kernel/locking/rwsem.c:1532
 register_netdevice_notifier+0x1e/0x260 net/core/dev.c:1814
 bcm_init+0x1a3/0x210 net/can/bcm.c:1451
 can_create+0x27c/0x4d0 net/can/af_can.c:168
 __sock_create+0x3ca/0x740 net/socket.c:1427
 sock_create net/socket.c:1478 [inline]
 __sys_socket+0xef/0x200 net/socket.c:1520
 __do_sys_socket net/socket.c:1529 [inline]
 __se_sys_socket net/socket.c:1527 [inline]
 __x64_sys_socket+0x6f/0xb0 net/socket.c:1527
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45d5b9
Code: Bad RIP value.
RSP: 002b:00007f336efccc78 EFLAGS: 00000246 ORIG_RAX: 0000000000000029
RAX: ffffffffffffffda RBX: 0000000000032b40 RCX: 000000000045d5b9
RDX: 0000000000000002 RSI: 0000000000000002 RDI: 000000000000001d
RBP: 000000000118cf80 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000118cf4c
R13: 00007ffed071b14f R14: 00007f336efcd9c0 R15: 000000000118cf4c
INFO: task syz-executor.4:10877 blocked for more than 143 seconds.
      Not tainted 5.9.0-rc2-next-20200828-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.4  state:D stack:29424 pid:10877 ppid:  6874 flags:0x00004004
Call Trace:
 context_switch kernel/sched/core.c:3778 [inline]
 __schedule+0x8e5/0x21e0 kernel/sched/core.c:4527
 schedule+0xd0/0x2a0 kernel/sched/core.c:4602
 rwsem_down_write_slowpath+0x603/0xc60 kernel/locking/rwsem.c:1235
 __down_write kernel/locking/rwsem.c:1389 [inline]
 down_write+0x137/0x150 kernel/locking/rwsem.c:1532
 register_netdevice_notifier+0x1e/0x260 net/core/dev.c:1814
 bcm_init+0x1a3/0x210 net/can/bcm.c:1451
 can_create+0x27c/0x4d0 net/can/af_can.c:168
 __sock_create+0x3ca/0x740 net/socket.c:1427
 sock_create net/socket.c:1478 [inline]
 __sys_socket+0xef/0x200 net/socket.c:1520
 __do_sys_socket net/socket.c:1529 [inline]
 __se_sys_socket net/socket.c:1527 [inline]
 __x64_sys_socket+0x6f/0xb0 net/socket.c:1527
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45d5b9
Code: Bad RIP value.
RSP: 002b:00007f336efccc78 EFLAGS: 00000246 ORIG_RAX: 0000000000000029
RAX: ffffffffffffffda RBX: 0000000000032b40 RCX: 000000000045d5b9
RDX: 0000000000000002 RSI: 0000000000000002 RDI: 000000000000001d
RBP: 000000000118cf80 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000118cf4c
R13: 00007ffed071b14f R14: 00007f336efcd9c0 R15: 000000000118cf4c
INFO: task syz-executor.4:10881 can't die for more than 144 seconds.
task:syz-executor.4  state:D stack:29792 pid:10881 ppid:  6874 flags:0x00000004
Call Trace:
 context_switch kernel/sched/core.c:3778 [inline]
 __schedule+0x8e5/0x21e0 kernel/sched/core.c:4527
 schedule+0xd0/0x2a0 kernel/sched/core.c:4602
 rwsem_down_write_slowpath+0x603/0xc60 kernel/locking/rwsem.c:1235
 __down_write kernel/locking/rwsem.c:1389 [inline]
 down_write+0x137/0x150 kernel/locking/rwsem.c:1532
 register_netdevice_notifier+0x1e/0x260 net/core/dev.c:1814
 bcm_init+0x1a3/0x210 net/can/bcm.c:1451
 can_create+0x27c/0x4d0 net/can/af_can.c:168
 __sock_create+0x3ca/0x740 net/socket.c:1427
 sock_create net/socket.c:1478 [inline]
 __sys_socket+0xef/0x200 net/socket.c:1520
 __do_sys_socket net/socket.c:1529 [inline]
 __se_sys_socket net/socket.c:1527 [inline]
 __x64_sys_socket+0x6f/0xb0 net/socket.c:1527
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45d5b9
Code: Bad RIP value.
RSP: 002b:00007f336edccc78 EFLAGS: 00000246 ORIG_RAX: 0000000000000029
RAX: ffffffffffffffda RBX: 0000000000032b40 RCX: 000000000045d5b9
RDX: 0000000000000002 RSI: 0000000000000002 RDI: 000000000000001d
RBP: 000000000118d0c0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000118d08c
R13: 00007ffed071b14f R14: 00007f336edcd9c0 R15: 000000000118d08c
INFO: task syz-executor.4:10881 blocked for more than 144 seconds.
      Not tainted 5.9.0-rc2-next-20200828-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.4  state:D stack:29792 pid:10881 ppid:  6874 flags:0x00000004
Call Trace:
 context_switch kernel/sched/core.c:3778 [inline]
 __schedule+0x8e5/0x21e0 kernel/sched/core.c:4527
 schedule+0xd0/0x2a0 kernel/sched/core.c:4602
 rwsem_down_write_slowpath+0x603/0xc60 kernel/locking/rwsem.c:1235
 __down_write kernel/locking/rwsem.c:1389 [inline]
 down_write+0x137/0x150 kernel/locking/rwsem.c:1532
 register_netdevice_notifier+0x1e/0x260 net/core/dev.c:1814
 bcm_init+0x1a3/0x210 net/can/bcm.c:1451
 can_create+0x27c/0x4d0 net/can/af_can.c:168
 __sock_create+0x3ca/0x740 net/socket.c:1427
 sock_create net/socket.c:1478 [inline]
 __sys_socket+0xef/0x200 net/socket.c:1520
 __do_sys_socket net/socket.c:1529 [inline]
 __se_sys_socket net/socket.c:1527 [inline]
 __x64_sys_socket+0x6f/0xb0 net/socket.c:1527
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45d5b9
Code: Bad RIP value.
RSP: 002b:00007f336edccc78 EFLAGS: 00000246 ORIG_RAX: 0000000000000029
RAX: ffffffffffffffda RBX: 0000000000032b40 RCX: 000000000045d5b9
RDX: 0000000000000002 RSI: 0000000000000002 RDI: 000000000000001d
RBP: 000000000118d0c0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000118d08c
R13: 00007ffed071b14f R14: 00007f336edcd9c0 R15: 000000000118d08c

Showing all locks held in the system:
2 locks held by kworker/u4:2/80:
 #0: ffff8880ae635f98 (&rq->lock){-.-.}-{2:2}, at: rq_lock kernel/sched/sched.h:1292 [inline]
 #0: ffff8880ae635f98 (&rq->lock){-.-.}-{2:2}, at: __schedule+0x232/0x21e0 kernel/sched/core.c:4445
 #1: ffff8880ae620ec8 (&per_cpu_ptr(group->pcpu, cpu)->seq){-.-.}-{0:0}, at: psi_task_switch+0x2fb/0x400 kernel/sched/psi.c:833
1 lock held by khungtaskd/1169:
 #0: ffffffff89c67640 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:5825
1 lock held by in:imklog/6548:
 #0: ffff888093dd26b0 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xe9/0x100 fs/file.c:930
2 locks held by rs:main Q:Reg/6549:
 #0: ffff88809deee130 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xe9/0x100 fs/file.c:930
 #1: ffff888098aea460 (sb_writers#4){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:2790 [inline]
 #1: ffff888098aea460 (sb_writers#4){.+.+}-{0:0}, at: vfs_write+0x54f/0x730 fs/read_write.c:574
3 locks held by kworker/u4:8/8625:
1 lock held by syz-executor.4/10877:
 #0: ffffffff8a879430 (pernet_ops_rwsem){++++}-{3:3}, at: register_netdevice_notifier+0x1e/0x260 net/core/dev.c:1814
1 lock held by syz-executor.4/10881:
 #0: ffffffff8a879430 (pernet_ops_rwsem){++++}-{3:3}, at: register_netdevice_notifier+0x1e/0x260 net/core/dev.c:1814

=============================================

NMI backtrace for cpu 1
CPU: 1 PID: 1169 Comm: khungtaskd Not tainted 5.9.0-rc2-next-20200828-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 nmi_cpu_backtrace.cold+0x44/0xd7 lib/nmi_backtrace.c:105
 nmi_trigger_cpumask_backtrace+0x1b3/0x223 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:147 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:253 [inline]
 watchdog+0xd89/0xf30 kernel/hung_task.c:339
 kthread+0x3b5/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 PID: 8625 Comm: kworker/u4:8 Not tainted 5.9.0-rc2-next-20200828-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: netns cleanup_net
RIP: 0010:lock_acquire+0x1e/0xad0 kernel/locking/lockdep.c:4977
Code: 66 90 66 2e 0f 1f 84 00 00 00 00 00 41 57 41 56 41 89 d6 41 55 49 89 fd 41 54 41 89 cc 48 b9 00 00 00 00 00 fc ff df 55 89 f5 <53> 44 89 c3 48 81 ec c0 00 00 00 48 8d 44 24 20 4c 89 0c 24 48 c7
RSP: 0018:ffffc900065ffb40 EFLAGS: 00000246
RAX: 0000000000000201 RBX: 0000000000010000 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff89a6be98
RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000000
R10: 000000000000160f R11: 0000000000000001 R12: 0000000000000000
R13: ffffffff89a6be98 R14: 0000000000000000 R15: 0000000000000001
FS:  0000000000000000(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f8fc077f000 CR3: 000000009f467000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
 _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
 spin_lock include/linux/spinlock.h:354 [inline]
 nf_conntrack_lock net/netfilter/nf_conntrack_core.c:91 [inline]
 get_next_corpse net/netfilter/nf_conntrack_core.c:2204 [inline]
 nf_ct_iterate_cleanup+0x102/0x330 net/netfilter/nf_conntrack_core.c:2249
 nf_conntrack_cleanup_net_list+0x81/0x250 net/netfilter/nf_conntrack_core.c:2436
 ops_exit_list+0x10d/0x160 net/core/net_namespace.c:189
 cleanup_net+0x4ea/0xb10 net/core/net_namespace.c:603
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
