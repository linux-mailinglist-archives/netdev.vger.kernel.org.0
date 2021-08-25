Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DB0D3F7B7B
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 19:22:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242302AbhHYRXL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 13:23:11 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:46757 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242293AbhHYRXH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 13:23:07 -0400
Received: by mail-io1-f72.google.com with SMTP id s6-20020a5ec646000000b005b7f88ffdd3so14933636ioo.13
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 10:22:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=UafuiKZgAuV2PQ23F5jJQAl5WEpSCaM94FX2b+wQ71o=;
        b=tWL9p6eWo10rMRba2sv8zbJ3N+uhUKcdTe3XB3TWJMyYFLqC8kdGU2NgK5R0lf9VoD
         0UWnsVblbGu0gOYymf2oCI7jz5k3OzuZQvwFT4sStjFw82d1UU1UHBoN8H1zrWCXg5MQ
         9fnDslBA4nSVshMs5kK+J+YG/BWZ9NVq353uHcGkio/ZUe6oRZmR3MyIrzPG8Juq/chy
         07PkyoKrj3t9pPuxNfAhcLDjRwirhQZ+pGeNh7gRvzeRxcIQFgvWVbeTzyQaiycPthKo
         ikaxqfhl9WdVuWcSelS544i3uAjYGORWooNpOQueotx2psdD2OIicU7sutKISi4LsRcG
         VZ5w==
X-Gm-Message-State: AOAM532zcxc4Dn3iqL2hitKoLWntoaNPv5wQR/mV5I/d9G58Zq1az6g9
        IKIVs69NtSy6j6ksXD1aVb89oJKn3VVYYBrgGkryIHcvBmDk
X-Google-Smtp-Source: ABdhPJwEXsMo0bYz1m5FQ1xc1aqLAAroEoH/9OO8P9HYsfI7jGUGXbN+nX5oCGWycS6uQ/df7lD0MsfMC/Xtx1zj/8pBEKmuHC1B
MIME-Version: 1.0
X-Received: by 2002:a05:6638:13d6:: with SMTP id i22mr40383008jaj.13.1629912141118;
 Wed, 25 Aug 2021 10:22:21 -0700 (PDT)
Date:   Wed, 25 Aug 2021 10:22:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002fc21105ca657edf@google.com>
Subject: [syzbot] INFO: task hung in __xfs_buf_submit (2)
From:   syzbot <syzbot+4bb1622c9a583bb6f9f2@syzkaller.appspotmail.com>
To:     a@unstable.cc, axboe@kernel.dk, b.a.t.m.a.n@lists.open-mesh.org,
        davem@davemloft.net, djwong@kernel.org, josef@toxicpanda.com,
        linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
        mareklindner@neomailbox.ch, mchristi@redhat.com,
        netdev@vger.kernel.org, sw@simonwunderlich.de,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    6e764bcd1cf7 Merge tag 'for-linus' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10504885300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2fd902af77ff1e56
dashboard link: https://syzkaller.appspot.com/bug?extid=4bb1622c9a583bb6f9f2
compiler:       Debian clang version 11.0.1-2, GNU ld (GNU Binutils for Debian) 2.35.1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14427606300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=149b3cce300000

The issue was bisected to:

commit 887e975c4172d0d5670c39ead2f18ba1e4ec8133
Author: Mike Christie <mchristi@redhat.com>
Date:   Tue Aug 13 16:39:51 2019 +0000

    nbd: add missing config put

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11980ad5300000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=13980ad5300000
console output: https://syzkaller.appspot.com/x/log.txt?x=15980ad5300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+4bb1622c9a583bb6f9f2@syzkaller.appspotmail.com
Fixes: 887e975c4172 ("nbd: add missing config put")

INFO: task syz-executor519:8442 blocked for more than 143 seconds.
      Not tainted 5.14.0-rc7-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor519 state:D stack:22808 pid: 8442 ppid:  8441 flags:0x00004004
Call Trace:
 context_switch kernel/sched/core.c:4681 [inline]
 __schedule+0xc07/0x11f0 kernel/sched/core.c:5938
 schedule+0x14b/0x210 kernel/sched/core.c:6017
 schedule_timeout+0x98/0x2f0 kernel/time/timer.c:1857
 do_wait_for_common+0x2da/0x480 kernel/sched/completion.c:85
 __wait_for_common kernel/sched/completion.c:106 [inline]
 wait_for_common kernel/sched/completion.c:117 [inline]
 wait_for_completion+0x48/0x60 kernel/sched/completion.c:138
 xfs_buf_iowait fs/xfs/xfs_buf.c:1571 [inline]
 __xfs_buf_submit+0x39d/0x6d0 fs/xfs/xfs_buf.c:1636
 xfs_buf_submit fs/xfs/xfs_buf.c:58 [inline]
 xfs_buf_read_uncached+0x1fa/0x390 fs/xfs/xfs_buf.c:884
 xfs_readsb+0x1dc/0x670 fs/xfs/xfs_mount.c:178
 xfs_fs_fill_super+0x483/0x1780 fs/xfs/xfs_super.c:1428
 get_tree_bdev+0x406/0x630 fs/super.c:1293
 vfs_get_tree+0x86/0x270 fs/super.c:1498
 do_new_mount fs/namespace.c:2923 [inline]
 path_mount+0x1981/0x2c10 fs/namespace.c:3253
 do_mount fs/namespace.c:3266 [inline]
 __do_sys_mount fs/namespace.c:3474 [inline]
 __se_sys_mount+0x2f9/0x3b0 fs/namespace.c:3451
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x444239
RSP: 002b:00007ffd4feb56f8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 0030656c69662f2e RCX: 0000000000444239
RDX: 0000000020000140 RSI: 0000000020000000 RDI: 00000000200000c0
RBP: 0000000000000000 R08: 0000000000000000 R09: 00007ffd4feb5898
R10: 0000000000008002 R11: 0000000000000246 R12: 0000000000403550
R13: 431bde82d7b634db R14: 00000000004b2018 R15: 00000000004004a0

