Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20F135197D2
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 09:04:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345219AbiEDHHc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 03:07:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345231AbiEDHHO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 03:07:14 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2053.outbound.protection.outlook.com [40.107.96.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BD6C23141
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 00:03:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bic5wTDFfGLOAY88ts45OGEEggdPgZILq1E9CnhpKLJFawrw8RGcXnNvoceEiC1qbbQIywTRUjWeFfk7XDb52KpdEdHo69pkkGZMrPtvtD2k1noDsIwS+sHSoAeulvPZ//Y3RpJbJ3n41dLtiherbMcCKbr5Tbae1Vk19jP/FwWoKSXi+WdLMXwJv++tghavKJoji/QLYSnzVUpu5A1y5/Qy19o/bE/sBeD3lRFNarJQEYO8R7KKz0YyAiPDxY7PndTQ6dRsdGChDMxkjHnkfNpLArndIuoMBGlqLqq7EflQOIGdbmXOR1P6yAC3pxdpY8vygMMGyC/PLq6135ikUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=awxK20xa8Fz3hM/bEQv9MKTkWZgH9RWGjMFERIygmrM=;
 b=SuotFO6gUlwGMapsxoQ7XivPcBkeD7MEyGOZYxjHrAlwrt2SKHVdTKXNjgxriJCxbp2JNnkWQSeS/tMgiG1uUZwqxpcWREoOscDYBUc3qDOGriFI9GFzno2wUi29rsF47wkmNn9pT08/okpt2hW5sS7WzWRyKiXHEKlMOTT4TJv1z2dFS6e1nEnKjheyETdnELpwZDB7LvpXMmxkF6sImsi1me9susXYpez1lpio5KLyJPDqKR6TQ9kMD3iNCekoPNz2zYC/2m7sufoQ2QniV7r499xZGlv5QkGVfLHLeqe+XVBXqiCJJOCTjYYPxk2RG5GLTN8/WG3llGDGa2EN8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=awxK20xa8Fz3hM/bEQv9MKTkWZgH9RWGjMFERIygmrM=;
 b=TWjqjLX3pi04ofyXizi9Cyh9NUdMr515/F5Q16dn4DYlhsnVMPZtUcmgeilJ3oscvr9wzcdxKztwJAYuT64zU7WzcStgyXRJiFEKMF2KgAPnMvYb/8ubaMxE5Jx5+sVg3CO4zW1jjtAvDLlfncWrcJYrF2hAtQd1CEJvbMGvjo5a6gZuRag8QlVusiG6c7GclOOjnyoc3+h+G0s1+Z+j/pHeUqgzR9YSGweIy+k2Iw0yBliJcAJwXC9hXwfuZKKvYYoIcsLm4A45xfzhiFkOJWFH9fo0o7sodZRoN9DsQGHd8uyAkDmKHojHObLyjVy2z+ZwsTi/8kYdTm2gy0v7ug==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by MN2PR12MB4503.namprd12.prod.outlook.com (2603:10b6:208:264::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Wed, 4 May
 2022 07:03:30 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca%4]) with mapi id 15.20.5206.025; Wed, 4 May 2022
 07:03:30 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 15/15] net/mlx5: Fix matching on inner TTC
