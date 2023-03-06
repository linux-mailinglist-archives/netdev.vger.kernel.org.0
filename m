Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F19716ABF5D
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 13:21:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbjCFMVx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 07:21:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjCFMVv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 07:21:51 -0500
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16DE828D31
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 04:21:48 -0800 (PST)
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 7C76B3F59B
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 12:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1678105306;
        bh=TboJUQovpzYek2i/102139Iu9Lsvq8CTk2LnpuwQcnA=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=rE+uz6oAfGWePwRWt79RRYMXyJ6EuMYdPCldJM9pE+neErwMspaF2bN5b9dQwU22Q
         TxlYt2hQZiVODeKASY+YVm1iOiGBY9jBjH6zF2olKoZWDogdeZVUPJFg3+PFX6NZcm
         RBAsBToyy2uRavd5MwgMIaS7rMi9Mv4ICfSfscdsMDL44fwJQe67hn4OqyHJqRv0ND
         b5+b13ZvTXebLO0db2FAwPBLXKMHC/oZJDXskmTQM98vw95oota2bwyHzhoCNx7A+n
         OcOQKP+J/+M1PFLWOjLykd8MMtiwJNA4YOU7w9NpHSf6wuIv0KcpRlP85aE2pu7CRc
         FgmiwEy5fSLjg==
Received: by mail-qt1-f200.google.com with SMTP id r3-20020ac84243000000b003b9a3ab9153so5059259qtm.8
        for <netdev@vger.kernel.org>; Mon, 06 Mar 2023 04:21:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678105305;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TboJUQovpzYek2i/102139Iu9Lsvq8CTk2LnpuwQcnA=;
        b=MngTUYaF1/fvgJLlWn3yLlyjtFU+AzVlfw8pOC1xqh/qc9ifezdMDBVB173Mw5A8z1
         2SxmH/SnWkgfM82IG5U4K1neol3LtA0ZQB3zwTGSyZPvAmDl3l5OlNbDtzsQH7h+DS3L
         xhxLVYmzj+HIGegFeQj6Np1tcO2DBK+wEozdGnpK+3MDtkFkfbI9FI1mcX/yNofjhTIB
         ZRDDkDpGnS1SZSlGI/2eTb+8YR0Kk2NM6QmWAdFPbsbg/9OHRSfETqkW/5p68e1FsJGB
         zdBqPCCyGM92A9XikJ+SfXWp2bZaAwV9snwjxkDskhkhGeRAVriHZdzmbsz9Vy7MeAGO
         OuGw==
X-Gm-Message-State: AO0yUKW5WCymF+3shin6bVnqDL9uTtnlFRWkWYu9TL5clm1oQiqEGTwO
        +3f19EQ3+gOI1gkga1mRxkLbopG8sCBieihNI7qrqFYCO8/A0QHIYDoRw41gdncDJpLV9EcsNVc
        BlBY8+XMAIUEWvsHuNZ2C6KfitHioUb8STxYY82yz46OINUpVssNlIBsYkA==
X-Received: by 2002:a05:620a:345:b0:742:8868:bfd1 with SMTP id t5-20020a05620a034500b007428868bfd1mr2971473qkm.7.1678105305308;
        Mon, 06 Mar 2023 04:21:45 -0800 (PST)
X-Google-Smtp-Source: AK7set9Vw5rBc6mLgwpTZTAf3+5BrpTtyf8wanj2WdfYa0M+VT2N5xbJD14UzKOOfiJF4q/25FmdvUA1+auZ35RIdsw=
X-Received: by 2002:a05:620a:345:b0:742:8868:bfd1 with SMTP id
 t5-20020a05620a034500b007428868bfd1mr2971463qkm.7.1678105305017; Mon, 06 Mar
 2023 04:21:45 -0800 (PST)
MIME-Version: 1.0
References: <20230303085928.4535-1-samin.guo@starfivetech.com>
 <20230303085928.4535-7-samin.guo@starfivetech.com> <CAJM55Z_Ze3mD4UVtUFTRYN_n6WnobcFB5evgYZi9zBRNR2dU4w@mail.gmail.com>
 <9c9bd26c-b548-1011-9025-ae95107551ba@starfivetech.com>
