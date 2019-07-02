Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 603875C62B
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 02:03:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbfGBADJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 20:03:09 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35611 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726966AbfGBADJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 20:03:09 -0400
Received: by mail-wm1-f66.google.com with SMTP id c6so1299493wml.0;
        Mon, 01 Jul 2019 17:03:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0oaxktBwYbCWBPSqdN0UkPZkDbNAm7KH/JUupR9080w=;
        b=oRGq7VKp/ev5G44cgKJrJdtTZgMtAaTjzmwbmWsDX+l+moJA5+oC4k5T03y/N2NvNP
         5R70EIlg7w8u8jqHvrX3pOWp+U4zivNz4TV2FC04n32CeL+8MJhIRi6fhP8LE4vmqRec
         mI6wq80nTR3/3msqi64IkB8UXe1QtaEbS8BQogXnRVETtOyOWQirjoH7vItJacrekpWO
         RVRV79t6gKrqoH2REzv7O+adaPrnzRtw3NKWP4a748USAQdBMNvnS5oy4wwz1KkMogLA
         hchF/mS4b1UCkVDxo0ZdDP1FRZHfGylrw8ddlG5LhAf2IDtYW7CLFNUSZqI8egmJ5FUQ
         mZQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0oaxktBwYbCWBPSqdN0UkPZkDbNAm7KH/JUupR9080w=;
        b=lyNSYGMd7TticVvl0ohMEQae8OxihxujHQb2c90L93ROmMxQTT8JevwZS818WmuV/V
         IlsOrsPAVeYC/xaBVlk9S5zbVee1FjSI+agJ/ZxHrV2I6jcUv4IUyvuKcZ9szJztN2gC
         G5VBNF9LyHJ49W2YJcIVsktMGy2xCTgEfyPBvEffcXYPICRPF5E0SbvV/r7ifk01BmtV
         6mRtdmBkeFgOUNrixSUwyDZw123nFaug6AStwyw8V02usHrQHzrmFTkBwIBrOzf0fKb7
         MOCygf+OpLWStEJYMaDIfq7XOe24F3Q0++OqYftzG3mx2BceFYjTW8s8+qr+1pvun30h
         vDrg==
X-Gm-Message-State: APjAAAWuw1fI4OuXbfOO/w4OVd0FkI4SNp+/zd59dEmLnMMJ8bvj9/kU
        TT1xgAgGAJMR27ckKoI6/m1It5w/nSC6vg0QXMg=
X-Google-Smtp-Source: APXvYqy6YC9Qi89zIU1hYTAoVPy6IqhePQIEP0I5BDd6BFDwHK6p6hhu9oME8YwuZ9p3JG3hPNbyqVV77eUz3i9ZEj4=
X-Received: by 2002:a05:600c:2549:: with SMTP id e9mr992279wma.46.1562025785805;
 Mon, 01 Jul 2019 17:03:05 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000008f06d058a6e9783@google.com> <20190630234533.15089-1-tranmanphong@gmail.com>
 <279519d5386680b3353b994a02475df08df13e29.camel@redhat.com>
In-Reply-To: <279519d5386680b3353b994a02475df08df13e29.camel@redhat.com>
From:   Phong Tran <tranmanphong@gmail.com>
Date:   Tue, 2 Jul 2019 07:02:54 +0700
Message-ID: <CAD3AR6EHq6+5kjyCLsu6AYbu7WGLhjE5cVL58g3SCr4b8D7UkA@mail.gmail.com>
Subject: Re: [PATCH] net: usb: asix: init MAC address buffers
To:     Dan Williams <dcbw@redhat.com>
Cc:     syzbot <syzbot+8a3fc6674bbc3978ed4e@syzkaller.appspotmail.com>,
        davem@davemloft.net, Alexander Potapenko <glider@google.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        lynxis@fe80.eu, marcel.ziswiler@toradex.com,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        yang.wei9@zte.com.cn, zhang.run@zte.com.cn,
        Shuah Khan <skhan@linuxfoundation.org>,
        linux-kernel-mentees@lists.linuxfoundation.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Dan,

