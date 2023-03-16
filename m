Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A18186BC542
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 05:37:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbjCPEh2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 00:37:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjCPEhZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 00:37:25 -0400
Received: from ex01.ufhost.com (ex01.ufhost.com [61.152.239.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA762A8EB8;
        Wed, 15 Mar 2023 21:37:19 -0700 (PDT)
Received: from EXMBX166.cuchost.com (unknown [175.102.18.54])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "EXMBX166", Issuer "EXMBX166" (not verified))
        by ex01.ufhost.com (Postfix) with ESMTP id 7728A24E1EC;
        Thu, 16 Mar 2023 12:37:18 +0800 (CST)
Received: from EXMBX162.cuchost.com (172.16.6.72) by EXMBX166.cuchost.com
 (172.16.6.76) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Thu, 16 Mar
 2023 12:37:18 +0800
Received: from starfive-sdk.starfivetech.com (171.223.208.138) by
 EXMBX162.cuchost.com (172.16.6.72) with Microsoft SMTP Server (TLS) id
 15.0.1497.42; Thu, 16 Mar 2023 12:37:17 +0800
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
        Samin Guo <samin.guo@starfivetech.com>,
        Tommaso Merciai <tomm.merciai@gmail.com>
Subject: [PATCH v7 3/6] dt-bindings: net: snps,dwmac: Add 'ahb' reset/reset-name
Date:   Thu, 16 Mar 2023 12:37:11 +0800
Message-ID: <20230316043714.24279-4-samin.guo@starfivetech.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230316043714.24279-1-samin.guo@starfivetech.com>
References: <20230316043714.24279-1-samin.guo@starfivetech.com>
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

According to:
stmmac_platform.c: stmmac_probe_config_dt
stmmac_main.c: stmmac_dvr_probe

dwmac controller may require one (stmmaceth) or two (stmmaceth+ahb)
reset signals, and the maxItems of resets/reset-names is going to be 2.

The gmac of Starfive Jh7110 SOC must have two resets.
it uses snps,dwmac-5.20 IP.

Signed-off-by: Samin Guo <samin.guo@starfivetech.com>
Tested-by: Tommaso Merciai <tomm.merciai@gmail.com>
---
 .../devicetree/bindings/net/snps,dwmac.yaml          | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
index 01b056ab71f7..e4519cf722ab 100644
--- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
@@ -133,12 +133,16 @@ properties:
         - ptp_ref
 
   resets:
-    maxItems: 1
-    description:
-      MAC Reset signal.
+    minItems: 1
+    items:
+      - description: GMAC stmmaceth reset
+      - description: AHB reset
 
   reset-names:
-    const: stmmaceth
+    minItems: 1
+    items:
+      - const: stmmaceth
+      - const: ahb
 
   power-domains:
     maxItems: 1
-- 
2.17.1

