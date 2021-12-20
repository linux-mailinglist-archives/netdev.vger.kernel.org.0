Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 241E547B121
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 17:33:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238256AbhLTQd1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 11:33:27 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:40459 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238238AbhLTQd0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 11:33:26 -0500
Received: by mail-io1-f72.google.com with SMTP id d12-20020a0566022d4c00b005ebda1035b1so7418015iow.7
        for <netdev@vger.kernel.org>; Mon, 20 Dec 2021 08:33:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=OWl8IqkEe6OQ3NoMzT2jKNMg3ANYUfrpYcjnt7QOHjU=;
        b=gnCnjkAPObgdKOpopDFiVYhFzmWM3Wat0V11+aSzbTytMKNRJNDbtEgAZ/dVmmWz+M
         GOK5wKBC0jtJPwAvmFylWhm5qlhCPw2sK6HoltibkNVuVe5tUNeEDSZdPA6wTrdyYaTH
         RmI/UonBMQyGdpu27EkQ+ReQzueP3goNBMoijsWdGL7PvPzOSmal3oPWVpnN7AGB7zNy
         ZWNtA/iSHD/Gu0EQac6dTB6mhFAt9gIfv4L55YZS2qaFcOT0upp21Nl+3hog1GCshmnu
         KZF0mGvwJBJdS/+CoCa5o6tQXoCSF1f8LTynNmJz22a3GPhihIZJn5tyLR762XX7yxPR
         QcBg==
X-Gm-Message-State: AOAM533gwK/O/dNbUg41I0rWR8d5uqif45xwzGmq35KPHMRsXFRvsY3Y
        14GHb5FU2GK/nS4UxoikUYEIfHrRLI17SebOAyTemC8KzAUQ
X-Google-Smtp-Source: ABdhPJwEgVPP9VnoS1clFZZYGPSVttbjCw84l/MMrlPCl1pB4FM0f8NFdQeS4WukMV6Q+LaQ/li7XRRgRXkARL78CJsI3O4wJmUE
MIME-Version: 1.0
X-Received: by 2002:a92:cac2:: with SMTP id m2mr9191921ilq.195.1640018005762;
 Mon, 20 Dec 2021 08:33:25 -0800 (PST)
