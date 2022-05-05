Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B70B51B896
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 09:17:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343636AbiEEHUh convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 5 May 2022 03:20:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343586AbiEEHUb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 03:20:31 -0400
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BECE3CFE4;
        Thu,  5 May 2022 00:16:53 -0700 (PDT)
Received: by mail-qt1-f169.google.com with SMTP id fu47so2570467qtb.5;
        Thu, 05 May 2022 00:16:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Psb/QuXIO3rdiKJBYSV64pOzSRPQoJS6TszufIyjNe8=;
        b=g2oXlQYt/GvBDNAKvS1NTWm5TO2W3PXM4aHDp1hk1eVk5SPrnIXuWalW+cnQA7UkLx
         dHhDqz8AV+ww1QH+CZKGrqsWA1cRorVvFiqjZmicr2eN0/oBPAfFfnRl6r2a5zL+wMac
         UGwtRNf8jqTMNojHw2e30toFvvGOJ1ee25KYALeyGpdNWhrulhjYi1ZRfCDmfywTsqBh
         ToQA+VG0iANMMQGGGDt4S2xM1MTPB6B65H+XtopNi0PnQy2ybXw7YqQtEpJIFB+4q446
         7Vj1IGlMYob0fjrKUMOWfoYqIDOXXBA/p2y2p19YUYm262qzR/uJTkku3YBr2ItCIQR0
         OxVQ==
X-Gm-Message-State: AOAM533Nb2QkuJUGGkW1TGiv8eLNeOfUkTQlWi5VrQSuysEpMXEEN3g4
        F/kxt0RVdPcS0xUv7nUyd/C3uDKPD0sUiw==
X-Google-Smtp-Source: ABdhPJxfcJiP6e3pG1LiEAfAF5dLVDxXwJYl+kiyO2WxFqjRf6BA2lTAv1LUus/hlk6wsBIhMPjW5w==
X-Received: by 2002:ac8:7d4a:0:b0:2f3:bbe2:f97f with SMTP id h10-20020ac87d4a000000b002f3bbe2f97fmr1592188qtb.355.1651735012120;
        Thu, 05 May 2022 00:16:52 -0700 (PDT)
Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com. [209.85.219.171])
        by smtp.gmail.com with ESMTPSA id w24-20020ac87198000000b002f39b99f697sm426369qto.49.2022.05.05.00.16.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 May 2022 00:16:50 -0700 (PDT)
Received: by mail-yb1-f171.google.com with SMTP id f38so6205971ybi.3;
        Thu, 05 May 2022 00:16:50 -0700 (PDT)
X-Received: by 2002:a05:6902:352:b0:63e:94c:883c with SMTP id
 e18-20020a056902035200b0063e094c883cmr19378252ybs.365.1651735010190; Thu, 05
 May 2022 00:16:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220504093000.132579-1-clement.leger@bootlin.com> <20220504093000.132579-5-clement.leger@bootlin.com>
In-Reply-To: <20220504093000.132579-5-clement.leger@bootlin.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 5 May 2022 09:16:38 +0200
X-Gmail-Original-Message-ID: <CAMuHMdU1dF25eKeihBO3xRarW-acG0vUSggWfKOwG3v=7eN+bg@mail.gmail.com>
Message-ID: <CAMuHMdU1dF25eKeihBO3xRarW-acG0vUSggWfKOwG3v=7eN+bg@mail.gmail.com>
Subject: Re: [PATCH net-next v3 04/12] net: pcs: add Renesas MII converter driver
To:     =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?Q?Miqu=C3=A8l_Raynal?= <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Clément,

On Wed, May 4, 2022 at 11:31 AM Clément Léger <clement.leger@bootlin.com> wrote:
> Add a PCS driver for the MII converter that is present on the Renesas
> RZ/N1 SoC. This MII converter is reponsible for converting MII to
> RMII/RGMII or act as a MII pass-trough. Exposing it as a PCS allows to
> reuse it in both the switch driver and the stmmac driver. Currently,
> this driver only allows the PCS to be used by the dual Cortex-A7
> subsystem since the register locking system is not used.
>
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>

Thanks for your patch!

> --- /dev/null
> +++ b/drivers/net/pcs/pcs-rzn1-miic.c

> +static int miic_probe(struct platform_device *pdev)
> +{
> +       struct device *dev = &pdev->dev;
> +       struct miic *miic;
> +       u32 mode_cfg;
> +       int ret;
> +
> +       ret = miic_parse_dt(dev, &mode_cfg);
> +       if (ret < 0)
> +               return -EINVAL;
> +
> +       miic = devm_kzalloc(dev, sizeof(*miic), GFP_KERNEL);
> +       if (!miic)
> +               return -ENOMEM;
> +
> +       spin_lock_init(&miic->lock);
> +       miic->dev = dev;
> +       miic->base = devm_platform_ioremap_resource(pdev, 0);
> +       if (!miic->base)
> +               return -EINVAL;
> +
> +       pm_runtime_enable(dev);
> +       ret = pm_runtime_resume_and_get(dev);
> +       if (ret < 0)

Missing pm_runtime_disable(dev).

> +               return ret;
> +
> +       ret = miic_init_hw(miic, mode_cfg);
> +       if (ret)
> +               goto disable_runtime_pm;
> +
> +       /* miic_create() relies on that fact that data are attached to the
> +        * platform device to determine if the driver is ready so this needs to
> +        * be the last thing to be done after everything is initialized
> +        * properly.
> +        */
> +       platform_set_drvdata(pdev, miic);
> +
> +       return 0;
> +
> +disable_runtime_pm:
> +       pm_runtime_put(dev);

Missing pm_runtime_disable(dev).

> +
> +       return ret;
> +}
> +
> +static int miic_remove(struct platform_device *pdev)
> +{
> +       pm_runtime_put(&pdev->dev);

Missing pm_runtime_disable(dev).

> +
> +       return 0;
> +}

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
