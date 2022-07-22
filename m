Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA0457E8CE
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 23:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233326AbiGVVUp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 17:20:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbiGVVUo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 17:20:44 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CE8A275CC;
        Fri, 22 Jul 2022 14:20:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=3eKaRdI8CjUQ36NeljKOepydGnzwI1tgXoOCDHqlXNI=; b=QMP94vzKADV/yccm6/kvM9BLSi
        G2g/00z/DYnRhs6SvJ7g4yONCo4H8aSDQD0td+2DVGzfoNKTB91xF8ttwnlN5e1kGk9VzorbJ20+i
        0d4CXkr1+3le+tCNWQgXXe46a6qHID7/il3FtVHg6S8BL+71DhEw6K9MVYUcg5bOTC4zkOUI/XkBJ
        gPCdEtGTt7AVDL1T6pohjiv0zOiromKtePVppxMhRWpkDRC9QlTu98mqkDbdwp+RcXuhVZ480UqPG
        y6O+Z/13BA7+6AK9L5NCD6lPo3EKdbOLB0LlMG6GyKcYQgEL8UuocMGKd0ISXd6mDNniW5OtIP1VP
        byJiwvmg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33518)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oF04D-0007bi-1Q; Fri, 22 Jul 2022 22:20:13 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oF045-00068Q-Kh; Fri, 22 Jul 2022 22:20:05 +0100
Date:   Fri, 22 Jul 2022 22:20:05 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Alvin __ipraga <alsi@bang-olufsen.dk>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Daniel Scally <djrscally@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        DENG Qingfang <dqfext@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sean Wang <sean.wang@mediatek.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: Re: [PATCH net-next 3/6] net: dsa: add support for retrieving the
 interface mode
Message-ID: <YtsUhdg3a2rT3NJC@shell.armlinux.org.uk>
References: <20220721192145.1f327b2a@dellmb>
 <20220721182216.z4vdaj4zfb6w3emo@skbuf>
 <YtnBmFm8Jhokgp7Q@shell.armlinux.org.uk>
 <20220721213645.57ne2jf7f6try4ec@skbuf>
 <YtpfmF37FmfY6BV5@shell.armlinux.org.uk>
 <20220722105238.qhfq5myqa4ixkvy4@skbuf>
 <YtqNkSDLRDtuooy/@shell.armlinux.org.uk>
 <20220722124629.7y3p7nt6jmm5hecq@skbuf>
 <YtqjFKUTsH4CK0L+@shell.armlinux.org.uk>
 <20220722165600.lldukpdflv7cjp4j@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220722165600.lldukpdflv7cjp4j@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 22, 2022 at 07:56:00PM +0300, Vladimir Oltean wrote:
> On Fri, Jul 22, 2022 at 02:16:04PM +0100, Russell King (Oracle) wrote:
> > > So mvneta at the stage of the commit you've mentioned calls
> > > mvneta_set_autoneg() with the value of pp->use_inband_status. There is
> > > then the exception to be made for the PCS being what's exposed to the
> > > medium, and in that case, ethtool may also override the pp->use_inband_status
> > > variable (which in turn affects the autoneg).
> > > 
> > > So if we take mvneta at this commit as the reference, what we learn is
> > > that using in-band status essentially depends on using in-band autoneg
> > > in the first place.
> > > 
> > > What is hard for me to comprehend is how we ever came to conclude that
> > > for SERDES protocols where clause 37 is possible (2500base-x should be
> > > part of this group), managed = "in-band-status" does not imply in-band
> > > autoneg, considering the mvneta precedent.
> > 
> > That is a recent addition, since the argument was made that when using
> > a 1000base-X fibre transceiver, using ethtool to disable autoneg is a
> > reasonable thing to do - and something that was supported with
> > mvneta_ethtool_set_link_ksettings() as it stands at the point in the
> > commit above.
> 
> I'm sorry, I don't understand. What is the recent addition, and recent
> relative to what? The 2500base-x link mode? Ok, but this is only
> tangentially related to the point overall, more below.

I'm talking about how we handle 1000base-X autoneg - specifically this
commit:

92817dad7dcb net: phylink: Support disabling autonegotiation for PCS

where we can be in 1000base-X with managed = "in-band-status" but we
have autoneg disabled. I thought that is what you were referring to.

As for 2500base-X, I had been raising the issue of AN in the past, for
example (have I said it's really difficult to find old emails even with
google?):

https://lwn.net/ml/netdev/20200618140623.GC1551@shell.armlinux.org.uk/

and eventually I stopped caring about it, as it became pointless to
raise it anymore when we had an established mixture of behaviours. This
is why we have ended up with PCS drivers configuring for no AN for a
firmware description of:

	managed = "in-band-status";
	phy-mode = "2500base-x";

