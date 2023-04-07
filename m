Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 630AA6DB3F2
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 21:12:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbjDGTMB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 15:12:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjDGTMA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 15:12:00 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE54E61AC
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 12:11:58 -0700 (PDT)
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com [209.85.219.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 364FE3F237
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 19:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1680894717;
        bh=w6xTUwQ3JL7AvAeCA6lcpSlPVx3TyBza2dRcNivqo/k=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=V09WM05KMadk5jPYZRF8Zp3N1T4Ba4NhnBZSzIm1ZNZVu4PeeAffPVn48HqX4ZYdb
         btf0y5q/Fpenyx+shrUTyS3/zR2tlYUtr6mI1s7MBnwxo4MTjWJh0XNh1j/CCaLSP3
         BF3U91VCi2XDhR2Ap397l+sZh/XW9YcWrZfR7rwDZWg5az3/rEWR4nOIxHsUTswipX
         5A58z/ByRXrZ74LkNQfSdW9zy+YjVEj0CyNuR8H7IZdrg/zD/FifAy/LI6vgPL0JOA
         x2M1jwoOA8fCSk1JYuIVjMM7b0ngE3nbqVf/uaM+LC2Oi5PBzn3cfSPoUfPJyOpxVv
         Got0FOntRTQIA==
Received: by mail-qv1-f72.google.com with SMTP id w2-20020a0cc242000000b00583d8e55181so19726992qvh.23
        for <netdev@vger.kernel.org>; Fri, 07 Apr 2023 12:11:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680894716;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w6xTUwQ3JL7AvAeCA6lcpSlPVx3TyBza2dRcNivqo/k=;
        b=c0UJ6JfMSYv9h/UWVvgp0s8gPmflGjTymR/0AAJY7kTCFLNrToDh4aWE5txRnA0z1Z
         wJG1O721w4l+YHQ8PGS4GjtwSQUhlWzwrq0xnI7mpgWjH6gC16NKuQTBo9bZzSqBofl9
         +kvE9mp3E8A0SzkQ8o6/bGK8YozSBWoYEAZ/zxm7wlkYS9maGdqibmjrrDS61D/j2/u2
         5Z/tf2akRbm2M1+sqzM9D/qro7cnxcaQkc2q+XKuqTCgEdQcGgZmko8Uz+n5cdX0+a59
         6Nm39JCY3674Bapw59sTHpJ2EONJiOqatlVtKzK5EJlxqztkvnXwXJo7jq4sATwp/3eR
         lpVw==
X-Gm-Message-State: AAQBX9fWBJyti1dT8SmsQik/5BB3g/D+W4j5n4D/sEZBKAmGnquD7LEY
        bbsfcGUVkzK03S6V43CPbmA5PRnoML4NJ1Jjuv095GFXMKuX1wsd8sDiXMVvVs7l0/ZCZPvUtFF
        VHI1chNoS79CjDpPstwsKciZKTbJUpUo0w3BMtJj4OnxdGutKPw==
X-Received: by 2002:a05:620a:c4a:b0:74a:505:b63 with SMTP id u10-20020a05620a0c4a00b0074a05050b63mr836693qki.13.1680894715955;
        Fri, 07 Apr 2023 12:11:55 -0700 (PDT)
X-Google-Smtp-Source: AKy350akTeL9NyHSRBDye11honkl0p1F6cIXhHlvcXrcqMlPixNImXisSpl2Slzdm3cA1mQNRRPWrLRSKj0ZaKgvZ9I=
X-Received: by 2002:a05:620a:c4a:b0:74a:505:b63 with SMTP id
 u10-20020a05620a0c4a00b0074a05050b63mr836684qki.13.1680894715666; Fri, 07 Apr
 2023 12:11:55 -0700 (PDT)
MIME-Version: 1.0
References: <20230407110356.8449-1-samin.guo@starfivetech.com> <20230407110356.8449-6-samin.guo@starfivetech.com>
In-Reply-To: <20230407110356.8449-6-samin.guo@starfivetech.com>
From:   Emil Renner Berthing <emil.renner.berthing@canonical.com>
Date:   Fri, 7 Apr 2023 21:11:39 +0200
Message-ID: <CAJM55Z9jCdPASsk+fw_j+9QH3+Kj28tpCA4PgW_nB_ce7qWL8w@mail.gmail.com>
Subject: Re: [-net-next v11 5/6] net: stmmac: Add glue layer for StarFive
 JH7110 SoC
To:     Samin Guo <samin.guo@starfivetech.com>
Cc:     linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Pedro Moreira <pmmoreir@synopsys.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Conor Dooley <conor@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>,
        Yanhong Wang <yanhong.wang@starfivetech.com>,
        Tommaso Merciai <tomm.merciai@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 7 Apr 2023 at 13:05, Samin Guo <samin.guo@starfivetech.com> wrote:
>
> This adds StarFive dwmac driver support on the StarFive JH7110 SoC.
>
> Tested-by: Tommaso Merciai <tomm.merciai@gmail.com>
> Co-developed-by: Emil Renner Berthing <kernel@esmil.dk>
> Signed-off-by: Emil Renner Berthing <kernel@esmil.dk>
> Signed-off-by: Samin Guo <samin.guo@starfivetech.com>
> ---
>  MAINTAINERS                                   |   1 +
>  drivers/net/ethernet/stmicro/stmmac/Kconfig   |  12 ++
>  drivers/net/ethernet/stmicro/stmmac/Makefile  |   1 +
>  .../ethernet/stmicro/stmmac/dwmac-starfive.c  | 123 ++++++++++++++++++
>  4 files changed, 137 insertions(+)
>  create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac-starfive.c
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 6b6b67468b8f..46b366456cee 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -19910,6 +19910,7 @@ M:      Emil Renner Berthing <kernel@esmil.dk>
>  M:     Samin Guo <samin.guo@starfivetech.com>
>  S:     Maintained
>  F:     Documentation/devicetree/bindings/net/starfive,jh7110-dwmac.yaml
> +F:     drivers/net/ethernet/stmicro/stmmac/dwmac-starfive.c
>
>  STARFIVE JH7100 CLOCK DRIVERS
>  M:     Emil Renner Berthing <kernel@esmil.dk>
> diff --git a/drivers/net/ethernet/stmicro/stmmac/Kconfig b/drivers/net/ethernet/stmicro/stmmac/Kconfig
> index f77511fe4e87..5f5a997f21f3 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/Kconfig
> +++ b/drivers/net/ethernet/stmicro/stmmac/Kconfig
> @@ -165,6 +165,18 @@ config DWMAC_SOCFPGA
>           for the stmmac device driver. This driver is used for
>           arria5 and cyclone5 FPGA SoCs.
>
> +config DWMAC_STARFIVE
> +       tristate "StarFive dwmac support"
> +       depends on OF && (ARCH_STARFIVE || COMPILE_TEST)
> +       select MFD_SYSCON
> +       default m if ARCH_STARFIVE
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
> index 000000000000..4963d4008485
> --- /dev/null
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-starfive.c
> @@ -0,0 +1,123 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/*
> + * StarFive DWMAC platform driver
> + *
> + * Copyright (C) 2021 Emil Renner Berthing <kernel@esmil.dk>
> + * Copyright (C) 2022 StarFive Technology Co., Ltd.
> + *
> + */
> +
> +#include <linux/mfd/syscon.h>
> +#include <linux/of_device.h>
> +#include <linux/regmap.h>
> +
> +#include "stmmac_platform.h"
> +
> +struct starfive_dwmac {
> +       struct device *dev;
> +       struct clk *clk_tx;
> +};
> +
> +static void starfive_dwmac_fix_mac_speed(void *priv, unsigned int speed)
> +{
> +       struct starfive_dwmac *dwmac = priv;
> +       unsigned long rate;
> +       int err;
> +
> +       rate = clk_get_rate(dwmac->clk_tx);

Hi Samin,

I'm not sure why you added this line in this revision. If it's just to
not call clk_set_rate on the uninitialized rate, I'd much rather you
just returned early and don't call clk_set_rate at all in case of
errors.

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

That is skip the clk_get_rate above and just change this break to a return.

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
> +       struct clk *clk_gtx;
> +       int err;
> +
> +       err = stmmac_get_platform_resources(pdev, &stmmac_res);
> +       if (err)
> +               return dev_err_probe(&pdev->dev, err,
> +                                    "failed to get resources\n");
> +
> +       plat_dat = stmmac_probe_config_dt(pdev, stmmac_res.mac);
> +       if (IS_ERR(plat_dat))
> +               return dev_err_probe(&pdev->dev, PTR_ERR(plat_dat),
> +                                    "dt configuration failed\n");
> +
> +       dwmac = devm_kzalloc(&pdev->dev, sizeof(*dwmac), GFP_KERNEL);
> +       if (!dwmac)
> +               return -ENOMEM;
> +
> +       dwmac->clk_tx = devm_clk_get_enabled(&pdev->dev, "tx");
> +       if (IS_ERR(dwmac->clk_tx))
> +               return dev_err_probe(&pdev->dev, PTR_ERR(dwmac->clk_tx),
> +                                    "error getting tx clock\n");
> +
> +       clk_gtx = devm_clk_get_enabled(&pdev->dev, "gtx");
> +       if (IS_ERR(clk_gtx))
> +               return dev_err_probe(&pdev->dev, PTR_ERR(clk_gtx),
> +                                    "error getting gtx clock\n");
> +
> +       /* Generally, the rgmii_tx clock is provided by the internal clock,
> +        * which needs to match the corresponding clock frequency according
> +        * to different speeds. If the rgmii_tx clock is provided by the
> +        * external rgmii_rxin, there is no need to configure the clock
> +        * internally, because rgmii_rxin will be adaptively adjusted.
> +        */
> +       if (!device_property_read_bool(&pdev->dev, "starfive,tx-use-rgmii-clk"))
> +               plat_dat->fix_mac_speed = starfive_dwmac_fix_mac_speed;
> +
> +       dwmac->dev = &pdev->dev;
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
