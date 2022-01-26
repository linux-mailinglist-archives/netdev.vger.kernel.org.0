Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DACB649C792
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 11:31:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239986AbiAZKbb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 05:31:31 -0500
Received: from mail-bn7nam10on2044.outbound.protection.outlook.com ([40.107.92.44]:13856
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239984AbiAZKb2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jan 2022 05:31:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TnX8dhpfL2sbXkh1Fxo/AEZSPd3dGkTQeWr0j2Nh222//6+Ec3pRy8bswSFnObjR/Xdmz2htWOQjK+MpxFVQqFBjDVxYhPLMYPZAp/oB19YRUvF8ygDbleYPsInb4rUYmdtppLxe/ex/xIY6aM2wndROJRPIx9tJc14ihq5QtVJy8nvcesCGevvTyE082y6x3pnaf6eq3jCmfobkjRnbFSU2VVnZZguuSTRC5ss+Wb0tvmgdvUTk1o913f/tWlaUlyIRen/WB2vK3VXL4IbB6lEYCCSpJ4s4A+FZujGtUlUt3iQpc1I92g52CpyDl79hOWyNUfVcbhsiU9fKM62nFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nP18OYGFJTFN0ZuC1cVx+3YMUuncso/BjFsas3C69eY=;
 b=axgC0yuL406jGqu6yYBeeNk9oCFVHpPsc0EcldIJEUimv5W86avJ/nQ8tJPfO45tBMhlEbNhCNCEDKtYl07G0DZ4g47DbMWGxE2ZagZcTZ+e+92P86ZFHwkf+kvsd1CJPqLec92Zp1MLwthMbWzXMas3GFUg4TZHlJmxo8DmcrkA+AqDBbE3yUsjjl8ad13PoBIH6ZiUPhQuijYbeltehQeLE1/NNvzgCa8XHRTm3e2xfg9Yykat9VNWZoMlMtF8O1B3GR9r3LtfQ6KA/Dc/EPSjhRXB7tLTa5Y5Cl5RM7jlfSHUJLqVNL51fgrwx/ttEYDRYrBqLy3wvmt9bAkpcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nP18OYGFJTFN0ZuC1cVx+3YMUuncso/BjFsas3C69eY=;
 b=Lp0HxAWTOPv9Smzb9VQS+j5BRpeZqCWi3hYtPPVBvJ6Pgzndr9xcVVXKenk0ogQkf/fy2e+8FNO5uqm7SFHY3TysnC5FS/3DDQYjGEXkYxTh4xIhmAbj+HFuU96mAZMHExpc7JbE62tW3wcmXyfmooHjko3EoRqW7TabJmud9f18YVSOpKYME/MWLLkEhRpSAvQjDtNtPUuskw1smagmAusPJsfuQBURIlO5q7oP+7mHTgsUHXojRDw5SdLwo9LIZA0uuCPf4K+TacOdLxyGDYMMsDXWqRfgJsFkVCl3UCfx9lnxxVysB2F9MkLY1KXocUTXv6KQ9L3WBnAqRMwzsA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3527.namprd12.prod.outlook.com (2603:10b6:a03:13c::12)
 by SA0PR12MB4461.namprd12.prod.outlook.com (2603:10b6:806:9c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.8; Wed, 26 Jan
 2022 10:31:27 +0000
Received: from BYAPR12MB3527.namprd12.prod.outlook.com
 ([fe80::3dfb:4df1:dcf1:4561]) by BYAPR12MB3527.namprd12.prod.outlook.com
 ([fe80::3dfb:4df1:dcf1:4561%5]) with mapi id 15.20.4909.017; Wed, 26 Jan 2022
 10:31:27 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        danieller@nvidia.com, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 2/9] mlxsw: core_env: Do not pass number of modules as argument
Date:   Wed, 26 Jan 2022 12:30:30 +0200
Message-Id: <20220126103037.234986-3-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220126103037.234986-1-idosch@nvidia.com>
References: <20220126103037.234986-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR10CA0094.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:803:28::23) To BYAPR12MB3527.namprd12.prod.outlook.com
 (2603:10b6:a03:13c::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cacf577b-1f6b-4f14-dd8b-08d9e0b70251
X-MS-TrafficTypeDiagnostic: SA0PR12MB4461:EE_
X-Microsoft-Antispam-PRVS: <SA0PR12MB4461DFEE6340981FAC495DC9B2209@SA0PR12MB4461.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V0xy5nU0j/PRUSx0Dyghua9AUBjTI1e8jZxSD9oEuyps9mL91xLXdyRad77B4ctF9tGPca+44F/pxQMkVzu13NZ529a/uNR3UNnPb1XpmNtF5O+YeMm0rQsWC3pXqTL59YmFk0SgN0MB7Nc9dUZ9z5Q5Y3wyhmukqhThZo8jZAXtNSevIYizTUuGG7XDxbnGFg/CfGzbL1D9sfPuodsJxHYeAsfsGdkow9OC1MM9ycKC0ncYhbIsCeIzzHK3CR8ZKqxs8VN1/2uw7vkbRBV9XUxECKwYoLfRX5kHlrgpnI3bX1GxEtS2ZUFBxJo5pz9czzTiB9CGS9VS8d0ZNN/13eBnRyiRtzEZDf4TY5t5DtWk6q2omK4BlaJTTs2mKh9lmi4dxSZjCe4bXcbUQaB8ve4H3OISVxVteR3Ml7sK9wCkrDweg9t8ShIw4lkd63JvbDZgWIOQFVmlt+kH9Dn7pTg223amPt+BWEsCnLHuTvvba+nW6Srcbqe29x45DYtyQ1/2GVPNL+VUv8aqJxn0PaQB9NjbKMrZ5Jl3yVdoNjmJg9236yKBUAgiMmPKEdVUpvgxdWJqTCitGULfix+O9IiuVT7ukduuaFaJVzepPhFQywpCIJOXBhEKo7KKsuRQFqY/ZGZXNFFR5tif34/FxA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3527.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(107886003)(86362001)(66476007)(508600001)(8676002)(66556008)(38100700002)(2616005)(5660300002)(8936002)(6666004)(83380400001)(4326008)(6916009)(186003)(6486002)(6512007)(6506007)(2906002)(316002)(26005)(36756003)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aNmiEeMMiMmK5bSzOqvKZxexVFzjcIp5+bl8iSwUx1H9Oz8K37+8nZAtK5Na?=
 =?us-ascii?Q?Jo4yV0KGI3NnHYXDgJSRvy5l42roGpdSZqY6svkPLrHG8yQ6yL6nKpx6o4xP?=
 =?us-ascii?Q?MC2i1ItcdsHxLrgqLgLanu5J9Lg1YJEvQjputAsxF3ayWo1qeoEiTC+sioED?=
 =?us-ascii?Q?N2vN36+HB5yuWKCNvQKHxjQ13JFiwQKuBGev0wqkO3mch2QBqvbaYjikQNWM?=
 =?us-ascii?Q?DL3ctLgtEHRW0MwOEZAEXUOcF/vPfloFFsQp+R3iLpLHN68m5MuTUBDgiD3Y?=
 =?us-ascii?Q?rDTt+uUz2vEElmVT+GMdIV938K4VWy6cIb2ADPx7q4C47mERiy3Uiv93f6xt?=
 =?us-ascii?Q?yjwdD5KuP4adNlI1YI7erpghkdujKDTZEBYyK6NyTLBs0+IjnIM8T47XOecJ?=
 =?us-ascii?Q?okgOC1DRu53zaITYsouhQTZTkYH2ZZoi1twnMbzLCBDHp0sKpzmO9CLiO0Nt?=
 =?us-ascii?Q?wISY86aYQK98VkLeMbemCuMRf75n/Jv48TjYW4lUJKJMGkl572vso0bu75QX?=
 =?us-ascii?Q?kP0dEoMZHQvjZET6RwS6dUYDBl2DTw5EutdrN7rdDxQ9mouf7mrerJ5lH1Pq?=
 =?us-ascii?Q?aVW7i4AQIeNOZd2HiZPqJKWnWF6kRAcSvlEONODm6ptr47OCPGSYEog/RIRY?=
 =?us-ascii?Q?Kajdmvm2EB0mXPUwAKA9bHwGOEvWuOEfiz0tx8RXuDW9oGvO92nWHz1AIIiz?=
 =?us-ascii?Q?owLF72mP0vICehwh4IjOh9JJlvofa9dMKvHJVaAx9b95YrlepVr4OITQS02b?=
 =?us-ascii?Q?Pl18gNcK7bo939B3/sO4hv5wXK47hBYZN+jOjntmXDfp3a754ufjNNK674eO?=
 =?us-ascii?Q?25bFqP3/lDI/vIlBEFG7JL73NwU09O016Ao7Ef1YtMdoDWc4j40sVP1qyEyk?=
 =?us-ascii?Q?tuEACYFklmDqzbrJS2BvIk36M/tOpR8ncaghHNyw0iSnXW/v+K53YoXaPe1O?=
 =?us-ascii?Q?ALn6fkE7VaptORdHhDVex/furaY3QHbo3JvO69FVsm30ynWl4m2XlZLT9Bl4?=
 =?us-ascii?Q?0M//cAX0nq8QtOJY0BaG0t12yhic2rgQLIE/ELOkuwZujrKCP1PEwaX4gazE?=
 =?us-ascii?Q?T26v///loy5Dgub0wdsseG4bgoStQy7Cp+JhhgWAx5dxuwBrskZ/xkQltnxe?=
 =?us-ascii?Q?Xukvvf+wk6/VEhwVOHiM1jc5lJ7ZyPeU0W+uICwEHUn/oD6ceFdI5kHq3njz?=
 =?us-ascii?Q?EdFPnmPbD+WG4+cEMrhGjsS+rqkRS+eYiTKeCgooklR1xr+xxOFmyjz4YfFC?=
 =?us-ascii?Q?QafRbHP6QlTI9KmA+UN8g9edYpjI/Wqposm+/HJR45HZo/uzafS6b+apNYo4?=
 =?us-ascii?Q?QzkE9Ud0ihBldXQ6F8qaj3161zyjMP8te1sbe+PZRkXqZWcVh4hENW68/wH4?=
 =?us-ascii?Q?jOTchNjBXBQil0Pke57XmXsiKtaq2DdtRuoRzCjE8bwI2fG/VtXrpr2tZbal?=
 =?us-ascii?Q?IxM0qTx15imUPDraODD1ovxcUhqxFPna0gwt5abPJKeDk96GwVZpmgJElXRn?=
 =?us-ascii?Q?KFYc9KCs/HelE4VUU4MDRJRkbsixAV+/whltUC1s5DfPpKd4qjZwlAnWRimX?=
 =?us-ascii?Q?EyqBfY/MDhN0qzMMlwzDiXdPHjnTYgiQ/Eb+DxpDBRZ4vgmPsf0mjijjj9mP?=
 =?us-ascii?Q?yo/e6Hp7/toNapbeaBWldsM=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cacf577b-1f6b-4f14-dd8b-08d9e0b70251
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3527.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2022 10:31:27.4848
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qTicF0bUvQ1vBzPaUiWwgG8hSSn9TtkjebcgOHUtpO4OOZvdB8Fqssjh4HkUYVr2RS1WernHQgcitfJ9tQwXvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4461
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The number of modules can be resolved from the first argument, so do not
pass it.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core_env.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_env.c b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
index 6dd4ae2f45f4..e84453d70355 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_env.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
@@ -661,13 +661,12 @@ static int mlxsw_env_temp_event_set(struct mlxsw_core *mlxsw_core,
 	return mlxsw_reg_write(mlxsw_core, MLXSW_REG(mtmp), mtmp_pl);
 }
 
-static int mlxsw_env_module_temp_event_enable(struct mlxsw_core *mlxsw_core,
-					      u8 module_count)
+static int mlxsw_env_module_temp_event_enable(struct mlxsw_core *mlxsw_core)
 {
 	int i, err, sensor_index;
 	bool has_temp_sensor;
 
-	for (i = 0; i < module_count; i++) {
+	for (i = 0; i < mlxsw_core_env(mlxsw_core)->module_count; i++) {
 		err = mlxsw_env_module_has_temp_sensor(mlxsw_core, i,
 						       &has_temp_sensor);
 		if (err)
@@ -876,12 +875,11 @@ mlxsw_env_module_plug_event_unregister(struct mlxsw_env *mlxsw_env)
 }
 
 static int
-mlxsw_env_module_oper_state_event_enable(struct mlxsw_core *mlxsw_core,
-					 u8 module_count)
+mlxsw_env_module_oper_state_event_enable(struct mlxsw_core *mlxsw_core)
 {
 	int i, err;
 
-	for (i = 0; i < module_count; i++) {
+	for (i = 0; i < mlxsw_core_env(mlxsw_core)->module_count; i++) {
 		char pmaos_pl[MLXSW_REG_PMAOS_LEN];
 
 		mlxsw_reg_pmaos_pack(pmaos_pl, i);
@@ -1037,12 +1035,11 @@ int mlxsw_env_init(struct mlxsw_core *mlxsw_core, struct mlxsw_env **p_env)
 	if (err)
 		goto err_module_plug_event_register;
 
-	err = mlxsw_env_module_oper_state_event_enable(mlxsw_core,
-						       env->module_count);
+	err = mlxsw_env_module_oper_state_event_enable(mlxsw_core);
 	if (err)
 		goto err_oper_state_event_enable;
 
-	err = mlxsw_env_module_temp_event_enable(mlxsw_core, env->module_count);
+	err = mlxsw_env_module_temp_event_enable(mlxsw_core);
 	if (err)
 		goto err_temp_event_enable;
 
-- 
2.33.1

