Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B65F6694F7D
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 19:35:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231153AbjBMSfn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 13:35:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230457AbjBMSfd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 13:35:33 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2068.outbound.protection.outlook.com [40.107.94.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D10D51D927;
        Mon, 13 Feb 2023 10:35:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jmAS2Rr0Fz/vAFJOsxbC06jVb+fu+EfmUkqgXW4r7qkr+Lx9LP6cX9bhhpaAuWA5IOkeCH/iiUh/Qq/pcs0vxTm/J3zlHU+9uGxPaLfDWR9PnLFDMFvLTwH/Hz2p7LAmg9Z59Za6yPc1YWyTu5O1agb/Y9OGjQluRKeFkePfT2JiBVn284MRfdK7G659R4rGVdLnjMFit0GBehik3iKdOXYB7cuL3QXaJnP7zGKjU6neAtGUxfLrG/CpZcX2TPVeRRJRFKh6cK5k1yFwqJxOHHiaS/Jgpa4DN0YBxNUk1zVlaEnBDoW480FGcdCAgiFwQm7IZcn71graqVppKTTFHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZJ2IQQJdbCsosFJC5HhVqN/WG3WeZrVLXZbz/aTJCkw=;
 b=XJ/nO+BtxLEQQ8X/3aa1on1ic+Ii2MKaElTAk7Cr30BhnQGvyR3UcGQbGHhdxftKJjd/HvxyQRNIqFMyTAmrPaue9HHIdZlyLbvLt+S3X6V+sCX1wX/4Zepk2Zje1ll6YQkx3WE4UJFKSAQdTUe2xtoiITogrOKazrmBgHUEvuuQvNWGpb3mzG15yQlmM5vbT62Jn9VctG4HKBtgmlPSNG0p50Q+DCdlF1ers02gxq2XRVPfLMViWtJICnuSTSq54ADMXc5AebLmFDRRk2rr1BtdzOVtv6BXjustovSW3AVvD8V/u6gV3xPn3AgUTFqSrsI1ENAaiU7G5ZIyApsJeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZJ2IQQJdbCsosFJC5HhVqN/WG3WeZrVLXZbz/aTJCkw=;
 b=q+3O/jx674pE6+EANlYrShtXyrH2me+BUoq1n0b8r4PaavOGB3L68KBHh0ngaQOshJlB4R4fB1U6wcv6OgzF2zyVFvxwSHsTLvXUn3mLF7iHZmfOjAVrTs9FAtdey1AXSatUA2ENkUTycSiIZYd/1TPrDnm/tpIpF8oCSmAYJCQ=
Received: from BN9PR03CA0452.namprd03.prod.outlook.com (2603:10b6:408:139::7)
 by DM6PR12MB4562.namprd12.prod.outlook.com (2603:10b6:5:2aa::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Mon, 13 Feb
 2023 18:35:26 +0000
Received: from BN8NAM11FT072.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:139:cafe::5a) by BN9PR03CA0452.outlook.office365.com
 (2603:10b6:408:139::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24 via Frontend
 Transport; Mon, 13 Feb 2023 18:35:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN8NAM11FT072.mail.protection.outlook.com (10.13.176.165) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6086.24 via Frontend Transport; Mon, 13 Feb 2023 18:35:25 +0000
Received: from SATLEXMB07.amd.com (10.181.41.45) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 13 Feb
 2023 12:35:25 -0600
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB07.amd.com
 (10.181.41.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 13 Feb
 2023 10:35:25 -0800
Received: from xcbalucerop41x.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34 via Frontend Transport; Mon, 13 Feb 2023 12:35:23 -0600
From:   <alejandro.lucero-palau@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        <ecree.xilinx@gmail.com>, <linux-doc@vger.kernel.org>,
        <corbet@lwn.net>, <jiri@nvidia.com>,
        "Alejandro Lucero" <alejandro.lucero-palau@amd.com>
Subject: [PATCH v7 net-next 7/8] sfc: add support for devlink port_function_hw_addr_get in ef100
Date:   Mon, 13 Feb 2023 18:34:27 +0000
Message-ID: <20230213183428.10734-8-alejandro.lucero-palau@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230213183428.10734-1-alejandro.lucero-palau@amd.com>
References: <20230213183428.10734-1-alejandro.lucero-palau@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT072:EE_|DM6PR12MB4562:EE_
X-MS-Office365-Filtering-Correlation-Id: 02863402-1889-4598-6c69-08db0df112ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W/HrEFucb96PGKzphG7vrUoMWpkckm0SWcRAXSDsbCKC1WGCvkzinw4iIu+0vAr1ySPQGbdO/imiyIo7InVSmZr5PJLVQ8xzZjadQV7nyGODgTSAJkFNU5oNJc9c681VN2p0SdEXZdC7hDc+tymxgDc0jvKbvXc/4l+AcNDCgcF+lAoj1flYdagMH+cP8ZR/S+VSWmyxZWqC8xbuGQUdeJenjO4sYgRTf4uNnoP6eEGwJ3t+Quqpl9ZKOYx4YcjtCiySrwqBR77p/Ma2PY4kVZeCee00byKNw5KTo7+B5WGAQocyayuLqBFujvjrvOJKiLCVJ9VHVeN1s6+T1IFDm0nuRrc3hBHaZbID+52mYhlWRouhllMsQA7Aqc69Igu6pvT4pxKpdLxARGJmVe4Tn8jTdeq2VO9bn6py8yaPEsAbbv1O0ArBhnn2T0qZXamQKc3ptalthYFx3uEri47U0vXbeZUdS1odiyLxLtI8YZv2XEtsAahhWeHxzUUVaxTIdRbfQd+50Lf1L7tyTQXGLj6i/McsYeI/fylONNzGv+yZYnIb1zgvwRysU91dINLZGns+3FosokT+clYXjYkXenA0/cJfIWSDgM8GywEx7oaaPG27/p5RggrYgvNK+ooFXQ0VHnxu5+lYoep0jUrV5xdc3nn155aUHR3c8ZUBg5Fd2MFimUTvw23JshESzcCNNBUZxlC3wli73GzNfrqnj8hMySqZqeTyuMqAmJnH/VE=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(376002)(39860400002)(136003)(451199018)(46966006)(40470700004)(36840700001)(82310400005)(36756003)(7416002)(2906002)(8936002)(5660300002)(2876002)(316002)(40480700001)(8676002)(70586007)(4326008)(86362001)(70206006)(41300700001)(36860700001)(356005)(54906003)(6636002)(81166007)(110136005)(82740400003)(40460700003)(47076005)(426003)(336012)(478600001)(2616005)(1076003)(186003)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 18:35:25.8417
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 02863402-1889-4598-6c69-08db0df112ed
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT072.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4562
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

Using the builtin client handle id infrastructure, add support for
obtaining the mac address linked to mports in ef100. This implies
to execute an MCDI command for getting the data from the firmware
for each devlink port.

Signed-off-by: Alejandro Lucero <alejandro.lucero-palau@amd.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Acked-by: Martin Habets <habetsm.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/ef100_nic.c   | 27 +++++++++++++
 drivers/net/ethernet/sfc/ef100_nic.h   |  1 +
 drivers/net/ethernet/sfc/ef100_rep.c   |  8 ++++
 drivers/net/ethernet/sfc/ef100_rep.h   |  1 +
 drivers/net/ethernet/sfc/efx_devlink.c | 54 ++++++++++++++++++++++++++
 5 files changed, 91 insertions(+)

diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index aa48c79a2149..becd21c2325d 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -1122,6 +1122,33 @@ static int ef100_probe_main(struct efx_nic *efx)
 	return rc;
 }
 
+/* MCDI commands are related to the same device issuing them. This function
+ * allows to do an MCDI command on behalf of another device, mainly PFs setting
+ * things for VFs.
+ */
+int efx_ef100_lookup_client_id(struct efx_nic *efx, efx_qword_t pciefn, u32 *id)
+{
+	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_CLIENT_HANDLE_OUT_LEN);
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_GET_CLIENT_HANDLE_IN_LEN);
+	u64 pciefn_flat = le64_to_cpu(pciefn.u64[0]);
+	size_t outlen;
+	int rc;
+
+	MCDI_SET_DWORD(inbuf, GET_CLIENT_HANDLE_IN_TYPE,
+		       MC_CMD_GET_CLIENT_HANDLE_IN_TYPE_FUNC);
+	MCDI_SET_QWORD(inbuf, GET_CLIENT_HANDLE_IN_FUNC,
+		       pciefn_flat);
+
+	rc = efx_mcdi_rpc(efx, MC_CMD_GET_CLIENT_HANDLE, inbuf, sizeof(inbuf),
+			  outbuf, sizeof(outbuf), &outlen);
+	if (rc)
+		return rc;
+	if (outlen < sizeof(outbuf))
+		return -EIO;
+	*id = MCDI_DWORD(outbuf, GET_CLIENT_HANDLE_OUT_HANDLE);
+	return 0;
+}
+
 int ef100_probe_netdev_pf(struct efx_nic *efx)
 {
 	struct ef100_nic_data *nic_data = efx->nic_data;
diff --git a/drivers/net/ethernet/sfc/ef100_nic.h b/drivers/net/ethernet/sfc/ef100_nic.h
index e59044072333..f1ed481c1260 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.h
+++ b/drivers/net/ethernet/sfc/ef100_nic.h
@@ -94,4 +94,5 @@ int ef100_filter_table_probe(struct efx_nic *efx);
 
 int ef100_get_mac_address(struct efx_nic *efx, u8 *mac_address,
 			  int client_handle, bool empty_ok);
+int efx_ef100_lookup_client_id(struct efx_nic *efx, efx_qword_t pciefn, u32 *id);
 #endif	/* EFX_EF100_NIC_H */
diff --git a/drivers/net/ethernet/sfc/ef100_rep.c b/drivers/net/ethernet/sfc/ef100_rep.c
index 6b5bc5d6955d..0b3083ef0ead 100644
--- a/drivers/net/ethernet/sfc/ef100_rep.c
+++ b/drivers/net/ethernet/sfc/ef100_rep.c
@@ -361,6 +361,14 @@ bool ef100_mport_on_local_intf(struct efx_nic *efx,
 		     mport_desc->interface_idx == nic_data->local_mae_intf;
 }
 
+bool ef100_mport_is_vf(struct mae_mport_desc *mport_desc)
+{
+	bool pcie_func;
+
+	pcie_func = ef100_mport_is_pcie_vnic(mport_desc);
+	return pcie_func && (mport_desc->vf_idx != MAE_MPORT_DESC_VF_IDX_NULL);
+}
+
 void efx_ef100_init_reps(struct efx_nic *efx)
 {
 	struct ef100_nic_data *nic_data = efx->nic_data;
diff --git a/drivers/net/ethernet/sfc/ef100_rep.h b/drivers/net/ethernet/sfc/ef100_rep.h
index ae6add4b0855..a042525a2240 100644
--- a/drivers/net/ethernet/sfc/ef100_rep.h
+++ b/drivers/net/ethernet/sfc/ef100_rep.h
@@ -76,4 +76,5 @@ void efx_ef100_fini_reps(struct efx_nic *efx);
 struct mae_mport_desc;
 bool ef100_mport_on_local_intf(struct efx_nic *efx,
 			       struct mae_mport_desc *mport_desc);
+bool ef100_mport_is_vf(struct mae_mport_desc *mport_desc);
 #endif /* EF100_REP_H */
diff --git a/drivers/net/ethernet/sfc/efx_devlink.c b/drivers/net/ethernet/sfc/efx_devlink.c
index 1bff2f607261..1c9dc15c8618 100644
--- a/drivers/net/ethernet/sfc/efx_devlink.c
+++ b/drivers/net/ethernet/sfc/efx_devlink.c
@@ -9,6 +9,7 @@
  */
 
 #include "net_driver.h"
+#include "ef100_nic.h"
 #include "efx_devlink.h"
 #include <linux/rtc.h>
 #include "mcdi.h"
@@ -58,6 +59,56 @@ static int efx_devlink_add_port(struct efx_nic *efx,
 
 	return devl_port_register(efx->devlink, &mport->dl_port, mport->mport_id);
 }
+
+static int efx_devlink_port_addr_get(struct devlink_port *port, u8 *hw_addr,
+				     int *hw_addr_len,
+				     struct netlink_ext_ack *extack)
+{
+	struct efx_devlink *devlink = devlink_priv(port->devlink);
+	struct mae_mport_desc *mport_desc;
+	efx_qword_t pciefn;
+	u32 client_id;
+	int rc = 0;
+
+	mport_desc = container_of(port, struct mae_mport_desc, dl_port);
+
+	if (!ef100_mport_on_local_intf(devlink->efx, mport_desc)) {
+		rc = -EINVAL;
+		NL_SET_ERR_MSG_FMT(extack,
+				   "Port not on local interface (mport: %u)",
+				   mport_desc->mport_id);
+		goto out;
+	}
+
+	if (ef100_mport_is_vf(mport_desc))
+		EFX_POPULATE_QWORD_3(pciefn,
+				     PCIE_FUNCTION_PF, PCIE_FUNCTION_PF_NULL,
+				     PCIE_FUNCTION_VF, mport_desc->vf_idx,
+				     PCIE_FUNCTION_INTF, PCIE_INTERFACE_CALLER);
+	else
+		EFX_POPULATE_QWORD_3(pciefn,
+				     PCIE_FUNCTION_PF, mport_desc->pf_idx,
+				     PCIE_FUNCTION_VF, PCIE_FUNCTION_VF_NULL,
+				     PCIE_FUNCTION_INTF, PCIE_INTERFACE_CALLER);
+
+	rc = efx_ef100_lookup_client_id(devlink->efx, pciefn, &client_id);
+	if (rc) {
+		NL_SET_ERR_MSG_FMT(extack,
+				   "No internal client_ID for port (mport: %u)",
+				   mport_desc->mport_id);
+		goto out;
+	}
+
+	rc = ef100_get_mac_address(devlink->efx, hw_addr, client_id, true);
+	if (rc != 0)
+		NL_SET_ERR_MSG_FMT(extack,
+				   "No available MAC for port (mport: %u)",
+				   mport_desc->mport_id);
+out:
+	*hw_addr_len = ETH_ALEN;
+	return rc;
+}
+
 #endif
 
 static int efx_devlink_info_nvram_partition(struct efx_nic *efx,
@@ -516,6 +567,9 @@ static int efx_devlink_info_get(struct devlink *devlink,
 
 static const struct devlink_ops sfc_devlink_ops = {
 	.info_get			= efx_devlink_info_get,
+#ifdef CONFIG_SFC_SRIOV
+	.port_function_hw_addr_get	= efx_devlink_port_addr_get,
+#endif
 };
 
 #ifdef CONFIG_SFC_SRIOV
-- 
2.17.1

