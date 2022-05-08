Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B64451ECD5
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 12:13:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230405AbiEHKRa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 06:17:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230328AbiEHKRZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 06:17:25 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAA8FBF69;
        Sun,  8 May 2022 03:13:34 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id c14so9919209pfn.2;
        Sun, 08 May 2022 03:13:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=N0vLdQJC2iM6p5/E3+l3sjmXIFLEk3/c9HAP285Q4AY=;
        b=jCXxMNzGMXzO5yN8ZjRJ2aoUOjAdPIhVxUX5jBV4Se84JsLfPw78t3X0P/dOCFnyYg
         q3pdLDka/UN2z2G3vjDv/STs/nFUWDoI6MwbqxrrSvXSzQZHnRwz5FRpsm39sgIufHuO
         lwaWnbisD5TVoEtHT4YPI3uI1NQwU81JycgaoxSTCiaVi1yXBED48W8e8GIe70VJzv5I
         s2+MYem0vXOe0pPmEjpTcrn+dZzWcu0APg1uYwPdFFBrbPPwCvLrktQ9+E2VgTpdTGLP
         GAAXEJgNRhgjyKKy/hVFBGxDjTz4cRJkPwrrta1RqROG76denUGT9tQB3wM9tM+Pu9je
         jZ0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=N0vLdQJC2iM6p5/E3+l3sjmXIFLEk3/c9HAP285Q4AY=;
        b=w9W8AmH47UyHtr+PyVjFLnGkZUZGzR/ILE8BlAO9J2rrGxmf2jJ7s66ERPucbL/Z1C
         YEFYAWa4QjDbG8jNTWJc+0108NHJfEuM7D7W64s8wq34nJ9gq7oceSddAFI9ez0fA2W9
         U1CEggbRkGVeoSKrjPbSyJjnpm2yRWqsSgm+L9/xhUyXInZo1TZkaaGpT7ro7BinF3Ni
         Q7y/4PULmY17EmanyyRuwfrhjTg4Vz5qn5P5IyMf+UqAVPJ/oEt74eQgCKTeef0Uehwl
         bO38qUDw24eiTqZsnLOmZzjg1p6S9lCskMwGFET8Gtdbi4DwMDTfPu6VWFaLyfNU/TwI
         avng==
X-Gm-Message-State: AOAM533XwwKZwqH1tm/tUA5wgrQJGqZ3wJV+kutaZnftB3gxtIeoq53V
        DTTiG8NnhkQUeScbOaLDCYQ=
X-Google-Smtp-Source: ABdhPJzwFfaxb/3IMiYZFV+5Kr6fhMZh/8dmS5o8IC0FHjvY73xpL+7wsfFMPfH14wX8BXQmmLFKzw==
X-Received: by 2002:a63:3206:0:b0:3c2:8205:1e00 with SMTP id y6-20020a633206000000b003c282051e00mr9126081pgy.242.1652004814465;
        Sun, 08 May 2022 03:13:34 -0700 (PDT)
Received: from scdiu3.sunplus.com ([113.196.136.192])
        by smtp.googlemail.com with ESMTPSA id y2-20020a17090322c200b0015e8d4eb1f6sm4969610plg.64.2022.05.08.03.13.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 08 May 2022 03:13:34 -0700 (PDT)
From:   Wells Lu <wellslutw@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, p.zabel@pengutronix.de,
        pabeni@redhat.com, krzk+dt@kernel.org, roopa@nvidia.com,
        andrew@lunn.ch, edumazet@google.com
Cc:     wells.lu@sunplus.com, Wells Lu <wellslutw@gmail.com>
Subject: [PATCH net-next v11 1/2] devicetree: bindings: net: Add bindings doc for Sunplus SP7021.
Date:   Sun,  8 May 2022 18:13:19 +0800
Message-Id: <1652004800-3212-2-git-send-email-wellslutw@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1652004800-3212-1-git-send-email-wellslutw@gmail.com>
References: <1652004800-3212-1-git-send-email-wellslutw@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add bindings documentation for Sunplus SP7021 SoC.

Reviewed-by: Rob Herring <robh@kernel.org>
Signed-off-by: Wells Lu <wellslutw@gmail.com>
---
Changes in v11
  - None

 .../bindings/net/sunplus,sp7021-emac.yaml          | 141 +++++++++++++++++++++
 MAINTAINERS                                        |   7 +
 2 files changed, 148 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/sunplus,sp7021-emac.yaml

