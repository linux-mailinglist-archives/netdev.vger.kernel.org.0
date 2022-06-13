Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A9CC5491CF
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 18:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240998AbiFMPpa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 11:45:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241528AbiFMPpK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 11:45:10 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2078.outbound.protection.outlook.com [40.107.243.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2B9D16F345
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 06:22:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PAhMsYT4T3R5mlOQSFN6KlIKxZIj0OAWlpIV6lz8rzcT25IFR8FLD93vhYjmxAWAzwPHGGUMzn9BN5/l97dCf7kH6g3EK2gCDae63R7z7qYOqU/G6gRiF8eLVpi7xH+8yRwgCRccKm/au9jcnkC1/KVQ0oZneC0pvt32m22/ohYSlFp+PcALf+OTlgOLGGmUDeo3FYKUlXf1exiHbi0aP62IxRKChpkd/fkluJLp+lFO6EudQ+FsMAHthYaSysM9uMl4SmH2EiF0TxDvVYTCHLdoOz7F42I4wZGtuj92dAtkzlZekZCszd6wQ7FYq6O6JLUmvfgfDW0HfDJgMyGYnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CxKuhK+2MK8+XaUTANpiTcXC212Ft/CRRe9bU4tzgnA=;
 b=dkuFuTuevL8wAaTEgP9oY14ekYH9Tw6sDszsuXKRFGOzil0+c+syi5MdYm5V04d/magSTDXnQq4XIh7m1BMqOpmmWLBN1iXvf9sL5XGxP6L+exQo9Wz6W5LXXFocLagf3zjoQ3UgH4mBond58wCX7j4qJ3FpzzdqL3TIs3N2vEYxkvnG9J4VzJ5gEyhJRO+yTUHiZy03kyHDpPP0fkfilxRK/JgH7khW+bhEO79JY90Dy8tIjBBLit9JgjwRUC2mVJ7G1X+T5+ZKqJmWK12ck7Yk9SI5t8kUL52JzJxRwr4JhjJ1mF17Vkvnov/lB6iaOfmpkwlx8SUq/O2ChWl72A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CxKuhK+2MK8+XaUTANpiTcXC212Ft/CRRe9bU4tzgnA=;
 b=HAMfVwag2F6jv+vJ3x7z91kObJmGhl3fgFIM7UQTdlr9rLK7lYJbVd6Fuxw+wmqj2YY6KDbqP0fsOhv7eRXk8c7jGKkHm6J8UkINA+jdfwoybHlwcUKzldgD/8D0x5d4A6JcRBd3e/w4g+9/patDFSJgT9DGnlNqJAyBBVuY48taE3yp7M5UGjbEY6NCZyFg6C5DtpUa+w50X0qomPiAqAQQqI/KxJEjS4FGjTwb+A+FhynutnJlCy/m1PAbNV1UW36YW2aT5SiGHqT0mLLhldGWZ8vNJqBip0mFEArgeGMEx2RhNWQV2dvV+mBd8L97FeDgaqCpW5bJ8hqPn/5RZQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by BL1PR12MB5361.namprd12.prod.outlook.com (2603:10b6:208:31f::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13; Mon, 13 Jun
 2022 13:22:09 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190%7]) with mapi id 15.20.5332.020; Mon, 13 Jun 2022
 13:22:09 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 2/3] mlxsw: Revert "Prepare for XM implementation - prefix insertion and removal"
