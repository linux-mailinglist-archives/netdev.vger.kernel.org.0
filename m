Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A10D4B63CE
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 07:57:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234640AbiBOG5c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 01:57:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234635AbiBOG5b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 01:57:31 -0500
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF2FC6591
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 22:57:21 -0800 (PST)
Received: by mail-io1-f70.google.com with SMTP id ay26-20020a5d9d9a000000b006396dd81e4bso10732761iob.10
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 22:57:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=0jdDKbuvs/SS6olnThggif8FOrGf5IWxmYLpjOqcz4o=;
        b=ktnLCN9ZrYSjlr2471Yq+XpJBS5s0ToZbK1tVNkMm6egQpID9YNBOZe8fgdTevzN4r
         POWeuGHYb+uP9TRbEpGjyq2x6Cy0Rk+zeW7r5v1139mG1aLcveHIe542EugGFSulhjG2
         8G1WsT08fKextMjIi6QXwVmnRaOdIKO3nePXdeum/fEUz/41yNfgr4uWAVYeAmITutPz
         DA2fgBmYacptsQ44Wk+8+r5yhaTShkTg7hRGJvY/iNUfb+6hNuoclFDLHyr70i/g4N/B
         S6AgUx6d85VaKbYv1tMkcgC0nBW/gtuRemztUpx3c+th9F6SphfYkPXNJYuGz61Xy7nV
         thMg==
X-Gm-Message-State: AOAM532vva5efoRsIMEqoJteuqs2ecniN8TBavUQqIBY26RmZolb5qUk
        pXiBy6V2IH54OzF9TVuAUQCfQXRRFsXHA5ziu1TMMRAqyoYT
X-Google-Smtp-Source: ABdhPJwPY5C2tzqo3GvpPosiWN5JAbGP4DoKyvBGTpASipkz5orT4YqHnRocS2wnGaBgPpG6CG75Ik3QQmiVwMoFSx6bnpIJgCEb
MIME-Version: 1.0
X-Received: by 2002:a92:680b:: with SMTP id d11mr1628582ilc.74.1644908240998;
 Mon, 14 Feb 2022 22:57:20 -0800 (PST)
Date:   Mon, 14 Feb 2022 22:57:20 -0800
In-Reply-To: <00000000000006b92e05d6ee4fce@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000064956605d8090bd5@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in ath9k_hif_usb_reg_in_cb (3)
From:   syzbot <syzbot+b05dabaed0b1f0b0a5e4@syzkaller.appspotmail.com>
To:     ath9k-devel@qca.qualcomm.com, davem@davemloft.net, kuba@kernel.org,
        kvalo@kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
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

HEAD commit:    4378e427f705 usbip: vudc: Make use of the helper macro LIS..
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git usb-testing
console output: https://syzkaller.appspot.com/x/log.txt?x=1565305a700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=83e40899a8923e35
dashboard link: https://syzkaller.appspot.com/bug?extid=b05dabaed0b1f0b0a5e4
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13a352f2700000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=162e878c700000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b05dabaed0b1f0b0a5e4@syzkaller.appspotmail.com

usb 1-1: ath: unknown panic pattern!
==================================================================
BUG: KASAN: use-after-free in instrument_atomic_read include/linux/instrumented.h:71 [inline]
BUG: KASAN: use-after-free in atomic_read include/linux/atomic/atomic-instrumented.h:27 [inline]
BUG: KASAN: use-after-free in refcount_read include/linux/refcount.h:147 [inline]
BUG: KASAN: use-after-free in skb_unref include/linux/skbuff.h:1098 [inline]
BUG: KASAN: use-after-free in kfree_skb_reason+0x33/0x400 net/core/skbuff.c:772
Read of size 4 at addr ffff888118b6be9c by task syz-executor056/1278

