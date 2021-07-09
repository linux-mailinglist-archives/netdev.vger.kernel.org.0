Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B92643C20AE
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 10:17:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231674AbhGIIUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 04:20:39 -0400
Received: from mail-db8eur05on2077.outbound.protection.outlook.com ([40.107.20.77]:51552
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231624AbhGIIUh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Jul 2021 04:20:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PM+WysTdq8QWzG4QWuWPFQ84RlkAix6KV76eYqx+YyOPR/tpY0sUMxNbotIK7PzD7iwRp/Kog1k5ktnfVfW0pDvX1Ea5LRNLNQFTlPYE+/PdgGCxTIsdAitm4eR77eSJ5N9Ckp+TB9sDtpIVMS0+txK5dVChpGZzFJddJ3bkLdEXZeuip7USngtuYUiuWXN5TigzQ9IIaHGOUE5ThBrKXF/i5Vj+jRGvzWi9/frThCBJDFbDSLzJXVQz92pnnqKN4v3iLrmDplG5+1B2xgyiYKdt6TY7ZdvxDF+x9XJKRl3MsA1CRhoUcH1Eguq6p1Wa0BeCDqreJ153ABwgtzpSrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dowxi3H2d10pnq22gLlhAyBp00VrgFO4i1zUQZkvSr0=;
 b=mJPSRWxv+3Ukkx8Gx/dMHGh3qHTOvx6vd5inJbcNHKpg4ZWS6u4NKLVnHSmaaLnf6K5Vc8CNe5aLHmwqzpqSmX8TGZES3Lut5CRJlVndkIA+IvcmmQ5oCDp7KckVt5+Td7Wh5SjXYgZbuGLWqaGnKIeTAJ35c0XEI/ObCpQngsnFTWigrO4zJ8bG/or6GNPG72mLaOLWvr6W6hXDzGNneNhT8n81Q1Rspq6/49//sLXPk0RQd6Zipp/vQewCmSL6nwUtj15pvPgs0FOY7rRkJW3pyH336l0N4kQfAaf8cOom+DAOVwbhDnQPo37LgbCjqm7dkp65dfB/AuellhEH8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dowxi3H2d10pnq22gLlhAyBp00VrgFO4i1zUQZkvSr0=;
 b=TXdhVWhJvknWidrhFDPjkpDb7iKsLIZwE7hc66AflnSL1ozwKMdqu4g/gKEubfXpMj56f41jiNJRv6peRGiivp8ey03WbqZfitxjVSK3lHryIQUgb/rQzm3UcZfoVwH1k+8nFee5AhQNWCsnYIY8zg4EsZd9UQx2kYcQ6fqOf3Y=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB9PR04MB8201.eurprd04.prod.outlook.com (2603:10a6:10:25e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20; Fri, 9 Jul
 2021 08:17:52 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802%7]) with mapi id 15.20.4308.023; Fri, 9 Jul 2021
 08:17:52 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        andrew@lunn.ch
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH V1 net-next 3/5] net: fec: add imx8mq and imx8qm new versions support
Date:   Fri,  9 Jul 2021 16:18:21 +0800
Message-Id: <20210709081823.18696-4-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210709081823.18696-1-qiangqing.zhang@nxp.com>
References: <20210709081823.18696-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0021.apcprd02.prod.outlook.com
 (2603:1096:3:17::33) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR02CA0021.apcprd02.prod.outlook.com (2603:1096:3:17::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend Transport; Fri, 9 Jul 2021 08:17:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7d11209d-8032-4c65-7ee1-08d942b20bc0
X-MS-TrafficTypeDiagnostic: DB9PR04MB8201:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB9PR04MB82014FFCFE2E043216083880E6189@DB9PR04MB8201.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: esl8pHydNufDkhUK76QWFVATjLiYgaBJe17ffqIFjeP1ulMrF//0MZmdioJwsudSXCRFMnkvnwg61av5FhaMu6t33NsdouhQp0GyGmDwIcgkvqhXEJoazoteGSYFcClTsgB8+4MfDQ2mFVgWFDBDBeuUtXKZQ8rhBdvDlt/SZWPFVVXJfDMJYDXh06BigTfsv7++gWqNIHJbpp54oXv3aw0+z6zwde83y1Q8DWC54N3YLlUqH9KmuoYHKlOua5jhAfHXwlemKxaX55kQg/fOBphEEGXAQkxYRTGzl5S4229VY+HFuzEvou+b2o3FQTbyTIBfN0wvgYvxHVOS7fLy1HGb4JOdkoGxQmoTx3C6g18MPZRIimMO4sKQBL2DhLLKmeGQm8yd/41zoC2iMb35NewKp7WAGLMtfXAVDfYoMOKEvEDzvPHgiVzjjQVR36q8L/qcxk/3MVkQkVXU7U6GocN7QvsagGV3hbR8t1B2quuRRnli2kUPy31Kmgq8bueOfGNNlj1RBkJEh7ytZXeKaSZLUFHGoxHPHCKHGdLz8G78hF5uRgTB4QiJK449EkAi0N39uOvux2yWOSKBNWTVBQEgSPC3VgSn4scf2XPxyqldGvTrBybmnWmSy8e0zAmfaMvn7a0hH3aQkeYnF/U5riHt9ASkEUNUGljIZCbhoMRbDbIsKtu2xtiLRnAXja9E/YEc8blPCqDTdpcmMT5O4WcndEGe6kUvQ5q/0Z7DtFM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(396003)(346002)(376002)(366004)(26005)(86362001)(6666004)(186003)(2616005)(956004)(4326008)(52116002)(5660300002)(83380400001)(38350700002)(38100700002)(316002)(36756003)(8676002)(66476007)(8936002)(6486002)(6506007)(2906002)(66556008)(6512007)(66946007)(1076003)(478600001)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cQaGU3GRmLp4coiJikJYMPfHDhOj1eI1K5YuKwZuS1DFfwos19P0SGuil+qY?=
 =?us-ascii?Q?vaAkATIEOO/3dzWhX87scIT+WEr6x93999mXgxxZHJ6fkpbJaHYQtc7eLw08?=
 =?us-ascii?Q?HbNBCfLMUyUWe/Xgf19iI1w5YKjiMpmqdabp7i5UBziV6cidbPwD1hFwFvVs?=
 =?us-ascii?Q?672rNJ+Yl/euSp70abYxNQAiCsh2gOFWwJWB4N3Hlcu63NtayGviNyJZxL5F?=
 =?us-ascii?Q?H7WTO7REaLmSzHBca/dpM2plwXO1Cub3BdLiq8lwZ28MFKnmVryiONnYiuQs?=
 =?us-ascii?Q?jmjunSj6VlOQ/sj+oVWWk9gvmHqfygwd++uL8LNf4DeOTw5JVKjH2UAozN5G?=
 =?us-ascii?Q?wWY8S5H/5BkiVmcpxDTh1BUT6JDtHByf8xFn1NrOPZNeSnWY5DQpoCOYV8Rm?=
 =?us-ascii?Q?6MJtU755n13M/qZmrNh4MWF9SpPmTxqwqW1I3PVEyYY2ZvusxLfMsi5jf2/g?=
 =?us-ascii?Q?+PwLRp2jIFMXEuRbw75oLgQlmRgLGW6hgafRFNijc6ihOi0o9oiK4GHSqTdZ?=
 =?us-ascii?Q?1O8Z2O2cmn+Iqw0op2IH17Q+u/px82bs85Av8rNDwpYcTrNCyIYRur2wg+vs?=
 =?us-ascii?Q?AZTxTADNGc7dRGj/atK/igcc8PW8UcYgqNGXYOKGwIGXf0Mt6KYCwrfhjbBN?=
 =?us-ascii?Q?WOcGNL8uPiUDQnJLOSQxQ2mlkpRXGnMqUzbPxhqxve7o5n81Vfw8pJ11un+k?=
 =?us-ascii?Q?2+yGOipGbG79Hl7DIFruOI7h+yVVz9Wo+QnUR/cFvxsXeHF2y46heE+yottu?=
 =?us-ascii?Q?lEnEDi4XpJlkyhFJtDWPCHe/P7GC57I7NlgYDwJnJ6TqQUNauF4i9Kvl4Qjy?=
 =?us-ascii?Q?nF2r0qz469Rr/7rnGUjf4HLM28WoSdWLVyWpl1KUWP8SWf30/0BuV7nY15H6?=
 =?us-ascii?Q?XdBb3yJp1RkyMM4yljUZF5SvVbl5a91NYUC0EVc0+z5Ts4zKMyx305s+w+my?=
 =?us-ascii?Q?gA5YBDJIoZ9HZsWUO+1yobXpSEghC3SE5d+eO8IiBjHHHB7VtlZspDcDZQyv?=
 =?us-ascii?Q?o2Ul1fYMyavMPhX5Ksc3idjmaqFo0MjVQbssYJxufTi7Lvs2IR16aO2fhvfO?=
 =?us-ascii?Q?Z2lop1NQAuozBb1F2GTTN4E6zk4tmyQ7ksTw9vSaxOt6+lttnNX1ixoP4nji?=
 =?us-ascii?Q?zb2uYQPyTlhdlT39cFZALONmjxy/4Xul2Sbh71knD4XZ5nM9a2Hw6KkSfoq3?=
 =?us-ascii?Q?fGgJPqTK5LcnqothZR/SsrrsEymV5WSVCkJDh7D/fGiKUmrup4SkuiPVK4H5?=
 =?us-ascii?Q?jEkTk7jPc5iS6k8fYkRtTtZh8niXYBOgBJMq5coBbELytTMoF5oOY6pUyLy3?=
 =?us-ascii?Q?bmScVGunXnAXaUArLcbBWqJp?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d11209d-8032-4c65-7ee1-08d942b20bc0
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2021 08:17:52.0174
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4q6I9Q7VHrRrk/dFARRWRJpzmRdh2JtayFHEaxGpWde5jiylaCAdWZ0xHlynG5iTkSf6rNZt6cSAytZA4GvYRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8201
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fugang Duan <fugang.duan@nxp.com>

The ENET of imx8mq and imx8qm are basically the same as imx6sx,
but they have new features support based on imx6sx, like:
- imx8mq: supports IEEE 802.3az EEE standard.
- imx8qm: supports RGMII mode delayed clock.

Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/ethernet/freescale/fec.h      | 13 ++++++++++
 drivers/net/ethernet/freescale/fec_main.c | 30 +++++++++++++++++++++++
 2 files changed, 43 insertions(+)

diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
index 2e002e4b4b4a..c1f93aa79d63 100644
--- a/drivers/net/ethernet/freescale/fec.h
+++ b/drivers/net/ethernet/freescale/fec.h
@@ -472,6 +472,19 @@ struct bufdesc_ex {
  */
 #define FEC_QUIRK_HAS_MULTI_QUEUES	(1 << 19)
 
+/* i.MX8MQ ENET IP version add new feature to support IEEE 802.3az EEE
+ * standard. For the transmission, MAC supply two user registers to set
+ * Sleep (TS) and Wake (TW) time.
+ */
+#define FEC_QUIRK_HAS_EEE		(1 << 20)
+
+/* i.MX8QM ENET IP version add new feture to generate delayed TXC/RXC
+ * as an alternative option to make sure it works well with various PHYs.
+ * For the implementation of delayed clock, ENET takes synchronized 250MHz
+ * clocks to generate 2ns delay.
+ */
+#define FEC_QUIRK_DELAYED_CLKS_SUPPORT	(1 << 21)
+
 struct bufdesc_prop {
 	int qid;
 	/* Address of Rx and Tx buffers */
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 8aea707a65a7..dd0b8715e84e 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -135,6 +135,26 @@ static const struct fec_devinfo fec_imx6ul_info = {
 		  FEC_QUIRK_HAS_COALESCE | FEC_QUIRK_CLEAR_SETUP_MII,
 };
 
+static const struct fec_devinfo fec_imx8mq_info = {
+	.quirks = FEC_QUIRK_ENET_MAC | FEC_QUIRK_HAS_GBIT |
+		  FEC_QUIRK_HAS_BUFDESC_EX | FEC_QUIRK_HAS_CSUM |
+		  FEC_QUIRK_HAS_VLAN | FEC_QUIRK_HAS_AVB |
+		  FEC_QUIRK_ERR007885 | FEC_QUIRK_BUG_CAPTURE |
+		  FEC_QUIRK_HAS_RACC | FEC_QUIRK_HAS_COALESCE |
+		  FEC_QUIRK_CLEAR_SETUP_MII | FEC_QUIRK_HAS_MULTI_QUEUES |
+		  FEC_QUIRK_HAS_EEE,
+};
+
+static const struct fec_devinfo fec_imx8qm_info = {
+	.quirks = FEC_QUIRK_ENET_MAC | FEC_QUIRK_HAS_GBIT |
+		  FEC_QUIRK_HAS_BUFDESC_EX | FEC_QUIRK_HAS_CSUM |
+		  FEC_QUIRK_HAS_VLAN | FEC_QUIRK_HAS_AVB |
+		  FEC_QUIRK_ERR007885 | FEC_QUIRK_BUG_CAPTURE |
+		  FEC_QUIRK_HAS_RACC | FEC_QUIRK_HAS_COALESCE |
+		  FEC_QUIRK_CLEAR_SETUP_MII | FEC_QUIRK_HAS_MULTI_QUEUES |
+		  FEC_QUIRK_DELAYED_CLKS_SUPPORT,
+};
+
 static struct platform_device_id fec_devtype[] = {
 	{
 		/* keep it for coldfire */
@@ -161,6 +181,12 @@ static struct platform_device_id fec_devtype[] = {
 	}, {
 		.name = "imx6ul-fec",
 		.driver_data = (kernel_ulong_t)&fec_imx6ul_info,
+	}, {
+		.name = "imx8mq-fec",
+		.driver_data = (kernel_ulong_t)&fec_imx8mq_info,
+	}, {
+		.name = "imx8qm-fec",
+		.driver_data = (kernel_ulong_t)&fec_imx8qm_info,
 	}, {
 		/* sentinel */
 	}
@@ -175,6 +201,8 @@ enum imx_fec_type {
 	MVF600_FEC,
 	IMX6SX_FEC,
 	IMX6UL_FEC,
+	IMX8MQ_FEC,
+	IMX8QM_FEC,
 };
 
 static const struct of_device_id fec_dt_ids[] = {
@@ -185,6 +213,8 @@ static const struct of_device_id fec_dt_ids[] = {
 	{ .compatible = "fsl,mvf600-fec", .data = &fec_devtype[MVF600_FEC], },
 	{ .compatible = "fsl,imx6sx-fec", .data = &fec_devtype[IMX6SX_FEC], },
 	{ .compatible = "fsl,imx6ul-fec", .data = &fec_devtype[IMX6UL_FEC], },
+	{ .compatible = "fsl,imx8mq-fec", .data = &fec_devtype[IMX8MQ_FEC], },
+	{ .compatible = "fsl,imx8qm-fec", .data = &fec_devtype[IMX8QM_FEC], },
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, fec_dt_ids);
-- 
2.17.1

