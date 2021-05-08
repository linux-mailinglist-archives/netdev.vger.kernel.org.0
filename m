Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8C1C3773D9
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 21:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbhEHTkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 15:40:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbhEHTkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 May 2021 15:40:17 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9745AC061574;
        Sat,  8 May 2021 12:39:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=jlOPCSK2nRsEwzsZJOeJDlZYSy04L7PKk/OEX0babh8=; b=1hF67LgOgSVJl00M6MckSAPaZ
        nOZ9xzjCD6Lsp3aYOKa5GGWaLXwwOxz1Wu4dqB5r/rejS48Qa4oI1IE/0ozPb1NOZ6mORinSsBXu5
        Jf9TNIV4i5fBOyJ2ccrbU2LiuzlqCeEueK3qwvKOuqVqYkXpBNPs64uh7BHCkOmfof0c+302sel82
        EHx62/o5ARqOGG43NcJPzmmwYUqVHEOYWF7ua3KaIjFZ7KiUfbUdJlDZv2kzS+mfAKPxyISZxNJbK
        nk05Oo5UiaQwchZTh0d+5Lyj8K/n+v4wr0nvJpLS+4y5JGZ8hI33stcvOWlWHg+VFiH/DLp5ymF1+
        Eww/1WxZA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:43794)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lfSnA-0006Kp-JO; Sat, 08 May 2021 20:39:12 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lfSn9-0006wz-G0; Sat, 08 May 2021 20:39:11 +0100
Date:   Sat, 8 May 2021 20:39:11 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next v3 19/20] net: dsa: qca8k: pass
 switch_revision info to phy dev_flags
Message-ID: <20210508193911.GG1336@shell.armlinux.org.uk>
References: <20210504222915.17206-1-ansuelsmth@gmail.com>
 <20210504222915.17206-19-ansuelsmth@gmail.com>
 <20210506112458.yhgbpifebusc2eal@skbuf>
 <YJXMit3YfBXKM98j@Ansuel-xps.localdomain>
 <20210507233353.GE1336@shell.armlinux.org.uk>
 <20210508182620.vmzjvmqhexutj7p3@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210508182620.vmzjvmqhexutj7p3@skbuf>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 08, 2021 at 09:26:20PM +0300, Vladimir Oltean wrote:
> On Sat, May 08, 2021 at 12:33:53AM +0100, Russell King - ARM Linux admin wrote:
> > On Sat, May 08, 2021 at 01:26:02AM +0200, Ansuel Smith wrote:
> > > On Thu, May 06, 2021 at 02:24:58PM +0300, Vladimir Oltean wrote:
> > > > On Wed, May 05, 2021 at 12:29:13AM +0200, Ansuel Smith wrote:
> > > > > Define get_phy_flags to pass switch_Revision needed to tweak the
> > > > > internal PHY with debug values based on the revision.
> > > > > 
> > > > > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> > > > > ---
> > > > >  drivers/net/dsa/qca8k.c | 19 +++++++++++++++++++
> > > > >  1 file changed, 19 insertions(+)
> > > > > 
> > > > > diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> > > > > index b4cd891ad35d..237e09bb1425 100644
> > > > > --- a/drivers/net/dsa/qca8k.c
> > > > > +++ b/drivers/net/dsa/qca8k.c
> > > > > @@ -1654,6 +1654,24 @@ qca8k_port_vlan_del(struct dsa_switch *ds, int port,
> > > > >  	return ret;
> > > > >  }
> > > > >  
> > > > > +static u32 qca8k_get_phy_flags(struct dsa_switch *ds, int port)
> > > > > +{
> > > > > +	struct qca8k_priv *priv = ds->priv;
> > > > > +
> > > > > +	pr_info("revision from phy %d", priv->switch_revision);
> > > > 
> > > > Log spam.
> > > > 
> > > > > +	/* Communicate to the phy internal driver the switch revision.
> > > > > +	 * Based on the switch revision different values needs to be
> > > > > +	 * set to the dbg and mmd reg on the phy.
> > > > > +	 * The first 2 bit are used to communicate the switch revision
> > > > > +	 * to the phy driver.
> > > > > +	 */
> > > > > +	if (port > 0 && port < 6)
> > > > > +		return priv->switch_revision;
> > > > > +
> > > > > +	return 0;
> > > > > +}
> > > > > +
> > > > >  static enum dsa_tag_protocol
> > > > >  qca8k_get_tag_protocol(struct dsa_switch *ds, int port,
> > > > >  		       enum dsa_tag_protocol mp)
> > > > > @@ -1687,6 +1705,7 @@ static const struct dsa_switch_ops qca8k_switch_ops = {
> > > > >  	.phylink_mac_config	= qca8k_phylink_mac_config,
> > > > >  	.phylink_mac_link_down	= qca8k_phylink_mac_link_down,
> > > > >  	.phylink_mac_link_up	= qca8k_phylink_mac_link_up,
> > > > > +	.get_phy_flags		= qca8k_get_phy_flags,
> > > > >  };
> > > > >  
> > > > >  static int qca8k_read_switch_id(struct qca8k_priv *priv)
> > > > > -- 
> > > > > 2.30.2
> > > > > 
> > > > 
> > > > Florian, I think at one point you said that a correct user of
> > > > phydev->dev_flags should first check the PHY revision and not apply
> > > > dev_flags in blind, since they are namespaced to each PHY driver?
> > > > It sounds a bit circular to pass the PHY revision to the PHY through
> > > > phydev->dev_flags, either that or I'm missing some piece.
> > > 
> > > Just to make sure. This is the SWITCH revision not the PHY revision. It
> > > was pointed out in old version that I should get this value from the PHY
> > > regs but they are different values. This is why the dsa driver needs to
> > > use the dev_flags to pass the SWITCH revision to the phy driver. Am I
> > > implementing this in the wrong way and I should declare something to
> > > pass this value in a more standard way? (anyway i'm pushing v4 so i
> > > don't know if we should continue that there)
> > 
> > Vladimir is confused - it is not PHY revision at all, but the PHY
> > identifiers.
> > 
> > What was actually suggested was checking the PHY identifiers before
> > passing PHY-driver specific flags, so that we didn't end up setting
> > driver private flags that are intending for one driver, but end up
> > actually binding a different driver, and mis-interpreting the flags.
> > 
> > This is one of the problems of the current scheme: it's just a
> > meaningless opaque u32 variable with no defined structure to it that
> > the various PHY drivers themselves use in whatever way they see fit.
> > That is only fine to use _if_ you know for certain which driver is
> > going to bind ahead of time.
> > 
> > As I mentioned in direct reply to your patch, there was discussions
> > about this back in February, but they seem to have stalled.
> 
> Yes, I was indeed confused. My problem was mixing up the PHY OUI/device ID
> and revision concepts in one big fuzzy notion. I remembered Heiner's
> suggestion to do something similar to mv88e6xxx_mdio_read from here:
> https://patchwork.kernel.org/project/netdevbpf/patch/20210423014741.11858-12-ansuelsmth@gmail.com/
> (where the problem is that some internal PHYs are lacking a device
> identifier) and thought that the problem here is the same.
> 
> Nonetheless, now it is clear to me that with care (don't set dev_flags
> except for internal PHYs which are statically known), it is possible for
> the PHY driver to have a larger identifier (PHY ID concatenated with
> switch revision passed through dev_flags) based on which it can
> configure the hardware.

We do have the problem with Marvell DSA vs Marvell PHY setup in that
the Marvell DSA driver assumes that all integrated PHYs that do not
have an ID are all the same. They are most definitely not, and this
shows itself up when we register the hwmon stuff inappropriately, or
access the wrong registers to report hwmon values.

We really need to solve this problem properly rather than bodging
around it with driver specific usage of dev_flags.

We already have the ability for drivers to have custom match functions
(match_phy_device) that do not depend on the probed ID - maybe we
should have an additional u32 member in struct phy_device for the
switch_id that the PHY is a part of that PHY drivers can check in their
match_phy_device method if necessary, or otherwise use that to parse
the switch revision from. Or something like that?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
