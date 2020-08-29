Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABAC2256501
	for <lists+netdev@lfdr.de>; Sat, 29 Aug 2020 08:19:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbgH2GJW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Aug 2020 02:09:22 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:50455 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbgH2GJV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Aug 2020 02:09:21 -0400
Received: by mail-il1-f197.google.com with SMTP id v15so931607ilm.17
        for <netdev@vger.kernel.org>; Fri, 28 Aug 2020 23:09:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=/7VXp0tP8F9WGxY+yGGRP+vowS31sIWVt3YL5Y7ETAA=;
        b=NIj325a6Yuvwt4GEX3hRzWNMn6FaUfdkro0gzEKLNMPJJrF8NZj8xH5D/k4cFdXQnA
         QD+C26gVWWPKgPB04q6Dp0j7mVzMK1OZFtnv4R9JEB0KA7oI7KIbT/fHfclcbDwF379e
         8ucVqgNV7Q7Jt/LMwWTROuHb+xebeeSYtnDVK1qdN9JdawX8QePGPF7O3bXbJHIPQgcC
         SPF+hRLEc0srFbj22pwiHv8v8tMX4xFYaw2V4llPMJh5sOB2jz4bM+OU67xrXHBG5MZl
         /BH793raRMFEvDuoAHaLr9l/8lXy/QHtwEC8Q5mv6Xu9p30l3CzwELIcJEBgcAswUjTH
         djqg==
X-Gm-Message-State: AOAM533iJTuVt/AxQSKRNRLPD7fCl7fYx2bFRB4v6cz7XfZbKeg9MMcE
        F2X0fcn4f6NZ7Rtj4OFIrbjUh9VSUtZ1l39mzMlWvCGyZW8p
X-Google-Smtp-Source: ABdhPJyemNPQ0VuZjfRt+FM355hDuF5VxMjHNSnkDS43XBOdma7xzgDy6dRiSseq2OH0IXVoLhyWuDVYWYcXP0SBcJNCADpqPkC6
MIME-Version: 1.0
X-Received: by 2002:a92:ce07:: with SMTP id b7mr1803689ilo.270.1598681360107;
 Fri, 28 Aug 2020 23:09:20 -0700 (PDT)
Date:   Fri, 28 Aug 2020 23:09:20 -0700
In-Reply-To: <000000000000d3d67f05a20d2027@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000940fbe05adfe0208@google.com>
Subject: Re: INFO: task hung in tls_sk_proto_close
From:   syzbot <syzbot+ca1345cca66556f3d79b@syzkaller.appspotmail.com>
To:     aviadye@mellanox.com, aviadye@nvidia.com, borisp@mellanox.com,
        borisp@nvidia.com, daniel@iogearbox.net, davem@davemloft.net,
        john.fastabend@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    b36c9697 Add linux-next specific files for 20200828
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=11ae3d61900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5e3cf99580b5542c
dashboard link: https://syzkaller.appspot.com/bug?extid=ca1345cca66556f3d79b
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=170cdfe5900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=139a768e900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ca1345cca66556f3d79b@syzkaller.appspotmail.com

INFO: task syz-executor014:6815 blocked for more than 143 seconds.
      Not tainted 5.9.0-rc2-next-20200828-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor014 state:D stack:23536 pid: 6815 ppid:  6814 flags:0x00004000
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
 task_work_run+0xdd/0x190 kernel/task_work.c:141
 tracehook_notify_resume include/linux/tracehook.h:188 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:140 [inline]
 exit_to_user_mode_prepare+0x195/0x1c0 kernel/entry/common.c:167
 syscall_exit_to_user_mode+0x59/0x2b0 kernel/entry/common.c:242
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x403950
Code: Bad RIP value.
RSP: 002b:00007fff6bd1cf98 EFLAGS: 00000246 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000005 RCX: 0000000000403950
RDX: 00000000000000d8 RSI: 00000000200005c0 RDI: 0000000000000004
RBP: 00007fff6bd1cfa0 R08: 0000000000000000 R09: 00000000000000d8
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fff6bd1cfb0
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000

