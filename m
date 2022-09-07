Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 351C25B0E84
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 22:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbiIGUtx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 16:49:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbiIGUtp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 16:49:45 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3A95205FD
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 13:49:42 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id d12so15766972plr.6
        for <netdev@vger.kernel.org>; Wed, 07 Sep 2022 13:49:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=sj5RaQ77I/6DyhjqmkYdL7/dOR7WFf4tzsvAF00sIzg=;
        b=AoRkpHmf/53e70dA21pWX3oMjPp0orkNV+RW9PY5toQIzEmKFRyGPkSC5ZyBNGn4VY
         0/N0VUvvJSKalVtQOHfH8cNGyvwA5s+wHdRENQSNEppPNExcii//1m2UhEI4K3qRHR+Q
         YYI2rjL6dW0EKd4sJsGjwLenX4mXqz7kqKKEvvd8P1aPUgXesDRzB9GxoP/xwKA8D1QW
         90VDsZOS/PXVWHUlhBm/Cr6t4t22KdwIdsk2sXH96D85zh4RSWy3fwtBZZM9qCtxL1Lv
         zemTnP0udklR/3TkkcqPHSrEt/8npotBXk2syN7BtRXTKPRx7Ac6BHR9Mq8wtTrqrFiX
         DRhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=sj5RaQ77I/6DyhjqmkYdL7/dOR7WFf4tzsvAF00sIzg=;
        b=Fpt6kA9c6YiBePx07N8Klc18ZNYREVuao3BdfTGZ8cBuht1D3hsdhhczuFecxOiOhU
         ubWUClfr75lCUQ5IZDUIwNSuFIwfkvylQVeu2OQYmJq9wYBwJgp5iIV5aVSb6aFe+urU
         NJtdmC8Wvy7TWbFkW+0nd6YyrGL1BOnbm1y37JbyE0sX5YQZs3lras5EaIUn4AkNkvjQ
         b5qTFiooEFx4p38im2HF8uo0tztedvL9QkDctBvsE6B1Uo1GEr57F2lTtmtl91Iu4C48
         E1HbHEQ6BMkMu6VihPCy51Xt8t1yQ4pg0oQ4XXQ6SlhyLr/yCgH9FLkI6cZ0wFHjgTRf
         Vf0Q==
X-Gm-Message-State: ACgBeo0O+NOg4NuCsQDN1N8jOLIckaWX7A4/aVwZ+c3OWutxd5RdKGja
        VdhAdBH6z3bu2jvRLfW71cV2bA==
X-Google-Smtp-Source: AA6agR7cTVUBMUOeF0ia+cmK/WY9khL6jR10lJlInrlDIOmKhG8i7tpYiZ392qe1on3ErO4tRDhWxw==
X-Received: by 2002:a17:902:d4c9:b0:176:e833:4efe with SMTP id o9-20020a170902d4c900b00176e8334efemr5105142plg.108.1662583782029;
        Wed, 07 Sep 2022 13:49:42 -0700 (PDT)
Received: from localhost.localdomain ([2401:4900:1c60:5362:9d7f:2354:1d0a:78e3])
        by smtp.gmail.com with ESMTPSA id e6-20020a17090301c600b001712c008f99sm12795140plh.11.2022.09.07.13.49.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 13:49:41 -0700 (PDT)
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
To:     devicetree@vger.kernel.org
Cc:     linux-arm-msm@vger.kernel.org, agross@kernel.org,
        bhupesh.sharma@linaro.org, bhupesh.linux@gmail.com,
        linux-kernel@vger.kernel.org, robh+dt@kernel.org,
        krzysztof.kozlowski@linaro.org, netdev@vger.kernel.org,
        Bjorn Andersson <andersson@kernel.org>,
        Rob Herring <robh@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        David Miller <davem@davemloft.net>
