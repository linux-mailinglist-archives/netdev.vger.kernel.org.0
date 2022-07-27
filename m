Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCB58583265
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 20:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236231AbiG0Svh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 14:51:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236267AbiG0Su5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 14:50:57 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2068.outbound.protection.outlook.com [40.107.94.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A6A0ABE77
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 10:47:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VlDbx+3mkujlrWD5q4InKILsUfotEj/kKLkQDWTCvhP3BopvnXHp/pVmt/TZDs0YIK60TuwKGeOTpEUL+Qy4Mgmbf5Cj+w5WPEpk2Wi2I94qKzyQI/saXmJ03IlVtezHSKALASIBHJi//SkwSFSB6FNZCdueeqbeiB9wAtSKpk+hXJGloc8KjSOlgVP1MHYaczs+OAOZQh0Zm9r9nWwT3duq1dpY3BJLio4H0fsWBQPMsqqT3QG7y4XfnjjwH1X7pw7UAkEPTEUJ5ac/yTp9T08bn9+ZK0t7SPo6BumxUy+Tts0JNQ53GT20ScZApYiD2825dDNMohe1+tM0Zxafng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nh1OfmGAQFZNa3emMqCs8K34bnNisgd/RXB3eEa2bV4=;
 b=Q28brs85YpNoF9yBkS1SlljToFpsV9qQo9hqYvTNqRp+gQzbmyMBqB7cF4LljNZKn69plgH9AIQOJ3YB8M59f/y4BS22ptxTJLl9LBuD35gARI8JCmyvzsYHbbAPWpCjt2DYtvy9coZhtWr6vOMAQY8LPn2VKtCGFwqc0TkMz50bsTnPOv5wELQQcih3Vh2lx9IY8R0HRF6T6ZrNlqvO9uEe9MgxGv1pjj8uuYp3jX2gRGAxsBxE/yT5RQ6gahT7EaYRgeFLwzgsonVrnjtwC1SlftSaEOFNFNJwe1teYmcrnDAOGLZAt4pGWknpUKhQaGiUsl2F1VxwYd9lLDTpWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nh1OfmGAQFZNa3emMqCs8K34bnNisgd/RXB3eEa2bV4=;
 b=DuZqEgbqFiqPBooh8G1rF2pXA9dsJD85pSadSHFB1jrH+ND1y231QuvwPGGGSv0m17RBrbR+/2uwKiApRbrX5SRaSBIKJ9c/qIE/nPE3OodmLX9zUR4gX2nsxtgdCV8sRv2EW+c0+ne9hthHduffUwKzbi6mFNXAKPMBV4G1g1p9gbKw1JlfRFDh3W7sl5ohLs2+8QE7X/BHq9AtHxPIVrbIxmz2zeSbP2+IlBvE2bEC+BeoVYZXdj/EWjkYvwYNckfpO7t6+Dtq9Pc1/aFrgl772D0MtkYvy0+LHkf7iotzSkc/dfJTMJVhrvkOnRWQpYL8+0EMSeEC8fUYa8A3+Q==
Received: from MW4PR04CA0316.namprd04.prod.outlook.com (2603:10b6:303:82::21)
 by DS7PR12MB6190.namprd12.prod.outlook.com (2603:10b6:8:99::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.24; Wed, 27 Jul
 2022 17:47:06 +0000
Received: from CO1NAM11FT044.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:82:cafe::f1) by MW4PR04CA0316.outlook.office365.com
 (2603:10b6:303:82::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.26 via Frontend
 Transport; Wed, 27 Jul 2022 17:47:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT044.mail.protection.outlook.com (10.13.175.188) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5482.10 via Frontend Transport; Wed, 27 Jul 2022 17:47:05 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 27 Jul
 2022 12:46:59 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Wed, 27 Jul 2022 12:46:58 -0500
From:   <ecree@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-net-drivers@amd.com>
CC:     <netdev@vger.kernel.org>, Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH net-next v2 07/14] sfc: insert default MAE rules to connect VFs to representors
Date:   Wed, 27 Jul 2022 18:45:57 +0100
Message-ID: <c40f5d1ae484db8d5c1461f20a9c17f44cdafbc3.1658943677.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1658943677.git.ecree.xilinx@gmail.com>
References: <cover.1658943677.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e825476e-e0eb-44f3-e91c-08da6ff80550
X-MS-TrafficTypeDiagnostic: DS7PR12MB6190:EE_
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BQu06FkkhrPEan4ELWV/GzYc5H4vXd2hGkFiD4u18oQHiIwxPPi6+leMZKXG47Cppp9KlEoi81wfE1ol2ZwLS5JJQFNkKSIIe8QN8jzYWMssgb2ynawxqQ/YQn+Sv6tpcFN+nJGhrRA8sRTWlH3aTYhp5Rx26wpBI+wL8bzv4kcT9r0tRR3TJevi7RvlfQv+73lhA64PQoq8gWNx4iwYt2bOtpQANMZfCDZ2Dm9NAu9MMgKAsvkz64C7B1xHfFEzN9nLgADOhxAlLx9fbB/mW8aaABXE2OC4Sk4c6L44Pd1S+V7nm0w4JlI/e6nh+jLvfKaJQskrHU4iYAhWpFoCG0H2Et4gllxRhA5WEvr6yoOKUU5BHRZYoR5DFnfXI47JU7IacbxGoUyzF2Uw1iFKEt+St6VZ7D86cqYm/BM0rpfrdd3zeyR3wyYuSluTrzJ07KYaSn1pQ7opFBSUF7jbRunyR8PVMSzsfzpgikxzDpOMG0i9+ERlevE5JqXgJu87atvz/TP1ULfTpegsmuu7Ae2bJfdkOZzLzt7wPVnXwLYHw7XZYMtpgYcZjovoauUOcbWsjZSikRsNWdXElAtUNGShZoKneXTb6WMBe9hXGu3m2iHTc+Htbp+ZUg1t2Uwdlwaoy0y/Ip2JF4Iq0+RO8wXcLyPnlDP03Urvo1IDAhCzLIVxmc9qxsjHAXtXe26F3JBoi9SVJ8P++mhH7tRmSDbwINIHY7lnm+2vCIwNuogS90yQXVrKobInK76srbbyvHpVmAk3WCEXQCSW0ieex5HTcmD0XB+ANhgwrasvj4kDQFUDoaawBJIJ+QeOPFwUPGua8qdT4Q7RyP/HAbOK0j3OW1p7n7FRC5MYnv+FX/s=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(136003)(396003)(346002)(376002)(39860400002)(36840700001)(40470700004)(46966006)(40460700003)(55446002)(81166007)(83170400001)(5660300002)(186003)(356005)(83380400001)(36860700001)(336012)(82740400003)(47076005)(36756003)(478600001)(42882007)(316002)(30864003)(8936002)(54906003)(9686003)(40480700001)(110136005)(41300700001)(82310400005)(70206006)(26005)(70586007)(8676002)(2876002)(4326008)(2906002)(2004002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2022 17:47:05.6232
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e825476e-e0eb-44f3-e91c-08da6ff80550
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT044.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6190
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

Default rules are low-priority switching rules which the hardware uses
 in the absence of higher-priority rules.  Each representor requires a
 corresponding rule matching traffic from its representee VF and
 delivering to the PF (where a check on INGRESS_MPORT in
 __ef100_rx_packet() will direct it to the representor).  No rule is
 required in the reverse direction, because representor TX uses a TX
 override descriptor to bypass the MAE and deliver directly to the VF.
Since inserting any rule into the MAE disables the firmware's own
 default rules, also insert a pair of rules to connect the PF to the
 physical network port and vice-versa.

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/Makefile        |   3 +-
 drivers/net/ethernet/sfc/ef100.c         |   3 +
 drivers/net/ethernet/sfc/ef100_netdev.c  |   4 +
 drivers/net/ethernet/sfc/ef100_nic.c     |  17 ++
 drivers/net/ethernet/sfc/ef100_rep.c     |  20 +-
 drivers/net/ethernet/sfc/ef100_rep.h     |   3 +
 drivers/net/ethernet/sfc/mae.c           | 257 ++++++++++++++++++++++-
 drivers/net/ethernet/sfc/mae.h           |  16 ++
 drivers/net/ethernet/sfc/mcdi.h          |   4 +
 drivers/net/ethernet/sfc/mcdi_pcol_mae.h |  24 +++
 drivers/net/ethernet/sfc/net_driver.h    |   2 +
 drivers/net/ethernet/sfc/tc.c            | 183 ++++++++++++++++
 drivers/net/ethernet/sfc/tc.h            |  76 +++++++
 13 files changed, 606 insertions(+), 6 deletions(-)
 create mode 100644 drivers/net/ethernet/sfc/mcdi_pcol_mae.h
 create mode 100644 drivers/net/ethernet/sfc/tc.c
 create mode 100644 drivers/net/ethernet/sfc/tc.h

diff --git a/drivers/net/ethernet/sfc/Makefile b/drivers/net/ethernet/sfc/Makefile
index 4c759488fc77..bb06fa228367 100644
--- a/drivers/net/ethernet/sfc/Makefile
+++ b/drivers/net/ethernet/sfc/Makefile
@@ -8,7 +8,8 @@ sfc-y			+= efx.o efx_common.o efx_channels.o nic.o \
 			   ef100.o ef100_nic.o ef100_netdev.o \
 			   ef100_ethtool.o ef100_rx.o ef100_tx.o
 sfc-$(CONFIG_SFC_MTD)	+= mtd.o
-sfc-$(CONFIG_SFC_SRIOV)	+= sriov.o ef10_sriov.o ef100_sriov.o ef100_rep.o mae.o
+sfc-$(CONFIG_SFC_SRIOV)	+= sriov.o ef10_sriov.o ef100_sriov.o ef100_rep.o \
+                           mae.o tc.o
 
 obj-$(CONFIG_SFC)	+= sfc.o
 
diff --git a/drivers/net/ethernet/sfc/ef100.c b/drivers/net/ethernet/sfc/ef100.c
index 425017fbcb25..71aab3d0480f 100644
--- a/drivers/net/ethernet/sfc/ef100.c
+++ b/drivers/net/ethernet/sfc/ef100.c
@@ -431,6 +431,9 @@ static void ef100_pci_remove(struct pci_dev *pci_dev)
 
 	probe_data = container_of(efx, struct efx_probe_data, efx);
 	ef100_remove_netdev(probe_data);
+#ifdef CONFIG_SFC_SRIOV
+	efx_fini_struct_tc(efx);
+#endif
 
 	ef100_remove(efx);
 	efx_fini_io(efx);
diff --git a/drivers/net/ethernet/sfc/ef100_netdev.c b/drivers/net/ethernet/sfc/ef100_netdev.c
index 9e65de1ab889..17b9d37218cb 100644
--- a/drivers/net/ethernet/sfc/ef100_netdev.c
+++ b/drivers/net/ethernet/sfc/ef100_netdev.c
@@ -329,6 +329,10 @@ void ef100_remove_netdev(struct efx_probe_data *probe_data)
 
 	ef100_unregister_netdev(efx);
 
+#ifdef CONFIG_SFC_SRIOV
+	efx_fini_tc(efx);
+#endif
+
 	down_write(&efx->filter_sem);
 	efx_mcdi_filter_table_remove(efx);
 	up_write(&efx->filter_sem);
diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index 393d6ca4525c..25cd43e3fcf7 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -1094,12 +1094,29 @@ int ef100_probe_netdev_pf(struct efx_nic *efx)
 		return 0;
 
 #ifdef CONFIG_SFC_SRIOV
+	rc = efx_init_struct_tc(efx);
+	if (rc)
+		return rc;
+
 	rc = efx_ef100_get_base_mport(efx);
 	if (rc) {
 		netif_warn(efx, probe, net_dev,
 			   "Failed to probe base mport rc %d; representors will not function\n",
 			   rc);
 	}
+
+	rc = efx_init_tc(efx);
+	if (rc) {
+		/* Either we don't have an MAE at all (i.e. legacy v-switching),
+		 * or we do but we failed to probe it.  In the latter case, we
+		 * may not have set up default rules, in which case we won't be
+		 * able to pass any traffic.  However, we don't fail the probe,
+		 * because the user might need to use the netdevice to apply
+		 * configuration changes to fix whatever's wrong with the MAE.
+		 */
+		netif_warn(efx, probe, net_dev, "Failed to probe MAE rc %d\n",
+			   rc);
+	}
 #endif
 	return 0;
 
diff --git a/drivers/net/ethernet/sfc/ef100_rep.c b/drivers/net/ethernet/sfc/ef100_rep.c
index c0bc12b9e348..eac932710c63 100644
--- a/drivers/net/ethernet/sfc/ef100_rep.c
+++ b/drivers/net/ethernet/sfc/ef100_rep.c
@@ -27,6 +27,8 @@ static int efx_ef100_rep_init_struct(struct efx_nic *efx, struct efx_rep *efv,
 	efv->parent = efx;
 	efv->idx = i;
 	INIT_LIST_HEAD(&efv->list);
+	efv->dflt.fw_id = MC_CMD_MAE_ACTION_RULE_INSERT_OUT_ACTION_RULE_ID_NULL;
+	INIT_LIST_HEAD(&efv->dflt.acts.list);
 	INIT_LIST_HEAD(&efv->rx_list);
 	spin_lock_init(&efv->rx_lock);
 	efv->msg_enable = NETIF_MSG_DRV | NETIF_MSG_PROBE |
@@ -212,7 +214,14 @@ static int efx_ef100_configure_rep(struct efx_rep *efv)
 	/* mport label should fit in 16 bits */
 	WARN_ON(efv->mport >> 16);
 
-	return 0;
+	return efx_tc_configure_default_rule_rep(efv);
+}
+
+static void efx_ef100_deconfigure_rep(struct efx_rep *efv)
+{
+	struct efx_nic *efx = efv->parent;
+
+	efx_tc_deconfigure_default_rule(efx, &efv->dflt);
 }
 
 static void efx_ef100_rep_destroy_netdev(struct efx_rep *efv)
@@ -246,19 +255,21 @@ int efx_ef100_vfrep_create(struct efx_nic *efx, unsigned int i)
 		pci_err(efx->pci_dev,
 			"Failed to configure representor for VF %d, rc %d\n",
 			i, rc);
-		goto fail;
+		goto fail1;
 	}
 	rc = register_netdev(efv->net_dev);
 	if (rc) {
 		pci_err(efx->pci_dev,
 			"Failed to register representor for VF %d, rc %d\n",
 			i, rc);
-		goto fail;
+		goto fail2;
 	}
 	pci_dbg(efx->pci_dev, "Representor for VF %d is %s\n", i,
 		efv->net_dev->name);
 	return 0;
-fail:
+fail2:
+	efx_ef100_deconfigure_rep(efv);
+fail1:
 	efx_ef100_rep_destroy_netdev(efv);
 	return rc;
 }
@@ -272,6 +283,7 @@ void efx_ef100_vfrep_destroy(struct efx_nic *efx, struct efx_rep *efv)
 		return;
 	netif_dbg(efx, drv, rep_dev, "Removing VF representor\n");
 	unregister_netdev(rep_dev);
+	efx_ef100_deconfigure_rep(efv);
 	efx_ef100_rep_destroy_netdev(efv);
 }
 
diff --git a/drivers/net/ethernet/sfc/ef100_rep.h b/drivers/net/ethernet/sfc/ef100_rep.h
index f3787133f793..070f700893c1 100644
--- a/drivers/net/ethernet/sfc/ef100_rep.h
+++ b/drivers/net/ethernet/sfc/ef100_rep.h
@@ -14,6 +14,7 @@
 #define EF100_REP_H
 
 #include "net_driver.h"
+#include "tc.h"
 
 struct efx_rep_sw_stats {
 	atomic64_t rx_packets, tx_packets;
@@ -32,6 +33,7 @@ struct efx_rep_sw_stats {
  * @write_index: number of packets enqueued to @rx_list
  * @read_index: number of packets consumed from @rx_list
  * @rx_pring_size: max length of RX list
+ * @dflt: default-rule for MAE switching
  * @list: entry on efx->vf_reps
  * @rx_list: list of SKBs queued for receive in NAPI poll
  * @rx_lock: protects @rx_list
@@ -46,6 +48,7 @@ struct efx_rep {
 	unsigned int idx;
 	unsigned int write_index, read_index;
 	unsigned int rx_pring_size;
+	struct efx_tc_flow_rule dflt;
 	struct list_head list;
 	struct list_head rx_list;
 	spinlock_t rx_lock;
diff --git a/drivers/net/ethernet/sfc/mae.c b/drivers/net/ethernet/sfc/mae.c
index 0cbcadde6677..ea87ec83e618 100644
--- a/drivers/net/ethernet/sfc/mae.c
+++ b/drivers/net/ethernet/sfc/mae.c
@@ -11,7 +11,7 @@
 
 #include "mae.h"
 #include "mcdi.h"
-#include "mcdi_pcol.h"
+#include "mcdi_pcol_mae.h"
 
 void efx_mae_mport_wire(struct efx_nic *efx, u32 *out)
 {
@@ -23,6 +23,17 @@ void efx_mae_mport_wire(struct efx_nic *efx, u32 *out)
 	*out = EFX_DWORD_VAL(mport);
 }
 
+void efx_mae_mport_uplink(struct efx_nic *efx __always_unused, u32 *out)
+{
+	efx_dword_t mport;
+
+	EFX_POPULATE_DWORD_3(mport,
+			     MAE_MPORT_SELECTOR_TYPE, MAE_MPORT_SELECTOR_TYPE_FUNC,
+			     MAE_MPORT_SELECTOR_FUNC_PF_ID, MAE_MPORT_SELECTOR_FUNC_PF_ID_CALLER,
+			     MAE_MPORT_SELECTOR_FUNC_VF_ID, MAE_MPORT_SELECTOR_FUNC_VF_ID_NULL);
+	*out = EFX_DWORD_VAL(mport);
+}
+
 void efx_mae_mport_vf(struct efx_nic *efx __always_unused, u32 vf_id, u32 *out)
 {
 	efx_dword_t mport;
@@ -34,6 +45,17 @@ void efx_mae_mport_vf(struct efx_nic *efx __always_unused, u32 vf_id, u32 *out)
 	*out = EFX_DWORD_VAL(mport);
 }
 
+/* Constructs an mport selector from an mport ID, because they're not the same */
+void efx_mae_mport_mport(struct efx_nic *efx __always_unused, u32 mport_id, u32 *out)
+{
+	efx_dword_t mport;
+
+	EFX_POPULATE_DWORD_2(mport,
+			     MAE_MPORT_SELECTOR_TYPE, MAE_MPORT_SELECTOR_TYPE_MPORT_ID,
+			     MAE_MPORT_SELECTOR_MPORT_ID, mport_id);
+	*out = EFX_DWORD_VAL(mport);
+}
+
 /* id is really only 24 bits wide */
 int efx_mae_lookup_mport(struct efx_nic *efx, u32 selector, u32 *id)
 {
@@ -52,3 +74,236 @@ int efx_mae_lookup_mport(struct efx_nic *efx, u32 selector, u32 *id)
 	*id = MCDI_DWORD(outbuf, MAE_MPORT_LOOKUP_OUT_MPORT_ID);
 	return 0;
 }
+
+static bool efx_mae_asl_id(u32 id)
+{
+	return !!(id & BIT(31));
+}
+
+int efx_mae_alloc_action_set(struct efx_nic *efx, struct efx_tc_action_set *act)
+{
+	MCDI_DECLARE_BUF(outbuf, MC_CMD_MAE_ACTION_SET_ALLOC_OUT_LEN);
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_MAE_ACTION_SET_ALLOC_IN_LEN);
+	size_t outlen;
+	int rc;
+
+	MCDI_SET_DWORD(inbuf, MAE_ACTION_SET_ALLOC_IN_SRC_MAC_ID,
+		       MC_CMD_MAE_MAC_ADDR_ALLOC_OUT_MAC_ID_NULL);
+	MCDI_SET_DWORD(inbuf, MAE_ACTION_SET_ALLOC_IN_DST_MAC_ID,
+		       MC_CMD_MAE_MAC_ADDR_ALLOC_OUT_MAC_ID_NULL);
+	MCDI_SET_DWORD(inbuf, MAE_ACTION_SET_ALLOC_IN_COUNTER_ID,
+		       MC_CMD_MAE_COUNTER_ALLOC_OUT_COUNTER_ID_NULL);
+	MCDI_SET_DWORD(inbuf, MAE_ACTION_SET_ALLOC_IN_COUNTER_LIST_ID,
+		       MC_CMD_MAE_COUNTER_LIST_ALLOC_OUT_COUNTER_LIST_ID_NULL);
+	MCDI_SET_DWORD(inbuf, MAE_ACTION_SET_ALLOC_IN_ENCAP_HEADER_ID,
+		       MC_CMD_MAE_ENCAP_HEADER_ALLOC_OUT_ENCAP_HEADER_ID_NULL);
+	if (act->deliver)
+		MCDI_SET_DWORD(inbuf, MAE_ACTION_SET_ALLOC_IN_DELIVER,
+			       act->dest_mport);
+	BUILD_BUG_ON(MAE_MPORT_SELECTOR_NULL);
+	rc = efx_mcdi_rpc(efx, MC_CMD_MAE_ACTION_SET_ALLOC, inbuf, sizeof(inbuf),
+			  outbuf, sizeof(outbuf), &outlen);
+	if (rc)
+		return rc;
+	if (outlen < sizeof(outbuf))
+		return -EIO;
+	act->fw_id = MCDI_DWORD(outbuf, MAE_ACTION_SET_ALLOC_OUT_AS_ID);
+	/* We rely on the high bit of AS IDs always being clear.
+	 * The firmware API guarantees this, but let's check it ourselves.
+	 */
+	if (WARN_ON_ONCE(efx_mae_asl_id(act->fw_id))) {
+		efx_mae_free_action_set(efx, act->fw_id);
+		return -EIO;
+	}
+	return 0;
+}
+
+int efx_mae_free_action_set(struct efx_nic *efx, u32 fw_id)
+{
+	MCDI_DECLARE_BUF(outbuf, MC_CMD_MAE_ACTION_SET_FREE_OUT_LEN(1));
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_MAE_ACTION_SET_FREE_IN_LEN(1));
+	size_t outlen;
+	int rc;
+
+	MCDI_SET_DWORD(inbuf, MAE_ACTION_SET_FREE_IN_AS_ID, fw_id);
+	rc = efx_mcdi_rpc(efx, MC_CMD_MAE_ACTION_SET_FREE, inbuf, sizeof(inbuf),
+			  outbuf, sizeof(outbuf), &outlen);
+	if (rc)
+		return rc;
+	if (outlen < sizeof(outbuf))
+		return -EIO;
+	/* FW freed a different ID than we asked for, should never happen.
+	 * Warn because it means we've now got a different idea to the FW of
+	 * what action-sets exist, which could cause mayhem later.
+	 */
+	if (WARN_ON(MCDI_DWORD(outbuf, MAE_ACTION_SET_FREE_OUT_FREED_AS_ID) != fw_id))
+		return -EIO;
+	return 0;
+}
+
+int efx_mae_alloc_action_set_list(struct efx_nic *efx,
+				  struct efx_tc_action_set_list *acts)
+{
+	MCDI_DECLARE_BUF(outbuf, MC_CMD_MAE_ACTION_SET_LIST_ALLOC_OUT_LEN);
+	struct efx_tc_action_set *act;
+	size_t inlen, outlen, i = 0;
+	efx_dword_t *inbuf;
+	int rc;
+
+	list_for_each_entry(act, &acts->list, list)
+		i++;
+	if (i == 0)
+		return -EINVAL;
+	if (i == 1) {
+		/* Don't wrap an ASL around a single AS, just use the AS_ID
+		 * directly.  ASLs are a more limited resource.
+		 */
+		act = list_first_entry(&acts->list, struct efx_tc_action_set, list);
+		acts->fw_id = act->fw_id;
+		return 0;
+	}
+	if (i > MC_CMD_MAE_ACTION_SET_LIST_ALLOC_IN_AS_IDS_MAXNUM_MCDI2)
+		return -EOPNOTSUPP; /* Too many actions */
+	inlen = MC_CMD_MAE_ACTION_SET_LIST_ALLOC_IN_LEN(i);
+	inbuf = kzalloc(inlen, GFP_KERNEL);
+	if (!inbuf)
+		return -ENOMEM;
+	i = 0;
+	list_for_each_entry(act, &acts->list, list) {
+		MCDI_SET_ARRAY_DWORD(inbuf, MAE_ACTION_SET_LIST_ALLOC_IN_AS_IDS,
+				     i, act->fw_id);
+		i++;
+	}
+	MCDI_SET_DWORD(inbuf, MAE_ACTION_SET_LIST_ALLOC_IN_COUNT, i);
+	rc = efx_mcdi_rpc(efx, MC_CMD_MAE_ACTION_SET_LIST_ALLOC, inbuf, inlen,
+			  outbuf, sizeof(outbuf), &outlen);
+	if (rc)
+		goto out_free;
+	if (outlen < sizeof(outbuf)) {
+		rc = -EIO;
+		goto out_free;
+	}
+	acts->fw_id = MCDI_DWORD(outbuf, MAE_ACTION_SET_LIST_ALLOC_OUT_ASL_ID);
+	/* We rely on the high bit of ASL IDs always being set.
+	 * The firmware API guarantees this, but let's check it ourselves.
+	 */
+	if (WARN_ON_ONCE(!efx_mae_asl_id(acts->fw_id))) {
+		efx_mae_free_action_set_list(efx, acts);
+		rc = -EIO;
+	}
+out_free:
+	kfree(inbuf);
+	return rc;
+}
+
+int efx_mae_free_action_set_list(struct efx_nic *efx,
+				 struct efx_tc_action_set_list *acts)
+{
+	MCDI_DECLARE_BUF(outbuf, MC_CMD_MAE_ACTION_SET_LIST_FREE_OUT_LEN(1));
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_MAE_ACTION_SET_LIST_FREE_IN_LEN(1));
+	size_t outlen;
+	int rc;
+
+	/* If this is just an AS_ID with no ASL wrapper, then there is
+	 * nothing for us to free.  (The AS will be freed later.)
+	 */
+	if (efx_mae_asl_id(acts->fw_id)) {
+		MCDI_SET_DWORD(inbuf, MAE_ACTION_SET_LIST_FREE_IN_ASL_ID,
+			       acts->fw_id);
+		rc = efx_mcdi_rpc(efx, MC_CMD_MAE_ACTION_SET_LIST_FREE, inbuf,
+				  sizeof(inbuf), outbuf, sizeof(outbuf), &outlen);
+		if (rc)
+			return rc;
+		if (outlen < sizeof(outbuf))
+			return -EIO;
+		/* FW freed a different ID than we asked for, should never happen.
+		 * Warn because it means we've now got a different idea to the FW of
+		 * what action-set-lists exist, which could cause mayhem later.
+		 */
+		if (WARN_ON(MCDI_DWORD(outbuf, MAE_ACTION_SET_LIST_FREE_OUT_FREED_ASL_ID) != acts->fw_id))
+			return -EIO;
+	}
+	/* We're probably about to free @acts, but let's just make sure its
+	 * fw_id is blatted so that it won't look valid if it leaks out.
+	 */
+	acts->fw_id = MC_CMD_MAE_ACTION_SET_LIST_ALLOC_OUT_ACTION_SET_LIST_ID_NULL;
+	return 0;
+}
+
+static int efx_mae_populate_match_criteria(MCDI_DECLARE_STRUCT_PTR(match_crit),
+					   const struct efx_tc_match *match)
+{
+	if (match->mask.ingress_port) {
+		if (~match->mask.ingress_port)
+			return -EOPNOTSUPP;
+		MCDI_STRUCT_SET_DWORD(match_crit,
+				      MAE_FIELD_MASK_VALUE_PAIRS_V2_INGRESS_MPORT_SELECTOR,
+				      match->value.ingress_port);
+	}
+	MCDI_STRUCT_SET_DWORD(match_crit, MAE_FIELD_MASK_VALUE_PAIRS_V2_INGRESS_MPORT_SELECTOR_MASK,
+			      match->mask.ingress_port);
+	return 0;
+}
+
+int efx_mae_insert_rule(struct efx_nic *efx, const struct efx_tc_match *match,
+			u32 prio, u32 acts_id, u32 *id)
+{
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_MAE_ACTION_RULE_INSERT_IN_LEN(MAE_FIELD_MASK_VALUE_PAIRS_V2_LEN));
+	MCDI_DECLARE_BUF(outbuf, MC_CMD_MAE_ACTION_RULE_INSERT_OUT_LEN);
+	MCDI_DECLARE_STRUCT_PTR(match_crit);
+	MCDI_DECLARE_STRUCT_PTR(response);
+	size_t outlen;
+	int rc;
+
+	if (!id)
+		return -EINVAL;
+
+	match_crit = _MCDI_DWORD(inbuf, MAE_ACTION_RULE_INSERT_IN_MATCH_CRITERIA);
+	response = _MCDI_DWORD(inbuf, MAE_ACTION_RULE_INSERT_IN_RESPONSE);
+	if (efx_mae_asl_id(acts_id)) {
+		MCDI_STRUCT_SET_DWORD(response, MAE_ACTION_RULE_RESPONSE_ASL_ID, acts_id);
+		MCDI_STRUCT_SET_DWORD(response, MAE_ACTION_RULE_RESPONSE_AS_ID,
+				      MC_CMD_MAE_ACTION_SET_ALLOC_OUT_ACTION_SET_ID_NULL);
+	} else {
+		/* We only had one AS, so we didn't wrap it in an ASL */
+		MCDI_STRUCT_SET_DWORD(response, MAE_ACTION_RULE_RESPONSE_ASL_ID,
+				      MC_CMD_MAE_ACTION_SET_LIST_ALLOC_OUT_ACTION_SET_LIST_ID_NULL);
+		MCDI_STRUCT_SET_DWORD(response, MAE_ACTION_RULE_RESPONSE_AS_ID, acts_id);
+	}
+	MCDI_SET_DWORD(inbuf, MAE_ACTION_RULE_INSERT_IN_PRIO, prio);
+	rc = efx_mae_populate_match_criteria(match_crit, match);
+	if (rc)
+		return rc;
+
+	rc = efx_mcdi_rpc(efx, MC_CMD_MAE_ACTION_RULE_INSERT, inbuf, sizeof(inbuf),
+			  outbuf, sizeof(outbuf), &outlen);
+	if (rc)
+		return rc;
+	if (outlen < sizeof(outbuf))
+		return -EIO;
+	*id = MCDI_DWORD(outbuf, MAE_ACTION_RULE_INSERT_OUT_AR_ID);
+	return 0;
+}
+
+int efx_mae_delete_rule(struct efx_nic *efx, u32 id)
+{
+	MCDI_DECLARE_BUF(outbuf, MC_CMD_MAE_ACTION_RULE_DELETE_OUT_LEN(1));
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_MAE_ACTION_RULE_DELETE_IN_LEN(1));
+	size_t outlen;
+	int rc;
+
+	MCDI_SET_DWORD(inbuf, MAE_ACTION_RULE_DELETE_IN_AR_ID, id);
+	rc = efx_mcdi_rpc(efx, MC_CMD_MAE_ACTION_RULE_DELETE, inbuf, sizeof(inbuf),
+			  outbuf, sizeof(outbuf), &outlen);
+	if (rc)
+		return rc;
+	if (outlen < sizeof(outbuf))
+		return -EIO;
+	/* FW freed a different ID than we asked for, should also never happen.
+	 * Warn because it means we've now got a different idea to the FW of
+	 * what rules exist, which could cause mayhem later.
+	 */
+	if (WARN_ON(MCDI_DWORD(outbuf, MAE_ACTION_RULE_DELETE_OUT_DELETED_AR_ID) != id))
+		return -EIO;
+	return 0;
+}
diff --git a/drivers/net/ethernet/sfc/mae.h b/drivers/net/ethernet/sfc/mae.h
index 25c2fd94e158..e9651f611750 100644
--- a/drivers/net/ethernet/sfc/mae.h
+++ b/drivers/net/ethernet/sfc/mae.h
@@ -14,10 +14,26 @@
 /* MCDI interface for the ef100 Match-Action Engine */
 
 #include "net_driver.h"
