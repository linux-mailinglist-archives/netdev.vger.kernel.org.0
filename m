Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B2BA3DB671
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 11:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238375AbhG3Jw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 05:52:26 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:36501 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229989AbhG3Jw0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 05:52:26 -0400
Received: by mail-io1-f70.google.com with SMTP id k20-20020a6b6f140000b029053817be16cdso5622854ioc.3
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 02:52:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=w7+OC66+wjiFWiulPYfa5oRt5nJ1vIGFY5nQxWNOTMg=;
        b=puy8ZgM6g2zvDdz2A5vqqTov+tde1fSFjUdzS549TRQVGDG1940fERKvkDWApR9x8B
         4Pnkq17cgv2ApTnmqxmRwngwk5WrlFG8e7IBpnOs/lzr3B4u4DGs/NpaWXa0FW5zN6Vi
         mz22KZuyTotar8p5RzV0GA/RAyc/g6ixHUgO7xKAKtkI9vhQXytqeZcO6ynrdZX21snT
         xjyqyz6fAy//VahW0MfeXX3SaeMtk3nmYvRVma49MDJXpALWlxIEfrwfFKgRRaW3K9D8
         c1pcxZ/j6EynLhM89Eeyd7+jtFNH6t2oi6PkVJYJDqXPwzjm8u1J3/PeKtNcvSYtIZuj
         TggA==
X-Gm-Message-State: AOAM5306oXjKf5+KNdBCrfPoNfo3wJLnWR7kYbaxVQ9Kg4Ja+r5wtyAs
        w5onwAsmD9RZQkrGNC7vpqYyatEu1ZfMHI1D6l+/mRoGn38d
X-Google-Smtp-Source: ABdhPJywDGx1i2AdbNCHuhLR3gFGwe0/OOuR2PDBCZRzOeUJdPU7fli00ki3xjSVga7CiX4q+dGrOWz20KKAWfz5PPRY3NO5zcjo
MIME-Version: 1.0
X-Received: by 2002:a92:1942:: with SMTP id e2mr202339ilm.4.1627638740706;
 Fri, 30 Jul 2021 02:52:20 -0700 (PDT)
Date:   Fri, 30 Jul 2021 02:52:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f66d1605c8542ca8@google.com>
Subject: [syzbot] KASAN: use-after-free Read in ieee80211_scan_rx (2)
From:   syzbot <syzbot+6cb476b7c69916a0caca@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    ff1176468d36 Linux 5.14-rc3
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15bb59b2300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1dee114394f7d2c2
dashboard link: https://syzkaller.appspot.com/bug?extid=6cb476b7c69916a0caca
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+6cb476b7c69916a0caca@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in ieee80211_scan_rx+0x7d0/0x7e0 net/mac80211/scan.c:289
Read of size 4 at addr ffff88801559922c by task syz-executor.0/14290

CPU: 0 PID: 14290 Comm: syz-executor.0 Not tainted 5.14.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:105
 print_address_description.constprop.0.cold+0x6c/0x2d6 mm/kasan/report.c:233
 __kasan_report mm/kasan/report.c:419 [inline]
 kasan_report.cold+0x83/0xdf mm/kasan/report.c:436
 ieee80211_scan_rx+0x7d0/0x7e0 net/mac80211/scan.c:289
 __ieee80211_rx_handle_packet net/mac80211/rx.c:4707 [inline]
 ieee80211_rx_list+0x20e8/0x27b0 net/mac80211/rx.c:4899
 ieee80211_rx_napi+0xdb/0x3d0 net/mac80211/rx.c:4922
 ieee80211_rx include/net/mac80211.h:4552 [inline]
 ieee80211_tasklet_handler+0xd4/0x130 net/mac80211/main.c:235
 tasklet_action_common.constprop.0+0x201/0x2e0 kernel/softirq.c:783
 __do_softirq+0x29b/0x9c2 kernel/softirq.c:558
 do_softirq.part.0+0xde/0x130 kernel/softirq.c:459
 </IRQ>
 do_softirq kernel/softirq.c:451 [inline]
 __local_bh_enable_ip+0x102/0x120 kernel/softirq.c:383
 local_bh_enable include/linux/bottom_half.h:32 [inline]
 rcu_read_unlock_bh include/linux/rcupdate.h:757 [inline]
 __dev_queue_xmit+0x1b04/0x3620 net/core/dev.c:4312
 __netlink_deliver_tap_skb net/netlink/af_netlink.c:303 [inline]
 __netlink_deliver_tap net/netlink/af_netlink.c:321 [inline]
 netlink_deliver_tap+0x9b5/0xbc0 net/netlink/af_netlink.c:334
 __netlink_sendskb net/netlink/af_netlink.c:1258 [inline]
 netlink_sendskb net/netlink/af_netlink.c:1267 [inline]
 netlink_unicast+0x697/0x7d0 net/netlink/af_netlink.c:1355
 nlmsg_unicast include/net/netlink.h:1050 [inline]
 netlink_ack+0x5ec/0xa60 net/netlink/af_netlink.c:2474
 netlink_rcv_skb+0x33d/0x420 net/netlink/af_netlink.c:2510
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:811
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
 sock_sendmsg_nosec net/socket.c:703 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:723
 __sys_sendto+0x21c/0x320 net/socket.c:2019
 __do_sys_sendto net/socket.c:2031 [inline]
 __se_sys_sendto net/socket.c:2027 [inline]
 __x64_sys_sendto+0xdd/0x1b0 net/socket.c:2027
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x41957c
Code: fa fa ff ff 44 8b 4c 24 2c 4c 8b 44 24 20 89 c5 44 8b 54 24 28 48 8b 54 24 18 b8 2c 00 00 00 48 8b 74 24 10 8b 7c 24 08 0f 05 <48> 3d 00 f0 ff ff 77 34 89 ef 48 89 44 24 08 e8 20 fb ff ff 48 8b
RSP: 002b:00007f82fca71030 EFLAGS: 00000293 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 00007f82fca710f0 RCX: 000000000041957c
RDX: 0000000000000064 RSI: 00007f82fca71140 RDI: 0000000000000005
RBP: 0000000000000000 R08: 00007f82fca71084 R09: 000000000000000c
R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000000000
R13: 00007f82fca71140 R14: 0000000000000005 R15: 0000000000000000

