Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FC06477B45
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 19:06:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240533AbhLPSF7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 13:05:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233302AbhLPSF6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 13:05:58 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2BF1C061574;
        Thu, 16 Dec 2021 10:05:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ypq5FRmGowIxm2o88iZsyAK7sTnww+wg511WNtyrzrQ=; b=KljhWFv81b6HZVatcxcIHWln4r
        IvZwjPA+kIJDI/KKIWMsI7wnFWqwRBavKlWt5xlOU52xrNtbPbfwJzIaDT1Pobv0FwdRUy6hHZJU9
        2ZsqApGWzlu2GYsMsyGyEKHrc+Awf4eQ7lW9MRBv+zffWtDPjqlyBRX0cVRzd3GVVH/J60Oda8/I/
        EZl2j7Xc1/WuUvfypDfnnwSoke/qGh1GeRFUEe43ZKNzYotoG4FVjWSNvEwqM8ynKxCP+CQS2mnzI
        nNq1Qyh7baif8Qmzeopp215emy/hMm0W6kMamcVgGls0CldCKB4E5h/cjj6+oapmHKxVJK9up9+Ac
        SuU8H9hw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56328)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mxv8U-0008Bg-7v; Thu, 16 Dec 2021 18:05:46 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mxv8O-0005bI-Cm; Thu, 16 Dec 2021 18:05:40 +0000
Date:   Thu, 16 Dec 2021 18:05:40 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>, Andrew Lunn <andrew@lunn.ch>,
        linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Marcin Wojtas <mw@semihalf.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        linux-arm-kernel@lists.infradead.org,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH] net: phylink: Pass state to pcs_config
Message-ID: <Ybt/9Kc+XJYYecQF@shell.armlinux.org.uk>
References: <20211214233450.1488736-1-sean.anderson@seco.com>
 <YbkshnqgXP7Gd188@shell.armlinux.org.uk>
 <de1f7214-58c8-cdc6-1d29-08c979ce68f1@seco.com>
 <Ybk7iuxdin69MjTo@shell.armlinux.org.uk>
 <YblA4E/InIAa0U1U@shell.armlinux.org.uk>
 <1a9de385-1eb9-510b-25f5-d970adfb124b@seco.com>
 <Ybt2syzCpjVDGQy7@shell.armlinux.org.uk>
 <9ce793d7-8361-be07-e6b9-1ecc4e3ff8e5@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9ce793d7-8361-be07-e6b9-1ecc4e3ff8e5@seco.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 16, 2021 at 12:51:33PM -0500, Sean Anderson wrote:
> On 12/16/21 12:26 PM, Russell King (Oracle) wrote:
> > On Thu, Dec 16, 2021 at 12:02:55PM -0500, Sean Anderson wrote:
> > > On 12/14/21 8:12 PM, Russell King (Oracle) wrote:
> > > > On Wed, Dec 15, 2021 at 12:49:14AM +0000, Russell King (Oracle) wrote:
> > > > > On Tue, Dec 14, 2021 at 07:16:53PM -0500, Sean Anderson wrote:
> > > > > > Ok, so let me clarify my understanding. Perhaps this can be eliminated
> > > > > > through a different approach.
> > > > > >
> > > > > > When I read the datasheet for mvneta (which hopefully has the same
> > > > > > logic here, since I could not find a datasheet for an mvpp2 device), I
> > > > > > noticed that the Pause_Adv bit said
> > > > > >
> > > > > > > It is valid only if flow control mode is defined by Auto-Negotiation
> > > > > > > (as defined by the <AnFcEn> bit).
> > > > > >
> > > > > > Which I interpreted to mean that if AnFcEn was clear, then no flow
> > > > > > control was advertised. But perhaps it instead means that the logic is
> > > > > > something like
> > > > > >
> > > > > > if (AnFcEn)
> > > > > > 	Config_Reg.PAUSE = Pause_Adv;
> > > > > > else
> > > > > > 	Config_Reg.PAUSE = SetFcEn;
> > > > > >
> > > > > > which would mean that we can just clear AnFcEn in link_up if the
> > > > > > autonegotiated pause settings are different from the configured pause
> > > > > > settings.
> > > > >
> > > > > Having actually played with this hardware quite a bit and observed what
> > > > > it sends, what it implements for advertising is:
> > > > >
> > > > > 	Config_Reg.PAUSE = Pause_Adv;
> > > 
> > > So the above note from the datasheet about Pause_Adv not being valid is
> > > incorrect?
> > > 
> > > > > Config_Reg gets sent over the 1000BASE-X link to the link partner, and
> > > > > we receive Remote_Reg from the link partner.
> > > > >
> > > > > Then, the hardware implements:
> > > > >
> > > > > 	if (AnFcEn)
> > > > > 		MAC_PAUSE = Config_Reg.PAUSE & Remote_Reg.PAUSE;
> > > > > 	else
> > > > > 		MAC_PAUSE = SetFcEn;
> > > > >
> > > > > In otherwords, AnFcEn controls whether the result of autonegotiation
> > > > > or the value of SetFcEn controls whether the MAC enables symmetric
> > > > > pause mode.
> > > >
> > > > I should also note that in the Port Status register,
> > > >
> > > > 	TxFcEn = RxFcEn = MAC_PAUSE;
> > > >
> > > > So, the status register bits follow SetFcEn when AnFcEn is disabled.
> > > >
> > > > However, these bits are the only way to report the result of the
> > > > negotiation, which is why we use them to report back whether flow
> > > > control was enabled in mvneta_pcs_get_state(). These bits will be
> > > > ignored by phylink when ethtool -A has disabled pause negotiation,
> > > > and in that situation there is no way as I said to be able to read
> > > > the negotiation result.
> > > 
> > > Ok, how about
> > > 
> > > diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > > index b1cce4425296..9b41d8ee71fb 100644
> > > --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > > +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > > @@ -6226,8 +6226,7 @@ static int mvpp2_gmac_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
> > >                          * automatically or the bits in MVPP22_GMAC_CTRL_4_REG
> > >                          * manually controls the GMAC pause modes.
> > >                          */
> > > -                       if (permit_pause_to_mac)
> > > -                               val |= MVPP2_GMAC_FLOW_CTRL_AUTONEG;
> > > +                       val |= MVPP2_GMAC_FLOW_CTRL_AUTONEG;
> > > 
> > >                         /* Configure advertisement bits */
> > >                         mask |= MVPP2_GMAC_FC_ADV_EN | MVPP2_GMAC_FC_ADV_ASM_EN;
> > > @@ -6525,6 +6524,9 @@ static void mvpp2_mac_link_up(struct phylink_config *config,
> > >                 }
> > >         } else {
> > >                 if (!phylink_autoneg_inband(mode)) {
> > > +                       bool cur_tx_pause, cur_rx_pause;
> > > +                       u32 status0 = readl(port->base + MVPP2_GMAC_STATUS0);
> > > +
> > >                         val = MVPP2_GMAC_FORCE_LINK_PASS;
> > > 
> > >                         if (speed == SPEED_1000 || speed == SPEED_2500)
> > > @@ -6535,11 +6537,18 @@ static void mvpp2_mac_link_up(struct phylink_config *config,
> > >                         if (duplex == DUPLEX_FULL)
> > >                                 val |= MVPP2_GMAC_CONFIG_FULL_DUPLEX;
> > > 
> > > +                       cur_tx_pause = status0 & MVPP2_GMAC_STATUS0_TX_PAUSE;
> > > +                       cur_rx_pause = status0 & MVPP2_GMAC_STATUS0_RX_PAUSE;
> > 
> > I think you haven't understood everything I've said. These status bits
> > report what the MAC is doing. They do not reflect what was negotiated
> > _unless_ MVPP2_GMAC_FLOW_CTRL_AUTONEG was set.
> > 
> > So, if we clear MVPP2_GMAC_FLOW_CTRL_AUTONEG, these bits will follow
> > MVPP22_XLG_CTRL0_TX_FLOW_CTRL_EN and MVPP22_XLG_CTRL0_RX_FLOW_CTRL_EN.
> > 
> > Let's say we apply this patch. tx/rx pause are negotiated and enabled.
> > So cur_tx_pause and cur_rx_pause are both true.
> > 
> > We change the pause settings, forcing tx pause only. This causes
> > pcs_config to be called which sets MVPP2_GMAC_FLOW_CTRL_AUTONEG, and
> > then link_up gets called with the differing settings. We clear
> > MVPP2_GMAC_FLOW_CTRL_AUTONEG and force the pause settings. We now
> > have the status register containing MVPP2_GMAC_STATUS0_TX_PAUSE set
> > but MVPP2_GMAC_STATUS0_RX_PAUSE clear.
> > 
> > The link goes down e.g. because the remote end has changed and comes
> > back. We read the status register and see MVPP2_GMAC_STATUS0_TX_PAUSE
> > is set and MVPP2_GMAC_STATUS0_RX_PAUSE is still clear. tx_pause is
> > true and rx_pause is false. These agree with the settings, so we
> > then set MVPP2_GMAC_FLOW_CTRL_AUTONEG.
> > 
> > If the link goes down and up again, then this cycle repeats - the
> > status register will now have both MVPP2_GMAC_STATUS0_TX_PAUSE and
> > MVPP2_GMAC_STATUS0_RX_PAUSE set, so we clear
> > MVPP2_GMAC_FLOW_CTRL_AUTONEG. If the link goes down/up again, we flip
> > back to re-enabling MVPP2_GMAC_FLOW_CTRL_AUTONEG.
> 
> The toggling is not really a problem, since we always correct the pause
> mode as soon as we notice.

When do we "notice" ? We don't regularly poll on these platforms, we
rely on interrupts.

> The real issue would be if we don't notice
> because the link went down and back up in between calls to
> phylink_resolve.

Err no. If the link goes down and back up, one of the things the code
is structured to ensure is that phylink_resolve gets called, _and_ that
we will see a link-down-link-up.

The only time that isn't guaranteed is when using a polled driver where
the link state does not latched-fail (or where the hardware does
latch-fail but someone has decided "let's double-read the status
register to get the current state".)

> That could be fixed by verifying that the result of
> pcs_get_state matches what was configured.

So we need to introduce mvneta and mvpp2 specific code into phylink to
do that, because for everything else, what we get from pcs_get_state
is the _resolved_ information.

> But perhaps the solution is to move this parameter to mac_link_up. That
> would eliminate this toggling. And this parameter really is about the
> MAC in the first case.

Maybe, but we still have this parameter.

> > I don't like having it either, but I've thought about it for a long
> > time and haven't found any other acceptable solution.
> > 
> > To me, the parameter name describes _exactly_ what it's about. It's
> > about the PCS being permitted to forward the pause status to the MAC.
> > Hence "permit" "pause" "to" "mac" and the PCS context comes from the
> > fact that this is a PCS function. I really don't see what could be
> > clearer about the name... and I get the impression this is a bit of
> > a storm in a tea cup.
> 
> Well first off, the PCS typically has no ability to delegate/permit
> anything to the MAC. So it is already unclear what the verb is.

In the classical model of ethernet that is completely true - there is
no coupling that communicates the link parameters between the PCS and
MAC. mvpp2 and mvneta annoyingly do not implement the classical model
though.

> Next,
> since this is pcs_config, one would think this has something to do with
> pause advertisement. But in fact it has nothing to do with it. In fact,
> this parameter only has an effect once mac_link_up comes around. I
> suggest something like use_autonegotiated_pause. This makes it clear
> that this is about the result of autonegotation.

I could be devils advocate here and claim that
"use_autonegotiated_pause" is meaningless to a MAC because in the
classical model, the MAC doesn't have any way to know what the
negotiated pause was. So where does this "pause" come from.

So it's just the same problem, doesn't solve anything, and we just have
a different opinion on naming and where something should be.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