CPU: 1 PID: 1278 Comm: syz-executor056 Not tainted 5.17.0-rc4-syzkaller-00061-g4378e427f705 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description.constprop.0.cold+0x8d/0x336 mm/kasan/report.c:255
 __kasan_report mm/kasan/report.c:442 [inline]
 kasan_report.cold+0x83/0xdf mm/kasan/report.c:459
 check_region_inline mm/kasan/generic.c:183 [inline]
 kasan_check_range+0x13d/0x180 mm/kasan/generic.c:189
 instrument_atomic_read include/linux/instrumented.h:71 [inline]
 atomic_read include/linux/atomic/atomic-instrumented.h:27 [inline]
 refcount_read include/linux/refcount.h:147 [inline]
 skb_unref include/linux/skbuff.h:1098 [inline]
 kfree_skb_reason+0x33/0x400 net/core/skbuff.c:772
 kfree_skb include/linux/skbuff.h:1114 [inline]
 ath9k_hif_usb_reg_in_cb+0x4c2/0x630 drivers/net/wireless/ath/ath9k/hif_usb.c:771
 __usb_hcd_giveback_urb+0x2b0/0x5c0 drivers/usb/core/hcd.c:1670
 usb_hcd_giveback_urb+0x367/0x410 drivers/usb/core/hcd.c:1747
 dummy_timer+0x11f9/0x32b0 drivers/usb/gadget/udc/dummy_hcd.c:1987
 call_timer_fn+0x1a5/0x6b0 kernel/time/timer.c:1421
 expire_timers kernel/time/timer.c:1466 [inline]
 __run_timers.part.0+0x67c/0xa30 kernel/time/timer.c:1734
 __run_timers kernel/time/timer.c:1715 [inline]
 run_timer_softirq+0xb3/0x1d0 kernel/time/timer.c:1747
 __do_softirq+0x288/0x9a5 kernel/softirq.c:558
 invoke_softirq kernel/softirq.c:432 [inline]
 __irq_exit_rcu+0x113/0x170 kernel/softirq.c:637
 irq_exit_rcu+0x5/0x20 kernel/softirq.c:649
 sysvec_apic_timer_interrupt+0x40/0xc0 arch/x86/kernel/apic/apic.c:1097
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:638
RIP: 0033:0x7f65f5afb6ca
Code: 83 ff 03 74 3b 48 83 ec 28 b8 fa ff ff ff 83 ff 02 49 89 ca 0f 44 f8 64 8b 04 25 18 00 00 00 85 c0 75 2d b8 e6 00 00 00 0f 05 <89> c2 f7 da 3d 00 f0 ff ff b8 00 00 00 00 0f 47 c2 48 83 c4 28 c3
RSP: 002b:00007ffd489cd250 EFLAGS: 00000246
RAX: 0000000000000000 RBX: 000000000002e7e7 RCX: 00007f65f5afb6ca
RDX: 00007ffd489cd290 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000008 R08: 00000000000000c0 R09: 00007ffd489f0080
R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffd489cd2e0
R13: 00007ffd489cd340 R14: 0000000000000002 R15: 431bde82d7b634db
 </TASK>

Allocated by task 69:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:45 [inline]
 set_alloc_info mm/kasan/common.c:436 [inline]
 __kasan_slab_alloc+0x66/0x80 mm/kasan/common.c:469
 kasan_slab_alloc include/linux/kasan.h:260 [inline]
 slab_post_alloc_hook mm/slab.h:732 [inline]
 slab_alloc_node mm/slub.c:3230 [inline]
 kmem_cache_alloc_node+0x25e/0x4b0 mm/slub.c:3266
 __alloc_skb+0x215/0x340 net/core/skbuff.c:414
 alloc_skb include/linux/skbuff.h:1158 [inline]
 ath9k_hif_usb_alloc_reg_in_urbs drivers/net/wireless/ath/ath9k/hif_usb.c:964 [inline]
 ath9k_hif_usb_alloc_urbs+0x91d/0x1040 drivers/net/wireless/ath/ath9k/hif_usb.c:1023
 ath9k_hif_usb_dev_init drivers/net/wireless/ath/ath9k/hif_usb.c:1109 [inline]
 ath9k_hif_usb_firmware_cb+0x148/0x530 drivers/net/wireless/ath/ath9k/hif_usb.c:1242
 request_firmware_work_func+0x12c/0x230 drivers/base/firmware_loader/main.c:1022
 process_one_work+0x9ac/0x1650 kernel/workqueue.c:2307
 worker_thread+0x657/0x1110 kernel/workqueue.c:2454
 kthread+0x2ef/0x3a0 kernel/kthread.c:377
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

