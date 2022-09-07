Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C75245B0A3B
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 18:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbiIGQgk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 12:36:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbiIGQgi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 12:36:38 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D28FEDF72;
        Wed,  7 Sep 2022 09:36:36 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id u9so31684065ejy.5;
        Wed, 07 Sep 2022 09:36:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date;
        bh=9OurSfaRscRJrc92d+EDlOtf1l62+mJ334cnIisu+nk=;
        b=mQO+keKXaw57zyTymwTopQhIonVV9obRsnlcmO8+EFh4RMc0ICMkLHBI+hKMdVzG8Q
         k9zAp35RheFMwbmOwjIZynE0dBOSChVxntRUjZyWqvaUG0YKu0umFjoVvkQmTzQ5Or13
         vyMXTNSfyy3YNhv5bqe/PawJXVZOqYDEi1rLl++JMCDlo343mo6eNenRw0Hnv0j11ssy
         9xh/o7k2j3dpIzLIp71Qq6CyA76t3P36J5Xr7kD3KPViO7ULHaNxUK/EvlyA7amPYRji
         zon9FvshwCZv6qyDFtWCieo+J8i/qcoTGDUZsmMYoBjfmC66ePwZZucyjKODHoNCsw/K
         nMbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date;
        bh=9OurSfaRscRJrc92d+EDlOtf1l62+mJ334cnIisu+nk=;
        b=5Oi8Ke6VpGMdxko4cONdS5w3WN5PNza1so1wSCzCupu7jA+mjy2VFboaRxduGtlSHi
         JeWNi62Ro0I7nlLDNTUlFvceueOSbME0UWLBPlRufiEB7cR22g3em+RqJiseFGJOYACe
         t1wGY44adHeac09tAE+6NXexS0cKsU3LvHJtZWODXtn+8tl+ja+U1Yu+rzWKADCd7/Z5
         Hq44ZLwljskiBO+zGv/fv0pwqJ4MJQ/+paqt1E6iAi4giqqO46fZRaaFgSSr6NZzrEen
         Nabf1VAgnLRUDR8QQNz3vjxJxEtY3WZWa6rF012f/dHk4EjMs6wjCtfw0KaUyG6DVpxp
         81Lg==
X-Gm-Message-State: ACgBeo3jQD81qj9z+dMGxan4cIHZhPOAZnlWNp1YduKkB4N0yj7KSSyn
        h8AVj1D1ULBJeE+svv+ubJo=
X-Google-Smtp-Source: AA6agR61hhqGDdCzw8IrLqL4EtyOO1Hyl38gTQwBIGzjCQLo0kZkiUy/nThoZC7R92tnYYPZICT6Dg==
X-Received: by 2002:a17:907:7252:b0:73f:c3e9:4197 with SMTP id ds18-20020a170907725200b0073fc3e94197mr2913163ejc.173.1662568595134;
        Wed, 07 Sep 2022 09:36:35 -0700 (PDT)
Received: from orome (p200300e41f12c800f22f74fffe1f3a53.dip0.t-ipconnect.de. [2003:e4:1f12:c800:f22f:74ff:fe1f:3a53])
        by smtp.gmail.com with ESMTPSA id gk3-20020a17090790c300b0076f0a723f6bsm2908108ejb.58.2022.09.07.09.36.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 09:36:34 -0700 (PDT)
Date:   Wed, 7 Sep 2022 18:36:31 +0200
From:   Thierry Reding <thierry.reding@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Jon Hunter <jonathanh@nvidia.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Bhadram Varka <vbhadram@nvidia.com>,
        devicetree@vger.kernel.org, linux-tegra@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v4 9/9] stmmac: tegra: Add MGBE support
Message-ID: <YxjIj1kr0mrdoWcd@orome>
References: <20220707074818.1481776-1-thierry.reding@gmail.com>
 <20220707074818.1481776-10-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="MDqb+EiWYBy486R+"
Content-Disposition: inline
In-Reply-To: <20220707074818.1481776-10-thierry.reding@gmail.com>
User-Agent: Mutt/2.2.7 (2022-08-07)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--MDqb+EiWYBy486R+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 07, 2022 at 09:48:18AM +0200, Thierry Reding wrote:
> From: Bhadram Varka <vbhadram@nvidia.com>
>=20
> Add support for the Multi-Gigabit Ethernet (MGBE/XPCS) IP found on
> NVIDIA Tegra234 SoCs.
>=20
> Signed-off-by: Bhadram Varka <vbhadram@nvidia.com>
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
> Note that this doesn't have any dependencies on any of the patches
> earlier in the series, so this can be applied independently.
>=20
>  drivers/net/ethernet/stmicro/stmmac/Kconfig   |   6 +
>  drivers/net/ethernet/stmicro/stmmac/Makefile  |   1 +
>  .../net/ethernet/stmicro/stmmac/dwmac-tegra.c | 290 ++++++++++++++++++
>  3 files changed, 297 insertions(+)
>  create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac-tegra.c

