Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 032AD33B11E
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 12:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230204AbhCOL3z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 07:29:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbhCOL3Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 07:29:24 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C891C061574;
        Mon, 15 Mar 2021 04:29:24 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id lr13so65584791ejb.8;
        Mon, 15 Mar 2021 04:29:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KFNekFiUvI41Ro84pNXiS2rRQL/pZm+3ROgVX6AukC8=;
        b=dJ7H/BMpMSWcK/p/UyoE8deduBfnpDR3m8JCfUz+CaxKdP+hN0SLVriYHZZ5AuXQoo
         VtRAAzJ93gCTYRABHq3ZQ25NR7gMHkJkCxr+A4Wz2BDV/7CACIJI+FxjiV8nmTWlOb3p
         7iACsW7/KTnbVFGGLZxA9oEG/+ZHVZWSVoFPzKJjJDWHHUlH7ETnYNiOQ9dsBCYFZSZn
         F62xMx4KT3NwLdDd9x7jV4OnIIWbADTTBCi8+khwac4pKJfkdCtMl1h1NYm/OmQAZ+Xu
         SgNp3RcieqikT4ZCv41rXNhGqvNucxtwZ1acssaiG39vxkKb+UXGl6ntsOCVjmpBcD9q
         XEpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KFNekFiUvI41Ro84pNXiS2rRQL/pZm+3ROgVX6AukC8=;
        b=P8vrw0AKrV3669gaBshIPqUrUcK9GjqYDy4MuR1W+/jtX1SURmcVe4O+TS7SH0oGEi
         tGHAmOqLONKKuF+2MBB0NzfzbDq/LyCpAFKzaurkEJvg4G4Pnszypl4Ylw/lfFBWCQ3E
         j5+Cq0+GF1yffAPpKuKuR0THGAupLPvVKRFMdqdffGU6Eb3dPxvd7si8ZAkWgzLEmCU8
         uCkoWZWVomMXscBeNu5xRJmui+c+3QU7aEhoKg9hVQwjiBFGNSAR8nkVnTGOR5sfyjPG
         b2TpUbCAQ7f1tXohhC5lHBo9cqRysGuK5lSlomKa9CPALllpc3NYbmC6JJR8witbiMs/
         Ic5w==
X-Gm-Message-State: AOAM530JuVPkSjENc5AYREaHvY11aHYqVJa4OggEFo1qopEE+dU1bHnP
        O28HcFnZA5OJcFDp2Ho+O3Y+bBPqUZo=
X-Google-Smtp-Source: ABdhPJxgQF7PMbHxn1LGbKho6Q/fyHhmovD08KaijO6PYUXyzjQpYbWskg+hRpWcr92Rh6qH9m1XWg==
X-Received: by 2002:a17:906:154f:: with SMTP id c15mr22020763ejd.142.1615807762880;
        Mon, 15 Mar 2021 04:29:22 -0700 (PDT)
Received: from localhost.localdomain ([188.24.140.160])
        by smtp.gmail.com with ESMTPSA id q25sm3921423edt.51.2021.03.15.04.29.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 04:29:22 -0700 (PDT)
From:   Cristian Ciocaltea <cristian.ciocaltea@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-actions@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/3] dt-bindings: net: Add Actions Semi Owl Ethernet MAC binding
Date:   Mon, 15 Mar 2021 13:29:16 +0200
Message-Id: <731f89c3c1ac90b2b24fa2140e07e97aa516f79f.1615807292.git.cristian.ciocaltea@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1615807292.git.cristian.ciocaltea@gmail.com>
References: <cover.1615807292.git.cristian.ciocaltea@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add devicetree binding for the Ethernet MAC present on the Actions
Semi Owl family of SoCs.

For the moment advertise only the support for the Actions Semi S500 SoC
variant.

Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@gmail.com>
---
 .../bindings/net/actions,owl-emac.yaml        | 92 +++++++++++++++++++
 1 file changed, 92 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/actions,owl-emac.yaml

diff --git a/Documentation/devicetree/bindings/net/actions,owl-emac.yaml b/Documentation/devicetree/bindings/net/actions,owl-emac.yaml
new file mode 100644
index 000000000000..1626e0a821b0
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/actions,owl-emac.yaml
@@ -0,0 +1,92 @@
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
+  It provides the RMII and SMII interfaces and is compliant with the
+  IEEE 802.3 CSMA/CD standard, supporting both half-duplex and full-duplex
+  operation modes at 10/100 Mb/s data transfer rates.
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
+        phy-mode = "rmii";
+        phy-handle = <&eth_phy>;
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

