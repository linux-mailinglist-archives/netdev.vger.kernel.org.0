Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96F4F69924D
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 11:54:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbjBPKyV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 05:54:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230264AbjBPKyT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 05:54:19 -0500
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BB46265B4
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 02:54:16 -0800 (PST)
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 78B403F57F
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 10:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1676544852;
        bh=gruy2zJzC/Dvg5LfaZvUjx5AlRrilw/uF54bkVyz1LI=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=my2FKxAceRajQCknYILlflW5Srkmz6+LXyCbs/Wpw2+EonQtwz/0k0HT28VlF6RQa
         SNBeeMsTw9Shj9aiKtyJZIAVa4AL2uSgObQUMTfpWjIcfwv910Rgpk3YzAhO5djPk3
         ie0QNLh1Fke5g3hFKqTK1Hn7clBSSWBDkW6V9FfXU99QDPo2SOKbWYEheIZUITE1je
         gRODiJ9GJ6bJ7cRuz+pICEY8Y4H/qkxrN+G1npup0nxB6/v9eTbnP1Ce24T7V+yIJc
         +f1qWIYL3hdJXcbJDvGRMn+tPEQ1QcwrI26UO8MIoOu7pf/UFTAog4iaLZAVBTGYDB
         N8MfE4WzZ5sJg==
Received: by mail-qt1-f197.google.com with SMTP id fp20-20020a05622a509400b003bcf4239f33so984658qtb.7
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 02:54:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gruy2zJzC/Dvg5LfaZvUjx5AlRrilw/uF54bkVyz1LI=;
        b=X0Kx1298dJwe2Zz4oMe9bI02ulu2w1NCjP1/04zhpBdnmRlnRfia45NpeXW7t5z60E
         dKsNlsc/0T9aFc7XUTSNKKwmjLOu+YYK3kGfDJJ0A/lv00hU/tHppsIjFiFqZOTKCstw
         KIzMWcQ8veIaXh15pgH7SWEI6pCtsQ2EssiFBrjLx5VkYnKY2978dTSZpZj/Ph/ydvul
         Q/WeTm/Cw5NwJl6RPP2UwT4qynvspblndAc7EGRJu5+XQ276HWXfYEFBIvWxXRjDJvlM
         0fjDua73ylmydeL/ZMqjSGux1VQioPSTD1R6P0alyQ5vx8+LeMN1mSRrjqxv970rB96D
         VSaQ==
X-Gm-Message-State: AO0yUKW97F/PoHv/fMCpWDGRkEIMf2NW37GfnDSraY/MAMORjkX8+9jn
        XsFwjtgeoOwsbxV0T7YO1UwLgSfSjtQCfM59WkNrlFk01Q6W0KjQS5Ja2swuHoLmEmdDYAVY8jP
        ic11ZOjFuzGQOiuRyRdCl4f8FbYYXgxWeAOnbq/xL1F2YURPk5A==
X-Received: by 2002:a37:4249:0:b0:73b:3411:48b1 with SMTP id p70-20020a374249000000b0073b341148b1mr258747qka.219.1676544849143;
        Thu, 16 Feb 2023 02:54:09 -0800 (PST)
X-Google-Smtp-Source: AK7set8RgkG6eMdqF8jxqjfdXJZdtj3ENMaszkBMb9ohdLgmVNvM9xdjiQ+QAglQRtGNY4Vekk3FndXf/3llRfs0a1k=
X-Received: by 2002:a37:4249:0:b0:73b:3411:48b1 with SMTP id
 p70-20020a374249000000b0073b341148b1mr258743qka.219.1676544848837; Thu, 16
 Feb 2023 02:54:08 -0800 (PST)
MIME-Version: 1.0
References: <20230118061701.30047-1-yanhong.wang@starfivetech.com> <20230118061701.30047-6-yanhong.wang@starfivetech.com>
In-Reply-To: <20230118061701.30047-6-yanhong.wang@starfivetech.com>
From:   Emil Renner Berthing <emil.renner.berthing@canonical.com>
Date:   Thu, 16 Feb 2023 11:53:51 +0100
Message-ID: <CAJM55Z-zvb5CJq4PU4c=YKvY0xPY216MAALFsmWTcVFjSd=wEA@mail.gmail.com>
Subject: Re: [PATCH v4 5/7] net: stmmac: Add glue layer for StarFive JH7110 SoCs
To:     Yanhong Wang <yanhong.wang@starfivetech.com>
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
        Peter Geis <pgwipeout@gmail.com>
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

