Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51F873CEDBE
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 22:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386842AbhGSTkx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 15:40:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383394AbhGSRyJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 13:54:09 -0400
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [IPv6:2001:67c:2050::465:202])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73A04C0610D2
        for <netdev@vger.kernel.org>; Mon, 19 Jul 2021 11:17:15 -0700 (PDT)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [80.241.60.241])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4GT9Q621XGzQjmg;
        Mon, 19 Jul 2021 20:30:38 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hauke-m.de; s=MBO0001;
        t=1626719436;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZuL9jTWE4YiZgGKkF8y7MYF/Av8wSMuSBoXCUyu4x1A=;
        b=Y2sjtO6eZ5khZJuNFoXSUc7DVBJkUk+bR/BbQGnwnXDNRAxFCBC0qd/B4RXXkbuZpHx1yN
        9GlQLNb1t5ZtG10K4kAmnQpG0cplWAblDH08EIXRZYfLEkMauv0hUdjMLPjWveE8NaUbVL
        0NxzeShhQv9kR6JTjFPL8xiWZGvmn5aYiPDEJil07sW7jIOluKdF3rxatd1FdHlo9KuJ8/
        P97eNsVOjscoEJlP8DPnTAyt/lJcVnkAr9ZUf9R1LwxqWzH/V1+CxOrq6xbMAVc7DK+Chn
        +ETcz55OUEHYW6W+9yLyQK2KuXOv0JhNR/oiW+VZ9vIe/+HAzkwpPACsAsvSig==
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter02.heinlein-hosting.de (spamfilter02.heinlein-hosting.de [80.241.56.116]) (amavisd-new, port 10030)
        with ESMTP id OfsJ2DLqQep5; Mon, 19 Jul 2021 20:30:33 +0200 (CEST)
Subject: Re: [PATCH v6 2/2] net: phy: add Maxlinear GPY115/21x/24x driver
To:     Xu Liang <lxu@maxlinear.com>, andrew@lunn.ch, hkallweit1@gmail.com,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        vee.khee.wong@linux.intel.com
Cc:     linux@armlinux.org.uk, hmehrtens@maxlinear.com,
        tmohren@maxlinear.com, mohammad.athari.ismail@intel.com
References: <20210719053212.11244-1-lxu@maxlinear.com>
 <20210719053212.11244-2-lxu@maxlinear.com>
From:   Hauke Mehrtens <hauke@hauke-m.de>
Message-ID: <6fa2e54f-c192-971b-b1c3-0ff81f800351@hauke-m.de>
Date:   Mon, 19 Jul 2021 20:30:30 +0200
MIME-Version: 1.0
In-Reply-To: <20210719053212.11244-2-lxu@maxlinear.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C44821833
X-Rspamd-UID: 4c986f
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/19/21 7:32 AM, Xu Liang wrote:
> Add driver to support the Maxlinear GPY115, GPY211, GPY212, GPY215,
> GPY241, GPY245 PHYs. Separate from XWAY PHY driver because this series
> has different register layout and new features not supported in XWAY PHY.
> 
> Signed-off-by: Xu Liang <lxu@maxlinear.com>

Acked-by: Hauke Mehrtens <hmehrtens@maxlinear.com>

