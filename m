Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 797D9132AAA
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 17:03:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728381AbgAGQDL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 11:03:11 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:39243 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728052AbgAGQDL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 11:03:11 -0500
Received: by mail-il1-f200.google.com with SMTP id n6so45834919ile.6
        for <netdev@vger.kernel.org>; Tue, 07 Jan 2020 08:03:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Bj3/S3P2ybvZ52mIwDyIfAFl2Dygzzgs5cWLel1ngeU=;
        b=KELZ8rFP+ZcM9b9GVaJz808V7Pjirv75fL3jjC8HDmoVsjOK+9zomU617FFrc0YsvT
         tymSe1nLX87f23yiQjh399VWq7CgDvbVwEPp/CmxJSvqg/39sWm0PnCiEMfJ/07Lrcti
         ftzrvB5a2Z88h1pVFIDdZ79PKeUuCvKxsep+OA6Elc7UcUplI8rBUGa8I7NR74Xyue5Y
         qQor8bLsGI7n8pSteaOgEebNOR450aSODIUUpWV9iCWBvlYSArIkmOGqRo8wX76qlZie
         yIH/dGuXdM0pD/tD+pApTDGU5sR1EoMPJlQZmCNoI8oVyYW4m3bBEz6s/OzcWUE82BVL
         KydQ==
X-Gm-Message-State: APjAAAU/PwYVTkyxlzTZpmdvAdbdtHER3jDITU0T4iJ2amUGpKOuDMRi
        FaIzHesCGx8f9jxp6Wy237nYWikfxLEYYZ+FcoJyUc73ijYz
X-Google-Smtp-Source: APXvYqw4LRacZaAdswqbY6qwTTSWzKmRX3Sz9H828hacUvKgl7a1Wu/LjmT6g4pceQtCnZ/wR//ksSJ1QWxD+iXq0o+8cgmTUl9l
MIME-Version: 1.0
X-Received: by 2002:a92:dcca:: with SMTP id b10mr95717526ilr.294.1578412990198;
 Tue, 07 Jan 2020 08:03:10 -0800 (PST)
Date:   Tue, 07 Jan 2020 08:03:10 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000096ffe8059b8ee9ef@google.com>
Subject: INFO: task hung in raw_release
From:   syzbot <syzbot+aeec49cf894ac6173e92@syzkaller.appspotmail.com>
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

HEAD commit:    ae608821 Merge tag 'trace-v5.5-rc5' of git://git.kernel.or..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14af6885e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=42c82694f792b2f5
dashboard link: https://syzkaller.appspot.com/bug?extid=aeec49cf894ac6173e92
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+aeec49cf894ac6173e92@syzkaller.appspotmail.com

INFO: task syz-executor.2:21380 blocked for more than 143 seconds.
       Not tainted 5.5.0-rc5-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor.2  D26192 21380  14397 0x80004006
Call Trace:
  context_switch kernel/sched/core.c:3385 [inline]
  __schedule+0x934/0x1f90 kernel/sched/core.c:4081
  schedule+0xdc/0x2b0 kernel/sched/core.c:4155
  rwsem_down_write_slowpath+0x706/0xf80 kernel/locking/rwsem.c:1238
  __down_write kernel/locking/rwsem.c:1392 [inline]
  down_write+0x13c/0x150 kernel/locking/rwsem.c:1535
  unregister_netdevice_notifier+0x7e/0x3a0 net/core/dev.c:1772
  raw_release+0x57/0x760 net/can/raw.c:354
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
RSP: 002b:00007ff5303a6c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000029
RAX: 0000000000000004 RBX: 0000000000000003 RCX: 000000000045af49
RDX: 0000000000000001 RSI: 0000000000000003 RDI: 000000000000001d
RBP: 000000000075bfc8 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007ff5303a76d4
R13: 00000000004cb827 R14: 00000000004e5fe8 R15: 00000000ffffffff

Showing all locks held in the system:
3 locks held by kworker/u4:1/21:
  #0: ffff8880a9a97128 ((wq_completion)netns){+.+.}, at: __write_once_size  
include/linux/compiler.h:226 [inline]
  #0: ffff8880a9a97128 ((wq_completion)netns){+.+.}, at: arch_atomic64_set  
arch/x86/include/asm/atomic64_64.h:34 [inline]
  #0: ffff8880a9a97128 ((wq_completion)netns){+.+.}, at: atomic64_set  
include/asm-generic/atomic-instrumented.h:855 [inline]
  #0: ffff8880a9a97128 ((wq_completion)netns){+.+.}, at: atomic_long_set  
include/asm-generic/atomic-long.h:40 [inline]
  #0: ffff8880a9a97128 ((wq_completion)netns){+.+.}, at: set_work_data  
kernel/workqueue.c:615 [inline]
  #0: ffff8880a9a97128 ((wq_completion)netns){+.+.}, at:  
