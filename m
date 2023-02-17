Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE8EE69AB96
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 13:32:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbjBQMcv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 07:32:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbjBQMct (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 07:32:49 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F19C2681
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 04:32:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=8b4TRasz9WS/99qQeBZUZqQjt7rW1bdnmmxCS6SHFaY=; b=zGp6GtiLyYK8mtNYyw9KDuIaLT
        ufnyfOi+0/B1A2fM0EbhWRgG7mW/wjhHAfby9AvuXdU4yiXdKnznykJEQMavJBCS0LCGv0TK9Bj6k
        Z0bISy9eFMjdQ9JBW5LYzHdnp9rSLfgqJKSBg7Svs85k8nXGNgUnPtCJZmcIFm0I74vz2BhD4qGxc
        1o6cZtMpk9dshuJJIcBZK/AAsuQH/u6xyj2xOgnuQ0XFkz6Livs/dkY/UZsT5m3QlgJff7r/lKjrz
        U/BE3VO50/cOZImSuGX2XQpOTFgLK8GOp7tNxq1NsCccJIge5DIAx2YNOBiD+vEkwEKHkJbasSXA0
        NMVQo8tA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:36490)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pSzuq-0000vS-PX; Fri, 17 Feb 2023 12:32:40 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pSzuk-0006nJ-Q7; Fri, 17 Feb 2023 12:32:34 +0000
Date:   Fri, 17 Feb 2023 12:32:34 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Doug Berger <opendmb@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Wei Fang <wei.fang@nxp.com>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        UNGLinuxDriver@microchip.com, Byungho An <bh74.an@samsung.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Oleksij Rempel <linux@rempel-privat.de>
Subject: Re: [PATCH RFC 08/18] net: FEC: Fixup EEE
Message-ID: <Y+9z4q270ny0ZYZj@shell.armlinux.org.uk>
References: <20230217034230.1249661-1-andrew@lunn.ch>
 <20230217034230.1249661-9-andrew@lunn.ch>
 <20230217081943.GA9065@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230217081943.GA9065@pengutronix.de>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 17, 2023 at 09:19:43AM +0100, Oleksij Rempel wrote:
> On Fri, Feb 17, 2023 at 04:42:20AM +0100, Andrew Lunn wrote:
> > @@ -3131,15 +3120,7 @@ fec_enet_set_eee(struct net_device *ndev, struct ethtool_eee *edata)
> >  		return -ENETDOWN;
> >  
> >  	p->tx_lpi_timer = edata->tx_lpi_timer;
> > -
> > -	if (!edata->eee_enabled || !edata->tx_lpi_enabled ||
> > -	    !edata->tx_lpi_timer)
> > -		ret = fec_enet_eee_mode_set(ndev, false);
> > -	else
> > -		ret = fec_enet_eee_mode_set(ndev, true);
> > -
> > -	if (ret)
> > -		return ret;
> > +	p->tx_lpi_enabled = edata->tx_lpi_enabled;
> 
> Hm.. this change have effect only after link restart. Should we do
> something like this?
> 
> 	if (phydev->link)
> 		fec_enet_eee_mode_set(ndev, phydev->eee_active);
> 
> or, execute phy_ethtool_set_eee() first and some how detect if link
> changed? Or restart link by phylib on every change?

Restarting the link on every "change" (even when nothing has changed)
is a dirty hack, and can be very annoying, leading to multiple link
restarts e.g. at boot time which can turn into several seconds of
boot delay depending on how much is configured.

I would suggest as a general principle, we should be keeping link
renegotiations to a minimum - and phylib already tries to do that in
several places.

Also note that reading phydev->eee_active without holding the phydev
mutex can be racy - and I would also ask what would prevent two calls
to fec_enet_eee_mode_set() running concurrently, once by the
adjust_link callback and once via the set_eee method. This applies
to reading phydev->link as well, so it may be best to hold the
phydev mutex around that entire if() clause.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
