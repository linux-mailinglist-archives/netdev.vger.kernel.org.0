Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E24E43D3CF9
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 17:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235725AbhGWPOy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 11:14:54 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:49062 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235676AbhGWPOv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 11:14:51 -0400
Received: by mail-io1-f70.google.com with SMTP id w4-20020a5ec2440000b029053e3f025a44so1959857iop.15
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 08:55:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=jrEVoI183Kmw64l8qy1wZKHXIRYmyIqbXtBbkwNlUZY=;
        b=YLkouhPUkP+WvUl6M0GWMfa1cUGALUvOWCNihCEUcBX1jWsXyV6vaFBZ18cC4GzaFR
         bp7TrJX3QVH+twhonKGHAvTKuvctRkB1Mob/1ItXbZPKZ2HcGPfADxupXeo80TNtwmCW
         LWPQ6GDy7NSC5MDSTfAiXaxOO9h5NzJhdxigmlQZ3K44Vc/nh9sn8/7Cal3npTBXNHqZ
         4OZnDKjvUwvRAZiCQlbLf4PpxIMw2qmvONz2IV78DhjmzLkKP3tlF3Z+aIpnEq3o8A2x
         XKzKJ8Fcf2gBg96mtV3ClRFwAr469WOXUdMdO472sTRrppTygRliHj3NrrivwUg6hvZ9
         RRwg==
X-Gm-Message-State: AOAM531k6XXUmhBGY9qwu3t2lCLFXXA5qFOHCB4+2Z7cWf2/Tij9KbcU
        YM/YORxQq+ScoN/ivGDNK7EeVMd+8M5krRBBR+yC6ty0DF0P
X-Google-Smtp-Source: ABdhPJymrKiMmzSlvulLG5/vb/egL5Os45wshW6Wj0yEXXxrLSIF25GxB2eY1uphmCT3VKL5XqftjR/PRS8uLkhbrBIE4xyG1JRq
MIME-Version: 1.0
X-Received: by 2002:a5e:8619:: with SMTP id z25mr4488495ioj.13.1627055723368;
 Fri, 23 Jul 2021 08:55:23 -0700 (PDT)
Date:   Fri, 23 Jul 2021 08:55:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006bd5e505c7cc6ec3@google.com>
Subject: [syzbot] memory leak in can_create
From:   syzbot <syzbot+ba3c733fb22a7be2ce04@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org, mkl@pengutronix.de,
        netdev@vger.kernel.org, socketcan@hartkopp.net,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    2734d6c1b1a0 Linux 5.14-rc2
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=121ee3f2300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7384ed231a0fd986
dashboard link: https://syzkaller.appspot.com/bug?extid=ba3c733fb22a7be2ce04
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1200c812300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1608525a300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ba3c733fb22a7be2ce04@syzkaller.appspotmail.com

