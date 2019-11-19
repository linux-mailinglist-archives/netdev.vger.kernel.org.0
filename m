Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B178D102592
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 14:38:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727737AbfKSNiZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 08:38:25 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:45452 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727066AbfKSNiZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 08:38:25 -0500
Received: by mail-pg1-f193.google.com with SMTP id k1so10069692pgg.12
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 05:38:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IQrHD9IslVtGMqrlGFhBe8nueuJ9D5DceJCfmpUkEkI=;
        b=VYUSD85NaYB0byiucF060eB59AJCix2ZvFBUf0G24foXaNBoHXED/JKuWsLdVMLsJ9
         F67yljXL4WpnyeArbGTiooVOGrFSCt8RIElIMc78cR+iiv2IHalg2Grmll8gmSJQiOt6
         4W7fmornEPJ5adKNM/hYatKSWNjWbHA4WnxkXnzAFoYOxq/nTVonVa5RMMzX42Bu9XqG
         Q8tDr/B400+0RhxErtJTEEed/1tQYqiRyake0Xv64rBA+LOXLcYwmpqOaT1XuAGVrHb/
         C+ocmn1oebWBJ0zxKQFZ1i4HavqGpRSUnDO5fyCJPLAoqbbN8y2kpUwo1WTsRNY3e7fE
         sitw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IQrHD9IslVtGMqrlGFhBe8nueuJ9D5DceJCfmpUkEkI=;
        b=UXJHgPfp1qLX6kEEvhgWtyoJQXA5hYWl8OWH7qrWHJBOqTENt4bFGnjl/Ky1ehEDAY
         b+YFj5mgKhnKPJIci5b0GciSPyQTS3Klxskxe2bPFAV6m//W56tzTyqyShkHyqsDZ0lY
         0BkGXIy6uBHkMUbOIYR1GarAn0MsbxnflPOqe/HGfPxBRtwB1LHayAUGJW8ZHAKx2V8I
         PglFCVvZJrQsLyZxusVoHzLFIfNkY+2ocNvrILHhfqvp1QBQwP3hQXMjkcDPgE42XB7V
         uUEZ9Q6bWwpav4TVrKjtDdBkvwNzCnOV+QotJcfsC4fmMm8FOvIzAb+DANUYYgnO7Q98
         GbYw==
X-Gm-Message-State: APjAAAXgxGObs6JiMSYVoRU2cCevoFK9gFKMIxP86crU1TdoWYSFedOo
        yfbhhrIHcx/ipEYmdyCxWrFVSaQgXE06ibrxcbd/rg==
X-Google-Smtp-Source: APXvYqyAvyKnlcct+TzQIJDyCdyo5QyXsi/jFxAF8Jx7zREh+d0k7xM01KV5RyOzX6Cxwo9frSbwx43NjsliXcsNS14=
X-Received: by 2002:aa7:9ad0:: with SMTP id x16mr5918680pfp.51.1574170703810;
 Tue, 19 Nov 2019 05:38:23 -0800 (PST)
