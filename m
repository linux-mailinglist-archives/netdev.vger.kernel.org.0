Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8205D3BA767
	for <lists+netdev@lfdr.de>; Sat,  3 Jul 2021 07:29:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbhGCFb5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Jul 2021 01:31:57 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:41517 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbhGCFb4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Jul 2021 01:31:56 -0400
Received: by mail-io1-f71.google.com with SMTP id w22-20020a5ed6160000b02904f28b1d759dso8523046iom.8
        for <netdev@vger.kernel.org>; Fri, 02 Jul 2021 22:29:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=UupjzTFokHtLpY+4O0Wj4t8um0Mged+KXroEeBgmDls=;
        b=ddm5R/FTOUdpblfcmWFaDxv21wLmsajLG0qgmoBNpRMgZaVZqqpY8fo7ixAquz+7Oz
         f8RISWAxS2QgjC7ggISpNONhlz4Hdbf2BXtFXAJsTe70/+wfDEc6hZ70ONvbDacbxf3I
         ZDfTAVZ+GfrJnrjNeSc080oSOdTscCs/9rGy1pQuY1CaDpEKSpBsMV/xxMUViyb/aFR/
         C6VZtqVWBjhtUYKsZAiUs8skF1701Iikh0nMWFWIK1jPLHeTuiLKenBJn7lCzRcIZ/M6
         HdmnMwb5EgvwpXuZqjSG0rdPBeuVOcC3EE8RbPWFtIclu+flgLERLgcjGcNRfYsg6Hro
         BtVA==
X-Gm-Message-State: AOAM533VJqfk9ZGSYNznZ/5oHk6nIutaIRJALiQOCGDsJczFYUxoGfsQ
        49DLGgxbsyhDVTxgMBTMu2hYRq0w8bVILdHXXaTZhrqRXfNT
X-Google-Smtp-Source: ABdhPJzPSTKX+sxCU91DDQVxCT5GvrRWFOpbCJMwsHhorgKUsGbNR+kdt/aAmJXVkCbL0FQFSXS94RGeiWWo5nd9XUxzWyd2A+X0
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1d12:: with SMTP id i18mr2387270ila.97.1625290161836;
 Fri, 02 Jul 2021 22:29:21 -0700 (PDT)
Date:   Fri, 02 Jul 2021 22:29:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c0d86005c6315a7b@google.com>
Subject: [syzbot] KASAN: use-after-free Write in rxrpc_put_bundle (2)
From:   syzbot <syzbot+b2ed14942e201ea556e0@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dhowells@redhat.com, kuba@kernel.org,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
        marc.dionne@auristor.com, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    62fb9874 Linux 5.13
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=107f6f30300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=317f9d1d95b8a90
dashboard link: https://syzkaller.appspot.com/bug?extid=b2ed14942e201ea556e0

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b2ed14942e201ea556e0@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in instrument_atomic_read_write include/linux/instrumented.h:101 [inline]
BUG: KASAN: use-after-free in atomic_dec_return include/asm-generic/atomic-instrumented.h:340 [inline]
BUG: KASAN: use-after-free in rxrpc_put_bundle+0x1d/0x80 net/rxrpc/conn_client.c:141
Write of size 4 at addr ffff88801dcb5e20 by task ksoftirqd/1/19

CPU: 1 PID: 19 Comm: ksoftirqd/1 Not tainted 5.13.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x141/0x1d7 lib/dump_stack.c:120
 print_address_description.constprop.0.cold+0x5b/0x2f8 mm/kasan/report.c:233
 __kasan_report mm/kasan/report.c:419 [inline]
 kasan_report.cold+0x7c/0xd8 mm/kasan/report.c:436
 check_region_inline mm/kasan/generic.c:180 [inline]
 kasan_check_range+0x13d/0x180 mm/kasan/generic.c:186
 instrument_atomic_read_write include/linux/instrumented.h:101 [inline]
 atomic_dec_return include/asm-generic/atomic-instrumented.h:340 [inline]
 rxrpc_put_bundle+0x1d/0x80 net/rxrpc/conn_client.c:141
 rxrpc_destroy_connection+0x128/0x2c0 net/rxrpc/conn_object.c:365
 rcu_do_batch kernel/rcu/tree.c:2558 [inline]
 rcu_core+0x7ab/0x13b0 kernel/rcu/tree.c:2793
 __do_softirq+0x29b/0x9f6 kernel/softirq.c:559
 run_ksoftirqd kernel/softirq.c:921 [inline]
 run_ksoftirqd+0x2d/0x60 kernel/softirq.c:913
 smpboot_thread_fn+0x655/0x9e0 kernel/smpboot.c:165
 kthread+0x3b1/0x4a0 kernel/kthread.c:313
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

Allocated by task 27342:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:428 [inline]
 ____kasan_kmalloc mm/kasan/common.c:507 [inline]
 ____kasan_kmalloc mm/kasan/common.c:466 [inline]
 __kasan_kmalloc+0x9b/0xd0 mm/kasan/common.c:516
 kmalloc include/linux/slab.h:556 [inline]
 kzalloc include/linux/slab.h:686 [inline]
 rxrpc_alloc_bundle+0x82/0x2b0 net/rxrpc/conn_client.c:121
 rxrpc_look_up_bundle net/rxrpc/conn_client.c:295 [inline]
 rxrpc_prep_call net/rxrpc/conn_client.c:368 [inline]
 rxrpc_connect_call+0x5bb/0x15d0 net/rxrpc/conn_client.c:704
 rxrpc_new_client_call+0x961/0x1020 net/rxrpc/call_object.c:330
 rxrpc_new_client_call_for_sendmsg net/rxrpc/sendmsg.c:605 [inline]
 rxrpc_do_sendmsg+0xee8/0x1350 net/rxrpc/sendmsg.c:658
 rxrpc_sendmsg+0x420/0x630 net/rxrpc/af_rxrpc.c:560
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:674
 ____sys_sendmsg+0x331/0x810 net/socket.c:2337
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2391
 __sys_sendmmsg+0x195/0x470 net/socket.c:2477
 __do_sys_sendmmsg net/socket.c:2506 [inline]
 __se_sys_sendmmsg net/socket.c:2503 [inline]
 __x64_sys_sendmmsg+0x99/0x100 net/socket.c:2503
 do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Freed by task 19:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track+0x1c/0x30 mm/kasan/common.c:46
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:357
 ____kasan_slab_free mm/kasan/common.c:360 [inline]
 ____kasan_slab_free mm/kasan/common.c:325 [inline]
 __kasan_slab_free+0xfb/0x130 mm/kasan/common.c:368
 kasan_slab_free include/linux/kasan.h:212 [inline]
 slab_free_hook mm/slub.c:1583 [inline]
 slab_free_freelist_hook+0xdf/0x240 mm/slub.c:1608
 slab_free mm/slub.c:3168 [inline]
 kfree+0xe5/0x7f0 mm/slub.c:4212
 rxrpc_put_bundle net/rxrpc/conn_client.c:146 [inline]
 rxrpc_put_bundle+0x6b/0x80 net/rxrpc/conn_client.c:138
 rxrpc_destroy_connection+0x128/0x2c0 net/rxrpc/conn_object.c:365
 rcu_do_batch kernel/rcu/tree.c:2558 [inline]
 rcu_core+0x7ab/0x13b0 kernel/rcu/tree.c:2793
 __do_softirq+0x29b/0x9f6 kernel/softirq.c:559

Last potentially related work creation:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_record_aux_stack+0xe5/0x110 mm/kasan/generic.c:345
 insert_work+0x48/0x370 kernel/workqueue.c:1332
 __queue_work+0x5c1/0xed0 kernel/workqueue.c:1498
 queue_work_on+0xee/0x110 kernel/workqueue.c:1525
 queue_work include/linux/workqueue.h:507 [inline]
 call_usermodehelper_exec+0x1f0/0x4c0 kernel/umh.c:435
 kobject_uevent_env+0xf95/0x1650 lib/kobject_uevent.c:618
 kobject_synth_uevent+0x701/0x850 lib/kobject_uevent.c:208
 uevent_store+0x20/0x50 drivers/base/core.c:2370
 dev_attr_store+0x50/0x80 drivers/base/core.c:2071
 sysfs_kf_write+0x110/0x160 fs/sysfs/file.c:139
 kernfs_fop_write_iter+0x342/0x500 fs/kernfs/file.c:296
 call_write_iter include/linux/fs.h:2114 [inline]
 new_sync_write+0x426/0x650 fs/read_write.c:518
 vfs_write+0x796/0xa30 fs/read_write.c:605
 ksys_write+0x12d/0x250 fs/read_write.c:658
 do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Second to last potentially related work creation:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_record_aux_stack+0xe5/0x110 mm/kasan/generic.c:345
 insert_work+0x48/0x370 kernel/workqueue.c:1332
 __queue_work+0x5c1/0xed0 kernel/workqueue.c:1498
 queue_work_on+0xee/0x110 kernel/workqueue.c:1525
 queue_work include/linux/workqueue.h:507 [inline]
 call_usermodehelper_exec+0x1f0/0x4c0 kernel/umh.c:435
 kobject_uevent_env+0xf95/0x1650 lib/kobject_uevent.c:618
 kobject_synth_uevent+0x701/0x850 lib/kobject_uevent.c:208
 uevent_store+0x20/0x50 drivers/base/core.c:2370
 dev_attr_store+0x50/0x80 drivers/base/core.c:2071
 sysfs_kf_write+0x110/0x160 fs/sysfs/file.c:139
 kernfs_fop_write_iter+0x342/0x500 fs/kernfs/file.c:296
 call_write_iter include/linux/fs.h:2114 [inline]
 new_sync_write+0x426/0x650 fs/read_write.c:518
 vfs_write+0x796/0xa30 fs/read_write.c:605
 ksys_write+0x12d/0x250 fs/read_write.c:658
 do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
 entry_SYSCALL_64_after_hwframe+0x44/0xae

The buggy address belongs to the object at ffff88801dcb5e00
 which belongs to the cache kmalloc-192 of size 192
The buggy address is located 32 bytes inside of
 192-byte region [ffff88801dcb5e00, ffff88801dcb5ec0)
The buggy address belongs to the page:
page:ffffea0000772d40 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1dcb5
flags: 0xfff00000000200(slab|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000000200 dead000000000100 dead000000000122 ffff888011041a00
raw: 0000000000000000 0000000000100010 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x12a20(GFP_ATOMIC|__GFP_NOWARN|__GFP_NORETRY), pid 8523, ts 188015122909, free_ts 187967405790
 prep_new_page mm/page_alloc.c:2358 [inline]
 get_page_from_freelist+0x1033/0x2b60 mm/page_alloc.c:3994
 __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5204
 alloc_pages+0x18c/0x2a0 mm/mempolicy.c:2272
 alloc_slab_page mm/slub.c:1646 [inline]
 allocate_slab+0x2c5/0x4c0 mm/slub.c:1786
 new_slab mm/slub.c:1849 [inline]
 new_slab_objects mm/slub.c:2595 [inline]
 ___slab_alloc+0x4a1/0x810 mm/slub.c:2758
 __slab_alloc.constprop.0+0xa7/0xf0 mm/slub.c:2798
 slab_alloc_node mm/slub.c:2880 [inline]
 slab_alloc mm/slub.c:2922 [inline]
 kmem_cache_alloc_trace+0x2a3/0x2c0 mm/slub.c:2939
 kmalloc include/linux/slab.h:556 [inline]
 addr_event.part.0+0x7b/0x4d0 drivers/infiniband/core/roce_gid_mgmt.c:839
 addr_event drivers/infiniband/core/roce_gid_mgmt.c:823 [inline]
 inet6addr_event+0x13e/0x1b0 drivers/infiniband/core/roce_gid_mgmt.c:882
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 atomic_notifier_call_chain+0x8d/0x170 kernel/notifier.c:217
 ipv6_add_addr+0x1750/0x1ef0 net/ipv6/addrconf.c:1152
 inet6_addr_add+0x410/0xae0 net/ipv6/addrconf.c:2945
 inet6_rtm_newaddr+0xf00/0x1970 net/ipv6/addrconf.c:4871
 rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5566
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1298 [inline]
 free_pcp_prepare+0x223/0x300 mm/page_alloc.c:1342
 free_unref_page_prepare mm/page_alloc.c:3250 [inline]
 free_unref_page+0x12/0x1d0 mm/page_alloc.c:3298
 unfreeze_partials+0x17c/0x1d0 mm/slub.c:2376
 put_cpu_partial+0x13d/0x230 mm/slub.c:2412
 qlink_free mm/kasan/quarantine.c:146 [inline]
 qlist_free_all+0x5a/0xc0 mm/kasan/quarantine.c:165
 kasan_quarantine_reduce+0x180/0x200 mm/kasan/quarantine.c:272
 __kasan_slab_alloc+0x8e/0xa0 mm/kasan/common.c:438
 kasan_slab_alloc include/linux/kasan.h:236 [inline]
 slab_post_alloc_hook mm/slab.h:524 [inline]
 slab_alloc_node mm/slub.c:2914 [inline]
 slab_alloc mm/slub.c:2922 [inline]
 kmem_cache_alloc_trace+0x201/0x2c0 mm/slub.c:2939
 kmalloc include/linux/slab.h:556 [inline]
 kzalloc include/linux/slab.h:686 [inline]
 ipv6_add_addr+0x363/0x1ef0 net/ipv6/addrconf.c:1083
 addrconf_add_linklocal+0x1ca/0x590 net/ipv6/addrconf.c:3182
 addrconf_addr_gen+0x3a4/0x3e0 net/ipv6/addrconf.c:3313
 addrconf_dev_config+0x26c/0x410 net/ipv6/addrconf.c:3360
 addrconf_notify+0x362/0x23e0 net/ipv6/addrconf.c:3593
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2121
 call_netdevice_notifiers_extack net/core/dev.c:2133 [inline]
 call_netdevice_notifiers net/core/dev.c:2147 [inline]
 __dev_notify_flags+0x110/0x2b0 net/core/dev.c:8798

Memory state around the buggy address:
 ffff88801dcb5d00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff88801dcb5d80: 00 00 00 fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff88801dcb5e00: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                               ^
 ffff88801dcb5e80: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
 ffff88801dcb5f00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
