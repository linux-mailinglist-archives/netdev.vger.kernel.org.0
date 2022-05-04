Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCB9351972B
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 08:03:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344822AbiEDGHH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 02:07:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344792AbiEDGGu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 02:06:50 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2045.outbound.protection.outlook.com [40.107.223.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF3F327CFF
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 23:03:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DXP9jn0Jf+0G8e8KsDU7youE0UJVqF/6gmCdXJ1sqTY8rJAdqFJtVPr0U04X8qxuO/VSwwn0NUFTr0eRja7NUQfjg6FSIqV9Q9U45KZpUsj5UerzmCkmTwki/OcPRFYlEWQgo2Dfs6a/M1JgHIqFTnS04WFp4rFDuRKOlGe2Id0Vg4d/AFfY9nrochdBkNL5W1DVyC5o04XeusPmeeiSPXeJkxWHfCBzU4wbGi3nV8hfpoT80nH7HGWq5iWriv0ZZzXdRdFxRVg88ZGcugRCf4qufWS2DISUlDd100zRoIB9wvwbRR++IW35MxHMAGpIc6D70tXkSDIi0yO/ZHQfVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iMg4hwLh/seh5kgxXYlNTzxCGBrDfZDAvLwohMb600o=;
 b=k0wrgfZeJp/kOsTx+1ObpEqiAa+5awh0g1yuOJLEXeJqCYtXdPBZib/qXiU3q2mVaP5RlR8uUch8t14vTbTgmSEkmasfyt13qDF9sv9Bu6HnnBpty5bjdye4U9qLFPNFneIMCtArXGNZnsmkqznqOYd7pRkl7cluI1/xZhtskoVijAm9e6nyZe4Xl7f9iT2WACPpcgKo3BCDMzKtaFZuggagMsQ2/46ZUnfMbQoC78DA1lC4Dq5vQGJXwypxUF39c3mcfU95pS1bM2vskKJOAlNil2oo20OxNzAjtK9Rls6c4meRX0KWTopQa1/ISVumiRSPZ4mnAdzWXPk/7roG4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iMg4hwLh/seh5kgxXYlNTzxCGBrDfZDAvLwohMb600o=;
 b=sLjSnyygwrUqabZSfPzqdreHYl2JYLATQKMOTdmg0o20rlbz3+gdNe3EoQBxl8EpFl/DJsSyUWsPPsPUm6IsVQgtERrvw8A4HKb8nmVJfK+F2dmGOyOqOjMTPKGCVCZzNJA7LSl4LkCbplbJiii6r2Xw3flXPIMk5t0Ma1eDg1q5jmRXOJ8n/ZiK5O8mKIth3LLHCXG3BQNJeOrjZINvSKr5E3zwXxAwC4V/AoWvmy1Qtbw+8hnaBOkS9YKNHrCo+wJX1GsRZc+A6a6cqgMAeiJxANbf8tBhZl63/TQdy+KjbJ1tkSYYgRIvaelQ+CN60fjLEY1DFGMN7ayQXuW3jQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by CY4PR1201MB0006.namprd12.prod.outlook.com (2603:10b6:903:d3::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.20; Wed, 4 May
 2022 06:03:08 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca%4]) with mapi id 15.20.5206.025; Wed, 4 May 2022
 06:03:08 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 10/17] net/mlx5: Clean IPsec FS add/delete rules
