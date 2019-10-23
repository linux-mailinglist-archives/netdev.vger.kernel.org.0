Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67150E1309
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 09:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389829AbfJWHZM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 03:25:12 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:54764 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389749AbfJWHZJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 03:25:09 -0400
Received: by mail-io1-f70.google.com with SMTP id d11so7228826ioc.21
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 00:25:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=xKcQJBIQc2/Cq0PCnsJB9k+HD99LAu+MTvjpMZVDV+8=;
        b=SDCjv+YQwDJDXKLwxq+O5FWz69TvchPVNzjM9QfRBzJOxeYeVoPyWW0z4emtJvCzv+
         3Q5keHC1yGIgM0It+No8tDGdfof5Q4euhoBNffzsyUsqb0YWRtRJX1Ew56mTjV4a/daV
         sP/JbHv3FKVrfQ5TzqmbmoogS6sXOib1BoZaM2J6qZcGsN0qyDlXZNhwi/65RQpt8CO+
         R0O+TFRBng/LKA4vVVWJ7v0Nx1M9A1+OhfMzXsFmoDEa4E/mF5Obe5KaaobZxXXOthkB
         Y7SjuUDJtX2zP8GxNZJCrFLt7668uqbk35W4NlWfOS2nD0IIh0uq3ZOA1UNUsHIMnSjH
         d+EQ==
X-Gm-Message-State: APjAAAUmIAynLPwAg+lpHhTZ+HQnDvY9o1K2zmVMWN8epgqn9Lu4uUhx
        eLurp2fFH0trKv0dX/4wPB95JC0/l5R/VTN+1tVmhcrMB2ox
X-Google-Smtp-Source: APXvYqxrecml2exqGoKbJ6ci8PpL1A6Hc4nQaYc0W9iq/OAENApmbjVtblhllVKN2oKbuuRtZeMS/LulN8hGJYhKHpkyqtpMqyIc
MIME-Version: 1.0
X-Received: by 2002:a92:8408:: with SMTP id l8mr14466789ild.107.1571815507042;
 Wed, 23 Oct 2019 00:25:07 -0700 (PDT)
Date:   Wed, 23 Oct 2019 00:25:07 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f32b3c05958ed0eb@google.com>
Subject: INFO: task hung in register_netdevice_notifier (2)
From:   syzbot <syzbot+355f8edb2ff45d5f95fa@syzkaller.appspotmail.com>
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

HEAD commit:    3b7c59a1 Merge tag 'pinctrl-v5.4-2' of git://git.kernel.or..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=131abff7600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=420126a10fdda0f1
dashboard link: https://syzkaller.appspot.com/bug?extid=355f8edb2ff45d5f95fa
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+355f8edb2ff45d5f95fa@syzkaller.appspotmail.com

INFO: task syz-executor.3:12938 blocked for more than 143 seconds.
       Not tainted 5.4.0-rc4+ #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor.3  D28568 12938  12570 0x00000004
Call Trace:
  context_switch kernel/sched/core.c:3384 [inline]
  __schedule+0x94f/0x1e70 kernel/sched/core.c:4069
  schedule+0xd9/0x260 kernel/sched/core.c:4136
  rwsem_down_write_slowpath+0x70b/0xf90 kernel/locking/rwsem.c:1238
  __down_write kernel/locking/rwsem.c:1392 [inline]
  down_write+0x13c/0x150 kernel/locking/rwsem.c:1535
  register_netdevice_notifier+0x7e/0x650 net/core/dev.c:1644
  bcm_init+0x1a8/0x220 net/can/bcm.c:1451
  can_create+0x288/0x4b0 net/can/af_can.c:167
  __sock_create+0x3d8/0x730 net/socket.c:1418
  sock_create net/socket.c:1469 [inline]
  __sys_socket+0x103/0x220 net/socket.c:1511
  __do_sys_socket net/socket.c:1520 [inline]
  __se_sys_socket net/socket.c:1518 [inline]
  __x64_sys_socket+0x73/0xb0 net/socket.c:1518
  do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x459ef9
Code: Bad RIP value.
RSP: 002b:00007f95783e1c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000029
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000459ef9
RDX: 0000000000000002 RSI: 0000000000000002 RDI: 000000000000001d
RBP: 000000000075bf20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f95783e26d4
R13: 00000000004c8f16 R14: 00000000004e02c0 R15: 00000000ffffffff
INFO: task syz-executor.3:12940 blocked for more than 143 seconds.
       Not tainted 5.4.0-rc4+ #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor.3  D29112 12940  12570 0x00000004
Call Trace:
  context_switch kernel/sched/core.c:3384 [inline]
  __schedule+0x94f/0x1e70 kernel/sched/core.c:4069
  schedule+0xd9/0x260 kernel/sched/core.c:4136
  rwsem_down_write_slowpath+0x70b/0xf90 kernel/locking/rwsem.c:1238
  __down_write kernel/locking/rwsem.c:1392 [inline]
  down_write+0x13c/0x150 kernel/locking/rwsem.c:1535
  register_netdevice_notifier+0x7e/0x650 net/core/dev.c:1644
  bcm_init+0x1a8/0x220 net/can/bcm.c:1451
  can_create+0x288/0x4b0 net/can/af_can.c:167
  __sock_create+0x3d8/0x730 net/socket.c:1418
  sock_create net/socket.c:1469 [inline]
  __sys_socket+0x103/0x220 net/socket.c:1511
  __do_sys_socket net/socket.c:1520 [inline]
  __se_sys_socket net/socket.c:1518 [inline]
  __x64_sys_socket+0x73/0xb0 net/socket.c:1518
  do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x459ef9
