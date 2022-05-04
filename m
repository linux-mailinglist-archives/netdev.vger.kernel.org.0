Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6373851972E
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 08:03:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344859AbiEDGHR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 02:07:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344809AbiEDGHI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 02:07:08 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2061.outbound.protection.outlook.com [40.107.223.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C5D31D0DA
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 23:03:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f4n6TzJ0Pz2FVILuJ0UeB9DFo4fP0PCf4FBr0oDYXyI9urcf0AY+QzU8dsugTqQa4rJoN9X2eSx3G445LejeqxnUoBXTjcggwNLtEm9zEl1vp4sGvJUc1koqxtm4G33XjxgbsLuwribj1ZMRMwTWiXkLXYDWl43pHJcAUPjwfxqXnKeEBlwmPL8pfzri5g7uyw/HNayXPqPhyC5OsRda2P/YIty5aL0gAAJP8CMK6/U1an0SgT/7Q68HcvRuNAq3V5X3A1LqLd+9BNjqRFzNeLF/7mDcG5Vk2DoP6n6g4It3URIMfQiQSVErxxuUQeUpuDIDPywDDKfiU+TxAFUwBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dOI6+wVRZOohGdsiI6SfX5kRlR66eguzxV+89HPRe6I=;
 b=XQcrrdA0y2WjHLoIq6AJNlsqPCXvhGqH7dBH1MNnzt1O+iDMQsERll7Zt83Only+xVXtsougd+CN9UbFSInu1PwUin0PkC4JWip+72JrpWfVjO27xvP8eZF8KYGI7dbUj4SRMxM0y2hMXzlK4VAa455Unibl2WBUYfoOKOTj0PYz5DqqaAlXaWGwyFwKY3tsA75eG2vgWhudYBrJWt5plZ07IUz88mNIe554sWSQUmqyHXIh0iRyEBv0EqVPhmMrB1dyoJMG2FiFV9uzMwpyxMxoJPLBJaSeBL5LPY5Y1QQk0LevCQhtZuuNMJbj+vIPPSIT3+QEjv8KMHnD7/fpmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dOI6+wVRZOohGdsiI6SfX5kRlR66eguzxV+89HPRe6I=;
 b=REk1V8ObOvda0zs4PplZGDmniy6kJa53zhC5sXvBj00zpb37kwiS5cnDkYSZ46rv6oyi1h0bZcyd+AvZ4LxqVr3lcPSmh0ISqg/Q11HpQBanjv4m9xtWpRcnxpC2cjFvUe79z5egLrJxU10qeGV9TeNmQyIrcq/UPEJmqJeyvzr2r79bLyqSVC7ez54rp7RXFyiCSleEWOF/aT163f9Sxvhw9dQR95cfx7McRmIkaxLO7XBt447ZXZhJljIf6syOr6RGEu/gp4DjTKjXRNgBXCroQxeTFhvnGDmV2YKN8h/RzAGRWmIaYrx/jhlQuG6UZ84Svuzvn7cuZvHO+epCJg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by CY4PR1201MB0006.namprd12.prod.outlook.com (2603:10b6:903:d3::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.20; Wed, 4 May
 2022 06:03:12 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca%4]) with mapi id 15.20.5206.025; Wed, 4 May 2022
 06:03:12 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 13/17] net/mlx5: Simplify IPsec capabilities logic
