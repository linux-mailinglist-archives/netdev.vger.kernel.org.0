Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B7583DCDCA
	for <lists+netdev@lfdr.de>; Sun,  1 Aug 2021 22:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230368AbhHAUel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Aug 2021 16:34:41 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:39654 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbhHAUek (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Aug 2021 16:34:40 -0400
Received: by mail-io1-f72.google.com with SMTP id u22-20020a5d9f560000b02905058dc6c376so10233270iot.6
        for <netdev@vger.kernel.org>; Sun, 01 Aug 2021 13:34:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=2nTW78nne7YV4oteAEFI9yTUaPPtJoN/k/2jsa42cBY=;
        b=Po/mSmz4KYIvKyxbTX30OU9NOz8H08TxX3shC5VLU2mU5FUGJJGDrFJD74ITXTS5//
         XnDqDtHoLDJfirJeCpXj8Q1lys2K/Sbw9gwQCEO5xpcCqqfmMu4NCpzPsXRJCZf8z4tk
         Ll0iq1vE2QNQUyltYl/YHWD6DeRGfsJ5zjE3rDhDbdj0KAhCRFauWwBaMfai02veKVxc
         Qg2XQAA6WlBzOxB3ifcFySknNz6j3BwWHHDBCc5pMoM4WIxE5xedvfT1rPg8wIN/3UTn
         jKY0yAQQnlKcU+W8oPROW/Nk6xBwrht2kbKP+Doned7gQUdTkTw/c6jj/bj4Dkz7e3wu
         C5dQ==
X-Gm-Message-State: AOAM531sT38nc2SBHZEXVNEbwZZHki5p2sX0lR9NJ4lW69jzk8HvS//A
        IrS8nL5kGNata6hsIBMLs5c497n6CxU5Oh6ZkXSR0siMtXc2
X-Google-Smtp-Source: ABdhPJxDdf6F16NElNuv+EDK47lNPw3fQeOaF7nxq3ifv2BqJl98TAAKjzfueChD4GrxpBEUmzwcPcxRbhFxFWBRwujSY1OoaiFr
MIME-Version: 1.0
X-Received: by 2002:a02:7a18:: with SMTP id a24mr9031500jac.45.1627850072379;
 Sun, 01 Aug 2021 13:34:32 -0700 (PDT)
Date:   Sun, 01 Aug 2021 13:34:32 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004fd4c505c8856109@google.com>
Subject: [syzbot] general protection fault in br_switchdev_fdb_notify
From:   syzbot <syzbot+9ba1174359adba5a5b7c@syzkaller.appspotmail.com>
To:     bridge@lists.linux-foundation.org, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, nikolay@nvidia.com, roopa@nvidia.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    b11f0a4c0c81 net: dsa: sja1105: be stateless when installi..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=13b77662300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=914a8107c0ffdc14
dashboard link: https://syzkaller.appspot.com/bug?extid=9ba1174359adba5a5b7c
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1247bf2e300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=163c441a300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+9ba1174359adba5a5b7c@syzkaller.appspotmail.com

netdevsim netdevsim0 netdevsim1: set [1, 0] type 2 family 0 port 6081 - 0
netdevsim netdevsim0 netdevsim2: set [1, 0] type 2 family 0 port 6081 - 0
netdevsim netdevsim0 netdevsim3: set [1, 0] type 2 family 0 port 6081 - 0
general protection fault, probably for non-canonical address 0xdffffc0000000001: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
CPU: 1 PID: 8468 Comm: syz-executor865 Not tainted 5.14.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:br_switchdev_fdb_notify+0x2bf/0x340 net/bridge/br_switchdev.c:137
Code: c4 a8 00 00 00 5b 5d 41 5c 41 5d 41 5e 41 5f c3 e8 f6 fd 77 f9 49 8d 7e 08 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 75 71 4d 8b 6e 08 e9 4f ff ff ff e8 cd fd 77 f9 31 c9
RSP: 0018:ffffc9000186f360 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000001 RSI: ffffffff87fd8c8a RDI: 0000000000000008
RBP: 1ffff9200030de6d R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff87fd8bc7 R11: 0000000000000000 R12: 000000000000001c
R13: ffff88801d1c8c00 R14: 0000000000000000 R15: ffff888033cb93e8
FS:  0000000002147300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000000 CR3: 000000003756d000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 fdb_notify+0x159/0x190 net/bridge/br_fdb.c:798
 br_fdb_external_learn_add+0x2cc/0x5c0 net/bridge/br_fdb.c:1303
 __br_fdb_add+0x122/0xa40 net/bridge/br_fdb.c:1033
 br_fdb_add+0x8aa/0xcd0 net/bridge/br_fdb.c:1105
 rtnl_fdb_add+0x45f/0xad0 net/core/rtnetlink.c:4046
 rtnetlink_rcv_msg+0x413/0xb80 net/core/rtnetlink.c:5563
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
 sock_sendmsg_nosec net/socket.c:703 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:723
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2402
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2456
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2485
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x443239
Code: 28 c3 e8 4a 15 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffee38b3de8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007ffee38b3df8 RCX: 0000000000443239
RDX: 0000000000000000 RSI: 0000000020000040 RDI: 0000000000000003
RBP: 0000000000000003 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffee38b3e00
R13: 00007ffee38b3e20 R14: 00000000004b8018 R15: 00000000004004b8
Modules linked in:
---[ end trace aa1b885b5f5494d5 ]---
RIP: 0010:br_switchdev_fdb_notify+0x2bf/0x340 net/bridge/br_switchdev.c:137
Code: c4 a8 00 00 00 5b 5d 41 5c 41 5d 41 5e 41 5f c3 e8 f6 fd 77 f9 49 8d 7e 08 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 75 71 4d 8b 6e 08 e9 4f ff ff ff e8 cd fd 77 f9 31 c9
RSP: 0018:ffffc9000186f360 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000001 RSI: ffffffff87fd8c8a RDI: 0000000000000008
RBP: 1ffff9200030de6d R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff87fd8bc7 R11: 0000000000000000 R12: 000000000000001c
R13: ffff88801d1c8c00 R14: 0000000000000000 R15: ffff888033cb93e8
FS:  0000000002147300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000000 CR3: 000000003756d000 CR4: 00000000001506e0
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
