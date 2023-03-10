Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 481846B3A23
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 10:17:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230375AbjCJJRg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 04:17:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231368AbjCJJRI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 04:17:08 -0500
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6FEE23670
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 01:13:24 -0800 (PST)
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 3734A423CE
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 09:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1678439033;
        bh=l7P6OpQtpiO31JbN3tB83JPnIs3LDbM5XdhGwbnJ6b4=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=RgIKtO3585rNpUXi86Ouw4P94rmoeW4j3L0MkVkV5slNWAiHvo7KpuzyEBa1Ds42B
         6AelrnePrgdKYqyfS+tuFQ8jD0UeFnVhucQV+5LaDZfXIlVBeVCcXl5+/8jy0kt1wO
         ACRrnyx5XJ3A77Xk56TGCcbXKAIzo/TlM7s896KiR0T7Kh52PfGiEN4A49EvOZOgOY
         xFHAIMhbLvBYjcECsdgj3NseQXbzLhFOrYtmiPaGJr4SC6bCYRuIjW+BmZIndS4gHz
         cOQwZU5lKjEohT6xsuNVL06AXkDd0cM9+gB2yHpih7Thaj8QJYR8ngnsd94NRT8Q+f
         TLhCLoqxXOqaw==
Received: by mail-qt1-f198.google.com with SMTP id o10-20020a05622a138a00b003bfdabf3b89so2578624qtk.13
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 01:03:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678439029;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l7P6OpQtpiO31JbN3tB83JPnIs3LDbM5XdhGwbnJ6b4=;
        b=yu9/92hYSFT063/h4VWAwTgPSSPnK/yoZZBeD0nlW9IkJ7vDgyAmUvPL9oh6VlLuT3
         mXRu1xs0xN+JLiQ+N7ET+rFQ9KhCuoOwQVu/QxERk1W7U4bFryBO3tdkUE3XejITtHWF
         gTUshx7TS2rhgFMtg3Zfm6gn3pcjnXGLK0lge26c6B2XdY0ONkNsLbq9tvX9SvwIBCgF
         gtYJrzbUwU5rkvNN6fQbn16N9KMBKFnwWBvZmIQsaO3xWXK2U1fkBtFKq+i+23ULpp7+
         G0vD45+jz8fiIs30kOY8kpX3AFxQOAqRAfH75OBx9QSsRm1czWZX00Io9WYyxp7DXIqs
         QnaQ==
X-Gm-Message-State: AO0yUKVvo2cBdBMf4nRPwdC1whhxjnPSFDPRTWM4S3UcOTTdpOhcdylD
        Mw6xRPa8nBJjtyao1Afq5ujk+6pTCXnSf3lPGVDMd3s04gGb5aUEZewudvOcv5a7iL5EaBQ52T7
        s8OY2HdZwPgVAD8n47bWj33lY4A7lQEPA1FLTFFcmVp6gS0OmdQ==
X-Received: by 2002:ac8:7006:0:b0:3bd:1fb6:c67a with SMTP id x6-20020ac87006000000b003bd1fb6c67amr6508824qtm.3.1678439029566;
        Fri, 10 Mar 2023 01:03:49 -0800 (PST)
X-Google-Smtp-Source: AK7set+KWnXYz9aSz4TArFL25XmNgJvRdjP3rg/DyLtzfDCPLX7B5HWzhWnLogf8I17gdbpWfK55ntywjImEB0Di21c=
X-Received: by 2002:ac8:7006:0:b0:3bd:1fb6:c67a with SMTP id
 x6-20020ac87006000000b003bd1fb6c67amr6508813qtm.3.1678439029220; Fri, 10 Mar
 2023 01:03:49 -0800 (PST)
MIME-Version: 1.0
References: <20230303085928.4535-1-samin.guo@starfivetech.com>
 <20230303085928.4535-7-samin.guo@starfivetech.com> <CAJM55Z_YUXbny3NR7xLRu1ekzkgOsx2wgBWmCoQ5peMkN+fV_Q@mail.gmail.com>
 <CAJM55Z-xojA5onmQu+suwaB2F4e8imBRqVFeLScuZQ1ixdv_EA@mail.gmail.com> <49bf9e1d-95ac-8cf5-ca43-43bb82ace690@starfivetech.com>
