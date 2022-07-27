Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7137A583264
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 20:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233461AbiG0Svf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 14:51:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236220AbiG0Su5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 14:50:57 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2083.outbound.protection.outlook.com [40.107.223.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D85AABE7B
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 10:47:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dFhlqzijtNCdnzL4nvBahGhPyvrzR5+3oDHWLg+haaK4rubofJWMes7vEGLlpW/CMGzMThXFnQWjieepV8zsf5iO8w4DeeAaOVKJ3NJwaEQtsA6N5ielB77ZKQb5aqOaARnnAxpJhypy36EeXwJiIKtjEN5H9W/Cc23jT9cvyszEmCmBbk1nQMGPDP813pqgF1/rkuki/IxbDqQBvAox1rqdG6JAV7ots3bavB3flcJXc6xOiRijAgdKrTVxTTXUAU1V8FL3YqTGY8EEbIpUGbI7jtCHV6SSmqk/exUu48UvopXoTMGqlR5BQiDxsf5sk/o8yJmuq1Uy9zGTCy+9Jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t4W+4odoY71AQ9d30OzFH807MgvxUuKYI8TjDvPkgYY=;
 b=WcO4SM/aHPb8/u1pISn0G8WRJY8z5XkXYSgsYyaMhc4EFpsz2gVVzWNZyXZGiNbOkSe7rYs2HuTY57V6wIYePznW6BoIWYh71WQnEeJBXzXXaRJWeUBtxuCDVez8Nry/i+NP0bUpfgFD+AzsZMItDwaJ3yl14CiCkBrvkPkh1Cwoxsioudmw12MxTYQO9VpopXHvpMwdw2wwY4SDpU6Z7Ccu7H+8hIWR6ohLpd7rOdDqNLmlwngLna2PtNy046KLVMyJ5r/I6g5KEA13ZbIQDVI+ofjD9dg+lXv5/hlzmvumYOFlaz+BRghdrSPfrf6tRxSax7K/NYvxl2Fgp1aQhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t4W+4odoY71AQ9d30OzFH807MgvxUuKYI8TjDvPkgYY=;
 b=Wdi5KsW+i9VAp8VZr2HLsRU0AbhpjcNaK8M7i6gaQ0ZWVyPmNVeM393s3v/R8nzpu2C7nS/6KFBZ/CTjBt7esSZmskbfVwBInMBMCiZspuZwqCKPcZ9swnjJF74Wtj9XtRJrvyJyjWsd1c/Q0yT4DeWgPKwP0+fXCJLFmiGJWCGfiCg6/ur9Kp9ON1W7bp34fWAhFjD+FLCOF04hIkqfpTYYFK7e8vgSJbu2nLnsoHvS4wXEDBW70oIozEnpGULrvdMvdmKIyBbalEfLIzcIC6hMNV3LYZP6k8tg8R2dkRDQtpuAoNFo08D/9PNg32Sp7bQXoXee52icCw0fOz094A==
Received: from MW3PR06CA0022.namprd06.prod.outlook.com (2603:10b6:303:2a::27)
 by BN6PR12MB1636.namprd12.prod.outlook.com (2603:10b6:405:6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Wed, 27 Jul
 2022 17:47:06 +0000
Received: from CO1NAM11FT008.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:2a:cafe::f0) by MW3PR06CA0022.outlook.office365.com
 (2603:10b6:303:2a::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.10 via Frontend
 Transport; Wed, 27 Jul 2022 17:47:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT008.mail.protection.outlook.com (10.13.175.191) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5482.10 via Frontend Transport; Wed, 27 Jul 2022 17:47:05 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 27 Jul
 2022 12:47:01 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Wed, 27 Jul 2022 12:47:00 -0500
From:   <ecree@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-net-drivers@amd.com>
CC:     <netdev@vger.kernel.org>, Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH net-next v2 08/14] sfc: move table locking into filter_table_{probe,remove} methods
Date:   Wed, 27 Jul 2022 18:45:58 +0100
Message-ID: <65a9be35bc76f6d1be4e0da22170fa1e52df7129.1658943677.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1658943677.git.ecree.xilinx@gmail.com>
References: <cover.1658943677.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7ad178c2-d1fb-4c00-573a-08da6ff80553
X-MS-TrafficTypeDiagnostic: BN6PR12MB1636:EE_
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9q64cjHC4/rHjWGgSjmB+YfIlcojZiU0XOOhVnfhTrsr0RTxAszdjAkC490uLranv/tHamAojGls4drAsAeSnv5wFuVPP0zoaRukZ/zbrHbmPhUXKLzq/tgcfXbBd+6aVQ47f+iGbu8lf/Taa1ZTlx3hWB8+oLn/oV31I4dH/nr7wIuuH7SG5avRcx7aMzhLLmQ3vxnVBle/ffz1HZnx4z7eqRKqA5uU+YN92kJOQ+tN3Q0mWtF9jEnLibIwnH6yTOtYBmKQBOzUkxbNggTFj6EbyE+Sr3fSWxLPsSLkX1lUD0Ax/GN+a6SpZvsF3UhqraR9fOTuAi7j/V7NLkB+aQevrtxGo2M5g+saIYh3jf0Bzkul//Lh6wZKS46yg7PcSkwfPj8YpJ678XlLklRJEfWPEhKPDqqZ878hVRRMcJa0mRm1IzPhbsmUvla39nxdq7J9E38KSyFxbXLPZnas4mFHNpYqWGxCL0SYCL2DeTOR7cVlSP5grR39vcsqA5henLzCc+6KES4Fl2adlSWobc8U6/RX9HehpunAPUft5QjRYFObUWTj0us8+BpcD9JPe4HskUa+QHT0qu0snUk1p/kZkjCgs1s+AxykdQlwQWGD58LiIaJVc+IsHrOmAP9994Dv/xCshcnz9lLYdIMxEgUK023UDkue7ErgOPICYxja3+piMN9qQ3tRtTiwajVNIT9/CrIaiCtgsWeF8XFJJnByviRwK9un89zwEPOAbEictte6RYdEquuJufGcSaHH5In7SvptIcD2/MRDjDCfUuI6aiN69l+6dN2/t1B2xvTdSaJ3MkmCQNGOyv5TQyjcsOG0QdYcMbREAuJB8Vaj7A==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(376002)(346002)(396003)(36840700001)(40470700004)(46966006)(81166007)(110136005)(186003)(316002)(2876002)(40480700001)(2906002)(41300700001)(356005)(478600001)(82740400003)(83380400001)(83170400001)(42882007)(55446002)(54906003)(8936002)(70586007)(4326008)(8676002)(36860700001)(9686003)(70206006)(26005)(336012)(5660300002)(47076005)(82310400005)(40460700003)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2022 17:47:05.6392
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ad178c2-d1fb-4c00-573a-08da6ff80553
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT008.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1636
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

We need to be able to drop the efx->filter_sem in ef100_filter_table_up()
 so that we can call functions that insert filters (and thus take that
 rwsem for read), which means the efx->type->filter_table_probe method
 needs to be responsible for taking the lock in the first place.

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/ef10.c         | 26 ++++++++++++++-----------
 drivers/net/ethernet/sfc/ef100_nic.c    | 22 +++++++++++++--------
 drivers/net/ethernet/sfc/ef10_sriov.c   | 16 +++------------
 drivers/net/ethernet/sfc/mcdi_filters.h |  1 +
 drivers/net/ethernet/sfc/rx_common.c    |  4 ----
 5 files changed, 33 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index ab979fd11133..ee734b69150f 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -2538,23 +2538,33 @@ static int efx_ef10_filter_table_probe(struct efx_nic *efx)
 
 	if (rc)
 		return rc;
+	down_write(&efx->filter_sem);
 	rc = efx_mcdi_filter_table_probe(efx, nic_data->workaround_26807);
 
 	if (rc)
-		return rc;
+		goto out_unlock;
 
 	list_for_each_entry(vlan, &nic_data->vlan_list, list) {
 		rc = efx_mcdi_filter_add_vlan(efx, vlan->vid);
 		if (rc)
 			goto fail_add_vlan;
 	}
-	return 0;
+	goto out_unlock;
 
 fail_add_vlan:
 	efx_mcdi_filter_table_remove(efx);
+out_unlock:
+	up_write(&efx->filter_sem);
 	return rc;
 }
 
