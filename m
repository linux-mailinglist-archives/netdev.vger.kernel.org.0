Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63D6568300A
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 15:59:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232252AbjAaO7i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 09:59:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232201AbjAaO66 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 09:58:58 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2041.outbound.protection.outlook.com [40.107.100.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01850869A;
        Tue, 31 Jan 2023 06:58:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l0f7laxIdsFuHdMlHTfaMLXXoLKNUC/4rgi9PikS8ZNuQ7gMNsM0wfu8dw6vI6ueSfKtJ4YJFK9Zz/4TKPR8C5vvIuc5iwrba882VV1jSJPFCip3FPH+CAYMm6hZwtJlXBoBQE5VR1UmZm+m00gtl6WH/bLNn1eRHaDygxi9Xbn6Ucd3IJIInW7rK5L2TckQrB8AFH7dpgCvwnvCWfEVBUgmustfS8PuqRC5Wcq+rbqmRIRBI2WUUIeZJUcDPJHaaTMjI3R9JzyjPDOHN635NJgiY1oyyn1ufAZGGSbvdc4765WMtbVtZKFgAMFGXl/xCExAkep5A+D5FXq9bXvJ/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yeZ3rucqmohHozuA48g1DL6kqbvCB6bNQ2pmcd80ry0=;
 b=RhEJVlmGi4eOcUXQZVPphFcr11m7poEo/5e0853SbN5QsBq96yJd8Jx3MymJTMskl6yvC6r3P4tuJzWu5rEUX8EUt1Z9L6cxeL2Z4LcBmw6D2rFArhh6JU8PN0kmgD4+31BWsXIPSRHzVliAR2IeMQlTm3o4X5sfWkbOM1fAZKelAvRgywlnJckXE3LsodpVMCYhSstDwLs/FTFVS6K4BUgPXRIhOlFG0phR0yPiJ3NxJfVRiwiVOHXrTHw16tyN+Vzqocm8mPE2HaaRNcVt6iV8alULr3682Y6qWn80EPiTsHzuLGLBA8u1XGIr1Bo+J4CAbR2yZiya09fizlUT2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yeZ3rucqmohHozuA48g1DL6kqbvCB6bNQ2pmcd80ry0=;
 b=PfAGKh9toZhLjQQcTknIOiIDL2evH9lJVj7RqZJHMUDqot8xbrjqxm59L4f6T8D71Y8YwtWDh46oFimTzxSnatzm8C6Vf72eQ+jiKy0YV6cV1K06hkOj1selX0XXnH9HzMi3x6DPRpkq2vNKD2jESZ69/RwKGbkuG2aVhjS1WUI=
Received: from DM6PR02CA0037.namprd02.prod.outlook.com (2603:10b6:5:177::14)
 by DM4PR12MB5915.namprd12.prod.outlook.com (2603:10b6:8:68::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Tue, 31 Jan
 2023 14:58:54 +0000
Received: from DM6NAM11FT108.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:177:cafe::3b) by DM6PR02CA0037.outlook.office365.com
 (2603:10b6:5:177::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38 via Frontend
 Transport; Tue, 31 Jan 2023 14:58:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT108.mail.protection.outlook.com (10.13.172.95) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6064.22 via Frontend Transport; Tue, 31 Jan 2023 14:58:54 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 31 Jan
 2023 08:58:51 -0600
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 31 Jan
 2023 08:58:50 -0600
Received: from xcbalucerop41x.xilinx.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34 via Frontend Transport; Tue, 31 Jan 2023 08:58:49 -0600
From:   <alejandro.lucero-palau@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        <ecree.xilinx@gmail.com>, <linux-doc@vger.kernel.org>,
        <corbet@lwn.net>, <jiri@nvidia.com>,
        "Alejandro Lucero" <alejandro.lucero-palau@amd.com>
Subject: [PATCH v4 net-next 7/8] sfc: add support for devlink port_function_hw_addr_get in ef100
Date:   Tue, 31 Jan 2023 14:58:21 +0000
Message-ID: <20230131145822.36208-8-alejandro.lucero-palau@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230131145822.36208-1-alejandro.lucero-palau@amd.com>
References: <20230131145822.36208-1-alejandro.lucero-palau@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT108:EE_|DM4PR12MB5915:EE_
X-MS-Office365-Filtering-Correlation-Id: dd5b2318-5027-4410-516f-08db039babd8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xh2iQOCoq5JXid94HsFCQFLl0rQRZKZgp4/oOFcwwHUhZV/p/u0xm/XxDCYRiuY6DKpSmIHbJvJBCe6UHH2JQhL7kaKNq8/7oFxARmq7t/ZwEUooZIW7CbaDDXQf2tJo9q9nZmnyTnNMNbdwHyRBg0qaL9NN/GyDFiWKj1C74m6oFbyTDkvWqLnF0TgZSISqxHgxYsWE5XAmse6vrPoejzlM4G/hMiIAkxA34uEnaZNzJT3fF4VwyP8CovB/Y943IWVWCofUIIcLKXgNG7KRzuWYb6gU5A1PNbcQnt4pFFnSUzWTQ77RNOcrTjRhYiJpi6GEv1GiaJFj50fjAqicMtHyOudnLjodjhmbMqoP4Ok/cBf9lj3EUGGfKkvB37hyFScgSYhjpm9AS13zh9oAan/Tpsh3ys4b4kguDN+BIu8bliYeKPLWvmiWOJHHIfKOd8ce+9KO5yqR/yFlQcJe/6Xo68pTUbJOHx4luRVltthMSrXBbtneAOFC+ppJg0HYPb7BZC9eIIwbuGwcBzdVZD/41tJL1X4JDH87vhTz6VDbTHj31eOryl9nD9Q3xvtLqkUqIuF2vwfrjrC8Ba69fhJOk+0zujUR25wIl0Eq9+VL9dZNkdoiQXCw8b3aJ1d4Tzqk2i2ppnZJPU2iahFBpXJqUiWR42bQCfPMmJwUsJkaKTqDBAmHJbXYC5kusSa5WFoIytB+DS4wLjl7Xm/bo9Fsb+77oUXt0L/fXCe1vWg=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(396003)(39860400002)(346002)(451199018)(46966006)(36840700001)(40470700004)(8676002)(70586007)(70206006)(336012)(2616005)(47076005)(316002)(426003)(6636002)(110136005)(40460700003)(478600001)(6666004)(54906003)(186003)(1076003)(26005)(36756003)(86362001)(7416002)(2876002)(81166007)(2906002)(356005)(4326008)(40480700001)(82310400005)(5660300002)(82740400003)(8936002)(41300700001)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2023 14:58:54.0014
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dd5b2318-5027-4410-516f-08db039babd8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT108.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5915
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

Using the builtin client handle id infrastructure, this patch adds
support for obtaining the mac address linked to mports in ef100. This
implies to execute an MCDI command for getting the data from the
firmware for each devlink port.

Signed-off-by: Alejandro Lucero <alejandro.lucero-palau@amd.com>
---
 drivers/net/ethernet/sfc/ef100_nic.c   | 27 ++++++++++++++
 drivers/net/ethernet/sfc/ef100_nic.h   |  1 +
 drivers/net/ethernet/sfc/ef100_rep.c   |  8 +++++
 drivers/net/ethernet/sfc/ef100_rep.h   |  1 +
 drivers/net/ethernet/sfc/efx_devlink.c | 50 ++++++++++++++++++++++++++
 5 files changed, 87 insertions(+)

diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index bcf937fb3d95..e64a7fb5353b 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -1121,6 +1121,33 @@ static int ef100_probe_main(struct efx_nic *efx)
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
index b1637eb372ad..709418b1935a 100644
--- a/drivers/net/ethernet/sfc/efx_devlink.c
+++ b/drivers/net/ethernet/sfc/efx_devlink.c
@@ -58,6 +58,55 @@ static int efx_devlink_add_port(struct efx_nic *efx,
 	return devl_port_register(efx->devlink, &mport->dl_port, mport->mport_id);
 }
 
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
 static int efx_devlink_info_nvram_partition(struct efx_nic *efx,
 					    struct devlink_info_req *req,
 					    unsigned int partition_type,
@@ -463,6 +512,7 @@ static int efx_devlink_info_get(struct devlink *devlink,
 
 static const struct devlink_ops sfc_devlink_ops = {
 	.info_get			= efx_devlink_info_get,
+	.port_function_hw_addr_get	= efx_devlink_port_addr_get,
 };
 
 static struct devlink_port *ef100_set_devlink_port(struct efx_nic *efx, u32 idx)
-- 
2.17.1

