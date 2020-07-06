Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA9FE215A69
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 17:13:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729473AbgGFPMx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 11:12:53 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:50405 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729329AbgGFPMZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 11:12:25 -0400
Received: by mail-il1-f198.google.com with SMTP id l17so28045622ilj.17
        for <netdev@vger.kernel.org>; Mon, 06 Jul 2020 08:12:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=hyeaJTylkqD9hhiRD1x9Nh4wEJMt0NUu/uugBm1Y8f4=;
        b=ukuft8wGM8I0QnbOQYHwvRAjfpecy2QAMCx17ARWcOtYRf0Hul8Gbf/qP/qva9PN7z
         JB2oJ8+OG69OGtnYgQCXgBD8zzIdSmdEN/h/+OuSTngtNWonqN2WHE7yGrODz9nD9ELW
         KJYNarBFmc3iHkJ2UO44e4lgY7bObyEDoAedp222qIwt6BHiWFwGf/SfsR00TzeHYZ6P
         biElyYa25WUcwj8YltocyGCIOE/P7brHdkE/XI0QU4U6LUOfuZbGjfNgYOfpMO7jA38T
         d6ianPSgq1KSzltZoWpMIYZlsZPO0tx+9lyfCeJB8BmLiP3J3Fk0nSVmSF0TAs73l4Fc
         i38g==
X-Gm-Message-State: AOAM53181b9ME0rWxZuyFW/C22AqPv0PYJfnyX7+bh+2jn5QeZdDukrG
        FUWyk5wm7LbRecZKkcqnMlVl4gsjAJHScDXPONwMFVoPyBig
X-Google-Smtp-Source: ABdhPJy9CerZaSSQ83MwUtuQx3LJg8IK3NlZ9OWlyyK94Zf3N09vXb2BlHrcuOdMhIiFJFAHovmo1xIn/4uuU2BZ/Lhk9HRrL9T2
MIME-Version: 1.0
X-Received: by 2002:a5e:9309:: with SMTP id k9mr25400736iom.135.1594048343819;
 Mon, 06 Jul 2020 08:12:23 -0700 (PDT)
Date:   Mon, 06 Jul 2020 08:12:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000049cb9905a9c74dfb@google.com>
Subject: INFO: task hung in __sock_release
From:   syzbot <syzbot+d12405ae80a8acdf5a9d@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    423b8baf Merge branch 'akpm' (patches from Andrew)
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=109ad97e100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b3368ce0cc5f5ace
dashboard link: https://syzkaller.appspot.com/bug?extid=d12405ae80a8acdf5a9d
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+d12405ae80a8acdf5a9d@syzkaller.appspotmail.com

INFO: task syz-executor.1:4415 blocked for more than 143 seconds.
      Not tainted 5.7.0-rc6-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor.1  D26032  4415   7163 0x80004006
