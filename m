Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3296164496B
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 17:36:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235590AbiLFQgt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 11:36:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235259AbiLFQgQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 11:36:16 -0500
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95C43EAC
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 08:35:45 -0800 (PST)
Received: by mail-il1-f197.google.com with SMTP id x9-20020a056e021ca900b003037ca1af0cso609365ill.16
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 08:35:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lCkSKYtH7VRiH8sWzLndHoqfj03ZbGfYkcqmDuOBZvE=;
        b=yjnia62xha/ZeZPpTZfcOI7rOkXFunGAuxSPk/H7VFzG/lHhd+0o/3T2ewYDCcFTpP
         ghxG2Zwg1HOwUEeJaYEO2jA4A4r+QqGV49Qpt6vdbLt+PmSnmUlVid6UZpkNsS7FWKob
         +Zs5oeHvbvkwgLx+r68edxl4j0lMzQhK7nklAlO1utg24deBK0uvXdIGlBFwVUNjT6A4
         DhLY/U//UGAYUaUPfUYXqqmrvHvR40J3S138UDP04ys0b20OQjSRUL+lPk7stP19WUhz
         GUX+BuTWVhwtbtaIEkdPlLQd4KIFuN0zDeoRKZQLp5iO7zRNSCKLWDoYfGcEgMWKs93B
         xqkA==
X-Gm-Message-State: ANoB5pkZZGtITqbWgknOJr7Ulam+my4OSOxop0sCwqajZxrK5DScZ4hg
        Qgv0xHkP6JEMx400F5HewQHboCbb50V4gwlBQTdqD86xvtfy
X-Google-Smtp-Source: AA0mqf4pYjzQ7GYU2pnoZNQXbqz7yfq6YSpiFYyXB/MdMnglUkFO+MI8HKpl1a/UxwJrNjrKgZQLjDiVcOQ8S5dH1lsaWLdZIXzV
MIME-Version: 1.0
X-Received: by 2002:a02:c6d9:0:b0:38a:5811:1174 with SMTP id
 r25-20020a02c6d9000000b0038a58111174mr2576917jan.85.1670344544910; Tue, 06
 Dec 2022 08:35:44 -0800 (PST)
Date:   Tue, 06 Dec 2022 08:35:44 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004081f705ef2b6511@google.com>
Subject: [syzbot] KASAN: use-after-free Write in rxrpc_destroy_local
From:   syzbot <syzbot+2a99eae8dc7c754bc16b@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dhowells@redhat.com, edumazet@google.com,
        kuba@kernel.org, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org, marc.dionne@auristor.com,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    c9f8d73645b6 net: mtk_eth_soc: enable flow offload support..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=11415fc3880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c608c21151db14f2
dashboard link: https://syzkaller.appspot.com/bug?extid=2a99eae8dc7c754bc16b
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/bf270f71d81b/disk-c9f8d736.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/9df5873e74c3/vmlinux-c9f8d736.xz
kernel image: https://storage.googleapis.com/syzbot-assets/4db90f01e6d3/bzImage-c9f8d736.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+2a99eae8dc7c754bc16b@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in __hlist_del include/linux/list.h:884 [inline]
BUG: KASAN: use-after-free in hlist_del_init_rcu include/linux/rculist.h:184 [inline]
BUG: KASAN: use-after-free in rxrpc_destroy_local+0x2ad/0x2f0 net/rxrpc/local_object.c:389
Write of size 8 at addr ffff8880b4c0b020 by task krxrpcio/7001/3678

CPU: 1 PID: 3678 Comm: krxrpcio/7001 Not tainted 6.1.0-rc7-syzkaller-01810-gc9f8d73645b6 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xd1/0x138 lib/dump_stack.c:106
 print_address_description mm/kasan/report.c:284 [inline]
 print_report+0x15e/0x45d mm/kasan/report.c:395
 kasan_report+0xbf/0x1f0 mm/kasan/report.c:495
 __hlist_del include/linux/list.h:884 [inline]
 hlist_del_init_rcu include/linux/rculist.h:184 [inline]
 rxrpc_destroy_local+0x2ad/0x2f0 net/rxrpc/local_object.c:389
 rxrpc_io_thread+0xcde/0xfa0 net/rxrpc/io_thread.c:492
 kthread+0x2e8/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
 </TASK>

