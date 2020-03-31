Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01584198A58
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 05:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729792AbgCaDIE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 23:08:04 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:46522 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727655AbgCaDIE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 23:08:04 -0400
Received: by mail-il1-f197.google.com with SMTP id n18so18208364ilp.13
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 20:08:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=+5vcJYsrFacweEz4W6ftdXhQocE2JVm+UGuLAzgpEEs=;
        b=GyZG6y3ohwvBikWiOB9bR5cu7VORXjGVabfwGo0L4Scjmxd6yAruC1S6vpSeOlleBl
         Tn3oo+FGjETWSHzbTijLbGJdz6E2U9VHQSF+evBCMI4lS4kjYUpNumcbIp+Jm7koHbKH
         M+Pt4FLaij3ORxUEACPGQxDZ4ZEMGdsR4P6Uy5Qt5jESkR9nV6RdW/9agTl7kdWJ1eFh
         e17ZqDodsVBUN6WskU3ummEpA5vrCJtEjFA84dMl2Gy8WVZ6zJoNav01Tar7zzf8n0o/
         nyJdy/pFYpLmTR6b2vzVhLBHm4Zw2nxaqAXJX5R5ir5id1AZY9DDP6FwQ3wsJj1KcOPe
         h/Cw==
X-Gm-Message-State: ANhLgQ2LcHKI0GKSvYdoqPRcv9YywbdbZmcLwws6EdwAWqA89GBezBpZ
        4H0mNhoKBipeFtD5tBgv3MhCyuxL07HiBU5tB8Ne8nUoJyyb
X-Google-Smtp-Source: ADFU+vursDUTX1at0nNsVGNHqQuQmAA/uLz3ggv9YCyfGdWalwmRvpK1HXfMd+zmV0YdW2uWdLm9tKL/ahe0XrSjF8EzhRViZ7tO
MIME-Version: 1.0
X-Received: by 2002:a6b:8dc9:: with SMTP id p192mr12873614iod.90.1585624082745;
 Mon, 30 Mar 2020 20:08:02 -0700 (PDT)
Date:   Mon, 30 Mar 2020 20:08:02 -0700
In-Reply-To: <CADG63jBgKXORSXV8zs_6QETgRGsNMOvJ8nBRn1itEjrZv5f+dA@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003313e805a21de06e@google.com>
Subject: Re: KASAN: stack-out-of-bounds Write in ath9k_hif_usb_rx_cb
From:   syzbot <syzbot+d403396d4df67ad0bd5f@syzkaller.appspotmail.com>
To:     andreyknvl@google.com, anenbupt@gmail.com,
        ath9k-devel@qca.qualcomm.com, davem@davemloft.net,
        kvalo@codeaurora.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot has tested the proposed patch but the reproducer still triggered crash:
KASAN: use-after-free Read in htc_connect_service

usb 4-1: Service connection timeout for: 256
==================================================================
BUG: KASAN: use-after-free in atomic_read include/asm-generic/atomic-instrumented.h:26 [inline]
BUG: KASAN: use-after-free in refcount_read include/linux/refcount.h:134 [inline]
BUG: KASAN: use-after-free in skb_unref include/linux/skbuff.h:1042 [inline]
BUG: KASAN: use-after-free in kfree_skb+0x32/0x3d0 net/core/skbuff.c:692
Read of size 4 at addr ffff8881c7ec2d54 by task kworker/0:5/3237

CPU: 0 PID: 3237 Comm: kworker/0:5 Not tainted 5.6.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events request_firmware_work_func
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0xef/0x16e lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xd3/0x314 mm/kasan/report.c:374
 __kasan_report.cold+0x37/0x77 mm/kasan/report.c:506
 kasan_report+0xe/0x20 mm/kasan/common.c:641
 check_memory_region_inline mm/kasan/generic.c:185 [inline]
 check_memory_region+0x152/0x1c0 mm/kasan/generic.c:192
 atomic_read include/asm-generic/atomic-instrumented.h:26 [inline]
 refcount_read include/linux/refcount.h:134 [inline]
 skb_unref include/linux/skbuff.h:1042 [inline]
 kfree_skb+0x32/0x3d0 net/core/skbuff.c:692
 htc_connect_service.cold+0xa9/0x109 drivers/net/wireless/ath/ath9k/htc_hst.c:282
 ath9k_wmi_connect+0xd2/0x1a0 drivers/net/wireless/ath/ath9k/wmi.c:265
 ath9k_init_htc_services.constprop.0+0xb4/0x650 drivers/net/wireless/ath/ath9k/htc_drv_init.c:146
 ath9k_htc_probe_device+0x25a/0x1d80 drivers/net/wireless/ath/ath9k/htc_drv_init.c:959
 ath9k_htc_hw_init+0x31/0x60 drivers/net/wireless/ath/ath9k/htc_hst.c:501
 ath9k_hif_usb_firmware_cb+0x26b/0x500 drivers/net/wireless/ath/ath9k/hif_usb.c:1192
 request_firmware_work_func+0x126/0x242 drivers/base/firmware_loader/main.c:976
 process_one_work+0x94b/0x1620 kernel/workqueue.c:2266
 worker_thread+0x96/0xe20 kernel/workqueue.c:2412
 kthread+0x318/0x420 kernel/kthread.c:255
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

