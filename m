Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A94EA645324
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 05:43:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbiLGEnX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 23:43:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbiLGEnM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 23:43:12 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A5D756EC1
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 20:43:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=PZrVyvFlOMGvQsYAox31piE8Yb0sq/qIYSP8QqMcS3M=; b=r9mU9F0HJTEwPpQ8tx3pzhfITn
        4Z8PZ6/9kP9Y8ggwkvsssGEhR/ZFL1Hh9Tuki2PXnH8EgCVLBOjJUr2ORAGic51qEfmAwhoItjibi
        2uloCslBfrDfY+kKxIsbNx8u7y1DuuIis+mpsRkUCh09KgtpNDkZKNbVEHxd2EVSBSjMJW8RXZQYz
        XTw2OK2jKVqCnM1isPGPtPdTeQpZ1Dck9HLuvC+oxhK1pXc2fKfEm/beTrCU9DvxEHv6AO8rakCv6
        61+OybXnReu9JJdlnC+dapIp8NQm83xlB1IRhajv6Y9sVyGdjkTUYeFd6mJWFBSLAWyjPrre0MZO+
        +O9w1N8g==;
Received: from [2601:1c2:d80:3110::a2e7] (helo=casper.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p2mH0-0058CH-Ax; Wed, 07 Dec 2022 04:43:10 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH] net: phy: remove redundant "depends on" lines
Date:   Tue,  6 Dec 2022 20:42:57 -0800
Message-Id: <20221207044257.30036-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Delete a few lines of "depends on PHYLIB" since they are inside
an "if PHYLIB / endif # PHYLIB" block, i.e., they are redundant
and the other 50+ drivers there don't use "depends on PHYLIB"
since it is not needed.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Russell King <linux@armlinux.org.uk>
---
 drivers/net/phy/Kconfig |    3 ---
 1 file changed, 3 deletions(-)

diff -- a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -47,7 +47,6 @@ config LED_TRIGGER_PHY
 
 config FIXED_PHY
 	tristate "MDIO Bus/PHY emulation with fixed speed/link PHYs"
-	depends on PHYLIB
 	select SWPHY
 	help
 	  Adds the platform "fixed" MDIO Bus to cover the boards that use
@@ -112,7 +111,6 @@ config BROADCOM_PHY
 
 config BCM54140_PHY
 	tristate "Broadcom BCM54140 PHY"
-	depends on PHYLIB
 	depends on HWMON || HWMON=n
 	select BCM_NET_PHYLIB
 	help
@@ -137,7 +135,6 @@ config BCM7XXX_PHY
 
 config BCM84881_PHY
 	tristate "Broadcom BCM84881 PHY"
-	depends on PHYLIB
 	help
 	  Support the Broadcom BCM84881 PHY.
 
