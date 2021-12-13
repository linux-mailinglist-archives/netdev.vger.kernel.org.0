Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E23D472C2D
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 13:20:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236696AbhLMMUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 07:20:25 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:34749 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236635AbhLMMUY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 07:20:24 -0500
Received: by mail-il1-f197.google.com with SMTP id h10-20020a056e021b8a00b002a3f246adeaso14747503ili.1
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 04:20:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=VXm/+Tlsxetwopf5HAh/B1M4Zf7Ek54Tvmbhc5zIEsY=;
        b=gixVy8QGqpH4K6SnZCWLl31ZdRrpDExQK1o7LluK7wVs3O4QfyTDIqrvSPWyQ1AMhS
         UoKG4SExRF84Uk6FI2lY4noRK5f7RDGnGVax7T2/l65PpfB4rN+yJMjG7TbQVZmqbeyP
         0Tca0o/ofrdzRuwkMku9mEw4B+W4XAQSrPrK+MEY3y81yYy8iI6o9HY4d+KTtdNk1dtp
         3LXWNtQxl3GSh8/pvGvcFQ0fu/Lau1HSfjMrUDJiq/2z/gg3OTjIp2AgpBeZOBocBXZM
         c1o2JX3S2W9j0nm1w64Qga6hOML3eiyVKNnya5Ebunva82Sz8NagrINHCCWYTw2Sr49i
         S5gQ==
X-Gm-Message-State: AOAM530JPZYt8ipLQ21rks4kThquZmHXkTxzLWpaJN6cjK84dhGVEkEG
        +6YuXJK4c3XZOHRSuoGX9Kwi4D+vSdulcdB8ppmdsFRjlLA8
X-Google-Smtp-Source: ABdhPJxVqh2OQJIslH66ltWNMgdRlzKLRmIf99LHh+8OxTLQ7gz6bwsXFens5LHc8a5TquANQ8vJMPm0mIR4LKRzDKxHqh3lpR+c
MIME-Version: 1.0
X-Received: by 2002:a05:6602:1487:: with SMTP id a7mr32194621iow.57.1639398024345;
 Mon, 13 Dec 2021 04:20:24 -0800 (PST)
Date:   Mon, 13 Dec 2021 04:20:24 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e2fc6405d3061843@google.com>
Subject: [syzbot] KASAN: use-after-free Read in cdc_ncm_tx_fixup
From:   syzbot <syzbot+5ec3d1378e31c88d87f4@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        oliver@neukum.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    2a987e65025e Merge tag 'perf-tools-fixes-for-v5.16-2021-12..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12a848b9b00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5247c9e141823545
dashboard link: https://syzkaller.appspot.com/bug?extid=5ec3d1378e31c88d87f4
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5ec3d1378e31c88d87f4@syzkaller.appspotmail.com

usb 7-1: USB disconnect, device number 2
cdc_ncm 7-1:1.0 usb0: unregister 'cdc_ncm' usb-dummy_hcd.2-1, CDC NCM
==================================================================
BUG: KASAN: use-after-free in __lock_acquire+0x3d86/0x54a0 kernel/locking/lockdep.c:4897
Read of size 8 at addr ffff888018b184f0 by task kworker/2:1/40

