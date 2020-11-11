Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F09EB2AF36B
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 15:23:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726227AbgKKOXT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 09:23:19 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:45798 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbgKKOXS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 09:23:18 -0500
Received: by mail-io1-f70.google.com with SMTP id o17so1493085ioo.12
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 06:23:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=2yCMU4GvUtwAjY+k5nLvthk8vkB54VNGKYZoEyb3b6c=;
        b=oQYy56MOjSMRckyULDpg+lZrV1s7rYBGuh8VlHXQTE8uxz2qxONxnpwpRQqwN2z4lH
         kQhT7vb7El2oOuNBzsDZ/UFNfJ4VDSglpxOXZp+nVKpvEO+Yjnau/nqmP7XVd4kOaQ2n
         AAWYF8T9zLWkgohCOfe/IWwZjNaVRo907tdYfzNVSqBklBaj/x/IiWQyXu3KWI9Tv33T
         vXn2xXfSUr98+lOc695DmhzNTHBbiUs1cC/oKvg6m7eYJYtdzw7W9UW8EaJy7ZMcVuD8
         bbGUb6LfDh/nR1gMg+5QWntvv3V1B3izlipYI1nK8mx946jwhA80MbZwYNx+0Sco/BX2
         oySA==
X-Gm-Message-State: AOAM533ZcPdGDgdB6+qtd9T6NHc6DrlMf1hlk02jCmZng3yV2v1h5WUC
        YzllPzS8Dc98Xo49tSqIS2gGW7+cDiBmwM+2Ec9ZedcrGcYY
X-Google-Smtp-Source: ABdhPJzS+LviWWBvhoTPlk8A1iMPbhdx32pJQmLO6uLZSeOZUpKY7PJaY6w9Z8f78WyCumGqA06uEA2TpC4JQFm0XIB/3xIXoXEp
MIME-Version: 1.0
X-Received: by 2002:a92:9845:: with SMTP id l66mr17373243ili.65.1605104597489;
 Wed, 11 Nov 2020 06:23:17 -0800 (PST)
Date:   Wed, 11 Nov 2020 06:23:17 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005c61c005b3d589fb@google.com>
Subject: KASAN: use-after-free Read in ath9k_hif_usb_reg_in_cb
From:   syzbot <syzbot+98c96757d557f4afaf19@syzkaller.appspotmail.com>
To:     ath9k-devel@qca.qualcomm.com, davem@davemloft.net, kuba@kernel.org,
        kvalo@codeaurora.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    407ab579 Merge tag 'for-linus' of git://git.kernel.org/pub..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=143b7966500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f9aa2432c01bcb1f
dashboard link: https://syzkaller.appspot.com/bug?extid=98c96757d557f4afaf19
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+98c96757d557f4afaf19@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in instrument_atomic_read include/linux/instrumented.h:71 [inline]
BUG: KASAN: use-after-free in atomic_read include/asm-generic/atomic-instrumented.h:27 [inline]
BUG: KASAN: use-after-free in refcount_read include/linux/refcount.h:147 [inline]
BUG: KASAN: use-after-free in skb_unref include/linux/skbuff.h:1046 [inline]
BUG: KASAN: use-after-free in kfree_skb+0x2e/0x3f0 net/core/skbuff.c:692
Read of size 4 at addr ffff888014b7ed54 by task syz-executor.0/28422

