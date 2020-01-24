Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D7DA148B8B
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 16:56:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389474AbgAXP4G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 10:56:06 -0500
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:48946 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389209AbgAXP4G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 10:56:06 -0500
Received: from pps.filterd (m0046661.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00OFsA3K021731;
        Fri, 24 Jan 2020 16:55:48 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=STMicroelectronics;
 bh=RIPX9tQ6Lx1BfiUExNjFXUscs7twuO2vNYhbgRvSd8U=;
 b=POqUkIjbaAIZKnAXw27HwWxHmjXMk5M6Pg4DQW2WacPV7XVy9iUvsurAVVJLYALPIzcY
 RNBNcKF0ENVJsLh8UTQSn8zhk+5HiuNOshc3gBm++YicbOx//trDoFbNThtqrbFAvhQM
 lJ85TbLOd3MyCCXdursG097wN3wQ6wToLEaCpd6UQGZdx3OQpUP3JKQ/OXh/4quxpdVG
 Gd7dWWHx5CyUqitEnHrabQrIto/IeQhF0M07f/xS5Swsn1QHc98y1EGehOrZtrEztJWm
 q7NgNjgBtkltPwEWDHOEBNacHz9x1s7Nw2HlHDH3OW5pnTZqAnj9lonTz6On0q+rkwEH lw== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 2xksspgksj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Jan 2020 16:55:48 +0100
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 4936910002A;
        Fri, 24 Jan 2020 16:55:45 +0100 (CET)
Received: from Webmail-eu.st.com (sfhdag3node3.st.com [10.75.127.9])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id E8D702B1867;
        Fri, 24 Jan 2020 16:55:44 +0100 (CET)
Received: from localhost (10.75.127.47) by SFHDAG3NODE3.st.com (10.75.127.9)
 with Microsoft SMTP Server (TLS) id 15.0.1347.2; Fri, 24 Jan 2020 16:55:44
 +0100
From:   Benjamin Gaignard <benjamin.gaignard@st.com>
To:     <wg@grandegger.com>, <mkl@pengutronix.de>, <davem@davemloft.net>,
        <robh+dt@kernel.org>, <mark.rutland@arm.com>,
        <sriram.dash@samsung.com>
CC:     <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@st.com>
Subject: [PATCH] dt-bindings: net: can: Convert M_CAN to json-schema
Date:   Fri, 24 Jan 2020 16:55:42 +0100
Message-ID: <20200124155542.2053-1-benjamin.gaignard@st.com>
X-Mailer: git-send-email 2.15.0
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.75.127.47]
X-ClientProxiedBy: SFHDAG5NODE3.st.com (10.75.127.15) To SFHDAG3NODE3.st.com
 (10.75.127.9)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-24_05:2020-01-24,2020-01-24 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert M_CAN bindings to json-schema

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@st.com>
---
 .../bindings/net/can/can-transceiver.txt           |  24 ----
 .../devicetree/bindings/net/can/m_can.txt          |  75 ----------
 .../devicetree/bindings/net/can/m_can.yaml         | 151 +++++++++++++++++++++
 3 files changed, 151 insertions(+), 99 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/can/can-transceiver.txt
 delete mode 100644 Documentation/devicetree/bindings/net/can/m_can.txt
 create mode 100644 Documentation/devicetree/bindings/net/can/m_can.yaml

