Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F0F36A9334
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 10:00:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230389AbjCCI76 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 03:59:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230341AbjCCI7w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 03:59:52 -0500
Received: from ex01.ufhost.com (ex01.ufhost.com [61.152.239.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18CBF16ADA;
        Fri,  3 Mar 2023 00:59:41 -0800 (PST)
Received: from EXMBX165.cuchost.com (unknown [175.102.18.54])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "EXMBX165", Issuer "EXMBX165" (not verified))
        by ex01.ufhost.com (Postfix) with ESMTP id ECB5A24E2D7;
        Fri,  3 Mar 2023 16:59:39 +0800 (CST)
Received: from EXMBX162.cuchost.com (172.16.6.72) by EXMBX165.cuchost.com
 (172.16.6.75) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Fri, 3 Mar
 2023 16:59:40 +0800
Received: from starfive-sdk.starfivetech.com (171.223.208.138) by
 EXMBX162.cuchost.com (172.16.6.72) with Microsoft SMTP Server (TLS) id
 15.0.1497.42; Fri, 3 Mar 2023 16:59:39 +0800
From:   Samin Guo <samin.guo@starfivetech.com>
To:     <linux-riscv@lists.infradead.org>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>,
        Yanhong Wang <yanhong.wang@starfivetech.com>,
        Samin Guo <samin.guo@starfivetech.com>
Subject: [PATCH v5 10/12] riscv: dts: starfive: visionfive-2-v1.3b: Add gmac+phy's delay configuration
Date:   Fri, 3 Mar 2023 16:59:26 +0800
Message-ID: <20230303085928.4535-11-samin.guo@starfivetech.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230303085928.4535-1-samin.guo@starfivetech.com>
References: <20230303085928.4535-1-samin.guo@starfivetech.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [171.223.208.138]
X-ClientProxiedBy: EXCAS064.cuchost.com (172.16.6.24) To EXMBX162.cuchost.com
 (172.16.6.72)
X-YovoleRuleAgent: yovoleflag
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v1.3B uses motorcomm YT8531(rgmii-id phy) x2, need delay and
inverse configurations.

The tx_clk of v1.3B uses an external clock and needs to be
switched to an external clock source.

Signed-off-by: Samin Guo <samin.guo@starfivetech.com>
---
 .../jh7110-starfive-visionfive-2-v1.3b.dts    | 27 +++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-2-v1.3b.dts b/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-2-v1.3b.dts
index 9230cc3d8946..32fae0de9a44 100644
--- a/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-2-v1.3b.dts
+++ b/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-2-v1.3b.dts
@@ -11,3 +11,30 @@
 	model = "StarFive VisionFive 2 v1.3B";
 	compatible = "starfive,visionfive-2-v1.3b", "starfive,jh7110";
 };
+
+&gmac0 {
+	starfive,tx-use-rgmii-clk;
+	assigned-clocks = <&aoncrg JH7110_AONCLK_GMAC0_TX>;
+	assigned-clock-parents = <&aoncrg JH7110_AONCLK_GMAC0_RMII_RTX>;
+};
+
+&gmac1 {
+	starfive,tx-use-rgmii-clk;
+	assigned-clocks = <&syscrg JH7110_SYSCLK_GMAC1_TX>;
+	assigned-clock-parents = <&syscrg JH7110_SYSCLK_GMAC1_RMII_RTX>;
+};
+
+&phy0 {
+	motorcomm,tx-clk-adj-enabled;
+	motorcomm,tx-clk-100-inverted;
+	motorcomm,tx-clk-1000-inverted;
+	rx-internal-delay-ps = <1900>;
+	tx-internal-delay-ps = <1500>;
+};
+
+&phy1 {
+	motorcomm,tx-clk-adj-enabled;
+	motorcomm,tx-clk-100-inverted;
+	rx-internal-delay-ps = <0>;
+	tx-internal-delay-ps = <0>;
+};
-- 
2.17.1