Code: Bad RIP value.
RSP: 002b:00007f95783c0c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000029
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000459ef9
RDX: 0000000000000002 RSI: 0000000000000002 RDI: 000000000000001d
RBP: 000000000075bfc8 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f95783c16d4
R13: 00000000004c8f16 R14: 00000000004e02c0 R15: 00000000ffffffff

Showing all locks held in the system:
1 lock held by khungtaskd/1070:
  #0: ffffffff88fab040 (rcu_read_lock){....}, at:  
debug_show_all_locks+0x5f/0x27e kernel/locking/lockdep.c:5337
2 locks held by rs:main Q:Reg/8631:
  #0: ffff88809a078d60 (&f->f_pos_lock){+.+.}, at: __fdget_pos+0xee/0x110  
fs/file.c:801
  #1: ffff88821637c428 (sb_writers#3){.+.+}, at: file_start_write  
include/linux/fs.h:2882 [inline]
  #1: ffff88821637c428 (sb_writers#3){.+.+}, at: vfs_write+0x485/0x5d0  
fs/read_write.c:557
1 lock held by rsyslogd/8633:
  #0: ffff8880a9391120 (&f->f_pos_lock){+.+.}, at: __fdget_pos+0xee/0x110  
fs/file.c:801
2 locks held by getty/8723:
  #0: ffff888096a75090 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
  #1: ffffc90005f1d2e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x232/0x1c10 drivers/tty/n_tty.c:2156
2 locks held by getty/8724:
  #0: ffff8880a181f090 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
  #1: ffffc90005f392e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x232/0x1c10 drivers/tty/n_tty.c:2156
2 locks held by getty/8725:
  #0: ffff88809ccbf090 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
  #1: ffffc90005f292e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x232/0x1c10 drivers/tty/n_tty.c:2156
2 locks held by getty/8726:
  #0: ffff888092816090 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
  #1: ffffc90005f152e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x232/0x1c10 drivers/tty/n_tty.c:2156
2 locks held by getty/8727:
  #0: ffff8880a10bc090 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
  #1: ffffc90005f2d2e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x232/0x1c10 drivers/tty/n_tty.c:2156
2 locks held by getty/8728:
  #0: ffff888091055090 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
  #1: ffffc90005f312e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x232/0x1c10 drivers/tty/n_tty.c:2156
2 locks held by getty/8729:
  #0: ffff8880a4f5c090 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
  #1: ffffc90005f092e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x232/0x1c10 drivers/tty/n_tty.c:2156
3 locks held by kworker/u4:2/12751:
3 locks held by kworker/u4:8/30968:
1 lock held by syz-executor.3/12938:
  #0: ffffffff89996388 (pernet_ops_rwsem){++++}, at:  
register_netdevice_notifier+0x7e/0x650 net/core/dev.c:1644
1 lock held by syz-executor.3/12940:
  #0: ffffffff89996388 (pernet_ops_rwsem){++++}, at:  
register_netdevice_notifier+0x7e/0x650 net/core/dev.c:1644

=============================================

NMI backtrace for cpu 1
CPU: 1 PID: 1070 Comm: khungtaskd Not tainted 5.4.0-rc4+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  nmi_cpu_backtrace.cold+0x70/0xb2 lib/nmi_backtrace.c:101
  nmi_trigger_cpumask_backtrace+0x23b/0x28b lib/nmi_backtrace.c:62
  arch_trigger_cpumask_backtrace+0x14/0x20 arch/x86/kernel/apic/hw_nmi.c:38
  trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
  check_hung_uninterruptible_tasks kernel/hung_task.c:205 [inline]
  watchdog+0x9d0/0xef0 kernel/hung_task.c:289
  kthread+0x361/0x430 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 PID: 30777 Comm: kworker/u4:4 Not tainted 5.4.0-rc4+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: bat_events batadv_nc_worker
RIP: 0010:hlock_class kernel/locking/lockdep.c:163 [inline]
RIP: 0010:mark_lock+0xca/0x1220 kernel/locking/lockdep.c:3643
Code: 20 66 81 e3 ff 1f 0f b7 db be 08 00 00 00 48 89 d8 48 c1 f8 06 48 8d  
3c c5 a0 e9 77 8a e8 4e 73 55 00 48 0f a3 1d 46 12 1f 09 <0f> 83 be 00 00  
00 48 69 db b0 00 00 00 48 81 c3 c0 ed 77 8a 48 8d
RSP: 0018:ffff888058de7ad8 EFLAGS: 00000047
RAX: 0000000000000001 RBX: 0000000000000029 RCX: ffffffff8158d752
RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffffffff8a77e9a0
RBP: ffff888058de7b28 R08: 1ffffffff14efd34 R09: fffffbfff14efd35
R10: fffffbfff14efd34 R11: ffffffff8a77e9a7 R12: 0000000000000008
R13: ffff888022a00d28 R14: 0000000000000000 R15: 0000000000020029
FS:  0000000000000000(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000459ecf CR3: 000000009451c000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  mark_usage kernel/locking/lockdep.c:3592 [inline]
  __lock_acquire+0x538/0x4a00 kernel/locking/lockdep.c:3909
  lock_acquire+0x190/0x410 kernel/locking/lockdep.c:4487
  rcu_lock_acquire include/linux/rcupdate.h:208 [inline]
  rcu_read_lock include/linux/rcupdate.h:599 [inline]
  batadv_nc_purge_orig_hash net/batman-adv/network-coding.c:407 [inline]
  batadv_nc_worker+0x117/0x760 net/batman-adv/network-coding.c:718
  process_one_work+0x9af/0x1740 kernel/workqueue.c:2269
  worker_thread+0x98/0xe40 kernel/workqueue.c:2415
  kthread+0x361/0x430 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
