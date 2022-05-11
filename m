Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AA81523576
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 16:29:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241511AbiEKO3C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 10:29:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231251AbiEKO3A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 10:29:00 -0400
Received: from mail-yb1-f179.google.com (mail-yb1-f179.google.com [209.85.219.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 552188FD4C;
        Wed, 11 May 2022 07:28:59 -0700 (PDT)
Received: by mail-yb1-f179.google.com with SMTP id e12so4300750ybc.11;
        Wed, 11 May 2022 07:28:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qTQsWzO3YZW4uR9nq/l9n7qJaYMCw4ErgRQiynA4kEg=;
        b=ZV0Iae6vKejP0m7BWxQuZsPkeeRuFbUVZ4SDI5/u8Vdk1B5C9CwB1HSzxi3hk33WBU
         q5DsrcsuH6Fa4pRndQk36T/x/DYCxrmnYdnY+H68/yCk27bN520vRTXQgI5EirAZZWAf
         fgAwgrau/eEqP7nwxkZBiE1LYKR05znvEUbEX27o+WxK88L4D6fnCL5JHtIrMzV4KhXE
         9n/jFcrM4o2civTiMod3BLQ+fYPe6H5seWtuH5mEIAmoEySBkY5swQy+gHxMzzNzvVm2
         Vi2aMxVmzP5XApbqOZa9expa3FvdYwaodeLV/Pl4QvTKs4X7qwE2Lb+dij/wmbV3gqdf
         An4Q==
X-Gm-Message-State: AOAM533Ll7PzdEMWfWE9S3iYAjmxK14HCc4AOdpj9ZaXE6o8KVy4xEbG
        jRXjTIKbwG15qZwz5ci7GyQKLZRQIeaIPhrAs3I=
X-Google-Smtp-Source: ABdhPJzUF1Hmo7chhIyI7QmLnOOhTeYUSu+/KrSyvQOVI3jgtw6tpn8zgdQR8STtyAp27JjupRvIDytVxTu6nPU33Lw=
X-Received: by 2002:a25:cb4b:0:b0:645:d702:eb15 with SMTP id
 b72-20020a25cb4b000000b00645d702eb15mr22026644ybg.500.1652279338443; Wed, 11
 May 2022 07:28:58 -0700 (PDT)
MIME-Version: 1.0
References: <20220511130240.790771-1-zhaojunkui2008@126.com>
In-Reply-To: <20220511130240.790771-1-zhaojunkui2008@126.com>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Wed, 11 May 2022 23:28:47 +0900
Message-ID: <CAMZ6RqJpgUkr0i4X4w5GxYKgiu9aX8KvQ3fJ9OB0Ob3kbL2abw@mail.gmail.com>
Subject: Re: [PATCH v2] usb/peak_usb: cleanup code
To:     Bernard Zhao <zhaojunkui2008@126.com>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        =?UTF-8?Q?Stefan_M=C3=A4tje?= <stefan.maetje@esd.eu>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bernard@vivo.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed. 11 May 2022 at 22:02, Bernard Zhao <zhaojunkui2008@126.com> wrote:
> The variable fi and bi only used in branch if (!dev->prev_siblings)
> , fi & bi not kmalloc in else branch, so move kfree into branch
> if (!dev->prev_siblings),this change is to cleanup the code a bit.
>
> Signed-off-by: Bernard Zhao <zhaojunkui2008@126.com>
>
> ---
> Changes since V1:
> * move all the content of the if (!dev->prev_siblings) to a new
> function.
> ---
>  drivers/net/can/usb/peak_usb/pcan_usb_pro.c | 57 +++++++++++++--------
>  1 file changed, 36 insertions(+), 21 deletions(-)
>
> diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_pro.c b/drivers/net/can/usb/peak_usb/pcan_usb_pro.c
> index ebe087f258e3..5e472fe086a8 100644
> --- a/drivers/net/can/usb/peak_usb/pcan_usb_pro.c
> +++ b/drivers/net/can/usb/peak_usb/pcan_usb_pro.c
> @@ -841,32 +841,28 @@ static int pcan_usb_pro_stop(struct peak_usb_device *dev)
>         return 0;
>  }
>
> -/*
> - * called when probing to initialize a device object.
> - */
> -static int pcan_usb_pro_init(struct peak_usb_device *dev)
> +static int pcan_usb_pro_init_first_channel(struct peak_usb_device *dev, struct pcan_usb_pro_interface **usb_if)
>  {
> -       struct pcan_usb_pro_device *pdev =
> -                       container_of(dev, struct pcan_usb_pro_device, dev);
> -       struct pcan_usb_pro_interface *usb_if = NULL;
> -       struct pcan_usb_pro_fwinfo *fi = NULL;
> -       struct pcan_usb_pro_blinfo *bi = NULL;
> +       struct pcan_usb_pro_interface *pusb_if = NULL;

Nitpick but I would expect the argument of the function to be named pusb_if:

struct pcan_usb_pro_interface **pusb_if

And this variable to be call usb_if:

struct pcan_usb_pro_interface *usb_if = NULL;

This is to be consistent with pcan_usb_pro_init() where the single
pointer is also named usb_if (and not pusb_if).

Also, you might as well consider not using and intermediate variable
and just do *pusb_if throughout all this helper function instead.

>         int err;
>
>         /* do this for 1st channel only */
>         if (!dev->prev_siblings) {
> +               struct pcan_usb_pro_fwinfo *fi = NULL;
> +               struct pcan_usb_pro_blinfo *bi = NULL;
> +
>                 /* allocate netdevices common structure attached to first one */
> -               usb_if = kzalloc(sizeof(struct pcan_usb_pro_interface),
> +               pusb_if = kzalloc(sizeof(struct pcan_usb_pro_interface),
>                                  GFP_KERNEL);
>                 fi = kmalloc(sizeof(struct pcan_usb_pro_fwinfo), GFP_KERNEL);
>                 bi = kmalloc(sizeof(struct pcan_usb_pro_blinfo), GFP_KERNEL);
> -               if (!usb_if || !fi || !bi) {
> +               if (!pusb_if || !fi || !bi) {
>                         err = -ENOMEM;
>                         goto err_out;

Did you test that code? Here, you are keeping the original err_out
label, correct? Aren't the variables fi and bi out of scope after the
err_out label?

>                 }
>
>                 /* number of ts msgs to ignore before taking one into account */
> -               usb_if->cm_ignore_count = 5;
> +               pusb_if->cm_ignore_count = 5;
>
>                 /*
>                  * explicit use of dev_xxx() instead of netdev_xxx() here:
> @@ -903,18 +899,14 @@ static int pcan_usb_pro_init(struct peak_usb_device *dev)
>                      pcan_usb_pro.name,
>                      bi->hw_rev, bi->serial_num_hi, bi->serial_num_lo,
>                      pcan_usb_pro.ctrl_count);
> +
> +               kfree(bi);
> +               kfree(fi);
>         } else {
> -               usb_if = pcan_usb_pro_dev_if(dev->prev_siblings);
> +               pusb_if = pcan_usb_pro_dev_if(dev->prev_siblings);
>         }

Sorry if I was not clear but I was thinking of just moving the if
block in a new function and leaving the else part of the original one
(c.f. below). This way, you lose one level on indentation and you can
have the declaration, the kmalloc() and the err_out label all at the
same indentation level in the function's main block.

> -       pdev->usb_if = usb_if;
> -       usb_if->dev[dev->ctrl_idx] = dev;
> -
> -       /* set LED in default state (end of init phase) */
> -       pcan_usb_pro_set_led(dev, PCAN_USBPRO_LED_DEVICE, 1);
> -
> -       kfree(bi);
> -       kfree(fi);
> +       *usb_if = pusb_if;
>
>         return 0;
>
> @@ -926,6 +918,29 @@ static int pcan_usb_pro_init(struct peak_usb_device *dev)
>         return err;
>  }
>
> +/*
> + * called when probing to initialize a device object.
> + */
> +static int pcan_usb_pro_init(struct peak_usb_device *dev)
> +{
> +       struct pcan_usb_pro_device *pdev =
> +                       container_of(dev, struct pcan_usb_pro_device, dev);
> +       struct pcan_usb_pro_interface *usb_if = NULL;
> +       int err;
> +
> +       err = pcan_usb_pro_init_first_channel(dev, &usb_if);
> +       if (err)
> +               return err;

I was thinking of this:

        if (!dev->prev_siblings) {
              err = pcan_usb_pro_init_first_channel(dev, &usb_if);
              if (err)
                     return err;
       } else {
               usb_if = pcan_usb_pro_dev_if(dev->prev_siblings);
        }
> +
> +       pdev->usb_if = usb_if;
> +       usb_if->dev[dev->ctrl_idx] = dev;
> +
> +       /* set LED in default state (end of init phase) */
> +       pcan_usb_pro_set_led(dev, PCAN_USBPRO_LED_DEVICE, 1);
> +
> +       return 0;
> +}
> +
>  static void pcan_usb_pro_exit(struct peak_usb_device *dev)
>  {
>         struct pcan_usb_pro_device *pdev =
> --
> 2.33.1
>
