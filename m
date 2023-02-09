Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB1BD69034C
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 10:19:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230135AbjBIJTv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 04:19:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230121AbjBIJTR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 04:19:17 -0500
Received: from mr85p00im-ztdg06021801.me.com (mr85p00im-ztdg06021801.me.com [17.58.23.195])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCF486278C
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 01:19:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=me.com; s=1a1hai;
        t=1675934345; bh=Yv+aNQTOHIB7qRjwbmhigngM9kFtfMeoMgBiuYQtyTc=;
        h=From:To:Subject:Date:Message-Id:MIME-Version;
        b=oBFHuOqplvPaB63OfWHRSYdmhJyYEYuM64AGUaaBl1O9cDGOgkRm1Md9X2qfrF4Yb
         cNz0TzPvmowvMZJclQB7q20wOlUdM9FyImDauKzGV8RQBoi95qNIoPHcV5yfLNh+r/
         vrOgEvUpTrDjsa+N3wKz7AMoBx0vdz2xODUb2uLlX5u3FoUlSP/DAJotIuTq7ffHmx
         loB19SNpknN+bJRB6rQSAzEjc8fYLEaKmd8bFy5WboTd2EiURLhGE+8JGhRPH32TJQ
         jo56V1Jy4Nfph7kVKWThxswd2D1+l+pHOAjF5LzmoSfiCXh11WUKgMOc9pE5RRtW24
         PKcyexmRmtGtA==
Received: from localhost (mr38p00im-dlb-asmtp-mailmevip.me.com [17.57.152.18])
        by mr85p00im-ztdg06021801.me.com (Postfix) with ESMTPSA id F2AFAD02A13;
        Thu,  9 Feb 2023 09:19:04 +0000 (UTC)
From:   Alain Volmat <avolmat@me.com>
To:     Jonathan Corbet <corbet@lwn.net>, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Patrice Chotard <patrice.chotard@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amitk@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com, linux-pm@vger.kernel.org,
        linux-clk@vger.kernel.org, Alain Volmat <avolmat@me.com>
Subject: [PATCH 07/11] net: ethernet: stmmac: dwmac-sti: remove stih415/stih416/stid127
Date:   Thu,  9 Feb 2023 10:16:55 +0100
Message-Id: <20230209091659.1409-8-avolmat@me.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230209091659.1409-1-avolmat@me.com>
References: <20230209091659.1409-1-avolmat@me.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: cbkkKnxBitPfqUkYra3jifKFBB60-BQq
X-Proofpoint-ORIG-GUID: cbkkKnxBitPfqUkYra3jifKFBB60-BQq
X-Proofpoint-Virus-Version: =?UTF-8?Q?vendor=3Dfsecure_engine=3D1.1.170-22c6f66c430a71ce266a39bfe25bc?=
 =?UTF-8?Q?2903e8d5c8f:6.0.425,18.0.816,17.11.62.513.0000000_definitions?=
 =?UTF-8?Q?=3D2022-01-18=5F01:2022-01-14=5F01,2022-01-18=5F01,2021-12-02?=
 =?UTF-8?Q?=5F01_signatures=3D0?=
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 bulkscore=0
 adultscore=0 clxscore=1015 spamscore=0 phishscore=0 mlxlogscore=999
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2302090088
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove no more supported platforms (stih415/stih416 and stid127)

Signed-off-by: Alain Volmat <avolmat@me.com>
---
 .../net/ethernet/stmicro/stmmac/dwmac-sti.c   | 60 +------------------
 1 file changed, 1 insertion(+), 59 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sti.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-sti.c
index 710d7435733e..3b424f4f95f9 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sti.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sti.c
@@ -35,7 +35,7 @@
 #define IS_PHY_IF_MODE_GBIT(iface)	(IS_PHY_IF_MODE_RGMII(iface) || \
 					 iface == PHY_INTERFACE_MODE_GMII)
 
