Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46F5B4D10A2
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 08:01:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344349AbiCHHCY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 02:02:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbiCHHCX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 02:02:23 -0500
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BB533D49E
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 23:01:25 -0800 (PST)
Received: by mail-io1-f71.google.com with SMTP id e11-20020a5d8e0b000000b006412cf3f627so12230258iod.17
        for <netdev@vger.kernel.org>; Mon, 07 Mar 2022 23:01:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=6F33WBPf5kIetygVAiLTzW5tsO0pahcTa15vp8diz+o=;
        b=5n0UPvsdVih5sKDBFSEw602i7GrHEaP6Mk8MzTfFcfuyH4Fwuqcsh/++9Ykf5ydlLj
         3q/yU95mr/2FNwyPBrHVLIR7vF3zMu18x6dSNceaqHJGww6oVw3gI0a9+4rAE1/YRNY2
         TatHqk+H5stJDVO18saluSloEFiA4zn4biDf9gzqVi6vHAgTKoJ4Z9fBKME74/hrwTfQ
         qIoWet9KgHuXICCiKAbUzZfduZFkEXJjUetavCdkex7RkQRoig2QdJPfTBWmxUEGemTa
         HOrtoWLG4r0Ib++1dbMH0TByr76U1ShkisrycEJWG1FJGv3BtMw6ch/hJnLmMUH0+IML
         CTxA==
X-Gm-Message-State: AOAM531H6wATzHsJobjdg6/N6chAZacH9NrdPALP6t2muEt8G1ARfS4L
        FZVebauy5aX2kbglXZysNYIBsiTDAbg8BNqWHZhGrzUjT7f4
X-Google-Smtp-Source: ABdhPJzK550fhHNRyqqpsrAfqKc2I+7cMEFPEBNEkQdWXrv1TPxmFs5q0AEICAYsKERC9wsfQuz3crhsejW0HhSwBoGwk4xtphyZ
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2e07:b0:644:98e9:fa64 with SMTP id
 o7-20020a0566022e0700b0064498e9fa64mr13472784iow.96.1646722884340; Mon, 07
 Mar 2022 23:01:24 -0800 (PST)
Date:   Mon, 07 Mar 2022 23:01:24 -0800
In-Reply-To: <000000000000e2fc6405d3061843@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009090d705d9af8c85@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in cdc_ncm_tx_fixup
From:   syzbot <syzbot+5ec3d1378e31c88d87f4@syzkaller.appspotmail.com>
To:     davem@davemloft.net, fgheet255t@gmail.com, hdanton@sina.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        oliver@neukum.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    ea4424be1688 Merge tag 'mtd/fixes-for-5.17-rc8' of git://g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12c2811a700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=442f8ac61e60a75e
dashboard link: https://syzkaller.appspot.com/bug?extid=5ec3d1378e31c88d87f4
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13c97bbe700000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5ec3d1378e31c88d87f4@syzkaller.appspotmail.com

usb 1-1: USB disconnect, device number 2
cdc_ncm 1-1:1.0 usb0: unregister 'cdc_ncm' usb-dummy_hcd.0-1, CDC NCM
==================================================================
BUG: KASAN: use-after-free in __lock_acquire+0x3f2f/0x56c0 kernel/locking/lockdep.c:4897
Read of size 8 at addr ffff888018d2c8f0 by task kworker/1:4/3612

CPU: 1 PID: 3612 Comm: kworker/1:4 Not tainted 5.17.0-rc7-syzkaller-00020-gea4424be1688 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: usb_hub_wq hub_event
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description.constprop.0.cold+0x8d/0x336 mm/kasan/report.c:255
 __kasan_report mm/kasan/report.c:442 [inline]
 kasan_report.cold+0x83/0xdf mm/kasan/report.c:459
 __lock_acquire+0x3f2f/0x56c0 kernel/locking/lockdep.c:4897
 lock_acquire kernel/locking/lockdep.c:5639 [inline]
 lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5604
 __raw_spin_lock_bh include/linux/spinlock_api_smp.h:126 [inline]
 _raw_spin_lock_bh+0x2f/0x40 kernel/locking/spinlock.c:178
 spin_lock_bh include/linux/spinlock.h:354 [inline]
 cdc_ncm_tx_fixup+0x8f/0x120 drivers/net/usb/cdc_ncm.c:1527
 usbnet_start_xmit+0x152/0x1f70 drivers/net/usb/usbnet.c:1372
 __netdev_start_xmit include/linux/netdevice.h:4683 [inline]
 netdev_start_xmit include/linux/netdevice.h:4697 [inline]
 xmit_one net/core/dev.c:3473 [inline]
 dev_hard_start_xmit+0x1eb/0x920 net/core/dev.c:3489
 sch_direct_xmit+0x19f/0xbe0 net/sched/sch_generic.c:342
 __dev_xmit_skb net/core/dev.c:3700 [inline]
 __dev_queue_xmit+0x148f/0x37b0 net/core/dev.c:4081
 lapb_data_transmit+0x8f/0xc0 net/lapb/lapb_iface.c:447
 lapb_transmit_buffer+0x183/0x390 net/lapb/lapb_out.c:149
 lapb_send_control+0x1c7/0x370 net/lapb/lapb_subr.c:251
 __lapb_disconnect_request+0x127/0x1a0 net/lapb/lapb_iface.c:326
 lapb_device_event+0x292/0x560 net/lapb/lapb_iface.c:492
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:84
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1919
 call_netdevice_notifiers_extack net/core/dev.c:1931 [inline]
 call_netdevice_notifiers net/core/dev.c:1945 [inline]
 __dev_close_many+0xf1/0x2e0 net/core/dev.c:1465
 dev_close_many+0x22c/0x620 net/core/dev.c:1516
 dev_close net/core/dev.c:1542 [inline]
 dev_close+0x16d/0x210 net/core/dev.c:1536
 lapbeth_device_event+0x677/0xc00 drivers/net/wan/lapbether.c:462
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:84
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1919
 call_netdevice_notifiers_extack net/core/dev.c:1931 [inline]
 call_netdevice_notifiers net/core/dev.c:1945 [inline]
 __dev_close_many+0xf1/0x2e0 net/core/dev.c:1465
 dev_close_many+0x22c/0x620 net/core/dev.c:1516
 unregister_netdevice_many+0x3ff/0x18d0 net/core/dev.c:10392
 unregister_netdevice_queue net/core/dev.c:10349 [inline]
 unregister_netdevice_queue+0x2dd/0x3c0 net/core/dev.c:10339
 unregister_netdevice include/linux/netdevice.h:2902 [inline]
 unregister_netdev+0x18/0x20 net/core/dev.c:10474
 usbnet_disconnect+0x139/0x270 drivers/net/usb/usbnet.c:1623
 usb_unbind_interface+0x1d8/0x8e0 drivers/usb/core/driver.c:458
 __device_release_driver+0x627/0x760 drivers/base/dd.c:1209
 device_release_driver_internal drivers/base/dd.c:1242 [inline]
 device_release_driver+0x26/0x40 drivers/base/dd.c:1265
 bus_remove_device+0x2eb/0x5a0 drivers/base/bus.c:529
 device_del+0x4f3/0xc80 drivers/base/core.c:3592
 usb_disable_device+0x35b/0x7b0 drivers/usb/core/message.c:1419
 usb_disconnect.cold+0x27a/0x78e drivers/usb/core/hub.c:2228
 hub_port_connect drivers/usb/core/hub.c:5202 [inline]
 hub_port_connect_change drivers/usb/core/hub.c:5502 [inline]
 port_event drivers/usb/core/hub.c:5660 [inline]
 hub_event+0x1e39/0x44d0 drivers/usb/core/hub.c:5742
 process_one_work+0x9ac/0x1650 kernel/workqueue.c:2307
 worker_thread+0x657/0x1110 kernel/workqueue.c:2454
 kthread+0x2e9/0x3a0 kernel/kthread.c:377
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
 </TASK>

Allocated by task 3596:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:45 [inline]
 set_alloc_info mm/kasan/common.c:436 [inline]
 ____kasan_kmalloc mm/kasan/common.c:515 [inline]
 ____kasan_kmalloc mm/kasan/common.c:474 [inline]
 __kasan_kmalloc+0xa9/0xd0 mm/kasan/common.c:524
 kmalloc include/linux/slab.h:581 [inline]
 kzalloc include/linux/slab.h:714 [inline]
 cdc_ncm_bind_common+0xb8/0x2df0 drivers/net/usb/cdc_ncm.c:826
 cdc_ncm_bind+0x7c/0x1c0 drivers/net/usb/cdc_ncm.c:1069
 usbnet_probe+0xaf8/0x2580 drivers/net/usb/usbnet.c:1747
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

