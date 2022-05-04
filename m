Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3BA2519733
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 08:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344826AbiEDGH2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 02:07:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344821AbiEDGG5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 02:06:57 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2045.outbound.protection.outlook.com [40.107.223.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDE8C1BE83
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 23:03:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gpEpDjHNKOvnYUt1ryIJMBVVGBQMhC3yTVQ6a7s3ZzxFIGJIefnxcEK1PqhQdbL1cGqGkq5RSeDHiaMjbcj69PZVuYuPO23x3vFyfj6gPE3Y1T1apZUxjzCZEQjMMcvAkNTlCOa83VE0/W22rYIJzv70mTVQmddAJiPKJOdvoOJ0y51jQBWpGD7POJpKI+73Kg1BcyX4VXFJljgNc12rLhBEBCZ2l4b94ODxTyL79g7gNoxupX8WoD33QpEBPo8SKgJg/i/0NEhYMyiiWODzm+1ym0KIwcCWvWNzuXw0Dk56mEd/4k6PhdiG/W2ULjyhpFV2LVbiOUmShoVKI6Mq/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gZazcVA6yKxvBEKEf+Hf9si+N74EF3AVJ2zjPD2xY6c=;
 b=MU3+Q+1FZJb0Y5d2fjUND1oxNRRAILOHiTMUUdkHVreZHpBvjWsM0DweuB3R94WgYUbSCPDs7vS3SetDqgO1thVaeGJOkM0d7nHmO1RU6bTeAs7I8V9sMZB/PAYdZ4YGew0qm+hd67PzUImsBikIiY3C63VZcXzCBO9YesgNi4DUEKXEkwMEMCi3o9zVnHTStnE4dOWo5GSFSugX5vsq1UMNAlsbvdjQXjNnhqWwO93ES/uEykVTYi8adjww3+QFQWNxvPPilf3dDamLd2BVcFfO52lbE6Q2REXmKgVbxwjcc3/5oeqP+VPLuYRI+b5sQZCP0t9V1b7Fa45kIeDgjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gZazcVA6yKxvBEKEf+Hf9si+N74EF3AVJ2zjPD2xY6c=;
 b=UFRLb6cc49RPQNrxJkkMIHVOrY3otoIofsPZiGBzzfcgbsEzt3jjHHZO3G66fvBnnr7DgfGBi55j8tFe2j8HXTvqgCRHc9cT6VUeF5PNRSozPLYX02X3aBeqjh08+jPrtpaItkWQOGKP/EzOyfiGc6+7mV7HMQfoJHKSt6oBLmfOJY7acbzcWaG8lJvgbsFJceUJw6j48czPvmsgXclRq2ra25ddtDLAoRL6nOz0IWAx8OD+xK2kjk4H7SxJ8T8FALrDn6n5YmPdHZrP5P3PCJUkp0HEcDbX5IHFGf3o9wbRBCyMIikuTTzvuuIk5xr6m1YXSi7R/cHkZ/WfgtWHUw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by CY4PR1201MB0006.namprd12.prod.outlook.com (2603:10b6:903:d3::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.20; Wed, 4 May
 2022 06:03:09 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca%4]) with mapi id 15.20.5206.025; Wed, 4 May 2022
 06:03:09 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 11/17] net/mlx5: Make sure that no dangling IPsec FS pointers exist
