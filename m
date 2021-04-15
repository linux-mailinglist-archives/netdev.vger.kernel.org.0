Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0973036057C
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 11:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231200AbhDOJUi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 05:20:38 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:56008 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbhDOJUh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 05:20:37 -0400
Received: by mail-il1-f200.google.com with SMTP id v1-20020a92d2410000b02901533f3ed5dbso3589340ilg.22
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 02:20:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=TKWxKlxzNvpkHVwpq2ENPdqKLi0cVgaRRb7P7JYoqUE=;
        b=MciwlGWvVHZeQA01mhXTbmbKN3TUx3ygTuuheKN1osasmxMI54F/R0HdGXP+PLA6aj
         XCKQ4+g3J3HyccaLmSAVV5B4GKRKE98tXcLOmzzNi+5OPXn9DprwSzb02IhGPogVCsdO
         hc+513uglntzjvL7AQhqn1HGJ+Dq0a5bpxCNWAzawjuDpGqybZ6sAF8GMOIlrYn+6Uft
         x1s8AkAQfvK/dn6a5kDF8uFAqa0KSLSwLrBLcI5qhvOeRVNyMZykmzA5E9YefUQb81Jp
         685CPE7MTJ8ddZ2dbBg57n7TlweuhOWuN8Esc2WQJ7kpzSilrvhIbCTfYTYtBpwXE/kF
         BBfw==
X-Gm-Message-State: AOAM530FvtfcNI5luvcbg496BaxMy7fZWYvVYIEAPc9r9MotyMeK/zrw
        8ylB091Ni3Ji+t/r5fUQrUmDhoicfs360gfnu/J5DcLYxrqr
X-Google-Smtp-Source: ABdhPJxq6orZYNnkZxH1VeQZa1M+8mZNmke50bqtwk7DdZ9QLFhbsiazhuSTimW1RIMtU+mT8d1H1edxH7tJu4Dr0appJLyoc/40
MIME-Version: 1.0
X-Received: by 2002:a92:d712:: with SMTP id m18mr2093767iln.127.1618478414709;
 Thu, 15 Apr 2021 02:20:14 -0700 (PDT)
Date:   Thu, 15 Apr 2021 02:20:14 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000fc4bc305bfff5e42@google.com>
Subject: [syzbot] INFO: trying to register non-static key in nfc_llcp_sock_unlink
From:   syzbot <syzbot+0b2182efb62fe1a7e162@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    50987bec Merge tag 'trace-v5.12-rc7' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14d2cab1d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b5591c832f889fd9
dashboard link: https://syzkaller.appspot.com/bug?extid=0b2182efb62fe1a7e162

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+0b2182efb62fe1a7e162@syzkaller.appspotmail.com

INFO: trying to register non-static key.
The code is fine but needs lockdep annotation, or maybe
you didn't initialize this object before use?
turning off the locking correctness validator.
CPU: 3 PID: 10363 Comm: syz-executor.3 Not tainted 5.12.0-rc7-syzkaller #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2 04/01/2014
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x141/0x1d7 lib/dump_stack.c:120
 assign_lock_key kernel/locking/lockdep.c:936 [inline]
 register_lock_class+0x1077/0x1180 kernel/locking/lockdep.c:1248
 __lock_acquire+0x106/0x54c0 kernel/locking/lockdep.c:4780
 lock_acquire kernel/locking/lockdep.c:5511 [inline]
 lock_acquire+0x1ab/0x740 kernel/locking/lockdep.c:5476
 __raw_write_lock include/linux/rwlock_api_smp.h:210 [inline]
 _raw_write_lock+0x2a/0x40 kernel/locking/spinlock.c:295
 nfc_llcp_sock_unlink+0x1d/0x1c0 net/nfc/llcp_core.c:32
 llcp_sock_release+0x286/0x580 net/nfc/llcp_sock.c:640
 __sock_release+0xcd/0x280 net/socket.c:599
 sock_close+0x18/0x20 net/socket.c:1258
 __fput+0x288/0x920 fs/file_table.c:280
 task_work_run+0xdd/0x1a0 kernel/task_work.c:140
 exit_task_work include/linux/task_work.h:30 [inline]
 do_exit+0xbfc/0x2a60 kernel/exit.c:825
 do_group_exit+0x125/0x310 kernel/exit.c:922
 get_signal+0x47f/0x2150 kernel/signal.c:2781
 arch_do_signal_or_restart+0x2a8/0x1eb0 arch/x86/kernel/signal.c:789
 handle_signal_work kernel/entry/common.c:147 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
 exit_to_user_mode_prepare+0x148/0x250 kernel/entry/common.c:208
 __syscall_exit_to_user_mode_work kernel/entry/common.c:290 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:301
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x466459
Code: Unable to access opcode bytes at RIP 0x46642f.
RSP: 002b:00007fddc86a8218 EFLAGS: 00000246
 ORIG_RAX: 00000000000000ca
