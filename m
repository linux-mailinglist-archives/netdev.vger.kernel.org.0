Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31E1E40086B
	for <lists+netdev@lfdr.de>; Sat,  4 Sep 2021 01:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241254AbhICXvd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 19:51:33 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:36698 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236816AbhICXvb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 19:51:31 -0400
Received: by mail-io1-f69.google.com with SMTP id e187-20020a6bb5c4000000b005b5fe391cf9so489116iof.3
        for <netdev@vger.kernel.org>; Fri, 03 Sep 2021 16:50:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=GoYAXS68C6w1w241WimPZMhFnsezbmShwJ0ZtOemdb4=;
        b=q6Dgg6KHRnKj1Kh/WM574ZTzu2LnQ+HQ/HbHvDN7BxNkVHGEepvFEtF/HIEtpbebxq
         B1jarLHmneS8/OKvzSayRuZpsjWxdnMY39YfhGOfkyVoQW1bOttAmHFOWq6T08ucKucc
         VCNHuNZGJb8CYqSMxaktccueJ6MkWklcRcKXHnOV4VRr/PThqPT+Bcd91Hs5h/W9GfJy
         KmqucA16UjGXckbTBreFrOj0VG9HQuTvuWtRHzoiA1Kyn1xE022CRqatZ2IbxdCEbQQ0
         xBYsPuD56CS7RPIH8GdcxO3kFUOQh/DJkum0i5y5opU+LF5CUwfBJc4BcP3yarIoMBh8
         pDXQ==
X-Gm-Message-State: AOAM533Ve5J1t2EPVt025vTw+wrgKeG2ZiIU1VTCjzUhEgWxeJvI1kFc
        Vp7rK/pxpbYV60rTsH0f1+sDK13fF2lVtRZdyu5iXbKt0JCv
X-Google-Smtp-Source: ABdhPJw87NykjYA37TqFpgY59kbGvi6goCXSXYgumaO25s+RjAbuqKuZCBuk59kkhxdDqKvgtjf0DsXEVYewfcTw2NFgChyyhbIN
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:d05:: with SMTP id g5mr764028ilj.42.1630713030738;
 Fri, 03 Sep 2021 16:50:30 -0700 (PDT)
Date:   Fri, 03 Sep 2021 16:50:30 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ed8c0a05cb1ff6d8@google.com>
Subject: [syzbot] WARNING: kmalloc bug in nf_tables_newset
From:   syzbot <syzbot+cd43695a64bcd21b8596@syzkaller.appspotmail.com>
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
console output: https://syzkaller.appspot.com/x/log.txt?x=119f0915300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7860a0536ececf0c
dashboard link: https://syzkaller.appspot.com/bug?extid=cd43695a64bcd21b8596
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13281b33300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1077b4b9300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+cd43695a64bcd21b8596@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 8421 at mm/util.c:597 kvmalloc_node+0x111/0x120 mm/util.c:597
Modules linked in:
CPU: 1 PID: 8421 Comm: syz-executor968 Not tainted 5.14.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:kvmalloc_node+0x111/0x120 mm/util.c:597
Code: 01 00 00 00 4c 89 e7 e8 8d 12 0d 00 49 89 c5 e9 69 ff ff ff e8 f0 21 d1 ff 41 89 ed 41 81 cd 00 20 01 00 eb 95 e8 df 21 d1 ff <0f> 0b e9 4c ff ff ff 0f 1f 84 00 00 00 00 00 55 48 89 fd 53 e8 c6
RSP: 0018:ffffc90006f2f330 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff8880259c0000 RSI: ffffffff81a4f621 RDI: 0000000000000003
RBP: 0000000000000dc0 R08: 000000007fffffff R09: 00000000ffffffff
R10: ffffffff81a4f5de R11: 0000000000000000 R12: 0000000400000108
R13: 0000000000000000 R14: 00000000ffffffff R15: dffffc0000000000
FS:  0000000001785300(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f6394785000 CR3: 000000001dd56000 CR4: 0000000000350ef0
Call Trace:
 kvmalloc include/linux/mm.h:806 [inline]
 kvzalloc include/linux/mm.h:814 [inline]
 nf_tables_newset+0x1512/0x3340 net/netfilter/nf_tables_api.c:4341
 nfnetlink_rcv_batch+0x1710/0x25f0 net/netfilter/nfnetlink.c:513
 nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:634 [inline]
 nfnetlink_rcv+0x3af/0x420 net/netfilter/nfnetlink.c:652
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
RIP: 0033:0x43f189
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd36aa47e8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000400488 RCX: 000000000043f189
RDX: 0000000000000000 RSI: 0000000020000040 RDI: 0000000000000003
RBP: 0000000000403170 R08: 0000000000000a00 R09: 0000000000400488
R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000403200
R13: 0000000000000000 R14: 00000000004ad018 R15: 0000000000400488


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
