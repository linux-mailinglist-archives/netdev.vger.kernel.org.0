Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1A0D37B96A
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 11:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbhELJlf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 05:41:35 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:56973 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230104AbhELJl3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 05:41:29 -0400
Received: by mail-io1-f71.google.com with SMTP id d6-20020a5d9bc60000b0290438ecc3ee01so9203085ion.23
        for <netdev@vger.kernel.org>; Wed, 12 May 2021 02:40:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=/1q+jr3iwbZQMoQfu/rwxrLc0Iqm+hrDD6OBwHxiMgQ=;
        b=FPpzgfzVjvgG13K6Ibd3bxXxklXF3XustfwR1OQVmIumTiacE1K49OE9DxNAyMY/HM
         fZGmDY6CWDAodfNMY4aHJgpL57N2KY0njtc5FZXQvRWBH7iy7xoNuMtfAp8P6NxW3bXO
         apmxHhs3k46UQygH8azW2POfdzrA4j+Cjsko4Ikk88kaOgSxM94emT06qGX+K9tcBgs5
         eDo6ITcrG5B3NPUyQQoaJ1kXK9IPPlSxzXr4Pi9xu/KQ5UZdy5jw7ErLQ/3jCmHiysRg
         y7JTBt/H/k/kjIc+/YmHmVPugEKA7bbzYE1qMCxnYtl6xI5Qyj9N2EKOJH/P9DFXFD3X
         w3ew==
X-Gm-Message-State: AOAM5305ZDMeOpwgWJ1+7yJtSvirP36Ks3bJpBa232DZYRTkdAnlXl5T
        PM7f/5ge7tdi9FD7xOqn5XiJcwWjLp7KDCWHlMpKta8MeIgU
X-Google-Smtp-Source: ABdhPJxKwFXjjfgpIkLY6FmsUEdNZXXdfvK2/SA6v+/gWGXTM5LbUu6QjbGZ6sTxtimImZqm/1wx/fmCxDM8ZC+XWLBGqdDCAob9
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:20c5:: with SMTP id 5mr30445805ilq.14.1620812421489;
 Wed, 12 May 2021 02:40:21 -0700 (PDT)
Date:   Wed, 12 May 2021 02:40:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a16c4f05c21ecc1c@google.com>
Subject: [syzbot] KASAN: use-after-free Read in bcm_rx_handler
From:   syzbot <syzbot+0f7e7e5e2f4f40fa89c0@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org, mkl@pengutronix.de,
        netdev@vger.kernel.org, socketcan@hartkopp.net,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    009fc857 mISDN: fix possible use-after-free in HFC_cleanup()
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=11ce90add00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b072be26137971e1
dashboard link: https://syzkaller.appspot.com/bug?extid=0f7e7e5e2f4f40fa89c0
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17c9f9b3d00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+0f7e7e5e2f4f40fa89c0@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in bcm_rx_starttimer net/can/bcm.c:543 [inline]
BUG: KASAN: use-after-free in bcm_rx_handler+0x5ff/0x6d0 net/can/bcm.c:694
Read of size 4 at addr ffff88802af28418 by task syz-executor.1/10095

CPU: 1 PID: 10095 Comm: syz-executor.1 Not tainted 5.12.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x141/0x1d7 lib/dump_stack.c:120
 print_address_description.constprop.0.cold+0x5b/0x2f8 mm/kasan/report.c:233
 __kasan_report mm/kasan/report.c:419 [inline]
 kasan_report.cold+0x7c/0xd8 mm/kasan/report.c:436
 bcm_rx_starttimer net/can/bcm.c:543 [inline]
 bcm_rx_handler+0x5ff/0x6d0 net/can/bcm.c:694
 deliver net/can/af_can.c:574 [inline]
 can_rcv_filter+0x445/0x8d0 net/can/af_can.c:635
 can_receive+0x290/0x580 net/can/af_can.c:661
 can_rcv+0x120/0x1c0 net/can/af_can.c:696
 __netif_receive_skb_one_core+0x114/0x180 net/core/dev.c:5440
 __netif_receive_skb+0x27/0x1c0 net/core/dev.c:5554
 process_backlog+0x232/0x6c0 net/core/dev.c:6418
 __napi_poll+0xaf/0x440 net/core/dev.c:6966
 napi_poll net/core/dev.c:7033 [inline]
 net_rx_action+0x801/0xb40 net/core/dev.c:7120
 __do_softirq+0x29b/0x9f6 kernel/softirq.c:559
 do_softirq.part.0+0xd9/0x130 kernel/softirq.c:460
 </IRQ>
 netif_rx_ni+0x33d/0x590 net/core/dev.c:4966
 can_send+0x4ec/0x9a0 net/can/af_can.c:287
 isotp_sendmsg+0x8c2/0x13d0 net/can/isotp.c:946
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:674
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2350
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2404
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2433
 do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4665f9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ff4a7a7d188 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 000000000056bf60 RCX: 00000000004665f9
RDX: 0000000000000004 RSI: 00000000200003c0 RDI: 0000000000000004
RBP: 00000000004bfce1 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf60
R13: 00007ffe23e0924f R14: 00007ff4a7a7d300 R15: 0000000000022000

