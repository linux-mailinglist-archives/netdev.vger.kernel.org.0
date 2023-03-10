Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1366B327E
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 01:02:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231356AbjCJAC0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 19:02:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230256AbjCJACY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 19:02:24 -0500
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 014191116A4
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 16:02:20 -0800 (PST)
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com [209.85.219.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 6BE4A41B6C
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 00:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1678406539;
        bh=BoSkneUy12T8t+j3LhsvuTkbzqLXyS0o4aZ72Mu8r5A=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=SairPqm+dG5DflxecNB57vQ9HD7udPdi26TCCt9oGaWSE6snFFjszhLBgjfOGdljL
         wSTbFITTVn8QBkoZ1P4l8+w5egl2Z41Qj2YKmLAVMQbxE0pymsRF1BxP+N+1dn1MnG
         zm0tCDWBrEjjTbEndz1p9xDe/x1jfQDLhKl8eagOgOyaRdos7Adpj+iHpiCag5kOJc
         TKfaOmTJ4FI8daUCUzwFwuFFsejzWYA9GUAaKgRLqoiCSs6TClWzn2b37aM/oUD3QR
         IYsLl+u8jWVxJXj8G7ZqwPQXU9/DopxKuCW6TeoTWhcAc1my88Tpv5vgSEIRm7H5pD
         SNoYB5wEJzB6A==
Received: by mail-qv1-f71.google.com with SMTP id pm17-20020ad446d1000000b0057256b237b9so2111840qvb.16
        for <netdev@vger.kernel.org>; Thu, 09 Mar 2023 16:02:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678406538;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BoSkneUy12T8t+j3LhsvuTkbzqLXyS0o4aZ72Mu8r5A=;
        b=vWUQcklq4Kq+xMHmDkaKzOwqyvFS5j79wnPiOXlAfKAtMU9uGAoU9f8oRgqfCWsxOI
         rB7ep/vyjrsvrcZVvWd3SwmriE9ILpXl+Jf+VEJJpHOaIMbtaL4SgabUq1u7VVdR+H3r
         vBeNqoOeRoSezE/ySMgcVK0BEv3h0PDYq4yXMV7AYhb+wYDIuU9SDwsoW6UkcsBTrTlI
         jprEUc+AgPmiPSUk1URekxl43i88e4WWfk8C9HZBY5hFmA6lyykpFS8QzUVxrO6ldenB
         ULKPIVRmMDEs8zOXHWkxkMZVEGP+BpmENbP8kb5Pg12aWcqxV8xPEGoFwtkMyZSO7lZD
         /5hA==
X-Gm-Message-State: AO0yUKVoBO/4DuvNRYoJkV9+nQ1zqCIgDgnYXL6M5oPkY83n+6bjPIad
        FOWyqmAwl7SC7Jat1Pi1Z/d/K/yLBC4Lp+18vhNMOiThO5KDi8OFYdwIfnav6DGRNjsYb6JQUiJ
        IqQt5bY7GShqOaJ1pgj2M81n0RGrtHaf6Ib81wGr23atLPbg5hg==
X-Received: by 2002:ac8:429a:0:b0:3bf:bba8:69b0 with SMTP id o26-20020ac8429a000000b003bfbba869b0mr6312071qtl.5.1678406538081;
        Thu, 09 Mar 2023 16:02:18 -0800 (PST)
X-Google-Smtp-Source: AK7set8fRvxdpfPVM2OPFg9A6xTfRqxPsgiTT/xuGVJfVz9pB5Ua2+ICgn69kaCOjlMNrWxSkchQ8EYhFTim0wfP3xE=
X-Received: by 2002:ac8:429a:0:b0:3bf:bba8:69b0 with SMTP id
 o26-20020ac8429a000000b003bfbba869b0mr6312054qtl.5.1678406537745; Thu, 09 Mar
 2023 16:02:17 -0800 (PST)
MIME-Version: 1.0
References: <20230303085928.4535-1-samin.guo@starfivetech.com> <20230303085928.4535-7-samin.guo@starfivetech.com>
In-Reply-To: <20230303085928.4535-7-samin.guo@starfivetech.com>
From:   Emil Renner Berthing <emil.renner.berthing@canonical.com>
Date:   Fri, 10 Mar 2023 01:02:01 +0100
Message-ID: <CAJM55Z_YUXbny3NR7xLRu1ekzkgOsx2wgBWmCoQ5peMkN+fV_Q@mail.gmail.com>
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
>
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
> +       depends on STMMAC_ETH
> +       default ARCH_STARFIVE
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
> + *
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
> +       bool tx_use_rgmii_rxin_clk;
> +};
> +
> +static void starfive_eth_fix_mac_speed(void *priv, unsigned int speed)
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
> +
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

Hi Samin,

I tried exercising this code by forcing the interface to downgrade
from 1000Mbps to 100Mbps (ethtool -s end0 speed 100), and it doesn't
seem to work. The reason is that clk_tx is a mux, and when you call
clk_set_rate it will try to find the parent with the closest clock
rate instead of adjusting the current parent as is needed here.
However that is easily fixed by calling clk_set_rate on clk_gtx which
is just a gate that *will* propagate the rate change to the parent.

With this change, this piece of code and downgrading from 1000Mbps to
100Mbps works on the JH7100. However on the JH7110 there is a second
problem. The parent of clk_gtx, confusingly called
clk_gmac{0,1}_gtxclk is a divider (and gate) that takes the 1GHz PLL0
clock and divides it by some integer. But according to [1] it can at
most divide by 15 which is not enough to generate the 25MHz clock
needed for 100Mbps. So now I wonder how this is supposed to work on
the JH7110.

[1]: https://doc-en.rvspace.org/JH7110/TRM/JH7110_TRM/sys_crg.html#sys_crg__section_skz_fxm_wsb

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
