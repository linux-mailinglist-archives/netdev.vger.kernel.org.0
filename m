Return-Path: <netdev+bounces-11461-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F413D7332AA
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 15:56:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AA7672817A4
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 13:56:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F1061ACDC;
	Fri, 16 Jun 2023 13:54:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D81119930
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 13:54:13 +0000 (UTC)
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2080.outbound.protection.outlook.com [40.107.6.80])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5054A3A8F;
	Fri, 16 Jun 2023 06:54:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lpg1+Kru6o/IlPazaxJSK1xEooTFmjU37srCtYywkvrM8Xf/FgRav3bhxmPH9KEniyMEIXw+5WhlNlsRjsrxsxPYu31HjoLoNf41XySG/tQqCoXxnR7noUauZ4zSV4Scbwo4Hl1JObb4rVOpvHE4WMmRNmXlrrOVDDDZ5fvaZylHzx+BlE9QIN7auhqzMwipUxh9PiGsJN3EDiaXSUaD1DRAS9g4AqgyXOXkEOs+RgW258ouROKxPFANpIhzuKElt7FbN3ipat3EZYjWqcHtK0Di+Xg5UCtExPK96RPK0eD4lg3Z98R4DYfbC5bB+UGXz9KCSuq4ky2JAXL6WnOPdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cn4kSTJie0wzoYaMYXXL0biburs5QzNbKc/LOPHE0qk=;
 b=dA1Ph5aR7sbYVzOpR328tkdTz57Q7iHwP/xIc4zBdQXlmMXKm4ZBSpjSViYv5zhZmyMzf2IXSrAasdmKsbb9YXZBIzXR/68V1XIkhArfq8rJIAb1V4ww5h9zl8NVBM1f2YlR9r/HSnihuv+sAqiTayp18gYAe+Dn5PBOIF0Jmmikv6KVuoZXrYDpncoqs7IYx04wvzDsgWtbPN+pSOoTLaSZ380Kh6N8QamrwuEywN3Mx+ry2Fq0E1rKrDkrykDdPlLI+0XPbNCMd4612TZor96KxzmGfx5e8qR7ifrsgzh48veMEdGq66ByhOvDRqWws9CQUyi6DCv6YA664dc94Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cn4kSTJie0wzoYaMYXXL0biburs5QzNbKc/LOPHE0qk=;
 b=Vz4YhE+13gnG/jlMQKpdsrigP4KBEX0gd9i4QWPwYnfphicA5gkzhmy1BERVjQ3U+jdLxUdB6tZ250t2/uFLssfOdaivJyuH1ccBsOtdDwVNnyN9wgKEyHnDaH2NN+k8hDn+5lBnIwY4t3AxSE69y1UZ8GbWCIq93rvC+bKZXyE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com (2603:10a6:20b:409::7)
 by PA4PR04MB9318.eurprd04.prod.outlook.com (2603:10a6:102:2a5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.25; Fri, 16 Jun
 2023 13:54:02 +0000
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::5356:c79f:ef9f:dc29]) by AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::5356:c79f:ef9f:dc29%4]) with mapi id 15.20.6500.029; Fri, 16 Jun 2023
 13:54:02 +0000
From: "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
To: andrew@lunn.ch,
	hkallweit1@gmail.com,
	linux@armlinux.org.uk,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	richardcochran@gmail.com
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	sebastian.tobuschat@nxp.com,
	"Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
Subject: [PATCH net-next v1 09/14] net: phy: nxp-c45-tja11xx: read egress ts on TJA1120
Date: Fri, 16 Jun 2023 16:53:18 +0300
Message-Id: <20230616135323.98215-10-radu-nicolae.pirea@oss.nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230616135323.98215-1-radu-nicolae.pirea@oss.nxp.com>
References: <20230616135323.98215-1-radu-nicolae.pirea@oss.nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0106.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::47) To AM9PR04MB8954.eurprd04.prod.outlook.com
 (2603:10a6:20b:409::7)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR04MB8954:EE_|PA4PR04MB9318:EE_
