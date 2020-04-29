Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75FC81BD8F1
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 11:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbgD2J7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 05:59:17 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:41599 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726423AbgD2J7Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 05:59:16 -0400
Received: by mail-il1-f198.google.com with SMTP id y2so1928559ilm.8
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 02:59:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=rBtCDC/1aj7/RN6lVwFtyJy8v88lLptWko+azv2s6gw=;
        b=lP5ScPJKhkSVQfx7QTtKncu0vpzxMwlgePRaopdyTSln39Y16oW/EqF3S4E0liGsfL
         kPPgsTDwke5bQfD78EB/TfY0vEVY5OzMvDOTN5oogT5yg4RKK2mzFjb5N3a5JyN8WJ+v
         +5nfrxj/K6e7YhtQXoDfY4M52Ns3D2Z9H6T47ut90YmrssnGDIb8ZdHwIOemM9NyReIt
         YNUTo1KkjjjjIw6/vpibW0mP10kb15pMtjGCqVptRW6qZ9IQCAU6nsxdx8n1y8GUSKwk
         eKM0sgucd3kNt5+yM0yeqFdk02t9lhNzS1XKBvcTlNsOhJM3O/CGjytR/HPaHr9M6d3g
         vvTA==
X-Gm-Message-State: AGi0PuaK8jLzand97RbDo/4uCQuGZSa6rVGXJ501XaBgQXaA3aeweuEm
        QePGgqQ78H6z3P/iP3ETNw5H604lE6biH9/ec6vkbIgp6Ssh
X-Google-Smtp-Source: APiQypKEYyGbpU2BJsquRe8gsjMCxM+f3Dk4ay0KO+A8qe79qhFzzM3dTfIBmL5dFBMGoTGw4Lm8FvifMenIyYz+Z2E831pqQ56E
MIME-Version: 1.0
X-Received: by 2002:a92:9a97:: with SMTP id c23mr29948979ill.7.1588154353545;
 Wed, 29 Apr 2020 02:59:13 -0700 (PDT)
Date:   Wed, 29 Apr 2020 02:59:13 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001779fd05a46b001f@google.com>
Subject: INFO: task hung in linkwatch_event (2)
From:   syzbot <syzbot+96ff6cfc4551fcc29342@syzkaller.appspotmail.com>
To:     allison@lohutok.net, aviad.krawczyk@huawei.com, axboe@kernel.dk,
        davem@davemloft.net, gregkh@linuxfoundation.org,
        io-uring@vger.kernel.org, kuba@kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linyunsheng@huawei.com, luobin9@huawei.com, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    b4f63322 Merge branch 'for-linus' of git://git.kernel.org/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1558936fe00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b7a70e992f2f9b68
dashboard link: https://syzkaller.appspot.com/bug?extid=96ff6cfc4551fcc29342
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14a57828100000

The bug was bisected to:

commit 386d4716fd91869e07c731657f2cde5a33086516
Author: Luo bin <luobin9@huawei.com>
Date:   Thu Feb 27 06:34:44 2020 +0000

    hinic: fix a bug of rss configuration

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16626fcfe00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=15626fcfe00000
console output: https://syzkaller.appspot.com/x/log.txt?x=11626fcfe00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+96ff6cfc4551fcc29342@syzkaller.appspotmail.com
Fixes: 386d4716fd91 ("hinic: fix a bug of rss configuration")

INFO: task kworker/1:5:2724 blocked for more than 143 seconds.
      Not tainted 5.7.0-rc2-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kworker/1:5     D27416  2724      2 0x80004000
Workqueue: events linkwatch_event
Call Trace:
 schedule+0xd0/0x2a0 kernel/sched/core.c:4163
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:4222
 __mutex_lock_common kernel/locking/mutex.c:1033 [inline]
 __mutex_lock+0x7ab/0x13c0 kernel/locking/mutex.c:1103
 linkwatch_event+0xb/0x60 net/core/link_watch.c:242
 process_one_work+0x965/0x16a0 kernel/workqueue.c:2268
 worker_thread+0x96/0xe20 kernel/workqueue.c:2414
 kthread+0x388/0x470 kernel/kthread.c:268
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
INFO: task syz-executor.0:7053 blocked for more than 143 seconds.
      Not tainted 5.7.0-rc2-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor.0  D23512  7053      1 0x80004006
