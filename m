Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B182F5197CA
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 09:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345208AbiEDHHQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 03:07:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345183AbiEDHG5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 03:06:57 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2042.outbound.protection.outlook.com [40.107.244.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E68F922B20
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 00:03:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VyhnkC/2pRUugbDTB9c153E2ylVtCT04TaWf/7DOBSOFuO9oB4Yum6NaEm3PMxjKbhBjAfIwDKqsLfPIEWvKY7RhK2aamKdkPaEcw6YkM6zXq9HqdPRCb1sjeGb+EJ9UY5TiydOTzD17DXxZpc4JiorbcU2F997yRa7BYychrBPp5HKpHOaQvb+sVPrWKlbmsDYkXoDh06L87H8RjWsQLZgGCxELd+9V4p9mehhm/5w+fx8m1vuJspS+3f822wqR6n5oC01CT161ixC62BOdd1LF32ZyIKxtzi/xYj1xUBEOs6NcKhdc/xAs4j+qcpGf6sMgWgVJCTvhfRjv/7J+8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H66rO30gHF6Ht5tZSw4rBrhrFKhxeOMF1vY3F0NR4dw=;
 b=E0loFi+YaknOY48rJHP/EKVnUT+e5XVFVeRV8+6zPheQqKhl8Cjt4d8bhuAd+lRh0aBmhjI/ZlmUjuJWKVAixc32eQS+cpApNwFlEtqo/y4lAz7c1A6+9bOwOJVyIJ7Y29Xxtc/m+iwOhd7SD0aQ2Oy2LX165+3IdX2Gk+yXVvs4cr10kD7IyaQP5KA0xeM5w4GSls4qJIxpw1B0yA2mFNgNuuU4TZNWpNxqjx4n/otqNoJur4XxeK2+hV5UrwoCrJ8vFNgPZI8/NzlkeTARipQa3tcS/tnqyy1otzRO/3X1HwdCeJmgJK/2CC1jEcEiqxWvwkr1fUtREhloLS+pdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H66rO30gHF6Ht5tZSw4rBrhrFKhxeOMF1vY3F0NR4dw=;
 b=EChZ8ddekvKhRfhwz4jval2kjwNTDMYFQ6XbiZKFgU4R9dBOphXQV5PwhMU0J6Bw0I+D+RqYHLSWvA2ICYiKDcuiJoxUPdVOirv1woadJNuzERHApE+VQ+o8YrrFwfUdxTNaSUpPcDAUoKYW/K1t7oey5U/iU0ibltcFOcoK5VoezY3JW2u3lWXKZ6Pa5O2SrcagGacUcO8bz9vdLbJYteJ7yWHBghEfc46yYKk6snDVszLeuKtD88moj5P3vjmr7l4yDP8mFbwzv8MfoAvOiSQVCOTgChYFRFvsqfXSE215yCEr6+8jiwoMOsdEJtocoUQmNGVTgXr8I3okGc8nwA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by PH7PR12MB6586.namprd12.prod.outlook.com (2603:10b6:510:212::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.28; Wed, 4 May
 2022 07:03:18 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca%4]) with mapi id 15.20.5206.025; Wed, 4 May 2022
 07:03:18 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Vlad Buslov <vladbu@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 06/15] net/mlx5e: Lag, Fix fib_info pointer assignment
