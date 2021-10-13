Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94C7342BBFE
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 11:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239181AbhJMJuu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 05:50:50 -0400
Received: from mail-dm6nam12on2075.outbound.protection.outlook.com ([40.107.243.75]:57441
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239088AbhJMJus (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 05:50:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dpBrmjHGleRlZ2VAW4oosuSwWEaWRx6RNu0qBJETV1rwuFUhUZfKMNtLKPsiCLpdGoRdBpifE2fiTiDNYTHaZo3l3n67Cvheq0LE+XKN6uBeFPwgSZYE3wbIze0z5msRHxuuY2ZHhjw+oZ7aCK1QCB/y/0nw4OWV8jDV4aTLNzEMr7Au3qLca3AQe3qF5NEY6qIlSBS6chR2pJc7a7VFJcRsLSnyZnsy5agJJnC4stGSb9YWRxJ83c1aZBirNVTRDtbUOWx5oCGMZuj347QI9y6PHPut21UkPCMstONBGZDiDBBaQ89ShcVEAR4FP55puV/KaeUMRK9jTLI2QZx7Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C89Jlk8BDEI17QHQ1FU/2vPIIO2h4K4F/VMusgvFzJI=;
 b=nj81+8yJWetqS5d4jb6eUnCpyVPqj1N0EH0oyQvik7mYX0RV13AqYkSuG+3IRlqDRRMODgns3wYwKoGu4PxXnN4t77K5RO61d6H9KXJFctJVmG9NPcknrWBUFXynkxpAc6HeQWEqcyAuLzhTB0egTkRWgz7M62i/RavGL1orkdWcnyiwC+ycuNBcShzHTd2AzsDVYxyM3ebWlf0ihwHTU+sSjxJThSuLLbW6E7N6i1XPipkdKKs5veZyydA1Zs36S+YA51bbU6GGOFEew63y6tRqgj1+5n4x2uAsAJIAUqHjr3sq0Ebz4UtjjaLAYUe1yfE3RqHgHJDjAkYnpKyang==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C89Jlk8BDEI17QHQ1FU/2vPIIO2h4K4F/VMusgvFzJI=;
 b=fzVLkTKbHC0fiHcwFX+szjF5ovXSC3Xi5iZ396EXJiHACMXwqX/MPAqrwYP0M5IffxC0rU/nYwnpQlK7JF/j/VwEHhFWN5gK7nXKElvzpkPkDhtkWrR7n8TCbkwdeZPMJp2JdEuZi3nKgOwAR8H2ueBby2RMllPyA87dfccPh4Zk8KhJAWA24dpPUxoNKFZLtXw9HPw966Gf5Q6shODdIsZkwuR26l+8ymjoinQBHI/J8+6T8ELh3CWmjm9vUi+fc9SLuytu8tqzxLS0/5vC0xIRupbKPLgD5HwVZh0AoNPstSqA6oBRGO9tGk03ae9BEZYkXlOQp/LKjz9FyeJ2lA==
Received: from MW4PR04CA0184.namprd04.prod.outlook.com (2603:10b6:303:86::9)
 by SN6PR12MB2766.namprd12.prod.outlook.com (2603:10b6:805:78::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.25; Wed, 13 Oct
 2021 09:48:43 +0000
Received: from CO1NAM11FT020.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:86:cafe::2a) by MW4PR04CA0184.outlook.office365.com
 (2603:10b6:303:86::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.25 via Frontend
 Transport; Wed, 13 Oct 2021 09:48:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 CO1NAM11FT020.mail.protection.outlook.com (10.13.174.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4608.15 via Frontend Transport; Wed, 13 Oct 2021 09:48:43 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 13 Oct
 2021 09:48:43 +0000
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 13 Oct 2021 09:48:39 +0000
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V1 mlx5-next 06/13] vdpa/mlx5: Use mlx5_vf_get_core_dev() to get PF device
Date:   Wed, 13 Oct 2021 12:47:00 +0300
Message-ID: <20211013094707.163054-7-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20211013094707.163054-1-yishaih@nvidia.com>
References: <20211013094707.163054-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 61371716-5dd2-4c9c-3df5-08d98e2ea4d8
X-MS-TrafficTypeDiagnostic: SN6PR12MB2766:
X-Microsoft-Antispam-PRVS: <SN6PR12MB27667D4BCB65902B169FED5BC3B79@SN6PR12MB2766.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F89HwVCRef7agAr4DMDTr8OtSqMZ03HNg8mhtsf3Nbpf7l9HiZD3INntW5k1Mve20C1V/40nWcOTgZkEiyPsIKohxpL3dDGcqPq8Fgv6FmBygfnuyTK/XQSLGgLp1wHjcUnHRzvOxJoiJsxeaCr82/l+Cva+YpdBwlMzPHzy9TVnffVT2LD7QnKyM65XLqmAts6ByJCBe69wz2sBlvyWwLKKVzt9TkCP2eag/WPZdbzFQmHT1LBQl/dqYc2pvEgfpNyUj/Bum/sYpzAc35QUggrB9kbzSIepTEz9SvHJPKnax74nPL4TDnRpPWdIYFdQFZjCcRkYddyscTU4AB0uSoEoBUWv1/KvQhC/nwwwkxu1ylEFSmg1pz72OazggGeN/9I9FLtqCkmUoCdm0rMNOuaqGeyXmju9N0ZY/3qoTtk+7aPo746/YMissL0+c+gVwdh2NJMDON6g/FF+LUvDyeqqRExyUBmFkAt6NWkhxCG3M3i5DHoKP8+TjEiSpajOyFunUZDUVBjurk5ApilMFQFfOrdIPkQy+CbiLGC4WsWEr2wUh+GurK8uxjg1w9h4zZpOZOgtyrhNI9IZlKT0RIftI9qlXaLG+LH68Q0QsJ9lUYCdFzsTPNGic+DlYnuCVDNg9QNbzcOOlxBBl+/1sDgAavFJ60zxhym/pk4f+ryK5g6uNn+8pzlG3wtFMD//L+VKG6uYEgziq7idFgR/MA==
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(2616005)(7636003)(86362001)(8936002)(70206006)(70586007)(54906003)(336012)(2906002)(6666004)(110136005)(316002)(426003)(8676002)(6636002)(83380400001)(4326008)(26005)(7696005)(36860700001)(1076003)(508600001)(82310400003)(356005)(186003)(47076005)(107886003)(5660300002)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2021 09:48:43.3581
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 61371716-5dd2-4c9c-3df5-08d98e2ea4d8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT020.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2766
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use mlx5_vf_get_core_dev() to get PF device instead of accessing
directly the PF data structure from the VF one.

The mlx5_vf_get_core_dev() API in its turn uses the generic PCI API
(i.e. pci_iov_get_pf_drvdata) to get it.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c | 27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 5c7d2a953dbd..97b8917bc34d 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -1445,7 +1445,10 @@ static virtio_net_ctrl_ack handle_ctrl_mac(struct mlx5_vdpa_dev *mvdev, u8 cmd)
 	size_t read;
 	u8 mac[ETH_ALEN];
 
-	pfmdev = pci_get_drvdata(pci_physfn(mvdev->mdev->pdev));
+	pfmdev = mlx5_vf_get_core_dev(mvdev->mdev->pdev);
+	if (!pfmdev)
+		return status;
+
 	switch (cmd) {
 	case VIRTIO_NET_CTRL_MAC_ADDR_SET:
 		read = vringh_iov_pull_iotlb(&cvq->vring, &cvq->riov, (void *)mac, ETH_ALEN);
@@ -1479,6 +1482,7 @@ static virtio_net_ctrl_ack handle_ctrl_mac(struct mlx5_vdpa_dev *mvdev, u8 cmd)
 		break;
 	}
 
+	mlx5_vf_put_core_dev(pfmdev);
 	return status;
 }
 
@@ -2261,8 +2265,11 @@ static void mlx5_vdpa_free(struct vdpa_device *vdev)
 	free_resources(ndev);
 	mlx5_vdpa_destroy_mr(mvdev);
 	if (!is_zero_ether_addr(ndev->config.mac)) {
-		pfmdev = pci_get_drvdata(pci_physfn(mvdev->mdev->pdev));
-		mlx5_mpfs_del_mac(pfmdev, ndev->config.mac);
+		pfmdev = mlx5_vf_get_core_dev(mvdev->mdev->pdev);
+		if (pfmdev) {
+			mlx5_mpfs_del_mac(pfmdev, ndev->config.mac);
+			mlx5_vf_put_core_dev(pfmdev);
+		}
 	}
 	mlx5_vdpa_free_resources(&ndev->mvdev);
 	mutex_destroy(&ndev->reslock);
@@ -2449,8 +2456,11 @@ static int mlx5_vdpa_dev_add(struct vdpa_mgmt_dev *v_mdev, const char *name)
 		goto err_mtu;
 
 	if (!is_zero_ether_addr(config->mac)) {
-		pfmdev = pci_get_drvdata(pci_physfn(mdev->pdev));
+		pfmdev = mlx5_vf_get_core_dev(mdev->pdev);
+		if (!pfmdev)
+			goto err_mtu;
 		err = mlx5_mpfs_add_mac(pfmdev, config->mac);
+		mlx5_vf_put_core_dev(pfmdev);
 		if (err)
 			goto err_mtu;
 
@@ -2497,8 +2507,13 @@ static int mlx5_vdpa_dev_add(struct vdpa_mgmt_dev *v_mdev, const char *name)
 err_res:
 	mlx5_vdpa_free_resources(&ndev->mvdev);
 err_mpfs:
-	if (!is_zero_ether_addr(config->mac))
-		mlx5_mpfs_del_mac(pfmdev, config->mac);
+	if (!is_zero_ether_addr(config->mac)) {
+		pfmdev = mlx5_vf_get_core_dev(mdev->pdev);
+		if (pfmdev) {
+			mlx5_mpfs_del_mac(pfmdev, config->mac);
+			mlx5_vf_put_core_dev(pfmdev);
+		}
+	}
 err_mtu:
 	mutex_destroy(&ndev->reslock);
 	put_device(&mvdev->vdev.dev);
-- 
2.18.1

