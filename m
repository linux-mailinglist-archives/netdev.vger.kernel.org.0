Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08D365473B9
	for <lists+netdev@lfdr.de>; Sat, 11 Jun 2022 12:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231567AbiFKK1L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jun 2022 06:27:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbiFKK1K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jun 2022 06:27:10 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D8D117E32;
        Sat, 11 Jun 2022 03:27:09 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id gl15so2384521ejb.4;
        Sat, 11 Jun 2022 03:27:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KIxsSmffb8RfNqJlYqJ6d8OJHZPkWprEKP9BjZRzvY4=;
        b=DmYimP8x9+fBNO5W9V+LPablLcvvdeYRzWgAyGF0whEQX/wYY7V7xjcwFUKEmTPA4c
         mpZwcvHCTA94+Rc/oh9sohMYfnkdY/QD/+ajvNzddutXAIRnHGaHfEdUiT7A6kIGR8VB
         3hxsumzh0hOJO2uOzb5Kf5O7TuaeHjmPiTjMisReEAEHaIb5TQzgYdsUZ05rGi1KmXYk
         nvOvAaw+8EeVsJq8dqk6STcfHJxHMJn9cAwO+rqpoTQe4fhw6pMIwMxLREhi74AbadqK
         GO5nNxLEUnaDjjnuSKthP4JbD0kjff9Fpuox0s56DCAGKppd1bJ7+lCMRw3hpOEQK3jb
         +7zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KIxsSmffb8RfNqJlYqJ6d8OJHZPkWprEKP9BjZRzvY4=;
        b=sQqS6KWTdhhFzPntIjnW+GkqH8ANaINxKWyBoJkNK46iNYExtB2NtwVPZchB/17Q9R
         Z93MFEFGkh83j5s9pNI18bVOp1wZ6po9qNx3ruMNnwxVAEVTfs35sV6xVfKG2aYIP8Qi
         2HX5+wk0GrrQVp2Skj02UHbihxLeJ6wpOhIlC9bsVCICLD/xlOsoNCFjBPP5O4yC5/tT
         emhhNt27xaU4JPEXrxiJpnO1NEoI2p8UES51KaRjnzJsBgorxzuVahptZk6+/xrh6WHo
         IEDVoXtfRZcF6uojR0gncKf93AnCNWMsXtsPMvfJhQMzUpy3sPyQu136i8Y2NaBGPmm3
         WFpw==
X-Gm-Message-State: AOAM533VzGJkYhSARxADkSJJB8S6DWM76kZV2AENWoGoy+8A4Eo9TuV5
        l99jtGebKfPcUf7bSdS59botTmL+xImYH7lm7pg=
X-Google-Smtp-Source: ABdhPJxGPAH3/4MNl4wJEhbi2aKPLJTgIIWnYOFq1wyqCO3Loa4a3ZXM4nLfZG8DtQD+7/hhnXIHdoiPxgckHoYpOaE=
X-Received: by 2002:a17:906:1193:b0:70d:cf39:a4db with SMTP id
 n19-20020a170906119300b0070dcf39a4dbmr38814493eja.44.1654943227473; Sat, 11
 Jun 2022 03:27:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220610175655.776153-1-colin.foster@in-advantage.com> <20220610175655.776153-2-colin.foster@in-advantage.com>
In-Reply-To: <20220610175655.776153-2-colin.foster@in-advantage.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Sat, 11 Jun 2022 12:26:31 +0200
Message-ID: <CAHp75VfHG7pqvTLcBu=vqx9PzXVrJhxyu6XHr9xaiMmhqke-Tg@mail.gmail.com>
Subject: Re: [PATCH v9 net-next 1/7] mfd: ocelot: add helper to get regmap
 from a resource
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
> Several ocelot-related modules are designed for MMIO / regmaps. As such,
> they often use a combination of devm_platform_get_and_ioremap_resource and
> devm_regmap_init_mmio.
>
> Operating in an MFD might be different, in that it could be memory mapped,
> or it could be SPI, I2C... In these cases a fallback to use IORESOURCE_REG
> instead of IORESOURCE_MEM becomes necessary.
>
> When this happens, there's redundant logic that needs to be implemented in
> every driver. In order to avoid this redundancy, utilize a single function
> that, if the MFD scenario is enabled, will perform this fallback logic.

...

> +#include <linux/err.h>
> +#include <linux/platform_device.h>
> +#include <linux/regmap.h>

Since it's header the rule of thumb is to include headers this one is
a direct user of. Here I see missed
types.h

Also missed forward declarations

struct resource;

...

> +       if (!IS_ERR(regs))

Why not positive conditional?

> +               *map = devm_regmap_init_mmio(&pdev->dev, regs, config);
> +       else
> +               *map = ERR_PTR(ENODEV);

Missed -.

-- 
With Best Regards,
Andy Shevchenko
