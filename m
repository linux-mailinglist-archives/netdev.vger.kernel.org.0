Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FACE59FAEE
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 15:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238078AbiHXNLF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 09:11:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236684AbiHXNLB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 09:11:01 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44E3115FC5;
        Wed, 24 Aug 2022 06:10:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=N9oJQbbnL3ZPdfQrFIR3akJaO1v/S9XNtdetroi1fvA=; b=nd6buqrEq/WpLStrEkR+1pNf4s
        8wuhU32kQ/2Aw4VCyDQu12J576L66NpSmoH4rbKG6A69+M3JlSVGaeUGPJDrmwIaW7UCSfe2KLZjK
        zRG0frRccNECb0nSAcHXIAqIQwzAg2zVUe7c6JJ8AHb3dqWJfGTeNF59P2MCx3CjfwkMnd3tj2xJ2
        w6OxmMlGPIcAK4CTlXlHvX7EC4p36XnLZJAPjWRl3g0w8oYgHVm4+0UapUo5A2yD30y/n59FOZuxt
        mFDuu4TGzDki5+V3V6tGgsEqvE9T+zh39exnxox3pl0vF86csRx00W38vWmT5qhnESimeb/li7Haj
        ATYF4zVw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33914)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oQq9V-0004EH-Cf; Wed, 24 Aug 2022 14:10:37 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oQq9Q-00048p-LO; Wed, 24 Aug 2022 14:10:32 +0100
Date:   Wed, 24 Aug 2022 14:10:32 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     "xiaowu.ding" <xiaowu.ding@jaguarmicro.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, nicolas.ferre@microchip.com,
        claudiu.beznea@microchip.com, palmer@dabbelt.com,
        paul.walmsley@sifive.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org
Subject: Re: [PATCH net-next] driver: cadence macb driver support acpi mode
Message-ID: <YwYjSPl7murFFpJG@shell.armlinux.org.uk>
References: <20220824121351.578-1-xiaowu.ding@jaguarmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220824121351.578-1-xiaowu.ding@jaguarmicro.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 24, 2022 at 08:13:51PM +0800, xiaowu.ding wrote:
> -static bool macb_phy_handle_exists(struct device_node *dn)
> +static bool macb_of_phy_handle_exists(struct device_node *dn)
>  {
>  	dn = of_parse_phandle(dn, "phy-handle", 0);
>  	of_node_put(dn);
>  	return dn != NULL;
>  }
>  
> -static int macb_phylink_connect(struct macb *bp)
> +static int macb_of_phylink_connect(struct macb *bp)
>  {
>  	struct device_node *dn = bp->pdev->dev.of_node;
>  	struct net_device *dev = bp->dev;
> @@ -765,7 +767,7 @@ static int macb_phylink_connect(struct macb *bp)
>  	if (dn)
>  		ret = phylink_of_phy_connect(bp->phylink, dn, 0);
>  
> -	if (!dn || (ret && !macb_phy_handle_exists(dn))) {
> +	if (!dn || (ret && !macb_of_phy_handle_exists(dn))) {
>  		phydev = phy_find_first(bp->mii_bus);
>  		if (!phydev) {
>  			netdev_err(dev, "no PHY found\n");
> @@ -786,6 +788,166 @@ static int macb_phylink_connect(struct macb *bp)
>  	return 0;
>  }
>  
> +#ifdef CONFIG_ACPI
> +
> +static bool macb_acpi_phy_handle_exists(struct fwnode_handle *fwnd)
> +{
> +	struct fwnode_handle *phy_node;
> +	bool flag = false;
> +	/* Only phy-handle is used for ACPI */
> +	phy_node = fwnode_find_reference(fwnd, "phy-handle", 0);
> +	flag = !IS_ERR_OR_NULL(phy_node);
> +
> +	if (flag)
> +		fwnode_handle_put(phy_node);
> +
> +	return flag;
> +}
> +
> +static int macb_acpi_phylink_connect(struct macb *bp)
> +{
> +	struct fwnode_handle *fwnd = bp->pdev->dev.fwnode;
> +	struct net_device *dev = bp->dev;
> +	struct phy_device *phydev;
> +	int ret;
> +
> +	if (fwnd)
> +		ret = phylink_fwnode_phy_connect(bp->phylink, fwnd, 0);
> +
> +	if (!fwnd || (ret && !macb_acpi_phy_handle_exists(fwnd))) {
> +		phydev = phy_find_first(bp->mii_bus);
> +		if (!phydev) {
> +			netdev_err(dev, "no PHY found\n");
> +			return -ENXIO;
> +		}
> +
> +		/* attach the mac to the phy */
> +		ret = phylink_connect_phy(bp->phylink, phydev);
> +	}
> +
> +	if (ret) {
> +		netdev_err(dev, "Could not attach PHY (%d)\n", ret);
> +		return ret;
> +	}
> +
> +	phylink_start(bp->phylink);
> +
> +	return 0;
> +}

You shouldn't need this duplication. phylink_fwnode_phy_connect() can be
used to connect DT-based PHYs just fine, so you should be able to use it
for both cases without needing to resort to two copies. This is one of
the reasons the fwnode API exists.

The functionality of your macb_acpi_phy_handle_exists() and
macb_of_phy_handle_exists() should also be the same. Not that
fwnode_handle_put() is safe to call with NULL or err-pointer fwnodes.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
