Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 539A55473C8
	for <lists+netdev@lfdr.de>; Sat, 11 Jun 2022 12:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231815AbiFKKfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jun 2022 06:35:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbiFKKfi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jun 2022 06:35:38 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B29459316;
        Sat, 11 Jun 2022 03:35:37 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id me5so2430208ejb.2;
        Sat, 11 Jun 2022 03:35:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GpxAqJ7MKT7TBnj7STiXSamQkAfUNiRyf59KUsb+gv4=;
        b=GRW5JRHPVpqNWylUW4116B6JDuh7H+nKErw9Vh1eVDSFt1+KAEwoM9mNBWgjDD8wLp
         zVupH5fPj6tyUnILQAZIRiBAL6w8LKHXO8klEKDZ+SaBJCw/R/bH8lGWiZW/ARejk7sc
         oBx4HA3c6h5QFS/2KgL4YCNtMBfjzqT5JSt16/ZW55i5tVmbNdIlRZJpiM+MnfFTdgGq
         AzutQnuAGQ5HLnLwICZhy7eb2o+HAs2120syTv7GEW2WWNZUVT9v4Y8WuCYFDZDu8lwj
         429MiSqAA6YeC7Ex8wt2FghkxvhosaKKYp+LD+oGqSkkt3tl2v4E9kVbJo1vZQpaIi4d
         9iPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GpxAqJ7MKT7TBnj7STiXSamQkAfUNiRyf59KUsb+gv4=;
        b=xLEWBDhd47WFZBkY4SHZ/K2BjjMQjnLEJBTEvbA7VHAO/WLYPC5AT3921LdEHfaWWu
         f91zrRk0ewD4zy79vAfiHTA4P/9Kn6WxvflTDvvBQLla31J2Zx0QmlE5hiyAB27Mmu8X
         /ZIhmS78RujvG4I9aHEL5DU/kN7KdJwEYAeowfAJH+aAK1puNNJWXKrjaS3OzjVujKnM
         YUNl0SC1TrhVIxAghkk2g+WcLsytLmjZiNwlGnEdabMsIMSzV7pObSDUTfsxFxqdWS3F
         3xLtQNle+0BvLQoBZ71kQROT6i1f6CHYE4FDdZPchSkGHlSb4e+xhUVrSRAVtgSsxvHK
         bJpw==
X-Gm-Message-State: AOAM533twvPHZuYVEushiO1r0YJ5lwq6tpmW9ejPOQc2Ok74+/FWvFJG
        37D+IDcH7OBwJ0qgJ0lpqNQg6tU16i8YaonX4n8=
X-Google-Smtp-Source: ABdhPJxpcSDRnUXCS0yc8Wrs123Y2/OoSN/jBzDYC0syi3Aiu+Tdm1gm/qtLUHgc59KvMmiRRDSgej0BPu4GyEcGpLs=
X-Received: by 2002:a17:906:434f:b0:711:eb76:c320 with SMTP id
 z15-20020a170906434f00b00711eb76c320mr18646521ejm.636.1654943735816; Sat, 11
 Jun 2022 03:35:35 -0700 (PDT)
MIME-Version: 1.0
References: <20220610175655.776153-1-colin.foster@in-advantage.com> <20220610175655.776153-3-colin.foster@in-advantage.com>
In-Reply-To: <20220610175655.776153-3-colin.foster@in-advantage.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Sat, 11 Jun 2022 12:34:59 +0200
Message-ID: <CAHp75Vd0ZhP3TcpH2LGsb7=6Bqe1hoNU5i6DRyovKm7Vnz=HCw@mail.gmail.com>
Subject: Re: [PATCH v9 net-next 2/7] net: mdio: mscc-miim: add ability to be
 used in a non-mmio configuration
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     devicetree <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@kernel.org>,
        Terry Bowman <terry.bowman@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 10, 2022 at 7:57 PM Colin Foster
<colin.foster@in-advantage.com> wrote:
>
> There are a few Ocelot chips that contain the logic for this bus, but are
> controlled externally. Specifically the VSC7511, 7512, 7513, and 7514. In
> the externally controlled configurations these registers are not
> memory-mapped.
>
> Add support for these non-memory-mapped configurations.

...

> +       ocelot_platform_init_regmap_from_resource(pdev, 0, &mii_regmap, NULL,
> +                                                 &mscc_miim_regmap_config);

This is a bit non-standard, why not to follow the previously used API
design, i.e.

mii_regmap.map = ...

?

...

> +       ocelot_platform_init_regmap_from_resource(pdev, 1, &phy_regmap, &res,
> +                                                 &mscc_miim_phy_regmap_config);

Ditto.

Also here is the question how '_from_'  is aligned with '&res'. If
it's _from_ a resource then the resource is already a pointer.

...

>         if (res) {
> -               phy_regs = devm_ioremap_resource(dev, res);
> -               if (IS_ERR(phy_regs)) {
> -                       dev_err(dev, "Unable to map internal phy registers\n");
> -                       return PTR_ERR(phy_regs);
> -               }
> -
> -               phy_regmap = devm_regmap_init_mmio(dev, phy_regs,
> -                                                  &mscc_miim_phy_regmap_config);
>                 if (IS_ERR(phy_regmap)) {
>                         dev_err(dev, "Unable to create phy register regmap\n");
>                         return PTR_ERR(phy_regmap);
>                 }

This looks weird. You check an error here instead of the API you
called. It's a weird design, the rationale of which is doubtful and
has to be at least explained.

> +       } else {
> +               phy_regmap = NULL;
>         }

--
With Best Regards,
Andy Shevchenko
