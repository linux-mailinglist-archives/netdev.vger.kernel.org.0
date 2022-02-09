Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADB2E4AEDF3
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 10:25:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbiBIJZa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 04:25:30 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:45706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbiBIJZ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 04:25:29 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on0600.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe0d::600])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 636B4E0AFABD
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 01:25:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SwHllJi8HdwDZ9hbu5s/ne3NjE0rVVaxd2b+Ei8dI7xlt21o79xQH1xrU+jKtcE3/7GMGoVDUdynOO5P7QJdZ/JP0XTQSG6lJE4YUGpvIl4DBsKOd5uPOMU+4lZUxRLbTGtne5K14RCgo6zo1TObzxhMVBBdlCMJ09UQVeGifVVYwqi4lNMce3csR9Pp16tcVZewAQt8ELlU8ace+I6Jv/pJZ9aae2/9mKI9hp9Czxsy77O4hUJ+UUa9hMMtaJAxM6CkInJ9IsQuWMGwIDlDWuqCPnpgv2imcPVmr73p+FE+TGuXR76i8qn9S19AYYKKDpm8agybnjiuJ6aJETvu3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0rleTzK79zSdJeNqyEEI49q+ziPUwcTWDGz6+83FDSs=;
 b=XYhXMUk0LOuYlzaoLH7GFujT/r25jg/RYVs+PHZAKAbc+mD1G8HVxdSjHN70DGKdjBheWRVKF4IymYBQstPvApBhgqpnDUc8y+2mZJj0Qweswg2ltTtNaAlLbyHD8zs63yRQEP2xf22sM1oeepmdgrRR60cX/wE8vUJeabGNTiJQESmXsyE8zH06NKGcjxO4l9ANYNFLYBtKGNiIe6orlatfH9vyzpqWf4gRZb3JsD6T+Rcd8hflpyHjzDPX3z/BPnIWHIjrVsnmHLSV89yIx3t5JihSTy81F3TMb2q3bBG9JgmSlo/KT6f/InJ4yqjA31EyErnaN+Kgu6HoMjxYGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0rleTzK79zSdJeNqyEEI49q+ziPUwcTWDGz6+83FDSs=;
 b=EWL/9/yShn/gE7dpfBbnXP0ccTG/2AI2nVbWtns1DpICK/VPerX4de3CGJ+UNm76C7AzX7J57X9bmsH5ZSji0hYZPvDU6BixtV5fUksfRA74up5mq4lnCl0xjmqfhpbrK25zoGfZjmHx2+o1kBJBJAFLCPT20Tx3UnMps9WvyJU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com (2603:10a6:20b:436::16)
 by VI1PR04MB5423.eurprd04.prod.outlook.com (2603:10a6:803:da::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.18; Wed, 9 Feb
 2022 09:24:04 +0000
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::5df9:5bf0:7ac1:a793]) by AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::5df9:5bf0:7ac1:a793%9]) with mapi id 15.20.4975.011; Wed, 9 Feb 2022
 09:24:04 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     youri.querry_1@nxp.com, leoyang.li@nxp.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 5/7] dpaa2-eth: work with an array of FDs
