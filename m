Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB2375A28E5
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 15:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344412AbiHZNzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 09:55:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344389AbiHZNzN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 09:55:13 -0400
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [217.70.183.193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CA2F4AD55;
        Fri, 26 Aug 2022 06:55:08 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id DF9AF240009;
        Fri, 26 Aug 2022 13:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1661522106;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f0n7NDlZ2x9VzdQiJVmYZllt4f0/gdngUBcBYKLIb78=;
        b=N1lWP89KO4Wy/SS5jPW0Q62BS1zHctafmqh5matVeboaDAVEmVQPCreJWUIqD07qax0c7i
        BtiCq5loF74KAFQJVdfsqvk/lP805ksWNA7uNTcrYdPGJyR1BFoSqKmtFv/8iB1XngxnK7
        8KJUKJ/ZB+/h+AAPf/Vyxt5St9BjWWUf4StfpFjNDIjLWoOy5c8R40fnaGoOd+jAkRosBh
        k4Lc2NjZq5Z1Gy3/QtGPnOdza4/oDNyI7bjptLNgCecGFD4ku+rvjrBM+265LwesXlRg4m
        Bk0BNeaPmKVH9P+HECcZTjdHQJrvuzrHieVMOPkJuD9CugHzlopNPp0+gk5SJQ==
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net, Rob Herring <robh+dt@kernel.org>
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH net-next 5/5] dt-bindings: net: altera: tse: add an optional pcs register range
Date:   Fri, 26 Aug 2022 15:54:51 +0200
Message-Id: <20220826135451.526756-6-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220826135451.526756-1-maxime.chevallier@bootlin.com>
References: <20220826135451.526756-1-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some implementations of the TSE have their PCS as an external bloc,
exposed at its own register range. Document this, and add a new example
showing a case using the pcs and the new phylink conversion to connect
an sfp port to a TSE mac.

Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---
 .../devicetree/bindings/net/altr,tse.yaml     | 28 +++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/altr,tse.yaml b/Documentation/devicetree/bindings/net/altr,tse.yaml
index 24e081cd1aa9..921011fc93f9 100644
--- a/Documentation/devicetree/bindings/net/altr,tse.yaml
+++ b/Documentation/devicetree/bindings/net/altr,tse.yaml
@@ -40,8 +40,10 @@ allOf:
       properties:
         reg:
           minItems: 6
+          maxItems: 7
         reg-names:
           minItems: 6
+          maxItems: 7
           items:
             - const: control_port
             - const: rx_csr
@@ -49,6 +51,7 @@ allOf:
             - const: rx_resp
             - const: tx_csr
             - const: tx_desc
+            - const: pcs
 
 properties:
   compatible:
@@ -99,6 +102,31 @@ required:
 unevaluatedProperties: false
 
 examples:
+  - |
+    tse_sub_0: ethernet@c0100000 {
+        compatible = "altr,tse-msgdma-1.0";
+        reg = <0xc0100000 0x00000400>,
+              <0xc0101000 0x00000020>,
+              <0xc0102000 0x00000020>,
+              <0xc0103000 0x00000008>,
+              <0xc0104000 0x00000020>,
+              <0xc0105000 0x00000020>,
+              <0xc0106000 0x00000100>;
+        reg-names = "control_port", "rx_csr", "rx_desc", "rx_resp", "tx_csr", "tx_desc", "pcs";
+        interrupt-parent = <&intc>;
+        interrupts = <0 44 4>,<0 45 4>;
+        interrupt-names = "rx_irq","tx_irq";
+        rx-fifo-depth = <2048>;
+        tx-fifo-depth = <2048>;
+        address-bits = <48>;
+        max-frame-size = <1500>;
+        local-mac-address = [ 00 0C ED 00 00 02 ];
+        altr,has-supplementary-unicast;
+        altr,has-hash-multicast-filter;
+        sfp = <&sfp0>;
+        phy-mode = "sgmii";
+        managed = "in-band-status";
+    };
   - |
     tse_sub_1_eth_tse_0: ethernet@1,00001000 {
         compatible = "altr,tse-msgdma-1.0";
-- 
2.37.2

