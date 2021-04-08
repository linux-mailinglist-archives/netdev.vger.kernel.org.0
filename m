Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD22357EE3
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 11:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231133AbhDHJOp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 05:14:45 -0400
Received: from mail-bn8nam11on2046.outbound.protection.outlook.com ([40.107.236.46]:13312
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230296AbhDHJOk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 05:14:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LpXfhkO2bdIQV85mXAbfFkwlLV2KEydSh6e5+p4R7VqiguyFI9auEKPmmLSrZZD2lL2tFKZ1efYzt0+tM28CUEHNxSaiR8acsGWsAuxhytdaioNyfZxiWmSNd3DN3ZEsIf6IBRIwtZGAePgSbAYy36IYq+osMKZHXC8KFOmk3cD80F0IGqvIbN5gCuhbstKRC/lxkg8QS9mLLSb4y1OXVcSNePe9ii3S73x37wnxJEQvpF0s5S5p/1+AAZshvbjk1LrDJY4vWMruKUT1Pvkd0G87/8L1deloHhoGFObeOyvDpLuynNtl0IzJ9i0GmMEqMx8/Tu3V0rP8Kz1f0gvaCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xciv+AIHVQSazpL/zDkghbmQZSeV6AMNrwo8kxqqcLE=;
 b=dxd1ShTYwJayKBrB8RMPYcebCtgwH6A7m/pXc0zSPAEoKNQKuFEi4oNtY+QyfiB/YmB1TOpTka3jBU3rIT/DkpdXGHaBMCMlZ4WYTk17K6K8cNTcqg8FETkUYUwDiFKXkjuYqKWDQ3B0uXud1wLywEFZP3mSNNzNzvqMcNm8qv7G12UCnE3A2kktdhHUi/Qm+LbZnMIiGVapAk1VdxyzIuKcF9rNwJjSc+wLHTBJDz+Hpf8QM7fWfQr51qwRIFTShSwM7fJ97++x+jWRAAaLTOthWzBjVH9OeAovmBJPIcmd8if2iEtRUzVYxJc/WYj5HVGiBAnNFU4i5bUmL5k26g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=lists.linux-foundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xciv+AIHVQSazpL/zDkghbmQZSeV6AMNrwo8kxqqcLE=;
 b=PqYpvPAvkGW67spJiL8SS7OTQfzFwcMJVExRcgxsZJP5O/0d0mTT+lTeAxmk0SsDkZvVIDY/qBUEmlsGZz8+n5QQiaqer3AepTB/s2vjM0BotlR7bBqOb0/HViK/11NC57F6fjSkbxhJwO2TGFAqNzrJMUV8Hzh5wpGm27UDah1zZfUMN5Kw2TbSuGbRLLzL0wfWlKqP43qjlaegCvNZw1B4zRZAqxp9/n4Ut/6SsO8do22FHj0AlOOkfqip6N+BWjHNs1ZMMl+puX2sA7A8G5iceG6L2/VmNNuXZvDBc0fKeXJfd+x6k7G6uabEaq1yL2313bMSMlmBOlvfODcC9A==
Received: from MW4PR03CA0147.namprd03.prod.outlook.com (2603:10b6:303:8c::32)
 by BN8PR12MB3188.namprd12.prod.outlook.com (2603:10b6:408:6b::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Thu, 8 Apr
 2021 09:14:27 +0000
Received: from CO1NAM11FT043.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8c:cafe::94) by MW4PR03CA0147.outlook.office365.com
 (2603:10b6:303:8c::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend
 Transport; Thu, 8 Apr 2021 09:14:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; lists.linux-foundation.org; dkim=none (message not
 signed) header.d=none;lists.linux-foundation.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 CO1NAM11FT043.mail.protection.outlook.com (10.13.174.193) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4020.17 via Frontend Transport; Thu, 8 Apr 2021 09:14:26 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 8 Apr
 2021 09:14:26 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 8 Apr 2021 09:14:24 +0000
From:   Eli Cohen <elic@nvidia.com>
To:     <mst@redhat.com>, <jasowang@redhat.com>, <parav@nvidia.com>,
        <si-wei.liu@oracle.com>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>
CC:     <elic@nvidia.com>
Subject: [PATCH] vdpa/mlx5: Enable user to add/delete vdpa device
Date:   Thu, 8 Apr 2021 12:13:21 +0300
Message-ID: <20210408091320.4600-1-elic@nvidia.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b3b6f914-b76c-467b-08cf-08d8fa6eb54c
X-MS-TrafficTypeDiagnostic: BN8PR12MB3188:
X-Microsoft-Antispam-PRVS: <BN8PR12MB31884D17ED844B2D11864162AB749@BN8PR12MB3188.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9Z9YZtzSJglHPGDhHY/4vf+geFLF/vMGYH/0ls5RyQLIXbfE4b76x6g9mCKNxvBfJ7PhDtkS7LSvHukEqcwEdPHTsgWTVL/L5keVbZi5zbFk1QiMkdcwVhWoblmRhMshgqP8QgG7EhyT1vHRiMnja8l2DfppqrUYShBWu6xXdVtg9FhG/Zje8g86Oz2JS0LHPpGfK7R1csg3hCCBjEX/nK7qaWDXAxWhYgn/FivbRwf2aSDluNyAYq5DUAxWVlNJ0uf3LONYV+J4UN6DUl1u/uDGrgeqqqydwLrzDg9tD1ZVsc/50K0UdcO2EgcUwd+gKUGJhqwwA3HvOFvsnqGR2tVnMeR/zoHtSyosPZeadaOP9XTcl1gmOvlm7LVnVgk2oiyYyRmm0elqR9JvZZNoqjUzqPnBy6mrhWpYpxvCVal5FJYqfeTKfpY6W8CYOQyOPS+sYZ6rgAUrIkKY0UVl+az0EM5lIxxGYMdmpPi8T9h+a9CE+5VjMSGQdSvtoV2WAiSh88bNtAzfrDOEuqSeci/Pwtbq/d4ZpXypab/99ppEtTVVzdqbu0FldqRDDIJm9P8yOHMuTDPy9KXIsHQpLkYo13PckZS/wKAhJcyKNneAE/g27vRUBp7lwNdItT3HNaO8Knj6GxKFiRPuE2RYKYrQcHFtSDdZjLbsN9CwS8E=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(39860400002)(376002)(46966006)(36840700001)(336012)(6666004)(70206006)(47076005)(2906002)(478600001)(86362001)(426003)(82310400003)(36860700001)(83380400001)(356005)(36756003)(1076003)(7636003)(70586007)(7696005)(107886003)(82740400003)(316002)(26005)(8676002)(36906005)(2616005)(4326008)(110136005)(5660300002)(186003)(8936002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2021 09:14:26.6971
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b3b6f914-b76c-467b-08cf-08d8fa6eb54c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT043.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3188
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow to control vdpa device creation and destruction using the vdpa
management tool.

Examples:
1. List the management devices
$ vdpa mgmtdev show
pci/0000:3b:00.1:
  supported_classes net

2. Create vdpa instance
$ vdpa dev add mgmtdev pci/0000:3b:00.1 name vdpa0

3. Show vdpa devices
$ vdpa dev show
vdpa0: type network mgmtdev pci/0000:3b:00.1 vendor_id 5555 max_vqs 16 \
max_vq_size 256

Signed-off-by: Eli Cohen <elic@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---

This patch is just a resend of rebased version over the previous fixes
sent by me minutes ago.

 drivers/vdpa/mlx5/net/mlx5_vnet.c | 79 +++++++++++++++++++++++++++----
 1 file changed, 70 insertions(+), 9 deletions(-)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 4d2809c7d4e3..10c5fef3c020 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -1974,23 +1974,32 @@ static void init_mvqs(struct mlx5_vdpa_net *ndev)
 	}
 }
 
-static int mlx5v_probe(struct auxiliary_device *adev,
-		       const struct auxiliary_device_id *id)
+struct mlx5_vdpa_mgmtdev {
+	struct vdpa_mgmt_dev mgtdev;
+	struct mlx5_adev *madev;
+	struct mlx5_vdpa_net *ndev;
+};
+
+static int mlx5_vdpa_dev_add(struct vdpa_mgmt_dev *v_mdev, const char *name)
 {
-	struct mlx5_adev *madev = container_of(adev, struct mlx5_adev, adev);
-	struct mlx5_core_dev *mdev = madev->mdev;
+	struct mlx5_vdpa_mgmtdev *mgtdev = container_of(v_mdev, struct mlx5_vdpa_mgmtdev, mgtdev);
 	struct virtio_net_config *config;
 	struct mlx5_vdpa_dev *mvdev;
 	struct mlx5_vdpa_net *ndev;
+	struct mlx5_core_dev *mdev;
 	u32 max_vqs;
 	int err;
 
+	if (mgtdev->ndev)
+		return -ENOSPC;
+
+	mdev = mgtdev->madev->mdev;
 	/* we save one virtqueue for control virtqueue should we require it */
 	max_vqs = MLX5_CAP_DEV_VDPA_EMULATION(mdev, max_num_virtio_queues);
 	max_vqs = min_t(u32, max_vqs, MLX5_MAX_SUPPORTED_VQS);
 
 	ndev = vdpa_alloc_device(struct mlx5_vdpa_net, mvdev.vdev, mdev->device, &mlx5_vdpa_ops,
-				 NULL);
+				 name);
 	if (IS_ERR(ndev))
 		return PTR_ERR(ndev);
 
@@ -2017,11 +2026,12 @@ static int mlx5v_probe(struct auxiliary_device *adev,
 	if (err)
 		goto err_res;
 
-	err = vdpa_register_device(&mvdev->vdev, 2 * mlx5_vdpa_max_qps(max_vqs));
+	mvdev->vdev.mdev = &mgtdev->mgtdev;
+	err = _vdpa_register_device(&mvdev->vdev, 2 * mlx5_vdpa_max_qps(max_vqs));
 	if (err)
 		goto err_reg;
 
-	dev_set_drvdata(&adev->dev, ndev);
+	mgtdev->ndev = ndev;
 	return 0;
 
 err_reg:
@@ -2034,11 +2044,62 @@ static int mlx5v_probe(struct auxiliary_device *adev,
 	return err;
 }
 
+static void mlx5_vdpa_dev_del(struct vdpa_mgmt_dev *v_mdev, struct vdpa_device *dev)
+{
+	struct mlx5_vdpa_mgmtdev *mgtdev = container_of(v_mdev, struct mlx5_vdpa_mgmtdev, mgtdev);
+
+	_vdpa_unregister_device(dev);
+	mgtdev->ndev = NULL;
+}
+
+static const struct vdpa_mgmtdev_ops mdev_ops = {
+	.dev_add = mlx5_vdpa_dev_add,
+	.dev_del = mlx5_vdpa_dev_del,
+};
+
+static struct virtio_device_id id_table[] = {
+	{ VIRTIO_ID_NET, VIRTIO_DEV_ANY_ID },
+	{ 0 },
+};
+
+static int mlx5v_probe(struct auxiliary_device *adev,
+		       const struct auxiliary_device_id *id)
+
+{
+	struct mlx5_adev *madev = container_of(adev, struct mlx5_adev, adev);
+	struct mlx5_core_dev *mdev = madev->mdev;
+	struct mlx5_vdpa_mgmtdev *mgtdev;
+	int err;
+
+	mgtdev = kzalloc(sizeof(*mgtdev), GFP_KERNEL);
+	if (!mgtdev)
+		return -ENOMEM;
+
+	mgtdev->mgtdev.ops = &mdev_ops;
+	mgtdev->mgtdev.device = mdev->device;
+	mgtdev->mgtdev.id_table = id_table;
+	mgtdev->madev = madev;
+
+	err = vdpa_mgmtdev_register(&mgtdev->mgtdev);
+	if (err)
+		goto reg_err;
+
+	dev_set_drvdata(&adev->dev, mgtdev);
+
+	return 0;
+
+reg_err:
+	kfree(mdev);
+	return err;
+}
+
 static void mlx5v_remove(struct auxiliary_device *adev)
 {
-	struct mlx5_vdpa_dev *mvdev = dev_get_drvdata(&adev->dev);
+	struct mlx5_vdpa_mgmtdev *mgtdev;
 
-	vdpa_unregister_device(&mvdev->vdev);
+	mgtdev = dev_get_drvdata(&adev->dev);
+	vdpa_mgmtdev_unregister(&mgtdev->mgtdev);
+	kfree(mgtdev);
 }
 
 static const struct auxiliary_device_id mlx5v_id_table[] = {
-- 
2.30.1

