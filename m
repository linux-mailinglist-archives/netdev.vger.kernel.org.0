Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDBC367EB41
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 17:42:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235069AbjA0QmT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 11:42:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235006AbjA0QmL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 11:42:11 -0500
Received: from mx07-00178001.pphosted.com (mx08-00178001.pphosted.com [91.207.212.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCF1E7CC8C;
        Fri, 27 Jan 2023 08:42:08 -0800 (PST)
Received: from pps.filterd (m0046661.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30RECpOp030161;
        Fri, 27 Jan 2023 17:41:26 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=selector1;
 bh=th2tLwr42ahTZJ1iv4VP8LnTeu3dyxVJFUaVFvpn8jc=;
 b=R5MJIHXHOpIWy88Nn531oxNSe1SQAOsFZIo3S5j9Dh7ehLaGn06gjT5k5e8XQqU8jLYm
 S+gU/H5b0cW1tXC8MhTdpfHyrNvHQ4B01dLauBPpSvHT/vPOWP2qzfREWFsE9vSrl4g8
 Hlp5onquIjg+hKcsab4BsD60Nr5bHPaBdQiOn4XURtTmhh3O9Y7cEbaWjKGrlnA44shu
 RpdOBWNsoD2hh7b9LCIF5q6f0jWk13hu/pozS7UhipATLybl84HJCOvaZHtMKqoSEtti
 T4Q3bUaNilKO5SSh46wSSMrbPQmZCBqecG5D81Q+P4TlOQLJsQBxh+pr14j4ZaCIvvsP Aw== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com (PPS) with ESMTPS id 3najx6xg2n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Jan 2023 17:41:26 +0100
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id E5467100039;
        Fri, 27 Jan 2023 17:41:23 +0100 (CET)
Received: from Webmail-eu.st.com (shfdag1node1.st.com [10.75.129.69])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id DC76E21D3FC;
        Fri, 27 Jan 2023 17:41:23 +0100 (CET)
Received: from localhost (10.201.21.177) by SHFDAG1NODE1.st.com (10.75.129.69)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.13; Fri, 27 Jan
 2023 17:41:23 +0100
From:   Gatien Chevallier <gatien.chevallier@foss.st.com>
To:     <Oleksii_Moisieiev@epam.com>, <gregkh@linuxfoundation.org>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
        <alexandre.torgue@foss.st.com>, <vkoul@kernel.org>,
        <jic23@kernel.org>, <olivier.moysan@foss.st.com>,
        <arnaud.pouliquen@foss.st.com>, <mchehab@kernel.org>,
        <fabrice.gasnier@foss.st.com>, <ulf.hansson@linaro.org>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <dmaengine@vger.kernel.org>,
        <linux-i2c@vger.kernel.org>, <linux-iio@vger.kernel.org>,
        <alsa-devel@alsa-project.org>, <linux-media@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-phy@lists.infradead.org>, <linux-serial@vger.kernel.org>,
        <linux-spi@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Gatien Chevallier <gatien.chevallier@foss.st.com>,
        Loic PALLARDY <loic.pallardy@st.com>
Subject: [PATCH v3 3/6] dt-bindings: bus: add STM32 System Bus
Date:   Fri, 27 Jan 2023 17:40:37 +0100
Message-ID: <20230127164040.1047583-4-gatien.chevallier@foss.st.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20230127164040.1047583-1-gatien.chevallier@foss.st.com>
References: <20230127164040.1047583-1-gatien.chevallier@foss.st.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.201.21.177]
X-ClientProxiedBy: EQNCAS1NODE3.st.com (10.75.129.80) To SHFDAG1NODE1.st.com
 (10.75.129.69)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-27_10,2023-01-27_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document STM32 System Bus. This bus is intended to control firewall
access for the peripherals connected to it.

Signed-off-by: Gatien Chevallier <gatien.chevallier@foss.st.com>
Signed-off-by: Loic PALLARDY <loic.pallardy@st.com>
---

Changes in V2: 
	- Corrected errors highlighted by Rob's robot
	- Re-ordered Signed-off-by tags
	
Changes in V3:
	- Correct #feature-domain-cells
	- Declare 1 as minimum number of arguments for feature-domains property
	in bus subnodes and 3 as maximum.
	- Change example to be a real usecase.

 .../devicetree/bindings/bus/st,sys-bus.yaml   | 127 ++++++++++++++++++
 1 file changed, 127 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/bus/st,sys-bus.yaml

diff --git a/Documentation/devicetree/bindings/bus/st,sys-bus.yaml b/Documentation/devicetree/bindings/bus/st,sys-bus.yaml
new file mode 100644
index 000000000000..c1510784b79b
--- /dev/null
+++ b/Documentation/devicetree/bindings/bus/st,sys-bus.yaml
@@ -0,0 +1,127 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/bus/st,sys-bus.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: STM32 System Bus
+
+description: |
+  The STM32 System Bus is an internal bus to which some internal peripherals
+  are connected. STM32 System Bus integrates a firewall controlling access to each
+  device. This bus prevents non-accessible devices to be probed.
+
+  To see which peripherals are securable, please check the SoC reference manual.
+
+maintainers:
+  - Gatien Chevallier <gatien.chevallier@foss.st.com>
+
+allOf:
+  - $ref: /schemas/feature-controllers/feature-domain-controller.yaml#
+
+properties:
+  compatible:
+    enum:
+      - st,stm32mp13-sys-bus
+      - st,stm32mp15-sys-bus
+
+  reg:
+    maxItems: 1
+
+  "#address-cells":
+    const: 1
+
+  "#size-cells":
+    const: 1
+
+  "#feature-domain-cells":
+    const: 1
+
+  ranges: true
+
+  feature-domain-controller: true
+
+patternProperties:
+  "^.*@[0-9a-f]+$":
+    description: Devices attached to system bus
+    type: object
+    properties:
+      feature-domains:
+        $ref: /schemas/feature-controllers/feature-domain-controller.yaml#/properties/feature-domains
+        minItems: 1
+        maxItems: 3
+
+required:
+  - compatible
+  - reg
+  - "#address-cells"
+  - "#size-cells"
+  - feature-domain-controller
+  - "#feature-domain-cells"
+  - ranges
+
+additionalProperties: false
+
+examples:
+  - |
+    // In this example, the rng1 device refers to etzpc as its domain controller.
+    // Same goes for fmc.
+    // Access rights are verified before creating devices.
+
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+    #include <dt-bindings/clock/stm32mp1-clks.h>
+    #include <dt-bindings/reset/stm32mp1-resets.h>
+
+    etzpc: bus@5c007000 {
+        compatible = "st,stm32mp15-sys-bus";
+        reg = <0x5c007000 0x400>;
+        #address-cells = <1>;
+        #size-cells = <1>;
+        ranges;
+        feature-domain-controller;
+        #feature-domain-cells = <1>;
+
+        rng1: rng@54003000 {
+          compatible = "st,stm32-rng";
+          reg = <0x54003000 0x400>;
+          clocks = <&rcc RNG1_K>;
+          resets = <&rcc RNG1_R>;
+          feature-domains = <&etzpc 7>;
+          status = "disabled";
+        };
+
+        fmc: memory-controller@58002000 {
+          #address-cells = <2>;
+          #size-cells = <1>;
+          compatible = "st,stm32mp1-fmc2-ebi";
+          reg = <0x58002000 0x1000>;
+          clocks = <&rcc FMC_K>;
+          resets = <&rcc FMC_R>;
+          feature-domains = <&etzpc 91>;
+          status = "disabled";
+
+          ranges = <0 0 0x60000000 0x04000000>, /* EBI CS 1 */
+                   <1 0 0x64000000 0x04000000>, /* EBI CS 2 */
+                   <2 0 0x68000000 0x04000000>, /* EBI CS 3 */
+                   <3 0 0x6c000000 0x04000000>, /* EBI CS 4 */
+                   <4 0 0x80000000 0x10000000>; /* NAND */
+
+          nand-controller@4,0 {
+            #address-cells = <1>;
+            #size-cells = <0>;
+            compatible = "st,stm32mp1-fmc2-nfc";
+            reg = <4 0x00000000 0x1000>,
+                  <4 0x08010000 0x1000>,
+                  <4 0x08020000 0x1000>,
+                  <4 0x01000000 0x1000>,
+                  <4 0x09010000 0x1000>,
+                  <4 0x09020000 0x1000>;
+            interrupts = <GIC_SPI 48 IRQ_TYPE_LEVEL_HIGH>;
+            dmas = <&mdma1 20 0x2 0x12000a02 0x0 0x0>,
+                   <&mdma1 20 0x2 0x12000a08 0x0 0x0>,
+                   <&mdma1 21 0x2 0x12000a0a 0x0 0x0>;
+            dma-names = "tx", "rx", "ecc";
+            status = "disabled";
+          };
+        };
+    };
-- 
2.35.3

