Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91CA42EAF8E
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 17:04:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728020AbhAEQEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 11:04:05 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:54174 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727336AbhAEQEE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 11:04:04 -0500
Received: by mail-io1-f72.google.com with SMTP id l20so14215750ioc.20
        for <netdev@vger.kernel.org>; Tue, 05 Jan 2021 08:03:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=qhP1/755q7WDrN0YK6Iv3mpn5+0OMvA+SZKVkiP59fw=;
        b=Zo3d4/ZUF7kVgeY60f/GQeKSh8XJTes+pN8nb6lo0jGdFEbUUWI7qNx4ojt1UFyzRe
         WHBiBwZiz01DG0h7SxkeAbPYhEQ+Pp6tVPSR8sFMF4JGTM7ar2d7oltWAMUpXfXGA4HI
         bSm2b+yXQh2BNK1NBF0ZXbFlzI2k3IGrqIh2hRat/zIbTiOxd7ZvOiZ61fZXaS09PuQS
         UfPromtIKbhTnp/ASGYOsu67y5PnTr7lnHrjWuwYZUFWwBQ5arfjDhIE1x/O2HPszPZp
         XtGbMsKG79MkOGa/1F1rY0uYsHV6Lcul/uvfpPN86KIexbgcO1gsGt1kjZyu/AbzGPVY
         HvdA==
X-Gm-Message-State: AOAM5324/OHWoZ6yqPGWKlceiBVIgOTrTHVfp68jALux1WqrxnoTR5Jw
        UUoxo5BVqjK0pWEyXwow9STpGeocs/2jEjfcCQ0i+hd6xXSX
X-Google-Smtp-Source: ABdhPJwiwuT5zmbUev1hNz5Yf6j2VYcn8y5FPKz3gM/wH1xDwdUa6TyNoff07+4iLe322hjQ0enIWxEALLItMegvxHio8XNFrKm8
MIME-Version: 1.0
X-Received: by 2002:a92:b652:: with SMTP id s79mr264085ili.251.1609862603502;
 Tue, 05 Jan 2021 08:03:23 -0800 (PST)
Date:   Tue, 05 Jan 2021 08:03:23 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009e7a1905b8295829@google.com>
Subject: KASAN: out-of-bounds Read in ath9k_hif_usb_rx_cb (3)
From:   syzbot <syzbot+3f1ca6a6fec34d601788@syzkaller.appspotmail.com>
To:     andreyknvl@google.com, ath9k-devel@qca.qualcomm.com,
        davem@davemloft.net, kuba@kernel.org, kvalo@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    3644e2d2 mm/filemap: fix infinite loop in generic_file_buf..
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git usb-testing
console output: https://syzkaller.appspot.com/x/log.txt?x=1669d8c5500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ff698e602d15ad28
dashboard link: https://syzkaller.appspot.com/bug?extid=3f1ca6a6fec34d601788
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3f1ca6a6fec34d601788@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: out-of-bounds in ath9k_hif_usb_rx_stream drivers/net/wireless/ath/ath9k/hif_usb.c:636 [inline]
BUG: KASAN: out-of-bounds in ath9k_hif_usb_rx_cb+0xdab/0x1020 drivers/net/wireless/ath/ath9k/hif_usb.c:680
Read of size 4 at addr ffff888112be40b8 by task systemd-journal/2634

