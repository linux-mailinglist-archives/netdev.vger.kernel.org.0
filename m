Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7DCB62E759
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 22:56:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240940AbiKQV4I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 16:56:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240924AbiKQV4H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 16:56:07 -0500
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [217.70.183.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C322A701B1;
        Thu, 17 Nov 2022 13:56:05 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id D65FA1C0004;
        Thu, 17 Nov 2022 21:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1668722164;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BfPYpwFw+JIzja3Q3OeYl2Qetdc/wSXMPCm2N01jyAk=;
        b=TifaughFUXInS7qkNbiXMv18rofUv4SYpxL7Pj8hC2vlwvyLmqCN/uZiPILci0evs8FmZ3
        wrf4PVVRfI6mVHhaaUgk6O3W4ulqebmqohn9xCr2KJjA1GrPqemj57I+iljPhw3fUE4Dg2
        bJetUUKSPMWfPyVAHQWbYRVz2qF24jkb3aBrq3xhOy40rzdRiOhcuUIZu8uZPsbDGNBaRJ
        ff4R5czcHFiTDnuJSB2iLKVJyIs/oEHXd/0ZEkIhYtnlQwdMT9tbH0FGcqCqy8Mox+VyXj
        0EtW/sOHUQAuEeqrM4CNdPSJ82m2eX4b0mSOsBeV30nONmQD8+3Kj50OacSUEg==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        devicetree@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org
Cc:     Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        Taras Chornyi <tchornyi@marvell.com>,
        <linux-kernel@vger.kernel.org>,
        Robert Marko <robert.marko@sartura.hr>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Michael Walle <michael@walle.cc>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 2/6] dt-bindings: net: marvell,dfx-server: Convert to yaml
Date:   Thu, 17 Nov 2022 22:55:53 +0100
Message-Id: <20221117215557.1277033-3-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221117215557.1277033-1-miquel.raynal@bootlin.com>
References: <20221117215557.1277033-1-miquel.raynal@bootlin.com>
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
I am fine dropping this file entirely as well, if judged useless.
---
 .../bindings/net/marvell,dfx-server.yaml      | 60 +++++++++++++++++++
 .../bindings/net/marvell,prestera.txt         | 18 ------
 2 files changed, 60 insertions(+), 18 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/marvell,dfx-server.yaml

diff --git a/Documentation/devicetree/bindings/net/marvell,dfx-server.yaml b/Documentation/devicetree/bindings/net/marvell,dfx-server.yaml
new file mode 100644
index 000000000000..72151a78396f
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/marvell,dfx-server.yaml
@@ -0,0 +1,60 @@
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
+  reg: true
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
+additionalProperties: true
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

