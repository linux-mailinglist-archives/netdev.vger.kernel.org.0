Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F11014F1CD
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 19:07:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727258AbgAaSHP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 13:07:15 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:52236 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727228AbgAaSHO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 13:07:14 -0500
Received: by mail-il1-f198.google.com with SMTP id o5so5959324ilg.19
        for <netdev@vger.kernel.org>; Fri, 31 Jan 2020 10:07:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=HHnzxZ2pJpp7EonPSAfrBOKio7gjEtPBgeAVJv4UndQ=;
        b=EYRozFADNz8R66PaEtezc7Hh+vLE257zFsDSpAOa6r+Rfm7XewocYUU6viJDCEcfB6
         Ch1MBK40ccMqCHngawEPRGxTjuYyDg1ZjDlLqKb5y0XISm8ELESUeYkxznpdTV1ZAUzi
         zSO+ESen/HOp8ogT7KUu1W4ymNHKPIuJ4tz81AbVQqRz3S8ATZmsmYDkV9X2II2Luihp
         p700cmVftNGOWyf/1KuQ2YtIZCwqJa3krFUZKP1d4bQJRGHnhPtlzBZbNSDe8VfkCTQb
         H8XKIxSPOFRAI1pmblutO03OIiykaVXBsmKHcdB74/WCGXUo9tnhMIAO+1sKmp8oc7li
         dPYg==
X-Gm-Message-State: APjAAAWzMVQbv+BQruk/GuoJ9sBtPkjllzuA69R1CYt0WPz4WrW9AtyQ
        WeCL8Vvxu1oNhotvTitOSkW8mAAFSaLN3EjOluKxIYc4k1nn
X-Google-Smtp-Source: APXvYqyqHE/w7RhbOxjHmWT7lC622w4bjebXJ6Xvr2xzD2pyAQShq31MY6ltG0SAX/gkONAPLYnkety9lXZDJVSTB46ZHx9yRIWt
MIME-Version: 1.0
X-Received: by 2002:a92:3984:: with SMTP id h4mr10276783ilf.36.1580494033304;
 Fri, 31 Jan 2020 10:07:13 -0800 (PST)
Date:   Fri, 31 Jan 2020 10:07:13 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006cc3d6059d7371ab@google.com>
Subject: INFO: task hung in rxrpc_release
From:   syzbot <syzbot+07d716baf0187672bc35@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dhowells@redhat.com, kuba@kernel.org,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    9f68e365 Merge tag 'drm-next-2020-01-30' of git://anongit...
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=11c8c776e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=95b275782b150c86
dashboard link: https://syzkaller.appspot.com/bug?extid=07d716baf0187672bc35
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+07d716baf0187672bc35@syzkaller.appspotmail.com

INFO: task kworker/u4:7:432 blocked for more than 143 seconds.
      Not tainted 5.5.0-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kworker/u4:7    D26824   432      2 0x80004000
Workqueue: netns cleanup_net
Call Trace:
 context_switch kernel/sched/core.c:3386 [inline]
 __schedule+0x934/0x1f90 kernel/sched/core.c:4082
 schedule+0xdc/0x2b0 kernel/sched/core.c:4156
 schedule_timeout+0x717/0xc50 kernel/time/timer.c:1871
 do_wait_for_common kernel/sched/completion.c:83 [inline]
 __wait_for_common kernel/sched/completion.c:104 [inline]
 wait_for_common kernel/sched/completion.c:115 [inline]
 wait_for_completion+0x29c/0x440 kernel/sched/completion.c:136
 flush_workqueue+0x40a/0x14c0 kernel/workqueue.c:2827
 rxrpc_release_sock net/rxrpc/af_rxrpc.c:898 [inline]
 rxrpc_release+0x2b2/0x5b0 net/rxrpc/af_rxrpc.c:927
 __sock_release+0x1d5/0x280 net/socket.c:605
 sock_release+0x18/0x20 net/socket.c:625
 afs_close_socket+0x1db/0x350 fs/afs/rxrpc.c:128
 afs_net_exit+0x1cd/0x320 fs/afs/main.c:151
 ops_exit_list.isra.0+0xb1/0x160 net/core/net_namespace.c:172
 cleanup_net+0x549/0xb10 net/core/net_namespace.c:589
 process_one_work+0xa05/0x17a0 kernel/workqueue.c:2264
 worker_thread+0x98/0xe40 kernel/workqueue.c:2410
 kthread+0x361/0x430 kernel/kthread.c:255
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
INFO: task syz-executor.4:15978 blocked for more than 143 seconds.
      Not tainted 5.5.0-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor.4  D28240 15978   9813 0x00004004
