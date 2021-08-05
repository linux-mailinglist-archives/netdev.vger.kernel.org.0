Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE09B3E0F82
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 09:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238792AbhHEHr5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 03:47:57 -0400
Received: from mail-eopbgr60070.outbound.protection.outlook.com ([40.107.6.70]:25821
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238757AbhHEHrW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 03:47:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kT8ODbzBpNSmei6Yv5WZM392oK7gWJhcUEpzoa2xLr+GCsvHq32VWEmv7tj/f/4emgsDYNY8Vj8gtipqXgmDZ0EFUsFmYONIV3xDirePJeKvzaEPR9meT7THkIBGY9v9khSFJiC7ogoB6HDfush9YyVd+vh9x0dcSMrrnYg3QYVVJxkSIpNrbvxWtbnwUqZpr4LKzz0+RTtqQpL+HUX3xOVTM0Wem4cED91FjVOdfe0uujajP+rjqD1mYITK3QF+j6leDA6zrEhFL/OMI7C7gsbd85he8+Wy/REiTzHR8wVJX9yEuzSEkynflVZypiz6wg5LxMGOnAttKiC6dHAJDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KMEOBtzgBPiftScxPqR+pMPKOyNWfphfWGh5oHXNSYc=;
 b=PzXZ14BjUf7cMWDH++rqOUFC43eaiCTjIlX8MszPPnoqztvvUsxrOsPiwYM3PWCSywnzLeyTTr/PYAXy3pNxCu6zoCauThsEn4NhU5k01CkkJT2R6PFWVhZ76HyaCexBNh2HxmvqvVDqOPeqG2EcbcUkCjaK7yu36H+iNuzlijCsjtNbCV7Oxl6hUIefeV84bpgWJzWFXZA9flsnPYRZQwDDpUEWvOAh8/91o1wykcIF9g+XuDYmzwg4CGIVwj2wxo0JbBlK2ODeJfSuI0QhYdQLMM06sH1Qz3VjAEhlmyfEzCKYhxBGlzEWAFq7Zg6fhWAsqguCTVSL7Ze2wm/IZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KMEOBtzgBPiftScxPqR+pMPKOyNWfphfWGh5oHXNSYc=;
 b=nlBSpTe80jlscdtjog0TkEff7KAxk5dRnyczNAfHRNcRtAAQ1VN+z6eQLnOMWzhZsSVRXXxKcgX4Fzku+KG/4liOFLV0cHFc50J5qqBxJMgydlPGsxS79AKTmExTPWhlwMDDXqGGSWAzMYHin/Y9fXHLX1T9AgcACZ93HVOjoBA=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBBPR04MB6249.eurprd04.prod.outlook.com (2603:10a6:10:c6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15; Thu, 5 Aug
 2021 07:47:06 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802%9]) with mapi id 15.20.4373.026; Thu, 5 Aug 2021
 07:47:06 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        shawnguo@kernel.org, s.hauer@pengutronix.de, festevam@gmail.com,
        andrew@lunn.ch