+#include "tc.h"
+#include "mcdi_pcol.h" /* needed for various MC_CMD_MAE_*_NULL defines */
 
 void efx_mae_mport_wire(struct efx_nic *efx, u32 *out);
+void efx_mae_mport_uplink(struct efx_nic *efx, u32 *out);
 void efx_mae_mport_vf(struct efx_nic *efx, u32 vf_id, u32 *out);
+void efx_mae_mport_mport(struct efx_nic *efx, u32 mport_id, u32 *out);
 
 int efx_mae_lookup_mport(struct efx_nic *efx, u32 selector, u32 *id);
 
+int efx_mae_alloc_action_set(struct efx_nic *efx, struct efx_tc_action_set *act);
+int efx_mae_free_action_set(struct efx_nic *efx, u32 fw_id);
+
+int efx_mae_alloc_action_set_list(struct efx_nic *efx,
+				  struct efx_tc_action_set_list *acts);
+int efx_mae_free_action_set_list(struct efx_nic *efx,
+				 struct efx_tc_action_set_list *acts);
+
+int efx_mae_insert_rule(struct efx_nic *efx, const struct efx_tc_match *match,
+			u32 prio, u32 acts_id, u32 *id);
+int efx_mae_delete_rule(struct efx_nic *efx, u32 id);
+
 #endif /* EF100_MAE_H */
