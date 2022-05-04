Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD9A7519725
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 08:03:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344816AbiEDGG4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 02:06:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344803AbiEDGGt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 02:06:49 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2045.outbound.protection.outlook.com [40.107.223.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FEE01CB1B
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 23:03:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d+Uzv/0WMX5gyUapSd45eO+xqzVsULI/1HmdW6q6rR7WzKjb1cbFLZc87ceYN/EA2lKFFhzNpTwKaFRXkkqT1ZH+EKao2AEQOLZo7pZAbcTL1WhcWXZPGWgkyS79nY0siTXWCJl13wzw/eISO7ouic21tGC4pkkoe7AntutsBbvsaVErZeukXUY69flr1chw8zg2aiWyhDxIOljNLfUIrbZ4q7mkPDX6XTU7J0GtP6nJoshZmXiOv2H+MNF1cc5A46xx0eyri2d+LshxMHqfkF2QQtgEmdzIeX/ATlLA9nfEIaZWSsbl/44WWVzvzfwwkJVZ4461JTSyjZIGZdqx6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kGNxy4iQG613CMBGpFtQNpaqAW/q8SudCmdOrl7OG1U=;
 b=YG68wm3A/uyri0w8MBV3TqqJN8zeV60WfSZVaEdlHDkzLHj/e4+9sj+zPXpDDmhVDheQbeJhiANcusGIOvU2vwIJsFyIaPz1B+jzhDv12rbPRGT/zdEWK1QaAG658w+pCtkKXnddF+yKdew9XQ7wW16GGVghsFdCiqMHbzqt0ybkUYriDC4uxaPyk5sOQbS1cl3QY9rTHm0e7Wzoh4L3IJ37OldlpxQcWCEJb1gbk8Vocc0hrHwt0avfyLBtuFGTCUTGl+xBwW6uW7Rz2T9pUsXO4aKEWrYHTta7Rx3M6OaCPzop8OW4udgUFIEresBXvIJvR0khHaPtTbBtlTZXvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kGNxy4iQG613CMBGpFtQNpaqAW/q8SudCmdOrl7OG1U=;
 b=O/+w1Brjw01+idfw42jedBBmdBMtOu3KgIzpTDBH/FVFLi0iAa763Biki6PYfon24mSXNHbp+88CU2aP9xfmJf5OnMbRAmEDJwoKNbs7ZUXyuiwSM1ivclqGXr9s2k4ut5EGmhmSBbr/3mjWZOpUrrSRizgpmKdB+LkT9UQWU17ltvRffbrsvJ48DaOjeDdjaZXX5RgLa8ntDYhs+VBmG6bd68k1gRms+QeYdK6MnxvQskPhMNlSWmU232s36iY6CxOUJ4oeCD7+3CB0o46NocJgDZd4M+t8DP7FMi9kfK2BoJ/Q9stDBnupfoIn26JK/8nQIzEHX25yz8jDp0x+Jw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by CY4PR1201MB0006.namprd12.prod.outlook.com (2603:10b6:903:d3::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.20; Wed, 4 May
 2022 06:03:06 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca%4]) with mapi id 15.20.5206.025; Wed, 4 May 2022
 06:03:06 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 08/17] net/mlx5: Remove indirections from esp functions
