Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA814578671
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 17:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234413AbiGRPcz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 11:32:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229928AbiGRPcy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 11:32:54 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2075.outbound.protection.outlook.com [40.107.94.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B67D4208
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 08:32:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T8f4nb1jmiEnI1vuYAdfNYep6HsIopkxyvBaLi1kPRQPEjT20heKYcycJtLbP0az/fLfimJHhklLa3RVBgNksPZsZJ5ujax8yliINOTG+INKatOvgLFV//fHDr9CWPcOZvrmSRT6O9G/xCdEhLLHE7Y4SSvPaWge0Bji6HzRZz0d6aQgHKKs4SbinHjguDVRjaB5Exoag6uPWSdqavM5QN4HA7hc94pAsHs/H5X1EcgKSRatZONQ2jGp7CAhqF5YZVKCTtlC5RQPZCuXNtaYXs1czwnCYqVeUw6KBABqpJ+S6OeAMoHTlWPEH9LpVyJuq3MtM87jJL5RWWAUY2sz7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MhYl6mdr1Flx50bFmY0630NWO+UtakKW/K3+4N+sgK8=;
 b=QOzLQbf6wvPmRFAgzWNYNfv9S9wYhlRUJZ4c0/WaxILF34nPeuTOtptsDFQ1mZBg0Yk/yGzCe3AmftMKb0IiY6hqwsfoExASsvO1Dx+8Eq7BiQ7M24FHV1oCVD7sjxyPOIJ4ztDtxST/EgDr1dEOoBNEWSIJG9iIGgS+G3mT9tBH8f+QJiWWjz1zPnCoEvIsDXfkEXB+WkkqF6YvN6un5a6KgCiOpQaNnj6WU0V+N3hVV47eCf+X36Sl9M9g/MKI+91uNLMA9Fz4gKLWOsHq+Sfuh4jVyhGxyxQEY+IGiUPFsbOlLeOd+Si0/PEv4H/C2sLQmia0DGMUixXncJylRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MhYl6mdr1Flx50bFmY0630NWO+UtakKW/K3+4N+sgK8=;
 b=ReEwdRc1k8TCQDvoTmM7gJHDjKqKtfif8f03ifuZibo0NRtLp5dgpjw4KSzGJa8Mh8LTNYq6nxGK4cgc6Z1QYvIYEpcUh1TqPQRsWzH4p0s+LobUzgytHmqx4QLJ3wgnv+VSkbZD2Ir6zMPIKYP2fT0p8rLTFN5T65DqYhTQfu255GmfboXRhmHTzdoUU9N7HzI9hOVyK6QPviP4gSQJHiszyxoSGjG/BwuoT1sXpg87Tu4ySEqxBMxWI0TfixzFy0BoyXlLu2UyDcb4wM+ySvF5I836HuXVC27EBXk/uXmTMPaG8f7Ph1vwbFx4UBO6yZRgsAQTfBS0TIsQEbRCrA==
Received: from BN9PR03CA0216.namprd03.prod.outlook.com (2603:10b6:408:f8::11)
 by IA1PR12MB6332.namprd12.prod.outlook.com (2603:10b6:208:3e2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Mon, 18 Jul
 2022 15:32:51 +0000
Received: from BN8NAM11FT065.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f8:cafe::2d) by BN9PR03CA0216.outlook.office365.com
 (2603:10b6:408:f8::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23 via Frontend
 Transport; Mon, 18 Jul 2022 15:32:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN8NAM11FT065.mail.protection.outlook.com (10.13.177.63) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5438.12 via Frontend Transport; Mon, 18 Jul 2022 15:32:51 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Mon, 18 Jul
 2022 10:32:46 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Mon, 18 Jul
 2022 08:32:45 -0700
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Mon, 18 Jul 2022 10:32:44 -0500
From:   <ecree@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-net-drivers@amd.com>
CC:     <netdev@vger.kernel.org>, Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH v2 net-next 03/10] sfc: detect ef100 MAE admin privilege/capability at probe time
Date:   Mon, 18 Jul 2022 16:30:09 +0100
Message-ID: <f466c2d7488180ebce2212ac54bab678f3f8fb91.1658158016.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1658158016.git.ecree.xilinx@gmail.com>
References: <cover.1658158016.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d1b4b1ce-9ce2-4509-928a-08da68d2c6b5
X-MS-TrafficTypeDiagnostic: IA1PR12MB6332:EE_
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AHvCWIeMp7yeV9KQ/GqBaOgAIiGzvT0aCqFrhZe/A/apV62gU59cYE6veCEqDjAVA8poR3wxZZEq+09B4zd2pd6QSjChtnAyRVzpUor/Z0DJyrSyhd5q4B+fW3G23Ll8QZ1FHjr+ND7h6BUIZPLNM/yBS0kJjh7syxu828cIObvVH5PkoylN/zGoaDiUv6+aYKs7CUrfoWOratUyPG1ts77CAVnnfW9jT010Ju7xbythlPWCDimSjciwgU1k1mACklOpKNWX8Ki7wD9fnn8paxyG91OCm8WihCXgHsC/wpMPdyCaVgRKD+WfZgekgshvSIdagoxV1s0WX7uOhj2Kd2y2Sskp1AT221HtY8zsT4ZD8h29/8M2wjZwMw3umjeLclt7yZFXhaby6ka3ttCk6KbRD5c8btncb6hkfQypUTa+c1iz/jaL662hbYY+MMQCXW4sZv8aSVLTzPRygYd6hyOoE22+ZEH3c3oaqerSOZbnjQEQ4IRhgXCQqpeyzVOoLzSrJfjjS8bMmDzIuqb+j4Tjd8UjaT9MthAbQ1LvxyqKqKcUuUFDyhazR2yf3bK3rM26bPkPGgGDbXA38tczVPrdqQWlBdUpdZcs36wpmR43ClZJyTtT8yXsqrLG5T3z/giteTm5LPGxxCZ6NDQMddnnU2QLtHawcbmb2Gjfx6zphFXqVDwJ2ceO8UGHCfixy8+gdWNpakvCwoneMPBmL+K/4aDldJBXR/emQbyNlDtTOC6r6qyM/K6tpxwq8dfko+08b146lFTm84KtHk9T0Ics/vP8G6B8yyBwngtN7GVQqGqUCYzYy6mhuDEbyGcF9ibvgfnsm34VPrvkFvHU5FxButPd12L6W56W6ugwj/o=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(376002)(136003)(396003)(346002)(36840700001)(40470700004)(46966006)(54906003)(83380400001)(316002)(110136005)(42882007)(47076005)(186003)(81166007)(336012)(82740400003)(83170400001)(5660300002)(82310400005)(356005)(36860700001)(8936002)(55446002)(40480700001)(70586007)(70206006)(8676002)(4326008)(478600001)(40460700003)(36756003)(26005)(41300700001)(9686003)(6666004)(2876002)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2022 15:32:51.1930
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d1b4b1ce-9ce2-4509-928a-08da68d2c6b5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT065.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6332
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
