Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9EC8518925
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 17:53:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238993AbiECP5L convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 3 May 2022 11:57:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238925AbiECP5J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 11:57:09 -0400
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 715553B56C;
        Tue,  3 May 2022 08:53:36 -0700 (PDT)
Received: by mail-qv1-f42.google.com with SMTP id ke5so12466255qvb.5;
        Tue, 03 May 2022 08:53:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=xvR8faQDJaeveOR0Qcn9d2ECF2rJcFcyUs3ADmoPK9I=;
        b=56vogaJcR0Wkt8tOvJtqtL7jNep1Xf2b8nHgyRXDMYi9MeCBxJFSa6a3kFmZ/scm2T
         mr9+9T7O5QmRvP6H1XZPSXk16ZHQDD65KOnOQtgDy1l8oZE3/OtpDrNAEeUq5ixvI3fb
         hVTYKdSit3J6cCm4/gZCCAWOej60Vq7lRMo4sqd1DSHDffU6pte7aMK6KJ2VlwR/4t+f
         /rta7aa4Y1Y0oGiwwiJLf+YTySHgvvX6+f1wFgRxfE2i+53uFlDbGnvDZR7lSviwY3vN
         obeB6n5MJt8JRhkuiIt5Ze9rvWpbx5e9HkS09PZkW3sVsh04ispqccdYpkPZvEh1/6KT
         Rc9w==
X-Gm-Message-State: AOAM531RFV6c3GoEseuScyNbC/yVNtbmt05hKVOXLv6ZwdyCc3kl2MJs
        d4NkLYrOmr0Mav/s0M9HAO8YoAPphAHBrQ==
X-Google-Smtp-Source: ABdhPJw9kdkPNOIfzgKxpe2Cjg7Kc/swj7gKKtIAzrGkm63aCDaCwag8sYqB7aYd0GnVN90s+mrTfA==
X-Received: by 2002:a0c:fd8d:0:b0:456:3481:603c with SMTP id p13-20020a0cfd8d000000b004563481603cmr14175646qvr.69.1651593215274;
        Tue, 03 May 2022 08:53:35 -0700 (PDT)
Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com. [209.85.128.177])
        by smtp.gmail.com with ESMTPSA id b13-20020a05620a088d00b0069fd2a10ef7sm4325466qka.100.2022.05.03.08.53.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 May 2022 08:53:34 -0700 (PDT)
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-2f863469afbso160412567b3.0;
        Tue, 03 May 2022 08:53:34 -0700 (PDT)
X-Received: by 2002:a81:6588:0:b0:2f8:b75e:1e1a with SMTP id
 z130-20020a816588000000b002f8b75e1e1amr16162028ywb.358.1651593214307; Tue, 03
 May 2022 08:53:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220429143505.88208-1-clement.leger@bootlin.com> <20220429143505.88208-5-clement.leger@bootlin.com>
In-Reply-To: <20220429143505.88208-5-clement.leger@bootlin.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 3 May 2022 17:53:10 +0200
X-Gmail-Original-Message-ID: <CAMuHMdV1anDky+_hyCnsptuDnCN=eaY6RrsTVU36jujkFr+DqQ@mail.gmail.com>
Message-ID: <CAMuHMdV1anDky+_hyCnsptuDnCN=eaY6RrsTVU36jujkFr+DqQ@mail.gmail.com>
Subject: Re: [net-next v2 04/12] net: pcs: add Renesas MII converter driver
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
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Clément,

On Fri, Apr 29, 2022 at 4:36 PM Clément Léger <clement.leger@bootlin.com> wrote:
> Add a PCS driver for the MII converter that is present on the Renesas
> RZ/N1 SoC. This MII converter is reponsible for converting MII to
> RMII/RGMII or act as a MII pass-trough. Exposing it as a PCS allows to
> reuse it in both the switch driver and the stmmac driver. Currently,
> this driver only allows the PCS to be used by the dual Cortex-A7
> subsystem since the register locking system is not used.
>
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>

> --- a/drivers/net/pcs/Kconfig
> +++ b/drivers/net/pcs/Kconfig
> @@ -18,4 +18,11 @@ config PCS_LYNX
>           This module provides helpers to phylink for managing the Lynx PCS
>           which is part of the Layerscape and QorIQ Ethernet SERDES.
>
> +config PCS_RZN1_MIIC
> +       tristate "Renesas RZ/N1 MII converter"

depends on ARCH_RZN1 || COMPILE_TEST

> +       help
> +         This module provides a driver for the MII converter that is available
> +         on RZ/N1 SoCs. This PCS convert MII to RMII/RGMII or can be set in

converts

> +         pass-through mode for MII.
> +

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
> +       miic->nclk = devm_clk_bulk_get_all(dev, &miic->clks);
> +       if (miic->nclk < 0)
> +               return miic->nclk;
> +
> +       ret = clk_bulk_prepare_enable(miic->nclk, miic->clks);
> +       if (ret)
> +               return ret;

As you don't seem to need any knowledge about the clocks' properties,
perhaps you can use Runtime PM instead?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