Call Trace:
 schedule+0xd0/0x2a0 kernel/sched/core.c:4163
 schedule_timeout+0x55b/0x850 kernel/time/timer.c:1874
 do_wait_for_common kernel/sched/completion.c:85 [inline]
 __wait_for_common kernel/sched/completion.c:106 [inline]
 wait_for_common kernel/sched/completion.c:117 [inline]
 wait_for_completion+0x16a/0x270 kernel/sched/completion.c:138
 __flush_work+0x4fd/0xa80 kernel/workqueue.c:3045
 flush_all_backlogs net/core/dev.c:5527 [inline]
 rollback_registered_many+0x562/0xe70 net/core/dev.c:8813
 rollback_registered+0xf2/0x1c0 net/core/dev.c:8873
 unregister_netdevice_queue net/core/dev.c:9969 [inline]
 unregister_netdevice_queue+0x1d7/0x2b0 net/core/dev.c:9962
 unregister_netdevice include/linux/netdevice.h:2725 [inline]
 __tun_detach+0xe42/0x1110 drivers/net/tun.c:690
 tun_detach drivers/net/tun.c:707 [inline]
 tun_chr_close+0xd9/0x180 drivers/net/tun.c:3413
 __fput+0x33e/0x880 fs/file_table.c:280
 task_work_run+0xf4/0x1b0 kernel/task_work.c:123
 exit_task_work include/linux/task_work.h:22 [inline]
 do_exit+0xb34/0x2dd0 kernel/exit.c:795
 do_group_exit+0x125/0x340 kernel/exit.c:893
 get_signal+0x47b/0x24e0 kernel/signal.c:2739
 do_signal+0x81/0x2240 arch/x86/kernel/signal.c:784
 exit_to_usermode_loop+0x26c/0x360 arch/x86/entry/common.c:161
 prepare_exit_to_usermode arch/x86/entry/common.c:196 [inline]
 syscall_return_slowpath arch/x86/entry/common.c:279 [inline]
 do_syscall_64+0x6b1/0x7d0 arch/x86/entry/common.c:305
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x4166ca
Code: Bad RIP value.
RSP: 002b:00007ffd4022d478 EFLAGS: 00000246 ORIG_RAX: 000000000000003d
RAX: fffffffffffffe00 RBX: 0000000001d60940 RCX: 00000000004166ca
RDX: 0000000040000000 RSI: 00007ffd4022d4b0 RDI: ffffffffffffffff
RBP: 0000000000002996 R08: 0000000000000001 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000003
R13: 00007ffd4022d4b0 R14: 0000000001d6099b R15: 00007ffd4022d4c0

Showing all locks held in the system:
1 lock held by khungtaskd/1125:
 #0: ffffffff899beb00 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:5754
3 locks held by kworker/1:5/2724:
 #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: __write_once_size include/linux/compiler.h:226 [inline]
 #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:855 [inline]
 #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:40 [inline]
 #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:615 [inline]
 #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:642 [inline]
 #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x844/0x16a0 kernel/workqueue.c:2239
 #1: ffffc90008367dc0 ((linkwatch_work).work){+.+.}-{0:0}, at: process_one_work+0x878/0x16a0 kernel/workqueue.c:2243
 #2: ffffffff8a582268 (rtnl_mutex){+.+.}-{3:3}, at: linkwatch_event+0xb/0x60 net/core/link_watch.c:242
1 lock held by in:imklog/6717:
 #0: ffff888098d271b0 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xe9/0x100 fs/file.c:826
2 locks held by syz-executor.0/7053:
 #0: ffffffff8a582268 (rtnl_mutex){+.+.}-{3:3}, at: tun_detach drivers/net/tun.c:704 [inline]
 #0: ffffffff8a582268 (rtnl_mutex){+.+.}-{3:3}, at: tun_chr_close+0x3a/0x180 drivers/net/tun.c:3413
 #1: ffffffff89979ad0 (cpu_hotplug_lock){++++}-{0:0}, at: get_online_cpus include/linux/cpu.h:143 [inline]
 #1: ffffffff89979ad0 (cpu_hotplug_lock){++++}-{0:0}, at: flush_all_backlogs net/core/dev.c:5520 [inline]
 #1: ffffffff89979ad0 (cpu_hotplug_lock){++++}-{0:0}, at: rollback_registered_many+0x45b/0xe70 net/core/dev.c:8813
