Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5313433410
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 12:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235179AbhJSLBm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 07:01:42 -0400
Received: from mail-bn8nam08on2080.outbound.protection.outlook.com ([40.107.100.80]:63969
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235252AbhJSLBe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 07:01:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SolwTWCne9TDjGsxJJQu1JOlCpTNvkjy4UaSI0TkuSckxjemk0267U+kalvNf9zxN1x7eIXGMjxOOOvYCRIK8G/++jqkrCUqn/KTaflIxYgcdM9IdrDfWXk8pazJCK7hVhJzQQVxCOjzA/mtJv5f3OPe32JvM1pC51e+kmllj+6t72/sLYxf2+Aq5cSJzKkobB9I8QuphJYTNtRu9u28xArWjZP8jfQFAWzeTim6Y1gM6qgpmcb/wnIqNy6H6HHDGPVbyGPAtEoWl4JSY8g4qS8y74HAeiIDLZU8ldsZEmHDMAHQM8WaNNyRIRJ+uwsCCA+bOEKxsmscDxZmqQjrkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eawxF+jFRBAH1P9hWq5BE145QVmYPfYNp1U9MJCuY0E=;
 b=UuoIsmC52MJmg+MdlxDRGG/Lt1fo3cTCErLU0RYlGs01wYXnZ66SnRxIF1EZ4T5I0/qujMCzqsNgoOd6sRCJoBFuQSN2hDcBQlIgX1A1NwAfO1p80n6Sa04B3w9XIesQOaq8BVj1NMX3Gg3SdH61OBvFwp2lwD2+CmD6aJS0jC+zGoBs0Hpza/sc18Dpm67WN6/PR00AJ7ZKa469nzWM1Pp+hDb/p1dfTTh3T28Kfj4a+0BTvJ7njqfYoYBSMwpq8xs34z6g5CuBjf+JCrvZ3eK6F1zTkpgMtjkUdd9g5pMhi5KQWt00uKDrzXXqIIGA1k0INaSuiu+Jg2Qb3Ab29g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eawxF+jFRBAH1P9hWq5BE145QVmYPfYNp1U9MJCuY0E=;
 b=qofYD30VHhbrNkCgl0CvGSyXxE6LfQjeT4ePym/WCjKtVRt7oHdNbjjVCV47cvxko8A05j5XrBjcqMjWNpYxj409a9sK9iCpM5qEzFAsX/LPUNbfbv31bAJkn09EphpDUD5e7C38zROJiJlzRj/WhS+hqM21MeuFrSRl226XACYVbzQzIx59JX0I54dOQBSsGLehhRvexad7/tf/aKz/vUkDxBySJvn1kogzlQSp0rzXQC5V1a2HnhUzwCvUXXQAbrlp92o7FazvV/D8hvTvaooY9yrqz6CuG4tREfZVYamCB8gCtteNdo55ivWjCDVKVLhVGbe/PSS9a1YINikNMQ==
Received: from BN9PR03CA0389.namprd03.prod.outlook.com (2603:10b6:408:f7::34)
 by BL0PR12MB4849.namprd12.prod.outlook.com (2603:10b6:208:1c2::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Tue, 19 Oct
 2021 10:59:20 +0000
Received: from BN8NAM11FT018.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f7:cafe::73) by BN9PR03CA0389.outlook.office365.com
 (2603:10b6:408:f7::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16 via Frontend
 Transport; Tue, 19 Oct 2021 10:59:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT018.mail.protection.outlook.com (10.13.176.89) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4608.15 via Frontend Transport; Tue, 19 Oct 2021 10:59:17 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 19 Oct
 2021 10:59:17 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 19 Oct 2021 10:59:14 +0000
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V2 mlx5-next 02/14] net/mlx5: Reuse exported virtfn index function call
Date:   Tue, 19 Oct 2021 13:58:26 +0300
Message-ID: <20211019105838.227569-3-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20211019105838.227569-1-yishaih@nvidia.com>
References: <20211019105838.227569-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4ef018d5-4445-494a-741b-08d992ef7f5a
X-MS-TrafficTypeDiagnostic: BL0PR12MB4849:
X-Microsoft-Antispam-PRVS: <BL0PR12MB484972DDB44F33ED9A74C184C3BD9@BL0PR12MB4849.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kXCy1exH5yFc0/XSmfRy+6tYDBa5YLOkmjCAUpn5vgTfqk8kwJg/F8PD/r3Qd2Z+rdfSlAPRjP7SDmcBwNDBVP32a65iTOpW1vmtMkOBvkEzy2H6NOeHmtYBItqaHGAOBqaZS+aU8kSJ15+vXjNCF0uM9vQevxBxfjGhsixunbw6JnBwzJp6UXT4u8km46ZhgW0qgSmu3ukQUv0u8zouYwo5HgHC0Jda9sOV0xZcaL55B4P0iB/elCP+veaJRGRXQzEKY6JEKHHT78JMuVKzQIDPjrwKJzdBWY2JHR8aR+HXL2i/QfDYe6pcxfQ/EAIFhPdN2U+bdofz2p0IcJjZnnPltQ1dNT6/H5yBR+t+/Jxwhzj/KvT//VX8HaCMPf7iRZiNpU7jRWtn81j92hMgeODj5bUdReSBOkDRNj48oQ2/Y5qxY8RpSigdtYsXDJScOiu7WEeeoKuhkr+EUF27ulCvnQWqmBq/BFV7k61nDpWWzJyllgvQ7+n2Qk7R5CxfCVhKEj+ze3mloYwp6PQfhr3fqFPhuc8wBsLPEFwbaZa9pPLMbaQT5rAa+aw3jpfCQB2No/3FtuE/C0yNaTAXyg8KvBFHyzueqx7Nq7uijlix5WtXFQmm4YyxtLsojZz75nBzqCLRCd6kY63rx0kS41rntKEuHuPP1YlVbpJE+9Hv+mIV3Rq5TgbhLP0vU3be8KXZ7pqM6z8sjUoB/TckKA==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(6636002)(70206006)(5660300002)(6666004)(186003)(70586007)(336012)(26005)(110136005)(36756003)(7696005)(47076005)(107886003)(508600001)(8936002)(8676002)(1076003)(426003)(4326008)(7636003)(54906003)(83380400001)(82310400003)(36860700001)(356005)(2906002)(86362001)(316002)(2616005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2021 10:59:17.6501
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ef018d5-4445-494a-741b-08d992ef7f5a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT018.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4849
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

