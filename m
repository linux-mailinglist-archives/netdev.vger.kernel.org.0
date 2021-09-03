Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E22F53FFD2E
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 11:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348829AbhICJd7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 05:33:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244272AbhICJd6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 05:33:58 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E18FC061575
        for <netdev@vger.kernel.org>; Fri,  3 Sep 2021 02:32:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=AkAUfQFX11xzdh/it+RaUnXZHT4m8fQAIx/HpoewkEE=; b=F/FV46rWc27BStJjNrVIO169u
        xfgD0hmGKTqwLYcz+G0Hi6cHTRXk2WRujR6it24G2/oKDNBG2ME85ydP/J0/ZthoYwB6BTb/8Trag
        e2cn8RcKaclgieWfFZsfzmcvaio8+YozJrVyhX4Rrdp45c48UHshcQPX31UOsOguIEzcVNXAbEzm4
        tpp5ykGzffKhvSsrqsERWrnIMuwvsR+RiFW1132oV2iocniirNxJWlyb6TNmgX7Zx0bg1A7ri8vAb
        gDobRdqgWq4kWOFteX3S/00McWPUQICNmlszk2WdaVZlz3fEMAs4IqDLoYovyLckDlwJWwW1FpYMf
        sc1iXqZNw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:48140)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mM5Z3-0002ne-KS; Fri, 03 Sep 2021 10:32:49 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mM5Z0-0000Mo-Gr; Fri, 03 Sep 2021 10:32:46 +0100
Date:   Fri, 3 Sep 2021 10:32:46 +0100
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
Message-ID: <20210903093246.GT22278@shell.armlinux.org.uk>
References: <20210901132547.GB22278@shell.armlinux.org.uk>
 <DB8PR04MB6795BB2A13AED5F6E56D08A0E6CE9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210902083224.GC22278@shell.armlinux.org.uk>
 <DB8PR04MB67954F4650408025E6D4EE2AE6CE9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210902104943.GD22278@shell.armlinux.org.uk>
 <DB8PR04MB6795C37D718096E7CA1AA72DE6CE9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <YTDCZN/WKlv9BsNG@lunn.ch>
 <DB8PR04MB6795C36B8211EE1A1C0280D9E6CF9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210903080147.GS22278@shell.armlinux.org.uk>
 <DB8PR04MB679518228AB7B2C5CD47A1B3E6CF9@DB8PR04MB6795.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DB8PR04MB679518228AB7B2C5CD47A1B3E6CF9@DB8PR04MB6795.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 03, 2021 at 08:39:23AM +0000, Joakim Zhang wrote:
> 
> Hi Russell,
> 
> > -----Original Message-----
> > From: Russell King <linux@armlinux.org.uk>
> > Sent: 2021年9月3日 16:02
> > To: Joakim Zhang <qiangqing.zhang@nxp.com>
> > Cc: Andrew Lunn <andrew@lunn.ch>; Vladimir Oltean <olteanv@gmail.com>;
> > peppe.cavallaro@st.com; alexandre.torgue@foss.st.com;
> > joabreu@synopsys.com; davem@davemloft.net; kuba@kernel.org;
> > mcoquelin.stm32@gmail.com; netdev@vger.kernel.org; f.fainelli@gmail.com;
> > hkallweit1@gmail.com; dl-linux-imx <linux-imx@nxp.com>
> > Subject: Re: [PATCH] net: stmmac: fix MAC not working when system resume
> > back with WoL enabled
> > 
> > On Fri, Sep 03, 2021 at 06:51:09AM +0000, Joakim Zhang wrote:
> > >
> > > > -----Original Message-----
> > > > From: Andrew Lunn <andrew@lunn.ch>
> > > > Sent: 2021年9月2日 20:24
> > > > To: Joakim Zhang <qiangqing.zhang@nxp.com>
> > > > Cc: Russell King <linux@armlinux.org.uk>; Vladimir Oltean
> > > > <olteanv@gmail.com>; peppe.cavallaro@st.com;
> > > > alexandre.torgue@foss.st.com; joabreu@synopsys.com;
> > > > davem@davemloft.net; kuba@kernel.org; mcoquelin.stm32@gmail.com;
> > > > netdev@vger.kernel.org; f.fainelli@gmail.com; hkallweit1@gmail.com;
> > > > dl-linux-imx <linux-imx@nxp.com>
> > > > Subject: Re: [PATCH] net: stmmac: fix MAC not working when system
> > > > resume back with WoL enabled
> > > >
> > > > > Emm, @andrew@lunn.ch, Andrew is much familiar with FEC, and PHY
> > > > > maintainers, Could you please help put insights here if possible?
> > > >
> > > > All the boards i have either have an Ethernet Switch connected to
> > > > the MAC, or a Micrel PHY. None are setup for WoL, since it is not
> > > > used in the use case of these boards.
> > > >
> > > > I think you need to scatter some printk() in various places to
> > > > confirm what is going on. Where is the WoL implemented: MAC or PHY,
> > > > what is suspended or not, etc.
> > >
> > > Thanks Andrew, Russell,
> > >
> > > I confirmed FEC is MAC-based WoL, and PHY is active when system
> > suspended if MAC-based WoL is active.
> > > I scatter printk() in both phy_device.c and realtek.c phy driver to debug this
> > for both WoL active and inactive case.
> > >
> > > When MAC-based WoL is active, phy_suspend() is the last point to actually
> > suspend the PHY, you can see that,
> > > 	phy_ethtool_get_wol(phydev, &wol);
> > > 	if (wol.wolopts || (netdev && netdev->wol_enabled))
> > > 		return -EBUSY;
> > >
> > > Here, netdev is true and netdev->wol_enabled is ture
> > > (net/ethtool/wol.c: ethnl_set_wol() -> dev->wol_enabled =
> > > !!wol.wolopts;) So that phydev->suspend() would not be called, PHY is active
> > after system suspended. PHY can receive packets and pass to MAC, MAC is
> > responsible for detecting magic packets then generate a wakeup interrupt. So
> > all is fine for FEC, and the behavior is clear.
> > 
> > What happens on resume with FEC?
> 
> Since we call phy_stop() in fec_suspend(), the link is down, but the PHY is active, after receiving
> magic packets, the system resume back; In fec_resume(), after restart/init FEC, we call phy_start()
> to let link up, then all is going well.

... but the link never went down! So I don't understand the last point.

> > > For STMMAC, when MAC-based WoL is active, according to the current
> > > implementation, only call phylink_mac_change()=false, PHY would be
> > > active, so PHY can receive packets then pass to MAC, MAC ignore packets
> > except magic packets. System can be waked up successfully.
> > >
> > > The issue is that phylink_mac_change()=false only notify a phylink of
> > > a change in MAC state, as we analyzed before, PHY would link up again
> > > before system suspended, which lead to .mac_link_up can't be called when
> > system resume back. Unfortunately, all MAC configurations are in
> > stmmac_mac_link_up(), as a result, MAC has not been initialized correctly
> > when system resume back, so that it can't work any longer.
> > 
> > Oh, I thought your problem was that the system didn't wake up.
> > 
> > In any case, remove the calls to phylink_mac_change() from the suspend and
> > resume functions, they are completely _incorrect_.
> 
> Ok, I will do that.
> 
> > > Intend to fix this obvious breakage, I did some work:
> > > Removing phylink_mac_change() (Russell said it's for MLO_AN_INBAND,
> > > but we have a MLO_AN_PHY) from suspend/resume path, then adding
> > > phylink_stop() in suspend, phylink_start() in resume() also for WoL active path.
> > I found remote magic packets can't wake up the system, I firstly suspect PHY
> > may be suspended. After further debug, I confirm that PHY is active, and
> > stmmac_pmt() is correctly configured.
> > 
> > As I've said a few times now, if the MAC is doing the wakeup, you need the PHY
> > to MAC link to be up, so you should _not_ call
> > phylink_stop() and phylink_start() from the suspend/resume functions because
> > they will take the link down.
> 
> Yes, I recall you said this before. Is it the requirement for phylink?
> For FEC, we call phy_stop() when suspend, and phy_start() when resume, with MAC is doing
> the wakeup.

phylink_stop() will synchronously force the phy/mac link down if it
wasn't already down, and it'll do this by calling the mac_link_down()
method.

phylink_start() will remove the force-down that phylink_stop() places,
and will re-resolve the link. You will get a "major reconfiguration"
event, and if the link is up, a mac_link_up() call.

These are primarily designed to be called from the .ndo_open and
.ndo_stop calls (as their kerneldoc mentions) but have found their way
into suspend/resume methods.

If a MAC is being suspended - as in powered down - you definitely want
to bring it down to a safe state where link events are not going to
affect the MAC. Calling phylink_stop() will do that. On resume, you
want to reconfigure and allow the MAC to receive link events, and
calling phylink_start() will do that.

