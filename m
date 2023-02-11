Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8107693123
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 13:56:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbjBKM4x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Feb 2023 07:56:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjBKM4w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Feb 2023 07:56:52 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 064779EF1;
        Sat, 11 Feb 2023 04:56:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=UsUTsmdI8FTtESXmakJcIlKRIPwSoiJ/RU2vJ1NPEmE=; b=P5HIKzzEsbVCrGzHd2D0+hA7GJ
        jKEl5/gZ1P4KQR2DccL40wWeiClhC8wJWMgRcOsilLhnPcqdVXY7tEtvsTJkEvNPO3SEH6vQbc2mA
        AI1wsAhcjxwg4p5r4CP0OogDEAZY59+F/yilJFpCTmef4GY2trplq7Tt5d0dA3Ttt92FV1nzHAMB4
        NwHTioxn1sHnorllbjneZ2+Owob7WE2gEPsDgDyipvGnAMZz5n5TfvCwAoDIhSiACrCy0Itwxze5t
        Zp6xsVgYX+CXbLOA6gsi//fYfMn5E8cILX5gHaE8eBhr5Clg0lFddCcLxmRlK4QK01bs520y2Y3V6
        zaR3Wg8A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56424)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pQpQu-0001c9-If; Sat, 11 Feb 2023 12:56:48 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pQpQt-00017w-5s; Sat, 11 Feb 2023 12:56:47 +0000
Date:   Sat, 11 Feb 2023 12:56:47 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Jianhui Zhao <zhaojh329@gmail.com>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Subject: Re: [PATCH v4 11/12] net: ethernet: mtk_eth_soc: switch to external
 PCS driver
Message-ID: <Y+eQj5LUTt4C5qgP@shell.armlinux.org.uk>
References: <cover.1676071507.git.daniel@makrotopia.org>
 <7886ca664ba6ca712aac127b20380d3d2a1a4d1f.1676071508.git.daniel@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7886ca664ba6ca712aac127b20380d3d2a1a4d1f.1676071508.git.daniel@makrotopia.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 10, 2023 at 11:40:22PM +0000, Daniel Golle wrote:
> +		eth->sgmii->dev = eth->dev;
>  		err = mtk_sgmii_init(eth->sgmii, pdev->dev.of_node,
>  				     eth->soc->ana_rgc3);

From what I can tell, it looks like sgmii->dev is only used within
mtk_sgmii_init() and nowhere else, so does it make sense to store
this in the structure rather than passing it as another argument to
this function? Seems a little wasteful for something that is only
used there.

> diff --git a/drivers/net/pcs/pcs-mtk-lynxi.c b/drivers/net/pcs/pcs-mtk-lynxi.c
> index 67965a6b57a4..f10621fc5baa 100644
> --- a/drivers/net/pcs/pcs-mtk-lynxi.c
> +++ b/drivers/net/pcs/pcs-mtk-lynxi.c
> @@ -146,6 +146,10 @@ static int mtk_pcs_lynxi_config(struct phylink_pcs *pcs, unsigned int mode,
>  		bmcr = 0;
>  
>  	if (mpcs->interface != interface) {
> +		link_timer = phylink_get_link_timer_ns(interface);
> +		if (link_timer < 0)
> +			return link_timer;
> +
>  		/* PHYA power down */
>  		regmap_update_bits(mpcs->regmap, SGMSYS_QPHY_PWR_STATE_CTRL,
>  				   SGMII_PHYA_PWD, SGMII_PHYA_PWD);
> @@ -168,11 +172,7 @@ static int mtk_pcs_lynxi_config(struct phylink_pcs *pcs, unsigned int mode,
>  		regmap_update_bits(mpcs->regmap, mpcs->ana_rgc3,
>  				   RG_PHY_SPEED_MASK, rgc3);
>  
> -		/* Setup the link timer and QPHY power up inside SGMIISYS */
> -		link_timer = phylink_get_link_timer_ns(interface);
> -		if (link_timer < 0)
> -			return link_timer;
> -
> +		/* Setup the link timer */
>  		regmap_write(mpcs->regmap, SGMSYS_PCS_LINK_TIMER, link_timer / 2 / 8);
>  
>  		mpcs->interface = interface;

I'm guessing you meant to squash that into patch 10 rather than this
patch?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
