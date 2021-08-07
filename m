Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE753E3598
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 15:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbhHGNpD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Aug 2021 09:45:03 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:57231 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232226AbhHGNon (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Aug 2021 09:44:43 -0400
Received: by mail-io1-f69.google.com with SMTP id k24-20020a6bef180000b02904a03acf5d82so8632830ioh.23
        for <netdev@vger.kernel.org>; Sat, 07 Aug 2021 06:44:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=wcd86TwBbvRuo6PgGk+Tz2s7ytrHm9wrtsDmlZd8b+o=;
        b=QtiJHgoHKedrFcSwGFye99+Tqfx+z/XyqtF4G9DYYmZ/Z9p7svyHT0Uho2GPmDlaht
         Bv2T6bOK1oPhwr9nXTUIHGh+Topb7vkbDw47oWTSr4SlbDNGmxr6XsmgU17xfG03mSFp
         nEf7uK1ltlf6E1YRoakLbzZUSazok1W1vYfuF7tU6Hhm+l15Jnd4ah9wapF32acMdJLw
         Iud5unMD9pqi0PRWTl+MDdoOQr9feyk8GTmInx/Hm3NXcHsIyl4iHq5P/7P0wAy4lfbd
         RSul/iG4I9vYbVtJ3gsfSvHYYEjbZq1h11NVhP1BohoPwVt04A9EUiVD6xSt18CubiNu
         Fy0A==
X-Gm-Message-State: AOAM532Gz2wyB3x6i7E3gYdtOMUii1wOrxpLuqtALxIehYKkUbap/bUw
        vFO5sb+O7zj1vWR7T46fPC6eKfsLE3ec58MZkE0zut3kQ3RS
X-Google-Smtp-Source: ABdhPJyNPKaAyAEcLeupWVAnK3WKEX5j8kqp+MilpGofVwNZIvzt4lrNxlsclAghPK9SayPloeu6sWKENOq7X7jp93HQxLW6ktrM
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1543:: with SMTP id j3mr355325ilu.308.1628343866170;
 Sat, 07 Aug 2021 06:44:26 -0700 (PDT)
Date:   Sat, 07 Aug 2021 06:44:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b720b705c8f8599f@google.com>
Subject: [syzbot] KASAN: use-after-free Write in nft_ct_tmpl_put_pcpu
From:   syzbot <syzbot+649e339fa6658ee623d3@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    894d6f401b21 Merge tag 'spi-fix-v5.14-rc4' of git://git.ke..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17c622fa300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=343fd21f6f4da2d6
dashboard link: https://syzkaller.appspot.com/bug?extid=649e339fa6658ee623d3
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=110319aa300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1142fac9d00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+649e339fa6658ee623d3@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in instrument_atomic_read_write include/linux/instrumented.h:101 [inline]
BUG: KASAN: use-after-free in atomic_dec_and_test include/asm-generic/atomic-instrumented.h:542 [inline]
BUG: KASAN: use-after-free in nf_conntrack_put include/linux/netfilter/nf_conntrack_common.h:33 [inline]
BUG: KASAN: use-after-free in nf_ct_put include/net/netfilter/nf_conntrack.h:176 [inline]
BUG: KASAN: use-after-free in nft_ct_tmpl_put_pcpu+0x135/0x1e0 net/netfilter/nft_ct.c:356
Write of size 4 at addr ffff88803d750400 by task syz-executor409/9789

CPU: 0 PID: 9789 Comm: syz-executor409 Not tainted 5.14.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:105
 print_address_description.constprop.0.cold+0x6c/0x309 mm/kasan/report.c:233
 __kasan_report mm/kasan/report.c:419 [inline]
 kasan_report.cold+0x83/0xdf mm/kasan/report.c:436
 check_region_inline mm/kasan/generic.c:183 [inline]
 kasan_check_range+0x13d/0x180 mm/kasan/generic.c:189
 instrument_atomic_read_write include/linux/instrumented.h:101 [inline]
 atomic_dec_and_test include/asm-generic/atomic-instrumented.h:542 [inline]
 nf_conntrack_put include/linux/netfilter/nf_conntrack_common.h:33 [inline]
 nf_ct_put include/net/netfilter/nf_conntrack.h:176 [inline]
 nft_ct_tmpl_put_pcpu+0x135/0x1e0 net/netfilter/nft_ct.c:356
 __nft_ct_set_destroy net/netfilter/nft_ct.c:529 [inline]
 __nft_ct_set_destroy net/netfilter/nft_ct.c:518 [inline]
 nft_ct_set_init+0x41e/0x750 net/netfilter/nft_ct.c:614
 nf_tables_newexpr net/netfilter/nf_tables_api.c:2742 [inline]
 nft_expr_init+0x145/0x2d0 net/netfilter/nf_tables_api.c:2780
 nft_set_elem_expr_alloc+0x27/0x280 net/netfilter/nf_tables_api.c:5284
 nf_tables_newset+0x208a/0x32f0 net/netfilter/nf_tables_api.c:4389
 nfnetlink_rcv_batch+0x1710/0x25f0 net/netfilter/nfnetlink.c:513
 nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:634 [inline]
 nfnetlink_rcv+0x3af/0x420 net/netfilter/nfnetlink.c:652
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
 sock_sendmsg_nosec net/socket.c:703 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:723
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2392
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2446
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2475
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x444819
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 41 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c4 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff0ba410d8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000444819
RDX: 0000000000000000 RSI: 00000000200000c0 RDI: 0000000000000003
RBP: 0000000000000000 R08: 00000000000f4240 R09: 00000000000f4240
R10: 00007fff0ba40b60 R11: 0000000000000246 R12: 00007fff0ba41100
R13: 00000000000f4240 R14: 000000000003754e R15: 00007fff0ba410f4

Allocated by task 9789:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:434 [inline]
 ____kasan_kmalloc mm/kasan/common.c:513 [inline]
 ____kasan_kmalloc mm/kasan/common.c:472 [inline]
 __kasan_kmalloc+0x9b/0xd0 mm/kasan/common.c:522
 kmalloc include/linux/slab.h:591 [inline]
 kzalloc include/linux/slab.h:721 [inline]
 nf_ct_tmpl_alloc+0x8d/0x270 net/netfilter/nf_conntrack_core.c:569
 nft_ct_tmpl_alloc_pcpu net/netfilter/nft_ct.c:371 [inline]
 nft_ct_set_init+0x4d6/0x750 net/netfilter/nft_ct.c:567
 nf_tables_newexpr net/netfilter/nf_tables_api.c:2742 [inline]
 nft_expr_init+0x145/0x2d0 net/netfilter/nf_tables_api.c:2780
 nft_set_elem_expr_alloc+0x27/0x280 net/netfilter/nf_tables_api.c:5284
 nf_tables_newset+0x208a/0x32f0 net/netfilter/nf_tables_api.c:4389
 nfnetlink_rcv_batch+0x1710/0x25f0 net/netfilter/nfnetlink.c:513
 nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:634 [inline]
 nfnetlink_rcv+0x3af/0x420 net/netfilter/nfnetlink.c:652
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
 sock_sendmsg_nosec net/socket.c:703 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:723
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2392
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2446
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2475
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Freed by task 9788:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track+0x1c/0x30 mm/kasan/common.c:46
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:360
 ____kasan_slab_free mm/kasan/common.c:366 [inline]
 ____kasan_slab_free mm/kasan/common.c:328 [inline]
 __kasan_slab_free+0xfb/0x130 mm/kasan/common.c:374
 kasan_slab_free include/linux/kasan.h:230 [inline]
 slab_free_hook mm/slub.c:1625 [inline]
 slab_free_freelist_hook+0xdf/0x240 mm/slub.c:1650
 slab_free mm/slub.c:3210 [inline]
 kfree+0xe4/0x530 mm/slub.c:4264
 nf_ct_tmpl_free net/netfilter/nf_conntrack_core.c:590 [inline]
 destroy_conntrack+0x222/0x2c0 net/netfilter/nf_conntrack_core.c:613
 nf_conntrack_destroy+0xab/0x230 net/netfilter/core.c:677
 nf_conntrack_put include/linux/netfilter/nf_conntrack_common.h:34 [inline]
 nf_ct_put include/net/netfilter/nf_conntrack.h:176 [inline]
 nft_ct_tmpl_put_pcpu+0x15e/0x1e0 net/netfilter/nft_ct.c:356
 __nft_ct_set_destroy net/netfilter/nft_ct.c:529 [inline]
 __nft_ct_set_destroy net/netfilter/nft_ct.c:518 [inline]
 nft_ct_set_init+0x41e/0x750 net/netfilter/nft_ct.c:614
 nf_tables_newexpr net/netfilter/nf_tables_api.c:2742 [inline]
 nft_expr_init+0x145/0x2d0 net/netfilter/nf_tables_api.c:2780
 nft_set_elem_expr_alloc+0x27/0x280 net/netfilter/nf_tables_api.c:5284
 nf_tables_newset+0x208a/0x32f0 net/netfilter/nf_tables_api.c:4389
 nfnetlink_rcv_batch+0x1710/0x25f0 net/netfilter/nfnetlink.c:513
 nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:634 [inline]
 nfnetlink_rcv+0x3af/0x420 net/netfilter/nfnetlink.c:652
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
 sock_sendmsg_nosec net/socket.c:703 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:723
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2392
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2446
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2475
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

The buggy address belongs to the object at ffff88803d750400
 which belongs to the cache kmalloc-512 of size 512
The buggy address is located 0 bytes inside of
 512-byte region [ffff88803d750400, ffff88803d750600)
The buggy address belongs to the page:
page:ffffea0000f5d400 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x3d750
head:ffffea0000f5d400 order:2 compound_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 0000000000000000 dead000000000122 ffff888010841c80
raw: 0000000000000000 0000000080100010 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 2, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 9789, ts 226704064982, free_ts 0
 prep_new_page mm/page_alloc.c:2436 [inline]
 get_page_from_freelist+0xa72/0x2f80 mm/page_alloc.c:4169
 __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5391
 alloc_pages+0x18c/0x2a0 mm/mempolicy.c:2244
 alloc_slab_page mm/slub.c:1688 [inline]
 allocate_slab+0x32e/0x4b0 mm/slub.c:1828
 new_slab mm/slub.c:1891 [inline]
 new_slab_objects mm/slub.c:2637 [inline]
 ___slab_alloc+0x4ba/0x820 mm/slub.c:2800
 __slab_alloc.constprop.0+0xa7/0xf0 mm/slub.c:2840
 slab_alloc_node mm/slub.c:2922 [inline]
 slab_alloc mm/slub.c:2964 [inline]
 kmem_cache_alloc_trace+0x30f/0x3c0 mm/slub.c:2981
 kmalloc include/linux/slab.h:591 [inline]
 kzalloc include/linux/slab.h:721 [inline]
 nf_ct_tmpl_alloc+0x8d/0x270 net/netfilter/nf_conntrack_core.c:569
 nft_ct_tmpl_alloc_pcpu net/netfilter/nft_ct.c:371 [inline]
 nft_ct_set_init+0x4d6/0x750 net/netfilter/nft_ct.c:567
 nf_tables_newexpr net/netfilter/nf_tables_api.c:2742 [inline]
 nft_expr_init+0x145/0x2d0 net/netfilter/nf_tables_api.c:2780
 nft_set_elem_expr_alloc+0x27/0x280 net/netfilter/nf_tables_api.c:5284
 nf_tables_newset+0x208a/0x32f0 net/netfilter/nf_tables_api.c:4389
 nfnetlink_rcv_batch+0x1710/0x25f0 net/netfilter/nfnetlink.c:513
 nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:634 [inline]
 nfnetlink_rcv+0x3af/0x420 net/netfilter/nfnetlink.c:652
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
page_owner free stack trace missing

Memory state around the buggy address:
 ffff88803d750300: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88803d750380: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff88803d750400: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                   ^
 ffff88803d750480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88803d750500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