Date:   Wed,  4 May 2022 00:02:56 -0700
Message-Id: <20220504070256.694458-16-saeedm@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220504070256.694458-1-saeedm@nvidia.com>
References: <20220504070256.694458-1-saeedm@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0010.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::20) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9aaa49b6-8ada-4ae3-422e-08da2d9c31b5
X-MS-TrafficTypeDiagnostic: MN2PR12MB4503:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB450333F31B9D73F575873EADB3C39@MN2PR12MB4503.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wc6NdLL01FgPBC+x5KdbLrhb0DQh1JTLLF0FpzHpT5wN7Yz+aIndGUFLo/Kznz75f0h87gAovQChil4GNVQvPlhuxwIj/jbIUOlSacBeGvuan/f+MfUge7Xe1NFS3G5ikurCikST4dgAXN8cm5scFj9Bmvgp+ZyrEmtvai/m9Rl9yYbe+ubyKin6+YXGSuD2NlLb80Xu416uRwaln26/eXEwPPA9Q2J5KC3teBNRbwJWR3Q609O1IyvRYEXUXMoEBUXKreTvOx5JMlup8bHK1lF9aGLJOiyyvLnNJen6/sQ74LbkBsenF9MdBEyCw08tYLEIvieAqxBfKARavUvtrqGIE675olC4GO3X4jjBokYJ9RFA3kiNd54bExVRL2kE30IRaO8IF2Kscsd0pxpYZjsS5uT6JvDhJb8Y08GYH5iyJGr8Mdx5PLuIpj+z0npNBAj5ZdeRWnryiDQoUGIax0dogD75pMsb62pZuaKS1DpFf9lCTQdFM9Sl8KU7K2SMFAwZ/ByPYyMAjrm9fbnlN7PCi1uGpII37hzHptpCKAV2q9nT4QILp9qCM/bMNlzdicxfw/InD7a2buMWAT2To/npL84+S8Zne10P0Q+69eTWoqLczFX1+LNLur4FPyVtax3223T+iBn7VtjsdEYmmA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6666004)(107886003)(6506007)(2906002)(36756003)(8676002)(508600001)(6486002)(38100700002)(66946007)(4326008)(6512007)(66556008)(66476007)(86362001)(8936002)(316002)(5660300002)(186003)(54906003)(1076003)(110136005)(83380400001)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?N32UYqtqKFUtqhKXCrmmEeRsPc3EYuq7cXDzEbaOocVcbDfp0rjs5gzet+WS?=
 =?us-ascii?Q?aUudp1+JTsi73ttX2d3Yo/0rP47YJapOLdAVpDnD0WdHeDuBaeAwBqu1NcXX?=
 =?us-ascii?Q?H8gn/a/Q7vknf+wiIyBVmdUqnxZxtfVrxib5HmQo97hfJNA1sjE34EW97BpM?=
 =?us-ascii?Q?PGBnySKqKkvATcno364xInOv87WwyZxGOxHRHGvZfFlc79op4VnqiCXUMGzy?=
 =?us-ascii?Q?Bj2cSHunVqsYFhc4hd6zLYH7+Ok1aEjrkzHvB25e7irKApaU+8VEFn378NUF?=
 =?us-ascii?Q?JmiOBvsVadROvpqWWRQvd2cli38EdltkHoF53YZD1jiAy+L21N824bLqdkB/?=
 =?us-ascii?Q?ikVcrX7pKdYlorO/IWt618ZJ9VFZo5LX0CCeWDIQBd0n4VD/pcJpX0Ag7+gD?=
 =?us-ascii?Q?vxw+5TE6byokdrbZ5u0s7PJWKk9QL687V2KA8H9E7IRg4VBsVp+KhMU5gN1Z?=
 =?us-ascii?Q?y/aZR2pTwQkQ9ReByoDn0sJjLCV1WXYYXTuJqJrH9Ne0M/W2cVu/LSFrLj7/?=
 =?us-ascii?Q?KAFl8PP+kKXZJQfZg1mQXTu6K/r3YPIJZ4KTxxGyqVo1P9Gm81P3+Mz/RhFf?=
 =?us-ascii?Q?JFun+qQazBLd2KwAnqIsWANFgBtjyT1+rPXCM1K/8kIT7N2KaXlMyMQbiEm1?=
 =?us-ascii?Q?40dUsF5zr2Uc3WNrEV4LCj2hMIslksWJH/CIKmYyYavJUrWsojp6YQPolv47?=
 =?us-ascii?Q?yGoHyK2BKQh1tdeGsyZ6HfX1pJisTcoZGA/PKSNpFMx2hxYcwTfE7jKwhn+r?=
 =?us-ascii?Q?E7+pf2Wo6QJhhSJuStQftB2HN908eev/BJ6Rg0qJLWg4xCE/phtEnMeUjW7p?=
 =?us-ascii?Q?oTepvzdQ44WQbJxjq/VQrrjcd7HiuBbuuZuxHe7RNtx7IuwySKqihKyAGmYw?=
 =?us-ascii?Q?waK5bvjcPqVXgoW4hAfvFL7IsTgJtb7PY4Aw/iWEfn6hmzJW35/VVNEMAhBE?=
 =?us-ascii?Q?UJyNw7hNC1zlKsfDnXJVkOLmIrCCgIl9Susy5w3hO7tMnsyTdKMnADIYnt1S?=
 =?us-ascii?Q?3CMoNMAghMYQcD4wl5GYTwVkOiZp8fCPZfutFYqaNb7t+sGPNiXV9x/XzoxC?=
 =?us-ascii?Q?C65phagNkAgRmK/AtjZ22fP+tevy1kTqTIPboFqClim/G3NKZON5wVma18KG?=
 =?us-ascii?Q?ubKfp7s//rUvgecDBIHz7WbfmE+JP9XHVxQlfmxt+NlmFmCM21et74Q9dXZo?=
 =?us-ascii?Q?rYvYXk9c8qcrE9xauk2OwHuf6e1XGn1i6DMNMkNi6nI+soKiHjbPj5v7xxqs?=
 =?us-ascii?Q?BtJe268EoO2Lw0F4iNrx6lYc7zJuzFbtRDHMReVgw9XXxP2krM257QqDvsKN?=
 =?us-ascii?Q?7UH8fqz/twSvblE3zpv94JJCwI+Sg8O2+VNKBrQ0DXiMlTPnvyoKRlgFzBCL?=
 =?us-ascii?Q?IvczVTQ/qtQfYvL4QjYCuiatHWjvFfQmmQ4rH6lWPtzgFiTy0G7nPfKXzXiS?=
 =?us-ascii?Q?wyPurnyTD6YiS8UsEnd6kyl+0aqC3dZ9PaF2sJ0MHt65RJn/RoQmCE1JDqCk?=
 =?us-ascii?Q?RkrD4qGOiYJddH8W1hMV2KMcG/Tx5NgRAg7PlsVRSBMEZ/4MaI/qgEE5fT8L?=
 =?us-ascii?Q?V2NPiYAzzTFi9Ixpo4rdYHpKZN3Vj+4elE+H9xvD1Ol1V9PRjWxm+J3uhs7E?=
 =?us-ascii?Q?pvtAAyL90587F1UbHRrc9VwBgyS0aybPoVABqruemsu9aLlFY1EXVlNU708Q?=
 =?us-ascii?Q?lQ7fjPRwxBXqKte/w42wOcxaVQSbPHHm8OtAKWnvxsLEBeFx9E7rCLybj91c?=
 =?us-ascii?Q?JMGIktphHg62U3Vdi4vOKQN05+T1XRtBMf0wg4LKkckr0fT13C24?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9aaa49b6-8ada-4ae3-422e-08da2d9c31b5
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 07:03:29.9660
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S9HIkySXXpj0FTH0xqPhv9nnQPotBV+T9J3eGzYCpBLDFRDXumhuSXG6edwPdJMLgOGKhJbI/1YoeSxXTNRlFA==
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

