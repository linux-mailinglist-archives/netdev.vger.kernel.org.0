Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F64B5B8C1F
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 17:44:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbiINPoY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 11:44:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbiINPoX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 11:44:23 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63F291409D;
        Wed, 14 Sep 2022 08:44:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=TT806hquzmPeDHNm/dCqNrwSyRjzONBhzJl1u4HFzxk=; b=R7uPD0Imyz38DRqmXNMFGvxFEE
        kse9E9RtwJ77YJUtBMeeSflRZQGdyr2BiwEkuhG2goiN4YUES+o2Thj5JifwfmWIE6S4DT9k1fZ6Q
        pXzvtPf8SxEUvfWDXQVyY7OlGDjMTFUOwkl8fUPszoxb9dAbbZJD8dpWuColUp+UDJiipt39lsGt1
        YiAX4wlUQPqP/ShySewyMXSl3puTZcSx18G49Ol0w7KpYLwqBGK74uf2sdKguyiFdpaR1z4hhzDQT
        PZ/mB+/uuXDBI0tMTo/Uvv/wIBXbnqi3jqn6/mrrD6YPK7hJcuxG2RYhxYlZQdVli50Xymdzr7k33
        Dzx0NWYg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34324)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oYUYg-0004Yt-2Q; Wed, 14 Sep 2022 16:44:14 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oYUYf-0001m3-0a; Wed, 14 Sep 2022 16:44:13 +0100
Date:   Wed, 14 Sep 2022 16:44:12 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Siddharth Vadapalli <s-vadapalli@ti.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski@linaro.org, krzysztof.kozlowski+dt@linaro.org,
        vladimir.oltean@nxp.com, grygorii.strashko@ti.com, vigneshr@ti.com,
        nsekhar@ti.com, netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kishon@ti.com
Subject: Re: [PATCH 6/8] net: ethernet: ti: am65-cpsw: Add support for SGMII
 mode for J7200 CPSW5G
Message-ID: <YyH2zCscSV5KQtZ9@shell.armlinux.org.uk>
References: <20220914095053.189851-1-s-vadapalli@ti.com>
 <20220914095053.189851-7-s-vadapalli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220914095053.189851-7-s-vadapalli@ti.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 14, 2022 at 03:20:51PM +0530, Siddharth Vadapalli wrote:
> Add support for SGMII mode in both fixed-link MAC2MAC master mode and
> MAC2PHY modes for CPSW5G ports.
> 
> Add SGMII mode to the list of extra_modes in j7200_cpswxg_pdata.
> 
> The MAC2PHY mode has been tested in fixed-link mode using a bootstrapped
> PHY. The MAC2MAC mode has been tested by a customer with J7200 SoC on
> their device.
> 
> Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
> ---
>  drivers/net/ethernet/ti/am65-cpsw-nuss.c | 19 ++++++++++++++++---
>  1 file changed, 16 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> index 1739c389af20..3f40178436ff 100644
> --- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> +++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> @@ -75,7 +75,15 @@
>  #define AM65_CPSW_PORTN_REG_TS_CTL_LTYPE2       0x31C
>  
>  #define AM65_CPSW_SGMII_CONTROL_REG		0x010
> +#define AM65_CPSW_SGMII_MR_ADV_ABILITY_REG	0x018

This doesn't seem to be used in this patch, should it be part of some
other patch in the series?

>  #define AM65_CPSW_SGMII_CONTROL_MR_AN_ENABLE	BIT(0)
> +#define AM65_CPSW_SGMII_CONTROL_MASTER_MODE	BIT(5)

Ditto.

> +
> +#define MAC2MAC_MR_ADV_ABILITY_BASE		(BIT(15) | BIT(0))
> +#define MAC2MAC_MR_ADV_ABILITY_FULLDUPLEX	BIT(12)
> +#define MAC2MAC_MR_ADV_ABILITY_1G		BIT(11)
> +#define MAC2MAC_MR_ADV_ABILITY_100M		BIT(10)
> +#define MAC2PHY_MR_ADV_ABILITY			BIT(0)

Most of the above don't seem to be used, and the only one that seems to
be used is used in a variable declaration where the variable isn't used,
and thus us also unused.

>  
>  #define AM65_CPSW_CTL_VLAN_AWARE		BIT(1)
>  #define AM65_CPSW_CTL_P0_ENABLE			BIT(2)
> @@ -1493,6 +1501,7 @@ static void am65_cpsw_nuss_mac_config(struct phylink_config *config, unsigned in
>  	struct am65_cpsw_slave_data *slave = container_of(config, struct am65_cpsw_slave_data,
>  							  phylink_config);
>  	struct am65_cpsw_port *port = container_of(slave, struct am65_cpsw_port, slave);
> +	u32 mr_adv_ability = MAC2MAC_MR_ADV_ABILITY_BASE;

This doesn't seem to be used; should it be part of a different patch?

I get the impression that most of this patch should be elsewhere in this
series.

>  	struct am65_cpsw_common *common = port->common;
>  	struct fwnode_handle *fwnode;
>  	bool fixed_link = false;
> @@ -2105,8 +2114,12 @@ am65_cpsw_nuss_init_port_ndev(struct am65_cpsw_common *common, u32 port_idx)
>  		__set_bit(PHY_INTERFACE_MODE_RMII,
>  			  port->slave.phylink_config.supported_interfaces);
>  	} else if (common->pdata.extra_modes & BIT(port->slave.phy_if)) {
> -		__set_bit(PHY_INTERFACE_MODE_QSGMII,
> -			  port->slave.phylink_config.supported_interfaces);
> +		if (port->slave.phy_if == PHY_INTERFACE_MODE_QSGMII)
> +			__set_bit(PHY_INTERFACE_MODE_QSGMII,
> +				  port->slave.phylink_config.supported_interfaces);
> +		else
> +			__set_bit(PHY_INTERFACE_MODE_SGMII,
> +				  port->slave.phylink_config.supported_interfaces);
>  	} else {
>  		dev_err(dev, "selected phy-mode is not supported\n");
>  		return -EOPNOTSUPP;
> @@ -2744,7 +2757,7 @@ static const struct am65_cpsw_pdata j7200_cpswxg_pdata = {
>  	.quirks = 0,
>  	.ale_dev_id = "am64-cpswxg",
>  	.fdqring_mode = K3_RINGACC_RING_MODE_RING,
> -	.extra_modes = BIT(PHY_INTERFACE_MODE_QSGMII),
> +	.extra_modes = BIT(PHY_INTERFACE_MODE_QSGMII) | BIT(PHY_INTERFACE_MODE_SGMII),
>  };
>  
>  static const struct of_device_id am65_cpsw_nuss_of_mtable[] = {
> -- 
> 2.25.1
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
