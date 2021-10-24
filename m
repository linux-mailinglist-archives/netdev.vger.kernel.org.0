Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F15F0438790
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 10:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231779AbhJXIec (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 04:34:32 -0400
Received: from mail-bn1nam07on2053.outbound.protection.outlook.com ([40.107.212.53]:14961
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231516AbhJXIeX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 Oct 2021 04:34:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cndv4n24756nfbbXfNmRdmr5uZJ71ca3UXIGrcUJ90QO0mShkCHCCeLHzjvWOprF+4fTXhGLhVX02U9Amvkvu0Gm7sDLiph/OQC+hKoWK8QOaQEYdGaPnhvFlp4ywx2iK5F9Jt5U5WT2yAaznffi+Tml7EsV4Q7tFra5dEFunl8bMK4qhCmFJdda5c5wsF4FmgkiaDMtwVl6wLQgYTx5oPUCBEg0I1breS3UZ3pfkqa2xJCZ1VFmWGYHw8HvvfRSiBoktlItXKPE4i07revZ4OR1vic7KS4brzoqQ+yb/W+QoKsn9igBPdnzh+RAObM/YBX/OoLjhaj+hifaC7vgYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DOcFU6eSD++XS6aHs3kXEvGIdsHFeir924wVdQSptkg=;
 b=MuxNrPNXKipW6LOpRWkhJG9B6OZtU+OWWOPUiQ9Qg+Pec5ZzUsWTR79GAwpMo+dHQSzfzzteZmS9bdhAlOldFLeKBnmIutP69tc8jJC2WfCnAs7L/yS/q+HgbIvA51n59bNpXa38r/JNOqN9+XFRovF3+EPrt3APWNph6eHtVuJPD9ZTDzVc4sW3uJFl62MOAAcIrIya2n8UYpZZDNrxLq+SIMtp/JIoV4SuTMUOAJRCnKzlSgMVIiQ0WoSRDX1+uKGPyvtyb3cTDp1O0NCX361LIa8qpjdrIN4VrfLUZ+WFptkjn8SFW78rsKfDXDETfqu5YUpGCpHAVItnw9/4Ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DOcFU6eSD++XS6aHs3kXEvGIdsHFeir924wVdQSptkg=;
 b=hijrW330gNnKgG+Uwm1VoOOk2B2zg9t0bDCTXLpnnYJA9ahXgaSKp6pi2i/MtaCfZwo1TcScpV0Ic5bCRtMsTouZXZPifJrR0vAqD/Mb55alP3c3G4cN/AqOrQeEjdYHw/BCxdYtgWxF85vz8NgijWHcrYOlC6XJK85ZUx2mrIJu434ZZzgVzP/nphW58cUWj40XoDlBIOZvTmd6Ke1DyRQut6xHdatsTojlB5oBHlp8ihhBjj0A5paAZwyqoGBORJRYR1suxvfB99a8uKqJrV02PIJyyiYW014Urr8iW9/acg5oTfPgqOtBs462OskvqgbVQis9uj78dSG64SK69w==
Received: from BN6PR13CA0050.namprd13.prod.outlook.com (2603:10b6:404:11::12)
 by BYAPR12MB3238.namprd12.prod.outlook.com (2603:10b6:a03:13b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Sun, 24 Oct
 2021 08:32:01 +0000
Received: from BN8NAM11FT034.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:11:cafe::94) by BN6PR13CA0050.outlook.office365.com
 (2603:10b6:404:11::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.11 via Frontend
 Transport; Sun, 24 Oct 2021 08:32:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT034.mail.protection.outlook.com (10.13.176.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4628.16 via Frontend Transport; Sun, 24 Oct 2021 08:32:00 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 24 Oct
 2021 08:32:00 +0000
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Sun, 24 Oct 2021 01:31:57 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V3 mlx5-next 08/13] vfio/pci_core: Make the region->release() function optional
Date:   Sun, 24 Oct 2021 11:30:14 +0300
Message-ID: <20211024083019.232813-9-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20211024083019.232813-1-yishaih@nvidia.com>
References: <20211024083019.232813-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8347b64f-bbff-4041-b9f6-08d996c8c016
X-MS-TrafficTypeDiagnostic: BYAPR12MB3238:
X-Microsoft-Antispam-PRVS: <BYAPR12MB3238CD93CE6AD53D0207E67CC3829@BYAPR12MB3238.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P/Xdb6PUX1Ak9YpCxJkJ6qSjh5RClaS/5suwObg4HBRRx/xkG8atEPBXVrt5UCbj2JbZJtjnSOxtiFxhAuxqpQQWi5Bf+XUjjHSD/CFLocoR8cQIDgSsYa9zxCI+f/iX1gG3PnzZsc6YmHDN4k45GkdLqD1uald82ZAY3Y6089hf1hMOAHI/2kLUv8sSBsxIr7jSO48NYGz1nzOoZmMxSOLGqZBe0hpN8Db4SsouFLycMNUBNJoaDtxiVHNQ5Yr0R+5idGCAlu8Vni9QMWeRBdL3K4ItEg+pUJUx6byG9mozjXrmNoKBNsYK1WLjoYyu+uSguXa1cDCySlddYfoQ9ZpNM8zI/C1RrjEXe3oQL5C0pGNUIboHpwSw8ddiFy7uMUgH4VwJNECUt7lyeoOH8TEADvIqdN6a80MzBEBA2xZ7jDPybjWM/aVwUpzco3K+SY1Cy0/TJfJhwcqGT7SSYjMyS+oPr7PNvfJW8bHU8ocieft2xjlwH3nLoYl/ldTmRHY81ExNynegW+zap1n8XcvNGyEwBDJ9NI6OxnB4OWyPSbInvFK3Pkn7IP4E1QbA3nVN2pqB8ZpGYs4S9/uYgcEHC0Q0Ylo3NHvt8QKlaJiQwsd5cLkO0FlJx8SACX/rPDer/71A04yx6Xip2AUVI2/wP/szaP2oMUAkmb5wBnRJTUKhbVVGY8RHpxHgYlXDQV/Uu8MATRp3C1zV1rz5YQ==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(5660300002)(36906005)(8936002)(316002)(4326008)(6636002)(7696005)(6666004)(26005)(47076005)(8676002)(70206006)(54906003)(36860700001)(508600001)(83380400001)(356005)(2616005)(7636003)(70586007)(110136005)(107886003)(1076003)(186003)(36756003)(82310400003)(426003)(2906002)(86362001)(336012);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2021 08:32:00.8157
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8347b64f-bbff-4041-b9f6-08d996c8c016
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT034.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3238
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