Date:   Tue,  3 May 2022 23:02:22 -0700
Message-Id: <20220504060231.668674-9-saeedm@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220504060231.668674-1-saeedm@nvidia.com>
References: <20220504060231.668674-1-saeedm@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR04CA0029.namprd04.prod.outlook.com
 (2603:10b6:a03:217::34) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4b9d272c-6efd-4a93-c9dd-08da2d93c1b0
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0006:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1201MB0006FCB9F01BC5C86C418772B3C39@CY4PR1201MB0006.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CoDfEIWlvruww65x2bq0bGF67rx86buMMzUHO9ElT6UfgXrF2wIJbeMT1b08NWIu3MoHrkg/I8j/BobQF8V4TswiD0f7ow6O9pO+QrGhgPjHNkm+sQisaCt8kZO93op3qQVNvOQDH5CFKDRfMhfsGU65zYcc4BBBOUqNCx/evrpV7lL6fsuOXZZ8UrenskEMY+mcmD4wpFKfVkNXWhRODHZB8hlsIwxw3mPOcFv3ZnYdGGrkd4EFUV6cIEjRKt/czq4BdCIvqZRy+2xZVK3NdVWM4GTMNLmDea9o7YKwGhwgbIFY1p4wjDwhiG/2HH9/PJwACkq+RsOyO+B926n8fs8DygbqWkOk6pH6yXxKZOiw5/l2cKnURERr7e+Fo4j0lVyWRPWiPpC2KuB1G4dNxzjGrysuYlnKfmfP/Qsh11LX6VumbuBe3NSl9yHtkgKBXi6ppzING2Da7fMaGJLYTR4s9BaT4py7UisHCcPtzyW6qtLsgxvZs5L3WyU+v0HSHaWORih8AV8J7K5ysB9PAnVljMrCEAQb9Jy3BdAhq9MEjYANbiZtJGDeI5tgbgFvt7jXhqrtbypyjGcj5FUjUzQ5h3NTw2TnYb8QyPM69wziKf+auy+hUEZjn0bwW8G+RLqkWjxqWpKu00zil/ZUbg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(107886003)(2906002)(54906003)(8936002)(110136005)(86362001)(316002)(83380400001)(66946007)(6512007)(6506007)(8676002)(66556008)(66476007)(6666004)(508600001)(4326008)(186003)(1076003)(2616005)(5660300002)(38100700002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4AF6j1WxKNTVBtnCpgW4erjsrl4gIsrbUWf86vGMtPZ6p0aCGfWCQZlp0W0z?=
 =?us-ascii?Q?P4XFpAQJMJSBAcmZiSa6FSvobDi15e7mWldzp5BwEa1BCiRRE6q5wkB81bGO?=
 =?us-ascii?Q?2t7CryxIw/S+f1RJboHc7F7DMEpowFkM+Tq1eIdq6aT2GNMd3xs4g28lM+lg?=
 =?us-ascii?Q?KfCh+JaPDXNqbeFPRhmioSHh7LXBpflnQxpQzcxttgpXsUX//vi3dMNqIEDf?=
 =?us-ascii?Q?1FGOdvv3GXplj0u2+5TiVGfsHBEtGjZrA+Z5jvTqnXnmXa/HKELEnjjzzFee?=
 =?us-ascii?Q?qE/mKYgWvX4uiC34swVt5UoSxf85lyn66ixbLkcQdu+vcTxVANHDVioVeflR?=
 =?us-ascii?Q?MjqYwZQeyC+30t7gyfEw9ImDo+PB8r00z+4s3XNnfnenIqv6YJD0n/o8MW0t?=
 =?us-ascii?Q?W2vsv/s1WgMjMiALqotMok810sCu4tuFKjHzpySWInGyaimdn9ozDsA8fksM?=
 =?us-ascii?Q?tqXkjdFmITFI4cgXMdF2BGAHlbyHQW6xmVjJB5Ghoejbq8e0jg7V9CNlwhX1?=
 =?us-ascii?Q?e6wwVqwz7/bDs2VD/fFyejcYJ4y8wLKLIdQG18phJddtz54SAQqZ1s0bN3xr?=
 =?us-ascii?Q?PubDW/suXqksLxKxN7i5rhkFzgMT1OF3j/Zy5Cc3OL0fTNU94+/dK6/deiBm?=
 =?us-ascii?Q?yOVkwroNjbHTRS+KWq/hK/8PTDSNKcpUL/GkgB82yoM4H0LXkAhipNN4i3Sk?=
 =?us-ascii?Q?ziCCX3acmzGsUz3CCyaWSXVhdpuqvfZqO6t+Lo9zBzGV9lBNAqhmjIo3V+t1?=
 =?us-ascii?Q?gLqIVplA7f3yG8gpYFh8TkyqSm9S5/RBUvqAGdWkktMaR83e2MsxZORmzIPx?=
 =?us-ascii?Q?ItB3J0ROZ4hU2+CcnqBc7ZtjOJPKeMuKDX9aZmwqns9xFbd+NgLgXaYY3ck7?=
 =?us-ascii?Q?BMd+6a4PJ95EHpVy5G1Nl4ifb5g+bSkWiRTRrkT+pYLvvpOcJXN7hPHOkrKW?=
 =?us-ascii?Q?8szWLYzgt+w14KKwm1fLmVg00o7T28uFDyPLNlwPAGcT9cESpAXOuQZUd24S?=
 =?us-ascii?Q?sSEH8lBTuu+QDy+lbUAhxeSaVAN8fEHJL5V24NDjIwbfJ+6n429Ifup8c71y?=
 =?us-ascii?Q?1/ZaxjMq52OMHNnDQEaFoqX8L+ltbvysKftLuM4Yd55rYRwFY/Xk+OdDCCe7?=
 =?us-ascii?Q?lCzMOcGB2RLhZ5DmyEmLmVz2BCft6s/YRHLaXXA1aKaCsINipbsih3ix1lG3?=
 =?us-ascii?Q?MlM5CoK5EmO1xn17/qBGqGksCK8qVzJelyuFwFt3VcuURpgjd/5yMPxSOuYs?=
 =?us-ascii?Q?rtgv/ZhlGIoOSe3vL3KqmCcDQmNNG5ysAMQS+mRfMF3sw7f5ocyxCxrpxc+0?=
 =?us-ascii?Q?jGzRL2gXXFEIw0gl3yrMT8CyBhyjuRgFkeDPlbyQkt3PGn4fd3mODBrmQiZP?=
 =?us-ascii?Q?8tg1AGSamPZOdVre63O625lyYSc1hREOyMJfsZSKrkQ/ojpbVbR8ur5ELZ/K?=
 =?us-ascii?Q?buzJlXWacTC9SAV/lk7vBYfRomtXJ61fp0fCwupUJPdnAU2CsRzw/r9PvilK?=
 =?us-ascii?Q?mf3zKbq2J0VXMJC6TG99H+YWDeGKJpDuNV0vqzHWWNFxSVS4m/0Lz3v9nSZf?=
 =?us-ascii?Q?pdQ6EfbMZANX1fhVoVcJ92qEdjW0fi7AimdPqCbuG4h1m7/xNU4elSJCqGs8?=
 =?us-ascii?Q?lOnnWIwfQU7tIVGSqEAP8FeBjkp78B5UzhlHBELkAAZ/9RU0K5+PNaM1ORU+?=
 =?us-ascii?Q?5Bpqpa+SK+JvW6zLFwXyL7do53rkBJIcokx6hb4xJKoaof3LbxoDYqTKSUIm?=
 =?us-ascii?Q?2gi+Jo47l32bvig827nFwVNepJFGyJEqBJVnmWiEkMtdeZSTyItt?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b9d272c-6efd-4a93-c9dd-08da2d93c1b0
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 06:03:06.0627
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o5E69xMjeKSlpK+MOCWNO6iFGXBGWc+wsCbdzDp2kAiHcF1ia7dvjginvqYrnoDBo1y9Nw8CZYcl93NQ8XzUkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0006
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

This change cleanups the mlx5 esp interface.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mlx5/core/en_accel/ipsec_offload.c        | 47 +++++--------------
 1 file changed, 12 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
index 6c03ce8aba92..a7bd31d10bd4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
@@ -61,9 +61,9 @@ u32 mlx5_ipsec_device_caps(struct mlx5_core_dev *mdev)
 }
 EXPORT_SYMBOL_GPL(mlx5_ipsec_device_caps);
 
