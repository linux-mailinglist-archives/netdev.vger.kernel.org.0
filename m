Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A03D6EB8E9
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 13:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbjDVLtG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Apr 2023 07:49:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbjDVLtE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Apr 2023 07:49:04 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 004322116;
        Sat, 22 Apr 2023 04:48:43 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1pqBjO-000853-1B;
        Sat, 22 Apr 2023 13:48:42 +0200
Date:   Sat, 22 Apr 2023 12:48:38 +0100
From:   Daniel Golle <daniel@makrotopia.org>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Chen Minqiang <ptpt52@gmail.com>, Chukun Pan <amadeus@jmu.edu.cn>,
        Yevhen Kolomeiko <jarvis2709@gmail.com>,
        Alexander Couzens <lynxis@fe80.eu>
Subject: [RFC PATCH net-next 3/8] net: phy: realtek: use genphy_soft_reset
 for 2.5G PHYs
Message-ID: <3ddae95741d87b94c9d135f3c0acfa1617f91836.1682163424.git.daniel@makrotopia.org>
References: <cover.1682163424.git.daniel@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1682163424.git.daniel@makrotopia.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some vendor bootloaders do weird things with those PHYs which result in
link modes being reported wrongly. Start from a clean sheet by resetting
the PHY.

Reported-by: Yevhen Kolomeiko <jarvis2709@gmail.com>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 drivers/net/phy/realtek.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index 34fd86b8ecf7d..9b477dd17fa56 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -1038,6 +1038,7 @@ static struct phy_driver realtek_drvs[] = {
 		.write_page	= rtl821x_write_page,
 		.read_mmd	= rtl822x_read_mmd,
 		.write_mmd	= rtl822x_write_mmd,
+		.soft_reset     = genphy_soft_reset,
 	}, {
 		PHY_ID_MATCH_EXACT(0x001cc840),
 		.name		= "RTL8226B_RTL8221B 2.5Gbps PHY",
@@ -1050,6 +1051,7 @@ static struct phy_driver realtek_drvs[] = {
 		.write_page	= rtl821x_write_page,
 		.read_mmd	= rtl822x_read_mmd,
 		.write_mmd	= rtl822x_write_mmd,
+		.soft_reset     = genphy_soft_reset,
 	}, {
 		PHY_ID_MATCH_EXACT(0x001cc838),
 		.name           = "RTL8226-CG 2.5Gbps PHY",
@@ -1060,6 +1062,7 @@ static struct phy_driver realtek_drvs[] = {
 		.resume         = rtlgen_resume,
 		.read_page      = rtl821x_read_page,
 		.write_page     = rtl821x_write_page,
+		.soft_reset     = genphy_soft_reset,
 	}, {
 		PHY_ID_MATCH_EXACT(0x001cc848),
 		.name           = "RTL8226B-CG_RTL8221B-CG 2.5Gbps PHY",
@@ -1070,6 +1073,7 @@ static struct phy_driver realtek_drvs[] = {
 		.resume         = rtlgen_resume,
 		.read_page      = rtl821x_read_page,
 		.write_page     = rtl821x_write_page,
+		.soft_reset     = genphy_soft_reset,
 	}, {
 		PHY_ID_MATCH_EXACT(0x001cc849),
 		.name           = "RTL8221B-VB-CG 2.5Gbps PHY",
@@ -1081,6 +1085,7 @@ static struct phy_driver realtek_drvs[] = {
 		.resume         = rtlgen_resume,
 		.read_page      = rtl821x_read_page,
 		.write_page     = rtl821x_write_page,
+		.soft_reset     = genphy_soft_reset,
 	}, {
 		PHY_ID_MATCH_EXACT(0x001cc84a),
 		.name           = "RTL8221B-VM-CG 2.5Gbps PHY",
@@ -1092,6 +1097,7 @@ static struct phy_driver realtek_drvs[] = {
 		.resume         = rtlgen_resume,
 		.read_page      = rtl821x_read_page,
 		.write_page     = rtl821x_write_page,
+		.soft_reset     = genphy_soft_reset,
 	}, {
 		PHY_ID_MATCH_EXACT(0x001cc961),
 		.name		= "RTL8366RB Gigabit Ethernet",
-- 
2.40.0

