Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30C79517CA0
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 06:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231238AbiECEqR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 00:46:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231217AbiECEqP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 00:46:15 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2057.outbound.protection.outlook.com [40.107.223.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 851B43E0ED
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 21:42:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bbZ5yrBGe07JZjzqN4mgGtCwzsh4oyCqKk+PaGUwqKzIfizkuhPoiRpyy3Un7QxFcB4A769KGVa770+cYMqBXRw2YorbDkm27dWVfzIjUXRwbAE74jEbGuEdAkfwGH80x2iK4/yoUG4TVk5oWJtG2g/I3Ah0yZPHXdnOwVph2UgXxCYbnGZHYPc/b3p8rNgkutDwF4/rpuc6Mu5q56ovHtZITFTTx1cywjcTYA/qseQEUmiNooZPWIXMrL6YJsetVxnibDzdGMgS+FxiUpZKEHx2Kykt5zyqSFxOFDSNzUIWN7cPjxVIc/GjwXCW3b4DReKsgzsufn9n9sBhpUcoQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J/KgREsTduGePnVkHvoaC9YmKlI6E7GawZoCyPykd9I=;
 b=aqbAukflVUsZGepznDIAU+YHznZ1Ly8iCjYFJ4ffXUKWA7rMk6wUYDOdwRJkZpSJqcX4sq3Ixcwk+bEQgByt1mdVzBy6soAo87iYV3ltLbQzWPBhHrqUsGhIxP2hwd137Ho8v9MPpNwr+/UAqp4VbjLIJReWVtKX/gW898G3SG3l5lWW+T5jKQ84OHmBkOzBF0NMEOAUZmgqeVZsVSJAuGd01mg3P3YqE1ciB/faozJBtF//cOsGkIfVi2Eg6xuB5F1RI0ZgpDAev7MCTvw43cyqjy2t/jWnhFjQ85U3nCEkE6a8KJKcldhoU3T8T3ol6LsdelN07FkaHzVYgxCuNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J/KgREsTduGePnVkHvoaC9YmKlI6E7GawZoCyPykd9I=;
 b=rusexk5+CAUmm4HJ3iPCviCKvppTkDEqCYLxNKSPzaurpyEd7MTCVVNd5vcer5FpTLyOfFmoUlMEAJ1f3A5ViHecBGYvUiCIR6dXm5x1w8CGmlBUFhdtqxjuQe7aGkoiKmVB3cax8eLtcVEPqYAuWFlhO0VojK+gF3e0tNVbgDsfpzrmKZRTf6dbTitXLh7KGPH1YKn5K6Najgz+zEDR5Pa0NKSDDWvkrWW4tNsEbP6yP9xDvhsFjdr4M5Um0ajOOwELoi+b/K6saroLsxvAYArfq5IKJF/JSishzkiAng0GBzCXCoBLdyBdyDHBOdA5iLXUROd17BhlHfGIMLoGMQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Tue, 3 May
 2022 04:42:40 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca%4]) with mapi id 15.20.5206.024; Tue, 3 May 2022
 04:42:40 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org,
        Ziyang Xuan <william.xuanziyang@huawei.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 01/15] net/mlx5: use kvfree() for kvzalloc() in mlx5_ct_fs_smfs_matcher_create
