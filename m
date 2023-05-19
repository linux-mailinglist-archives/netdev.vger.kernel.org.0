Return-Path: <netdev+bounces-3948-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CEDC709BF5
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 18:04:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1216D281CAF
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 16:04:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C47E1119D;
	Fri, 19 May 2023 16:04:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 025BB10960
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 16:04:12 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2D4CFE
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 09:04:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=Iq4ynVINjRXSNqespR934YxuET9pTqrwSpYN94yTh3w=; b=XSlvV1xEw0a+RJpuc4PfXk8for
	hkLzEwLKir3+EMRgOC5H2BoVx09UyUWsvAC1QUpmA5xDTTX6w+Gb6mpZ7wLjrGQ65Q8xB2rUa121q
	SSpo56koVMAJj+O78UGfk0BExnITqmTA74iJbG66yMzOcmTaMMlyiDyuywqlS3iJdfWxo4nxqQjAR
	i8V0w6IDeWf767zI0do3tnkDLBph6neottEQOwROXKAQZi3zBDKqAGfet9SVIsmUm61vD8l7TvGJa
	cVz9JRDCYwWYwsOLaLZyXP0C+jVc6YFQwBUhXWQJM2YDh4KcWjl6raa78nGIaAuIQdE89P4EHp0vz
	f+t9KewQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:52444)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q02aL-000397-HP; Fri, 19 May 2023 17:04:05 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q02aJ-0004kE-Iw; Fri, 19 May 2023 17:04:03 +0100
Date: Fri, 19 May 2023 17:04:03 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Heiner Kallweit <hkallweit1@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: phy: add helpers for comparing phy IDs
Message-ID: <ZGed83w9IlHnTgsC@shell.armlinux.org.uk>
References: <E1pzzm3-006BZJ-Bi@rmk-PC.armlinux.org.uk>
 <808c6158-5e30-402b-b686-462ca17e2a2c@lunn.ch>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <808c6158-5e30-402b-b686-462ca17e2a2c@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 19, 2023 at 05:59:02PM +0200, Andrew Lunn wrote:
> On Fri, May 19, 2023 at 02:03:59PM +0100, Russell King wrote:
> > There are several places which open code comparing PHY IDs. Provide a
> > couple of helpers to assist with this, using a slightly simpler test
> > than the original:
> > 
> > - phy_id_compare() compares two arbitary PHY IDs and a mask of the
> >   significant bits in the ID.
> > - phydev_id_compare() compares the bound phydev with the specified
> >   PHY ID, using the bound driver's mask.
> 
> Hi Russell
> 
> I think these are useful, but i'm wondering about naming. In the PHY
> drivers we use these macros:
> 
> #define PHY_ID_MATCH_EXACT(id) .phy_id = (id), .phy_id_mask = GENMASK(31, 0)
> #define PHY_ID_MATCH_MODEL(id) .phy_id = (id), .phy_id_mask = GENMASK(31, 4)
> #define PHY_ID_MATCH_VENDOR(id) .phy_id = (id), .phy_id_mask = GENMASK(31, 10)
> 
> when creating the tables. 
> 
> > diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
> > index 3f81bb8dac44..2094d49025a7 100644
> > --- a/drivers/net/phy/micrel.c
> > +++ b/drivers/net/phy/micrel.c
> > @@ -637,7 +637,7 @@ static int ksz8051_ksz8795_match_phy_device(struct phy_device *phydev,
> >  {
> >  	int ret;
> >  
> > -	if ((phydev->phy_id & MICREL_PHY_ID_MASK) != PHY_ID_KSZ8051)
> > +	if (!phy_id_compare(phydev->phy_id, PHY_ID_KSZ8051, MICREL_PHY_ID_MASK))
> >  		return 0;
> 
> This could be phy_id_compare_model() 

Note that this can't access phydev->drv, because this is a match method
and in all likelyhood, phydev->drv is NULL here.

> phy_id_compare_exact() could be used in a number of places, eg.
> 
> vitesse.c:			(phydev->drv->phy_id == PHY_ID_VSC8234 ||
> vitesse.c:			 phydev->drv->phy_id == PHY_ID_VSC8244 ||
> vitesse.c:			 phydev->drv->phy_id == PHY_ID_VSC8572 ||
> vitesse.c:			 phydev->drv->phy_id == PHY_ID_VSC8601) ?
> motorcomm.c:	} else if (phydev->drv->phy_id == PHY_ID_YT8531S) {
> marvell10g.c:	if (phydev->drv->phy_id != MARVELL_PHY_ID_88X3310)

However, these are not comparing the PHY ID, they're comparing the
driver's idea of the PHY ID. I would expect phy_id_compare_exact()
to be comparing phydev->phy_id!

Many places can use phydev->drv->phy_id == foo to identify which
driver was matched. If the driver's phy_id is set my a macro
definition, then that same macro identifier can be used with a
straight compare like the above, and I think open coding those
like that is entirely reasonable and proper.

However, phydev->phy_id is much more complex because it generally
needs the revision masking away, which is what these helpers are
achieving.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