Date:   Tue,  3 May 2022 23:02:25 -0700
Message-Id: <20220504060231.668674-12-saeedm@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220504060231.668674-1-saeedm@nvidia.com>
References: <20220504060231.668674-1-saeedm@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0018.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::31) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d42a00c4-eba7-4190-138d-08da2d93c3d3
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0006:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1201MB00061BE1A4305C20E74AED49B3C39@CY4PR1201MB0006.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UT5htUoJuX3hVOz8PqR0HRolJOzIt9vt9VlAfUbU4XcQNfPPJJOA0bAicZicEknpmByuLLp3tJdGAlPkIwNL4DZxAHKDdTjVZMWSYHwKjaITZC2moIhEOUNr2mMO28Zdi9LxoWiT9P+rQhMylRYct2/+KwPoJec0hAfqfhA/tu3DpKBYpnbFc7DIh9YhdgsOugMbI7pQsGVJJdgEJ/h6GyebeerVNygVWyrIt+BqetGtKlZjHXDtrVsCFo7foDToqhtDnrZsN4ra0kHByYnuZPdEFOBRxIZFRLCaALaiy+OkQ6p9u+ZxJWRI3ElivP0x51ERTqPXWHvNL+J2vJD+/KIj+RaxzpfXUDN27HFNVqlFS+1alcbkopvux2IWNDAqe6T0Gv4W7lAQreT6FwpAOC+ASoxrl0qbtkqXZgSidi71te0xhy4BlWu/n7vAdxYiS0OxHyqowuQlMTovR5dCGFeudN1wXDXY9iIr65fWsNcucsPoS4WmZvLgfMwy+tG1DF5n+ZMV9HKvV+7PKlujafxtapMyuzxlm6EZZDD0SSKvCZUC6P1dgp1Ymf2IN/HBWrNVDQHBZGkQ5xvTxaEc13XGs4Y2w41BNKhIRk6aO0QOpCTYaHxj028/UKsQ5RS7lTDQ99E0JUNbTX295eRsYA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(107886003)(2906002)(54906003)(8936002)(110136005)(86362001)(316002)(30864003)(83380400001)(66946007)(6512007)(6506007)(8676002)(66556008)(66476007)(6666004)(508600001)(4326008)(186003)(1076003)(2616005)(5660300002)(38100700002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8Obm0vg43itwjpK43z4R9VOFps5xLJHoH+A3LD4xjtl58zjthN3uoTtBhFLA?=
 =?us-ascii?Q?F2H7tcx8f0XaZwdyul0GTdMK3pfL5c2PoiQzBhAqL0f6gjC8SbBnqnJTzFSJ?=
 =?us-ascii?Q?kOxJwta1lbyX+0WCnxtqUIJXauqdrPXGvIXK5URH0hpjgebhAOiRL/OImt4H?=
 =?us-ascii?Q?KedDR5HQyQp15XWeF97MjMkL8IgIAcvNDWxXpuARIeCV/Ih+ex8ctGCMzikB?=
 =?us-ascii?Q?oG27nMMdXqlLlx93jWXhnPXdYDLZZz6KH+M2AZDlYzGN1JarT0VyzVqU4P5U?=
 =?us-ascii?Q?v86usyxWTAx0ZYJ++bvy88exTvGyITfuhYWr3TfauHi8nJrNBzMusMf/S0F+?=
 =?us-ascii?Q?vWiI3JCxjsT3mLAqa/dz35aUH3J1MQ+xJDTwVecr4JotuwDu+lZJ7zLDGL9V?=
 =?us-ascii?Q?s3bdllny0bwajUpJM5uzbwftllKzVGw+8YJqnr6TUbL6ytLQZi4LZifyvIVN?=
 =?us-ascii?Q?jwPAWGlGctiiSiQrdASm/NKDJrhyUB/hpQiv1OaqoDlVa1ZoZzwmC4NbVwE3?=
 =?us-ascii?Q?Ts9/lJkI0x9L5op/PZ9/12OCzIbMqwSM59mlj4Fs0EWpwVnWDW8UE6MrUJzl?=
 =?us-ascii?Q?aE2ywogvsKMgh3Y5ZtKHvuKVzvb8uRLdyH9hjLVJGmf2zEsqUjeqyWNOUFhB?=
 =?us-ascii?Q?nEbzqDAFL80dtCvy2R1i/O1sczkIqQRZxiOSZ9Wl2DfRoRFIX9sQJp7wq9p4?=
 =?us-ascii?Q?sWZr9t/SJYx0m9E14AUpJtbRB29W4yhKJtSREzNAYgxuLyslUPRZFMBc7osi?=
 =?us-ascii?Q?VU169qY8PMZhKh11u/B3dMSrOaH1oB7hUXEH+JBHSNBByW3qLOAYGYP16k2i?=
 =?us-ascii?Q?LcRmJ2Xm86LcnkfTmirDXrZbi5TP7Pk8TZSiiNvflrGJVxQex1nByWZYQpOx?=
 =?us-ascii?Q?8QxRLbHEC5NIs9DeJl445KUz40/8aF7zw7FnTrTU43HZkir+myN1cH4APWa/?=
 =?us-ascii?Q?JpX6WhK5oboldg0NMo0sCUOFFgI9kRiuwrp8yIHgdwS2wKALV1wkNJ0+zSoE?=
 =?us-ascii?Q?I3/HUp/kQSHPWtN2gf/VedOvvk8xZEfRs71roojJ/1nTKQ2Upsafr1d5SnhD?=
 =?us-ascii?Q?SE+BAcsMtyyYRNjyiFCyUvYWI+GRuWUndQ+8OEs8orisaMxV4+4dsSr6DqZG?=
 =?us-ascii?Q?BHR7YjE86/5tAkXak17pyR9GCXCM8xTobet6Bwu/V+46eBb5zr2tEV59t31E?=
 =?us-ascii?Q?f8nQH0Y9ZIGN3UA5J1dZFuu1jDr0S59FrpbTnzwJU9tqR153W8avLsZnOhfn?=
 =?us-ascii?Q?IVKXwLVoo4sqO8AXIAQxKpQTkdgQ+iXn4DA3RBgy/iGso0e6rk2JxTw5EOLj?=
 =?us-ascii?Q?9YGCXBNyPIm0nGENQz7BERvaY54SH2U9R/sEbUAUYZMYITgshFzaZMFS3vQN?=
 =?us-ascii?Q?gR9pRSROu1SI4lDrEd7PyFw+zrs7dk6jPynt5P9Zf4T/cGxqysz+gpEj0DvN?=
 =?us-ascii?Q?IJPULzQLTvbfuFDbkNr1YVtlmHoZyTjFp3WK6w/n03zIbDtHQe4fXncadEtc?=
 =?us-ascii?Q?7maTTKLtfudWFcj6HGA7QYJVlRxQn1UQafqef5FS19ub8Z0Tfmco5S4DXnxF?=
 =?us-ascii?Q?5N5rA3n46wN8d/5jkI/S6wtYRLw8lovHGvWXw0VIkwFDvSagwpQjU1XW1nzS?=
 =?us-ascii?Q?qHlMSGIpfUfG2B75Q79kT7qoRw7RTXWk3zZa5G3XgRNRlEl93MUcGPkuIIMN?=
 =?us-ascii?Q?FMiRSJgNwjExgSBNkM/kwC4lRd9qSKiHroN9hubsNU+mou9o4+6TP6s1axNa?=
 =?us-ascii?Q?EbY9NIPkFqkWcYfnaJUelezKZa7QoteZF6wWJm2Ch6nCTOug4W5t?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d42a00c4-eba7-4190-138d-08da2d93c3d3
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 06:03:09.7691
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nQX9BgzFuFYOh0n0EhsXgJrbHR73CWKj5jicDRd7CgfjdqmamQg36d5W0TXIuyNEwGq6Vuq7C/mI806eaX9NeA==
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

The IPsec FS code was implemented with anti-pattern there failures
in create functions left the system with dangling pointers that were
cleaned in global routines.

The less error prone approach is to make sure that failed function
cleans everything internally.

As part of this change, we remove the batch of one liners and rewrite
get/put functions to remove ambiguity.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 229 ++++++------------
 1 file changed, 73 insertions(+), 156 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index 342828351254..9d95a0025fd6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -60,7 +60,7 @@ static int rx_err_add_rule(struct mlx5e_priv *priv,
 	struct mlx5_modify_hdr *modify_hdr;
 	struct mlx5_flow_handle *fte;
 	struct mlx5_flow_spec *spec;
-	int err = 0;
+	int err;
 
 	spec = kvzalloc(sizeof(*spec), GFP_KERNEL);
 	if (!spec)
@@ -96,101 +96,27 @@ static int rx_err_add_rule(struct mlx5e_priv *priv,
 		goto out;
 	}
 
+	kvfree(spec);
 	rx_err->rule = fte;
 	rx_err->copy_modify_hdr = modify_hdr;
+	return 0;
 
 out:
-	if (err)
-		mlx5_modify_header_dealloc(mdev, modify_hdr);
+	mlx5_modify_header_dealloc(mdev, modify_hdr);
 out_spec:
 	kvfree(spec);
 	return err;
 }
 
-static void rx_err_del_rule(struct mlx5e_priv *priv,
-			    struct mlx5e_ipsec_rx_err *rx_err)
-{
-	if (rx_err->rule) {
-		mlx5_del_flow_rules(rx_err->rule);
-		rx_err->rule = NULL;
-	}
-
-	if (rx_err->copy_modify_hdr) {
-		mlx5_modify_header_dealloc(priv->mdev, rx_err->copy_modify_hdr);
-		rx_err->copy_modify_hdr = NULL;
-	}
-}
-
-static void rx_err_destroy_ft(struct mlx5e_priv *priv, struct mlx5e_ipsec_rx_err *rx_err)
-{
-	rx_err_del_rule(priv, rx_err);
-
-	if (rx_err->ft) {
-		mlx5_destroy_flow_table(rx_err->ft);
-		rx_err->ft = NULL;
-	}
-}
-
-static int rx_err_create_ft(struct mlx5e_priv *priv,
-			    struct mlx5e_accel_fs_esp_prot *fs_prot,
-			    struct mlx5e_ipsec_rx_err *rx_err)
-{
-	struct mlx5_flow_table_attr ft_attr = {};
-	struct mlx5_flow_table *ft;
-	int err;
-
-	ft_attr.max_fte = 1;
-	ft_attr.autogroup.max_num_groups = 1;
-	ft_attr.level = MLX5E_ACCEL_FS_ESP_FT_ERR_LEVEL;
-	ft_attr.prio = MLX5E_NIC_PRIO;
-	ft = mlx5_create_auto_grouped_flow_table(priv->fs.ns, &ft_attr);
-	if (IS_ERR(ft)) {
-		err = PTR_ERR(ft);
-		netdev_err(priv->netdev, "fail to create ipsec rx inline ft err=%d\n", err);
-		return err;
-	}
-
-	rx_err->ft = ft;
-	err = rx_err_add_rule(priv, fs_prot, rx_err);
-	if (err)
-		goto out_err;
-
-	return 0;
-
-out_err:
-	mlx5_destroy_flow_table(ft);
-	rx_err->ft = NULL;
-	return err;
-}
-
-static void rx_fs_destroy(struct mlx5e_accel_fs_esp_prot *fs_prot)
-{
-	if (fs_prot->miss_rule) {
-		mlx5_del_flow_rules(fs_prot->miss_rule);
-		fs_prot->miss_rule = NULL;
-	}
-
-	if (fs_prot->miss_group) {
-		mlx5_destroy_flow_group(fs_prot->miss_group);
-		fs_prot->miss_group = NULL;
-	}
-
-	if (fs_prot->ft) {
-		mlx5_destroy_flow_table(fs_prot->ft);
-		fs_prot->ft = NULL;
-	}
-}
-
 static int rx_fs_create(struct mlx5e_priv *priv,
 			struct mlx5e_accel_fs_esp_prot *fs_prot)
 {
 	int inlen = MLX5_ST_SZ_BYTES(create_flow_group_in);
-	struct mlx5_flow_table_attr ft_attr = {};
+	struct mlx5_flow_table *ft = fs_prot->ft;
 	struct mlx5_flow_group *miss_group;
 	struct mlx5_flow_handle *miss_rule;
 	MLX5_DECLARE_FLOW_ACT(flow_act);
 	struct mlx5_flow_spec *spec;
-	struct mlx5_flow_table *ft;
 	u32 *flow_group_in;
 	int err = 0;
 
@@ -201,20 +127,6 @@ static int rx_fs_create(struct mlx5e_priv *priv,
 		goto out;
 	}
 
-	/* Create FT */
-	ft_attr.max_fte = NUM_IPSEC_FTE;
-	ft_attr.level = MLX5E_ACCEL_FS_ESP_FT_LEVEL;
-	ft_attr.prio = MLX5E_NIC_PRIO;
-	ft_attr.autogroup.num_reserved_entries = 1;
-	ft_attr.autogroup.max_num_groups = 1;
-	ft = mlx5_create_auto_grouped_flow_table(priv->fs.ns, &ft_attr);
-	if (IS_ERR(ft)) {
-		err = PTR_ERR(ft);
-		netdev_err(priv->netdev, "fail to create ipsec rx ft err=%d\n", err);
-		goto out;
-	}
-	fs_prot->ft = ft;
-
 	/* Create miss_group */
 	MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, ft->max_fte - 1);
 	MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index, ft->max_fte - 1);
