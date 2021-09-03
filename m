Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6697D3FFF82
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 14:01:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349233AbhICMCj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 08:02:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349210AbhICMCi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 08:02:38 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8663CC061575
        for <netdev@vger.kernel.org>; Fri,  3 Sep 2021 05:01:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=JgwscaMUpXgyTZeGxZugIB9RkvSSJBr2ZFYYVlecTa8=; b=sQQLqWHorusda8xQTZC/4nbAJ
        40pO0E2jnx+EIROr6IA5ih55c2gHSgGx/xlHPNEjDVsivR++Xzq2Hlik9Gb3rE7PahOVmLPFKdXdF
        2XVdRpthnt+Fxn/quJU98BWZbl1YI7ikSP6G30APgxxuY1D5o6FU7CsKLmSz2BDoVSZMeQv5Qxa2H
        UdDqStDDpBHEHPcHHbcKY4Fj22OMSfRxIMN8q1lPon98Ug0KuI4WjcV6MgojO9C3zgv/qM5uNNzuk
        1tyS7YBc1dXRgmzX5xRrLiaZp2U/O95DV1nq8+lANaARi2swYihlJbEBxgpqgtKpoPcBBPBVDBYZN
        ZQh8LNGmw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:48148)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mM7sw-0002zU-Lx; Fri, 03 Sep 2021 13:01:30 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mM7st-0000U5-PG; Fri, 03 Sep 2021 13:01:27 +0100
Date:   Fri, 3 Sep 2021 13:01:27 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH] net: stmmac: fix MAC not working when system resume back
 with WoL enabled
Message-ID: <20210903120127.GW22278@shell.armlinux.org.uk>
References: <20210902083224.GC22278@shell.armlinux.org.uk>
 <DB8PR04MB67954F4650408025E6D4EE2AE6CE9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210902104943.GD22278@shell.armlinux.org.uk>
 <DB8PR04MB6795C37D718096E7CA1AA72DE6CE9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <YTDCZN/WKlv9BsNG@lunn.ch>
 <DB8PR04MB6795C36B8211EE1A1C0280D9E6CF9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210903080147.GS22278@shell.armlinux.org.uk>
 <DB8PR04MB679518228AB7B2C5CD47A1B3E6CF9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210903093246.GT22278@shell.armlinux.org.uk>
 <DB8PR04MB6795EE2FA03451AB5D73EFC3E6CF9@DB8PR04MB6795.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DB8PR04MB6795EE2FA03451AB5D73EFC3E6CF9@DB8PR04MB6795.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 03, 2021 at 11:04:57AM +0000, Joakim Zhang wrote:
> 
> Hi Russell,
> 
> [...]
> > > > > > -----Original Message-----
> > > > > > From: Andrew Lunn <andrew@lunn.ch>
> > > > > > Sent: 2021年9月2日 20:24
> > > > > > To: Joakim Zhang <qiangqing.zhang@nxp.com>
> > > > > > Cc: Russell King <linux@armlinux.org.uk>; Vladimir Oltean
> > > > > > <olteanv@gmail.com>; peppe.cavallaro@st.com;
> > > > > > alexandre.torgue@foss.st.com; joabreu@synopsys.com;
> > > > > > davem@davemloft.net; kuba@kernel.org;
> > mcoquelin.stm32@gmail.com;
> > > > > > netdev@vger.kernel.org; f.fainelli@gmail.com;
> > > > > > hkallweit1@gmail.com; dl-linux-imx <linux-imx@nxp.com>
> > > > > > Subject: Re: [PATCH] net: stmmac: fix MAC not working when
> > > > > > system resume back with WoL enabled
> > > > > >
> > > > > > > Emm, @andrew@lunn.ch, Andrew is much familiar with FEC, and
> > > > > > > PHY maintainers, Could you please help put insights here if possible?
> > > > > >
> > > > > > All the boards i have either have an Ethernet Switch connected
> > > > > > to the MAC, or a Micrel PHY. None are setup for WoL, since it is
> > > > > > not used in the use case of these boards.
> > > > > >
> > > > > > I think you need to scatter some printk() in various places to
> > > > > > confirm what is going on. Where is the WoL implemented: MAC or
> > > > > > PHY, what is suspended or not, etc.
> > > > >
> > > > > Thanks Andrew, Russell,
> > > > >
> > > > > I confirmed FEC is MAC-based WoL, and PHY is active when system
> > > > suspended if MAC-based WoL is active.
> > > > > I scatter printk() in both phy_device.c and realtek.c phy driver
> > > > > to debug this
> > > > for both WoL active and inactive case.
> > > > >
> > > > > When MAC-based WoL is active, phy_suspend() is the last point to
> > > > > actually
> > > > suspend the PHY, you can see that,
> > > > > 	phy_ethtool_get_wol(phydev, &wol);
> > > > > 	if (wol.wolopts || (netdev && netdev->wol_enabled))
> > > > > 		return -EBUSY;
> > > > >
> > > > > Here, netdev is true and netdev->wol_enabled is ture
> > > > > (net/ethtool/wol.c: ethnl_set_wol() -> dev->wol_enabled =
> > > > > !!wol.wolopts;) So that phydev->suspend() would not be called, PHY
> > > > > is active
> > > > after system suspended. PHY can receive packets and pass to MAC, MAC
> > > > is responsible for detecting magic packets then generate a wakeup
> > > > interrupt. So all is fine for FEC, and the behavior is clear.
> > > >
> > > > What happens on resume with FEC?
> > >
> > > Since we call phy_stop() in fec_suspend(), the link is down, but the
> > > PHY is active, after receiving magic packets, the system resume back;
> > > In fec_resume(), after restart/init FEC, we call phy_start() to let link up, then
> > all is going well.
> > 
> > ... but the link never went down! So I don't understand the last point.
> 
> Sorry, what the meaning of "the link never went down"? How do you define
> the link is down? May be I have not get your original point correctly.

