Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3B303FDD4A
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 15:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243519AbhIAN0z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 09:26:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243125AbhIAN0y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 09:26:54 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35837C061575
        for <netdev@vger.kernel.org>; Wed,  1 Sep 2021 06:25:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=gt1dFrZUaxaIOQDTRH5b3OsfYe+KDnvFK7vczlWAqSc=; b=DV/Imm7KggaOqKjhbl8qj3pbK
        zzhyPEboxQzBefDXmnIUqVHjk85S8rHv/9ztb9A/S6BU4oKl4udSvvq/ygY3wiUsdpywS7e43U09u
        WuHng90pgJBaF5Y6GiWz3oPtwtK23n6aTBqYaqE0BAabuHgafvGbGY3z9wga1muUUJ0kSZduJ0MOj
        kyBBdMEOcyrfpldLtImCx6k9yscpnZrIJypCp68MmVoLgiZauSQ0wb4MfqtncIdPTRSYXjb91clDO
        8v3SIJI1d7fboCHstzCAu/cUikf6zKvAO3VEzRtQEVPryKk7KIhUgUGmyv/TuOJmKHDtGDSunlKbT
        z9mvwGCUA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:47984)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mLQFR-0008I0-W6; Wed, 01 Sep 2021 14:25:50 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mLQFP-0006so-HQ; Wed, 01 Sep 2021 14:25:47 +0100
Date:   Wed, 1 Sep 2021 14:25:47 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH] net: stmmac: fix MAC not working when system resume back
 with WoL enabled
Message-ID: <20210901132547.GB22278@shell.armlinux.org.uk>
References: <20210901090228.11308-1-qiangqing.zhang@nxp.com>
 <20210901092149.fmap4ac7jxf754ao@skbuf>
 <DB8PR04MB6795CCAE06AA7CEB5CCEC521E6CD9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210901105611.y27yymlyi5e4hys5@skbuf>
 <DB8PR04MB67956C22F601DA8B7DC147D5E6CD9@DB8PR04MB6795.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DB8PR04MB67956C22F601DA8B7DC147D5E6CD9@DB8PR04MB6795.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 01, 2021 at 11:42:08AM +0000, Joakim Zhang wrote:
> Hi Vladimir,
> 
> > -----Original Message-----
> > From: Vladimir Oltean <olteanv@gmail.com>
> > Sent: 2021年9月1日 18:56
> > To: Joakim Zhang <qiangqing.zhang@nxp.com>
> > Cc: peppe.cavallaro@st.com; alexandre.torgue@foss.st.com;
> > joabreu@synopsys.com; davem@davemloft.net; kuba@kernel.org;
> > mcoquelin.stm32@gmail.com; linux@armlinux.org.uk;
> > netdev@vger.kernel.org; andrew@lunn.ch; f.fainelli@gmail.com;
> > hkallweit1@gmail.com; dl-linux-imx <linux-imx@nxp.com>
> > Subject: Re: [PATCH] net: stmmac: fix MAC not working when system resume
> > back with WoL enabled
> > 
> > On Wed, Sep 01, 2021 at 10:25:15AM +0000, Joakim Zhang wrote:
> > >
> > > Hi Vladimir,
> > >
> > > > -----Original Message-----
> > > > From: Vladimir Oltean <olteanv@gmail.com>
> > > > Sent: 2021年9月1日 17:22
> > > > To: Joakim Zhang <qiangqing.zhang@nxp.com>
> > > > Cc: peppe.cavallaro@st.com; alexandre.torgue@foss.st.com;
> > > > joabreu@synopsys.com; davem@davemloft.net; kuba@kernel.org;
> > > > mcoquelin.stm32@gmail.com; linux@armlinux.org.uk;
> > > > netdev@vger.kernel.org; andrew@lunn.ch; f.fainelli@gmail.com;
> > > > hkallweit1@gmail.com; dl-linux-imx <linux-imx@nxp.com>
> > > > Subject: Re: [PATCH] net: stmmac: fix MAC not working when system
> > > > resume back with WoL enabled
> > > >
> > > > On Wed, Sep 01, 2021 at 05:02:28PM +0800, Joakim Zhang wrote:
> > > > > We can reproduce this issue with below steps:
> > > > > 1) enable WoL on the host
> > > > > 2) host system suspended
> > > > > 3) remote client send out wakeup packets We can see that host
> > > > > system resume back, but can't work, such as ping failed.
> > > > >
> > > > > After a bit digging, this issue is introduced by the commit
> > > > > 46f69ded988d
> > > > > ("net: stmmac: Use resolved link config in mac_link_up()"), which
> > > > > use the finalised link parameters in mac_link_up() rather than the
> > > > > parameters in mac_config().
> > > > >
> > > > > There are two scenarios for MAC suspend/resume:
> > > > >
> > > > > 1) MAC suspend with WoL disabled, stmmac_suspend() call
> > > > > phylink_mac_change() to notify phylink machine that a change in
> > > > > MAC state, then .mac_link_down callback would be invoked. Further,
> > > > > it will call phylink_stop() to stop the phylink instance. When MAC
> > > > > resume back, firstly phylink_start() is called to start the
> > > > > phylink instance, then call phylink_mac_change() which will
> > > > > finally trigger phylink machine to invoke .mac_config and
> > > > > .mac_link_up callback. All is fine since configuration in these two callbacks
> > will be initialized.
> > > > >
> > > > > 2) MAC suspend with WoL enabled, phylink_mac_change() will put
> > > > > link down, but there is no phylink_stop() to stop the phylink
> > > > > instance, so it will link up again, that means .mac_config and
> > > > > .mac_link_up would be invoked before system suspended. After
> > > > > system resume back, it will do DMA initialization and SW reset
> > > > > which let MAC lost the hardware setting (i.e MAC_Configuration
> > > > > register(offset 0x0) is reset). Since link is up before system
> > > > > suspended, so .mac_link_up would not be invoked after system
> > > > > resume back, lead to there is no chance to initialize the
> > > > > configuration in .mac_link_up callback, as a result, MAC can't work any
> > longer.
> > > >
> > > > Have you tried putting phylink_stop in .suspend, and phylink_start
> > in .resume?
> > >
> > > Yes, I tried, but the system can't be wakeup with remote packets.
> > > Please see the code change.
> > 
> > That makes it a PHY driver issue then, I guess?
> > At least some PHY drivers avoid suspending when WoL is active, like
> > lan88xx_suspend.
> > Even the phy_suspend function takes wol.wolopts into consideration before
> > proceeding to call the driver. What PHY driver is it?
> 
> I think it's not the PHY issue, since both STMMAC and FEC controllers on i.MX8MP use the same
> PHY(Realtek RTL8211FD, drivers/net/phy/realtek.c), there is no issue with FEC.

