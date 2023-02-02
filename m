Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15B88687BF0
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 12:15:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232094AbjBBLO4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 06:14:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232301AbjBBLOu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 06:14:50 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2050.outbound.protection.outlook.com [40.107.94.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B867C87D1B;
        Thu,  2 Feb 2023 03:14:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hO9Y/UVbqeGMgjbWgQL1JP52JM8eOlZsvT5A0mLN21/HrmYSCxHU6LqsGxfYV7N2CWhwjEpN0t5XFuxcAhadr8UngtsI4U3sXi37hPcwDjBPGIJ9FLRKBni8a2fKZrfFSij8c4lSX/scAoCb6vEOV+6THNO392QjOLdGdOmg5ROMmASpWMSOTZrPMCKAOQHGkfOB6n3X2AfM1Vs4FgAfhhnVQwWK6FaPsy2zfr+ZDSTXmiKSinyqZ9+9xFNE+xjFHaGf+q8Ct8hSTSpWY+4sC/kof74ECb3NOFMiVduLiVGq0Q13RPhEWVxIy/8RCX2dAMZcXRnu78FspOrOETNqOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=agyuEKmvwKZnn7xT7B4R2Ett+r61Bb7RWpAgVDlu2ZY=;
 b=eoThRxMk7EuMn5vqQCs4V1Oz/JtHLVLZrXH6Mpr3RwxG50tk9km5gelc6aJpm0c9EVSSZb2zNREthVYRlFKtlvgkePGia3iT1WYe2foG2IX9X7PDeQaYGssDm6jkiSb6KcdSTxNmBhv8qQhMaLE3PYXbo+4OkJiJceTdxsU2fTHoMC0jTu+bsPsDXrWcISirCEeU0vJtsWA7EAMr3/tOrv108AU4Do9ZXKCHFzcRlfmQJJwkSOZ5hA82KxY+VGEnLlzcxl5xkUncQJaCJnwilmSIpofff1qKAB0k0qs094VsRZSpAr7H1pfqRy68ft+NJjhi0Tv8AEIKIeZILZ6VOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=agyuEKmvwKZnn7xT7B4R2Ett+r61Bb7RWpAgVDlu2ZY=;
 b=tjXqaXYuC7acFXpXDBNIgbyTME+SjA+5clOBnbNF0+68fwXOpFA/kWEbqubD2fLg/oCZsLKFbyVg2iRKog1L4M/RXvLrQwOAdfa4trkxBoxSu42HnNdpLphzuwGhExkmB+f1TjuXb9BXSuwdvN8965fFAtbSZI6KDn9Yw+HkLZY=
Received: from MW4PR04CA0279.namprd04.prod.outlook.com (2603:10b6:303:89::14)
 by DS0PR12MB8564.namprd12.prod.outlook.com (2603:10b6:8:167::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Thu, 2 Feb
 2023 11:14:46 +0000
Received: from CO1NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:89:cafe::4c) by MW4PR04CA0279.outlook.office365.com
 (2603:10b6:303:89::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27 via Frontend
 Transport; Thu, 2 Feb 2023 11:14:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT010.mail.protection.outlook.com (10.13.175.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6064.27 via Frontend Transport; Thu, 2 Feb 2023 11:14:46 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 2 Feb
 2023 05:14:44 -0600
Received: from xcbalucerop41x.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34 via Frontend Transport; Thu, 2 Feb 2023 05:14:42 -0600
From:   <alejandro.lucero-palau@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        <ecree.xilinx@gmail.com>, <linux-doc@vger.kernel.org>,
        <corbet@lwn.net>, <jiri@nvidia.com>,
        "Alejandro Lucero" <alejandro.lucero-palau@amd.com>
Subject: [PATCH v5 net-next 3/8] sfc: enumerate mports in ef100
Date:   Thu, 2 Feb 2023 11:14:18 +0000
Message-ID: <20230202111423.56831-4-alejandro.lucero-palau@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230202111423.56831-1-alejandro.lucero-palau@amd.com>
References: <20230202111423.56831-1-alejandro.lucero-palau@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT010:EE_|DS0PR12MB8564:EE_
X-MS-Office365-Filtering-Correlation-Id: b6fbd571-f187-4032-ba6c-08db050eb152
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CJZ0E3/nnrcHXjd+08Nd4D9NEURNIYz7E1t7Vfsf0Ju0CfzgP8JOr43TXV1+I4hhTwLUFMEyCQBqEdK8Yo67TUqBkdLgSm+t/vt9v3lpJT7pT3qT2JzDMsr+Nia7i/T9L+42AqVKP18lhv/ksX478r2tJkzlMFErDyCtSR1fKte+8FTzB9lWpQQs1x7Y9yUV+9LFMB8g6UOs0k/zO/hFCdhV0ensUcwA+pIdxmuWaucUmgJuQhvJzyOI5jeosN0MxEQ2ta8XjcaUo55Vd15qtSv61+Uvj0jZjNBU/etcEwCKPYhj6CJr4f0B1yLutC7LMs0qf1fflPN5qpyQnldhQv+X2YQI7QvMBU/Io/VZdvrVFHc80GbxDZMFRuXcJES5ueHvoAKDUI8SzBS83DrsSudWj8QaU4FQmR31W7VFSXEYaODosLsHrrfupo2M+6X3bLwGoBdDGPRqfYiBK3gY3ABwrDNK2do5lrheEPoHRb12Rcw6FdVu7fKNS8dUZZ2TPFwdwNkkV3/3jUBdvYSjLZ7QBNX8tUM/Fty9DR+rMOlnr7qhYG9vik2Ny80wbFjSdLGU7LrBHD0tw8YCt0PjYz2NSovIQILnGQFz2XZ7tgO33GVMeyp9m3LASNQ5CDyD/aejBXOE6odYk8u0IBUwutwFLvBjmYdB6KMYtDloELVleUL+G97OcDxONU23UbqS0D3BPsSeuokAPnXhiKucDMEmKlrrzvVeHw4HlsFNKwwaQf/Jbttd6aK8tBh3yObR
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(376002)(346002)(136003)(396003)(451199018)(46966006)(36840700001)(40470700004)(82740400003)(40480700001)(426003)(47076005)(83380400001)(1076003)(6666004)(356005)(81166007)(336012)(82310400005)(186003)(478600001)(86362001)(36860700001)(36756003)(2616005)(26005)(54906003)(30864003)(6636002)(8936002)(2876002)(2906002)(70586007)(41300700001)(40460700003)(70206006)(4326008)(8676002)(110136005)(316002)(5660300002)(7416002)(2004002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 11:14:46.4008
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b6fbd571-f187-4032-ba6c-08db050eb152
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8564
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

MAE ports (mports) are the ports on the EF100 embedded switch such
as networking PCIe functions, the physical port, and potentially
others.

Signed-off-by: Alejandro Lucero <alejandro.lucero-palau@amd.com>
---
 drivers/net/ethernet/sfc/ef100_nic.c  |  27 ++++
 drivers/net/ethernet/sfc/ef100_nic.h  |   4 +
 drivers/net/ethernet/sfc/ef100_rep.c  |  22 +++
 drivers/net/ethernet/sfc/ef100_rep.h  |   2 +
 drivers/net/ethernet/sfc/mae.c        | 191 ++++++++++++++++++++++++++
 drivers/net/ethernet/sfc/mae.h        |  37 +++++
 drivers/net/ethernet/sfc/mcdi.h       |   5 +
 drivers/net/ethernet/sfc/net_driver.h |   4 +
 8 files changed, 292 insertions(+)

diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index ad686c671ab8..07e7dca0e4f2 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -747,6 +747,19 @@ static int efx_ef100_get_base_mport(struct efx_nic *efx)
 			   id);
 	nic_data->base_mport = id;
 	nic_data->have_mport = true;
+
+	/* Construct mport selector for "calling PF" */
+	efx_mae_mport_uplink(efx, &selector);
+	/* Look up actual mport ID */
+	rc = efx_mae_lookup_mport(efx, selector, &id);
+	if (rc)
+		return rc;
+	if (id >> 16)
+		netif_warn(efx, probe, efx->net_dev, "Bad own m-port id %#x\n",
+			   id);
+	nic_data->own_mport = id;
+	nic_data->have_own_mport = true;
+
 	return 0;
 }
 #endif
@@ -1126,6 +1139,14 @@ int ef100_probe_netdev_pf(struct efx_nic *efx)
 			   rc);
 	}
 
