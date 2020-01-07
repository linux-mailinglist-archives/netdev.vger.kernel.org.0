Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06B29132AA9
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 17:03:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728391AbgAGQDL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 11:03:11 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:41068 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728291AbgAGQDL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 11:03:11 -0500
Received: by mail-il1-f197.google.com with SMTP id k9so87656ili.8
        for <netdev@vger.kernel.org>; Tue, 07 Jan 2020 08:03:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Lq7oG4kN0bgyUSOq2ZBh0XJtTePNFuAjgOPCbZc9Tyk=;
        b=E5NrV/2v9O5JUkf82Cvu5xJCDb4eWGylRUoyfFe3t4Mym5UPYmuaL81mBcttJf+3CH
         w1mgjsMdfmw/K4iFTgKa8bjL7CO0DKTnzYUhsQ8295Pkscs3B//STYiEk79wh42j9gPZ
         ZCsMDjGFnb2kUHq8+MwgjUOs5Az0rxDjgihGUBvgBqv+5av+BxQTQmAsT1pYxa5Or8pf
         tjp7aRMNjsL4CmmQmdEW/hqOLP8v5FQNe6U+VkwLUbNLLEYfrPAqVxs/Fw4x8ZDnWzL2
         SWylgOnyYU7K88DxLIy5+KUoF2i8gQKZBdOL/pBhFWoy0EuK6UEVi2P3kfM6kVsNttwh
         dYLQ==
X-Gm-Message-State: APjAAAVRzw4lRixyxi6FRNz0alrpBcNaQQXBGz0ZacM19TvFHV1j5ZLX
        9xl6lH5YyOGIS0Bu5h3tDjLQ0EyOyGwTrJzaIYGQScO4Airg
X-Google-Smtp-Source: APXvYqxLPGxJ6STU0SP+dsrT/Jn9uV8vP3KVNj1bujWZ/SxTUkvVglfWHZM1pPa2wqhhV6SmSk+JSNH84hPk2YvW5obH86tfySxD
MIME-Version: 1.0
X-Received: by 2002:a92:498d:: with SMTP id k13mr4070880ilg.254.1578412990449;
 Tue, 07 Jan 2020 08:03:10 -0800 (PST)
Date:   Tue, 07 Jan 2020 08:03:10 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009ad299059b8ee99c@google.com>
Subject: INFO: task hung in bcm_release
From:   syzbot <syzbot+9d1d68a21e17513cb654@syzkaller.appspotmail.com>
To:     davem@davemloft.net, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org, mkl@pengutronix.de,
        netdev@vger.kernel.org, socketcan@hartkopp.net,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    bed72351 Merge tag 'kbuild-fixes-v5.5-2' of git://git.kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16eeba56e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=874bac2ff63646fa
dashboard link: https://syzkaller.appspot.com/bug?extid=9d1d68a21e17513cb654
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+9d1d68a21e17513cb654@syzkaller.appspotmail.com

INFO: task syz-executor.5:25823 blocked for more than 143 seconds.
       Not tainted 5.5.0-rc4-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor.5  D26440 25823  10371 0x80004006
Call Trace:
  context_switch kernel/sched/core.c:3385 [inline]
  __schedule+0x934/0x1f90 kernel/sched/core.c:4081
  schedule+0xdc/0x2b0 kernel/sched/core.c:4155
  rwsem_down_write_slowpath+0x706/0xf80 kernel/locking/rwsem.c:1238
  __down_write kernel/locking/rwsem.c:1392 [inline]
  down_write+0x13c/0x150 kernel/locking/rwsem.c:1535
  unregister_netdevice_notifier+0x7e/0x3a0 net/core/dev.c:1772
  bcm_release+0x93/0x650 net/can/bcm.c:1474
  __sock_release+0xce/0x280 net/socket.c:592
  sock_close+0x1e/0x30 net/socket.c:1270
  __fput+0x2ff/0x890 fs/file_table.c:280
  ____fput+0x16/0x20 fs/file_table.c:313
  task_work_run+0x145/0x1c0 kernel/task_work.c:113
  exit_task_work include/linux/task_work.h:22 [inline]
  do_exit+0xba9/0x2f50 kernel/exit.c:801
  do_group_exit+0x135/0x360 kernel/exit.c:899
  get_signal+0x47c/0x24f0 kernel/signal.c:2734
  do_signal+0x87/0x1700 arch/x86/kernel/signal.c:815
  exit_to_usermode_loop+0x286/0x380 arch/x86/entry/common.c:160
  prepare_exit_to_usermode arch/x86/entry/common.c:195 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:278 [inline]
  do_syscall_64+0x676/0x790 arch/x86/entry/common.c:304
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x45af49
Code: Bad RIP value.
RSP: 002b:00007f5d7155ec78 EFLAGS: 00000246 ORIG_RAX: 0000000000000029
RAX: 0000000000000004 RBX: 0000000000000003 RCX: 000000000045af49
RDX: 0000000000000002 RSI: 0000000000000002 RDI: 000000000000001d
RBP: 000000000075bfc8 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f5d7155f6d4
R13: 00000000004cb57f R14: 00000000004e58a8 R15: 00000000ffffffff

