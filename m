Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F2AC57E419
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 18:08:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231166AbiGVQHH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 12:07:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235563AbiGVQGn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 12:06:43 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 181F113F36
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 09:06:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EOaUzA/0XzUfMHrKL59zMQCnCFNLFoIw80I+4GQuqyeHzWZbfJpN9nAmCq1hyegBbWxOeC/aDFcMyIVZRlfrojjIdPE3K5HDKXrcoJBJygWGo4NwKQevBKJaPgNf7e+Hf5pRvmloPl4eS2s1qBqy3DirQV1xp2+LSqv29Bd2H5RPH1D/4mofMst67aGzwGJTVV2y06i36ku4jpRqaZxsI7DJyicwrDKw6F3Wb1a7igpM2PS9ti2j1E7jPHD3BZgBbzI24nc3wg9GUYDLScurmRig2lUUe3Sb2qAxGQ4nvfTMKVD1q9AWgBfZgVI2RxS3UGNAcFeN/nuNCL6i8oNpJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=19ZXYhmVlEDsNdLAtenWzrVQPzq6lavvWAhYrbbTJXA=;
 b=Q+tvYALgrxA+TANDyx1QYRkfnXdijNrb7piP48vsqtbIDELqiBBPg2O/413w2ISZ3QZ/+sfEfj5tZ5sej+XCk6sam0cXrmbCDgOJ35HAO49pwv14xPVTmYB5Qhc2l9wqnhUMufEE9ppcUDQj4dhAFA+8n8U2yqdjYgufUjIgNH6P9rE8xJnzFCjjppKVR16ymM7qxFvGDce0+hSuTcbaIImdWYtDI7dN3WTo9mczL0CnakYXN9zHThdL2jER7DdOp012Z9WkWJvFpkkWVjjopKPn6p5KFHM28cPRWdr9aMmwMqN65Wp+8l9DBQZh+bFT5uj1LKImXs9m91w4otOs1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=19ZXYhmVlEDsNdLAtenWzrVQPzq6lavvWAhYrbbTJXA=;
 b=TOqKE6zzdPDGfs8gNYT/AqokCOyHcKZ9mqCpkAvV0jduE/nUFW044eQhkr8vBcUTadq9Ir/lLB5S1RTH4tTlGLxCJOn9pVv1aSCYXVgtlRfTKfv113IkiUTtYLHD8YgQZ+CfmzvBk2dqG/N44hHPuhhpg8Qm2vUCx+3jdyogT0JCTpLRPsItAG3Zw98cws67cEJUPK7c/skfQTiCCkN3MuhY4ZF0rnUdT6pYl1yvuyqfxXTQ8nXRxnF9Md8AT2264fzK4UJCs2zvdJ+DSW5+PoNe78tADiTaPHy71RGFnvqFseYmYxkoh9LOGYnkhw7n4YA3A8d5x4/xB5FWBPXDUg==
