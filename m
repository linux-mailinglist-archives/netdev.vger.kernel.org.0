Return-Path: <netdev+bounces-9557-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B509729C18
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 16:00:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1DA981C21124
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 14:00:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24EFC17ABA;
	Fri,  9 Jun 2023 13:59:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 118B017FF4
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 13:59:41 +0000 (UTC)
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2074.outbound.protection.outlook.com [40.107.22.74])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C504C1BC6;
	Fri,  9 Jun 2023 06:59:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E/rnhzS/sn5HLjC0PtAjwsoxqSzZdzOM5q3wdvlqi+BNxtfhmQyb9CfDIF04XhhCO6DAYu7gSRLOrpNCvlIhUoDuY/LIXx0EgM/a3ZbOl427bF/vFgzsHnBjBLrWLnqtwQKNm3HXLTm+21A/jAWrN67av/4RmVT9ZHjltz04pI2oeNEAHJTath9zXZ9Bu+qoWBUec46x9fYxi9M390oEihkfsQ3fI+UohF4N1KeXiL9FVisyD0Bq8jaoHU9AGEZpKaaTOsRlc/g1VIwQjaQXLgVT7Zaz3JOmDgH2i/4rZa6QC5aMNSy/gCGAopGgCYiiczpu71z6ju73RUwckxqN2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FZ2ZDiynkmC4eyDhohgHAhmbWomw9RJ8JtAgBG25tRs=;
 b=K94+BA/UVMohuah7JG05VH8BQs5EFhytxR16ivNYrC0gJmT2N7WuVrtmXr723qEE17u84HlG8WkbTQEuU1L+kC96FRYU2YuZ3hwFHJu1hAFvtwhIY5fTsD9ivj/ySGir8wB5LhIB3jIxAQRt05tkvJQnrxOwUWaLpCLZf+FotetzY2KcAs29P1kvvAPXWrRk294D0L5moPRHamAm+h7JtBJqTIVp8cLwB1jFCmiCmc6i/2lrnkzmNxc2df2yPbbEjW2TRnE1ylmH1hrFd6q6JptgmszTREdbn/L3MRDmqumAthAUbm6H5y5Afd+RxMnToX0oj1BBkJJUg5/w6Axc0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FZ2ZDiynkmC4eyDhohgHAhmbWomw9RJ8JtAgBG25tRs=;
 b=fx33L6UEid7Q5cWJPam1HNkcYISdh0n5A7xMHL515crCsvpmJp4tekUf31fswWVeKl5U7jL7M5DXscg8B4eS9deu1Lo0p8pHkjWPMABfh7zkxaJE1q3bV04yv4I4FftXxCKgomKHusx66y49MROJG8cfyWThha/F4lWoYvHafr4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AM0PR04MB7139.eurprd04.prod.outlook.com (2603:10a6:208:19d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.41; Fri, 9 Jun
 2023 13:59:33 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::c40e:d76:fd88:f460]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::c40e:d76:fd88:f460%4]) with mapi id 15.20.6455.030; Fri, 9 Jun 2023
 13:59:32 +0000
From: Vladimir Oltean <vladimir.oltean@nxp.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Jiri Pirko <jiri@resnulli.us>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Kurt Kanzenbach <kurt@linutronix.de>,
	Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
	Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
	linux-kernel@vger.kernel.org,
	Jesse Brandeburg <jesse.brandeburg@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	intel-wired-lan@lists.osuosl.org,
	Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Subject: [PATCH net-next 2/2] net: enetc: reset taprio stats when taprio is deleted