Showing all locks held in the system:
2 locks held by kworker/u4:0/7:
1 lock held by khungtaskd/1103:
  #0: ffffffff899a5680 (rcu_read_lock){....}, at:  
debug_show_all_locks+0x5f/0x279 kernel/locking/lockdep.c:5334
1 lock held by rsyslogd/10193:
  #0: ffff8880a9a7a660 (&f->f_pos_lock){+.+.}, at: __fdget_pos+0xee/0x110  
fs/file.c:801
2 locks held by getty/10315:
  #0: ffff8880a8966090 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
  #1: ffffc900017e32e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
2 locks held by getty/10316:
  #0: ffff8880953a1090 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
  #1: ffffc900018832e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
2 locks held by getty/10317:
  #0: ffff8880a551a090 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
  #1: ffffc900018132e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
2 locks held by getty/10318:
  #0: ffff88809f175090 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
  #1: ffffc900018532e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
2 locks held by getty/10319:
  #0: ffff888094002090 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
  #1: ffffc900018232e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
2 locks held by getty/10320:
  #0: ffff888099c20090 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
  #1: ffffc900018732e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
2 locks held by getty/10321:
  #0: ffff8880a8ab1090 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
  #1: ffffc900017bb2e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
3 locks held by kworker/u4:7/16900:
  #0: ffff8880a9a96128 ((wq_completion)netns){+.+.}, at: __write_once_size  
include/linux/compiler.h:226 [inline]
  #0: ffff8880a9a96128 ((wq_completion)netns){+.+.}, at: arch_atomic64_set  
arch/x86/include/asm/atomic64_64.h:34 [inline]
  #0: ffff8880a9a96128 ((wq_completion)netns){+.+.}, at: atomic64_set  
include/asm-generic/atomic-instrumented.h:855 [inline]
  #0: ffff8880a9a96128 ((wq_completion)netns){+.+.}, at: atomic_long_set  
include/asm-generic/atomic-long.h:40 [inline]
  #0: ffff8880a9a96128 ((wq_completion)netns){+.+.}, at: set_work_data  
kernel/workqueue.c:615 [inline]
  #0: ffff8880a9a96128 ((wq_completion)netns){+.+.}, at:  
set_work_pool_and_clear_pending kernel/workqueue.c:642 [inline]
  #0: ffff8880a9a96128 ((wq_completion)netns){+.+.}, at:  
process_one_work+0x88b/0x1740 kernel/workqueue.c:2235
  #1: ffffc90007fcfdc0 (net_cleanup_work){+.+.}, at:  
process_one_work+0x8c1/0x1740 kernel/workqueue.c:2239
  #2: ffffffff8a4af948 (pernet_ops_rwsem){++++}, at: cleanup_net+0xae/0xaf0  
net/core/net_namespace.c:559
2 locks held by syz-executor.5/25823:
  #0: ffff888091a84700 (&sb->s_type->i_mutex_key#12){+.+.}, at: inode_lock  
include/linux/fs.h:791 [inline]
  #0: ffff888091a84700 (&sb->s_type->i_mutex_key#12){+.+.}, at:  
__sock_release+0x89/0x280 net/socket.c:591
  #1: ffffffff8a4af948 (pernet_ops_rwsem){++++}, at:  
unregister_netdevice_notifier+0x7e/0x3a0 net/core/dev.c:1772
1 lock held by syz-executor.0/25891:
  #0: ffffffff8a4af948 (pernet_ops_rwsem){++++}, at: copy_net_ns+0x27b/0x5a0  
net/core/net_namespace.c:472

=============================================

NMI backtrace for cpu 1
CPU: 1 PID: 1103 Comm: khungtaskd Not tainted 5.5.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
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
CPU: 0 PID: 7 Comm: kworker/u4:0 Not tainted 5.5.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: bat_events batadv_nc_worker
RIP: 0010:__sanitizer_cov_trace_const_cmp4+0x0/0x20 kernel/kcov.c:273
Code: f6 fe ff ff 5d c3 0f 1f 40 00 55 0f b7 d6 0f b7 f7 bf 03 00 00 00 48  
89 e5 48 8b 4d 08 e8 d8 fe ff ff 5d c3 66 0f 1f 44 00 00 <55> 89 f2 89 fe  
bf 05 00 00 00 48 89 e5 48 8b 4d 08 e8 ba fe ff ff
RSP: 0018:ffffc90000cdfcd8 EFLAGS: 00000246
RAX: 0000000000000001 RBX: ffff8880a89978c0 RCX: 1ffffffff14f3a12
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: ffffc90000cdfd30 R08: ffff8880a99f61c0 R09: ffffed1015d0703d
R10: ffffed1015d0703c R11: ffff8880ae8381e3 R12: 0000000000000001
R13: 0000000000000140 R14: 0000000000000001 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffff600400 CR3: 0000000087fff000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  process_one_work+0x9af/0x1740 kernel/workqueue.c:2264
  worker_thread+0x98/0xe40 kernel/workqueue.c:2410
  kthread+0x361/0x430 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
