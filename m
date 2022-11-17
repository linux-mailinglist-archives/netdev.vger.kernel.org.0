Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44C8562E761
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 22:56:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240977AbiKQV4N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 16:56:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240954AbiKQV4I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 16:56:08 -0500
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [217.70.183.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CEF36D48A;
        Thu, 17 Nov 2022 13:56:07 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id A580A1C0008;
        Thu, 17 Nov 2022 21:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1668722166;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ax0tNqoYutdKrIUuwqnf5IT6Ev2gIDY96QxRhHlvipw=;
        b=e4cTCixnOAi104+PoXmpHttdVUikNISxuJ/Uq41VOiMMQdgGuHW28PDgbvu1ZdW42eNMiX
        l+iA8x4YwYI4Io1tRxbaC+t9cJBPg8sAm9AQ+lkumc+uqRhMA7SPhpK8uFMFOwlfJI6KMj
        nTDePALFSCXqJSMCY5SCAxFzpUpqfVnD5208NyexV2iwAj76HxvN5AA6vooPg5JMo05b04
        pkqt5tlmpjZULqnXmqGVW+hq+Z2m+kqvZFfzI9b46Ys69S0dF9oIAU5fpldqPi1vJfA0y8
        y0fQZ+ItghMgGtq2NuNWN9ymhvXrM8+43jAi8ADZp/R4dNjouD1qGNpzliD9gg==
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
Subject: [PATCH 3/6] dt-bindings: net: marvell,prestera: Convert to yaml
Date:   Thu, 17 Nov 2022 22:55:54 +0100
Message-Id: <20221117215557.1277033-4-miquel.raynal@bootlin.com>
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

The currently described switch family is named AlleyCat3, it is a memory
mapped switch found on Armada XP boards.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
This patch (and the original txt file) can also be dropped if judged not
worth the conversion as anyway in both cases there is no driver upstream
for these devices.
---
 .../bindings/net/marvell,prestera.txt         | 29 ------------
 .../bindings/net/marvell,prestera.yaml        | 45 +++++++++++++++++++
 2 files changed, 45 insertions(+), 29 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/marvell,prestera.txt
 create mode 100644 Documentation/devicetree/bindings/net/marvell,prestera.yaml

diff --git a/Documentation/devicetree/bindings/net/marvell,prestera.txt b/Documentation/devicetree/bindings/net/marvell,prestera.txt
deleted file mode 100644
index 8868d774da67..000000000000
--- a/Documentation/devicetree/bindings/net/marvell,prestera.txt
+++ /dev/null
@@ -1,29 +0,0 @@
-Marvell Prestera Switch Chip bindings
--------------------------------------
-
-Required properties:
-- compatible: must be "marvell,prestera" and one of the following
-	"marvell,prestera-98dx3236",
-	"marvell,prestera-98dx3336",
-	"marvell,prestera-98dx4251",
-- reg: address and length of the register set for the device.
-- interrupts: interrupt for the device
-
-Optional properties:
-- dfx: phandle reference to the "DFX Server" node
-
-Example:
-
-switch {
-	compatible = "simple-bus";
-	#address-cells = <1>;
-	#size-cells = <1>;
-	ranges = <0 MBUS_ID(0x03, 0x00) 0 0x100000>;
-
-	packet-processor@0 {
-		compatible = "marvell,prestera-98dx3236", "marvell,prestera";
-		reg = <0 0x4000000>;
-		interrupts = <33>, <34>, <35>;
-		dfx = <&dfx>;
-	};
-};
diff --git a/Documentation/devicetree/bindings/net/marvell,prestera.yaml b/Documentation/devicetree/bindings/net/marvell,prestera.yaml
new file mode 100644
index 000000000000..b0a3ecca406e
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/marvell,prestera.yaml
@@ -0,0 +1,45 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/marvell,prestera.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Marvell Prestera AlleyCat3 switch
+
+maintainers:
+  - Miquel Raynal <miquel.raynal@bootlin.com>
+
+properties:
+  compatible:
+    items:
+      - enum:
+          - marvell,prestera-98dx3236
+          - marvell,prestera-98dx3336
+          - marvell,prestera-98dx4251
+      - const: marvell,prestera
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    maxItems: 3
+
+  dfx:
+    description: Reference to the DFX Server bus node.
+    $ref: /schemas/types.yaml#/definitions/phandle
+
+required:
+  - compatible
+  - reg
+  - interrupts
+
+additionalProperties: false
+
+examples:
+  - |
+    packet-processor@0 {
+        compatible = "marvell,prestera-98dx3236", "marvell,prestera";
+        reg = <0 0x4000000>;
+        interrupts = <33>, <34>, <35>;
+        dfx = <&dfx>;
+    };
-- 
2.34.1

