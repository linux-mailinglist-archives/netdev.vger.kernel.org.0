Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A7874AEDED
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 10:25:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232055AbiBIJZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 04:25:11 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:44596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbiBIJZK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 04:25:10 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on0600.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe0d::600])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3169FE03D712
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 01:25:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LSQtgA6i0BH5hWlEhv+vvB7gVt5uYBCo7nH8qddnVfqHZls6n49E7kdGN8PCYE1C374iX3HcAWGWka72Aaz8eXRYhnkKHKkW7JcD/1EmTA0R9yHzxAx0LSC7pBN5epZ5RaaHh8ZL855jWQc1wCzXCdHvIl9EywiPXv8GevE7SG3BW301lOCqkt3Yt45wM/V1+Jzjld5kZT63RxhdTPAqY9rTI/G6cmOHmiBYnIVgxAJ7BLPXuCoA/IhWmX08cotXwzAF/Pz7dJ47XZBFPs8ZVMTC+amBegN0bHYEA8pKxRDIwbnpYlfuT7OGWO8FRWKs6CTn9S27unSh499a2d52bA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0CVfbngSFZA8obmdC6h6TN3I0nd4NCGn+Z98J28qkXg=;
 b=HXxEHQ2aX63kotoEeFsVjgk6iBUkJsv9C3k2DkhBWXnc4MGF4Ovj7NlCLwGMzK2k81AybEKCrDXoBCC6L72RlUPgD5tf60yoi5qV7sXIKhb6AHynxEOsFi/cDK4CxOtwajuDg8X9x/8dT9jJCPHdZRc5QIPUndfoIQG2E+KRnHIqZA/iaO+28sciPwSnhs/CNRQazTnc99u8LN2DAwYTplkqEIDia9VRX5JyB/8qgqMTFjOP1bNxA6VoYzp4aN+TvEerru8Ca+6DcA40fJGhuBifdBmt5+xfwUjqJu6X2fQt7T40I/0TuNHvhvPsajvmX5UC1ibGFNz3OjKXYeYNHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0CVfbngSFZA8obmdC6h6TN3I0nd4NCGn+Z98J28qkXg=;
 b=NGuITutAlUnz2EEKKWvPkpgylbs6VZYugLV+BibFzyQNwCcEys6FrpmhhdP2LMsdo0rfllmyxnyDKD4Wm9GNVq85HMaqeWErqvcQPxoHNYo5+Ola1rfR4Ej4gH1+rr4kEYVYWRC1T0Yy8JEm6o7JSfjH9h1EyONt6NBwjn0y7GA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com (2603:10a6:20b:436::16)
 by VI1PR04MB5423.eurprd04.prod.outlook.com (2603:10a6:803:da::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.18; Wed, 9 Feb
 2022 09:24:01 +0000
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::5df9:5bf0:7ac1:a793]) by AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::5df9:5bf0:7ac1:a793%9]) with mapi id 15.20.4975.011; Wed, 9 Feb 2022
 09:24:01 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     youri.querry_1@nxp.com, leoyang.li@nxp.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 2/7] dpaa2-eth: allocate a fragment already aligned
