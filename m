Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03291683003
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 15:59:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232376AbjAaO7I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 09:59:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232417AbjAaO6r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 09:58:47 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2042.outbound.protection.outlook.com [40.107.100.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB04E234D5;
        Tue, 31 Jan 2023 06:58:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NRIgHJLWQpDzHx1pNPqqz33Yx/jTm5M5GAhgCfW+kVYji/j/UcSxRDqi1wMa9EblpGv8n8d52MluXpst695HMvrIqIEc6Xmz9fDBgZ4NOpobq+YoX1OhfDZYtsSgSyUGXr+q55S0efhIKaMigV75/FkboRJZA5GdVkDhql7tyxQSUVIrBtZYJOCBV4uGjCarowE9sUkgU9cDLufgf8xZmJdUzhoGOt7X8q8hDzX7EHYoMhyw7JNsqYFhJA2rm079WfNkzxJziO4BqJAM9U7Eg2b/6ml9La10xdhC2IvgZBoGTR8NXXAp/2i9wWsrGewQyGsPZjogWVTp4ZpxcRjZEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+ySfW8tfsKE9K3stbxr6s+lo/S5VziImX0Yg4W1V8ZE=;
 b=CgrL54fxujeQ8HQ7Vv8KepL0avKfbbpANMUTvpBZh5KV6V4AHxMWX58psquWrgFl77eW4XrAd04NDEfb9njoq0wvumIeoTNxx6uVS2+6ieCI+4wiPmyp2VrTIiP+5MKNROa5JpciXyZF4eWchE3z8KsZOxcEkLRE0lvAGapvvrtuKfKiZ+MaSE24iVwENoEnIZyB1LJdgwrKQk3Z6Nwkf1FN6hmerIoRwc+pn2ATyPSrvLMtBRNSz/ixF5yCuz2JuLYesOoTraKRHaFiE4ThJvs35JvW7S1inxuXb50JkvizP0HjI6/Tg94OouX2q9z2xPt5NEmpp0dFBjE5/AfLrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+ySfW8tfsKE9K3stbxr6s+lo/S5VziImX0Yg4W1V8ZE=;
 b=m066SRG0xbbbZPFIrvsUtJdPFtZk24LIsZX7XzcOK22/CUDZgYjA1OD094RwgyKk/ppMeGuEMlNcwWqiZeD5VgeiXvx3xLqr5PKOf9oNe+g6tId6KsdSDqFG9CsCR6Z+HkNXVVH+LDrmUeNJ76r9sR8IWmWqTv3Cl8OCLWOBo/A=
Received: from BN9P221CA0005.NAMP221.PROD.OUTLOOK.COM (2603:10b6:408:10a::28)
 by MN2PR12MB4501.namprd12.prod.outlook.com (2603:10b6:208:269::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Tue, 31 Jan
 2023 14:58:41 +0000
Received: from BN8NAM11FT039.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10a:cafe::97) by BN9P221CA0005.outlook.office365.com
 (2603:10b6:408:10a::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38 via Frontend
 Transport; Tue, 31 Jan 2023 14:58:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT039.mail.protection.outlook.com (10.13.177.169) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6043.21 via Frontend Transport; Tue, 31 Jan 2023 14:58:41 +0000
Received: from SATLEXMB07.amd.com (10.181.41.45) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 31 Jan
 2023 08:58:40 -0600
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB07.amd.com
 (10.181.41.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 31 Jan
 2023 06:58:40 -0800
Received: from xcbalucerop41x.xilinx.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34 via Frontend Transport; Tue, 31 Jan 2023 08:58:38 -0600
From:   <alejandro.lucero-palau@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        <ecree.xilinx@gmail.com>, <linux-doc@vger.kernel.org>,
        <corbet@lwn.net>, <jiri@nvidia.com>,
        "Alejandro Lucero" <alejandro.lucero-palau@amd.com>
Subject: [PATCH v4 net-next 3/8] sfc: enumerate mports in ef100
Date:   Tue, 31 Jan 2023 14:58:17 +0000
Message-ID: <20230131145822.36208-4-alejandro.lucero-palau@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230131145822.36208-1-alejandro.lucero-palau@amd.com>
References: <20230131145822.36208-1-alejandro.lucero-palau@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT039:EE_|MN2PR12MB4501:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a695539-1462-42d5-7ee1-08db039ba415
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: noU+FMmPOICdBaTDWhOwHisAeFb2uJe9Ww0yygau63Al/Gzokc5z54OFwMtSfodBULfBNfergHdQkueNwQB4AlqXsRnotus71SpneKw5phQu5iwz8YGwWchDrwd7Bv2P0MxRfhgwCfYr5ldWKrTS9QlRXKaAhwpDghsCet0WjHBhXhCjpZ2Ls/4RayzvwE4oqOMTK3WAIhwl42ek31+lk34hhRi6iTGSL8ZudBk7FzeGTfrrPnLVcWPuHQHXnCytbopxaMcEr/tP1HRr9Y1Ozlf2jfcAcPAbnpfEksYu1KvSyQE1RZrN8tXBAAKxHoTnL9k/nQxSbDCteWzZsoHEjn7cMA+BqpCyTZ6U7K7RVxzCvPSL4mx2FAIvmEwsyawbTJdTKRsw7y6u1i8C/dqAJTt+8/xNthnAh62EdQIizwqI91DUoSSmSwuSGQGVwSWwwlzFLRL3gqZ1Knh3AvCH6kOk7zCbSgjLp8V45tzRF1h3a5Y2+wrjV5dBrcvj4jRv+16aecFAUOGK2xMAcQXvtvqP/JRkG7cnbloi1tMl0cyGGVriQqDHqBurRZ9Inn6E2Pu94wyetpfpqsZ2GN+e4KpBOEv6g+1kcgJUdvGzggih+hU3rc4GhHGW0OMejPoahlHinh+ThkA87/twS+rT2OBPMQKd1idXhPZqr1K0OP4aRYp3AuXhHDpGf0V6myw4DcJGCPC5ALMcYaPNjjyBAu75I0H/2XhPrJyRZHJHrhpTt2rU9EruDwKN22oyACCb
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(39860400002)(376002)(346002)(451199018)(46966006)(40470700004)(36840700001)(26005)(186003)(2906002)(82740400003)(4326008)(70586007)(36860700001)(40460700003)(86362001)(2876002)(81166007)(30864003)(5660300002)(7416002)(41300700001)(8936002)(356005)(336012)(40480700001)(83380400001)(426003)(47076005)(2616005)(36756003)(54906003)(82310400005)(8676002)(6636002)(70206006)(110136005)(316002)(478600001)(1076003)(6666004)(2004002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2023 14:58:41.0274
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a695539-1462-42d5-7ee1-08db039ba415
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT039.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4501
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
 drivers/net/ethernet/sfc/ef100_nic.c  |  24 ++++
 drivers/net/ethernet/sfc/ef100_nic.h  |   4 +
 drivers/net/ethernet/sfc/ef100_rep.c  |  22 +++
 drivers/net/ethernet/sfc/ef100_rep.h  |   2 +
 drivers/net/ethernet/sfc/mae.c        | 191 ++++++++++++++++++++++++++
 drivers/net/ethernet/sfc/mae.h        |  37 +++++
 drivers/net/ethernet/sfc/mcdi.h       |   5 +
 drivers/net/ethernet/sfc/net_driver.h |   4 +
 8 files changed, 289 insertions(+)

diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index e4aacb4ec666..767edb1d922c 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -747,6 +747,18 @@ static int efx_ef100_get_base_mport(struct efx_nic *efx)
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
 	return 0;
 }
 #endif
@@ -1125,6 +1137,14 @@ int ef100_probe_netdev_pf(struct efx_nic *efx)
 			   "Failed to probe base mport rc %d; representors will not function\n",
 			   rc);
 
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
@@ -1156,6 +1176,10 @@ void ef100_remove(struct efx_nic *efx)
 {
 	struct ef100_nic_data *nic_data = efx->nic_data;
 
+	if (efx->mae) {
+		efx_ef100_fini_reps(efx);
+		efx_fini_mae(efx);
+	}
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

