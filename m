Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3B4456A0B3
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 13:01:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234737AbiGGLB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 07:01:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235052AbiGGLBW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 07:01:22 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E12D357238
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 04:01:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=meTVCLauPT8tVIXdbiSRm0UrVZwGUwqcYXp+qq9WOhg=; b=QhwPrliKQE2sX6Vo81x5t3GmUz
        0frJ+45A0xAQG6fYJLL30EAE34Z0C1AYKNqxRPXZ+ef79FpNVuTwQsh5ZboleolRvK/oGX5nrzXaK
        PJOdM2/Qb2fSfCDJqlWMDbBWLPd3lxHanjKIaxsvmeMcPw3babpGJtx+xYvXyKqVWZQvwIX+feRdi
        MCJbvK+C/xLcWMuCOhxMc6qo5cWypGaxY41SM3xLEmy9GfbrXETZpT1yCd3LDrPJpLgIg4aThM96V
        HU3NsH7a+JFN3T7O5hJ3YGgO1nafpbH1UyVWhMncs78DpHT7fut8WIV1lAufurr4W3WK+vkKeHNaT
        tyjHpQTA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33218)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1o9PFk-0003nU-T9; Thu, 07 Jul 2022 12:01:00 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1o9PFe-0005Db-VO; Thu, 07 Jul 2022 12:00:54 +0100
Date:   Thu, 7 Jul 2022 12:00:54 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Alvin __ipraga <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        DENG Qingfang <dqfext@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Sean Wang <sean.wang@mediatek.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Subject: Re: [PATCH RFC net-next 5/5] net: dsa: always use phylink for CPU
 and DSA ports
Message-ID: <Ysa85mJIUfo5m4dJ@shell.armlinux.org.uk>
References: <YsQIjC7UpcGWJovx@shell.armlinux.org.uk>
 <E1o8fA7-0059aO-K8@rmk-PC.armlinux.org.uk>
 <20220706102621.hfubvn3wa6wlw735@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220706102621.hfubvn3wa6wlw735@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 06, 2022 at 01:26:21PM +0300, Vladimir Oltean wrote:
> Hello,
> 
> On Tue, Jul 05, 2022 at 10:48:07AM +0100, Russell King (Oracle) wrote:
> > diff --git a/net/dsa/port.c b/net/dsa/port.c
> > index 35b4e1f8dc05..34487e62eb03 100644
> > --- a/net/dsa/port.c
> > +++ b/net/dsa/port.c
> > @@ -1525,6 +1525,7 @@ int dsa_port_phylink_create(struct dsa_port *dp)
> >  {
> >  	struct dsa_switch *ds = dp->ds;
> >  	phy_interface_t mode, def_mode;
> > +	struct device_node *phy_np;
> >  	int err;
> >  
> >  	/* Presence of phylink_mac_link_state or phylink_mac_an_restart is
> > @@ -1559,6 +1560,13 @@ int dsa_port_phylink_create(struct dsa_port *dp)
> >  		return PTR_ERR(dp->pl);
> >  	}
> >  
> > +	if (dp->type == DSA_PORT_TYPE_CPU || dp->type == DSA_PORT_TYPE_DSA) {
> > +		phy_np = of_parse_phandle(dp->dn, "phy-handle", 0);
> > +		of_node_put(phy_np);
> > +		if (!phy_np)
> > +			err = phylink_set_max_fixed_link(dp->pl);
> 
> Can we please limit phylink_set_max_link_speed() to just the CPU ports
> where a fixed-link property is also missing, not just a phy-handle?
> Although to be entirely correct, we can also have MLO_AN_INBAND, which
> wouldn't be covered by these 2 checks and would still represent a valid
> DT binding.

More importantly, we need your input on Ocelot, which you are listed as
a maintainer for, and Ocelot is the only DSA driver that does stuff
differently (due to the rate adapting PCS). It doesn't set
mac_capabilities, and therefore phylink_set_max_fixed_link() will not
work here.

Has Ocelot ever made use of this DSA feature where, when nothing is
specified for a CPU or DSA port, we use an effective fixed-link setup
with an interface mode that gives the highest speed? Or does this not
apply to this DSA driver?

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
