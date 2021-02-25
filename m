Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E70613253FE
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 17:50:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234109AbhBYQuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 11:50:20 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:46475 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233668AbhBYQsF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 11:48:05 -0500
Received: by mail-io1-f70.google.com with SMTP id w8so4103319iox.13
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 08:47:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=9H/CwtcPS5njhZEy8VrcSFtOUJSZ60HSsVj51LKQW8Q=;
        b=Cv0p1lSHWpLuSuJu/hzuluJl29E8C+2KUAc1N7DWW9ca1/zHSFFQDRFxJ4IFgpCfx7
         CwDsWg7gCZjLEjDNXdOyTPC6xoyI3gaAdYjUCe6eY2rihrHlshMr7xbn2rxCk1sFe+5H
         Da2Qd1rGbQ46Vp38MUKfKue2Tx/JFMQtMD6EUo0w8KMHCTIONsHkyqhHVuXni9ldj/IC
         ACZ7p/STbKm9JUIrLJKRscAnhjrux1Cf1Xmv1jFOg756xrQyna4BlCGu/zfcazTVMp0b
         hdNR5KWWKEax7HaJHW3gR6Ckq3ZOauOgCXEdtOjuWuDFry9/tC7vy8rQ4qP2/HrmjJQ6
         v+rA==
X-Gm-Message-State: AOAM531QUc0DUaDwiCvfKbT0Cg5HRNYZLbawNyt2janQUrZ9ykj+HCxX
        AeHlQ2Sklp5WxBGYq6rPa8f+1ENjT2GvIKrqyHmPkVPYylYt
X-Google-Smtp-Source: ABdhPJxso2JqKTX/f7Iyxq1fwMqK1qdcYRdckBeoApdPTVevpB0NGiGdk4FSjtupSp/xKb2WEDPVzx16mrT97Yb1wgQz+oVUwfcJ
MIME-Version: 1.0
X-Received: by 2002:a02:3e16:: with SMTP id s22mr3666531jas.72.1614271643488;
 Thu, 25 Feb 2021 08:47:23 -0800 (PST)
Date:   Thu, 25 Feb 2021 08:47:23 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e195f705bc2be778@google.com>
Subject: general protection fault in ieee802154_llsec_parse_dev_addr
From:   syzbot <syzbot+8b6719da8a04beeafcc3@syzkaller.appspotmail.com>
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

HEAD commit:    fcb30073 Merge branch 'wireguard-fixes-for-5-12-rc1'
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=148f1646d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2b8307379601586a
dashboard link: https://syzkaller.appspot.com/bug?extid=8b6719da8a04beeafcc3
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=122a61a8d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1648d632d00000

Bisection is inconclusive: the issue happens on the oldest tested release.

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10406466d00000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=12406466d00000
console output: https://syzkaller.appspot.com/x/log.txt?x=14406466d00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8b6719da8a04beeafcc3@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 1 PID: 8419 Comm: syz-executor652 Not tainted 5.11.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:nla_get_le16 include/net/netlink.h:1599 [inline]
RIP: 0010:ieee802154_llsec_parse_dev_addr+0x2b3/0x370 net/ieee802154/nl802154.c:1306
Code: 00 0f 85 d5 00 00 00 48 89 5d 08 e9 5c ff ff ff e8 72 2e e4 f8 49 8d 7e 04 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 14 02 48 89 f8 83 e0 07 83 c0 01 38 d0 7c 04 84 d2 75 7d 48
RSP: 0018:ffffc90001797390 EFLAGS: 00010247
RAX: dffffc0000000000 RBX: 0000000000000002 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff888eab3e RDI: 0000000000000004
RBP: ffffc90001797590 R08: ffffffff8a8934e0 R09: ffffffff888eaa81
R10: 0000000000000002 R11: 0000000000000002 R12: 1ffff920002f2e72
R13: 0000000000000000 R14: 0000000000000000 R15: ffff88802171cc78
FS:  00000000016b2300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000408 CR3: 000000001360f000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 ieee802154_llsec_parse_key_id+0x343/0x410 net/ieee802154/nl802154.c:1344
 nl802154_set_llsec_params+0x1db/0x470 net/ieee802154/nl802154.c:1399
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
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x43fc09
Code: 28 c3 e8 5a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffed214c208 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004004a0 RCX: 000000000043fc09
RDX: 0000000000000040 RSI: 0000000020000680 RDI: 0000000000000003
RBP: 0000000000403670 R08: 0000000000000004 R09: 00000000004004a0
R10: 000000000000000c R11: 0000000000000246 R12: 0000000000403700
R13: 0000000000000000 R14: 00000000004ad018 R15: 00000000004004a0
Modules linked in:
---[ end trace 20aa2d549964b50b ]---
RIP: 0010:nla_get_le16 include/net/netlink.h:1599 [inline]
RIP: 0010:ieee802154_llsec_parse_dev_addr+0x2b3/0x370 net/ieee802154/nl802154.c:1306
Code: 00 0f 85 d5 00 00 00 48 89 5d 08 e9 5c ff ff ff e8 72 2e e4 f8 49 8d 7e 04 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 14 02 48 89 f8 83 e0 07 83 c0 01 38 d0 7c 04 84 d2 75 7d 48
RSP: 0018:ffffc90001797390 EFLAGS: 00010247
RAX: dffffc0000000000 RBX: 0000000000000002 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff888eab3e RDI: 0000000000000004
RBP: ffffc90001797590 R08: ffffffff8a8934e0 R09: ffffffff888eaa81
R10: 0000000000000002 R11: 0000000000000002 R12: 1ffff920002f2e72
R13: 0000000000000000 R14: 0000000000000000 R15: ffff88802171cc78
FS:  00000000016b2300(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f3256d2dab4 CR3: 000000001360f000 CR4: 00000000001506f0
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
