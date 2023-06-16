Return-Path: <netdev+bounces-11456-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 119DF73329E
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 15:54:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 41E1E1C20FC1
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 13:54:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAA721ACA5;
	Fri, 16 Jun 2023 13:54:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A94DA19E4D
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 13:54:01 +0000 (UTC)
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2080.outbound.protection.outlook.com [40.107.6.80])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BC1F2702;
	Fri, 16 Jun 2023 06:54:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cry2O/Rn/4XqQAjKWUpm+88qKoZAyig2D8co8Fy2EuopuI9Ar+8F6cTsL+WYRa4F+iRoteYWLdp8A7m45O8r/SmFd+sYvHaS7FWih8uuTXZBBwcQPZOarWNfP5hXx4AH+4eOrtkG4TauLeKts8DGvTjo2FWNmpyEaxYOyj9EqBg5NhgW2Lt77+6TkpZLUzTToGojqmkbmJxChy08xkb+FCOVnKbMA3Q/IOQBMYLaCJcuMG86OCjDc8YCAArQ/sCipvV58/nKPL5HifvNigufhceZCuxpkWWLCb749yv4WQOq6dVSklzW9Yw4G2AiyGBsxB1Lc9kH4/x0SZIRdZUkkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8Tu+ysxOgK5DKmxDxtrsDdRWy9k7KgmOc0eIDEV4jmw=;
 b=BLRuRbqVAn25Vi0b7jI+TGG43SsoFV8/KSrlNAemVjYkqqkl0iW5pl9z4nDhw2vcSCC2TZbHIoTfHdTQ8zgScp2H3LAR5qaexJCXpSXcjEzp8lyu677ljTZWOD5pI38kJjyT9JZd5dK3UjYD4Ge/KJKJvoAklZzdGbtKQHbp9Z+v/wbqirxacowxn5trPVGJY19xt71UW9IOpMoCCHZQv+xh7Mc+jLpHcq36utZ28WZVWvLZ9Msl29mBcn0QFDe7uh2EZUKdLsNt/3xjtXMn3i9cdTjMeOxg0AQ1c1csaapnbLsx7eRaXn0shTtz1D8PK+4DK3WKuqacYOW+KmRRLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Tu+ysxOgK5DKmxDxtrsDdRWy9k7KgmOc0eIDEV4jmw=;
 b=mZkkkrqXQigzL/+wSzsPtx+8i3BWD7XylaeY0SbPuhGcOPdqMLNf0aS5FdFxljv1rdK/kNK8hJqgTR0mDvFIG7PFONFNyhZq5TnuKcJFrmzLcfwu2WKEpmfLcnDuwIeD+VAds99wyYuHOqezPULGU40fWW0kET4pINHBekLhHAE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com (2603:10a6:20b:409::7)
 by PA4PR04MB9318.eurprd04.prod.outlook.com (2603:10a6:102:2a5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.25; Fri, 16 Jun
 2023 13:53:57 +0000
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::5356:c79f:ef9f:dc29]) by AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::5356:c79f:ef9f:dc29%4]) with mapi id 15.20.6500.029; Fri, 16 Jun 2023
 13:53:57 +0000
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
Subject: [PATCH net-next v1 03/14] net: phy: nxp-c45-tja11xx: remove RX BIST frame counters
Date: Fri, 16 Jun 2023 16:53:12 +0300
Message-Id: <20230616135323.98215-4-radu-nicolae.pirea@oss.nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: dbf4b484-2766-48aa-f553-08db6e71213f
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	sQVCnGxCo1C0kc+PrY1WT0uy3Oj6NtfEBgf/z7XTe5peay83/fVtYcUvbVzacpBdXx1CZ8ZWWqWdplGSX5xP+0gQRAg9aHjIjlYr5FuD8cEYvWpHdujwdGLQdHbDBidRZ/Rqg9rOnEqAPkq+H2gEW8iLBzTUTHMWUu6o0mVPWOU3LRi4bDDIW0wiTcx2jslNN5ZmRvwfuTX4//7lCSRg7wrrp3O1ILiOkbcciZY5WZ9nlC6V8Cu4SgGdu6N1s9RXgvloWqJJAoQsyeF5bZFqy9BSm5I7kKtbJdQF2ZQdxAoYOmWk0RODBTuxirCYyCMkAwnBk6RSbsXCX881Unh7nuHcLiRawNgmCEpxHncJ5p1RJIBOkGovByi6LRe9jtCOUOZquhFYNX8NUwP/2H3UtNfrSGA33DQvQrxJ/juV0CnOg0bRIfa6SY09IUIZyBog2XovcJkqPjpYYsGGIFHz2FKWiHxFW3AFu4OTlZMaotqZB08L6wYHblIjaC3NyZGF9XiVYZq4QyNIkHXou0i0fxq6JXj075ftYXW5gUqQXriiZv4/kAe/sPPXFr+hfCZboA0RRJnl3dVC6rsnCOs+Ye+W/x7slCnoN6aFQ2z4AMVfGHHD65CJAdm3Hsx8WZEM
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8954.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(366004)(346002)(136003)(376002)(451199021)(41300700001)(52116002)(86362001)(66556008)(66946007)(316002)(6486002)(8676002)(8936002)(6666004)(66476007)(4326008)(478600001)(7416002)(6512007)(5660300002)(26005)(83380400001)(6506007)(1076003)(2906002)(186003)(38350700002)(2616005)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XGC+v7QAIoAGDwpQ22Pf7QRbw75B8aAIl1pIUHpJouhfsy402pAOxdoarhDM?=
 =?us-ascii?Q?RANm26htUzj0vJdthwzm4HFBy1RPNpjJK204IKW5yVFWNYQSte6Wgvq2BsOD?=
 =?us-ascii?Q?zE8ccsggOKBqGjAtRfcukKcBA10QdJSIiGoRGMlrq+9gLG6NG+3a66I7Pfkz?=
 =?us-ascii?Q?2o90MTXIo4Xq/7frXbIb3afzBxJjyofN1m5kmLo8oiFVAZwyS3gsgaxsG558?=
 =?us-ascii?Q?1E3ZREdn/Uid9Fsh+tBo7UE+5oDrz11utojf7Z8LaG9A2Dh+OVU8Ujy/tNFP?=
 =?us-ascii?Q?dTjwRKxdL7kYdq5iRyGYWSJLRSY4gBMD0lgBzMoIBLVs1Je9gWJlaQGNKlOr?=
 =?us-ascii?Q?fkabOLa7e0JDAn/kbSEmqRQRlILEkyWW/s26E3THQfgmhmj8VsUsRnrPte8E?=
 =?us-ascii?Q?2rhZqAlcL7HxWvnA1ZKYqt4ZM8AfJl4VPGE5yPZvrsdWUE0jZJg4RSk0kVqQ?=
 =?us-ascii?Q?1WHELyWWa7zUAB5Hb5B7zFWZTtobkr+lFHpcmIkhwHDBJa+2nx8B7KX5+PBN?=
 =?us-ascii?Q?sHhJu6TX2vCyRm7mTs4Ud/I/ioeCP/UchMTU/8vRvjGZuHrSJm75MQ8KkmrL?=
 =?us-ascii?Q?q4FmCPsCq7rRySCyTQzkyJz7Zvpr2bpnXLv2kX0J9NwdisaoMTPp9Yrn5PnK?=
 =?us-ascii?Q?VKH4MzzXFcTjc1H96dXvGMIgcNSrxw4/syqnqQet1lnvlQDZD/FFaDU1K0/e?=
 =?us-ascii?Q?rE28+kr8lttMOqcQjCClEN8EMQF0HjJ1+rU9Rs6ralcQVLPan0G6x3T4IDHY?=
 =?us-ascii?Q?6e4tdci8i8bs0cNh4KS/46XTbJ2aAK5OECAC3DRmlV1KdCXy6zHj4LCv9sz7?=
 =?us-ascii?Q?hQk1v+fOaG2jHQQqsZXUhcXsHf1qDlIB19SiEf6qWwjXsIB67LqDlvvyDYA1?=
 =?us-ascii?Q?DK7Bnu6wswttKpXkj07rx+6cnq5kLfJg6JwurRvlTmEyC2kvvJZ5LvMHsWjD?=
 =?us-ascii?Q?Uz9uP7/UZh8VFFNCWeUW/R2SqP/BqVis3Y5/G1cGadk2dRNycBPPO7jLwaor?=
 =?us-ascii?Q?hNNW9tFK71d5P25Y+kQGFLyNBQeg4jYOYDq3DiXkMz5T5fbhXCOJwjSYOF3+?=
 =?us-ascii?Q?toln4XMmswRUum99MBHEz/uzw633y32i2oUKrD5pv5u8xXtU2nynlH/5szp7?=
 =?us-ascii?Q?Q7R30F65LpDg8lgc6baSJvlw/M9RTzPquLRHA0jZWDr3JXmHAXp7URpky4fV?=
 =?us-ascii?Q?umtPNCd/E2ExWMxH1bi2TPeL0CZpbXKg/dCY8n7lnjdiMx5s/4XCYFK3nxnY?=
 =?us-ascii?Q?lzjQEwH8Fj92dm0kj8yDdPng8P20vGP6DfGfSJijhRaCWkqUfyaYC75SdoGr?=
 =?us-ascii?Q?K5Grwussv2r20+Kuoj4kZbvaWcRn7luf4tWdwhYtg1pPKfg0hrBRtWZN2ZEU?=
 =?us-ascii?Q?VnRokc2sEbcNZKMyjnJomNSJURqpbQ2s7Pj/n0ZRDFWIAgmkMNKRm6QWca70?=
 =?us-ascii?Q?f/e63hpR1I3VSsZkteUKAPp07q+lJMAyqL9lGH053JupIevLL89ryrlzBdc0?=
 =?us-ascii?Q?0TJI7WOV0X6GCN1zywfxsn4NcwPVYFy8EMkT5x4TDsE8cA/9yHwDfujHpMG5?=
 =?us-ascii?Q?ibA/dzmVPljA2loKO1x/5uR/KuhAOniEzt5pwNTDT04egldKAtGZtsJZXWuJ?=
 =?us-ascii?Q?Fw=3D=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbf4b484-2766-48aa-f553-08db6e71213f
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8954.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2023 13:53:57.3055
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n536BRJnRLqn1enK6Z6Htic5DA346bf2gv6m6l1BPrn0b01u/l7xujUD+pj11oF+FOvbapb7P9mNIxw4UN5V5kd/JMH7dqDnNAmTajglhYE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB9318
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

