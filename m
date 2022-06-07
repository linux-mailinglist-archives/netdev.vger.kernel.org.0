Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1A6D53FEFF
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 14:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243880AbiFGMho convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 7 Jun 2022 08:37:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243802AbiFGMg4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 08:36:56 -0400
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C848FE27BE;
        Tue,  7 Jun 2022 05:36:52 -0700 (PDT)
Received: by mail-qt1-f175.google.com with SMTP id y15so12480292qtx.4;
        Tue, 07 Jun 2022 05:36:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=jI9Eiy9NqYqthM/bM2aEWTmdS6Ov8FCqsQpj0jvzrm0=;
        b=i3xBIdu0Imzpn7+GeYihuu7FZqWWmUkazEo4w0O0JfJkM7NFbnww16nSsMSFMTi63J
         JTWuN+HETtLS1Y5fkmYBDcUOVvWwqhvOpWH6xy6RoqPkMkUfQso5BzvgDQ6o4T4VS1Rt
         EF3ySOVUrBr1UbmGhLHYW6vWT09lScATSRKYr9hGX9Mul0eAmxpJLyFo3LksEE5gqTM/
         +RvOAS1OXDaFm1XVKfh0OPFKEyODmUKNf9SIK9ZcLDLgkNKOfYWydhzrZRr7udEiV18O
         UcfMvwm5Qjsh7J+AoSH7zaULP/wWZM06S11g97yWYCTho902T+y11AxyNShLqgafZ/KA
         II4A==
X-Gm-Message-State: AOAM532Wsv1yYYwZaR6/bKwMD1Yfb8coa9nL0sMVLNRUD9oWdOs03zZP
        IdjRE0PZG/l9Pxp67ej1t3agCddLmjgyCQ==
X-Google-Smtp-Source: ABdhPJwGod2ZTC35dVzxa46M26uqJXqucakYCo0RId/YXLNI8RDb6tjB9wj6NF6g49Hm73uxz8q1Ig==
X-Received: by 2002:ac8:58ca:0:b0:2f3:da32:ab1 with SMTP id u10-20020ac858ca000000b002f3da320ab1mr22157947qta.308.1654605400840;
        Tue, 07 Jun 2022 05:36:40 -0700 (PDT)
Received: from mail-yb1-f179.google.com (mail-yb1-f179.google.com. [209.85.219.179])
        by smtp.gmail.com with ESMTPSA id f12-20020a05620a280c00b0069fe1dfbeffsm218111qkp.92.2022.06.07.05.36.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jun 2022 05:36:40 -0700 (PDT)
Received: by mail-yb1-f179.google.com with SMTP id p13so30908697ybm.1;
        Tue, 07 Jun 2022 05:36:40 -0700 (PDT)
X-Received: by 2002:a05:6902:a:b0:65c:b38e:6d9f with SMTP id
 l10-20020a056902000a00b0065cb38e6d9fmr30887112ybh.36.1654605399923; Tue, 07
 Jun 2022 05:36:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220526081550.1089805-1-saravanak@google.com> <20220526081550.1089805-9-saravanak@google.com>
In-Reply-To: <20220526081550.1089805-9-saravanak@google.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 7 Jun 2022 14:36:28 +0200
X-Gmail-Original-Message-ID: <CAMuHMdXrTjjNcqro+FA0BPJ+rK3bCAX+boYdf5=ZvGGocVJPMw@mail.gmail.com>
Message-ID: <CAMuHMdXrTjjNcqro+FA0BPJ+rK3bCAX+boYdf5=ZvGGocVJPMw@mail.gmail.com>
Subject: Re: [RFC PATCH v1 8/9] net: ipconfig: Force fw_devlink to unblock any
 devices that might probe
To:     Saravana Kannan <saravanak@google.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Daniel Scally <djrscally@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh@kernel.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        John Stultz <jstultz@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Android Kernel Team <kernel-team@android.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
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

On Thu, May 26, 2022 at 10:16 AM Saravana Kannan <saravanak@google.com> wrote:
> If there are network devices that could probe without some of their
> suppliers probing and those network devices are needed for IP auto
> config to work, then fw_devlink=on might break that usecase by blocking
> the network devices from probing by the time IP auto config starts.
>
> So, when IP auto config is enabled, make sure fw_devlink doesn't block
> the probing of any device that has a driver by the time we get to IP
> auto config.
>
> Signed-off-by: Saravana Kannan <saravanak@google.com>
> ---
>  net/ipv4/ipconfig.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/net/ipv4/ipconfig.c b/net/ipv4/ipconfig.c
> index 9d41d5d5cd1e..aa7b8ba68ca6 100644
> --- a/net/ipv4/ipconfig.c
> +++ b/net/ipv4/ipconfig.c
> @@ -1435,6 +1435,8 @@ static int __init wait_for_devices(void)
>  {
>         int i;
>
> +       fw_devlink_unblock_may_probe();
> +
>         for (i = 0; i < DEVICE_WAIT_MAX; i++) {
>                 struct net_device *dev;
>                 int found = 0;

FTR, this lacks an include <linux/fwnode.h>, as my mips rbtx4927
build fails with:

net/ipv4/ipconfig.c:1438:2: error: implicit declaration of function
‘fw_devlink_unblock_may_probe’ [-Werror=implicit-function-declaration]

Switching to v2 instead...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
