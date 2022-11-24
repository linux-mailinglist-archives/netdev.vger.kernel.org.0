Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33EFA637752
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 12:16:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbiKXLQR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 06:16:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbiKXLQK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 06:16:10 -0500
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [217.70.183.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5954F6F801;
        Thu, 24 Nov 2022 03:16:09 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 846881C0015;
        Thu, 24 Nov 2022 11:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1669288568;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wAx8VtTdz4qwIpgQj6QKnIjD5MlND5gXjXhbAzs+LZw=;
        b=lRbAy1VF1dKDs7kpuf9TWgf81sL6Qv/MZQY4zGhvLdtm0UyHfC8hdVSrKp+rRF2NIgbHJB
        jyngQajMS8US3CAO8hW/8m3OhXZKPmKIbnGWB/7kBmeZYJ1/YmkTg1/Hi7ctdu26z/aMhE
        rnnvlt3nqcrV0xQse4qWGRra4CLes0m9vLvcXKkmSjZimxTCOaIDHS1pmpKN7TeXk/JDIk
        h2TakiF23+yU9Xpi6k/+IwxlOeB/isqLDtxD+17M4hgQQ87pjfD7duNzOjDpmI25M/NDtT
        WTrHN0dSrBhJH4XzOzN1TNAmPVAvPl+mLQZmgguqbEbVRnFsiM6rojT4A1idpQ==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org
Cc:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        devicetree@vger.kernel.org, Robert Marko <robert.marko@sartura.hr>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Michael Walle <michael@walle.cc>,
        Marcin Wojtas <mw@semihalf.com>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Vadym Kochan <vadym.kochan@plvision.eu>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH net-next v2 2/7] dt-bindings: net: marvell,dfx-server: Convert to yaml
Date:   Thu, 24 Nov 2022 12:15:51 +0100
Message-Id: <20221124111556.264647-3-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221124111556.264647-1-miquel.raynal@bootlin.com>
References: <20221124111556.264647-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Even though this description is not used anywhere upstream (no matching
driver), while on this file I decided I would try a conversion to yaml
in order to clarify the prestera family description.

I cannot keep the nodename dfx-server@xxxx so I switched to dfx-bus@xxxx
which matches simple-bus.yaml. Otherwise I took the example context from
the only user of this compatible: armada-xp-98dx3236.dtsi, which is a
rather old and not perfect DT.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 .../bindings/net/marvell,dfx-server.yaml      | 62 +++++++++++++++++++
 .../bindings/net/marvell,prestera.txt         | 18 ------
 2 files changed, 62 insertions(+), 18 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/marvell,dfx-server.yaml

diff --git a/Documentation/devicetree/bindings/net/marvell,dfx-server.yaml b/Documentation/devicetree/bindings/net/marvell,dfx-server.yaml
new file mode 100644
index 000000000000..8a14c919e3f7
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/marvell,dfx-server.yaml
@@ -0,0 +1,62 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/marvell,dfx-server.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Marvell Prestera DFX server
+
+maintainers:
+  - Miquel Raynal <miquel.raynal@bootlin.com>
+
+select:
+  properties:
+    compatible:
+      contains:
+        const: marvell,dfx-server
+  required:
+    - compatible
+
+properties:
+  compatible:
+    items:
+      - const: marvell,dfx-server
+      - const: simple-bus
+
+  reg:
+    maxItems: 1
+
+  ranges: true
+
+  '#address-cells':
+    const: 1
+
+  '#size-cells':
+    const: 1
+
+required:
+  - compatible
+  - reg
+  - ranges
+
+# The DFX server may expose clocks described as subnodes
+additionalProperties:
+  type: object
+
+examples:
+  - |
+
+    #define MBUS_ID(target,attributes) (((target) << 24) | ((attributes) << 16))
+    bus@0 {
+        reg = <0 0>;
+        #address-cells = <2>;
+        #size-cells = <1>;
+
+        dfx-bus@ac000000 {
+            compatible = "marvell,dfx-server", "simple-bus";
+            #address-cells = <1>;
+            #size-cells = <1>;
+            ranges = <0 MBUS_ID(0x08, 0x00) 0 0x100000>;
+            reg = <MBUS_ID(0x08, 0x00) 0 0x100000>;
+        };
+    };
diff --git a/Documentation/devicetree/bindings/net/marvell,prestera.txt b/Documentation/devicetree/bindings/net/marvell,prestera.txt
index 83370ebf5b89..8868d774da67 100644
--- a/Documentation/devicetree/bindings/net/marvell,prestera.txt
+++ b/Documentation/devicetree/bindings/net/marvell,prestera.txt
@@ -27,21 +27,3 @@ switch {
 		dfx = <&dfx>;
 	};
 };
-
-DFX Server bindings
--------------------
-
-Required properties:
-- compatible: must be "marvell,dfx-server", "simple-bus"
-- ranges: describes the address mapping of a memory-mapped bus.
-- reg: address and length of the register set for the device.
-
-Example:
-
-dfx-server {
-	compatible = "marvell,dfx-server", "simple-bus";
-	#address-cells = <1>;
-	#size-cells = <1>;
-	ranges = <0 MBUS_ID(0x08, 0x00) 0 0x100000>;
-	reg = <MBUS_ID(0x08, 0x00) 0 0x100000>;
-};
-- 
2.34.1