-/* STiH4xx register definitions (STiH415/STiH416/STiH407/STiH410 families)
+/* STiH4xx register definitions (STiH407/STiH410 families)
  *
  * Below table summarizes the clock requirement and clock sources for
  * supported phy interface modes with link speeds.
@@ -75,27 +75,6 @@
 #define STIH4XX_ETH_SEL_INTERNAL_NOTEXT_PHYCLK	BIT(7)
 #define STIH4XX_ETH_SEL_TXCLK_NOT_CLK125	BIT(6)
 
-/* STiD127 register definitions
- *-----------------------
- * src	 |BIT(6)| BIT(7)|
- *-----------------------
- * MII   |  1	|   n/a	|
- *-----------------------
- * RMII  |  n/a	|   1	|
- * clkgen|	|	|
- *-----------------------
- * RMII  |  n/a	|   0	|
- * phyclk|	|	|
- *-----------------------
- * RGMII |  1	|  n/a	|
- * clkgen|	|	|
- *-----------------------
- */
-
-#define STID127_RETIME_SRC_MASK			GENMASK(7, 6)
-#define STID127_ETH_SEL_INTERNAL_NOTEXT_PHYCLK	BIT(7)
-#define STID127_ETH_SEL_INTERNAL_NOTEXT_TXCLK	BIT(6)
-
 #define ENMII_MASK	GENMASK(5, 5)
 #define ENMII		BIT(5)
 #define EN_MASK		GENMASK(1, 1)
@@ -194,36 +173,6 @@ static void stih4xx_fix_retime_src(void *priv, u32 spd)
 			   stih4xx_tx_retime_val[src]);
 }
 
-static void stid127_fix_retime_src(void *priv, u32 spd)
-{
-	struct sti_dwmac *dwmac = priv;
-	u32 reg = dwmac->ctrl_reg;
-	u32 freq = 0;
-	u32 val = 0;
-
-	if (dwmac->interface == PHY_INTERFACE_MODE_MII) {
-		val = STID127_ETH_SEL_INTERNAL_NOTEXT_TXCLK;
-	} else if (dwmac->interface == PHY_INTERFACE_MODE_RMII) {
-		if (!dwmac->ext_phyclk) {
-			val = STID127_ETH_SEL_INTERNAL_NOTEXT_PHYCLK;
-			freq = DWMAC_50MHZ;
-		}
-	} else if (IS_PHY_IF_MODE_RGMII(dwmac->interface)) {
-		val = STID127_ETH_SEL_INTERNAL_NOTEXT_TXCLK;
-		if (spd == SPEED_1000)
-			freq = DWMAC_125MHZ;
-		else if (spd == SPEED_100)
-			freq = DWMAC_25MHZ;
-		else if (spd == SPEED_10)
-			freq = DWMAC_2_5MHZ;
-	}
-
-	if (freq)
-		clk_set_rate(dwmac->clk, freq);
-
-	regmap_update_bits(dwmac->regmap, reg, STID127_RETIME_SRC_MASK, val);
-}
-
 static int sti_dwmac_set_mode(struct sti_dwmac *dwmac)
 {
 	struct regmap *regmap = dwmac->regmap;
@@ -407,14 +356,7 @@ static const struct sti_dwmac_of_data stih4xx_dwmac_data = {
 	.fix_retime_src = stih4xx_fix_retime_src,
 };
 
-static const struct sti_dwmac_of_data stid127_dwmac_data = {
-	.fix_retime_src = stid127_fix_retime_src,
-};
-
 static const struct of_device_id sti_dwmac_match[] = {
-	{ .compatible = "st,stih415-dwmac", .data = &stih4xx_dwmac_data},
-	{ .compatible = "st,stih416-dwmac", .data = &stih4xx_dwmac_data},
-	{ .compatible = "st,stid127-dwmac", .data = &stid127_dwmac_data},
 	{ .compatible = "st,stih407-dwmac", .data = &stih4xx_dwmac_data},
 	{ }
 };
-- 
2.34.1

