Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91C8089E40
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 14:27:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728464AbfHLM1y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 08:27:54 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:39595 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728293AbfHLM1x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 08:27:53 -0400
Received: by mail-pf1-f195.google.com with SMTP id f17so45623265pfn.6
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 05:27:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qNFs7sbNtnm8TIR9j2SolRZsryLdQU4+rlFLvcu2GAY=;
        b=nlnLwPlc2Zb8CsIdl6INGn8eBPFSxyF17s+Sf1rqTKglwFRZrLMfiQV+xyyBxVUBC9
         UAmf7xXV2H7JgrQUX0dz9g4S3PMsB8eWNsVjyvvCob5wi6CVt3Z1bBkxe4M7Qm8WAwxa
         SC7Ib6OxUR0MGV4O9/rhdEl3+G1Hzvaocnm+CsoWG9PsAGWZxb3mGT5fUA0jbq2w5PON
         TCXPxB4T2ubMCk0Wnk1dRV/ote2+0flvtsPjbq7WJV5bn5P3g6z5WOBuTO7Gy3xZeoDL
         g1+vvuxgUNlgal86GTym0cLlGBw/7sKhMwfOYqsi3c0qV/I7aCXUMOWs+0LvQbw8sCJs
         7/Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qNFs7sbNtnm8TIR9j2SolRZsryLdQU4+rlFLvcu2GAY=;
        b=hjB5hGFXeccShx60nLLMBywHZhHGrO3WEgUj6lysb0snJT6FArU3NOMrz7xuDmwP5m
         /WB/ekk4Bj20YoX8QldZx0SklD+7Ectnclh8Mukp5CYDwqL+nzkGsE0xnTH/5OmTDqO7
         0xG3Zif0CRSd1dCrFQtueKEntHmpQh9gtoPW65XMk7B94rcgPNt+fWdoxmPKNpgjP3hP
         TgqEB+NnNUgU5uQ7ik0/sC3m8MqeiVjUaZ+ktR9Dsetwgz4lNeKLSHAdnp2Qk6jpLgfy
         yaYx/Cj2yr1G63jCEOQl7dQHovyItkD9CVV8aFZ/XmQ8D0u6fuVJx6/b2lf3A1hkKTrC
         eVmA==
X-Gm-Message-State: APjAAAV7VC8cEyDy8CGrGoKfVpRP+SRw+dxnF7lyAwulofXaXWqxpyFL
        Xs0h5DLkq3BO6OL2ZnJ9Hbxt9PiGKHaulrHXHUDhOA==
X-Google-Smtp-Source: APXvYqyUWw6ptj1JwOUyxZKIhMwemF63PdlLuXg00TaGkm4edY3MfHSL7YLxkWY8F2GXMbKhMOUowT3r2FYahvnBcng=
X-Received: by 2002:a17:90a:c20f:: with SMTP id e15mr16883275pjt.123.1565612872743;
 Mon, 12 Aug 2019 05:27:52 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000487b44058fea845c@google.com>
