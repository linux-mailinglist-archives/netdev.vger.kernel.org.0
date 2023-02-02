Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79F5D687BF9
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 12:15:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232102AbjBBLPR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 06:15:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231643AbjBBLPE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 06:15:04 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2060e.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5b::60e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B6C28899A;
        Thu,  2 Feb 2023 03:15:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gGL/10vO+hPcWh7IRqYYKTnbI2ADSGWo9VO9yZFHh+g2nCx/PNrxPj4IztwZo9oRUsYwPqoAp7l660nXmcPoTmLIx0L1pmAqMcIczh+2X0b8JhuJ4BzgT0PDU9OUQkXkdxZFRG21zWjb3/bfWyY6q5y5tJtUetORVJWj+GcCBuMv4QWIlEQ3wnCvcI63FdR18c2SnzwdbHBmitbKRfQz5eznNrslakPjeMA7gYup+euN+H6drOpmpDwRCiCThx3njEGHZcUSgjf2LsMKtsb+tMQjRGidcKmaWUeRPp/O3qJ56+jd8SbpQpV9A7k/TaOQRRYzRunpvJD/0zY6c5MFrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cu4HWPj4FaJiFpjcca3llU3x9PtpcjxTPbL8Y0KluP0=;
 b=FY8o6SnV6yEw63XtWBa6LMD4blxw8SXOMKu2zP1nIzlzVk/imqiKaU6KpEZX7AKEcs29rjWCulE04tXv9ikZcoL5sdVbZsTx2yD3KSrTG1p9hQjQj0NyJa0aQTf/lzdkHX7E2EjqX73ctsCCcbjbPHN1tenVIEHb6tDAiYuVg/UdeR66etKgmye1Zngw0liDGPigzbXE9UsuqvoXlwSEKaAVLkdST4Hcj6KQnNrgEKBy8yOjpB5UuIZNCBW7eVboiy/py1E2c2TOU+Z7G7/RKS5UHJzQBhZ8CT48axTZsYA4yznYq0O2giNzYF6PaHG8grwcJJ1qXbZTCvIk3mzUhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cu4HWPj4FaJiFpjcca3llU3x9PtpcjxTPbL8Y0KluP0=;
 b=R7N55RjDx3NVatL7N60+Usn5jl8cZVstqWJvtFTAB64+RCl2hrvDvD2gn72e1bxln1KkCPGWrpELTigGelRQurj+AnFWL4yl/lfOpttxROJRUqhi9vuX3bqCJecCIA1GTz0XnmyFedESMSY7qFLxYp0IVIAvi2tRqIMuiu8LE2A=
