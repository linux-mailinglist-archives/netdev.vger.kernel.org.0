Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84AA4214E9C
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 20:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728085AbgGESmX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 14:42:23 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:51872 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727906AbgGESmW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 14:42:22 -0400
Received: by mail-il1-f197.google.com with SMTP id m3so26105646ila.18
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 11:42:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=36lIim6U0EVSea9yn5eRaizKMk+KEYlJqS23zYMSLOk=;
        b=LhGvildkWE7oAfm+vTD8B3GggHPcHe38XggZHIsNP/cSZ+kD1b/lZHEp58H7YK8tcl
         x3OTw0yhUS7V6n2m1NTVPjr7GLSqeSo25pQo34yOjYkhweuV9iwLpF/mKihdEAEML5rs
         U/RVwPHmgPYtEo/JVFLhmNpxMKEXQB4+oBJT7v+7N4oKAHxKL2nHiofV1V8y/jDgBN1N
         mlYdhaM70c0TRjCQS7FDnf6VN/QOr9iBa53bXq1HADSIPdxR6T+7mgBNetiSvqyn0noq
         JFY8H1ltQZYRui3AYoIJH+xTH6jjXFAGgwzl5kR5KmB9IfTvANu4tecudtZDMvYgvX7x
         eSSA==
X-Gm-Message-State: AOAM533TYP88aHPwveYAa8XMl/kk1c7k49CFGL57+KGCfqLBqbjhsqpq
        GLmw3+Wu4obGXrmScnRUhBgyEZwbnqMTGWpMiCT+SpVZwE0Y
X-Google-Smtp-Source: ABdhPJxI8RfCHebzqFgY01iWDvhaoIwOhyEqBLiFwmY6Vbf1wGjH+aiyZVM2XuALnt4TZHdm/fahuQ+9CJqkHl2qP9/pB+wiO65u
MIME-Version: 1.0
X-Received: by 2002:a05:6602:d8:: with SMTP id z24mr21869065ioe.136.1593974541507;
 Sun, 05 Jul 2020 11:42:21 -0700 (PDT)
Date:   Sun, 05 Jul 2020 11:42:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000053e07805a9b61e09@google.com>
Subject: KASAN: use-after-free Read in __cfg8NUM_wpan_dev_from_attrs (2)
From:   syzbot <syzbot+14e0e4960091ffae7cf7@syzkaller.appspotmail.com>
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

HEAD commit:    e44f65fd xen-netfront: remove redundant assignment to vari..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=120f87e5100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=829871134ca5e230
dashboard link: https://syzkaller.appspot.com/bug?extid=14e0e4960091ffae7cf7
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11818aa7100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10f997d3100000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+14e0e4960091ffae7cf7@syzkaller.appspotmail.com

netlink: 26 bytes leftover after parsing attributes in process `syz-executor982'.
==================================================================
BUG: KASAN: use-after-free in nla_len include/net/netlink.h:1135 [inline]
BUG: KASAN: use-after-free in nla_memcpy+0x9c/0xa0 lib/nlattr.c:724
Read of size 2 at addr ffff8880a0ca8414 by task syz-executor982/6816

CPU: 0 PID: 6816 Comm: syz-executor982 Not tainted 5.8.0-rc2-syzkaller #0
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
 __cfg802154_wpan_dev_from_attrs+0x3e0/0x510 net/ieee802154/nl802154.c:55
 nl802154_prepare_wpan_dev_dump.constprop.0+0xf9/0x490 net/ieee802154/nl802154.c:245
 nl802154_dump_llsec_dev+0xc0/0xb10 net/ieee802154/nl802154.c:1655
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
RIP: 0033:0x4413c9
Code: Bad RIP value.
RSP: 002b:00007fff5b30bca8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00000000004413c9
RDX: 0000000000000000 RSI: 0000000020000000 RDI: 0000000000000003
RBP: 00000000006cb018 R08: 00000000004002c8 R09: 00000000004002c8
R10: 0000000000000004 R11: 0000000000000246 R12: 0000000000402140
R13: 00000000004021d0 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 6815:
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

Freed by task 6815:
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

The buggy address belongs to the object at ffff8880a0ca8400
 which belongs to the cache kmalloc-512 of size 512
The buggy address is located 20 bytes inside of
 512-byte region [ffff8880a0ca8400, ffff8880a0ca8600)
The buggy address belongs to the page:
page:ffffea0002832a00 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0
flags: 0xfffe0000000200(slab)
raw: 00fffe0000000200 ffffea00029e1288 ffffea00028ef888 ffff8880aa000a80
raw: 0000000000000000 ffff8880a0ca8000 0000000100000004 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8880a0ca8300: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff8880a0ca8380: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff8880a0ca8400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                         ^
 ffff8880a0ca8480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8880a0ca8500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
