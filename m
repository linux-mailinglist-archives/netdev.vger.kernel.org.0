Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5BB45EC7CD
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 17:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231725AbiI0Pd0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 11:33:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231143AbiI0PdZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 11:33:25 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B5A41C26CF;
        Tue, 27 Sep 2022 08:33:20 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id z13-20020a7bc7cd000000b003b5054c6f9bso9159534wmk.2;
        Tue, 27 Sep 2022 08:33:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date;
        bh=ZEFfqlwxn2rpN055jt7PPyRAVPbD90VZJc3Ef+UmG0k=;
        b=CBI+taBFWyNjydO2srEeoQ8xxjzc8ZUpzo7XRp88uW4IWHAKzZLDxTRw6Ul4uVs8e3
         Go5L/RItjn7oQCPv1Ulf5KZXEtuS1sLRzq9wJN51NIiwbk5By2XsLtWp214SiU/AxWVX
         ee9Z70S4DX+GaH9QpdZst9iq28duBi0laYw/IniIiLWw2m42wPSJ9INSb3O0oqPEJUPs
         ybK3ipjWYf5JesLdEhxyZyqnNAMr7G6x5MWR3jx8mMDrR+Cy0DxdktLwkuDl3/e456gu
         OfuimRoXtohuslBxyEEDG5j+URjEqz/rXgGmDVMV+c3hMoQ60KZIxcMy32aZIB0QQhF2
         o9Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date;
        bh=ZEFfqlwxn2rpN055jt7PPyRAVPbD90VZJc3Ef+UmG0k=;
        b=ByuJq07YX1rUuU2l1pFMOq6uiS0IfbUj3o3fj3EWXKVr+SKaIFWd0Vj9jn4lB55ExX
         dxGF9Khrxe0ERzr7XpP0dB7XBxFDypdurEEhpZ6vu1oSue8HJ3GwstEp51rGPXxSuzky
         zKOpIUPRgj6t5GrmWOIjDrHHiuv749VLHRoTzTmYcU339pujgVphn4kMMi3Wk/4KqZyv
         0vrtWsYCPmOB325rMakmTTUjyIzR+mG0ZFM9ShxhyvPnl9UG935QVLckKvrYzCHKJxN5
         awVMuPB4wo0OdsEjOzOeKqEcz/RlEi8h2gY49G+9rH3oV0HJLzT2i5H2tFGBfXxTSKOD
         rqdg==
X-Gm-Message-State: ACrzQf2l+jICdS0qQMNAb3r6JiKhbhVyNJLUwa/2y2qmR1iNVJqz493b
        2EqBX8n9N5Yh1ozbEwt4jIU=
X-Google-Smtp-Source: AMsMyM4x/+6iWKdOIuEi/sYXZKsls/LlDSPmFeyDepmsuTVsrlN4+K6/rAe8JkeAjiQWTBxkUAcJGA==
X-Received: by 2002:a05:600c:1d28:b0:3b4:91f9:aeb8 with SMTP id l40-20020a05600c1d2800b003b491f9aeb8mr3174357wms.136.1664292798904;
        Tue, 27 Sep 2022 08:33:18 -0700 (PDT)
Received: from orome (p200300e41f201d00f22f74fffe1f3a53.dip0.t-ipconnect.de. [2003:e4:1f20:1d00:f22f:74ff:fe1f:3a53])
        by smtp.gmail.com with ESMTPSA id k15-20020adfd22f000000b0021badf3cb26sm1523798wrh.63.2022.09.27.08.33.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 08:33:18 -0700 (PDT)
Date:   Tue, 27 Sep 2022 17:33:16 +0200
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Paolo Abeni <pabeni@redhat.com>,
        Bhadram Varka <vbhadram@nvidia.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jon Hunter <jonathanh@nvidia.com>, linux-tegra@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v4 RESEND] stmmac: tegra: Add MGBE support
Message-ID: <YzMXvJd7oJSdsdHe@orome>
References: <20220923114922.864552-1-thierry.reding@gmail.com>
 <b9c159dea84b98acc5d5078338723f7f1585e39e.camel@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="G0NeLVxfQ5CWlgG7"
