Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C5EF3CCE64
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 09:21:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234890AbhGSHVr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 03:21:47 -0400
Received: from mail-eopbgr80073.outbound.protection.outlook.com ([40.107.8.73]:26246
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234863AbhGSHVq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Jul 2021 03:21:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DQBd27A8SPARkTelmxevxsO+bJMFksD4lgEG3mJiPj53JmTcZpnzw7dR6WEEKyOkbrZGfskmepjMPFEgxhkW0j4KE9IynvycNbZAvLBim6AAShfA1NsGCnVBckjn328cnUgpLfEjt8xvB5nMeY991FTAWPMyH8RpU2+W7d5lqUgR0qAVJPDJzq9e3FBrYFw1h/ZvGCW8ZRi0Eb3h6DDrhhif3JDzMrtB0Bbz8ErcRWx+RN9rZlREAW9/oe+8OXvIDlmn8NXaphmEnFdQZ5ws+vTRdRdLncvIswCB/0Cep7l6DB4Zl79i4wjhxJiV+y37+Op46RL/8nKByP6cyfe+EA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kDGZsKYY41VaFxHIidxc79mUrhrkJJ2Y8OH6oRHHYl8=;
 b=POEhtXab351F6oW02F3i31v7F4KNsY0E93o+rs+4OXhwHw29SVS7JGPPUKFz3f0Fk7pfTrciyEimkf3Qjvl3L0ol+rzHd/0+bwWbAR0D3EUuunv1XnF9Eqsxu65nWV+VZw7AJYwzJOkS/3qYQ24bL+fGis9LgezaeCgGN6I8MKTE3FB3m5k3QJackBtbqDe59xbZtGlk7hHD9U4tpx5cuTDP19i3tERG5nhUJVrVNLU7TRdySIL+yRKhxEMtvjisSLBABlBeNq1TDQ9E0JwmIt2/fKi4T6ZYOBAojBrrGvpW6LzRHZNw8oYqC5dIqzdzQ7rXA0VAft79H3f+sYDJhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kDGZsKYY41VaFxHIidxc79mUrhrkJJ2Y8OH6oRHHYl8=;
 b=srJBqtqB1ZyxksvzUN/QjsOk+zzm2LlzanWEHMGlo6HBZlVO6mrd1xHh3Pglu4jEu5c7Awzp3+csMwOb8Zag0iizcpqM3t0GhZJ8JoHzG5x1SpG6NTNr63TCSLUMJeGP2Nid2vod99U0DOwklTcxwjrKGErPJG0v3apjPN+GWSU=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB7100.eurprd04.prod.outlook.com (2603:10a6:10:127::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Mon, 19 Jul
 2021 07:18:43 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802%9]) with mapi id 15.20.4331.032; Mon, 19 Jul 2021
 07:18:43 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        shawnguo@kernel.org, s.hauer@pengutronix.de, festevam@gmail.com
Cc:     kernel@pengutronix.de, linux-imx@nxp.com, peppe.cavallaro@st.com,
        joabreu@synopsys.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next V1 2/3] dt-bindings: net: imx-dwmac: convert imx-dwmac bindings to yaml
Date:   Mon, 19 Jul 2021 15:18:20 +0800
Message-Id: <20210719071821.31583-3-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210719071821.31583-1-qiangqing.zhang@nxp.com>
References: <20210719071821.31583-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0067.apcprd02.prod.outlook.com
 (2603:1096:4:54::31) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR02CA0067.apcprd02.prod.outlook.com (2603:1096:4:54::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.22 via Frontend Transport; Mon, 19 Jul 2021 07:18:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0b4aec4c-8bc8-421d-2f59-08d94a8570d5
X-MS-TrafficTypeDiagnostic: DB8PR04MB7100:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR04MB71006990E7EC004731C283F7E6E19@DB8PR04MB7100.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F5m6JTsNg19vpfWa3Wc6FBgb4o8AYv3q3qw0bpWQQizofc620b+5fDs0sJ64Q71dbJ1VxUSyLuWnQ2yMkwi3/OznUwSprdN/r/6ZsZZkaAhSQOD9drP5SIw1uKjs9bWOCuzTI9l2J2l4nwwJU4kfcpTITm9QoDVSLwnz0mznz8EEnfrS6pgjlMADzsjjPfNM+rHj2Nkuf497040a86xegh3//xT2Rhc/fRFho2EVkwYVxyArJEjPg4E7Q10Tv8YG7O3PspzZf4onINx656tshZn1d7cD2lXzVTk2oHsuV63TKcSNX8zYGYyfIq/ZuhYv/xnGmeEAU+jCMwCSBN/ESkY/+8llsNbNFZaH70W/7Pz0irWrOJsHuC7eu+Yw6g2unraiHW76ALfB77L+o6iAoTyamkylK15Vc3PSqKwP6toTZPmhci+/WChD3gk7XLTh+D78PkAdqCS+bjH7c1MxWsj+JFYeXy1D47gwly+Q9v1jhtqnwGs0PFJrGVmyAPiUhRCLZPikegqfYUAr/B9WO1XXq5zG0Z/KkzEbEcTd4O4Fth6U+ZZ7/rL1hQIaHE66NvU1grpbVCeLDWsPLkAErqVaF7zdyjD0oST/e0PWHhdLT+/5q5skDYOJWI5NkE5qwGh7ULWMvY3GHH8sBg5HKDzSswdIaWHVMrJ+4BatdgiFyen+BloLlpCJtUjpPpSXQaXJdoJVs6oj9cu0xEhQ64LHLJS1a6WrKFekRDpxlytycx0iD2am+mHXmGbhyhHdW48QfoQacYA6hPhDdXnstY3NnEdhbFiCn29z1xZ45JbiKgFW8XMXOJhcf+cwLHdJ0ByBNOQPGbXBZpBVWMgqVg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(52116002)(1076003)(5660300002)(956004)(2616005)(6512007)(4326008)(7416002)(66476007)(38350700002)(38100700002)(6666004)(26005)(966005)(8676002)(66556008)(8936002)(36756003)(6486002)(66946007)(83380400001)(508600001)(186003)(2906002)(86362001)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NFuvlpJL9H+shnfvi79ya/HelZGBAq1TDjTbK/rmK7MwQdpAUtZ+3sfHfBm6?=
 =?us-ascii?Q?8dhj22itbHM97tmuRO7IC16u+wsVBpL3fyYiXd1AvPg3OzxyQWtapFTWzf+r?=
 =?us-ascii?Q?sEwfhVeEAmPtZgVFeR1WAZQS30xW6g88eS63ndx+k8xyTv8qgDtK0hUx99gP?=
 =?us-ascii?Q?8JzCYsIPVHIb4CnSRmeJ2iEE/GD8WL2LRKO80pJqka1lzKBnc/r57/PcKG01?=
 =?us-ascii?Q?HwGzj/6frSJoaHCfrDQYTuIkZZbTLGJcwhJWgF+bbIr9rBaAKO1/4WwHdN6a?=
 =?us-ascii?Q?C9UCvpsfcUkpwYMNx1haAOrxqlKc9GyajPg5byr68X3c8lcsAp4qEbhwTdTG?=
 =?us-ascii?Q?C0WGc3KE3DNHnPpocyV1B4HKyCtCqdTIv73gNEgPea05mxwjyWHMWnuW2IqV?=
 =?us-ascii?Q?WXpjH9B527+ZBbSmU1VfuPIH/fzP9X6dbTj9DFoVISp29kP0VSfjhxHo0YU1?=
 =?us-ascii?Q?J343a4RJLaQqu0blikFno5JoEwCVSdqBAwdvYmltPesXLLUMXuszZDIap6Er?=
 =?us-ascii?Q?p+/QzvRuSfh+EgjCMglF0wob572tkY2qLq9WL0Y6amkg7VVFHzajpRywFrwi?=
 =?us-ascii?Q?a3L76yfZbCMlvUikBEU3MDS0HhAi6/vgnqTa9u9W/TLUCmUkZPyO/TcAsBxo?=
 =?us-ascii?Q?+wdjVOkYqfjtScTjPpUeR//AKKG9reREUoy9F7iLAs6msVzaScqYdaBECSIR?=
 =?us-ascii?Q?/1cuw/og07dNaBtdrRIDWGTzf1Ax5vKFo0AgwS6gBgt7jK84Q8se/pS4z7kN?=
 =?us-ascii?Q?zXaZi7yFAD5lAq6Vg+kqncspMSSbkBJKYRsab/+easy3DsdxbGkIRP95kWbv?=
 =?us-ascii?Q?UHF+rdoVa0QeJVX/ASF4BQ+kn40zlsDlopw2CFRQqqqnFmTDVkG1jMd9e0z+?=
 =?us-ascii?Q?cHneSRuhR3y7ktVqi3eerzWrWXTqamdjBZpFGNTjTRF4jMyyuflZ/6S5rPzs?=
 =?us-ascii?Q?etC+1V+hvh9/Go9BAyjd9FquBOUeLeLVr4mT62gy2D+apdbt1iwoMOTstDTY?=
 =?us-ascii?Q?3hLQYn7BycFhCby1Ymf0DA3ayTwU0Qcv8xYfwoPpcJdo9uieBzMGfigCtP3n?=
 =?us-ascii?Q?6HylsKIAtsQpENSiCMsrhSlFIgIj+nY/OhK8D4IdOaX0ZZG+adfIKbyHR61D?=
 =?us-ascii?Q?C41rSPpNgm3s9hrp230ISDkoU/5gflcomMDmw8JIhySRbmfc/f7usESoUpyx?=
 =?us-ascii?Q?ljzXNYdfNRG+QEaMualrvHZTib02TIKr7QbyNSPuL1DtMgyDIC4yS8+ojkWa?=
 =?us-ascii?Q?X0fcI6JLpkaZ3DzLlWrpIwMW9ARLhnQpAe5danEIHnMY1zcfO5DOXZOv62zP?=
 =?us-ascii?Q?qIRwKyrZdUKcHO5SOoIh1Nrt?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b4aec4c-8bc8-421d-2f59-08d94a8570d5
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2021 07:18:43.5762
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0uIWhThKf4dwbMFS3qnFkSyEn3r93g9kOU1gbLIM+IQ2meXzo9/biReSvsQ2ismEaT7XHOGS94cM9omwX3JhNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB7100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to automate the verification of DT nodes covert imx-dwmac to
nxp,dwmac-imx.yaml, and pass below checking.

$ make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- dt_binding_check DT_SCHEMA_FILES=Documentation/devicetree/bindings/net/nxp,dwmac-imx.yaml
$ make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- dtbs_check DT_SCHEMA_FILES=Documentation/devicetree/bindings/net/nxp,dwmac-imx.yaml

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 .../devicetree/bindings/net/imx-dwmac.txt     | 56 -----------
 .../bindings/net/nxp,dwmac-imx.yaml           | 93 +++++++++++++++++++
 2 files changed, 93 insertions(+), 56 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/imx-dwmac.txt
 create mode 100644 Documentation/devicetree/bindings/net/nxp,dwmac-imx.yaml

diff --git a/Documentation/devicetree/bindings/net/imx-dwmac.txt b/Documentation/devicetree/bindings/net/imx-dwmac.txt
deleted file mode 100644
index 921d522fe8d7..000000000000
--- a/Documentation/devicetree/bindings/net/imx-dwmac.txt
+++ /dev/null
@@ -1,56 +0,0 @@
-IMX8 glue layer controller, NXP imx8 families support Synopsys MAC 5.10a IP.
-
-This file documents platform glue layer for IMX.
-Please see stmmac.txt for the other unchanged properties.
-
-The device node has following properties.
-
-Required properties:
-- compatible:  Should be "nxp,imx8mp-dwmac-eqos" to select glue layer
-	       and "snps,dwmac-5.10a" to select IP version.
-- clocks: Must contain a phandle for each entry in clock-names.
-- clock-names: Should be "stmmaceth" for the host clock.
-	       Should be "pclk" for the MAC apb clock.
-	       Should be "ptp_ref" for the MAC timer clock.
-	       Should be "tx" for the MAC RGMII TX clock:
-	       Should be "mem" for EQOS MEM clock.
-		- "mem" clock is required for imx8dxl platform.
-		- "mem" clock is not required for imx8mp platform.
-- interrupt-names: Should contain a list of interrupt names corresponding to
-		   the interrupts in the interrupts property, if available.
-		   Should be "macirq" for the main MAC IRQ
-		   Should be "eth_wake_irq" for the IT which wake up system
-- intf_mode: Should be phandle/offset pair. The phandle to the syscon node which
-	     encompases the GPR register, and the offset of the GPR register.
-		- required for imx8mp platform.
-		- is optional for imx8dxl platform.
-
-Optional properties:
-- intf_mode: is optional for imx8dxl platform.
-- snps,rmii_refclk_ext: to select RMII reference clock from external.
-
-Example:
-	eqos: ethernet@30bf0000 {
-		compatible = "nxp,imx8mp-dwmac-eqos", "snps,dwmac-5.10a";
-		reg = <0x30bf0000 0x10000>;
-		interrupts = <GIC_SPI 134 IRQ_TYPE_LEVEL_HIGH>,
-			     <GIC_SPI 135 IRQ_TYPE_LEVEL_HIGH>;
-		interrupt-names = "eth_wake_irq", "macirq";
-		clocks = <&clk IMX8MP_CLK_ENET_QOS_ROOT>,
-			 <&clk IMX8MP_CLK_QOS_ENET_ROOT>,
-			 <&clk IMX8MP_CLK_ENET_QOS_TIMER>,
-			 <&clk IMX8MP_CLK_ENET_QOS>;
-		clock-names = "stmmaceth", "pclk", "ptp_ref", "tx";
-		assigned-clocks = <&clk IMX8MP_CLK_ENET_AXI>,
-				  <&clk IMX8MP_CLK_ENET_QOS_TIMER>,
-				  <&clk IMX8MP_CLK_ENET_QOS>;
-		assigned-clock-parents = <&clk IMX8MP_SYS_PLL1_266M>,
-					 <&clk IMX8MP_SYS_PLL2_100M>,
-					 <&clk IMX8MP_SYS_PLL2_125M>;
-		assigned-clock-rates = <0>, <100000000>, <125000000>;
-		nvmem-cells = <&eth_mac0>;
-		nvmem-cell-names = "mac-address";
-		nvmem_macaddr_swap;
-		intf_mode = <&gpr 0x4>;
-		status = "disabled";
-	};
diff --git a/Documentation/devicetree/bindings/net/nxp,dwmac-imx.yaml b/Documentation/devicetree/bindings/net/nxp,dwmac-imx.yaml
new file mode 100644
index 000000000000..5629b2e4ccf8
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/nxp,dwmac-imx.yaml
@@ -0,0 +1,93 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/nxp,dwmac-imx.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: NXP i.MX8 DWMAC glue layer Device Tree Bindings
+
+maintainers:
+  - Joakim Zhang <qiangqing.zhang@nxp.com>
+
+# We need a select here so we don't match all nodes with 'snps,dwmac'
+select:
+  properties:
+    compatible:
+      contains:
+        enum:
+          - nxp,imx8mp-dwmac-eqos
+          - nxp,imx8dxl-dwmac-eqos
+  required:
+    - compatible
+
+allOf:
+  - $ref: "snps,dwmac.yaml#"
+
+properties:
+  compatible:
+    oneOf:
+      - items:
+          - enum:
+              - nxp,imx8mp-dwmac-eqos
+              - nxp,imx8dxl-dwmac-eqos
+          - const: snps,dwmac-5.10a
+
+  clocks:
+    minItems: 3
+    maxItems: 5
+    items:
+      - description: MAC host clock
+      - description: MAC apb clock
+      - description: MAC timer clock
+      - description: MAC RGMII TX clock
+      - description: EQOS MEM clock
+
+  clock-names:
+    minItems: 3
+    maxItems: 5
+    contains:
+      enum:
+        - stmmaceth
+        - pclk
+        - ptp_ref
+        - tx
+        - mem
+
+  intf_mode:
+    $ref: /schemas/types.yaml#/definitions/phandle-array
+    description:
+      Should be phandle/offset pair. The phandle to the syscon node which
+      encompases the GPR register, and the offset of the GPR register.
+
+  snps,rmii_refclk_ext:
+    $ref: /schemas/types.yaml#/definitions/flag
+    description:
+      To select RMII reference clock from external.
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
+    #include <dt-bindings/interrupt-controller/irq.h>
+    #include <dt-bindings/clock/imx8mp-clock.h>
+
+    eqos: ethernet@30bf0000 {
+            compatible = "nxp,imx8mp-dwmac-eqos","snps,dwmac-5.10a";
+            reg = <0x30bf0000 0x10000>;
+            interrupts = <GIC_SPI 135 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 134 IRQ_TYPE_LEVEL_HIGH>;
+            interrupt-names = "macirq", "eth_wake_irq";
+            clocks = <&clk IMX8MP_CLK_ENET_QOS_ROOT>,
+                     <&clk IMX8MP_CLK_QOS_ENET_ROOT>,
+                     <&clk IMX8MP_CLK_ENET_QOS_TIMER>,
+                     <&clk IMX8MP_CLK_ENET_QOS>;
+            clock-names = "stmmaceth", "pclk", "ptp_ref", "tx";
+            phy-mode = "rgmii";
+            status = "disabled";
+    };
-- 
2.17.1