Date:   Wed,  9 Feb 2022 11:23:33 +0200
Message-Id: <20220209092335.3064731-6-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220209092335.3064731-1-ioana.ciornei@nxp.com>
References: <20220209092335.3064731-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR03CA0037.eurprd03.prod.outlook.com (2603:10a6:208::14)
 To AM9PR04MB8555.eurprd04.prod.outlook.com (2603:10a6:20b:436::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 740172a9-91c2-4ef3-fa12-08d9ebadea12
X-MS-TrafficTypeDiagnostic: VI1PR04MB5423:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB542329B7C3CF0397E1AF8E56E02E9@VI1PR04MB5423.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R3D0fEbeo8aBrtqzTxmctw4GIjDogQ1m3bRlWXSJTFHAXQOk54Z6KPF7uVpY1s9WDXJDa0KK/AES39Q/kiIexvXcRFxr04kxDKQcmNYZ6FbVDEgvMnW9sxUKiHfjeXAeDJEfxexPl53eZys4U5nxhfFx8+/fkOPc1CJB7Nv8DyoRP/GYbVdqBeP06Nb0Xzj6pUutVvqx4MnH4HMKQ/VPW6OTL4+EG91t62aBaDfZJzUVpN6sOP/LtythjL93ioTwhGZ8XEczbt81CPLjQips9g5uYa30ASgNGKe5P0YwMopBCWECxOkcSACkGgTk74VE/XJ756l9gtmHXJOsdcAf1eR7C4whRHnvOwhbmDOf4VWFSGxVDAOIiV6TeYyQd2LReP7+W/7bngrXmNwYTir410c9AU8j+GG8eYvuFvMo0cTXSMJhWGrAeX5ipdYv+NMyjQw+5LWuOtZv2lfddbVUKQx0VAC96RqT8BTxWZnxXdX10+RobPrpcM81Df6pLBznOWx5Z3w1wbIhxZv/0R4TsntAtIb5FJ5ZclmfUJwAYhVgNuJk2v6LrvLojUsA6XUAVkyyxUCoGjMLydh/a2cDB6Yov5lIcUyO4PKIXYlQALgch4AcMFLGO4cSmlcBgmo56kzo9VAny7aBRL6Dmn4w/5P/dI0Dlp4oRjS/U9pXWnER8iZSo8zgan1dSF5gGC6coL0ALCgiA7mGzirpKkJe5w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8555.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2616005)(83380400001)(66556008)(66476007)(8936002)(4326008)(8676002)(2906002)(1076003)(26005)(36756003)(6486002)(5660300002)(44832011)(52116002)(66946007)(86362001)(38350700002)(508600001)(38100700002)(186003)(316002)(6506007)(6666004)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hticUJiWm2Cpaj6gWYOPX87ZPkGgHW1BaNHL/3qGMl1Mwouqu350BuDAPVAt?=
 =?us-ascii?Q?yQX76XxBeFC4sTxkh+wV31TXKCAxip5zY+MMk/lmbaj+3s4Y7atnvcW4Pub/?=
 =?us-ascii?Q?rqMQD/S/egBrhcYTQS0CmBpaH1+3TJpKccOCvjYG2aKBwZBzqb8KRQzlMxU7?=
 =?us-ascii?Q?p1rWn3q1sq/TOoYyBkqUL4ij0ckl9XQXLdfdTwAFaleqsxon6khHnN2mSwxf?=
 =?us-ascii?Q?ZnT77IFBnbU4CKwouQTgNVuQlN0eXP/yif7qhNhyDilIhIGFau1uA5i00ce8?=
 =?us-ascii?Q?PPlU3gCfK00LfiVOe2e1vwm5qMAulBad62T15zOgZFGx/Cnc1hnvfS5fONvM?=
 =?us-ascii?Q?7J5hZw+PXNzvYUR9tP8Z78a46BabBFo/u0Z0WKEN5noQ+JTHAgqd+vaW4MB3?=
 =?us-ascii?Q?ukhil7JfoVJ3neTDIiB7mXx6EFIXztSzienI79msCOG7xVd9dl5sq5zd3b2U?=
 =?us-ascii?Q?ulk7Os1oJgFz0wNODCwBLscms08zJgWhpxmR0bgI4SMhIRdPwgffob7rXsSH?=
 =?us-ascii?Q?iYtBHem5KVqCFP9BSA9kI7bY2u1nOncoBPgonr04oTUOujThxZloooVMzc0L?=
 =?us-ascii?Q?UHUGtRoIUs/RVcg6pT0Agir+KnTPJ5Zyqz4vEN/a58fN4HA5FtvB4RrAG7o0?=
 =?us-ascii?Q?G5jlK1cunn+Ja/NcCyL0FZSQHBCYvqz3cy63k8BWjTZL3HDZA5QHsOMv8Qx2?=
 =?us-ascii?Q?LLthBmJWwU4Gc6QX43r2No9i4u0EIB4JiCc3J6OzKwyhpHzz1SndnX1RhqqE?=
 =?us-ascii?Q?OipamkTAuaF0FMBeMqnRpeqg2AFttAfjPl3WtoHvnBXuPXIQOImDw3f1St/v?=
 =?us-ascii?Q?S8WBM1YNhAFdKpbfKOR950dTBTNFu+kwr+A7S+UDvHB5//5b5B2on87cnZP/?=
 =?us-ascii?Q?FbHUaQlP5x6vH53TOg81H099f8UbpFC8ZuJkpT8kOLES3MJdCmGfRza2vTkJ?=
 =?us-ascii?Q?W6NAptiLSXO407qJp264Qd1F2JtlEmuEZmluFOQQvAbH0GJqWd89SSfIrhgR?=
 =?us-ascii?Q?/C4lQ4BMOws1TDelbCH4CTqBm+7urrHdtqBUtz1bIX6ttsxXHpVMnz9jWDE2?=
 =?us-ascii?Q?JzFwV4TI7eO1GuN4AlKEaZpZC3uCVK8BukQwZdOiaE22o51BYhTTEW4zDqoJ?=
 =?us-ascii?Q?b3uduEj8wqAuJ5wjfbfkOxvn+0TmbIsqypYZWuhaCKC3zVBVX7cnRYyH7M0c?=
 =?us-ascii?Q?OnRI/t9d1FGQcOdY+u1VzK4bCDk+FfabeBmJxrrHFMTbSfT9hYtUOJkpyeev?=
 =?us-ascii?Q?AnOz1S5QpkvqD5EORg3zaU866PZTG4z2Su2HzkF0J/Ay/TOcNf21oYEae2Wx?=
 =?us-ascii?Q?tkiU+a03SbGdAVxfs5vRg+iCIUqSAyXj5xgokFCcXdhxdwLZwzwUQEK8vTUc?=
 =?us-ascii?Q?ZYRYpDXUg2aGFSP/OGBVQEE+mNsjy3FrOeE6GJXVO3G0I5vEZOipsm30JZnY?=
 =?us-ascii?Q?1FfG5Qpz3Ecbc7m1bYr9xZBDFghG9Vp/uA3iE+yzz86YS+0TZsbuCB+uBnFQ?=
 =?us-ascii?Q?4F8vhpZ7YqeR9Am3zkKDUNdFuL8ZrYbvh7MrGBfUD2DzYCY2SQWkJy3v5xk7?=
 =?us-ascii?Q?fTPrbnJO4eFDcXTzWVDdagXG+aK4d5VSoV/6UxLABCfAJdl6/uiJly12hKUN?=
 =?us-ascii?Q?arUSvyvdWuyc2CktxTWto9U=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 740172a9-91c2-4ef3-fa12-08d9ebadea12
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2022 09:24:04.0179
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: noqKporooznJhF9oKLQ/CvPf5f4GqsyhvPVDpQnODM4b+sHQLVETM8pdV5vfZ9UIJu7CqvSp8K/BIyjZ2FmpTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5423
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Up until now, the __dpaa2_eth_tx function used a single FD on the stack
to construct the structure to be enqueued. Since we are now preparing
the ground work to add support for TSO done in software at the driver
level, the same function needs to work with an array of FDs and enqueue
as many as the build_*_fd functions create.

