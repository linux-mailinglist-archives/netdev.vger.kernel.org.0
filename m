Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06C114C2E31
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 15:23:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235443AbiBXOVl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 09:21:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235406AbiBXOVf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 09:21:35 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam08on2082.outbound.protection.outlook.com [40.107.102.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD86014FFC3;
        Thu, 24 Feb 2022 06:21:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fmjCKt6BalCc47cGHLJ6omBmX17mv2QiWT4K4uPi+3mqKL0lHUynBpOUnmyaIbY6PSFoiP/5xS5aDWFOd9uM39wDm2YJjr8Mh20Bn1jU3h3TAJACW/jJh0KmnEjP5ZxMueoB8f6xgHBr0/RkpCDolV+uO94DKKmRCKO8/1Jp5oz67OG+XrO60wq5zV3mNpTPhP0RY89mydkA6YYZjqNe455Q06Q8laZuwWM6VhRABZsykFb9r6w/5kRbbmVf9m69NI6rBZf3UxYEEQCh3+znpqQQF1IFeOgG46dp4Y4IEBB70CaABkxvW8iPtFHfym2JLLIn79s6+kubao8+1VQRmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eawxF+jFRBAH1P9hWq5BE145QVmYPfYNp1U9MJCuY0E=;
 b=aks8gR7XQ2Z1VqTl6Oemz3rmnH9yxft8X7WKZ9M3sWazeSaiboQaEB80l6HlOqRhnPmK1rPrPN4wubHTK8kxk80jNFAjrRLa/NoJCN0m4SPnm4ui7L0dKyuCarc5oKSgYVLwR5T2cW3Z8GnesJtFK2eq0z3JMl9u88Ki65EvMZZQEQsmEN60s7WDw+v9l+Rtrlb2bjGYHfbxTI+H8ibEc3nvm9VdCWwn5jj/zdN09lRo2DOCK3C2NQTPd08g/6HizHMU5d3rA7nNbXt1GGXf9mQKJTqu2spp8rceSqnVIIl12S6cVfRqhCJKbIoSue7VjUwIJSeGdCd5Wx6LcNBMEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eawxF+jFRBAH1P9hWq5BE145QVmYPfYNp1U9MJCuY0E=;
 b=O5FlTot/NRu7gmnPRbHgIK8gejldoWI/4Vs+FiLKR/qMT6eCU5jAxyFtvFidzYc5zxOICOAb2vj0ZtnAX1MqjxGj48vRnF75YAUnrPu0ir5wZmtWw/Xa3wEFaNYeX/2pmVcJOE0olzRXz45RUx0K2F/PS8FodF1A3Y4z8oYcVF3ruoy1hwP8VsEjjptONGfuoN1IJJA2czhWmjyKfFIZLNsdAif535+qAjRStkyrCiJR87fK+5AOsLWUg5lVYuxvme0z12ZFJ6FzpYqNF3664V2SM0PlL0XzjKGM0jfd6gvIybVATz62Jm2UxaoRcGPPjFh2u2v7kZnhDS8cjfvsaQ==
Received: from MWHPR11CA0009.namprd11.prod.outlook.com (2603:10b6:301:1::19)
 by BY5PR12MB4919.namprd12.prod.outlook.com (2603:10b6:a03:1d6::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.23; Thu, 24 Feb
 2022 14:21:02 +0000
Received: from CO1NAM11FT054.eop-nam11.prod.protection.outlook.com
 (2603:10b6:301:1:cafe::4) by MWHPR11CA0009.outlook.office365.com
 (2603:10b6:301:1::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21 via Frontend
 Transport; Thu, 24 Feb 2022 14:21:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT054.mail.protection.outlook.com (10.13.174.70) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5017.22 via Frontend Transport; Thu, 24 Feb 2022 14:21:01 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 24 Feb
 2022 14:21:00 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Thu, 24 Feb 2022
 06:20:57 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Thu, 24 Feb
 2022 06:20:54 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>, <cohuck@redhat.com>,
        <ashok.raj@intel.com>, <kevin.tian@intel.com>,
        <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH V9 mlx5-next 02/15] net/mlx5: Reuse exported virtfn index function call
Date:   Thu, 24 Feb 2022 16:20:11 +0200
Message-ID: <20220224142024.147653-3-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220224142024.147653-1-yishaih@nvidia.com>
References: <20220224142024.147653-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c9917b82-c2df-4282-7c06-08d9f7a0e2bc
X-MS-TrafficTypeDiagnostic: BY5PR12MB4919:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB4919A4DAD64349A62CB71886C33D9@BY5PR12MB4919.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +6NZG/9s1NsKkm6DqxpT633OQ1Azl+Gki8hMoH6tv0tFNrX7DMl2jf+J7R6c74MP03iaSlTJiEbhylASVSV0GbCDrYTuRoBt/H1uiG6eZY4X1eCO1mL0Wjb43rhTORXz1lGCs08ZFUpiy2Nfn2KzUCKF/QrFLGxxnS7lrfJijJioWcYatIx/dS4Vx8xUYgBJQjj8UIxKVsFYNzYpb1rbc7DejkZmZ4Wj7uE3mdsB1TItdkFudUtAeAsWfNkQPc8w0+48VfR49xHD6FJb0cYUlZvB4+ga/Bx6JIfUSEy4W8rnlloTkZu+hgHtzcQ+mhvSuBJc6+yUM1PNQcFGMwUvOtbBqNhEG5QlEfUq0PtITamPtXaU8dsVK1g/gfW4PYZTmxZ3Z4RwYMzISo2PzBC52TWnGBZOEPi5kTvIWPWVAFpan/h2aLaV0dETBMY6aAi5quKb892x2ZOEz8O845oh/l/39RZCL+5TCY/SWRzE3eq0yu/eG7eOtiUF8Uv8fgxAUzryve2kSmAPeRZ5Mn4EArDSjE3qkALKH+vQs0jQ/5pAEGXdZ0vjABV+cXBEKcTutu9r/SgdNTDusBu5cQiMHolXDygSRdnuH7g/Mo1QDGU1qOLFIPd9MuC/spKoAL8g4jcgdylTZ1iyebGwPSTHSVU5gVn0C7iVUgF9ZY9a58ch94LR8OwKSZLf+lW7DGpfhVLhZ2qnXG0A+DUwChq4ew==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(8936002)(110136005)(26005)(86362001)(336012)(186003)(2616005)(426003)(1076003)(82310400004)(36756003)(81166007)(40460700003)(7416002)(5660300002)(6636002)(47076005)(316002)(54906003)(83380400001)(8676002)(4326008)(508600001)(36860700001)(2906002)(7696005)(6666004)(70586007)(70206006)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 14:21:01.9373
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c9917b82-c2df-4282-7c06-08d9f7a0e2bc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT054.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4919
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

