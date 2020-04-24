Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1F931B6D0A
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 07:15:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726295AbgDXFPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 01:15:19 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:47886 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725919AbgDXFPS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 01:15:18 -0400
Received: by mail-io1-f71.google.com with SMTP id v23so8946146ioj.14
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 22:15:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=GsHJhhlI69iEbus5Kx/hbxlTWBhT5w75wH6LGF6jvQc=;
        b=BMfHdBI2jy3CWBvb4Hp1eNs8sgQJC5VehJ359pCEoo+hjw7ZUb0pp0A9QsxX74rhaD
         KtmffS17LcUN7aihRPC44ZoOY+zCC2fVCW9jV8j9UMvpCIMqY81oP88eVY0MKoqjugMt
         fwg4BZqw3XaC0pnJVZs77WPWInPTN1B8BN1yeF9SrKIOByJSdob1Nd71YDrzaw+P4mX3
         CcF51+Agsn5hxcrEuKj4zgQBcagVzIiiEfXtF6GykcSCnVhfgbxNmGAiDA6AilIyaShR
         nwDay+Ovc30/+iZvCgjslIJ+x/3Rq/eFxbBpdn/ROgidMuC7BNg/uT1EcaMl4wePOpLP
         /A/w==
X-Gm-Message-State: AGi0PuZzLxJyjvBlb/rEXAjY7BpPoW0APwxLtnZqXp66HnS0kTQ0kRQL
        Y11d895SjRZdNVhg8F3iLdtCCs96wIaTz2JOw0JHCPAlyThU
X-Google-Smtp-Source: APiQypLNZY55mRUY+Mmi87BuLoHzMCupYhECQHvPJ03ziVJyAeMghmlQXeOc49mhYa6x8F7HgguHiEuOLWZwWaxI9wjEe9CNz5k0
MIME-Version: 1.0
X-Received: by 2002:a05:6602:1c6:: with SMTP id w6mr6684396iot.91.1587705315578;
 Thu, 23 Apr 2020 22:15:15 -0700 (PDT)
Date:   Thu, 23 Apr 2020 22:15:15 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000057d76f05a4027384@google.com>
Subject: INFO: task hung in sock_close
From:   syzbot <syzbot+b42220e45c511c2bf7ad@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    c578ddb3 Merge tag 'linux-kselftest-5.7-rc3' of git://git...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=176044dfe00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=78a7d8adda44b4b
dashboard link: https://syzkaller.appspot.com/bug?extid=b42220e45c511c2bf7ad
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+b42220e45c511c2bf7ad@syzkaller.appspotmail.com

INFO: task syz-executor.1:20765 blocked for more than 143 seconds.
      Not tainted 5.7.0-rc2-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor.1  D26112 20765   7179 0x80004006
Call Trace:
 context_switch kernel/sched/core.c:3372 [inline]
 __schedule+0x805/0xc90 kernel/sched/core.c:4088
 schedule+0x188/0x220 kernel/sched/core.c:4163
 rwsem_down_write_slowpath+0x7d0/0xd60 kernel/locking/rwsem.c:1235
 __down_write kernel/locking/rwsem.c:1389 [inline]
 down_write+0x125/0x130 kernel/locking/rwsem.c:1532
 unregister_netdevice_notifier+0x30/0x380 net/core/dev.c:1776
 inode_lock include/linux/fs.h:797 [inline]
 __sock_release net/socket.c:604 [inline]
 sock_close+0x94/0x260 net/socket.c:1283
 bcm_release+0x77/0x800 net/can/bcm.c:1474
 atomic64_set include/asm-generic/atomic-instrumented.h:854 [inline]
 atomic_long_set include/asm-generic/atomic-long.h:40 [inline]
 rwsem_set_owner kernel/locking/rwsem.c:176 [inline]
 __down_write kernel/locking/rwsem.c:1391 [inline]
 down_write+0xcd/0x130 kernel/locking/rwsem.c:1532
 __sock_release net/socket.c:605 [inline]
 sock_close+0xd8/0x260 net/socket.c:1283
 sock_mmap+0x90/0x90 net/socket.c:1278
 __fput+0x2ed/0x750 fs/file_table.c:280
 task_work_run+0x147/0x1d0 kernel/task_work.c:123
 exit_task_work include/linux/task_work.h:22 [inline]
 do_exit+0x5ef/0x1f80 kernel/exit.c:795
 do_group_exit+0x15e/0x2c0 kernel/exit.c:893
 get_signal+0x13cf/0x1d60 kernel/signal.c:2735
 do_signal+0x33/0x610 arch/x86/kernel/signal.c:784
 rcu_read_unlock_sched include/linux/rcupdate.h:732 [inline]
 __fd_install+0x251/0x490 fs/file.c:613
 exit_to_usermode_loop arch/x86/entry/common.c:148 [inline]
 prepare_exit_to_usermode+0x280/0x600 arch/x86/entry/common.c:196
 exit_to_usermode_loop arch/x86/entry/common.c:161 [inline]
 prepare_exit_to_usermode+0x32a/0x600 arch/x86/entry/common.c:196
 syscall_return_slowpath+0xf9/0x420 arch/x86/entry/common.c:278
 entry_SYSCALL_64_after_hwframe+0x49/0xb3

