Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E062957BDDB
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 20:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbiGTSeO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 14:34:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiGTSeN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 14:34:13 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2042.outbound.protection.outlook.com [40.107.223.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 422C071BC7
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 11:34:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zq8fuvM4MOddnO065MZDL6iJrt1mcCACi02yrxl9XL2Co1m8KDTMYOhTZtPTrC6Hl4tGUH4SQqQKwik+cOOCIGgE+v/skXeqPqLnvjZ6lvdvW8XEc2SzZTS/JjZQ0lSO++K8JYfWeS6NrQ+3GC1YPTSdy1Iq+Fde1dSTx3IVzIMdKkNPgUH8OYkwzdS+V/7m1M2wyI0uTp2+h0khqmhmpmgDY7kzZLlqrHru6dSESCCXekHkP9vC6Fm/Xi31jUuVU/7thwHIPccbsXqWWSXUl9naYLOpdYfCELrkNxIbvm91pfHW6n/GPZpvGJ5Z/xMs0xDBtoD6DnjUTtLkljdqKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=56SHEc+/z+mysZCWVUPvy2fU2ZqtSDOWlbQEJBR3G+0=;
 b=Zhn8D6KznJdlwF+IAx3LCL1FrxkDYE0M9Fy3RKKODQ65DiaV/3Sr94w2fnfQjMTwAQj180lZl2tVb+wo/Pu9t/z+BI9TEO9tXckVCbWf2I8TupFz8XB7ElVPeiOWTjpRZ7Ag0x7JM05LHhjwqB1+AiLVPyFNkcl6D93MOo+VJd6YCTkz3FHfd/a/Q59jH0hr3ONMC+RfvMD+grfKjUOsmgwIAjIZpNzP0jsHspU3rS5fcexj9lfNyB1UutNhITDXegOqaQPe3ygOgnoSM6aPZh45kt9paDOAhFgozQRPcPyhamrSwmqKf+Aeq3HT5opIDNFYhBXiFic5J6Lrw2t9oQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=56SHEc+/z+mysZCWVUPvy2fU2ZqtSDOWlbQEJBR3G+0=;
 b=Mqb9yUj5ao9VKotaZ54HMlP2roqAk+0Ecz7KYSbIHfxxK95FQbSV/tf7oh1fvhcGbpL/smAnPGUUR0tcQ5wXqqzGZQ9n7ZvZCeuuhU2Sq2lSF3BNC54kzwCXtuHLB/73jKvwetR/wFFWkDT+9gO2VpxqFb6QN7d05aPM9WRo0KUN4hvhKdFR0R0PCLIsZFZlqnSG02Y5c1on8QUqgZgRZ4s1CKHDubyNdjHF1xTYBCMNw2j/L7PB/dqCec4fKj/UK4QFDYyR6DDn9HRIudnbRzmw41RpdagDWr6XXXAEvG2R5BN0TsnNGJlMcOj4Ip8T9Ir+Er4fmbQM4ryCuUH83A==
Received: from MW4PR03CA0026.namprd03.prod.outlook.com (2603:10b6:303:8f::31)
 by DM4PR12MB5151.namprd12.prod.outlook.com (2603:10b6:5:392::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.18; Wed, 20 Jul
 2022 18:34:09 +0000
Received: from CO1NAM11FT013.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8f:cafe::85) by MW4PR03CA0026.outlook.office365.com
 (2603:10b6:303:8f::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.25 via Frontend
 Transport; Wed, 20 Jul 2022 18:34:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT013.mail.protection.outlook.com (10.13.174.227) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5458.17 via Frontend Transport; Wed, 20 Jul 2022 18:34:09 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 20 Jul
 2022 13:34:08 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 20 Jul
 2022 13:34:08 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Wed, 20 Jul 2022 13:34:07 -0500
From:   <ecree@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-net-drivers@amd.com>
CC:     <netdev@vger.kernel.org>, Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH v3 net-next 9/9] sfc: attach/detach EF100 representors along with their owning PF
Date:   Wed, 20 Jul 2022 19:33:49 +0100
Message-ID: <20220720183349.29448-3-ecree@xilinx.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1658341691.git.ecree.xilinx@gmail.com>
References: <cover.1658341691.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 392e41e1-1490-4010-9af2-08da6a7e6f6b
X-MS-TrafficTypeDiagnostic: DM4PR12MB5151:EE_
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BCZ/9VEVEcahMtKkSHFZLUKUDeFw4oPW9jX5IcnrZZNRml1+/5Hkg+ip3d+sS32BbrDYE57s2IbPUHZdhQVdKJMdReUplAEHs/1487QdvIq/H23PSaX82UTTL72an4NkXM//DYCO4hB4hiqN6uny89cAWRsqUcWjdqoP6w2qvEakU/Vwa04PZFyOfCvNyjPseCE2THg7w+wiLLffF+Wq8SGPGPRwZ157ty5PwNHR1LpfbvRoPv8yOP10MfN9/44dSwBlmAgQPCUBE/GnqQTBoYsppLn3MqFIrKskUtdBrSMaqQ4wPMzP93P6qyB8QqYWqnwxJGNZLo2yg9mtVs26+n+sgUY/w0yMkEghTnxDDgTUIvGUZqzeffMR6qESpLYl9C99T2Gcken1cYPSLmfq+w1OCj2KZ1khl+jthE8PHTUNqzrnKjkOVTTmbNGFLR+1vzefBqLr/5HhvZQc9T2HOtyQ2DiwRfIHnw4W3b8UOvDloYp6pz6XLTqIdJPQcxo9DZGdc3PY8Yu1MYQ1JHigvQWXi13K0ZvXJqLHXeQe/Kdbk02PDFmBBGQvP6huYXuWWS6l+qAEtjiNDAJeCVvLSalNcbxyrHsJ56Yp8kvUaY61KXIdc9W1Cu+DIoua7AX/Cn1oeAfP0CQDN8t3nDtJ3RwdLF2/+5DQESqSDDBWPP90mQ03hV4tIS4NpYXtsKhjw82Tr5uv3fIE35U04E+F2nTjXCI6s7ldJXB8aXBxBjVm9tIhdXb6zfBTVh6iQlS3oBsR/DB8GWciwXHIzJ+c4as8CdNG3/rwqB7UJrIgp8ZAYXpBd7bUeb5r/qtV75G74ZVszeTZ2OzAL/4lRErjtA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(396003)(136003)(376002)(46966006)(40470700004)(36840700001)(2876002)(7696005)(2616005)(6666004)(41300700001)(8936002)(5660300002)(82740400003)(478600001)(83170400001)(81166007)(4326008)(1076003)(70586007)(47076005)(356005)(336012)(83380400001)(42882007)(70206006)(40460700003)(110136005)(36860700001)(26005)(54906003)(316002)(36756003)(40480700001)(186003)(8676002)(2906002)(82310400005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2022 18:34:09.2218
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 392e41e1-1490-4010-9af2-08da6a7e6f6b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT013.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5151
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
