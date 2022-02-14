Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96FF14B44FA
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 09:55:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242497AbiBNIyh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 03:54:37 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232624AbiBNIyf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 03:54:35 -0500
Received: from mail-ua1-f45.google.com (mail-ua1-f45.google.com [209.85.222.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D36695F8F7;
        Mon, 14 Feb 2022 00:54:27 -0800 (PST)
Received: by mail-ua1-f45.google.com with SMTP id d22so7786120uaw.2;
        Mon, 14 Feb 2022 00:54:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PlmHX1HHokXQyxG79YUgUTlDvUDqxBtLYhszaegEBgU=;
        b=h3i1Z8nzAqun82XBV2fD/ig2HLw+teGNCAASQWMQCFHDqI9t1uT19oEhh5zEZcIuU+
         Bq3M8b9AmuTXFPT84yAOeBuUNlrysibURMR6OFHVHsD4WrkQnARv4DbIUAbb6fVafQYz
         n172V7K6PZnDeeErnHT3ZVLSeODa4Uxr7vKqr+4Qh3IZkb1Lwq4hfOUAq6oanfaahh4c
         ghhcMiriuy/5i9xtOyfs2wSI6J4suyWEIwgNarLHNyUsNJeti7MrmGpdUw77pFM2B3V0
         /VJlWZc3rJUCup9upp+0A3Mec9VHJCM+6ibN/KD5zeMv88Z6ScxHA1wIuvLnRfmNFN+n
         aU6A==
X-Gm-Message-State: AOAM532F4oFYgfApr/7sdQbGuIoS9AFkHxff6rc6B32WlsyWg9I0qJIE
        ufp0G3r2jjEdlorzDZU2+umJO9CvkAFUt1FE
X-Google-Smtp-Source: ABdhPJxG80+yVkBa/7DTSNK/cqa8g80w345JgDTQHyE4Tngp2pMgRHKbDaroOYU2h5FNY9Fr2rotSQ==
X-Received: by 2002:a05:6130:413:: with SMTP id ba19mr3797932uab.4.1644828866592;
        Mon, 14 Feb 2022 00:54:26 -0800 (PST)
Received: from mail-vk1-f177.google.com (mail-vk1-f177.google.com. [209.85.221.177])
        by smtp.gmail.com with ESMTPSA id q131sm2271072vkq.23.2022.02.14.00.54.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Feb 2022 00:54:26 -0800 (PST)
Received: by mail-vk1-f177.google.com with SMTP id l14so8568053vko.12;
        Mon, 14 Feb 2022 00:54:25 -0800 (PST)
X-Received: by 2002:a05:6122:c8f:: with SMTP id ba15mr3731293vkb.39.1644828865522;
 Mon, 14 Feb 2022 00:54:25 -0800 (PST)
MIME-Version: 1.0
References: <20220212201631.12648-1-s.shtylyov@omp.ru> <20220212201631.12648-2-s.shtylyov@omp.ru>
In-Reply-To: <20220212201631.12648-2-s.shtylyov@omp.ru>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 14 Feb 2022 09:54:14 +0100
X-Gmail-Original-Message-ID: <CAMuHMdUPxX7Tja6BCjEb4KDobNFPMcM66Fk7Z+VsO7pgb8JnjA@mail.gmail.com>
Message-ID: <CAMuHMdUPxX7Tja6BCjEb4KDobNFPMcM66Fk7Z+VsO7pgb8JnjA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] platform: make platform_get_irq_optional() optional
To:     Sergey Shtylyov <s.shtylyov@omp.ru>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        linux-kernel@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Corey Minyard <minyard@acm.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        William Breathitt Gray <vilhelm.gray@gmail.com>,
        Mun Yew Tham <mun.yew.tham@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Thierry Reding <thierry.reding@gmail.com>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, Lee Jones <lee.jones@linaro.org>,
        Kamal Dasu <kdasu.kdev@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Peter Korsgaard <peter@korsgaard.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        Benson Leung <bleung@chromium.org>,
        Guenter Roeck <groeck@chromium.org>,
        Zha Qipeng <qipeng.zha@intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        John Garry <john.garry@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        =?UTF-8?Q?Niklas_S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amitk@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Eric Auger <eric.auger@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        openipmi-developer@lists.sourceforge.net,
        linux-iio@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-pwm@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mmc@vger.kernel.org,
        linux-mtd@lists.infradead.org, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-phy@lists.infradead.org,
        platform-driver-x86@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-serial@vger.kernel.org, kvm@vger.kernel.org,
        alsa-devel@alsa-project.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
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

Hi Sergey,

On Sat, Feb 12, 2022 at 9:17 PM Sergey Shtylyov <s.shtylyov@omp.ru> wrote:
> This patch is based on the former Andy Shevchenko's patch:
>
> https://lore.kernel.org/lkml/20210331144526.19439-1-andriy.shevchenko@linux.intel.com/
>
> Currently platform_get_irq_optional() returns an error code even if IRQ
> resource simply has not been found.  It prevents the callers from being
> error code agnostic in their error handling:
>
>         ret = platform_get_irq_optional(...);
>         if (ret < 0 && ret != -ENXIO)
>                 return ret; // respect deferred probe
>         if (ret > 0)
>                 ...we get an IRQ...
>
> All other *_optional() APIs seem to return 0 or NULL in case an optional
> resource is not available.  Let's follow this good example, so that the
> callers would look like:
>
>         ret = platform_get_irq_optional(...);
>         if (ret < 0)
>                 return ret;
>         if (ret > 0)
>                 ...we get an IRQ...
>
> Reported-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
> Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
> ---
> Changes in version 2:

Thanks for the update!

>  drivers/base/platform.c                  | 60 +++++++++++++++---------

The core change LGTM.

I'm only looking at Renesas drivers below...

> --- a/drivers/mmc/host/sh_mmcif.c
> +++ b/drivers/mmc/host/sh_mmcif.c
> @@ -1465,14 +1465,14 @@ static int sh_mmcif_probe(struct platform_device *pdev)
>         sh_mmcif_sync_reset(host);
>         sh_mmcif_writel(host->addr, MMCIF_CE_INT_MASK, MASK_ALL);
>
> -       name = irq[1] < 0 ? dev_name(dev) : "sh_mmc:error";
> +       name = irq[1] <= 0 ? dev_name(dev) : "sh_mmc:error";

"== 0" should be sufficient here, if the code above would bail out
on errors returned by platform_get_irq_optional(), which it currently
doesn't do.
As this adds missing error handling, this is to be fixed by a separate
patch later?

>         ret = devm_request_threaded_irq(dev, irq[0], sh_mmcif_intr,
>                                         sh_mmcif_irqt, 0, name, host);
>         if (ret) {
>                 dev_err(dev, "request_irq error (%s)\n", name);
>                 goto err_clk;
>         }
> -       if (irq[1] >= 0) {
> +       if (irq[1] > 0) {

OK.

>                 ret = devm_request_threaded_irq(dev, irq[1],
>                                                 sh_mmcif_intr, sh_mmcif_irqt,
>                                                 0, "sh_mmc:int", host);

> --- a/drivers/phy/renesas/phy-rcar-gen3-usb2.c
> +++ b/drivers/phy/renesas/phy-rcar-gen3-usb2.c
> @@ -439,7 +439,7 @@ static int rcar_gen3_phy_usb2_init(struct phy *p)
>         u32 val;
>         int ret;
>
> -       if (!rcar_gen3_is_any_rphy_initialized(channel) && channel->irq >= 0) {
> +       if (!rcar_gen3_is_any_rphy_initialized(channel) && channel->irq > 0) {
>                 INIT_WORK(&channel->work, rcar_gen3_phy_usb2_work);
>                 ret = request_irq(channel->irq, rcar_gen3_phy_usb2_irq,
>                                   IRQF_SHARED, dev_name(channel->dev), channel);
> @@ -486,7 +486,7 @@ static int rcar_gen3_phy_usb2_exit(struct phy *p)
>                 val &= ~USB2_INT_ENABLE_UCOM_INTEN;
>         writel(val, usb2_base + USB2_INT_ENABLE);
>
> -       if (channel->irq >= 0 && !rcar_gen3_is_any_rphy_initialized(channel))
> +       if (channel->irq > 0 && !rcar_gen3_is_any_rphy_initialized(channel))
>                 free_irq(channel->irq, channel);
>
>         return 0;

LGTM, but note that all errors returned by platform_get_irq_optional()
are currently ignored, even real errors, which should be propagated
up.
As this adds missing error handling, this is to be fixed by a separate
patch later?

> --- a/drivers/thermal/rcar_gen3_thermal.c
> +++ b/drivers/thermal/rcar_gen3_thermal.c
> @@ -432,6 +432,8 @@ static int rcar_gen3_thermal_request_irqs(struct rcar_gen3_thermal_priv *priv,
>                 irq = platform_get_irq_optional(pdev, i);
>                 if (irq < 0)
>                         return irq;
> +               if (!irq)
> +                       return -ENXIO;

While correct, and preserving existing behavior, this looks strange
to me.  Probably this should return zero instead (i.e. the check
above should be changed to "<= 0"), and the caller should start caring
about and propagating up real errors.
As this adds missing error handling, this is to be fixed by a separate
patch later?

>
>                 irqname = devm_kasprintf(dev, GFP_KERNEL, "%s:ch%d",
>                                          dev_name(dev), i);
> diff --git a/drivers/tty/serial/8250/8250_mtk.c b/drivers/tty/serial/8250/8250_mtk.c
> index fb65dc601b23..328ab074fd89 100644

> --- a/drivers/tty/serial/sh-sci.c
> +++ b/drivers/tty/serial/sh-sci.c

I think you missed

    #define SCIx_IRQ_IS_MUXED(port)                 \
            ((port)->irqs[SCIx_ERI_IRQ] ==  \
             (port)->irqs[SCIx_RXI_IRQ]) || \
            ((port)->irqs[SCIx_ERI_IRQ] &&  \
             ((port)->irqs[SCIx_RXI_IRQ] < 0))

above? The last condition should become "<= 0".

> @@ -1915,7 +1915,7 @@ static int sci_request_irq(struct sci_port *port)
>                          * Certain port types won't support all of the
>                          * available interrupt sources.
>                          */
> -                       if (unlikely(irq < 0))
> +                       if (unlikely(irq <= 0))
>                                 continue;
>                 }
>
> @@ -1963,7 +1963,7 @@ static void sci_free_irq(struct sci_port *port)
>                  * Certain port types won't support all of the available
>                  * interrupt sources.
>                  */
> -               if (unlikely(irq < 0))
> +               if (unlikely(irq <= 0))
>                         continue;
>
>                 /* Check if already freed (irq was muxed) */
> @@ -2875,7 +2875,7 @@ static int sci_init_single(struct platform_device *dev,
>         if (sci_port->irqs[0] < 0)
>                 return -ENXIO;
>
> -       if (sci_port->irqs[1] < 0)
> +       if (sci_port->irqs[1] <= 0)
>                 for (i = 1; i < ARRAY_SIZE(sci_port->irqs); i++)
>                         sci_port->irqs[i] = sci_port->irqs[0];
>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
