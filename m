Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA174545D8
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 12:42:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236897AbhKQLo6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 06:44:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235061AbhKQLo5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 06:44:57 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3199EC061746;
        Wed, 17 Nov 2021 03:41:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=mBBJF2yawl0kgACqc2HujgjVeeJsd5fX8mPLwpdeQ10=; b=shC1P+sQyMdlspE6psXkKoiUrl
        j2A1Nvj3lJMLEhXPba0eldUERms+FosQ1L5h4dqlpR9CnFr3yau/XUJ3AF+W7idsJR0L02r4Hbv1f
        uh8TGrycL4QyANpN5yCMH0WI2Y0omr49y5vG3pTpf0Wpf4+Pfh/TJh5cC9WujOsXc76qytzdnuJkp
        yz8LKzcSMwFJFhosQ5f2XURIcmipf2izNAnvgTq3mm8e+f78YMGKN8MwbcoNyOiqKGN5s3VJAIebV
        XuZL8daeTzGv8V8Ne5k1JDpXdNj06CvQyjt+6A0AEhvliWpgptE2vmo5c0LJzx/gZjUhgnQgerinO
        2SpQPU3Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55678)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mnJK0-0001l5-5Q; Wed, 17 Nov 2021 11:41:48 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mnJJy-0002uI-KG; Wed, 17 Nov 2021 11:41:46 +0000
Date:   Wed, 17 Nov 2021 11:41:46 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        p.zabel@pengutronix.de, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 3/5] net: lan966x: add port module support
Message-ID: <YZTqekOTK8pm86G+@shell.armlinux.org.uk>
References: <20211117091858.1971414-1-horatiu.vultur@microchip.com>
 <20211117091858.1971414-4-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211117091858.1971414-4-horatiu.vultur@microchip.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

By the way...

On Wed, Nov 17, 2021 at 10:18:56AM +0100, Horatiu Vultur wrote:
> +	port->phylink_config.mac_capabilities = MAC_ASYM_PAUSE | MAC_SYM_PAUSE |
> +		MAC_10 | MAC_100 | MAC_1000FD | MAC_2500FD;
> +
> +	__set_bit(PHY_INTERFACE_MODE_MII,
> +		  port->phylink_config.supported_interfaces);
> +	__set_bit(PHY_INTERFACE_MODE_GMII,
> +		  port->phylink_config.supported_interfaces);
> +	__set_bit(PHY_INTERFACE_MODE_SGMII,
> +		  port->phylink_config.supported_interfaces);
> +	__set_bit(PHY_INTERFACE_MODE_QSGMII,
> +		  port->phylink_config.supported_interfaces);
> +	__set_bit(PHY_INTERFACE_MODE_1000BASEX,
> +		  port->phylink_config.supported_interfaces);
> +	__set_bit(PHY_INTERFACE_MODE_2500BASEX,
> +		  port->phylink_config.supported_interfaces);
...
> +const struct phylink_mac_ops lan966x_phylink_mac_ops = {
> +	.validate = phylink_generic_validate,

Thank you for switching the driver to use phylink_generic_validate(),
that's really very useful, and saves a chunk of code in your driver!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
