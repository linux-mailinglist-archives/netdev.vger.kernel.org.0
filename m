Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE2F08BA24
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 15:28:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728930AbfHMN2L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 09:28:11 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:37432 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728134AbfHMN2I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 09:28:08 -0400
Received: by mail-pf1-f193.google.com with SMTP id 129so4705380pfa.4
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 06:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:cc;
        bh=OUnI5qShYtHQYww3X1RCBrfCURbBQ7wCunEPYxXRUns=;
        b=nWLJmN3XZAPFpmXl7Lv98vYL2f5xide0ABgIuYQFZZy15vy2ONsAm/1UZ1JzukTcw8
         BDL9RltV2YBhTQzX/UahXxHNWCr/8Keym9JDfL3ahYwsNuC4giB2KQKu7++6dUgM8TFE
         P6qh+xMHedLkv8UeXIvk2EEtNRkgXTxPRyLvS0BFcTiKCe5pEJJKl2C9mC/eGEO3YITH
         DhjzZKGkp2ZpBHONUrIyNRZT3nllrg8L7eJ5iJLoOJ0IzAtMZO7BcMylAdEVx6QlokCn
         a0MZnqnB0LTfx2UOYhlbfsLSiPNmhvVBO8Kverf0iE+bOYedAXdiln/RagrrcmBCM8QZ
         QwwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:cc;
        bh=OUnI5qShYtHQYww3X1RCBrfCURbBQ7wCunEPYxXRUns=;
        b=BMPvRAeWVAa5UvwtVXgyTjWYpFDdsu6erLg7J3ANEQB/H3JAS7/E7EJ8fxJzqY8TUB
         cWR7OD1Tu0Bt7b4uFl9x3L+XP2P5EiuiDOe//YI4vIWDw8JjtAlW3RErSD8mmmnB6sey
         pXd26AKVT2IU/7gjjw96WXESJqTqRIbYt6uSlPCvJDwokFnhygQvzqzpYaeaiXRR858L
         JidEhm68zPKj/zt2CirvZfRixWM36Z+n7QPGoMiDiKFr17JwqUjkQ4JDZ+JyG+c7S+Ut
         rWccrCV5oqVxIIXPolgZXYYka9aQ2lMEPaXpGoHXf919kxSwuiiLSdEedfUIdiccodN9
         iLWA==
X-Gm-Message-State: APjAAAWiuhOVczTpiUCZcwPm4fsdLYQmqK0F6ZolGhD2sDEs1hU7s99r
        s5nAGbQtgdPV0T7wrSAFFgxDMbDXJeLGON6bBokWvw==
X-Received: by 2002:a17:90a:a116:: with SMTP id s22mt2038036pjp.47.1565702886660;
 Tue, 13 Aug 2019 06:28:06 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000f00cf1058bb7fb56@google.com> <Pine.LNX.4.44L0.1906201544001.1346-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1906201544001.1346-100000@iolanthe.rowland.org>
From:   Andrey Konovalov <andreyknvl@google.com>
Date:   Tue, 13 Aug 2019 15:27:55 +0200
Message-ID: <CAAeHK+zV84yDuXRL6TAiC9LW_kQQ0c1hgynNFw5aY+ofHAE85g@mail.gmail.com>
Subject: Re: KASAN: slab-out-of-bounds Read in p54u_load_firmware_cb
Cc:     syzbot <syzbot+6d237e74cdc13f036473@syzkaller.appspotmail.com>,
        Christian Lamparter <chunkeey@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        linux-wireless@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Alan Stern <stern@rowland.harvard.edu>
