Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DA9A5B611B
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 20:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230517AbiILShi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 14:37:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230523AbiILShS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 14:37:18 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on0614.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe0e::614])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70A9FE00F
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 11:34:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k1SKvh+q++UxG1fAXFH51TEqzvBdrw5chiHPGY8ZhVDA4bzcKfkOxm4pLKtWJ2AP+Zk9GIhI1wO3nAZlPp77RLdRBkgIROkRNle9e8x4ORcWgtqN58s/Jb7Y2DDzhxCwE5IU6yFL6VTQaGijP1nfOVtYnA+e7AIjpGN36TMfl4ege61AWgs3R0qR5XwLsUWe34g/FLQoSX6VfLRsq9uNjCiHo4YtWR9kgt9yhyjAlJ6p05zGzTAw9BjchdXiTjkh1w+t61/XKX/Da0g8Oxr6xwfbfWufFoCOgd9Q9sqpZzoFALMTpFvc5+k2CwRLrPugglXgjuiTUGmj1uzUY26E1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UtkwG/QzYywr7ZllWZDBd2cxuvJ2AgZ0Aby33GsQd3w=;
 b=GTXdr96ke2937b3vN47wJbxlaicz+AvdXfYvun7axq/wMRDVxrShGT1pPnzt/fqgxoVNiECpfPoHu5expW/RWW1vz6o4WtsjFzaOBjgOH4duBEILEsmXEirIDpBKMhgoCqaUk58kMVrIgqaODc8JylJ7RB7pVr8bWc1yWgP5joxaYEvK1SG6AD2fOSCWmnLSd8ASO2cIxPjsYnOKLlV+u29NhF3Ezl3lYDE1XCACl7T7AbTEMvBVcLDCau5zXq31HbXeloPv9tLhkoYMR1ssCjunrWZ/kMupcZL4jhuXPybXma+3p0Ld6GpkNpFqT00CYeR9NR9/Mi5pZD0/LqePpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UtkwG/QzYywr7ZllWZDBd2cxuvJ2AgZ0Aby33GsQd3w=;
 b=HqEnRjhyWl6fwe45JC9dBDPKMrCsVZn33a+49BecSyF/bc8lMldNUA7fiaG3URt5Zb7Mwk68NaXKziUqw/TzzVwi56Q2qmz2AlExjo34ikpslmHxvhkfMicUriObQc15G1xKwFbTkIBX5Z0SWrqHOBbwt7CF+B7N61h7mG6fSsw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com (2603:10a6:150:1e::22)
 by DU0PR04MB9494.eurprd04.prod.outlook.com (2603:10a6:10:32e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Mon, 12 Sep
 2022 18:29:11 +0000
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::d06:e64e:5f94:eb90]) by GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::d06:e64e:5f94:eb90%4]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 18:29:10 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 11/12] net: dpaa2-eth: AF_XDP TX zero copy support
Date:   Mon, 12 Sep 2022 21:28:28 +0300
Message-Id: <20220912182829.160715-12-ioana.ciornei@nxp.com>
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
X-MS-TrafficTypeDiagnostic: GV1PR04MB9055:EE_|DU0PR04MB9494:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f4db480-b566-4e0d-32b9-08da94ecaf78
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WBYUCuIVFhO9Ez39SmNDCJY5NMj/J9YKNxtP5R+deOR/oc8pemNYP6bbNlthy0SiYSMbsGbIttl4f0cYBlWkf0DOB91AK5SShiSZL6kKR/ifR/WWoM7Xgdp+FZN5YV73B8Z/v7vXiATL3Sh6hLas7uPzxxluSkltZDuobrJbVJSc7YMFyxj0M2AoTaqxmSBeF6uGDNBHxHA5Yr4B/FEhLhbkgI/Ow52W6YeYKBU9cfsSmN7dnZLwTtgAjc1nNrp4QVrCwNGEaT1HHvtTwHT+cqIodEa79rHqRVhRJwQWswzv6hxhu2met6YJw+MVH6EzcbhOWusMbq/8fgZ8KUaAmYO3JzZxl5U1vy7e4KN6n4A2Uti/iadeMcbprnAzkQs0IvznA3KUrsVLOcMqfVAlg0g5nyjD4bw/BTlX2jtFNTMoqMySufVnW6PQ6gniBL24VB7Ah2wLZzif6RnCQD85ZcXqq7kqeutybF3dAKqhztrzrjVIuuN9Whp/2AQBZfbgAp/y2K9JrWWZ5hufvpCOfFK8soWR4vnmxbY8yc2AWeTbM6jdMGWRdPSyRBvMoEH4U3ZAfjyO6YprSlc4+yhdwaEXiqWF+UZrtSTZQ/FeUQEA84asDUdiXH77ZFfSInHBLYJLQG+DiO53IjahNx5lRa1aC/qWzF294X0RQxAMFmR6RQ1uBmlKTtrhcFZsKajkOGHX0lC5yHYV3Y/GDYIkaRN4eaWd6aYrNzomBZIySaXsPDPEH4Hv4hu7IpJo2Spx7qa7RqUExaVIT6DtLeyVFQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9055.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(366004)(376002)(136003)(346002)(451199015)(8676002)(6666004)(8936002)(30864003)(38100700002)(2906002)(2616005)(186003)(66476007)(4326008)(66556008)(44832011)(26005)(36756003)(41300700001)(86362001)(6486002)(83380400001)(6512007)(66946007)(1076003)(52116002)(478600001)(5660300002)(38350700002)(6506007)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zrwPnrdVy0aJd9Zl04j9BBziWpNoB1Zn4YtFXykAyiA0YZ6XSuZ40eOABMps?=
 =?us-ascii?Q?f3TqS+6JemfL94WrVCrI9ozu6+9I8WxADDkBabe/yth7W0p37B4zY5I+4RD4?=
 =?us-ascii?Q?o/K2V+RLurJFg4Z/Pna7xBTVUM27JzIhXZ8LRpiYL7iESDSOa/seVHVn7rcS?=
 =?us-ascii?Q?j7na4UVUiX5s8d8dUmwXHwZevV3o0MsW+rr2QGm9HrMrZgSJ+Aknv5oIPrqN?=
 =?us-ascii?Q?NAGnfyPJUj21gFFP1gN3Q3OCG5L6gnGBwrEbEaG75m7uixLVYjXN4s7Iv8rY?=
 =?us-ascii?Q?i23u4wVR7QrhgYz6b9W3Y6uMve/sYnn7YPEzRqRWLCf7kgcF3ccmoOEmIlHr?=
 =?us-ascii?Q?q36cIumJkcZAOInlwgqyeyYS/udfJ2LZLS4kDxFpPUCx4jOtJgoIENu8CDHJ?=
 =?us-ascii?Q?ujYKxvNOt4UvMKAP+Y/jnjE+AZHc1xEFzNLfctjlRlsWTmLC3OHEixv7mplc?=
 =?us-ascii?Q?i+sIClaLI/6NXhZ6CYSotBoNBTF+AGWtTIoc03Ju1W4zCLytbZkZ1fc2VB2I?=
 =?us-ascii?Q?ItxWmAEmFiXgAiQ5lq7KxKHLd1XLct+Gi82+LwxR81cEbwN1ejh+AchuFA6Q?=
 =?us-ascii?Q?H55t+Hp+zj7mLg8NLVQt+Hie5O9PHRheDUSoYXPKY2ixMLh2DcUhmuE867uL?=
 =?us-ascii?Q?n0m2+00Cy35uhuLTqt08GKpqJe723hke5hzbXbMs8AbbQ34YN862liLOI0o3?=
 =?us-ascii?Q?lPJd6tqg5+EpoftNhZ4nahhTo/Xnbrxoh12Zxhm2iIKE0gag7yR7sohamV7G?=
 =?us-ascii?Q?gA0tbNzr1pChf5Q7l7LsfBLSn+nRgsAnwWCFjwx6NOcV5lbzFWcApy5AIMJr?=
 =?us-ascii?Q?XiXLOw4sfCOZpg+/avvrxX2d+psDPAaGrCXHnSOs4r2r1yL4EnoJ2loG/jfb?=
 =?us-ascii?Q?svHJWXSB2FR10NcRhS0sefm7MLATWAeXAu5EjF6kqf5kE/vWrN25zUyEUzdv?=
 =?us-ascii?Q?1KQrUXghPV+Uxv7bRNzyZxPCygbW4Mb06LrwIhj9Iv3AFNCiUzwia1SkO+NE?=
 =?us-ascii?Q?0u8M8Y8y8EOimYq83OBluxeyOPRQ7aotKEMgJpnJmFiiZrTsJQb5KLaPkEu1?=
 =?us-ascii?Q?bOGVtN1ws7hOIEoAJD06Yld+FwGQS3IwofJZ0R6/jRWxqL+UVowj2hv2rI14?=
 =?us-ascii?Q?kFCZbNlLALLteg2fjlVKeSwpMBK3RghSMgzDWXLFe+otoxsrcKZyhq5SzY5d?=
 =?us-ascii?Q?t0dRQXlQAFcqoC265H6wUYAOx7OymVJb5u4dznyfrZSzbVutxPDqvnH151YH?=
 =?us-ascii?Q?cticJGk85mv6fOZghhM+O3RE/wDZpw9/X+6BADSDf4UY1IjOrODdRG15ltiS?=
 =?us-ascii?Q?xV7pFohzYI12OALJOjEjB1wwyEZaF/IsLN20dBlLgcoUJbOqZmv0pCi7v0Dj?=
 =?us-ascii?Q?1pWNTJ4CrajPI+O6AyR4UADql7kV0GJWRXlM+VO9J5Ltc5kcfhCo7ppzg4o4?=
 =?us-ascii?Q?DVWfBgS0GlWI8sBLGTSzxS2WJKfcMhm6PLl+WUop4KeHHwrlPtU7mgR0C9sL?=
 =?us-ascii?Q?Oa61ICu/EWPMHPq/aeoqjpYuNoCCAKN+vVpkFMqNiFDujhLeDHgf6rP9twaG?=
 =?us-ascii?Q?Unn7V5hdsYlrhtjmQn36uDg8us63TzN/zk/TMoF7baFnZI2i2phbSDXFDgK0?=
 =?us-ascii?Q?lw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f4db480-b566-4e0d-32b9-08da94ecaf78
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9055.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2022 18:29:10.5147
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LuShSao5G4tZ9J5qaMLhJFrsHXEjx1968JLRre1snmfVRhhSLjmnmFlL74gYR4GWX5TB3e4hZCMLrirxeR/2jg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR04MB9494
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

