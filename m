Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72B89517CB6
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 06:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231272AbiECEq7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 00:46:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231255AbiECEq5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 00:46:57 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2076.outbound.protection.outlook.com [40.107.212.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9FA83E0FC
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 21:43:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=axDWozjZI7m1Yh2ftTtEI+RGhIhTQlY9fCCwYJR3nmXmBm61N58qNajpsp7fDykDHWgE0bcIpND/cRCVGd8g+87S+BarjpcWsJsQpkRkC23R6D+Zz+gMSc2SaeqlgUXJCsoy6BMhciZvGEoZFDBOYxn5+yoPSdFwfvynFf8Dz6B7tZ2j9vLJ/6cOGQifS5cAXENd9gs8oIDfHql8iwkTjElSdL3k3rdpd8hG2DbTU95XhbKh7oQcwlOCK4j0oqPe1xwSafwzBCLesPcCHod/UwVwfgqi+ohnUNPgNVSdV6rQ1ZCVmoDddGuNzuShEufTqz4fdRq+S/FxAMOoLIZfbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lVVDNJhWVfh9L5dF5U7p0XPlARujKFUgyCF4gEcQFts=;
 b=BkEECO1SyzmCCdoccCuCVNCzb4Cf6kI893W+0LMuwetssv5J3lujVThHnFKV2A4cD+0NaY5X6Sz2ReUevEAEy8TY62DnMQgOr3xtEoiDraXBAbeG0SJ4iqcJbtLgvUGXDdZ/zjSvikU5VlQ2BHfJm/WHS5+1VzmvTL8Q57Otzvg5OA84xGXQVVfFjbSCTxQPI2wDbMIb3CeNSUvgwywI5g5NcciUgu7VAqFfFMIrE2knIKpSIOGClH5d61s+YE17UrI8kLD2P72k32RUbaNcvvKUpRRy9Y+yU3XSVH1YeWFCHDxyaSOZCFtzSJIaHJIsIbetZGUHnVPl8OvpSFeWMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lVVDNJhWVfh9L5dF5U7p0XPlARujKFUgyCF4gEcQFts=;
 b=MYjGOIK6fY6euvMgtk0ah+4roYUwM8IzPQwi7ZqmSgetKImDT9Ke5Sx/H5LHh6qVrqaIfSNhMe0cZ4bYwtddGLvrObM9wWShJzkUlUAWvbyLXrgTK9JtqzBjsiH7djLojnLcsw8KdiMPvbgql/0uDBqUKRqIGzwJ1mW/RQaZRpDrdr2WSqoOtqOiXtcXvGlYdVLrZ9eI2kXDVnLFTM6bQ22GPD5DhZCw+A6if3i98btT682I61FGvSObVNaF62Ikjohuo2DwRsjSKyiVK/Kaa1Z6p9r6JD3JQwH9ybltvoMREXmdBm18JYAXyKO9g/F3O7nOaIIRj+sFYFJx/7/xiQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Tue, 3 May
 2022 04:43:25 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca%4]) with mapi id 15.20.5206.024; Tue, 3 May 2022
 04:43:25 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Gal Pressman <gal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 06/15] net/mlx5e: Remove unused mlx5e_dcbnl_build_rep_netdev function
