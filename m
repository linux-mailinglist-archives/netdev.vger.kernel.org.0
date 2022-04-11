Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 188754FC2F5
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 19:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348775AbiDKRN5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 13:13:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348771AbiDKRNz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 13:13:55 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81A8224591;
        Mon, 11 Apr 2022 10:11:41 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id md4so7585469pjb.4;
        Mon, 11 Apr 2022 10:11:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=lwumo4OognSssz63QX+fR2s8f7HjOZfG/NuRBmw6cy0=;
        b=cOozpkyOoOt1CoNh1Jomb+cWt+MwWMsw5nx63TjAFF0dSw3g+XN7EMxEqt+6c4VKNU
         nwxyq3WY8NTNryGB+X44vJXruXyBVM7udb6XJHbaDWJpAL2jwPw1lF1FQaRbB6J1xOLz
         UqBg2LROd5nItX0sYUuRlN+/X+bWoFi9GzhjDWZj/foj/QC4X673Vbq5fBqo14ms2nMX
         pPL3mVcDWAcMR4OQnXfME7wMS57Qw8cvbD5iRXRTpDxwwQxOWuReZyO371RhlNpj4wxp
         QMKiFKa4ZaY/PV3AlSONu04zb7cgX1V7XwGheKTGgjG415vbA0LhKPBj7nUt+KWtBrUV
         DaMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=lwumo4OognSssz63QX+fR2s8f7HjOZfG/NuRBmw6cy0=;
        b=MBvPx00nCa45Mr4BgwqDG8/eRd2Fk84Ho082pePTpcrGVN4PEDc5m/7kGhsTsLhfkG
         kUEdkaimMaiMiYNDmd3D1F/jWnZOF2YoWzsCR7L6QP5z10NW4WhE3ri0hSBSc/oTm4xX
         nkT5qTXSckXFxCKQ3FtAXZd4pLuK9gQt6r304wSdjhMssvBNmHQS2otNwTo6qG2r2/cD
         eoWk0c3i4HCcA++rJqcH2Yc4rdDTnbD/Sxly4TYQ5+/y6/URKdSjyY84Gwz2HshqjzRR
         Ym9cyz6XipDVsRaGJ2GTP0OAHxu0qB1PN3Rj/Z0L8aVS8R0Ki31mG5vuwRgbMUMqYdI4
         IAFg==
X-Gm-Message-State: AOAM531NjF42etKfk9HuxEaaHLvlPrkM/zyqeOg2SaMRgCDtjMhCll6z
        dNC4c1MjoBTcUMj8zalSBk0=
X-Google-Smtp-Source: ABdhPJwDb5DR51heG7w4ZAMCQXIyuZYTwg05ehlUJOnBWj7vfEnxLFtlAoLSW784jh6S/JxvH3iJPA==
X-Received: by 2002:a17:90b:4c12:b0:1c6:f450:729d with SMTP id na18-20020a17090b4c1200b001c6f450729dmr194978pjb.190.1649697100948;
        Mon, 11 Apr 2022 10:11:40 -0700 (PDT)
Received: from scdiu3.sunplus.com ([113.196.136.192])
        by smtp.googlemail.com with ESMTPSA id y16-20020a63b510000000b00398d8b19bbfsm307213pge.23.2022.04.11.10.11.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Apr 2022 10:11:40 -0700 (PDT)
From:   Wells Lu <wellslutw@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, p.zabel@pengutronix.de,
        pabeni@redhat.com, krzk+dt@kernel.org, roopa@nvidia.com,
        andrew@lunn.ch, edumazet@google.com
Cc:     wells.lu@sunplus.com, Wells Lu <wellslutw@gmail.com>
Subject: [PATCH net-next v7 1/2] devicetree: bindings: net: Add bindings doc for Sunplus SP7021.
Date:   Tue, 12 Apr 2022 01:11:27 +0800
Message-Id: <1649697088-7812-2-git-send-email-wellslutw@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1649697088-7812-1-git-send-email-wellslutw@gmail.com>
References: <1649697088-7812-1-git-send-email-wellslutw@gmail.com>
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
Changes in v7
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

