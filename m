Return-Path: <netdev+bounces-3271-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 59101706565
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 12:37:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 13F74281627
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 10:37:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CD27154B7;
	Wed, 17 May 2023 10:37:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C7A92CA6
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 10:37:14 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9365540E6
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 03:37:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
	Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=vPQuC2Knq+B5VW+FCOV656SyHImAIzJnBAjWotDxk5E=; b=WaJTPvFAfWKpFNyPUqr0LBwBvK
	671aJ0BzpfxuoqtO75jr+rhx+e62arD2zVGUrh65zEzjEPt2CI10z1cDnNOoLvT4Yma+xLLaGxqDB
	cQh6ZrzyhoJQxvgXnbNW2O4n+RcY9ixRH7vfthPZTZ8wzF54wi6J2vZD7ykU0bY6xSAOKBBQnFo0j
	wX4eUl/X2XQCxL7zTAay/jVWxcf/vEVaEglAYnjtfwPXBBOgjEpPBWEP79APdnjo9JwzRVT8jyQsE
	f+K+0Sgp9AfsiTm+x8jr4Y4+kZagfbBse/58BNOz1niQwrIYEQdbD3jbG8wjwdyozDQz5Q6Ck/Vik
	s8Il8rXA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:42026)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1pzEWn-0007Xs-On; Wed, 17 May 2023 11:37:05 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1pzEWj-0001lJ-2i; Wed, 17 May 2023 11:37:01 +0100
Date: Wed, 17 May 2023 11:37:01 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>,
	Daniel Golle <daniel@makrotopia.org>,
	Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Subject: [PATCH net-next 0/7] net: sfp: add support for control of rate
 selection
Message-ID: <ZGSuTY8GqjM+sqta@shell.armlinux.org.uk>
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

This series introduces control of the rate selection SFP pins (or
their soft state in the I2C diagnostics EEPROM). Several SNIA documents
(referenced in the commits) describe the various different modes for
these, and we implement them all for maximum compatibility, but as
we know, SFP modules tend to do their own thing, so that may not be
sufficient.

In order to implement this, we need to change the locking arrangement
in the SFP layer - we need to make st_mutex (state mutex) able to be
taken from within the rtnl lock and sm_mutex (state machine mutex).
Essentially, st_mutex protects the hard (gpio) and soft state signals.

So, patches 2 through 5 rejig the locking so that st_mutex is only
ever taken when we want to fiddle with the signal state variables,
read or write the GPIOs, or read or write the soft state.

Patch 1 adds a helper that makes the locking rejig a little easier
as it combines the update of sfp->state with setting the updated
control state to the module.

Patch 6 adds code to phylink to give the signalling rate for various
PHY interface modes that are relevant to SFPs - this is the baud rate
of the encoded signal, not the data rate, which is what matters for
SFPs. This rate is passed through the SFP bus layer into the SFP
socket driver, which initially has a stub sfp_set_signal_rate().

Patch 7 adds the code to the SFP socket driver to parse the rate
selection data in the EEPROM, configure which RS signals need to be
driven, and the signalling rate threshold. We fill in 
sfp_set_signal_rate() to set the rate select pins as appropriate.

Thanks to Simon for reviewing.

 drivers/net/phy/phylink.c |  24 ++++
 drivers/net/phy/sfp-bus.c |  20 +++
 drivers/net/phy/sfp.c     | 310 ++++++++++++++++++++++++++++++++++++++--------
 drivers/net/phy/sfp.h     |   1 +
 include/linux/sfp.h       |  14 +++
 5 files changed, 317 insertions(+), 52 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

