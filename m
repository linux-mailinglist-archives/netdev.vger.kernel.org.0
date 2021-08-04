Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C64C73E06B8
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 19:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239860AbhHDR2g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 13:28:36 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:43742 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239795AbhHDR2f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 13:28:35 -0400
Received: by mail-io1-f72.google.com with SMTP id d7-20020a6b6e070000b02904c0978ed194so1919066ioh.10
        for <netdev@vger.kernel.org>; Wed, 04 Aug 2021 10:28:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=JLUWnWN+fs3YDOLTIDChuY6GEfR/lEW2hNSnBNIgd4A=;
        b=JAtsQ3tGvKco147xorPpENnRstzC8u8Vi93Sx0SMrd+GyHhsvf0pPpY/RFPSW2bXUy
         rv5c+KXncTrwG/W2rzWIlqEQlP+G80sIj6o/H88diZQOQc8BaJEuLq2puUo3O5x9OS9v
         7BXOzF+vNLUKy3/fOQcUVg6dL1x0Whamf231N6mgyJnu9HjKm+ndiRRySlbdnjWnB7sZ
         thXdYwDlJxl+GKUo6INea0pDkB5ftj8qYZuLjKW/MFdghzK8Hm2wJhZnfaIlWJED2BLP
         gSF0G/2KRyJ3lgEQrREPpm+yoITTc7kTw64Ok0CTOZRUDBWeHG4z14S7dYRaowyD45pA
         3OpQ==
X-Gm-Message-State: AOAM532lC0ektVxxxLiZVomFRsfXlSVsKI0jv0u+OER9Nm4Ot58oJoSY
        R7Yy1Xfd9Jj1lbNiVB8YldNBEx6AcbFbo1SdiIEhgEwPTTLQ
X-Google-Smtp-Source: ABdhPJwVfsk65xG/Rmq41xdGxnTwkZFCsRjwGyGaXVJ92+klx0b1vk8ncl2sQPPTv0S1zdf6DOwsbyxOEUcOPtVcic1/kbdMFH4y
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1046:: with SMTP id p6mr555742ilj.155.1628098102114;
 Wed, 04 Aug 2021 10:28:22 -0700 (PDT)
Date:   Wed, 04 Aug 2021 10:28:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000009422905c8bf2102@google.com>
Subject: [syzbot] BUG: unable to handle kernel paging request in cap_capable
From:   syzbot <syzbot+79f4a8692e267bdb7227@syzkaller.appspotmail.com>
To:     jmorris@namei.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        serge@hallyn.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    b820c114eba7 net: fec: fix MAC internal delay doesn't work
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=11fbdd7a300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5e6797705e664e3b
dashboard link: https://syzkaller.appspot.com/bug?extid=79f4a8692e267bdb7227
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=127e4952300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16fef2aa300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+79f4a8692e267bdb7227@syzkaller.appspotmail.com

netdevsim netdevsim0 netdevsim1: set [1, 0] type 2 family 0 port 6081 - 0
netdevsim netdevsim0 netdevsim2: set [1, 0] type 2 family 0 port 6081 - 0
netdevsim netdevsim0 netdevsim3: set [1, 0] type 2 family 0 port 6081 - 0
BUG: unable to handle page fault for address: fffff3008f71a93b
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 0 P4D 0 
Oops: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 8445 Comm: syz-executor610 Not tainted 5.14.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:cap_capable+0xa0/0x280 security/commoncap.c:83
Code: 0f 8e d3 01 00 00 41 8b ad e0 00 00 00 49 bc 00 00 00 00 00 fc ff df e8 ce ef da fd 48 8d bb e0 00 00 00 48 89 f8 48 c1 e8 03 <42> 0f b6 04 20 84 c0 74 08 3c 03 0f 8e 64 01 00 00 44 8b bb e0 00
RSP: 0018:ffffc90001c3f9d8 EFLAGS: 00010a02
RAX: 1ffff7008f71a93b RBX: ffffb8047b8d48f8 RCX: 0000000000000000
RDX: ffff88802dad54c0 RSI: ffffffff839aad82 RDI: ffffb8047b8d49d8
RBP: 0000000000000000 R08: 0000000000000028 R09: ffffffff87f70fe6
R10: ffffffff814731be R11: 00000000000089a2 R12: dffffc0000000000
R13: ffffffff8b83b660 R14: ffff8880155fa500 R15: ffff8880155fa500
FS:  000000000105d300(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffff3008f71a93b CR3: 000000002789f000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 security_capable+0x5c/0xc0 security/security.c:805
 ns_capable_common kernel/capability.c:375 [inline]
 ns_capable+0x6f/0x100 kernel/capability.c:396
 add_del_if+0x9b/0x140 net/bridge/br_ioctl.c:89
 br_ioctl_stub+0x1c6/0x7f0 net/bridge/br_ioctl.c:397
 br_ioctl_call+0x5e/0xa0 net/socket.c:1092
 dev_ifsioc+0xc1f/0xf60 net/core/dev_ioctl.c:382
 dev_ioctl+0x1b9/0xee0 net/core/dev_ioctl.c:580
 sock_do_ioctl+0x18b/0x210 net/socket.c:1129
 sock_ioctl+0x2f1/0x640 net/socket.c:1232
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:1069 [inline]
 __se_sys_ioctl fs/ioctl.c:1055 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:1055
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4430a9
Code: 28 c3 e8 4a 15 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe266e8a48 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007ffe266e8a58 RCX: 00000000004430a9
RDX: 0000000020000080 RSI: 00000000000089a2 RDI: 0000000000000003
RBP: 0000000000000003 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffe266e8a60
R13: 00007ffe266e8a80 R14: 00000000004b8018 R15: 00000000004004b8
Modules linked in:
CR2: fffff3008f71a93b
---[ end trace 5ec5ff62110878d2 ]---
RIP: 0010:cap_capable+0xa0/0x280 security/commoncap.c:83
Code: 0f 8e d3 01 00 00 41 8b ad e0 00 00 00 49 bc 00 00 00 00 00 fc ff df e8 ce ef da fd 48 8d bb e0 00 00 00 48 89 f8 48 c1 e8 03 <42> 0f b6 04 20 84 c0 74 08 3c 03 0f 8e 64 01 00 00 44 8b bb e0 00
RSP: 0018:ffffc90001c3f9d8 EFLAGS: 00010a02
RAX: 1ffff7008f71a93b RBX: ffffb8047b8d48f8 RCX: 0000000000000000
RDX: ffff88802dad54c0 RSI: ffffffff839aad82 RDI: ffffb8047b8d49d8
RBP: 0000000000000000 R08: 0000000000000028 R09: ffffffff87f70fe6
R10: ffffffff814731be R11: 00000000000089a2 R12: dffffc0000000000
R13: ffffffff8b83b660 R14: ffff8880155fa500 R15: ffff8880155fa500
FS:  000000000105d300(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffff3008f71a93b CR3: 000000002789f000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
