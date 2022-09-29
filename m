Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C67B35EED88
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 08:05:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234940AbiI2GFX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 02:05:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234861AbiI2GFD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 02:05:03 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89FC46384
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 23:05:00 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id u59-20020a17090a51c100b00205d3c44162so4959969pjh.2
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 23:05:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=euoSuVgnw+yxsONpPgybf7DkiRoua4Vw0QEswYUTaXg=;
        b=VJyw4UFZw/fGkRIeDK7yU2jaWGuuDRk1wSnttBccAt9I/+RBREOSBh2efNH4tPp7v5
         6u7XmuzFgbKIU4elAqmgOH4VNr/6WyG8Tvmyz3GB9feCyDJkZg4BRHeNJT6S+3E2RjxB
         QJmgo6r5gd/ycKOQQYQG1HkhphhwBIXTbabLeskJtn+l3pV/K6XM8/m2Z2SeflbMulAX
         GDF+UxM9/IRxPg5n0RE7VnzIQ2di7D7EXQmH574kNTGV8385potSsrQ5+FXmJ7apDcPB
         iDfFi6C+Bbr/yq2WgD0QSLNRs9eTmAazoQazzvyy40T25w8LcE/XQBoMmoeGV4Sulj4Q
         dN0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=euoSuVgnw+yxsONpPgybf7DkiRoua4Vw0QEswYUTaXg=;
        b=rV9xZog5rDTcJw0YuNP/9YTm1E9hJ8cFEUM7bUXKNw3whI0o+3IVdyrXF56eJrcvlK
         ITwaNn1TL/mKTQJkgjXz2HZtRxvDUOOBWF7yhn6VP29U+K4eA0pUdxoHImhsrZk59Nqd
         dzsm3VJcwGRIZ9r/WykCMu4T97UAUCvi3uCIi/bnVkdHUgqlEQMEdeOHfqChtFJxHCXo
         1gs+7aDWYLu1IKwyQai0FOiVQf1yXsEJnF+yfvVp/qpzI6dm6mY6pn8JLt26n7TIoigX
         4umx2d8hWuutbCb/GfLnqDA+68K8bJE/GY6YO+8zaJ7VdcP9awCU54/E/uOMfNXc9ZXp
         DSIg==
X-Gm-Message-State: ACrzQf2fFdwI1JCMJWdi6SJment+ptaDx9eddqkJ1KIqSIR0viYAg4Ti
        mYkHRV3rlMBbVr9F3RLgEeVCuA==
X-Google-Smtp-Source: AMsMyM5kwK9Y21f5/IKbTxCwobRIQ94oUGUz8q/ZVKnqgiAnwwyK7KX00K8D8m0Uze+ZTFVqmHL4JQ==
X-Received: by 2002:a17:902:d2c8:b0:178:6f5b:f905 with SMTP id n8-20020a170902d2c800b001786f5bf905mr1841546plc.2.1664431499979;
        Wed, 28 Sep 2022 23:04:59 -0700 (PDT)
Received: from localhost.localdomain ([2401:4900:1f3b:3adb:24f8:ac24:2282:1dc7])
        by smtp.gmail.com with ESMTPSA id i1-20020aa796e1000000b00540c3b6f32fsm5037681pfq.49.2022.09.28.23.04.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 23:04:59 -0700 (PDT)
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
To:     devicetree@vger.kernel.org
Cc:     linux-arm-msm@vger.kernel.org, agross@kernel.org,
        bhupesh.sharma@linaro.org, bhupesh.linux@gmail.com,
        linux-kernel@vger.kernel.org, robh+dt@kernel.org,
        krzysztof.kozlowski@linaro.org, netdev@vger.kernel.org,
        Bjorn Andersson <andersson@kernel.org>,
        Rob Herring <robh@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        David Miller <davem@davemloft.net>
Subject: [PATCH v2 3/4] dt-bindings: net: qcom,ethqos: Convert bindings to yaml
Date:   Thu, 29 Sep 2022 11:34:04 +0530
Message-Id: <20220929060405.2445745-4-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220929060405.2445745-1-bhupesh.sharma@linaro.org>
References: <20220929060405.2445745-1-bhupesh.sharma@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert Qualcomm ETHQOS Ethernet devicetree binding to YAML.

