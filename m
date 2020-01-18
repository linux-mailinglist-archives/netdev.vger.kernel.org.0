Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A97314166D
	for <lists+netdev@lfdr.de>; Sat, 18 Jan 2020 08:57:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbgARH5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jan 2020 02:57:25 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:53086 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726444AbgARH5K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jan 2020 02:57:10 -0500
Received: by mail-il1-f200.google.com with SMTP id n9so20820020ilm.19
        for <netdev@vger.kernel.org>; Fri, 17 Jan 2020 23:57:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=gotre1v45vmPlzMfoSZXarOBWu5ufj3kG39ObIdErvc=;
        b=rkR/pj/W4RTvengZ3LWdTzALVPoQgHOb2Ow11UFvvyOK+jfDnEAKH4m09QRcLzXyJ8
         90ED5b7qFSxfWQhuAgLywepd07Jbo/977Hzfqqr8xdtZ1u3AIGc0jNqUSVep2N9Zy+Hx
         BGsQ/WEeEYHp1HaraKRzjjT/zNGFnkQ2SmjnWcaJ12KzXVHVCSyuj6IXTjjYhKmfKVif
         P8SHH2HXVcONJ+7FwIx+g9PL4tnYwSdi6r1u1eCPYz4BIJUKW+IRNFG90Hs66w2oS3jV
         lkeHXC4O7vw5RhW9Wvz6FFRBrZgArMpQtUI/5P3QrPcdFuJ+A8V2QDBobJ1IFupZJR38
         eHKQ==
X-Gm-Message-State: APjAAAVwQE5uWyjdzNrdGFgzVdUAaXVfgikCTZddVAOFVSV59dOrM7qR
        H6GQXENFOwmFWyWGaqg9/G/Kmh8aaSV1rMD4prYwB2P0Au3m
X-Google-Smtp-Source: APXvYqzkJ4PFk3k4RNA52/d0weaCnn/yCVPhqsdxho9tJ65SODt0Ao0hJB6s8gvkfi5JaX+u7IjDMeYrNQbOFKyp0NgFPQIYrtwc
MIME-Version: 1.0
X-Received: by 2002:a92:db4f:: with SMTP id w15mr2113328ilq.182.1579334229653;
 Fri, 17 Jan 2020 23:57:09 -0800 (PST)
Date:   Fri, 17 Jan 2020 23:57:09 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000bd7c6d059c6567e8@google.com>
Subject: KASAN: slab-out-of-bounds Read in bitmap_ip_list
From:   syzbot <syzbot+827ced406c9a1d9570ed@syzkaller.appspotmail.com>
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

HEAD commit:    5a9ef194 net: systemport: Fixed queue mapping in internal ..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=12c26faee00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7e89bd00623fe71e
dashboard link: https://syzkaller.appspot.com/bug?extid=827ced406c9a1d9570ed
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16abc1d1e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11dde495e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+827ced406c9a1d9570ed@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-out-of-bounds in test_bit include/asm-generic/bitops/instrumented-non-atomic.h:110 [inline]
BUG: KASAN: slab-out-of-bounds in bitmap_ip_list+0x40f/0xf20 net/netfilter/ipset/ip_set_bitmap_gen.h:222
Read of size 8 at addr ffff88809acff240 by task syz-executor210/9545

