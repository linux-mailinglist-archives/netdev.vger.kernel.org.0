Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 333FD457DBA
	for <lists+netdev@lfdr.de>; Sat, 20 Nov 2021 12:59:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237470AbhKTMCo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Nov 2021 07:02:44 -0500
Received: from mail-eopbgr40052.outbound.protection.outlook.com ([40.107.4.52]:6827
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237413AbhKTMCl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 20 Nov 2021 07:02:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LFjtFAA4L7RrSdWzZzoP9gGHuD4VIT5Oo9z6iAcmVf08dhE3ATKI05U8bfFJfJ7IGuqfxRelsb6wSvWCJZL//lmYL6pis8OrKipQt2qBqs5TGKehSCmVTA9MWAg5y0mPB/GAsKaSyFSmvQjo97usZL1GXAemRQ9Xu6XSnOPUkLOXaWwPwOwcJ2Rn5h176TsTtQNQdDMKcJrTni5zNtKGRcsn++VA30Gd8oOQQiIImjlnGL8cQT45B3vMZ8NWEbzehgyRWEQ9tZSaiki/gqGDHMUAPDbemVQV9Tl7ugkS4oULCV8P5/GqSnwjihocJyrzwg6NaOT5DoLybzY5QpY3bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pGeeSS9IfStgyT2mlRf5SVcTYFGV4fIqZ0bGjvSWyp0=;
 b=I8lOPeUV2eDs1Prmm1FCDrxltwJIHQ6eIXSzgHpSag9F5C+XsEkDuGdt0YOOWKi29nv+QJpe4q1aq6Rv43eAa9/urbwmsIwV5r853+XTH/H5Cfsl69w++9PTDp9viVuJ9d0vaBetzInonL5xZpBDv8Kc8s1GbpGEE1wkk2VCPNAUEJUAhKJCWEA9vnk2r11iq1AdVHj2IUZ8sjtT2zgdl36YC2x7mRQw53oEpY0/zwmquZ6Sr3uuMWTPYAAaBStH58Yk6VroUTUyIsomivVpXp2mQksAoTJr2RVgTfX4IqWYPd9buYpjPjSc0GZTkQWDecME0wFZHrKYjV4B38fdKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pGeeSS9IfStgyT2mlRf5SVcTYFGV4fIqZ0bGjvSWyp0=;
 b=OXn9QegjS5svv7R1gK1dQDSn3swtW2aln2i42kgFU6MgxhyFrdlUjTrkqfyvW8zx3ufMyGDuFGQeN0RcHGS+MCal/L/cvCPtpfME+wXEy8wUQ66A6MKzllXcoxdPMA3byJ5eLPFIrkiL1Xm5rCpMqaxIZwACWiQTiZEOLlqmQxk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from DU0PR04MB9417.eurprd04.prod.outlook.com (2603:10a6:10:358::11)
 by DU2PR04MB9082.eurprd04.prod.outlook.com (2603:10a6:10:2f1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21; Sat, 20 Nov
 2021 11:59:36 +0000
Received: from DU0PR04MB9417.eurprd04.prod.outlook.com
 ([fe80::82e:6ad2:dd1d:df43]) by DU0PR04MB9417.eurprd04.prod.outlook.com
 ([fe80::82e:6ad2:dd1d:df43%9]) with mapi id 15.20.4669.016; Sat, 20 Nov 2021
 11:59:36 +0000
From:   "Peng Fan (OSS)" <peng.fan@oss.nxp.com>
To:     robh+dt@kernel.org, aisheng.dong@nxp.com, qiangqing.zhang@nxp.com,
        davem@davemloft.net, kuba@kernel.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de
Cc:     kernel@pengutronix.de, festevam@gmail.com, linux-imx@nxp.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Peng Fan <peng.fan@nxp.com>
Subject: [PATCH 4/4] arm64: dts: imx8ulp-evk: enable fec
Date:   Sat, 20 Nov 2021 19:58:25 +0800
Message-Id: <20211120115825.851798-5-peng.fan@oss.nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211120115825.851798-1-peng.fan@oss.nxp.com>
References: <20211120115825.851798-1-peng.fan@oss.nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR04CA0012.apcprd04.prod.outlook.com
 (2603:1096:4:197::14) To DU0PR04MB9417.eurprd04.prod.outlook.com
 (2603:10a6:10:358::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.66) by SI2PR04CA0012.apcprd04.prod.outlook.com (2603:1096:4:197::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend Transport; Sat, 20 Nov 2021 11:59:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f0be0be9-7e32-4140-920e-08d9ac1d38db
X-MS-TrafficTypeDiagnostic: DU2PR04MB9082:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-Microsoft-Antispam-PRVS: <DU2PR04MB9082179B9A98BF783D8CBCDBC99D9@DU2PR04MB9082.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1079;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jjtO4xl3NpAiEwY+nWi0LFZ3SgvYfEJNhRrZZYUxsaXKf89+l0hiTOLmIUNXBZmBBzNerM7Tsjni4PtR6i47ttzbOdZViaTxXcrEJ21Uus4VQZVB1JiRxUDs86/MeYbX4v/BCHCO/1VnGLbic4vgH0G6UYS6SQlkZKLE+NEL/OM9SQ2eaYrxbWV8fBoSwzS+mRO7MG7fzx3CnZGTnmdPcroPlglsOCfT0zOqgd0ao9jG0ohbG3vw7FuaGUw5bQcP42RPRpyEqp9SahwsK4uCMbv25fMd7uBE2/9lWogWg4XhPyjSWjvpaL99/oTlRkuZtVh/s1iitmpJR/VbIESJR27QUn3SH2/IqZiTNgr4p+qq15IcM0DP+0KzaOB2BEUTJcSYMlOPSlqeXvgG/TCAJ/d6w+/3VJXs8hA3DDBRgiGfCJW9XCj0hsbbAbgp9DMHmis49W4XMk2uboqqxoAv+koap0JKOCvHcxeWlp2fjq8Ws9hoj0HOlPiNa2zsGDAcKaM6Yud96QkQP8EEq/tV9XughfvSNO5WznRDZQcbrBSQOn/Elep0jMqPTCb7MqjhAtK0RkYqniDO5uVSlZz41zgQdIpto+nxiPlgU+dfO0KUIH+JfXx27ATsi98GC5Re7Wyb13L48I6qFqzixZOdmccWuhaCApWIqWCAAkM/wjv1lLDdmBEcg2oaoaAoj2eQcfluVFDyKDs1PavEklaoy/uq6t7SaXK8qbixV2NLRfI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR04MB9417.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66476007)(6486002)(4326008)(5660300002)(7416002)(66556008)(8936002)(52116002)(2906002)(86362001)(66946007)(1076003)(316002)(956004)(186003)(6666004)(6506007)(2616005)(26005)(38350700002)(6512007)(8676002)(508600001)(38100700002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0tI+YnMjQiIDEp9IJSJsz2Nabu+Ydh09G36Li4F1PHLT/oBK0Dg0PMaXkoea?=
 =?us-ascii?Q?pPXO6IRRwlYoe70k00iphNwyDBcJ39+orlJ7BlS7hYggOFXTBTXl4OQHBrce?=
 =?us-ascii?Q?ctVIXoyTFV4ab3oW2GKwe9Dcz9irMVKgpSnPZt/v1sH7+lisPErbBPppH164?=
 =?us-ascii?Q?1UU1HWIOA8j6zP99L40K5oZWRAlayGVPAWcygGbaHvRtATPTpOS1NU0PLnMf?=
 =?us-ascii?Q?eUQP7dEayD8Vtc+EHusuCySNr+jUluC1rXPNMJ4btHIGhQFtUPJuzRYu2pNi?=
 =?us-ascii?Q?/YLw/kzJrIclAMwHE0QqiJ21lnYkkDw2EkfqmXPIKWLiSTvUT5jISOQlKxJt?=
 =?us-ascii?Q?0RDZ6wO3SgYuILEcj+GjUbmgqBCJ80lkf0ozIyQ3APPwqTiie0GgB+wCbk4t?=
 =?us-ascii?Q?+bTWI4G3IeODEVDc4QKV7rEo8dTk/Qq7Sw0xl8485iLxxM84st6elExMlHyL?=
 =?us-ascii?Q?y80MONpHqnGVNGRNciEjwsxgL+PHuNGfoUjMU+1XkgfCIqCpEKzk3bqBglVF?=
 =?us-ascii?Q?JOORZHyc0uECQSTVL8juCpdmxYdqbxlzPm/NET2YRehMYt3ad7zC3vUNOhZR?=
 =?us-ascii?Q?AFBs4FK0IJ7CseECCLRqTvJlnGL8XWgRs8aqfcM3Nl9p4c6GdzflFx3r/fLj?=
 =?us-ascii?Q?962jHJZ4pxT9ethSrsstWBayLg7av6Qc6c09cKXlvV+UNxvZRvVLWIRnJkst?=
 =?us-ascii?Q?LV8fTFJkQIySXRtg2ACidaTKEJMO0WaONoij9J4Q747twQe8DIE7dBRkVOXd?=
 =?us-ascii?Q?ldy/DSY3ejHrLAKiSlpGxYL9ndAtECz0Sn401v4uMbo175q23Zo1JjEWwWyC?=
 =?us-ascii?Q?0crcYP9hSOSdXLmQb5m8Bc1UDUlTxWsx06CgNe/WLH2jPLBWmz609GwF9www?=
 =?us-ascii?Q?BhtZdfOCt14/jwJ786lpw9ZFzCgz5M9ToSaSsWHPCp3lbXDlc8qyp4uyJcm2?=
 =?us-ascii?Q?kL7EnDuGY8JtILX7+Xc8PRUz/Pj4R5G/SdADE5tt4B11DWENntvgdjNKl89B?=
 =?us-ascii?Q?ZminemODKP59TTxEz+Vr4pzG4TVAF1hr3Q2r4SKExEpVYN+ILMnAGee0jzfb?=
 =?us-ascii?Q?O4D+wt3mlRRYxZTBQimK+4xKh/qLwgvITfYYF4S6s+xyesvmRr1J+7jxLxc1?=
 =?us-ascii?Q?6k5Dy86Gby8okTcNCBNRhhpj7NuRjiJb3ySSE43G/zeoxL00Tn6n3Oxj6KcW?=
 =?us-ascii?Q?EyX9SrW3QEDqsiXkm98C0WNYmyNdZQQz9/Lo0ShepmfCPpfQ+u6wTqpOOnRD?=
 =?us-ascii?Q?mdgSR0SAMIwi0cbW2mcAT4K7fKvLMeAc4762Xb9VQidyR6zpQ98eipOSOOTc?=
 =?us-ascii?Q?ZCmiuTOXD0sIrR0/ohg8RP6X8dv6GPMKm0bFeLW3v5zfsJFK7pmk3jM7QV9B?=
 =?us-ascii?Q?nR2oG2NDdvFxibfbAQ9Ah7+5pDfLpV0vlMzyPrr7Ntt+uKSh+Hn7zQGxpE+e?=
 =?us-ascii?Q?eZw9kF6wO+UdhRIzjzWmnMUfIZgV5WsIsSkykYOwaHWsSxttG9/YeAfyw58m?=
 =?us-ascii?Q?G67vS9G3JDPOTgVHdBmWQgzKRlgFBbJ30FD9FAXnc1QVyrHqW8YNov7I/2Zv?=
 =?us-ascii?Q?apnpwts4phMORax22PwU0BAmOkefjsfNtaJ7IbNwbOYFllZ991BUqGyulvi0?=
 =?us-ascii?Q?6GhVfpDDFHqNu2tLo3Xtpuc=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0be0be9-7e32-4140-920e-08d9ac1d38db
X-MS-Exchange-CrossTenant-AuthSource: DU0PR04MB9417.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2021 11:59:35.9251
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rhW6Y35qGOHKrHxNAl6pPQptO1zvfy8frcwROVuNjZx3QgjmWwuHoPLOe0IHia56sonxEfNjLTlfrFKGl20xvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB9082
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Fan <peng.fan@nxp.com>

Enable fec, add pinctrl for fec

Signed-off-by: Peng Fan <peng.fan@nxp.com>
---
 arch/arm64/boot/dts/freescale/imx8ulp-evk.dts | 34 +++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/imx8ulp-evk.dts b/arch/arm64/boot/dts/freescale/imx8ulp-evk.dts
index 33e84c4e9ed8..7103fed3a6cc 100644
--- a/arch/arm64/boot/dts/freescale/imx8ulp-evk.dts
+++ b/arch/arm64/boot/dts/freescale/imx8ulp-evk.dts
@@ -21,6 +21,24 @@ memory@80000000 {
 	};
 };
 
+&fec {
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_enet>;
+	phy-mode = "rmii";
+	phy-handle = <&ethphy>;
+	status = "okay";
+
+	mdio {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		ethphy: ethernet-phy {
+			reg = <1>;
+			micrel,led-mode = <1>;
+		};
+	};
+};
+
 &lpuart5 {
 	/* console */
 	pinctrl-names = "default", "sleep";
@@ -39,6 +57,22 @@ &usdhc0 {
 };
 
 &iomuxc1 {
+	pinctrl_enet: enetgrp {
+		fsl,pins = <
+			MX8ULP_PAD_PTE15__ENET0_MDC     0x43
+			MX8ULP_PAD_PTE14__ENET0_MDIO    0x43
+			MX8ULP_PAD_PTE17__ENET0_RXER    0x43
+			MX8ULP_PAD_PTE18__ENET0_CRS_DV  0x43
+			MX8ULP_PAD_PTF1__ENET0_RXD0     0x43
+			MX8ULP_PAD_PTE20__ENET0_RXD1    0x43
+			MX8ULP_PAD_PTE16__ENET0_TXEN    0x43
+			MX8ULP_PAD_PTE23__ENET0_TXD0    0x43
+			MX8ULP_PAD_PTE22__ENET0_TXD1    0x43
+			MX8ULP_PAD_PTE19__ENET0_REFCLK  0x43
+			MX8ULP_PAD_PTF10__ENET0_1588_CLKIN 0x43
+		>;
+	};
+
 	pinctrl_lpuart5: lpuart5grp {
 		fsl,pins = <
 			MX8ULP_PAD_PTF14__LPUART5_TX	0x3
-- 
2.25.1