Content-Disposition: inline
In-Reply-To: <b9c159dea84b98acc5d5078338723f7f1585e39e.camel@redhat.com>
User-Agent: Mutt/2.2.7 (2022-08-07)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--G0NeLVxfQ5CWlgG7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 27, 2022 at 11:29:32AM +0200, Paolo Abeni wrote:
> On Fri, 2022-09-23 at 13:49 +0200, Thierry Reding wrote:
> > From: Bhadram Varka <vbhadram@nvidia.com>
> >=20
> > Add support for the Multi-Gigabit Ethernet (MGBE/XPCS) IP found on
> > NVIDIA Tegra234 SoCs.
> >=20
> > Signed-off-by: Bhadram Varka <vbhadram@nvidia.com>
> > Signed-off-by: Thierry Reding <treding@nvidia.com>
> > ---
> >  drivers/net/ethernet/stmicro/stmmac/Kconfig   |   6 +
> >  drivers/net/ethernet/stmicro/stmmac/Makefile  |   1 +
> >  .../net/ethernet/stmicro/stmmac/dwmac-tegra.c | 290 ++++++++++++++++++
> >  3 files changed, 297 insertions(+)
> >  create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac-tegra.c
> >=20
> > diff --git a/drivers/net/ethernet/stmicro/stmmac/Kconfig b/drivers/net/=
ethernet/stmicro/stmmac/Kconfig
> > index 31ff35174034..e9f61bdaf7c4 100644
> > --- a/drivers/net/ethernet/stmicro/stmmac/Kconfig
> > +++ b/drivers/net/ethernet/stmicro/stmmac/Kconfig
> > @@ -235,6 +235,12 @@ config DWMAC_INTEL_PLAT
> >  	  the stmmac device driver. This driver is used for the Intel Keem Bay
> >  	  SoC.
> > =20
> > +config DWMAC_TEGRA
> > +	tristate "NVIDIA Tegra MGBE support"
> > +	depends on ARCH_TEGRA || COMPILE_TEST
> > +	help
> > +	  Support for the MGBE controller found on Tegra SoCs.
> > +
> >  config DWMAC_VISCONTI
> >  	tristate "Toshiba Visconti DWMAC support"
> >  	default ARCH_VISCONTI
> > diff --git a/drivers/net/ethernet/stmicro/stmmac/Makefile b/drivers/net=
/ethernet/stmicro/stmmac/Makefile
> > index d4e12e9ace4f..057e4bab5c08 100644
> > --- a/drivers/net/ethernet/stmicro/stmmac/Makefile
> > +++ b/drivers/net/ethernet/stmicro/stmmac/Makefile
> > @@ -31,6 +31,7 @@ obj-$(CONFIG_DWMAC_DWC_QOS_ETH)	+=3D dwmac-dwc-qos-et=
h.o
> >  obj-$(CONFIG_DWMAC_INTEL_PLAT)	+=3D dwmac-intel-plat.o
> >  obj-$(CONFIG_DWMAC_GENERIC)	+=3D dwmac-generic.o
> >  obj-$(CONFIG_DWMAC_IMX8)	+=3D dwmac-imx.o
> > +obj-$(CONFIG_DWMAC_TEGRA)	+=3D dwmac-tegra.o
> >  obj-$(CONFIG_DWMAC_VISCONTI)	+=3D dwmac-visconti.o
> >  stmmac-platform-objs:=3D stmmac_platform.o
> >  dwmac-altr-socfpga-objs :=3D altr_tse_pcs.o dwmac-socfpga.o
> > diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-tegra.c b/driver=
s/net/ethernet/stmicro/stmmac/dwmac-tegra.c
> > new file mode 100644
> > index 000000000000..bb4b540820fa
> > --- /dev/null
> > +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-tegra.c
> > @@ -0,0 +1,290 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +#include <linux/platform_device.h>
> > +#include <linux/of_device.h>
> > +#include <linux/module.h>
> > +#include <linux/stmmac.h>
> > +#include <linux/clk.h>
> > +
> > +#include "stmmac_platform.h"
> > +
> > +static const char *const mgbe_clks[] =3D {
> > +	"rx-pcs", "tx", "tx-pcs", "mac-divider", "mac", "mgbe", "ptp-ref", "m=
ac"
> > +};
> > +
> > +struct tegra_mgbe {
> > +	struct device *dev;
> > +
> > +	struct clk_bulk_data *clks;
> > +
> > +	struct reset_control *rst_mac;
> > +	struct reset_control *rst_pcs;
> > +
> > +	void __iomem *hv;
> > +	void __iomem *regs;
> > +	void __iomem *xpcs;
> > +
> > +	struct mii_bus *mii;
> > +};
> > +
> > +#define XPCS_WRAP_UPHY_RX_CONTROL 0x801c
> > +#define XPCS_WRAP_UPHY_RX_CONTROL_RX_SW_OVRD BIT(31)
> > +#define XPCS_WRAP_UPHY_RX_CONTROL_RX_PCS_PHY_RDY BIT(10)
> > +#define XPCS_WRAP_UPHY_RX_CONTROL_RX_CDR_RESET BIT(9)
> > +#define XPCS_WRAP_UPHY_RX_CONTROL_RX_CAL_EN BIT(8)
> > +#define XPCS_WRAP_UPHY_RX_CONTROL_RX_SLEEP (BIT(7) | BIT(6))
> > +#define XPCS_WRAP_UPHY_RX_CONTROL_AUX_RX_IDDQ BIT(5)
> > +#define XPCS_WRAP_UPHY_RX_CONTROL_RX_IDDQ BIT(4)
> > +#define XPCS_WRAP_UPHY_RX_CONTROL_RX_DATA_EN BIT(0)
> > +#define XPCS_WRAP_UPHY_HW_INIT_CTRL 0x8020
> > +#define XPCS_WRAP_UPHY_HW_INIT_CTRL_TX_EN BIT(0)
> > +#define XPCS_WRAP_UPHY_HW_INIT_CTRL_RX_EN BIT(2)
> > +#define XPCS_WRAP_UPHY_STATUS 0x8044
> > +#define XPCS_WRAP_UPHY_STATUS_TX_P_UP BIT(0)
> > +#define XPCS_WRAP_IRQ_STATUS 0x8050
> > +#define XPCS_WRAP_IRQ_STATUS_PCS_LINK_STS BIT(6)
> > +
> > +#define XPCS_REG_ADDR_SHIFT 10
> > +#define XPCS_REG_ADDR_MASK 0x1fff
> > +#define XPCS_ADDR 0x3fc
> > +
> > +#define MGBE_WRAP_COMMON_INTR_ENABLE	0x8704
> > +#define MAC_SBD_INTR			BIT(2)
> > +#define MGBE_WRAP_AXI_ASID0_CTRL	0x8400
> > +#define MGBE_SID			0x6
> > +
> > +static void mgbe_uphy_lane_bringup(struct tegra_mgbe *mgbe)
> > +{
> > +	unsigned int retry =3D 300;
> > +	u32 value;
> > +	int err;
> > +
> > +	value =3D readl(mgbe->xpcs + XPCS_WRAP_UPHY_STATUS);
> > +	if ((value & XPCS_WRAP_UPHY_STATUS_TX_P_UP) =3D=3D 0) {
> > +		value =3D readl(mgbe->xpcs + XPCS_WRAP_UPHY_HW_INIT_CTRL);
> > +		value |=3D XPCS_WRAP_UPHY_HW_INIT_CTRL_TX_EN;
> > +		writel(value, mgbe->xpcs + XPCS_WRAP_UPHY_HW_INIT_CTRL);
> > +	}
> > +
> > +	err =3D readl_poll_timeout(mgbe->xpcs + XPCS_WRAP_UPHY_HW_INIT_CTRL, =
value,
> > +				 (value & XPCS_WRAP_UPHY_HW_INIT_CTRL_TX_EN) =3D=3D 0,
> > +				 500, 500 * 2000);
> > +	if (err < 0)
> > +		dev_err(mgbe->dev, "timeout waiting for TX lane to become enabled\n"=
);
>=20
> Why you don't need to propagate this error to the caller?
>=20
> Same question for more error cases below.

I suspect that we can simply propagate the error in these cases. We
never run into these issues in practice, so it went unnoticed.

>=20
> > +
> > +	usleep_range(10000, 20000);
> > +
> > +	value =3D readl(mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
> > +	value |=3D XPCS_WRAP_UPHY_RX_CONTROL_RX_SW_OVRD;
> > +	writel(value, mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
> > +
> > +	value =3D readl(mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
> > +	value &=3D ~XPCS_WRAP_UPHY_RX_CONTROL_RX_IDDQ;
> > +	writel(value, mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
> > +
> > +	value =3D readl(mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
> > +	value &=3D ~XPCS_WRAP_UPHY_RX_CONTROL_AUX_RX_IDDQ;
> > +	writel(value, mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
> > +
> > +	value =3D readl(mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
> > +	value &=3D ~XPCS_WRAP_UPHY_RX_CONTROL_RX_SLEEP;
> > +	writel(value, mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
> > +
> > +	value =3D readl(mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
> > +	value |=3D XPCS_WRAP_UPHY_RX_CONTROL_RX_CAL_EN;
> > +	writel(value, mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
> > +
> > +	err =3D readl_poll_timeout(mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL, va=
lue,
> > +				 (value & XPCS_WRAP_UPHY_RX_CONTROL_RX_CAL_EN) =3D=3D 0,
> > +				 1000, 1000 * 2000);
> > +	if (err < 0)
> > +		dev_err(mgbe->dev, "timeout waiting for RX calibration to become ena=
bled\n");
> > +
> > +	value =3D readl(mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
> > +	value |=3D XPCS_WRAP_UPHY_RX_CONTROL_RX_DATA_EN;
> > +	writel(value, mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
> > +
> > +	value =3D readl(mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
> > +	value |=3D XPCS_WRAP_UPHY_RX_CONTROL_RX_CDR_RESET;
> > +	writel(value, mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
> > +
> > +	value =3D readl(mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
> > +	value &=3D ~XPCS_WRAP_UPHY_RX_CONTROL_RX_CDR_RESET;
> > +	writel(value, mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
> > +
> > +	value =3D readl(mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
> > +	value |=3D XPCS_WRAP_UPHY_RX_CONTROL_RX_PCS_PHY_RDY;
> > +	writel(value, mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
> > +
> > +	while (--retry) {
> > +		err =3D readl_poll_timeout(mgbe->xpcs + XPCS_WRAP_IRQ_STATUS, value,
> > +					 value & XPCS_WRAP_IRQ_STATUS_PCS_LINK_STS,
> > +					 500, 500 * 2000);
> > +		if (err < 0) {
> > +			dev_err(mgbe->dev, "timeout waiting for link to become ready\n");
> > +			usleep_range(10000, 20000);
> > +			continue;
> > +		}
> > +		break;
> > +	}
>=20
> It looks like the above loop can take up to 150 seconds (300
> iterations, 500000usec each), can it be shortned?

This is likely left-over from debugging. It might be possible to get rid
of the loop altogether and just use the built-in retry mechanism from
readl_poll_timeout().

Bhadram, do you have any concerns with removing the outer while loop
here? In your experience, if the link doesn't become ready within the 1
second timeout of the readl_poll_timeout() call, is it at all likely to
succeed subsequently or can we safely assume that something has gone
wrong?

>=20
> > +
> > +	/* clear status */
> > +	writel(value, mgbe->xpcs + XPCS_WRAP_IRQ_STATUS);
> > +}
> > +
> > +static int tegra_mgbe_probe(struct platform_device *pdev)
> > +{
> > +	struct plat_stmmacenet_data *plat;
> > +	struct stmmac_resources res;
> > +	struct tegra_mgbe *mgbe;
> > +	int irq, err, i;
> > +
> > +	mgbe =3D devm_kzalloc(&pdev->dev, sizeof(*mgbe), GFP_KERNEL);
> > +	if (!mgbe)
> > +		return -ENOMEM;
> > +
> > +	mgbe->dev =3D &pdev->dev;
> > +
> > +	memset(&res, 0, sizeof(res));
> > +
> > +	irq =3D platform_get_irq(pdev, 0);
> > +	if (irq < 0)
> > +		return irq;
> > +
> > +	mgbe->hv =3D devm_platform_ioremap_resource_byname(pdev, "hypervisor"=
);
> > +	if (IS_ERR(mgbe->hv))
> > +		return PTR_ERR(mgbe->hv);
> > +
> > +	mgbe->regs =3D devm_platform_ioremap_resource_byname(pdev, "mac");
> > +	if (IS_ERR(mgbe->regs))
> > +		return PTR_ERR(mgbe->regs);
> > +
> > +	mgbe->xpcs =3D devm_platform_ioremap_resource_byname(pdev, "xpcs");
> > +	if (IS_ERR(mgbe->xpcs))
> > +		return PTR_ERR(mgbe->xpcs);
> > +
> > +	res.addr =3D mgbe->regs;
> > +	res.irq =3D irq;
> > +
> > +	mgbe->clks =3D devm_kzalloc(&pdev->dev, sizeof(*mgbe->clks), GFP_KERN=
EL);
> > +	if (!mgbe->clks)
> > +		return -ENOMEM;
> > +
> > +	for (i =3D 0; i <  ARRAY_SIZE(mgbe_clks); i++)
> > +		mgbe->clks[i].id =3D mgbe_clks[i];
> > +
> > +	err =3D devm_clk_bulk_get(mgbe->dev, ARRAY_SIZE(mgbe_clks), mgbe->clk=
s);
> > +	if (err < 0)
> > +		return err;
> > +
> > +	err =3D clk_bulk_prepare_enable(ARRAY_SIZE(mgbe_clks), mgbe->clks);
> > +	if (err < 0)
> > +		return err;
> > +
> > +	/* Perform MAC reset */
> > +	mgbe->rst_mac =3D devm_reset_control_get(&pdev->dev, "mac");
> > +	if (IS_ERR(mgbe->rst_mac))
> > +		return PTR_ERR(mgbe->rst_mac);
> > +
> > +	err =3D reset_control_assert(mgbe->rst_mac);
> > +	if (err < 0)
> > +		return err;
> > +
> > +	usleep_range(2000, 4000);
> > +
> > +	err =3D reset_control_deassert(mgbe->rst_mac);
> > +	if (err < 0)
> > +		return err;
> > +
> > +	/* Perform PCS reset */
> > +	mgbe->rst_pcs =3D devm_reset_control_get(&pdev->dev, "pcs");
> > +	if (IS_ERR(mgbe->rst_pcs))
> > +		return PTR_ERR(mgbe->rst_pcs);
> > +
> > +	err =3D reset_control_assert(mgbe->rst_pcs);
> > +	if (err < 0)
> > +		return err;
> > +
> > +	usleep_range(2000, 4000);
> > +
> > +	err =3D reset_control_deassert(mgbe->rst_pcs);
> > +	if (err < 0)
> > +		return err;
> > +
> > +	plat =3D stmmac_probe_config_dt(pdev, res.mac);
> > +	if (IS_ERR(plat))
> > +		return PTR_ERR(plat);
> > +
> > +	plat->has_xgmac =3D 1;
> > +	plat->tso_en =3D 1;
> > +	plat->pmt =3D 1;
> > +	plat->bsp_priv =3D mgbe;
> > +
> > +	if (!plat->mdio_node)
> > +		plat->mdio_node =3D of_get_child_by_name(pdev->dev.of_node, "mdio");
> > +
> > +	if (!plat->mdio_bus_data) {
> > +		plat->mdio_bus_data =3D devm_kzalloc(&pdev->dev, sizeof(*plat->mdio_=
bus_data),
> > +						   GFP_KERNEL);
> > +		if (!plat->mdio_bus_data) {
> > +			err =3D -ENOMEM;
> > +			goto remove;
> > +		}
> > +	}
> > +
> > +	plat->mdio_bus_data->needs_reset =3D true;
> > +
> > +	mgbe_uphy_lane_bringup(mgbe);
> > +
> > +	/* Tx FIFO Size - 128KB */
> > +	plat->tx_fifo_size =3D 131072;
> > +	/* Rx FIFO Size - 192KB */
> > +	plat->rx_fifo_size =3D 196608;
> > +
> > +	/* Enable common interrupt at wrapper level */
> > +	writel(MAC_SBD_INTR, mgbe->regs + MGBE_WRAP_COMMON_INTR_ENABLE);
> > +
> > +	/* Program SID */
> > +	writel(MGBE_SID, mgbe->hv + MGBE_WRAP_AXI_ASID0_CTRL);
> > +
> > +	err =3D stmmac_dvr_probe(&pdev->dev, plat, &res);
> > +	if (err < 0)
> > +		goto remove;
> > +
> > +	return 0;
> > +
> > +remove:
> > +	stmmac_remove_config_dt(pdev, plat);
> > +	return err;
> > +}
> > +
> > +static int tegra_mgbe_remove(struct platform_device *pdev)
> > +{
> > +	struct tegra_mgbe *mgbe =3D get_stmmac_bsp_priv(&pdev->dev);
> > +
> > +	clk_bulk_disable_unprepare(ARRAY_SIZE(mgbe_clks), mgbe->clks);
> > +
> > +	stmmac_pltfr_remove(pdev);
> > +
> > +	return 0;
> > +}
> > +
> > +static const struct of_device_id tegra_mgbe_match[] =3D {
> > +	{ .compatible =3D "nvidia,tegra234-mgbe", },
> > +	{ }
> > +};
> > +MODULE_DEVICE_TABLE(of, tegra_mgbe_match);
>=20
> The DT bindings will land in 6.1, right?

Yes, the DT bindings and the device tree changes for Jetson AGX Orin
are currently targetted for 6.1.

Thierry

--G0NeLVxfQ5CWlgG7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmMzF7kACgkQ3SOs138+
s6GS6w/6A1P2w8GwTlxAdl1Twkxz8blqQZRAhlm6XcPDeT7Pk3FZ9kvpfhDcxP+0
DSR1mDedZhFNk2YYyVdWNBaVfgnDMCwk9cRA7Qdgm8Q1zo4yJ3SXkcH9y/N0vrsc
EuNL3D9fHUWurfSV17cZvlLW4s5imT5jS59f0AuMCSewk89+pH9lEZ5VYLAVmJJm
2pNygVo7SDKrmwJt+yMFvdfheMsGH+JYyW/vuul8D85/48oZAiJfzZxxX8E5kzUq
pCTXOnhKq31OeiERqyNhlrFFSh80w4TRuNB2Gv2PrNq83URtnBld39NjsUpunY4o
ase/GSEnalVOFmhwSYwICm+46P73zET824YZ/G5TqiiZ0oWSpdHy9bz2XqRgmNXA
lGCun+mswhGoyM7XXSnguexCON808T+UsqO8phTW/ofXLx6mzWZKAazey9N928gX
TTwUiFdka1bucTS0auNc08Lm0iwyiMwoHhwO0KqRhr7IWfu+5bvtm8M5niV9UyN9
g2L5lwY9USWdDiqqTd9+sIsXjXA4fLWUjER3JdFrqzSbr9b8SLAuo4jRW0gVVKxF
8IGeg3YOrrV5NQIzu2gYTKl1qzvdUnSGGEmiEzorVIMnC3CHpPWoU4SRRcgC0NIe
UYNQ2P4kbWxmyrbpUqPxBAEL3Aq9rMkVX1PTOQ65/6sblcXhtSs=
=kGI5
-----END PGP SIGNATURE-----

--G0NeLVxfQ5CWlgG7--