Note that FEC calls phylink_stop() in fec_suspend() if the net device
was up. So that kind of rules out phylink and phylib too... and
points towards stmmac doing something it shouldn't.

> > Bad assumption in the stmmac driver, if the intention was for the link state
> > change to be induced to phylink after the resume?
> 
> Yes, I also think link state change should be captured after the resume, it's very strange that
> link up again before suspended. You would see below log if I add no_console_suspend in cmdline.

... because phylink_mac_change() is not supposed to be used to force
the link down. I can't say this loudly enough: Read the documentation.
I don't write it just for my pleasure, it's there to help others get
stuff correct. If people aren't going to read it, I might as well not
waste the time writing it.

 * phylink_mac_change() - notify phylink of a change in MAC state
 * @pl: a pointer to a &struct phylink returned from phylink_create()
 * @up: indicates whether the link is currently up.
 *
 * The MAC driver should call this driver when the state of its link
 * changes (eg, link failure, new negotiation results, etc.)

Realise that "up" is there merely to capture that the link has gone
down - but by the time phylink reacts to that (which may be some time
*after* this call has been made - it is *not* synchronous since it's
meant to be called from an *interrupt*) the link state may well have
changed again. So, phylink will always recheck the link state with
up = false, so you _will_ get the link going down and then up.

In any case "change in MAC state" is only applicable when in in-band
mode, not in PHY mode, so you should not be calling this if you have
a PHY attached which isn't in in-band mode.

> 
> root@imx8mpevk:~# ethtool -s eth1 wol g
> [   76.309460] stmmac: wakeup enable

So you've asked it to wake on MagicPacket, which is WAKE_MAGIC. As
you got the message "wakeup enable" which is emitted by
stmmac_set_wol(), this will only be emitted if priv->plat->pmt() is
set. It will _not_ call phylink_ethtool_set_wol().

So, you are not using the PHY-based wake-on-lan, but the MAC based
wake-on-lan. This means you need to have the phy <-> mac link up
during suspend, and in that case, yes, you do not want to call
phylink_stop() or phylink_start().

I'm not sure what stmmac_pmt() does - thanks to the macro stuff, I'd
need to trace it through the driver and find out where that goes,
and also which variant of stmmac you're using... so without more
information I can't follow what the driver is doing.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