MIME-Version: 1.0
References: <0000000000005ae4cd058731d407@google.com>
In-Reply-To: <0000000000005ae4cd058731d407@google.com>
From:   Andrey Konovalov <andreyknvl@google.com>
Date:   Tue, 19 Nov 2019 14:38:11 +0100
Message-ID: <CAAeHK+wDcQpQhDp2Ajz0GOFqKcqV9E_DSNvZ8UW26BdX+T-Uug@mail.gmail.com>
Subject: Re: KASAN: invalid-free in rsi_91x_deinit
To:     syzbot <syzbot+7c72edfb407b2bd866ce@syzkaller.appspotmail.com>
Cc:     amitkarwar@gmail.com, "David S. Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        LKML <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        linux-wireless@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        siva8118@gmail.com,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 23, 2019 at 2:36 PM syzbot
<syzbot+7c72edfb407b2bd866ce@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    d34f9519 usb-fuzzer: main usb gadget fuzzer driver
> git tree:       https://github.com/google/kasan/tree/usb-fuzzer
> console output: https://syzkaller.appspot.com/x/log.txt?x=14a79403200000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=c73d1bb5aeaeae20
> dashboard link: https://syzkaller.appspot.com/bug?extid=7c72edfb407b2bd866ce
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17547247200000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=147b3a1d200000
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+7c72edfb407b2bd866ce@syzkaller.appspotmail.com
>
> usb 1-1: config 252 interface 115 altsetting 0 has 1 endpoint descriptor,
> different from the interface descriptor's value: 4
> usb 1-1: New USB device found, idVendor=1618, idProduct=9113,
> bcdDevice=32.21
> usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> rsi_91x: rsi_probe: Failed to init usb interface
> ==================================================================
> BUG: KASAN: double-free or invalid-free in slab_free mm/slub.c:3003 [inline]
> BUG: KASAN: double-free or invalid-free in kfree+0xce/0x280 mm/slub.c:3958
>
> CPU: 0 PID: 12 Comm: kworker/0:1 Not tainted 5.1.0-rc5-319617-gd34f951 #4
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> Workqueue: usb_hub_wq hub_event
> Call Trace:
>   __dump_stack lib/dump_stack.c:77 [inline]
>   dump_stack+0xe8/0x16e lib/dump_stack.c:113
>   print_address_description+0x6c/0x236 mm/kasan/report.c:187
>   kasan_report_invalid_free+0x66/0xa0 mm/kasan/report.c:278
>   __kasan_slab_free+0x162/0x180 mm/kasan/common.c:438
>   slab_free_hook mm/slub.c:1429 [inline]
>   slab_free_freelist_hook+0x5e/0x140 mm/slub.c:1456
>   slab_free mm/slub.c:3003 [inline]
>   kfree+0xce/0x280 mm/slub.c:3958
>   rsi_91x_deinit+0x27b/0x300 drivers/net/wireless/rsi/rsi_91x_main.c:407
>   rsi_probe+0xdf3/0x140d drivers/net/wireless/rsi/rsi_91x_sdio.c:1178
>   usb_probe_interface+0x31d/0x820 drivers/usb/core/driver.c:361
>   really_probe+0x2da/0xb10 drivers/base/dd.c:509
>   driver_probe_device+0x21d/0x350 drivers/base/dd.c:671
>   __device_attach_driver+0x1d8/0x290 drivers/base/dd.c:778
>   bus_for_each_drv+0x163/0x1e0 drivers/base/bus.c:454
>   __device_attach+0x223/0x3a0 drivers/base/dd.c:844
>   bus_probe_device+0x1f1/0x2a0 drivers/base/bus.c:514
>   device_add+0xad2/0x16e0 drivers/base/core.c:2106
>   usb_set_configuration+0xdf7/0x1740 drivers/usb/core/message.c:2021
>   generic_probe+0xa2/0xda drivers/usb/core/generic.c:210
>   usb_probe_device+0xc0/0x150 drivers/usb/core/driver.c:266
>   really_probe+0x2da/0xb10 drivers/base/dd.c:509
>   driver_probe_device+0x21d/0x350 drivers/base/dd.c:671
>   __device_attach_driver+0x1d8/0x290 drivers/base/dd.c:778
>   bus_for_each_drv+0x163/0x1e0 drivers/base/bus.c:454
>   __device_attach+0x223/0x3a0 drivers/base/dd.c:844
>   bus_probe_device+0x1f1/0x2a0 drivers/base/bus.c:514
>   device_add+0xad2/0x16e0 drivers/base/core.c:2106
>   usb_new_device.cold+0x537/0xccf drivers/usb/core/hub.c:2534
>   hub_port_connect drivers/usb/core/hub.c:5089 [inline]
>   hub_port_connect_change drivers/usb/core/hub.c:5204 [inline]
>   port_event drivers/usb/core/hub.c:5350 [inline]
>   hub_event+0x1398/0x3b00 drivers/usb/core/hub.c:5432
>   process_one_work+0x90f/0x1580 kernel/workqueue.c:2269
>   worker_thread+0x9b/0xe20 kernel/workqueue.c:2415
>   kthread+0x313/0x420 kernel/kthread.c:253
>   ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:352
>
> Allocated by task 12:
>   set_track mm/kasan/common.c:87 [inline]
>   __kasan_kmalloc mm/kasan/common.c:497 [inline]
>   __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:470
>   rsi_init_sdio_interface drivers/net/wireless/rsi/rsi_91x_sdio.c:853
> [inline]
>   rsi_probe+0x11a/0x140d drivers/net/wireless/rsi/rsi_91x_sdio.c:965
>   usb_probe_interface+0x31d/0x820 drivers/usb/core/driver.c:361
>   really_probe+0x2da/0xb10 drivers/base/dd.c:509
>   driver_probe_device+0x21d/0x350 drivers/base/dd.c:671
>   __device_attach_driver+0x1d8/0x290 drivers/base/dd.c:778
>   bus_for_each_drv+0x163/0x1e0 drivers/base/bus.c:454
>   __device_attach+0x223/0x3a0 drivers/base/dd.c:844
>   bus_probe_device+0x1f1/0x2a0 drivers/base/bus.c:514
>   device_add+0xad2/0x16e0 drivers/base/core.c:2106
>   usb_set_configuration+0xdf7/0x1740 drivers/usb/core/message.c:2021
>   generic_probe+0xa2/0xda drivers/usb/core/generic.c:210
>   usb_probe_device+0xc0/0x150 drivers/usb/core/driver.c:266
>   really_probe+0x2da/0xb10 drivers/base/dd.c:509
>   driver_probe_device+0x21d/0x350 drivers/base/dd.c:671
>   __device_attach_driver+0x1d8/0x290 drivers/base/dd.c:778
>   bus_for_each_drv+0x163/0x1e0 drivers/base/bus.c:454
>   __device_attach+0x223/0x3a0 drivers/base/dd.c:844
>   bus_probe_device+0x1f1/0x2a0 drivers/base/bus.c:514
>   device_add+0xad2/0x16e0 drivers/base/core.c:2106
>   usb_new_device.cold+0x537/0xccf drivers/usb/core/hub.c:2534
>   hub_port_connect drivers/usb/core/hub.c:5089 [inline]
>   hub_port_connect_change drivers/usb/core/hub.c:5204 [inline]
>   port_event drivers/usb/core/hub.c:5350 [inline]
>   hub_event+0x1398/0x3b00 drivers/usb/core/hub.c:5432
>   process_one_work+0x90f/0x1580 kernel/workqueue.c:2269
>   worker_thread+0x9b/0xe20 kernel/workqueue.c:2415
>   kthread+0x313/0x420 kernel/kthread.c:253
>   ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:352
>
> Freed by task 12:
>   set_track mm/kasan/common.c:87 [inline]
>   __kasan_slab_free+0x130/0x180 mm/kasan/common.c:459
>   slab_free_hook mm/slub.c:1429 [inline]
>   slab_free_freelist_hook+0x5e/0x140 mm/slub.c:1456
>   slab_free mm/slub.c:3003 [inline]
>   kfree+0xce/0x280 mm/slub.c:3958
>   rsi_probe+0xf04/0x140d drivers/net/wireless/rsi/rsi_91x_sdio.c:1196
>   usb_probe_interface+0x31d/0x820 drivers/usb/core/driver.c:361
>   really_probe+0x2da/0xb10 drivers/base/dd.c:509
>   driver_probe_device+0x21d/0x350 drivers/base/dd.c:671
>   __device_attach_driver+0x1d8/0x290 drivers/base/dd.c:778
>   bus_for_each_drv+0x163/0x1e0 drivers/base/bus.c:454
>   __device_attach+0x223/0x3a0 drivers/base/dd.c:844
>   bus_probe_device+0x1f1/0x2a0 drivers/base/bus.c:514
>   device_add+0xad2/0x16e0 drivers/base/core.c:2106
>   usb_set_configuration+0xdf7/0x1740 drivers/usb/core/message.c:2021
>   generic_probe+0xa2/0xda drivers/usb/core/generic.c:210
>   usb_probe_device+0xc0/0x150 drivers/usb/core/driver.c:266
>   really_probe+0x2da/0xb10 drivers/base/dd.c:509
>   driver_probe_device+0x21d/0x350 drivers/base/dd.c:671
>   __device_attach_driver+0x1d8/0x290 drivers/base/dd.c:778
>   bus_for_each_drv+0x163/0x1e0 drivers/base/bus.c:454
>   __device_attach+0x223/0x3a0 drivers/base/dd.c:844
>   bus_probe_device+0x1f1/0x2a0 drivers/base/bus.c:514
>   device_add+0xad2/0x16e0 drivers/base/core.c:2106
>   usb_new_device.cold+0x537/0xccf drivers/usb/core/hub.c:2534
>   hub_port_connect drivers/usb/core/hub.c:5089 [inline]
>   hub_port_connect_change drivers/usb/core/hub.c:5204 [inline]
>   port_event drivers/usb/core/hub.c:5350 [inline]
>   hub_event+0x1398/0x3b00 drivers/usb/core/hub.c:5432
>   process_one_work+0x90f/0x1580 kernel/workqueue.c:2269
>   worker_thread+0x9b/0xe20 kernel/workqueue.c:2415
>   kthread+0x313/0x420 kernel/kthread.c:253
>   ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:352
>
> The buggy address belongs to the object at ffff888214af0c80
>   which belongs to the cache kmalloc-512 of size 512
> The buggy address is located 0 bytes inside of
>   512-byte region [ffff888214af0c80, ffff888214af0e80)
> The buggy address belongs to the page:
> page:ffffea000852bc00 count:1 mapcount:0 mapping:ffff88812c3f4c00
> index:0xffff888214af1180 compound_mapcount: 0
> flags: 0x57ff00000010200(slab|head)
> raw: 057ff00000010200 ffffea00086b3780 0000000800000008 ffff88812c3f4c00
> raw: ffff888214af1180 00000000800c000a 00000001ffffffff 0000000000000000
> page dumped because: kasan: bad access detected
>
> Memory state around the buggy address:
>   ffff888214af0b80: 00 00 00 00 00 00 00 00 00 00 00 fc fc fc fc fc
>   ffff888214af0c00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> > ffff888214af0c80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                     ^
>   ffff888214af0d00: fb fb fb fb fb fb f
>
>
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> syzbot can test patches for this bug, for details see:
> https://goo.gl/tpsmEJ#testing-patches

Most likely the same issue as:

#syz dup: WARNING: ODEBUG bug in rsi_probe

https://syzkaller.appspot.com/bug?extid=1d1597a5aa3679c65b9f
