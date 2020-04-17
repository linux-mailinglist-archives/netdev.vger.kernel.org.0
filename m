Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 739231AE80B
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 00:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728724AbgDQWPQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 18:15:16 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:40399 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728706AbgDQWPQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 18:15:16 -0400
Received: by mail-il1-f198.google.com with SMTP id k5so4010686ilg.7
        for <netdev@vger.kernel.org>; Fri, 17 Apr 2020 15:15:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=WEcygz2yiTkhcSymwPQaWfTbOHv0m+f9utC1k92dGvI=;
        b=APhNV32RJZuVkKQwvK4Snjgs3XvoiHGPtWvrcn/JNXDFhQd1mVn29c0zahbZpYZoro
         jLuAUUVTEpk8rLUoMb/lWDYs+SgXex6dw58BrwmL1vSTJK2mAa/gR+JzE9GJhGFb+m4e
         B9hroazrcF3QqYqizakCFtVo05T1Lte6j1Adbwig0qplR0ine1xz76Iy2flMy+jInfkZ
         2irZ9JHuNkYWOrXyjlwjtUaJPgxvGv2wHRT0ZQ6V0l0Q7T0NdzUTMC+eUBT6qJbW0otY
         kwhdJ8WyzVZ1ctu01UnJjizCsrfKzVS0JKhjyGPDenvOg4B5RiknXs9ppFyh0pzNQrZ5
         780A==
X-Gm-Message-State: AGi0PuZCLUA8RB/FTO0vdkPRb2lek1cPQW+7Es4dM4FBOWCAUs06UyeY
        kFaI28vOW+rB10dsZjF01PZ3wL6pvb7k4dIliMMNK0uRIXm/
X-Google-Smtp-Source: APiQypLz91J++bbdaxnWO+tLXAVzyEHztNeUaUbTrzFAsi0kWHzaJJsszL47TVyJGvKnkGqeSqIa2qGqms/BCMpq2zimre8JILyu
MIME-Version: 1.0
X-Received: by 2002:a02:5184:: with SMTP id s126mr4928223jaa.81.1587161714629;
 Fri, 17 Apr 2020 15:15:14 -0700 (PDT)
Date:   Fri, 17 Apr 2020 15:15:14 -0700
In-Reply-To: <0000000000006ed82e05a1c05dcc@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000033a1e005a383e276@google.com>
Subject: Re: KASAN: use-after-free Read in hif_usb_regout_cb
From:   syzbot <syzbot+b894396e6110e1df38c4@syzkaller.appspotmail.com>
To:     andreyknvl@google.com, ath9k-devel@qca.qualcomm.com,
        davem@davemloft.net, efault@gmx.de, hdanton@sina.com,
        kvalo@codeaurora.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    0fa84af8 Merge tag 'usb-serial-5.7-rc1' of https://git.ker..
git tree:       https://github.com/google/kasan.git usb-fuzzer
console output: https://syzkaller.appspot.com/x/log.txt?x=160e64d7e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6b9c154b0c23aecf
dashboard link: https://syzkaller.appspot.com/bug?extid=b894396e6110e1df38c4
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=143956d7e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13dc3300100000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+b894396e6110e1df38c4@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in atomic_read include/asm-generic/atomic-instrumented.h:26 [inline]
BUG: KASAN: use-after-free in refcount_read include/linux/refcount.h:134 [inline]
BUG: KASAN: use-after-free in skb_unref include/linux/skbuff.h:1042 [inline]
BUG: KASAN: use-after-free in kfree_skb+0x32/0x3d0 net/core/skbuff.c:692
Read of size 4 at addr ffff8881d15fd854 by task swapper/1/0

CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.6.0-rc7-syzkaller #0
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
 __usb_hcd_giveback_urb+0x1f2/0x470 drivers/usb/core/hcd.c:1648
 usb_hcd_giveback_urb+0x368/0x420 drivers/usb/core/hcd.c:1713
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
Code: cc cc 41 56 41 55 65 44 8b 2d 44 eb 71 7a 41 54 55 53 0f 1f 44 00 00 e8 f6 d7 b4 fb e9 07 00 00 00 0f 00 2d aa 7c 52 00 fb f4 <65> 44 8b 2d 20 eb 71 7a 0f 1f 44 00 00 5b 5d 41 5c 41 5d 41 5e c3
RSP: 0018:ffff8881da22fda8 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
RAX: 0000000000000007 RBX: ffff8881da213100 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000006 RDI: ffff8881da21394c
RBP: ffffed103b442620 R08: ffff8881da213100 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
R13: 0000000000000001 R14: ffffffff87e629c0 R15: 0000000000000000
 cpuidle_idle_call kernel/sched/idle.c:154 [inline]
 do_idle+0x3e0/0x500 kernel/sched/idle.c:269
 cpu_startup_entry+0x14/0x20 kernel/sched/idle.c:361
 start_secondary+0x2a4/0x390 arch/x86/kernel/smpboot.c:264
 secondary_startup_64+0xb6/0xc0 arch/x86/kernel/head_64.S:242

Allocated by task 21:
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
 ath9k_hif_usb_firmware_cb+0x26b/0x500 drivers/net/wireless/ath/ath9k/hif_usb.c:1187
 request_firmware_work_func+0x126/0x242 drivers/base/firmware_loader/main.c:976
 process_one_work+0x94b/0x1620 kernel/workqueue.c:2266
 worker_thread+0x96/0xe20 kernel/workqueue.c:2412
 kthread+0x318/0x420 kernel/kthread.c:255
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

Freed by task 21:
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
 htc_connect_service.cold+0xa9/0x109 drivers/net/wireless/ath/ath9k/htc_hst.c:282
 ath9k_wmi_connect+0xd2/0x1a0 drivers/net/wireless/ath/ath9k/wmi.c:265
 ath9k_init_htc_services.constprop.0+0xb4/0x650 drivers/net/wireless/ath/ath9k/htc_drv_init.c:146
 ath9k_htc_probe_device+0x25a/0x1d80 drivers/net/wireless/ath/ath9k/htc_drv_init.c:959
 ath9k_htc_hw_init+0x31/0x60 drivers/net/wireless/ath/ath9k/htc_hst.c:501
 ath9k_hif_usb_firmware_cb+0x26b/0x500 drivers/net/wireless/ath/ath9k/hif_usb.c:1187
 request_firmware_work_func+0x126/0x242 drivers/base/firmware_loader/main.c:976
 process_one_work+0x94b/0x1620 kernel/workqueue.c:2266
 worker_thread+0x96/0xe20 kernel/workqueue.c:2412
 kthread+0x318/0x420 kernel/kthread.c:255
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

The buggy address belongs to the object at ffff8881d15fd780
 which belongs to the cache skbuff_head_cache of size 224
The buggy address is located 212 bytes inside of
 224-byte region [ffff8881d15fd780, ffff8881d15fd860)
The buggy address belongs to the page:
page:ffffea0007457f40 refcount:1 mapcount:0 mapping:ffff8881da16b400 index:0x0
flags: 0x200000000000200(slab)
raw: 0200000000000200 0000000000000000 0000000300000001 ffff8881da16b400
raw: 0000000000000000 00000000800c000c 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8881d15fd700: fb fb fb fb fc fc fc fc fc fc fc fc fc fc fc fc
 ffff8881d15fd780: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff8881d15fd800: fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
                                                 ^
 ffff8881d15fd880: fc fc fc fc fc fc fc fc fb fb fb fb fb fb fb fb
 ffff8881d15fd900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================

