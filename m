Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F3F257E416
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 18:08:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235303AbiGVQHP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 12:07:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235570AbiGVQGn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 12:06:43 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2067.outbound.protection.outlook.com [40.107.237.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C3B57391B
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 09:06:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DKFmuIbM8uXap77l91DSa9YiL+nI0rRbHJfs/2bSEC8jMokZoI1zp23r5Wt8IWGrlmcA1skOJ1f2c+xiR1sUIrow72FQQ9iaKsR9focwzlHFuEUL4Hc/T4b9vdKZIy79kyZheGzlElEp3X9uXDG/7UDq9KyOA6fWI6inSHtqKdFSkXSwugUVv5gkHUqo00bvOQh4td1DhoG2F8/lYn85y/egicqXVdDHlQ+AQRoKisjYLwbCtLBkfKlVu9p6phuLebyR7Lm7U2KX6jQS5Jap6FNH/yI7UbBRYoR5ewvVDtRHaPGDjW7/qiHI+f/rZpuppuK1kXdYhFq11gz3f0rOuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FWctVmD4tVpvQ1SE/KHWsXvWRoJt5zaWi9Y88mUzGcM=;
 b=IFs4nlcypzzSd7RVsbEtkbiFQ7Tdf+qWmzxZQhubaKNPg2Hg1VdRpGv2TEbjb8G97SI/L6GHNkhLoK7bL8dRW0CMpaFoRC3uveUFJbM/Jl7oQYSU+/1L/6KSKnbqfRwk5OtqfEtwldzdxorHNCsVGE4vb8AmiX8HgYCXpASrLndDxprakmxR1CUC5ihqTS5tXNwLO2sxCaU2CSNVvslUFvuT0IsKzusgpNM4Kivp4SwT7NHl4P6lV2aMpcTwrOSnJfgkzuAh2wd30MgHLU0bv0pfiBrQksrDlpHI7dA4Kltm7SXXjRND8r0oWLj3AYJ/345fe/j3VlxYmlZVZR85aA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FWctVmD4tVpvQ1SE/KHWsXvWRoJt5zaWi9Y88mUzGcM=;
 b=ay1y3eH0XtxcR/VYBClAX7g/Y43XgYU7icg9hhD6iN8uK/GdJfHAvoV4+/6Yy+64pWTx68KOnA+0KLfqizPN5Mxqb+PIdKO+fTZEgnhC36KGI3/9N3oCte1rPR9l4OauV4S5jnYjDf/pFXuaKVNWRH5bLMrao7rz2NO6jblhV2bNN58GBtB6hrS3lq8wGyT6Rigw5r77lAnv9BBv3+4aCExG3Jw7Cr91qLt4tU5fGXqxm2DyFMvi2Cjx3Ht44qqEKQA6RzQEcqXbvj6kZc9Al0z37KM7C31L5ks8YU2cfPZe3DRhI+8VL87cJZL+J5JG4AZJOMyLHhrPICRIVWha5A==
Received: from DS7PR03CA0219.namprd03.prod.outlook.com (2603:10b6:5:3ba::14)
 by MN2PR12MB4238.namprd12.prod.outlook.com (2603:10b6:208:199::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.18; Fri, 22 Jul
 2022 16:06:34 +0000
Received: from DM6NAM11FT011.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3ba:cafe::bb) by DS7PR03CA0219.outlook.office365.com
 (2603:10b6:5:3ba::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23 via Frontend
 Transport; Fri, 22 Jul 2022 16:06:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT011.mail.protection.outlook.com (10.13.172.108) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5458.17 via Frontend Transport; Fri, 22 Jul 2022 16:06:33 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Fri, 22 Jul
 2022 11:06:32 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Fri, 22 Jul 2022 11:06:31 -0500
From:   <ecree@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-net-drivers@amd.com>
CC:     <netdev@vger.kernel.org>, Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH net-next 13/14] sfc: get provisioned MAC address on EF100 VF probe
Date:   Fri, 22 Jul 2022 17:04:22 +0100
Message-ID: <7c6e6b2d70bd46b92feaedce80f637b671778448.1658497661.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1658497661.git.ecree.xilinx@gmail.com>
References: <cover.1658497661.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4fe1bede-8bfd-487b-b9c8-08da6bfc25d7
X-MS-TrafficTypeDiagnostic: MN2PR12MB4238:EE_
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G5XQGlgfLB6jhy6oHhvOkK6p2gYZbdzN+vttaQ8JRDtAhltm6ijqyFyePeB16+Z6xmbSZb5PT6E63/LjsTOuf+bPYGFrqmg5cP/jMtsL/jG8wViBdS7M5fUgULB1Gz38qqLbcBmNj9wgHii35fMOYTEKks+0qjVNrBZikNX4KJ5Hepoly7k0+4xl3Hzq1OMy15Pvki67gjuo811QO9KYdcM5gxi+NuUL6AwFUjJtmUBifP4l7ZqtvR1bG6Y8T43t23FRQBzguxGoxBqaDOObtREI8IcP0YElZmRNi0mWYqUJpQdXv9AIGsxkQVZeJ8Ou6VoXrh0DI51AtA2imHzPunDEIYQO9789Canqj6oiKEgsJjgBzvPiA0wKCTCz5NVMMG6XI8TegT73I7W5rnK/59r8IsS5oKEal8JhYhNAVjhbUdyn9fJktjrgUfEA9hTIQyWMGm3bPd5YJBO5eFXme09yZybSY6TU0aImyGgsK2ZwA+HvgUkMBynszdgBHXkTFKo6hGF97fM4qaJFtXHr+5zEcnmSD4Ci8tsRFIgP1VqXGMWnWguNLhOnVP4JUbTPZ0tlBZD4AJnM1486PfDS+4o1voZh5Uz8bJOFS2MjSaa3hrrsdG4V4fMZtpOr3DfmoOjtNIR6ZgIhc+xE0SgsM0NPQuKxNwaBSyESq0Ttf4Hz7QXHiTcBViHMhLiDemlXEccXAml5LllCZSD9YWilnHPnOnziHxMXdrMr650R5GMapvvu9JGi8MrwWFUE5uPUxndTSpO0or67edxai+Me91E0M3XV5gjLQ7vlsrjh0GtbKrcQrYBkv98dlYaA003PMlKkjtoV7XX9GRj7EqmGRw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(396003)(346002)(39860400002)(46966006)(40470700004)(36840700001)(82310400005)(110136005)(186003)(42882007)(6666004)(47076005)(336012)(2876002)(40460700003)(55446002)(9686003)(83380400001)(26005)(54906003)(8676002)(316002)(8936002)(70586007)(41300700001)(36860700001)(70206006)(5660300002)(36756003)(356005)(82740400003)(81166007)(478600001)(83170400001)(40480700001)(2906002)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2022 16:06:33.6234
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fe1bede-8bfd-487b-b9c8-08da6bfc25d7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT011.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4238
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

Move the implementation from the PF-specific probe path to that part
 which is common to both PFs and VFs.

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/ef100_netdev.c | 10 ++++++++++
 drivers/net/ethernet/sfc/ef100_nic.c    | 11 -----------
 2 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef100_netdev.c b/drivers/net/ethernet/sfc/ef100_netdev.c
index 03aba7bd59ed..0f7447858837 100644
--- a/drivers/net/ethernet/sfc/ef100_netdev.c
+++ b/drivers/net/ethernet/sfc/ef100_netdev.c
@@ -347,6 +347,7 @@ int ef100_probe_netdev(struct efx_probe_data *probe_data)
 {
 	struct efx_nic *efx = &probe_data->efx;
 	struct efx_probe_data **probe_ptr;
+	struct ef100_nic_data *nic_data;
 	struct net_device *net_dev;
 	int rc;
 
@@ -398,6 +399,15 @@ int ef100_probe_netdev(struct efx_probe_data *probe_data)
 	/* Don't fail init if RSS setup doesn't work. */
 	efx_mcdi_push_default_indir_table(efx, efx->n_rx_channels);
 
+	rc = ef100_get_mac_address(efx, net_dev->perm_addr, CLIENT_HANDLE_SELF,
+				   efx->type->is_vf);
+	if (rc)
+		goto fail;
+	/* Assign MAC address */
+	eth_hw_addr_set(net_dev, net_dev->perm_addr);
+	nic_data = efx->nic_data;
+	memcpy(nic_data->port_id, net_dev->perm_addr, ETH_ALEN);
+
 	rc = ef100_register_netdev(efx);
 	if (rc)
 		goto fail;
diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index 92908640a0a6..b74b0d60528e 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -1132,14 +1132,6 @@ int ef100_probe_netdev_pf(struct efx_nic *efx)
 	struct net_device *net_dev = efx->net_dev;
 	int rc;
 
-	rc = ef100_get_mac_address(efx, net_dev->perm_addr, CLIENT_HANDLE_SELF,
-				   false);
-	if (rc)
-		goto fail;
-	/* Assign MAC address */
-	eth_hw_addr_set(net_dev, net_dev->perm_addr);
-	memcpy(nic_data->port_id, net_dev->perm_addr, ETH_ALEN);
-
 	if (!nic_data->grp_mae)
 		return 0;
 
@@ -1168,9 +1160,6 @@ int ef100_probe_netdev_pf(struct efx_nic *efx)
 	}
 
 	return 0;
-
-fail:
-	return rc;
 }
 
 int ef100_probe_vf(struct efx_nic *efx)
