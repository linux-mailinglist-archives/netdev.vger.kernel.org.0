Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2FE157BDC5
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 20:31:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234607AbiGTSa7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 14:30:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbiGTSa6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 14:30:58 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2076.outbound.protection.outlook.com [40.107.95.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D26D709A3
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 11:30:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pd3faPFLBQevJ/EdjyhPiHC7A/WDLVLWYSm08Vs9UoiSFrO3hracc4GCFS5zewd9B7I8enfkCSFHg4mHGBoRiPmnWfAQwHp3BhxfQhx01RwdPx5Htr9BJcu1W469qDDmBIbrhGNE3/iOq8GDo1KVPVV6AiUezx/yWTMl0lCF82Ab+IuA2cgjZQ1pci9/REs0IO7A4vBoit1VjZSffFeYoBOmBoQItuz5JX0u5VTLGGuKdo6b5AWmo0eQPWpxSB/4A5IP3tF7TYwCtZFpQGoSzkjgqTm4JORebHvgxDBx3zbd0r59EJZ6qKFVuwoXnHji/dinXJL/oSx/guKpqp9X9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MhYl6mdr1Flx50bFmY0630NWO+UtakKW/K3+4N+sgK8=;
 b=Qon66STp4c/T64Uu1KLpzkjMuJDLr0qvBUpFvgnuVpOM0qeWIiwbbDWywKyg8fVKAVafy7QWjcOErzMsqYaqggGsGNxh5+s37tNCvaAtR5WEYdbICIY224uhb2cbf5vjRMjCk16FbKYFPSgP/br5nAPpSi2asvgAIDAad+TMlp+CHlzKEC7VkfnemEfF7sSUECS8GM7QzE9kRpvwxVCLeAHQxCRopORMFRoVSHNmoiDHSjFrlrZFRmEvWAo5JC9n/Vwn2j7LTAUOayNMPoar+ESPwrsFlwDlaJAOFGTlB81Ba7+troEDaaoGnJH60bynXeM5n8ajonBCQFuuFFH5IA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MhYl6mdr1Flx50bFmY0630NWO+UtakKW/K3+4N+sgK8=;
 b=q5OxA5rvlEYHGgJiowEpbeF+mbA3rtzw7IUxvJpHsWbYifTJqqxFy4sHWfaQG7/kJbIujvpcpQ+04E5Ll6CSCu3HIdnyDPVX7VqDWS9vGVTWILNpT5RJ1gz1AVerY1RnlSnkqpGc3SxqI25yMXTM4ENXUQ1yh1cFUyJxt5d5BmIt6x4BWTVIA4SeDyYtj8x3rBFR+6a3jhEKndA5xkBVywdOv9MKCUMe3QsN9f15H99GCJ40Okm43coueI+Em4hTs3kQJp7vFieYbSgxatK7bgoz66vE2BFeS15gtdLnGOH5JxeHYUXk79JLSmhQjOFDJbsEPtWZF1FKFYO8U0We0g==
Received: from DS7PR03CA0232.namprd03.prod.outlook.com (2603:10b6:5:3ba::27)
 by BYAPR12MB2983.namprd12.prod.outlook.com (2603:10b6:a03:d6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.21; Wed, 20 Jul
 2022 18:30:53 +0000
Received: from DM6NAM11FT065.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3ba::4) by DS7PR03CA0232.outlook.office365.com
 (2603:10b6:5:3ba::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.21 via Frontend
 Transport; Wed, 20 Jul 2022 18:30:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT065.mail.protection.outlook.com (10.13.172.109) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5458.17 via Frontend Transport; Wed, 20 Jul 2022 18:30:53 +0000
Received: from SATLEXMB07.amd.com (10.181.41.45) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 20 Jul
 2022 13:30:53 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB07.amd.com
 (10.181.41.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 20 Jul
 2022 11:30:52 -0700
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Wed, 20 Jul 2022 13:30:51 -0500
From:   <ecree@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-net-drivers@amd.com>
CC:     <netdev@vger.kernel.org>, Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH v3 net-next 2/9] sfc: detect ef100 MAE admin privilege/capability at probe time
Date:   Wed, 20 Jul 2022 19:29:26 +0100
Message-ID: <1efa3ac7290be1baab39447b16b05b118ec659ba.1658341691.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1658341691.git.ecree.xilinx@gmail.com>
References: <cover.1658341691.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6351bc3f-e652-43c8-cbd1-08da6a7dfab4
X-MS-TrafficTypeDiagnostic: BYAPR12MB2983:EE_
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4Fe3MWuH8StY1pyu5OMxiLGIz4HX3O1oPO2QA1GhUBTb4LB++EeuR4SD0xqLCKHzwpUV6hQq8e6xYo5EonPjA9N5Z0PgXHfBGSfxusL7ABMBSlIT1eXhjDk7FdijqO3OP/H67AnHxyJoid33JGcXjDDhZZqqKCAcm/aPPyv5WlorrVf5aueL8zjVc8qvnt/hmr3rcKCM3Zo96FU+4xHJMpxWxSgWsbioEQhHxlN7xE/QMJXjMcSaIjLcYKmyUVrzyOcGpboIfqpFokmuMyz2IoHAFWotIan0iSlEdqcqweg9ejFx+VytBdugNOXX2E/k8gPLJOrLNXh3YRgSC84Jf9kJJX5rOyoC/NMKNY+5dZX00h3L0baX1YfmyIuAWJ2+ld9bFJu+EwqiOVZYhCZHvQJbVobSMy5hlI1es5JycciYektXsh/21y3N9vSZs33fckh+7ECuE5NofkIz/aYGkBYnPhpO8K+3weMQvlcTr8UlzuDj9ALJOQM4LV0R8tLOXV4HWUWkS41tn/8uLwBcnE2imOV4zmN3InJ2hQLANwoZRW+RI8ujjbjMKV15YWDEw+ZcHKT93TzVoW2rfWUIE7Uag+azxIaolfHtGUXnZaDys0yepbQ6n10jMYz1SbgdNPsOIWqIgUrM8M2qqTnVK9nSXd3S3LLa7K0GQVZGQBQVAYXCT24T5JvxCWwzC6PeMbxz5l9f+MKjvrlZWlZE0BHhGm9aFWtMbubQEWkVjEPU/vchZ00/94EmSowMVOtlMRROOhJVcCYkimIVSfxzi6NpK+vUNVzHwe02CXHoF6yCbqwANWNvtluU5fdH2lyfOEe99zuXdXuw8C/lk1aYqw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(396003)(39860400002)(346002)(376002)(136003)(36840700001)(46966006)(40470700004)(82740400003)(186003)(36756003)(41300700001)(9686003)(36860700001)(82310400005)(478600001)(40480700001)(5660300002)(83380400001)(336012)(42882007)(6666004)(54906003)(2906002)(47076005)(4326008)(2876002)(8936002)(8676002)(70206006)(55446002)(356005)(70586007)(110136005)(26005)(40460700003)(81166007)(83170400001)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2022 18:30:53.4861
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6351bc3f-e652-43c8-cbd1-08da6a7dfab4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT065.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2983
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
