Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A51D046D582
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 15:18:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235042AbhLHOVc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 09:21:32 -0500
Received: from mail-bn8nam12on2078.outbound.protection.outlook.com ([40.107.237.78]:55328
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235019AbhLHOV1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Dec 2021 09:21:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ya2UzbeeJtIvGbvJF+1qT+msG1OyzjzF5fPGe/ssD8vickohXvrLnu1EpcU75oaK5RCiX9vuRq4jVyn7w5SdX9qRSbphRzJ+YpMR3OjuRPa8a4SNTLIbe74JI1wea6eKRZ+2zvB82JwOPeLx6IAo8PklqqNzjuKdY7rjr8dlRkmzdK6T02KhqQVi+VBRB+NugwRCe2VoLa8rBioPTnHjmBLp//de0HuHnxQrkjwfmebbI0pWEkzUUqrMm8rRueSeWYmoOHG3bxMOITOqfKk7RMOwZJhowgBZ6alYpEMmvh8fDJ3nqKs6cEMCUJ8Or9RRSju07vNN2Mcenpus235kRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fU+NT6CNaZnpCVz0VZC3APGBXUm+bP1MJtJDlVfCEeg=;
 b=d8sqZfHajoBavFYLjTzioo5VsjJwXL1xjDrO2pbPJ/A8DChCm6wSE5l/h85/3L79epH/w6C5A8x3TVQaLVGWk5NiGIMk5BPHg8bhbL7DJQXb1WqQBxkdOCfv/EEZG0xddaWqWExyih8+rcSgTNCXwqOPxVDSjSirLXRuIRiYmYD4+KhgZ3DxGxL4fKxD3OuVsi35N4iwvh8x+71UepLs43Pk+oFXJvWj9+T06RGYhon97/3idQWI6+2+uXuCYkJvO8dnHEiYkjdtRm0WsJblaE/oh9WUds7HhFcc4lx6uKcoQifiDZYj8qSX8xrriqVcuMKeOSTVi6JC0LoL7bBGcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fU+NT6CNaZnpCVz0VZC3APGBXUm+bP1MJtJDlVfCEeg=;
 b=bmvesXGRD6lVCqhu+m8nJH526hZ+tNfzmDJP2Ff7NciQAJiJ5aLJsPBr7jrFwGsHgSsoVvsvEXSyat3CNDB+8oJ6gtvDNXe18NOUNyyiU5MF1IXjwakn7PcqTGZ/pdhiDLEYvgdLiPGYUs4mgqPPFfLgeIBya+3njuZcGJ1+n50IaQpHe6xyS9JR/46UKRYqnxM90OvJQqzYWjlCYXmvli/xyurBgizsuZb0bQoDvwn1JJd0+6Xvao4m/OSaxR5MvdM7ySz6AGE0Ks7GMIbOPe1swMOF1JzB5gL2mkxjN/6czGoJ6CQfrfJYtrLyqII42/dg9Nuk14Kn060wBEEeeA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5373.namprd12.prod.outlook.com (2603:10b6:5:39a::17)
 by DM4PR12MB5117.namprd12.prod.outlook.com (2603:10b6:5:390::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.12; Wed, 8 Dec
 2021 14:17:54 +0000
Received: from DM4PR12MB5373.namprd12.prod.outlook.com
 ([fe80::10d0:8c16:3110:f8ac]) by DM4PR12MB5373.namprd12.prod.outlook.com
 ([fe80::10d0:8c16:3110:f8ac%7]) with mapi id 15.20.4755.022; Wed, 8 Dec 2021
 14:17:54 +0000
From:   Shay Drory <shayd@nvidia.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     jiri@nvidia.com, saeedm@nvidia.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Shay Drory <shayd@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH net-next v3 5/7] net/mlx5: Let user configure event_eq_size param
Date:   Wed,  8 Dec 2021 16:17:20 +0200
Message-Id: <20211208141722.13646-6-shayd@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20211208141722.13646-1-shayd@nvidia.com>
References: <20211208141722.13646-1-shayd@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM5PR0502CA0011.eurprd05.prod.outlook.com
 (2603:10a6:203:91::21) To DM4PR12MB5373.namprd12.prod.outlook.com
 (2603:10b6:5:39a::17)
MIME-Version: 1.0
Received: from nps-server-23.mtl.labs.mlnx (94.188.199.18) by AM5PR0502CA0011.eurprd05.prod.outlook.com (2603:10a6:203:91::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Wed, 8 Dec 2021 14:17:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 32a70bd1-8863-4eac-f716-08d9ba55864c
X-MS-TrafficTypeDiagnostic: DM4PR12MB5117:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB5117C56F3A6261C3326813BDCF6F9@DM4PR12MB5117.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ywS/FuntE9sq5dffwjzxCRKZZ49/6hJ6V/Vfy7ZGJV6Z/btVeFbXydQPdgoTD660bp6Cg6NRJvAwnaWF4VzWJuRyHcmGVLv1jufx+e4Fq2CPI8tbtqsKx5VVKCSmOS/BaGADjqkOX4/9a8uoQwnR2TrXWdrrus5HAeuR4IlGoGz2woED9vMdIzMgZOOqfM9BFlTNFU7VNowqfZHV/9bUYPgWdwE4MM/Drk9vPGRwcJ8kmXGZd06ZBYMd/gcrtH/kppG4AfxS72Sx672cRtRe7EYzEVC2bRhlgkgY8oDYYLB83Gy64lc14YgxjMpmghJq2ePuAbJySXCRDs8cJ51fQxqOYNU70nmNnnKYY3oUhiU6CMU9j/OMdOZngHRKsFrGrP8f9X1rYvj+pKV82b4J1ZtLJOgLZtBqGy4u6y30LscPCBLeljfIChaQoJONBD8rt4MrXWfyGbd67KRoXjj3XVrMyO+XpXzHb3twWRfdQK78wzhK2GFyH4IVlUiBnNRNXDuMlwsWoPqdmtFFsmcu/qjOwYl66UrRRPnFgH/LbiDtQ5LXAUOaWW3bUj4T+dHGsfoA5jMXLWIpJJ6YiBfeT1NGZruK6mvSlElDxLelH5ahgJc6cwdmeGy+S9yfgRVhAeCHBJHU+/ut4ajTpGeZuaa+/o22EH/6iHOo23WoDzXaW4l1QaKIIwt1bOoC2jx9Zhppz1W6z3EgJOmK9sLzvg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5373.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(316002)(83380400001)(52116002)(4326008)(107886003)(86362001)(54906003)(6486002)(110136005)(6506007)(26005)(66946007)(66476007)(66556008)(6666004)(186003)(36756003)(8676002)(6512007)(8936002)(508600001)(1076003)(2906002)(2616005)(956004)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?q+WJYBBHXUEi51JDjGbshdtaQLGFRewEVZtNMcDDn8WoyCdNJI4I4XiqZhPV?=
 =?us-ascii?Q?oF5VcJtqf/zMdctml6EwCgHSAkXN/mqaD1+Gb/vtFytjmrbBDNJIzGDsBdjR?=
 =?us-ascii?Q?b16sbgZhNaLyA12zcjZk8jPSMgt2Fk28qoj3AyJ6UX30/KSB46Mbl7Ryc0v8?=
 =?us-ascii?Q?keijqs5D/WYuAnSEbN9H5i2jWI1yeNVnd3XesUbyS6hYL3VqXttEt7FcuSsk?=
 =?us-ascii?Q?q3UmBMNCFGS9tH5qKw4hOCMYeiDqeo9HSr9Q64Fdv9LzcxQ8sVvYzdamPEWF?=
 =?us-ascii?Q?tThoQkyZJo6o2v89/NTl9GxMPrs6pN2z2njJQbZ87zKzKFSyqicHHacuWoEX?=
 =?us-ascii?Q?IaZH9Te7swNDEQ/tRz/FGPVxl05Is4TEpKOCtrlvMWtxIG9k38rq5i0jYI7x?=
 =?us-ascii?Q?cOaE/kkImP/TqeO+ewhfYvhX12gOTKViU5gg7BEYiydzZ9XWiRdILrvHsIth?=
 =?us-ascii?Q?pL+K8rlB57mDWzNsNjFzeYoa/b1s2msKCOi0oSF+cqZXiolQRs7nzLJkXYPc?=
 =?us-ascii?Q?c79QgQTVwub9nFHGWzj7EYcWah0/7gy35LOjPODBg3TPDLDMTczpDwPgNBQ2?=
 =?us-ascii?Q?DhRvXInXmD9fH609eEF/yIjIoXIBzoU9gt8wwusm74TxE5rlRI4uLFVqd/bu?=
 =?us-ascii?Q?mSiafXb+uO8Qn6tRQcW+HI8M2u+xusiI0ApOfpjCyPTXz2501m1md+IDEgby?=
 =?us-ascii?Q?e5DtqHe0xdgztrNPTme2grnL7M+GqyvU2vw9wTI7GwrZ2ARUryvsa5JCA3zt?=
 =?us-ascii?Q?knympGLxPGfeeLJBlfaXZ/P9SIat5XjiQDoy8ynSKJ8JnnyhwJEeCoppZ96c?=
 =?us-ascii?Q?mrvln7ozYsdWk1E+svue8xQYgh+B73DTQr1ssamCCksh7xgGdCAppYp2G8RS?=
 =?us-ascii?Q?NERv3QcGcLaB3QsO5pn4Vh3FRGP3aZBCPhTx/EidGfCQZlGCtHLumLHymDNS?=
 =?us-ascii?Q?v/afntgV3xVWcnEnE/2yNhvHF+C4nWCjcRrzybHrdC3V1FOEhH6dKLSORfhY?=
 =?us-ascii?Q?kFnHqn/S6dY2IzhNDPGvEHxrK5SVILG0CGj3oE8QXd0yOI47a0ZfVwoGCaMH?=
 =?us-ascii?Q?oobCG7Mf7cWK+QLmduRraXFiGMpq2DL6PiYuHviR65BX6W1A7Abpk2uVCh4W?=
 =?us-ascii?Q?xJaeeL+CPSP91ITDpzs1sYrw7/ZlUHYkraScYblV1PjuhnsS46U8UYYGdhE0?=
 =?us-ascii?Q?WUEZRhzTGhrJ0y0fWFH8g3v/YPW0Xp4KVeiCUP4VwRURh3voBsJYSzK5kxsd?=
 =?us-ascii?Q?7Az9H3gQOUjV8bRfwcylfQJg74RPid6ldcCRU59YSU/PBAZG9rAMze6HLwHF?=
 =?us-ascii?Q?pSkxH/IIOHDwZs6NO6bfbBvcjib83Cvmf+JPy1OtNmleJvn0dlFNQHyLLtTU?=
 =?us-ascii?Q?XStglXfau5Cex+Q1ZX7Cc0UaEiOLDdQFRpHblEdFHGRGxbAVyfH7yl5Hlo9I?=
 =?us-ascii?Q?TUaVfh0azVgvLUf5Kia8MDn+FDiJQQlWEoigqH9/BW1bzAsxftkf+zlqrsyW?=
 =?us-ascii?Q?vOZTtj3AU6xlL9rY1ILkucbD+ob9P8emCSQ7J/4DJBnjUk5BOlaq2nwcBroV?=
 =?us-ascii?Q?7l5RKhAwAK4vZ0mF9+PbLQ8YEmG58ppwF2ckIcfMFyBHJ+CBehwP6LFhSmCp?=
 =?us-ascii?Q?kE3Fu+kXq+misq4grjZWrgA=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32a70bd1-8863-4eac-f716-08d9ba55864c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5373.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2021 14:17:53.9436
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wZBX2oqGG4Jt/6CpAabgP5obgmAsFZb+jKZBBxGy0+bqVIkAkmkbtWtqcJ6ZpUt7IKOxH0wg26w3FM0//aFOew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5117
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Event EQ is an EQ which received the notification of almost all the
events generated by the NIC.
Currently, each event EQ is taking 512KB of memory. This size is not
needed in most use cases, and is critical with large scale. Hence,
allow user to configure the size of the event EQ.

For example to reduce event EQ size to 64, execute::
$ devlink dev param set pci/0000:00:0b.0 name event_eq_size value 64 \
              cmode driverinit
$ devlink dev reload pci/0000:00:0b.0

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
---
 Documentation/networking/devlink/mlx5.rst        |  3 +++
 .../net/ethernet/mellanox/mlx5/core/devlink.c    |  7 +++++++
 drivers/net/ethernet/mellanox/mlx5/core/eq.c     | 16 +++++++++++++++-
 3 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/devlink/mlx5.rst b/Documentation/networking/devlink/mlx5.rst
index 291e7f63af73..38089f0aefcf 100644
--- a/Documentation/networking/devlink/mlx5.rst
+++ b/Documentation/networking/devlink/mlx5.rst
@@ -20,6 +20,9 @@ Parameters
    * - ``io_eq_size``
      - driverinit
      - The range is between 64 and 4096.
+   * - ``event_eq_size``
+     - driverinit
+     - The range is between 64 and 4096.
 
 The ``mlx5`` driver also implements the following driver-specific
 parameters.
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index 177c6e9159f8..37b7600c5545 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -579,6 +579,8 @@ static const struct devlink_param mlx5_devlink_params[] = {
 			      mlx5_devlink_enable_remote_dev_reset_set, NULL),
 	DEVLINK_PARAM_GENERIC(IO_EQ_SIZE, BIT(DEVLINK_PARAM_CMODE_DRIVERINIT),
 			      NULL, NULL, mlx5_devlink_eq_depth_validate),
+	DEVLINK_PARAM_GENERIC(EVENT_EQ_SIZE, BIT(DEVLINK_PARAM_CMODE_DRIVERINIT),
+			      NULL, NULL, mlx5_devlink_eq_depth_validate),
 };
 
 static void mlx5_devlink_set_params_init_values(struct devlink *devlink)
@@ -622,6 +624,11 @@ static void mlx5_devlink_set_params_init_values(struct devlink *devlink)
 	devlink_param_driverinit_value_set(devlink,
 					   DEVLINK_PARAM_GENERIC_ID_IO_EQ_SIZE,
 					   value);
+
+	value.vu32 = MLX5_NUM_ASYNC_EQE;
+	devlink_param_driverinit_value_set(devlink,
+					   DEVLINK_PARAM_GENERIC_ID_EVENT_EQ_SIZE,
+					   value);
 }
 
 static const struct devlink_param enable_eth_param =
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 7686d7c9c824..b695aad71ee1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -623,6 +623,20 @@ static void cleanup_async_eq(struct mlx5_core_dev *dev,
 			      name, err);
 }
 
+static u16 async_eq_depth_devlink_param_get(struct mlx5_core_dev *dev)
+{
+	struct devlink *devlink = priv_to_devlink(dev);
+	union devlink_param_value val;
+	int err;
+
+	err = devlink_param_driverinit_value_get(devlink,
+						 DEVLINK_PARAM_GENERIC_ID_EVENT_EQ_SIZE,
+						 &val);
+	if (!err)
+		return val.vu32;
+	mlx5_core_dbg(dev, "Failed to get param. using default. err = %d\n", err);
+	return MLX5_NUM_ASYNC_EQE;
+}
 static int create_async_eqs(struct mlx5_core_dev *dev)
 {
 	struct mlx5_eq_table *table = dev->priv.eq_table;
@@ -647,7 +661,7 @@ static int create_async_eqs(struct mlx5_core_dev *dev)
 
 	param = (struct mlx5_eq_param) {
 		.irq_index = MLX5_IRQ_EQ_CTRL,
-		.nent = MLX5_NUM_ASYNC_EQE,
+		.nent = async_eq_depth_devlink_param_get(dev),
 	};
 
 	gather_async_events_mask(dev, param.mask);
-- 
2.21.3