Date:   Wed,  4 May 2022 00:02:47 -0700
Message-Id: <20220504070256.694458-7-saeedm@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220504070256.694458-1-saeedm@nvidia.com>
References: <20220504070256.694458-1-saeedm@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0008.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::13) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3a148146-5f0f-4264-2a45-08da2d9c2b1c
X-MS-TrafficTypeDiagnostic: PH7PR12MB6586:EE_
X-Microsoft-Antispam-PRVS: <PH7PR12MB65864334918D3B7BE1DDF1A2B3C39@PH7PR12MB6586.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y9u6PKUaNR5pBuRILOnjVcdVbx+WF5Lrvo4mNLsqNVXXU0Pu21alDFODyhdDVoor5I8k0jJsV7wZFMk1pqI9dwDk6P89pxO1FW/GLM1ErzQFdlUYzexKLurJOVw2rTw8KzQfoaujoEWdwt7Jbl0sTHTD3nkpJQGkgyExzpOOqixPm5v+b5t33YCm14i4IKWqPSokF/gAROwIGkb9NC0TSxN4/eNGje+zuE+GA81x+DcEAE0/QwdtfmGqwatTDpCyB0SxHSSTUWJ70kCfKWs7NUPOqE6sgUdVqj+8wxg+sp+0fnn9B4RTzOXksXLBwC9QpcKK9NhGwrYQhIPhf9PdvyLNU2JWoGKbAp3dILKGNyA+oevlOrPrIcNq56ClR8Cej2V3HdIZNDBbvgwGUhesKWPEort1gGGUhTIyvVgOib8Kkio+9GilBpfauwEH3rJ96TyMwA+f2a8mKjqiJV+2su1tmuGPF6WA1ZkK7v6Mz8Du1lrPaLfMZYhiB20uwwunhkKC1k0C3aU9RNz/YdqCAr9NDcgdnfdaQok4msOWOnd+Jx/p3nErTUysi1cfxn5b3HtzJ9UEhCCHZdO039AxLun2WzqIkqNW+f+xCIzi5HrTINtb9TKUDd3twduPwjrUYGW3kMYahN5jq9zHf9BwkQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(86362001)(83380400001)(36756003)(1076003)(107886003)(186003)(66556008)(66946007)(4326008)(66476007)(8676002)(2616005)(2906002)(8936002)(6512007)(6486002)(38100700002)(5660300002)(110136005)(54906003)(6506007)(508600001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rOVOOgUJZ7rlWMlg0MTMqIEEAgy9gmipqpIRarpnGQA1zSsZi//Vwrii/BQ2?=
 =?us-ascii?Q?Xx8yZKiwZu5t1JmcvxsWlSXkGuKEX9OKctpOFsrZv3/t1xhs2H16VZ9tNTuJ?=
 =?us-ascii?Q?NJwh7Ow5NGV6YhG600dMOZz/BPOZiWU0eEWe4EYs8C7Mzoj1m96to3bmaOJ/?=
 =?us-ascii?Q?YanqiXOmXPNTBGYFgq6Zk9SJ/UcOtv+/gTkZZU7y0WLEffsmo4mF3NTLg9F5?=
 =?us-ascii?Q?8diQFQKMmtSRJi7IeXvI4LVi12HxfG/YgvfA3BFFq17rIcvYu47zpKdA4TIP?=
 =?us-ascii?Q?BvRYVXJ7YU1XxPJ4gu3rwp5Tt7Q/CRTnJBfAUARbhIwKKjJNCV7DCaiWCdVB?=
 =?us-ascii?Q?aeXGVEzFIlGMwtAwzzMrGx21Gn2FG3rguGMmyMvFVE1Qxa1VgCTJZa+nI4gz?=
 =?us-ascii?Q?n1gM8Cp/m4t7t/9e0nZRvuDYjq+OZJPRsP+VYIl0hX4TEPdQPPtJq3yirAEG?=
 =?us-ascii?Q?7cNSmEpZ020Gb5csW+N5sZub4CyjHy9usv7VwmFHKS64mOh5GVyv3UZjxABi?=
 =?us-ascii?Q?nblLKX2+iVCtARmG1R0W3Yot3OqFAUby268SO+4mpH/C7y1Mwl4jSWe+otqp?=
 =?us-ascii?Q?M1KzfiKOhFQlY/XmYbgDNVsmAYser9jm6Sd/9hVX7AlIZGwBAGybtrccSJBT?=
 =?us-ascii?Q?YD8MWsvIj9Ar1EasZ95Js9WliQqge0l2N4vIswL7p4beVKegirYMKYwEYUHV?=
 =?us-ascii?Q?CiMqCW8IQEgVp+Rh7emq/kQcLDJg6hXjCthw/zUFcY4NphxDx/fuUYJHrROE?=
 =?us-ascii?Q?Ar0tP/vZATs3oyalTVHE59hrNXxF44SugXMrC9QhsMhhut1PZa+a80P4HQ4x?=
 =?us-ascii?Q?hSoqdH3PykAsQ0DVrTWVQvYjDlZxcCApZ+UiMoraFIOnp+Sh2cwZ/N/zUg2h?=
 =?us-ascii?Q?eo/9RdHaMXkSQE5XrC20JkLXnyaH83S0OODEH+W98adtLQ4paQEzUQaE61Ke?=
 =?us-ascii?Q?1rhsjOAmSoaSC/KC1p3WcoAYzhgIO9P4muVUHvi92I2mw1XgYQ2tqWRivtr4?=
 =?us-ascii?Q?8QXWOE2wo7m/sACOPYe8IDKKBzxjrZ6vnZ44tulU5a36UsZ+d72RxYFWVx1T?=
 =?us-ascii?Q?d/S/49YX9gt7cpBSTo7eIAxC2PPl0QYpy4NettGmnSn+V/cuIUczqUi25Onr?=
 =?us-ascii?Q?A5nr9xFU+QNJ6lIRmigF/cow41/tNM6gUb5gnPtP1wTVDapTfjzGg8Z1mPWr?=
 =?us-ascii?Q?YuuUjn26zt8Jtc6ZJcMYa4sI9xJeS0pTLfrNQR2V36mC4F6YjqOHSNp9vnd8?=
 =?us-ascii?Q?9l5U+txDXRoXh/QntTuunk9GTvVVODaDzTmNinRsL3H3Dqc4kD9Z6ECdySoN?=
 =?us-ascii?Q?aPP3O+50DskzTFU1fRSKDVFKWDX8ue2PX7I/sYBHwnw1oDtW+GxtBC2JWWM1?=
 =?us-ascii?Q?fVJLh3O5MWQAe4qGwh/wpo90GKnJMOEP9CK9mx/zCDc4MpQ6DR3PRAMBXxT7?=
 =?us-ascii?Q?Ht0F4ty1PxGCrd91bXkaHyPxCwWCjoOWrBexRho0hNIJMwyIjEcpqe2lp6Ic?=
 =?us-ascii?Q?9attKToai67JlJ7jfOt1MI/M7x/+YRTdpg/hi436H0iTYz72ogixEN1OSJsf?=
 =?us-ascii?Q?J84s7VzjY32U9JaHyVxTq133cPRrE2ALzBci6N/42VjtNk0BuluB/4gDfhu8?=
 =?us-ascii?Q?aovah/O2L/YA3xxXRKSwW1y8QMoGdzVsoJgKjrKHsM27RUn0ZXhsLKh1oilc?=
 =?us-ascii?Q?mpgz5COlIBbEGeZvEiZ4Bupw5zTlxXvP/RUooWz3DWLwabBeAoGKgcMuhY+i?=
 =?us-ascii?Q?PtR2mmqi9Lc7d1HZC1XL+tB+TZRmgR/FxNclYCqSdF1GkidEsOZp?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a148146-5f0f-4264-2a45-08da2d9c2b1c
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 07:03:18.8698
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OS8hTurk4na2qbRLxTFBOKHwn3t1t4UNWTKTpw+G0A3SkuAvSRUKzq7HhnM3AIZOaBUnnNYSFSFwQdanH2J9zw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6586
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

Referenced change incorrectly sets single path fib_info even when LAG is
not active. Fix it by moving call to mlx5_lag_fib_set() into conditional
that verifies LAG state.

Fixes: ad11c4f1d8fd ("net/mlx5e: Lag, Only handle events from highest priority multipath entry")
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c
index bc77aba97ac1..9a5884e8a8bf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c
@@ -149,9 +149,9 @@ static void mlx5_lag_fib_route_event(struct mlx5_lag *ldev,
 
 			i++;
 			mlx5_lag_set_port_affinity(ldev, i);
+			mlx5_lag_fib_set(mp, fi);
 		}
 
-		mlx5_lag_fib_set(mp, fi);
 		return;
 	}
 
-- 
2.35.1

