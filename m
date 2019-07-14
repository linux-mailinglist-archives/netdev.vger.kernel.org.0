Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE19C67CEF
	for <lists+netdev@lfdr.de>; Sun, 14 Jul 2019 06:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726077AbfGNEHH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jul 2019 00:07:07 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:43393 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725308AbfGNEHH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Jul 2019 00:07:07 -0400
Received: by mail-io1-f70.google.com with SMTP id q26so15901850ioi.10
        for <netdev@vger.kernel.org>; Sat, 13 Jul 2019 21:07:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=/6wkwT0idFLnOEPxuO0WhNO61CRDw6dRODNZJZSVjKw=;
        b=iE0YZtmUQcKISNPykpZkGp0GPGzQSJHBIaPrTiTki2h6xeFF1Qrgw/kup1oIeMjHDc
         IkqLQ2qH/AGD+wRj6lOvkeVJZ1cHVdNTKbNkKBiUWHkFzF0E2c1uNj3yTw9D0abmSFX/
         kAI5VYjziV8qdktlnK9nq8w9RrYY2KwWNFUQF0Jw2mgsqIc/DjbTsshpSNhDnveQMbxZ
         F5mVQXOvGZoMm5Ht8yRt4kfBtCLOJrCx5TCMpjBVrew/iTZYNtzUCQFDKRjgXZmE+q0T
         grwT3sjcZJyARCT7FRBtznfTPYniF6UEskppFiReOcIJYdN2jgCbL8dKelVSUn4fA5jH
         58Pw==
X-Gm-Message-State: APjAAAX/4PFAM23vedRa3uq1PzQzXbqBVkl5eLzBSKFTAWBoXXKIdDxD
        vG+GDroL+06+xQKeZJR/y4f0L5SOGxb8eENj1yuDlUH2uhHt
X-Google-Smtp-Source: APXvYqxDXQMxZG8VSzid85/n8+K6/jYKd/QojY2k5FdyEvjPUT3e3CRCo/93uVmy2/raweCHyXozszpcpqtQgpZWTGQn6IFU71Ml
MIME-Version: 1.0
X-Received: by 2002:a02:9a03:: with SMTP id b3mr20808327jal.0.1563077226007;
 Sat, 13 Jul 2019 21:07:06 -0700 (PDT)
Date:   Sat, 13 Jul 2019 21:07:05 -0700
In-Reply-To: <0000000000009d787a0582128cbe@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d018ea058d9c46e3@google.com>
Subject: Re: INFO: task hung in unregister_netdevice_notifier (3)
From:   syzbot <syzbot+0f1827363a305f74996f@syzkaller.appspotmail.com>
To:     davem@davemloft.net, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org, mkl@pengutronix.de,
        netdev@vger.kernel.org, socketcan@hartkopp.net,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    a2d79c71 Merge tag 'for-5.3/io_uring-20190711' of git://gi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10e45f0fa00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3539b1747f03988e
dashboard link: https://syzkaller.appspot.com/bug?extid=0f1827363a305f74996f
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1765c52fa00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+0f1827363a305f74996f@syzkaller.appspotmail.com