+	rc = efx_init_mae(efx);
+	if (rc)
+		netif_warn(efx, probe, net_dev,
+			   "Failed to init MAE rc %d; representors will not function\n",
+			   rc);
+	else
+		efx_ef100_init_reps(efx);
+
 	rc = efx_init_tc(efx);
 	if (rc) {
 		/* Either we don't have an MAE at all (i.e. legacy v-switching),
@@ -1157,6 +1178,12 @@ void ef100_remove(struct efx_nic *efx)
 {
 	struct ef100_nic_data *nic_data = efx->nic_data;
 
+#ifdef CONFIG_SFC_SRIOV
+	if (efx->mae) {
+		efx_ef100_fini_reps(efx);
+		efx_fini_mae(efx);
+	}
+#endif
 	efx_mcdi_detach(efx);
 	efx_mcdi_fini(efx);
 	if (nic_data)
diff --git a/drivers/net/ethernet/sfc/ef100_nic.h b/drivers/net/ethernet/sfc/ef100_nic.h
index 0295933145fa..496aea43c60f 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.h
+++ b/drivers/net/ethernet/sfc/ef100_nic.h
@@ -74,6 +74,10 @@ struct ef100_nic_data {
 	u64 stats[EF100_STAT_COUNT];
 	u32 base_mport;
 	bool have_mport; /* base_mport was populated successfully */
+	u32 own_mport;
+	u32 local_mae_intf; /* interface_idx that corresponds to us, in mport enumerate */
+	bool have_own_mport; /* own_mport was populated successfully */
+	bool have_local_intf; /* local_mae_intf was populated successfully */
 	bool grp_mae; /* MAE Privilege */
 	u16 tso_max_hdr_len;
 	u16 tso_max_payload_num_segs;
diff --git a/drivers/net/ethernet/sfc/ef100_rep.c b/drivers/net/ethernet/sfc/ef100_rep.c
index 81ab22c74635..ebe7b1275713 100644
--- a/drivers/net/ethernet/sfc/ef100_rep.c
+++ b/drivers/net/ethernet/sfc/ef100_rep.c
@@ -9,6 +9,7 @@
  * by the Free Software Foundation, incorporated herein by reference.
  */
 
+#include <linux/rhashtable.h>
 #include "ef100_rep.h"
 #include "ef100_netdev.h"
 #include "ef100_nic.h"
@@ -341,6 +342,27 @@ void efx_ef100_fini_vfreps(struct efx_nic *efx)
 		efx_ef100_vfrep_destroy(efx, efv);
 }
 
