Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81E1C1E5AE0
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 10:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727069AbgE1IeO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 04:34:14 -0400
Received: from mail-db8eur05on2067.outbound.protection.outlook.com ([40.107.20.67]:57029
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726939AbgE1IeN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 04:34:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PvKQN2ExzRw+dslK/UlzesGKL+kDMDCAUvzLLboWCUYRIDAM8z8blwWNGTNyXrj+8N2z2qkO0rAlxL2zKlj/wCrb7kO3i/K5m5vVpoR2A/1+aULexgHzKfT6XR0z22v10jh8eEcq/2UOrovxzW0810aEJ7K0jfuomhTukpM3NYU9s1XWWOpACmoXEeJ/DFc2DhNlNffSE8LjNyLaZXeuGCtzgmSOyegzbrgqfAioGd1ksmcWneV0XSAJ0vPZgC4NKmxWeJLzE/ksoIP22uj3pNRhwcnKYQkus2hspSnJUPXTb1OAZXVHYe284z5fxQ8T13BMrOOtBMlJLLv+iQrHag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B5lhBVMfD0Ln0pujVI7Xs3RovjgkO1POC1Jb0ch3lC4=;
 b=g/0n8jpSPuBRyIvv71ZHcIEbMOfIX+HFfVgtfj8q021IiPu//bICke7bfZHfE97F5xX4GHFHq6lM8jLsHvzLyb3H6hwlyXae5Bpo3U+0RyifKe6vJ/hueF1JvwDuY4f8XDNbdqzwUeC2OKDhlg/MKkmrisScCLotupxSdpUnb5k0cyxBMre+ONrpmQnynpIbmpS0Bya4XsliGbb/CRC1YoAs9l1g4yGQ/UAHsQ7pygwo40kuyq13gbcR+TWt8iRAe8EdMB6LcnBny82chdKPKgBpcpUABkbxT3ihhNmFsL2TYhHoAoIL857FYqueNRvY5DcZYBv6KjH5beBQsq+lQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B5lhBVMfD0Ln0pujVI7Xs3RovjgkO1POC1Jb0ch3lC4=;
 b=bw8q6+uRar30j+s4aTjZmm9+GXL2sWulyrFtQmfi+2FEZ+cGRl2KYnUhki0VMmL+Uy65iFfDbA05m9xH43nJk7wFV9rnGr8mkjMAyrMPOXD0J2+QMp+D36msqVLRqhBhU9IYdoUR2/Q5j2XT1wdj1UeggOGyL8buKXUt3R5kLtY=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18) by AM6PR0402MB3768.eurprd04.prod.outlook.com
 (2603:10a6:209:1c::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19; Thu, 28 May
 2020 08:34:09 +0000
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1]) by AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1%7]) with mapi id 15.20.3045.018; Thu, 28 May 2020
 08:34:09 +0000
From:   fugang.duan@nxp.com
To:     davem@davemloft.net, andrew@lunn.ch, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com, kuba@kernel.org
Cc:     netdev@vger.kernel.org, mcoquelin.stm32@gmail.com,
        p.zabel@pengutronix.de, fugang.duan@nxp.com
Subject: [PATCH v2 net 3/3] dt-bindings: net: imx-dwmac: Add NXP imx8 DWMAC glue layer
Date:   Thu, 28 May 2020 16:26:25 +0800
Message-Id: <20200528082625.27218-4-fugang.duan@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200528082625.27218-1-fugang.duan@nxp.com>
References: <20200528082625.27218-1-fugang.duan@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR0401CA0014.apcprd04.prod.outlook.com
 (2603:1096:3:1::24) To AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from b38611-OptiPlex-7040.ap.freescale.net (119.31.174.66) by SG2PR0401CA0014.apcprd04.prod.outlook.com (2603:1096:3:1::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend Transport; Thu, 28 May 2020 08:34:05 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.66]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e3e8c3ac-9e2d-4ee3-28f5-08d802e1e47c
