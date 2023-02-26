Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B47856A3227
	for <lists+netdev@lfdr.de>; Sun, 26 Feb 2023 16:24:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231206AbjBZPYH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Feb 2023 10:24:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbjBZPXy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Feb 2023 10:23:54 -0500
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DF8C18A8A
        for <netdev@vger.kernel.org>; Sun, 26 Feb 2023 07:16:58 -0800 (PST)
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com [209.85.219.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 5D38C3F72B
        for <netdev@vger.kernel.org>; Sun, 26 Feb 2023 15:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1677424552;
        bh=wIBy6U41Dj5n4ITVB/Mns+jjmQ4eaV8djJQzjN4oRmU=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=YY1lYwftwx/w5BIGEbceF++jawqPgcS/hKW8hstBlR7F1kAt2uBs2/8Y13xmLAWyj
         XoRlPBktBtg+/EHvTQMCz0lh44fKKk/c8aFHE162+JY2eay3nX0zfdi0vELW5ovj5u
         zsQ2h+l1jkpo4jKaO++OSGJ0+fwFk+NoCtDKxMa5q6p/AjP2PECFSdfqPUBDvt532w
         1FlEl7gjX2u3JSX+1Q4C57sPQKuyEpNim9d9Pi1TIls/wNo9xxslGsPbvhyYdjhV3H
         PI4yfF5p4V1fRflj6BKQp7ZHoZCecgcq0hnJlD3vnQvaZf/47J2MIbDHrJFRlH/gyV
         0L9Nqjq2bC3zw==
Received: by mail-qv1-f69.google.com with SMTP id y6-20020ad457c6000000b00535261af1b1so2118095qvx.13
        for <netdev@vger.kernel.org>; Sun, 26 Feb 2023 07:15:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wIBy6U41Dj5n4ITVB/Mns+jjmQ4eaV8djJQzjN4oRmU=;
        b=clML4iiBeIzPkzjdezBbPMDpxk0xcwXi0fa+eggtBMwU0jv8bJr8vX67JwHofrDG6J
         zZ8cw1mdxlmVYlpCTzDiwjbTpqt43G1VbOQW+1oJWzytqBOvqQ3STiknsrhQwWYKvJHG
         FyayhHwIyfBpLYsqQe9DMnYDqtbjErQERtU6Mn/AZ+atXT8oxsalpT72WxfVAzngwJQ2
         ZeDdvkaYFQ4hsT3hB3trrK+NF8OJvScQpshUDSiAfgGfkvi3aQSh5YYstpjSP2OM6Ldl
         QURCc8YD/IY9ZaygUGqIfY/twGZsK+89N9+NMxkZXDWjOLG0x5SQb//nH4tNjhGeST9R
         +KzQ==
X-Gm-Message-State: AO0yUKV0m7gcwk5mgQiGrWbjfakr8e5wWVZ7Wi8jdpj3I2xT7pvhzg0g
        OVx5Ma9qpgUr3N7zfGrbEAoASKNWuWP96Vc111evXqZXO9lnf9TBL8aVQO52bEmZKtI9Lyg6HIe
        G60Rz59e9tsX69dwNbqnny0pvT8PFstsIIlRbrl7jlxXDa95nZw==
X-Received: by 2002:a05:620a:a07:b0:73b:a941:7206 with SMTP id i7-20020a05620a0a0700b0073ba9417206mr4398865qka.7.1677424551260;
        Sun, 26 Feb 2023 07:15:51 -0800 (PST)
X-Google-Smtp-Source: AK7set8kQriIg1Y8SjWJC50nqEv7gKjengpifGiOd7lR5AGwmNGEmtjmOyntTOaSQCXjHHlWUCWd3sZxCSc6ihPh31c=
X-Received: by 2002:a05:620a:a07:b0:73b:a941:7206 with SMTP id
 i7-20020a05620a0a0700b0073ba9417206mr4398863qka.7.1677424550956; Sun, 26 Feb
 2023 07:15:50 -0800 (PST)
MIME-Version: 1.0
References: <20230118061701.30047-1-yanhong.wang@starfivetech.com>
 <20230118061701.30047-6-yanhong.wang@starfivetech.com> <CAJM55Z-zvb5CJq4PU4c=YKvY0xPY216MAALFsmWTcVFjSd=wEA@mail.gmail.com>
 <dfddde90-ddce-d0e5-d31c-bbbbecaf7323@starfivetech.com>
In-Reply-To: <dfddde90-ddce-d0e5-d31c-bbbbecaf7323@starfivetech.com>
From:   Emil Renner Berthing <emil.renner.berthing@canonical.com>
Date:   Sun, 26 Feb 2023 16:15:34 +0100
Message-ID: <CAJM55Z-Pkd5+GBi4NYEuRSHezvJ_vUYiWLdQCpY2D2RqLa-btw@mail.gmail.com>
Subject: Re: [PATCH v4 5/7] net: stmmac: Add glue layer for StarFive JH7110 SoCs
To:     yanhong wang <yanhong.wang@starfivetech.com>
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
        Peter Geis <pgwipeout@gmail.com>, samin.guo@starfivetech.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Feb 2023 at 03:27, yanhong wang
<yanhong.wang@starfivetech.com> wrote:
>
> add  samin.guo@starfivetech.com  to loop.
>
> On 2023/2/16 18:53, Emil Renner Berthing wrote:
> > On Wed, 18 Jan 2023 at 07:20, Yanhong Wang
> > <yanhong.wang@starfivetech.com> wrote:
> >>
> >> This adds StarFive dwmac driver support on the StarFive JH7110 SoCs.
> >>
> >> Signed-off-by: Yanhong Wang <yanhong.wang@starfivetech.com>
> >> Co-developed-by: Emil Renner Berthing <kernel@esmil.dk>
> >> Signed-off-by: Emil Renner Berthing <kernel@esmil.dk>
> >> ---
> >>  MAINTAINERS                                   |   1 +
> >>  drivers/net/ethernet/stmicro/stmmac/Kconfig   |  12 ++
> >>  drivers/net/ethernet/stmicro/stmmac/Makefile  |   1 +
> >>  .../stmicro/stmmac/dwmac-starfive-plat.c      | 118 ++++++++++++++++++
> >>  4 files changed, 132 insertions(+)
> >>  create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac-starfive-plat.c
> >>
> >> diff --git a/MAINTAINERS b/MAINTAINERS
> >> index 56be59bb09f7..5b50b52d3dbb 100644
> >> --- a/MAINTAINERS
> >> +++ b/MAINTAINERS
> >> @@ -19609,6 +19609,7 @@ F:      include/dt-bindings/clock/starfive*
> >>  STARFIVE DWMAC GLUE LAYER
> >>  M:     Yanhong Wang <yanhong.wang@starfivetech.com>
> >>  S:     Maintained
> >> +F:     Documentation/devicetree/bindings/net/dwmac-starfive-plat.c
> >>  F:     Documentation/devicetree/bindings/net/starfive,jh7110-dwmac.yaml
> >>
> >>  STARFIVE PINCTRL DRIVER
> >> diff --git a/drivers/net/ethernet/stmicro/stmmac/Kconfig b/drivers/net/ethernet/stmicro/stmmac/Kconfig
> >> index 31ff35174034..f9a4ad4abd54 100644
> >> --- a/drivers/net/ethernet/stmicro/stmmac/Kconfig
> >> +++ b/drivers/net/ethernet/stmicro/stmmac/Kconfig
> >> @@ -235,6 +235,18 @@ config DWMAC_INTEL_PLAT
> >>           the stmmac device driver. This driver is used for the Intel Keem Bay
> >>           SoC.
> >>
> >> +config DWMAC_STARFIVE_PLAT
> >> +       tristate "StarFive dwmac support"
> >> +       depends on OF && COMMON_CLK
> >> +       depends on STMMAC_ETH
> >> +       default SOC_STARFIVE
> >> +       help
> >> +         Support for ethernet controllers on StarFive RISC-V SoCs
> >> +
> >> +         This selects the StarFive platform specific glue layer support for
> >> +         the stmmac device driver. This driver is used for StarFive JH7110
> >> +         ethernet controller.
> >> +
> >>  config DWMAC_VISCONTI
> >>         tristate "Toshiba Visconti DWMAC support"
> >>         default ARCH_VISCONTI
> >> diff --git a/drivers/net/ethernet/stmicro/stmmac/Makefile b/drivers/net/ethernet/stmicro/stmmac/Makefile
> >> index d4e12e9ace4f..a63ab0ab5071 100644
> >> --- a/drivers/net/ethernet/stmicro/stmmac/Makefile
> >> +++ b/drivers/net/ethernet/stmicro/stmmac/Makefile
> >> @@ -31,6 +31,7 @@ obj-$(CONFIG_DWMAC_DWC_QOS_ETH)       += dwmac-dwc-qos-eth.o
> >>  obj-$(CONFIG_DWMAC_INTEL_PLAT) += dwmac-intel-plat.o
> >>  obj-$(CONFIG_DWMAC_GENERIC)    += dwmac-generic.o
> >>  obj-$(CONFIG_DWMAC_IMX8)       += dwmac-imx.o
> >> +obj-$(CONFIG_DWMAC_STARFIVE_PLAT)      += dwmac-starfive-plat.o
> >
> > Hi Yanhong,
> >
> > For the next version could you please drop the _PLAT from the config
> > symbol and -plat from filename. I know the intel wrapper does the
> > same, but it's the only one, so lets do like the majority of other
> > wrappers and not add more different ways of doing things.
> >
>
> Thanks. I will fix.
>
> >>  obj-$(CONFIG_DWMAC_VISCONTI)   += dwmac-visconti.o
> >>  stmmac-platform-objs:= stmmac_platform.o
> >>  dwmac-altr-socfpga-objs := altr_tse_pcs.o dwmac-socfpga.o
> >> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-starfive-plat.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-starfive-plat.c
> >> new file mode 100644
> >> index 000000000000..e441d920933a
> >> --- /dev/null
> >> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-starfive-plat.c
> >> @@ -0,0 +1,118 @@
> >> +// SPDX-License-Identifier: GPL-2.0+
> >> +/*
> >> + * StarFive DWMAC platform driver
> >> + *
> >> + * Copyright(C) 2022 StarFive Technology Co., Ltd.
> >> + *
> >> + */
> >> +
> >> +#include <linux/of_device.h>
> >> +
> >> +#include "stmmac_platform.h"
> >> +
> >> +struct starfive_dwmac {
> >> +       struct device *dev;
> >> +       struct clk *clk_tx;
> >> +       struct clk *clk_gtx;
> >> +       struct clk *clk_gtxc;
> >> +};
> >
> > I like this name. For the next version could you also
> > s/starfive_eth_plat_/starfive_dwmac_/ on the function/struct names
> > below for consistency.
> >
>
> I will fix.
>
> >> +
> >> +static void starfive_eth_plat_fix_mac_speed(void *priv, unsigned int speed)
> >> +{
> >> +       struct starfive_dwmac *dwmac = priv;
> >> +       unsigned long rate;
> >> +       int err;
> >> +
> >> +       rate = clk_get_rate(dwmac->clk_gtx);
> >> +
> >> +       switch (speed) {
> >> +       case SPEED_1000:
> >> +               rate = 125000000;
> >> +               break;
> >> +       case SPEED_100:
> >> +               rate = 25000000;
> >> +               break;
> >> +       case SPEED_10:
> >> +               rate = 2500000;
> >> +               break;
> >> +       default:
> >> +               dev_err(dwmac->dev, "invalid speed %u\n", speed);
> >> +               break;
> >> +       }
> >> +
> >> +       err = clk_set_rate(dwmac->clk_gtx, rate);
> >> +       if (err)
> >> +               dev_err(dwmac->dev, "failed to set tx rate %lu\n", rate);
> >> +}
> >> +
> >> +static int starfive_eth_plat_probe(struct platform_device *pdev)
> >> +{
> >> +       struct plat_stmmacenet_data *plat_dat;
> >> +       struct stmmac_resources stmmac_res;
> >> +       struct starfive_dwmac *dwmac;
> >> +       int err;
> >> +
> >> +       err = stmmac_get_platform_resources(pdev, &stmmac_res);
> >> +       if (err)
> >> +               return err;
> >> +
> >> +       plat_dat = stmmac_probe_config_dt(pdev, stmmac_res.mac);
> >> +       if (IS_ERR(plat_dat)) {
> >> +               dev_err(&pdev->dev, "dt configuration failed\n");
> >> +               return PTR_ERR(plat_dat);
> >> +       }
> >> +
> >> +       dwmac = devm_kzalloc(&pdev->dev, sizeof(*dwmac), GFP_KERNEL);
> >> +       if (!dwmac)
> >> +               return -ENOMEM;
> >> +
> >> +       dwmac->clk_tx = devm_clk_get_enabled(&pdev->dev, "tx");
> >> +       if (IS_ERR(dwmac->clk_tx))
> >> +               return dev_err_probe(&pdev->dev, PTR_ERR(dwmac->clk_tx),
> >> +                                               "error getting tx clock\n");
> >> +
> >> +       dwmac->clk_gtx = devm_clk_get_enabled(&pdev->dev, "gtx");
> >> +       if (IS_ERR(dwmac->clk_gtx))
> >> +               return dev_err_probe(&pdev->dev, PTR_ERR(dwmac->clk_gtx),
> >> +                                               "error getting gtx clock\n");
> >> +
> >> +       dwmac->clk_gtxc = devm_clk_get_enabled(&pdev->dev, "gtxc");
> >> +       if (IS_ERR(dwmac->clk_gtxc))
> >> +               return dev_err_probe(&pdev->dev, PTR_ERR(dwmac->clk_gtxc),
> >> +                                               "error getting gtxc clock\n");
> >> +
> >> +       dwmac->dev = &pdev->dev;
> >> +       plat_dat->fix_mac_speed = starfive_eth_plat_fix_mac_speed;
> >> +       plat_dat->init = NULL;
> >> +       plat_dat->bsp_priv = dwmac;
> >> +       plat_dat->dma_cfg->dche = true;
> >> +
> >> +       err = stmmac_dvr_probe(&pdev->dev, plat_dat, &stmmac_res);
> >> +       if (err) {
> >> +               stmmac_remove_config_dt(pdev, plat_dat);
> >> +               return err;
> >> +       }
> >> +
> >> +       return 0;
> >> +}
> >> +
> >> +static const struct of_device_id starfive_eth_plat_match[] = {
> >> +       { .compatible = "starfive,jh7110-dwmac" },
> >> +       { }
> >> +};

I noticed you're missing a
MODULE_DEVICE_TABLE(of, starfive_dwmac_match);
here, so udev will load the module automatically.

While you're at it I also like the idiom of using { /* sentinel */ }
for the last entry here.

> >> +static struct platform_driver starfive_eth_plat_driver = {
> >> +       .probe  = starfive_eth_plat_probe,
> >> +       .remove = stmmac_pltfr_remove,
> >> +       .driver = {
> >> +               .name = "starfive-eth-plat",
> >> +               .pm = &stmmac_pltfr_pm_ops,
> >> +               .of_match_table = starfive_eth_plat_match,
> >> +       },
> >> +};
> >> +
> >> +module_platform_driver(starfive_eth_plat_driver);
> >> +
> >> +MODULE_LICENSE("GPL");
> >> +MODULE_DESCRIPTION("StarFive DWMAC platform driver");
> >> +MODULE_AUTHOR("Yanhong Wang <yanhong.wang@starfivetech.com>");
> >> --
> >> 2.17.1
> >>
> >>
> >> _______________________________________________
> >> linux-riscv mailing list
> >> linux-riscv@lists.infradead.org
> >> http://lists.infradead.org/mailman/listinfo/linux-riscv
