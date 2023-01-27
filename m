Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8514D67EB2B
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 17:42:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235023AbjA0QmP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 11:42:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234991AbjA0QmK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 11:42:10 -0500
Received: from mx07-00178001.pphosted.com (mx08-00178001.pphosted.com [91.207.212.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFD137CCA5;
        Fri, 27 Jan 2023 08:42:07 -0800 (PST)
Received: from pps.filterd (m0046660.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30RFGlc5006249;
        Fri, 27 Jan 2023 17:41:26 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=selector1;
 bh=fHgwXmERSKkKo5JYYoQLqx8MKq2fQD94JofDAVji+4o=;
 b=NJIq0w/welBiBSOAYRU1y2ykNETJYe+YhxSKLu2crVMoAeOL7kZ6qcDFc5lJ/Fiqt1VU
 4EINAb58vv8ZiuJozOE0MASlhPMTZOzS3QCOFu+A4eZ+oaI1MoiiKDnWNK0zHdOiU9JF
 y9ziZmzP3tsQdS1VzeGVFVSntsr6TYLgrH8mR3TcSxBIQR75Wtl6aoQZsL2x7mA+uV6M
 I2Xx8msO9ETdwjT+GF9yU0ieS+aNmeKZyk9Nl9o6PV3cWniOE5OBCwnH3GAN1J8umNO3
 FNDgA6uiLrwTyY/FdQS46evHTI0QzJxvK9e2tZNjUfabV6WS8onV3uUnjvQ0H5RuuqS6 MQ== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com (PPS) with ESMTPS id 3nbykcxq8e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Jan 2023 17:41:26 +0100
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 36957100038;
        Fri, 27 Jan 2023 17:41:23 +0100 (CET)
Received: from Webmail-eu.st.com (shfdag1node1.st.com [10.75.129.69])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 2B54821D3FB;
        Fri, 27 Jan 2023 17:41:23 +0100 (CET)
Received: from localhost (10.201.21.177) by SHFDAG1NODE1.st.com (10.75.129.69)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.13; Fri, 27 Jan
 2023 17:41:22 +0100
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
        Gatien Chevallier <gatien.chevallier@foss.st.com>
Subject: [PATCH v3 2/6] dt-bindings: treewide: add feature-domains description in binding files
Date:   Fri, 27 Jan 2023 17:40:36 +0100
Message-ID: <20230127164040.1047583-3-gatien.chevallier@foss.st.com>
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

feature-domains is an optional property that allows a peripheral to
refer to one or more feature domain controller(s).

Description of this property is added to all peripheral binding files of
the peripheral under the STM32 System Bus. It allows an accurate
representation of the hardware, where various peripherals are connected
to this firewall bus. The firewall can then check the peripheral accesses
before allowing it to probe.

Signed-off-by: Gatien Chevallier <gatien.chevallier@foss.st.com>
---

Patch not present in V1 and V2.

 Documentation/devicetree/bindings/crypto/st,stm32-hash.yaml | 5 +++++
 Documentation/devicetree/bindings/dma/st,stm32-dma.yaml     | 5 +++++
 Documentation/devicetree/bindings/dma/st,stm32-dmamux.yaml  | 5 +++++
 Documentation/devicetree/bindings/i2c/st,stm32-i2c.yaml     | 5 +++++
 Documentation/devicetree/bindings/iio/adc/st,stm32-adc.yaml | 5 +++++
 .../devicetree/bindings/iio/adc/st,stm32-dfsdm-adc.yaml     | 5 +++++
 Documentation/devicetree/bindings/iio/dac/st,stm32-dac.yaml | 5 +++++
 Documentation/devicetree/bindings/media/st,stm32-cec.yaml   | 5 +++++
 Documentation/devicetree/bindings/media/st,stm32-dcmi.yaml  | 5 +++++
 .../bindings/memory-controllers/st,stm32-fmc2-ebi.yaml      | 5 +++++
 Documentation/devicetree/bindings/mfd/st,stm32-lptimer.yaml | 5 +++++
 Documentation/devicetree/bindings/mfd/st,stm32-timers.yaml  | 6 ++++++
 Documentation/devicetree/bindings/mmc/arm,pl18x.yaml        | 5 +++++
 Documentation/devicetree/bindings/net/stm32-dwmac.yaml      | 5 +++++
 .../devicetree/bindings/phy/phy-stm32-usbphyc.yaml          | 5 +++++
 .../devicetree/bindings/regulator/st,stm32-vrefbuf.yaml     | 5 +++++
 Documentation/devicetree/bindings/rng/st,stm32-rng.yaml     | 5 +++++
 Documentation/devicetree/bindings/serial/st,stm32-uart.yaml | 5 +++++
 Documentation/devicetree/bindings/sound/st,stm32-i2s.yaml   | 5 +++++
 Documentation/devicetree/bindings/sound/st,stm32-sai.yaml   | 5 +++++
 .../devicetree/bindings/sound/st,stm32-spdifrx.yaml         | 5 +++++
 Documentation/devicetree/bindings/spi/st,stm32-qspi.yaml    | 5 +++++
 Documentation/devicetree/bindings/spi/st,stm32-spi.yaml     | 5 +++++
 Documentation/devicetree/bindings/usb/dwc2.yaml             | 5 +++++
 24 files changed, 121 insertions(+)

diff --git a/Documentation/devicetree/bindings/crypto/st,stm32-hash.yaml b/Documentation/devicetree/bindings/crypto/st,stm32-hash.yaml
index 4ccb335e8063..cb2ad7d5fdb5 100644
--- a/Documentation/devicetree/bindings/crypto/st,stm32-hash.yaml
+++ b/Documentation/devicetree/bindings/crypto/st,stm32-hash.yaml
@@ -41,6 +41,11 @@ properties:
     maximum: 2
     default: 0
 
+  feature-domains:
+    $ref: /schemas/feature-controllers/feature-domain-controller.yaml#/properties/feature-domains
+    minItems: 1
+    maxItems: 3
+
 required:
   - compatible
   - reg
diff --git a/Documentation/devicetree/bindings/dma/st,stm32-dma.yaml b/Documentation/devicetree/bindings/dma/st,stm32-dma.yaml
index 158c791d7caa..3df6c3c998bc 100644
--- a/Documentation/devicetree/bindings/dma/st,stm32-dma.yaml
+++ b/Documentation/devicetree/bindings/dma/st,stm32-dma.yaml
@@ -82,6 +82,11 @@ properties:
     description: if defined, it indicates that the controller
       supports memory-to-memory transfer
 
+  feature-domains:
+    $ref: /schemas/feature-controllers/feature-domain-controller.yaml#/properties/feature-domains
+    minItems: 1
+    maxItems: 3
+
 required:
   - compatible
   - reg
diff --git a/Documentation/devicetree/bindings/dma/st,stm32-dmamux.yaml b/Documentation/devicetree/bindings/dma/st,stm32-dmamux.yaml
index 3e0b82d277ca..73a06651ec94 100644
--- a/Documentation/devicetree/bindings/dma/st,stm32-dmamux.yaml
+++ b/Documentation/devicetree/bindings/dma/st,stm32-dmamux.yaml
@@ -28,6 +28,11 @@ properties:
   resets:
     maxItems: 1
 
+  feature-domains:
+    $ref: /schemas/feature-controllers/feature-domain-controller.yaml#/properties/feature-domains
+    minItems: 1
+    maxItems: 3
+
 required:
   - compatible
   - reg
diff --git a/Documentation/devicetree/bindings/i2c/st,stm32-i2c.yaml b/Documentation/devicetree/bindings/i2c/st,stm32-i2c.yaml
index bf396e9466aa..126576200e1f 100644
--- a/Documentation/devicetree/bindings/i2c/st,stm32-i2c.yaml
+++ b/Documentation/devicetree/bindings/i2c/st,stm32-i2c.yaml
@@ -99,6 +99,11 @@ properties:
 
   wakeup-source: true
 
+  feature-domains:
+    $ref: /schemas/feature-controllers/feature-domain-controller.yaml#/properties/feature-domains
+    minItems: 1
+    maxItems: 3
+
 required:
   - compatible
   - reg
diff --git a/Documentation/devicetree/bindings/iio/adc/st,stm32-adc.yaml b/Documentation/devicetree/bindings/iio/adc/st,stm32-adc.yaml
index 1c340c95df16..c68b7b0e1903 100644
--- a/Documentation/devicetree/bindings/iio/adc/st,stm32-adc.yaml
+++ b/Documentation/devicetree/bindings/iio/adc/st,stm32-adc.yaml
@@ -93,6 +93,11 @@ properties:
   '#size-cells':
     const: 0
 
+  feature-domains:
+    $ref: /schemas/feature-controllers/feature-domain-controller.yaml#/properties/feature-domains
+    minItems: 1
+    maxItems: 3
+
 allOf:
   - if:
       properties:
diff --git a/Documentation/devicetree/bindings/iio/adc/st,stm32-dfsdm-adc.yaml b/Documentation/devicetree/bindings/iio/adc/st,stm32-dfsdm-adc.yaml
index 1970503389aa..d01f60765e48 100644
--- a/Documentation/devicetree/bindings/iio/adc/st,stm32-dfsdm-adc.yaml
+++ b/Documentation/devicetree/bindings/iio/adc/st,stm32-dfsdm-adc.yaml
@@ -59,6 +59,11 @@ properties:
       If not, SPI CLKOUT frequency will not be accurate.
     maximum: 20000000
 
+  feature-domains:
+    $ref: /schemas/feature-controllers/feature-domain-controller.yaml#/properties/feature-domains
+    minItems: 1
+    maxItems: 3
+
 required:
   - compatible
   - reg
diff --git a/Documentation/devicetree/bindings/iio/dac/st,stm32-dac.yaml b/Documentation/devicetree/bindings/iio/dac/st,stm32-dac.yaml
index 0f1bf1110122..f6fe58d2f9b8 100644
--- a/Documentation/devicetree/bindings/iio/dac/st,stm32-dac.yaml
+++ b/Documentation/devicetree/bindings/iio/dac/st,stm32-dac.yaml
@@ -45,6 +45,11 @@ properties:
   '#size-cells':
     const: 0
 
+  feature-domains:
+    $ref: /schemas/feature-controllers/feature-domain-controller.yaml#/properties/feature-domains
+    minItems: 1
+    maxItems: 3
+
 additionalProperties: false
 
 required:
diff --git a/Documentation/devicetree/bindings/media/st,stm32-cec.yaml b/Documentation/devicetree/bindings/media/st,stm32-cec.yaml
index 7f545a587a39..719f4f38afcf 100644
--- a/Documentation/devicetree/bindings/media/st,stm32-cec.yaml
+++ b/Documentation/devicetree/bindings/media/st,stm32-cec.yaml
@@ -29,6 +29,11 @@ properties:
       - const: cec
       - const: hdmi-cec
 
+  feature-domains:
+    $ref: /schemas/feature-controllers/feature-domain-controller.yaml#/properties/feature-domains
+    minItems: 1
+    maxItems: 3
+
 required:
   - compatible
   - reg
diff --git a/Documentation/devicetree/bindings/media/st,stm32-dcmi.yaml b/Documentation/devicetree/bindings/media/st,stm32-dcmi.yaml
index 6b3e413cedb2..49001646663b 100644
--- a/Documentation/devicetree/bindings/media/st,stm32-dcmi.yaml
+++ b/Documentation/devicetree/bindings/media/st,stm32-dcmi.yaml
@@ -36,6 +36,11 @@ properties:
   resets:
     maxItems: 1
 
+  feature-domains:
+    $ref: /schemas/feature-controllers/feature-domain-controller.yaml#/properties/feature-domains
+    minItems: 1
+    maxItems: 3
+
   port:
     $ref: /schemas/graph.yaml#/$defs/port-base
     unevaluatedProperties: false
diff --git a/Documentation/devicetree/bindings/memory-controllers/st,stm32-fmc2-ebi.yaml b/Documentation/devicetree/bindings/memory-controllers/st,stm32-fmc2-ebi.yaml
index e76ba767dfd2..565e7d2fe164 100644
--- a/Documentation/devicetree/bindings/memory-controllers/st,stm32-fmc2-ebi.yaml
+++ b/Documentation/devicetree/bindings/memory-controllers/st,stm32-fmc2-ebi.yaml
@@ -45,6 +45,11 @@ properties:
       Reflects the memory layout with four integer values per bank. Format:
       <bank-number> 0 <address of the bank> <size>
 
+  feature-domains:
+    $ref: /schemas/feature-controllers/feature-domain-controller.yaml#/properties/feature-domains
+    minItems: 1
+    maxItems: 3
+
 patternProperties:
   "^.*@[0-4],[a-f0-9]+$":
     type: object
diff --git a/Documentation/devicetree/bindings/mfd/st,stm32-lptimer.yaml b/Documentation/devicetree/bindings/mfd/st,stm32-lptimer.yaml
index 27329c5dc38e..9649c672c9a5 100644
--- a/Documentation/devicetree/bindings/mfd/st,stm32-lptimer.yaml
+++ b/Documentation/devicetree/bindings/mfd/st,stm32-lptimer.yaml
@@ -44,6 +44,11 @@ properties:
 
   wakeup-source: true
 
+  feature-domains:
+    $ref: /schemas/feature-controllers/feature-domain-controller.yaml#/properties/feature-domains
+    minItems: 1
+    maxItems: 3
+
   pwm:
     type: object
     additionalProperties: false
diff --git a/Documentation/devicetree/bindings/mfd/st,stm32-timers.yaml b/Documentation/devicetree/bindings/mfd/st,stm32-timers.yaml
index f84e09a5743b..897e805fde49 100644
--- a/Documentation/devicetree/bindings/mfd/st,stm32-timers.yaml
+++ b/Documentation/devicetree/bindings/mfd/st,stm32-timers.yaml
@@ -67,6 +67,12 @@ properties:
   "#size-cells":
     const: 0
 
+  feature-domains:
+    $ref: /schemas/feature-controllers/feature-domain-controller.yaml#/properties/feature-domains
+    minItems: 1
+    maxItems: 3
+
+
   pwm:
     type: object
     additionalProperties: false
diff --git a/Documentation/devicetree/bindings/mmc/arm,pl18x.yaml b/Documentation/devicetree/bindings/mmc/arm,pl18x.yaml
index 1c96da04f0e5..43c546d1a0cd 100644
--- a/Documentation/devicetree/bindings/mmc/arm,pl18x.yaml
+++ b/Documentation/devicetree/bindings/mmc/arm,pl18x.yaml
@@ -78,6 +78,11 @@ properties:
           - const: rx
           - const: tx
 
+  feature-domains:
+    $ref: /schemas/feature-controllers/feature-domain-controller.yaml#/properties/feature-domains
+    minItems: 1
+    maxItems: 3
+
   power-domains: true
 
   resets:
diff --git a/Documentation/devicetree/bindings/net/stm32-dwmac.yaml b/Documentation/devicetree/bindings/net/stm32-dwmac.yaml
index 5c93167b3b41..d39b2efd186a 100644
--- a/Documentation/devicetree/bindings/net/stm32-dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/stm32-dwmac.yaml
@@ -93,6 +93,11 @@ properties:
       select RCC clock instead of ETH_REF_CLK.
     type: boolean
 
+  feature-domains:
+    $ref: /schemas/feature-controllers/feature-domain-controller.yaml#/properties/feature-domains
+    minItems: 1
+    maxItems: 3
+
 required:
   - compatible
   - clocks
diff --git a/Documentation/devicetree/bindings/phy/phy-stm32-usbphyc.yaml b/Documentation/devicetree/bindings/phy/phy-stm32-usbphyc.yaml
index 5b4c915cc9e5..9bd81cde2fa9 100644
--- a/Documentation/devicetree/bindings/phy/phy-stm32-usbphyc.yaml
+++ b/Documentation/devicetree/bindings/phy/phy-stm32-usbphyc.yaml
@@ -55,6 +55,11 @@ properties:
     description: number of clock cells for ck_usbo_48m consumer
     const: 0
 
+  feature-domains:
+    $ref: /schemas/feature-controllers/feature-domain-controller.yaml#/properties/feature-domains
+    minItems: 1
+    maxItems: 3
+
 #Required child nodes:
 
 patternProperties:
diff --git a/Documentation/devicetree/bindings/regulator/st,stm32-vrefbuf.yaml b/Documentation/devicetree/bindings/regulator/st,stm32-vrefbuf.yaml
index c1bf1f90490a..77ac6409ee60 100644
--- a/Documentation/devicetree/bindings/regulator/st,stm32-vrefbuf.yaml
+++ b/Documentation/devicetree/bindings/regulator/st,stm32-vrefbuf.yaml
@@ -30,6 +30,11 @@ properties:
   vdda-supply:
     description: phandle to the vdda input analog voltage.
 
+  feature-domains:
+    $ref: /schemas/feature-controllers/feature-domain-controller.yaml#/properties/feature-domains
+    minItems: 1
+    maxItems: 3
+
 required:
   - compatible
   - reg
diff --git a/Documentation/devicetree/bindings/rng/st,stm32-rng.yaml b/Documentation/devicetree/bindings/rng/st,stm32-rng.yaml
index 187b172d0cca..9f75537e11d0 100644
--- a/Documentation/devicetree/bindings/rng/st,stm32-rng.yaml
+++ b/Documentation/devicetree/bindings/rng/st,stm32-rng.yaml
@@ -30,6 +30,11 @@ properties:
     type: boolean
     description: If set enable the clock detection management
 
+  feature-domains:
+    $ref: /schemas/feature-controllers/feature-domain-controller.yaml#/properties/feature-domains
+    minItems: 1
+    maxItems: 3
+
 required:
   - compatible
   - reg
diff --git a/Documentation/devicetree/bindings/serial/st,stm32-uart.yaml b/Documentation/devicetree/bindings/serial/st,stm32-uart.yaml
index 85876c668f6d..f528f284e448 100644
--- a/Documentation/devicetree/bindings/serial/st,stm32-uart.yaml
+++ b/Documentation/devicetree/bindings/serial/st,stm32-uart.yaml
@@ -77,6 +77,11 @@ properties:
     enum: [1, 2, 4, 8, 12, 14, 16]
     default: 8
 
+  feature-domains:
+    $ref: /schemas/feature-controllers/feature-domain-controller.yaml#/properties/feature-domains
+    minItems: 1
+    maxItems: 3
+
 allOf:
   - $ref: rs485.yaml#
   - $ref: serial.yaml#
diff --git a/Documentation/devicetree/bindings/sound/st,stm32-i2s.yaml b/Documentation/devicetree/bindings/sound/st,stm32-i2s.yaml
index a040d4d31412..aee8b09ec264 100644
--- a/Documentation/devicetree/bindings/sound/st,stm32-i2s.yaml
+++ b/Documentation/devicetree/bindings/sound/st,stm32-i2s.yaml
@@ -61,6 +61,11 @@ properties:
     description: Configure the I2S device as MCLK clock provider.
     const: 0
 
+  feature-domains:
+    $ref: /schemas/feature-controllers/feature-domain-controller.yaml#/properties/feature-domains
+    minItems: 1
+    maxItems: 3
+
 required:
   - compatible
   - "#sound-dai-cells"
diff --git a/Documentation/devicetree/bindings/sound/st,stm32-sai.yaml b/Documentation/devicetree/bindings/sound/st,stm32-sai.yaml
index 56d206f97a96..f16fd41eed02 100644
--- a/Documentation/devicetree/bindings/sound/st,stm32-sai.yaml
+++ b/Documentation/devicetree/bindings/sound/st,stm32-sai.yaml
@@ -48,6 +48,11 @@ properties:
   clock-names:
     maxItems: 3
 
+  feature-domains:
+    $ref: /schemas/feature-controllers/feature-domain-controller.yaml#/properties/feature-domains
+    minItems: 1
+    maxItems: 3
+
 required:
   - compatible
   - reg
diff --git a/Documentation/devicetree/bindings/sound/st,stm32-spdifrx.yaml b/Documentation/devicetree/bindings/sound/st,stm32-spdifrx.yaml
index bc48151b9adb..8b1da025565c 100644
--- a/Documentation/devicetree/bindings/sound/st,stm32-spdifrx.yaml
+++ b/Documentation/devicetree/bindings/sound/st,stm32-spdifrx.yaml
@@ -50,6 +50,11 @@ properties:
   resets:
     maxItems: 1
 
+  feature-domains:
+    $ref: /schemas/feature-controllers/feature-domain-controller.yaml#/properties/feature-domains
+    minItems: 1
+    maxItems: 3
+
 required:
   - compatible
   - "#sound-dai-cells"
diff --git a/Documentation/devicetree/bindings/spi/st,stm32-qspi.yaml b/Documentation/devicetree/bindings/spi/st,stm32-qspi.yaml
index 1eb17f7a4d86..ef75e9aed120 100644
--- a/Documentation/devicetree/bindings/spi/st,stm32-qspi.yaml
+++ b/Documentation/devicetree/bindings/spi/st,stm32-qspi.yaml
@@ -46,6 +46,11 @@ properties:
       - const: tx
       - const: rx
 
+  feature-domains:
+    $ref: /schemas/feature-controllers/feature-domain-controller.yaml#/properties/feature-domains
+    minItems: 1
+    maxItems: 3
+
 required:
   - compatible
   - reg
diff --git a/Documentation/devicetree/bindings/spi/st,stm32-spi.yaml b/Documentation/devicetree/bindings/spi/st,stm32-spi.yaml
index 1cda15f91cc3..6bda605b2ecb 100644
--- a/Documentation/devicetree/bindings/spi/st,stm32-spi.yaml
+++ b/Documentation/devicetree/bindings/spi/st,stm32-spi.yaml
@@ -59,6 +59,11 @@ properties:
       - const: rx
       - const: tx
 
+  feature-domains:
+    $ref: /schemas/feature-controllers/feature-domain-controller.yaml#/properties/feature-domains
+    minItems: 1
+    maxItems: 3
+
 patternProperties:
   "^[a-zA-Z][a-zA-Z0-9,+\\-._]{0,63}@[0-9a-f]+$":
     type: object
diff --git a/Documentation/devicetree/bindings/usb/dwc2.yaml b/Documentation/devicetree/bindings/usb/dwc2.yaml
index 371ba93f3ce5..f5092a2846b4 100644
--- a/Documentation/devicetree/bindings/usb/dwc2.yaml
+++ b/Documentation/devicetree/bindings/usb/dwc2.yaml
@@ -168,6 +168,11 @@ properties:
 
   tpl-support: true
 
+  feature-domains:
+    $ref: /schemas/feature-controllers/feature-domain-controller.yaml#/properties/feature-domains
+    minItems: 1
+    maxItems: 3
+
 dependencies:
   port: [ usb-role-switch ]
   role-switch-default-mode: [ usb-role-switch ]
-- 
2.35.3