Date:   Mon,  2 May 2022 21:42:00 -0700
Message-Id: <20220503044209.622171-7-saeedm@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220503044209.622171-1-saeedm@nvidia.com>
References: <20220503044209.622171-1-saeedm@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0109.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::24) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ebfe370a-5ed4-4fd6-49ca-08da2cbf75ed
X-MS-TrafficTypeDiagnostic: BY5PR12MB4322:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB43229ED73637D20999A17E11B3C09@BY5PR12MB4322.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ilZUmrQhIVXMBlK5cS/QrCM48xkl7uLlUgM5k8fmhPsMBgf9Xy8XDWTHvjhwsSQhph7PPzlm4vTApssCTlZRs7i/86o22Vx3Ab20h1VutixdTwQUEeHsf5/rbtr0nHIi4B+uSO02JSb4ABjwUbCe66vr96dOBWrcGOOxFv2Sf/jSQHW3LogXZVnN71S7Xx6Yr3aGrWYtUJH9n6qI4ozLVa2qaWTMYJWcJ7OtD1D5MfgjGpdxdL1FYjIH/IDCQ4kbxSUKQp8nUIsDtuwQZO8oaGfl/ftWUqvSCPvF9IewR1KqI6pOojuOenE4DHz3rniaKRLV++AG2c35XKLj5lMdAuOpMeXeuBNT0tC3s3iEP2yDna0DnN5gTFi3j3zsLJ8L3Fn6hXKS0xCvvYbg94pjy9LNNQAXegn74dIHUsP+x5cwTTeiSjNM3kLiNLGtRA9E0YNzuAyBgGwwFlaB13qxIKfuVK9RC4qmeyPqT7m8kHECdQI0oycd29ti6ArQ8L1iPTWQ1lj4qf0h0svlkzkkjbxVzlHCwrrJwyJtfsN6HcyjrDebd64u1g+kNCKn8aWJU+HU4Hp9QCfuln4VKH8YbC0/fKY3I4up++/WnqfzSpI7dDVkmNh5aKWptrA2REhd7D3sWLGxsrdEW0a0/lso+A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4326008)(66476007)(66556008)(8936002)(6666004)(8676002)(66946007)(83380400001)(6512007)(6486002)(1076003)(2906002)(508600001)(86362001)(2616005)(186003)(36756003)(107886003)(5660300002)(316002)(6506007)(38100700002)(110136005)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2/5lfSMAJz6CxNN1n+TS6PIiI0Xpww4J6/8Jh/A0HkY12KPc9WdUYyP5Okeb?=
 =?us-ascii?Q?VoD9psYSWvRdxklqHqDDsBFNa7AuioiCK8rsu6mEwa69z1knw1rMSbOsFZ2K?=
 =?us-ascii?Q?Zb/ra/RdHT1E7gZwkMCZHvgvW+tEoVrWsz5YmuQ5Kp8AliNpm1UNKGpJSVtb?=
 =?us-ascii?Q?9c4ZukT0lligfBg9O9gyTVcvPCmqa9Rs+s3uJv6lzEz46ShUBazCik0viuwr?=
 =?us-ascii?Q?JODQl4bnwVB+vNm+8ZOVqwO9O+eUulCyRG672KgTdVaUGDfNib9g8R4ENCp2?=
 =?us-ascii?Q?cNpPNEGn5DnMFEmzrvowMFDYRka+XIWOvF8o4R6IEqC8QJrfO8kTdfCh5Ful?=
 =?us-ascii?Q?hmiycFamU6xzUeoJvkNrt8RW7hrt7q8Qa6dUIxjwoyUqH/t6XFE8uM0ChoPA?=
 =?us-ascii?Q?+rTYWR2Sv/X1xuZAMqvJYwjgJXR5bokpr/O7wd+A5F4gVFcIRYIIn9iPtSHz?=
 =?us-ascii?Q?zI4RtP8pk0cv07HQ/DQiCAkSPUiwQGNCowxjuCs/nrnA6+Jye0XVyocCssGI?=
 =?us-ascii?Q?CQoUC5VBqlcgDx0s6/6BVvWx5kEaH9Ao35TyibLeTAL3Nd0OtZBMi6t/nKBu?=
 =?us-ascii?Q?+DwH1FoGv1VTpWowt9qbMuGAMxYDW248O40/RjjVnEgAGNQcTdY2fNQOhPkx?=
 =?us-ascii?Q?xKOmgB8epzsEQ1KiZEkJFCOhbeON4L6OHkE4PMgWHFRuikcb9q8AUW49PV/y?=
 =?us-ascii?Q?++S9yMjmGje1VQpEkZpbyF1lewBitn11S//3anxnprffkrtNd59Aam0H8Wck?=
 =?us-ascii?Q?Sx5Azn0O2LkVbm6EFEABkzNfFC9RSzF13XFJ1ZsBuzua7F6MqiMNkXUrCKae?=
 =?us-ascii?Q?VwkCTqQCxZFSXKEVzIr3J8ip1z8fK+na0jFDI1y1I3ddAlLUvKxH6jNPXngg?=
 =?us-ascii?Q?xiRW4XaqN9vzZsF+tZI9r2T0e/NYL9BJOOekjjm+QUEEE2bDgJx4M0Lk4q/c?=
 =?us-ascii?Q?3zcM2rsGqM793Dj/Qxf6honjsL0fcsXvzpYp+YCyLwLymJ1mI1VOJtlY3YFt?=
 =?us-ascii?Q?twloZxHMAbDJQk0jv2Uze8rf3m8b49yXabvB2MIFMOtz/aB4tCARnQ8XGgAt?=
 =?us-ascii?Q?XSgA+E5udZ004sOv8nCo47MmCzzV9Z2RgTMRUKf7k9DhOzdubAPGnnWEiTQa?=
 =?us-ascii?Q?qlbLLk2gCZb++5Fx4tZvkv2dePL7i1m4AZ8tl/PAQaAAC5DhiHF3EYM8j0jK?=
 =?us-ascii?Q?9Gby7H81vwMRXKi7/6ivhtKGqlhqIE6hKvnhWqFkVPF1QFIim8xxm/dTzDZM?=
 =?us-ascii?Q?inPZrquInkzWsWhG4hLghIRB/+fAHeknJjWuRNyY1DIt1E4C/ni7UKPsJDi1?=
 =?us-ascii?Q?borb1Pap/80fT2qZyGohYn6C7rPj8y0hMw1XIy7DT93jqk+wiCR8yLS1PwY3?=
 =?us-ascii?Q?AwJs5+prDA93P9o79MBVjn7iEtNuICiKx6yex6THIQ90TyvEGdu2FrmavHky?=
 =?us-ascii?Q?5qD0oP46wpkuOhbmrUCkT7rVLvtpE5mJXx2AAs6xRQl0u1++o9lN1Mz4hX60?=
 =?us-ascii?Q?MljjQtiA4yE5t+KgWuG+LZnQgwqVa79gqwI0Z3CucIzJBGcNtu5VZRL4SSoL?=
 =?us-ascii?Q?qyznmvqmEzwwQXi9rDLbkyexA2bNKKPDCTigzGX/DXNM9CaU+PXfQMLO2eLo?=
 =?us-ascii?Q?RBWzTAMzyuNSH3a9aUjOWTARuPlgW5zBKm0enLDkiFF7yM6GPivRAPOcNqji?=
 =?us-ascii?Q?h1PHD6lQMCAxN1DFwc4DhTjiVqzjSUwcwH9KWWzMJ2cSSpfqf1w0LgA+3rHL?=
 =?us-ascii?Q?mKrzzvF6CyfvsGRRTcrngjaPW7mEjxQ=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebfe370a-5ed4-4fd6-49ca-08da2cbf75ed
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2022 04:43:25.6770
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +9Cg+d8hRWHhvt58ZlmMN0/oN3uYBECiK6sqENrUECT7YkZ08CNMf+Zsz7YSUDHJssaY0XnipHrE3b87dTxUJA==
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

