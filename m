Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A9B11E079A
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 09:15:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389043AbgEYHOk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 03:14:40 -0400
Received: from mail-eopbgr70053.outbound.protection.outlook.com ([40.107.7.53]:1606
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388932AbgEYHOj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 May 2020 03:14:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m6lg6ZbtVwMuM3rcAJpItYhB1yfQDTMWfLdL7ColVDjeRLuncHJutmN4PL73iJ5R2amUfIwZYEOKBjpUFQP4GKoteegwVsM5IKWgcazgZbPZY8irHXsHLEj9FtxLlUSNl8qWLy5E53R+XksRr/5PMjnVCIhoEnGiZYsOjIvAlAf04f4vE/bghw/zIwlll9LLm4RxmpRnjG5YpJw177ESulPDk6mGhiLT0ulpwDvLYDbceyLR8S2xAK1TTnjdl5dRFsSvm7oR5y3f8WauWJn1681gdROKgmVGq+NZtsxFLvzOUcZz44dCOrTqgh9IYsf+4SknJQIkYac9oJz4YUiXHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0+egVCaipiCG381DrpLO0ogjSrGIRRuIyw6tt8O/NjU=;
 b=hkgPR/al/AHLFPVdBGGQAYcoJha/W1Y1OFqrey57bh7bTiN+S/oPkL/xlTj2l/HNvMhBO9ELuLSR6jPFU654nsFklDjEFrMOa2wCIabsFxeG4mQeW6EaIgYDcuu1lgU/eKkgabzttoF9Tz7X+jnpVVr2/Xau0Q7QMoCYVTFzCx/iX1nVyzP784KVvQuWiYMJjgJbmD6unskDfdDUt26f2zaH5wiARbc3mUkRC7FVfoVUjzKHqj+4jsy1p22bcx9jCMcyyQ6Sg2l3yNGctEqv6GQZIBX5OPr79Vf+EnSVGsen8cOi4ZuuZhIz2dWCxVXpvE2adIpE1fTVzbfN7qE7XA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0+egVCaipiCG381DrpLO0ogjSrGIRRuIyw6tt8O/NjU=;
 b=BwrCbjvDn60T/V9hqlqQUFUsQttCxg3CQha13fdpIygD7R+pD+ZWTeg7xmb2rL/bWoKUUCyqtpKnPZjDZ68EOArp+yP1ld8gXNkP7rQcHpa0cmKEOEjuh+OwkkdDna6ZfNmFgELoYHzLyjnAUrjisuMoIp+0HwG/rH+UaM3h1OQ=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18) by AM6PR0402MB3735.eurprd04.prod.outlook.com
 (2603:10a6:209:1a::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Mon, 25 May
 2020 07:14:25 +0000
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1]) by AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1%7]) with mapi id 15.20.3021.029; Mon, 25 May 2020
 07:14:25 +0000
From:   fugang.duan@nxp.com
To:     andrew@lunn.ch, martin.fuzzey@flowbird.group, davem@davemloft.net
Cc:     netdev@vger.kernel.org, robh+dt@kernel.org, shawnguo@kernel.org,
        devicetree@vger.kernel.org, kuba@kernel.org, fugang.duan@nxp.com
