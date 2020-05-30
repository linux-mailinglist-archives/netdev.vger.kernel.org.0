Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B576F1E8DD2
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 06:27:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728783AbgE3E12 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 00:27:28 -0400
Received: from mail-db8eur05on2070.outbound.protection.outlook.com ([40.107.20.70]:36101
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728763AbgE3E1Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 May 2020 00:27:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W37kWaJTkJlkV7KiqJpdTiCyURIAL5S1mAwpL+vHfRcEGN03lf8sr53Saxbu5J0SW+OXEdHvKji0KL5w1pTNbLnee4DVsXUcmJvs+8vQ6xOUtgCVdqQbRl5Jnkj79c12vOY2/n+vbIXW4XPGJ2IKirpye1jEiMRIm3vUlDRmhlcgUwLCpXYGx27gseXL26E0AaDu5vVuyY8cZWg0O+mXDrdpgFrcfnHMRwm5R816ZfP6TnZp9FPAP+Ai8uObSF7bkzcn7Ixosyg43VxLIjUj9D1sIem+du6NDkNtTnULOS1dO4gJlaqE3IdDdQ8cVU+LuPGz61yNtWtPr5S+1i/tGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fn4d4vQooknJOo2W/K5lCwPgo9Z471d6Uxrb35x4wdE=;
 b=ihKSM/wJ02LF/uh5XJwvcIxJMMfWUjb+zxCgQimNxyd5fyLm5hAJ0k+QHlh1vsQmpPov7+ZsdRScJ3tMYqnJ2cp2ghwbnr04FQPOt6hlQ+7EdssMu8lSXGnoae4CqiUwnlTp36uxZ64hSv9tQep026o7XFI04vac6vNCZguOR//KtqdQYwj53ASey8eDPSGyBtfHK0/o7Q7hwULQmw2bkaTTd3r4pK0xz601vc/eAAN4K1zRCDP9MTQCPPnFyPY+ZUpW2zHJ7y+Uosrm4cwDl0IJR6bk0CxQc+ti/eZRKbuz1k4y2Mi2y7eihN4DxPJPhAKR0gtiCDHsAktgg8qncg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fn4d4vQooknJOo2W/K5lCwPgo9Z471d6Uxrb35x4wdE=;
 b=mKomCC0gBV/6MAyAE6IdUrvNUu6bgSimLrRkj2M/nhzMcG3c4W9Hln2bcvAMmk/mbqhHLRAs9R/bYeORIWMtIQeGQgGenYiW2cClJZiaBAB80kz/T2BNYDHw1ybRT+GpJHYFLPRiZja6xNa4sLsXvWEO7lhVZotDGPOqBxeA1xk=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB3408.eurprd05.prod.outlook.com (2603:10a6:802:1e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.18; Sat, 30 May
 2020 04:27:11 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3045.018; Sat, 30 May 2020
 04:27:11 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 11/15] net/mlx5: Accel: fpga tls fix cast to __be64 and incorrect argument types
Date:   Fri, 29 May 2020 21:26:22 -0700
Message-Id: <20200530042626.15837-12-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200530042626.15837-1-saeedm@mellanox.com>
References: <20200530042626.15837-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0004.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::17) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR05CA0004.namprd05.prod.outlook.com (2603:10b6:a03:c0::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.7 via Frontend Transport; Sat, 30 May 2020 04:27:09 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 96e41597-b32d-410b-c776-08d80451b8b5
X-MS-TrafficTypeDiagnostic: VI1PR05MB3408:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB340829B48611EE5B7DCC4E1EBE8C0@VI1PR05MB3408.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2512;
X-Forefront-PRVS: 041963B986
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d0wGlX/DeQoAiYr9EUfNrdO6vAQlUdt4d2+2YK5WPWzLz3tyfpxKA8aKZzSVsPnd5wnVKZMLt0pfnJH7xJRJW9ePMt+fDS2OW9elkcIl27h2yAsvtoVYnYXSOC2ww+65NNLtcd7PUuAoE++Kq6wzlFh+Plrl13F+l1ExjmxQ/YcKs6QdcFgMJ+rKkRl3p91rePtFLZyZec0RGcVNKHL9aHm/ygb/fD6SG6ntlQ+oulpv7giYbIQsC9GU/y7hvV4rkqt9ebqC2FLuUwM4pW5MIbzXj9Oa0pntlTr7M3Td3hckFc5HJUxz3E7EeQ2ZoeOenesT08SSMb5YyXpY9OGR1MFA+ACVmMj82WtXCsU9/A/CvFYOem9B2uBfxQRX7+3z
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(376002)(396003)(136003)(346002)(366004)(52116002)(5660300002)(6666004)(107886003)(186003)(66476007)(26005)(16526019)(66946007)(478600001)(1076003)(8676002)(4326008)(6486002)(66556008)(2906002)(956004)(86362001)(6512007)(83380400001)(316002)(6506007)(36756003)(2616005)(8936002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: uoqLF5j7RrJxrgYaVLksIFUsUoXTvFfQf35gcopLbtoCfMlr1IhwWvQDE+Dl9ytG06Edwq3WCVN+rB0kDE4sNACVnzY277z3NH+fGHrDn+nntuhDIgmeXa+olT+1pYH/vkDIVSfUPUmx6BnVvHIiAV2G/p80XfnQeAhIVa9SfA30SzdyR4hqhlwOvxE4sC8HsAx0g+i0rUm0yKK2OJtsR3xFLgLxFMy7Wg1ewWRMu1ld5u6rmKtfIZwsI/WewIWWSDbZJh5domTlspvjJjbV5rkxVbB4ZJtHARbF/X7unTCBUX7cSGFVRg2Su0xU80JqkFDphvT1dLM+jN1kuxwwlidofJKF+I9lJiR5Det7F0SCbXoAM3WAmutIaTc+TKotkJm/ZqlOb1ftsw00Q4hgiSYi2e2E8b5CkyZIIlHSqG8oFbJUOgsbYtqmbmgfS8TZS7pQHexYfMrZPw0gKlERioorpPxtPv3KIoYFp8TrjZw=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96e41597-b32d-410b-c776-08d80451b8b5
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2020 04:27:11.3146
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5BQEE1AjCuMXsE4nbHDIVdZTxC9cewBx+4xRGo4ewcMFpkHkiOiq2GSD+8ACbn4t6YfdHBZUBaBh5BirwnEnYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3408
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tls handle and rcd_sn are actually big endian and not in host format.
Fix that.

Fix the following sparse warnings:
drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c:177:21:
warning: cast to restricted __be64

drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c:178:52:
warning: incorrect type in argument 2 (different base types)
    expected unsigned int [usertype] handle
    got restricted __be32 [usertype] handle

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/accel/tls.c    | 4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/accel/tls.h    | 8 ++++----
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/fpga/tls.c     | 4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/fpga/tls.h     | 4 ++--
 5 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/accel/tls.c b/drivers/net/ethernet/mellanox/mlx5/core/accel/tls.c
index cab708af34223..cbf3d76c05a88 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/accel/tls.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/accel/tls.c
@@ -56,8 +56,8 @@ void mlx5_accel_tls_del_flow(struct mlx5_core_dev *mdev, u32 swid,
 	mlx5_fpga_tls_del_flow(mdev, swid, GFP_KERNEL, direction_sx);
 }
 
-int mlx5_accel_tls_resync_rx(struct mlx5_core_dev *mdev, u32 handle, u32 seq,
-			     u64 rcd_sn)
+int mlx5_accel_tls_resync_rx(struct mlx5_core_dev *mdev, __be32 handle,
+			     u32 seq, __be64 rcd_sn)
 {
 	return mlx5_fpga_tls_resync_rx(mdev, handle, seq, rcd_sn);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/accel/tls.h b/drivers/net/ethernet/mellanox/mlx5/core/accel/tls.h
index e09bc3858d574..aefea467f7b38 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/accel/tls.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/accel/tls.h
@@ -109,8 +109,8 @@ int mlx5_accel_tls_add_flow(struct mlx5_core_dev *mdev, void *flow,
 			    bool direction_sx);
 void mlx5_accel_tls_del_flow(struct mlx5_core_dev *mdev, u32 swid,
 			     bool direction_sx);
-int mlx5_accel_tls_resync_rx(struct mlx5_core_dev *mdev, u32 handle, u32 seq,
-			     u64 rcd_sn);
+int mlx5_accel_tls_resync_rx(struct mlx5_core_dev *mdev, __be32 handle,
+			     u32 seq, __be64 rcd_sn);
 bool mlx5_accel_is_tls_device(struct mlx5_core_dev *mdev);
 u32 mlx5_accel_tls_device_caps(struct mlx5_core_dev *mdev);
 int mlx5_accel_tls_init(struct mlx5_core_dev *mdev);
@@ -125,8 +125,8 @@ mlx5_accel_tls_add_flow(struct mlx5_core_dev *mdev, void *flow,
 			bool direction_sx) { return -ENOTSUPP; }
 static inline void mlx5_accel_tls_del_flow(struct mlx5_core_dev *mdev, u32 swid,
 					   bool direction_sx) { }
-static inline int mlx5_accel_tls_resync_rx(struct mlx5_core_dev *mdev, u32 handle,
-					   u32 seq, u64 rcd_sn) { return 0; }
+static inline int mlx5_accel_tls_resync_rx(struct mlx5_core_dev *mdev, __be32 handle,
+					   u32 seq, __be64 rcd_sn) { return 0; }
 static inline bool mlx5_accel_is_tls_device(struct mlx5_core_dev *mdev)
 {
 	return mlx5_accel_is_ktls_device(mdev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c
index c27e9a609d519..1fbb5a90cb381 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c
@@ -167,7 +167,7 @@ static int mlx5e_tls_resync(struct net_device *netdev, struct sock *sk,
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 	struct mlx5e_tls_offload_context_rx *rx_ctx;
-	u64 rcd_sn = *(u64 *)rcd_sn_data;
+	__be64 rcd_sn = *(__be64 *)rcd_sn_data;
 
 	if (WARN_ON_ONCE(direction != TLS_OFFLOAD_CTX_DIR_RX))
 		return -EINVAL;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fpga/tls.c b/drivers/net/ethernet/mellanox/mlx5/core/fpga/tls.c
index 22a2ef1115144..29b7339ebfa33 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/tls.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/tls.c
@@ -194,8 +194,8 @@ static void mlx5_fpga_tls_flow_to_cmd(void *flow, void *cmd)
 		 MLX5_GET(tls_flow, flow, direction_sx));
 }
 
-int mlx5_fpga_tls_resync_rx(struct mlx5_core_dev *mdev, u32 handle, u32 seq,
-			    u64 rcd_sn)
+int mlx5_fpga_tls_resync_rx(struct mlx5_core_dev *mdev, __be32 handle,
+			    u32 seq, __be64 rcd_sn)
 {
 	struct mlx5_fpga_dma_buf *buf;
 	int size = sizeof(*buf) + MLX5_TLS_COMMAND_SIZE;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fpga/tls.h b/drivers/net/ethernet/mellanox/mlx5/core/fpga/tls.h
index 3b2e37bf76feb..5714cf391d1b2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/tls.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/tls.h
@@ -68,7 +68,7 @@ static inline u32 mlx5_fpga_tls_device_caps(struct mlx5_core_dev *mdev)
 	return mdev->fpga->tls->caps;
 }
 
-int mlx5_fpga_tls_resync_rx(struct mlx5_core_dev *mdev, u32 handle, u32 seq,
-			    u64 rcd_sn);
+int mlx5_fpga_tls_resync_rx(struct mlx5_core_dev *mdev, __be32 handle,
+			    u32 seq, __be64 rcd_sn);
 
 #endif /* __MLX5_FPGA_TLS_H__ */
-- 
2.26.2

