Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC6E14AEDF0
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 10:25:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232374AbiBIJZW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 04:25:22 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:45136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbiBIJZT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 04:25:19 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on0600.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe0d::600])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17B83E03D72C
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 01:25:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=adPldMEH80bjAxPGvntsV0Ey4+heygsJiR1dQAI3MZfpia/MAAjm8VRCA+Wlv66y2CrhQKPfGWA12x1AcfbAoWfHqYJ84XT6Q5ZrCcwQESPX4Ra/YJvHJVHkL6Ab6QwtlPbYrYj4OM61W0909KGXaEb2FmFZk/RsORFKR1PqNnCoWKJW4a7+bxfXbmyrSlenc9eBwM8XwIF16XUTGrA22l45O0JbrTI1mv0oOdfOJ+CfKptj9pcWaf4Yyu5247C8vx50V6qRW9+JMhGw2936sNThtHyN4lBqCp7kaQAmwguDIRMw+KaS242sFJkz3N42BoLLJ0MMG265tybc8qx/pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RaWyxIpeNOfGLlIWGlvMkZ0N1zcYFmdXBN5cS4LSbBU=;
 b=GhS0v2fbf6rDvyLm0HdGQ38c+Xyr/qqzuBdfRRH/dAJUUNO3BaEND97uhOyC7PxgS+Z4YqrflzOIwcJOz4DDpi1+zfjldnmp3fRtV8ac1lZVi5aCM5/tjOpyoqtkW3Ychck4txXZ/MqhfIyOMFZ6Qgb4yyoI2bWoURfS+ndIZ+BAvYwspdXKP65hjJHCdNwI+D7NFNer4w5ydivBZKNi4+iSyN77rfILycEY2AvVr4q32b7eXpeJQ/KF9apH4Y4UPT8s4KCINHlsue1OgHK5GcVPZ/igIy+IOtybJW+XH9Rn7jfkrOuZ4n5tVEtY9d9cKpwjo5AwtaxW+tewgk6pBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RaWyxIpeNOfGLlIWGlvMkZ0N1zcYFmdXBN5cS4LSbBU=;
 b=Twnq2GRmWOYxe5yoAe51hEicYZX4QlNPZKVd16ykneLW/81nu4ubGcsSC1nxxtMOw/vgziBbIV8sgrvAFqyZ6q9TrxB5XccZIkb1fBDAlLuYtBEH21jjTQ9EL5IQM6PpXzRHCdD4PBceHD9nyVIY9owGmQJHuU7iqnNzrb77wRk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com (2603:10a6:20b:436::16)
 by VI1PR04MB5423.eurprd04.prod.outlook.com (2603:10a6:803:da::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.18; Wed, 9 Feb
 2022 09:24:02 +0000
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::5df9:5bf0:7ac1:a793]) by AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::5df9:5bf0:7ac1:a793%9]) with mapi id 15.20.4975.011; Wed, 9 Feb 2022
 09:24:02 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     youri.querry_1@nxp.com, leoyang.li@nxp.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 3/7] dpaa2-eth: extract the S/G table buffer cache interaction into functions
