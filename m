Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87AC8399D8D
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 11:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbhFCJTm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 05:19:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbhFCJTl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 05:19:41 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C595C06174A
        for <netdev@vger.kernel.org>; Thu,  3 Jun 2021 02:17:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=2qbwSl+XiRAL06aJLO8OWO6GKK3KWB/cmhCjG/H4Qe8=; b=NSxOjJ4VucdYKBRuIk7hVOE74
        29g+lxJQ1VC+fU3nGL1532+RH1UbVFSnVSxqcTFHkbDuGA3oimMc7vizaHdDc0FP1uwWnSnf3hhU1
        RrFvpdyBWBwk84AOB0izwrAhl7dkdpafeVOdjWWG/yOfOrcYSXkJcO2b0Q8ozPT0CmuEa6UihHfQZ
        9Rnfww5R/BtQZ9BSr7QoyEZ39WWmeqZBMJMrjUvGT8Y+BqqMsH9dIB06zJOR19E/dmwajKLl8Y+Nq
        zLqcMmVWXUbMDSymF2T8nJwqoy9EcImhVQMYCKmF0aeuw4BwzoBFC+spXwQdOBWCltTKY3RNuf0Nr
        jrB18NrqQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:44664)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lojU9-0002PQ-O5; Thu, 03 Jun 2021 10:17:53 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lojU6-0001zT-UY; Thu, 03 Jun 2021 10:17:50 +0100
Date:   Thu, 3 Jun 2021 10:17:50 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Xu Liang <lxu@maxlinear.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org,
        vee.khee.wong@linux.intel.com, hmehrtens@maxlinear.com,
        tmohren@maxlinear.com
Subject: Re: [PATCH v2] net: phy: add Maxlinear GPY115/21x/24x driver
Message-ID: <20210603091750.GQ30436@shell.armlinux.org.uk>
References: <20210603073438.33967-1-lxu@maxlinear.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210603073438.33967-1-lxu@maxlinear.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, Jun 03, 2021 at 03:34:38PM +0800, Xu Liang wrote:
> diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
> index bcda7ed2455d..70efab3659ee 100644
> --- a/drivers/net/phy/Makefile
> +++ b/drivers/net/phy/Makefile
> @@ -70,6 +70,7 @@ obj-$(CONFIG_MICREL_PHY)	+= micrel.o
>  obj-$(CONFIG_MICROCHIP_PHY)	+= microchip.o
>  obj-$(CONFIG_MICROCHIP_T1_PHY)	+= microchip_t1.o
>  obj-$(CONFIG_MICROSEMI_PHY)	+= mscc/
> +obj-$(CONFIG_MXL_GPHY)          += mxl-gpy.o

This should use tab(s) to align indentation rather than spaces.

> +static int gpy_config_init(struct phy_device *phydev)
> +{
> +	int ret, fw_ver;
> +
> +	/* Show GPY PHY FW version in dmesg */
> +	fw_ver = phy_read(phydev, PHY_FWV);
> +	if (fw_ver < 0)
> +		return fw_ver;
> +
> +	phydev_info(phydev, "Firmware Version: 0x%04X (%s)\n", fw_ver,
> +		    (fw_ver & PHY_FWV_REL_MASK) ? "release" : "test");

Does this need to print the firmware version each time config_init()
is called? Is it likely to change beyond? Would it be more sensible
to print it in the probe() method?

> +static int gpy_config_aneg(struct phy_device *phydev)
> +{
> +	bool changed = false;
> +	u32 adv;
> +	int ret;
> +
> +	if (phydev->autoneg == AUTONEG_DISABLE) {
> +		return phydev->duplex != DUPLEX_FULL
> +			? genphy_setup_forced(phydev)
> +			: genphy_c45_pma_setup_forced(phydev);

I think this needs a comment to describe what is going on here to
explain why the duplex setting influences whether we program the PHY
via C22 or C45.

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
> +		ret = phy_modify_mmd_changed(phydev, MDIO_MMD_VEND1,
> +					     VSPEC1_SGMII_CTRL,
> +					     VSPEC1_SGMII_CTRL_ANEN, 0);

Do you need to know if the bit was changed? It doesn't appear so, so
please consider using phy_modify_mmd() here and in the other part of
this switch block.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
