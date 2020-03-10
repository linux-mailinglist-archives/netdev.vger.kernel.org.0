Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF8917EE1D
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 02:43:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbgCJBnb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 21:43:31 -0400
Received: from mail-vi1eur05on2047.outbound.protection.outlook.com ([40.107.21.47]:6053
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726284AbgCJBn2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Mar 2020 21:43:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i5S2h0g9Xiz57YXvFwbwWqpM6fIxbj8pl+zS3oOurgtZNG8H5ohylNmUztDJNqNGevAWKhQBCtvwetQsVNSxJufg8SvnWUOA5S/ELK26idHIljOL5BoVn7aGVTUnBbPXVBiJi+WseoYQcaRtHNjoiJ/EkYZteOsxUoFr2I9IF4bX/n4vV7g47aRU/EJAKYZXGjP4BkV2cZn8/hl3N0cmRYIk9gSNkJ6HMuLxyKBLcepS/ox1GDjmsRAcgJ2pjpqmwj7BweCqUOMOVcilwT9yHKLRK+Jg/VPhZFCGkVEdlz48/sX33d7A+x2x+iEXtSMwsU+f7HQHS3DEfQIEDEMWsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/xtiso4lhCIf1/46vGCezQzZkHWVLw4RulPSDUIFcIY=;
 b=EyDtc5rjqXJxpTwYrW5c8janBloteSrwkBfrNqGyA7Ozf6CZuyk2CipIrx0e978uBlDwQcla8M38iRcCl7AA52im+lmCycSX1XrC2gi5L6iidEXoaU5Zwp2RAflexPYmvxtpsrlNgO2/EdMTy7nnxDxXpybZz9hyaPZ16VQSYRTryDeseK2/2aeHtCIGLxbzknOiuVF00549fqWY1CmCqY4mlkcfcWOYJr12JU2q6sc8W+G3QTFzEgqz+JRZhqNutDJopV0qcJFFHEuJt4aJQMswoQ3r6W0vuOdYhH7JxdX/0R+EBp/i7QkwgGPjT1aZVDpbie9pqWtDYOdZjxn/Yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/xtiso4lhCIf1/46vGCezQzZkHWVLw4RulPSDUIFcIY=;
 b=rYlBjBaq6YnkiCiOEhS1HWbEuWdoMp1xzj7/HhB68aDi7h/ZidHE5w/r4T9mrw5/2K/kE3Ghp7JJ52TPlz3nmi/AOIleL6p91N3AQwu8O5nTBT+HgfZcMULaE0Cam9v3YhDKFaRuYCatsJyjWcj36/3MqGhzPpSNxXEn2gMRmS8=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5533.eurprd05.prod.outlook.com (20.177.201.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.17; Tue, 10 Mar 2020 01:43:18 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2793.013; Tue, 10 Mar 2020
 01:43:18 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Parav Pandit <parav@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Bodong Wang <bodong@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 07/11] net/mlx5: E-switch, make query inline mode a static function
Date:   Mon,  9 Mar 2020 18:42:42 -0700
Message-Id: <20200310014246.30830-8-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200310014246.30830-1-saeedm@mellanox.com>
References: <20200310014246.30830-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0068.namprd08.prod.outlook.com
 (2603:10b6:a03:117::45) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR08CA0068.namprd08.prod.outlook.com (2603:10b6:a03:117::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.15 via Frontend Transport; Tue, 10 Mar 2020 01:43:16 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c9119d5b-75d5-4fab-4002-08d7c494687d
X-MS-TrafficTypeDiagnostic: VI1PR05MB5533:|VI1PR05MB5533:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB5533E0CECA9DB06402ECF16CBEFF0@VI1PR05MB5533.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-Forefront-PRVS: 033857D0BD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(396003)(136003)(366004)(39860400002)(199004)(189003)(66476007)(16526019)(316002)(1076003)(66946007)(66556008)(8676002)(86362001)(6506007)(478600001)(107886003)(5660300002)(81166006)(81156014)(6486002)(956004)(36756003)(2906002)(6512007)(4326008)(54906003)(8936002)(26005)(2616005)(52116002)(6666004)(186003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5533;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uGY8UC8thKWiYsbOO2XVnybJfp+/cffz0n62dzPrOkZM+LIXbalh4HvF2yJ+AhBOjSt00PTZvw5tuwSrZmxSFY52+OiBaIBm9wqMrhiA7xny8l5eVxVrg0b2g2wLSo8RnuZzicluwWzbpTq5o+pe6jlK81DjTX74pDCr6oSGfCgEwjp/FbynfL82fofzqbPSTf5MuFPGICLMob5dvej+uqekfdd1zh2laQLdcuksqDzI2UuL+pRJ2qMto9tSncpObGJhdTbcJn4f9YcLbELXQKTRYQJL9KndfwWBDwr76JxkKIdrr/vCB46TfHUNYz/VmCFgxq6gUBadTzJuQL7KbaTG0OQCWfHQOfHJjocWPK/7IZcGxfLczQmulBdjpVtX6gvcoKeZrxQwkj1lK5ceMWcCP7xiwDA7x8ac6nh+IWXuF+iS3ubQOaeZ7/qNtncwOJ189AXZ5RHNSphvaBAxLqnDCuzSKMNpwgwN17I0DmZfZnUXhZfSpi7TyZv3S2jqlaK3NbKF0bcH4goIrp4xvpIOOvZXZ8H2AOOoNvNlruU=
X-MS-Exchange-AntiSpam-MessageData: tYnVF8RP+/p9qajt/vl0sl5tzOGL5EwXXOQI+VRhLevuHVvZJ+bWgqpnqP/IqOTZ8ryFJs6HkvNHk4L2IDoz7mDc64OR/r0o0WxKDVJyiKmsrQlWhCA7lLFWilEEuG5kzX/qIiavv8SxoU/auJBHUg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9119d5b-75d5-4fab-4002-08d7c494687d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2020 01:43:18.5426
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hyyw0JEBtnVueuNV8QLg9yH9FT4+xBbqqcXpszp5NzKyJP4oeQqE5yq+SFtkLDSnpiK/1RlrcqbYvQekIfrmWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5533
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

mlx5_eswitch_inline_mode_get() is used only in eswitch_offloads.c.
Hence, make it static and adjacent to its caller function.

Reviewed-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Bodong Wang <bodong@mellanox.com>
Signed-off-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  1 -
 .../mellanox/mlx5/core/eswitch_offloads.c     | 74 +++++++++----------
 2 files changed, 37 insertions(+), 38 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index d010657ce601..99073342b500 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -425,7 +425,6 @@ int mlx5_devlink_eswitch_mode_get(struct devlink *devlink, u16 *mode);
 int mlx5_devlink_eswitch_inline_mode_set(struct devlink *devlink, u8 mode,
 					 struct netlink_ext_ack *extack);
 int mlx5_devlink_eswitch_inline_mode_get(struct devlink *devlink, u8 *mode);
-int mlx5_eswitch_inline_mode_get(struct mlx5_eswitch *esw, u8 *mode);
 int mlx5_devlink_eswitch_encap_mode_set(struct devlink *devlink,
 					enum devlink_eswitch_encap_mode encap,
 					struct netlink_ext_ack *extack);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 3bed4f0f2f3d..1a909d47aee2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1344,6 +1344,43 @@ mlx5_eswitch_create_vport_rx_rule(struct mlx5_eswitch *esw, u16 vport,
 	return flow_rule;
 }
 
+static int mlx5_eswitch_inline_mode_get(const struct mlx5_eswitch *esw, u8 *mode)
+{
+	u8 prev_mlx5_mode, mlx5_mode = MLX5_INLINE_MODE_L2;
+	struct mlx5_core_dev *dev = esw->dev;
+	int vport;
+
+	if (!MLX5_CAP_GEN(dev, vport_group_manager))
+		return -EOPNOTSUPP;
+
+	if (esw->mode == MLX5_ESWITCH_NONE)
+		return -EOPNOTSUPP;
+
+	switch (MLX5_CAP_ETH(dev, wqe_inline_mode)) {
+	case MLX5_CAP_INLINE_MODE_NOT_REQUIRED:
+		mlx5_mode = MLX5_INLINE_MODE_NONE;
+		goto out;
+	case MLX5_CAP_INLINE_MODE_L2:
+		mlx5_mode = MLX5_INLINE_MODE_L2;
+		goto out;
+	case MLX5_CAP_INLINE_MODE_VPORT_CONTEXT:
+		goto query_vports;
+	}
+
+query_vports:
+	mlx5_query_nic_vport_min_inline(dev, esw->first_host_vport, &prev_mlx5_mode);
+	mlx5_esw_for_each_host_func_vport(esw, vport, esw->esw_funcs.num_vfs) {
+		mlx5_query_nic_vport_min_inline(dev, vport, &mlx5_mode);
+		if (prev_mlx5_mode != mlx5_mode)
+			return -EINVAL;
+		prev_mlx5_mode = mlx5_mode;
+	}
+
+out:
+	*mode = mlx5_mode;
+	return 0;
+}
+
 static int esw_offloads_start(struct mlx5_eswitch *esw,
 			      struct netlink_ext_ack *extack)
 {
@@ -2491,43 +2528,6 @@ int mlx5_devlink_eswitch_inline_mode_get(struct devlink *devlink, u8 *mode)
 	return esw_inline_mode_to_devlink(esw->offloads.inline_mode, mode);
 }
 
-int mlx5_eswitch_inline_mode_get(struct mlx5_eswitch *esw, u8 *mode)
-{
-	u8 prev_mlx5_mode, mlx5_mode = MLX5_INLINE_MODE_L2;
-	struct mlx5_core_dev *dev = esw->dev;
-	int vport;
-
-	if (!MLX5_CAP_GEN(dev, vport_group_manager))
-		return -EOPNOTSUPP;
-
-	if (esw->mode == MLX5_ESWITCH_NONE)
-		return -EOPNOTSUPP;
-
-	switch (MLX5_CAP_ETH(dev, wqe_inline_mode)) {
-	case MLX5_CAP_INLINE_MODE_NOT_REQUIRED:
-		mlx5_mode = MLX5_INLINE_MODE_NONE;
-		goto out;
-	case MLX5_CAP_INLINE_MODE_L2:
-		mlx5_mode = MLX5_INLINE_MODE_L2;
-		goto out;
-	case MLX5_CAP_INLINE_MODE_VPORT_CONTEXT:
-		goto query_vports;
-	}
-
-query_vports:
-	mlx5_query_nic_vport_min_inline(dev, esw->first_host_vport, &prev_mlx5_mode);
-	mlx5_esw_for_each_host_func_vport(esw, vport, esw->esw_funcs.num_vfs) {
-		mlx5_query_nic_vport_min_inline(dev, vport, &mlx5_mode);
-		if (prev_mlx5_mode != mlx5_mode)
-			return -EINVAL;
-		prev_mlx5_mode = mlx5_mode;
-	}
-
-out:
-	*mode = mlx5_mode;
-	return 0;
-}
-
 int mlx5_devlink_eswitch_encap_mode_set(struct devlink *devlink,
 					enum devlink_eswitch_encap_mode encap,
 					struct netlink_ext_ack *extack)
-- 
2.24.1

