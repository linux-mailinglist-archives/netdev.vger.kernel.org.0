Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4046C1F783D
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 15:00:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbgFLNAp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 09:00:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726381AbgFLNAo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jun 2020 09:00:44 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB477C03E96F
        for <netdev@vger.kernel.org>; Fri, 12 Jun 2020 06:00:44 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id b16so4253830pfi.13
        for <netdev@vger.kernel.org>; Fri, 12 Jun 2020 06:00:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=swP4p/uhLQH6sh691twbClwZYKHi8YjTCIj0DdBzqa0=;
        b=K9mpJwvLRJ3nGfymm/TvkheafL3/Q9m1Vg28H87YSan4JzvTdsi7QkLbs6ak4Go7Y5
         VTsLh9KNYVurr6EmC2v9Zf8Q4NuByI9CMErpuxdk7dL4WgOc1umRbX6YlXmV+aH9iaua
         6PXVjm6PxESvGfY58/cGNa/zYbRDuYKO+qly1xtIkwnUqg1+P25DmLPIjevopHwhijT1
         eJmrL83gTY5Y0wljz2F/kT5U2XGH8mh1Z4tFFp+YWV2YrMsHbFuLgsexkeAnNk/egjQa
         GzbTEr/9hYG9D+oVeo39TnGbzGFs1Tjc7O9p6qN/9OXOd/c1cEbmhSgWjDJNxY1TvLaf
         pYXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=swP4p/uhLQH6sh691twbClwZYKHi8YjTCIj0DdBzqa0=;
        b=m1ioWp1yrKinZAoc9voV37g+kDD8mvRFpUq/AywKcJnmIEjaMq41V+OPbin43bSRb+
         iijJAW9YOmmn86GD52KJh596YygfwbWnjZ4FvbCwyAXPomUHqFcdlcnQ95X4tozxEmlV
         xoS4Yzzkrgtuh1aV5FndQkuLEVzn9ns0IIGUMcBXf9hE/pC+YgzBuzQ9VQe+thrMrIB1
         8EkAESbrrlhYDKGngyHXiOcx60FtRrfnYocxytIXWjv4R+M+kR8oLOJtCkdlw66Omz23
         H/pESeY1AkRmZzR0iCsY1ZkRxChzZ9NRtlG5lPEMqDQe4l0uTVy7ljpEYzKX0FbCIAkg
         kt0A==
X-Gm-Message-State: AOAM530GtngzW7rQ19XFtjbyePGTQrpTdAUwhSguqDLl6SOb9yqiJwri
        ILhncetY45xwBo+tCahHM84XJEjDEcgcxyvYkE/y4g==
X-Google-Smtp-Source: ABdhPJz64KrIGgDOSnnTPhCB6reVYL+Rt7opZPYBe95ZE3ezMMtiVN3PrE1uam6Hwn0oD+kTLtq9epUulNEyN8jorEc=
X-Received: by 2002:a62:25c5:: with SMTP id l188mr11718967pfl.178.1591966843813;
 Fri, 12 Jun 2020 06:00:43 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000007f8ce405a5d9c010@google.com>
In-Reply-To: <0000000000007f8ce405a5d9c010@google.com>
From:   Andrey Konovalov <andreyknvl@google.com>
Date:   Fri, 12 Jun 2020 15:00:32 +0200
Message-ID: <CAAeHK+wd5e_YMZmanJv=8X29TKvZ0U461gTTcrJrLPBgRC3ARg@mail.gmail.com>
Subject: Re: KASAN: slab-out-of-bounds Read in ath9k_hif_usb_rx_cb
To:     syzbot <syzbot+c15a0a825788b6ba2bc4@syzkaller.appspotmail.com>
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

