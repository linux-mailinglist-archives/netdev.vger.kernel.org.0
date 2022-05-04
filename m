Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2135F519722
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 08:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344800AbiEDGGl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 02:06:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344787AbiEDGGh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 02:06:37 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2054.outbound.protection.outlook.com [40.107.223.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D8191BEA1
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 23:03:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lDDEAsnw2uUnkUilbK4zwFQYk+lPvSVlT9nixwldAJ90WfQCcnmO66/OC94CYQ/vETrIGybH6zClJ5M7tZ4MaNGJ3JMc4+odX9wtxXdvsv+nUsYqkUjzUOUM/SygK/1GqWuG/go6UxMauLm+q+Bp3D6M2W/Mm/voRbjML82PRWdy/0p+SofGV4q9LGyk6zpmdx6jV3xOn6etv5gYtmoB9zkwanQJlU2ySmDiRI8JxOfxbe75LzakyWDBYo8tekyZeKl+jXrOMffNJQj8x6VM7hNt4IIudBMUP5jKt3s7xMK+WAeRVo2CYqZhh56B7ZpuOsIw/w1UgJ6dzJSL5AZCiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4FfMfGKzp7Da4uiJiSQOouVTjE79KjBLtw9UHOTCack=;
 b=j0pxfWIpirEDDP1igNqS6jfdszeGYQ7+72GsOVBs7y2bnzYheydCKlcXbXOl8K3O/Vp2W+Fkk+3pej67OE7aGcGBnSYKqIYDJoFs07QR8PfsLr39SHd06W2T9P8JlwmOJYrknfbt5hgFyZiyOcjN80UERN8RDYIkZDUridEwbFSxn3aY7wCZioJfGXgCuPNBbueBaC446tGROkVxerU8eXOE/jNYZWqU4cqs8sIT/ie71M20U03LV8D+6TsTNqkcCqF6fyitqqSVbPprKl8VV85yFuKZESetpvJFuqQlzFU6R26YkwZnQt2ppciV8IlTiWROtJZlRXVPrnlpc5yD2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4FfMfGKzp7Da4uiJiSQOouVTjE79KjBLtw9UHOTCack=;
 b=kyEMMadYkf+eYIfS1NLmmutb/mC66T/egviKb0LITgYG35Umz1fNFmm4rJsTxAX5Ib1GwVYvp3el0hMv2HKYyFJ3IvrQ196zWZ+Hmwbp9Ykp1UMaoK5UzhiwQNPGhAZ2wzWSLGJwpAqSPP2KX+GEAU4hkCm7hNIrrYEfzS15g2qeHec4w+Z4dob8IZzTMFTKop+5zTC2Yg0kp9lA7PaDsqrs/i7mLI0fwFKvZy60whxC/EUYiaNhJVHv4T+a8GhrY6tjfyX3o3vNJ0Cv/HdNSzi7Xqxpq5eZx1ExRdv/pm9Pp4zlmOOEf9pk5yyjjF6al/o6rqkpBoeJZP6NG+CVyA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by CY4PR1201MB0006.namprd12.prod.outlook.com (2603:10b6:903:d3::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.20; Wed, 4 May
 2022 06:03:01 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca%4]) with mapi id 15.20.5206.025; Wed, 4 May 2022
 06:03:01 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 04/17] net/mlx5: Reduce useless indirection in IPsec FS add/delete flows
