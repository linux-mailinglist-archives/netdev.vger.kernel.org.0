Return-Path: <netdev+bounces-2371-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F16570190F
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 20:13:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5C1C01C20B9C
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 18:13:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 313D879CC;
	Sat, 13 May 2023 18:13:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 253B27477
	for <netdev@vger.kernel.org>; Sat, 13 May 2023 18:13:16 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 386FB3C06
	for <netdev@vger.kernel.org>; Sat, 13 May 2023 11:13:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=g7BhOKunWwN0XCZv21klw8Db+n/IyqsFiJbDUYMhxio=; b=e1aqQTxTqW3/nuMiJvGyNP5Wu7
	iez1soGwfzuumIFkqBlbBZv8tvMxWi+KUniOYPwfohcq/szxFRZcmTDYqQHChBdTkJAyGxf2f9M7p
	Xp8j0Bo6yABupuB2vF92Co0AQamusmAAgxomItn7kN3q26ikUn/1VHobN08AmaA85NtMrzz75MDcD
	hyeXcWuo1sDq9z7ANL/OL2ePUdgFfosedZdwnHkq8d1GCIKnKzK7oYh4JbVN3CjiNj8OX/Mf8Pqpj
	alIKI9xVuxATsVo9YNtddGtVBDY6c1g7xoTk837tEWMVTOYQkN4Q6wRkFq0Q7g6SOQfgoIFeXsqxW
	8h7wCqYw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:38476)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1pxtjt-0001cw-FE; Sat, 13 May 2023 19:13:05 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1pxtjq-0006K5-Rv; Sat, 13 May 2023 19:13:02 +0100
Date: Sat, 13 May 2023 19:13:02 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Jose Abreu <Jose.Abreu@synopsys.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH RFC net-next 7/9] net: pcs: xpcs: correct pause resolution
Message-ID: <ZF/TLuDSHDZmwonu@shell.armlinux.org.uk>
References: <ZF52z7PqH2HLrWEU@shell.armlinux.org.uk>
 <E1pxWYJ-002QsU-IT@rmk-PC.armlinux.org.uk>
 <f1b8d851-1e01-4719-aa2e-4b628838a515@lunn.ch>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f1b8d851-1e01-4719-aa2e-4b628838a515@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat, May 13, 2023 at 07:47:35PM +0200, Andrew Lunn wrote:
> On Fri, May 12, 2023 at 06:27:35PM +0100, Russell King (Oracle) wrote:
> > xpcs was indicating symmetric pause should be enabled regardless of
> > the advertisements by either party. Fix this to use
> > linkmode_resolve_pause() now that we're no longer obliterating the
> > link partner's advertisement by logically anding it with our own.
> > 
> > Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> > ---
> >  drivers/net/pcs/pcs-xpcs.c | 11 ++++++++++-
> >  1 file changed, 10 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
> > index 43115d04c01a..beed799a69a7 100644
> > --- a/drivers/net/pcs/pcs-xpcs.c
> > +++ b/drivers/net/pcs/pcs-xpcs.c
> > @@ -538,11 +538,20 @@ static void xpcs_resolve_lpa_c73(struct dw_xpcs *xpcs,
> >  				 struct phylink_link_state *state)
> >  {
> >  	__ETHTOOL_DECLARE_LINK_MODE_MASK(res);
> > +	bool tx_pause, rx_pause;
> >  
> >  	/* Calculate the union of the advertising masks */
> >  	linkmode_and(res, state->lp_advertising, state->advertising);
> >  
> > -	state->pause = MLO_PAUSE_TX | MLO_PAUSE_RX;
> > +	/* Resolve pause modes */
> > +	linkmode_resolve_pause(state->advertising, state->lp_advertising,
> > +			       &tx_pause, &rx_pause);
> > +
> > +	if (tx_pause)
> > +		state->pause |= MLO_PAUSE_TX;
> > +	if (rx_pause)
> > +		state->pause |= MLO_PAUSE_RX;
> > +
> 
> Hi Russell
> 
> I must be missing something. Why not use phylink_resolve_an_pause()?

Check the next few patches... it eventually gets to using the c73
helper, entirely eliminating this function. This is a staged
conversion, so that its easier to bisect down to the change that
caused the breakage. Converting straight to the c73 helper would
be a big change - not only fixing the pause resolution mechanism
but also how we do the c73 priority resolution.

Moreover, the above patch can be backported to stable kernels
without too much effort if there's a desire to do so.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

