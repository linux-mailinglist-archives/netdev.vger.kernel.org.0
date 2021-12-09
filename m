Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 545F146E65A
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 11:10:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233641AbhLIKNp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 05:13:45 -0500
Received: from mail-bn8nam11on2070.outbound.protection.outlook.com ([40.107.236.70]:2973
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233296AbhLIKNk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 05:13:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MavpZaSeIoZaNpnc6o20jFqQ7WNfI082d/CN1FVvylMYKp8lq4bKRAXaQTBWbF4OFNb99egEZvIngVgfWulHVaO1cj067JEllmvGomIAqgWDM5f6xcdz/C2Ml5DWtRNIqKtWLwwvYPW118+cX4X7V0L14Yiiw9UsJvnrjghuJ8kvok7raFeKpuIBsDcGPb2zXt9zBTlhiAazShdGyVa2g5HNT4anmjIQB1c6bssyuywQ6pwxgXeoDX95SwX3Nekra9GfH3B3Ot9qUNgxHJNocO6eylOb2KSM2CRJDzZe/TmkmvI8jIxyWJeQbruMW1Dgvs17cqmb9NG8+ih4LumGug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fU+NT6CNaZnpCVz0VZC3APGBXUm+bP1MJtJDlVfCEeg=;
 b=MLAxRH3CVnngG4+33ylWfbnY/RSkYErfVKgSBL2+z2ra1E5s288YTGhWbSj9k1QXGDxoh9SlpcolJYgyxbaGvy1O7ayabjmfRka9tiKOY7e5+7ElwSQaOhzz52DIVETPqMECxRGiOsU+OLanKoxp5xxg6chxx5dPrRmeZKsC54P3vGTZLLEopEoXx4SlE6A6PIE1CLE01VJTAU/Q5YAssT5mF5j+lQZ9s3HD3S91SWrg0agrJNFlVwbUOWswgg6GvRH0iTaCkgDtBoGCpczFXju4XG8QLozNUtq/SxYcNwkPxblQ/6rtnFNSYBrM4dhSRXmUcxmT/P8dFZq0gr5A0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fU+NT6CNaZnpCVz0VZC3APGBXUm+bP1MJtJDlVfCEeg=;
 b=gR32r7XWKuhfVV02hfrj6BnmGHApEnAivvf2+DX4TJK6U8Ft6hRRuFPRRM4+Potd5YeRna91SVQidVlBbTU+ZVyO2h66PeRuIqRTJZBrF5GABFfbcTtfJxLDBzFZMTMgvl/Fzl41CtNqPMZQPRCFTEayCC0xD6uZ0ZmfBni5MzOjTSpsNG7XosP1e6gZ/K1kS34RBWY8JoRTuRCQWnksl98hLveBbOfTRja4nB1YxEVdvJMhLXYD4BIXd/Q1YgpCO5KoeG0Y9aykRba6LLdMMCHSoBxjUGzKumdpl38MU5dkNuGDrqmgUP14Lhxh9BrM/5Ezcx0BleCZ+KFnrYXHMQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5373.namprd12.prod.outlook.com (2603:10b6:5:39a::17)
 by DM4PR12MB5311.namprd12.prod.outlook.com (2603:10b6:5:39f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11; Thu, 9 Dec
 2021 10:10:04 +0000
Received: from DM4PR12MB5373.namprd12.prod.outlook.com
 ([fe80::10d0:8c16:3110:f8ac]) by DM4PR12MB5373.namprd12.prod.outlook.com
 ([fe80::10d0:8c16:3110:f8ac%7]) with mapi id 15.20.4755.022; Thu, 9 Dec 2021
 10:10:04 +0000
From:   Shay Drory <shayd@nvidia.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     jiri@nvidia.com, saeedm@nvidia.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Shay Drory <shayd@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH net-next v4 5/7] net/mlx5: Let user configure event_eq_size param
Date:   Thu,  9 Dec 2021 12:09:27 +0200
Message-Id: <20211209100929.28115-6-shayd@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20211209100929.28115-1-shayd@nvidia.com>
References: <20211209100929.28115-1-shayd@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6P193CA0076.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:209:88::17) To DM4PR12MB5373.namprd12.prod.outlook.com
 (2603:10b6:5:39a::17)
