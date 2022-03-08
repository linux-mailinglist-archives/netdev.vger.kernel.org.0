Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF764D1F9B
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 19:03:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241721AbiCHSES (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 13:04:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238356AbiCHSES (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 13:04:18 -0500
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76A573587E
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 10:03:20 -0800 (PST)
Received: by mail-io1-f69.google.com with SMTP id g16-20020a05660203d000b005f7b3b0642eso13335354iov.16
        for <netdev@vger.kernel.org>; Tue, 08 Mar 2022 10:03:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=RWf3+dpfL4savAt5Px6y0ovjoV7YIU8rixiN7rFHStk=;
        b=Ma5ZJfn+ptOErmooeo01OJPRreIte/tt5W3UyD7H7s+r9smiYbfM5zoEEdlaWx837O
         GWFppnpcbguP+OUaxH6y8NUpiczXMZReqxSvkQRnc4DIxe8DalFOcjqEoCgR0A8nFsDW
         oMsgPPrZTBvdYvTLDIqU09b/ASJImvk/9KauQP0Apd6uaTAJO26UGOqlS1sALPr/Wl7Q
         ueD60juDL7VWFtNxslQ1rdaHeBdihPP0BS7+o4PKI2chKE1TEMV86cl+epL6ympWgmxy
         auvztdVUkqXImg837hsOb87u7Ur+hsQ5kf1bIk+2ydhgjd+iV/Fcx/9DUn4os+54QEjg
         Lxdw==
X-Gm-Message-State: AOAM533JHop/Qh7YdpKAA3MX9cHtnP4tA8gfwqF4KBDBNHFqFSOpi6Yg
        ynep1EPovMEGH2PqslSGkjNNewUNPN4x44303GXCuHoMbovo
X-Google-Smtp-Source: ABdhPJy4Ai5tCX7c+iCDoThOd+ECopfXJuj3wbnY+m8nhFrCAzjiieezsy3GPL8H/zYLgg3S4Lk3Pi3cvxkFIZ2aOigkweYPAnXo
MIME-Version: 1.0
X-Received: by 2002:a05:6638:328f:b0:30f:624d:9d82 with SMTP id
 f15-20020a056638328f00b0030f624d9d82mr16896854jav.227.1646762599867; Tue, 08
 Mar 2022 10:03:19 -0800 (PST)
Date:   Tue, 08 Mar 2022 10:03:19 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000cb6dd805d9b8cbb8@google.com>
Subject: [syzbot] KASAN: use-after-free Read in port100_send_complete
From:   syzbot <syzbot+16bcb127fb73baeecb14@syzkaller.appspotmail.com>
To:     krzysztof.kozlowski@canonical.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    38f80f42147f MAINTAINERS: Remove dead patchwork link
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14b0d321700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=542b2708133cc492
dashboard link: https://syzkaller.appspot.com/bug?extid=16bcb127fb73baeecb14
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14a63d21700000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17d21be1700000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+16bcb127fb73baeecb14@syzkaller.appspotmail.com

port100 5-1:0.0: NFC: Urb failure (status -71)
==================================================================
BUG: KASAN: use-after-free in port100_send_complete+0x16e/0x1a0 drivers/nfc/port100.c:935
Read of size 1 at addr ffff88801bb59540 by task ksoftirqd/2/26

CPU: 2 PID: 26 Comm: ksoftirqd/2 Not tainted 5.17.0-rc6-syzkaller-00184-g38f80f42147f #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description.constprop.0.cold+0x8d/0x303 mm/kasan/report.c:255
 __kasan_report mm/kasan/report.c:442 [inline]
 kasan_report.cold+0x83/0xdf mm/kasan/report.c:459
 port100_send_complete+0x16e/0x1a0 drivers/nfc/port100.c:935
 __usb_hcd_giveback_urb+0x2b0/0x5c0 drivers/usb/core/hcd.c:1670
 usb_hcd_giveback_urb+0x367/0x410 drivers/usb/core/hcd.c:1747
 dummy_timer+0x11f9/0x32b0 drivers/usb/gadget/udc/dummy_hcd.c:1987
 call_timer_fn+0x1a5/0x6b0 kernel/time/timer.c:1421
 expire_timers kernel/time/timer.c:1466 [inline]
 __run_timers.part.0+0x67c/0xa30 kernel/time/timer.c:1734
 __run_timers kernel/time/timer.c:1715 [inline]
 run_timer_softirq+0xb3/0x1d0 kernel/time/timer.c:1747
 __do_softirq+0x29b/0x9c2 kernel/softirq.c:558
 run_ksoftirqd kernel/softirq.c:921 [inline]
 run_ksoftirqd+0x2d/0x60 kernel/softirq.c:913
 smpboot_thread_fn+0x645/0x9c0 kernel/smpboot.c:164
 kthread+0x2e9/0x3a0 kernel/kthread.c:377
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
 </TASK>

Allocated by task 1255:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:45 [inline]
 set_alloc_info mm/kasan/common.c:436 [inline]
 ____kasan_kmalloc mm/kasan/common.c:515 [inline]
 ____kasan_kmalloc mm/kasan/common.c:474 [inline]
 __kasan_kmalloc+0xa6/0xd0 mm/kasan/common.c:524
 alloc_dr drivers/base/devres.c:116 [inline]
 devm_kmalloc+0x96/0x1d0 drivers/base/devres.c:823
 devm_kzalloc include/linux/device.h:209 [inline]
 port100_probe+0x8a/0x1320 drivers/nfc/port100.c:1502
 usb_probe_interface+0x315/0x7f0 drivers/usb/core/driver.c:396
 call_driver_probe drivers/base/dd.c:517 [inline]
 really_probe+0x245/0xcc0 drivers/base/dd.c:596
 __driver_probe_device+0x338/0x4d0 drivers/base/dd.c:755
 driver_probe_device+0x4c/0x1a0 drivers/base/dd.c:785
 __device_attach_driver+0x20b/0x2f0 drivers/base/dd.c:902
 bus_for_each_drv+0x15f/0x1e0 drivers/base/bus.c:427
 __device_attach+0x228/0x4a0 drivers/base/dd.c:973
 bus_probe_device+0x1e4/0x290 drivers/base/bus.c:487
 device_add+0xb83/0x1e20 drivers/base/core.c:3405
 usb_set_configuration+0x101e/0x1900 drivers/usb/core/message.c:2170
 usb_generic_driver_probe+0xba/0x100 drivers/usb/core/generic.c:238
 usb_probe_device+0xd9/0x2c0 drivers/usb/core/driver.c:293
 call_driver_probe drivers/base/dd.c:517 [inline]
 really_probe+0x245/0xcc0 drivers/base/dd.c:596
 __driver_probe_device+0x338/0x4d0 drivers/base/dd.c:755
 driver_probe_device+0x4c/0x1a0 drivers/base/dd.c:785
 __device_attach_driver+0x20b/0x2f0 drivers/base/dd.c:902
 bus_for_each_drv+0x15f/0x1e0 drivers/base/bus.c:427
 __device_attach+0x228/0x4a0 drivers/base/dd.c:973
 bus_probe_device+0x1e4/0x290 drivers/base/bus.c:487
 device_add+0xb83/0x1e20 drivers/base/core.c:3405
 usb_new_device.cold+0x63f/0x108e drivers/usb/core/hub.c:2566
 hub_port_connect drivers/usb/core/hub.c:5358 [inline]
 hub_port_connect_change drivers/usb/core/hub.c:5502 [inline]
 port_event drivers/usb/core/hub.c:5660 [inline]
 hub_event+0x2585/0x44d0 drivers/usb/core/hub.c:5742
 process_one_work+0x9ac/0x1650 kernel/workqueue.c:2307
 worker_thread+0x657/0x1110 kernel/workqueue.c:2454
 kthread+0x2e9/0x3a0 kernel/kthread.c:377
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

Freed by task 1255:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 kasan_set_track+0x21/0x30 mm/kasan/common.c:45
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:370
 ____kasan_slab_free mm/kasan/common.c:366 [inline]
 ____kasan_slab_free+0xff/0x140 mm/kasan/common.c:328
 kasan_slab_free include/linux/kasan.h:236 [inline]
 __cache_free mm/slab.c:3437 [inline]
 kfree+0xf8/0x2b0 mm/slab.c:3794
 release_nodes+0x112/0x1a0 drivers/base/devres.c:501
 devres_release_all+0x114/0x190 drivers/base/devres.c:530
 really_probe+0x626/0xcc0 drivers/base/dd.c:670
 __driver_probe_device+0x338/0x4d0 drivers/base/dd.c:755
 driver_probe_device+0x4c/0x1a0 drivers/base/dd.c:785
 __device_attach_driver+0x20b/0x2f0 drivers/base/dd.c:902
 bus_for_each_drv+0x15f/0x1e0 drivers/base/bus.c:427
 __device_attach+0x228/0x4a0 drivers/base/dd.c:973
 bus_probe_device+0x1e4/0x290 drivers/base/bus.c:487
 device_add+0xb83/0x1e20 drivers/base/core.c:3405
 usb_set_configuration+0x101e/0x1900 drivers/usb/core/message.c:2170
 usb_generic_driver_probe+0xba/0x100 drivers/usb/core/generic.c:238
 usb_probe_device+0xd9/0x2c0 drivers/usb/core/driver.c:293
 call_driver_probe drivers/base/dd.c:517 [inline]
 really_probe+0x245/0xcc0 drivers/base/dd.c:596
 __driver_probe_device+0x338/0x4d0 drivers/base/dd.c:755
 driver_probe_device+0x4c/0x1a0 drivers/base/dd.c:785
 __device_attach_driver+0x20b/0x2f0 drivers/base/dd.c:902
 bus_for_each_drv+0x15f/0x1e0 drivers/base/bus.c:427
 __device_attach+0x228/0x4a0 drivers/base/dd.c:973
 bus_probe_device+0x1e4/0x290 drivers/base/bus.c:487
 device_add+0xb83/0x1e20 drivers/base/core.c:3405
 usb_new_device.cold+0x63f/0x108e drivers/usb/core/hub.c:2566
 hub_port_connect drivers/usb/core/hub.c:5358 [inline]
 hub_port_connect_change drivers/usb/core/hub.c:5502 [inline]
 port_event drivers/usb/core/hub.c:5660 [inline]
 hub_event+0x2585/0x44d0 drivers/usb/core/hub.c:5742
 process_one_work+0x9ac/0x1650 kernel/workqueue.c:2307
 worker_thread+0x657/0x1110 kernel/workqueue.c:2454
 kthread+0x2e9/0x3a0 kernel/kthread.c:377
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

Last potentially related work creation:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 __kasan_record_aux_stack+0x7e/0x90 mm/kasan/generic.c:348
 insert_work+0x48/0x370 kernel/workqueue.c:1368
 __queue_work+0x5ca/0xf30 kernel/workqueue.c:1534
 queue_work_on+0xee/0x110 kernel/workqueue.c:1562
 queue_work include/linux/workqueue.h:502 [inline]
 schedule_work include/linux/workqueue.h:563 [inline]
 port100_recv_ack+0x2cf/0x3c0 drivers/nfc/port100.c:710
 __usb_hcd_giveback_urb+0x2b0/0x5c0 drivers/usb/core/hcd.c:1670
 usb_hcd_giveback_urb+0x367/0x410 drivers/usb/core/hcd.c:1747
 dummy_timer+0x11f9/0x32b0 drivers/usb/gadget/udc/dummy_hcd.c:1987
 call_timer_fn+0x1a5/0x6b0 kernel/time/timer.c:1421
 expire_timers kernel/time/timer.c:1466 [inline]
 __run_timers.part.0+0x67c/0xa30 kernel/time/timer.c:1734
 __run_timers kernel/time/timer.c:1715 [inline]
 run_timer_softirq+0xb3/0x1d0 kernel/time/timer.c:1747
 __do_softirq+0x29b/0x9c2 kernel/softirq.c:558

The buggy address belongs to the object at ffff88801bb59400
 which belongs to the cache kmalloc-512 of size 512
The buggy address is located 320 bytes inside of
 512-byte region [ffff88801bb59400, ffff88801bb59600)
The buggy address belongs to the page:
page:ffffea00006ed640 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1bb59
flags: 0xfff00000000200(slab|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000000200 ffffea000068aec8 ffffea00006fe408 ffff888010c40600
raw: 0000000000000000 ffff88801bb59000 0000000100000004 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x2420c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_COMP|__GFP_THISNODE), pid 1, ts 13880885565, free_ts 13141726599
 prep_new_page mm/page_alloc.c:2434 [inline]
 get_page_from_freelist+0xa72/0x2f50 mm/page_alloc.c:4165
 __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5389
 __alloc_pages_node include/linux/gfp.h:572 [inline]
 kmem_getpages mm/slab.c:1378 [inline]
 cache_grow_begin+0x75/0x390 mm/slab.c:2584
 cache_alloc_refill+0x27f/0x380 mm/slab.c:2957
 ____cache_alloc mm/slab.c:3040 [inline]
 ____cache_alloc mm/slab.c:3023 [inline]
 __do_cache_alloc mm/slab.c:3267 [inline]
 slab_alloc mm/slab.c:3308 [inline]
 kmem_cache_alloc_trace+0x380/0x4a0 mm/slab.c:3565
 kmalloc include/linux/slab.h:581 [inline]
 kzalloc include/linux/slab.h:714 [inline]
 device_private_init drivers/base/core.c:3249 [inline]
 device_add+0x1113/0x1e20 drivers/base/core.c:3299
 netdev_register_kobject+0x181/0x430 net/core/net-sysfs.c:2008
 register_netdevice+0xd9d/0x1580 net/core/dev.c:9667
 register_netdev+0x2d/0x50 net/core/dev.c:9791
 e1000_probe+0x212f/0x3360 drivers/net/ethernet/intel/e1000e/netdev.c:7710
 local_pci_probe+0xe1/0x1a0 drivers/pci/pci-driver.c:323
 pci_call_probe drivers/pci/pci-driver.c:380 [inline]
 __pci_device_probe drivers/pci/pci-driver.c:405 [inline]
 pci_device_probe+0x298/0x740 drivers/pci/pci-driver.c:448
 call_driver_probe drivers/base/dd.c:517 [inline]
 really_probe+0x245/0xcc0 drivers/base/dd.c:596
 __driver_probe_device+0x338/0x4d0 drivers/base/dd.c:755
 driver_probe_device+0x4c/0x1a0 drivers/base/dd.c:785
 __driver_attach+0x22d/0x4e0 drivers/base/dd.c:1144
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1352 [inline]
 free_pcp_prepare+0x374/0x870 mm/page_alloc.c:1404
 free_unref_page_prepare mm/page_alloc.c:3325 [inline]
 free_unref_page+0x19/0x690 mm/page_alloc.c:3404
 rcu_do_batch kernel/rcu/tree.c:2527 [inline]
 rcu_core+0x7b1/0x1820 kernel/rcu/tree.c:2778
 __do_softirq+0x29b/0x9c2 kernel/softirq.c:558

Memory state around the buggy address:
 ffff88801bb59400: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88801bb59480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff88801bb59500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                           ^
 ffff88801bb59580: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88801bb59600: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
