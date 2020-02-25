Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AC1016B754
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 02:48:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728733AbgBYBsP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 20:48:15 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:34773 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728583AbgBYBsO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 20:48:14 -0500
Received: by mail-il1-f200.google.com with SMTP id l13so22187535ils.1
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 17:48:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=THUlbZ/6NMU2sVym3Qlfci4ygzS5ZBnoxaxT1jFcOt8=;
        b=rfSyAekK6zeSpb85C6tgTeNZd+8kWnj1NlazrIyejR+3V1x7i9V4C99tLRoXXcPlTV
         4ryuRAyG0c/jHtubJkkAgAT2mwiHKwu708bpeQ5go4TL1NHY0t7aozKSnseXVLr2NzzH
         e4upTG4BlVHxkZujuS7FbTl6l5fvamMAGIrr8ys9GSg5zNbsPrPLuLJ9KPBbcWVXB2Pi
         MHZTANvPCzUhHKqlS+buI0Q/66armDwpCH8dpvteSMvJjANrrnn+gaKbtJatZkouM+zf
         y058O2djFqRphDUAYFnayHxK+IG8Wmd/eTiNnijhIXJDCOC9RIG1sMGrVDCnHVUyJMzD
         muQA==
X-Gm-Message-State: APjAAAWb1lYT1KBVpayO2Ae8q3CD9bQtsqB+r3xfziIW+aCq6qS2MnMQ
        7wZW6jCB7D3Sz3I2/KiY9jtIprOUowR/E3fmO6oK/er8oMH/
X-Google-Smtp-Source: APXvYqzntUKeAtSxXmfIUrtt3OhLfaq7b1vqkJ/qquLmzXPg8jF/9WS/6RvoU3bd3Sm3RhE87tSf+y+MdenYf0corw66y5ScFTFY
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2352:: with SMTP id r18mr52270205iot.220.1582595293486;
 Mon, 24 Feb 2020 17:48:13 -0800 (PST)
Date:   Mon, 24 Feb 2020 17:48:13 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004aa34d059f5caedc@google.com>
Subject: general protection fault in nldev_stat_set_doit
From:   syzbot <syzbot+bd4af81bc51ee0283445@syzkaller.appspotmail.com>
To:     dledford@redhat.com, jgg@ziepe.ca, leon@kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        markz@mellanox.com, netdev@vger.kernel.org, parav@mellanox.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    39f3b41a net: genetlink: return the error code when attrib..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=161be265e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3b8906eb6a7d6028
dashboard link: https://syzkaller.appspot.com/bug?extid=bd4af81bc51ee0283445
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=167103ede00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1710c265e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+bd4af81bc51ee0283445@syzkaller.appspotmail.com

iwpm_register_pid: Unable to send a nlmsg (client = 2)
infiniband syz1: RDMA CMA: cma_listen_on_dev, error -98
general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 0 PID: 9754 Comm: syz-executor069 Not tainted 5.6.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:nla_get_u32 include/net/netlink.h:1474 [inline]
RIP: 0010:nldev_stat_set_doit+0x63c/0xb70 drivers/infiniband/core/nldev.c:1760
Code: fc 01 0f 84 58 03 00 00 e8 41 83 bf fb 4c 8b a3 58 fd ff ff 48 b8 00 00 00 00 00 fc ff df 49 8d 7c 24 04 48 89 fa 48 c1 ea 03 <0f> b6 14 02 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 6d
RSP: 0018:ffffc900068bf350 EFLAGS: 00010247
RAX: dffffc0000000000 RBX: ffffc900068bf728 RCX: ffffffff85b60470
RDX: 0000000000000000 RSI: ffffffff85b6047f RDI: 0000000000000004
RBP: ffffc900068bf750 R08: ffff88808c3ee140 R09: ffff8880a25e6010
R10: ffffed10144bcddc R11: ffff8880a25e6ee3 R12: 0000000000000000
R13: ffff88809acb0000 R14: ffff888092a42c80 R15: 000000009ef2e29a
FS:  0000000001ff0880(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f4733e34000 CR3: 00000000a9b27000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 rdma_nl_rcv_msg drivers/infiniband/core/netlink.c:195 [inline]
 rdma_nl_rcv_skb drivers/infiniband/core/netlink.c:239 [inline]
 rdma_nl_rcv+0x5d9/0x980 drivers/infiniband/core/netlink.c:259
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x59e/0x7e0 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x91c/0xea0 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xd7/0x130 net/socket.c:672
 ____sys_sendmsg+0x753/0x880 net/socket.c:2343
 ___sys_sendmsg+0x100/0x170 net/socket.c:2397
 __sys_sendmsg+0x105/0x1d0 net/socket.c:2430
 __do_sys_sendmsg net/socket.c:2439 [inline]
 __se_sys_sendmsg net/socket.c:2437 [inline]
 __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2437
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4403d9
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffc0efbc5c8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 00000000004403d9
RDX: 0000000000000000 RSI: 0000000020000240 RDI: 0000000000000004
RBP: 00000000006ca018 R08: 0000000000000008 R09: 00000000004002c8
R10: 000000000000004a R11: 0000000000000246 R12: 0000000000401c60
R13: 0000000000401cf0 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
---[ end trace 548745c787596b79 ]---
RIP: 0010:nla_get_u32 include/net/netlink.h:1474 [inline]
RIP: 0010:nldev_stat_set_doit+0x63c/0xb70 drivers/infiniband/core/nldev.c:1760
Code: fc 01 0f 84 58 03 00 00 e8 41 83 bf fb 4c 8b a3 58 fd ff ff 48 b8 00 00 00 00 00 fc ff df 49 8d 7c 24 04 48 89 fa 48 c1 ea 03 <0f> b6 14 02 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 6d
RSP: 0018:ffffc900068bf350 EFLAGS: 00010247
RAX: dffffc0000000000 RBX: ffffc900068bf728 RCX: ffffffff85b60470
RDX: 0000000000000000 RSI: ffffffff85b6047f RDI: 0000000000000004
RBP: ffffc900068bf750 R08: ffff88808c3ee140 R09: ffff8880a25e6010
R10: ffffed10144bcddc R11: ffff8880a25e6ee3 R12: 0000000000000000
R13: ffff88809acb0000 R14: ffff888092a42c80 R15: 000000009ef2e29a
FS:  0000000001ff0880(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f4733e34000 CR3: 00000000a9b27000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
