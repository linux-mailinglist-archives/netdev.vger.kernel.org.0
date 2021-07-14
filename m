Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C61403C7FB1
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 10:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238424AbhGNIDR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 04:03:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238416AbhGNIDQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 04:03:16 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BB2FC06175F;
        Wed, 14 Jul 2021 01:00:25 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id gn32so1932216ejc.2;
        Wed, 14 Jul 2021 01:00:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CG/YcDQ/exOjssT9uVR0bnqmiCrC2Jq+PjWV7ypJrxQ=;
        b=SV1GxsNt/w6xkWHGXFSylld24MvuTEFpjtDd4emfWsN2S+VxpAFKd7k9tSnaewETZ1
         FIjcHVcGD2e65RM2JIZxCtiSvcv8SZOEmiP044W5h3rTD0+hJfmqGKjKQR6vY4d4MzWM
         ZgLusGK5324mMw5/PMkitql56qwzwzm/YxaVeSWknTbd0hldOwfXr9/XjtxdA91UQjXs
         fuIgtKiw6DZ52AFyGqs0ICfmjrDWVvp5Ze7isfzs79DVz2UeBsRxy0VoBxyPRxJ3RdU0
         NCUaDrOl8i/5nKwQsvBybe/RCudrUJATn7PXYzzqHa/mnQdDcqzPONiHliagIWFoy2bv
         P4Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CG/YcDQ/exOjssT9uVR0bnqmiCrC2Jq+PjWV7ypJrxQ=;
        b=YUvp1NYs89iHa+/yNq1CAT4LzGx9JPzeN1/VBOgRgUP8wY2ehGqbFb/tp1zkTkHtv7
         hqz1ys/tvKz3ZkmxQZ9S0o4Ys1PRM4X1l/3qMtUFYy/RcctM1pZ4tTjIOYHEIAOv2d67
         5/hEKCyTvfx3s5ma3N51b7DgrFpWANW5jE1URHm79uPQ6jxyvR950QEZlZpNIh3qtYIz
         YM65suX4vib6E1Cfs334/OigTyvy5i8B8DMLehsCTmlIHkK4EslltSwWqbZUibv0zHES
         jhG9QUD4vFa+5sNPIVmf1/zuy5O+LCugy4ppFBGotez52oLY0QbRusjomutluEq9i2e0
         qKMQ==
X-Gm-Message-State: AOAM533rrEdSEJPkOJDfJpL7ojf6JJdkGcy8UR5KPinOKb9g3mJgHkmp
        g6gdV+yDps3L/AG7bTHRlGt+fLUyjtwNVNr29QI=
X-Google-Smtp-Source: ABdhPJyvVWX2tO4oMAETfKWK9/hbSEkf1wVLzwNo1pwJlmpA1FSm3hokTzrxzfpP8hBEMUjDA30doJ4JyYWs3RLKalY=
X-Received: by 2002:a17:906:9fc1:: with SMTP id hj1mr10763072ejc.103.1626249624029;
 Wed, 14 Jul 2021 01:00:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210714071547.656587-1-mudongliangabcd@gmail.com> <20210714073614.GU1954@kadam>
In-Reply-To: <20210714073614.GU1954@kadam>
From:   Dongliang Mu <mudongliangabcd@gmail.com>
Date:   Wed, 14 Jul 2021 15:59:56 +0800
Message-ID: <CAD-N9QW4Gs6bAGvUFv+GhRc+P14TF8ozQOj0AK3CZZpVgcGFKw@mail.gmail.com>
Subject: Re: [PATCH 1/2] usb: hso: fix error handling code of hso_create_net_device
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hovold <johan@kernel.org>,
        Oliver Neukum <oneukum@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        YueHaibing <yuehaibing@huawei.com>,
        Anirudh Rayabharam <mail@anirudhrb.com>,
        syzbot+44d53c7255bb1aea22d2@syzkaller.appspotmail.com,
        linux-usb@vger.kernel.org,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 14, 2021 at 3:36 PM Dan Carpenter <dan.carpenter@oracle.com> wrote:
>
> On Wed, Jul 14, 2021 at 03:15:32PM +0800, Dongliang Mu wrote:
> > The current error handling code of hso_create_net_device is
> > hso_free_net_device, no matter which errors lead to. For example,
> > WARNING in hso_free_net_device [1].
> >
> > Fix this by refactoring the error handling code of
> > hso_create_net_device by handling different errors by different code.
> >
> > [1] https://syzkaller.appspot.com/bug?id=66eff8d49af1b28370ad342787413e35bbe76efe
> >
> > Reported-by: syzbot+44d53c7255bb1aea22d2@syzkaller.appspotmail.com
> > Fixes: 5fcfb6d0bfcd ("hso: fix bailout in error case of probe")
> > Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
> > ---
> >  drivers/net/usb/hso.c | 37 +++++++++++++++++++++++++++----------
> >  1 file changed, 27 insertions(+), 10 deletions(-)
> >
> > diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
> > index 54ef8492ca01..90fa4d9fa119 100644
> > --- a/drivers/net/usb/hso.c
> > +++ b/drivers/net/usb/hso.c
> > @@ -2495,7 +2495,9 @@ static struct hso_device *hso_create_net_device(struct usb_interface *interface,
> >                          hso_net_init);
> >       if (!net) {
> >               dev_err(&interface->dev, "Unable to create ethernet device\n");
> > -             goto exit;
> > +             kfree(hso_dev);
> > +     usb_free_urb(hso_net->mux_bulk_tx_urb);
>
> Obviously this wasn't intentional.

This is a copy-paste error. I am sorry. :(

>
> > +             return NULL;
>
> But use gotos here.

OK, I will change it in version v2.

>
> >       }
> >
> >       hso_net = netdev_priv(net);
> > @@ -2508,13 +2510,13 @@ static struct hso_device *hso_create_net_device(struct usb_interface *interface,
> >                                     USB_DIR_IN);
> >       if (!hso_net->in_endp) {
> >               dev_err(&interface->dev, "Can't find BULK IN endpoint\n");
> > -             goto exit;
> > +             goto err_get_ep;
>
> This is Come From naming style where it says what failed on the line
> before.  It's not helpful because we can see what failed.  What we need
> to know is what the goto does.
>
> Use Free the Last thing style.  Where you just keep track of the most
> recent successful allocation and free it.  That way you don't free
> things which aren't allocated, you don't double free things, you don't
> dereference uninitialized variables or error points.  Plus it's a very
> simple system where when you're reading code you just have to remember
> the last thing that was allocated.  Every function must clean up after
> itself.  Every allocation function needs a free function.  The goto
> names say the variable that is freed.

That's a good rule to follow. Will change the patch following this rule.

>
>                 goto free_net;
>
> >       }
> >       hso_net->out_endp = hso_get_ep(interface, USB_ENDPOINT_XFER_BULK,
> >                                      USB_DIR_OUT);
> >       if (!hso_net->out_endp) {
> >               dev_err(&interface->dev, "Can't find BULK OUT endpoint\n");
> > -             goto exit;
> > +             goto err_get_ep;
> >       }
> >       SET_NETDEV_DEV(net, &interface->dev);
> >       SET_NETDEV_DEVTYPE(net, &hso_type);
> > @@ -2523,18 +2525,18 @@ static struct hso_device *hso_create_net_device(struct usb_interface *interface,
> >       for (i = 0; i < MUX_BULK_RX_BUF_COUNT; i++) {
> >               hso_net->mux_bulk_rx_urb_pool[i] = usb_alloc_urb(0, GFP_KERNEL);
> >               if (!hso_net->mux_bulk_rx_urb_pool[i])
> > -                     goto exit;
> > +                     goto err_mux_bulk_rx;
> >               hso_net->mux_bulk_rx_buf_pool[i] = kzalloc(MUX_BULK_RX_BUF_SIZE,
> >                                                          GFP_KERNEL);
> >               if (!hso_net->mux_bulk_rx_buf_pool[i])
> > -                     goto exit;
> > +                     goto err_mux_bulk_rx;
>
> In a loop then how Free the last thing style works is that you free
> that partial allocation before the goto.  And then do a
>
>         while (--i >= 0) {
>                 free_c();
>                 free_b();
>                 free_a();
>         }
>

You have told me this rule. But I think the handling of this loop does
not need to be such complicated.

> But in this case your code is fine and simple enough.  No need to be
> dogmatic about style so long as the functions are small.

Thanks.

>
> >       }
> >       hso_net->mux_bulk_tx_urb = usb_alloc_urb(0, GFP_KERNEL);
> >       if (!hso_net->mux_bulk_tx_urb)
> > -             goto exit;
> > +             goto err_mux_bulk_tx;
> >       hso_net->mux_bulk_tx_buf = kzalloc(MUX_BULK_TX_BUF_SIZE, GFP_KERNEL);
> >       if (!hso_net->mux_bulk_tx_buf)
> > -             goto exit;
> > +             goto err_mux_bulk_tx;
>
>
> These gotos are freeing things which haven't been allocated.  Which is
> harmless in this case but puzzling.

I will revise this label in the v2 version.

>
> >
> >       add_net_device(hso_dev);
> >
> > @@ -2542,7 +2544,7 @@ static struct hso_device *hso_create_net_device(struct usb_interface *interface,
> >       result = register_netdev(net);
> >       if (result) {
> >               dev_err(&interface->dev, "Failed to register device\n");
> > -             goto exit;
> > +             goto err_register;
>
> In this case register failed and calling unregister_netdev() will lead
> to WARN_ON(1) and a stack trace.
>

I will revise this label in the v2 version.

> >       }
> >
> >       hso_log_port(hso_dev);
> > @@ -2550,8 +2552,23 @@ static struct hso_device *hso_create_net_device(struct usb_interface *interface,
> >       hso_create_rfkill(hso_dev, interface);
> >
> >       return hso_dev;
> > -exit:
> > -     hso_free_net_device(hso_dev, true);
> > +
> > +err_register:
> > +     unregister_netdev(net);
> > +     remove_net_device(hso_dev);
> > +err_mux_bulk_tx:
> > +     kfree(hso_net->mux_bulk_tx_buf);
> > +     hso_net->mux_bulk_tx_buf = NULL;
>
> No need for this.
>
> > +     usb_free_urb(hso_net->mux_bulk_tx_urb);
> > +err_mux_bulk_rx:
> > +     for (i = 0; i < MUX_BULK_RX_BUF_COUNT; i++) {
> > +             usb_free_urb(hso_net->mux_bulk_rx_urb_pool[i]);
> > +             kfree(hso_net->mux_bulk_rx_buf_pool[i]);
> > +             hso_net->mux_bulk_rx_buf_pool[i] = NULL;
>
> No need.  This memory is just going to be freed.
>
> > +     }
> > +err_get_ep:
> > +     free_netdev(net);
> > +     kfree(hso_dev);
> >       return NULL;
> >  }
>
> regards,
> dan carpenter
