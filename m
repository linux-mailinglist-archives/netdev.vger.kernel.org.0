Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0070423C5A5
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 08:17:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727961AbgHEGRa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 02:17:30 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:46558 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727783AbgHEGRX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 02:17:23 -0400
Received: by mail-io1-f72.google.com with SMTP id n1so17621370ion.13
        for <netdev@vger.kernel.org>; Tue, 04 Aug 2020 23:17:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=di6vgA1QwvKcuaK4zAt5UtCoArB7tUveaatpD9fjTvM=;
        b=QbWThdD9jY17MzL3DTLyVxB84j/JeAsFXfjj5tkcOKC54UelbziCGDGlymKu6M5AyM
         5R23dcnyZzVuZujYO47+nFsdqzykiwi2DTfyIvLF07Av6MKsQAL9erESu98chBnAFgZV
         EldjmSnp/W/xk2cO8cK3onMpv2Ooo5TR218d8b7redByYrUlqHACq0Lf/j4dUqIaUlnE
         UhCG+hQh7DHD+xEN73owwXMiUIhcrnS00WBpJnfdpsPpWLrdWMrkrpNLM52GCn9jVNXZ
         uRHCWqlRn4n9y2ubI7ty83U19fki/uTb1ypgD/AtNdHdwgozWBGoLDrLNo37m1HMSEBd
         CGWQ==
X-Gm-Message-State: AOAM5318nAyFaTztIIiKFjnEFAfD7wTbKwsZSv9YWZBhVdDd+AtUG4Hy
        PdGd12EKPEaHxAqkkbyaC4HVcQOPg9g4g0HcrriOUx/uZOc4
X-Google-Smtp-Source: ABdhPJw7CeR8FScCQjTke99M/QZIjT4CWXzYncIR8c+ldAl42UTk0q7UGzeqpI+NBgeN3NmNaEMNkenJVSxmswwfEb6X1QBIHAn5
MIME-Version: 1.0
X-Received: by 2002:a05:6638:1313:: with SMTP id r19mr2355385jad.60.1596608242876;
 Tue, 04 Aug 2020 23:17:22 -0700 (PDT)
Date:   Tue, 04 Aug 2020 23:17:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000029856f05ac1b5335@google.com>
Subject: WARNING: locking bug in hci_dev_reset
From:   syzbot <syzbot+f456fc1d58a1f67c401f@syzkaller.appspotmail.com>
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

HEAD commit:    ac3a0c84 Merge git://git.kernel.org/pub/scm/linux/kernel/g..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=10887792900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c0cfcf935bcc94d2
dashboard link: https://syzkaller.appspot.com/bug?extid=f456fc1d58a1f67c401f
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=123baf04900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f456fc1d58a1f67c401f@syzkaller.appspotmail.com

------------[ cut here ]------------
DEBUG_LOCKS_WARN_ON(1)
WARNING: CPU: 0 PID: 22435 at kernel/locking/lockdep.c:183 hlock_class kernel/locking/lockdep.c:183 [inline]
WARNING: CPU: 0 PID: 22435 at kernel/locking/lockdep.c:183 hlock_class kernel/locking/lockdep.c:172 [inline]
WARNING: CPU: 0 PID: 22435 at kernel/locking/lockdep.c:183 check_wait_context kernel/locking/lockdep.c:4054 [inline]
WARNING: CPU: 0 PID: 22435 at kernel/locking/lockdep.c:183 __lock_acquire+0x1629/0x56e0 kernel/locking/lockdep.c:4330
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 22435 Comm: syz-executor.2 Not tainted 5.8.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 panic+0x2e3/0x75c kernel/panic.c:231
 __warn.cold+0x20/0x45 kernel/panic.c:600
 report_bug+0x1bd/0x210 lib/bug.c:198
 handle_bug+0x38/0x90 arch/x86/kernel/traps.c:235
 exc_invalid_op+0x13/0x40 arch/x86/kernel/traps.c:255
 asm_exc_invalid_op+0x12/0x20 arch/x86/include/asm/idtentry.h:540
RIP: 0010:hlock_class kernel/locking/lockdep.c:183 [inline]
RIP: 0010:hlock_class kernel/locking/lockdep.c:172 [inline]
RIP: 0010:check_wait_context kernel/locking/lockdep.c:4054 [inline]
RIP: 0010:__lock_acquire+0x1629/0x56e0 kernel/locking/lockdep.c:4330
Code: 08 84 d2 0f 85 bd 35 00 00 8b 35 a2 a2 55 09 85 f6 0f 85 cc fa ff ff 48 c7 c6 20 b0 4b 88 48 c7 c7 20 ab 4b 88 e8 b9 44 eb ff <0f> 0b e9 b2 fa ff ff e8 3b a0 8e 06 85 c0 0f 84 ed fa ff ff 48 c7
RSP: 0018:ffffc90002a17810 EFLAGS: 00010086
RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000000
RDX: ffff8880949044c0 RSI: ffffffff815d4ef7 RDI: fffff52000542ef4
RBP: ffff888094904db8 R08: 0000000000000000 R09: ffffffff89bb5c23
R10: 0000000000000aea R11: 0000000000000001 R12: ffff8880949044c0
R13: 00000000000006d9 R14: ffff88809487c138 R15: 0000000000040000
 lock_acquire+0x1f1/0xad0 kernel/locking/lockdep.c:4959
 flush_workqueue+0x110/0x13e0 kernel/workqueue.c:2780
 drain_workqueue+0x1a5/0x3c0 kernel/workqueue.c:2945
 hci_dev_do_reset net/bluetooth/hci_core.c:1864 [inline]
 hci_dev_reset+0x23e/0x450 net/bluetooth/hci_core.c:1907
 hci_sock_ioctl+0x510/0x800 net/bluetooth/hci_sock.c:1036
 sock_do_ioctl+0xcb/0x2d0 net/socket.c:1048
 sock_ioctl+0x3b8/0x730 net/socket.c:1199
 vfs_ioctl fs/ioctl.c:48 [inline]
 ksys_ioctl+0x11a/0x180 fs/ioctl.c:753
 __do_sys_ioctl fs/ioctl.c:762 [inline]
 __se_sys_ioctl fs/ioctl.c:760 [inline]
 __x64_sys_ioctl+0x6f/0xb0 fs/ioctl.c:760
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45cce9
Code: 2d b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 fb b5 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fab01629c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 000000000001d300 RCX: 000000000045cce9
RDX: 0000000000000000 RSI: 00000000400448cb RDI: 0000000000000006
RBP: 000000000078c120 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000078c0ec
R13: 00007ffc2d1075ff R14: 00007fab0162a9c0 R15: 000000000078c0ec
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
