Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F78B6DE3DA
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 20:27:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbjDKS1b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 14:27:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbjDKS12 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 14:27:28 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2047.outbound.protection.outlook.com [40.107.243.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9742A49D9
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 11:27:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FDz65rvp1wkTaCeyhso3uLoRyClLjpyL+JIQhl9MIX5fUw11FHHvTlLUZOXRLQFjZ3vA7oP1EkpyVZTsWUjPqTLB9qCSsTbAPnPIdepJA2JOV2zyMJu1lAx8zZ+bBnSMq9tM1fYb+977PH+xryrrTRMS6PrvwOJRH0Jau2T9zrzVBwJ/Vnqb2pKCzxpGX4MOvuGE1eZOmryjaJ1ItFaVcnwgZr05D+9OscIZ2Z3PSjwBPg/1JO6mQtd1glvUTufsOM2gqSc9d7FJfU6S6cfzHaDkAZzvkrXtGpNmn1tlub5oG0VtO65+SMQMbIfEITKNE6YU7a5gw7Spaqo3VrZRwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2949q2wLINYOobl+HBI8JH+IUqsG5i7m2stVCoviBnA=;
 b=oegbaaYO1Ms5+3y0N7BHw76R0OwxAq+XXUoMPV+D+n+L0HqX5BiEJhVDZlPUR8yQbXhc4tgw7RHci1i8IApl8FX8a6pWxAzhH/4bSbtKHqqDxw3/fr5syjIV977/Hg8IGw1DgTCvV9pg4apebAS5F48Czoq1LqVt/J57ZU4AnUQhzs7w0FaM1edTo0TU+hYXc/2qbKaE4HuOHKri0tgQlWBE0GLIWR9XHY0QrNfwgqVbsX+E2v8y3FE63YbTk4xnA0efZw5+d+tlGFI8XjONV/DGw9Dds3DZmZf20rZqiVyyz120wHw9bpMPHvfmJyCShqBnq8gcw9aAjG2x1LBdhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2949q2wLINYOobl+HBI8JH+IUqsG5i7m2stVCoviBnA=;
 b=l4cXWugCi9tRlbz6vN7IGx+HZkr2fbB3QxOtqnj0bqgIxadzNkwv/0FK9khq+NwP5hvISkErAj+rsjsGX0H6w37UlqgGzw12A2if1c/BevmjK/IFjP93OtbDCmJqbx0XmGBV9PixARmfRMv3UBC7/IH/LwUDgaH8XVDZiUiZ+jo=
Received: from DM6PR12CA0027.namprd12.prod.outlook.com (2603:10b6:5:1c0::40)
 by SA0PR12MB4575.namprd12.prod.outlook.com (2603:10b6:806:73::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Tue, 11 Apr
 2023 18:27:25 +0000
Received: from DM6NAM11FT097.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1c0:cafe::b6) by DM6PR12CA0027.outlook.office365.com
 (2603:10b6:5:1c0::40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.40 via Frontend
 Transport; Tue, 11 Apr 2023 18:27:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT097.mail.protection.outlook.com (10.13.172.72) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6298.28 via Frontend Transport; Tue, 11 Apr 2023 18:27:24 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 11 Apr
 2023 13:27:24 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34 via Frontend
 Transport; Tue, 11 Apr 2023 13:27:22 -0500
From:   <edward.cree@amd.com>
To:     <linux-net-drivers@amd.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@google.com>
CC:     Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>,
        <habetsm.xilinx@gmail.com>, <sudheer.mogilappagari@intel.com>
Subject: [RFC PATCH v2 net-next 2/7] net: ethtool: attach an IDR of custom RSS contexts to a netdevice
Date:   Tue, 11 Apr 2023 19:26:10 +0100
Message-ID: <16030cc69a6726cda461290a3d6bed9c48db7562.1681236653.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1681236653.git.ecree.xilinx@gmail.com>
References: <cover.1681236653.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT097:EE_|SA0PR12MB4575:EE_
X-MS-Office365-Filtering-Correlation-Id: 98293fed-55fa-4ec5-e900-08db3aba65b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v31CSErIU2rn+6D1kUPoML/dqNrhKwS6JVoldrd9j8c9xfdoQuABw/6CcR7Y9+2l2PZC7PyYLGDpY1F7nl/wgiZN1oOw26KGWcs+qUp5RchYD7OjuPa7RJugei5H1mL5QBU2fSsvfVCKqdEhTnwQWTpqaW0SBpiiaXBMjHcnCfMRUqEHyb2HCHURWnRTeHRxwbZv3azEQYYBJGi1K25IkitG6Yz6SkubL9/P7u5IpxL8qD8sdqiKh4qbHhnUhQU3Pgv3Uds65/QMZzmz1Dvjv1h4EBrH+oIEGq2O/G1LnOJa6SLiBWMkmjqzTWKqwKzeB8CrwjKveVCXdXVpV4cEtP3/tMWzMIXoc/V8HnrVEd3pBYby+2lqs9azM152zSle0rhMnc4CDm/krs/eYUqAM48ti5jp/uhsphmu5SXduHEt3Yuyd7fof/Q2zKP64UFvWuIidxM6wZ067Z707ey3FNdhghhuxwtqpBoP5fFMMazYZxglfnDa98BaI2LQ5fBgV4hQJNO42xfFYfYNHsqhDs9KNwfu3j5Urzay5nK+UGrRlv+RdiLVsffGQzkhmsz04V7tZ9evRVbQlSSMWY1JyD+/j9pKUOEA1G7FNH6O99GgwnUa5d/wlhQRPKJlArKBSQKJySUsIJMORHtsgJgwcxqh+VQrzAD59zuSNZSX2ElHdoCOjITdJtX+Kff3u+flsPONpKasuT5SURAejqdKjqCC4Tq8E6OFurLkWlLD8CU=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(376002)(396003)(39860400002)(451199021)(40470700004)(36840700001)(46966006)(2876002)(40480700001)(5660300002)(41300700001)(6666004)(8936002)(36860700001)(9686003)(26005)(82310400005)(40460700003)(83380400001)(86362001)(316002)(55446002)(82740400003)(186003)(110136005)(8676002)(4326008)(70586007)(70206006)(47076005)(478600001)(2906002)(54906003)(426003)(336012)(36756003)(81166007)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 18:27:24.7155
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 98293fed-55fa-4ec5-e900-08db3aba65b7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT097.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4575
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

Each context stores the RXFH settings (indir, key, and hfunc) as well
 as optionally some driver private data.
Delete any still-existing contexts at netdev unregister time.

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
Changes in v2: fix data area to ensure proper alignment (kuba)
---
 include/linux/ethtool.h | 41 +++++++++++++++++++++++++++++++++++++++++
 net/core/dev.c          | 23 +++++++++++++++++++++++
 2 files changed, 64 insertions(+)

diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index c73b28df301c..7963b06da484 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -157,6 +157,43 @@ static inline u32 ethtool_rxfh_indir_default(u32 index, u32 n_rx_rings)
 	return index % n_rx_rings;
 }
 
+/**
+ * struct ethtool_rxfh_context - a custom RSS context configuration
+ * @indir_size: Number of u32 entries in indirection table
+ * @key_size: Size of hash key, in bytes
+ * @hfunc: RSS hash function identifier.  One of the %ETH_RSS_HASH_*
+ * @priv_size: Size of driver private data, in bytes
+ * @indir_no_change: indir was not specified at create time
+ * @key_no_change: hkey was not specified at create time
+ */
+struct ethtool_rxfh_context {
+	u32 indir_size;
+	u32 key_size;
+	u8 hfunc;
+	u16 priv_size;
+	u8 indir_no_change:1;
+	u8 key_no_change:1;
+	/* private: driver private data, indirection table, and hash key are
+	 * stored sequentially in @data area.  Use below helpers to access.
+	 */
+	u8 data[] __aligned(sizeof(void *));
+};
+
+static inline void *ethtool_rxfh_context_priv(struct ethtool_rxfh_context *ctx)
+{
+	return ctx->data;
+}
+
+static inline u32 *ethtool_rxfh_context_indir(struct ethtool_rxfh_context *ctx)
+{
+	return (u32 *)(ctx->data + ALIGN(ctx->priv_size, sizeof(u32)));
+}
+
+static inline u8 *ethtool_rxfh_context_key(struct ethtool_rxfh_context *ctx)
+{
+	return (u8 *)(ethtool_rxfh_context_indir(ctx) + ctx->indir_size);
+}
+
 /* declare a link mode bitmap */
 #define __ETHTOOL_DECLARE_LINK_MODE_MASK(name)		\
 	DECLARE_BITMAP(name, __ETHTOOL_LINK_MODE_MASK_NBITS)
@@ -936,9 +973,13 @@ int ethtool_virtdev_set_link_ksettings(struct net_device *dev,
 
 /**
  * struct ethtool_netdev_state - per-netdevice state for ethtool features
+ * @rss_ctx_max_id:	maximum (exclusive) supported RSS context ID
+ * @rss_ctx:		IDR storing custom RSS context state
  * @wol_enabled:	Wake-on-LAN is enabled
  */
 struct ethtool_netdev_state {
+	u32			rss_ctx_max_id;
+	struct idr		rss_ctx;
 	unsigned		wol_enabled:1;
 };
 
diff --git a/net/core/dev.c b/net/core/dev.c
index 93960861a11f..c9ed9f6ea695 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9983,6 +9983,9 @@ int register_netdevice(struct net_device *dev)
 	if (ret)
 		return ret;
 
+	/* rss ctx ID 0 is reserved for the default context, start from 1 */
+	idr_init_base(&dev->ethtool->rss_ctx, 1);
+
 	spin_lock_init(&dev->addr_list_lock);
 	netdev_set_addr_lockdep_class(dev);
 
@@ -10781,6 +10784,24 @@ void synchronize_net(void)
 }
 EXPORT_SYMBOL(synchronize_net);
 
+static void netdev_rss_contexts_free(struct net_device *dev)
+{
+	struct ethtool_rxfh_context *ctx;
+	u32 context;
+
+	if (!dev->ethtool_ops->set_rxfh_context)
+		return;
+	idr_for_each_entry(&dev->ethtool->rss_ctx, ctx, context) {
+		u32 *indir = ethtool_rxfh_context_indir(ctx);
+		u8 *key = ethtool_rxfh_context_key(ctx);
+
+		idr_remove(&dev->ethtool->rss_ctx, context);
+		dev->ethtool_ops->set_rxfh_context(dev, indir, key, ctx->hfunc,
+						   &context, true);
+		kfree(ctx);
+	}
+}
+
 /**
  *	unregister_netdevice_queue - remove device from the kernel
  *	@dev: device
@@ -10885,6 +10906,8 @@ void unregister_netdevice_many_notify(struct list_head *head,
 		netdev_name_node_alt_flush(dev);
 		netdev_name_node_free(dev->name_node);
 
+		netdev_rss_contexts_free(dev);
+
 		call_netdevice_notifiers(NETDEV_PRE_UNINIT, dev);
 
 		if (dev->netdev_ops->ndo_uninit)
