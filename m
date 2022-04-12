Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02E764FD980
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 12:40:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238449AbiDLH72 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 03:59:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353525AbiDLHPl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 03:15:41 -0400
Received: from twspam01.aspeedtech.com (twspam01.aspeedtech.com [211.20.114.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73B9639B97;
        Mon, 11 Apr 2022 23:57:02 -0700 (PDT)
Received: from mail.aspeedtech.com ([192.168.0.24])
        by twspam01.aspeedtech.com with ESMTP id 23C6gdB0026333;
        Tue, 12 Apr 2022 14:42:39 +0800 (GMT-8)
        (envelope-from dylan_hung@aspeedtech.com)
Received: from DylanHung-PC.aspeed.com (192.168.2.216) by TWMBX02.aspeed.com
 (192.168.0.24) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 12 Apr
 2022 14:54:18 +0800
From:   Dylan Hung <dylan_hung@aspeedtech.com>
To:     <robh+dt@kernel.org>, <joel@jms.id.au>, <andrew@aj.id.au>,
        <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <p.zabel@pengutronix.de>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-aspeed@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <krzk+dt@kernel.org>
CC:     <BMC-SW@aspeedtech.com>, Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH v4 1/3] dt-bindings: net: add reset property for aspeed, ast2600-mdio binding
Date:   Tue, 12 Apr 2022 14:56:09 +0800
Message-ID: <20220412065611.8930-2-dylan_hung@aspeedtech.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220412065611.8930-1-dylan_hung@aspeedtech.com>
References: <20220412065611.8930-1-dylan_hung@aspeedtech.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.2.216]
X-ClientProxiedBy: TWMBX02.aspeed.com (192.168.0.24) To TWMBX02.aspeed.com
 (192.168.0.24)
X-DNSRBL: 
X-MAIL: twspam01.aspeedtech.com 23C6gdB0026333
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The AST2600 MDIO bus controller has a reset control bit and must be
deasserted before manipulating the MDIO controller. By default, the
hardware asserts the reset so the driver only need to deassert it.

Regarding to the old DT blobs which don't have reset property in them,
the reset deassertion is usually done by the bootloader so the reset
property is optional to work with them.

Signed-off-by: Dylan Hung <dylan_hung@aspeedtech.com>
Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
---
 .../devicetree/bindings/net/aspeed,ast2600-mdio.yaml         | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/aspeed,ast2600-mdio.yaml b/Documentation/devicetree/bindings/net/aspeed,ast2600-mdio.yaml
index 1c88820cbcdf..1174c14898e1 100644
--- a/Documentation/devicetree/bindings/net/aspeed,ast2600-mdio.yaml
+++ b/Documentation/devicetree/bindings/net/aspeed,ast2600-mdio.yaml
@@ -20,10 +20,14 @@ allOf:
 properties:
   compatible:
     const: aspeed,ast2600-mdio
+
   reg:
     maxItems: 1
     description: The register range of the MDIO controller instance
 
+  resets:
+    maxItems: 1
+
 required:
   - compatible
   - reg
@@ -39,6 +43,7 @@ examples:
             reg = <0x1e650000 0x8>;
             #address-cells = <1>;
             #size-cells = <0>;
+            resets = <&syscon ASPEED_RESET_MII>;
 
             ethphy0: ethernet-phy@0 {
                     compatible = "ethernet-phy-ieee802.3-c22";
-- 
2.25.1