+static void efx_ef10_filter_table_remove(struct efx_nic *efx)
+{
+	down_write(&efx->filter_sem);
+	efx_mcdi_filter_table_remove(efx);
+	up_write(&efx->filter_sem);
+}
+
 /* This creates an entry in the RX descriptor queue */
 static inline void
 efx_ef10_build_rx_desc(struct efx_rx_queue *rx_queue, unsigned int index)
@@ -3211,9 +3221,7 @@ static int efx_ef10_vport_set_mac_address(struct efx_nic *efx)
 
 	efx_device_detach_sync(efx);
 	efx_net_stop(efx->net_dev);
-	down_write(&efx->filter_sem);
-	efx_mcdi_filter_table_remove(efx);
-	up_write(&efx->filter_sem);
+	efx_ef10_filter_table_remove(efx);
 
 	rc = efx_ef10_vadaptor_free(efx, efx->vport_id);
 	if (rc)
@@ -3243,9 +3251,7 @@ static int efx_ef10_vport_set_mac_address(struct efx_nic *efx)
 	if (rc2)
 		goto reset_nic;
 restore_filters:
-	down_write(&efx->filter_sem);
 	rc2 = efx_ef10_filter_table_probe(efx);
-	up_write(&efx->filter_sem);
 	if (rc2)
 		goto reset_nic;
 