Date:   Tue,  3 May 2022 23:02:27 -0700
Message-Id: <20220504060231.668674-14-saeedm@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220504060231.668674-1-saeedm@nvidia.com>
References: <20220504060231.668674-1-saeedm@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR04CA0016.namprd04.prod.outlook.com
 (2603:10b6:a03:217::21) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 91bd8890-4532-4a86-a743-08da2d93c58e
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0006:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1201MB00062CE1D1E6A2BEA6BBD5A3B3C39@CY4PR1201MB0006.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ShtANLo/FQ+cL4P8u6vIenU7odyulH44ONuMQRdkfMxMQeW1s4lteOtzGdwwhL3fThgpHXradw+vHB0/4c08P3RGquG1xe8kiEQwns/Q7Y0sEzeENBwZhEfAOfXvFRIPPMccDMYAEJ4RN1MNpi9GebxUWZOu3g/qiY/2I0lRB120WtBDdC1FH3gmtwJjZksDBxKzJY2bspUbgNwbwIuoHuaupnS+IeSpBjS+Kx/ySxqWjfLqKDrGhwMwPXAA25ffDAfrxEbqLCV36F4E7vd+RggyBo7NJpCd4jFcAdZSXMKVBEOjed0G7F0LnNqrPgnXOSDfMM9BnunkIm4711qoFIse1NzCMrekd6SV4scLDO4iLsApHFkFgsIBoBxf5RNpwZpbzfGYNcqGZCgtP8vPyIL20OjNl99JmWPeimCi4uMjLLlIeQHiuyt29j8vdDfaqZTCCIQYjBkWGrrmLZTDkf1QUF36PsuU9zVZBs7CR70TJkeyR82i3uA8MvIL1A691HCTZMN7l4oxzH4OpWt9jHL6g/kiqPO9b23SJVq8ffiitJiYFDaBoh9kXxP7uP3sKjGyTYUz8dj+0IjF/E8WZmtogSQq2ZuDTzuHntNJIj21uRqaBCYoTBpbWxiMqE1guF3QrJjs4qeKvdfr5euDiA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(107886003)(2906002)(54906003)(8936002)(110136005)(86362001)(316002)(83380400001)(66946007)(6512007)(6506007)(8676002)(66556008)(66476007)(6666004)(508600001)(4326008)(186003)(1076003)(2616005)(5660300002)(38100700002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Gtk6vJO8FfTY3/e3Z0Y4HZMVCO30xhhfbFDR/X59x5QGOGS7xp7NdxZZ6JuB?=
 =?us-ascii?Q?xi9ZCOIhgFNDEKLV2LAwXRwNlH3pFBsdDCuTs8pmg/Kfah7/eZgOehg9MXWM?=
 =?us-ascii?Q?2/mwneYk9klrezLiqmX99VDy3xZc8una8YnwU0pCq2XYRx/zBF1GhC/kc7TL?=
 =?us-ascii?Q?UJ+j2mXQVubfF2qG0NIJyNn4oyGoh9a2TcwKiBENZ6XnClKHNxvrFueYDQXG?=
 =?us-ascii?Q?8QccBPOoQF93ht4DcICZXWokEdhUFlnbB8167kzLzZCURElhy6TIFYlUPPDA?=
 =?us-ascii?Q?WsPVUbrG5qxRYvYKZgQ165DHcT5//fpicR8InnF4iyo6jKRTDqpODehGKhul?=
 =?us-ascii?Q?zbFdcUZvFCwGodann2ii+jj4vakChNHzDWWSlsrgfvqZ4NoP76ROGuX/X/yU?=
 =?us-ascii?Q?u/ocQz3OsqX3coTThBWlGmjumwaBwakYi9JL8oBaED7CT8xs5QqkGJWmzS2Y?=
 =?us-ascii?Q?ePCcMatK2dINkYKDRa4/B7OyZnDbx9PAyr/nu6F2UJhBkcZqMEwZBB7PRXlm?=
 =?us-ascii?Q?itOtotX7HRGIWuIIO4RrbltpCQ+C5TTOrt27drUtW3xO0G6H4BRN+M7Ez4PW?=
 =?us-ascii?Q?6FH/cV6rKy4tADay1DUeL2QpJDfAQ5wowvRN3qaJlu+YXDhPzlMnVeYdF1VF?=
 =?us-ascii?Q?U1iZk26bfXIo5K29Aqbz6Dqz/Ux8gGKK7koYJPqCPGv1ZnapL1EIAoVVad35?=
 =?us-ascii?Q?jFa8WufTpPXW9IZM3TzbnIePuvqz7XzP/JQJRp63E6eQHWV/jjhyOICe09TB?=
 =?us-ascii?Q?B+/frMqVKcWAA2Sc/Ug97vLO1ybaNG+2oD7TYe3CFC/BwMQCAyp7MjAu9gtS?=
 =?us-ascii?Q?Wabs84veSNvtdziVe+jXIxdul5UUG+EiuUtD2p6cguFW9e7sNspbwCXNNhl2?=
 =?us-ascii?Q?tLh1F+2+D1sR0aZUUEezbbGvmTSuw5o/jI456PnBAlGmvSL7lWXvsjc7j4Cp?=
 =?us-ascii?Q?IpEEMSrRyq0uVmAeRcURmgaq8z/YnbzZyx9t+MaLTlmm2LDnhh7CPfCAfwCn?=
 =?us-ascii?Q?Vx4e6OuqT85T8vJTJHM8y0aq1RFl/s4Y3t03iRW5XPjx7Vy1Blm9ykJJ+d1G?=
 =?us-ascii?Q?WzRs+TRKphistwrIKLK9JlJcr6Y07WTeRXNbq0BFkRtuAovf72LsIO+wBDAZ?=
 =?us-ascii?Q?nv1GRt7ebdrf8f5Ysseh5l2MeDC4+HXpcpN5S0hB4ZLbjcj47vpuOe0gOm3j?=
 =?us-ascii?Q?RdTIlh84o4ejoTvDRZhMjNIsFbPgAUtaNLi0liLAGHnw7nzvOkKy5cu6grGy?=
 =?us-ascii?Q?ILSYZf5YQkkHTqstFs00/qSM90oa6RgVji4ZumUp6xxJF4OtuGfCT13dsXlJ?=
 =?us-ascii?Q?PL9P6Dq7+oYx2fdvnBuLvzmfQojOqF7LPjNve1DAIR7+RO6Esy19kYd6m7Ze?=
 =?us-ascii?Q?rinMvNh5VzAPJ8gkiuwhHEwTQmwhqslQw3rpo0BWh76RKR0o+cWqv1zoHXqx?=
 =?us-ascii?Q?wLLiRT3SGecJQQVjFcek/qzJlj0Ahug16ThrZHdKnTpF9GAbpjmchirZT1x2?=
 =?us-ascii?Q?Q7/Y/apMbSoRLjhJLPLO2NfDwIBY8T4paY2WYOD0TLjnIib/GFinxSf1SydA?=
 =?us-ascii?Q?M9APdijVVMZC7s3tLFWkntlridzqu1+duEnOpFPryzcaJvB/fq1qEX73rtN/?=
 =?us-ascii?Q?QuYiUlvJ7F/tfsPwd/ZjmUjl/20MaqrSlXudtqZlETMGrVVGCFCaQ+Mta1WD?=
 =?us-ascii?Q?2rmPn0FE5vLIsrKWSxPpP73TCeTOixIw7svMla2Ee1UwtY04I1T7ivs3ccHL?=
 =?us-ascii?Q?aEohAeQWT2N6I+nDH2qSOLD5HhCli1SpxUmm0y37HR8VIDvF+fN/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91bd8890-4532-4a86-a743-08da2d93c58e
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 06:03:12.5655
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jxe5oV438IOkr6hmymjwAN2fVkacWPEAvw7UKT7IYAiGYUxAojd+ENbJICNASptB3OEpD/8s+yWpKrwEf7ck+g==
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

Reduce number of hard-coded IPsec capabilities by making sure
that mlx5_ipsec_device_caps() sets only supported bits.

As part of this change, remove _ACCEL_ notations from the capabilities
names as they represent IPsec-capable device, so it is aligned with
MLX5_CAP_IPSEC() macro. And prepare the code to IPsec full offload mode.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec.c       | 16 ++------------
 .../mellanox/mlx5/core/en_accel/ipsec.h       |  9 +++-----
 .../mlx5/core/en_accel/ipsec_offload.c        | 22 +++++++++----------
 3 files changed, 16 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 28729b1cc6e6..be7650d2cfd3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -215,7 +215,7 @@ static inline int mlx5e_xfrm_validate_state(struct xfrm_state *x)
 		return -EINVAL;
 	}
 	if (x->props.flags & XFRM_STATE_ESN &&
-	    !(mlx5_ipsec_device_caps(priv->mdev) & MLX5_ACCEL_IPSEC_CAP_ESN)) {
+	    !(mlx5_ipsec_device_caps(priv->mdev) & MLX5_IPSEC_CAP_ESN)) {
 		netdev_info(netdev, "Cannot offload ESN xfrm states\n");
 		return -EINVAL;
 	}