RX BIST frame counters can be used only when the PHY is in test mode. In
production mode, the counters will be always read as 0. So, they don't
provide any useful information and are removed from the statistics.

Signed-off-by: Radu Pirea (NXP OSS) <radu-nicolae.pirea@oss.nxp.com>
---
 drivers/net/phy/nxp-c45-tja11xx.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/net/phy/nxp-c45-tja11xx.c b/drivers/net/phy/nxp-c45-tja11xx.c
index 78a30007edf8..e39f0b46e934 100644
--- a/drivers/net/phy/nxp-c45-tja11xx.c
+++ b/drivers/net/phy/nxp-c45-tja11xx.c
@@ -84,9 +84,6 @@
 #define VEND1_SYMBOL_ERROR_COUNTER	0x8350
 #define VEND1_LINK_DROP_COUNTER		0x8352
 #define VEND1_LINK_LOSSES_AND_FAILURES	0x8353
-#define VEND1_R_GOOD_FRAME_CNT		0xA950
-#define VEND1_R_BAD_FRAME_CNT		0xA952
-#define VEND1_R_RXER_FRAME_CNT		0xA954
 #define VEND1_RX_PREAMBLE_COUNT		0xAFCE
 #define VEND1_TX_PREAMBLE_COUNT		0xAFCF
 #define VEND1_RX_IPG_LENGTH		0xAFD0
@@ -812,12 +809,6 @@ static const struct nxp_c45_phy_stats nxp_c45_hw_stats[] = {
 		VEND1_LINK_LOSSES_AND_FAILURES, 10, GENMASK(15, 10) },
 	{ "phy_link_failure_cnt", MDIO_MMD_VEND1,
 		VEND1_LINK_LOSSES_AND_FAILURES, 0, GENMASK(9, 0) },
-	{ "r_good_frame_cnt", MDIO_MMD_VEND1,
-		VEND1_R_GOOD_FRAME_CNT, 0, GENMASK(15, 0) },
-	{ "r_bad_frame_cnt", MDIO_MMD_VEND1,
-		VEND1_R_BAD_FRAME_CNT, 0, GENMASK(15, 0) },
-	{ "r_rxer_frame_cnt", MDIO_MMD_VEND1,
-		VEND1_R_RXER_FRAME_CNT, 0, GENMASK(15, 0) },
 	{ "rx_preamble_count", MDIO_MMD_VEND1,
 		VEND1_RX_PREAMBLE_COUNT, 0, GENMASK(5, 0) },
 	{ "tx_preamble_count", MDIO_MMD_VEND1,
-- 
2.34.1


