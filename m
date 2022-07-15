Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3C005761C9
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 14:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234490AbiGOMgU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 08:36:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233344AbiGOMgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 08:36:19 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2058.outbound.protection.outlook.com [40.107.96.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2635C6EEB6
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 05:36:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fuZhIjYx+u8RjUjrGPFGDQwfNXYxhwRx14nt8BujIaZcwcHdR/ng5WVXJiTForWefg9+jkaknTUD0j6vTDknFIEgXXU/5MW6oz9H4l2RISq+IGR7CuWretNMYHMHwGhOMfIHsVlXbqR403wrVPLpzncQ0iQopbY9MjgE9y7yppNJaz7ltQFM5eK/W0lxbxejkYtlWHpIQEqjNTtgNC00gMSsqxGTYE2Nn+2J7vaZQ9XYX2baV0d8Hfaeh7Tqj+u2DZooSxZaVfq0pEYrxUj5Facl2eA2NKKPNvhIHZrDAEJb7QtVAF1j2ZcLjfYtJclHHNHpfwfkGF6jYwvyks3vVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MhYl6mdr1Flx50bFmY0630NWO+UtakKW/K3+4N+sgK8=;
 b=D8ZymAZhkyxxy3lG2J5UzyMoajDPY+LH9eWNkoMtOKXAQtMMIdk1mwffYp98eEKa2nMuRPI8r1+lNweHcASRzKfCVMnzeS5koqhiHC4yaatzZwASSl72Bm5Xy1FKyX1ZNWfomstEl+DAAWKcIJ3hIGvOZbk+VnvLMezGtK98crVTnlf8U3nY0OINC3YxYXKOo5WdR2AJePT4uc3dGrSD/kQ5x7eKTfzrDpVWJ8g50iqVJl/kLj8eHt4pc9aKqTATv9LqghLQ22kqgDwneRrun20Dx6ja0brbbjbzjahcFI1y/O8QCMbsaqn73BIvJrGbweUrCMACnmyHI/2pcegmNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MhYl6mdr1Flx50bFmY0630NWO+UtakKW/K3+4N+sgK8=;
 b=5E6Y2Tz5fCfiL8NBddc6n5KX6Zt2WS2W26wE1PKFFEFbjdmG6WyKENIRuq4sQCG6PePnW9PBWRUmpEAQaEOO5fmWjG6sg5/ZPgEb9e2txhu1Ph1LJO5DdVdi1vwgzjc5+ybd2E91LS4qX4QlVFW9LDp4/HxDuMVxco1FwIMwMU4OvH9wxZW67Gr9V5f88J0vWCG6JvIJE26CFyWU735wrc3dTyvBrQOqV4DeJqA4rfDXV+Oc1G8y02IJVpYiwTydQeGh3WY1jCw9yaBsJ82yqhVPP/70hJ47JQ0Y9d+F1o4+EKzAPVaXfeTUkKMbfahbyp8vigtwHz2BvaC2wpt24g==
Received: from MW4PR03CA0088.namprd03.prod.outlook.com (2603:10b6:303:b6::33)
 by PH8PR12MB7025.namprd12.prod.outlook.com (2603:10b6:510:1bc::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.26; Fri, 15 Jul
 2022 12:36:13 +0000
Received: from CO1NAM11FT032.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b6:cafe::cf) by MW4PR03CA0088.outlook.office365.com
 (2603:10b6:303:b6::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.21 via Frontend
 Transport; Fri, 15 Jul 2022 12:36:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT032.mail.protection.outlook.com (10.13.174.218) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5438.12 via Frontend Transport; Fri, 15 Jul 2022 12:36:12 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Fri, 15 Jul
 2022 07:36:11 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Fri, 15 Jul
 2022 05:36:11 -0700
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Fri, 15 Jul 2022 07:36:10 -0500
From:   <ecree@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-net-drivers@amd.com>
CC:     <netdev@vger.kernel.org>, Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH net-next 03/10] sfc: detect ef100 MAE admin privilege/capability at probe time
Date:   Fri, 15 Jul 2022 13:33:25 +0100
Message-ID: <f466c2d7488180ebce2212ac54bab678f3f8fb91.1657878101.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1657878101.git.ecree.xilinx@gmail.com>
References: <cover.1657878101.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e6b5f5fc-30bb-4f67-17df-08da665e9a6a
X-MS-TrafficTypeDiagnostic: PH8PR12MB7025:EE_
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e5GP7xjKoih5AVce9KE48/oGXPy/W+LWgigiU9hc0VWnZTPjkxP1JnAQWzRJkB2t5UWcLWJqk60TpHdzzGTNsDmtJJrw5B9pgIrHobojkCwgZat6ia3c4IPLY2i3AaZV62FTrD5LIWnH5RhmunjgSBlTJIwgNbo1PuwBDRQDScCly2EDcQeMSuwM61bYLADJfDC7eHyMDxk/ERdoABtEPRdMWRo1S/GPb1h9ZsIhLHeggMuaw1LdLck76Tv2tWGMY54qvp2cLr51UqWLwWPKQq24rtGHcB78BfMzkPui2eWQhGTsNKrZdsR2TD2YLDeQU4cN42W2FmoaLWgHu651zoMC97xVgZtheoFM4Er3LN51498LPPHiUiS5IjpzuygsgI0kViUOvgzISZ86XPjv7Ed3rXBySrCRKxzhNwDN1QMxUY/gM0ARfIPZs04lxo/NTUnsnkbhJ3hPkkxM5WgjoeX0vSDawu0NfXSbANBGCtcJV6nHQ7S7Hyfa6mDFXTHQXB+MkC1HGSU1TJVH1X3wOUY/yhHrDjdb/5mSxPXmmp7EKpOi3Hknhqy45j8/R44wJd0fDopogD/yusORBA2efeIWsIGnf4DKULjq1EkVRlh2XtdmWWOJDHjqE0sC07zodSKT9VwmP0ztoP9ppsFTdK0iLS9jxfTAJfOaJL+eWFaM1FaJheKDYSCC5UV+VPMiPsPDEzb7dwpgKrXWy+kg8l7B78zZftxe92XGS+JOFV+/OGNkTim8hX5nlezW6pGb3rg8GcqX5BcTCJBdkJUu85TpVSr+L+EgWn1pgStmuQpeM7mlffZItUXF3VHCJ089KRD72MrjCZoMiyknKDbRSElVgCk8gxD9tVMp/q2Ijvc=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(136003)(396003)(39860400002)(40470700004)(46966006)(36840700001)(81166007)(6666004)(82310400005)(478600001)(83170400001)(42882007)(82740400003)(356005)(8676002)(2906002)(316002)(70206006)(4326008)(41300700001)(40460700003)(70586007)(83380400001)(110136005)(26005)(336012)(36860700001)(5660300002)(2876002)(9686003)(47076005)(54906003)(8936002)(36756003)(186003)(40480700001)(55446002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2022 12:36:12.8074
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e6b5f5fc-30bb-4f67-17df-08da665e9a6a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT032.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7025
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree.xilinx@gmail.com>

One PCIe function per network port (more precisely, per m-port group) is
 responsible for configuring the Match-Action Engine which performs
 switching and packet modification in the slice to support flower/OVS
 offload.  The GRP_MAE bit in the privilege mask indicates whether a
 given function has this capability.
At probe time, call MCDIs to read the calling function's privilege mask,
 and store the GRP_MAE bit in a new ef100_nic_data member.

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/ef100_nic.c |  7 +++++
 drivers/net/ethernet/sfc/ef100_nic.h |  1 +
 drivers/net/ethernet/sfc/mcdi.c      | 46 ++++++++++++++++++++++++++++
 drivers/net/ethernet/sfc/mcdi.h      |  1 +
 4 files changed, 55 insertions(+)

diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index f89e695cf8ac..4625d35269e6 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -946,6 +946,7 @@ static int ef100_probe_main(struct efx_nic *efx)
 	unsigned int bar_size = resource_size(&efx->pci_dev->resource[efx->mem_bar]);
 	struct ef100_nic_data *nic_data;
 	char fw_version[32];
+	u32 priv_mask = 0;
 	int i, rc;
 
 	if (WARN_ON(bar_size == 0))
@@ -1027,6 +1028,12 @@ static int ef100_probe_main(struct efx_nic *efx)
 	efx_mcdi_print_fwver(efx, fw_version, sizeof(fw_version));
 	pci_dbg(efx->pci_dev, "Firmware version %s\n", fw_version);
 
+	rc = efx_mcdi_get_privilege_mask(efx, &priv_mask);
+	if (rc) /* non-fatal, and priv_mask will still be 0 */
+		pci_info(efx->pci_dev,
+			 "Failed to get privilege mask from FW, rc %d\n", rc);
+	nic_data->grp_mae = !!(priv_mask & MC_CMD_PRIVILEGE_MASK_IN_GRP_MAE);
+
 	if (compare_versions(fw_version, "1.1.0.1000") < 0) {
 		pci_info(efx->pci_dev, "Firmware uses old event descriptors\n");
 		rc = -EINVAL;
diff --git a/drivers/net/ethernet/sfc/ef100_nic.h b/drivers/net/ethernet/sfc/ef100_nic.h
index 744dbbdb4adc..40f84a275057 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.h
+++ b/drivers/net/ethernet/sfc/ef100_nic.h
@@ -72,6 +72,7 @@ struct ef100_nic_data {
 	u8 port_id[ETH_ALEN];
 	DECLARE_BITMAP(evq_phases, EFX_MAX_CHANNELS);
 	u64 stats[EF100_STAT_COUNT];
+	bool grp_mae; /* MAE Privilege */
 	u16 tso_max_hdr_len;
 	u16 tso_max_payload_num_segs;
 	u16 tso_max_frames;
diff --git a/drivers/net/ethernet/sfc/mcdi.c b/drivers/net/ethernet/sfc/mcdi.c
index 3225fe64c397..af338208eae9 100644
--- a/drivers/net/ethernet/sfc/mcdi.c
+++ b/drivers/net/ethernet/sfc/mcdi.c
@@ -2129,6 +2129,52 @@ int efx_mcdi_get_workarounds(struct efx_nic *efx, unsigned int *impl_out,
 	return rc;
 }
 
+/* Failure to read a privilege mask is never fatal, because we can always
+ * carry on as though we didn't have the privilege we were interested in.
+ * So use efx_mcdi_rpc_quiet().
+ */
+int efx_mcdi_get_privilege_mask(struct efx_nic *efx, u32 *mask)
+{
+	MCDI_DECLARE_BUF(fi_outbuf, MC_CMD_GET_FUNCTION_INFO_OUT_LEN);
+	MCDI_DECLARE_BUF(pm_inbuf, MC_CMD_PRIVILEGE_MASK_IN_LEN);
+	MCDI_DECLARE_BUF(pm_outbuf, MC_CMD_PRIVILEGE_MASK_OUT_LEN);
+	size_t outlen;
+	u16 pf, vf;
+	int rc;
+
+	if (!efx || !mask)
+		return -EINVAL;
+
+	/* Get our function number */
+	rc = efx_mcdi_rpc_quiet(efx, MC_CMD_GET_FUNCTION_INFO, NULL, 0,
+				fi_outbuf, MC_CMD_GET_FUNCTION_INFO_OUT_LEN,
+				&outlen);
+	if (rc != 0)
+		return rc;
+	if (outlen < MC_CMD_GET_FUNCTION_INFO_OUT_LEN)
+		return -EIO;
+
+	pf = MCDI_DWORD(fi_outbuf, GET_FUNCTION_INFO_OUT_PF);
+	vf = MCDI_DWORD(fi_outbuf, GET_FUNCTION_INFO_OUT_VF);
+
+	MCDI_POPULATE_DWORD_2(pm_inbuf, PRIVILEGE_MASK_IN_FUNCTION,
+			      PRIVILEGE_MASK_IN_FUNCTION_PF, pf,
+			      PRIVILEGE_MASK_IN_FUNCTION_VF, vf);
+
+	rc = efx_mcdi_rpc_quiet(efx, MC_CMD_PRIVILEGE_MASK,
+				pm_inbuf, sizeof(pm_inbuf),
+				pm_outbuf, sizeof(pm_outbuf), &outlen);
+
+	if (rc != 0)
+		return rc;
+	if (outlen < MC_CMD_PRIVILEGE_MASK_OUT_LEN)
+		return -EIO;
+
+	*mask = MCDI_DWORD(pm_outbuf, PRIVILEGE_MASK_OUT_OLD_MASK);
+
+	return 0;
+}
+
 #ifdef CONFIG_SFC_MTD
 
 #define EFX_MCDI_NVRAM_LEN_MAX 128
diff --git a/drivers/net/ethernet/sfc/mcdi.h b/drivers/net/ethernet/sfc/mcdi.h
index 69c2924a147c..f74f6ce8b27d 100644
--- a/drivers/net/ethernet/sfc/mcdi.h
+++ b/drivers/net/ethernet/sfc/mcdi.h
@@ -366,6 +366,7 @@ int efx_mcdi_set_workaround(struct efx_nic *efx, u32 type, bool enabled,
 			    unsigned int *flags);
 int efx_mcdi_get_workarounds(struct efx_nic *efx, unsigned int *impl_out,
 			     unsigned int *enabled_out);
+int efx_mcdi_get_privilege_mask(struct efx_nic *efx, u32 *mask);
 
 #ifdef CONFIG_SFC_MCDI_MON
 int efx_mcdi_mon_probe(struct efx_nic *efx);