X-MS-Office365-Filtering-Correlation-Id: 8d23f4ca-aff6-47ab-f596-08db6e712492
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	nr9L+bwT9VA08UUI7Qufz0G16pRSF+6Jjja+rAa5VXuQAigwM5XDqyhYiSIADME2weXws18yrPEcJfK+I1n8HL3oMgJGc++BJ30IUz+xkwCSYWInLmOwlKauQlcvOQVyC+AulmcIVcSNGHPc0mizFPoOXZeOfnYNKR5pWaF5WXBBQR4mm6FcZ29Jtog2R7Yb59oXSjpdWQ3tcUq0jS1rP3ulvG6ePOBwNoiNdMtXdlRBoJfU6DOkg6U+v4USTZURHALFCWlMSAL+JVEVbtIw7myYIi8lVAgfzOVPTSVbOd+pQi1Nm0c7XAf0ZNlhdGbU7Fabt5YZC2FKQC9vTzWLF4ZuHB5v/nrMQuMtjkUPnQ1BNxd0L+iz/Sc435hbBicZejMOGctycFTaR/e+IHaqOVUuKW1JP4Le6/SGxSYO533gVPe98K24+TpumKH4NPkWc2COnMWv2b4SE00nFr4THaQEhwlufgxXMvlmvDh1eBAmpdflqbuMyxbHWg4yaLVUnynpABZ6KWJvaGjoKheA9yQ4GMDv2pAdNQNU3Lmw8XTvzSJWLr4LLak2uEcAWFjBM62isG17RrZ0AjHnoM+eUgsjEa7cw0gUX6fsT/NX9rY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8954.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(366004)(346002)(136003)(376002)(451199021)(41300700001)(52116002)(86362001)(66556008)(66946007)(316002)(6486002)(8676002)(8936002)(6666004)(66476007)(4326008)(478600001)(7416002)(6512007)(5660300002)(26005)(83380400001)(6506007)(1076003)(2906002)(186003)(38350700002)(2616005)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QjZUnaFkjTVukmpwATw47l8LulwhN9kPwnBEsOf+rngXnER9bvzc5vAcP4kL?=
 =?us-ascii?Q?b+YYyt+xKMIJhYRIrWlPf119w+lPFoWutxEIilFVKTSYsSuWSG/d4LPWWfDe?=
 =?us-ascii?Q?hgxdHksQxUy7XlSqKl0LcOXP7Bamhls7qF9wWFTfEa4vroEvSqW0mdc8bMWJ?=
 =?us-ascii?Q?SqrGRXJSkVn5Kr+6bKt9doGDz/YhfziY2TwG7rPQFcyGZWwgk6NDkIuUH4ZL?=
 =?us-ascii?Q?XNi831YIFarWkMSkF10yjW87vnt9gVJKeb1C2lvN0pSzhYaK3gVhriWn5/u2?=
 =?us-ascii?Q?KYv9fJI5NAItLyYOZCk2zng4sogR/kCUJmBKO8iu90wrout5cTnQ44JYrOlZ?=
 =?us-ascii?Q?GAtF/HeXqIMQju+lCo78XW434Qb26/vyMKSMhptHik1jyh9LGxmvXCWfPG7s?=
 =?us-ascii?Q?SKDTcJugrLahNBuph8PYZSMo9oHH0B5N8QAyhBwvVhpqTnDUr6YCXFTmDoWX?=
 =?us-ascii?Q?bzHIRME5FTwWvGOczWpXq0dDjBezWEeVMl9Lm0qsm1c/8lTa+rdvyqyOvA8U?=
 =?us-ascii?Q?lkZvB5cgPo22yjcTCTXNqs901iTgo5MNy5uZgIRfwu+3ZTALhPX4R333lslh?=
 =?us-ascii?Q?jkksoCZoLamTKpoYSae9ShMiNodclq/i2JPSVcP7Ltzf3FfZZHpJTd0MxZ/H?=
 =?us-ascii?Q?VkY5VXDfhVizE+PRsBy89S4W+PhqmJP0KTgAhMOw3eFUWsExNDGeif3twUpl?=
 =?us-ascii?Q?YOWyIVIUZFs1dwZQk9/bjv4FC1uAT8OmTxcx2fSyDgnEM6vLYIcO1cDdjVN0?=
 =?us-ascii?Q?YDpoaPmz5LmjAzeK9F/dfflgG1BFJTmijOdXO377yZPOt92/JLgF2/WVwjge?=
 =?us-ascii?Q?ghL3JER5Tgg+xsaZrmNTJu43ePTDkn/1gZGpLnxGqqYDeK4In03lXHZQlvAb?=
 =?us-ascii?Q?nMjYTTKDuQfaAX6WMISYgrK95+1jyOG4pPRJfUcM4AGg8BQ0/6vhoy3ikPIZ?=
 =?us-ascii?Q?9wbmnyIWhCY830bowggq4AFIp5k3X2TXhaPsZeDtCa2bfzA4rDwuv7k469gm?=
 =?us-ascii?Q?ZmVkWrJuK4Xaj/2aG4HIwAXw63mHom9w6LfgQNotVuCiZGFdLtXQkZ0eZDRS?=
 =?us-ascii?Q?A1Wk8LPDcpq64VvmKdQcuqA9o70fQh8i3XRA1Hj5EyYM1eXzGCSkz0MLET7D?=
 =?us-ascii?Q?2sFzF4l0mPZWGu0Jh3rYLvVSrN15ebAfnmg9PdSMixWwRtxM98ObFSJTePLK?=
 =?us-ascii?Q?fQMRq4GrWlT7XLV5MLegtEgV/3txqJW/YTju+n70M3Vo9S9scHVWm5WM5UP9?=
 =?us-ascii?Q?l9u5sE+yKSTEYriDS4GQ6umCMbsfjHW8RuUqhdOrVxxYGak/Dbi4BKhnFGb4?=
 =?us-ascii?Q?+scJhk/HDWkXwTywlSf6Uqoq1hsDeye5gCDlc/bu3JNwEu0kckf+V2y6KbIW?=
 =?us-ascii?Q?cX+uWUpeE1dd7SZ/Zs/FDlJjtzD+/8zBGhYE2XvV39fCGtqLDpOcGLx3Ft0M?=
 =?us-ascii?Q?NuOcCegBw+jZHobvSgVyMw+R4NSlTBwK67he1GX4ZeEExBmy0OgvbpBfnkAq?=
 =?us-ascii?Q?la23fZeowP3AafMPtAXvQqgXAavC6kKMS3APlKnXsOwgacTIBWhNX5BGIxnO?=
 =?us-ascii?Q?ZUKtjiSAyujwLQnrvpMVYSC0fMDbB7+zzxm82bR+zq1znhM3FNHysaRD/l2y?=
 =?us-ascii?Q?yw=3D=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d23f4ca-aff6-47ab-f596-08db6e712492
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8954.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2023 13:54:02.8972
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +Z3xS2/jSa5JnXQdDg6kUGDaWFht/SdIgTYbj9P5AYbj3hSqzExoBYdm6aM8pwb6E9cP1wEO3p0gZtP2TmSpoql4QiX5UDEu3Ap6HPZdVxs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB9318
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The egress timestamp FIFO/circular buffer work different on TJA1120 than
TJA1103.

