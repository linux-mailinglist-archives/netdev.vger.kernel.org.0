Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7DDC6ADD95
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 12:37:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231243AbjCGLhY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 06:37:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231207AbjCGLhM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 06:37:12 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2047.outbound.protection.outlook.com [40.107.102.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BE245B93;
        Tue,  7 Mar 2023 03:36:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z4e4+NNlB5V4czLARkpFYNyIjKnJ8cqjjPiIMfPEHpQ2RnLe4R2yl2Oheaezd7snZ/pUi6vyME0P2MiJOc8VbrpuuKqDHH0KGg0bEFlN94tw9tCYglcDO5bdwlIqVJSjVz4PmlJLui2wyx1cBOtbDw/uh9edxq6e/pJ3wf4+4iBGcnNKJf8WzFKoRSaBemfnsB+2Fm9ZagYBxSsf65NwErIqGmSFaEnLMk/2Dgcbw/ZWUvzQLtZqS91aNarB8MIoZsp+mMrcUMqS2UWWFF4xpJRJgY4MI6NMk32n4wQr3T8UofkYf5Lpc+TLW1Z/uBpCtqDCL1NlllEq1VKrgJYkcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iSgf0b7cGvBnWoCD6hvP2e7rQYy0euZ3iPl3ZW5j0jE=;
 b=CZjLVKWsCOt6utSJqZSs+H0i2CTz6PHxIhcadFocJpyWRS3Qz/5qb47UkZ/6yNH+FM4wHG6m9dOzJL6D+MkWL81/6eubDIyQuQg5ZDYT83OgWpQO6hfoXgHhzAnibqyMunpsp9m58fcxzDLHLACYjbtfz8HmewxMbQySXx0OSHSqRa8v2xQiBQVgP1U07E6uRawjAh+DQXaY1CN1ojpOUyg5z5gIwrio0APEl4/RYvft+0VQLgQuspzkET/vVPXVeuGSz6d38k9xQuPn4tSlBS/n+faZqBlIG7NG9WOifojimnrfYUUbthSjN/dBika8Bk1UqgK4m1ZTobaFcQtjhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iSgf0b7cGvBnWoCD6hvP2e7rQYy0euZ3iPl3ZW5j0jE=;
 b=gH64luUNdtjLKcVVw2Xjwzl+AHkEg2LvF5iP8oaofpu61KPLE462iZWIaT35cubUqBpadLxLPliVtKhukVIcXDIMj3KSWDKRNoh58NXlBdushYSMRZu477BvnhbE3PJgLSrFWfglf+N14rk9mcTI4A6/omlV/V24qIbfbPsee1Y=
Received: from BN9PR03CA0389.namprd03.prod.outlook.com (2603:10b6:408:f7::34)
 by MN0PR12MB5834.namprd12.prod.outlook.com (2603:10b6:208:379::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.25; Tue, 7 Mar
 2023 11:36:43 +0000
Received: from BN8NAM11FT058.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f7:cafe::c3) by BN9PR03CA0389.outlook.office365.com
 (2603:10b6:408:f7::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28 via Frontend
 Transport; Tue, 7 Mar 2023 11:36:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN8NAM11FT058.mail.protection.outlook.com (10.13.177.58) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6178.16 via Frontend Transport; Tue, 7 Mar 2023 11:36:43 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 7 Mar
 2023 05:36:40 -0600
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 7 Mar
 2023 03:36:40 -0800
Received: from xndengvm004102.xilinx.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34
 via Frontend Transport; Tue, 7 Mar 2023 05:36:36 -0600
From:   Gautam Dawar <gautam.dawar@amd.com>
To:     <linux-net-drivers@amd.com>, <jasowang@redhat.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <eperezma@redhat.com>, <harpreet.anand@amd.com>,
        <tanuj.kamde@amd.com>, <koushik.dutta@amd.com>,
        Gautam Dawar <gautam.dawar@amd.com>
Subject: [PATCH net-next v2 01/14] sfc: add function personality support for EF100 devices
Date:   Tue, 7 Mar 2023 17:06:03 +0530
Message-ID: <20230307113621.64153-2-gautam.dawar@amd.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230307113621.64153-1-gautam.dawar@amd.com>
References: <20230307113621.64153-1-gautam.dawar@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT058:EE_|MN0PR12MB5834:EE_
X-MS-Office365-Filtering-Correlation-Id: 930ed179-4453-423d-0690-08db1f0039b5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L7SlMVRujpB0p13sJqN9TbumUKDQxFV/kDyUs0QrkJlB8VcgDR5yKdKtd2rbac/QJaI72OMpIoFeAf6B9+RVArgNEmFmmBgQiAxqQw/veo0ByPGpWiNIt34S3ooANj0dqp2VKBWIF+CJbHq+iXIQv1+yhy6QMU8uCO66Lh+qRIcMpyhdYBlsEgYU7SEbB9uch9nniU+KL/0nJVsH/q889aJXarN/F08T5QFAi7u+ha7XceekjOcFRC14Vc8uqRoayEy2xm96ZCPyPuAKFqOB+xA6ebQbmnFmM2R7oUa5bp50eIO6wOByIjL6QBNc7PlVLmotOBbrxcZjclPCIycKN8tBfmOxAIpUoWasQ0xyf3mPsR5k3pk8hx1EyrDWGXJSXBhgiPUvsKOJUvIrLunE3XM1zq3D4bufac/R/U6mB2aGY9cuY+MVRkvDZC9/6k0etjLvW34NeC/rlriVisIEIimaGwDwVjClCb4Itscm6OTG5JIe5Sv6DS2cpdJ1K8l1iI47lYmef9IUdZ3tEBXPavCppWm7WHNxMjyvDng7r/fzhSZ86ftnJNjuYubRejXRXRT/a1h+EJX7e6aEuymyBfJaZF/5c0UQO5vyqLAJ5g+6uHX5PzjCfK4AmlQKF4h6+lzdtaXyw+XrkU+fo9dy/VuuDNTgz+hK8T6ToshXy2IdXT8cXsAFNP583Grc+kSVRKNAYybZUDSWqDn34GpSaWvyw/Mer3wg6OBUco304eZPHsd4JmvhUIf0hNxIy1gr
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(136003)(376002)(346002)(396003)(451199018)(40470700004)(36840700001)(46966006)(7416002)(186003)(36756003)(82310400005)(2616005)(40460700003)(336012)(8936002)(26005)(5660300002)(41300700001)(4326008)(40480700001)(86362001)(1076003)(316002)(36860700001)(83380400001)(44832011)(2906002)(426003)(47076005)(8676002)(81166007)(70586007)(110136005)(6666004)(70206006)(54906003)(478600001)(356005)(921005)(82740400003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2023 11:36:43.1214
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 930ed179-4453-423d-0690-08db1f0039b5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT058.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5834
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A function personality defines the location and semantics of
registers in the BAR. EF100 NICs allow different personalities
of a PCIe function and changing it at run-time. A total of three
function personalities are defined as of now: EF100, vDPA and
None with EF100 being the default.
For now, vDPA net devices can be created on a EF100 virtual
function and the VF personality will be changed to vDPA in the
process.

Co-developed-by: Martin Habets <habetsm.xilinx@gmail.com>
Signed-off-by: Martin Habets <habetsm.xilinx@gmail.com>
Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>
---
 drivers/net/ethernet/sfc/ef100.c     |  6 +-
 drivers/net/ethernet/sfc/ef100_nic.c | 98 +++++++++++++++++++++++++++-
 drivers/net/ethernet/sfc/ef100_nic.h | 11 ++++
 3 files changed, 111 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef100.c b/drivers/net/ethernet/sfc/ef100.c
index 71aab3d0480f..c1c69783db7b 100644
--- a/drivers/net/ethernet/sfc/ef100.c
+++ b/drivers/net/ethernet/sfc/ef100.c
@@ -429,8 +429,7 @@ static void ef100_pci_remove(struct pci_dev *pci_dev)
 	if (!efx)
 		return;
 
-	probe_data = container_of(efx, struct efx_probe_data, efx);
-	ef100_remove_netdev(probe_data);
+	efx_ef100_set_bar_config(efx, EF100_BAR_CONFIG_NONE);
 #ifdef CONFIG_SFC_SRIOV
 	efx_fini_struct_tc(efx);
 #endif
@@ -443,6 +442,7 @@ static void ef100_pci_remove(struct pci_dev *pci_dev)
 	pci_disable_pcie_error_reporting(pci_dev);
 
 	pci_set_drvdata(pci_dev, NULL);
+	probe_data = container_of(efx, struct efx_probe_data, efx);
 	efx_fini_struct(efx);
 	kfree(probe_data);
 };
@@ -508,7 +508,7 @@ static int ef100_pci_probe(struct pci_dev *pci_dev,
 		goto fail;
 
 	efx->state = STATE_PROBED;
-	rc = ef100_probe_netdev(probe_data);
+	rc = efx_ef100_set_bar_config(efx, EF100_BAR_CONFIG_EF100);
 	if (rc)
 		goto fail;
 
diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index 4dc643b0d2db..8cbe5e0f4bdf 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -772,6 +772,99 @@ static int efx_ef100_get_base_mport(struct efx_nic *efx)
 	return 0;
 }
 
+/* BAR configuration.
+ * To change BAR configuration, tear down the current configuration (which
+ * leaves the hardware in the PROBED state), and then initialise the new
+ * BAR state.
+ */
+struct ef100_bar_config_ops {
+	int (*init)(struct efx_probe_data *probe_data);
+	void (*fini)(struct efx_probe_data *probe_data);
+};
+
+static const struct ef100_bar_config_ops bar_config_ops[] = {
+	[EF100_BAR_CONFIG_EF100] = {
+		.init = ef100_probe_netdev,
+		.fini = ef100_remove_netdev
+	},
+#ifdef CONFIG_SFC_VDPA
+	[EF100_BAR_CONFIG_VDPA] = {
+		.init = NULL,
+		.fini = NULL
+	},
+#endif
+	[EF100_BAR_CONFIG_NONE] = {
+		.init = NULL,
+		.fini = NULL
+	},
+};
+
+/* Keep this in sync with the definition of enum ef100_bar_config. */
+static char *bar_config_name[] = {
+	[EF100_BAR_CONFIG_NONE] = "None",
+	[EF100_BAR_CONFIG_EF100] = "EF100",
+	[EF100_BAR_CONFIG_VDPA] = "vDPA",
+};
+
+#ifdef CONFIG_SFC_VDPA
+static bool efx_vdpa_supported(struct efx_nic *efx)
+{
+	return efx->type->is_vf;
+}
+#endif
+
+int efx_ef100_set_bar_config(struct efx_nic *efx,
+			     enum ef100_bar_config new_config)
+{
+	const struct ef100_bar_config_ops *old_config_ops;
+	const struct ef100_bar_config_ops *new_config_ops;
+	struct ef100_nic_data *nic_data = efx->nic_data;
+	struct efx_probe_data *probe_data;
+	enum ef100_bar_config old_config;
+	int rc;
+
+	if (WARN_ON_ONCE(nic_data->bar_config > EF100_BAR_CONFIG_VDPA))
+		return -EINVAL;
+
+#ifdef CONFIG_SFC_VDPA
+	/* Current EF100 hardware supports vDPA on VFs only */
+	if (new_config == EF100_BAR_CONFIG_VDPA && !efx_vdpa_supported(efx)) {
+		pci_err(efx->pci_dev, "vdpa over PF not supported : %s",
+			efx->name);
+		return -EOPNOTSUPP;
+	}
+#endif
+	mutex_lock(&nic_data->bar_config_lock);
+	old_config = nic_data->bar_config;
+	if (new_config == old_config) {
+		mutex_unlock(&nic_data->bar_config_lock);
+		return 0;
+	}
+
+	old_config_ops = &bar_config_ops[old_config];
+	new_config_ops = &bar_config_ops[new_config];
+
+	probe_data = container_of(efx, struct efx_probe_data, efx);
+	if (old_config_ops->fini)
+		old_config_ops->fini(probe_data);
+	nic_data->bar_config = EF100_BAR_CONFIG_NONE;
+
+	if (new_config_ops->init) {
+		rc = new_config_ops->init(probe_data);
+		if (rc) {
+			mutex_unlock(&nic_data->bar_config_lock);
+			return rc;
+		}
+	}
+
+	nic_data->bar_config = new_config;
+	pci_dbg(efx->pci_dev, "BAR configuration changed to %s\n",
+		bar_config_name[new_config]);
+	mutex_unlock(&nic_data->bar_config_lock);
+
+	return 0;
+}
+
 static int compare_versions(const char *a, const char *b)
 {
 	int a_major, a_minor, a_point, a_patch;
@@ -1025,6 +1118,7 @@ static int ef100_probe_main(struct efx_nic *efx)
 		return -ENOMEM;
 	efx->nic_data = nic_data;
 	nic_data->efx = efx;
+	mutex_init(&nic_data->bar_config_lock);
 	efx->max_vis = EF100_MAX_VIS;
 
 	/* Populate design-parameter defaults */
@@ -1208,8 +1302,10 @@ void ef100_remove(struct efx_nic *efx)
 
 	efx_mcdi_detach(efx);
 	efx_mcdi_fini(efx);
-	if (nic_data)
+	if (nic_data) {
 		efx_nic_free_buffer(efx, &nic_data->mcdi_buf);
+		mutex_destroy(&nic_data->bar_config_lock);
+	}
 	kfree(nic_data);
 	efx->nic_data = NULL;
 }
diff --git a/drivers/net/ethernet/sfc/ef100_nic.h b/drivers/net/ethernet/sfc/ef100_nic.h
index f1ed481c1260..4562982f2965 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.h
+++ b/drivers/net/ethernet/sfc/ef100_nic.h
@@ -61,6 +61,13 @@ enum {
 	EF100_STAT_COUNT
 };
 
+/* Keep this in sync with the contents of bar_config_name. */
+enum ef100_bar_config {
+	EF100_BAR_CONFIG_NONE,
+	EF100_BAR_CONFIG_EF100,
+	EF100_BAR_CONFIG_VDPA,
+};
+
 struct ef100_nic_data {
 	struct efx_nic *efx;
 	struct efx_buffer mcdi_buf;
@@ -71,6 +78,8 @@ struct ef100_nic_data {
 	u16 warm_boot_count;
 	u8 port_id[ETH_ALEN];
 	DECLARE_BITMAP(evq_phases, EFX_MAX_CHANNELS);
+	enum ef100_bar_config bar_config;
+	struct mutex bar_config_lock; /* lock to control access to bar config */
 	u64 stats[EF100_STAT_COUNT];
 	u32 base_mport;
 	bool have_mport; /* base_mport was populated successfully */
@@ -95,4 +104,6 @@ int ef100_filter_table_probe(struct efx_nic *efx);
 int ef100_get_mac_address(struct efx_nic *efx, u8 *mac_address,
 			  int client_handle, bool empty_ok);
 int efx_ef100_lookup_client_id(struct efx_nic *efx, efx_qword_t pciefn, u32 *id);
+int efx_ef100_set_bar_config(struct efx_nic *efx,
+			     enum ef100_bar_config new_config);
 #endif	/* EFX_EF100_NIC_H */
-- 
2.30.1

