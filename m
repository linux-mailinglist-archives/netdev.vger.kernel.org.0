Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B1C857BDC6
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 20:31:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240434AbiGTSbD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 14:31:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbiGTSbA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 14:31:00 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2076.outbound.protection.outlook.com [40.107.220.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E960F4BD08
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 11:30:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JKnSlmjNaSyzktEBTo+rIqXx/AaAoLrjcE1bLbX0pD2jyT0qAFaJ+lbEJe+tEZKoc+b5MeEDWCBJJBdeHIKH9XWCdI+QZ9eUz8JaJZeQ2M8YMd6fTIhU9Xy/s/qBpS3+Ua3GuV3t5qM4wyv9AE51FmHgqjVGbty//sBSUfL4HsBRPyu8Oez2Epwm2hP26Btwb5efnT0JRGJ2Q6wMWPwbhRHrZVMwPlcMDPpHOLhy9k0tEKLeIfYNWYbFR8KtAbmv28132CMkmA985Y6/XBmv+ZXfaC95Penf4NZPQ813rtUv5JgR5qe8lxYy/6eY1//huzKGXXxALB22L4I1mV/umg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MhYl6mdr1Flx50bFmY0630NWO+UtakKW/K3+4N+sgK8=;
 b=bnyHuqjhGpU70GiSAJ6o/9qe42z1AKXbRDaNkimZoKa7CbxEjquS1J2nfUTr39NQGreXE1BsAV/kXOC9pkti4Huo/JEMK/I2Sq9GpGANaTjEYZ764YLu9y/a3yxKoJmDYl6zI62OninPa3E5el8nyEcZZF4pzmOV68V0WfXWgeyG2Vyu0IuuKWBJ1q70bU36KP0vA4tYr8XzNQtvzOt29AvGIOhA6kEUKwLhTMPgcU+oXlkLPbTmkmrEGRp9UriloAf28SD2JMRXOxrscu3U7w61Ro/at19Of0sptQoY+aBBipHPAtKHwrI+89Z2dn4sxbXVLCmJa0XAX3aHPS1FOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MhYl6mdr1Flx50bFmY0630NWO+UtakKW/K3+4N+sgK8=;
 b=lqqsgArirO0LR+kWsOQ/OCacno5rXu3TJeJwPIEHMZjC4VPuHl0C4jPZfpPydEXWudhHuZeB1rHuxN3nFGEB1het6SjuHw2CetwgpnybwlM+XFqiLk+ng/a2eFyw+6sYcolB3wf8R9ZZOHh5A9HHK0XvCcxoSUOs/rl5jssZxdZHri+ETcwycEGyGahCyIj3i1m1cvk7Mt0ViK6BLY27a01+NIfAVF51EN786td1BZR+S3Rtm8VDdH6xOT4j7o+0mjwtLD/51mZQzPHgkXN7244m2xl75Wez0rnJKUj423PekypEyw4eM2Mggy95FPnunc4xUMlxhsiWRBEVx6n9kA==
Received: from MW4PR03CA0021.namprd03.prod.outlook.com (2603:10b6:303:8f::26)
 by CY5PR12MB6323.namprd12.prod.outlook.com (2603:10b6:930:20::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.12; Wed, 20 Jul
 2022 18:30:58 +0000
Received: from CO1NAM11FT036.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8f:cafe::f5) by MW4PR03CA0021.outlook.office365.com
 (2603:10b6:303:8f::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19 via Frontend
 Transport; Wed, 20 Jul 2022 18:30:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT036.mail.protection.outlook.com (10.13.174.124) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5458.17 via Frontend Transport; Wed, 20 Jul 2022 18:30:57 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 20 Jul
 2022 13:30:56 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Wed, 20 Jul 2022 13:30:55 -0500
From:   <ecree@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-net-drivers@amd.com>
CC:     <netdev@vger.kernel.org>, Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH v2 net-next 03/10] sfc: detect ef100 MAE admin privilege/capability at probe time
Date:   Wed, 20 Jul 2022 19:29:29 +0100
Message-ID: <f466c2d7488180ebce2212ac54bab678f3f8fb91.1658158016.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1658158016.git.ecree.xilinx@gmail.com>
References: <cover.1658158016.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8a0f3bfb-d0d3-4c74-d199-08da6a7dfd49
X-MS-TrafficTypeDiagnostic: CY5PR12MB6323:EE_
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LBLbdyIBJXFzJf+EmZZyqfctzW9VIbFX8nLknyzyjVBrtoGOr8q7L3WNUDj6c7g2k6DEEgCCcv8mhyPZIJt2ns9Efby8WKB7V8G7Al11cecRLZU13mqlYA0SDBMxR0f6AmxWsmnEX0WzE/TqPloLeXTmNXOAqqPqJAWGkaD50lEGXsgnhr6h7qlHUKD2WXFlzFfELyaxoD/KGVSq9LHkf8KPnq01kxLRf40gYCMPN8Qc++HW35J0jJyjORvVl9Z05Y/vSroFd1/HLB9C+1GIx2fSgYbd56HhHwwwUlSmT21RZZ0rvzpZopxaM/Q7hhjrsHBqDPnXuBtkKFJTQMw/CYq1nzGAd+rsEAQ13aHgnAsFTitcA6JlxFNvoGXuFDuaMT08nwOjgB7DCkRfSeU6Ql3a7Qom9g1nLuMw6il5mQxESIHaXlt0eV4JfA9gD+OtjlhdcjDZg+m94tT3yEd74ZI1kBIO1Ae+ykI55MXm9i5uxl7sgV6BysbhDDDjp8aOV6aOtzZx3Gv5EPofDPUhJX2/bW0NBv6uMvW4VRa/jOzlCd4dvQ6j82G7PTSG5Z56rGebycvoiFhYuIgHoP0OLwdbVFiy/BabaXVoF3LnV5nD0v7QOO0Z7Qy0SKfQ1GHHREH51hEgd3MoCjQ76d9HrXuzzz/vYU95BYrQMW/xjFYBfI7W6jFkYpWpe27SFzvXSwL6CBQR4LzvrSf+eezatNgOyi7VN0TOX8h5HpwDs7b3/xNr2KMY8QpLQfgEdv38NWAs8Ef2id6m2EqfQE0mOSWmwimlRDHhkJkDORkZEIss5H2WPy/CX4buDlwfdkbek0bdL5VRY7/wRAUIt4F4RQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(396003)(376002)(136003)(40470700004)(36840700001)(46966006)(110136005)(5660300002)(47076005)(70206006)(70586007)(82740400003)(40480700001)(9686003)(6666004)(478600001)(55446002)(54906003)(26005)(36756003)(316002)(82310400005)(41300700001)(40460700003)(81166007)(4326008)(8676002)(83170400001)(356005)(336012)(2906002)(83380400001)(36860700001)(42882007)(8936002)(2876002)(186003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2022 18:30:57.7401
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a0f3bfb-d0d3-4c74-d199-08da6a7dfd49
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT036.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6323
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
