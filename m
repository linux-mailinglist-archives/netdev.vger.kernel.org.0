Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C7CF58466E
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 21:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231610AbiG1S7D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 14:59:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232332AbiG1S64 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 14:58:56 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2067.outbound.protection.outlook.com [40.107.92.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D2D27646E
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 11:58:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Obxew2N7ashHVPce8P3pLgXsvCsSkjLRjlerAAKYAZao1fulPWU4ROr8VEsFa6ma3BZnOE/eImgKpk2yNRA1kJm49B3Ar6knogLeRmgvVxRIxKIfNWx1gRMi10F1FM8dOrqDSf4E7VD02zG5Tc3gNz68oYzDxGP7hOXZp9r6I4Sx0TAy7xXXkguwsbXJ+ITRpYu/PmaBgwAGhyz5FxV/1IgztclU0I1PNVsH4ihQVly2gCO5PfHKKFGtjC4aN1pEzhN+Vg/YjWvvfeHIBBNPlb8YKaCRoDA52PF2ihggiDc/rFgX+wH2GF4hHAkc4DPCurtzi634rLVLmaSmgAk46Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t4W+4odoY71AQ9d30OzFH807MgvxUuKYI8TjDvPkgYY=;
 b=DCebOCwEEe9KbS7YzWEaxZk4MbhaPve7XZL7vtzHQqWa5pQTugMAzYOM9NO5avXx8tgooYSJDr5FihfjnfERYMcX5hIowCCYqwLxa1rPqa+Zw4nEvhTKRPvlOC0pdnJXoVV+hPXIP/mVCQdIAQz21fySZBhmmiYUqSG0qGayDLLgvQxMlJdGMLxcYNOAkdJOXKKO071JvOf0u8QyMvvzy/UuYQQVi9dYB2AeEqNi92PUkLZ6N6ipaVzaJp3KVtBURYUkpoMpBOB7LxCQl7bm9YFbjHe8Y+TARzYY8qjayvYT8fsVnTvdV87zKLh93KQewQf7dPJcq4GmGHHkN2YVrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t4W+4odoY71AQ9d30OzFH807MgvxUuKYI8TjDvPkgYY=;
 b=B5QKO/w/hJyjK9U4oaBunNEdIH3JVu1tv8ST4G1bpsnmiMONJLayJfag1Ys+TBM4wgabd6jtGNxxpQU69lTgzSsBDtk0/g3H+FxTxh6kEUwFVhC6QjporUlS4R8v37s1IbbAXSQ5UYZ3YSS0TPzBfsxD5dTwIgYNr3ClSYgxyl6mzDM3M6dRKIgsAw+G6hAg/XJe68WIBgLkHb/vS6jiQctkIHsMFK4BHDnkTjyJOZnd+tSxiPwVsUFS0/61pqi0M0UqSeyS6aXQrAlXr20tE1DvG2RjRAzKB9xQn8B4ju9j7KuluiHfWI29j07/hvVOvsO8uQjjsEDyEod/5cxbfw==
Received: from BN8PR04CA0038.namprd04.prod.outlook.com (2603:10b6:408:d4::12)
 by PH8PR12MB6964.namprd12.prod.outlook.com (2603:10b6:510:1bf::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.25; Thu, 28 Jul
 2022 18:58:48 +0000
Received: from BN8NAM11FT040.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:d4:cafe::59) by BN8PR04CA0038.outlook.office365.com
 (2603:10b6:408:d4::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23 via Frontend
 Transport; Thu, 28 Jul 2022 18:58:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT040.mail.protection.outlook.com (10.13.177.166) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5482.10 via Frontend Transport; Thu, 28 Jul 2022 18:58:48 +0000
Received: from SATLEXMB07.amd.com (10.181.41.45) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Thu, 28 Jul
 2022 13:58:47 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB07.amd.com
 (10.181.41.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Thu, 28 Jul
 2022 11:58:47 -0700
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Thu, 28 Jul 2022 13:58:46 -0500
From:   <ecree@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-net-drivers@amd.com>
CC:     <netdev@vger.kernel.org>, Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH net-next v3 08/10] sfc: move table locking into filter_table_{probe,remove} methods
Date:   Thu, 28 Jul 2022 19:57:50 +0100
Message-ID: <68c21e41ad5193b60939ce1cf40faa6b97bd04b2.1659034549.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1659034549.git.ecree.xilinx@gmail.com>
References: <cover.1659034549.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 62cdf517-2c62-4dea-fee3-08da70cb341f
X-MS-TrafficTypeDiagnostic: PH8PR12MB6964:EE_
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Lqtw6HIVqiiZi6DMq0AULIKc6koe+hvYVNfQCx4QLgf04xRefi506/CuZ3xWZNb56c3AGDIrPQ2oBKA7UcQme3kMqTomrJvlqzAZ+HAYpzRf+Q76QSDB3L1lA6oagwP4qTOa6WVGbkEElIdq5Dkayvl2tbNdy/WMfUcdGZ8hxg3Eyfd+nKt9u9nPB/egh5xaPHBoeetnRnP5ExC/wPEH3ubv5BFZfyjqm9lDOwPU5pf5oILai5HyE2mrQcupNFrTeSJ50OA7EBzA8p1IK8ZOc6s4r5NAT8XFCQBtB2GodtVmoLmCbuAw1u0gnRmZhrB1fpM2GMu5xXzlP9Z4aXOSQxYa/dEaXn6D/8JQcwLxWJIlJzySWbhhrv6JnyElcizyqgQ3eJ/ECv/SS9lBiHHXBN/ZBVUuVWthL2+KJZ2A08lrA6T2tBxitNz3NqO4WJ3sTPbBlhL9zZl8kOSp/04LBwBMH/FFcuz7sGVvwi1lBzvNGt/JX/A6j8uT8JAcgD/QP1cggayLyWP+u2xQtxA4yaEZ6GLaTLL/DNpO3xDu2uELEDmndHiDJeLxq8oB/jYTm2+xGF7sQ3xwVnSqgwWJVjOiOELy0c8OUl/lKCFfhTMownqGLOMTATZsqZnJdMZ/nfZgXoXUEMXknafLTj1ZE4p7+jH7JPKb4/5bCV0pBrogir1ffGCBFKiibH+LJwyq9JWgSZshSLUBOIqORiba4gy/sYVCLVQma89bhKCmqBYApda8n4yJR9bqrBtoilSHSbeMOpKZ/gdfJg9jE/bf8GBadJjkZHDm5g7Ey2QgWqj8KQh6+6SPKWzEEioVZKGjvwGpgWb8q9SKs7WvLkWOKA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(396003)(376002)(136003)(346002)(40470700004)(46966006)(36840700001)(41300700001)(70586007)(70206006)(82310400005)(40460700003)(478600001)(8676002)(6666004)(81166007)(5660300002)(82740400003)(356005)(4326008)(8936002)(83170400001)(2876002)(110136005)(36756003)(2906002)(47076005)(55446002)(186003)(83380400001)(36860700001)(42882007)(316002)(26005)(9686003)(54906003)(40480700001)(336012)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2022 18:58:48.0436
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 62cdf517-2c62-4dea-fee3-08da70cb341f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT040.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6964
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