Received: from DS7PR03CA0040.namprd03.prod.outlook.com (2603:10b6:5:3b5::15)
 by MWHPR12MB1392.namprd12.prod.outlook.com (2603:10b6:300:14::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Fri, 22 Jul
 2022 16:06:32 +0000
Received: from DM6NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b5:cafe::e6) by DS7PR03CA0040.outlook.office365.com
 (2603:10b6:5:3b5::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.21 via Frontend
 Transport; Fri, 22 Jul 2022 16:06:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT019.mail.protection.outlook.com (10.13.172.172) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5458.17 via Frontend Transport; Fri, 22 Jul 2022 16:06:31 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Fri, 22 Jul
 2022 11:06:27 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Fri, 22 Jul 2022 11:06:26 -0500
From:   <ecree@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-net-drivers@amd.com>
CC:     <netdev@vger.kernel.org>, Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH net-next 09/14] sfc: use a dynamic m-port for representor RX and set it promisc
Date:   Fri, 22 Jul 2022 17:04:18 +0100
Message-ID: <55595696c836d9cd7a7813af4725ad34e3681cf6.1658497661.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1658497661.git.ecree.xilinx@gmail.com>
References: <cover.1658497661.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 23f7c940-d726-432e-b5a5-08da6bfc24bd
X-MS-TrafficTypeDiagnostic: MWHPR12MB1392:EE_
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5BC5PtM+mJVZLWh9o7ev36LQjK3N23jVnbRS1Vhw/HgJJCIx4K5DmhuHzr0sqVSuhyVAimvbatB6j5F4XBX0NNPquGjl9SDZ5H1JSofAQgz+WteEjGEFf32auVQeYPjTICVaZsBN3DXXUNYKnxqtYUSY9oQ2Zqlt2KB5+TRjoSNa78tnnnPUrL/YpGwEltqKONTsDzmVNx346FgfqLsCokaFhMn3P2t9dqprXYEhgNrI1F1aU9/8UT5VBjkuJL1ov8Mwcj3ScS4L47STXHVwPSgBAM5J+7G2KVnApu7Y33ztB5S9dLzkKfh/GEiRDemE9/TbTfmeXqQv1ri3aiGiu5iXKriHnG6Ielpmle7CsCAJYLH/XG0fZ4mhudf3hwnNffkdEtQEuQjeLTuFxO7t82UTS47k5DAWllNF6uUONeEnuILm8PTr+HXfngPXph/Y9Oua1ZniwUqLIPL+Zilh0FBhMDf/0wPqmkzEFzcFl8N8eKrwhVGNlQzZpQ7OdHPOyiDppiYrNDHFV4wd84TAg8bM44lwzbY06H8pUniraHAdEI6/PXW2cpnDjwHCi2j7tTCSYbfGBni29tlTc9wMHI4ugCm0v/4NXvejMkesLOkaKSEV1bikR51BJIUGJuAnVVJaL926YtuHwAsooJs+Q30dHqn1TMMC4CMhJRiCp6zJbrIHhJy+uwxo8R35MKqCUuVovFYT1avTGWCvpGmahTr62aJyHH4KxSd/ygZqEi0QiD3bd2CpbQ8S7grpJXy73TRMTHDqXIkug5g+tp1jiZs85jxQjQRnD8Rno3w29L7YpFhdexFy7EfcfHpkEighbIgmRNJq4vPtfX4bonQ+DQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(396003)(346002)(39860400002)(376002)(136003)(46966006)(40470700004)(36840700001)(2876002)(5660300002)(8936002)(70586007)(2906002)(70206006)(82310400005)(30864003)(4326008)(8676002)(40480700001)(40460700003)(36860700001)(356005)(83380400001)(81166007)(83170400001)(36756003)(55446002)(47076005)(41300700001)(82740400003)(316002)(6666004)(110136005)(42882007)(9686003)(336012)(54906003)(26005)(186003)(478600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2022 16:06:31.7752
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 23f7c940-d726-432e-b5a5-08da6bfc24bd
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1392
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

Representors do not want to be subject to the PF's Ethernet address
 filters, since traffic from VFs will typically have a destination
 either elsewhere on the link segment or on an overlay network.
So, create a dynamic m-port with promiscuous and all-multicast
 filters, and set it as the egress port of representor default rules.
 Since the m-port is an alias of the calling PF's own m-port, traffic
 will still be delivered to the PF's RXQs, but it will be subject to
 the VNRX filter rules installed on the dynamic m-port (specified by
 the v-port ID field of the filter spec).

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/ef100_nic.c    | 11 ++++
 drivers/net/ethernet/sfc/filter.h       | 18 ++++++
 drivers/net/ethernet/sfc/mae.c          | 37 +++++++++++++
 drivers/net/ethernet/sfc/mae.h          |  3 +
 drivers/net/ethernet/sfc/mcdi_filters.c |  6 +-
 drivers/net/ethernet/sfc/tc.c           | 73 ++++++++++++++++++++++++-
 drivers/net/ethernet/sfc/tc.h           |  9 +++
 7 files changed, 154 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index fa459b95f367..0ae27de314b5 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -24,6 +24,7 @@
 #include "ef100_tx.h"
 #include "ef100_sriov.h"
 #include "ef100_netdev.h"
+#include "tc.h"
 #include "mae.h"
 #include "rx_common.h"
 
@@ -383,7 +384,16 @@ static int ef100_filter_table_up(struct efx_nic *efx)
 	rc = efx_mcdi_filter_add_vlan(efx, 0);
 	if (rc)
 		goto fail_vlan0;
+	/* Drop the lock: we've finished altering table existence, and
+	 * filter insertion will need to take the lock for read.
+	 */
 	up_write(&efx->filter_sem);
+	rc = efx_tc_insert_rep_filters(efx);
+	/* Rep filter failure is nonfatal */
+	if (rc)
+		netif_warn(efx, drv, efx->net_dev,
+			   "Failed to insert representor filters, rc %d\n",
+			   rc);
 	return 0;
 
 fail_vlan0:
@@ -396,6 +406,7 @@ static int ef100_filter_table_up(struct efx_nic *efx)
 
 static void ef100_filter_table_down(struct efx_nic *efx)
 {
+	efx_tc_remove_rep_filters(efx);
 	down_write(&efx->filter_sem);
 	efx_mcdi_filter_del_vlan(efx, 0);
 	efx_mcdi_filter_del_vlan(efx, EFX_FILTER_VID_UNSPEC);
diff --git a/drivers/net/ethernet/sfc/filter.h b/drivers/net/ethernet/sfc/filter.h
index 40b2af8bfb81..4d928839d292 100644
--- a/drivers/net/ethernet/sfc/filter.h
+++ b/drivers/net/ethernet/sfc/filter.h
@@ -88,6 +88,7 @@ enum efx_filter_priority {
  *	the automatic filter in its place.
  * @EFX_FILTER_FLAG_RX: Filter is for RX
  * @EFX_FILTER_FLAG_TX: Filter is for TX
+ * @EFX_FILTER_FLAG_VPORT_ID: Virtual port ID for adapter switching.
  */
 enum efx_filter_flags {
 	EFX_FILTER_FLAG_RX_RSS = 0x01,
@@ -95,6 +96,7 @@ enum efx_filter_flags {
 	EFX_FILTER_FLAG_RX_OVER_AUTO = 0x04,
 	EFX_FILTER_FLAG_RX = 0x08,
 	EFX_FILTER_FLAG_TX = 0x10,
+	EFX_FILTER_FLAG_VPORT_ID = 0x20,
 };
 
 /** enum efx_encap_type - types of encapsulation
@@ -127,6 +129,9 @@ enum efx_encap_type {
  *	MCFW context_id.
  * @dmaq_id: Source/target queue index, or %EFX_FILTER_RX_DMAQ_ID_DROP for
  *	an RX drop filter
+ * @vport_id: Virtual port ID associated with RX queue, for adapter switching,
+ *	if %EFX_FILTER_FLAG_VPORT_ID is set.  This is an MCFW vport_id, or on
+ *	EF100 an mport selector.
  * @outer_vid: Outer VLAN ID to match, if %EFX_FILTER_MATCH_OUTER_VID is set
  * @inner_vid: Inner VLAN ID to match, if %EFX_FILTER_MATCH_INNER_VID is set
  * @loc_mac: Local MAC address to match, if %EFX_FILTER_MATCH_LOC_MAC or
@@ -156,6 +161,7 @@ struct efx_filter_spec {
 	u32	priority:2;
 	u32	flags:6;
 	u32	dmaq_id:12;
+	u32	vport_id;
 	u32	rss_context;
 	__be16	outer_vid __aligned(4); /* allow jhash2() of match values */
 	__be16	inner_vid;
@@ -292,6 +298,18 @@ static inline int efx_filter_set_mc_def(struct efx_filter_spec *spec)
 	return 0;
 }
 
+/**
+ * efx_filter_set_vport_id - override virtual port id relating to filter
+ * @spec: Specification to initialise
+ * @vport_id: firmware ID of the virtual port
+ */
+static inline void efx_filter_set_vport_id(struct efx_filter_spec *spec,
+					   u32 vport_id)
+{
+	spec->flags |= EFX_FILTER_FLAG_VPORT_ID;
+	spec->vport_id = vport_id;
+}
+
 static inline void efx_filter_set_encap_type(struct efx_filter_spec *spec,
 					     enum efx_encap_type encap_type)
 {
diff --git a/drivers/net/ethernet/sfc/mae.c b/drivers/net/ethernet/sfc/mae.c
index ea87ec83e618..97627f5e3674 100644
--- a/drivers/net/ethernet/sfc/mae.c
+++ b/drivers/net/ethernet/sfc/mae.c
@@ -13,6 +13,43 @@
 #include "mcdi.h"
 #include "mcdi_pcol_mae.h"
 
+int efx_mae_allocate_mport(struct efx_nic *efx, u32 *id, u32 *label)
+{
+	MCDI_DECLARE_BUF(outbuf, MC_CMD_MAE_MPORT_ALLOC_ALIAS_OUT_LEN);
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_MAE_MPORT_ALLOC_ALIAS_IN_LEN);
+	size_t outlen;
+	int rc;
+
+	if (WARN_ON_ONCE(!id))
+		return -EINVAL;
+	if (WARN_ON_ONCE(!label))
+		return -EINVAL;
+
+	MCDI_SET_DWORD(inbuf, MAE_MPORT_ALLOC_ALIAS_IN_TYPE,
+		       MC_CMD_MAE_MPORT_ALLOC_ALIAS_IN_MPORT_TYPE_ALIAS);
+	MCDI_SET_DWORD(inbuf, MAE_MPORT_ALLOC_ALIAS_IN_DELIVER_MPORT,
+		       MAE_MPORT_SELECTOR_ASSIGNED);
+	rc = efx_mcdi_rpc(efx, MC_CMD_MAE_MPORT_ALLOC, inbuf, sizeof(inbuf),
+			  outbuf, sizeof(outbuf), &outlen);
+	if (rc)
+		return rc;
+	if (outlen < sizeof(outbuf))
+		return -EIO;
+	*id = MCDI_DWORD(outbuf, MAE_MPORT_ALLOC_ALIAS_OUT_MPORT_ID);
+	*label = MCDI_DWORD(outbuf, MAE_MPORT_ALLOC_ALIAS_OUT_LABEL);
+	return 0;
+}
+
+int efx_mae_free_mport(struct efx_nic *efx, u32 id)
+{
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_MAE_MPORT_FREE_IN_LEN);
+
+	BUILD_BUG_ON(MC_CMD_MAE_MPORT_FREE_OUT_LEN);
+	MCDI_SET_DWORD(inbuf, MAE_MPORT_FREE_IN_MPORT_ID, id);
+	return efx_mcdi_rpc(efx, MC_CMD_MAE_MPORT_FREE, inbuf, sizeof(inbuf),
+			    NULL, 0, NULL);
+}
+
 void efx_mae_mport_wire(struct efx_nic *efx, u32 *out)
 {
 	efx_dword_t mport;
diff --git a/drivers/net/ethernet/sfc/mae.h b/drivers/net/ethernet/sfc/mae.h
index e9651f611750..0369be4d8983 100644
--- a/drivers/net/ethernet/sfc/mae.h
+++ b/drivers/net/ethernet/sfc/mae.h
@@ -17,6 +17,9 @@
 #include "tc.h"
 #include "mcdi_pcol.h" /* needed for various MC_CMD_MAE_*_NULL defines */
 
+int efx_mae_allocate_mport(struct efx_nic *efx, u32 *id, u32 *label);
+int efx_mae_free_mport(struct efx_nic *efx, u32 id);
+
 void efx_mae_mport_wire(struct efx_nic *efx, u32 *out);
 void efx_mae_mport_uplink(struct efx_nic *efx, u32 *out);
 void efx_mae_mport_vf(struct efx_nic *efx, u32 vf_id, u32 *out);
diff --git a/drivers/net/ethernet/sfc/mcdi_filters.c b/drivers/net/ethernet/sfc/mcdi_filters.c
index 1523be77b9db..4ff6586116ee 100644
--- a/drivers/net/ethernet/sfc/mcdi_filters.c
+++ b/drivers/net/ethernet/sfc/mcdi_filters.c
@@ -221,7 +221,10 @@ static void efx_mcdi_filter_push_prep(struct efx_nic *efx,
 		efx_mcdi_filter_push_prep_set_match_fields(efx, spec, inbuf);
 	}
 
-	MCDI_SET_DWORD(inbuf, FILTER_OP_IN_PORT_ID, efx->vport_id);
+	if (flags & EFX_FILTER_FLAG_VPORT_ID)
+		MCDI_SET_DWORD(inbuf, FILTER_OP_IN_PORT_ID, spec->vport_id);
+	else
+		MCDI_SET_DWORD(inbuf, FILTER_OP_IN_PORT_ID, efx->vport_id);
 	MCDI_SET_DWORD(inbuf, FILTER_OP_IN_RX_DEST,
 		       spec->dmaq_id == EFX_FILTER_RX_DMAQ_ID_DROP ?
 		       MC_CMD_FILTER_OP_IN_RX_DEST_DROP :
@@ -488,6 +491,7 @@ static s32 efx_mcdi_filter_insert_locked(struct efx_nic *efx,
 			saved_spec->flags |= spec->flags;
 			saved_spec->rss_context = spec->rss_context;
 			saved_spec->dmaq_id = spec->dmaq_id;
+			saved_spec->vport_id = spec->vport_id;
 		}
 	} else if (!replacing) {
 		kfree(saved_spec);
diff --git a/drivers/net/ethernet/sfc/tc.c b/drivers/net/ethernet/sfc/tc.c
index 0fb01f73c56e..0c0aeb91f500 100644
--- a/drivers/net/ethernet/sfc/tc.c
+++ b/drivers/net/ethernet/sfc/tc.c
@@ -12,6 +12,7 @@
 #include "tc.h"
 #include "mae.h"
 #include "ef100_rep.h"
+#include "efx.h"
 
 static void efx_tc_free_action_set(struct efx_nic *efx,
 				   struct efx_tc_action_set *act, bool in_hw)
@@ -122,7 +123,7 @@ int efx_tc_configure_default_rule_rep(struct efx_rep *efv)
 	u32 ing_port, eg_port;
 
 	efx_mae_mport_mport(efx, efv->mport, &ing_port);
-	efx_mae_mport_uplink(efx, &eg_port);
+	efx_mae_mport_mport(efx, efx->tc->reps_mport_id, &eg_port);
 	return efx_tc_configure_default_rule(efx, ing_port, eg_port, rule);
 }
 
@@ -134,6 +135,68 @@ void efx_tc_deconfigure_default_rule(struct efx_nic *efx,
 	rule->fw_id = MC_CMD_MAE_ACTION_RULE_INSERT_OUT_ACTION_RULE_ID_NULL;
 }
 
+static int efx_tc_configure_rep_mport(struct efx_nic *efx)
+{
+	u32 rep_mport_label;
+	int rc;
+
+	rc = efx_mae_allocate_mport(efx, &efx->tc->reps_mport_id, &rep_mport_label);
+	if (rc)
+		return rc;
+	pci_dbg(efx->pci_dev, "created rep mport 0x%08x (0x%04x)\n",
+		efx->tc->reps_mport_id, rep_mport_label);
+	/* Use mport *selector* as vport ID */
+	efx_mae_mport_mport(efx, efx->tc->reps_mport_id,
+			    &efx->tc->reps_mport_vport_id);
+	return 0;
+}
+
+static void efx_tc_deconfigure_rep_mport(struct efx_nic *efx)
+{
+	efx_mae_free_mport(efx, efx->tc->reps_mport_id);
+	efx->tc->reps_mport_id = MAE_MPORT_SELECTOR_NULL;
+}
+
+int efx_tc_insert_rep_filters(struct efx_nic *efx)
+{
+	struct efx_filter_spec promisc, allmulti;
+	int rc;
+
+	if (efx->type->is_vf)
+		return 0;
+	if (!efx->tc)
+		return 0;
+	efx_filter_init_rx(&promisc, EFX_FILTER_PRI_REQUIRED, 0, 0);
+	efx_filter_set_uc_def(&promisc);
+	efx_filter_set_vport_id(&promisc, efx->tc->reps_mport_vport_id);
+	rc = efx_filter_insert_filter(efx, &promisc, false);
+	if (rc < 0)
+		return rc;
+	efx->tc->reps_filter_uc = rc;
+	efx_filter_init_rx(&allmulti, EFX_FILTER_PRI_REQUIRED, 0, 0);
+	efx_filter_set_mc_def(&allmulti);
+	efx_filter_set_vport_id(&allmulti, efx->tc->reps_mport_vport_id);
+	rc = efx_filter_insert_filter(efx, &allmulti, false);
+	if (rc < 0)
+		return rc;
+	efx->tc->reps_filter_mc = rc;
+	return 0;
+}
+
+void efx_tc_remove_rep_filters(struct efx_nic *efx)
+{
+	if (efx->type->is_vf)
+		return;
+	if (!efx->tc)
+		return;
+	if (efx->tc->reps_filter_mc >= 0)
+		efx_filter_remove_id_safe(efx, EFX_FILTER_PRI_REQUIRED, efx->tc->reps_filter_mc);
+	efx->tc->reps_filter_mc = -1;
+	if (efx->tc->reps_filter_uc >= 0)
+		efx_filter_remove_id_safe(efx, EFX_FILTER_PRI_REQUIRED, efx->tc->reps_filter_uc);
+	efx->tc->reps_filter_uc = -1;
+}
+
 int efx_init_tc(struct efx_nic *efx)
 {
 	int rc;
@@ -141,7 +204,10 @@ int efx_init_tc(struct efx_nic *efx)
 	rc = efx_tc_configure_default_rule_pf(efx);
 	if (rc)
 		return rc;
-	return efx_tc_configure_default_rule_wire(efx);
+	rc = efx_tc_configure_default_rule_wire(efx);
+	if (rc)
+		return rc;
+	return efx_tc_configure_rep_mport(efx);
 }
 
 void efx_fini_tc(struct efx_nic *efx)
@@ -149,6 +215,7 @@ void efx_fini_tc(struct efx_nic *efx)
 	/* We can get called even if efx_init_struct_tc() failed */
 	if (!efx->tc)
 		return;
+	efx_tc_deconfigure_rep_mport(efx);
 	efx_tc_deconfigure_default_rule(efx, &efx->tc->dflt.pf);
 	efx_tc_deconfigure_default_rule(efx, &efx->tc->dflt.wire);
 }
@@ -162,6 +229,8 @@ int efx_init_struct_tc(struct efx_nic *efx)
 	if (!efx->tc)
 		return -ENOMEM;
 
+	efx->tc->reps_filter_uc = -1;
+	efx->tc->reps_filter_mc = -1;
 	INIT_LIST_HEAD(&efx->tc->dflt.pf.acts.list);
 	efx->tc->dflt.pf.fw_id = MC_CMD_MAE_ACTION_RULE_INSERT_OUT_ACTION_RULE_ID_NULL;
 	INIT_LIST_HEAD(&efx->tc->dflt.wire.acts.list);
diff --git a/drivers/net/ethernet/sfc/tc.h b/drivers/net/ethernet/sfc/tc.h
index 46c5101eaa8d..309123c6b386 100644
--- a/drivers/net/ethernet/sfc/tc.h
+++ b/drivers/net/ethernet/sfc/tc.h
@@ -49,12 +49,18 @@ enum efx_tc_rule_prios {
 /**
  * struct efx_tc_state - control plane data for TC offload
  *
+ * @reps_mport_id: MAE port allocated for representor RX
+ * @reps_filter_uc: VNIC filter for representor unicast RX (promisc)
+ * @reps_filter_mc: VNIC filter for representor multicast RX (allmulti)
+ * @reps_mport_vport_id: vport_id for representor RX filters
  * @dflt: Match-action rules for default switching; at priority
  *	%EFX_TC_PRIO_DFLT.  Named by *ingress* port
  * @dflt.pf: rule for traffic ingressing from PF (egresses to wire)
  * @dflt.wire: rule for traffic ingressing from wire (egresses to PF)
  */
 struct efx_tc_state {
+	u32 reps_mport_id, reps_mport_vport_id;
+	s32 reps_filter_uc, reps_filter_mc;
 	struct {
 		struct efx_tc_flow_rule pf;
 		struct efx_tc_flow_rule wire;
@@ -67,6 +73,9 @@ int efx_tc_configure_default_rule_rep(struct efx_rep *efv);
 void efx_tc_deconfigure_default_rule(struct efx_nic *efx,
 				     struct efx_tc_flow_rule *rule);
 
+int efx_tc_insert_rep_filters(struct efx_nic *efx);
+void efx_tc_remove_rep_filters(struct efx_nic *efx);
+
 int efx_init_tc(struct efx_nic *efx);
 void efx_fini_tc(struct efx_nic *efx);
 
