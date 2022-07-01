Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18A23562CA1
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 09:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234807AbiGAHap (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 03:30:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230523AbiGAHan (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 03:30:43 -0400
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAED36B816;
        Fri,  1 Jul 2022 00:30:42 -0700 (PDT)
Received: by mail-qv1-f46.google.com with SMTP id cs6so3346520qvb.6;
        Fri, 01 Jul 2022 00:30:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YU1XddcO32RLHJVgcyV4xbGLKtUqtr7Z4CGj+gDtTi4=;
        b=VkpdRWCRntWC8WiwirkMoru7TKi6USC/NtwS2PZ4hGyli2lDhw88rAPX4qj4kNGy92
         bOPCi/3NfuwYw+ZD5l58OlDRV6TBSm3nrzyJhYe5YtnavvxB7Er4qj9B2enXoxKffNML
         8LdlKKoAP7lHt6RHVfftT2Y5CrXXwDA2Pgk/0B2I7zZDT8Ncsr2oeXznWIHoQH0i53R3
         dNtRAndUEnchZtHYhrfZPp9PSKz6x24/m26Y1xR2MF7TANjABtMAyFVVmyEV8x//UjmM
         qZYummJcpHySLdxM6tSQ+dwlkbl9IVN/Ot+1Mj4AcSYQcLDVOcDwb2tZuYwe50b4YCUS
         2YOQ==
X-Gm-Message-State: AJIora+5XdTQQ+EqLTpeKUXj5kJBtCODY43VrAiMkEpfQ7g9x7pLiOka
        APBsfPt+osBwL7vz47kbMC4iqDl/18eB3A==
X-Google-Smtp-Source: AGRyM1uPm/dzjQeUTCuNo2BRTxrRYx2CQxjdWBttFkrF/KcFFazSri6wYThC+6RMF6XK/5fp9CMW4g==
X-Received: by 2002:a05:622a:3ce:b0:305:2667:5103 with SMTP id k14-20020a05622a03ce00b0030526675103mr11208027qtx.7.1656660641568;
        Fri, 01 Jul 2022 00:30:41 -0700 (PDT)
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com. [209.85.128.171])
        by smtp.gmail.com with ESMTPSA id v2-20020a05622a130200b00304e47b9602sm15428507qtk.9.2022.07.01.00.30.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Jul 2022 00:30:40 -0700 (PDT)
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-31780ad7535so15241047b3.8;
        Fri, 01 Jul 2022 00:30:39 -0700 (PDT)
X-Received: by 2002:a0d:c787:0:b0:31b:a963:e1de with SMTP id
 j129-20020a0dc787000000b0031ba963e1demr15110386ywd.283.1656660639601; Fri, 01
 Jul 2022 00:30:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220601070707.3946847-1-saravanak@google.com>
 <20220601070707.3946847-2-saravanak@google.com> <YrFzK6EiVvXmzVG6@atomide.com>
 <4799738.LvFx2qVVIh@steina-w> <CAGETcx_1qa=gGT4LVkyPpcA1vFM9FzuJE+0DhL_nFyg5cbFjVg@mail.gmail.com>
In-Reply-To: <CAGETcx_1qa=gGT4LVkyPpcA1vFM9FzuJE+0DhL_nFyg5cbFjVg@mail.gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 1 Jul 2022 09:30:28 +0200
X-Gmail-Original-Message-ID: <CAMuHMdUJbWtTvDdtJGcDKfdULA+uqo_HGaiOz4p2UjszAJtsRQ@mail.gmail.com>
Message-ID: <CAMuHMdUJbWtTvDdtJGcDKfdULA+uqo_HGaiOz4p2UjszAJtsRQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/9] PM: domains: Delete usage of driver_deferred_probe_check_state()
To:     Saravana Kannan <saravanak@google.com>
Cc:     Alexander Stein <alexander.stein@ew.tq-group.com>,
        Tony Lindgren <tony@atomide.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Kevin Hilman <khilman@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>
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

Hi Saravana,

On Fri, Jul 1, 2022 at 2:37 AM Saravana Kannan <saravanak@google.com> wrote:
> On Thu, Jun 23, 2022 at 5:08 AM Alexander Stein
> <alexander.stein@ew.tq-group.com> wrote:
> > Am Dienstag, 21. Juni 2022, 09:28:43 CEST schrieb Tony Lindgren:

> > > * Saravana Kannan <saravanak@google.com> [700101 02:00]:
> > > > Now that fw_devlink=on by default and fw_devlink supports
> > > > "power-domains" property, the execution will never get to the point
> > > > where driver_deferred_probe_check_state() is called before the supplier
> > > > has probed successfully or before deferred probe timeout has expired.
> > > >
> > > > So, delete the call and replace it with -ENODEV.
> > >
> > > Looks like this causes omaps to not boot in Linux next. With this
> > > simple-pm-bus fails to probe initially as the power-domain is not
> > > yet available. On platform_probe() genpd_get_from_provider() returns
> > > -ENOENT.
> > >
> > > Seems like other stuff is potentially broken too, any ideas on
> > > how to fix this?
> >
> > I think I'm hit by this as well, although I do not get a lockup.
> > In my case I'm using arch/arm64/boot/dts/freescale/imx8mq-tqma8mq-mba8mx.dts
> > and probing of 38320000.blk-ctrl fails as the power-domain is not (yet)
> > registed.
>
> Ok, took a look.
>
> The problem is that there are two drivers for the same device and they
> both initialize this device.
>
>     gpc: gpc@303a0000 {
>         compatible = "fsl,imx8mq-gpc";
>     }
>
> $ git grep -l "fsl,imx7d-gpc" -- drivers/
> drivers/irqchip/irq-imx-gpcv2.c
> drivers/soc/imx/gpcv2.c

You missed the "driver" in arch/arm/mach-imx/src.c ;-)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