In-Reply-To: <9c9bd26c-b548-1011-9025-ae95107551ba@starfivetech.com>
From:   Emil Renner Berthing <emil.renner.berthing@canonical.com>
Date:   Mon, 6 Mar 2023 13:21:28 +0100
Message-ID: <CAJM55Z-=MKnBb02exLbpsbSTMLs=Ttwr4hM2Ck5wDLKagJ+3rg@mail.gmail.com>
Subject: Re: [PATCH v5 06/12] net: stmmac: Add glue layer for StarFive JH7110 SoC
To:     Guo Samin <samin.guo@starfivetech.com>
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
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 6 Mar 2023 at 08:16, Guo Samin <samin.guo@starfivetech.com> wrote:
> =E5=9C=A8 2023/3/4 0:18:20, Emil Renner Berthing =E5=86=99=E9=81=93:
> > On Fri, 3 Mar 2023 at 10:01, Samin Guo <samin.guo@starfivetech.com> wro=
te:
> >> This adds StarFive dwmac driver support on the StarFive JH7110 SoC.
> >>
> >> Co-developed-by: Emil Renner Berthing <kernel@esmil.dk>
> >> Signed-off-by: Emil Renner Berthing <kernel@esmil.dk>
> >> Signed-off-by: Samin Guo <samin.guo@starfivetech.com>
> >> ---
> >>  MAINTAINERS                                   |   1 +
> >>  drivers/net/ethernet/stmicro/stmmac/Kconfig   |  12 ++
> >>  drivers/net/ethernet/stmicro/stmmac/Makefile  |   1 +
> >>  .../ethernet/stmicro/stmmac/dwmac-starfive.c  | 125 +++++++++++++++++=
+
> >>  4 files changed, 139 insertions(+)
> >>  create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac-starfive=
.c
> >>
> >> diff --git a/MAINTAINERS b/MAINTAINERS
> >> index 4e236b7c7fd2..91a4f190c827 100644
> >> --- a/MAINTAINERS
> >> +++ b/MAINTAINERS
> >> @@ -19916,6 +19916,7 @@ STARFIVE DWMAC GLUE LAYER
> >>  M:     Emil Renner Berthing <kernel@esmil.dk>
> >>  M:     Samin Guo <samin.guo@starfivetech.com>
> >>  S:     Maintained
> >> +F:     Documentation/devicetree/bindings/net/dwmac-starfive.c
> >>  F:     Documentation/devicetree/bindings/net/starfive,jh7110-dwmac.ya=
ml
> >>
> >>  STARFIVE JH71X0 CLOCK DRIVERS
> >> diff --git a/drivers/net/ethernet/stmicro/stmmac/Kconfig b/drivers/net=
/ethernet/stmicro/stmmac/Kconfig
> >> index f77511fe4e87..47fbccef9d04 100644
> >> --- a/drivers/net/ethernet/stmicro/stmmac/Kconfig
> >> +++ b/drivers/net/ethernet/stmicro/stmmac/Kconfig
> >> @@ -165,6 +165,18 @@ config DWMAC_SOCFPGA
> >>           for the stmmac device driver. This driver is used for
> >>           arria5 and cyclone5 FPGA SoCs.
> >>
> >> +config DWMAC_STARFIVE
> >> +       tristate "StarFive dwmac support"
> >> +       depends on OF  && (ARCH_STARFIVE || COMPILE_TEST)
> >
> > There is an extra space between "OF" and "&&" here.
> >
> will drop it
> >
> >> +       depends on STMMAC_ETH
> >
> > It's not visible in this patch context, but this whole config option
> > is surrounded by "if STMMAC_ETH" and "if STMMAC_PLATFORM", so "depends
> > on STMMAC_ETH" should not be needed.
> >
> will drop it.
> >> +       default ARCH_STARFIVE
> >
> > This driver is not required to boot the JH7110, so we should just
> > default to building it as a module. Eg.
> > default m if ARCH_STARFIVE
>
> Yes, this driver is not required to boot the JH7110, but the network is a=
 very basic module,
> it seems that other dwmac-platforms have been compiled into the kernel in=
stead of modules.

Right, but the defconfig should work on as many platforms as possible,
so if we build in every "basic" module for every platform the kernel
will be huge and waste a lot of memory on drivers that will never be
used.

Also even if this driver was built in the gmac0 would still not work
until the driver for the AON CRG is loaded, which also defaults to m
for the same reasons.