Date:   Wed,  9 Feb 2022 11:23:30 +0200
Message-Id: <20220209092335.3064731-3-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220209092335.3064731-1-ioana.ciornei@nxp.com>
References: <20220209092335.3064731-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR03CA0037.eurprd03.prod.outlook.com (2603:10a6:208::14)
 To AM9PR04MB8555.eurprd04.prod.outlook.com (2603:10a6:20b:436::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e635a2b3-7dbf-4d68-e85f-08d9ebade87a
X-MS-TrafficTypeDiagnostic: VI1PR04MB5423:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB54238177114365D8B488864AE02E9@VI1PR04MB5423.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CgCYsl7y3qenHcwcOMZQ0nkPEIYyQ+5sULNYtnz+sdPJubF6brR+8HsB6eSmyQOmKRfKi6Ke02STc9LioEjrCRvh528fkfoSGK0tMztRVIomok+aKKRl005bjYUk6E91Poqtoi4X8WLM6DXMpcc9xmAd/+SGkKAriuVeEivm57jC9IvYWVsXYbKnoMLWKD/RCnqLVD4qT12CCJ9tb3bmrJJma9RS7ZpZQnkLOyoRbocXWSXHaaoVY9+fcOREUrXZG65zzIDZBNrBpUU99S38VeJNkD9CMXZR/8Dg9FN/iud37UxAgbW/M+fqHL5o5E8Y+4Eb8xHtJwwceuv2AQ/fQN68Ev2QbhxK3EsR2JYcvXYvbzpEWwhIG+m5fPckh4AR8sE9g4c4K0sq7d1hi2MoY+8nZLwIbRafm3AJaKvlX5YhAn65jVL2aWnfUWaEZ3luUfTCcPnjMJOLnEMgL8PJpQs80+1ltva1PyTT2Pr9sdHGVlqeNq7WTVeuyL+eX8Set1Cexz75QLTG6rn0113Bu3/ddMw9sTWsL9rUolxqeH1j88PzVQTUxq8LP2cMUXjRqr41AbOCX863Pab7ZbQpX6v/vuBbJp5MxJx/EnUuGQBFs1/kfVCrgtzKyvInkF41ZEyW+7EmPHHpGHh/Ld7uxl7LT7eFx4XUUj1DtsS1W9FNxbVb81WbosLMVo5Pfld5HrzhwUWYRWr/LrzvJOTzoQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8555.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2616005)(83380400001)(66556008)(66476007)(8936002)(4326008)(8676002)(2906002)(1076003)(26005)(36756003)(6486002)(5660300002)(44832011)(52116002)(66946007)(86362001)(38350700002)(508600001)(38100700002)(186003)(316002)(6506007)(6666004)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DM7p0Evd/9tliQJcHAo0mksKP+LtNpQkbxlHmHJKdbtMKREpZqdVkWLiFzpv?=
 =?us-ascii?Q?I/z33PGmAFiyM9KwStkosCb5vYfXOUt0nUz1e+ZSF2ka02HXqv8kXcX0lI1M?=
 =?us-ascii?Q?0DPL/zv5uJsjFw5Zd2Li0N5XqM/VFPi7iEQo7NpNUc/H6Lyg9RlnnCBaECm4?=
 =?us-ascii?Q?DJOHH1DId/B9SB8KD3dkGtJhgdk2O1uzqaxQoHU26OkIBbGT+TfknHfDCyrp?=
 =?us-ascii?Q?Q/KJBazQIspRwv4eRiCLUqo8mMm3YgqLHqq6gB+EiViCLr8Salr8u9y491+l?=
 =?us-ascii?Q?sogln3xxQnkkVD94DcYU4ZrcDmF9zQ6FbG/zReESj65rV8iWs3qAexHIdDBX?=
 =?us-ascii?Q?qX/Whj253bAIdhoGTR3FmqpwP9doZLhliizsCCHB1kHSRnlfuhwVMeAN8x9a?=
 =?us-ascii?Q?FXWco7sm1l4+PaFSp4tFr2nZT8nIgdtQSGwKDd5yB4QCA+6+Y/izAlZohga3?=
 =?us-ascii?Q?DBpJa3BO/EBsAYeqpZ+R/813JiZSTNYuQe0z1ailgT5Bw0N39ep/3gn+cUL8?=
 =?us-ascii?Q?sKakzCU/Q5lw0JWiBqDfIz/DGqleJHYDhioEGKpshx9nknRAlFYoZubeiTH/?=
 =?us-ascii?Q?MdVujbRD+Its7klbJjAqDfrsGDQaZUMgGZnsD3MJAxudqqkAHXIf34s67fkL?=
 =?us-ascii?Q?fvZW93oGxDtReO3yoCl4Mlw0Z2JvH2tIG5L/h+VXdFAoR9nMoCbY7isuuw71?=
 =?us-ascii?Q?BL89dw3AlPb//h+0efY5Rcjfq0BYYxmePJQB4GAgJZw3msSVqzM2ACL8KSLK?=
 =?us-ascii?Q?BIwWOfC1DPoEjy5N8bSYWdRQFxIeLPTLvXGpi1mef107fBdj80fPmVznMExm?=
 =?us-ascii?Q?HVhgrPXvJh6Ersju7oKIxnDo5DqmRNqJ9uxNpSTUln5n3pnX9F/hvHjCbeUc?=
 =?us-ascii?Q?X7aO/2gp2iIBFsbNH6sY06nook5pz2HBqiXY8niY3dKuFA6UyhswbDunWyaT?=
 =?us-ascii?Q?wTrVppyjBacifTrM+Odu+rozcv4hr6BlPKB1Jxvn2RfyAj/V5Y+rmUSpb4LL?=
 =?us-ascii?Q?52Ecz5O5YezDlMYImiBxcMNAcYj65g7v7OaNFIYpbr8v0XW9xMP0R1iSb/Y/?=
 =?us-ascii?Q?s4kwhSA8L3tWa1E9nU242tm6DtF8NFRGhG/EXbPsW6LHtLwbxTroJ5NFY154?=
 =?us-ascii?Q?v+/bGGLFTv5AeGtrqd3hOTZbD5DM0XV9x3wcUPPERfvjCNtVgpcwpqYrwQST?=
 =?us-ascii?Q?moImTN0F7PVntop1DzRskhFIvV/Bb/KHPLiKgG5ipqOOAP/YxOLKFbfv63/o?=
 =?us-ascii?Q?w1rlpm3TpFiTDg8G+dJ48igca0RuRRX7OFfvLMI7aHUrGc5+aNJ8pQBdo6Hv?=
 =?us-ascii?Q?8fY5JRJtn3+NM7VsVsfuWnoS0CSouZlDDmHVldsO4aUtFRIwlFS+isoz1koy?=
 =?us-ascii?Q?d0TurzTUnHlU+C4XKd6vl1/9J96F4S+DtdGts6rXw8b2KcZ1zuS33/ajKvZz?=
 =?us-ascii?Q?fwkVjwGfVBQhQW2MGdgKP30gxS6nZ850DLS0FBCf1qBJQbLeoL2oGtamQ4pj?=
 =?us-ascii?Q?FzHN3/5rKrbNLeL8Q5fAIOq5AVsqJVlV/ZLq1tHxTwegbtIicybE5lg/iQ76?=
 =?us-ascii?Q?poeCcuX5ZYxmjAEYaop5UAsMgO1hwVSj7JhRFFKWpSV8h4E4wgn5oCuxqmc4?=
 =?us-ascii?Q?h4T0HnmwkUKAhQa1ydyyUxk=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e635a2b3-7dbf-4d68-e85f-08d9ebade87a
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2022 09:24:01.4998
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qjFfF/DnV3dOnudwvXvKZ0j/IdJImqZ/Hqpy8LcIe5qDE4Bjl1K0eYMnD0uK9DaP9wYVvcMaiJC1uVIuLqIUsw==
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