Showing all locks held in the system:
4 locks held by kworker/u4:2/88:
3 locks held by kworker/u4:3/128:
1 lock held by khungtaskd/1129:
 #0: ffffffff892e8550 (rcu_read_lock){....}-{1:2}, at: rcu_lock_acquire+0x0/0x30 net/mptcp/pm_netlink.c:858
1 lock held by in:imklog/6713:
 #0: ffff888095212bb0 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0x25d/0x2f0 fs/file.c:826
2 locks held by agetty/6722:
 #0: ffff888093fd9098 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x21/0x70 drivers/tty/tty_ldisc.c:267
 #1: ffffc90000f802e8 (&ldata->atomic_read_lock){+.+.}-{3:3}, at: n_tty_read+0x260/0x1bc0 drivers/tty/n_tty.c:2156
2 locks held by syz-executor.1/20765:
 #0: ffff8880245bf750 (&sb->s_type->i_mutex_key#14){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:797 [inline]
 #0: ffff8880245bf750 (&sb->s_type->i_mutex_key#14){+.+.}-{3:3}, at: __sock_release net/socket.c:604 [inline]
 #0: ffff8880245bf750 (&sb->s_type->i_mutex_key#14){+.+.}-{3:3}, at: sock_close+0x94/0x260 net/socket.c:1283
 #1: ffffffff895ac1b0 (pernet_ops_rwsem){++++}-{3:3}, at: unregister_netdevice_notifier+0x30/0x380 net/core/dev.c:1776

=============================================