RAX: fffffffffffffe00 RBX: 000000000056bf68 RCX: 0000000000466459
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 000000000056bf68
RBP: 000000000056bf60 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf6c
R13: 00007fff5b1ed3ff R14: 00007fddc86a8300 R15: 0000000000022000
------------[ cut here ]------------
refcount_t: underflow; use-after-free.
WARNING: CPU: 3 PID: 10363 at lib/refcount.c:28 refcount_warn_saturate+0x1d1/0x1e0 lib/refcount.c:28
Modules linked in:

CPU: 3 PID: 10363 Comm: syz-executor.3 Not tainted 5.12.0-rc7-syzkaller #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2 04/01/2014
RIP: 0010:refcount_warn_saturate+0x1d1/0x1e0 lib/refcount.c:28
Code: e9 db fe ff ff 48 89 df e8 4c c7 ed fd e9 8a fe ff ff e8 22 98 aa fd 48 c7 c7 c0 47 c1 89 c6 05 c4 30 e8 09 01 e8 14 a5 f9 04 <0f> 0b e9 af fe ff ff 0f 1f 84 00 00 00 00 00 41 56 41 55 41 54 55
RSP: 0000:ffffc90000f77958 EFLAGS: 00010282
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff888025e5a200 RSI: ffffffff815b8155 RDI: fffff520001eef1d
RBP: 0000000000000003 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff815b0ebe R11: 0000000000000000 R12: 0000000000000000
R13: ffff888044a19018 R14: ffff888044a19000 R15: ffff888022a6d330
FS:  0000000000000000(0000) GS:ffff88802ca00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f69397f80d8 CR3: 000000000bc8e000 CR4: 0000000000150ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 __refcount_sub_and_test include/linux/refcount.h:283 [inline]
 __refcount_dec_and_test include/linux/refcount.h:315 [inline]
 refcount_dec_and_test include/linux/refcount.h:333 [inline]
 kref_put include/linux/kref.h:64 [inline]
 nfc_llcp_local_put net/nfc/llcp_core.c:183 [inline]
 nfc_llcp_local_put+0x1ab/0x200 net/nfc/llcp_core.c:178
 llcp_sock_destruct+0x81/0x150 net/nfc/llcp_sock.c:950
 __sk_destruct+0x4b/0x900 net/core/sock.c:1795
 sk_destruct+0xbd/0xe0 net/core/sock.c:1839
 __sk_free+0xef/0x3d0 net/core/sock.c:1850
 sk_free+0x78/0xa0 net/core/sock.c:1861
 sock_put include/net/sock.h:1807 [inline]
 llcp_sock_release+0x3c9/0x580 net/nfc/llcp_sock.c:644
 __sock_release+0xcd/0x280 net/socket.c:599
 sock_close+0x18/0x20 net/socket.c:1258
 __fput+0x288/0x920 fs/file_table.c:280
 task_work_run+0xdd/0x1a0 kernel/task_work.c:140
 exit_task_work include/linux/task_work.h:30 [inline]
 do_exit+0xbfc/0x2a60 kernel/exit.c:825
 do_group_exit+0x125/0x310 kernel/exit.c:922
 get_signal+0x47f/0x2150 kernel/signal.c:2781
 arch_do_signal_or_restart+0x2a8/0x1eb0 arch/x86/kernel/signal.c:789
 handle_signal_work kernel/entry/common.c:147 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
 exit_to_user_mode_prepare+0x148/0x250 kernel/entry/common.c:208
 __syscall_exit_to_user_mode_work kernel/entry/common.c:290 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:301
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x466459
Code: Unable to access opcode bytes at RIP 0x46642f.
RSP: 002b:00007fddc86a8218 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: fffffffffffffe00 RBX: 000000000056bf68 RCX: 0000000000466459
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 000000000056bf68
RBP: 000000000056bf60 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf6c
R13: 00007fff5b1ed3ff R14: 00007fddc86a8300 R15: 0000000000022000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
