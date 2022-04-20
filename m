Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8606D50893F
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 15:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379048AbiDTN2o convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 20 Apr 2022 09:28:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379036AbiDTN2l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 09:28:41 -0400
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D322C42A0C;
        Wed, 20 Apr 2022 06:25:54 -0700 (PDT)
Received: by mail-qt1-f170.google.com with SMTP id fu34so913641qtb.8;
        Wed, 20 Apr 2022 06:25:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=rFIpc07kdcdErSG52Vnbbh7AXlY7+Cv1PmRK4le+8hE=;
        b=qg+WFdkx4IbdGAhs6Qg8ioPAL7HPsKaHU9gHRJX4SoGOKv3t0XJrr6VSrjoyezTaLX
         cEAfNbtVAWjOkGXTB0BGTDKdf6ph1+vJtTQSqVqwpi+tfGtAv/CHct/aaAeVDgNCdj5L
         zGwf0cIgTKADFvc0LSXaAQvaT7ZrzGOZNmIgOFEvjxaO7cqN17QfpHkrGB+KAg0eBXve
         9MHe6YV611CU5lYPvMpp1tBHwojtqR7Vje6CDdNoL7WaKZV1x3Tns3kgzfRijuvtoX1g
         UejEVI9pGaRGJ1Hl/k6HPPMRjRJbQbZFa8oYuwqe7gDWcMPJXoz/EJWerv9ExzwWAoZM
         azLA==
X-Gm-Message-State: AOAM531cEGJVvRDu8jIqDbAABj+O2E6mBlsKPTLQqsx7QJSu0QoIt8Fm
        wWvfgoF+KurBQNisLxOJ4/31c3mQ2+EUBg==
X-Google-Smtp-Source: ABdhPJy1h9FAARtdksCNxxWNLmD6QSb2LbPLHU2aqWwqhgHDmK+7y/M0BDYaDsymgIgngtXhwDIaKg==
X-Received: by 2002:ac8:5f07:0:b0:2e1:d695:d857 with SMTP id x7-20020ac85f07000000b002e1d695d857mr13815421qta.40.1650461153730;
        Wed, 20 Apr 2022 06:25:53 -0700 (PDT)
Received: from mail-yb1-f170.google.com (mail-yb1-f170.google.com. [209.85.219.170])
        by smtp.gmail.com with ESMTPSA id n11-20020a05622a11cb00b002f344f11849sm293030qtk.71.2022.04.20.06.25.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Apr 2022 06:25:52 -0700 (PDT)
Received: by mail-yb1-f170.google.com with SMTP id f38so2841486ybi.3;
        Wed, 20 Apr 2022 06:25:52 -0700 (PDT)
X-Received: by 2002:a05:6902:724:b0:644:c37b:4e21 with SMTP id
 l4-20020a056902072400b00644c37b4e21mr19809816ybt.6.1650461152378; Wed, 20 Apr
 2022 06:25:52 -0700 (PDT)
MIME-Version: 1.0
References: <20220414122250.158113-1-clement.leger@bootlin.com> <20220414122250.158113-5-clement.leger@bootlin.com>
In-Reply-To: <20220414122250.158113-5-clement.leger@bootlin.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 20 Apr 2022 15:25:39 +0200
X-Gmail-Original-Message-ID: <CAMuHMdXcnZ64q+VAMW9f4PNTXR4o+zW9s7EHZQWWh++x94Pz7g@mail.gmail.com>
Message-ID: <CAMuHMdXcnZ64q+VAMW9f4PNTXR4o+zW9s7EHZQWWh++x94Pz7g@mail.gmail.com>
Subject: Re: [PATCH net-next 04/12] net: pcs: add Renesas MII converter driver
To:     =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
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
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Clément,

Thanks for your patch!
Only cosmetic comments from me, as I'm not too familiar with MII.

On Thu, Apr 14, 2022 at 2:24 PM Clément Léger <clement.leger@bootlin.com> wrote:
> Add PCS driver for the MII converter that is present on Renesas RZ/N1

Add a ... on the ...

> SoC. This MII converter is reponsible of converting MII to RMII/RGMII

responsible for

> or act as a MII passtrough. Exposing it as a PCS allows to reuse it

pass-through

> in both the switch driver and the stmmac driver. Currently, this driver
> only allows the PCS to be used by the dual Cortex-A7 subsystem since
> the register locking system is not used.
>
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>

> --- a/drivers/net/pcs/Kconfig
> +++ b/drivers/net/pcs/Kconfig
> @@ -18,4 +18,11 @@ config PCS_LYNX
>           This module provides helpers to phylink for managing the Lynx PCS
>           which is part of the Layerscape and QorIQ Ethernet SERDES.
>
> +config PCS_RZN1_MIIC
> +       tristate "Renesas RZN1 MII converter"

RZ/N1

> +       help
> +         This module provides a driver for the MII converter that is available
> +         on RZN1 SoC. This PCS convert MII to RMII/RGMII or can be in

RZ/N1

> +         passthrough mode for MII.
> +
>  endmenu

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
