Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F161357ECD
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 11:11:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230482AbhDHJLW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 05:11:22 -0400
Received: from mail-co1nam11on2069.outbound.protection.outlook.com ([40.107.220.69]:42949
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230449AbhDHJLT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 05:11:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OyQGYlA0fAalmg9IlOQwR0D5B79D2DT0vYFeGgz7ZqY0P09fd564Ka2oIBrm+bUPu3YRwlDx2DihyCX3RJ4ViZ9K50Z9PonHPF0wtF8SSNNzM0jNyaLi5lAmjGvLskiEx5IBO04Q1JLXMM84odG663BcLW/LPkys9RUWGHUss2VkmDV+VLswjzXSeeaQEuEwwqJiH0jxX/Kt+9y2/v3Sq229B1dgDxx6nMFiTjWx2m26dhq7Jfw9OEHW+QBHKC1sg2XzJONgYcy9tfi93inHX4WinTB+TePUSftgfST52WEUOLfHwwIts3uDgEqP/xQXFdt3RDAoo5hZ9DlYLEdadQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EUJPeEytsGu0gw6qqiqt0uGDmdO78mW7KcsR+Ob/Wxw=;
 b=Yx0xoyZXaBu3KWN3VGHynWqVSRQOyXw7tB845HsgMY9Sb9/SWlknbfMSsvi+WwnkUFQUYSCFMe9PN2fEG7/6A2c99ugCPJOCT8fjz5c51zKZKbA6FdrUrGCU6qI46rFTQpa4UqjrY7kzJfSm9NG3QK0fzsHn+kKXyKODpzUI/el3EbJ76/FXM91FGkKaKOelrHB1h8s2Z6yTl7nSu80B0pPiZZ8HNVyuLiyP2/Yzkw26LWlf/IkTWGHx+xNTIwWUWDAf+0m1blPyaz7cVcDP6m5/Kfu7PZVcshbPVjER4jehkSqNbVDj12KOhdAdv2ft+tGcciTkBZju12VU0g1DCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=lists.linux-foundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EUJPeEytsGu0gw6qqiqt0uGDmdO78mW7KcsR+Ob/Wxw=;
 b=nWhVfsCCUS9x7fuj8d3WtEbEKd1hYza+Z5fdMVUYltNx35h6GXbJO5PHieRsl1r1e2yTY/wSZiX6Pii5d1PvLgtRNCSsCIyl0/Fis2iV/eBMPEqbCqoP93eA90BKgKty2zkpZOYo/JSMyA8bINTjQlfbSXWmot65TGKdatOumZz4WFNGcvRW12RCTIo3X0BDy9j/9xWikr8AqLwFz+czuIt+TDOZxJ4GHowgm4B3g9Bp7d5BIUQAWRX/sjOmgHzU9Bi45V5Y0MlU4UTUTg2cf4aiGpcGy4CdeuQrWF36+DU0wpcqys3KWOuBP1Sgws6zcMb+ckw7eiGV3UyS2440Dw==
Received: from MWHPR13CA0032.namprd13.prod.outlook.com (2603:10b6:300:95::18)
 by MWHPR12MB1262.namprd12.prod.outlook.com (2603:10b6:300:12::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Thu, 8 Apr
 2021 09:11:06 +0000
Received: from CO1NAM11FT012.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:95:cafe::b9) by MWHPR13CA0032.outlook.office365.com
 (2603:10b6:300:95::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.6 via Frontend
 Transport; Thu, 8 Apr 2021 09:11:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; lists.linux-foundation.org; dkim=none (message not
 signed) header.d=none;lists.linux-foundation.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 CO1NAM11FT012.mail.protection.outlook.com (10.13.175.192) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4020.17 via Frontend Transport; Thu, 8 Apr 2021 09:11:06 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 8 Apr
 2021 02:11:05 -0700
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 8 Apr 2021 09:11:03 +0000
From:   Eli Cohen <elic@nvidia.com>
To:     <mst@redhat.com>, <jasowang@redhat.com>, <parav@nvidia.com>,
        <si-wei.liu@oracle.com>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>
CC:     <stable@vger.kernel.org>, Eli Cohen <elic@nvidia.com>
Subject: [PATCH 5/5] vdpa/mlx5: Fix suspend/resume index restoration
Date:   Thu, 8 Apr 2021 12:10:47 +0300
Message-ID: <20210408091047.4269-6-elic@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210408091047.4269-1-elic@nvidia.com>
References: <20210408091047.4269-1-elic@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d9492701-4250-46ba-4545-08d8fa6e3dd5
X-MS-TrafficTypeDiagnostic: MWHPR12MB1262:
X-Microsoft-Antispam-PRVS: <MWHPR12MB1262AFE4FBC15465C77480B7AB749@MWHPR12MB1262.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bSzaUJEl8/o9Q3uOciYOoJ8/aRO1B96V+KbeqEzUe6hp49y7ljF/8r+1Idi83DEiKApGUlvi8nGR+38HgS5VyGb2Z0rNoX0e7TyHUrw2NClkgdOrDHhZ/YvgUmi5xdvWPJOduNyJgJYWOgUjNcpTg0528zwpnnY1YCNDMOjFMjf0EXBogaBn/cnhqPyWLR6K4cIcm7bPEvlewlMMO2+o7TrBT3mFBGQdearwPmb2+2jBdjRh9wZRFOmFn8sPuWcf0S9TJKQq/4hvuZccUXMkwpWNItQeK3BsM6LuBeCls99Z5sJB6+SA5dsr+orSV0J4Rm0lyhHLeUfvKLFUj5GhtQhNi4oUbobgTHhCzzuamKU7Y64wmVqX/0QwuyEZ4T5AKRuBVmAfyArYP0O1cBIxUCQn6wPO1PZcokbrK8dna3cYHWHYr/38HBRXJM/3dc/Ci9VUjPRmV44G4ahH4UI3TR1yTGzukpDfAveBQhvVgL2TusWj5dOlqsqnT4l7mFtIuzZavAxIDN+NspIk18NSArk55E7/BWucZJi/9aiXzUoTsLK9AIZuhDMrzHMdMuAVeqnnN25EMnxLzaPCbt7oC4hCjnqenFfSoyxr8w63WB5dijsJMn+0C4zndCUI+YSaCvC3pgbdu5rZlJh6fanzSkJwHVkBRtnfqkmzoU+5nqI=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(346002)(376002)(396003)(136003)(36840700001)(46966006)(26005)(478600001)(8936002)(2906002)(8676002)(70586007)(47076005)(4326008)(86362001)(316002)(7636003)(6666004)(83380400001)(5660300002)(186003)(70206006)(7696005)(426003)(336012)(2616005)(1076003)(36756003)(82310400003)(107886003)(36860700001)(15650500001)(356005)(110136005)(54906003)(82740400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2021 09:11:06.2389
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d9492701-4250-46ba-4545-08d8fa6e3dd5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT012.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1262
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we suspend the VM, the VDPA interface will be reset. When the VM is
resumed again, clear_virtqueues() will clear the available and used
indices resulting in hardware virqtqueue objects becoming out of sync.
We can avoid this function alltogether since qemu will clear them if
required, e.g. when the VM went through a reboot.

Moreover, since the hw available and used indices should always be
identical on query and should be restored to the same value same value
for virtqueues that complete in order, we set the single value provided
by set_vq_state(). In get_vq_state() we return the value of hardware
used index.

Fixes: b35ccebe3ef7 ("vdpa/mlx5: Restore the hardware used index after change map")
Fixes: 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for supported mlx5 devices")
Signed-off-by: Eli Cohen <elic@nvidia.com>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 6fe61fc57790..4d2809c7d4e3 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -1169,6 +1169,7 @@ static void suspend_vq(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *m
 		return;
 	}
 	mvq->avail_idx = attr.available_index;
+	mvq->used_idx = attr.used_index;
 }
 
 static void suspend_vqs(struct mlx5_vdpa_net *ndev)
@@ -1426,6 +1427,7 @@ static int mlx5_vdpa_set_vq_state(struct vdpa_device *vdev, u16 idx,
 		return -EINVAL;
 	}
 
+	mvq->used_idx = state->avail_index;
 	mvq->avail_idx = state->avail_index;
 	return 0;
 }
@@ -1443,7 +1445,11 @@ static int mlx5_vdpa_get_vq_state(struct vdpa_device *vdev, u16 idx, struct vdpa
 	 * that cares about emulating the index after vq is stopped.
 	 */
 	if (!mvq->initialized) {
-		state->avail_index = mvq->avail_idx;
+		/* Firmware returns a wrong value for the available index.
+		 * Since both values should be identical, we take the value of
+		 * used_idx which is reported correctly.
+		 */
+		state->avail_index = mvq->used_idx;
 		return 0;
 	}
 
@@ -1452,7 +1458,7 @@ static int mlx5_vdpa_get_vq_state(struct vdpa_device *vdev, u16 idx, struct vdpa
 		mlx5_vdpa_warn(mvdev, "failed to query virtqueue\n");
 		return err;
 	}
-	state->avail_index = attr.available_index;
+	state->avail_index = attr.used_index;
 	return 0;
 }
 
@@ -1540,16 +1546,6 @@ static void teardown_virtqueues(struct mlx5_vdpa_net *ndev)
 	}
 }
 
-static void clear_virtqueues(struct mlx5_vdpa_net *ndev)
-{
-	int i;
-
-	for (i = ndev->mvdev.max_vqs - 1; i >= 0; i--) {
-		ndev->vqs[i].avail_idx = 0;
-		ndev->vqs[i].used_idx = 0;
-	}
-}
-
 /* TODO: cross-endian support */
 static inline bool mlx5_vdpa_is_little_endian(struct mlx5_vdpa_dev *mvdev)
 {
@@ -1785,7 +1781,6 @@ static void mlx5_vdpa_set_status(struct vdpa_device *vdev, u8 status)
 	if (!status) {
 		mlx5_vdpa_info(mvdev, "performing device reset\n");
 		teardown_driver(ndev);
-		clear_virtqueues(ndev);
 		mlx5_vdpa_destroy_mr(&ndev->mvdev);
 		ndev->mvdev.status = 0;
 		ndev->mvdev.mlx_features = 0;
-- 
2.30.1