Freed by task 1278:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 kasan_set_track+0x21/0x30 mm/kasan/common.c:45
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:370
 ____kasan_slab_free mm/kasan/common.c:366 [inline]
 ____kasan_slab_free+0x102/0x150 mm/kasan/common.c:328
 kasan_slab_free include/linux/kasan.h:236 [inline]
 slab_free_hook mm/slub.c:1728 [inline]
 slab_free_freelist_hook mm/slub.c:1754 [inline]
 slab_free mm/slub.c:3509 [inline]
 kmem_cache_free+0xd5/0x400 mm/slub.c:3526
 kfree_skbmem+0xef/0x1b0 net/core/skbuff.c:700
 __kfree_skb net/core/skbuff.c:757 [inline]
 kfree_skb_reason net/core/skbuff.c:776 [inline]
 kfree_skb_reason+0x145/0x400 net/core/skbuff.c:770
 kfree_skb include/linux/skbuff.h:1114 [inline]
 ath9k_htc_rx_msg+0x1ed/0xb70 drivers/net/wireless/ath/ath9k/htc_hst.c:451
 ath9k_hif_usb_reg_in_cb+0x1ac/0x630 drivers/net/wireless/ath/ath9k/hif_usb.c:740
 __usb_hcd_giveback_urb+0x2b0/0x5c0 drivers/usb/core/hcd.c:1670
 usb_hcd_giveback_urb+0x367/0x410 drivers/usb/core/hcd.c:1747
 dummy_timer+0x11f9/0x32b0 drivers/usb/gadget/udc/dummy_hcd.c:1987
 call_timer_fn+0x1a5/0x6b0 kernel/time/timer.c:1421
 expire_timers kernel/time/timer.c:1466 [inline]
 __run_timers.part.0+0x67c/0xa30 kernel/time/timer.c:1734
 __run_timers kernel/time/timer.c:1715 [inline]
 run_timer_softirq+0xb3/0x1d0 kernel/time/timer.c:1747
 __do_softirq+0x288/0x9a5 kernel/softirq.c:558

The buggy address belongs to the object at ffff888118b6bdc0
 which belongs to the cache skbuff_head_cache of size 232
The buggy address is located 220 bytes inside of
 232-byte region [ffff888118b6bdc0, ffff888118b6bea8)
The buggy address belongs to the page:
page:ffffea000462dac0 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x118b6b
flags: 0x200000000000200(slab|node=0|zone=2)
raw: 0200000000000200 0000000000000000 dead000000000001 ffff8881003d3640
raw: 0000000000000000 00000000000c000c 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x12cc0(GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY), pid 1170, ts 8677100351, free_ts 0
 prep_new_page mm/page_alloc.c:2434 [inline]
 get_page_from_freelist+0x122d/0x2940 mm/page_alloc.c:4165
 __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5389
 alloc_pages+0x1aa/0x310 mm/mempolicy.c:2271
 alloc_slab_page mm/slub.c:1799 [inline]
 allocate_slab+0x27f/0x3e0 mm/slub.c:1944
 new_slab mm/slub.c:2004 [inline]
 ___slab_alloc+0xc12/0x1450 mm/slub.c:3018
 __slab_alloc.constprop.0+0x4d/0xa0 mm/slub.c:3105
 slab_alloc_node mm/slub.c:3196 [inline]
 kmem_cache_alloc_node+0x397/0x4b0 mm/slub.c:3266
 __alloc_skb+0x215/0x340 net/core/skbuff.c:414
 alloc_skb include/linux/skbuff.h:1158 [inline]
 alloc_uevent_skb+0x7b/0x210 lib/kobject_uevent.c:290
 uevent_net_broadcast_untagged lib/kobject_uevent.c:326 [inline]
 kobject_uevent_net_broadcast lib/kobject_uevent.c:409 [inline]
 kobject_uevent_env+0xadf/0x1600 lib/kobject_uevent.c:593
 kobject_synth_uevent+0x701/0x850 lib/kobject_uevent.c:208
 store_uevent+0x12/0x20 kernel/module.c:1166
 module_attr_store+0x50/0x80 kernel/params.c:919
 sysfs_kf_write+0x110/0x160 fs/sysfs/file.c:136
 kernfs_fop_write_iter+0x3f8/0x610 fs/kernfs/file.c:296
 call_write_iter include/linux/fs.h:2074 [inline]
 new_sync_write+0x431/0x660 fs/read_write.c:503
page_owner free stack trace missing

Memory state around the buggy address:
 ffff888118b6bd80: fc fc fc fc fc fc fc fc fa fb fb fb fb fb fb fb
 ffff888118b6be00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff888118b6be80: fb fb fb fb fb fc fc fc fc fc fc fc fc fc fc fc
                            ^
 ffff888118b6bf00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888118b6bf80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================

