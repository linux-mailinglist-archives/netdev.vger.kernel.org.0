Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70BE71F787C
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 15:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbgFLNI0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 09:08:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726258AbgFLNIZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jun 2020 09:08:25 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8E89C08C5C2
        for <netdev@vger.kernel.org>; Fri, 12 Jun 2020 06:08:25 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id h10so373717pgq.10
        for <netdev@vger.kernel.org>; Fri, 12 Jun 2020 06:08:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aUOnK/V6E2c0QjA3JcLB73isOrqlUh0EKxeqmn334Io=;
        b=IQKavdnrV0XGnU+daxIx0alEG08pnm20vtMKXsBOcwc+Bh78Hm5odWCrFmWkSS5AJm
         hSRpWUZ1VPaZk6feyGW9ZdCvI6mFFL8gYBvMw2nSzatX3a7/22Dz5VSHDGcABG74pgj4
         v8XcX8PgtULnVoJhNaF+g7aCFn3nBi1mIrBOq4sfudLjQ78Uey6OZdK4rXEt0lXwNaEX
         MeIelcVUwxq21fodJHNDwloZAUbPsWcawzI1c/Z+lAAEYH0SB/CTiZdZW+//PffNuvOl
         5DI5NgsXMexooZeViItG8H/36mxRSleJW5jjlh9T3BMU4+3LDC+0D7TE17nuyl5qsI6a
         MVPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aUOnK/V6E2c0QjA3JcLB73isOrqlUh0EKxeqmn334Io=;
        b=s2wiS2P5jcppsGvMO+KWCoA4z3obL72JymbphKBqThvU4nb0iuVZcV9hsznQi8O77B
         kGhUA2yit0cr0yURH6YsOVyixNsfKrX+JXpsREv5hVY9BdxNyefKFsdssMGQuOVQRlL2
         7Rz1yrLQd3RgoRzOkfBK7LNWu9KoMzpOOHyI9CFmheB0Sb12bp8AIcoVN5Ba3g+D+/Vo
         gb6+65bEyqZIeC3iuaiqA7UwrmIshRrcUcMJyrtd8qRGv0giCieaJYuETHshqvfPoY69
         CN38P5rYPhnE5XHrr9DtJviZ0a5qIQhUaiKtE66/rbovT4DKeNzMDn5tzNf+3i097uwj
         ZSLg==
X-Gm-Message-State: AOAM530wJt9wLDXDPwJmLl/PVYng/GyRt4IeM1hmxt4u7WyFe+bzaoXb
        2RZcAkuDnr5tOctsK76xZWODM/kH6TFBQCJL6oQloA==
X-Google-Smtp-Source: ABdhPJy6jtd2g64TNuQdLYvVvSWrDRdqdV9mmn4qEM7tRFhfxFTVQ1fW1hReIFhw5fkbil3HcpvOFG7oYMHRwqj33No=
X-Received: by 2002:a63:724a:: with SMTP id c10mr10824235pgn.130.1591967305188;
 Fri, 12 Jun 2020 06:08:25 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000036317b05a301e1e4@google.com>
In-Reply-To: <00000000000036317b05a301e1e4@google.com>
From:   Andrey Konovalov <andreyknvl@google.com>
Date:   Fri, 12 Jun 2020 15:08:14 +0200
Message-ID: <CAAeHK+z-kPmNc_rVaMht+p=1qRu110ue=LZ09=+DGZNt7f-TTg@mail.gmail.com>
Subject: Re: KASAN: use-after-free Read in ath9k_htc_txcompletion_cb
To:     syzbot <syzbot+809d3bdcdb4650cdbc83@syzkaller.appspotmail.com>
Cc:     ath9k-devel@qca.qualcomm.com,
        "David S. Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        LKML <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        linux-wireless@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 11, 2020 at 1:09 PM syzbot
