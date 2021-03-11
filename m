Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1197F33698C
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 02:21:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbhCKBUp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 20:20:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbhCKBUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 20:20:19 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20EDAC061574;
        Wed, 10 Mar 2021 17:20:19 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id 7so25455386wrz.0;
        Wed, 10 Mar 2021 17:20:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ehVRDxcjYT4kjvF6VjL17bBzgNtlONIBkFhsI3t47oA=;
        b=Vki/R/Lh7cSFAWKC5hIOGi/ouxV7t9bTTJeBzainn6CrAq7GxXDeBG4wwgLll9fpU7
         5WWMagtE4Y9LHHrgLdmsvZTikxIAue119E6Lt1CxJFN2c6s2/nTgLxVMk5V9Bx0nDtzV
         cTVfK7uVe4S/8tJ8zTrbCrmtki8WOYLn7hM5jabUZE6YOZbtqdkTJFZ6orYznCjblDqz
         Ha2PNTxTHG9p6NH0QJC8iFu5abpXYCTFWbadXiaQZLfrcX4Q/t6JMkZ0nSwk4+d3lvoX
         Cm2v/uNz70MXwix7BRBWc22NmZ9siQIrC2ps225Heq3QU7ESeAGeWe3mcynm72LPRP3J
         PH1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ehVRDxcjYT4kjvF6VjL17bBzgNtlONIBkFhsI3t47oA=;
        b=i/1zwq4yLpnrWBRyrprtl1Mam4/zUTG5hoUpeUt4i9aGacah/dts6uAIfQ5C2CQBEE
         /pLKyhmXEPDbDlk+H59GMqITkBR4f8k25Jg0rBTQn6+Bg1cEo8bh0fIHBq+QOlj/EBhp
         u7YWURm7Q/uqOEGPPEr9xDRl234SoOqK3RxDaGesgaLT0ahGgrwdC4T23IL2ulhyEs3B
         XfUhNvMzJvZtzSsEILKgmbfTfUTwDmRJcsB+jaOEF4ZPnn7DFaVbQ1exsw7ltGvZoCYG
         Vs/+L0Uok75yeHxjC++asU4ZQkcPVAsKlDACmSID1QH4k81BMl7w9gKfyZk1OMeKO6I5
         Uaog==
X-Gm-Message-State: AOAM533WlsYiZ0J9EUWW4IB8bDhDb6uw9O/c4ZxabOJG81PUqDNC7hWq
        U2Z5l/AAa+jgLWb1yqSZfLnSmshrAag=
X-Google-Smtp-Source: ABdhPJwuRoBpRkgCLg64hcecjmH2Le0uQ45Gzfj/RUDRoJW1GcMad/osCgjjX5Aq7fO9CbWkIi3yNg==
X-Received: by 2002:adf:f78f:: with SMTP id q15mr5915748wrp.383.1615425617903;
        Wed, 10 Mar 2021 17:20:17 -0800 (PST)
Received: from localhost.localdomain ([81.18.95.223])
        by smtp.gmail.com with ESMTPSA id d85sm1199127wmd.15.2021.03.10.17.20.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 17:20:17 -0800 (PST)
From:   Cristian Ciocaltea <cristian.ciocaltea@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-actions@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] dt-bindings: net: Add Actions Semi Owl Ethernet MAC binding
Date:   Thu, 11 Mar 2021 03:20:12 +0200
Message-Id: <cc79f78c9e685474491b3d65be8a4e0be4bf3778.1615423279.git.cristian.ciocaltea@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1615423279.git.cristian.ciocaltea@gmail.com>
References: <cover.1615423279.git.cristian.ciocaltea@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add devicetree binding for the Ethernet MAC present on the Actions
Semi Owl family of SoCs.

For the moment enable only the support for the Actions Semi S500 SoC
variant.

Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@gmail.com>
---
 .../bindings/net/actions,owl-emac.yaml        | 91 +++++++++++++++++++
 1 file changed, 91 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/actions,owl-emac.yaml

diff --git a/Documentation/devicetree/bindings/net/actions,owl-emac.yaml b/Documentation/devicetree/bindings/net/actions,owl-emac.yaml
new file mode 100644
index 000000000000..d5a0da0d20bc
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/actions,owl-emac.yaml
@@ -0,0 +1,91 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/actions,owl-emac.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Actions Semi Owl SoCs Ethernet MAC Controller
+
+maintainers:
+  - Cristian Ciocaltea <cristian.ciocaltea@gmail.com>
+
+description: |
+  This Ethernet MAC is used on the Owl family of SoCs from Actions Semi.
+  It is compliant with the IEEE 802.3 CSMA/CD standard and supports both
+  half-duplex and full-duplex operation modes at 10/100 Mb/s.
+
+allOf:
+  - $ref: "ethernet-controller.yaml#"
+
+properties:
+  compatible:
+    oneOf:
+      - const: actions,owl-emac
+      - items:
+          - enum:
+              - actions,s500-emac
+          - const: actions,owl-emac
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    maxItems: 1
+
+  clocks:
+    minItems: 2
+    maxItems: 2
+
+  clock-names:
+    additionalItems: false
+    items:
+      - const: eth
+      - const: rmii
+
+  resets:
+    maxItems: 1
+
+  actions,ethcfg:
+    $ref: /schemas/types.yaml#/definitions/phandle
+    description:
+      Phandle to the device containing custom config.
+
+required:
+  - compatible
+  - reg
+  - interrupts
+  - clocks
+  - clock-names
+  - resets
+  - phy-mode
+  - phy-handle
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/clock/actions,s500-cmu.h>
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+    #include <dt-bindings/reset/actions,s500-reset.h>
+
+    ethernet@b0310000 {
+        compatible = "actions,s500-emac", "actions,owl-emac";
+        reg = <0xb0310000 0x10000>;
+        interrupts = <GIC_SPI 0 IRQ_TYPE_LEVEL_HIGH>;
+        clocks = <&cmu 59 /*CLK_ETHERNET*/>, <&cmu CLK_RMII_REF>;
+        clock-names = "eth", "rmii";
+        resets = <&cmu RESET_ETHERNET>;
+        phy-handle = <&eth_phy>;
+        phy-mode = "rmii";
+
+        mdio {
+            #address-cells = <1>;
+            #size-cells = <0>;
+
+            eth_phy: ethernet-phy@3 {
+                reg = <0x3>;
+                interrupt-parent = <&sirq>;
+                interrupts = <0 IRQ_TYPE_LEVEL_LOW>;
+            };
+        };
+    };
-- 
2.30.2

