Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC4F33CB617
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 12:30:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238897AbhGPKcC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 06:32:02 -0400
Received: from mail-eopbgr60085.outbound.protection.outlook.com ([40.107.6.85]:32401
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238534AbhGPKb4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Jul 2021 06:31:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GbNbgq8vMYxTdeCLOq7u8ypI8vjXFfbHMmLySpuIOE9JDNdQ1g+S4xS58wvgr4ju7B1ybBTqnh2aimZ3OrgeqoDkogkiRKOGZKucboyvUusVkitCeMV2g1MrZmkyFEOvprfXf+4b/2oS8zITxNV61JpZlTP/FB8sLEEwqGWgYffCOKlQvjK+8wjxGlp/ZDXtHBHyyFgtsZHkr32K9cFwXbjERZ0ruON3JGSAJSHdvfT4psWr9DzBpx5jCp+bWuocIegGZ3wgS6M9DWm+niRW9F31XWYWNwqvP0h9dcwPr14KOIRxKrSEXRukepYYo3KflzGE1re25/oGIcz2dqLhxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i0CT4BjfpeLWOqiw2Yn/eygKLbBIsarum9X1/9YdDJs=;
 b=hvGUS91V4MZAWbE4MPyU4XwnAhbdo+dyg5UiutGlaPniu8JDEDwfFFVI5AtwsCzlZVLmXqo0GiQKqIp32Io5AW9O9HSw/rtrMK0ovZMVJD7m69evftsoG3gMlipz2UZ9N7F69qdM/ot2V8lK+vjv5nHBhvfspyk40HDJikH7MuhhrnJ0TlK7AGF1OlRyEg3jGKy067vKo8fBlVqvFL/+0fg+Bo03sztKoYkJssCTMcLK1sGPPpTYlDADh4quBZBgN/xxZXehOg+v3nzboYQYHy9jgzl5lhEJoBKya5CA1UA5Zxw5/CzOaiEyLJYbA2oKCqkQ/RjgUis/6+ha63TFVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i0CT4BjfpeLWOqiw2Yn/eygKLbBIsarum9X1/9YdDJs=;
 b=SYoWBl18vPm1QrZGixm2wZfzO6NTnrnvJKlakku7MJRkv1E6tEyPz/qwXQg1cYWg0VDQUKegy0xJs+qn0K6c+kvTssq3cYzX0FFEr+VGDaGa3LeBUN8m/TsOpVgKsZ1gkkHi2mVOwywsTefeapYQWCWfS6AUgRY3OIjoINGMCRE=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB6PR0402MB2725.eurprd04.prod.outlook.com (2603:10a6:4:95::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.23; Fri, 16 Jul
 2021 10:28:58 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802%9]) with mapi id 15.20.4331.021; Fri, 16 Jul 2021
 10:28:58 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        shawnguo@kernel.org, s.hauer@pengutronix.de, kernel@pengutronix.de,
        festevam@gmail.com, bruno.thomsen@gmail.com
Cc:     linux-imx@nxp.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH V1 1/3] dt-bindings: net: fec: convert fsl,*fec bindings to yaml
Date:   Fri, 16 Jul 2021 18:29:09 +0800
Message-Id: <20210716102911.23694-2-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210716102911.23694-1-qiangqing.zhang@nxp.com>
References: <20210716102911.23694-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SGBP274CA0008.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::20)
 To DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SGBP274CA0008.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.22 via Frontend Transport; Fri, 16 Jul 2021 10:28:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9f73d085-2cc3-4717-3f94-08d948448574
X-MS-TrafficTypeDiagnostic: DB6PR0402MB2725:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0402MB27259867800177245B7811ABE6119@DB6PR0402MB2725.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2201;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Tf5pd66bwS/SURnkXe81rg34GWHxcLL5TakT0SZIObkp/FPQq3pKmLMPCzN6/+2gPtsW5n7X1vylXBEt7hadWj7YIQPo3jkHoWHZWXEIF8ZD9CxYLynpTbtITQkUZez/giZdgI3yci2btfQWPikiXrTM0TJva46BSpbvULV0Jr8A/CcdUqNyDbhFVfBj72SN9e0gjDhVAtaalZUHlHvKi6OjWpcCZkt4JInH8vacEKXlVvSeszVtmNADUKUZiMEGv1n6k+V8KsbQkrMB/cFS2JgeaBtUrG4HeqTmQRqHE2T9jkVaX1Z5FEDbSuYKXuBRHt3/svQa68u3VnYtMEeQrGqtrI1GCo/rAobKBhCB/T4ZvlwJqhrYr84lA8oaR7OT9n46fdcUFuJE3sdTNFjgSgbCPDlRHyfSN4LonIMVBnAp2qOY0lMAgTDV8qJ31DZ6P+aSrQS1t9Ra08cJHGKLX7eT9UaCRG9hxzSgaTHUPH8/GBHiBF5OETz6/sDG/oNK2IwfVW7nqFvSq+xngtXBOjj875yUjzfTyIpODBK3DBVC7eouNoEMqBzfjy2sDI9ZYgrUzG3MI77yhPGwUSA8Sg9TAnYbHPTK5LuJKdfL/AjnM2Ka7rGsn1p1U14A9tSlxa5qLIahlcRB4ccUWJc4nqhHqApg5c8fs3If51sB34P5FBMD3+mihBrDCGoHxzR7g/zkvLycyWPXpjKSBQhlS0NvNmKgrtsancB0qUiDiTI4qNa3UOHNEo4ZfdjX40QnA/FJ/KoyauK7wV3AQQ34FetValocOMaMJ57YKdJlsFbLfb6Kjw8cvWvihwfgPb3c
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(136003)(396003)(376002)(39860400002)(316002)(83380400001)(478600001)(5660300002)(30864003)(86362001)(66476007)(1076003)(966005)(66556008)(52116002)(36756003)(66946007)(2906002)(4326008)(26005)(6506007)(956004)(2616005)(6486002)(8936002)(6666004)(7416002)(186003)(8676002)(38350700002)(6512007)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eGWaYgY5CICZSHWWq2Em+jKoWiwXixMDz6bwp8545GpNS90rEJKCHNivJJtc?=
 =?us-ascii?Q?TkuAZ8gnS+QVbaSNc9ReursImpOoG3oCwwOeXPWDpunRgWLxaFquBQoLtADo?=
 =?us-ascii?Q?vXLhvjSREfBd5SwVry/+jGpH3TVN5ffyEpm1oSubQSK23PXCGqX5PJfWFQj9?=
 =?us-ascii?Q?YvzexJ7uqSLZmJovKI2Vu4MPDf1wS6QrHxsDoAE09eYt+1Uy/nPBEPhdzeqe?=
 =?us-ascii?Q?FkaNtc9+aPr1Y9Q0CDXT4w0tgtsSU0npxzteZkI8e1us5adS4hEXQ2haL1Tc?=
 =?us-ascii?Q?Jqd7kiEmwxOaM9WweOdpl3Y1c2GzlD335jifxRaHfm3yqG//XlMycDL+i6Ly?=
 =?us-ascii?Q?n0qjSBJt01Gf3ee32nMM/eKBs6/l6TGBdd90sfiDbkKp0Pxe3sHcVoMhRKQR?=
 =?us-ascii?Q?09Fr7o5nTJt09mqEG8ZEku1fUaWA1SjOHc53vYBNsGpkS0sLTa4ZITketxi1?=
 =?us-ascii?Q?sVs7IlKjYbBGFteoBdIMXPhJzmvW6o+CLejhw5X9ri8jyuhC7xW5iHKu2ELS?=
 =?us-ascii?Q?ODY4reSHItQhiPhu8HdYJJFtRP/hVn3dktPivRIwLEQGaAo9djM0DR0d8Pgw?=
 =?us-ascii?Q?ASJJC0JsCyMjYe+kJ68Sgv9KqfmfvhcMo5u6kDmqDiCAwu8V1P5KuElgcIxN?=
 =?us-ascii?Q?uG7l45N3Mv+NBAD/Fb6Xfa33e0zlT72uDVD1ube4Hdr17jaNcwuPHa2ZKsoO?=
 =?us-ascii?Q?1fK/+1/ZHm9SEud7xTL8KirkrFNb6FiJLZCdodqlGaGUk5Wuw4UzWYwe7F/b?=
 =?us-ascii?Q?c5pPOKr4KzGeS5+2C30Gb2d0kJsymaT1MUOagQfYF4xkYNVrXyNxeulzH7N4?=
 =?us-ascii?Q?wrgf1eoShBP8ynZQ9Wpyd3BpcRExk7dQrh396yHn4gX/K3JIou6TXS3Aew6V?=
 =?us-ascii?Q?dzPTIhIx6jOEJOYiyGTbp0cypLkdq6ueO9G8sZNerWytDvkLH0VQ3sNFSLxg?=
 =?us-ascii?Q?KDs2+DKGYgpXUX9a/vw5Lbh1HGxG1g0yAXQfl2jcnA0JowhBmMNcUWxD1HtE?=
 =?us-ascii?Q?dRrsei+roeVKO6t9858RtTbYOYUZdPyHhWEaajWlKNfS9oOYINBVT6YTlseJ?=
 =?us-ascii?Q?KcmlgBepgNn6ch6t8Pr7oIfhrJ1Hunw8zo4zM7SKi7DfZMOqbSaC8N45WS6Z?=
 =?us-ascii?Q?QjtCBcFuw43o15FuIScN5dR2SQL55N9Lwmb6NzppjJFmkplshFiLLQbK7LsX?=
 =?us-ascii?Q?M13v4FPwmvoeucIp5J1P/vbwIMbqMUODKkG5EQMB2iG+PxQmMRhkOgCEUoJx?=
 =?us-ascii?Q?foZ1bjbdPlxJqnbfsXzRrqHvkhPxD9DieQm0mHQSCHShuUToRxCORWQrH/LI?=
 =?us-ascii?Q?TaVN8Sq+mzurLm9EsqLwozjL?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f73d085-2cc3-4717-3f94-08d948448574
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2021 10:28:58.6079
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2KXArnZ8RKqD+4x+8xV0uL1PurSr2dRGwrygrqGpCmuwT/t0wIYmp+jHUYiTcVauAGwNBQYF/gngUE1bl9vRag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0402MB2725
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to automate the verification of DT nodes convert fsl-fec.txt to
fsl,fec.yaml, and pass binding check with below command.

