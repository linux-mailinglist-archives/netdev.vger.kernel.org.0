Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 428841E12BA
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 18:32:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731508AbgEYQcQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 12:32:16 -0400
Received: from mail-eopbgr150084.outbound.protection.outlook.com ([40.107.15.84]:14054
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729338AbgEYQcP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 May 2020 12:32:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RQZgCVKgusC69Ub5iQxzEewQTCbqyybdDS3jw4Hmn0MJ+81K9e9kK51d69N+eG4uv5ABwqPeamSVyulEgCqJ2Or+6qp/gLgWc81bvqpTF4JZzCmkBncSR7zbbFP1752jRhK7OvkkhJvdbEYlyzrNjeWWPCOryjqqmlOBQ5xVSA98aMHDa7hS+NNneeOQdeDSepFvruVuk1x+TrhQln5E1esAQyJOXavrMPJDy5TuxRXMomg8pX3RQgi1pVp8MCcIUxAZyyR88pmp3uFuEZZLhY8hjEJnsOWbLW/Szv8oUN1A0TBWqhh9ed151SccDuJA8M1xw4SF6urXOOo3j5+Qjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sKApi7OFIZjahR+oMnE92eVZbfDWX8XnChEMx5RAYQU=;
 b=TnC4ZdC2IPUXX6Y0qX60FLlm/HvkBETy/GB76u1erV+S9IICO5a4LQAYKgt7Ck5qnCcqNEn3YoeeMxFWMVX1XVoH/VsZaBYoxtpEm2CCRqdq1G+eC/Bn/Y5gqO/6mFOZ+3RFfqgcEUAMbv/JpqectaBV40FUSy4AkcnsRQ6M6XbW8x8pLz2g1whHKYnJHSZS4JUC0aRXtv3+/PXw/lhpa39/YqO2/gIR3mz3ZTplFLR4ftJ3CWYcmbHk74Ei8onrXcZ/5NUb+afQAUddj0s2sqeUdNToAtYSArfd7J/Sc+wZw7ZdYIkQKcyi7H/EbSBU3qtpm5wEVDI4y1+MzQE+7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sKApi7OFIZjahR+oMnE92eVZbfDWX8XnChEMx5RAYQU=;
 b=PbhFEO3LVEuoNiYAJaadQQgL26lPt6V0QNa5uR8CfzlxWrUU2Imx4xIAgm60EoLzL59vavT3b+W5iO1Y1ZYGEIXawHTEwuwKbTM1zWP258Rffhl9TJrwBkruEHrb4kuWFGAtSi3aOJ6az9+2omocjesfmozZ2XheVZoHsi/CNrA=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18) by AM6PR0402MB3846.eurprd04.prod.outlook.com
 (2603:10a6:209:18::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Mon, 25 May
 2020 16:32:12 +0000
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1]) by AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1%7]) with mapi id 15.20.3021.029; Mon, 25 May 2020
 16:32:12 +0000
From:   fugang.duan@nxp.com
To:     andrew@lunn.ch, martin.fuzzey@flowbird.group, davem@davemloft.net,
        s.hauer@pengutronix.de
Cc:     netdev@vger.kernel.org, robh+dt@kernel.org, shawnguo@kernel.org,
        devicetree@vger.kernel.org, kuba@kernel.org, fugang.duan@nxp.com
Subject: [PATCH net v3 3/4] ARM: dts: imx: add ethernet stop mode property
Date:   Tue, 26 May 2020 00:27:12 +0800
Message-Id: <1590424033-16906-4-git-send-email-fugang.duan@nxp.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1590424033-16906-1-git-send-email-fugang.duan@nxp.com>
References: <1590424033-16906-1-git-send-email-fugang.duan@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0102.apcprd01.prod.exchangelabs.com
 (2603:1096:3:15::28) To AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from b38611.ap.freescale.net (119.31.174.66) by SG2PR01CA0102.apcprd01.prod.exchangelabs.com (2603:1096:3:15::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.3021.23 via Frontend Transport; Mon, 25 May 2020 16:32:09 +0000
X-Mailer: git-send-email 2.7.4
X-Originating-IP: [119.31.174.66]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8b6ff3dd-5598-4caa-391f-08d800c92d2b
X-MS-TrafficTypeDiagnostic: AM6PR0402MB3846:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR0402MB38461FEB8B78733DD0156936FFB30@AM6PR0402MB3846.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2276;
X-Forefront-PRVS: 0414DF926F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Hk8f9/RuwE88IJkSbn2CE4eK92m05O9/igL9tXCZ/mlBPr3JzUbibNY/TsuotlVs95vjq0nyrq/xHz3PZWu8l7hvdHWYmokVU5d5V5Fi3aEUUTS5FmEiTxa5YMO++Kv5RCsW2NixYAFDkGj1jyvMURWp/g/jZV3PYloaBvI0Wz9pOAvfz4cyJrySfqfK0XJISTS2Rk+cnf9s/kgiMR2Td999iClNZkeD4lCUHWeloPiLVGUxk/sxEVMW9rczdaVKAtfvd3kOBDoUDX+6y3gvR7yRHMeBI9/xELUTy64HZ67pzE0ibWz4C87uZNfHYtSdL09DnEfYEywv3j0B+6HP9A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0402MB3607.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(396003)(39860400002)(366004)(136003)(376002)(6512007)(9686003)(4326008)(36756003)(16526019)(86362001)(6666004)(316002)(6506007)(2906002)(52116002)(5660300002)(26005)(186003)(66556008)(8936002)(66946007)(66476007)(956004)(2616005)(478600001)(6486002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ie5hqXFe5iUOb4zsJkALfxzyy3tQoVYOFdxm7sml6YeRWUFZmDGBBP6kXMHTOAjLwcctoEymv4t/POV81L8vGhMg6t9EHF1DKXxRQL/BXsru0kT9ve/zuKKc4t6Mr0qiIYlgeX1WbeQfB7xZHxlRaN4ei+r4qMDfKAybDIByedvVrAPq5exxdfhk5udLc9PmpDD7dbqS5LTxkGVCS3vRHcPYdG2XRNMExiD0VmGQXEskaaUVpuJ33WsXsNQ9rAbPZsGBUwpX9rcnHq//OmYuXSqn+iK8Qsz7f0A/ipTrvzrEZADKgqyIbIopm9wDW9C93AGLgFrEmQLYJUAo3X9j+pDBgdf7X4Oq2CIEPd+lUP8abVRTIg+WzErG343gYtX84m2IZGiX8cXDq+mo2GHvVPXKvPXDKqoE7eG35s2SVQ5WLpzCiQadyu/kukaFWun5wZMa829C5yNa1WQAjcMjATctUscaWhYhjp7hg7cUd8I=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b6ff3dd-5598-4caa-391f-08d800c92d2b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2020 16:32:12.0978
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1I8zt5kZVwhih+M3HhmbfUaPdAOz02QddCeXJUaPNgO3tCHExbvUZ6K2t/KzkqgAscqzEv3ITSPC9CbVQ26ktg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3846
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fugang Duan <fugang.duan@nxp.com>

- Update the imx6qdl gpr property to define gpr register
  offset and bit in DT.
- Add imx6sx/imx6ul/imx7d ethernet stop mode property.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
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

