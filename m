Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4292B1B1851
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 23:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727123AbgDTVW7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 17:22:59 -0400
Received: from mail-eopbgr30042.outbound.protection.outlook.com ([40.107.3.42]:11830
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726050AbgDTVW6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 17:22:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KFPFk4Sds1XmS/lwE2lwCijR7JpxzmX+EXmkmVC4ohfncWQeYA1nGhXGdZG+j/WiZq/ad+m0ilBzVv213Il26/0OA2oUlF/Dh8a+5R0SMXZy9/DB6lvJI03TvgBLIDGE4EQyNGsk09bC7mdOfMC1DY1aNCVpbEm/kVMMQfrxh5gFw4rbGb+NzwLT4zfEqSJPyoMhcStSHj/zi9Llo1XuOgR7+c2fkbuptdbOzFZgA6fkwmAZYZwoh45+cHwJyjNLzAJhM1MO0Y4MEGRNcUg4p8BCk7J7me64vOSLlTz1J/H6jdEYdOXdwaV/l4rBur4ROK256yhf7v/8HwhqzVUD9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2GLWmictuiMELEPc22A1CQcKt551pd8cGYqJp2TYC1k=;
 b=e1LjybwFh4AC5xFjiwuHArsZN1qx8EaGiCdMQGxgnvpIdoo9SUmFm8hlkYDh/Zr6XAjHJduHGrkaNswRL4cAm4TAmd3qtPz0zGy4s19VpuBUTjWmXXycpOeK5bI3RXlxZf0Xi2CoReAptP4T+Fc+RU2X7rf7wgb6q5Fo+laxINUdq3Rxfp2V55YmcMcIOulihbliY6qrQG+VhX2g8+JvDriWf6Db7zOamEXuOXHy/tFfPxZHTsYVTafcBDXYRqX7FHytG0OU5RoFaAN/VgDfY5qbYV1lldYsdz1llhi0sqqeV2C4hZznqRDYgSspIFKYxPngDn7MKDUW/liZ5Sud8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2GLWmictuiMELEPc22A1CQcKt551pd8cGYqJp2TYC1k=;
 b=sLKdwM8vxUBmw4QgR17hMJ7X75Swc2FQy9eJ0Ahk5c4cOV9WI++uM2P8LqVjW9svhLOyElLa0woa3A5b9fjj4L73pfAJBXi4VjEe9wGA8mR2g9/AT8ubVudDRvyERCm+8+YJ8EwfLOJqptDpMkdcfKAkKeb1nZi30AnD1e1RoPY=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6478.eurprd05.prod.outlook.com (2603:10a6:803:f3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Mon, 20 Apr
 2020 21:22:56 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2921.027; Mon, 20 Apr 2020
 21:22:56 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Raed Salem <raeds@mellanox.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Huy Nguyen <huyn@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 01/10] net/mlx5: Use the correct IPsec capability function for FPGA ops
Date:   Mon, 20 Apr 2020 14:22:14 -0700
Message-Id: <20200420212223.41574-2-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200420212223.41574-1-saeedm@mellanox.com>
References: <20200420212223.41574-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR04CA0032.namprd04.prod.outlook.com
 (2603:10b6:a03:40::45) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR04CA0032.namprd04.prod.outlook.com (2603:10b6:a03:40::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.27 via Frontend Transport; Mon, 20 Apr 2020 21:22:53 +0000
X-Mailer: git-send-email 2.25.3
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5873fe03-ff1a-4fe2-6546-08d7e570fdb1
X-MS-TrafficTypeDiagnostic: VI1PR05MB6478:|VI1PR05MB6478:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB647817DD7D7D0768D28D4BD1BED40@VI1PR05MB6478.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 03793408BA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(136003)(346002)(376002)(396003)(39860400002)(366004)(107886003)(6506007)(86362001)(2906002)(186003)(16526019)(26005)(4326008)(5660300002)(36756003)(316002)(1076003)(66556008)(478600001)(956004)(6666004)(66946007)(52116002)(66476007)(6512007)(6486002)(2616005)(54906003)(8676002)(8936002)(81156014)(54420400002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bggR04sn6677q4R2sHe+c8lKUw7UAq7rYo+BRX6Fp8AVdTsLex0qbqmYwRg+Xk3doSSo79R+2GjucaGrUzAgs1WFEAlaUimK49LGILF+xSBYwodhAtsME7XlyBsyxMLu4D77cvPh7l8NBcbP88p+IgbF8HB7ec3MDmuUqF9uxidLd+JMm1+QnfS7Z6QlCJ4UG8ta5zI5B/L3/mXPt/7YbbnHQY7vl3FmnVseM9l6zQva+06nM46WRFJsXlqK8palCxranfW9HB4gvnVN7lUyNoMDCjPO/0W2LZwPZogKksE/3uHbbuXg7P4puK79xSJjzqqR0h+BUQ2DQ/y9SjgIYfDa5ePZdP5gztK+tkXpAYItCqunQUpVl1ck1F2sSozeqjsiofbH6A6pXwIiIWs6FATlaPg1VFdnmxcfFUqf3lJ4x+AOkwAINIYhrQZT2YqPXqSv1zcbpr2kgz52qzpTspSmpjeyroSj+uTN89IoihDh52EpWT8yq604fovB9qnd
X-MS-Exchange-AntiSpam-MessageData: G+3VU0ktcNA1Nc3Ju5lUgFy3Xz6tFeTqtkK20C8Gf5/eW9A7kVuktTWDOT7FenLGzrMkAF0RSJFRtIp3305oDOoN+faD/fQBl+51jGwYUOJnAlnXspPv0C3YdCE84u06+IjtNX8hZ4MG/X3mKnfkvw==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5873fe03-ff1a-4fe2-6546-08d7e570fdb1
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2020 21:22:55.7180
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gau9PaMZ2fb7toRjGCEwz0KoQbXIPZH74axaSja5ydOIMNTwvH2RUp90mDXYZj6SaUMRzKztAsp0xc9WUcRodA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6478
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Raed Salem <raeds@mellanox.com>

Currently the IPsec acceleration capability function is also used
at IPsec fpga capable device code.

This could cause a future bug as the acceleration layer is agnostic
to the device implementing its API.

Fix by using the IPsec FPGA capability function instead of acceleration
layer capability function in case of FPGA IPsec only related operations.

Downstream patches will add support for Connect-X IPsec, this can avoid
a future bug.

Signed-off-by: Raed Salem <raeds@mellanox.com>
Reviewed-by: Boris Pismenny <borisp@mellanox.com>
Reviewed-by: Huy Nguyen <huyn@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/fpga/ipsec.c  |  2 +-
 .../net/ethernet/mellanox/mlx5/core/fpga/ipsec.h  | 15 ++++++++++++++-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c |  5 +++--
 3 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c
index b794888fa3ba..c8736b6b4172 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c
@@ -602,7 +602,7 @@ static bool mlx5_is_fpga_ipsec_rule(struct mlx5_core_dev *dev,
 				    const u32 *match_c,
 				    const u32 *match_v)
 {
-	u32 ipsec_dev_caps = mlx5_accel_ipsec_device_caps(dev);
+	u32 ipsec_dev_caps = mlx5_fpga_ipsec_device_caps(dev);
 	bool ipv6_flow;
 
 	ipv6_flow = mlx5_fs_is_outer_ipv6_flow(dev, match_c, match_v);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.h
index 382985e65b48..d01b1fc8e11b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.h
@@ -37,6 +37,7 @@
 #include "accel/ipsec.h"
 #include "fs_cmd.h"
 
+#ifdef CONFIG_MLX5_FPGA_IPSEC
 u32 mlx5_fpga_ipsec_device_caps(struct mlx5_core_dev *mdev);
 unsigned int mlx5_fpga_ipsec_counters_count(struct mlx5_core_dev *mdev);
 int mlx5_fpga_ipsec_counters_read(struct mlx5_core_dev *mdev, u64 *counters,
@@ -63,5 +64,17 @@ int mlx5_fpga_esp_modify_xfrm(struct mlx5_accel_esp_xfrm *xfrm,
 
 const struct mlx5_flow_cmds *
 mlx5_fs_cmd_get_default_ipsec_fpga_cmds(enum fs_flow_table_type type);
+#else
+static inline u32 mlx5_fpga_ipsec_device_caps(struct mlx5_core_dev *mdev)
+{
+	return 0;
+}
 
-#endif	/* __MLX5_FPGA_SADB_H__ */
+static inline const struct mlx5_flow_cmds *
+mlx5_fs_cmd_get_default_ipsec_fpga_cmds(enum fs_flow_table_type type)
+{
+	return mlx5_fs_cmd_get_default(type);
+}
+
+#endif /* CONFIG_MLX5_FPGA_IPSEC */
+#endif	/* __MLX5_FPGA_IPSEC_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index d5defe09339a..2da45e9b9b6d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -2359,7 +2359,7 @@ static struct mlx5_flow_root_namespace
 	struct mlx5_flow_root_namespace *root_ns;
 	struct mlx5_flow_namespace *ns;
 
-	if (mlx5_accel_ipsec_device_caps(steering->dev) & MLX5_ACCEL_IPSEC_CAP_DEVICE &&
+	if (mlx5_fpga_ipsec_device_caps(steering->dev) & MLX5_ACCEL_IPSEC_CAP_DEVICE &&
 	    (table_type == FS_FT_NIC_RX || table_type == FS_FT_NIC_TX))
 		cmds = mlx5_fs_cmd_get_default_ipsec_fpga_cmds(table_type);
 
@@ -2943,7 +2943,8 @@ int mlx5_init_fs(struct mlx5_core_dev *dev)
 			goto err;
 	}
 
-	if (MLX5_IPSEC_DEV(dev) || MLX5_CAP_FLOWTABLE_NIC_TX(dev, ft_support)) {
+	if (mlx5_fpga_ipsec_device_caps(steering->dev) & MLX5_ACCEL_IPSEC_CAP_DEVICE ||
+	    MLX5_CAP_FLOWTABLE_NIC_TX(dev, ft_support)) {
 		err = init_egress_root_ns(steering);
 		if (err)
 			goto err;
-- 
2.25.3