If the link goes down, connectivity between the MAC and the outside
world is lost - whether that be the link between the MAC and PHY, or
PHY and the outside world. That's my definition of "link down".

However, if the MAC is still alive and receiving packets, even for
Wake-on-Lan purposes, from the outside world then the link can not be
down, it must be operational and therefore it must be in the "up"
state.

I'm talking about the physical state of the link - "up" meaning capable
of passing packets to and from the MAC, "down" meaning incapable of
passing packets.

> At my side, with MAC-based WoL is active, FEC calls phy_stop() in
> fec_suspend(), then fec_enet_adjust_link() is called, further
> fec_stop() is called, FEC only keep necessary receive logic active
> to service WoL. This is not the link went down? At least I see the
> log " fec 30be0000.ethernet eth0: Link is Down".

It looks like calling phy_stop() will force a link-down event to be
reported from phylib. As I say above though, really, this doesn't
affect the physical state of the link, because the link has to be
up for the WoL packets to be received by the MAC.

What I don't like about that is that we're saying that the link is
down, whereas the physical link is actually still up. This is going
to make network drivers implementation of mac_link_down() rather
yucky, especially ones that force the physical link down at the MAC
end when operating in PHY mode and they see a call to mac_link_down()
(which they do to stop packet reception.) There's no way for them to
know whether mac_link_down() is a result of a real physical link down
event, or whether this is a "soft" link down event as you're describing
at a suspend.

Then there's the issue that some network drivers _must_ see a
mac_link_down() call to force the link down prior to reconfiguring
the link (since settings are not allowed to be changed while the
physical link is up.) So we start to destroy the guarantee that
mac_link_down() and mac_link_up() will be properly ordered.

Damn it.

> > There's a few more questions:
> > 1. Since the state at this point will be that netdev and phylink believe
> >    the link to still be up, should phylink_suspend() force a
> >    netif_carrier_off() event to stop the netdev transmit watchdog - I
> >    think it ought to, even though the link will actually remain up.
> 
> Agree.

Note that phylib in the FEC case will do this just before calling
the adjust_link function already.

With phylink, we can make that silent, and I think it should be silent
because, as I describe above, the physical link isn't actually going
down.

> > 2. Should we call mac_link_down() prior to the major reconfig - I think
> >    we should to keep the mac_link_down()/mac_link_up() calls balanced
> >    (as we do already guarantee.) Will that do any harm for stmmac if we
> >    were to call mac_link_down() as a result of a call to
> >    phylink_resume() ?
> 
> For STMMAC, I think it's safe, since we calling phylink_resume() before re-config MAC.
> But we design this for common usage, other MAC drivers may call this at the end of resume
> path, but I think it also safe, like we unplug then plug the cable. However, it will print the LINK DOWN
> then LINK UP log, which is very strange when system resume back. Is there any better solution?

I think at this point, we should just print the state of the link at
resume, which should basically be only a "link down" if the link is
now physically down at resume.

One thing worries me though - what happens if the link parameters
change while the system is suspended. The MAC won't be updated with
the new link parameters. What happens on resume?

> > Why is it different from the .ndo_stop/.ndo_open case, where the PHY may
> > have been suspended by the actions of .ndo_stop?
> 
> It's a good question. PHY will suspend by the actions od .ndo_stop, but it will resume
> before we config MAC. Please see stmmac_open(), stmmac_init_phy()->phylink_of_phy_connect()
> -> phy_attach_direct(): phy_resume(phydev), where PHY will be resume backed.

Ah, I forgot FEC does the PHY connect/disconnect at open/stop. Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