In-Reply-To: <49bf9e1d-95ac-8cf5-ca43-43bb82ace690@starfivetech.com>
From:   Emil Renner Berthing <emil.renner.berthing@canonical.com>
Date:   Fri, 10 Mar 2023 10:03:32 +0100
Message-ID: <CAJM55Z9EwR_zmtBwvue+dSQ+ngiOdVqbFmuK9wiN3bm0i1LHqA@mail.gmail.com>
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
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Mar 2023 at 02:55, Guo Samin <samin.guo@starfivetech.com> wrote:
> -------- =E5=8E=9F=E5=A7=8B=E4=BF=A1=E6=81=AF --------
> =E4=B8=BB=E9=A2=98: Re: [PATCH v5 06/12] net: stmmac: Add glue layer for =
StarFive JH7110 SoC
> From: Emil Renner Berthing <emil.renner.berthing@canonical.com>
> =E6=94=B6=E4=BB=B6=E4=BA=BA: Samin Guo <samin.guo@starfivetech.com>
> =E6=97=A5=E6=9C=9F: 2023/3/10
>
> > On Fri, 10 Mar 2023 at 01:02, Emil Renner Berthing
> > <emil.renner.berthing@canonical.com> wrote:
> >> On Fri, 3 Mar 2023 at 10:01, Samin Guo <samin.guo@starfivetech.com> wr=
ote:
> >>>
> >>> This adds StarFive dwmac driver support on the StarFive JH7110 SoC.
> >>>
> >>> Co-developed-by: Emil Renner Berthing <kernel@esmil.dk>
> >>> Signed-off-by: Emil Renner Berthing <kernel@esmil.dk>
> >>> Signed-off-by: Samin Guo <samin.guo@starfivetech.com>
> >>> ---
> >>>  MAINTAINERS                                   |   1 +
> >>>  drivers/net/ethernet/stmicro/stmmac/Kconfig   |  12 ++
> >>>  drivers/net/ethernet/stmicro/stmmac/Makefile  |   1 +
> >>>  .../ethernet/stmicro/stmmac/dwmac-starfive.c  | 125 ++++++++++++++++=
++
> >>>  4 files changed, 139 insertions(+)
> >>>  create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac-starfiv=
e.c
> >>>
> >>> diff --git a/MAINTAINERS b/MAINTAINERS
> >>> index 4e236b7c7fd2..91a4f190c827 100644
> >>> --- a/MAINTAINERS
> >>> +++ b/MAINTAINERS
> >>> @@ -19916,6 +19916,7 @@ STARFIVE DWMAC GLUE LAYER
> >>>  M:     Emil Renner Berthing <kernel@esmil.dk>
> >>>  M:     Samin Guo <samin.guo@starfivetech.com>
> >>>  S:     Maintained
> >>> +F:     Documentation/devicetree/bindings/net/dwmac-starfive.c
> >>>  F:     Documentation/devicetree/bindings/net/starfive,jh7110-dwmac.y=
aml
> >>>
> >>>  STARFIVE JH71X0 CLOCK DRIVERS
> >>> diff --git a/drivers/net/ethernet/stmicro/stmmac/Kconfig b/drivers/ne=
t/ethernet/stmicro/stmmac/Kconfig
> >>> index f77511fe4e87..47fbccef9d04 100644
> >>> --- a/drivers/net/ethernet/stmicro/stmmac/Kconfig
> >>> +++ b/drivers/net/ethernet/stmicro/stmmac/Kconfig
> >>> @@ -165,6 +165,18 @@ config DWMAC_SOCFPGA
> >>>           for the stmmac device driver. This driver is used for
> >>>           arria5 and cyclone5 FPGA SoCs.
> >>>
> >>> +config DWMAC_STARFIVE
> >>> +       tristate "StarFive dwmac support"
> >>> +       depends on OF  && (ARCH_STARFIVE || COMPILE_TEST)
> >>> +       depends on STMMAC_ETH
> >>> +       default ARCH_STARFIVE
> >>> +       help
> >>> +         Support for ethernet controllers on StarFive RISC-V SoCs
> >>> +
> >>> +         This selects the StarFive platform specific glue layer supp=
ort for
> >>> +         the stmmac device driver. This driver is used for StarFive =
JH7110
> >>> +         ethernet controller.
> >>> +
> >>>  config DWMAC_STI
> >>>         tristate "STi GMAC support"
> >>>         default ARCH_STI
> >>> diff --git a/drivers/net/ethernet/stmicro/stmmac/Makefile b/drivers/n=
et/ethernet/stmicro/stmmac/Makefile
> >>> index 057e4bab5c08..8738fdbb4b2d 100644
> >>> --- a/drivers/net/ethernet/stmicro/stmmac/Makefile
> >>> +++ b/drivers/net/ethernet/stmicro/stmmac/Makefile
> >>> @@ -23,6 +23,7 @@ obj-$(CONFIG_DWMAC_OXNAS)     +=3D dwmac-oxnas.o
> >>>  obj-$(CONFIG_DWMAC_QCOM_ETHQOS)        +=3D dwmac-qcom-ethqos.o
> >>>  obj-$(CONFIG_DWMAC_ROCKCHIP)   +=3D dwmac-rk.o
> >>>  obj-$(CONFIG_DWMAC_SOCFPGA)    +=3D dwmac-altr-socfpga.o
> >>> +obj-$(CONFIG_DWMAC_STARFIVE)   +=3D dwmac-starfive.o
> >>>  obj-$(CONFIG_DWMAC_STI)                +=3D dwmac-sti.o
> >>>  obj-$(CONFIG_DWMAC_STM32)      +=3D dwmac-stm32.o
> >>>  obj-$(CONFIG_DWMAC_SUNXI)      +=3D dwmac-sunxi.o
> >>> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-starfive.c b/d=
rivers/net/ethernet/stmicro/stmmac/dwmac-starfive.c
> >>> new file mode 100644
> >>> index 000000000000..566378306f67
> >>> --- /dev/null
> >>> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-starfive.c
> >>> @@ -0,0 +1,125 @@
> >>> +// SPDX-License-Identifier: GPL-2.0+
> >>> +/*
> >>> + * StarFive DWMAC platform driver
> >>> + *
> >>> + * Copyright (C) 2022 StarFive Technology Co., Ltd.
> >>> + * Copyright (C) 2022 Emil Renner Berthing <kernel@esmil.dk>
> >>> + *
> >>> + */
> >>> +
> >>> +#include <linux/of_device.h>
> >>> +
> >>> +#include "stmmac_platform.h"
> >>> +
> >>> +struct starfive_dwmac {
> >>> +       struct device *dev;
> >>> +       struct clk *clk_tx;
> >>> +       struct clk *clk_gtx;
> >>> +       bool tx_use_rgmii_rxin_clk;
> >>> +};
> >>> +
> >>> +static void starfive_eth_fix_mac_speed(void *priv, unsigned int spee=
d)
> >>> +{
> >>> +       struct starfive_dwmac *dwmac =3D priv;
> >>> +       unsigned long rate;
> >>> +       int err;
> >>> +
> >>> +       /* Generally, the rgmii_tx clock is provided by the internal =
clock,
> >>> +        * which needs to match the corresponding clock frequency acc=
ording
> >>> +        * to different speeds. If the rgmii_tx clock is provided by =
the
> >>> +        * external rgmii_rxin, there is no need to configure the clo=
ck
> >>> +        * internally, because rgmii_rxin will be adaptively adjusted=
.
> >>> +        */
> >>> +       if (dwmac->tx_use_rgmii_rxin_clk)
> >>> +               return;
> >>> +
> >>> +       switch (speed) {
> >>> +       case SPEED_1000:
> >>> +               rate =3D 125000000;
> >>> +               break;
> >>> +       case SPEED_100:
> >>> +               rate =3D 25000000;
> >>> +               break;
> >>> +       case SPEED_10:
> >>> +               rate =3D 2500000;
> >>> +               break;
> >>> +       default:
> >>> +               dev_err(dwmac->dev, "invalid speed %u\n", speed);
> >>> +               break;
> >>> +       }
> >>> +
> >>> +       err =3D clk_set_rate(dwmac->clk_tx, rate);
> >>
> >> Hi Samin,
> >>
> >> I tried exercising this code by forcing the interface to downgrade
> >> from 1000Mbps to 100Mbps (ethtool -s end0 speed 100), and it doesn't
> >> seem to work. The reason is that clk_tx is a mux, and when you call
> >> clk_set_rate it will try to find the parent with the closest clock
> >> rate instead of adjusting the current parent as is needed here.
> >> However that is easily fixed by calling clk_set_rate on clk_gtx which
> >> is just a gate that *will* propagate the rate change to the parent.
> >>
> >> With this change, this piece of code and downgrading from 1000Mbps to
> >> 100Mbps works on the JH7100. However on the JH7110 there is a second
> >> problem. The parent of clk_gtx, confusingly called
> >> clk_gmac{0,1}_gtxclk is a divider (and gate) that takes the 1GHz PLL0
> >> clock and divides it by some integer. But according to [1] it can at
> >> most divide by 15 which is not enough to generate the 25MHz clock
> >> needed for 100Mbps. So now I wonder how this is supposed to work on
> >> the JH7110.
> >>
> >> [1]: https://doc-en.rvspace.org/JH7110/TRM/JH7110_TRM/sys_crg.html#sys=
_crg__section_skz_fxm_wsb
> >
> > Ah, I see now that gmac0_gtxclk is only used by gmac0 on the
> > VisionFive 2 v1.2A, where I think it's a known problem that only
> > 1000Mbps works.
> > On the 1.3B this function is not used at all, and I guess it also
> > ought to be skipped for gmac1 of the 1.2A using the rmii interface so
> > it doesn't risk changing the parent of the tx clock.
> >
> Hi Emil,
>
> V1.2A gmac0 only supports 1000M due to known problem, and v1.2A gmac1 sup=
ports 100M/10M.
>
> V1.2A gmac1 uses a parent clock from gmac1_rmii_rtx, whose parent clock i=
s from external phy clock gmac1_rmii_refin (fixed is 50M).
> The default frequency division value of gmac1_rmii_rtx is 2, so it can wo=
rk in 100M mode. =EF=BC=88clk_tx: 50/2=3D25M =3D=3D=3D> 100M mode=EF=BC=89.
> When gmac1 switches to 10M mode, the clock frequency of gmac1_rmii_rtx ne=
eds to be modified to 2.5M.
> So,if 1.2A gmac1 is skipped the starfive_eth_fix_mac_speed, 10M mode will=
 be unavailable.
>
>         gmac1_rmii_refin=EF=BC=8850M) =3D=3D> gmac1_rmii_rtx=EF=BC=88div =
2, by default) =3D=3D>  clk_tx (25M)  =EF=BC=88100M mode=EF=BC=89
>         gmac1_rmii_refin=EF=BC=8850M=EF=BC=89=3D=3D> gmac1_rmii_rtx=EF=BC=
=88div 20) =3D=3D> clk_tx (2.5M)  =EF=BC=8810M mode=EF=BC=89
>

