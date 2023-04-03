Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D12E6D4E10
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 18:37:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232892AbjDCQhB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 12:37:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232868AbjDCQg6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 12:36:58 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2088.outbound.protection.outlook.com [40.107.93.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F23D2685
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 09:36:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fdouRGaw0oDPvU0N7Ih6MLR2iWuhPuOgtQybG8UsJaByjK5hKQPdmA5Bg1Y3w8AECmkA6MGqANky9nNyaBy2xeTgGyDC0zTxo6dmSAMu7vbaKGBfdDmgguopSxR0R/BkJR/IMjyiuA2j2g1eRDIbUmDZ5IADLx1UfuKj8oSGAN7duHNlXXJLuznjl2l3jGLvLHBInk+tROdDjh5Xx+WCCe+9FqGHlnfnW5TGtB8dJvq3Y/AuKfimkohuZ7oPmgHPs0gAljiPhE7WQm8PO9b1Yojq1YE6NkOJib9CqPHsYOjyGfKDWi2A8s57376q1kIp18XwFAQxUKhL18uqtQVBRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PN0LwE98y7mMw2rBzGa3RFPO9yDXJM+RbaiDtLOz16Q=;
 b=UedXP5gjKpkGJ2TuuCva0JHqc2mjrn+pjAN7zAqZIRv2ap3bn6niD5YFVUEOlzOMvBMG/BkzadO9f+/i0ulr3673GuVjniGY5Ndu/zm+7Xz7JPIIIHC29tia7F7a5Z6Vv+zCMkf9yFNVqODlGyNE62uHowUl7MoEoun1gkft0VZIGhILkMFLgOqt+w7N7txNL7tkLAX6H+10ug+2uaIp/9klHCz8IucxNfTUJckFKYQCi8fAlHd/4NtsI68MCDl9oe0ypbaBDtDPDXogu184jgzK6duoUrWHs72ClS2k+TH4eVJu315oCYaWdkhpxvPssiPnMFzh+VvSpdnxKxddDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PN0LwE98y7mMw2rBzGa3RFPO9yDXJM+RbaiDtLOz16Q=;
 b=nFvOE/FdvPNUS2W5sV67ZKTK0a2yiXKEXNXWyJF5FSpAD1itpI4lz/SOsIn2qnLZq52J3r8ll6MFx3znrg0u7oLIofAaHAG7ce/vnk1KtKPRhfp7ut1WLwDs4kM5DLpPLQooumpNp78dzW8ladtphYfBh46QtmuK3CIFjXxEolc=
Received: from MW2PR16CA0015.namprd16.prod.outlook.com (2603:10b6:907::28) by
 SA3PR12MB7829.namprd12.prod.outlook.com (2603:10b6:806:316::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.30; Mon, 3 Apr
 2023 16:36:52 +0000
Received: from CO1NAM11FT059.eop-nam11.prod.protection.outlook.com
 (2603:10b6:907:0:cafe::7b) by MW2PR16CA0015.outlook.office365.com
 (2603:10b6:907::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.20 via Frontend
 Transport; Mon, 3 Apr 2023 16:36:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT059.mail.protection.outlook.com (10.13.174.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6254.23 via Frontend Transport; Mon, 3 Apr 2023 16:36:51 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 3 Apr
 2023 11:36:50 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 3 Apr
 2023 11:36:50 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34 via Frontend
 Transport; Mon, 3 Apr 2023 11:36:49 -0500
From:   <edward.cree@amd.com>
To:     <linux-net-drivers@amd.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@google.com>
CC:     Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>,
        <habetsm.xilinx@gmail.com>, <sudheer.mogilappagari@intel.com>
Subject: [RFC PATCH net-next 2/6] net: ethtool: record custom RSS contexts in the IDR
Date:   Mon, 3 Apr 2023 17:32:59 +0100
Message-ID: <57c0a5a7d41e1341e8a7b0256ca8ed6f3e3ea9c0.1680538846.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1680538846.git.ecree.xilinx@gmail.com>
References: <cover.1680538846.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT059:EE_|SA3PR12MB7829:EE_
X-MS-Office365-Filtering-Correlation-Id: 60af0c0c-e4f7-49b7-63c6-08db3461a0e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xoiLn1EjFDVsuSlmSK/APRKqxvNUDke5xyViHJEqRc2O1rxeu+hpZtY8Oc3Kz0nkgvkStI0jrnIfLTCObKsJVQ5s9XDkH8T99bT0+4BK/VcAZH5udfwWS0VZuQIH7rMOJvh/jCk7r9UKDG89LT/OfQBRzLFiwrY2QvSNUfjwN0pgeevLMX4tW6Cjy/1/CL36C548xcORq09dc7AZ5AR42VT829yPhlqwInOVC0J2xc9/AifNWZ7DulTU+BGBKFk4XDlxE2Fdy4Tg3BC0uil8xK5EOG8hW/NbCWPjE25TVbq+mFQIDT1pJEvn3CJwMJWCJiY0W2pMi+v5lnU2nyA2MwOxPrgs0VsBO7Fl7EOWf9zHvlPOKSjO9P6C9lt47+8EzHcMCPc+d8RwNzNAPcwSt4+e+QMdcwvLchvayrPgT85A/3NNPvy9u3vODbLfwvUFxDT4EBckIfrCJGJbCaR+ZpXqKdbD1S24vKazQTzxnlRqssNW875kGLQyviQCcQFs9js5r6wLNOqfqGZKppAZVaMSLVwdjqDuV0ualOf0SNmrprKuYRgL3ljuAfT4K4O+39lYG5Pp7lY/p/AV89Hfy70oeHhZAquFPbadqgFW7BpfrX+I4DZ3rvBBM063BssK2t3thz7kilJvAYiMA8sQjv+sJkoBpdPh5JvO/Mi2C/WO9ezT/ibZphaLp4h0ZrSFhrwN5XqE+a6Tyupjt4LlltHCepPmsaVZF5cW9H8HITk=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(396003)(39860400002)(376002)(451199021)(46966006)(36840700001)(40470700004)(40460700003)(26005)(186003)(9686003)(6666004)(47076005)(8936002)(336012)(426003)(5660300002)(83380400001)(4326008)(41300700001)(70586007)(8676002)(70206006)(2906002)(478600001)(316002)(110136005)(54906003)(2876002)(36756003)(40480700001)(82740400003)(82310400005)(81166007)(36860700001)(55446002)(86362001)(356005)(66899021)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2023 16:36:51.7354
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 60af0c0c-e4f7-49b7-63c6-08db3461a0e5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT059.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7829
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
 include/linux/ethtool.h | 17 +++++++++++
 net/ethtool/ioctl.c     | 67 +++++++++++++++++++++++++++++++++++++++--
 2 files changed, 82 insertions(+), 2 deletions(-)

diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 1898f4446666..a16580a8e9d7 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -163,12 +163,16 @@ static inline u32 ethtool_rxfh_indir_default(u32 index, u32 n_rx_rings)
  * @key_size: Size of hash key, in bytes
  * @hfunc: RSS hash function identifier.  One of the %ETH_RSS_HASH_*
  * @priv_size: Size of driver private data, in bytes
+ * @indir_no_change: indir was not specified at create time
+ * @key_no_change: hkey was not specified at create time
  */
 struct ethtool_rxfh_context {
 	u32 indir_size;
 	u32 key_size;
 	u8 hfunc;
 	u16 priv_size;
+	u8 indir_no_change:1;
+	u8 key_no_change:1;
 	/* private: indirection table, hash key, and driver private data are
 	 * stored sequentially in @data area.  Use below helpers to access
 	 */
@@ -190,6 +194,16 @@ static inline void *ethtool_rxfh_context_priv(struct ethtool_rxfh_context *ctx)
 	return ethtool_rxfh_context_key(ctx) + ctx->key_size;
 }
 
+static inline size_t ethtool_rxfh_context_size(u32 indir_size, u32 key_size,
+					       u16 priv_size)
+{
+	size_t indir_bytes = array_size(indir_size, sizeof(u32));
+	size_t flex_len;
+
+	flex_len = size_add(size_add(indir_bytes, key_size), priv_size);
+	return struct_size((struct ethtool_rxfh_context *)0, data, flex_len);
+}
+
 /* declare a link mode bitmap */
 #define __ETHTOOL_DECLARE_LINK_MODE_MASK(name)		\
 	DECLARE_BITMAP(name, __ETHTOOL_LINK_MODE_MASK_NBITS)
@@ -727,6 +741,8 @@ struct ethtool_mm_stats {
  *	will remain unchanged.
  *	Returns a negative error code or zero. An error code must be returned
  *	if at least one unsupported change was requested.
+ * @get_rxfh_priv_size: Get the size of the driver private data area the
+ *	core should allocate for an RSS context.
  * @get_rxfh_context: Get the contents of the RX flow hash indirection table,
  *	hash key, and/or hash function assiciated to the given rss context.
  *	Returns a negative error code or zero.
@@ -880,6 +896,7 @@ struct ethtool_ops {
 			    u8 *hfunc);
 	int	(*set_rxfh)(struct net_device *, const u32 *indir,
 			    const u8 *key, const u8 hfunc);
+	u16	(*get_rxfh_priv_size)(struct net_device *);
 	int	(*get_rxfh_context)(struct net_device *, u32 *indir, u8 *key,
 				    u8 *hfunc, u32 rss_context);
 	int	(*set_rxfh_context)(struct net_device *, const u32 *indir,
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 59adc4e6e9ee..c8f11ac343c9 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -1248,14 +1248,15 @@ static noinline_for_stack int ethtool_set_rxfh(struct net_device *dev,
 {
 	int ret;
 	const struct ethtool_ops *ops = dev->ethtool_ops;
+	struct ethtool_rxfh_context *ctx;
 	struct ethtool_rxnfc rx_rings;
 	struct ethtool_rxfh rxfh;
-	u32 dev_indir_size = 0, dev_key_size = 0, i;
+	u32 dev_indir_size = 0, dev_key_size = 0, dev_priv_size = 0, i;
 	u32 *indir = NULL, indir_bytes = 0;
 	u8 *hkey = NULL;
 	u8 *rss_config;
 	u32 rss_cfg_offset = offsetof(struct ethtool_rxfh, rss_config[0]);
-	bool delete = false;
+	bool create = false, delete = false;
 
 	if (!ops->get_rxnfc || !ops->set_rxfh)
 		return -EOPNOTSUPP;
@@ -1274,6 +1275,9 @@ static noinline_for_stack int ethtool_set_rxfh(struct net_device *dev,
 	/* Most drivers don't handle rss_context, check it's 0 as well */
 	if (rxfh.rss_context && !ops->set_rxfh_context)
 		return -EOPNOTSUPP;
+	create = rxfh.rss_context == ETH_RXFH_CONTEXT_ALLOC;
+	if (create && ops->get_rxfh_priv_size)
+		dev_priv_size = ops->get_rxfh_priv_size(dev);
 
 	/* If either indir, hash key or function is valid, proceed further.
 	 * Must request at least one change: indir size, hash key or function.
@@ -1331,6 +1335,31 @@ static noinline_for_stack int ethtool_set_rxfh(struct net_device *dev,
 		}
 	}
 
+	if (create) {
+		if (delete) {
+			ret = -EINVAL;
+			goto out;
+		}
+		ctx = kzalloc(ethtool_rxfh_context_size(dev_indir_size,
+							dev_key_size,
+							dev_priv_size),
+			      GFP_USER);
+		if (!ctx) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		ctx->indir_size = dev_indir_size;
+		ctx->key_size = dev_key_size;
+		ctx->hfunc = rxfh.hfunc;
+		ctx->priv_size = dev_priv_size;
+	} else if (rxfh.rss_context) {
+		ctx = idr_find(&dev->rss_ctx, rxfh.rss_context);
+		if (!ctx) {
+			ret = -ENOENT;
+			goto out;
+		}
+	}
+
 	if (rxfh.rss_context)
 		ret = ops->set_rxfh_context(dev, indir, hkey, rxfh.hfunc,
 					    &rxfh.rss_context, delete);
@@ -1350,6 +1379,40 @@ static noinline_for_stack int ethtool_set_rxfh(struct net_device *dev,
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
+		if (WARN_ON(idr_find(&dev->rss_ctx, rxfh.rss_context)))
+			/* context ID reused, our tracking is screwed */
+			goto out;
+		/* Allocate the exact ID the driver gave us */
+		WARN_ON(idr_alloc(&dev->rss_ctx, ctx, rxfh.rss_context,
+				  rxfh.rss_context + 1, GFP_KERNEL) !=
+			rxfh.rss_context);
+		ctx->indir_no_change = rxfh.indir_size == ETH_RXFH_INDIR_NO_CHANGE;
+		ctx->key_no_change = !rxfh.key_size;
+	}
+	if (delete) {
+		WARN_ON(idr_remove(&dev->rss_ctx, rxfh.rss_context) != ctx);
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
