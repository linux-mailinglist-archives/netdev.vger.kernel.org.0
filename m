Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93ADB50BEA
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 15:24:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731079AbfFXNYe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 09:24:34 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:39994 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728635AbfFXNYd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 09:24:33 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id A2B2D60D35; Mon, 24 Jun 2019 13:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1561382672;
        bh=nFcGEbZcTkvmOSyEkEviWoSgX4LYhTdkIGi80b7j/pE=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=H06CjTkxt7ZLBbVY5ZjRqN54RzrMndZHgmNV5H3VeSNr3xXlzHf6g5jfRIdp/58a/
         hgvsi2DuTJQ0eLZrprg32HrZUs/9LR9sllERlpOa+5dcKIrsDeTl4Oanm77mHVsFuc
         v9CFN12qLPWm+7NcUdEAFx9gAr/N8EjcIWHJC3SM=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 14E3F607DE;
        Mon, 24 Jun 2019 13:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1561382669;
        bh=nFcGEbZcTkvmOSyEkEviWoSgX4LYhTdkIGi80b7j/pE=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=gqG7YnqdeXqEoCkwnT9mzxN9E9OmD+C52BZr7/1ToNn09m04ST35+RShL2Ie6YeY0
         BzjYnXOC58v2XBtPgneIeD7wApDSX07rTUNMHm0djr2OXkRjH+bL6q+RM7skjmMm19
         jMlZEKi9FABS8nidUEy3eenOdVDHdbF8MVV/Bh0M=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 14E3F607DE
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Andrey Konovalov <andreyknvl@google.com>
Cc:     Christian Lamparter <chunkeey@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        syzbot <syzbot+6d237e74cdc13f036473@syzkaller.appspotmail.com>,
        Christian Lamparter <chunkeey@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        linux-wireless@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Subject: Re: KASAN: slab-out-of-bounds Read in p54u_load_firmware_cb
References: <Pine.LNX.4.44L0.1906201544001.1346-100000@iolanthe.rowland.org>
        <3232861.cjm3rXpEJU@debian64>
        <CAAeHK+zhcgmBQT=rdHaCMu7XWPz4o1gwzCJQEXiTEW9_iUUauA@mail.gmail.com>
