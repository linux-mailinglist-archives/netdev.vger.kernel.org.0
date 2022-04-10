Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED7464FB0E3
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 01:46:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244167AbiDJXsb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 19:48:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233726AbiDJXs3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 19:48:29 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2072.outbound.protection.outlook.com [40.107.223.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2938714083;
        Sun, 10 Apr 2022 16:46:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C+eHrp/bSmXq06qAM85pDjYycvEnXCllYPeMgqTBNERjmd46bqd/PIuDGFC2oYV7KyH1dctfAj3jRgwTdgQd0iVOGb9CZya3KHfvJz+W+vLHdun63Co970zX9nTCbdKIFKGT5wtqvQKLlnyk5sTWrJLb5ae92LZTEkfIapECHRb/TEHklHCPU5GxOCo8qvCyzSf0nveg1g/oN9ngkpEuudnIkUTt+8G9mAX52dWhph5GcGJg2v1EC0PQY/B33EDuDHmqVabD6NpDVIO2gCPxEN6wDDfrXZ/XZK/jluizpAGtDt2DBXcv1YxbWs8jURpu6pE904dlIr6c0cG8hRI7Pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4neCUNNPn27M2a50j0jtIMZk/QLCpGyxQvRe30HEhMU=;
 b=bN2vFF5qDednBXB7lpyXZ78yhqs1jgmVI//xo3EXurvtdgwQbYIgaad0HCIzhzDWwn2/497+FRQOXD/jpjR6WNUiLkorJMNOgx+iSxM35G7EYa4lR4sTu1IQvxsS28FdTjYjTRvHKQgGTx195fvItUt0l2XlFFAUX+QSUjrRwF6Mv1Ovzcio0/e4TAtjS+WoieLjCqW2QzhVTNOJWpJ5Yh7I7k+vBSHVlh/Q1+qp6QZIRVcVdnMbcN5KWOT0uOEOGEOWHMa42+RI83rLnM8OgWtCGzGm6u1rFfN2xKcHzHsWqyzPykjAoqKMKOxlpjw9hH+UQqKIMkuzSB6F6MVgHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4neCUNNPn27M2a50j0jtIMZk/QLCpGyxQvRe30HEhMU=;
 b=MDnWuK7agzwdpJ88P233+VUDXDXrGetUOH9ucNEJNdzNTIBVp4FipXTA9vvZkUpm6L+fqNeS+JV3tUe6OsZ0gczs/IoRZ2fiZlHO3hkAzozD2/nkFqzDWUPWFvA53x6DKhNhejsNNSGGcbhjyARMN/Nf7DoBiMiZtXCKDiqngsVLf4FR8eZFa1e0CCzwJgLP9GJzSbwY+oTPc2TkwpqYI1J5ZqQ7z9/53igqNmcSlt/Vvbj3HvrgwSBZq0v+e0QKS05lX3jSsTQ5Z72d+0HK5dHDIB7yZ0glaOSZFhyVe5SwQTxJ2Var/rdmfa87GwumMvEU2hhVeOB3RifY+iMs0Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by LV2PR12MB5847.namprd12.prod.outlook.com (2603:10b6:408:174::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.27; Sun, 10 Apr
 2022 23:46:14 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::f811:b003:4bd2:4602]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::f811:b003:4bd2:4602%6]) with mapi id 15.20.5144.029; Sun, 10 Apr 2022
 23:46:13 +0000
Date:   Sun, 10 Apr 2022 16:46:12 -0700
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>
Subject: Re: [PATCH mlx5-next 02/17] net/mlx5: Check IPsec TX flow steering
 namespace in advance
Message-ID: <20220410234612.cmhkcuraszf45lfm@sx1>
References: <cover.1649578827.git.leonro@nvidia.com>
 <123bc1de57218089184a77465218d930997a8cf6.1649578827.git.leonro@nvidia.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <123bc1de57218089184a77465218d930997a8cf6.1649578827.git.leonro@nvidia.com>
X-ClientProxiedBy: BY3PR04CA0011.namprd04.prod.outlook.com
 (2603:10b6:a03:217::16) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e65492a3-0235-4cfa-6447-08da1b4c4c08
