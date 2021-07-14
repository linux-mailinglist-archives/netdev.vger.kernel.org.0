Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41B033C7F46
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 09:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238267AbhGNHZk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 03:25:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238104AbhGNHZk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 03:25:40 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28BB1C06175F;
        Wed, 14 Jul 2021 00:22:48 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id l1so1737601edr.11;
        Wed, 14 Jul 2021 00:22:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Uv3bCFjkxBCn0hMrBP7maAjSxRY6anVlaVgiurra1AU=;
        b=HmfWf/AQhD2d01pTTC9DYogNenYxfj+pS7Z+wnwv+tCY5xEgptGiQAOQLvWPu04auT
         uWh95+TLP4hfjCi6MyYyQLf+u5aOxAyoPnVEnG/n8x/025D1cQ9mH1TaxGoZ45+MBqM9
         Q0LbR43J13fq1o6KFgs8dM8n08moHcwLHSbEN+/lwDHAJmH0Eh2jV8DRMaet7UHpjIbN
         jxFXHzcfbOTJhNGyKDI6dh4fPmpkKu9zMqPLZ2uX+P+tXJGz48N9GQx6AgUxqrVpb/jX
         kCWaqYbgCSzAFnaOY0ZFdgxZIaWAFbpiHiNuFMSoPsXG3EP7o2ZTPJSgnigNb2WvpfB5
         YtuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Uv3bCFjkxBCn0hMrBP7maAjSxRY6anVlaVgiurra1AU=;
        b=md+gmrCPVBo9BmkhFse5sY8mMOrKf7V4eaHI4qUlw1fuc9flMP/fbnFbm8wv1w+PcO
         TtYWmsGz5zwt9TEpzvUzfaIk0GMtiYCWMKpefeFgY+zUjqK/lZ6OUkROZ6ZBN6rQygUE
         pS8YGJJKE2RmcqyXxLLW88x5w4UCf5eCyhZ72eqne22zGAVbPntyo9ErP3xysvxqtbzs
         YM6/1xr2jhYBRveY7y+uLXWZ0vRUipOziv299No8h7J5HZBysLgmdseoduItMXDJRByx
         EUgWEiQaxLnocDsw+AAJ5w4OV4YdYYh62lxBAh+rHywYK0eRWjXJao7Ur+6Hz1ZFcykQ
         GP3Q==
X-Gm-Message-State: AOAM5339iRywkGRSUtWgjbznFL4Q24Zc0SDICL1eP9dAXNN9N2aUJ1Z9
        cOgEtUjZZ4aAexHKfmvGWskbK6NXLaRXjNwmf2w=
X-Google-Smtp-Source: ABdhPJzROsMTZKGlUUV+Tj3OQ0xOEDQoQeH1O37LsNOxpdWhf0jIIcfhqJ+/ZlMR6Cj+fEPPk5dzdA8L/uBDTdM9dtU=
X-Received: by 2002:a50:ff02:: with SMTP id a2mr11487150edu.214.1626247366720;
 Wed, 14 Jul 2021 00:22:46 -0700 (PDT)
MIME-Version: 1.0
References: <20210714071547.656587-1-mudongliangabcd@gmail.com>
In-Reply-To: <20210714071547.656587-1-mudongliangabcd@gmail.com>
From:   Dongliang Mu <mudongliangabcd@gmail.com>
Date:   Wed, 14 Jul 2021 15:22:20 +0800
Message-ID: <CAD-N9QVC2Kza-7H42UdVb1bb2Y9fM+n3CYjQb_j9BAS2u_eyvA@mail.gmail.com>
Subject: Re: [PATCH 1/2] usb: hso: fix error handling code of hso_create_net_device
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hovold <johan@kernel.org>,
        Oliver Neukum <oneukum@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dongliang Mu <mudongliangabcd@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Anirudh Rayabharam <mail@anirudhrb.com>
Cc:     syzbot+44d53c7255bb1aea22d2@syzkaller.appspotmail.com,
        linux-usb@vger.kernel.org,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 14, 2021 at 3:16 PM Dongliang Mu <mudongliangabcd@gmail.com> wrote:
>
> The current error handling code of hso_create_net_device is
> hso_free_net_device, no matter which errors lead to. For example,
> WARNING in hso_free_net_device [1].

Although there is already a patch for the above bug report, I don't
think it cannot handle all kinds of errors caused in
hso_create_net_device.

So refactoring the error handling code is the only way to fix this issue.

[1] https://syzkaller.appspot.com/text?tag=Patch&x=1188fcc6600000

