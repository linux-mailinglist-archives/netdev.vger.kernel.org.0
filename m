Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD25400869
	for <lists+netdev@lfdr.de>; Sat,  4 Sep 2021 01:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350532AbhICXvc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 19:51:32 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:57152 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236131AbhICXvb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 19:51:31 -0400
Received: by mail-io1-f70.google.com with SMTP id c22-20020a5d9a960000b029059c9e04cd63so434053iom.23
        for <netdev@vger.kernel.org>; Fri, 03 Sep 2021 16:50:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=E4DKx2x3qEqa/La398s4sWrvTl4Rrvl7+M4z46YI5nw=;
        b=JcvtDi/StCGH5v0mNciIIi+/geF9VyePvHLv+2wSGE5R6D374/Zl8Y/Hfq+Zv6hKPP
         wuRPGqMizp1ah0u8+v26F0e5mzDXjdOrbV0iIY8CeF1uZ5yxgwWGkX2YZE971ScRoW8S
         8RBpBKqgqta4+tX3sIQBJrgnotlEH0jwykn56hOopUgvqCSC0fkPLNj4Qc3oXNJc0w2M
         2Q12ari4HYAocDGVuUXny1JXKdz0UGbaF6uRwyvlL87fZSwXg/icvZ0A8mCGpDBaNDtq
         mOk4sFcLgRsFWOC5vG6aXOEeWnJQQ/EtcAaNZNy9EPqR6Drc2+TwSRqsdLYBU2xQMOaF
         h09g==
X-Gm-Message-State: AOAM531c2WWnS+zxPf+GE8NBchRt+ouGkeuuWHYFBhhyBlXNiil1ZggJ
        5yu+SxoG0mg47PKb+Y7ebi2D6ZQXQRUbJC7RvcPM6Aqho45A
X-Google-Smtp-Source: ABdhPJzSeGhr37gFeiCKruL8NhBCmPy1C8w+hqnxOiKGXVriffaHMbUj5Y+WfrPbf599kIzjB1187p6UDgJKxMmCZe0mjYkUQVJE
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:144:: with SMTP id j4mr1033579ilr.75.1630713030517;
 Fri, 03 Sep 2021 16:50:30 -0700 (PDT)
Date:   Fri, 03 Sep 2021 16:50:30 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ea2f2605cb1ff6f6@google.com>
Subject: [syzbot] WARNING: kmalloc bug in hash_ip_create
From:   syzbot <syzbot+3493b1873fb3ea827986@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    a9c9a6f741cd Merge tag 'scsi-misc' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13246f25300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7860a0536ececf0c
dashboard link: https://syzkaller.appspot.com/bug?extid=3493b1873fb3ea827986
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11602f35300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10e8fbf5300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3493b1873fb3ea827986@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 8430 at mm/util.c:597 kvmalloc_node+0x111/0x120 mm/util.c:597
Modules linked in:
CPU: 1 PID: 8430 Comm: syz-executor792 Not tainted 5.14.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:kvmalloc_node+0x111/0x120 mm/util.c:597
Code: 01 00 00 00 4c 89 e7 e8 8d 12 0d 00 49 89 c5 e9 69 ff ff ff e8 f0 21 d1 ff 41 89 ed 41 81 cd 00 20 01 00 eb 95 e8 df 21 d1 ff <0f> 0b e9 4c ff ff ff 0f 1f 84 00 00 00 00 00 55 48 89 fd 53 e8 c6
RSP: 0018:ffffc9000108f280 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffffc9000108f3a0 RCX: 0000000000000000
RDX: ffff88801bfd5580 RSI: ffffffff81a4f621 RDI: 0000000000000003
RBP: 0000000000400dc0 R08: 000000007fffffff R09: 00000000ffffffff
R10: ffffffff81a4f5de R11: 000000000000001f R12: 0000000200000018
R13: 0000000000000000 R14: 00000000ffffffff R15: ffff888028b41a00
FS:  0000000002409300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000006 CR3: 00000000127f1000 CR4: 0000000000350ee0
Call Trace:
 hash_ip_create+0x4bb/0x13d0 net/netfilter/ipset/ip_set_hash_gen.h:1524
 ip_set_create+0x782/0x15a0 net/netfilter/ipset/ip_set_core.c:1100
 nfnetlink_rcv_msg+0xbc9/0x13f0 net/netfilter/nfnetlink.c:296
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
 nfnetlink_rcv+0x1ac/0x420 net/netfilter/nfnetlink.c:654
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:724
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2409
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2463
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2492
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x43f029
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd662e8c48 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000400488 RCX: 000000000043f029
RDX: 0000000000000000 RSI: 00000000200000c0 RDI: 0000000000000003
RBP: 0000000000403010 R08: 0000000000000005 R09: 0000000000400488
R10: 0000000000000001 R11: 0000000000000246 R12: 00000000004030a0
R13: 0000000000000000 R14: 00000000004ac018 R15: 0000000000400488


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