From: Mark Bloch <mbloch@nvidia.com>

The cited commits didn't use proper matching on inner TTC
as a result distribution of encapsulated packets wasn't symmetric
between the physical ports.

Fixes: 4c71ce50d2fe ("net/mlx5: Support partial TTC rules")
Fixes: 8e25a2bc6687 ("net/mlx5: Lag, add support to create TTC tables for LAG port selection")
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.c | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/lib/fs_ttc.c   | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.c
index a6592f9c3c05..5be322528279 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.c
@@ -505,7 +505,7 @@ static int mlx5_lag_create_inner_ttc_table(struct mlx5_lag *ldev)
 	struct ttc_params ttc_params = {};
 
 	mlx5_lag_set_inner_ttc_params(ldev, &ttc_params);
-	port_sel->inner.ttc = mlx5_create_ttc_table(dev, &ttc_params);
+	port_sel->inner.ttc = mlx5_create_inner_ttc_table(dev, &ttc_params);
 	if (IS_ERR(port_sel->inner.ttc))
 		return PTR_ERR(port_sel->inner.ttc);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_ttc.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_ttc.c
index b63dec24747a..b78f2ba25c19 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_ttc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_ttc.c
@@ -408,6 +408,8 @@ static int mlx5_generate_inner_ttc_table_rules(struct mlx5_core_dev *dev,
 	for (tt = 0; tt < MLX5_NUM_TT; tt++) {
 		struct mlx5_ttc_rule *rule = &rules[tt];
 
+		if (test_bit(tt, params->ignore_dests))
+			continue;
 		rule->rule = mlx5_generate_inner_ttc_rule(dev, ft,
 							  &params->dests[tt],
 							  ttc_rules[tt].etype,
-- 
2.35.1