MIME-Version: 1.0
Received: from nps-server-23.mtl.labs.mlnx (94.188.199.18) by AM6P193CA0076.EURP193.PROD.OUTLOOK.COM (2603:10a6:209:88::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Thu, 9 Dec 2021 10:10:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 488501ea-0338-46f3-9705-08d9bafc11bc
X-MS-TrafficTypeDiagnostic: DM4PR12MB5311:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB5311DDBB2FB787FB103A7223CF709@DM4PR12MB5311.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AA1SEOHz+UIc45LF2+XKX1Ymks09imGWPHtbfftt+gi8pzW23xW7gi94+opwUg/LU1y1QlQ7YsqY6AmgyubhU3AxenkBmIE1respQuWK5+LzCQBn1gWeoiUQGjI63H6/6e8B9DvYFqLvBnvQ3a/HnKBhq5wi1gyZWQrdMuQe27LjfSu43Ime605qBjc4CsYtMNtCY5ujuAtM87YyCSaL69CqyEb/oVdg7n68vxi2NizGlScKJeL0TFVZ8MsJlsNlcLmd3us1Wrv8uqMuBqXu7u+rBNxHeVySBBfbXSnVVGPYeulGiKtf9XrNwvCC3DhpwnTLfQo2chNygFpbny7dH/jUQ94wJxnBJsxdu+QDfywvXG96paWIICdHZbBnE7I84DLNcYFP6Prtuocgt80B4/aDk9lm5f9ZtolQ37kyxxaSPV8n/qo44qNkL1kgXiRKH5IMkjhPpTOtQbO2LBvzD7fVs9B3g3hlltu05AFcZIeTyFEUnb+m86M3lCevTAV1VXopOzs45d6iRDZBE/BUjlYJJJ2kmET1gyC75PhMNx/YK2yD/MAgG9PXT+jT7/OjGsC0nrH4ossvCj6y5OQCetbFkNJGUoOf/2mQ5/DeK4maTnTgQuOZzMxt1axmtUd36HPyrJRh1ZjyUlyPwWF4xToUfTgy/4BsxB62wros+8EpZ4HGR/Sp4ymgWjwdLRMchatY1RJXZuAIelMuUodd5A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5373.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(66476007)(66556008)(956004)(38100700002)(38350700002)(2616005)(508600001)(6666004)(26005)(6506007)(1076003)(4326008)(52116002)(5660300002)(316002)(8936002)(54906003)(110136005)(107886003)(2906002)(8676002)(186003)(6512007)(36756003)(6486002)(86362001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?omiN4RAUf4piPM9Cwx1hxtYJnY4iY+Fb3Bhq3iZVBWEglsoSOslHFWTGVSoI?=
 =?us-ascii?Q?Id+3NCEijoQK6RiS30WMntk3Wyd1W+CDKUEfCBemPKG6EcS4iwiDWW+xbJts?=
 =?us-ascii?Q?t6sMmD4GyGCfYym9YitpkBXTIAahHIi7NZKCuP2GTWu1WDGkv8RjTvKfBdeL?=
 =?us-ascii?Q?bMwtZFW35FLbFhZUk5Qr787HODzAIrYf2IsacLIVEcMtlGFwQSasFZ/gYa91?=
 =?us-ascii?Q?fOwDXK+jFocRV0ARn63aoYoYTeHzitGA2XD+dMnA39Q2rJQ8I/qTuJZIKbUh?=
 =?us-ascii?Q?nB80uHdUvFJwcDv4Ss/MKeT9Jti6OMOlV3+w7BVRWL4FeTgEbs8eEulA/R3h?=
 =?us-ascii?Q?3583B04qX8Au/lhw4UlQ3rjZDS5Z5s7M0FhLpVGiITCebf7Mf19O7evQDpSa?=
 =?us-ascii?Q?NxWpZTOkKHatfNiBJ8QhloeIFeExZ3z+3O+5NGbW8nWP1lci/rMQH1obyT7T?=
 =?us-ascii?Q?08TxcPjcdXZOnVM6e/8BUeIRh9Md+60TA8LuAK2BtfDKN6toFrygtUzXk2Zb?=
 =?us-ascii?Q?GuUNLI/vmzHfDpeDk/bT7cVt+v5Bjcx8+TPFvSSJYvc5ePqYjOIz0q1kDVxp?=
 =?us-ascii?Q?g22w4zUBux6NNuk4ACgy2guizq0wqF7kZdaJgVO/5f8bo4Cjda9ST8nKC0M2?=
 =?us-ascii?Q?3omK1E2lP+HAi9shBi4JQXJpWq7g9M4gckqGUjQksylR5QUp+DJ0vzw07aTR?=
 =?us-ascii?Q?5pSTXNq9NEtw7WtGGmtD/nvMdpFRieyeQq4OKs8Jan3CEprZaRJ/OFT+SZ2f?=
 =?us-ascii?Q?uFKqh6fJXHxYin5J2UP5dcAfJ+jb9fVllCT4Ipp/NJ/cpu29z0uRQ/InupUh?=
 =?us-ascii?Q?v9eXL3fqa59m9Njde8tAmfXkHJY+0SMLmQ/j7qv3JC3yxSlbNt4hpt9Tn9tU?=
 =?us-ascii?Q?81EW/6i5Tig9fF1Mpe/h00WsdzOxkcEpW4TIrpAaa/CmyYgcI9zDNlFgXc/B?=
 =?us-ascii?Q?UMJJGG2GFy/yxI8WJvmYQ06GK9NF6qCiM6Z7TkgrS3jEMUiL9WGR6qn9itVt?=
 =?us-ascii?Q?KBv2ZJVKtdiFylSb4aG5aQ0sZY5mZUd27cEn4o3cmhip4Q0u0VFssW0Pbtla?=
 =?us-ascii?Q?dKjkIXNuhfrIOeoNViU5ztze/joG5xqgTHrNp0JX3Yx0QhM9ZXMuI20xCDtY?=
 =?us-ascii?Q?ocwr+YqsuQKdimIlhRY3Ru984EDVuKWM0DoEAg/chTt5hC+S+ApD9nnd1rm0?=
 =?us-ascii?Q?0+Ey00jd/KRRNwqx78+V4tm2lqJKPogaRWZOFflTd2RdgARG2JFqdbPShWGF?=
 =?us-ascii?Q?+LGYgy8p0KL7KGLeGguzpBBEvUSNqMP3owu/9qAtU4G8r7w4up15LIrW8XX3?=
 =?us-ascii?Q?4WiY6gZv4z8A7Rbyqr9cjgULQw68nnRczmpgDeFpkYLMnI1db4gtK+QwdN6A?=
 =?us-ascii?Q?zcU3NwPo1L1u3EdwJMFTd6uxH38EjjXofuRgNkmP49J0k+243nMy4mh9O5fx?=
 =?us-ascii?Q?ZgfDLMH3D2Iy8pVzSIBL4RewlfT0IGW9/Z69ljkoFzkUb1bQMSgh3uDmKviR?=
 =?us-ascii?Q?QDaN01/aJJE6gR/axk60yq8UGhZkAS//cFYA85VmpaEBxFrNguyJ3v62+uSM?=
 =?us-ascii?Q?sYgwmQ6WcYrvacFJoN0JpnOnFBr5pkNNN4TYgJTnzXyKWVN0x1wFzPBUSxAe?=
 =?us-ascii?Q?0tOBZQemGSi5XpdBg7dSgB4=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 488501ea-0338-46f3-9705-08d9bafc11bc
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5373.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2021 10:10:04.4042
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EUsbCcbe1/PbGO6M8hMLTMbi8pFVgodgXHTIva8l40n5GsAlFuFISjKN9O15QzPnEhuTgUv9BNWVozog/XMjSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5311
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

