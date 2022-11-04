Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA42A619D60
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 17:35:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231667AbiKDQfn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 12:35:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230041AbiKDQfm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 12:35:42 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7452B26AF0
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 09:35:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=6U5GM9CDnuPYeUBmOY3yvVRmtco3O0xxyNkzgUFtJfA=; b=koddq24MmTim1WxSbkHVwp6lRS
        F+lTIb90obciOlER1BphazJwbNHvmR3N7AXdPZfCof/GIbmpXlW5Ns5Tmvh35goh/rRJTM7S8Yzqc
        LE1/tTuwK53obMgvYBsu/WfYXk8bgE6yzgUG3InDp8mwZBQKl/XonhP8cXylldT/Z4sTuh40FZ0GD
        fqkbR8fSHbSPNYvU1MAwKNxv5BLHETOj6QWsR9FtVmdrtL/7AACNu1IFb2cFbvtbRB3GUw10tXTUd
        m9ml4FS2ED8U7eRwScmbXh4yIjwEvOEot8qMhi7KT1V0anQJ2Yci6PKAlvEN6zcBXv90MiyleSMZz
        F0E6d3Ig==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35112)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oqzfG-0007qp-4r; Fri, 04 Nov 2022 16:35:30 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oqzfC-000123-58; Fri, 04 Nov 2022 16:35:26 +0000
Date:   Fri, 4 Nov 2022 16:35:26 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Sean Anderson <sean.anderson@seco.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next 4/4] net: dsa: remove phylink_validate() method
Message-ID: <Y2U/Ts5WqIf8pjJI@shell.armlinux.org.uk>
References: <20221101114806.1186516-1-vladimir.oltean@nxp.com>
 <20221101114806.1186516-5-vladimir.oltean@nxp.com>
 <Y2T2fIb5SBRQbn8I@shell.armlinux.org.uk>
 <Y2T47CorBztXGgS4@shell.armlinux.org.uk>
 <7186132a-7040-7131-396d-f1d6321e39d7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7186132a-7040-7131-396d-f1d6321e39d7@gmail.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 04, 2022 at 08:40:56AM -0700, Florian Fainelli wrote:
> On 11/4/2022 4:35 AM, Russell King (Oracle) wrote:
> > diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
> > index 18a3847bd82b..6676971128d1 100644
> > --- a/drivers/net/dsa/bcm_sf2.c
> > +++ b/drivers/net/dsa/bcm_sf2.c
> > @@ -727,6 +727,10 @@ static void bcm_sf2_sw_get_caps(struct dsa_switch *ds, int port,
> >   		__set_bit(PHY_INTERFACE_MODE_MII, interfaces);
> >   		__set_bit(PHY_INTERFACE_MODE_REVMII, interfaces);
> >   		__set_bit(PHY_INTERFACE_MODE_GMII, interfaces);
> > +
> > +		/* FIXME 1: Are RGMII_RXID and RGMII_ID actually supported?
> > +		 * See FIXME 2 and FIXME 3 below.
> > +		 */
> 
> They are supported, just not tested and still don't have hardware to test, I
> suppose you can include both modes for simplicity if they end up being
> broken, a fix would be submitted.

Okay, that sounds like we can add them to the switch() in
bcm_sf2_sw_mac_config(). I assume id_mode_dis should be zero for
these other modes.

> > +static void bcm_sf2_sw_validate(struct dsa_switch *ds, int port,
> > +				unsigned long *supported,
> > +				struct phylink_link_state *state)
> > +{
> > +	u32 caps;
> > +
> > +	caps = dsa_to_port(ds, port)->pl_config.mac_capabilities;
> > +
> > +	/* Pause modes are only programmed for these modes - see FIXME 3.
> > +	 * So, as pause modes are not configured for other modes, disable
> > +	 * support for them. If FIXME 3 is updated to allow the other RGMII
> > +	 * modes, these should be included here as well.
> > +	 */
> > +	if (!(state->interface == PHY_INTERFACE_MODE_RGMII ||
> > +	      state->interface == PHY_INTERFACE_MODE_RGMII_TXID ||
> > +	      state->interface == PHY_INTERFACE_MODE_MII ||
> > +	      state->interface == PHY_INTERFACE_MODE_REVMII))
> > +		caps &= ~(MAC_ASYM_PAUSE | MAC_SYM_PAUSE);
> 
> Can be programmed on all ports.

If I understand you correctly, I think you mean that this can be
programmed on all ports that support the RGMII control register:

        if (phy_interface_mode_is_rgmii(interface) ||
            interface == PHY_INTERFACE_MODE_MII ||
            interface == PHY_INTERFACE_MODE_REVMII) {
                reg_rgmii_ctrl = bcm_sf2_reg_rgmii_cntrl(priv, port);
                reg = reg_readl(priv, reg_rgmii_ctrl);
                reg &= ~(RX_PAUSE_EN | TX_PAUSE_EN);

                if (tx_pause)
                        reg |= TX_PAUSE_EN;
                if (rx_pause)
                        reg |= RX_PAUSE_EN;

                reg_writel(priv, reg, reg_rgmii_ctrl);
        }

We seem to have several places in the code that make this decision -
bcm_sf2_sw_mac_link_set(). I'm guessing, looking at
bcm_sf2_reg_rgmii_cntrl(), that we _could_ use the device ID and port
number in bcm_sf2_sw_get_caps() to narrow down whether the pause
modes are supported - as ports that do not have the RGMII control
register can't have pause modes programmed?

So for the BCM4908, it's just port 7, and for everything else it's
ports 0-2.

That would mean something like:

static void bcm_sf2_sw_get_caps(struct dsa_switch *ds, int port,
                                struct phylink_config *config)
{
...
	struct bcm_sf2_priv *priv = bcm_sf2_to_priv(ds);
...
	config->mac_capabilities = MAC_10 | MAC_100 | MAC_1000;

	if (priv->type == BCM4908_DEVICE_ID ? port == 7 :
	    (port >= 0 && port < 3))
		config->mac_capabilities |= MAC_ASYM_PAUSE | MAC_SYM_PAUSE;

may be sensible?

It brings up another question: if the port supports this register, but
we aren't using one of the rgmii, mii or revmii modes, should we be
clearing the pause bits in this register if we're telling the system
that pause isn't supported, or does the hardware not look at this RGMII
register unless its in one of those three modes?

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