I see. So on the JH7110 it is only when using gmac{0,1}_rmii_rtx ->
clk_tx with the rmii interface that this function is needed?

As noted above using the current fix_mac_speed with gmac{0,1}_gtxclk
-> clk_tx will produce wrong results, so for the VF2 v1.2A you
probably just want something like this in the device tree
&gmac0 {
  assigned-clocks =3D <&aoncrg JH7110_AONCLK_GMAC0_TX>, <&syscrg
JH7110_SYSCLK_GMAC0_GTXCLK>;
  assigned-clock-parents =3D <&syscrg JH7110_SYSCLK_GMAC0_GTXCLK>;
  assigned-clock-rates =3D <0> <125000000>;
};

..and then don't set the fix_mac_speed callback.

> Of course, as you mentioned earlier, we need to add gmac1_clk_tx uses CLK=
_SET_RATE_PARENT flag.

Yes, I'm not too sure how clk_set_rate on mux'es are supposed to work,
but if you can convince Hal and Stephen (the clock maintainer) that
clk_set_rate should always propagate the rate change to the current
parent, then I'm fine with it.

Alternatively you can add an optional clock to the bindings, and only
if the optional clock is set then set the fix_mac_speed callback to
modify the rate of that clock. This way you won't need the special
"starfive,tx-use-rgmii-clk" flag either.