+void efx_ef100_init_reps(struct efx_nic *efx)
+{
+	struct ef100_nic_data *nic_data = efx->nic_data;
+	int rc;
+
+	nic_data->have_local_intf = false;
+	rc = efx_mae_enumerate_mports(efx);
+	if (rc)
+		pci_warn(efx->pci_dev,
+			 "Could not enumerate mports (rc=%d), are we admin?",
+			 rc);
+}
+
+void efx_ef100_fini_reps(struct efx_nic *efx)
+{
+	struct efx_mae *mae = efx->mae;
+
+	rhashtable_free_and_destroy(&mae->mports_ht, efx_mae_remove_mport,
+				    NULL);
+}
+
 static int efx_ef100_rep_poll(struct napi_struct *napi, int weight)
 {
 	struct efx_rep *efv = container_of(napi, struct efx_rep, napi);
diff --git a/drivers/net/ethernet/sfc/ef100_rep.h b/drivers/net/ethernet/sfc/ef100_rep.h
index c21bc716f847..328ac0cbb532 100644
--- a/drivers/net/ethernet/sfc/ef100_rep.h
+++ b/drivers/net/ethernet/sfc/ef100_rep.h
@@ -67,4 +67,6 @@ void efx_ef100_rep_rx_packet(struct efx_rep *efv, struct efx_rx_buffer *rx_buf);
  */
 struct efx_rep *efx_ef100_find_rep_by_mport(struct efx_nic *efx, u16 mport);
 extern const struct net_device_ops efx_ef100_rep_netdev_ops;
+void efx_ef100_init_reps(struct efx_nic *efx);
+void efx_ef100_fini_reps(struct efx_nic *efx);
 #endif /* EF100_REP_H */
diff --git a/drivers/net/ethernet/sfc/mae.c b/drivers/net/ethernet/sfc/mae.c
index 583baf69981c..725a3ab31087 100644
--- a/drivers/net/ethernet/sfc/mae.c
+++ b/drivers/net/ethernet/sfc/mae.c
@@ -9,8 +9,11 @@
  * by the Free Software Foundation, incorporated herein by reference.
  */
 
+#include <linux/rhashtable.h>
+#include "ef100_nic.h"
 #include "mae.h"
 #include "mcdi.h"
+#include "mcdi_pcol.h"
 #include "mcdi_pcol_mae.h"
 
 int efx_mae_allocate_mport(struct efx_nic *efx, u32 *id, u32 *label)
@@ -490,6 +493,163 @@ static bool efx_mae_asl_id(u32 id)
 	return !!(id & BIT(31));
 }
 