For TJA1103 the new timestamp should be manually moved from the FIFO to
the hardware buffer before checking if the timestamp is valid.

For TJA1120 the hardware will move automatically the new timestamp
from the FIFO to the buffer and the user should check the valid bit, read
the timestamp and unlock the buffer by writing any of the buffer
registers(which are read only).

Another change for the TJA1120 is the behaviour of the EGR TS IRQ bit.
This bit was a self-clear bit for TJA1103, but now should be cleared
before reading the timestamp.

Signed-off-by: Radu Pirea (NXP OSS) <radu-nicolae.pirea@oss.nxp.com>
---
 drivers/net/phy/nxp-c45-tja11xx.c | 85 ++++++++++++++++++++++++-------
 1 file changed, 67 insertions(+), 18 deletions(-)

diff --git a/drivers/net/phy/nxp-c45-tja11xx.c b/drivers/net/phy/nxp-c45-tja11xx.c
index 6aa738396daf..838bd4a638bc 100644
--- a/drivers/net/phy/nxp-c45-tja11xx.c
+++ b/drivers/net/phy/nxp-c45-tja11xx.c
@@ -29,6 +29,11 @@
 
 #define TJA1120_VEND1_EXT_TS_MODE	0x1012
 
+#define TJA1120_EGRESS_TS_DATA_S	0x9060
+#define TJA1120_EGRESS_TS_END		0x9067
+#define TJA1120_TS_VALID		BIT(0)
+#define TJA1120_MORE_TS			BIT(15)
+
 #define VEND1_PHY_IRQ_ACK		0x80A0
 #define VEND1_PHY_IRQ_EN		0x80A1
 #define VEND1_PHY_IRQ_STATUS		0x80A2
