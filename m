Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E14C6DA9E5
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 10:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240296AbjDGIOZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 04:14:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240209AbjDGINn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 04:13:43 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2040.outbound.protection.outlook.com [40.107.243.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1169B45D;
        Fri,  7 Apr 2023 01:13:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mq03kOzmuxx70igwOrORk0+RA33KHrDLLZETw4Wsc7geKqauXmtn/c5FIAHX9vSHznICfewrS2yOGxdIxeBoiDrw1er6a0UxnXIUEIaeLapW7uVwHKrHPzWWxJhqM4D5kD6f+X5SxVI1Z0VU2WUHxC2q9kmZUL/RUj7lL5awbnS5cnXmNr6mUbx7beZ28jlmSdmdZNKm2kjIOvsNKI69F/31Ag3DiFrNmFpFrHOwqRXTNklXKQ2r2moWujQu5bgHSbL5tTzrDT1FBhZvRnwosftDjGVqYS1pvwlVy8eeIuiN3B7KaL0WFndKb+sJSrFsoAA5oz7rsaeNmOA8eI6qSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ab9vjKUtSIohfwywKZQvbI9vuygm8W8+UvNz2PfFSHE=;
 b=jpY5/WMIUnnxWW9XKSfMTVtp1yGnAGfC2/z/6aT3mJkXujylTmrunfWtE65yo5p2vXhY92L//wyozpi8Am6Kzpby2j8tfgU+B7/XXOWedUqBdzxTlSRmbf/L3TMf7LznIUaUNgiYABVWegxSdwfj9sPC4hLXXlO7SKFcoxtQO4u8+vlrpbxbpKRSOvYOZooh/k3S+IU+TcLHMry//4OYnEGWhJV5wLbXEhfEFbmOY7Fjvjep+DONg8obiw5/x85LQiRgQM57BZl3GYmzV5r4kGnbaLjuI1c3OmkqyuaUopuwvHL1vzI7SOrVPvMA0GOT9e/F/ZUTwOaa/ADOvQnKhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ab9vjKUtSIohfwywKZQvbI9vuygm8W8+UvNz2PfFSHE=;
 b=qsS9A4aBv/2p2kEMgZbLRL8c8KYAHJs7GDv3JMsuLVW/fH4JFhQ97MrY0Zq8iD6J/PEYldeoAjptCvSDtQoZBDFURYXtm6uQnvqzdBVHvmyg9WOtj7ZQ3SpzjoLm4fYIQcdbqBHpwQhfahcOqjQ/mtrGzNas7ISmJeOPbtOQD6I=
Received: from MW4PR04CA0340.namprd04.prod.outlook.com (2603:10b6:303:8a::15)
 by PH7PR12MB7188.namprd12.prod.outlook.com (2603:10b6:510:204::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.30; Fri, 7 Apr
 2023 08:12:41 +0000
Received: from CO1NAM11FT009.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8a:cafe::73) by MW4PR04CA0340.outlook.office365.com
 (2603:10b6:303:8a::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.31 via Frontend
 Transport; Fri, 7 Apr 2023 08:12:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT009.mail.protection.outlook.com (10.13.175.61) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6298.19 via Frontend Transport; Fri, 7 Apr 2023 08:12:40 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 7 Apr
 2023 03:12:40 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 7 Apr
 2023 03:12:39 -0500
Received: from xndengvm004102.xilinx.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34
 via Frontend Transport; Fri, 7 Apr 2023 03:12:35 -0500
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
Subject: [PATCH net-next v4 11/14] sfc: use PF's IOMMU domain for running VF's MCDI commands
Date:   Fri, 7 Apr 2023 13:40:12 +0530
Message-ID: <20230407081021.30952-12-gautam.dawar@amd.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230407081021.30952-1-gautam.dawar@amd.com>
References: <20230407081021.30952-1-gautam.dawar@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT009:EE_|PH7PR12MB7188:EE_
X-MS-Office365-Filtering-Correlation-Id: 14518201-c2d6-48a2-7ace-08db373fdba4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GI66zoDLcF7zby9PZ3Dz4FRTxQSUMNcjNt3i8Z15WI8KAaIzRWCejtBUizpT5+DtWwS+Lyw99Kr5DS1QhNbY/g7EpsMdR72srdMe9ohUq1p5OVXqYLuje1BOfO9lS3NJHCMshFwjuLBG+9MN8REpy69GyTRwppborKMiBImYdxkHysdbGlXblwHDZTI4ZJnBbrh42vn64zHg47h4L6th4Kbesqh9XDiUdwQVvpzNv7oaLD8A0rmX5g3eIEiRZLXeuLQ7L6MER4Pv4RyuRxzf8U1/Ci+JAkPcCGfIOvp2/qU/aMfqbnCq/NtCPUkx+5Xh9ZlEia1v7tMtzSZ5oovpqzF1Vef4CAdDEyGwUNnteAX6gsd0HRREF4z4iOBnVwFsMff00RVSMoT82sZ5EI2mzwF3za/DlYGV+zu+fWJzebwzYsQmIMnb7P5lq8ctQDMnm03CaOtbAXtEmFCHXEKMwdulcokVD2AczdnAxaz0BBknLSMxI9fgUm+YCok1eg0dxLIqFBYNirrY4vyjC+vwcxlr+kuZ8amfT37qp/QTQv7Y+FUEQwT47zE3R8g0Rpw49vWhrL3b6/tRmoc3D80h/dN9UAB49XtuB6XoDplIr6INxalMW5JlzM+DH8vOBPN8kI9Pp35xjqdQ9Rn+tyjaoiSDFso64OFJxYavW5+8GXQ6NTiw2sLMdMwiq/tCQ+BC+NlPYV8BMDS6wV/Dv1t4frcYnLDhXbYV5eBa0EiCrVKYSl28glZMf7huSbQ2sprr
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(136003)(346002)(376002)(451199021)(46966006)(36840700001)(40470700004)(316002)(40460700003)(5660300002)(36756003)(30864003)(44832011)(2906002)(40480700001)(7416002)(82310400005)(41300700001)(8936002)(921005)(86362001)(356005)(82740400003)(70586007)(4326008)(8676002)(81166007)(70206006)(47076005)(83380400001)(2616005)(36860700001)(110136005)(1076003)(54906003)(336012)(478600001)(426003)(26005)(6666004)(186003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2023 08:12:40.9107
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 14518201-c2d6-48a2-7ace-08db373fdba4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT009.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7188
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This changeset uses MC_CMD_CLIENT_CMD to execute VF's MCDI
commands when running in vDPA mode (STATE_VDPA).
Also, use the PF's IOMMU domain for executing the encapsulated
VF's MCDI commands to isolate DMA of guest buffers in the VF's
IOMMU domain.
This patch also updates the PCIe FN's client id in the efx_nic
structure which is required while running MC_CMD_CLIENT_CMD.

Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>
---
 drivers/net/ethernet/sfc/ef100.c      |   1 +
 drivers/net/ethernet/sfc/ef100_nic.c  |  33 ++++++++
 drivers/net/ethernet/sfc/mcdi.c       | 108 ++++++++++++++++++++++----
 drivers/net/ethernet/sfc/mcdi.h       |   2 +-
 drivers/net/ethernet/sfc/net_driver.h |   2 +
 drivers/net/ethernet/sfc/ptp.c        |   4 +-
 6 files changed, 130 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef100.c b/drivers/net/ethernet/sfc/ef100.c
index 35f1b74ba890..2afc500fc424 100644
--- a/drivers/net/ethernet/sfc/ef100.c
+++ b/drivers/net/ethernet/sfc/ef100.c
@@ -463,6 +463,7 @@ static int ef100_pci_probe(struct pci_dev *pci_dev,
 	efx->type = (const struct efx_nic_type *)entry->driver_data;
 
 	efx->pci_dev = pci_dev;
+	efx->client_id = MC_CMD_CLIENT_ID_SELF;
 	pci_set_drvdata(pci_dev, efx);
 	rc = efx_init_struct(efx, pci_dev);
 	if (rc)
diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index e42be65334a5..6dadfa391327 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -1092,6 +1092,35 @@ static int ef100_check_design_params(struct efx_nic *efx)
 	return rc;
 }
 
+static int efx_ef100_update_client_id(struct efx_nic *efx)
+{
+	struct ef100_nic_data *nic_data = efx->nic_data;
+	unsigned int pf_index = PCIE_FUNCTION_PF_NULL;
+	unsigned int vf_index = PCIE_FUNCTION_VF_NULL;
+	efx_qword_t pciefn;
+	int rc;
+
+	if (efx->pci_dev->is_virtfn)
+		vf_index = nic_data->vf_index;
+	else
+		pf_index = nic_data->pf_index;
+
+	/* Construct PCIE_FUNCTION structure */
+	EFX_POPULATE_QWORD_3(pciefn,
+			     PCIE_FUNCTION_PF, pf_index,
+			     PCIE_FUNCTION_VF, vf_index,
+			     PCIE_FUNCTION_INTF, PCIE_INTERFACE_CALLER);
+	/* look up self client ID */
+	rc = efx_ef100_lookup_client_id(efx, pciefn, &efx->client_id);
+	if (rc) {
+		pci_warn(efx->pci_dev,
+			 "%s: Failed to get client ID, rc %d\n",
+			 __func__, rc);
+	}
+
+	return rc;
+}
+
 /*	NIC probe and remove
  */
 static int ef100_probe_main(struct efx_nic *efx)
@@ -1179,6 +1208,10 @@ static int ef100_probe_main(struct efx_nic *efx)
 		goto fail;
 	efx->port_num = rc;
 
+	rc = efx_ef100_update_client_id(efx);
+	if (rc)
+		goto fail;
+
 	efx_mcdi_print_fwver(efx, fw_version, sizeof(fw_version));
 	pci_dbg(efx->pci_dev, "Firmware version %s\n", fw_version);
 
diff --git a/drivers/net/ethernet/sfc/mcdi.c b/drivers/net/ethernet/sfc/mcdi.c
index a7f2c31071e8..3bf1ebe05775 100644
--- a/drivers/net/ethernet/sfc/mcdi.c
+++ b/drivers/net/ethernet/sfc/mcdi.c
@@ -145,14 +145,15 @@ void efx_mcdi_fini(struct efx_nic *efx)
 	kfree(efx->mcdi);
 }
 
-static void efx_mcdi_send_request(struct efx_nic *efx, unsigned cmd,
-				  const efx_dword_t *inbuf, size_t inlen)
+static void efx_mcdi_send_request(struct efx_nic *efx, u32 client_id,
+				  unsigned int cmd, const efx_dword_t *inbuf,
+				  size_t inlen)
 {
 	struct efx_mcdi_iface *mcdi = efx_mcdi(efx);
 #ifdef CONFIG_SFC_MCDI_LOGGING
 	char *buf = mcdi->logging_buffer; /* page-sized */
 #endif
-	efx_dword_t hdr[2];
+	efx_dword_t hdr[5];
 	size_t hdr_len;
 	u32 xflags, seqno;
 
@@ -179,7 +180,7 @@ static void efx_mcdi_send_request(struct efx_nic *efx, unsigned cmd,
 				     MCDI_HEADER_XFLAGS, xflags,
 				     MCDI_HEADER_NOT_EPOCH, !mcdi->new_epoch);
 		hdr_len = 4;
-	} else {
+	} else if (client_id == efx->client_id) {
 		/* MCDI v2 */
 		BUG_ON(inlen > MCDI_CTL_SDU_LEN_MAX_V2);
 		EFX_POPULATE_DWORD_7(hdr[0],
@@ -194,6 +195,35 @@ static void efx_mcdi_send_request(struct efx_nic *efx, unsigned cmd,
 				     MC_CMD_V2_EXTN_IN_EXTENDED_CMD, cmd,
 				     MC_CMD_V2_EXTN_IN_ACTUAL_LEN, inlen);
 		hdr_len = 8;
+	} else {
+		/* MCDI v2 */
+		WARN_ON(inlen > MCDI_CTL_SDU_LEN_MAX_V2);
+		/* MCDI v2 with credentials of a different client */
+		BUILD_BUG_ON(MC_CMD_CLIENT_CMD_IN_LEN != 4);
+		/* Outer CLIENT_CMD wrapper command with client ID */
+		EFX_POPULATE_DWORD_7(hdr[0],
+				     MCDI_HEADER_RESPONSE, 0,
+				     MCDI_HEADER_RESYNC, 1,
+				     MCDI_HEADER_CODE, MC_CMD_V2_EXTN,
+				     MCDI_HEADER_DATALEN, 0,
+				     MCDI_HEADER_SEQ, seqno,
+				     MCDI_HEADER_XFLAGS, xflags,
+				     MCDI_HEADER_NOT_EPOCH, !mcdi->new_epoch);
+		EFX_POPULATE_DWORD_2(hdr[1],
+				     MC_CMD_V2_EXTN_IN_EXTENDED_CMD,
+				     MC_CMD_CLIENT_CMD,
+				     MC_CMD_V2_EXTN_IN_ACTUAL_LEN, inlen + 12);
+		MCDI_SET_DWORD(&hdr[2],
+			       CLIENT_CMD_IN_CLIENT_ID, client_id);
+
+		/* MCDIv2 header for inner command */
+		EFX_POPULATE_DWORD_2(hdr[3],
+				     MCDI_HEADER_CODE, MC_CMD_V2_EXTN,
+				     MCDI_HEADER_DATALEN, 0);
+		EFX_POPULATE_DWORD_2(hdr[4],
+				     MC_CMD_V2_EXTN_IN_EXTENDED_CMD, cmd,
+				     MC_CMD_V2_EXTN_IN_ACTUAL_LEN, inlen);
+		hdr_len = 20;
 	}
 
 #ifdef CONFIG_SFC_MCDI_LOGGING
@@ -474,7 +504,8 @@ static void efx_mcdi_release(struct efx_mcdi_iface *mcdi)
 			&mcdi->async_list, struct efx_mcdi_async_param, list);
 		if (async) {
 			mcdi->state = MCDI_STATE_RUNNING_ASYNC;
-			efx_mcdi_send_request(efx, async->cmd,
+			efx_mcdi_send_request(efx, efx->client_id,
+					      async->cmd,
 					      (const efx_dword_t *)(async + 1),
 					      async->inlen);
 			mod_timer(&mcdi->async_timer,
@@ -797,7 +828,7 @@ static int efx_mcdi_proxy_wait(struct efx_nic *efx, u32 handle, bool quiet)
 	return mcdi->proxy_rx_status;
 }
 
-static int _efx_mcdi_rpc(struct efx_nic *efx, unsigned int cmd,
+static int _efx_mcdi_rpc(struct efx_nic *efx, u32 client_id, unsigned int cmd,
 			 const efx_dword_t *inbuf, size_t inlen,
 			 efx_dword_t *outbuf, size_t outlen,
 			 size_t *outlen_actual, bool quiet, int *raw_rc)
@@ -811,7 +842,7 @@ static int _efx_mcdi_rpc(struct efx_nic *efx, unsigned int cmd,
 		return -EINVAL;
 	}
 
-	rc = efx_mcdi_rpc_start(efx, cmd, inbuf, inlen);
+	rc = efx_mcdi_rpc_start(efx, client_id, cmd, inbuf, inlen);
 	if (rc)
 		return rc;
 
@@ -836,7 +867,8 @@ static int _efx_mcdi_rpc(struct efx_nic *efx, unsigned int cmd,
 
 			/* We now retry the original request. */
 			mcdi->state = MCDI_STATE_RUNNING_SYNC;
-			efx_mcdi_send_request(efx, cmd, inbuf, inlen);
+			efx_mcdi_send_request(efx, efx->client_id, cmd,
+					      inbuf, inlen);
 
 			rc = _efx_mcdi_rpc_finish(efx, cmd, inlen,
 						  outbuf, outlen, outlen_actual,
@@ -855,16 +887,44 @@ static int _efx_mcdi_rpc(struct efx_nic *efx, unsigned int cmd,
 	return rc;
 }
 
+#ifdef CONFIG_SFC_VDPA
+static bool is_mode_vdpa(struct efx_nic *efx)
+{
+	if (efx->pci_dev->is_virtfn &&
+	    efx->pci_dev->physfn &&
+	    efx->state == STATE_VDPA &&
+	    efx->vdpa_nic)
+		return true;
+
+	return false;
+}
+#endif
+
 static int _efx_mcdi_rpc_evb_retry(struct efx_nic *efx, unsigned cmd,
 				   const efx_dword_t *inbuf, size_t inlen,
 				   efx_dword_t *outbuf, size_t outlen,
 				   size_t *outlen_actual, bool quiet)
 {
+#ifdef CONFIG_SFC_VDPA
+	struct efx_nic *efx_pf;
+#endif
 	int raw_rc = 0;
 	int rc;
 
-	rc = _efx_mcdi_rpc(efx, cmd, inbuf, inlen,
-			   outbuf, outlen, outlen_actual, true, &raw_rc);
+#ifdef CONFIG_SFC_VDPA
+	if (is_mode_vdpa(efx)) {
+		efx_pf = pci_get_drvdata(efx->pci_dev->physfn);
+		rc = _efx_mcdi_rpc(efx_pf, efx->client_id, cmd, inbuf,
+				   inlen, outbuf, outlen, outlen_actual,
+				   true, &raw_rc);
+	} else {
+#endif
+		rc = _efx_mcdi_rpc(efx, efx->client_id, cmd, inbuf,
+				   inlen, outbuf, outlen, outlen_actual, true,
+				   &raw_rc);
+#ifdef CONFIG_SFC_VDPA
+	}
+#endif
 
 	if ((rc == -EPROTO) && (raw_rc == MC_CMD_ERR_NO_EVB_PORT) &&
 	    efx->type->is_vf) {
@@ -881,9 +941,22 @@ static int _efx_mcdi_rpc_evb_retry(struct efx_nic *efx, unsigned cmd,
 
 		do {
 			usleep_range(delay_us, delay_us + 10000);
-			rc = _efx_mcdi_rpc(efx, cmd, inbuf, inlen,
-					   outbuf, outlen, outlen_actual,
-					   true, &raw_rc);
+#ifdef CONFIG_SFC_VDPA
+			if (is_mode_vdpa(efx)) {
+				efx_pf = pci_get_drvdata(efx->pci_dev->physfn);
+				rc = _efx_mcdi_rpc(efx_pf, efx->client_id, cmd,
+						   inbuf, inlen, outbuf, outlen,
+						   outlen_actual, true,
+						   &raw_rc);
+			} else {
+#endif
+				rc = _efx_mcdi_rpc(efx, efx->client_id,
+						   cmd, inbuf, inlen, outbuf,
+						   outlen, outlen_actual, true,
+						   &raw_rc);
+#ifdef CONFIG_SFC_VDPA
+			}
+#endif
 			if (delay_us < 100000)
 				delay_us <<= 1;
 		} while ((rc == -EPROTO) &&
@@ -939,7 +1012,7 @@ int efx_mcdi_rpc(struct efx_nic *efx, unsigned cmd,
  * function and is then responsible for calling efx_mcdi_display_error
  * as needed.
  */
-int efx_mcdi_rpc_quiet(struct efx_nic *efx, unsigned cmd,
+int efx_mcdi_rpc_quiet(struct efx_nic *efx, unsigned int cmd,
 		       const efx_dword_t *inbuf, size_t inlen,
 		       efx_dword_t *outbuf, size_t outlen,
 		       size_t *outlen_actual)
@@ -948,7 +1021,7 @@ int efx_mcdi_rpc_quiet(struct efx_nic *efx, unsigned cmd,
 				       outlen_actual, true);
 }
 
-int efx_mcdi_rpc_start(struct efx_nic *efx, unsigned cmd,
+int efx_mcdi_rpc_start(struct efx_nic *efx, u32 client_id, unsigned int cmd,
 		       const efx_dword_t *inbuf, size_t inlen)
 {
 	struct efx_mcdi_iface *mcdi = efx_mcdi(efx);
@@ -965,7 +1038,7 @@ int efx_mcdi_rpc_start(struct efx_nic *efx, unsigned cmd,
 		return -ENETDOWN;
 
 	efx_mcdi_acquire_sync(mcdi);
-	efx_mcdi_send_request(efx, cmd, inbuf, inlen);
+	efx_mcdi_send_request(efx, client_id, cmd, inbuf, inlen);
 	return 0;
 }
 
@@ -1009,7 +1082,8 @@ static int _efx_mcdi_rpc_async(struct efx_nic *efx, unsigned int cmd,
 		 */
 		if (mcdi->async_list.next == &async->list &&
 		    efx_mcdi_acquire_async(mcdi)) {
-			efx_mcdi_send_request(efx, cmd, inbuf, inlen);
+			efx_mcdi_send_request(efx, efx->client_id,
+					      cmd, inbuf, inlen);
 			mod_timer(&mcdi->async_timer,
 				  jiffies + MCDI_RPC_TIMEOUT);
 		}
diff --git a/drivers/net/ethernet/sfc/mcdi.h b/drivers/net/ethernet/sfc/mcdi.h
index 303c4fe0bd64..2badf08aa247 100644
--- a/drivers/net/ethernet/sfc/mcdi.h
+++ b/drivers/net/ethernet/sfc/mcdi.h
@@ -152,7 +152,7 @@ int efx_mcdi_rpc_quiet(struct efx_nic *efx, unsigned cmd,
 		       efx_dword_t *outbuf, size_t outlen,
 		       size_t *outlen_actual);
 
-int efx_mcdi_rpc_start(struct efx_nic *efx, unsigned cmd,
+int efx_mcdi_rpc_start(struct efx_nic *efx, u32 client_id, unsigned int cmd,
 		       const efx_dword_t *inbuf, size_t inlen);
 int efx_mcdi_rpc_finish(struct efx_nic *efx, unsigned cmd, size_t inlen,
 			efx_dword_t *outbuf, size_t outlen,
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index 1da71deac71c..948c7a06403a 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -859,6 +859,7 @@ struct efx_mae;
  * @secondary_list: List of &struct efx_nic instances for the secondary PCI
  *	functions of the controller, if this is for the primary function.
  *	Serialised by rtnl_lock.
+ * @client_id: client ID of this PCIe function
  * @type: Controller type attributes
  * @legacy_irq: IRQ number
  * @workqueue: Workqueue for port reconfigures and the HW monitor.
@@ -1022,6 +1023,7 @@ struct efx_nic {
 	struct list_head secondary_list;
 	struct pci_dev *pci_dev;
 	unsigned int port_num;
+	u32 client_id;
 	const struct efx_nic_type *type;
 	int legacy_irq;
 	bool eeh_disabled_legacy_irq;
diff --git a/drivers/net/ethernet/sfc/ptp.c b/drivers/net/ethernet/sfc/ptp.c
index 9f07e1ba7780..d90d4f6b3824 100644
--- a/drivers/net/ethernet/sfc/ptp.c
+++ b/drivers/net/ethernet/sfc/ptp.c
@@ -1052,8 +1052,8 @@ static int efx_ptp_synchronize(struct efx_nic *efx, unsigned int num_readings)
 
 	/* Clear flag that signals MC ready */
 	WRITE_ONCE(*start, 0);
-	rc = efx_mcdi_rpc_start(efx, MC_CMD_PTP, synch_buf,
-				MC_CMD_PTP_IN_SYNCHRONIZE_LEN);
+	rc = efx_mcdi_rpc_start(efx, MC_CMD_CLIENT_ID_SELF, MC_CMD_PTP,
+				synch_buf, MC_CMD_PTP_IN_SYNCHRONIZE_LEN);
 	EFX_WARN_ON_ONCE_PARANOID(rc);
 
 	/* Wait for start from MCDI (or timeout) */
-- 
2.30.1