INFO: task syz-executor.4:9527 blocked for more than 143 seconds.
       Not tainted 5.2.0+ #80
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor.4  D28136  9527   9356 0x00000004
Call Trace:
  context_switch kernel/sched/core.c:3252 [inline]
  __schedule+0x755/0x1580 kernel/sched/core.c:3878
  schedule+0xa8/0x270 kernel/sched/core.c:3942
  rwsem_down_write_slowpath+0x70a/0xf70 kernel/locking/rwsem.c:1198
  __down_write kernel/locking/rwsem.c:1349 [inline]
  down_write+0x13c/0x150 kernel/locking/rwsem.c:1485
  unregister_netdevice_notifier+0x7e/0x390 net/core/dev.c:1713
  bcm_release+0x93/0x5e0 net/can/bcm.c:1525
  __sock_release+0xce/0x280 net/socket.c:586
  sock_close+0x1e/0x30 net/socket.c:1264
  __fput+0x2ff/0x890 fs/file_table.c:280
  ____fput+0x16/0x20 fs/file_table.c:313
  task_work_run+0x145/0x1c0 kernel/task_work.c:113
  tracehook_notify_resume include/linux/tracehook.h:185 [inline]
  exit_to_usermode_loop+0x316/0x380 arch/x86/entry/common.c:163
  prepare_exit_to_usermode arch/x86/entry/common.c:194 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:274 [inline]
  do_syscall_64+0x5a9/0x6a0 arch/x86/entry/common.c:299
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x413501
Code: 75 14 b8 03 00 00 00 0f 05 48 3d 01 f0 ff ff 0f 83 04 1b 00 00 c3 48  
83 ec 08 e8 0a fc ff ff 48 89 04 24 b8 03 00 00 00 0f 05 <48> 8b 3c 24 48  
89 c2 e8 53 fc ff ff 48 89 d0 48 83 c4 08 48 3d 01
RSP: 002b:0000000000a6fbc0 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000005 RCX: 0000000000413501
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000004
RBP: 0000000000000001 R08: ffffffffffffffff R09: ffffffffffffffff
R10: 0000000000a6fca0 R11: 0000000000000293 R12: 000000000075c9a0
R13: 000000000075c9a0 R14: 00000000007619c8 R15: ffffffffffffffff
INFO: task syz-executor.2:9528 blocked for more than 145 seconds.
       Not tainted 5.2.0+ #80
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor.2  D28136  9528   9354 0x00000004
Call Trace:
  context_switch kernel/sched/core.c:3252 [inline]
  __schedule+0x755/0x1580 kernel/sched/core.c:3878
  schedule+0xa8/0x270 kernel/sched/core.c:3942
  rwsem_down_write_slowpath+0x70a/0xf70 kernel/locking/rwsem.c:1198
  __down_write kernel/locking/rwsem.c:1349 [inline]
  down_write+0x13c/0x150 kernel/locking/rwsem.c:1485
  unregister_netdevice_notifier+0x7e/0x390 net/core/dev.c:1713
  bcm_release+0x93/0x5e0 net/can/bcm.c:1525
  __sock_release+0xce/0x280 net/socket.c:586
  sock_close+0x1e/0x30 net/socket.c:1264
  __fput+0x2ff/0x890 fs/file_table.c:280
  ____fput+0x16/0x20 fs/file_table.c:313
  task_work_run+0x145/0x1c0 kernel/task_work.c:113
  tracehook_notify_resume include/linux/tracehook.h:185 [inline]
  exit_to_usermode_loop+0x316/0x380 arch/x86/entry/common.c:163
  prepare_exit_to_usermode arch/x86/entry/common.c:194 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:274 [inline]
  do_syscall_64+0x5a9/0x6a0 arch/x86/entry/common.c:299
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x413501
Code: 5f fe ff ff 31 c9 31 f6 41 b9 b0 20 41 00 41 b8 8c d6 65 00 ba 02 00  
00 00 bf 28 38 44 00 ff 15 7d a1 24 00 85 c0 0f 85 37 fe <ff> ff 31 c9 31  
f6 41 b9 b0 20 41 00 41 b8 90 d6 65 00 ba 03 00 00
RSP: 002b:0000000000a6fbc0 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000005 RCX: 0000000000413501
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000004
RBP: 0000000000000001 R08: ffffffffffffffff R09: ffffffffffffffff
R10: 0000000000a6fca0 R11: 0000000000000293 R12: 000000000075c9a0
R13: 000000000075c9a0 R14: 00000000007619c8 R15: ffffffffffffffff
INFO: task syz-executor.0:9529 blocked for more than 147 seconds.
       Not tainted 5.2.0+ #80
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor.0  D28136  9529   9353 0x00000004
Call Trace:
  context_switch kernel/sched/core.c:3252 [inline]
  __schedule+0x755/0x1580 kernel/sched/core.c:3878
  schedule+0xa8/0x270 kernel/sched/core.c:3942
  rwsem_down_write_slowpath+0x70a/0xf70 kernel/locking/rwsem.c:1198
  __down_write kernel/locking/rwsem.c:1349 [inline]
  down_write+0x13c/0x150 kernel/locking/rwsem.c:1485
  unregister_netdevice_notifier+0x7e/0x390 net/core/dev.c:1713
  bcm_release+0x93/0x5e0 net/can/bcm.c:1525
  __sock_release+0xce/0x280 net/socket.c:586
  sock_close+0x1e/0x30 net/socket.c:1264
  __fput+0x2ff/0x890 fs/file_table.c:280
  ____fput+0x16/0x20 fs/file_table.c:313
  task_work_run+0x145/0x1c0 kernel/task_work.c:113
  tracehook_notify_resume include/linux/tracehook.h:185 [inline]
  exit_to_usermode_loop+0x316/0x380 arch/x86/entry/common.c:163
  prepare_exit_to_usermode arch/x86/entry/common.c:194 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:274 [inline]
  do_syscall_64+0x5a9/0x6a0 arch/x86/entry/common.c:299
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x413501
Code: 75 14 b8 03 00 00 00 0f 05 48 3d 01 f0 ff ff 0f 83 04 1b 00 00 c3 48  
83 ec 08 e8 0a fc ff ff 48 89 04 24 b8 03 00 00 00 0f 05 <48> 8b 3c 24 48  
89 c2 e8 53 fc ff ff 48 89 d0 48 83 c4 08 48 3d 01
RSP: 002b:0000000000a6fbc0 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000005 RCX: 0000000000413501
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000004
RBP: 0000000000000001 R08: ffffffffffffffff R09: ffffffffffffffff
R10: 0000000000a6fca0 R11: 0000000000000293 R12: 000000000075c9a0
R13: 000000000075c9a0 R14: 00000000007619c8 R15: ffffffffffffffff
INFO: task syz-executor.5:9533 blocked for more than 148 seconds.
       Not tainted 5.2.0+ #80
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor.5  D28136  9533   9358 0x00000004
Call Trace:
  context_switch kernel/sched/core.c:3252 [inline]
  __schedule+0x755/0x1580 kernel/sched/core.c:3878
  schedule+0xa8/0x270 kernel/sched/core.c:3942
  rwsem_down_write_slowpath+0x70a/0xf70 kernel/locking/rwsem.c:1198
  __down_write kernel/locking/rwsem.c:1349 [inline]
  down_write+0x13c/0x150 kernel/locking/rwsem.c:1485
  unregister_netdevice_notifier+0x7e/0x390 net/core/dev.c:1713
  bcm_release+0x93/0x5e0 net/can/bcm.c:1525
  __sock_release+0xce/0x280 net/socket.c:586
  sock_close+0x1e/0x30 net/socket.c:1264
  __fput+0x2ff/0x890 fs/file_table.c:280
  ____fput+0x16/0x20 fs/file_table.c:313
  task_work_run+0x145/0x1c0 kernel/task_work.c:113
  tracehook_notify_resume include/linux/tracehook.h:185 [inline]
  exit_to_usermode_loop+0x316/0x380 arch/x86/entry/common.c:163
  prepare_exit_to_usermode arch/x86/entry/common.c:194 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:274 [inline]
  do_syscall_64+0x5a9/0x6a0 arch/x86/entry/common.c:299
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x413501
Code: 5f fe ff ff 31 c9 31 f6 41 b9 b0 20 41 00 41 b8 8c d6 65 00 ba 02 00  
00 00 bf 28 38 44 00 ff 15 7d a1 24 00 85 c0 0f 85 37 fe <ff> ff 31 c9 31  
f6 41 b9 b0 20 41 00 41 b8 90 d6 65 00 ba 03 00 00
RSP: 002b:0000000000a6fbc0 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000005 RCX: 0000000000413501
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000004
RBP: 0000000000000001 R08: ffffffffffffffff R09: ffffffffffffffff
R10: 0000000000a6fca0 R11: 0000000000000293 R12: 000000000075c9a0
R13: 000000000075c9a0 R14: 00000000007619c8 R15: ffffffffffffffff
INFO: task syz-executor.1:9534 blocked for more than 148 seconds.
       Not tainted 5.2.0+ #80
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor.1  D28136  9534   9359 0x00000004
Call Trace:
  context_switch kernel/sched/core.c:3252 [inline]
  __schedule+0x755/0x1580 kernel/sched/core.c:3878
  schedule+0xa8/0x270 kernel/sched/core.c:3942
  rwsem_down_write_slowpath+0x70a/0xf70 kernel/locking/rwsem.c:1198
  __down_write kernel/locking/rwsem.c:1349 [inline]
  down_write+0x13c/0x150 kernel/locking/rwsem.c:1485
  unregister_netdevice_notifier+0x7e/0x390 net/core/dev.c:1713
  bcm_release+0x93/0x5e0 net/can/bcm.c:1525
  __sock_release+0xce/0x280 net/socket.c:586
  sock_close+0x1e/0x30 net/socket.c:1264
  __fput+0x2ff/0x890 fs/file_table.c:280
  ____fput+0x16/0x20 fs/file_table.c:313
  task_work_run+0x145/0x1c0 kernel/task_work.c:113
  tracehook_notify_resume include/linux/tracehook.h:185 [inline]
  exit_to_usermode_loop+0x316/0x380 arch/x86/entry/common.c:163
  prepare_exit_to_usermode arch/x86/entry/common.c:194 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:274 [inline]
  do_syscall_64+0x5a9/0x6a0 arch/x86/entry/common.c:299
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x413501
Code: 75 14 b8 03 00 00 00 0f 05 48 3d 01 f0 ff ff 0f 83 04 1b 00 00 c3 48  
83 ec 08 e8 0a fc ff ff 48 89 04 24 b8 03 00 00 00 0f 05 <48> 8b 3c 24 48  
89 c2 e8 53 fc ff ff 48 89 d0 48 83 c4 08 48 3d 01
RSP: 002b:0000000000a6fbc0 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000005 RCX: 0000000000413501
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000004
RBP: 0000000000000001 R08: ffffffffffffffff R09: ffffffffffffffff
R10: 0000000000a6fca0 R11: 0000000000000293 R12: 000000000075c9a0
R13: 000000000075c9a0 R14: 00000000007619c8 R15: ffffffffffffffff
INFO: task syz-executor.3:9535 blocked for more than 150 seconds.
       Not tainted 5.2.0+ #80
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor.3  D28136  9535   9351 0x00000004
Call Trace:
  context_switch kernel/sched/core.c:3252 [inline]
  __schedule+0x755/0x1580 kernel/sched/core.c:3878
  schedule+0xa8/0x270 kernel/sched/core.c:3942
  rwsem_down_write_slowpath+0x70a/0xf70 kernel/locking/rwsem.c:1198
  __down_write kernel/locking/rwsem.c:1349 [inline]
  down_write+0x13c/0x150 kernel/locking/rwsem.c:1485
  unregister_netdevice_notifier+0x7e/0x390 net/core/dev.c:1713
  bcm_release+0x93/0x5e0 net/can/bcm.c:1525
  __sock_release+0xce/0x280 net/socket.c:586
  sock_close+0x1e/0x30 net/socket.c:1264
  __fput+0x2ff/0x890 fs/file_table.c:280
  ____fput+0x16/0x20 fs/file_table.c:313
  task_work_run+0x145/0x1c0 kernel/task_work.c:113
  tracehook_notify_resume include/linux/tracehook.h:185 [inline]
  exit_to_usermode_loop+0x316/0x380 arch/x86/entry/common.c:163
  prepare_exit_to_usermode arch/x86/entry/common.c:194 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:274 [inline]
  do_syscall_64+0x5a9/0x6a0 arch/x86/entry/common.c:299
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x413501
Code: 75 14 b8 03 00 00 00 0f 05 48 3d 01 f0 ff ff 0f 83 04 1b 00 00 c3 48  
83 ec 08 e8 0a fc ff ff 48 89 04 24 b8 03 00 00 00 0f 05 <48> 8b 3c 24 48  
89 c2 e8 53 fc ff ff 48 89 d0 48 83 c4 08 48 3d 01
RSP: 002b:0000000000a6fbc0 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000005 RCX: 0000000000413501
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000004
RBP: 0000000000000001 R08: ffffffffffffffff R09: ffffffffffffffff
R10: 0000000000a6fca0 R11: 0000000000000293 R12: 000000000075c9a0
R13: 000000000075c9a0 R14: 00000000007619c8 R15: ffffffffffffffff

