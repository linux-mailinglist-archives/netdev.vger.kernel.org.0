Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F28AA42BC15
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 11:49:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239224AbhJMJvx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 05:51:53 -0400
Received: from mail-mw2nam10on2053.outbound.protection.outlook.com ([40.107.94.53]:48001
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239276AbhJMJvM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 05:51:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KxTFhrKZeNySGFtQk93SFCil8VqccG0uWcXs+4LKRpczGoE7VDfjIlF6+PLG0Rqw/FEItH5mNfaG5r5ZpJFyD1WvEYa/fWmdSO14uQbOCPcMKbA8DQTeqAuTE04syMu7QLgCDTDsnP1thgenTzoAApFwX8sBgOLgcaJUAoR88xfYLQ0PnUyMzO3h411aHayUDTHcGfsWcW6Ofv7GoPyqas1/9VCsw6uknRakLXQHYhhDsPBrZ9VWqXSXnxtnsFt/OpIQu6hCyrN6xWVne3glIgPBDnoeljl2nda6Sq1mmXCEOMHaF15TrcgjGxopQwUnmv3ItCvpcVUD8OkdOS6PcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nKZ06M5DEgvv5Hcnlj5KjV4W4F5oErEUIFUptUE7ncA=;
 b=Ds+S4eciEF5P0AjQFB+3pZ64apkiPsjP6rOOvYPV1hAZUwjhP22YBwq5AC4U/hA1jmHpJ4nvvcDYpzPWuVYU30tG7YVuQ6jTzBegOR9lehmPviFP5n3VZ5cQpAWNqd81raVUVGzXyl6MXI/H/N4y5sr82+h4aZT6uQ5QWrWk8kOIzGYjx4jqvvNq6pVxkyzHMXFHbFM8rWA3NUIntI+IAEywyLxbV1b3JIY4e/7G40pIT6IZnGc4spbYu73+fzlZJydQgje628c3ftG5RuDCPerWpjAgUUgYHn9FZKpVKvijvUGhLlabb2Hn70jYBqJtCZFsMTgQbzR2Dfv6ZsHoTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nKZ06M5DEgvv5Hcnlj5KjV4W4F5oErEUIFUptUE7ncA=;
 b=JrU6SCNlLAijcrMN/eb2eoqeDIaHB09T6MNVuG1IXKJQ8sf806nFUhzlzYEkzxuHL18/5MCy+BFGod239G0XTVnr1/Hqfuhk1GdOp4B0zjpH+wGvxEKWc0kMyUs+cDwNhwwvnIXfKIRFznTKM9cr/iPBmTRRb+YdPDSlntXKSfh4p9mJ/SS18pIqmLYVKqSJ+ycCenEcwPmOStGTzu2PyemvAoVAOD1vv5GFuL2Yi5atm0fMkaVuFCOPOV8xHN8JwGrlFq8bTneMQYgT9HXLRPcjb5Zi7XEHweX89tvbHNGLhL45CX/FZfJBWDOk5fNOesaWlN/zSyBRtuKfQuQbBQ==
Received: from BN1PR10CA0015.namprd10.prod.outlook.com (2603:10b6:408:e0::20)
 by BYAPR12MB2856.namprd12.prod.outlook.com (2603:10b6:a03:136::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Wed, 13 Oct
 2021 09:49:07 +0000
Received: from BN8NAM11FT057.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e0:cafe::8a) by BN1PR10CA0015.outlook.office365.com
 (2603:10b6:408:e0::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.25 via Frontend
 Transport; Wed, 13 Oct 2021 09:49:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT057.mail.protection.outlook.com (10.13.177.49) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4608.15 via Frontend Transport; Wed, 13 Oct 2021 09:49:07 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 13 Oct
 2021 02:49:06 -0700
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 13 Oct
 2021 09:49:06 +0000
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 13 Oct 2021 09:49:03 +0000
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V1 mlx5-next 13/13] vfio/mlx5: Trap device RESET and update state accordingly
Date:   Wed, 13 Oct 2021 12:47:07 +0300
Message-ID: <20211013094707.163054-14-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20211013094707.163054-1-yishaih@nvidia.com>
References: <20211013094707.163054-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 81131ce4-bd74-413e-d1d1-08d98e2eb34e
X-MS-TrafficTypeDiagnostic: BYAPR12MB2856:
X-Microsoft-Antispam-PRVS: <BYAPR12MB28567F51ED26E86485E72E93C3B79@BYAPR12MB2856.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:883;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EWHUVaRj5D6uMMWJo3p/mDDuLzzdRu0/tJaCSbYemmN10Ya/+ZI38c3YYGPV1+oxOfwlxDFTuiYuU65rvgbzz/WyizPWFh4n+LthESannaQU/ZKCRbR9vCMPUskXhXq1r3DBSBpuEWCnorwQeH6ExY6rd9DMdDTu6jp331bCVPqZnPyhXuNZ2zGw0BQLQE9fpbgLpR+1A4Wq3eWrJmCpIZr0eYczWay+20G0ir0vdLyQ0YzfR+9WVcC3u8Rs2EJxx3EGb+MWg/M2OZJDDEuQSVKYkA2Pmk4pD5HV/CAiyabO0rn6rS68uUPTjySKgRwJ9LGwF+5KqOgNpiT1MfKXXrK3wi+GloryXcgKvVcYAcmS3efBwlYInnepX5Qakqr6T+sIUtOcVahZEzOZH/ymCHmn5hdIQTXVAiB1X0KmWYBNFL/7GRUQeXx7Jp9Fe9nalSGXj7vVKj7ClCS3w+HuEKSjrstnH6agZet1AyjeZ9KSdKU+S7g51mPI0Ajs6sB6pLNbsF6CjtUv+cA6niigkRHPvvv0NGYqxyJqRbOur6UVfFFK/BpBXMicfqscENE7+wP2Y0yx7YBf/dmODVmzez5hkrs2S+iyxCCPVTOnAvsRIFciVXsYs6ovqpZ0vXB0raw2kHhmWN9+boQhH/7zlHxbS6Q5h+/2RgjOeITduEKwvWUNjBbKdi/hfHCXgLx1RtbrvslooSFHjDMve09WCA==
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(70206006)(36756003)(82310400003)(508600001)(8936002)(316002)(2906002)(36860700001)(2616005)(7696005)(8676002)(426003)(110136005)(4326008)(54906003)(6636002)(70586007)(5660300002)(83380400001)(86362001)(1076003)(26005)(356005)(7636003)(336012)(186003)(15650500001)(47076005)(107886003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2021 09:49:07.5776
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 81131ce4-bd74-413e-d1d1-08d98e2eb34e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT057.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2856
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Trap device RESET and update state accordingly, it's done by registering
the matching callbacks.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/vfio/pci/mlx5/main.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index e36302b444a6..8fe44ed13552 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -613,6 +613,19 @@ static const struct vfio_device_ops mlx5vf_pci_ops = {
 	.match = vfio_pci_core_match,
 };
 
+static void mlx5vf_reset_done(struct vfio_pci_core_device *core_vdev)
+{
+	struct mlx5vf_pci_core_device *mvdev = container_of(
+			core_vdev, struct mlx5vf_pci_core_device,
+			core_device);
+
+	mvdev->vmig.vfio_dev_state = VFIO_DEVICE_STATE_RUNNING;
+}
+
+static const struct vfio_pci_core_device_ops mlx5vf_pci_core_ops = {
+	.reset_done = mlx5vf_reset_done,
+};
+
 static int mlx5vf_pci_probe(struct pci_dev *pdev,
 			    const struct pci_device_id *id)
 {
@@ -629,8 +642,10 @@ static int mlx5vf_pci_probe(struct pci_dev *pdev,
 			mlx5_vf_get_core_dev(pdev);
 
 		if (mdev) {
-			if (MLX5_CAP_GEN(mdev, migration))
+			if (MLX5_CAP_GEN(mdev, migration)) {
 				mvdev->migrate_cap = 1;
+				mvdev->core_device.ops = &mlx5vf_pci_core_ops;
+			}
 			mlx5_vf_put_core_dev(mdev);
 		}
 	}
-- 
2.18.1

