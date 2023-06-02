Return-Path: <netdev+bounces-7424-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 93C207203D4
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 15:58:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 493312818FD
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 13:58:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DC251952B;
	Fri,  2 Jun 2023 13:58:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51C6F15BF
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 13:58:18 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAF5513E
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 06:58:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
	Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=d3T3tutC6K9EUQ7mUmo7TEujeFp6RrvqyQhtSC/y+rs=; b=l2K9zEBLN232o760w95n3Pkx2n
	h9ST87sJS7FIuFAcWlH5JP6ZFzE+NiOIWKwNP5pz/ZrgByPQ4+bHa9PBGEEhtUU9KT898CP+G5DmX
	76XqdP4zWlHW69Ka2QiRcQdTC0V8vQpsuSCFXwR5iaR9BVXYAYHmJe4es5bJKmFVq2yJ1xh6Zp5Vn
	zAltr0mlak+Lj9+DuFzvQtLfcrAmMIl5LJ5nMuQ1mFERN75EPHekYED6v8mSuOW55mEgUBuisrC8Z
	rrGPkzxuT1uN17uRqiAbe5fAn6G9wi3aT64Qy2Gfh6kir6rWLp7aRKU8bRugKZsEK5+kd8Dw1tKCX
	lRLEVMSw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:52866)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q55IB-00086F-NN; Fri, 02 Jun 2023 14:58:11 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q55I9-000307-Q2; Fri, 02 Jun 2023 14:58:09 +0100
Date: Fri, 2 Jun 2023 14:58:09 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Jose Abreu <Jose.Abreu@synopsys.com>, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>,
	Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 0/3] convert sja1105 xpcs creation and remove
 xpcs_create
Message-ID: <ZHn1cTGFtEQ1Rv6E@shell.armlinux.org.uk>
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

This series of three patches converts sja1105 to use the newly
provided xpcs_create_mdiodev(), and as there become no users of
xpcs_create(), removes this function from the global namespace to
discourage future direct use.

 drivers/net/dsa/sja1105/sja1105_mdio.c | 11 +----------
 drivers/net/pcs/pcs-xpcs.c             |  5 ++---
 include/linux/pcs/pcs-xpcs.h           |  2 --
 3 files changed, 3 insertions(+), 15 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

