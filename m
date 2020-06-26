Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3789420B691
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 19:08:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728175AbgFZRIT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 13:08:19 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:54082 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727859AbgFZRIS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 13:08:18 -0400
Received: by mail-il1-f200.google.com with SMTP id r4so6876296ilq.20
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 10:08:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=t2Z2VRoz3/98NJeyfMvHjdmkNx4ro3D+vUPmsLLjLZM=;
        b=CNJx16IpMshAq7+s3Y1k/T4KLHN70iu5eseFVWRYdPPDHkx/I3Xp2vEThwVdjhbKBB
         iaXK4YS1sE9bp5ZHOG6SiCNT+WX/RY4nzhp5vufTQ+OAShZceioaiNBOmUCVZmapqLW5
         yvFtqlu+HJi2L141b0DKg+f01GKKTS+8N3K2bmwz2t/yoZi0GJXdws473JnH3y0+2K/8
         5DvP1hhUJMVOngmJ39CiUfev80bD/bjxS2x1wUGFwmH6rwt/qVzy4k6j1JMPRA+Fn2h7
         7hUW5DgdXU293tTkngP6EXpwQYZZXmP/nPgl2LZUdBFpegtKqDvjPW/Q2N7wMUC9nHYK
         JXgQ==
X-Gm-Message-State: AOAM530URT2OvkPmuKzC3YgEqwTsTs6xVp90qRCb5t7WFupys9kw6Nl0
        dasHmRogKB0zO8pwD+a0E8grquPgF3dkqYnuqTKN49amWc8q
X-Google-Smtp-Source: ABdhPJzi8z0iVSssZlM3bXL98MJgdWNNejtBWbJFhhNqSaMhZLP5NXz55QSwz6d0e5T+NxEYkk5fGtsCVyRYE7TMc2ET5fyLzXcP
MIME-Version: 1.0
X-Received: by 2002:a05:6638:12c7:: with SMTP id v7mr4403231jas.56.1593191296525;
 Fri, 26 Jun 2020 10:08:16 -0700 (PDT)
Date:   Fri, 26 Jun 2020 10:08:16 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000049ea0a05a8ffc126@google.com>
Subject: KASAN: use-after-free Read in nl8NUM_dump_wpan_phy (2)
From:   syzbot <syzbot+4c8afc85aa32ddb020dc@syzkaller.appspotmail.com>
To:     alex.aring@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org, stefan@datenfreihafen.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    b835a71e usbnet: smsc95xx: Fix use-after-free after removal
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=106721ad100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=dcc6334acae363d4
dashboard link: https://syzkaller.appspot.com/bug?extid=4c8afc85aa32ddb020dc
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13c25419100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1768f009100000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+4c8afc85aa32ddb020dc@syzkaller.appspotmail.com

netlink: 'syz-executor532': attribute type 3 has an invalid length.
==================================================================
BUG: KASAN: use-after-free in nla_len include/net/netlink.h:1135 [inline]
BUG: KASAN: use-after-free in nla_memcpy+0x9c/0xa0 lib/nlattr.c:724
Read of size 2 at addr ffff8880a46aec14 by task syz-executor532/6937

CPU: 1 PID: 6937 Comm: syz-executor532 Not tainted 5.8.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xae/0x436 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
 nla_len include/net/netlink.h:1135 [inline]
 nla_memcpy+0x9c/0xa0 lib/nlattr.c:724
 nla_get_u64 include/net/netlink.h:1606 [inline]
 nl802154_dump_wpan_phy_parse net/ieee802154/nl802154.c:559 [inline]
 nl802154_dump_wpan_phy+0x59b/0x9c0 net/ieee802154/nl802154.c:593
 genl_lock_dumpit+0x7f/0xb0 net/netlink/genetlink.c:575
 netlink_dump+0x4cd/0xf60 net/netlink/af_netlink.c:2245
 __netlink_dump_start+0x643/0x900 net/netlink/af_netlink.c:2353
 genl_family_rcv_msg_dumpit+0x2ac/0x310 net/netlink/genetlink.c:638
 genl_family_rcv_msg net/netlink/genetlink.c:733 [inline]
 genl_rcv_msg+0x797/0x9e0 net/netlink/genetlink.c:753
 netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2469
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:764
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2352
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2406
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2439
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:359
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x441409
Code: Bad RIP value.
RSP: 002b:00007ffda49cc2b8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000441409
RDX: 0000000000000000 RSI: 0000000020000000 RDI: 0000000000000003
RBP: 00000000006cc018 R08: 0000000120080522 R09: 0000000120080522
R10: 0000000000000004 R11: 0000000000000246 R12: 0000000000402220
R13: 00000000004022b0 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 6962:
 save_stack+0x1b/0x40 mm/kasan/common.c:48
 set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc.constprop.0+0xc2/0xd0 mm/kasan/common.c:494
 __kmalloc_reserve net/core/skbuff.c:142 [inline]
 __alloc_skb+0xae/0x550 net/core/skbuff.c:210
 alloc_skb include/linux/skbuff.h:1083 [inline]
 netlink_alloc_large_skb net/netlink/af_netlink.c:1175 [inline]
 netlink_sendmsg+0x94f/0xd90 net/netlink/af_netlink.c:1893
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2352
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2406
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2439
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:359
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Freed by task 6962:
 save_stack+0x1b/0x40 mm/kasan/common.c:48
 set_track mm/kasan/common.c:56 [inline]
 kasan_set_free_info mm/kasan/common.c:316 [inline]
 __kasan_slab_free+0xf5/0x140 mm/kasan/common.c:455
 __cache_free mm/slab.c:3426 [inline]
 kfree+0x103/0x2c0 mm/slab.c:3757
 skb_free_head net/core/skbuff.c:590 [inline]
 skb_release_data+0x6d9/0x910 net/core/skbuff.c:610
 skb_release_all net/core/skbuff.c:664 [inline]
 __kfree_skb net/core/skbuff.c:678 [inline]
 consume_skb net/core/skbuff.c:837 [inline]
 consume_skb+0xc2/0x160 net/core/skbuff.c:831
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x53b/0x7d0 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2352
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2406
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2439
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:359
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

The buggy address belongs to the object at ffff8880a46aec00
 which belongs to the cache kmalloc-512 of size 512
The buggy address is located 20 bytes inside of
 512-byte region [ffff8880a46aec00, ffff8880a46aee00)
The buggy address belongs to the page:
page:ffffea000291ab80 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0
flags: 0xfffe0000000200(slab)
raw: 00fffe0000000200 ffffea00028dee88 ffffea0002548e08 ffff8880aa000a80
raw: 0000000000000000 ffff8880a46ae000 0000000100000004 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8880a46aeb00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff8880a46aeb80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff8880a46aec00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                         ^
 ffff8880a46aec80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8880a46aed00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
