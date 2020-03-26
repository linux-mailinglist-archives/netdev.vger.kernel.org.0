Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00A53193DEC
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 12:34:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728207AbgCZLeT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 07:34:19 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:36827 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728184AbgCZLeR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 07:34:17 -0400
Received: by mail-io1-f69.google.com with SMTP id s66so4955482iod.3
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 04:34:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=BgKOq3H9BEvgLZAZAQip00Xcj5s1SgZehy0YOxU7Jn0=;
        b=NE8Oaq8zGva/PWodwCNj4H/IipxOc+y329ft3QwcBFDp9OR6X3tPrGkLvt8Tcn/iPK
         r62FUgry0iaLwEgnQYYlP6AJWHggh9o+LVvXpyjCHYMxcGDVuPe1oBokw1WIn7+A3y5l
         xEDdE5enVc93DCHKpxISPGS6jSQmuFrpzjaxR0CERqHUY613I5mlolA8ySqU4PCWtMfx
         we/6fTou3wDTkJ3F/XNdBA+eUvgpexO19IyGgJs/Fe+SE2xLRmJDM4c5gfH2ROTWUdXo
         F2HD8UCGzuSeskFw3Ue2qR/zMqNaQo/djVWSW0zwcKIrYmMj9pE8j3YqpO8gUtYws6TW
         3bzQ==
X-Gm-Message-State: ANhLgQ17boNx2h3y/I8rsZsekpBkmTmD5sFsQ3JBH6x/neosV7XX/kC0
        K4JMIzf3BsOW20m7clgADWdbtAZyhb8wTP7TgvnCcCvrO8pQ
X-Google-Smtp-Source: ADFU+vssIXEZ6FnGiHgKbGTRjOPnSeFippDtodh5E3Rhn9EaLX+zMNc0IvHv6U2HPdHzaok1dxnD+pPafTYOnSeK4ve9fpAkVGU1
MIME-Version: 1.0
X-Received: by 2002:a02:390b:: with SMTP id l11mr7275488jaa.111.1585222456889;
 Thu, 26 Mar 2020 04:34:16 -0700 (PDT)
Date:   Thu, 26 Mar 2020 04:34:16 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006ed82e05a1c05dcc@google.com>
Subject: KASAN: use-after-free Read in hif_usb_regout_cb
From:   syzbot <syzbot+b894396e6110e1df38c4@syzkaller.appspotmail.com>
To:     andreyknvl@google.com, ath9k-devel@qca.qualcomm.com,
        davem@davemloft.net, kvalo@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    e17994d1 usb: core: kcov: collect coverage from usb comple..
git tree:       https://github.com/google/kasan.git usb-fuzzer
console output: https://syzkaller.appspot.com/x/log.txt?x=13ee4d4be00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5d64370c438bc60
dashboard link: https://syzkaller.appspot.com/bug?extid=b894396e6110e1df38c4
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+b894396e6110e1df38c4@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in atomic_read include/asm-generic/atomic-instrumented.h:26 [inline]
BUG: KASAN: use-after-free in refcount_read include/linux/refcount.h:134 [inline]
BUG: KASAN: use-after-free in skb_unref include/linux/skbuff.h:1042 [inline]
BUG: KASAN: use-after-free in kfree_skb+0x32/0x3d0 net/core/skbuff.c:692
Read of size 4 at addr ffff8881d6816494 by task swapper/0/0

CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.6.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
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
 hif_usb_regout_cb+0x14c/0x1b0 drivers/net/wireless/ath/ath9k/hif_usb.c:97
 __usb_hcd_giveback_urb+0x29a/0x550 drivers/usb/core/hcd.c:1650
 usb_hcd_giveback_urb+0x368/0x420 drivers/usb/core/hcd.c:1716
 dummy_timer+0x1258/0x32ae drivers/usb/gadget/udc/dummy_hcd.c:1966
 call_timer_fn+0x195/0x6f0 kernel/time/timer.c:1404
 expire_timers kernel/time/timer.c:1449 [inline]
 __run_timers kernel/time/timer.c:1773 [inline]
 __run_timers kernel/time/timer.c:1740 [inline]
 run_timer_softirq+0x5f9/0x1500 kernel/time/timer.c:1786
 __do_softirq+0x21e/0x950 kernel/softirq.c:292
 invoke_softirq kernel/softirq.c:373 [inline]
 irq_exit+0x178/0x1a0 kernel/softirq.c:413
 exiting_irq arch/x86/include/asm/apic.h:546 [inline]
 smp_apic_timer_interrupt+0x141/0x540 arch/x86/kernel/apic/apic.c:1146
 apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:829
 </IRQ>