Allocated by task 14295:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:434 [inline]
 ____kasan_kmalloc mm/kasan/common.c:513 [inline]
 ____kasan_kmalloc mm/kasan/common.c:472 [inline]
 __kasan_kmalloc+0x98/0xc0 mm/kasan/common.c:522
 kasan_kmalloc include/linux/kasan.h:264 [inline]
 __do_kmalloc mm/slab.c:3702 [inline]
 __kmalloc+0x214/0x4d0 mm/slab.c:3711
 kmalloc include/linux/slab.h:596 [inline]
 kzalloc include/linux/slab.h:721 [inline]
 cfg80211_conn_scan+0x195/0xfd0 net/wireless/sme.c:80
 cfg80211_sme_connect net/wireless/sme.c:585 [inline]
 cfg80211_connect+0x15d0/0x2010 net/wireless/sme.c:1257
 nl80211_connect+0x1647/0x22a0 net/wireless/nl80211.c:10923
 genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:739
 genl_family_rcv_msg net/netlink/genetlink.c:783 [inline]
 genl_rcv_msg+0x328/0x580 net/netlink/genetlink.c:800
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:811
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

Freed by task 15038:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track+0x1c/0x30 mm/kasan/common.c:46
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:360
 ____kasan_slab_free mm/kasan/common.c:366 [inline]
 ____kasan_slab_free mm/kasan/common.c:328 [inline]
 __kasan_slab_free+0xcd/0x100 mm/kasan/common.c:374
 kasan_slab_free include/linux/kasan.h:230 [inline]
 __cache_free mm/slab.c:3445 [inline]
 kfree+0x106/0x2c0 mm/slab.c:3803
 ___cfg80211_scan_done+0x474/0x960 net/wireless/scan.c:984
 __cfg80211_scan_done+0x2c/0x40 net/wireless/scan.c:1001
 process_one_work+0x98d/0x1630 kernel/workqueue.c:2276
 worker_thread+0x658/0x11f0 kernel/workqueue.c:2422
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

Last potentially related work creation:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_record_aux_stack+0xa4/0xd0 mm/kasan/generic.c:348
 __call_rcu kernel/rcu/tree.c:3029 [inline]
 call_rcu+0xb1/0x750 kernel/rcu/tree.c:3109
 fib6_info_release include/net/ip6_fib.h:337 [inline]
 fib6_info_release include/net/ip6_fib.h:334 [inline]
 ip6_route_add+0x12d/0x150 net/ipv6/route.c:3861
 addrconf_prefix_route+0x30a/0x4e0 net/ipv6/addrconf.c:2415
 sit_add_v4_addrs net/ipv6/addrconf.c:3137 [inline]
 addrconf_sit_config net/ipv6/addrconf.c:3387 [inline]
 addrconf_notify+0x1a96/0x2400 net/ipv6/addrconf.c:3580
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2123
 call_netdevice_notifiers_extack net/core/dev.c:2135 [inline]
 call_netdevice_notifiers net/core/dev.c:2149 [inline]
 __dev_notify_flags+0x110/0x2b0 net/core/dev.c:8860
 rtnl_configure_link+0x16b/0x240 net/core/rtnetlink.c:3143
 __rtnl_newlink+0x109f/0x1760 net/core/rtnetlink.c:3468
 rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3508
 rtnetlink_rcv_msg+0x413/0xb80 net/core/rtnetlink.c:5574
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
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