@@ -3275,8 +3281,7 @@ static int efx_ef10_set_mac_address(struct efx_nic *efx)
 	efx_net_stop(efx->net_dev);
 
 	mutex_lock(&efx->mac_lock);
-	down_write(&efx->filter_sem);
-	efx_mcdi_filter_table_remove(efx);
+	efx_ef10_filter_table_remove(efx);
 
 	ether_addr_copy(MCDI_PTR(inbuf, VADAPTOR_SET_MAC_IN_MACADDR),
 			efx->net_dev->dev_addr);
@@ -3286,7 +3291,6 @@ static int efx_ef10_set_mac_address(struct efx_nic *efx)
 				sizeof(inbuf), NULL, 0, NULL);
 
 	efx_ef10_filter_table_probe(efx);
-	up_write(&efx->filter_sem);
 	mutex_unlock(&efx->mac_lock);
 
 	if (was_enabled)
@@ -4092,7 +4096,7 @@ const struct efx_nic_type efx_hunt_a0_vf_nic_type = {
 	.ev_test_generate = efx_ef10_ev_test_generate,
 	.filter_table_probe = efx_ef10_filter_table_probe,
 	.filter_table_restore = efx_mcdi_filter_table_restore,
-	.filter_table_remove = efx_mcdi_filter_table_remove,
+	.filter_table_remove = efx_ef10_filter_table_remove,
 	.filter_update_rx_scatter = efx_mcdi_update_rx_scatter,
 	.filter_insert = efx_mcdi_filter_insert,
 	.filter_remove_safe = efx_mcdi_filter_remove_safe,
diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index 25cd43e3fcf7..5fe18b383e20 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -375,26 +375,32 @@ static int ef100_filter_table_up(struct efx_nic *efx)
 {
 	int rc;
 
+	down_write(&efx->filter_sem);
 	rc = efx_mcdi_filter_add_vlan(efx, EFX_FILTER_VID_UNSPEC);
-	if (rc) {
-		efx_mcdi_filter_table_down(efx);
-		return rc;
-	}
+	if (rc)
+		goto fail_unspec;
 
 	rc = efx_mcdi_filter_add_vlan(efx, 0);
-	if (rc) {
-		efx_mcdi_filter_del_vlan(efx, EFX_FILTER_VID_UNSPEC);
-		efx_mcdi_filter_table_down(efx);
-	}
+	if (rc)
+		goto fail_vlan0;
+	up_write(&efx->filter_sem);
+	return 0;
 
+fail_vlan0:
+	efx_mcdi_filter_del_vlan(efx, EFX_FILTER_VID_UNSPEC);
+fail_unspec:
+	efx_mcdi_filter_table_down(efx);
+	up_write(&efx->filter_sem);
 	return rc;
 }
 
 static void ef100_filter_table_down(struct efx_nic *efx)
 {
+	down_write(&efx->filter_sem);
 	efx_mcdi_filter_del_vlan(efx, 0);
 	efx_mcdi_filter_del_vlan(efx, EFX_FILTER_VID_UNSPEC);
 	efx_mcdi_filter_table_down(efx);
+	up_write(&efx->filter_sem);
 }
 
 /*	Other
diff --git a/drivers/net/ethernet/sfc/ef10_sriov.c b/drivers/net/ethernet/sfc/ef10_sriov.c
index 92550c7e85ce..9aae0d8b713f 100644
--- a/drivers/net/ethernet/sfc/ef10_sriov.c
+++ b/drivers/net/ethernet/sfc/ef10_sriov.c
@@ -501,14 +501,11 @@ int efx_ef10_sriov_set_vf_mac(struct efx_nic *efx, int vf_i, const u8 *mac)
 		efx_device_detach_sync(vf->efx);
 		efx_net_stop(vf->efx->net_dev);
 
-		down_write(&vf->efx->filter_sem);
 		vf->efx->type->filter_table_remove(vf->efx);
 
 		rc = efx_ef10_vadaptor_free(vf->efx, EVB_PORT_ID_ASSIGNED);
-		if (rc) {
-			up_write(&vf->efx->filter_sem);
+		if (rc)
 			return rc;
-		}
 	}
 
 	rc = efx_ef10_evb_port_assign(efx, EVB_PORT_ID_NULL, vf_i);
@@ -539,12 +536,9 @@ int efx_ef10_sriov_set_vf_mac(struct efx_nic *efx, int vf_i, const u8 *mac)
 	if (vf->efx) {
 		/* VF cannot use the vport_id that the PF created */
 		rc = efx_ef10_vadaptor_alloc(vf->efx, EVB_PORT_ID_ASSIGNED);
-		if (rc) {
-			up_write(&vf->efx->filter_sem);
+		if (rc)
 			return rc;
-		}
 		vf->efx->type->filter_table_probe(vf->efx);
-		up_write(&vf->efx->filter_sem);
 		efx_net_open(vf->efx->net_dev);
 		efx_device_attach_if_not_resetting(vf->efx);
 	}
