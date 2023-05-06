Return-Path: <netdev+bounces-707-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 462476F9257
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 15:55:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 718AC1C21B05
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 13:55:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E76058830;
	Sat,  6 May 2023 13:55:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D92581FB4
	for <netdev@vger.kernel.org>; Sat,  6 May 2023 13:55:01 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F29FF23A0C
	for <netdev@vger.kernel.org>; Sat,  6 May 2023 06:54:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=GbC36vZd1pEiTJfF5aEU7GWPCVDMkG9KrRAqJsasChs=; b=EPcxYvdwTw98fdGbb9zHapqQiG
	Wq1UfdyK2zm+kawQzt0Fldjjfk+f1QA0xXmL0Fvhwox69LMfAYzSMVIQ2i698NLaIYzmOntZan6dD
	vieI09wd5lDzSMaK1h9p8WQGMtKAffORNMxRTDBRr/4uQCIePKDXyenhJ9HymwY1FITV0ye8iWcS0
	H1QCKTIOtYUwmlVdCg01hLUVzKC7QuZ4SFzJHmGCQtpVxDsb3r/NbSTP6x2DFqv4rdXHbHbjS7Fah
	dvV8ujgQS2AHJkFcmoJQvahpcY/EXVwd3vEI7LGN0J/R2N72cIFWDvoQJCvBVGhfw+NuUJ6NUMA0B
	NamlFWmQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:46262)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1pvINE-0007qz-4J; Sat, 06 May 2023 14:54:56 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1pvIND-00056J-BQ; Sat, 06 May 2023 14:54:55 +0100
Date: Sat, 6 May 2023 14:54:55 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Lorenz Brun <lorenz@brun.one>, netdev@vger.kernel.org
Subject: Re: Quirks for exotic SFP module
Message-ID: <ZFZcL8LKkX3+GKMT@shell.armlinux.org.uk>
References: <C157UR.RELZCR5M9XI83@brun.one>
 <7ed07d2e-ef0e-4e27-9ac6-96d60ae0e630@lunn.ch>
 <CQF7UR.5191D6UPT6U8@brun.one>
 <d75c2138-76c6-49fe-96c3-39401f18b831@lunn.ch>
 <DVN7UR.QEVJPHB8FG6I1@brun.one>
 <8adbd20c-6de0-49ab-aabe-faf845d9a5d9@lunn.ch>
 <75Q7UR.PII4PI72J55K3@brun.one>
 <561dff8e-8a12-4f99-86e2-b5cdc8632d4a@lunn.ch>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <561dff8e-8a12-4f99-86e2-b5cdc8632d4a@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat, May 06, 2023 at 03:35:42PM +0200, Andrew Lunn wrote:
> > Oh, so you're talking about signalling on the AR8033 <-> Linux Host part of
> > the link. I actually wasn't aware that 1000Base-X did in-band signalling,
> > TIL. Since the I2C bus is connected to the modem SoC it would have to
> > forward any MDIO to the AR8033 transceiver, right? This would also be a bit
> > weird as the AR8033 is connected "backwards", i.e. with RGMII facing towards
> > the Modem SoC and 1000Base-X towards the Linux host.

(To Lorenz)

It's not backwards at all. For a fibre link, 1000baseX is carried over
the fibre, and it looks like this:

Host MAC <==> Host PCS <==1000baseX==> Remote PCS <==> Remote MAC

The host has no access to the remote PCS.

In your case:

Host MAC <==> Host PCS <==1000baseX==> AR8033 <==RGMII==> SoC

How is this any different? I would say the AR8033 is up to the SoC to
manage itself. The fact that the SoC does something with the packets
to them stuff them out to the rest of the world is neither here nor
there. In the 1000base-X over fibre example above, the SoC could be
something designed for routing applications inside a network switch/
router.

Please don't get hung up on "there is a PHY on the module, I want
access to it!" As you're not talking twisted-pair ethernet, you
don't, there is nothing we need to control there.

The fact the module wants 1000base-X on its host interface is just
what it wants - and that it specifies that it offers 1000base-T
compliance is just the manufacturer being idiotic (as seems to be
the case with a lot of SFPs.)

Just add a quirk removing the 1000base-T capability, setting
1000base-X in the supported mask, and also clear the
PHY_INTERFACE_MODE_SGMII and set PHY_INTERFACE_MODE_1000BASEX in
the interfaces mask.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

