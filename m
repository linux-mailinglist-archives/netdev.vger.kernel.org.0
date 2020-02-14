Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C82A215D8C2
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 14:50:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729092AbgBNNu5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 08:50:57 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:44320 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728216AbgBNNu4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 08:50:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=5o5fq/+Rmipo1x3fgmdHzLOarWzv4wCY8CKcndszr84=; b=dhwLV1U2TNUFNZft1POpI1a9J
        FrcV/aE/hw0Un7UlxVgxBLgQbUsgJGgZ10fFdA9O3pCxf7HEK0A05PRQlJkWSU6y4RoE4AmhnIOjm
        cxMpvj5XHSyrmS6RXMHU1PWPiFOgpOMA7eUzaFuEeSNWggsqKOSQkI5fcQh5iC9cKBk/diJPAISyK
        YfdE5d54SXk3DvKVdiPQku4HvIdHUM/Jx45NkUOhf06Hjzh1fkPKCxk3sOXlFkvnLPoqm9CvkAhOz
        EQha8j0gfoR7avWpitf5/Io1d23eN+6mCYRaQzYvQjJVclVbFsDQUD9cy1EJiEkugJ7A0Hvl+9/nd
        isJo5C4QQ==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:47754)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1j2bMi-0007GV-1E; Fri, 14 Feb 2020 13:50:44 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1j2bMa-0003QK-9B; Fri, 14 Feb 2020 13:50:36 +0000
Date:   Fri, 14 Feb 2020 13:50:36 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        John Crispin <john@phrozen.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: Heads up: phylink changes for next merge window
Message-ID: <20200214135036.GK18808@shell.armlinux.org.uk>
References: <20200213133831.GM25745@shell.armlinux.org.uk>
 <20200213144615.GH18808@shell.armlinux.org.uk>
 <20200213160004.GC31084@lunn.ch>
 <20200213171602.GO25745@shell.armlinux.org.uk>
 <20200213174500.GI18808@shell.armlinux.org.uk>
 <20200214104148.GJ18808@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200214104148.GJ18808@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 14, 2020 at 10:41:48AM +0000, Russell King - ARM Linux admin wrote:
