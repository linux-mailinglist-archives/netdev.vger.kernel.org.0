Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF1D9249CDD
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 13:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728391AbgHSL5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 07:57:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:49206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728281AbgHSLt0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Aug 2020 07:49:26 -0400
Received: from mail.kernel.org (ip5f5ad5a3.dynamic.kabel-deutschland.de [95.90.213.163])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04C6A22D6D;
        Wed, 19 Aug 2020 11:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597837584;
        bh=0s3pmtILVSiuI77kiYarCgl3FUbdNZSJJENxk4HNs1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XPoNKr4UNTqnAzpnnXX0ra1UVzx27ph7DOeQ7Lxg7GLPBzAJk+TZgZwglUIovjO2C
         Ox4rol4IoNMRrIBPrZttvUxhNAQeUcTpgYcArKxrbQqhv+FTLNfCzOp3uPn61YI22K
         D9se5drVv7bB9w8L2f0tMtFoW2knYrdC4sR1YRZo=
Received: from mchehab by mail.kernel.org with local (Exim 4.94)
        (envelope-from <mchehab@kernel.org>)
        id 1k8MXt-00EucG-PZ; Wed, 19 Aug 2020 13:46:21 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linuxarm@huawei.com, mauro.chehab@huawei.com,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        David Airlie <airlied@linux.ie>,
        Rob Herring <robh+dt@kernel.org>,
        Wei Xu <xuwei5@hisilicon.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH 49/49] dt: display: Add binds for the DPE and DSI controller for Kirin 960/970
Date:   Wed, 19 Aug 2020 13:46:17 +0200
Message-Id: <6471642f74779fecfc9d5e990d90f9475d8b32d4.1597833138.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1597833138.git.mchehab+huawei@kernel.org>
References: <cover.1597833138.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a description of the bindings used by Kirin 960/970 Display
Serial Interface (DSI) controller and by its Display Engine (DPE).

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 .../display/hisilicon,hi3660-dpe.yaml         |  99 +++++++++++++++++
 .../display/hisilicon,hi3660-dsi.yaml         | 102 ++++++++++++++++++
 .../boot/dts/hisilicon/hikey970-drm.dtsi      |   4 +-
 3 files changed, 203 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/display/hisilicon,hi3660-dpe.yaml
 create mode 100644 Documentation/devicetree/bindings/display/hisilicon,hi3660-dsi.yaml

