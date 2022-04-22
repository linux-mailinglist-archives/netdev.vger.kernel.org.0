Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC68D50C2AE
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 01:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233996AbiDVXJk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 19:09:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233556AbiDVXJG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 19:09:06 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2070.outbound.protection.outlook.com [40.107.243.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AC68939A4
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 15:43:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kR3+j+YdrgJ/5U4saIuo0X9csBLOmN2U1iAyGtUG71EPnmn1N0bGU0+8HaMaQNt69dFY6i3svy0HEjLLz/kKwqXbWKtITGKbDSvH4p+AxTdQrAbww+OjvGUKQse8rh7NgbwuqlGVIDYL2e449T+Rr+9uB6OF9CC21JGQBdl6QlcPRdFFv3iL5yaIvN5AdXo8tI0A32RAbA5iqGPzY29AtTXjWp9xl0ngt3OIKBOPMIGQRH9UfZZbUCDPQstriLf8xgBBAfjRwOW99HxyI1iTMnI3C+12U92QagrFtsBPqYOvo9GYtOe+h6NVPe5kwvgCdQi6eKkk2coO+SAzTfRaPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PfKItXkNiBnKIXQtc/Tpzjuk7lQdzk7Vd5ZRRdtAK3c=;
 b=ffP9hP637dwsoWZs9ovATnQc3ekLX8PxRZRTmgnTHQ9MAWFcKX+HBiUOlhBwnHMJCaNkvXyUUvakMEgFGGD0TDxvGTMnOyyqyX0//3OtAha4kX4T2SvZGHIkkOKNdNWIGVeFsAgnw3102PHVeTu1TSZuKYm0KdpTr8D+dIY8eKKQO3QLUKK/jMCryIjbR+0I/Z5lH4M7wA6DWufsn5qZ/PUAG8nj8VaysMWsEPjz3sMeNzMrc9VHWGIMDY+IAW9C8XbdHA5wLpDSCwq63spE9bs/JkjL9TP2qKWkmg0wa0C2BrSnztl47TnkHT9anI602WHDHMUbJF5PM+X+KM46qQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PfKItXkNiBnKIXQtc/Tpzjuk7lQdzk7Vd5ZRRdtAK3c=;
 b=Dtb3Z9ES7ccdPqlDH5bJzK4xMs3f2ucUc7ZRNZdkDudsmlPUhO0NEK4WT/+x7dFUyeYoildifsPwPyb2D1iI7ayHtw5O/c2s0Q7OP8asKYMModoe54/IhCF7zwykXh1KpoCo4IKOrFSASGD6cvAiryz5SpbIO72+hhX0syvFWkYAbOsm2O1oyc2VA1tdTGzF+CyujTSBZ8HP347FM6KGc5bApSvXtmZLPz6PisbpjwwL68jeFJoTZ6hkcA3KTADCfjsyo26H5FGkXWhqCH1SJMvIu6o2OT0PMKn/3krOuL6SJ0wUvqcn/IRCnOTrJtqX03DC+G8/EGTWlV47Jt7OgA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4220.namprd12.prod.outlook.com (2603:10b6:5:21d::7) by
 MN2PR12MB4304.namprd12.prod.outlook.com (2603:10b6:208:1d0::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Fri, 22 Apr
 2022 22:42:59 +0000
Received: from DM6PR12MB4220.namprd12.prod.outlook.com
 ([fe80::d585:d44d:54d6:a137]) by DM6PR12MB4220.namprd12.prod.outlook.com
 ([fe80::d585:d44d:54d6:a137%3]) with mapi id 15.20.5186.015; Fri, 22 Apr 2022
 22:42:59 +0000
Date:   Fri, 22 Apr 2022 15:42:57 -0700
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>
Subject: Re: [PATCH net-next v1 13/17] net/mlx5: Simplify IPsec capabilities
 logic
Message-ID: <20220422224257.pa7p2uuo4qau5ezi@sx1>
References: <cover.1650363043.git.leonro@nvidia.com>
 <f47d197be948ce44772baf3276a1a855ad2f210a.1650363043.git.leonro@nvidia.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <f47d197be948ce44772baf3276a1a855ad2f210a.1650363043.git.leonro@nvidia.com>
X-ClientProxiedBy: SJ0PR03CA0005.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::10) To DM6PR12MB4220.namprd12.prod.outlook.com
 (2603:10b6:5:21d::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b2c881fc-69af-412f-5377-08da24b17369
X-MS-TrafficTypeDiagnostic: MN2PR12MB4304:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB4304657EE4E7949D5C911CCBB3F79@MN2PR12MB4304.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: znwwPPgxmOEQthfDCLbUanQ2hZIrWR7MyGqqfGAGm4Xkr9MSYwkda+uAMTGypA8ILWRXQf+vip5CLQ7QfvNjSW0BL4eHpziR2DwDj3vTxZL2gt4bgDmL56NrD5ozcwKy5BM9atcQFQnHe2EtkupgtKz/7N6Q8vfmqfO0fnqbVcblI52Hmg2XfsB+wiMixuZCxwGhceARViDiu2YgNPpLkrHP0W5euS7+4V4WqZvASRjLmv9MNnoViFo1gkO3tiT4sSXu2QEXccbManCNIcz9xcMY3bzSaUW0zpuzbTV4HrQSDVf7zBoVsVGmv46i7Zv1bzAXyhV/Qf+6Rm9xrHBtBc4pLhI5BScr7wg/lgu/4Mm2Fc3K65qrwWBNRIClYztk9T4/u+seOfBiAli3xe8McldjX4pvg8eN4AMyOSEb6fejKzaCFn5EZrkJLezsY2IR41Nz5RhETjasx6NjS99gn30nfuMrtBJLXc1nQ+yeE+/VWhBO/oXLTzpU263OS/Pq7EdwBO4cxTTYSjYV7bjtkRlD/+MdhpZtEju+nSQVCbLVMRMdz9Gh/mL7ZvAEl7VBH11JTEC4IzHc5n6VVJ9q2ubsPBcK67gYHjqDq2WsdEFWN9+5Sx47vTlWRX4Vepw8NJbXvmzn+ne8inY55C6n0Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4220.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(107886003)(66476007)(186003)(86362001)(8676002)(1076003)(8936002)(6486002)(38100700002)(9686003)(6512007)(66556008)(4326008)(66946007)(508600001)(316002)(2906002)(83380400001)(54906003)(5660300002)(6506007)(33716001)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0ccEP4sY1djTtjZ0QK/T6i5U+HAJm2bu48pFCI8TKZ7DAtZO1MqdoiiHyjFp?=
 =?us-ascii?Q?wOr4UjVar+o0JXIUCUOnnlHmZJTWsPnHmakJ+ZgxLFv6bOHa/ojgkHBPxEUK?=
 =?us-ascii?Q?oQ5xXBP8d97LooeApwRIkJVIn0Vhgta+VCJRJFm8kb6fj5XmDtul313Us7Wh?=
 =?us-ascii?Q?FqiFVGg4UIyK1Nn8QiWq/r+95ZVhnau6hCH5KwBj8+v0RtDAw6vA5gqu0Kye?=
 =?us-ascii?Q?Dy8M6pAyLl3ghc/oKLbkyhZswMUAcnzcAB0nQ311M+k5NxB4luoc4ZhEk+0b?=
 =?us-ascii?Q?nv5QH8jigqymXpUhbfKQu1zVfZ3bVhEM+4d0OftyNzavxQRojc7bmHM6YKld?=
 =?us-ascii?Q?7KrU94TzSuPa+PgduM0k+YdDij1mMPqXaD9Fae4nNKWCsfzqTa3/CY/Ldwie?=
 =?us-ascii?Q?gx6YwFO0O8bimHe8i4aSZWhSbSMsvPnmfAeifHaAACVMcdqWbJ6KKTaF56pK?=
 =?us-ascii?Q?AXvABElIYLis/TcfXYZwOICZQw9cD0VLU0w021aWm63WgewgwmDGs3+9v9G+?=
 =?us-ascii?Q?4WrT6cYoFuMUmlVtxjvF7lxVW21n4rpyreku1p2EA6e8u+fqeMoFzJyvPX0I?=
 =?us-ascii?Q?XKf7f4Yz19tT/ImfxYy6xVbQ7I5WV1n9ZIfqa7Tawa+KugGYSSmmmdgY/P0q?=
 =?us-ascii?Q?2HIEJsi2b8RGuolIbS3F2MLEq6E7fjzcV73kIjHnfTRVrFRVQvJTRH+Nn0WC?=
 =?us-ascii?Q?0fI3+9oXwSMjzt6QDB/WyWFrwouHojV46f0MVSFDKZMf1i9FxqNa1q8OD2Dn?=
 =?us-ascii?Q?gvrekcOiyHb2T2DSKiF6MeAPMSwc8NzYTFUKpAbgULn/M3qdjmWShKhOYoy6?=
 =?us-ascii?Q?xBYoQinIe9fbo2BUqI23WV4/tfViLwRppq/3sr/KKRlDpWubmx70H0IHtw5Q?=
 =?us-ascii?Q?0ACiQGL/p3E2XRWpAUz/rMXCMqF2gV55RpSe7TjhlflkOCWBinDOLmi5gRfh?=
 =?us-ascii?Q?qmBvGYq/3mqxTAd0TF0nsuOnegesw2ZusnFT1fx+KNKIjfplqPMhkLI7wNlx?=
 =?us-ascii?Q?x4icsYx3KGAcvsq90BD/e7xafse+f+HByH3EZmSLLVuiV3YytmVPktwb0uMW?=
 =?us-ascii?Q?WOUBze4CHemazAddp38ExnyO/Q56UAyiw6kogRB9HpzMj3ghjFhxGUPgpmAd?=
 =?us-ascii?Q?uqqzL5fNBDyx4gRmNwranoPA25i0PXy8Ce86h7/X/t9sXdAhFgm2FjEJWxjj?=
 =?us-ascii?Q?Pq1CI0DOCtTqtjoOkeJsOJiHIistUbt5oh7Cz5HCYFMwQWeOX/GfMsQsDclz?=
 =?us-ascii?Q?+hbz/+WIj5yve/soK0r/X0P8xKNAbHQuPkN1k3oYagSO2Nr1NiZFlj55+lQu?=
 =?us-ascii?Q?0eqfrs8XmkmfUawnvXq04LiIAPpUq5MG7gjFMQDZ/Snszs2AEl8d7BUE12VD?=
 =?us-ascii?Q?Fm7rBdixFIxwJG5VG3LMPU5N3+HU3d6qeTT61TG0b5P953NLCYrcP6eVGNqw?=
 =?us-ascii?Q?K9WGkR4BwICv0Z+jJZpMGF9JSic1qnqw44UF0b7Y3DXpYJFWhTZyJDvfFFQx?=
 =?us-ascii?Q?ToSWNTeGhCIL+HQv6dVgS2+WjO5WOJ3OpOT8YIXUkfWS4GcRzaRj4A3Fa+d8?=
 =?us-ascii?Q?YG0runx3ZCvOXrOpEhW22CKE+JQioFrWRjte/UTqDipzweP6T2mcRr5K7G2J?=
 =?us-ascii?Q?YU/uxH0E7nMIGo7P/UzprDs7Yh9oDS/peMy2BWamIVvfpdu8qi5DtvFle+18?=
 =?us-ascii?Q?JERd1vlFk67dMq1iC4Qst393wxIrHkFPZa/EeEo/VzNXjn/TM9xstg/+fHOK?=
 =?us-ascii?Q?8ze8n9r9zmavUnNEuAdUZg8FYZTCxl0=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2c881fc-69af-412f-5377-08da24b17369
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4220.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2022 22:42:59.2256
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R13FdzBexC39jV56qFNRFXpvZrZpk7fwN0CRBdq/qbQB/evyCdEaslrT8AIUBiHggacQuZTjB5B8YVKFSDyluw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4304
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
>Reduce number of hard-coded IPsec capabilities by making sure
>that mlx5_ipsec_device_caps() sets only supported bits.
>
>As part of this change, remove _accel_ notations from the names
>and prepare the code to IPsec full offload mode.
>

Can you explain why remove __accel__ notation ?
__accel__ notation and decoupling from other common netdev features is done
for modularity purpose, en_accel directories are separated so we can
implement complex/stateful accelerations while avoid contaminating/affecting
common data-path performance sensitives flows.

I think keeping __accel__ notations is a must here for the above reasons,
unless you have a more strong reason to remove it.. 

>Reviewed-by: Raed Salem <raeds@nvidia.com>
>Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
>---
> .../mellanox/mlx5/core/en_accel/ipsec.c       | 16 ++------------
> .../mellanox/mlx5/core/en_accel/ipsec.h       |  9 +++-----
> .../mlx5/core/en_accel/ipsec_offload.c        | 22 +++++++++----------
> 3 files changed, 16 insertions(+), 31 deletions(-)
>
>diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
>index Clean IPsec FS add/delete rules28729b1cc6e6..be7650d2cfd3 100644
>--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
>+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
>@@ -215,7 +215,7 @@ static inline int mlx5e_xfrm_validate_state(struct xfrm_state *x)
> 		return -EINVAL;
> 	}
> 	if (x->props.flags & XFRM_STATE_ESN &&
>-	    !(mlx5_ipsec_device_caps(priv->mdev) & MLX5_ACCEL_IPSEC_CAP_ESN)) {
>+	    !(mlx5_ipsec_device_caps(priv->mdev) & MLX5_IPSEC_CAP_ESN)) {
> 		netdev_info(netdev, "Cannot offload ESN xfrm states\n");
> 		return -EINVAL;
> 	}
>@@ -262,11 +262,6 @@ static inline int mlx5e_xfrm_validate_state(struct xfrm_state *x)
> 		netdev_info(netdev, "Cannot offload xfrm states with geniv other than seqiv\n");
> 		return -EINVAL;
> 	}
>-	if (x->props.family == AF_INET6 &&
>-	    !(mlx5_ipsec_device_caps(priv->mdev) & MLX5_ACCEL_IPSEC_CAP_IPV6)) {
>-		netdev_info(netdev, "IPv6 xfrm state offload is not supported by this device\n");
>-		return -EINVAL;
>-	}
> 	return 0;
> }
>
>@@ -457,12 +452,6 @@ void mlx5e_ipsec_build_netdev(struct mlx5e_priv *priv)
> 	if (!mlx5_ipsec_device_caps(mdev))
> 		return;
>
>-	if (!(mlx5_ipsec_device_caps(mdev) & MLX5_ACCEL_IPSEC_CAP_ESP) ||
>-	    !MLX5_CAP_ETH(mdev, swp)) {
>-		mlx5_core_dbg(mdev, "mlx5e: ESP and SWP offload not supported\n");
>-		return;
>-	}
>-
> 	mlx5_core_info(mdev, "mlx5e: IPSec ESP acceleration enabled\n");
> 	netdev->xfrmdev_ops = &mlx5e_ipsec_xfrmdev_ops;
> 	netdev->features |= NETIF_F_HW_ESP;
>@@ -476,8 +465,7 @@ void mlx5e_ipsec_build_netdev(struct mlx5e_priv *priv)
> 	netdev->features |= NETIF_F_HW_ESP_TX_CSUM;
> 	netdev->hw_enc_features |= NETIF_F_HW_ESP_TX_CSUM;
>
>-	if (!(mlx5_ipsec_device_caps(mdev) & MLX5_ACCEL_IPSEC_CAP_LSO) ||
>-	    !MLX5_CAP_ETH(mdev, swp_lso)) {
>+	if (!MLX5_CAP_ETH(mdev, swp_lso)) {
> 		mlx5_core_dbg(mdev, "mlx5e: ESP LSO not supported\n");
> 		return;
> 	}
>diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
>index af1467cbb7c7..97c55620089d 100644
>--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
>+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
>@@ -102,12 +102,9 @@ struct mlx5_accel_esp_xfrm_attrs {
> 	u8 is_ipv6;
> };
>
>-enum mlx5_accel_ipsec_cap {
>-	MLX5_ACCEL_IPSEC_CAP_DEVICE		= 1 << 0,
>-	MLX5_ACCEL_IPSEC_CAP_ESP		= 1 << 1,
>-	MLX5_ACCEL_IPSEC_CAP_IPV6		= 1 << 2,
>-	MLX5_ACCEL_IPSEC_CAP_LSO		= 1 << 3,
>-	MLX5_ACCEL_IPSEC_CAP_ESN		= 1 << 4,
>+enum mlx5_ipsec_cap {
>+	MLX5_IPSEC_CAP_CRYPTO		= 1 << 0,
>+	MLX5_IPSEC_CAP_ESN		= 1 << 1,
> };
>
> struct mlx5e_priv;
>diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
>index 817747d5229e..b44bce3f4ef1 100644
>--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
>+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
>@@ -7,7 +7,7 @@
>
> u32 mlx5_ipsec_device_caps(struct mlx5_core_dev *mdev)
> {
>-	u32 caps;
>+	u32 caps = 0;
>
> 	if (!MLX5_CAP_GEN(mdev, ipsec_offload))
> 		return 0;
>@@ -19,23 +19,23 @@ u32 mlx5_ipsec_device_caps(struct mlx5_core_dev *mdev)
> 	    MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_IPSEC))
> 		return 0;
>
>-	if (!MLX5_CAP_IPSEC(mdev, ipsec_crypto_offload) ||
>-	    !MLX5_CAP_ETH(mdev, insert_trailer))
>-		return 0;
>-
> 	if (!MLX5_CAP_FLOWTABLE_NIC_TX(mdev, ipsec_encrypt) ||
> 	    !MLX5_CAP_FLOWTABLE_NIC_RX(mdev, ipsec_decrypt))
> 		return 0;
>
>-	caps = MLX5_ACCEL_IPSEC_CAP_DEVICE | MLX5_ACCEL_IPSEC_CAP_IPV6 |
>-	       MLX5_ACCEL_IPSEC_CAP_LSO;
>+	if (!MLX5_CAP_IPSEC(mdev, ipsec_crypto_esp_aes_gcm_128_encrypt) ||
>+	    !MLX5_CAP_IPSEC(mdev, ipsec_crypto_esp_aes_gcm_128_decrypt))
>+		return 0;
>
>-	if (MLX5_CAP_IPSEC(mdev, ipsec_crypto_esp_aes_gcm_128_encrypt) &&
>-	    MLX5_CAP_IPSEC(mdev, ipsec_crypto_esp_aes_gcm_128_decrypt))
>-		caps |= MLX5_ACCEL_IPSEC_CAP_ESP;
>+	if (MLX5_CAP_IPSEC(mdev, ipsec_crypto_offload) &&
>+	    MLX5_CAP_ETH(mdev, insert_trailer) && MLX5_CAP_ETH(mdev, swp))
>+		caps |= MLX5_IPSEC_CAP_CRYPTO;
>+
>+	if (!caps)
>+		return 0;
>
> 	if (MLX5_CAP_IPSEC(mdev, ipsec_esn))
>-		caps |= MLX5_ACCEL_IPSEC_CAP_ESN;
>+		caps |= MLX5_IPSEC_CAP_ESN;
>
> 	/* We can accommodate up to 2^24 different IPsec objects
> 	 * because we use up to 24 bit in flow table metadata
>-- 
>2.35.1
>
