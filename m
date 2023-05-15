Return-Path: <netdev+bounces-2670-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D4EA702EF3
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 15:59:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4A019280FFC
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 13:59:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49766D2E9;
	Mon, 15 May 2023 13:59:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E5573FC7
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 13:59:23 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83E3C1FD7
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 06:58:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=iYPq5fR3Cy+OCwvVu7qitsrrs6GcWO5NbmwTHJ8YR2Q=; b=DseE9QezuaB+gFlQFDgkh4dgtL
	xJ/ww2T/22Lol2k4IZxaLQoSU2ijCPXZMlvSEFrGXMaJnn5qKTEIJboz+bURxAIV9i1YAgXwAS4rB
	7muyyhfd/vYLFth04sB9XuXUBaUs4D7mVllAEDb5F2IqjOVlEN8nQBFgp00IRfL2q030=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1pyYiH-00CtiM-71; Mon, 15 May 2023 15:58:09 +0200
Date: Mon, 15 May 2023 15:58:09 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
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
Message-ID: <9f7b1d6f-ca62-4c6c-9cd5-37726e7857b7@lunn.ch>
References: <ZGIkGmyL8yL1q1zp@shell.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZGIkGmyL8yL1q1zp@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> 2. XLGMII.. Looking at the XPCS driver, it's unclear whether Clause 73
>    AN gets used for this. A quick scan of IEEE 802.3 suggests that
>    XLGMII doesn't have any support for any inband signalling, and it's
>    just an intermediary protocol between the MAC (more specifically the
>    RS, but for the purposes of this I'll just refer to MAC) and the
>    attached PCS, and any autonegotiation happens after the XLGMII link.

So isn't XLGMII then a generic PHY thing, not a phylink thing?

Or am i not correctly understanding how
drivers/phy/marvell/phy-*-comphy.c and
drivers/phy/microchip/*_serdev.c fit into the overall picture?

	Andrew