set_work_pool_and_clear_pending kernel/workqueue.c:642 [inline]
  #0: ffff8880a9a97128 ((wq_completion)netns){+.+.}, at:  
process_one_work+0x88b/0x1740 kernel/workqueue.c:2235
  #1: ffffc90000dd7dc0 (net_cleanup_work){+.+.}, at:  
process_one_work+0x8c1/0x1740 kernel/workqueue.c:2239
  #2: ffffffff8a4cc508 (pernet_ops_rwsem){++++}, at: cleanup_net+0xae/0xaf0  
net/core/net_namespace.c:559
2 locks held by kworker/u4:3/112:
  #0: ffff8880ae937358 (&rq->lock){-.-.}, at: newidle_balance+0xa28/0xe80  
kernel/sched/fair.c:10177
  #1: ffffffff899a5600 (rcu_read_lock){....}, at: perf_iterate_sb+0x0/0xa20  
kernel/events/core.c:7380
1 lock held by khungtaskd/1127:
  #0: ffffffff899a5600 (rcu_read_lock){....}, at:  
debug_show_all_locks+0x5f/0x279 kernel/locking/lockdep.c:5334
1 lock held by rsyslogd/10228:
2 locks held by getty/10350:
  #0: ffff8880a6b4e090 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
  #1: ffffc90001bbb2e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
2 locks held by getty/10351:
  #0: ffff88809003a090 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
  #1: ffffc90001bfb2e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
2 locks held by getty/10352:
  #0: ffff88809003c090 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
  #1: ffffc90001b6b2e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
2 locks held by getty/10353:
  #0: ffff8880a020c090 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
  #1: ffffc90001b9b2e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
2 locks held by getty/10354:
  #0: ffff8880a4770090 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
  #1: ffffc90001bcb2e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
2 locks held by getty/10355:
  #0: ffff888085fbb090 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
  #1: ffffc90001beb2e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
2 locks held by getty/10356:
  #0: ffff888099247090 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
  #1: ffffc90001b3b2e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
2 locks held by syz-executor.2/21380:
  #0: ffff888082d03c80 (&sb->s_type->i_mutex_key#12){+.+.}, at: inode_lock  
include/linux/fs.h:791 [inline]
  #0: ffff888082d03c80 (&sb->s_type->i_mutex_key#12){+.+.}, at:  
__sock_release+0x89/0x280 net/socket.c:591
  #1: ffffffff8a4cc508 (pernet_ops_rwsem){++++}, at:  
unregister_netdevice_notifier+0x7e/0x3a0 net/core/dev.c:1772

=============================================

NMI backtrace for cpu 0
CPU: 0 PID: 1127 Comm: khungtaskd Not tainted 5.5.0-rc5-syzkaller #0
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
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 PID: 112 Comm: kworker/u4:3 Not tainted 5.5.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: bat_events batadv_tt_purge
RIP: 0010:check_memory_region+0x1f/0x1a0 mm/kasan/generic.c:191
Code: 00 66 2e 0f 1f 84 00 00 00 00 00 48 85 f6 0f 84 34 01 00 00 48 b8 ff  
ff ff ff ff 7f ff ff 55 0f b6 d2 48 39 c7 48 89 e5 41 55 <41> 54 53 0f 86  
07 01 00 00 4c 8d 5c 37 ff 49 89 f8 48 b8 00 00 00
RSP: 0018:ffffc900012b7a50 EFLAGS: 00000012
RAX: ffff7fffffffffff RBX: 00000000000005cc RCX: ffffffff815ab610
RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffffffff8b2f8e18
RBP: ffffc900012b7a58 R08: 1ffffffff165f1ca R09: fffffbfff165f1cb
R10: ffff8880a9120ba8 R11: ffff8880a91202c0 R12: 00000000c4aa1f53
R13: ffffffff8a7be570 R14: ffff8880a9120b80 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000c008e26020 CR3: 0000000096afc000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  __kasan_check_read+0x11/0x20 mm/kasan/common.c:95
  test_bit include/asm-generic/bitops/instrumented-non-atomic.h:110 [inline]
  hlock_class kernel/locking/lockdep.c:163 [inline]
  __lock_acquire+0x8a0/0x4a00 kernel/locking/lockdep.c:3952
  lock_acquire+0x190/0x410 kernel/locking/lockdep.c:4485
  __raw_spin_lock_bh include/linux/spinlock_api_smp.h:135 [inline]
  _raw_spin_lock_bh+0x33/0x50 kernel/locking/spinlock.c:175
  spin_lock_bh include/linux/spinlock.h:343 [inline]
  batadv_tt_local_purge+0x10b/0x360 net/batman-adv/translation-table.c:1444
  batadv_tt_purge+0x2e/0xa30 net/batman-adv/translation-table.c:3801
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
