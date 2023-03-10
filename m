Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79B636B32DA
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 01:40:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbjCJAkL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 19:40:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjCJAkH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 19:40:07 -0500
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0360110460A
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 16:40:05 -0800 (PST)
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id E5460423CE
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 00:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1678408803;
        bh=Qgq/S6Aoxv+YRzxR6Qk4jlqBd/H7XiPNWF6GE4eyDZc=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=WGKIhYpllczOypl1KIsCHToV/i7zAaOKC2s6ywZBlmV3cJ9+Bj+E3xgerrXPR962H
         lK+VMehHHwDMj3Vo0pvIP6KQdAywpPAJfkE3AoMnUsDES13whFlAhTa9XacGr/FrgP
         I8C9VYN08U024CL+4bt9m/selvsfri80mliy0Qsg9M0xgWtCEBwWEi2flxo2bPOzNZ
         usSfvUimAhC85gga0YzWrh3B1IRTnBfBcboAIDTgGEb65M01jyJ8pBUSqVyY3v2UIK
         +zxDV/JOBRnsHojiI2kiPepCxgxaDkg382PqhUDUxLYJqN8ywy2TU9CdX5EyCzKr1L
         AmzkMzXzPkqXQ==
Received: by mail-qt1-f198.google.com with SMTP id t22-20020ac86a16000000b003bd1c0f74cfso2045812qtr.20
        for <netdev@vger.kernel.org>; Thu, 09 Mar 2023 16:40:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678408803;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Qgq/S6Aoxv+YRzxR6Qk4jlqBd/H7XiPNWF6GE4eyDZc=;
        b=eQEvomkZVxnJQIBxMaUlcUE9sZmYGpCZRtdX4CUdvJW9uCh4g3cwQAyEaB9H8QSbuL
         PCsRcYE0pQmHrDchydjnGhpwYq+FU5IXMJjCu4u3M3GJyAbcDfe3vNTwMzwIvOOBc5V/
         Emefdfh8qHRcjAQf64gLQOJUul5TJ56bvig8s2uX+CahdHKWTSmXoOGuBtURzVMUAa6l
         GtgKrw8XRUXzqfiyfQfymqQMz8DnNN/2Q2A0w9ceYgW6qOzFOAe3zAWJpqAz0SzAqp3e
         Vbe5C4C5VQSCsFBrh4YcwbivI8zOj1cLWYwUWtjUfPH76QW1hk2BmV4Gyx4koUsSxfwi
         zsxg==
X-Gm-Message-State: AO0yUKUBYzbGE2IkyyBz6J4p28krPcjolJn9BAP4vHNSXglg7L0o4xjw
        JhIBbP78zSIdDHUakDUFhUT77q6ck5SrtKghbr2ftLkob3KjDE14M1kr84o863A04/KJqZGDup7
        kn1Y4JqpDI81THJDu1fdl2UeA6+j61d7vTmef/FqY7hKCr28UAA==
X-Received: by 2002:ac8:7006:0:b0:3bf:e265:9bf with SMTP id x6-20020ac87006000000b003bfe26509bfmr7185885qtm.5.1678408802749;
        Thu, 09 Mar 2023 16:40:02 -0800 (PST)
X-Google-Smtp-Source: AK7set997Vz1tm5Klw8Fb6TUNy5d6qVc2+ag7bibJFFdsMG357M9sbnlnfdKusr1Ja0Xwr2uhU7ld0NRKXqWfX9/nHc=
X-Received: by 2002:ac8:7006:0:b0:3bf:e265:9bf with SMTP id
 x6-20020ac87006000000b003bfe26509bfmr7185874qtm.5.1678408802443; Thu, 09 Mar
 2023 16:40:02 -0800 (PST)
MIME-Version: 1.0
References: <20230303085928.4535-1-samin.guo@starfivetech.com>
 <20230303085928.4535-7-samin.guo@starfivetech.com> <CAJM55Z_YUXbny3NR7xLRu1ekzkgOsx2wgBWmCoQ5peMkN+fV_Q@mail.gmail.com>