Allocated by task 3237:
 save_stack+0x1b/0x80 mm/kasan/common.c:72
 set_track mm/kasan/common.c:80 [inline]
 __kasan_kmalloc mm/kasan/common.c:515 [inline]
 __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:488
 slab_post_alloc_hook mm/slab.h:584 [inline]
 slab_alloc_node mm/slub.c:2786 [inline]
 kmem_cache_alloc_node+0xdc/0x330 mm/slub.c:2822
 __alloc_skb+0xba/0x5a0 net/core/skbuff.c:198
 alloc_skb include/linux/skbuff.h:1081 [inline]
 htc_connect_service+0x2cc/0x840 drivers/net/wireless/ath/ath9k/htc_hst.c:257
 ath9k_wmi_connect+0xd2/0x1a0 drivers/net/wireless/ath/ath9k/wmi.c:265
 ath9k_init_htc_services.constprop.0+0xb4/0x650 drivers/net/wireless/ath/ath9k/htc_drv_init.c:146
 ath9k_htc_probe_device+0x25a/0x1d80 drivers/net/wireless/ath/ath9k/htc_drv_init.c:959
 ath9k_htc_hw_init+0x31/0x60 drivers/net/wireless/ath/ath9k/htc_hst.c:501
 ath9k_hif_usb_firmware_cb+0x26b/0x500 drivers/net/wireless/ath/ath9k/hif_usb.c:1192
 request_firmware_work_func+0x126/0x242 drivers/base/firmware_loader/main.c:976
 process_one_work+0x94b/0x1620 kernel/workqueue.c:2266
 worker_thread+0x96/0xe20 kernel/workqueue.c:2412
 kthread+0x318/0x420 kernel/kthread.c:255
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

Freed by task 0:
 save_stack+0x1b/0x80 mm/kasan/common.c:72
 set_track mm/kasan/common.c:80 [inline]
 kasan_set_free_info mm/kasan/common.c:337 [inline]
 __kasan_slab_free+0x117/0x160 mm/kasan/common.c:476
 slab_free_hook mm/slub.c:1444 [inline]
 slab_free_freelist_hook mm/slub.c:1477 [inline]
 slab_free mm/slub.c:3034 [inline]
 kmem_cache_free+0x9b/0x360 mm/slub.c:3050
 kfree_skbmem net/core/skbuff.c:622 [inline]
 kfree_skbmem+0xef/0x1b0 net/core/skbuff.c:616
 __kfree_skb net/core/skbuff.c:679 [inline]
 kfree_skb net/core/skbuff.c:696 [inline]
 kfree_skb+0x102/0x3d0 net/core/skbuff.c:690
 ath9k_htc_txcompletion_cb+0x1f8/0x2b0 drivers/net/wireless/ath/ath9k/htc_hst.c:356
 hif_usb_regout_cb+0x10b/0x1b0 drivers/net/wireless/ath/ath9k/hif_usb.c:90
 __usb_hcd_giveback_urb+0x1f2/0x470 drivers/usb/core/hcd.c:1648
 usb_hcd_giveback_urb+0x368/0x420 drivers/usb/core/hcd.c:1713
 dummy_timer+0x1258/0x32ae drivers/usb/gadget/udc/dummy_hcd.c:1966
 call_timer_fn+0x195/0x6f0 kernel/time/timer.c:1404
 expire_timers kernel/time/timer.c:1449 [inline]
 __run_timers kernel/time/timer.c:1773 [inline]
 __run_timers kernel/time/timer.c:1740 [inline]
 run_timer_softirq+0x5f9/0x1500 kernel/time/timer.c:1786
 __do_softirq+0x21e/0x950 kernel/softirq.c:292

The buggy address belongs to the object at ffff8881c7ec2c80
 which belongs to the cache skbuff_head_cache of size 224
The buggy address is located 212 bytes inside of
 224-byte region [ffff8881c7ec2c80, ffff8881c7ec2d60)
The buggy address belongs to the page:
page:ffffea00071fb080 refcount:1 mapcount:0 mapping:ffff8881da16b400 index:0x0
flags: 0x200000000000200(slab)
raw: 0200000000000200 dead000000000100 dead000000000122 ffff8881da16b400
raw: 0000000000000000 00000000000c000c 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8881c7ec2c00: fb fb fb fb fc fc fc fc fc fc fc fc fc fc fc fc
 ffff8881c7ec2c80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff8881c7ec2d00: fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
                                                 ^
 ffff8881c7ec2d80: fc fc fc fc fc fc fc fc fb fb fb fb fb fb fb fb
 ffff8881c7ec2e00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


Tested on:

commit:         0fa84af8 Merge tag 'usb-serial-5.7-rc1' of https://git.ker..
git tree:       https://github.com/google/kasan.git usb-fuzzer
console output: https://syzkaller.appspot.com/x/log.txt?x=17c2dadbe00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a782c087b1f425c6
dashboard link: https://syzkaller.appspot.com/bug?extid=d403396d4df67ad0bd5f
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
patch:          https://syzkaller.appspot.com/x/patch.diff?x=14b7b40be00000

