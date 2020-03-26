Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFD63193E00
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 12:34:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728173AbgCZLeR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 07:34:17 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:33782 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727953AbgCZLeQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 07:34:16 -0400
Received: by mail-io1-f71.google.com with SMTP id w25so4941328iom.0
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 04:34:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=ekOt4BXavtliJmZUL8YzGKrknOJ5quWo6FGWsgR2OP8=;
        b=nSLw72iHOPXRufYEI164QyJAnBx7tx8+3hFyeP580/pBDN0QYA476ecBP2rsw9y5vf
         JvJn+LsQiSKoFJOYGndAyBhLUs4jWXIuE6uurshTBvapwhCPBMooluC4evA2eSpC8Qz/
         d5B+U+UCjCquXYVpUv72r6o64Kkq8RsrDGDOqkSHhK5vWEAHaAyf1pPdimnmcNo8ZW/4
         BjmBehMVbTAXUS1rlzKC+7T2869SG6nqRvCLr8vCUF5gnsKdkh8NeRc7D0GduwM/4hSM
         cxjERM6IvIbR4ME70T8UgECuuZ8NbWj9ps44lYqlJFZTWL/xYdpSwORyAsuTokksWuns
         Iypg==
X-Gm-Message-State: ANhLgQ0WZQpq29O/Ed2xkGxuZcAhTFz7rUYkY0sAz/E7yqOaTkfpdRy4
        eKQ3wG9wuH2XKb44OoO4rz6DFI479P355KgSUes1wk+ZLg0M
X-Google-Smtp-Source: ADFU+vs+49by72EiK3tyDZ1VJTAtJjUTQvFX8OhFkSOi42kkEpgdB4fNMAZ2eILYHZaqnaMGWS2fYau6zArA3T2lhzRHiozyVXVy
MIME-Version: 1.0
X-Received: by 2002:a92:cc8c:: with SMTP id x12mr8410127ilo.224.1585222455461;
 Thu, 26 Mar 2020 04:34:15 -0700 (PDT)
Date:   Thu, 26 Mar 2020 04:34:15 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000590f6b05a1c05d15@google.com>
Subject: KASAN: use-after-free Read in htc_connect_service
From:   syzbot <syzbot+9505af1ae303dabdc646@syzkaller.appspotmail.com>
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
console output: https://syzkaller.appspot.com/x/log.txt?x=1509f1a7e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5d64370c438bc60
dashboard link: https://syzkaller.appspot.com/bug?extid=9505af1ae303dabdc646
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=116bbf75e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=117302d5e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+9505af1ae303dabdc646@syzkaller.appspotmail.com

usb 1-1: ath9k_htc: Firmware ath9k_htc/htc_9271-1.4.0.fw requested
usb 1-1: ath9k_htc: Transferred FW: ath9k_htc/htc_9271-1.4.0.fw, size: 51008
usb 1-1: Service connection timeout for: 256
==================================================================
BUG: KASAN: use-after-free in atomic_read include/asm-generic/atomic-instrumented.h:26 [inline]
BUG: KASAN: use-after-free in refcount_read include/linux/refcount.h:134 [inline]
BUG: KASAN: use-after-free in skb_unref include/linux/skbuff.h:1042 [inline]
BUG: KASAN: use-after-free in kfree_skb+0x32/0x3d0 net/core/skbuff.c:692
Read of size 4 at addr ffff8881d0957994 by task kworker/1:2/83

CPU: 1 PID: 83 Comm: kworker/1:2 Not tainted 5.6.0-rc5-syzkaller #0
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
 ath9k_hif_usb_firmware_cb+0x26b/0x500 drivers/net/wireless/ath/ath9k/hif_usb.c:1187
 request_firmware_work_func+0x126/0x242 drivers/base/firmware_loader/main.c:976
 process_one_work+0x94b/0x1620 kernel/workqueue.c:2264
 worker_thread+0x96/0xe20 kernel/workqueue.c:2410
 kthread+0x318/0x420 kernel/kthread.c:255
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

Allocated by task 83:
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

Freed by task 0:
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
 ath9k_htc_txcompletion_cb+0x1f8/0x2b0 drivers/net/wireless/ath/ath9k/htc_hst.c:356
 hif_usb_regout_cb+0x10b/0x1b0 drivers/net/wireless/ath/ath9k/hif_usb.c:90
 __usb_hcd_giveback_urb+0x29a/0x550 drivers/usb/core/hcd.c:1650
 usb_hcd_giveback_urb+0x368/0x420 drivers/usb/core/hcd.c:1716
 dummy_timer+0x1258/0x32ae drivers/usb/gadget/udc/dummy_hcd.c:1966
 call_timer_fn+0x195/0x6f0 kernel/time/timer.c:1404
 expire_timers kernel/time/timer.c:1449 [inline]
 __run_timers kernel/time/timer.c:1773 [inline]
 __run_timers kernel/time/timer.c:1740 [inline]
 run_timer_softirq+0x5f9/0x1500 kernel/time/timer.c:1786
 __do_softirq+0x21e/0x950 kernel/softirq.c:292

The buggy address belongs to the object at ffff8881d09578c0
 which belongs to the cache skbuff_head_cache of size 224
The buggy address is located 212 bytes inside of
 224-byte region [ffff8881d09578c0, ffff8881d09579a0)
The buggy address belongs to the page:
page:ffffea00074255c0 refcount:1 mapcount:0 mapping:ffff8881da16b400 index:0x0
flags: 0x200000000000200(slab)
raw: 0200000000000200 dead000000000100 dead000000000122 ffff8881da16b400
raw: 0000000000000000 00000000000c000c 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8881d0957880: fc fc fc fc fc fc fc fc fb fb fb fb fb fb fb fb
 ffff8881d0957900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff8881d0957980: fb fb fb fb fc fc fc fc fc fc fc fc fc fc fc fc
                         ^
 ffff8881d0957a00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8881d0957a80: fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