diff --git a/Documentation/devicetree/bindings/display/hisilicon,hi3660-dpe.yaml b/Documentation/devicetree/bindings/display/hisilicon,hi3660-dpe.yaml
new file mode 100644
index 000000000000..074997354417
--- /dev/null
+++ b/Documentation/devicetree/bindings/display/hisilicon,hi3660-dpe.yaml
@@ -0,0 +1,99 @@
+# SPDX-License-Identifier: GPL-2.0
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/display/hisilicon,hi3660-dpe.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: HiSilicon SPMI controller
+
+maintainers:
+  - Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
+
+description: |
+  The HiSilicon Display Engine (DPE) s the display controller which grab
+  image data from memory, do composition, do post image processing,
+  generate RGB timing stream and transfer to DSI.
+
+properties:
+  $nodename:
+    pattern: "dpe@[0-9a-f]+"
+
+  compatible:
+    enum:
+      - hisilicon,kirin960-dpe
+      - hisilicon,kirin970-dpe
+
+  reg:
+    minItems: 1
+
+  interrupts:
+    maxItems: 1
+
+  clocks:
+    minItems: 1
+    description: Clocks used by the ISP and by the display
+
+  clock-names:
+    description: Names for the clock lines
+
+  dma-coherent: true
+
+  port:
+    type: object
+    description: A port node pointing to the display output endpoint.
+
+
+  iommu-info:
+    type: object
+    description: IOMMU address and size to be used by GPU
+
+    properties:
+      start-addr:
+        const: start address for IOMMU
+      size:
+        const: size of the mapped region
+
+examples:
+  - |
+    dpe: dpe@e8600000 {
+      compatible = "hisilicon,kirin970-dpe";
+      memory-region = <&drm_dma_reserved>;
+      reg = <0 0xE8600000 0 0xC0000>,
+            <0 0xFFF35000 0 0x1000>,
+            <0 0xFFF0A000 0 0x1000>,
+            <0 0xE8A09000 0 0x1000>,
+            <0 0xE86C0000 0 0x10000>,
+            <0 0xFFF31000 0 0x1000>,
+            <0 0xE87FF000 0 0x1000>;
+
+      interrupts = <0 245 4>;
+
+      clocks = <&media1_crg HI3670_ACLK_GATE_DSS>,
+               <&media1_crg HI3670_PCLK_GATE_DSS>,
+               <&media1_crg HI3670_CLK_GATE_EDC0>,
+               <&media1_crg HI3670_CLK_GATE_LDI0>,
+               <&media1_crg HI3670_CLK_GATE_DSS_AXI_MM>,
+               <&media1_crg HI3670_PCLK_GATE_MMBUF>,
+               <&crg_ctrl   HI3670_PCLK_GATE_PCTRL>;
+
+      clock-names = "aclk_dss",
+                    "pclk_dss",
+                    "clk_edc0",
+                    "clk_ldi0",
+                    "clk_dss_axi_mm",
+                    "pclk_mmbuf",
+                    "pclk_pctrl";
+
+      dma-coherent;
+
+      port {
+        dpe_out: endpoint {
+          remote-endpoint = <&dsi_in>;
+        };
+      };
+
+      iommu_info {
+        start-addr = <0x8000>;
+        size = <0xbfff8000>;
+      };
+    };
diff --git a/Documentation/devicetree/bindings/display/hisilicon,hi3660-dsi.yaml b/Documentation/devicetree/bindings/display/hisilicon,hi3660-dsi.yaml
new file mode 100644
index 000000000000..2265267fc53d
--- /dev/null
+++ b/Documentation/devicetree/bindings/display/hisilicon,hi3660-dsi.yaml
@@ -0,0 +1,102 @@
+# SPDX-License-Identifier: GPL-2.0
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/display/hisilicon,hi3660-dsi.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: HiSilicon SPMI controller
+
+maintainers:
+  - Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
+
+description: |
+  The HiSilicon Display Serial Interface (DSI) Host Controller for
+  Kirin 960 and 970 resides in the middle of display controller and
+  an external HDMI converter or panel.
+
+properties:
+  $nodename:
+    pattern: "dsi@[0-9a-f]+"
+
+  compatible:
+    enum:
+      - hisilicon,kirin960-dsi
+      - hisilicon,kirin970-dsi
+
+  reg:
+    minItems: 1
+    maxItems: 4
+
+  clocks:
+    minItems: 1
+    maxItems: 8
+    description: Clocks used by the ISP and by the display.
+
+  clock-names:
+    description: Names for the clock lines.
+
+  "#address-cells":
+    const: 1
+
+  "#size-cells":
+    const: 0
+
+  mux-gpio:
+    description: GPIO used by the mux.
+
+  ports:
+    type: object
+    description: Display input and output ports.
+
+examples:
+  - |
+    dsi: dsi@e8601000 {
+      compatible = "hisilicon,kirin970-dsi";
+      reg = <0 0xE8601000 0 0x7F000>,
+        <0 0xFFF35000 0 0x1000>,
+        <0 0xE8A09000 0 0x1000>;
+
+      clocks = <&crg_ctrl HI3670_CLK_GATE_TXDPHY0_REF>,
+        <&crg_ctrl HI3670_CLK_GATE_TXDPHY1_REF>,
+        <&crg_ctrl HI3670_CLK_GATE_TXDPHY0_CFG>,
+        <&crg_ctrl HI3670_CLK_GATE_TXDPHY1_CFG>,
+        <&crg_ctrl HI3670_PCLK_GATE_DSI0>,
+        <&crg_ctrl HI3670_PCLK_GATE_DSI1>;
+      clock-names = "clk_txdphy0_ref",
+            "clk_txdphy1_ref",
+            "clk_txdphy0_cfg",
+            "clk_txdphy1_cfg",
+            "pclk_dsi0",
+            "pclk_dsi1";
+
+      #address-cells = <1>;
+      #size-cells = <0>;
+      mux-gpio = <&gpio25 7 0>;
+
+      ports {
+        #address-cells = <1>;
+        #size-cells = <0>;
+
+        port@0 {
+          reg = <0>;
+          dsi_in: endpoint {
+            remote-endpoint = <&dpe_out>;
+          };
+        };
+
+        port@1 {
+          #address-cells = <1>;
+          #size-cells = <0>;
+          reg = <1>;
+
+          dsi_out0: endpoint@0 {
+            reg = <0>;
+            remote-endpoint = <&adv7533_in>;
+          };
+
+          dsi_out1: endpoint@1 {
+            reg = <1>;
+            remote-endpoint = <&panel0_in>;
+          };
+        };
+      };
diff --git a/arch/arm64/boot/dts/hisilicon/hikey970-drm.dtsi b/arch/arm64/boot/dts/hisilicon/hikey970-drm.dtsi
index 503c7c9425c8..5758d7d181e5 100644
--- a/arch/arm64/boot/dts/hisilicon/hikey970-drm.dtsi
+++ b/arch/arm64/boot/dts/hisilicon/hikey970-drm.dtsi
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 / {
-	dpe: dpe@E8600000 {
+	dpe: dpe@e8600000 {
 		compatible = "hisilicon,kirin970-dpe";
 		memory-region = <&drm_dma_reserved>;
 		// DSS, PERI_CRG, SCTRL, PCTRL, NOC_DSS_Service_Target, PMCTRL, MEDIA_CRG
@@ -44,7 +44,7 @@ iommu_info {
 		};
 	};
 
-	dsi: dsi@E8601000 {
+	dsi: dsi@e8601000 {
 		compatible = "hisilicon,kirin970-dsi";
 		reg = <0 0xE8601000 0 0x7F000>,
 			<0 0xFFF35000 0 0x1000>,
-- 
2.26.2