The buggy address belongs to the object at ffff888015599200
 which belongs to the cache kmalloc-256 of size 256
The buggy address is located 44 bytes inside of
 256-byte region [ffff888015599200, ffff888015599300)
The buggy address belongs to the page:
page:ffffea0000556640 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x15599
flags: 0xfff00000000200(slab|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000000200 ffffea0001e52008 ffffea0002046008 ffff888010840500
raw: 0000000000000000 ffff888015599000 0000000100000008 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x2420c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_COMP|__GFP_THISNODE), pid 13813, ts 1677185189740, free_ts 1675053513618
 prep_new_page mm/page_alloc.c:2436 [inline]
 get_page_from_freelist+0xa72/0x2f80 mm/page_alloc.c:4169
 __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5391
 __alloc_pages_node include/linux/gfp.h:570 [inline]
 kmem_getpages mm/slab.c:1377 [inline]
 cache_grow_begin+0x75/0x460 mm/slab.c:2593
 cache_alloc_refill+0x27f/0x380 mm/slab.c:2965
 ____cache_alloc mm/slab.c:3048 [inline]
 ____cache_alloc mm/slab.c:3031 [inline]
 __do_cache_alloc mm/slab.c:3275 [inline]
 slab_alloc mm/slab.c:3316 [inline]
 kmem_cache_alloc_trace+0x38c/0x480 mm/slab.c:3573
 kmalloc include/linux/slab.h:591 [inline]
 kzalloc include/linux/slab.h:721 [inline]
 fib6_info_alloc+0xc1/0x210 net/ipv6/ip6_fib.c:155
 ip6_route_info_create+0x33e/0x1aa0 net/ipv6/route.c:3762
 ip6_route_add+0x24/0x150 net/ipv6/route.c:3856
 addrconf_prefix_route+0x30a/0x4e0 net/ipv6/addrconf.c:2415
 sit_add_v4_addrs net/ipv6/addrconf.c:3137 [inline]
 addrconf_sit_config net/ipv6/addrconf.c:3387 [inline]
 addrconf_notify+0x1a96/0x2400 net/ipv6/addrconf.c:3580
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2123
 call_netdevice_notifiers_extack net/core/dev.c:2135 [inline]
 call_netdevice_notifiers net/core/dev.c:2149 [inline]
 __dev_notify_flags+0x110/0x2b0 net/core/dev.c:8860
 rtnl_configure_link+0x16b/0x240 net/core/rtnetlink.c:3143
 __rtnl_newlink+0x109f/0x1760 net/core/rtnetlink.c:3468
 rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3508
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1346 [inline]
 free_pcp_prepare+0x2c5/0x780 mm/page_alloc.c:1397
 free_unref_page_prepare mm/page_alloc.c:3332 [inline]
 free_unref_page_list+0x1a1/0x1050 mm/page_alloc.c:3448
 release_pages+0x824/0x20b0 mm/swap.c:972
 tlb_batch_pages_flush mm/mmu_gather.c:49 [inline]
 tlb_flush_mmu_free mm/mmu_gather.c:242 [inline]
 tlb_flush_mmu mm/mmu_gather.c:249 [inline]
 tlb_finish_mmu+0x165/0x8c0 mm/mmu_gather.c:340
 exit_mmap+0x1ea/0x620 mm/mmap.c:3203
 __mmput+0x122/0x470 kernel/fork.c:1101
 mmput+0x58/0x60 kernel/fork.c:1122
 exit_mm kernel/exit.c:501 [inline]
 do_exit+0xae2/0x2a60 kernel/exit.c:812
 do_group_exit+0x125/0x310 kernel/exit.c:922
 get_signal+0x47f/0x2160 kernel/signal.c:2808
 arch_do_signal_or_restart+0x2a9/0x1c40 arch/x86/kernel/signal.c:865
 handle_signal_work kernel/entry/common.c:148 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
 exit_to_user_mode_prepare+0x17d/0x290 kernel/entry/common.c:209
 __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:302
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Memory state around the buggy address:
 ffff888015599100: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888015599180: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff888015599200: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                  ^
 ffff888015599280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888015599300: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
