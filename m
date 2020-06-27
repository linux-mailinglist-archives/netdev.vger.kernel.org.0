Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DAEC20C449
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 23:19:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbgF0VTY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 17:19:24 -0400
Received: from mail-eopbgr60076.outbound.protection.outlook.com ([40.107.6.76]:16519
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725823AbgF0VTX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 27 Jun 2020 17:19:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Iq84bjkfcwAiB1fOWOYaMpUjhhT1wRxaRclAT/X0S9WaVNJ9QJsZCfqZ9xL/9eam7Q7r9ANOK1YhiBHWONudGQU/wZFytSfac5utMcrar+NaFBDvZGYESCMDuC5VV4OxryFtChW86tl611G/6bcFm78wA4kgsUsVz9fBZSeqWyXpnxwQgAU2eD/RCrLo5u79uAGfP3C2CTf1QjrZMPkqtc7IigEAUxTinhzqMG2M1oKP8W/Iv8xtHl1Shi3hEwtOLTnLp/Kj/BDd9hW+eK4CwlxDVFqkukNCsN5u59+TjHdDoR/7WDZ+EQZBlQApG4oT7EW00/seXCNa1VXFF/DrnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yyuXvneBGq6Ns7v3rRuvPjOtsIMicDUWDRRfWGDIBfI=;
 b=oWvoveKDNqWj152w4pPPygHLY+ZTZ3yl6AaVvZuBr59la1APFouUn95X+tNRomzM/nbgN5cmbzlm7R9RBY1NL1zGZOo+mILgYzi8L0HTdGvyyJja7zewLmuW/YWetvtIPPxIO+VsnVbDv0lH6Vn06XZ3sggNFAMRA0YQd0mpfLnIQvx+UmOt+qWJrvmjE9BXhs1clobzn860Zz+DWaFW63n/3nblvuZSjM9eIuLioBLNhNH/gGKVg/56f9+dV0HLPX7hO4WOakhf81rc2jTU+nid2y9G2aQko8a9soe11xnSUJslsfhpskgSfD9i1oj+ylY8VKPQzWIMqb40r/wQJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yyuXvneBGq6Ns7v3rRuvPjOtsIMicDUWDRRfWGDIBfI=;
 b=agwUeSV6bXkQB/vBf4NBWugSDxgOwiYpenlShGbrkibUfeipsFlh7sWDSRyD+Aht3xp/oMxPPRUqmXhz32o/xA6/OTBF8WuYwzwDrrCEe8zlQ4dLWpapUIVIPtQSldNI7pfu0O9qeglhpw1+R6fMQ2E9/IjnTdiTtAYYFkFdVNw=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5134.eurprd05.prod.outlook.com (2603:10a6:803:ad::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21; Sat, 27 Jun
 2020 21:19:04 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3131.026; Sat, 27 Jun 2020
 21:19:04 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 13/15] net/mlx5e: Increase Async ICO SQ size
Date:   Sat, 27 Jun 2020 14:17:25 -0700
Message-Id: <20200627211727.259569-14-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200627211727.259569-1-saeedm@mellanox.com>
References: <20200627211727.259569-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0017.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::27) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR03CA0017.namprd03.prod.outlook.com (2603:10b6:a03:1e0::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21 via Frontend Transport; Sat, 27 Jun 2020 21:19:02 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: cc973770-3ee1-4ab4-27a0-08d81adfb84c
X-MS-TrafficTypeDiagnostic: VI1PR05MB5134:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB51344AF31CCAC51150071E7CBE900@VI1PR05MB5134.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-Forefront-PRVS: 0447DB1C71
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I9Y8WEc3sk0hjFh6yDM9+Hv3xr+leXVJNfWutENHfhf3b2jSRV54oeziybR01MtplIIVxXoK5zymkEoo5Y7w9T4LFL0af7jbZIwIisRB9RFdDhpyWF8AOibABKlK6dkzjma9Bk+TCNyU5eF9strvCJkPd9DQay7PB++qdPqjCSUM/h/ncQMYcnLnGc3MXrpu0l3TQegbGYMAevLSwUn5vznNcrnc4kKVwiuDX3EmzPux2n+Mpn+UaKUGwLarAPiqh/OtpQDmr/V6dC5EWW56wqTZ+kw6NUzj7L/kpYjlboyWmFKqct33Z5cQQV96wo1n7/ShJ/idZA8XDSjuZ2jgRhkQjxNzZmM5DepVVzwi6uOThyfgMO9jH6jvfvpAnwr2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(376002)(136003)(39850400004)(346002)(396003)(66476007)(107886003)(54906003)(478600001)(4326008)(316002)(6512007)(16526019)(6506007)(2616005)(1076003)(6486002)(956004)(6666004)(66556008)(8936002)(52116002)(86362001)(36756003)(5660300002)(66946007)(26005)(8676002)(83380400001)(2906002)(186003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 8QEffPWrybGDrBlirVYhKURlqDxdjQqB+TlFA8ouy7u158NCCEuRLcghTo2CmiFVvdABAnRrXY9Jy1992pgUVdOHFRrjedMogv0N3b0jiftSmr941fxbPDmrvUPgHbKci7iJjlPQEIsehmvK8klb4QL7dArI+EJ9bSwssnrCU7bUoJH61eTq4feWEZY8ujpVJ0Rsnaqsbprr0WloYK7Wlhf/1axEFsX3SfP0Q7ZB8/j06Sm3COBMVYsvEOjXYwLJajXrZeBvu9jaPgmKMHnfDjlKy8HrGhinDOaOPglDJfFLOQcy1EE2NK5xBQYdaBpuiaDds9gRx+R8k1SzNcDNx/1WfvluukOAHkTJ5onJlBloPRC69vmJk4Cr9A6sD/lHRcN7kr/LOm2GDK6YLP0FKpFoUQyD05p47mAWnqrPxFiat4Rs5ZYe/fQbnsoF20Fx5beoA+ZSYmeAdhrRRMbJW0eEK0Jl6NWTgiFPMKUYaFA=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc973770-3ee1-4ab4-27a0-08d81adfb84c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2020 21:19:04.7091
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L5geChi7d9W3Jk2ub99nCFsnNdQ+iNFQjQaJT53jACg/JBXfgRbfwCs8BTPOSqeDzmIXGcGspNj8ImWGC+UZvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5134
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

Resync communication with HW for kTLS RX is done via the
async ICOSQs.
kTLS RX resync requests might come in bursts. To improve the
success chances for such bursts, use a larger ICOSQ.

Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 0f1578a5e538..3e6fcd545d2c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2306,6 +2306,14 @@ static u8 mlx5e_build_icosq_log_wq_sz(struct mlx5e_params *params,
 	}
 }
 
+static u8 mlx5e_build_async_icosq_log_wq_sz(struct net_device *netdev)
+{
+	if (netdev->hw_features & NETIF_F_HW_TLS_RX)
+		return MLX5E_PARAMS_DEFAULT_LOG_SQ_SIZE;
+
+	return MLX5E_PARAMS_MINIMUM_LOG_SQ_SIZE;
+}
+
 static void mlx5e_build_channel_param(struct mlx5e_priv *priv,
 				      struct mlx5e_params *params,
 				      struct mlx5e_channel_param *cparam)
@@ -2315,7 +2323,7 @@ static void mlx5e_build_channel_param(struct mlx5e_priv *priv,
 	mlx5e_build_rq_param(priv, params, NULL, &cparam->rq);
 
 	icosq_log_wq_sz = mlx5e_build_icosq_log_wq_sz(params, &cparam->rq);
-	async_icosq_log_wq_sz = MLX5E_PARAMS_MINIMUM_LOG_SQ_SIZE;
+	async_icosq_log_wq_sz = mlx5e_build_async_icosq_log_wq_sz(priv->netdev);
 
 	mlx5e_build_sq_param(priv, params, &cparam->txq_sq);
 	mlx5e_build_xdpsq_param(priv, params, &cparam->xdp_sq);
-- 
2.26.2

