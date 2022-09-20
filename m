Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB7F5BE9D2
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 17:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230484AbiITPOU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 11:14:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230344AbiITPOT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 11:14:19 -0400
Received: from smtp2.axis.com (smtp2.axis.com [195.60.68.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA92C58083;
        Tue, 20 Sep 2022 08:14:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; q=dns/txt; s=axis-central1; t=1663686859;
  x=1695222859;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=k3tV7BYNoaMmGkk9sPvJNO+QjiH32hWSnEMAx88EIiE=;
  b=bpbpNyCKTIUbv/eo/P6SA8y4hHd4/Y4XmJ58o7Mu/Z6TPj0fyr3xXL73
   rWZhFVAjQWQRy3ZM/XmudF/yTsAHOAcHyLY49YamO8SRuswuVq5SHmTeD
   zX6U1dtSBJZNV11pn7sMYS1P8+HtJItopzfXItWTTUHlLvxG8MLdWZqDi
   YEQ5tdlLbWuzVzGwkRXUjvu+eYWLCQ+brxXTKozKOlYhIKXHCD/gLY/LJ
   GBqlDdf6KDusarBAu/llMHtdJDkpLUymOuaiyR3osqjgTAVpbFnPFtWS0
   //sr2tYqhus+5n6WXCJqLaZlI8NSRoDbdm8OcWTDBEO9/2b0BRjXQnMrI
   g==;
From:   Marcus Carlberg <marcus.carlberg@axis.com>
To:     <lxu@maxlinear.com>, <andrew@lunn.ch>
CC:     <linux-kernel@vger.kernel.org>, <kernel@axis.com>,
        Marcus Carlberg <marcus.carlberg@axis.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        <devicetree@vger.kernel.org>, Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
Subject: [PATCH net-next 1/2] dt-bindings: net: Add mxl,gpy
Date:   Tue, 20 Sep 2022 17:14:10 +0200
Message-ID: <20220920151411.12523-2-marcus.carlberg@axis.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220920151411.12523-1-marcus.carlberg@axis.com>
References: <20220920151411.12523-1-marcus.carlberg@axis.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add dual-led-mode override property specific to mxl,gpy.

Signed-off-by: Marcus Carlberg <marcus.carlberg@axis.com>
---
 .../devicetree/bindings/net/mxl,gpy.yaml      | 39 +++++++++++++++++++
 .../devicetree/bindings/vendor-prefixes.yaml  |  2 +
 MAINTAINERS                                   |  1 +
 3 files changed, 42 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/mxl,gpy.yaml

diff --git a/Documentation/devicetree/bindings/net/mxl,gpy.yaml b/Documentation/devicetree/bindings/net/mxl,gpy.yaml
new file mode 100644
index 000000000000..423d2a5e1ce9
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/mxl,gpy.yaml
@@ -0,0 +1,39 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/mxl,gpy.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Maxlinear Phy
+
+maintainers:
+  - Xu Liang <lxu@maxlinear.com>
+
+allOf:
+  - $ref: ethernet-phy.yaml#
+
+properties:
+  mxl,dual-led-mode:
+    $ref: /schemas/types.yaml#/definitions/flag
+    description:
+      If set, indicates that the hardware only have connected pins led0 and
+      led1 where led0 is used for noting the highest network speed (2500) and
+      led1 for the rest (10, 100, 1000). The absence of this property
+      indicates that the PHY uses all four led pins to communicate link speed,
+      one pin for each speed.
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    ethernet {
+        #address-cells = <1>;
+        #size-cells = <0>;
+
+        ethernet-phy@0 {
+            compatible = "ethernet-phy-id67c9.de10", "ethernet-phy-ieee802.3-c45";
+            reg = <0>;
+            mxl,dual-led-mode;
+        };
+    };
+
diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index 2f0151e9f6be..3c833827a790 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -757,6 +757,8 @@ patternProperties:
     description: MaxBotix Inc.
   "^maxim,.*":
     description: Maxim Integrated Products
+  "^mxl,.*":
+    description: Maxlinear Inc.
   "^mbvl,.*":
     description: Mobiveil Inc.
   "^mcube,.*":
diff --git a/MAINTAINERS b/MAINTAINERS
index 9ae989b32ebb..accc4242c027 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12455,6 +12455,7 @@ MAXLINEAR ETHERNET PHY DRIVER
 M:	Xu Liang <lxu@maxlinear.com>
 L:	netdev@vger.kernel.org
 S:	Supported
+F:	Documentation/devicetree/bindings/net/phy/mxl,gpy.yaml
 F:	drivers/net/phy/mxl-gpy.c

 MCBA MICROCHIP CAN BUS ANALYZER TOOL DRIVER
--
2.20.1

