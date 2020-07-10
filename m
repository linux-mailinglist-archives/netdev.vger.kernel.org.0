Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 406F821B8D9
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 16:38:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728256AbgGJOhw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 10:37:52 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:47194 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726820AbgGJOht (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 10:37:49 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 06AEbiaG090319;
        Fri, 10 Jul 2020 09:37:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1594391864;
        bh=AFRw+WmJ2Q5yfDyMlj5hZGNaBfFtzWmLjk7PZiopxDM=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=xdTVwUNG9TX76HTYbp71YKxMdwwTmkzqyWMZ3zyurbWj/XdZJZy9HdhGCVlzntTJz
         VidBUtv3VYPU0+1sBHzU013tLLRKeQdvjVRS9WqM5yi7I+bdVPMld2WIViDdSBU1q7
         KIPsJU2WcAW3XC7M1BD5yxgXyJN6j0qyvk3CDt38=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 06AEbicX074914
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 10 Jul 2020 09:37:44 -0500
Received: from DLEE112.ent.ti.com (157.170.170.23) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 10
 Jul 2020 09:37:44 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 10 Jul 2020 09:37:44 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 06AEbiO0033780;
        Fri, 10 Jul 2020 09:37:44 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <robh@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Dan Murphy <dmurphy@ti.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: [PATCH net-next v2 1/2] dt-bindings: net: dp83822: Add TI dp83822 phy
Date:   Fri, 10 Jul 2020 09:37:32 -0500
Message-ID: <20200710143733.30751-2-dmurphy@ti.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200710143733.30751-1-dmurphy@ti.com>
References: <20200710143733.30751-1-dmurphy@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a dt binding for the TI dp83822 ethernet phy device.

CC: Rob Herring <robh+dt@kernel.org>
Signed-off-by: Dan Murphy <dmurphy@ti.com>
---
 .../devicetree/bindings/net/ti,dp83822.yaml   | 80 +++++++++++++++++++
 1 file changed, 80 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/ti,dp83822.yaml

diff --git a/Documentation/devicetree/bindings/net/ti,dp83822.yaml b/Documentation/devicetree/bindings/net/ti,dp83822.yaml
new file mode 100644
index 000000000000..55913534cbc2
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/ti,dp83822.yaml
@@ -0,0 +1,80 @@
+# SPDX-License-Identifier: (GPL-2.0+ OR BSD-2-Clause)
+# Copyright (C) 2020 Texas Instruments Incorporated
+%YAML 1.2
+---
+$id: "http://devicetree.org/schemas/net/ti,dp83822.yaml#"
+$schema: "http://devicetree.org/meta-schemas/core.yaml#"
+
+title: TI DP83822 ethernet PHY
+
+maintainers:
+  - Dan Murphy <dmurphy@ti.com>
+
+description: |
+  The DP83822 is a low-power, single-port, 10/100 Mbps Ethernet PHY. It
+  provides all of the physical layer functions needed to transmit and receive
+  data over standard, twisted-pair cables or to connect to an external,
+  fiber-optic transceiver. Additionally, the DP83822 provides flexibility to
+  connect to a MAC through a standard MII, RMII, or RGMII interface
+
+  Specifications about the Ethernet PHY can be found at:
+    http://www.ti.com/lit/ds/symlink/dp83822i.pdf
+
+allOf:
+  - $ref: "ethernet-phy.yaml#"
+
+properties:
+  reg:
+    maxItems: 1
+
+  ti,link-loss-low:
+    type: boolean
+    description: |
+       DP83822 PHY in Fiber mode only.
+       Sets the DP83822 to detect a link drop condition when the signal goes
+       high.  If not set then link drop will occur when the signal goes low.
+       This property is only applicable if the fiber mode support is strapped
+       to on.
+
+  ti,fiber-mode:
+    type: boolean
+    description: |
+       DP83822 PHY only.
+       If present the DP83822 PHY is configured to operate in fiber mode
+       Fiber mode support can also be strapped. If the strap pin is not set
+       correctly or not set at all then this boolean can be used to enable it.
+       If the fiber mode is not strapped then signal detection for the PHY
+       is disabled.
+       In fiber mode, auto-negotiation is disabled and the PHY can only work in
+       100base-fx (full and half duplex) modes.
+
+  rx-internal-delay-ps:
+    description: |
+       DP83822 PHY only.
+       Setting this property to a non-zero number sets the RX internal delay
+       for the PHY.  The internal delay for the PHY is fixed to 3.5ns relative
+       to receive data.
+
+  tx-internal-delay-ps:
+    description: |
+       DP83822 PHY only.
+       Setting this property to a non-zero number sets the TX internal delay
+       for the PHY.  The internal delay for the PHY is fixed to 3.5ns relative
+       to transmit data.
+
+required:
+  - reg
+
+examples:
+  - |
+    mdio0 {
+      #address-cells = <1>;
+      #size-cells = <0>;
+      ethphy0: ethernet-phy@0 {
+        reg = <0>;
+        rx-internal-delay-ps = <1>;
+        tx-internal-delay-ps = <1>;
+      };
+    };
+
+...
-- 
2.27.0