@@ -229,19 +141,19 @@ static int rx_fs_create(struct mlx5e_priv *priv,
 	/* Create miss rule */
 	miss_rule = mlx5_add_flow_rules(ft, spec, &flow_act, &fs_prot->default_dest, 1);
 	if (IS_ERR(miss_rule)) {
+		mlx5_destroy_flow_group(fs_prot->miss_group);
 		err = PTR_ERR(miss_rule);
 		netdev_err(priv->netdev, "fail to create ipsec rx miss_rule err=%d\n", err);
 		goto out;
 	}
 	fs_prot->miss_rule = miss_rule;
-
 out:
 	kvfree(flow_group_in);
 	kvfree(spec);
 	return err;
 }
 
-static int rx_destroy(struct mlx5e_priv *priv, enum accel_fs_esp_type type)
+static void rx_destroy(struct mlx5e_priv *priv, enum accel_fs_esp_type type)
 {
 	struct mlx5e_accel_fs_esp_prot *fs_prot;
 	struct mlx5e_accel_fs_esp *accel_esp;
@@ -251,17 +163,21 @@ static int rx_destroy(struct mlx5e_priv *priv, enum accel_fs_esp_type type)
 	/* The netdev unreg already happened, so all offloaded rule are already removed */
 	fs_prot = &accel_esp->fs_prot[type];
 
-	rx_fs_destroy(fs_prot);
-
-	rx_err_destroy_ft(priv, &fs_prot->rx_err);
+	mlx5_del_flow_rules(fs_prot->miss_rule);
+	mlx5_destroy_flow_group(fs_prot->miss_group);
+	mlx5_destroy_flow_table(fs_prot->ft);
 
-	return 0;
+	mlx5_del_flow_rules(fs_prot->rx_err.rule);
+	mlx5_modify_header_dealloc(priv->mdev, fs_prot->rx_err.copy_modify_hdr);
+	mlx5_destroy_flow_table(fs_prot->rx_err.ft);
 }
 
 static int rx_create(struct mlx5e_priv *priv, enum accel_fs_esp_type type)
 {
+	struct mlx5_flow_table_attr ft_attr = {};
 	struct mlx5e_accel_fs_esp_prot *fs_prot;
 	struct mlx5e_accel_fs_esp *accel_esp;
+	struct mlx5_flow_table *ft;
 	int err;
 
 	accel_esp = priv->ipsec->rx_fs;
@@ -270,14 +186,45 @@ static int rx_create(struct mlx5e_priv *priv, enum accel_fs_esp_type type)
 	fs_prot->default_dest =
 		mlx5_ttc_get_default_dest(priv->fs.ttc, fs_esp2tt(type));
 
-	err = rx_err_create_ft(priv, fs_prot, &fs_prot->rx_err);
+	ft_attr.max_fte = 1;
+	ft_attr.autogroup.max_num_groups = 1;
+	ft_attr.level = MLX5E_ACCEL_FS_ESP_FT_ERR_LEVEL;
+	ft_attr.prio = MLX5E_NIC_PRIO;
+	ft = mlx5_create_auto_grouped_flow_table(priv->fs.ns, &ft_attr);
+	if (IS_ERR(ft))
+		return PTR_ERR(ft);
+
+	fs_prot->rx_err.ft = ft;
+	err = rx_err_add_rule(priv, fs_prot, &fs_prot->rx_err);
 	if (err)
-		return err;
+		goto err_add;
+
+	/* Create FT */
+	ft_attr.max_fte = NUM_IPSEC_FTE;
+	ft_attr.level = MLX5E_ACCEL_FS_ESP_FT_LEVEL;
+	ft_attr.prio = MLX5E_NIC_PRIO;
+	ft_attr.autogroup.num_reserved_entries = 1;
+	ft_attr.autogroup.max_num_groups = 1;
+	ft = mlx5_create_auto_grouped_flow_table(priv->fs.ns, &ft_attr);
+	if (IS_ERR(ft)) {
+		err = PTR_ERR(ft);
+		goto err_fs_ft;
+	}
+	fs_prot->ft = ft;
 
 	err = rx_fs_create(priv, fs_prot);
 	if (err)
-		rx_destroy(priv, type);
+		goto err_fs;
+
+	return 0;
 
+err_fs:
+	mlx5_destroy_flow_table(fs_prot->ft);
+err_fs_ft:
+	mlx5_del_flow_rules(fs_prot->rx_err.rule);
+	mlx5_modify_header_dealloc(priv->mdev, fs_prot->rx_err.copy_modify_hdr);
+err_add:
+	mlx5_destroy_flow_table(fs_prot->rx_err.ft);
 	return err;
 }
 
