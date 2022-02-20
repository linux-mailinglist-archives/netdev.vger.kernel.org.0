Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 331BD4BCDE9
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 11:21:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243514AbiBTJ6y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 04:58:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242828AbiBTJ6t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 04:58:49 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2065.outbound.protection.outlook.com [40.107.92.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 434E154191;
        Sun, 20 Feb 2022 01:58:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ly15qkBI9CofmgpkhyelxnYze0ib7Y0ygpPpB3z1SfjCkxfOHoG47RBtYM/U/kSZq81ykTGVJlbNxZdgeppp3ltUNdbUKYqKghXGBolmN5qgF1qVpADLpo+1PNZzGRgYqEVQK3ZeEzFxssmlQUhT2CZ6LPIlfodz4CjD8xC4ZeQyTj8RnMXUjlti1dlzLVLcxhCksrft3LrFGeDE3gkW7Z7EIQs8sjjqKAzihPjNlOv4snAsriSBjpzCtCBLUnX6Th2mq64Rbin6bKL+Us2AEcw0IQmRIXY88XPcqLuAdYLhL5ZdS5ZJYNmYJbbS2xcqCkmGj0/gDeYVD3IgEPOfdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eawxF+jFRBAH1P9hWq5BE145QVmYPfYNp1U9MJCuY0E=;
 b=nN0ef54ECo7baQRRlsH1Itjh7AjD6FoYUtgvh80KuakMH1zC2MRrh5pxJWjrJefRUtQkKFGKkcXNXbvdy9u3Ubtltt2CtQ7HCvUFFMii5uzxecT5Kkf/9JimHl8i7XTDNO/nsqM8sY19dCJGbyG9mQYgY4hTZ4Cfl79SLx7ZUNCpkLzKXV/fSDurVcAfUAm8XaY3dsd9ujQaFXflV7ttxGvKOedLXE/8YAcl2okTQPsYW29I9aOOiqMFupTLdmR/Q4f5HxXSmxbzrcJlIEKh7xeFRgEakDUFShxk56VpkGL7SKd9/x3elEMjRYPfsFRNAgDNz/BSlC6Qtxhs+LXUDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eawxF+jFRBAH1P9hWq5BE145QVmYPfYNp1U9MJCuY0E=;
 b=pMmGLacMazbYOQFWlk0JTjZK+W0XRWGOBQikQHT2ZSre3QTERdj/nXou/Rf0+5xFZTFHjpyq1FftzMSB/iAg//mtUkAqPYnHxrWyUl1MvRCB9CRWz1NHa6oRzQCg/QvCNhldgMaOxBuKMVYqBJb4mRyVlbf/eXtAIaXXo4ibY1iGGbMusyclWZZSEMClvQ6yaeUXLJcw2pEVDdGRW94gcQf3y+E/XfB3FWmL+adOQXps12CyPo/Nm5mHuGhdV3aTrHWBitJAoxDYNEmdwc6pUaBW0CJRLGtIuFCCugCh8bZgJu3EcKEF/vuJsnoJu3XGNH6ZLbG7EtP6S5sF1KfkmA==
Received: from DM6PR08CA0061.namprd08.prod.outlook.com (2603:10b6:5:1e0::35)
 by BL0PR12MB4723.namprd12.prod.outlook.com (2603:10b6:208:8a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.24; Sun, 20 Feb
 2022 09:58:27 +0000
Received: from DM6NAM11FT013.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1e0:cafe::68) by DM6PR08CA0061.outlook.office365.com
 (2603:10b6:5:1e0::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16 via Frontend
 Transport; Sun, 20 Feb 2022 09:58:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT013.mail.protection.outlook.com (10.13.173.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.15 via Frontend Transport; Sun, 20 Feb 2022 09:58:27 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 20 Feb
 2022 09:58:26 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Sun, 20 Feb 2022
 01:58:25 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Sun, 20 Feb
 2022 01:58:21 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>, <cohuck@redhat.com>,
        <ashok.raj@intel.com>, <kevin.tian@intel.com>,
        <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH V8 mlx5-next 02/15] net/mlx5: Reuse exported virtfn index function call
Date:   Sun, 20 Feb 2022 11:57:03 +0200
Message-ID: <20220220095716.153757-3-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220220095716.153757-1-yishaih@nvidia.com>
References: <20220220095716.153757-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c040502c-e9cf-4e3f-7511-08d9f4578a75
X-MS-TrafficTypeDiagnostic: BL0PR12MB4723:EE_
X-Microsoft-Antispam-PRVS: <BL0PR12MB4723B32F2F6BB30575F80992C3399@BL0PR12MB4723.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M4JQGcXB2quwuUfti7roEJ0T0xNEAI2AlHUOjioZERj+fVib8k3q4wh19OF9s3gKYe/uE9cNgmrTxA33E2ghQmu8adKI2rYYd1obiynHJWvTzf8eWmgHoLNYVUxoKxYcDn87UsmZoNfCR2kJG3vUL2dMXmfb2yrEp3Up6KHDxIqPFCt6PS0Q0KPvhkVzXZCI5SkRilDpee7xXj511JeO7JoIlz0cnKat+UyMPGEkLKLXJgFzu+id+pcP0GSK6lESZOSh14Jw2H3Nu54w7KbnXwyg9LhuKvyIxszDEQ49i2NNNSgyvS13ECroK9ExUbuylgdyS7o0y+Vt6m5QWl3U4x+LYhXhIU162au5ikS86xxlM/Je8EAPaMFkjmE8/f7CZF//oHDXPIlpuGsOmPs/+7TNsq9BhInltlpaHRAEbJGKjJs9fpBzQJ3gHK3qqK05xM0GWlfi6qaTKsXNjQhfMjVlDWmFpnSZgWwf1KG4JdFfk2nwTiNm9IoBWnjAbeqbIMGQJ1fQVxRn4JGKhmW3L2fY803Shi/zNNnOx08z6rV48XzDv1owJsz0Eh/V1XQqZ8U9BZe57i5Tx907kqgiKnluAm3RGMZFLbHo/YoS9iSeGTGPdgkwlN2vvds4eNqQ596O7/In+MJ4kUtimMWV9CVrAL4YnAmf9pm5YJOXgkp0qC9C7C4VHCc704kpQhJwI87Td9jfz3ojEsihzRhnog==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(1076003)(81166007)(356005)(70206006)(70586007)(4326008)(8676002)(508600001)(36756003)(83380400001)(6666004)(86362001)(82310400004)(7696005)(2906002)(316002)(5660300002)(7416002)(40460700003)(36860700001)(186003)(26005)(8936002)(47076005)(336012)(110136005)(54906003)(426003)(6636002)(2616005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2022 09:58:27.0671
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c040502c-e9cf-4e3f-7511-08d9f4578a75
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT013.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4723
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Instead open-code iteration to compare virtfn internal index, use newly
introduced pci_iov_vf_id() call.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/sriov.c | 15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
index e8185b69ac6c..24c4b4f05214 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
@@ -205,19 +205,8 @@ int mlx5_core_sriov_set_msix_vec_count(struct pci_dev *vf, int msix_vec_count)
 			mlx5_get_default_msix_vec_count(dev, pci_num_vf(pf));
 
 	sriov = &dev->priv.sriov;
-
-	/* Reversed translation of PCI VF function number to the internal
-	 * function_id, which exists in the name of virtfn symlink.
-	 */
-	for (id = 0; id < pci_num_vf(pf); id++) {
-		if (!sriov->vfs_ctx[id].enabled)
-			continue;
-
-		if (vf->devfn == pci_iov_virtfn_devfn(pf, id))
-			break;
-	}
-
-	if (id == pci_num_vf(pf) || !sriov->vfs_ctx[id].enabled)
+	id = pci_iov_vf_id(vf);
+	if (id < 0 || !sriov->vfs_ctx[id].enabled)
 		return -EINVAL;
 
 	return mlx5_set_msix_vec_count(dev, id + 1, msix_vec_count);
-- 
2.18.1

