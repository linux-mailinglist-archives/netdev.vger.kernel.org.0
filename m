Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 652E068F0C3
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 15:26:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231542AbjBHO0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 09:26:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231475AbjBHO0F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 09:26:05 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2061.outbound.protection.outlook.com [40.107.95.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0E244B19E;
        Wed,  8 Feb 2023 06:25:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hDJdWuhKUeGP08B4J+qmV3c7f+/dDvupf+eUouQstOQA53FlWjFbzc/k1EhxZFYXwtye9GpPgX+XPYn5vrm5KgwdZBF78r6V676Aj5EUZ4ohMAseUoSG7QESh5xBGjnj0YSIC8695oDriJXFl9rAZlN01g+fW05Hn8DhoDjg7Hn+hM317eYxmnThCjmJh7kSyK46RLVR1moB9SHhS82ZMc+9dmG74mT0v/zusQ0WZpD4NIwdU99SZ8uGth0jLjpwQW4TEpNBykjErasWaUlaH3AdmMXY/y/RtlzN00NfPvRXZd/lYyBQh7ppmA9j7ed4qjAxycOtA5ubYeBOVJUSsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8KLLalSg4WGP+PC2KFj2lkbblN2Mt/Wmhv0NBhh0390=;
 b=PzjZIfIswdDafZB8Kb2lVmhq+QtpjF+79Bg0Y1vsmIQ9E53BssrEo3CALSvgAmdoAMCjmF91KuzEDz80qthzlSGfgI0vTPSmBPxwIOAbfv7820VVVERQVqTXIGelLB9S6NbtNpCLgCkzNj1USwLUMhbDY9jIn1X1VmySZRE1S7f65ibGo4MlqDSV55Vq5VQ6TSVUXrf4wlJEVnLiWSQYlsyb5YXKTVjOXUpq8dQrA2UnDc82lQdde/DWO7PHGfpdMVKboGHlKT2RGAVR3n595WNt3ptEVGJ+Gy6gFT7gUBj0TcjDzP6irAACjzYNYHaWh2NEZrDVYu5vSg6J5HtFmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8KLLalSg4WGP+PC2KFj2lkbblN2Mt/Wmhv0NBhh0390=;
 b=gAc8k8nI+w8NBcDoTYMLzY2y90AKwgsO71EnSi96Sd8mPgBHPb2+WsPdi+ltyRIfS0UzK3FuIjruD2CeV9OVHk2LIEPCAgEhEgEAlUmT1nEl1KhsPWp1GI5J4T7CAKtKw9SlTM58dicEazGL3Y+IUwYZ8Qr4tG9zdloXNyvlPgQ=
Received: from DM6PR02CA0131.namprd02.prod.outlook.com (2603:10b6:5:1b4::33)
 by SA1PR12MB8094.namprd12.prod.outlook.com (2603:10b6:806:336::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.32; Wed, 8 Feb
 2023 14:25:52 +0000
Received: from DM6NAM11FT048.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1b4:cafe::5a) by DM6PR02CA0131.outlook.office365.com
 (2603:10b6:5:1b4::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.36 via Frontend
 Transport; Wed, 8 Feb 2023 14:25:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT048.mail.protection.outlook.com (10.13.173.114) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6043.28 via Frontend Transport; Wed, 8 Feb 2023 14:25:52 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 8 Feb
 2023 08:25:50 -0600
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 8 Feb
 2023 06:25:50 -0800
Received: from xcbalucerop41x.xilinx.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34 via Frontend Transport; Wed, 8 Feb 2023 08:25:48 -0600
From:   <alejandro.lucero-palau@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        <ecree.xilinx@gmail.com>, <linux-doc@vger.kernel.org>,
        <corbet@lwn.net>, <jiri@nvidia.com>,
        "Alejandro Lucero" <alejandro.lucero-palau@amd.com>
Subject: [PATCH v6 net-next 7/8] sfc: add support for devlink port_function_hw_addr_get in ef100
Date:   Wed, 8 Feb 2023 14:25:18 +0000
Message-ID: <20230208142519.31192-8-alejandro.lucero-palau@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230208142519.31192-1-alejandro.lucero-palau@amd.com>
References: <20230208142519.31192-1-alejandro.lucero-palau@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT048:EE_|SA1PR12MB8094:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f51ba88-ede1-42da-9526-08db09e061db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kvmDGnv28+RgNCnnhYiy9/aW/ktOKzTr9Q9h9pmYhzQWuU0AjoQ47FLSPIb7DmX8gQLeK1nyxlQzeazAfKMuDwzi1MRYKLanBQ0F7p6Kb2z6KgMzA8kZJEtDHLYuHrTuOdnD3VZOSTcdOPWkKgozvA/QdMtMPTBWCdkYoQyCLeZ7xRI0inxQpyqNvYyGSrBhXP/k4acrN6Q/AirgMkjK12TTQMpOY67cP1MBx7CxFBGTgYcq+a+CwaN6eYkBVMNyBJqi0WrAtCx/vy2ywldSJcdq1rknVvNBlOa6hl+O1kpsQ3QbSFiy3QGIlYSFjs7NjyEkfYfFg3BhbxIE9f02v4kBf/czJxz7YRs5AUq4U7iXM17GXWqgodY9rPT4Zi6RkdyJjmL4gode2vQQMoFyiLZ6I7lxmIsoNxyIAWonknU4vDMK9+fZEdPnwqJSFAQTy33ZRyNLoU5EFUUhMaJCasKflaLT4yImnKPqe7dEOtOzWlP0iIbRnqyNIK1Xfo4HTWGWotMmxGn0I0JbbwEoaLcLbXz909uXgeI16tTkcACjyu0bpQOGj5uZ4+zS6HF+7PoXUk4Fy/LjgV2jxgLYSP9iyRltW//US/b1FEk0xidUdMM9nJAZaP56ThgyhC+1+FQvqmmt5PX6EiBtBp/6KJwRwhCOAV/OUt8iTww8hZnlRa9N4mtqqNCjgXeYV12RM4lUyess7I+/CQ6bm9PgXn99xsi2D9LrVzmN/zIZBNw=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(39860400002)(396003)(136003)(451199018)(36840700001)(46966006)(40470700004)(40460700003)(2876002)(2906002)(8936002)(86362001)(426003)(47076005)(336012)(26005)(7416002)(41300700001)(186003)(5660300002)(40480700001)(82310400005)(36756003)(478600001)(6666004)(1076003)(36860700001)(2616005)(316002)(356005)(4326008)(8676002)(70206006)(82740400003)(6636002)(81166007)(110136005)(54906003)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 14:25:52.1380
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f51ba88-ede1-42da-9526-08db09e061db
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT048.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8094
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
---
 drivers/net/ethernet/sfc/ef100_nic.c   | 27 +++++++++++++++
 drivers/net/ethernet/sfc/ef100_nic.h   |  1 +
 drivers/net/ethernet/sfc/ef100_rep.c   |  8 +++++
 drivers/net/ethernet/sfc/ef100_rep.h   |  1 +
 drivers/net/ethernet/sfc/efx_devlink.c | 46 ++++++++++++++++++++++++++
 5 files changed, 83 insertions(+)

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
index 1b1276716113..68d04c2176d3 100644
--- a/drivers/net/ethernet/sfc/efx_devlink.c
+++ b/drivers/net/ethernet/sfc/efx_devlink.c
@@ -11,6 +11,7 @@
 #include "efx_devlink.h"
 #ifdef CONFIG_SFC_SRIOV
 #include <linux/rtc.h>
+#include "ef100_nic.h"
 #include "mcdi.h"
 #include "mcdi_functions.h"
 #include "mcdi_pcol.h"
@@ -58,6 +59,50 @@ static int efx_devlink_add_port(struct efx_nic *efx,
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
+	int rc;
+
+	mport_desc = container_of(port, struct mae_mport_desc, dl_port);
+
+	if (!ef100_mport_on_local_intf(devlink->efx, mport_desc)) {
+		NL_SET_ERR_MSG_MOD(extack, "Port not on local interface");
+		return -EINVAL;
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
+		NL_SET_ERR_MSG_MOD(extack, "No internal client_ID for port");
+		return -EIO;
+	}
+
+	rc = ef100_get_mac_address(devlink->efx, hw_addr, client_id, true);
+	if (rc) {
+		NL_SET_ERR_MSG_MOD(extack, "No MAC available");
+		return -ENOENT;
+	}
+
+	*hw_addr_len = ETH_ALEN;
+	return rc;
+}
+
 static int efx_devlink_info_nvram_partition(struct efx_nic *efx,
 					    struct devlink_info_req *req,
 					    unsigned int partition_type,
@@ -511,6 +556,7 @@ static int efx_devlink_info_get(struct devlink *devlink,
 static const struct devlink_ops sfc_devlink_ops = {
 #ifdef CONFIG_SFC_SRIOV
 	.info_get			= efx_devlink_info_get,
+	.port_function_hw_addr_get	= efx_devlink_port_addr_get,
 #endif
 };
 
-- 
2.17.1

