Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A4194E23D1
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 10:59:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346175AbiCUKAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 06:00:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346160AbiCUKAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 06:00:13 -0400
Received: from twspam01.aspeedtech.com (twspam01.aspeedtech.com [211.20.114.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22F70381B8;
        Mon, 21 Mar 2022 02:58:40 -0700 (PDT)
Received: from mail.aspeedtech.com ([192.168.0.24])
        by twspam01.aspeedtech.com with ESMTP id 22L9jwMZ079098;
        Mon, 21 Mar 2022 17:45:58 +0800 (GMT-8)
        (envelope-from dylan_hung@aspeedtech.com)
Received: from DylanHung-PC.aspeed.com (192.168.2.216) by TWMBX02.aspeed.com
 (192.168.0.24) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 21 Mar
 2022 17:56:23 +0800
From:   Dylan Hung <dylan_hung@aspeedtech.com>
To:     <robh+dt@kernel.org>, <joel@jms.id.au>, <andrew@aj.id.au>,
        <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <p.zabel@pengutronix.de>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-aspeed@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     <BMC-SW@aspeedtech.com>, <stable@vger.kernel.org>
Subject: [PATCH v2 1/3] dt-bindings: net: add reset property for aspeed, ast2600-mdio binding
Date:   Mon, 21 Mar 2022 17:56:46 +0800
Message-ID: <20220321095648.4760-2-dylan_hung@aspeedtech.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220321095648.4760-1-dylan_hung@aspeedtech.com>
References: <20220321095648.4760-1-dylan_hung@aspeedtech.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.2.216]
X-ClientProxiedBy: TWMBX02.aspeed.com (192.168.0.24) To TWMBX02.aspeed.com
 (192.168.0.24)
X-DNSRBL: 
X-MAIL: twspam01.aspeedtech.com 22L9jwMZ079098
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The AST2600 MDIO bus controller has a reset control bit and must be
deasserted before the manipulating the MDIO controller.

Signed-off-by: Dylan Hung <dylan_hung@aspeedtech.com>
Cc: stable@vger.kernel.org
---
 .../devicetree/bindings/net/aspeed,ast2600-mdio.yaml          | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/aspeed,ast2600-mdio.yaml b/Documentation/devicetree/bindings/net/aspeed,ast2600-mdio.yaml
index 1c88820cbcdf..8ba108e25d94 100644
--- a/Documentation/devicetree/bindings/net/aspeed,ast2600-mdio.yaml
+++ b/Documentation/devicetree/bindings/net/aspeed,ast2600-mdio.yaml
@@ -23,12 +23,15 @@ properties:
   reg:
     maxItems: 1
     description: The register range of the MDIO controller instance
+  resets:
+    maxItems: 1
 
 required:
   - compatible
   - reg
   - "#address-cells"
   - "#size-cells"
+  - resets
 
 unevaluatedProperties: false
 
@@ -39,6 +42,7 @@ examples:
             reg = <0x1e650000 0x8>;
             #address-cells = <1>;
             #size-cells = <0>;
+            resets = <&syscon 35>;
 
             ethphy0: ethernet-phy@0 {
                     compatible = "ethernet-phy-ieee802.3-c22";
-- 
2.25.1