Date:   Tue,  3 May 2022 23:02:24 -0700
Message-Id: <20220504060231.668674-11-saeedm@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220504060231.668674-1-saeedm@nvidia.com>
References: <20220504060231.668674-1-saeedm@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR04CA0017.namprd04.prod.outlook.com
 (2603:10b6:a03:217::22) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5597e322-2eb6-4938-4e95-08da2d93c301
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0006:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1201MB000656B0D09B4AE0B6B67D57B3C39@CY4PR1201MB0006.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Fr+jkhkGlii9DDixekhCm5iX/8hiDQT/g/rApufVcNyP4GSRXPNWbdK/VDDNlmGmarzisp/M7MyiE5pxpBliyCVRXdPNqytUQYDZ9dY21dK7sVcV3yO7pagKBWYwdpw5LRyC+Ms9cV/Ov54ULym15At2kPPjUzScn6nG3TEMSxP5+rNoJ4pzNmMxElkFZEcrQN0FEZsi0xOfldl00L70WmfVyUfPdEi7o35diMh4qzhtrmuMqcqYzUqczN9Hd1pqCCQZiGHRnhB08G3x3fiuM4wIAu564vyS++JzLQnTsAljMzqlP/2rS4LdaehFAhZ1e6oXEcAKmRpYNf0h0NNnf+0BDGsD6O4+GS7u5qBPgX16qQQPnbCk5rLLNrlpGzNNx6joCq7qUsjtGhu9Lw1c+/90exnbTtVRDji3psRR0JMg0hs9h5i9hCWHm+7998FBnSvARUmjU+9FDCHg2LGIBc6EFRgOpmTsrnoh4aWsSfoeEm2jv/BGXs+YC5jDEKH5RZz8lU/2zThpTb/7OyOTm1yYcG1d9DDoNv34crOYZyhUofv86ZOncJtIwGMXXA7ZLsh7RM636YJ/sGwGlHa2qFexgQhCVJ/0dFXMo8YFC6/kONRzHEj8xyRljUdYdnmW8RUCWEuadPIP07rBUY5PNw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(107886003)(2906002)(54906003)(8936002)(110136005)(86362001)(316002)(83380400001)(66946007)(6512007)(6506007)(8676002)(66556008)(66476007)(6666004)(508600001)(4326008)(186003)(1076003)(2616005)(5660300002)(38100700002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1Sk1v3VSbpNOx/XtvVtSPr6OFLUfC45APEip94pYIU/AdU3yQMasmTF2Leu5?=
 =?us-ascii?Q?56ZlggLZ9j5YBil7rI+k2BGsO8SI0txZPdddODtSFLhG5Ot9Yx6eNoMwjc0u?=
 =?us-ascii?Q?HLn8PDJZuBd2Nur3MYsxSBIkxDxdT3yDzWFV9qJDmFDLQCF9zxBvKxOEdd84?=
 =?us-ascii?Q?XWYGclOlyYu44ANxvs82D7cwnWHL2+uMEFpOv9Lvs42iD6GXROGSXDHJ1Vid?=
 =?us-ascii?Q?UPIkeZMX/J2Qw6l8H9UqW9ZCOT+FcR+u5zuxchZW7u5QVlRA5nGAe+ZBKMNU?=
 =?us-ascii?Q?vcfF22w70T7+B7yVVouL5gKvRsE/ifPHZwpew6aakSD3bf9eJiP3azIeW8DE?=
 =?us-ascii?Q?6GKoLeZtLRQr0TFYVaVsgyGr4pakn+KdSDO/34RK0K5uxZkISIvkTwQV9VtK?=
 =?us-ascii?Q?2A2BeYIPqXxTHUq7O5pQ5MliHXkMtZsDd7f2jJhE55j4nfFweY5QbABB5wjY?=
 =?us-ascii?Q?mw6RKG18ecNpvpQG7K2QB0fHtgb3Ed3rFEOtbpRB0C3gkz7ueJqkEbSKDCQq?=
 =?us-ascii?Q?PN+vCPuHig0US+RXCS5AGFde7TaaKkkh06/jZUyKI+6avrvbwgImFXEF6KkE?=
 =?us-ascii?Q?Rt1WWVB3Ah3cO/YCx56CUWm9aX+8pUcXYNESIsG52nHyIFfOk8QhdjQaZXWr?=
 =?us-ascii?Q?I4bTVxhPNKpEBH0IvEkf5zdC1I4NeadxVgx07JD3meEWElXxltXzaEHfrA+z?=
 =?us-ascii?Q?ypzg+6ACntYP4J2a4JVGyogwqxAGU8sG3rOLn0MrMSy5+FTw9D1mK9smLdXy?=
 =?us-ascii?Q?GKqtfefOGDEBcSxb25btq9MjtJTTsGUAU38DGrG3vrRMDzRu/oqtm4MiGO9P?=
 =?us-ascii?Q?QTYCLcPWIkKtUV4f8voDWrh72pw61tlgaG1GSUH6zd98OJat7rD+bGPwXjPW?=
 =?us-ascii?Q?NutgN3Rsbr15x1y8j1wl7UQRAAskHNO8tP8SceMWxKwCRXoIpp8i3aB0HVlo?=
 =?us-ascii?Q?TQEzMEUhP7svZVgi0oW5AW9tehYujC1gIJT3tlPLFA2CGZqhKLtvQjw94h1m?=
 =?us-ascii?Q?qNXkiO9/PzgyVdEV8/2WpLvs+2/WRsb2pNXaYiauts4iWAkQJTSkOa7+wlu6?=
 =?us-ascii?Q?HVy6N1H0BIoh5oiw8yd740NY6YBl7P0SncmCL0K+8jX4HxrjrpDWlIdVdbz7?=
 =?us-ascii?Q?bZvsW/uKqnRhXx743ffzpb9oCvgSixQWOHRqaDDa5b43F13TVemphAWnVWxe?=
 =?us-ascii?Q?oE5mmktl0zSW/qc+lFSQvHFyeW2Jv4l9fAO3OA2pzWvHzizJcSryPECbVjQ7?=
 =?us-ascii?Q?UDsLnCNcewbm51RrPrASv/ghyD+QWcMr1zfCESdzF21/hQ0tomOUU1BcNq79?=
 =?us-ascii?Q?3KM3JunADIvhNvBK99aN002GWezoLMd1E6PC3vxFw0TrzJwdCoI11bKlHTif?=
 =?us-ascii?Q?1tTtGRzYXTD4thRVqNBbQcDKgj1BV0lkpMgBoAySFgcCDnxNRTzy7vD943Bg?=
 =?us-ascii?Q?GPP7L1OqZ+OoHp4DN6Xjk8oZKGl2kMZOTuBLAXixT9kMJBtkn2+2ENTSAHZA?=
 =?us-ascii?Q?LX668NxrNTav2EU5g9Z0AUFNRm3Sqm1j/3ltIq/l4JgV2MKEvfm2c/vm6K6v?=
 =?us-ascii?Q?50AJDscTqO6F65VYjivhfZPwudrEHwVxbUlo2hIRVB+77ZRy7ROxfMs3xc9K?=
 =?us-ascii?Q?FqDwCDLaOZrmNTMJBuvKIM3A5deO5lUzVbYdhGO4fLjtTyMkKMljtee8STin?=
 =?us-ascii?Q?4gsDeA5eot6Nw+sxvcJtBYSsA3oa+iThii1zu1G+TSKLDzDeBJHg5kbZqwpm?=
 =?us-ascii?Q?JLvJDcg1imWiHwIKlGtShv78k+x8BH8iG9TJHBD7x9wz6M2+RdIJ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5597e322-2eb6-4938-4e95-08da2d93c301
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 06:03:08.3931
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EFHq0yY3FzSsQlgwOVTqlYwRAzsZjoVF+JwtxNg4pSnVVXI3gbjy5V4NG2AvYmk48eImUK8OgeCCuTC1kcB6bw==
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

Reuse existing struct to pass parameters instead of open code them.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec.c       | 10 +---
 .../mellanox/mlx5/core/en_accel/ipsec.h       |  7 +--
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 55 ++++++++++---------
 3 files changed, 34 insertions(+), 38 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 537311a74bfb..81c9831ad286 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -313,9 +313,7 @@ static int mlx5e_xfrm_add_state(struct xfrm_state *x)
 	if (err)
 		goto err_xfrm;
 
-	err = mlx5e_accel_ipsec_fs_add_rule(priv, &sa_entry->attrs,
-					    sa_entry->ipsec_obj_id,
-					    &sa_entry->ipsec_rule);
+	err = mlx5e_accel_ipsec_fs_add_rule(priv, sa_entry);
 	if (err)
 		goto err_hw_ctx;
 
@@ -333,8 +331,7 @@ static int mlx5e_xfrm_add_state(struct xfrm_state *x)
 	goto out;
 
 err_add_rule:
-	mlx5e_accel_ipsec_fs_del_rule(priv, &sa_entry->attrs,
-				      &sa_entry->ipsec_rule);
+	mlx5e_accel_ipsec_fs_del_rule(priv, sa_entry);
 err_hw_ctx:
 	mlx5_ipsec_free_sa_ctx(sa_entry);
 err_xfrm:
@@ -357,8 +354,7 @@ static void mlx5e_xfrm_free_state(struct xfrm_state *x)
 	struct mlx5e_priv *priv = netdev_priv(x->xso.dev);
 
 	cancel_work_sync(&sa_entry->modify_work.work);
-	mlx5e_accel_ipsec_fs_del_rule(priv, &sa_entry->attrs,
-				      &sa_entry->ipsec_rule);
+	mlx5e_accel_ipsec_fs_del_rule(priv, sa_entry);
 	mlx5_ipsec_free_sa_ctx(sa_entry);
 	kfree(sa_entry);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
index cdcb95f90623..af1467cbb7c7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
@@ -176,12 +176,9 @@ struct xfrm_state *mlx5e_ipsec_sadb_rx_lookup(struct mlx5e_ipsec *dev,
 void mlx5e_accel_ipsec_fs_cleanup(struct mlx5e_ipsec *ipsec);
 int mlx5e_accel_ipsec_fs_init(struct mlx5e_ipsec *ipsec);
 int mlx5e_accel_ipsec_fs_add_rule(struct mlx5e_priv *priv,
-				  struct mlx5_accel_esp_xfrm_attrs *attrs,
-				  u32 ipsec_obj_id,
-				  struct mlx5e_ipsec_rule *ipsec_rule);
+				  struct mlx5e_ipsec_sa_entry *sa_entry);
 void mlx5e_accel_ipsec_fs_del_rule(struct mlx5e_priv *priv,
-				   struct mlx5_accel_esp_xfrm_attrs *attrs,
-				   struct mlx5e_ipsec_rule *ipsec_rule);
+				   struct mlx5e_ipsec_sa_entry *sa_entry);
 
 int mlx5_ipsec_create_sa_ctx(struct mlx5e_ipsec_sa_entry *sa_entry);
 void mlx5_ipsec_free_sa_ctx(struct mlx5e_ipsec_sa_entry *sa_entry);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index 96ab2e9d6f9a..342828351254 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -454,11 +454,12 @@ static void setup_fte_common(struct mlx5_accel_esp_xfrm_attrs *attrs,
 }
 
 static int rx_add_rule(struct mlx5e_priv *priv,
-		       struct mlx5_accel_esp_xfrm_attrs *attrs,
-		       u32 ipsec_obj_id,
-		       struct mlx5e_ipsec_rule *ipsec_rule)
+		       struct mlx5e_ipsec_sa_entry *sa_entry)
 {
 	u8 action[MLX5_UN_SZ_BYTES(set_add_copy_action_in_auto)] = {};
+	struct mlx5e_ipsec_rule *ipsec_rule = &sa_entry->ipsec_rule;
+	struct mlx5_accel_esp_xfrm_attrs *attrs = &sa_entry->attrs;
+	u32 ipsec_obj_id = sa_entry->ipsec_obj_id;
 	struct mlx5_modify_hdr *modify_hdr = NULL;
 	struct mlx5e_accel_fs_esp_prot *fs_prot;
 	struct mlx5_flow_destination dest = {};
@@ -532,9 +533,7 @@ static int rx_add_rule(struct mlx5e_priv *priv,
 }
 
 static int tx_add_rule(struct mlx5e_priv *priv,
-		       struct mlx5_accel_esp_xfrm_attrs *attrs,
-		       u32 ipsec_obj_id,
-		       struct mlx5e_ipsec_rule *ipsec_rule)
+		       struct mlx5e_ipsec_sa_entry *sa_entry)
 {
 	struct mlx5_flow_act flow_act = {};
 	struct mlx5_flow_handle *rule;
@@ -551,7 +550,8 @@ static int tx_add_rule(struct mlx5e_priv *priv,
 		goto out;
 	}
 
-	setup_fte_common(attrs, ipsec_obj_id, spec, &flow_act);
+	setup_fte_common(&sa_entry->attrs, sa_entry->ipsec_obj_id, spec,
+			 &flow_act);
 
 	/* Add IPsec indicator in metadata_reg_a */
 	spec->match_criteria_enable |= MLX5_MATCH_MISC_PARAMETERS_2;
@@ -566,11 +566,11 @@ static int tx_add_rule(struct mlx5e_priv *priv,
 	if (IS_ERR(rule)) {
 		err = PTR_ERR(rule);
 		netdev_err(priv->netdev, "fail to add ipsec rule attrs->action=0x%x, err=%d\n",
-				attrs->action, err);
+				sa_entry->attrs.action, err);
 		goto out;
 	}
 
-	ipsec_rule->rule = rule;
+	sa_entry->ipsec_rule.rule = rule;
 
 out:
 	kvfree(spec);
@@ -580,21 +580,25 @@ static int tx_add_rule(struct mlx5e_priv *priv,
 }
 
 static void rx_del_rule(struct mlx5e_priv *priv,
-		struct mlx5_accel_esp_xfrm_attrs *attrs,
-		struct mlx5e_ipsec_rule *ipsec_rule)
+			struct mlx5e_ipsec_sa_entry *sa_entry)
 {
+	struct mlx5e_ipsec_rule *ipsec_rule = &sa_entry->ipsec_rule;
+
 	mlx5_del_flow_rules(ipsec_rule->rule);
 	ipsec_rule->rule = NULL;
 
 	mlx5_modify_header_dealloc(priv->mdev, ipsec_rule->set_modify_hdr);
 	ipsec_rule->set_modify_hdr = NULL;
 
-	rx_ft_put(priv, attrs->is_ipv6 ? ACCEL_FS_ESP6 : ACCEL_FS_ESP4);
+	rx_ft_put(priv,
+		  sa_entry->attrs.is_ipv6 ? ACCEL_FS_ESP6 : ACCEL_FS_ESP4);
 }
 
 static void tx_del_rule(struct mlx5e_priv *priv,
-		struct mlx5e_ipsec_rule *ipsec_rule)
+			struct mlx5e_ipsec_sa_entry *sa_entry)
 {
+	struct mlx5e_ipsec_rule *ipsec_rule = &sa_entry->ipsec_rule;
+
 	mlx5_del_flow_rules(ipsec_rule->rule);
 	ipsec_rule->rule = NULL;
 
@@ -602,24 +606,23 @@ static void tx_del_rule(struct mlx5e_priv *priv,
 }
 
 int mlx5e_accel_ipsec_fs_add_rule(struct mlx5e_priv *priv,
-				  struct mlx5_accel_esp_xfrm_attrs *attrs,
-				  u32 ipsec_obj_id,
-				  struct mlx5e_ipsec_rule *ipsec_rule)
+				  struct mlx5e_ipsec_sa_entry *sa_entry)
 {
-	if (attrs->action == MLX5_ACCEL_ESP_ACTION_DECRYPT)
-		return rx_add_rule(priv, attrs, ipsec_obj_id, ipsec_rule);
-	else
-		return tx_add_rule(priv, attrs, ipsec_obj_id, ipsec_rule);
+	if (sa_entry->attrs.action == MLX5_ACCEL_ESP_ACTION_ENCRYPT)
+		return tx_add_rule(priv, sa_entry);
+
+	return rx_add_rule(priv, sa_entry);
 }
 
 void mlx5e_accel_ipsec_fs_del_rule(struct mlx5e_priv *priv,
-		struct mlx5_accel_esp_xfrm_attrs *attrs,
-		struct mlx5e_ipsec_rule *ipsec_rule)
+				   struct mlx5e_ipsec_sa_entry *sa_entry)
 {
-	if (attrs->action == MLX5_ACCEL_ESP_ACTION_DECRYPT)
-		rx_del_rule(priv, attrs, ipsec_rule);
-	else
-		tx_del_rule(priv, ipsec_rule);
+	if (sa_entry->attrs.action == MLX5_ACCEL_ESP_ACTION_ENCRYPT) {
+		tx_del_rule(priv, sa_entry);
+		return;
+	}
+
+	rx_del_rule(priv, sa_entry);
 }
 
 void mlx5e_accel_ipsec_fs_cleanup(struct mlx5e_ipsec *ipsec)
-- 
2.35.1

