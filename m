Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49A6B4AC75F
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 18:28:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377106AbiBGR1U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 12:27:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345988AbiBGRX3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 12:23:29 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam08on2040.outbound.protection.outlook.com [40.107.102.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB184C0401E6;
        Mon,  7 Feb 2022 09:23:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gg+oJn65SrQncxW7uAO07ozA5voo6auuazKZ25noCevTOYsTe/OFfUhvKzmLaVzYSXax3V3ej9Ui2OZBNLvuk4XpHz9UsSnWepwn80SAFmp3qZgVWSy+cAlF+ZWyUEawltO5cmQk65lopFka8vW1UwMEbJ5WcRJ8VbM+u627NruHRkYfoWdxHs/2aX2OwDm9d/EcVNipekCbjsii2gkZHI9nk6cC5Z8K05A9CS7QZgEc6nOl6KLVvkG93BSUC2wXMtaReMU68461j1pe+trPHJn3PDQKRwFqgFbvorXOWFzSv7pGmoVc6VL5998VlSYso3VjO07HWIVUfGztik+DYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eawxF+jFRBAH1P9hWq5BE145QVmYPfYNp1U9MJCuY0E=;
 b=RPZdgyAnQQTjPFhghso7izD64nTztWnIA8aPACuuCqBlge40/FNYkNszjJCBuY72cz2OYQ9m+FuNkYSzCxK7T6q/4YSaSLj7v4b71GeIm6MQWoK2Vug9v8SEzTW60RD8Mx1BSdhSjZtlL+ZGnA92Y+cT3RmojSz49+tGHzWH6OPURr9XOlgqx6u5vmzW/99NduBmoEv274gECm5W+JU1KBU8892JJnUI6EGAAZ33cm2nPP5M7kI9aBopOKkhuTQd3e5QKBj7poD+zUECGZz2RFAntCL1PhbopVyetYcN4EmQ0c1Pqlh8sGWQoUhHpufxK21h4ng8KGZNPu5WvJrHIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eawxF+jFRBAH1P9hWq5BE145QVmYPfYNp1U9MJCuY0E=;
 b=WVDhBiUdTAG2GnjxTC4qb7uYk2XpNOc3BNB2aZNkWGj5aYZJAERUotunnu0727J6pGaEaf9aAm7WuuXHJPbPMw04J4t5//hVHTPOancS/HQWr8ZUCC8qWytcBYXhrYwu58pwb/g4DHcr3BMSMYmrD9KnZmBQJ7st1JNbyCLwcRMOAHcEkaAq7A3LGIzFVIOchCBwkTewrMccMFwHAClm6Z8PglFQlIzhnRG6/WTbwI9Apc0hhROYwPuy9Mfzd6mXuodq5Mj8NbcFLgg1YvEQOdiJpQqxxQPD/EbXnJqEnnQNx1pTIAqvb8QH68MpljEcnTueKIajGfzba+xxEob/WQ==
Received: from MWHPR22CA0014.namprd22.prod.outlook.com (2603:10b6:300:ef::24)
 by BN6PR1201MB0163.namprd12.prod.outlook.com (2603:10b6:405:56::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.11; Mon, 7 Feb
 2022 17:23:21 +0000
Received: from CO1NAM11FT049.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:ef:cafe::f5) by MWHPR22CA0014.outlook.office365.com
 (2603:10b6:300:ef::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.19 via Frontend
 Transport; Mon, 7 Feb 2022 17:23:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT049.mail.protection.outlook.com (10.13.175.50) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4951.12 via Frontend Transport; Mon, 7 Feb 2022 17:23:20 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 7 Feb
 2022 17:23:14 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Mon, 7 Feb 2022
 09:23:13 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Mon, 7 Feb
 2022 09:23:09 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>, <ashok.raj@intel.com>,
        <kevin.tian@intel.com>, <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH V7 mlx5-next 02/15] net/mlx5: Reuse exported virtfn index function call
Date:   Mon, 7 Feb 2022 19:22:03 +0200
Message-ID: <20220207172216.206415-3-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220207172216.206415-1-yishaih@nvidia.com>
References: <20220207172216.206415-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: adc7a090-6fb0-4868-ae84-08d9ea5e89b7
X-MS-TrafficTypeDiagnostic: BN6PR1201MB0163:EE_
X-Microsoft-Antispam-PRVS: <BN6PR1201MB01630CE419FFDC5E8788CDAAC32C9@BN6PR1201MB0163.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: awpgcrI9RQPkNn2ChIG7PneVvlKzCmLpYV2P7cElmThKa4QLGS45l4b4zVs9oFDsNXZ54lrQqMvjBSIi1+9GfaklzTCvduA2Eqc7W3MdQSsP9kql6ZYZVbk3yQe9SyJTe1GHQ/aFvWZ6h6XkZKC3DZMKWMl8aTLJxqwsalf4sunxSFmT2eKg4OFt1VR6g6yPsa3IFZtVXUJStFLAUHa4dBdng4TlUhMDRjANakBqXBX/8S/+E2HmVlt2kLjOgDvzjPqPGeM2gPhvgrQvXQXZwjo1BBzfmL03+bDozWNg8XUZm8xUAxlwdEJOKcW6k57AglNA26v+uqP2QuEYccgPBo5N+b8l+Gh3brYxRox+fGE6HxK219bHYLkBiOaCnkOTlixx7pvhcc2WOGwKBWFYNzRw+bY0NAOuRV6zK8Pln5SsxMwIbW1DQbuIPu7XxQSG9RYlfmFmVSHqxZxDso5maGFsYBJ0QUTmzFt8CHlwrcI+YNhz6hEj1n3sEzdkndzJW1FNtkZ1N7DR7aj675uzv8fpz5SJEkSlunQhT/3x++XwaBEgruGLGyYpjRc6e9nX9m56c53+bdhYum8OdBTnTjzpuGnLra9P5xO6cBNusBl7tAl4rfd+eNxsH9siV94FGflAeaFh2mSiavMy18aFwlvjE0x3HisRccrY3qRppaarvvV/tkSvJl2eqljp2N5+Ert9iMppYAvHhgv/4rkaAA==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(8676002)(40460700003)(4326008)(47076005)(70586007)(70206006)(8936002)(336012)(426003)(83380400001)(2906002)(82310400004)(86362001)(36860700001)(5660300002)(508600001)(186003)(6666004)(6636002)(7696005)(26005)(1076003)(2616005)(36756003)(316002)(81166007)(356005)(54906003)(110136005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2022 17:23:20.7040
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: adc7a090-6fb0-4868-ae84-08d9ea5e89b7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT049.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB0163
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

