Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65DE731EDA7
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 18:49:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233968AbhBRRs3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 12:48:29 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:33317 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232369AbhBRRWZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Feb 2021 12:22:25 -0500
Received: by mail-il1-f199.google.com with SMTP id k5so1621523ilu.0
        for <netdev@vger.kernel.org>; Thu, 18 Feb 2021 09:21:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=vTqU7z+hMuPADLiCcqd0CORJtVZxh1RcwMIGtNvcShM=;
        b=FBZUfoaXcolOjB1vg/8mYaG+pBXz2rdbNvdPWGS8Sxtfv3KjZZx5gfVyHJqQt/UlWL
         0i4A4ZvkY8x40WN/4TdR4cOn+4euJfRVlZvzhs5B99aTwZYYYM8hksGNjYIXgQoCJzWl
         j4CewaSFQBQtxEQ6z874O1DPQ+uX515eXUKAtgTum+0PgSTTZx3oLEJZpJpG9pN7REOr
         5VGBAETEwFJp2ZEUgSTStttgQxsA371a/jtdjxOOx3SupScPKhfiqTUYXjHwGybQM7Nb
         QN919/1Frz0dkPoJuAIHwcJvre+rNdDJbb6k2L+lAAp10j6KWeZN8ErDuz852J34+MH3
         A9gw==
X-Gm-Message-State: AOAM533t1PRPCu1eB7vPFGWnNcipgqG6u1Im2OWLBFdzDOXoXbL6s85S
        ZyT+OzLXr0RytB5MhPvBeYdIPiKcsPZaJtEoQPM5EPHZOlPY
X-Google-Smtp-Source: ABdhPJyhfC4emPz0tt0e0xYr/NQMSaPCtH2D7fzzBugRGRtdtTRHEstAEOsdHNNr3z//FFNEIC/39xJrLqB/G7WohdyWXluvIPrv
MIME-Version: 1.0
X-Received: by 2002:a02:1ac5:: with SMTP id 188mr5458237jai.71.1613668886098;
 Thu, 18 Feb 2021 09:21:26 -0800 (PST)
Date:   Thu, 18 Feb 2021 09:21:26 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000bdbc6a05bb9f90b0@google.com>
Subject: general protection fault in nl802154_del_llsec_dev
From:   syzbot <syzbot+d946223c2e751d136c94@syzkaller.appspotmail.com>
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
console output: https://syzkaller.appspot.com/x/log.txt?x=16d83be2d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8cb23303ddb9411f
dashboard link: https://syzkaller.appspot.com/bug?extid=d946223c2e751d136c94
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=161c1204d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12daf1d2d00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d946223c2e751d136c94@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 1 PID: 8428 Comm: syz-executor295 Not tainted 5.11.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:nla_len include/net/netlink.h:1148 [inline]
RIP: 0010:nla_parse_nested_deprecated include/net/netlink.h:1231 [inline]
RIP: 0010:nl802154_del_llsec_dev+0x150/0x310 net/ieee802154/nl802154.c:1760
Code: 00 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 c4 01 00 00 48 8b 93 18 01 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 d1 48 c1 e9 03 <0f> b6 0c 01 48 89 d0 83 e0 07 83 c0 01 38 c8 7c 08 84 c9 0f 85 13
RSP: 0018:ffffc90001a67568 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: ffff88801def5400 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff8888ffaa RDI: ffff88801def5518
RBP: 1ffff9200034ceae R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff87315ffa R11: 0000000000000000 R12: ffff8881443d6000
R13: ffff8881441e4bd0 R14: ffffc90001a678b0 R15: 0000000000000000
FS:  000000000208c300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f3aac6fd6c0 CR3: 00000000210c4000 CR4: 00000000001506e0
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
RIP: 0033:0x43f969
Code: 28 c3 e8 5a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe784206c8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004004a0 RCX: 000000000043f969
RDX: 0000000020008800 RSI: 0000000020000600 RDI: 0000000000000003
RBP: 00000000004033d0 R08: 0000000000000008 R09: 00000000004004a0
R10: 0000000000000003 R11: 0000000000000246 R12: 0000000000403460
R13: 0000000000000000 R14: 00000000004ad018 R15: 00000000004004a0
Modules linked in:
---[ end trace 9aedc238aa0648a2 ]---
RIP: 0010:nla_len include/net/netlink.h:1148 [inline]
RIP: 0010:nla_parse_nested_deprecated include/net/netlink.h:1231 [inline]
RIP: 0010:nl802154_del_llsec_dev+0x150/0x310 net/ieee802154/nl802154.c:1760
Code: 00 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 c4 01 00 00 48 8b 93 18 01 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 d1 48 c1 e9 03 <0f> b6 0c 01 48 89 d0 83 e0 07 83 c0 01 38 c8 7c 08 84 c9 0f 85 13
RSP: 0018:ffffc90001a67568 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: ffff88801def5400 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff8888ffaa RDI: ffff88801def5518
RBP: 1ffff9200034ceae R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff87315ffa R11: 0000000000000000 R12: ffff8881443d6000
R13: ffff8881441e4bd0 R14: ffffc90001a678b0 R15: 0000000000000000
FS:  000000000208c300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f3aac6fd6c0 CR3: 00000000210c4000 CR4: 00000000001506e0
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