+/* mport handling */
+static const struct rhashtable_params efx_mae_mports_ht_params = {
+	.key_len	= sizeof(u32),
+	.key_offset	= offsetof(struct mae_mport_desc, mport_id),
+	.head_offset	= offsetof(struct mae_mport_desc, linkage),
+};
+
+struct mae_mport_desc *efx_mae_get_mport(struct efx_nic *efx, u32 mport_id)
+{
+	return rhashtable_lookup_fast(&efx->mae->mports_ht, &mport_id,
+				      efx_mae_mports_ht_params);
+}
+
+static int efx_mae_add_mport(struct efx_nic *efx, struct mae_mport_desc *desc)
+{
+	struct efx_mae *mae = efx->mae;
+	int rc;
+
+	rc = rhashtable_insert_fast(&mae->mports_ht, &desc->linkage,
+				    efx_mae_mports_ht_params);
+
+	if (rc) {
+		pci_err(efx->pci_dev, "Failed to insert MPORT %08x, rc %d\n",
+			desc->mport_id, rc);
+		kfree(desc);
+		return rc;
+	}
+
+	return rc;
+}
+
+void efx_mae_remove_mport(void *desc, void *arg)
+{
+	struct mae_mport_desc *mport = desc;
+
+	synchronize_rcu();
+	kfree(mport);
+}
+
+static int efx_mae_process_mport(struct efx_nic *efx,
+				 struct mae_mport_desc *desc)
+{
+	struct ef100_nic_data *nic_data = efx->nic_data;
+	struct mae_mport_desc *mport;
+
+	mport = efx_mae_get_mport(efx, desc->mport_id);
+	if (!IS_ERR_OR_NULL(mport)) {
+		netif_err(efx, drv, efx->net_dev,
+			  "mport with id %u does exist!!!\n", desc->mport_id);
+		return -EEXIST;
+	}
+
+	if (nic_data->have_own_mport &&
+	    desc->mport_id == nic_data->own_mport) {
+		WARN_ON(desc->mport_type != MAE_MPORT_DESC_MPORT_TYPE_VNIC);
+		WARN_ON(desc->vnic_client_type !=
+			MAE_MPORT_DESC_VNIC_CLIENT_TYPE_FUNCTION);
+		nic_data->local_mae_intf = desc->interface_idx;
+		nic_data->have_local_intf = true;
+		pci_dbg(efx->pci_dev, "MAE interface_idx is %u\n",
+			nic_data->local_mae_intf);
+	}
+
+	return efx_mae_add_mport(efx, desc);
+}
+
+#define MCDI_MPORT_JOURNAL_LEN \
+	ALIGN(MC_CMD_MAE_MPORT_READ_JOURNAL_OUT_LENMAX_MCDI2, 4)
+
+int efx_mae_enumerate_mports(struct efx_nic *efx)
+{
+	efx_dword_t *outbuf = kzalloc(MCDI_MPORT_JOURNAL_LEN, GFP_KERNEL);
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_MAE_MPORT_READ_JOURNAL_IN_LEN);
+	MCDI_DECLARE_STRUCT_PTR(desc);
+	size_t outlen, stride, count;
+	int rc = 0, i;
+
+	if (!outbuf)
+		return -ENOMEM;
+	do {
+		rc = efx_mcdi_rpc(efx, MC_CMD_MAE_MPORT_READ_JOURNAL, inbuf,
+				  sizeof(inbuf), outbuf,
+				  MCDI_MPORT_JOURNAL_LEN, &outlen);
+		if (rc)
+			goto fail;
+		if (outlen < MC_CMD_MAE_MPORT_READ_JOURNAL_OUT_MPORT_DESC_DATA_OFST) {
+			rc = -EIO;
+			goto fail;
+		}
+		count = MCDI_DWORD(outbuf, MAE_MPORT_READ_JOURNAL_OUT_MPORT_DESC_COUNT);
+		if (!count)
+			continue; /* not break; we want to look at MORE flag */
+		stride = MCDI_DWORD(outbuf, MAE_MPORT_READ_JOURNAL_OUT_SIZEOF_MPORT_DESC);
+		if (stride < MAE_MPORT_DESC_LEN) {
+			rc = -EIO;
+			goto fail;
+		}
+		if (outlen < MC_CMD_MAE_MPORT_READ_JOURNAL_OUT_LEN(count * stride)) {
+			rc = -EIO;
+			goto fail;
+		}
+
+		for (i = 0; i < count; i++) {
+			struct mae_mport_desc *d;
+
+			d = kzalloc(sizeof(*d), GFP_KERNEL);
+			if (!d) {
+				rc = -ENOMEM;
+				goto fail;
+			}
+
+			desc = (efx_dword_t *)
+				_MCDI_PTR(outbuf, MC_CMD_MAE_MPORT_READ_JOURNAL_OUT_MPORT_DESC_DATA_OFST +
+					  i * stride);
+			d->mport_id = MCDI_STRUCT_DWORD(desc, MAE_MPORT_DESC_MPORT_ID);
+			d->flags = MCDI_STRUCT_DWORD(desc, MAE_MPORT_DESC_FLAGS);
+			d->caller_flags = MCDI_STRUCT_DWORD(desc,
+							    MAE_MPORT_DESC_CALLER_FLAGS);
+			d->mport_type = MCDI_STRUCT_DWORD(desc,
+							  MAE_MPORT_DESC_MPORT_TYPE);
+			switch (d->mport_type) {
+			case MAE_MPORT_DESC_MPORT_TYPE_NET_PORT:
+				d->port_idx = MCDI_STRUCT_DWORD(desc,
+								MAE_MPORT_DESC_NET_PORT_IDX);
+				break;
+			case MAE_MPORT_DESC_MPORT_TYPE_ALIAS:
+				d->alias_mport_id = MCDI_STRUCT_DWORD(desc,
+								      MAE_MPORT_DESC_ALIAS_DELIVER_MPORT_ID);
+				break;
+			case MAE_MPORT_DESC_MPORT_TYPE_VNIC:
+				d->vnic_client_type = MCDI_STRUCT_DWORD(desc,
+									MAE_MPORT_DESC_VNIC_CLIENT_TYPE);
+				d->interface_idx = MCDI_STRUCT_DWORD(desc,
+								     MAE_MPORT_DESC_VNIC_FUNCTION_INTERFACE);
+				d->pf_idx = MCDI_STRUCT_WORD(desc,
+							     MAE_MPORT_DESC_VNIC_FUNCTION_PF_IDX);
+			d->vf_idx = MCDI_STRUCT_WORD(desc,
+						     MAE_MPORT_DESC_VNIC_FUNCTION_VF_IDX);
+				break;
+			default:
+				/* Unknown mport_type, just accept it */
+				break;
+			}
+			rc = efx_mae_process_mport(efx, d);
+			/* Any failure will be due to memory allocation faiure,
+			 * so there is no point to try subsequent entries.
+			 */
+			if (rc)
+				goto fail;
+		}
+	} while (MCDI_FIELD(outbuf, MAE_MPORT_READ_JOURNAL_OUT, MORE) &&
+		 !WARN_ON(!count));
+fail:
+	kfree(outbuf);
+	return rc;
+}
+
 int efx_mae_alloc_action_set(struct efx_nic *efx, struct efx_tc_action_set *act)
 {
 	MCDI_DECLARE_BUF(outbuf, MC_CMD_MAE_ACTION_SET_ALLOC_OUT_LEN);
@@ -805,3 +965,34 @@ int efx_mae_delete_rule(struct efx_nic *efx, u32 id)
 		return -EIO;
 	return 0;
 }
