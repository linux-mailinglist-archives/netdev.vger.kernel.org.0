Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80DF74737DA
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 23:46:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243822AbhLMWqY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 17:46:24 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:48676 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243713AbhLMWqX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 17:46:23 -0500
Received: by mail-il1-f198.google.com with SMTP id k9-20020a056e02156900b002a1acf9a52dso16003536ilu.15
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 14:46:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=6slidn2uLEYo6Q9quCUllTZBd4MA2hHMb0ZjtiLaISk=;
        b=4JVWpQYIe4bmiLI0vNShsLl13y0wR67z25lRrh+jinClf8APobhB/eubU4Cd5iYpPb
         gEhyo2AT4xvLMSFA2yTnJzR8t7R/T66k4H5+BZYFJSO8srElHOauKsIENtwBJvHpqJPm
         Sj1zomRUQJu8sf/THacd2tede92hV+kqWccOjSDxZUsIALul8W0TNHo1msTHUOZxE6XA
         bFLdtcMFIxQqMVIrTigURr63JsZzYYL+TrHr9dZUJT1kttTiyriQrzcrkewU76qJKAOv
         SHf/fIzQgHa7ymicllgw3wFcLS7a23MyDI2gimQYEB6GLssDns83KzWWSgBzTipru/LX
         hAxA==
X-Gm-Message-State: AOAM531eGDbxlBhR+11NZYMYlnAD+F9hST3MwGNlR7Ba42RRvH8nCs7z
        l/33S5iS/HxfmaKmSXuFsOV75OeFhX20I2CdcNDqZ1X5Nvo6
X-Google-Smtp-Source: ABdhPJwEPv5XuqrZL8qEyaior1XLR9mNECqghXQzSzapQvn55xg83i1Ll/IacX3ZI3+i4TgL5mgRm+Y8oubsH3QOKLAdZ3Aoxtar
MIME-Version: 1.0
X-Received: by 2002:a05:6638:2186:: with SMTP id s6mr753535jaj.96.1639435582645;
 Mon, 13 Dec 2021 14:46:22 -0800 (PST)
Date:   Mon, 13 Dec 2021 14:46:22 -0800
In-Reply-To: <000000000000f5ccbf05cd8db7b0@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000892b3805d30ed738@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in __dev_queue_xmit (5)
From:   syzbot <syzbot+b7be9429f37d15205470@syzkaller.appspotmail.com>
To:     axboe@kernel.dk, justin@coraid.com, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    9b5bcb193a3b Merge branch 'dsa-tagger-storage'
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=17263269b00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d0a94897bd9637ea
dashboard link: https://syzkaller.appspot.com/bug?extid=b7be9429f37d15205470
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10983f4db00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11613eb1b00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b7be9429f37d15205470@syzkaller.appspotmail.com

ieee802154 phy0 wpan0: encryption failed: -22
ieee802154 phy1 wpan1: encryption failed: -22
xfrm0 selects TX queue 0, but real number of TX queues is 0
==================================================================
BUG: KASAN: use-after-free in __dev_queue_xmit+0x3134/0x3640 net/core/dev.c:4073
Read of size 8 at addr ffff88804610b408 by task aoe_tx0/1229

CPU: 1 PID: 1229 Comm: aoe_tx0 Not tainted 5.16.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description.constprop.0.cold+0x8d/0x320 mm/kasan/report.c:247
 __kasan_report mm/kasan/report.c:433 [inline]
 kasan_report.cold+0x83/0xdf mm/kasan/report.c:450
 __dev_queue_xmit+0x3134/0x3640 net/core/dev.c:4073
 tx+0x68/0xb0 drivers/block/aoe/aoenet.c:63
 kthread+0x1e7/0x3b0 drivers/block/aoe/aoecmd.c:1230
 kthread+0x405/0x4f0 kernel/kthread.c:327
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
 </TASK>

