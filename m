Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3D104A3789
	for <lists+netdev@lfdr.de>; Sun, 30 Jan 2022 17:15:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355575AbiA3QPD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jan 2022 11:15:03 -0500
Received: from mail-bn8nam11on2069.outbound.protection.outlook.com ([40.107.236.69]:43104
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1355538AbiA3QO4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 Jan 2022 11:14:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LEz4xhguPSup4j1/d6TRUpV0CKfzrkRGyksbvESs6OmwheLD4mvGvFMGizgfjcyOjt7OJk1QIIKSXZg3mlXSYiVbZZxncg9VuKnA+J5UOnKgHPqGMK5h6QJZe7fkqLFio2Tm4mm2xQmZJjYYIlez3RMUxko1zU1jPmSmJKKYMYpzN463tdmHkHCXRQ9eIbIs9t3pEfwSZiBTCqgRoufclKInzWnVx3lGQ/8PGiYrPE/Vo0sct+za4/Q861JGgZ79pezCX1py9XGT/2hgWHp1D3ULCYg9V04vuDVAG10ARrjixFncs2mh72KC5g79VFYpfBgBNcz7oSz2yecPGu/anw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eawxF+jFRBAH1P9hWq5BE145QVmYPfYNp1U9MJCuY0E=;
 b=Vbu749zGZ648WxdyZ2VhtnHvrefoYQKOONr0+QrMTOMmIL+UrCr0yHX4/mknRX9OYlvIcFoc1gCgDRj5VcJyM+RpnHZ1hopI2FJuwBfc0ZmwKpOi8UFrdS+PCCXganUa3fKiTF48xfzfUzAK2bvEUIDGlLseEGVJnxm9jxAetsGfgSBNTXs8dEIF0Gprhzfwj7ApMVvD1fkmAjv/q6BMj0vrOmBzHf/cOWVPXE92tLPr+wdmxVH1TEBekFcrkurrwABLXSJOZJuz1kSVHOwCGzVxnCFaj4l4SVAM6fJUjELcsqqCSG/5ji2yBdsPR5MF0Ckz826mEKykZFkHVZUJig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eawxF+jFRBAH1P9hWq5BE145QVmYPfYNp1U9MJCuY0E=;
 b=LgpVP4u/fhgaisAXrgXc+S8n8F5e4ZG35vM2wfxwHHFQKhjbM8DgoUD/Ub2x05nvdhheZzvc7iCDOrTi3VHf/LYYTDhKJMIvcudef8lDxNqos4BTBL6iSaKfbkW201XRzaG1mUEESTdloD75p6wHxZpZIPyCCy7mkbuYw9/ZALxWqC9Asao6afK337tGZJC32TFiK6WghC276KcQE3s1mN9FfG6G8y06Sie52Z7ExZeNUNxnstElY6Ojhz+k3Cfuuj+mOimW3+MqAKqHsqM+YunUjSHok3KFT1HeuZAf1eRt8DO7FVwjgCv+HW21nvp6nBV3cnEE7C+7LbphmC31hA==
Received: from BN0PR04CA0160.namprd04.prod.outlook.com (2603:10b6:408:eb::15)
 by BN6PR12MB1875.namprd12.prod.outlook.com (2603:10b6:404:103::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17; Sun, 30 Jan
 2022 16:14:54 +0000
Received: from BN8NAM11FT022.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:eb:cafe::98) by BN0PR04CA0160.outlook.office365.com
 (2603:10b6:408:eb::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17 via Frontend
 Transport; Sun, 30 Jan 2022 16:14:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 BN8NAM11FT022.mail.protection.outlook.com (10.13.176.112) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4930.15 via Frontend Transport; Sun, 30 Jan 2022 16:14:53 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL109.nvidia.com (10.27.9.19) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Sun, 30 Jan 2022 16:14:52 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9;
 Sun, 30 Jan 2022 08:14:52 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.9 via Frontend
 Transport; Sun, 30 Jan 2022 08:14:49 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V6 mlx5-next 02/15] net/mlx5: Reuse exported virtfn index function call
Date:   Sun, 30 Jan 2022 18:08:13 +0200
Message-ID: <20220130160826.32449-3-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220130160826.32449-1-yishaih@nvidia.com>
References: <20220130160826.32449-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d9c3c761-0c04-4ac7-9ede-08d9e40ba680
X-MS-TrafficTypeDiagnostic: BN6PR12MB1875:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB1875DD400B753E6E8CAD065FC3249@BN6PR12MB1875.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EE2JQ2LHNcKlLe4CZWnJHXxX5Lyl6iCXYSD/h8UIPNs+sgc884P4dFlUSRtCIclkEo0sNiC+K/2xzVZ40yoSLmLPtM/6ud47A/2GIaw0vWZT9q+bmQfhSg2MUXCrSNVz8576HwwmbWwkmlbpbzZ6FwpRFXYquOfYqwdw4cqTtgck17qQLM67X9EBWpQDPdYTn0dQAQ9WAZOX49bhzMtARfkiSAa9t/nYKnLJJAlFTxxAmvNNcH2irKGFR1fpJdZREI7dZYSbd21DSFBPcsPCyHCbHbBleycyoFuZZQDAXFN2kmfzxd8BrgjF7SItfwmY3s+zho1Af0VthHC8SToEt3bozix1rfaFLdwJNHa1nX8i6cPsShV5s0WC4QA5m3HEo43dORqU5hxwRa5IdNz7z+1kD3D1/zo9Ra1drgNze0ieKNqTv4FJhglTEwMup8+2BOhpH/IBYldjSw1QbLpz0utrjR0Wy/G2iWJ2rFj6clWerj3oTbjwTAfGeoO1WYYo9YC6tWzcI3zprLxhjkT+XkUKNzXNWU8TINeJu9ws5qAQO6+AbZChdCsw802wTZ1C0bVgUOdbt1/8YIYgWu42qQv6sNba7MQHTGZLCp6YGeY/heaVZbeCPO0SnFuVSMuU7gEdsAmWlyyvqNqxQevLmc2hjNhIqWAMBuph0nqztVlnRTAvJBEu6hUrVay8gnXxyMvmbJETVDifXDS7x+Az7w==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(36860700001)(83380400001)(6636002)(54906003)(316002)(1076003)(186003)(26005)(426003)(336012)(36756003)(2906002)(47076005)(2616005)(107886003)(110136005)(8676002)(86362001)(40460700003)(4326008)(8936002)(70206006)(7696005)(5660300002)(508600001)(356005)(81166007)(82310400004)(70586007)(6666004)(36900700001)(20210929001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2022 16:14:53.7137
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d9c3c761-0c04-4ac7-9ede-08d9e40ba680
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT022.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1875
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