Call Trace:
 context_switch kernel/sched/core.c:3386 [inline]
 __schedule+0x934/0x1f90 kernel/sched/core.c:4082
 schedule+0xdc/0x2b0 kernel/sched/core.c:4156
 schedule_timeout+0x717/0xc50 kernel/time/timer.c:1871
 do_wait_for_common kernel/sched/completion.c:83 [inline]
 __wait_for_common kernel/sched/completion.c:104 [inline]
 wait_for_common kernel/sched/completion.c:115 [inline]
 wait_for_completion+0x29c/0x440 kernel/sched/completion.c:136
 __flush_work+0x4fe/0xa50 kernel/workqueue.c:3041
 __cancel_work_timer+0x3d9/0x540 kernel/workqueue.c:3128
 cancel_delayed_work_sync+0x1b/0x20 kernel/workqueue.c:3260
 htable_destroy net/netfilter/xt_hashlimit.c:406 [inline]
 htable_put+0x15f/0x220 net/netfilter/xt_hashlimit.c:435
 hashlimit_mt_destroy+0x56/0x70 net/netfilter/xt_hashlimit.c:971
 cleanup_match+0xde/0x170 net/ipv6/netfilter/ip6_tables.c:478
 find_check_entry.isra.0+0x454/0x920 net/ipv4/netfilter/ip_tables.c:564
 translate_table+0xcb4/0x17d0 net/ipv4/netfilter/ip_tables.c:717
 do_replace net/ipv4/netfilter/ip_tables.c:1136 [inline]
 do_ipt_set_ctl+0x2fe/0x4c2 net/ipv4/netfilter/ip_tables.c:1672
 nf_sockopt net/netfilter/nf_sockopt.c:106 [inline]
 nf_setsockopt+0x77/0xd0 net/netfilter/nf_sockopt.c:115
 ip_setsockopt net/ipv4/ip_sockglue.c:1260 [inline]
 ip_setsockopt+0xdf/0x100 net/ipv4/ip_sockglue.c:1240
 tcp_setsockopt net/ipv4/tcp.c:3159 [inline]
 tcp_setsockopt+0x8f/0xe0 net/ipv4/tcp.c:3153
 sock_common_setsockopt+0x94/0xd0 net/core/sock.c:3149
 __sys_setsockopt+0x261/0x4c0 net/socket.c:2130
 __do_sys_setsockopt net/socket.c:2146 [inline]
 __se_sys_setsockopt net/socket.c:2143 [inline]
 __x64_sys_setsockopt+0xbe/0x150 net/socket.c:2143
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x45b349
Code: Bad RIP value.
RSP: 002b:00007f59d07ddc78 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 00007f59d07de6d4 RCX: 000000000045b349
RDX: 0000000000000040 RSI: 0004000000000000 RDI: 0000000000000004
RBP: 000000000075c118 R08: 0000000000000400 R09: 0000000000000000
R10: 0000000020000e00 R11: 0000000000000246 R12: 00000000ffffffff
R13: 0000000000000a02 R14: 00000000004cb5e1 R15: 000000000075c124

Showing all locks held in the system:
4 locks held by kworker/u4:4/218:
 #0: ffff8880ae837558 (&rq->lock){-.-.}, at: rq_lock kernel/sched/sched.h:1215 [inline]
 #0: ffff8880ae837558 (&rq->lock){-.-.}, at: __schedule+0x232/0x1f90 kernel/sched/core.c:4030
 #1: ffffffff89babf40 (rcu_read_lock){....}, at: trace_sched_stat_runtime include/trace/events/sched.h:435 [inline]
 #1: ffffffff89babf40 (rcu_read_lock){....}, at: update_curr+0x2ea/0x8d0 kernel/sched/fair.c:859
 #2: ffff8880ae827418 (&base->lock){-.-.}, at: lock_timer_base+0x56/0x1b0 kernel/time/timer.c:936
 #3: ffffffff8ba6ac60 (&obj_hash[i].lock){-.-.}, at: debug_object_activate+0x131/0x470 lib/debugobjects.c:636
3 locks held by kworker/u4:7/432:
 #0: ffff88821b044128 ((wq_completion)netns){+.+.}, at: __write_once_size include/linux/compiler.h:226 [inline]
 #0: ffff88821b044128 ((wq_completion)netns){+.+.}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff88821b044128 ((wq_completion)netns){+.+.}, at: atomic64_set include/asm-generic/atomic-instrumented.h:855 [inline]
 #0: ffff88821b044128 ((wq_completion)netns){+.+.}, at: atomic_long_set include/asm-generic/atomic-long.h:40 [inline]
 #0: ffff88821b044128 ((wq_completion)netns){+.+.}, at: set_work_data kernel/workqueue.c:615 [inline]
 #0: ffff88821b044128 ((wq_completion)netns){+.+.}, at: set_work_pool_and_clear_pending kernel/workqueue.c:642 [inline]
 #0: ffff88821b044128 ((wq_completion)netns){+.+.}, at: process_one_work+0x8dd/0x17a0 kernel/workqueue.c:2235
 #1: ffffc90002677dc0 (net_cleanup_work){+.+.}, at: process_one_work+0x917/0x17a0 kernel/workqueue.c:2239
 #2: ffffffff8a727fc8 (pernet_ops_rwsem){++++}, at: cleanup_net+0xa1/0xb10 net/core/net_namespace.c:551
