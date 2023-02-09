Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D524C690EA8
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 17:52:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbjBIQwX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 11:52:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbjBIQwW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 11:52:22 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B54D21817B;
        Thu,  9 Feb 2023 08:52:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=wvGkVNR7Kt7J6/yu+Te1okCnObmv66IkihKqSceI0Dc=; b=Wj2hJZKPNL80bvox5/FV1a6sg5
        Oc+cEMQCo6GY/A4nxogX20wUKQYDJiERuH2xRHxBzBbkLuXoCsddt90ihfyDHkxWhd7PxT/5gJADB
        JH58J4KjZvv2zZVag82gdwKKWXA7HnJdgs11/UycXLdLd8IcPZIKTxX368aWP6/c1K2DeCLo2nKZv
        +6qeddXumJqwYVxsHqgcYGGlOtfutYBfLNKaxURyNPjKV4tHO21YEehqQ2pyojfoQJbRLduEvcTiF
        7rzX3GdM7Xy36SLQm7X3WSqHfGj6P1AKqclJTr9RyDRmt+MT/X+I8Sz/QNBhji4TIRYck4btkCtvQ
        36n4Xnhw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:36484)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pQA9H-00089d-5m; Thu, 09 Feb 2023 16:51:50 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pQA9A-0004kb-Bs; Thu, 09 Feb 2023 16:51:44 +0000
Date:   Thu, 9 Feb 2023 16:51:44 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>
Cc:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Wong Vee Khee <veekhee@apple.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Revanth Kumar Uppala <ruppala@nvidia.com>,
        Tan Tee Min <tee.min.tan@linux.intel.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?iso-8859-1?Q?Miqu=E8l?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        Jon Hunter <jonathanh@nvidia.com>, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net-next v2 5/6] net: stmmac: add support for RZ/N1 GMAC
Message-ID: <Y+UkoNpA9NiXlGmT@shell.armlinux.org.uk>
References: <20230208164203.378153-1-clement.leger@bootlin.com>
 <20230208164203.378153-6-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230208164203.378153-6-clement.leger@bootlin.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 08, 2023 at 05:42:02PM +0100, Clément Léger wrote:
> Add support for Renesas RZ/N1 GMAC. This support uses a custom PCS (MIIC)
> which is handle by parsing the pcs-handle device tree property.
> 
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/Kconfig   |  11 ++
>  drivers/net/ethernet/stmicro/stmmac/Makefile  |   1 +
>  .../net/ethernet/stmicro/stmmac/dwmac-rzn1.c  | 120 ++++++++++++++++++
>  3 files changed, 132 insertions(+)
>  create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac-rzn1.c
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/Kconfig b/drivers/net/ethernet/stmicro/stmmac/Kconfig
> index f77511fe4e87..be5429b7e192 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/Kconfig
> +++ b/drivers/net/ethernet/stmicro/stmmac/Kconfig
> @@ -153,6 +153,17 @@ config DWMAC_ROCKCHIP
>  	  This selects the Rockchip RK3288 SoC glue layer support for
>  	  the stmmac device driver.
>  
> +config DWMAC_RZN1
> +	tristate "Renesas RZ/N1 dwmac support"
> +	default ARCH_RZN1
> +	depends on OF && (ARCH_RZN1 || COMPILE_TEST)
> +	select PCS_RZN1_MIIC
> +	help
> +	  Support for Ethernet controller on Renesas RZ/N1 SoC family.
> +
> +	  This selects the Renesas RZ/N1 SoC glue layer support for
> +	  the stmmac device driver.
> +
>  config DWMAC_SOCFPGA
>  	tristate "SOCFPGA dwmac support"
>  	default ARCH_INTEL_SOCFPGA
> diff --git a/drivers/net/ethernet/stmicro/stmmac/Makefile b/drivers/net/ethernet/stmicro/stmmac/Makefile
> index 057e4bab5c08..53a0f74c1cb5 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/Makefile
> +++ b/drivers/net/ethernet/stmicro/stmmac/Makefile
> @@ -22,6 +22,7 @@ obj-$(CONFIG_DWMAC_MESON)	+= dwmac-meson.o dwmac-meson8b.o
>  obj-$(CONFIG_DWMAC_OXNAS)	+= dwmac-oxnas.o
>  obj-$(CONFIG_DWMAC_QCOM_ETHQOS)	+= dwmac-qcom-ethqos.o
>  obj-$(CONFIG_DWMAC_ROCKCHIP)	+= dwmac-rk.o
> +obj-$(CONFIG_DWMAC_RZN1)	+= dwmac-rzn1.o
>  obj-$(CONFIG_DWMAC_SOCFPGA)	+= dwmac-altr-socfpga.o
>  obj-$(CONFIG_DWMAC_STI)		+= dwmac-sti.o
>  obj-$(CONFIG_DWMAC_STM32)	+= dwmac-stm32.o
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-rzn1.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-rzn1.c
> new file mode 100644
> index 000000000000..82118d8cb50e
> --- /dev/null
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-rzn1.c
> @@ -0,0 +1,120 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * Copyright (C) 2022 Schneider-Electric
> + *
> + * Clément Léger <clement.leger@bootlin.com>
> + */
> +
> +#include <linux/of.h>
> +#include <linux/pcs-rzn1-miic.h>
> +#include <linux/phylink.h>
> +#include <linux/platform_device.h>
> +
> +#include "stmmac_platform.h"
> +#include "stmmac.h"
> +
> +struct rzn1_dwmac {
> +	struct phylink_pcs *pcs;
> +};

