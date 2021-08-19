Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9606D3F171C
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 12:11:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237889AbhHSKLm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 06:11:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236149AbhHSKLj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 06:11:39 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C7AAC061575;
        Thu, 19 Aug 2021 03:11:03 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id s3so10554738ljp.11;
        Thu, 19 Aug 2021 03:11:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hRcUw4A9JUOH9E/HZUrcJBrNnU77uugOHMYye5z2kPk=;
        b=oCgEXdoXT9js2xbiSTtP4LSKSH73+WdhaGoN3jjqgCDPNABybapX2RyG7W5BQZqdQ2
         q2BeqynbMafnevVJxxhODBLUQkcb3mE/U+IEDskdRr/BJyf8l7oyg/5J51RzwtD0QF9/
         /EnAQaIN5HGCFGsF6YHFwKtGH9vXI4OV18N75ZC1YdHXLnBYU269gcdYiT9MVNop25dX
         HgUvV1GUHErFCQThXk3D/muI2t4kt16U384fnBs5eOBqXczF0ArJLQvYm+NiVcVFPYPd
         cYtyuhhFBd6IDuY1BHqi68xftmXH3MDFV1jMSSatpne8gxK7VyxFRtd1yzdyZkaOSAkC
         h5yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hRcUw4A9JUOH9E/HZUrcJBrNnU77uugOHMYye5z2kPk=;
        b=DsL+UWkfnPaq3OeQykW4SE2AMz2eDzFVNmM+Tb+rtPEgbgqP1h1IzhIDx9Eaj8/yx3
         MV0GCTf2rR1ly/wAFxbiGArvVlkp/eI/Dl8ozDt2o2+ygqJdYHfvuc2SkSDxCM9J0Szg
         OHgLe6tGRpQd1NuJiI4b0YqxKqx7rVaGoT/SzEipHnL14O6+YqRMgQwISlCcDJCSdBLl
         6w0a+5G6FpE4fmMUApyHZ4EKbbuA5c3oE7ZLyc/NXtIJBd0UiEoVwopIbpBaKg2LoUue
         2eW8KC8Jr8UIijF8sScP7pBYoABsIW+Xn35cAmm9Bv8fKDwEpgV2oPj+aYtLzg7Yzo8R
         uN7A==
X-Gm-Message-State: AOAM532XUY/5sfSPPxIL9PbIRR2zbK/JwKCQZFl2kBgmPoO0UU4hYJZ8
        QaL7W0ikIg0lzzZ9/Y5uMCs=
X-Google-Smtp-Source: ABdhPJxhUgrY6cH0QDAknulavT6meRRprK+lfWsK0LPtnelokx10o9uM0goqC06AuFmVnrcCU16Vng==
X-Received: by 2002:a2e:a5c8:: with SMTP id n8mr11243328ljp.317.1629367861963;
        Thu, 19 Aug 2021 03:11:01 -0700 (PDT)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id f16sm221595ljq.58.2021.08.19.03.11.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 03:11:01 -0700 (PDT)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH] dt-bindings: net: brcm,unimac-mdio: convert to the json-schema
Date:   Thu, 19 Aug 2021 12:09:46 +0200
Message-Id: <20210819100946.10748-1-zajec5@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

This helps validating DTS files.

Introduced example binding changes:
1. Fixed reg formatting
2. Swapped #address-cells and #size-cells incorrect values
3. Renamed node: s/phy/ethernet-phy/

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
I've verified this new binding using:
make dt_binding_check DT_SCHEMA_FILES=Documentation/devicetree/bindings/net/brcm,unimac-mdio.yaml
---
 .../bindings/net/brcm,unimac-mdio.txt         | 43 ----------
 .../bindings/net/brcm,unimac-mdio.yaml        | 84 +++++++++++++++++++
 2 files changed, 84 insertions(+), 43 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/brcm,unimac-mdio.txt
 create mode 100644 Documentation/devicetree/bindings/net/brcm,unimac-mdio.yaml

