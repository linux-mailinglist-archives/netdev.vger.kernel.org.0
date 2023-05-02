Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6FB46F3EB4
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 10:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233714AbjEBIB4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 04:01:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbjEBIBz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 04:01:55 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5393E5D;
        Tue,  2 May 2023 01:01:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=awIw9raqKVv9+RqUY5uCDztWhOg0YSMu1lQ7JA1ncyA=; b=Lkob+H/01rc7kJYRQFTQoiJMP2
        IemT/d3tF1t8a/eDrsNVGa8vnr2y2h/qVKoShFRm2vhTe8Lx9nckHzsLx26kGxdZ0VRwfTgco3aJB
        566QPlWMFDeDiVDYKzFIESXP3ZyFjYTe0DJxYTkfAvVsWPS8XlH1V+365poPkWA31I6voqFPB0dXl
        YKPmDo8O9GmL0mJ8KLe0AeL7Dc5+sYQj22gAhntI4dALlQHK+1MdaH9zYx3bX4IuVb/t3mk5cQbJH
        mpQ1T7rBaECuKxf5BhPP6ER90KaE3Qcm1nPB2LkLxP1gkIIOv9S62Tinl0MK+gLntfX6MtytmzsHr
        /D9CxFoA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:46722)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ptkxB-0001vH-2A; Tue, 02 May 2023 09:01:41 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ptkx0-0000WK-EB; Tue, 02 May 2023 09:01:30 +0100
Date:   Tue, 2 May 2023 09:01:30 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Jiawen Wu <jiawenwu@trustnetic.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch,
        jarkko.nikula@linux.intel.com, olteanv@gmail.com,
        andriy.shevchenko@linux.intel.com, hkallweit1@gmail.com,
        linux-i2c@vger.kernel.org, linux-gpio@vger.kernel.org,
        mengyuanlou@net-swift.com, Jose Abreu <Jose.Abreu@synopsys.com>
Subject: Re: [PATCH net-next v4 6/8] net: pcs: Add 10GBASE-R mode for
 Synopsys Designware XPCS
Message-ID: <ZFDDWrkiGzho1fA9@shell.armlinux.org.uk>
References: <20230422045621.360918-1-jiawenwu@trustnetic.com>
 <20230422045621.360918-7-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230422045621.360918-7-jiawenwu@trustnetic.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 22, 2023 at 12:56:19PM +0800, Jiawen Wu wrote:
> Add basic support for XPCS using 10GBASE-R interface. This mode will
> be extended to use interrupt, so set pcs.poll false. And avoid soft
> reset so that the device using this mode is in the default configuration.
> 
> Cc: Jose Abreu <Jose.Abreu@synopsys.com>
> 
> Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
> ---
>  drivers/net/pcs/pcs-xpcs.c   | 56 ++++++++++++++++++++++++++++++++++++
>  include/linux/pcs/pcs-xpcs.h |  1 +
>  2 files changed, 57 insertions(+)
> 
> diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
> index 539cd43eae8d..9ddaceda1fe9 100644
> --- a/drivers/net/pcs/pcs-xpcs.c
> +++ b/drivers/net/pcs/pcs-xpcs.c
> @@ -64,6 +64,16 @@ static const int xpcs_xlgmii_features[] = {
>  	__ETHTOOL_LINK_MODE_MASK_NBITS,
>  };
>  
> +static const int xpcs_10gbaser_features[] = {
> +	ETHTOOL_LINK_MODE_Pause_BIT,
> +	ETHTOOL_LINK_MODE_Asym_Pause_BIT,
> +	ETHTOOL_LINK_MODE_10000baseSR_Full_BIT,
> +	ETHTOOL_LINK_MODE_10000baseLR_Full_BIT,
> +	ETHTOOL_LINK_MODE_10000baseLRM_Full_BIT,
> +	ETHTOOL_LINK_MODE_10000baseER_Full_BIT,
> +	__ETHTOOL_LINK_MODE_MASK_NBITS,
> +};
> +
>  static const int xpcs_sgmii_features[] = {
>  	ETHTOOL_LINK_MODE_Pause_BIT,
>  	ETHTOOL_LINK_MODE_Asym_Pause_BIT,
> @@ -106,6 +116,10 @@ static const phy_interface_t xpcs_xlgmii_interfaces[] = {
>  	PHY_INTERFACE_MODE_XLGMII,
>  };
>  
> +static const phy_interface_t xpcs_10gbaser_interfaces[] = {
> +	PHY_INTERFACE_MODE_10GBASER,
> +};
> +
>  static const phy_interface_t xpcs_sgmii_interfaces[] = {
>  	PHY_INTERFACE_MODE_SGMII,
>  };
> @@ -123,6 +137,7 @@ enum {
>  	DW_XPCS_USXGMII,
>  	DW_XPCS_10GKR,
>  	DW_XPCS_XLGMII,
> +	DW_XPCS_10GBASER,
>  	DW_XPCS_SGMII,
>  	DW_XPCS_1000BASEX,
>  	DW_XPCS_2500BASEX,
> @@ -246,6 +261,7 @@ static int xpcs_soft_reset(struct dw_xpcs *xpcs,
>  
>  	switch (compat->an_mode) {
>  	case DW_AN_C73:
> +	case DW_10GBASER:
>  		dev = MDIO_MMD_PCS;
>  		break;
>  	case DW_AN_C37_SGMII:
> @@ -872,6 +888,8 @@ int xpcs_do_config(struct dw_xpcs *xpcs, phy_interface_t interface,
>  		return -ENODEV;
>  
>  	switch (compat->an_mode) {
> +	case DW_10GBASER:
> +		break;
>  	case DW_AN_C73:
>  		if (phylink_autoneg_inband(mode)) {
>  			ret = xpcs_config_aneg_c73(xpcs, compat);
> @@ -919,6 +937,27 @@ static int xpcs_config(struct phylink_pcs *pcs, unsigned int mode,
>  	return xpcs_do_config(xpcs, interface, mode, advertising);
>  }
>  
> +static int xpcs_get_state_10gbaser(struct dw_xpcs *xpcs,
> +				   struct phylink_link_state *state)
> +{
> +	int ret;
> +
> +	state->link = false;
> +
> +	ret = xpcs_read(xpcs, MDIO_MMD_PCS, MDIO_STAT1);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (ret & MDIO_STAT1_LSTATUS) {
> +		state->link = true;
> +		state->pause = MLO_PAUSE_TX | MLO_PAUSE_RX;
> +		state->duplex = DUPLEX_FULL;
> +		state->speed = SPEED_10000;
> +	}
> +
> +	return 0;

This looks to me to be an almost duplicate of
phylink_mii_c45_pcs_get_state().

> +}
> +
>  static int xpcs_get_state_c73(struct dw_xpcs *xpcs,
>  			      struct phylink_link_state *state,
>  			      const struct xpcs_compat *compat)
> @@ -1033,6 +1072,14 @@ static void xpcs_get_state(struct phylink_pcs *pcs,
>  		return;
>  
>  	switch (compat->an_mode) {
> +	case DW_10GBASER:
> +		ret = xpcs_get_state_10gbaser(xpcs, state);

This could then be simply:

		phylink_mii_c45_pcs_get_state(xpcs->mdiodev, state);

> +		if (ret) {
> +			pr_err("xpcs_get_state_10gbaser returned %pe\n",
> +			       ERR_PTR(ret));

Please avoid printing errors like this if we can't read the state. If we
become unable to read the state, then this message will flood the log at
the polling rate (if polling is enabled.)

I know the other cases here do, but they shouldn't.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!
