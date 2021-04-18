Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0102E36382C
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 00:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237274AbhDRWVA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 18:21:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:38360 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235740AbhDRWUY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Apr 2021 18:20:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id BEE89B187;
        Sun, 18 Apr 2021 22:19:54 +0000 (UTC)
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: [PATCH v6 net-next 10/10] dt-bindings: net: korina: Add DT bindings for IDT 79RC3243x SoCs
Date:   Mon, 19 Apr 2021 00:19:48 +0200
Message-Id: <20210418221949.130779-11-tsbogend@alpha.franken.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210418221949.130779-1-tsbogend@alpha.franken.de>
References: <20210418221949.130779-1-tsbogend@alpha.franken.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add device tree bindings for ethernet controller integrated into
IDT 79RC3243x SoCs.

Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
---
 .../bindings/net/idt,3243x-emac.yaml          | 73 +++++++++++++++++++
 1 file changed, 73 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/idt,3243x-emac.yaml

diff --git a/Documentation/devicetree/bindings/net/idt,3243x-emac.yaml b/Documentation/devicetree/bindings/net/idt,3243x-emac.yaml
new file mode 100644
index 000000000000..11ffc306dd54
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/idt,3243x-emac.yaml
@@ -0,0 +1,73 @@
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
+      - const: emac
+      - const: dma_rx
+      - const: dma_tx
+
+  interrupts:
+    items:
+      - description: RX interrupt
+      - description: TX interrupt
+
+  interrupt-names:
+    items:
+      - const: rx
+      - const: tx
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
+        reg-names = "emac", "dma_rx", "dma_tx";
+
+        interrupt-parent = <&rcpic3>;
+        interrupts = <0>, <1>;
+        interrupt-names = "rx", "tx";
+
+        clocks = <&iclk>;
+        clock-names = "mdioclk";
+    };
-- 
2.29.2