I don't understand why you need this...

> +
> +static int rzn1_dt_parse(struct device *dev, struct rzn1_dwmac *dwmac)

You could pass a pointer to struct plat_stmmacenet_data into here, and
have it fill in your new ->pcs directly, and save the extra devm
allocations.

> +{
> +	struct device_node *np = dev->of_node;
> +	struct device_node *pcs_node;
> +	struct phylink_pcs *pcs;
> +	int ret;
> +
> +	pcs_node = of_parse_phandle(np, "pcs-handle", 0);
> +	if (!pcs_node)
> +		return 0;
> +
> +	pcs = miic_create(dev, pcs_node);

Don't you need to put pcs_node?

> +	if (IS_ERR(pcs))
> +		return PTR_ERR(pcs);
> +
> +	ret = miic_early_setup(pcs, dev);
> +	if (ret) {
> +		miic_destroy(pcs);
> +		return ret;
> +	}
> +
> +	dwmac->pcs = pcs;
> +
> +	return 0;
> +}
> +
> +static int rzn1_dwmac_probe(struct platform_device *pdev)
> +{
> +	struct plat_stmmacenet_data *plat_dat;
> +	struct stmmac_resources stmmac_res;
> +	struct device *dev = &pdev->dev;
> +	struct rzn1_dwmac *dwmac;
> +	int ret;
> +
> +	ret = stmmac_get_platform_resources(pdev, &stmmac_res);
> +	if (ret)
> +		return ret;
> +
> +	plat_dat = stmmac_probe_config_dt(pdev, stmmac_res.mac);
> +	if (IS_ERR(plat_dat))
> +		return PTR_ERR(plat_dat);
> +
> +	dwmac = devm_kzalloc(dev, sizeof(*dwmac), GFP_KERNEL);
> +	if (!dwmac) {
> +		ret = -ENOMEM;
> +		goto err_remove_config_dt;
> +	}
> +
> +	ret = rzn1_dt_parse(dev, dwmac);
> +	if (ret)
> +		goto err_remove_config_dt;
> +
> +	plat_dat->bsp_priv = dwmac;

You could set this to point back to plat_dat.

> +	plat_dat->pcs = dwmac->pcs;
> +
> +	ret = stmmac_dvr_probe(dev, plat_dat, &stmmac_res);
> +	if (ret)
> +		goto err_free_pcs;
> +
> +	return 0;
> +
> +err_free_pcs:
> +	if (dwmac->pcs)
> +		miic_destroy(dwmac->pcs);
> +
> +err_remove_config_dt:
> +	stmmac_remove_config_dt(pdev, plat_dat);
> +
> +	return ret;
> +}
> +
> +static int rzn1_dwmac_remove(struct platform_device *pdev)
> +{
> +	struct rzn1_dwmac *dwmac = get_stmmac_bsp_priv(&pdev->dev);

... which means you get plat_dat back here...

> +	int ret = stmmac_dvr_remove(&pdev->dev);
> +
> +	if (dwmac->pcs)
> +		miic_destroy(dwmac->pcs);

and can still destroy the pcs.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