On Mon, Jul 1, 2019 at 10:30 PM Dan Williams <dcbw@redhat.com> wrote:
>
> On Mon, 2019-07-01 at 06:45 +0700, Phong Tran wrote:
> > This is for fixing bug KMSAN: uninit-value in ax88772_bind
> >
> > Tested by
> > https://groups.google.com/d/msg/syzkaller-bugs/aFQurGotng4/cFe9nxMCCwAJ
> >
> > Reported-by: syzbot+8a3fc6674bbc3978ed4e@syzkaller.appspotmail.com
> >
> > syzbot found the following crash on:
> >
> > HEAD commit:    f75e4cfe kmsan: use kmsan_handle_urb() in urb.c
> > git tree:       kmsan
> > console output:
> > https://syzkaller.appspot.com/x/log.txt?x=136d720ea00000
> > kernel config:
> > https://syzkaller.appspot.com/x/.config?x=602468164ccdc30a
> > dashboard link:
> > https://syzkaller.appspot.com/bug?extid=8a3fc6674bbc3978ed4e
> > compiler:       clang version 9.0.0 (/home/glider/llvm/clang
> > 06d00afa61eef8f7f501ebdb4e8612ea43ec2d78)
> > syz repro:
> > https://syzkaller.appspot.com/x/repro.syz?x=12788316a00000
> > C reproducer:
> > https://syzkaller.appspot.com/x/repro.c?x=120359aaa00000
> >
> > ==================================================================
> > BUG: KMSAN: uninit-value in is_valid_ether_addr
> > include/linux/etherdevice.h:200 [inline]
> > BUG: KMSAN: uninit-value in asix_set_netdev_dev_addr
> > drivers/net/usb/asix_devices.c:73 [inline]
> > BUG: KMSAN: uninit-value in ax88772_bind+0x93d/0x11e0
> > drivers/net/usb/asix_devices.c:724
> > CPU: 0 PID: 3348 Comm: kworker/0:2 Not tainted 5.1.0+ #1
> > Hardware name: Google Google Compute Engine/Google Compute Engine,
> > BIOS
> > Google 01/01/2011
> > Workqueue: usb_hub_wq hub_event
> > Call Trace:
> >   __dump_stack lib/dump_stack.c:77 [inline]
> >   dump_stack+0x191/0x1f0 lib/dump_stack.c:113
> >   kmsan_report+0x130/0x2a0 mm/kmsan/kmsan.c:622
> >   __msan_warning+0x75/0xe0 mm/kmsan/kmsan_instr.c:310
> >   is_valid_ether_addr include/linux/etherdevice.h:200 [inline]
> >   asix_set_netdev_dev_addr drivers/net/usb/asix_devices.c:73 [inline]
> >   ax88772_bind+0x93d/0x11e0 drivers/net/usb/asix_devices.c:724
> >   usbnet_probe+0x10f5/0x3940 drivers/net/usb/usbnet.c:1728
> >   usb_probe_interface+0xd66/0x1320 drivers/usb/core/driver.c:361
> >   really_probe+0xdae/0x1d80 drivers/base/dd.c:513
> >   driver_probe_device+0x1b3/0x4f0 drivers/base/dd.c:671
> >   __device_attach_driver+0x5b8/0x790 drivers/base/dd.c:778
> >   bus_for_each_drv+0x28e/0x3b0 drivers/base/bus.c:454
> >   __device_attach+0x454/0x730 drivers/base/dd.c:844
> >   device_initial_probe+0x4a/0x60 drivers/base/dd.c:891
> >   bus_probe_device+0x137/0x390 drivers/base/bus.c:514
> >   device_add+0x288d/0x30e0 drivers/base/core.c:2106
> >   usb_set_configuration+0x30dc/0x3750 drivers/usb/core/message.c:2027
> >   generic_probe+0xe7/0x280 drivers/usb/core/generic.c:210
> >   usb_probe_device+0x14c/0x200 drivers/usb/core/driver.c:266
> >   really_probe+0xdae/0x1d80 drivers/base/dd.c:513
> >   driver_probe_device+0x1b3/0x4f0 drivers/base/dd.c:671
> >   __device_attach_driver+0x5b8/0x790 drivers/base/dd.c:778
> >   bus_for_each_drv+0x28e/0x3b0 drivers/base/bus.c:454
> >   __device_attach+0x454/0x730 drivers/base/dd.c:844
> >   device_initial_probe+0x4a/0x60 drivers/base/dd.c:891
> >   bus_probe_device+0x137/0x390 drivers/base/bus.c:514
> >   device_add+0x288d/0x30e0 drivers/base/core.c:2106
> >   usb_new_device+0x23e5/0x2ff0 drivers/usb/core/hub.c:2534
> >   hub_port_connect drivers/usb/core/hub.c:5089 [inline]
> >   hub_port_connect_change drivers/usb/core/hub.c:5204 [inline]
> >   port_event drivers/usb/core/hub.c:5350 [inline]
> >   hub_event+0x48d1/0x7290 drivers/usb/core/hub.c:5432
> >   process_one_work+0x1572/0x1f00 kernel/workqueue.c:2269
> >   process_scheduled_works kernel/workqueue.c:2331 [inline]
> >   worker_thread+0x189c/0x2460 kernel/workqueue.c:2417
> >   kthread+0x4b5/0x4f0 kernel/kthread.c:254
> >   ret_from_fork+0x35/0x40 arch/x86/entry/entry_64.S:355
> >
> > Signed-off-by: Phong Tran <tranmanphong@gmail.com>
> > ---
> >  drivers/net/usb/asix_devices.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/drivers/net/usb/asix_devices.c
> > b/drivers/net/usb/asix_devices.c
> > index c9bc96310ed4..f514d19316b1 100644
> > --- a/drivers/net/usb/asix_devices.c
> > +++ b/drivers/net/usb/asix_devices.c
> > @@ -230,6 +230,7 @@ static int ax88172_bind(struct usbnet *dev,
> > struct usb_interface *intf)
> >       int i;
> >       unsigned long gpio_bits = dev->driver_info->data;
> >
> > +     memset(buf, 0, sizeof(buf));
>
> For array variables defined in the function itself, isn't this usually
> done with:
>
>          int ret = 0;
> -        u8 buf[ETH_ALEN];
> +        u8 buf[ETH_ALEN] = {0};
>          int i;
>          unsigned long gpio_bits = dev->driver_info->data;
>
> eg make the compiler do it (though maybe it's smart enough to elide the
> memset, I don't know). See drivers/net/ethernet/intel/igb/e1000_mac.c
> for an example.
>

Thank suggestion, applied in v2 without using memset().

Phong
