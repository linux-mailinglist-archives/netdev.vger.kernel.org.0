Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A68A85B610C
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 20:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbiILSfF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 14:35:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231434AbiILSeE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 14:34:04 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on0611.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe0d::611])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A838C4CA3B
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 11:30:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lTuOonrTy4prvGovq1dnKrpxlSq/JVAptvW2Kv1qkc9T/oLdqcy1hx3U5kz/aVMRkCUjtJnKOfUPG/tx6fkqLLFm4DymwjUq+yjvlHGd24sdH3G0CAQsG1xrXsLZnZTEvpsyv7eR9N1AiKLVtiu4AKbQQNNxcaPqizn1aOEmI0pAz7Ke5POB4m8l7+We32G8qjnNLAy/o3LX3SclTrxgQ4EuT0LO8c5ES6fAJl2jSVbW6GDtdZQ9VJ5X45H7mHkd/skHQMssHDOa4FIHwHXiUE3MfQmxunyulqCfJu98MlbGyl9kokztc2tbnEngKRYhpdKkIL69vLyolFOBYiD8bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BfXwqpRVMGphMvoJuBYchis/6FV6Rdc9fEPoQWwoHBU=;
 b=fMXvOWd08EfZFDe4C7wJxwa80GRdOZoqi2DvsZSryR0s4RoXB/uPFPZSVoLsi9VDoCjag13PqhZP+/tfkCaKYus9YWkCrDc/Vx/fdHvyfIMLUgY8MP2/Z4mPTKZFEGLL2TG4OEXzZ9rveBwuoKXtesbqRt5W1DVgHVVLe30GiKtu/lUqtueW5AtjnonErOd/wF3Nz71QfMi7YqezL+FS6gxDg4V0Z8LVMkY8fev1ETjA9lCuIeyPB8KmpiEdwvJd/qoL3MBxAXoW1nnTv87mEMCMh+cXQyJdFJyLroKEBGdYpT7yfS9xyTo+FuPvVf86cB7Zuh+jUB0YwGCFNj/H9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BfXwqpRVMGphMvoJuBYchis/6FV6Rdc9fEPoQWwoHBU=;
 b=Mhx0JQLRfKy/vE6mgqMtQZ8GFtfIHXzS/t5S3zGkN4YUZyW2CBHQjlmAziAscvPcV+1lrF3cJKM356EVRj8p8380BUr1DcYz6YostH3VnsvLjy5018OSCroJ7lCeBI4OhCNG7nNSiCjXxPFrDD1VOGw+Y5r9J0mv3mHoFRCdeao=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com (2603:10a6:150:1e::22)
 by AS8PR04MB8023.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Mon, 12 Sep
 2022 18:29:07 +0000
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::d06:e64e:5f94:eb90]) by GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::d06:e64e:5f94:eb90%4]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 18:29:07 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 09/12] net: dpaa2-eth: create and export the dpaa2_eth_receive_skb() function
Date:   Mon, 12 Sep 2022 21:28:26 +0300
Message-Id: <20220912182829.160715-10-ioana.ciornei@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: e79b570b-84dd-4d54-9973-08da94ecace8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YJFi1IUSqIJSWFWF004YFworoaiaZvaaTdJUeVv2HkgGfLzTIIEMs4UGOOgeTSRZzog6hxgdtVq8qZN3YXSi6Q7pQGQxWtTYlPmnpn+YNI143jmubLer8nE0P6Y/Y2pUsya59t2MbUWOnqhfH7J1Gqdz9Sy0goPaPFL4ZGkhrKxp7J7CQ56+04+M0osRgeeqEmBwML2OaS0ZA2tS3PNp2GkGc38+XX/N6mWx7XUwDE1ed1XTE0rD6dE9BACWdAPpetPdW2nnGKFFWhMz2WmHjXDQGhbc3Juk0VWo/Tbmdrk3iJ5jYL7/bYdwNyFyXMFQSQ7WIQnRO2DP3r3ZnBMscRDvb0v7ESTqs/Pq6j7O6rzbICbjAAxDLr6NOgdUzBIUoDQo0p78DJlRkJqo2K3msASUTVdmTIAQJfEExi/r/YuDsLdpVtld2pXNEV78+DChrXHkMwFAV9DEYKZRb8wj/KsfwZDTK7wPjyNIt8iM9Khkrkh6jBZlXBkHS0j84pm1cWV0Xc8ohM3Osj+MBh4ViRKaGB64rMNSeK7VCUvHMFLGGmIwi2Ol5XklmK9ptOKoOK1RrT6QuxQ0NUl8cy4tlzHMemJhC07kKb9SrIRNnG4/O3cVlfjhY0v0ozKNDL7R3cgyV1Bm3CpKy/N/BH2xacUppzt2Wac0eBCpChreh4SSkwEXs2UENNhLZQuyY6LOu4CRy+fBwkEAQP5hE81GmRnU8wqk9Z+jUiY3DFzv1rL+eul+Z4lLA7DLAx75+7WVSqx0+/bKMPFfkmKeFealjw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9055.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(136003)(376002)(396003)(346002)(451199015)(4326008)(5660300002)(8936002)(2616005)(6486002)(1076003)(2906002)(8676002)(6666004)(316002)(36756003)(41300700001)(86362001)(38350700002)(38100700002)(66476007)(44832011)(6506007)(6512007)(66556008)(186003)(66946007)(52116002)(478600001)(83380400001)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7mmz8UB8OkmVVtf23RzUhkCsxn7Cauyvw8OxE8dzya9g3lFylAxmPCgiuauN?=
 =?us-ascii?Q?OAeX5g0gGgAosob3it6iRO7yl8TZ0UM+ZzmAmQch5/scEikS7Oru9AMp0JhS?=
 =?us-ascii?Q?yo1LIx4UIzKSUS7Nlx9DnsslsbUF2pp0T57jVPyAATaZ98xBlWG3Ve8cmto9?=
 =?us-ascii?Q?BFgGecpdhmibdqnwwtuZXIwySfJSZktzpfEs66tw7tJuF9Um/iTySDCnulJe?=
 =?us-ascii?Q?XTKQpK60bQ0OYg3x4bw4VMkgJfZjj7+ui5kKHzTDC6R9k/RwuF0YXuAIUigg?=
 =?us-ascii?Q?N25IBqco6oOHXqxaO7l5NXp8HIm2uSow8guhtRlaDLVA+NH3eiFF1R8o/oaJ?=
 =?us-ascii?Q?MlVUft9tT5Er1708vES+P4J8krxUWf7UmUWw1ALe6xYweVR+nqBCmYVT0saN?=
 =?us-ascii?Q?jz+xa5IaXgReD/VKEekpHnYlVtCFB2caAtIBPnu8NddcX+TMzRHhvEHMErF9?=
 =?us-ascii?Q?O/61SN66gmyxr4QEwQzNY8j8evt8HinC7X/mKsMVvoQ+2yHzR8XKIWvkGIng?=
 =?us-ascii?Q?KJBZ6PLN9EDNvOBJ+vp325EZRmzwtmBhr6kUlE66T5YSFDHXOMmfQGxV+7KK?=
 =?us-ascii?Q?n1/7VOVg6+nd+phqLedyGOKz2OVU5EtEN8bt74GUgJVhBr6SURfHmc0dq36V?=
 =?us-ascii?Q?KDoufA7ykEAxZADOTtkr2CMt4acRnt5pTKNrnceN0yFkQe+etneMmOzZ/3bJ?=
 =?us-ascii?Q?0xQQb0LDbvaB0V1imPCVV/hwkDcBU9f1PWSgEdXCFlh6mrBAwXuPqWZUlsMr?=
 =?us-ascii?Q?REkBgefli7qVVe8f2Rvl78xCvB50BwAlNX0j8HY1NIa1mGxsuphXEdNfuPfV?=
 =?us-ascii?Q?k+YF8bZwkwE+X96v0wu87QWZkSdH/cX02PMXKuA9GZW+Lk8rRn9Ym/bBuTvu?=
 =?us-ascii?Q?FHnDJfFVAWEwaE8YAJ8PRVWTF+P158E7XoQqdMEaDI6IRqkwL9ROs3ReOzwx?=
 =?us-ascii?Q?o5B+LT6InRinktfsqTs/FdMlctHU1wCADa8VF0aOtpQKGmSC83j3IXEQiWst?=
 =?us-ascii?Q?CRkGdb8mjzJIaVnb3MKPsDLJQwF45nLZDFHILZBQ+Rw/cix3yowo/OcY0eLK?=
 =?us-ascii?Q?V/MWzy/mwunMxROAWXlqfCcXy4Qh5GX+jPGIQ4sk6F8u20VbwMtkHYZ494WW?=
 =?us-ascii?Q?mzCzQR2pa3kDxidUWvB128IRnhALv6tKxZ2xV3nyS4JDrSN8Jgp8zQHHjVEK?=
 =?us-ascii?Q?ECiYr11+Tvz3buaZ5I65X49dwtz9jw+/gHX+g/l2jsLsVlCuOT8l/D5xjGek?=
 =?us-ascii?Q?jkQ3FiMYiRJMHSdr9IjcslttvAVgUP5m/lunoJAbmD7Ze2neequ3T6Wc0X3h?=
 =?us-ascii?Q?4xUhPQ4OQHDq7zB3lWT6t+kvknaHQS/+3O5LJP7aZg+nTi10lpJ3twMcRqil?=
 =?us-ascii?Q?ErikgYEKo7QRU4jFZUOPJLIPnmMhcuJQEsnW8vToyC1834NrURU0rW5K9WAf?=
 =?us-ascii?Q?qYg1apSivoPT3oNj49l1cJvgVncj0tugUwxFjLoSQwfEqLsQ3Xi/IZ25VbgY?=
 =?us-ascii?Q?I2WQyzpy1PTHZWMo41hLsm94jqlep+pgY8iXsLDd3jDz7pl09lyGda588vhE?=
 =?us-ascii?Q?1zO+PrMmN8l+lpgeQo13mPOrVnNStqSWYj3euqsMHeQeN4a4G+0GKHdRbBqK?=
 =?us-ascii?Q?NA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e79b570b-84dd-4d54-9973-08da94ecace8
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9055.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2022 18:29:07.0631
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XL4JmmLeSbGJyQzpYXssq06ZmqSW2Zh47jvNPc5bgXm0gluhX2rXUvPV3BHSUYJrT7WiVFD/kby0MN3bOsA5Rw==
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