@@ -62,6 +67,9 @@
 #define VEND1_PORT_FUNC_IRQ_EN		0x807A
 #define PTP_IRQS			BIT(3)
 
+#define VEND1_PTP_IRQ_ACK		0x9008
+#define EGR_TS_IRQ			BIT(1)
+
 #define VEND1_PORT_INFRA_CONTROL	0xAC00
 #define PORT_INFRA_CONTROL_EN		BIT(14)
 
@@ -160,6 +168,8 @@
 
 #define NXP_C45_SKB_CB(skb)	((struct nxp_c45_skb_cb *)(skb)->cb)
 
+struct nxp_c45_phy;
+
 struct nxp_c45_skb_cb {
 	struct ptp_header *header;
 	unsigned int type;
@@ -245,7 +255,10 @@ struct nxp_c45_phy_data {
 	int n_stats;
 	u8 ptp_clk_period;
 	bool ext_ts_both_edges;
+	bool ack_ptp_irq;
 	void (*counters_enable)(struct phy_device *phydev);
+	bool (*get_egressts)(struct nxp_c45_phy *priv,
+			     struct nxp_c45_hwts *hwts);
 	void (*ptp_init)(struct phy_device *phydev);
 	void (*ptp_enable)(struct phy_device *phydev, bool enable);
 };
@@ -497,21 +510,11 @@ static void nxp_c45_get_extts(struct nxp_c45_phy *priv,
 		      regmap->vend1_ext_trg_ctrl, RING_DONE);
 }
 
