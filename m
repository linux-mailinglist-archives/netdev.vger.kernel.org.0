Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A408B148EF5
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 20:57:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392401AbgAXT5W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 14:57:22 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:42924 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391837AbgAXT5M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 14:57:12 -0500
Received: by mail-io1-f70.google.com with SMTP id e7so2013592iog.9
        for <netdev@vger.kernel.org>; Fri, 24 Jan 2020 11:57:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=sAFaEA+BSTQ/YzFzmKO41vTV+JAzWArpZYlyNlcrVNU=;
        b=p4phKoLjrKbPdR7+QU04PPtOG/hfvwM4IdcaUmotAAu5Y9ZWAMoIC5KXbLse0byp72
         p/ShAj0HqmGuwBnotKMHUKzNT+Ou8vhkJzI6fsb+mJ27F1iXCqQe9UuyHwHYVqQgjv6N
         bxgrvcJidouFi3dkKfrU4fH0o+WnzTEH3uGISah2gzfZFV7S9gZvAprkmyHhxIYJnzra
         FcBcm7yuDHsex9vDwbr+sJJ0v3r890RYTn5y6YWKbAdfMJoN0dhOLRZZjkI2qOZtrrve
         Qvj4Aie8hCZ5iKuBxzkWzObwrg7fuUL8dcye52IbfzCOC1hITOVLPpE3rnUpTd6dGsUY
         yt4g==
X-Gm-Message-State: APjAAAXbUHhIVdh/EF0P9sGJu6HqcUDlNBZki1sYNlMfLOlk8S9dgmDZ
        iAht19PBjXKwYMX+KW545Jy+0wElR78mzUDNrjpm7PlITdSf
X-Google-Smtp-Source: APXvYqxiWj5tK6sdcHHza+l+o2ho3rTONj9Vt3Seh562PbEf40PrbIq7n1PqXAvyKaEOMJDkbg0yYPPjOSNHZ0TmEXGKih4mKAsb
MIME-Version: 1.0
X-Received: by 2002:a6b:8ecd:: with SMTP id q196mr3438032iod.136.1579895831247;
 Fri, 24 Jan 2020 11:57:11 -0800 (PST)
Date:   Fri, 24 Jan 2020 11:57:11 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000cdbe79059ce82948@google.com>
Subject: KASAN: slab-out-of-bounds Read in bitmap_ipmac_destroy
From:   syzbot <syzbot+a85062dec5d65617cc1c@syzkaller.appspotmail.com>
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

HEAD commit:    4703d911 Merge tag 'xarray-5.5' of git://git.infradead.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11601611e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=83c00afca9cf5153
dashboard link: https://syzkaller.appspot.com/bug?extid=a85062dec5d65617cc1c
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1301ed85e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14b7b79ee00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+a85062dec5d65617cc1c@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-out-of-bounds in test_bit include/asm-generic/bitops/instrumented-non-atomic.h:110 [inline]
BUG: KASAN: slab-out-of-bounds in bitmap_ipmac_ext_cleanup net/netfilter/ipset/ip_set_bitmap_gen.h:51 [inline]
BUG: KASAN: slab-out-of-bounds in bitmap_ipmac_destroy+0x1d2/0x3c0 net/netfilter/ipset/ip_set_bitmap_gen.h:64
Read of size 8 at addr ffff8880a71e5e00 by task syz-executor455/8657

CPU: 1 PID: 8657 Comm: syz-executor455 Not tainted 5.5.0-rc7-syzkaller #0
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
 bitmap_ipmac_ext_cleanup net/netfilter/ipset/ip_set_bitmap_gen.h:51 [inline]
 bitmap_ipmac_destroy+0x1d2/0x3c0 net/netfilter/ipset/ip_set_bitmap_gen.h:64
 ip_set_create+0xae0/0xfd0 net/netfilter/ipset/ip_set_core.c:1165
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
RIP: 0033:0x4413f9
Code: e8 fc ab 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 9b 09 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffdcc88fa08 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00000000004413f9
RDX: 0000000000000000 RSI: 0000000020000300 RDI: 0000000000000003
RBP: 00000000000100d9 R08: 00000000004002c8 R09: 00000000004002c8
R10: 0000000000000004 R11: 0000000000000246 R12: 0000000000402220
R13: 00000000004022b0 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 8657:
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

Freed by task 0:
(stack is not available)

The buggy address belongs to the object at ffff8880a71e4000
 which belongs to the cache kmalloc-8k of size 8192
The buggy address is located 7680 bytes inside of
 8192-byte region [ffff8880a71e4000, ffff8880a71e6000)
The buggy address belongs to the page:
page:ffffea00029c7900 refcount:1 mapcount:0 mapping:ffff8880aa8021c0 index:0x0 compound_mapcount: 0
raw: 00fffe0000010200 ffffea000230b908 ffff8880aa801b48 ffff8880aa8021c0
raw: 0000000000000000 ffff8880a71e4000 0000000100000001 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8880a71e5d00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff8880a71e5d80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff8880a71e5e00: 04 fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
                   ^
 ffff8880a71e5e80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff8880a71e5f00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