Date: Fri,  9 Jun 2023 16:59:17 +0300
Message-Id: <20230609135917.1084327-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230609135917.1084327-1-vladimir.oltean@nxp.com>
References: <20230609135917.1084327-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0091.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a9::11) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AM0PR04MB7139:EE_
X-MS-Office365-Filtering-Correlation-Id: 40e7092f-bd0a-4bc2-5db5-08db68f1bfe0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	IHwYZo2TJESDhjbFcyfi2WWYo/m9BA5P2MDb/4fVkKqHbyEZetoIp30RssHE60YrzCyiDdDTlm52dl6PU6Fkfkaof/z7qtHAnNJt7ktW6zVD008WxFlOyqyaLn7VLsm2KyYgPbljUWIhyGZWv+qAhkIhm6h3OMGFqnVuROvMbgnsOhYPxmDKYnhTdmd+bSyXe4wpDr4/hn9d3QfTr4YRTAjRW/BpXHs8XtRGQYXTmmkk9xB8n+IuWKEU7Ymd2S2Wwtjw8gnN9ov2HUwjqgwizGdJbwMcK/W0R0PI50kc2B9lS31WadA50WSXGOGBCBozMFT2D/JbY2zpQfjnsZ+a0a4QV/5xnnhR+nB+lv7C1Hzd2rz10Z6An+8YxF0i+4pdEat09wRaRVv2U14+uSW07g73ddGlzZHRF05wFUh76zg4VWEgIY7JmjiICmzUyiB8r/HfuI5OQyYYR7ERcBZc4GQpoWXaR6ZTo/tSKfRBk+S1dPH5/77yr4BIN+IlBti30CemeGX+I3gXgi7PnhxMsr+fEGdPH5b+l/hmTRRZwKNe/TBGkU1U6nRj0h5ZdKXjImkOoKyDqDXvUBRts1qOm1OuxZBJqesXsss50zS7hPIcYeVYUQsLqUdR7nyWACJf
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(39860400002)(396003)(136003)(366004)(451199021)(66946007)(66476007)(316002)(6666004)(66556008)(54906003)(6916009)(4326008)(478600001)(86362001)(36756003)(6506007)(1076003)(26005)(6512007)(186003)(41300700001)(8936002)(8676002)(7416002)(44832011)(2906002)(5660300002)(52116002)(6486002)(2616005)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?e9JVEg/QO1Hgob/r36dyPHS4XHd+tPQjc6oDTk3pzuKOa8ROFZWLkbLjB477?=
 =?us-ascii?Q?lFtWF9dsVaR1NmYtUDynfWv6jU9SfkrKgfOXi6NC9qNxNiQKQ3eoi67mH75i?=
 =?us-ascii?Q?hITlYWoHzckxHqMD7L27BXN5ZJBejDB5Wcs17xoUPKoWGY6uCMHpoHci/m5S?=
 =?us-ascii?Q?sQG6s0gXTf3bNnNuf55w1SSd0gf25NBKrTfbfwcDLsh5pm6cf3rCvRCSVEu3?=
 =?us-ascii?Q?Bayfkp5Dqr6AQl/UxDXu8gTTBkeZLZ+LlL+jF39EPzODsAd3PCtV47JwFBBV?=
 =?us-ascii?Q?v5SB5hI14ypFcfHbCPCOuvS6Qtd0plAqIUe+vmhJKn0e1iujyxoLVLo1krHY?=
 =?us-ascii?Q?0gRClnO4LN+OjaHjqaGxxM9Fy3aYj8G6hj0s9Owy0wxhGfSRu3K7nTrEXREJ?=
 =?us-ascii?Q?5byKfHQFMYBhC74MDPsdOfTowVV4XNRK4UOJVx1HyKUeEfzgd1PTiw87Gykn?=
 =?us-ascii?Q?bIMyAIfJMB+NnCVYdCZTDZYT78SWk8eriI83/5r5yMTgWSSPkqTdrOXtohPP?=
 =?us-ascii?Q?9r/CrWgOD23ZHnWqwuBJfbAMg117SD6Cu5EOKwjhU8r4kjDazT5Vn3pZJyzb?=
 =?us-ascii?Q?BwKDXF1OIEJjHW0O70rl6OJXKltWDSbsffezCb7ylk0hGiGPd3cmzZuxi91e?=
 =?us-ascii?Q?OOySICiROpWoOQukXyXRDzqOP9k7y1zMIjYzptIODyisX8napcGehYbCuLOl?=
 =?us-ascii?Q?c16NcZbIRdorsVKDGiW3Ro/B1DFUrlFcTX/aTbV13eRMtTRWj4x/BufJ1cIv?=
 =?us-ascii?Q?Bm0u9/JMrLDqvDkDj5MZ/vaTKPI6ESpAWxMPa3LO5clGgX4oG8UlF73chFKj?=
 =?us-ascii?Q?+N+j1H9JvtKxAk+Z/p5VymMfpWZEPIotjs8EcgyjmVOAkTyl8KvCx8avIKc7?=
 =?us-ascii?Q?3WMZyUGSmv6XdwPMeKOA3ECx4Y3CpdOgCFnlTydfesVV5wNPJMSNQp/EoAHO?=
 =?us-ascii?Q?+4UJrM7PEhW6tRAnQOMBopA7urWft7cL1yLSqLExRGusLpd6NQCydIkCf21W?=
 =?us-ascii?Q?EF8sf1AQmvSkNU+z+LCNql6Bnp6PaMZzB8lG/hO9FZt/ujk3vNUiZ73/X7tg?=
 =?us-ascii?Q?Yq4u5qUcEhOWw1vxIpGy9McSCZgV/Aq1SSSz1YUke1X9Bwp5fDYpDrmQAaFd?=
 =?us-ascii?Q?VdahTC4IIQFTXrec6eMyaGybGzXEkQLIZqBK/oQRyKBi5NJLBSsqXOEc0ASo?=
 =?us-ascii?Q?KOtSlGFTVNuArO/34J90QW4xruJpPU2aVrYTFa8Bp+wz1W+dA5RI2flu57Yd?=
 =?us-ascii?Q?/scF3wYyKiPw1p4x16m0AhshROWbXSAU93r3JdQJdhhXD0rTEZcj+T+LqouA?=
 =?us-ascii?Q?u/FAiMH3nlEUMd00hKVMqUslV4eePN2w018MbMcDzZ3EtrFusEipOak3bMIp?=
 =?us-ascii?Q?qSWRg1NKgV8Zl0mJ0VgVFbECecWgnKamhLrooO9hXMcCb0Tj2fSn9UtHX29f?=
 =?us-ascii?Q?pMwSoYxL0Rloyi+3dw+yzgxjsHNZlrBYpG8VfufEq4jxwA/9GeuhBb0/+DFQ?=
 =?us-ascii?Q?wJWTH/klUpD96z1mlaMsque0wHU5OCfkMPMvhUms21hVMSowLRb5yAelEJA1?=
 =?us-ascii?Q?lqme3DlNCuzVdKsAURsDfm/wGQGRPbnP4v6RJ4BDbVZiW7BGJXr9HHuRdBJ/?=
 =?us-ascii?Q?hQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40e7092f-bd0a-4bc2-5db5-08db68f1bfe0
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2023 13:59:32.0529
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hPOofxCUfILo4iTr0+SeI4nS9cbV+CNgMW3SiO8LUssQuPlhajeLUCtpcHCqrBx8bD3sblI0irW0hZmBOp8uYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB7139
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Currently, the window_drop stats persist even if an incorrect Qdisc was
removed from the interface and a new one is installed. This is because
the enetc driver keeps the state, and that is persistent across multiple
Qdiscs.

