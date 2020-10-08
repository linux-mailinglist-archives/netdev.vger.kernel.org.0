Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6909287691
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730802AbgJHPAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:00:24 -0400
Received: from mail-io1-f78.google.com ([209.85.166.78]:38481 "EHLO
        mail-io1-f78.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730786AbgJHPAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:00:22 -0400
Received: by mail-io1-f78.google.com with SMTP id e21so3892087iod.5
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 08:00:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=ZWnDANWUQlu270VES8UjaVW3caWeIqfI6UFhnzEXQ7w=;
        b=FSy4BmOmXk5CcyvnbmcMbYq5OFud1OSJoDOOZgENuGUxAEOcNQ+GBFY+8LmaAPzneu
         XASOj1ZMjPRUCuIEa2kC/WvYEq1neYS/TwBNxPft6E7dJYM2gokzajnFz5rygmtoQnsN
         efOIjMnaelhKMgXVjzU3lADlTpYbsErSGg5ReONKe9JkABGl20AcBLioAQJpiDL4n7ML
         c19hfMYabA8rPRWeTkBZme5YZo9GdEnUVB76QDWhX5WgyyS5J24ok3rrrtDEOGIExwwR
         poghWfZZga94fAVzFNSFTwHjCollmv1PkJRt5/Yf5ZDz2T2NFqGLCxP0q9hmXLcc6TQn
         Fykw==
X-Gm-Message-State: AOAM5315Nv1R1FkCJKenR3yVUYDIrCnvBzIF/CFJKbkvzDFzKCWd0igm
        qpAvSmcP2w9p/Y2+cMa1oS5t6akW2ZUQ7CH8LAV8H2KaP7RG
X-Google-Smtp-Source: ABdhPJyDsh80CdKJN9vHU2pKOYGHSeFuAkgUIdPPIgOWvEhI1lpIBQ9fUZ5XSK+J4hRiIaC1WWkwahWSJcvIeEwkT54Uxf28Cuim
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:8b3:: with SMTP id a19mr6931279ilt.174.1602169220321;
 Thu, 08 Oct 2020 08:00:20 -0700 (PDT)
Date:   Thu, 08 Oct 2020 08:00:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003f57e905b12a17b5@google.com>
Subject: KASAN: slab-out-of-bounds Read in strset_parse_request
From:   syzbot <syzbot+9d1389df89299fa368dc@syzkaller.appspotmail.com>
To:     andrew@lunn.ch, davem@davemloft.net, f.fainelli@gmail.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org, mkubecek@suse.cz,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    9faebeb2 Merge branch 'ethtool-allow-dumping-policies-to-u..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=15f7dc00500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8ad9ecfafd94317b
dashboard link: https://syzkaller.appspot.com/bug?extid=9d1389df89299fa368dc
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15d9b94f900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=105268bf900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+9d1389df89299fa368dc@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-out-of-bounds in strset_parse_request+0x4dd/0x530 net/ethtool/strset.c:172
Read of size 8 at addr ffff8880a120be18 by task syz-executor483/6874

CPU: 1 PID: 6874 Comm: syz-executor483 Not tainted 5.9.0-rc8-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x198/0x1fd lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xae/0x497 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
 strset_parse_request+0x4dd/0x530 net/ethtool/strset.c:172
 ethnl_default_parse+0xda/0x130 net/ethtool/netlink.c:282
 ethnl_default_start+0x21f/0x510 net/ethtool/netlink.c:501
 genl_start+0x3cc/0x670 net/netlink/genetlink.c:604
 __netlink_dump_start+0x585/0x900 net/netlink/af_netlink.c:2363
 genl_family_rcv_msg_dumpit+0x1c9/0x310 net/netlink/genetlink.c:697
 genl_family_rcv_msg net/netlink/genetlink.c:780 [inline]
 genl_rcv_msg+0x434/0x580 net/netlink/genetlink.c:800
 netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2489
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:811
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:671
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2353
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2407
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2440
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x440979
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 5b 11 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffe892965e8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 0000000000440979
RDX: 0000000000000000 RSI: 0000000020000780 RDI: 0000000000000003
RBP: 00000000006ca018 R08: 0000000000000001 R09: 00000000004002c8
R10: 0000000000000008 R11: 0000000000000246 R12: 0000000000401f60
R13: 0000000000401ff0 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 6874:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:461
 __do_kmalloc mm/slab.c:3659 [inline]
 __kmalloc+0x1b0/0x360 mm/slab.c:3668
 kmalloc_array include/linux/slab.h:594 [inline]
 genl_family_rcv_msg_attrs_parse.constprop.0+0xd7/0x280 net/netlink/genetlink.c:543
 genl_start+0x187/0x670 net/netlink/genetlink.c:584
 __netlink_dump_start+0x585/0x900 net/netlink/af_netlink.c:2363
 genl_family_rcv_msg_dumpit+0x1c9/0x310 net/netlink/genetlink.c:697
 genl_family_rcv_msg net/netlink/genetlink.c:780 [inline]
 genl_rcv_msg+0x434/0x580 net/netlink/genetlink.c:800
 netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2489
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:811
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:671
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2353
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2407
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2440
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

The buggy address belongs to the object at ffff8880a120be00
 which belongs to the cache kmalloc-32 of size 32
The buggy address is located 24 bytes inside of
 32-byte region [ffff8880a120be00, ffff8880a120be20)
The buggy address belongs to the page:
page:000000007938d980 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff8880a120bfc1 pfn:0xa120b
flags: 0xfffe0000000200(slab)
raw: 00fffe0000000200 ffffea0002848c08 ffffea00027e6b48 ffff8880aa040100
raw: ffff8880a120bfc1 ffff8880a120b000 0000000100000011 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8880a120bd00: fb fb fb fb fc fc fc fc fa fb fb fb fc fc fc fc
 ffff8880a120bd80: fb fb fb fb fc fc fc fc 00 01 fc fc fc fc fc fc
>ffff8880a120be00: 00 00 00 fc fc fc fc fc 00 01 fc fc fc fc fc fc
                            ^
 ffff8880a120be80: fa fb fb fb fc fc fc fc fb fb fb fb fc fc fc fc
 ffff8880a120bf00: 05 fc fc fc fc fc fc fc 05 fc fc fc fc fc fc fc
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
