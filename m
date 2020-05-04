Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93F151C402A
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 18:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729740AbgEDQjQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 12:39:16 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:48437 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729734AbgEDQjQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 12:39:16 -0400
Received: from apollo.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:6257:18ff:fec4:ca34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 1D52522FF5;
        Mon,  4 May 2020 18:39:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1588610354;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=YP4gjbxcCteAmw6tSDmBQLlYF5WPFR7ZRFNU6sacuXM=;
        b=WxqziZ6M08fEKrcgpTq+MBtfBr4x/7p6ZJ3oyOA3U9TCJHtfTkJIo6BwU3LmMOqa+WxLAM
        kTJvJ4xgDUvjwtzHhuVR63BLe0EvFbrdJuMKuIKKZIarLZaBcG9NeKetuVGaRoYkplC71x
        WRN+kw9RCCuUUMHfrkHBU9mISgxbaRU=
From:   Michael Walle <michael@walle.cc>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next 0/3] add phy shared storage
Date:   Mon,  4 May 2020 18:38:56 +0200
Message-Id: <20200504163859.10763-1-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: ++++++
X-Spam-Level: ******
X-Rspamd-Server: web
X-Spam-Status: Yes, score=6.40
X-Spam-Score: 6.40
X-Rspamd-Queue-Id: 1D52522FF5
X-Spamd-Result: default: False [6.40 / 15.00];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         R_MISSING_CHARSET(2.50)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TAGGED_RCPT(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         BROKEN_CONTENT_TYPE(1.50)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         NEURAL_SPAM(0.00)[0.864];
         DKIM_SIGNED(0.00)[];
         RCPT_COUNT_SEVEN(0.00)[10];
         MID_CONTAINS_FROM(1.00)[];
         RCVD_COUNT_ZERO(0.00)[0];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         ASN(0.00)[asn:31334, ipnet:2a02:810c:8000::/33, country:DE];
         FREEMAIL_CC(0.00)[lunn.ch,gmail.com,armlinux.org.uk,davemloft.net,nxp.com,bootlin.com,walle.cc];
         SUSPICIOUS_RECIPS(1.50)[]
X-Spam: Yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce the concept of a shared PHY storage which can be used by some
QSGMII PHYs to ease initialization and access to global per-package
registers.

Changes since RFC:
 - check return code of kzalloc()
 - fix local variable ordering (reverse christmas tree)
 - add priv_size argument to phy_package_join()
 - add Tested-by tag, thanks Vladimir.

Michael Walle (3):
  net: phy: add concept of shared storage for PHYs
  net: phy: bcm54140: use phy_package_shared
  net: phy: mscc: use phy_package_shared

 drivers/net/phy/bcm54140.c       |  57 +++----------
 drivers/net/phy/mdio_bus.c       |   1 +
 drivers/net/phy/mscc/mscc.h      |   1 -
 drivers/net/phy/mscc/mscc_main.c | 101 +++++++---------------
 drivers/net/phy/phy_device.c     | 138 +++++++++++++++++++++++++++++++
 include/linux/phy.h              |  89 ++++++++++++++++++++
 6 files changed, 270 insertions(+), 117 deletions(-)

-- 
2.20.1

