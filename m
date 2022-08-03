Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C33F588B4A
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 13:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236468AbiHCLcQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 07:32:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236312AbiHCLcP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 07:32:15 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 034B833E1F;
        Wed,  3 Aug 2022 04:32:14 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id gb36so5352757ejc.10;
        Wed, 03 Aug 2022 04:32:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=ffgpxlJKI4KloBx4T0gCdNQddFQjpgif6BFX6azbkS4=;
        b=X+Ec2mVmfXxkLlVWHzSL4F2cf5p74isrOXQZzhTrwQhnAFI+u5Ok/4I1guInVFdFVV
         Pons1SmeZoPEGSyJtgqcSoXYvzVtZj1YpPa1LTcTH3x17gJfUoae1TmPq4n6nkX8tdWW
         KpZhifswDDNRkhsxz22h5VsUdT2ryRC2wOyOd8GiWbSVEcDI0lGBSVC6rx5Py/nye0DP
         PvlcwoCbXF0RzkLHW3Furxt9y+fdl0JscnJEwU7oAIuxboCQyWK4Q/qIesjtbUF7npSZ
         b7bI4GgD6O79lALs9SdlDCrbHNC46vw4VascZJ26jynnBEZ1NQqEe70LiYcl1nNb/aA+
         EeMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=ffgpxlJKI4KloBx4T0gCdNQddFQjpgif6BFX6azbkS4=;
        b=6DrUQ7TLOS0GapLEnVJXyCSgSZXHsyAoIxL63sO/jN6N8DMsb0I0iSdAGscg8rASZa
         2k3F8Of1lIAUuezKzWbD3JvUzwwPLRJYJaH8qHItQat6OC8MPW0CG3zeaG9ldCEUTf7X
         XCSU1QRZcQ1O+Oe+F0Q4OY3dXM00HNZx7jAFpMynhQp0+qg2hnI5VXpotEespaCjojQU
         6f92baOqi7F4v5U+LMlgAJ+1fEU6eLab2f4+h27vMNXRHemCrP2tbgVl1RDSfymDhaIq
         cSj+EsRjkFJJtf79LektONxM/Ne3rR1B+so9Ir/zpRj9luS4aQyvz8EXKo4xADZY1h8A
         0Pew==
X-Gm-Message-State: AJIora9S8HyYQDoB74h/uxix/Px9DB5pcdj2sDZBagJs8Swn+cQIidON
        q2U/czcdbBIo5ICgDbYIEiELsEs3MTvoad31Mo0=
X-Google-Smtp-Source: AGRyM1tqx4F1flQ1tWao3I+F8VQZ4n4wNfAbuNdpmxr3yAznNCZFOQfB18b2xlx8H52sSog2V2j/5+R09yFNopgS0P0=
X-Received: by 2002:a17:906:7950:b0:72f:d4a4:564d with SMTP id
 l16-20020a170906795000b0072fd4a4564dmr19722433ejo.479.1659526332466; Wed, 03
 Aug 2022 04:32:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220803054728.1541104-1-colin.foster@in-advantage.com> <20220803054728.1541104-3-colin.foster@in-advantage.com>
In-Reply-To: <20220803054728.1541104-3-colin.foster@in-advantage.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Wed, 3 Aug 2022 13:31:35 +0200
Message-ID: <CAHp75Ve0i4T9vu0Y4BpOX=MWMyV=jognMgwow_Tk4inW=ZyvLQ@mail.gmail.com>
Subject: Re: [PATCH v15 mfd 2/9] net: mdio: mscc-miim: add ability to be used
 in a non-mmio configuration
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
> There are a few Ocelot chips that contain the logic for this bus, but are
> controlled externally. Specifically the VSC7511, 7512, 7513, and 7514. In
> the externally controlled configurations these registers are not
> memory-mapped.
>
> Add support for these non-memory-mapped configurations.

FWIW,
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>

> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Acked-by: Jakub Kicinski <kuba@kernel.org>
> ---
>
> (No changes since v14)
>
> v14
>     * Add Reviewed and Acked tags
>
> ---
>  drivers/net/mdio/mdio-mscc-miim.c | 42 +++++++++----------------------
>  1 file changed, 12 insertions(+), 30 deletions(-)
>
> diff --git a/drivers/net/mdio/mdio-mscc-miim.c b/drivers/net/mdio/mdio-mscc-miim.c
> index 08541007b18a..51f68daac152 100644
> --- a/drivers/net/mdio/mdio-mscc-miim.c
> +++ b/drivers/net/mdio/mdio-mscc-miim.c
> @@ -12,6 +12,7 @@
>  #include <linux/iopoll.h>
>  #include <linux/kernel.h>
>  #include <linux/mdio/mdio-mscc-miim.h>
> +#include <linux/mfd/ocelot.h>
>  #include <linux/module.h>
>  #include <linux/of_mdio.h>
>  #include <linux/phy.h>
> @@ -270,44 +271,25 @@ static int mscc_miim_clk_set(struct mii_bus *bus)
>
>  static int mscc_miim_probe(struct platform_device *pdev)
>  {
> -       struct regmap *mii_regmap, *phy_regmap = NULL;
>         struct device_node *np = pdev->dev.of_node;
> +       struct regmap *mii_regmap, *phy_regmap;
>         struct device *dev = &pdev->dev;
> -       void __iomem *regs, *phy_regs;
>         struct mscc_miim_dev *miim;
> -       struct resource *res;
>         struct mii_bus *bus;
>         int ret;
>
> -       regs = devm_platform_get_and_ioremap_resource(pdev, 0, NULL);
> -       if (IS_ERR(regs)) {
> -               dev_err(dev, "Unable to map MIIM registers\n");
> -               return PTR_ERR(regs);
> -       }
> -
> -       mii_regmap = devm_regmap_init_mmio(dev, regs, &mscc_miim_regmap_config);
> -
> -       if (IS_ERR(mii_regmap)) {
> -               dev_err(dev, "Unable to create MIIM regmap\n");
> -               return PTR_ERR(mii_regmap);
> -       }
> +       mii_regmap = ocelot_regmap_from_resource(pdev, 0,
> +                                                &mscc_miim_regmap_config);
> +       if (IS_ERR(mii_regmap))
> +               return dev_err_probe(dev, PTR_ERR(mii_regmap),
> +                                    "Unable to create MIIM regmap\n");
>
>         /* This resource is optional */
> -       res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> -       if (res) {
> -               phy_regs = devm_ioremap_resource(dev, res);
> -               if (IS_ERR(phy_regs)) {
> -                       dev_err(dev, "Unable to map internal phy registers\n");
> -                       return PTR_ERR(phy_regs);
> -               }
> -
> -               phy_regmap = devm_regmap_init_mmio(dev, phy_regs,
> -                                                  &mscc_miim_phy_regmap_config);
> -               if (IS_ERR(phy_regmap)) {
> -                       dev_err(dev, "Unable to create phy register regmap\n");
> -                       return PTR_ERR(phy_regmap);
> -               }
> -       }
> +       phy_regmap = ocelot_regmap_from_resource_optional(pdev, 1,
> +                                                &mscc_miim_phy_regmap_config);
> +       if (IS_ERR(phy_regmap))
> +               return dev_err_probe(dev, PTR_ERR(phy_regmap),
> +                                    "Unable to create phy register regmap\n");
>
>         ret = mscc_miim_setup(dev, &bus, "mscc_miim", mii_regmap, 0);
>         if (ret < 0) {
> --
> 2.25.1
>


-- 
With Best Regards,
Andy Shevchenko
