Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2768B6978B9
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 10:10:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233696AbjBOJKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 04:10:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233656AbjBOJJ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 04:09:59 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2074.outbound.protection.outlook.com [40.107.243.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A21FB36FE3;
        Wed, 15 Feb 2023 01:09:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hI7sSxJERdZP6IIhS22SVT1kBEJZVX9BTfT3N53NXez7wC6dUfUe4XaFs90/H7OqL6HmwNLVNBkP+2AkK21DuW/mhhN97mzqwwp6YCdF/rlMQOL0XaKTtZtQtHCSN6DCTWAJ+nL4zJkPXFxQeje8sJLtlQ3QqY4oYKwgu5aEXRa/CLFbAYFxvR/mmL4t53w0f/gb78lmTqQpQqD1YWii9Sm3mG3+AbROW1azty47+P8J3bZf65BHMp9jDT8cD3kezezi1DThXw1J6+/Jvjr6Onupac+5CAkz8tvKk0XY77noIb3bEZ6nOVI+imI04aqNg5e0kl+HWmrHA/m9mMRARA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fCc1jtUVNkkn9i1rx+fsumy2mNjIZQG9gFDrd+j/E84=;
 b=X7LYvuTLGKnTO6wNoFV5sT06eShgKmpC0Kvxw/EZuK/rWDWRf6Vio3750uz3giOpPIjuNe137X3/H5wzEoS4a1vFKTLNNB+r9DsCIVwuA7NyFwb11AV4l8wnrIB60gw7r0fVAY2vI9SqGOOe+QLo19L/5V5qyobpjYz7Hx0ipSgRqsDL1RZDkJivYWZVIb9w0mPoWmPruwLluiPBeNz4b0mjB9fnu4gQmm5O/rGQODPgkwdaniFnSrTuM4aE4Z4rbyV1S/x6ghDJpXwXQC3nbb0CilIWu84HvSJLgQZYQD8nrDs0exP3a34+scGiLtvXIkF2pILcw5i+3cclAJDQbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fCc1jtUVNkkn9i1rx+fsumy2mNjIZQG9gFDrd+j/E84=;
 b=iCP7BgkiBqf1dKVi26yetXBJVmRzFb/WILbRK/LtjgF9/7XOyZ/8FWBIk4tiF2P4x6Nexpu8rH/kCSXB5gaxFUSOKmB8STP1RH+Um4O+kiYoS+smtQneI1QTsccoZuXn6ltapOv0ZMhs5pqgaNuXEknlbsxALjroilz9DG5i+Fw=
Received: from DM6PR06CA0025.namprd06.prod.outlook.com (2603:10b6:5:120::38)
 by SA1PR12MB8144.namprd12.prod.outlook.com (2603:10b6:806:337::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Wed, 15 Feb
 2023 09:09:41 +0000
Received: from DS1PEPF0000E632.namprd02.prod.outlook.com
 (2603:10b6:5:120:cafe::95) by DM6PR06CA0025.outlook.office365.com
 (2603:10b6:5:120::38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26 via Frontend
 Transport; Wed, 15 Feb 2023 09:09:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF0000E632.mail.protection.outlook.com (10.167.17.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6111.8 via Frontend Transport; Wed, 15 Feb 2023 09:09:41 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 15 Feb
 2023 03:09:11 -0600
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 15 Feb
 2023 01:08:58 -0800
Received: from xcbalucerop41x.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34 via Frontend Transport; Wed, 15 Feb 2023 03:08:56 -0600
From:   <alejandro.lucero-palau@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        <ecree.xilinx@gmail.com>, <linux-doc@vger.kernel.org>,
        <corbet@lwn.net>, <jiri@nvidia.com>,
        "Alejandro Lucero" <alejandro.lucero-palau@amd.com>
Subject: [PATCH v8 net-next 5/8] sfc: add devlink port support for ef100
Date:   Wed, 15 Feb 2023 09:08:25 +0000
Message-ID: <20230215090828.11697-6-alejandro.lucero-palau@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230215090828.11697-1-alejandro.lucero-palau@amd.com>
References: <20230215090828.11697-1-alejandro.lucero-palau@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E632:EE_|SA1PR12MB8144:EE_
X-MS-Office365-Filtering-Correlation-Id: 55f359de-4482-4e22-6b15-08db0f345f12
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1GHBTDLu+2u7HMqgL7H5RCvCZkb7xJBAJQxfBp3dM8xzHdOc/UUPawvtspbY4Bvwb3e4Xo01dsy5EGALKtbD8KNiW1QKDIchIktSev/DbsDYmeIOlWzb/HNONffwns0pZYqHiz0G43kdoFKRpd8XbDT3ZhwTWK0OZwx51F3dkxoyAr/L3+1nRis6Ewluz2DhfughZ1cAX0CEQTW/6SRj5JFKOZLD5TfpCoTLI+hUUdWvSMIzSb3fMHMS3hy6Iq8StH7K1FWZPBCIGUC26mxmwSqDTuUQ58/LXZ2F6iuJUv9WIwAc/4C5dDcWm68guXOArwYJLff+BfK6WGBVFASuImxaqxiJSazMDVuCO61hmPEy6BAxWQFTk5vJ1wTIvUOwXwN7yITfUWFwfNqfYiIxC5CD/jEhnB0UY5rTcL3DkHu18W5LYqNMPXvznab/NCX4rSjnt4yzQb81fv3kVn9bVHrBL8h1DI3pbPjqxz5tKZdwvD8b8qoHcXR2hkeI7C7mdCeCse5M9URUoLvLiUBOQtZq7lo1fgzhVycKWqiogJxA+Zbn0N56I/A4gxNuCfmtucCoUn+xxL89XBgMj95MSqfgl6TLjUg1s9lWQgtk5QNFA1MpRgvLILL/0z1ZQQXSSILKDN62g0WNppXQWMRm+mTYO47jFN8D5wYexkLWKnAGGOCG5rkBDoJI9IfIE5SHJDfloJUHrEXm+iYOCXfmQ6zZY5K62/nVXNOOySKQJc4=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(396003)(136003)(376002)(346002)(451199018)(36840700001)(46966006)(40470700004)(478600001)(1076003)(6666004)(26005)(186003)(47076005)(70206006)(70586007)(336012)(8676002)(426003)(316002)(4326008)(2876002)(36860700001)(83380400001)(41300700001)(5660300002)(7416002)(8936002)(30864003)(2906002)(81166007)(356005)(82740400003)(86362001)(82310400005)(54906003)(6636002)(110136005)(2616005)(36756003)(40480700001)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2023 09:09:41.0034
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 55f359de-4482-4e22-6b15-08db0f345f12
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E632.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8144
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alejandro Lucero <alejandro.lucero-palau@amd.com>

Using the data when enumerating mports, create devlink ports just before
netdevs are registered and remove those devlink ports after netdev has
been unregistered.

Signed-off-by: Alejandro Lucero <alejandro.lucero-palau@amd.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Acked-by: Martin Habets <habetsm.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/ef100_netdev.c |  10 +++
 drivers/net/ethernet/sfc/ef100_rep.c    |  22 +++++
 drivers/net/ethernet/sfc/ef100_rep.h    |   7 ++
 drivers/net/ethernet/sfc/efx_devlink.c  | 105 ++++++++++++++++++++++++
 drivers/net/ethernet/sfc/efx_devlink.h  |   8 ++
 drivers/net/ethernet/sfc/mae.h          |   2 +
 drivers/net/ethernet/sfc/net_driver.h   |   2 +
 7 files changed, 156 insertions(+)

diff --git a/drivers/net/ethernet/sfc/ef100_netdev.c b/drivers/net/ethernet/sfc/ef100_netdev.c
index 6cf74788b27a..368147359299 100644
--- a/drivers/net/ethernet/sfc/ef100_netdev.c
+++ b/drivers/net/ethernet/sfc/ef100_netdev.c
@@ -337,6 +337,7 @@ void ef100_remove_netdev(struct efx_probe_data *probe_data)
 	ef100_unregister_netdev(efx);
 
 #ifdef CONFIG_SFC_SRIOV
+	ef100_pf_unset_devlink_port(efx);
 	efx_fini_tc(efx);
 #endif
 
@@ -422,6 +423,9 @@ int ef100_probe_netdev(struct efx_probe_data *probe_data)
 		rc = ef100_probe_netdev_pf(efx);
 		if (rc)
 			goto fail;
+#ifdef CONFIG_SFC_SRIOV
+		ef100_pf_set_devlink_port(efx);
+#endif
 	}
 
 	efx->netdev_notifier.notifier_call = ef100_netdev_event;
@@ -432,7 +436,13 @@ int ef100_probe_netdev(struct efx_probe_data *probe_data)
 		goto fail;
 	}
 
+	efx_probe_devlink_unlock(efx);
+	return rc;
 fail:
+#ifdef CONFIG_SFC_SRIOV
+	/* remove devlink port if does exist */
+	ef100_pf_unset_devlink_port(efx);
+#endif
 	efx_probe_devlink_unlock(efx);
 	return rc;
 }
diff --git a/drivers/net/ethernet/sfc/ef100_rep.c b/drivers/net/ethernet/sfc/ef100_rep.c
index 9cd1a3ac67e0..6b5bc5d6955d 100644
--- a/drivers/net/ethernet/sfc/ef100_rep.c
+++ b/drivers/net/ethernet/sfc/ef100_rep.c
@@ -16,6 +16,7 @@
 #include "mae.h"
 #include "rx_common.h"
 #include "tc_bindings.h"
+#include "efx_devlink.h"
 
 #define EFX_EF100_REP_DRIVER	"efx_ef100_rep"
 
@@ -297,6 +298,7 @@ int efx_ef100_vfrep_create(struct efx_nic *efx, unsigned int i)
 			i, rc);
 		goto fail1;
 	}
+	ef100_rep_set_devlink_port(efv);
 	rc = register_netdev(efv->net_dev);
 	if (rc) {
 		pci_err(efx->pci_dev,
@@ -308,6 +310,7 @@ int efx_ef100_vfrep_create(struct efx_nic *efx, unsigned int i)
 		efv->net_dev->name);
 	return 0;
 fail2:
+	ef100_rep_unset_devlink_port(efv);
 	efx_ef100_deconfigure_rep(efv);
 fail1:
 	efx_ef100_rep_destroy_netdev(efv);
@@ -323,6 +326,7 @@ void efx_ef100_vfrep_destroy(struct efx_nic *efx, struct efx_rep *efv)
 		return;
 	netif_dbg(efx, drv, rep_dev, "Removing VF representor\n");
 	unregister_netdev(rep_dev);
+	ef100_rep_unset_devlink_port(efv);
 	efx_ef100_deconfigure_rep(efv);
 	efx_ef100_rep_destroy_netdev(efv);
 }
@@ -339,6 +343,24 @@ void efx_ef100_fini_vfreps(struct efx_nic *efx)
 		efx_ef100_vfrep_destroy(efx, efv);
 }
 
+static bool ef100_mport_is_pcie_vnic(struct mae_mport_desc *mport_desc)
+{
+	return mport_desc->mport_type == MAE_MPORT_DESC_MPORT_TYPE_VNIC &&
+	       mport_desc->vnic_client_type == MAE_MPORT_DESC_VNIC_CLIENT_TYPE_FUNCTION;
+}
+
+bool ef100_mport_on_local_intf(struct efx_nic *efx,
+			       struct mae_mport_desc *mport_desc)
+{
+	struct ef100_nic_data *nic_data = efx->nic_data;
+	bool pcie_func;
+
+	pcie_func = ef100_mport_is_pcie_vnic(mport_desc);
+
+	return nic_data->have_local_intf && pcie_func &&
+		     mport_desc->interface_idx == nic_data->local_mae_intf;
+}
+
 void efx_ef100_init_reps(struct efx_nic *efx)
 {
 	struct ef100_nic_data *nic_data = efx->nic_data;
diff --git a/drivers/net/ethernet/sfc/ef100_rep.h b/drivers/net/ethernet/sfc/ef100_rep.h
index 328ac0cbb532..ae6add4b0855 100644
--- a/drivers/net/ethernet/sfc/ef100_rep.h
+++ b/drivers/net/ethernet/sfc/ef100_rep.h
@@ -22,6 +22,8 @@ struct efx_rep_sw_stats {
 	atomic64_t rx_dropped, tx_errors;
 };
 
+struct devlink_port;
+
 /**
  * struct efx_rep - Private data for an Efx representor
  *
@@ -39,6 +41,7 @@ struct efx_rep_sw_stats {
  * @rx_lock: protects @rx_list
  * @napi: NAPI control structure
  * @stats: software traffic counters for netdev stats
+ * @dl_port: devlink port associated to this netdev representor
  */
 struct efx_rep {
 	struct efx_nic *parent;
@@ -54,6 +57,7 @@ struct efx_rep {
 	spinlock_t rx_lock;
 	struct napi_struct napi;
 	struct efx_rep_sw_stats stats;
+	struct devlink_port *dl_port;
 };
 
 int efx_ef100_vfrep_create(struct efx_nic *efx, unsigned int i);
@@ -69,4 +73,7 @@ struct efx_rep *efx_ef100_find_rep_by_mport(struct efx_nic *efx, u16 mport);
 extern const struct net_device_ops efx_ef100_rep_netdev_ops;
 void efx_ef100_init_reps(struct efx_nic *efx);
 void efx_ef100_fini_reps(struct efx_nic *efx);
+struct mae_mport_desc;
+bool ef100_mport_on_local_intf(struct efx_nic *efx,
+			       struct mae_mport_desc *mport_desc);
 #endif /* EF100_REP_H */
diff --git a/drivers/net/ethernet/sfc/efx_devlink.c b/drivers/net/ethernet/sfc/efx_devlink.c
index 76d54048beda..01e75eb244e3 100644
--- a/drivers/net/ethernet/sfc/efx_devlink.c
+++ b/drivers/net/ethernet/sfc/efx_devlink.c
@@ -14,11 +14,52 @@
 #include "mcdi.h"
 #include "mcdi_functions.h"
 #include "mcdi_pcol.h"
+#ifdef CONFIG_SFC_SRIOV
+#include "mae.h"
+#include "ef100_rep.h"
+#endif
 
 struct efx_devlink {
 	struct efx_nic *efx;
 };
 
+#ifdef CONFIG_SFC_SRIOV
+static void efx_devlink_del_port(struct devlink_port *dl_port)
+{
+	if (!dl_port)
+		return;
+	devl_port_unregister(dl_port);
+}
+
+static int efx_devlink_add_port(struct efx_nic *efx,
+				struct mae_mport_desc *mport)
+{
+	bool external = false;
+
+	if (!ef100_mport_on_local_intf(efx, mport))
+		external = true;
+
+	switch (mport->mport_type) {
+	case MAE_MPORT_DESC_MPORT_TYPE_VNIC:
+		if (mport->vf_idx != MAE_MPORT_DESC_VF_IDX_NULL)
+			devlink_port_attrs_pci_vf_set(&mport->dl_port, 0, mport->pf_idx,
+						      mport->vf_idx,
+						      external);
+		else
+			devlink_port_attrs_pci_pf_set(&mport->dl_port, 0, mport->pf_idx,
+						      external);
+		break;
+	default:
+		/* MAE_MPORT_DESC_MPORT_ALIAS and UNDEFINED */
+		return 0;
+	}
+
+	mport->dl_port.index = mport->mport_id;
+
+	return devl_port_register(efx->devlink, &mport->dl_port, mport->mport_id);
+}
+#endif
+
 static int efx_devlink_info_nvram_partition(struct efx_nic *efx,
 					    struct devlink_info_req *req,
 					    unsigned int partition_type,
@@ -475,6 +516,70 @@ static const struct devlink_ops sfc_devlink_ops = {
 	.info_get			= efx_devlink_info_get,
 };
 
+#ifdef CONFIG_SFC_SRIOV
+static struct devlink_port *ef100_set_devlink_port(struct efx_nic *efx, u32 idx)
+{
+	struct mae_mport_desc *mport;
+	u32 id;
+	int rc;
+
+	if (efx_mae_lookup_mport(efx, idx, &id)) {
+		/* This should not happen. */
+		if (idx == MAE_MPORT_DESC_VF_IDX_NULL)
+			pci_warn_once(efx->pci_dev, "No mport ID found for PF.\n");
+		else
+			pci_warn_once(efx->pci_dev, "No mport ID found for VF %u.\n",
+				      idx);
+		return NULL;
+	}
+
+	mport = efx_mae_get_mport(efx, id);
+	if (!mport) {
+		/* This should not happen. */
+		if (idx == MAE_MPORT_DESC_VF_IDX_NULL)
+			pci_warn_once(efx->pci_dev, "No mport found for PF.\n");
+		else
+			pci_warn_once(efx->pci_dev, "No mport found for VF %u.\n",
+				      idx);
+		return NULL;
+	}
+
+	rc = efx_devlink_add_port(efx, mport);
+	if (rc) {
+		if (idx == MAE_MPORT_DESC_VF_IDX_NULL)
+			pci_warn(efx->pci_dev,
+				 "devlink port creation for PF failed.\n");
+		else
+			pci_warn(efx->pci_dev,
+				 "devlink_port creationg for VF %u failed.\n",
+				 idx);
+		return NULL;
+	}
+
+	return &mport->dl_port;
+}
+
+void ef100_rep_set_devlink_port(struct efx_rep *efv)
+{
+	efv->dl_port = ef100_set_devlink_port(efv->parent, efv->idx);
+}
+
+void ef100_pf_set_devlink_port(struct efx_nic *efx)
+{
+	efx->dl_port = ef100_set_devlink_port(efx, MAE_MPORT_DESC_VF_IDX_NULL);
+}
+
+void ef100_rep_unset_devlink_port(struct efx_rep *efv)
+{
+	efx_devlink_del_port(efv->dl_port);
+}
+
+void ef100_pf_unset_devlink_port(struct efx_nic *efx)
+{
+	efx_devlink_del_port(efx->dl_port);
+}
+#endif
+
 void efx_fini_devlink_lock(struct efx_nic *efx)
 {
 	if (efx->devlink)
diff --git a/drivers/net/ethernet/sfc/efx_devlink.h b/drivers/net/ethernet/sfc/efx_devlink.h
index a5269361c3e0..e5fd5e1dcc27 100644
--- a/drivers/net/ethernet/sfc/efx_devlink.h
+++ b/drivers/net/ethernet/sfc/efx_devlink.h
@@ -36,4 +36,12 @@ void efx_probe_devlink_unlock(struct efx_nic *efx);
 void efx_fini_devlink_lock(struct efx_nic *efx);
 void efx_fini_devlink_and_unlock(struct efx_nic *efx);
 
+#ifdef CONFIG_SFC_SRIOV
+struct efx_rep;
+
+void ef100_pf_set_devlink_port(struct efx_nic *efx);
+void ef100_rep_set_devlink_port(struct efx_rep *efv);
+void ef100_pf_unset_devlink_port(struct efx_nic *efx);
+void ef100_rep_unset_devlink_port(struct efx_rep *efv);
+#endif
 #endif	/* _EFX_DEVLINK_H */
diff --git a/drivers/net/ethernet/sfc/mae.h b/drivers/net/ethernet/sfc/mae.h
index b9bf86c47cda..bec293a06733 100644
--- a/drivers/net/ethernet/sfc/mae.h
+++ b/drivers/net/ethernet/sfc/mae.h
@@ -13,6 +13,7 @@
 #define EF100_MAE_H
 /* MCDI interface for the ef100 Match-Action Engine */
 
+#include <net/devlink.h>
 #include "net_driver.h"
 #include "tc.h"
 #include "mcdi_pcol.h" /* needed for various MC_CMD_MAE_*_NULL defines */
@@ -43,6 +44,7 @@ struct mae_mport_desc {
 		};
 	};
 	struct rhash_head linkage;
+	struct devlink_port dl_port;
 };
 
 int efx_mae_enumerate_mports(struct efx_nic *efx);
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index bc9efbfb3d6b..fcd51d3992fa 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -998,6 +998,7 @@ struct efx_mae;
  * @netdev_notifier: Netdevice notifier.
  * @tc: state for TC offload (EF100).
  * @devlink: reference to devlink structure owned by this device
+ * @dl_port: devlink port associated with the PF
  * @mem_bar: The BAR that is mapped into membase.
  * @reg_base: Offset from the start of the bar to the function control window.
  * @monitor_work: Hardware monitor workitem
@@ -1185,6 +1186,7 @@ struct efx_nic {
 	struct efx_tc_state *tc;
 
 	struct devlink *devlink;
+	struct devlink_port *dl_port;
 	unsigned int mem_bar;
 	u32 reg_base;
 
-- 
2.17.1

