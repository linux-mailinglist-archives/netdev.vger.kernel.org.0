Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A792249DD38
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 10:03:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234582AbiA0JDI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 04:03:08 -0500
Received: from mail-bn7nam10on2081.outbound.protection.outlook.com ([40.107.92.81]:31969
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238134AbiA0JDI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jan 2022 04:03:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ennv39QHO4FvPazQICx+n9SDd1Pt3+yT5VM7ns6UF9MR/Iv1BKIbr8KblMSgE9ZYsmOExcYn2RXhD813lsewI66aE8HlmgZvNEe8eCLR/Aqt2PnM7aHoCFonvGCHx7M05A7OLvf4VHcPRrNlsJmDKiWvvGCeZSOaAWkEdvZ60meA5LtTpGaZ+58+j+uylQu3c+9fvJmjuhQTV4n0KeXOtRFny5GYo2/Oexc2uH6NTmwDerDyJMho/N8EP5Wq+Ar5E5CF41ekOYY/mw99/N5KY3wR/0U63xsREgunbEZpRiHff6yNWXz0rt5hOnxGW5cS+7UPxAGOr7da7pZ9MxN9ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cTvPm9PxGRPlHpbNl8Spe2YXd7SWIH8NWrZtBfS79QI=;
 b=liyW5NddS4GXUw+Nejk2Pj5A3TIliHnewYC3PuO26W9RC95RefYMRTloy5OrAuW3ygGvE1cGGBBNLYGh94uZVglABwQZz3Eor/MHL9HvXC3I+6+nmXESyiKoB5x87d+drVMJgrEMnhVN5RxzKiue0Bev0wgSesBNnwfNiU4kvIhBgueFG5qlYMWugl0P5FbHn1ZcunEq0YBOWHCQAlTIxJRHGbRXnXx8g4dB7zZy+RXB3quAN4BgQWlaSpcTuvfy0bKrELREmoeaHSvJKKO3MnQcuxeN7qUK2n3klzJupeSvr2WkD6Ev9veMdJsReNSde95j9UwEQY3/Qgoh32kOkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cTvPm9PxGRPlHpbNl8Spe2YXd7SWIH8NWrZtBfS79QI=;
 b=nXhYai1rRgGpDV6mgF86dvmvvmQr9tXz2XFZUCd2OyogUyNjZrRydXvlPQV4jYSuZd97BSKoafHrKgWNx+94NFjPwbWmymLAp/2tXwcjzoz1yJ+i49ucayBzoosVUFnPY+dJKz8mwtnmNTXhp6aPswSJaivFWCao8aJab6zDFXogAPX0KorDPT4mdoeM7vzzDUrZVnmeh27mfhXbOI5935vhMAhBL0+sEkVMChT51bB91w5lDyHAtQx2ADmwflTHMeJjXeXLVshQrjigHvrvBYlkYUVgjTHnUEU4UsppBu6gWkdZEhV66XtcSKC03Hg33bc+urUmtwyc32wPGcpxZA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3527.namprd12.prod.outlook.com (2603:10b6:a03:13c::12)
 by BN9PR12MB5355.namprd12.prod.outlook.com (2603:10b6:408:104::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.10; Thu, 27 Jan
 2022 09:03:06 +0000
Received: from BYAPR12MB3527.namprd12.prod.outlook.com
 ([fe80::3dfb:4df1:dcf1:4561]) by BYAPR12MB3527.namprd12.prod.outlook.com
 ([fe80::3dfb:4df1:dcf1:4561%5]) with mapi id 15.20.4909.019; Thu, 27 Jan 2022
 09:03:06 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        jiri@nvidia.com, amcohen@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 1/7] mlxsw: spectrum: Set basic trap groups from an array
Date:   Thu, 27 Jan 2022 11:02:20 +0200
Message-Id: <20220127090226.283442-2-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220127090226.283442-1-idosch@nvidia.com>
References: <20220127090226.283442-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0801CA0073.eurprd08.prod.outlook.com
 (2603:10a6:800:7d::17) To BYAPR12MB3527.namprd12.prod.outlook.com
 (2603:10b6:a03:13c::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a4433c24-7b49-4ab1-061d-08d9e173d50c
X-MS-TrafficTypeDiagnostic: BN9PR12MB5355:EE_
X-Microsoft-Antispam-PRVS: <BN9PR12MB535544263136EEABCE217463B2219@BN9PR12MB5355.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YOe8+gGm7Rz8nNqNdioAXxmm2Tw8j+P3JmEA4M9lSCtTguXEb5PYtpHgLs7LWKEKW5pk08C77HEMZWONeOhadlLvjiQkHlF+Yl6MR9y8icPsufpVBTRsxlfLvq1tlaBYEs0n7nINYzPMC3dRapMrmFuIOTPhVjPS92u6zKvFv9GU/rNwIydLaTLNUbBqkOaBrfkKEjIsDMBsmRnKXTgPu7SMQtQmjx0O+VtbidiHyzACA2W2+d5EYiy6f8gQrx1iLBKFZLTOE9RGDkkb34n5PBvrjIsXTqeIWgGqrgO85/1MLUMgdyq1UbKk64poJ2J+2ov5GZ+s46Z6Y1ils+P9HNPjny5j6nOstpiJxYwNUcYeYqKn44LPxuecLcR/Z9HhPVn95WYyG5ETPbkAPYxysZA31uuCpVp772ficqhSiWxG6fobqPUoBMGOilWX4fe8dW01hkaIs7FciHVTXedN6V7j9UY1eESXo4/KMGMImuKm0kuEWU3tYBowaFelnfOPsWXhakodg/R3qtALF0RMHX0uguRkxcmgc/oOoKQm3VVxUROLhnBBwSOytz+xVn17Rpl3iX97EfGl6fLirf9j0qp1jZcq9XoyGjf2f8AwQI79T8PcP6o+kER1p8GekyPtD9zJXFNyxaFldQDR1uBI9g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3527.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(6512007)(2616005)(6916009)(4326008)(8676002)(316002)(6486002)(66946007)(26005)(186003)(86362001)(1076003)(66476007)(107886003)(508600001)(8936002)(6666004)(66556008)(5660300002)(83380400001)(6506007)(36756003)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kDeYP/tqrIAGW0yeJBW3kJdUm4CVyiLOaR6Qtk/m6/1JmIUmlxgfREOc3lIc?=
 =?us-ascii?Q?M+Y9aNC2VOwB6Yb3NCYUWMQVpgVH+n8/rdAlX9seBNLv1GuxC47rea3opEkV?=
 =?us-ascii?Q?2n7zrDdadM3jVl5LBGqIzv5lW761aipr52NVsgVT+aqP9i2DdgxNy1o2XuI0?=
 =?us-ascii?Q?WMaduQJz53eERGUdamSI5U0oU2fMxZHbwHtKf30HSnwS6VyNgj2CgVkn6OYz?=
 =?us-ascii?Q?4vbd+XxpbJim52nda06WNaJupTzw58ctq6wW+ka1YLSVAcQAVYLUxUhP3c1/?=
 =?us-ascii?Q?BJ6mGb7pbotptEGCQxO9DLuA6VGLWRbCh7gSPyzs71WBQsUqXqx7C7qAyhJ8?=
 =?us-ascii?Q?YOOw3oqSAlutWgLF0Shi5YSQFSfcunrZEK2FjPuhD6ZCFKj5dskvsGor+b8w?=
 =?us-ascii?Q?Nr7KLQc4qKPshggl8U5ux3qIf21PcqnYRvgmKkU04K5961hb0qadoebZCCH8?=
 =?us-ascii?Q?5uOV2ALoASE8G6H9MvjKJet4whLTbY8c3WoWaRETiMVn2MasXCl0ejSl4ELM?=
 =?us-ascii?Q?arhlh00dm73CcsfgDbDFe3bKa5PNjuYDlGzBOD9Pl4kKhJOXwF7lXy0ka0Ej?=
 =?us-ascii?Q?zG4i2IEdHG6Zswjx38XbfK0wQFts3sq2yYzs8yzt8CfbFVtey/kvAF6MQnB/?=
 =?us-ascii?Q?S2PabOZc8g4Hps9kVE93RRwhEKc6M1rDOoBcWMk027U1xv1ctq6nKyp7nxJn?=
 =?us-ascii?Q?xc+yognRBj8S3dmjLKF/QmIrGjTJ+Q5y0LMBhxrjQFEf3TIYJERzaF5ZEvXL?=
 =?us-ascii?Q?Fql7bYyz1Op0erFE5xhOAuSHl5foSGx+ZhkPZVT4XaR6J39B1UHGqx6nAciC?=
 =?us-ascii?Q?ndL+dXehPc+UPJysItERNQ2sHBKNH0DciHaezGnyMP44C2QAqMpGNzRZOiv7?=
 =?us-ascii?Q?iXF6tphtJ9LK0LcZwbCv8m6Tve32VpCzvY4trVHcrb1pGBIjAKC1Q6gxnuaB?=
 =?us-ascii?Q?VL+8sUPX963eJW5PsAQ35yBndQIXWbcA69JLWvqovHJPvjj8bN8rKQcI0c9d?=
 =?us-ascii?Q?8bnObHjzjvZFypoiddmUEzlC5Qevw0g1nDcQmIAH8pCXfPCuOn6CfRd6p5rS?=
 =?us-ascii?Q?jbwVzz2phABHzLMMyKeOliucqvx2iQw+v5UIhCb36XxYS/B9/A+IRuOBNJU4?=
 =?us-ascii?Q?js0fRFMuXkBI7VTYbhxb/snou0NnrQwi0GRKT2goLN8ItOQPcrju+pRNXx3z?=
 =?us-ascii?Q?S5wy89rMJeeCSQak2VBFngt/kv/2usSXAjWr4SJpcOYDR+ofYlvqDxdJcyBU?=
 =?us-ascii?Q?F+elHlfMDGiVXRQAOc+sKRuUT0up4OYMlPYx+4uwt1roVmV1DzNqBjw0CYzN?=
 =?us-ascii?Q?1imxFFBeWyBVsLkR5WnJJ7bWwJ7vwg4WvCYqM8LQ9TUF2HWWtK9/jxPc2Xwx?=
 =?us-ascii?Q?DscEcAvx5gHxmg4ko2TgRcj3XBEj0mQrRczlLXMNuof2Ya9Fb5zUfxCCQy5O?=
 =?us-ascii?Q?OKNmCy8FPFh2IqMlpkp42DoyxacojZ5bdlWx1pM7wyLU1DiDnGWTx8txKbe8?=
 =?us-ascii?Q?GLx0Af8T72mE+Gs4LNlt6EvwhHmiBV6GEnf0fWBnGTNhNz1cKdJccSt/xcN9?=
 =?us-ascii?Q?KKbD6rASdozBf9thjn24OcPmnI7jr/9yonAkv1XVTDo8j4/90CIVM03i1DOm?=
 =?us-ascii?Q?+aDGpS6kZuLECuL8OIi8cVE=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4433c24-7b49-4ab1-061d-08d9e173d50c
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3527.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2022 09:03:06.4584
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mTMd6wUaaUNjYxb5KdrP2KTqFMUnQmz8ZpM+MrXDvqGCN7PCqpMjsDE1gGVYCzGdCOt7pnZE8q9QmIV5GnPH1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5355
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Instead of calling the same code four times, do it in a loop over array
which contains trap grups to be set.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 47 +++++++------------
 1 file changed, 18 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index aa411dec62f0..4c6497753912 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -2528,40 +2528,29 @@ static void mlxsw_sp_lag_fini(struct mlxsw_sp *mlxsw_sp)
 	kfree(mlxsw_sp->lags);
 }
 
+static const u8 mlxsw_sp_basic_trap_groups[] = {
+	MLXSW_REG_HTGT_TRAP_GROUP_EMAD,
+	MLXSW_REG_HTGT_TRAP_GROUP_MFDE,
+	MLXSW_REG_HTGT_TRAP_GROUP_MTWE,
+	MLXSW_REG_HTGT_TRAP_GROUP_PMPE,
+};
+
 static int mlxsw_sp_basic_trap_groups_set(struct mlxsw_core *mlxsw_core)
 {
 	char htgt_pl[MLXSW_REG_HTGT_LEN];
 	int err;
+	int i;
 
-	mlxsw_reg_htgt_pack(htgt_pl, MLXSW_REG_HTGT_TRAP_GROUP_EMAD,
-			    MLXSW_REG_HTGT_INVALID_POLICER,
-			    MLXSW_REG_HTGT_DEFAULT_PRIORITY,
-			    MLXSW_REG_HTGT_DEFAULT_TC);
-	err =  mlxsw_reg_write(mlxsw_core, MLXSW_REG(htgt), htgt_pl);
-	if (err)
-		return err;
-
-	mlxsw_reg_htgt_pack(htgt_pl, MLXSW_REG_HTGT_TRAP_GROUP_MFDE,
-			    MLXSW_REG_HTGT_INVALID_POLICER,
-			    MLXSW_REG_HTGT_DEFAULT_PRIORITY,
-			    MLXSW_REG_HTGT_DEFAULT_TC);
-	err = mlxsw_reg_write(mlxsw_core, MLXSW_REG(htgt), htgt_pl);
-	if (err)
-		return err;
-
-	mlxsw_reg_htgt_pack(htgt_pl, MLXSW_REG_HTGT_TRAP_GROUP_MTWE,
-			    MLXSW_REG_HTGT_INVALID_POLICER,
-			    MLXSW_REG_HTGT_DEFAULT_PRIORITY,
-			    MLXSW_REG_HTGT_DEFAULT_TC);
-	err = mlxsw_reg_write(mlxsw_core, MLXSW_REG(htgt), htgt_pl);
-	if (err)
-		return err;
-
-	mlxsw_reg_htgt_pack(htgt_pl, MLXSW_REG_HTGT_TRAP_GROUP_PMPE,
-			    MLXSW_REG_HTGT_INVALID_POLICER,
-			    MLXSW_REG_HTGT_DEFAULT_PRIORITY,
-			    MLXSW_REG_HTGT_DEFAULT_TC);
-	return mlxsw_reg_write(mlxsw_core, MLXSW_REG(htgt), htgt_pl);
+	for (i = 0; i < ARRAY_SIZE(mlxsw_sp_basic_trap_groups); i++) {
+		mlxsw_reg_htgt_pack(htgt_pl, mlxsw_sp_basic_trap_groups[i],
+				    MLXSW_REG_HTGT_INVALID_POLICER,
+				    MLXSW_REG_HTGT_DEFAULT_PRIORITY,
+				    MLXSW_REG_HTGT_DEFAULT_TC);
+		err = mlxsw_reg_write(mlxsw_core, MLXSW_REG(htgt), htgt_pl);
+		if (err)
+			return err;
+	}
+	return 0;
 }
 
 static const struct mlxsw_sp_ptp_ops mlxsw_sp1_ptp_ops = {
-- 
2.33.1

