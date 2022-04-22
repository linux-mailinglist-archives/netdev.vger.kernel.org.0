Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5753C50C474
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 01:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233482AbiDVW4U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 18:56:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233689AbiDVW4M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 18:56:12 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2089.outbound.protection.outlook.com [40.107.100.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88C5F15F584
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 15:19:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ehddvzP/zNQ94RWta0AMM98ZSez50PKpC9E0O2AidjYlERX3p9U0kX6GtlGwJfxG7D2S3UmwyIjDmcLTv8Er6PZf+/mmhWlpQv6F3rAzkFnoSjSm8CoNtMRTLU3fn7/ddIMFBXUgX1D347yLlXBNGmEx2cJ+ngJN2ddRcaCZsUOzO8Wtv2wh3NdeZQ0c1bNlRkhU6ICwBj9nAjJEVGOYq4itZEsVO+TmRcMQM1EBrKqgA4AiR75q1rAeYHRTnInG/7hY1PY7zLqhlv5P0Iv0uK1u2cxF0zbKY8x3vrfNCv4Ql970C5fJsNzUxnRT4ZCmt6fdeHj+DlQFXPED2cmetA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fKSGOc5zzZ7JQSfJhis53tQfNY68rMcJF2+1BVx4RF0=;
 b=fa/68npMBtTxsdZP4L2IvDjVWzHSAFHDHxvGkJ82J5vnX7P/oN4VNS842P/UyPCt3weQS5rWZIQpSQx0Qwmp0cw4/BhX6d7X8ewrSXFZczn8Fey1hnWek0JXVRJvb0ALxkNICLxPnMtMOj7wd5tsu5bVKGBHxyFN461Qc/0Gxu6s9kN38o60jFO2kD70JeNDH91ksZ++gspBYDRRtjYlc8ApFa1f2FNeAKtmlYGesGzBgly/sXCSdTafrIP1P4XnpD6n004CRTW4X59C+4qIChJVWMJRS4X+bGy5Tzot2o6nQFb1O6DsL8YQ0CGUg/ZJnC+c/MYNfu8o2A+wID9J/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fKSGOc5zzZ7JQSfJhis53tQfNY68rMcJF2+1BVx4RF0=;
 b=J6cDWXM5/t5nQpM9t1YM0s9AnGCUr/qG3q7kG2bmYVt12C4FjTKqas3zkqByQwWSfCYoo9O1itAZpGmN/4fjaDO9oE0rgaZjzdnBJmxE6IZnMgd6icp6Sz1v+pOSkP9m9Ox7IXKWWluFh2tSMPn9OcwVaCJUZqNPUQ/7mG2lMXtRSmYjWo8+F0gzuiDkxm41z6WRrH7fLGjR2a8C5XSbczG3JKalSe0Ly0ew2pPzqiL37J2NnHUfW7Yxj4upu9uW/Cw2fs3uTaWNWeB8e5oGaqMFrLC0cxiFy85O/VGS095H9ckhjVo6xr7w3zzOwh3364vTFzRBA2NxqECBFOkNvg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4220.namprd12.prod.outlook.com (2603:10b6:5:21d::7) by
 PH7PR12MB5688.namprd12.prod.outlook.com (2603:10b6:510:13c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Fri, 22 Apr
 2022 22:19:37 +0000
Received: from DM6PR12MB4220.namprd12.prod.outlook.com
 ([fe80::d585:d44d:54d6:a137]) by DM6PR12MB4220.namprd12.prod.outlook.com
 ([fe80::d585:d44d:54d6:a137%3]) with mapi id 15.20.5186.015; Fri, 22 Apr 2022
 22:19:37 +0000
Date:   Fri, 22 Apr 2022 15:19:35 -0700
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>
Subject: Re: [PATCH net-next v1 09/17] net/mlx5: Simplify HW context
 interfaces by using SA entry
Message-ID: <20220422221935.xf5yvx5i3yt55qho@sx1>
References: <cover.1650363043.git.leonro@nvidia.com>
 <3ad7b80c6f58d938550dd3259c5eaaecd8833af4.1650363043.git.leonro@nvidia.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <3ad7b80c6f58d938550dd3259c5eaaecd8833af4.1650363043.git.leonro@nvidia.com>
X-ClientProxiedBy: BYAPR05CA0021.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::34) To DM6PR12MB4220.namprd12.prod.outlook.com
 (2603:10b6:5:21d::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 62853977-51d5-47d2-c408-08da24ae300c
X-MS-TrafficTypeDiagnostic: PH7PR12MB5688:EE_
X-Microsoft-Antispam-PRVS: <PH7PR12MB5688E6D51CF264E3CB29B991B3F79@PH7PR12MB5688.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7ymEn/F9Ri7I05amZ7JzzNKHrZEyFTRdf/I7XJhBlSUB35RyO1jNZCIy5E89o+HPDug8+3KJWOfJHDvDjl0a9vAJaGHa9kAlvjQ/heSN+BHByn0l3/lZjdFmJfpv2pus1gF/bvMAh9GJMv0e2kD41KTBTMIlcx9HiQVzkX5WnNL5SLssj9EXBlAtyOypPQGKm8ja03UA0f1VWGWwuv0cGmWmlDQ0XIgEl/tjNYdSITBIuupHEYOqXJgzHMOc7MO/Sxtpl1sl1W+5cFKCLFk12zZ3SuRnB1F/iqwgF6Ex1iD2KV0tPQyO4VYFGVSBlEaewe6c4RpRvtlTZWywk81qhErkeILtrjnWxOM2opgkb9aPn8O0yniezybKeI//8H92p2LOxn81FylzF16duuleCkUn/0DE34J6jSt94FpopgONDBaBdfljvHs5Dm412/FnB5W+x47Z1hE71CGPhMhNjgKcNWJPlnW0tfSUj8XpEivwSvIb7i/UAjwYQt3Tqp25EoXi210pY9hoCVJOJry/XSatHLlnwcYhHXx0pvJMI78ZTDAdmyg1Xsut9emU693bM3zdR1VCF1LmVS0IAFRXXHWT91wtnHsdEzLHLyfWbyPVaCyt7wDMZrLI9UTKR+kdJOOXScSffA8dC4FcdHTrRg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4220.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(9686003)(6512007)(30864003)(66476007)(54906003)(6506007)(1076003)(186003)(107886003)(38100700002)(6916009)(83380400001)(86362001)(8676002)(2906002)(4326008)(66946007)(33716001)(8936002)(6486002)(5660300002)(66556008)(508600001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fNQ8UpFfkVLXCIMeXjZaLcprYFPWH1U3rQUxpJDP0uQ06eu7PHrFG6/waAsu?=
 =?us-ascii?Q?Z9uy39Z3tsTMCmMz/bhwAZUKfxCBA8POQJaNa27XhMI7lnwfpecA9C2BojSq?=
 =?us-ascii?Q?4BZi7aJSpmxh95AOauaii/5Op1TWSgv062YK/jHZClAfOBH7cUqfYudObB+x?=
 =?us-ascii?Q?KI+mEew3XJlUPmqtecw41bc5Ez2S/EqRtfaJZWBUTp2fqOlpiy6wdbkCGgum?=
 =?us-ascii?Q?U8gYgKDnqIWJexW87JSURtGfdvB6j3CE9jpVf/yAhNOaXfeSnGyufpBIZeJT?=
 =?us-ascii?Q?8mFQefG0656T0LGEe4+HS+3s975d60NSfaM4PuLUo1Et6/xZQKuv72leypMQ?=
 =?us-ascii?Q?jY863tH5L3j7BZ7tyZ5wCw1OgNkRFH7zAdLpLAT+1Luq2xNfv/h/6rmQfnUh?=
 =?us-ascii?Q?K2C4SIBhWI6N1YLbN90IOMDfEwDjCzk61KH80jNaSPh+Ati1jJ+Gsq2OaLb1?=
 =?us-ascii?Q?mtZPqD7DJarotACJHplX1gUhArbo8UCgZXEC5xUmgLluj/4IdsjwPAWZdgiy?=
 =?us-ascii?Q?WlpCUIX6Euw8DpgiisLxnNGdmq2TjSFA0GgGQxGUNXiA7BRGMnxr+T6hK6LG?=
 =?us-ascii?Q?aGedjyh8ys18TXUI0Kvgzv9yY5uD70bSz+Fr0VyY5rr2Ph3NpXeqN5Kt9wNV?=
 =?us-ascii?Q?Wi/1satPBwljR12+NXM1nh2WNICO4Ba8Si0IWXZDi6YKjzoxfMr2XR0DOp2z?=
 =?us-ascii?Q?H1tyQ5f4ZSqUrGAxkl2Zvhl6IRNCWUeOtHOaABmH+oc8mxwOD0bKeBXzKt8h?=
 =?us-ascii?Q?iGuozApjscIpw9bwpTdn2mkNhImRzsK792eS8pGUojxpUpyUmwQC7DPCDahW?=
 =?us-ascii?Q?7wH7ediWDOd+iYBZKgaefuOJPxFcS6JbRGugqrgKaF+Ro2J7e43u7isQAb51?=
 =?us-ascii?Q?28B0g0xY8ZofxRRYsnU4hhpddVz7aShChpahoqoi5JML4bUfiwuxmALe6Hra?=
 =?us-ascii?Q?mBTzgrE8x+9esDYjqQR8l2UcFETDGR40z6BaQkztLBrwCN97VALJ6i0epZOP?=
 =?us-ascii?Q?OfLN6OGoyH/B3u4GQE2j9t6IjJb+pRiRYZ/FlUzeI92n6R5lMQ2pr3VovRLB?=
 =?us-ascii?Q?W3nJNRdwxvZl6ZPAdmZmclle9pc0WasxPmI8AlJLEoI70JHg2Uii/Iwe9LJ/?=
 =?us-ascii?Q?VnC10Hpq+i+yGPH4SzdLQV4Vc4WwSJMkzsqdZ8aNsLXfyUNCKpCMD1aK7zhK?=
 =?us-ascii?Q?yOe/0K0nzHe+3DrMh2PjXrmSAC9XOri4VJtYDFcOoDe2jtSABTi1TgnwkczB?=
 =?us-ascii?Q?iNxBJcmb/IW8PGlguA1nXlBIW32936DzKKojieWRmXcWOYcDy8bhWARl9zzY?=
 =?us-ascii?Q?ZUo9RkG8TG/qGp8eAfCPGXnRKiGqyCUn+3tDFmdJA0muKUpiBBJJAyxGk/FC?=
 =?us-ascii?Q?oF4AIyf9lZ6AusJwTh/sE/D3dkFpyL7ANkwECCkVrwnE96lHE9dH6ChfEux1?=
 =?us-ascii?Q?C8dxF6DxSRa5fqoHLUHIpXVlA5FcC3t04fARAxTg4pfk+4Cvxxwy9t3K9vbp?=
 =?us-ascii?Q?PB7kOlXWZP+lR0X7ly+Bx305aDiNW3vUMRCOwMSWDTxhWhS3JAF4IYa44Xpj?=
 =?us-ascii?Q?y4uhDjllHzZtDSPdF747Wt7MI8svQPgU6OpQHomTz7EvMh6I1tTLb3JL+UBi?=
 =?us-ascii?Q?eX458m1RQ4hQuyWMnbpJuFlAEtXRZT9zK0U/eZTjyN8HFzffu6NxSq5NI3W4?=
 =?us-ascii?Q?qrsKNDyiwn/SPHtRoUg01wd4KhZYp+ex45dhZnu0mjO2mMxz9hB7cmhmalqW?=
 =?us-ascii?Q?PmUnGrunnQndwuLWUt+K+sw4j7CfKj4=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62853977-51d5-47d2-c408-08da24ae300c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4220.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2022 22:19:37.7429
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yeoyHvhiBQopcJRIFguKZIrqV4IUs10bYDui8O4RyBURTNaim0SDjJAI+oxvIzr90cr0Fw97fhZ51Kx/GZynhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5688
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19 Apr 13:13, Leon Romanovsky wrote:
>From: Leon Romanovsky <leonro@nvidia.com>
>
>SA context logic used multiple structures to store same data
>over and over. By simplifying the SA context interfaces, we
>can remove extra structs.
>
>Reviewed-by: Raed Salem <raeds@nvidia.com>
>Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
>---
> .../mellanox/mlx5/core/en_accel/ipsec.c       |  50 ++---
> .../mellanox/mlx5/core/en_accel/ipsec.h       |  27 ++-
> .../mlx5/core/en_accel/ipsec_offload.c        | 182 ++++--------------
> 3 files changed, 62 insertions(+), 197 deletions(-)
>
>diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
>index 0daf9350471f..537311a74bfb 100644
>--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
>+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
>@@ -63,9 +63,9 @@ struct xfrm_state *mlx5e_ipsec_sadb_rx_lookup(struct mlx5e_ipsec *ipsec,
> 	return ret;
> }
>
>-static int  mlx5e_ipsec_sadb_rx_add(struct mlx5e_ipsec_sa_entry *sa_entry,
>-				    unsigned int handle)
>+static int mlx5e_ipsec_sadb_rx_add(struct mlx5e_ipsec_sa_entry *sa_entry)
> {
>+	unsigned int handle = sa_entry->ipsec_obj_id;
> 	struct mlx5e_ipsec *ipsec = sa_entry->ipsec;
> 	struct mlx5e_ipsec_sa_entry *_sa_entry;
> 	unsigned long flags;
>@@ -277,16 +277,14 @@ static void _update_xfrm_state(struct work_struct *work)
> 	struct mlx5e_ipsec_sa_entry *sa_entry = container_of(
> 		modify_work, struct mlx5e_ipsec_sa_entry, modify_work);
>
>-	mlx5_accel_esp_modify_xfrm(sa_entry->xfrm, &modify_work->attrs);
>+	mlx5_accel_esp_modify_xfrm(sa_entry, &modify_work->attrs);
> }
>
> static int mlx5e_xfrm_add_state(struct xfrm_state *x)
> {
> 	struct mlx5e_ipsec_sa_entry *sa_entry = NULL;
> 	struct net_device *netdev = x->xso.real_dev;
>-	struct mlx5_accel_esp_xfrm_attrs attrs;
> 	struct mlx5e_priv *priv;
>-	unsigned int sa_handle;
> 	int err;
>
> 	priv = netdev_priv(netdev);
>@@ -309,33 +307,20 @@ static int mlx5e_xfrm_add_state(struct xfrm_state *x)
> 	/* check esn */
> 	mlx5e_ipsec_update_esn_state(sa_entry);
>
>-	/* create xfrm */
>-	mlx5e_ipsec_build_accel_xfrm_attrs(sa_entry, &attrs);
>-	sa_entry->xfrm = mlx5_accel_esp_create_xfrm(priv->mdev, &attrs);
>-	if (IS_ERR(sa_entry->xfrm)) {
>-		err = PTR_ERR(sa_entry->xfrm);
>-		goto err_sa_entry;
>-	}
>-
>+	mlx5e_ipsec_build_accel_xfrm_attrs(sa_entry, &sa_entry->attrs);
> 	/* create hw context */
>-	sa_entry->hw_context =
>-			mlx5_accel_esp_create_hw_context(priv->mdev,
>-							 sa_entry->xfrm,
>-							 &sa_handle);
>-	if (IS_ERR(sa_entry->hw_context)) {
>-		err = PTR_ERR(sa_entry->hw_context);
>+	err = mlx5_ipsec_create_sa_ctx(sa_entry);
>+	if (err)
> 		goto err_xfrm;
>-	}
>
>-	sa_entry->ipsec_obj_id = sa_handle;
>-	err = mlx5e_accel_ipsec_fs_add_rule(priv, &sa_entry->xfrm->attrs,
>+	err = mlx5e_accel_ipsec_fs_add_rule(priv, &sa_entry->attrs,
> 					    sa_entry->ipsec_obj_id,
> 					    &sa_entry->ipsec_rule);
> 	if (err)
> 		goto err_hw_ctx;
>
> 	if (x->xso.flags & XFRM_OFFLOAD_INBOUND) {
>-		err = mlx5e_ipsec_sadb_rx_add(sa_entry, sa_handle);
>+		err = mlx5e_ipsec_sadb_rx_add(sa_entry);
> 		if (err)
> 			goto err_add_rule;
> 	} else {
>@@ -348,15 +333,12 @@ static int mlx5e_xfrm_add_state(struct xfrm_state *x)
> 	goto out;
>
> err_add_rule:
>-	mlx5e_accel_ipsec_fs_del_rule(priv, &sa_entry->xfrm->attrs,
>+	mlx5e_accel_ipsec_fs_del_rule(priv, &sa_entry->attrs,
> 				      &sa_entry->ipsec_rule);
> err_hw_ctx:
>-	mlx5_accel_esp_free_hw_context(priv->mdev, sa_entry->hw_context);
>+	mlx5_ipsec_free_sa_ctx(sa_entry);
> err_xfrm:
>-	mlx5_accel_esp_destroy_xfrm(sa_entry->xfrm);
>-err_sa_entry:
> 	kfree(sa_entry);
>-
> out:
> 	return err;
> }
>@@ -374,14 +356,10 @@ static void mlx5e_xfrm_free_state(struct xfrm_state *x)
> 	struct mlx5e_ipsec_sa_entry *sa_entry = to_ipsec_sa_entry(x);
> 	struct mlx5e_priv *priv = netdev_priv(x->xso.dev);
>
>-	if (sa_entry->hw_context) {
>-		cancel_work_sync(&sa_entry->modify_work.work);
>-		mlx5e_accel_ipsec_fs_del_rule(priv, &sa_entry->xfrm->attrs,
>-					      &sa_entry->ipsec_rule);
>-		mlx5_accel_esp_free_hw_context(sa_entry->xfrm->mdev, sa_entry->hw_context);
>-		mlx5_accel_esp_destroy_xfrm(sa_entry->xfrm);
>-	}
>-
>+	cancel_work_sync(&sa_entry->modify_work.work);
>+	mlx5e_accel_ipsec_fs_del_rule(priv, &sa_entry->attrs,
>+				      &sa_entry->ipsec_rule);
>+	mlx5_ipsec_free_sa_ctx(sa_entry);
> 	kfree(sa_entry);
> }
>
>diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
>index b438b0358c36..cdcb95f90623 100644
>--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
>+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
>@@ -102,11 +102,6 @@ struct mlx5_accel_esp_xfrm_attrs {
> 	u8 is_ipv6;
> };
>
>-struct mlx5_accel_esp_xfrm {
>-	struct mlx5_core_dev  *mdev;
>-	struct mlx5_accel_esp_xfrm_attrs attrs;
>-};
>-
> enum mlx5_accel_ipsec_cap {
> 	MLX5_ACCEL_IPSEC_CAP_DEVICE		= 1 << 0,
> 	MLX5_ACCEL_IPSEC_CAP_ESP		= 1 << 1,
>@@ -162,11 +157,11 @@ struct mlx5e_ipsec_sa_entry {
> 	unsigned int handle; /* Handle in SADB_RX */
> 	struct xfrm_state *x;
> 	struct mlx5e_ipsec *ipsec;
>-	struct mlx5_accel_esp_xfrm *xfrm;
>-	void *hw_context;
>+	struct mlx5_accel_esp_xfrm_attrs attrs;
> 	void (*set_iv_op)(struct sk_buff *skb, struct xfrm_state *x,
> 			  struct xfrm_offload *xo);
> 	u32 ipsec_obj_id;
>+	u32 enc_key_id;
> 	struct mlx5e_ipsec_rule ipsec_rule;
> 	struct mlx5e_ipsec_modify_state_work modify_work;
> };
>@@ -188,19 +183,19 @@ void mlx5e_accel_ipsec_fs_del_rule(struct mlx5e_priv *priv,
> 				   struct mlx5_accel_esp_xfrm_attrs *attrs,
> 				   struct mlx5e_ipsec_rule *ipsec_rule);
>
>-void *mlx5_accel_esp_create_hw_context(struct mlx5_core_dev *mdev,
>-				       struct mlx5_accel_esp_xfrm *xfrm,
>-				       u32 *sa_handle);
>-void mlx5_accel_esp_free_hw_context(struct mlx5_core_dev *mdev, void *context);
>+int mlx5_ipsec_create_sa_ctx(struct mlx5e_ipsec_sa_entry *sa_entry);
>+void mlx5_ipsec_free_sa_ctx(struct mlx5e_ipsec_sa_entry *sa_entry);
>
> u32 mlx5_ipsec_device_caps(struct mlx5_core_dev *mdev);
>
>-struct mlx5_accel_esp_xfrm *
>-mlx5_accel_esp_create_xfrm(struct mlx5_core_dev *mdev,
>-			   const struct mlx5_accel_esp_xfrm_attrs *attrs);
>-void mlx5_accel_esp_destroy_xfrm(struct mlx5_accel_esp_xfrm *xfrm);
>-void mlx5_accel_esp_modify_xfrm(struct mlx5_accel_esp_xfrm *xfrm,
>+void mlx5_accel_esp_modify_xfrm(struct mlx5e_ipsec_sa_entry *sa_entry,
> 				const struct mlx5_accel_esp_xfrm_attrs *attrs);
>+
>+static inline struct mlx5_core_dev *
>+mlx5e_ipsec_sa2dev(struct mlx5e_ipsec_sa_entry *sa_entry)
>+{
>+	return sa_entry->ipsec->mdev;
>+}
> #else
> static inline int mlx5e_ipsec_init(struct mlx5e_priv *priv)
> {
>diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
>index a7bd31d10bd4..817747d5229e 100644
>--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
>+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
>@@ -5,21 +5,6 @@
> #include "ipsec.h"
> #include "lib/mlx5.h"
>
>-struct mlx5_ipsec_sa_ctx {
>-	struct rhash_head hash;
>-	u32 enc_key_id;
>-	u32 ipsec_obj_id;
>-	/* hw ctx */
>-	struct mlx5_core_dev *dev;
>-	struct mlx5_ipsec_esp_xfrm *mxfrm;
>-};
>-
>-struct mlx5_ipsec_esp_xfrm {
>-	/* reference counter of SA ctx */
>-	struct mlx5_ipsec_sa_ctx *sa_ctx;
>-	struct mlx5_accel_esp_xfrm accel_xfrm;
>-};
>-
> u32 mlx5_ipsec_device_caps(struct mlx5_core_dev *mdev)
> {
> 	u32 caps;
>@@ -61,43 +46,11 @@ u32 mlx5_ipsec_device_caps(struct mlx5_core_dev *mdev)
> }
> EXPORT_SYMBOL_GPL(mlx5_ipsec_device_caps);
>
>-struct mlx5_accel_esp_xfrm *
>-mlx5_accel_esp_create_xfrm(struct mlx5_core_dev *mdev,
>-			   const struct mlx5_accel_esp_xfrm_attrs *attrs)
>-{
>-	struct mlx5_ipsec_esp_xfrm *mxfrm;
>-
>-	mxfrm = kzalloc(sizeof(*mxfrm), GFP_KERNEL);
>-	if (!mxfrm)
>-		return ERR_PTR(-ENOMEM);
>-
>-	memcpy(&mxfrm->accel_xfrm.attrs, attrs,
>-	       sizeof(mxfrm->accel_xfrm.attrs));
>-
>-	mxfrm->accel_xfrm.mdev = mdev;
>-	return &mxfrm->accel_xfrm;
>-}
>-
>-void mlx5_accel_esp_destroy_xfrm(struct mlx5_accel_esp_xfrm *xfrm)
>+static int mlx5_create_ipsec_obj(struct mlx5e_ipsec_sa_entry *sa_entry)
> {
>-	struct mlx5_ipsec_esp_xfrm *mxfrm = container_of(xfrm, struct mlx5_ipsec_esp_xfrm,
>-							 accel_xfrm);
>-
>-	kfree(mxfrm);
>-}
>-
>-struct mlx5_ipsec_obj_attrs {
>-	const struct aes_gcm_keymat *aes_gcm;
>-	u32 accel_flags;
>-	u32 esn_msb;
>-	u32 enc_key_id;
>-};
>-
>-static int mlx5_create_ipsec_obj(struct mlx5_core_dev *mdev,
>-				 struct mlx5_ipsec_obj_attrs *attrs,
>-				 u32 *ipsec_id)

I don't see the point of this change, the function used to receive two
primitives, now it receives a god object, just to grab the two primitives,
this breaks the bottom up design, and contaminates the code with the
sa_entry container, that only should be visible by high-level ipsec module and
the SA DB, all service and low level functions should remain as
primitive and simple as possible to avoid future abuse and reduce the scope
and visibility of god objects. The effect of this change is more severe in
the next patch.

Even within the same file, i still recommend a monotonic bottom up
design and keep the complex objects usage to as few hight level functions
as possible.

>-{
>-	const struct aes_gcm_keymat *aes_gcm = attrs->aes_gcm;
>+	struct mlx5_accel_esp_xfrm_attrs *attrs = &sa_entry->attrs;
>+	struct mlx5_core_dev *mdev = mlx5e_ipsec_sa2dev(sa_entry);
>+	struct aes_gcm_keymat *aes_gcm = &attrs->keymat.aes_gcm;
> 	u32 out[MLX5_ST_SZ_DW(general_obj_out_cmd_hdr)];
> 	u32 in[MLX5_ST_SZ_DW(create_ipsec_obj_in)] = {};
> 	void *obj, *salt_p, *salt_iv_p;
>@@ -128,14 +81,14 @@ static int mlx5_create_ipsec_obj(struct mlx5_core_dev *mdev,
> 	salt_iv_p = MLX5_ADDR_OF(ipsec_obj, obj, implicit_iv);
> 	memcpy(salt_iv_p, &aes_gcm->seq_iv, sizeof(aes_gcm->seq_iv));
> 	/* esn */
>-	if (attrs->accel_flags & MLX5_ACCEL_ESP_FLAGS_ESN_TRIGGERED) {
>+	if (attrs->flags & MLX5_ACCEL_ESP_FLAGS_ESN_TRIGGERED) {
> 		MLX5_SET(ipsec_obj, obj, esn_en, 1);
>-		MLX5_SET(ipsec_obj, obj, esn_msb, attrs->esn_msb);
>-		if (attrs->accel_flags & MLX5_ACCEL_ESP_FLAGS_ESN_STATE_OVERLAP)
>+		MLX5_SET(ipsec_obj, obj, esn_msb, attrs->esn);
>+		if (attrs->flags & MLX5_ACCEL_ESP_FLAGS_ESN_STATE_OVERLAP)
> 			MLX5_SET(ipsec_obj, obj, esn_overlap, 1);
> 	}
>
>-	MLX5_SET(ipsec_obj, obj, dekn, attrs->enc_key_id);
>+	MLX5_SET(ipsec_obj, obj, dekn, sa_entry->enc_key_id);
>
> 	/* general object fields set */
> 	MLX5_SET(general_obj_in_cmd_hdr, in, opcode,
>@@ -145,13 +98,15 @@ static int mlx5_create_ipsec_obj(struct mlx5_core_dev *mdev,
>
> 	err = mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
> 	if (!err)
>-		*ipsec_id = MLX5_GET(general_obj_out_cmd_hdr, out, obj_id);
>+		sa_entry->ipsec_obj_id =
>+			MLX5_GET(general_obj_out_cmd_hdr, out, obj_id);
>
> 	return err;
> }
>
>-static void mlx5_destroy_ipsec_obj(struct mlx5_core_dev *mdev, u32 ipsec_id)
>+static void mlx5_destroy_ipsec_obj(struct mlx5e_ipsec_sa_entry *sa_entry)
> {
>+	struct mlx5_core_dev *mdev = mlx5e_ipsec_sa2dev(sa_entry);
> 	u32 in[MLX5_ST_SZ_DW(general_obj_in_cmd_hdr)] = {};
> 	u32 out[MLX5_ST_SZ_DW(general_obj_out_cmd_hdr)];
>
>@@ -159,79 +114,52 @@ static void mlx5_destroy_ipsec_obj(struct mlx5_core_dev *mdev, u32 ipsec_id)
> 		 MLX5_CMD_OP_DESTROY_GENERAL_OBJECT);
> 	MLX5_SET(general_obj_in_cmd_hdr, in, obj_type,
> 		 MLX5_GENERAL_OBJECT_TYPES_IPSEC);
>-	MLX5_SET(general_obj_in_cmd_hdr, in, obj_id, ipsec_id);
>+	MLX5_SET(general_obj_in_cmd_hdr, in, obj_id, sa_entry->ipsec_obj_id);
>
> 	mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
> }
>
>-static void *mlx5_ipsec_offload_create_sa_ctx(struct mlx5_core_dev *mdev,
>-					      struct mlx5_accel_esp_xfrm *accel_xfrm,
>-					      const __be32 saddr[4], const __be32 daddr[4],
>-					      const __be32 spi, bool is_ipv6, u32 *hw_handle)
>+int mlx5_ipsec_create_sa_ctx(struct mlx5e_ipsec_sa_entry *sa_entry)
> {
>-	struct mlx5_accel_esp_xfrm_attrs *xfrm_attrs = &accel_xfrm->attrs;
>-	struct aes_gcm_keymat *aes_gcm = &xfrm_attrs->keymat.aes_gcm;
>-	struct mlx5_ipsec_obj_attrs ipsec_attrs = {};
>-	struct mlx5_ipsec_esp_xfrm *mxfrm;
>-	struct mlx5_ipsec_sa_ctx *sa_ctx;
>+	struct aes_gcm_keymat *aes_gcm = &sa_entry->attrs.keymat.aes_gcm;
>+	struct mlx5_core_dev *mdev = mlx5e_ipsec_sa2dev(sa_entry);
> 	int err;
>
>-	/* alloc SA context */
>-	sa_ctx = kzalloc(sizeof(*sa_ctx), GFP_KERNEL);
>-	if (!sa_ctx)
>-		return ERR_PTR(-ENOMEM);
>-
>-	sa_ctx->dev = mdev;
>-
>-	mxfrm = container_of(accel_xfrm, struct mlx5_ipsec_esp_xfrm, accel_xfrm);
>-	sa_ctx->mxfrm = mxfrm;
>-
> 	/* key */
> 	err = mlx5_create_encryption_key(mdev, aes_gcm->aes_key,
> 					 aes_gcm->key_len / BITS_PER_BYTE,
> 					 MLX5_ACCEL_OBJ_IPSEC_KEY,
>-					 &sa_ctx->enc_key_id);
>+					 &sa_entry->enc_key_id);
> 	if (err) {
> 		mlx5_core_dbg(mdev, "Failed to create encryption key (err = %d)\n", err);
>-		goto err_sa_ctx;
>+		return err;
> 	}
>
>-	ipsec_attrs.aes_gcm = aes_gcm;
>-	ipsec_attrs.accel_flags = accel_xfrm->attrs.flags;
>-	ipsec_attrs.esn_msb = accel_xfrm->attrs.esn;
>-	ipsec_attrs.enc_key_id = sa_ctx->enc_key_id;
>-	err = mlx5_create_ipsec_obj(mdev, &ipsec_attrs,
>-				    &sa_ctx->ipsec_obj_id);
>+	err = mlx5_create_ipsec_obj(sa_entry);
> 	if (err) {
> 		mlx5_core_dbg(mdev, "Failed to create IPsec object (err = %d)\n", err);
> 		goto err_enc_key;
> 	}
>
>-	*hw_handle = sa_ctx->ipsec_obj_id;
>-	mxfrm->sa_ctx = sa_ctx;
>-
>-	return sa_ctx;
>+	return 0;
>
> err_enc_key:
>-	mlx5_destroy_encryption_key(mdev, sa_ctx->enc_key_id);
>-err_sa_ctx:
>-	kfree(sa_ctx);
>-	return ERR_PTR(err);
>+	mlx5_destroy_encryption_key(mdev, sa_entry->enc_key_id);
>+	return err;
> }
>
>-static void mlx5_ipsec_offload_delete_sa_ctx(void *context)
>+void mlx5_ipsec_free_sa_ctx(struct mlx5e_ipsec_sa_entry *sa_entry)
> {
>-	struct mlx5_ipsec_sa_ctx *sa_ctx = (struct mlx5_ipsec_sa_ctx *)context;
>+	struct mlx5_core_dev *mdev = mlx5e_ipsec_sa2dev(sa_entry);
>
>-	mlx5_destroy_ipsec_obj(sa_ctx->dev, sa_ctx->ipsec_obj_id);
>-	mlx5_destroy_encryption_key(sa_ctx->dev, sa_ctx->enc_key_id);
>-	kfree(sa_ctx);
>+	mlx5_destroy_ipsec_obj(sa_entry);
>+	mlx5_destroy_encryption_key(mdev, sa_entry->enc_key_id);
> }
>
>-static int mlx5_modify_ipsec_obj(struct mlx5_core_dev *mdev,
>-				 struct mlx5_ipsec_obj_attrs *attrs,
>-				 u32 ipsec_id)
>+static int mlx5_modify_ipsec_obj(struct mlx5e_ipsec_sa_entry *sa_entry,
>+				 const struct mlx5_accel_esp_xfrm_attrs *attrs)
> {
>+	struct mlx5_core_dev *mdev = mlx5e_ipsec_sa2dev(sa_entry);
> 	u32 in[MLX5_ST_SZ_DW(modify_ipsec_obj_in)] = {};
> 	u32 out[MLX5_ST_SZ_DW(query_ipsec_obj_out)];
> 	u64 modify_field_select = 0;
>@@ -239,7 +167,7 @@ static int mlx5_modify_ipsec_obj(struct mlx5_core_dev *mdev,
> 	void *obj;
> 	int err;
>
>-	if (!(attrs->accel_flags & MLX5_ACCEL_ESP_FLAGS_ESN_TRIGGERED))
>+	if (!(attrs->flags & MLX5_ACCEL_ESP_FLAGS_ESN_TRIGGERED))
> 		return 0;
>
> 	general_obj_types = MLX5_CAP_GEN_64(mdev, general_obj_types);
>@@ -249,11 +177,11 @@ static int mlx5_modify_ipsec_obj(struct mlx5_core_dev *mdev,
> 	/* general object fields set */
> 	MLX5_SET(general_obj_in_cmd_hdr, in, opcode, MLX5_CMD_OP_QUERY_GENERAL_OBJECT);
> 	MLX5_SET(general_obj_in_cmd_hdr, in, obj_type, MLX5_GENERAL_OBJECT_TYPES_IPSEC);
>-	MLX5_SET(general_obj_in_cmd_hdr, in, obj_id, ipsec_id);
>+	MLX5_SET(general_obj_in_cmd_hdr, in, obj_id, sa_entry->ipsec_obj_id);
> 	err = mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
> 	if (err) {
> 		mlx5_core_err(mdev, "Query IPsec object failed (Object id %d), err = %d\n",
>-			      ipsec_id, err);
>+			      sa_entry->ipsec_obj_id, err);
> 		return err;
> 	}
>
>@@ -266,8 +194,8 @@ static int mlx5_modify_ipsec_obj(struct mlx5_core_dev *mdev,
> 		return -EOPNOTSUPP;
>
> 	obj = MLX5_ADDR_OF(modify_ipsec_obj_in, in, ipsec_object);
>-	MLX5_SET(ipsec_obj, obj, esn_msb, attrs->esn_msb);
>-	if (attrs->accel_flags & MLX5_ACCEL_ESP_FLAGS_ESN_STATE_OVERLAP)
>+	MLX5_SET(ipsec_obj, obj, esn_msb, attrs->esn);
>+	if (attrs->flags & MLX5_ACCEL_ESP_FLAGS_ESN_STATE_OVERLAP)
> 		MLX5_SET(ipsec_obj, obj, esn_overlap, 1);
>
> 	/* general object fields set */
>@@ -276,50 +204,14 @@ static int mlx5_modify_ipsec_obj(struct mlx5_core_dev *mdev,
> 	return mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
> }
>
>-void mlx5_accel_esp_modify_xfrm(struct mlx5_accel_esp_xfrm *xfrm,
>+void mlx5_accel_esp_modify_xfrm(struct mlx5e_ipsec_sa_entry *sa_entry,
> 				const struct mlx5_accel_esp_xfrm_attrs *attrs)
> {
>-	struct mlx5_ipsec_obj_attrs ipsec_attrs = {};
>-	struct mlx5_core_dev *mdev = xfrm->mdev;
>-	struct mlx5_ipsec_esp_xfrm *mxfrm;
> 	int err;
>
>-	mxfrm = container_of(xfrm, struct mlx5_ipsec_esp_xfrm, accel_xfrm);
>-
>-	/* need to add find and replace in ipsec_rhash_sa the sa_ctx */
>-	/* modify device with new hw_sa */
>-	ipsec_attrs.accel_flags = attrs->flags;
>-	ipsec_attrs.esn_msb = attrs->esn;
>-	err = mlx5_modify_ipsec_obj(mdev,
>-				    &ipsec_attrs,
>-				    mxfrm->sa_ctx->ipsec_obj_id);
>-
>+	err = mlx5_modify_ipsec_obj(sa_entry, attrs);
> 	if (err)
> 		return;
>
>-	memcpy(&xfrm->attrs, attrs, sizeof(xfrm->attrs));
>-}
>-
>-void *mlx5_accel_esp_create_hw_context(struct mlx5_core_dev *mdev,
>-				       struct mlx5_accel_esp_xfrm *xfrm,
>-				       u32 *sa_handle)
>-{
>-	__be32 saddr[4] = {}, daddr[4] = {};
>-
>-	if (!xfrm->attrs.is_ipv6) {
>-		saddr[3] = xfrm->attrs.saddr.a4;
>-		daddr[3] = xfrm->attrs.daddr.a4;
>-	} else {
>-		memcpy(saddr, xfrm->attrs.saddr.a6, sizeof(saddr));
>-		memcpy(daddr, xfrm->attrs.daddr.a6, sizeof(daddr));
>-	}
>-
>-	return mlx5_ipsec_offload_create_sa_ctx(mdev, xfrm, saddr, daddr,
>-						xfrm->attrs.spi,
>-						xfrm->attrs.is_ipv6, sa_handle);
>-}
>-
>-void mlx5_accel_esp_free_hw_context(struct mlx5_core_dev *mdev, void *context)
>-{
>-	mlx5_ipsec_offload_delete_sa_ctx(context);
>+	memcpy(&sa_entry->attrs, attrs, sizeof(sa_entry->attrs));
> }
>-- 
>2.35.1
>