diff --git a/Documentation/devicetree/bindings/net/brcm,unimac-mdio.txt b/Documentation/devicetree/bindings/net/brcm,unimac-mdio.txt
deleted file mode 100644
index e15589f47787..000000000000
--- a/Documentation/devicetree/bindings/net/brcm,unimac-mdio.txt
+++ /dev/null
@@ -1,43 +0,0 @@
-* Broadcom UniMAC MDIO bus controller
-
-Required properties:
-- compatible: should one from "brcm,genet-mdio-v1", "brcm,genet-mdio-v2",
-  "brcm,genet-mdio-v3", "brcm,genet-mdio-v4", "brcm,genet-mdio-v5" or
-  "brcm,unimac-mdio"
-- reg: address and length of the register set for the device, first one is the
-  base register, and the second one is optional and for indirect accesses to
-  larger than 16-bits MDIO transactions
-- reg-names: name(s) of the register must be "mdio" and optional "mdio_indir_rw"
-- #size-cells: must be 1
-- #address-cells: must be 0
-
-Optional properties:
-- interrupts: must be one if the interrupt is shared with the Ethernet MAC or
-  Ethernet switch this MDIO block is integrated from, or must be two, if there
-  are two separate interrupts, first one must be "mdio done" and second must be
-  for "mdio error"
-- interrupt-names: must be "mdio_done_error" when there is a share interrupt fed
-  to this hardware block, or must be "mdio_done" for the first interrupt and
-  "mdio_error" for the second when there are separate interrupts
-- clocks: A reference to the clock supplying the MDIO bus controller
-- clock-frequency: the MDIO bus clock that must be output by the MDIO bus
-  hardware, if absent, the default hardware values are used
-
-Child nodes of this MDIO bus controller node are standard Ethernet PHY device
-nodes as described in Documentation/devicetree/bindings/net/phy.txt
-
-Example:
-
-mdio@403c0 {
-	compatible = "brcm,unimac-mdio";
-	reg = <0x403c0 0x8 0x40300 0x18>;
-	reg-names = "mdio", "mdio_indir_rw";
-	#size-cells = <1>;
-	#address-cells = <0>;
-
-	...
-	phy@0 {
-		compatible = "ethernet-phy-ieee802.3-c22";
-		reg = <0>;
-	};
-};
diff --git a/Documentation/devicetree/bindings/net/brcm,unimac-mdio.yaml b/Documentation/devicetree/bindings/net/brcm,unimac-mdio.yaml
new file mode 100644
index 000000000000..ffc1ee99613e
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/brcm,unimac-mdio.yaml
@@ -0,0 +1,84 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/brcm,unimac-mdio.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Broadcom UniMAC MDIO bus controller
+
+maintainers:
+  - Rafał Miłecki <rafal@milecki.pl>
+
+allOf:
+  - $ref: mdio.yaml#
+
+properties:
+  compatible:
+    enum:
+      - brcm,genet-mdio-v1
+      - brcm,genet-mdio-v2
+      - brcm,genet-mdio-v3
+      - brcm,genet-mdio-v4
+      - brcm,genet-mdio-v5
+      - brcm,unimac-mdio
+
+  reg:
+    minItems: 1
+    items:
+      - description: base register
+      - description: indirect accesses to larger than 16-bits MDIO transactions
+
+  reg-names:
+    minItems: 1
+    items:
+      - const: mdio
+      - const: mdio_indir_rw
+
+  interrupts:
+    oneOf:
+      - description: >
+          Tnterrupt shared with the Ethernet MAC or Ethernet switch this MDIO
+          block is integrated from
+      - items:
+          - description: |
+              "mdio done" interrupt
+          - description: |
+              "mdio error" interrupt
+
+  interrupt-names:
+    oneOf:
+      - const: mdio_done_error
+      - items:
+          - const: mdio_done
+          - const: mdio_error
+
+  clocks:
+    description: A reference to the clock supplying the MDIO bus controller
+
+  clock-frequency:
+    description: >
+      The MDIO bus clock that must be output by the MDIO bus hardware, if
+      absent, the default hardware values are used
+
+unevaluatedProperties: false
+
+required:
+  - reg
+  - reg-names
+  - '#address-cells'
+  - '#size-cells'
+
+examples:
+  - |
+    mdio@403c0 {
+        compatible = "brcm,unimac-mdio";
+        reg = <0x403c0 0x8>, <0x40300 0x18>;
+        reg-names = "mdio", "mdio_indir_rw";
+        #address-cells = <1>;
+        #size-cells = <0>;
+
+        ethernet-phy@0 {
+            compatible = "ethernet-phy-ieee802.3-c22";
+            reg = <0>;
+        };
+    };
-- 
2.26.2