On Wed, 18 Jan 2023 at 07:20, Yanhong Wang
<yanhong.wang@starfivetech.com> wrote:
>
> This adds StarFive dwmac driver support on the StarFive JH7110 SoCs.
>
> Signed-off-by: Yanhong Wang <yanhong.wang@starfivetech.com>
> Co-developed-by: Emil Renner Berthing <kernel@esmil.dk>
> Signed-off-by: Emil Renner Berthing <kernel@esmil.dk>
> ---
>  MAINTAINERS                                   |   1 +
>  drivers/net/ethernet/stmicro/stmmac/Kconfig   |  12 ++
>  drivers/net/ethernet/stmicro/stmmac/Makefile  |   1 +
>  .../stmicro/stmmac/dwmac-starfive-plat.c      | 118 ++++++++++++++++++
>  4 files changed, 132 insertions(+)
>  create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac-starfive-plat.c
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 56be59bb09f7..5b50b52d3dbb 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -19609,6 +19609,7 @@ F:      include/dt-bindings/clock/starfive*
>  STARFIVE DWMAC GLUE LAYER
>  M:     Yanhong Wang <yanhong.wang@starfivetech.com>
>  S:     Maintained
> +F:     Documentation/devicetree/bindings/net/dwmac-starfive-plat.c
>  F:     Documentation/devicetree/bindings/net/starfive,jh7110-dwmac.yaml
>
>  STARFIVE PINCTRL DRIVER
> diff --git a/drivers/net/ethernet/stmicro/stmmac/Kconfig b/drivers/net/ethernet/stmicro/stmmac/Kconfig
> index 31ff35174034..f9a4ad4abd54 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/Kconfig
> +++ b/drivers/net/ethernet/stmicro/stmmac/Kconfig
> @@ -235,6 +235,18 @@ config DWMAC_INTEL_PLAT
>           the stmmac device driver. This driver is used for the Intel Keem Bay
>           SoC.
>
> +config DWMAC_STARFIVE_PLAT
> +       tristate "StarFive dwmac support"
> +       depends on OF && COMMON_CLK
> +       depends on STMMAC_ETH
> +       default SOC_STARFIVE
> +       help
> +         Support for ethernet controllers on StarFive RISC-V SoCs
> +
> +         This selects the StarFive platform specific glue layer support for
> +         the stmmac device driver. This driver is used for StarFive JH7110
> +         ethernet controller.
> +
>  config DWMAC_VISCONTI
>         tristate "Toshiba Visconti DWMAC support"
>         default ARCH_VISCONTI
> diff --git a/drivers/net/ethernet/stmicro/stmmac/Makefile b/drivers/net/ethernet/stmicro/stmmac/Makefile
> index d4e12e9ace4f..a63ab0ab5071 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/Makefile
> +++ b/drivers/net/ethernet/stmicro/stmmac/Makefile
> @@ -31,6 +31,7 @@ obj-$(CONFIG_DWMAC_DWC_QOS_ETH)       += dwmac-dwc-qos-eth.o
>  obj-$(CONFIG_DWMAC_INTEL_PLAT) += dwmac-intel-plat.o
>  obj-$(CONFIG_DWMAC_GENERIC)    += dwmac-generic.o
>  obj-$(CONFIG_DWMAC_IMX8)       += dwmac-imx.o
> +obj-$(CONFIG_DWMAC_STARFIVE_PLAT)      += dwmac-starfive-plat.o

Hi Yanhong,

For the next version could you please drop the _PLAT from the config
symbol and -plat from filename. I know the intel wrapper does the
same, but it's the only one, so lets do like the majority of other
wrappers and not add more different ways of doing things.

>  obj-$(CONFIG_DWMAC_VISCONTI)   += dwmac-visconti.o
>  stmmac-platform-objs:= stmmac_platform.o
>  dwmac-altr-socfpga-objs := altr_tse_pcs.o dwmac-socfpga.o
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-starfive-plat.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-starfive-plat.c
> new file mode 100644
> index 000000000000..e441d920933a
> --- /dev/null
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-starfive-plat.c
> @@ -0,0 +1,118 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/*
> + * StarFive DWMAC platform driver
> + *
> + * Copyright(C) 2022 StarFive Technology Co., Ltd.
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
> +       struct clk *clk_gtxc;
> +};

I like this name. For the next version could you also
s/starfive_eth_plat_/starfive_dwmac_/ on the function/struct names
below for consistency.

> +
> +static void starfive_eth_plat_fix_mac_speed(void *priv, unsigned int speed)
> +{
> +       struct starfive_dwmac *dwmac = priv;
> +       unsigned long rate;
> +       int err;
> +
> +       rate = clk_get_rate(dwmac->clk_gtx);
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
> +       err = clk_set_rate(dwmac->clk_gtx, rate);
> +       if (err)
> +               dev_err(dwmac->dev, "failed to set tx rate %lu\n", rate);
> +}
> +
> +static int starfive_eth_plat_probe(struct platform_device *pdev)
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
> +                                               "error getting tx clock\n");
> +
> +       dwmac->clk_gtx = devm_clk_get_enabled(&pdev->dev, "gtx");
> +       if (IS_ERR(dwmac->clk_gtx))
> +               return dev_err_probe(&pdev->dev, PTR_ERR(dwmac->clk_gtx),
> +                                               "error getting gtx clock\n");
> +
> +       dwmac->clk_gtxc = devm_clk_get_enabled(&pdev->dev, "gtxc");
> +       if (IS_ERR(dwmac->clk_gtxc))
> +               return dev_err_probe(&pdev->dev, PTR_ERR(dwmac->clk_gtxc),
> +                                               "error getting gtxc clock\n");
> +
> +       dwmac->dev = &pdev->dev;
> +       plat_dat->fix_mac_speed = starfive_eth_plat_fix_mac_speed;
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
> +static const struct of_device_id starfive_eth_plat_match[] = {
> +       { .compatible = "starfive,jh7110-dwmac" },
> +       { }
> +};
> +
> +static struct platform_driver starfive_eth_plat_driver = {
> +       .probe  = starfive_eth_plat_probe,
> +       .remove = stmmac_pltfr_remove,
> +       .driver = {
> +               .name = "starfive-eth-plat",
> +               .pm = &stmmac_pltfr_pm_ops,
> +               .of_match_table = starfive_eth_plat_match,
> +       },
> +};
> +
> +module_platform_driver(starfive_eth_plat_driver);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("StarFive DWMAC platform driver");
> +MODULE_AUTHOR("Yanhong Wang <yanhong.wang@starfivetech.com>");
> --
> 2.17.1
>
>
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv
