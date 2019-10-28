Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4274FE7957
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 20:42:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731424AbfJ1TmK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 15:42:10 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:46889 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731026AbfJ1TmK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 15:42:10 -0400
Received: by mail-il1-f197.google.com with SMTP id i74so7101488ild.13
        for <netdev@vger.kernel.org>; Mon, 28 Oct 2019 12:42:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=bmHQZULhVT/ity23PwxxYsAfoKEIMgz2aD/aW3UZN3A=;
        b=Gjt4AO2LZ7D4NDpw+d672CEaoR6tZPAghNOin3EvfzKGV0HWyP7qyFhopxfVhCspv4
         MzaAZWjEz0iMZFCIY9SyQdlwQTLqfM4nyaX5howlMrS58ImbqpwpF1e82jkHW5uklvnw
         GJ1tv1xPv39JNm9YaXdo0sj/BTMRAEuqqBLvy7BimXgAY2SfUtlURcHjVC2b3rynm3/F
         mgPVKkAFFV+f6LrgYz4HdRS6jhhqFNRb2slEfghUP9FMao7k5TSZEtWlHdC4RHBJXYAl
         UBY6TlC8hyFKh7xBsYCGcJ0nWJjCpf4DCZRlszRnvXci6mRcNL8sXDCdrWKrZ9+JJ8gj
         VLOg==
X-Gm-Message-State: APjAAAWPvp8sq2XQplDxp92gdi6fp1dFPbsScUkmbWtzzsnGf+cMaw4n
        Lx/82bDZq1mN3Gaa11wgcxau0u4LECfJ6OWJf+gbqsnFC5wq
X-Google-Smtp-Source: APXvYqx2Um6zGQ7ftrIQ/vQSOO4cILfPxfDLxYPw/PLv9+/EIRONRZMKMY7PizhqNGrOAoEfKO95ewRO//gqi1099MXx/bydhxoF
MIME-Version: 1.0
X-Received: by 2002:a05:6638:1f1:: with SMTP id t17mr18831455jaq.130.1572291728662;
 Mon, 28 Oct 2019 12:42:08 -0700 (PDT)
Date:   Mon, 28 Oct 2019 12:42:08 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f86a4f0595fdb152@google.com>
Subject: INFO: task hung in io_wq_destroy
From:   syzbot <syzbot+0f1cc17f85154f400465@syzkaller.appspotmail.com>
To:     andriy.shevchenko@linux.intel.com, axboe@kernel.dk,
        davem@davemloft.net, f.fainelli@gmail.com,
        gregkh@linuxfoundation.org, idosch@mellanox.com,
        kimbrownkd@gmail.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        petrm@mellanox.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, viro@zeniv.linux.org.uk, wanghai26@huawei.com,
        yuehaibing@huawei.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    139c2d13 Add linux-next specific files for 20191025
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=137a3e97600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=28fd7a693df38d29
dashboard link: https://syzkaller.appspot.com/bug?extid=0f1cc17f85154f400465
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15415bdf600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=101fa6e4e00000

The bug was bisected to:

commit 3f982fff29b4ad339b36e9cf43422d1039f9917a
Author: Jens Axboe <axboe@kernel.dk>
Date:   Thu Oct 24 17:35:03 2019 +0000

     Merge branch 'for-5.5/drivers' into for-next

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17f7e44ce00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=140fe44ce00000
console output: https://syzkaller.appspot.com/x/log.txt?x=100fe44ce00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+0f1cc17f85154f400465@syzkaller.appspotmail.com
Fixes: 3f982fff29b4 ("Merge branch 'for-5.5/drivers' into for-next")

INFO: task syz-executor696:18072 blocked for more than 143 seconds.
       Not tainted 5.4.0-rc4-next-20191025 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor696 D28160 18072   9609 0x00004004
Call Trace:
  context_switch kernel/sched/core.c:3385 [inline]
  __schedule+0x94a/0x1e70 kernel/sched/core.c:4070
  schedule+0xdc/0x2b0 kernel/sched/core.c:4144
  schedule_timeout+0x717/0xc50 kernel/time/timer.c:1871
  do_wait_for_common kernel/sched/completion.c:83 [inline]
  __wait_for_common kernel/sched/completion.c:104 [inline]
  wait_for_common kernel/sched/completion.c:115 [inline]
  wait_for_completion+0x29c/0x440 kernel/sched/completion.c:136
  io_wq_destroy+0x247/0x470 fs/io-wq.c:784
  io_finish_async+0x102/0x180 fs/io_uring.c:2890
  io_ring_ctx_free fs/io_uring.c:3615 [inline]
  io_ring_ctx_wait_and_kill+0x249/0x710 fs/io_uring.c:3683
  io_uring_release+0x42/0x50 fs/io_uring.c:3691
  __fput+0x2ff/0x890 fs/file_table.c:280
  ____fput+0x16/0x20 fs/file_table.c:313
  task_work_run+0x145/0x1c0 kernel/task_work.c:113
  tracehook_notify_resume include/linux/tracehook.h:188 [inline]
  exit_to_usermode_loop+0x316/0x380 arch/x86/entry/common.c:163
  prepare_exit_to_usermode arch/x86/entry/common.c:194 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:274 [inline]
  do_syscall_64+0x65f/0x760 arch/x86/entry/common.c:300
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4019d0
Code: 01 f0 ff ff 0f 83 20 0c 00 00 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f  
44 00 00 83 3d fd 2c 2d 00 00 75 14 b8 03 00 00 00 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 f4 0b 00 00 c3 48 83 ec 08 e8 5a 01 00 00
RSP: 002b:00007ffdcb9bf4b8 EFLAGS: 00000246 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000004 RCX: 00000000004019d0
RDX: 0000000000401970 RSI: 0000000020000080 RDI: 0000000000000003
RBP: 0000000000000000 R08: 0000000000000004 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000670
R13: 0000000000402ae0 R14: 0000000000000000 R15: 0000000000000000

Showing all locks held in the system:
1 lock held by khungtaskd/1078:
  #0: ffffffff88faba80 (rcu_read_lock){....}, at:  
debug_show_all_locks+0x5f/0x279 kernel/locking/lockdep.c:5336
1 lock held by rsyslogd/9148:
  #0: ffff888099aa8660 (&f->f_pos_lock){+.+.}, at: __fdget_pos+0xee/0x110  
fs/file.c:801
2 locks held by getty/9238:
  #0: ffff88809a77f090 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
  #1: ffffc90005f472e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
2 locks held by getty/9239:
  #0: ffff8880a7bc7090 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
  #1: ffffc90005f4f2e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
2 locks held by getty/9240:
  #0: ffff8880a83e7090 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
  #1: ffffc90005f3d2e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
2 locks held by getty/9241:
  #0: ffff88808e706090 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
  #1: ffffc90005f292e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
2 locks held by getty/9242:
  #0: ffff8880a7b75090 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
  #1: ffffc90005f312e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
2 locks held by getty/9243:
  #0: ffff8880a130f090 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
  #1: ffffc90005f532e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
2 locks held by getty/9244:
  #0: ffff88809b09e090 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
  #1: ffffc90005f212e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156

=============================================

NMI backtrace for cpu 0
CPU: 0 PID: 1078 Comm: khungtaskd Not tainted 5.4.0-rc4-next-20191025 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  nmi_cpu_backtrace.cold+0x70/0xb2 lib/nmi_backtrace.c:101
  nmi_trigger_cpumask_backtrace+0x23b/0x28b lib/nmi_backtrace.c:62
  arch_trigger_cpumask_backtrace+0x14/0x20 arch/x86/kernel/apic/hw_nmi.c:38
  trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
  check_hung_uninterruptible_tasks kernel/hung_task.c:269 [inline]
  watchdog+0xc8f/0x1350 kernel/hung_task.c:353
  kthread+0x361/0x430 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1 skipped: idling at native_safe_halt+0xe/0x10  
arch/x86/include/asm/irqflags.h:60


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