Allocated by task 31626:
 kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
 kasan_set_track+0x25/0x30 mm/kasan/common.c:52
 ____kasan_kmalloc mm/kasan/common.c:371 [inline]
 ____kasan_kmalloc mm/kasan/common.c:330 [inline]
 __kasan_kmalloc+0xa5/0xb0 mm/kasan/common.c:380
 kasan_kmalloc include/linux/kasan.h:211 [inline]
 __do_kmalloc_node mm/slab_common.c:955 [inline]
 __kmalloc_node_track_caller+0x5b/0xc0 mm/slab_common.c:975
 kmalloc_reserve net/core/skbuff.c:438 [inline]
 __alloc_skb+0xe9/0x310 net/core/skbuff.c:511
 alloc_skb include/linux/skbuff.h:1269 [inline]
 nlmsg_new include/net/netlink.h:1002 [inline]
 inet6_rt_notify+0xf0/0x2b0 net/ipv6/route.c:6172
 fib6_del_route net/ipv6/ip6_fib.c:1993 [inline]
 fib6_del+0xf4d/0x15d0 net/ipv6/ip6_fib.c:2028
 fib6_clean_node+0x397/0x5c0 net/ipv6/ip6_fib.c:2190
 fib6_walk_continue+0x395/0x6e0 net/ipv6/ip6_fib.c:2112
 fib6_walk+0x182/0x370 net/ipv6/ip6_fib.c:2160
 fib6_clean_tree+0xdb/0x120 net/ipv6/ip6_fib.c:2240
 __fib6_clean_all+0x107/0x2a0 net/ipv6/ip6_fib.c:2256
 rt6_sync_down_dev net/ipv6/route.c:4894 [inline]
 rt6_disable_ip+0x807/0xa00 net/ipv6/route.c:4899
 addrconf_ifdown.isra.0+0x11a/0x1920 net/ipv6/addrconf.c:3750
 addrconf_notify+0x104/0x1c80 net/ipv6/addrconf.c:3673
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:87
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1944
 call_netdevice_notifiers_extack net/core/dev.c:1982 [inline]
 call_netdevice_notifiers net/core/dev.c:1996 [inline]
 dev_close_many+0x309/0x630 net/core/dev.c:1530
 unregister_netdevice_many_notify+0x416/0x19e0 net/core/dev.c:10813
 unregister_netdevice_many net/core/dev.c:10895 [inline]
 default_device_exit_batch+0x451/0x590 net/core/dev.c:11348
 ops_exit_list+0x125/0x170 net/core/net_namespace.c:174
 cleanup_net+0x4ee/0xb10 net/core/net_namespace.c:606
 process_one_work+0x9bf/0x1710 kernel/workqueue.c:2289
 worker_thread+0x669/0x1090 kernel/workqueue.c:2436
 kthread+0x2e8/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306

