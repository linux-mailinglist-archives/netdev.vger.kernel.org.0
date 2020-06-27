Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 074A720C44A
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 23:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbgF0VT1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 17:19:27 -0400
Received: from mail-eopbgr60076.outbound.protection.outlook.com ([40.107.6.76]:16519
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725916AbgF0VTZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 27 Jun 2020 17:19:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NnmrPjpDTqoinlvxg3R08AD07A5SjCKtspRSHqO2kOs7XV/AneamU21+CDnWoivFaUjEhoVyluctGU7o5KBXX6OcNAPa6c5BEykLqAgMs+eAn0aCeypYsvS6xE2Ehl9rvBQUHcAFopEUKw/VQSMvYZr0JdiPsZOUwYgWKSFldLALUopeCxQCOmiKmuRdfsHKq73gW5ARzMZsnEYlcgl40J8DuRJg3ohbjWAEPUfpaNjSBzBeb+7+EyUAgImiU+IRAdovd1HX2vwLBVBxeITI3ZdjaznHV+VW420YBSPEcW90shDessxvuqM4MbjDf89P5cBikvIlRDYQuaRQtClciA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1a/XFyBQAr3TMsCWz8Tj1c1Idf6XczLoALHKqjP3/hw=;
 b=Dd0vK6zexxW7mHXdNL3P8r/3LFiNWrYxypPedfX+8uX7yhfGxw4XcH9cu4sR31woiMowX8VlCfVxeB/7gT3NTSi1Izt/ZGy5b76wIRnFwcDX5yGHaB0nXCfgHvM+hQJWXMgSRz+GUmebRSOleSmV3KNoQKrCdVo7m3FWA3/ZQgU4TCQEzc/jpQlFQEJ8KtSd9yHc9lsnLmDcz+VKNhBj0Zs5RHxMVh2S3aUw16ggeMb86SHDsfskOfFBMqmZX+IkiV0yB4gHu29RIBm4PK+b7aii+dIRPpfbRp2ZU0s2osc/49D1inDg2Ij9rXGDCjWhk9E1rgEcgb0R8aPTz6q7Xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1a/XFyBQAr3TMsCWz8Tj1c1Idf6XczLoALHKqjP3/hw=;
 b=O0ucJmAjIbGOskJw4a6A0aE8GkjV2yoE+Jv+txhNpeh5AwbE9H8ObnCX7snWU8+kwocqyOO0rVZYRg/gkNzNChrZ5s9kdnZ9PlB74FqsBGzAVnmi15S9w1q9WN4lboZc5NLF9gXL4TQda+KkTv7JD/rCF48T+at9NLdGRmNdv5E=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5134.eurprd05.prod.outlook.com (2603:10a6:803:ad::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21; Sat, 27 Jun
 2020 21:19:07 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3131.026; Sat, 27 Jun 2020
 21:19:07 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 14/15] net/mlx5e: kTLS, Cleanup redundant capability check
Date:   Sat, 27 Jun 2020 14:17:26 -0700
Message-Id: <20200627211727.259569-15-saeedm@mellanox.com>
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
Received: from smtp.office365.com (73.15.39.150) by BY5PR03CA0017.namprd03.prod.outlook.com (2603:10b6:a03:1e0::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21 via Frontend Transport; Sat, 27 Jun 2020 21:19:05 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a9fa8915-c7b9-4dcb-81c8-08d81adfb9a4
X-MS-TrafficTypeDiagnostic: VI1PR05MB5134:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB51340A3212B55C133EFFFB9DBE900@VI1PR05MB5134.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-Forefront-PRVS: 0447DB1C71
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D600Q6yecX2o0IX+msruLRyViFLOrmyJ5AyIFHtCr4omdxtaQHRdTjoO1RdCfsnsw6HeyToNRPGDPQT1rlP6nI8IIMJfBWy/wLl8xHjOPPlqkgmMhtulye6UP14KqAnMP4xO0kiFVMCVLS0OBj12K6oDtZ5ytrZO3ihk0NnOs3dRrrd2AhvdEb6eL1kWyCF1bD4RM9G+PWY8I38urcwRpH4jGAGRhO+k53BoKHj9emqaaRjjcjaZadPSwjA/9G19BtIXdskV7CO6FE+HmqWc6zKmxJVgXapgPR5utaW28v/VvS4D/emhqpjHARoaXH5CuyjAMtVqe7ZoMt2Ex9GXIYGPGt53T/uEystCcWLePl31T5Civ+MBuGeZPqFI0gIk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(376002)(136003)(39850400004)(346002)(396003)(66476007)(107886003)(54906003)(478600001)(4326008)(316002)(6512007)(16526019)(6506007)(2616005)(1076003)(6486002)(956004)(6666004)(66556008)(8936002)(52116002)(86362001)(36756003)(5660300002)(66946007)(26005)(8676002)(83380400001)(2906002)(186003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: wvVt8xlr8tWOfq4XzHrIWFqPKV5qgO5MQoA7qFKtItYECqd+9oprQlO+Q2s3G9jHVWhKCT0BGI7bwqyw1B9l2uwVHMxKjKwGoD9yvzeSeCw34pEs6qaYcqq/LW7Rzkkd+MoctPeAI16Pe3wte6QiiDBJf/xWeOJtWIus4ZN/BLjQRGh0PQPtQExwoxCmV7V3tr2qkP+0vNf/K55mFqDqdOwSwX3RmWOKKr1OZcXqVimrwB8YRgUlg50K5GPYJtvikYEenb5KHm6Xg+GG/0t8ZPMSS09g9ykMCJhIm9qbJkHiMlYlHSVbUBgInmttgTaWJpc5tef/GAvTb+UisxKuMulcys/0e8JwqycmOvd5yziwq5rKeGg+v3H2RhxtM/8unFn/slrKMVsXntp9TrPVqepdmx5NDts8OJwotQq++/g9UoeSocRl5f3g+yR10EBdGbUyuyvW+0mh2Xwy2LBJvqRXsD+wmInt02wFIvOhG7s=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9fa8915-c7b9-4dcb-81c8-08d81adfb9a4
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2020 21:19:07.1178
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bmpO/1hO/1Os8spLGAY4ljRp3MtkAm26a218H3LNgfe0k29uIBIEhGS9muMZKTBRzsvZOuJDwXCVkH30k6Q/SQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5134
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

All callers of mlx5e_ktls_build_netdev() check capability
before the call.
Remove the repeated check in the function.

Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
index deec17af5a69..1b392696280d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
@@ -58,9 +58,6 @@ void mlx5e_ktls_build_netdev(struct mlx5e_priv *priv)
 	struct net_device *netdev = priv->netdev;
 	struct mlx5_core_dev *mdev = priv->mdev;
 
-	if (!mlx5_accel_is_ktls_device(mdev))
-		return;
-
 	if (mlx5_accel_is_ktls_tx(mdev)) {
 		netdev->hw_features |= NETIF_F_HW_TLS_TX;
 		netdev->features    |= NETIF_F_HW_TLS_TX;
-- 
2.26.2