Allocated by task 10111:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:428 [inline]
 ____kasan_kmalloc mm/kasan/common.c:507 [inline]
 ____kasan_kmalloc mm/kasan/common.c:466 [inline]
 __kasan_kmalloc+0x9b/0xd0 mm/kasan/common.c:516
 kmalloc include/linux/slab.h:556 [inline]
 kzalloc include/linux/slab.h:686 [inline]
 bcm_rx_setup net/can/bcm.c:1070 [inline]
 bcm_sendmsg+0x2a81/0x4420 net/can/bcm.c:1331
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:674
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2350
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2404
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2433
 do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Freed by task 10093:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track+0x1c/0x30 mm/kasan/common.c:46
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:357
 ____kasan_slab_free mm/kasan/common.c:360 [inline]
 ____kasan_slab_free mm/kasan/common.c:325 [inline]
 __kasan_slab_free+0xfb/0x130 mm/kasan/common.c:368
 kasan_slab_free include/linux/kasan.h:212 [inline]
 slab_free_hook mm/slub.c:1581 [inline]
 slab_free_freelist_hook+0xdf/0x240 mm/slub.c:1606
 slab_free mm/slub.c:3166 [inline]
 kfree+0xe5/0x7f0 mm/slub.c:4225
 bcm_release+0x34a/0x780 net/can/bcm.c:1506
 __sock_release+0xcd/0x280 net/socket.c:599
 sock_close+0x18/0x20 net/socket.c:1258
 __fput+0x288/0x920 fs/file_table.c:280
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164
 tracehook_notify_resume include/linux/tracehook.h:189 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:174 [inline]
 exit_to_user_mode_prepare+0x272/0x280 kernel/entry/common.c:208
 __syscall_exit_to_user_mode_work kernel/entry/common.c:290 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:301
 do_syscall_64+0x47/0xb0 arch/x86/entry/common.c:57
 entry_SYSCALL_64_after_hwframe+0x44/0xae

The buggy address belongs to the object at ffff88802af28400
 which belongs to the cache kmalloc-512 of size 512
The buggy address is located 24 bytes inside of
 512-byte region [ffff88802af28400, ffff88802af28600)
The buggy address belongs to the page:
page:ffffea0000abca00 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x2af28
head:ffffea0000abca00 order:2 compound_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 dead000000000100 dead000000000122 ffff888011041c80
raw: 0000000000000000 0000000000100010 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 2, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 8455, ts 309324953429, free_ts 309319650475
 prep_new_page mm/page_alloc.c:2358 [inline]
 get_page_from_freelist+0x1033/0x2b60 mm/page_alloc.c:3994
 __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5200
 alloc_pages+0x18c/0x2a0 mm/mempolicy.c:2272
 alloc_slab_page mm/slub.c:1644 [inline]
 allocate_slab+0x2c5/0x4c0 mm/slub.c:1784
 new_slab mm/slub.c:1847 [inline]
 new_slab_objects mm/slub.c:2593 [inline]
 ___slab_alloc+0x44c/0x7a0 mm/slub.c:2756
 __slab_alloc.constprop.0+0xa7/0xf0 mm/slub.c:2796
 slab_alloc_node mm/slub.c:2878 [inline]
 __kmalloc_node_track_caller+0x2e6/0x350 mm/slub.c:4604
 kmalloc_reserve net/core/skbuff.c:354 [inline]
 __alloc_skb+0xde/0x340 net/core/skbuff.c:425
 alloc_skb include/linux/skbuff.h:1107 [inline]
 nlmsg_new include/net/netlink.h:953 [inline]
 netlink_ack+0x1ed/0xaa0 net/netlink/af_netlink.c:2437
 netlink_rcv_skb+0x33d/0x420 net/netlink/af_netlink.c:2508
 netlink_unicast_kernel net/netlink/af_netlink.c:1312 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1338
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1927
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:674
 __sys_sendto+0x21c/0x320 net/socket.c:1977
 __do_sys_sendto net/socket.c:1989 [inline]
 __se_sys_sendto net/socket.c:1985 [inline]
 __x64_sys_sendto+0xdd/0x1b0 net/socket.c:1985
 do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1298 [inline]
 __free_pages_ok+0x476/0xce0 mm/page_alloc.c:1572
 stack_depot_save+0x162/0x4e0 lib/stackdepot.c:336
 kasan_save_stack+0x32/0x40 mm/kasan/common.c:40
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:428 [inline]
 __kasan_slab_alloc+0x84/0xa0 mm/kasan/common.c:461
 kasan_slab_alloc include/linux/kasan.h:236 [inline]
 slab_post_alloc_hook mm/slab.h:524 [inline]
 slab_alloc_node mm/slub.c:2912 [inline]
 slab_alloc mm/slub.c:2920 [inline]
 kmem_cache_alloc+0x152/0x3a0 mm/slub.c:2925
 alloc_inode+0x161/0x230 fs/inode.c:235
 new_inode_pseudo fs/inode.c:934 [inline]
 new_inode+0x27/0x2f0 fs/inode.c:963
 debugfs_get_inode+0x1a/0x130 fs/debugfs/inode.c:69
 __debugfs_create_file+0x11a/0x4e0 fs/debugfs/inode.c:404
 debugfs_create_mode_unsafe fs/debugfs/file.c:407 [inline]
 debugfs_create_bool+0x6c/0xa0 fs/debugfs/file.c:862
 nsim_dev_debugfs_init drivers/net/netdevsim/dev.c:231 [inline]
 nsim_dev_probe+0xa9d/0x1080 drivers/net/netdevsim/dev.c:1109
 really_probe+0x291/0xf60 drivers/base/dd.c:576
 driver_probe_device+0x298/0x410 drivers/base/dd.c:763
 __device_attach_driver+0x203/0x2c0 drivers/base/dd.c:870
 bus_for_each_drv+0x15f/0x1e0 drivers/base/bus.c:431
 __device_attach+0x228/0x4b0 drivers/base/dd.c:938

Memory state around the buggy address:
 ffff88802af28300: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88802af28380: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff88802af28400: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                            ^
 ffff88802af28480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88802af28500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
