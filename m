Return-Path: <netdev+bounces-11486-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 54CAC73352C
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 17:52:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6FBA72817C7
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 15:52:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E53591952F;
	Fri, 16 Jun 2023 15:52:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8C5C3D62
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 15:52:49 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FCF4297E
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 08:52:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=ogQmQ6wprTqZ/EyoXKfpzFfumwVkMG2afh0FIz5W3+E=; b=LFFyYZAJpurrFSKtW+ua6s3ute
	SoE9NmFfbWPphYthzFLbdF7CsTFMLbhfMcF3yqse2vNPBE/8rXj7/Hmb7q4R9Ikp3B4bw8hUXgJLS
	W0GWQYWurPZCgn0A1RUcut0BC3B6qZKxnog8paNmKKKUfYSF9y7d3TKY2CtvoXp0vIPWJfSJXPdOr
	V45TSyEd5Rw2082UXtQmEEF2k7Y459piCXEO95mMOv6XVwSHgpx/Dlkw8nhctoJiMfUjVUmVGa51B
	ZEWaNcq36zWiS2f6jDU2eXRoiRc+dRrLJ4DuU8fIZjAqrsdwqM9WZ5Tt8rDNgFeHTgmI4xh9syWBG
	hFRZ539w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:48718)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1qABkQ-0005R2-Je; Fri, 16 Jun 2023 16:52:26 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1qABkL-0002e8-Ul; Fri, 16 Jun 2023 16:52:21 +0100
Date: Fri, 16 Jun 2023 16:52:21 +0100
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
Message-ID: <ZIyFNSnwahdL0A8s@shell.armlinux.org.uk>
References: <ZIxQIBfO9dH5xFlg@shell.armlinux.org.uk>
 <20230616150055.kb7dyuwqqvfkfuh7@skbuf>
 <ZIyD31CaVxjSDtz3@shell.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZIyD31CaVxjSDtz3@shell.armlinux.org.uk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 16, 2023 at 04:46:39PM +0100, Russell King (Oracle) wrote:
> On Fri, Jun 16, 2023 at 06:00:55PM +0300, Vladimir Oltean wrote:
> > Do you know for sure what this bit does and whether it makes sense for
> > drivers to even distinguish between OUTBAND and INBAND_DISABLED in the
> > way that this series is proposing?
> 
> I have no idea, and I didn't bother investigating - I don't want to go
> around trying to disect drivers to figure out whether they're buggy or
> not.
> 
> However, what I would say is that this is not where these modes came
> from. They came from me asking myself the question "what would be the
> logical set of information to give a PCS driver about the negotiation
> state of the link?" and that's what I came up with _without_ reference
> to this driver. The states are all documented in the first patch and
> what they mean.
> 
> So, no, the Microchip driver code is not the reason why these
> definitions were chosen. They were chosen because it's the logical
> set that gives PCS drivers what they need to know.
> 
> Start from inband + autoneg. Then inband + !autoneg. Then inband
> possible but not being used. Then "there's no inband possible for this
> mode". That's the four states.
> 
> I think having this level of detail is important if we want to think
> about those pesky inband-AN bypass modes, which make sense for only
> really the PHYLINK_PCS_NEG_INBAND_DISABLED state and not OUTBAND nor
> NONE state. Bypass mode doesn't make sense for e.g. SGMII because
> one needs to know the speed for the link to come up, and if you're
> getting that through an out-of-band mechanism, you're into forcing
> the configuration at the PCS end.

I should also add... yes, I did _then_ subsequently use the microchip
driver as a justification for it. I probably should've explained it
without using that as justification.

I could also have used the sja1105 driver as well, since:

	MLO_AN_INBAND => PHYLINK_PCS_NEG_INBAND_ENABLED
	MLO_AN_FIXED || MLO_AN_PHY => PHYLINK_PCS_NEG_OUTBAND

are the conversions done there, which fits with:

-               if (!phylink_autoneg_inband(mode)) {
+               if (neg_mode == PHYLINK_PCS_NEG_OUTBAND) {

since the opposite of !inband is outband.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