CPU: 0 PID: 2634 Comm: systemd-journal Not tainted 5.10.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:120
 print_address_description.constprop.0.cold+0xae/0x4c8 mm/kasan/report.c:385
 __kasan_report mm/kasan/report.c:545 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:562
 ath9k_hif_usb_rx_stream drivers/net/wireless/ath/ath9k/hif_usb.c:636 [inline]
 ath9k_hif_usb_rx_cb+0xdab/0x1020 drivers/net/wireless/ath/ath9k/hif_usb.c:680
 __usb_hcd_giveback_urb+0x2b0/0x5c0 drivers/usb/core/hcd.c:1657
 usb_hcd_giveback_urb+0x38c/0x430 drivers/usb/core/hcd.c:1728
 dummy_timer+0x11f4/0x32a0 drivers/usb/gadget/udc/dummy_hcd.c:1971
 call_timer_fn+0x1a5/0x690 kernel/time/timer.c:1417
 expire_timers kernel/time/timer.c:1462 [inline]
 __run_timers.part.0+0x692/0xa50 kernel/time/timer.c:1731
 __run_timers kernel/time/timer.c:1712 [inline]
 run_timer_softirq+0x80/0x120 kernel/time/timer.c:1744
 __do_softirq+0x1b7/0x9c5 kernel/softirq.c:343
 asm_call_irq_on_stack+0xf/0x20
 </IRQ>
 __run_on_irqstack arch/x86/include/asm/irq_stack.h:26 [inline]
 run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:77 [inline]
 do_softirq_own_stack+0x80/0xa0 arch/x86/kernel/irq_64.c:77
 invoke_softirq kernel/softirq.c:226 [inline]
 __irq_exit_rcu+0x119/0x1b0 kernel/softirq.c:420
 irq_exit_rcu+0x5/0x10 kernel/softirq.c:432
 sysvec_apic_timer_interrupt+0x43/0xa0 arch/x86/kernel/apic/apic.c:1096
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:628
RIP: 0010:devkmsg_read+0x3df/0x750 kernel/printk/printk.c:754
Code: 01 80 3c 02 00 0f 85 19 03 00 00 48 c7 c7 c0 95 66 87 4c 89 6d 00 e8 00 0d 97 04 e8 0b 4b 00 00 e8 b6 4e 1c 00 fb 48 8b 2c 24 <4c> 89 ff 48 c7 c3 ea ff ff ff 48 89 ee e8 df 96 16 00 49 39 ef 77
RSP: 0018:ffffc90000247d68 EFLAGS: 00000202
RAX: 0000000001f89e25 RBX: ffff88810ef320f8 RCX: ffffffff8126e037
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff8129b43a
RBP: 0000000000002000 R08: 0000000000000001 R09: ffffffff8a02c65f
R10: fffffbfff14058cb R11: 000000000000005c R12: 1ffff92000048fb2
R13: 000000000000ab98 R14: ffff88810ef30068 R15: 000000000000009a
 vfs_read+0x1b5/0x570 fs/read_write.c:494
 ksys_read+0x12d/0x250 fs/read_write.c:634
 do_syscall_64+0x2d/0x40 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7ffbb8d4f210
Code: 73 01 c3 48 8b 0d 98 7d 20 00 f7 d8 64 89 01 48 83 c8 ff c3 66 0f 1f 44 00 00 83 3d b9 c1 20 00 00 75 10 b8 00 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 31 c3 48 83 ec 08 e8 4e fc ff ff 48 89 04 24
RSP: 002b:00007ffdc194c458 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
RAX: ffffffffffffffda RBX: 00007ffdc194eed0 RCX: 00007ffbb8d4f210
RDX: 0000000000002000 RSI: 00007ffdc194ccd0 RDI: 0000000000000009
RBP: 0000000000000000 R08: 0000000000000008 R09: 00007ffdc19c20f0
R10: 000000000002c96e R11: 0000000000000246 R12: 00007ffdc194ccd0
R13: 00007ffdc194ee28 R14: 00005646a13bb958 R15: 0005b6f3706fc2a9

