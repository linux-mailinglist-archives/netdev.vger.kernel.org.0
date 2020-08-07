Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2593123E790
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 09:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbgHGHH3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 03:07:29 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:39885 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726094AbgHGHHR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 03:07:17 -0400
Received: by mail-il1-f197.google.com with SMTP id i66so833197ile.6
        for <netdev@vger.kernel.org>; Fri, 07 Aug 2020 00:07:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=qv4lE7G2xaxTSAJq3kTpN12XBqorrrJ0WTduANv5o2E=;
        b=N9aA05fIu2JaNleBdqTjnxLmNH4BIuR+th+POJVqMtwP6NYYIs83kQ+H14/mWoAm5S
         1q0hOaJSOwy+qwMa1gDShoSeaklpH4ZsXzwSwUsAAz44EEY+xj9AML+K6+xKNZIfTdKp
         PAlv4xHyf6VfOezfuldPeLkgQHJX6DjmQ2UXvvmmcSWBGt8u9XX1Hyc4hSVS6lUKPABo
         dXZejGLQG9D74CY32D5Kz+StfUFukwAjbusXsOgEbh2cvCKUMm1PnhRbQxfWNcVn2Yq9
         gWmUwIrPCXNo7TGAy4DNpWrtWSzWT5EaUlKl0IJU800xayevyZND1/qm6U0s2hz26fJz
         +dDw==
X-Gm-Message-State: AOAM5333OUsF0I7bziAGXEYR0z8bKcqadRPLy9/a6D8N+0IQaw9vXd35
        z2FdMdNlIsJt+eiY81wM7yXKytDAf1+uKK+Y2ckgJkv/G2Ht
X-Google-Smtp-Source: ABdhPJz+Fp2qewsy1tzCgdnTssJIOpyK1pr79B/YED4ieO7jQXedDYAOnf7J2eMFO/mmqoemvNgL3LD3hRLj31KCKx4NqGvCI7Iu
MIME-Version: 1.0
X-Received: by 2002:a92:d8d2:: with SMTP id l18mr2843601ilo.94.1596784036194;
 Fri, 07 Aug 2020 00:07:16 -0700 (PDT)
Date:   Fri, 07 Aug 2020 00:07:16 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000042af6205ac444172@google.com>
Subject: WARNING: locking bug in l2cap_chan_del
From:   syzbot <syzbot+01d7fc00b2a0419d01cc@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    47ec5303 Merge git://git.kernel.org/pub/scm/linux/kernel/g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=111d93fa900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7bb894f55faf8242
dashboard link: https://syzkaller.appspot.com/bug?extid=01d7fc00b2a0419d01cc
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+01d7fc00b2a0419d01cc@syzkaller.appspotmail.com

------------[ cut here ]------------
DEBUG_LOCKS_WARN_ON(1)
WARNING: CPU: 0 PID: 12006 at kernel/locking/lockdep.c:183 hlock_class kernel/locking/lockdep.c:183 [inline]
WARNING: CPU: 0 PID: 12006 at kernel/locking/lockdep.c:183 hlock_class kernel/locking/lockdep.c:172 [inline]
WARNING: CPU: 0 PID: 12006 at kernel/locking/lockdep.c:183 check_wait_context kernel/locking/lockdep.c:4100 [inline]
WARNING: CPU: 0 PID: 12006 at kernel/locking/lockdep.c:183 __lock_acquire+0x1674/0x5640 kernel/locking/lockdep.c:4376
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 12006 Comm: kworker/0:14 Not tainted 5.8.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events l2cap_chan_timeout
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 panic+0x2e3/0x75c kernel/panic.c:231
 __warn.cold+0x20/0x45 kernel/panic.c:600
 report_bug+0x1bd/0x210 lib/bug.c:198
 handle_bug+0x38/0x90 arch/x86/kernel/traps.c:235
 exc_invalid_op+0x14/0x40 arch/x86/kernel/traps.c:255
 asm_exc_invalid_op+0x12/0x20 arch/x86/include/asm/idtentry.h:536
RIP: 0010:hlock_class kernel/locking/lockdep.c:183 [inline]
RIP: 0010:hlock_class kernel/locking/lockdep.c:172 [inline]
RIP: 0010:check_wait_context kernel/locking/lockdep.c:4100 [inline]
RIP: 0010:__lock_acquire+0x1674/0x5640 kernel/locking/lockdep.c:4376
Code: d2 0f 85 f1 36 00 00 44 8b 15 b0 8e 57 09 45 85 d2 0f 85 1c fa ff ff 48 c7 c6 80 af 4b 88 48 c7 c7 80 aa 4b 88 e8 ce 36 eb ff <0f> 0b e9 02 fa ff ff c7 44 24 38 fe ff ff ff 41 bf 01 00 00 00 c7
RSP: 0018:ffffc900065878e0 EFLAGS: 00010086
RAX: 0000000000000000 RBX: 0000000000000004 RCX: 0000000000000000
RDX: ffff888051186380 RSI: ffffffff815d8eb7 RDI: fffff52000cb0f0e
RBP: ffff888051186cf0 R08: 0000000000000000 R09: ffffffff89bcb3c3
R10: 00000000000010e6 R11: 0000000000000001 R12: 0000000000000000
R13: 000000000000126a R14: ffff888051186380 R15: 0000000000040000
 lock_acquire+0x1f1/0xad0 kernel/locking/lockdep.c:5005
 __raw_spin_lock_bh include/linux/spinlock_api_smp.h:135 [inline]
 _raw_spin_lock_bh+0x2f/0x40 kernel/locking/spinlock.c:175
 spin_lock_bh include/linux/spinlock.h:359 [inline]
 lock_sock_nested+0x3b/0x110 net/core/sock.c:3040
 l2cap_sock_teardown_cb+0x88/0x400 net/bluetooth/l2cap_sock.c:1520
 l2cap_chan_del+0xad/0x1300 net/bluetooth/l2cap_core.c:618
 l2cap_chan_close+0x118/0xb10 net/bluetooth/l2cap_core.c:823
 l2cap_chan_timeout+0x173/0x450 net/bluetooth/l2cap_core.c:436
 process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
 kthread+0x3b5/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
