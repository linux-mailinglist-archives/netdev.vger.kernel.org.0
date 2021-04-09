Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36C9335A6DD
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 21:19:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234980AbhDITSz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 15:18:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234949AbhDITSy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 15:18:54 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6789EC061762;
        Fri,  9 Apr 2021 12:18:41 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id x7so6625961wrw.10;
        Fri, 09 Apr 2021 12:18:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DU6Zrk95juyK7+i/k19osuWgq0Q7ekmzOdypGvv23SU=;
        b=mLkNAl8dTgvO/P0d1U57ICjDEI3zTQgE/aextVSiki9GikNjDQle89eWcq9GMXius6
         /tOtl82IorZ4mZdrkVSwKy0OvwrSYjc4HokTG2mMjGvwrINIHDJ03NW3TgOkxnE/jdnV
         rN0mXucGhDrHph82mdrYZv4IM/YlNex0td6pRpbq0eTKuUpSVyHCz/LsYAxDyCtazDDP
         okS5ldEbbsrJrzDElYtP7jYJ6JnrCUvC59ae1VHOxiA0WC8qJcILjNeTxjJ/Yl/Glcfo
         ZedHwHZaVYBUGNnvN26yXC2faBreTDtfmYkdbXM7mIeaA1wQhH1hGb2euXwQCF5xmwy+
         jt2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DU6Zrk95juyK7+i/k19osuWgq0Q7ekmzOdypGvv23SU=;
        b=O/0i3+PcVkGQR0wJ54NMi/qIRuy3/G6Vaor+k0E3Rw6b8VfU26ECdH5NAr6INI7FtD
         wknAG3YfYQ0SiAF6xuyXoTgDDQRP8MPB1dntiPs8EWhu97RfUuekajhBtXVC//9mPOlE
         SqJGW9jmpIBWfNfH/7jGOUCPK6lAbAht/b67KWel0TU3j3sJLZwXmvAMGiurz+74YybJ
         km2mlSbFDm7OjKNd0ahGoGTiCajVDoe74CPKiSLeTkbelh+lkqfS0Hq44hqYnUddszZF
         l+kKascOY3aVth39hylLOSfiM6IALIwnNb2BuGIjHXrjgrfgzngU/qIlQ+VRd8XIFGUf
         keIQ==
X-Gm-Message-State: AOAM533HpMNnTnrg2BvNXp7Fjki+jMqkv5KQGirU6mxl7tjTJvZ/EYKN
        FwYgJ/pKvGWj+4beQaPWcnfbagiXt4Omgg==
X-Google-Smtp-Source: ABdhPJwo7h1p6Q/+noNQ3LPlaTAfc+oPy6/inPUdSFhKrDcgIsnMOM1T+5MV7L6Q8fvFfP4jyoatWw==
X-Received: by 2002:adf:cd8c:: with SMTP id q12mr19422459wrj.340.1617995919736;
        Fri, 09 Apr 2021 12:18:39 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f38:4600:141d:420a:4787:e788? (p200300ea8f384600141d420a4787e788.dip0.t-ipconnect.de. [2003:ea:8f38:4600:141d:420a:4787:e788])
        by smtp.googlemail.com with ESMTPSA id r11sm5918360wrp.70.2021.04.09.12.18.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Apr 2021 12:18:39 -0700 (PDT)
To:     "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>,
        andrew@lunn.ch, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210409184106.264463-1-radu-nicolae.pirea@oss.nxp.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH] phy: nxp-c45: add driver for tja1103
