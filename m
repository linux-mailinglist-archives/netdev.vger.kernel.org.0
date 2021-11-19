Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEC6A456C4F
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 10:27:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234355AbhKSJaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 04:30:22 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:33635 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231560AbhKSJaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 04:30:22 -0500
Received: by mail-il1-f198.google.com with SMTP id c17-20020a92b751000000b0027392cd873aso6118690ilm.0
        for <netdev@vger.kernel.org>; Fri, 19 Nov 2021 01:27:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=8eIrv/BfIzlck5WxpTrBcsxiDswsSksx4sttyrXhACU=;
        b=YlB75U74tj/Oal+4v7Bvr/RY6ePpJyIpW705F4lXaD0CzknSv+O04RqC4W8cp7wCmy
         EnEsFHZ01gatlGe6g+cTReIxrVtXN+hPO0+tW0vD0r8kKDV0sZkfuSViHctqCXd8jeaD
         Do+bN13NLuW+KOwpT/AFji1DMkg60TxboaCon4Hcq/mc9F+ZHlZ5jO/Wc5KgQiks1Nty
         F13KwVpxR0HkDNmM6pG7sH68Q6BCwun9Y4wwAs5M0doK/vpF97P/2PWn5Yqgr/kzM9C3
         QW1fFtwgRlSHj/YVFctWvd5n7L8nPVJEJYJU3ydqkdGQ3k1Riw4C/3xqhpXx/DiRFwN9
         K0DA==
X-Gm-Message-State: AOAM53140mkL5sH5lXfGNR3rK/tfWnUVa8nyTqNJgEs4hkaKs7xovJv7
        WxIvfGPzwmIX5GwW2hx/cqlkedeT20Vc2YzkOElkplFJ7dQ9
X-Google-Smtp-Source: ABdhPJzYp2tfYC3l9J8yu7Msx4A4E4yuBmLbwfUAyGUllVKZNihC5OBYcJnl0yo/btfwCJ3NEfzTwDuLuyPMTJ7eXaZLyneqvxc3
MIME-Version: 1.0
X-Received: by 2002:a6b:8bc2:: with SMTP id n185mr4237866iod.174.1637314040487;
 Fri, 19 Nov 2021 01:27:20 -0800 (PST)
Date:   Fri, 19 Nov 2021 01:27:20 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c4e52d05d120e1b0@google.com>
Subject: [syzbot] KASAN: use-after-free Read in rxe_queue_cleanup
From:   syzbot <syzbot+aab53008a5adf26abe91@syzkaller.appspotmail.com>
To:     dledford@redhat.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, zyjzyj2000@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    8d0112ac6fd0 Merge tag 'net-5.16-rc2' of git://git.kernel...
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=14e3eeaab00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6d3b8fd1977c1e73
dashboard link: https://syzkaller.appspot.com/bug?extid=aab53008a5adf26abe91
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+aab53008a5adf26abe91@syzkaller.appspotmail.com

Free swap  = 0kB
Total swap = 0kB
2097051 pages RAM
0 pages HighMem/MovableOnly
384517 pages reserved
0 pages cma reserved
==================================================================
BUG: KASAN: use-after-free in rxe_queue_cleanup+0xf4/0x100 drivers/infiniband/sw/rxe/rxe_queue.c:193
Read of size 8 at addr ffff88814a6b6e90 by task syz-executor.3/9534

