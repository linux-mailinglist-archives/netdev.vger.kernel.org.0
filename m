Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87D1A6DE3DE
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 20:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbjDKS1t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 14:27:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbjDKS1d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 14:27:33 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2046.outbound.protection.outlook.com [40.107.244.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4028249D9
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 11:27:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nuRVbSpXQz1ETdkP5+H/KR5wyObF/l7XGWgNqGeyTBoQcjdRbaJevvUHyq+w93ULrwDDdH+mGYJ8ovmi4zVTSQi2RzZzRzusWFLltyBwjFxQhg72XXiXxNwoLkAAatQIgIo5xlia6M9AQohb+IpETswh/K4x0tbUvrQV6+xxRIQG/8I2VtmMH+137R/Ac989uPcJ/aMGxDh6Ph9slM25yQOqyLiG3BSFr02xEayqPID1j3sUlCu3Pb5pJk3H6UlQWw+LHo8qVmJYnM2MxI8dCNbyZTGc8EGOpdaUfSnH1Z0iC81S7NjflDOGBoU+FvTvlE7HSi90FULxRzpShHhC/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D8nBC/InmYVRuxyb6QH6xhJTPxuynncY9p33J9EKAC4=;
 b=Wxl2ZPzKeKQspay8brzA2bXCGZIylDcWQwyL8ow+gYlfwkFYeW/69XJzag8e+elqYTUCAEdG1v+YQt7rojgLnsq93jkJTQBtsDOuut4GvCst4qExzvM6OasWkkqqm0W5T6gqqfXJdJZo7IctYmWzwfSO+nZwey+YdHvrAnj6CFxl/Si8eR0liTaWbnlT8d9SLIExH/iHY+xbExbsu62eM2964mHW4+tN4RpNK0RXHcMAFL9fg+HFGrElIV6tHLLh5jCDdA2cOqHVD0OEJOKJFv3gUUKXrs2h+HgMkA1uRl4vZIuKEpdO6FIGnje+/cnoGWKopSdhgoody8S8IvZ9QQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D8nBC/InmYVRuxyb6QH6xhJTPxuynncY9p33J9EKAC4=;
 b=4phstkWijP04UpULIAGVvhYXgt7rfZ2i1z6kDgqf/mRu2LDZbjDCJKXj7E3Vv/BUHjMVPmeUx8i2Lc1j3ZWG47VSxOvWqRK5EYnzKSoC2wXZev9us7J3N+XL9YIDtYlIDEmJqgQIl9iZoETcra98MX8LHTW9OScdA3CoNuxM9F4=
Received: from DM6PR02CA0081.namprd02.prod.outlook.com (2603:10b6:5:1f4::22)
 by SA1PR12MB8094.namprd12.prod.outlook.com (2603:10b6:806:336::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.31; Tue, 11 Apr
 2023 18:27:28 +0000
Received: from DM6NAM11FT021.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1f4:cafe::9e) by DM6PR02CA0081.outlook.office365.com
 (2603:10b6:5:1f4::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.28 via Frontend
 Transport; Tue, 11 Apr 2023 18:27:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT021.mail.protection.outlook.com (10.13.173.76) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6298.29 via Frontend Transport; Tue, 11 Apr 2023 18:27:27 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 11 Apr
 2023 13:27:26 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34 via Frontend
 Transport; Tue, 11 Apr 2023 13:27:25 -0500
From:   <edward.cree@amd.com>
To:     <linux-net-drivers@amd.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@google.com>
CC:     Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>,
        <habetsm.xilinx@gmail.com>, <sudheer.mogilappagari@intel.com>
Subject: [RFC PATCH v2 net-next 4/7] net: ethtool: let the core choose RSS context IDs
Date:   Tue, 11 Apr 2023 19:26:12 +0100
Message-ID: <7a18d0588e8596ad9cc83234488bebe22ba3d328.1681236653.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1681236653.git.ecree.xilinx@gmail.com>
References: <cover.1681236653.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT021:EE_|SA1PR12MB8094:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e52abcc-c889-4063-21c2-08db3aba6799
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +9iceySNVm4hH54xQePDRqoy1Mm/Ys97ibZPKX3bBjxwEqg5SA7hu0JzBKaMfexfC2jHgAdXQ3ibKNBEsmZE7GZCrD0MnooaXY6cG+xNvWkouLVWg9QDOSiQzbSueBiBCiUC8vlU37bWcMAKJWYVarA8+GvD+OGsmaN+MOipuMqnPI1mKhFx5KsDY5McvOUXkRc6va0AioyjOI37hdmWYLI7KKDxE6kM+J71bGDtdDQujKNAMcCj1HtgigUe3aaUnq1CHMM5lQG4nqWIqANwUfLsbf9VBtJr4+g5H88Hkv05xVl/9c9J7bSLPAAp8RjMm3uxS3b9cT4YpDuSNs64O3VnW0ykasUCuecYXj5YSgYd/JSk1Les3ZMhZs4X0Uh0oNYNtF7xLXo+ui4rRtKv2wetilFNS91vI4aIwD4/mMvdZgIiZTtX6WV8bvQbWQy5GOIJUCkXs9LiLJSww/HWV2uxxPFWjj7f6gfViQruYS7GzRisdmxYhKPUNdrUPo9fvAMOs2MgttpBGG2Uj3zdxwJCQUrGaIh9ggTUYl16z31vClSZvw2fFO1S2p+o6GyhMu+8IRwVoJu6OLCsf5ZsnEDQtN4lDcebkHxVUoamdsBS9sWWJOYKQ7jD1db+QD7mkCASPlPHa0n1GgRPy3zfKAvv3mxXb9lrCeWzyMczIzAGni1CK0D6nNqfHx9LC/KxV6BedyrPwBETvxCkc3NvPwgu5l3gpsXrFmsicEzn19I=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(39860400002)(346002)(136003)(451199021)(36840700001)(46966006)(40470700004)(47076005)(82740400003)(36860700001)(40480700001)(426003)(316002)(26005)(478600001)(186003)(6666004)(2876002)(54906003)(9686003)(110136005)(83380400001)(2906002)(336012)(8676002)(81166007)(5660300002)(4326008)(36756003)(356005)(40460700003)(41300700001)(70586007)(8936002)(82310400005)(70206006)(86362001)(55446002)(66899021)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 18:27:27.8380
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e52abcc-c889-4063-21c2-08db3aba6799
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT021.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8094
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree.xilinx@gmail.com>

Add a new API to create/modify/remove RSS contexts, that passes in the
 newly-chosen context ID (not as a pointer) rather than leaving the
 driver to choose it on create.  Also pass in the ctx, allowing drivers
 to easily use its private data area to store their hardware-specific
 state.
Keep the existing .set_rxfh_context API for now as a fallback, but
 deprecate it.

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
Changes in v2:
* split the new API into create/modify/remove ops (kuba).  Also means we
  don't need to rename the old API and touch legacy drivers
* squash patch "net: ethtool: pass ctx_priv and create into .set_rxfh_context"
---
 include/linux/ethtool.h | 40 ++++++++++++++++++++++--
 net/core/dev.c          | 11 +++++--
 net/ethtool/ioctl.c     | 67 ++++++++++++++++++++++++++++++++---------
 3 files changed, 97 insertions(+), 21 deletions(-)

diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 710d6a985347..12ed3b79be68 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -747,10 +747,33 @@ struct ethtool_mm_stats {
  * @get_rxfh_context: Get the contents of the RX flow hash indirection table,
  *	hash key, and/or hash function assiciated to the given rss context.
  *	Returns a negative error code or zero.
- * @set_rxfh_context: Create, remove and configure RSS contexts. Allows setting
+ * @create_rxfh_context: Create a new RSS context with the specified RX flow
+ *	hash indirection table, hash key, and hash function.
+ *	Arguments which are set to %NULL or zero will be populated to
+ *	appropriate defaults by the driver.
+ *	The &struct ethtool_rxfh_context for this context is passed in @ctx;
+ *	note that the indir table, hkey and hfunc are not yet populated as
+ *	of this call.  The driver does not need to update these; the core
+ *	will do so if this op succeeds.
+ *	If the driver provides this method, it must also provide
+ *	@modify_rxfh_context and @remove_rxfh_context.
+ *	Returns a negative error code or zero.
+ * @modify_rxfh_context: Reconfigure the specified RSS context.  Allows setting
  *	the contents of the RX flow hash indirection table, hash key, and/or
- *	hash function associated to the given context. Arguments which are set
- *	to %NULL or zero will remain unchanged.
+ *	hash function associated with the given context.
+ *	Arguments which are set to %NULL or zero will remain unchanged.
+ *	The &struct ethtool_rxfh_context for this context is passed in @ctx;
+ *	note that it will still contain the *old* settings.  The driver does
+ *	not need to update these; the core will do so if this op succeeds.
+ *	Returns a negative error code or zero. An error code must be returned
+ *	if at least one unsupported change was requested.
+ * @remove_rxfh_context: Remove the specified RSS context.
+ *	The &struct ethtool_rxfh_context for this context is passed in @ctx.
+ *	Returns a negative error code or zero.
+ * @set_rxfh_context: Deprecated API to create, remove and configure RSS
+ *	contexts. Allows setting the contents of the RX flow hash indirection
+ *	table, hash key, and/or hash function associated to the given context.
+ *	Arguments which are set to %NULL or zero will remain unchanged.
  *	Returns a negative error code or zero. An error code must be returned
  *	if at least one unsupported change was requested.
  * @get_channels: Get number of channels.
@@ -900,6 +923,17 @@ struct ethtool_ops {
 			    const u8 *key, const u8 hfunc);
 	int	(*get_rxfh_context)(struct net_device *, u32 *indir, u8 *key,
 				    u8 *hfunc, u32 rss_context);
+	int	(*create_rxfh_context)(struct net_device *,
+				       struct ethtool_rxfh_context *ctx,
+				       const u32 *indir, const u8 *key,
+				       const u8 hfunc, u32 rss_context);
+	int	(*modify_rxfh_context)(struct net_device *,
+				       struct ethtool_rxfh_context *ctx,
+				       const u32 *indir, const u8 *key,
+				       const u8 hfunc, u32 rss_context);
+	int	(*remove_rxfh_context)(struct net_device *,
+				       struct ethtool_rxfh_context *ctx,
+				       u32 rss_context);
 	int	(*set_rxfh_context)(struct net_device *, const u32 *indir,
 				    const u8 *key, const u8 hfunc,
 				    u32 *rss_context, bool delete);
diff --git a/net/core/dev.c b/net/core/dev.c
index c9ed9f6ea695..4feb58b0beb3 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10789,15 +10789,20 @@ static void netdev_rss_contexts_free(struct net_device *dev)
 	struct ethtool_rxfh_context *ctx;
 	u32 context;
 
-	if (!dev->ethtool_ops->set_rxfh_context)
+	if (!dev->ethtool_ops->create_rxfh_context &&
+	    !dev->ethtool_ops->set_rxfh_context)
 		return;
 	idr_for_each_entry(&dev->ethtool->rss_ctx, ctx, context) {
 		u32 *indir = ethtool_rxfh_context_indir(ctx);
 		u8 *key = ethtool_rxfh_context_key(ctx);
 
 		idr_remove(&dev->ethtool->rss_ctx, context);
-		dev->ethtool_ops->set_rxfh_context(dev, indir, key, ctx->hfunc,
-						   &context, true);
+		if (dev->ethtool_ops->create_rxfh_context)
+			dev->ethtool_ops->remove_rxfh_context(dev, ctx, context);
+		else
+			dev->ethtool_ops->set_rxfh_context(dev, indir, key,
+							   ctx->hfunc,
+							   &context, true);
 		kfree(ctx);
 	}
 }
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 9f9f8ba9c0f6..20154d6159a1 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -1273,7 +1273,8 @@ static noinline_for_stack int ethtool_set_rxfh(struct net_device *dev,
 	if (rxfh.rsvd8[0] || rxfh.rsvd8[1] || rxfh.rsvd8[2] || rxfh.rsvd32)
 		return -EINVAL;
 	/* Most drivers don't handle rss_context, check it's 0 as well */
-	if (rxfh.rss_context && !ops->set_rxfh_context)
+	if (rxfh.rss_context && !(ops->create_rxfh_context ||
+				  ops->set_rxfh_context))
 		return -EOPNOTSUPP;
 	create = rxfh.rss_context == ETH_RXFH_CONTEXT_ALLOC;
 
@@ -1348,8 +1349,28 @@ static noinline_for_stack int ethtool_set_rxfh(struct net_device *dev,
 		}
 		ctx->indir_size = dev_indir_size;
 		ctx->key_size = dev_key_size;
-		ctx->hfunc = rxfh.hfunc;
 		ctx->priv_size = ops->rxfh_priv_size;
+		/* Initialise to an empty context */
+		ctx->indir_no_change = ctx->key_no_change = 1;
+		ctx->hfunc = ETH_RSS_HASH_NO_CHANGE;
+		if (ops->create_rxfh_context) {
+			int ctx_id;
+
+			/* driver uses new API, core allocates ID */
+			/* if rss_ctx_max_id is not specified (left as 0), it is
+			 * treated as INT_MAX + 1 by idr_alloc
+			 */
+			ctx_id = idr_alloc(&dev->ethtool->rss_ctx, ctx, 1,
+					   dev->ethtool->rss_ctx_max_id,
+					   GFP_KERNEL_ACCOUNT);
+			/* 0 is not allowed, so treat it like an error here */
+			if (ctx_id <= 0) {
+				kfree(ctx);
+				ret = -ENOMEM;
+				goto out;
+			}
+			rxfh.rss_context = ctx_id;
+		}
 	} else if (rxfh.rss_context) {
 		ctx = idr_find(&dev->ethtool->rss_ctx, rxfh.rss_context);
 		if (!ctx) {
@@ -1358,13 +1379,35 @@ static noinline_for_stack int ethtool_set_rxfh(struct net_device *dev,
 		}
 	}
 
-	if (rxfh.rss_context)
-		ret = ops->set_rxfh_context(dev, indir, hkey, rxfh.hfunc,
-					    &rxfh.rss_context, delete);
-	else
+	if (rxfh.rss_context) {
+		if (ops->create_rxfh_context) {
+			if (create)
+				ret = ops->create_rxfh_context(dev, ctx, indir,
+							       hkey, rxfh.hfunc,
+							       rxfh.rss_context);
+			else if (delete)
+				ret = ops->remove_rxfh_context(dev, ctx,
+							       rxfh.rss_context);
+			else
+				ret = ops->modify_rxfh_context(dev, ctx, indir,
+							       hkey, rxfh.hfunc,
+							       rxfh.rss_context);
+		} else {
+			ret = ops->set_rxfh_context(dev, indir, hkey,
+						    rxfh.hfunc,
+						    &rxfh.rss_context, delete);
+		}
+	} else {
 		ret = ops->set_rxfh(dev, indir, hkey, rxfh.hfunc);
-	if (ret)
+	}
+	if (ret) {
+		if (create && ops->create_rxfh_context) {
+			/* failed to create, discard our new tracking entry */
+			idr_remove(&dev->ethtool->rss_ctx, rxfh.rss_context);
+			kfree(ctx);
+		}
 		goto out;
+	}
 
 	if (copy_to_user(useraddr + offsetof(struct ethtool_rxfh, rss_context),
 			 &rxfh.rss_context, sizeof(rxfh.rss_context)))
@@ -1378,12 +1421,8 @@ static noinline_for_stack int ethtool_set_rxfh(struct net_device *dev,
 			dev->priv_flags |= IFF_RXFH_CONFIGURED;
 	}
 	/* Update rss_ctx tracking */
-	if (create) {
-		/* Ideally this should happen before calling the driver,
-		 * so that we can fail more cleanly; but we don't have the
-		 * context ID until the driver picks it, so we have to
-		 * wait until after.
-		 */
+	if (create && !ops->create_rxfh_context) {
+		/* driver uses old API, it chose context ID */
 		if (WARN_ON(idr_find(&dev->ethtool->rss_ctx, rxfh.rss_context)))
 			/* context ID reused, our tracking is screwed */
 			goto out;
@@ -1391,8 +1430,6 @@ static noinline_for_stack int ethtool_set_rxfh(struct net_device *dev,
 		WARN_ON(idr_alloc(&dev->ethtool->rss_ctx, ctx, rxfh.rss_context,
 				  rxfh.rss_context + 1, GFP_KERNEL) !=
 			rxfh.rss_context);
-		ctx->indir_no_change = rxfh.indir_size == ETH_RXFH_INDIR_NO_CHANGE;
-		ctx->key_no_change = !rxfh.key_size;
 	}
 	if (delete) {
 		WARN_ON(idr_remove(&dev->ethtool->rss_ctx, rxfh.rss_context) != ctx);