Cc:     kernel@pengutronix.de, linux-imx@nxp.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH net-next 3/3] arm64: dts: imx8m: add "fsl,wakeup-irq" property for FEC
Date:   Thu,  5 Aug 2021 15:46:15 +0800
Message-Id: <20210805074615.29096-4-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210805074615.29096-1-qiangqing.zhang@nxp.com>
References: <20210805074615.29096-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2P153CA0009.APCP153.PROD.OUTLOOK.COM (2603:1096::19) To
 DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2P153CA0009.APCP153.PROD.OUTLOOK.COM (2603:1096::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.1 via Frontend Transport; Thu, 5 Aug 2021 07:47:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 85d4fb59-3b2b-4e4e-28ff-08d957e5388e
X-MS-TrafficTypeDiagnostic: DBBPR04MB6249:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBBPR04MB624995D4BCDBDB530D8D6C60E6F29@DBBPR04MB6249.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:989;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xDjLflYHYG0n7X5KLe165fNrRR7Sx+yPWuTi8NcBigU5Xhp0Ag6aYpu3gopDxHn7wU4TR8oRoMRoaXnCGhWJcgY9udipVLi5i/n6rdLZ36aqFyqBWi7vx4PKue7DBYy7I4rikJk4vvqsIst2/J1e7SLsvyc6NVZyo/DZskEsEoB/qmJQVlM+Icv9NyMp4smrffdXZ7ybTlDvxief5jE6rFYNunWphUTCENz5slQUvZ85piCeQf7bj4xOCIA6LwR/sXbibPDmmhFpy2l4ma/OXWrJttJ1MyPEdt1PsCEBB2XqZ9I77Tduzhw1rH48gFBzvYtjrk2wTDE0X2sS91wNCfE5dSd8AKmXe5MsXd+2nULv4I3R1kguIXV5YoS4wIdwSWjxQRs8jZYr8Gzpr/IUcC7Z2cl1KI6dz71sY3atUvTtCgpP5qTo/pm74/AnFxNFpD1l0NQl8GZNWfuyTmfrfyZiNjKGzTlRw/AibXwsgPtXMie324R8Olrmk/fb1FNPy51QATK3dUlOOSNN1P92kPcPXHClvDoDtI/7dvYHjrGgMtcLaXNUHr8tcCZn23CLQrocS/LfOiceVTrFZKXx8UDhS3LM0R2gq3CBzVCbrjWsmXVh2SxtNHglbf0DiY9vKJw8L2v9n30/ge8X+stSvJcWa3kPkMfJKqZdr9WzUJg/JpaiNxlsKErDSEOKsxxJsoxdKouJqPROLfC+/a0sqIRGDCCU0Kl2pl8q4Cn9+Js=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(366004)(396003)(136003)(39860400002)(2906002)(83380400001)(186003)(66476007)(956004)(316002)(7416002)(2616005)(66946007)(66556008)(6486002)(86362001)(6512007)(1076003)(6506007)(52116002)(4326008)(8676002)(8936002)(26005)(38350700002)(478600001)(6666004)(5660300002)(38100700002)(36756003)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tpdOwUdZSyJbpeG6QUh2TutKtsD9rjnyIGCrj3h3uiURfLYNGFYwZwY0z2zK?=
 =?us-ascii?Q?PhdzemSFJ3e/sng1o82GB59DZeKvAkic5epqVPRN9i5mUPX1ZMQ0GYk8hhPw?=
 =?us-ascii?Q?bh4h0BXzLR1dk43ff1yx9EGgFzvfpm5xBU8/poZ2to6KBrPccdfHSQLce784?=
 =?us-ascii?Q?HCv/pwpR+aADKjZk1Vos+J+ErLwLSa3F81eZAkQnuXxar/lWZ2+2n4VbFZzF?=
 =?us-ascii?Q?aJC6X6x9Kd9tjJYWt1Puy5r67xcAu5MPG5hcweHUNclzGYOp+413OuJmSAJ8?=
 =?us-ascii?Q?TfANdGwD+gNPiyUeSFRDuAm+TmTd9kMFkOFm98zm6XEteEsy0GGiQKGLL/+5?=
 =?us-ascii?Q?yf4Mfm8XfScoaFGQygBKNYFWwhYFnQDgIONdwfxx4eOIV1f5/uO+F8NmtemG?=
 =?us-ascii?Q?j0W+N5nRqMLA4cFAFKfuia+5E5ZhedZVUOjAgPHu+uvCXnSbvcd2pJj7F8Nv?=
 =?us-ascii?Q?DJHHx9JEc4uVZubohUHlX53n/BMsEOY5VdPzHGeq4/lr1EtgnUhAd7M2ytJ8?=
 =?us-ascii?Q?KM+5F05XsYfcFWJ7aprHa+l1qetI2S6HEk/Xf2NfN6hSk5USNXCA25auiFic?=
 =?us-ascii?Q?0+IQ1Xk1H1mOWbuIC58WRdrdU7bVirNyS7vuVFAB9aw0uQZ3wgdIHM80rpSx?=
 =?us-ascii?Q?n3h+hvkjSGrOViEEmtBU0Kpc0FLU3YygTx8L7qpzWoRPMEd475gO3mCVdroA?=
 =?us-ascii?Q?j773wP2auacM8vJx8PdDgqBiT4dN6OotNPibW0l9QBI9aJ09mFfTSBiVqdSQ?=
 =?us-ascii?Q?OMnJMjog6WCzAucjel2x8z5gNBrufM7tYwwSlq+MoNky45ojRi73ZvcPdWjP?=
 =?us-ascii?Q?MP/ow3TcYK7ZMbCnvqwnfPNeHCWbK4gpLbfiOh8h2c6KT4pNRukqR7LA1XnO?=
 =?us-ascii?Q?2Ee7jAFqZqPb1JZIC52sqYpriZ1trypObovj/t5egKtFC3xAUMuoRT/VQj8L?=
 =?us-ascii?Q?VxUAU+6Nqz64UFQJa6GehqmlbFlAHr274Ehr7crKwWXASZx86oMzX1aRPD2X?=
 =?us-ascii?Q?WIR8Ew4GwenBa3TwZCsCVceSGuIYQkiZT4td9cyg4+V/aKyIXD71OztswBzf?=
 =?us-ascii?Q?BS6iAKy0pEeD0gauwfy08S3vR+kt4WJZFzr30EgLpsSlVkqciLV3sBIfVOhr?=
 =?us-ascii?Q?upDLJDzMe0FQDuRuOYjbCbMrcpAJzVNHFfwUAAVecJxovpIc/HYo2gG66RYo?=
 =?us-ascii?Q?GbpTsAdVllxVebJ2T0LqKVk1KfIzVgP5Gy7YVRJis5Y5X4gYvE21jsDzOcyi?=
 =?us-ascii?Q?WV1EmtPykVfv+J23W4y+dxNIkA3Yx+T+3jofymGaHE15RmIPjVwpPZUTKJT6?=
 =?us-ascii?Q?n0iuc7HL4cbzrLYagkH0ia6S?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85d4fb59-3b2b-4e4e-28ff-08d957e5388e
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2021 07:47:06.0590
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ln7SucEl+Os8RQo0RltoJMjm5WVDLaIZEUcKZ2u56jrianDd+4WBcVm8LnjvWzwA+maQk8JXOU/M4hs71MV5zw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB6249
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add "fsl,wakeup-irq" property for FEC to provide wakeup irq source.

Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 arch/arm64/boot/dts/freescale/imx8mm.dtsi | 1 +
 arch/arm64/boot/dts/freescale/imx8mn.dtsi | 1 +
 arch/arm64/boot/dts/freescale/imx8mp.dtsi | 1 +
 arch/arm64/boot/dts/freescale/imx8mq.dtsi | 1 +
 4 files changed, 4 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm.dtsi b/arch/arm64/boot/dts/freescale/imx8mm.dtsi
index 1608a48495b6..11aac9209944 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm.dtsi
@@ -948,6 +948,7 @@
 				nvmem-cell-names = "mac-address";
 				nvmem_macaddr_swap;
 				fsl,stop-mode = <&gpr 0x10 3>;
+				fsl,wakeup-irq = <2>;
 				status = "disabled";
 			};
 