X-MS-TrafficTypeDiagnostic: AM6PR0402MB3768:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR0402MB3768A3DD7B354963814D61BDFF8E0@AM6PR0402MB3768.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 0417A3FFD2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O66UtHuLHozkjsQRqV0VD8hbXKwqIvmf7/+O0tnGAK1WOBPr850jhrxDNIYTw3wBb6Gcg4w2zNGNYoGLOSWMZjP9VmsFKln8Lx85EEay49J0tDZYri7kKw+/3Pf7RAok2bpeAC2e1JL2sEuDiZ5D0oXuqqTcQlZ48e3wrPc6k5ouL5MTdj812VSWeDSTxqFHdx0G0RA4HMLvniQV/IKMI8vEu+V7TVPlOHQ10KH0dVTW5xQw/RPq07QciYXSZTyH8afRnrhBNTQNI0mMVFvk4QBEj5KYH03Sup13dqNtksygoBEZujtufvb4VjKOzDGgcaFJosP585FZesCDIAP6VQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0402MB3607.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(376002)(346002)(136003)(39860400002)(5660300002)(8676002)(36756003)(26005)(86362001)(16526019)(186003)(1076003)(6486002)(52116002)(6506007)(478600001)(8936002)(66476007)(66946007)(316002)(66556008)(9686003)(6512007)(2616005)(2906002)(956004)(83380400001)(6666004)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: yA3Q8h80nt/xrUqgWWrFeoAfduP07Rw/+ajBP2RIHgVGBnGXSiLbo5HLfxxpG7yFuKtNSmbjaRc1bgVejKfjhjkgpbsK2yJgZ8Gbm1psNYj2hqQgZgHvJYSuFtS6oEFbY5c0mV+1AnjeczWy3ooIi0f+vbL5h+dw++iJrvhKypjrPd3BMRWTtrPkF+hIboLrl88+al7aceX1LynQUtRLKJRWrBGuvWZNwWJm6x66nBZzNmks5hm1iyQ6+OX6VMZiil62WyBKBSIDRR7YwgJq5M6/qtCj4puGDOCVqhiQmRQIi8CD2uvxVV2APt/PnS0rsrQdOzx0j81Tb95Wib9xwikW+l8C3DxTcBTbLFkPdDPYzLOsweXvatXD+jOImy+HfaMpUR1jUu32f28rQ/IIxSKHUIBG9wHHs9ut/wL3sLBgnCKjScTirkXPO9VhYJk63UrekVjRdIme+F4nTDZ33ioTkmus55afUftOlBneqlosjDs2ZKPzj0gAK60+hoTr
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3e8c3ac-9e2d-4ee3-28f5-08d802e1e47c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2020 08:34:09.8691
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dsbWhJdxpB9KDIGZ0mra9pMaAMtb5tXLuxdzCMUV9Cnuj6z46l4XBuTfgwYGeb7E6444/u5WUBn+2sVR6lEH/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3768
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fugang Duan <fugang.duan@nxp.com>

Add description for NXP imx8 families like imx8mp/imx8dxl
that integrate the Synopsys gmac IP version 5.10a.

Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
---
 .../devicetree/bindings/net/imx-dwmac.txt     | 56 +++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/imx-dwmac.txt b/Documentation/devicetree/bindings/net/imx-dwmac.txt
new file mode 100644
index 000000000000..921d522fe8d7
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/imx-dwmac.txt
@@ -0,0 +1,56 @@
+IMX8 glue layer controller, NXP imx8 families support Synopsys MAC 5.10a IP.
+
+This file documents platform glue layer for IMX.
+Please see stmmac.txt for the other unchanged properties.
+
+The device node has following properties.
+
+Required properties:
+- compatible:  Should be "nxp,imx8mp-dwmac-eqos" to select glue layer
+	       and "snps,dwmac-5.10a" to select IP version.
+- clocks: Must contain a phandle for each entry in clock-names.
+- clock-names: Should be "stmmaceth" for the host clock.
+	       Should be "pclk" for the MAC apb clock.
+	       Should be "ptp_ref" for the MAC timer clock.
+	       Should be "tx" for the MAC RGMII TX clock:
+	       Should be "mem" for EQOS MEM clock.
+		- "mem" clock is required for imx8dxl platform.
+		- "mem" clock is not required for imx8mp platform.
+- interrupt-names: Should contain a list of interrupt names corresponding to
+		   the interrupts in the interrupts property, if available.
+		   Should be "macirq" for the main MAC IRQ
+		   Should be "eth_wake_irq" for the IT which wake up system
+- intf_mode: Should be phandle/offset pair. The phandle to the syscon node which
+	     encompases the GPR register, and the offset of the GPR register.
+		- required for imx8mp platform.
+		- is optional for imx8dxl platform.
+
+Optional properties:
+- intf_mode: is optional for imx8dxl platform.
+- snps,rmii_refclk_ext: to select RMII reference clock from external.
+
+Example:
+	eqos: ethernet@30bf0000 {
+		compatible = "nxp,imx8mp-dwmac-eqos", "snps,dwmac-5.10a";
+		reg = <0x30bf0000 0x10000>;
+		interrupts = <GIC_SPI 134 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 135 IRQ_TYPE_LEVEL_HIGH>;
+		interrupt-names = "eth_wake_irq", "macirq";
+		clocks = <&clk IMX8MP_CLK_ENET_QOS_ROOT>,
+			 <&clk IMX8MP_CLK_QOS_ENET_ROOT>,
+			 <&clk IMX8MP_CLK_ENET_QOS_TIMER>,
+			 <&clk IMX8MP_CLK_ENET_QOS>;
+		clock-names = "stmmaceth", "pclk", "ptp_ref", "tx";
+		assigned-clocks = <&clk IMX8MP_CLK_ENET_AXI>,
+				  <&clk IMX8MP_CLK_ENET_QOS_TIMER>,
+				  <&clk IMX8MP_CLK_ENET_QOS>;
+		assigned-clock-parents = <&clk IMX8MP_SYS_PLL1_266M>,
+					 <&clk IMX8MP_SYS_PLL2_100M>,
+					 <&clk IMX8MP_SYS_PLL2_125M>;
+		assigned-clock-rates = <0>, <100000000>, <125000000>;
+		nvmem-cells = <&eth_mac0>;
+		nvmem-cell-names = "mac-address";
+		nvmem_macaddr_swap;
+		intf_mode = <&gpr 0x4>;
+		status = "disabled";
+	};
-- 
2.17.1

