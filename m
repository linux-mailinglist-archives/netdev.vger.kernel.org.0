Return-Path: <netdev+bounces-9461-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F4BF729465
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 11:13:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 96DF0281916
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 09:12:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3C80C8FF;
	Fri,  9 Jun 2023 09:12:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9599BBA3F
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 09:12:57 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEEAD46A0
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 02:12:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
	Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=6oAmBDJZQ0GbB16kcOqOf5PrImdP5GDBxyET5fEnL4A=; b=XwPVax/LFA2gMwSDg4gsLyS6+U
	LsGO4/m5h2cNv9dw3hKHPtRAtRJ1HoIo7xmFJmQrUzTSUBCkt/mtOfx8oRFztT38LH/OU98jaIpQB
	66LrNZBBIct17+LrvQeHzC7kHZ5WqJKvkkfypo/J4H99PGoI5xt8bCNLajcNOuFkoaEfhJ7XiDsaP
	mAkNDBRf6yL4Xl/stG1Hobj1z8Z4l0cfgFYqL5q8PHJ5hRGZcs9vWZEXGAVrkDVNFS13UJWzb6zAr
	SD4u9Y9EHCNQDMoGL4p68ldZWXNWbXcwKJ1uS7AUoutPnXUAvdpWObijgH62vv4mRTYW804F+ZEJv
	hr0ECWFg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:46354)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q7Y9D-0001jC-TT; Fri, 09 Jun 2023 10:11:07 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q7Y9B-0001jX-Ny; Fri, 09 Jun 2023 10:11:05 +0100
Date: Fri, 9 Jun 2023 10:11:05 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Marcin Wojtas <mw@semihalf.com>,
	netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: [PATCH RFC net-next 0/4] phylink EEE support
Message-ID: <ZILsqV0gkSMMdinU@shell.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi,

There has been some recent discussion on generalising EEE support so
that drivers implement it more consistently. This has mostly focused
around phylib, but there are other situations where EEE may be useful.

To illustrate this, in both USGMII and UXGMII communicate EEE through
the configuration word - bit 8 indicates EEE capability and bit 7
indicates the clock stop capability. The PHY may not be accessible.
Another case would be a PHY on a SFP module that may not be accessible,
signalling LPI to it may result in power savings if it has negotiated
with the link partner. My understanding is that signalling LPI when
negotiation hasn't agreed EEE support should be fine. In the classic
model, LPI informs the PHY that the MAC is idle, and gives it
permission to enter low power. It will only enter low power when the
MAC sends LPI and the remote PHY also agrees to enter low power.

mvneta has had EEE support for a while, but the implementation has its
quirks. This series implements EEE handling in phylink. To make use of
it, a MAC driver needs to fill in the default parameters for EEE, and
provide the enable and disable functions for LPI.

This series also adds EEE for mvpp2, which is only supported by the
GMAC (up to 1G) and not the XLG (5G,10G) MAC.

There is further work that needs to be considered - 802.3 has the
facility to negotiate the Tw (wake to data) parameter via packets.
Also, timing parameters are speed and media type specific, some
implementations need these parameters reprogrammed each time the speed
changes (e.g. mvneta and mvpp2.)

Patch 1 adds a structure to store the runtime EEE configuration  state,
a helper to decode the state to indicate whether LPI can be enabled (it
remains the responsibility of the user to determine whether EEE has
been negotiated.) A couple of helpers are provided to insert and
extract the EEE configuration from the ethtool EEE structure.

Patch 2 adds the phylink implementation.

Patch 3 converts mvneta to use phylink's implementation.

Patch 4 adds mvpp2 support.

This uses the current code from phylib, and is only functional when we
have a phylib PHY, but can be easily extended so that when we have a
SFP socket without a PHY, we can enable LPI signalling.

 drivers/net/ethernet/marvell/mvneta.c           | 95 ++++++++++++++++---------
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h      |  5 ++
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 85 ++++++++++++++++++++++
 drivers/net/phy/phylink.c                       | 82 +++++++++++++++++++--
 include/linux/phylink.h                         | 32 +++++++++
 include/net/eee.h                               | 38 ++++++++++
 6 files changed, 298 insertions(+), 39 deletions(-)
 create mode 100644 include/net/eee.h

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

