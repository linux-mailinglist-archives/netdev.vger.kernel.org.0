Return-Path: <netdev+bounces-694-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AD9A26F9109
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 11:57:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C8CA81C219DE
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 09:57:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E72876FBD;
	Sat,  6 May 2023 09:57:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D413A7C
	for <netdev@vger.kernel.org>; Sat,  6 May 2023 09:57:13 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69E1946A8
	for <netdev@vger.kernel.org>; Sat,  6 May 2023 02:57:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=vah3fnNYZggNVt3BUQRcldBPjDEltAWikSHiwKDk86w=; b=wZk8KiMO5Rm/H9UZSq6ICoSind
	uysTzjpCqMpoCU0pP7hWqXYfaUQP6fkq4BUi4JZTZp1O0eUr21MqmlOujcTu4ZEpsRgu5p29qRfyt
	Zj0sdsN4P2InEfrMFsrXFPMLgnVmzXpIyjW5kB+C3ADLIvGcgJqxjqOrUHTDQPdVR+fb+ziIx5wMd
	A19Ora2zODwhT2+uleJ2hXbViZGvoI0MgtmsKOEj8xjijDpTEshv4iOc83ciyc+v7p0FZVDKritjn
	kYuAsfM84+esgtir/w8L2dCAjVIE24blKTot+HW1hVsTl09kWnTm5HSkdG7kd8/K0WNA6PesEkEUa
	uX72F8VQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33704)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1pvEf5-0007fF-KM; Sat, 06 May 2023 10:57:07 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1pvEf4-0004wH-D0; Sat, 06 May 2023 10:57:06 +0100
Date: Sat, 6 May 2023 10:57:06 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Lorenz Brun <lorenz@brun.one>, netdev@vger.kernel.org
Subject: Re: Quirks for exotic SFP module
Message-ID: <ZFYj8oMU+g+x7BxU@shell.armlinux.org.uk>
References: <C157UR.RELZCR5M9XI83@brun.one>
 <7ed07d2e-ef0e-4e27-9ac6-96d60ae0e630@lunn.ch>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7ed07d2e-ef0e-4e27-9ac6-96d60ae0e630@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 05, 2023 at 08:53:43PM +0200, Andrew Lunn wrote:
> On Fri, May 05, 2023 at 07:39:12PM +0200, Lorenz Brun wrote:
> > Hi netdev members,
> 
> For SFP matters, please Cc: SFP maintainer, and the PHY
> maintainers. See the MAINTAINERS file.

... and it doesn't help that $author is using a *.one vanity domain
(all the new TLDs that were announced a number of years back quickly
became brand new sources of nothing but spam, so I blocked them when
the first spams came through on the assumption that no one would be
silly enough to originate email from any of them.)

> > I have some SFP modules which contain a G.fast modem (Metanoia MT5321). In
> > my case I have ones without built-in flash, which means that they come up in
> > bootloader mode. Their EEPROM is emulated by the onboard CPU/DSP and is
> > pretty much completely incorrect, the claimed checksum is 0x00. Luckily
> > there seems to be valid vendor and part number information to quirk off of.
> 
> It is amazing how many SFP manufactures cannot get the simple things
> like CRC right. 
> 
> > I've implemented a detection mechanism analogous to the Cotsworks one, which
> > catches my modules. Since the bootloader is in ROM, we sadly cannot
> > overwrite the bad data, so I just made it skip the CRC check if this is an
> > affected device and the expected CRC is zero.
> 
> Sounds sensible. Probably pointless, because SFP manufactures don't
> seem to care about quality, but please do print an warning that the
> bad checksum is being ignored.
> 
> > There is also the issue of the module advertising 1000BASE-T:
> 
> Probably something for Russell, but what should be advertised?
> 1000Base-X? 
> 
> > But the module internally has an AR8033 1000BASE-X to RGMII converter which
> > is then connected to the modem SoC, so as far as I am aware this is
> > incorrect and could cause Linux to do things like autonegotiation which
> > definitely does not work here.
> 
> Is there anything useful to be gained by talking to the PHY? Since it
> appears to be just a media converter, i guess the PHY having link is
> not useful. Does the LOS GPIO tell you about the G.Fast modem status?

AR803x PHYs don't support I2C directly unlike the MV88E1111, and tend
not to be accessible. Only though additional hardware to convert I2C to
MDIO would it be accessible.

If it's programmed to use 1000base-X on the host side, then that's what
it will be using.

I'm not sure what the original author is talking about when referring to
autonegotiation - autonegotiation for _which_ part of the link?

There's 1000base-X autonegotiation, and then there's RGMII in-band
signalling that is sometimes called (imho incorrectly) autonegotiation.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