@@ -291,21 +238,21 @@ static int rx_ft_get(struct mlx5e_priv *priv, enum accel_fs_esp_type type)
 	accel_esp = priv->ipsec->rx_fs;
 	fs_prot = &accel_esp->fs_prot[type];
 	mutex_lock(&fs_prot->prot_mutex);
-	if (fs_prot->refcnt++)
-		goto out;
+	if (fs_prot->refcnt)
+		goto skip;
 
 	/* create FT */
 	err = rx_create(priv, type);
-	if (err) {
-		fs_prot->refcnt--;
+	if (err)
 		goto out;
-	}
 
 	/* connect */
 	dest.type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
 	dest.ft = fs_prot->ft;
 	mlx5_ttc_fwd_dest(priv->fs.ttc, fs_esp2tt(type), &dest);
 
+skip:
+	fs_prot->refcnt++;
 out:
 	mutex_unlock(&fs_prot->prot_mutex);
 	return err;
@@ -319,7 +266,8 @@ static void rx_ft_put(struct mlx5e_priv *priv, enum accel_fs_esp_type type)
 	accel_esp = priv->ipsec->rx_fs;
 	fs_prot = &accel_esp->fs_prot[type];
 	mutex_lock(&fs_prot->prot_mutex);
-	if (--fs_prot->refcnt)
+	fs_prot->refcnt--;
+	if (fs_prot->refcnt)
 		goto out;
 
 	/* disconnect */