Date:   Mon,  2 May 2022 21:41:55 -0700
Message-Id: <20220503044209.622171-2-saeedm@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220503044209.622171-1-saeedm@nvidia.com>
References: <20220503044209.622171-1-saeedm@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0088.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::29) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8f644a12-cbe2-4657-ef11-08da2cbf5b05
X-MS-TrafficTypeDiagnostic: BY5PR12MB4322:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB4322388A66F6182202FA3442B3C09@BY5PR12MB4322.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AK2iwfgKf3P6Hc1mpKRWTgDj2mMP4tVO4pFqnhjN1W0QAONbfISsvCb+TkT/nW1uPYHoOaXHvCsxTuoAVXDuuZ/ZPYPqXjSAQW8XWI3I73GoB1tmeqzcazHmYgN2vfgCiLsPT2lkKVZ9zcVCuokhrjzjBZ2pDmMTZvn8vkGDqYgmG1o+7k8ITR0EZlpFm49ZyKbc3CE1fAuhpQLPhe6AhEbh8leTILoo33eu6kbFLRo16aAkrkM1s77S5l3hXFaCiVn1BcwQkKblDqFK8JUMz8QFY01F+0iAAyo2af7cvnJyXefRu0i3PobVLTVPzmVVHMQ3Ja5ksARlkeC/p/hfCSWrcCJ03bv1jvFxXV92ko4KGgT+Aq7N0wv4jHejAtgbuPoYHtfUzzLEnmDMdwsLQKt2n6ftxtZ8PU+gXiQ+QHpbU3CUcm+bPbZsEZx0EQr0ojIMMogFnJIU7RrbduIffHeligvtHUY5GZC3Fm3YCHKIhbC1OXfP+pehz5q2JQz5JRdkPdF1Qdkl7OGkqHnxHlZZakMDLg9fbvX07JDIf4Ysvtu5TnGAALqy7ATiqKyc+NpLf03oRt1njZLpPEklsetWD30b4YxpfUP11HxHFjSJLL6vFyHnGW35tqKdbD/uukg/UDCi4IRNAQETrHN2wg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4326008)(66476007)(66556008)(8936002)(6666004)(8676002)(66946007)(83380400001)(6512007)(6486002)(1076003)(2906002)(508600001)(86362001)(2616005)(186003)(36756003)(107886003)(5660300002)(316002)(6506007)(38100700002)(110136005)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?P5C4kDIaEqzapGxcq/H0dBe50pp+aY8orwG0QjviVKkOLjYFFznnOfusfP7i?=
 =?us-ascii?Q?u1F7LBPNnx9b2M1Nne/PXuAT3dbPsAwlpM3820VQDqzqCdQU9tgb12LzawEE?=
 =?us-ascii?Q?AkRWpwg/DX40vlNlofwMFP8mVXWleT2SmzzZlAcmUw/VOk9EXo0r+K1vZtUf?=
 =?us-ascii?Q?VnaIF0g0MaPcBTrqsCriBhbUe3PZAehgfFJMn/3NuqiG+dFF8Mch3Kks2qnm?=
 =?us-ascii?Q?uNOPds9XIllpcJANLOcr5iwEziIGcNd8J+C8breDwzPTfiN1wW6THkRloNiF?=
 =?us-ascii?Q?TGI1bX8K13+CmWCBqyXoxiJpiAnVzqiZCZaKD11Uf8/Mv0L4IRz44iSDvh62?=
 =?us-ascii?Q?xch3MY7xwBru+ZpfbxKS0MHQ6gp3lGmNiQhch7Owy0640h5LlHPI05vI4arl?=
 =?us-ascii?Q?qCAVAtUQb+LOxM2+ZxkUtD4D7Hl9+fC8amV4IrkzDId0lru9vozvaqlxuSaj?=
 =?us-ascii?Q?3dcDPD6t9k0WAmR5Tgo92KmoXQkaVAeS8qzjOHWIdLcis797i8TzxXtKPgJc?=
 =?us-ascii?Q?/WqKfHdU8d1l3SwioGXjGxBfbMdLaDCdnJEg6Yr4vrRyeBeyzUoedF1PETIP?=
 =?us-ascii?Q?1VB/+IHYHSw9ru/AedMa6FAVHF5QZ4el03T2tYyBQtQUn/yoaLh6Jsy9N50C?=
 =?us-ascii?Q?U6LLS9gIdO+gRdCxE4lIvFtkN9gviJ8bU4vckEqlfc66kiYNUX4OekpI38Ck?=
 =?us-ascii?Q?3iSON34RZxdWQLWbfsWocB3ZlpQ+t7FYMaBJmMfDwuBA3qwjwu5lx2I1tCXh?=
 =?us-ascii?Q?lezAULZjXpbmqLW7Bm95tm+9zgd6ISmPeBXtKDIvQaKQicizddHvh9VWVMLG?=
 =?us-ascii?Q?VKBsqdz3BGxxwvOE4WpWwy3SaUQOcI5lM6AaUHDMKBMvBGZSbzP7n0yD/Rfy?=
 =?us-ascii?Q?/0XPGyPS0eCQCbLTbFDV2cfxbMvJS/GF+OBmm8p15RsaWZ+g6+pA66U+jOMt?=
 =?us-ascii?Q?YOsX3JwnYQ8jJkD7hR/r2VXisX/N5Lyvf8WXsxV+fYqCVKQxbDcVQA6mqNzd?=
 =?us-ascii?Q?VlGIukrRGUyPWkHb0e7rdnwdGL9QomXxaWosFaOvRlS1hraPcMjzt0p6d4Gz?=
 =?us-ascii?Q?zM9/zrL2WcTSSqtMhTntgEix3YIJjOkTWsIYe6bVSvRsQm5EPJJQis9lpWY/?=
 =?us-ascii?Q?mbD5sBZRRBal2FB4pY2Xxd64am4uzYmAZbvOiSWfGivjcEwMmh5FoN3Un3Mk?=
 =?us-ascii?Q?QNiPH9jjt62D4+9ugx3RORuSgZX99RMKyPk4+FhWaCSOEYH9jeddfY6wS+Vs?=
 =?us-ascii?Q?xlVEBi7M4exAe+Rukka9kQ7NilHLSWQLqVjfjWzhIf7NLEXh4/LaQWOckVMW?=
 =?us-ascii?Q?89Wz/HTRj5U+QlsCBHIjQF+6xjH/5+QaRmtPEgGm4Ii/qTWgnTOT6kqF5WOb?=
 =?us-ascii?Q?79BQh460ef6vjscGyz4sDOweFOsXit0c1w0F+2p2sAHMO1wHUK84RAjnIrRT?=
 =?us-ascii?Q?RFgZ3UL+FngYHI2SaERBpiLYA6uklcoNEEtGnB9NHtgdwYm1/LNuTOrhM+j/?=
 =?us-ascii?Q?7GHLBpdTfBWTM47jlAAEYkGQmaXCTL4/5zkueUuc2WaCL/fsGdoX5cp0lWRw?=
 =?us-ascii?Q?PTYkSdl5lh3Cb1c/m7f21z1onGaXV3L07E/kXRZOGwKOK/Brcd+hSCnl8B+K?=
 =?us-ascii?Q?/srC5M5Phm2heFPRYOIAVq/Cy27vVQW9jPb3nsExHnI5cJBZoaq12Nu1i66W?=
 =?us-ascii?Q?xfAuNmZmypHVdBer9d3R/fH8yL9dwhJskr4hRj9qQbdlXzu3bfOsDiHgD4UM?=
 =?us-ascii?Q?Mw2vsql4gILUJMokG4PWQx+CXvKza6Y=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f644a12-cbe2-4657-ef11-08da2cbf5b05
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2022 04:42:40.5556
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UGtwRCZJyiM2qDdrTXkLdAHut7NiIJHi9pO7h675C09Wpv4z55HK+PFFh1N+8x75fbHrWkeBk7EHYs/5dmLPMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4322
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ziyang Xuan <william.xuanziyang@huawei.com>

The memory of spec is allocated with kvzalloc(), the corresponding
release function should not be kfree(), use kvfree() instead.

Generated by: scripts/coccinelle/api/kfree_mismatch.cocci

Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc/ct_fs_smfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/ct_fs_smfs.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/ct_fs_smfs.c
index 59988e24b704..b979826f3f6c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/ct_fs_smfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/ct_fs_smfs.c
@@ -100,7 +100,7 @@ mlx5_ct_fs_smfs_matcher_create(struct mlx5_ct_fs *fs, struct mlx5dr_table *tbl,
 	spec->match_criteria_enable = MLX5_MATCH_MISC_PARAMETERS_2 | MLX5_MATCH_OUTER_HEADERS;
 
 	dr_matcher = mlx5_smfs_matcher_create(tbl, priority, spec);
-	kfree(spec);
+	kvfree(spec);
 	if (!dr_matcher)
 		return ERR_PTR(-EINVAL);
 
-- 
2.35.1

