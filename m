Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2738031F0CA
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 21:08:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232417AbhBRUHJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 15:07:09 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:45081 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232062AbhBRUFB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Feb 2021 15:05:01 -0500
Received: by mail-il1-f198.google.com with SMTP id h17so1922163ila.12
        for <netdev@vger.kernel.org>; Thu, 18 Feb 2021 12:04:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=14s4etd2RG23hvdh/2LBIif38UIYsK3i0gzC4BQN0lQ=;
        b=ICXYOTwQU93cJK+O6rxi+abYplb+e1bGQri+5RJIDSSgf5C2xiKVir4oNJ6lAvoK3Y
         GQ1H3AYxyB1l5zSuf4eQfqqhkFYh7f3eXBMLrb7JQt6E8D4oqXgPA94sDpEPpCflUJW3
         lED8WpP1GkOARmZ1la8FUrYNuz2+Ioh5VvznMmrDHvqOYpHBse8Cj1yhUtpeZaSYWKdO
         1eV+3YK5EtpGs7puhH5BCul62VOfdNKTpjV3XZLEuQplDJtLvgCCdBbnCzcs2EJ6aQrJ
         kNp6bm7RcNhnv3bKwdU8Eg8+pJNzUDmXOx8sc1TBlIgWVbOJWe6y4l25gAgkUgvxLS0B
         8ALA==
X-Gm-Message-State: AOAM532tTDPLgSGehr5jJJMLSw2Cl1QTjx8iiIgdN7oqDkzyoURKk2Ul
        lS66kq6Ol+shwuMTs2YJdP3k5coTFNaGvLYGjKsEOJmC4mOG
X-Google-Smtp-Source: ABdhPJz+fCjHDwSSd6yBNR0wYYf6NtSyYGyJuRw+XSBPedOxJ/Yv3/EWJLkgg92zbt6LiEVfrg+qVX+epcAsD/PA21P82Yc8KRLg
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2c49:: with SMTP id x9mr685593iov.173.1613678660777;
 Thu, 18 Feb 2021 12:04:20 -0800 (PST)
Date:   Thu, 18 Feb 2021 12:04:20 -0800
In-Reply-To: <0000000000006246f105bba148f9@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005b7a2a05bba1d762@google.com>
Subject: Re: BUG: unable to handle kernel paging request in nl802154_del_llsec_key
From:   syzbot <syzbot+ac5c11d2959a8b3c4806@syzkaller.appspotmail.com>
To:     alex.aring@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org, stefan@datenfreihafen.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    3af409ca net: enetc: fix destroyed phylink dereference dur..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=12ee9f72d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8cb23303ddb9411f
dashboard link: https://syzkaller.appspot.com/bug?extid=ac5c11d2959a8b3c4806
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1201ac0cd00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1307734ad00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ac5c11d2959a8b3c4806@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 0 PID: 8434 Comm: syz-executor691 Not tainted 5.11.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:nla_len include/net/netlink.h:1148 [inline]
RIP: 0010:nla_parse_nested_deprecated include/net/netlink.h:1231 [inline]
RIP: 0010:nl802154_del_llsec_key+0x16d/0x320 net/ieee802154/nl802154.c:1595
Code: 00 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 ab 01 00 00 48 8b 93 28 01 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 d1 48 c1 e9 03 <0f> b6 0c 01 48 89 d0 83 e0 07 83 c0 01 38 c8 7c 08 84 c9 0f 85 16
RSP: 0018:ffffc90001abf528 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: ffff88801847fc00 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff88892647 RDI: ffff88801847fd28
RBP: 1ffff92000357ea6 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff8731625a R11: 0000000000000000 R12: ffff888144a80000
R13: ffff8881448fcbd0 R14: ffffc90001abf8b0 R15: 0000000000000000
FS:  0000000001d99300(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000048 CR3: 0000000015550000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:739
 genl_family_rcv_msg net/netlink/genetlink.c:783 [inline]
 genl_rcv_msg+0x328/0x580 net/netlink/genetlink.c:800
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2494
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:811
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2345
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2399
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2432
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x43f909
Code: 28 c3 e8 5a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd3305ef28 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004004a0 RCX: 000000000043f909
RDX: 0000000020000000 RSI: 0000000020000140 RDI: 0000000000000003
RBP: 0000000000403370 R08: 000000000000000c R09: 00000000004004a0
R10: 0000000000000006 R11: 0000000000000246 R12: 0000000000403400
R13: 0000000000000000 R14: 00000000004ad018 R15: 00000000004004a0
Modules linked in:
---[ end trace e812501a57df1749 ]---
RIP: 0010:nla_len include/net/netlink.h:1148 [inline]
RIP: 0010:nla_parse_nested_deprecated include/net/netlink.h:1231 [inline]
RIP: 0010:nl802154_del_llsec_key+0x16d/0x320 net/ieee802154/nl802154.c:1595
Code: 00 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 ab 01 00 00 48 8b 93 28 01 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 d1 48 c1 e9 03 <0f> b6 0c 01 48 89 d0 83 e0 07 83 c0 01 38 c8 7c 08 84 c9 0f 85 16
RSP: 0018:ffffc90001abf528 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: ffff88801847fc00 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff88892647 RDI: ffff88801847fd28
RBP: 1ffff92000357ea6 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff8731625a R11: 0000000000000000 R12: ffff888144a80000
R13: ffff8881448fcbd0 R14: ffffc90001abf8b0 R15: 0000000000000000
FS:  0000000001d99300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f152c03e068 CR3: 0000000015550000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400

