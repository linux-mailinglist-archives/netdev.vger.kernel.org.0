Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E93F583260
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 20:51:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbiG0SvI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 14:51:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230487AbiG0Suw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 14:50:52 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2055.outbound.protection.outlook.com [40.107.223.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59CBB8C76E
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 10:47:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cVfdXpG6RmCkol7I/EFH6uqdOYdMwYW7iPHD5e8NyK4KcompltjPkntvD32QiKs34Pu1ftJHaxagG1x6hDzGMo8YoU2v+dhIWlJ3rksmB8u1JJ5P/e2jWB3n8/uITgmNageUqN3fhVMNDxxtbG887dD2+F2QoBoQMzOm7AAAzMV+s4A1VAxo1Mp9KHklqDGfFqUbr8v60in/dvr53k0siJRVRRe1RdmEc8WzZY+5VtMvD1eEWjmj6WqrkOrJEUQ3okeRF1bs84kZ9pJPMNWQvUvGwDaplPVSsHk+HekvjiCUgQ7m0IfQ3JVeheK6sIcWya3uVpmb4+ztuBTBTj7AvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XfdqkurY77O25VPVcelRdCW/iPWMGoqTJUW5RIBF9cc=;
 b=jjTjSnSK5VrJoOJGpxkC/Kl8SgCHAT3kBb3UWtWzcjkw70GX6qFBr/etC0SMJV7/apnp0+sufU5dN+joBwvAkrcmM3qmoBSogqYrbTNcDztCy/mM1Ax/fpz2ldx5CryujP3VPPKUOjsdKdcdjwUah++C94Z7rL+RYE+uRfqYwvnTpQaGjNJZr9c5FHveSeDmDeIJkCYU4dNYTi0gEbPiQL/XpqY/xuOLndL79RV1+3nsa8b/s/OVx+sKRpwbEjttEECuCjN+fKfpgsTqPi1BPY6GbUftQqO/ciBvRsq7vLU0L8l9v8V6zx5AJ/K1U3YyD4Z6b1IKMuSkTA9Z8+EjWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XfdqkurY77O25VPVcelRdCW/iPWMGoqTJUW5RIBF9cc=;
 b=hKA6WhMchgiAF2zGxvdXCQ/yvC1zJNrfZ/acRFMKbzuuZkHyQHM0qZ7EcUy5xF4VMlCyCrZrRH9l6O5H+kjRJKQdWooa1pSnxwMedHV8X2gVkk+D/cTi+tIZrjj3Wnbusda79xX1v2dGK5aa5RnxfIWjG/RgE/ZhWAlpU1uVgA+ICT8PBhNefLxB9bkZ1+Fcqc3+B0xrL5tpfPvqxMo9VbFJI8Psr4oUPSTX2qR1oATYlyXo8JeDjwyUmJbgFgC6ZJnklNi3nttt0qsmK37F6oTlFe1Iov+XVINfjvJ8YgcHfnaBQT9zePs3/a0YsasntRZvPHHrluxq3lcnVibLWA==
Received: from MW3PR06CA0005.namprd06.prod.outlook.com (2603:10b6:303:2a::10)
 by DM5PR12MB1356.namprd12.prod.outlook.com (2603:10b6:3:74::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Wed, 27 Jul
 2022 17:47:04 +0000
Received: from CO1NAM11FT008.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:2a:cafe::4f) by MW3PR06CA0005.outlook.office365.com
 (2603:10b6:303:2a::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.21 via Frontend
 Transport; Wed, 27 Jul 2022 17:47:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT008.mail.protection.outlook.com (10.13.175.191) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5482.10 via Frontend Transport; Wed, 27 Jul 2022 17:47:03 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 27 Jul
 2022 12:46:55 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Wed, 27 Jul 2022 12:46:54 -0500
From:   <ecree@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-net-drivers@amd.com>
CC:     <netdev@vger.kernel.org>, Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH net-next v2 04/14] sfc: determine wire m-port at EF100 PF probe time
Date:   Wed, 27 Jul 2022 18:45:54 +0100
Message-ID: <6eb45c1cb8c39a27a53807667a685ca051eda4ec.1658943677.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1658943677.git.ecree.xilinx@gmail.com>
References: <cover.1658943677.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 20688ad5-1312-4c25-2fcf-08da6ff80403
X-MS-TrafficTypeDiagnostic: DM5PR12MB1356:EE_
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zGU7Gij0qy0iH2vBeV/OsjGpeMb3c8HnWANQnaQtXYZ2Gkx/oMJO4sayI/e9EQ8Pgo3/sslFpedIoO4d1lNIM/eIRh7y8sDA8FY3rSYVYAGv+LvcC7+VDDCSrLnrbI9aUf5IlfNclz8m8SpF1ZoRMFmsMRbD9a22Bj0FH3NFOkrhP2YIfWMFwdyiAcRsJ06y9q+K7oy3Tn3fj217gjz4zzJzhsj06nX14VPd8cyfU7jykuYB4qKTwnjQSEsOaMwjEPYBAoj1ZFY5lFraQR5hGdnfP4Gv3Hh1OCsMJq1j8FiviPS0CiUFVINqePgIpUxOAaHQu2WUp+XA5uclG4l/8IjBB/BiGzFpv1swOLREG2fcgVMl+c5mDEjBZLuA588tF0waEpH4ywuZUNPQ5DBZeVbrRmXMrYu2Pdsg831Hrx0AfCGdnIbCee4J8giVaz/CEbOngSWWfWg80gITjw7J9V2ddo40ashFWLVfj8QaIlgcSkz840oJ/8bfyhv3A3agk5kIR3B3S0nBgRseeiYeubasSdjT+san1cTN4cfhjSA1M5/TgPV7gX8zENPk94cK1k4s08G6wBFLD0EnSO2gXOI5qjbsAiKE0QoJIXdYxu7wsL4haUNEy28nj51H3Us1GMSMmFMQHK2thTVEUK56c1tIunN3X3LQUIn03x4reH7JFGEPqzBJktwO0FhuKOdXD+zHsJUgowBYDXCn5CQbV6ppCAeMs1MJ1OXOx1RNavgUNA82IQeFU6aLIzrpybre5AqqtVk6Jf1gCvGVPCaYKQYjxl02e/vPLt657jyw8Li3V32EDmRvD1SJlUo2qaY2Ycfm/V8bQFYdnqmvVTgdfg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(136003)(376002)(39860400002)(396003)(346002)(46966006)(40470700004)(36840700001)(8676002)(186003)(55446002)(81166007)(336012)(83170400001)(8936002)(2906002)(36756003)(83380400001)(42882007)(478600001)(41300700001)(54906003)(9686003)(40460700003)(47076005)(26005)(110136005)(36860700001)(40480700001)(5660300002)(316002)(82740400003)(70586007)(2876002)(70206006)(356005)(82310400005)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2022 17:47:03.4361
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 20688ad5-1312-4c25-2fcf-08da6ff80403
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT008.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1356
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

Traffic delivered to the (MAE admin) PF could be from either the wire
 or a VF.  The INGRESS_MPORT field of the RX prefix distinguishes these;
 base_mport is the value this field will have for traffic from the wire
 (which should be delivered to the PF's netdevice, not a representor).

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/ef100_nic.c | 37 ++++++++++++++++++++++++++++
 drivers/net/ethernet/sfc/ef100_nic.h |  2 ++
 drivers/net/ethernet/sfc/mae.c       | 10 ++++++++
 drivers/net/ethernet/sfc/mae.h       |  1 +
 4 files changed, 50 insertions(+)

diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index 4625d35269e6..393d6ca4525c 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -24,6 +24,7 @@
 #include "ef100_tx.h"
 #include "ef100_sriov.h"
 #include "ef100_netdev.h"
+#include "mae.h"
 #include "rx_common.h"
 
 #define EF100_MAX_VIS 4096
@@ -704,6 +705,31 @@ static unsigned int efx_ef100_recycle_ring_size(const struct efx_nic *efx)
 	return 10 * EFX_RECYCLE_RING_SIZE_10G;
 }
 
+#ifdef CONFIG_SFC_SRIOV
+static int efx_ef100_get_base_mport(struct efx_nic *efx)
+{
+	struct ef100_nic_data *nic_data = efx->nic_data;
+	u32 selector, id;
+	int rc;
+
+	/* Construct mport selector for "physical network port" */
+	efx_mae_mport_wire(efx, &selector);
+	/* Look up actual mport ID */
+	rc = efx_mae_lookup_mport(efx, selector, &id);
+	if (rc)
+		return rc;
+	/* The ID should always fit in 16 bits, because that's how wide the
+	 * corresponding fields in the RX prefix & TX override descriptor are
+	 */
+	if (id >> 16)
+		netif_warn(efx, probe, efx->net_dev, "Bad base m-port id %#x\n",
+			   id);
+	nic_data->base_mport = id;
+	nic_data->have_mport = true;
+	return 0;
+}
+#endif
+
 static int compare_versions(const char *a, const char *b)
 {
 	int a_major, a_minor, a_point, a_patch;
@@ -1064,6 +1090,17 @@ int ef100_probe_netdev_pf(struct efx_nic *efx)
 	eth_hw_addr_set(net_dev, net_dev->perm_addr);
 	memcpy(nic_data->port_id, net_dev->perm_addr, ETH_ALEN);
 
+	if (!nic_data->grp_mae)
+		return 0;
+
+#ifdef CONFIG_SFC_SRIOV
+	rc = efx_ef100_get_base_mport(efx);
+	if (rc) {
+		netif_warn(efx, probe, net_dev,
+			   "Failed to probe base mport rc %d; representors will not function\n",
+			   rc);
+	}
+#endif
 	return 0;
 
 fail:
diff --git a/drivers/net/ethernet/sfc/ef100_nic.h b/drivers/net/ethernet/sfc/ef100_nic.h
index 40f84a275057..0295933145fa 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.h
+++ b/drivers/net/ethernet/sfc/ef100_nic.h
@@ -72,6 +72,8 @@ struct ef100_nic_data {
 	u8 port_id[ETH_ALEN];
 	DECLARE_BITMAP(evq_phases, EFX_MAX_CHANNELS);
 	u64 stats[EF100_STAT_COUNT];
+	u32 base_mport;
+	bool have_mport; /* base_mport was populated successfully */
 	bool grp_mae; /* MAE Privilege */
 	u16 tso_max_hdr_len;
 	u16 tso_max_payload_num_segs;
diff --git a/drivers/net/ethernet/sfc/mae.c b/drivers/net/ethernet/sfc/mae.c
index 011ebd46ada5..0cbcadde6677 100644
--- a/drivers/net/ethernet/sfc/mae.c
+++ b/drivers/net/ethernet/sfc/mae.c
@@ -13,6 +13,16 @@
 #include "mcdi.h"
 #include "mcdi_pcol.h"
 
+void efx_mae_mport_wire(struct efx_nic *efx, u32 *out)
+{
+	efx_dword_t mport;
+
+	EFX_POPULATE_DWORD_2(mport,
+			     MAE_MPORT_SELECTOR_TYPE, MAE_MPORT_SELECTOR_TYPE_PPORT,
+			     MAE_MPORT_SELECTOR_PPORT_ID, efx->port_num);
+	*out = EFX_DWORD_VAL(mport);
+}
+
 void efx_mae_mport_vf(struct efx_nic *efx __always_unused, u32 vf_id, u32 *out)
 {
 	efx_dword_t mport;
diff --git a/drivers/net/ethernet/sfc/mae.h b/drivers/net/ethernet/sfc/mae.h
index 27e69e8a54b6..25c2fd94e158 100644
--- a/drivers/net/ethernet/sfc/mae.h
+++ b/drivers/net/ethernet/sfc/mae.h
@@ -15,6 +15,7 @@
 
 #include "net_driver.h"
 
+void efx_mae_mport_wire(struct efx_nic *efx, u32 *out);
 void efx_mae_mport_vf(struct efx_nic *efx, u32 vf_id, u32 *out);
 
 int efx_mae_lookup_mport(struct efx_nic *efx, u32 selector, u32 *id);
