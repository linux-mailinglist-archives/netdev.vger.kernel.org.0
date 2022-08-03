Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B94B3588B51
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 13:33:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237518AbiHCLdA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 07:33:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237482AbiHCLcz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 07:32:55 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 420753D595;
        Wed,  3 Aug 2022 04:32:54 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id dc19so8202908ejb.12;
        Wed, 03 Aug 2022 04:32:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=9eJR3E7r7PDYrwPyZgyOXsCTuvoCZ7sVt4yoqxYJPX4=;
        b=o+b6PdvDZDHi+nrpABUNjbp4ZVQx6du6ZHu9GoXgPmUTTrA/+kwnw8G5mBplzCN0C7
         ZIetmXEoNJfVr2FN7EwJjlYcRN6NNSEVk9xNLVbxKyAvdd4I+qf6X3CGa/KI1U0gzKpn
         ujQW5ZuCvqVsOz+IgiQdiIwg74oVc/j9WVb1L1B+Of/Mv+ZkthKmcULTU4gCmr3MfMKh
         nGFhdpSVwWZ57YnHrXpQSuoEZGoJ50GC2wKXtRhkMXYj3CTaWLN9n6DU5IuaBXfY1GCt
         7PZu4AQS3JxFrqrgxJWDI4+dPT5uEQe5AYxlpcmNXzE7wKyeqTyp3SPdQrrkvy064Fai
         8Q3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=9eJR3E7r7PDYrwPyZgyOXsCTuvoCZ7sVt4yoqxYJPX4=;
        b=2yt/rSvUttWHi1zKC7Gj9KG+uFMRK1QCuRp56OXU9KA/a6t+Gtxi2R6YnPY7KXKYxf
         Tb1mpGQ5ss9Eminxg1TpcPP+6g0UHPPh5LtqFYggD5LDyHgPd4wousFF0D4nhh+Da5Ww
         IGr/G1l/ire2BoSdb8ynxmQyWFe+SmgUQI7FMVCBC/KVQvBEJhhPAh8rMB7eqvsAV9My
         jRNn+x10iMjBnPtVR0PlafdeQhSalAy3zF+KtAaeAiD+6F7Pi2ISAwa0g/XM/tSNmn7C
         ALyWjDqMR56K/r1lbAgascnqZ7IK80o98Ev7lNpL6l7UV5aTCTX0yhv72Gr6MozrIahq
         yoUA==
X-Gm-Message-State: AJIora+HenZEtkNCUGUUcfPi5SHjfi6adDxpei16UVWRggXdNnoY/Csj
        8K5JOtDhwk0+a1VtlcUGY2HSZyWMoTL70PqTpPI=
X-Google-Smtp-Source: AGRyM1uQNT2sLEmn+47hvcwdSagVjYBFsLCmTzLrhiz4Zx2S8Lc2gPvuaO7WU6VMLuHwWblWK12jxjfziNzhVGYgVwk=
X-Received: by 2002:a17:907:28d6:b0:72b:7497:76b with SMTP id
 en22-20020a17090728d600b0072b7497076bmr19322425ejc.365.1659526372574; Wed, 03
 Aug 2022 04:32:52 -0700 (PDT)
MIME-Version: 1.0
References: <20220803054728.1541104-1-colin.foster@in-advantage.com> <20220803054728.1541104-5-colin.foster@in-advantage.com>
In-Reply-To: <20220803054728.1541104-5-colin.foster@in-advantage.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Wed, 3 Aug 2022 13:32:15 +0200
Message-ID: <CAHp75Vf=yg8QWUwbKPNjJmvg44FH3JCyNFEQi4m-qHAuff5zVg@mail.gmail.com>
Subject: Re: [PATCH v15 mfd 4/9] pinctrl: ocelot: add ability to be used in a
 non-mmio configuration
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Wolfram Sang <wsa@kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Lee Jones <lee.jones@linaro.org>, katie.morris@in-advantage.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 3, 2022 at 7:47 AM Colin Foster
<colin.foster@in-advantage.com> wrote:
>
> There are a few Ocelot chips that contain pinctrl logic, but can be
> controlled externally. Specifically the VSC7511, 7512, 7513 and 7514. In
> the externally controlled configurations these registers are not
> memory-mapped.
>
> Add support for these non-memory-mapped configurations.

FWIW,
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>

> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>
> (No changes since v14)
>
> v14
>     * Add Reviewed and Acked tags
>
> ---
>  drivers/pinctrl/pinctrl-ocelot.c | 16 +++++-----------
>  1 file changed, 5 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/pinctrl/pinctrl-ocelot.c b/drivers/pinctrl/pinctrl-ocelot.c
> index d18047d2306d..80a3bba520cb 100644
> --- a/drivers/pinctrl/pinctrl-ocelot.c
> +++ b/drivers/pinctrl/pinctrl-ocelot.c
> @@ -10,6 +10,7 @@
>  #include <linux/gpio/driver.h>
>  #include <linux/interrupt.h>
>  #include <linux/io.h>
> +#include <linux/mfd/ocelot.h>
>  #include <linux/of_device.h>
>  #include <linux/of_irq.h>
>  #include <linux/of_platform.h>
> @@ -1918,7 +1919,6 @@ static int ocelot_pinctrl_probe(struct platform_device *pdev)
>         struct ocelot_pinctrl *info;
>         struct reset_control *reset;
>         struct regmap *pincfg;
> -       void __iomem *base;
>         int ret;
>         struct regmap_config regmap_config = {
>                 .reg_bits = 32,
> @@ -1938,20 +1938,14 @@ static int ocelot_pinctrl_probe(struct platform_device *pdev)
>                                      "Failed to get reset\n");
>         reset_control_reset(reset);
>
> -       base = devm_ioremap_resource(dev,
> -                       platform_get_resource(pdev, IORESOURCE_MEM, 0));
> -       if (IS_ERR(base))
> -               return PTR_ERR(base);
> -
>         info->stride = 1 + (info->desc->npins - 1) / 32;
>
>         regmap_config.max_register = OCELOT_GPIO_SD_MAP * info->stride + 15 * 4;
>
> -       info->map = devm_regmap_init_mmio(dev, base, &regmap_config);
> -       if (IS_ERR(info->map)) {
> -               dev_err(dev, "Failed to create regmap\n");
> -               return PTR_ERR(info->map);
> -       }
> +       info->map = ocelot_regmap_from_resource(pdev, 0, &regmap_config);
> +       if (IS_ERR(info->map))
> +               return dev_err_probe(dev, PTR_ERR(info->map),
> +                                    "Failed to create regmap\n");
>         dev_set_drvdata(dev, info->map);
>         info->dev = dev;
>
> --
> 2.25.1
>


-- 
With Best Regards,
Andy Shevchenko