Carve out code from the dpaa2_eth_rx() function in order to create and
export the dpaa2_eth_receive_skb() function. Do this in order to reuse
this code also from the XSK path which will be introduced in a later
patch.

Signed-off-by: Robert-Ionut Alexa <robert-ionut.alexa@nxp.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 83 ++++++++++---------
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.h  | 11 +++
 2 files changed, 57 insertions(+), 37 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index a43498ac0846..651b3ad489b9 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -523,11 +523,52 @@ static struct sk_buff *dpaa2_eth_copybreak(struct dpaa2_eth_channel *ch,
 	return dpaa2_eth_alloc_skb(priv, ch, fd, fd_length, fd_vaddr);
 }
 
+void dpaa2_eth_receive_skb(struct dpaa2_eth_priv *priv, struct dpaa2_eth_channel *ch,
+			   const struct dpaa2_fd *fd, void *vaddr,
+			   struct dpaa2_eth_fq *fq,
+			   struct rtnl_link_stats64 *percpu_stats,
+			   struct sk_buff *skb)
+{
+	struct dpaa2_fas *fas;
+	u32 status = 0;
+
+	fas = dpaa2_get_fas(vaddr, false);
+	prefetch(fas);
+	prefetch(skb->data);
+
+	/* Get the timestamp value */
+	if (priv->rx_tstamp) {
+		struct skb_shared_hwtstamps *shhwtstamps = skb_hwtstamps(skb);
+		__le64 *ts = dpaa2_get_ts(vaddr, false);
+		u64 ns;
+
+		memset(shhwtstamps, 0, sizeof(*shhwtstamps));
+
+		ns = DPAA2_PTP_CLK_PERIOD_NS * le64_to_cpup(ts);
+		shhwtstamps->hwtstamp = ns_to_ktime(ns);
+	}
+
+	/* Check if we need to validate the L4 csum */
+	if (likely(dpaa2_fd_get_frc(fd) & DPAA2_FD_FRC_FASV)) {
+		status = le32_to_cpu(fas->status);
+		dpaa2_eth_validate_rx_csum(priv, status, skb);
+	}
+
+	skb->protocol = eth_type_trans(skb, priv->net_dev);
+	skb_record_rx_queue(skb, fq->flowid);
+
+	percpu_stats->rx_packets++;
+	percpu_stats->rx_bytes += dpaa2_fd_get_len(fd);
+	ch->stats.bytes_per_cdan += dpaa2_fd_get_len(fd);
+
+	list_add_tail(&skb->list, ch->rx_list);
+}
+
 /* Main Rx frame processing routine */