Showing all locks held in the system:
1 lock held by khungtaskd/1049:
  #0: 00000000ede263b0 (rcu_read_lock){....}, at:  
debug_show_all_locks+0x5f/0x27e kernel/locking/lockdep.c:5257
1 lock held by rsyslogd/9208:
  #0: 00000000da20b59a (&f->f_pos_lock){+.+.}, at: __fdget_pos+0xee/0x110  
fs/file.c:801
2 locks held by getty/9298:
  #0: 00000000e9efae0d (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:341
  #1: 0000000007287a12 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x232/0x1c10 drivers/tty/n_tty.c:2156
2 locks held by getty/9299:
  #0: 00000000ad0733b0 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:341
  #1: 0000000094dd5193 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x232/0x1c10 drivers/tty/n_tty.c:2156
2 locks held by getty/9300:
  #0: 00000000692c340f (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:341
  #1: 00000000538c7d7d (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x232/0x1c10 drivers/tty/n_tty.c:2156
2 locks held by getty/9301:
  #0: 00000000116ea6c7 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:341
  #1: 00000000a908a9f7 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x232/0x1c10 drivers/tty/n_tty.c:2156
2 locks held by getty/9302:
  #0: 0000000042704f01 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:341
  #1: 0000000041cc8671 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x232/0x1c10 drivers/tty/n_tty.c:2156
2 locks held by getty/9303:
  #0: 000000001ef3b293 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:341
  #1: 000000008b703302 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x232/0x1c10 drivers/tty/n_tty.c:2156
2 locks held by getty/9304:
  #0: 0000000095601bb0 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:341

