Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C83FD6A9C53
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 17:52:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231410AbjCCQwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 11:52:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231417AbjCCQvq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 11:51:46 -0500
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23B0A5C13B
        for <netdev@vger.kernel.org>; Fri,  3 Mar 2023 08:51:20 -0800 (PST)
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 321FD41AEB
        for <netdev@vger.kernel.org>; Fri,  3 Mar 2023 16:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1677862276;
        bh=8104o3BXBuCMBg1EpGwp3Vv0rGGYeWcwxreEU+Uex7M=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=n+fPjrL3WkTrJYCNQc8fq38QIM/Wijq9b4aQR7osKIB1DBeSrosYHCYqs5WCSuHaL
         IqYS5TQV3xrFqcBdRIz/zco/AfELkuEBLynvcMuoB+3edbiro07Mp67BGVqI7M8Ceh
         Dvpb2k/jBtfM79y6G8rUCqsXp+LzxW/QcZjVuwbUqfZq0dFrScfpmbtpzH6UcdmurX
         9ucp+YFChrfLaHnxMsSa1LDLXFGOSRF5EFKv/ftu4F2F4X48BawnDyyTidEb05Sn36
         NlbB5RE31XYs0UtHVvQaIH/3pn0lrsEbcANOTc2ljl1RDn/tpmHjfDwERvVSGwE78w
         ci/6wYJyftK1A==
Received: by mail-qt1-f198.google.com with SMTP id w16-20020ac843d0000000b003bfe50a4105so1794165qtn.10
        for <netdev@vger.kernel.org>; Fri, 03 Mar 2023 08:51:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677862271;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8104o3BXBuCMBg1EpGwp3Vv0rGGYeWcwxreEU+Uex7M=;
        b=c/0y7bPas+xuC0wHkT10vr7JuGNTA3k5vrqRP+UUqPUSdSZola3OZz3CFH9eUfkAh4
         quH376HYNhM5mt1kiPWBswwI84+FEcCM3srP7r42i9k2LsHITVPxew/UnAHAUFB5Qv9H
         I1Riv/4dSEhSkYsO/j/Xymlw4Ss1WBzKkcEVCqtZv4ckG/8ZrJ0Dbd4Y8xIhzFRPE2y2
         Z+ygwLqoB/m1yKYo/82OtNEmTDNPMOlN63RKSHPZQpSMdWnPNVWDZZc6+VjkNahGATbl
         ok4sy87ClW0qwr1AzArGKJ4DE0Bn4+vwNWsXfT9vl+Xz5UUwssnDsW5qxf+BcWyIpiWo
         cfDg==
X-Gm-Message-State: AO0yUKVgwTEZv6ErIzsQbhnZBk4pnuYY7Wgp/+SpbXsQm5D5rjszVdjn
        9LyoLHjZQe/2sW+jlGjQns8ew6Eo9KXZPLOJWTGeYYg8hKsmYy9PGOMxC1foMyG1Za0XzM4geeV
        /I5sYXZXMNjS2IOdqmTHTXrSiVYU9WaUuDDA0tGR7EcjR6/+W4Q==
X-Received: by 2002:a05:6214:4a45:b0:56e:fbea:9e9a with SMTP id ph5-20020a0562144a4500b0056efbea9e9amr582091qvb.0.1677862271322;
        Fri, 03 Mar 2023 08:51:11 -0800 (PST)
X-Google-Smtp-Source: AK7set+UvCTIlmmgq2C8w/UG8U3QGIr2FvnAWY6e1IjhHGbnhoyZXgaQhdRhu7VVj9s+dyGlIuis3/tJJMBa0vv1UZ0=
X-Received: by 2002:a05:6214:4a45:b0:56e:fbea:9e9a with SMTP id
 ph5-20020a0562144a4500b0056efbea9e9amr582078qvb.0.1677862271002; Fri, 03 Mar
 2023 08:51:11 -0800 (PST)
MIME-Version: 1.0
References: <20230303085928.4535-1-samin.guo@starfivetech.com> <20230303085928.4535-9-samin.guo@starfivetech.com>
In-Reply-To: <20230303085928.4535-9-samin.guo@starfivetech.com>
From:   Emil Renner Berthing <emil.renner.berthing@canonical.com>
Date:   Fri, 3 Mar 2023 17:50:54 +0100
Message-ID: <CAJM55Z-3CCY8xx81Qr9UqSSQ+gOer3XXJzOvnAe7yyESk23pQw@mail.gmail.com>
Subject: Re: [PATCH v5 08/12] net: stmmac: starfive_dmac: Add phy interface settings
To:     Samin Guo <samin.guo@starfivetech.com>
Cc:     linux-riscv@lists.infradead.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>,
        Yanhong Wang <yanhong.wang@starfivetech.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 3 Mar 2023 at 10:01, Samin Guo <samin.guo@starfivetech.com> wrote:
>
> dwmac supports multiple modess. When working under rmii and rgmii,
> you need to set different phy interfaces.
>
> According to the dwmac document, when working in rmii, it needs to be
> set to 0x4, and rgmii needs to be set to 0x1.
>
> The phy interface needs to be set in syscon, the format is as follows:
> starfive,syscon: <&syscon, offset, mask>
>
> Signed-off-by: Samin Guo <samin.guo@starfivetech.com>
> ---
>  .../ethernet/stmicro/stmmac/dwmac-starfive.c  | 46 +++++++++++++++++++
>  1 file changed, 46 insertions(+)
>
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-starfive.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-starfive.c
> index 566378306f67..40fdd7036127 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-starfive.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-starfive.c
> @@ -7,10 +7,15 @@
>   *
>   */
>
> +#include <linux/mfd/syscon.h>
>  #include <linux/of_device.h>
> +#include <linux/regmap.h>
>
>  #include "stmmac_platform.h"
>
> +#define MACPHYC_PHY_INFT_RMII  0x4
> +#define MACPHYC_PHY_INFT_RGMII 0x1

Please prefix these with something like STARFIVE_DWMAC_

>  struct starfive_dwmac {
>         struct device *dev;
>         struct clk *clk_tx;
> @@ -53,6 +58,46 @@ static void starfive_eth_fix_mac_speed(void *priv, unsigned int speed)
>                 dev_err(dwmac->dev, "failed to set tx rate %lu\n", rate);
>  }
>
> +static int starfive_dwmac_set_mode(struct plat_stmmacenet_data *plat_dat)
> +{
> +       struct starfive_dwmac *dwmac = plat_dat->bsp_priv;
> +       struct of_phandle_args args;
> +       struct regmap *regmap;
> +       unsigned int reg, mask, mode;
> +       int err;
> +
> +       switch (plat_dat->interface) {
> +       case PHY_INTERFACE_MODE_RMII:
> +               mode = MACPHYC_PHY_INFT_RMII;
> +               break;
> +
> +       case PHY_INTERFACE_MODE_RGMII:
> +       case PHY_INTERFACE_MODE_RGMII_ID:
> +               mode = MACPHYC_PHY_INFT_RGMII;
> +               break;
> +
> +       default:
> +               dev_err(dwmac->dev, "Unsupported interface %d\n",
> +                       plat_dat->interface);
> +       }
> +
> +       err = of_parse_phandle_with_fixed_args(dwmac->dev->of_node,
> +                                              "starfive,syscon", 2, 0, &args);
> +       if (err) {
> +               dev_dbg(dwmac->dev, "syscon reg not found\n");
> +               return -EINVAL;
> +       }
> +
> +       reg = args.args[0];
> +       mask = args.args[1];
> +       regmap = syscon_node_to_regmap(args.np);
> +       of_node_put(args.np);

I think the above is basically
unsigned int args[2];
syscon_regmap_lookup_by_phandle_args(dwmac->dev_of_node,
"starfive,syscon", 2, args);

..but as Andrew points out another solution is to use platform match
data for this. Eg.

static const struct starfive_dwmac_match_data starfive_dwmac_jh7110_data {
  .phy_interface_offset = 0xc,
  .phy_interface_mask = 0x1c0000,
};

static const struct of_device_id starfive_dwmac_match[] = {
  { .compatible = "starfive,jh7110-dwmac", .data =
&starfive_dwmac_jh7110_data },
  { /* sentinel */ }
};

and in the probe function:

struct starfive_dwmac_match_data *pdata = device_get_match_data(&pdev->dev);

> +       if (IS_ERR(regmap))
> +               return PTR_ERR(regmap);
> +
> +       return regmap_update_bits(regmap, reg, mask, mode << __ffs(mask));
> +}
> +
>  static int starfive_dwmac_probe(struct platform_device *pdev)
>  {
>         struct plat_stmmacenet_data *plat_dat;
> @@ -93,6 +138,7 @@ static int starfive_dwmac_probe(struct platform_device *pdev)
>         plat_dat->bsp_priv = dwmac;
>         plat_dat->dma_cfg->dche = true;
>
> +       starfive_dwmac_set_mode(plat_dat);

The function returns errors in an int, but you never check it :(

>         err = stmmac_dvr_probe(&pdev->dev, plat_dat, &stmmac_res);
>         if (err) {
>                 stmmac_remove_config_dt(pdev, plat_dat);
> --
> 2.17.1
>
>
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv
