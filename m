Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FE626A9340
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 10:00:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230432AbjCCJAK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 04:00:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230053AbjCCI7z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 03:59:55 -0500
Received: from fd01.gateway.ufhost.com (fd01.gateway.ufhost.com [61.152.239.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DD37199E0;
        Fri,  3 Mar 2023 00:59:42 -0800 (PST)
Received: from EXMBX166.cuchost.com (unknown [175.102.18.54])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "EXMBX166", Issuer "EXMBX166" (not verified))
        by fd01.gateway.ufhost.com (Postfix) with ESMTP id E7F3724E398;
        Fri,  3 Mar 2023 16:59:40 +0800 (CST)
Received: from EXMBX162.cuchost.com (172.16.6.72) by EXMBX166.cuchost.com
 (172.16.6.76) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Fri, 3 Mar
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
Subject: [PATCH v5 11/12] riscv: dts: starfive: visionfive-2-v1.2a: Add gmac+phy's delay configuration
Date:   Fri, 3 Mar 2023 16:59:27 +0800
Message-ID: <20230303085928.4535-12-samin.guo@starfivetech.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230303085928.4535-1-samin.guo@starfivetech.com>
References: <20230303085928.4535-1-samin.guo@starfivetech.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [171.223.208.138]
X-ClientProxiedBy: EXCAS064.cuchost.com (172.16.6.24) To EXMBX162.cuchost.com
 (172.16.6.72)
X-YovoleRuleAgent: yovoleflag
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v1.2A gmac0 uses motorcomm YT8531(rgmii-id) PHY, and needs delay
configurations.

v1.2A gmac1 uses motorcomm YT8512(rmii) PHY, and needs to
switch rx and rx to external clock sources.

Signed-off-by: Samin Guo <samin.guo@starfivetech.com>
---
 .../starfive/jh7110-starfive-visionfive-2-v1.2a.dts | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-2-v1.2a.dts b/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-2-v1.2a.dts
index 4af3300f3cf3..205a13d8c8b1 100644
--- a/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-2-v1.2a.dts
+++ b/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-2-v1.2a.dts
@@ -11,3 +11,16 @@
 	model = "StarFive VisionFive 2 v1.2A";
 	compatible = "starfive,visionfive-2-v1.2a", "starfive,jh7110";
 };
+
+&gmac1 {
+	phy-mode = "rmii";
+	assigned-clocks = <&syscrg JH7110_SYSCLK_GMAC1_TX>,
+			  <&syscrg JH7110_SYSCLK_GMAC1_RX>;
+	assigned-clock-parents = <&syscrg JH7110_SYSCLK_GMAC1_RMII_RTX>,
+				 <&syscrg JH7110_SYSCLK_GMAC1_RMII_RTX>;
+};
+
+&phy0 {
+	rx-internal-delay-ps = <1900>;
+	tx-internal-delay-ps = <1350>;
+};
-- 
2.17.1

