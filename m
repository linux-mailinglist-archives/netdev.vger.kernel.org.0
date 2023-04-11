Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B80C26DE3E2
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 20:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbjDKS2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 14:28:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbjDKS1u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 14:27:50 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2040.outbound.protection.outlook.com [40.107.92.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4A9465AC
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 11:27:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i8AxnfKQV2/zjO2YQQfCPUu1gx/ooo2UHhOIt58iHJFK+C74L3zocnrlb0imBqV6kbIY9u8jMQC3noYuqbDLw//wXIpMqjUcwsXQdDd+uskg+G8sXQwb04uz9N7H7hZP66CUIxeQuoXj83YzJWOxIiLpe2WreHJalrMHgpJ618oOtrJo7sEFm4lfVur0B7ywOgtJG3T61fEJ8N0moGSqbwfV0EFOgUBNnU30FVAt8nbvzGCUJQrVHfhMw+v7f9xdtMkvllERVFMOf1HIW3quZdAXq7EdSKv2cdf9huMtKD86vdqY0+JJD+WXuS3SAcDDgx8bzVIsJe37f+Qo2YZisA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A6uToltu6rrNo1V7hFaBNFhYGjVwHF6PEcFpJIWvqPM=;
 b=kQdFTNbIjSaqE6T/7dc5QXuTIQ2KkFr7NX9k6gFgVM+B8i7VIxmGpz0JgPVIFSRjxvmztrFH6mkU1qFF7OiX7H4mcIUE8OnLzVQ7lyQyXcmLyhqYIsju6gc9WtfRLMzBQkCxHvpewc4XrSktm+iaI7aAr4fIPo7IwgK+KDJvp+RNPJ6PNFd7KNS0pVu2FkT/CuQNQFddCRmq7Zy+uQmSqaABnotcJakm6d5e3UaO4uExHCG+XTIbrx1C3jJZX0R0ZWP4IQbAGIVVHQyNxAYBmp1X5GVgULFDeoQ3GyQWLF/+GDbtL9bAV/vo/4kdhpsqr2tlF5VzAcCl+OaxBMsjRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A6uToltu6rrNo1V7hFaBNFhYGjVwHF6PEcFpJIWvqPM=;
 b=pg1vCA1OlkVOPl/hAq0qiVcMLD5UVDdd3OuIPlCpPv5236iM6gSRyTMiNbHLxwLT7OHcULznDavNlcnb8kjEg0eZ05Xb7uZJ0LKIZwjk9Lv67oNbAISjP7KZ8YL0Rllvos5yXAI4GAVM2WP+rYkSOGpXSNHaZl3R3dDE51MZtXI=
Received: from MW4PR04CA0216.namprd04.prod.outlook.com (2603:10b6:303:87::11)
 by DS0PR12MB8344.namprd12.prod.outlook.com (2603:10b6:8:fe::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6277.38; Tue, 11 Apr 2023 18:27:35 +0000
Received: from CO1NAM11FT005.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:87:cafe::b9) by MW4PR04CA0216.outlook.office365.com
 (2603:10b6:303:87::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38 via Frontend
 Transport; Tue, 11 Apr 2023 18:27:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT005.mail.protection.outlook.com (10.13.174.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6298.29 via Frontend Transport; Tue, 11 Apr 2023 18:27:34 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 11 Apr
 2023 13:27:30 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34 via Frontend
 Transport; Tue, 11 Apr 2023 13:27:29 -0500
From:   <edward.cree@amd.com>
To:     <linux-net-drivers@amd.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@google.com>
CC:     Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>,
        <habetsm.xilinx@gmail.com>, <sudheer.mogilappagari@intel.com>
Subject: [RFC PATCH v2 net-next 7/7] sfc: use new rxfh_context API
Date:   Tue, 11 Apr 2023 19:26:15 +0100
Message-ID: <4a731b911e037b9efa742ad946c76e837372aed6.1681236654.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1681236653.git.ecree.xilinx@gmail.com>
References: <cover.1681236653.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT005:EE_|DS0PR12MB8344:EE_
X-MS-Office365-Filtering-Correlation-Id: 1bd9aaad-6ae4-4ee2-4461-08db3aba6b53
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n0TfNxRSh5M3EC9kT3QA4Zf1o3kY83qwkogorWicK6x36nS76Vi2Jj85J4uSv0g03cRfNgvjL/eoOnqr+x/MyMGijSTzrgyHvfzDVEqr0Vd66BIMdjOWiKpwmmTDhaUH3ya7kmHtap5wmUNsKNJaGdBrKSbL75748TBKGBFIP+QYg4yyQ8S/UvGViUUq9H7G9TUBVhe2MNP8iC7dkKV4hgS+9fVefPCDxo+X5aqjKsonu8T0mBd8lIajMzmC19sVWyZ06JGD1ADTwECUD1yoe9cZCV2AsvpzWgO55e21qjG3XY/wcuPxCQohemzmQxbkGqJkT//8JU9ARpEWVyxwFBdGHwGleMi+v/UF+2/nK+SKGGuzbHiyBLKEBHu721WU2uhNqYhMHpVG0nwnPaGuNFyJiI1Pc8Il3xImBHfKNucMXeu9EXMNDxuRyF0BstSM16YFJeIcirIWYeENl1xwSBqUXCbnmDmhUwjK6XyvP8Q3oow2CicOR9xjtgf7QUO7hiyNOFJDaYJsQgv8gtB7+XitKo0RPiD4Bi5IJLtybWNrh0Ie26BQaWnZqVEIXLMArIP1eyeWUnVMaYtxEdIGHRmLkscKl3hhfvwoGcjLV9s942AgktMN3S1jQeL0W3hAgYFT4mJLB6D5HfttR/43mkc26vyYX9aB4IcddLmPQsXGLWYxx9n6NXItFiBHo75vmTLismAmfiJmIok9SLhZ3AAEU1V6KAlRDCo+0BSfUAs=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(346002)(136003)(39860400002)(451199021)(40470700004)(36840700001)(46966006)(478600001)(316002)(110136005)(26005)(54906003)(9686003)(186003)(5660300002)(6666004)(30864003)(2876002)(2906002)(70206006)(70586007)(4326008)(41300700001)(8676002)(8936002)(82310400005)(356005)(81166007)(82740400003)(40460700003)(40480700001)(47076005)(55446002)(83380400001)(36756003)(336012)(36860700001)(426003)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 18:27:34.0285
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bd9aaad-6ae4-4ee2-4461-08db3aba6b53
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT005.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8344
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

The core is now responsible for allocating IDs and a memory region for
 us to store our state (struct efx_rss_context_priv), so we no longer
 need efx_alloc_rss_context_entry() and friends.
Since the contexts are now maintained by the core, use the core's lock
 (net_dev->ethtool->rss_lock), rather than our own mutex (efx->rss_lock),
 to serialise access against changes; and remove the now-unused
 efx->rss_lock from struct efx_nic.

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
Changes in v2:
* actually hook up rxfh_priv_size in ethtool ops structs
* port to the updated API
---
 drivers/net/ethernet/sfc/ef10.c           |   2 +-
 drivers/net/ethernet/sfc/ef100_ethtool.c  |   5 +-
 drivers/net/ethernet/sfc/efx.c            |   2 +-
 drivers/net/ethernet/sfc/efx.h            |   2 +-
 drivers/net/ethernet/sfc/efx_common.c     |  10 +-
 drivers/net/ethernet/sfc/ethtool.c        |   5 +-
 drivers/net/ethernet/sfc/ethtool_common.c | 147 +++++++++++++---------
 drivers/net/ethernet/sfc/ethtool_common.h |  18 ++-
 drivers/net/ethernet/sfc/mcdi_filters.c   | 133 ++++++++++----------
 drivers/net/ethernet/sfc/mcdi_filters.h   |   8 +-
 drivers/net/ethernet/sfc/net_driver.h     |  28 ++---
 drivers/net/ethernet/sfc/rx_common.c      |  64 ++--------
 drivers/net/ethernet/sfc/rx_common.h      |   8 +-
 13 files changed, 213 insertions(+), 219 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index d30459dbfe8f..6f12fcee8247 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -1394,7 +1394,7 @@ static void efx_ef10_table_reset_mc_allocations(struct efx_nic *efx)
 	efx_mcdi_filter_table_reset_mc_allocations(efx);
 	nic_data->must_restore_piobufs = true;
 	efx_ef10_forget_old_piobufs(efx);
-	efx->rss_context.context_id = EFX_MCDI_RSS_CONTEXT_INVALID;
+	efx->rss_context.priv.context_id = EFX_MCDI_RSS_CONTEXT_INVALID;
 
 	/* Driver-created vswitches and vports must be re-created */
 	nic_data->must_probe_vswitching = true;
diff --git a/drivers/net/ethernet/sfc/ef100_ethtool.c b/drivers/net/ethernet/sfc/ef100_ethtool.c
index 702abbe59b76..c5f82eb0e5b4 100644
--- a/drivers/net/ethernet/sfc/ef100_ethtool.c
+++ b/drivers/net/ethernet/sfc/ef100_ethtool.c
@@ -58,10 +58,13 @@ const struct ethtool_ops ef100_ethtool_ops = {
 
 	.get_rxfh_indir_size	= efx_ethtool_get_rxfh_indir_size,
 	.get_rxfh_key_size	= efx_ethtool_get_rxfh_key_size,
+	.rxfh_priv_size		= sizeof(struct efx_rss_context_priv),
 	.get_rxfh		= efx_ethtool_get_rxfh,
 	.set_rxfh		= efx_ethtool_set_rxfh,
 	.get_rxfh_context	= efx_ethtool_get_rxfh_context,
-	.set_rxfh_context	= efx_ethtool_set_rxfh_context,
+	.create_rxfh_context	= efx_ethtool_create_rxfh_context,
+	.modify_rxfh_context	= efx_ethtool_modify_rxfh_context,
+	.remove_rxfh_context	= efx_ethtool_remove_rxfh_context,
 
 	.get_module_info	= efx_ethtool_get_module_info,
 	.get_module_eeprom	= efx_ethtool_get_module_eeprom,
diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 746fd9164e30..1b2c281c1cc1 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -298,7 +298,7 @@ static int efx_probe_nic(struct efx_nic *efx)
 	if (efx->n_channels > 1)
 		netdev_rss_key_fill(efx->rss_context.rx_hash_key,
 				    sizeof(efx->rss_context.rx_hash_key));
-	efx_set_default_rx_indir_table(efx, &efx->rss_context);
+	efx_set_default_rx_indir_table(efx, efx->rss_context.rx_indir_table);
 
 	/* Initialise the interrupt moderation settings */
 	efx->irq_mod_step_us = DIV_ROUND_UP(efx->timer_quantum_ns, 1000);
diff --git a/drivers/net/ethernet/sfc/efx.h b/drivers/net/ethernet/sfc/efx.h
index 4239c7ece123..a077f648bbde 100644
--- a/drivers/net/ethernet/sfc/efx.h
+++ b/drivers/net/ethernet/sfc/efx.h
@@ -160,7 +160,7 @@ static inline s32 efx_filter_get_rx_ids(struct efx_nic *efx,
 }
 
 /* RSS contexts */
-static inline bool efx_rss_active(struct efx_rss_context *ctx)
+static inline bool efx_rss_active(struct efx_rss_context_priv *ctx)
 {
 	return ctx->context_id != EFX_MCDI_RSS_CONTEXT_INVALID;
 }
diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index cc30524c2fe4..23e3778716b2 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -717,7 +717,7 @@ void efx_reset_down(struct efx_nic *efx, enum reset_type method)
 
 	mutex_lock(&efx->mac_lock);
 	down_write(&efx->filter_sem);
-	mutex_lock(&efx->rss_lock);
+	mutex_lock(&efx->net_dev->ethtool->rss_lock);
 	efx->type->fini(efx);
 }
 
@@ -780,7 +780,7 @@ int efx_reset_up(struct efx_nic *efx, enum reset_type method, bool ok)
 
 	if (efx->type->rx_restore_rss_contexts)
 		efx->type->rx_restore_rss_contexts(efx);
-	mutex_unlock(&efx->rss_lock);
+	mutex_unlock(&efx->net_dev->ethtool->rss_lock);
 	efx->type->filter_table_restore(efx);
 	up_write(&efx->filter_sem);
 	if (efx->type->sriov_reset)
@@ -798,7 +798,7 @@ int efx_reset_up(struct efx_nic *efx, enum reset_type method, bool ok)
 fail:
 	efx->port_initialized = false;
 
-	mutex_unlock(&efx->rss_lock);
+	mutex_unlock(&efx->net_dev->ethtool->rss_lock);
 	up_write(&efx->filter_sem);
 	mutex_unlock(&efx->mac_lock);
 
@@ -1005,9 +1005,7 @@ int efx_init_struct(struct efx_nic *efx, struct pci_dev *pci_dev)
 		efx->type->rx_hash_offset - efx->type->rx_prefix_size;
 	efx->rx_packet_ts_offset =
 		efx->type->rx_ts_offset - efx->type->rx_prefix_size;
-	INIT_LIST_HEAD(&efx->rss_context.list);
-	efx->rss_context.context_id = EFX_MCDI_RSS_CONTEXT_INVALID;
-	mutex_init(&efx->rss_lock);
+	efx->rss_context.priv.context_id = EFX_MCDI_RSS_CONTEXT_INVALID;
 	efx->vport_id = EVB_PORT_ID_ASSIGNED;
 	spin_lock_init(&efx->stats_lock);
 	efx->vi_stride = EFX_DEFAULT_VI_STRIDE;
diff --git a/drivers/net/ethernet/sfc/ethtool.c b/drivers/net/ethernet/sfc/ethtool.c
index 364323599f7b..f5fb7464e025 100644
--- a/drivers/net/ethernet/sfc/ethtool.c
+++ b/drivers/net/ethernet/sfc/ethtool.c
@@ -267,10 +267,13 @@ const struct ethtool_ops efx_ethtool_ops = {
 	.set_rxnfc		= efx_ethtool_set_rxnfc,
 	.get_rxfh_indir_size	= efx_ethtool_get_rxfh_indir_size,
 	.get_rxfh_key_size	= efx_ethtool_get_rxfh_key_size,
+	.rxfh_priv_size		= sizeof(struct efx_rss_context_priv),
 	.get_rxfh		= efx_ethtool_get_rxfh,
 	.set_rxfh		= efx_ethtool_set_rxfh,
 	.get_rxfh_context	= efx_ethtool_get_rxfh_context,
-	.set_rxfh_context	= efx_ethtool_set_rxfh_context,
+	.create_rxfh_context	= efx_ethtool_create_rxfh_context,
+	.modify_rxfh_context	= efx_ethtool_modify_rxfh_context,
+	.remove_rxfh_context	= efx_ethtool_remove_rxfh_context,
 	.get_ts_info		= efx_ethtool_get_ts_info,
 	.get_module_info	= efx_ethtool_get_module_info,
 	.get_module_eeprom	= efx_ethtool_get_module_eeprom,
diff --git a/drivers/net/ethernet/sfc/ethtool_common.c b/drivers/net/ethernet/sfc/ethtool_common.c
index a8cbceeb301b..7cd01012152e 100644
--- a/drivers/net/ethernet/sfc/ethtool_common.c
+++ b/drivers/net/ethernet/sfc/ethtool_common.c
@@ -820,10 +820,10 @@ int efx_ethtool_get_rxnfc(struct net_device *net_dev,
 		return 0;
 
 	case ETHTOOL_GRXFH: {
-		struct efx_rss_context *ctx = &efx->rss_context;
+		struct efx_rss_context_priv *ctx = &efx->rss_context.priv;
 		__u64 data;
 
-		mutex_lock(&efx->rss_lock);
+		mutex_lock(&net_dev->ethtool->rss_lock);
 		if (info->flow_type & FLOW_RSS && info->rss_context) {
 			ctx = efx_find_rss_context_entry(efx, info->rss_context);
 			if (!ctx) {
@@ -864,7 +864,7 @@ int efx_ethtool_get_rxnfc(struct net_device *net_dev,
 out_setdata_unlock:
 		info->data = data;
 out_unlock:
-		mutex_unlock(&efx->rss_lock);
+		mutex_unlock(&net_dev->ethtool->rss_lock);
 		return rc;
 	}
 
@@ -1207,96 +1207,121 @@ int efx_ethtool_get_rxfh_context(struct net_device *net_dev, u32 *indir,
 				 u8 *key, u8 *hfunc, u32 rss_context)
 {
 	struct efx_nic *efx = efx_netdev_priv(net_dev);
-	struct efx_rss_context *ctx;
+	struct efx_rss_context_priv *ctx_priv;
+	struct efx_rss_context ctx;
 	int rc = 0;
 
 	if (!efx->type->rx_pull_rss_context_config)
 		return -EOPNOTSUPP;
 
-	mutex_lock(&efx->rss_lock);
-	ctx = efx_find_rss_context_entry(efx, rss_context);
-	if (!ctx) {
+	mutex_lock(&net_dev->ethtool->rss_lock);
+	ctx_priv = efx_find_rss_context_entry(efx, rss_context);
+	if (!ctx_priv) {
 		rc = -ENOENT;
 		goto out_unlock;
 	}
-	rc = efx->type->rx_pull_rss_context_config(efx, ctx);
+	ctx.priv = *ctx_priv;
+	rc = efx->type->rx_pull_rss_context_config(efx, &ctx);
 	if (rc)
 		goto out_unlock;
 
 	if (hfunc)
 		*hfunc = ETH_RSS_HASH_TOP;
 	if (indir)
-		memcpy(indir, ctx->rx_indir_table, sizeof(ctx->rx_indir_table));
+		memcpy(indir, ctx.rx_indir_table, sizeof(ctx.rx_indir_table));
 	if (key)
-		memcpy(key, ctx->rx_hash_key, efx->type->rx_hash_key_size);
+		memcpy(key, ctx.rx_hash_key, efx->type->rx_hash_key_size);
 out_unlock:
-	mutex_unlock(&efx->rss_lock);
+	mutex_unlock(&net_dev->ethtool->rss_lock);
 	return rc;
 }
 
-int efx_ethtool_set_rxfh_context(struct net_device *net_dev,
-				 const u32 *indir, const u8 *key,
-				 const u8 hfunc, u32 *rss_context,
-				 bool delete)
+int efx_ethtool_modify_rxfh_context(struct net_device *net_dev,
+				    struct ethtool_rxfh_context *ctx,
+				    const u32 *indir, const u8 *key,
+				    const u8 hfunc, u32 rss_context,
+				    struct netlink_ext_ack *extack)
 {
 	struct efx_nic *efx = efx_netdev_priv(net_dev);
-	struct efx_rss_context *ctx;
-	bool allocated = false;
-	int rc;
+	struct efx_rss_context_priv *priv;
 
-	if (!efx->type->rx_push_rss_context_config)
+	if (!efx->type->rx_push_rss_context_config) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "NIC type does not support custom contexts");
 		return -EOPNOTSUPP;
+	}
 	/* Hash function is Toeplitz, cannot be changed */
-	if (hfunc != ETH_RSS_HASH_NO_CHANGE && hfunc != ETH_RSS_HASH_TOP)
+	if (hfunc != ETH_RSS_HASH_NO_CHANGE && hfunc != ETH_RSS_HASH_TOP) {
+		NL_SET_ERR_MSG_MOD(extack, "Only Toeplitz hash is supported");
 		return -EOPNOTSUPP;
+	}
 
-	mutex_lock(&efx->rss_lock);
+	priv = ethtool_rxfh_context_priv(ctx);
 
-	if (*rss_context == ETH_RXFH_CONTEXT_ALLOC) {
-		if (delete) {
-			/* alloc + delete == Nothing to do */
-			rc = -EINVAL;
-			goto out_unlock;
-		}
-		ctx = efx_alloc_rss_context_entry(efx);
-		if (!ctx) {
-			rc = -ENOMEM;
-			goto out_unlock;
-		}
-		ctx->context_id = EFX_MCDI_RSS_CONTEXT_INVALID;
-		/* Initialise indir table and key to defaults */
-		efx_set_default_rx_indir_table(efx, ctx);
-		netdev_rss_key_fill(ctx->rx_hash_key, sizeof(ctx->rx_hash_key));
-		allocated = true;
-	} else {
-		ctx = efx_find_rss_context_entry(efx, *rss_context);
-		if (!ctx) {
-			rc = -ENOENT;
-			goto out_unlock;
-		}
-	}
+	if (!key)
+		key = ethtool_rxfh_context_key(ctx);
+	if (!indir)
+		indir = ethtool_rxfh_context_indir(ctx);
 
-	if (delete) {
-		/* delete this context */
-		rc = efx->type->rx_push_rss_context_config(efx, ctx, NULL, NULL);
-		if (!rc)
-			efx_free_rss_context_entry(ctx);
-		goto out_unlock;
+	return efx->type->rx_push_rss_context_config(efx, priv, indir, key,
+						     false);
+}
+
+int efx_ethtool_create_rxfh_context(struct net_device *net_dev,
+				    struct ethtool_rxfh_context *ctx,
+				    const u32 *indir, const u8 *key,
+				    const u8 hfunc, u32 rss_context,
+				    struct netlink_ext_ack *extack)
+{
+	struct efx_nic *efx = efx_netdev_priv(net_dev);
+	struct efx_rss_context_priv *priv;
+
+	if (!efx->type->rx_push_rss_context_config) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "NIC type does not support custom contexts");
+		return -EOPNOTSUPP;
+	}
+	/* Hash function is Toeplitz, cannot be changed */
+	if (hfunc != ETH_RSS_HASH_NO_CHANGE && hfunc != ETH_RSS_HASH_TOP) {
+		NL_SET_ERR_MSG_MOD(extack, "Only Toeplitz hash is supported");
+		return -EOPNOTSUPP;
 	}
 
-	if (!key)
-		key = ctx->rx_hash_key;
+	priv = ethtool_rxfh_context_priv(ctx);
+
+	priv->context_id = EFX_MCDI_RSS_CONTEXT_INVALID;
+	priv->rx_hash_udp_4tuple = false;
+	/* Generate default indir table and/or key if not specified.
+	 * We use ctx as a place to store these; this is fine because
+	 * we're doing a create, so if we fail then the ctx will just
+	 * be deleted.
+	 */
 	if (!indir)
-		indir = ctx->rx_indir_table;
+		efx_set_default_rx_indir_table(efx, ethtool_rxfh_context_indir(ctx));
+	if (!key)
+		netdev_rss_key_fill(ethtool_rxfh_context_key(ctx),
+				    ctx->key_size);
+	return efx_ethtool_modify_rxfh_context(net_dev, ctx, indir, key, hfunc,
+					       rss_context, extack);
+}
 
-	rc = efx->type->rx_push_rss_context_config(efx, ctx, indir, key);
-	if (rc && allocated)
-		efx_free_rss_context_entry(ctx);
-	else
-		*rss_context = ctx->user_id;
-out_unlock:
-	mutex_unlock(&efx->rss_lock);
-	return rc;
+int efx_ethtool_remove_rxfh_context(struct net_device *net_dev,
+				    struct ethtool_rxfh_context *ctx,
+				    u32 rss_context,
+				    struct netlink_ext_ack *extack)
+{
+	struct efx_nic *efx = efx_netdev_priv(net_dev);
+	struct efx_rss_context_priv *priv;
+
+	if (!efx->type->rx_push_rss_context_config) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "NIC type does not support custom contexts");
+		return -EOPNOTSUPP;
+	}
+
+	priv = ethtool_rxfh_context_priv(ctx);
+	return efx->type->rx_push_rss_context_config(efx, priv, NULL, NULL,
+						     true);
 }
 
 int efx_ethtool_reset(struct net_device *net_dev, u32 *flags)
diff --git a/drivers/net/ethernet/sfc/ethtool_common.h b/drivers/net/ethernet/sfc/ethtool_common.h
index 659491932101..3df852eaab20 100644
--- a/drivers/net/ethernet/sfc/ethtool_common.h
+++ b/drivers/net/ethernet/sfc/ethtool_common.h
@@ -50,10 +50,20 @@ int efx_ethtool_set_rxfh(struct net_device *net_dev,
 			 const u32 *indir, const u8 *key, const u8 hfunc);
 int efx_ethtool_get_rxfh_context(struct net_device *net_dev, u32 *indir,
 				 u8 *key, u8 *hfunc, u32 rss_context);
-int efx_ethtool_set_rxfh_context(struct net_device *net_dev,
-				 const u32 *indir, const u8 *key,
-				 const u8 hfunc, u32 *rss_context,
-				 bool delete);
+int efx_ethtool_create_rxfh_context(struct net_device *net_dev,
+				    struct ethtool_rxfh_context *ctx,
+				    const u32 *indir, const u8 *key,
+				    const u8 hfunc, u32 rss_context,
+				    struct netlink_ext_ack *extack);
+int efx_ethtool_modify_rxfh_context(struct net_device *net_dev,
+				    struct ethtool_rxfh_context *ctx,
+				    const u32 *indir, const u8 *key,
+				    const u8 hfunc, u32 rss_context,
+				    struct netlink_ext_ack *extack);
+int efx_ethtool_remove_rxfh_context(struct net_device *net_dev,
+				    struct ethtool_rxfh_context *ctx,
+				    u32 rss_context,
+				    struct netlink_ext_ack *extack);
 int efx_ethtool_reset(struct net_device *net_dev, u32 *flags);
 int efx_ethtool_get_module_eeprom(struct net_device *net_dev,
 				  struct ethtool_eeprom *ee,
diff --git a/drivers/net/ethernet/sfc/mcdi_filters.c b/drivers/net/ethernet/sfc/mcdi_filters.c
index 4ff6586116ee..fa6eb4ec170a 100644
--- a/drivers/net/ethernet/sfc/mcdi_filters.c
+++ b/drivers/net/ethernet/sfc/mcdi_filters.c
@@ -194,7 +194,7 @@ efx_mcdi_filter_push_prep_set_match_fields(struct efx_nic *efx,
 static void efx_mcdi_filter_push_prep(struct efx_nic *efx,
 				      const struct efx_filter_spec *spec,
 				      efx_dword_t *inbuf, u64 handle,
-				      struct efx_rss_context *ctx,
+				      struct efx_rss_context_priv *ctx,
 				      bool replacing)
 {
 	u32 flags = spec->flags;
@@ -245,7 +245,7 @@ static void efx_mcdi_filter_push_prep(struct efx_nic *efx,
 
 static int efx_mcdi_filter_push(struct efx_nic *efx,
 				const struct efx_filter_spec *spec, u64 *handle,
-				struct efx_rss_context *ctx, bool replacing)
+				struct efx_rss_context_priv *ctx, bool replacing)
 {
 	MCDI_DECLARE_BUF(inbuf, MC_CMD_FILTER_OP_EXT_IN_LEN);
 	MCDI_DECLARE_BUF(outbuf, MC_CMD_FILTER_OP_EXT_OUT_LEN);
@@ -345,9 +345,9 @@ static s32 efx_mcdi_filter_insert_locked(struct efx_nic *efx,
 					 bool replace_equal)
 {
 	DECLARE_BITMAP(mc_rem_map, EFX_EF10_FILTER_SEARCH_LIMIT);
+	struct efx_rss_context_priv *ctx = NULL;
 	struct efx_mcdi_filter_table *table;
 	struct efx_filter_spec *saved_spec;
-	struct efx_rss_context *ctx = NULL;
 	unsigned int match_pri, hash;
 	unsigned int priv_flags;
 	bool rss_locked = false;
@@ -380,12 +380,12 @@ static s32 efx_mcdi_filter_insert_locked(struct efx_nic *efx,
 		bitmap_zero(mc_rem_map, EFX_EF10_FILTER_SEARCH_LIMIT);
 
 	if (spec->flags & EFX_FILTER_FLAG_RX_RSS) {
-		mutex_lock(&efx->rss_lock);
+		mutex_lock(&efx->net_dev->ethtool->rss_lock);
 		rss_locked = true;
 		if (spec->rss_context)
 			ctx = efx_find_rss_context_entry(efx, spec->rss_context);
 		else
-			ctx = &efx->rss_context;
+			ctx = &efx->rss_context.priv;
 		if (!ctx) {
 			rc = -ENOENT;
 			goto out_unlock;
@@ -548,7 +548,7 @@ static s32 efx_mcdi_filter_insert_locked(struct efx_nic *efx,
 
 out_unlock:
 	if (rss_locked)
-		mutex_unlock(&efx->rss_lock);
+		mutex_unlock(&efx->net_dev->ethtool->rss_lock);
 	up_write(&table->lock);
 	return rc;
 }
@@ -611,13 +611,13 @@ static int efx_mcdi_filter_remove_internal(struct efx_nic *efx,
 
 		new_spec.priority = EFX_FILTER_PRI_AUTO;
 		new_spec.flags = (EFX_FILTER_FLAG_RX |
-				  (efx_rss_active(&efx->rss_context) ?
+				  (efx_rss_active(&efx->rss_context.priv) ?
 				   EFX_FILTER_FLAG_RX_RSS : 0));
 		new_spec.dmaq_id = 0;
 		new_spec.rss_context = 0;
 		rc = efx_mcdi_filter_push(efx, &new_spec,
 					  &table->entry[filter_idx].handle,
-					  &efx->rss_context,
+					  &efx->rss_context.priv,
 					  true);
 
 		if (rc == 0)
@@ -764,7 +764,7 @@ static int efx_mcdi_filter_insert_addr_list(struct efx_nic *efx,
 		ids = vlan->uc;
 	}
 
-	filter_flags = efx_rss_active(&efx->rss_context) ? EFX_FILTER_FLAG_RX_RSS : 0;
+	filter_flags = efx_rss_active(&efx->rss_context.priv) ? EFX_FILTER_FLAG_RX_RSS : 0;
 
 	/* Insert/renew filters */
 	for (i = 0; i < addr_count; i++) {
@@ -833,7 +833,7 @@ static int efx_mcdi_filter_insert_def(struct efx_nic *efx,
 	int rc;
 	u16 *id;
 
-	filter_flags = efx_rss_active(&efx->rss_context) ? EFX_FILTER_FLAG_RX_RSS : 0;
+	filter_flags = efx_rss_active(&efx->rss_context.priv) ? EFX_FILTER_FLAG_RX_RSS : 0;
 
 	efx_filter_init_rx(&spec, EFX_FILTER_PRI_AUTO, filter_flags, 0);
 
@@ -1375,8 +1375,8 @@ void efx_mcdi_filter_table_restore(struct efx_nic *efx)
 	struct efx_mcdi_filter_table *table = efx->filter_state;
 	unsigned int invalid_filters = 0, failed = 0;
 	struct efx_mcdi_filter_vlan *vlan;
+	struct efx_rss_context_priv *ctx;
 	struct efx_filter_spec *spec;
-	struct efx_rss_context *ctx;
 	unsigned int filter_idx;
 	u32 mcdi_flags;
 	int match_pri;
@@ -1388,7 +1388,7 @@ void efx_mcdi_filter_table_restore(struct efx_nic *efx)
 		return;
 
 	down_write(&table->lock);
-	mutex_lock(&efx->rss_lock);
+	mutex_lock(&efx->net_dev->ethtool->rss_lock);
 
 	for (filter_idx = 0; filter_idx < EFX_MCDI_FILTER_TBL_ROWS; filter_idx++) {
 		spec = efx_mcdi_filter_entry_spec(table, filter_idx);
@@ -1407,7 +1407,7 @@ void efx_mcdi_filter_table_restore(struct efx_nic *efx)
 		if (spec->rss_context)
 			ctx = efx_find_rss_context_entry(efx, spec->rss_context);
 		else
-			ctx = &efx->rss_context;
+			ctx = &efx->rss_context.priv;
 		if (spec->flags & EFX_FILTER_FLAG_RX_RSS) {
 			if (!ctx) {
 				netif_warn(efx, drv, efx->net_dev,
@@ -1444,7 +1444,7 @@ void efx_mcdi_filter_table_restore(struct efx_nic *efx)
 		}
 	}
 
-	mutex_unlock(&efx->rss_lock);
+	mutex_unlock(&efx->net_dev->ethtool->rss_lock);
 	up_write(&table->lock);
 
 	/*
@@ -1861,7 +1861,8 @@ bool efx_mcdi_filter_rfs_expire_one(struct efx_nic *efx, u32 flow_id,
 					 RSS_MODE_HASH_ADDRS << MC_CMD_RSS_CONTEXT_GET_FLAGS_OUT_UDP_IPV6_RSS_MODE_LBN |\
 					 RSS_MODE_HASH_ADDRS << MC_CMD_RSS_CONTEXT_GET_FLAGS_OUT_OTHER_IPV6_RSS_MODE_LBN)
 
-int efx_mcdi_get_rss_context_flags(struct efx_nic *efx, u32 context, u32 *flags)
+static int efx_mcdi_get_rss_context_flags(struct efx_nic *efx, u32 context,
+					  u32 *flags)
 {
 	/*
 	 * Firmware had a bug (sfc bug 61952) where it would not actually
@@ -1909,8 +1910,8 @@ int efx_mcdi_get_rss_context_flags(struct efx_nic *efx, u32 context, u32 *flags)
  * Defaults are 4-tuple for TCP and 2-tuple for UDP and other-IP, so we
  * just need to set the UDP ports flags (for both IP versions).
  */
-void efx_mcdi_set_rss_context_flags(struct efx_nic *efx,
-				    struct efx_rss_context *ctx)
+static void efx_mcdi_set_rss_context_flags(struct efx_nic *efx,
+					   struct efx_rss_context_priv *ctx)
 {
 	MCDI_DECLARE_BUF(inbuf, MC_CMD_RSS_CONTEXT_SET_FLAGS_IN_LEN);
 	u32 flags;
@@ -1931,7 +1932,7 @@ void efx_mcdi_set_rss_context_flags(struct efx_nic *efx,
 }
 
 static int efx_mcdi_filter_alloc_rss_context(struct efx_nic *efx, bool exclusive,
-					     struct efx_rss_context *ctx,
+					     struct efx_rss_context_priv *ctx,
 					     unsigned *context_size)
 {
 	MCDI_DECLARE_BUF(inbuf, MC_CMD_RSS_CONTEXT_ALLOC_IN_LEN);
@@ -2032,25 +2033,26 @@ void efx_mcdi_rx_free_indir_table(struct efx_nic *efx)
 {
 	int rc;
 
-	if (efx->rss_context.context_id != EFX_MCDI_RSS_CONTEXT_INVALID) {
-		rc = efx_mcdi_filter_free_rss_context(efx, efx->rss_context.context_id);
+	if (efx->rss_context.priv.context_id != EFX_MCDI_RSS_CONTEXT_INVALID) {
+		rc = efx_mcdi_filter_free_rss_context(efx, efx->rss_context.priv.context_id);
 		WARN_ON(rc != 0);
 	}
-	efx->rss_context.context_id = EFX_MCDI_RSS_CONTEXT_INVALID;
+	efx->rss_context.priv.context_id = EFX_MCDI_RSS_CONTEXT_INVALID;
 }
 
 static int efx_mcdi_filter_rx_push_shared_rss_config(struct efx_nic *efx,
 					      unsigned *context_size)
 {
 	struct efx_mcdi_filter_table *table = efx->filter_state;
-	int rc = efx_mcdi_filter_alloc_rss_context(efx, false, &efx->rss_context,
-					    context_size);
+	int rc = efx_mcdi_filter_alloc_rss_context(efx, false,
+						   &efx->rss_context.priv,
+						   context_size);
 
 	if (rc != 0)
 		return rc;
 
 	table->rx_rss_context_exclusive = false;
-	efx_set_default_rx_indir_table(efx, &efx->rss_context);
+	efx_set_default_rx_indir_table(efx, efx->rss_context.rx_indir_table);
 	return 0;
 }
 
@@ -2058,26 +2060,27 @@ static int efx_mcdi_filter_rx_push_exclusive_rss_config(struct efx_nic *efx,
 						 const u32 *rx_indir_table,
 						 const u8 *key)
 {
+	u32 old_rx_rss_context = efx->rss_context.priv.context_id;
 	struct efx_mcdi_filter_table *table = efx->filter_state;
-	u32 old_rx_rss_context = efx->rss_context.context_id;
 	int rc;
 
-	if (efx->rss_context.context_id == EFX_MCDI_RSS_CONTEXT_INVALID ||
+	if (efx->rss_context.priv.context_id == EFX_MCDI_RSS_CONTEXT_INVALID ||
 	    !table->rx_rss_context_exclusive) {
-		rc = efx_mcdi_filter_alloc_rss_context(efx, true, &efx->rss_context,
-						NULL);
+		rc = efx_mcdi_filter_alloc_rss_context(efx, true,
+						       &efx->rss_context.priv,
+						       NULL);
 		if (rc == -EOPNOTSUPP)
 			return rc;
 		else if (rc != 0)
 			goto fail1;
 	}
 
-	rc = efx_mcdi_filter_populate_rss_table(efx, efx->rss_context.context_id,
-					 rx_indir_table, key);
+	rc = efx_mcdi_filter_populate_rss_table(efx, efx->rss_context.priv.context_id,
+						rx_indir_table, key);
 	if (rc != 0)
 		goto fail2;
 
-	if (efx->rss_context.context_id != old_rx_rss_context &&
+	if (efx->rss_context.priv.context_id != old_rx_rss_context &&
 	    old_rx_rss_context != EFX_MCDI_RSS_CONTEXT_INVALID)
 		WARN_ON(efx_mcdi_filter_free_rss_context(efx, old_rx_rss_context) != 0);
 	table->rx_rss_context_exclusive = true;
@@ -2091,9 +2094,9 @@ static int efx_mcdi_filter_rx_push_exclusive_rss_config(struct efx_nic *efx,
 	return 0;
 
 fail2:
-	if (old_rx_rss_context != efx->rss_context.context_id) {
-		WARN_ON(efx_mcdi_filter_free_rss_context(efx, efx->rss_context.context_id) != 0);
-		efx->rss_context.context_id = old_rx_rss_context;
+	if (old_rx_rss_context != efx->rss_context.priv.context_id) {
+		WARN_ON(efx_mcdi_filter_free_rss_context(efx, efx->rss_context.priv.context_id) != 0);
+		efx->rss_context.priv.context_id = old_rx_rss_context;
 	}
 fail1:
 	netif_err(efx, hw, efx->net_dev, "%s: failed rc=%d\n", __func__, rc);
@@ -2101,33 +2104,28 @@ static int efx_mcdi_filter_rx_push_exclusive_rss_config(struct efx_nic *efx,
 }
 
 int efx_mcdi_rx_push_rss_context_config(struct efx_nic *efx,
-					struct efx_rss_context *ctx,
+					struct efx_rss_context_priv *ctx,
 					const u32 *rx_indir_table,
-					const u8 *key)
+					const u8 *key, bool delete)
 {
 	int rc;
 
-	WARN_ON(!mutex_is_locked(&efx->rss_lock));
+	WARN_ON(!mutex_is_locked(&efx->net_dev->ethtool->rss_lock));
 
 	if (ctx->context_id == EFX_MCDI_RSS_CONTEXT_INVALID) {
+		if (delete)
+			/* already wasn't in HW, nothing to do */
+			return 0;
 		rc = efx_mcdi_filter_alloc_rss_context(efx, true, ctx, NULL);
 		if (rc)
 			return rc;
 	}
 
-	if (!rx_indir_table) /* Delete this context */
+	if (delete) /* Delete this context */
 		return efx_mcdi_filter_free_rss_context(efx, ctx->context_id);
 
-	rc = efx_mcdi_filter_populate_rss_table(efx, ctx->context_id,
-					 rx_indir_table, key);
-	if (rc)
-		return rc;
-
-	memcpy(ctx->rx_indir_table, rx_indir_table,
-	       sizeof(efx->rss_context.rx_indir_table));
-	memcpy(ctx->rx_hash_key, key, efx->type->rx_hash_key_size);
-
-	return 0;
+	return efx_mcdi_filter_populate_rss_table(efx, ctx->context_id,
+						  rx_indir_table, key);
 }
 
 int efx_mcdi_rx_pull_rss_context_config(struct efx_nic *efx,
@@ -2139,16 +2137,16 @@ int efx_mcdi_rx_pull_rss_context_config(struct efx_nic *efx,
 	size_t outlen;
 	int rc, i;
 
-	WARN_ON(!mutex_is_locked(&efx->rss_lock));
+	WARN_ON(!mutex_is_locked(&efx->net_dev->ethtool->rss_lock));
 
 	BUILD_BUG_ON(MC_CMD_RSS_CONTEXT_GET_TABLE_IN_LEN !=
 		     MC_CMD_RSS_CONTEXT_GET_KEY_IN_LEN);
 
-	if (ctx->context_id == EFX_MCDI_RSS_CONTEXT_INVALID)
+	if (ctx->priv.context_id == EFX_MCDI_RSS_CONTEXT_INVALID)
 		return -ENOENT;
 
 	MCDI_SET_DWORD(inbuf, RSS_CONTEXT_GET_TABLE_IN_RSS_CONTEXT_ID,
-		       ctx->context_id);
+		       ctx->priv.context_id);
 	BUILD_BUG_ON(ARRAY_SIZE(ctx->rx_indir_table) !=
 		     MC_CMD_RSS_CONTEXT_GET_TABLE_OUT_INDIRECTION_TABLE_LEN);
 	rc = efx_mcdi_rpc(efx, MC_CMD_RSS_CONTEXT_GET_TABLE, inbuf, sizeof(inbuf),
@@ -2164,7 +2162,7 @@ int efx_mcdi_rx_pull_rss_context_config(struct efx_nic *efx,
 				RSS_CONTEXT_GET_TABLE_OUT_INDIRECTION_TABLE)[i];
 
 	MCDI_SET_DWORD(inbuf, RSS_CONTEXT_GET_KEY_IN_RSS_CONTEXT_ID,
-		       ctx->context_id);
+		       ctx->priv.context_id);
 	BUILD_BUG_ON(ARRAY_SIZE(ctx->rx_hash_key) !=
 		     MC_CMD_RSS_CONTEXT_SET_KEY_IN_TOEPLITZ_KEY_LEN);
 	rc = efx_mcdi_rpc(efx, MC_CMD_RSS_CONTEXT_GET_KEY, inbuf, sizeof(inbuf),
@@ -2186,35 +2184,42 @@ int efx_mcdi_rx_pull_rss_config(struct efx_nic *efx)
 {
 	int rc;
 
-	mutex_lock(&efx->rss_lock);
+	mutex_lock(&efx->net_dev->ethtool->rss_lock);
 	rc = efx_mcdi_rx_pull_rss_context_config(efx, &efx->rss_context);
-	mutex_unlock(&efx->rss_lock);
+	mutex_unlock(&efx->net_dev->ethtool->rss_lock);
 	return rc;
 }
 
 void efx_mcdi_rx_restore_rss_contexts(struct efx_nic *efx)
 {
 	struct efx_mcdi_filter_table *table = efx->filter_state;
-	struct efx_rss_context *ctx;
+	struct ethtool_rxfh_context *ctx;
+	u32 context;
 	int rc;
 
-	WARN_ON(!mutex_is_locked(&efx->rss_lock));
+	WARN_ON(!mutex_is_locked(&efx->net_dev->ethtool->rss_lock));
 
 	if (!table->must_restore_rss_contexts)
 		return;
 
-	list_for_each_entry(ctx, &efx->rss_context.list, list) {
+	idr_for_each_entry(&efx->net_dev->ethtool->rss_ctx, ctx, context) {
+		struct efx_rss_context_priv *priv;
+		u32 *indir;
+		u8 *key;
+
+		priv = ethtool_rxfh_context_priv(ctx);
 		/* previous NIC RSS context is gone */
-		ctx->context_id = EFX_MCDI_RSS_CONTEXT_INVALID;
+		priv->context_id = EFX_MCDI_RSS_CONTEXT_INVALID;
 		/* so try to allocate a new one */
-		rc = efx_mcdi_rx_push_rss_context_config(efx, ctx,
-							 ctx->rx_indir_table,
-							 ctx->rx_hash_key);
+		indir = ethtool_rxfh_context_indir(ctx);
+		key = ethtool_rxfh_context_key(ctx);
+		rc = efx_mcdi_rx_push_rss_context_config(efx, priv, indir, key,
+							 false);
 		if (rc)
 			netif_warn(efx, probe, efx->net_dev,
 				   "failed to restore RSS context %u, rc=%d"
 				   "; RSS filters may fail to be applied\n",
-				   ctx->user_id, rc);
+				   context, rc);
 	}
 	table->must_restore_rss_contexts = false;
 }
@@ -2276,7 +2281,7 @@ int efx_mcdi_vf_rx_push_rss_config(struct efx_nic *efx, bool user,
 {
 	if (user)
 		return -EOPNOTSUPP;
-	if (efx->rss_context.context_id != EFX_MCDI_RSS_CONTEXT_INVALID)
+	if (efx->rss_context.priv.context_id != EFX_MCDI_RSS_CONTEXT_INVALID)
 		return 0;
 	return efx_mcdi_filter_rx_push_shared_rss_config(efx, NULL);
 }
@@ -2295,7 +2300,7 @@ int efx_mcdi_push_default_indir_table(struct efx_nic *efx,
 
 	efx_mcdi_rx_free_indir_table(efx);
 	if (rss_spread > 1) {
-		efx_set_default_rx_indir_table(efx, &efx->rss_context);
+		efx_set_default_rx_indir_table(efx, efx->rss_context.rx_indir_table);
 		rc = efx->type->rx_push_rss_config(efx, false,
 				   efx->rss_context.rx_indir_table, NULL);
 	}
diff --git a/drivers/net/ethernet/sfc/mcdi_filters.h b/drivers/net/ethernet/sfc/mcdi_filters.h
index c0d6558b9fd2..11b9f87ed9e1 100644
--- a/drivers/net/ethernet/sfc/mcdi_filters.h
+++ b/drivers/net/ethernet/sfc/mcdi_filters.h
@@ -145,9 +145,9 @@ void efx_mcdi_filter_del_vlan(struct efx_nic *efx, u16 vid);
 
 void efx_mcdi_rx_free_indir_table(struct efx_nic *efx);
 int efx_mcdi_rx_push_rss_context_config(struct efx_nic *efx,
-					struct efx_rss_context *ctx,
+					struct efx_rss_context_priv *ctx,
 					const u32 *rx_indir_table,
-					const u8 *key);
+					const u8 *key, bool delete);
 int efx_mcdi_pf_rx_push_rss_config(struct efx_nic *efx, bool user,
 				   const u32 *rx_indir_table,
 				   const u8 *key);
@@ -161,10 +161,6 @@ int efx_mcdi_push_default_indir_table(struct efx_nic *efx,
 int efx_mcdi_rx_pull_rss_config(struct efx_nic *efx);
 int efx_mcdi_rx_pull_rss_context_config(struct efx_nic *efx,
 					struct efx_rss_context *ctx);
-int efx_mcdi_get_rss_context_flags(struct efx_nic *efx, u32 context,
-				   u32 *flags);
-void efx_mcdi_set_rss_context_flags(struct efx_nic *efx,
-				    struct efx_rss_context *ctx);
 void efx_mcdi_rx_restore_rss_contexts(struct efx_nic *efx);
 
 static inline void efx_mcdi_update_rx_scatter(struct efx_nic *efx)
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index fcd51d3992fa..bceeada24d6c 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -770,21 +770,24 @@ struct vfdi_status;
 /* The reserved RSS context value */
 #define EFX_MCDI_RSS_CONTEXT_INVALID	0xffffffff
 /**
- * struct efx_rss_context - A user-defined RSS context for filtering
- * @list: node of linked list on which this struct is stored
+ * struct efx_rss_context_priv - driver private data for an RSS context
  * @context_id: the RSS_CONTEXT_ID returned by MC firmware, or
  *	%EFX_MCDI_RSS_CONTEXT_INVALID if this context is not present on the NIC.
- *	For Siena, 0 if RSS is active, else %EFX_MCDI_RSS_CONTEXT_INVALID.
- * @user_id: the rss_context ID exposed to userspace over ethtool.
  * @rx_hash_udp_4tuple: UDP 4-tuple hashing enabled
+ */
+struct efx_rss_context_priv {
+	u32 context_id;
+	bool rx_hash_udp_4tuple;
+};
+
+/**
+ * struct efx_rss_context - an RSS context
+ * @priv: hardware-specific state
  * @rx_hash_key: Toeplitz hash key for this RSS context
  * @indir_table: Indirection table for this RSS context
  */
 struct efx_rss_context {
-	struct list_head list;
-	u32 context_id;
-	u32 user_id;
-	bool rx_hash_udp_4tuple;
+	struct efx_rss_context_priv priv;
 	u8 rx_hash_key[40];
 	u32 rx_indir_table[128];
 };
@@ -917,9 +920,7 @@ struct efx_mae;
  * @rx_packet_ts_offset: Offset of timestamp from start of packet data
  *	(valid only if channel->sync_timestamps_enabled; always negative)
  * @rx_scatter: Scatter mode enabled for receives
- * @rss_context: Main RSS context.  Its @list member is the head of the list of
- *	RSS contexts created by user requests
- * @rss_lock: Protects custom RSS context software state in @rss_context.list
+ * @rss_context: Main RSS context.
  * @vport_id: The function's vport ID, only relevant for PFs
  * @int_error_count: Number of internal errors seen recently
  * @int_error_expire: Time at which error count will be expired
@@ -1090,7 +1091,6 @@ struct efx_nic {
 	int rx_packet_ts_offset;
 	bool rx_scatter;
 	struct efx_rss_context rss_context;
-	struct mutex rss_lock;
 	u32 vport_id;
 
 	unsigned int_error_count;
@@ -1462,9 +1462,9 @@ struct efx_nic_type {
 				  const u32 *rx_indir_table, const u8 *key);
 	int (*rx_pull_rss_config)(struct efx_nic *efx);
 	int (*rx_push_rss_context_config)(struct efx_nic *efx,
-					  struct efx_rss_context *ctx,
+					  struct efx_rss_context_priv *ctx,
 					  const u32 *rx_indir_table,
-					  const u8 *key);
+					  const u8 *key, bool delete);
 	int (*rx_pull_rss_context_config)(struct efx_nic *efx,
 					  struct efx_rss_context *ctx);
 	void (*rx_restore_rss_contexts)(struct efx_nic *efx);
diff --git a/drivers/net/ethernet/sfc/rx_common.c b/drivers/net/ethernet/sfc/rx_common.c
index d2f35ee15eff..f5632c210ab2 100644
--- a/drivers/net/ethernet/sfc/rx_common.c
+++ b/drivers/net/ethernet/sfc/rx_common.c
@@ -556,69 +556,25 @@ efx_rx_packet_gro(struct efx_channel *channel, struct efx_rx_buffer *rx_buf,
 	napi_gro_frags(napi);
 }
 
-/* RSS contexts.  We're using linked lists and crappy O(n) algorithms, because
- * (a) this is an infrequent control-plane operation and (b) n is small (max 64)
- */
-struct efx_rss_context *efx_alloc_rss_context_entry(struct efx_nic *efx)
+struct efx_rss_context_priv *efx_find_rss_context_entry(struct efx_nic *efx,
+							u32 id)
 {
-	struct list_head *head = &efx->rss_context.list;
-	struct efx_rss_context *ctx, *new;
-	u32 id = 1; /* Don't use zero, that refers to the master RSS context */
-
-	WARN_ON(!mutex_is_locked(&efx->rss_lock));
+	struct ethtool_rxfh_context *ctx;
 
-	/* Search for first gap in the numbering */
-	list_for_each_entry(ctx, head, list) {
-		if (ctx->user_id != id)
-			break;
-		id++;
-		/* Check for wrap.  If this happens, we have nearly 2^32
-		 * allocated RSS contexts, which seems unlikely.
-		 */
-		if (WARN_ON_ONCE(!id))
-			return NULL;
-	}
+	WARN_ON(!mutex_is_locked(&efx->net_dev->ethtool->rss_lock));
 
-	/* Create the new entry */
-	new = kmalloc(sizeof(*new), GFP_KERNEL);
-	if (!new)
+	ctx = idr_find(&efx->net_dev->ethtool->rss_ctx, id);
+	if (!ctx)
 		return NULL;
-	new->context_id = EFX_MCDI_RSS_CONTEXT_INVALID;
-	new->rx_hash_udp_4tuple = false;
-
-	/* Insert the new entry into the gap */
-	new->user_id = id;
-	list_add_tail(&new->list, &ctx->list);
-	return new;
-}
-
-struct efx_rss_context *efx_find_rss_context_entry(struct efx_nic *efx, u32 id)
-{
-	struct list_head *head = &efx->rss_context.list;
-	struct efx_rss_context *ctx;
-
-	WARN_ON(!mutex_is_locked(&efx->rss_lock));
-
-	list_for_each_entry(ctx, head, list)
-		if (ctx->user_id == id)
-			return ctx;
-	return NULL;
-}
-
-void efx_free_rss_context_entry(struct efx_rss_context *ctx)
-{
-	list_del(&ctx->list);
-	kfree(ctx);
+	return ethtool_rxfh_context_priv(ctx);
 }
 
-void efx_set_default_rx_indir_table(struct efx_nic *efx,
-				    struct efx_rss_context *ctx)
+void efx_set_default_rx_indir_table(struct efx_nic *efx, u32 *indir)
 {
 	size_t i;
 
-	for (i = 0; i < ARRAY_SIZE(ctx->rx_indir_table); i++)
-		ctx->rx_indir_table[i] =
-			ethtool_rxfh_indir_default(i, efx->rss_spread);
+	for (i = 0; i < ARRAY_SIZE(efx->rss_context.rx_indir_table); i++)
+		indir[i] = ethtool_rxfh_indir_default(i, efx->rss_spread);
 }
 
 /**
diff --git a/drivers/net/ethernet/sfc/rx_common.h b/drivers/net/ethernet/sfc/rx_common.h
index fbd2769307f9..75fa84192362 100644
--- a/drivers/net/ethernet/sfc/rx_common.h
+++ b/drivers/net/ethernet/sfc/rx_common.h
@@ -84,11 +84,9 @@ void
 efx_rx_packet_gro(struct efx_channel *channel, struct efx_rx_buffer *rx_buf,
 		  unsigned int n_frags, u8 *eh, __wsum csum);
 
-struct efx_rss_context *efx_alloc_rss_context_entry(struct efx_nic *efx);
-struct efx_rss_context *efx_find_rss_context_entry(struct efx_nic *efx, u32 id);
-void efx_free_rss_context_entry(struct efx_rss_context *ctx);
-void efx_set_default_rx_indir_table(struct efx_nic *efx,
-				    struct efx_rss_context *ctx);
+struct efx_rss_context_priv *efx_find_rss_context_entry(struct efx_nic *efx,
+							u32 id);
+void efx_set_default_rx_indir_table(struct efx_nic *efx, u32 *indir);
 
 bool efx_filter_is_mc_recipient(const struct efx_filter_spec *spec);
 bool efx_filter_spec_equal(const struct efx_filter_spec *left,
