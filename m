Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7AFE5197CE
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 09:04:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345232AbiEDHHi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 03:07:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345211AbiEDHHO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 03:07:14 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2053.outbound.protection.outlook.com [40.107.96.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C436C22BE1
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 00:03:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g8y5OFD49WC0g000fTt7uyfWgigEDO4ifhW21vgcTZYSvFUV3/FxRxtB4LKAeY4hpHaDB8F/Bn1qi0DhoAzbVPSOuzicme/UF+3bXAbtFJ48GXvdSEvmy/nguivsFwH2LDY7hgu9glh4gXsPkYeTnvC3HFIm5tof1fDa/cOgmqVjqyZGn+hzYVup4vl/vEf5nTjjP7go0BIwNLbD6x4tzqY1ZVjfIvib50Au264uFGLzy8s9qVJKnWVNJgoDnOd0xOLhede16jS6HBFFiBjKt3a5Y7aOCKSerc1eBgC+f9Im4GcOAO1ChbmkzKx64oZba3kkRPuo4WIpFvyz1xG97Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X9NygdjstG8adKV6bxvSqAhMLcV0YYhMCuAM7f+b3Zg=;
 b=TaTGGvmFXPw9/dgxv6zx/RNwST1BFYgJQ5v+EJf07TkErojfrki54YRvTz/rCwDMsKHOyUZuBgxyz/AIRzf9NBo9sWB/PB+10bldkQ3LjJWvxJlH0603Ac1irNvg8OXUUfdFugxBBn4WLUszlqhh7y8AFTct0KQrPkn60V49ed8v3hY1ws591tD+y3pZ2+d86tL6ofmZruQTx5rW58li2LABN2myxOLfup3OmZwQi5W6RMlXAV2WcTMtG8YE5KlM6p7bNNuUI3lYbdKZmjHCBYU0fR8Qzzyjq0Qu4oR1yAXtimpGEJzGe1gu4FnldxUaLEB66lnSTqUuliPgfOAP6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X9NygdjstG8adKV6bxvSqAhMLcV0YYhMCuAM7f+b3Zg=;
 b=nzphzBuxMIxY+tK9TI8fMCN+dBcXtX7OAeTm9zG3SHgf56teqSK8nGvvLjwU70dXCvUucCFIgWt1xv4q2/p8joC7l4eeORiCXIqa5BhJXhU9y7lQVL0CX7U5HHdvFhJ6YnTlHd2N3SrMpwpJg5i0bV3M2n0gODo8T5Z9MktU9rrQtmAQM6x7+0oZEulRHpDJeNdXLwUNiCk1sYiunqBED8zPz39XRDZpDFceN8rI6lTrWi40x3plVk4ae2gdUxN7+ZFXt545lwm7PpfiABhgws8ZeQ06sTI5odSJ4Tgk1uE6iasKj0db83RKZzjf5dgyxqdIsIhL9SPwPXFvIiLTSA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by MN2PR12MB4503.namprd12.prod.outlook.com (2603:10b6:208:264::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Wed, 4 May
 2022 07:03:26 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca%4]) with mapi id 15.20.5206.025; Wed, 4 May 2022
 07:03:26 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Moshe Tal <moshet@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 12/15] net/mlx5e: Fix trust state reset in reload