Add support in dpaa2-eth for packet processing on the Tx path using
AF_XDP zero copy mode.

The newly added dpaa2_xsk_tx() function will handle enqueuing AF_XDP Tx
packets into the appropriate queue and update any necessary statistics.

On a more detailed note, the dpaa2_xsk_tx_build_fd() function handles
creating a Scatter-Gather frame descriptor with only one data buffer.
This is needed because otherwise we would need to impose a headroom in
the Tx buffer to store our software annotation structures.
This tactic is already used on the normal data path of the dpaa2-eth
driver, thus we are reusing the dpaa2_eth_sgt_get/dpaa2_eth_sgt_recycle
functions in order to allocate and recycle the Scatter-Gather table
buffers.

In case we have reached the maximum number of Tx XSK packets to be sent
in a NAPI cycle, we'll exit the dpaa2_eth_poll() and hope to be
rescheduled again.

On the XSK Tx confirmation path, we are just unmapping the SGT buffer
and recycle it for further use.

Signed-off-by: Robert-Ionut Alexa <robert-ionut.alexa@nxp.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |  48 +++++--
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.h  |  22 +++-
 .../net/ethernet/freescale/dpaa2/dpaa2-xsk.c  | 123 ++++++++++++++++++
 3 files changed, 183 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 2ce5f5605f69..ccfec7986ba1 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -857,7 +857,7 @@ static void dpaa2_eth_enable_tx_tstamp(struct dpaa2_eth_priv *priv,
 	}
 }
 