In-Reply-To: <CAJM55Z_YUXbny3NR7xLRu1ekzkgOsx2wgBWmCoQ5peMkN+fV_Q@mail.gmail.com>
From:   Emil Renner Berthing <emil.renner.berthing@canonical.com>
Date:   Fri, 10 Mar 2023 01:39:45 +0100
Message-ID: <CAJM55Z-xojA5onmQu+suwaB2F4e8imBRqVFeLScuZQ1ixdv_EA@mail.gmail.com>
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
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Mar 2023 at 01:02, Emil Renner Berthing
<emil.renner.berthing@canonical.com> wrote:
> On Fri, 3 Mar 2023 at 10:01, Samin Guo <samin.guo@starfivetech.com> wrote:
> >
> > This adds StarFive dwmac driver support on the StarFive JH7110 SoC.
> >
> > Co-developed-by: Emil Renner Berthing <kernel@esmil.dk>
> > Signed-off-by: Emil Renner Berthing <kernel@esmil.dk>
> > Signed-off-by: Samin Guo <samin.guo@starfivetech.com>
> > ---
> >  MAINTAINERS                                   |   1 +
> >  drivers/net/ethernet/stmicro/stmmac/Kconfig   |  12 ++
> >  drivers/net/ethernet/stmicro/stmmac/Makefile  |   1 +
> >  .../ethernet/stmicro/stmmac/dwmac-starfive.c  | 125 ++++++++++++++++++
> >  4 files changed, 139 insertions(+)
> >  create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac-starfive.c
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 4e236b7c7fd2..91a4f190c827 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -19916,6 +19916,7 @@ STARFIVE DWMAC GLUE LAYER
> >  M:     Emil Renner Berthing <kernel@esmil.dk>
> >  M:     Samin Guo <samin.guo@starfivetech.com>
> >  S:     Maintained
> > +F:     Documentation/devicetree/bindings/net/dwmac-starfive.c
> >  F:     Documentation/devicetree/bindings/net/starfive,jh7110-dwmac.yaml
> >
> >  STARFIVE JH71X0 CLOCK DRIVERS
> > diff --git a/drivers/net/ethernet/stmicro/stmmac/Kconfig b/drivers/net/ethernet/stmicro/stmmac/Kconfig
> > index f77511fe4e87..47fbccef9d04 100644
> > --- a/drivers/net/ethernet/stmicro/stmmac/Kconfig
> > +++ b/drivers/net/ethernet/stmicro/stmmac/Kconfig
> > @@ -165,6 +165,18 @@ config DWMAC_SOCFPGA
> >           for the stmmac device driver. This driver is used for
> >           arria5 and cyclone5 FPGA SoCs.
> >
> > +config DWMAC_STARFIVE
> > +       tristate "StarFive dwmac support"
> > +       depends on OF  && (ARCH_STARFIVE || COMPILE_TEST)
> > +       depends on STMMAC_ETH
> > +       default ARCH_STARFIVE
> > +       help
> > +         Support for ethernet controllers on StarFive RISC-V SoCs
> > +
> > +         This selects the StarFive platform specific glue layer support for
> > +         the stmmac device driver. This driver is used for StarFive JH7110
> > +         ethernet controller.
> > +
> >  config DWMAC_STI
> >         tristate "STi GMAC support"
> >         default ARCH_STI
> > diff --git a/drivers/net/ethernet/stmicro/stmmac/Makefile b/drivers/net/ethernet/stmicro/stmmac/Makefile
> > index 057e4bab5c08..8738fdbb4b2d 100644
> > --- a/drivers/net/ethernet/stmicro/stmmac/Makefile
> > +++ b/drivers/net/ethernet/stmicro/stmmac/Makefile
> > @@ -23,6 +23,7 @@ obj-$(CONFIG_DWMAC_OXNAS)     += dwmac-oxnas.o
> >  obj-$(CONFIG_DWMAC_QCOM_ETHQOS)        += dwmac-qcom-ethqos.o
> >  obj-$(CONFIG_DWMAC_ROCKCHIP)   += dwmac-rk.o
> >  obj-$(CONFIG_DWMAC_SOCFPGA)    += dwmac-altr-socfpga.o
> > +obj-$(CONFIG_DWMAC_STARFIVE)   += dwmac-starfive.o
> >  obj-$(CONFIG_DWMAC_STI)                += dwmac-sti.o
> >  obj-$(CONFIG_DWMAC_STM32)      += dwmac-stm32.o
> >  obj-$(CONFIG_DWMAC_SUNXI)      += dwmac-sunxi.o
> > diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-starfive.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-starfive.c
> > new file mode 100644
> > index 000000000000..566378306f67
> > --- /dev/null
> > +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-starfive.c
> > @@ -0,0 +1,125 @@
> > +// SPDX-License-Identifier: GPL-2.0+
> > +/*
> > + * StarFive DWMAC platform driver
> > + *
> > + * Copyright (C) 2022 StarFive Technology Co., Ltd.
> > + * Copyright (C) 2022 Emil Renner Berthing <kernel@esmil.dk>
> > + *
> > + */
> > +
> > +#include <linux/of_device.h>
> > +
> > +#include "stmmac_platform.h"
> > +
> > +struct starfive_dwmac {
> > +       struct device *dev;
> > +       struct clk *clk_tx;
> > +       struct clk *clk_gtx;
> > +       bool tx_use_rgmii_rxin_clk;
> > +};
> > +
> > +static void starfive_eth_fix_mac_speed(void *priv, unsigned int speed)
> > +{
> > +       struct starfive_dwmac *dwmac = priv;
> > +       unsigned long rate;
> > +       int err;
> > +
> > +       /* Generally, the rgmii_tx clock is provided by the internal clock,
> > +        * which needs to match the corresponding clock frequency according
> > +        * to different speeds. If the rgmii_tx clock is provided by the
> > +        * external rgmii_rxin, there is no need to configure the clock
> > +        * internally, because rgmii_rxin will be adaptively adjusted.
> > +        */
> > +       if (dwmac->tx_use_rgmii_rxin_clk)
> > +               return;
> > +
> > +       switch (speed) {
> > +       case SPEED_1000:
> > +               rate = 125000000;
> > +               break;
> > +       case SPEED_100:
> > +               rate = 25000000;
> > +               break;
> > +       case SPEED_10:
> > +               rate = 2500000;
> > +               break;
> > +       default:
> > +               dev_err(dwmac->dev, "invalid speed %u\n", speed);
> > +               break;
> > +       }
> > +
> > +       err = clk_set_rate(dwmac->clk_tx, rate);
>
> Hi Samin,
>
> I tried exercising this code by forcing the interface to downgrade
> from 1000Mbps to 100Mbps (ethtool -s end0 speed 100), and it doesn't
> seem to work. The reason is that clk_tx is a mux, and when you call
> clk_set_rate it will try to find the parent with the closest clock
> rate instead of adjusting the current parent as is needed here.
> However that is easily fixed by calling clk_set_rate on clk_gtx which
> is just a gate that *will* propagate the rate change to the parent.
>
> With this change, this piece of code and downgrading from 1000Mbps to
> 100Mbps works on the JH7100. However on the JH7110 there is a second
> problem. The parent of clk_gtx, confusingly called
> clk_gmac{0,1}_gtxclk is a divider (and gate) that takes the 1GHz PLL0
> clock and divides it by some integer. But according to [1] it can at
> most divide by 15 which is not enough to generate the 25MHz clock
> needed for 100Mbps. So now I wonder how this is supposed to work on
> the JH7110.
>
> [1]: https://doc-en.rvspace.org/JH7110/TRM/JH7110_TRM/sys_crg.html#sys_crg__section_skz_fxm_wsb

Ah, I see now that gmac0_gtxclk is only used by gmac0 on the
VisionFive 2 v1.2A, where I think it's a known problem that only
1000Mbps works.
On the 1.3B this function is not used at all, and I guess it also
ought to be skipped for gmac1 of the 1.2A using the rmii interface so
it doesn't risk changing the parent of the tx clock.

> > +       if (err)
> > +               dev_err(dwmac->dev, "failed to set tx rate %lu\n", rate);
> > +}
> > +
> > +static int starfive_dwmac_probe(struct platform_device *pdev)
> > +{
> > +       struct plat_stmmacenet_data *plat_dat;
> > +       struct stmmac_resources stmmac_res;
> > +       struct starfive_dwmac *dwmac;
> > +       int err;
> > +
> > +       err = stmmac_get_platform_resources(pdev, &stmmac_res);
> > +       if (err)
> > +               return err;
> > +
> > +       plat_dat = stmmac_probe_config_dt(pdev, stmmac_res.mac);
> > +       if (IS_ERR(plat_dat)) {
> > +               dev_err(&pdev->dev, "dt configuration failed\n");
> > +               return PTR_ERR(plat_dat);
> > +       }
> > +
> > +       dwmac = devm_kzalloc(&pdev->dev, sizeof(*dwmac), GFP_KERNEL);
> > +       if (!dwmac)
> > +               return -ENOMEM;
> > +
> > +       dwmac->clk_tx = devm_clk_get_enabled(&pdev->dev, "tx");
> > +       if (IS_ERR(dwmac->clk_tx))
> > +               return dev_err_probe(&pdev->dev, PTR_ERR(dwmac->clk_tx),
> > +                                   "error getting tx clock\n");
> > +
> > +       dwmac->clk_gtx = devm_clk_get_enabled(&pdev->dev, "gtx");
> > +       if (IS_ERR(dwmac->clk_gtx))
> > +               return dev_err_probe(&pdev->dev, PTR_ERR(dwmac->clk_gtx),
> > +                                   "error getting gtx clock\n");
> > +
> > +       if (device_property_read_bool(&pdev->dev, "starfive,tx-use-rgmii-clk"))
> > +               dwmac->tx_use_rgmii_rxin_clk = true;
> > +
> > +       dwmac->dev = &pdev->dev;
> > +       plat_dat->fix_mac_speed = starfive_eth_fix_mac_speed;
> > +       plat_dat->init = NULL;
> > +       plat_dat->bsp_priv = dwmac;
> > +       plat_dat->dma_cfg->dche = true;
> > +
> > +       err = stmmac_dvr_probe(&pdev->dev, plat_dat, &stmmac_res);
> > +       if (err) {
> > +               stmmac_remove_config_dt(pdev, plat_dat);
> > +               return err;
> > +       }
> > +
> > +       return 0;
> > +}
> > +
> > +static const struct of_device_id starfive_dwmac_match[] = {
> > +       { .compatible = "starfive,jh7110-dwmac" },
> > +       { /* sentinel */ }
> > +};
> > +MODULE_DEVICE_TABLE(of, starfive_dwmac_match);
> > +
> > +static struct platform_driver starfive_dwmac_driver = {
> > +       .probe  = starfive_dwmac_probe,
> > +       .remove = stmmac_pltfr_remove,
> > +       .driver = {
> > +               .name = "starfive-dwmac",
> > +               .pm = &stmmac_pltfr_pm_ops,
> > +               .of_match_table = starfive_dwmac_match,
> > +       },
> > +};
> > +module_platform_driver(starfive_dwmac_driver);
> > +
> > +MODULE_LICENSE("GPL");
> > +MODULE_DESCRIPTION("StarFive DWMAC platform driver");
> > +MODULE_AUTHOR("Emil Renner Berthing <kernel@esmil.dk>");
> > +MODULE_AUTHOR("Samin Guo <samin.guo@starfivetech.com>");
> > --
> > 2.17.1
> >
> >
> > _______________________________________________
> > linux-riscv mailing list
> > linux-riscv@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/linux-riscv