CPU: 2 PID: 40 Comm: kworker/2:1 Not tainted 5.16.0-rc4-syzkaller #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2 04/01/2014
Workqueue: usb_hub_wq hub_event
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description.constprop.0.cold+0x8d/0x2ed mm/kasan/report.c:247
 __kasan_report mm/kasan/report.c:433 [inline]
 kasan_report.cold+0x83/0xdf mm/kasan/report.c:450
 __lock_acquire+0x3d86/0x54a0 kernel/locking/lockdep.c:4897
 lock_acquire kernel/locking/lockdep.c:5637 [inline]
 lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5602
 __raw_spin_lock_bh include/linux/spinlock_api_smp.h:126 [inline]
 _raw_spin_lock_bh+0x2f/0x40 kernel/locking/spinlock.c:178
 spin_lock_bh include/linux/spinlock.h:354 [inline]
 cdc_ncm_tx_fixup+0x8f/0x120 drivers/net/usb/cdc_ncm.c:1525
 usbnet_start_xmit+0x152/0x1f70 drivers/net/usb/usbnet.c:1372
 __netdev_start_xmit include/linux/netdevice.h:4994 [inline]
 netdev_start_xmit include/linux/netdevice.h:5008 [inline]
 xmit_one net/core/dev.c:3590 [inline]
 dev_hard_start_xmit+0x1eb/0x920 net/core/dev.c:3606
 sch_direct_xmit+0x19f/0xbe0 net/sched/sch_generic.c:342
 __dev_xmit_skb net/core/dev.c:3817 [inline]
 __dev_queue_xmit+0x149c/0x3650 net/core/dev.c:4194
 lapb_data_transmit+0x8f/0xc0 net/lapb/lapb_iface.c:447
 lapb_transmit_buffer+0x183/0x390 net/lapb/lapb_out.c:149
 lapb_send_control+0x1c7/0x370 net/lapb/lapb_subr.c:251
 __lapb_disconnect_request+0x127/0x1a0 net/lapb/lapb_iface.c:326
 lapb_device_event+0x292/0x560 net/lapb/lapb_iface.c:492
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2002
 call_netdevice_notifiers_extack net/core/dev.c:2014 [inline]
 call_netdevice_notifiers net/core/dev.c:2028 [inline]
 __dev_close_many+0xf1/0x2e0 net/core/dev.c:1548
 dev_close_many+0x22c/0x620 net/core/dev.c:1599
 dev_close net/core/dev.c:1625 [inline]
 dev_close+0x16d/0x210 net/core/dev.c:1619
 lapbeth_device_event+0x677/0xc00 drivers/net/wan/lapbether.c:462
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2002
 call_netdevice_notifiers_extack net/core/dev.c:2014 [inline]
 call_netdevice_notifiers net/core/dev.c:2028 [inline]
 __dev_close_many+0xf1/0x2e0 net/core/dev.c:1548
 dev_close_many+0x22c/0x620 net/core/dev.c:1599
 unregister_netdevice_many+0x3ff/0x1790 net/core/dev.c:11057
 unregister_netdevice_queue+0x2dd/0x3c0 net/core/dev.c:11014
 unregister_netdevice include/linux/netdevice.h:2989 [inline]
 unregister_netdev+0x18/0x20 net/core/dev.c:11139
 usbnet_disconnect+0x139/0x270 drivers/net/usb/usbnet.c:1623
 usb_unbind_interface+0x1d8/0x8e0 drivers/usb/core/driver.c:458
 __device_release_driver+0x5d7/0x700 drivers/base/dd.c:1205
 device_release_driver_internal drivers/base/dd.c:1236 [inline]
 device_release_driver+0x26/0x40 drivers/base/dd.c:1259
 bus_remove_device+0x2eb/0x5a0 drivers/base/bus.c:529
 device_del+0x502/0xd60 drivers/base/core.c:3581
 usb_disable_device+0x35b/0x7b0 drivers/usb/core/message.c:1419
 usb_disconnect.cold+0x27a/0x78e drivers/usb/core/hub.c:2225
 hub_port_connect drivers/usb/core/hub.c:5197 [inline]
 hub_port_connect_change drivers/usb/core/hub.c:5497 [inline]
 port_event drivers/usb/core/hub.c:5643 [inline]
 hub_event+0x1c9c/0x4460 drivers/usb/core/hub.c:5725
 process_one_work+0x9b2/0x1690 kernel/workqueue.c:2298
 worker_thread+0x658/0x11f0 kernel/workqueue.c:2445
 kthread+0x405/0x4f0 kernel/kthread.c:327
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
 </TASK>

Allocated by task 40:
 kasan_save_stack+0x1e/0x50 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:434 [inline]
 ____kasan_kmalloc mm/kasan/common.c:513 [inline]
 ____kasan_kmalloc mm/kasan/common.c:472 [inline]
 __kasan_kmalloc+0xa6/0xd0 mm/kasan/common.c:522
 kasan_kmalloc include/linux/kasan.h:269 [inline]
 kmem_cache_alloc_trace+0x1ea/0x4a0 mm/slab.c:3575
 kmalloc include/linux/slab.h:590 [inline]
 kzalloc include/linux/slab.h:724 [inline]
 cdc_ncm_bind_common+0xb8/0x2df0 drivers/net/usb/cdc_ncm.c:824
 cdc_ncm_bind+0x7c/0x1c0 drivers/net/usb/cdc_ncm.c:1067
 usbnet_probe+0xb21/0x25b0 drivers/net/usb/usbnet.c:1747
 usb_probe_interface+0x315/0x7f0 drivers/usb/core/driver.c:396
 call_driver_probe drivers/base/dd.c:517 [inline]
 really_probe+0x245/0xcc0 drivers/base/dd.c:596
 __driver_probe_device+0x338/0x4d0 drivers/base/dd.c:751
 driver_probe_device+0x4c/0x1a0 drivers/base/dd.c:781
 __device_attach_driver+0x20b/0x2f0 drivers/base/dd.c:898
 bus_for_each_drv+0x15f/0x1e0 drivers/base/bus.c:427
 __device_attach+0x228/0x4a0 drivers/base/dd.c:969
 bus_probe_device+0x1e4/0x290 drivers/base/bus.c:487
 device_add+0xc17/0x1ee0 drivers/base/core.c:3394
 usb_set_configuration+0x101e/0x1900 drivers/usb/core/message.c:2170
 usb_generic_driver_probe+0xba/0x100 drivers/usb/core/generic.c:238
 usb_probe_device+0xd9/0x2c0 drivers/usb/core/driver.c:293
 call_driver_probe drivers/base/dd.c:517 [inline]
 really_probe+0x245/0xcc0 drivers/base/dd.c:596
 __driver_probe_device+0x338/0x4d0 drivers/base/dd.c:751
 driver_probe_device+0x4c/0x1a0 drivers/base/dd.c:781
 __device_attach_driver+0x20b/0x2f0 drivers/base/dd.c:898
 bus_for_each_drv+0x15f/0x1e0 drivers/base/bus.c:427
 __device_attach+0x228/0x4a0 drivers/base/dd.c:969
 bus_probe_device+0x1e4/0x290 drivers/base/bus.c:487
 device_add+0xc17/0x1ee0 drivers/base/core.c:3394
 usb_new_device.cold+0x63f/0x108e drivers/usb/core/hub.c:2563
 hub_port_connect drivers/usb/core/hub.c:5353 [inline]
 hub_port_connect_change drivers/usb/core/hub.c:5497 [inline]
 port_event drivers/usb/core/hub.c:5643 [inline]
 hub_event+0x23e5/0x4460 drivers/usb/core/hub.c:5725
 process_one_work+0x9b2/0x1690 kernel/workqueue.c:2298
 worker_thread+0x658/0x11f0 kernel/workqueue.c:2445
 kthread+0x405/0x4f0 kernel/kthread.c:327
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

Freed by task 40:
 kasan_save_stack+0x1e/0x50 mm/kasan/common.c:38
 kasan_set_track+0x21/0x30 mm/kasan/common.c:46
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:370
 ____kasan_slab_free mm/kasan/common.c:366 [inline]
 ____kasan_slab_free mm/kasan/common.c:328 [inline]
 __kasan_slab_free+0xd1/0x110 mm/kasan/common.c:374
 kasan_slab_free include/linux/kasan.h:235 [inline]
 __cache_free mm/slab.c:3445 [inline]
 kfree+0x10d/0x2c0 mm/slab.c:3802
 cdc_ncm_free+0x145/0x1a0 drivers/net/usb/cdc_ncm.c:784
 cdc_ncm_unbind+0x1a7/0x340 drivers/net/usb/cdc_ncm.c:1019
 usbnet_disconnect+0x103/0x270 drivers/net/usb/usbnet.c:1620
 usb_unbind_interface+0x1d8/0x8e0 drivers/usb/core/driver.c:458
 __device_release_driver+0x5d7/0x700 drivers/base/dd.c:1205
 device_release_driver_internal drivers/base/dd.c:1236 [inline]
 device_release_driver+0x26/0x40 drivers/base/dd.c:1259
 bus_remove_device+0x2eb/0x5a0 drivers/base/bus.c:529
 device_del+0x502/0xd60 drivers/base/core.c:3581
 usb_disable_device+0x35b/0x7b0 drivers/usb/core/message.c:1419
 usb_disconnect.cold+0x27a/0x78e drivers/usb/core/hub.c:2225
 hub_port_connect drivers/usb/core/hub.c:5197 [inline]
 hub_port_connect_change drivers/usb/core/hub.c:5497 [inline]
 port_event drivers/usb/core/hub.c:5643 [inline]
 hub_event+0x1c9c/0x4460 drivers/usb/core/hub.c:5725
 process_one_work+0x9b2/0x1690 kernel/workqueue.c:2298
 worker_thread+0x658/0x11f0 kernel/workqueue.c:2445
 kthread+0x405/0x4f0 kernel/kthread.c:327
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

The buggy address belongs to the object at ffff888018b18400
 which belongs to the cache kmalloc-512 of size 512
The buggy address is located 240 bytes inside of
 512-byte region [ffff888018b18400, ffff888018b18600)
The buggy address belongs to the page:
page:ffffea000062c600 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff888018b18c00 pfn:0x18b18
flags: 0xfff00000000200(slab|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000000200 ffffea00006274c8 ffffea000063dd88 ffff888010c40600
raw: ffff888018b18c00 ffff888018b18000 0000000100000003 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x2420c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_COMP|__GFP_THISNODE), pid 545, ts 26238686038, free_ts 26238573279
 prep_new_page mm/page_alloc.c:2418 [inline]
 get_page_from_freelist+0xa72/0x2f50 mm/page_alloc.c:4149
 __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5369
 __alloc_pages_node include/linux/gfp.h:570 [inline]
 kmem_getpages mm/slab.c:1377 [inline]
 cache_grow_begin+0x75/0x470 mm/slab.c:2593
 cache_alloc_refill+0x27f/0x380 mm/slab.c:2965
 ____cache_alloc mm/slab.c:3048 [inline]
 ____cache_alloc mm/slab.c:3031 [inline]
 __do_cache_alloc mm/slab.c:3275 [inline]
 slab_alloc mm/slab.c:3316 [inline]
 kmem_cache_alloc_trace+0x380/0x4a0 mm/slab.c:3573
 kmalloc include/linux/slab.h:590 [inline]
 kzalloc include/linux/slab.h:724 [inline]
 alloc_bprm+0x51/0x8f0 fs/exec.c:1503
 kernel_execve+0x55/0x460 fs/exec.c:1943
 call_usermodehelper_exec_async+0x2e3/0x580 kernel/umh.c:112
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1338 [inline]
 free_pcp_prepare+0x374/0x870 mm/page_alloc.c:1389
 free_unref_page_prepare mm/page_alloc.c:3309 [inline]
 free_unref_page+0x19/0x690 mm/page_alloc.c:3388
 rcu_do_batch kernel/rcu/tree.c:2506 [inline]
 rcu_core+0x7ab/0x1470 kernel/rcu/tree.c:2741
 __do_softirq+0x29b/0x9c2 kernel/softirq.c:558
 run_ksoftirqd kernel/softirq.c:921 [inline]
 run_ksoftirqd+0x2d/0x60 kernel/softirq.c:913
 smpboot_thread_fn+0x645/0x9c0 kernel/smpboot.c:164
 kthread+0x405/0x4f0 kernel/kthread.c:327
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

Memory state around the buggy address:
 ffff888018b18380: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888018b18400: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff888018b18480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                             ^
 ffff888018b18500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888018b18580: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
