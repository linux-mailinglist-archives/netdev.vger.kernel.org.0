Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E693527348
	for <lists+netdev@lfdr.de>; Sat, 14 May 2022 19:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234573AbiENRSc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 May 2022 13:18:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbiENRSa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 May 2022 13:18:30 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A69A1EAFB;
        Sat, 14 May 2022 10:18:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=dxDs5yrcW45vjplOBhaNnU+S9CSWYkuBCk04Qmhp8xA=; b=wufhlEK7Gr4scKS8+uJ3+7otF9
        4dZvDvOeDgRPJhf8hbVaqryp7VpnwVW+wz3mrDkhrwl2erXXNwAonQmnqd8JA3kNf4ZhyLRl+OqAV
        fZ0fEI1GglVjcLN4bV162CUAs1u7Lh7taz9rA2E1np2P7ar6Xtl2vpWq5kurwPRUlom8I04iczXDY
        5JDzQmPwiSHBSIriZaExmU2b0jRMBPOn6VEmsJzQKE0v38hE6ew7Ugp4MhPCPgYN9cWPUg1k5HMWw
        mqJAiFH6CQu7TTq+7B5BLASlkZtOyPNeqM+cSfhk15O7O/D5P00eaqT9Vmf8sA8U26yxMwut9USeS
        g7f7YuXg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:60714)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1npvPH-0003sm-OH; Sat, 14 May 2022 18:18:20 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1npvPF-0001iv-1O; Sat, 14 May 2022 18:18:17 +0100
Date:   Sat, 14 May 2022 18:18:17 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     davem@davemloft.net, Rob Herring <robh+dt@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, thomas.petazzoni@bootlin.com,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>
Subject: Re: [PATCH net-next v2 1/5] net: ipqess: introduce the Qualcomm
 IPQESS driver
Message-ID: <Yn/kWG7X1YCPk17F@shell.armlinux.org.uk>
References: <20220514150656.122108-1-maxime.chevallier@bootlin.com>
 <20220514150656.122108-2-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220514150656.122108-2-maxime.chevallier@bootlin.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 14, 2022 at 05:06:52PM +0200, Maxime Chevallier wrote:
> +static int ipqess_do_ioctl(struct net_device *netdev, struct ifreq *ifr, int cmd)
> +{
> +	struct ipqess *ess = netdev_priv(netdev);
> +
> +	switch (cmd) {
> +	case SIOCGMIIPHY:
> +	case SIOCGMIIREG:
> +	case SIOCSMIIREG:
> +		return phylink_mii_ioctl(ess->phylink, ifr, cmd);
> +	default:
> +		break;
> +	}
> +
> +	return -EOPNOTSUPP;
> +}

Is there a reason this isn't just:

	return phylink_mii_ioctl(ess->phylink, ifr, cmd);

?

> +static int ipqess_axi_probe(struct platform_device *pdev)
> +{
> +	struct device_node *np = pdev->dev.of_node;
> +	struct net_device *netdev;
> +	phy_interface_t phy_mode;
> +	struct resource *res;
> +	struct ipqess *ess;
> +	int i, err = 0;
> +
> +	netdev = devm_alloc_etherdev_mqs(&pdev->dev, sizeof(struct ipqess),
> +					 IPQESS_NETDEV_QUEUES,
> +					 IPQESS_NETDEV_QUEUES);
> +	if (!netdev)
> +		return -ENOMEM;
> +
> +	ess = netdev_priv(netdev);
> +	ess->netdev = netdev;
> +	ess->pdev = pdev;
> +	spin_lock_init(&ess->stats_lock);
> +	SET_NETDEV_DEV(netdev, &pdev->dev);
> +	platform_set_drvdata(pdev, netdev);
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	ess->hw_addr = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(ess->hw_addr))
> +		return PTR_ERR(ess->hw_addr);
> +
> +	err = of_get_phy_mode(np, &phy_mode);
> +	if (err) {
> +		dev_err(&pdev->dev, "incorrect phy-mode\n");
> +		return err;
> +	}
> +
> +	ess->ess_clk = devm_clk_get(&pdev->dev, "ess");
> +	if (!IS_ERR(ess->ess_clk))
> +		clk_prepare_enable(ess->ess_clk);
> +
> +	ess->ess_rst = devm_reset_control_get(&pdev->dev, "ess");
> +	if (IS_ERR(ess->ess_rst))
> +		goto err_clk;
> +
> +	ipqess_reset(ess);
> +
> +	ess->phylink_config.dev = &netdev->dev;
> +	ess->phylink_config.type = PHYLINK_NETDEV;
> +
> +	__set_bit(PHY_INTERFACE_MODE_INTERNAL,
> +		  ess->phylink_config.supported_interfaces);

No mac capabilities?

> +
> +	ess->phylink = phylink_create(&ess->phylink_config,
> +				      of_fwnode_handle(np), phy_mode,
> +				      &ipqess_phylink_mac_ops);

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
