Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B09D31BC26
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 16:21:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230172AbhBOPTx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 10:19:53 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:51835 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbhBOPSC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 10:18:02 -0500
Received: by mail-io1-f71.google.com with SMTP id j2so6943114iow.18
        for <netdev@vger.kernel.org>; Mon, 15 Feb 2021 07:17:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=6Yl9t4gdd2YVth0q3BHMCtt6ZKFt8W/B/gJwsLbv9dc=;
        b=HXy8yH9k6AU/n11a3oww1q/oV14l1xtCocZEStRGBBh/aqvEljSdbaIdrT+/UuCmsk
         cz/oR/6+yY0eZg1clDgZtZhTRx/83bwQ6PNw0+5fpfYH0k9HYbw6OMGu3Ds7CMmxEHJu
         JOCNFN3skjAYIsm0xqnHeEya23RY9hltyYjasLowAXftaEPRU8o0cOPedEKqz3GqeNd7
         T6S9R10gXcWkyP7IvQtMJ+Br2I+Nf7VAOlOTKE6q0jHP1/iQ0XVz/37ACqcRJg40CvZf
         VniudwaPDVxGBq+7tmsRA9RO4v8Tn6nl7NvPz8muW2PHQe3l/6mIfhUEbVQ1SE189l+A
         6nHQ==
X-Gm-Message-State: AOAM5302TAKVAb7E9W5/COWgtmFskcIU0NyIOO+4+viCCQC++L6tLiPR
        Y4DqcSbLDJIbaBonqpB7OubTejq6ycNYFe4N+OFCk7pXgeZ8
X-Google-Smtp-Source: ABdhPJwtT5ZSMT9DFRY8v/G8IhAUDwB6SAPYdqmGoTJG8o3l6Ljxie90N0nF1pSBoC5Ur1Cdr2zg+h4PeH+rOfM30Oa7c6WnVt85
MIME-Version: 1.0
X-Received: by 2002:a05:6638:2411:: with SMTP id z17mr5241927jat.29.1613402240800;
 Mon, 15 Feb 2021 07:17:20 -0800 (PST)
Date:   Mon, 15 Feb 2021 07:17:20 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000715bd105bb617b44@google.com>
Subject: general protection fault in nl802154_add_llsec_key
From:   syzbot <syzbot+ce4e062c2d51977ddc50@syzkaller.appspotmail.com>
To:     alex.aring@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org, stefan@datenfreihafen.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    57baf8cc net: axienet: Handle deferred probe on clock prop..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=15c84ed2d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8cb23303ddb9411f
dashboard link: https://syzkaller.appspot.com/bug?extid=ce4e062c2d51977ddc50
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1332a822d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12760822d00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ce4e062c2d51977ddc50@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 1 PID: 8444 Comm: syz-executor279 Not tainted 5.11.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:nla_len include/net/netlink.h:1148 [inline]
RIP: 0010:nla_parse_nested_deprecated include/net/netlink.h:1231 [inline]
RIP: 0010:nl802154_add_llsec_key+0x1f7/0x560 net/ieee802154/nl802154.c:1547
Code: 00 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 2f 03 00 00 48 8b 93 28 01 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 d1 48 c1 e9 03 <0f> b6 0c 01 48 89 d0 83 e0 07 83 c0 01 38 c8 7c 08 84 c9 0f 85 c9
RSP: 0018:ffffc90001adf4a0 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: ffff88802117c000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff88892195 RDI: ffff88802117c128
RBP: 1ffff9200035be95 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff87315ffa R11: 0000000000000000 R12: ffff88801c222000
R13: ffff88801bb34bd0 R14: ffffc90001adf8b0 R15: 0000000000000000
FS:  0000000001dcd300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000200006c8 CR3: 000000002146a000 CR4: 00000000001506e0
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
RIP: 0033:0x43f8a9
Code: 28 c3 e8 5a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe56c91f68 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004004a0 RCX: 000000000043f8a9
RDX: 0000000000000000 RSI: 0000000020000a00 RDI: 0000000000000004
RBP: 0000000000403310 R08: 00000000004004a0 R09: 00000000004004a0
R10: 0000000000000003 R11: 0000000000000246 R12: 00000000004033a0
R13: 0000000000000000 R14: 00000000004ad018 R15: 00000000004004a0
Modules linked in:
---[ end trace 1844a7d5c231fd88 ]---
RIP: 0010:nla_len include/net/netlink.h:1148 [inline]
RIP: 0010:nla_parse_nested_deprecated include/net/netlink.h:1231 [inline]
RIP: 0010:nl802154_add_llsec_key+0x1f7/0x560 net/ieee802154/nl802154.c:1547
Code: 00 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 2f 03 00 00 48 8b 93 28 01 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 d1 48 c1 e9 03 <0f> b6 0c 01 48 89 d0 83 e0 07 83 c0 01 38 c8 7c 08 84 c9 0f 85 c9
RSP: 0018:ffffc90001adf4a0 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: ffff88802117c000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff88892195 RDI: ffff88802117c128
RBP: 1ffff9200035be95 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff87315ffa R11: 0000000000000000 R12: ffff88801c222000
R13: ffff88801bb34bd0 R14: ffffc90001adf8b0 R15: 0000000000000000
FS:  0000000001dcd300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000200006c8 CR3: 000000002146a000 CR4: 00000000001506e0
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