-static void *dpaa2_eth_sgt_get(struct dpaa2_eth_priv *priv)
+void *dpaa2_eth_sgt_get(struct dpaa2_eth_priv *priv)
 {
 	struct dpaa2_eth_sgt_cache *sgt_cache;
 	void *sgt_buf = NULL;
@@ -879,7 +879,7 @@ static void *dpaa2_eth_sgt_get(struct dpaa2_eth_priv *priv)
 	return sgt_buf;
 }
 
-static void dpaa2_eth_sgt_recycle(struct dpaa2_eth_priv *priv, void *sgt_buf)
+void dpaa2_eth_sgt_recycle(struct dpaa2_eth_priv *priv, void *sgt_buf)
 {
 	struct dpaa2_eth_sgt_cache *sgt_cache;
 
@@ -1114,9 +1114,10 @@ static int dpaa2_eth_build_single_fd(struct dpaa2_eth_priv *priv,
  * This can be called either from dpaa2_eth_tx_conf() or on the error path of
  * dpaa2_eth_tx().
  */
-static void dpaa2_eth_free_tx_fd(struct dpaa2_eth_priv *priv,
-				 struct dpaa2_eth_fq *fq,
-				 const struct dpaa2_fd *fd, bool in_napi)
+void dpaa2_eth_free_tx_fd(struct dpaa2_eth_priv *priv,
+			  struct dpaa2_eth_channel *ch,
+			  struct dpaa2_eth_fq *fq,
+			  const struct dpaa2_fd *fd, bool in_napi)
 {
 	struct device *dev = priv->net_dev->dev.parent;
 	dma_addr_t fd_addr, sg_addr;
@@ -1183,6 +1184,10 @@ static void dpaa2_eth_free_tx_fd(struct dpaa2_eth_priv *priv,
 
 			if (!swa->tso.is_last_fd)
 				should_free_skb = 0;
+		} else if (swa->type == DPAA2_ETH_SWA_XSK) {
+			/* Unmap the SGT Buffer */
+			dma_unmap_single(dev, fd_addr, swa->xsk.sgt_size,
+					 DMA_BIDIRECTIONAL);
 		} else {
 			skb = swa->single.skb;
 
@@ -1200,6 +1205,12 @@ static void dpaa2_eth_free_tx_fd(struct dpaa2_eth_priv *priv,
 		return;
 	}
 
+	if (swa->type == DPAA2_ETH_SWA_XSK) {
+		ch->xsk_tx_pkts_sent++;
+		dpaa2_eth_sgt_recycle(priv, buffer_start);
+		return;
+	}
+
 	if (swa->type != DPAA2_ETH_SWA_XDP && in_napi) {
 		fq->dq_frames++;
 		fq->dq_bytes += fd_len;
@@ -1374,7 +1385,7 @@ static int dpaa2_eth_build_gso_fd(struct dpaa2_eth_priv *priv,
 err_sgt_get:
 	/* Free all the other FDs that were already fully created */
 	for (i = 0; i < index; i++)
-		dpaa2_eth_free_tx_fd(priv, NULL, &fd_start[i], false);
+		dpaa2_eth_free_tx_fd(priv, NULL, NULL, &fd_start[i], false);
 
 	return err;
 }
@@ -1490,7 +1501,7 @@ static netdev_tx_t __dpaa2_eth_tx(struct sk_buff *skb,
 	if (unlikely(err < 0)) {
 		percpu_stats->tx_errors++;
 		/* Clean up everything, including freeing the skb */
-		dpaa2_eth_free_tx_fd(priv, fq, fd, false);
+		dpaa2_eth_free_tx_fd(priv, NULL, fq, fd, false);
 		netdev_tx_completed_queue(nq, 1, fd_len);
 	} else {
 		percpu_stats->tx_packets += total_enqueued;
@@ -1583,7 +1594,7 @@ static void dpaa2_eth_tx_conf(struct dpaa2_eth_priv *priv,
 
 	/* Check frame errors in the FD field */
 	fd_errors = dpaa2_fd_get_ctrl(fd) & DPAA2_FD_TX_ERR_MASK;
-	dpaa2_eth_free_tx_fd(priv, fq, fd, true);
+	dpaa2_eth_free_tx_fd(priv, ch, fq, fd, true);
 
 	if (likely(!fd_errors))
 		return;
@@ -1923,6 +1934,7 @@ static int dpaa2_eth_poll(struct napi_struct *napi, int budget)
 	struct dpaa2_eth_fq *fq, *txc_fq = NULL;
 	struct netdev_queue *nq;
 	int store_cleaned, work_done;
+	bool work_done_zc = false;
 	struct list_head rx_list;
 	int retries = 0;
 	u16 flowid;
@@ -1935,6 +1947,15 @@ static int dpaa2_eth_poll(struct napi_struct *napi, int budget)
 	INIT_LIST_HEAD(&rx_list);
 	ch->rx_list = &rx_list;
 
+	if (ch->xsk_zc) {
+		work_done_zc = dpaa2_xsk_tx(priv, ch);
+		/* If we reached the XSK Tx per NAPI threshold, we're done */
+		if (work_done_zc) {
+			work_done = budget;
+			goto out;
+		}
+	}
+
 	do {
 		err = dpaa2_eth_pull_channel(ch);
 		if (unlikely(err))
@@ -1987,6 +2008,11 @@ static int dpaa2_eth_poll(struct napi_struct *napi, int budget)
 out:
 	netif_receive_skb_list(ch->rx_list);
 
+	if (ch->xsk_tx_pkts_sent) {
+		xsk_tx_completed(ch->xsk_pool, ch->xsk_tx_pkts_sent);
+		ch->xsk_tx_pkts_sent = 0;
+	}
+
 	if (txc_fq && txc_fq->dq_frames) {
 		nq = netdev_get_tx_queue(priv->net_dev, txc_fq->flowid);
 		netdev_tx_completed_queue(nq, txc_fq->dq_frames,
@@ -2983,7 +3009,11 @@ static void dpaa2_eth_cdan_cb(struct dpaa2_io_notification_ctx *ctx)
 	/* Update NAPI statistics */
 	ch->stats.cdan++;
 
-	napi_schedule(&ch->napi);
+	/* NAPI can also be scheduled from the AF_XDP Tx path. Mark a missed
+	 * so that it can be rescheduled again.
+	 */
+	if (!napi_if_scheduled_mark_missed(&ch->napi))
+		napi_schedule(&ch->napi);
 }
 
 /* Allocate and configure a DPCON object */
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
index 4ae1adbb4ab8..88e3ed34a3cd 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
@@ -53,6 +53,12 @@
  */
 #define DPAA2_ETH_TXCONF_PER_NAPI	256
 
+/* Maximum number of Tx frames to be processed in a single NAPI
+ * call when AF_XDP is running. Bind it to DPAA2_ETH_TXCONF_PER_NAPI
+ * to maximize the throughput.
+ */
+#define DPAA2_ETH_TX_ZC_PER_NAPI	DPAA2_ETH_TXCONF_PER_NAPI
+
 /* Buffer qouta per channel. We want to keep in check number of ingress frames
  * in flight: for small sized frames, congestion group taildrop may kick in
  * first; for large sizes, Rx FQ taildrop threshold will ensure only a
@@ -154,6 +160,7 @@ struct dpaa2_eth_swa {
 		} xdp;
 		struct {
 			struct xdp_buff *xdp_buff;
+			int sgt_size;
 		} xsk;
 		struct {
 			struct sk_buff *skb;
@@ -495,6 +502,7 @@ struct dpaa2_eth_channel {
 	int recycled_bufs_cnt;
 
 	bool xsk_zc;
+	int xsk_tx_pkts_sent;
 	struct xsk_buff_pool *xsk_pool;
 	struct dpaa2_eth_bp *bp;
 };
@@ -531,7 +539,7 @@ struct dpaa2_eth_trap_data {
 
 #define DPAA2_ETH_DEFAULT_COPYBREAK	512
 
-#define DPAA2_ETH_ENQUEUE_MAX_FDS	200
+#define DPAA2_ETH_ENQUEUE_MAX_FDS	256
 struct dpaa2_eth_fds {
 	struct dpaa2_fd array[DPAA2_ETH_ENQUEUE_MAX_FDS];
 };
@@ -833,4 +841,16 @@ int dpaa2_xsk_wakeup(struct net_device *dev, u32 qid, u32 flags);
 int dpaa2_xsk_setup_pool(struct net_device *dev, struct xsk_buff_pool *pool,
 			 u16 qid);
 
+void dpaa2_eth_free_tx_fd(struct dpaa2_eth_priv *priv,
+			  struct dpaa2_eth_channel *ch,
+			  struct dpaa2_eth_fq *fq,
+			  const struct dpaa2_fd *fd, bool in_napi);
+bool dpaa2_xsk_tx(struct dpaa2_eth_priv *priv,
+		  struct dpaa2_eth_channel *ch);
+
+/* SGT (Scatter-Gather Table) cache management */
+void *dpaa2_eth_sgt_get(struct dpaa2_eth_priv *priv);
+
+void dpaa2_eth_sgt_recycle(struct dpaa2_eth_priv *priv, void *sgt_buf);
+
 #endif	/* __DPAA2_H */
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-xsk.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-xsk.c
index a0f6ea1c5c9f..0a8cbd3fa837 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-xsk.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-xsk.c
@@ -194,6 +194,7 @@ static int dpaa2_xsk_disable_pool(struct net_device *dev, u16 qid)
 
 	ch->xsk_zc = false;
 	ch->xsk_pool = NULL;
+	ch->xsk_tx_pkts_sent = 0;
 	ch->bp = priv->bp[DPAA2_ETH_DEFAULT_BP_IDX];
 
 	dpaa2_eth_setup_consume_func(priv, ch, DPAA2_RX_FQ, dpaa2_eth_rx);
@@ -323,3 +324,125 @@ int dpaa2_xsk_wakeup(struct net_device *dev, u32 qid, u32 flags)
 
 	return 0;
 }
+
+static int dpaa2_xsk_tx_build_fd(struct dpaa2_eth_priv *priv,
+				 struct dpaa2_eth_channel *ch,
+				 struct dpaa2_fd *fd,
+				 struct xdp_desc *xdp_desc)
+{
+	struct device *dev = priv->net_dev->dev.parent;
+	struct dpaa2_sg_entry *sgt;
+	struct dpaa2_eth_swa *swa;
+	void *sgt_buf = NULL;
+	dma_addr_t sgt_addr;
+	int sgt_buf_size;
+	dma_addr_t addr;
+	int err = 0;
+
+	/* Prepare the HW SGT structure */
+	sgt_buf_size = priv->tx_data_offset + sizeof(struct dpaa2_sg_entry);
+	sgt_buf = dpaa2_eth_sgt_get(priv);
+	if (unlikely(!sgt_buf))
+		return -ENOMEM;
+	sgt = (struct dpaa2_sg_entry *)(sgt_buf + priv->tx_data_offset);
+
+	/* Get the address of the XSK Tx buffer */
+	addr = xsk_buff_raw_get_dma(ch->xsk_pool, xdp_desc->addr);
+	xsk_buff_raw_dma_sync_for_device(ch->xsk_pool, addr, xdp_desc->len);
+
+	/* Fill in the HW SGT structure */
+	dpaa2_sg_set_addr(sgt, addr);
+	dpaa2_sg_set_len(sgt, xdp_desc->len);
+	dpaa2_sg_set_final(sgt, true);
+
+	/* Store the necessary info in the SGT buffer */
+	swa = (struct dpaa2_eth_swa *)sgt_buf;
+	swa->type = DPAA2_ETH_SWA_XSK;
+	swa->xsk.sgt_size = sgt_buf_size;
+
+	/* Separately map the SGT buffer */
+	sgt_addr = dma_map_single(dev, sgt_buf, sgt_buf_size, DMA_BIDIRECTIONAL);
+	if (unlikely(dma_mapping_error(dev, sgt_addr))) {
+		err = -ENOMEM;
+		goto sgt_map_failed;
+	}
+
+	/* Initialize FD fields */
+	memset(fd, 0, sizeof(struct dpaa2_fd));
+	dpaa2_fd_set_offset(fd, priv->tx_data_offset);
+	dpaa2_fd_set_format(fd, dpaa2_fd_sg);
+	dpaa2_fd_set_addr(fd, sgt_addr);
+	dpaa2_fd_set_len(fd, xdp_desc->len);
+	dpaa2_fd_set_ctrl(fd, FD_CTRL_PTA);
+
+	return 0;
+
+sgt_map_failed:
+	dpaa2_eth_sgt_recycle(priv, sgt_buf);
+
+	return err;
+}
+
+bool dpaa2_xsk_tx(struct dpaa2_eth_priv *priv,
+		  struct dpaa2_eth_channel *ch)
+{
+	struct xdp_desc *xdp_descs = ch->xsk_pool->tx_descs;
+	struct dpaa2_eth_drv_stats *percpu_extras;
+	struct rtnl_link_stats64 *percpu_stats;
+	int budget = DPAA2_ETH_TX_ZC_PER_NAPI;
+	int total_enqueued, enqueued;
+	int retries, max_retries;
+	struct dpaa2_eth_fq *fq;
+	struct dpaa2_fd *fds;
+	int batch, i, err;
+
+	percpu_stats = this_cpu_ptr(priv->percpu_stats);
+	percpu_extras = this_cpu_ptr(priv->percpu_extras);
+	fds = (this_cpu_ptr(priv->fd))->array;
+
+	/* Use the FQ with the same idx as the affine CPU */
+	fq = &priv->fq[ch->nctx.desired_cpu];
+
+	batch = xsk_tx_peek_release_desc_batch(ch->xsk_pool, budget);
+	if (!batch)
+		return false;
+
+	/* Create a FD for each XSK frame to be sent */
+	for (i = 0; i < batch; i++) {
+		err = dpaa2_xsk_tx_build_fd(priv, ch, &fds[i], &xdp_descs[i]);
+		if (err) {
+			batch = i;
+			break;
+		}
+	}
+
+	/* Enqueue all the created FDs */
+	max_retries = batch * DPAA2_ETH_ENQUEUE_RETRIES;
+	total_enqueued = 0;
+	enqueued = 0;
+	retries = 0;
+	while (total_enqueued < batch && retries < max_retries) {
+		err = priv->enqueue(priv, fq, &fds[total_enqueued], 0,
+				    batch - total_enqueued, &enqueued);
+		if (err == -EBUSY) {
+			retries++;
+			continue;
+		}
+
+		total_enqueued += enqueued;
+	}
+	percpu_extras->tx_portal_busy += retries;
+
+	/* Update statistics */
+	percpu_stats->tx_packets += total_enqueued;
+	for (i = 0; i < total_enqueued; i++)
+		percpu_stats->tx_bytes += dpaa2_fd_get_len(&fds[i]);
+	for (i = total_enqueued; i < batch; i++) {
+		dpaa2_eth_free_tx_fd(priv, ch, fq, &fds[i], false);
+		percpu_stats->tx_errors++;
+	}
+
+	xsk_tx_release(ch->xsk_pool);
+
+	return total_enqueued == budget ? true : false;
+}
-- 
2.33.1

