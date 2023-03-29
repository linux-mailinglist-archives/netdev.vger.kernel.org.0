Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 944B66CD944
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 14:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbjC2MV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 08:21:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229937AbjC2MV2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 08:21:28 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2058.outbound.protection.outlook.com [40.107.223.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5D171FE7
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 05:21:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FXhQZtI2//KC0plAy1Zfb0tIffmu788eQyNeEzc8gvSYnYRwBGfO4loN5CTFnfk5go4YMnrw5hrw+xXpRJQzbsRbDOstT7nejJQ3TkEq/Aybyk0+8O9Vqf7GBBVeZ3HBrdowsBh4T1UvspUpbzZ0j0r+IE3k2aV/IUmt3OoFFAURHtyjQ9Dp4Ovj61NILPCdXsRcj3mG+o9/CaOGeRxdQKkdakXvpQmFaLK3Xoyf64ytWFvMu38TUWob1jPMlYD0aGJBEarJ7u1mrAYlsL7qmgrLi+LqRgNsdE5wFKM1GqZ2uKnk2oPP38bT//FyZtc9viU33sx26ypNuNyBb4sGnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/WuBNCd2fmFPIoXxjDJwQf0jx2RkcMA3i2Mdhgt27Fk=;
 b=DTcI48n8p8wGYN/jQkS6oA/0nU91gH4RWHgm5hvuE2Tqk22SdPortOyrryLoZuV01U77VzOwpXSu/C8ab5RKAET6SYAgqz9q+GdlLOSIi14ysOk7b74fiZTPzVXm4bBdcDb2YT4Ub7KcbISSoeMXRK4EAy3hseEja50jFD8Qlu//b2/tYGqWQaWRVprHRWZLW63PIPLarB2pZRncvlmvJOSYnX+Kj6WMT01qWBiPbV/0/HAy4Nx60BPFX7shKSaZDmbYZ6QZW2F7MFnOVkCjy8ho31Q3LLcZ/YZ1STHxi+067qwyIf4qEVkMT1svRxcCF4NsbDJBzmEv7KoxDCdYMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/WuBNCd2fmFPIoXxjDJwQf0jx2RkcMA3i2Mdhgt27Fk=;
 b=M45V7GgOXN0nghP7qEeIzQeQqaoai6+YdJ1n6mPC4VcjqaFSt7ACFJ3c+Hyy0VsoALnoczKo11fSOWvfANEOPZGi5z6sHwJaPLYvu3b5rSa2v5PCacP+GIjaWkW6RzbUHXBj9crtaCN/ZGGkR6B8RDBkPi5Bh8/7QWCemZsh/TUJhDbGOgvA+mO+dcCcSzrBtRgyYRu91Sb6wo+kCEWRmhHihAC3IMgAZPUHCqNy5bXYFhrECfhQh5b9ZFi7LBmIeEgeDM0aVmp1L8V/T1v0Dtw4HLPL2M6lKCMfoDlfAfbCGYWtHmKrRBcPe7c57u4OmdMaFt8AZ7v19JewTpHxUw==
Received: from DM6PR11CA0059.namprd11.prod.outlook.com (2603:10b6:5:14c::36)
 by CH0PR12MB5170.namprd12.prod.outlook.com (2603:10b6:610:b9::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.35; Wed, 29 Mar
 2023 12:21:25 +0000
Received: from DM6NAM11FT088.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:14c:cafe::43) by DM6PR11CA0059.outlook.office365.com
 (2603:10b6:5:14c::36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.20 via Frontend
 Transport; Wed, 29 Mar 2023 12:21:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DM6NAM11FT088.mail.protection.outlook.com (10.13.172.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6222.22 via Frontend Transport; Wed, 29 Mar 2023 12:21:25 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Wed, 29 Mar 2023
 05:21:17 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Wed, 29 Mar 2023 05:21:17 -0700
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.126.190.181)
 with Microsoft SMTP Server id 15.2.986.5 via Frontend Transport; Wed, 29 Mar
 2023 05:21:15 -0700
From:   Emeel Hakim <ehakim@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <sd@queasysnail.net>
CC:     <netdev@vger.kernel.org>, Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net-next v2 1/4] vlan: Add MACsec offload operations for VLAN interface
Date:   Wed, 29 Mar 2023 15:21:04 +0300
Message-ID: <20230329122107.22658-2-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20230329122107.22658-1-ehakim@nvidia.com>
References: <20230329122107.22658-1-ehakim@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT088:EE_|CH0PR12MB5170:EE_
X-MS-Office365-Filtering-Correlation-Id: 116f184b-6e7b-4ad6-989e-08db30501d78
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tq8RImABqztNCylDA3JAO5/ETc1mPRi2weFucotRAbQaZkmblc3A1VQJpypKEy4fyr4sb5aMNAx9xPX+hOw5ZGoG6km1HrRnGuUh34n7ZpybVDNaoMV6lHbbQM5GHQTgbylNk4bxxG/QRnnBW+5FldgUOSn4Ji1g54QDHUGVtZjGO+75spC8cW7vAYHH2/mPXIylVqdcJUDUnz8lgNI5K632rKQrxlh8Cb7zKJbNjLSy1aO0b2ycUNoqI7J4uJfYEwYG6Lnqe2YGxEKT9H4poF75cfRvuD5uUydyGCh0qc6SkOugxyFsRfrM6pwsT8OAkIb745S9+tLNYtrEpDEWVhoILuWAyrCtGuI/yC5ygAOb9nvnjMhiktFnQRJ/SD+6ZZ6RRx7E2Hx0bztMQeBUtzbmZHYyvShm4WjdzWTrB5leFsmtpzJk6wDgfoSSwHu58nOXhqE7PIj+R96SRGQ8Gp+qS4Mz/7XyKsAnZRfP4+y7ic+iKsHAyfX+HigsMJ9Vt7hKvSHKSg10PliQ4MIihpKnF6g7MzFW1nKgvue2HkWv2AV2KZWd2ZeGgRRHnyYgEKcqPtVuU+xfYeVzwELBd5nA5NMhmmp2Mqgkaj5tLCMFIYlF34rCZsuABv197XZEIJynOG9Aylo3ixOQ+jikFXl2TtCPooPGjHrVgfatHjM/2ZhvvWK9bTdzHOEfOMRF2AuOYlSJR+wSyx8+fkxU/j+H43rYwpHsWGluJjKChxtq8CwQnCUzfM7LR4MdGNJPpQy+dPAGx4nx1UnG9JX4PQ==
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(136003)(346002)(396003)(451199021)(40470700004)(46966006)(36840700001)(6666004)(36860700001)(107886003)(54906003)(2616005)(1076003)(26005)(478600001)(186003)(34020700004)(4326008)(336012)(426003)(110136005)(316002)(70586007)(47076005)(70206006)(7696005)(8676002)(83380400001)(82740400003)(356005)(41300700001)(5660300002)(8936002)(2906002)(7636003)(40480700001)(40460700003)(82310400005)(36756003)(86362001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2023 12:21:25.1610
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 116f184b-6e7b-4ad6-989e-08db30501d78
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT088.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5170
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for MACsec offload operations for VLAN driver
to allow offloading MACsec when VLAN's real device supports
Macsec offload by forwarding the offload request to it.

Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
---
V1 -> V2: - Consult vlan_features when adding NETIF_F_HW_MACSEC.
		  - Allow grep for the functions.
		  - Add helper function to get the macsec operation to allow the compiler to make some choice.
 .../net/ethernet/mellanox/mlx5/core/en_main.c |   1 +
 net/8021q/vlan_dev.c                          | 101 ++++++++++++++++++
 2 files changed, 102 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 6db1aff8778d..5ecef26e83c6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5076,6 +5076,7 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
 
 	netdev->vlan_features    |= NETIF_F_SG;
 	netdev->vlan_features    |= NETIF_F_HW_CSUM;
+	netdev->vlan_features    |= NETIF_F_HW_MACSEC;
 	netdev->vlan_features    |= NETIF_F_GRO;
 	netdev->vlan_features    |= NETIF_F_TSO;
 	netdev->vlan_features    |= NETIF_F_TSO6;
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index 5920544e93e8..08d063f1e5b6 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -26,6 +26,7 @@
 #include <linux/ethtool.h>
 #include <linux/phy.h>
 #include <net/arp.h>
+#include <net/macsec.h>
 
 #include "vlan.h"
 #include "vlanproc.h"
@@ -572,6 +573,9 @@ static int vlan_dev_init(struct net_device *dev)
 			   NETIF_F_HIGHDMA | NETIF_F_SCTP_CRC |
 			   NETIF_F_ALL_FCOE;
 
+	if (real_dev->features & NETIF_F_HW_MACSEC)
+		dev->hw_features |= NETIF_F_HW_MACSEC;
+
 	dev->features |= dev->hw_features | NETIF_F_LLTX;
 	netif_inherit_tso_max(dev, real_dev);
 	if (dev->features & NETIF_F_VLAN_FEATURES)
@@ -803,6 +807,100 @@ static int vlan_dev_fill_forward_path(struct net_device_path_ctx *ctx,
 	return 0;
 }
 
+#if IS_ENABLED(CONFIG_MACSEC)
+
+static const struct macsec_ops *vlan_get_macsec_ops(struct macsec_context *ctx)
+{
+	return vlan_dev_priv(ctx->netdev)->real_dev->macsec_ops;
+}
+
+#define _BUILD_VLAN_MACSEC_MDO(mdo) \
+	const struct macsec_ops *ops; \
+	ops =  vlan_get_macsec_ops(ctx); \
+	return ops ? ops->mdo_ ## mdo(ctx) : -EOPNOTSUPP
+
+static int vlan_macsec_add_txsa(struct macsec_context *ctx)
+{
+_BUILD_VLAN_MACSEC_MDO(add_txsa);
+}
+
+static int vlan_macsec_upd_txsa(struct macsec_context *ctx)
+{
+_BUILD_VLAN_MACSEC_MDO(upd_txsa);
+}
+
+static int vlan_macsec_del_txsa(struct macsec_context *ctx)
+{
+_BUILD_VLAN_MACSEC_MDO(del_txsa);
+}
+
+static int vlan_macsec_add_rxsa(struct macsec_context *ctx)
+{
+_BUILD_VLAN_MACSEC_MDO(add_rxsa);
+}
+
+static int vlan_macsec_upd_rxsa(struct macsec_context *ctx)
+{
+_BUILD_VLAN_MACSEC_MDO(upd_rxsa);
+}
+
+static int vlan_macsec_del_rxsa(struct macsec_context *ctx)
+{
+_BUILD_VLAN_MACSEC_MDO(del_rxsa);
+}
+
+static int vlan_macsec_add_rxsc(struct macsec_context *ctx)
+{
+_BUILD_VLAN_MACSEC_MDO(add_rxsc);
+}
+
+static int vlan_macsec_upd_rxsc(struct macsec_context *ctx)
+{
+_BUILD_VLAN_MACSEC_MDO(upd_rxsc);
+}
+
+static int vlan_macsec_del_rxsc(struct macsec_context *ctx)
+{
+_BUILD_VLAN_MACSEC_MDO(del_rxsc);
+}
+
+static int vlan_macsec_add_secy(struct macsec_context *ctx)
+{
+_BUILD_VLAN_MACSEC_MDO(add_secy);
+}
+
+static int vlan_macsec_upd_secy(struct macsec_context *ctx)
+{
+_BUILD_VLAN_MACSEC_MDO(upd_secy);
+}
+
+static int vlan_macsec_del_secy(struct macsec_context *ctx)
+{
+_BUILD_VLAN_MACSEC_MDO(del_secy);
+}
+
+#undef _BUILD_VLAN_MACSEC_MDO
+
+#define VLAN_MACSEC_DECLARE_MDO(mdo) .mdo_ ## mdo = vlan_macsec_ ## mdo
+
+static const struct macsec_ops macsec_offload_ops = {
+	VLAN_MACSEC_DECLARE_MDO(add_txsa),
+	VLAN_MACSEC_DECLARE_MDO(upd_txsa),
+	VLAN_MACSEC_DECLARE_MDO(del_txsa),
+	VLAN_MACSEC_DECLARE_MDO(add_rxsc),
+	VLAN_MACSEC_DECLARE_MDO(upd_rxsc),
+	VLAN_MACSEC_DECLARE_MDO(del_rxsc),
+	VLAN_MACSEC_DECLARE_MDO(add_rxsa),
+	VLAN_MACSEC_DECLARE_MDO(upd_rxsa),
+	VLAN_MACSEC_DECLARE_MDO(del_rxsa),
+	VLAN_MACSEC_DECLARE_MDO(add_secy),
+	VLAN_MACSEC_DECLARE_MDO(upd_secy),
+	VLAN_MACSEC_DECLARE_MDO(del_secy),
+};
+
+#undef VLAN_MACSEC_DECLARE_MDO
+#endif
+
 static const struct ethtool_ops vlan_ethtool_ops = {
 	.get_link_ksettings	= vlan_ethtool_get_link_ksettings,
 	.get_drvinfo	        = vlan_ethtool_get_drvinfo,
@@ -869,6 +967,9 @@ void vlan_setup(struct net_device *dev)
 	dev->priv_destructor	= vlan_dev_free;
 	dev->ethtool_ops	= &vlan_ethtool_ops;
 
+#if IS_ENABLED(CONFIG_MACSEC)
+	dev->macsec_ops		= &macsec_offload_ops;
+#endif
 	dev->min_mtu		= 0;
 	dev->max_mtu		= ETH_MAX_MTU;
 
-- 
2.21.3