-static bool nxp_c45_get_hwtxts(struct nxp_c45_phy *priv,
-			       struct nxp_c45_hwts *hwts)
+static void nxp_c45_read_egress_ts(struct nxp_c45_phy *priv,
+				   struct nxp_c45_hwts *hwts)
 {
 	const struct nxp_c45_regmap *regmap = nxp_c45_get_regmap(priv->phydev);
 	struct phy_device *phydev = priv->phydev;
-	bool valid;
-	u16 reg;
-
-	mutex_lock(&priv->ptp_lock);
-	phy_write_mmd(priv->phydev, MDIO_MMD_VEND1, VEND1_EGR_RING_CTRL,
-		      RING_DONE);
-	reg = phy_read_mmd(priv->phydev, MDIO_MMD_VEND1, VEND1_EGR_RING_DATA_0);
-	valid = !!(reg & RING_DATA_0_TS_VALID);
-	if (!valid)
-		goto nxp_c45_get_hwtxts_out;
 
 	hwts->domain_number =
 		nxp_c45_read_reg_field(phydev, &regmap->domain_number);
@@ -525,12 +528,49 @@ static bool nxp_c45_get_hwtxts(struct nxp_c45_phy *priv,
 		nxp_c45_read_reg_field(phydev, &regmap->nsec_29_16) << 16;
 	hwts->sec = nxp_c45_read_reg_field(phydev, &regmap->sec_1_0);
 	hwts->sec |= nxp_c45_read_reg_field(phydev, &regmap->sec_4_2) << 2;
+}
+
+static bool nxp_c45_get_hwtxts(struct nxp_c45_phy *priv,
+			       struct nxp_c45_hwts *hwts)
+{
+	bool valid;
+	u16 reg;
 
+	mutex_lock(&priv->ptp_lock);
+	phy_write_mmd(priv->phydev, MDIO_MMD_VEND1, VEND1_EGR_RING_CTRL,
+		      RING_DONE);
+	reg = phy_read_mmd(priv->phydev, MDIO_MMD_VEND1, VEND1_EGR_RING_DATA_0);
+	valid = !!(reg & RING_DATA_0_TS_VALID);
+	if (!valid)
+		goto nxp_c45_get_hwtxts_out;
+
+	nxp_c45_read_egress_ts(priv, hwts);
 nxp_c45_get_hwtxts_out:
 	mutex_unlock(&priv->ptp_lock);
 	return valid;
 }
 
+static bool tja1120_get_hwtxts(struct nxp_c45_phy *priv,
+			       struct nxp_c45_hwts *hwts)
+{
+	struct phy_device *phydev = priv->phydev;
+	bool valid;
+	u16 reg;
+
+	mutex_lock(&priv->ptp_lock);
+	reg = phy_read_mmd(phydev, MDIO_MMD_VEND1, TJA1120_EGRESS_TS_DATA_S);
+	valid = !!(reg & TJA1120_TS_VALID);
+	if (!valid)
+		goto tja1120_get_hwtxts_out;
+
+	nxp_c45_read_egress_ts(priv, hwts);
+	phy_clear_bits_mmd(phydev, MDIO_MMD_VEND1, TJA1120_EGRESS_TS_DATA_S,
+			   TJA1120_TS_VALID);
+tja1120_get_hwtxts_out:
+	mutex_unlock(&priv->ptp_lock);
+	return valid;
+}
+
 static void nxp_c45_process_txts(struct nxp_c45_phy *priv,
 				 struct nxp_c45_hwts *txts)
 {
@@ -569,6 +609,7 @@ static void nxp_c45_process_txts(struct nxp_c45_phy *priv,
 static long nxp_c45_do_aux_work(struct ptp_clock_info *ptp)
 {
 	struct nxp_c45_phy *priv = container_of(ptp, struct nxp_c45_phy, caps);
+	const struct nxp_c45_phy_data *data = nxp_c45_get_data(priv->phydev);
 	bool poll_txts = nxp_c45_poll_txts(priv->phydev);
 	struct skb_shared_hwtstamps *shhwtstamps_rx;
 	struct ptp_clock_event event;
@@ -580,7 +621,7 @@ static long nxp_c45_do_aux_work(struct ptp_clock_info *ptp)
 	u32 ts_raw;
 
 	while (!skb_queue_empty_lockless(&priv->tx_queue) && poll_txts) {
-		txts_valid = nxp_c45_get_hwtxts(priv, &hwts);
+		txts_valid = data->get_egressts(priv, &hwts);
 		if (unlikely(!txts_valid)) {
 			/* Still more skbs in the queue */
 			reschedule = true;
@@ -1127,13 +1168,17 @@ static irqreturn_t nxp_c45_handle_interrupt(struct phy_device *phydev)
 	if (!data)
 		return ret;
 
-	/* There is no need for ACK.
-	 * The irq signal will be asserted until the EGR TS FIFO will be
-	 * emptied.
-	 */
 	irq = nxp_c45_read_reg_field(phydev, &data->regmap->irq_egr_ts_status);
 	if (irq) {
-		while (nxp_c45_get_hwtxts(priv, &hwts))
+		/* If ack_ptp_irq is false, the IRQ bit is self-clear and will
+		 * be cleared when the EGR TS FIFO is empty. Otherwise, the
+		 * IRQ bit should be cleared before reading the timestamp,
+		 */
+
+		if (data->ack_ptp_irq)
+			phy_write_mmd(phydev, MDIO_MMD_VEND1,
+				      VEND1_PTP_IRQ_ACK, EGR_TS_IRQ);
+		while (data->get_egressts(priv, &hwts))
 			nxp_c45_process_txts(priv, &hwts);
 
 		ret = IRQ_HANDLED;
@@ -1598,7 +1643,9 @@ static const struct nxp_c45_phy_data tja1103_phy_data = {
 	.n_stats = ARRAY_SIZE(tja1103_hw_stats),
 	.ptp_clk_period = PTP_CLK_PERIOD_100BT1,
 	.ext_ts_both_edges = false,
+	.ack_ptp_irq = false,
 	.counters_enable = tja1103_counters_enable,
+	.get_egressts = nxp_c45_get_hwtxts,
 	.ptp_init = tja1103_ptp_init,
 	.ptp_enable = tja1103_ptp_enable,
 };
@@ -1694,7 +1741,9 @@ static const struct nxp_c45_phy_data tja1120_phy_data = {
 	.n_stats = ARRAY_SIZE(tja1120_hw_stats),
 	.ptp_clk_period = PTP_CLK_PERIOD_1000BT1,
 	.ext_ts_both_edges = true,
+	.ack_ptp_irq = true,
 	.counters_enable = tja1120_counters_enable,
+	.get_egressts = tja1120_get_hwtxts,
 	.ptp_init = tja1120_ptp_init,
 	.ptp_enable = tja1120_ptp_enable,
 };
-- 
2.34.1


