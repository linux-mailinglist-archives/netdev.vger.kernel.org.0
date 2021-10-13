Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A821442BC05
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 11:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239292AbhJMJvS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 05:51:18 -0400
Received: from mail-mw2nam08on2048.outbound.protection.outlook.com ([40.107.101.48]:62144
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239226AbhJMJuz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 05:50:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gWNddMr4S+BvcU0KV1mbTNGK0smTw/CSOyLNc5Rb9UTCJujv6t/jO36Xsqqey6YsUF8cWHvpTUn5t0g0b+TPYFsDxt61a5S+auaIFWsUrfrBhQI5+n6j3YAVXyievJkIsg7DXaGJ23YVF4pvvY8+uuEUHR4RAgBTvUrJV+bjVqzlE8/JB0x1+RiS90sa/3p+eMizzoID/hwrM/+qc9Bsw+0TLQ0QUYPhz4ANk15KEnyOwVHdlni75Fj7CkGLi/WZUw19wEKaFpCOCcOV11peip/XOYGNWz7Eh2muyWE5ww7k1bnFYHIBluI6JsGR4m7qLWyx9u1PKxInOyN4eO1n4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DOcFU6eSD++XS6aHs3kXEvGIdsHFeir924wVdQSptkg=;
 b=OiPWjAKxzai4Hlb9v8nWKeVhB5nmqwZIOTE8MOgSVARTmgnrmQ4ry1PwkvtO21SVfoEB+7cOyDqYKkodSSwMxBVnYjP9BqF4ThI+1ciGcswTbq6aTOS1Vzi0DuzuE+G6VytL0G73Kqx52ct+hJS1FBE/424Angtb65HL5XoW4clJUaZrWlhZp/qST5XfnFdGpFsRktojVEay3IYN4Wj/w9KSAVejLdNmaR0ZmP0Io5jDl0gEnhxdXY/izHpUWrTUUrWxzAcrDuRLuE0zLv8TIkYcVbNzwEBm07O+r95wMn1kSsGe0VpiPbMdG8AbaKKKEkwd2i2R5qVE+IHpPJb8Ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DOcFU6eSD++XS6aHs3kXEvGIdsHFeir924wVdQSptkg=;
 b=Z0bE2BR4eKugUGLi0tFkNVGh+zBWwOGev129IKBx84AYSQpXygnEI8GHpjewq0AFBgkxJSGkQP+uF7KCDKJJQ46wAyNJv1mQJiwXO2dQk/FW930buQygK1DY1ax3AtPFsKkggTR/TPx3huE+qcEksPTsD+cf02xD3RbYkTAfzGwHv9BsZQU4HBDe1bpSsLDAakr/Z05hb0STUY9Ud4F9qxAoe0Jf7Fq7Q6Nhp8Q7ALOcKLVrfzgbaZjC6qHi4KCbTo/cYyg0uVY6nkFZjSdfYecWlAHE142l3mIZ+g7QF6HkI60NCmbPsIcWbsFWl5d6jKqGBTuiHzduRgxaNEPw9A==
Received: from BN9PR03CA0478.namprd03.prod.outlook.com (2603:10b6:408:139::33)
 by MW2PR12MB2474.namprd12.prod.outlook.com (2603:10b6:907:9::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.25; Wed, 13 Oct
 2021 09:48:51 +0000
Received: from BN8NAM11FT041.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:139:cafe::73) by BN9PR03CA0478.outlook.office365.com
 (2603:10b6:408:139::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.25 via Frontend
 Transport; Wed, 13 Oct 2021 09:48:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT041.mail.protection.outlook.com (10.13.177.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4608.15 via Frontend Transport; Wed, 13 Oct 2021 09:48:50 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 13 Oct
 2021 02:48:49 -0700
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 13 Oct 2021 09:48:46 +0000
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V1 mlx5-next 08/13] vfio/pci_core: Make the region->release() function optional
Date:   Wed, 13 Oct 2021 12:47:02 +0300
Message-ID: <20211013094707.163054-9-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20211013094707.163054-1-yishaih@nvidia.com>
References: <20211013094707.163054-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0f4491e2-2970-4796-6f6b-08d98e2ea96a
X-MS-TrafficTypeDiagnostic: MW2PR12MB2474:
X-Microsoft-Antispam-PRVS: <MW2PR12MB2474072D38BDBD4C96EE6B79C3B79@MW2PR12MB2474.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VUvdaRh1lo9iawjO2tdE8Q0kt5IIO9mVxxY8836DA7d5750GEc2qj2dofvFNkfTRIlO+lty+c5EO6i6t8DEZkQoD4XoC0Sa5IFqY0F5B6eQI55YQwjWVnVGrVSrCzuhfUXGge/jzekRVxs4fS+VTD/i1Z/dRNEMFEL/vDlgQYaKtVj/Hhu5dfhft/lOPkzzZMZWi9XBZIZ2+A9ktqHGeSagQrcNzVaKYhb/pXSW2VoBZZM353sY+awv1trlaR9f8ytDn0zmLbLqzfLAJiTTjQ0M/m1I3yJ1qHHxDtUFsqhS0U5HIsUNpxBubF4VsVKNttTiHwO9JrplGASWHg0PG8tmofOxjVboaTtJVopEEQxPGW2Wwxj//jvNCknArWsfyMWabs6SoBHG7HHuU4s+VtAbyRLcdzz6mdouVe9k6BKSHyjsyEKwYIUh3Z9GE2PsrhPFlj1thv7uWHkbGhp4qCCh2NMp/qrtzr9m7Ki89oyJmRlRGC4jkAalYe5IAHxaX2lylwrXLH5+8EsyMLf8BVGTuFqlfeLWHIJEYinG7BC1E3rwmX94AS4x9pB79ImPPcxaaIqOejIFisSsQeVS7uCilSqEKHVdsfC1/2d3I0w20O0cycmqJK8ha1q6CYs1RUneis9IAo1XWaD1XremoIgLfZB/C1IwV6ylj/aj+OErwWo+sttoHol35g1fhj4JSvUePtarwbsaISNMrSyEmLg==
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(186003)(2906002)(5660300002)(8676002)(70586007)(110136005)(316002)(86362001)(83380400001)(6666004)(54906003)(107886003)(1076003)(8936002)(36860700001)(82310400003)(336012)(356005)(70206006)(47076005)(6636002)(7696005)(426003)(36756003)(26005)(7636003)(508600001)(4326008)(2616005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2021 09:48:50.9861
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f4491e2-2970-4796-6f6b-08d98e2ea96a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT041.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR12MB2474
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

