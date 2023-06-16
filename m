Return-Path: <netdev+bounces-11484-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B627733525
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 17:47:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6DB172817D6
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 15:47:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C307518C0C;
	Fri, 16 Jun 2023 15:47:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1D84C8D6
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 15:47:22 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6B7135A3
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 08:47:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=P8wpRXvRzVivt4iN/qRZSCNk0Ox5z6dWmFf6qbaj4IU=; b=jBCUpxpCKTlShuqiiU8S/29Irf
	xJI70mnXiHkzbdU4vzkZWDWq3n5tiKAFAQZZ9wPtq8XjDQJLktZQW6xKmQZjewksbujgfEng0lhJ7
	SrEyDpP4AN8SzomTdbvwGp1gZuovK1cbH1OiWesWMQWVCVxICf3Cyg/KcjVl8qpvK4l8QqALBCJYD
	bmtK+fZgmuwqO/bplXnR3ButPE04ByOnFKSQnQx9VwVjIrB2sWkSqrsNMaw8n/mI0S2TvrrBu0krF
	5BeMRY21fy08AlMw0VoTk+Ahsv+f0lJb+wEZpl/81wXBX8cmOx1Z8HBEY55ZY+QjDqg6GSlalWiPr
	69pVLjpg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57630)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1qABew-0005Q6-OV; Fri, 16 Jun 2023 16:46:46 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1qABep-0002e1-In; Fri, 16 Jun 2023 16:46:39 +0100
Date: Fri, 16 Jun 2023 16:46:39 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Vladimir Oltean <olteanv@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Alexander Couzens <lynxis@fe80.eu>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Cc@web.codeaurora.org:Claudiu Beznea <claudiu.beznea@microchip.com>,
	Daniel Golle <daniel@makrotopia.org>,
	Daniel Machon <daniel.machon@microchip.com>,
	"David S. Miller" <davem@davemloft.net>,
	DENG Qingfang <dqfext@gmail.com>, Eric Dumazet <edumazet@google.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Jose Abreu <Jose.Abreu@synopsys.com>,
	Landen Chao <Landen.Chao@mediatek.com>,
	Lars Povlsen <lars.povlsen@microchip.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org,
	Madalin Bucur <madalin.bucur@nxp.com>,
	Marcin Wojtas <mw@semihalf.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Michal Simek <michal.simek@amd.com>, netdev@vger.kernel.org,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
	Sean Anderson <sean.anderson@seco.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Steen Hegelund <Steen.Hegelund@microchip.com>,
	Taras Chornyi <taras.chornyi@plvision.eu>,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next 0/15] Add and use helper for PCS negotiation
 modes
Message-ID: <ZIyD31CaVxjSDtz3@shell.armlinux.org.uk>
References: <ZIxQIBfO9dH5xFlg@shell.armlinux.org.uk>
 <20230616150055.kb7dyuwqqvfkfuh7@skbuf>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230616150055.kb7dyuwqqvfkfuh7@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 16, 2023 at 06:00:55PM +0300, Vladimir Oltean wrote:
> On Fri, Jun 16, 2023 at 01:05:52PM +0100, Russell King (Oracle) wrote:
> > Hi,
> > 
> > Earlier this month, I proposed a helper for deciding whether a PCS
> > should use inband negotiation modes or not. There was some discussion
> > around this topic, and I believe there was no disagreement about
> > providing the helper.
> > 
> > The initial discussion can be found at:
> > 
> > https://lore.kernel.org/r/ZGIkGmyL8yL1q1zp@shell.armlinux.org.uk
> > 
> > Subsequently, I posted a RFC series back in May:
> > 
> > https://lore.kernel.org/r/ZGzhvePzPjJ0v2En@shell.armlinux.org.uk
> > 
> > that added a helper, phylink_pcs_neg_mode() which PCS drivers could use
> > to parse the state, and updated a bunch of drivers to use it. I got
> > a couple of bits of feedback to it, including some ACKs.
> > 
> > However, I've decided to take this slightly further and change the
> > "mode" parameter to both the pcs_config() and pcs_link_up() methods
> > when a PCS driver opts in to this (by setting "neg_mode" in the
> > phylink_pcs structure.) If this is not set, we default to the old
> > behaviour. That said, this series converts all the PCS implementations
> > I can find currently in net-next.
> > 
> > Doing this has the added benefit that the negotiation mode parameter
> > is also available to the pcs_link_up() function, which can now know
> > whether inband negotiation was in fact enabled or not at pcs_config()
> > time.
> > 
> > It has been posted as RFC at:
> > 
> > https://lore.kernel.org/r/ZIh/CLQ3z89g0Ua0@shell.armlinux.org.uk
> > 
> > and received one reply, thanks Elad, which is a similar amount of
> > interest to previous postings. Let's post it as non-RFC and see
> > whether we get more reaction.
> 
> Sorry, I was in the process of reviewing the RFC, but I'm not sure I
> know what to ask to make sure that I understand the motivation :-/
> Here's a question that might or might not result in a code change.
> 
> In the single-patch RFC at:
> https://lore.kernel.org/all/ZGIkGmyL8yL1q1zp@shell.armlinux.org.uk/
> you bring sparx5 and lan966x as a motivation for introducing
> PHYLINK_PCS_NEG_OUTBAND as separate from PHYLINK_PCS_NEG_INBAND_DISABLED,
> with both meaning that in-band autoneg isn't used, but in the former
> case it's not enabled at all, while in the latter it's disabled through
> ethtool (if I get that right?).

Correct.

conf.inband is set true if phylink_autoneg_inband(mode) is true, which
equates to MLO_AN_INBAND.

conf.autoneg is set true if the ethtool Autoneg flag in the advertising
mask is set.

That goes through some incomprehensible logic in
sparx5_port_pcs_low_set() which I'm not going to even try to unpick
because it looks buggy to me, except that conf.autoneg is only looked
at if conf.inband were true at some point in the past.

So, what I care about here is keeping the behaviour pretty much the
same, especially as far as conf.inband.

With the new neg_mode:

conf.inband is set when we have one of the NEG_INBAND states. These are
set when in 1000BASE-X, 2500BASE-X or one of the SGMII family and
phylink_autoneg_inband(mode) is true. So, 100% identical when one
considers that the driver only supports SGMII, QSGMII, 1000BASE-X and
2500BASE-X for this path.

conf.autoneg will only be set when we have NEG_INBAND_ENABLED state,
and that is only set when in SGMII mode (irrespective of Autoneg) or
in *BASE-X, we're in in-band mode (so conf.inband is set) and the
advertising mask has the Autoneg bit set. As this is only looked at
if conf.inband was set the _last_ time around (which seems like a
bug in the driver...) and we're in 1000BASE-X mode, this is identical
logic where it matters.

So, conf.inband is 100% identical logic, and conf.autoneg is very
similar and for how it's actually used, completely identical.

> ... trying to find
> exactly what the PCS1G_MODE_CFG.SGMII_MODE_ENA field does (which is
> controlled in sparx5 and lan966x based on the presence or absence of the
> managed = "in-band-status" property).
> 
> Do you know for sure what this bit does and whether it makes sense for
> drivers to even distinguish between OUTBAND and INBAND_DISABLED in the
> way that this series is proposing?

I have no idea, and I didn't bother investigating - I don't want to go
around trying to disect drivers to figure out whether they're buggy or
not.

However, what I would say is that this is not where these modes came
from. They came from me asking myself the question "what would be the
logical set of information to give a PCS driver about the negotiation
state of the link?" and that's what I came up with _without_ reference
to this driver. The states are all documented in the first patch and
what they mean.

So, no, the Microchip driver code is not the reason why these
definitions were chosen. They were chosen because it's the logical
set that gives PCS drivers what they need to know.

Start from inband + autoneg. Then inband + !autoneg. Then inband
possible but not being used. Then "there's no inband possible for this
mode". That's the four states.

I think having this level of detail is important if we want to think
about those pesky inband-AN bypass modes, which make sense for only
really the PHYLINK_PCS_NEG_INBAND_DISABLED state and not OUTBAND nor
NONE state. Bypass mode doesn't make sense for e.g. SGMII because
one needs to know the speed for the link to come up, and if you're
getting that through an out-of-band mechanism, you're into forcing
the configuration at the PCS end.

Makes sense?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

