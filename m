Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF73361C87
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 11:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241231AbhDPIw7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 04:52:59 -0400
Received: from mx2.suse.de ([195.135.220.15]:54156 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241067AbhDPIwk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 04:52:40 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 889CEADB3;
        Fri, 16 Apr 2021 08:52:14 +0000 (UTC)
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: [PATCH v5 net-next 10/10] dt-bindings: net: korina: Add DT bindings for IDT 79RC3243x SoCs
Date:   Fri, 16 Apr 2021 10:52:06 +0200
Message-Id: <20210416085207.63181-11-tsbogend@alpha.franken.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210416085207.63181-1-tsbogend@alpha.franken.de>
References: <20210416085207.63181-1-tsbogend@alpha.franken.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add device tree bindings for ethernet controller integrated into
IDT 79RC3243x SoCs.

Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
---
 .../bindings/net/idt,3243x-emac.yaml          | 74 +++++++++++++++++++
 1 file changed, 74 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/idt,3243x-emac.yaml

diff --git a/Documentation/devicetree/bindings/net/idt,3243x-emac.yaml b/Documentation/devicetree/bindings/net/idt,3243x-emac.yaml
new file mode 100644
index 000000000000..3697af5cb66f
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/idt,3243x-emac.yaml
@@ -0,0 +1,74 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/idt,3243x-emac.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: IDT 79rc3243x Ethernet controller
+
+description: Ethernet controller integrated into IDT 79RC3243x family SoCs
+
+maintainers:
+  - Thomas Bogendoerfer <tsbogend@alpha.franken.de>
+
+allOf:
+  - $ref: ethernet-controller.yaml#
+
+properties:
+  compatible:
+    const: idt,3243x-emac
+
+  reg:
+    maxItems: 3
+
+  reg-names:
+    items:
+      - const: korina_regs
+      - const: korina_dma_rx
+      - const: korina_dma_tx
+
+  interrupts:
+    items:
+      - description: RX interrupt
+      - description: TX interrupt
+
+  interrupt-names:
+    items:
+      - const: korina_rx
+      - const: korina_tx
+
+  clocks:
+    maxItems: 1
+
+  clock-names:
+    items:
+      - const: mdioclk
+
+required:
+  - compatible
+  - reg
+  - reg-names
+  - interrupts
+  - interrupt-names
+
+additionalProperties: false
+
+examples:
+  - |
+
+    ethernet@60000 {
+        compatible = "idt,3243x-emac";
+
+        reg = <0x60000 0x10000>,
+              <0x40000 0x14>,
+              <0x40014 0x14>;
+        reg-names = "korina_regs",
+                    "korina_dma_rx",
+                    "korina_dma_tx";
+
+        interrupts-extended = <&rcpic3 0>, <&rcpic3 1>;
+        interrupt-names = "korina_rx", "korina_tx";
+
+        clocks = <&iclk>;
+        clock-names = "mdioclk";
+    };
-- 
2.29.2

