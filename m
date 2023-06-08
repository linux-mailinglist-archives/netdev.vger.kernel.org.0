Return-Path: <netdev+bounces-9308-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D5A7728661
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 19:30:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F3D071C21005
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 17:30:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0E681DCA4;
	Thu,  8 Jun 2023 17:30:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9625619930
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 17:30:50 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F1C39E;
	Thu,  8 Jun 2023 10:30:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=vhx0DrAoIURoUAWg1ewcKT6wKdBRWd/M6bB7nEvVkQ4=; b=nnMgt/Q8pqPmW6oH0ol5FDxWVE
	4+dKGLaAaU5jYQS8EukKGsBEIDgiPtKCqz21VrvEskHtRHuLtZaK/MmfAXWolrSXUTz3Mzkl4A4dJ
	QYakt1Sclc3bGVaXPTPh+brvZFpGePJzHRr3soWdAssAv+1r25L5HW7c23xBWcETTbooMiCc5V6U9
	e4bLIxU0LXDu39o72xKtlgCQ68sI3PR7QaigfeqMrFsCxfnVMqswPBuy6WsameRAz0fw/AoB/nzB6
	DPLosymMlKwiKCzl/QOBvPSSAcuatPc04oveZKL2w7pQm2sMwkuaPc38R7VKuBkMKYbi8eB4+GCWS
	7qsfSc4g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:46416)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q7JTA-0000k3-O7; Thu, 08 Jun 2023 18:30:44 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q7JT7-0000zs-Ge; Thu, 08 Jun 2023 18:30:41 +0100
Date: Thu, 8 Jun 2023 18:30:41 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com,
	Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	linux-arm-kernel@lists.infradead.org, Horatiu.Vultur@microchip.com,
	Allan.Nielsen@microchip.com, UNGLinuxDriver@microchip.com,
	Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net 2/2] net: phylink: use USXGMII control-word format to
 parse Q-USGMII word
Message-ID: <ZIIQQXhbnnpZHGw8@shell.armlinux.org.uk>
References: <20230608163415.511762-1-maxime.chevallier@bootlin.com>
 <20230608163415.511762-4-maxime.chevallier@bootlin.com>
 <ZIICtN5zrxvTuEwz@shell.armlinux.org.uk>
 <20230608195330.476fca86@pc-7.home>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230608195330.476fca86@pc-7.home>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 08, 2023 at 07:53:30PM +0200, Maxime Chevallier wrote:
> Hi Russell,
> 
> On Thu, 8 Jun 2023 17:32:52 +0100
> "Russell King (Oracle)" <linux@armlinux.org.uk> wrote:
> 
> > On Thu, Jun 08, 2023 at 06:34:15PM +0200, Maxime Chevallier wrote:
> > > diff --git a/include/uapi/linux/mdio.h b/include/uapi/linux/mdio.h
> > > index 256b463e47a6..1d20a9082507 100644
> > > --- a/include/uapi/linux/mdio.h
> > > +++ b/include/uapi/linux/mdio.h
> > > @@ -444,4 +444,7 @@ static inline __u16 mdio_phy_id_c45(int prtad, int devad)
> > >  #define MDIO_USXGMII_5000FULL		0x1a00	/* 5000Mbps full-duplex */
> > >  #define MDIO_USXGMII_LINK		0x8000	/* PHY link with copper-side partner */
> > >  
> > > +/* Usgmii control word is based on Usxgmii, masking away 2.5, 5 and 10Gbps */
> > > +#define MDIO_USGMII_SPD_MASK		0x0600  
> > 
> > This isn't correct:
> > 
> > 11:9	Speed: Bit 11, 10, 9:
> > 	1 1 1 to 011 = Reserved
> > 	0 1 0 = 1000 Mbps: 1000BASE-TX, 1000BASE-X
> > 	0 0 1 = 100 Mbps: 100BASE-TX, 100BASE-FX
> > 	0 0 0 = 10 Mbps: 10BASET, 10BASE2, 10BASE5
> > 
> > If we only look at bits 10 and 9, then we're interpreting the reserved
> > combinations as valid as well.
> 
> That's why I rewrote the decoding helper instead of simply masking away
> the extra bit, so that we exclude the 0 1 1 combination ( 10G speed ).

I don't think you've understood my comment properly. Here is what
the code is doing:

+#define MDIO_USGMII_SPD_MASK             0x0600
+       switch (lpa & MDIO_USGMII_SPD_MASK) {
#define MDIO_USXGMII_10                 0x0000  /* 10Mbps */
+       case MDIO_USXGMII_10:
+               state->speed = SPEED_10;
+               break;
#define MDIO_USXGMII_100                0x0200  /* 100Mbps */
+       case MDIO_USXGMII_100:
+               state->speed = SPEED_100;
+               break;
#define MDIO_USXGMII_1000               0x0400  /* 1000Mbps */
+       case MDIO_USXGMII_1000:
+               state->speed = SPEED_1000;
+               break;
+       default:
+               state->link = false;
+               return;
+       }

So, this will decode bits 11:9 as:

000	10Mbps
001	100Mbps
010	1000Mgps
011	link = false
100	10Mbps
101	100Mbps
110	1000Mbps
111	link = false

Whereas, USGMII says the last four are all reserved. Why does this
happen? Because the mask is defined as:

+#define MDIO_USGMII_SPD_MASK             0x0600

which only covers bits 10 and 9, masking off bit 11. However, bit 11
is _still_ part of the field, and if it's set, then it is a "reserved"
speed. We should not be just ignoring bit 11.

I hope that helps to clarify.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

