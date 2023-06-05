Return-Path: <netdev+bounces-7965-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 260B07223BF
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 12:45:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D4F202811C5
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 10:45:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23409111B5;
	Mon,  5 Jun 2023 10:45:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15D534431
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 10:45:16 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82AF0FA
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 03:45:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=j/ORUKfLFYNZMSfZmNpxZapN6ulrZ1+RHN+E+Me8a8k=; b=iJXCLsSYAj+n6o5g8nK5YmrUAY
	dre5z++g8ndEJFknXddosQ+B/EITiv7suteaecLFz7uF17z8QYtcLDNgUGX9sPthD1HtCSeyOiB0i
	GGm1YGfX0PLpDKTXyvLE8XKR57UFLAuL3TgFUCA3XLWWoXXTPxZP9yj6FuOCoA/teumPKElJlY5Gi
	xB3QA4xKV3yDMAgGJK6SNLqR2e8pd4z4354r1RlMxHbD1YT2pfvfWAS9m75sY9007gGo8duzIfAh1
	sEPBFiaCbvhsOkua/f6BZDTW0B98Qj1vYWLLKQBFcTObMqfDnvz5Y2mxyH3GBKMi+2bOzvYFZeJXv
	9hcpdf/g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:36702)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q67i5-0003pP-Lv; Mon, 05 Jun 2023 11:45:13 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q67i4-00062Q-SW; Mon, 05 Jun 2023 11:45:12 +0100
Date: Mon, 5 Jun 2023 11:45:12 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc: Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: Re: QUSGMII control word
Message-ID: <ZH28uKIZBetr79BB@shell.armlinux.org.uk>
References: <ZHnd+6FUO77XFJvQ@shell.armlinux.org.uk>
 <20230605081334.3258befa@pc-7.home>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230605081334.3258befa@pc-7.home>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 05, 2023 at 08:13:34AM +0200, Maxime Chevallier wrote:
> Hello Russell,
> 
> On Fri, 2 Jun 2023 13:18:03 +0100
> "Russell King (Oracle)" <linux@armlinux.org.uk> wrote:
> 
> > Hi Maxime,
> > 
> > Looking at your commit which introduced QUSGMII -
> > 5e61fe157a27 ("net: phy: Introduce QUSGMII PHY mode"), are you sure
> > your decoding of the control word is correct?
> > 
> > I've found some information online which suggests that QUSGMII uses a
> > slightly different format to the control word from SGMII. Most of the
> > bits are the same, but the speed bits occupy the three bits from 11:9,
> > and 10M, 100M and 1G are encoded using bits 10:9, whereas in SGMII
> > they are bits 11:10. In other words, in QUSGMII they are shifted one
> > bit down. In your commit, you used the SGMII decoder for QUSGMII,
> > which would mean we'd be picking out the wrong bits for decoding the
> > speed.
> > 
> > QUSGMII also introduces EEE information into bits 8 and 7 whereas
> > these are reserved in SGMII.
> > 
> > Please could you take a look, because I think we need a different
> > decoder for the QUSGMII speed bits.
> 
> I've taken a look at it, back when I sent that patch I didn't have
> access to the full documentation and used a vendor reference
> implementation as a basis... I managed to get my hands on the proper
> doc and the control word being used looks to be the usxgmii control
> word, which matches with the offset you are seeing.
> 
> Do you have a patch or should I send a followup ?

I don't have a patch.

> Out of curiosity, on which hardware did you find this ?

No, it's something I noticed when reviewing some documentation I have.

> I still have some patches of PCH extensions around, but didn't get any
> room in my schedule to move forward with it. Is it something that you
> plan on using ?

No plans, sorry! :D

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

