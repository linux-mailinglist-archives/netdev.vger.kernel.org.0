Return-Path: <netdev+bounces-10397-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D88972E550
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 16:11:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B0FA61C20C91
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 14:11:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FCA5370C2;
	Tue, 13 Jun 2023 14:11:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 937F1522B
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 14:11:07 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A407ED
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 07:11:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=3F7Z9TkGgjkk/613u0Ft4M42oUPBaHGk5Ku78X+Kbmk=; b=IRgSR3hwMJMaZICS0IjG2FVJc9
	S/aI2FZRhvjRYKdvArPd0yIpBuMb1eJ1Q8Vy6kBlIZ1+1+cpKj8tQTxLZbKuuDMDV7M65LvM7yJqV
	OskXWJy5xnjI7lB/aEKf05Ap8cdN0SQc5hxJrxoj/ZCYz2WVRywowC/wU0HxyEUE5iEFkN6Mtgf+d
	sSEOb0AXYhv2zFSuI7XV20ZMGLMQlf+DwSaKuzrIEWM0djTJffGBwm1dUeE8P3guDVUU7SiZiN+5L
	+2JA7moK8+2cxoggrV5HXPUjSRdvHcxH1B02Q1nR2cI4C9/ONh1Y32b4JHaD3Q78d7xEkKhaenAcF
	OojKe+yw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58030)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q94jb-0007O5-AV; Tue, 13 Jun 2023 15:10:59 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q94jY-00065X-Ku; Tue, 13 Jun 2023 15:10:56 +0100
Date: Tue, 13 Jun 2023 15:10:56 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Heiner Kallweit <hkallweit1@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Marcin Wojtas <mw@semihalf.com>,
	netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH RFC net-next 2/4] net: phylink: add EEE management
Message-ID: <ZIh48DMvIr+/isR3@shell.armlinux.org.uk>
References: <ZILsqV0gkSMMdinU@shell.armlinux.org.uk>
 <E1q7Y9R-00DI8g-GF@rmk-PC.armlinux.org.uk>
 <bca7e7ec-3997-4d97-9803-16bfaf05d1f5@lunn.ch>
 <ZIY+szvNDxFCn94b@shell.armlinux.org.uk>
 <50a42dc7-02df-4052-abeb-7d7b9cd7225e@lunn.ch>
 <ZIgzUZSKW0WsA0AC@shell.armlinux.org.uk>
 <e6a62d6c-7c1e-4084-b5e7-f5ffa2a2da02@lunn.ch>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e6a62d6c-7c1e-4084-b5e7-f5ffa2a2da02@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 13, 2023 at 02:26:22PM +0200, Andrew Lunn wrote:
> > I'm wondering if, rather than adding a bit to mac_capabilities, whether
> > instead:
> > 
> > 1) add eee_capabilities and re-use the existing MAC_CAP_* definitions
> >    to indicate what speeds the MAC supports LPI. This doesn't seem to
> >    solve (c).
> > 2) add a phy interface bitmap indicating which interface modes support
> >    LPI generation.
> > 
> > Phylib already has similar with its supported_eee link mode bitmap,
> > which presumably MACs can knock out link modes that they know they
> > wouldn't support.
> 
> O.K, I can probably make that work. None of the MAC drivers i've
> looked at need this flexibility yet, but we can add it now.
> 
> I do however wounder if it should be called lpi_capabilities, not
> eee_capabilities. These patches are all about making the core deal
> with 99% of EEE. All the MAC driver needs to do is enable/disable
> sending LPI and set the timer value. So we are really talking about
> the MACs LPI capabilities.

No problem with calling it lpi_capabilities.

Thanks!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