To resolve the issue, clear all win_drop counters from all TX queues
when the currently active Qdisc is removed. These counters are zero
by default. The counters visible in ethtool -S are also affected,
but I don't care very much about preserving those enough to keep them
monotonically incrementing.

Fixes: 4802fca8d1af ("net: enetc: report statistics counters for taprio")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc_qos.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
index 58cdd67bb573..9d74104df7c8 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -127,6 +127,14 @@ static int enetc_setup_taprio(struct enetc_ndev_priv *priv,
 	return 0;
 }
 
+static void enetc_reset_taprio_stats(struct enetc_ndev_priv *priv)
+{
+	int i;
+
+	for (i = 0; i < priv->num_tx_rings; i++)
+		priv->tx_ring[i]->stats.win_drop = 0;
+}
+
 static void enetc_reset_taprio(struct enetc_ndev_priv *priv)
 {
 	struct enetc_hw *hw = &priv->si->hw;
@@ -145,6 +153,7 @@ static void enetc_taprio_destroy(struct net_device *ndev)
 
 	enetc_reset_taprio(priv);
 	enetc_reset_tc_mqprio(ndev);
+	enetc_reset_taprio_stats(priv);
 }
 
 static void enetc_taprio_stats(struct net_device *ndev,
-- 
2.34.1