Date:   Mon, 24 Jun 2019 16:24:23 +0300
In-Reply-To: <CAAeHK+zhcgmBQT=rdHaCMu7XWPz4o1gwzCJQEXiTEW9_iUUauA@mail.gmail.com>
        (Andrey Konovalov's message of "Mon, 24 Jun 2019 13:51:29 +0200")
Message-ID: <87d0j3t8u0.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrey Konovalov <andreyknvl@google.com> writes:

> On Thu, Jun 20, 2019 at 9:56 PM Christian Lamparter <chunkeey@gmail.com> wrote:
>>
>> On Thursday, June 20, 2019 9:46:32 PM CEST Alan Stern wrote:
>> > On Wed, 19 Jun 2019, syzbot wrote:
>> >
>> > > syzbot has found a reproducer for the following crash on:
>> > >
>> > > HEAD commit:    9939f56e usb-fuzzer: main usb gadget fuzzer driver
>> > > git tree:       https://github.com/google/kasan.git usb-fuzzer
>> > > console output: https://syzkaller.appspot.com/x/log.txt?x=135e29faa00000
>> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=df134eda130bb43a
>> > > dashboard link: https://syzkaller.appspot.com/bug?extid=6d237e74cdc13f036473
>> > > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
>> > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=175d946ea00000
>> > >
>> > > IMPORTANT: if you fix the bug, please add the following tag to the commit:
>> > > Reported-by: syzbot+6d237e74cdc13f036473@syzkaller.appspotmail.com
>> > >
>> > > usb 3-1: Direct firmware load for isl3887usb failed with error -2
>> > > usb 3-1: Firmware not found.
>> > > ==================================================================
>> > > BUG: KASAN: slab-out-of-bounds in p54u_load_firmware_cb.cold+0x97/0x13d
>> > > drivers/net/wireless/intersil/p54/p54usb.c:936
>> > > Read of size 8 at addr ffff8881c9cf7588 by task kworker/1:5/2759
>> > >
>> > > CPU: 1 PID: 2759 Comm: kworker/1:5 Not tainted 5.2.0-rc5+ #11
>> > > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
>> > > Google 01/01/2011
>> > > Workqueue: events request_firmware_work_func
>> > > Call Trace:
>> > >   __dump_stack lib/dump_stack.c:77 [inline]
>> > >   dump_stack+0xca/0x13e lib/dump_stack.c:113
>> > >   print_address_description+0x67/0x231 mm/kasan/report.c:188
>> > >   __kasan_report.cold+0x1a/0x32 mm/kasan/report.c:317
>> > >   kasan_report+0xe/0x20 mm/kasan/common.c:614
>> > >   p54u_load_firmware_cb.cold+0x97/0x13d
>> > > drivers/net/wireless/intersil/p54/p54usb.c:936
>> > >   request_firmware_work_func+0x126/0x242
>> > > drivers/base/firmware_loader/main.c:785
>> > >   process_one_work+0x905/0x1570 kernel/workqueue.c:2269
>> > >   worker_thread+0x96/0xe20 kernel/workqueue.c:2415
>> > >   kthread+0x30b/0x410 kernel/kthread.c:255
>> > >   ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
>> > >
>> > > Allocated by task 1612:
>> > >   save_stack+0x1b/0x80 mm/kasan/common.c:71
>> > >   set_track mm/kasan/common.c:79 [inline]
>> > >   __kasan_kmalloc mm/kasan/common.c:489 [inline]
>> > >   __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:462
>> > >   kmalloc include/linux/slab.h:547 [inline]
>> > >   syslog_print kernel/printk/printk.c:1346 [inline]
>> > >   do_syslog kernel/printk/printk.c:1519 [inline]
>> > >   do_syslog+0x4f4/0x12e0 kernel/printk/printk.c:1493
>> > >   kmsg_read+0x8a/0xb0 fs/proc/kmsg.c:40
>> > >   proc_reg_read+0x1c1/0x280 fs/proc/inode.c:221
>> > >   __vfs_read+0x76/0x100 fs/read_write.c:425
>> > >   vfs_read+0x18e/0x3d0 fs/read_write.c:461
>> > >   ksys_read+0x127/0x250 fs/read_write.c:587
>> > >   do_syscall_64+0xb7/0x560 arch/x86/entry/common.c:301
>> > >   entry_SYSCALL_64_after_hwframe+0x49/0xbe
>> > >
>> > > Freed by task 1612:
>> > >   save_stack+0x1b/0x80 mm/kasan/common.c:71
>> > >   set_track mm/kasan/common.c:79 [inline]
>> > >   __kasan_slab_free+0x130/0x180 mm/kasan/common.c:451
>> > >   slab_free_hook mm/slub.c:1421 [inline]
>> > >   slab_free_freelist_hook mm/slub.c:1448 [inline]
>> > >   slab_free mm/slub.c:2994 [inline]
>> > >   kfree+0xd7/0x280 mm/slub.c:3949
>> > >   syslog_print kernel/printk/printk.c:1405 [inline]
>> > >   do_syslog kernel/printk/printk.c:1519 [inline]
>> > >   do_syslog+0xff3/0x12e0 kernel/printk/printk.c:1493
>> > >   kmsg_read+0x8a/0xb0 fs/proc/kmsg.c:40
>> > >   proc_reg_read+0x1c1/0x280 fs/proc/inode.c:221
>> > >   __vfs_read+0x76/0x100 fs/read_write.c:425
>> > >   vfs_read+0x18e/0x3d0 fs/read_write.c:461
>> > >   ksys_read+0x127/0x250 fs/read_write.c:587
>> > >   do_syscall_64+0xb7/0x560 arch/x86/entry/common.c:301
>> > >   entry_SYSCALL_64_after_hwframe+0x49/0xbe
>> > >
>> > > The buggy address belongs to the object at ffff8881c9cf7180
>> > >   which belongs to the cache kmalloc-1k of size 1024
>> > > The buggy address is located 8 bytes to the right of
>> > >   1024-byte region [ffff8881c9cf7180, ffff8881c9cf7580)
>> > > The buggy address belongs to the page:
>> > > page:ffffea0007273d00 refcount:1 mapcount:0 mapping:ffff8881dac02a00
>> > > index:0x0 compound_mapcount: 0
>> > > flags: 0x200000000010200(slab|head)
>> > > raw: 0200000000010200 dead000000000100 dead000000000200 ffff8881dac02a00
>> > > raw: 0000000000000000 00000000000e000e 00000001ffffffff 0000000000000000
>> > > page dumped because: kasan: bad access detected
>> > >
>> > > Memory state around the buggy address:
>> > >   ffff8881c9cf7480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>> > >   ffff8881c9cf7500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>> > > > ffff8881c9cf7580: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>> > >                        ^
>> > >   ffff8881c9cf7600: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>> > >   ffff8881c9cf7680: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>> > > ==================================================================
>> >
>> > Isn't this the same as syzkaller bug 200d4bb11b23d929335f ?  Doesn't
>> > the same patch fix it?
>> >
>> I think Kalle hasn't applied it yet? It's still sitting on the patchwork queue:
>> <https://patchwork.kernel.org/patch/10951527/>
>
> Yes, until this patch is in the tree that is being tested (which is
> based on the usb-linus branch; I update it every few weeks), syzbot
> considers this bug as open.

I'm hoping to apply this today or tomorrow.

-- 
Kalle Valo
