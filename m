Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD14D249521
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 08:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726938AbgHSGnR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 02:43:17 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:45153 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726711AbgHSGnQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 02:43:16 -0400
Received: by mail-il1-f200.google.com with SMTP id m80so244803ilb.12
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 23:43:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=R3nMeROQnANHQhgA6eIg8Oz1+wqED/F0geLQt6U/548=;
        b=ouZ+k2vurw3CG1KG3zpTbmiVjb947TTut5TcG1qYLEBfI1kzGWuaEXyQMhPJhlyv44
         WFSBLKpvXS5nxlUG/0vW/IOs45ZuohmV3dCMSt8qrKjiTh3/PT/c7eVFbrx0qnyEHcyY
         xzg881/yNzIJzl/BfPqjLCE2hTjF2vsbSAQtW0XTJYZo+/8C2gi0z0u28aFnNb5SRMdq
         l7WRcZEbEwjcn4QEn6WR4v6GZBG1iBEwntGyzMoOQStGS1EnDTj574SnmawQGwQ50mH2
         oM2vCAZ897vgQ6CkooFOi7sogP2TD7OdzI5QnOEafzNud/ZuC0fSPLL1mnOmb9Eb1MwG
         L9tQ==
X-Gm-Message-State: AOAM5305iHlasMVmaaxREzcUNL+glCUFLnYDGISwAazJqOI4+m2ORMdi
        T/0v81SGSQd7qBcv3hhvhZHm2v+KI8TE12zPuVr69lAc3YhW
X-Google-Smtp-Source: ABdhPJyWzUb0Hjy/Tie7V/hTCb5VNPTBqkVusY8sGIyiFIYvW/ROPS85zm+YFnmphK68poFXcJgqV3JCigV9PNg53JCIHqsB6ctN
MIME-Version: 1.0
X-Received: by 2002:a92:354d:: with SMTP id c74mr19524908ila.27.1597819394434;
 Tue, 18 Aug 2020 23:43:14 -0700 (PDT)
Date:   Tue, 18 Aug 2020 23:43:14 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006bac5105ad3551e9@google.com>
Subject: INFO: task can't die in tls_sk_proto_close
From:   syzbot <syzbot+739db38bc09c5a792e31@syzkaller.appspotmail.com>
To:     aviadye@mellanox.com, borisp@mellanox.com, daniel@iogearbox.net,
        davem@davemloft.net, john.fastabend@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    4993e4fe Add linux-next specific files for 20200814
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=107ad7d6900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2055bd0d83d5ee16
dashboard link: https://syzkaller.appspot.com/bug?extid=739db38bc09c5a792e31
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+739db38bc09c5a792e31@syzkaller.appspotmail.com

INFO: task syz-executor.4:22039 can't die for more than 143 seconds.
syz-executor.4  D28360 22039   6861 0x00004004
Call Trace:
 context_switch kernel/sched/core.c:3778 [inline]
 __schedule+0x8e5/0x21e0 kernel/sched/core.c:4527
 schedule+0xd0/0x2a0 kernel/sched/core.c:4602
 schedule_timeout+0x1d8/0x250 kernel/time/timer.c:1855
 do_wait_for_common kernel/sched/completion.c:85 [inline]
 __wait_for_common kernel/sched/completion.c:106 [inline]
 wait_for_common kernel/sched/completion.c:117 [inline]
 wait_for_completion+0x163/0x260 kernel/sched/completion.c:138
 __flush_work+0x51f/0xab0 kernel/workqueue.c:3046
 __cancel_work_timer+0x5de/0x700 kernel/workqueue.c:3133
 tls_sk_proto_close+0x4a7/0xaf0 net/tls/tls_main.c:305
 inet_release+0x12e/0x280 net/ipv4/af_inet.c:431
 inet6_release+0x4c/0x70 net/ipv6/af_inet6.c:475
 __sock_release+0xcd/0x280 net/socket.c:596
 sock_close+0x18/0x20 net/socket.c:1277
 __fput+0x285/0x920 fs/file_table.c:281
 task_work_run+0xdd/0x190 kernel/task_work.c:135
 tracehook_notify_resume include/linux/tracehook.h:188 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:139 [inline]
 exit_to_user_mode_prepare+0x195/0x1c0 kernel/entry/common.c:166
 syscall_exit_to_user_mode+0x59/0x2b0 kernel/entry/common.c:241
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x416b81
Code: Bad RIP value.
RSP: 002b:00007ffedaaf5920 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000004 RCX: 0000000000416b81
RDX: 0000000000000000 RSI: 0000000000000be4 RDI: 0000000000000003
RBP: 0000000000000001 R08: 00000000f2ab2be2 R09: 00000000f2ab2be6
R10: 00007ffedaaf5a10 R11: 0000000000000293 R12: 000000000118d940
R13: 000000000118d940 R14: ffffffffffffffff R15: 000000000118cf4c
INFO: task syz-executor.4:22039 blocked for more than 143 seconds.
      Not tainted 5.8.0-next-20200814-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor.4  D28360 22039   6861 0x00004004