+
+int efx_init_mae(struct efx_nic *efx)
+{
+	struct ef100_nic_data *nic_data = efx->nic_data;
+	struct efx_mae *mae;
+	int rc;
+
+	if (!nic_data->have_mport)
+		return -EINVAL;
+
+	mae = kmalloc(sizeof(*mae), GFP_KERNEL);
+	if (!mae)
+		return -ENOMEM;
+
+	rc = rhashtable_init(&mae->mports_ht, &efx_mae_mports_ht_params);
+	if (rc < 0) {
+		kfree(mae);
+		return rc;
+	}
+	efx->mae = mae;
+	mae->efx = efx;
+	return 0;
+}
+
+void efx_fini_mae(struct efx_nic *efx)
+{
+	struct efx_mae *mae = efx->mae;
+
+	kfree(mae);
+	efx->mae = NULL;
+}
diff --git a/drivers/net/ethernet/sfc/mae.h b/drivers/net/ethernet/sfc/mae.h
index 72343e90e222..e1f057f01f08 100644
--- a/drivers/net/ethernet/sfc/mae.h
+++ b/drivers/net/ethernet/sfc/mae.h
@@ -27,6 +27,40 @@ void efx_mae_mport_mport(struct efx_nic *efx, u32 mport_id, u32 *out);
 
 int efx_mae_lookup_mport(struct efx_nic *efx, u32 selector, u32 *id);
 