Instead of allocating memory and then manually aligning it to the
desired value use napi_alloc_frag_align() directly to streamline the
process.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 218b1516b86b..6ccbec21300f 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -888,14 +888,13 @@ static int dpaa2_eth_build_sg_fd_single_buf(struct dpaa2_eth_priv *priv,
 	sgt_buf_size = priv->tx_data_offset + sizeof(struct dpaa2_sg_entry);
 
 	if (sgt_cache->count == 0)
-		sgt_buf = kzalloc(sgt_buf_size + DPAA2_ETH_TX_BUF_ALIGN,
-				  GFP_ATOMIC);
+		sgt_buf = napi_alloc_frag_align(sgt_buf_size, DPAA2_ETH_TX_BUF_ALIGN);
 	else
 		sgt_buf = sgt_cache->buf[--sgt_cache->count];
 	if (unlikely(!sgt_buf))
 		return -ENOMEM;
+	memset(sgt_buf, 0, sgt_buf_size);
 
-	sgt_buf = PTR_ALIGN(sgt_buf, DPAA2_ETH_TX_BUF_ALIGN);
 	sgt = (struct dpaa2_sg_entry *)(sgt_buf + priv->tx_data_offset);
 
 	addr = dma_map_single(dev, skb->data, skb->len, DMA_BIDIRECTIONAL);
@@ -935,7 +934,7 @@ static int dpaa2_eth_build_sg_fd_single_buf(struct dpaa2_eth_priv *priv,
 	dma_unmap_single(dev, addr, skb->len, DMA_BIDIRECTIONAL);
 data_map_failed:
 	if (sgt_cache->count >= DPAA2_ETH_SGT_CACHE_SIZE)
-		kfree(sgt_buf);
+		skb_free_frag(sgt_buf);
 	else
 		sgt_cache->buf[sgt_cache->count++] = sgt_buf;
 
@@ -1088,7 +1087,7 @@ static void dpaa2_eth_free_tx_fd(struct dpaa2_eth_priv *priv,
 			skb_free_frag(buffer_start);
 		} else {
 			if (sgt_cache->count >= DPAA2_ETH_SGT_CACHE_SIZE)
-				kfree(buffer_start);
+				skb_free_frag(buffer_start);
 			else
 				sgt_cache->buf[sgt_cache->count++] = buffer_start;
 		}
@@ -1523,7 +1522,7 @@ static void dpaa2_eth_sgt_cache_drain(struct dpaa2_eth_priv *priv)
 		count = sgt_cache->count;
 
 		for (i = 0; i < count; i++)
-			kfree(sgt_cache->buf[i]);
+			skb_free_frag(sgt_cache->buf[i]);
 		sgt_cache->count = 0;
 	}
 }
-- 
2.33.1

