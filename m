Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A0B243C701
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 11:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241289AbhJ0KAd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 06:00:33 -0400
Received: from mail-dm6nam10on2086.outbound.protection.outlook.com ([40.107.93.86]:50912
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241300AbhJ0KA3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 06:00:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C+OwOjn8iEv6aVOuHyh2fA728rtouI9biskqYckhKut2BOWBoTpVSmlxa9NqQNVqUYI6QhZwcNYW6VcruUkf4wc9nkbRo8ZpBzs+kOfwBgbe48fHefb2ody2EH8tRQkzHUoJfbHJt3a1RoNPubnl0c5Tw9KFYS9kXhSM6ja0z3AWVfN5Jg6Z8ZDlf3tIRuPqcoAMBU/GLci222DLYguf+zLx+dfp/pQrV+0ZMu682V1PFZ9NbEeOw73U0vpNLkgJ7zAloZh8ufbb1mz23EOd1FZKyf23hFpobmVNAkkhGv+0xjatJkPUu1MaQk5cO/zezr/E1PNj5l+SqEnBfUYFww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ATQOdGVF4dTjbvMJ1bmmazMNjFwWqMg4M5PKqHqf20k=;
 b=KBTcXXnUaOcclEnqNb29D6M1WHp5QWYLUJ4jPKT63wCVTgtgCoS/IkPo5mF4L0EbiWehkm9duX4HZgSyb+WpJkRMH9/S5XGeGEJm6/CIdS0pPtIFd/BAWZoYkhFw++WHx1zKvykQzpItRFixn4MFWFmI72SAuKKKspa940ijGwkd/1UvVLKrNvB9cbAuNv9VKC09XxC6LvMykHeb1k3Fi6jzH/1y9sXtIcq2pQ7hNL2T5m4g2w2O89UE4iJNJCievHC2gq2pB6T82iKia6oWNYvkFnciPsTOFEknh2Rr1inPZnd7Ld5H9k2e0Ck6OSYaqmInHG2J9H9oVo8oOuYC4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ATQOdGVF4dTjbvMJ1bmmazMNjFwWqMg4M5PKqHqf20k=;
 b=TAG/Cjw+eJNDFhJMKJfc7WPd0yPrAxhhDsoBO5f4AsPLcjIxfTmYhxZLjK3JeWiVVeselFy3EAp9h5C5LsviilRiQvqmC1lchoZTI0ukqHdgAcCv+ibi9rUuWsYcG2AIHdY+YK30qjCIA5EHcfBt4XJXJ3BpOxNJQ6acAteotmn4XiN6kVTk7vPOFm46/HzAUEdoyI4gYxiiLw+QSGUbxiRa7RIBAlV0cqT4PdKIfSJXypwynBKLRlvFgnXjscs88TfNThA8x5JRbcV7+w3Ky95vkQmjtogmFWnEQa//I2FOR6/nzrEhbChjOLwQjoDfzyezdxcNpYR8O0xuKzwESw==
Received: from BN9PR03CA0239.namprd03.prod.outlook.com (2603:10b6:408:f8::34)
 by BL1PR12MB5380.namprd12.prod.outlook.com (2603:10b6:208:314::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Wed, 27 Oct
 2021 09:58:02 +0000
Received: from BN8NAM11FT038.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f8:cafe::4b) by BN9PR03CA0239.outlook.office365.com
 (2603:10b6:408:f8::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend
 Transport; Wed, 27 Oct 2021 09:58:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 BN8NAM11FT038.mail.protection.outlook.com (10.13.176.246) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4649.14 via Frontend Transport; Wed, 27 Oct 2021 09:58:02 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 27 Oct
 2021 09:58:01 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 27 Oct 2021 09:57:58 +0000
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V5 mlx5-next 03/13] net/mlx5: Disable SRIOV before PF removal
Date:   Wed, 27 Oct 2021 12:56:48 +0300
Message-ID: <20211027095658.144468-4-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20211027095658.144468-1-yishaih@nvidia.com>
References: <20211027095658.144468-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 74946f44-0a65-427b-5279-08d9993043bc
X-MS-TrafficTypeDiagnostic: BL1PR12MB5380:
X-Microsoft-Antispam-PRVS: <BL1PR12MB53807F45E0A5AC7BBF4C17EEC3859@BL1PR12MB5380.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZqxDxRT7Q4MZzeA+ytdmJHgZN8yWevakJ+Opga+TS9YPgNS6qALu1NfAq3hsJ2wv4D67I5SuHQNWP8vSnV4PT7qZ1iN5Cn2CdJ9JITye5a40R9g87zi2Wv9TV9VoUVJzYuZQYxWR7Lt4MwAcpdvLdGuMJbQpYylTZku91PfdNT2/kIx8UjU4GY62amd9xWcRBxo9I39wdlmabr+zDrofTV+Nfuq61cJ2tE4IjALLEEeKJPfaczpOtMKid3t/eMZvZTJakEiVmDstKpbbJ6IFbc1Is2pbH84/AS2dtB2VLkyM+RNFtReiWhO3uijObvZTrG+HYaHuMJ6Ksj96+m5DmsUiNnWNimv6+zklwjZCmJAWyoCRZSt4VFjtZZbRX0YOgbPj6PkDecjs0GXevt5RXHNp1xn3ZYx9LHcv9yRI8DCUpe26x3/ZyszEnmEq/VV1NwfgegDWNMLzQlVmeSPNEkuV54wnXp7HtuN6p522diqEArp9ZPlhyQVsOpCkVPv7nNvlht2N1lkjkCkpwPYAlH8NSNOR4izI+awFJC8zC0XgKHSptPSkh4TtyJn31mb9n2L9L23z4Wb2AxQJFWD2VfY3FfFPSO0XNKatdk4FiIqL2woTYtH0JJxKhi4gpg1jyRfnLQGstZjs+JjBA/Wjyj7Kg1VwqhtPZfVJyTfzK5qku1HxjIu000r9vVewU0aWxrt7TUnfktNV/BVmL/9NBw==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(47076005)(356005)(508600001)(83380400001)(2906002)(70586007)(1076003)(7636003)(70206006)(26005)(107886003)(4326008)(82310400003)(8676002)(8936002)(7696005)(54906003)(36756003)(2616005)(110136005)(316002)(426003)(86362001)(186003)(5660300002)(6636002)(6666004)(336012)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2021 09:58:02.1872
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 74946f44-0a65-427b-5279-08d9993043bc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT038.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5380
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
index 79482824c64f..0b9a911acfc1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1558,6 +1558,7 @@ static void remove_one(struct pci_dev *pdev)
 	struct mlx5_core_dev *dev  = pci_get_drvdata(pdev);
 	struct devlink *devlink = priv_to_devlink(dev);
 
+	mlx5_sriov_disable(pdev);
 	devlink_reload_disable(devlink);
 	mlx5_crdump_disable(dev);
 	mlx5_drain_health_wq(dev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index 230eab7e3bc9..f21d64416f7f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -140,6 +140,7 @@ void mlx5_sriov_cleanup(struct mlx5_core_dev *dev);
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

