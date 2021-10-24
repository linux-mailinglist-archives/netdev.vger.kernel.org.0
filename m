Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D882C438780
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 10:31:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231438AbhJXIeH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 04:34:07 -0400
Received: from mail-bn8nam12on2048.outbound.protection.outlook.com ([40.107.237.48]:46176
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230300AbhJXIeH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 Oct 2021 04:34:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nE02L6HKKfbc1Guu0R0ZvlqA60sbIT33Z0HXg2oLzgqwkfEnpVmqSvURERM6DBDKJP+1wxfaSfZxhSuezxpXN/w4OzvFZYI8SfkiWl1ZwUYa51F7Olhnct0lOSnzets1PLzcr0/VIgihkNI+7+eIdEqS142cmlPTTzwhLBmoOjslpEM6f42hc1Eoo++VDWvAmecpxI5PF65mqdDGKNuf32Brze0IWYngmpJvN8QhHKQtyl6n6E2tiFpKGUTODNh8nOb/w98rquS1TEOzZYNAW9NmjuZEuM8QL7lb55A1JbJycqb6YXTTwX7pWZtn4fUZpen4BapQAe34hnfeqq2pUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eawxF+jFRBAH1P9hWq5BE145QVmYPfYNp1U9MJCuY0E=;
 b=NWVhBi2yZESzlGh5fi74QPXdUj33UqYeAB7tLhCgTKo5TJM8FnoMbjxgkF9mXUdZWl60a9pK0b8Jtz3XXZt2xKItAitkjeLl3JSdkCNYZ3QrK4AurCfn+6Kedtysd26LJpm2FC7Qx+ISwlvI3u8BPw5jy4oJK7mYdx+4pMCldqyGaU1GgA0IunImJNkgsvSTqjiInWYctiNTgwt70dixrakaTd3EwotZiMkFyU6L50qL9Gh6f9XOu6/p9kbEW8r4wlk1/8uOwiusvcwLSFjon5/pbpPUDapSdNy8bCbnS+nKBQ6Nl3kJnSdkpM83bOb8XMp0/CI7oUhOxquk2+UgUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eawxF+jFRBAH1P9hWq5BE145QVmYPfYNp1U9MJCuY0E=;
 b=fCOVMOxNTzYQ63js3m4wJVEosZ8/dBgw8kydzyZKn4SX4lNMjl41A2WDHqXNVre6HvKVETaRLrKCSWSU6AZ5RVHf5aeiU93W52sD0LYQKvbk7GQGbtC8GXxKPI7sdBh2ROZSZC6XvYRA5zxUEUJOyqxlA0pd86BvubciQjGe3r/8EQ04XB4F1irBh9pjNi4VXPr9U5SLITCvKuAAG+wbvbhAKv1Boe2X0Rm6AaWwV8jCcgVchK7HNIKCiaI7Vwwua0qotWnv1wzYdGD6Kt09ZE1c+l2XfBKg9owHUChoYX0CPalJeHYlKFZCl4qqt2bXtDsZI3hTdNsigHH3Sty0kA==
Received: from BN9PR03CA0145.namprd03.prod.outlook.com (2603:10b6:408:fe::30)
 by MN2PR12MB4238.namprd12.prod.outlook.com (2603:10b6:208:199::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Sun, 24 Oct
 2021 08:31:44 +0000
Received: from BN8NAM11FT022.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fe:cafe::f0) by BN9PR03CA0145.outlook.office365.com
 (2603:10b6:408:fe::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.15 via Frontend
 Transport; Sun, 24 Oct 2021 08:31:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 BN8NAM11FT022.mail.protection.outlook.com (10.13.176.112) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4628.16 via Frontend Transport; Sun, 24 Oct 2021 08:31:43 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 24 Oct
 2021 08:31:40 +0000
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Sun, 24 Oct 2021 01:31:37 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V3 mlx5-next 02/13] net/mlx5: Reuse exported virtfn index function call
Date:   Sun, 24 Oct 2021 11:30:08 +0300
Message-ID: <20211024083019.232813-3-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20211024083019.232813-1-yishaih@nvidia.com>
References: <20211024083019.232813-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3df2d594-e910-445d-7d64-08d996c8b5f0
X-MS-TrafficTypeDiagnostic: MN2PR12MB4238:
X-Microsoft-Antispam-PRVS: <MN2PR12MB4238CFB8633FA252EE1BAD10C3829@MN2PR12MB4238.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 83728EU8iUEVmb0Pp0ghzzpyVG6zJaPPQkJkcecQThIMoY/vAhS7DtJuzbw0Tg2sbM1BDMgrGeoJychQzNzTRHABVtYJM3LmAXsfRQScY3LE86G2F9Z91yqQRl3+VTz0GuZOBTsxSrh3FYWt/HHt5KQEMMi59jEU+CLlQoILk2ixr5bgYIw1gt8a/qDh8NPAD8s664ODWVgH8KNIhZ1vjw+vrrpYhCE/kszmNj6QpzQFJLbe9K21uuz1OWZIVe4zKL2ntYfqqjZVA0VK10tqgD9oxttaQu349Z+xoOfwJbfzhMusFDCLMq/vCp36HGsPN+ZiGQ2JT7+fPvOeO/BGD1k82rQw+/L5OkmTfTDLaMY7xKTLvZ1EySI3rccbCo7u39eUPpjpO5XQwpZ1qjWWoP825ttBaV9p6fgL5HIYUP90k7CXbQR3gNqU+BRnF+gu3bYjU8P7w/ZuhSonjgN2vj0Xh2fLRq8lQ3z+QNMhfqo0CFwlJywNO6CiOCGJrozLVBs9DKQ+ysF0dwhKCMloEZF+ML+A78MCzO1h4T21qmdmgpZ1u8yQ0P2hAfclybGH5WjXOBpGLII7NtR96NMhQilYvnODZ9nGL7gMA6SXrruVcvduQaHz/2UJl8eOkcMXHkI85GHLABMxxWWIcBh5GWKhTxkNms1YC3w0gQaSFivnZBNk+75hl9ld5/Ep8WflkhiYIqpdlw1TZ9nzSyqXNw==
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(8936002)(26005)(47076005)(4326008)(5660300002)(70206006)(83380400001)(1076003)(508600001)(36860700001)(70586007)(186003)(8676002)(356005)(86362001)(36756003)(2906002)(82310400003)(110136005)(54906003)(316002)(426003)(2616005)(7696005)(107886003)(336012)(6666004)(7636003)(6636002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2021 08:31:43.7849
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3df2d594-e910-445d-7d64-08d996c8b5f0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT022.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4238
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