+struct mae_mport_desc {
+	u32 mport_id;
+	u32 flags;
+	u32 caller_flags; /* enum mae_mport_desc_caller_flags */
+	u32 mport_type; /* MAE_MPORT_DESC_MPORT_TYPE_* */
+	union {
+		u32 port_idx; /* for mport_type == NET_PORT */
+		u32 alias_mport_id; /* for mport_type == ALIAS */
+		struct { /* for mport_type == VNIC */
+			u32 vnic_client_type; /* MAE_MPORT_DESC_VNIC_CLIENT_TYPE_* */
+			u32 interface_idx;
+			u16 pf_idx;
+			u16 vf_idx;
+		};
+	};
+	struct rhash_head linkage;
+	struct efx_rep *efv;
+};
+
+int efx_mae_enumerate_mports(struct efx_nic *efx);
+struct mae_mport_desc *efx_mae_get_mport(struct efx_nic *efx, u32 mport_id);
+void efx_mae_put_mport(struct efx_nic *efx, struct mae_mport_desc *desc);
+
+/**
+ * struct efx_mae - MAE information
+ *
+ * @efx: The associated NIC
+ * @mports_ht: m-port descriptions from MC_CMD_MAE_MPORT_READ_JOURNAL
+ */
+struct efx_mae {
+	struct efx_nic *efx;
+	struct rhashtable mports_ht;
+};
+
 int efx_mae_start_counters(struct efx_nic *efx, struct efx_rx_queue *rx_queue);
 int efx_mae_stop_counters(struct efx_nic *efx, struct efx_rx_queue *rx_queue);
 void efx_mae_counters_grant_credits(struct work_struct *work);
