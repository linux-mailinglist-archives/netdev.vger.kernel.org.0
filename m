Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA9C33C7FD8
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 10:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238458AbhGNIRj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 04:17:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbhGNIRi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 04:17:38 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E1A5C06175F;
        Wed, 14 Jul 2021 01:14:46 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id c17so1906981ejk.13;
        Wed, 14 Jul 2021 01:14:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VaUCVoNr+2EuGOH3CuGBqSBfdj5qCHl1IbtbxJNGpJg=;
        b=gSTtx/KWr94p6z1RtbmqFP4v1e2SmEtdC6IRqdDx/xUw/Q2Q18VNAW6fPxkvT2Jjs+
         jzV3i0Vq4r5flzvRuvRvb7HWNVWIPBNUN59Blot0+2G0nS+mno8UwIVmjlikSGvmXLME
         Z5KqrlaT8QKPv1O6JfwRA6u6R4O0j1BQLLpxMsTxMjaVoU27dK2gNzDtUaixzPwDdgia
         LcF5P7igr0LHk83T2HisRApPAGhTnj+GSAIOWziBKWSDX9bdW55hfvgHnEZEtoBPsDM3
         h2zFybo8x14h2d6dufResiKTEurRXdrBZGg8g6AFWq8r/w3xoLmVo7PiSSTv8ax8xzJV
         8Cfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VaUCVoNr+2EuGOH3CuGBqSBfdj5qCHl1IbtbxJNGpJg=;
        b=cniOF2Wfkv3aaKHFLIXPJAqTEKwTryNFXnv+gafH4Qkc1eOL0iZVXspMXGygEQGq3c
         h59e2mv5ubpM/hxXB8oEWx4n7PJ/rmaBXbqYKKIDyOb9bd32tq4Xe8HfltzwfatMSOzr
         7kUmFGEqtcz6ph6xdpIzX0Y9m06AAkTHWIYoRHuSGeasuo8axUBBINV2EP3RDTzql7Pv
         E0zocHYM1342+kh/M339kU8ApxWqVZmvWcND//ePa+AVENpQcrwPhgLK3espPNbKLIHZ
         FUhL/qlDNB9bBD+MNUpPPUJPcD7M2KIF/oCae9qDkEUWbBjB217G6Jr0IHWj/cvCdhpy
         4o4w==
X-Gm-Message-State: AOAM532OP5R/cL12SXHdSGzqOn+5n1/apSZFZVnCW5eLw/YkcFBEOepB
        PSzVKo1TC9ShbfGGxb0suCN4F50dGu/ySLAKKVU=
X-Google-Smtp-Source: ABdhPJw5UhysBN6BMKKYdUzC2Pk1da8QCisRxuR5IYZoAp0LtO/Y3hB/3rENMmF2MNa1tbPRLWbAuoBnlFWrM/56JqU=
X-Received: by 2002:a17:906:4784:: with SMTP id cw4mr11008310ejc.160.1626250485010;
 Wed, 14 Jul 2021 01:14:45 -0700 (PDT)
MIME-Version: 1.0
References: <20210714081127.675743-1-mudongliangabcd@gmail.com>
In-Reply-To: <20210714081127.675743-1-mudongliangabcd@gmail.com>
From:   Dongliang Mu <mudongliangabcd@gmail.com>
Date:   Wed, 14 Jul 2021 16:14:18 +0800
Message-ID: <CAD-N9QXRRipmyOiUFDx9OdM47c37Y+oAa+T-ntZAGZXrd8MTrA@mail.gmail.com>
Subject: Re: [PATCH 1/2] usb: hso: fix error handling code of hso_create_net_device
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        YueHaibing <yuehaibing@huawei.com>,
        Anirudh Rayabharam <mail@anirudhrb.com>,
        Oliver Neukum <oneukum@suse.com>,
        Jakub Kicinski <kuba@kernel.org>,
        syzbot+44d53c7255bb1aea22d2@syzkaller.appspotmail.com,
        Zheng Yongjun <zhengyongjun3@huawei.com>,
        Emil Renner Berthing <kernel@esmil.dk>,
        linux-usb@vger.kernel.org,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hovold <johan@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 14, 2021 at 4:11 PM Dongliang Mu <mudongliangabcd@gmail.com> wrote:
>
> The current error handling code of hso_create_net_device is
> hso_free_net_device, no matter which errors lead to. For example,
> WARNING in hso_free_net_device [1].
>
> Fix this by refactoring the error handling code of
> hso_create_net_device by handling different errors by different code.
>

Hi Dan,

Please take a look at this version. I forget about the changelog about
this patch. I will send a version v3 with your further comment if you
have.

> [1] https://syzkaller.appspot.com/bug?id=66eff8d49af1b28370ad342787413e35bbe76efe
>
> Reported-by: syzbot+44d53c7255bb1aea22d2@syzkaller.appspotmail.com
> Fixes: 5fcfb6d0bfcd ("hso: fix bailout in error case of probe")
> Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
> ---
>  drivers/net/usb/hso.c | 33 +++++++++++++++++++++++----------
>  1 file changed, 23 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
> index 54ef8492ca01..39c4e88eab62 100644
> --- a/drivers/net/usb/hso.c
> +++ b/drivers/net/usb/hso.c
> @@ -2495,7 +2495,7 @@ static struct hso_device *hso_create_net_device(struct usb_interface *interface,
>                            hso_net_init);
>         if (!net) {
>                 dev_err(&interface->dev, "Unable to create ethernet device\n");
> -               goto exit;
> +               goto err_hso_dev;
>         }
>
>         hso_net = netdev_priv(net);
> @@ -2508,13 +2508,13 @@ static struct hso_device *hso_create_net_device(struct usb_interface *interface,
>                                       USB_DIR_IN);
>         if (!hso_net->in_endp) {
>                 dev_err(&interface->dev, "Can't find BULK IN endpoint\n");
> -               goto exit;
> +               goto err_net;
>         }
>         hso_net->out_endp = hso_get_ep(interface, USB_ENDPOINT_XFER_BULK,
>                                        USB_DIR_OUT);
>         if (!hso_net->out_endp) {
>                 dev_err(&interface->dev, "Can't find BULK OUT endpoint\n");
> -               goto exit;
> +               goto err_net;
>         }
>         SET_NETDEV_DEV(net, &interface->dev);
>         SET_NETDEV_DEVTYPE(net, &hso_type);
> @@ -2523,18 +2523,18 @@ static struct hso_device *hso_create_net_device(struct usb_interface *interface,
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
> +               goto err_mux_bulk_rx;
>         hso_net->mux_bulk_tx_buf = kzalloc(MUX_BULK_TX_BUF_SIZE, GFP_KERNEL);
>         if (!hso_net->mux_bulk_tx_buf)
> -               goto exit;
> +               goto err_mux_bulk_tx;
>
>         add_net_device(hso_dev);
>
> @@ -2542,7 +2542,7 @@ static struct hso_device *hso_create_net_device(struct usb_interface *interface,
>         result = register_netdev(net);
>         if (result) {
>                 dev_err(&interface->dev, "Failed to register device\n");
> -               goto exit;
> +               goto err_register;
>         }
>
>         hso_log_port(hso_dev);
> @@ -2550,8 +2550,21 @@ static struct hso_device *hso_create_net_device(struct usb_interface *interface,
>         hso_create_rfkill(hso_dev, interface);
>
>         return hso_dev;
> -exit:
> -       hso_free_net_device(hso_dev, true);
> +
> +err_register:
> +       remove_net_device(hso_dev);
> +       kfree(hso_net->mux_bulk_tx_buf);
> +err_mux_bulk_tx:
> +       usb_free_urb(hso_net->mux_bulk_tx_urb);
> +err_mux_bulk_rx:
> +       for (i = 0; i < MUX_BULK_RX_BUF_COUNT; i++) {
> +               usb_free_urb(hso_net->mux_bulk_rx_urb_pool[i]);
> +               kfree(hso_net->mux_bulk_rx_buf_pool[i]);
> +       }
> +err_net:
> +       free_netdev(net);
> +err_hso_dev:
> +       kfree(hso_dev);
>         return NULL;
>  }
>
> --
> 2.25.1
>
