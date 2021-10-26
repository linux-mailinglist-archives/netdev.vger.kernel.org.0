Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F371043AEA3
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 11:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234065AbhJZJKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 05:10:20 -0400
Received: from mail-sn1anam02on2050.outbound.protection.outlook.com ([40.107.96.50]:2362
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234610AbhJZJKE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 05:10:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CB9YlOYzxzf/MhJ80Zp4eSqYQGHQSPirYTgnGstntcGW60CfjXI2VAOM3YyJOEa/44KRSQdgKzkBnGaxGRs/5IfB/y6oipOVR2O8AIZexrvkcLG32QlltQSs4ZhOeMAGr4Oqp8FoGDm+gZiLyNFOLaSRP2f0cEpQHVpwn3Rt7yZqTBwpX9f/4jWXnlZpAS2bxhZ5lW4YHXcBPr2hODIFyPH91jgUI61jMpjOrVWOHPex5X3Oy0n9WWxTvTEstS12pQQWF7m4fCRfhpSBOSMnxfPVW0ruYu/eN7WOa3OZqPqpg3yhjz+03K60dLGHN2MjARlmm9fOXR+15bJxgOnotg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DOcFU6eSD++XS6aHs3kXEvGIdsHFeir924wVdQSptkg=;
 b=Li+DUXCeFruCfr0UxS2Nxj+6WgfvNV1esz4+eewUBXqD2KxqYlVcbY0nGW+BwvjtF/P3x2ZJ/WLDE1SitZhcuLjHiOc8Fgcu4YHGlGSgdCkKbC3Ko0Yxp6bR01yPVQGuKgy3f9cPy3EgY9P1AhQ6i9rv8oCsy7vbsAIHv40cNp7elHnJOrKQ8/wccYMOfOkBUsGKFWNFbuT6Ii68Gq/T0dqfzhCxabk6e5RoEoNFzdgHyNjdOslXRbvr3r8l22SCVg9RYWkDblAisYqtM0S0UOdOsVSm9RiU4rcyo7gum7z5PkXVzhAVZ20mcmtHllFuVYUvghBGrZnJTOT5kNnPtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DOcFU6eSD++XS6aHs3kXEvGIdsHFeir924wVdQSptkg=;
 b=AVjkv6J5zbknj/ibip1Kx3p8LF1MgpT4nQ1v2E2MPKLNfA8JaPcDff/FrItCs9pEyxYkqsjKW8FMXFM4momMNo+TMtP4jXn8jTI4GES+N7s/9UHwCHW7RQI9FZ4DdehZRwnuK2OuQnkwwwomZ2MuuzaxcTiEtDrkI3SShakWH1WKP084fvo/JVSRhXQyHtnQyC6fZhEEhByn6OLIjlnWlR/Ta5fzYVaVovflx/SPMvG4HOPD2anFNzSFXb4PLFZsRBXGrRXdCzlH2VzfCjpuzOIw1n8Y4bFVVKUhLjYB1rZIPskwLClQB9eLbhRxYR7I7UhzNGXmD77w2Zoov+VNVg==
Received: from DS7PR05CA0009.namprd05.prod.outlook.com (2603:10b6:5:3b9::14)
 by CH0PR12MB5140.namprd12.prod.outlook.com (2603:10b6:610:bf::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Tue, 26 Oct
 2021 09:07:39 +0000
Received: from DM6NAM11FT068.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b9:cafe::df) by DS7PR05CA0009.outlook.office365.com
 (2603:10b6:5:3b9::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.12 via Frontend
 Transport; Tue, 26 Oct 2021 09:07:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT068.mail.protection.outlook.com (10.13.173.67) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4628.16 via Frontend Transport; Tue, 26 Oct 2021 09:07:38 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 26 Oct
 2021 09:07:36 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 26 Oct 2021 09:07:33 +0000
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V4 mlx5-next 08/13] vfio/pci_core: Make the region->release() function optional
Date:   Tue, 26 Oct 2021 12:06:00 +0300
Message-ID: <20211026090605.91646-9-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20211026090605.91646-1-yishaih@nvidia.com>
References: <20211026090605.91646-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a8f22612-2de7-44d5-58a7-08d998600f11
X-MS-TrafficTypeDiagnostic: CH0PR12MB5140:
X-Microsoft-Antispam-PRVS: <CH0PR12MB514007E539A62ED98BD6FE62C3849@CH0PR12MB5140.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /+pBikmlZDxfDNk1JEb/cE/MtuKGWDw/hPDZpS3hFbiI+6SR9T3Ge6C/TbLwpJdRNH/f2J+6hS3GSddN8tbq+q10v1ipdm5rt0/tng8wq+X9m5DjCUyaWmKNmGyWyMcQ86UFLHuse+njfCBT+SGu0PMOodXmseO4wG2aSFPKOBxEJs6UugiLm/d8J/Htevz/NDPlSbu0sM81GywK6eNQr6A6SsAiBpY2HYkRPtooL8DtlciajnaHUXJK0lhQqS75HXN32nOy1PeyDSmYIsDVUsAbhaZ0zuPiBrl3/vt9jo2AmDDSStb3SzNJkE4Gs/yAxCO9oIFBh3Q+Lf3UZNZdGH7YAIYD2P2/B/nSVnVdXAOshMUf2ObFaUjBQnJs4enU3YPQY7YMfHv17zXVb7e0Tocie4/tqOuyqtpMWyy8imjP6ZPXdlKwnN09mwqXe+O8Srfwpqro+wt8UlxoHt9NErxglk0Fo9OZjSv1DyzOQk1leq81VmlsdXYtZ96tYYogW+wFLCKFfIpn1GvDPY4R8FE6MxmbJ75TSB70Ank9+IGeAk07D9OqtDnDDLCcg1CRl6s2H+ulBx27IZ0Hrk7dmLEflPjP1BpbvCXJgyHh4+W7Bw6EvEpkJWJiGWRYdhXn+2xBb6T1R3HCBh7RPB6vwWaOjM7WNPJShu5JldqvPgaSDcwHROy3kGVPPgrhTCa6XpXbArpVK6D+RDbbtxDfuA==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(7636003)(7696005)(5660300002)(8676002)(107886003)(36860700001)(86362001)(356005)(83380400001)(508600001)(2906002)(8936002)(26005)(186003)(316002)(110136005)(82310400003)(6666004)(426003)(47076005)(336012)(1076003)(70586007)(70206006)(4326008)(54906003)(6636002)(36756003)(2616005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 09:07:38.5364
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a8f22612-2de7-44d5-58a7-08d998600f11
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT068.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5140
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