CPU: 1 PID: 9534 Comm: syz-executor.3 Not tainted 5.16.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description.constprop.0.cold+0x8d/0x320 mm/kasan/report.c:247
 __kasan_report mm/kasan/report.c:433 [inline]
 kasan_report.cold+0x83/0xdf mm/kasan/report.c:450
 rxe_queue_cleanup+0xf4/0x100 drivers/infiniband/sw/rxe/rxe_queue.c:193
 rxe_qp_do_cleanup+0x5d/0xa60 drivers/infiniband/sw/rxe/rxe_qp.c:804
 execute_in_process_context+0x37/0x150 kernel/workqueue.c:3359
 rxe_elem_release+0x9f/0x180 drivers/infiniband/sw/rxe/rxe_pool.c:407
 kref_put include/linux/kref.h:65 [inline]
 rxe_create_qp+0x32c/0x3b0 drivers/infiniband/sw/rxe/rxe_verbs.c:450
 create_qp+0x50c/0x880 drivers/infiniband/core/verbs.c:1238
 ib_create_qp_kernel+0x9d/0x310 drivers/infiniband/core/verbs.c:1349
 ib_create_qp include/rdma/ib_verbs.h:3722 [inline]
 create_mad_qp+0x177/0x2d0 drivers/infiniband/core/mad.c:2910
 ib_mad_port_open drivers/infiniband/core/mad.c:2991 [inline]
 ib_mad_init_device+0xd4d/0x13f0 drivers/infiniband/core/mad.c:3082
 add_client_context+0x405/0x5e0 drivers/infiniband/core/device.c:720
 enable_device_and_get+0x1cd/0x3b0 drivers/infiniband/core/device.c:1331
 ib_register_device drivers/infiniband/core/device.c:1419 [inline]
 ib_register_device+0x854/0xb50 drivers/infiniband/core/device.c:1365
 rxe_register_device+0x2fe/0x3b0 drivers/infiniband/sw/rxe/rxe_verbs.c:1146
 rxe_add+0x1331/0x1710 drivers/infiniband/sw/rxe/rxe.c:248
 rxe_net_add+0x8c/0xe0 drivers/infiniband/sw/rxe/rxe_net.c:543
 rxe_newlink drivers/infiniband/sw/rxe/rxe.c:270 [inline]
 rxe_newlink+0xb7/0xe0 drivers/infiniband/sw/rxe/rxe.c:251
 nldev_newlink+0x30a/0x560 drivers/infiniband/core/nldev.c:1717
 rdma_nl_rcv_msg+0x36d/0x690 drivers/infiniband/core/netlink.c:195
 rdma_nl_rcv_skb drivers/infiniband/core/netlink.c:239 [inline]
 rdma_nl_rcv+0x2ee/0x430 drivers/infiniband/core/netlink.c:259
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x86d/0xda0 net/netlink/af_netlink.c:1916
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:724
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2409
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2463
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2492
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f8f44e42ae9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f8f42397188 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f8f44f56020 RCX: 00007f8f44e42ae9
RDX: 0000000000000000 RSI: 00000000200000c0 RDI: 0000000000000007
RBP: 00007f8f44e9cf6d R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffde16bb93f R14: 00007f8f42397300 R15: 0000000000022000
 </TASK>

Allocated by task 9534:
 kasan_save_stack+0x1e/0x50 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:434 [inline]
 ____kasan_kmalloc mm/kasan/common.c:513 [inline]
 ____kasan_kmalloc mm/kasan/common.c:472 [inline]
 __kasan_kmalloc+0xa9/0xd0 mm/kasan/common.c:522
 kmalloc include/linux/slab.h:590 [inline]
 kzalloc include/linux/slab.h:724 [inline]
 rxe_queue_init+0x99/0x510 drivers/infiniband/sw/rxe/rxe_queue.c:66
 rxe_qp_init_req drivers/infiniband/sw/rxe/rxe_qp.c:233 [inline]
 rxe_qp_from_init+0x844/0x1bf0 drivers/infiniband/sw/rxe/rxe_qp.c:347
 rxe_create_qp+0x231/0x3b0 drivers/infiniband/sw/rxe/rxe_verbs.c:442
 create_qp+0x50c/0x880 drivers/infiniband/core/verbs.c:1238
 ib_create_qp_kernel+0x9d/0x310 drivers/infiniband/core/verbs.c:1349
 ib_create_qp include/rdma/ib_verbs.h:3722 [inline]
 create_mad_qp+0x177/0x2d0 drivers/infiniband/core/mad.c:2910
 ib_mad_port_open drivers/infiniband/core/mad.c:2991 [inline]
 ib_mad_init_device+0xd4d/0x13f0 drivers/infiniband/core/mad.c:3082
 add_client_context+0x405/0x5e0 drivers/infiniband/core/device.c:720
 enable_device_and_get+0x1cd/0x3b0 drivers/infiniband/core/device.c:1331
 ib_register_device drivers/infiniband/core/device.c:1419 [inline]
 ib_register_device+0x854/0xb50 drivers/infiniband/core/device.c:1365
 rxe_register_device+0x2fe/0x3b0 drivers/infiniband/sw/rxe/rxe_verbs.c:1146
 rxe_add+0x1331/0x1710 drivers/infiniband/sw/rxe/rxe.c:248
 rxe_net_add+0x8c/0xe0 drivers/infiniband/sw/rxe/rxe_net.c:543
 rxe_newlink drivers/infiniband/sw/rxe/rxe.c:270 [inline]
 rxe_newlink+0xb7/0xe0 drivers/infiniband/sw/rxe/rxe.c:251
 nldev_newlink+0x30a/0x560 drivers/infiniband/core/nldev.c:1717
 rdma_nl_rcv_msg+0x36d/0x690 drivers/infiniband/core/netlink.c:195
 rdma_nl_rcv_skb drivers/infiniband/core/netlink.c:239 [inline]
 rdma_nl_rcv+0x2ee/0x430 drivers/infiniband/core/netlink.c:259
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x86d/0xda0 net/netlink/af_netlink.c:1916
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:724
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2409
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2463
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2492
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Freed by task 9534:
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
 rxe_qp_from_init+0x161e/0x1bf0 drivers/infiniband/sw/rxe/rxe_qp.c:361
 rxe_create_qp+0x231/0x3b0 drivers/infiniband/sw/rxe/rxe_verbs.c:442
 create_qp+0x50c/0x880 drivers/infiniband/core/verbs.c:1238
 ib_create_qp_kernel+0x9d/0x310 drivers/infiniband/core/verbs.c:1349
 ib_create_qp include/rdma/ib_verbs.h:3722 [inline]
 create_mad_qp+0x177/0x2d0 drivers/infiniband/core/mad.c:2910
 ib_mad_port_open drivers/infiniband/core/mad.c:2991 [inline]
 ib_mad_init_device+0xd4d/0x13f0 drivers/infiniband/core/mad.c:3082
 add_client_context+0x405/0x5e0 drivers/infiniband/core/device.c:720
 enable_device_and_get+0x1cd/0x3b0 drivers/infiniband/core/device.c:1331
 ib_register_device drivers/infiniband/core/device.c:1419 [inline]
 ib_register_device+0x854/0xb50 drivers/infiniband/core/device.c:1365
 rxe_register_device+0x2fe/0x3b0 drivers/infiniband/sw/rxe/rxe_verbs.c:1146
 rxe_add+0x1331/0x1710 drivers/infiniband/sw/rxe/rxe.c:248
 rxe_net_add+0x8c/0xe0 drivers/infiniband/sw/rxe/rxe_net.c:543
 rxe_newlink drivers/infiniband/sw/rxe/rxe.c:270 [inline]
 rxe_newlink+0xb7/0xe0 drivers/infiniband/sw/rxe/rxe.c:251
 nldev_newlink+0x30a/0x560 drivers/infiniband/core/nldev.c:1717
 rdma_nl_rcv_msg+0x36d/0x690 drivers/infiniband/core/netlink.c:195
 rdma_nl_rcv_skb drivers/infiniband/core/netlink.c:239 [inline]
 rdma_nl_rcv+0x2ee/0x430 drivers/infiniband/core/netlink.c:259
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x86d/0xda0 net/netlink/af_netlink.c:1916
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:724
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2409
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2463
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2492
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