CPU: 1 PID: 28422 Comm: syz-executor.0 Not tainted 5.10.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xae/0x4c8 mm/kasan/report.c:385
 __kasan_report mm/kasan/report.c:545 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:562
 check_memory_region_inline mm/kasan/generic.c:186 [inline]
 check_memory_region+0x13d/0x180 mm/kasan/generic.c:192
 instrument_atomic_read include/linux/instrumented.h:71 [inline]
 atomic_read include/asm-generic/atomic-instrumented.h:27 [inline]
 refcount_read include/linux/refcount.h:147 [inline]
 skb_unref include/linux/skbuff.h:1046 [inline]
 kfree_skb+0x2e/0x3f0 net/core/skbuff.c:692
 ath9k_hif_usb_reg_in_cb+0x4c0/0x630 drivers/net/wireless/ath/ath9k/hif_usb.c:764
 __usb_hcd_giveback_urb+0x32d/0x560 drivers/usb/core/hcd.c:1650
 usb_hcd_giveback_urb+0x367/0x410 drivers/usb/core/hcd.c:1716
 dummy_timer+0x11f4/0x3280 drivers/usb/gadget/udc/dummy_hcd.c:1967
 call_timer_fn+0x1a5/0x6b0 kernel/time/timer.c:1410
 expire_timers kernel/time/timer.c:1455 [inline]
 __run_timers.part.0+0x67c/0xa50 kernel/time/timer.c:1747
 __run_timers kernel/time/timer.c:1728 [inline]
 run_timer_softirq+0xb3/0x1d0 kernel/time/timer.c:1760
 __do_softirq+0x2a0/0x9f6 kernel/softirq.c:298
 asm_call_irq_on_stack+0xf/0x20
 </IRQ>
 __run_on_irqstack arch/x86/include/asm/irq_stack.h:26 [inline]
 run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:77 [inline]
 do_softirq_own_stack+0xaa/0xd0 arch/x86/kernel/irq_64.c:77
 invoke_softirq kernel/softirq.c:393 [inline]
 __irq_exit_rcu kernel/softirq.c:423 [inline]
 irq_exit_rcu+0x132/0x200 kernel/softirq.c:435
 sysvec_apic_timer_interrupt+0x4d/0x100 arch/x86/kernel/apic/apic.c:1091
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:631
RIP: 0010:zap_pte_range mm/memory.c:1252 [inline]
RIP: 0010:zap_pmd_range mm/memory.c:1357 [inline]
RIP: 0010:zap_pud_range mm/memory.c:1386 [inline]
RIP: 0010:zap_p4d_range mm/memory.c:1407 [inline]
RIP: 0010:unmap_page_range+0xdf9/0x2640 mm/memory.c:1428
Code: 83 e3 01 89 de c1 e3 1f e8 b4 c2 ce ff c1 fb 1f 83 e3 03 e8 99 ca ce ff 48 63 db 48 83 fb 03 0f 87 b0 14 00 00 48 8b 44 24 40 <48> 8d 3c 98 48 89 f8 48 c1 e8 03 42 0f b6 14 30 48 89 f8 83 e0 07
RSP: 0018:ffffc9000320f9d8 EFLAGS: 00000293
RAX: ffffc9000320fad0 RBX: 0000000000000000 RCX: ffffffff81a14e9c
RDX: ffff88806c188000 RSI: ffffffff81a14ea7 RDI: 0000000000000001
RBP: ffffea00008b5740 R08: 0000000000000000 R09: ffffea00008b5747
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: ffff88802efc74a0 R14: dffffc0000000000 R15: 00007fd879e95000
 unmap_single_vma+0x198/0x300 mm/memory.c:1473
 unmap_vmas+0x168/0x2e0 mm/memory.c:1505
 exit_mmap+0x2b1/0x530 mm/mmap.c:3222
 __mmput+0x122/0x470 kernel/fork.c:1079
 mmput+0x53/0x60 kernel/fork.c:1100
 exit_mm kernel/exit.c:483 [inline]
 do_exit+0xa31/0x2930 kernel/exit.c:793
 do_group_exit+0x125/0x310 kernel/exit.c:903
 __do_sys_exit_group kernel/exit.c:914 [inline]
 __se_sys_exit_group kernel/exit.c:912 [inline]
 __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:912
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45deb9
Code: Unable to access opcode bytes at RIP 0x45de8f.
RSP: 002b:000000000169fd88 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 000000000000001e RCX: 000000000045deb9
RDX: 0000000000417811 RSI: fffffffffffffff7 RDI: 0000000000000000
RBP: 0000000000000000 R08: 000000006e9499ad R09: 000000000169fde0
R10: ffffffff8127dcc0 R11: 0000000000000246 R12: 0000000000000000
R13: 000000000169fde0 R14: 0000000000000000 R15: 000000000169fdf0