Date:   Wed,  4 May 2022 00:02:53 -0700
Message-Id: <20220504070256.694458-13-saeedm@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220504070256.694458-1-saeedm@nvidia.com>
References: <20220504070256.694458-1-saeedm@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0021.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::31) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9eae4079-b72f-4401-ea06-08da2d9c2f51
X-MS-TrafficTypeDiagnostic: MN2PR12MB4503:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB450324D0DE0330B62915E85CB3C39@MN2PR12MB4503.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IKy/CR/SmxO6R15AdtQjFHJkQUOZZt7G805RDCxgAUAQNOv1+XG7JQAUNw8HzkD/NvPksQkgfkuvR6Vhvah6gotRpSnGGrP3+TyAmTZpXzQpMSDJzYWL26ev2i9hRlcr4l00vLVqSZeJUEt4ArgvQ4jvP/6sXSA+5+nZ8xU50G6nkJboQmtzRthRmaJXwK8xhK+PJPfkkcbAsNG48RGksT2K+CihSQfKdk9mE4kFwNJhaADTwPjptSrs+kKaMPMfCr9XOFBjtJS00b3BQ/Cr15wd+yk0Ie0rW/E7CQ20SFaEyR8ZYi4EGBOSXiybqVmSzbSCLRKsibvs1c3PwkCzPNpdewn+j1/7DmC4UcS7ijTqfyz/rANqY20eEusvwL1iXHvbUWNGbg9bUCdFt8T/rG2zj3KBVrLNe4DvZa1OCBBFzO4X5Z75IuugyFN0lFHBsZA03EQNyi3hvk5Z5pTceUEXsBlMuT27yI3/weRxNFer8zqFGsI/3RSgKrJeZav/TIzlx0KTOWntXFIpaA79Tn/zelcC706Hvi3cvDKpDtjH4EL+Al6HTqd8tzysmVqd4PWEnj/vqRAJuLuXeYkh5w/500H7kfts2ZjAXpklMY7vGaJRQ5ahnqkv0OWp+z+7kBWwgyU/YRtdv22SNPGobw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6666004)(107886003)(6506007)(2906002)(36756003)(8676002)(508600001)(6486002)(38100700002)(66946007)(4326008)(6512007)(66556008)(66476007)(86362001)(8936002)(316002)(5660300002)(186003)(54906003)(1076003)(110136005)(83380400001)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BincrHIuzAVDLd+BBiYmSfcOE+oIf6rcNMnyE2MzotAAXwQ0qoYeA1fwXEGl?=
 =?us-ascii?Q?SA8SOarnYDuRFKNq/kYX9zbc8wHeaFSlNBkdGUMj2xtYykvVWp5LknzoZ+9D?=
 =?us-ascii?Q?2JeF5sh1VaJf+geLNdCpVeo2IdoUFtQCW8IsbWWpW4P6y07p4v3jUnRFJ7Cv?=
 =?us-ascii?Q?QHoE7KiSrWTcDks2BDr23Xz1ud6+kW217cKefsdkENcpInf4IkBypgEvRQPF?=
 =?us-ascii?Q?Afosw38wWo0AKR5L1TR41UHJ+UaufYFdkghD/60FeofymiDkF0eUqIiYlj2a?=
 =?us-ascii?Q?vH5feJqRwtUgovVce1jQQ5i06OTJgQTOpDBgJcObxGCKRpmBtPHXA26S849Y?=
 =?us-ascii?Q?dgJNoWN0XDB0hciyydyvPTZVW0AyKG/AR/U0XOtJqg8fspB8KV+/lVk6iWrQ?=
 =?us-ascii?Q?7ZmH/AMEx2NmxuFvM6oEfCFBzwvs810LUTbRfQaMT9mB4Sy+lEnmpswaBoBc?=
 =?us-ascii?Q?FkZkGoZnXs4PK0EyHQiFfi4OPNS2wjnAjhViIbDpzncpu72JJuzcfnJga4Y+?=
 =?us-ascii?Q?cR78tr217+sc2zTCXcP20UHHbPKWQTgXk0DsLBcUbNK/r2LXlBrg5N6ic7nG?=
 =?us-ascii?Q?/dMyP8p+/kXc8ZWYSutvTJIX4a5giYIWJO/orJyZjuQh7XLXKn2qThmfaHtF?=
 =?us-ascii?Q?BeISUpleY+U9XYPFgRLcaKjQDagoLXmTPOlqFZ2zF5Us5AaVQtZrnFfLvAWH?=
 =?us-ascii?Q?A4TLkVCyElgFE0oZzziMnEMcF02asg26po93vD+da6uRkJR2uI3Ug/xulG6g?=
 =?us-ascii?Q?krqgrFKx1cLfY0VPvRiZYkV+LZ7U41xN8EE+FiSO1DRr62gXy5zJyRwYgtp0?=
 =?us-ascii?Q?Okm2M+vZ+M13dLudaJxg5Z+cu07B657LVjFb8cIb1EfGAL/q+deRmV5ZTCd9?=
 =?us-ascii?Q?ucS+yUd0mFkUR1BC4tkv0I4oN+lnUwqR5Y8czykMaSUSaCjGiVUqum54buPt?=
 =?us-ascii?Q?V6HSgwW0UF2S1kDDKAnpFr6UGvbyxBjBvcAhkI9AVViUC8MlLT0gXnfbF3JQ?=
 =?us-ascii?Q?dqCBfBMLEjP1hxvChYNBY0j+rZgAWRL7/tpopXp616v/k84f46x5RTJdpxSu?=
 =?us-ascii?Q?JoU5hO1EMZ6xtPFuCjxB9ZehydQqJT36aMPZqQNOYp3pD7ikroh7uoQca6+/?=
 =?us-ascii?Q?tsKzQfCLHJgEUGIg4v/HY+ktSWfX+/ElBWe3AvaTa35QPDbHkB2yVRKRsys1?=
 =?us-ascii?Q?+0X/m3r8XaL1N5mYKJ9Rjem8UT52Z9I94cFdMvQNb/vlO/AU8g91JAGkEh3V?=
 =?us-ascii?Q?lSThJM+8YjGLvxRb2CYldiyPW6Pde5pU4N9Y6G0DNTIwEPXmCUMp/5kilMuE?=
 =?us-ascii?Q?Occlg+vZyDOPNoLTslr9E3B4OBzZ2/bDHTvXq9eKKZqmz9br93OMADVz+Abn?=
 =?us-ascii?Q?be/MN5le2O3RgGn9PuMXJb4423iDDdU5ULE8lYbzhqvBXounNUvbJRtW4nVJ?=
 =?us-ascii?Q?+rwRrlbnztRBeT0FP8WIme1uoLlgsETp6E+Lsxsik7JP8c4LTbvJyUpm7RVN?=
 =?us-ascii?Q?JbIbwkjbEl4MEey+6ZFbtI5erUL6VzEPqbcSnOLRjDoEAklQLBDQoM651f92?=
 =?us-ascii?Q?UBNB1RzSg0VcWMARrsbilmWEWdWuWxxQpW1aBWhGRa2Ew4P7PZZwK4AD7IXw?=
 =?us-ascii?Q?ANyDNH3KA7YQ/JQQub/4AQyV8WQU61wa/rO1azokhcKwtRqlCk1ZHRxpdB0X?=
 =?us-ascii?Q?1Wvb3/eQM3WinzA9NecgCMOBtr8wgrYxaZDUXb2/FYJ9FB6Wf1AaRgP+FY9S?=
 =?us-ascii?Q?8WfX+TGI0U+zWKvTBlobT3haFNinKpnHGZEqlVpNrMGTKF3ZdUSJ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9eae4079-b72f-4401-ea06-08da2d9c2f51
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 07:03:25.9329
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QyDqfGcSF7zT0B5kLAuUHAuhHdZvm3fnI0VUdq9W/QAjU2YfeEdYHWwWpkT5JNEnYSz5/p+WVfTMXRFOrAwcAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4503
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Moshe Tal <moshet@nvidia.com>

