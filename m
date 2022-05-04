Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7957D519729
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 08:03:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344807AbiEDGHD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 02:07:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344813AbiEDGGt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 02:06:49 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2045.outbound.protection.outlook.com [40.107.223.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0097E1D0DA
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 23:03:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QzsJ2DHkEP8Q4rgZ1WfF5GDYC3IM9J/4bccw9F1C6LzM5gJIBidyyG7EcR8kBfc+X0nkne/AMmcyz3w3Euj+6Kx3GS32rxrpP0l6vnIsL494ocO8l/t/V32QhO05ivpLyE244WG3Ije/Ik8Ry+BJ5tkKp11NPEtrgyJqQYV3bzDS6MfhC4WDZ5h+pY8Bp3JL4DJSkonaqbPNwyH97M11th2Ni+Z2wVOS+qSHgcvsftXhCxbfel9l/znsoW335ow8nyOnir8ZYsWSTj4yYHFBSORPTSyZ9Y2iLD6yQU7Qduq6k+oAIYdeWfVQTUIHP9SqS5wj2lzUDH3Zzkb/bnNSNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PUyIwZmntbIWI1BzfhFhgXr6/txN8tiiaelfyVbPMbE=;
 b=HJacg8XUYOkcdZjvCxfpCLq4ILMxAtkInrs4Lc+K+WbqeFXz7UEyXIu7fYsGIr2rLVllmwh4DTJiwoRNQDRr2GlkpUm2+NxgHGk3ASkHOkeEVvqL1DcoEjkOl6Mbo73l7hpfu7sRdUbnSEDJIe/KJAyIY9yj/VWnTO3WISXVhGE9Unu/I3iewl0g5KzjXWi36ntUGWwB1zND1x8EClte5dWhISj2Re+BcOYQtlZ8ntEcPFfFvW54AsiYY7AcceoIGyHqICkyQrY9Sh/Ive56tO1XmhSnzKEtGXjeQoi9NZZZd/k6umBjpTbF6Xa1fd1iYXO1gMZz+itWOUIFReh14w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PUyIwZmntbIWI1BzfhFhgXr6/txN8tiiaelfyVbPMbE=;
 b=BCMEpl95vyoXzqUvMZJ+tHNFnFBmiCGSsQ4YGN1b5NDT5TE/vnS26Pi79uOqf+jgeLhwyRrPWL9BHIeJ78GyGnIvLhDoa8rk3HYkQp29Lo1dVdMIoqYuTXbrFiJYm4BAPLPjcIyDT79csxGVBtoYColnXKiSlpoROn6VBk3QcwzooZdbOB2UbweuIZnwDnmre+Q7WCW3hZiWx3XYe8c6WAN3yDXfHBmF/eH5rDbMZQP/Cf3+exKsJBQZeh4TqcjdyC3s/4HwbAkfV3bqLXddFUnhr55hYNxOpvlfM89CcNwVM7dnSegbVHPJiFNrVDc07MWCwZuPjrkXhh29/2zjHQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by CY4PR1201MB0006.namprd12.prod.outlook.com (2603:10b6:903:d3::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.20; Wed, 4 May
 2022 06:03:07 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca%4]) with mapi id 15.20.5206.025; Wed, 4 May 2022
 06:03:07 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 09/17] net/mlx5: Simplify HW context interfaces by using SA entry
