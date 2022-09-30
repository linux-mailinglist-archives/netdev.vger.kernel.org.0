Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE8255F0D6B
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 16:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232049AbiI3OWE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 10:22:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232051AbiI3OVk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 10:21:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED485C9033
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 07:21:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A6EE8B828F5
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 14:21:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E84D9C43470;
        Fri, 30 Sep 2022 14:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664547682;
        bh=tn+uJp0hCNGEKULAk5syyPS6VXE7a+H6ka8mHscdn84=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ousdle2eN82l/jA3OUd5ngGhhWksrj2O+xWNaHvBn/w4CcOrocrtSi87WTyVQZqUV
         3HgtGj2MyeBplCFtZSpaVfyvTBLhwvrRrHGakfUHl5IMLmxra9j8d5jH41B1CmFijX
         XEPadd1vTvz5ldvbt/goZXHV8msRP87Eu3tqSHwNDrY993STQjasUvQ0DAlj0X/5c3
         eD82mN94GjVXQoXSI+Q2kZ0RK0skjk9ChPmhPLsJhGOw5ws+BAg1SkUWvRKVEQzdAa
         50PLVVNfhNfZ2gL5a2aF5oo9AaMe4BSCfoBg9TH9cjqQBAqDLqadFEggQh8WrPwi3a
         3Gf0Ct2NOg9VA==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next 04/12] net: phylink: rename phylink_sfp_config()
Date:   Fri, 30 Sep 2022 16:21:02 +0200
Message-Id: <20220930142110.15372-5-kabel@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220930142110.15372-1-kabel@kernel.org>
References: <20220930142110.15372-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>

phylink_sfp_config() now only deals with configuring the MAC for a
SFP containing a PHY. Rename it to be specific.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/net/phy/phylink.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index ab32ef767d69..f6e9231f0cbe 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -2867,9 +2867,8 @@ static void phylink_sfp_set_config(struct phylink *pl, u8 mode,
 		phylink_mac_initial_config(pl, false);
 }
 
-static int phylink_sfp_config(struct phylink *pl, u8 mode,
-			      const unsigned long *supported,
-			      const unsigned long *advertising)
+static int phylink_sfp_config_phy(struct phylink *pl, u8 mode,
+				  struct phy_device *phy)
 {
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(support1);
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(support);
@@ -2877,10 +2876,10 @@ static int phylink_sfp_config(struct phylink *pl, u8 mode,
 	phy_interface_t iface;
 	int ret;
 
-	linkmode_copy(support, supported);
+	linkmode_copy(support, phy->supported);
 
 	memset(&config, 0, sizeof(config));
-	linkmode_copy(config.advertising, advertising);
+	linkmode_copy(config.advertising, phy->advertising);
 	config.interface = PHY_INTERFACE_MODE_NA;
 	config.speed = SPEED_UNKNOWN;
 	config.duplex = DUPLEX_UNKNOWN;
@@ -3093,7 +3092,7 @@ static int phylink_sfp_connect_phy(void *upstream, struct phy_device *phy)
 		mode = MLO_AN_INBAND;
 
 	/* Do the initial configuration */
-	ret = phylink_sfp_config(pl, mode, phy->supported, phy->advertising);
+	ret = phylink_sfp_config_phy(pl, mode, phy);
 	if (ret < 0)
 		return ret;
 
-- 
2.35.1