/Emil
>
> Best regards,
> Samin
>
> >>> +       if (err)
> >>> +               dev_err(dwmac->dev, "failed to set tx rate %lu\n", ra=
te);
> >>> +}
> >>> +
> >>> +static int starfive_dwmac_probe(struct platform_device *pdev)
> >>> +{
> >>> +       struct plat_stmmacenet_data *plat_dat;
> >>> +       struct stmmac_resources stmmac_res;
> >>> +       struct starfive_dwmac *dwmac;
> >>> +       int err;
> >>> +
> >>> +       err =3D stmmac_get_platform_resources(pdev, &stmmac_res);
> >>> +       if (err)
> >>> +               return err;
> >>> +
> >>> +       plat_dat =3D stmmac_probe_config_dt(pdev, stmmac_res.mac);
> >>> +       if (IS_ERR(plat_dat)) {
> >>> +               dev_err(&pdev->dev, "dt configuration failed\n");
> >>> +               return PTR_ERR(plat_dat);
> >>> +       }
> >>> +
> >>> +       dwmac =3D devm_kzalloc(&pdev->dev, sizeof(*dwmac), GFP_KERNEL=
);
> >>> +       if (!dwmac)
> >>> +               return -ENOMEM;
> >>> +
> >>> +       dwmac->clk_tx =3D devm_clk_get_enabled(&pdev->dev, "tx");
> >>> +       if (IS_ERR(dwmac->clk_tx))
> >>> +               return dev_err_probe(&pdev->dev, PTR_ERR(dwmac->clk_t=
x),
> >>> +                                   "error getting tx clock\n");
> >>> +
> >>> +       dwmac->clk_gtx =3D devm_clk_get_enabled(&pdev->dev, "gtx");
> >>> +       if (IS_ERR(dwmac->clk_gtx))
> >>> +               return dev_err_probe(&pdev->dev, PTR_ERR(dwmac->clk_g=
tx),
> >>> +                                   "error getting gtx clock\n");
> >>> +
> >>> +       if (device_property_read_bool(&pdev->dev, "starfive,tx-use-rg=
mii-clk"))
> >>> +               dwmac->tx_use_rgmii_rxin_clk =3D true;
> >>> +
> >>> +       dwmac->dev =3D &pdev->dev;
> >>> +       plat_dat->fix_mac_speed =3D starfive_eth_fix_mac_speed;
> >>> +       plat_dat->init =3D NULL;
> >>> +       plat_dat->bsp_priv =3D dwmac;
> >>> +       plat_dat->dma_cfg->dche =3D true;
> >>> +
> >>> +       err =3D stmmac_dvr_probe(&pdev->dev, plat_dat, &stmmac_res);
> >>> +       if (err) {
> >>> +               stmmac_remove_config_dt(pdev, plat_dat);
> >>> +               return err;
> >>> +       }
> >>> +
> >>> +       return 0;
> >>> +}
> >>> +
> >>> +static const struct of_device_id starfive_dwmac_match[] =3D {
> >>> +       { .compatible =3D "starfive,jh7110-dwmac" },
> >>> +       { /* sentinel */ }
> >>> +};
> >>> +MODULE_DEVICE_TABLE(of, starfive_dwmac_match);
> >>> +
> >>> +static struct platform_driver starfive_dwmac_driver =3D {
> >>> +       .probe  =3D starfive_dwmac_probe,
> >>> +       .remove =3D stmmac_pltfr_remove,
> >>> +       .driver =3D {
> >>> +               .name =3D "starfive-dwmac",
> >>> +               .pm =3D &stmmac_pltfr_pm_ops,
> >>> +               .of_match_table =3D starfive_dwmac_match,
> >>> +       },
> >>> +};
> >>> +module_platform_driver(starfive_dwmac_driver);
> >>> +
> >>> +MODULE_LICENSE("GPL");
> >>> +MODULE_DESCRIPTION("StarFive DWMAC platform driver");
> >>> +MODULE_AUTHOR("Emil Renner Berthing <kernel@esmil.dk>");
> >>> +MODULE_AUTHOR("Samin Guo <samin.guo@starfivetech.com>");
> >>> --
> >>> 2.17.1
> >>>
> >>>
> >>> _______________________________________________
> >>> linux-riscv mailing list
> >>> linux-riscv@lists.infradead.org
> >>> http://lists.infradead.org/mailman/listinfo/linux-riscv
>
>