and hence now have unclean semantics for this - some such as mvneta
and mvpp2 will have AN enabled. Others such as pcs-lynx will not.
However, both will request link status from the PCS side and use that
to determine whether the link is up, and use the parameters that the
PCS code returns for the link. Since 2500base-X can only operate at
2.5G, PCS code always reports SPEED_2500, and as half duplex is
virtually never supported above 1G, DUPLEX_FULL.

> > > And why would we essentially redefine its meaning by stating that no,
> > > it is only about the status, not about the autoneg, even though the
> > > status comes from the autoneg for these protocols.
> > 
> > I'm not sure I understand what you're getting at there.
> 
> Sorry if I haven't made my point clear.
> 
> My point is that drivers may have more restrictive interpretations of
> managed = "in-band-status", and the current logic of automatically
> create a fixed-link for DSA's CPU ports is going to cause problems when
> matched up with a DSA master that expects in-band autoneg for whatever
> SERDES protocol.
> 
> What I'd like to happen as a result is that no DSA driver except Marvell
> opts into this by default, and no driver opts into it without its maintainer
> understanding the implications. Otherwise we're going to normalize the
> expectation that a managed = "in-band-status" DSA master should be able
> to interoperate with a fixed-link CPU port, but during this discussion
> there was no argument being brought that a strict interpretation of
> "in-band-status" as "enable autoneg" is incorrect in any way.

I still don't understand your point - because you seem to be conflating
two different things (at least as I understand it.)

We have this:

		port@N {
			reg = <N>;
			label = "cpu";
			ethernet = <&ethX>;
		};

This specifies that the port operates at whatever interface mode and
settings gives the maximum speed. There is no mention of a "managed"
property, and therefore (Andrew, correct me if I'm wrong) in-band
negotiation is not expected to be used.

The configuration of the ethX parameters on the other end of the link
are up to the system integrator to get right, and the actual behaviour
would depend on the ethernet driver. As I've said in previous emails,
there is such a thing as "AN bypass" that can be implemented, and it
can default to be enabled, and drivers can ignore that such a bit even
exists. So, it's possible that even with "managed" set to
"in-band-status" in DT, a link to such a DSA switch will still come up
even though we've requested in DT for AN to be used.

If an ethernet driver is implemented to strictly require in-band AN in
this case, then the link won't come up, and the system integrator would
have to debug the problem.

I think this is actually true on Clearfog - if one specifies the CPU
port as I have above, and requests in-band on the host ethernet, then
the link doesn't come up, because mvneta turns off AN bypass.

> > Going back to the mvneta combined PCS+MAC implementation, we read the
> > link parameters from the PCS when operating in in-band mode and throw
> > them at the fixed PHY so that ethtool works, along with all the usual
> > link up/down state reporting, carrier etc.
> > 
> > If autoneg is disabled, then we effectively operate in fixed-link mode
> > (use_inband_status becomes false, and we start forcing the link up/down
> > and also force the speed and duplex parameters by disabling autoneg.)
> > 
> > Note that this version of mvneta does not support 1000base-X mode, only
> > SGMII is actually supported.
> > 
> > There's a few things that are rather confusing in the driver:
> > 
> > MVNETA_GMAC_INBAND_AN_ENABLE - this controls whether in-band negotiation
> > is performed or not.
> > MVNETA_GMAC_AN_SPEED_EN - this controls whether the result of in-band
> > negotiation for speed is used, or the manually programmed speed in this
> > register.
> > MVNETA_GMAC_AN_DUPLEX_EN - same for duplex.
> > MVNETA_GMAC_AN_FLOW_CTRL_EN - same for pause (only symmetric pause is
> > supported)
> > 
> > MVNETA_GMAC2_INBAND_AN_ENABLE - misnamed, it selects whether SGMII (set)
> > or 1000base-X (unset) format for the 16-bit control word is used.
> > 
> > There is another bit in MVNETA_GMAC_CTRL_0 that selects between
> > 1000base-X and SGMII operation mode, and when this bit is set for
> > 1000base-X. This version of the driver doesn't support 1000base-X,
> > so this bit is never set.
> 
> Thanks for this explanation, if nothing else, it seems to support the
> way in which I was interpreting managed = "in-band-status" to mean
> "enable in-band autoneg", but to be clear, I wasn't debating something
> about the way in which mvneta was doing things. But rather, I was
> debating why would *other* drivers do things differently such as to come
> to expect that a fixed-link master + an in-band-status CPU port, or the
> other way around, may be compatible with each other.

Please note that phylink makes a DT specification including both a
fixed-link descriptor and a managed in-band-status property illegal
because these are two different modes of operating the link, and they
conflict with each other.

The fact that the of_fixed_link_whateveritwas() function (sorry I can't
remember the name) returns true for both indicating that they're both
fixed-link is a historic artifact that has not been changed. As the
fixed-PHY code supporting that way was dropped, I suppose that should
have been cleaned up at some point, but I never got around to it
(remember, development in this space is a very slow process.) There
were always more pressing matters to be dealt with.

Maybe we should now make of_fixed_link_whateveritwas() no longer return
true, and introduce of_managed_in_band() or something like that which
drivers can test that separately. I'm not sure it's worth the driver
churn to make such a change, I'm not sure what the benefit would be.

> Anyway, before I comment any further on the other points, I have a board
> using armada-3720-turris-mox.dts on which I wanted to make a test, but I
> don't fully understand the results, could you help me do so?
> 
> By default, both the mvneta master and my 6390 top-most switch are
> configured for inband/2500base-x. In essence I'm perfectly fine with
> that. I don't care whether IEEE standardized inband/2500base-x, as long
> as both drivers come to expect to enable or disable inband depending on
> the device tree.
> 
> I've dumped the variables from mvneta_pcs_get_state() and it appears
> that the mvneta is reporting AN complete. This would suggest that there
> is indeed in-band autoneg taking place with the 6390 switch.
> 
> Then I modified the device tree to disable in-band autoneg (I've checked
> mv88e6390_serdes_pcs_config and it behaves how I'd expect, enabling
> BMCR_ANENABLE strictly according to phylink_autoneg_inband(mode)).
> Essentially what I'm trying is to intentionally break in-band autoneg by
> causing a mismatch, to prove that it is indeed taking place.
> 
> The results are interesting: state->an_complete is still reported as 1
> for eth1 (mvneta).
> 
> ip link set eth1 up
> [   70.809889] mvneta d0040000.ethernet eth1: configuring for inband/2500base-x link mode
> [   70.818086] mvneta_pcs_get_state: MVNETA_GMAC_AUTONEG_CONFIG 0x9b4c state->an_complete 0 state->speed 2500 state->pause 0x3 state->link 0 state->duplex 1
> [   70.836081] mvneta_pcs_get_state: MVNETA_GMAC_AUTONEG_CONFIG 0x9b4c state->an_complete 0 state->speed 2500 state->pause 0x3 state->link 0 state->duplex 1
> [   70.843748] mv88e6085 d0032004.mdio-mii:10: Link is Down
> [   70.859944] mv88e6085 d0032004.mdio-mii:10: mv88e6390_serdes_pcs_config: port 9 MV88E6390_SGMII_ADVERTISE 0xa0 adv 0x80 changed 1
> [   70.878737] mv88e6085 d0032004.mdio-mii:10: mv88e6390_serdes_pcs_config: port 9 MV88E6390_SGMII_BMCR 0x140 bmcr 0x140 phylink_autoneg_inband(mode) 0
> [   70.898302] mv88e6085 d0032004.mdio-mii:10: Link is Up - 2.5Gbps/Full - flow control off
> [   71.069532] mvneta_pcs_get_state: MVNETA_GMAC_AUTONEG_CONFIG 0x9b4c state->an_complete 1 state->speed 2500 state->pause 0x3 state->link 1 state->duplex 1
> [   71.083376] mvneta d0040000.ethernet eth1: Link is Up - 2.5Gbps/Full - flow control rx/tx
> [   71.091672] IPv6: ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
> 
> Then I studied MVNETA_GMAC_AUTONEG_CONFIG and I noticed that the bit
> you're talking about, MVNETA_GMAC_AN_BYPASS_ENABLE (bit 3) is indeed set
> by default (the driver doesn't set it).

Correct - because of history, and changing it could break setups that
have been working since before DT. The driver has never changed the
bypass bit, so playing with that when phylink was introduced risked
regressions.

> I've intentionally masked it off in mvneta_pcs_config() by setting it in
> the "mask" variable and nowhere else. Now I get:
> 
> ip link set eth1 up
> [  434.336679] mvneta d0040000.ethernet eth1: configuring for inband/2500base-x link mode
> [  434.342618] mv88e6085 d0032004.mdio-mii:10: Link is Down
> [  434.350020] mvneta_pcs_get_state: MVNETA_GMAC_AUTONEG_CONFIG 0x9b44 state->an_complete 0 state->speed 2500 state->pause 0x3 state->link 0 state->duplex 1
> [  434.350055] mvneta_pcs_get_state: MVNETA_GMAC_AUTONEG_CONFIG 0x9b44 state->an_complete 0 state->speed 2500 state->pause 0x3 state->link 0 state->duplex 1
> [  434.384794] mv88e6085 d0032004.mdio-mii:10: mv88e6390_serdes_pcs_config: port 9 MV88E6390_SGMII_ADVERTISE 0xa0 adv 0x80 changed 1
> [  434.403808] mv88e6085 d0032004.mdio-mii:10: mv88e6390_serdes_pcs_config: port 9 MV88E6390_SGMII_BMCR 0x140 bmcr 0x140 phylink_autoneg_inband(mode) 0
> [  434.423732] mv88e6085 d0032004.mdio-mii:10: Link is Up - 2.5Gbps/Full - flow control off
> 
> so state->an_complete now remains zero, and the link is down on the CPU
> port, and indeed I can no longer ping the board from the outside world.

We can see that the DSA switch thinks the link came up, but mvneta
didn't because autoneg never completed. We can see from the
MV88E6390_SGMII_BMCR value that AN is definitely disabled. So we
positively have one end of the link configured for no AN (a fixed
link) and the other side configured for AN.

That is expected with a strict and correct implementation. As you've
spotted, mvneta is not a strict implementation, because it defaults
to allowing bypass mode, which allows the dissimilar configuration
due to history.

However, what you will find is that you will get the same results
with or without these patches applied - because the DSA switch will
default to not using in-band AN on its CPU port, and that isn't
changed when the DSA port is brought up without phylink.

> So what this is telling me is that mvneta has some built-in resilience
> to in-band autoneg mismatches, via MVNETA_GMAC_AN_BYPASS_ENABLE. But that
> (a) doesn't make it valid to mix and match a fixed-link with a managed =
>     "in-band-status" mode
> (b) doesn't mean it's unspecified whether managed = "in-band-status"
>     should dictate whether to enable in-band autoneg or not
> (c) doesn't mean that other devices/drivers support "AN bypass" to save
>     the day and make an invalid DT description appear to work just fine
> 
> This further supports my idea that we should make a better attempt of
> matching the DSA master's mode with the node we're faking in DSA for
> phylink. For Marvell hardware you or Andrew are surely more knowledgeable
> to be able to say whether that's needed right now or not. But in the
> general case please don't push this to everyone, it just muddies the
> waters.

I really don't get this.

For a mv88e6xxx port which supports 1000base-X, with these patches
applied, then these are all effectively equivalent:

		port@N {
			reg = <N>;
			label = "cpu";
			ethernet = <&ethX>;
		};

		port@N {
			reg = <N>;
			label = "cpu";
			ethernet = <&ethX>;
			phy-mode = "1000base-x";
		};

		port@N {
			reg = <N>;
			label = "cpu";
			ethernet = <&ethX>;
			fixed-link {
				speed = <1000>;
				full-duplex;
			};
		};

		port@N {
			reg = <N>;
			label = "cpu";
			ethernet = <&ethX>;
			phy-mode = "1000base-x";
			fixed-link {
				speed = <1000>;
				full-duplex;
			};
		};

and all _should_ lead to inband AN being disabled.

That is my understanding of Andrew's statements on the defaulting
parameters for both the inter-switch and CPU ports. (Maybe Andrew can
clarify whether this is correct or not.)

However, this would not equivalent to any of the above:

		port@N {
			reg = <N>;
			label = "cpu";
			ethernet = <&ethX>;
			managed = "in-band-status";
		};

The reason this is not equivalent is - as you've recently spotted -
of_phy_is_fixed_link() will return true, and therefore phylink gets
passed the above node to work with - and we do not generate a swnode
fixed-link stanza for it. The behaviour in this case is completely
unaffected by these patches.

If a DSA driver defaults to AN enabled on the DSA/CPU ports, and makes
use of the defaulting firmware description, then this will break with
these patches, since we setup a fixed-link specifier that states that
no AN should be used. That's why I've been trying to get these tested,
and that's why there's a risk with them. However, that's got nothing
to do with whether the driver implements filling in this new
"default_interface" field.

We could go delving into the node pointed to by the phandle and retrieve
whatever parameters from there, but that is an entirely new behaviour
and would be a functional change to the behaviour that Andrew has been
promoting - and is itself not free of a risk of regressions caused by
that approach. What if there's an interface converter in the path between
the# CPU ethernet device and the DSA that hasn't needed to be described?
Digging out the phy-mode from the CPU side could be the wrong thing to
do.

Then there's the question whether DSA should have been validating that
the description on both ends of the link are compatible with each other.
The problem with that is just the same as the above - an undescribed
interface converter would make such validation problematical.

So, I don't think we could rely on the description on the other end of
the link to be capable of describing the setup on the DSA port end.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