Date:   Mon, 20 Dec 2021 08:33:25 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a8a64205d39672b8@google.com>
Subject: [syzbot] KMSAN: kernel-infoleak in move_addr_to_user (6)
From:   syzbot <syzbot+cdbd40e0c3ca02cae3b7@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, glider@google.com,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    b0a8b5053e8b kmsan: core: add dependency on DEBUG_KERNEL
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=14a45071b00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=46a956fc7a887c60
dashboard link: https://syzkaller.appspot.com/bug?extid=cdbd40e0c3ca02cae3b7
compiler:       clang version 14.0.0 (/usr/local/google/src/llvm-git-monorepo 2b554920f11c8b763cd9ed9003f4e19b919b8e1f), GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1343f443b00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16efa493b00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+cdbd40e0c3ca02cae3b7@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: kernel-infoleak in instrument_copy_to_user include/linux/instrumented.h:121 [inline]
BUG: KMSAN: kernel-infoleak in instrument_copy_to_user include/linux/instrumented.h:121 [inline] lib/usercopy.c:33
BUG: KMSAN: kernel-infoleak in _copy_to_user+0x1c9/0x270 lib/usercopy.c:33 lib/usercopy.c:33
 instrument_copy_to_user include/linux/instrumented.h:121 [inline]
 instrument_copy_to_user include/linux/instrumented.h:121 [inline] lib/usercopy.c:33
 _copy_to_user+0x1c9/0x270 lib/usercopy.c:33 lib/usercopy.c:33
 copy_to_user include/linux/uaccess.h:209 [inline]
 copy_to_user include/linux/uaccess.h:209 [inline] net/socket.c:287
 move_addr_to_user+0x3f6/0x600 net/socket.c:287 net/socket.c:287
 __sys_getpeername+0x470/0x6b0 net/socket.c:1987 net/socket.c:1987
 __do_sys_getpeername net/socket.c:1997 [inline]
 __se_sys_getpeername net/socket.c:1994 [inline]
 __do_sys_getpeername net/socket.c:1997 [inline] net/socket.c:1994
 __se_sys_getpeername net/socket.c:1994 [inline] net/socket.c:1994
 __x64_sys_getpeername+0xda/0x120 net/socket.c:1994 net/socket.c:1994
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_x64 arch/x86/entry/common.c:51 [inline] arch/x86/entry/common.c:82
 do_syscall_64+0x54/0xd0 arch/x86/entry/common.c:82 arch/x86/entry/common.c:82
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Uninit was stored to memory at:
 tipc_getname+0x575/0x5e0 net/tipc/socket.c:757 net/tipc/socket.c:757
 __sys_getpeername+0x3b3/0x6b0 net/socket.c:1984 net/socket.c:1984
 __do_sys_getpeername net/socket.c:1997 [inline]
 __se_sys_getpeername net/socket.c:1994 [inline]
 __do_sys_getpeername net/socket.c:1997 [inline] net/socket.c:1994
 __se_sys_getpeername net/socket.c:1994 [inline] net/socket.c:1994
 __x64_sys_getpeername+0xda/0x120 net/socket.c:1994 net/socket.c:1994
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_x64 arch/x86/entry/common.c:51 [inline] arch/x86/entry/common.c:82
 do_syscall_64+0x54/0xd0 arch/x86/entry/common.c:82 arch/x86/entry/common.c:82
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Uninit was stored to memory at:
 msg_set_word net/tipc/msg.h:212 [inline]
 msg_set_destport net/tipc/msg.h:619 [inline]
 msg_set_word net/tipc/msg.h:212 [inline] net/tipc/socket.c:1486
 msg_set_destport net/tipc/msg.h:619 [inline] net/tipc/socket.c:1486
 __tipc_sendmsg+0x44fa/0x5890 net/tipc/socket.c:1486 net/tipc/socket.c:1486
 tipc_sendmsg+0xeb/0x140 net/tipc/socket.c:1402 net/tipc/socket.c:1402
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg net/socket.c:724 [inline]
 sock_sendmsg_nosec net/socket.c:704 [inline] net/socket.c:2409
 sock_sendmsg net/socket.c:724 [inline] net/socket.c:2409
 ____sys_sendmsg+0xe11/0x12c0 net/socket.c:2409 net/socket.c:2409
 ___sys_sendmsg net/socket.c:2463 [inline]
 ___sys_sendmsg net/socket.c:2463 [inline] net/socket.c:2492
 __sys_sendmsg+0x704/0x840 net/socket.c:2492 net/socket.c:2492
 __do_sys_sendmsg net/socket.c:2501 [inline]
 __se_sys_sendmsg net/socket.c:2499 [inline]
 __do_sys_sendmsg net/socket.c:2501 [inline] net/socket.c:2499
 __se_sys_sendmsg net/socket.c:2499 [inline] net/socket.c:2499
 __x64_sys_sendmsg+0xe2/0x120 net/socket.c:2499 net/socket.c:2499
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_x64 arch/x86/entry/common.c:51 [inline] arch/x86/entry/common.c:82
 do_syscall_64+0x54/0xd0 arch/x86/entry/common.c:82 arch/x86/entry/common.c:82
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Local variable skaddr created at:
 __tipc_sendmsg+0x2d0/0x5890 net/tipc/socket.c:1419 net/tipc/socket.c:1419
 tipc_sendmsg+0xeb/0x140 net/tipc/socket.c:1402 net/tipc/socket.c:1402

Bytes 4-7 of 16 are uninitialized
Memory access of size 16 starts at ffff888113753e00
Data copied to user address 0000000020000280

CPU: 1 PID: 3479 Comm: syz-executor115 Not tainted 5.16.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
=====================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
