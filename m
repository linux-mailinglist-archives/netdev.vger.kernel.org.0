Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 993E043C712
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 11:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241334AbhJ0KBM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 06:01:12 -0400
Received: from mail-mw2nam10on2077.outbound.protection.outlook.com ([40.107.94.77]:61153
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241342AbhJ0KAp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 06:00:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iDDNNZu9kh/NU+XKqAY0B8SxVHpUlZPECZhZI9iHVYpUh7HMrjwtMnQbrpPwSOMaqxOjKK9cOPCGtul6A4iDhXHRF4PmUn9KMHv9GdAFvZaLNQ/AHTiLHd8TZjBgbszmapCc6xRF3gSDc7VwMKCiPx9lbPjHs4NYNn30+LDAxtC9HGSAfFID0tvE2GtPULwNABkEJaZ46xnA4RpwvtIFZ8dxi4+K9lQzC3gOCFsNppHSq0Vd+QAO6zh0p6YnRWfCiEEu8o416utxYykzMvVYwSTIGXsQNqWUh1a13KDjvqhc5+uUsmsP7JsII+eQo/GDYKKmb38kjT00MyiGW7ybXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DOcFU6eSD++XS6aHs3kXEvGIdsHFeir924wVdQSptkg=;
 b=oMDgFKn/7koLXQ2XWF+NKLXcskOM0BQdwuhEs1fYIRYE/+taMw48DLfPpYYoYOmguJtmCdQv+TA3LdE+XY+p7FXzKG55r00EXIc4mkJLUvmYI50M9jLO98qQ+piF7Rw/lrkPJaiFNKO0GmgYetFpjRkXvGceBjIq9zijmfC86gyeKZyo0EKgLHrK5O62kokcaYsaLRF2Ae4UTM+AM7KAZ2dgiX8HYzzaFmcFtVytp6VneieWp1m+TDyFO5XhhA1Qv6W2Bzn4D9p8JNFCcIqHbEFbjrz8yeFuay+PSVLMuH+xH1SVqnMNF/LQtXQ9r3ZBB4uq/wQu95fh+5U74lhGAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DOcFU6eSD++XS6aHs3kXEvGIdsHFeir924wVdQSptkg=;
 b=qUNj/omCtMuQPGoP+2WAD2/gkDPVJ8uCtHxbm9Q20O4XbizDTBD73G05UIMjKy0+XrgCHTddkF1H+HQ0jeoXrnOjAg7B+qVpkC2Th6YHPs+jRd+aO343EpX92bUlUkqT475kDwQIS6++ETItjThnXtjnL91aVIUmmnqMpErGw8tNlUOkyYCJIzFjdoWT8g7Ryff/mwTcqhk7AiaEH4eKhMRZFhr50T0WtmhDeiEQA7tfJAywCGDao8ohUvGE/psdRmXtxwNtqS+vukZ4acZYjb2zrCKuzh96FNoeE9oUl8+vJUyr8ssVVmuY2Vh4WvcuJGJR9SZ7qEP5BgjqZ8jx+w==
Received: from DM3PR12CA0069.namprd12.prod.outlook.com (2603:10b6:0:57::13) by
 DM4PR12MB5053.namprd12.prod.outlook.com (2603:10b6:5:388::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4628.18; Wed, 27 Oct 2021 09:58:19 +0000
Received: from DM6NAM11FT040.eop-nam11.prod.protection.outlook.com
 (2603:10b6:0:57:cafe::ce) by DM3PR12CA0069.outlook.office365.com
 (2603:10b6:0:57::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14 via Frontend
 Transport; Wed, 27 Oct 2021 09:58:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT040.mail.protection.outlook.com (10.13.173.133) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4649.14 via Frontend Transport; Wed, 27 Oct 2021 09:58:18 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 27 Oct
 2021 09:58:18 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 27 Oct 2021 09:58:15 +0000
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V5 mlx5-next 08/13] vfio/pci_core: Make the region->release() function optional
Date:   Wed, 27 Oct 2021 12:56:53 +0300
Message-ID: <20211027095658.144468-9-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20211027095658.144468-1-yishaih@nvidia.com>
References: <20211027095658.144468-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9a394f34-a18e-4994-e311-08d999304da3
X-MS-TrafficTypeDiagnostic: DM4PR12MB5053:
X-Microsoft-Antispam-PRVS: <DM4PR12MB505326B9DB389A9D2157050DC3859@DM4PR12MB5053.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GFiCO2L+k9IqXnkvYmmbvUd5ibbz5P/3vQcLEiaQKkb0y+M9LtJJ6B4sFO+bkxvEKduWUCM4LFe0XbE9VJKdxKD4j7SRwujNp3jJSVEdp54L5b1J7abZjJKArmbvSTHJmGvmmYvKS45RNK6ThK5lNIz/iqJK7Mi5Qk/W0s0Rv0xTt6j982ZuHriUj9jVKj6dQ2cLPIhN56zRIqz72XXEwYDIImdTkdbzVS0jpHdWDqCDD7N/k8qq3WEkiNbgSSuxWkIfXaRWK1vN2ZIPu8gsAhgdaSyox2TlKAHuXFrmbgqRvoqCvKS0FAQ5p3fzBzYMdUKcgi3c6aU9FsNQHyVJslFqVODN6CaGs38y4JYJVSL/uOLldQ0vxHAK14ItBF1mWAXE38YJnQvHmedu7HjKXDaMT9Z8wqpcOdz/GwhBGVvKgwut2457/JS1q2gBGviiknJrK+BfwxY+Wbo9wkCYqZWvP/mXJrWampq0bhdDhu0jSTrQM1bJPY7n8O/D8cUmLXhZ9+jvy00wkSrjHmMbMA+2bTsEzZYVt0bCuoNL+hyKoA8dYimNQYYSncqASRhQob8vS/y6ZRTTL1nh+0pekzW928iD8yNRrebM4wLeQRFtbJG/RUrHIeVOCBKYSN73BYqqDZ5+1O8GGf0wKH+eACYUuiJ33yA+kkTllXC+7rVkq1ZJAdYTZ1psWdewOGfubw+zkgx5eOa9CSlyQT6MoQ==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(36860700001)(36756003)(110136005)(47076005)(36906005)(426003)(83380400001)(7696005)(1076003)(107886003)(4326008)(2616005)(54906003)(86362001)(8936002)(82310400003)(6636002)(186003)(8676002)(70206006)(6666004)(26005)(2906002)(356005)(7636003)(316002)(508600001)(70586007)(5660300002)(336012);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2021 09:58:18.8552
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a394f34-a18e-4994-e311-08d999304da3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT040.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5053
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make the region->release() function optional as in some cases there is
nothing to do by driver as part of it.

This is needed for coming patch from this series once we add
mlx5_vfio_pci driver to support live migration but we don't need a
migration release function.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index a03b5a99c2da..e581a327f90d 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -341,7 +341,8 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
 	vdev->virq_disabled = false;
 
 	for (i = 0; i < vdev->num_regions; i++)
-		vdev->region[i].ops->release(vdev, &vdev->region[i]);
+		if (vdev->region[i].ops->release)
+			vdev->region[i].ops->release(vdev, &vdev->region[i]);
 
 	vdev->num_regions = 0;
 	kfree(vdev->region);
-- 
2.18.1