@@ -262,11 +262,6 @@ static inline int mlx5e_xfrm_validate_state(struct xfrm_state *x)
 		netdev_info(netdev, "Cannot offload xfrm states with geniv other than seqiv\n");
 		return -EINVAL;
 	}
-	if (x->props.family == AF_INET6 &&
-	    !(mlx5_ipsec_device_caps(priv->mdev) & MLX5_ACCEL_IPSEC_CAP_IPV6)) {
-		netdev_info(netdev, "IPv6 xfrm state offload is not supported by this device\n");
-		return -EINVAL;
-	}
 	return 0;
 }
 
@@ -457,12 +452,6 @@ void mlx5e_ipsec_build_netdev(struct mlx5e_priv *priv)
 	if (!mlx5_ipsec_device_caps(mdev))
 		return;
 
-	if (!(mlx5_ipsec_device_caps(mdev) & MLX5_ACCEL_IPSEC_CAP_ESP) ||
-	    !MLX5_CAP_ETH(mdev, swp)) {
-		mlx5_core_dbg(mdev, "mlx5e: ESP and SWP offload not supported\n");
-		return;
-	}
-
 	mlx5_core_info(mdev, "mlx5e: IPSec ESP acceleration enabled\n");
 	netdev->xfrmdev_ops = &mlx5e_ipsec_xfrmdev_ops;
 	netdev->features |= NETIF_F_HW_ESP;
