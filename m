Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D6C158464E
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 21:33:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229436AbiG1S67 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 14:58:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231383AbiG1S6r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 14:58:47 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2051.outbound.protection.outlook.com [40.107.237.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 289497645D
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 11:58:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JdfbdYaU6CW9Llhe1wG+0jVKaXTNeIu/WEyItnF5UJotQ17ASlAdfiotynNoXFcUMZir43uiGeVaNrS6pTtRmhQHBM3tNWz8AlO79Dx48PECuxTHLcnZrKG5zGHDA978KE3fIXRH+Y1cHXncubrSuXNybQ9bwDHorG7QdtXmG8w432aetsNCHsztgN3lnYSTzrggQH2TaZ517wwVe+b9Hz3mQDwcDvqE1s8d67BS7vbBzKUDjAqn4ZvzhkiD/rT774hNls/XW1MuxH2fMZC4+2kR0tYerq0p/Mk1tb2oyXO2TwHpHkJKX4kS8hLGKgTxVWPn3jub5HOd9JGLYARodA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XfdqkurY77O25VPVcelRdCW/iPWMGoqTJUW5RIBF9cc=;
 b=Mz/AqSX/kxPXo8Fro4i7g1OxhZMxByb4wE91bkM9aEq0mFcxseA9rtxSH1C48uA/ZQlHqMjrL8Mv3/sRK/mriDqXleZVRTbsjnuO2LPas5et5qFHFWTcsU0zrJUa+wEDuVz/01MAuqx1DtZL0mbne+Ov5YVzaCvOstYQ+7nqIFDM5N8OFPJC9UW/qz4PjYpRj+lsNXJbRATg3PmTWJXT5wk+EqPlxUwzPGYA9Qql++/ingFe1dK3XykwUGYy8xv4MWT10smGZY+lPcId2FKBndtmJyIlvSsH0AGxL73w7uPFgMSWchmX1W/6Q9ylOZqPRNgvUmkAfYeTf+Z+cHp2Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XfdqkurY77O25VPVcelRdCW/iPWMGoqTJUW5RIBF9cc=;
 b=t7st1mEXY0r9CBLAwyoYw0Xf09C3eYxeAzUHSAA9BzT/vfN+xEpmINDlUnQthiS1WbIVv0+Pi//kharnrP4uCNdi7LDC2c52h+BQ3bczpktaxran1IDuzc1at2aAx8eQYdktWsH2CG0LWm4qAW3UtaF/dCaI+K5Enz/lQA3ozBE+2XfXsbzt6W3NYhAuZeQW46RREij7ZIyhubvx0Q0Ae6+wRqV0DPZP/OzUXlhXFrkUvs/tW9XyL7o8XNp4xC7PJ6+JxoOpjRHyanLNrmtmvN1bkvfhvrvb3IwXpxjKSKxciKe+7qEDgr4rUSfpeScY8pg8lW2GQ/qgQhfbyl6gNg==
Received: from BN1PR12CA0020.namprd12.prod.outlook.com (2603:10b6:408:e1::25)
 by IA1PR12MB6042.namprd12.prod.outlook.com (2603:10b6:208:3d6::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.25; Thu, 28 Jul
 2022 18:58:43 +0000
Received: from BN8NAM11FT020.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e1:cafe::d) by BN1PR12CA0020.outlook.office365.com
 (2603:10b6:408:e1::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19 via Frontend
 Transport; Thu, 28 Jul 2022 18:58:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN8NAM11FT020.mail.protection.outlook.com (10.13.176.223) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5482.10 via Frontend Transport; Thu, 28 Jul 2022 18:58:43 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Thu, 28 Jul
 2022 13:58:42 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Thu, 28 Jul
 2022 11:58:41 -0700
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Thu, 28 Jul 2022 13:58:40 -0500
From:   <ecree@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-net-drivers@amd.com>
CC:     <netdev@vger.kernel.org>, Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH net-next v3 04/10] sfc: determine wire m-port at EF100 PF probe time
Date:   Thu, 28 Jul 2022 19:57:46 +0100
Message-ID: <ca4b9c68480617f8bb49d5489cef14f9f26c7e7d.1659034549.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1659034549.git.ecree.xilinx@gmail.com>
References: <cover.1659034549.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 71cde54d-726d-4e06-2ca3-08da70cb3123
X-MS-TrafficTypeDiagnostic: IA1PR12MB6042:EE_
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YpSY4D2TNlj6ZQ9f7PZunFyuIveW8rM1LCqV/AIxxXx5sDbQNre7bAT+SVNjOW1NuSLmgHiUYjQ6M/GDQ6+kq5TTBrIzzUjDb/Xy52462upl57JleSe16o811+nzAne/QZbqi9cgOrtsJnje7+frPdK+sYEDY+509Dnlu3X9rXkHbYSHbjLLlhJHx97y/DSS301tRNEUjFwHALHOCc2gcQFE1CWVhzngA8D+xISeRWG0q25QvtUkgLPzQlFybtROkvt1mjhnhaEweh51iyzPj2IJFqiMiMBmnce36vpBUtXNEEnQay8zd2ESC9vdB4HJfvrQ62K+2GmGzf6ICFeH+5fiuavBfjDcg7ljXZogpUVB9X3FzN/FtmUMW3PgPM0VrdiPRVVGUfrmcVlpx0F56gsQLGO7Kf6Y/jZ9KoEoy3vI4zWf/W6LugoNjmaTJ+PqyF+QleYYFPull5OY2rv3C8gOLewfOGXVJEDUYMO/goVRkmJApGcdNgSjEeIEddho7gLnF3OrdcJlOzZmBxKyrM8bMnVWbJ+jFtr3tcDWyUTzz1bKBIpindwKandzOpTqlp8eJYjy8MZkniMtEaaWGJHpxhAtnBU/7v4pdWGCggM6rWxW72VF4B0yzQL9TwPI8/3tzkRP5HH5NHiv9LSn/w7smKUQXBTjvitVyDVn4XL0OdUEM8ImFV/aQKvfPWZD1jNYPit9VTKl4kYWuGpP8OFGVvWx9TEsyyDeATKfGXAyq5xE1ExWxDCTa3hz2WV13QKbjLAaRZ4GOAfmzJrmJHh1yoLhfOs9eHQ+zVQaF1DU4HqiaGBSZSRDaKe1DH0mDnslVL1yQtsfmSmxeLrnPg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(346002)(136003)(376002)(396003)(40470700004)(36840700001)(46966006)(70586007)(40480700001)(8936002)(9686003)(82740400003)(26005)(36860700001)(54906003)(8676002)(70206006)(81166007)(110136005)(83170400001)(478600001)(41300700001)(42882007)(4326008)(36756003)(55446002)(2876002)(186003)(316002)(82310400005)(5660300002)(40460700003)(336012)(83380400001)(356005)(2906002)(47076005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2022 18:58:43.0782
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 71cde54d-726d-4e06-2ca3-08da70cb3123
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT020.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6042
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
