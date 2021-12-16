Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF4F6477A85
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 18:26:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239919AbhLPR0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 12:26:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235503AbhLPR02 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 12:26:28 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A418C061574;
        Thu, 16 Dec 2021 09:26:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=AXHqZb7F90jYAXnOm9qgJgfgpP4oixmnye3L1wnbXrg=; b=heIdCK/yhXA9ZjcCML/f0ddaNN
        k22r4mR3rJWF/D22yod5o8NukZmlt1IKgceVzMUI8oxcTaqP+iH0jdxYhLOwRorBos52lAdKijTFC
        dqMeVT55Px9C/e5O6SQacAD6XUEKH6x/DaTOQELdoqrgb8s2kPza3XuCy7Efg7MPgDwoCwjlVkwJh
        92C3PSA7b6ZaD68heyKc0NViyJIJzDDARHaK2IRLF7QAZS43NOxjN0vq3oj0S4s4p034+Dqs0XZfp
        +5w0pBbqw4/sN70EItJjxYCbHLaL5E/seosvsCvZ0hSyCkf6pSHM1qXZgNkuob/NQjUOwhLXqKbhJ
        UfGX6dYw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56326)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mxuWL-00088d-Q1; Thu, 16 Dec 2021 17:26:21 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mxuWB-0005aD-Pt; Thu, 16 Dec 2021 17:26:11 +0000
Date:   Thu, 16 Dec 2021 17:26:11 +0000
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
Message-ID: <Ybt2syzCpjVDGQy7@shell.armlinux.org.uk>
References: <20211214233450.1488736-1-sean.anderson@seco.com>
 <YbkshnqgXP7Gd188@shell.armlinux.org.uk>
 <de1f7214-58c8-cdc6-1d29-08c979ce68f1@seco.com>
 <Ybk7iuxdin69MjTo@shell.armlinux.org.uk>
 <YblA4E/InIAa0U1U@shell.armlinux.org.uk>
 <1a9de385-1eb9-510b-25f5-d970adfb124b@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1a9de385-1eb9-510b-25f5-d970adfb124b@seco.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 16, 2021 at 12:02:55PM -0500, Sean Anderson wrote:
> On 12/14/21 8:12 PM, Russell King (Oracle) wrote:
> > On Wed, Dec 15, 2021 at 12:49:14AM +0000, Russell King (Oracle) wrote:
> > > On Tue, Dec 14, 2021 at 07:16:53PM -0500, Sean Anderson wrote:
> > > > Ok, so let me clarify my understanding. Perhaps this can be eliminated
> > > > through a different approach.
> > > >
> > > > When I read the datasheet for mvneta (which hopefully has the same
> > > > logic here, since I could not find a datasheet for an mvpp2 device), I
> > > > noticed that the Pause_Adv bit said
> > > >
> > > > > It is valid only if flow control mode is defined by Auto-Negotiation
> > > > > (as defined by the <AnFcEn> bit).
> > > >
> > > > Which I interpreted to mean that if AnFcEn was clear, then no flow
> > > > control was advertised. But perhaps it instead means that the logic is
> > > > something like
> > > >
> > > > if (AnFcEn)
> > > > 	Config_Reg.PAUSE = Pause_Adv;
> > > > else
> > > > 	Config_Reg.PAUSE = SetFcEn;
> > > >
> > > > which would mean that we can just clear AnFcEn in link_up if the
> > > > autonegotiated pause settings are different from the configured pause
> > > > settings.
> > > 
> > > Having actually played with this hardware quite a bit and observed what
> > > it sends, what it implements for advertising is:
> > > 
> > > 	Config_Reg.PAUSE = Pause_Adv;
> 
> So the above note from the datasheet about Pause_Adv not being valid is
> incorrect?
> 
> > > Config_Reg gets sent over the 1000BASE-X link to the link partner, and
> > > we receive Remote_Reg from the link partner.
> > > 
> > > Then, the hardware implements:
> > > 
> > > 	if (AnFcEn)
> > > 		MAC_PAUSE = Config_Reg.PAUSE & Remote_Reg.PAUSE;
> > > 	else
> > > 		MAC_PAUSE = SetFcEn;
> > > 
> > > In otherwords, AnFcEn controls whether the result of autonegotiation
> > > or the value of SetFcEn controls whether the MAC enables symmetric
> > > pause mode.
> > 
> > I should also note that in the Port Status register,
> > 
> > 	TxFcEn = RxFcEn = MAC_PAUSE;
> > 
> > So, the status register bits follow SetFcEn when AnFcEn is disabled.
> > 
> > However, these bits are the only way to report the result of the
> > negotiation, which is why we use them to report back whether flow
> > control was enabled in mvneta_pcs_get_state(). These bits will be
> > ignored by phylink when ethtool -A has disabled pause negotiation,
> > and in that situation there is no way as I said to be able to read
> > the negotiation result.
> 
> Ok, how about
> 
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> index b1cce4425296..9b41d8ee71fb 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> @@ -6226,8 +6226,7 @@ static int mvpp2_gmac_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
>                          * automatically or the bits in MVPP22_GMAC_CTRL_4_REG
>                          * manually controls the GMAC pause modes.
>                          */
> -                       if (permit_pause_to_mac)
> -                               val |= MVPP2_GMAC_FLOW_CTRL_AUTONEG;
> +                       val |= MVPP2_GMAC_FLOW_CTRL_AUTONEG;
> 
>                         /* Configure advertisement bits */
>                         mask |= MVPP2_GMAC_FC_ADV_EN | MVPP2_GMAC_FC_ADV_ASM_EN;
> @@ -6525,6 +6524,9 @@ static void mvpp2_mac_link_up(struct phylink_config *config,
>                 }
>         } else {
>                 if (!phylink_autoneg_inband(mode)) {
> +                       bool cur_tx_pause, cur_rx_pause;
> +                       u32 status0 = readl(port->base + MVPP2_GMAC_STATUS0);
> +
>                         val = MVPP2_GMAC_FORCE_LINK_PASS;
> 
>                         if (speed == SPEED_1000 || speed == SPEED_2500)
> @@ -6535,11 +6537,18 @@ static void mvpp2_mac_link_up(struct phylink_config *config,
>                         if (duplex == DUPLEX_FULL)
>                                 val |= MVPP2_GMAC_CONFIG_FULL_DUPLEX;
> 
> +                       cur_tx_pause = status0 & MVPP2_GMAC_STATUS0_TX_PAUSE;
> +                       cur_rx_pause = status0 & MVPP2_GMAC_STATUS0_RX_PAUSE;

I think you haven't understood everything I've said. These status bits
report what the MAC is doing. They do not reflect what was negotiated
_unless_ MVPP2_GMAC_FLOW_CTRL_AUTONEG was set.

So, if we clear MVPP2_GMAC_FLOW_CTRL_AUTONEG, these bits will follow
MVPP22_XLG_CTRL0_TX_FLOW_CTRL_EN and MVPP22_XLG_CTRL0_RX_FLOW_CTRL_EN.

Let's say we apply this patch. tx/rx pause are negotiated and enabled.
So cur_tx_pause and cur_rx_pause are both true.

We change the pause settings, forcing tx pause only. This causes
pcs_config to be called which sets MVPP2_GMAC_FLOW_CTRL_AUTONEG, and
then link_up gets called with the differing settings. We clear
MVPP2_GMAC_FLOW_CTRL_AUTONEG and force the pause settings. We now
have the status register containing MVPP2_GMAC_STATUS0_TX_PAUSE set
but MVPP2_GMAC_STATUS0_RX_PAUSE clear.

The link goes down e.g. because the remote end has changed and comes
back. We read the status register and see MVPP2_GMAC_STATUS0_TX_PAUSE
is set and MVPP2_GMAC_STATUS0_RX_PAUSE is still clear. tx_pause is
true and rx_pause is false. These agree with the settings, so we
then set MVPP2_GMAC_FLOW_CTRL_AUTONEG.

If the link goes down and up again, then this cycle repeats - the
status register will now have both MVPP2_GMAC_STATUS0_TX_PAUSE and
MVPP2_GMAC_STATUS0_RX_PAUSE set, so we clear
MVPP2_GMAC_FLOW_CTRL_AUTONEG. If the link goes down/up again, we flip
back to re-enabling MVPP2_GMAC_FLOW_CTRL_AUTONEG.

And we will toggle between these two states.

Sorry, but this can't work.

> When we have MLO_PAUSE_AN, this is the same as before. For the other
> case, consider the scenario where someone disables pause
> autonegotiation, and then plugs in the cable. Here, we get the
> negotiated pause from pcs_get_state, but it is overridden by

In mvneta and mvpp2, pcs_get_state() can only read the current settings
that the PCS/MAC are currently using. There is no way to read purely
the results of negotiation with this hardware.

E.g., if you force speed to 100Mbps, then pcs_get_state() will tell you
that you're doing 100Mbps. If you force duplex, pcs_get_state() will
tell you what's being forced. If you force pause, pcs_get_state() will
tell you what pause settings are being forced.

Sadly, this is the way Marvell designed this hardware, and it sucks,
but we have to support it.

> > permit_pause_to_mac exists precisely because of the limitions of this
> > hardware, and having it costs virtually nothing to other network
> > drivers... except a parameter that others ignore.
> > 
> > If we don't have permit_pause_to_mac in pcs_config() then we need to
> > have it passed to the link_up() methods instead. There is no other
> > option (other than breaking mvneta and mvpp2) here than to make the
> > state of ethtool -A ... autoneg on|off known to the hardware.
> 
> Well, the original patch is primarily motivated by the terrible naming
> and documentation regarding this parameter. I was only able to determine
> the purpose of this parameter by reading the mvpp2 driver and consulting
> the A370 datasheet. I think if it is possible to eliminate this
> parameter (such as with the above patch), we should do so, since it will
> make the API cleaner and easier to understand. Failing that, I will
> submit a patch to improve the documentation (and perhaps rename the
> parameter to something more descriptive).

I don't like having it either, but I've thought about it for a long
time and haven't found any other acceptable solution.

To me, the parameter name describes _exactly_ what it's about. It's
about the PCS being permitted to forward the pause status to the MAC.
Hence "permit" "pause" "to" "mac" and the PCS context comes from the
fact that this is a PCS function. I really don't see what could be
clearer about the name... and I get the impression this is a bit of
a storm in a tea cup.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
