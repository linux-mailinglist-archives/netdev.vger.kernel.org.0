Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8FDD69AC33
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 14:13:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbjBQNNV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 08:13:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjBQNNU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 08:13:20 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 711792FCDD
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 05:13:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=CzALCF+eGK1up4l2u58xXS8JzSTTDyQcSQ5QWvIqkMs=; b=P+7w7sCOi1lGEhKoZdstGoj3CP
        lA+CHEKKxL98zzIJn3JrRrZZOo49JLMZHuOwC9PZ8im5cLB1+9GwhhC5J05wEOczahJNrdNtCt/IG
        JvxBymqbPP0F+rA+Obf5NWunWMYgB/gE/tgz5AwLT7cteaEo36dM7XcoZVJjOeisPIu1vohvUXy/o
        074you4rX2vJrCyH6fWLVlkOi0SaF8vdZ127tioBPq8XwVRAWCx1QdCNGFxsHBDIiHhe8i240jXJI
        wnhI/JLEUJZQ5/RfmCkgVJCmWo1GjPAxLgcaojLvAdFkxPwSC0Q/9vttb+un3qvggZNOUN4dEuebW
        7rl/e1cg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:37684)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pT0Y2-0000ye-Bo; Fri, 17 Feb 2023 13:13:10 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pT0Xv-0006pk-IU; Fri, 17 Feb 2023 13:13:03 +0000
Date:   Fri, 17 Feb 2023 13:13:03 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>,
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
Subject: Re: [PATCH RFC 03/18] net: marvell: mvneta: Simplify EEE
 configuration
Message-ID: <Y+99X3vRjLIoVOmm@shell.armlinux.org.uk>
References: <20230217034230.1249661-1-andrew@lunn.ch>
 <20230217034230.1249661-4-andrew@lunn.ch>
 <Y+9sK/yN7JmQyTl0@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+9sK/yN7JmQyTl0@shell.armlinux.org.uk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 17, 2023 at 11:59:39AM +0000, Russell King (Oracle) wrote:
> On Fri, Feb 17, 2023 at 04:42:15AM +0100, Andrew Lunn wrote:
> > @@ -4221,10 +4218,8 @@ static void mvneta_mac_link_up(struct phylink_config *config,
> >  
> >  	mvneta_port_up(pp);
> >  
> > -	if (phy && pp->eee_enabled) {
> > -		pp->eee_active = phy_init_eee(phy, false) >= 0;
> > -		mvneta_set_eee(pp, pp->eee_active && pp->tx_lpi_enabled);
> > -	}
> > +	if (phy)
> > +		mvneta_set_eee(pp, phy->eee_active && pp->tx_lpi_enabled);
> 
> Thinking about this a bit more, I'm not convinced this is properly safe.
> What protects phy->eee_active from changing here? The phydev mutex won't
> be held at this point.
> 
> As I mentioned in my reply to the cover letter about passing a flag to
> mac_link_up() for EEE status, this would mean phylink could save the
> EEE active status just like it does with the other phydev parameters
> in phylink_phy_change() (which is called under the phydev mutex).

I suppose another option would be to add a new method to
phylink_mac_ops:

	int (*mac_set_eee)(struct phylink_config *config, bool eee,
			   u32 tx_lpi_timer);

and phylink calls this just before mac_link_up() or after
phylink_ethtool_set_eee(). The eee flag would be the effective result
of phydev->eee_active && tx_lpi_enabled, possibly also && tx_lpi_timer
!= 0, since a zero tx_lpi_timer is rather meaningless, unless we
explicitly have phylink_ethtool_set_eee() reject it is invalid.

All that mac_set_eee() implementations should then need to do is to
program the LPI timer in the MAC hardware, and enable or disable it
according to the "eee" flag.

The down-side to another mac_ops method is having to add a wrapper in
net/dsa/port.c for it.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
