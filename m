Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFC1742BBF3
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 11:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238613AbhJMJug (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 05:50:36 -0400
Received: from mail-dm6nam10on2058.outbound.protection.outlook.com ([40.107.93.58]:34945
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238054AbhJMJuf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 05:50:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f3DjYJ+StX7/dp5hDhNa4wrygcS+FEKH2wwEIA4w3Yk8xrs315T4pbGjTl0mvg20Is1iKEvrQRJv+37RA9fxRgifRhfotF1Y9oVnUUrO8/rKNvzrpbFK+tS2aHwAFg20YlG/9DfDgrtK49NA42/eY7QOypal07YQf2bseqb4KnNFRBhQHtZXhShKdIsEDy49gjTFuqMxDhivyFAt3aDiV0f/u68bRiA/5qXlJmiJJLBWxuP+cAoV80rxRRAddodC3PZmnliH+ckBEIKVwvfKkK0slvOFqG78CFPbktoijynIGQfSe2Yb9EUwAaUpUuQN8ZtYdjQJXzPOGqbcOgRFng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eawxF+jFRBAH1P9hWq5BE145QVmYPfYNp1U9MJCuY0E=;
 b=m0fD2JPx026KRYbjawSEeKI7AtIMm+XhqXgdI6L3UYOngIX9PviP8BG43rNkR1wtIiPCzOEIBzKH02Zzog5vSRdL6yUoWLu6sqdWwZVeR1fXm+FQZLS2t/Zn65zeAKrrYjrqIbVj+NGMRHubEHf4q+dsLcFMO8gObGoTs7/TQpzor4HqB84m8fXZBc5BbLH0C/HL7TQjOQHJcknKSGDIM8hLs7McP8BvO9GcSinlJwtCic70l9cZi6NnHUKttPYC6U5L3K50krJciSCoztM5sQfCTFnb6UwxDKVjA6JGM8kBA9wcqXLnPhJNjVRL4OfuTg3VMdwg3P9uvkOsNzBFYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eawxF+jFRBAH1P9hWq5BE145QVmYPfYNp1U9MJCuY0E=;
 b=U4/0ReJp2fO7wu4M7wJAzZ9zSX4MjyOAGLDbZ7wzu8LzEm59tQt471GFklE8JVdLWKJ4okd2eM4peEMjmgrzR/IhlWgyu0QZG/rVMKEjfPKbtshvn14g/Nif1ACkFY152/sv6oIzvKUKGSa+qJnG9sRRGlSMjyE5WXlofE9HH4GoL2fnA3Q/67PUfgr+C/JU/dPNhdyrQYMm/e2EwGf0jfVZHWowLfKJ7sJRDZHYDSrJCtAk9jl5RImESeAJ6rjlg5SbMDAQmNsoNnSQkcZs3BmJmX49CAeHakR1Hs8EpeTXWNm4vnnDFZhqXxV3Y1oahwd9jAbjZMiXdgCfJdx6Gg==
Received: from DM3PR12CA0089.namprd12.prod.outlook.com (2603:10b6:0:57::33) by
 BN6PR1201MB0227.namprd12.prod.outlook.com (2603:10b6:405:4e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.22; Wed, 13 Oct
 2021 09:48:31 +0000
Received: from DM6NAM11FT051.eop-nam11.prod.protection.outlook.com
 (2603:10b6:0:57:cafe::76) by DM3PR12CA0089.outlook.office365.com
 (2603:10b6:0:57::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.14 via Frontend
 Transport; Wed, 13 Oct 2021 09:48:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT051.mail.protection.outlook.com (10.13.172.243) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4608.15 via Frontend Transport; Wed, 13 Oct 2021 09:48:30 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 13 Oct
 2021 09:48:29 +0000
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 13 Oct 2021 09:48:26 +0000
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V1 mlx5-next 02/13] net/mlx5: Reuse exported virtfn index function call
Date:   Wed, 13 Oct 2021 12:46:56 +0300
Message-ID: <20211013094707.163054-3-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20211013094707.163054-1-yishaih@nvidia.com>
References: <20211013094707.163054-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3bef8b47-4308-4664-aa37-08d98e2e9d4b
X-MS-TrafficTypeDiagnostic: BN6PR1201MB0227:
X-Microsoft-Antispam-PRVS: <BN6PR1201MB0227F4C77236FC7540172929C3B79@BN6PR1201MB0227.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TN1FiAeem9aNKm6QcMf+VHfSoQk5FjCZi7hoKjI0NnsZRBQNHeW/Pk3WJjbw8ZxiIy9rVuVBnzvLVDnSXW3qidYLtnOGhgp7VN4HhYz7caLegrKGEvoVLuWJ3U0U9QFnfgfrGty48+Bz2WM88Vku1FzsCGHMwKu/l6vZUv7RjEdslov96RrwvQ2I8oW5XONgMpLPh39bn+Tfyo3oao6hgzvNGBn+5A5QYW3XtEbSMFJn56MjaRfx7AbUDVdhtDr6+nWVjvNsXkSfhnTAa3wJhkZ+FfzBkRqQUxd9z+BGPO3L80l3wfoOyFYIcW2zqbkWp/s0nkKfjY4p0sED9QBRRb138XZnYPBBoGQemcXpdaJUW8YuZRx1IIAuD6a71km1IVzJbn+pbc/IaaX/jRR4RSnyj3OnpML/nlk47/oQDuh17JewOaGd78SGt3mV2drIcRPYNJ8z81vRAEkQOKihSvNf27xIvX0KcZcXXhp0Vreggz9CfIXA7obDb/SEx12HhpsRH0wxIj/hUrsqmtGcFnUtW/TL5l1Zdt07T+eDCHmaOlYWrxTdODcr/LpK1D59xkYORn1XT/t7I+TIUfIXmMAnGyCazOicbjyD2OuxZirXRb+gu1WHX4MdjV/Vn6u1w/Z9zCoLPMw1dqcW6BEKAlSe8/aqC+JD0/0l8sYdZwBuyNcnUTx8fpIJlOw3NPKfAKzWvzGKVRaCM98oB5XTBg==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(83380400001)(70206006)(6636002)(1076003)(82310400003)(2906002)(508600001)(26005)(107886003)(336012)(356005)(7636003)(54906003)(6666004)(426003)(70586007)(36756003)(86362001)(8676002)(110136005)(316002)(5660300002)(47076005)(2616005)(4326008)(8936002)(36860700001)(186003)(7696005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2021 09:48:30.7147
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bef8b47-4308-4664-aa37-08d98e2e9d4b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT051.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB0227
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