CPU: 0 PID: 9545 Comm: syz-executor210 Not tainted 5.5.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x197/0x210 lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xd4/0x30b mm/kasan/report.c:374
 __kasan_report.cold+0x1b/0x41 mm/kasan/report.c:506
 kasan_report+0x12/0x20 mm/kasan/common.c:639
 check_memory_region_inline mm/kasan/generic.c:185 [inline]
 check_memory_region+0x134/0x1a0 mm/kasan/generic.c:192
 __kasan_check_read+0x11/0x20 mm/kasan/common.c:95
 test_bit include/asm-generic/bitops/instrumented-non-atomic.h:110 [inline]
 bitmap_ip_list+0x40f/0xf20 net/netfilter/ipset/ip_set_bitmap_gen.h:222
 ip_set_dump_start+0x96c/0x1ca0 net/netfilter/ipset/ip_set_core.c:1632
 netlink_dump+0x558/0xfb0 net/netlink/af_netlink.c:2244
 __netlink_dump_start+0x66a/0x930 net/netlink/af_netlink.c:2352
 netlink_dump_start include/linux/netlink.h:233 [inline]
 ip_set_dump+0x15a/0x1d0 net/netfilter/ipset/ip_set_core.c:1690
 nfnetlink_rcv_msg+0xcf2/0xfb0 net/netfilter/nfnetlink.c:229
 netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
 nfnetlink_rcv+0x1ba/0x460 net/netfilter/nfnetlink.c:563
 netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
 netlink_unicast+0x58c/0x7d0 net/netlink/af_netlink.c:1328
 netlink_sendmsg+0x91c/0xea0 net/netlink/af_netlink.c:1917
 sock_sendmsg_nosec net/socket.c:639 [inline]
 sock_sendmsg+0xd7/0x130 net/socket.c:659
 ____sys_sendmsg+0x753/0x880 net/socket.c:2330
 ___sys_sendmsg+0x100/0x170 net/socket.c:2384
 __sys_sendmsg+0x105/0x1d0 net/socket.c:2417
 __do_sys_sendmsg net/socket.c:2426 [inline]
 __se_sys_sendmsg net/socket.c:2424 [inline]
 __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2424
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x440529
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffc7dffe988 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 0000000000440529
RDX: 0000000000000000 RSI: 0000000020000540 RDI: 0000000000000004
RBP: 00000000006ca018 R08: 00000000004002c8 R09: 00000000004002c8
R10: 00000000004002c8 R11: 0000000000000246 R12: 0000000000401db0
R13: 0000000000401e40 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 9545:
 save_stack+0x23/0x90 mm/kasan/common.c:72
 set_track mm/kasan/common.c:80 [inline]
 __kasan_kmalloc mm/kasan/common.c:513 [inline]
 __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:486
 kasan_kmalloc+0x9/0x10 mm/kasan/common.c:527
 __do_kmalloc mm/slab.c:3656 [inline]
 __kmalloc+0x163/0x770 mm/slab.c:3665
 kmalloc include/linux/slab.h:561 [inline]
 kzalloc include/linux/slab.h:670 [inline]
 ip_set_alloc+0x38/0x5e net/netfilter/ipset/ip_set_core.c:255
 init_map_ip net/netfilter/ipset/ip_set_bitmap_ip.c:223 [inline]
 bitmap_ip_create+0x6ec/0xc20 net/netfilter/ipset/ip_set_bitmap_ip.c:327
 ip_set_create+0x6f1/0x1500 net/netfilter/ipset/ip_set_core.c:1111
 nfnetlink_rcv_msg+0xcf2/0xfb0 net/netfilter/nfnetlink.c:229
 netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
 nfnetlink_rcv+0x1ba/0x460 net/netfilter/nfnetlink.c:563
 netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
 netlink_unicast+0x58c/0x7d0 net/netlink/af_netlink.c:1328
 netlink_sendmsg+0x91c/0xea0 net/netlink/af_netlink.c:1917
 sock_sendmsg_nosec net/socket.c:639 [inline]
 sock_sendmsg+0xd7/0x130 net/socket.c:659
 ____sys_sendmsg+0x753/0x880 net/socket.c:2330
 ___sys_sendmsg+0x100/0x170 net/socket.c:2384
 __sys_sendmsg+0x105/0x1d0 net/socket.c:2417
 __do_sys_sendmsg net/socket.c:2426 [inline]
 __se_sys_sendmsg net/socket.c:2424 [inline]
 __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2424
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 9263:
 save_stack+0x23/0x90 mm/kasan/common.c:72
 set_track mm/kasan/common.c:80 [inline]
 kasan_set_free_info mm/kasan/common.c:335 [inline]
 __kasan_slab_free+0x102/0x150 mm/kasan/common.c:474
 kasan_slab_free+0xe/0x10 mm/kasan/common.c:483
 __cache_free mm/slab.c:3426 [inline]
 kfree+0x10a/0x2c0 mm/slab.c:3757
 tomoyo_path_perm+0x24e/0x430 security/tomoyo/file.c:842
 tomoyo_inode_getattr+0x1d/0x30 security/tomoyo/tomoyo.c:129
 security_inode_getattr+0xf2/0x150 security/security.c:1222
 vfs_getattr+0x25/0x70 fs/stat.c:115
 vfs_statx+0x157/0x200 fs/stat.c:191
 vfs_stat include/linux/fs.h:3249 [inline]
 __do_sys_newstat+0xa4/0x130 fs/stat.c:341
 __se_sys_newstat fs/stat.c:337 [inline]
 __x64_sys_newstat+0x54/0x80 fs/stat.c:337
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff88809acff240
 which belongs to the cache kmalloc-32 of size 32
The buggy address is located 0 bytes inside of
 32-byte region [ffff88809acff240, ffff88809acff260)
The buggy address belongs to the page:
page:ffffea00026b3fc0 refcount:1 mapcount:0 mapping:ffff8880aa4001c0 index:0xffff88809acfffc1
raw: 00fffe0000000200 ffffea00028c1388 ffffea00027ba748 ffff8880aa4001c0
raw: ffff88809acfffc1 ffff88809acff000 000000010000003f 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88809acff100: fb fb fb fb fc fc fc fc fb fb fb fb fc fc fc fc
 ffff88809acff180: 00 00 fc fc fc fc fc fc fb fb fb fb fc fc fc fc
>ffff88809acff200: fb fb fb fb fc fc fc fc 04 fc fc fc fc fc fc fc
                                           ^
 ffff88809acff280: fb fb fb fb fc fc fc fc fb fb fb fb fc fc fc fc
 ffff88809acff300: fb fb fb fb fc fc fc fc fb fb fb fb fc fc fc fc
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