diff --git a/drivers/net/ethernet/sfc/mcdi.h b/drivers/net/ethernet/sfc/mcdi.h
index f74f6ce8b27d..26bc69f76801 100644
--- a/drivers/net/ethernet/sfc/mcdi.h
+++ b/drivers/net/ethernet/sfc/mcdi.h
@@ -205,6 +205,8 @@ void efx_mcdi_sensor_event(struct efx_nic *efx, efx_qword_t *ev);
 	((_ofst) + BUILD_BUG_ON_ZERO((_ofst) & (_align - 1)))
 #define _MCDI_DWORD(_buf, _field)					\
 	((_buf) + (_MCDI_CHECK_ALIGN(MC_CMD_ ## _field ## _OFST, 4) >> 2))
+#define _MCDI_STRUCT_DWORD(_buf, _field)				\
+	((_buf) + (_MCDI_CHECK_ALIGN(_field ## _OFST, 4) >> 2))
 
 #define MCDI_BYTE(_buf, _field)						\
 	((void)BUILD_BUG_ON_ZERO(MC_CMD_ ## _field ## _LEN != 1),	\
@@ -214,6 +216,8 @@ void efx_mcdi_sensor_event(struct efx_nic *efx, efx_qword_t *ev);
 	 le16_to_cpu(*(__force const __le16 *)MCDI_PTR(_buf, _field)))
 #define MCDI_SET_DWORD(_buf, _field, _value)				\
 	EFX_POPULATE_DWORD_1(*_MCDI_DWORD(_buf, _field), EFX_DWORD_0, _value)
+#define MCDI_STRUCT_SET_DWORD(_buf, _field, _value)			\
+	EFX_POPULATE_DWORD_1(*_MCDI_STRUCT_DWORD(_buf, _field), EFX_DWORD_0, _value)
 #define MCDI_DWORD(_buf, _field)					\
 	EFX_DWORD_FIELD(*_MCDI_DWORD(_buf, _field), EFX_DWORD_0)
 #define MCDI_POPULATE_DWORD_1(_buf, _field, _name1, _value1)		\
diff --git a/drivers/net/ethernet/sfc/mcdi_pcol_mae.h b/drivers/net/ethernet/sfc/mcdi_pcol_mae.h
new file mode 100644
index 000000000000..ff6d80c8e486
--- /dev/null
+++ b/drivers/net/ethernet/sfc/mcdi_pcol_mae.h
@@ -0,0 +1,24 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/****************************************************************************
+ * Driver for Solarflare network controllers and boards
+ * Copyright 2019 Solarflare Communications Inc.
+ * Copyright 2019-2022 Xilinx, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation, incorporated herein by reference.
+ */
+
+#ifndef MCDI_PCOL_MAE_H
+#define MCDI_PCOL_MAE_H
+/* MCDI definitions for Match-Action Engine functionality, that are
+ * missing from the main mcdi_pcol.h
+ */
+
+/* MC_CMD_MAE_COUNTER_LIST_ALLOC is not (yet) a released API, but the
+ * following value is needed as an argument to MC_CMD_MAE_ACTION_SET_ALLOC.
+ */
+/* enum: A counter ID that is guaranteed never to represent a real counter */
+#define          MC_CMD_MAE_COUNTER_LIST_ALLOC_OUT_COUNTER_LIST_ID_NULL 0xffffffff
+
+#endif /* MCDI_PCOL_MAE_H */
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index 6b64ba3a7d36..7ef823d7a89a 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -978,6 +978,7 @@ enum efx_xdp_tx_queues_mode {
  * @xdp_rxq_info_failed: Have any of the rx queues failed to initialise their
  *      xdp_rxq_info structures?
  * @netdev_notifier: Netdevice notifier.
+ * @tc: state for TC offload (EF100).
  * @mem_bar: The BAR that is mapped into membase.
  * @reg_base: Offset from the start of the bar to the function control window.
  * @monitor_work: Hardware monitor workitem
@@ -1161,6 +1162,7 @@ struct efx_nic {
 	bool xdp_rxq_info_failed;
 
 	struct notifier_block netdev_notifier;
+	struct efx_tc_state *tc;
 
 	unsigned int mem_bar;
 	u32 reg_base;
diff --git a/drivers/net/ethernet/sfc/tc.c b/drivers/net/ethernet/sfc/tc.c
new file mode 100644
index 000000000000..0fb01f73c56e
--- /dev/null
+++ b/drivers/net/ethernet/sfc/tc.c
@@ -0,0 +1,183 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/****************************************************************************
+ * Driver for Solarflare network controllers and boards
+ * Copyright 2019 Solarflare Communications Inc.
+ * Copyright 2020-2022 Xilinx Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation, incorporated herein by reference.
+ */
+
+#include "tc.h"
+#include "mae.h"
+#include "ef100_rep.h"
+
+static void efx_tc_free_action_set(struct efx_nic *efx,
+				   struct efx_tc_action_set *act, bool in_hw)
+{
+	/* Failure paths calling this on the 'running action' set in_hw=false,
+	 * because if the alloc had succeeded we'd've put it in acts.list and
+	 * not still have it in act.
+	 */
+	if (in_hw) {
+		efx_mae_free_action_set(efx, act->fw_id);
+		/* in_hw is true iff we are on an acts.list; make sure to
+		 * remove ourselves from that list before we are freed.
+		 */
+		list_del(&act->list);
+	}
+	kfree(act);
+}
+
+static void efx_tc_free_action_set_list(struct efx_nic *efx,
+					struct efx_tc_action_set_list *acts,
+					bool in_hw)
+{
+	struct efx_tc_action_set *act, *next;
+
+	/* Failure paths set in_hw=false, because usually the acts didn't get
+	 * to efx_mae_alloc_action_set_list(); if they did, the failure tree
+	 * has a separate efx_mae_free_action_set_list() before calling us.
+	 */
+	if (in_hw)
+		efx_mae_free_action_set_list(efx, acts);
+	/* Any act that's on the list will be in_hw even if the list isn't */
+	list_for_each_entry_safe(act, next, &acts->list, list)
+		efx_tc_free_action_set(efx, act, true);
+	/* Don't kfree, as acts is embedded inside a struct efx_tc_flow_rule */
+}
+
+static void efx_tc_delete_rule(struct efx_nic *efx, struct efx_tc_flow_rule *rule)
+{
+	efx_mae_delete_rule(efx, rule->fw_id);
+
+	/* Release entries in subsidiary tables */
+	efx_tc_free_action_set_list(efx, &rule->acts, true);
+	rule->fw_id = MC_CMD_MAE_ACTION_RULE_INSERT_OUT_ACTION_RULE_ID_NULL;
+}
+
+static int efx_tc_configure_default_rule(struct efx_nic *efx, u32 ing_port,
+					 u32 eg_port, struct efx_tc_flow_rule *rule)
+{
+	struct efx_tc_action_set_list *acts = &rule->acts;
+	struct efx_tc_match *match = &rule->match;
+	struct efx_tc_action_set *act;
+	int rc;
+
+	match->value.ingress_port = ing_port;
+	match->mask.ingress_port = ~0;
+	act = kzalloc(sizeof(*act), GFP_KERNEL);
+	if (!act)
+		return -ENOMEM;
+	act->deliver = 1;
+	act->dest_mport = eg_port;
+	rc = efx_mae_alloc_action_set(efx, act);
+	if (rc)
+		goto fail1;
+	EFX_WARN_ON_PARANOID(!list_empty(&acts->list));
+	list_add_tail(&act->list, &acts->list);
+	rc = efx_mae_alloc_action_set_list(efx, acts);
+	if (rc)
+		goto fail2;
+	rc = efx_mae_insert_rule(efx, match, EFX_TC_PRIO_DFLT,
+				 acts->fw_id, &rule->fw_id);
+	if (rc)
+		goto fail3;
+	return 0;
+fail3:
+	efx_mae_free_action_set_list(efx, acts);
+fail2:
+	list_del(&act->list);
+	efx_mae_free_action_set(efx, act->fw_id);
+fail1:
+	kfree(act);
+	return rc;
+}
+
+static int efx_tc_configure_default_rule_pf(struct efx_nic *efx)
+{
+	struct efx_tc_flow_rule *rule = &efx->tc->dflt.pf;
+	u32 ing_port, eg_port;
+
+	efx_mae_mport_uplink(efx, &ing_port);
+	efx_mae_mport_wire(efx, &eg_port);
+	return efx_tc_configure_default_rule(efx, ing_port, eg_port, rule);
+}
+
+static int efx_tc_configure_default_rule_wire(struct efx_nic *efx)
+{
+	struct efx_tc_flow_rule *rule = &efx->tc->dflt.wire;
+	u32 ing_port, eg_port;
+
+	efx_mae_mport_wire(efx, &ing_port);
+	efx_mae_mport_uplink(efx, &eg_port);
+	return efx_tc_configure_default_rule(efx, ing_port, eg_port, rule);
+}
+
+int efx_tc_configure_default_rule_rep(struct efx_rep *efv)
+{
+	struct efx_tc_flow_rule *rule = &efv->dflt;
+	struct efx_nic *efx = efv->parent;
+	u32 ing_port, eg_port;
+
+	efx_mae_mport_mport(efx, efv->mport, &ing_port);
+	efx_mae_mport_uplink(efx, &eg_port);
+	return efx_tc_configure_default_rule(efx, ing_port, eg_port, rule);
+}
+
+void efx_tc_deconfigure_default_rule(struct efx_nic *efx,
+				     struct efx_tc_flow_rule *rule)
+{
+	if (rule->fw_id != MC_CMD_MAE_ACTION_RULE_INSERT_OUT_ACTION_RULE_ID_NULL)
+		efx_tc_delete_rule(efx, rule);
+	rule->fw_id = MC_CMD_MAE_ACTION_RULE_INSERT_OUT_ACTION_RULE_ID_NULL;
+}
+
+int efx_init_tc(struct efx_nic *efx)
+{
+	int rc;
+
+	rc = efx_tc_configure_default_rule_pf(efx);
+	if (rc)
+		return rc;
+	return efx_tc_configure_default_rule_wire(efx);
+}
+
+void efx_fini_tc(struct efx_nic *efx)
+{
+	/* We can get called even if efx_init_struct_tc() failed */
+	if (!efx->tc)
+		return;
+	efx_tc_deconfigure_default_rule(efx, &efx->tc->dflt.pf);
+	efx_tc_deconfigure_default_rule(efx, &efx->tc->dflt.wire);
+}
+
+int efx_init_struct_tc(struct efx_nic *efx)
+{
+	if (efx->type->is_vf)
+		return 0;
+
+	efx->tc = kzalloc(sizeof(*efx->tc), GFP_KERNEL);
+	if (!efx->tc)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&efx->tc->dflt.pf.acts.list);
+	efx->tc->dflt.pf.fw_id = MC_CMD_MAE_ACTION_RULE_INSERT_OUT_ACTION_RULE_ID_NULL;
+	INIT_LIST_HEAD(&efx->tc->dflt.wire.acts.list);
+	efx->tc->dflt.wire.fw_id = MC_CMD_MAE_ACTION_RULE_INSERT_OUT_ACTION_RULE_ID_NULL;
+	return 0;
+}
+
+void efx_fini_struct_tc(struct efx_nic *efx)
+{
+	if (!efx->tc)
+		return;
+
+	EFX_WARN_ON_PARANOID(efx->tc->dflt.pf.fw_id !=
+			     MC_CMD_MAE_ACTION_RULE_INSERT_OUT_ACTION_RULE_ID_NULL);
+	EFX_WARN_ON_PARANOID(efx->tc->dflt.wire.fw_id !=
+			     MC_CMD_MAE_ACTION_RULE_INSERT_OUT_ACTION_RULE_ID_NULL);
+	kfree(efx->tc);
+	efx->tc = NULL;
+}
diff --git a/drivers/net/ethernet/sfc/tc.h b/drivers/net/ethernet/sfc/tc.h
new file mode 100644
index 000000000000..46c5101eaa8d
--- /dev/null
+++ b/drivers/net/ethernet/sfc/tc.h
@@ -0,0 +1,76 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/****************************************************************************
+ * Driver for Solarflare network controllers and boards
+ * Copyright 2019 Solarflare Communications Inc.
+ * Copyright 2020-2022 Xilinx Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation, incorporated herein by reference.
+ */
+
+#ifndef EFX_TC_H
+#define EFX_TC_H
+#include "net_driver.h"
+
+struct efx_tc_action_set {
+	u16 deliver:1;
+	u32 dest_mport;
+	u32 fw_id; /* index of this entry in firmware actions table */
+	struct list_head list;
+};
+
+struct efx_tc_match_fields {
+	/* L1 */
+	u32 ingress_port;
+};
+
+struct efx_tc_match {
+	struct efx_tc_match_fields value;
+	struct efx_tc_match_fields mask;
+};
+
+struct efx_tc_action_set_list {
+	struct list_head list;
+	u32 fw_id;
+};
+
+struct efx_tc_flow_rule {
+	struct efx_tc_match match;
+	struct efx_tc_action_set_list acts;
+	u32 fw_id;
+};
+
+enum efx_tc_rule_prios {
+	EFX_TC_PRIO_DFLT, /* Default switch rule; one of efx_tc_default_rules */
+	EFX_TC_PRIO__NUM
+};
+
+/**
+ * struct efx_tc_state - control plane data for TC offload
+ *
+ * @dflt: Match-action rules for default switching; at priority
+ *	%EFX_TC_PRIO_DFLT.  Named by *ingress* port
+ * @dflt.pf: rule for traffic ingressing from PF (egresses to wire)
+ * @dflt.wire: rule for traffic ingressing from wire (egresses to PF)
+ */
+struct efx_tc_state {
+	struct {
+		struct efx_tc_flow_rule pf;
+		struct efx_tc_flow_rule wire;
+	} dflt;
+};
+
+struct efx_rep;
+
+int efx_tc_configure_default_rule_rep(struct efx_rep *efv);
+void efx_tc_deconfigure_default_rule(struct efx_nic *efx,
+				     struct efx_tc_flow_rule *rule);
+
+int efx_init_tc(struct efx_nic *efx);
+void efx_fini_tc(struct efx_nic *efx);
+
+int efx_init_struct_tc(struct efx_nic *efx);
+void efx_fini_struct_tc(struct efx_nic *efx);
+
+#endif /* EFX_TC_H */