@@ -60,4 +94,7 @@ int efx_mae_insert_rule(struct efx_nic *efx, const struct efx_tc_match *match,
 			u32 prio, u32 acts_id, u32 *id);
 int efx_mae_delete_rule(struct efx_nic *efx, u32 id);
 
+int efx_init_mae(struct efx_nic *efx);
+void efx_fini_mae(struct efx_nic *efx);
+void efx_mae_remove_mport(void *desc, void *arg);
 #endif /* EF100_MAE_H */
diff --git a/drivers/net/ethernet/sfc/mcdi.h b/drivers/net/ethernet/sfc/mcdi.h
index 5cb202684858..b139b76febff 100644
--- a/drivers/net/ethernet/sfc/mcdi.h
+++ b/drivers/net/ethernet/sfc/mcdi.h
@@ -229,6 +229,9 @@ void efx_mcdi_sensor_event(struct efx_nic *efx, efx_qword_t *ev);
 #define MCDI_WORD(_buf, _field)						\
 	((u16)BUILD_BUG_ON_ZERO(MC_CMD_ ## _field ## _LEN != 2) +	\
 	 le16_to_cpu(*(__force const __le16 *)MCDI_PTR(_buf, _field)))
+#define MCDI_STRUCT_WORD(_buf, _field)                                  \
+	((void)BUILD_BUG_ON_ZERO(_field ## _LEN != 2),  \
+	le16_to_cpu(*(__force const __le16 *)MCDI_STRUCT_PTR(_buf, _field)))
 /* Write a 16-bit field defined in the protocol as being big-endian. */
 #define MCDI_STRUCT_SET_WORD_BE(_buf, _field, _value) do {		\
 	BUILD_BUG_ON(_field ## _LEN != 2);				\
@@ -241,6 +244,8 @@ void efx_mcdi_sensor_event(struct efx_nic *efx, efx_qword_t *ev);
 	EFX_POPULATE_DWORD_1(*_MCDI_STRUCT_DWORD(_buf, _field), EFX_DWORD_0, _value)
 #define MCDI_DWORD(_buf, _field)					\
 	EFX_DWORD_FIELD(*_MCDI_DWORD(_buf, _field), EFX_DWORD_0)
+#define MCDI_STRUCT_DWORD(_buf, _field)                                 \
+	EFX_DWORD_FIELD(*_MCDI_STRUCT_DWORD(_buf, _field), EFX_DWORD_0)
 /* Write a 32-bit field defined in the protocol as being big-endian. */
 #define MCDI_STRUCT_SET_DWORD_BE(_buf, _field, _value) do {		\
 	BUILD_BUG_ON(_field ## _LEN != 4);				\
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index d036641dc043..bc9efbfb3d6b 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -845,6 +845,8 @@ enum efx_xdp_tx_queues_mode {
 	EFX_XDP_TX_QUEUES_BORROWED	/* queues borrowed from net stack */
 };
 
+struct efx_mae;
+
 /**
  * struct efx_nic - an Efx NIC
  * @name: Device name (net device name or bus id before net device registered)
@@ -881,6 +883,7 @@ enum efx_xdp_tx_queues_mode {
  * @msi_context: Context for each MSI
  * @extra_channel_types: Types of extra (non-traffic) channels that
  *	should be allocated for this NIC
+ * @mae: Details of the Match Action Engine
  * @xdp_tx_queue_count: Number of entries in %xdp_tx_queues.
  * @xdp_tx_queues: Array of pointers to tx queues used for XDP transmit.
  * @xdp_txq_queues_mode: XDP TX queues sharing strategy.
@@ -1044,6 +1047,7 @@ struct efx_nic {
 	struct efx_msi_context msi_context[EFX_MAX_CHANNELS];
 	const struct efx_channel_type *
 	extra_channel_type[EFX_MAX_EXTRA_CHANNELS];
+	struct efx_mae *mae;
 
 	unsigned int xdp_tx_queue_count;
 	struct efx_tx_queue **xdp_tx_queues;
-- 
2.17.1