diff --git a/Documentation/devicetree/bindings/net/can/can-transceiver.txt b/Documentation/devicetree/bindings/net/can/can-transceiver.txt
deleted file mode 100644
index 0011f53ff159..000000000000
--- a/Documentation/devicetree/bindings/net/can/can-transceiver.txt
+++ /dev/null
@@ -1,24 +0,0 @@
-Generic CAN transceiver Device Tree binding
-------------------------------
-
-CAN transceiver typically limits the max speed in standard CAN and CAN FD
-modes. Typically these limitations are static and the transceivers themselves
-provide no way to detect this limitation at runtime. For this situation,
-the "can-transceiver" node can be used.
-
-Required Properties:
- max-bitrate:	a positive non 0 value that determines the max
-		speed that CAN/CAN-FD can run. Any other value
-		will be ignored.
-
-Examples:
-
-Based on Texas Instrument's TCAN1042HGV CAN Transceiver
-
-m_can0 {
-	....
-	can-transceiver {
-		max-bitrate = <5000000>;
-	};
-	...
-};
diff --git a/Documentation/devicetree/bindings/net/can/m_can.txt b/Documentation/devicetree/bindings/net/can/m_can.txt
deleted file mode 100644
index ed614383af9c..000000000000
--- a/Documentation/devicetree/bindings/net/can/m_can.txt
+++ /dev/null
@@ -1,75 +0,0 @@
-Bosch MCAN controller Device Tree Bindings
--------------------------------------------------
-
-Required properties:
-- compatible		: Should be "bosch,m_can" for M_CAN controllers
-- reg			: physical base address and size of the M_CAN
-			  registers map and Message RAM
-- reg-names		: Should be "m_can" and "message_ram"
-- interrupts		: Should be the interrupt number of M_CAN interrupt
-			  line 0 and line 1, could be same if sharing
-			  the same interrupt.
-- interrupt-names	: Should contain "int0" and "int1"
-- clocks		: Clocks used by controller, should be host clock
-			  and CAN clock.
-- clock-names		: Should contain "hclk" and "cclk"
-- pinctrl-<n>		: Pinctrl states as described in bindings/pinctrl/pinctrl-bindings.txt
-- pinctrl-names 	: Names corresponding to the numbered pinctrl states
-- bosch,mram-cfg	: Message RAM configuration data.
-			  Multiple M_CAN instances can share the same Message
-			  RAM and each element(e.g Rx FIFO or Tx Buffer and etc)
-			  number in Message RAM is also configurable,
-			  so this property is telling driver how the shared or
-			  private Message RAM are used by this M_CAN controller.
-
-			  The format should be as follows:
-			  <offset sidf_elems xidf_elems rxf0_elems rxf1_elems
-			   rxb_elems txe_elems txb_elems>
-			  The 'offset' is an address offset of the Message RAM
-			  where the following elements start from. This is
-			  usually set to 0x0 if you're using a private Message
-			  RAM. The remain cells are used to specify how many
-			  elements are used for each FIFO/Buffer.
-
-			  M_CAN includes the following elements according to user manual:
-			  11-bit Filter	0-128 elements / 0-128 words
-			  29-bit Filter	0-64 elements / 0-128 words
-			  Rx FIFO 0	0-64 elements / 0-1152 words
-			  Rx FIFO 1	0-64 elements / 0-1152 words
-			  Rx Buffers	0-64 elements / 0-1152 words
-			  Tx Event FIFO	0-32 elements / 0-64 words
-			  Tx Buffers	0-32 elements / 0-576 words
-
-			  Please refer to 2.4.1 Message RAM Configuration in
-			  Bosch M_CAN user manual for details.
-
-Optional Subnode:
-- can-transceiver	: Can-transceiver subnode describing maximum speed
-			  that can be used for CAN/CAN-FD modes. See
-			  Documentation/devicetree/bindings/net/can/can-transceiver.txt
-			  for details.
-Example:
-SoC dtsi:
-m_can1: can@20e8000 {
-	compatible = "bosch,m_can";
-	reg = <0x020e8000 0x4000>, <0x02298000 0x4000>;
-	reg-names = "m_can", "message_ram";
-	interrupts = <0 114 0x04>,
-		     <0 114 0x04>;
-	interrupt-names = "int0", "int1";
-	clocks = <&clks IMX6SX_CLK_CANFD>,
-		 <&clks IMX6SX_CLK_CANFD>;
-	clock-names = "hclk", "cclk";
-	bosch,mram-cfg = <0x0 0 0 32 0 0 0 1>;
-};
-
-Board dts:
-&m_can1 {
-	pinctrl-names = "default";
-	pinctrl-0 = <&pinctrl_m_can1>;
-	status = "enabled";
-
-	can-transceiver {
-		max-bitrate = <5000000>;
-	};
-};
diff --git a/Documentation/devicetree/bindings/net/can/m_can.yaml b/Documentation/devicetree/bindings/net/can/m_can.yaml
new file mode 100644
index 000000000000..efdbed81af29
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/can/m_can.yaml
@@ -0,0 +1,151 @@
+# SPDX-License-Identifier: GPL-2.0
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/can/m_can.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Bosch MCAN controller Bindings
+
+description: Bosch MCAN controller for CAN bus
+
+maintainers:
+  -  Sriram Dash <sriram.dash@samsung.com>
+
+properties:
+  compatible:
+    const: bosch,m_can
+
+  reg:
+    items:
+      - description: M_CAN registers map
+      - description: message RAM
+
+  reg-names:
+    items:
+      - const: m_can
+      - const: message_ram
+
+  interrupts:
+    items:
+      - description: interrupt line0
+      - description: interrupt line1
+    minItems: 1
+    maxItems: 2
+
+  interrupt-names:
+    items:
+      - const: int0
+      - const: int1
+    minItems: 1
+    maxItems: 2
+
+  clocks:
+    items:
+      - description: peripheral clock
+      - description: bus clock
+
+  clock-names:
+    items:
+      - const: hclk
+      - const: cclk
+
+  bosch,mram-cfg:
+    description: |
+                 Message RAM configuration data.
+                 Multiple M_CAN instances can share the same Message RAM
+                 and each element(e.g Rx FIFO or Tx Buffer and etc) number
+                 in Message RAM is also configurable, so this property is
+                 telling driver how the shared or private Message RAM are
+                 used by this M_CAN controller.
+
+                 The format should be as follows:
+                 <offset sidf_elems xidf_elems rxf0_elems rxf1_elems rxb_elems txe_elems txb_elems>
+                 The 'offset' is an address offset of the Message RAM where
+                 the following elements start from. This is usually set to
+                 0x0 if you're using a private Message RAM. The remain cells
+                 are used to specify how many elements are used for each FIFO/Buffer.
+
+                 M_CAN includes the following elements according to user manual:
+                 11-bit Filter	0-128 elements / 0-128 words
+                 29-bit Filter	0-64 elements / 0-128 words
+                 Rx FIFO 0	0-64 elements / 0-1152 words
+                 Rx FIFO 1	0-64 elements / 0-1152 words
+                 Rx Buffers	0-64 elements / 0-1152 words
+                 Tx Event FIFO	0-32 elements / 0-64 words
+                 Tx Buffers	0-32 elements / 0-576 words
+
+                 Please refer to 2.4.1 Message RAM Configuration in Bosch
+                 M_CAN user manual for details.
+    allOf:
+      - $ref: /schemas/types.yaml#/definitions/int32-matrix
+      - items:
+         items:
+           - description: The 'offset' is an address offset of the Message RAM
+                          where the following elements start from. This is usually
+                          set to 0x0 if you're using a private Message RAM.
+             default: 0
+           - description: 11-bit Filter 0-128 elements / 0-128 words
+             minimum: 0
+             maximum: 128
+           - description: 29-bit Filter 0-64 elements / 0-128 words
+             minimum: 0
+             maximum: 64
+           - description: Rx FIFO 0 0-64 elements / 0-1152 words
+             minimum: 0
+             maximum: 64
+           - description: Rx FIFO 1 0-64 elements / 0-1152 words
+             minimum: 0
+             maximum: 64
+           - description: Rx Buffers 0-64 elements / 0-1152 words
+             minimum: 0
+             maximum: 64
+           - description: Tx Event FIFO 0-32 elements / 0-64 words
+             minimum: 0
+             maximum: 32
+           - description: Tx Buffers 0-32 elements / 0-576 words
+             minimum: 0
+             maximum: 32
+        maxItems: 1
+
+  can-transceiver:
+    type: object
+
+    properties:
+      max-bitrate:
+        $ref: /schemas/types.yaml#/definitions/uint32
+        description: a positive non 0 value that determines the max speed that
+                     CAN/CAN-FD can run.
+        minimum: 1
+
+required:
+  - compatible
+  - reg
+  - reg-names
+  - interrupts
+  - interrupt-names
+  - clocks
+  - clock-names
+  - bosch,mram-cfg
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/clock/imx6sx-clock.h>
+    can@20e8000 {
+      compatible = "bosch,m_can";
+      reg = <0x020e8000 0x4000>, <0x02298000 0x4000>;
+      reg-names = "m_can", "message_ram";
+      interrupts = <0 114 0x04>, <0 114 0x04>;
+      interrupt-names = "int0", "int1";
+      clocks = <&clks IMX6SX_CLK_CANFD>,
+               <&clks IMX6SX_CLK_CANFD>;
+      clock-names = "hclk", "cclk";
+      bosch,mram-cfg = <0x0 0 0 32 0 0 0 1>;
+
+      can-transceiver {
+        max-bitrate = <5000000>;
+      };
+    };
+
+...
-- 
2.15.0