@@ -352,32 +300,20 @@ static int tx_create(struct mlx5e_priv *priv)
 	return 0;
 }
 
-static void tx_destroy(struct mlx5e_priv *priv)
-{
-	struct mlx5e_ipsec *ipsec = priv->ipsec;
-
-	if (IS_ERR_OR_NULL(ipsec->tx_fs->ft))
-		return;
-
-	mlx5_destroy_flow_table(ipsec->tx_fs->ft);
-	ipsec->tx_fs->ft = NULL;
-}
-
 static int tx_ft_get(struct mlx5e_priv *priv)
 {
 	struct mlx5e_ipsec_tx *tx_fs = priv->ipsec->tx_fs;
 	int err = 0;
 
 	mutex_lock(&tx_fs->mutex);
-	if (tx_fs->refcnt++)
-		goto out;
+	if (tx_fs->refcnt)
+		goto skip;
 
 	err = tx_create(priv);
-	if (err) {
-		tx_fs->refcnt--;
+	if (err)
 		goto out;
-	}
-
+skip:
+	tx_fs->refcnt++;
 out:
 	mutex_unlock(&tx_fs->mutex);
 	return err;
@@ -388,11 +324,11 @@ static void tx_ft_put(struct mlx5e_priv *priv)
 	struct mlx5e_ipsec_tx *tx_fs = priv->ipsec->tx_fs;
 
 	mutex_lock(&tx_fs->mutex);
-	if (--tx_fs->refcnt)
+	tx_fs->refcnt--;
+	if (tx_fs->refcnt)
 		goto out;
 
-	tx_destroy(priv);
-
+	mlx5_destroy_flow_table(tx_fs->ft);
 out:
 	mutex_unlock(&tx_fs->mutex);
 }