$ make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- dt_binding_check DT_SCHEMA_FILES=Documentation/devicetree/bindings/net/fsl,fec.yaml
  DTEX    Documentation/devicetree/bindings/net/fsl,fec.example.dts
  DTC     Documentation/devicetree/bindings/net/fsl,fec.example.dt.yaml
  CHECK   Documentation/devicetree/bindings/net/fsl,fec.example.dt.yaml

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 .../devicetree/bindings/net/fsl,fec.yaml      | 213 ++++++++++++++++++
 .../devicetree/bindings/net/fsl-fec.txt       |  95 --------
 2 files changed, 213 insertions(+), 95 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/fsl,fec.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/fsl-fec.txt

diff --git a/Documentation/devicetree/bindings/net/fsl,fec.yaml b/Documentation/devicetree/bindings/net/fsl,fec.yaml
new file mode 100644
index 000000000000..7fa11f6622b1
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/fsl,fec.yaml
@@ -0,0 +1,213 @@
+# SPDX-License-Identifier: GPL-2.0
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/fsl,fec.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Freescale Fast Ethernet Controller (FEC)
+
+maintainers:
+  - Joakim Zhang <qiangqing.zhang@nxp.com>
+
+allOf:
+  - $ref: ethernet-controller.yaml#
+
+properties:
+  compatible:
+    oneOf:
+      - enum:
+          - fsl,imx25-fec
+          - fsl,imx27-fec
+          - fsl,imx28-fec
+          - fsl,imx6q-fec
+          - fsl,mvf600-fec
+      - items:
+          - enum:
+              - fsl,imx53-fec
+              - fsl,imx6sl-fec
+          - const: fsl,imx25-fec
+      - items:
+          - enum:
+              - fsl,imx35-fec
+              - fsl,imx51-fec
+          - const: fsl,imx27-fec
+      - items:
+          - enum:
+              - fsl,imx6ul-fec
+              - fsl,imx6sx-fec
+          - const: fsl,imx6q-fec
+      - items:
+          - enum:
+              - fsl,imx7d-fec
+          - const: fsl,imx6sx-fec
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    minItems: 1
+    maxItems: 4
+
+  interrupt-names:
+    description:
+      Names of the interrupts listed in interrupts property in the same order.
+      The defaults if not specified are
+      __Number of interrupts__   __Default__
+            1                       "int0"
+            2                       "int0", "pps"
+            3                       "int0", "int1", "int2"
+            4                       "int0", "int1", "int2", "pps"
+      The order may be changed as long as they correspond to the interrupts
+      property. Currently, only i.mx7 uses "int1" and "int2". They correspond to
+      tx/rx queues 1 and 2. "int0" will be used for queue 0 and ENET_MII interrupts.
+      For imx6sx, "int0" handles all 3 queues and ENET_MII. "pps" is for the pulse
+      per second interrupt associated with 1588 precision time protocol(PTP).
+
+  clocks:
+    minItems: 2
+    maxItems: 5
+    description:
+      The "ipg", for MAC ipg_clk_s, ipg_clk_mac_s that are for register accessing.
+      The "ahb", for MAC ipg_clk, ipg_clk_mac that are bus clock.
+      The "ptp"(option), for IEEE1588 timer clock that requires the clock.
+      The "enet_clk_ref"(option), for MAC transmit/receiver reference clock like
+      RGMII TXC clock or RMII reference clock. It depends on board design,
+      the clock is required if RGMII TXC and RMII reference clock source from
+      SOC internal PLL.
+      The "enet_out"(option), output clock for external device, like supply clock
+      for PHY. The clock is required if PHY clock source from SOC.
+
+  clock-names:
+    minItems: 2
+    maxItems: 5
+    contains:
+      enum:
+      - ipg
+      - ahb
+      - ptp
+      - enet_clk_ref
+      - enet_out
+
+  phy-mode: true
+
+  phy-handle: true
+
+  fixed-link: true
+
+  local-mac-address: true
+
+  mac-address: true
+
+  phy-supply:
+    description:
+      Regulator that powers the Ethernet PHY.
+
+  fsl,num-tx-queues:
+    $ref: /schemas/types.yaml#/definitions/uint32
+    description:
+      The property is valid for enet-avb IP, which supports hw multi queues.
+      Should specify the tx queue number, otherwise set tx queue number to 1.
+
+  fsl,num-rx-queues:
+    $ref: /schemas/types.yaml#/definitions/uint32
+    description:
+      The property is valid for enet-avb IP, which supports hw multi queues.
+      Should specify the rx queue number, otherwise set rx queue number to 1.
+
+  fsl,magic-packet:
+    $ref: /schemas/types.yaml#/definitions/flag
+    description:
+      If present, indicates that the hardware supports waking up via magic packet.
+
+  fsl,err006687-workaround-present:
+    $ref: /schemas/types.yaml#/definitions/flag
+    description:
+      If present indicates that the system has the hardware workaround for
+      ERR006687 applied and does not need a software workaround.
+
+  fsl,stop-mode:
+    $ref: /schemas/types.yaml#/definitions/phandle-array
+    description:
+      Register bits of stop mode control, the format is <&gpr req_gpr req_bit>.
+      gpr is the phandle to general purpose register node.
+      req_gpr is the gpr register offset for ENET stop request.
+      req_bit is the gpr bit offset for ENET stop request.
+
+  mdio:
+    type: object
+    description:
+      Specifies the mdio bus in the FEC, used as a container for phy nodes.
+
+  # Deprecated optional properties:
+  # To avoid these, create a phy node according to ethernet-phy.yaml in the same
+  # directory, and point the FEC's "phy-handle" property to it. Then use
+  # the phy's reset binding, again described by ethernet-phy.yaml.
+
+  phy-reset-gpios:
+    deprecated: true
+    description:
+      Should specify the gpio for phy reset.
+
+  phy-reset-duration:
+    deprecated: true
+    description:
+      Reset duration in milliseconds.  Should present only if property
+      "phy-reset-gpios" is available.  Missing the property will have the
+      duration be 1 millisecond.  Numbers greater than 1000 are invalid
+      and 1 millisecond will be used instead.
+
+  phy-reset-active-high:
+    deprecated: true
+    description:
+      If present then the reset sequence using the GPIO specified in the
+      "phy-reset-gpios" property is reversed (H=reset state, L=operation state).
+
+  phy-reset-post-delay:
+    deprecated: true
+    description:
+      Post reset delay in milliseconds. If present then a delay of phy-reset-post-delay
+      milliseconds will be observed after the phy-reset-gpios has been toggled.
+      Can be omitted thus no delay is observed. Delay is in range of 1ms to 1000ms.
+      Other delays are invalid.
+
+required:
+  - compatible
+  - reg
+  - interrupts
+
+# FIXME: We had better set additionalProperties to false to avoid invalid or at
+# least undocumented properties. However, PHY may have a deprecated option to
+# place PHY OF properties in the MAC node, such as Micrel PHY, and we can find
+# these boards which is based on i.MX6QDL.
+additionalProperties: true
+
+examples:
+  - |
+    ethernet@83fec000 {
+      compatible = "fsl,imx51-fec", "fsl,imx27-fec";
+      reg = <0x83fec000 0x4000>;
+      interrupts = <87>;
+      phy-mode = "mii";
+      phy-reset-gpios = <&gpio2 14 0>;
+      phy-supply = <&reg_fec_supply>;
+    };
+
+    ethernet@83fed000 {
+      compatible = "fsl,imx51-fec", "fsl,imx27-fec";
+      reg = <0x83fed000 0x4000>;
+      interrupts = <87>;
+      phy-mode = "mii";
+      phy-reset-gpios = <&gpio2 14 0>;
+      phy-supply = <&reg_fec_supply>;
+      phy-handle = <&ethphy0>;
+
+      mdio {
+        #address-cells = <1>;
+        #size-cells = <0>;
+
+        ethphy0: ethernet-phy@0 {
+          compatible = "ethernet-phy-ieee802.3-c22";
+          reg = <0>;
+        };
+      };
+    };
diff --git a/Documentation/devicetree/bindings/net/fsl-fec.txt b/Documentation/devicetree/bindings/net/fsl-fec.txt
deleted file mode 100644
index 9b543789cd52..000000000000
--- a/Documentation/devicetree/bindings/net/fsl-fec.txt
+++ /dev/null
@@ -1,95 +0,0 @@
-* Freescale Fast Ethernet Controller (FEC)
-
-Required properties:
-- compatible : Should be "fsl,<soc>-fec"
-- reg : Address and length of the register set for the device
-- interrupts : Should contain fec interrupt
-- phy-mode : See ethernet.txt file in the same directory
-
-Optional properties:
-- phy-supply : regulator that powers the Ethernet PHY.
-- phy-handle : phandle to the PHY device connected to this device.
-- fixed-link : Assume a fixed link. See fixed-link.txt in the same directory.
-  Use instead of phy-handle.
-- fsl,num-tx-queues : The property is valid for enet-avb IP, which supports
-  hw multi queues. Should specify the tx queue number, otherwise set tx queue
-  number to 1.
-- fsl,num-rx-queues : The property is valid for enet-avb IP, which supports
-  hw multi queues. Should specify the rx queue number, otherwise set rx queue
-  number to 1.
-- fsl,magic-packet : If present, indicates that the hardware supports waking
-  up via magic packet.
-- fsl,err006687-workaround-present: If present indicates that the system has
-  the hardware workaround for ERR006687 applied and does not need a software
-  workaround.
-- fsl,stop-mode: register bits of stop mode control, the format is
-		 <&gpr req_gpr req_bit>.
-		 gpr is the phandle to general purpose register node.
-		 req_gpr is the gpr register offset for ENET stop request.
-		 req_bit is the gpr bit offset for ENET stop request.
- -interrupt-names:  names of the interrupts listed in interrupts property in
-  the same order. The defaults if not specified are
-  __Number of interrupts__   __Default__
-	1			"int0"
-	2			"int0", "pps"
-	3			"int0", "int1", "int2"
-	4			"int0", "int1", "int2", "pps"
-  The order may be changed as long as they correspond to the interrupts
-  property. Currently, only i.mx7 uses "int1" and "int2". They correspond to
-  tx/rx queues 1 and 2. "int0" will be used for queue 0 and ENET_MII interrupts.
-  For imx6sx, "int0" handles all 3 queues and ENET_MII. "pps" is for the pulse
-  per second interrupt associated with 1588 precision time protocol(PTP).
-
-Optional subnodes:
-- mdio : specifies the mdio bus in the FEC, used as a container for phy nodes
-  according to phy.txt in the same directory
-
-Deprecated optional properties:
-	To avoid these, create a phy node according to phy.txt in the same
-	directory, and point the fec's "phy-handle" property to it. Then use
-	the phy's reset binding, again described by phy.txt.
-- phy-reset-gpios : Should specify the gpio for phy reset
-- phy-reset-duration : Reset duration in milliseconds.  Should present
-  only if property "phy-reset-gpios" is available.  Missing the property
-  will have the duration be 1 millisecond.  Numbers greater than 1000 are
-  invalid and 1 millisecond will be used instead.
-- phy-reset-active-high : If present then the reset sequence using the GPIO
-  specified in the "phy-reset-gpios" property is reversed (H=reset state,
-  L=operation state).
-- phy-reset-post-delay : Post reset delay in milliseconds. If present then
-  a delay of phy-reset-post-delay milliseconds will be observed after the
-  phy-reset-gpios has been toggled. Can be omitted thus no delay is
-  observed. Delay is in range of 1ms to 1000ms. Other delays are invalid.
-
-Example:
-
-ethernet@83fec000 {
-	compatible = "fsl,imx51-fec", "fsl,imx27-fec";
-	reg = <0x83fec000 0x4000>;
-	interrupts = <87>;
-	phy-mode = "mii";
-	phy-reset-gpios = <&gpio2 14 GPIO_ACTIVE_LOW>; /* GPIO2_14 */
-	local-mac-address = [00 04 9F 01 1B B9];
-	phy-supply = <&reg_fec_supply>;
-};
-
-Example with phy specified:
-
-ethernet@83fec000 {
-	compatible = "fsl,imx51-fec", "fsl,imx27-fec";
-	reg = <0x83fec000 0x4000>;
-	interrupts = <87>;
-	phy-mode = "mii";
-	phy-reset-gpios = <&gpio2 14 GPIO_ACTIVE_LOW>; /* GPIO2_14 */
-	local-mac-address = [00 04 9F 01 1B B9];
-	phy-supply = <&reg_fec_supply>;
-	phy-handle = <&ethphy>;
-	mdio {
-	        clock-frequency = <5000000>;
-		ethphy: ethernet-phy@6 {
-			compatible = "ethernet-phy-ieee802.3-c22";
-			reg = <6>;
-			max-speed = <100>;
-		};
-	};
-};
-- 
2.17.1