Content-Type: text/plain; charset="UTF-8"
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 20, 2019 at 9:46 PM Alan Stern <stern@rowland.harvard.edu> wrote:
>
> On Wed, 19 Jun 2019, syzbot wrote:
>
> > syzbot has found a reproducer for the following crash on:
> >
> > HEAD commit:    9939f56e usb-fuzzer: main usb gadget fuzzer driver
> > git tree:       https://github.com/google/kasan.git usb-fuzzer
> > console output: https://syzkaller.appspot.com/x/log.txt?x=135e29faa00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=df134eda130bb43a
> > dashboard link: https://syzkaller.appspot.com/bug?extid=6d237e74cdc13f036473
> > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=175d946ea00000
> >
> > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > Reported-by: syzbot+6d237e74cdc13f036473@syzkaller.appspotmail.com
> >
> > usb 3-1: Direct firmware load for isl3887usb failed with error -2
> > usb 3-1: Firmware not found.
> > ==================================================================
> > BUG: KASAN: slab-out-of-bounds in p54u_load_firmware_cb.cold+0x97/0x13d
> > drivers/net/wireless/intersil/p54/p54usb.c:936
> > Read of size 8 at addr ffff8881c9cf7588 by task kworker/1:5/2759
> >
> > CPU: 1 PID: 2759 Comm: kworker/1:5 Not tainted 5.2.0-rc5+ #11
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> > Google 01/01/2011
> > Workqueue: events request_firmware_work_func
> > Call Trace:
> >   __dump_stack lib/dump_stack.c:77 [inline]
> >   dump_stack+0xca/0x13e lib/dump_stack.c:113
> >   print_address_description+0x67/0x231 mm/kasan/report.c:188
> >   __kasan_report.cold+0x1a/0x32 mm/kasan/report.c:317
> >   kasan_report+0xe/0x20 mm/kasan/common.c:614
> >   p54u_load_firmware_cb.cold+0x97/0x13d
> > drivers/net/wireless/intersil/p54/p54usb.c:936
> >   request_firmware_work_func+0x126/0x242
> > drivers/base/firmware_loader/main.c:785
> >   process_one_work+0x905/0x1570 kernel/workqueue.c:2269
> >   worker_thread+0x96/0xe20 kernel/workqueue.c:2415
> >   kthread+0x30b/0x410 kernel/kthread.c:255
> >   ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
> >
> > Allocated by task 1612:
> >   save_stack+0x1b/0x80 mm/kasan/common.c:71
> >   set_track mm/kasan/common.c:79 [inline]
> >   __kasan_kmalloc mm/kasan/common.c:489 [inline]
> >   __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:462
> >   kmalloc include/linux/slab.h:547 [inline]
> >   syslog_print kernel/printk/printk.c:1346 [inline]
> >   do_syslog kernel/printk/printk.c:1519 [inline]
> >   do_syslog+0x4f4/0x12e0 kernel/printk/printk.c:1493
> >   kmsg_read+0x8a/0xb0 fs/proc/kmsg.c:40
> >   proc_reg_read+0x1c1/0x280 fs/proc/inode.c:221
> >   __vfs_read+0x76/0x100 fs/read_write.c:425
> >   vfs_read+0x18e/0x3d0 fs/read_write.c:461
> >   ksys_read+0x127/0x250 fs/read_write.c:587
> >   do_syscall_64+0xb7/0x560 arch/x86/entry/common.c:301
> >   entry_SYSCALL_64_after_hwframe+0x49/0xbe
> >
> > Freed by task 1612:
> >   save_stack+0x1b/0x80 mm/kasan/common.c:71
> >   set_track mm/kasan/common.c:79 [inline]
> >   __kasan_slab_free+0x130/0x180 mm/kasan/common.c:451
> >   slab_free_hook mm/slub.c:1421 [inline]
> >   slab_free_freelist_hook mm/slub.c:1448 [inline]
> >   slab_free mm/slub.c:2994 [inline]
> >   kfree+0xd7/0x280 mm/slub.c:3949
> >   syslog_print kernel/printk/printk.c:1405 [inline]
> >   do_syslog kernel/printk/printk.c:1519 [inline]
> >   do_syslog+0xff3/0x12e0 kernel/printk/printk.c:1493
> >   kmsg_read+0x8a/0xb0 fs/proc/kmsg.c:40
> >   proc_reg_read+0x1c1/0x280 fs/proc/inode.c:221
> >   __vfs_read+0x76/0x100 fs/read_write.c:425
> >   vfs_read+0x18e/0x3d0 fs/read_write.c:461
> >   ksys_read+0x127/0x250 fs/read_write.c:587
> >   do_syscall_64+0xb7/0x560 arch/x86/entry/common.c:301
> >   entry_SYSCALL_64_after_hwframe+0x49/0xbe
> >
> > The buggy address belongs to the object at ffff8881c9cf7180
> >   which belongs to the cache kmalloc-1k of size 1024
> > The buggy address is located 8 bytes to the right of
> >   1024-byte region [ffff8881c9cf7180, ffff8881c9cf7580)
> > The buggy address belongs to the page:
> > page:ffffea0007273d00 refcount:1 mapcount:0 mapping:ffff8881dac02a00
> > index:0x0 compound_mapcount: 0
> > flags: 0x200000000010200(slab|head)
> > raw: 0200000000010200 dead000000000100 dead000000000200 ffff8881dac02a00
> > raw: 0000000000000000 00000000000e000e 00000001ffffffff 0000000000000000
> > page dumped because: kasan: bad access detected
> >
> > Memory state around the buggy address:
> >   ffff8881c9cf7480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> >   ffff8881c9cf7500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> > > ffff8881c9cf7580: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> >                        ^
> >   ffff8881c9cf7600: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> >   ffff8881c9cf7680: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> > ==================================================================
>
> Isn't this the same as syzkaller bug 200d4bb11b23d929335f ?  Doesn't
> the same patch fix it?

#syz dup: KASAN: use-after-free Read in p54u_load_firmware_cb