-static struct mlx5_accel_esp_xfrm *
-mlx5_ipsec_offload_esp_create_xfrm(struct mlx5_core_dev *mdev,
-				   const struct mlx5_accel_esp_xfrm_attrs *attrs)
+struct mlx5_accel_esp_xfrm *
+mlx5_accel_esp_create_xfrm(struct mlx5_core_dev *mdev,
+			   const struct mlx5_accel_esp_xfrm_attrs *attrs)
 {
 	struct mlx5_ipsec_esp_xfrm *mxfrm;
 
@@ -74,10 +74,11 @@ mlx5_ipsec_offload_esp_create_xfrm(struct mlx5_core_dev *mdev,
 	memcpy(&mxfrm->accel_xfrm.attrs, attrs,
 	       sizeof(mxfrm->accel_xfrm.attrs));
 
+	mxfrm->accel_xfrm.mdev = mdev;
 	return &mxfrm->accel_xfrm;
 }
 
-static void mlx5_ipsec_offload_esp_destroy_xfrm(struct mlx5_accel_esp_xfrm *xfrm)
+void mlx5_accel_esp_destroy_xfrm(struct mlx5_accel_esp_xfrm *xfrm)
 {
 	struct mlx5_ipsec_esp_xfrm *mxfrm = container_of(xfrm, struct mlx5_ipsec_esp_xfrm,
 							 accel_xfrm);
@@ -275,14 +276,13 @@ static int mlx5_modify_ipsec_obj(struct mlx5_core_dev *mdev,
 	return mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
 }
 
-static void mlx5_ipsec_offload_esp_modify_xfrm(
-	struct mlx5_accel_esp_xfrm *xfrm,
-	const struct mlx5_accel_esp_xfrm_attrs *attrs)
+void mlx5_accel_esp_modify_xfrm(struct mlx5_accel_esp_xfrm *xfrm,
+				const struct mlx5_accel_esp_xfrm_attrs *attrs)
 {
 	struct mlx5_ipsec_obj_attrs ipsec_attrs = {};
 	struct mlx5_core_dev *mdev = xfrm->mdev;
 	struct mlx5_ipsec_esp_xfrm *mxfrm;
-	int err = 0;
+	int err;
 
 	mxfrm = container_of(xfrm, struct mlx5_ipsec_esp_xfrm, accel_xfrm);
 
@@ -294,8 +294,10 @@ static void mlx5_ipsec_offload_esp_modify_xfrm(
 				    &ipsec_attrs,
 				    mxfrm->sa_ctx->ipsec_obj_id);
 
-	if (!err)
-		memcpy(&xfrm->attrs, attrs, sizeof(xfrm->attrs));
+	if (err)
+		return;
+
+	memcpy(&xfrm->attrs, attrs, sizeof(xfrm->attrs));
 }
 
 void *mlx5_accel_esp_create_hw_context(struct mlx5_core_dev *mdev,
@@ -321,28 +323,3 @@ void mlx5_accel_esp_free_hw_context(struct mlx5_core_dev *mdev, void *context)
 {
 	mlx5_ipsec_offload_delete_sa_ctx(context);
 }
-
-struct mlx5_accel_esp_xfrm *
-mlx5_accel_esp_create_xfrm(struct mlx5_core_dev *mdev,
-			   const struct mlx5_accel_esp_xfrm_attrs *attrs)
-{
-	struct mlx5_accel_esp_xfrm *xfrm;
-
-	xfrm = mlx5_ipsec_offload_esp_create_xfrm(mdev, attrs);
-	if (IS_ERR(xfrm))
-		return xfrm;
-
-	xfrm->mdev = mdev;
-	return xfrm;
-}
-
-void mlx5_accel_esp_destroy_xfrm(struct mlx5_accel_esp_xfrm *xfrm)
-{
-	mlx5_ipsec_offload_esp_destroy_xfrm(xfrm);
-}
-
-void mlx5_accel_esp_modify_xfrm(struct mlx5_accel_esp_xfrm *xfrm,
-				const struct mlx5_accel_esp_xfrm_attrs *attrs)
-{
-	mlx5_ipsec_offload_esp_modify_xfrm(xfrm, attrs);
-}
-- 
2.35.1

