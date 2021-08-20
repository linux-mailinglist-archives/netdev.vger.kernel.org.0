Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 226DD3F315F
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 18:15:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbhHTQQY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 12:16:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbhHTQQX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 12:16:23 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63FD4C061575;
        Fri, 20 Aug 2021 09:15:45 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id d16so18127621ljq.4;
        Fri, 20 Aug 2021 09:15:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=R2W3zLfEON5B5SjCNOHj6nt3A7BTwp4MUfhCTRtc9N4=;
        b=bRnyCXR55ZGsR2jNnt+1cn6a3vWpF6UeMC4hi1t5BnEmFbWHoqUNF69En3CWqduUG4
         43LjAhXrlNGRMCdgMCR0qmFXj6vTIXRyS0mShagUGj6cHa4lLeybZGpwAGtt0PUqYUPZ
         4XeWbzA4YKGD0IalovZyJJuy+yUQlymVol+TDNKHBIYFgFkVv3OVudwfWOfl0a5al6sw
         Ad6awGtFmbUl5pqZyNxLvnEJuyG+i5xwIUKW9YhFhzZ4J/CCkEEsbeuhh6WdX0SoiXl4
         mKSUWl6Uh5PdGh2VsFZuzMv3zTY/6gpnSRfay2k2AGJpeZrna5ZA4UTn8dRLiRhOByfh
         BwYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=R2W3zLfEON5B5SjCNOHj6nt3A7BTwp4MUfhCTRtc9N4=;
        b=XZ8OARg59GLqp+RX0bXb1OgGIsRmGFEb80takcuOeXrBOGBeTdTsFb/EOGWffJ6lgQ
         UcmmBYeGbe7umrA7Nui14VyYEylr6al9Q/BUA466O0IAXJCLHt6BKIk002xUEoOp1oZe
         UlQPXIK+u1NVyBZhQKDip5dSOeoxQwabB9ZlzStzRiRexcv8msGkni3PTyIfNHuN/rvO
         fanm42FJB5nFpfDTx3sn2Ip4L+8Td4RnTRMaL8nM86vRY7IbsDbQ+6xULqJAKEGGeEmY
         p01/vREycsovqcdwOkWQSK2erA+ibUO0LvsZbTrjFt2cc6KIbzy51DYfPc7wupFT9mRc
         8Y9A==
X-Gm-Message-State: AOAM533wIju03dD5mEl3op27QqlEkCeagX7gtUpZT/Ktst9Byv7PineP
        YfWNkb/Pesx7WbGLPgG4Lc0=
X-Google-Smtp-Source: ABdhPJy+cWMGZ7saO/rACuVgsZcyPM0jLK1QwXRcsr1B3uISX3HtKZ6lXMUHr0V8MTOjuf8XHIow4Q==
X-Received: by 2002:a2e:2f1c:: with SMTP id v28mr16158640ljv.476.1629476143717;
        Fri, 20 Aug 2021 09:15:43 -0700 (PDT)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id o1sm670183lfl.67.2021.08.20.09.15.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Aug 2021 09:15:43 -0700 (PDT)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH V2] dt-bindings: net: brcm,unimac-mdio: convert to the json-schema
Date:   Fri, 20 Aug 2021 18:15:33 +0200
Message-Id: <20210820161533.20611-1-zajec5@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210819100946.10748-1-zajec5@gmail.com>
References: <20210819100946.10748-1-zajec5@gmail.com>
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

V2: Fix typo: s/Tnterrupt/Interrupt/ - thanks Andrew
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
index 000000000000..f4f4c37f1d4e
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
+          Interrupt shared with the Ethernet MAC or Ethernet switch this MDIO
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