<syzbot+809d3bdcdb4650cdbc83@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    0fa84af8 Merge tag 'usb-serial-5.7-rc1' of https://git.ker..
> git tree:       https://github.com/google/kasan.git usb-fuzzer
> console output: https://syzkaller.appspot.com/x/log.txt?x=10af83b3e00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=6b9c154b0c23aecf
> dashboard link: https://syzkaller.appspot.com/bug?extid=809d3bdcdb4650cdbc83
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
>
> Unfortunately, I don't have any reproducer for this crash yet.
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+809d3bdcdb4650cdbc83@syzkaller.appspotmail.com
>
> ==================================================================
> BUG: KASAN: use-after-free in ath9k_htc_txcompletion_cb+0x285/0x2b0 drivers/net/wireless/ath/ath9k/htc_hst.c:341
> Read of size 8 at addr ffff8881d1caf488 by task kworker/0:0/24267
>
> CPU: 0 PID: 24267 Comm: kworker/0:0 Not tainted 5.6.0-rc7-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Workqueue: events request_firmware_work_func
> Call Trace:
>  <IRQ>
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0xef/0x16e lib/dump_stack.c:118
>  print_address_description.constprop.0.cold+0xd3/0x314 mm/kasan/report.c:374
>  __kasan_report.cold+0x37/0x77 mm/kasan/report.c:506
>  kasan_report+0xe/0x20 mm/kasan/common.c:641
>  ath9k_htc_txcompletion_cb+0x285/0x2b0 drivers/net/wireless/ath/ath9k/htc_hst.c:341
>  hif_usb_regout_cb+0x10b/0x1b0 drivers/net/wireless/ath/ath9k/hif_usb.c:90
>  __usb_hcd_giveback_urb+0x1f2/0x470 drivers/usb/core/hcd.c:1648
>  usb_hcd_giveback_urb+0x368/0x420 drivers/usb/core/hcd.c:1713
>  dummy_timer+0x1258/0x32ae drivers/usb/gadget/udc/dummy_hcd.c:1966
>  call_timer_fn+0x195/0x6f0 kernel/time/timer.c:1404
>  expire_timers kernel/time/timer.c:1449 [inline]
>  __run_timers kernel/time/timer.c:1773 [inline]
>  __run_timers kernel/time/timer.c:1740 [inline]
>  run_timer_softirq+0x5f9/0x1500 kernel/time/timer.c:1786
>  __do_softirq+0x21e/0x950 kernel/softirq.c:292
>  invoke_softirq kernel/softirq.c:373 [inline]
>  irq_exit+0x178/0x1a0 kernel/softirq.c:413
>  exiting_irq arch/x86/include/asm/apic.h:546 [inline]
>  smp_apic_timer_interrupt+0x141/0x540 arch/x86/kernel/apic/apic.c:1146
>  apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:829
>  </IRQ>
> RIP: 0010:arch_local_irq_restore arch/x86/include/asm/irqflags.h:85 [inline]
> RIP: 0010:console_unlock+0xa6b/0xca0 kernel/printk/printk.c:2481
> Code: 00 89 ee 48 c7 c7 60 3e 14 87 e8 10 c3 03 00 65 ff 0d c1 ed d8 7e e9 b5 f9 ff ff e8 0f 37 16 00 e8 0a 7f 1b 00 ff 74 24 30 9d <e9> fd fd ff ff e8 fb 36 16 00 48 8d 7d 08 48 89 f8 48 c1 e8 03 42
> RSP: 0018:ffff8881d9227a50 EFLAGS: 00000293 ORIG_RAX: ffffffffffffff13
> RAX: 0000000000000007 RBX: 0000000000000200 RCX: 0000000000000006
> RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffff8881aba6d1cc
> RBP: 0000000000000000 R08: ffff8881aba6c980 R09: fffffbfff1266485
> R10: fffffbfff1266484 R11: ffffffff89332427 R12: ffffffff82a092b0
> R13: ffffffff874d3950 R14: 0000000000000057 R15: dffffc0000000000
>  vprintk_emit+0x171/0x3d0 kernel/printk/printk.c:1996
>  vprintk_func+0x75/0x113 kernel/printk/printk_safe.c:386
>  printk+0xba/0xed kernel/printk/printk.c:2056
>  ath9k_htc_hw_init.cold+0x17/0x2a drivers/net/wireless/ath/ath9k/htc_hst.c:502
>  ath9k_hif_usb_firmware_cb+0x26b/0x500 drivers/net/wireless/ath/ath9k/hif_usb.c:1187
>  request_firmware_work_func+0x126/0x242 drivers/base/firmware_loader/main.c:976
>  process_one_work+0x94b/0x1620 kernel/workqueue.c:2266
>  worker_thread+0x96/0xe20 kernel/workqueue.c:2412
>  kthread+0x318/0x420 kernel/kthread.c:255
>  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
>
> Allocated by task 24267:
>  save_stack+0x1b/0x80 mm/kasan/common.c:72
>  set_track mm/kasan/common.c:80 [inline]
>  __kasan_kmalloc mm/kasan/common.c:515 [inline]
>  __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:488
>  slab_post_alloc_hook mm/slab.h:584 [inline]
>  slab_alloc_node mm/slub.c:2786 [inline]
>  kmem_cache_alloc_node+0xdc/0x330 mm/slub.c:2822
>  __alloc_skb+0xba/0x5a0 net/core/skbuff.c:198
>  alloc_skb include/linux/skbuff.h:1081 [inline]
>  htc_connect_service+0x2cc/0x840 drivers/net/wireless/ath/ath9k/htc_hst.c:257
>  ath9k_wmi_connect+0xd2/0x1a0 drivers/net/wireless/ath/ath9k/wmi.c:265
>  ath9k_init_htc_services.constprop.0+0xb4/0x650 drivers/net/wireless/ath/ath9k/htc_drv_init.c:146
>  ath9k_htc_probe_device+0x25a/0x1d80 drivers/net/wireless/ath/ath9k/htc_drv_init.c:959
>  ath9k_htc_hw_init+0x31/0x60 drivers/net/wireless/ath/ath9k/htc_hst.c:501
>  ath9k_hif_usb_firmware_cb+0x26b/0x500 drivers/net/wireless/ath/ath9k/hif_usb.c:1187
>  request_firmware_work_func+0x126/0x242 drivers/base/firmware_loader/main.c:976
>  process_one_work+0x94b/0x1620 kernel/workqueue.c:2266
>  worker_thread+0x96/0xe20 kernel/workqueue.c:2412
>  kthread+0x318/0x420 kernel/kthread.c:255
>  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
>
> Freed by task 24267:
>  save_stack+0x1b/0x80 mm/kasan/common.c:72
>  set_track mm/kasan/common.c:80 [inline]
>  kasan_set_free_info mm/kasan/common.c:337 [inline]
>  __kasan_slab_free+0x117/0x160 mm/kasan/common.c:476
>  slab_free_hook mm/slub.c:1444 [inline]
>  slab_free_freelist_hook mm/slub.c:1477 [inline]
>  slab_free mm/slub.c:3034 [inline]
>  kmem_cache_free+0x9b/0x360 mm/slub.c:3050
>  kfree_skbmem net/core/skbuff.c:622 [inline]
>  kfree_skbmem+0xef/0x1b0 net/core/skbuff.c:616
>  __kfree_skb net/core/skbuff.c:679 [inline]
>  kfree_skb net/core/skbuff.c:696 [inline]
>  kfree_skb+0x102/0x3d0 net/core/skbuff.c:690
>  htc_connect_service.cold+0xa9/0x109 drivers/net/wireless/ath/ath9k/htc_hst.c:282
>  ath9k_wmi_connect+0xd2/0x1a0 drivers/net/wireless/ath/ath9k/wmi.c:265
>  ath9k_init_htc_services.constprop.0+0xb4/0x650 drivers/net/wireless/ath/ath9k/htc_drv_init.c:146
>  ath9k_htc_probe_device+0x25a/0x1d80 drivers/net/wireless/ath/ath9k/htc_drv_init.c:959
>  ath9k_htc_hw_init+0x31/0x60 drivers/net/wireless/ath/ath9k/htc_hst.c:501
>  ath9k_hif_usb_firmware_cb+0x26b/0x500 drivers/net/wireless/ath/ath9k/hif_usb.c:1187
>  request_firmware_work_func+0x126/0x242 drivers/base/firmware_loader/main.c:976
>  process_one_work+0x94b/0x1620 kernel/workqueue.c:2266
>  worker_thread+0x96/0xe20 kernel/workqueue.c:2412
>  kthread+0x318/0x420 kernel/kthread.c:255
>  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
>
> The buggy address belongs to the object at ffff8881d1caf3c0
>  which belongs to the cache skbuff_head_cache of size 224
> The buggy address is located 200 bytes inside of
>  224-byte region [ffff8881d1caf3c0, ffff8881d1caf4a0)
> The buggy address belongs to the page:
> page:ffffea0007472bc0 refcount:1 mapcount:0 mapping:ffff8881da16b400 index:0xffff8881d1caf280
> flags: 0x200000000000200(slab)
> raw: 0200000000000200 ffffea00074473c0 0000000900000009 ffff8881da16b400
> raw: ffff8881d1caf280 00000000800c000b 00000001ffffffff 0000000000000000
> page dumped because: kasan: bad access detected
>
> Memory state around the buggy address:
>  ffff8881d1caf380: fc fc fc fc fc fc fc fc fb fb fb fb fb fb fb fb
>  ffff8881d1caf400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> >ffff8881d1caf480: fb fb fb fb fc fc fc fc fc fc fc fc fc fc fc fc
>                       ^
>  ffff8881d1caf500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff8881d1caf580: fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
> ==================================================================
>
>
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

#syz dup: KASAN: use-after-free Read in hif_usb_regout_cb
