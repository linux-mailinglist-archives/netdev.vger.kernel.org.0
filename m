Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E0552DBDA1
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 10:33:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbgLPJbk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 04:31:40 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:38257 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725822AbgLPJbj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 04:31:39 -0500
X-UUID: 7e16ee06d0af4860bc232c208fbe56f5-20201216
X-UUID: 7e16ee06d0af4860bc232c208fbe56f5-20201216
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw01.mediatek.com
        (envelope-from <chunfeng.yun@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1630314000; Wed, 16 Dec 2020 17:30:37 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs06n1.mediatek.inc (172.21.101.129) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 16 Dec 2020 17:30:36 +0800
Received: from mtkslt301.mediatek.inc (10.21.14.114) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 16 Dec 2020 17:30:34 +0800
From:   Chunfeng Yun <chunfeng.yun@mediatek.com>
To:     Rob Herring <robh+dt@kernel.org>
CC:     Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Chunfeng Yun <chunfeng.yun@mediatek.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Min Guo <min.guo@mediatek.com>,
        <dri-devel@lists.freedesktop.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>
Subject: [PATCH v4 05/11] dt-bindings: phy: convert phy-mtk-ufs.txt to YAML schema
Date:   Wed, 16 Dec 2020 17:30:06 +0800
Message-ID: <20201216093012.24406-5-chunfeng.yun@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20201216093012.24406-1-chunfeng.yun@mediatek.com>
References: <20201216093012.24406-1-chunfeng.yun@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert phy-mtk-ufs.txt to YAML schema mediatek,ufs-phy.yaml

Cc: Stanley Chu <stanley.chu@mediatek.com>
Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
---
v4: add Reviewed-by Stanley
v3: add Reviewed-by Rob
v2: fix binding check warning of reg in example
---
 .../bindings/phy/mediatek,ufs-phy.yaml        | 64 +++++++++++++++++++
 .../devicetree/bindings/phy/phy-mtk-ufs.txt   | 38 -----------
 2 files changed, 64 insertions(+), 38 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/phy/mediatek,ufs-phy.yaml
 delete mode 100644 Documentation/devicetree/bindings/phy/phy-mtk-ufs.txt

diff --git a/Documentation/devicetree/bindings/phy/mediatek,ufs-phy.yaml b/Documentation/devicetree/bindings/phy/mediatek,ufs-phy.yaml
new file mode 100644
index 000000000000..3a9be82e7f13
--- /dev/null
+++ b/Documentation/devicetree/bindings/phy/mediatek,ufs-phy.yaml
@@ -0,0 +1,64 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+# Copyright (c) 2020 MediaTek
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/phy/mediatek,ufs-phy.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: MediaTek Universal Flash Storage (UFS) M-PHY binding
+
+maintainers:
+  - Stanley Chu <stanley.chu@mediatek.com>
+  - Chunfeng Yun <chunfeng.yun@mediatek.com>
+
+description: |
+  UFS M-PHY nodes are defined to describe on-chip UFS M-PHY hardware macro.
+  Each UFS M-PHY node should have its own node.
+  To bind UFS M-PHY with UFS host controller, the controller node should
+  contain a phandle reference to UFS M-PHY node.
+
+properties:
+  $nodename:
+    pattern: "^ufs-phy@[0-9a-f]+$"
+
+  compatible:
+    const: mediatek,mt8183-ufsphy
+
+  reg:
+    maxItems: 1
+
+  clocks:
+    items:
+      - description: Unipro core control clock.
+      - description: M-PHY core control clock.
+
+  clock-names:
+    items:
+      - const: unipro
+      - const: mp
+
+  "#phy-cells":
+    const: 0
+
+required:
+  - compatible
+  - reg
+  - "#phy-cells"
+  - clocks
+  - clock-names
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/clock/mt8183-clk.h>
+    ufsphy: ufs-phy@11fa0000 {
+        compatible = "mediatek,mt8183-ufsphy";
+        reg = <0x11fa0000 0xc000>;
+        clocks = <&infracfg CLK_INFRA_UNIPRO_SCK>,
+                 <&infracfg CLK_INFRA_UFS_MP_SAP_BCLK>;
+        clock-names = "unipro", "mp";
+        #phy-cells = <0>;
+    };
+
+...
diff --git a/Documentation/devicetree/bindings/phy/phy-mtk-ufs.txt b/Documentation/devicetree/bindings/phy/phy-mtk-ufs.txt
deleted file mode 100644
index 5789029a1d42..000000000000
--- a/Documentation/devicetree/bindings/phy/phy-mtk-ufs.txt
+++ /dev/null
@@ -1,38 +0,0 @@
-MediaTek Universal Flash Storage (UFS) M-PHY binding
---------------------------------------------------------
-
-UFS M-PHY nodes are defined to describe on-chip UFS M-PHY hardware macro.
-Each UFS M-PHY node should have its own node.
-
-To bind UFS M-PHY with UFS host controller, the controller node should
-contain a phandle reference to UFS M-PHY node.
-
-Required properties for UFS M-PHY nodes:
-- compatible         : Compatible list, contains the following controller:
-                       "mediatek,mt8183-ufsphy" for ufs phy
-                       persent on MT81xx chipsets.
-- reg                : Address and length of the UFS M-PHY register set.
-- #phy-cells         : This property shall be set to 0.
-- clocks             : List of phandle and clock specifier pairs.
-- clock-names        : List of clock input name strings sorted in the same
-                       order as the clocks property. Following clocks are
-                       mandatory.
-                       "unipro": Unipro core control clock.
-                       "mp": M-PHY core control clock.
-
-Example:
-
-	ufsphy: phy@11fa0000 {
-		compatible = "mediatek,mt8183-ufsphy";
-		reg = <0 0x11fa0000 0 0xc000>;
-		#phy-cells = <0>;
-
-		clocks = <&infracfg_ao INFRACFG_AO_UNIPRO_SCK_CG>,
-			 <&infracfg_ao INFRACFG_AO_UFS_MP_SAP_BCLK_CG>;
-		clock-names = "unipro", "mp";
-	};
-
-	ufshci@11270000 {
-		...
-		phys = <&ufsphy>;
-	};
-- 
2.18.0