> ---
> v2 changes:
>   Fix format warning from checkpath and some comments.
>   Use smaller PHY ID mask.
>   Split FWV register mask.
>   Call phy_trigger_machine if necessary when clear interrupt.
> v3 changes:
>   Replace unnecessary phy_modify_mmd_changed with phy_modify_mmd
>   Move firmware version print to probe.
> v4 changes:
>   Separate PHY ID for new silicon.
>   Use full Maxlinear name in Kconfig.
>   Add and use C45 ID read API, and use genphy_c45_pma_read_abilities.
>   Use my name instead of company as author.
> v5 changes:
>   Fix comment for link speed 2.5G.
> v6 changes:
>   Add GPY241B, GPY241BM, GPY245B models.
> 
>   MAINTAINERS               |   6 +
>   drivers/net/phy/Kconfig   |   6 +
>   drivers/net/phy/Makefile  |   1 +
>   drivers/net/phy/mxl-gpy.c | 728 ++++++++++++++++++++++++++++++++++++++
>   4 files changed, 741 insertions(+)
>   create mode 100644 drivers/net/phy/mxl-gpy.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 6c8be735cc91..59b997201cee 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -11327,6 +11327,12 @@ W:	https://linuxtv.org
>   T:	git git://linuxtv.org/media_tree.git
>   F:	drivers/media/radio/radio-maxiradio*
>   
> +MAXLINEAR ETHERNET PHY DRIVER
> +M:	Xu Liang <lxu@maxlinear.com>
> +L:	netdev@vger.kernel.org
> +S:	Supported
> +F:	drivers/net/phy/mxl-gpy.c
> +
>   MCAN MMIO DEVICE DRIVER
>   M:	Chandrasekar Ramakrishnan <rcsekar@samsung.com>
>   L:	linux-can@vger.kernel.org
> diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
> index c56f703ae998..7564ae0c1997 100644
> --- a/drivers/net/phy/Kconfig
> +++ b/drivers/net/phy/Kconfig
> @@ -207,6 +207,12 @@ config MARVELL_88X2222_PHY
>   	  Support for the Marvell 88X2222 Dual-port Multi-speed Ethernet
>   	  Transceiver.
>   
> +config MAXLINEAR_GPHY
> +	tristate "Maxlinear Ethernet PHYs"
> +	help
> +	  Support for the Maxlinear GPY115, GPY211, GPY212, GPY215,
> +	  GPY241, GPY245 PHYs.
> +
>   config MEDIATEK_GE_PHY
>   	tristate "MediaTek Gigabit Ethernet PHYs"
>   	help
> diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
> index 172bb193ae6a..b2728d00fc9a 100644
> --- a/drivers/net/phy/Makefile
> +++ b/drivers/net/phy/Makefile
> @@ -64,6 +64,7 @@ obj-$(CONFIG_LXT_PHY)		+= lxt.o
>   obj-$(CONFIG_MARVELL_10G_PHY)	+= marvell10g.o
>   obj-$(CONFIG_MARVELL_PHY)	+= marvell.o
>   obj-$(CONFIG_MARVELL_88X2222_PHY)	+= marvell-88x2222.o
> +obj-$(CONFIG_MAXLINEAR_GPHY)	+= mxl-gpy.o
>   obj-$(CONFIG_MEDIATEK_GE_PHY)	+= mediatek-ge.o
>   obj-$(CONFIG_MESON_GXL_PHY)	+= meson-gxl.o
>   obj-$(CONFIG_MICREL_KS8995MA)	+= spi_ks8995.o
> diff --git a/drivers/net/phy/mxl-gpy.c b/drivers/net/phy/mxl-gpy.c
> new file mode 100644
> index 000000000000..12a02d8ce09b
> --- /dev/null
> +++ b/drivers/net/phy/mxl-gpy.c
> @@ -0,0 +1,728 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/* Copyright (C) 2021 Maxlinear Corporation
> + * Copyright (C) 2020 Intel Corporation
> + *
> + * Drivers for Maxlinear Ethernet GPY
> + *
> + */
> +
> +#include <linux/version.h>
> +#include <linux/module.h>
> +#include <linux/bitfield.h>
> +#include <linux/phy.h>
> +#include <linux/netdevice.h>
> +
> +/* PHY ID */
> +#define PHY_ID_GPYx15B_MASK	0xFFFFFFFC
> +#define PHY_ID_GPY21xB_MASK	0xFFFFFFF9
> +#define PHY_ID_GPY2xx		0x67C9DC00
> +#define PHY_ID_GPY115B		0x67C9DF00
> +#define PHY_ID_GPY115C		0x67C9DF10
> +#define PHY_ID_GPY211B		0x67C9DE08
> +#define PHY_ID_GPY211C		0x67C9DE10
> +#define PHY_ID_GPY212B		0x67C9DE09
> +#define PHY_ID_GPY212C		0x67C9DE20
> +#define PHY_ID_GPY215B		0x67C9DF04
> +#define PHY_ID_GPY215C		0x67C9DF20
> +#define PHY_ID_GPY241B		0x67C9DE40
> +#define PHY_ID_GPY241BM		0x67C9DE80
> +#define PHY_ID_GPY245B		0x67C9DEC0
> +
> +#define PHY_MIISTAT		0x18	/* MII state */
> +#define PHY_IMASK		0x19	/* interrupt mask */
> +#define PHY_ISTAT		0x1A	/* interrupt status */
> +#define PHY_FWV			0x1E	/* firmware version */
> +
> +#define PHY_MIISTAT_SPD_MASK	GENMASK(2, 0)
> +#define PHY_MIISTAT_DPX		BIT(3)
> +#define PHY_MIISTAT_LS		BIT(10)
> +
> +#define PHY_MIISTAT_SPD_10	0
> +#define PHY_MIISTAT_SPD_100	1
> +#define PHY_MIISTAT_SPD_1000	2
> +#define PHY_MIISTAT_SPD_2500	4
> +
> +#define PHY_IMASK_WOL		BIT(15)	/* Wake-on-LAN */
> +#define PHY_IMASK_ANC		BIT(10)	/* Auto-Neg complete */
> +#define PHY_IMASK_ADSC		BIT(5)	/* Link auto-downspeed detect */
> +#define PHY_IMASK_DXMC		BIT(2)	/* Duplex mode change */
> +#define PHY_IMASK_LSPC		BIT(1)	/* Link speed change */
> +#define PHY_IMASK_LSTC		BIT(0)	/* Link state change */
> +#define PHY_IMASK_MASK		(PHY_IMASK_LSTC | \
> +				 PHY_IMASK_LSPC | \
> +				 PHY_IMASK_DXMC | \
> +				 PHY_IMASK_ADSC | \
> +				 PHY_IMASK_ANC)
> +
> +#define PHY_FWV_REL_MASK	BIT(15)
> +#define PHY_FWV_TYPE_MASK	GENMASK(11, 8)
> +#define PHY_FWV_MINOR_MASK	GENMASK(7, 0)
> +
> +/* SGMII */
> +#define VSPEC1_SGMII_CTRL	0x08
> +#define VSPEC1_SGMII_CTRL_ANEN	BIT(12)		/* Aneg enable */
> +#define VSPEC1_SGMII_CTRL_ANRS	BIT(9)		/* Restart Aneg */
> +#define VSPEC1_SGMII_ANEN_ANRS	(VSPEC1_SGMII_CTRL_ANEN | \
> +				 VSPEC1_SGMII_CTRL_ANRS)
> +
> +/* WoL */
> +#define VPSPEC2_WOL_CTL		0x0E06
> +#define VPSPEC2_WOL_AD01	0x0E08
> +#define VPSPEC2_WOL_AD23	0x0E09
> +#define VPSPEC2_WOL_AD45	0x0E0A
> +#define WOL_EN			BIT(0)
> +
> +static const struct {
> +	int type;
> +	int minor;
> +} ver_need_sgmii_reaneg[] = {
> +	{7, 0x6D},
> +	{8, 0x6D},
> +	{9, 0x73},
> +};
> +
> +static int gpy_config_init(struct phy_device *phydev)
> +{
> +	int ret;
> +
> +	/* Mask all interrupts */
> +	ret = phy_write(phydev, PHY_IMASK, 0);
> +	if (ret)
> +		return ret;
> +
> +	/* Clear all pending interrupts */
> +	ret = phy_read(phydev, PHY_ISTAT);
> +	return ret < 0 ? ret : 0;
> +}
> +
> +static int gpy_probe(struct phy_device *phydev)
> +{
> +	int ret;
> +
> +	if (!phydev->is_c45) {
> +		ret = phy_get_c45_ids(phydev);
> +		if (ret < 0)
> +			return ret;
> +	}
> +
> +	/* Show GPY PHY FW version in dmesg */
> +	ret = phy_read(phydev, PHY_FWV);
> +	if (ret < 0)
> +		return ret;
> +
> +	phydev_info(phydev, "Firmware Version: 0x%04X (%s)\n", ret,
> +		    (ret & PHY_FWV_REL_MASK) ? "release" : "test");
> +
> +	return 0;
> +}
> +
> +static bool gpy_sgmii_need_reaneg(struct phy_device *phydev)
> +{
> +	int fw_ver, fw_type, fw_minor;
> +	size_t i;
> +
> +	fw_ver = phy_read(phydev, PHY_FWV);
> +	if (fw_ver < 0)
> +		return true;
> +
> +	fw_type = FIELD_GET(PHY_FWV_TYPE_MASK, fw_ver);
> +	fw_minor = FIELD_GET(PHY_FWV_MINOR_MASK, fw_ver);
> +
> +	for (i = 0; i < ARRAY_SIZE(ver_need_sgmii_reaneg); i++) {
> +		if (fw_type != ver_need_sgmii_reaneg[i].type)
> +			continue;
> +		if (fw_minor < ver_need_sgmii_reaneg[i].minor)
> +			return true;
> +		break;
> +	}
> +
> +	return false;
> +}
> +
> +static bool gpy_2500basex_chk(struct phy_device *phydev)
> +{
> +	int ret;
> +
> +	ret = phy_read(phydev, PHY_MIISTAT);
> +	if (ret < 0) {
> +		phydev_err(phydev, "Error: MDIO register access failed: %d\n",
> +			   ret);
> +		return false;
> +	}
> +
> +	if (!(ret & PHY_MIISTAT_LS) ||
> +	    FIELD_GET(PHY_MIISTAT_SPD_MASK, ret) != PHY_MIISTAT_SPD_2500)
> +		return false;
> +
> +	phydev->speed = SPEED_2500;
> +	phydev->interface = PHY_INTERFACE_MODE_2500BASEX;
> +	phy_modify_mmd(phydev, MDIO_MMD_VEND1, VSPEC1_SGMII_CTRL,
> +		       VSPEC1_SGMII_CTRL_ANEN, 0);
> +	return true;
> +}
> +
> +static bool gpy_sgmii_aneg_en(struct phy_device *phydev)
> +{
> +	int ret;
> +
> +	ret = phy_read_mmd(phydev, MDIO_MMD_VEND1, VSPEC1_SGMII_CTRL);
> +	if (ret < 0) {
> +		phydev_err(phydev, "Error: MMD register access failed: %d\n",
> +			   ret);
> +		return true;
> +	}
> +
> +	return (ret & VSPEC1_SGMII_CTRL_ANEN) ? true : false;
> +}
> +
> +static int gpy_config_aneg(struct phy_device *phydev)
> +{
> +	bool changed = false;
> +	u32 adv;
> +	int ret;
> +
> +	if (phydev->autoneg == AUTONEG_DISABLE) {
> +		/* Configure half duplex with genphy_setup_forced,
> +		 * because genphy_c45_pma_setup_forced does not support.
> +		 */
> +		return phydev->duplex != DUPLEX_FULL
> +			? genphy_setup_forced(phydev)
> +			: genphy_c45_pma_setup_forced(phydev);
> +	}
> +
> +	ret = genphy_c45_an_config_aneg(phydev);
> +	if (ret < 0)
> +		return ret;
> +	if (ret > 0)
> +		changed = true;
> +
> +	adv = linkmode_adv_to_mii_ctrl1000_t(phydev->advertising);
> +	ret = phy_modify_changed(phydev, MII_CTRL1000,
> +				 ADVERTISE_1000FULL | ADVERTISE_1000HALF,
> +				 adv);
> +	if (ret < 0)
> +		return ret;
> +	if (ret > 0)
> +		changed = true;
> +
> +	ret = genphy_c45_check_and_restart_aneg(phydev, changed);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (phydev->interface == PHY_INTERFACE_MODE_USXGMII ||
> +	    phydev->interface == PHY_INTERFACE_MODE_INTERNAL)
> +		return 0;
> +
> +	/* No need to trigger re-ANEG if link speed is 2.5G or SGMII ANEG is
> +	 * disabled.
> +	 */
> +	if (!gpy_sgmii_need_reaneg(phydev) || gpy_2500basex_chk(phydev) ||
> +	    !gpy_sgmii_aneg_en(phydev))
> +		return 0;
> +
> +	/* There is a design constraint in GPY2xx device where SGMII AN is
> +	 * only triggered when there is change of speed. If, PHY link
> +	 * partner`s speed is still same even after PHY TPI is down and up
> +	 * again, SGMII AN is not triggered and hence no new in-band message
> +	 * from GPY to MAC side SGMII.
> +	 * This could cause an issue during power up, when PHY is up prior to
> +	 * MAC. At this condition, once MAC side SGMII is up, MAC side SGMII
> +	 * wouldn`t receive new in-band message from GPY with correct link
> +	 * status, speed and duplex info.
> +	 *
> +	 * 1) If PHY is already up and TPI link status is still down (such as
> +	 *    hard reboot), TPI link status is polled for 4 seconds before
> +	 *    retriggerring SGMII AN.
> +	 * 2) If PHY is already up and TPI link status is also up (such as soft
> +	 *    reboot), polling of TPI link status is not needed and SGMII AN is
> +	 *    immediately retriggered.
> +	 * 3) Other conditions such as PHY is down, speed change etc, skip
> +	 *    retriggering SGMII AN. Note: in case of speed change, GPY FW will
> +	 *    initiate SGMII AN.
> +	 */
> +
> +	if (phydev->state != PHY_UP)
> +		return 0;
> +
> +	ret = phy_read_poll_timeout(phydev, MII_BMSR, ret, ret & BMSR_LSTATUS,
> +				    20000, 4000000, false);
> +	if (ret == -ETIMEDOUT)
> +		return 0;
> +	else if (ret < 0)
> +		return ret;
> +
> +	/* Trigger SGMII AN. */
> +	return phy_modify_mmd(phydev, MDIO_MMD_VEND1, VSPEC1_SGMII_CTRL,
> +			      VSPEC1_SGMII_CTRL_ANRS, VSPEC1_SGMII_CTRL_ANRS);
> +}
> +
> +static void gpy_update_interface(struct phy_device *phydev)
> +{
> +	int ret;
> +
> +	/* Interface mode is fixed for USXGMII and integrated PHY */
> +	if (phydev->interface == PHY_INTERFACE_MODE_USXGMII ||
> +	    phydev->interface == PHY_INTERFACE_MODE_INTERNAL)
> +		return;
> +
> +	/* Automatically switch SERDES interface between SGMII and 2500-BaseX
> +	 * according to speed. Disable ANEG in 2500-BaseX mode.
> +	 */
> +	switch (phydev->speed) {
> +	case SPEED_2500:
> +		phydev->interface = PHY_INTERFACE_MODE_2500BASEX;
> +		ret = phy_modify_mmd(phydev, MDIO_MMD_VEND1, VSPEC1_SGMII_CTRL,
> +				     VSPEC1_SGMII_CTRL_ANEN, 0);
> +		if (ret < 0)
> +			phydev_err(phydev,
> +				   "Error: Disable of SGMII ANEG failed: %d\n",
> +				   ret);
> +		break;
> +	case SPEED_1000:
> +	case SPEED_100:
> +	case SPEED_10:
> +		phydev->interface = PHY_INTERFACE_MODE_SGMII;
> +		if (gpy_sgmii_aneg_en(phydev))
> +			break;
> +		/* Enable and restart SGMII ANEG for 10/100/1000Mbps link speed
> +		 * if ANEG is disabled (in 2500-BaseX mode).
> +		 */
> +		ret = phy_modify_mmd(phydev, MDIO_MMD_VEND1, VSPEC1_SGMII_CTRL,
> +				     VSPEC1_SGMII_ANEN_ANRS,
> +				     VSPEC1_SGMII_ANEN_ANRS);
> +		if (ret < 0)
> +			phydev_err(phydev,
> +				   "Error: Enable of SGMII ANEG failed: %d\n",
> +				   ret);
> +		break;
> +	}
> +}
> +
> +static int gpy_read_status(struct phy_device *phydev)
> +{
> +	int ret;
> +
> +	ret = genphy_update_link(phydev);
> +	if (ret)
> +		return ret;
> +
> +	phydev->speed = SPEED_UNKNOWN;
> +	phydev->duplex = DUPLEX_UNKNOWN;
> +	phydev->pause = 0;
> +	phydev->asym_pause = 0;
> +
> +	if (phydev->autoneg == AUTONEG_ENABLE && phydev->autoneg_complete) {
> +		ret = genphy_c45_read_lpa(phydev);
> +		if (ret < 0)
> +			return ret;
> +
> +		/* Read the link partner's 1G advertisement */
> +		ret = phy_read(phydev, MII_STAT1000);
> +		if (ret < 0)
> +			return ret;
> +		mii_stat1000_mod_linkmode_lpa_t(phydev->lp_advertising, ret);
> +	} else if (phydev->autoneg == AUTONEG_DISABLE) {
> +		linkmode_zero(phydev->lp_advertising);
> +	}
> +
> +	ret = phy_read(phydev, PHY_MIISTAT);
> +	if (ret < 0)
> +		return ret;
> +
> +	phydev->link = (ret & PHY_MIISTAT_LS) ? 1 : 0;
> +	phydev->duplex = (ret & PHY_MIISTAT_DPX) ? DUPLEX_FULL : DUPLEX_HALF;
> +	switch (FIELD_GET(PHY_MIISTAT_SPD_MASK, ret)) {
> +	case PHY_MIISTAT_SPD_10:
> +		phydev->speed = SPEED_10;
> +		break;
> +	case PHY_MIISTAT_SPD_100:
> +		phydev->speed = SPEED_100;
> +		break;
> +	case PHY_MIISTAT_SPD_1000:
> +		phydev->speed = SPEED_1000;
> +		break;
> +	case PHY_MIISTAT_SPD_2500:
> +		phydev->speed = SPEED_2500;
> +		break;
> +	}
> +
> +	if (phydev->link)
> +		gpy_update_interface(phydev);
> +
> +	return 0;
> +}
> +
> +static int gpy_config_intr(struct phy_device *phydev)
> +{
> +	u16 mask = 0;
> +
> +	if (phydev->interrupts == PHY_INTERRUPT_ENABLED)
> +		mask = PHY_IMASK_MASK;
> +
> +	return phy_write(phydev, PHY_IMASK, mask);
> +}
> +
> +static irqreturn_t gpy_handle_interrupt(struct phy_device *phydev)
> +{
> +	int reg;
> +
> +	reg = phy_read(phydev, PHY_ISTAT);
> +	if (reg < 0) {
> +		phy_error(phydev);
> +		return IRQ_NONE;
> +	}
> +
> +	if (!(reg & PHY_IMASK_MASK))
> +		return IRQ_NONE;
> +
> +	phy_trigger_machine(phydev);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static int gpy_set_wol(struct phy_device *phydev,
> +		       struct ethtool_wolinfo *wol)
> +{
> +	struct net_device *attach_dev = phydev->attached_dev;
> +	int ret;
> +
> +	if (wol->wolopts & WAKE_MAGIC) {
> +		/* MAC address - Byte0:Byte1:Byte2:Byte3:Byte4:Byte5
> +		 * VPSPEC2_WOL_AD45 = Byte0:Byte1
> +		 * VPSPEC2_WOL_AD23 = Byte2:Byte3
> +		 * VPSPEC2_WOL_AD01 = Byte4:Byte5
> +		 */
> +		ret = phy_set_bits_mmd(phydev, MDIO_MMD_VEND2,
> +				       VPSPEC2_WOL_AD45,
> +				       ((attach_dev->dev_addr[0] << 8) |
> +				       attach_dev->dev_addr[1]));
> +		if (ret < 0)
> +			return ret;
> +
> +		ret = phy_set_bits_mmd(phydev, MDIO_MMD_VEND2,
> +				       VPSPEC2_WOL_AD23,
> +				       ((attach_dev->dev_addr[2] << 8) |
> +				       attach_dev->dev_addr[3]));
> +		if (ret < 0)
> +			return ret;
> +
> +		ret = phy_set_bits_mmd(phydev, MDIO_MMD_VEND2,
> +				       VPSPEC2_WOL_AD01,
> +				       ((attach_dev->dev_addr[4] << 8) |
> +				       attach_dev->dev_addr[5]));
> +		if (ret < 0)
> +			return ret;
> +
> +		/* Enable the WOL interrupt */
> +		ret = phy_write(phydev, PHY_IMASK, PHY_IMASK_WOL);
> +		if (ret < 0)
> +			return ret;
> +
> +		/* Enable magic packet matching */
> +		ret = phy_set_bits_mmd(phydev, MDIO_MMD_VEND2,
> +				       VPSPEC2_WOL_CTL,
> +				       WOL_EN);
> +		if (ret < 0)
> +			return ret;
> +
> +		/* Clear the interrupt status register.
> +		 * Only WoL is enabled so clear all.
> +		 */
> +		ret = phy_read(phydev, PHY_ISTAT);
> +		if (ret < 0)
> +			return ret;
> +	} else {
> +		/* Disable magic packet matching */
> +		ret = phy_clear_bits_mmd(phydev, MDIO_MMD_VEND2,
> +					 VPSPEC2_WOL_CTL,
> +					 WOL_EN);
> +		if (ret < 0)
> +			return ret;
> +	}
> +
> +	if (wol->wolopts & WAKE_PHY) {
> +		/* Enable the link state change interrupt */
> +		ret = phy_set_bits(phydev, PHY_IMASK, PHY_IMASK_LSTC);
> +		if (ret < 0)
> +			return ret;
> +
> +		/* Clear the interrupt status register */
> +		ret = phy_read(phydev, PHY_ISTAT);
> +		if (ret < 0)
> +			return ret;
> +
> +		if (ret & (PHY_IMASK_MASK & ~PHY_IMASK_LSTC))
> +			phy_trigger_machine(phydev);
> +
> +		return 0;
> +	}
> +
> +	/* Disable the link state change interrupt */
> +	return phy_clear_bits(phydev, PHY_IMASK, PHY_IMASK_LSTC);
> +}
> +
> +static void gpy_get_wol(struct phy_device *phydev,
> +			struct ethtool_wolinfo *wol)
> +{
> +	int ret;
> +
> +	wol->supported = WAKE_MAGIC | WAKE_PHY;
> +	wol->wolopts = 0;
> +
> +	ret = phy_read_mmd(phydev, MDIO_MMD_VEND2, VPSPEC2_WOL_CTL);
> +	if (ret & WOL_EN)
> +		wol->wolopts |= WAKE_MAGIC;
> +
> +	ret = phy_read(phydev, PHY_IMASK);
> +	if (ret & PHY_IMASK_LSTC)
> +		wol->wolopts |= WAKE_PHY;
> +}
> +
> +static int gpy_loopback(struct phy_device *phydev, bool enable)
> +{
> +	int ret;
> +
> +	ret = phy_modify(phydev, MII_BMCR, BMCR_LOOPBACK,
> +			 enable ? BMCR_LOOPBACK : 0);
> +	if (!ret) {
> +		/* It takes some time for PHY device to switch
> +		 * into/out-of loopback mode.
> +		 */
> +		msleep(100);
> +	}
> +
> +	return ret;
> +}
> +
> +static struct phy_driver gpy_drivers[] = {
> +	{
> +		PHY_ID_MATCH_MODEL(PHY_ID_GPY2xx),
> +		.name		= "Maxlinear Ethernet GPY2xx",
> +		.get_features	= genphy_c45_pma_read_abilities,
> +		.config_init	= gpy_config_init,
> +		.probe		= gpy_probe,
> +		.suspend	= genphy_suspend,
> +		.resume		= genphy_resume,
> +		.config_aneg	= gpy_config_aneg,
> +		.aneg_done	= genphy_c45_aneg_done,
> +		.read_status	= gpy_read_status,
> +		.config_intr	= gpy_config_intr,
> +		.handle_interrupt = gpy_handle_interrupt,
> +		.set_wol	= gpy_set_wol,
> +		.get_wol	= gpy_get_wol,
> +		.set_loopback	= gpy_loopback,
> +	},
> +	{
> +		.phy_id		= PHY_ID_GPY115B,
> +		.phy_id_mask	= PHY_ID_GPYx15B_MASK,
> +		.name		= "Maxlinear Ethernet GPY115B",
> +		.get_features	= genphy_c45_pma_read_abilities,
> +		.config_init	= gpy_config_init,
> +		.probe		= gpy_probe,
> +		.suspend	= genphy_suspend,
> +		.resume		= genphy_resume,
> +		.config_aneg	= gpy_config_aneg,
> +		.aneg_done	= genphy_c45_aneg_done,
> +		.read_status	= gpy_read_status,
> +		.config_intr	= gpy_config_intr,
> +		.handle_interrupt = gpy_handle_interrupt,
> +		.set_wol	= gpy_set_wol,
> +		.get_wol	= gpy_get_wol,
> +		.set_loopback	= gpy_loopback,
> +	},
> +	{
> +		PHY_ID_MATCH_MODEL(PHY_ID_GPY115C),
> +		.name		= "Maxlinear Ethernet GPY115C",
> +		.get_features	= genphy_c45_pma_read_abilities,
> +		.config_init	= gpy_config_init,
> +		.probe		= gpy_probe,
> +		.suspend	= genphy_suspend,
> +		.resume		= genphy_resume,
> +		.config_aneg	= gpy_config_aneg,
> +		.aneg_done	= genphy_c45_aneg_done,
> +		.read_status	= gpy_read_status,
> +		.config_intr	= gpy_config_intr,
> +		.handle_interrupt = gpy_handle_interrupt,
> +		.set_wol	= gpy_set_wol,
> +		.get_wol	= gpy_get_wol,
> +		.set_loopback	= gpy_loopback,
> +	},
> +	{
> +		.phy_id		= PHY_ID_GPY211B,
> +		.phy_id_mask	= PHY_ID_GPY21xB_MASK,
> +		.name		= "Maxlinear Ethernet GPY211B",
> +		.get_features	= genphy_c45_pma_read_abilities,
> +		.config_init	= gpy_config_init,
> +		.probe		= gpy_probe,
> +		.suspend	= genphy_suspend,
> +		.resume		= genphy_resume,
> +		.config_aneg	= gpy_config_aneg,
> +		.aneg_done	= genphy_c45_aneg_done,
> +		.read_status	= gpy_read_status,
> +		.config_intr	= gpy_config_intr,
> +		.handle_interrupt = gpy_handle_interrupt,
> +		.set_wol	= gpy_set_wol,
> +		.get_wol	= gpy_get_wol,
> +		.set_loopback	= gpy_loopback,
> +	},
> +	{
> +		PHY_ID_MATCH_MODEL(PHY_ID_GPY211C),
> +		.name		= "Maxlinear Ethernet GPY211C",
> +		.get_features	= genphy_c45_pma_read_abilities,
> +		.config_init	= gpy_config_init,
> +		.probe		= gpy_probe,
> +		.suspend	= genphy_suspend,
> +		.resume		= genphy_resume,
> +		.config_aneg	= gpy_config_aneg,
> +		.aneg_done	= genphy_c45_aneg_done,
> +		.read_status	= gpy_read_status,
> +		.config_intr	= gpy_config_intr,
> +		.handle_interrupt = gpy_handle_interrupt,
> +		.set_wol	= gpy_set_wol,
> +		.get_wol	= gpy_get_wol,
> +		.set_loopback	= gpy_loopback,
> +	},
> +	{
> +		.phy_id		= PHY_ID_GPY212B,
> +		.phy_id_mask	= PHY_ID_GPY21xB_MASK,
> +		.name		= "Maxlinear Ethernet GPY212B",
> +		.get_features	= genphy_c45_pma_read_abilities,
> +		.config_init	= gpy_config_init,
> +		.probe		= gpy_probe,
> +		.suspend	= genphy_suspend,
> +		.resume		= genphy_resume,
> +		.config_aneg	= gpy_config_aneg,
> +		.aneg_done	= genphy_c45_aneg_done,
> +		.read_status	= gpy_read_status,
> +		.config_intr	= gpy_config_intr,
> +		.handle_interrupt = gpy_handle_interrupt,
> +		.set_wol	= gpy_set_wol,
> +		.get_wol	= gpy_get_wol,
> +		.set_loopback	= gpy_loopback,
> +	},
> +	{
> +		PHY_ID_MATCH_MODEL(PHY_ID_GPY212C),
> +		.name		= "Maxlinear Ethernet GPY212C",
> +		.get_features	= genphy_c45_pma_read_abilities,
> +		.config_init	= gpy_config_init,
> +		.probe		= gpy_probe,
> +		.suspend	= genphy_suspend,
> +		.resume		= genphy_resume,
> +		.config_aneg	= gpy_config_aneg,
> +		.aneg_done	= genphy_c45_aneg_done,
> +		.read_status	= gpy_read_status,
> +		.config_intr	= gpy_config_intr,
> +		.handle_interrupt = gpy_handle_interrupt,
> +		.set_wol	= gpy_set_wol,
> +		.get_wol	= gpy_get_wol,
> +		.set_loopback	= gpy_loopback,
> +	},
> +	{
> +		.phy_id		= PHY_ID_GPY215B,
> +		.phy_id_mask	= PHY_ID_GPYx15B_MASK,
> +		.name		= "Maxlinear Ethernet GPY215B",
> +		.get_features	= genphy_c45_pma_read_abilities,
> +		.config_init	= gpy_config_init,
> +		.probe		= gpy_probe,
> +		.suspend	= genphy_suspend,
> +		.resume		= genphy_resume,
> +		.config_aneg	= gpy_config_aneg,
> +		.aneg_done	= genphy_c45_aneg_done,
> +		.read_status	= gpy_read_status,
> +		.config_intr	= gpy_config_intr,
> +		.handle_interrupt = gpy_handle_interrupt,
> +		.set_wol	= gpy_set_wol,
> +		.get_wol	= gpy_get_wol,
> +		.set_loopback	= gpy_loopback,
> +	},
> +	{
> +		PHY_ID_MATCH_MODEL(PHY_ID_GPY215C),
> +		.name		= "Maxlinear Ethernet GPY215C",
> +		.get_features	= genphy_c45_pma_read_abilities,
> +		.config_init	= gpy_config_init,
> +		.probe		= gpy_probe,
> +		.suspend	= genphy_suspend,
> +		.resume		= genphy_resume,
> +		.config_aneg	= gpy_config_aneg,
> +		.aneg_done	= genphy_c45_aneg_done,
> +		.read_status	= gpy_read_status,
> +		.config_intr	= gpy_config_intr,
> +		.handle_interrupt = gpy_handle_interrupt,
> +		.set_wol	= gpy_set_wol,
> +		.get_wol	= gpy_get_wol,
> +		.set_loopback	= gpy_loopback,
> +	},
> +	{
> +		PHY_ID_MATCH_MODEL(PHY_ID_GPY241B),
> +		.name		= "Maxlinear Ethernet GPY241B",
> +		.get_features	= genphy_c45_pma_read_abilities,
> +		.config_init	= gpy_config_init,
> +		.probe		= gpy_probe,
> +		.suspend	= genphy_suspend,
> +		.resume		= genphy_resume,
> +		.config_aneg	= gpy_config_aneg,
> +		.aneg_done	= genphy_c45_aneg_done,
> +		.read_status	= gpy_read_status,
> +		.config_intr	= gpy_config_intr,
> +		.handle_interrupt = gpy_handle_interrupt,
> +		.set_wol	= gpy_set_wol,
> +		.get_wol	= gpy_get_wol,
> +		.set_loopback	= gpy_loopback,
> +	},
> +	{
> +		PHY_ID_MATCH_MODEL(PHY_ID_GPY241BM),
> +		.name		= "Maxlinear Ethernet GPY241BM",
> +		.get_features	= genphy_c45_pma_read_abilities,
> +		.config_init	= gpy_config_init,
> +		.probe		= gpy_probe,
> +		.suspend	= genphy_suspend,
> +		.resume		= genphy_resume,
> +		.config_aneg	= gpy_config_aneg,
> +		.aneg_done	= genphy_c45_aneg_done,
> +		.read_status	= gpy_read_status,
> +		.config_intr	= gpy_config_intr,
> +		.handle_interrupt = gpy_handle_interrupt,
> +		.set_wol	= gpy_set_wol,
> +		.get_wol	= gpy_get_wol,
> +		.set_loopback	= gpy_loopback,
> +	},
> +	{
> +		PHY_ID_MATCH_MODEL(PHY_ID_GPY245B),
> +		.name		= "Maxlinear Ethernet GPY245B",
> +		.get_features	= genphy_c45_pma_read_abilities,
> +		.config_init	= gpy_config_init,
> +		.probe		= gpy_probe,
> +		.suspend	= genphy_suspend,
> +		.resume		= genphy_resume,
> +		.config_aneg	= gpy_config_aneg,
> +		.aneg_done	= genphy_c45_aneg_done,
> +		.read_status	= gpy_read_status,
> +		.config_intr	= gpy_config_intr,
> +		.handle_interrupt = gpy_handle_interrupt,
> +		.set_wol	= gpy_set_wol,
> +		.get_wol	= gpy_get_wol,
> +		.set_loopback	= gpy_loopback,
> +	},
> +};
> +module_phy_driver(gpy_drivers);
> +
> +static struct mdio_device_id __maybe_unused gpy_tbl[] = {
> +	{PHY_ID_MATCH_MODEL(PHY_ID_GPY2xx)},
> +	{PHY_ID_GPY115B, PHY_ID_GPYx15B_MASK},
> +	{PHY_ID_MATCH_MODEL(PHY_ID_GPY115C)},
> +	{PHY_ID_GPY211B, PHY_ID_GPY21xB_MASK},
> +	{PHY_ID_MATCH_MODEL(PHY_ID_GPY211C)},
> +	{PHY_ID_GPY212B, PHY_ID_GPY21xB_MASK},
> +	{PHY_ID_MATCH_MODEL(PHY_ID_GPY212C)},
> +	{PHY_ID_GPY215B, PHY_ID_GPYx15B_MASK},
> +	{PHY_ID_MATCH_MODEL(PHY_ID_GPY215C)},
> +	{PHY_ID_MATCH_MODEL(PHY_ID_GPY241B)},
> +	{PHY_ID_MATCH_MODEL(PHY_ID_GPY241BM)},
> +	{PHY_ID_MATCH_MODEL(PHY_ID_GPY245B)},
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(mdio, gpy_tbl);
> +
> +MODULE_DESCRIPTION("Maxlinear Ethernet GPY Driver");
> +MODULE_AUTHOR("Xu Liang");
> +MODULE_LICENSE("GPL");
> 