diff --git a/arch/arm64/boot/dts/freescale/imx8mn.dtsi b/arch/arm64/boot/dts/freescale/imx8mn.dtsi
index e6de293865b0..2c921ba519dd 100644
--- a/arch/arm64/boot/dts/freescale/imx8mn.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mn.dtsi
@@ -951,6 +951,7 @@
 				nvmem-cell-names = "mac-address";
 				nvmem_macaddr_swap;
 				fsl,stop-mode = <&gpr 0x10 3>;
+				fsl,wakeup-irq = <2>;
 				status = "disabled";
 			};
 
diff --git a/arch/arm64/boot/dts/freescale/imx8mp.dtsi b/arch/arm64/boot/dts/freescale/imx8mp.dtsi
index f4eaab3ecf03..ce4efe0a9bca 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp.dtsi
@@ -814,6 +814,7 @@
 				nvmem-cells = <&eth_mac1>;
 				nvmem-cell-names = "mac-address";
 				fsl,stop-mode = <&gpr 0x10 3>;
+				fsl,wakeup-irq = <2>;
 				nvmem_macaddr_swap;
 				status = "disabled";
 			};
diff --git a/arch/arm64/boot/dts/freescale/imx8mq.dtsi b/arch/arm64/boot/dts/freescale/imx8mq.dtsi
index 91df9c5350ae..d7b68630098b 100644
--- a/arch/arm64/boot/dts/freescale/imx8mq.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mq.dtsi
@@ -1191,6 +1191,7 @@
 				nvmem-cell-names = "mac-address";
 				nvmem_macaddr_swap;
 				fsl,stop-mode = <&iomuxc_gpr 0x10 3>;
+				fsl,wakeup-irq = <2>;
 				status = "disabled";
 			};
 		};
-- 
2.17.1