From: Gal Pressman <gal@nvidia.com>

Commit
7a9fb35e8c3a ("net/mlx5e: Do not reload ethernet ports when changing eswitch mode")
removed the usage of mlx5e_dcbnl_build_rep_netdev() from the driver,
delete the function.

Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/dcbnl.h | 2 --
 drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c | 9 ---------
 2 files changed, 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/dcbnl.h b/drivers/net/ethernet/mellanox/mlx5/core/en/dcbnl.h
index 9976de8b9047..b59aee75de94 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/dcbnl.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/dcbnl.h
@@ -40,13 +40,11 @@ struct mlx5e_dcbx_dp {
 };
 
 void mlx5e_dcbnl_build_netdev(struct net_device *netdev);
-void mlx5e_dcbnl_build_rep_netdev(struct net_device *netdev);
 void mlx5e_dcbnl_initialize(struct mlx5e_priv *priv);
 void mlx5e_dcbnl_init_app(struct mlx5e_priv *priv);
 void mlx5e_dcbnl_delete_app(struct mlx5e_priv *priv);
 #else
 static inline void mlx5e_dcbnl_build_netdev(struct net_device *netdev) {}
-static inline void mlx5e_dcbnl_build_rep_netdev(struct net_device *netdev) {}
 static inline void mlx5e_dcbnl_initialize(struct mlx5e_priv *priv) {}
 static inline void mlx5e_dcbnl_init_app(struct mlx5e_priv *priv) {}
 static inline void mlx5e_dcbnl_delete_app(struct mlx5e_priv *priv) {}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
index d659fe07d464..6435517c0bee 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
@@ -1026,15 +1026,6 @@ void mlx5e_dcbnl_build_netdev(struct net_device *netdev)
 		netdev->dcbnl_ops = &mlx5e_dcbnl_ops;
 }
 
-void mlx5e_dcbnl_build_rep_netdev(struct net_device *netdev)
-{
-	struct mlx5e_priv *priv = netdev_priv(netdev);
-	struct mlx5_core_dev *mdev = priv->mdev;
-
-	if (MLX5_CAP_GEN(mdev, qos))
-		netdev->dcbnl_ops = &mlx5e_dcbnl_ops;
-}
-
 static void mlx5e_dcbnl_query_dcbx_mode(struct mlx5e_priv *priv,
 					enum mlx5_dcbx_oper_mode *mode)
 {
-- 
2.35.1