Showing all locks held in the system:
4 locks held by kworker/u4:0/7:
1 lock held by khungtaskd/1167:
 #0: ffffffff89c67640 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:5825
1 lock held by in:imklog/6517:
 #0: ffff8880a8b1c930 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xe9/0x100 fs/file.c:930
1 lock held by syz-executor014/6815:
 #0: ffff888085128750 (&sb->s_type->i_mutex_key#13){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:779 [inline]
 #0: ffff888085128750 (&sb->s_type->i_mutex_key#13){+.+.}-{3:3}, at: __sock_release+0x86/0x280 net/socket.c:595
3 locks held by kworker/0:3/7021:
 #0: ffff8880aa063d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff8880aa063d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff8880aa063d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff8880aa063d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff8880aa063d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff8880aa063d38 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x82b/0x1670 kernel/workqueue.c:2240
 #1: ffffc90006137da8 ((work_completion)(&(&sw_ctx_tx->tx_work.work)->work)){+.+.}-{0:0}, at: process_one_work+0x85f/0x1670 kernel/workqueue.c:2244
 #2: ffff88809dc300d8 (&ctx->tx_lock){+.+.}-{3:3}, at: tx_work_handler+0x127/0x190 net/tls/tls_sw.c:2251

=============================================

NMI backtrace for cpu 0
CPU: 0 PID: 1167 Comm: khungtaskd Not tainted 5.9.0-rc2-next-20200828-syzkaller #0
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
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 PID: 3893 Comm: systemd-journal Not tainted 5.9.0-rc2-next-20200828-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__read_seqcount_t_begin include/linux/seqlock.h:276 [inline]
RIP: 0010:path_init+0x1d1/0x13c0 fs/namei.c:2218
Code: 24 40 48 b8 00 00 00 00 00 fc ff df 4c 89 f2 48 c1 ea 03 0f b6 04 02 84 c0 74 08 3c 03 0f 8e 73 0e 00 00 44 8b 2d cf 44 de 07 <31> ff 45 89 ef 41 83 e7 01 44 89 fe e8 4e 87 b1 ff 45 84 ff 0f 85
RSP: 0018:ffffc900052f7a48 EFLAGS: 00000246
RAX: 0000000000000000 RBX: 0000000000000040 RCX: ffffffff81c2f109
RDX: 1ffffffff13426c8 RSI: ffffffff81c2f117 RDI: ffffc900052f7c98
RBP: ffffc900052f7ae8 R08: 0000000000000000 R09: ffffffff8c6a59e7
R10: 0000000000000000 R11: 0000000000000000 R12: ffffc900052f7c58
R13: 0000000000001444 R14: ffffffff89a13640 R15: 0000000000000000
FS:  00007fcc879848c0(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fcc84d25000 CR3: 0000000094282000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 path_openat+0x185/0x2730 fs/namei.c:3363
 do_filp_open+0x17e/0x3c0 fs/namei.c:3395
 do_sys_openat2+0x16d/0x420 fs/open.c:1168
 do_sys_open fs/open.c:1184 [inline]
 __do_sys_open fs/open.c:1192 [inline]
 __se_sys_open fs/open.c:1188 [inline]
 __x64_sys_open+0x119/0x1c0 fs/open.c:1188
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7fcc86f14840
Code: 73 01 c3 48 8b 0d 68 77 20 00 f7 d8 64 89 01 48 83 c8 ff c3 66 0f 1f 44 00 00 83 3d 89 bb 20 00 00 75 10 b8 02 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 31 c3 48 83 ec 08 e8 1e f6 ff ff 48 89 04 24
RSP: 002b:00007ffe226b7b58 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
RAX: ffffffffffffffda RBX: 00007ffe226b7e60 RCX: 00007fcc86f14840
RDX: 00000000000001a0 RSI: 0000000000080042 RDI: 0000563cfc995a50
RBP: 000000000000000d R08: 000000000000c0ff R09: 00000000ffffffff
R10: 0000000000000069 R11: 0000000000000246 R12: 00000000ffffffff
R13: 0000563cfc989040 R14: 00007ffe226b7e20 R15: 0000563cfc995820