In-Reply-To: <000000000000487b44058fea845c@google.com>
From:   Andrey Konovalov <andreyknvl@google.com>
Date:   Mon, 12 Aug 2019 14:27:41 +0200
Message-ID: <CAAeHK+wELVfuQPJaOeG7KggR2BDTOuzCYLC+dzqbhrRRPNf9cA@mail.gmail.com>
Subject: Re: KASAN: slab-out-of-bounds Read in usbnet_generic_cdc_bind
To:     syzbot <syzbot+45a53506b65321c1fe91@syzkaller.appspotmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Oliver Neukum <oliver@neukum.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Alan Stern <stern@rowland.harvard.edu>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 12, 2019 at 2:18 PM syzbot
<syzbot+45a53506b65321c1fe91@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    e96407b4 usb-fuzzer: main usb gadget fuzzer driver
> git tree:       https://github.com/google/kasan.git usb-fuzzer
> console output: https://syzkaller.appspot.com/x/log.txt?x=1390791c600000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=cfa2c18fb6a8068e
> dashboard link: https://syzkaller.appspot.com/bug?extid=45a53506b65321c1fe91
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12c78cd2600000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1395b40e600000
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+45a53506b65321c1fe91@syzkaller.appspotmail.com
>
> usb 1-1: config 1 interface 0 altsetting 0 has 0 endpoint descriptors,
> different from the interface descriptor's value: 18
> usb 1-1: New USB device found, idVendor=0525, idProduct=a4a1, bcdDevice=
> 0.40
> usb 1-1: New USB device strings: Mfr=6, Product=0, SerialNumber=0
> ==================================================================
> BUG: KASAN: slab-out-of-bounds in memcmp+0xa6/0xb0 lib/string.c:904
> Read of size 1 at addr ffff8881d4262f3b by task kworker/1:2/83
>
> CPU: 1 PID: 83 Comm: kworker/1:2 Not tainted 5.3.0-rc2+ #25
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> Workqueue: usb_hub_wq hub_event
> Call Trace:
>   __dump_stack lib/dump_stack.c:77 [inline]
>   dump_stack+0xca/0x13e lib/dump_stack.c:113
>   print_address_description+0x6a/0x32c mm/kasan/report.c:351
>   __kasan_report.cold+0x1a/0x33 mm/kasan/report.c:482
>   kasan_report+0xe/0x12 mm/kasan/common.c:612
>   memcmp+0xa6/0xb0 lib/string.c:904
>   memcmp include/linux/string.h:400 [inline]
>   usbnet_generic_cdc_bind+0x71b/0x17c0 drivers/net/usb/cdc_ether.c:225
>   usbnet_ether_cdc_bind drivers/net/usb/cdc_ether.c:322 [inline]
>   usbnet_cdc_bind+0x20/0x1a0 drivers/net/usb/cdc_ether.c:430
>   usbnet_probe+0xb43/0x23d0 drivers/net/usb/usbnet.c:1722
>   usb_probe_interface+0x305/0x7a0 drivers/usb/core/driver.c:361
>   really_probe+0x281/0x650 drivers/base/dd.c:548
>   driver_probe_device+0x101/0x1b0 drivers/base/dd.c:709
>   __device_attach_driver+0x1c2/0x220 drivers/base/dd.c:816
>   bus_for_each_drv+0x15c/0x1e0 drivers/base/bus.c:454
>   __device_attach+0x217/0x360 drivers/base/dd.c:882
>   bus_probe_device+0x1e4/0x290 drivers/base/bus.c:514
>   device_add+0xae6/0x16f0 drivers/base/core.c:2114
>   usb_set_configuration+0xdf6/0x1670 drivers/usb/core/message.c:2023
>   generic_probe+0x9d/0xd5 drivers/usb/core/generic.c:210
>   usb_probe_device+0x99/0x100 drivers/usb/core/driver.c:266
>   really_probe+0x281/0x650 drivers/base/dd.c:548
>   driver_probe_device+0x101/0x1b0 drivers/base/dd.c:709
>   __device_attach_driver+0x1c2/0x220 drivers/base/dd.c:816
>   bus_for_each_drv+0x15c/0x1e0 drivers/base/bus.c:454
>   __device_attach+0x217/0x360 drivers/base/dd.c:882
>   bus_probe_device+0x1e4/0x290 drivers/base/bus.c:514
>   device_add+0xae6/0x16f0 drivers/base/core.c:2114
>   usb_new_device.cold+0x6a4/0xe79 drivers/usb/core/hub.c:2536
>   hub_port_connect drivers/usb/core/hub.c:5098 [inline]
>   hub_port_connect_change drivers/usb/core/hub.c:5213 [inline]
>   port_event drivers/usb/core/hub.c:5359 [inline]
>   hub_event+0x1b5c/0x3640 drivers/usb/core/hub.c:5441
>   process_one_work+0x92b/0x1530 kernel/workqueue.c:2269
>   worker_thread+0x96/0xe20 kernel/workqueue.c:2415
>   kthread+0x318/0x420 kernel/kthread.c:255
>   ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
>
> Allocated by task 83:
>   save_stack+0x1b/0x80 mm/kasan/common.c:69
>   set_track mm/kasan/common.c:77 [inline]
>   __kasan_kmalloc mm/kasan/common.c:487 [inline]
>   __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:460
>   kmalloc include/linux/slab.h:557 [inline]
>   usb_get_configuration+0x30c/0x3070 drivers/usb/core/config.c:857
>   usb_enumerate_device drivers/usb/core/hub.c:2369 [inline]
>   usb_new_device+0xd3/0x160 drivers/usb/core/hub.c:2505
>   hub_port_connect drivers/usb/core/hub.c:5098 [inline]
>   hub_port_connect_change drivers/usb/core/hub.c:5213 [inline]
>   port_event drivers/usb/core/hub.c:5359 [inline]
>   hub_event+0x1b5c/0x3640 drivers/usb/core/hub.c:5441
>   process_one_work+0x92b/0x1530 kernel/workqueue.c:2269
>   worker_thread+0x96/0xe20 kernel/workqueue.c:2415
>   kthread+0x318/0x420 kernel/kthread.c:255
>   ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
>
> Freed by task 269:
>   save_stack+0x1b/0x80 mm/kasan/common.c:69
>   set_track mm/kasan/common.c:77 [inline]
>   __kasan_slab_free+0x130/0x180 mm/kasan/common.c:449
>   slab_free_hook mm/slub.c:1423 [inline]
>   slab_free_freelist_hook mm/slub.c:1470 [inline]
>   slab_free mm/slub.c:3012 [inline]
>   kfree+0xe4/0x2f0 mm/slub.c:3953
>   kobject_uevent_env+0x294/0x1160 lib/kobject_uevent.c:624
>   kobject_synth_uevent+0x70a/0x81e lib/kobject_uevent.c:208
>   uevent_store+0x20/0x50 drivers/base/core.c:1244
>   dev_attr_store+0x50/0x80 drivers/base/core.c:947
>   sysfs_kf_write+0x110/0x160 fs/sysfs/file.c:138
>   kernfs_fop_write+0x2b0/0x470 fs/kernfs/file.c:315
>   __vfs_write+0x76/0x100 fs/read_write.c:494
>   vfs_write+0x262/0x5c0 fs/read_write.c:558
>   ksys_write+0x127/0x250 fs/read_write.c:611
>   do_syscall_64+0xb7/0x580 arch/x86/entry/common.c:296
>   entry_SYSCALL_64_after_hwframe+0x49/0xbe
>
> The buggy address belongs to the object at ffff8881d4262f00
>   which belongs to the cache kmalloc-64 of size 64
> The buggy address is located 59 bytes inside of
>   64-byte region [ffff8881d4262f00, ffff8881d4262f40)
> The buggy address belongs to the page:
> page:ffffea0007509880 refcount:1 mapcount:0 mapping:ffff8881da003180
> index:0x0
> flags: 0x200000000000200(slab)
> raw: 0200000000000200 ffffea00074d1f00 0000001800000018 ffff8881da003180
> raw: 0000000000000000 00000000802a002a 00000001ffffffff 0000000000000000
> page dumped because: kasan: bad access detected
>
> Memory state around the buggy address:
>   ffff8881d4262e00: fb fb fb fb fc fc fc fc 00 00 00 00 00 00 fc fc
>   ffff8881d4262e80: fc fc fc fc fb fb fb fb fb fb fb fb fc fc fc fc
> > ffff8881d4262f00: 00 00 00 00 00 00 00 03 fc fc fc fc fb fb fb fb
>                                          ^
>   ffff8881d4262f80: fb fb fb fb fc fc fc fc fc fc fc fc fc fc fc fc
>   ffff8881d4263000: fb fb fb fb fb fb fb fb fb fb fc fc fc fc fb fb
> ==================================================================

This one is funny, we do sizeof(struct usb_cdc_mdlm_desc *) instead of
sizeof(struct usb_cdc_mdlm_desc) and the same for
usb_cdc_mdlm_detail_desc in cdc_parse_cdc_header().

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
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/000000000000487b44058fea845c%40google.com.