Make the necessary adjustments in order to do this. These include:
keeping an array of FDs in a percpu structure, cleaning up the necessary
FDs before populating it and then, retrying the enqueue process up till
all the generated FDs were enqueued or until we reach the maximum number
retries.

This patch does not change the fact that only a single FD will result
from a __dpaa2_eth_tx call but rather just creates the necessary changes
for the next patch.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 56 +++++++++++++------
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.h  |  7 +++
 2 files changed, 47 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 73e242fad000..d9871b9c1aad 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -878,6 +878,7 @@ static int dpaa2_eth_build_sg_fd(struct dpaa2_eth_priv *priv,
 		err = -ENOMEM;
 		goto dma_map_single_failed;
 	}
+	memset(fd, 0, sizeof(struct dpaa2_fd));
 	dpaa2_fd_set_offset(fd, priv->tx_data_offset);
 	dpaa2_fd_set_format(fd, dpaa2_fd_sg);
 	dpaa2_fd_set_addr(fd, addr);
@@ -946,6 +947,7 @@ static int dpaa2_eth_build_sg_fd_single_buf(struct dpaa2_eth_priv *priv,
 		goto sgt_map_failed;
 	}
 
+	memset(fd, 0, sizeof(struct dpaa2_fd));
 	dpaa2_fd_set_offset(fd, priv->tx_data_offset);
 	dpaa2_fd_set_format(fd, dpaa2_fd_sg);
 	dpaa2_fd_set_addr(fd, sgt_addr);
