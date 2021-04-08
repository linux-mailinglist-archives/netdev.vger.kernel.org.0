Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F6D7357EC8
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 11:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230444AbhDHJLS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 05:11:18 -0400
Received: from mail-bn8nam12on2075.outbound.protection.outlook.com ([40.107.237.75]:61792
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230337AbhDHJLO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 05:11:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UdKIzzvOu2pyZ0BGqg/QYrsxwY0WQipiIkFhSLDeO9YKrmQLEx5U2G151x3Z/P8sNIM97P6X2+KiSAZY3XJ8DAEJFea9rIkipfDLSKexbumvHn8lI1Rn7k+aBQr9TYU1jf1HpM6ui+uHbJm0046yivLT41xbvY7mj/f6vEwSAyafhaWpBadUqefnfzEC2DbPNflcshDJZhqiK7HslOTkLekC7Dx/4HiXCHYp5fTlzhUt9czR5VCo7YUv/aZwy8WNUMGBGnB3cwB8oYsHzeJIhXD3P3lmsx/sgr1hzD4FVmVY4emv1l0WnPovFbUYmagnZEc1roptLb4FS96cAYWL5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qUgRl9uLOAK4/xuQCxY5O1ZGYVGQ5zGngOpRYaNnMdA=;
 b=Lv9LZN9FRA0E5q3Fq1nGWLqwdL5p8hn9yNjdexjIgDzpU3TxqcJXPvkMGF+RQKGfrVrGrH58mWYmG4OPJCrknVUm716VSf0km8azEHwdZiN99GJa98K3oMcFOQZau5SDRDe9lBInU2Lh2L52OstKIOV+LgpH49S28NpOiavr6XYUofIWNGFuBApaV847RJOsd2wZwRudjev1Z6XXz8bd61aM8zd8N9eqC5uFKdHin4sG7YvNS8u++yTWCNBc1v1MVDSKWnqWszeX6i/7QJOkNdLCyKkrcuCaK4ErOdMcloOTKftv/fDWh0cZFj7eTt20qAB7QRAQdcZDtepN1rNs9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=lists.linux-foundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qUgRl9uLOAK4/xuQCxY5O1ZGYVGQ5zGngOpRYaNnMdA=;
 b=YhzzaomF6+SgiOO57lLXeamgGd536wOxdgBvkfY/jXRmmEo4v7RdhhK16lni54ihIKhT9dXHMurnLWORCOD4O+4O8jYynJBWnARwaA05UHwsZnltGw4DEC6NYyBRcsWKOeKe9/2c561q+rUcJaUkMDbVwMdbPNXLFYYVIbXx5dNENQSeLkXkawBSw2YNwwkeHgVvURyjGvwcNcQey5nC4RW9Ae96MoJBK0I17218KeNAjqZlHrAhcvNs5qd2/k6lEN7oAE1Bp+ZV1B01j8uTTkLH4ec4PrhOIdgQMMsY7GTDFNBTv5gUjJykIMRmFe0xIpM+nrD0p+FqJkDg8GB/Ew==
Received: from MWHPR04CA0062.namprd04.prod.outlook.com (2603:10b6:300:6c::24)
 by CY4PR12MB1509.namprd12.prod.outlook.com (2603:10b6:910:8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27; Thu, 8 Apr
 2021 09:11:01 +0000
Received: from CO1NAM11FT022.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:6c:cafe::da) by MWHPR04CA0062.outlook.office365.com
 (2603:10b6:300:6c::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend
 Transport; Thu, 8 Apr 2021 09:11:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; lists.linux-foundation.org; dkim=none (message not
 signed) header.d=none;lists.linux-foundation.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 CO1NAM11FT022.mail.protection.outlook.com (10.13.175.199) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4020.17 via Frontend Transport; Thu, 8 Apr 2021 09:11:01 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 8 Apr
 2021 09:11:00 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 8 Apr 2021 09:10:58 +0000
From:   Eli Cohen <elic@nvidia.com>
To:     <mst@redhat.com>, <jasowang@redhat.com>, <parav@nvidia.com>,
        <si-wei.liu@oracle.com>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>
CC:     <stable@vger.kernel.org>, Eli Cohen <elic@nvidia.com>
Subject: [PATCH 3/5] vdpa/mlx5: Retrieve BAR address suitable any function
Date:   Thu, 8 Apr 2021 12:10:45 +0300
Message-ID: <20210408091047.4269-4-elic@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210408091047.4269-1-elic@nvidia.com>
References: <20210408091047.4269-1-elic@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 719d1bb8-49c1-475d-4cde-08d8fa6e3ace
X-MS-TrafficTypeDiagnostic: CY4PR12MB1509:
X-Microsoft-Antispam-PRVS: <CY4PR12MB15090D70C5ED1B38F412DC5DAB749@CY4PR12MB1509.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Mr+iuCG5lt2dCccUHChwUG7Rxf9c1jin8WBYocFI/hkn27e+KQq2AHVht0EHpjCUOwLfL/JorBEBlZ74D0nTbYMXImrWJbXGL2OlqSLDO9Xvo5jYAxOQlrU0562r0BkYlMqZkc6eDbk2E25f0hwICx7w7/9vR1L4p0MxpCcCEMxGYsQE6wyyEOnC7sig3OvvRwrAJO3/aQT5oTEF3kmtx+8TFDGwPyTlAaZormmlfm9QNqToZvT+33wcERcTCfHU2lmUCkczOICU4noiGh2PFWSSJDWpUHhbYQNIHLEI1dD83rbw0ZXJXqVY/BzvnXmMFwzHhDXVt4CxtdknmgpgOxoesj4e3ZFVxDOl4vmCYaTQ2z9CRpkyONn29bGQqplhIZ0SRimIN2Mlw8E85jG7cM3UomAGNzNcivEW4v+XS3n3cBxoK06+u+xO5DYTIkvtqI1aMAIn8cV3BsR0mL6w+pPpTxCFbRGVr00oupV7cqZ9ZNCNqD+ADtTMStxbbt3DotjjQavncrxErZzVHkhEaPMmKJ+/JzvEQHGvy0Y2Qe7YpafmfPNrpCDw/C1n8VvsfRIIWi3GVtQP0jbf9zsIFJ3jQja9QlCgTOreIGUmosE4fQtnYZ2F3/sDspEOKU4UxpfeFHVPv2o3l1aKB0n8L5X29mOeeLVxUc1sreLzdXM=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(376002)(39860400002)(396003)(136003)(36840700001)(46966006)(54906003)(110136005)(82740400003)(4744005)(107886003)(316002)(36906005)(8936002)(336012)(478600001)(83380400001)(426003)(356005)(7696005)(4326008)(1076003)(82310400003)(26005)(2906002)(7636003)(8676002)(36756003)(70206006)(36860700001)(6666004)(2616005)(186003)(5660300002)(70586007)(86362001)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2021 09:11:01.1830
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 719d1bb8-49c1-475d-4cde-08d8fa6e3ace
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT022.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1509
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

struct mlx5_core_dev has a bar_addr field that contains the correct bar
address for the function regardless of whether it is pci function or sub
function. Use it.

Fixes: 1958fc2f0712 ("net/mlx5: SF, Add auxiliary device driver")
Signed-off-by: Eli Cohen <elic@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
---
 drivers/vdpa/mlx5/core/resources.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/vdpa/mlx5/core/resources.c b/drivers/vdpa/mlx5/core/resources.c
index 96e6421c5d1c..6521cbd0f5c2 100644
--- a/drivers/vdpa/mlx5/core/resources.c
+++ b/drivers/vdpa/mlx5/core/resources.c
@@ -246,7 +246,8 @@ int mlx5_vdpa_alloc_resources(struct mlx5_vdpa_dev *mvdev)
 	if (err)
 		goto err_key;
 
-	kick_addr = pci_resource_start(mdev->pdev, 0) + offset;
+	kick_addr = mdev->bar_addr + offset;
+
 	res->kick_addr = ioremap(kick_addr, PAGE_SIZE);
 	if (!res->kick_addr) {
 		err = -ENOMEM;
-- 
2.30.1