Last potentially related work creation:
 kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
 __kasan_record_aux_stack+0xbc/0xd0 mm/kasan/generic.c:481
 kvfree_call_rcu+0x78/0x8f0 kernel/rcu/tree.c:3343
 neigh_destroy+0x435/0x640 net/core/neighbour.c:931
 neigh_release include/net/neighbour.h:449 [inline]
 neigh_cleanup_and_release+0x271/0x3d0 net/core/neighbour.c:103
 neigh_flush_dev+0x4e7/0x820 net/core/neighbour.c:411
 __neigh_ifdown.isra.0+0x54/0x400 net/core/neighbour.c:428
 neigh_ifdown+0x1f/0x30 net/core/neighbour.c:446
 rt6_disable_ip+0x795/0xa00 net/ipv6/route.c:4901
 addrconf_ifdown.isra.0+0x11a/0x1920 net/ipv6/addrconf.c:3750
 addrconf_notify+0x104/0x1c80 net/ipv6/addrconf.c:3673
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:87
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1944
 call_netdevice_notifiers_extack net/core/dev.c:1982 [inline]
 call_netdevice_notifiers net/core/dev.c:1996 [inline]
 __dev_notify_flags+0x1ea/0x2d0 net/core/dev.c:8571
 dev_change_flags+0x11b/0x170 net/core/dev.c:8607
 do_setlink+0x9f1/0x3bb0 net/core/rtnetlink.c:2827
 rtnl_group_changelink net/core/rtnetlink.c:3344 [inline]
 __rtnl_newlink+0xb90/0x1840 net/core/rtnetlink.c:3600
 rtnl_newlink+0x68/0xa0 net/core/rtnetlink.c:3637
 rtnetlink_rcv_msg+0x43e/0xca0 net/core/rtnetlink.c:6141
 netlink_rcv_skb+0x165/0x440 net/netlink/af_netlink.c:2564
 netlink_unicast_kernel net/netlink/af_netlink.c:1330 [inline]
 netlink_unicast+0x547/0x7f0 net/netlink/af_netlink.c:1356
 netlink_sendmsg+0x91b/0xe10 net/netlink/af_netlink.c:1932
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg+0xd3/0x120 net/socket.c:734
 ____sys_sendmsg+0x712/0x8c0 net/socket.c:2476
 ___sys_sendmsg+0x110/0x1b0 net/socket.c:2530
 __sys_sendmsg+0xf7/0x1c0 net/socket.c:2559
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Second to last potentially related work creation:
 kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
 __kasan_record_aux_stack+0xbc/0xd0 mm/kasan/generic.c:481
 kvfree_call_rcu+0x78/0x8f0 kernel/rcu/tree.c:3343
 neigh_destroy+0x435/0x640 net/core/neighbour.c:931
 neigh_release include/net/neighbour.h:449 [inline]
 neigh_cleanup_and_release+0x271/0x3d0 net/core/neighbour.c:103
 neigh_del net/core/neighbour.c:225 [inline]
 neigh_remove_one+0x381/0x460 net/core/neighbour.c:246
 neigh_forced_gc net/core/neighbour.c:276 [inline]
 neigh_alloc net/core/neighbour.c:466 [inline]
 ___neigh_create+0x191f/0x2a20 net/core/neighbour.c:661
 ip6_finish_output2+0xfc4/0x1530 net/ipv6/ip6_output.c:125
 __ip6_finish_output net/ipv6/ip6_output.c:195 [inline]
 ip6_finish_output+0x694/0x1170 net/ipv6/ip6_output.c:206
 NF_HOOK_COND include/linux/netfilter.h:291 [inline]
 ip6_output+0x1f1/0x540 net/ipv6/ip6_output.c:227
 dst_output include/net/dst.h:444 [inline]
 NF_HOOK include/linux/netfilter.h:302 [inline]
 ndisc_send_skb+0xa63/0x1740 net/ipv6/ndisc.c:508
 ndisc_send_rs+0x132/0x6f0 net/ipv6/ndisc.c:718
 addrconf_rs_timer+0x3f1/0x810 net/ipv6/addrconf.c:3931
 call_timer_fn+0x1da/0x7c0 kernel/time/timer.c:1474
 expire_timers kernel/time/timer.c:1519 [inline]
 __run_timers.part.0+0x6a2/0xaf0 kernel/time/timer.c:1790
 __run_timers kernel/time/timer.c:1768 [inline]
 run_timer_softirq+0xb7/0x1d0 kernel/time/timer.c:1803
 __do_softirq+0x1fb/0xadc kernel/softirq.c:571

The buggy address belongs to the object at ffff8880b4c0b000
 which belongs to the cache kmalloc-1k of size 1024
The buggy address is located 32 bytes inside of
 1024-byte region [ffff8880b4c0b000, ffff8880b4c0b400)

