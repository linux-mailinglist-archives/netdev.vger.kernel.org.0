Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C1334F0C74
	for <lists+netdev@lfdr.de>; Sun,  3 Apr 2022 22:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376422AbiDCUJz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 16:09:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354764AbiDCUJx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 16:09:53 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D54893A1AB;
        Sun,  3 Apr 2022 13:07:58 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id j20-20020a17090ae61400b001ca9553d073so1062622pjy.5;
        Sun, 03 Apr 2022 13:07:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=AFqxTU1E4kaBwWRx5cYewNgahUMR80SylrAckx/+otA=;
        b=WL48zVog8ky6YA3BDWWoNlgjwYsW/HpDEIpT6o4xE+tWsXaS+isFb+G4qsybUGlg2k
         CZbTJWg/Lv2BqFrIDjKvzBsFQ+S9X71QjAsU7uaG+5N+OlVsoVJT+ia0kqTXkVvMerB0
         moqpVaVXtgfYhZeq/BfQ1RJIIx7URxqrHTs980cni91kUjQ/USRiAEaQQPXd6tloVwSO
         biihPEVJUo6WgFYgvzxQazO17NvqHL2Qe04VXDxM2G57xd1XOb3yIqcHwdN8qFKATRh0
         CiQv5db7DIRt3PomAOrP3oxdww9l0h3yLaJxQiH0sRLwN6ZoCZAeLaCahi5oYCgCM+yA
         nGLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=AFqxTU1E4kaBwWRx5cYewNgahUMR80SylrAckx/+otA=;
        b=lRnd4deUqgtBOA+ly+6dgsViDKF1okso42drExTmSKzTlsz9zxm/w+9T5g1tllNrZj
         jhzYYJqJNFT5rbZruYkCl32DO7rQdzVDYlT9s1BocxsrqR1/pjtDEFaD+8xL9fbuymGb
         I5yeL1xjp8MAQWOcVOBdZrdTv2XpFkxV5Se7IDI/Z7fqVtfnjPn8s4XIgIqLfdDKPREB
         nc2ajpgyWJFEjxI60lWEbFGRH5+o8niWKxSk2O0HQg3+jd6s1WYNmvrIPKDLG2FCcR8R
         u0o3C+w2ozYYKA4eZvSyLm2CfXqFr8jpdcLaVPKA9My0j/3YrAhP4drXmnsLBIhzYb0/
         rchA==
X-Gm-Message-State: AOAM531H/Fc5y+GQqrVeBa9ghOYFHjHsAzCn3fDsUXN8kFn2L1XfE8qw
        bZlFRRiNf8uxcpAIwXSF2Vo=
X-Google-Smtp-Source: ABdhPJxpXbo1hGkdsPTyDz8TK1l8q0uUz+xh8qfxHiHHhJqGxj+/F1i6GowNpQATDqdPUscHLj5eAA==
X-Received: by 2002:a17:90b:314b:b0:1c7:4a4f:6740 with SMTP id ip11-20020a17090b314b00b001c74a4f6740mr22803777pjb.145.1649016478254;
        Sun, 03 Apr 2022 13:07:58 -0700 (PDT)
Received: from scdiu3.sunplus.com ([113.196.136.192])
        by smtp.googlemail.com with ESMTPSA id p10-20020a637f4a000000b00373a2760775sm8154660pgn.2.2022.04.03.13.07.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 03 Apr 2022 13:07:58 -0700 (PDT)
From:   Wells Lu <wellslutw@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, p.zabel@pengutronix.de,
        pabeni@redhat.com, krzk+dt@kernel.org, roopa@nvidia.com,
        andrew@lunn.ch, edumazet@google.com
Cc:     wells.lu@sunplus.com, Wells Lu <wellslutw@gmail.com>
Subject: [PATCH net-next v6 1/2] devicetree: bindings: net: Add bindings doc for Sunplus SP7021.
Date:   Mon,  4 Apr 2022 04:07:38 +0800
Message-Id: <1649016459-23989-2-git-send-email-wellslutw@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1649016459-23989-1-git-send-email-wellslutw@gmail.com>
References: <1649016459-23989-1-git-send-email-wellslutw@gmail.com>
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
Changes in v6
  - Removed the second item of 'reg'.
  - Removed 'reg-names'

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
index cf89643..84e8f36 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -18837,6 +18837,13 @@ L:	netdev@vger.kernel.org
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