Call Trace:
 context_switch kernel/sched/core.c:3367 [inline]
 __schedule+0x937/0x1ff0 kernel/sched/core.c:4083
 rwsem_down_write_slowpath+0x90a/0xf90 kernel/locking/rwsem.c:1216
 __sched_text_start+0x8/0x8
 schedule+0xd0/0x2a0 kernel/sched/core.c:4158
 rwsem_down_write_slowpath+0x706/0xf90 kernel/locking/rwsem.c:1235
 rwsem_mark_wake+0x8d0/0x8d0 include/linux/compiler.h:199
 lock_acquire+0x1f2/0x8f0 kernel/locking/lockdep.c:4934
 unregister_netdevice_notifier+0x1e/0x170 net/core/dev.c:1776
 lock_release+0x800/0x800 kernel/locking/lockdep.c:4689
 __sock_release+0x280/0x280 net/socket.c:605
 __down_write kernel/locking/rwsem.c:1389 [inline]
 down_write+0x137/0x150 kernel/locking/rwsem.c:1532
 atomic64_try_cmpxchg include/asm-generic/atomic-instrumented.h:1504 [inline]
 atomic_long_try_cmpxchg_acquire include/asm-generic/atomic-long.h:442 [inline]
 __down_write kernel/locking/rwsem.c:1387 [inline]
 down_write+0xb2/0x150 kernel/locking/rwsem.c:1532
 __down_write kernel/locking/rwsem.c:1389 [inline]
 down_write+0x137/0x150 kernel/locking/rwsem.c:1532
 __down_timeout+0x2d0/0x2d0
 unregister_netdevice_notifier+0x1e/0x170 net/core/dev.c:1776
 __sock_release+0x280/0x280 net/socket.c:605
 raw_release+0x53/0x730 net/can/raw.c:354
 fcntl_setlk+0xcc0/0xcc0 fs/locks.c:2542
 __sock_release+0x280/0x280 net/socket.c:605
 __sock_release+0xcd/0x280 net/socket.c:605
 sock_close+0x18/0x20 net/socket.c:1283
 __fput+0x33e/0x880 fs/file_table.c:280
 task_work_run+0xf4/0x1b0 kernel/task_work.c:123
 exit_task_work include/linux/task_work.h:22 [inline]
 do_exit+0xb34/0x2dd0 kernel/exit.c:796
 find_held_lock+0x2d/0x110 kernel/locking/lockdep.c:4458
 mm_update_next_owner+0x7a0/0x7a0 kernel/exit.c:375
 lock_downgrade+0x840/0x840 kernel/locking/lockdep.c:4579
 do_group_exit+0x125/0x340 kernel/exit.c:894
 get_signal+0x47b/0x24e0 kernel/signal.c:2739
 find_held_lock+0x2d/0x110 kernel/locking/lockdep.c:4458
 do_signal+0x81/0x2240 arch/x86/kernel/signal.c:784
 lock_downgrade+0x840/0x840 kernel/locking/lockdep.c:4579
 rcu_read_lock_any_held.part.0+0x50/0x50 arch/x86/include/asm/paravirt.h:754
 get_sigframe.isra.0+0x730/0x730 arch/x86/kernel/signal.c:268
 rcu_read_unlock_sched include/linux/rcupdate.h:732 [inline]
 __fd_install+0x1e6/0x600 fs/file.c:613
 __sys_socket+0x16d/0x200 net/socket.c:438
 move_addr_to_kernel+0x70/0x70 net/socket.c:195
 exit_to_usermode_loop+0x26c/0x360 arch/x86/entry/common.c:161
 prepare_exit_to_usermode arch/x86/entry/common.c:196 [inline]
 syscall_return_slowpath arch/x86/entry/common.c:279 [inline]
 do_syscall_64+0x6b1/0x7d0 arch/x86/entry/common.c:305
 entry_SYSCALL_64_after_hwframe+0x49/0xb3

Showing all locks held in the system:
5 locks held by kworker/u4:4/211:
1 lock held by khungtaskd/1143:
 #0: ffffffff899bea80 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:5754
1 lock held by in:imklog/6724:
 #0: ffff888092f98af0 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xe9/0x100 fs/file.c:826
3 locks held by kworker/u4:5/11846:
 #0: ffff8880a9771938 ((wq_completion)netns){+.+.}-{0:0}, at: __write_once_size include/linux/compiler.h:226 [inline]
 #0: ffff8880a9771938 ((wq_completion)netns){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff8880a9771938 ((wq_completion)netns){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:855 [inline]
 #0: ffff8880a9771938 ((wq_completion)netns){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:40 [inline]
 #0: ffff8880a9771938 ((wq_completion)netns){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:615 [inline]
 #0: ffff8880a9771938 ((wq_completion)netns){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:642 [inline]
 #0: ffff8880a9771938 ((wq_completion)netns){+.+.}-{0:0}, at: process_one_work+0x844/0x16a0 kernel/workqueue.c:2239
 #1: ffffc900153dfdc0 (net_cleanup_work){+.+.}-{0:0}, at: process_one_work+0x878/0x16a0 kernel/workqueue.c:2243
 #2: ffffffff8a57aaf0 (pernet_ops_rwsem){++++}-{3:3}, at: cleanup_net+0x9b/0xa50 net/core/net_namespace.c:565