Allocated by task 31625:
 kasan_save_stack+0x1e/0x50 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:434 [inline]
 ____kasan_kmalloc mm/kasan/common.c:513 [inline]
 ____kasan_kmalloc mm/kasan/common.c:472 [inline]
 __kasan_kmalloc+0xa9/0xd0 mm/kasan/common.c:522
 kmalloc_node include/linux/slab.h:613 [inline]
 kvmalloc_node+0x61/0x120 mm/util.c:587
 kvmalloc include/linux/slab.h:741 [inline]
 kvzalloc include/linux/slab.h:749 [inline]
 netif_alloc_netdev_queues net/core/dev.c:9511 [inline]
 alloc_netdev_mqs+0x758/0xea0 net/core/dev.c:10208
 rtnl_create_link+0x936/0xb40 net/core/rtnetlink.c:3182
 __rtnl_newlink+0xf73/0x1750 net/core/rtnetlink.c:3447
 rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3505
 rtnetlink_rcv_msg+0x413/0xb80 net/core/rtnetlink.c:5570
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2492
 netlink_unicast_kernel net/netlink/af_netlink.c:1315 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1341
 netlink_sendmsg+0x904/0xdf0 net/netlink/af_netlink.c:1917
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:724
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2409
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2463
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2492
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Freed by task 31625:
 kasan_save_stack+0x1e/0x50 mm/kasan/common.c:38
 kasan_set_track+0x21/0x30 mm/kasan/common.c:46
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:370
 ____kasan_slab_free mm/kasan/common.c:366 [inline]
 ____kasan_slab_free mm/kasan/common.c:328 [inline]
 __kasan_slab_free+0xff/0x130 mm/kasan/common.c:374
 kasan_slab_free include/linux/kasan.h:235 [inline]
 slab_free_hook mm/slub.c:1723 [inline]
 slab_free_freelist_hook+0x8b/0x1c0 mm/slub.c:1749
 slab_free mm/slub.c:3513 [inline]
 kfree+0xf6/0x560 mm/slub.c:4561
 kvfree+0x42/0x50 mm/util.c:620
 netif_free_tx_queues net/core/dev.c:9499 [inline]
 free_netdev+0xa7/0x5a0 net/core/dev.c:10265
 netdev_run_todo+0x882/0xa80 net/core/dev.c:9953
 rtnl_unlock net/core/rtnetlink.c:112 [inline]
 rtnetlink_rcv_msg+0x420/0xb80 net/core/rtnetlink.c:5571
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2492
 netlink_unicast_kernel net/netlink/af_netlink.c:1315 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1341
 netlink_sendmsg+0x904/0xdf0 net/netlink/af_netlink.c:1917
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:724
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2409
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2463
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2492
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

The buggy address belongs to the object at ffff88804610b400
 which belongs to the cache kmalloc-cg-512 of size 512
The buggy address is located 8 bytes inside of
 512-byte region [ffff88804610b400, ffff88804610b600)
The buggy address belongs to the page:
page:ffffea0001184200 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff88804610b800 pfn:0x46108
head:ffffea0001184200 order:2 compound_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 ffffea0001e4dc08 ffffea0001d68508 ffff888010c42dc0
raw: ffff88804610b800 0000000000100009 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 2, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 3713, ts 1382028996406, free_ts 15275532588
 prep_new_page mm/page_alloc.c:2418 [inline]
 get_page_from_freelist+0xa72/0x2f50 mm/page_alloc.c:4149
 __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5369
 alloc_pages+0x1a7/0x300 mm/mempolicy.c:2191
 alloc_slab_page mm/slub.c:1793 [inline]
 allocate_slab mm/slub.c:1930 [inline]
 new_slab+0x32d/0x4a0 mm/slub.c:1993
 ___slab_alloc+0x918/0xfe0 mm/slub.c:3022
 __slab_alloc.constprop.0+0x4d/0xa0 mm/slub.c:3109
 slab_alloc_node mm/slub.c:3200 [inline]
 __kmalloc_node_track_caller+0x2cb/0x360 mm/slub.c:4956
 kmalloc_reserve net/core/skbuff.c:354 [inline]
 __alloc_skb+0xde/0x340 net/core/skbuff.c:426
 alloc_skb include/linux/skbuff.h:1129 [inline]
 alloc_skb_with_frags+0x93/0x620 net/core/skbuff.c:5930
 sock_alloc_send_pskb+0x793/0x920 net/core/sock.c:2581
 unix_dgram_sendmsg+0x414/0x1a10 net/unix/af_unix.c:1895
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:724
 sock_write_iter+0x289/0x3c0 net/socket.c:1057
 call_write_iter include/linux/fs.h:2162 [inline]
 new_sync_write+0x429/0x660 fs/read_write.c:503
 vfs_write+0x7cd/0xae0 fs/read_write.c:590
 ksys_write+0x1ee/0x250 fs/read_write.c:643
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1338 [inline]
 free_pcp_prepare+0x374/0x870 mm/page_alloc.c:1389
 free_unref_page_prepare mm/page_alloc.c:3309 [inline]
 free_unref_page+0x19/0x690 mm/page_alloc.c:3388
 free_contig_range+0xa8/0xf0 mm/page_alloc.c:9271
 destroy_args+0xa8/0x646 mm/debug_vm_pgtable.c:1016
 debug_vm_pgtable+0x2984/0x2a16 mm/debug_vm_pgtable.c:1330
 do_one_initcall+0x103/0x650 init/main.c:1297
 do_initcall_level init/main.c:1370 [inline]
 do_initcalls init/main.c:1386 [inline]
 do_basic_setup init/main.c:1405 [inline]
 kernel_init_freeable+0x6b1/0x73a init/main.c:1610
 kernel_init+0x1a/0x1d0 init/main.c:1499
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

Memory state around the buggy address:
 ffff88804610b300: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88804610b380: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff88804610b400: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                      ^
 ffff88804610b480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88804610b500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================

