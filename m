Return-Path: <netdev+bounces-695-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A53286F910F
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 12:01:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 62BC9281181
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 10:01:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63AD26FB6;
	Sat,  6 May 2023 10:01:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5674B7C
	for <netdev@vger.kernel.org>; Sat,  6 May 2023 10:01:04 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E20635FE5
	for <netdev@vger.kernel.org>; Sat,  6 May 2023 03:01:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=61Djg6zq4vE+r694YQ6kJf3gkxPAwW6dQt5qa3q7Lx8=; b=1uzS/D8hLLwgBFCGJD7SZbizON
	bEmvG9tekC5jB6UkQ7lXLdHzN2bqVljAKhTvG/VeW5zEt//TA0XSrlehuRiECO2NuXAngFFjZ92bW
	HhS2P0JPXYJ09MeoQmmuVGco4FTGdB0IP3z4qCmQsTRoiVNMiDR78SfIOr30rml0iwJNBd8UYW+SU
	gYuBFT6yra0eBpi4q0biRI8sKC8xiGvZPREEyaU2E14wvQp74l/sqkyfc1B7rftIzkHG5aKCt91RV
	MsDdgsD6LsoiKhi9qoUh0uwqsVbLuMqs1cQHRrub71+2GwEuDSFHkhkA87pUHnuArXqc7KQoRTm3w
	v57akDfQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56828)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1pvEir-0007fX-4e; Sat, 06 May 2023 11:01:01 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1pvEiq-0004wr-I2; Sat, 06 May 2023 11:01:00 +0100
Date: Sat, 6 May 2023 11:01:00 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Lorenz Brun <lorenz@brun.one>, netdev@vger.kernel.org
Subject: Re: Quirks for exotic SFP module
Message-ID: <ZFYlXFrLl/RdvkFu@shell.armlinux.org.uk>
References: <C157UR.RELZCR5M9XI83@brun.one>
 <7ed07d2e-ef0e-4e27-9ac6-96d60ae0e630@lunn.ch>
 <CQF7UR.5191D6UPT6U8@brun.one>
 <d75c2138-76c6-49fe-96c3-39401f18b831@lunn.ch>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d75c2138-76c6-49fe-96c3-39401f18b831@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat, May 06, 2023 at 02:03:32AM +0200, Andrew Lunn wrote:
> > > 
> > > >  But the module internally has an AR8033 1000BASE-X to RGMII
> > > > converter which
> > > >  is then connected to the modem SoC, so as far as I am aware this is
> > > >  incorrect and could cause Linux to do things like autonegotiation
> > > > which
> > > >  definitely does not work here.
> > > 
> > > Is there anything useful to be gained by talking to the PHY? Since it
> > > appears to be just a media converter, i guess the PHY having link is
> > > not useful. Does the LOS GPIO tell you about the G.Fast modem status?
> 
> > AFAIK you cannot talk to the PHY as there isn't really an Ethernet PHY.
> 
> So i2c-detect does not find anything other than at address 0x50?
> 
> Often the PHY can be access via an MDIO bus over I2C at some other
> address on the bus. The linux SFP code might be trying, even
> succeeding, in instantiating such a bus and finding the PHY. And then
> a PHY driver will be loaded to drive the PHY. This is how Copper SFP
> modules work. However, most Copper SFP use a Marvell PHY, not
> Atheros. And RollBall SFP use a different MDIO over i2c protocol.

Given that the PHY is in 1000base-X to RGMII mode, this is not a usual
setup, and its probably something the PHYLIB driver won't expect. So
we probably don't want to be talking to the PHY, and we probably just
want to talk 1000base-X to the module.

> > I actually haven't checked the LOS GPIO. This thing runs ~1MiB of firmware
> > and two different proprietary management protocols which I've
> > reverse-engineered over which you can get tons of data about the current
> > modem and link status. You need those to boot the SoC anyways. The TX
> > disable GPIO puts the modem SoC into reset state and is used in case you use
> > a host-based watchdog for the module.
> 
> So i guess you are not passing the GPIO for TX disable in your DT
> blob. And maybe not LOS. If you do, it must be doing something
> sensible, because phylink does not allow the carrier to go up if LOS
> is active. Although the EEPROM can indicate LOS is not
> implemented. But that assumes the EEPROM contents are sane.
> 
> Russell King will be interested in a binary dump from ethtool -m.

Definitely.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