X-MS-TrafficTypeDiagnostic: LV2PR12MB5847:EE_
X-Microsoft-Antispam-PRVS: <LV2PR12MB5847788BAA19DDF2CCB56712B3EB9@LV2PR12MB5847.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yOyS+bBG1cHjAmNUuGpvOdv4KuFks9nfYIZLbQx3TlAXFtBA3dIUP7fy4BEF65YL4dtMvL8Qk6d9+R2BzVUvnNw1c1dun/Vc05hasc4NlSPVchuRCqSKHQCjsDq74QFo6yMmqvAhfTpYzEdzlBp7/TjRAca4vXKpeD9OFkFxIz1IvWeD97j7vmdgu4dOyQGl9EwGhv+vkos6+Fg1h0N1gSkGOKQdWcpOvlp/8/0z4kixbPd7gaUwBVaH1FbYy9XaPCqnjgJjw2taojdKddS6jIVlb2cCaWPt009TFCNyv1c4WiX7EcpeC6v7xUcE/sbfk2VSpVpURBDXcxqsgRRc0t7Jgm6OdoinPGO8wkYdwD0DLRtgHZMZpBDo5VfpMgBCh0dH1EtmhIQhLSLWtPveiUx0Yo7YXdgmX2+vYR5Gn5UOkO15hqvU6rHoRyZ5n7NeCCXufiQgOUqt8eE+r5A0giuo1EF/NCB68ZkuHkORfJI+agkxv+00eeit4y7mx6k1GhV3WPLL8sYqgsajWlsOeIlc2Nxw7EvQ7YpUCQdVz5WuuYOaBQv9islijy4qZj3okWUWjnpFscZSunl7vy90ohbl3TojrKaMhOnZCrAyh7tsY8N/+FlBXLeG5N2cOL1h20yg5k8IGet1nq5MSWO/aw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(4326008)(38100700002)(66556008)(186003)(86362001)(66476007)(8936002)(6486002)(508600001)(5660300002)(66946007)(83380400001)(8676002)(6916009)(107886003)(54906003)(316002)(1076003)(2906002)(6512007)(9686003)(33716001)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2BPZTIgw+5MloMHqvejyz4fY+2gMpAPq+96ruiZOL/r5GP0TFYA1w/+R4lwt?=
 =?us-ascii?Q?RxuS+RUA+6EjhDVJREk8VYyLoI0KlD+pv/pFe7nX0bDi8IWGqhncVxyR9Amh?=
 =?us-ascii?Q?wJpYlMESWI03MjWjUt7DVYj78RerC+U9RRZ163EMjPQm23YKaUcSmFhfFeC3?=
 =?us-ascii?Q?xPiJXrI9QQ6/3SUCDgJ0p6dvwpxnkNu9HDTVydop0J7wuhrbT2AjxEf9YDdx?=
 =?us-ascii?Q?ZXbpPIWdGk/chFH/2M9bQfJ3M4k9f11nrjPl0Gg0/OUXUzhkfq6EbpWvflAm?=
 =?us-ascii?Q?nUrSuoUJVCt9To4eA4IMqbXCv95JV6bFwZeCJ+IdXr4x1hAymSRR7z2826wq?=
 =?us-ascii?Q?QYHHDg7qPYsXSo6tYzoHXi1vc8OQGh4Xt4PxKAqUXRUMZdLej3uGEQ0HYH7U?=
 =?us-ascii?Q?oF9tYDxMdW0Qp3+aQllKkXK1mV6DJIGJSbcP1wpifFtQtFQCZfaglWXB0LPv?=
 =?us-ascii?Q?4s0dWsmmVWi35fA3OVzpub+Gh+nLLvOTBbnAfWevMWYdyj0kWownVjGtAArB?=
 =?us-ascii?Q?QO+/RWKBvNgGCsRjDTcTjPiswPsMX3Jr17Ek1+YYP+aZxvhBtkcxnaiJBlGM?=
 =?us-ascii?Q?lG2Adr+hBhZr3wetTMCPpIMS7GfQt8rBbEGrmNmoUOCp4lLSdOajrwVubcEu?=
 =?us-ascii?Q?pqIBhsc4wf0jQ4QnkRnY7/RG2Lh3Hw+b0c10nd8flDPEqHoIvXRZg40yjC9L?=
 =?us-ascii?Q?me8lFo/OROdrCfN/rPbcsu0rJP2xAW4vkqx3a/Ug7oCCfxMpsfVcUsUkAAC2?=
 =?us-ascii?Q?gnsmCZYnEZdPs1Moq3HvooQmRkPdL9KPiNolClRfaS6TmhPbhsoDE0ODSprJ?=
 =?us-ascii?Q?7akOK6CSqwA6eTPpt2nFTCADt5HOeplqEjfyvcIMqhhcAOVWIuEfT7exyJTJ?=
 =?us-ascii?Q?vJVKyLa2YYUQ1ZxfYEuh2qteqM44bAzBJA4osLDExEY1IDhA5y+IkkZO+MU3?=
 =?us-ascii?Q?sD/ucV+9hDyqoie6J9LDWmoTyzoSKHGNHJEfewXbrs+2KgGsO/xZZHqe4iOw?=
 =?us-ascii?Q?MnL7Qwd0UTzs4gPlPSDmMiQqewsVN4lyp8bTjQX+EyWnZDtCDtqoBTQ7s1tv?=
 =?us-ascii?Q?hWgxGV4MPBSddxn8L4R8Ft1zUpT5jBHcCThAkjES05+lxJIGomxy7q7VzEhB?=
 =?us-ascii?Q?QFVY7WXefrbJ7mtq8Uc/SlS5GGIbbScAOKdoHIfDDEFRfVgStVDzzBICEBEN?=
 =?us-ascii?Q?BBBGFx7xXFLgc3obMhaU08WCqUC58Rhv7EjQgLRhB9AvE2gRMVPLLQKqjhH/?=
 =?us-ascii?Q?2s3UW5zXwhcPwWKd2QwjtC/rQzfd9Iits/AIIPaBOlU/Rl0rTEktmXj8mULw?=
 =?us-ascii?Q?ApzS3t0HTleP9lPtxWJXVq3Rw6DFmpOoSxkKVECgBJdEHItyAkTD8mjx9IuL?=
 =?us-ascii?Q?g3DMkTouJoGmvK5SOepeAOTGItlD14NrN8L2XKBkiNaWEHrNE+KyKVPgcr3r?=
 =?us-ascii?Q?Ary2IOlut0bYDFGXrRBiMtOZMigF1BTdqzTrGdqVxvHn7lf4iWGviEpDX/dG?=
 =?us-ascii?Q?/Y3Xi3QyFmtIpYODsGb4mYjPPuCwQHNRVBm6pBqPzbNN6KA2kB6VE7Di41nP?=
 =?us-ascii?Q?6xONPX5jVyubMMK+wG+lCVE2GJmzHPFp6F5pVSc2dNi3hT1xvu4klzC9P96Z?=
 =?us-ascii?Q?xuk6Ak+HVpQfhLk+xDWbF4vjyM5TNVqTI9uLo15GA2exOTb9azyU6WP5DlII?=
 =?us-ascii?Q?lr1THMsVwq3btlROiWMZfdWPHKb/D+Nc3dI2SQ5OB8LZ6wHr416IWs74EbMa?=
 =?us-ascii?Q?FWPvNBIQOFMimXhpicBTLSGowZVoUqk056uHseRY0V0MZOedmzYU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e65492a3-0235-4cfa-6447-08da1b4c4c08
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2022 23:46:13.4834
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qdtsP6CK8BKdE51JoAsfA8TPCeH6Njb3Q/aH4XHkXe+al50HFw57SWuLVo++hda9R/8FiHDAhNM/1FqRcbKyUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5847
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10 Apr 11:28, Leon Romanovsky wrote:
>From: Leon Romanovsky <leonro@nvidia.com>
>
>Ensure that flow steering is usable as early as possible, to understand
>if crypto IPsec is supported or not.
>
>Reviewed-by: Raed Salem <raeds@nvidia.com>
>Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
>---
> drivers/net/ethernet/mellanox/mlx5/core/en/fs.h  |  1 -
> .../ethernet/mellanox/mlx5/core/en_accel/ipsec.c |  1 +
> .../ethernet/mellanox/mlx5/core/en_accel/ipsec.h |  1 +
> .../mellanox/mlx5/core/en_accel/ipsec_fs.c       | 16 +++++++++-------
> 4 files changed, 11 insertions(+), 8 deletions(-)
>
>diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
>index 678ffbb48a25..4130a871de61 100644
>--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
>+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
>@@ -164,7 +164,6 @@ struct mlx5e_ptp_fs;
>
> struct mlx5e_flow_steering {
> 	struct mlx5_flow_namespace      *ns;
>-	struct mlx5_flow_namespace      *egress_ns;
> #ifdef CONFIG_MLX5_EN_RXNFC
> 	struct mlx5e_ethtool_steering   ethtool;
> #endif
>diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
>index 5a10755dd4f1..285ccb773de6 100644
>--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
>+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
>@@ -415,6 +415,7 @@ int mlx5e_ipsec_init(struct mlx5e_priv *priv)
>
> 	hash_init(ipsec->sadb_rx);
> 	spin_lock_init(&ipsec->sadb_rx_lock);
>+	ipsec->mdev = priv->mdev;
> 	ipsec->en_priv = priv;
> 	ipsec->wq = alloc_ordered_workqueue("mlx5e_ipsec: %s", 0,
> 					    priv->netdev->name);
>diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
>index a0e9dade09e9..bbf48d4616f9 100644
>--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
>+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
>@@ -61,6 +61,7 @@ struct mlx5e_accel_fs_esp;
> struct mlx5e_ipsec_tx;
>
> struct mlx5e_ipsec {
>+	struct mlx5_core_dev *mdev;
> 	struct mlx5e_priv *en_priv;

Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>

we could probably remove en_priv, I already sent you a patch, please try to
include it in the next version.