@@ -998,6 +1000,7 @@ static int dpaa2_eth_build_single_fd(struct dpaa2_eth_priv *priv,
 	if (unlikely(dma_mapping_error(dev, addr)))
 		return -ENOMEM;
 
+	memset(fd, 0, sizeof(struct dpaa2_fd));
 	dpaa2_fd_set_addr(fd, addr);
 	dpaa2_fd_set_offset(fd, (u16)(skb->data - buffer_start));
 	dpaa2_fd_set_len(fd, skb->len);
@@ -1111,12 +1114,14 @@ static netdev_tx_t __dpaa2_eth_tx(struct sk_buff *skb,
 				  struct net_device *net_dev)
 {
 	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
+	int total_enqueued = 0, retries = 0, enqueued;
 	struct dpaa2_eth_drv_stats *percpu_extras;
 	struct rtnl_link_stats64 *percpu_stats;
 	unsigned int needed_headroom;
+	int num_fds = 1, max_retries;
 	struct dpaa2_eth_fq *fq;
 	struct netdev_queue *nq;
-	struct dpaa2_fd fd;
+	struct dpaa2_fd *fd;
 	u16 queue_mapping;
 	u8 prio = 0;
 	int err, i;
@@ -1125,6 +1130,7 @@ static netdev_tx_t __dpaa2_eth_tx(struct sk_buff *skb,
 
 	percpu_stats = this_cpu_ptr(priv->percpu_stats);
 	percpu_extras = this_cpu_ptr(priv->percpu_extras);
+	fd = (this_cpu_ptr(priv->fd))->array;
 
 	needed_headroom = dpaa2_eth_needed_headroom(skb);
 
@@ -1139,20 +1145,22 @@ static netdev_tx_t __dpaa2_eth_tx(struct sk_buff *skb,
 	}
 
 	/* Setup the FD fields */
-	memset(&fd, 0, sizeof(fd));
 
 	if (skb_is_nonlinear(skb)) {
-		err = dpaa2_eth_build_sg_fd(priv, skb, &fd, &swa);
+		err = dpaa2_eth_build_sg_fd(priv, skb, fd, &swa);
 		percpu_extras->tx_sg_frames++;
 		percpu_extras->tx_sg_bytes += skb->len;
+		fd_len = dpaa2_fd_get_len(fd);
 	} else if (skb_headroom(skb) < needed_headroom) {
-		err = dpaa2_eth_build_sg_fd_single_buf(priv, skb, &fd, &swa);
+		err = dpaa2_eth_build_sg_fd_single_buf(priv, skb, fd, &swa);
 		percpu_extras->tx_sg_frames++;
 		percpu_extras->tx_sg_bytes += skb->len;
 		percpu_extras->tx_converted_sg_frames++;
 		percpu_extras->tx_converted_sg_bytes += skb->len;
+		fd_len = dpaa2_fd_get_len(fd);
 	} else {
-		err = dpaa2_eth_build_single_fd(priv, skb, &fd, &swa);
+		err = dpaa2_eth_build_single_fd(priv, skb, fd, &swa);
+		fd_len = dpaa2_fd_get_len(fd);
 	}
 
 	if (unlikely(err)) {
@@ -1161,10 +1169,11 @@ static netdev_tx_t __dpaa2_eth_tx(struct sk_buff *skb,
 	}
 
 	if (skb->cb[0])
-		dpaa2_eth_enable_tx_tstamp(priv, &fd, swa, skb);
+		dpaa2_eth_enable_tx_tstamp(priv, fd, swa, skb);
 
 	/* Tracing point */
-	trace_dpaa2_tx_fd(net_dev, &fd);
+	for (i = 0; i < num_fds; i++)
+		trace_dpaa2_tx_fd(net_dev, &fd[i]);
 
 	/* TxConf FQ selection relies on queue id from the stack.
 	 * In case of a forwarded frame from another DPNI interface, we choose
@@ -1184,27 +1193,32 @@ static netdev_tx_t __dpaa2_eth_tx(struct sk_buff *skb,
 		queue_mapping %= dpaa2_eth_queue_count(priv);
 	}
 	fq = &priv->fq[queue_mapping];
-
-	fd_len = dpaa2_fd_get_len(&fd);
 	nq = netdev_get_tx_queue(net_dev, queue_mapping);
 	netdev_tx_sent_queue(nq, fd_len);
 
 	/* Everything that happens after this enqueues might race with
 	 * the Tx confirmation callback for this frame
 	 */
-	for (i = 0; i < DPAA2_ETH_ENQUEUE_RETRIES; i++) {
-		err = priv->enqueue(priv, fq, &fd, prio, 1, NULL);
-		if (err != -EBUSY)
-			break;
+	max_retries = num_fds * DPAA2_ETH_ENQUEUE_RETRIES;
+	while (total_enqueued < num_fds && retries < max_retries) {
+		err = priv->enqueue(priv, fq, &fd[total_enqueued],
+				    prio, num_fds - total_enqueued, &enqueued);
+		if (err == -EBUSY) {
+			retries++;
+			continue;
+		}
+
+		total_enqueued += enqueued;
 	}
-	percpu_extras->tx_portal_busy += i;
+	percpu_extras->tx_portal_busy += retries;
+
 	if (unlikely(err < 0)) {
 		percpu_stats->tx_errors++;
 		/* Clean up everything, including freeing the skb */
-		dpaa2_eth_free_tx_fd(priv, fq, &fd, false);
+		dpaa2_eth_free_tx_fd(priv, fq, fd, false);
 		netdev_tx_completed_queue(nq, 1, fd_len);
 	} else {
-		percpu_stats->tx_packets++;
+		percpu_stats->tx_packets += total_enqueued;
 		percpu_stats->tx_bytes += fd_len;
 	}
 
@@ -4406,6 +4420,13 @@ static int dpaa2_eth_probe(struct fsl_mc_device *dpni_dev)
 		goto err_alloc_sgt_cache;
 	}
 
+	priv->fd = alloc_percpu(*priv->fd);
+	if (!priv->fd) {
+		dev_err(dev, "alloc_percpu(fds) failed\n");
+		err = -ENOMEM;
+		goto err_alloc_fds;
+	}
+
 	err = dpaa2_eth_netdev_init(net_dev);
 	if (err)
 		goto err_netdev_init;
@@ -4493,6 +4514,8 @@ static int dpaa2_eth_probe(struct fsl_mc_device *dpni_dev)
 err_alloc_rings:
 err_csum:
 err_netdev_init:
+	free_percpu(priv->fd);
+err_alloc_fds:
 	free_percpu(priv->sgt_cache);
 err_alloc_sgt_cache:
 	free_percpu(priv->percpu_extras);
@@ -4548,6 +4571,7 @@ static int dpaa2_eth_remove(struct fsl_mc_device *ls_dev)
 		fsl_mc_free_irqs(ls_dev);
 
 	dpaa2_eth_free_rings(priv);
+	free_percpu(priv->fd);
 	free_percpu(priv->sgt_cache);
 	free_percpu(priv->percpu_stats);
 	free_percpu(priv->percpu_extras);
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
index 7f9c6f4dea53..64e4aaebdcb2 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
@@ -497,6 +497,11 @@ struct dpaa2_eth_trap_data {
 
 #define DPAA2_ETH_DEFAULT_COPYBREAK	512
 
+#define DPAA2_ETH_ENQUEUE_MAX_FDS	200
+struct dpaa2_eth_fds {
+	struct dpaa2_fd array[DPAA2_ETH_ENQUEUE_MAX_FDS];
+};
+
 /* Driver private data */
 struct dpaa2_eth_priv {
 	struct net_device *net_dev;
@@ -579,6 +584,8 @@ struct dpaa2_eth_priv {
 	struct devlink_port devlink_port;
 
 	u32 rx_copybreak;
+
+	struct dpaa2_eth_fds __percpu *fd;
 };
 
 struct dpaa2_eth_devlink_priv {
-- 
2.33.1