3 locks held by kworker/1:6/14336:
 #0: ffff88809ace8d38 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: __write_once_size include/linux/compiler.h:226 [inline]
 #0: ffff88809ace8d38 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff88809ace8d38 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:855 [inline]
 #0: ffff88809ace8d38 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:40 [inline]
 #0: ffff88809ace8d38 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:615 [inline]
 #0: ffff88809ace8d38 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:642 [inline]
 #0: ffff88809ace8d38 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: process_one_work+0x844/0x16a0 kernel/workqueue.c:2239
 #1: ffffc90004637dc0 ((addr_chk_work).work){+.+.}-{0:0}, at: process_one_work+0x878/0x16a0 kernel/workqueue.c:2243
 #2: ffffffff8a582268 (rtnl_mutex){+.+.}-{3:3}, at: addrconf_verify_work+0xa/0x20 net/ipv6/addrconf.c:4584

=============================================

NMI backtrace for cpu 1
CPU: 1 PID: 1125 Comm: khungtaskd Not tainted 5.7.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 nmi_cpu_backtrace.cold+0x70/0xb1 lib/nmi_backtrace.c:101
 nmi_trigger_cpumask_backtrace+0x231/0x27e lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:205 [inline]
 watchdog+0xa8c/0x1010 kernel/hung_task.c:289
 kthread+0x388/0x470 kernel/kthread.c:268
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 PID: 28894 Comm: syz-executor.0 Not tainted 5.7.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:io_ring_ctx_wait_and_kill+0x98/0x5e0 fs/io_uring.c:7329
Code: 01 00 00 4d 89 f4 48 b8 00 00 00 00 00 fc ff df 4c 89 ed 49 c1 ec 03 48 c1 ed 03 49 01 c4 48 01 c5 eb 1c e8 6a f2 9d ff f3 90 <41> 80 3c 24 00 0f 85 b0 04 00 00 48 83 bb 10 01 00 00 00 74 21 e8
RSP: 0018:ffffc90004e17a48 EFLAGS: 00000293
RAX: ffff888091758480 RBX: ffff888094860000 RCX: 1ffff920009c2f36
RDX: 0000000000000000 RSI: ffffffff81d53c26 RDI: ffff888094860300
RBP: ffffed101290c02c R08: 0000000000000001 R09: ffffed101290c061
R10: ffff888094860307 R11: ffffed101290c060 R12: ffffed101290c022
R13: ffff888094860160 R14: ffff888094860110 R15: ffffffff81d54170
FS:  00007fac6c1a8700(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000560ad6a654a7 CR3: 0000000009879000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 io_uring_release+0x3e/0x50 fs/io_uring.c:7352
 __fput+0x33e/0x880 fs/file_table.c:280
 task_work_run+0xf4/0x1b0 kernel/task_work.c:123
 exit_task_work include/linux/task_work.h:22 [inline]
 do_exit+0xb34/0x2dd0 kernel/exit.c:795
 do_group_exit+0x125/0x340 kernel/exit.c:893
 get_signal+0x47b/0x24e0 kernel/signal.c:2739
 do_signal+0x81/0x2240 arch/x86/kernel/signal.c:784
 exit_to_usermode_loop+0x26c/0x360 arch/x86/entry/common.c:161
 prepare_exit_to_usermode arch/x86/entry/common.c:196 [inline]
 syscall_return_slowpath arch/x86/entry/common.c:279 [inline]
 do_syscall_64+0x6b1/0x7d0 arch/x86/entry/common.c:305
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x45c829
Code: Bad RIP value.
RSP: 002b:00007fac6c1a7c78 EFLAGS: 00000246 ORIG_RAX: 00000000000001a9
RAX: 0000000000000003 RBX: 00000000004e0bc0 RCX: 000000000045c829
RDX: 0000000000000000 RSI: 0000000020000580 RDI: 00000000000000f1
RBP: 000000000078bf00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 0000000000000204 R14: 00000000004c425f R15: 00007fac6c1a86d4


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
