Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39450433420
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 12:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235397AbhJSLB4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 07:01:56 -0400
Received: from mail-dm3nam07on2086.outbound.protection.outlook.com ([40.107.95.86]:27329
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235315AbhJSLBt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 07:01:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cTMdLuGwA1qItbUdQZN12oP9I3cgsjc7pNUio+JTLw24VT6S7GhaShcHfiJVnoPehugbXQPtGbL651pqsbAYVvLFloUeMe36ZFZCETFYAu1ZLq3sBbfHhQ+43bNxEsH+4+ABHTIFMtw4x2GmGLqkyEhcMkPcPUr88H5XlCT5mSwp/BkHinEibHx9P4p3Z7TR5NFk/vLyF4xBsznanoiHp3OmzvJXYoM7r1MlMHDQU0+b1ydS4ViuEPmqYo3kE2oi81+CD6OOVq5HbyK2Q6HdGKnpme9RpWivMlF8DjCleJH1NY4/1FDSix0Uqsa2RLSNfk/3+9DdcDrZzLvf8vuVDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C89Jlk8BDEI17QHQ1FU/2vPIIO2h4K4F/VMusgvFzJI=;
 b=nW4xlz5Cgj0akhqelWDoWToszzwiargfR44rZMihxnAdBw9ep53v9fBfMTvg3+Fza++VG/u/MV7PqOYE8FZ0WqDvtfxX8VRrGa/r4v81KziCsgRN9qn25iduv0wGMMyz2RU4sTtfeWX7TB9MypUdeoFCX5kY7y1VFu0m8ohxYiriitUdRnsDmzOtTGAg+ZgX/CsF6rXu9syC591sV4QluQVJkyzxZ6beziixyYBHeeXqNGCT7eIUxFkFgwMAK7kXF3KIA3EwIujULkwKo26ov9yDvLiRwqIFQ+7GcphRp7gIW2qyom/1x1dbWaFLjQ+6Dwip/FAZaYHio3StK2Op7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C89Jlk8BDEI17QHQ1FU/2vPIIO2h4K4F/VMusgvFzJI=;
 b=HQqj4sf+Zff21UJX1eoEsOXq90YCCO02rVzqghXwgdHzr/elYt0yRLIof8dlRuU+dAPXsNSfj/xt2tLGk0WjGfxCu8y3NhQ6dyoEKfHdr1nQ+wk+RY7Drk4ZDXFtTtTSdhd6ne/hNuqzTTmVEctnmbsjYm3Ra7d/gHLykkuiU7jg8RsqSvldjpOiQV3OgGCfW4I6Btmhprmr2G1OLmoRV+q+/Ul/eOUKwati3XbZzCFrfv4cgqSvU5pVdmt2zkOyIKHKmHKJk8oDdf4iZV/T0lLvXgRDnAyM7MK5USd0ZSpJB9xOO01nt5x9lpGSn1klItoh37j1gUGR03Dl+le62Q==
Received: from BN0PR04CA0018.namprd04.prod.outlook.com (2603:10b6:408:ee::23)
 by MWHPR12MB1536.namprd12.prod.outlook.com (2603:10b6:301:6::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Tue, 19 Oct
 2021 10:59:34 +0000
Received: from BN8NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ee:cafe::3f) by BN0PR04CA0018.outlook.office365.com
 (2603:10b6:408:ee::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16 via Frontend
 Transport; Tue, 19 Oct 2021 10:59:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT010.mail.protection.outlook.com (10.13.177.53) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4608.15 via Frontend Transport; Tue, 19 Oct 2021 10:59:33 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 19 Oct
 2021 03:59:30 -0700
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 19 Oct 2021 10:59:27 +0000
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V2 mlx5-next 06/14] vdpa/mlx5: Use mlx5_vf_get_core_dev() to get PF device
Date:   Tue, 19 Oct 2021 13:58:30 +0300
Message-ID: <20211019105838.227569-7-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20211019105838.227569-1-yishaih@nvidia.com>
References: <20211019105838.227569-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2b0d1e82-748a-406c-8d39-08d992ef8890
X-MS-TrafficTypeDiagnostic: MWHPR12MB1536:
X-Microsoft-Antispam-PRVS: <MWHPR12MB1536C6F309DF0B27C6175288C3BD9@MWHPR12MB1536.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NGvEPwLbZ8L1IWS9S6UoDHV3sbm40hHfPcBlHAG41Q4yIO0RBysLUdQ1clinlB+riugUIBjV39+F/0fVcCxy8dv2ul50nOCdkTPWTBcyq53fDedUpiOx+JYbefEu+3ovuUxFRUM5Cd7xrLTl2MPw8i489V/3/bGHgT7OjDr7BAQUGJQn5m8h3m3xnFleUYwU0nnJ4RK2PMU8aGw/EtVXfsY/5rwrjST5RF48r6XiZ9OC+z8BdI7Mt9cTLVWup18irCsOeuWoZS2cYhbBHm2LWnucVuWD9l9wkN80HdljyhFLiep/0+z29/Up8r8utnjieGpwdaULebV2Tfco0EjjvpCecMhZ70qGjH2qx3yoURFBlKIDhVXSwbvImLuvLb6qV+sJde1FMpxX+PLKqoKIGwx0Wi8nd9qYQqLduCn1D6DH/QZeVF21ufLD2/WirhDWFFdDSUuGQHAyM2YTgzgTzJgOTaiW2EOAVtyNdHwJFYOvFcMF8iv7eqxfMkTVxHilyDRtaT8lMf+xgNPI26Cyo6zoIWb5UTfPFyCFAWg1KsEd0dP7MO1VS83ZmMLncca/i75bja60XUCu8r8r3nQgLAPmhJbTtPQ6g5jaiECB17d/stYWyNvy/JEDpBlO+D4Doc7gNz1s2UsCYDSqh82P/lAxLwm554zcgCIU00Wlbz79TEnt0LaPINA0d/5ytzmdk7qPs5svCozZvGfc3/ckIQ==
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(110136005)(107886003)(54906003)(8936002)(47076005)(7636003)(83380400001)(82310400003)(356005)(1076003)(8676002)(70206006)(36860700001)(26005)(508600001)(6636002)(36756003)(86362001)(2616005)(426003)(6666004)(336012)(7696005)(5660300002)(2906002)(70586007)(4326008)(316002)(186003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2021 10:59:33.0742
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b0d1e82-748a-406c-8d39-08d992ef8890
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1536
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