Date:   Tue,  3 May 2022 23:02:23 -0700
Message-Id: <20220504060231.668674-10-saeedm@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220504060231.668674-1-saeedm@nvidia.com>
References: <20220504060231.668674-1-saeedm@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0003.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::16) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fd35a013-541f-4bd0-cc48-08da2d93c27d
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0006:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1201MB0006B6AF916F35A91F8BBBFAB3C39@CY4PR1201MB0006.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kiolpV7vyEgil+oZhlHiaPWnIwOJ0hVS2JLGF07JglPUcZ61XhvoSBAEAe0dXwjR11YoSqOMDs874eHEbV3x3/P8PKN9KNAZnnU4Ea+bKf+D75+VbKL2yQ7VJdTns2QIvzApyLtsLs2xWk1JzxKuCUf9XSKA4nFUYqx6bNg4VOD1vkq++AdwD45HH9v8bquKAh5x/CMSTbvJ91cUGJ5B1XTIjjkSHTZz53QbF6fjX6J5wdZsdE8O5Rr7RbMGp5iYQw+l4mo2OUFghL++yGJYEZ2sO3Oghfqi/72ZgRNwL45sOsTH1FyIwemnhN9xtlMDVw0oa5NUcW2e3nBPxG3NCKi3VZ/gMyQCBTccD+4rqVDV1mvF93QqFF6l868e/3j2hkCOyw/yfi/Li5o0AqQd+0aKP+IHt0vqiMRvhi7M0b/wcB1Q3LFH6MJMHnFuf+C44Ub+Ag5qNGI0NIN9rUXTUdSdkaUv+B9r8qBLzOotSG1HBpy12xBHpJpq0+bVb9rRgrUBS9B0jaQQ+LNXKvn1guSRHIEekuc6T+l91ej1YJintgWS8DTs+OdI9n1LbQhZMo7seSUjo/Pz2O0iq3ZC7rqdP9K6+unCsnWmrq3CCL9ClBkv4yDd7Xl2bDp6D4qB8ctvnDrlMstkXl/LsZoI/w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(107886003)(2906002)(54906003)(8936002)(110136005)(86362001)(316002)(30864003)(83380400001)(66946007)(6512007)(6506007)(8676002)(66556008)(66476007)(6666004)(508600001)(4326008)(186003)(1076003)(2616005)(5660300002)(38100700002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MTgi1I74PsNxWNEj9Q5MGO2PxG9HBgLFZ5y2bwwYhYyCcozCtV9uVuS3BZ0f?=
 =?us-ascii?Q?gPAPw6gqPzR73HqOVqZcEM8QEwNMTeWZ2GZx3mnE2Yq7WGQxJ9eaj59N8UCw?=
 =?us-ascii?Q?VUbVnZWGhoKVfDJLNB2cfc3lbvSsJOs1fCg57Vxt4PxHHue4xIZOj/oz8pSH?=
 =?us-ascii?Q?YI1nhAwzMHU/WJWH1dQKdkNq4VOm2x846tYWAkYbFnYKozgSYTPAk8S8SUuC?=
 =?us-ascii?Q?MWRO3cFAFCCC371/O7tUD8UXwYH2VYGxcrQfjaw7Z1/IOS+ZHGXufBWNre3C?=
 =?us-ascii?Q?8bp7z4QXQgxd7rAKzlXo4kpGY+oaDly+el3LJMNF8W96FWqT9cbOfjJjKCsf?=
 =?us-ascii?Q?hIge+v4GjJzTJ20csrIYhKaafIccFs6RD24REFmx69MqpFn9LxJYpggHWmLO?=
 =?us-ascii?Q?h6n0RAEZyVj3AzVRidTvzYq/R4lK//opLF2pw4iDIXExKyAwO6AwhMLAc0uq?=
 =?us-ascii?Q?54h4RuO9AOhh+YPaAE2iUtPc7WdjEsUUdYjeuDUoRHKTcCwJu3f+z1HbYl95?=
 =?us-ascii?Q?ok3R0giLUWp7N91NiN6qLLm0BCUJnTvLZEvXFQeVu16qqYzmElHe16MvMP6s?=
 =?us-ascii?Q?PDWzDzPsOV6HQal8L9aapuX+wTkFb18zpDhhvXrrKOxGFKLtAFJLhaSIWtbe?=
 =?us-ascii?Q?wilS7QaKiJJMs4X+tML+dJpYTrSGiZNsw6HVGlI0j3KmtTno5wN4SNArsKFd?=
 =?us-ascii?Q?BQ5Iu86kq9tjq66Oi7EZB0tBCbHryxh18YvFoWvkoxdUBftOzAkxl25dvTUh?=
 =?us-ascii?Q?hGUpzJfvNbO9u8IHkeXT8jm9mQKaN3iIuIvWgqNK3In1tqxVdH5sMeP1qcRv?=
 =?us-ascii?Q?KYb7r1z56ckMSD6Oy3T/wzrEM5xDSiuU/0BZ0NLre2Uew7L6UI/3UHC4aGVG?=
 =?us-ascii?Q?2bvaG5exSRwq1MAMtuGIf5T/rY5j/5kxTBXp5QQ0A+rIiWpxUPldIRPaVSmQ?=
 =?us-ascii?Q?To//NjwF2M1UyCgUFqAmWgpcQ8GxeAsA9jcdEtFlkZjXbeOrFtuDHB9+8Deh?=
 =?us-ascii?Q?29meAHf0WwoQxYOdrZM+JXX5PBF5oWqQB7IA/RhqWRL1hmzujVJrLreTKWvR?=
 =?us-ascii?Q?NB9OH4YOlne+L86voUT6oDJnO+KgBKKzMcZWAxYKUhYOGtvC1PIrQptZ2X7/?=
 =?us-ascii?Q?xQ0YDwoqEBpFjByVhMkJN4K05MAG2BiT6JJ0vx9IPI2HVeg+EewV+Gw9MJtV?=
 =?us-ascii?Q?shyM4xIPqciVpGbu6uz62XYIxoS23UszcDCEM32nk6HkGvIWFOjvDBrxM5qE?=
 =?us-ascii?Q?M2LemLMWYDJdOT50+aySbLCxjIM1wbpxgyefqVLfzLz6mYwqW7n7M/kLlJgN?=
 =?us-ascii?Q?Egq+Kn4wq737IzkhL6XMjekauyhNlmXJO/yNakk2B8UMkPjvWzIF5DsKgww8?=
 =?us-ascii?Q?qRz5aI0XF72AJDmRpxzYcApxuE8Hzetz1gOHkmgZ/LrlvtfSj8gwudalzd6a?=
 =?us-ascii?Q?0UryE4oFBCK9XN/mWFlDLLGHXZudS8zpdVlZukhSMBg4ZgtIAVxa/z3zM5wR?=
 =?us-ascii?Q?8uHgfRNsDgmZvTyUncESQIb3mYOirf4LNMX8HH1JUb7QySA0vgZAa3o6Kiot?=
 =?us-ascii?Q?IbXxZsSUHpK584xJd7D/TjVvdJf/HVr/n3Fx1DfdYBYeTFW4zw/XO8pXenyX?=
 =?us-ascii?Q?rAt7KVNuRc3b0raM4uoTBvmhuu9/z2o+rPDTJudKreyd54WBUdkKp0ycHsbX?=
 =?us-ascii?Q?OU5azRGc1Ay3EYcQR6RluLq8Neq4leindF/n/bVFy49V0b3cRLYmMmwugq0z?=
 =?us-ascii?Q?Mg9jg4uZpzKOhvzmrV8LGIIYcrb3ha9WjzeT4/haEoAnDIOAmBEU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd35a013-541f-4bd0-cc48-08da2d93c27d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 06:03:07.4374
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fKTaXDe7MfhI0CHB4M0usGPdRzp3jtnHBAIxEHrQCa8HWek9TkK/EQNILZdhFb9528gziPm8JoGdMcauN54Jyg==
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

SA context logic used multiple structures to store same data
over and over. By simplifying the SA context interfaces, we
can remove extra structs.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec.c       |  50 ++---
 .../mellanox/mlx5/core/en_accel/ipsec.h       |  27 ++-
 .../mlx5/core/en_accel/ipsec_offload.c        | 182 ++++--------------
 3 files changed, 62 insertions(+), 197 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 0daf9350471f..537311a74bfb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -63,9 +63,9 @@ struct xfrm_state *mlx5e_ipsec_sadb_rx_lookup(struct mlx5e_ipsec *ipsec,
 	return ret;
 }
 
-static int  mlx5e_ipsec_sadb_rx_add(struct mlx5e_ipsec_sa_entry *sa_entry,
-				    unsigned int handle)
+static int mlx5e_ipsec_sadb_rx_add(struct mlx5e_ipsec_sa_entry *sa_entry)
 {
+	unsigned int handle = sa_entry->ipsec_obj_id;
 	struct mlx5e_ipsec *ipsec = sa_entry->ipsec;
 	struct mlx5e_ipsec_sa_entry *_sa_entry;
 	unsigned long flags;
@@ -277,16 +277,14 @@ static void _update_xfrm_state(struct work_struct *work)
 	struct mlx5e_ipsec_sa_entry *sa_entry = container_of(
 		modify_work, struct mlx5e_ipsec_sa_entry, modify_work);
 
-	mlx5_accel_esp_modify_xfrm(sa_entry->xfrm, &modify_work->attrs);
+	mlx5_accel_esp_modify_xfrm(sa_entry, &modify_work->attrs);
 }
 
 static int mlx5e_xfrm_add_state(struct xfrm_state *x)
 {
 	struct mlx5e_ipsec_sa_entry *sa_entry = NULL;
 	struct net_device *netdev = x->xso.real_dev;
-	struct mlx5_accel_esp_xfrm_attrs attrs;
 	struct mlx5e_priv *priv;
-	unsigned int sa_handle;
 	int err;
 
 	priv = netdev_priv(netdev);
@@ -309,33 +307,20 @@ static int mlx5e_xfrm_add_state(struct xfrm_state *x)
 	/* check esn */
 	mlx5e_ipsec_update_esn_state(sa_entry);
 
-	/* create xfrm */
-	mlx5e_ipsec_build_accel_xfrm_attrs(sa_entry, &attrs);
-	sa_entry->xfrm = mlx5_accel_esp_create_xfrm(priv->mdev, &attrs);
-	if (IS_ERR(sa_entry->xfrm)) {
-		err = PTR_ERR(sa_entry->xfrm);
-		goto err_sa_entry;
-	}
-
+	mlx5e_ipsec_build_accel_xfrm_attrs(sa_entry, &sa_entry->attrs);
 	/* create hw context */
-	sa_entry->hw_context =
-			mlx5_accel_esp_create_hw_context(priv->mdev,
-							 sa_entry->xfrm,
-							 &sa_handle);
-	if (IS_ERR(sa_entry->hw_context)) {
-		err = PTR_ERR(sa_entry->hw_context);
+	err = mlx5_ipsec_create_sa_ctx(sa_entry);
+	if (err)
 		goto err_xfrm;
-	}
 
-	sa_entry->ipsec_obj_id = sa_handle;
-	err = mlx5e_accel_ipsec_fs_add_rule(priv, &sa_entry->xfrm->attrs,
+	err = mlx5e_accel_ipsec_fs_add_rule(priv, &sa_entry->attrs,
 					    sa_entry->ipsec_obj_id,
 					    &sa_entry->ipsec_rule);
 	if (err)
 		goto err_hw_ctx;
 
 	if (x->xso.flags & XFRM_OFFLOAD_INBOUND) {
-		err = mlx5e_ipsec_sadb_rx_add(sa_entry, sa_handle);
+		err = mlx5e_ipsec_sadb_rx_add(sa_entry);
 		if (err)
 			goto err_add_rule;
 	} else {
@@ -348,15 +333,12 @@ static int mlx5e_xfrm_add_state(struct xfrm_state *x)
 	goto out;
 
 err_add_rule:
-	mlx5e_accel_ipsec_fs_del_rule(priv, &sa_entry->xfrm->attrs,
+	mlx5e_accel_ipsec_fs_del_rule(priv, &sa_entry->attrs,
 				      &sa_entry->ipsec_rule);
 err_hw_ctx:
-	mlx5_accel_esp_free_hw_context(priv->mdev, sa_entry->hw_context);
+	mlx5_ipsec_free_sa_ctx(sa_entry);
 err_xfrm:
-	mlx5_accel_esp_destroy_xfrm(sa_entry->xfrm);
-err_sa_entry:
 	kfree(sa_entry);
-
 out:
 	return err;
 }
@@ -374,14 +356,10 @@ static void mlx5e_xfrm_free_state(struct xfrm_state *x)
 	struct mlx5e_ipsec_sa_entry *sa_entry = to_ipsec_sa_entry(x);
 	struct mlx5e_priv *priv = netdev_priv(x->xso.dev);
 
-	if (sa_entry->hw_context) {
-		cancel_work_sync(&sa_entry->modify_work.work);
-		mlx5e_accel_ipsec_fs_del_rule(priv, &sa_entry->xfrm->attrs,
-					      &sa_entry->ipsec_rule);
-		mlx5_accel_esp_free_hw_context(sa_entry->xfrm->mdev, sa_entry->hw_context);
-		mlx5_accel_esp_destroy_xfrm(sa_entry->xfrm);
-	}
-
+	cancel_work_sync(&sa_entry->modify_work.work);
+	mlx5e_accel_ipsec_fs_del_rule(priv, &sa_entry->attrs,
+				      &sa_entry->ipsec_rule);
+	mlx5_ipsec_free_sa_ctx(sa_entry);
 	kfree(sa_entry);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
index b438b0358c36..cdcb95f90623 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
@@ -102,11 +102,6 @@ struct mlx5_accel_esp_xfrm_attrs {
 	u8 is_ipv6;
 };
 
-struct mlx5_accel_esp_xfrm {
-	struct mlx5_core_dev  *mdev;
-	struct mlx5_accel_esp_xfrm_attrs attrs;
-};
-
 enum mlx5_accel_ipsec_cap {
 	MLX5_ACCEL_IPSEC_CAP_DEVICE		= 1 << 0,
 	MLX5_ACCEL_IPSEC_CAP_ESP		= 1 << 1,
@@ -162,11 +157,11 @@ struct mlx5e_ipsec_sa_entry {
 	unsigned int handle; /* Handle in SADB_RX */
 	struct xfrm_state *x;
 	struct mlx5e_ipsec *ipsec;
-	struct mlx5_accel_esp_xfrm *xfrm;
-	void *hw_context;
+	struct mlx5_accel_esp_xfrm_attrs attrs;
 	void (*set_iv_op)(struct sk_buff *skb, struct xfrm_state *x,
 			  struct xfrm_offload *xo);
 	u32 ipsec_obj_id;
+	u32 enc_key_id;
 	struct mlx5e_ipsec_rule ipsec_rule;
 	struct mlx5e_ipsec_modify_state_work modify_work;
 };
@@ -188,19 +183,19 @@ void mlx5e_accel_ipsec_fs_del_rule(struct mlx5e_priv *priv,
 				   struct mlx5_accel_esp_xfrm_attrs *attrs,
 				   struct mlx5e_ipsec_rule *ipsec_rule);
 
-void *mlx5_accel_esp_create_hw_context(struct mlx5_core_dev *mdev,
-				       struct mlx5_accel_esp_xfrm *xfrm,
-				       u32 *sa_handle);
-void mlx5_accel_esp_free_hw_context(struct mlx5_core_dev *mdev, void *context);
+int mlx5_ipsec_create_sa_ctx(struct mlx5e_ipsec_sa_entry *sa_entry);
+void mlx5_ipsec_free_sa_ctx(struct mlx5e_ipsec_sa_entry *sa_entry);
 
 u32 mlx5_ipsec_device_caps(struct mlx5_core_dev *mdev);
 
-struct mlx5_accel_esp_xfrm *
-mlx5_accel_esp_create_xfrm(struct mlx5_core_dev *mdev,
-			   const struct mlx5_accel_esp_xfrm_attrs *attrs);
-void mlx5_accel_esp_destroy_xfrm(struct mlx5_accel_esp_xfrm *xfrm);
-void mlx5_accel_esp_modify_xfrm(struct mlx5_accel_esp_xfrm *xfrm,
+void mlx5_accel_esp_modify_xfrm(struct mlx5e_ipsec_sa_entry *sa_entry,
 				const struct mlx5_accel_esp_xfrm_attrs *attrs);
+
+static inline struct mlx5_core_dev *
+mlx5e_ipsec_sa2dev(struct mlx5e_ipsec_sa_entry *sa_entry)
+{
+	return sa_entry->ipsec->mdev;
+}
 #else
 static inline int mlx5e_ipsec_init(struct mlx5e_priv *priv)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
index a7bd31d10bd4..817747d5229e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
@@ -5,21 +5,6 @@
 #include "ipsec.h"
 #include "lib/mlx5.h"
 
-struct mlx5_ipsec_sa_ctx {
-	struct rhash_head hash;
-	u32 enc_key_id;
-	u32 ipsec_obj_id;
-	/* hw ctx */
-	struct mlx5_core_dev *dev;
-	struct mlx5_ipsec_esp_xfrm *mxfrm;
-};
-
-struct mlx5_ipsec_esp_xfrm {
-	/* reference counter of SA ctx */
-	struct mlx5_ipsec_sa_ctx *sa_ctx;
-	struct mlx5_accel_esp_xfrm accel_xfrm;
-};
-
 u32 mlx5_ipsec_device_caps(struct mlx5_core_dev *mdev)
 {
 	u32 caps;
@@ -61,43 +46,11 @@ u32 mlx5_ipsec_device_caps(struct mlx5_core_dev *mdev)
 }
 EXPORT_SYMBOL_GPL(mlx5_ipsec_device_caps);
 
-struct mlx5_accel_esp_xfrm *
-mlx5_accel_esp_create_xfrm(struct mlx5_core_dev *mdev,
-			   const struct mlx5_accel_esp_xfrm_attrs *attrs)
-{
-	struct mlx5_ipsec_esp_xfrm *mxfrm;
-
-	mxfrm = kzalloc(sizeof(*mxfrm), GFP_KERNEL);
-	if (!mxfrm)
-		return ERR_PTR(-ENOMEM);
-
-	memcpy(&mxfrm->accel_xfrm.attrs, attrs,
-	       sizeof(mxfrm->accel_xfrm.attrs));
-
-	mxfrm->accel_xfrm.mdev = mdev;
-	return &mxfrm->accel_xfrm;
-}
-
-void mlx5_accel_esp_destroy_xfrm(struct mlx5_accel_esp_xfrm *xfrm)
+static int mlx5_create_ipsec_obj(struct mlx5e_ipsec_sa_entry *sa_entry)
 {
-	struct mlx5_ipsec_esp_xfrm *mxfrm = container_of(xfrm, struct mlx5_ipsec_esp_xfrm,
-							 accel_xfrm);
-
-	kfree(mxfrm);
-}
-
-struct mlx5_ipsec_obj_attrs {
-	const struct aes_gcm_keymat *aes_gcm;
-	u32 accel_flags;
-	u32 esn_msb;
-	u32 enc_key_id;
-};
-
-static int mlx5_create_ipsec_obj(struct mlx5_core_dev *mdev,
-				 struct mlx5_ipsec_obj_attrs *attrs,
-				 u32 *ipsec_id)
-{
-	const struct aes_gcm_keymat *aes_gcm = attrs->aes_gcm;
+	struct mlx5_accel_esp_xfrm_attrs *attrs = &sa_entry->attrs;
+	struct mlx5_core_dev *mdev = mlx5e_ipsec_sa2dev(sa_entry);
+	struct aes_gcm_keymat *aes_gcm = &attrs->keymat.aes_gcm;
 	u32 out[MLX5_ST_SZ_DW(general_obj_out_cmd_hdr)];
 	u32 in[MLX5_ST_SZ_DW(create_ipsec_obj_in)] = {};
 	void *obj, *salt_p, *salt_iv_p;
@@ -128,14 +81,14 @@ static int mlx5_create_ipsec_obj(struct mlx5_core_dev *mdev,
 	salt_iv_p = MLX5_ADDR_OF(ipsec_obj, obj, implicit_iv);
 	memcpy(salt_iv_p, &aes_gcm->seq_iv, sizeof(aes_gcm->seq_iv));
 	/* esn */
-	if (attrs->accel_flags & MLX5_ACCEL_ESP_FLAGS_ESN_TRIGGERED) {
+	if (attrs->flags & MLX5_ACCEL_ESP_FLAGS_ESN_TRIGGERED) {
 		MLX5_SET(ipsec_obj, obj, esn_en, 1);
-		MLX5_SET(ipsec_obj, obj, esn_msb, attrs->esn_msb);
-		if (attrs->accel_flags & MLX5_ACCEL_ESP_FLAGS_ESN_STATE_OVERLAP)
+		MLX5_SET(ipsec_obj, obj, esn_msb, attrs->esn);
+		if (attrs->flags & MLX5_ACCEL_ESP_FLAGS_ESN_STATE_OVERLAP)
 			MLX5_SET(ipsec_obj, obj, esn_overlap, 1);
 	}
 
-	MLX5_SET(ipsec_obj, obj, dekn, attrs->enc_key_id);
+	MLX5_SET(ipsec_obj, obj, dekn, sa_entry->enc_key_id);
 
 	/* general object fields set */
 	MLX5_SET(general_obj_in_cmd_hdr, in, opcode,
@@ -145,13 +98,15 @@ static int mlx5_create_ipsec_obj(struct mlx5_core_dev *mdev,
 
 	err = mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
 	if (!err)
-		*ipsec_id = MLX5_GET(general_obj_out_cmd_hdr, out, obj_id);
+		sa_entry->ipsec_obj_id =
+			MLX5_GET(general_obj_out_cmd_hdr, out, obj_id);
 
 	return err;
 }
 
-static void mlx5_destroy_ipsec_obj(struct mlx5_core_dev *mdev, u32 ipsec_id)
+static void mlx5_destroy_ipsec_obj(struct mlx5e_ipsec_sa_entry *sa_entry)
 {
+	struct mlx5_core_dev *mdev = mlx5e_ipsec_sa2dev(sa_entry);
 	u32 in[MLX5_ST_SZ_DW(general_obj_in_cmd_hdr)] = {};
 	u32 out[MLX5_ST_SZ_DW(general_obj_out_cmd_hdr)];
 
@@ -159,79 +114,52 @@ static void mlx5_destroy_ipsec_obj(struct mlx5_core_dev *mdev, u32 ipsec_id)
 		 MLX5_CMD_OP_DESTROY_GENERAL_OBJECT);
 	MLX5_SET(general_obj_in_cmd_hdr, in, obj_type,
 		 MLX5_GENERAL_OBJECT_TYPES_IPSEC);
-	MLX5_SET(general_obj_in_cmd_hdr, in, obj_id, ipsec_id);
+	MLX5_SET(general_obj_in_cmd_hdr, in, obj_id, sa_entry->ipsec_obj_id);
 
 	mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
 }
 
-static void *mlx5_ipsec_offload_create_sa_ctx(struct mlx5_core_dev *mdev,
-					      struct mlx5_accel_esp_xfrm *accel_xfrm,
-					      const __be32 saddr[4], const __be32 daddr[4],
-					      const __be32 spi, bool is_ipv6, u32 *hw_handle)
+int mlx5_ipsec_create_sa_ctx(struct mlx5e_ipsec_sa_entry *sa_entry)
 {
-	struct mlx5_accel_esp_xfrm_attrs *xfrm_attrs = &accel_xfrm->attrs;
-	struct aes_gcm_keymat *aes_gcm = &xfrm_attrs->keymat.aes_gcm;
-	struct mlx5_ipsec_obj_attrs ipsec_attrs = {};
-	struct mlx5_ipsec_esp_xfrm *mxfrm;
-	struct mlx5_ipsec_sa_ctx *sa_ctx;
+	struct aes_gcm_keymat *aes_gcm = &sa_entry->attrs.keymat.aes_gcm;
+	struct mlx5_core_dev *mdev = mlx5e_ipsec_sa2dev(sa_entry);
 	int err;
 
-	/* alloc SA context */
-	sa_ctx = kzalloc(sizeof(*sa_ctx), GFP_KERNEL);
-	if (!sa_ctx)
-		return ERR_PTR(-ENOMEM);
-
-	sa_ctx->dev = mdev;
-
-	mxfrm = container_of(accel_xfrm, struct mlx5_ipsec_esp_xfrm, accel_xfrm);
-	sa_ctx->mxfrm = mxfrm;
-
 	/* key */
 	err = mlx5_create_encryption_key(mdev, aes_gcm->aes_key,
 					 aes_gcm->key_len / BITS_PER_BYTE,
 					 MLX5_ACCEL_OBJ_IPSEC_KEY,
-					 &sa_ctx->enc_key_id);
+					 &sa_entry->enc_key_id);
 	if (err) {
 		mlx5_core_dbg(mdev, "Failed to create encryption key (err = %d)\n", err);
-		goto err_sa_ctx;
+		return err;
 	}
 
-	ipsec_attrs.aes_gcm = aes_gcm;
-	ipsec_attrs.accel_flags = accel_xfrm->attrs.flags;
-	ipsec_attrs.esn_msb = accel_xfrm->attrs.esn;
-	ipsec_attrs.enc_key_id = sa_ctx->enc_key_id;
-	err = mlx5_create_ipsec_obj(mdev, &ipsec_attrs,
-				    &sa_ctx->ipsec_obj_id);
+	err = mlx5_create_ipsec_obj(sa_entry);
 	if (err) {
 		mlx5_core_dbg(mdev, "Failed to create IPsec object (err = %d)\n", err);
 		goto err_enc_key;
 	}
 
-	*hw_handle = sa_ctx->ipsec_obj_id;
-	mxfrm->sa_ctx = sa_ctx;
-
-	return sa_ctx;
+	return 0;
 
 err_enc_key:
-	mlx5_destroy_encryption_key(mdev, sa_ctx->enc_key_id);
-err_sa_ctx:
-	kfree(sa_ctx);
-	return ERR_PTR(err);
+	mlx5_destroy_encryption_key(mdev, sa_entry->enc_key_id);
+	return err;
 }
 
-static void mlx5_ipsec_offload_delete_sa_ctx(void *context)
+void mlx5_ipsec_free_sa_ctx(struct mlx5e_ipsec_sa_entry *sa_entry)
 {
-	struct mlx5_ipsec_sa_ctx *sa_ctx = (struct mlx5_ipsec_sa_ctx *)context;
+	struct mlx5_core_dev *mdev = mlx5e_ipsec_sa2dev(sa_entry);
 
-	mlx5_destroy_ipsec_obj(sa_ctx->dev, sa_ctx->ipsec_obj_id);
-	mlx5_destroy_encryption_key(sa_ctx->dev, sa_ctx->enc_key_id);
-	kfree(sa_ctx);
+	mlx5_destroy_ipsec_obj(sa_entry);
+	mlx5_destroy_encryption_key(mdev, sa_entry->enc_key_id);
 }
 
-static int mlx5_modify_ipsec_obj(struct mlx5_core_dev *mdev,
-				 struct mlx5_ipsec_obj_attrs *attrs,
-				 u32 ipsec_id)
+static int mlx5_modify_ipsec_obj(struct mlx5e_ipsec_sa_entry *sa_entry,
+				 const struct mlx5_accel_esp_xfrm_attrs *attrs)
 {
+	struct mlx5_core_dev *mdev = mlx5e_ipsec_sa2dev(sa_entry);
 	u32 in[MLX5_ST_SZ_DW(modify_ipsec_obj_in)] = {};
 	u32 out[MLX5_ST_SZ_DW(query_ipsec_obj_out)];
 	u64 modify_field_select = 0;
@@ -239,7 +167,7 @@ static int mlx5_modify_ipsec_obj(struct mlx5_core_dev *mdev,
 	void *obj;
 	int err;
 
-	if (!(attrs->accel_flags & MLX5_ACCEL_ESP_FLAGS_ESN_TRIGGERED))
+	if (!(attrs->flags & MLX5_ACCEL_ESP_FLAGS_ESN_TRIGGERED))
 		return 0;
 
 	general_obj_types = MLX5_CAP_GEN_64(mdev, general_obj_types);
@@ -249,11 +177,11 @@ static int mlx5_modify_ipsec_obj(struct mlx5_core_dev *mdev,
 	/* general object fields set */
 	MLX5_SET(general_obj_in_cmd_hdr, in, opcode, MLX5_CMD_OP_QUERY_GENERAL_OBJECT);
 	MLX5_SET(general_obj_in_cmd_hdr, in, obj_type, MLX5_GENERAL_OBJECT_TYPES_IPSEC);
-	MLX5_SET(general_obj_in_cmd_hdr, in, obj_id, ipsec_id);
+	MLX5_SET(general_obj_in_cmd_hdr, in, obj_id, sa_entry->ipsec_obj_id);
 	err = mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
 	if (err) {
 		mlx5_core_err(mdev, "Query IPsec object failed (Object id %d), err = %d\n",
-			      ipsec_id, err);
+			      sa_entry->ipsec_obj_id, err);
 		return err;
 	}
 
@@ -266,8 +194,8 @@ static int mlx5_modify_ipsec_obj(struct mlx5_core_dev *mdev,
 		return -EOPNOTSUPP;
 
 	obj = MLX5_ADDR_OF(modify_ipsec_obj_in, in, ipsec_object);
-	MLX5_SET(ipsec_obj, obj, esn_msb, attrs->esn_msb);
-	if (attrs->accel_flags & MLX5_ACCEL_ESP_FLAGS_ESN_STATE_OVERLAP)
+	MLX5_SET(ipsec_obj, obj, esn_msb, attrs->esn);
+	if (attrs->flags & MLX5_ACCEL_ESP_FLAGS_ESN_STATE_OVERLAP)
 		MLX5_SET(ipsec_obj, obj, esn_overlap, 1);
 
 	/* general object fields set */
@@ -276,50 +204,14 @@ static int mlx5_modify_ipsec_obj(struct mlx5_core_dev *mdev,
 	return mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
 }
 
-void mlx5_accel_esp_modify_xfrm(struct mlx5_accel_esp_xfrm *xfrm,
+void mlx5_accel_esp_modify_xfrm(struct mlx5e_ipsec_sa_entry *sa_entry,
 				const struct mlx5_accel_esp_xfrm_attrs *attrs)
 {
-	struct mlx5_ipsec_obj_attrs ipsec_attrs = {};
-	struct mlx5_core_dev *mdev = xfrm->mdev;
-	struct mlx5_ipsec_esp_xfrm *mxfrm;
 	int err;
 
-	mxfrm = container_of(xfrm, struct mlx5_ipsec_esp_xfrm, accel_xfrm);
-
-	/* need to add find and replace in ipsec_rhash_sa the sa_ctx */
-	/* modify device with new hw_sa */
-	ipsec_attrs.accel_flags = attrs->flags;
-	ipsec_attrs.esn_msb = attrs->esn;
-	err = mlx5_modify_ipsec_obj(mdev,
-				    &ipsec_attrs,
-				    mxfrm->sa_ctx->ipsec_obj_id);
-
+	err = mlx5_modify_ipsec_obj(sa_entry, attrs);
 	if (err)
 		return;
 
-	memcpy(&xfrm->attrs, attrs, sizeof(xfrm->attrs));
-}
-
-void *mlx5_accel_esp_create_hw_context(struct mlx5_core_dev *mdev,
-				       struct mlx5_accel_esp_xfrm *xfrm,
-				       u32 *sa_handle)
-{
-	__be32 saddr[4] = {}, daddr[4] = {};
-
-	if (!xfrm->attrs.is_ipv6) {
-		saddr[3] = xfrm->attrs.saddr.a4;
-		daddr[3] = xfrm->attrs.daddr.a4;
-	} else {
-		memcpy(saddr, xfrm->attrs.saddr.a6, sizeof(saddr));
-		memcpy(daddr, xfrm->attrs.daddr.a6, sizeof(daddr));
-	}
-
-	return mlx5_ipsec_offload_create_sa_ctx(mdev, xfrm, saddr, daddr,
-						xfrm->attrs.spi,
-						xfrm->attrs.is_ipv6, sa_handle);
-}
-
-void mlx5_accel_esp_free_hw_context(struct mlx5_core_dev *mdev, void *context)
-{
-	mlx5_ipsec_offload_delete_sa_ctx(context);
+	memcpy(&sa_entry->attrs, attrs, sizeof(sa_entry->attrs));
 }
-- 
2.35.1

