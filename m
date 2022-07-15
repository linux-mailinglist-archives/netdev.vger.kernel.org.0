Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 790FD5761CF
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 14:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234588AbiGOMgj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 08:36:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234545AbiGOMga (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 08:36:30 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2085.outbound.protection.outlook.com [40.107.244.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F3E7820D4
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 05:36:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q9fCVR2cXmprkilOlyDCtyrEifmf8Dh+MWJ/ikrFUJdhZ9Gfp9pqLEmBJMLUnZB5Esc97PzLUiv0LPTgFrWQea7L6ixLN0Q3uWVBF4R9BI8dnYj/sqM+AMQM1xNXerg1TAS34CCE5tYZq5mLSF6Y7YGegyp7MbirNOQpOPMx3kL6l/xZ+zf649Gq9h0HQ/yN9bYS5XFu4NZYsgN+C75kN/19a+mNdHH3WBhdrplNlFtSVLH2vzTSgShMeemItGpEMBMxzpPJEHGiATQaTKVZ1hcqNpp1GSKHlZa3xbcxInCAC4oFMn3ielOibAjpJPw+Yk3SefnfONjSgMxHEDOi5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=56SHEc+/z+mysZCWVUPvy2fU2ZqtSDOWlbQEJBR3G+0=;
 b=KPqfKAkGBPROcpWHDfmgnoy7+jHFeB1E1gaGwWWfltR46RsNxQb5SMo7quFOr/LXxsAbse52/TfUA/PjOja/xwm9I7ZIy29fgTF7naov1PRu66UwHBgs9bu7TYrnHG2k0CWUMff7OeheI55lmfteYtSnijkqo29jzeXcOaZdCT17XSibiSTaE7oHMa/8strj/BhaaldIYVOPYCrb79DbCI4wl71cWZEEaGxVc5Mf9oF0/lNoUsdvlvhoy51IyCDlwqoJSUlPosp9NJKZ43TkStPosm2fNCg8Pr4Vv+BW15PsGeH/7XFdNaprn4RYzebrI/GoxeGQlDi2GutGDHbgOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=56SHEc+/z+mysZCWVUPvy2fU2ZqtSDOWlbQEJBR3G+0=;
 b=WaipTwnV6+AWgAK+foo7/uJ6gKJEZTc7m1Of2gJQiy88cht/dSMGjTpId3G2+6K4/cPwx8jpASX5EZDgc2Ij4i0rbApxq4CZmXSAyUgKoUtvs39x4Tgbtu0AjNszdb+GKwO0JXWE4rMh0vm8O076w3MKIr7a2m9MDdc5Rj2lS46bM2DtJWN08nI4FlcsoHfZhcdRMYHmH9qc3tbp7UWLaaZqwiQdsvFA/P0nrV6ou/JH46TCS9imYNAGo7ZmotO7UH2DLf59nPKxRhSxf2zJG4e9s6Q3dIV+Hv9LH5lWx1SYvFhtFLV6pvsxnZ7EoTIOg7oFYv4fYj3UcqIf1/A4sg==
Received: from BN9PR03CA0441.namprd03.prod.outlook.com (2603:10b6:408:113::26)
 by DM6PR12MB3739.namprd12.prod.outlook.com (2603:10b6:5:1c4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.23; Fri, 15 Jul
 2022 12:36:21 +0000
Received: from BN8NAM11FT066.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:113:cafe::32) by BN9PR03CA0441.outlook.office365.com
 (2603:10b6:408:113::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.19 via Frontend
 Transport; Fri, 15 Jul 2022 12:36:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT066.mail.protection.outlook.com (10.13.177.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5438.12 via Frontend Transport; Fri, 15 Jul 2022 12:36:21 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Fri, 15 Jul
 2022 07:36:20 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Fri, 15 Jul
 2022 05:36:20 -0700
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Fri, 15 Jul 2022 07:36:19 -0500
From:   <ecree@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-net-drivers@amd.com>
CC:     <netdev@vger.kernel.org>, Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH net-next 10/10] sfc: attach/detach EF100 representors along with their owning PF
Date:   Fri, 15 Jul 2022 13:33:32 +0100
Message-ID: <c6ca0d372593d979c42eaa1583bbefab5868feaf.1657878101.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1657878101.git.ecree.xilinx@gmail.com>
References: <cover.1657878101.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 58d91bc1-b8b8-4e4e-143a-08da665e9f76
X-MS-TrafficTypeDiagnostic: DM6PR12MB3739:EE_
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vsMEWobnONSuguW1vCheHlA3u+NilRjDWN6cnQIi93i3BaieCjCh97BqzyvETKqCIf/Egqh4t3MVEVGQqHeki/2bxTihdIPQtqCln+dUB19uw4uj3FsZXu1LWsYH7Ngy8khS89zs+YJlKWfqawRwi8tKPX4nGztGG864oQWHvhVgtQ2f/EQXbcD4eYkbQo0pMS3hrghYijvbJ+UVfZslXX/szH7OKd5uVReFtoS3VeT1Kd77dTKoc80LTADFOV3boefW7a1kKrWepDuQFFy/puI0zzWK6nYCx7A3ZhaaWiVNOrItvJcMrZvobiuhiJVrHl79+GQqKKQ788H80eYPTIXZtqY+ieT6Uc4FglP2+rtMvwXonmJ/HZ+7yw/q4GI3SzV+GwZkRqNqyhw+uebajSlb7gd56ZaTu/B5GtlQvRa/sH6bLQRP++2luf04ZQXACKGByscTUTaonprm4PlHrEHU55psL4ES0t8T0i/jLm/UI4bpMHy85nAgqYxTg+A+LhCVfynOK1GPRDBduqP4cLNd600TTUGYIJi39/GhfgQ0FochEz4SwPLiA08tcNfzrwKOMJGC6ecs3e94okPZGOUamaZ2waynAdmZGOpi3KQ769m3PeY90ZqMpZ7ITlqKDnGkkeSm2WGDS8+MUkD7ZNiJLGw2+9b1WZ3Qlq1L1tQGgQMgzQT7mmvqBeAmYr0tKjVTWTgfYIQU5kY6IzEmY8FZYQIrsmlwyHNSceTCu4727xKeSmbPcRtZGBgiw9OGyYMtwbtryAlKvHSdJ5gAp0RW3DWBWuqHqewwYKhXzblrSBEUtKogPnfV1YvFPP57MBMr2b7fe382mu/2d6HkkBiujMAvcSQ6RzF5F4+Dm40=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(136003)(396003)(39860400002)(376002)(346002)(36840700001)(46966006)(40470700004)(5660300002)(54906003)(83170400001)(36860700001)(8936002)(40480700001)(110136005)(81166007)(70206006)(8676002)(40460700003)(70586007)(4326008)(356005)(82740400003)(316002)(55446002)(2906002)(478600001)(83380400001)(47076005)(6666004)(36756003)(2876002)(82310400005)(336012)(41300700001)(9686003)(42882007)(186003)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2022 12:36:21.3996
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 58d91bc1-b8b8-4e4e-143a-08da665e9f76
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT066.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3739
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree.xilinx@gmail.com>

Since representors piggy-back on the PF's queues for TX, they can
 only accept new TXes while the PF is up.  Thus, any operation which
 detaches the PF must first detach all its VFreps.

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/ef100_netdev.c |  3 +++
 drivers/net/ethernet/sfc/ef100_rep.c    | 11 ++++++--
 drivers/net/ethernet/sfc/efx.h          |  9 ++++++-
 drivers/net/ethernet/sfc/efx_common.c   | 36 +++++++++++++++++++++++++
 drivers/net/ethernet/sfc/efx_common.h   |  3 +++
 5 files changed, 59 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef100_netdev.c b/drivers/net/ethernet/sfc/ef100_netdev.c
index 3443477c26da..9e65de1ab889 100644
--- a/drivers/net/ethernet/sfc/ef100_netdev.c
+++ b/drivers/net/ethernet/sfc/ef100_netdev.c
@@ -85,6 +85,7 @@ static int ef100_net_stop(struct net_device *net_dev)
 	netif_dbg(efx, ifdown, efx->net_dev, "closing on CPU %d\n",
 		  raw_smp_processor_id());
 
+	efx_detach_reps(efx);
 	netif_stop_queue(net_dev);
 	efx_stop_all(efx);
 	efx_mcdi_mac_fini_stats(efx);
@@ -176,6 +177,8 @@ static int ef100_net_open(struct net_device *net_dev)
 	mutex_unlock(&efx->mac_lock);
 
 	efx->state = STATE_NET_UP;
+	if (netif_running(efx->net_dev))
+		efx_attach_reps(efx);
 
 	return 0;
 
diff --git a/drivers/net/ethernet/sfc/ef100_rep.c b/drivers/net/ethernet/sfc/ef100_rep.c
index 6d4c3f0eee0a..d07539f091b8 100644
--- a/drivers/net/ethernet/sfc/ef100_rep.c
+++ b/drivers/net/ethernet/sfc/ef100_rep.c
@@ -132,8 +132,13 @@ static struct efx_rep *efx_ef100_rep_create_netdev(struct efx_nic *efx,
 	spin_lock_bh(&efx->vf_reps_lock);
 	list_add_tail(&efv->list, &efx->vf_reps);
 	spin_unlock_bh(&efx->vf_reps_lock);
-	netif_carrier_off(net_dev);
-	netif_tx_stop_all_queues(net_dev);
+	if (netif_running(efx->net_dev) && efx->state == STATE_NET_UP) {
+		netif_device_attach(net_dev);
+		netif_carrier_on(net_dev);
+	} else {
+		netif_carrier_off(net_dev);
+		netif_tx_stop_all_queues(net_dev);
+	}
 	rtnl_unlock();
 
 	net_dev->netdev_ops = &efx_ef100_rep_netdev_ops;
@@ -171,9 +176,11 @@ static void efx_ef100_rep_destroy_netdev(struct efx_rep *efv)
 {
 	struct efx_nic *efx = efv->parent;
 
+	rtnl_lock();
 	spin_lock_bh(&efx->vf_reps_lock);
 	list_del(&efv->list);
 	spin_unlock_bh(&efx->vf_reps_lock);
+	rtnl_unlock();
 	free_netdev(efv->net_dev);
 }
 
diff --git a/drivers/net/ethernet/sfc/efx.h b/drivers/net/ethernet/sfc/efx.h
index c05a83da9e44..4239c7ece123 100644
--- a/drivers/net/ethernet/sfc/efx.h
+++ b/drivers/net/ethernet/sfc/efx.h
@@ -12,6 +12,7 @@
 #include "net_driver.h"
 #include "ef100_rx.h"
 #include "ef100_tx.h"
+#include "efx_common.h"
 #include "filter.h"
 
 int efx_net_open(struct net_device *net_dev);
@@ -206,6 +207,9 @@ static inline void efx_device_detach_sync(struct efx_nic *efx)
 {
 	struct net_device *dev = efx->net_dev;
 
+	/* We must stop reps (which use our TX) before we stop ourselves. */
+	efx_detach_reps(efx);
+
 	/* Lock/freeze all TX queues so that we can be sure the
 	 * TX scheduler is stopped when we're done and before
 	 * netif_device_present() becomes false.
@@ -217,8 +221,11 @@ static inline void efx_device_detach_sync(struct efx_nic *efx)
 
 static inline void efx_device_attach_if_not_resetting(struct efx_nic *efx)
 {
-	if ((efx->state != STATE_DISABLED) && !efx->reset_pending)
+	if ((efx->state != STATE_DISABLED) && !efx->reset_pending) {
 		netif_device_attach(efx->net_dev);
+		if (efx->state == STATE_NET_UP)
+			efx_attach_reps(efx);
+	}
 }
 
 static inline bool efx_rwsem_assert_write_locked(struct rw_semaphore *sem)
diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index fb6b66b8707b..a929a1aaba92 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -24,6 +24,7 @@
 #include "mcdi_port_common.h"
 #include "io.h"
 #include "mcdi_pcol.h"
+#include "ef100_rep.h"
 
 static unsigned int debug = (NETIF_MSG_DRV | NETIF_MSG_PROBE |
 			     NETIF_MSG_LINK | NETIF_MSG_IFDOWN |
@@ -1391,3 +1392,38 @@ int efx_get_phys_port_name(struct net_device *net_dev, char *name, size_t len)
 		return -EINVAL;
 	return 0;
 }
+
+void efx_detach_reps(struct efx_nic *efx)
+{
+	struct net_device *rep_dev;
+	struct efx_rep *efv;
+
+	ASSERT_RTNL();
+	netif_dbg(efx, drv, efx->net_dev, "Detaching VF representors\n");
+	list_for_each_entry(efv, &efx->vf_reps, list) {
+		rep_dev = efv->net_dev;
+		if (!rep_dev)
+			continue;
+		netif_carrier_off(rep_dev);
+		/* See efx_device_detach_sync() */
+		netif_tx_lock_bh(rep_dev);
+		netif_tx_stop_all_queues(rep_dev);
+		netif_tx_unlock_bh(rep_dev);
+	}
+}
+
+void efx_attach_reps(struct efx_nic *efx)
+{
+	struct net_device *rep_dev;
+	struct efx_rep *efv;
+
+	ASSERT_RTNL();
+	netif_dbg(efx, drv, efx->net_dev, "Attaching VF representors\n");
+	list_for_each_entry(efv, &efx->vf_reps, list) {
+		rep_dev = efv->net_dev;
+		if (!rep_dev)
+			continue;
+		netif_tx_wake_all_queues(rep_dev);
+		netif_carrier_on(rep_dev);
+	}
+}
diff --git a/drivers/net/ethernet/sfc/efx_common.h b/drivers/net/ethernet/sfc/efx_common.h
index 93babc1a2678..2c54dac3e662 100644
--- a/drivers/net/ethernet/sfc/efx_common.h
+++ b/drivers/net/ethernet/sfc/efx_common.h
@@ -111,4 +111,7 @@ int efx_get_phys_port_id(struct net_device *net_dev,
 
 int efx_get_phys_port_name(struct net_device *net_dev,
 			   char *name, size_t len);
+
+void efx_detach_reps(struct efx_nic *efx);
+void efx_attach_reps(struct efx_nic *efx);
 #endif