diff --git a/Documentation/devicetree/bindings/net/sunplus,sp7021-emac.yaml b/Documentation/devicetree/bindings/net/sunplus,sp7021-emac.yaml
new file mode 100644
index 0000000..62dffee
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/sunplus,sp7021-emac.yaml
@@ -0,0 +1,141 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+# Copyright (C) Sunplus Co., Ltd. 2021
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/sunplus,sp7021-emac.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Sunplus SP7021 Dual Ethernet MAC Device Tree Bindings
+
+maintainers:
+  - Wells Lu <wellslutw@gmail.com>
+
+description: |
+  Sunplus SP7021 dual 10M/100M Ethernet MAC controller.
+  Device node of the controller has following properties.
+
+properties:
+  compatible:
+    const: sunplus,sp7021-emac
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    maxItems: 1
+
+  clocks:
+    maxItems: 1
+
+  resets:
+    maxItems: 1
+
+  ethernet-ports:
+    type: object
+    description: Ethernet ports to PHY
+
+    properties:
+      "#address-cells":
+        const: 1
+
+      "#size-cells":
+        const: 0
+
+    patternProperties:
+      "^port@[0-1]$":
+        type: object
+        description: Port to PHY
+
+        properties:
+          reg:
+            minimum: 0
+            maximum: 1
+
+          phy-handle:
+            maxItems: 1
+
+          phy-mode:
+            maxItems: 1
+
+          nvmem-cells:
+            items:
+              - description: nvmem cell address of MAC address
+
+          nvmem-cell-names:
+            description: names corresponding to the nvmem cells
+            items:
+              - const: mac-address
+
+        required:
+          - reg
+          - phy-handle
+          - phy-mode
+          - nvmem-cells
+          - nvmem-cell-names
+
+  mdio:
+    $ref: mdio.yaml#
+    unevaluatedProperties: false
+
+additionalProperties: false
+
+required:
+  - compatible
+  - reg
+  - interrupts
+  - clocks
+  - resets
+  - pinctrl-0
+  - pinctrl-names
+  - ethernet-ports
+  - mdio
+
+examples:
+  - |
+    #include <dt-bindings/interrupt-controller/irq.h>
+
+    ethernet@9c108000 {
+        compatible = "sunplus,sp7021-emac";
+        reg = <0x9c108000 0x400>;
+        interrupt-parent = <&intc>;
+        interrupts = <66 IRQ_TYPE_LEVEL_HIGH>;
+        clocks = <&clkc 0xa7>;
+        resets = <&rstc 0x97>;
+        pinctrl-0 = <&emac_demo_board_v3_pins>;
+        pinctrl-names = "default";
+
+        ethernet-ports {
+            #address-cells = <1>;
+            #size-cells = <0>;
+
+            port@0 {
+                reg = <0>;
+                phy-handle = <&eth_phy0>;
+                phy-mode = "rmii";
+                nvmem-cells = <&mac_addr0>;
+                nvmem-cell-names = "mac-address";
+            };
+
+            port@1 {
+                reg = <1>;
+                phy-handle = <&eth_phy1>;
+                phy-mode = "rmii";
+                nvmem-cells = <&mac_addr1>;
+                nvmem-cell-names = "mac-address";
+            };
+        };
+
+        mdio {
+            #address-cells = <1>;
+            #size-cells = <0>;
+
+            eth_phy0: ethernet-phy@0 {
+                reg = <0>;
+            };
+
+            eth_phy1: ethernet-phy@1 {
+                reg = <1>;
+            };
+        };
+    };
+...
diff --git a/MAINTAINERS b/MAINTAINERS
index cbf21e1..9473062 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -18897,6 +18897,13 @@ L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/ethernet/dlink/sundance.c
 
+SUNPLUS ETHERNET DRIVER
+M:	Wells Lu <wellslutw@gmail.com>
+L:	netdev@vger.kernel.org
+S:	Maintained
+W:	https://sunplus.atlassian.net/wiki/spaces/doc/overview
+F:	Documentation/devicetree/bindings/net/sunplus,sp7021-emac.yaml
+
 SUNPLUS OCOTP DRIVER
 M:	Vincent Shih <vincent.sunplus@gmail.com>
 S:	Maintained
-- 
2.7.4