>
> Fix this by refactoring the error handling code of
> hso_create_net_device by handling different errors by different code.
>
> [1] https://syzkaller.appspot.com/bug?id=66eff8d49af1b28370ad342787413e35bbe76efe
>
> Reported-by: syzbot+44d53c7255bb1aea22d2@syzkaller.appspotmail.com
> Fixes: 5fcfb6d0bfcd ("hso: fix bailout in error case of probe")
> Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
> ---
>  drivers/net/usb/hso.c | 37 +++++++++++++++++++++++++++----------
>  1 file changed, 27 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
> index 54ef8492ca01..90fa4d9fa119 100644
> --- a/drivers/net/usb/hso.c
> +++ b/drivers/net/usb/hso.c
> @@ -2495,7 +2495,9 @@ static struct hso_device *hso_create_net_device(struct usb_interface *interface,
>                            hso_net_init);
>         if (!net) {
>                 dev_err(&interface->dev, "Unable to create ethernet device\n");
> -               goto exit;
> +               kfree(hso_dev);
> +       usb_free_urb(hso_net->mux_bulk_tx_urb);
> +               return NULL;
>         }
>
>         hso_net = netdev_priv(net);
> @@ -2508,13 +2510,13 @@ static struct hso_device *hso_create_net_device(struct usb_interface *interface,
>                                       USB_DIR_IN);
>         if (!hso_net->in_endp) {
>                 dev_err(&interface->dev, "Can't find BULK IN endpoint\n");
> -               goto exit;
> +               goto err_get_ep;
>         }
>         hso_net->out_endp = hso_get_ep(interface, USB_ENDPOINT_XFER_BULK,
>                                        USB_DIR_OUT);
>         if (!hso_net->out_endp) {
>                 dev_err(&interface->dev, "Can't find BULK OUT endpoint\n");
> -               goto exit;
> +               goto err_get_ep;
>         }
>         SET_NETDEV_DEV(net, &interface->dev);
>         SET_NETDEV_DEVTYPE(net, &hso_type);
> @@ -2523,18 +2525,18 @@ static struct hso_device *hso_create_net_device(struct usb_interface *interface,
>         for (i = 0; i < MUX_BULK_RX_BUF_COUNT; i++) {
>                 hso_net->mux_bulk_rx_urb_pool[i] = usb_alloc_urb(0, GFP_KERNEL);
>                 if (!hso_net->mux_bulk_rx_urb_pool[i])
> -                       goto exit;
> +                       goto err_mux_bulk_rx;
>                 hso_net->mux_bulk_rx_buf_pool[i] = kzalloc(MUX_BULK_RX_BUF_SIZE,
>                                                            GFP_KERNEL);
>                 if (!hso_net->mux_bulk_rx_buf_pool[i])
> -                       goto exit;
> +                       goto err_mux_bulk_rx;
>         }
>         hso_net->mux_bulk_tx_urb = usb_alloc_urb(0, GFP_KERNEL);
>         if (!hso_net->mux_bulk_tx_urb)
> -               goto exit;
> +               goto err_mux_bulk_tx;
>         hso_net->mux_bulk_tx_buf = kzalloc(MUX_BULK_TX_BUF_SIZE, GFP_KERNEL);
>         if (!hso_net->mux_bulk_tx_buf)
> -               goto exit;
> +               goto err_mux_bulk_tx;
>
>         add_net_device(hso_dev);
>
> @@ -2542,7 +2544,7 @@ static struct hso_device *hso_create_net_device(struct usb_interface *interface,
>         result = register_netdev(net);
>         if (result) {
>                 dev_err(&interface->dev, "Failed to register device\n");
> -               goto exit;
> +               goto err_register;
>         }
>
>         hso_log_port(hso_dev);
> @@ -2550,8 +2552,23 @@ static struct hso_device *hso_create_net_device(struct usb_interface *interface,
>         hso_create_rfkill(hso_dev, interface);
>
>         return hso_dev;
> -exit:
> -       hso_free_net_device(hso_dev, true);
> +
> +err_register:
> +       unregister_netdev(net);
> +       remove_net_device(hso_dev);
> +err_mux_bulk_tx:
> +       kfree(hso_net->mux_bulk_tx_buf);
> +       hso_net->mux_bulk_tx_buf = NULL;
> +       usb_free_urb(hso_net->mux_bulk_tx_urb);
> +err_mux_bulk_rx:
> +       for (i = 0; i < MUX_BULK_RX_BUF_COUNT; i++) {
> +               usb_free_urb(hso_net->mux_bulk_rx_urb_pool[i]);
> +               kfree(hso_net->mux_bulk_rx_buf_pool[i]);
> +               hso_net->mux_bulk_rx_buf_pool[i] = NULL;
> +       }
> +err_get_ep:
> +       free_netdev(net);
> +       kfree(hso_dev);
>         return NULL;
>  }
>
> --
> 2.25.1
>
