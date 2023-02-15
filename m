Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8913E6978B3
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 10:10:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233688AbjBOJJ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 04:09:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233769AbjBOJJ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 04:09:56 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2051.outbound.protection.outlook.com [40.107.94.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8C69367F7;
        Wed, 15 Feb 2023 01:09:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C02iWlS40gZbA2/f+MfKBo/emeRrPkZ+fQ0JZCQkUllHJN/q411ViX63vP6EsSJyoFQ2Eq72MOwxkynjHwrLuBr5+uCG9J4anft8oN3ZQHuubLQ4pZlyvrom8afyPsz4EQxXTx4DW4BMEf6vd2VfvxJUKTipeFKVHZIr+FmHMgLlfr7s/9qj0yA5lDPeNOoucYMPXtdDVW8ZVn13B3Ur/VWVT3mifVGnx+hXGyyloybl/MXcUo7wjcqcjRIkl8ZgVWp59Bx0Hnl2T7AByWS2k15eOzGf3UcYQ4oD9mnMrOYrJFr7Vp/8YrqSLYPC9VzLn3jYmHmM1Folk+ZUquUxew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sX93ghUCKmRMNGLD3RbQVoAJW3hbCu6ODF+JPMntlGs=;
 b=H695Q7kQgDSNptJwfEn6S0YhzjdcbpXZ51hi4GxxXyxn3QJkTEoYiJlk8z5Wkr198P//3oelCO9PfPv/r8BM2am+30nSuM+Yn1Ps9GAGz+lYlMJyaOR4ouCZ+9LrF/9wcV0KT9ROTLZdmeiXymajL5ZgASe6GbUrQ2KKPA2b4CcbD6VEZn0aADVvZnpuwAzNWmioMCBEy92WZcCj1pfB7HXslz0ggbYVfH5poWUhWhzemqRK9T3cEuypVtVZ8cE286DXFb1Dn2zjrtZAJU0W0REQmgfbEFcvQscyFq0d4Ot6io73VSFvfgSbgg6RkXuIEA0RApH6grXfUBJpFf8jqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sX93ghUCKmRMNGLD3RbQVoAJW3hbCu6ODF+JPMntlGs=;
 b=mGO7SuHcC9K4uzGozIREgnmtpNXy2dblOZ/JooFkuJ/L/rjWLqzQveaZz35NSlnSpUoTRHNcCCdsD30qplHGpSKuTYOHQRcOKDj3MRtRMidLy75QzUg4sd8KrQ/r3r83cUYDKTFDUaNl3L2bsVsFt3sqFY6w2NZS8PJ8sIxsgJg=
Received: from DM5PR07CA0070.namprd07.prod.outlook.com (2603:10b6:4:ad::35) by
 SJ0PR12MB7082.namprd12.prod.outlook.com (2603:10b6:a03:4ae::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Wed, 15 Feb
 2023 09:09:40 +0000
Received: from DM6NAM11FT063.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:ad:cafe::16) by DM5PR07CA0070.outlook.office365.com
 (2603:10b6:4:ad::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26 via Frontend
 Transport; Wed, 15 Feb 2023 09:09:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT063.mail.protection.outlook.com (10.13.172.219) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6111.12 via Frontend Transport; Wed, 15 Feb 2023 09:09:40 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 15 Feb
 2023 03:09:36 -0600
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 15 Feb
 2023 01:09:27 -0800
Received: from xcbalucerop41x.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34 via Frontend Transport; Wed, 15 Feb 2023 03:09:25 -0600
From:   <alejandro.lucero-palau@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        <ecree.xilinx@gmail.com>, <linux-doc@vger.kernel.org>,
        <corbet@lwn.net>, <jiri@nvidia.com>,
        "Alejandro Lucero" <alejandro.lucero-palau@amd.com>
Subject: [PATCH v8 net-next 7/8] sfc: add support for devlink port_function_hw_addr_get in ef100
Date:   Wed, 15 Feb 2023 09:08:27 +0000
Message-ID: <20230215090828.11697-8-alejandro.lucero-palau@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230215090828.11697-1-alejandro.lucero-palau@amd.com>
References: <20230215090828.11697-1-alejandro.lucero-palau@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT063:EE_|SJ0PR12MB7082:EE_
X-MS-Office365-Filtering-Correlation-Id: a7d7f6fa-e33c-4c04-f341-08db0f345e9d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FuuF5wOIknylhiA6XSA6hpRVAjHGO5oIAvod6NSu+ETDRijfSay95vwd7TU4CGqyEDtouJcdh7A/WrDp380CBj949IA+2NUCezR/UPaxliQOs+HHWx3QY+LcLnvVpZ1b/xcKwLrI2mc/djvVZC5a1mE/AZdIP1sapClq4N/VCWt3/eUJhpJWEfanmu+j40o0Rmf9nbjKww6IpxnIE4v20jT02quCRDbAyMypTRGcdswvjr2lqSwYiQsNyax/7by3Pt5uvG3jscgJZXpz4lZBfTPv4NfpOaAeO/5ZuoGNKPj0vCTvEfg3qCsEkpD8h63T5B3kSFi8md28mWjik7FA9l22zo6z5TJspV8Bhh386+9IR/9fi+SqVRATE54D7OP0yeoJNEf4cCrZJGh7emlIbWYx66HUDVl5S4staVeM5ZnMxfGoit8fD/+rSOrV/f7BS2vGcpaulOmbp8AhvyUSSBT1z+WpCf38bTwS0SCqbatWJwp/yRdUm2plMR9lrotKSc0oABvkNubtjWDKJEiA6DfH/C2Bi9NSkF0XmFP7ARVfVLz9ZHPb5NhPNGHV9Sh8fo9JQhTyRen6u+2AWj8AEK4jvmj8V+QdD/NwzIJtYJgWksCRQ0j0ORrMrnorj7kXQN5jQ+XBDJnnLDtNhkTmaKFilEN1r5M3tSd3trlZ/GvBImOf2/gz0Tv8pgqOlX3OAaEK1t2hkiHmy01Ri5qQXAZEN6dcabrYgPn8iXUff4o=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(346002)(39860400002)(396003)(451199018)(36840700001)(46966006)(40470700004)(110136005)(6636002)(54906003)(478600001)(426003)(336012)(2616005)(47076005)(1076003)(36756003)(186003)(26005)(356005)(41300700001)(5660300002)(86362001)(8936002)(40460700003)(7416002)(40480700001)(316002)(8676002)(4326008)(2906002)(82310400005)(70206006)(81166007)(82740400003)(70586007)(36860700001)(2876002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2023 09:09:40.2557
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a7d7f6fa-e33c-4c04-f341-08db0f345e9d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT063.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7082
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
index 01e75eb244e3..0af25dca7b53 100644
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
@@ -514,6 +565,9 @@ static int efx_devlink_info_get(struct devlink *devlink,
 
 static const struct devlink_ops sfc_devlink_ops = {
 	.info_get			= efx_devlink_info_get,
+#ifdef CONFIG_SFC_SRIOV
+	.port_function_hw_addr_get	= efx_devlink_port_addr_get,
+#endif
 };
 
 #ifdef CONFIG_SFC_SRIOV
-- 
2.17.1

