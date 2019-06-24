Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA4B750A27
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 13:51:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729851AbfFXLvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 07:51:42 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:41139 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729550AbfFXLvl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 07:51:41 -0400
Received: by mail-pg1-f196.google.com with SMTP id y72so6980752pgd.8
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 04:51:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MktjD5JI8plrPxYgdY28dSdky16sGE3yFJlzutMBX0Y=;
        b=E42AtJYYKS3gX+CavKLFlDYVVNCoSjuykLZUIN+uEWysOmPvEjowAsUCoL+p4bxDLD
         CHrahBaSZ/AaA1XqTklaYxmNdWwMTuqFhUEj3ACVySVr6cSwog2yQK7SJYe9SJf+1fsu
         Jxg5XidlAQWXCtiklfCS+OOJ1RsXwjtQbu8IAX5dtex3bFVNMHklYhUWj3x0K3TIwpv7
         HKzvKlb0UyYUk6dO+GP0wKxTbQ6mWivHViXlIhnXA1+Bye+t0Pe7wiPpiviOP4TFKtF+
         5ep5I5d21sivYG84h7gout7eJagMVCFuQ5RU2JOUJgT/iicMTHgAKyAYWUnWJcbS4xSb
         SGOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MktjD5JI8plrPxYgdY28dSdky16sGE3yFJlzutMBX0Y=;
        b=XBeJK+kKygOEbcWCfntIczLGvvcVGQPD8/Myy/yLarFbgyqMRUr2YzkMwZdgZxnJvw
         8JwWPyGfiVD5r/CKpVufHETKe/Ag5NQTlMLNhQtDhs+ybUiB1WBZFUD/+mpGzcM0FONW
         dpaGv89/B/TR1S8n4hDlQSUKOBKfxsf/g1eCYOy2p83VBlSpRCxZlEZ4RnNZkpt8gFgo
         LXLukP8epLnrcexfGhSG5KSE0UuC8eZRscHkmu3fOPS4a9Gh0Xyg6Pf/8G90+wE11bzD
         tE7wvpNZEd7Fqqm5ZG9imMVZ+Bk1hICRWwGbjQ9P+SVpdOSspKpVu9ay9qJDag3zC62m
         loEQ==
X-Gm-Message-State: APjAAAWCAEK/+vF3W7ejVM64fA41IMgP/aGq2hhI1EvnnEfRHO8WIA0o
        U/3vVfL5ak1X/Od+k3LiknOlmljSmNT8r6f1iuGbLQ==
X-Google-Smtp-Source: APXvYqz5xbtBgSv9XKplkSawe6nghKkaroCsUJSXThEB/hnFaWvNPzkCZMYZkuMEAbHjzcChr/ODQWoaTLNZKz32Dw4=
X-Received: by 2002:a17:90a:a116:: with SMTP id s22mr24124967pjp.47.1561377100565;
 Mon, 24 Jun 2019 04:51:40 -0700 (PDT)
MIME-Version: 1.0
References: <Pine.LNX.4.44L0.1906201544001.1346-100000@iolanthe.rowland.org> <3232861.cjm3rXpEJU@debian64>
In-Reply-To: <3232861.cjm3rXpEJU@debian64>
From:   Andrey Konovalov <andreyknvl@google.com>
Date:   Mon, 24 Jun 2019 13:51:29 +0200
Message-ID: <CAAeHK+zhcgmBQT=rdHaCMu7XWPz4o1gwzCJQEXiTEW9_iUUauA@mail.gmail.com>
Subject: Re: KASAN: slab-out-of-bounds Read in p54u_load_firmware_cb
To:     Christian Lamparter <chunkeey@gmail.com>
Cc:     Alan Stern <stern@rowland.harvard.edu>,
        syzbot <syzbot+6d237e74cdc13f036473@syzkaller.appspotmail.com>,
        Christian Lamparter <chunkeey@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        linux-wireless@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 20, 2019 at 9:56 PM Christian Lamparter <chunkeey@gmail.com> wrote:
>
> On Thursday, June 20, 2019 9:46:32 PM CEST Alan Stern wrote:
> > On Wed, 19 Jun 2019, syzbot wrote:
> >
> > > syzbot has found a reproducer for the following crash on:
> > >
> > > HEAD commit:    9939f56e usb-fuzzer: main usb gadget fuzzer driver
> > > git tree:       https://github.com/google/kasan.git usb-fuzzer
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=135e29faa00000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=df134eda130bb43a
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=6d237e74cdc13f036473
> > > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=175d946ea00000
> > >
> > > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > > Reported-by: syzbot+6d237e74cdc13f036473@syzkaller.appspotmail.com
> > >
> > > usb 3-1: Direct firmware load for isl3887usb failed with error -2
> > > usb 3-1: Firmware not found.
> > > ==================================================================
> > > BUG: KASAN: slab-out-of-bounds in p54u_load_firmware_cb.cold+0x97/0x13d
> > > drivers/net/wireless/intersil/p54/p54usb.c:936
> > > Read of size 8 at addr ffff8881c9cf7588 by task kworker/1:5/2759
> > >
> > > CPU: 1 PID: 2759 Comm: kworker/1:5 Not tainted 5.2.0-rc5+ #11
> > > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> > > Google 01/01/2011
> > > Workqueue: events request_firmware_work_func
> > > Call Trace:
> > >   __dump_stack lib/dump_stack.c:77 [inline]
> > >   dump_stack+0xca/0x13e lib/dump_stack.c:113
> > >   print_address_description+0x67/0x231 mm/kasan/report.c:188
> > >   __kasan_report.cold+0x1a/0x32 mm/kasan/report.c:317
> > >   kasan_report+0xe/0x20 mm/kasan/common.c:614
> > >   p54u_load_firmware_cb.cold+0x97/0x13d
> > > drivers/net/wireless/intersil/p54/p54usb.c:936
> > >   request_firmware_work_func+0x126/0x242
> > > drivers/base/firmware_loader/main.c:785
> > >   process_one_work+0x905/0x1570 kernel/workqueue.c:2269
> > >   worker_thread+0x96/0xe20 kernel/workqueue.c:2415
> > >   kthread+0x30b/0x410 kernel/kthread.c:255
> > >   ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
> > >
> > > Allocated by task 1612:
> > >   save_stack+0x1b/0x80 mm/kasan/common.c:71
> > >   set_track mm/kasan/common.c:79 [inline]
> > >   __kasan_kmalloc mm/kasan/common.c:489 [inline]
> > >   __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:462
> > >   kmalloc include/linux/slab.h:547 [inline]
> > >   syslog_print kernel/printk/printk.c:1346 [inline]
> > >   do_syslog kernel/printk/printk.c:1519 [inline]
> > >   do_syslog+0x4f4/0x12e0 kernel/printk/printk.c:1493
> > >   kmsg_read+0x8a/0xb0 fs/proc/kmsg.c:40
> > >   proc_reg_read+0x1c1/0x280 fs/proc/inode.c:221
> > >   __vfs_read+0x76/0x100 fs/read_write.c:425
> > >   vfs_read+0x18e/0x3d0 fs/read_write.c:461
> > >   ksys_read+0x127/0x250 fs/read_write.c:587
> > >   do_syscall_64+0xb7/0x560 arch/x86/entry/common.c:301
> > >   entry_SYSCALL_64_after_hwframe+0x49/0xbe
> > >
> > > Freed by task 1612:
> > >   save_stack+0x1b/0x80 mm/kasan/common.c:71
> > >   set_track mm/kasan/common.c:79 [inline]
> > >   __kasan_slab_free+0x130/0x180 mm/kasan/common.c:451
> > >   slab_free_hook mm/slub.c:1421 [inline]
> > >   slab_free_freelist_hook mm/slub.c:1448 [inline]
> > >   slab_free mm/slub.c:2994 [inline]
> > >   kfree+0xd7/0x280 mm/slub.c:3949
> > >   syslog_print kernel/printk/printk.c:1405 [inline]
> > >   do_syslog kernel/printk/printk.c:1519 [inline]
> > >   do_syslog+0xff3/0x12e0 kernel/printk/printk.c:1493
> > >   kmsg_read+0x8a/0xb0 fs/proc/kmsg.c:40
> > >   proc_reg_read+0x1c1/0x280 fs/proc/inode.c:221
> > >   __vfs_read+0x76/0x100 fs/read_write.c:425
> > >   vfs_read+0x18e/0x3d0 fs/read_write.c:461
> > >   ksys_read+0x127/0x250 fs/read_write.c:587
> > >   do_syscall_64+0xb7/0x560 arch/x86/entry/common.c:301
> > >   entry_SYSCALL_64_after_hwframe+0x49/0xbe
> > >
> > > The buggy address belongs to the object at ffff8881c9cf7180
> > >   which belongs to the cache kmalloc-1k of size 1024
> > > The buggy address is located 8 bytes to the right of
> > >   1024-byte region [ffff8881c9cf7180, ffff8881c9cf7580)
> > > The buggy address belongs to the page:
> > > page:ffffea0007273d00 refcount:1 mapcount:0 mapping:ffff8881dac02a00
> > > index:0x0 compound_mapcount: 0
> > > flags: 0x200000000010200(slab|head)
> > > raw: 0200000000010200 dead000000000100 dead000000000200 ffff8881dac02a00
> > > raw: 0000000000000000 00000000000e000e 00000001ffffffff 0000000000000000
> > > page dumped because: kasan: bad access detected
> > >
> > > Memory state around the buggy address:
> > >   ffff8881c9cf7480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> > >   ffff8881c9cf7500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> > > > ffff8881c9cf7580: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> > >                        ^
> > >   ffff8881c9cf7600: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> > >   ffff8881c9cf7680: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> > > ==================================================================
> >
> > Isn't this the same as syzkaller bug 200d4bb11b23d929335f ?  Doesn't
> > the same patch fix it?
> >
> I think Kalle hasn't applied it yet? It's still sitting on the patchwork queue:
> <https://patchwork.kernel.org/patch/10951527/>

Yes, until this patch is in the tree that is being tested (which is
based on the usb-linus branch; I update it every few weeks), syzbot
considers this bug as open.

>
> Regards,
> Christian
>
>
