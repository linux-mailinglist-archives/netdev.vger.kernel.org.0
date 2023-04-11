Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4069B6DE174
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 18:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbjDKQty (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 12:49:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230261AbjDKQts (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 12:49:48 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 809A91B0
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 09:49:47 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id v29so8261070wra.13
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 09:49:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681231786; x=1683823786;
        h=content-transfer-encoding:in-reply-to:subject:from:content-language
         :references:cc:to:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SmBFmfbz/44YbW/CVA+1OKRo8ZXmvv53brsDbeyxfPE=;
        b=TiyoqyKeGw65KAvewjQAJz7my2YZ1qQkJasJQfsY8rx5xU+4FoJWCYSrUDHvR1IXmL
         in3QbTYwAUC3m+wA2QvkZOECViB2p8AnQRI0/CHsKwTherFErZy8/4Th43/3aqW9KJ42
         R2T8hkHksPImz+jHlNhjSxTErF0nuVpX1p2iac3qi18Ep/+LHO+tzDeLknMVkIbSU7nP
         4DyT6dtyejcjyf4qrHVDDp6FrqDTP4Pyc7TEv6mJJIhnieqGgRVXeCuDPDBSpf9YKXqP
         YBbtrdBDsrJTA9Wq6efpJ5/N3CGhjHgtiq3SjeKTgP/eJSBOgP2bFiFU3H/2i5s88o6f
         KjzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681231786; x=1683823786;
        h=content-transfer-encoding:in-reply-to:subject:from:content-language
         :references:cc:to:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SmBFmfbz/44YbW/CVA+1OKRo8ZXmvv53brsDbeyxfPE=;
        b=d5K1EStvwzN0aWjVahDJglwDuIufy9HOQvlR0QdbeKJqBmGMoyXsspGsVve2J9ie33
         bRKE0v48LSRgifPVc9J6EQlqgbN+cKNZophho8kouqS5M9D8P58nprh8lxNhKZopZjpk
         rSYhGLyW6DWiAMHy53KMTZ4X7X9NvAPMbd+PMTzGjoOxMKveuZt65c/I3JlA0NZdq8jn
         l0bKIco4H8Fnw2Cx/2/rrqkEfLqn2t0JZBgicvj3OC4ZmMZYKMx7i+B9UKJq9zacOTId
         kXVNxItpSTXeWwFZyvJbhXNJ5B6JqeXlC1kpRlstmX4kUUQkkm9UpnzJgrtomH1e/rae
         jYSA==
X-Gm-Message-State: AAQBX9c1w2JdOWyZ5jCwA1D8yweMAtxlr11MMS5iHzT0Xtu2CqbeViWm
        TaKJecbmt7hgIV/j4wgu5rc=
X-Google-Smtp-Source: AKy350agJF6zz2xZ7wIFCoJndrXbo0ygfaj/09oV+UBtds/5TlEpbGH9G1ZO/GfkR4/JGai3URHp/Q==
X-Received: by 2002:adf:dfcc:0:b0:2ef:af46:1278 with SMTP id q12-20020adfdfcc000000b002efaf461278mr9486942wrn.10.1681231785732;
        Tue, 11 Apr 2023 09:49:45 -0700 (PDT)
Received: from ?IPV6:2a01:c23:c4bb:c200:90e3:4731:63e4:d333? (dynamic-2a01-0c23-c4bb-c200-90e3-4731-63e4-d333.c23.pool.telefonica.de. [2a01:c23:c4bb:c200:90e3:4731:63e4:d333])
        by smtp.googlemail.com with ESMTPSA id iz11-20020a05600c554b00b003f09aaf547asm293304wmb.1.2023.04.11.09.49.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Apr 2023 09:49:45 -0700 (PDT)
Message-ID: <e2ea17e9-2c6a-9a89-bb09-29eca8dbf6bc@gmail.com>
Date:   Tue, 11 Apr 2023 18:49:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>, Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <20230411155706.1713311-1-vladimir.oltean@nxp.com>
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next] net: phy: add basic driver for NXP CBTX PHY
In-Reply-To: <20230411155706.1713311-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11.04.2023 17:57, Vladimir Oltean wrote:
> The CBTX PHY is a Fast Ethernet PHY integrated into the SJA1110 A/B/C
> automotive Ethernet switches.
> 
> It was hoped it would work with the Generic PHY driver, but alas, it
> doesn't. The most important reason why is that the PHY is powered down
> by default, and it needs a vendor register to power it on.
> 
> It has a linear memory map that is accessed over SPI by the SJA1110
> switch driver, which exposes a fake MDIO controller. It has the
> following (and only the following) standard clause 22 registers:
> 
> 0x0: MII_BMCR
> 0x1: MII_BMSR
> 0x2: MII_PHYSID1
> 0x3: MII_PHYSID2
> 0x4: MII_ADVERTISE
> 0x5: MII_LPA
> 0x6: MII_EXPANSION
> 0x7: the missing MII_NPAGE for Next Page Transmit Register
> 
> Every other register is vendor-defined.
> 
> The register map expands the standard clause 22 5-bit address space of
> 0x20 registers, however the driver does not need to access the extra
> registers for now (and hopefully never). If it ever needs to do that, it
> is possible to implement a fake (software) page switching mechanism
> between the PHY driver and the SJA1110 MDIO controller driver.
> 
> Also, Auto-MDIX is turned off by default in hardware, the driver turns
> it on by default and reports the current status. I've tested this with a
> VSC8514 link partner and a crossover cable, by forcing the mode on the
> link partner, and seeing that the CBTX PHY always sees the reverse of
> the mode forced on the VSC8514 (and that traffic works). The link
> doesn't come up (as expected) if MDI modes are forced on both ends in
> the same way (with the cross-over cable, that is).
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  drivers/net/phy/Kconfig    |   6 +
>  drivers/net/phy/Makefile   |   1 +
>  drivers/net/phy/nxp-cbtx.c | 251 +++++++++++++++++++++++++++++++++++++
>  3 files changed, 258 insertions(+)
>  create mode 100644 drivers/net/phy/nxp-cbtx.c
> 
> diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
> index 6b9525def973..eae6fc697ba3 100644
> --- a/drivers/net/phy/Kconfig
> +++ b/drivers/net/phy/Kconfig
> @@ -265,6 +265,12 @@ config NATIONAL_PHY
>  	help
>  	  Currently supports the DP83865 PHY.
>  
> +config NXP_CBTX_PHY
> +	tristate "NXP 100BASE-TX PHYs"
> +	help
> +	  Support the 100BASE-TX PHY integrated on the SJA1110 automotive
> +	  switch family.
> +
>  config NXP_C45_TJA11XX_PHY
>  	tristate "NXP C45 TJA11XX PHYs"
>  	depends on PTP_1588_CLOCK_OPTIONAL
> diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
> index b5138066ba04..ae11bf20b46e 100644
> --- a/drivers/net/phy/Makefile
> +++ b/drivers/net/phy/Makefile
> @@ -79,6 +79,7 @@ obj-$(CONFIG_MOTORCOMM_PHY)	+= motorcomm.o
>  obj-$(CONFIG_NATIONAL_PHY)	+= national.o
>  obj-$(CONFIG_NCN26000_PHY)	+= ncn26000.o
>  obj-$(CONFIG_NXP_C45_TJA11XX_PHY)	+= nxp-c45-tja11xx.o
> +obj-$(CONFIG_NXP_CBTX_PHY)	+= nxp-cbtx.o
>  obj-$(CONFIG_NXP_TJA11XX_PHY)	+= nxp-tja11xx.o
>  obj-$(CONFIG_QSEMI_PHY)		+= qsemi.o
>  obj-$(CONFIG_REALTEK_PHY)	+= realtek.o
> diff --git a/drivers/net/phy/nxp-cbtx.c b/drivers/net/phy/nxp-cbtx.c
> new file mode 100644
> index 000000000000..936761ec516e
> --- /dev/null
> +++ b/drivers/net/phy/nxp-cbtx.c
> @@ -0,0 +1,251 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Driver for 100BASE-TX PHY embedded into NXP SJA1110 switch
> + *
> + * Copyright 2022-2023 NXP
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/mii.h>
> +#include <linux/module.h>
> +#include <linux/phy.h>
> +
> +#define PHY_ID_CBTX_SJA1110			0x001bb020
> +
> +/* Registers */
> +#define  CBTX_MODE_CTRL_STAT			0x11
> +#define  CBTX_PDOWN_CTRL			0x18
> +#define  CBTX_RX_ERR_COUNTER			0x1a
> +#define  CBTX_IRQ_STAT				0x1d
> +#define  CBTX_IRQ_ENABLE			0x1e
> +
> +/* Fields */
> +#define CBTX_MODE_CTRL_STAT_AUTO_MDIX_EN	BIT(7)
> +#define CBTX_MODE_CTRL_STAT_MDIX_MODE		BIT(6)
> +
> +#define CBTX_PDOWN_CTL_TRUE_PDOWN		BIT(0)
> +
> +#define CBTX_IRQ_ENERGYON			BIT(7)
> +#define CBTX_IRQ_AN_COMPLETE			BIT(6)
> +#define CBTX_IRQ_REM_FAULT			BIT(5)
> +#define CBTX_IRQ_LINK_DOWN			BIT(4)
> +#define CBTX_IRQ_AN_LP_ACK			BIT(3)
> +#define CBTX_IRQ_PARALLEL_DETECT_FAULT		BIT(2)
> +#define CBTX_IRQ_AN_PAGE_RECV			BIT(1)
> +
> +static int cbtx_soft_reset(struct phy_device *phydev)
> +{
> +	int ret;
> +
> +	/* Can't soft reset unless we remove PHY from true power down mode */
> +	ret = phy_clear_bits(phydev, CBTX_PDOWN_CTRL,
> +			     CBTX_PDOWN_CTL_TRUE_PDOWN);
> +	if (ret)
> +		return ret;
> +
> +	return genphy_soft_reset(phydev);
> +}
> +
> +static int cbtx_config_init(struct phy_device *phydev)
> +{
> +	/* Wait for cbtx_config_aneg() to kick in and apply this */
> +	phydev->mdix_ctrl = ETH_TP_MDI_AUTO;
> +
> +	return 0;
> +}
> +
> +static int cbtx_suspend(struct phy_device *phydev)
> +{
> +	int ret;
> +
> +	ret = genphy_suspend(phydev);
> +	if (ret)
> +		return ret;
> +
> +	return phy_set_bits(phydev, CBTX_PDOWN_CTRL,
> +			    CBTX_PDOWN_CTL_TRUE_PDOWN);

A comment may be helpful explaining how true_pdown mode
is different from power-down mode set by C22 standard
bit in BMCR as part of genphy_suspend().

> +}
> +
> +static int cbtx_resume(struct phy_device *phydev)
> +{
> +	int ret;
> +
> +	ret = phy_clear_bits(phydev, CBTX_PDOWN_CTRL,
> +			     CBTX_PDOWN_CTL_TRUE_PDOWN);
> +	if (ret)
> +		return ret;
> +
> +	return genphy_resume(phydev);
> +}
> +
> +static int cbtx_mdix_status(struct phy_device *phydev)
> +{
> +	int ret;
> +
> +	ret = phy_read(phydev, CBTX_MODE_CTRL_STAT);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (ret & CBTX_MODE_CTRL_STAT_MDIX_MODE)
> +		phydev->mdix = ETH_TP_MDI_X;
> +	else
> +		phydev->mdix = ETH_TP_MDI;
> +
> +	return 0;
> +}
> +
> +static int cbtx_read_status(struct phy_device *phydev)
> +{
> +	int ret;
> +
> +	ret = cbtx_mdix_status(phydev);
> +	if (ret)
> +		return ret;
> +
> +	return genphy_read_status(phydev);
> +}
> +
> +static int cbtx_mdix_config(struct phy_device *phydev)
> +{
> +	int ret;
> +
> +	switch (phydev->mdix_ctrl) {
> +	case ETH_TP_MDI_AUTO:
> +		return phy_set_bits(phydev, CBTX_MODE_CTRL_STAT,
> +				    CBTX_MODE_CTRL_STAT_AUTO_MDIX_EN);
> +	case ETH_TP_MDI:
> +		ret = phy_clear_bits(phydev, CBTX_MODE_CTRL_STAT,
> +				     CBTX_MODE_CTRL_STAT_AUTO_MDIX_EN);
> +		if (ret)
> +			return ret;
> +
> +		return phy_clear_bits(phydev, CBTX_MODE_CTRL_STAT,
> +				      CBTX_MODE_CTRL_STAT_MDIX_MODE);
> +	case ETH_TP_MDI_X:
> +		ret = phy_clear_bits(phydev, CBTX_MODE_CTRL_STAT,
> +				     CBTX_MODE_CTRL_STAT_AUTO_MDIX_EN);
> +		if (ret)
> +			return ret;
> +
> +		return phy_set_bits(phydev, CBTX_MODE_CTRL_STAT,
> +				    CBTX_MODE_CTRL_STAT_MDIX_MODE);
> +	}
> +
> +	return 0;
> +}
> +
> +static int cbtx_config_aneg(struct phy_device *phydev)
> +{
> +	int ret;
> +
> +	ret = cbtx_mdix_config(phydev);
> +	if (ret)
> +		return ret;
> +
> +	return genphy_config_aneg(phydev);
> +}
> +
> +static int cbtx_ack_interrupts(struct phy_device *phydev)
> +{
> +	return phy_read(phydev, CBTX_IRQ_STAT);
> +}
> +
> +static int cbtx_config_intr(struct phy_device *phydev)
> +{
> +	int ret;
> +
> +	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
> +		ret = cbtx_ack_interrupts(phydev);
> +		if (ret < 0)
> +			return ret;
> +
> +		ret = phy_write(phydev, CBTX_IRQ_ENABLE,
> +				CBTX_IRQ_AN_COMPLETE | CBTX_IRQ_LINK_DOWN);

I think you need also CBTX_IRQ_ENERGYON. Otherwise you won't get a
link-up interrupt in forced mode.

> +		if (ret)
> +			return ret;
> +	} else {
> +		ret = phy_write(phydev, CBTX_IRQ_ENABLE, 0);
> +		if (ret)
> +			return ret;
> +
> +		ret = cbtx_ack_interrupts(phydev);
> +		if (ret < 0)
> +			return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static irqreturn_t cbtx_handle_interrupt(struct phy_device *phydev)
> +{
> +	int irq_stat, irq_enabled;
> +
> +	irq_stat = cbtx_ack_interrupts(phydev);
> +	if (irq_stat < 0) {
> +		phy_error(phydev);
> +		return IRQ_NONE;
> +	}
> +
> +	irq_enabled = phy_read(phydev, CBTX_IRQ_ENABLE);
> +	if (irq_enabled < 0) {
> +		phy_error(phydev);
> +		return IRQ_NONE;
> +	}
> +
> +	if (!(irq_enabled & irq_stat))
> +		return IRQ_NONE;
> +
> +	phy_trigger_machine(phydev);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static int cbtx_get_sset_count(struct phy_device *phydev)
> +{
> +	return 1;
> +}
> +
> +static void cbtx_get_strings(struct phy_device *phydev, u8 *data)
> +{
> +	strncpy(data, "100btx_rx_err", ETH_GSTRING_LEN);
> +}
> +
> +static void cbtx_get_stats(struct phy_device *phydev,
> +			   struct ethtool_stats *stats, u64 *data)
> +{
> +	int ret;
> +
> +	ret = phy_read(phydev, CBTX_RX_ERR_COUNTER);
> +	data[0] = (ret < 0) ? U64_MAX : ret;
> +}
> +
> +static struct phy_driver cbtx_driver[] = {
> +	{
> +		PHY_ID_MATCH_MODEL(PHY_ID_CBTX_SJA1110),
> +		.name			= "NXP CBTX (SJA1110)",
> +		/* PHY_BASIC_FEATURES */
> +		.soft_reset		= cbtx_soft_reset,
> +		.config_init		= cbtx_config_init,
> +		.suspend		= cbtx_suspend,
> +		.resume			= cbtx_resume,
> +		.config_intr		= cbtx_config_intr,
> +		.handle_interrupt	= cbtx_handle_interrupt,
> +		.read_status		= cbtx_read_status,
> +		.config_aneg		= cbtx_config_aneg,
> +		.get_sset_count		= cbtx_get_sset_count,
> +		.get_strings		= cbtx_get_strings,
> +		.get_stats		= cbtx_get_stats,
> +	},
> +};
> +
> +module_phy_driver(cbtx_driver);
> +
> +static struct mdio_device_id __maybe_unused cbtx_tbl[] = {
> +	{ PHY_ID_MATCH_MODEL(PHY_ID_CBTX_SJA1110) },
> +	{ },
> +};
> +
> +MODULE_DEVICE_TABLE(mdio, cbtx_tbl);
> +
> +MODULE_AUTHOR("Vladimir Oltean <vladimir.oltean@nxp.com>");
> +MODULE_DESCRIPTION("NXP CBTX PHY driver");
> +MODULE_LICENSE("GPL");