Date:   Tue,  3 May 2022 23:02:18 -0700
Message-Id: <20220504060231.668674-5-saeedm@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220504060231.668674-1-saeedm@nvidia.com>
References: <20220504060231.668674-1-saeedm@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0035.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::10) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ce56ff84-0743-475b-81b0-08da2d93beb5
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0006:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1201MB000645CCE54078F009352184B3C39@CY4PR1201MB0006.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yH5uiHq205/C272JAuU1nWOsQEOIKq4qANEeKe2E4kPJuJg/kPU2dlLUkoMGNYzr5ydSG9YKvCd+TchiqJLirQdwoZHMe76Vm8jyG0DXZBO9LWwKRIjzth9iU9KbpEyTZv7uSsbxdPdlPrKjyY0zWcLijRvoJfZBoEYy/grq2nOewIBbG1InJAU1RYq7WCrFyVh83RChHvTnBi3p9UxAzr2U9dvrSHqD8e1/wYy8CIVyubParhxOKp9jSJGI2uywa6PUopEf9TOKeET/kxMLJEa+mO4dBMsA+1UkIKiLnUOZQt6PQ2Qm+7KoQUKHN14VN9LBXrCAKOi2Xnm+q+nQYQBbwmU8EAqjvA5cEonKYikI1+O3XjlIIFesCTMkXXCCONg0HLaGgeeNLPo32YR1wVXCxikZ55D3sy4zkd1E3sZLbKnvDYhacVswczX25MEZL98ZXrLBj7MVnriCvX5yfqFrHtMuXZaBIlrpM7dWK3F5FBN00Dx8Y9aS361VXq0oNvsU0dYr2LD8C2rzkEmexmLHcmq08ko6GjJPJqxjWt9Ulhojw/3UDr5/eei8w1Mj9cjy6iAeTcSm8db/uByNgxs1YSo7EZAsQ6kI+d51m9SSE40ABjxE68FDHy01K7Jg5WtnODKK9YQDnXgwB42udQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(107886003)(2906002)(54906003)(8936002)(110136005)(86362001)(316002)(83380400001)(66946007)(6512007)(6506007)(8676002)(66556008)(66476007)(6666004)(508600001)(4326008)(186003)(1076003)(2616005)(5660300002)(38100700002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PI37y0btmg8MyNXW5S1bVJ/UlPfSEwhjioibBPL84IPlPNyAkjLsKNwiLGe1?=
 =?us-ascii?Q?8bwRK1dGS2Pnl1Zoy/6N6kfUl1bHdhm5FVLtbaPksSnJvCyXfTHaqcEZ8BaX?=
 =?us-ascii?Q?c8TmeD56KfxdeKd4geUAvzmVEF/Zyb/YiXuxvJTeom3S0O34s+JZWKkgeLIk?=
 =?us-ascii?Q?Mq2IU2ovTTXQFJgNqxScLGmG/KNP8slbdUwP1I5S4DLNpe+fnykqnMluvKw6?=
 =?us-ascii?Q?p+FAfGdAXtMh1+KfAiIXxzSHlbpkF50BzFPwNhAv5keBwx2NsBAZ2acayaar?=
 =?us-ascii?Q?YiVsi0PPvoh23hJXxb+rnX/G/8j+oZoMzM7Drni7mkvr/fdmMKR/GHm/fNHg?=
 =?us-ascii?Q?r4j8hy1XRttZcyLn6PICk3VN8S/7YDGyX0gR3cQFqdES9EC7gItA/ElhYmUR?=
 =?us-ascii?Q?G3ox6E2a2S50wm7v7kmtb0aEty0dbnKqb3i3NQ9+sFQZ+QLrXV7Wb//7MSP1?=
 =?us-ascii?Q?zClLIn9qKdZnCsIy8c6eLE+rFR1NxBp9iIYgsKUhA5UgyObuwfdLou4ujuHr?=
 =?us-ascii?Q?+idJLqX4QqlLpo8kZnYrmM1z+Ovna6TRVKffnNfKTZzFEhOZZrs4RrU/KIF3?=
 =?us-ascii?Q?R6s4RVLL/Uu0UkzV21BeULNA5w/nTI9WjJWcEzG2aEDsz1UwL8bVIvcc79qb?=
 =?us-ascii?Q?m6gmIabk73Uel0w9GT4Zm9zqQ0VD6QEJr/qkMas3oyH/EEiobJV6ej2WUpS3?=
 =?us-ascii?Q?faLxdu79fEcPr418yyFMonmbUyFts3OW69vFEhU1zaAZcpSGg0hIphhjVU0V?=
 =?us-ascii?Q?DjPacyrhc1Y2DQuc182EtABGcMZmGVTncXhpT05575k3a5UVHRGcf8qvnOTG?=
 =?us-ascii?Q?Jn8vHqdXucBaQ73DFt+D1cqqjE6w36oFejxRahUpFLEke+r9Ib2i0hUeEG2o?=
 =?us-ascii?Q?uT2W1Vd4tWGdIZ6UB4zIQYVdAUzC0BzsdFnsAw/xhP6Z3R3G/8zDgVPujwCZ?=
 =?us-ascii?Q?t5Lemft02MnA3sD42GkfxKmgR+dF0bKFTsbMlg0Jrn3mv5z9SK9YaPUUGqas?=
 =?us-ascii?Q?TKR2Ta8iWExb9U5S33FVTGAFBIurPujyokvXHfUcT7kNxUJpnDfc8tJfFKY2?=
 =?us-ascii?Q?/4UJQq7FliGOtsFEg/LsazmQeQHwAhFmDb0jwOkY37m3evdK4vkKsyb+omJ/?=
 =?us-ascii?Q?CvFgTGtTOXApSL119ZIa0+YvV7GlE6sJID+J4Vntcp4AojI1OhmwGLezJ0k8?=
 =?us-ascii?Q?2QubxiCX+8/17X0abIE+X7rpsrn/Me7LRrN4smOgLqSSiE63sSpS8aGB9vFS?=
 =?us-ascii?Q?hk914Onkh2tiiceh4TcwnyepMixGBX+dS2vmAtdm+CLnF5l10YxBPYPuoWS/?=
 =?us-ascii?Q?U/hpxiuJIeGXDfNF8WjrNCql9YCKXs8KUi5wem0a3c9dEuvznaHSdMeDJLjs?=
 =?us-ascii?Q?8KYWdjkt4w7Tf1YUlTQ6PGX6L6A8gVPep2xmWtPzNFpfdEdrsg5oN1MhHJTv?=
 =?us-ascii?Q?CHDCK0qBMOlqFkt4zG/fWl0VZoCOvDpWQwFj+YFWV7E6zEQuCbeUtn7Orfse?=
 =?us-ascii?Q?Qr8Lvf9gqJz852dQLVScCKYvg/PMpcRsgsgHlNXwx0kt2FYQQDWToEhLOIVb?=
 =?us-ascii?Q?WonaujmJ6xUkLhL+itb13LgbSZdHUaKX/Xx3ypgz7KtlYnJMApR68JOiUq13?=
 =?us-ascii?Q?ntluwZ0MXkmVlszw+NvlS1hQl8dRim+5W7tQ09+CnqqqJzKGTC0ocpGbg9ls?=
 =?us-ascii?Q?21cFcTDil3HabHCSAdqId6cQZiqw3hEVyriHQPFCGgfRDGL8ytoTSw7+D+p0?=
 =?us-ascii?Q?ILub6wNn3sEisD0kXKc0YKbLYm4qjtw=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce56ff84-0743-475b-81b0-08da2d93beb5
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 06:03:01.0604
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9ZDS2qglklwXNx1Vu+uEOUenKrTZqcN/yXtetQLh4vbTUxKSap/7dfxs5UBv3Xc+hbJz7UspcLFIu1flInZ7ZQ==
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

There is no need in one-liners wrappers to call internal functions.
Let's remove them.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec.c       | 25 ++++++-------------
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    |  4 +--
 2 files changed, 9 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index b04d5de91d87..251178e6e82b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -271,21 +271,6 @@ static inline int mlx5e_xfrm_validate_state(struct xfrm_state *x)
 	return 0;
 }
 