Date:   Wed,  9 Feb 2022 11:23:31 +0200
Message-Id: <20220209092335.3064731-4-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220209092335.3064731-1-ioana.ciornei@nxp.com>
References: <20220209092335.3064731-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR03CA0037.eurprd03.prod.outlook.com (2603:10a6:208::14)
 To AM9PR04MB8555.eurprd04.prod.outlook.com (2603:10a6:20b:436::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3df7aac8-0736-42f3-65a7-08d9ebade900
X-MS-TrafficTypeDiagnostic: VI1PR04MB5423:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB54236768888EEE992361C61DE02E9@VI1PR04MB5423.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +G5xeI8fW5+e2vDzA0vVfNXKzOKes4NjEb6D3kGxwfIa8RpPMio6xTmQaAZ0pS/jViuffm65qcnRSKxduI4JsddjNhlrUp4HhasUJ4fsMckWMRoK4ry39yEFuAOu+Ng/yAoq73umxTJ+laGsY37OB1jSTFcnfI+zJ6RAbibiUzHgs4j5bP+nvzRbbea0jYY7YOXPUPkSTe73axoY4lloSIO5JmZwqpl3f68t9uP6x9qWXoScKHI4p3uxu+WLdePRFtcnHCHottWZljw9CLJOAPQ9z8pMz84L/c81oetMFyTdS13hQEznhI3AKr+9FFBWR8f2Undo3JP+IHLcBpX2P00Z/ItC13VbixuPojCe0smtS3VbK4WVWzTGnJZDsGegbA653igzBoRYzPJbtdpSKK+O5EXsoecfGUp6RNcqQkfsn9BuhJTKh7YovyKBPuZimwLHge5/eEVlm8S/sWjiiRDZAwQp2a2GKcTKKIaLkPOTHUmQk8O7eikSFMytmn54VSQv83qdN2oOrqi5J+VOG3bj9TT/wuklKrCeaMp0uL7PtL8L3sLLAB3m7/sB6iX0S+EEMxFAKPuhSGMnCyJWo61pza2vBl8VzU4c5+kWZztRakqEMGegJch6Dw3WfkhezU2sI4he5A98ptWqEse3wJu0eJ8ODmWBhx4r94tjs6dJcYa23+eMOatWJx2r0B1S6RKxA4fZHJIrNn7BKpOKSg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8555.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2616005)(83380400001)(66556008)(66476007)(8936002)(4326008)(8676002)(2906002)(1076003)(26005)(36756003)(6486002)(5660300002)(44832011)(52116002)(66946007)(86362001)(38350700002)(508600001)(38100700002)(186003)(316002)(6506007)(6666004)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wiYUF3edSUK8ajIXtzV24CM0NSoG6MRkcJATAybae8Q3ROVAnB/S5WOcUjRa?=
 =?us-ascii?Q?3cMuBNIs7oJJJo+VnkOpqVqngZ5OCZWNBBD99Xm1alH3SDRIapgYAch1P0fW?=
 =?us-ascii?Q?6aUylaXCYghUzAJDI1IjjO7zBH6ESVcok4B4brwZPSDc9mRhrEW0Upqkj0hm?=
 =?us-ascii?Q?5e/5sPIOfWfCUH/ky9UNtFjTnoEEBm0JgSIV9mCMpjygae7zTKrbC8n8RpuQ?=
 =?us-ascii?Q?tboEdVNeW4cvysqpNwgKl3d2+hycMfDJYaVwuzN4iKglozBXUJui/EyjfpM/?=
 =?us-ascii?Q?hPTvRMskR6wRMoKHhZ5kbvfPvCt+MItBEG091LY69kHnuXvdKwRn4P6g1ZXX?=
 =?us-ascii?Q?/sMqC3AhKAV7WzdKCEVgHXFAz7Dg19J2wyzvSNXRiqnJx5FZCkbCR5gBC2DU?=
 =?us-ascii?Q?FQJoUpRxGu+vCmzlzCuHqElgP1sZAXvcvYt0fuyqM1ga5/hDzrPbMYnPkIYZ?=
 =?us-ascii?Q?d8DIbPxXt1ic7XK1mN5WyrfLyRDwZB8Tq594C8aHqf1VGz8rf5Jy31YI5uQ0?=
 =?us-ascii?Q?yQIeooH762+2sRiCrz3aYBJSIe3DzTMnzxG0YIwoCHdlMjXSF0mwT/CKXTnI?=
 =?us-ascii?Q?ON4Jla7SvFsr6TFLFX9xBU1lmYZHfaf82rlLtt7ffZNf1S6gUn+VIn2xGpp+?=
 =?us-ascii?Q?iEHHqZ/gvvhyH5X3ZZ8t790PVk0Ofp+TzjjinloK6PBOwcfIlLb9G1z0pkaT?=
 =?us-ascii?Q?6Z3oAnr82te5TxLq9DnW+ePi0mrmdLik5IfegZwi/sxc+xGcFUbdnsZzwoXw?=
 =?us-ascii?Q?DMu1Qq3gVpQn5JKAv6Eoh6o8t50z6e1Wn5owz+pYGu+fYMNC9zjnGP4bxm3T?=
 =?us-ascii?Q?i8hwd3zDPBDcYm9yhzl1FYjeZ67NH1w55bd5yswKbazPOP7MmphqgcD38eA2?=
 =?us-ascii?Q?NCy8VKt6UuyVwGyIrDFWYhodgcyy9dilD5epb/Ui/aKBvA1xAfprIl83tBkQ?=
 =?us-ascii?Q?/EevnqJ2bsHtqzE6pgqaf8axlK+Omb+Fs/7RCXtrWOq8D5gobTVKQLhC4DU+?=
 =?us-ascii?Q?YZnFypyzdaIFqDn0VfH6NlqULP2C8EzrRiMtrvGWZGkq5g9y0rcQSJghj2N8?=
 =?us-ascii?Q?vBBiuin27JYvatE1UNsWu3ZsU4k7r21+bDuU2hhOPMSZodV4BsTzANXjGkXM?=
 =?us-ascii?Q?cSgPqGeE3qxWRfQqLG1NtrG1A4lWeyfWeFfvV6ecuy7mhjmDTz6D2P3bEKND?=
 =?us-ascii?Q?0QG4WtPiiKpdSu0epYMOIp99RPWwcdr2ib4zX7yXJsAMwKgpgrzM5gTT/OU/?=
 =?us-ascii?Q?esYmUr/IqH3To7GIfNJxiCYbMbuw0FyGb+6ZFsOJ1m5ghC/2RQw+gx3FB5Vz?=
 =?us-ascii?Q?HtO12kWvniz98Q5CL2UF2GPYoJc4k+dQPD6+loByuO7vRcAzDLdkbw5XNptf?=
 =?us-ascii?Q?gl0fcIrzmjBtiSrmQTDxAU3p7c+fO1B4gM/snYj4wmpeODRG0PXkLftgWwdP?=
 =?us-ascii?Q?eLWqAwqSFqnZ28EfMz0JwLEuCnaRYb8QxQYpGjZF/uuaNRbUtk+GEVPDvnc8?=
 =?us-ascii?Q?VIoM/FiZd7CLhGWIrvOnQQ79WMK98GDXRO+/F1LHzCv3nIb/T+Cr+FKnpw9N?=
 =?us-ascii?Q?721kOP5EDb9J1cgI5b0pQOPn61qEZd9wAjJFM1T781GG+K6J73JBjwUe51Ye?=
 =?us-ascii?Q?Rvif5J3h8tvBbgLNKyjKvWw=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3df7aac8-0736-42f3-65a7-08d9ebade900
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2022 09:24:02.2826
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MRj/YMwcTur9W0ukNK5Rt+yywqxqoX27ExUg5foIJOc6yDwoHfG6lLzp/5cqvRyge+Wp0QSWUjt5aLhzPVRISw==
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