Setting dscp2prio during the driver reload can cause dcb ieee app list to
be not empty after the reload finish and as a result to a conflict between
the priority trust state reported by the app and the state in the device
register.

Reset the dcb ieee app list on initialization in case this is
conflicting with the register status.

Fixes: 2a5e7a1344f4 ("net/mlx5e: Add dcbnl dscp to priority support")
Signed-off-by: Moshe Tal <moshet@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
index d659fe07d464..8ead2c82a52a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
@@ -1200,6 +1200,16 @@ static int mlx5e_trust_initialize(struct mlx5e_priv *priv)
 		return err;
 	WRITE_ONCE(priv->dcbx_dp.trust_state, trust_state);
 
+	if (priv->dcbx_dp.trust_state == MLX5_QPTS_TRUST_PCP && priv->dcbx.dscp_app_cnt) {
+		/*
+		 * Align the driver state with the register state.
+		 * Temporary state change is required to enable the app list reset.
+		 */
+		priv->dcbx_dp.trust_state = MLX5_QPTS_TRUST_DSCP;
+		mlx5e_dcbnl_delete_app(priv);
+		priv->dcbx_dp.trust_state = MLX5_QPTS_TRUST_PCP;
+	}
+
 	mlx5e_params_calc_trust_tx_min_inline_mode(priv->mdev, &priv->channels.params,
 						   priv->dcbx_dp.trust_state);
 
-- 
2.35.1