@@ -579,32 +515,6 @@ static int tx_add_rule(struct mlx5e_priv *priv,
 	return err;
 }
 
-static void rx_del_rule(struct mlx5e_priv *priv,
-			struct mlx5e_ipsec_sa_entry *sa_entry)
-{
-	struct mlx5e_ipsec_rule *ipsec_rule = &sa_entry->ipsec_rule;
-
-	mlx5_del_flow_rules(ipsec_rule->rule);
-	ipsec_rule->rule = NULL;
-
-	mlx5_modify_header_dealloc(priv->mdev, ipsec_rule->set_modify_hdr);
-	ipsec_rule->set_modify_hdr = NULL;
-
-	rx_ft_put(priv,
-		  sa_entry->attrs.is_ipv6 ? ACCEL_FS_ESP6 : ACCEL_FS_ESP4);
-}
-
-static void tx_del_rule(struct mlx5e_priv *priv,
-			struct mlx5e_ipsec_sa_entry *sa_entry)
-{
-	struct mlx5e_ipsec_rule *ipsec_rule = &sa_entry->ipsec_rule;
-
-	mlx5_del_flow_rules(ipsec_rule->rule);
-	ipsec_rule->rule = NULL;
-
-	tx_ft_put(priv);
-}
-
 int mlx5e_accel_ipsec_fs_add_rule(struct mlx5e_priv *priv,
 				  struct mlx5e_ipsec_sa_entry *sa_entry)
 {
@@ -617,12 +527,19 @@ int mlx5e_accel_ipsec_fs_add_rule(struct mlx5e_priv *priv,
 void mlx5e_accel_ipsec_fs_del_rule(struct mlx5e_priv *priv,
 				   struct mlx5e_ipsec_sa_entry *sa_entry)
 {
+	struct mlx5e_ipsec_rule *ipsec_rule = &sa_entry->ipsec_rule;
+	struct mlx5_core_dev *mdev = mlx5e_ipsec_sa2dev(sa_entry);
+
+	mlx5_del_flow_rules(ipsec_rule->rule);
+
 	if (sa_entry->attrs.action == MLX5_ACCEL_ESP_ACTION_ENCRYPT) {
-		tx_del_rule(priv, sa_entry);
+		tx_ft_put(priv);
 		return;
 	}
 
-	rx_del_rule(priv, sa_entry);
+	mlx5_modify_header_dealloc(mdev, ipsec_rule->set_modify_hdr);
+	rx_ft_put(priv,
+		  sa_entry->attrs.is_ipv6 ? ACCEL_FS_ESP6 : ACCEL_FS_ESP4);
 }
 
 void mlx5e_accel_ipsec_fs_cleanup(struct mlx5e_ipsec *ipsec)
-- 
2.35.1