2 locks held by syz-executor.1/4415:
 #0: ffff88803f15e750 (&sb->s_type->i_mutex_key#14){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:797 [inline]
 #0: ffff88803f15e750 (&sb->s_type->i_mutex_key#14){+.+.}-{3:3}, at: __sock_release+0x86/0x280 net/socket.c:604
 #1: ffffffff8a57aaf0 (pernet_ops_rwsem){++++}-{3:3}, at: unregister_netdevice_notifier+0x1e/0x170 net/core/dev.c:1776

=============================================

NMI backtrace for cpu 1
CPU: 1 PID: 1143 Comm: khungtaskd Not tainted 5.7.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 nmi_cpu_backtrace.cold+0x70/0xb1 lib/nmi_backtrace.c:101
 lapic_can_unplug_cpu.cold+0x3b/0x3b
 nmi_trigger_cpumask_backtrace+0x231/0x27e lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:205 [inline]
 watchdog+0xa8c/0x1010 kernel/hung_task.c:289
 reset_hung_task_detector+0x30/0x30 kernel/hung_task.c:243
 kthread+0x388/0x470 kernel/kthread.c:268
 kthread_mod_delayed_work+0x1a0/0x1a0 kernel/kthread.c:1090
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:351
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 PID: 17188 Comm: kworker/u4:6 Not tainted 5.7.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: bat_events batadv_nc_worker
RIP: 0010:lock_release+0x2f/0x800 kernel/locking/lockdep.c:4942
Code: 00 00 fc ff df 41 57 41 56 41 55 49 89 f5 41 54 49 89 fc 55 53 48 81 ec 98 00 00 00 48 c7 44 24 18 b3 8a b5 41 48 8d 5c 24 18 <48> c7 44 24 20 e8 c6 47 89 48 c1 eb 03 48 c7 44 24 28 40 7f 59 81
RSP: 0018:ffffc9000727fc00 EFLAGS: 00000286
RAX: ffff88809e2c4000 RBX: ffffc9000727fc18 RCX: ffffffff87b70337
RDX: dffffc0000000000 RSI: ffffffff87b700a6 RDI: ffffffff899bea80
RBP: ffff888051de4c00 R08: ffff88809e2c4000 R09: ffffed1015cc7104
R10: ffff8880ae63881b R11: ffffed1015cc7103 R12: ffffffff899bea80
R13: ffffffff87b700a6 R14: dffffc0000000000 R15: 0000000000000001
FS:  0000000000000000(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000c0007bf6c0 CR3: 00000000a8637000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 lock_release+0x800/0x800 kernel/locking/lockdep.c:4689
 process_one_work+0x878/0x16a0 kernel/workqueue.c:2243
 lock_downgrade+0x840/0x840 kernel/locking/lockdep.c:4579
 rcu_lock_release include/linux/rcupdate.h:213 [inline]
 rcu_read_unlock include/linux/rcupdate.h:655 [inline]
 batadv_nc_purge_orig_hash net/batman-adv/network-coding.c:411 [inline]
 batadv_nc_worker+0x21c/0x760 net/batman-adv/network-coding.c:718
 process_one_work+0x965/0x16a0 kernel/workqueue.c:2268
 lock_release+0x800/0x800 kernel/locking/lockdep.c:4689
 pwq_dec_nr_in_flight+0x310/0x310 kernel/workqueue.c:1198
 rwlock_bug.part.0+0x90/0x90 include/linux/sched.h:1329
 worker_thread+0x96/0xe20 kernel/workqueue.c:2414
 process_one_work+0x16a0/0x16a0 kernel/workqueue.c:2273
 kthread+0x388/0x470 kernel/kthread.c:268
 kthread_mod_delayed_work+0x1a0/0x1a0 kernel/kthread.c:1090
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:351


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