Showing all locks held in the system:
1 lock held by khungtaskd/1644:
 #0: ffffffff8c717ec0 (rcu_read_lock){....}-{1:2}, at: rcu_lock_acquire+0x0/0x30 arch/x86/pci/mmconfig_64.c:151
2 locks held by in:imklog/8141:
 #0: ffff888023be8870 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0x24e/0x2f0 fs/file.c:974
 #1: ffffffff8c717ec0 (rcu_read_lock){....}-{1:2}, at: rcu_lock_acquire+0x5/0x30 include/linux/rcupdate.h:266
1 lock held by syz-executor519/8442:
 #0: ffff888030e060e0 (&type->s_umount_key#49/1){+.+.}-{3:3}, at: alloc_super+0x1c8/0x860 fs/super.c:229

=============================================

NMI backtrace for cpu 1
CPU: 1 PID: 1644 Comm: khungtaskd Not tainted 5.14.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x1d3/0x29f lib/dump_stack.c:105
 nmi_cpu_backtrace+0x16c/0x190 lib/nmi_backtrace.c:105
 nmi_trigger_cpumask_backtrace+0x191/0x2f0 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:210 [inline]
 watchdog+0xd06/0xd50 kernel/hung_task.c:295
 kthread+0x453/0x480 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 PID: 4862 Comm: systemd-journal Not tainted 5.14.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:check_wait_context kernel/locking/lockdep.c:4688 [inline]
RIP: 0010:__lock_acquire+0x5fc/0x6100 kernel/locking/lockdep.c:4965
Code: 00 fc ff df 4c 8b 7c 24 58 4c 8b 64 24 50 48 81 c3 b8 00 00 00 48 89 d8 48 c1 e8 03 8a 04 10 84 c0 0f 85 c1 25 00 00 44 8a 33 <48> 8b 44 24 60 8a 04 10 84 c0 0f 85 d2 25 00 00 41 8b 1c 24 81 e3
RSP: 0018:ffffc9000162f940 EFLAGS: 00000046
RAX: 1ffffffff1f10400 RBX: ffffffff8f882478 RCX: ffffffff816219b8
RDX: dffffc0000000000 RSI: 0000000000000008 RDI: ffffffff8faf3dd0
RBP: ffffc9000162fcd0 R08: dffffc0000000000 R09: fffffbfff1f5e7bb
R10: fffffbfff1f5e7bb R11: 0000000000000000 R12: ffff888015bc5ed0
R13: ffff888015bc5eb8 R14: 00000000000c0000 R15: ffff888015bc54c0
FS:  00007f6e3c3a48c0(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f6e39776000 CR3: 00000000213b3000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 lock_acquire+0x182/0x4a0 kernel/locking/lockdep.c:5625
 do_write_seqcount_begin_nested include/linux/seqlock.h:520 [inline]
 do_write_seqcount_begin include/linux/seqlock.h:545 [inline]
 vtime_user_exit+0xb9/0x3e0 kernel/sched/cputime.c:719
 __context_tracking_exit+0x7a/0xd0 kernel/context_tracking.c:160
 user_exit_irqoff include/linux/context_tracking.h:47 [inline]
 __enter_from_user_mode kernel/entry/common.c:22 [inline]
 syscall_enter_from_user_mode+0x199/0x1b0 kernel/entry/common.c:104
 do_syscall_64+0x1e/0xb0 arch/x86/entry/common.c:76
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f6e3b65f9c7
Code: 83 c4 08 48 3d 01 f0 ff ff 73 01 c3 48 8b 0d c8 d4 2b 00 f7 d8 64 89 01 48 83 c8 ff c3 66 0f 1f 44 00 00 b8 15 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d a1 d4 2b 00 f7 d8 64 89 01 48
RSP: 002b:00007ffebb868098 EFLAGS: 00000246 ORIG_RAX: 0000000000000015
RAX: ffffffffffffffda RBX: 00007ffebb86b0c0 RCX: 00007f6e3b65f9c7
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 000055c77e4df9a3
RBP: 00007ffebb8681e0 R08: 000055c77e4d53e5 R09: 0000000000000018
R10: 0000000000000069 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 000055c77fce98a0 R15: 00007ffebb8686d0
----------------
Code disassembly (best guess), 3 bytes skipped:
   0:	df 4c 8b 7c          	fisttps 0x7c(%rbx,%rcx,4)
   4:	24 58                	and    $0x58,%al
   6:	4c 8b 64 24 50       	mov    0x50(%rsp),%r12
   b:	48 81 c3 b8 00 00 00 	add    $0xb8,%rbx
  12:	48 89 d8             	mov    %rbx,%rax
  15:	48 c1 e8 03          	shr    $0x3,%rax
  19:	8a 04 10             	mov    (%rax,%rdx,1),%al
  1c:	84 c0                	test   %al,%al
  1e:	0f 85 c1 25 00 00    	jne    0x25e5
  24:	44 8a 33             	mov    (%rbx),%r14b
* 27:	48 8b 44 24 60       	mov    0x60(%rsp),%rax <-- trapping instruction
  2c:	8a 04 10             	mov    (%rax,%rdx,1),%al
  2f:	84 c0                	test   %al,%al
  31:	0f 85 d2 25 00 00    	jne    0x2609
  37:	41 8b 1c 24          	mov    (%r12),%ebx
  3b:	81                   	.byte 0x81
  3c:	e3                   	.byte 0xe3


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
