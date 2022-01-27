Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44DFA49DD3F
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 10:04:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238172AbiA0JDu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 04:03:50 -0500
Received: from mail-mw2nam12on2077.outbound.protection.outlook.com ([40.107.244.77]:5856
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238176AbiA0JDt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jan 2022 04:03:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lAw9s7ojWHkeraa1MWwbGCBg1aWg/pRcVKx1pvHCvwlrB8rB7vCgYwY6EnkulDoBGbZUDfxDCAX9qHVRND16pSDVuk1p70OzRBfs9cazaK2RD/g0z/FVQG4uA7eRfv/LIoB03eaclBUwr5cZX/Hf3sEEaZBK2hwO93ApFBiGczAz0z76xnTGJatpWLLZRCS/5qcBZpVI2+lZvnB4p8RsnXkOh1veCpXvTEYdFMK7P/DWXBvDFlVxbO89i+xZyissdJvlaYV9GzZA/jhKUqXGm5XOwhCBgeAMyVgzljDGvgyngiYTNlaLbpb74zyUuquMaqmGiJKTck2gq5DciOtLHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eY0JjPZiFVm+7jzV7pxf3KHeXeLlC74bpNq7jCA6EoM=;
 b=MtrPQITV9zK19GK6FiAyzwYWna5HvWe1PakwD/n6tTLbr311pmO/8ICoFgphFDkezRYCtPKzQxfmDyM9U6e8WmZf0ugoGt1tK5iwyj9YBuykaL5lEq94PmZJLKlEwvbqoy9VGbM5slRcDRDZRHq4CSkuX0O+oBHwkdRqubjpERon+EdysvrCfDTi6GGDoqVnMi3Q4CF/5dxUm8HCxEFC3nJ9JBSHNt227R7lUJhK15w6EUhSBabxiOCD5n5LWeM+atqFexaKO6ivF9GJIc12LvpIwgTfK6m0f9zWlrdPWl+hR+TNkJP5gsE7I/uzL3gsKGyQQi+tj2VjBQzidmFR2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eY0JjPZiFVm+7jzV7pxf3KHeXeLlC74bpNq7jCA6EoM=;
 b=E72XSpOHZQBEnyJxz5twXTwd7aAyoTEc31f7QzEBeznNXSZzMBXLPCU3KwQgkMsbzO3am3i+iQ1U6BMv82KWuAPQy/EZWZEYrMHwdKvcrIVgAt7j/ay7vaPSpPnI3dBy+/IF8xC+O6thp5fIZQvDUwpPtWS28+lzUcAAF9UjERQZlnQxzfPIu+TLFLYKOyHsB/1+kikiEloTNcu003CF+vzsi869FX0i1wVWVdRt0tbEr2fhs85PI/Nkut49qmOdiUQS4Goo3bxnqC6Dv/4GFC5qwdyzWrrO6CGvL7/KBsGgTg10QI81KTcDYf/C5Gpf0r885GQkKKLAlL8LF0/Oiw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3527.namprd12.prod.outlook.com (2603:10b6:a03:13c::12)
 by BN9PR12MB5355.namprd12.prod.outlook.com (2603:10b6:408:104::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.10; Thu, 27 Jan
 2022 09:03:47 +0000
Received: from BYAPR12MB3527.namprd12.prod.outlook.com
 ([fe80::3dfb:4df1:dcf1:4561]) by BYAPR12MB3527.namprd12.prod.outlook.com
 ([fe80::3dfb:4df1:dcf1:4561%5]) with mapi id 15.20.4909.019; Thu, 27 Jan 2022
 09:03:47 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        jiri@nvidia.com, amcohen@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 7/7] mlxsw: spectrum_acl: Allocate default actions for internal TCAM regions
Date:   Thu, 27 Jan 2022 11:02:26 +0200
Message-Id: <20220127090226.283442-8-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220127090226.283442-1-idosch@nvidia.com>
References: <20220127090226.283442-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR09CA0073.eurprd09.prod.outlook.com
 (2603:10a6:802:29::17) To BYAPR12MB3527.namprd12.prod.outlook.com
 (2603:10b6:a03:13c::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cf892c39-e40a-44a3-71db-08d9e173ed42
X-MS-TrafficTypeDiagnostic: BN9PR12MB5355:EE_
X-Microsoft-Antispam-PRVS: <BN9PR12MB53550982D669B7D6C0076A2DB2219@BN9PR12MB5355.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zd5RYNxT/YC67xXCkjHbp7QVB60QkTzsu4c9VrUxST10jDEALlE+3MwJv+JsBeZeyxrkuGIhYzCiTRpot+7iDqgyfK0gM5Z7B2tsSXhsFFhmAGqB0AxQ1V7oZVauD7G5vKOGH4qOAjUaT6JNLTd8CM+h80M0a2Fo2v2g+ZO2lnDmKWE3CXp6WgsDXKIXvs0RvvI/er7tQVAvb9WTSBd48GDY8EeI5hSDDTVjFmy5iY2mC1JA865qj79TUowYhckI9/QhHgZTOKNJTv3HmV8/0L+A6/1QHkrwhvUtApnPeFGyhLh/h7xV8nY0E2Q/8B+XWJVZk0Te+/gPSh4+qqTBfOWPZWc1UyaZG8NYMvKbKpZgW/0y0OksXv1E0GQTHb3Z4ZmZhkA22xaDr6um1H4JAzU5tqP+pcJIsFeT5ka+RbGZsAJrmhqHx++1HeTWw0/WtwnJVLUvGq3wZETzd6W5A2yeWPvAIkpk5qlxx/uRqw80gBMZEuJHA69lY8NLUpp/tkOCCFadh970PnFZwVGGYmCsmNxg8vI0d9fWPuChsoerLP6YjlhTIjRn9astqwulK/v7yQj7arwlJJ8MPYhMdmm8bZpRYc3xFrB3DJv5ZOF9ROj9Bdeo3m1IWLzMOZfdRFpC6K/Ve5pAknX0PYVFWg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3527.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(6512007)(2616005)(6916009)(4326008)(8676002)(316002)(6486002)(66946007)(26005)(186003)(86362001)(1076003)(66476007)(107886003)(508600001)(8936002)(6666004)(66556008)(5660300002)(83380400001)(6506007)(36756003)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?h1MKCs4XywehsMaKJgipK/E6BJ+gHtQGoZH8VUpmRE8HqiPUSJpTxid39+Jd?=
 =?us-ascii?Q?ICIw+HvpU9b1hIjJtCsIswxuDJH5KDg/BbCbqdZuXuFQ3o6EJ0mpU4w3SLDP?=
 =?us-ascii?Q?mbB7eR4DvklasVAbrzq4sCky3WGvv/gLIODaGZgUlBUjsi9Hk3lQ9GVZbxcB?=
 =?us-ascii?Q?IBhX7QyDXX93sRvpwh4Ra1KwudMqm6ffZDElXpxREiRYBbhVJwPSinrSGoAR?=
 =?us-ascii?Q?9BVSY5ObzGxj2/SM99wp5D5Q4M5tn4PtP/dEaYcd8jwWbY/RZoTpvzJmW/22?=
 =?us-ascii?Q?YwFoE6Pp7mehtqAYbDMUA73WqCgSah6O6kgI6+jilUtauzbzbWL0VHcluW3O?=
 =?us-ascii?Q?xDaJatWBdv3ST/jfNKunIs3BpgV2IOiL26Bc3TKaPTlXOKWo0CsN66KQDHXe?=
 =?us-ascii?Q?vlmuEnMk6ggN6GuEnwchRGs6iB+OoazDNgpElplMrW5V5CM6PzkyU15X2rK7?=
 =?us-ascii?Q?CiW+sPCko7G2ldt0Lqo3uGmK5M7bZLcwcF5L9ttgdo0qg9VsmJoI3D84QBw+?=
 =?us-ascii?Q?Cm7LwAQgWZsiHmuPm7nQ3Gc9HuG9KQPlucCZqfwbFs7ZlNz6plvCQHC2Kt0z?=
 =?us-ascii?Q?Z5giQM7LQmEI7SG36nHp/NIqzgJL5gwjh/1dRzLKeMwACEyeQjkMfb2lgVyA?=
 =?us-ascii?Q?qNn9OkE2lEQZKCN4rWIB5C+0oISz0PPep87DIU4049mua7ujtExD4NsMWQJy?=
 =?us-ascii?Q?PmiFmrCU+wGO4qseOsAFZPCqnDIZCmLLkYbB2z9zMyj5MzdMIMOYQVfjNxze?=
 =?us-ascii?Q?y5a4h6uMq8hGMkKi4zG0TKlgnyPS5ANYcEUWJOpRekk/O47qdBwtzINsO4Wa?=
 =?us-ascii?Q?jLzXrwsfOnY/TwOKtJ9Au7RxdzdGR9nLb6oHVzlfeOH+yTpIOe88rnlUhx7v?=
 =?us-ascii?Q?aUnXfrEcdvzOEzofSEu2Pp/VBaL07BOgQlKwM7whS1gh3ShTQCNoOwyHzGBW?=
 =?us-ascii?Q?ECe906y1v3OHtU7u6lujcJ5i6DU18WQOS4Z+oFUh4tKbcNZFHzwx9PEerGQm?=
 =?us-ascii?Q?Un1iyLLxUo7p5co1NQywbsToMHzg1eaY9UyJpHqlDTfwx8vXMkcBtEQ/kWJh?=
 =?us-ascii?Q?gXy7XbW8kFiuW5S0xGHdG/pAZN+Q6MfqoQctuc2xBIurvb4MRRrIkOVlNLrn?=
 =?us-ascii?Q?piCnz08kZcX8kENfrF8Wc3K0Mcqhw6Y+FCrbvYV5YlmUsaElRGByfXlBJmv+?=
 =?us-ascii?Q?ikMtUlCJTPtbVFH9WN7QUMp7JqKx4EMK3HxbXWsM/R7JYaC9Vd3wQULptsVd?=
 =?us-ascii?Q?pcwImYx1VXFIxG4U6bBo4vHoJ3Dcqbg6UIMs3r1dODW19ibizxagl0SPTU/g?=
 =?us-ascii?Q?lk9gkbcNmFArmACKluE9I8LU5kaedFkj3y0LBvEdGkcF2R4yNwx+p3i7H2AD?=
 =?us-ascii?Q?32GaCEjh8dqAgZW4Zf2vEgfTZJov6zPJS6nwzP8HcPmEyTqvWEa0Ds7GC0Da?=
 =?us-ascii?Q?AIhLs7ioC6lQnK9012Q2Hud0nkpwNiZ/egZ8BFYui6iXu0/LsbE5VSXY7/wI?=
 =?us-ascii?Q?Dn095JtTnacQf1IUwwfYMTUOc360NsSx0P/wIxC9ZaH1gfs4i0hnN7hL88ly?=
 =?us-ascii?Q?yxypUy35lXJDwEvJ4eV/XZiwRP2pSdmJGQVtMKWJRt5MiLDdqX+S7pyE+dW+?=
 =?us-ascii?Q?5srN9OzkX1yQ3JITwJzvVUg=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf892c39-e40a-44a3-71db-08d9e173ed42
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3527.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2022 09:03:47.0335
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kBjtaqhNtAIMdIA6rMMBO2DsNVIllxql4p9pa1r+saHUyxx8r6XxKgmNBAKvg1TtR2GxOOV8up2tsj2tlFGaVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5355
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In Spectrum-2 and later ASICs, each TCAM region has a default action
that is executed in case a packet did not match any rule in the region.
The location of the action in the database (KVDL) is computed by adding
the region's index to a base value.

Some TCAM regions are not exposed to the host and used internally by the
device. Allocate KVDL entries for the default actions of these regions
to avoid the host from overwriting them.

With mlxsw, lookups in the internal regions are not currently performed,
but it is a good practice not to overwrite their default actions.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/resources.h      |  2 ++
 .../net/ethernet/mellanox/mlxsw/spectrum2_acl_tcam.c | 12 +++++++++++-
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/resources.h b/drivers/net/ethernet/mellanox/mlxsw/resources.h
index c7fc650608eb..daacf6291253 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/resources.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/resources.h
@@ -33,6 +33,7 @@ enum mlxsw_res_id {
 	MLXSW_RES_ID_ACL_MAX_REGIONS,
 	MLXSW_RES_ID_ACL_MAX_GROUPS,
 	MLXSW_RES_ID_ACL_MAX_GROUP_SIZE,
+	MLXSW_RES_ID_ACL_MAX_DEFAULT_ACTIONS,
 	MLXSW_RES_ID_ACL_FLEX_KEYS,
 	MLXSW_RES_ID_ACL_MAX_ACTION_PER_RULE,
 	MLXSW_RES_ID_ACL_ACTIONS_PER_SET,
@@ -90,6 +91,7 @@ static u16 mlxsw_res_ids[] = {
 	[MLXSW_RES_ID_ACL_MAX_REGIONS] = 0x2903,
 	[MLXSW_RES_ID_ACL_MAX_GROUPS] = 0x2904,
 	[MLXSW_RES_ID_ACL_MAX_GROUP_SIZE] = 0x2905,
+	[MLXSW_RES_ID_ACL_MAX_DEFAULT_ACTIONS] = 0x2908,
 	[MLXSW_RES_ID_ACL_FLEX_KEYS] = 0x2910,
 	[MLXSW_RES_ID_ACL_MAX_ACTION_PER_RULE] = 0x2911,
 	[MLXSW_RES_ID_ACL_ACTIONS_PER_SET] = 0x2912,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum2_acl_tcam.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum2_acl_tcam.c
index ad69913f19c1..5b0210862655 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum2_acl_tcam.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum2_acl_tcam.c
@@ -77,7 +77,14 @@ static int mlxsw_sp2_acl_tcam_init(struct mlxsw_sp *mlxsw_sp, void *priv,
 	int i;
 	int err;
 
+	/* Some TCAM regions are not exposed to the host and used internally
+	 * by the device. Allocate KVDL entries for the default actions of
+	 * these regions to avoid the host from overwriting them.
+	 */
 	tcam->kvdl_count = _tcam->max_regions;
+	if (MLXSW_CORE_RES_VALID(mlxsw_sp->core, ACL_MAX_DEFAULT_ACTIONS))
+		tcam->kvdl_count = MLXSW_CORE_RES_GET(mlxsw_sp->core,
+						      ACL_MAX_DEFAULT_ACTIONS);
 	err = mlxsw_sp_kvdl_alloc(mlxsw_sp, MLXSW_SP_KVDL_ENTRY_TYPE_ACTSET,
 				  tcam->kvdl_count, &tcam->kvdl_index);
 	if (err)
@@ -97,7 +104,10 @@ static int mlxsw_sp2_acl_tcam_init(struct mlxsw_sp *mlxsw_sp, void *priv,
 		goto err_afa_block_continue;
 	enc_actions = mlxsw_afa_block_cur_set(afa_block);
 
-	for (i = 0; i < tcam->kvdl_count; i++) {
+	/* Only write to KVDL entries used by TCAM regions exposed to the
+	 * host.
+	 */
+	for (i = 0; i < _tcam->max_regions; i++) {
 		mlxsw_reg_pefa_pack(pefa_pl, tcam->kvdl_index + i,
 				    true, enc_actions);
 		err = mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(pefa), pefa_pl);
-- 
2.33.1