-static int mlx5e_xfrm_fs_add_rule(struct mlx5e_priv *priv,
-				  struct mlx5e_ipsec_sa_entry *sa_entry)
-{
-	return mlx5e_accel_ipsec_fs_add_rule(priv, &sa_entry->xfrm->attrs,
-					     sa_entry->ipsec_obj_id,
-					     &sa_entry->ipsec_rule);
-}
-
-static void mlx5e_xfrm_fs_del_rule(struct mlx5e_priv *priv,
-				   struct mlx5e_ipsec_sa_entry *sa_entry)
-{
-	mlx5e_accel_ipsec_fs_del_rule(priv, &sa_entry->xfrm->attrs,
-				      &sa_entry->ipsec_rule);
-}
-
 static int mlx5e_xfrm_add_state(struct xfrm_state *x)
 {
 	struct mlx5e_ipsec_sa_entry *sa_entry = NULL;
@@ -334,7 +319,9 @@ static int mlx5e_xfrm_add_state(struct xfrm_state *x)
 	}
 
 	sa_entry->ipsec_obj_id = sa_handle;
-	err = mlx5e_xfrm_fs_add_rule(priv, sa_entry);
+	err = mlx5e_accel_ipsec_fs_add_rule(priv, &sa_entry->xfrm->attrs,
+					    sa_entry->ipsec_obj_id,
+					    &sa_entry->ipsec_rule);
 	if (err)
 		goto err_hw_ctx;
 
@@ -351,7 +338,8 @@ static int mlx5e_xfrm_add_state(struct xfrm_state *x)
 	goto out;
 
 err_add_rule:
-	mlx5e_xfrm_fs_del_rule(priv, sa_entry);
+	mlx5e_accel_ipsec_fs_del_rule(priv, &sa_entry->xfrm->attrs,
+				      &sa_entry->ipsec_rule);
 err_hw_ctx:
 	mlx5_accel_esp_free_hw_context(priv->mdev, sa_entry->hw_context);
 err_xfrm:
@@ -378,7 +366,8 @@ static void mlx5e_xfrm_free_state(struct xfrm_state *x)
 
 	if (sa_entry->hw_context) {
 		flush_workqueue(sa_entry->ipsec->wq);
-		mlx5e_xfrm_fs_del_rule(priv, sa_entry);
+		mlx5e_accel_ipsec_fs_del_rule(priv, &sa_entry->xfrm->attrs,
+					      &sa_entry->ipsec_rule);
 		mlx5_accel_esp_free_hw_context(sa_entry->xfrm->mdev, sa_entry->hw_context);
 		mlx5_accel_esp_destroy_xfrm(sa_entry->xfrm);
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index f733a6e61196..bffad18a59d6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -612,8 +612,8 @@ int mlx5e_accel_ipsec_fs_add_rule(struct mlx5e_priv *priv,
 }
 
 void mlx5e_accel_ipsec_fs_del_rule(struct mlx5e_priv *priv,
-				   struct mlx5_accel_esp_xfrm_attrs *attrs,
-				   struct mlx5e_ipsec_rule *ipsec_rule)
+			     struct mlx5_accel_esp_xfrm_attrs *attrs,
+			     struct mlx5e_ipsec_rule *ipsec_rule)
 {
 	if (attrs->action == MLX5_ACCEL_ESP_ACTION_DECRYPT)
 		rx_del_rule(priv, attrs, ipsec_rule);
-- 
2.35.1

