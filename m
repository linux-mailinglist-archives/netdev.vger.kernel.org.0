Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 564F7588B59
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 13:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237665AbiHCLdg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 07:33:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237600AbiHCLd1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 07:33:27 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 298B23DF04;
        Wed,  3 Aug 2022 04:33:26 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id a89so21080726edf.5;
        Wed, 03 Aug 2022 04:33:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=onxOdMmI5QbIGUE/oDxEeplm+cELkOPvfMCEuj17XyE=;
        b=e80QPsaOkwgNFQn0rtSDmXyeEbAurKgI3paSkgTLa6gTyVHa4LZNNjhtUPrF+TiYjA
         94enMiVEPbAjGBow0aSG8cUAW3ZEHaOR45ycZ+1tq/oSxijXyyqCBYgpEPAUdCA40UfB
         xf9hnsyrmSN9yHji5necoonhG3fAqvDoqGH+sC+mk0P8cYe1PgVmkPsergu6ydQuLYtb
         v5cr6vxyrSMjl6EK8rEExDJKgIxHanmvRoVqIYOOFDjnkDofyNCnsKKLPzAogpDGQAO6
         z9YOfBvvyQA1AHXt3uI0kbnHPeMmo0Jo8SphvPbwBYPnrPvSoJ24cXXt4yQXwFhAiOgA
         U4cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=onxOdMmI5QbIGUE/oDxEeplm+cELkOPvfMCEuj17XyE=;
        b=soC+EZo8Y6gpLUDiDMFXHnHsKH3uHZm8mZLsZJ54hgq+xxDfh+EeyEFADNpyu7EhhF
         JBKCNygUOxXJ2k3u19TANThldau20MNQ663ixH3UQjyUrS+5hZOKZpsLZQRBO6xxI4bx
         JxRKKejMQ6azXo0Td1icxhVRfQTmqTiLoq5I9UDuk5EsdL7+p8jsHYIEuPjxfyyWOoGY
         G8vduC49mjursHEllNXxeL9Lealt1wKpfIzPTEMPkj9kPve2l67gLcTDjwOXywimIcUv
         s24diN3HB/fzoAVn283RcPEQysv8IEvhWgpQRoYXs6jhAvr3hKYJmmjltb/h9chNoG3/
         HEsQ==
X-Gm-Message-State: AJIora+KjzT/XZZ7X+HE/0CVKNnb6f9SgXTd3OMKmbIopZstjPOoo3uL
        SWWs/Za+XzMuqQN6j+vd/JAPi/fum5OXdGHXB84=
X-Google-Smtp-Source: AGRyM1sZau8R/yEHs7vvjpvJRBOiosnrmc4ppHCWFWWLbaYymgynSbBdHmb/Xq1Symzxt7lQqbvYMyAwH06xyklevEU=
X-Received: by 2002:a05:6402:280b:b0:43b:5d75:fcfa with SMTP id
 h11-20020a056402280b00b0043b5d75fcfamr24685276ede.114.1659526404638; Wed, 03
 Aug 2022 04:33:24 -0700 (PDT)
MIME-Version: 1.0
References: <20220803054728.1541104-1-colin.foster@in-advantage.com> <20220803054728.1541104-7-colin.foster@in-advantage.com>
In-Reply-To: <20220803054728.1541104-7-colin.foster@in-advantage.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Wed, 3 Aug 2022 13:32:47 +0200
Message-ID: <CAHp75VdWRQmp=dNON2jWoT8yqjB1bc-bd0-W5tswY7ucDA6bvw@mail.gmail.com>
Subject: Re: [PATCH v15 mfd 6/9] pinctrl: microchip-sgpio: add ability to be
 used in a non-mmio configuration
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
> There are a few Ocelot chips that can contain SGPIO logic, but can be
> controlled externally. Specifically the VSC7511, 7512, 7513, and 7514. In
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
>  drivers/pinctrl/pinctrl-microchip-sgpio.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/pinctrl/pinctrl-microchip-sgpio.c b/drivers/pinctrl/pinctrl-microchip-sgpio.c
> index e56074b7e659..2b4167a09b3b 100644
> --- a/drivers/pinctrl/pinctrl-microchip-sgpio.c
> +++ b/drivers/pinctrl/pinctrl-microchip-sgpio.c
> @@ -12,6 +12,7 @@
>  #include <linux/clk.h>
>  #include <linux/gpio/driver.h>
>  #include <linux/io.h>
> +#include <linux/mfd/ocelot.h>
>  #include <linux/mod_devicetable.h>
>  #include <linux/module.h>
>  #include <linux/pinctrl/pinmux.h>
> @@ -904,7 +905,6 @@ static int microchip_sgpio_probe(struct platform_device *pdev)
>         struct reset_control *reset;
>         struct sgpio_priv *priv;
>         struct clk *clk;
> -       u32 __iomem *regs;
>         u32 val;
>         struct regmap_config regmap_config = {
>                 .reg_bits = 32,
> @@ -937,11 +937,7 @@ static int microchip_sgpio_probe(struct platform_device *pdev)
>                 return -EINVAL;
>         }
>
> -       regs = devm_platform_ioremap_resource(pdev, 0);
> -       if (IS_ERR(regs))
> -               return PTR_ERR(regs);
> -
> -       priv->regs = devm_regmap_init_mmio(dev, regs, &regmap_config);
> +       priv->regs = ocelot_regmap_from_resource(pdev, 0, &regmap_config);
>         if (IS_ERR(priv->regs))
>                 return PTR_ERR(priv->regs);
>
> --
> 2.25.1
>


-- 
With Best Regards,
Andy Shevchenko