executing program
BUG: memory leak
unreferenced object 0xffff8881140ffc00 (size 1024):
  comm "syz-executor060", pid 8644, jiffies 4294942938 (age 13.010s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    1d 00 07 41 00 00 00 00 00 00 00 00 00 00 00 00  ...A............
  backtrace:
    [<ffffffff836d5d92>] kmalloc include/linux/slab.h:596 [inline]
    [<ffffffff836d5d92>] sk_prot_alloc+0xd2/0x1b0 net/core/sock.c:1808
    [<ffffffff836da5a0>] sk_alloc+0x30/0x3f0 net/core/sock.c:1861
    [<ffffffff83c8fd18>] can_create+0x108/0x300 net/can/af_can.c:158
    [<ffffffff836ce96b>] __sock_create+0x1ab/0x2b0 net/socket.c:1450
    [<ffffffff836d198f>] sock_create net/socket.c:1501 [inline]
    [<ffffffff836d198f>] __sys_socket+0x6f/0x140 net/socket.c:1543
    [<ffffffff836d1a7a>] __do_sys_socket net/socket.c:1552 [inline]
    [<ffffffff836d1a7a>] __se_sys_socket net/socket.c:1550 [inline]
    [<ffffffff836d1a7a>] __x64_sys_socket+0x1a/0x20 net/socket.c:1550
    [<ffffffff843b0915>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
    [<ffffffff843b0915>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
    [<ffffffff84400068>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff8881170d2340 (size 32):
  comm "syz-executor060", pid 8644, jiffies 4294942938 (age 13.010s)
  hex dump (first 32 bytes):
    b0 02 05 40 81 88 ff ff 00 00 00 00 00 00 00 00  ...@............
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff82167ee3>] kmalloc include/linux/slab.h:591 [inline]
    [<ffffffff82167ee3>] kzalloc include/linux/slab.h:721 [inline]
    [<ffffffff82167ee3>] apparmor_sk_alloc_security+0x53/0xd0 security/apparmor/lsm.c:785
    [<ffffffff8212d441>] security_sk_alloc+0x31/0x70 security/security.c:2261
    [<ffffffff836d5dad>] sk_prot_alloc+0xed/0x1b0 net/core/sock.c:1811
    [<ffffffff836da5a0>] sk_alloc+0x30/0x3f0 net/core/sock.c:1861
    [<ffffffff83c8fd18>] can_create+0x108/0x300 net/can/af_can.c:158
    [<ffffffff836ce96b>] __sock_create+0x1ab/0x2b0 net/socket.c:1450
    [<ffffffff836d198f>] sock_create net/socket.c:1501 [inline]
    [<ffffffff836d198f>] __sys_socket+0x6f/0x140 net/socket.c:1543
    [<ffffffff836d1a7a>] __do_sys_socket net/socket.c:1552 [inline]
    [<ffffffff836d1a7a>] __se_sys_socket net/socket.c:1550 [inline]
    [<ffffffff836d1a7a>] __x64_sys_socket+0x1a/0x20 net/socket.c:1550
    [<ffffffff843b0915>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
    [<ffffffff843b0915>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
    [<ffffffff84400068>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff88811344a100 (size 232):
  comm "syz-executor060", pid 8644, jiffies 4294942938 (age 13.010s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 2c 10 81 88 ff ff 00 fc 0f 14 81 88 ff ff  ..,.............
  backtrace:
    [<ffffffff836e0ebf>] __alloc_skb+0x20f/0x280 net/core/skbuff.c:414
    [<ffffffff836eb6fa>] alloc_skb include/linux/skbuff.h:1112 [inline]
    [<ffffffff836eb6fa>] alloc_skb_with_frags+0x6a/0x2b0 net/core/skbuff.c:6005
    [<ffffffff836d8fe3>] sock_alloc_send_pskb+0x353/0x3c0 net/core/sock.c:2461
    [<ffffffff83c9ee2f>] j1939_sk_alloc_skb net/can/j1939/socket.c:861 [inline]
    [<ffffffff83c9ee2f>] j1939_sk_send_loop net/can/j1939/socket.c:1043 [inline]
    [<ffffffff83c9ee2f>] j1939_sk_sendmsg+0x2cf/0x800 net/can/j1939/socket.c:1178
    [<ffffffff836cfb86>] sock_sendmsg_nosec net/socket.c:703 [inline]
    [<ffffffff836cfb86>] sock_sendmsg+0x56/0x80 net/socket.c:723
    [<ffffffff836d00ec>] ____sys_sendmsg+0x36c/0x390 net/socket.c:2392
    [<ffffffff836d413b>] ___sys_sendmsg+0x8b/0xd0 net/socket.c:2446
    [<ffffffff836d4238>] __sys_sendmsg+0x88/0x100 net/socket.c:2475
    [<ffffffff843b0915>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
    [<ffffffff843b0915>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
    [<ffffffff84400068>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff88811344aa00 (size 232):
  comm "syz-executor060", pid 8644, jiffies 4294942938 (age 13.010s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 2c 10 81 88 ff ff 00 fc 0f 14 81 88 ff ff  ..,.............
  backtrace:
    [<ffffffff836e0ebf>] __alloc_skb+0x20f/0x280 net/core/skbuff.c:414
    [<ffffffff836eb6fa>] alloc_skb include/linux/skbuff.h:1112 [inline]
    [<ffffffff836eb6fa>] alloc_skb_with_frags+0x6a/0x2b0 net/core/skbuff.c:6005
    [<ffffffff836d8fe3>] sock_alloc_send_pskb+0x353/0x3c0 net/core/sock.c:2461
    [<ffffffff83c9ee2f>] j1939_sk_alloc_skb net/can/j1939/socket.c:861 [inline]
    [<ffffffff83c9ee2f>] j1939_sk_send_loop net/can/j1939/socket.c:1043 [inline]
    [<ffffffff83c9ee2f>] j1939_sk_sendmsg+0x2cf/0x800 net/can/j1939/socket.c:1178
    [<ffffffff836cfb86>] sock_sendmsg_nosec net/socket.c:703 [inline]
    [<ffffffff836cfb86>] sock_sendmsg+0x56/0x80 net/socket.c:723
    [<ffffffff836d00ec>] ____sys_sendmsg+0x36c/0x390 net/socket.c:2392
    [<ffffffff836d413b>] ___sys_sendmsg+0x8b/0xd0 net/socket.c:2446
    [<ffffffff836d4238>] __sys_sendmsg+0x88/0x100 net/socket.c:2475
    [<ffffffff843b0915>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
    [<ffffffff843b0915>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
    [<ffffffff84400068>] entry_SYSCALL_64_after_hwframe+0x44/0xae



---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