> On Thu, Feb 13, 2020 at 05:45:00PM +0000, Russell King - ARM Linux admin wrote:
> > On Thu, Feb 13, 2020 at 05:16:02PM +0000, Russell King - ARM Linux admin wrote:
> > > On Thu, Feb 13, 2020 at 05:00:04PM +0100, Andrew Lunn wrote:
> > > > On Thu, Feb 13, 2020 at 02:46:16PM +0000, Russell King - ARM Linux admin wrote:
> > > > > [Recipient list updated; removed addresses that bounce, added Ioana
> > > > > Ciornei for dpaa2 and DSA issue mentioned below.]
> > > > > 
> > > > > On Thu, Feb 13, 2020 at 01:38:31PM +0000, Russell King - ARM Linux admin wrote:
> > > > > > Hi,
> > > > > > 
> > > > > > During the next round of development changes, I wish to make some
> > > > > > changes to phylink which will affect almost every user out there,
> > > > > > as it affects the interfaces to the MAC drivers.
> > > > > > 
> > > > > > The reason behind the change is to allow us to support situations
> > > > > > where the MAC is not closely coupled with its associated PCS, such
> > > > > > as is found in mvneta and mvpp2.  This is necessary to support
> > > > > > already existing hardware properly, such as Marvell DSA and Xilinx
> > > > > > AXI ethernet drivers, and there seems to be a growing need for this.
> > > > > > 
> > > > > > What I'm proposing to do is to move the MAC setup for the negotiated
> > > > > > speed, duplex and pause settings to the mac_link_up() method, out of
> > > > > > the existing mac_config() method.  I have already converted the
> > > > > > axienet, dpaa2-mac, macb, mvneta, mvpp2 and mv88e6xxx (dsa) drivers,
> > > > > > but I'm not able to test all those.  Thus far, I've tested dpaa2-mac,
> > > > > > mvneta, and mv88e6xxx.  There's a bunch of other drivers that I don't
> > > > > > know enough about the hardware to do the conversion myself.
> > > > > 
> > > > > I should also have pointed out that with mv88e6xxx, the patch
> > > > > "net: mv88e6xxx: use resolved link config in mac_link_up()" "fixes" by
> > > > > side-effect an issue that Andrew has mentioned, where inter-DSA ports
> > > > > get configured down to 10baseHD speed.  This is by no means a true fix
> > > > > for that problem - which is way deeper than this series can address.
> > > > > The reason it fixes it is because we no longer set the speed/duplex
> > > > > in mac_config() but set it in mac_link_up() - but mac_link_up() is
> > > > > never called for CPU and DSA ports.
> > > > > 
> > > > > However, I think there may be another side-effect of that - any fixed
> > > > > link declaration in DT may not be respected after this patch.
> > > > > 
> > > > > I believe the root of this goes back to this commit:
> > > > > 
> > > > >   commit 0e27921816ad99f78140e0c61ddf2bc515cc7e22
> > > > >   Author: Ioana Ciornei <ioana.ciornei@nxp.com>
> > > > >   Date:   Tue May 28 20:38:16 2019 +0300
> > > > > 
> > > > >   net: dsa: Use PHYLINK for the CPU/DSA ports
> > > > > 
> > > > > and, in the case of no fixed-link declaration, phylink has no idea what
> > > > > the link parameters should be (and hence the initial bug, where
> > > > > mac_config gets called with speed=0 duplex=0, which gets interpreted as
> > > > > 10baseHD.)  Moreover, as far as phylink is concerned, these links never
> > > > > come up. Essentially, this commit was not fully tested with inter-DSA
> > > > > links, and probably was never tested with phylink debugging enabled.
> > > > > 
> > > > > There is currently no fix for this, and it is not an easy problem to
> > > > > resolve, irrespective of the patches I'm proposing.
> > > > 
> > > > Hi Russell
> > > > 
> > > > I've been playing around with this a bit. I have a partial fix:
> > > > 
> > > > diff --git a/net/dsa/port.c b/net/dsa/port.c
> > > > index 9b54e5a76297..dc4da4dc44f5 100644
> > > > --- a/net/dsa/port.c
> > > > +++ b/net/dsa/port.c
> > > > @@ -629,9 +629,14 @@ static int dsa_port_phylink_register(struct dsa_port *dp)
> > > >  int dsa_port_link_register_of(struct dsa_port *dp)
> > > >  {
> > > >         struct dsa_switch *ds = dp->ds;
> > > > +       struct device_node *phy_np;
> > > >  
> > > > -       if (!ds->ops->adjust_link)
> > > > -               return dsa_port_phylink_register(dp);
> > > > +       if (!ds->ops->adjust_link) {
> > > > +               phy_np = of_parse_phandle(dp->dn, "phy-handle", 0);
> > > > +               if (of_phy_is_fixed_link(dp->dn) || phy_np)
> > > > +                       return dsa_port_phylink_register(dp);
> > > > +               return 0;
> > > > +       }
> > > >  
> > > >         dev_warn(ds->dev,
> > > >                  "Using legacy PHYLIB callbacks. Please migrate to PHYLINK!\n");
> > > > @@ -646,11 +651,12 @@ void dsa_port_link_unregister_of(struct dsa_port *dp)
> > > >  {
> > > >         struct dsa_switch *ds = dp->ds;
> > > >  
> > > > -       if (!ds->ops->adjust_link) {
> > > > +       if (!ds->ops->adjust_link && dp->pl) {
> > > >                 rtnl_lock();
> > > >                 phylink_disconnect_phy(dp->pl);
> > > >                 rtnl_unlock();
> > > >                 phylink_destroy(dp->pl);
> > > > +               dp->pl = NULL;
> > > >                 return;
> > > >         }
> > > > 
> > > > So basically only instantiate phylink if there is a fixed-link
> > > > property, or a phy-handle.
> > > > 
> > > > What i think is still broken is if there is a phy-mode property, and
> > > > nothing else. e.g. to set RGMII delays. I think that will get ignored.
> > > 
> > > Can you please verify that mac_link_up() gets called for these if
> > > there is a fixed-link property or phy-handle?
> > > 
> > > Also, there is another way around this, which is for phylink_create()
> > > to callback through the mac_ops to request the default configuration.
> > > That could be plumbed down through the various DSA layers such that
> > > the old "max speed / max link" business could be setup.  However,
> > > that brings with it a new problem: if we default to a fixed-link, then
> > > attempting to connect a phy later will be ignored.  However, deferring
> > > the default create-time configuration setup to phylink_start() would
> > > work around it, but brings with it a bit more complexity.
> > 
> > Hmm.
> > 
> > Andrew, it is possible that what I have in the ZII branch does end
> > up fixing this problem by accident without requiring any further
> > code changes in DSA.
> > 
> > If a node has no fixed-link nor PHY, phylink defaults to MLO_AN_PHY
> > mode - and without a PHY, phylink will never believe that the link
> > has come up.  Hence, mac_link_up() will never be called.
> > 
> > If a node has a fixed-link property, then phylink will parse it,
> > and by default, fixed-links without GPIOs or a callback function
> > will come up at initialisation.  Hence, we get a mac_link_up()
> > call with the fixed-link parameters.
> > 
> > If a node has a PHY, then DSA will instruct phylink to connect to
> > it, and it will behave as any other PHY-attached MAC, calling
> > mac_link_up() at the appropriate time.
> > 
> > The mv88e6xxx driver by default configures CPU and DSA ports to
> > maximum speed, which is what we get if mac_link_up() is never
> > called.  On the other hand, if there's a fixed-link or PHY, we'll
> > call mac_link_up() to program those parameters.
> > 
> > So, provided all drivers are converted to program the speed/duplex
> > etc in mac_link_up(), we might not have a problem at all - and
> > that would be an additional motivation for everyone to update to
> > the changes I've proposed!
> > 
> > What I don't like - if the above is correct - is that this is
> > merely coincidental.
> > 
> > Now, while that sounds great, something's niggling me about it.
> > If the link is forced up by the DSA driver initialisation defaulting
> > the speed to maximum speed, but phylink believes the link to be down,
> > and then we get a mac_link_up() call, with the patches as they stand
> > we end up changing the port configuration while the link is up, which
> > I'm sure I've read shouldn't be done in some of the DSA switch
> > functional specs.  Hmm.
> 
> Hi Andrew,
> 
> Having added some additional debug into mv88e6xxx, it seems that it's
> not working as I thought it would be on the ZII dev rev C, but does on
> the ZII dev rev B.
> 
> On the ZII dev rev C:
> 
> [   23.082294] mv88e6085 0.1:00: p0: Force link down
> [   23.095527] mv88e6085 0.1:00: p0: Force link up
> [   23.116490] mv88e6085 0.1:00: p1: Force link down
> [   23.122065] mv88e6085 0.1:00: p1: Unforce link down
> [   23.137928] mv88e6085 0.1:00: p2: Force link down
> [   23.143487] mv88e6085 0.1:00: p2: Unforce link down
> [   23.159416] mv88e6085 0.1:00: p3: Force link down
> [   23.164986] mv88e6085 0.1:00: p3: Unforce link down
> [   23.181277] mv88e6085 0.1:00: p4: Force link down
> [   23.186925] mv88e6085 0.1:00: p4: Unforce link down
> [   23.202864] mv88e6085 0.1:00: p9: Force link down
> [   23.208434] mv88e6085 0.1:00: p9: Unforce link down
> [   23.227698] mv88e6085 0.1:00: p10: Force link down
> [   23.233372] mv88e6085 0.1:00: p10: Force link up
> ...
> [   24.294145] mv88e6085 0.1:00: configuring for fixed/ link mode
> [   24.300435] mv88e6085 0.1:00: phylink_mac_config: mode=fixed//100Mbps/Full adv=000,00000000,00002208 pause=00 link=0 an=1
> [   24.300474] mv88e6085 0.1:00: p0: dsa_port_phylink_mac_config()
> [   24.302905] mv88e6085 0.1:00: phylink_mac_config: mode=fixed//100Mbps/Full adv=000,00000000,00002208 pause=00 link=1 an=1
> [   24.303035] mv88e6085 0.1:00: p0: dsa_port_phylink_mac_config()
> [   24.303756] mv88e6085 0.1:00: p0: dsa_port_phylink_mac_link_up()
> [   24.303797] mv88e6085 0.1:00: Link is Up - 100Mbps/Full - flow control off
> ...
> [   24.436179] mv88e6085 0.1:00: configuring for phy/xaui link mode
> [   24.442578] mv88e6085 0.1:00: phylink_mac_config: mode=phy/xaui/Unsupported (update phy-core.c)/Half adv=000,00000000,00000000 pause=00 link=0 an=0
> [   24.442615] mv88e6085 0.1:00: p10: dsa_port_phylink_mac_config()
> 
> This is with:
> 
>         if (reg & MV88E6XXX_PORT_MAC_CTL_FORCE_LINK &&
>             reg & MV88E6XXX_PORT_MAC_CTL_LINK_UP)
>                 dev_err(chip->dev, "p%d: forcing link speed/duplex with port up\n", port);
> 
> added in to mv88e6xxx_port_set_speed_duplex(), which never fires.  Yet,
> we can see from the above that port 0 and port 10 were forced up
> earlier.
> 
> Hence, phylink isn't playing a part in setting the speed and duplex on
> this port, yet port 0's mac control is 0x203e and port 10's is 0x203f.
> They are both forcing link up, forced full duplex, and port 0 is forced
> to 1G and port 10 to 10G.  So, the problem you mentioned does still
> exist.
> 
> This comes down to my comment in the code (in mac_link_up and
> mac_link_down):
> 
>         /* Internal PHYs propagate their configuration directly to the MAC.
>          * External PHYs depend on whether the PPU is enabled for this port.
>          * FIXME: we should be using the PPU enable state here. What about
>          * an automedia port?
>          */
>         if (!mv88e6xxx_phy_is_internal(ds, port) && ops->port_set_link) {
> 
> and suggests this is the wrong test to be using here.  I'm not sure
> if using the PPU PHY detect bit is correct either, but looking at
> what I have here, it seems to be _more_ correct than not.
> 
> For the 88e6390, mv88e6xxx_phy_is_internal() will be true for all ports
> 0 through 8, and for the 88e6352, ports 0 through 4.  So, these two
> methods will only force settings for port 9 and 10 for the 88e6390 and
> port 5 and 6 on the 88e6352.
> 
> The reasoning is, if the PHY detect bit is set, the PPU should be
> polling the attached PHY and automatically updating the MAC to reflect
> the PHY status.  This seems great...
> 
> On the ZII dev rev C, we have the following port status values:
> - port 0 = 0xe04
> - port 1 through 8 = 0x100f
> - port 9 = 0x49
> - port 10 = 0xcf4c
> 
> On the ZII dev rev B, port 4 (which is one of the optical ports) has a
> value of 0xde09, despite being linked to the on-board serdes.  It seems
> that the PPU on the 88e6352 automatically propagates the status from the
> serdes there.
> 
> So, it looks to me like using the PHY detect bit is the right solution,
> we just need access to it at this mid-layer...
> 
> On the ZII dev rev B, I see what I expect:
> 
> mv88e6085 0.1:00: p0: Force link down
> mv88e6085 0.1:00: p0: Unforce link down
> mv88e6085 0.1:00: p1: Force link down
> mv88e6085 0.1:00: p1: Unforce link down
> mv88e6085 0.1:00: p2: Force link down
> mv88e6085 0.1:00: p2: Unforce link down
> mv88e6085 0.1:00: p4: Force link down
> mv88e6085 0.1:00: p4: Unforce link down
> mv88e6085 0.1:00: p5: Force link down
> mv88e6085 0.1:00: p5: Force link up
> mv88e6085 0.1:00: p6: Force link down
> mv88e6085 0.1:00: p6: Force link up
> ...
> mv88e6085 0.1:00: configuring for fixed/rgmii-txid link mode
> mv88e6085 0.1:00: phylink_mac_config: mode=fixed/rgmii-txid/1Gbps/Full adv=000,00000000,00002220 pause=00 link=0 an=1
> mv88e6085 0.1:00: p5: dsa_port_phylink_mac_config()
> mv88e6085 0.1:00: phylink_mac_config: mode=fixed/rgmii-txid/1Gbps/Full adv=000,00000000,00002220 pause=00 link=1 an=1
> mv88e6085 0.1:00: p5: dsa_port_phylink_mac_config()
> mv88e6085 0.1:00: p5: dsa_port_phylink_mac_link_up()
> mv88e6085 0.1:00: p5: forcing link speed/duplex with port up
> mv88e6085 0.1:00: p5: Force link up
> mv88e6085 0.1:00: Link is Up - 1Gbps/Full - flow control off
> mv88e6085 0.1:00: configuring for fixed/ link mode
> mv88e6085 0.1:00: phylink_mac_config: mode=fixed//100Mbps/Full adv=000,00000000,00002208 pause=00 link=0 an=1
> mv88e6085 0.1:00: p6: dsa_port_phylink_mac_config()
> mv88e6085 0.1:00: phylink_mac_config: mode=fixed//100Mbps/Full adv=000,00000000,00002208 pause=00 link=1 an=1
> mv88e6085 0.1:00: p6: dsa_port_phylink_mac_config()
> mv88e6085 0.1:00: p6: dsa_port_phylink_mac_link_up()
> mv88e6085 0.1:00: p6: forcing link speed/duplex with port up
> mv88e6085 0.1:00: p6: Force link up
> mv88e6085 0.1:00: Link is Up - 100Mbps/Full - flow control off
> 
> which shows that we're changing the speed and duplex with the port up
> as I suspected in my reply yesterday, which the functional specs say we
> shouldn't do.

I've now pushed out the debugging changes, and a change to use the
PHY_DETECT bit instead in my zii branch.

Note that the "changing with link up" issue affects several calls
in addition to the port_set_speed_duplex() methods, including
port_set_rgmii_delay(), and likely the port_set_cmode() methods.

I'm also wondering whether forcing the link down, updating the
configuration, and then restoring the link status gains us anything.
When we do that, we could be forcing the link down in the middle of
a packet - and we won't wait for that packet to finish before making
the change.  If we're not forcing the link down and merely change
the configuration, how is that any different - we still end up with
a corrupted packet.  Maybe the forcing-link-down event marks any
ingressing packet bad, but what about egressing packets...  Not sure.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