-static void dpaa2_eth_rx(struct dpaa2_eth_priv *priv,
-			 struct dpaa2_eth_channel *ch,
-			 const struct dpaa2_fd *fd,
-			 struct dpaa2_eth_fq *fq)
+void dpaa2_eth_rx(struct dpaa2_eth_priv *priv,
+		  struct dpaa2_eth_channel *ch,
+		  const struct dpaa2_fd *fd,
+		  struct dpaa2_eth_fq *fq)
 {
 	dma_addr_t addr = dpaa2_fd_get_addr(fd);
 	u8 fd_format = dpaa2_fd_get_format(fd);
@@ -536,9 +577,7 @@ static void dpaa2_eth_rx(struct dpaa2_eth_priv *priv,
 	struct rtnl_link_stats64 *percpu_stats;
 	struct dpaa2_eth_drv_stats *percpu_extras;
 	struct device *dev = priv->net_dev->dev.parent;
-	struct dpaa2_fas *fas;
 	void *buf_data;
-	u32 status = 0;
 	u32 xdp_act;
 
 	/* Tracing point */
@@ -548,8 +587,6 @@ static void dpaa2_eth_rx(struct dpaa2_eth_priv *priv,
 	dma_sync_single_for_cpu(dev, addr, priv->rx_buf_size,
 				DMA_BIDIRECTIONAL);
 
-	fas = dpaa2_get_fas(vaddr, false);
-	prefetch(fas);
 	buf_data = vaddr + dpaa2_fd_get_offset(fd);
 	prefetch(buf_data);
 
@@ -587,35 +624,7 @@ static void dpaa2_eth_rx(struct dpaa2_eth_priv *priv,
 	if (unlikely(!skb))
 		goto err_build_skb;
 
-	prefetch(skb->data);
-
-	/* Get the timestamp value */
-	if (priv->rx_tstamp) {
-		struct skb_shared_hwtstamps *shhwtstamps = skb_hwtstamps(skb);
-		__le64 *ts = dpaa2_get_ts(vaddr, false);
-		u64 ns;
-
-		memset(shhwtstamps, 0, sizeof(*shhwtstamps));
-
-		ns = DPAA2_PTP_CLK_PERIOD_NS * le64_to_cpup(ts);
-		shhwtstamps->hwtstamp = ns_to_ktime(ns);
-	}
-
-	/* Check if we need to validate the L4 csum */
-	if (likely(dpaa2_fd_get_frc(fd) & DPAA2_FD_FRC_FASV)) {
-		status = le32_to_cpu(fas->status);
-		dpaa2_eth_validate_rx_csum(priv, status, skb);
-	}
-
-	skb->protocol = eth_type_trans(skb, priv->net_dev);
-	skb_record_rx_queue(skb, fq->flowid);
-
-	percpu_stats->rx_packets++;
-	percpu_stats->rx_bytes += dpaa2_fd_get_len(fd);
-	ch->stats.bytes_per_cdan += dpaa2_fd_get_len(fd);
-
-	list_add_tail(&skb->list, ch->rx_list);
-
+	dpaa2_eth_receive_skb(priv, ch, fd, vaddr, fq, percpu_stats, skb);
 	return;
 
 err_build_skb:
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
index 6412fde6db4b..8966470c412f 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
@@ -793,4 +793,15 @@ struct sk_buff *dpaa2_eth_alloc_skb(struct dpaa2_eth_priv *priv,
 				    struct dpaa2_eth_channel *ch,
 				    const struct dpaa2_fd *fd, u32 fd_length,
 				    void *fd_vaddr);
+
+void dpaa2_eth_receive_skb(struct dpaa2_eth_priv *priv, struct dpaa2_eth_channel *ch,
+			   const struct dpaa2_fd *fd, void *vaddr,
+			   struct dpaa2_eth_fq *fq,
+			   struct rtnl_link_stats64 *percpu_stats,
+			   struct sk_buff *skb);
+
+void dpaa2_eth_rx(struct dpaa2_eth_priv *priv,
+		  struct dpaa2_eth_channel *ch,
+		  const struct dpaa2_fd *fd,
+		  struct dpaa2_eth_fq *fq);
 #endif	/* __DPAA2_H */
-- 
2.33.1