@@ -476,8 +465,7 @@ void mlx5e_ipsec_build_netdev(struct mlx5e_priv *priv)
 	netdev->features |= NETIF_F_HW_ESP_TX_CSUM;
 	netdev->hw_enc_features |= NETIF_F_HW_ESP_TX_CSUM;
 
-	if (!(mlx5_ipsec_device_caps(mdev) & MLX5_ACCEL_IPSEC_CAP_LSO) ||
-	    !MLX5_CAP_ETH(mdev, swp_lso)) {
+	if (!MLX5_CAP_ETH(mdev, swp_lso)) {
 		mlx5_core_dbg(mdev, "mlx5e: ESP LSO not supported\n");
 		return;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
index af1467cbb7c7..97c55620089d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
@@ -102,12 +102,9 @@ struct mlx5_accel_esp_xfrm_attrs {
 	u8 is_ipv6;
 };
 
-enum mlx5_accel_ipsec_cap {
-	MLX5_ACCEL_IPSEC_CAP_DEVICE		= 1 << 0,
-	MLX5_ACCEL_IPSEC_CAP_ESP		= 1 << 1,
-	MLX5_ACCEL_IPSEC_CAP_IPV6		= 1 << 2,
-	MLX5_ACCEL_IPSEC_CAP_LSO		= 1 << 3,
-	MLX5_ACCEL_IPSEC_CAP_ESN		= 1 << 4,
+enum mlx5_ipsec_cap {
+	MLX5_IPSEC_CAP_CRYPTO		= 1 << 0,
+	MLX5_IPSEC_CAP_ESN		= 1 << 1,
 };
 
 struct mlx5e_priv;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
index 817747d5229e..b44bce3f4ef1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
@@ -7,7 +7,7 @@
 
 u32 mlx5_ipsec_device_caps(struct mlx5_core_dev *mdev)
 {
-	u32 caps;
+	u32 caps = 0;
 
 	if (!MLX5_CAP_GEN(mdev, ipsec_offload))
 		return 0;
@@ -19,23 +19,23 @@ u32 mlx5_ipsec_device_caps(struct mlx5_core_dev *mdev)
 	    MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_IPSEC))
 		return 0;
 
-	if (!MLX5_CAP_IPSEC(mdev, ipsec_crypto_offload) ||
-	    !MLX5_CAP_ETH(mdev, insert_trailer))
-		return 0;
-
 	if (!MLX5_CAP_FLOWTABLE_NIC_TX(mdev, ipsec_encrypt) ||
 	    !MLX5_CAP_FLOWTABLE_NIC_RX(mdev, ipsec_decrypt))
 		return 0;
 
-	caps = MLX5_ACCEL_IPSEC_CAP_DEVICE | MLX5_ACCEL_IPSEC_CAP_IPV6 |
-	       MLX5_ACCEL_IPSEC_CAP_LSO;
+	if (!MLX5_CAP_IPSEC(mdev, ipsec_crypto_esp_aes_gcm_128_encrypt) ||
+	    !MLX5_CAP_IPSEC(mdev, ipsec_crypto_esp_aes_gcm_128_decrypt))
+		return 0;
 
-	if (MLX5_CAP_IPSEC(mdev, ipsec_crypto_esp_aes_gcm_128_encrypt) &&
-	    MLX5_CAP_IPSEC(mdev, ipsec_crypto_esp_aes_gcm_128_decrypt))
-		caps |= MLX5_ACCEL_IPSEC_CAP_ESP;
+	if (MLX5_CAP_IPSEC(mdev, ipsec_crypto_offload) &&
+	    MLX5_CAP_ETH(mdev, insert_trailer) && MLX5_CAP_ETH(mdev, swp))
+		caps |= MLX5_IPSEC_CAP_CRYPTO;
+
+	if (!caps)
+		return 0;
 
 	if (MLX5_CAP_IPSEC(mdev, ipsec_esn))
-		caps |= MLX5_ACCEL_IPSEC_CAP_ESN;
+		caps |= MLX5_IPSEC_CAP_ESN;
 
 	/* We can accommodate up to 2^24 different IPsec objects
 	 * because we use up to 24 bit in flow table metadata
-- 
2.35.1