Subject: [PATCH 1/4] dt-bindings: net: qcom,ethqos: Convert bindings to yaml
Date:   Thu,  8 Sep 2022 02:19:21 +0530
Message-Id: <20220907204924.2040384-2-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220907204924.2040384-1-bhupesh.sharma@linaro.org>
References: <20220907204924.2040384-1-bhupesh.sharma@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert Qualcomm ETHQOS Ethernet devicetree binding to YAML.

Cc: Bjorn Andersson <andersson@kernel.org>
Cc: Rob Herring <robh@kernel.org>
Cc: Vinod Koul <vkoul@kernel.org>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
---
 .../devicetree/bindings/net/qcom,ethqos.txt   |  66 ---------
 .../devicetree/bindings/net/qcom,ethqos.yaml  | 139 ++++++++++++++++++
 2 files changed, 139 insertions(+), 66 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/qcom,ethqos.txt
 create mode 100644 Documentation/devicetree/bindings/net/qcom,ethqos.yaml

diff --git a/Documentation/devicetree/bindings/net/qcom,ethqos.txt b/Documentation/devicetree/bindings/net/qcom,ethqos.txt
deleted file mode 100644
index 1f5746849a71..000000000000
--- a/Documentation/devicetree/bindings/net/qcom,ethqos.txt
+++ /dev/null
@@ -1,66 +0,0 @@
-Qualcomm Ethernet ETHQOS device
-
-This documents dwmmac based ethernet device which supports Gigabit
-ethernet for version v2.3.0 onwards.
-
-This device has following properties:
-
-Required properties:
-
-- compatible: Should be one of:
-		"qcom,qcs404-ethqos"
-		"qcom,sm8150-ethqos"
-
-- reg: Address and length of the register set for the device
-
-- reg-names: Should contain register names "stmmaceth", "rgmii"
-
-- clocks: Should contain phandle to clocks
-
-- clock-names: Should contain clock names "stmmaceth", "pclk",
-		"ptp_ref", "rgmii"
-
-- interrupts: Should contain phandle to interrupts
-
-- interrupt-names: Should contain interrupt names "macirq", "eth_lpi"
-
-Rest of the properties are defined in stmmac.txt file in same directory
-
-
-Example:
-
-ethernet: ethernet@7a80000 {
-	compatible = "qcom,qcs404-ethqos";
-	reg = <0x07a80000 0x10000>,
-		<0x07a96000 0x100>;
-	reg-names = "stmmaceth", "rgmii";
-	clock-names = "stmmaceth", "pclk", "ptp_ref", "rgmii";
-	clocks = <&gcc GCC_ETH_AXI_CLK>,
-		<&gcc GCC_ETH_SLAVE_AHB_CLK>,
-		<&gcc GCC_ETH_PTP_CLK>,
-		<&gcc GCC_ETH_RGMII_CLK>;
-	interrupts = <GIC_SPI 56 IRQ_TYPE_LEVEL_HIGH>,
-			<GIC_SPI 55 IRQ_TYPE_LEVEL_HIGH>;
-	interrupt-names = "macirq", "eth_lpi";
-	snps,reset-gpio = <&tlmm 60 GPIO_ACTIVE_LOW>;
-	snps,reset-active-low;
-
-	snps,txpbl = <8>;
-	snps,rxpbl = <2>;
-	snps,aal;
-	snps,tso;
-
-	phy-handle = <&phy1>;
-	phy-mode = "rgmii";
-
-	mdio {
-		#address-cells = <0x1>;
-		#size-cells = <0x0>;
-		compatible = "snps,dwmac-mdio";
-		phy1: phy@4 {
-			device_type = "ethernet-phy";
-			reg = <0x4>;
-		};
-	};
-
-};
diff --git a/Documentation/devicetree/bindings/net/qcom,ethqos.yaml b/Documentation/devicetree/bindings/net/qcom,ethqos.yaml
new file mode 100644
index 000000000000..f05df9b0d106
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/qcom,ethqos.yaml
@@ -0,0 +1,139 @@
+# SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/qcom,ethqos.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Qualcomm Ethernet ETHQOS device
+
+maintainers:
+  - Bhupesh Sharma <bhupesh.sharma@linaro.org>
+
+description:
+  This binding describes the dwmmac based Qualcomm ethernet devices which
+  support Gigabit ethernet (version v2.3.0 onwards).
+
+  So, this file documents platform glue layer for dwmmac stmmac based Qualcomm
+  ethernet devices.
+
+allOf:
+  - $ref: "snps,dwmac.yaml#"
+
+properties:
+  compatible:
+    enum:
+      - qcom,qcs404-ethqos
+      - qcom,sm8150-ethqos
+
+  reg: true
+
+  reg-names:
+    minItems: 1
+    items:
+      - const: stmmaceth
+      - const: rgmii
+
+  interrupts: true
+
+  interrupt-names: true
+
+  clocks:
+    minItems: 1
+    maxItems: 4
+
+  clock-names:
+    minItems: 1
+    items:
+      - const: stmmaceth
+      - const: pclk
+      - const: ptp_ref
+      - const: rgmii
+
+  iommus:
+    minItems: 1
+    maxItems: 2
+
+  mdio: true
+
+  phy-handle: true
+
+  phy-mode: true
+
+  snps,reset-gpio: true
+
+  snps,tso:
+    $ref: /schemas/types.yaml#/definitions/flag
+    description:
+      Enables the TSO feature otherwise it will be managed by MAC HW capability register.
+
+  power-domains: true
+
+  resets: true
+
+  rx-fifo-depth: true
+
+  tx-fifo-depth: true
+
+required:
+  - compatible
+  - clocks
+  - clock-names
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+    #include <dt-bindings/clock/qcom,gcc-sm8150.h>
+    #include <dt-bindings/gpio/gpio.h>
+
+    ethernet1: ethernet@20000 {
+      compatible = "qcom,sm8150-ethqos";
+      reg = <0x0 0x00020000 0x0 0x10000>,
+            <0x0 0x00036000 0x0 0x100>;
+      reg-names = "stmmaceth", "rgmii";
+      clock-names = "stmmaceth", "pclk", "ptp_ref", "rgmii";
+      clocks = <&gcc GCC_EMAC_AXI_CLK>,
+               <&gcc GCC_EMAC_SLV_AHB_CLK>,
+               <&gcc GCC_EMAC_PTP_CLK>,
+               <&gcc GCC_EMAC_RGMII_CLK>;
+      interrupts = <GIC_SPI 689 IRQ_TYPE_LEVEL_HIGH>,
+                   <GIC_SPI 699 IRQ_TYPE_LEVEL_HIGH>;
+      interrupt-names = "macirq", "eth_lpi";
+
+      power-domains = <&gcc EMAC_GDSC>;
+      resets = <&gcc GCC_EMAC_BCR>;
+      iommus = <&apps_smmu 0x3C0 0x0>;
+
+      snps,tso;
+      rx-fifo-depth = <4096>;
+      tx-fifo-depth = <4096>;
+
+      snps,reset-gpio = <&tlmm 79 GPIO_ACTIVE_LOW>;
+      snps,reset-active-low;
+      snps,reset-delays-us = <0 11000 70000>;
+
+      snps,mtl-rx-config = <&mtl_rx_setup>;
+      snps,mtl-tx-config = <&mtl_tx_setup>;
+
+      pinctrl-names = "default";
+      pinctrl-0 = <&ethernet_defaults>;
+
+      phy-handle = <&rgmii_phy>;
+      phy-mode = "rgmii";
+      max-speed = <1000>;
+
+      mdio {
+        #address-cells = <0x1>;
+        #size-cells = <0x0>;
+
+        compatible = "snps,dwmac-mdio";
+        rgmii_phy: phy@7 {
+          reg = <0x7>;
+          interrupt-parent = <&tlmm>;
+          interrupts-extended = <&tlmm 124 IRQ_TYPE_EDGE_FALLING>;
+          device_type = "ethernet-phy";
+          compatible = "ethernet-phy-ieee802.3-c22";
+        };
+      };
+    };
-- 
2.37.1

