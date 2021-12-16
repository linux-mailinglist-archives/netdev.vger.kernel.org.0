Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A54CA477C0F
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 19:59:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240564AbhLPS7O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 13:59:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236361AbhLPS7N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 13:59:13 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3451EC061574;
        Thu, 16 Dec 2021 10:59:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=WPmxwWlkwmN+u/NjsnWlhvl5lxWrAkaoiPaHG4sO7WM=; b=GZ5cfJko9tge0WHmNyLM1sltIS
        d044rNirY/HaLacAyvIhv1RwQA54Ix2KMjCQDsQ2CfGlq8vc+4wjyXkwRAhf36/tozq/tPUmRaoOI
        Mq6+E3C9cLezvkJ1/HNb6LpZum3x5fxLgSbF+TphNJMwVUGIzBbgQf4RQZFTRu4ZqRbTHkhvRUbt/
        6vRVsU2X4f61j+tbAIYBArZdM+w22xzCzc6KbzgE1ZNEybyUPU7C/weHzwq96bjr+dR1yCbxqf3mR
        f8yaoPPb27EJRwDyD89Vtm6dSXi5ZKXvUmgvVhZ0dRuFx2iTTTqz7qCR9zTOw+PCOF9neEIFYeOgq
        BrjBEUvA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56334)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mxvy7-0008FK-SM; Thu, 16 Dec 2021 18:59:07 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mxvxw-0005dt-CO; Thu, 16 Dec 2021 18:58:56 +0000
Date:   Thu, 16 Dec 2021 18:58:56 +0000
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
Message-ID: <YbuMcPOeVM9Cu9hN@shell.armlinux.org.uk>
References: <20211214233450.1488736-1-sean.anderson@seco.com>
 <YbkshnqgXP7Gd188@shell.armlinux.org.uk>
 <de1f7214-58c8-cdc6-1d29-08c979ce68f1@seco.com>
 <Ybk7iuxdin69MjTo@shell.armlinux.org.uk>
 <YblA4E/InIAa0U1U@shell.armlinux.org.uk>
 <1a9de385-1eb9-510b-25f5-d970adfb124b@seco.com>
 <Ybt2syzCpjVDGQy7@shell.armlinux.org.uk>
 <9ce793d7-8361-be07-e6b9-1ecc4e3ff8e5@seco.com>
 <Ybt/9Kc+XJYYecQF@shell.armlinux.org.uk>
 <26875713-a024-b848-24fb-bbd772446f49@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26875713-a024-b848-24fb-bbd772446f49@seco.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 16, 2021 at 01:29:20PM -0500, Sean Anderson wrote:
> On 12/16/21 1:05 PM, Russell King (Oracle) wrote:
> > On Thu, Dec 16, 2021 at 12:51:33PM -0500, Sean Anderson wrote:
> > > On 12/16/21 12:26 PM, Russell King (Oracle) wrote:
> > > > On Thu, Dec 16, 2021 at 12:02:55PM -0500, Sean Anderson wrote:
> > > > > On 12/14/21 8:12 PM, Russell King (Oracle) wrote:
> > > > > > On Wed, Dec 15, 2021 at 12:49:14AM +0000, Russell King (Oracle) wrote:
> > > > > > > On Tue, Dec 14, 2021 at 07:16:53PM -0500, Sean Anderson wrote:
> > > > > > > > Ok, so let me clarify my understanding. Perhaps this can be eliminated
> > > > > > > > through a different approach.
> > > > > > > >
> > > > > > > > When I read the datasheet for mvneta (which hopefully has the same
> > > > > > > > logic here, since I could not find a datasheet for an mvpp2 device), I
> > > > > > > > noticed that the Pause_Adv bit said
> > > > > > > >
> > > > > > > > > It is valid only if flow control mode is defined by Auto-Negotiation
> > > > > > > > > (as defined by the <AnFcEn> bit).
> > > > > > > >
> > > > > > > > Which I interpreted to mean that if AnFcEn was clear, then no flow
> > > > > > > > control was advertised. But perhaps it instead means that the logic is
> > > > > > > > something like
> > > > > > > >
> > > > > > > > if (AnFcEn)
> > > > > > > > 	Config_Reg.PAUSE = Pause_Adv;
> > > > > > > > else
> > > > > > > > 	Config_Reg.PAUSE = SetFcEn;
> > > > > > > >
> > > > > > > > which would mean that we can just clear AnFcEn in link_up if the
> > > > > > > > autonegotiated pause settings are different from the configured pause
> > > > > > > > settings.
> > > > > > >
> > > > > > > Having actually played with this hardware quite a bit and observed what
> > > > > > > it sends, what it implements for advertising is:
> > > > > > >
> > > > > > > 	Config_Reg.PAUSE = Pause_Adv;
> > > > >
> > > > > So the above note from the datasheet about Pause_Adv not being valid is
> > > > > incorrect?
> > > > >
> > > > > > > Config_Reg gets sent over the 1000BASE-X link to the link partner, and
> > > > > > > we receive Remote_Reg from the link partner.
> > > > > > >
> > > > > > > Then, the hardware implements:
> > > > > > >
> > > > > > > 	if (AnFcEn)
> > > > > > > 		MAC_PAUSE = Config_Reg.PAUSE & Remote_Reg.PAUSE;
> > > > > > > 	else
> > > > > > > 		MAC_PAUSE = SetFcEn;
> > > > > > >
> > > > > > > In otherwords, AnFcEn controls whether the result of autonegotiation
> > > > > > > or the value of SetFcEn controls whether the MAC enables symmetric
> > > > > > > pause mode.
> > > > > >
> > > > > > I should also note that in the Port Status register,
> > > > > >
> > > > > > 	TxFcEn = RxFcEn = MAC_PAUSE;
> > > > > >
> > > > > > So, the status register bits follow SetFcEn when AnFcEn is disabled.
> > > > > >
> > > > > > However, these bits are the only way to report the result of the
> > > > > > negotiation, which is why we use them to report back whether flow
> > > > > > control was enabled in mvneta_pcs_get_state(). These bits will be
> > > > > > ignored by phylink when ethtool -A has disabled pause negotiation,
> > > > > > and in that situation there is no way as I said to be able to read
> > > > > > the negotiation result.
> > > > >
> > > > > Ok, how about
> > > > >
> > > > > diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > > > > index b1cce4425296..9b41d8ee71fb 100644
> > > > > --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > > > > +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > > > > @@ -6226,8 +6226,7 @@ static int mvpp2_gmac_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
> > > > >                          * automatically or the bits in MVPP22_GMAC_CTRL_4_REG
> > > > >                          * manually controls the GMAC pause modes.
> > > > >                          */
> > > > > -                       if (permit_pause_to_mac)
> > > > > -                               val |= MVPP2_GMAC_FLOW_CTRL_AUTONEG;
> > > > > +                       val |= MVPP2_GMAC_FLOW_CTRL_AUTONEG;
> > > > >
> > > > >                         /* Configure advertisement bits */
> > > > >                         mask |= MVPP2_GMAC_FC_ADV_EN | MVPP2_GMAC_FC_ADV_ASM_EN;
> > > > > @@ -6525,6 +6524,9 @@ static void mvpp2_mac_link_up(struct phylink_config *config,
> > > > >                 }
> > > > >         } else {
> > > > >                 if (!phylink_autoneg_inband(mode)) {
> > > > > +                       bool cur_tx_pause, cur_rx_pause;
> > > > > +                       u32 status0 = readl(port->base + MVPP2_GMAC_STATUS0);
> > > > > +
> > > > >                         val = MVPP2_GMAC_FORCE_LINK_PASS;
> > > > >
> > > > >                         if (speed == SPEED_1000 || speed == SPEED_2500)
> > > > > @@ -6535,11 +6537,18 @@ static void mvpp2_mac_link_up(struct phylink_config *config,
> > > > >                         if (duplex == DUPLEX_FULL)
> > > > >                                 val |= MVPP2_GMAC_CONFIG_FULL_DUPLEX;
> > > > >
> > > > > +                       cur_tx_pause = status0 & MVPP2_GMAC_STATUS0_TX_PAUSE;
> > > > > +                       cur_rx_pause = status0 & MVPP2_GMAC_STATUS0_RX_PAUSE;
> > > >
> > > > I think you haven't understood everything I've said. These status bits
> > > > report what the MAC is doing. They do not reflect what was negotiated
> > > > _unless_ MVPP2_GMAC_FLOW_CTRL_AUTONEG was set.
> > > >
> > > > So, if we clear MVPP2_GMAC_FLOW_CTRL_AUTONEG, these bits will follow
> > > > MVPP22_XLG_CTRL0_TX_FLOW_CTRL_EN and MVPP22_XLG_CTRL0_RX_FLOW_CTRL_EN.
> > > >
> > > > Let's say we apply this patch. tx/rx pause are negotiated and enabled.
> > > > So cur_tx_pause and cur_rx_pause are both true.
> > > >
> > > > We change the pause settings, forcing tx pause only. This causes
> > > > pcs_config to be called which sets MVPP2_GMAC_FLOW_CTRL_AUTONEG, and
> > > > then link_up gets called with the differing settings. We clear
> > > > MVPP2_GMAC_FLOW_CTRL_AUTONEG and force the pause settings. We now
> > > > have the status register containing MVPP2_GMAC_STATUS0_TX_PAUSE set
> > > > but MVPP2_GMAC_STATUS0_RX_PAUSE clear.
> > > >
> > > > The link goes down e.g. because the remote end has changed and comes
> > > > back. We read the status register and see MVPP2_GMAC_STATUS0_TX_PAUSE
> > > > is set and MVPP2_GMAC_STATUS0_RX_PAUSE is still clear. tx_pause is
> > > > true and rx_pause is false. These agree with the settings, so we
> > > > then set MVPP2_GMAC_FLOW_CTRL_AUTONEG.
> > > >
> > > > If the link goes down and up again, then this cycle repeats - the
> > > > status register will now have both MVPP2_GMAC_STATUS0_TX_PAUSE and
> > > > MVPP2_GMAC_STATUS0_RX_PAUSE set, so we clear
> > > > MVPP2_GMAC_FLOW_CTRL_AUTONEG. If the link goes down/up again, we flip
> > > > back to re-enabling MVPP2_GMAC_FLOW_CTRL_AUTONEG.
> > > 
> > > The toggling is not really a problem, since we always correct the pause
> > > mode as soon as we notice.
> > 
> > When do we "notice" ? We don't regularly poll on these platforms, we
> > rely on interrupts.
> 
> When the link comes back up again.

So we end up with link-down-link-up and the settings are wrong.
The next time the link goes down and up, the settings are corrected
as I described. The next time the link goes down and up, the settings
are again wrong. etc. I don't consider this acceptable.

> > > The real issue would be if we don't notice
> > > because the link went down and back up in between calls to
> > > phylink_resolve.
> > 
> > Err no. If the link goes down and back up, one of the things the code
> > is structured to ensure is that phylink_resolve gets called, _and_ that
> > we will see a link-down-link-up.
> 
> Great. Then the above will work fine. Because we always set the pause
> mode in mac_link_up, it's OK to have the pause be incorrect in the time
> between when it comes up and when mac_link_up is called. The result of
> the pause from get_state will not be what was negotiated, but that is OK
> because we discard it anyway.

I can't tell whether you are intentionally misinterpreting to try and
get your way or not, but I've now said several times that your proposal
will _not_ work, yet you keep with some weird idea that I'm somehow
agreeing with you.

I'm not.

> I think my primary issue with the name is that it is named after its
> purpose in the marvell hardware, and not after the user setting. That
> is, we have something like
> 
> 	if (pause_autonegotiation_enabled())
> 		permit_pause_to_mac()
> 
> So the generic interface should be named after the condition and not
> the body.
> 
> If this parameter got moved to mac_link_up, I think the following would
> be good:
> 
> @autonegotiated_pause: This indicates whether the pause settings are a
> result of autonegotiation or whether they were manually configured. Some
> MACs are tightly coupled to their PCSs and have a hardware
> implementation of linkmode_resolve_pause() which sets their pause mode
> based on the autonegotiated pause mode. For these MACs, disabling this
> hardware implementation may inhibit their ability to determine the
> autonegotiated pause mode, so it should only be disabled when the pause
> mode was manually set. MACs which do not have this feature/limitation
> should ignore this parameter.

I might agree with that, but I haven't read it because I'm feeling way
too frazzled this evening to do so (not your fault, just an afternoon
of pressure.)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