Message-ID: <bc84a0d0-a0c2-988d-3382-9ebd1a0a0233@gmail.com>
Date:   Fri, 9 Apr 2021 21:18:32 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210409184106.264463-1-radu-nicolae.pirea@oss.nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09.04.2021 20:41, Radu Pirea (NXP OSS) wrote:
> Add driver for tja1103 driver and for future NXP C45 PHYs.
> 
> Signed-off-by: Radu Pirea (NXP OSS) <radu-nicolae.pirea@oss.nxp.com>
> ---
>  MAINTAINERS               |   6 +
>  drivers/net/phy/Kconfig   |   6 +
>  drivers/net/phy/Makefile  |   1 +
>  drivers/net/phy/nxp-c45.c | 622 ++++++++++++++++++++++++++++++++++++++
>  4 files changed, 635 insertions(+)
>  create mode 100644 drivers/net/phy/nxp-c45.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index a008b70f3c16..082a5eca8913 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -12518,6 +12518,12 @@ F:	drivers/nvmem/
>  F:	include/linux/nvmem-consumer.h
>  F:	include/linux/nvmem-provider.h
>  
> +NXP C45 PHY DRIVER
> +M:	Radu Pirea <radu-nicolae.pirea@oss.nxp.com>
> +L:	netdev@vger.kernel.org
> +S:	Maintained
> +F:	drivers/net/phy/nxp-c45.c
> +
>  NXP FSPI DRIVER
>  M:	Ashish Kumar <ashish.kumar@nxp.com>
>  R:	Yogesh Gaur <yogeshgaur.83@gmail.com>
> diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
> index 698bea312adc..fd2da80b5339 100644
> --- a/drivers/net/phy/Kconfig
> +++ b/drivers/net/phy/Kconfig
> @@ -228,6 +228,12 @@ config NATIONAL_PHY
>  	help
>  	  Currently supports the DP83865 PHY.
>  
> +config NXP_C45_PHY
> +	tristate "NXP C45 PHYs"
> +	help
> +	  Enable support for NXP C45 PHYs.
> +	  Currently supports only the TJA1103 PHY.
> +
>  config NXP_TJA11XX_PHY
>  	tristate "NXP TJA11xx PHYs support"
>  	depends on HWMON
> diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
> index a13e402074cf..a18f095748b5 100644
> --- a/drivers/net/phy/Makefile
> +++ b/drivers/net/phy/Makefile
> @@ -70,6 +70,7 @@ obj-$(CONFIG_MICROCHIP_PHY)	+= microchip.o
>  obj-$(CONFIG_MICROCHIP_T1_PHY)	+= microchip_t1.o
>  obj-$(CONFIG_MICROSEMI_PHY)	+= mscc/
>  obj-$(CONFIG_NATIONAL_PHY)	+= national.o
> +obj-$(CONFIG_NXP_C45_PHY)	+= nxp-c45.o
>  obj-$(CONFIG_NXP_TJA11XX_PHY)	+= nxp-tja11xx.o
>  obj-$(CONFIG_QSEMI_PHY)		+= qsemi.o
>  obj-$(CONFIG_REALTEK_PHY)	+= realtek.o
> diff --git a/drivers/net/phy/nxp-c45.c b/drivers/net/phy/nxp-c45.c
> new file mode 100644
> index 000000000000..2961799f7d05
> --- /dev/null
> +++ b/drivers/net/phy/nxp-c45.c
> @@ -0,0 +1,622 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* NXP C45 PHY driver
> + * Copyright (C) 2021 NXP
> + * Copyright (C) 2021 Radu Pirea <radu-nicolae.pirea@oss.nxp.com>
> + */
> +
> +#include <linux/delay.h>
> +#include <linux/ethtool.h>
> +#include <linux/ethtool_netlink.h>
> +#include <linux/kernel.h>
> +#include <linux/mii.h>
> +#include <linux/module.h>
> +#include <linux/phy.h>
> +#include <linux/processor.h>
> +#include <linux/property.h>
> +
> +#define PHY_ID_BASE_T1			0x001BB010
> +
> +#define B100T1_PMAPMD_CTL		0x0834
> +#define B100T1_PMAPMD_CONFIG_EN		BIT(15)
> +#define B100T1_PMAPMD_MASTER		BIT(14)
> +#define MASTER_MODE			(B100T1_PMAPMD_CONFIG_EN | B100T1_PMAPMD_MASTER)
> +#define SLAVE_MODE			(B100T1_PMAPMD_CONFIG_EN)
> +
> +#define DEVICE_CONTROL			0x0040
> +#define DEVICE_CONTROL_RESET		BIT(15)
> +#define DEVICE_CONTROL_CONFIG_GLOBAL_EN	BIT(14)
> +#define DEVICE_CONTROL_CONFIG_ALL_EN	BIT(13)
> +#define RESET_POLL_NS			(250 * NSEC_PER_MSEC)
> +
> +#define PHY_CONTROL			0x8100
> +#define PHY_CONFIG_EN			BIT(14)
> +#define PHY_START_OP			BIT(0)
> +
> +#define PHY_CONFIG			0x8108
> +#define PHY_CONFIG_AUTO			BIT(0)
> +
> +#define SIGNAL_QUALITY			0x8320
> +#define SQI_VALID			BIT(14)
> +#define SQI_MASK			GENMASK(2, 0)
> +#define MAX_SQI				SQI_MASK
> +
> +#define CABLE_TEST			0x8330
> +#define CABLE_TEST_ENABLE		BIT(15)
> +#define CABLE_TEST_START		BIT(14)
> +#define CABLE_TEST_VALID		BIT(13)
> +#define CABLE_TEST_OK			0x00
> +#define CABLE_TEST_SHORTED		0x01
> +#define CABLE_TEST_OPEN			0x02
> +#define CABLE_TEST_UNKNOWN		0x07
> +
> +#define PORT_CONTROL			0x8040
> +#define PORT_CONTROL_EN			BIT(14)
> +
> +#define PORT_INFRA_CONTROL		0xAC00
> +#define PORT_INFRA_CONTROL_EN		BIT(14)
> +
> +#define VND1_RXID			0xAFCC
> +#define VND1_TXID			0xAFCD
> +#define ID_ENABLE			BIT(15)
> +
> +#define ABILITIES			0xAFC4
> +#define RGMII_ID_ABILITY		BIT(15)
> +#define RGMII_ABILITY			BIT(14)
> +#define RMII_ABILITY			BIT(10)
> +#define REVMII_ABILITY			BIT(9)
> +#define MII_ABILITY			BIT(8)
> +#define SGMII_ABILITY			BIT(0)
> +
> +#define MII_BASIC_CONFIG		0xAFC6
> +#define MII_BASIC_CONFIG_REV		BIT(8)
> +#define MII_BASIC_CONFIG_SGMII		0x9
> +#define MII_BASIC_CONFIG_RGMII		0x7
> +#define MII_BASIC_CONFIG_RMII		0x5
> +#define MII_BASIC_CONFIG_MII		0x4
> +
> +#define SYMBOL_ERROR_COUNTER		0x8350
> +#define LINK_DROP_COUNTER		0x8352
> +#define LINK_LOSSES_AND_FAILURES	0x8353
> +#define R_GOOD_FRAME_CNT		0xA950
> +#define R_BAD_FRAME_CNT			0xA952
> +#define R_RXER_FRAME_CNT		0xA954
> +#define RX_PREAMBLE_COUNT		0xAFCE
> +#define TX_PREAMBLE_COUNT		0xAFCF
> +#define RX_IPG_LENGTH			0xAFD0
> +#define TX_IPG_LENGTH			0xAFD1
> +#define COUNTERS_EN			BIT(15)
> +
> +#define CLK_25MHZ_PS_PERIOD		40000UL
> +#define PS_PER_DEGREE			(CLK_25MHZ_PS_PERIOD / 360)
> +#define MIN_ID_PS			8222U
> +#define MAX_ID_PS			11300U
> +
> +struct nxp_c45_phy {
> +	u32 tx_delay;
> +	u32 rx_delay;
> +};
> +
> +struct nxp_c45_phy_stats {
> +	const char	*name;
> +	u8		mmd;
> +	u16		reg;
> +	u8		off;
> +	u16		mask;
> +};
> +
> +static const struct nxp_c45_phy_stats nxp_c45_hw_stats[] = {
> +	{ "phy_symbol_error_cnt", MDIO_MMD_VEND1, SYMBOL_ERROR_COUNTER, 0, GENMASK(15, 0) },
> +	{ "phy_link_status_drop_cnt", MDIO_MMD_VEND1, LINK_DROP_COUNTER, 8, GENMASK(13, 8) },
> +	{ "phy_link_availability_drop_cnt", MDIO_MMD_VEND1, LINK_DROP_COUNTER, 0, GENMASK(5, 0) },
> +	{ "phy_link_loss_cnt", MDIO_MMD_VEND1, LINK_LOSSES_AND_FAILURES, 10, GENMASK(15, 10) },
> +	{ "phy_link_failure_cnt", MDIO_MMD_VEND1, LINK_LOSSES_AND_FAILURES, 0, GENMASK(9, 0) },
> +	{ "r_good_frame_cnt", MDIO_MMD_VEND1, R_GOOD_FRAME_CNT, 0, GENMASK(15, 0) },
> +	{ "r_bad_frame_cnt", MDIO_MMD_VEND1, R_BAD_FRAME_CNT, 0, GENMASK(15, 0) },
> +	{ "r_rxer_frame_cnt", MDIO_MMD_VEND1, R_RXER_FRAME_CNT, 0, GENMASK(15, 0) },
> +	{ "rx_preamble_count", MDIO_MMD_VEND1, RX_PREAMBLE_COUNT, 0, GENMASK(5, 0) },
> +	{ "tx_preamble_count", MDIO_MMD_VEND1, TX_PREAMBLE_COUNT, 0, GENMASK(5, 0) },
> +	{ "rx_ipg_length", MDIO_MMD_VEND1, RX_IPG_LENGTH, 0, GENMASK(8, 0) },
> +	{ "tx_ipg_length", MDIO_MMD_VEND1, TX_IPG_LENGTH, 0, GENMASK(8, 0) },
> +};
> +
> +static int nxp_c45_get_sset_count(struct phy_device *phydev)
> +{
> +	return ARRAY_SIZE(nxp_c45_hw_stats);
> +}
> +
> +static void nxp_c45_get_strings(struct phy_device *phydev, u8 *data)
> +{
> +	size_t i;
> +
> +	for (i = 0; i < ARRAY_SIZE(nxp_c45_hw_stats); i++) {
> +		strncpy(data + i * ETH_GSTRING_LEN,
> +			nxp_c45_hw_stats[i].name, ETH_GSTRING_LEN);
> +	}
> +}
> +
> +static void nxp_c45_get_stats(struct phy_device *phydev,
> +			      struct ethtool_stats *stats, u64 *data)
> +{
> +	size_t i;
> +	int ret;
> +
> +	for (i = 0; i < ARRAY_SIZE(nxp_c45_hw_stats); i++) {
> +		ret = phy_read_mmd(phydev, nxp_c45_hw_stats[i].mmd, nxp_c45_hw_stats[i].reg);
> +		if (ret < 0) {
> +			data[i] = U64_MAX;
> +		} else {
> +			data[i] = ret & nxp_c45_hw_stats[i].mask;
> +			data[i] >>= nxp_c45_hw_stats[i].off;
> +		}
> +	}
> +}
> +
> +static int nxp_c45_config_enable(struct phy_device *phydev)
> +{
> +	phy_write_mmd(phydev, MDIO_MMD_VEND1, DEVICE_CONTROL, DEVICE_CONTROL_CONFIG_GLOBAL_EN |
> +		      DEVICE_CONTROL_CONFIG_ALL_EN);
> +	usleep_range(400, 450);
> +
> +	phy_write_mmd(phydev, MDIO_MMD_VEND1, PORT_CONTROL, PORT_CONTROL_EN);
> +	phy_write_mmd(phydev, MDIO_MMD_VEND1, PHY_CONTROL, PHY_CONFIG_EN);
> +	phy_write_mmd(phydev, MDIO_MMD_VEND1, PORT_INFRA_CONTROL, PORT_INFRA_CONTROL_EN);
> +
> +	return 0;
> +}
> +
> +static int nxp_c45_start_op(struct phy_device *phydev)
> +{
> +	int reg;
> +
> +	reg = phy_read_mmd(phydev, MDIO_MMD_VEND1, PHY_CONTROL);
> +	reg |= PHY_START_OP;
> +
> +	return phy_write_mmd(phydev, MDIO_MMD_VEND1, PHY_CONTROL, reg);

You may want to use phy_set_bits_mmd() here. Similar comment
applies to other places in the driver where phy_clear_bits_mmd()
and phy_modify_mmd() could be used.

> +}
> +
> +static bool nxp_c45_can_sleep(struct phy_device *phydev)
> +{
> +	int reg;
> +
> +	reg = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_STAT1);
> +	if (reg < 0)
> +		return false;
> +
> +	return !!(reg & MDIO_STAT1_LPOWERABLE);
> +}
> +
> +static int nxp_c45_resume(struct phy_device *phydev)
> +{
> +	int reg;
> +
> +	if (!nxp_c45_can_sleep(phydev))
> +		return -EOPNOTSUPP;
> +
> +	reg = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_CTRL1);
> +	reg &= ~MDIO_CTRL1_LPOWER;
> +	phy_write_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_CTRL1, reg);
> +
> +	return 0;
> +}
> +
> +static int nxp_c45_suspend(struct phy_device *phydev)
> +{
> +	int reg;
> +
> +	if (!nxp_c45_can_sleep(phydev))
> +		return -EOPNOTSUPP;
> +
> +	reg = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_CTRL1);
> +	reg |= MDIO_CTRL1_LPOWER;
> +	phy_write_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_CTRL1, reg);
> +
> +	return 0;
> +}
> +
> +static int nxp_c45_reset_done(struct phy_device *phydev)
> +{
> +	return !(phy_read_mmd(phydev, MDIO_MMD_VEND1, DEVICE_CONTROL) & DEVICE_CONTROL_RESET);
> +}
> +
> +static int nxp_c45_reset_done_or_timeout(struct phy_device *phydev,
> +					 ktime_t timeout)
> +{
> +	ktime_t cur = ktime_get();
> +
> +	return nxp_c45_reset_done(phydev) || ktime_after(cur, timeout);
> +}
> +
> +static int nxp_c45_soft_reset(struct phy_device *phydev)
> +{
> +	ktime_t timeout;
> +	int ret;
> +
> +	ret = phy_write_mmd(phydev, MDIO_MMD_VEND1, DEVICE_CONTROL, DEVICE_CONTROL_RESET);
> +	if (ret)
> +		return ret;
> +
> +	timeout = ktime_add_ns(ktime_get(), RESET_POLL_NS);
> +	spin_until_cond(nxp_c45_reset_done_or_timeout(phydev, timeout));
> +	if (!nxp_c45_reset_done(phydev)) {
> +		phydev_err(phydev, "reset fail\n");
> +		return -EIO;
> +	}
> +	return 0;
> +}
> +
> +static int nxp_c45_cable_test_start(struct phy_device *phydev)
> +{
> +	return phy_write_mmd(phydev, MDIO_MMD_VEND1, CABLE_TEST,
> +			     CABLE_TEST_ENABLE | CABLE_TEST_START);
> +}
> +
> +static int nxp_c45_cable_test_get_status(struct phy_device *phydev,
> +					 bool *finished)
> +{
> +	int ret;
> +	u8 cable_test_result;
> +
> +	ret = phy_read_mmd(phydev, MDIO_MMD_VEND1, CABLE_TEST);
> +	if (!(ret & CABLE_TEST_VALID)) {
> +		*finished = false;
> +		return 0;
> +	}
> +
> +	*finished = true;
> +	cable_test_result = ret & GENMASK(2, 0);
> +
> +	switch (cable_test_result) {
> +	case CABLE_TEST_OK:
> +		ethnl_cable_test_result(phydev, ETHTOOL_A_CABLE_PAIR_A,
> +					ETHTOOL_A_CABLE_RESULT_CODE_OK);
> +		break;
> +	case CABLE_TEST_SHORTED:
> +		ethnl_cable_test_result(phydev, ETHTOOL_A_CABLE_PAIR_A,
> +					ETHTOOL_A_CABLE_RESULT_CODE_SAME_SHORT);
> +		break;
> +	case CABLE_TEST_OPEN:
> +		ethnl_cable_test_result(phydev, ETHTOOL_A_CABLE_PAIR_A,
> +					ETHTOOL_A_CABLE_RESULT_CODE_OPEN);
> +		break;
> +	default:
> +		ethnl_cable_test_result(phydev, ETHTOOL_A_CABLE_PAIR_A,
> +					ETHTOOL_A_CABLE_RESULT_CODE_UNSPEC);
> +	}
> +
> +	phy_write_mmd(phydev, MDIO_MMD_VEND1, CABLE_TEST, 0);
> +
> +	return nxp_c45_start_op(phydev);
> +}
> +
> +static int nxp_c45_setup_master_slave(struct phy_device *phydev)
> +{
> +	switch (phydev->master_slave_set) {
> +	case MASTER_SLAVE_CFG_MASTER_FORCE:
> +	case MASTER_SLAVE_CFG_MASTER_PREFERRED:
> +		phy_write_mmd(phydev, MDIO_MMD_PMAPMD, B100T1_PMAPMD_CTL, MASTER_MODE);
> +		break;
> +	case MASTER_SLAVE_CFG_SLAVE_PREFERRED:
> +	case MASTER_SLAVE_CFG_SLAVE_FORCE:
> +		phy_write_mmd(phydev, MDIO_MMD_PMAPMD, B100T1_PMAPMD_CTL, SLAVE_MODE);
> +		break;
> +	case MASTER_SLAVE_CFG_UNKNOWN:
> +	case MASTER_SLAVE_CFG_UNSUPPORTED:
> +		return 0;
> +	default:
> +		phydev_warn(phydev, "Unsupported Master/Slave mode\n");
> +		return -EOPNOTSUPP;
> +	}
> +
> +	return 0;
> +}
> +
> +static int nxp_c45_read_master_slave(struct phy_device *phydev)
> +{
> +	int reg;
> +
> +	phydev->master_slave_get = MASTER_SLAVE_CFG_UNKNOWN;
> +	phydev->master_slave_state = MASTER_SLAVE_STATE_UNKNOWN;
> +
> +	reg = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, B100T1_PMAPMD_CTL);
> +	if (reg < 0)
> +		return reg;
> +
> +	if (reg & B100T1_PMAPMD_MASTER) {
> +		phydev->master_slave_get = MASTER_SLAVE_CFG_MASTER_FORCE;
> +		phydev->master_slave_state = MASTER_SLAVE_STATE_MASTER;
> +	} else {
> +		phydev->master_slave_get = MASTER_SLAVE_CFG_SLAVE_FORCE;
> +		phydev->master_slave_state = MASTER_SLAVE_STATE_SLAVE;
> +	}
> +
> +	return 0;
> +}
> +
> +static int nxp_c45_config_aneg(struct phy_device *phydev)
> +{
> +	return nxp_c45_setup_master_slave(phydev);
> +}
> +
> +static int nxp_c45_read_status(struct phy_device *phydev)
> +{
> +	int ret;
> +
> +	ret = genphy_c45_read_status(phydev);
> +	if (ret)
> +		return ret;
> +
> +	ret = nxp_c45_read_master_slave(phydev);
> +	if (ret)
> +		return ret;
> +
> +	return 0;
> +}
> +
> +static int nxp_c45_set_loopback(struct phy_device *phydev, bool enable)
> +{
> +	int reg;
> +
> +	reg = phy_read_mmd(phydev, MDIO_MMD_PCS, MDIO_CTRL1);
> +	if (reg < 0)
> +		return reg;
> +
> +	if (enable)
> +		reg |= MDIO_PCS_CTRL1_LOOPBACK;
> +	else
> +		reg &= ~MDIO_PCS_CTRL1_LOOPBACK;
> +
> +	phy_write_mmd(phydev, MDIO_MMD_PCS, MDIO_CTRL1, reg);
> +
> +	phydev->loopback_enabled = enable;
> +
> +	phydev_dbg(phydev, "Loopback %s\n", enable ? "enabled" : "disabled");
> +
> +	return 0;
> +}
> +
> +static int nxp_c45_get_sqi(struct phy_device *phydev)
> +{
> +	int reg;
> +
> +	reg = phy_read_mmd(phydev, MDIO_MMD_VEND1, SIGNAL_QUALITY);
> +	if (!(reg & SQI_VALID))
> +		return -EINVAL;
> +
> +	reg &= SQI_MASK;
> +
> +	return reg;
> +}
> +
> +static int nxp_c45_get_sqi_max(struct phy_device *phydev)
> +{
> +	return MAX_SQI;
> +}
> +
> +static int nxp_c45_check_delay(struct phy_device *phydev, u32 delay)
> +{
> +	if (delay < MIN_ID_PS) {
> +		phydev_err(phydev, "delay value smaller than %u\n", MIN_ID_PS);
> +		return -EINVAL;
> +	}
> +
> +	if (delay > MAX_ID_PS) {
> +		phydev_err(phydev, "delay value higher than %u\n", MAX_ID_PS);
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static u64 nxp_c45_get_phase_shift(u64 phase_offset_raw)
> +{
> +	/* The delay in degree phase is 73.8 + phase_offset_raw * 0.9.
> +	 * To avoid floating point operations we'll multiply by 10
> +	 * and get 1 decimal point precision.
> +	 */
> +	phase_offset_raw *= 10;
> +	return (phase_offset_raw - 738) / 9;
> +}
> +
> +static void nxp_c45_set_delays(struct phy_device *phydev)
> +{
> +	struct nxp_c45_phy *priv = phydev->priv;
> +	u64 tx_delay = priv->tx_delay;
> +	u64 rx_delay = priv->rx_delay;
> +	u64 degree;
> +
> +	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
> +	    phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID) {
> +		degree = tx_delay / PS_PER_DEGREE;
> +		phy_write_mmd(phydev, MDIO_MMD_VEND1, VND1_TXID,
> +			      ID_ENABLE | nxp_c45_get_phase_shift(degree));
> +	}
> +
> +	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
> +	    phydev->interface == PHY_INTERFACE_MODE_RGMII_RXID) {
> +		degree = rx_delay / PS_PER_DEGREE;
> +		phy_write_mmd(phydev, MDIO_MMD_VEND1, VND1_RXID,
> +			      ID_ENABLE | nxp_c45_get_phase_shift(degree));
> +	}
> +}
> +
> +static int nxp_c45_get_delays(struct phy_device *phydev)
> +{
> +	struct nxp_c45_phy *priv = phydev->priv;
> +	int ret;
> +
> +	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
> +	    phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID) {
> +		ret = device_property_read_u32(&phydev->mdio.dev, "tx-internal-delay-ps",
> +					       &priv->tx_delay);
> +		if (ret) {
> +			phydev_err(phydev, "tx-internal-delay-ps property missing\n");
> +			return ret;
> +		}
> +		ret = nxp_c45_check_delay(phydev, priv->tx_delay);
> +		if (ret) {
> +			phydev_err(phydev, "tx-internal-delay-ps invalid value\n");
> +			return ret;
> +		}
> +	}
> +
> +	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
> +	    phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID) {
> +		ret = device_property_read_u32(&phydev->mdio.dev, "rx-internal-delay-ps",
> +					       &priv->rx_delay);
> +		if (ret) {
> +			phydev_err(phydev, "rx-internal-delay-ps property missing\n");
> +			return ret;
> +		}
> +		ret = nxp_c45_check_delay(phydev, priv->rx_delay);
> +		if (ret) {
> +			phydev_err(phydev, "rx-internal-delay-ps invalid value\n");
> +			return ret;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static int nxp_c45_set_phy_mode(struct phy_device *phydev)
> +{
> +	int ret;
> +
> +	ret = phy_read_mmd(phydev, MDIO_MMD_VEND1, ABILITIES);
> +	phydev_dbg(phydev, "Clause 45 managed PHY abilities 0x%x\n", ret);
> +
> +	switch (phydev->interface) {
> +	case PHY_INTERFACE_MODE_RGMII:
> +		if (!(ret & RGMII_ABILITY)) {
> +			phydev_err(phydev, "rgmii mode not supported\n");
> +			return -EINVAL;
> +		}
> +		phy_write_mmd(phydev, MDIO_MMD_VEND1, MII_BASIC_CONFIG, MII_BASIC_CONFIG_RGMII);
> +		break;
> +	case PHY_INTERFACE_MODE_RGMII_ID:
> +	case PHY_INTERFACE_MODE_RGMII_TXID:
> +	case PHY_INTERFACE_MODE_RGMII_RXID:
> +		if (!(ret & RGMII_ID_ABILITY)) {
> +			phydev_err(phydev, "rgmii-id, rgmii-txid, rgmii-rxid modes are not supported\n");
> +			return -EINVAL;
> +		}
> +		phy_write_mmd(phydev, MDIO_MMD_VEND1, MII_BASIC_CONFIG, MII_BASIC_CONFIG_RGMII);
> +		ret = nxp_c45_get_delays(phydev);
> +		if (ret)
> +			return ret;
> +
> +		nxp_c45_set_delays(phydev);
> +		break;
> +	case PHY_INTERFACE_MODE_MII:
> +		if (!(ret & MII_ABILITY)) {
> +			phydev_err(phydev, "mii mode not supported\n");
> +			return -EINVAL;
> +		}
> +		phy_write_mmd(phydev, MDIO_MMD_VEND1, MII_BASIC_CONFIG, MII_BASIC_CONFIG_MII);
> +		break;
> +	case PHY_INTERFACE_MODE_REVMII:
> +		if (!(ret & REVMII_ABILITY)) {
> +			phydev_err(phydev, "rev-mii mode not supported\n");
> +			return -EINVAL;
> +		}
> +		phy_write_mmd(phydev, MDIO_MMD_VEND1, MII_BASIC_CONFIG, MII_BASIC_CONFIG_MII |
> +			      MII_BASIC_CONFIG_REV);
> +		break;
> +	case PHY_INTERFACE_MODE_RMII:
> +		if (!(ret & RMII_ABILITY)) {
> +			phydev_err(phydev, "rmii mode not supported\n");
> +			return -EINVAL;
> +		}
> +		phy_write_mmd(phydev, MDIO_MMD_VEND1, MII_BASIC_CONFIG, MII_BASIC_CONFIG_RMII);
> +		break;
> +	case PHY_INTERFACE_MODE_SGMII:
> +		if (!(ret & SGMII_ABILITY)) {
> +			phydev_err(phydev, "sgmii mode not supported\n");
> +			return -EINVAL;
> +		}
> +		phy_write_mmd(phydev, MDIO_MMD_VEND1, MII_BASIC_CONFIG, MII_BASIC_CONFIG_SGMII);
> +		break;
> +	case PHY_INTERFACE_MODE_INTERNAL:
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static int nxp_c45_config_init(struct phy_device *phydev)
> +{
> +	int ret;
> +
> +	ret = nxp_c45_config_enable(phydev);
> +	if (ret) {
> +		phydev_err(phydev, "Failed to enable config\n");
> +		return ret;
> +	}
> +
> +	ret = phy_read_mmd(phydev, MDIO_MMD_VEND1, PHY_CONFIG);
> +	ret &= ~PHY_CONFIG_AUTO;
> +	phy_write_mmd(phydev, MDIO_MMD_VEND1, PHY_CONFIG, ret);
> +
> +	phy_write_mmd(phydev, MDIO_MMD_VEND1, LINK_DROP_COUNTER, COUNTERS_EN);
> +	phy_write_mmd(phydev, MDIO_MMD_VEND1, RX_PREAMBLE_COUNT, COUNTERS_EN);
> +	phy_write_mmd(phydev, MDIO_MMD_VEND1, TX_PREAMBLE_COUNT, COUNTERS_EN);
> +	phy_write_mmd(phydev, MDIO_MMD_VEND1, RX_IPG_LENGTH, COUNTERS_EN);
> +	phy_write_mmd(phydev, MDIO_MMD_VEND1, TX_IPG_LENGTH, COUNTERS_EN);
> +
> +	ret = nxp_c45_set_phy_mode(phydev);
> +	if (ret)
> +		return ret;
> +
> +	phydev->autoneg = AUTONEG_DISABLE;
> +
> +	return nxp_c45_start_op(phydev);
> +}
> +
> +static int nxp_c45_probe(struct phy_device *phydev)
> +{
> +	struct nxp_c45_phy *priv;
> +
> +	priv = devm_kzalloc(&phydev->mdio.dev, sizeof(*priv), GFP_KERNEL);
> +	if (!priv)
> +		return -ENOMEM;
> +
> +	phydev->priv = priv;
> +
> +	return 0;
> +}
> +
> +static struct phy_driver nxp_c45_driver[] = {
> +	{
> +		PHY_ID_MATCH_MODEL(PHY_ID_BASE_T1),
> +		.name			= "NXP C45 BASE-T1",
> +		.features		= PHY_BASIC_T1_FEATURES,
> +		.probe			= nxp_c45_probe,
> +		.soft_reset		= nxp_c45_soft_reset,
> +		.config_aneg		= nxp_c45_config_aneg,
> +		.config_init		= nxp_c45_config_init,
> +		.read_status		= nxp_c45_read_status,
> +		.suspend		= nxp_c45_suspend,
> +		.resume			= nxp_c45_resume,
> +		.get_sset_count		= nxp_c45_get_sset_count,
> +		.get_strings		= nxp_c45_get_strings,
> +		.get_stats		= nxp_c45_get_stats,
> +		.cable_test_start	= nxp_c45_cable_test_start,
> +		.cable_test_get_status	= nxp_c45_cable_test_get_status,
> +		.set_loopback		= nxp_c45_set_loopback,
> +		.get_sqi		= nxp_c45_get_sqi,
> +		.get_sqi_max		= nxp_c45_get_sqi_max,

How about interrupt support?

> +	},
> +};
> +
> +module_phy_driver(nxp_c45_driver);
> +
> +static struct mdio_device_id __maybe_unused nxp_c45_tbl[] = {
> +	{ PHY_ID_MATCH_MODEL(PHY_ID_BASE_T1) }
> +};
> +
> +MODULE_DEVICE_TABLE(mdio, nxp_c45_tbl);
> +
> +MODULE_AUTHOR("Radu Pirea <radu-nicolae.pirea@oss.nxp.com>");
> +MODULE_DESCRIPTION("NXP C45 PHY driver");
> +MODULE_LICENSE("GPL v2");
> 

