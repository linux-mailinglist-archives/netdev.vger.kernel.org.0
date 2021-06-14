Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DDA53A6CF6
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 19:18:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235485AbhFNRUJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 13:20:09 -0400
Received: from out28-52.mail.aliyun.com ([115.124.28.52]:45994 "EHLO
        out28-52.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235398AbhFNRUF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 13:20:05 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.9016092|0.8433917;CH=green;DM=|SPAM|false|;DS=CONTINUE|ham_regular_dialog|0.0829513-0.00479038-0.912258;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047207;MF=zhouyanjie@wanyeetech.com;NM=1;PH=DS;RN=21;RT=21;SR=0;TI=SMTPD_---.KSAJpVJ_1623691068;
Received: from localhost.localdomain(mailfrom:zhouyanjie@wanyeetech.com fp:SMTPD_---.KSAJpVJ_1623691068)
          by smtp.aliyun-inc.com(10.147.41.121);
          Tue, 15 Jun 2021 01:17:58 +0800
From:   =?UTF-8?q?=E5=91=A8=E7=90=B0=E6=9D=B0=20=28Zhou=20Yanjie=29?= 
        <zhouyanjie@wanyeetech.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        matthias.bgg@gmail.com
Cc:     alexandre.torgue@st.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, dongsheng.qiu@ingenic.com,
        aric.pzqi@ingenic.com, rick.tyliu@ingenic.com,
        sihui.liu@ingenic.com, jun.jiang@ingenic.com,
        sernia.zhou@foxmail.com
Subject: [PATCH v3 1/2] dt-bindings: dwmac: Add bindings for new Ingenic SoCs.
Date:   Tue, 15 Jun 2021 01:15:36 +0800
Message-Id: <1623690937-52389-2-git-send-email-zhouyanjie@wanyeetech.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1623690937-52389-1-git-send-email-zhouyanjie@wanyeetech.com>
References: <1623690937-52389-1-git-send-email-zhouyanjie@wanyeetech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the dwmac bindings for the JZ4775 SoC, the X1000 SoC,
the X1600 SoC, the X1830 SoC and the X2000 SoC from Ingenic.

Signed-off-by: 周琰杰 (Zhou Yanjie) <zhouyanjie@wanyeetech.com>
---

Notes:
    v1->v2:
    No change.
    
    v2->v3:
    Add "ingenic,mac.yaml" for Ingenic SoCs.

 .../devicetree/bindings/net/ingenic,mac.yaml       | 76 ++++++++++++++++++++++
 .../devicetree/bindings/net/snps,dwmac.yaml        | 15 +++++
 2 files changed, 91 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/ingenic,mac.yaml

diff --git a/Documentation/devicetree/bindings/net/ingenic,mac.yaml b/Documentation/devicetree/bindings/net/ingenic,mac.yaml
new file mode 100644
index 00000000..5fe2e81
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/ingenic,mac.yaml
@@ -0,0 +1,76 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/ingenic,mac.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Bindings for MAC in Ingenic SoCs
+
+maintainers:
+  - 周琰杰 (Zhou Yanjie) <zhouyanjie@wanyeetech.com>
+
+description:
+  The Ethernet Media Access Controller in Ingenic SoCs.
+
+properties:
+  compatible:
+    enum:
+      - ingenic,jz4775-mac
+      - ingenic,x1000-mac
+      - ingenic,x1600-mac
+      - ingenic,x1830-mac
+      - ingenic,x2000-mac
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    maxItems: 1
+
+  interrupt-names:
+    const: macirq
+
+  clocks:
+    maxItems: 1
+
+  clock-names:
+    const: stmmaceth
+
+  mode-reg:
+    description: An extra syscon register that control ethernet interface and timing delay
+
+  rx-clk-delay-ps:
+    description: RGMII receive clock delay defined in pico seconds
+
+  tx-clk-delay-ps:
+    description: RGMII transmit clock delay defined in pico seconds
+
+required:
+  - compatible
+  - reg
+  - interrupts
+  - interrupt-names
+  - clocks
+  - clock-names
+  - mode-reg
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/clock/x1000-cgu.h>
+
+    mac: ethernet@134b0000 {
+        compatible = "ingenic,x1000-mac", "snps,dwmac";
+        reg = <0x134b0000 0x2000>;
+
+        interrupt-parent = <&intc>;
+        interrupts = <55>;
+        interrupt-names = "macirq";
+
+        clocks = <&cgu X1000_CLK_MAC>;
+        clock-names = "stmmaceth";
+
+        mode-reg = <&mac_phy_ctrl>;
+    };
+...
diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
index 2edd8be..9c0ce92 100644
--- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
@@ -56,6 +56,11 @@ properties:
         - amlogic,meson8m2-dwmac
         - amlogic,meson-gxbb-dwmac
         - amlogic,meson-axg-dwmac
+        - ingenic,jz4775-mac
+        - ingenic,x1000-mac
+        - ingenic,x1600-mac
+        - ingenic,x1830-mac
+        - ingenic,x2000-mac
         - rockchip,px30-gmac
         - rockchip,rk3128-gmac
         - rockchip,rk3228-gmac
@@ -310,6 +315,11 @@ allOf:
               - allwinner,sun8i-r40-emac
               - allwinner,sun8i-v3s-emac
               - allwinner,sun50i-a64-emac
+              - ingenic,jz4775-mac
+              - ingenic,x1000-mac
+              - ingenic,x1600-mac
+              - ingenic,x1830-mac
+              - ingenic,x2000-mac
               - snps,dwxgmac
               - snps,dwxgmac-2.10
               - st,spear600-gmac
@@ -353,6 +363,11 @@ allOf:
               - allwinner,sun8i-r40-emac
               - allwinner,sun8i-v3s-emac
               - allwinner,sun50i-a64-emac
+              - ingenic,jz4775-mac
+              - ingenic,x1000-mac
+              - ingenic,x1600-mac
+              - ingenic,x1830-mac
+              - ingenic,x2000-mac
               - snps,dwmac-4.00
               - snps,dwmac-4.10a
               - snps,dwmac-4.20a
-- 
2.7.4

