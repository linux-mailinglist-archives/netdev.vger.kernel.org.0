Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1B62321305
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 10:26:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230042AbhBVJZM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 04:25:12 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:53697 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbhBVJZC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 04:25:02 -0500
Received: by mail-io1-f71.google.com with SMTP id 196so6202905iob.20
        for <netdev@vger.kernel.org>; Mon, 22 Feb 2021 01:24:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=2uSBdEqU47c4oS9ECd3COMKQ/tDdxAm2kFaxZlo25JE=;
        b=Spt0QCRcSzdDhg8ovPouruFm7kiShuoNA6yu5Z+yBkDSQxeoCCY78QgdsKcYmvE5Ap
         Q2DaXKkt3h3X5t1rO4XRcOMUafBxL+wybZWx0ffeP5sCc7vCk2jwdE+AkskesIJ/cIYK
         35ovFpkVKYQLbRmC6cTWZEFYmhGBTvpdtElkT1FxOZAct2KQaVAKjc6ey8XyR1zE9ll4
         EuDvoyRDMtrYoDL6UZJWT00+MqLIFse3F7CWNu1igaiTha/e9Suw3HXPwkAwsKQ4eaFN
         dGe4apI6aYVI4jhLwjZFj83u+8cQrrFXi2mYLUfrCQbNLs5DzIR1wgDqEVfkQlLDY6eE
         BqRg==
X-Gm-Message-State: AOAM5333BmFGICbHEXwWN3hBLixj/TmPEiqo0K6SqrDFd9MT4YANcdUy
        D6Hr/L6CElNH4wC+C8c0i3IujtMjy0e+jTE/rVuhVxCyu/hO
X-Google-Smtp-Source: ABdhPJxJtADNakcKhIpNEcZvK+RbczS8i7akNa4Yeo4xqbH5zi4F/RG2av5zJtFbIKl1aTYNCI+7PiiAsXhvx4W4HLDxcKtWst1h
MIME-Version: 1.0
X-Received: by 2002:a5d:9b18:: with SMTP id y24mr14518492ion.24.1613985860726;
 Mon, 22 Feb 2021 01:24:20 -0800 (PST)
Date:   Mon, 22 Feb 2021 01:24:20 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e6b67405bbe95dfd@google.com>
Subject: general protection fault in ieee802154_llsec_parse_key_id
From:   syzbot <syzbot+d4c07de0144f6f63be3a@syzkaller.appspotmail.com>
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

HEAD commit:    38b5133a octeontx2-pf: Fix otx2_get_fecparam()
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=140c2512d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=dbc1ca9e55dc1f9f
dashboard link: https://syzkaller.appspot.com/bug?extid=d4c07de0144f6f63be3a
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13db6e22d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13fea434d00000

Bisection is inconclusive: the issue happens on the oldest tested release.

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=168e7f02d00000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=158e7f02d00000
console output: https://syzkaller.appspot.com/x/log.txt?x=118e7f02d00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d4c07de0144f6f63be3a@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 0 PID: 8431 Comm: syz-executor292 Not tainted 5.11.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:nla_get_u16 include/net/netlink.h:1581 [inline]
RIP: 0010:nla_get_shortaddr net/ieee802154/nl-mac.c:48 [inline]
RIP: 0010:ieee802154_llsec_parse_key_id+0x17f/0x8a0 net/ieee802154/nl-mac.c:559
Code: 00 00 4d 8b 66 30 4d 85 e4 0f 84 1e 05 00 00 e8 a7 16 e8 f8 49 8d 7c 24 04 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 14 02 48 89 f8 83 e0 07 83 c0 01 38 d0 7c 08 84 d2 0f 85 4e
RSP: 0018:ffffc900017ff4f0 EFLAGS: 00010247
RAX: dffffc0000000000 RBX: ffffc900017ff5a8 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff888ad1e9 RDI: 0000000000000004
RBP: ffffc900017ff680 R08: 0000000000000001 R09: 0000000000000000
R10: ffffffff888ad1a6 R11: 0000000000000000 R12: 0000000000000000
R13: 1ffff920002ffe9e R14: ffff888025b7c400 R15: ffffffff8da591f8
FS:  00000000008e1300(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000002000030c CR3: 000000001cb7a000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 llsec_remove_key net/ieee802154/nl-mac.c:896 [inline]
 ieee802154_nl_llsec_change net/ieee802154/nl-mac.c:824 [inline]
 ieee802154_llsec_del_key+0x109/0x240 net/ieee802154/nl-mac.c:904
 genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:739
 genl_family_rcv_msg net/netlink/genetlink.c:783 [inline]
 genl_rcv_msg+0x328/0x580 net/netlink/genetlink.c:800
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2502
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:811
 netlink_unicast_kernel net/netlink/af_netlink.c:1312 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1338
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1927
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2348
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2402
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2435
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x43fa99
Code: 28 c3 e8 5a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffce4fc0e98 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004004a0 RCX: 000000000043fa99
RDX: 0000000000004054 RSI: 0000000020000440 RDI: 0000000000000004
RBP: 0000000000403500 R08: 00000000ffffffff R09: 00000000004004a0
R10: 0000000000000004 R11: 0000000000000246 R12: 0000000000403590
R13: 0000000000000000 R14: 00000000004ad018 R15: 00000000004004a0
Modules linked in:
---[ end trace 32b0ca68504d0ad5 ]---
RIP: 0010:nla_get_u16 include/net/netlink.h:1581 [inline]
RIP: 0010:nla_get_shortaddr net/ieee802154/nl-mac.c:48 [inline]
RIP: 0010:ieee802154_llsec_parse_key_id+0x17f/0x8a0 net/ieee802154/nl-mac.c:559
Code: 00 00 4d 8b 66 30 4d 85 e4 0f 84 1e 05 00 00 e8 a7 16 e8 f8 49 8d 7c 24 04 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 14 02 48 89 f8 83 e0 07 83 c0 01 38 d0 7c 08 84 d2 0f 85 4e
RSP: 0018:ffffc900017ff4f0 EFLAGS: 00010247
RAX: dffffc0000000000 RBX: ffffc900017ff5a8 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff888ad1e9 RDI: 0000000000000004
RBP: ffffc900017ff680 R08: 0000000000000001 R09: 0000000000000000
R10: ffffffff888ad1a6 R11: 0000000000000000 R12: 0000000000000000
R13: 1ffff920002ffe9e R14: ffff888025b7c400 R15: ffffffff8da591f8
FS:  00000000008e1300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055bf74e6f0b8 CR3: 000000001cb7a000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
