Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B19AC6DE3DB
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 20:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbjDKS1d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 14:27:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbjDKS1a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 14:27:30 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2055.outbound.protection.outlook.com [40.107.223.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BFD049E1
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 11:27:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lgobQi2XimdH277628rGbS5IIzNu0vkQ6AxvCnkpGCNFGFfVTg4F9JRTJa2J0fHOj+ZlwclmfEU5rseE/vrS1s8MJ9O5/2vK15bC/xaivOLP7fQkNJX5Hbj7D7Mc3fLhF20DgEkiiEH3/nl3ccEIwcljCZ9ktErlueIUOp8t6ZDXvOKlpY9d0OmGa7FeXwH6zCf9wlYMQLEdC3t+hOO2yQyzbe461rd351Xag/MT84qXwZ7K4noedMFqRYCcW8SDvzI3vxmYGQL+/JE54pC3saKVTkg5133uDd8/rybX00Uryk6/v2eNynsCLIUmtIQT/KqAFqvs0B3RKkHfpXxbDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4wR9Mp9thK4CmINfd1g2lkRpRP7LKZvmnKwUD3A0RbI=;
 b=XVeBHI+lzU9P5l+0i7LmsJ+Ec8EuphKsWF4jadql9UcBcm67mNzBlOER52ARb37wGcXf8xosVvmj8ZFyECg4kMkRjuAULkxfrs/2vnIIuVgYlyQ8UKGFZ4XdfzQ/nt8FeazG2/shlMetIuLXlw3pG3sp8RYAAq3IorpwocABsgscaMP8KpJgkPx3EYX0/HZmsIKhXYvQYBu6B1cTr1zCW8iyPAduRLWftB83Ce1nBvEOJ0B0j3P+6QggIi57IGYd4Dd0FriVSBIKfvUe2ykFfHMhS4W4Q7YKZUe4ioSD6VK9oBf0BH9t3D/FBVgGHBRNoDWDGJZn2/uBxQiptxw4mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4wR9Mp9thK4CmINfd1g2lkRpRP7LKZvmnKwUD3A0RbI=;
 b=cllvroOBSrwrwHm0cK+KYo4FGRtJAD+O0eTqmSL7r/zdZXwADFsQs9/cam0roKOQE+xZ6G0Powon2T0eArgzFGb66IwAkTDgnCpeNVPMTqjzUN12Dmz6v23uZPnTJwzPSlMZSKYOUUB4Gk80Vt9LWwK1AYcHkuRTsIn9Tz109Gs=
Received: from DM6PR08CA0064.namprd08.prod.outlook.com (2603:10b6:5:1e0::38)
 by IA1PR12MB6212.namprd12.prod.outlook.com (2603:10b6:208:3e4::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.33; Tue, 11 Apr
 2023 18:27:26 +0000
Received: from DM6NAM11FT074.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1e0:cafe::1a) by DM6PR08CA0064.outlook.office365.com
 (2603:10b6:5:1e0::38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.40 via Frontend
 Transport; Tue, 11 Apr 2023 18:27:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT074.mail.protection.outlook.com (10.13.173.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6298.29 via Frontend Transport; Tue, 11 Apr 2023 18:27:26 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 11 Apr
 2023 13:27:25 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34 via Frontend
 Transport; Tue, 11 Apr 2023 13:27:24 -0500
From:   <edward.cree@amd.com>
To:     <linux-net-drivers@amd.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@google.com>
CC:     Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>,
        <habetsm.xilinx@gmail.com>, <sudheer.mogilappagari@intel.com>
Subject: [RFC PATCH v2 net-next 3/7] net: ethtool: record custom RSS contexts in the IDR
Date:   Tue, 11 Apr 2023 19:26:11 +0100
Message-ID: <5ac2860f8936b95cf873b6dcfd624c530a83ff2d.1681236653.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1681236653.git.ecree.xilinx@gmail.com>
References: <cover.1681236653.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT074:EE_|IA1PR12MB6212:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ff4224f-c55c-4f1c-8062-08db3aba6684
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vA3hTHOI1hHK24y93N+y0POUYzqxyx/80aYgNa8GfZD5xpcf1x0FcM95+IQBGfFDVXT4CFiXN6d9tPLswF/mH1gqDNq16JRN+wq5PF9OGwh/yQxRvAcH5n8zHB9Mkp7XCziBwWZmX+0jn/bBk4IhSm4mDIm0kE9YznqfmG/j6ZpL7CVJm7qJTexjM9fK/0I/+bYq/bX6z/02bklbs9hRIBIvcLKFbLXCOsR9A/NR062qTrz/YTQ2BR2KpT68eIyvvNjPNJOHPYZARlpuJ6kbmWXJYmS1GIebTaq0PVmOaYxKSiMFTZT9BUrD9D5AhEWPE5HXaTFDdWWMH3KeGjmMTWFpMWW10XiCTWTD8h+WWCy3igcCfcuIrHfzCfA5Z5e5lpB3MG2wB5EVagfGJW/2GLKLk91feHnCRLaMOzzWcyAQ3graxAdFL68a2ODsjRYe/fyQ6WGvahe9MMjCEST8gFk4iS5pgVEl85C4cPC9A3mxqKNAJs1b80R+wrgyFjSIapLFgO1vYvz49n6i+q8jFXYmAvZicqmtHziaCx5Eyj8X04T7Rg/2cAf3F2H6nYnDb+EOoR3JW8gQDgqJB+psXbbx30qjrAwAvRcrao6z22CzfA80KUcKSa7i5acXoTE5wKiZF4/YGYbB5U912QJF7bo4tNE4VNU0ut4/AdGGiUxH2adu6Asgvvk2hk/KfY4/Oi/LDzeTC54I4/tDl0ECi9C/gMoDHkhxgzslMTP/K+w=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(39860400002)(346002)(396003)(451199021)(40470700004)(46966006)(36840700001)(4326008)(8676002)(478600001)(8936002)(36860700001)(6666004)(316002)(66899021)(82740400003)(41300700001)(40480700001)(70206006)(70586007)(110136005)(54906003)(81166007)(356005)(55446002)(186003)(2906002)(47076005)(2876002)(336012)(26005)(426003)(82310400005)(83380400001)(86362001)(36756003)(9686003)(5660300002)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 18:27:26.0563
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ff4224f-c55c-4f1c-8062-08db3aba6684
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT074.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6212
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

Since drivers are still choosing the context IDs, we have to force the
 IDR to use the ID they've chosen rather than picking one ourselves.

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
Changes in v2:
* change .get_rxfh_priv_size op into rxfh_priv_size value member (kuba)
* use GFP_KERNEL_ACCOUNT rather than GFP_USER (kuba)
* adjust size calculation to allow for alignment padding from patch #2
---
 include/linux/ethtool.h | 14 +++++++++
 net/ethtool/ioctl.c     | 63 ++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 76 insertions(+), 1 deletion(-)

diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 7963b06da484..710d6a985347 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -194,6 +194,17 @@ static inline u8 *ethtool_rxfh_context_key(struct ethtool_rxfh_context *ctx)
 	return (u8 *)(ethtool_rxfh_context_indir(ctx) + ctx->indir_size);
 }
 
+static inline size_t ethtool_rxfh_context_size(u32 indir_size, u32 key_size,
+					       u16 priv_size)
+{
+	size_t indir_bytes = array_size(indir_size, sizeof(u32));
+	size_t flex_len;
+
+	flex_len = size_add(size_add(indir_bytes, key_size),
+			    ALIGN(priv_size, sizeof(u32)));
+	return struct_size((struct ethtool_rxfh_context *)0, data, flex_len);
+}
+
 /* declare a link mode bitmap */
 #define __ETHTOOL_DECLARE_LINK_MODE_MASK(name)		\
 	DECLARE_BITMAP(name, __ETHTOOL_LINK_MODE_MASK_NBITS)
@@ -731,6 +742,8 @@ struct ethtool_mm_stats {
  *	will remain unchanged.
  *	Returns a negative error code or zero. An error code must be returned
  *	if at least one unsupported change was requested.
+ * @rxfh_priv_size: size of the driver private data area the core should
+ *	allocate for an RSS context.
  * @get_rxfh_context: Get the contents of the RX flow hash indirection table,
  *	hash key, and/or hash function assiciated to the given rss context.
  *	Returns a negative error code or zero.
@@ -823,6 +836,7 @@ struct ethtool_ops {
 	u32     cap_link_lanes_supported:1;
 	u32	supported_coalesce_params;
 	u32	supported_ring_params;
+	u16	rxfh_priv_size;
 	void	(*get_drvinfo)(struct net_device *, struct ethtool_drvinfo *);
 	int	(*get_regs_len)(struct net_device *);
 	void	(*get_regs)(struct net_device *, struct ethtool_regs *, void *);
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 0effaca4ff9e..9f9f8ba9c0f6 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -1248,6 +1248,7 @@ static noinline_for_stack int ethtool_set_rxfh(struct net_device *dev,
 {
 	int ret;
 	const struct ethtool_ops *ops = dev->ethtool_ops;
+	struct ethtool_rxfh_context *ctx = NULL;
 	struct ethtool_rxnfc rx_rings;
 	struct ethtool_rxfh rxfh;
 	u32 dev_indir_size = 0, dev_key_size = 0, i;
@@ -1255,7 +1256,7 @@ static noinline_for_stack int ethtool_set_rxfh(struct net_device *dev,
 	u8 *hkey = NULL;
 	u8 *rss_config;
 	u32 rss_cfg_offset = offsetof(struct ethtool_rxfh, rss_config[0]);
-	bool delete = false;
+	bool create = false, delete = false;
 
 	if (!ops->get_rxnfc || !ops->set_rxfh)
 		return -EOPNOTSUPP;
@@ -1274,6 +1275,7 @@ static noinline_for_stack int ethtool_set_rxfh(struct net_device *dev,
 	/* Most drivers don't handle rss_context, check it's 0 as well */
 	if (rxfh.rss_context && !ops->set_rxfh_context)
 		return -EOPNOTSUPP;
+	create = rxfh.rss_context == ETH_RXFH_CONTEXT_ALLOC;
 
 	/* If either indir, hash key or function is valid, proceed further.
 	 * Must request at least one change: indir size, hash key or function.
@@ -1331,6 +1333,31 @@ static noinline_for_stack int ethtool_set_rxfh(struct net_device *dev,
 		}
 	}
 
+	if (create) {
+		if (delete) {
+			ret = -EINVAL;
+			goto out;
+		}
+		ctx = kzalloc(ethtool_rxfh_context_size(dev_indir_size,
+							dev_key_size,
+							ops->rxfh_priv_size),
+			      GFP_KERNEL_ACCOUNT);
+		if (!ctx) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		ctx->indir_size = dev_indir_size;
+		ctx->key_size = dev_key_size;
+		ctx->hfunc = rxfh.hfunc;
+		ctx->priv_size = ops->rxfh_priv_size;
+	} else if (rxfh.rss_context) {
+		ctx = idr_find(&dev->ethtool->rss_ctx, rxfh.rss_context);
+		if (!ctx) {
+			ret = -ENOENT;
+			goto out;
+		}
+	}
+
 	if (rxfh.rss_context)
 		ret = ops->set_rxfh_context(dev, indir, hkey, rxfh.hfunc,
 					    &rxfh.rss_context, delete);
@@ -1350,6 +1377,40 @@ static noinline_for_stack int ethtool_set_rxfh(struct net_device *dev,
 		else if (rxfh.indir_size != ETH_RXFH_INDIR_NO_CHANGE)
 			dev->priv_flags |= IFF_RXFH_CONFIGURED;
 	}
+	/* Update rss_ctx tracking */
+	if (create) {
+		/* Ideally this should happen before calling the driver,
+		 * so that we can fail more cleanly; but we don't have the
+		 * context ID until the driver picks it, so we have to
+		 * wait until after.
+		 */
+		if (WARN_ON(idr_find(&dev->ethtool->rss_ctx, rxfh.rss_context)))
+			/* context ID reused, our tracking is screwed */
+			goto out;
+		/* Allocate the exact ID the driver gave us */
+		WARN_ON(idr_alloc(&dev->ethtool->rss_ctx, ctx, rxfh.rss_context,
+				  rxfh.rss_context + 1, GFP_KERNEL) !=
+			rxfh.rss_context);
+		ctx->indir_no_change = rxfh.indir_size == ETH_RXFH_INDIR_NO_CHANGE;
+		ctx->key_no_change = !rxfh.key_size;
+	}
+	if (delete) {
+		WARN_ON(idr_remove(&dev->ethtool->rss_ctx, rxfh.rss_context) != ctx);
+		kfree(ctx);
+	} else if (ctx) {
+		if (indir) {
+			for (i = 0; i < dev_indir_size; i++)
+				ethtool_rxfh_context_indir(ctx)[i] = indir[i];
+			ctx->indir_no_change = 0;
+		}
+		if (hkey) {
+			memcpy(ethtool_rxfh_context_key(ctx), hkey,
+			       dev_key_size);
+			ctx->key_no_change = 0;
+		}
+		if (rxfh.hfunc != ETH_RSS_HASH_NO_CHANGE)
+			ctx->hfunc = rxfh.hfunc;
+	}
 
 out:
 	kfree(rss_config);