While at it, also add Qualcomm Ethernet ETHQOS compatible checks
in snps,dwmac YAML binding document.

Cc: Bjorn Andersson <andersson@kernel.org>
Cc: Rob Herring <robh@kernel.org>
Cc: Vinod Koul <vkoul@kernel.org>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
---
 .../devicetree/bindings/net/qcom,ethqos.txt   |  66 --------
 .../devicetree/bindings/net/qcom,ethqos.yaml  | 145 ++++++++++++++++++
 2 files changed, 145 insertions(+), 66 deletions(-)
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
index 000000000000..d3d8f6799d18
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/qcom,ethqos.yaml
@@ -0,0 +1,145 @@
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
+  - $ref: snps,dwmac.yaml#
+
+properties:
+  compatible:
+    enum:
+      - qcom,qcs404-ethqos
+      - qcom,sm8150-ethqos
+
+  reg:
+    maxItems: 2
+
+  reg-names:
+    items:
+      - const: stmmaceth
+      - const: rgmii
+
+  interrupts:
+    items:
+      - description: Combined signal for various interrupt events
+      - description: The interrupt that occurs when Rx exits the LPI state
+
+  interrupt-names:
+    items:
+      - const: macirq
+      - const: eth_lpi
+
+  clocks:
+    maxItems: 4
+
+  clock-names:
+    items:
+      - const: stmmaceth
+      - const: pclk
+      - const: ptp_ref
+      - const: rgmii
+
+  iommus:
+    maxItems: 1
+
+  mdio:
+    $ref: mdio.yaml#
+    unevaluatedProperties: false
+
+    properties:
+      compatible:
+        const: snps,dwmac-mdio
+
+  phy-handle:
+    maxItems: 1
+
+  phy-mode:
+    maxItems: 1
+
+  snps,reset-gpio:
+    maxItems: 1
+
+  power-domains:
+    maxItems: 1
+
+  resets:
+    maxItems: 1
+
+  rx-fifo-depth:
+    $ref: /schemas/types.yaml#/definitions/uint32
+
+  tx-fifo-depth:
+    $ref: /schemas/types.yaml#/definitions/uint32
+
+  snps,tso:
+    type: boolean
+    description: Enables the TSO feature (otherwise managed by MAC HW capability register).
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
+    #include <dt-bindings/clock/qcom,gcc-qcs404.h>
+    #include <dt-bindings/gpio/gpio.h>
+
+    ethernet: ethernet@7a80000 {
+      compatible = "qcom,qcs404-ethqos";
+      reg = <0x07a80000 0x10000>,
+            <0x07a96000 0x100>;
+      reg-names = "stmmaceth", "rgmii";
+      clock-names = "stmmaceth", "pclk", "ptp_ref", "rgmii";
+      clocks = <&gcc GCC_ETH_AXI_CLK>,
+               <&gcc GCC_ETH_SLAVE_AHB_CLK>,
+               <&gcc GCC_ETH_PTP_CLK>,
+               <&gcc GCC_ETH_RGMII_CLK>;
+      interrupts = <GIC_SPI 56 IRQ_TYPE_LEVEL_HIGH>,
+                   <GIC_SPI 55 IRQ_TYPE_LEVEL_HIGH>;
+      interrupt-names = "macirq", "eth_lpi";
+
+      rx-fifo-depth = <4096>;
+      tx-fifo-depth = <4096>;
+
+      snps,tso;
+      snps,reset-gpio = <&tlmm 60 GPIO_ACTIVE_LOW>;
+      snps,reset-active-low;
+      snps,reset-delays-us = <0 10000 10000>;
+
+      pinctrl-names = "default";
+      pinctrl-0 = <&ethernet_defaults>;
+
+      phy-handle = <&phy1>;
+      phy-mode = "rgmii";
+      mdio {
+        #address-cells = <0x1>;
+        #size-cells = <0x0>;
+
+        compatible = "snps,dwmac-mdio";
+        phy1: phy@4 {
+          compatible = "ethernet-phy-ieee802.3-c22";
+          device_type = "ethernet-phy";
+          reg = <0x4>;
+
+          #phy-cells = <0>;
+        };
+      };
+    };
-- 
2.37.1