On Sun, May 17, 2020 at 5:32 PM syzbot
<syzbot+c15a0a825788b6ba2bc4@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    806d8acc USB: dummy-hcd: use configurable endpoint naming ..
> git tree:       https://github.com/google/kasan.git usb-fuzzer
> console output: https://syzkaller.appspot.com/x/log.txt?x=1147bce6100000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=d800e9bad158025f
> dashboard link: https://syzkaller.appspot.com/bug?extid=c15a0a825788b6ba2bc4
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
>
> Unfortunately, I don't have any reproducer for this crash yet.
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+c15a0a825788b6ba2bc4@syzkaller.appspotmail.com
>
> ==================================================================
> BUG: KASAN: slab-out-of-bounds in ath9k_hif_usb_rx_stream drivers/net/wireless/ath/ath9k/hif_usb.c:580 [inline]
> BUG: KASAN: slab-out-of-bounds in ath9k_hif_usb_rx_cb+0xad3/0xf90 drivers/net/wireless/ath/ath9k/hif_usb.c:666
> Read of size 4 at addr ffff8881cca0c0dc by task kworker/1:3/3075
>
> CPU: 1 PID: 3075 Comm: kworker/1:3 Not tainted 5.7.0-rc5-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Workqueue: events request_firmware_work_func
> Call Trace:
>  <IRQ>
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0xef/0x16e lib/dump_stack.c:118
>  print_address_description.constprop.0.cold+0xd3/0x314 mm/kasan/report.c:382
>  __kasan_report.cold+0x37/0x92 mm/kasan/report.c:511
>  kasan_report+0x33/0x50 mm/kasan/common.c:625
>  ath9k_hif_usb_rx_stream drivers/net/wireless/ath/ath9k/hif_usb.c:580 [inline]
>  ath9k_hif_usb_rx_cb+0xad3/0xf90 drivers/net/wireless/ath/ath9k/hif_usb.c:666
>  __usb_hcd_giveback_urb+0x1f2/0x470 drivers/usb/core/hcd.c:1648
>  usb_hcd_giveback_urb+0x368/0x420 drivers/usb/core/hcd.c:1713
>  dummy_timer+0x125e/0x32b4 drivers/usb/gadget/udc/dummy_hcd.c:1966
>  call_timer_fn+0x1ac/0x700 kernel/time/timer.c:1405
>  expire_timers kernel/time/timer.c:1450 [inline]
>  __run_timers kernel/time/timer.c:1774 [inline]
>  __run_timers kernel/time/timer.c:1741 [inline]
>  run_timer_softirq+0x5f9/0x1500 kernel/time/timer.c:1787
>  __do_softirq+0x21e/0x9aa kernel/softirq.c:292
>  invoke_softirq kernel/softirq.c:373 [inline]
>  irq_exit+0x178/0x1a0 kernel/softirq.c:413
>  exiting_irq arch/x86/include/asm/apic.h:546 [inline]
>  smp_apic_timer_interrupt+0x141/0x540 arch/x86/kernel/apic/apic.c:1140
>  apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:829
>  </IRQ>
> RIP: 0010:arch_local_irq_restore arch/x86/include/asm/irqflags.h:85 [inline]
> RIP: 0010:console_trylock_spinning kernel/printk/printk.c:1779 [inline]
> RIP: 0010:vprintk_emit+0x3d0/0x3e0 kernel/printk/printk.c:2020
> Code: 00 83 fb ff 75 d6 e9 d8 fc ff ff e8 7a 2f 16 00 e8 55 8b 1b 00 41 56 9d e9 aa fd ff ff e8 68 2f 16 00 e8 43 8b 1b 00 41 56 9d <e9> 2a ff ff ff 90 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 f5 53 48
> RSP: 0018:ffff8881d5f8fab8 EFLAGS: 00000293 ORIG_RAX: ffffffffffffff13
> RAX: 0000000000000007 RBX: 0000000000000200 RCX: 1ffffffff1270ab2
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8881d5aeeb7c
> RBP: ffff8881d5f8fb00 R08: 0000000000000001 R09: fffffbfff126c8c8
> R10: ffffffff8936463f R11: fffffbfff126c8c7 R12: 000000000000002a
> R13: ffff8881d5e48000 R14: 0000000000000293 R15: 0000000000000000
>  vprintk_func+0x75/0x113 kernel/printk/printk_safe.c:385
>  printk+0xba/0xed kernel/printk/printk.c:2081
>  ath9k_htc_hw_init.cold+0x17/0x2a drivers/net/wireless/ath/ath9k/htc_hst.c:502
>  ath9k_hif_usb_firmware_cb+0x274/0x510 drivers/net/wireless/ath/ath9k/hif_usb.c:1187
>  request_firmware_work_func+0x126/0x242 drivers/base/firmware_loader/main.c:1005
>  process_one_work+0x965/0x1630 kernel/workqueue.c:2268
>  worker_thread+0x96/0xe20 kernel/workqueue.c:2414
>  kthread+0x326/0x430 kernel/kthread.c:268
>  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:351
>
> Allocated by task 147:
>  save_stack+0x1b/0x40 mm/kasan/common.c:49
>  set_track mm/kasan/common.c:57 [inline]
>  __kasan_kmalloc mm/kasan/common.c:495 [inline]
>  __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:468
>  slab_post_alloc_hook mm/slab.h:586 [inline]
>  slab_alloc_node mm/slub.c:2797 [inline]
>  slab_alloc mm/slub.c:2805 [inline]
>  kmem_cache_alloc+0xd8/0x300 mm/slub.c:2810
>  getname_flags fs/namei.c:138 [inline]
>  getname_flags+0xd2/0x5b0 fs/namei.c:128
>  user_path_at_empty+0x2a/0x50 fs/namei.c:2632
>  user_path_at include/linux/namei.h:59 [inline]
>  vfs_statx+0x119/0x1e0 fs/stat.c:197
>  vfs_lstat include/linux/fs.h:3284 [inline]
>  __do_sys_newlstat+0x96/0x120 fs/stat.c:364
>  do_syscall_64+0xb6/0x5a0 arch/x86/entry/common.c:295
>  entry_SYSCALL_64_after_hwframe+0x49/0xb3
>
> Freed by task 147:
>  save_stack+0x1b/0x40 mm/kasan/common.c:49
>  set_track mm/kasan/common.c:57 [inline]
>  kasan_set_free_info mm/kasan/common.c:317 [inline]
>  __kasan_slab_free+0x117/0x160 mm/kasan/common.c:456
>  slab_free_hook mm/slub.c:1455 [inline]
>  slab_free_freelist_hook mm/slub.c:1488 [inline]
>  slab_free mm/slub.c:3045 [inline]
>  kmem_cache_free+0x9b/0x360 mm/slub.c:3061
>  putname+0xe1/0x120 fs/namei.c:259
>  filename_lookup+0x282/0x3e0 fs/namei.c:2362
>  user_path_at include/linux/namei.h:59 [inline]
>  vfs_statx+0x119/0x1e0 fs/stat.c:197
>  vfs_lstat include/linux/fs.h:3284 [inline]
>  __do_sys_newlstat+0x96/0x120 fs/stat.c:364
>  do_syscall_64+0xb6/0x5a0 arch/x86/entry/common.c:295
>  entry_SYSCALL_64_after_hwframe+0x49/0xb3
>
> The buggy address belongs to the object at ffff8881cca0b300
>  which belongs to the cache names_cache of size 4096
> The buggy address is located 3548 bytes inside of
>  4096-byte region [ffff8881cca0b300, ffff8881cca0c300)
> The buggy address belongs to the page:
> page:ffffea0007328200 refcount:1 mapcount:0 mapping:0000000063d385a8 index:0x0 head:ffffea0007328200 order:3 compound_mapcount:0 compound_pincount:0
> flags: 0x200000000010200(slab|head)
> raw: 0200000000010200 dead000000000100 dead000000000122 ffff8881da11e000
> raw: 0000000000000000 0000000000070007 00000001ffffffff 0000000000000000
> page dumped because: kasan: bad access detected
>
> Memory state around the buggy address:
>  ffff8881cca0bf80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff8881cca0c000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> >ffff8881cca0c080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                                                     ^
>  ffff8881cca0c100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff8881cca0c180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
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

#syz dup: KASAN: stack-out-of-bounds Write in ath9k_hif_usb_rx_cb
