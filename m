Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19B5335B274
	for <lists+netdev@lfdr.de>; Sun, 11 Apr 2021 10:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235124AbhDKIhR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 04:37:17 -0400
Received: from mail-bn8nam11on2052.outbound.protection.outlook.com ([40.107.236.52]:13857
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229804AbhDKIhQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Apr 2021 04:37:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oPhs5f1eZxWnQmVdrl2krMY1R0gsHAOdC7G8rZamUBICWLN3nSWUsFK4KMOvSsxCPOJLj7Xf+O/yu9l5UXr2HS4xNXvGUfxRa8PY+viBPTrENDhaYmzgk/9OVutJrg50ahIt+Xq6h21P/xvv4R+A3/MDKsBkNRl92GCHiM/n0WNj71YQXxQx4q/t7+2x1CznAwr++GH9ZzvnvMbq5XkwTkoPVv2Mt9j7Ip2ULnHevkKtu4OYjDzi9dponb28rmCDlS1kCMSdcoSwqPL78ktokNxph9pRuyf5uzIiRkgqIVR25LMBSSDNQR/uTe+dR2GnjK21d4P+cNzWAiydDv3kmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5MOLiVdrMY8WF1rh+D5Fh4TSfrTsvVw4LQTaZ/5Orfw=;
 b=Kksbv7BDGnoJRyW4lSaGh73pnaDvONosRDyT9iaIMCgJnh4BFb+w451e9tGc7HhSo+kjo1HCQkkXS4fyU+jzrCEts/Av0oal3ZtjPbKVxEsZkE0ugp5QlueFEYGtemxlOVOHvSn45BJIPjmirYnqVBkyYDOLc7OcdPsYyAWzEtHCuA7sq/pwprSHVRMiyPS0uI0sMVRvKleBWuhXQQUFJBbyP9Af/7UvqzN22Rc551UhPBQYhTmOfBmHP7mf/dq1sq+vvWdKr/WAEssx2vhZ1EnJRFu5wlV0qqcuOz2aiz6+bhPerGKXzHusrA8+zb0iSIjtmMYxZvKDsHsX3IWA0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5MOLiVdrMY8WF1rh+D5Fh4TSfrTsvVw4LQTaZ/5Orfw=;
 b=VmRhzHbjqDfxgJ3IF3OyBIAuoA5ssrykS97epYRrunn0hIhs7NaFpQU5/9MHgwQMnLvFzy6yVrAuqKljsXv+iJlPH28YVyqoursDaDquY443shZoVIboSQHfnCAsSWbqYzkgnDKCQkrI6Og2FJabNckgaXtlfUfnKPiUTy33ukgPnQ+ImHjZ9RmFIGP1SErXRrInbMbdKbnhjB2u3OthNgHPWxfenwqBVjPSI/xO7M8Y+ZpUSVTR4FeVWXaWs4jPICVluctIz9/sE9Ghnl2DRBMAHSKuPzRAAiqFEmvzHIrK04BTn6IMGVMP8A2AIkmiTPMq1AEf3o5+yn5y7/EHPQ==
Received: from BN9PR03CA0395.namprd03.prod.outlook.com (2603:10b6:408:111::10)
 by DM6PR12MB4043.namprd12.prod.outlook.com (2603:10b6:5:216::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.22; Sun, 11 Apr
 2021 08:36:58 +0000
Received: from BN8NAM11FT009.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:111:cafe::b) by BN9PR03CA0395.outlook.office365.com
 (2603:10b6:408:111::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend
 Transport; Sun, 11 Apr 2021 08:36:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT009.mail.protection.outlook.com (10.13.176.65) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4020.17 via Frontend Transport; Sun, 11 Apr 2021 08:36:58 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 11 Apr
 2021 08:36:57 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 11 Apr 2021 08:36:55 +0000
From:   Eli Cohen <elic@nvidia.com>
To:     <mst@redhat.com>, <jasowang@redhat.com>, <si-wei.liu@oracle.com>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>
CC:     <elic@nvidia.com>, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH] vdpa/mlx5: Set err = -ENOMEM in case dma_map_sg_attrs fails
Date:   Sun, 11 Apr 2021 11:36:46 +0300
Message-ID: <20210411083646.910546-1-elic@nvidia.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b344d8d8-277c-49ad-2d95-08d8fcc4f882
X-MS-TrafficTypeDiagnostic: DM6PR12MB4043:
X-Microsoft-Antispam-PRVS: <DM6PR12MB40438D597B4134CEFDF904C7AB719@DM6PR12MB4043.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:398;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r/pF6/TMsS4xHr96YZt/LBEtmMk8e3F+whr9b8zLLWvyjLKFCXiagXH3ZiPtBUribkdjkSy4GKr7v/LszMnafaROdmxgj0jUFhHZU3aGAnUiUVU/G3b+5y3hZGvHECKRRMP5OHoBf56FIxyAPacqoB0Qlm+F+7aZrmVO4XKktWEMTAKFi3rmUieLxLelcIQrvIFr2qpXDbcLdz3HlVPjTOM3+jR2kR60hVnUAw8vxNl9zkCz9lbm2BjZGaMaGcRCXDoBvvSF9Vmag0eJnYrsk2uRPKajFpLa/X5WKARW4K+wlDOtXye7Tqr/7LqISpnmuTdB+FUNQYPOneXzCwV7dXhTFhzfdxEnf41nibRbFH56LxhEw+B9EBdN2W2GtLQz6RmzxGSjWqKwiPFwOyjWk/3Ab0/RAKH0dE1oBp+K7wP8sE8mRdrX1HcKUtIWuNlWdTMBuXgudHUHZv4F20TGz+T63f/n0gzcstWuOVexVewXQepQ3IzUYCyrhTaPvyQ7IsJV+nqWHiVAgYDDoMJh/F4+C2txUf0WRB/uycBYu6hddDKlE/pk1/IFlvDs6ntyQikqHtgu09jFTKTx+6+C0m2UZoKt74N/BHH2epFrsH5ayb/iDSb88ppL1LY53PVF0+PBnaKY0RDiy9va+LzSariN+zvzT4t8ssCz59RllTs=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(396003)(136003)(36840700001)(46966006)(36756003)(6666004)(82740400003)(83380400001)(426003)(2616005)(82310400003)(4744005)(4326008)(356005)(54906003)(186003)(2906002)(7636003)(70206006)(5660300002)(110136005)(47076005)(26005)(7696005)(86362001)(36906005)(8936002)(8676002)(36860700001)(70586007)(316002)(336012)(1076003)(478600001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2021 08:36:58.4166
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b344d8d8-277c-49ad-2d95-08d8fcc4f882
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT009.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4043
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set err = -ENOMEM if dma_map_sg_attrs() fails so the function reutrns
error.

Fixes: 94abbccdf291 ("vdpa/mlx5: Add shared memory registration code")
Signed-off-by: Eli Cohen <elic@nvidia.com>
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/vdpa/mlx5/core/mr.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/vdpa/mlx5/core/mr.c b/drivers/vdpa/mlx5/core/mr.c
index 3908ff28eec0..800cfd1967ad 100644
--- a/drivers/vdpa/mlx5/core/mr.c
+++ b/drivers/vdpa/mlx5/core/mr.c
@@ -278,8 +278,10 @@ static int map_direct_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_direct_mr
 	mr->log_size = log_entity_size;
 	mr->nsg = nsg;
 	mr->nent = dma_map_sg_attrs(dma, mr->sg_head.sgl, mr->nsg, DMA_BIDIRECTIONAL, 0);
-	if (!mr->nent)
+	if (!mr->nent) {
+		err = -ENOMEM;
 		goto err_map;
+	}
 
 	err = create_direct_mr(mvdev, mr);
 	if (err)
-- 
2.30.1