Subject: [PATCH net v2 3/4] ARM: dts: imx: add ethernet stop mode property
Date:   Mon, 25 May 2020 15:09:28 +0800
Message-Id: <1590390569-4394-4-git-send-email-fugang.duan@nxp.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1590390569-4394-1-git-send-email-fugang.duan@nxp.com>
References: <1590390569-4394-1-git-send-email-fugang.duan@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0213.apcprd06.prod.outlook.com
 (2603:1096:4:68::21) To AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from b38611.ap.freescale.net (119.31.174.66) by SG2PR06CA0213.apcprd06.prod.outlook.com (2603:1096:4:68::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.3021.23 via Frontend Transport; Mon, 25 May 2020 07:14:22 +0000
X-Mailer: git-send-email 2.7.4
X-Originating-IP: [119.31.174.66]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c6140ca0-0d11-49cf-c544-08d8007b413b
X-MS-TrafficTypeDiagnostic: AM6PR0402MB3735:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR0402MB373530230E7581FB6AC1350EFFB30@AM6PR0402MB3735.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2276;
X-Forefront-PRVS: 0414DF926F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DSPJ+sb46cIx2xGiWn/Ah7/BRclAZbxzjOuvqz/fqCvvb1zPQTtf7iHEaSou9U6fpzKGQ5W7O6Rp72eSRs4772cHUO0nqRyqNbTA3jX05dlDvG34X3iC7brgdug1xagieXf1O5FqmBhXeKoYDvEQba+1+crMaER93Igvh0dRSuryoNHmZybxZBgNrcGMXhfI2s0YgU5QbcX+J9ah9jkXZb8poKCS6M2TJqcQEuyif1GhdU5Rx1Q3Ne1qM7sZ0/GvM3gsYJ86ifPcKxPX4WVL/x/F2tvTinuKL9IJWZKhCNeF4att3KVCtKiM+Rw980MDLeZAidltSiAW2JYVWk3ZNQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0402MB3607.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(39860400002)(136003)(346002)(376002)(366004)(316002)(956004)(2616005)(66476007)(52116002)(6506007)(66556008)(66946007)(86362001)(36756003)(26005)(5660300002)(6486002)(16526019)(186003)(6512007)(2906002)(8676002)(9686003)(478600001)(8936002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: OI09dRPGRca4OB5CCCmEgzhJAHNXmLz1X96PIA7dVNyawECYgULhjIpVg55wyCSAZ/uTFR4QdwPr+U66wYTF5ANU2rHcd1rRiTvCbjyYnYovY5eIygXHwlbvFZkHwymADljNBrdhlviTgROBwAN1Vs4wAr+0r1hzY4ymI38rcEvvR3kN6C6QwL965ypWoNP3F37a6nXteRFMWU8mTunGA2B2dfSoNN3aQlqCbD6TxTAMWKmkQwvy0/fXMXWzovUHwd0vnEaDhoBpNHcm8kZIJbeWbtK26Cwohxyq0zK3h+6StHayjnnkCaWUzOGJRceSxir2GkTXDRdX30AFy+h/O4adH0W3NFubxY/CtPYixWgXqNJxgv8XdZNq2qHxFElC4kNxBbyjbLBIoQMiu427h6Qd/+NiWYuCRuz8w9gg7v9DOEPOnL/98GLZLRC1e6asoh9nBO4YEIrWI5bTgE/1x8gCWrLVzw51a/vTxvP0mwcj2wUNaTILvvhRxQHcKhP/
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6140ca0-0d11-49cf-c544-08d8007b413b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2020 07:14:25.0297
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 223yl5LQ5pETvLYRFL5RY8vkUNbjqRylao00e2iJrl9+pRXxUztOx1f8qV4M56UlFNk/g5sss0VZV6rfVAb2mg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3735
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fugang Duan <fugang.duan@nxp.com>

- Update the imx6qdl gpr property to define gpr register
  offset and bit in DT.
- Add imx6sx/imx6ul/imx7d ethernet stop mode property.

Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
---
 arch/arm/boot/dts/imx6qdl.dtsi | 2 +-
 arch/arm/boot/dts/imx6sx.dtsi  | 2 ++
 arch/arm/boot/dts/imx6ul.dtsi  | 2 ++
 arch/arm/boot/dts/imx7d.dtsi   | 1 +
 arch/arm/boot/dts/imx7s.dtsi   | 1 +
 5 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx6qdl.dtsi b/arch/arm/boot/dts/imx6qdl.dtsi
index 98da446..48f5016 100644
--- a/arch/arm/boot/dts/imx6qdl.dtsi
+++ b/arch/arm/boot/dts/imx6qdl.dtsi
@@ -1045,7 +1045,7 @@
 					 <&clks IMX6QDL_CLK_ENET>,
 					 <&clks IMX6QDL_CLK_ENET_REF>;
 				clock-names = "ipg", "ahb", "ptp";
-				gpr = <&gpr>;
+				fsl,stop-mode = <&gpr 0x34 27>;
 				status = "disabled";
 			};
 
diff --git a/arch/arm/boot/dts/imx6sx.dtsi b/arch/arm/boot/dts/imx6sx.dtsi
index d6f8317..09f21aa 100644
--- a/arch/arm/boot/dts/imx6sx.dtsi
+++ b/arch/arm/boot/dts/imx6sx.dtsi
@@ -930,6 +930,7 @@
 					      "enet_clk_ref", "enet_out";
 				fsl,num-tx-queues = <3>;
 				fsl,num-rx-queues = <3>;
+				fsl,stop-mode = <&gpr 0x10 3>;
 				status = "disabled";
 			};
 
@@ -1039,6 +1040,7 @@
 					 <&clks IMX6SX_CLK_ENET_PTP>;
 				clock-names = "ipg", "ahb", "ptp",
 					      "enet_clk_ref", "enet_out";
+				fsl,stop-mode = <&gpr 0x10 4>;
 				status = "disabled";
 			};
 
diff --git a/arch/arm/boot/dts/imx6ul.dtsi b/arch/arm/boot/dts/imx6ul.dtsi
index 2ccf67c..345ae9b 100644
--- a/arch/arm/boot/dts/imx6ul.dtsi
+++ b/arch/arm/boot/dts/imx6ul.dtsi
@@ -520,6 +520,7 @@
 					      "enet_clk_ref", "enet_out";
 				fsl,num-tx-queues = <1>;
 				fsl,num-rx-queues = <1>;
+				fsl,stop-mode = <&gpr 0x10 4>;
 				status = "disabled";
 			};
 
@@ -856,6 +857,7 @@
 					      "enet_clk_ref", "enet_out";
 				fsl,num-tx-queues = <1>;
 				fsl,num-rx-queues = <1>;
+				fsl,stop-mode = <&gpr 0x10 3>;
 				status = "disabled";
 			};
 
diff --git a/arch/arm/boot/dts/imx7d.dtsi b/arch/arm/boot/dts/imx7d.dtsi
index 4c22828..cff875b 100644
--- a/arch/arm/boot/dts/imx7d.dtsi
+++ b/arch/arm/boot/dts/imx7d.dtsi
@@ -153,6 +153,7 @@
 			"enet_clk_ref", "enet_out";
 		fsl,num-tx-queues = <3>;
 		fsl,num-rx-queues = <3>;
+		fsl,stop-mode = <&gpr 0x10 4>;
 		status = "disabled";
 	};
 
diff --git a/arch/arm/boot/dts/imx7s.dtsi b/arch/arm/boot/dts/imx7s.dtsi
index 76e3ffb..5bf0b39 100644
--- a/arch/arm/boot/dts/imx7s.dtsi
+++ b/arch/arm/boot/dts/imx7s.dtsi
@@ -1190,6 +1190,7 @@
 					"enet_clk_ref", "enet_out";
 				fsl,num-tx-queues = <3>;
 				fsl,num-rx-queues = <3>;
+				fsl,stop-mode = <&gpr 0x10 3>;
 				status = "disabled";
 			};
 		};
-- 
2.7.4