The buggy address belongs to the object at ffff88814a6b6e80
 which belongs to the cache kmalloc-64 of size 64
The buggy address is located 16 bytes inside of
 64-byte region [ffff88814a6b6e80, ffff88814a6b6ec0)
The buggy address belongs to the page:
page:ffffea000529ad80 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x14a6b6
flags: 0x57ff00000000200(slab|node=1|zone=2|lastcpupid=0x7ff)
raw: 057ff00000000200 ffffea000070c640 dead000000000003 ffff888010c41640
raw: 0000000000000000 0000000000200020 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x12cc0(GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY), pid 1, ts 15105016000, free_ts 0
 prep_new_page mm/page_alloc.c:2418 [inline]
 get_page_from_freelist+0xa72/0x2f50 mm/page_alloc.c:4149
 __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5369
 alloc_page_interleave+0x1e/0x200 mm/mempolicy.c:2036
 alloc_pages+0x29f/0x300 mm/mempolicy.c:2186
 alloc_slab_page mm/slub.c:1793 [inline]
 allocate_slab mm/slub.c:1930 [inline]
 new_slab+0x32d/0x4a0 mm/slub.c:1993
 ___slab_alloc+0x918/0xfe0 mm/slub.c:3022
 __slab_alloc.constprop.0+0x4d/0xa0 mm/slub.c:3109
 slab_alloc_node mm/slub.c:3200 [inline]
 slab_alloc mm/slub.c:3242 [inline]
 kmem_cache_alloc_trace+0x289/0x2c0 mm/slub.c:3259
 kmalloc include/linux/slab.h:590 [inline]
 kzalloc include/linux/slab.h:724 [inline]
 dropmon_net_event+0x283/0x480 net/core/drop_monitor.c:1560
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2002
 call_netdevice_notifiers_extack net/core/dev.c:2014 [inline]
 call_netdevice_notifiers net/core/dev.c:2028 [inline]
 register_netdevice+0x1073/0x1500 net/core/dev.c:10364
 register_netdev+0x2d/0x50 net/core/dev.c:10457
 rose_proto_init+0x317/0x66a net/rose/af_rose.c:1531
 do_one_initcall+0x103/0x650 init/main.c:1297
 do_initcall_level init/main.c:1370 [inline]
 do_initcalls init/main.c:1386 [inline]
 do_basic_setup init/main.c:1405 [inline]
 kernel_init_freeable+0x6b1/0x73a init/main.c:1610
page_owner free stack trace missing

Memory state around the buggy address:
 ffff88814a6b6d80: 00 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc
 ffff88814a6b6e00: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
>ffff88814a6b6e80: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
                         ^
 ffff88814a6b6f00: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
 ffff88814a6b6f80: 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
