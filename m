Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 537A1455929
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 11:37:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245687AbhKRKkf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 05:40:35 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:40517 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245708AbhKRKj0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 05:39:26 -0500
Received: by mail-il1-f198.google.com with SMTP id d8-20020a928748000000b0027585828bc3so3753963ilm.7
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 02:36:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=S+hZjFERYaau081nQLDIk+XVoTNXbx6u415PGYVVeHs=;
        b=aFCgNXqhSIWpjx/nvvwGMx3h8v1SSaE+/dkfsgYMxF1SNVPeqHqMylM2K5hSTfMfHd
         cZSf4nsTp9c45OYELjo3GunNXUT5toN3d8SvJIDJCJb79iohtDt/c2Wf/e42XqkVT0cg
         6lI5cF38szm8Wyax9AW166Vq+5RQNT7Q7vfcSKOdn+jAinCIwOa/xf6oyHzj6xkRs1pV
         xg4mZxZverNaDYTKEZIZ/ZznLls26GDzO+gLomwcuBzM0T/J9d6MjtEovyDQP+08bM5P
         FIhB+Refg0shi9R+yVwpZL4HR5+qZoWAmL7+U+lbzXwvxHoNzFCA75wonIXtbLOY8C2M
         hk1w==
X-Gm-Message-State: AOAM533OEHwlYOU38rxYJl2O6EWOEnPJRaw4Fz5wNxpRiDsOeSmA0LZk
        /9+HtVmUbiQ7s2gMEODJ3ZTsLa9vEdM7+n/nDoLK1IqIkOm0
X-Google-Smtp-Source: ABdhPJyeDLvfzOSKR4ho0K/xNgaGX2Onqw53w4ffa4yw9VbumzBRC2NcioErWsXXdKfcYf9JQv3JgPL8Oh9ss91iksxBTF8hb1E7
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1749:: with SMTP id y9mr15060210ill.232.1637231786114;
 Thu, 18 Nov 2021 02:36:26 -0800 (PST)
Date:   Thu, 18 Nov 2021 02:36:26 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000006c24a05d10dbb7f@google.com>
Subject: [syzbot] WARNING: refcount bug in nr_release (3)
From:   syzbot <syzbot+342c8cfbf3eb29cb36e8@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org, linux-hams@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        ralf@linux-mips.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    f2e19fd15bd7 Add linux-next specific files for 20211112
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=14de0821b00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ba9c83199208e103
dashboard link: https://syzkaller.appspot.com/bug?extid=342c8cfbf3eb29cb36e8
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+342c8cfbf3eb29cb36e8@syzkaller.appspotmail.com

------------[ cut here ]------------
refcount_t: addition on 0; use-after-free.
WARNING: CPU: 0 PID: 13624 at lib/refcount.c:25 refcount_warn_saturate+0x169/0x1e0 lib/refcount.c:25
Modules linked in:
CPU: 0 PID: 13624 Comm: syz-executor.4 Not tainted 5.15.0-next-20211112-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:refcount_warn_saturate+0x169/0x1e0 lib/refcount.c:25
Code: 09 31 ff 89 de e8 27 70 a0 fd 84 db 0f 85 36 ff ff ff e8 3a 6c a0 fd 48 c7 c7 a0 5f 04 8a c6 05 0e 1e a5 09 01 e8 de 4d 34 05 <0f> 0b e9 17 ff ff ff e8 1b 6c a0 fd 0f b6 1d f3 1d a5 09 31 ff 89
RSP: 0018:ffffc9000282fa70 EFLAGS: 00010286
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff88802c4fd7c0 RSI: ffffffff815f5c98 RDI: fffff52000505f40
RBP: 0000000000000002 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff815efa3e R11: 0000000000000000 R12: ffff88803cd1c200
R13: ffff88803c3d7080 R14: ffff88803cd1c218 R15: ffff888011a4a620
FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffdbaf50df8 CR3: 0000000022a02000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 __refcount_add include/linux/refcount.h:199 [inline]
 __refcount_inc include/linux/refcount.h:250 [inline]
 refcount_inc include/linux/refcount.h:267 [inline]
 sock_hold include/net/sock.h:708 [inline]
 nr_release+0x3d1/0x450 net/netrom/af_netrom.c:520
 __sock_release+0xcd/0x280 net/socket.c:649
 sock_close+0x18/0x20 net/socket.c:1314
 __fput+0x286/0x9f0 fs/file_table.c:280
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164
 exit_task_work include/linux/task_work.h:32 [inline]
 do_exit+0xc14/0x2b40 kernel/exit.c:832
 do_group_exit+0x125/0x310 kernel/exit.c:929
 get_signal+0x47d/0x2220 kernel/signal.c:2830
 arch_do_signal_or_restart+0x2a9/0x1c40 arch/x86/kernel/signal.c:868
 handle_signal_work kernel/entry/common.c:148 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
 exit_to_user_mode_prepare+0x17d/0x290 kernel/entry/common.c:207
 __syscall_exit_to_user_mode_work kernel/entry/common.c:289 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:300
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f8de835cae9
Code: Unable to access opcode bytes at RIP 0x7f8de835cabf.
RSP: 002b:00007f8de58d2218 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: fffffffffffffe00 RBX: 00007f8de846ff68 RCX: 00007f8de835cae9
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00007f8de846ff68
RBP: 00007f8de846ff60 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f8de846ff6c
R13: 00007ffc7f8041ff R14: 00007f8de58d2300 R15: 0000000000022000
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