RIP: 0010:default_idle+0x28/0x300 arch/x86/kernel/process.c:696
Code: cc cc 41 56 41 55 65 44 8b 2d 44 77 72 7a 41 54 55 53 0f 1f 44 00 00 e8 b6 62 b5 fb e9 07 00 00 00 0f 00 2d ea 0c 53 00 fb f4 <65> 44 8b 2d 20 77 72 7a 0f 1f 44 00 00 5b 5d 41 5c 41 5d 41 5e c3
RSP: 0018:ffffffff87007d80 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
RAX: 0000000000000007 RBX: ffffffff8702cc40 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000006 RDI: ffffffff8702d48c
RBP: fffffbfff0e05988 R08: ffffffff8702cc40 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: ffffffff87e607c0 R15: 0000000000000000
 cpuidle_idle_call kernel/sched/idle.c:154 [inline]
 do_idle+0x3e0/0x500 kernel/sched/idle.c:269
 cpu_startup_entry+0x14/0x20 kernel/sched/idle.c:361
 start_kernel+0xe16/0xe5a init/main.c:998
 secondary_startup_64+0xb6/0xc0 arch/x86/kernel/head_64.S:242

Allocated by task 3135:
 save_stack+0x1b/0x80 mm/kasan/common.c:72
 set_track mm/kasan/common.c:80 [inline]
 __kasan_kmalloc mm/kasan/common.c:515 [inline]
 __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:488
 slab_post_alloc_hook mm/slab.h:584 [inline]
 slab_alloc_node mm/slub.c:2778 [inline]
 kmem_cache_alloc_node+0xdc/0x330 mm/slub.c:2814
 __alloc_skb+0xba/0x5a0 net/core/skbuff.c:198
 alloc_skb include/linux/skbuff.h:1081 [inline]
 htc_connect_service+0x2cc/0x840 drivers/net/wireless/ath/ath9k/htc_hst.c:257
 ath9k_wmi_connect+0xd2/0x1a0 drivers/net/wireless/ath/ath9k/wmi.c:265
 ath9k_init_htc_services.constprop.0+0xb4/0x650 drivers/net/wireless/ath/ath9k/htc_drv_init.c:146
 ath9k_htc_probe_device+0x25a/0x1d80 drivers/net/wireless/ath/ath9k/htc_drv_init.c:959
 ath9k_htc_hw_init+0x31/0x60 drivers/net/wireless/ath/ath9k/htc_hst.c:501
 ath9k_hif_usb_firmware_cb+0x26b/0x500 drivers/net/wireless/ath/ath9k/hif_usb.c:1187
 request_firmware_work_func+0x126/0x242 drivers/base/firmware_loader/main.c:976
 process_one_work+0x94b/0x1620 kernel/workqueue.c:2264
 worker_thread+0x96/0xe20 kernel/workqueue.c:2410
 kthread+0x318/0x420 kernel/kthread.c:255
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

Freed by task 3135:
 save_stack+0x1b/0x80 mm/kasan/common.c:72
 set_track mm/kasan/common.c:80 [inline]
 kasan_set_free_info mm/kasan/common.c:337 [inline]
 __kasan_slab_free+0x117/0x160 mm/kasan/common.c:476
 slab_free_hook mm/slub.c:1444 [inline]
 slab_free_freelist_hook mm/slub.c:1477 [inline]
 slab_free mm/slub.c:3024 [inline]
 kmem_cache_free+0x9b/0x360 mm/slub.c:3040
 kfree_skbmem net/core/skbuff.c:622 [inline]
 kfree_skbmem+0xef/0x1b0 net/core/skbuff.c:616
 __kfree_skb net/core/skbuff.c:679 [inline]
 kfree_skb net/core/skbuff.c:696 [inline]
 kfree_skb+0x102/0x3d0 net/core/skbuff.c:690
 htc_connect_service.cold+0xa9/0x109 drivers/net/wireless/ath/ath9k/htc_hst.c:282
 ath9k_wmi_connect+0xd2/0x1a0 drivers/net/wireless/ath/ath9k/wmi.c:265
 ath9k_init_htc_services.constprop.0+0xb4/0x650 drivers/net/wireless/ath/ath9k/htc_drv_init.c:146
 ath9k_htc_probe_device+0x25a/0x1d80 drivers/net/wireless/ath/ath9k/htc_drv_init.c:959
 ath9k_htc_hw_init+0x31/0x60 drivers/net/wireless/ath/ath9k/htc_hst.c:501
 ath9k_hif_usb_firmware_cb+0x26b/0x500 drivers/net/wireless/ath/ath9k/hif_usb.c:1187
 request_firmware_work_func+0x126/0x242 drivers/base/firmware_loader/main.c:976
 process_one_work+0x94b/0x1620 kernel/workqueue.c:2264
 worker_thread+0x96/0xe20 kernel/workqueue.c:2410
 kthread+0x318/0x420 kernel/kthread.c:255
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

The buggy address belongs to the object at ffff8881d68163c0
 which belongs to the cache skbuff_head_cache of size 224
The buggy address is located 212 bytes inside of
 224-byte region [ffff8881d68163c0, ffff8881d68164a0)
The buggy address belongs to the page:
page:ffffea00075a0580 refcount:1 mapcount:0 mapping:ffff8881da16b400 index:0x0
flags: 0x200000000000200(slab)
raw: 0200000000000200 ffffea00072b75c0 0000000300000002 ffff8881da16b400
raw: 0000000000000000 00000000000c000c 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8881d6816380: fc fc fc fc fc fc fc fc fb fb fb fb fb fb fb fb
 ffff8881d6816400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff8881d6816480: fb fb fb fb fc fc fc fc fc fc fc fc fc fc fc fc
                         ^
 ffff8881d6816500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8881d6816580: fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