> >
> >> +       help
> >> +         Support for ethernet controllers on StarFive RISC-V SoCs
> >> +
> >> +         This selects the StarFive platform specific glue layer suppo=
rt for
> >> +         the stmmac device driver. This driver is used for StarFive J=
H7110
> >> +         ethernet controller.
> >> +
> >>  config DWMAC_STI
> >>         tristate "STi GMAC support"
> >>         default ARCH_STI
> >> diff --git a/drivers/net/ethernet/stmicro/stmmac/Makefile b/drivers/ne=
t/ethernet/stmicro/stmmac/Makefile
> >> index 057e4bab5c08..8738fdbb4b2d 100644
> >> --- a/drivers/net/ethernet/stmicro/stmmac/Makefile
> >> +++ b/drivers/net/ethernet/stmicro/stmmac/Makefile
> >> @@ -23,6 +23,7 @@ obj-$(CONFIG_DWMAC_OXNAS)     +=3D dwmac-oxnas.o
> >>  obj-$(CONFIG_DWMAC_QCOM_ETHQOS)        +=3D dwmac-qcom-ethqos.o
> >>  obj-$(CONFIG_DWMAC_ROCKCHIP)   +=3D dwmac-rk.o
> >>  obj-$(CONFIG_DWMAC_SOCFPGA)    +=3D dwmac-altr-socfpga.o
> >> +obj-$(CONFIG_DWMAC_STARFIVE)   +=3D dwmac-starfive.o
> >>  obj-$(CONFIG_DWMAC_STI)                +=3D dwmac-sti.o
> >>  obj-$(CONFIG_DWMAC_STM32)      +=3D dwmac-stm32.o
> >>  obj-$(CONFIG_DWMAC_SUNXI)      +=3D dwmac-sunxi.o
> >> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-starfive.c b/dr=
ivers/net/ethernet/stmicro/stmmac/dwmac-starfive.c
> >> new file mode 100644
> >> index 000000000000..566378306f67
> >> --- /dev/null
> >> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-starfive.c
> >> @@ -0,0 +1,125 @@
> >> +// SPDX-License-Identifier: GPL-2.0+
> >> +/*
> >> + * StarFive DWMAC platform driver
> >> + *
> >> + * Copyright (C) 2022 StarFive Technology Co., Ltd.
> >> + * Copyright (C) 2022 Emil Renner Berthing <kernel@esmil.dk>
> >
> > Sorry, after looking at my old git branches where this started as a
> > driver for the JH7100 this should really be
> > * Copyright (C) 2021 Emil Renner Berthing <kernel@esmil.dk>
> > * Copyright (C) 2022 StarFive Technology Co., Ltd.
> >
> OK, It should be.
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
> >
> > This pointer is only set, but never read. Please remove it.
> >>
> >> +       bool tx_use_rgmii_rxin_clk;
> >> +};
> >> +
> >> +static void starfive_eth_fix_mac_speed(void *priv, unsigned int speed=
)
> >
> > This should be starfive_dwmac_fix_mac_speed for consistency.
> >
> Sorry=EF=BC=8CI missed this, will fix next version.
> >> +{
> >> +       struct starfive_dwmac *dwmac =3D priv;
> >> +       unsigned long rate;
> >> +       int err;
> >> +
> >> +       /* Generally, the rgmii_tx clock is provided by the internal c=
lock,
> >> +        * which needs to match the corresponding clock frequency acco=
rding
> >> +        * to different speeds. If the rgmii_tx clock is provided by t=
he
> >> +        * external rgmii_rxin, there is no need to configure the cloc=
k
> >> +        * internally, because rgmii_rxin will be adaptively adjusted.
> >> +        */
> >> +       if (dwmac->tx_use_rgmii_rxin_clk)
> >> +               return;
> >
> > If this function is only needed in certain situations, why not just
> > set the plat_dat->fix_mac_speed callback when it is needed?
> >
> Sounds good idea.
> >> +       switch (speed) {
> >> +       case SPEED_1000:
> >> +               rate =3D 125000000;
> >> +               break;
> >> +       case SPEED_100:
> >> +               rate =3D 25000000;
> >> +               break;
> >> +       case SPEED_10:
> >> +               rate =3D 2500000;
> >> +               break;
> >> +       default:
> >> +               dev_err(dwmac->dev, "invalid speed %u\n", speed);
> >> +               break;
> >> +       }
> >> +
> >> +       err =3D clk_set_rate(dwmac->clk_tx, rate);
> >> +       if (err)
> >> +               dev_err(dwmac->dev, "failed to set tx rate %lu\n", rat=
e);
> >> +}
> >> +
> >> +static int starfive_dwmac_probe(struct platform_device *pdev)
> >> +{
> >> +       struct plat_stmmacenet_data *plat_dat;
> >> +       struct stmmac_resources stmmac_res;
> >> +       struct starfive_dwmac *dwmac;
> >> +       int err;
> >> +
> >> +       err =3D stmmac_get_platform_resources(pdev, &stmmac_res);
> >> +       if (err)
> >> +               return err;
> >> +
> >> +       plat_dat =3D stmmac_probe_config_dt(pdev, stmmac_res.mac);
> >> +       if (IS_ERR(plat_dat)) {
> >> +               dev_err(&pdev->dev, "dt configuration failed\n");
> >> +               return PTR_ERR(plat_dat);
> >> +       }
> >> +
> >> +       dwmac =3D devm_kzalloc(&pdev->dev, sizeof(*dwmac), GFP_KERNEL)=
;
> >> +       if (!dwmac)
> >> +               return -ENOMEM;
> >> +
> >> +       dwmac->clk_tx =3D devm_clk_get_enabled(&pdev->dev, "tx");
> >> +       if (IS_ERR(dwmac->clk_tx))
> >> +               return dev_err_probe(&pdev->dev, PTR_ERR(dwmac->clk_tx=
),
> >> +                                   "error getting tx clock\n");
> >> +
> >> +       dwmac->clk_gtx =3D devm_clk_get_enabled(&pdev->dev, "gtx");
> >> +       if (IS_ERR(dwmac->clk_gtx))
> >> +               return dev_err_probe(&pdev->dev, PTR_ERR(dwmac->clk_gt=
x),
> >> +                                   "error getting gtx clock\n");
> >> +
> >> +       if (device_property_read_bool(&pdev->dev, "starfive,tx-use-rgm=
ii-clk"))
> >> +               dwmac->tx_use_rgmii_rxin_clk =3D true;
> >> +
> >> +       dwmac->dev =3D &pdev->dev;
> >> +       plat_dat->fix_mac_speed =3D starfive_eth_fix_mac_speed;
> >
> > Eg.:
> > if (!device_property_read_bool(&pdev->dev, "starfive,tx_use_rgmii_clk")=
)
> >   plat_dat->fix_mac_speed =3D starfive_dwmac_fix_mac_speed;
> >
> Good idea, so we can remove flag 'tx_use_rgmii_rxin_clk' in struct starfi=
ve_dwmac.
> >> +       plat_dat->init =3D NULL;

Btw. plat_dat is initialized by kzalloc in stmmac_probe_config_dt and
I can't seem to find anything that sets plat_dat->init, so I think
this is redundant.

> >> +       plat_dat->bsp_priv =3D dwmac;
> >> +       plat_dat->dma_cfg->dche =3D true;
> >> +
> >> +       err =3D stmmac_dvr_probe(&pdev->dev, plat_dat, &stmmac_res);
> >> +       if (err) {
> >> +               stmmac_remove_config_dt(pdev, plat_dat);
> >> +               return err;
> >> +       }
> >> +
> >> +       return 0;
> >> +}
> >> +
> >> +static const struct of_device_id starfive_dwmac_match[] =3D {
> >> +       { .compatible =3D "starfive,jh7110-dwmac" },
> >> +       { /* sentinel */ }
> >> +};
> >> +MODULE_DEVICE_TABLE(of, starfive_dwmac_match);
> >> +
> >> +static struct platform_driver starfive_dwmac_driver =3D {
> >> +       .probe  =3D starfive_dwmac_probe,
> >> +       .remove =3D stmmac_pltfr_remove,
> >> +       .driver =3D {
> >> +               .name =3D "starfive-dwmac",
> >> +               .pm =3D &stmmac_pltfr_pm_ops,
> >> +               .of_match_table =3D starfive_dwmac_match,
> >> +       },
> >> +};
> >> +module_platform_driver(starfive_dwmac_driver);
> >> +
> >> +MODULE_LICENSE("GPL");
> >> +MODULE_DESCRIPTION("StarFive DWMAC platform driver");
> >> +MODULE_AUTHOR("Emil Renner Berthing <kernel@esmil.dk>");
> >> +MODULE_AUTHOR("Samin Guo <samin.guo@starfivetech.com>");
> >> --
> >> 2.17.1
> >>
> >>
> >> _______________________________________________
> >> linux-riscv mailing list
> >> linux-riscv@lists.infradead.org
> >> http://lists.infradead.org/mailman/listinfo/linux-riscv
> Best regards,
> Samin
>
> --
> Best regards,
> Samin
