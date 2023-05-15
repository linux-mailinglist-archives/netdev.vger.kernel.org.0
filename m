Return-Path: <netdev+bounces-2684-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AA007031A4
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 17:35:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3F3F52810D3
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 15:35:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72F13DF4F;
	Mon, 15 May 2023 15:35:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62BFFD537
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 15:35:10 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A495A19BC
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 08:35:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=8a+oLK/EjvW2iWa4CvVnKNi6T68qPXF5eHPAeQXKSvQ=; b=HGU6JtmhWszCAfdURqlW/Ut+66
	84hfuyjtPVc0MwUYbNBETFcAfz5NM3sIeqSEbFmEmGNNvk3dFGzJLjogP8wMWREs0etAtaMdhmewm
	eVB3ZrcO8d3CLxmquVIK+CrS92ER5HYC6ww+g+uoqGRBYqiImluxiC4kzdz5jaQ4iDt1Di0fqZKBe
	ru8cAs/vtn2Mr9fpOiEsLtOvHpTZXDV2GgAXjra2y9NOMRR3vTgDvwzfD8V37n6i5xEat0O+glzPX
	JGSGf6Toh6R6H9RaiXqOH9/EsOCgWMoGpewU/wbqrdHB1aQE0K5gpPeazG68DSGxo3CXk9EPM9nhq
	Le3hPnQw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35164)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1pyaDg-0003ww-8S; Mon, 15 May 2023 16:34:40 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1pyaDZ-0008Ic-Pp; Mon, 15 May 2023 16:34:33 +0100
Date: Mon, 15 May 2023 16:34:33 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Andrew Lunn <andrew@lunn.ch>
Cc: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Daniel Machon <daniel.machon@microchip.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Felix Fietkau <nbd@nbd.name>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>, John Crispin <john@phrozen.org>,
	Jose Abreu <Jose.Abreu@synopsys.com>,
	Lars Povlsen <lars.povlsen@microchip.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Marcin Wojtas <mw@semihalf.com>,
	Mark Lee <Mark-MC.Lee@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Paolo Abeni <pabeni@redhat.com>, Sean Wang <sean.wang@mediatek.com>,
	Steen Hegelund <Steen.Hegelund@microchip.com>,
	Taras Chornyi <taras.chornyi@plvision.eu>,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	UNGLinuxDriver@microchip.com, Vladimir Oltean <olteanv@gmail.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org, netdev@vger.kernel.org
Subject: Re: [PATCH RFC] Providing a helper for PCS inband negotiation
Message-ID: <ZGJRCaR2gQqEt2+L@shell.armlinux.org.uk>
References: <ZGIkGmyL8yL1q1zp@shell.armlinux.org.uk>
 <9f7b1d6f-ca62-4c6c-9cd5-37726e7857b7@lunn.ch>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9f7b1d6f-ca62-4c6c-9cd5-37726e7857b7@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 15, 2023 at 03:58:09PM +0200, Andrew Lunn wrote:
> > 2. XLGMII.. Looking at the XPCS driver, it's unclear whether Clause 73
> >    AN gets used for this. A quick scan of IEEE 802.3 suggests that
> >    XLGMII doesn't have any support for any inband signalling, and it's
> >    just an intermediary protocol between the MAC (more specifically the
> >    RS, but for the purposes of this I'll just refer to MAC) and the
> >    attached PCS, and any autonegotiation happens after the XLGMII link.
> 
> So isn't XLGMII then a generic PHY thing, not a phylink thing?

Honestly, I'm really not sure. It feels more like an internal-SoC
thing. See my last diagram why I think this.

> Or am i not correctly understanding how
> drivers/phy/marvell/phy-*-comphy.c and
> drivers/phy/microchip/*_serdev.c fit into the overall picture?

In the case of serdes-based protocols with an external PHY, the general
structure we have is:

------------------------------+
  SoC                         |
+-----+   +-----+  +--------+ |          +--------------+
| MAC +---+ PCS +--+ SERDES +------------+ Ethernet PHY +---- Media
+-----+   +-----+  +--------+ |    ^     +--------------+
------------------------------+    |
                                   |
PHY_INTERFACE_MODE_xxx has referred to this bit, and this is the bit
where inband can occur.

In the case of multi-rate implementations, there can be one of many
different PCS that can be placed there, and the SERDES handles
converting the data stream from the PCS into its appropriate
electrical form, essentially covering the PMA and PMD functions.
(That same SERDES block generally can also handle PCIe and SATA.)

In the case of non-serdes based protocols, then it's essentially the
same as the above, but with the PCS and SERDES blocks removed.

For Fibre based connections:

------------------------------+
  SoC                         |
+-----+   +-----+  +--------+ |
| MAC +---+ PCS +--+ SERDES +------------ Media
+-----+   +-----+  +--------+ |    ^
------------------------------+    |
                                   |
PHY_INTERFACE_MODE_xxx has referred to this bit, and 1000BASE-X runs
negotiation on this. 10GBASE-R also used for fibre has no negotiation,
but there's still the 10GBASE-R PCS and the 802.3 PMA/PMD are subsumed
by the SERDES block.

What I think seems to be the case with XPCS is:

------------------------------+
  SoC                         |
+-----+   +-----+  +--------+ |
| MAC +---+ PCS +--+ SERDES +----------- Media
+-----+ ^ +-----+  +--------+ |
--------|---------------------+
        |
PHY_INTERFACE_MODE_xxx seems to be referring to this bit. When clause 73
negotiation is used, that happens where I've stated "media" above, and
that's involved with negotiating backplane protocols e.g. 40GBASE-KR4,
40GBASE-CR4, 25GBASE-KR, 10GBASE-KR, 1000BASE-KX etc on the bit I've
called "Media" above.

However, we can also have this for a fibre link:

------------------------------+
  SoC                         |
+-----+   +-----+  +--------+ |
| MAC +---+ PCS +--+ SERDES +----------- Fibre
+-----+ ^ +-----+  +--------+ |    ^
--------|---------------------+    |
        |                          |
     XLGMII                    40GBASE-R

Given that in this case, we'd want PHY_INTERFACE_MODE_xxx to say
40GBASE-R, using the existing PHY_INTERFACE_MODE_xxx to specify at
where I've pointed XLGMII just makes things confused... but in the
case above with clause 73 negotiation, we wouldn't have a standard
PHY_INTERFACE_MODE_xxx specifier for the external "media" side
because that's dependent on the result of the negotiation.

So... this seems to be a right can of wriggly things.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