@@ -580,7 +574,6 @@ int efx_ef10_sriov_set_vf_vlan(struct efx_nic *efx, int vf_i, u16 vlan,
 		efx_net_stop(vf->efx->net_dev);
 
 		mutex_lock(&vf->efx->mac_lock);
-		down_write(&vf->efx->filter_sem);
 		vf->efx->type->filter_table_remove(vf->efx);
 
 		rc = efx_ef10_vadaptor_free(vf->efx, EVB_PORT_ID_ASSIGNED);
@@ -654,7 +647,6 @@ int efx_ef10_sriov_set_vf_vlan(struct efx_nic *efx, int vf_i, u16 vlan,
 		if (rc2)
 			goto reset_nic_up_write;
 
-		up_write(&vf->efx->filter_sem);
 		mutex_unlock(&vf->efx->mac_lock);
 
 		rc2 = efx_net_open(vf->efx->net_dev);
@@ -666,10 +658,8 @@ int efx_ef10_sriov_set_vf_vlan(struct efx_nic *efx, int vf_i, u16 vlan,
 	return rc;
 
 reset_nic_up_write:
-	if (vf->efx) {
-		up_write(&vf->efx->filter_sem);
+	if (vf->efx)
 		mutex_unlock(&vf->efx->mac_lock);
-	}
 reset_nic:
 	if (vf->efx) {
 		netif_err(efx, drv, efx->net_dev,
diff --git a/drivers/net/ethernet/sfc/mcdi_filters.h b/drivers/net/ethernet/sfc/mcdi_filters.h
index 06426aa9f2f3..c0d6558b9fd2 100644
--- a/drivers/net/ethernet/sfc/mcdi_filters.h
+++ b/drivers/net/ethernet/sfc/mcdi_filters.h
@@ -89,6 +89,7 @@ struct efx_mcdi_filter_table {
 	 */
 	bool mc_chaining;
 	bool vlan_filter;
+	/* Entries on the vlan_list are added/removed under filter_sem */
 	struct list_head vlan_list;
 };
 
diff --git a/drivers/net/ethernet/sfc/rx_common.c b/drivers/net/ethernet/sfc/rx_common.c
index bd21d6ac778a..4826e6a7e4ce 100644
--- a/drivers/net/ethernet/sfc/rx_common.c
+++ b/drivers/net/ethernet/sfc/rx_common.c
@@ -793,7 +793,6 @@ int efx_probe_filters(struct efx_nic *efx)
 	int rc;
 
 	mutex_lock(&efx->mac_lock);
-	down_write(&efx->filter_sem);
 	rc = efx->type->filter_table_probe(efx);
 	if (rc)
 		goto out_unlock;
@@ -830,7 +829,6 @@ int efx_probe_filters(struct efx_nic *efx)
 	}
 #endif
 out_unlock:
-	up_write(&efx->filter_sem);
 	mutex_unlock(&efx->mac_lock);
 	return rc;
 }
@@ -846,9 +844,7 @@ void efx_remove_filters(struct efx_nic *efx)
 		channel->rps_flow_id = NULL;
 	}
 #endif
-	down_write(&efx->filter_sem);
 	efx->type->filter_table_remove(efx);
-	up_write(&efx->filter_sem);
 }
 
 #ifdef CONFIG_RFS_ACCEL