Patches 1-8 of this have already been applied to the Tegra tree. Are
there any more comments on this or can this be merged as well?

=46rom a Tegra point of view this looks good, so:

Acked-by: Thierry Reding <treding@nvidia.com>

>=20
> diff --git a/drivers/net/ethernet/stmicro/stmmac/Kconfig b/drivers/net/et=
hernet/stmicro/stmmac/Kconfig
> index 929cfc22cd0c..47af5a59ce88 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/Kconfig
> +++ b/drivers/net/ethernet/stmicro/stmmac/Kconfig
> @@ -232,6 +232,12 @@ config DWMAC_INTEL_PLAT
>  	  the stmmac device driver. This driver is used for the Intel Keem Bay
>  	  SoC.
> =20
> +config DWMAC_TEGRA
> +	tristate "NVIDIA Tegra MGBE support"
> +	depends on ARCH_TEGRA || COMPILE_TEST
> +	help
> +	  Support for the MGBE controller found on Tegra SoCs.
> +
>  config DWMAC_VISCONTI
>  	tristate "Toshiba Visconti DWMAC support"
>  	default ARCH_VISCONTI
> diff --git a/drivers/net/ethernet/stmicro/stmmac/Makefile b/drivers/net/e=
thernet/stmicro/stmmac/Makefile
> index d4e12e9ace4f..057e4bab5c08 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/Makefile
> +++ b/drivers/net/ethernet/stmicro/stmmac/Makefile
> @@ -31,6 +31,7 @@ obj-$(CONFIG_DWMAC_DWC_QOS_ETH)	+=3D dwmac-dwc-qos-eth.o
>  obj-$(CONFIG_DWMAC_INTEL_PLAT)	+=3D dwmac-intel-plat.o
>  obj-$(CONFIG_DWMAC_GENERIC)	+=3D dwmac-generic.o
>  obj-$(CONFIG_DWMAC_IMX8)	+=3D dwmac-imx.o
> +obj-$(CONFIG_DWMAC_TEGRA)	+=3D dwmac-tegra.o
>  obj-$(CONFIG_DWMAC_VISCONTI)	+=3D dwmac-visconti.o
>  stmmac-platform-objs:=3D stmmac_platform.o
>  dwmac-altr-socfpga-objs :=3D altr_tse_pcs.o dwmac-socfpga.o
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-tegra.c b/drivers/=
net/ethernet/stmicro/stmmac/dwmac-tegra.c
> new file mode 100644
> index 000000000000..bb4b540820fa
> --- /dev/null
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-tegra.c
> @@ -0,0 +1,290 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +#include <linux/platform_device.h>
> +#include <linux/of_device.h>
> +#include <linux/module.h>
> +#include <linux/stmmac.h>
> +#include <linux/clk.h>
> +
> +#include "stmmac_platform.h"
> +
> +static const char *const mgbe_clks[] =3D {
> +	"rx-pcs", "tx", "tx-pcs", "mac-divider", "mac", "mgbe", "ptp-ref", "mac"
> +};
> +
> +struct tegra_mgbe {
> +	struct device *dev;
> +
> +	struct clk_bulk_data *clks;
> +
> +	struct reset_control *rst_mac;
> +	struct reset_control *rst_pcs;
> +
> +	void __iomem *hv;
> +	void __iomem *regs;
> +	void __iomem *xpcs;
> +
> +	struct mii_bus *mii;
> +};
> +
> +#define XPCS_WRAP_UPHY_RX_CONTROL 0x801c
> +#define XPCS_WRAP_UPHY_RX_CONTROL_RX_SW_OVRD BIT(31)
> +#define XPCS_WRAP_UPHY_RX_CONTROL_RX_PCS_PHY_RDY BIT(10)
> +#define XPCS_WRAP_UPHY_RX_CONTROL_RX_CDR_RESET BIT(9)
> +#define XPCS_WRAP_UPHY_RX_CONTROL_RX_CAL_EN BIT(8)
> +#define XPCS_WRAP_UPHY_RX_CONTROL_RX_SLEEP (BIT(7) | BIT(6))
> +#define XPCS_WRAP_UPHY_RX_CONTROL_AUX_RX_IDDQ BIT(5)
> +#define XPCS_WRAP_UPHY_RX_CONTROL_RX_IDDQ BIT(4)
> +#define XPCS_WRAP_UPHY_RX_CONTROL_RX_DATA_EN BIT(0)
> +#define XPCS_WRAP_UPHY_HW_INIT_CTRL 0x8020
> +#define XPCS_WRAP_UPHY_HW_INIT_CTRL_TX_EN BIT(0)
> +#define XPCS_WRAP_UPHY_HW_INIT_CTRL_RX_EN BIT(2)
> +#define XPCS_WRAP_UPHY_STATUS 0x8044
> +#define XPCS_WRAP_UPHY_STATUS_TX_P_UP BIT(0)
> +#define XPCS_WRAP_IRQ_STATUS 0x8050
> +#define XPCS_WRAP_IRQ_STATUS_PCS_LINK_STS BIT(6)
> +
> +#define XPCS_REG_ADDR_SHIFT 10
> +#define XPCS_REG_ADDR_MASK 0x1fff
> +#define XPCS_ADDR 0x3fc
> +
> +#define MGBE_WRAP_COMMON_INTR_ENABLE	0x8704
> +#define MAC_SBD_INTR			BIT(2)
> +#define MGBE_WRAP_AXI_ASID0_CTRL	0x8400
> +#define MGBE_SID			0x6
> +
> +static void mgbe_uphy_lane_bringup(struct tegra_mgbe *mgbe)
> +{
> +	unsigned int retry =3D 300;
> +	u32 value;
> +	int err;
> +
> +	value =3D readl(mgbe->xpcs + XPCS_WRAP_UPHY_STATUS);
> +	if ((value & XPCS_WRAP_UPHY_STATUS_TX_P_UP) =3D=3D 0) {
> +		value =3D readl(mgbe->xpcs + XPCS_WRAP_UPHY_HW_INIT_CTRL);
> +		value |=3D XPCS_WRAP_UPHY_HW_INIT_CTRL_TX_EN;
> +		writel(value, mgbe->xpcs + XPCS_WRAP_UPHY_HW_INIT_CTRL);
> +	}
> +
> +	err =3D readl_poll_timeout(mgbe->xpcs + XPCS_WRAP_UPHY_HW_INIT_CTRL, va=
lue,
> +				 (value & XPCS_WRAP_UPHY_HW_INIT_CTRL_TX_EN) =3D=3D 0,
> +				 500, 500 * 2000);
> +	if (err < 0)
> +		dev_err(mgbe->dev, "timeout waiting for TX lane to become enabled\n");
> +
> +	usleep_range(10000, 20000);
> +
> +	value =3D readl(mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
> +	value |=3D XPCS_WRAP_UPHY_RX_CONTROL_RX_SW_OVRD;
> +	writel(value, mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
> +
> +	value =3D readl(mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
> +	value &=3D ~XPCS_WRAP_UPHY_RX_CONTROL_RX_IDDQ;
> +	writel(value, mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
> +
> +	value =3D readl(mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
> +	value &=3D ~XPCS_WRAP_UPHY_RX_CONTROL_AUX_RX_IDDQ;
> +	writel(value, mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
> +
> +	value =3D readl(mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
> +	value &=3D ~XPCS_WRAP_UPHY_RX_CONTROL_RX_SLEEP;
> +	writel(value, mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
> +
> +	value =3D readl(mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
> +	value |=3D XPCS_WRAP_UPHY_RX_CONTROL_RX_CAL_EN;
> +	writel(value, mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
> +
> +	err =3D readl_poll_timeout(mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL, valu=
e,
> +				 (value & XPCS_WRAP_UPHY_RX_CONTROL_RX_CAL_EN) =3D=3D 0,
> +				 1000, 1000 * 2000);
> +	if (err < 0)
> +		dev_err(mgbe->dev, "timeout waiting for RX calibration to become enabl=
ed\n");
> +
> +	value =3D readl(mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
> +	value |=3D XPCS_WRAP_UPHY_RX_CONTROL_RX_DATA_EN;
> +	writel(value, mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
> +
> +	value =3D readl(mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
> +	value |=3D XPCS_WRAP_UPHY_RX_CONTROL_RX_CDR_RESET;
> +	writel(value, mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
> +
> +	value =3D readl(mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
> +	value &=3D ~XPCS_WRAP_UPHY_RX_CONTROL_RX_CDR_RESET;
> +	writel(value, mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
> +
> +	value =3D readl(mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
> +	value |=3D XPCS_WRAP_UPHY_RX_CONTROL_RX_PCS_PHY_RDY;
> +	writel(value, mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
> +
> +	while (--retry) {
> +		err =3D readl_poll_timeout(mgbe->xpcs + XPCS_WRAP_IRQ_STATUS, value,
> +					 value & XPCS_WRAP_IRQ_STATUS_PCS_LINK_STS,
> +					 500, 500 * 2000);
> +		if (err < 0) {
> +			dev_err(mgbe->dev, "timeout waiting for link to become ready\n");
> +			usleep_range(10000, 20000);
> +			continue;
> +		}
> +		break;
> +	}
> +
> +	/* clear status */
> +	writel(value, mgbe->xpcs + XPCS_WRAP_IRQ_STATUS);
> +}
> +
> +static int tegra_mgbe_probe(struct platform_device *pdev)
> +{
> +	struct plat_stmmacenet_data *plat;
> +	struct stmmac_resources res;
> +	struct tegra_mgbe *mgbe;
> +	int irq, err, i;
> +
> +	mgbe =3D devm_kzalloc(&pdev->dev, sizeof(*mgbe), GFP_KERNEL);
> +	if (!mgbe)
> +		return -ENOMEM;
> +
> +	mgbe->dev =3D &pdev->dev;
> +
> +	memset(&res, 0, sizeof(res));
> +
> +	irq =3D platform_get_irq(pdev, 0);
> +	if (irq < 0)
> +		return irq;
> +
> +	mgbe->hv =3D devm_platform_ioremap_resource_byname(pdev, "hypervisor");
> +	if (IS_ERR(mgbe->hv))
> +		return PTR_ERR(mgbe->hv);
> +
> +	mgbe->regs =3D devm_platform_ioremap_resource_byname(pdev, "mac");
> +	if (IS_ERR(mgbe->regs))
> +		return PTR_ERR(mgbe->regs);
> +
> +	mgbe->xpcs =3D devm_platform_ioremap_resource_byname(pdev, "xpcs");
> +	if (IS_ERR(mgbe->xpcs))
> +		return PTR_ERR(mgbe->xpcs);
> +
> +	res.addr =3D mgbe->regs;
> +	res.irq =3D irq;
> +
> +	mgbe->clks =3D devm_kzalloc(&pdev->dev, sizeof(*mgbe->clks), GFP_KERNEL=
);
> +	if (!mgbe->clks)
> +		return -ENOMEM;
> +
> +	for (i =3D 0; i <  ARRAY_SIZE(mgbe_clks); i++)
> +		mgbe->clks[i].id =3D mgbe_clks[i];
> +
> +	err =3D devm_clk_bulk_get(mgbe->dev, ARRAY_SIZE(mgbe_clks), mgbe->clks);
> +	if (err < 0)
> +		return err;
> +
> +	err =3D clk_bulk_prepare_enable(ARRAY_SIZE(mgbe_clks), mgbe->clks);
> +	if (err < 0)
> +		return err;
> +
> +	/* Perform MAC reset */
> +	mgbe->rst_mac =3D devm_reset_control_get(&pdev->dev, "mac");
> +	if (IS_ERR(mgbe->rst_mac))
> +		return PTR_ERR(mgbe->rst_mac);
> +
> +	err =3D reset_control_assert(mgbe->rst_mac);
> +	if (err < 0)
> +		return err;
> +
> +	usleep_range(2000, 4000);
> +
> +	err =3D reset_control_deassert(mgbe->rst_mac);
> +	if (err < 0)
> +		return err;
> +
> +	/* Perform PCS reset */
> +	mgbe->rst_pcs =3D devm_reset_control_get(&pdev->dev, "pcs");
> +	if (IS_ERR(mgbe->rst_pcs))
> +		return PTR_ERR(mgbe->rst_pcs);
> +
> +	err =3D reset_control_assert(mgbe->rst_pcs);
> +	if (err < 0)
> +		return err;
> +
> +	usleep_range(2000, 4000);
> +
> +	err =3D reset_control_deassert(mgbe->rst_pcs);
> +	if (err < 0)
> +		return err;
> +
> +	plat =3D stmmac_probe_config_dt(pdev, res.mac);
> +	if (IS_ERR(plat))
> +		return PTR_ERR(plat);
> +
> +	plat->has_xgmac =3D 1;
> +	plat->tso_en =3D 1;
> +	plat->pmt =3D 1;
> +	plat->bsp_priv =3D mgbe;
> +
> +	if (!plat->mdio_node)
> +		plat->mdio_node =3D of_get_child_by_name(pdev->dev.of_node, "mdio");
> +
> +	if (!plat->mdio_bus_data) {
> +		plat->mdio_bus_data =3D devm_kzalloc(&pdev->dev, sizeof(*plat->mdio_bu=
s_data),
> +						   GFP_KERNEL);
> +		if (!plat->mdio_bus_data) {
> +			err =3D -ENOMEM;
> +			goto remove;
> +		}
> +	}
> +
> +	plat->mdio_bus_data->needs_reset =3D true;
> +
> +	mgbe_uphy_lane_bringup(mgbe);
> +
> +	/* Tx FIFO Size - 128KB */
> +	plat->tx_fifo_size =3D 131072;
> +	/* Rx FIFO Size - 192KB */
> +	plat->rx_fifo_size =3D 196608;
> +
> +	/* Enable common interrupt at wrapper level */
> +	writel(MAC_SBD_INTR, mgbe->regs + MGBE_WRAP_COMMON_INTR_ENABLE);
> +
> +	/* Program SID */
> +	writel(MGBE_SID, mgbe->hv + MGBE_WRAP_AXI_ASID0_CTRL);
> +
> +	err =3D stmmac_dvr_probe(&pdev->dev, plat, &res);
> +	if (err < 0)
> +		goto remove;
> +
> +	return 0;
> +
> +remove:
> +	stmmac_remove_config_dt(pdev, plat);
> +	return err;
> +}
> +
> +static int tegra_mgbe_remove(struct platform_device *pdev)
> +{
> +	struct tegra_mgbe *mgbe =3D get_stmmac_bsp_priv(&pdev->dev);
> +
> +	clk_bulk_disable_unprepare(ARRAY_SIZE(mgbe_clks), mgbe->clks);
> +
> +	stmmac_pltfr_remove(pdev);
> +
> +	return 0;
> +}
> +
> +static const struct of_device_id tegra_mgbe_match[] =3D {
> +	{ .compatible =3D "nvidia,tegra234-mgbe", },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(of, tegra_mgbe_match);
> +
> +static struct platform_driver tegra_mgbe_driver =3D {
> +	.probe =3D tegra_mgbe_probe,
> +	.remove =3D tegra_mgbe_remove,
> +	.driver =3D {
> +		.name =3D "tegra-mgbe",
> +		.pm		=3D &stmmac_pltfr_pm_ops,
> +		.of_match_table =3D tegra_mgbe_match,
> +	},
> +};
> +module_platform_driver(tegra_mgbe_driver);
> +
> +MODULE_AUTHOR("Thierry Reding <treding@nvidia.com>");
> +MODULE_DESCRIPTION("NVIDIA Tegra MGBE driver");
> +MODULE_LICENSE("GPL");
> --=20
> 2.36.1
>=20

--MDqb+EiWYBy486R+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmMYyI0ACgkQ3SOs138+
s6Hr3xAAkcqPr9vDCTLr00gBWfbUjRr9+vGbWbkvGj/qUSLwnP6LEtmdhPCCCh3a
eyXEerHo0oAxk+aBw+eo5AKBArBsVhr6qx8czxUJdi1gFxrsIjvO2nzxMW8r0tJU
w2N9RqmzSraRBJb8NXHxWQN4Qxmd/1dh1Zfjmziv1TDzX746ozuzcnf/YPjBjr2p
KYLuGM+wHchDG1ADIwEpc1GXHUNwmRfYTfDrEWy4b9VN2ENWflyc32Wo1yVe+EVy
1c3cMwzcS6zb/klCdIARYHGwPDqON5nT3ZrTre0fWvubq6U0FnJLmppiqO8+18fK
LG1WWted0JPXbh3SfxC00IbpJmXogTuQJVqDdJwsfhNE8+iavxPwK3M2k7+zKCC4
2ofmdNxhTAdiYfFjNH3xFHCKJeUDftseXNS2/NDWS3aoTAf8dWMQdfoo6XEf26mK
3XgUaPh50kBnuykNbvAnqw6RykBZc7YS4IBowj/DTqSoBdMKXKE3wKg/vIdRbLg/
IyiqWLlcvatThtEWeuhIiI0pMnBdE70vZZNOfMjuAJTcII9sGMkXw2omYp6DJnWk
9pC09l5J0RiGjQaEjqRLLDTUXRVUZzVG4DGua4ZBJUycfRbto43SgiIsvEw5Fp0R
wC5lWESnzZjKYNteeCbxu3OQLS4Z2t8Ow6lfvxRsdeWAS38j8e8=
=7xhX
-----END PGP SIGNATURE-----

--MDqb+EiWYBy486R+--