Allocated by task 31546:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc.constprop.0+0xc2/0xd0 mm/kasan/common.c:461
 slab_post_alloc_hook mm/slab.h:512 [inline]
 slab_alloc_node mm/slub.c:2889 [inline]
 __kmalloc_node_track_caller+0x1a2/0x340 mm/slub.c:4493
 __kmalloc_reserve net/core/skbuff.c:142 [inline]
 __alloc_skb+0xae/0x5c0 net/core/skbuff.c:210
 __netdev_alloc_skb+0x6b/0x3b0 net/core/skbuff.c:442
 netdev_alloc_skb include/linux/skbuff.h:2831 [inline]
 dev_alloc_skb include/linux/skbuff.h:2844 [inline]
 ath6kl_usb_post_recv_transfers.constprop.0+0x55/0x400 drivers/net/wireless/ath/ath6kl/usb.c:422
 ath6kl_usb_start_recv_pipes drivers/net/wireless/ath/ath6kl/usb.c:492 [inline]
 hif_start drivers/net/wireless/ath/ath6kl/usb.c:690 [inline]
 ath6kl_usb_power_on+0x8a/0x150 drivers/net/wireless/ath/ath6kl/usb.c:1049
 ath6kl_hif_power_on drivers/net/wireless/ath/ath6kl/hif-ops.h:136 [inline]
 ath6kl_core_init drivers/net/wireless/ath/ath6kl/core.c:97 [inline]
 ath6kl_core_init+0x1ae/0x1170 drivers/net/wireless/ath/ath6kl/core.c:66
 ath6kl_usb_probe+0xc3d/0x11f0 drivers/net/wireless/ath/ath6kl/usb.c:1155
 usb_probe_interface+0x315/0x7f0 drivers/usb/core/driver.c:396
 really_probe+0x2b1/0xe40 drivers/base/dd.c:561
 driver_probe_device+0x285/0x3f0 drivers/base/dd.c:745
 __device_attach_driver+0x216/0x2d0 drivers/base/dd.c:851
 bus_for_each_drv+0x15f/0x1e0 drivers/base/bus.c:431
 __device_attach+0x228/0x4c0 drivers/base/dd.c:919
 bus_probe_device+0x1e4/0x290 drivers/base/bus.c:491
 device_add+0xbc4/0x1d90 drivers/base/core.c:3091
 usb_set_configuration+0x113c/0x1910 drivers/usb/core/message.c:2164
 usb_generic_driver_probe+0xba/0x100 drivers/usb/core/generic.c:238
 usb_probe_device+0xd9/0x2c0 drivers/usb/core/driver.c:293
 really_probe+0x2b1/0xe40 drivers/base/dd.c:561
 driver_probe_device+0x285/0x3f0 drivers/base/dd.c:745
 __device_attach_driver+0x216/0x2d0 drivers/base/dd.c:851
 bus_for_each_drv+0x15f/0x1e0 drivers/base/bus.c:431
 __device_attach+0x228/0x4c0 drivers/base/dd.c:919
 bus_probe_device+0x1e4/0x290 drivers/base/bus.c:491
 device_add+0xbc4/0x1d90 drivers/base/core.c:3091
 usb_new_device.cold+0x725/0x1057 drivers/usb/core/hub.c:2555
 hub_port_connect drivers/usb/core/hub.c:5223 [inline]
 hub_port_connect_change drivers/usb/core/hub.c:5363 [inline]
 port_event drivers/usb/core/hub.c:5509 [inline]
 hub_event+0x2348/0x42d0 drivers/usb/core/hub.c:5591
 process_one_work+0x98d/0x15c0 kernel/workqueue.c:2275
 process_scheduled_works kernel/workqueue.c:2337 [inline]
 worker_thread+0x82b/0x1120 kernel/workqueue.c:2423
 kthread+0x38c/0x460 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296

The buggy address belongs to the object at ffff888112be4000
 which belongs to the cache kmalloc-8k of size 8192
The buggy address is located 184 bytes inside of
 8192-byte region [ffff888112be4000, ffff888112be6000)
The buggy address belongs to the page:
page:0000000066b7dcb8 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x112be0
head:0000000066b7dcb8 order:3 compound_mapcount:0 compound_pincount:0
flags: 0x200000000010200(slab|head)
raw: 0200000000010200 dead000000000100 dead000000000122 ffff888100042280
raw: 0000000000000000 0000000000020002 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff888112be3f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888112be4000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff888112be4080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                                        ^
 ffff888112be4100: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff888112be4180: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
