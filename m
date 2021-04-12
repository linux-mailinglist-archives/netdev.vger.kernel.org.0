Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ADA235C31C
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 12:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242787AbhDLJ5i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 05:57:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244083AbhDLJyu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 05:54:50 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B9A8C06138F;
        Mon, 12 Apr 2021 02:50:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=0UfDA/sQr+zdmclT4Oo7p8kfTePhSR650tmaVpnrbDI=; b=AOqjZOIof8IP30HVfsW8bXXL8
        nzxyKvCBKJhnEgQ9wyWD5qe2q3ipakjbGmjlReIW4Vh2YxDnxakEJbfpFkj6I/wi9P0QVKErT4jPV
        KaH3i+2e6izA7HLnGgYyFzAWAUeL3CX1zYeGTUZABjowWTE2uovBdjqDranMyrmATUMEqZm85pwCb
        /EtTc0DrX7hhZrjABT3rU8eeCUZOLaOSRh3h01TC7MqptZx4ehquIEAquGuu+oSKYvF2K5fiXNltw
        iMrRZT7iQkiRtb1zhkQFzEcDVmYn9oX3bATpvkDTVy8NzNV29WGwrBQIoUdO1O5r5b7QENp27iWwm
        E0baPHxrg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:52330)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lVtCy-0004Qr-MJ; Mon, 12 Apr 2021 10:50:17 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lVtCw-00079M-6r; Mon, 12 Apr 2021 10:50:14 +0100
Date:   Mon, 12 Apr 2021 10:50:14 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] phy: nxp-c45: add driver for tja1103
Message-ID: <20210412095012.GJ1463@shell.armlinux.org.uk>
References: <20210409184106.264463-1-radu-nicolae.pirea@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210409184106.264463-1-radu-nicolae.pirea@oss.nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 09, 2021 at 09:41:06PM +0300, Radu Pirea (NXP OSS) wrote:
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

Maybe include some prefix as to which MMD each of these registers is
located?

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

This looks like it could be useful as a generic helper function -
nothing in this function is specific to this PHY.

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

These too look like potential generic helper functions.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