The dpaa2-eth driver uses in certain circumstances a buffer cache for
the S/G tables needed in case of a S/G FD. At the moment, the
interraction with the cache is open-coded and couldn't be reused easily.

Add two new functions - dpaa2_eth_sgt_get and dpaa2_eth_sgt_recycle -
which help with code reusability.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 61 +++++++++++--------
 1 file changed, 37 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 6ccbec21300f..006ab355a21d 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -760,6 +760,38 @@ static void dpaa2_eth_enable_tx_tstamp(struct dpaa2_eth_priv *priv,
 	}
 }
 
+static void *dpaa2_eth_sgt_get(struct dpaa2_eth_priv *priv)
+{
+	struct dpaa2_eth_sgt_cache *sgt_cache;
+	void *sgt_buf = NULL;
+	int sgt_buf_size;
+
+	sgt_cache = this_cpu_ptr(priv->sgt_cache);
+	sgt_buf_size = priv->tx_data_offset + sizeof(struct dpaa2_sg_entry);
+
+	if (sgt_cache->count == 0)
+		sgt_buf = napi_alloc_frag_align(sgt_buf_size, DPAA2_ETH_TX_BUF_ALIGN);
+	else
+		sgt_buf = sgt_cache->buf[--sgt_cache->count];
+	if (!sgt_buf)
+		return NULL;
+
+	memset(sgt_buf, 0, sgt_buf_size);
+
+	return sgt_buf;
+}
+
+static void dpaa2_eth_sgt_recycle(struct dpaa2_eth_priv *priv, void *sgt_buf)
+{
+	struct dpaa2_eth_sgt_cache *sgt_cache;
+
+	sgt_cache = this_cpu_ptr(priv->sgt_cache);
+	if (sgt_cache->count >= DPAA2_ETH_SGT_CACHE_SIZE)
+		skb_free_frag(sgt_buf);
+	else
+		sgt_cache->buf[sgt_cache->count++] = sgt_buf;
+}
+
 /* Create a frame descriptor based on a fragmented skb */
 static int dpaa2_eth_build_sg_fd(struct dpaa2_eth_priv *priv,
 				 struct sk_buff *skb,
@@ -810,7 +842,6 @@ static int dpaa2_eth_build_sg_fd(struct dpaa2_eth_priv *priv,
 		err = -ENOMEM;
 		goto sgt_buf_alloc_failed;
 	}
-	memset(sgt_buf, 0, sgt_buf_size);
 
 	sgt = (struct dpaa2_sg_entry *)(sgt_buf + priv->tx_data_offset);
 
@@ -875,7 +906,6 @@ static int dpaa2_eth_build_sg_fd_single_buf(struct dpaa2_eth_priv *priv,
 					    void **swa_addr)
 {
 	struct device *dev = priv->net_dev->dev.parent;
-	struct dpaa2_eth_sgt_cache *sgt_cache;
 	struct dpaa2_sg_entry *sgt;
 	struct dpaa2_eth_swa *swa;
 	dma_addr_t addr, sgt_addr;
@@ -884,17 +914,10 @@ static int dpaa2_eth_build_sg_fd_single_buf(struct dpaa2_eth_priv *priv,
 	int err;
 
 	/* Prepare the HW SGT structure */
-	sgt_cache = this_cpu_ptr(priv->sgt_cache);
 	sgt_buf_size = priv->tx_data_offset + sizeof(struct dpaa2_sg_entry);
-
-	if (sgt_cache->count == 0)
-		sgt_buf = napi_alloc_frag_align(sgt_buf_size, DPAA2_ETH_TX_BUF_ALIGN);
-	else
-		sgt_buf = sgt_cache->buf[--sgt_cache->count];
+	sgt_buf = dpaa2_eth_sgt_get(priv);
 	if (unlikely(!sgt_buf))
 		return -ENOMEM;
-	memset(sgt_buf, 0, sgt_buf_size);
-
 	sgt = (struct dpaa2_sg_entry *)(sgt_buf + priv->tx_data_offset);
 
 	addr = dma_map_single(dev, skb->data, skb->len, DMA_BIDIRECTIONAL);
@@ -933,10 +956,7 @@ static int dpaa2_eth_build_sg_fd_single_buf(struct dpaa2_eth_priv *priv,
 sgt_map_failed:
 	dma_unmap_single(dev, addr, skb->len, DMA_BIDIRECTIONAL);
 data_map_failed:
-	if (sgt_cache->count >= DPAA2_ETH_SGT_CACHE_SIZE)
-		skb_free_frag(sgt_buf);
-	else
-		sgt_cache->buf[sgt_cache->count++] = sgt_buf;
+	dpaa2_eth_sgt_recycle(priv, sgt_buf);
 
 	return err;
 }
@@ -1004,8 +1024,6 @@ static void dpaa2_eth_free_tx_fd(struct dpaa2_eth_priv *priv,
 	struct dpaa2_eth_swa *swa;
 	u8 fd_format = dpaa2_fd_get_format(fd);
 	u32 fd_len = dpaa2_fd_get_len(fd);
-
-	struct dpaa2_eth_sgt_cache *sgt_cache;
 	struct dpaa2_sg_entry *sgt;
 
 	fd_addr = dpaa2_fd_get_addr(fd);
@@ -1082,15 +1100,10 @@ static void dpaa2_eth_free_tx_fd(struct dpaa2_eth_priv *priv,
 
 	/* Free SGT buffer allocated on tx */
 	if (fd_format != dpaa2_fd_single) {
-		sgt_cache = this_cpu_ptr(priv->sgt_cache);
-		if (swa->type == DPAA2_ETH_SWA_SG) {
+		if (swa->type == DPAA2_ETH_SWA_SG)
 			skb_free_frag(buffer_start);
-		} else {
-			if (sgt_cache->count >= DPAA2_ETH_SGT_CACHE_SIZE)
-				skb_free_frag(buffer_start);
-			else
-				sgt_cache->buf[sgt_cache->count++] = buffer_start;
-		}
+		else
+			dpaa2_eth_sgt_recycle(priv, buffer_start);
 	}
 
 	/* Move on with skb release */
-- 
2.33.1