The buggy address belongs to the physical page:
page:ffffea0002d30200 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff8880b4c0b000 pfn:0xb4c08
head:ffffea0002d30200 order:3 compound_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 ffffea0000ef5808 ffffea0001f92c08 ffff888012041dc0
raw: ffff8880b4c0b000 0000000000100009 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0x152a20(GFP_ATOMIC|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_HARDWALL), pid 24904, tgid 24904 (kworker/u4:8), ts 1421351587259, free_ts 1421332121505
 prep_new_page mm/page_alloc.c:2539 [inline]
 get_page_from_freelist+0x10b5/0x2d50 mm/page_alloc.c:4291
 __alloc_pages+0x1cb/0x5b0 mm/page_alloc.c:5558
 alloc_pages+0x1aa/0x270 mm/mempolicy.c:2285
 alloc_slab_page mm/slub.c:1794 [inline]
 allocate_slab+0x213/0x300 mm/slub.c:1939
 new_slab mm/slub.c:1992 [inline]
 ___slab_alloc+0xa91/0x1400 mm/slub.c:3180
 __slab_alloc.constprop.0+0x56/0xa0 mm/slub.c:3279
 slab_alloc_node mm/slub.c:3364 [inline]
 __kmem_cache_alloc_node+0x199/0x3e0 mm/slub.c:3437
 __do_kmalloc_node mm/slab_common.c:954 [inline]
 __kmalloc+0x4a/0xd0 mm/slab_common.c:968
 kmalloc include/linux/slab.h:558 [inline]
 kzalloc include/linux/slab.h:689 [inline]
 ieee802_11_parse_elems_full+0x106/0x1330 net/mac80211/util.c:1655
 ieee802_11_parse_elems_crc.constprop.0+0x99/0xd0 net/mac80211/ieee80211_i.h:2260
 ieee802_11_parse_elems net/mac80211/ieee80211_i.h:2267 [inline]
 ieee80211_bss_info_update+0x410/0xaf0 net/mac80211/scan.c:212
 ieee80211_rx_bss_info net/mac80211/ibss.c:1120 [inline]
 ieee80211_rx_mgmt_probe_beacon net/mac80211/ibss.c:1609 [inline]
 ieee80211_ibss_rx_queued_mgmt+0x19fc/0x3160 net/mac80211/ibss.c:1638
 ieee80211_iface_process_skb net/mac80211/iface.c:1581 [inline]
 ieee80211_iface_work+0xa4d/0xd70 net/mac80211/iface.c:1635
 process_one_work+0x9bf/0x1710 kernel/workqueue.c:2289
 worker_thread+0x669/0x1090 kernel/workqueue.c:2436
 kthread+0x2e8/0x3a0 kernel/kthread.c:376
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1459 [inline]
 free_pcp_prepare+0x65c/0xd90 mm/page_alloc.c:1509
 free_unref_page_prepare mm/page_alloc.c:3387 [inline]
 free_unref_page+0x1d/0x4d0 mm/page_alloc.c:3483
 __unfreeze_partials+0x17c/0x1a0 mm/slub.c:2586
 qlink_free mm/kasan/quarantine.c:168 [inline]
 qlist_free_all+0x6a/0x170 mm/kasan/quarantine.c:187
 kasan_quarantine_reduce+0x184/0x210 mm/kasan/quarantine.c:294
 __kasan_slab_alloc+0x66/0x90 mm/kasan/common.c:302
 kasan_slab_alloc include/linux/kasan.h:201 [inline]
 slab_post_alloc_hook mm/slab.h:737 [inline]
 slab_alloc_node mm/slub.c:3398 [inline]
 slab_alloc mm/slub.c:3406 [inline]
 __kmem_cache_alloc_lru mm/slub.c:3413 [inline]
 kmem_cache_alloc+0x2b4/0x3d0 mm/slub.c:3422
 ptlock_alloc mm/memory.c:5842 [inline]
 ptlock_init include/linux/mm.h:2336 [inline]
 pmd_ptlock_init include/linux/mm.h:2422 [inline]
 pgtable_pmd_page_ctor include/linux/mm.h:2458 [inline]
 pmd_alloc_one include/asm-generic/pgalloc.h:129 [inline]
 __pmd_alloc+0xc3/0x5d0 mm/memory.c:5294
 pmd_alloc include/linux/mm.h:2286 [inline]
 __handle_mm_fault+0x8c8/0x3a40 mm/memory.c:5057
 handle_mm_fault+0x1cc/0x780 mm/memory.c:5218
 do_user_addr_fault+0x475/0x1210 arch/x86/mm/fault.c:1428
 handle_page_fault arch/x86/mm/fault.c:1519 [inline]
 exc_page_fault+0x98/0x170 arch/x86/mm/fault.c:1575
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:570

Memory state around the buggy address:
 ffff8880b4c0af00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff8880b4c0af80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff8880b4c0b000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                               ^
 ffff8880b4c0b080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8880b4c0b100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
