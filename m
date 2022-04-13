Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94B314FECF0
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 04:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231698AbiDMCed (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 22:34:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbiDMCeb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 22:34:31 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 288E627CD7;
        Tue, 12 Apr 2022 19:32:11 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id q19so482938pgm.6;
        Tue, 12 Apr 2022 19:32:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=cWiDTxPWXtJvNGSaGQVi3ZjY/HAbUitpn0w87jsYEX8=;
        b=E1+vA5lY1KjCu1jqN2dFs06LxGSTGv/qAAhNTR2A/NUeuL7NkiCiwTjMKx9gAdlU0B
         wUmx3KdNwHAuAnErmFveWCm8307MXxqQng10aEai/xTYofIN0foT55/rnHKNoc8b7Jrz
         /0h435AinW0HRds51gSWzCqIvst617fh6vbw/frc7tU+k+se9lbvjUo6uQqtXjky5m3z
         Dh43Enz2G5mDrhQ2PH4rBrQ0J5E9AP3+dc0jDpSSam8E1xWIXOc2JyNLvRKF0u+serwh
         /XCCyTBLEjZNZYhQsbZiQUboK7C6nfdbNXliVj/SuRJTLVE1SZIt9/OHUaJdHgYBCWpg
         7LEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=cWiDTxPWXtJvNGSaGQVi3ZjY/HAbUitpn0w87jsYEX8=;
        b=irLy8rLDz20cwUYdUvBminLx1Lyfh682R7Es/1liDkZhqIaeo7ifWtm+jvzPZm6lzf
         etsVa0HkgbjhvCx+RcUuKKUJLL/lc0zaKjTDpn+esE/PnXs918D9RLpDdpZCidBzbESE
         mKKJcE50Mznk1WXLhqe3VYzqfDKGWvTGa3zo7q1/p1nnGC1w+/HJy5d2BUl2oxlLwpOK
         lrIedVZvuulv15EXWYIb6S6yK8XNal0F7BgVGtIipduPg2PuInTKkodtSQSagAjKla7d
         KR67LuMuumOsUYl8GLDqELhlcDEDkNgFgn/c4+RpsL8oCYPsQKRNPmV5uCtZKZbYsSrN
         em5w==
X-Gm-Message-State: AOAM530mUE77U89YtSrr7/gyw1DVE77gJH7lITAevmKKV8APRakxNMWW
        59rNFa92rEoqLvKUXQwKpoY=
X-Google-Smtp-Source: ABdhPJz7IwQyXLP8c86uqVhmbUp9qWmxnRToLl9aXHDX8Fb/fOwk+zyrcnHuGys1H32NMHCRFTc8oA==
X-Received: by 2002:a63:24d:0:b0:380:ada1:cd4b with SMTP id 74-20020a63024d000000b00380ada1cd4bmr33351477pgc.127.1649817130665;
        Tue, 12 Apr 2022 19:32:10 -0700 (PDT)
Received: from scdiu3.sunplus.com ([113.196.136.192])
        by smtp.googlemail.com with ESMTPSA id q28-20020a656a9c000000b00372f7ecfcecsm4255943pgu.37.2022.04.12.19.32.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Apr 2022 19:32:10 -0700 (PDT)
From:   Wells Lu <wellslutw@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, p.zabel@pengutronix.de,
        pabeni@redhat.com, krzk+dt@kernel.org, roopa@nvidia.com,
        andrew@lunn.ch, edumazet@google.com
Cc:     wells.lu@sunplus.com, Wells Lu <wellslutw@gmail.com>
Subject: [PATCH net-next v8 1/2] devicetree: bindings: net: Add bindings doc for Sunplus SP7021.
Date:   Wed, 13 Apr 2022 10:31:57 +0800
Message-Id: <1649817118-14667-2-git-send-email-wellslutw@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1649817118-14667-1-git-send-email-wellslutw@gmail.com>
References: <1649817118-14667-1-git-send-email-wellslutw@gmail.com>
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
Changes in v8
  - None

 .../bindings/net/sunplus,sp7021-emac.yaml          | 140 +++++++++++++++++++++
 MAINTAINERS                                        |   7 ++
 2 files changed, 147 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/sunplus,sp7021-emac.yaml

diff --git a/Documentation/devicetree/bindings/net/sunplus,sp7021-emac.yaml b/Documentation/devicetree/bindings/net/sunplus,sp7021-emac.yaml
new file mode 100644
index 0000000..6dc15cd
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/sunplus,sp7021-emac.yaml
@@ -0,0 +1,140 @@
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
index fd768d4..1d54292 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -18869,6 +18869,13 @@ L:	netdev@vger.kernel.org
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