Received: from MW4PR03CA0180.namprd03.prod.outlook.com (2603:10b6:303:8d::35)
 by CY5PR12MB6371.namprd12.prod.outlook.com (2603:10b6:930:f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.24; Thu, 2 Feb
 2023 11:14:58 +0000
Received: from CO1NAM11FT061.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8d:cafe::97) by MW4PR03CA0180.outlook.office365.com
 (2603:10b6:303:8d::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27 via Frontend
 Transport; Thu, 2 Feb 2023 11:14:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT061.mail.protection.outlook.com (10.13.175.200) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6064.27 via Frontend Transport; Thu, 2 Feb 2023 11:14:58 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 2 Feb
 2023 05:14:57 -0600
Received: from xcbalucerop41x.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34 via Frontend Transport; Thu, 2 Feb 2023 05:14:56 -0600
From:   <alejandro.lucero-palau@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        <ecree.xilinx@gmail.com>, <linux-doc@vger.kernel.org>,
        <corbet@lwn.net>, <jiri@nvidia.com>,
        "Alejandro Lucero" <alejandro.lucero-palau@amd.com>
Subject: [PATCH v5 net-next 7/8] sfc: add support for devlink port_function_hw_addr_get in ef100
Date:   Thu, 2 Feb 2023 11:14:22 +0000
Message-ID: <20230202111423.56831-8-alejandro.lucero-palau@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230202111423.56831-1-alejandro.lucero-palau@amd.com>
References: <20230202111423.56831-1-alejandro.lucero-palau@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT061:EE_|CY5PR12MB6371:EE_
X-MS-Office365-Filtering-Correlation-Id: 38a9edbf-beb8-48b4-e782-08db050eb89e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rurwNMwX08WTeSYGlyTV/qyazAZKJDk/+/Nv0D2z8DWSIklMcOMYFs9G6JdIxvr4S7eHWpsryUZehxLNW7gQMy0z5bUvA0KuAV862xw3/87/fHvcTgKI+Gk094t5vh4j58v8O5lp4+hMoBZdD0dDybXEen6yP16xzPVQE/iF/B5bBzIKmHABoEOMcheKihrJmLOPSNcskprAMbKclAzSlt4NZkx7WPTH4ulJcOOBoneqdPmCNKblfhCkf0e4V8sZEhIwmYAlnJ8omF9pdXhrwjvjmfPJ3T/EAHilTt0DszvfFEaishnfK1CSZ/WVITuiCFM79PpguQJQCmdYqgPooce6vyb80/eblWZXkQwGIpnVB/UoXo7lUykLI8GffhOO8GRtG7vOx97qtIcFpHLstrdwtkdJ3t5U4k8FGC2RViFNC4pF2CVcU7pM3yon0PTqr7joyEeEhsjwGa7jiwaO6GwkvaWD3yzSOlgCAy+i6B9HczV38BUsypbPVL+RY1XV3LhehB+VmgxDrI1B5E8VPLbUt46sbJvBS2HSvJTU0nTmPJKajs/k2EZjWEUyyTe/QznYUPlvCz6tmAhHXyd4wEJ8+stkrXyr4KPViDxe950vQk0r+Aw6lf28iHXqcHnb/kCkLZ+es529HuFcxTRadoaPQmNQw7B5Y/9dsONlVAqpYAtOzPbxC3MBv6N3hBLA4tMfyn/0qdstawXdBbm/mnqMZFdd4rw7zN8M+EZRFCM=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(396003)(376002)(39860400002)(451199018)(40470700004)(46966006)(36840700001)(316002)(36860700001)(2876002)(186003)(40480700001)(81166007)(2616005)(6636002)(2906002)(82310400005)(6666004)(86362001)(1076003)(478600001)(356005)(26005)(110136005)(426003)(36756003)(54906003)(336012)(40460700003)(5660300002)(41300700001)(70206006)(70586007)(4326008)(82740400003)(7416002)(47076005)(8676002)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 11:14:58.6441
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 38a9edbf-beb8-48b4-e782-08db050eb89e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT061.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6371
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
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
 drivers/net/ethernet/sfc/ef100_nic.c   | 27 +++++++++++++
 drivers/net/ethernet/sfc/ef100_nic.h   |  1 +
 drivers/net/ethernet/sfc/ef100_rep.c   |  8 ++++
 drivers/net/ethernet/sfc/ef100_rep.h   |  1 +
 drivers/net/ethernet/sfc/efx_devlink.c | 53 ++++++++++++++++++++++++++
 5 files changed, 90 insertions(+)

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
index afdb19f0c774..c44547b9894e 100644
--- a/drivers/net/ethernet/sfc/efx_devlink.c
+++ b/drivers/net/ethernet/sfc/efx_devlink.c
@@ -60,6 +60,56 @@ static int efx_devlink_add_port(struct efx_nic *efx,
 
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
@@ -522,6 +572,9 @@ static int efx_devlink_info_get(struct devlink *devlink,
 
 static const struct devlink_ops sfc_devlink_ops = {
 	.info_get			= efx_devlink_info_get,
+#ifdef CONFIG_SFC_SRIOV
+	.port_function_hw_addr_get	= efx_devlink_port_addr_get,
+#endif
 };
 
 #ifdef CONFIG_SFC_SRIOV
-- 
2.17.1

