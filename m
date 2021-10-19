Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 701AA43342A
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 13:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235407AbhJSLCL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 07:02:11 -0400
Received: from mail-co1nam11on2080.outbound.protection.outlook.com ([40.107.220.80]:47073
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235388AbhJSLBz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 07:01:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E3dgd43EFCnSM+7fM+lxMcWMVmKb0csnqL5hoHRT6so94UXAyczA+Fe1tgbFriUu2vfBXKUdBiZuTOH67hM0QnJhwTCZ4ILTc6QpPruaz1kwuobpjvOSbSz/jlL0g28Yi9bu3upbvZ9NYSfRLpcjfZADwRbszrD3Vds5w2s3RZer18nHiASkIF32BrVOO6TH73d94kAxwPAJuTlQKNpyqffFUbhEGaiZE0ytZI3UcZWEgoma0hft78biaKBLQfSAHscPatppn5Q8yKS/aryWigG8Az8OEgHDZpJu4woi9B6SEPYxj0zDnDwUAfiuM94AfVIokbazXBat0WMM93autA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DOcFU6eSD++XS6aHs3kXEvGIdsHFeir924wVdQSptkg=;
 b=gK5nPEE8moLltUqWlTvNlhm18fOP3NhxOq0xIo1oPyKhSvk1Wg7jh/AM0ZQ7I9ZE9G8yopUb/RKLsa2KbckSfjIf0ifNC5OXZ5yhzweMNe4ItefB0D18d3i5ls5gUhnlwMraw/uufWa+5z39+u5pkbsqgAr3iqa2Lf+Ybr0UZk9PKV34bltsm+Ud+X9F9yxldwpypMDdpm5J0DSNTbbXJtGXO8meSLv+lE7oz1B+nzYF205pVz+xglYMOg7Kjv5YHYlvLHpI5jkJshzSL9kWButMtIwpDtONHKO+b+tfzd7ki1PRUX/OB/SzvZMmcEbE4jgoa3tcnx6WCCm3aRY0BQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DOcFU6eSD++XS6aHs3kXEvGIdsHFeir924wVdQSptkg=;
 b=MYnsdO30GLQeqBtmVvOO4FC2VDC+7ej0TN/SGiL+IXpeJbJ4RTN6TmGKcf0Z9mWJX2nJ/XPj3eTKxVXbh/MPyU5O+XPnLH58imtkIVXbzN4klS0+4OpUwGxgv/eGtryVeLA89HwXj5Tz3CCySqer91WWqibo8UxEgf85onNqq9IO8qGo4ocGDJXq2v6h8zHLi3xtBnCnuO89xRWvgK6rNTolleQGafz5SljjVdejATUw0sDFWYiHZ9DjbMEDwOKejAL75x/VxqluO/FiRNFDcQgt5wRn8Qlbx92t0x3UJlX/wrwXYFrVulX4cLQb68riQ2nHNFqOt/UaQ52df1TC2Q==
Received: from DM5PR13CA0034.namprd13.prod.outlook.com (2603:10b6:3:7b::20) by
 BN8PR12MB3187.namprd12.prod.outlook.com (2603:10b6:408:69::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4608.16; Tue, 19 Oct 2021 10:59:41 +0000
Received: from DM6NAM11FT062.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:7b:cafe::d9) by DM5PR13CA0034.outlook.office365.com
 (2603:10b6:3:7b::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.8 via Frontend
 Transport; Tue, 19 Oct 2021 10:59:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT062.mail.protection.outlook.com (10.13.173.40) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4608.15 via Frontend Transport; Tue, 19 Oct 2021 10:59:41 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 19 Oct
 2021 10:59:40 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 19 Oct 2021 10:59:37 +0000
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V2 mlx5-next 09/14] vfio/pci_core: Make the region->release() function optional
Date:   Tue, 19 Oct 2021 13:58:33 +0300
Message-ID: <20211019105838.227569-10-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20211019105838.227569-1-yishaih@nvidia.com>
References: <20211019105838.227569-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9e174a3d-2f5b-4de7-dd36-08d992ef8d40
X-MS-TrafficTypeDiagnostic: BN8PR12MB3187:
X-Microsoft-Antispam-PRVS: <BN8PR12MB3187EDABAD031EC6F1A6E808C3BD9@BN8PR12MB3187.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DlLbkfjqLccmtm2ADlDsifX6AESuilpsmVvvGl4S1cqYw7/LsR85d/ot+tFXn0fSvvwgNvPxFJhTv3vnUZt716zvQvoi448PgEtdRzlvCOwnQlnQJbQpLl7TfhFb+Ikn3PV6t98tS6GIb5ikg2wOz8JtC4xdC8BJIQG1O4pG4bpzHJCW0XTg9O0WeWk9FaCQQAdCx/Yz08f9kX0TeKW07zPElUbfdKzrNG7oJs5FQbczRAmxH6vhnQdFQ4HYAO3tXlJZeJKL5Lve4Yjg99MiFEFW85H/xhBFa1/0aRcb6viQ5TyHxkTRxj47Kv7WxDCylmptqJnUv/ONJFZNN39UNGA6Bvlj0bOW4tFoNqj2bDIPDMueOWDRput3YKbA0/nPDxg5A8Tg5iB7PMmcQ2tVoHgMP17TEZmpvOzOB9e2yFjWLrO4BVGuBOBXgge9wzJ/R7BAuGGjDcySodUS29tKh9Wnvn0pyuqYyLTDcBL8mpFIjsCoir37F98TnYgKwyfGXktcZ0yoGv3rqrLLXBuByW0b1q4tRgkpbJDvDpetqiWRWjZ8EnG+2ehBrKUvW89VR5sOPYiW7PvjnJsqPrPUAPcS61qPCTlAAomhDlwvmt/HqD9hE4m6xBhTk+ezYQeS8PlU0aJC3uc9lCaiYq+OZtwODACEXiiz7jZi94WcrlIW84OUtV4OVWN8nvxCtuQcJppjwRBBLjU9tllqawGzzA==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(4326008)(36906005)(316002)(6666004)(426003)(47076005)(6636002)(110136005)(83380400001)(5660300002)(36860700001)(36756003)(7636003)(356005)(54906003)(2906002)(82310400003)(7696005)(8676002)(186003)(70586007)(70206006)(508600001)(336012)(1076003)(8936002)(26005)(86362001)(2616005)(107886003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2021 10:59:41.3213
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e174a3d-2f5b-4de7-dd36-08d992ef8d40
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT062.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3187
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make the region->release() function optional as in some cases there is
nothing to do by driver as part of it.

This is needed for coming patch from this series once we add
mlx5_vfio_pci driver to support live migration but we don't need a
migration release function.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index a03b5a99c2da..e581a327f90d 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -341,7 +341,8 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
 	vdev->virq_disabled = false;
 
 	for (i = 0; i < vdev->num_regions; i++)
-		vdev->region[i].ops->release(vdev, &vdev->region[i]);
+		if (vdev->region[i].ops->release)
+			vdev->region[i].ops->release(vdev, &vdev->region[i]);
 
 	vdev->num_regions = 0;
 	kfree(vdev->region);
-- 
2.18.1