Call Trace:
 context_switch kernel/sched/core.c:3778 [inline]
 __schedule+0x8e5/0x21e0 kernel/sched/core.c:4527
 schedule+0xd0/0x2a0 kernel/sched/core.c:4602
 schedule_timeout+0x1d8/0x250 kernel/time/timer.c:1855
 do_wait_for_common kernel/sched/completion.c:85 [inline]
 __wait_for_common kernel/sched/completion.c:106 [inline]
 wait_for_common kernel/sched/completion.c:117 [inline]
 wait_for_completion+0x163/0x260 kernel/sched/completion.c:138
 __flush_work+0x51f/0xab0 kernel/workqueue.c:3046
 __cancel_work_timer+0x5de/0x700 kernel/workqueue.c:3133
 tls_sk_proto_close+0x4a7/0xaf0 net/tls/tls_main.c:305
 inet_release+0x12e/0x280 net/ipv4/af_inet.c:431
 inet6_release+0x4c/0x70 net/ipv6/af_inet6.c:475
 __sock_release+0xcd/0x280 net/socket.c:596
 sock_close+0x18/0x20 net/socket.c:1277
 __fput+0x285/0x920 fs/file_table.c:281
 task_work_run+0xdd/0x190 kernel/task_work.c:135
 tracehook_notify_resume include/linux/tracehook.h:188 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:139 [inline]
 exit_to_user_mode_prepare+0x195/0x1c0 kernel/entry/common.c:166
 syscall_exit_to_user_mode+0x59/0x2b0 kernel/entry/common.c:241
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x416b81
Code: Bad RIP value.
RSP: 002b:00007ffedaaf5920 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000004 RCX: 0000000000416b81
RDX: 0000000000000000 RSI: 0000000000000be4 RDI: 0000000000000003
RBP: 0000000000000001 R08: 00000000f2ab2be2 R09: 00000000f2ab2be6
R10: 00007ffedaaf5a10 R11: 0000000000000293 R12: 000000000118d940
R13: 000000000118d940 R14: ffffffffffffffff R15: 000000000118cf4c

Showing all locks held in the system:
1 lock held by khungtaskd/1165:
 #0: ffffffff89c66c40 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:5825
1 lock held by in:imklog/6547:
 #0: ffff88809f2578f0 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xe9/0x100 fs/file.c:930
2 locks held by agetty/6565:
 #0: ffff8880a1f98098 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x22/0x80 drivers/tty/tty_ldisc.c:267
 #1: ffffc900025d12e8 (&ldata->atomic_read_lock){+.+.}-{3:3}, at: n_tty_read+0x223/0x1a30 drivers/tty/n_tty.c:2156
3 locks held by kworker/1:3/7601:
 #0: ffff8880aa063d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff8880aa063d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff8880aa063d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff8880aa063d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff8880aa063d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff8880aa063d38 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x82b/0x1670 kernel/workqueue.c:2240
 #1: ffffc90008eb7da8 ((work_completion)(&(&sw_ctx_tx->tx_work.work)->work)){+.+.}-{0:0}, at: process_one_work+0x85f/0x1670 kernel/workqueue.c:2244
 #2: ffff888099161cd8 (&ctx->tx_lock){+.+.}-{3:3}, at: tx_work_handler+0x127/0x190 net/tls/tls_sw.c:2251
1 lock held by syz-executor.3/31922:
 #0: ffff8880a237ae20 (sk_lock-AF_INET6){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1583 [inline]
 #0: ffff8880a237ae20 (sk_lock-AF_INET6){+.+.}-{0:0}, at: sctp_getsockopt net/sctp/socket.c:7820 [inline]
 #0: ffff8880a237ae20 (sk_lock-AF_INET6){+.+.}-{0:0}, at: sctp_getsockopt+0x249/0x6d0a net/sctp/socket.c:7793
1 lock held by syz-executor.4/22039:
 #0: ffff8880855f7210 (&sb->s_type->i_mutex_key#13){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:780 [inline]
 #0: ffff8880855f7210 (&sb->s_type->i_mutex_key#13){+.+.}-{3:3}, at: __sock_release+0x86/0x280 net/socket.c:595

=============================================

NMI backtrace for cpu 0
CPU: 0 PID: 1165 Comm: khungtaskd Not tainted 5.8.0-next-20200814-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 nmi_cpu_backtrace.cold+0x70/0xb1 lib/nmi_backtrace.c:101
 nmi_trigger_cpumask_backtrace+0x1b3/0x223 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:147 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:253 [inline]
 watchdog+0xd89/0xf30 kernel/hung_task.c:339
 kthread+0x3b5/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 PID: 3891 Comm: systemd-journal Not tainted 5.8.0-next-20200814-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0033:0x558c52df8321
Code: 3b 44 24 78 0f 85 de 00 00 00 45 31 ed 45 31 e4 e9 f7 fe ff ff 4c 89 fe 48 8b 5c 24 10 44 89 ed e9 d8 fb ff ff e8 2f 31 ff ff <31> ed e9 1c fd ff ff 4c 8b 64 24 60 4d 85 e4 0f 84 bf 00 00 00 48
RSP: 002b:00007ffc87c71ea0 EFLAGS: 00000246
RAX: 00007ffc87c72780 RBX: 00007ffc87c74910 RCX: 000000000000004e
RDX: 00007ffc87c72781 RSI: 000000000000000a RDI: 00007ffc87c72780
RBP: 00007ffc87c72718 R08: 00007ffc87c72722 R09: 0000000000000000
R10: 0000000000000000 R11: 00007f22fccae040 R12: 0000000000000000
R13: 000000000000004f R14: 0000558c52dfb958 R15: 0005acdcf22a81cb
FS:  00007f22fd9818c0 GS:  0000000000000000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
