Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A29465B6113
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 20:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230433AbiILSff (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 14:35:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231636AbiILSeX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 14:34:23 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on0631.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe0d::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19F7346DAF
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 11:31:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ut+5ZATYC/KOPgjFE33JP6fc3R1gvUV7iYxG+dooCfrZUCedsLIBlmPQB/MzL/Gvrw0vc5ospKO0MuS/WHbnZEzZWC3B7JH05BNv8m1F9qMDMda3JnKfnsJIR+GVbV7DFWcP/4ojiivEN3aW/HkBsf61lFvV9DwaR9UD6LpRLWJHdItD84GzBGtvGx2GXF9xaG75TXlHRE/oPQJvUKL/YljUyCKm4uk9XF5gdNHDkgFruzNWJX5UHIqCC5lWXzduOaA6kSU/90VpePq7LDL/QvX7HgxTYdvLkt3378JRoUcQMiZaAWoTh+69UienTVxIv8OTgTNoQkxPWQbWZZYepQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r7FcerZ03M3uWf8y8vtt5WbnUMjd1qy8avP13WsGfU4=;
 b=Yy4v3oEkcEJpuKbDh33TDqbJcPNntfrw1HzFVrDnMwcOc3UaGzXyDyuc/FJfVKcuCXszWkVpIQovxUjpDLi6OBTN8uawxKKtCoUmKLqOKhjpdLrhUsQi2gOQXMjpJCqOqINbGA3GhaMKoCU8bnRqXagwVuKg1b7L//8pJe36F4Rcrb8lGFdBTksNEZzwtnrBJDE/MqB6Ur81rBGHD0fyek1lBeuql5zvPNL5/zfV7EPiDD1PkVsA+tohnkTLkKMuzQuHtpi7uFUbfq0uaRHhjQqNW9L+Zyccby5/1zS0uxmFeOuvXo1qjqN+QDoSl0vkHgqB3gVXjEuSiFC/Ie/deA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r7FcerZ03M3uWf8y8vtt5WbnUMjd1qy8avP13WsGfU4=;
 b=Zgqus2xYUiZaegcUldYuaG9XmLshQJTNJbeifkIDx3MzPA9gfxLx8mY3/4sRH54TanKaWYTpUQnj4QsatzBZCHkLdil01t6uukCTaPHRCez8nJTpqe6Vh7i397E7a90uY0yuo99JyHbZXr6f1+AwnzeDliQg73a518lFcD+pug0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com (2603:10a6:150:1e::22)
 by AS8PR04MB8023.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Mon, 12 Sep
 2022 18:28:56 +0000
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::d06:e64e:5f94:eb90]) by GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::d06:e64e:5f94:eb90%4]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 18:28:55 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 03/12] net: dpaa2-eth: add support for multiple buffer pools per DPNI
Date:   Mon, 12 Sep 2022 21:28:20 +0300
Message-Id: <20220912182829.160715-4-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220912182829.160715-1-ioana.ciornei@nxp.com>
References: <20220912182829.160715-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P190CA0009.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5de::16) To GV1PR04MB9055.eurprd04.prod.outlook.com
 (2603:10a6:150:1e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV1PR04MB9055:EE_|AS8PR04MB8023:EE_
X-MS-Office365-Filtering-Correlation-Id: 70d02e6e-fb69-43a0-7ada-08da94eca67d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qR1gZpx0DsJIe5mKlT8DaWNlICe3PY7g8fMjhF7WOF9rK30IOHEk5em0x3EFUm96pratT+iX0jOv12KDO92xF3BlXhIh9Du+FUmmKoz19wIlsGzMgqX2tO1bwfO8u1RjjsMyLLO4cGwf0F71gppmjYeuUqasksZQXl1uMykjaK2DjZt0oS1ytcnd/XVTdWC1ZXIbkshbH6n65bPIiO9ErsBz3UkJicuh9cIECNvjEKCP3ld/M20o2TVEJy7nAZBJSNfZeX34nWLje2i6oOBxtKEvFOGi5yfvufPc2ZnQ9XZgresCNlq9NkW/QLs0dgU8dwakjVou1PMFrQo+amFXtdErK5FtxwT84BYPJ7YBHqO1v3tJcSYNWkMRhMdPq7awulJwAWsmoA+cIQaFeCafaQ6ymPQl5x7IcPFGtmzvuPiA88C0DEU3JsUHYLtfCqwGMh+l/S1AznIJOz7iByM2lINK30p/6MObQGvaHI7IA/LzTFaJ1m5Yee6C4u2Le8eRGCu8IPHZ4jQ8VKXzL6P+L8AAlOhanepxj+58nGGmqF+ADEaCWO5q3Zsk4ENFwzaLdk1GpKmMmGxu3HU2ZEJYKe90EVwd8cjzPsHTSeD73pPBGVhtgqzXvhRuYT7YIOqpJITl+lej0jpUzR7HeN+2puTbfv9JQp6iz8BzZMx6Wt/1yQemlBC78fXRp3J6pzCR8Ij0ThtlzAx5Y5O6Lbum/06dWU+I+GwKMseUWQPExB9bLmBmUn0ePGhawz/eoOCSdffeJuLgik7DGz6N2QderQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9055.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(136003)(376002)(396003)(346002)(451199015)(4326008)(5660300002)(8936002)(30864003)(2616005)(6486002)(1076003)(2906002)(8676002)(6666004)(316002)(36756003)(41300700001)(86362001)(38350700002)(38100700002)(66476007)(44832011)(6506007)(6512007)(66556008)(186003)(66946007)(52116002)(478600001)(83380400001)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kx9B0x+HYSnivuRqxwEvleULjyixnezlVEgfu61uh0eI1RVPC5TWrLniRf8+?=
 =?us-ascii?Q?vSJaV1r0QSYe0coV2keHkQ4CDUN2dTcUF49eEHsQW9Ji4jR1Dh5Qv209hJoK?=
 =?us-ascii?Q?1OsZHkHUCilxQ6GhkHRK/eP891MNn4rvPJaH0J9PNFiy7Aitx5/td+QhY6Lz?=
 =?us-ascii?Q?RybJy55GH0rv2JFibhloSloBpMGl78Kc/pfZvoZNhMRWmDuN7K2Otw+LZaUx?=
 =?us-ascii?Q?Kk5HcYFfkUjdPZBW1lAUvDD/J5KMYvZqhOOwGpHJyDjLzrFuocvtqZ0d9tA0?=
 =?us-ascii?Q?68da1aknmlLwBBAVVJZ0tmvyVnv0Jlpqiypgtn/T/dmdvBbdwoyaIgEl5qyp?=
 =?us-ascii?Q?n0PimeKP2GcVPxiQaWoWRllXnf4xbSaNZ7i7VLvdO42+qkwqxre7g4YjAgry?=
 =?us-ascii?Q?MYXBNAK1a61XyYs1Uc/Wg8lcdZfQqTqpX7Oz8rizVPyKhnKkQf1pbpmXhFB6?=
 =?us-ascii?Q?nBD8A5KyqFB9uRfKELLtXNx+0AZT8ESWqSQv5EgclMB51qmmMCMrgrOeH4fl?=
 =?us-ascii?Q?eA+I5QFwmPGCIqIhkCZZECh9dRPnMMUkP6mwbCsVB4DVTowXW4raHbDMrPh2?=
 =?us-ascii?Q?d6O2f/CDVCpc3u7EcO+qs7JAqu1xA36PvICvbiPrIPShlge+KH/f5oi2CSsO?=
 =?us-ascii?Q?1oZd1nzW3ziGOEL3e6gSsTQ7omv1rdc0uNi7QdZsVfXibfttzoI87xLLmwd9?=
 =?us-ascii?Q?NQNirMp1soHRzhCRA66Dehv8JzLiDaFTDGirMo7tnBfLlBjh/aBuZ/3UOg4H?=
 =?us-ascii?Q?6yPtQiRMxIW7FvqJaDHAiK4bwyGA8BHxLzZX31hUGumkrF9FHdyGQgobxQvk?=
 =?us-ascii?Q?cZ8HT7E4H/X1bJYCjrofZcFeKKOPumfJ6VaT7oObavcWRrW+R+ghshQ5QUvi?=
 =?us-ascii?Q?CGzpAUWd0FDiwzE3KLEVdXkPUjQLSXW8OuGR/DmTaFxfxbCFHFDcAX4Znirb?=
 =?us-ascii?Q?P1ikT1QKwXB67B/u29QMvFmsKuqk1YCXu5LclKm9GvRgBRFCPTNtKfegXETJ?=
 =?us-ascii?Q?Rf0a3RJkjKKXA9JcJ1caY7Y/30RmKp/YIHrLYOoJqJaHqhqVp1Tm3XgQqyFS?=
 =?us-ascii?Q?Fzk5zV1TQAdT74VMMBm9wAg7Y0e7mPPcD1oxrSKuPFrup5LKGUGaQPvWeXR1?=
 =?us-ascii?Q?FXZOptvhpTugVSK34c1JJi6T0gwaaeqPYlZ6CngObPlXW/aRMlk801zhT/7o?=
 =?us-ascii?Q?8vwc5mcSLFc2eZqROFCzmVQiJ69Hmc3Zl8dvirR0Ir4FVgH5HxzllYBpiX4M?=
 =?us-ascii?Q?e0UR4qRcuh4pTRu6C+he1NY247bWSYwIBu+cc/uz3pGWlCq/NqlSzB44E+OV?=
 =?us-ascii?Q?vPkG2q6SyXLYLU65GJ26MMXodhITqQlcQf6CtjbjAj9JhmmZa6LzsBu0EVTg?=
 =?us-ascii?Q?G0lMQ8FzWgGoaTPGtP9B9EyoO0EECGSUTGjmPzKyeDTC7+hKmR8ZcCby6eGI?=
 =?us-ascii?Q?rObLxxut0m54BmxzljbEBAmdKUeP1Ogw/20CNnofJA82mogE4gZUb1/16qkN?=
 =?us-ascii?Q?Q5x+PGmr06tuyHW3m73TCMupHBAU7KtA/viYxKiBnNFvrCeJ6L73MZmM0ft3?=
 =?us-ascii?Q?beIiDBEQYaGBxu7+kPYADjc2cTGMTCtA6aHtLR0U?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70d02e6e-fb69-43a0-7ada-08da94eca67d
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9055.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2022 18:28:55.8404
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Am+MUlT+O4TZ929NdGG3ODYehBt5e7AVbU2c+/H1I4hy10xi2p1lhfhmtx4wdIkyhP8GYoUIewUkODvyKgYvGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8023
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Robert-Ionut Alexa <robert-ionut.alexa@nxp.com>

This patch allows the configuration of multiple buffer pools associated
with a single DPNI object, each distinct DPBP object not necessarily
shared among all queues.
The user can interogate both the number of buffer pools and the buffer
count in each buffer pool by using the .get_ethtool_stats() callback.

Signed-off-by: Robert-Ionut Alexa <robert-ionut.alexa@nxp.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 184 ++++++++++++------
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.h  |  23 ++-
 .../ethernet/freescale/dpaa2/dpaa2-ethtool.c  |  15 +-
 3 files changed, 155 insertions(+), 67 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 75d51572693d..83b7c14bba53 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
 /* Copyright 2014-2016 Freescale Semiconductor Inc.
- * Copyright 2016-2020 NXP
+ * Copyright 2016-2022 NXP
  */
 #include <linux/init.h>
 #include <linux/module.h>
@@ -304,7 +304,7 @@ static void dpaa2_eth_recycle_buf(struct dpaa2_eth_priv *priv,
 	if (ch->recycled_bufs_cnt < DPAA2_ETH_BUFS_PER_CMD)
 		return;
 
-	while ((err = dpaa2_io_service_release(ch->dpio, priv->bpid,
+	while ((err = dpaa2_io_service_release(ch->dpio, ch->bp->bpid,
 					       ch->recycled_bufs,
 					       ch->recycled_bufs_cnt)) == -EBUSY) {
 		if (retries++ >= DPAA2_ETH_SWP_BUSY_RETRIES)
@@ -1631,7 +1631,7 @@ static int dpaa2_eth_set_tx_csum(struct dpaa2_eth_priv *priv, bool enable)
  * to the specified buffer pool
  */
 static int dpaa2_eth_add_bufs(struct dpaa2_eth_priv *priv,
-			      struct dpaa2_eth_channel *ch, u16 bpid)
+			      struct dpaa2_eth_channel *ch)
 {
 	struct device *dev = priv->net_dev->dev.parent;
 	u64 buf_array[DPAA2_ETH_BUFS_PER_CMD];
@@ -1663,12 +1663,12 @@ static int dpaa2_eth_add_bufs(struct dpaa2_eth_priv *priv,
 		trace_dpaa2_eth_buf_seed(priv->net_dev, page_address(page),
 					 DPAA2_ETH_RX_BUF_RAW_SIZE,
 					 addr, priv->rx_buf_size,
-					 bpid);
+					 ch->bp->bpid);
 	}
 
 release_bufs:
 	/* In case the portal is busy, retry until successful */
-	while ((err = dpaa2_io_service_release(ch->dpio, bpid,
+	while ((err = dpaa2_io_service_release(ch->dpio, ch->bp->bpid,
 					       buf_array, i)) == -EBUSY) {
 		if (retries++ >= DPAA2_ETH_SWP_BUSY_RETRIES)
 			break;
@@ -1697,39 +1697,55 @@ static int dpaa2_eth_add_bufs(struct dpaa2_eth_priv *priv,
 	return 0;
 }
 
-static int dpaa2_eth_seed_pool(struct dpaa2_eth_priv *priv, u16 bpid)
+static int dpaa2_eth_seed_pool(struct dpaa2_eth_priv *priv, struct dpaa2_eth_channel *ch)
 {
-	int i, j;
+	int i;
 	int new_count;
 
-	for (j = 0; j < priv->num_channels; j++) {
-		for (i = 0; i < DPAA2_ETH_NUM_BUFS;
-		     i += DPAA2_ETH_BUFS_PER_CMD) {
-			new_count = dpaa2_eth_add_bufs(priv, priv->channel[j], bpid);
-			priv->channel[j]->buf_count += new_count;
+	for (i = 0; i < DPAA2_ETH_NUM_BUFS; i += DPAA2_ETH_BUFS_PER_CMD) {
+		new_count = dpaa2_eth_add_bufs(priv, ch);
+		ch->buf_count += new_count;
 
-			if (new_count < DPAA2_ETH_BUFS_PER_CMD) {
-				return -ENOMEM;
-			}
-		}
+		if (new_count < DPAA2_ETH_BUFS_PER_CMD)
+			return -ENOMEM;
 	}
 
 	return 0;
 }
 
+static void dpaa2_eth_seed_pools(struct dpaa2_eth_priv *priv)
+{
+	struct net_device *net_dev = priv->net_dev;
+	struct dpaa2_eth_channel *channel;
+	int i, err = 0;
+
+	for (i = 0; i < priv->num_channels; i++) {
+		channel = priv->channel[i];
+
+		err = dpaa2_eth_seed_pool(priv, channel);
+
+		/* Not much to do; the buffer pool, though not filled up,
+		 * may still contain some buffers which would enable us
+		 * to limp on.
+		 */
+		if (err)
+			netdev_err(net_dev, "Buffer seeding failed for DPBP %d (bpid=%d)\n",
+				   channel->bp->dev->obj_desc.id, channel->bp->bpid);
+	}
+}
+
 /*
- * Drain the specified number of buffers from the DPNI's private buffer pool.
+ * Drain the specified number of buffers from one of the DPNI's private buffer pools.
  * @count must not exceeed DPAA2_ETH_BUFS_PER_CMD
  */
-static void dpaa2_eth_drain_bufs(struct dpaa2_eth_priv *priv, int count)
+static void dpaa2_eth_drain_bufs(struct dpaa2_eth_priv *priv, int bpid, int count)
 {
 	u64 buf_array[DPAA2_ETH_BUFS_PER_CMD];
 	int retries = 0;
 	int ret;
 
 	do {
-		ret = dpaa2_io_service_acquire(NULL, priv->bpid,
-					       buf_array, count);
+		ret = dpaa2_io_service_acquire(NULL, bpid, buf_array, count);
 		if (ret < 0) {
 			if (ret == -EBUSY &&
 			    retries++ < DPAA2_ETH_SWP_BUSY_RETRIES)
@@ -1742,23 +1758,35 @@ static void dpaa2_eth_drain_bufs(struct dpaa2_eth_priv *priv, int count)
 	} while (ret);
 }
 
-static void dpaa2_eth_drain_pool(struct dpaa2_eth_priv *priv)
+static void dpaa2_eth_drain_pool(struct dpaa2_eth_priv *priv, int bpid)
 {
 	int i;
 
-	dpaa2_eth_drain_bufs(priv, DPAA2_ETH_BUFS_PER_CMD);
-	dpaa2_eth_drain_bufs(priv, 1);
+	/* Drain the buffer pool */
+	dpaa2_eth_drain_bufs(priv, bpid, DPAA2_ETH_BUFS_PER_CMD);
+	dpaa2_eth_drain_bufs(priv, bpid, 1);
 
+	/* Setup to zero the buffer count of all channels which were
+	 * using this buffer pool.
+	 */
 	for (i = 0; i < priv->num_channels; i++)
-		priv->channel[i]->buf_count = 0;
+		if (priv->channel[i]->bp->bpid == bpid)
+			priv->channel[i]->buf_count = 0;
+}
+
+static void dpaa2_eth_drain_pools(struct dpaa2_eth_priv *priv)
+{
+	int i;
+
+	for (i = 0; i < priv->num_bps; i++)
+		dpaa2_eth_drain_pool(priv, priv->bp[i]->bpid);
 }
 
 /* Function is called from softirq context only, so we don't need to guard
  * the access to percpu count
  */
 static int dpaa2_eth_refill_pool(struct dpaa2_eth_priv *priv,
-				 struct dpaa2_eth_channel *ch,
-				 u16 bpid)
+				 struct dpaa2_eth_channel *ch)
 {
 	int new_count;
 
@@ -1766,7 +1794,7 @@ static int dpaa2_eth_refill_pool(struct dpaa2_eth_priv *priv,
 		return 0;
 
 	do {
-		new_count = dpaa2_eth_add_bufs(priv, ch, bpid);
+		new_count = dpaa2_eth_add_bufs(priv, ch);
 		if (unlikely(!new_count)) {
 			/* Out of memory; abort for now, we'll try later on */
 			break;
@@ -1848,7 +1876,7 @@ static int dpaa2_eth_poll(struct napi_struct *napi, int budget)
 			break;
 
 		/* Refill pool if appropriate */
-		dpaa2_eth_refill_pool(priv, ch, priv->bpid);
+		dpaa2_eth_refill_pool(priv, ch);
 
 		store_cleaned = dpaa2_eth_consume_frames(ch, &fq);
 		if (store_cleaned <= 0)
@@ -2047,15 +2075,7 @@ static int dpaa2_eth_open(struct net_device *net_dev)
 	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
 	int err;
 
-	err = dpaa2_eth_seed_pool(priv, priv->bpid);
-	if (err) {
-		/* Not much to do; the buffer pool, though not filled up,
-		 * may still contain some buffers which would enable us
-		 * to limp on.
-		 */
-		netdev_err(net_dev, "Buffer seeding failed for DPBP %d (bpid=%d)\n",
-			   priv->dpbp_dev->obj_desc.id, priv->bpid);
-	}
+	dpaa2_eth_seed_pools(priv);
 
 	if (!dpaa2_eth_is_type_phy(priv)) {
 		/* We'll only start the txqs when the link is actually ready;
@@ -2088,7 +2108,7 @@ static int dpaa2_eth_open(struct net_device *net_dev)
 
 enable_err:
 	dpaa2_eth_disable_ch_napi(priv);
-	dpaa2_eth_drain_pool(priv);
+	dpaa2_eth_drain_pools(priv);
 	return err;
 }
 
@@ -2193,7 +2213,7 @@ static int dpaa2_eth_stop(struct net_device *net_dev)
 	dpaa2_eth_disable_ch_napi(priv);
 
 	/* Empty the buffer pool */
-	dpaa2_eth_drain_pool(priv);
+	dpaa2_eth_drain_pools(priv);
 
 	/* Empty the Scatter-Gather Buffer cache */
 	dpaa2_eth_sgt_cache_drain(priv);
@@ -3204,13 +3224,14 @@ static void dpaa2_eth_setup_fqs(struct dpaa2_eth_priv *priv)
 	dpaa2_eth_set_fq_affinity(priv);
 }
 
-/* Allocate and configure one buffer pool for each interface */
-static int dpaa2_eth_setup_dpbp(struct dpaa2_eth_priv *priv)
+/* Allocate and configure a buffer pool */
+struct dpaa2_eth_bp *dpaa2_eth_allocate_dpbp(struct dpaa2_eth_priv *priv)
 {
-	int err;
-	struct fsl_mc_device *dpbp_dev;
 	struct device *dev = priv->net_dev->dev.parent;
+	struct fsl_mc_device *dpbp_dev;
 	struct dpbp_attr dpbp_attrs;
+	struct dpaa2_eth_bp *bp;
+	int err;
 
 	err = fsl_mc_object_allocate(to_fsl_mc_device(dev), FSL_MC_POOL_DPBP,
 				     &dpbp_dev);
@@ -3219,12 +3240,16 @@ static int dpaa2_eth_setup_dpbp(struct dpaa2_eth_priv *priv)
 			err = -EPROBE_DEFER;
 		else
 			dev_err(dev, "DPBP device allocation failed\n");
-		return err;
+		return ERR_PTR(err);
 	}
 
-	priv->dpbp_dev = dpbp_dev;
+	bp = kzalloc(sizeof(*bp), GFP_KERNEL);
+	if (!bp) {
+		err = -ENOMEM;
+		goto err_alloc;
+	}
 
-	err = dpbp_open(priv->mc_io, 0, priv->dpbp_dev->obj_desc.id,
+	err = dpbp_open(priv->mc_io, 0, dpbp_dev->obj_desc.id,
 			&dpbp_dev->mc_handle);
 	if (err) {
 		dev_err(dev, "dpbp_open() failed\n");
@@ -3249,9 +3274,11 @@ static int dpaa2_eth_setup_dpbp(struct dpaa2_eth_priv *priv)
 		dev_err(dev, "dpbp_get_attributes() failed\n");
 		goto err_get_attr;
 	}
-	priv->bpid = dpbp_attrs.bpid;
 
-	return 0;
+	bp->dev = dpbp_dev;
+	bp->bpid = dpbp_attrs.bpid;
+
+	return bp;
 
 err_get_attr:
 	dpbp_disable(priv->mc_io, 0, dpbp_dev->mc_handle);
@@ -3259,17 +3286,57 @@ static int dpaa2_eth_setup_dpbp(struct dpaa2_eth_priv *priv)
 err_reset:
 	dpbp_close(priv->mc_io, 0, dpbp_dev->mc_handle);
 err_open:
+err_alloc:
 	fsl_mc_object_free(dpbp_dev);
 
-	return err;
+	return ERR_PTR(err);
+}
+
+static int dpaa2_eth_setup_default_dpbp(struct dpaa2_eth_priv *priv)
+{
+	struct dpaa2_eth_bp *bp;
+	int i;
+
+	bp = dpaa2_eth_allocate_dpbp(priv);
+	if (IS_ERR(bp))
+		return PTR_ERR(bp);
+
+	priv->bp[DPAA2_ETH_DEFAULT_BP_IDX] = bp;
+	priv->num_bps++;
+
+	for (i = 0; i < priv->num_channels; i++)
+		priv->channel[i]->bp = bp;
+
+	return 0;
+}
+
+static void dpaa2_eth_free_dpbp(struct dpaa2_eth_priv *priv, struct dpaa2_eth_bp *bp)
+{
+	int idx_bp;
+
+	/* Find the index at which this BP is stored */
+	for (idx_bp = 0; idx_bp < priv->num_bps; idx_bp++)
+		if (priv->bp[idx_bp] == bp)
+			break;
+
+	/* Drain the pool and disable the associated MC object */
+	dpaa2_eth_drain_pool(priv, bp->bpid);
+	dpbp_disable(priv->mc_io, 0, bp->dev->mc_handle);
+	dpbp_close(priv->mc_io, 0, bp->dev->mc_handle);
+	fsl_mc_object_free(bp->dev);
+	kfree(bp);
+
+	/* Move the last in use DPBP over in this position */
+	priv->bp[idx_bp] = priv->bp[priv->num_bps - 1];
+	priv->num_bps--;
 }
 
-static void dpaa2_eth_free_dpbp(struct dpaa2_eth_priv *priv)
+static void dpaa2_eth_free_dpbps(struct dpaa2_eth_priv *priv)
 {
-	dpaa2_eth_drain_pool(priv);
-	dpbp_disable(priv->mc_io, 0, priv->dpbp_dev->mc_handle);
-	dpbp_close(priv->mc_io, 0, priv->dpbp_dev->mc_handle);
-	fsl_mc_object_free(priv->dpbp_dev);
+	int i;
+
+	for (i = 0; i < priv->num_bps; i++)
+		dpaa2_eth_free_dpbp(priv, priv->bp[i]);
 }
 
 static int dpaa2_eth_set_buffer_layout(struct dpaa2_eth_priv *priv)
@@ -4154,6 +4221,7 @@ static int dpaa2_eth_set_default_cls(struct dpaa2_eth_priv *priv)
  */
 static int dpaa2_eth_bind_dpni(struct dpaa2_eth_priv *priv)
 {
+	struct dpaa2_eth_bp *bp = priv->bp[DPAA2_ETH_DEFAULT_BP_IDX];
 	struct net_device *net_dev = priv->net_dev;
 	struct device *dev = net_dev->dev.parent;
 	struct dpni_pools_cfg pools_params;
@@ -4162,7 +4230,7 @@ static int dpaa2_eth_bind_dpni(struct dpaa2_eth_priv *priv)
 	int i;
 
 	pools_params.num_dpbp = 1;
-	pools_params.pools[0].dpbp_id = priv->dpbp_dev->obj_desc.id;
+	pools_params.pools[0].dpbp_id = bp->dev->obj_desc.id;
 	pools_params.pools[0].backup_pool = 0;
 	pools_params.pools[0].buffer_size = priv->rx_buf_size;
 	err = dpni_set_pools(priv->mc_io, 0, priv->mc_token, &pools_params);
@@ -4642,7 +4710,7 @@ static int dpaa2_eth_probe(struct fsl_mc_device *dpni_dev)
 
 	dpaa2_eth_setup_fqs(priv);
 
-	err = dpaa2_eth_setup_dpbp(priv);
+	err = dpaa2_eth_setup_default_dpbp(priv);
 	if (err)
 		goto err_dpbp_setup;
 
@@ -4778,7 +4846,7 @@ static int dpaa2_eth_probe(struct fsl_mc_device *dpni_dev)
 err_alloc_percpu_stats:
 	dpaa2_eth_del_ch_napi(priv);
 err_bind:
-	dpaa2_eth_free_dpbp(priv);
+	dpaa2_eth_free_dpbps(priv);
 err_dpbp_setup:
 	dpaa2_eth_free_dpio(priv);
 err_dpio_setup:
@@ -4831,7 +4899,7 @@ static int dpaa2_eth_remove(struct fsl_mc_device *ls_dev)
 	free_percpu(priv->percpu_extras);
 
 	dpaa2_eth_del_ch_napi(priv);
-	dpaa2_eth_free_dpbp(priv);
+	dpaa2_eth_free_dpbps(priv);
 	dpaa2_eth_free_dpio(priv);
 	dpaa2_eth_free_dpni(priv);
 	if (priv->onestep_reg_base)
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
index 447718483ef4..daae160aa6b3 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause) */
 /* Copyright 2014-2016 Freescale Semiconductor Inc.
- * Copyright 2016-2020 NXP
+ * Copyright 2016-2022 NXP
  */
 
 #ifndef __DPAA2_ETH_H
@@ -109,6 +109,14 @@
 #define DPAA2_ETH_RX_BUF_ALIGN_REV1	256
 #define DPAA2_ETH_RX_BUF_ALIGN		64
 
+/* The firmware allows assigning multiple buffer pools to a single DPNI -
+ * maximum 8 DPBP objects. By default, only the first DPBP (idx 0) is used for
+ * all queues. Thus, when enabling AF_XDP we must accommodate up to 9 DPBPs
+ * object: the default and 8 other distinct buffer pools, one for each queue.
+ */
+#define DPAA2_ETH_DEFAULT_BP_IDX	0
+#define DPAA2_ETH_MAX_BPS		9
+
 /* We are accommodating a skb backpointer and some S/G info
  * in the frame's software annotation. The hardware
  * options are either 0 or 64, so we choose the latter.
@@ -454,6 +462,11 @@ struct dpaa2_eth_ch_xdp {
 	unsigned int res;
 };
 
+struct dpaa2_eth_bp {
+	struct fsl_mc_device *dev;
+	int bpid;
+};
+
 struct dpaa2_eth_channel {
 	struct dpaa2_io_notification_ctx nctx;
 	struct fsl_mc_device *dpcon;
@@ -472,6 +485,8 @@ struct dpaa2_eth_channel {
 	/* Buffers to be recycled back in the buffer pool */
 	u64 recycled_bufs[DPAA2_ETH_BUFS_PER_CMD];
 	int recycled_bufs_cnt;
+
+	struct dpaa2_eth_bp *bp;
 };
 
 struct dpaa2_eth_dist_fields {
@@ -535,14 +550,16 @@ struct dpaa2_eth_priv {
 	u8 ptp_correction_off;
 	void (*dpaa2_set_onestep_params_cb)(struct dpaa2_eth_priv *priv,
 					    u32 offset, u8 udp);
-	struct fsl_mc_device *dpbp_dev;
 	u16 rx_buf_size;
-	u16 bpid;
 	struct iommu_domain *iommu_domain;
 
 	enum hwtstamp_tx_types tx_tstamp_type;	/* Tx timestamping type */
 	bool rx_tstamp;				/* Rx timestamping enabled */
 
+	/* Buffer pool management */
+	struct dpaa2_eth_bp *bp[DPAA2_ETH_MAX_BPS];
+	int num_bps;
+
 	u16 tx_qdid;
 	struct fsl_mc_io *mc_io;
 	/* Cores which have an affine DPIO/DPCON.
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
index 46b493892f3b..32a38a03db57 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
@@ -241,9 +241,9 @@ static void dpaa2_eth_get_ethtool_stats(struct net_device *net_dev,
 	u32 bcnt_rx_total = 0, bcnt_tx_total = 0;
 	struct dpaa2_eth_ch_stats *ch_stats;
 	struct dpaa2_eth_drv_stats *extras;
+	u32 buf_cnt, buf_cnt_total = 0;
 	int j, k, err, num_cnt, i = 0;
 	u32 fcnt, bcnt;
-	u32 buf_cnt;
 
 	memset(data, 0,
 	       sizeof(u64) * (DPAA2_ETH_NUM_STATS + DPAA2_ETH_NUM_EXTRA_STATS));
@@ -305,12 +305,15 @@ static void dpaa2_eth_get_ethtool_stats(struct net_device *net_dev,
 	*(data + i++) = fcnt_tx_total;
 	*(data + i++) = bcnt_tx_total;
 
-	err = dpaa2_io_query_bp_count(NULL, priv->bpid, &buf_cnt);
-	if (err) {
-		netdev_warn(net_dev, "Buffer count query error %d\n", err);
-		return;
+	for (j = 0; j < priv->num_bps; j++) {
+		err = dpaa2_io_query_bp_count(NULL, priv->bp[j]->bpid, &buf_cnt);
+		if (err) {
+			netdev_warn(net_dev, "Buffer count query error %d\n", err);
+			return;
+		}
+		buf_cnt_total += buf_cnt;
 	}
-	*(data + i++) = buf_cnt;
+	*(data + i++) = buf_cnt_total;
 
 	if (dpaa2_eth_has_mac(priv))
 		dpaa2_mac_get_ethtool_stats(priv->mac, data + i);
-- 
2.33.1

