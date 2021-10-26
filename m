Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD8E243AE90
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 11:07:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234397AbhJZJJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 05:09:56 -0400
Received: from mail-bn8nam11on2054.outbound.protection.outlook.com ([40.107.236.54]:55073
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230420AbhJZJJo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 05:09:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GcmLdQ2GRXF9nCeUX4Y1wf4g5f9ZobfJumQggjQLaWboF8Uu0R5KY+SLkuwegERLZml7MoXVP1oylzvxpsjLZgk0UOwFJ7lxn1HpHvd5GvcjBTHCVdbhN0UQLNpAmeJl+LLXYOT9xvk+3WXzgRTjCB/YY+FNVmvl3Cr/WFEVNjlrsxWf9vBj3FcAdTaJXYd9+55+pUdngm3e5oQjmIcIP5NxJYb69yszm98yhPXB/ehQ8P6IblzKslHltT/P9fR+/+bWegMQ6AI3Hu0FNspiAo7mQhiBAwtDucLxOKTzthsN1+Hsh37ZoJ5L/8HNG4tokTqnejVBNQUH72ZbaT8OEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eawxF+jFRBAH1P9hWq5BE145QVmYPfYNp1U9MJCuY0E=;
 b=SDejQ4lfP2Q7Fn2zQKNNOkcApllRXEH/3ADmbGYd0oo7U/u9vXOzpOAaZrsa9NJeJI/RplO2HwRf2RxshEfd5ynsCZCX4E7sLItOngILZDWsnx7dF4Ml3mv4kF+S6kCr3hMCN0/FxUX9i84T4i0dOjduR+qJ7AsFMM1ZbemU5HOmI3pymfvpHAT15l/dQIwgxWl5B2Bo+goMHX1xGg7j6Rvo9VLQuEaoX06nVxKHCm7VcENwNL9+vUjztgjWShOK3qY9XCr9cZI3ZuyBGtCVeNAF/6wZXEUevpN4lYhTHiJCI7OAZ9Puv/XnSi+tkMKYAGLdJGq5fkGbRFjgQu98Vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eawxF+jFRBAH1P9hWq5BE145QVmYPfYNp1U9MJCuY0E=;
 b=mWg+76/Vv0bAl5SkQa2EFnWsVNGvUJDkNxPKW9qvM/LHvWCmOrwlD5az8cYse9hoLgAHT67Irs2XYtV8ffPNes3vwOzU0wyFpJcLl1mV7DQpVzWjZkW3GV9oXDDHoMfS7/6C19OUe54wHregg0fUQhiEq8kcFjag5yX1atMMwp7yBdi3xtGXdpmg+GMtfUOguouPIN5I0PTp795Q59yPsCCx+1fJqIVDce4DOCNTtKFFu8CUIIw4jv41wThPHLH1XOsUfIjBrL3K6OtTcedqzgyckCH3UGGlTdp1xap+fQhW2IMqdfkVxYbczmLbPxC6dHjN2LyDvk+PcGa4GUHqHQ==
Received: from BN6PR1101CA0012.namprd11.prod.outlook.com
 (2603:10b6:405:4a::22) by BN8PR12MB3555.namprd12.prod.outlook.com
 (2603:10b6:408:48::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14; Tue, 26 Oct
 2021 09:07:17 +0000
Received: from BN8NAM11FT061.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:4a:cafe::f5) by BN6PR1101CA0012.outlook.office365.com
 (2603:10b6:405:4a::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend
 Transport; Tue, 26 Oct 2021 09:07:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 BN8NAM11FT061.mail.protection.outlook.com (10.13.177.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4628.16 via Frontend Transport; Tue, 26 Oct 2021 09:07:16 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 26 Oct
 2021 09:07:16 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 26 Oct 2021 09:07:13 +0000
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V4 mlx5-next 02/13] net/mlx5: Reuse exported virtfn index function call
Date:   Tue, 26 Oct 2021 12:05:54 +0300
Message-ID: <20211026090605.91646-3-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20211026090605.91646-1-yishaih@nvidia.com>
References: <20211026090605.91646-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 07c5c402-1714-474d-255d-08d998600220
X-MS-TrafficTypeDiagnostic: BN8PR12MB3555:
X-Microsoft-Antispam-PRVS: <BN8PR12MB3555063142B53B15DE17CBD9C3849@BN8PR12MB3555.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ztglC0zC7t4yM0ZMUCGPzRAMkt9pHtw+s1f1nBSnZXU4stOrl6XZWMveFpmtVvIg8SOSrt1gY1X/l7p4AFHkXnMzvIQanUdGPGY+kaNqflRXoL0shs4XQFwDUDOXT+BQYv4U+spHylobmQ8xHkGSbeXBFKbhKV4/ksga4JNt5I8PxsncXwEoleelBep/OCfkbRkSL/MXJnDE9BGYZUewWAlXfMX5EM6lohGiWER6tO6bsdV/AMNsIdpS7bZzOwDnjtKS9xIlBEqfcoqelo2qIdUoo3rqNpmOffpEO9jpLz0v0FHznM+QnUD5yA/Zm6zbIiMXquX/MLKJXXF28KQP8jyfrScuOBb6yQGqCm+NlMjN8fpCzeGLdxET/nxhcss3ludrZPcUfjulYhleYyGrbBHw73Ai3taP46/yTTfyaz5cz5NCj3pdOGaViX3miVJ1240jKLUE4RKLu4z0p/ajMYjaqXzzvFgCKwXlEuUJ/+dz2mOgveNgUEUFK+57pLWg58JGaPPZoGEv2eg+l8uM7jahcSWvFsMw9J1u0d+wcRnMI7wN/Tk45NmnHGnaYVgKHuwzvvr4L3Clmn/BEjRdD1GbVymUC8ES4vV2fiJ936wcEHH9HpO/dziwZQAig+IjHjRYCXGTPUyijtit8LvEMmD8Yi4X9h2l1Ub02sC3NotpiuktlQohRpRT03Duvr2onOjRJzJWIgLoWwvS915q+Q==
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(508600001)(6666004)(2616005)(426003)(47076005)(4326008)(86362001)(2906002)(36860700001)(5660300002)(70206006)(70586007)(1076003)(36756003)(8936002)(54906003)(356005)(7636003)(26005)(6636002)(316002)(7696005)(186003)(107886003)(336012)(82310400003)(8676002)(110136005)(83380400001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 09:07:16.7830
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 07c5c402-1714-474d-255d-08d998600220
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT061.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3555
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Instead open-code iteration to compare virtfn internal index, use newly
introduced pci_iov_vf_id() call.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/sriov.c | 15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
index e8185b69ac6c..24c4b4f05214 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
@@ -205,19 +205,8 @@ int mlx5_core_sriov_set_msix_vec_count(struct pci_dev *vf, int msix_vec_count)
 			mlx5_get_default_msix_vec_count(dev, pci_num_vf(pf));
 
 	sriov = &dev->priv.sriov;
-
-	/* Reversed translation of PCI VF function number to the internal
-	 * function_id, which exists in the name of virtfn symlink.
-	 */
-	for (id = 0; id < pci_num_vf(pf); id++) {
-		if (!sriov->vfs_ctx[id].enabled)
-			continue;
-
-		if (vf->devfn == pci_iov_virtfn_devfn(pf, id))
-			break;
-	}
-
-	if (id == pci_num_vf(pf) || !sriov->vfs_ctx[id].enabled)
+	id = pci_iov_vf_id(vf);
+	if (id < 0 || !sriov->vfs_ctx[id].enabled)
 		return -EINVAL;
 
 	return mlx5_set_msix_vec_count(dev, id + 1, msix_vec_count);
-- 
2.18.1