Allocated by task 9817:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc.constprop.0+0xc2/0xd0 mm/kasan/common.c:461
 slab_post_alloc_hook mm/slab.h:526 [inline]
 slab_alloc_node mm/slub.c:2891 [inline]
 kmem_cache_alloc_node+0x132/0x480 mm/slub.c:2927
 __alloc_skb+0x71/0x550 net/core/skbuff.c:198
 alloc_skb include/linux/skbuff.h:1094 [inline]
 ath9k_hif_usb_alloc_reg_in_urbs drivers/net/wireless/ath/ath9k/hif_usb.c:957 [inline]
 ath9k_hif_usb_alloc_urbs+0x912/0x1010 drivers/net/wireless/ath/ath9k/hif_usb.c:1016
 ath9k_hif_usb_dev_init drivers/net/wireless/ath/ath9k/hif_usb.c:1102 [inline]
 ath9k_hif_usb_firmware_cb+0x148/0x530 drivers/net/wireless/ath/ath9k/hif_usb.c:1235
 request_firmware_work_func+0x12c/0x230 drivers/base/firmware_loader/main.c:1079
 process_one_work+0x933/0x15a0 kernel/workqueue.c:2272
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2418
 kthread+0x3af/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296

Freed by task 28422:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_set_track+0x1c/0x30 mm/kasan/common.c:56
 kasan_set_free_info+0x1b/0x30 mm/kasan/generic.c:355
 __kasan_slab_free+0x102/0x140 mm/kasan/common.c:422
 slab_free_hook mm/slub.c:1544 [inline]
 slab_free_freelist_hook+0x5d/0x150 mm/slub.c:1577
 slab_free mm/slub.c:3142 [inline]
 kmem_cache_free+0x82/0x350 mm/slub.c:3158
 kfree_skbmem+0xef/0x1b0 net/core/skbuff.c:622
 __kfree_skb net/core/skbuff.c:679 [inline]
 kfree_skb net/core/skbuff.c:696 [inline]
 kfree_skb+0x140/0x3f0 net/core/skbuff.c:690
 ath9k_htc_rx_msg+0x1eb/0xb70 drivers/net/wireless/ath/ath9k/htc_hst.c:451
 ath9k_hif_usb_reg_in_cb+0x1ac/0x630 drivers/net/wireless/ath/ath9k/hif_usb.c:733
 __usb_hcd_giveback_urb+0x32d/0x560 drivers/usb/core/hcd.c:1650
 usb_hcd_giveback_urb+0x367/0x410 drivers/usb/core/hcd.c:1716
 dummy_timer+0x11f4/0x3280 drivers/usb/gadget/udc/dummy_hcd.c:1967
 call_timer_fn+0x1a5/0x6b0 kernel/time/timer.c:1410
 expire_timers kernel/time/timer.c:1455 [inline]
 __run_timers.part.0+0x67c/0xa50 kernel/time/timer.c:1747
 __run_timers kernel/time/timer.c:1728 [inline]
 run_timer_softirq+0xb3/0x1d0 kernel/time/timer.c:1760
 __do_softirq+0x2a0/0x9f6 kernel/softirq.c:298

The buggy address belongs to the object at ffff888014b7ec80
 which belongs to the cache skbuff_head_cache of size 224
The buggy address is located 212 bytes inside of
 224-byte region [ffff888014b7ec80, ffff888014b7ed60)
The buggy address belongs to the page:
page:00000000f48c4391 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x14b7e
flags: 0xfff00000000200(slab)
raw: 00fff00000000200 ffffea00009b9a80 0000000400000004 ffff888010f33640
raw: 0000000000000000 00000000000c000c 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff888014b7ec00: 00 00 00 00 fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888014b7ec80: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff888014b7ed00: fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
                                                 ^
 ffff888014b7ed80: fc fc fc fc fc fc fc fc 00 00 00 00 00 00 00 00
 ffff888014b7ee00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