Freed by task 3612:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 kasan_set_track+0x21/0x30 mm/kasan/common.c:45
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:370
 ____kasan_slab_free mm/kasan/common.c:366 [inline]
 ____kasan_slab_free+0x126/0x160 mm/kasan/common.c:328
 kasan_slab_free include/linux/kasan.h:236 [inline]
 slab_free_hook mm/slub.c:1728 [inline]
 slab_free_freelist_hook+0x8b/0x1c0 mm/slub.c:1754
 slab_free mm/slub.c:3509 [inline]
 kfree+0xd0/0x390 mm/slub.c:4562
 cdc_ncm_free+0x145/0x1a0 drivers/net/usb/cdc_ncm.c:786
 cdc_ncm_unbind+0x1a7/0x340 drivers/net/usb/cdc_ncm.c:1021
 usbnet_disconnect+0x103/0x270 drivers/net/usb/usbnet.c:1620
 usb_unbind_interface+0x1d8/0x8e0 drivers/usb/core/driver.c:458
 __device_release_driver+0x627/0x760 drivers/base/dd.c:1209
 device_release_driver_internal drivers/base/dd.c:1242 [inline]
 device_release_driver+0x26/0x40 drivers/base/dd.c:1265
 bus_remove_device+0x2eb/0x5a0 drivers/base/bus.c:529
 device_del+0x4f3/0xc80 drivers/base/core.c:3592
 usb_disable_device+0x35b/0x7b0 drivers/usb/core/message.c:1419
 usb_disconnect.cold+0x27a/0x78e drivers/usb/core/hub.c:2228
 hub_port_connect drivers/usb/core/hub.c:5202 [inline]
 hub_port_connect_change drivers/usb/core/hub.c:5502 [inline]
 port_event drivers/usb/core/hub.c:5660 [inline]
 hub_event+0x1e39/0x44d0 drivers/usb/core/hub.c:5742
 process_one_work+0x9ac/0x1650 kernel/workqueue.c:2307
 worker_thread+0x657/0x1110 kernel/workqueue.c:2454
 kthread+0x2e9/0x3a0 kernel/kthread.c:377
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

The buggy address belongs to the object at ffff888018d2c800
 which belongs to the cache kmalloc-512 of size 512
The buggy address is located 240 bytes inside of
 512-byte region [ffff888018d2c800, ffff888018d2ca00)
The buggy address belongs to the page:
page:ffffea0000634b00 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x18d2c
head:ffffea0000634b00 order:2 compound_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 ffffea0000721d00 dead000000000002 ffff888010c41c80
raw: 0000000000000000 0000000000100010 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 2, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 472, ts 7097294333, free_ts 0
 prep_new_page mm/page_alloc.c:2434 [inline]
 get_page_from_freelist+0xa72/0x2f50 mm/page_alloc.c:4165
 __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5389
 alloc_pages+0x1aa/0x310 mm/mempolicy.c:2271
 alloc_slab_page mm/slub.c:1799 [inline]
 allocate_slab+0x27f/0x3c0 mm/slub.c:1944
 new_slab mm/slub.c:2004 [inline]
 ___slab_alloc+0xbe1/0x12b0 mm/slub.c:3018
 __slab_alloc.constprop.0+0x4d/0xa0 mm/slub.c:3105
 slab_alloc_node mm/slub.c:3196 [inline]
 slab_alloc mm/slub.c:3238 [inline]
 kmem_cache_alloc_trace+0x2f8/0x3d0 mm/slub.c:3255
 kmalloc include/linux/slab.h:581 [inline]
 kzalloc include/linux/slab.h:714 [inline]
 alloc_bprm+0x51/0x8f0 fs/exec.c:1507
 kernel_execve+0x55/0x460 fs/exec.c:1947
 call_usermodehelper_exec_async+0x2e3/0x580 kernel/umh.c:112
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
page_owner free stack trace missing

Memory state around the buggy address:
 ffff888018d2c780: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888018d2c800: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff888018d2c880: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                             ^
 ffff888018d2c900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888018d2c980: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================

