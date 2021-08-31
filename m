Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F07A93FC5EB
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 13:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241045AbhHaKhb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 06:37:31 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:48912 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233660AbhHaKhS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 06:37:18 -0400
Received: by mail-io1-f71.google.com with SMTP id z26-20020a05660200da00b005b86e36a1f4so4375944ioe.15
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 03:36:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=2qd5l81swi+xRw37GGw82lqKntZQqf/pXfsBP2WkvJI=;
        b=L3rV/yQZ7KZ4MZXu/by0RhPNYqACsd1Xr6/3gSpK5YrOqxGFu/5jyh1E8XBSMM6Na3
         mzbvW1Rq36TeKjSFTCDf0m0uXpVIC2iaaJovY97ktBZtbdo6AWTtXDSjaVq2bf7UMbiK
         adQb3mJ/0MvmBpJ5XpXnrJb9TvPEqvAOa6zqXDFsI8gz6gyZrBy/fX+RZ8PrWzBCqOeZ
         v7anqTn4y9IMpOhcqttoKzSjG60nXlOxl1Yy2PTGZ4YYjt/SY50yLA5tmO1lyRXBC7rF
         CY5xl1eIyxuJTA1SDeGX6nPBBYvnjBhBGTOpm6F4Gobcta3ahCxVORjEy5XuBt+t+lqx
         kVEQ==
X-Gm-Message-State: AOAM5335Zc0q4h5u4GXxGXDI8SOUIsKRa6mSb/h4hCxQT9kffxDC9V8D
        p6QSfjSSuTp2D9yk8McmIgu/wlj9XZk0IVOZU0PhFu7917vv
X-Google-Smtp-Source: ABdhPJz4rBzzNikjOjsztr7lQys04ZKpKbcUXSuij/fKhSA82oPZ+9CIpIBV8UWBQPaHrthpepM3sNcWtsXVwAc9b62eZhDX1XI8
MIME-Version: 1.0
X-Received: by 2002:a92:611:: with SMTP id x17mr19317931ilg.41.1630406183351;
 Tue, 31 Aug 2021 03:36:23 -0700 (PDT)
Date:   Tue, 31 Aug 2021 03:36:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000065fe6705cad8850e@google.com>
Subject: [syzbot] WARNING in j1939_session_deactivate
From:   syzbot <syzbot+535e5aae63c0d0433473@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kernel@pengutronix.de, kuba@kernel.org,
        linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux@rempel-privat.de, mkl@pengutronix.de, netdev@vger.kernel.org,
        robin@protonic.nl, socketcan@hartkopp.net,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    1a6436f37512 Merge tag 'mmc-v5.14-rc7' of git://git.kernel..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11f1f6a9300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=765eea9a273a8879
dashboard link: https://syzkaller.appspot.com/bug?extid=535e5aae63c0d0433473
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17193c4d300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12d86fd5300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+535e5aae63c0d0433473@syzkaller.appspotmail.com

vcan0: j1939_xtp_rx_abort_one: 0xffff888040cd1c00: 0x00000: (3) A timeout occurred and this is the connection abort to close the session.
vcan0: j1939_xtp_rx_abort_one: 0xffff88802a973400: 0x00000: (3) A timeout occurred and this is the connection abort to close the session.
------------[ cut here ]------------
WARNING: CPU: 0 PID: 13 at net/can/j1939/transport.c:1085 j1939_session_deactivate+0xaf/0xd0 net/can/j1939/transport.c:1085
Modules linked in:
CPU: 0 PID: 13 Comm: ksoftirqd/0 Not tainted 5.14.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:j1939_session_deactivate+0xaf/0xd0 net/can/j1939/transport.c:1085
Code: fd 01 76 21 e8 d2 4c 68 f9 48 89 ef e8 2a fc ff ff 4c 89 e7 41 89 c5 e8 5f ca 1f 01 44 89 e8 5d 41 5c 41 5d c3 e8 b1 4c 68 f9 <0f> 0b eb d6 4c 89 ef e8 d5 86 ae f9 eb b5 48 89 ef e8 db 86 ae f9
RSP: 0018:ffffc90000d27990 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000003 RCX: 0000000000000100
RDX: ffff888010a60000 RSI: ffffffff880d5c3f RDI: 0000000000000003
RBP: ffff88802a973400 R08: 0000000000000001 R09: ffff88802a97342b
R10: ffffffff880d5c13 R11: 0000000000000003 R12: ffff888042005070
R13: 0000000000000001 R14: ffff88802bd11418 R15: ffffffff8a9ecde0
FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000200 CR3: 000000000b68e000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 j1939_session_deactivate_activate_next+0x12/0x35 net/can/j1939/transport.c:1095
 j1939_xtp_rx_abort_one.cold+0x205/0x321 net/can/j1939/transport.c:1329
 j1939_xtp_rx_abort net/can/j1939/transport.c:1340 [inline]
 j1939_tp_cmd_recv net/can/j1939/transport.c:2068 [inline]
 j1939_tp_recv+0x488/0xb40 net/can/j1939/transport.c:2098
 j1939_can_recv+0x6d7/0x930 net/can/j1939/main.c:101
 deliver net/can/af_can.c:574 [inline]
 can_rcv_filter+0x5d4/0x8d0 net/can/af_can.c:608
 can_receive+0x31d/0x580 net/can/af_can.c:665
 can_rcv+0x120/0x1c0 net/can/af_can.c:696
 __netif_receive_skb_one_core+0x114/0x180 net/core/dev.c:5498
 __netif_receive_skb+0x24/0x1b0 net/core/dev.c:5612
 process_backlog+0x2a5/0x6c0 net/core/dev.c:6492
 __napi_poll+0xaf/0x440 net/core/dev.c:7047
 napi_poll net/core/dev.c:7114 [inline]
 net_rx_action+0x801/0xb40 net/core/dev.c:7201
 __do_softirq+0x29b/0x9c2 kernel/softirq.c:558
 run_ksoftirqd kernel/softirq.c:920 [inline]
 run_ksoftirqd+0x2d/0x60 kernel/softirq.c:912
 smpboot_thread_fn+0x645/0x9c0 kernel/smpboot.c:164
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
