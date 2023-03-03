Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E77A26A9B7D
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 17:18:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231177AbjCCQSp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 11:18:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbjCCQSo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 11:18:44 -0500
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FA7811EB2
        for <netdev@vger.kernel.org>; Fri,  3 Mar 2023 08:18:40 -0800 (PST)
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com [209.85.219.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 2AB1441262
        for <netdev@vger.kernel.org>; Fri,  3 Mar 2023 16:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1677860318;
        bh=es+hc5n+zswZQczR3HU2bkHqd0ak5Sb5q5T47HqNNMA=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=UEgxnxtnDUOMI4/pfEoWqpwSkRUzqci1XC6LONUdATe53XZ9JGTzv3r1UV9V2htcX
         kbBkQe/w5jcL92snZOM40GchWkaL2fkUZMLQCXnwDFkcFkMnzbWsElC7agfqOc5TMH
         yuADw7AbuyEfSPav/FcZOzO60lApOAlVRFNJ2gLUZval5dXiSBUZDaHFmsJ0wZtFdg
         6Z1nBP5pY+Jda4SzobVbUs6i3HqrSF/TlNhHm2X9G9VD3KGR2vlBK74ym+a8GOY5kl
         dOtOvAW2S5EO2wq+Q6Ga435UEsUMYNBUlU1dEFrMAV76VLRCpUntDmuKlwffa19eC5
         gw0OwWbaRLTgw==
Received: by mail-qv1-f71.google.com with SMTP id jo13-20020a056214500d00b004c6c72bf1d0so1651029qvb.9
        for <netdev@vger.kernel.org>; Fri, 03 Mar 2023 08:18:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677860317;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=es+hc5n+zswZQczR3HU2bkHqd0ak5Sb5q5T47HqNNMA=;
        b=RZFvRCIjpUFoGmRWk5ngqPQzL4esuikGQ7akzsqK6uqj1AQonFdJI+HboHbAdFqqob
         0Qzws9CAeYbKX6UffRtTtBTIRQTpeFhWKR69tGa8/pFWIUu9TJeKYit2kI0CxcAIXz8d
         OHSJoMyZcG1yuqj+7BM6BLeOM38WujLat3PnGG8mNma6aa24DElrY95YD2elZTgMtqN0
         xV6FxyCadbJPPTqeLzxoHA1+OButtIDgy13nnV5lkYD2hyPmVSFyy7OVak5gHrLxWhrq
         Z+MFHy4gOcykJM2KH0JETkKcJU8qei6FEoXTlFYy2VI6kol+jENm6oesOfIooK95wIox
         1OoQ==
X-Gm-Message-State: AO0yUKXtNvs9+greddVRMbCIJS6WN6Y8nuDazdzuakeY0fS/SzUV3073
        spzIEoPWqtSARTOWb5kmhWUANp6hWBic13pO8BFIOzvTb3DEXCYpl4WSbF/ypg/LEP8pN//oBPo
        UdxFQUNBJNslZnIZT9gw9Gkvel0yWNvtuuMp4ZjaMibfmzlVd3g==
X-Received: by 2002:a05:620a:ce4:b0:742:72c6:a140 with SMTP id c4-20020a05620a0ce400b0074272c6a140mr581865qkj.7.1677860316898;
        Fri, 03 Mar 2023 08:18:36 -0800 (PST)
X-Google-Smtp-Source: AK7set/WnUl/2mIGv5HbkcMpWHdTYsy4cXNm7MUkXOf6ZEkkp6tp8hc/4NZfaxm1CxmBQZqOWJ6Fo6tgsl4GWNE1UFQ=
X-Received: by 2002:a05:620a:ce4:b0:742:72c6:a140 with SMTP id
 c4-20020a05620a0ce400b0074272c6a140mr581852qkj.7.1677860316551; Fri, 03 Mar
 2023 08:18:36 -0800 (PST)
MIME-Version: 1.0
References: <20230303085928.4535-1-samin.guo@starfivetech.com> <20230303085928.4535-7-samin.guo@starfivetech.com>
In-Reply-To: <20230303085928.4535-7-samin.guo@starfivetech.com>
From:   Emil Renner Berthing <emil.renner.berthing@canonical.com>
Date:   Fri, 3 Mar 2023 17:18:20 +0100
Message-ID: <CAJM55Z_Ze3mD4UVtUFTRYN_n6WnobcFB5evgYZi9zBRNR2dU4w@mail.gmail.com>
Subject: Re: [PATCH v5 06/12] net: stmmac: Add glue layer for StarFive JH7110 SoC
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
> This adds StarFive dwmac driver support on the StarFive JH7110 SoC.
>
> Co-developed-by: Emil Renner Berthing <kernel@esmil.dk>
> Signed-off-by: Emil Renner Berthing <kernel@esmil.dk>
> Signed-off-by: Samin Guo <samin.guo@starfivetech.com>
> ---
>  MAINTAINERS                                   |   1 +
>  drivers/net/ethernet/stmicro/stmmac/Kconfig   |  12 ++
>  drivers/net/ethernet/stmicro/stmmac/Makefile  |   1 +
>  .../ethernet/stmicro/stmmac/dwmac-starfive.c  | 125 ++++++++++++++++++
>  4 files changed, 139 insertions(+)
>  create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac-starfive.c
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 4e236b7c7fd2..91a4f190c827 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -19916,6 +19916,7 @@ STARFIVE DWMAC GLUE LAYER
>  M:     Emil Renner Berthing <kernel@esmil.dk>
>  M:     Samin Guo <samin.guo@starfivetech.com>
>  S:     Maintained
> +F:     Documentation/devicetree/bindings/net/dwmac-starfive.c
>  F:     Documentation/devicetree/bindings/net/starfive,jh7110-dwmac.yaml
>
>  STARFIVE JH71X0 CLOCK DRIVERS
> diff --git a/drivers/net/ethernet/stmicro/stmmac/Kconfig b/drivers/net/ethernet/stmicro/stmmac/Kconfig
> index f77511fe4e87..47fbccef9d04 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/Kconfig
> +++ b/drivers/net/ethernet/stmicro/stmmac/Kconfig
> @@ -165,6 +165,18 @@ config DWMAC_SOCFPGA
>           for the stmmac device driver. This driver is used for
>           arria5 and cyclone5 FPGA SoCs.
>
> +config DWMAC_STARFIVE
> +       tristate "StarFive dwmac support"
> +       depends on OF  && (ARCH_STARFIVE || COMPILE_TEST)

There is an extra space between "OF" and "&&" here.


> +       depends on STMMAC_ETH

It's not visible in this patch context, but this whole config option
is surrounded by "if STMMAC_ETH" and "if STMMAC_PLATFORM", so "depends
on STMMAC_ETH" should not be needed.

> +       default ARCH_STARFIVE

This driver is not required to boot the JH7110, so we should just
default to building it as a module. Eg.
default m if ARCH_STARFIVE

> +       help
> +         Support for ethernet controllers on StarFive RISC-V SoCs
> +
> +         This selects the StarFive platform specific glue layer support for
> +         the stmmac device driver. This driver is used for StarFive JH7110
> +         ethernet controller.
> +
>  config DWMAC_STI
>         tristate "STi GMAC support"
>         default ARCH_STI
> diff --git a/drivers/net/ethernet/stmicro/stmmac/Makefile b/drivers/net/ethernet/stmicro/stmmac/Makefile
> index 057e4bab5c08..8738fdbb4b2d 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/Makefile
> +++ b/drivers/net/ethernet/stmicro/stmmac/Makefile
> @@ -23,6 +23,7 @@ obj-$(CONFIG_DWMAC_OXNAS)     += dwmac-oxnas.o
>  obj-$(CONFIG_DWMAC_QCOM_ETHQOS)        += dwmac-qcom-ethqos.o
>  obj-$(CONFIG_DWMAC_ROCKCHIP)   += dwmac-rk.o
>  obj-$(CONFIG_DWMAC_SOCFPGA)    += dwmac-altr-socfpga.o
> +obj-$(CONFIG_DWMAC_STARFIVE)   += dwmac-starfive.o
>  obj-$(CONFIG_DWMAC_STI)                += dwmac-sti.o
>  obj-$(CONFIG_DWMAC_STM32)      += dwmac-stm32.o
>  obj-$(CONFIG_DWMAC_SUNXI)      += dwmac-sunxi.o
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-starfive.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-starfive.c
> new file mode 100644
> index 000000000000..566378306f67
> --- /dev/null
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-starfive.c
> @@ -0,0 +1,125 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/*
> + * StarFive DWMAC platform driver
> + *
> + * Copyright (C) 2022 StarFive Technology Co., Ltd.
> + * Copyright (C) 2022 Emil Renner Berthing <kernel@esmil.dk>

Sorry, after looking at my old git branches where this started as a
driver for the JH7100 this should really be
* Copyright (C) 2021 Emil Renner Berthing <kernel@esmil.dk>
* Copyright (C) 2022 StarFive Technology Co., Ltd.

> + */
> +
> +#include <linux/of_device.h>
> +
> +#include "stmmac_platform.h"
> +
> +struct starfive_dwmac {
> +       struct device *dev;
> +       struct clk *clk_tx;
> +       struct clk *clk_gtx;

This pointer is only set, but never read. Please remove it.

> +       bool tx_use_rgmii_rxin_clk;
> +};
> +
> +static void starfive_eth_fix_mac_speed(void *priv, unsigned int speed)

This should be starfive_dwmac_fix_mac_speed for consistency.

> +{
> +       struct starfive_dwmac *dwmac = priv;
> +       unsigned long rate;
> +       int err;
> +
> +       /* Generally, the rgmii_tx clock is provided by the internal clock,
> +        * which needs to match the corresponding clock frequency according
> +        * to different speeds. If the rgmii_tx clock is provided by the
> +        * external rgmii_rxin, there is no need to configure the clock
> +        * internally, because rgmii_rxin will be adaptively adjusted.
> +        */
> +       if (dwmac->tx_use_rgmii_rxin_clk)
> +               return;

If this function is only needed in certain situations, why not just
set the plat_dat->fix_mac_speed callback when it is needed?

> +       switch (speed) {
> +       case SPEED_1000:
> +               rate = 125000000;
> +               break;
> +       case SPEED_100:
> +               rate = 25000000;
> +               break;
> +       case SPEED_10:
> +               rate = 2500000;
> +               break;
> +       default:
> +               dev_err(dwmac->dev, "invalid speed %u\n", speed);
> +               break;
> +       }
> +
> +       err = clk_set_rate(dwmac->clk_tx, rate);
> +       if (err)
> +               dev_err(dwmac->dev, "failed to set tx rate %lu\n", rate);
> +}
> +
> +static int starfive_dwmac_probe(struct platform_device *pdev)
> +{
> +       struct plat_stmmacenet_data *plat_dat;
> +       struct stmmac_resources stmmac_res;
> +       struct starfive_dwmac *dwmac;
> +       int err;
> +
> +       err = stmmac_get_platform_resources(pdev, &stmmac_res);
> +       if (err)
> +               return err;
> +
> +       plat_dat = stmmac_probe_config_dt(pdev, stmmac_res.mac);
> +       if (IS_ERR(plat_dat)) {
> +               dev_err(&pdev->dev, "dt configuration failed\n");
> +               return PTR_ERR(plat_dat);
> +       }
> +
> +       dwmac = devm_kzalloc(&pdev->dev, sizeof(*dwmac), GFP_KERNEL);
> +       if (!dwmac)
> +               return -ENOMEM;
> +
> +       dwmac->clk_tx = devm_clk_get_enabled(&pdev->dev, "tx");
> +       if (IS_ERR(dwmac->clk_tx))
> +               return dev_err_probe(&pdev->dev, PTR_ERR(dwmac->clk_tx),
> +                                   "error getting tx clock\n");
> +
> +       dwmac->clk_gtx = devm_clk_get_enabled(&pdev->dev, "gtx");
> +       if (IS_ERR(dwmac->clk_gtx))
> +               return dev_err_probe(&pdev->dev, PTR_ERR(dwmac->clk_gtx),
> +                                   "error getting gtx clock\n");
> +
> +       if (device_property_read_bool(&pdev->dev, "starfive,tx-use-rgmii-clk"))
> +               dwmac->tx_use_rgmii_rxin_clk = true;
> +
> +       dwmac->dev = &pdev->dev;
> +       plat_dat->fix_mac_speed = starfive_eth_fix_mac_speed;

Eg.:
if (!device_property_read_bool(&pdev->dev, "starfive,tx_use_rgmii_clk"))
  plat_dat->fix_mac_speed = starfive_dwmac_fix_mac_speed;

> +       plat_dat->init = NULL;
> +       plat_dat->bsp_priv = dwmac;
> +       plat_dat->dma_cfg->dche = true;
> +
> +       err = stmmac_dvr_probe(&pdev->dev, plat_dat, &stmmac_res);
> +       if (err) {
> +               stmmac_remove_config_dt(pdev, plat_dat);
> +               return err;
> +       }
> +
> +       return 0;
> +}
> +
> +static const struct of_device_id starfive_dwmac_match[] = {
> +       { .compatible = "starfive,jh7110-dwmac" },
> +       { /* sentinel */ }
> +};
> +MODULE_DEVICE_TABLE(of, starfive_dwmac_match);
> +
> +static struct platform_driver starfive_dwmac_driver = {
> +       .probe  = starfive_dwmac_probe,
> +       .remove = stmmac_pltfr_remove,
> +       .driver = {
> +               .name = "starfive-dwmac",
> +               .pm = &stmmac_pltfr_pm_ops,
> +               .of_match_table = starfive_dwmac_match,
> +       },
> +};
> +module_platform_driver(starfive_dwmac_driver);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("StarFive DWMAC platform driver");
> +MODULE_AUTHOR("Emil Renner Berthing <kernel@esmil.dk>");
> +MODULE_AUTHOR("Samin Guo <samin.guo@starfivetech.com>");
> --
> 2.17.1
>
>
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv
