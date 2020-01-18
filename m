Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1DC6141668
	for <lists+netdev@lfdr.de>; Sat, 18 Jan 2020 08:57:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbgARH5K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jan 2020 02:57:10 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:33891 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbgARH5K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jan 2020 02:57:10 -0500
Received: by mail-io1-f71.google.com with SMTP id n26so16665151ioj.1
        for <netdev@vger.kernel.org>; Fri, 17 Jan 2020 23:57:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=dn6Mqk5M7w9NzrOVtlnGFmAkuKgRc5x79zF9Jwzx7/4=;
        b=b+tGA2gbqkKCJ9Blzg/DaTvAzqjekygLEQ9WI/CT0G42T9JI/9XtCeMWRkBNnQTXKa
         DTIKEVTp6VnVMBgQxoJ6MYWhselEeRbkj5GcB7oMHE/6xUBDeRv4X5iFGNljPbit+/rI
         El/HnN216gK4/nwyii1iGvpV0vZFunLz7eV4l7amUnryXUYMV8BP+X2tr7s+3VNMHHX/
         R/FmeQ6lNcJ0afp3jiFqExEt5R9CK59K+r6NnV1QU+hMXcJJEu0qU2NgC1uVR9ejM3fR
         RH4WKXXDzPzGmwPylZHjiXyPi5X6fUDVcnA4BsRuVxWiuhDPtQkPrxPn0h/zhqcy/B9a
         nNAQ==
X-Gm-Message-State: APjAAAW6OunWpMqwlTjUnEh/dYL9nByzi2c195iUDH3xzUBSTS3SPxHK
        yQPrODAT6+xDiHvKp/tqOKIy6sYCNMfHNZTPbDOVBRa6/FOn
X-Google-Smtp-Source: APXvYqzQzleK9ft7KD6qMN9HBdKI0K+Gs9WpEFigiznE20uG357xij3fkGZ85ns7CD1dfVt/gD8Q6rK8bqgw4MF+lDN7ExGtqCQM
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:8e2:: with SMTP id n2mr2243831ilt.167.1579334229408;
 Fri, 17 Jan 2020 23:57:09 -0800 (PST)
Date:   Fri, 17 Jan 2020 23:57:09 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b9c312059c656759@google.com>
Subject: KASAN: slab-out-of-bounds Read in bitmap_ipmac_list
From:   syzbot <syzbot+190d63957b22ef673ea5@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net,
        florent.fourcot@wifirst.fr, fw@strlen.de, jeremy@azazel.net,
        johannes.berg@intel.com, kadlec@netfilter.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    ab7541c3 Merge tag 'fuse-fixes-5.5-rc7' of git://git.kerne..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=115112a5e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cfbb8fa33f49f9f3
dashboard link: https://syzkaller.appspot.com/bug?extid=190d63957b22ef673ea5
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17ebc1d1e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12f9b1d1e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+190d63957b22ef673ea5@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-out-of-bounds in test_bit include/asm-generic/bitops/instrumented-non-atomic.h:110 [inline]
BUG: KASAN: slab-out-of-bounds in bitmap_ipmac_list+0x40d/0xdd0 net/netfilter/ipset/ip_set_bitmap_gen.h:222
Read of size 8 at addr ffff8880a06e5d00 by task syz-executor278/8566

