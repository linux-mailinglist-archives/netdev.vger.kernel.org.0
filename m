Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 654892EA977
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 12:05:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729518AbhAELED (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 06:04:03 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:35473 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729363AbhAELEC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 06:04:02 -0500
Received: by mail-il1-f197.google.com with SMTP id p6so30296681ilb.2
        for <netdev@vger.kernel.org>; Tue, 05 Jan 2021 03:03:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=L3uN6pisff8aaO4cxH6i9R3Ew7bD6TQmaDC9RmrPw9E=;
        b=oZk3QgXgkW/avK00n2lfLWb1hE6ucVT2d8DMimeXTMSzmfD1gaDEgNTA1TsK27Apm5
         HQv6Cs8U77E0K2fi6UdasZmUxf6UnHHfH8cbfwyzWc8f8oUyq9KkNEw+BNzBjFZiPvKu
         jU9p9sIZAIB9pbPofxB5IktO15RTzozPldIr1tS0ePJ53jdzz8NyNmoiF4Lp68LBhL0K
         lqo5sUB6yplGFXuIAdHv2v2M9ynvi3P/kcSo+w3upGrN/8y9VCFZxzESamNEL0x21/4a
         Pr3k8kgzJUTSnVgZCrmTRM5bZESLx+2+Dup33KvW+Rr/RbEKAxPCzxwENOwKr3mmNQvI
         K0vA==
X-Gm-Message-State: AOAM531wA3v8+r2oHqSZ8cyX9irYtVsOWqey9E2KRH0eVQmJfHBaAove
        xjV00IbiftCArVqb2gQPYCBqlVeq4qNvpOTekGPea3B8s6Kc
X-Google-Smtp-Source: ABdhPJxzSl5Zqr+paPHN/saRVltHDzUUF3FrwKSVQzTlt4Pg93UUoeDRkmMBXDIlOKyGASnogv/6VkOppWlos5gW8638Lv5sL2/j
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1605:: with SMTP id t5mr46211487ilu.232.1609844601146;
 Tue, 05 Jan 2021 03:03:21 -0800 (PST)
Date:   Tue, 05 Jan 2021 03:03:21 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000098536705b8252721@google.com>
Subject: WARNING: locking bug in l2cap_sock_teardown_cb
From:   syzbot <syzbot+9cde9e1af823debba3b2@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        luiz.dentz@gmail.com, marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    139711f0 Merge branch 'akpm' (patches from Andrew)
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17a6d077500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=97ec68097e292826
dashboard link: https://syzkaller.appspot.com/bug?extid=9cde9e1af823debba3b2
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+9cde9e1af823debba3b2@syzkaller.appspotmail.com

------------[ cut here ]------------
DEBUG_LOCKS_WARN_ON(1)
WARNING: CPU: 1 PID: 69 at kernel/locking/lockdep.c:202 hlock_class kernel/locking/lockdep.c:202 [inline]
WARNING: CPU: 1 PID: 69 at kernel/locking/lockdep.c:202 hlock_class kernel/locking/lockdep.c:191 [inline]
WARNING: CPU: 1 PID: 69 at kernel/locking/lockdep.c:202 check_wait_context kernel/locking/lockdep.c:4506 [inline]
WARNING: CPU: 1 PID: 69 at kernel/locking/lockdep.c:202 __lock_acquire+0x165e/0x5500 kernel/locking/lockdep.c:4782
Modules linked in:
CPU: 1 PID: 69 Comm: kworker/1:1 Not tainted 5.11.0-rc1-syzkaller #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
Workqueue: events l2cap_chan_timeout
RIP: 0010:hlock_class kernel/locking/lockdep.c:202 [inline]
RIP: 0010:hlock_class kernel/locking/lockdep.c:191 [inline]
RIP: 0010:check_wait_context kernel/locking/lockdep.c:4506 [inline]
RIP: 0010:__lock_acquire+0x165e/0x5500 kernel/locking/lockdep.c:4782
Code: 08 84 d2 0f 85 1c 2c 00 00 8b 15 95 67 97 0b 85 d2 0f 85 5f fa ff ff 48 c7 c6 a0 a7 4b 89 48 c7 c7 c0 9d 4b 89 e8 89 7f 5b 07 <0f> 0b e9 45 fa ff ff c7 44 24 60 fe ff ff ff 41 bf 01 00 00 00 c7
RSP: 0018:ffffc900007b7900 EFLAGS: 00010082
RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000000
RDX: ffff88801115d280 RSI: ffffffff815b2ae5 RDI: fffff520000f6f12
RBP: ffff88801115d280 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff815abc8e R11: 0000000000000000 R12: ffff88801115dca8
R13: 00000000000013db R14: ffff888020f740a0 R15: 0000000000040000
FS:  0000000000000000(0000) GS:ffff88802cb00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffd559fd13c CR3: 000000005a46e000 CR4: 0000000000350ee0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 lock_acquire kernel/locking/lockdep.c:5437 [inline]
 lock_acquire+0x29d/0x740 kernel/locking/lockdep.c:5402
 __raw_spin_lock_bh include/linux/spinlock_api_smp.h:135 [inline]
 _raw_spin_lock_bh+0x2f/0x40 kernel/locking/spinlock.c:175
 spin_lock_bh include/linux/spinlock.h:359 [inline]
 lock_sock_nested+0x3b/0x110 net/core/sock.c:3049
 l2cap_sock_teardown_cb+0xa1/0x660 net/bluetooth/l2cap_sock.c:1520
 l2cap_chan_del+0xbc/0xa80 net/bluetooth/l2cap_core.c:618
 l2cap_chan_close+0x1bc/0xaf0 net/bluetooth/l2cap_core.c:823
 l2cap_chan_timeout+0x17e/0x2f0 net/bluetooth/l2cap_core.c:436
 process_one_work+0x98d/0x15f0 kernel/workqueue.c:2275
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
