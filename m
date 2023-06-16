Return-Path: <netdev+bounces-11413-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FAC97330BF
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 14:06:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 44A5C1C20F81
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 12:06:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4035A17729;
	Fri, 16 Jun 2023 12:06:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3427EFC03
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 12:06:26 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 175192D6B
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 05:06:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
	Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=GMakLNiznKhV47he34/qz/SKwm9V58eoSqKR8UevaM8=; b=fBNTVcarHdyhUWq6cPt01Fcbju
	IQ2s+A1M+JPVmJF+7Py+GApspGaRY2lRvScjY1OLfzy34CwjC1gDuR2NQfvy7+DPfbcyfYi+lsJ3V
	w5y0hh5+m1nrqkCB9itSuBlgQbURgf7R3RiHN18+Grf+RBkuyN38pTbHjSvYdjum+Q+AsZ6CX/uLb
	QQnZgL42fXGiJLkOlW++w/jCswIThcacXD1W5i0IL+wwBzFZI9VzYqOQ91Qdkml+iYH8EUKD3ZXij
	KDhQ42lKtsP2JDB66dO6YC4/jXxHl06D6xKo+FxSZJKxv1h/zzOu3K7DROVM/zn8LRUf86TDCzEdC
	MfnHdt1w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:44980)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1qA8DI-00050y-Cr; Fri, 16 Jun 2023 13:06:00 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1qA8DA-0002Uq-VY; Fri, 16 Jun 2023 13:05:53 +0100
Date: Fri, 16 Jun 2023 13:05:52 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>
Cc: Alexander Couzens <lynxis@fe80.eu>,
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
	UNGLinuxDriver@microchip.com, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 0/15] Add and use helper for PCS negotiation modes
Message-ID: <ZIxQIBfO9dH5xFlg@shell.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi,

Earlier this month, I proposed a helper for deciding whether a PCS
should use inband negotiation modes or not. There was some discussion
around this topic, and I believe there was no disagreement about
providing the helper.

The initial discussion can be found at:

https://lore.kernel.org/r/ZGIkGmyL8yL1q1zp@shell.armlinux.org.uk

Subsequently, I posted a RFC series back in May:

https://lore.kernel.org/r/ZGzhvePzPjJ0v2En@shell.armlinux.org.uk

that added a helper, phylink_pcs_neg_mode() which PCS drivers could use
to parse the state, and updated a bunch of drivers to use it. I got
a couple of bits of feedback to it, including some ACKs.

However, I've decided to take this slightly further and change the
"mode" parameter to both the pcs_config() and pcs_link_up() methods
when a PCS driver opts in to this (by setting "neg_mode" in the
phylink_pcs structure.) If this is not set, we default to the old
behaviour. That said, this series converts all the PCS implementations
I can find currently in net-next.

Doing this has the added benefit that the negotiation mode parameter
is also available to the pcs_link_up() function, which can now know
whether inband negotiation was in fact enabled or not at pcs_config()
time.

It has been posted as RFC at:

https://lore.kernel.org/r/ZIh/CLQ3z89g0Ua0@shell.armlinux.org.uk

and received one reply, thanks Elad, which is a similar amount of
interest to previous postings. Let's post it as non-RFC and see
whether we get more reaction.

 drivers/net/dsa/qca/qca8k-8xxx.c                   |  13 ++-
 drivers/net/dsa/sja1105/sja1105_main.c             |  14 ++-
 drivers/net/ethernet/freescale/fman/fman_dtsec.c   |   7 +-
 drivers/net/ethernet/marvell/mvneta.c              |   7 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |  14 +--
 .../net/ethernet/marvell/prestera/prestera_main.c  |  11 +--
 .../net/ethernet/microchip/lan966x/lan966x_main.c  |   1 +
 .../ethernet/microchip/lan966x/lan966x_phylink.c   |   7 +-
 .../net/ethernet/microchip/sparx5/sparx5_main.c    |   1 +
 .../net/ethernet/microchip/sparx5/sparx5_phylink.c |   8 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |   6 +-
 drivers/net/pcs/pcs-lynx.c                         |  48 +++++----
 drivers/net/pcs/pcs-mtk-lynxi.c                    |  39 +++-----
 drivers/net/pcs/pcs-xpcs.c                         |  43 ++++----
 drivers/net/phy/phylink.c                          |  59 +++++++----
 include/linux/pcs/pcs-xpcs.h                       |   4 +-
 include/linux/phylink.h                            | 109 +++++++++++++++++++--
 17 files changed, 253 insertions(+), 138 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

