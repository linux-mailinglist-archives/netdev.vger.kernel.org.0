Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20F3163A0EF
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 06:50:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbiK1FuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 00:50:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbiK1FuA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 00:50:00 -0500
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on2087.outbound.protection.outlook.com [40.107.15.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5187113F64;
        Sun, 27 Nov 2022 21:49:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WQp9PXoC5OOcy19E8Z86VgAFjls+H2EIc8G46tpo1ufkzR+k6GyG1tr7DgZt7KjmDtyQlEHmkWU7Biw7u9dTxv0sPc8OCOmK/ZJ1CZ96ezlCBkf6hcv1nBKf5axmKk6QNttJrz1kXB06j30VGuz3rKEzB67OWCzdKJLtDpvlNfhzf9rxSBgVQ2Iv8ST3/ydVsIZXb2eM5M7Lj8Ib/n5/kNuKioS9BoVubnEPiFRsrZAQbCuvJw+k2z9rPwstrpp6sO31NkdJAXs/GGvM7hIn11wrBky1TgzBFuWQM6R2VJmy6Q11q7YW2MJ1QN1Nmu+oYOp6cfr2+yLd25eopXY+uA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AhXmGvpVPy984cYgkhg8LOOX/aSZ61B1z9C6x92i3Hc=;
 b=hVpt/lzVlM94MuNDs0iq4ExnbEtxDKGAN4UBok7yDpqEubzJ/WYBpGfi3mpLzTfVooChVt4z946k56Mafj4p/jPQUK+g13JbJBjZ8EZxDO6iT7G3VnmPYLlHS/gYXzVE5DDTxb67f39gKXdU/sqTjiZ5GaH7s4suyXBEpTTOezaDD+Z3uztjb8HmoDMHutx7rxermwe530/iAapMd+XTiek7ofUcVPStpmWXNH1CN16+JZDmAaIpDcEjDbTxZxWncROcFyN0Q4ku4QWVHF1JewfUj+iFERamh8XqPcKGHGYe7Q1SwxkR3fP3F99jOvnP8N3Fs9FEWEohT3taOWxXXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AhXmGvpVPy984cYgkhg8LOOX/aSZ61B1z9C6x92i3Hc=;
 b=3LLJz5WoeCMJWa+c2Q8vZAaEmWBTPRM4kWfiqNQ5NUcElV3LU+ytuHDL3Wqy345xkaqHGRFd3UURnyC4j2hH2KR7EyN4dY46O8vAPcYfPvZMWZekh4h0293YgDGQ1eEqRQ1afIvZeL21+Qha/O8AXZOHjabTIXxf2cNMTuZJywUhlAzs31zi8ysqMK9yGr5JKS8kjguL+A1qTCd91Jf8MSjbRIB3VPb4SX3Nsvn8do24EIDOo0UxJ2b433GdAguv1ZUvgtV5GKujDFI+vSY61Mp4+Aa8apysdVOErx0tYqKYN4QS4Nwj3QNZeZ0XQ681FSC8ZKdUrHfH22Uu13dXlg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3439.eurprd04.prod.outlook.com (2603:10a6:803:4::13)
 by AS8PR04MB7655.eurprd04.prod.outlook.com (2603:10a6:20b:292::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19; Mon, 28 Nov
 2022 05:49:51 +0000
Received: from VI1PR0402MB3439.eurprd04.prod.outlook.com
 ([fe80::28d6:1b8:94d9:89f5]) by VI1PR0402MB3439.eurprd04.prod.outlook.com
 ([fe80::28d6:1b8:94d9:89f5%7]) with mapi id 15.20.5857.023; Mon, 28 Nov 2022
 05:49:51 +0000
From:   Chester Lin <clin@suse.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jan Petrous <jan.petrous@nxp.com>, Andrew Lunn <andrew@lunn.ch>
Cc:     Chester Lin <clin@suse.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org,
        s32@nxp.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>,
        Matthias Brugger <mbrugger@suse.com>
Subject: [PATCH v2 2/5] dt-bindings: net: add schema for NXP S32CC dwmac glue driver
Date:   Mon, 28 Nov 2022 13:49:17 +0800
Message-Id: <20221128054920.2113-3-clin@suse.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221128054920.2113-1-clin@suse.com>
References: <20221128054920.2113-1-clin@suse.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0146.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:31b::11) To VI1PR0402MB3439.eurprd04.prod.outlook.com
 (2603:10a6:803:4::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3439:EE_|AS8PR04MB7655:EE_
X-MS-Office365-Filtering-Correlation-Id: f3a04ac4-c047-4de7-c834-08dad1045da8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7t1WENTYLKuiITAQ9eRCK/TpAZbqmFZgbyqFP0bYOmHIoW3/Sa3hyPIT9DD/T8OYKyMIvWFt31GOv2j/YZjgw4GfhL+4LYxLFIGPqOkuOsMNe+HSH2UiXkUPzH22VA/RUqyPRPuPwb8Vf0zAW8qwop0VRC6+KVNsfDmp1KpkCPvMo8H9nd5Pb67eddTpNfBxgoQ07vvQnvBnmmUUh7mH1gvY8yVLD7Gj02hHg43WeDa0g/IVna4fiBvrScDB5x63UJvdjg+Ha6jeLB+JE/1hRflHkMx2/cpArjoDnLcjx5Jemiun3+6KIK6FIhguHzbarouEsYi9IZ6WKq00ozS757NjiVGDCUkWB6ndzf7aGk22oeGDvNfFtPjivJIFyly/3iEGtlNmOGf3b0czvsn49KJNM4K+1+LiO202NSO6XqxjGsZzIG2CEYjqx0fCyFyr5C0rOnRhxH4nmwzZtYL7vQY3KxMaHcav0876hkYMoAuj1l9ow+RvIn7EkDcoYoS1tfOo2c3sUXMU1OFm+5V/+dvEmyY1qawEUaImmHsLLgBemyb89qqgWbbfnWQUL4+YCKAsgZQf10Qu+mNFfZit1ywuQmXBn9hdlBVRY1+u66AZggBa4/G03i4LqCqgmI39d+p4pkiwofm8wVJR5jbQ4PAwXDpMOl2no+rZ7OXOOXY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3439.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(346002)(136003)(396003)(376002)(451199015)(2616005)(6506007)(6512007)(36756003)(7416002)(1076003)(186003)(5660300002)(54906003)(86362001)(110136005)(66476007)(8676002)(4326008)(66946007)(66556008)(2906002)(41300700001)(38100700002)(316002)(83380400001)(8936002)(478600001)(6486002)(107886003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VLRxUtXycK94x6kM77Uwc3bkUS3kyXPSqtIQDGFzYUEeQJLUUEbIGNBWYKIP?=
 =?us-ascii?Q?VHxJKiSeY28lzGoIlAx4ISRMJF08Jf+SVO3N67kSwOH3vmN/eTOdc5+wRYl4?=
 =?us-ascii?Q?iaiHLdIcmaMZzjnF105SLhu0LvrQqOzUP4Ma7qXxPUgOA5m3LkzqvSmji6XL?=
 =?us-ascii?Q?PIcC3TzZoCPp+XuWQya3r/lxDHX5r4kr58avhiLprCKRLEbkz6fGM4IJ0yp4?=
 =?us-ascii?Q?x9hsie6X6M/YV6WJij7UdmANty408ClIwG2b3dJB37HQmAIPuiKhJdYP1EbU?=
 =?us-ascii?Q?kE/5c8cl9YC8NcG9YARAO0igP4y77N3QL4/7MQZ+b0YuYG6ebkvx5/Ot9oJl?=
 =?us-ascii?Q?jUn3Pd1HyQVuiQmRqrVk9KO1ztelGxSGi/CyspA7iX1XJkkBADfonoPFl++6?=
 =?us-ascii?Q?uuxffuHz84TlHEc3XBArc/rwY/gLPkwgQnsk9fadeh/5g6jxiq9u0tpxSn+1?=
 =?us-ascii?Q?C6fRh+rBrzvomsJ8SSxs4iJvS+dyA6rryDWbN2/GorhkMxJxf5IlMCeGFWJP?=
 =?us-ascii?Q?qSnyZk3GnjK/ZrXMBKTMmoyy3Qeam9IxflA/YG1XT05jxk2Fowi+7UE4VRM/?=
 =?us-ascii?Q?DW+6PHA0S83ggMG9P0yySAUXxQtf+bzzRw7u0ITm1XQj7GPZqOKBCHy+mCkb?=
 =?us-ascii?Q?h9BgUGLbREVQlY3q2Z3gKoNfjr5Egt9dnW9ttQMFUNDY6tQWrsn9QwD+A1u9?=
 =?us-ascii?Q?kcuaDlDok9w7MirbymT1kJ35dxg+9vitcOkL5MnkC+q8uXE9/GGEu/QWoeEF?=
 =?us-ascii?Q?4k9O8zHI/luKsAwuWaiC42HMA410aVCA3utbVSU+x/lzilCiVmJfNQ989bma?=
 =?us-ascii?Q?m0ck8Vy5kWQiWGSV+CWnRhg1pg8lc4oa7V7wnlPzM5Vp36El38VfnZAAxaA/?=
 =?us-ascii?Q?A7fHbTaY/lx+jO19gzxTMWTn9J2HaVhdxyQmor8+ugAffI5swGCtUONhbJcO?=
 =?us-ascii?Q?amgZyekZboY1+ioDQkr0SGsz7GgNZRGGVDLSbN/KwtykyhlYtuw54Ga/Pilf?=
 =?us-ascii?Q?WE1vp1cRLEQg2RLkY8m7Sw/BikfulW7sP1MyL8LHMdkuS7mTwPu8PVzJ/TOl?=
 =?us-ascii?Q?lncw3u/PyVrcJcVjiBP68IXeP74Jo/SWTpSgFRXMhDe1+uN/VuqiCI7RhyAZ?=
 =?us-ascii?Q?S4MFHn7PTc605LM7Mqs9hdmtcZQzkUlMx8SRgC/2NoCj4Osk2eD9DGVZP7eV?=
 =?us-ascii?Q?yAbUi3RqDYC7vgK+KDWApw7Q2DD72HM3I+mnQETgpa8x+o1z2jkhvu5NAmKh?=
 =?us-ascii?Q?36jbzoUBiToLYDNwEs6ALg8zQ49PB7j/kcSZR7BF8MDWiLeNNwKv0YZAfOVo?=
 =?us-ascii?Q?61VtUpzp2WAsVfDTf9sJyTl+acJ30z46iAK6bCU82b25RJtanFZdlrqW2reS?=
 =?us-ascii?Q?4R0/A4zsLBva69cCKM85yAq16qsJDzFg6VLT7AUs1laf5JiGtJQiBjzuCOl8?=
 =?us-ascii?Q?5c7Pb2VaqVxsWzr5eazqS7MBZrGoU0iSxsSrQHKs/MjEiTrIDjuv8BKsiAus?=
 =?us-ascii?Q?SEXGFuCibtLAk17g0/JP2gYko1PyNleShYLCFSFMJGtn9N07wwDpfhtKtejQ?=
 =?us-ascii?Q?nHdyPuPwoEeSAG6UawORmHtZo2dxw+LMWOXrsBom37UQ9Rdbv8i3ARmhP6p2?=
 =?us-ascii?Q?qU1L7FJM9Mdz7UTWP/Bos8EHPzJOcWOn6dK2C14TVM7H?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3a04ac4-c047-4de7-c834-08dad1045da8
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3439.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2022 05:49:51.1200
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zG4gk7q+fFeLbMx7WiBRsW1X0CM4AMkc7C1Eesen0NYWk5EhnpiSNwSzujmVFKPO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7655
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the DT schema for the DWMAC Ethernet controller on NXP S32 Common
Chassis.

Signed-off-by: Jan Petrous <jan.petrous@nxp.com>
Signed-off-by: Chester Lin <clin@suse.com>
---

Changes in v2:
  - Fix schema issues.
  - Add minItems to clocks & clock-names.
  - Replace all sgmii/SGMII terms with pcs/PCS.

 .../bindings/net/nxp,s32cc-dwmac.yaml         | 135 ++++++++++++++++++
 1 file changed, 135 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/nxp,s32cc-dwmac.yaml

diff --git a/Documentation/devicetree/bindings/net/nxp,s32cc-dwmac.yaml b/Documentation/devicetree/bindings/net/nxp,s32cc-dwmac.yaml
new file mode 100644
index 000000000000..c6839fd3df40
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/nxp,s32cc-dwmac.yaml
@@ -0,0 +1,135 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+# Copyright 2021-2022 NXP
+%YAML 1.2
+---
+$id: "http://devicetree.org/schemas/net/nxp,s32cc-dwmac.yaml#"
+$schema: "http://devicetree.org/meta-schemas/core.yaml#"
+
+title: NXP S32CC DWMAC Ethernet controller
+
+maintainers:
+  - Jan Petrous <jan.petrous@nxp.com>
+  - Chester Lin <clin@suse.com>
+
+allOf:
+  - $ref: "snps,dwmac.yaml#"
+
+properties:
+  compatible:
+    enum:
+      - nxp,s32cc-dwmac
+
+  reg:
+    items:
+      - description: Main GMAC registers
+      - description: S32 MAC control registers
+
+  dma-coherent: true
+
+  clocks:
+    minItems: 5
+    items:
+      - description: Main GMAC clock
+      - description: Peripheral registers clock
+      - description: Transmit PCS clock
+      - description: Transmit RGMII clock
+      - description: Transmit RMII clock
+      - description: Transmit MII clock
+      - description: Receive PCS clock
+      - description: Receive RGMII clock
+      - description: Receive RMII clock
+      - description: Receive MII clock
+      - description:
+          PTP reference clock. This clock is used for programming the
+          Timestamp Addend Register. If not passed then the system
+          clock will be used.
+
+  clock-names:
+    minItems: 5
+    items:
+      - const: stmmaceth
+      - const: pclk
+      - const: tx_pcs
+      - const: tx_rgmii
+      - const: tx_rmii
+      - const: tx_mii
+      - const: rx_pcs
+      - const: rx_rgmii
+      - const: rx_rmii
+      - const: rx_mii
+      - const: ptp_ref
+
+  tx-fifo-depth:
+    const: 20480
+
+  rx-fifo-depth:
+    const: 20480
+
+required:
+  - compatible
+  - reg
+  - tx-fifo-depth
+  - rx-fifo-depth
+  - clocks
+  - clock-names
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+    #include <dt-bindings/interrupt-controller/irq.h>
+
+    #define S32GEN1_SCMI_CLK_GMAC0_AXI
+    #define S32GEN1_SCMI_CLK_GMAC0_TX_PCS
+    #define S32GEN1_SCMI_CLK_GMAC0_TX_RGMII
+    #define S32GEN1_SCMI_CLK_GMAC0_TX_RMII
+    #define S32GEN1_SCMI_CLK_GMAC0_TX_MII
+    #define S32GEN1_SCMI_CLK_GMAC0_RX_PCS
+    #define S32GEN1_SCMI_CLK_GMAC0_RX_RGMII
+    #define S32GEN1_SCMI_CLK_GMAC0_RX_RMII
+    #define S32GEN1_SCMI_CLK_GMAC0_RX_MII
+    #define S32GEN1_SCMI_CLK_GMAC0_TS
+
+    soc {
+      #address-cells = <1>;
+      #size-cells = <1>;
+
+      gmac0: ethernet@4033c000 {
+        compatible = "nxp,s32cc-dwmac";
+        reg = <0x4033c000 0x2000>, /* gmac IP */
+              <0x4007C004 0x4>;    /* S32 CTRL_STS reg */
+        interrupt-parent = <&gic>;
+        interrupts = <GIC_SPI 57 IRQ_TYPE_LEVEL_HIGH>;
+        interrupt-names = "macirq";
+        phy-mode = "rgmii-id";
+        tx-fifo-depth = <20480>;
+        rx-fifo-depth = <20480>;
+        dma-coherent;
+        clocks = <&clks S32GEN1_SCMI_CLK_GMAC0_AXI>,
+                 <&clks S32GEN1_SCMI_CLK_GMAC0_AXI>,
+                 <&clks S32GEN1_SCMI_CLK_GMAC0_TX_PCS>,
+                 <&clks S32GEN1_SCMI_CLK_GMAC0_TX_RGMII>,
+                 <&clks S32GEN1_SCMI_CLK_GMAC0_TX_RMII>,
+                 <&clks S32GEN1_SCMI_CLK_GMAC0_TX_MII>,
+                 <&clks S32GEN1_SCMI_CLK_GMAC0_RX_PCS>,
+                 <&clks S32GEN1_SCMI_CLK_GMAC0_RX_RGMII>,
+                 <&clks S32GEN1_SCMI_CLK_GMAC0_RX_RMII>,
+                 <&clks S32GEN1_SCMI_CLK_GMAC0_RX_MII>,
+                 <&clks S32GEN1_SCMI_CLK_GMAC0_TS>;
+        clock-names = "stmmaceth", "pclk",
+                      "tx_pcs", "tx_rgmii", "tx_rmii", "tx_mii",
+                      "rx_pcs", "rx_rgmii", "rx_rmii", "rx_mii",
+                      "ptp_ref";
+
+        gmac0_mdio: mdio {
+          #address-cells = <1>;
+          #size-cells = <0>;
+          compatible = "snps,dwmac-mdio";
+
+          ethernet-phy@4 {
+            reg = <0x04>;
+          };
+        };
+      };
+    };
-- 
2.37.3