1 lock held by khungtaskd/1107:
 #0: ffffffff89babf40 (rcu_read_lock){....}, at: debug_show_all_locks+0x5f/0x279 kernel/locking/lockdep.c:5333
1 lock held by khugepaged/1139:
 #0: ffffffff89c50fe0 (pcpu_drain_mutex){+.+.}, at: drain_all_pages+0x4d/0x5d0 mm/page_alloc.c:2902
1 lock held by rsyslogd/9673:
 #0: ffff8880879e3860 (&f->f_pos_lock){+.+.}, at: __fdget_pos+0xee/0x110 fs/file.c:821
2 locks held by getty/9763:
 #0: ffff88809dec3090 (&tty->ldisc_sem){++++}, at: ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
 #1: ffffc9000191f2e0 (&ldata->atomic_read_lock){+.+.}, at: n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
2 locks held by getty/9764:
 #0: ffff88809ee49090 (&tty->ldisc_sem){++++}, at: ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
 #1: ffffc9000199b2e0 (&ldata->atomic_read_lock){+.+.}, at: n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
2 locks held by getty/9765:
 #0: ffff8880a20dd090 (&tty->ldisc_sem){++++}, at: ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
 #1: ffffc9000197b2e0 (&ldata->atomic_read_lock){+.+.}, at: n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
2 locks held by getty/9766:
 #0: ffff888091b8a090 (&tty->ldisc_sem){++++}, at: ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
 #1: ffffc9000198b2e0 (&ldata->atomic_read_lock){+.+.}, at: n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
2 locks held by getty/9767:
 #0: ffff88809ee41090 (&tty->ldisc_sem){++++}, at: ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
 #1: ffffc900019ab2e0 (&ldata->atomic_read_lock){+.+.}, at: n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
2 locks held by getty/9768:
 #0: ffff88809fd08090 (&tty->ldisc_sem){++++}, at: ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
 #1: ffffc900019232e0 (&ldata->atomic_read_lock){+.+.}, at: n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
2 locks held by getty/9769:
 #0: ffff888092172090 (&tty->ldisc_sem){++++}, at: ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
 #1: ffffc900018fb2e0 (&ldata->atomic_read_lock){+.+.}, at: n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
1 lock held by syz-executor.4/15978:
 #0: ffffffff8a7b80a0 (hashlimit_mutex){+.+.}, at: htable_put+0x21/0x220 net/netfilter/xt_hashlimit.c:432
2 locks held by kworker/0:3/16041:

=============================================

NMI backtrace for cpu 1
CPU: 1 PID: 1107 Comm: khungtaskd Not tainted 5.5.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x197/0x210 lib/dump_stack.c:118
 nmi_cpu_backtrace.cold+0x70/0xb2 lib/nmi_backtrace.c:101
 nmi_trigger_cpumask_backtrace+0x23b/0x28b lib/nmi_backtrace.c:62
 arch_trigger_cpumask_backtrace+0x14/0x20 arch/x86/kernel/apic/hw_nmi.c:38
 trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:205 [inline]
 watchdog+0xb11/0x10c0 kernel/hung_task.c:289
 kthread+0x361/0x430 kernel/kthread.c:255
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 PID: 16041 Comm: kworker/0:3 Not tainted 5.5.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events_power_efficient htable_gc
RIP: 0010:lock_is_held_type+0x27e/0x320 kernel/locking/lockdep.c:4526
Code: 48 c1 e8 03 80 3c 10 00 0f 85 88 00 00 00 48 83 3d 0e 3a 59 08 00 74 31 48 8b 7d c0 57 9d 0f 1f 44 00 00 48 83 c4 20 44 89 e0 <5b> 41 5c 41 5d 41 5e 41 5f 5d c3 45 31 e4 e9 6e ff ff ff 41 bc 01
RSP: 0018:ffffc9000194fc38 EFLAGS: 00000282
RAX: 0000000000000000 RBX: ffff88805ad1a000 RCX: ffff88805ad1a898
RDX: dffffc0000000000 RSI: ffffffff89babec0 RDI: 0000000000000286
RBP: ffffc9000194fc60 R08: 1ffffffff169f59e R09: fffffbfff169f59f
R10: fffffbfff169f59e R11: ffffffff8b4facf7 R12: 0000000000000000
R13: ffff88805ad1a8c0 R14: ffffffff89babec0 R15: 0000000000000002
FS:  0000000000000000(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f59d08209e0 CR3: 000000008df0d000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 lock_is_held include/linux/lockdep.h:361 [inline]
 ___might_sleep+0x205/0x2c0 kernel/sched/core.c:6765
 htable_selective_cleanup+0x245/0x340 net/netfilter/xt_hashlimit.c:374
 htable_gc+0x21/0xb0 net/netfilter/xt_hashlimit.c:384
 process_one_work+0xa05/0x17a0 kernel/workqueue.c:2264
 worker_thread+0x98/0xe40 kernel/workqueue.c:2410
 kthread+0x361/0x430 kernel/kthread.c:255
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
