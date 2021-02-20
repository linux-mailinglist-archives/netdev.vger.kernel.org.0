Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E015F32044C
	for <lists+netdev@lfdr.de>; Sat, 20 Feb 2021 08:06:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbhBTHGG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Feb 2021 02:06:06 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:46715 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbhBTHGC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Feb 2021 02:06:02 -0500
Received: by mail-io1-f71.google.com with SMTP id s26so4773846ioe.13
        for <netdev@vger.kernel.org>; Fri, 19 Feb 2021 23:05:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=yBvR6QhWGmgWa6u0J4gSpumL12+o1rDkset8CbmpFLE=;
        b=ejbDZhw75Vh+C9hGij2KaqIJgJ6KFWBSe9oFZHvVI+p1OVJHPXiKs5+zZi5fX/Kp4q
         CUzHZkLrjDZSE5Gsl+A3P7bcVh0bLdieo8N7FITq4z8ogHKHnvfBvjyn2pd3D+mv8kzv
         dFMcSeIcnK6R8i2NxFChJw9yFGhDQPm1kcF1DuUn/K0E6P9csLt6nD2gm0lzHlzG8q1a
         iiekh6vdFHE9ht/esL3A2s3Q+GQnpPQYpWpDIY9qxijLYYAU3FrTsODxQLkX5u/fzWh+
         h9aOnPWtrJyCEV9G8MzcBt/MGdCt9lZ20nJCIvr7eicV15K1Y07/ZEkgxO+U6x+TivQD
         jyRw==
X-Gm-Message-State: AOAM533Uhi6mGJSfE9vqZ2N08VqOy02+RKuAsdJxJxk3kBU0LaX3g4sc
        U6NRXGxySfoR8iGd1tFDHtnwH66RgRJ84SM1hBz9YlVVgvZq
X-Google-Smtp-Source: ABdhPJybJnMZCn/LeCBjhTJlQbnaaEUk+y67n2RpMTcuWILBwRAH3DvYSKAqvmE49rSvTP7t+sIDwIGKokSoWbAzoHVZ9ucs5z73
MIME-Version: 1.0
X-Received: by 2002:a6b:f317:: with SMTP id m23mr7548478ioh.67.1613804721960;
 Fri, 19 Feb 2021 23:05:21 -0800 (PST)
Date:   Fri, 19 Feb 2021 23:05:21 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000307cc205bbbf31d3@google.com>
Subject: WARNING in netlbl_cipsov4_add
From:   syzbot <syzbot+cdd51ee2e6b0b2e18c0d@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    4773acf3 b43: N-PHY: Fix the update of coef for the PHY re..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=13290cb0d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8cb23303ddb9411f
dashboard link: https://syzkaller.appspot.com/bug?extid=cdd51ee2e6b0b2e18c0d
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1267953cd00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10d98524d00000

Bisection is inconclusive: the issue happens on the oldest tested release.

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1127cc82d00000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1327cc82d00000
console output: https://syzkaller.appspot.com/x/log.txt?x=1527cc82d00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+cdd51ee2e6b0b2e18c0d@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 8425 at mm/page_alloc.c:4979 __alloc_pages_nodemask+0x5f8/0x730 mm/page_alloc.c:5014
Modules linked in:
CPU: 0 PID: 8425 Comm: syz-executor629 Not tainted 5.11.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__alloc_pages_nodemask+0x5f8/0x730 mm/page_alloc.c:4979
Code: 00 00 0c 00 0f 85 a7 00 00 00 8b 3c 24 4c 89 f2 44 89 e6 c6 44 24 70 00 48 89 6c 24 58 e8 d0 d7 ff ff 49 89 c5 e9 ea fc ff ff <0f> 0b e9 b5 fd ff ff 89 74 24 14 4c 89 4c 24 08 4c 89 74 24 18 e8
RSP: 0018:ffffc900017ef3e0 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 1ffff920002fde80 RCX: 0000000000000000
RDX: 0000000000000000 RSI: dffffc0000000000 RDI: 0000000000040dc0
RBP: 0000000000040dc0 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff81b29ac1 R11: 0000000000000000 R12: 0000000000000015
R13: 0000000000000015 R14: 0000000000000000 R15: ffff88801209c980
FS:  0000000001c35300(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fbf6f3656c0 CR3: 000000001db9e000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 alloc_pages_current+0x18c/0x2a0 mm/mempolicy.c:2267
 alloc_pages include/linux/gfp.h:547 [inline]
 kmalloc_order+0x32/0xd0 mm/slab_common.c:837
 kmalloc_order_trace+0x14/0x130 mm/slab_common.c:853
 kmalloc_array include/linux/slab.h:592 [inline]
 kcalloc include/linux/slab.h:621 [inline]
 netlbl_cipsov4_add_std net/netlabel/netlabel_cipso_v4.c:188 [inline]
 netlbl_cipsov4_add+0x5a9/0x23e0 net/netlabel/netlabel_cipso_v4.c:416
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
RIP: 0033:0x43fcc9
Code: 28 c3 e8 5a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffdcdd33c48 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004004a0 RCX: 000000000043fcc9
RDX: 0000000000004904 RSI: 0000000020000140 RDI: 0000000000000003
RBP: 0000000000403730 R08: 0000000000000005 R09: 00000000004004a0
R10: 0000000000000003 R11: 0000000000000246 R12: 00000000004037c0
R13: 0000000000000000 R14: 00000000004ad018 R15: 00000000004004a0


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