However, if the MAC is not being suspended because you want WoL to
work, then you need the PHY/MAC link _not_ to be brought down so the
MAC can receive packets and examine them to see if it should wake up.
Phylink does not really cater for that case - it wasn't on my radar
as I don't have any modern systems that support suspend/resume, much
less MAC based WoL.

> > Maybe I should provide phylink_suspend()/phylink_resume() which look at the
> > netdev state just like phylib does, and conditionally call
> > phylink_stop() and phylink_start() so driver authors don't have to consider this.
> > 
> > Something like:
> > 
> > /**
> >  *...
> >  * @mac_wol: true if the MAC needs to receive packets for Wake-on-Lan  */
> > void phylink_suspend(struct phylink *phylink, bool mac_wol) {
> > 	ASSERT_RTNL();
> > 
> > 	if (!mac_wol && !(phylink->netdev && phylink->netdev->wol_active))
> > 		phylink_stop(phylink);
> > }
> > 
> > /**
> >  *...
> >  * @mac_wol: true if the MAC needs to receive packets for Wake-on-Lan
> >  *
> >  * @mac_wol must have the same value as passed previously to
> >  * phylink_suspend().
> >  */
> > void phylink_resume(struct phylink *phylink, bool mac_wol) {
> > 	ASSERT_RTNL();
> > 
> > 	if (!mac_wol && !(phylink->netdev && phylink->netdev->wol_active))
> > 		phylink_start(phylink);
> > }
> 
> That's great!!! MAC driver authors don't need to distinguish the different cases.
> 
> > > The conclusion is that, as long as we call phylink_stop() for WoL
> > > active in suspend(), then system can't be waked up any longer, and the
> > > PHY situation is active. This let me recall what Russell mentioned in this
> > thread, if we need bring MAC link up with phylink framework to let MAC can
> > see traffic from PHY when MAC-based WoL is active?
> > >
> > > Now, I don't know where I can further dig into this issue, if you have any
> > advice please share with me , thanks in advance.
> > 
> > So my question now is: as the MAC needs to be alive while the system is
> > suspended, that implies that it has been configured to receive packets. When
> > the system resumes, why exactly doesn't the MAC continue to work? Does the
> > MAC get reset after the system comes out of resume and lose all of its
> > configuration?
> 
> Yes, as I described in commit message, when STMMAC resume back, either WoL is active or not,
> it reset the hardware then reconfig the MAC.
> stmmac_resume()->stmmac_hw_setup()->stmmac_init_dma_engine()...

Okay, so that means I need to make phylink_resume() trigger a major
config if we are using WoL.

There's a few more questions:
1. Since the state at this point will be that netdev and phylink believe
   the link to still be up, should phylink_suspend() force a
   netif_carrier_off() event to stop the netdev transmit watchdog - I
   think it ought to, even though the link will actually remain up.
2. Should we call mac_link_down() prior to the major reconfig - I think
   we should to keep the mac_link_down()/mac_link_up() calls balanced
   (as we do already guarantee.) Will that do any harm for stmmac if we
   were to call mac_link_down() as a result of a call to
   phylink_resume() ?

> > Reading what stmmac_resume() does, it seems that may well be the case, or if
> > not, the actions of stmmac_resume() ends up reprogramming a great deal of
> > the device setup. If this is the case, then yes, we need phylink to be triggered
> > to reconfigure the link - which we could do in
> > phylink_resume() if mac_wol was active.
> > 
> > While reading stmmac_resume(), I have to question the placement of this code
> > block:
> > 
> >         if (!device_may_wakeup(priv->device) || !priv->plat->pmt) {
> >                 rtnl_lock();
> >                 phylink_start(priv->phylink);
> >                 /* We may have called phylink_speed_down before */
> >                 phylink_speed_up(priv->phylink);
> >                 rtnl_unlock();
> >         }
> > 
> > in the sequence there - phylink_start() should be called when you're ready for
> > the link to come up - in other words, when you're ready to start seeing packets
> > arrive at the MAC's interface. However, the code following is clearing and
> > resetting up queues, restoring receive modes, setting up the hardware, and
> > restoring the vlan filtering.
> > Surely all that should happen before calling phylink_start(), much like it already
> > does in stmmac_open() ?
> 
> There is a story here, SNPS EQOS IP need PHY provides RXC clock for MAC's receive
> logic, so we need phylink_start() to bring PHY link up, that make PHY resume back,
> PHY could stop RXC clock when in suspended state. This is the reason why calling phylink_start()
> before re-config MAC.

Why is it different from the .ndo_stop/.ndo_open case, where the PHY may
have been suspended by the actions of .ndo_stop?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
