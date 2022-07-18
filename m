Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDD1F578675
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 17:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234761AbiGRPda (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 11:33:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235391AbiGRPd3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 11:33:29 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2082.outbound.protection.outlook.com [40.107.223.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 343B729CAE
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 08:33:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a8SotEADPMcQzNirESO7Yv7WABLgFssSvd9xxlztRzkM+fBqjLA6zvfkwdTsosTNIxq1J7F45iVfAp4HgrrKbs7YXubH/5O/N+RQpC6y4uydjnc6vDntwTEf5BtLO1bHaZeiZb8chmkS/626QxXzb1UY5huLZjEgktG3uFcqHRXC+NuJNRjrNOGPlqs4sntszfRZPr8aRUdMjmPJLrb6DnOx0YX6kVzVkXK6ZeUp4/my4b03a39sJa4g0Vb3L5gJtd+ah3By/fE/8m3WbcTEj7/9kD2+izWkZ0lFZ/EpgLUjajcHWKwotyZvcuHUTYLeLHC0CCMrgkVHe2vWjAE/LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=56SHEc+/z+mysZCWVUPvy2fU2ZqtSDOWlbQEJBR3G+0=;
 b=AYc+hDxZ2Z4M5i6w9hBBCLYtOSeJDHJKQI5KUeOXqAJvwGYRz0jqFoUjyWlG0qKla2ziuVFZze5onLFDX+YVLLr2eGRreTSA0KH6YBDS4nSjT0IpPM14vRLHLASnOz651wEQaqiSDhAuXXbzRy5zPAfjEOpiGLucYIhZ0S9aNMnvRoYPEgtl6DCzVN8OzXHcbKd/XIPEhHoH72rKOPKcDxRtwZH4/HcyCpT8MIaPpPnb8kfh78ySRGrNLwmk/zMXbjvc/Wh4t7+mFfiY5eyTdDmDJuA/eIz9MktLBrafb7GB+rHIi0jgxwzs69UgnsNyINAq7l3BmVVCG53ciiF2kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=56SHEc+/z+mysZCWVUPvy2fU2ZqtSDOWlbQEJBR3G+0=;
 b=tucAyNj6oBetrF+6WINt76R9tZZFhjMyjJpBz7UY9aoqW6uMwB0BeJB21OF3XlMaS+UOP3YuhCirb5VdfsjWU2wQgaD0Cyq5W4uqfFxb2ZBUmR/xa0SFib95ej2wW1HKhVzNxGhtdVC1MWJngtvEj2nUL8JXxZnQnnnuhL/vjUjP1izWNgxn1VlJMqKMbXvllanyB6f0138Lcc10K/c9e/fki95l+GgSqkguFd61r5oMQift3jCIl9MCPrO0/Zgi5Q2QILVM4trIUfHn2wb0+3ZvlARxVhtkwmSsQnmxGIvJPHi4SGgTVGfWmWSgh+ufSNZO6qF4kZZAJZKIM8ReQA==
Received: from BN8PR12CA0017.namprd12.prod.outlook.com (2603:10b6:408:60::30)
 by CY4PR12MB1526.namprd12.prod.outlook.com (2603:10b6:910:4::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.20; Mon, 18 Jul
 2022 15:33:26 +0000
Received: from BN8NAM11FT062.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:60:cafe::de) by BN8PR12CA0017.outlook.office365.com
 (2603:10b6:408:60::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.20 via Frontend
 Transport; Mon, 18 Jul 2022 15:33:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT062.mail.protection.outlook.com (10.13.177.34) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5438.12 via Frontend Transport; Mon, 18 Jul 2022 15:33:25 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Mon, 18 Jul
 2022 10:32:55 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Mon, 18 Jul
 2022 10:32:54 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Mon, 18 Jul 2022 10:32:53 -0500
From:   <ecree@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-net-drivers@amd.com>
CC:     <netdev@vger.kernel.org>, Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH v2 net-next 10/10] sfc: attach/detach EF100 representors along with their owning PF
Date:   Mon, 18 Jul 2022 16:30:16 +0100
Message-ID: <81d938e79ee9590c8ccb85f0237e60c78b4836f8.1658158016.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1658158016.git.ecree.xilinx@gmail.com>
References: <cover.1658158016.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: efe22e9e-35a0-4f74-bdee-08da68d2db0f
X-MS-TrafficTypeDiagnostic: CY4PR12MB1526:EE_
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g47W14HW9+CmxR9bmwpSRFLjHMPyy8Gz2za/t87isvhyYWW5zpZ0fuXDz0m7DR88YkocBkj+8Cv/d++fyjmSPfFQthO4VCyfFfcK4OYb4oeH2ciuV1RFsIUmg8ZJ/dqpEEML58u8R2GhgCh89h972453NHFvwBrmmB1NonSVYBfUCOthHEUF70j0ZMdTJYDBhMJQiRLn7Y5d/bFCCVBoLNlHS6OoqROrt6T0ZbwIlLa5Ad+jg6J9H+2P/AsQ2l7R0KoNv6fZOamIO1T6m6ekSq5kjNgVJrC9z0wfl9zp7IbkgEQhesSVRWQUWNKuqqmVYT9SDtBeSHGEHTrvjURe9drMXXIxC5R3RjU77pAYbYIM8ZCz00UeylXeV2yvGcR9zzNNmxTnxPXM+Papwae6z9KpJpZLxukPxcXFi086jVpP7LP3fmVWlxu77m1VYhRrln85//+78whWhBvGGNdnQhuEYvdztUhIhIMlbUEx43NoQHHWb5SA6g1hsLtmvDR9Nf7RCxFQpJyNaAS3MsmHiwk9rDgKzlI5to5d+n0O+Q0cUi+avo0GzH6OJ451wH8HO+cilTWUFfUFfDQxHRvS96FyTUKwM1I/p/ZnZM9KAmwlSky14s7BP5g/BBEnBSd7X9IykRnbTa5jRrsWeHs0+ycuGMRFIhSkWg6Ce3DmF790BA198V5UUGdErSdlbcaWI9psOGdZXN3gPXv8RzrZxbl95yEXrLLI3Z93lyKHmE8/vNHxrBkI5h5n6oNVgZrDmJ6C5U64z7eKswlDxavymK/5VjSckx60kyU74K0cwsuwUMLWO3BVMw6L1452GCL+q2na3N0bnSJuXnLWZaMNO33E5rHpHReOOFPQstgwsvE=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(376002)(346002)(136003)(396003)(46966006)(36840700001)(40470700004)(6666004)(41300700001)(82740400003)(4326008)(70206006)(70586007)(8676002)(478600001)(110136005)(54906003)(36756003)(40460700003)(55446002)(81166007)(356005)(83380400001)(83170400001)(316002)(186003)(42882007)(26005)(9686003)(336012)(47076005)(5660300002)(2906002)(82310400005)(8936002)(40480700001)(36860700001)(2876002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2022 15:33:25.3071
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: efe22e9e-35a0-4f74-bdee-08da68d2db0f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT062.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1526
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
