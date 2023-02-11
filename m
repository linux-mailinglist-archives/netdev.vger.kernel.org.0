Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F11C693121
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 13:53:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbjBKMxM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Feb 2023 07:53:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjBKMxL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Feb 2023 07:53:11 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D5D0E3AF;
        Sat, 11 Feb 2023 04:53:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=nHf5K/3CxkfPe8qKwrnhaJIdaQB3d06R8C9LSCDVA9Q=; b=urQL6xNx2HjJhmtsqQyY908gKl
        comEalff9Uut+3IQksKlW0ut1njxVu6fkf61ncyQgk6KUkxzae4ldRdHD9QG14DMGi8Rr+8jQH6Vl
        Zi/A4Anp3XgqWROgf6cPthHpJH3HeqNFVO60AswahpR38ELW/mRLNtE4WpiVbeveMNi7h0dMPLgl7
        khNwe+hQfguR06pD2fXNjZfkQZPUet/a2ithDrWvS3CeCurfSKpFDqfGg88ePagiAMgyiOmGm6FNa
        y5oEDruz8vlQJXRxBpZbX2f/nv+mUscYzNhrybocVD3Pn2aBdr6YvhpPfrfatRc78NrgIJmZGlqZd
        xvTtojog==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:48374)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pQpNJ-0001bb-EX; Sat, 11 Feb 2023 12:53:05 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pQpNG-00017o-Lo; Sat, 11 Feb 2023 12:53:02 +0000
Date:   Sat, 11 Feb 2023 12:53:02 +0000
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
Subject: Re: [PATCH v4 10/12] net: pcs: add driver for MediaTek SGMII PCS
Message-ID: <Y+ePrq4pTLOuTNIc@shell.armlinux.org.uk>
References: <cover.1676071507.git.daniel@makrotopia.org>
 <1df6229f353a093279d707f8841d71b65aec4d90.1676071508.git.daniel@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1df6229f353a093279d707f8841d71b65aec4d90.1676071508.git.daniel@makrotopia.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Daniel,

On Fri, Feb 10, 2023 at 11:39:59PM +0000, Daniel Golle wrote:
> +	if (mpcs->interface != interface) {
> +		/* PHYA power down */
> +		regmap_update_bits(mpcs->regmap, SGMSYS_QPHY_PWR_STATE_CTRL,
> +				   SGMII_PHYA_PWD, SGMII_PHYA_PWD);
> +
> +		/* Reset SGMII PCS state */
> +		regmap_update_bits(mpcs->regmap, SGMII_RESERVED_0,
> +				   SGMII_SW_RESET, SGMII_SW_RESET);
> +
> +		if (mpcs->flags & MTK_SGMII_FLAG_PN_SWAP)
> +			regmap_update_bits(mpcs->regmap, SGMSYS_QPHY_WRAP_CTRL,
> +					   SGMII_PN_SWAP_MASK,
> +					   SGMII_PN_SWAP_TX_RX);
> +
> +		if (interface == PHY_INTERFACE_MODE_2500BASEX)
> +			rgc3 = RG_PHY_SPEED_3_125G;
> +		else
> +			rgc3 = 0;
> +
> +		/* Configure the underlying interface speed */
> +		regmap_update_bits(mpcs->regmap, mpcs->ana_rgc3,
> +				   RG_PHY_SPEED_MASK, rgc3);
> +
> +		/* Setup the link timer and QPHY power up inside SGMIISYS */
> +		link_timer = phylink_get_link_timer_ns(interface);
> +		if (link_timer < 0)
> +			return link_timer;

The change in patch 7 needs to be propagated to this patch (moving this
to the beginning of this block of code.)

Otherwise, LGTM. Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
