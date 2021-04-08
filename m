Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41407357EC4
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 11:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbhDHJLK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 05:11:10 -0400
Received: from mail-eopbgr770087.outbound.protection.outlook.com ([40.107.77.87]:25454
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229603AbhDHJLI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 05:11:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YNe66yfVnG1GwoLdU4X8lfuKZcmw0/Itjwrilc/lPo8ZQLeQM14Za7Uuh4v5C9/c4c9Mq0V+62gBwSgh/QwXu/LsNlnFajYF4xH/ui005BUVi5HrlA300SYsKPXpWWJ0gf4GMytYOmFyro8zBSwdxMTsRchcu/iDZmk47g56+VxhY4BcXgK2IikTOjTJ0yW3tq00Wfd9WgDERMctiwYvdx5hTzAgGo1rlPChrqizuDlIecRUAcQpZ/U90So/LaEL8FVWihAHPfkkQktfzfiQ1/nI24/XEpKud4AxW6ovFuPqqPCj9pmfabu5ic/kvjJUwI8W3/fx+zlFmjLwSfQnxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DzZEAR5poXPGX/1jigS6ffEhCHKkS16g+x/r0a3YBx4=;
 b=PyWRe8LJ3z8/vneQWP5AEooIn0kH+h/7u+VxpQgsAN7Tlv1x1b3HES842Q4OetKSEHVUhny+8Y3z4o89VPL/yOImYNxyX+GuS3McRG0B9idTdDvcP6osMYywzgpfIMJ36mdR9+W1Aa2i3t5H1uxu+cPJbZ7gyif1DOGtf63Lsgai7qaG0moFyRx5NCsL8qSNvYv0WiiaoH2FPxqrSc50jqkCqhpMHqtm0X9wkjFLsZwP3OTxWVgbqTqgHXvyZHybqCiXZhsRg1EQCFEL33QbPuIVrwlt+SYboIT9Wigy4xAKhCq3IniYT7qwmCq711n0lrQczOfXNy7q3avMuKmj+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=lists.linux-foundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DzZEAR5poXPGX/1jigS6ffEhCHKkS16g+x/r0a3YBx4=;
 b=Mipk4fhCm/QrupRHmSL+L2kl8UtHwdvsf3oX6y3ozbR5EuoiGeigPjQPD56J1OH3Mhg/TFPDPuQMv6R2rHSdvXkYv7GeJooO82fIc7U07PTbo0F9c72XP3sNTYqNVTafFlfqk9UanPa6hG9/AKQrtJJ0tKofnaS/ds9U8whi7uZoEj0UTjClrXYbYf+EFfBAOPlzIPF8JVvzl4W3cFtR2FTBgpZTQwZegkDrsTaYc71Z4rZI5HTSCJWcGe5i3IKLjtMsa9httzgnbgd26+gdp8E/o3dl/0U2nHYkojPOFnx1WZ4Cwp8icvunUIiH6+BnBR+miBjpzIOtwSRJspPDKw==
Received: from MW4PR03CA0306.namprd03.prod.outlook.com (2603:10b6:303:dd::11)
 by PH0PR12MB5404.namprd12.prod.outlook.com (2603:10b6:510:d7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16; Thu, 8 Apr
 2021 09:10:56 +0000
Received: from CO1NAM11FT065.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:dd:cafe::e) by MW4PR03CA0306.outlook.office365.com
 (2603:10b6:303:dd::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend
 Transport; Thu, 8 Apr 2021 09:10:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; lists.linux-foundation.org; dkim=none (message not
 signed) header.d=none;lists.linux-foundation.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 CO1NAM11FT065.mail.protection.outlook.com (10.13.174.62) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4020.17 via Frontend Transport; Thu, 8 Apr 2021 09:10:56 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 8 Apr
 2021 09:10:55 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 8 Apr 2021 09:10:53 +0000
From:   Eli Cohen <elic@nvidia.com>
To:     <mst@redhat.com>, <jasowang@redhat.com>, <parav@nvidia.com>,
        <si-wei.liu@oracle.com>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>
CC:     <stable@vger.kernel.org>, Eli Cohen <elic@nvidia.com>
Subject: [PATCH 1/5] vdpa/mlx5: should exclude header length and fcs from mtu
Date:   Thu, 8 Apr 2021 12:10:43 +0300
Message-ID: <20210408091047.4269-2-elic@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210408091047.4269-1-elic@nvidia.com>
References: <20210408091047.4269-1-elic@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: df021eac-e885-4a5f-1d8d-08d8fa6e37e4
X-MS-TrafficTypeDiagnostic: PH0PR12MB5404:
X-Microsoft-Antispam-PRVS: <PH0PR12MB54041AD48394D1620B66ACA2AB749@PH0PR12MB5404.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sqtv2YOyQNBRxWxTOT1B7nOC3wlq/5oB+pahhT1x4tdXXw5nqBRCvRcUtMTXrOYhudpTDjV5Hf4CRoQkxkXhbJ5ILf5ABhMWMVKAo+pnz5Ytjj9iTYmJ6eTGwrU2g9VV3YH6fsSS6mnDnkPTCMVPLMtIjA8FBgp7EYxQ/xadR5A1SzehwepZm6Lto6s06M9rXCSmq0Xx+Es0X85/W50oAmc/xQZokPGyPSc8XVCclWK6Fn7fjyoepl/+hBFannx047V+9Juzraj67JudBqxTYS0SDKZhKih9W86j9/GxuR7SeTS5hISksy1cbas/IHWWXhvTUqs5i/K50DXNk3L6XF1UJ18zMP3zVRfuiU2muxw5L01f79jNTqYk+S78XLn/KD2G+MooNE6mEe3XxK7qPLXuOTbH6YtKwIN8cMNXU3KSxQEk1qleSf8jC7miuxtIN1KEK5PWWMMOZ0+gRN1sdCMssn+YO7r1AAwIDw2Ny62KZNhCJWrKSPGZojvK/wcSWmIAR0Ioo10DUfd8ErA+Y1djbv+NJoV/yWibG5Fzf+pqx2BWPswwSQiuVLWTilNlMHwdgT346itOIxKv6+QdNwLCQklvLLneLkjT4fY5q71Y+ugmSk7ry66J46urEaGOA5AUQOLc1HqfybgazWoOoHjsZ0fSwRDofZsZU4IyKA0=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(396003)(346002)(376002)(136003)(46966006)(36840700001)(2906002)(8936002)(336012)(86362001)(426003)(107886003)(7696005)(4326008)(1076003)(2616005)(82310400003)(186003)(36756003)(82740400003)(26005)(6666004)(356005)(70586007)(7636003)(8676002)(316002)(54906003)(36906005)(5660300002)(47076005)(83380400001)(70206006)(110136005)(36860700001)(478600001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2021 09:10:56.1449
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: df021eac-e885-4a5f-1d8d-08d8fa6e37e4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT065.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5404
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Si-Wei Liu <si-wei.liu@oracle.com>

When feature VIRTIO_NET_F_MTU is negotiated on mlx5_vdpa,
22 extra bytes worth of MTU length is shown in guest.
This is because the mlx5_query_port_max_mtu API returns
the "hardware" MTU value, which does not just contain the
 Ethernet payload, but includes extra lengths starting
from the Ethernet header up to the FCS altogether.

Fix the MTU so packets won't get dropped silently.

Fixes: 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for supported mlx5 devices")
Signed-off-by: Si-Wei Liu <si-wei.liu@oracle.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Acked-by: Eli Cohen <elic@nvidia.com>
---
 drivers/vdpa/mlx5/core/mlx5_vdpa.h |  4 ++++
 drivers/vdpa/mlx5/net/mlx5_vnet.c  | 15 ++++++++++++++-
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/vdpa/mlx5/core/mlx5_vdpa.h b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
index 08f742fd2409..b6cc53ba980c 100644
--- a/drivers/vdpa/mlx5/core/mlx5_vdpa.h
+++ b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
@@ -4,9 +4,13 @@
 #ifndef __MLX5_VDPA_H__
 #define __MLX5_VDPA_H__
 
+#include <linux/etherdevice.h>
+#include <linux/if_vlan.h>
 #include <linux/vdpa.h>
 #include <linux/mlx5/driver.h>
 
+#define MLX5V_ETH_HARD_MTU (ETH_HLEN + VLAN_HLEN + ETH_FCS_LEN)
+
 struct mlx5_vdpa_direct_mr {
 	u64 start;
 	u64 end;
diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 71397fdafa6a..a49ebb250253 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -1907,6 +1907,19 @@ static const struct vdpa_config_ops mlx5_vdpa_ops = {
 	.free = mlx5_vdpa_free,
 };
 
+static int query_mtu(struct mlx5_core_dev *mdev, u16 *mtu)
+{
+	u16 hw_mtu;
+	int err;
+
+	err = mlx5_query_nic_vport_mtu(mdev, &hw_mtu);
+	if (err)
+		return err;
+
+	*mtu = hw_mtu - MLX5V_ETH_HARD_MTU;
+	return 0;
+}
+
 static int alloc_resources(struct mlx5_vdpa_net *ndev)
 {
 	struct mlx5_vdpa_net_resources *res = &ndev->res;
@@ -1992,7 +2005,7 @@ static int mlx5v_probe(struct auxiliary_device *adev,
 	init_mvqs(ndev);
 	mutex_init(&ndev->reslock);
 	config = &ndev->config;
-	err = mlx5_query_nic_vport_mtu(mdev, &ndev->mtu);
+	err = query_mtu(mdev, &ndev->mtu);
 	if (err)
 		goto err_mtu;
 
-- 
2.30.1

