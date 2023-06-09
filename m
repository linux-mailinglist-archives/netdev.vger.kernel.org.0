Return-Path: <netdev+bounces-9567-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 12200729CEC
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 16:31:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C343B1C2114D
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 14:31:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5EB515AA;
	Fri,  9 Jun 2023 14:31:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA55B200A2
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 14:31:41 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 584C430D7
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 07:31:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=fcxku29q67g+QYhUcT0+DZp1s+ufnMtB4Mq468Q38UA=; b=FPIpZskt05kNz4FX/hx0Ny+5ia
	N4pTjcSefw2OTTZheVPrt5nt/o09zV/OD0+jHCbHEkTq0tuuWUZVX9KD/Pkd1/zIVitG8RO/lu098
	2gLH3be+4Me/hIPbCOFOR8U1x5ZL9fU2np49BC7FjwkBhHxOq3Gxr+VMkNuaVFBpIjyyuYpkHLzIQ
	emx5bx3+DtaE5fZG8lGTsgPeowxdgjoik2O8WaEydHkPnSGg7o8fplOCJlKqum57QglMKUF4qUjsU
	CrZtiHUC0BJXbosFAvswMZVA/1/VcaHfdn2KLoAjwKORtnPXa1Rzsue1+5n1nF60i/pU0tvsT1KcG
	3R5O6jKw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:54146)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q7d9H-00028f-WA; Fri, 09 Jun 2023 15:31:32 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q7d9E-0001v0-Uf; Fri, 09 Jun 2023 15:31:28 +0100
Date: Fri, 9 Jun 2023 15:31:28 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Simon Horman <simon.horman@corigine.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Marcin Wojtas <mw@semihalf.com>,
	netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH RFC net-next 3/4] net: mvneta: convert to phylink EEE
 implementation
Message-ID: <ZIM3wP3TjvigZP6r@shell.armlinux.org.uk>
References: <ZILsqV0gkSMMdinU@shell.armlinux.org.uk>
 <E1q7Y9W-00DI8m-Jo@rmk-PC.armlinux.org.uk>
 <ZIMw4XoCg/4biVN9@corigine.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZIMw4XoCg/4biVN9@corigine.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 09, 2023 at 04:02:09PM +0200, Simon Horman wrote:
> On Fri, Jun 09, 2023 at 10:11:26AM +0100, Russell King (Oracle) wrote:
> > Convert mvneta to use phylink's EEE implementation, which means we just
> > need to implement the two methods for LPI control, and adding the
> > initial configuration.
> > 
> > Disabling LPI requires clearing a single bit. Enabling LPI needs a full
> > configuration of several values, as the timer values are dependent on
> > the MAC operating speed.
> > 
> > Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> > ---
> >  drivers/net/ethernet/marvell/mvneta.c | 95 +++++++++++++++++----------
> >  1 file changed, 61 insertions(+), 34 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
> > index e2abc00d0472..c634ec5d3f9a 100644
> > --- a/drivers/net/ethernet/marvell/mvneta.c
> > +++ b/drivers/net/ethernet/marvell/mvneta.c
> > @@ -284,8 +284,10 @@
> >  					  MVNETA_TXQ_BUCKET_REFILL_PERIOD))
> >  
> >  #define MVNETA_LPI_CTRL_0                        0x2cc0
> > +#define      MVNETA_LPI_CTRL_0_TS                0xff << 8
> 
> Hi Russell,
> 
> maybe GENMASK would be useful here. If not, perhaps (0xffUL << 8)

Why "unsigned long" when the variable we use it with is u32, which is
defined as "unsigned int" ?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