Date:   Mon, 13 Jun 2022 16:21:15 +0300
Message-Id: <20220613132116.2021055-3-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613132116.2021055-1-idosch@nvidia.com>
References: <20220613132116.2021055-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MR2P264CA0138.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:30::30) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 82bb529f-c3d1-4fb3-75a0-08da4d3fb81e
X-MS-TrafficTypeDiagnostic: BL1PR12MB5361:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB5361AB1F37FB8BAFAF55C7B0B2AB9@BL1PR12MB5361.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hrbtj0ixCKB8N4+jvPc0Qm647aiuBxcWFcvQGXWnrtG8Qa5FrXw1JegN3UesmrrMDPiFFWHkYKpyW8UwoyFwsUH3+uOZWWc7vPNfrmVZPIfad9F0toYdKlbQeZDQOMYBf7a5X8OGjcKKg1GL6EG+bVrifcLDflznRF0F7ahmGnZbzoazAcjfxz7fmVYB251etRBWwagpZTQp4wrS5h0cVYQSz4R7IcXk69PAvlnByAbBU4czsil7pUIl27ogaOEIpn8ri6RupGYT4wcKpsKlXNmIjrdFFXeau0WK41tI2FCbE4Pn5NckCI2LMLWd11ycAU2Gu+ZufcGlVsD3og/uCplr4+0r8LNBATkVTA/jW8g39xrDjfgtU8AHYvDXG910ZRV/Mi6Vq8alFtakycjzdyYaDqdvTjPByL+vTA/bCLs6YUbrEd6vJANaaxuKTWM44BnRfsdrJu+e+JkpvfjJqL6HeDWe7gGjO+1hcFRq0Paca6IcwxL5NW/ChkOr81cjaeFrqT/D7byNo/oTv5amGfePSZq1A+hvbpHysv5XydwG172N26y3yBG2xYtAUy2G26DQ1QTYunVxGDD8mdXtmmJUyn3BnFqOTyHBriK4pvdaFMnfJOn+gzxhutMFMsMODdi1WyZZ6hQwgq2mDV2N4Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(316002)(6916009)(36756003)(66476007)(4326008)(66946007)(38100700002)(2906002)(8676002)(107886003)(86362001)(6666004)(66556008)(66574015)(8936002)(6486002)(6512007)(2616005)(26005)(30864003)(5660300002)(6506007)(83380400001)(1076003)(508600001)(186003)(559001)(579004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wAzYGdQ4tZBTSkfSmrXVvjpNAJtifB+KUPc+A5ct2h3zHRjVBCTotN7NylcY?=
 =?us-ascii?Q?KyvQwACWEMJTU2y7/nw2Zv8QdM24vQOm3vSpmf525ifPmX+QwIuwf/oTACUP?=
 =?us-ascii?Q?kwNieVI8NNZpTuxkYAfOTrCdeU/FprOKXvMTUEBzBROQrPN2QN4AhE/NjT8T?=
 =?us-ascii?Q?An4+5D6grDmNh40PSwqKUk6y/BlZYoQ60UYlRS6yTulkly9JaGyQpbu+H/Z2?=
 =?us-ascii?Q?v/cGuCVwmMYSUaZQYV2caltu0GjbXFDa27XoSQqsWjGvgQOVBQQo8tGFQ6zn?=
 =?us-ascii?Q?ltIXIve+Bb3p+KdBdEGVbQA/sQxwfvABR5/24I2oXuuEoMCF76dkk5zVJRt7?=
 =?us-ascii?Q?3YXOBtQWma8voi+1Nw4rjGtHxKOTLQPUzK9PAu98vWGBYg0mw9HwdnLAUyzw?=
 =?us-ascii?Q?GwMbonFJDfD4KExubFXDReaQTMw8FHfgq+ZHRZbb5elgMTQDMXahQPC+D4Ef?=
 =?us-ascii?Q?IFLdhf0BtnMyteL3rQ9aBxODtQmMrC5Xm15gczcInogvCi/Quzduhbk5Busa?=
 =?us-ascii?Q?8MuRTC2zCBVkpb6LSLMX/3sFrtv4GC2S/HQJdDEi2I618m4tJYlNLZnDTLg4?=
 =?us-ascii?Q?i4DMgz0RO8w0dDXCQWHdSwPL6jHVTmIcRp3/IlCG5A7mXOpDC/g+UdQ6PlIK?=
 =?us-ascii?Q?hBgL/wMt1Pe0PjQPcZEzWVtk50sfY5DaYPXRvVXLaQDl5/tja8NbIn6LxVph?=
 =?us-ascii?Q?nA6AeGtVQ0OUKumeRVC9njd8I4uPvyZWRsBPIYQ0isK7dHvvR/ZrfZZEbcHK?=
 =?us-ascii?Q?Jbp2YL6/X1P0TtR0FsFPPZbEwiURaozr2qse4dM6H/Wuag9iSAMQ3YoINVd6?=
 =?us-ascii?Q?VIb7GcOPcxi22rl7mksjou8yJ8OTPl8LnSAOvoxpZciLS2rRLJrtMXRD81B3?=
 =?us-ascii?Q?JSQFBoVCdQvRmzlDiKhZTfucNmXovGZT2kJdwLrS5uergL3oOGyDIIT/qnZG?=
 =?us-ascii?Q?82M9bkvhnagpobDB15w7/oYAg982lfVYc5+tnilwbjuiAzTUAPXiZE6qFCbD?=
 =?us-ascii?Q?tXS1X/X/1b/1vSEKKnqUS1p92xjvtVFKZxxawvDU1l3EvB58rAKxDhhG/cYh?=
 =?us-ascii?Q?AXlgjivuRVW3Fm+qnYhIrRcGLokVm67q7cGKRIHfVJuywGj98nymqDNEOppw?=
 =?us-ascii?Q?u60JEv/YB9o3+IGytVxNjS2aPm/JrDcYKue+MP2inzkKEiHx6tzBG5TtUc6i?=
 =?us-ascii?Q?QKueGwVENmBwyVkyTyhkpJH4dItxcqWTKd/e50j1v2mI8Uxa+BfkRsZ5b974?=
 =?us-ascii?Q?ZJWnqzdycOsahm4ehc8MSfZ+BY6xlfpDbxDREa8Xui4RNgKGlL8Qu9RiuLZg?=
 =?us-ascii?Q?hZ0js9vE2rcKpDDUDqFfit0cuCnG0ofkZNaPfMoM2N4wtAEagj5sQIPFwsBy?=
 =?us-ascii?Q?0cqXArmY409qcPDAuahWMprrxQoRlAUrwge7ggdYwTPt2pKK1NUbGvZkGdtL?=
 =?us-ascii?Q?pcM/ACQNzRcdnUJLLUU68PNH0Fh7KGWy5zxE2vjBFu34/xIBbg5xnE75oCQt?=
 =?us-ascii?Q?j69FOhobxrecTICQH4xXYaJpmmCfA7HHqtPnQNeWHSsnrzOVcahn/Isto0pK?=
 =?us-ascii?Q?7XOgc4y2zD4pZ/MEnkwfbtzpeYDdF2MBw+JQpKIQckrCZcbcfWb93ZZ6bOkK?=
 =?us-ascii?Q?Ndl/JMIdUtgQF51o7+MuW3s4SCPSPr8MMNVPXz71PlvSYcq0E5OmZkTkyqmQ?=
 =?us-ascii?Q?tM+2gXhwZn/oGcUUcfe9+TbUH05S0CaIqaK68/PYPyZ9ZQkHD+V2ipKf9kz3?=
 =?us-ascii?Q?ULypoTyBLg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82bb529f-c3d1-4fb3-75a0-08da4d3fb81e
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2022 13:22:09.5972
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 71XmGuoK3tTcLxvrfJqQBVztUOmhKc+FD0P/4VvhTeBO1JGGx6ozvSkaxbn18NzcsgAVQRXhBPdjBLsVg7Ml+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5361
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

This reverts commit e7086213f7b4 ("Merge branch
'mlxsw-spectrum-prepare-for-xm-implementation-prefix-insertion-and-removal'").

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h     |   8 +-
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 736 +++++-------------
 .../ethernet/mellanox/mlxsw/spectrum_router.h |  54 --
 3 files changed, 209 insertions(+), 589 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index de7718b5c21a..d1a94c22ee60 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -7848,11 +7848,10 @@ static inline void mlxsw_reg_ralue_pack4(char *payload,
 					 enum mlxsw_reg_ralxx_protocol protocol,
 					 enum mlxsw_reg_ralue_op op,
 					 u16 virtual_router, u8 prefix_len,
-					 u32 *dip)
+					 u32 dip)
 {
 	mlxsw_reg_ralue_pack(payload, protocol, op, virtual_router, prefix_len);
-	if (dip)
-		mlxsw_reg_ralue_dip4_set(payload, *dip);
+	mlxsw_reg_ralue_dip4_set(payload, dip);
 }
 
 static inline void mlxsw_reg_ralue_pack6(char *payload,
@@ -7862,8 +7861,7 @@ static inline void mlxsw_reg_ralue_pack6(char *payload,
 					 const void *dip)
 {
 	mlxsw_reg_ralue_pack(payload, protocol, op, virtual_router, prefix_len);
-	if (dip)
-		mlxsw_reg_ralue_dip6_memcpy_to(payload, dip);
+	mlxsw_reg_ralue_dip6_memcpy_to(payload, dip);
 }
 
 static inline void
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 31984c704cd9..1b389e4ad3af 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -443,65 +443,12 @@ struct mlxsw_sp_fib_entry_decap {
 	u32 tunnel_index;
 };
 
-static struct mlxsw_sp_fib_entry_priv *
-mlxsw_sp_fib_entry_priv_create(const struct mlxsw_sp_router_ll_ops *ll_ops)
-{
-	struct mlxsw_sp_fib_entry_priv *priv;
-
-	if (!ll_ops->fib_entry_priv_size)
-		/* No need to have priv */
-		return NULL;
-
-	priv = kzalloc(sizeof(*priv) + ll_ops->fib_entry_priv_size, GFP_KERNEL);
-	if (!priv)
-		return ERR_PTR(-ENOMEM);
-	refcount_set(&priv->refcnt, 1);
-	return priv;
-}
-
-static void
-mlxsw_sp_fib_entry_priv_destroy(struct mlxsw_sp_fib_entry_priv *priv)
-{
-	kfree(priv);
-}
-
-static void mlxsw_sp_fib_entry_priv_hold(struct mlxsw_sp_fib_entry_priv *priv)
-{
-	refcount_inc(&priv->refcnt);
-}
-
-static void mlxsw_sp_fib_entry_priv_put(struct mlxsw_sp_fib_entry_priv *priv)
-{
-	if (!priv || !refcount_dec_and_test(&priv->refcnt))
-		return;
-	mlxsw_sp_fib_entry_priv_destroy(priv);
-}
-
-static void mlxsw_sp_fib_entry_op_ctx_priv_hold(struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
-						struct mlxsw_sp_fib_entry_priv *priv)
-{
-	if (!priv)
-		return;
-	mlxsw_sp_fib_entry_priv_hold(priv);
-	list_add(&priv->list, &op_ctx->fib_entry_priv_list);
-}
-
-static void mlxsw_sp_fib_entry_op_ctx_priv_put_all(struct mlxsw_sp_fib_entry_op_ctx *op_ctx)
-{
-	struct mlxsw_sp_fib_entry_priv *priv, *tmp;
-
-	list_for_each_entry_safe(priv, tmp, &op_ctx->fib_entry_priv_list, list)
-		mlxsw_sp_fib_entry_priv_put(priv);
-	INIT_LIST_HEAD(&op_ctx->fib_entry_priv_list);
-}
-
 struct mlxsw_sp_fib_entry {
 	struct mlxsw_sp_fib_node *fib_node;
 	enum mlxsw_sp_fib_entry_type type;
 	struct list_head nexthop_group_node;
 	struct mlxsw_sp_nexthop_group *nh_group;
 	struct mlxsw_sp_fib_entry_decap decap; /* Valid for decap entries. */
-	struct mlxsw_sp_fib_entry_priv *priv;
 };
 
 struct mlxsw_sp_fib4_entry {
@@ -5768,14 +5715,13 @@ mlxsw_sp_fib_entry_hw_flags_clear(struct mlxsw_sp *mlxsw_sp,
 static void
 mlxsw_sp_fib_entry_hw_flags_refresh(struct mlxsw_sp *mlxsw_sp,
 				    struct mlxsw_sp_fib_entry *fib_entry,
-				    enum mlxsw_sp_fib_entry_op op)
+				    enum mlxsw_reg_ralue_op op)
 {
 	switch (op) {
-	case MLXSW_SP_FIB_ENTRY_OP_WRITE:
-	case MLXSW_SP_FIB_ENTRY_OP_UPDATE:
+	case MLXSW_REG_RALUE_OP_WRITE_WRITE:
 		mlxsw_sp_fib_entry_hw_flags_set(mlxsw_sp, fib_entry);
 		break;
-	case MLXSW_SP_FIB_ENTRY_OP_DELETE:
+	case MLXSW_REG_RALUE_OP_WRITE_DELETE:
 		mlxsw_sp_fib_entry_hw_flags_clear(mlxsw_sp, fib_entry);
 		break;
 	default:
@@ -5783,140 +5729,39 @@ mlxsw_sp_fib_entry_hw_flags_refresh(struct mlxsw_sp *mlxsw_sp,
 	}
 }
 
-struct mlxsw_sp_fib_entry_op_ctx_basic {
-	char ralue_pl[MLXSW_REG_RALUE_LEN];
-};
-
 static void
-mlxsw_sp_router_ll_basic_fib_entry_pack(struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
-					enum mlxsw_sp_l3proto proto,
-					enum mlxsw_sp_fib_entry_op op,
-					u16 virtual_router, u8 prefix_len,
-					unsigned char *addr,
-					struct mlxsw_sp_fib_entry_priv *priv)
+mlxsw_sp_fib_entry_ralue_pack(char *ralue_pl,
+			      const struct mlxsw_sp_fib_entry *fib_entry,
+			      enum mlxsw_reg_ralue_op op)
 {
-	struct mlxsw_sp_fib_entry_op_ctx_basic *op_ctx_basic = (void *) op_ctx->ll_priv;
-	enum mlxsw_reg_ralxx_protocol ralxx_proto;
-	char *ralue_pl = op_ctx_basic->ralue_pl;
-	enum mlxsw_reg_ralue_op ralue_op;
+	struct mlxsw_sp_fib *fib = fib_entry->fib_node->fib;
+	enum mlxsw_reg_ralxx_protocol proto;
+	u32 *p_dip;
 
-	ralxx_proto = (enum mlxsw_reg_ralxx_protocol) proto;
+	proto = (enum mlxsw_reg_ralxx_protocol) fib->proto;
 
-	switch (op) {
-	case MLXSW_SP_FIB_ENTRY_OP_WRITE:
-	case MLXSW_SP_FIB_ENTRY_OP_UPDATE:
-		ralue_op = MLXSW_REG_RALUE_OP_WRITE_WRITE;
-		break;
-	case MLXSW_SP_FIB_ENTRY_OP_DELETE:
-		ralue_op = MLXSW_REG_RALUE_OP_WRITE_DELETE;
-		break;
-	default:
-		WARN_ON_ONCE(1);
-		return;
-	}
-
-	switch (proto) {
+	switch (fib->proto) {
 	case MLXSW_SP_L3_PROTO_IPV4:
-		mlxsw_reg_ralue_pack4(ralue_pl, ralxx_proto, ralue_op,
-				      virtual_router, prefix_len, (u32 *) addr);
+		p_dip = (u32 *) fib_entry->fib_node->key.addr;
+		mlxsw_reg_ralue_pack4(ralue_pl, proto, op, fib->vr->id,
+				      fib_entry->fib_node->key.prefix_len,
+				      *p_dip);
 		break;
 	case MLXSW_SP_L3_PROTO_IPV6:
-		mlxsw_reg_ralue_pack6(ralue_pl, ralxx_proto, ralue_op,
-				      virtual_router, prefix_len, addr);
+		mlxsw_reg_ralue_pack6(ralue_pl, proto, op, fib->vr->id,
+				      fib_entry->fib_node->key.prefix_len,
+				      fib_entry->fib_node->key.addr);
 		break;
 	}
 }
 
-static void
-mlxsw_sp_router_ll_basic_fib_entry_act_remote_pack(struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
-						   enum mlxsw_reg_ralue_trap_action trap_action,
-						   u16 trap_id, u32 adjacency_index, u16 ecmp_size)
-{
-	struct mlxsw_sp_fib_entry_op_ctx_basic *op_ctx_basic = (void *) op_ctx->ll_priv;
-
-	mlxsw_reg_ralue_act_remote_pack(op_ctx_basic->ralue_pl, trap_action,
-					trap_id, adjacency_index, ecmp_size);
-}
-
-static void
-mlxsw_sp_router_ll_basic_fib_entry_act_local_pack(struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
-						  enum mlxsw_reg_ralue_trap_action trap_action,
-						  u16 trap_id, u16 local_erif)
-{
-	struct mlxsw_sp_fib_entry_op_ctx_basic *op_ctx_basic = (void *) op_ctx->ll_priv;
-
-	mlxsw_reg_ralue_act_local_pack(op_ctx_basic->ralue_pl, trap_action,
-				       trap_id, local_erif);
-}
-
-static void
-mlxsw_sp_router_ll_basic_fib_entry_act_ip2me_pack(struct mlxsw_sp_fib_entry_op_ctx *op_ctx)
-{
-	struct mlxsw_sp_fib_entry_op_ctx_basic *op_ctx_basic = (void *) op_ctx->ll_priv;
-
-	mlxsw_reg_ralue_act_ip2me_pack(op_ctx_basic->ralue_pl);
-}
-
-static void
-mlxsw_sp_router_ll_basic_fib_entry_act_ip2me_tun_pack(struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
-						      u32 tunnel_ptr)
-{
-	struct mlxsw_sp_fib_entry_op_ctx_basic *op_ctx_basic = (void *) op_ctx->ll_priv;
-
-	mlxsw_reg_ralue_act_ip2me_tun_pack(op_ctx_basic->ralue_pl, tunnel_ptr);
-}
-
-static int
-mlxsw_sp_router_ll_basic_fib_entry_commit(struct mlxsw_sp *mlxsw_sp,
-					  struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
-					  bool *postponed_for_bulk)
-{
-	struct mlxsw_sp_fib_entry_op_ctx_basic *op_ctx_basic = (void *) op_ctx->ll_priv;
-
-	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(ralue),
-			       op_ctx_basic->ralue_pl);
-}
-
-static bool
-mlxsw_sp_router_ll_basic_fib_entry_is_committed(struct mlxsw_sp_fib_entry_priv *priv)
-{
-	return true;
-}
-
-static void mlxsw_sp_fib_entry_pack(struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
-				    struct mlxsw_sp_fib_entry *fib_entry,
-				    enum mlxsw_sp_fib_entry_op op)
-{
-	struct mlxsw_sp_fib *fib = fib_entry->fib_node->fib;
-
-	mlxsw_sp_fib_entry_op_ctx_priv_hold(op_ctx, fib_entry->priv);
-	fib->ll_ops->fib_entry_pack(op_ctx, fib->proto, op, fib->vr->id,
-				    fib_entry->fib_node->key.prefix_len,
-				    fib_entry->fib_node->key.addr,
-				    fib_entry->priv);
-}
-
-static int mlxsw_sp_fib_entry_commit(struct mlxsw_sp *mlxsw_sp,
-				     struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
-				     const struct mlxsw_sp_router_ll_ops *ll_ops)
-{
-	bool postponed_for_bulk = false;
-	int err;
-
-	err = ll_ops->fib_entry_commit(mlxsw_sp, op_ctx, &postponed_for_bulk);
-	if (!postponed_for_bulk)
-		mlxsw_sp_fib_entry_op_ctx_priv_put_all(op_ctx);
-	return err;
-}
-
 static int mlxsw_sp_fib_entry_op_remote(struct mlxsw_sp *mlxsw_sp,
-					struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
 					struct mlxsw_sp_fib_entry *fib_entry,
-					enum mlxsw_sp_fib_entry_op op)
+					enum mlxsw_reg_ralue_op op)
 {
-	const struct mlxsw_sp_router_ll_ops *ll_ops = fib_entry->fib_node->fib->ll_ops;
 	struct mlxsw_sp_nexthop_group *nh_group = fib_entry->nh_group;
 	struct mlxsw_sp_nexthop_group_info *nhgi = nh_group->nhgi;
+	char ralue_pl[MLXSW_REG_RALUE_LEN];
 	enum mlxsw_reg_ralue_trap_action trap_action;
 	u16 trap_id = 0;
 	u32 adjacency_index = 0;
@@ -5939,20 +5784,19 @@ static int mlxsw_sp_fib_entry_op_remote(struct mlxsw_sp *mlxsw_sp,
 		trap_id = MLXSW_TRAP_ID_RTR_INGRESS0;
 	}
 
-	mlxsw_sp_fib_entry_pack(op_ctx, fib_entry, op);
-	ll_ops->fib_entry_act_remote_pack(op_ctx, trap_action, trap_id,
-					  adjacency_index, ecmp_size);
-	return mlxsw_sp_fib_entry_commit(mlxsw_sp, op_ctx, ll_ops);
+	mlxsw_sp_fib_entry_ralue_pack(ralue_pl, fib_entry, op);
+	mlxsw_reg_ralue_act_remote_pack(ralue_pl, trap_action, trap_id,
+					adjacency_index, ecmp_size);
+	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(ralue), ralue_pl);
 }
 
 static int mlxsw_sp_fib_entry_op_local(struct mlxsw_sp *mlxsw_sp,
-				       struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
 				       struct mlxsw_sp_fib_entry *fib_entry,
-				       enum mlxsw_sp_fib_entry_op op)
+				       enum mlxsw_reg_ralue_op op)
 {
-	const struct mlxsw_sp_router_ll_ops *ll_ops = fib_entry->fib_node->fib->ll_ops;
 	struct mlxsw_sp_rif *rif = fib_entry->nh_group->nhgi->nh_rif;
 	enum mlxsw_reg_ralue_trap_action trap_action;
+	char ralue_pl[MLXSW_REG_RALUE_LEN];
 	u16 trap_id = 0;
 	u16 rif_index = 0;
 
@@ -5964,64 +5808,61 @@ static int mlxsw_sp_fib_entry_op_local(struct mlxsw_sp *mlxsw_sp,
 		trap_id = MLXSW_TRAP_ID_RTR_INGRESS0;
 	}
 
-	mlxsw_sp_fib_entry_pack(op_ctx, fib_entry, op);
-	ll_ops->fib_entry_act_local_pack(op_ctx, trap_action, trap_id, rif_index);
-	return mlxsw_sp_fib_entry_commit(mlxsw_sp, op_ctx, ll_ops);
+	mlxsw_sp_fib_entry_ralue_pack(ralue_pl, fib_entry, op);
+	mlxsw_reg_ralue_act_local_pack(ralue_pl, trap_action, trap_id,
+				       rif_index);
+	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(ralue), ralue_pl);
 }
 
 static int mlxsw_sp_fib_entry_op_trap(struct mlxsw_sp *mlxsw_sp,
-				      struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
 				      struct mlxsw_sp_fib_entry *fib_entry,
-				      enum mlxsw_sp_fib_entry_op op)
+				      enum mlxsw_reg_ralue_op op)
 {
-	const struct mlxsw_sp_router_ll_ops *ll_ops = fib_entry->fib_node->fib->ll_ops;
+	char ralue_pl[MLXSW_REG_RALUE_LEN];
 
-	mlxsw_sp_fib_entry_pack(op_ctx, fib_entry, op);
-	ll_ops->fib_entry_act_ip2me_pack(op_ctx);
-	return mlxsw_sp_fib_entry_commit(mlxsw_sp, op_ctx, ll_ops);
+	mlxsw_sp_fib_entry_ralue_pack(ralue_pl, fib_entry, op);
+	mlxsw_reg_ralue_act_ip2me_pack(ralue_pl);
+	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(ralue), ralue_pl);
 }
 
 static int mlxsw_sp_fib_entry_op_blackhole(struct mlxsw_sp *mlxsw_sp,
-					   struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
 					   struct mlxsw_sp_fib_entry *fib_entry,
-					   enum mlxsw_sp_fib_entry_op op)
+					   enum mlxsw_reg_ralue_op op)
 {
-	const struct mlxsw_sp_router_ll_ops *ll_ops = fib_entry->fib_node->fib->ll_ops;
 	enum mlxsw_reg_ralue_trap_action trap_action;
+	char ralue_pl[MLXSW_REG_RALUE_LEN];
 
 	trap_action = MLXSW_REG_RALUE_TRAP_ACTION_DISCARD_ERROR;
-	mlxsw_sp_fib_entry_pack(op_ctx, fib_entry, op);
-	ll_ops->fib_entry_act_local_pack(op_ctx, trap_action, 0, 0);
-	return mlxsw_sp_fib_entry_commit(mlxsw_sp, op_ctx, ll_ops);
+	mlxsw_sp_fib_entry_ralue_pack(ralue_pl, fib_entry, op);
+	mlxsw_reg_ralue_act_local_pack(ralue_pl, trap_action, 0, 0);
+	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(ralue), ralue_pl);
 }
 
 static int
 mlxsw_sp_fib_entry_op_unreachable(struct mlxsw_sp *mlxsw_sp,
-				  struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
 				  struct mlxsw_sp_fib_entry *fib_entry,
-				  enum mlxsw_sp_fib_entry_op op)
+				  enum mlxsw_reg_ralue_op op)
 {
-	const struct mlxsw_sp_router_ll_ops *ll_ops = fib_entry->fib_node->fib->ll_ops;
 	enum mlxsw_reg_ralue_trap_action trap_action;
+	char ralue_pl[MLXSW_REG_RALUE_LEN];
 	u16 trap_id;
 
 	trap_action = MLXSW_REG_RALUE_TRAP_ACTION_TRAP;
 	trap_id = MLXSW_TRAP_ID_RTR_INGRESS1;
 
-	mlxsw_sp_fib_entry_pack(op_ctx, fib_entry, op);
-	ll_ops->fib_entry_act_local_pack(op_ctx, trap_action, trap_id, 0);
-	return mlxsw_sp_fib_entry_commit(mlxsw_sp, op_ctx, ll_ops);
+	mlxsw_sp_fib_entry_ralue_pack(ralue_pl, fib_entry, op);
+	mlxsw_reg_ralue_act_local_pack(ralue_pl, trap_action, trap_id, 0);
+	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(ralue), ralue_pl);
 }
 
 static int
 mlxsw_sp_fib_entry_op_ipip_decap(struct mlxsw_sp *mlxsw_sp,
-				 struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
 				 struct mlxsw_sp_fib_entry *fib_entry,
-				 enum mlxsw_sp_fib_entry_op op)
+				 enum mlxsw_reg_ralue_op op)
 {
-	const struct mlxsw_sp_router_ll_ops *ll_ops = fib_entry->fib_node->fib->ll_ops;
 	struct mlxsw_sp_ipip_entry *ipip_entry = fib_entry->decap.ipip_entry;
 	const struct mlxsw_sp_ipip_ops *ipip_ops;
+	char ralue_pl[MLXSW_REG_RALUE_LEN];
 	int err;
 
 	if (WARN_ON(!ipip_entry))
@@ -6033,55 +5874,54 @@ mlxsw_sp_fib_entry_op_ipip_decap(struct mlxsw_sp *mlxsw_sp,
 	if (err)
 		return err;
 
-	mlxsw_sp_fib_entry_pack(op_ctx, fib_entry, op);
-	ll_ops->fib_entry_act_ip2me_tun_pack(op_ctx,
-					     fib_entry->decap.tunnel_index);
-	return mlxsw_sp_fib_entry_commit(mlxsw_sp, op_ctx, ll_ops);
+	mlxsw_sp_fib_entry_ralue_pack(ralue_pl, fib_entry, op);
+	mlxsw_reg_ralue_act_ip2me_tun_pack(ralue_pl,
+					   fib_entry->decap.tunnel_index);
+	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(ralue), ralue_pl);
 }
 
 static int mlxsw_sp_fib_entry_op_nve_decap(struct mlxsw_sp *mlxsw_sp,
-					   struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
 					   struct mlxsw_sp_fib_entry *fib_entry,
-					   enum mlxsw_sp_fib_entry_op op)
+					   enum mlxsw_reg_ralue_op op)
 {
-	const struct mlxsw_sp_router_ll_ops *ll_ops = fib_entry->fib_node->fib->ll_ops;
+	char ralue_pl[MLXSW_REG_RALUE_LEN];
 
-	mlxsw_sp_fib_entry_pack(op_ctx, fib_entry, op);
-	ll_ops->fib_entry_act_ip2me_tun_pack(op_ctx,
-					     fib_entry->decap.tunnel_index);
-	return mlxsw_sp_fib_entry_commit(mlxsw_sp, op_ctx, ll_ops);
+	mlxsw_sp_fib_entry_ralue_pack(ralue_pl, fib_entry, op);
+	mlxsw_reg_ralue_act_ip2me_tun_pack(ralue_pl,
+					   fib_entry->decap.tunnel_index);
+	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(ralue), ralue_pl);
 }
 
 static int __mlxsw_sp_fib_entry_op(struct mlxsw_sp *mlxsw_sp,
-				   struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
 				   struct mlxsw_sp_fib_entry *fib_entry,
-				   enum mlxsw_sp_fib_entry_op op)
+				   enum mlxsw_reg_ralue_op op)
 {
 	switch (fib_entry->type) {
 	case MLXSW_SP_FIB_ENTRY_TYPE_REMOTE:
-		return mlxsw_sp_fib_entry_op_remote(mlxsw_sp, op_ctx, fib_entry, op);
+		return mlxsw_sp_fib_entry_op_remote(mlxsw_sp, fib_entry, op);
 	case MLXSW_SP_FIB_ENTRY_TYPE_LOCAL:
-		return mlxsw_sp_fib_entry_op_local(mlxsw_sp, op_ctx, fib_entry, op);
+		return mlxsw_sp_fib_entry_op_local(mlxsw_sp, fib_entry, op);
 	case MLXSW_SP_FIB_ENTRY_TYPE_TRAP:
-		return mlxsw_sp_fib_entry_op_trap(mlxsw_sp, op_ctx, fib_entry, op);
+		return mlxsw_sp_fib_entry_op_trap(mlxsw_sp, fib_entry, op);
 	case MLXSW_SP_FIB_ENTRY_TYPE_BLACKHOLE:
-		return mlxsw_sp_fib_entry_op_blackhole(mlxsw_sp, op_ctx, fib_entry, op);
+		return mlxsw_sp_fib_entry_op_blackhole(mlxsw_sp, fib_entry, op);
 	case MLXSW_SP_FIB_ENTRY_TYPE_UNREACHABLE:
-		return mlxsw_sp_fib_entry_op_unreachable(mlxsw_sp, op_ctx, fib_entry, op);
+		return mlxsw_sp_fib_entry_op_unreachable(mlxsw_sp, fib_entry,
+							 op);
 	case MLXSW_SP_FIB_ENTRY_TYPE_IPIP_DECAP:
-		return mlxsw_sp_fib_entry_op_ipip_decap(mlxsw_sp, op_ctx, fib_entry, op);
+		return mlxsw_sp_fib_entry_op_ipip_decap(mlxsw_sp,
+							fib_entry, op);
 	case MLXSW_SP_FIB_ENTRY_TYPE_NVE_DECAP:
-		return mlxsw_sp_fib_entry_op_nve_decap(mlxsw_sp, op_ctx, fib_entry, op);
+		return mlxsw_sp_fib_entry_op_nve_decap(mlxsw_sp, fib_entry, op);
 	}
 	return -EINVAL;
 }
 
 static int mlxsw_sp_fib_entry_op(struct mlxsw_sp *mlxsw_sp,
-				 struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
 				 struct mlxsw_sp_fib_entry *fib_entry,
-				 enum mlxsw_sp_fib_entry_op op)
+				 enum mlxsw_reg_ralue_op op)
 {
-	int err = __mlxsw_sp_fib_entry_op(mlxsw_sp, op_ctx, fib_entry, op);
+	int err = __mlxsw_sp_fib_entry_op(mlxsw_sp, fib_entry, op);
 
 	if (err)
 		return err;
@@ -6091,35 +5931,18 @@ static int mlxsw_sp_fib_entry_op(struct mlxsw_sp *mlxsw_sp,
 	return err;
 }
 
-static int __mlxsw_sp_fib_entry_update(struct mlxsw_sp *mlxsw_sp,
-				       struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
-				       struct mlxsw_sp_fib_entry *fib_entry,
-				       bool is_new)
-{
-	return mlxsw_sp_fib_entry_op(mlxsw_sp, op_ctx, fib_entry,
-				     is_new ? MLXSW_SP_FIB_ENTRY_OP_WRITE :
-					      MLXSW_SP_FIB_ENTRY_OP_UPDATE);
-}
-
 static int mlxsw_sp_fib_entry_update(struct mlxsw_sp *mlxsw_sp,
 				     struct mlxsw_sp_fib_entry *fib_entry)
 {
-	struct mlxsw_sp_fib_entry_op_ctx *op_ctx = mlxsw_sp->router->ll_op_ctx;
-
-	mlxsw_sp_fib_entry_op_ctx_clear(op_ctx);
-	return __mlxsw_sp_fib_entry_update(mlxsw_sp, op_ctx, fib_entry, false);
+	return mlxsw_sp_fib_entry_op(mlxsw_sp, fib_entry,
+				     MLXSW_REG_RALUE_OP_WRITE_WRITE);
 }
 
 static int mlxsw_sp_fib_entry_del(struct mlxsw_sp *mlxsw_sp,
-				  struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
 				  struct mlxsw_sp_fib_entry *fib_entry)
 {
-	const struct mlxsw_sp_router_ll_ops *ll_ops = fib_entry->fib_node->fib->ll_ops;
-
-	if (!ll_ops->fib_entry_is_committed(fib_entry->priv))
-		return 0;
-	return mlxsw_sp_fib_entry_op(mlxsw_sp, op_ctx, fib_entry,
-				     MLXSW_SP_FIB_ENTRY_OP_DELETE);
+	return mlxsw_sp_fib_entry_op(mlxsw_sp, fib_entry,
+				     MLXSW_REG_RALUE_OP_WRITE_DELETE);
 }
 
 static int
@@ -6214,12 +6037,6 @@ mlxsw_sp_fib4_entry_create(struct mlxsw_sp *mlxsw_sp,
 		return ERR_PTR(-ENOMEM);
 	fib_entry = &fib4_entry->common;
 
-	fib_entry->priv = mlxsw_sp_fib_entry_priv_create(fib_node->fib->ll_ops);
-	if (IS_ERR(fib_entry->priv)) {
-		err = PTR_ERR(fib_entry->priv);
-		goto err_fib_entry_priv_create;
-	}
-
 	err = mlxsw_sp_nexthop4_group_get(mlxsw_sp, fib_entry, fen_info->fi);
 	if (err)
 		goto err_nexthop4_group_get;
@@ -6248,8 +6065,6 @@ mlxsw_sp_fib4_entry_create(struct mlxsw_sp *mlxsw_sp,
 err_nexthop_group_vr_link:
 	mlxsw_sp_nexthop4_group_put(mlxsw_sp, &fib4_entry->common);
 err_nexthop4_group_get:
-	mlxsw_sp_fib_entry_priv_put(fib_entry->priv);
-err_fib_entry_priv_create:
 	kfree(fib4_entry);
 	return ERR_PTR(err);
 }
@@ -6264,7 +6079,6 @@ static void mlxsw_sp_fib4_entry_destroy(struct mlxsw_sp *mlxsw_sp,
 	mlxsw_sp_nexthop_group_vr_unlink(fib4_entry->common.nh_group,
 					 fib_node->fib);
 	mlxsw_sp_nexthop4_group_put(mlxsw_sp, &fib4_entry->common);
-	mlxsw_sp_fib_entry_priv_put(fib4_entry->common.priv);
 	kfree(fib4_entry);
 }
 
@@ -6502,16 +6316,14 @@ static void mlxsw_sp_fib_node_put(struct mlxsw_sp *mlxsw_sp,
 }
 
 static int mlxsw_sp_fib_node_entry_link(struct mlxsw_sp *mlxsw_sp,
-					struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
 					struct mlxsw_sp_fib_entry *fib_entry)
 {
 	struct mlxsw_sp_fib_node *fib_node = fib_entry->fib_node;
-	bool is_new = !fib_node->fib_entry;
 	int err;
 
 	fib_node->fib_entry = fib_entry;
 
-	err = __mlxsw_sp_fib_entry_update(mlxsw_sp, op_ctx, fib_entry, is_new);
+	err = mlxsw_sp_fib_entry_update(mlxsw_sp, fib_entry);
 	if (err)
 		goto err_fib_entry_update;
 
@@ -6522,25 +6334,14 @@ static int mlxsw_sp_fib_node_entry_link(struct mlxsw_sp *mlxsw_sp,
 	return err;
 }
 
-static int __mlxsw_sp_fib_node_entry_unlink(struct mlxsw_sp *mlxsw_sp,
-					    struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
-					    struct mlxsw_sp_fib_entry *fib_entry)
+static void
+mlxsw_sp_fib_node_entry_unlink(struct mlxsw_sp *mlxsw_sp,
+			       struct mlxsw_sp_fib_entry *fib_entry)
 {
 	struct mlxsw_sp_fib_node *fib_node = fib_entry->fib_node;
-	int err;
 
-	err = mlxsw_sp_fib_entry_del(mlxsw_sp, op_ctx, fib_entry);
+	mlxsw_sp_fib_entry_del(mlxsw_sp, fib_entry);
 	fib_node->fib_entry = NULL;
-	return err;
-}
-
-static void mlxsw_sp_fib_node_entry_unlink(struct mlxsw_sp *mlxsw_sp,
-					   struct mlxsw_sp_fib_entry *fib_entry)
-{
-	struct mlxsw_sp_fib_entry_op_ctx *op_ctx = mlxsw_sp->router->ll_op_ctx;
-
-	mlxsw_sp_fib_entry_op_ctx_clear(op_ctx);
-	__mlxsw_sp_fib_node_entry_unlink(mlxsw_sp, op_ctx, fib_entry);
 }
 
 static bool mlxsw_sp_fib4_allow_replace(struct mlxsw_sp_fib4_entry *fib4_entry)
@@ -6562,7 +6363,6 @@ static bool mlxsw_sp_fib4_allow_replace(struct mlxsw_sp_fib4_entry *fib4_entry)
 
 static int
 mlxsw_sp_router_fib4_replace(struct mlxsw_sp *mlxsw_sp,
-			     struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
 			     const struct fib_entry_notifier_info *fen_info)
 {
 	struct mlxsw_sp_fib4_entry *fib4_entry, *fib4_replaced;
@@ -6597,7 +6397,7 @@ mlxsw_sp_router_fib4_replace(struct mlxsw_sp *mlxsw_sp,
 	}
 
 	replaced = fib_node->fib_entry;
-	err = mlxsw_sp_fib_node_entry_link(mlxsw_sp, op_ctx, &fib4_entry->common);
+	err = mlxsw_sp_fib_node_entry_link(mlxsw_sp, &fib4_entry->common);
 	if (err) {
 		dev_warn(mlxsw_sp->bus_info->dev, "Failed to link FIB entry to node\n");
 		goto err_fib_node_entry_link;
@@ -6622,23 +6422,20 @@ mlxsw_sp_router_fib4_replace(struct mlxsw_sp *mlxsw_sp,
 	return err;
 }
 
-static int mlxsw_sp_router_fib4_del(struct mlxsw_sp *mlxsw_sp,
-				    struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
-				    struct fib_entry_notifier_info *fen_info)
+static void mlxsw_sp_router_fib4_del(struct mlxsw_sp *mlxsw_sp,
+				     struct fib_entry_notifier_info *fen_info)
 {
 	struct mlxsw_sp_fib4_entry *fib4_entry;
 	struct mlxsw_sp_fib_node *fib_node;
-	int err;
 
 	fib4_entry = mlxsw_sp_fib4_entry_lookup(mlxsw_sp, fen_info);
 	if (!fib4_entry)
-		return 0;
+		return;
 	fib_node = fib4_entry->common.fib_node;
 
-	err = __mlxsw_sp_fib_node_entry_unlink(mlxsw_sp, op_ctx, &fib4_entry->common);
+	mlxsw_sp_fib_node_entry_unlink(mlxsw_sp, &fib4_entry->common);
 	mlxsw_sp_fib4_entry_destroy(mlxsw_sp, fib4_entry);
 	mlxsw_sp_fib_node_put(mlxsw_sp, fib_node);
-	return err;
 }
 
 static bool mlxsw_sp_fib6_rt_should_ignore(const struct fib6_info *rt)
@@ -6936,9 +6733,9 @@ static void mlxsw_sp_nexthop6_group_put(struct mlxsw_sp *mlxsw_sp,
 	mlxsw_sp_nexthop6_group_destroy(mlxsw_sp, nh_grp);
 }
 
-static int mlxsw_sp_nexthop6_group_update(struct mlxsw_sp *mlxsw_sp,
-					  struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
-					  struct mlxsw_sp_fib6_entry *fib6_entry)
+static int
+mlxsw_sp_nexthop6_group_update(struct mlxsw_sp *mlxsw_sp,
+			       struct mlxsw_sp_fib6_entry *fib6_entry)
 {
 	struct mlxsw_sp_nexthop_group *old_nh_grp = fib6_entry->common.nh_group;
 	struct mlxsw_sp_fib_node *fib_node = fib6_entry->common.fib_node;
@@ -6961,8 +6758,7 @@ static int mlxsw_sp_nexthop6_group_update(struct mlxsw_sp *mlxsw_sp,
 	 * currently associated with it in the device's table is that
 	 * of the old group. Start using the new one instead.
 	 */
-	err = __mlxsw_sp_fib_entry_update(mlxsw_sp, op_ctx,
-					  &fib6_entry->common, false);
+	err = mlxsw_sp_fib_entry_update(mlxsw_sp, &fib6_entry->common);
 	if (err)
 		goto err_fib_entry_update;
 
@@ -6986,7 +6782,6 @@ static int mlxsw_sp_nexthop6_group_update(struct mlxsw_sp *mlxsw_sp,
 
 static int
 mlxsw_sp_fib6_entry_nexthop_add(struct mlxsw_sp *mlxsw_sp,
-				struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
 				struct mlxsw_sp_fib6_entry *fib6_entry,
 				struct fib6_info **rt_arr, unsigned int nrt6)
 {
@@ -7004,7 +6799,7 @@ mlxsw_sp_fib6_entry_nexthop_add(struct mlxsw_sp *mlxsw_sp,
 		fib6_entry->nrt6++;
 	}
 
-	err = mlxsw_sp_nexthop6_group_update(mlxsw_sp, op_ctx, fib6_entry);
+	err = mlxsw_sp_nexthop6_group_update(mlxsw_sp, fib6_entry);
 	if (err)
 		goto err_rt6_unwind;
 
@@ -7023,7 +6818,6 @@ mlxsw_sp_fib6_entry_nexthop_add(struct mlxsw_sp *mlxsw_sp,
 
 static void
 mlxsw_sp_fib6_entry_nexthop_del(struct mlxsw_sp *mlxsw_sp,
-				struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
 				struct mlxsw_sp_fib6_entry *fib6_entry,
 				struct fib6_info **rt_arr, unsigned int nrt6)
 {
@@ -7041,7 +6835,7 @@ mlxsw_sp_fib6_entry_nexthop_del(struct mlxsw_sp *mlxsw_sp,
 		mlxsw_sp_rt6_destroy(mlxsw_sp_rt6);
 	}
 
-	mlxsw_sp_nexthop6_group_update(mlxsw_sp, op_ctx, fib6_entry);
+	mlxsw_sp_nexthop6_group_update(mlxsw_sp, fib6_entry);
 }
 
 static int
@@ -7127,12 +6921,6 @@ mlxsw_sp_fib6_entry_create(struct mlxsw_sp *mlxsw_sp,
 		return ERR_PTR(-ENOMEM);
 	fib_entry = &fib6_entry->common;
 
-	fib_entry->priv = mlxsw_sp_fib_entry_priv_create(fib_node->fib->ll_ops);
-	if (IS_ERR(fib_entry->priv)) {
-		err = PTR_ERR(fib_entry->priv);
-		goto err_fib_entry_priv_create;
-	}
-
 	INIT_LIST_HEAD(&fib6_entry->rt6_list);
 
 	for (i = 0; i < nrt6; i++) {
@@ -7174,8 +6962,6 @@ mlxsw_sp_fib6_entry_create(struct mlxsw_sp *mlxsw_sp,
 		list_del(&mlxsw_sp_rt6->list);
 		mlxsw_sp_rt6_destroy(mlxsw_sp_rt6);
 	}
-	mlxsw_sp_fib_entry_priv_put(fib_entry->priv);
-err_fib_entry_priv_create:
 	kfree(fib6_entry);
 	return ERR_PTR(err);
 }
@@ -7198,7 +6984,6 @@ static void mlxsw_sp_fib6_entry_destroy(struct mlxsw_sp *mlxsw_sp,
 	mlxsw_sp_nexthop6_group_put(mlxsw_sp, &fib6_entry->common);
 	mlxsw_sp_fib6_entry_rt_destroy_all(fib6_entry);
 	WARN_ON(fib6_entry->nrt6);
-	mlxsw_sp_fib_entry_priv_put(fib6_entry->common.priv);
 	kfree(fib6_entry);
 }
 
@@ -7256,8 +7041,8 @@ static bool mlxsw_sp_fib6_allow_replace(struct mlxsw_sp_fib6_entry *fib6_entry)
 }
 
 static int mlxsw_sp_router_fib6_replace(struct mlxsw_sp *mlxsw_sp,
-					struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
-					struct fib6_info **rt_arr, unsigned int nrt6)
+					struct fib6_info **rt_arr,
+					unsigned int nrt6)
 {
 	struct mlxsw_sp_fib6_entry *fib6_entry, *fib6_replaced;
 	struct mlxsw_sp_fib_entry *replaced;
@@ -7296,7 +7081,7 @@ static int mlxsw_sp_router_fib6_replace(struct mlxsw_sp *mlxsw_sp,
 	}
 
 	replaced = fib_node->fib_entry;
-	err = mlxsw_sp_fib_node_entry_link(mlxsw_sp, op_ctx, &fib6_entry->common);
+	err = mlxsw_sp_fib_node_entry_link(mlxsw_sp, &fib6_entry->common);
 	if (err)
 		goto err_fib_node_entry_link;
 
@@ -7320,8 +7105,8 @@ static int mlxsw_sp_router_fib6_replace(struct mlxsw_sp *mlxsw_sp,
 }
 
 static int mlxsw_sp_router_fib6_append(struct mlxsw_sp *mlxsw_sp,
-				       struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
-				       struct fib6_info **rt_arr, unsigned int nrt6)
+				       struct fib6_info **rt_arr,
+				       unsigned int nrt6)
 {
 	struct mlxsw_sp_fib6_entry *fib6_entry;
 	struct mlxsw_sp_fib_node *fib_node;
@@ -7349,7 +7134,8 @@ static int mlxsw_sp_router_fib6_append(struct mlxsw_sp *mlxsw_sp,
 
 	fib6_entry = container_of(fib_node->fib_entry,
 				  struct mlxsw_sp_fib6_entry, common);
-	err = mlxsw_sp_fib6_entry_nexthop_add(mlxsw_sp, op_ctx, fib6_entry, rt_arr, nrt6);
+	err = mlxsw_sp_fib6_entry_nexthop_add(mlxsw_sp, fib6_entry, rt_arr,
+					      nrt6);
 	if (err)
 		goto err_fib6_entry_nexthop_add;
 
@@ -7360,17 +7146,16 @@ static int mlxsw_sp_router_fib6_append(struct mlxsw_sp *mlxsw_sp,
 	return err;
 }
 
-static int mlxsw_sp_router_fib6_del(struct mlxsw_sp *mlxsw_sp,
-				    struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
-				    struct fib6_info **rt_arr, unsigned int nrt6)
+static void mlxsw_sp_router_fib6_del(struct mlxsw_sp *mlxsw_sp,
+				     struct fib6_info **rt_arr,
+				     unsigned int nrt6)
 {
 	struct mlxsw_sp_fib6_entry *fib6_entry;
 	struct mlxsw_sp_fib_node *fib_node;
 	struct fib6_info *rt = rt_arr[0];
-	int err;
 
 	if (mlxsw_sp_fib6_rt_should_ignore(rt))
-		return 0;
+		return;
 
 	/* Multipath routes are first added to the FIB trie and only then
 	 * notified. If we vetoed the addition, we will get a delete
@@ -7379,22 +7164,22 @@ static int mlxsw_sp_router_fib6_del(struct mlxsw_sp *mlxsw_sp,
 	 */
 	fib6_entry = mlxsw_sp_fib6_entry_lookup(mlxsw_sp, rt);
 	if (!fib6_entry)
-		return 0;
+		return;
 
 	/* If not all the nexthops are deleted, then only reduce the nexthop
 	 * group.
 	 */
 	if (nrt6 != fib6_entry->nrt6) {
-		mlxsw_sp_fib6_entry_nexthop_del(mlxsw_sp, op_ctx, fib6_entry, rt_arr, nrt6);
-		return 0;
+		mlxsw_sp_fib6_entry_nexthop_del(mlxsw_sp, fib6_entry, rt_arr,
+						nrt6);
+		return;
 	}
 
 	fib_node = fib6_entry->common.fib_node;
 
-	err = __mlxsw_sp_fib_node_entry_unlink(mlxsw_sp, op_ctx, &fib6_entry->common);
+	mlxsw_sp_fib_node_entry_unlink(mlxsw_sp, &fib6_entry->common);
 	mlxsw_sp_fib6_entry_destroy(mlxsw_sp, fib6_entry);
 	mlxsw_sp_fib_node_put(mlxsw_sp, fib_node);
-	return err;
 }
 
 static struct mlxsw_sp_mr_table *
@@ -7547,15 +7332,15 @@ static void mlxsw_sp_router_fib_flush(struct mlxsw_sp *mlxsw_sp)
 	}
 }
 
-struct mlxsw_sp_fib6_event {
+struct mlxsw_sp_fib6_event_work {
 	struct fib6_info **rt_arr;
 	unsigned int nrt6;
 };
 
-struct mlxsw_sp_fib_event {
-	struct list_head list; /* node in fib queue */
+struct mlxsw_sp_fib_event_work {
+	struct work_struct work;
 	union {
-		struct mlxsw_sp_fib6_event fib6_event;
+		struct mlxsw_sp_fib6_event_work fib6_work;
 		struct fib_entry_notifier_info fen_info;
 		struct fib_rule_notifier_info fr_info;
 		struct fib_nh_notifier_info fnh_info;
@@ -7564,12 +7349,11 @@ struct mlxsw_sp_fib_event {
 	};
 	struct mlxsw_sp *mlxsw_sp;
 	unsigned long event;
-	int family;
 };
 
 static int
-mlxsw_sp_router_fib6_event_init(struct mlxsw_sp_fib6_event *fib6_event,
-				struct fib6_entry_notifier_info *fen6_info)
+mlxsw_sp_router_fib6_work_init(struct mlxsw_sp_fib6_event_work *fib6_work,
+			       struct fib6_entry_notifier_info *fen6_info)
 {
 	struct fib6_info *rt = fen6_info->rt;
 	struct fib6_info **rt_arr;
@@ -7583,8 +7367,8 @@ mlxsw_sp_router_fib6_event_init(struct mlxsw_sp_fib6_event *fib6_event,
 	if (!rt_arr)
 		return -ENOMEM;
 
-	fib6_event->rt_arr = rt_arr;
-	fib6_event->nrt6 = nrt6;
+	fib6_work->rt_arr = rt_arr;
+	fib6_work->nrt6 = nrt6;
 
 	rt_arr[0] = rt;
 	fib6_info_hold(rt);
@@ -7606,241 +7390,182 @@ mlxsw_sp_router_fib6_event_init(struct mlxsw_sp_fib6_event *fib6_event,
 }
 
 static void
-mlxsw_sp_router_fib6_event_fini(struct mlxsw_sp_fib6_event *fib6_event)
+mlxsw_sp_router_fib6_work_fini(struct mlxsw_sp_fib6_event_work *fib6_work)
 {
 	int i;
 
-	for (i = 0; i < fib6_event->nrt6; i++)
-		mlxsw_sp_rt6_release(fib6_event->rt_arr[i]);
-	kfree(fib6_event->rt_arr);
+	for (i = 0; i < fib6_work->nrt6; i++)
+		mlxsw_sp_rt6_release(fib6_work->rt_arr[i]);
+	kfree(fib6_work->rt_arr);
 }
 
-static void mlxsw_sp_router_fib4_event_process(struct mlxsw_sp *mlxsw_sp,
-					       struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
-					       struct mlxsw_sp_fib_event *fib_event)
+static void mlxsw_sp_router_fib4_event_work(struct work_struct *work)
 {
+	struct mlxsw_sp_fib_event_work *fib_work =
+		container_of(work, struct mlxsw_sp_fib_event_work, work);
+	struct mlxsw_sp *mlxsw_sp = fib_work->mlxsw_sp;
 	int err;
 
+	mutex_lock(&mlxsw_sp->router->lock);
 	mlxsw_sp_span_respin(mlxsw_sp);
 
-	switch (fib_event->event) {
+	switch (fib_work->event) {
 	case FIB_EVENT_ENTRY_REPLACE:
-		err = mlxsw_sp_router_fib4_replace(mlxsw_sp, op_ctx, &fib_event->fen_info);
+		err = mlxsw_sp_router_fib4_replace(mlxsw_sp,
+						   &fib_work->fen_info);
 		if (err) {
-			mlxsw_sp_fib_entry_op_ctx_priv_put_all(op_ctx);
 			dev_warn(mlxsw_sp->bus_info->dev, "FIB replace failed.\n");
 			mlxsw_sp_fib4_offload_failed_flag_set(mlxsw_sp,
-							      &fib_event->fen_info);
+							      &fib_work->fen_info);
 		}
-		fib_info_put(fib_event->fen_info.fi);
+		fib_info_put(fib_work->fen_info.fi);
 		break;
 	case FIB_EVENT_ENTRY_DEL:
-		err = mlxsw_sp_router_fib4_del(mlxsw_sp, op_ctx, &fib_event->fen_info);
-		if (err)
-			mlxsw_sp_fib_entry_op_ctx_priv_put_all(op_ctx);
-		fib_info_put(fib_event->fen_info.fi);
+		mlxsw_sp_router_fib4_del(mlxsw_sp, &fib_work->fen_info);
+		fib_info_put(fib_work->fen_info.fi);
 		break;
 	case FIB_EVENT_NH_ADD:
 	case FIB_EVENT_NH_DEL:
-		mlxsw_sp_nexthop4_event(mlxsw_sp, fib_event->event, fib_event->fnh_info.fib_nh);
-		fib_info_put(fib_event->fnh_info.fib_nh->nh_parent);
+		mlxsw_sp_nexthop4_event(mlxsw_sp, fib_work->event,
+					fib_work->fnh_info.fib_nh);
+		fib_info_put(fib_work->fnh_info.fib_nh->nh_parent);
 		break;
 	}
+	mutex_unlock(&mlxsw_sp->router->lock);
+	kfree(fib_work);
 }
 
-static void mlxsw_sp_router_fib6_event_process(struct mlxsw_sp *mlxsw_sp,
-					       struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
-					       struct mlxsw_sp_fib_event *fib_event)
+static void mlxsw_sp_router_fib6_event_work(struct work_struct *work)
 {
-	struct mlxsw_sp_fib6_event *fib6_event = &fib_event->fib6_event;
+	struct mlxsw_sp_fib_event_work *fib_work =
+		    container_of(work, struct mlxsw_sp_fib_event_work, work);
+	struct mlxsw_sp_fib6_event_work *fib6_work = &fib_work->fib6_work;
+	struct mlxsw_sp *mlxsw_sp = fib_work->mlxsw_sp;
 	int err;
 
+	mutex_lock(&mlxsw_sp->router->lock);
 	mlxsw_sp_span_respin(mlxsw_sp);
 
-	switch (fib_event->event) {
+	switch (fib_work->event) {
 	case FIB_EVENT_ENTRY_REPLACE:
-		err = mlxsw_sp_router_fib6_replace(mlxsw_sp, op_ctx, fib_event->fib6_event.rt_arr,
-						   fib_event->fib6_event.nrt6);
+		err = mlxsw_sp_router_fib6_replace(mlxsw_sp,
+						   fib6_work->rt_arr,
+						   fib6_work->nrt6);
 		if (err) {
-			mlxsw_sp_fib_entry_op_ctx_priv_put_all(op_ctx);
 			dev_warn(mlxsw_sp->bus_info->dev, "FIB replace failed.\n");
 			mlxsw_sp_fib6_offload_failed_flag_set(mlxsw_sp,
-							      fib6_event->rt_arr,
-							      fib6_event->nrt6);
+							      fib6_work->rt_arr,
+							      fib6_work->nrt6);
 		}
-		mlxsw_sp_router_fib6_event_fini(&fib_event->fib6_event);
+		mlxsw_sp_router_fib6_work_fini(fib6_work);
 		break;
 	case FIB_EVENT_ENTRY_APPEND:
-		err = mlxsw_sp_router_fib6_append(mlxsw_sp, op_ctx, fib_event->fib6_event.rt_arr,
-						  fib_event->fib6_event.nrt6);
+		err = mlxsw_sp_router_fib6_append(mlxsw_sp,
+						  fib6_work->rt_arr,
+						  fib6_work->nrt6);
 		if (err) {
-			mlxsw_sp_fib_entry_op_ctx_priv_put_all(op_ctx);
 			dev_warn(mlxsw_sp->bus_info->dev, "FIB append failed.\n");
 			mlxsw_sp_fib6_offload_failed_flag_set(mlxsw_sp,
-							      fib6_event->rt_arr,
-							      fib6_event->nrt6);
+							      fib6_work->rt_arr,
+							      fib6_work->nrt6);
 		}
-		mlxsw_sp_router_fib6_event_fini(&fib_event->fib6_event);
+		mlxsw_sp_router_fib6_work_fini(fib6_work);
 		break;
 	case FIB_EVENT_ENTRY_DEL:
-		err = mlxsw_sp_router_fib6_del(mlxsw_sp, op_ctx, fib_event->fib6_event.rt_arr,
-					       fib_event->fib6_event.nrt6);
-		if (err)
-			mlxsw_sp_fib_entry_op_ctx_priv_put_all(op_ctx);
-		mlxsw_sp_router_fib6_event_fini(&fib_event->fib6_event);
+		mlxsw_sp_router_fib6_del(mlxsw_sp,
+					 fib6_work->rt_arr,
+					 fib6_work->nrt6);
+		mlxsw_sp_router_fib6_work_fini(fib6_work);
 		break;
 	}
+	mutex_unlock(&mlxsw_sp->router->lock);
+	kfree(fib_work);
 }
 
-static void mlxsw_sp_router_fibmr_event_process(struct mlxsw_sp *mlxsw_sp,
-						struct mlxsw_sp_fib_event *fib_event)
+static void mlxsw_sp_router_fibmr_event_work(struct work_struct *work)
 {
+	struct mlxsw_sp_fib_event_work *fib_work =
+		container_of(work, struct mlxsw_sp_fib_event_work, work);
+	struct mlxsw_sp *mlxsw_sp = fib_work->mlxsw_sp;
 	bool replace;
 	int err;
 
 	rtnl_lock();
 	mutex_lock(&mlxsw_sp->router->lock);
-	switch (fib_event->event) {
+	switch (fib_work->event) {
 	case FIB_EVENT_ENTRY_REPLACE:
 	case FIB_EVENT_ENTRY_ADD:
-		replace = fib_event->event == FIB_EVENT_ENTRY_REPLACE;
+		replace = fib_work->event == FIB_EVENT_ENTRY_REPLACE;
 
-		err = mlxsw_sp_router_fibmr_add(mlxsw_sp, &fib_event->men_info, replace);
+		err = mlxsw_sp_router_fibmr_add(mlxsw_sp, &fib_work->men_info,
+						replace);
 		if (err)
 			dev_warn(mlxsw_sp->bus_info->dev, "MR entry add failed.\n");
-		mr_cache_put(fib_event->men_info.mfc);
+		mr_cache_put(fib_work->men_info.mfc);
 		break;
 	case FIB_EVENT_ENTRY_DEL:
-		mlxsw_sp_router_fibmr_del(mlxsw_sp, &fib_event->men_info);
-		mr_cache_put(fib_event->men_info.mfc);
+		mlxsw_sp_router_fibmr_del(mlxsw_sp, &fib_work->men_info);
+		mr_cache_put(fib_work->men_info.mfc);
 		break;
 	case FIB_EVENT_VIF_ADD:
 		err = mlxsw_sp_router_fibmr_vif_add(mlxsw_sp,
-						    &fib_event->ven_info);
+						    &fib_work->ven_info);
 		if (err)
 			dev_warn(mlxsw_sp->bus_info->dev, "MR VIF add failed.\n");
-		dev_put(fib_event->ven_info.dev);
+		dev_put(fib_work->ven_info.dev);
 		break;
 	case FIB_EVENT_VIF_DEL:
-		mlxsw_sp_router_fibmr_vif_del(mlxsw_sp, &fib_event->ven_info);
-		dev_put(fib_event->ven_info.dev);
+		mlxsw_sp_router_fibmr_vif_del(mlxsw_sp,
+					      &fib_work->ven_info);
+		dev_put(fib_work->ven_info.dev);
 		break;
 	}
 	mutex_unlock(&mlxsw_sp->router->lock);
 	rtnl_unlock();
+	kfree(fib_work);
 }
 
-static void mlxsw_sp_router_fib_event_work(struct work_struct *work)
-{
-	struct mlxsw_sp_router *router = container_of(work, struct mlxsw_sp_router, fib_event_work);
-	struct mlxsw_sp_fib_entry_op_ctx *op_ctx = router->ll_op_ctx;
-	struct mlxsw_sp *mlxsw_sp = router->mlxsw_sp;
-	struct mlxsw_sp_fib_event *next_fib_event;
-	struct mlxsw_sp_fib_event *fib_event;
-	int last_family = AF_UNSPEC;
-	LIST_HEAD(fib_event_queue);
-
-	spin_lock_bh(&router->fib_event_queue_lock);
-	list_splice_init(&router->fib_event_queue, &fib_event_queue);
-	spin_unlock_bh(&router->fib_event_queue_lock);
-
-	/* Router lock is held here to make sure per-instance
-	 * operation context is not used in between FIB4/6 events
-	 * processing.
-	 */
-	mutex_lock(&router->lock);
-	mlxsw_sp_fib_entry_op_ctx_clear(op_ctx);
-	list_for_each_entry_safe(fib_event, next_fib_event,
-				 &fib_event_queue, list) {
-		/* Check if the next entry in the queue exists and it is
-		 * of the same type (family and event) as the currect one.
-		 * In that case it is permitted to do the bulking
-		 * of multiple FIB entries to a single register write.
-		 */
-		op_ctx->bulk_ok = !list_is_last(&fib_event->list, &fib_event_queue) &&
-				  fib_event->family == next_fib_event->family &&
-				  fib_event->event == next_fib_event->event;
-
-		/* In case family of this and the previous entry are different, context
-		 * reinitialization is going to be needed now, indicate that.
-		 * Note that since last_family is initialized to AF_UNSPEC, this is always
-		 * going to happen for the first entry processed in the work.
-		 */
-		if (fib_event->family != last_family)
-			op_ctx->initialized = false;
-
-		switch (fib_event->family) {
-		case AF_INET:
-			mlxsw_sp_router_fib4_event_process(mlxsw_sp, op_ctx,
-							   fib_event);
-			break;
-		case AF_INET6:
-			mlxsw_sp_router_fib6_event_process(mlxsw_sp, op_ctx,
-							   fib_event);
-			break;
-		case RTNL_FAMILY_IP6MR:
-		case RTNL_FAMILY_IPMR:
-			/* Unlock here as inside FIBMR the lock is taken again
-			 * under RTNL. The per-instance operation context
-			 * is not used by FIBMR.
-			 */
-			mutex_unlock(&router->lock);
-			mlxsw_sp_router_fibmr_event_process(mlxsw_sp,
-							    fib_event);
-			mutex_lock(&router->lock);
-			break;
-		default:
-			WARN_ON_ONCE(1);
-		}
-		last_family = fib_event->family;
-		kfree(fib_event);
-		cond_resched();
-	}
-	WARN_ON_ONCE(!list_empty(&router->ll_op_ctx->fib_entry_priv_list));
-	mutex_unlock(&router->lock);
-}
-
-static void mlxsw_sp_router_fib4_event(struct mlxsw_sp_fib_event *fib_event,
+static void mlxsw_sp_router_fib4_event(struct mlxsw_sp_fib_event_work *fib_work,
 				       struct fib_notifier_info *info)
 {
 	struct fib_entry_notifier_info *fen_info;
 	struct fib_nh_notifier_info *fnh_info;
 
-	switch (fib_event->event) {
+	switch (fib_work->event) {
 	case FIB_EVENT_ENTRY_REPLACE:
 	case FIB_EVENT_ENTRY_DEL:
 		fen_info = container_of(info, struct fib_entry_notifier_info,
 					info);
-		fib_event->fen_info = *fen_info;
+		fib_work->fen_info = *fen_info;
 		/* Take reference on fib_info to prevent it from being
-		 * freed while event is queued. Release it afterwards.
+		 * freed while work is queued. Release it afterwards.
 		 */
-		fib_info_hold(fib_event->fen_info.fi);
+		fib_info_hold(fib_work->fen_info.fi);
 		break;
 	case FIB_EVENT_NH_ADD:
 	case FIB_EVENT_NH_DEL:
 		fnh_info = container_of(info, struct fib_nh_notifier_info,
 					info);
-		fib_event->fnh_info = *fnh_info;
-		fib_info_hold(fib_event->fnh_info.fib_nh->nh_parent);
+		fib_work->fnh_info = *fnh_info;
+		fib_info_hold(fib_work->fnh_info.fib_nh->nh_parent);
 		break;
 	}
 }
 
-static int mlxsw_sp_router_fib6_event(struct mlxsw_sp_fib_event *fib_event,
+static int mlxsw_sp_router_fib6_event(struct mlxsw_sp_fib_event_work *fib_work,
 				      struct fib_notifier_info *info)
 {
 	struct fib6_entry_notifier_info *fen6_info;
 	int err;
 
-	switch (fib_event->event) {
+	switch (fib_work->event) {
 	case FIB_EVENT_ENTRY_REPLACE:
 	case FIB_EVENT_ENTRY_APPEND:
 	case FIB_EVENT_ENTRY_DEL:
 		fen6_info = container_of(info, struct fib6_entry_notifier_info,
 					 info);
-		err = mlxsw_sp_router_fib6_event_init(&fib_event->fib6_event,
-						      fen6_info);
+		err = mlxsw_sp_router_fib6_work_init(&fib_work->fib6_work,
+						     fen6_info);
 		if (err)
 			return err;
 		break;
@@ -7850,20 +7575,20 @@ static int mlxsw_sp_router_fib6_event(struct mlxsw_sp_fib_event *fib_event,
 }
 
 static void
-mlxsw_sp_router_fibmr_event(struct mlxsw_sp_fib_event *fib_event,
+mlxsw_sp_router_fibmr_event(struct mlxsw_sp_fib_event_work *fib_work,
 			    struct fib_notifier_info *info)
 {
-	switch (fib_event->event) {
+	switch (fib_work->event) {
 	case FIB_EVENT_ENTRY_REPLACE:
 	case FIB_EVENT_ENTRY_ADD:
 	case FIB_EVENT_ENTRY_DEL:
-		memcpy(&fib_event->men_info, info, sizeof(fib_event->men_info));
-		mr_cache_hold(fib_event->men_info.mfc);
+		memcpy(&fib_work->men_info, info, sizeof(fib_work->men_info));
+		mr_cache_hold(fib_work->men_info.mfc);
 		break;
 	case FIB_EVENT_VIF_ADD:
 	case FIB_EVENT_VIF_DEL:
-		memcpy(&fib_event->ven_info, info, sizeof(fib_event->ven_info));
-		dev_hold(fib_event->ven_info.dev);
+		memcpy(&fib_work->ven_info, info, sizeof(fib_work->ven_info));
+		dev_hold(fib_work->ven_info.dev);
 		break;
 	}
 }
@@ -7917,7 +7642,7 @@ static int mlxsw_sp_router_fib_rule_event(unsigned long event,
 static int mlxsw_sp_router_fib_event(struct notifier_block *nb,
 				     unsigned long event, void *ptr)
 {
-	struct mlxsw_sp_fib_event *fib_event;
+	struct mlxsw_sp_fib_event_work *fib_work;
 	struct fib_notifier_info *info = ptr;
 	struct mlxsw_sp_router *router;
 	int err;
@@ -7949,39 +7674,37 @@ static int mlxsw_sp_router_fib_event(struct notifier_block *nb,
 		break;
 	}
 
-	fib_event = kzalloc(sizeof(*fib_event), GFP_ATOMIC);
-	if (!fib_event)
+	fib_work = kzalloc(sizeof(*fib_work), GFP_ATOMIC);
+	if (!fib_work)
 		return NOTIFY_BAD;
 
-	fib_event->mlxsw_sp = router->mlxsw_sp;
-	fib_event->event = event;
-	fib_event->family = info->family;
+	fib_work->mlxsw_sp = router->mlxsw_sp;
+	fib_work->event = event;
 
 	switch (info->family) {
 	case AF_INET:
-		mlxsw_sp_router_fib4_event(fib_event, info);
+		INIT_WORK(&fib_work->work, mlxsw_sp_router_fib4_event_work);
+		mlxsw_sp_router_fib4_event(fib_work, info);
 		break;
 	case AF_INET6:
-		err = mlxsw_sp_router_fib6_event(fib_event, info);
+		INIT_WORK(&fib_work->work, mlxsw_sp_router_fib6_event_work);
+		err = mlxsw_sp_router_fib6_event(fib_work, info);
 		if (err)
 			goto err_fib_event;
 		break;
 	case RTNL_FAMILY_IP6MR:
 	case RTNL_FAMILY_IPMR:
-		mlxsw_sp_router_fibmr_event(fib_event, info);
+		INIT_WORK(&fib_work->work, mlxsw_sp_router_fibmr_event_work);
+		mlxsw_sp_router_fibmr_event(fib_work, info);
 		break;
 	}
 
-	/* Enqueue the event and trigger the work */
-	spin_lock_bh(&router->fib_event_queue_lock);
-	list_add_tail(&fib_event->list, &router->fib_event_queue);
-	spin_unlock_bh(&router->fib_event_queue_lock);
-	mlxsw_core_schedule_work(&router->fib_event_work);
+	mlxsw_core_schedule_work(&fib_work->work);
 
 	return NOTIFY_DONE;
 
 err_fib_event:
-	kfree(fib_event);
+	kfree(fib_work);
 	return NOTIFY_BAD;
 }
 
@@ -10526,41 +10249,8 @@ static const struct mlxsw_sp_router_ll_ops mlxsw_sp_router_ll_basic_ops = {
 	.ralta_write = mlxsw_sp_router_ll_basic_ralta_write,
 	.ralst_write = mlxsw_sp_router_ll_basic_ralst_write,
 	.raltb_write = mlxsw_sp_router_ll_basic_raltb_write,
-	.fib_entry_op_ctx_size = sizeof(struct mlxsw_sp_fib_entry_op_ctx_basic),
-	.fib_entry_pack = mlxsw_sp_router_ll_basic_fib_entry_pack,
-	.fib_entry_act_remote_pack = mlxsw_sp_router_ll_basic_fib_entry_act_remote_pack,
-	.fib_entry_act_local_pack = mlxsw_sp_router_ll_basic_fib_entry_act_local_pack,
-	.fib_entry_act_ip2me_pack = mlxsw_sp_router_ll_basic_fib_entry_act_ip2me_pack,
-	.fib_entry_act_ip2me_tun_pack = mlxsw_sp_router_ll_basic_fib_entry_act_ip2me_tun_pack,
-	.fib_entry_commit = mlxsw_sp_router_ll_basic_fib_entry_commit,
-	.fib_entry_is_committed = mlxsw_sp_router_ll_basic_fib_entry_is_committed,
 };
 
-static int mlxsw_sp_router_ll_op_ctx_init(struct mlxsw_sp_router *router)
-{
-	size_t max_size = 0;
-	int i;
-
-	for (i = 0; i < MLXSW_SP_L3_PROTO_MAX; i++) {
-		size_t size = router->proto_ll_ops[i]->fib_entry_op_ctx_size;
-
-		if (size > max_size)
-			max_size = size;
-	}
-	router->ll_op_ctx = kzalloc(sizeof(*router->ll_op_ctx) + max_size,
-				    GFP_KERNEL);
-	if (!router->ll_op_ctx)
-		return -ENOMEM;
-	INIT_LIST_HEAD(&router->ll_op_ctx->fib_entry_priv_list);
-	return 0;
-}
-
-static void mlxsw_sp_router_ll_op_ctx_fini(struct mlxsw_sp_router *router)
-{
-	WARN_ON(!list_empty(&router->ll_op_ctx->fib_entry_priv_list));
-	kfree(router->ll_op_ctx);
-}
-
 static int mlxsw_sp_lb_rif_init(struct mlxsw_sp *mlxsw_sp)
 {
 	u16 lb_rif_index;
@@ -10637,14 +10327,9 @@ int mlxsw_sp_router_init(struct mlxsw_sp *mlxsw_sp,
 	router->proto_ll_ops[MLXSW_SP_L3_PROTO_IPV4] = &mlxsw_sp_router_ll_basic_ops;
 	router->proto_ll_ops[MLXSW_SP_L3_PROTO_IPV6] = &mlxsw_sp_router_ll_basic_ops;
 
-	err = mlxsw_sp_router_ll_op_ctx_init(router);
-	if (err)
-		goto err_ll_op_ctx_init;
-
 	INIT_LIST_HEAD(&mlxsw_sp->router->nh_res_grp_list);
 	INIT_DELAYED_WORK(&mlxsw_sp->router->nh_grp_activity_dw,
 			  mlxsw_sp_nh_grp_activity_work);
-
 	INIT_LIST_HEAD(&mlxsw_sp->router->nexthop_neighs_list);
 	err = __mlxsw_sp_router_init(mlxsw_sp);
 	if (err)
@@ -10697,10 +10382,6 @@ int mlxsw_sp_router_init(struct mlxsw_sp *mlxsw_sp,
 	if (err)
 		goto err_dscp_init;
 
-	INIT_WORK(&router->fib_event_work, mlxsw_sp_router_fib_event_work);
-	INIT_LIST_HEAD(&router->fib_event_queue);
-	spin_lock_init(&router->fib_event_queue_lock);
-
 	router->inetaddr_nb.notifier_call = mlxsw_sp_inetaddr_event;
 	err = register_inetaddr_notifier(&router->inetaddr_nb);
 	if (err)
@@ -10755,7 +10436,6 @@ int mlxsw_sp_router_init(struct mlxsw_sp *mlxsw_sp,
 	unregister_inetaddr_notifier(&router->inetaddr_nb);
 err_register_inetaddr_notifier:
 	mlxsw_core_flush_owq();
-	WARN_ON(!list_empty(&router->fib_event_queue));
 err_dscp_init:
 err_mp_hash_init:
 	mlxsw_sp_neigh_fini(mlxsw_sp);
@@ -10779,8 +10459,6 @@ int mlxsw_sp_router_init(struct mlxsw_sp *mlxsw_sp,
 	__mlxsw_sp_router_fini(mlxsw_sp);
 err_router_init:
 	cancel_delayed_work_sync(&mlxsw_sp->router->nh_grp_activity_dw);
-	mlxsw_sp_router_ll_op_ctx_fini(router);
-err_ll_op_ctx_init:
 err_router_ops_init:
 	mutex_destroy(&mlxsw_sp->router->lock);
 	kfree(mlxsw_sp->router);
@@ -10799,7 +10477,6 @@ void mlxsw_sp_router_fini(struct mlxsw_sp *mlxsw_sp)
 	unregister_inet6addr_notifier(&mlxsw_sp->router->inet6addr_nb);
 	unregister_inetaddr_notifier(&mlxsw_sp->router->inetaddr_nb);
 	mlxsw_core_flush_owq();
-	WARN_ON(!list_empty(&mlxsw_sp->router->fib_event_queue));
 	mlxsw_sp_neigh_fini(mlxsw_sp);
 	mlxsw_sp_lb_rif_fini(mlxsw_sp);
 	mlxsw_sp_vrs_fini(mlxsw_sp);
@@ -10811,7 +10488,6 @@ void mlxsw_sp_router_fini(struct mlxsw_sp *mlxsw_sp)
 	mlxsw_sp_rifs_fini(mlxsw_sp);
 	__mlxsw_sp_router_fini(mlxsw_sp);
 	cancel_delayed_work_sync(&mlxsw_sp->router->nh_grp_activity_dw);
-	mlxsw_sp_router_ll_op_ctx_fini(mlxsw_sp->router);
 	mutex_destroy(&mlxsw_sp->router->lock);
 	kfree(mlxsw_sp->router);
 }
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
index e95dd7d51186..f646a5d3a9c2 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
@@ -15,26 +15,6 @@ struct mlxsw_sp_router_nve_decap {
 	u8 valid:1;
 };
 
-struct mlxsw_sp_fib_entry_op_ctx {
-	u8 bulk_ok:1, /* Indicate to the low-level op it is ok to bulk
-		       * the actual entry with the one that is the next
-		       * in queue.
-		       */
-	   initialized:1; /* Bit that the low-level op sets in case
-			   * the context priv is initialized.
-			   */
-	struct list_head fib_entry_priv_list;
-	unsigned long ll_priv[];
-};
-
-static inline void
-mlxsw_sp_fib_entry_op_ctx_clear(struct mlxsw_sp_fib_entry_op_ctx *op_ctx)
-{
-	WARN_ON_ONCE(!list_empty(&op_ctx->fib_entry_priv_list));
-	memset(op_ctx, 0, sizeof(*op_ctx));
-	INIT_LIST_HEAD(&op_ctx->fib_entry_priv_list);
-}
-
 struct mlxsw_sp_router {
 	struct mlxsw_sp *mlxsw_sp;
 	struct mlxsw_sp_rif **rifs;
@@ -71,9 +51,6 @@ struct mlxsw_sp_router {
 	const struct mlxsw_sp_ipip_ops **ipip_ops_arr;
 	struct mlxsw_sp_router_nve_decap nve_decap_config;
 	struct mutex lock; /* Protects shared router resources */
-	struct work_struct fib_event_work;
-	struct list_head fib_event_queue;
-	spinlock_t fib_event_queue_lock; /* Protects fib event queue list */
 	/* One set of ops for each protocol: IPv4 and IPv6 */
 	const struct mlxsw_sp_router_ll_ops *proto_ll_ops[MLXSW_SP_L3_PROTO_MAX];
 	struct mlxsw_sp_fib_entry_op_ctx *ll_op_ctx;
@@ -87,18 +64,6 @@ struct mlxsw_sp_router {
 	u32 adj_trap_index;
 };
 
-struct mlxsw_sp_fib_entry_priv {
-	refcount_t refcnt;
-	struct list_head list; /* Member in op_ctx->fib_entry_priv_list */
-	unsigned long priv[];
-};
-
-enum mlxsw_sp_fib_entry_op {
-	MLXSW_SP_FIB_ENTRY_OP_WRITE,
-	MLXSW_SP_FIB_ENTRY_OP_UPDATE,
-	MLXSW_SP_FIB_ENTRY_OP_DELETE,
-};
-
 /* Low-level router ops. Basically this is to handle the different
  * register sets to work with ordinary and XM trees and FIB entries.
  */
@@ -106,25 +71,6 @@ struct mlxsw_sp_router_ll_ops {
 	int (*ralta_write)(struct mlxsw_sp *mlxsw_sp, char *xralta_pl);
 	int (*ralst_write)(struct mlxsw_sp *mlxsw_sp, char *xralst_pl);
 	int (*raltb_write)(struct mlxsw_sp *mlxsw_sp, char *xraltb_pl);
-	size_t fib_entry_op_ctx_size;
-	size_t fib_entry_priv_size;
-	void (*fib_entry_pack)(struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
-			       enum mlxsw_sp_l3proto proto, enum mlxsw_sp_fib_entry_op op,
-			       u16 virtual_router, u8 prefix_len, unsigned char *addr,
-			       struct mlxsw_sp_fib_entry_priv *priv);
-	void (*fib_entry_act_remote_pack)(struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
-					  enum mlxsw_reg_ralue_trap_action trap_action,
-					  u16 trap_id, u32 adjacency_index, u16 ecmp_size);
-	void (*fib_entry_act_local_pack)(struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
-					 enum mlxsw_reg_ralue_trap_action trap_action,
-					 u16 trap_id, u16 local_erif);
-	void (*fib_entry_act_ip2me_pack)(struct mlxsw_sp_fib_entry_op_ctx *op_ctx);
-	void (*fib_entry_act_ip2me_tun_pack)(struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
-					     u32 tunnel_ptr);
-	int (*fib_entry_commit)(struct mlxsw_sp *mlxsw_sp,
-				struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
-				bool *postponed_for_bulk);
-	bool (*fib_entry_is_committed)(struct mlxsw_sp_fib_entry_priv *priv);
 };
 
 struct mlxsw_sp_rif_ipip_lb;
-- 
2.36.1