NMI backtrace for cpu 0
CPU: 0 PID: 1129 Comm: khungtaskd Not tainted 5.7.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1e9/0x30e lib/dump_stack.c:118
 nmi_cpu_backtrace+0x9f/0x180 lib/nmi_backtrace.c:101
 arch_trigger_cpumask_backtrace+0x10/0x10 arch/x86/kernel/apic/hw_nmi.c:38
 nmi_trigger_cpumask_backtrace+0x16a/0x280 lib/nmi_backtrace.c:62
 check_hung_uninterruptible_tasks kernel/hung_task.c:205 [inline]
 watchdog+0xd2a/0xd40 kernel/hung_task.c:289
 kthread+0x353/0x380 kernel/kthread.c:268
 hungtask_pm_notify+0x50/0x50 kernel/hung_task.c:265
 kthread_blkcg+0xd0/0xd0 kernel/kthread.c:1247
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 PID: 20942 Comm: (md-udevd) Not tainted 5.7.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:check_memory_region+0x2/0x2f0 mm/kasan/generic.c:192
Code: d1 e8 88 eb 0c 31 db 48 c7 c7 82 d1 e8 88 4c 89 fe 31 c0 e8 bd 61 ab ff eb d3 cc cc cc cc cc cc cc cc cc cc cc cc cc cc 41 57 <41> 56 41 55 41 54 53 b0 01 48 85 f6 0f 84 0d 02 00 00 48 89 fb 48
RSP: 0018:ffffc90016bb7a70 EFLAGS: 00000046
RAX: 0000000000000002 RBX: 00000000000000b2 RCX: ffffffff81596a64
RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffffffff8b149500
RBP: ffffc90016bb7c70 R08: dffffc0000000000 R09: fffffbfff16292a1
R10: fffffbfff16292a1 R11: 0000000000000000 R12: 1ffff11005f0d1d7
R13: ffff88802f868ee8 R14: e91b78abf4a04936 R15: dffffc0000000000
FS:  00007fd711208500(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fb179f01000 CR3: 000000004e7fd000 CR4: 00000000001426e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 test_bit include/asm-generic/bitops/instrumented-non-atomic.h:110 [inline]
 hlock_class kernel/locking/lockdep.c:179 [inline]
 lookup_chain_cache_add kernel/locking/lockdep.c:3146 [inline]
 validate_chain+0x94/0x8920 kernel/locking/lockdep.c:3202
 test_bit include/asm-generic/bitops/instrumented-non-atomic.h:110 [inline]
 hlock_class kernel/locking/lockdep.c:179 [inline]
 mark_lock+0x102/0x1b00 kernel/locking/lockdep.c:3912
 __lock_acquire+0x116c/0x2c30 kernel/locking/lockdep.c:4355
 test_bit include/asm-generic/bitops/instrumented-non-atomic.h:110 [inline]
 hlock_class kernel/locking/lockdep.c:179 [inline]
 mark_lock+0x102/0x1b00 kernel/locking/lockdep.c:3912
 __lock_acquire+0x116c/0x2c30 kernel/locking/lockdep.c:4355
 pv_queued_spin_unlock arch/x86/include/asm/paravirt.h:650 [inline]
 queued_spin_unlock arch/x86/include/asm/qspinlock.h:55 [inline]
 do_raw_spin_unlock+0x134/0x8d0 kernel/locking/spinlock_debug.c:139
 __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:168 [inline]
 _raw_spin_unlock_irq+0x1f/0x80 kernel/locking/spinlock.c:199
 lock_acquire+0x169/0x480 kernel/locking/lockdep.c:4934
 spin_lock include/linux/spinlock.h:353 [inline]
 __close_fd+0x2f/0x1f0 fs/file.c:631
 pv_queued_spin_unlock arch/x86/include/asm/paravirt.h:650 [inline]
 queued_spin_unlock arch/x86/include/asm/qspinlock.h:55 [inline]
 do_raw_spin_unlock+0x134/0x8d0 kernel/locking/spinlock_debug.c:139
 __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
 _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
 spin_lock include/linux/spinlock.h:353 [inline]
 __close_fd+0x2f/0x1f0 fs/file.c:631
 spin_lock include/linux/spinlock.h:353 [inline]
 __close_fd+0x2f/0x1f0 fs/file.c:631
 __do_sys_close fs/open.c:1270 [inline]
 __se_sys_close fs/open.c:1268 [inline]
 __x64_sys_close+0x62/0xb0 fs/open.c:1268
 do_syscall_64+0xf3/0x1b0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x7fd70faa628d
Code: c1 20 00 00 75 10 b8 03 00 00 00 0f 05 48 3d 01 f0 ff ff 73 31 c3 48 83 ec 08 e8 ee fb ff ff 48 89 04 24 b8 03 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 37 fc ff ff 48 89 d0 48 83 c4 08 48 3d 01
RSP: 002b:00007ffd283f1d70 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: ffffffffffffffda RBX: 00000000000874f5 RCX: 00007fd70faa628d
RDX: 00007ffd283f1dfc RSI: 00007ffd283f1df0 RDI: 00000000000874f5
RBP: 0000000000100000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000008 R11: 0000000000000293 R12: 0000000000000003
R13: 00007ffd283f1df0 R14: 0000000000000000 R15: 00007ffd283f2070


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
