Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 351FE4AC74C
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 18:28:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358172AbiBGR1I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 12:27:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343718AbiBGRXX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 12:23:23 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2062.outbound.protection.outlook.com [40.107.223.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3F18C0401D5;
        Mon,  7 Feb 2022 09:23:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uj7lRAIwk52SveB+Y2QxqSrYtpFbPViFoxehPbYVHpr3Gu6Ah8IMxl+so+uOvrapDPRxYKQ63ph0N+QVxHeTlUQmyKSOOOxUcfDq9gdbDS9y8wOtdWb7WVTREKahqQWC90oCTeRMUhCgSQRO1/xZGXPmdvZJqTFsI7iI3tH4VYhX+2Z/sLhR5XjOu5d8mlBw6hmk6DMBqHDWXPOdo2E8mgKW3QrTC6U4TldhwmoWVLJM1AaGl38UcMOpAjtASJ353JownsbrM+qk2WcLciQ5LxqLEdISLuIydGP0YcDhgADkRr4+uVqaKP+eAm1fn9iAcXiYjByyOeRMO4ovERWPTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q6yP+UcaESGvVDA99CJM19WVOqvMzB4Yg0hQqHcAhk4=;
 b=MPc14POH2llUe89XxxvVM1ABmLLdJlXl2c/BauTnDlpCor0nYWs38+87VzgAXdpbyfGbARurHfWtteOUoCBZU6spZhw9NVwGSIq63cjsUQc81ayJr4d9Mbk5yIHgLZWDSl+JsJUvhPPtC68oLyz8bSRkRtRSsk9LpYae11mxfDjT2pvJ8Udom0nrRWumKe4j06LQQlbLGuQl/cYp8wI41QLOsNhKsqRqaxgEEKUAU3l7/RhQGjBjnWjNVrc+mJa59atRBOXTp+vYcRjhUIe+v1Pc98sWQBmIiI2TgbI9e1u2FasTt0N6iFaEkHkm4NezT8yMrQhWRJZjFy+vzm7nEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q6yP+UcaESGvVDA99CJM19WVOqvMzB4Yg0hQqHcAhk4=;
 b=b0h09UcE96mJvogRF0EfpdmdwgsfSTsawws5nmZy+Nl2RgOVLfGCnfsRMZA0zXJ5lG9H1ZAzXBWt4du9Qk5Mv5bS+exLFBu1YmEiuBaZa4Dd/ltMRr8FS+TcJYyCnRgnLInNye1ertKJfCYbkCuN7/82/hbWhE2MBTo/5FblEM2J7gIN8blaReyPOxVWVsZLspVzLQ9+oZCTXNXfS+S0RKNEHeIYQNoHaRnxIY6QYUh39fiGWtcuYh6SEO8198OW0sZ0nM79sjBt+y1rv80GyH2RY7jFE36NKRCGVestaK3AYVAZQhSZ2hiSXTSPbk9LkztDYXiH/vRN9KM1qSgeSQ==
Received: from DM6PR18CA0002.namprd18.prod.outlook.com (2603:10b6:5:15b::15)
 by MN2PR12MB3360.namprd12.prod.outlook.com (2603:10b6:208:c7::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.16; Mon, 7 Feb
 2022 17:23:20 +0000
Received: from DM6NAM11FT024.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:15b:cafe::9b) by DM6PR18CA0002.outlook.office365.com
 (2603:10b6:5:15b::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.19 via Frontend
 Transport; Mon, 7 Feb 2022 17:23:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT024.mail.protection.outlook.com (10.13.172.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4951.12 via Frontend Transport; Mon, 7 Feb 2022 17:23:19 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 7 Feb
 2022 17:23:18 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Mon, 7 Feb 2022
 09:23:18 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Mon, 7 Feb
 2022 09:23:14 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>, <ashok.raj@intel.com>,
        <kevin.tian@intel.com>, <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH V7 mlx5-next 03/15] net/mlx5: Disable SRIOV before PF removal
Date:   Mon, 7 Feb 2022 19:22:04 +0200
Message-ID: <20220207172216.206415-4-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220207172216.206415-1-yishaih@nvidia.com>
References: <20220207172216.206415-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 450b0770-fca1-4102-caf1-08d9ea5e894d
X-MS-TrafficTypeDiagnostic: MN2PR12MB3360:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB3360D089A15FCD43279217FFC32C9@MN2PR12MB3360.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DIenpFI/CTDCdwRbdHdLgVx490zXKSACm/DMO6F70MTzsXriFwu5RZkj+oZIVp34ho14jT+k2sOqeRUtHjOwFl8oTuI95GtIE84yrB+kUiAAL6TgkIjB9Tb6hMu1hmE6YRVCJmop7rWIfQjngHAdaC4aKPtNvl1Aofm5pZmViG9Z9c83sxlZse8Ei1IUgcK3Ke44CoYrTeh5hkqGQWMErrW/U/Sti/hp9wdT9jhPPAYFt2gVZKgCmTXXeSmdsVHIblymXC2dc+ogDNFaSVUiQfimz2Og4InmzXF49LWirzHS4Z603FTdil69B0WYFRUXhXvBS1ZuatF6Z8whPDbOgviU+nqqfqCYzlmuz/0p1SAfIHwCf78inbG7wfzQIrQOMMkZyHDyFxrFlS+PT6lwVWY06AgZLSIbWdSA3j47LUont24cYL3NVnxsBQur+PVXlbXvkvdpctzB8npAHwkVN9wi53KrAPk2+6W/xIjemfLgPsmwI4rqyY2V7msn1W+Ol6ygXqBoljwm83l+V8/LmaFoOTL8c+CTQhZ1wZTSshVF8MEJyo9+QfPH902JAb17+iJEzVry9uL9Ll7wsbYxqnfX4A3XJH+xJi3XSPnl4r1MuTlXg3E0rbgU+oZqlwP/ssB0XfZE/OXxwpxz0wEBOfF72JZXWF6mnB0V47fPnN4dTLKrTMrz0XeSyBLxYnAhe3FVEwFF52z5naVY/XTsrQ==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(36756003)(40460700003)(36860700001)(70586007)(70206006)(81166007)(8936002)(8676002)(356005)(83380400001)(110136005)(54906003)(6636002)(5660300002)(4326008)(2906002)(336012)(26005)(186003)(426003)(86362001)(1076003)(82310400004)(47076005)(7696005)(6666004)(508600001)(316002)(2616005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2022 17:23:19.9944
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 450b0770-fca1-4102-caf1-08d9ea5e894d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT024.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3360
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Virtual functions depend on physical function for device access (for example
firmware host PAGE management), so make sure to disable SRIOV once PF is gone.

This will prevent also the below warning if PF has gone before disabling SRIOV.
"driver left SR-IOV enabled after remove"

Next patch from this series will rely on that when the VF may need to
access safely the PF 'driver data'.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c      | 1 +
 drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h | 1 +
 drivers/net/ethernet/mellanox/mlx5/core/sriov.c     | 2 +-
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 2c774f367199..5b8958186157 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1620,6 +1620,7 @@ static void remove_one(struct pci_dev *pdev)
 	struct devlink *devlink = priv_to_devlink(dev);
 
 	devlink_unregister(devlink);
+	mlx5_sriov_disable(pdev);
 	mlx5_crdump_disable(dev);
 	mlx5_drain_health_wq(dev);
 	mlx5_uninit_one(dev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index 6f8baa0f2a73..37b2805b3bf3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -164,6 +164,7 @@ void mlx5_sriov_cleanup(struct mlx5_core_dev *dev);
 int mlx5_sriov_attach(struct mlx5_core_dev *dev);
 void mlx5_sriov_detach(struct mlx5_core_dev *dev);
 int mlx5_core_sriov_configure(struct pci_dev *dev, int num_vfs);
+void mlx5_sriov_disable(struct pci_dev *pdev);
 int mlx5_core_sriov_set_msix_vec_count(struct pci_dev *vf, int msix_vec_count);
 int mlx5_core_enable_hca(struct mlx5_core_dev *dev, u16 func_id);
 int mlx5_core_disable_hca(struct mlx5_core_dev *dev, u16 func_id);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
index 24c4b4f05214..887ee0f729d1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
@@ -161,7 +161,7 @@ static int mlx5_sriov_enable(struct pci_dev *pdev, int num_vfs)
 	return err;
 }
 
-static void mlx5_sriov_disable(struct pci_dev *pdev)
+void mlx5_sriov_disable(struct pci_dev *pdev)
 {
 	struct mlx5_core_dev *dev  = pci_get_drvdata(pdev);
 	int num_vfs = pci_num_vf(dev->pdev);
-- 
2.18.1