CPU: 1 PID: 8566 Comm: syz-executor278 Not tainted 5.5.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1fb/0x318 lib/dump_stack.c:118
 print_address_description+0x74/0x5c0 mm/kasan/report.c:374
 __kasan_report+0x149/0x1c0 mm/kasan/report.c:506
 kasan_report+0x26/0x50 mm/kasan/common.c:639
 check_memory_region_inline mm/kasan/generic.c:182 [inline]
 check_memory_region+0x2b6/0x2f0 mm/kasan/generic.c:192
 __kasan_check_read+0x11/0x20 mm/kasan/common.c:95
 test_bit include/asm-generic/bitops/instrumented-non-atomic.h:110 [inline]
 bitmap_ipmac_list+0x40d/0xdd0 net/netfilter/ipset/ip_set_bitmap_gen.h:222
 ip_set_dump_start+0x10f9/0x1800 net/netfilter/ipset/ip_set_core.c:1632
 netlink_dump+0x4ed/0x1170 net/netlink/af_netlink.c:2244
 __netlink_dump_start+0x5cb/0x7b0 net/netlink/af_netlink.c:2352
 netlink_dump_start include/linux/netlink.h:233 [inline]
 ip_set_dump+0x107/0x160 net/netfilter/ipset/ip_set_core.c:1690
 nfnetlink_rcv_msg+0x9ae/0xcd0 net/netfilter/nfnetlink.c:229
 netlink_rcv_skb+0x19e/0x3e0 net/netlink/af_netlink.c:2477
 nfnetlink_rcv+0x1e0/0x1e50 net/netfilter/nfnetlink.c:563
 netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
 netlink_unicast+0x767/0x920 net/netlink/af_netlink.c:1328
 netlink_sendmsg+0xa2c/0xd50 net/netlink/af_netlink.c:1917
 sock_sendmsg_nosec net/socket.c:639 [inline]
 sock_sendmsg net/socket.c:659 [inline]
 ____sys_sendmsg+0x4f7/0x7f0 net/socket.c:2330
 ___sys_sendmsg net/socket.c:2384 [inline]
 __sys_sendmsg+0x1ed/0x290 net/socket.c:2417
 __do_sys_sendmsg net/socket.c:2426 [inline]
 __se_sys_sendmsg net/socket.c:2424 [inline]
 __x64_sys_sendmsg+0x7f/0x90 net/socket.c:2424
 do_syscall_64+0xf7/0x1c0 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x440539
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffef7b9cde8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 0000000000440539
RDX: 0000000000000040 RSI: 0000000020000680 RDI: 0000000000000004
RBP: 00000000006ca018 R08: 00000000004002c8 R09: 00000000004002c8
R10: 00000000004002c8 R11: 0000000000000246 R12: 0000000000401dc0
R13: 0000000000401e50 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 8566:
 save_stack mm/kasan/common.c:72 [inline]
 set_track mm/kasan/common.c:80 [inline]
 __kasan_kmalloc+0x118/0x1c0 mm/kasan/common.c:513
 kasan_kmalloc+0x9/0x10 mm/kasan/common.c:527
 __do_kmalloc mm/slab.c:3656 [inline]
 __kmalloc+0x254/0x340 mm/slab.c:3665
 kmalloc include/linux/slab.h:561 [inline]
 kzalloc+0x21/0x40 include/linux/slab.h:670
 ip_set_alloc+0x32/0x60 net/netfilter/ipset/ip_set_core.c:255
 init_map_ipmac net/netfilter/ipset/ip_set_bitmap_ipmac.c:302 [inline]
 bitmap_ipmac_create+0x3d9/0x840 net/netfilter/ipset/ip_set_bitmap_ipmac.c:365
 ip_set_create+0x421/0xfd0 net/netfilter/ipset/ip_set_core.c:1111
 nfnetlink_rcv_msg+0x9ae/0xcd0 net/netfilter/nfnetlink.c:229
 netlink_rcv_skb+0x19e/0x3e0 net/netlink/af_netlink.c:2477
 nfnetlink_rcv+0x1e0/0x1e50 net/netfilter/nfnetlink.c:563
 netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
 netlink_unicast+0x767/0x920 net/netlink/af_netlink.c:1328
 netlink_sendmsg+0xa2c/0xd50 net/netlink/af_netlink.c:1917
 sock_sendmsg_nosec net/socket.c:639 [inline]
 sock_sendmsg net/socket.c:659 [inline]
 ____sys_sendmsg+0x4f7/0x7f0 net/socket.c:2330
 ___sys_sendmsg net/socket.c:2384 [inline]
 __sys_sendmsg+0x1ed/0x290 net/socket.c:2417
 __do_sys_sendmsg net/socket.c:2426 [inline]
 __se_sys_sendmsg net/socket.c:2424 [inline]
 __x64_sys_sendmsg+0x7f/0x90 net/socket.c:2424
 do_syscall_64+0xf7/0x1c0 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 8261:
 save_stack mm/kasan/common.c:72 [inline]
 set_track mm/kasan/common.c:80 [inline]
 kasan_set_free_info mm/kasan/common.c:335 [inline]
 __kasan_slab_free+0x12e/0x1e0 mm/kasan/common.c:474
 kasan_slab_free+0xe/0x10 mm/kasan/common.c:483
 __cache_free mm/slab.c:3426 [inline]
 kfree+0x10d/0x220 mm/slab.c:3757
 tomoyo_check_open_permission+0x79c/0x9d0 security/tomoyo/file.c:786
 tomoyo_file_open+0x141/0x190 security/tomoyo/tomoyo.c:319
 security_file_open+0x50/0x2e0 security/security.c:1497
 do_dentry_open+0x351/0x10c0 fs/open.c:784
 vfs_open+0x73/0x80 fs/open.c:914
 do_last fs/namei.c:3356 [inline]
 path_openat+0x1367/0x4250 fs/namei.c:3473
 do_filp_open+0x192/0x3d0 fs/namei.c:3503
 do_sys_open+0x29f/0x560 fs/open.c:1097
 __do_sys_open fs/open.c:1115 [inline]
 __se_sys_open fs/open.c:1110 [inline]
 __x64_sys_open+0x87/0x90 fs/open.c:1110
 do_syscall_64+0xf7/0x1c0 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff8880a06e5d00
 which belongs to the cache kmalloc-32 of size 32
The buggy address is located 0 bytes inside of
 32-byte region [ffff8880a06e5d00, ffff8880a06e5d20)
The buggy address belongs to the page:
page:ffffea000281b940 refcount:1 mapcount:0 mapping:ffff8880aa8001c0 index:0xffff8880a06e5fc1
raw: 00fffe0000000200 ffffea0002a6f648 ffffea00028b0648 ffff8880aa8001c0
raw: ffff8880a06e5fc1 ffff8880a06e5000 000000010000003f 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8880a06e5c00: fb fb fb fb fc fc fc fc 00 00 00 fc fc fc fc fc
 ffff8880a06e5c80: fb fb fb fb fc fc fc fc fb fb fb fb fc fc fc fc
>ffff8880a06e5d00: 04 fc fc fc fc fc fc fc fb fb fb fb fc fc fc fc
                   ^
 ffff8880a06e5d80: fb fb fb fb fc fc fc fc fb fb fb fb fc fc fc fc
 ffff8880a06e5e00: 00 00 00 fc fc fc fc fc fb fb fb fb fc fc fc fc
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
