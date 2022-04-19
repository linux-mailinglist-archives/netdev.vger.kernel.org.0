Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 169B350711A
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 16:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344346AbiDSO6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 10:58:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345537AbiDSO6L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 10:58:11 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2049.outbound.protection.outlook.com [40.107.223.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A3332B18F
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 07:55:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LndxSzjgypgo3BLkz5SAvPxXKDB7+GBXjUhHM+Aa5neO479WK5DUL1rRunS0tSGPU0WJgbzt9Xs7QWQAtpud4bumwrOdNKXSoQVS9NQErynFSlKeF1wFqAFs4biwt15+kGFJxw6ayiUYbGDGC87h6hw5E5tqOPmJZOYTvlVxnkZ2KfAgoOl58Iy1sPxqd0kSIGhkuHVCUU8fnC/VwKffpUKVtRIpFEqPkEHzNdtG/ogfeD3zkScMkj1/ic4J4ZIoFmeo/RlRI5G6tj6NE35MDkYfxPWfkM1QrtMWQwNQAXfUBrppkIRoqV1IUrZ/Vri8Puyf9R3Y3R+VwieiOnrj3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RSeG+9ZUpsM8RNgrsINGSocUUTzfLVC2YVttiCyhcY0=;
 b=luvRVGLPq+JW8DdqLQKN4ywUMbzUAzo+/knStaD4GR8l0Nad+ql7WNuHBy38ulmrnMq1QXyGgpfEwXEe35l1mDZyeuuebTVdMxv/JQhFHsbyDIV0/xQH4EdNI8RLprPie4eT3wvF7nPfhogzWiFLko3/604mnxyH6/EF/iV54FhCG+hNlX3j0xBx55s2P7RipHc7Hk70WGvN1KJWBi/usTEixc9GDkDFHTPOn+oo1Xdl4oSAvW+hAt4BaXQ4mhDm7b1qFRQvybq/kBFetxhpQOQLViyQcIWmgfwUbMEPTUx7PgPMM6hROXeEYenMO40/fo4IyoWATU6wWJZost2eQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RSeG+9ZUpsM8RNgrsINGSocUUTzfLVC2YVttiCyhcY0=;
 b=qLr/4l1iOd6di+thcTGYh0WPClLraS8kYdnI0Fjba+2+a42m4GRDktJnuo87QFdRZr5cug115PYgaWBPO/eq3CJQUgkwY6iQSFCGhkpg3qWXzndiFOaBW5gDrLDw/lOXAj3bDxRKhHJIDodIb4NzYKe8oah4r1tOP6F0KV7sEHhhkY0KcKoEO79cXXt88HTIIjUsFtBKSURM+yg9P7C+MYxBCD5HdIYtrSTBWJO02riDhaWcqD6pYRXIq0mobUnw6aTo2ho1Uj7WURRC6z1RAwcc6JOo+v+J1xNHol/hpkJEIzj7K0JHmQ6fTtc3f3hsh/S/Ph4aYr3K5Yf+Yyf0WA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MW3PR12MB4347.namprd12.prod.outlook.com (2603:10b6:303:2e::10)
 by BN6PR12MB1378.namprd12.prod.outlook.com (2603:10b6:404:1e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13; Tue, 19 Apr
 2022 14:55:26 +0000
Received: from MW3PR12MB4347.namprd12.prod.outlook.com
 ([fe80::9196:55b8:5355:f64d]) by MW3PR12MB4347.namprd12.prod.outlook.com
 ([fe80::9196:55b8:5355:f64d%2]) with mapi id 15.20.5186.013; Tue, 19 Apr 2022
 14:55:26 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        petrm@nvidia.com, jiri@nvidia.com, vadimp@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 3/6] mlxsw: core_env: Split module power mode setting to a separate function
Date:   Tue, 19 Apr 2022 17:54:28 +0300
Message-Id: <20220419145431.2991382-4-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220419145431.2991382-1-idosch@nvidia.com>
References: <20220419145431.2991382-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0222.eurprd08.prod.outlook.com
 (2603:10a6:802:15::31) To MW3PR12MB4347.namprd12.prod.outlook.com
 (2603:10b6:303:2e::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 050e8050-0c5b-4b98-0cc8-08da2214a363
X-MS-TrafficTypeDiagnostic: BN6PR12MB1378:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB137854C4D48C40AC099435C9B2F29@BN6PR12MB1378.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Er9+6RBECRJH9wDIEONsC90no4yTW+8Gze0MZ0WqQD39qsWPcFMQBaaTIVJN2FN7g9mITHVMcaWafoyMKNe8GGJ423x6qSqrGGLQ38wR8Qmovk0TkOcjWAHu7FSueS3WN99RHKAfZFnE/VABm8nHJCezrRjYR2whg8zkTmWiu7mjYlyJUw8kTgOQQcBSMAiIsSRkGvZWOGeF5mngJWOYuiogRC1d/L4e/uCyIcyasoh+R8FPZkXU6D0E6HPk4hpzz4zNoCNOzDMOIX797wHros2OczcQ3A63jaEZbFFmfK6KfotrZh6Em+nbeGM/Z8xO9kt1c2dGsff+TcQlAKvAVjzbNBXOj5l7uIuxvJ/EOEmCN6J8hvtbL9fjkBRqXsPOWlsK98xc3AYLiceuCE8dG1x6uS1x6NCokTCogWTB1UfrxbCW7hZStei37B3vZgsC7+617YbZnpCay7ILmJq5NPU81qCuKee5yCR8SbK1sPZ4rRD4MS1UDEtsVoG2jH7c8Tnm9YzmSjNl8+3VKCr3rNYmqeg97d9DXOWtxZJilVsyTgW0T83lUOor7PqHGavxkzZOQgjqgQUSZ2W4UtMwdELcfHCV6V75GAKuvBBorD58V8mxszzrWyj2q2imgh3JHDQP4WSF++k9ZCGxTEAeUw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4347.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(38100700002)(6486002)(508600001)(8936002)(5660300002)(316002)(26005)(6512007)(8676002)(4326008)(66946007)(66556008)(83380400001)(186003)(66476007)(2906002)(6506007)(6916009)(2616005)(1076003)(107886003)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?coMbJexW9hGpzJPoiQ8Lo/LBP6oF2RsaPJurUNl7TADL3TLvMM4K8h4tbYvW?=
 =?us-ascii?Q?QFg2j0Zi2gC3LxgE7E17FArqt0HO+Z3Vru1M8GI/WfnqV7MEhcv6/jI474vD?=
 =?us-ascii?Q?ZTwOgauVlj896+L5Ie8uQDCfV6E8Vwt1d5ZSGZXUWRhc62TW/sem8ZlJFXhT?=
 =?us-ascii?Q?xYrUN0JzaV5Hq2xk2XXQNJ/iP/1RZmcbw95aMQQM9XayHMLyoj6nrmQiEIsW?=
 =?us-ascii?Q?aM/FrpBB2B3ytQgCEp/rvD7BS/YxhH07wKheCP1ljMG0EeDAWGhqGlKEJahZ?=
 =?us-ascii?Q?VIEeM/h//em8uMlKFqMdseVkkXjK0wUa3AAcMR1fjY2n2AHfOYvM7d6aEOlm?=
 =?us-ascii?Q?eK6Bs11BZVW7w2SkM+qOIl6n/lrJeCvVSV0+FclP81SLIASs7zV7RNIvAo3M?=
 =?us-ascii?Q?Bz7+Sd1V8ji/fXZ0rB6oZ4iS8F0acJucbwHHP9ZuRGzHH0HCP6CmnJStORTo?=
 =?us-ascii?Q?+zq6+necLdPytyRs39pts9gIeGSDTEcngtCR5Mp4oUQq3SCzuKcVdYJv6XZG?=
 =?us-ascii?Q?X+zegPAEiy6XhUGR2CDCjK8qVt9oAboYF8JFtwD3RrgQzLPOmbEFhveF2qRr?=
 =?us-ascii?Q?3LzMTii6ad8iRk5Ew8hgP39R6tMZQEh+E2NQNy7/azV2TE7TtQ+/NCB/NAfV?=
 =?us-ascii?Q?QkhNK3afrprlgvH2DDOieEe+vvtLYZIL/RPiJf6GNddULCcfljzvaVB0+8gc?=
 =?us-ascii?Q?53vNWDhYl18reSE6LFwQebXOEtW65T5vjCdVCqJMBuuNp+IGQV7w3KUS3qFw?=
 =?us-ascii?Q?kuDOOPrnnnQ9xYSNhw27XeY8peiT7l3QXWp3p83YRS/OHAcda3yJcyVk+vzN?=
 =?us-ascii?Q?wLLSjdKBbcoZaX8De+OYJeygeJd+DN2K2LMSYtx1rfHPbYTNNqYRB+IDz6Oh?=
 =?us-ascii?Q?MMISAJcEWiULi21Z2MDnnEdQOhZrn828pPJA8T+JHNHgskJA4EoZg9YfQbbW?=
 =?us-ascii?Q?Gd6loyqCb+Ip+f36Sqz+cAQgvoEsFCvqNXqHYA1hc+sdqQBXki50pvjCCCMC?=
 =?us-ascii?Q?iWiuQ0C85a9Qxt/7WIxNn3sBOe+zIH4OBFPhej2k7cbSgi+Wz6ItZv8GPOoI?=
 =?us-ascii?Q?kXLEjtuX77NYfgnhQ9x/9y8PPk+2yNCRYT7ocoINwu8p93qZsayqcib/vPL3?=
 =?us-ascii?Q?pdXXPF35cXRnqT+PYst9BzbFENwb0qQhrgJ/5fjKRnzP6bVUy84/zJFF8Xr0?=
 =?us-ascii?Q?Vc9nRRVUalbs4qqceELCKMqFCNuUjLmCi5hsbEjxy+/Hw5NG6IdlMUTNto1n?=
 =?us-ascii?Q?+1B3vRM6f/Ba6hSttoomX0n/siaz+tRkg3320MykFkepmwYicCd9AgyUBvey?=
 =?us-ascii?Q?nM27Vc40IHt6ih1DH/eouBZ6C3UUsqft8aNqhxw0Iza/9bapLwz8DwQHPZf8?=
 =?us-ascii?Q?9fds5Qx1UiVXp8ZQMQBtOiJ48ii/PWOcTi0J+OaWXEjCl7wbbl2h0DR2hFbS?=
 =?us-ascii?Q?6N6SPBzOeVGti6sR+4vZZi+Q3XY2hroZr58tCcOwQpWLJzAK/WL5AG+PvkCe?=
 =?us-ascii?Q?aEkM6hEOCj9UglIwY2sf8+dA4jzDXHGQd6c+5bv4pl5PGcpUcphaGM+fJUIn?=
 =?us-ascii?Q?lvkguhZJSmeUWPf9cfT1lBNPKVsJ8nnhx1jald/KGcMT2R1o1625BW0A972Y?=
 =?us-ascii?Q?WVJoT+BZyQUcxZXw4dRmsuc6ku6rP/A3JWAO7T7nhMuoZjGM/8K90QUF42bs?=
 =?us-ascii?Q?H7hfYut7C4zu5aSmDolXi2UvRoFuZJmN6NUGAC6m1dNSkag9G2faTLljM6CX?=
 =?us-ascii?Q?0ETaCa7m7g=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 050e8050-0c5b-4b98-0cc8-08da2214a363
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4347.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2022 14:55:26.3932
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nCxep65DIsCuXM1k0DPyeyRLtBN2Ras1MfmkaoHrccwozs1kXNfkTfIJOaySZfh6Vj38oYhPfDNShb5jCWAWiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1378
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadim Pasternak <vadimp@nvidia.com>

Move the code that applies the module power mode to the device to a
separate function. This function will be invoked by the next patch to
set the power mode on transceiver modules found on a line card when the
line card becomes active.

Signed-off-by: Vadim Pasternak <vadimp@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/core_env.c    | 41 ++++++++++++-------
 1 file changed, 27 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_env.c b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
index abb54177485c..a9b133d6c2fc 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_env.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
@@ -648,25 +648,16 @@ static int __mlxsw_env_set_module_power_mode(struct mlxsw_core *mlxsw_core,
 	return err;
 }
 
-int
-mlxsw_env_set_module_power_mode(struct mlxsw_core *mlxsw_core, u8 slot_index,
-				u8 module,
-				enum ethtool_module_power_mode_policy policy,
-				struct netlink_ext_ack *extack)
+static int
+mlxsw_env_set_module_power_mode_apply(struct mlxsw_core *mlxsw_core,
+				      u8 slot_index, u8 module,
+				      enum ethtool_module_power_mode_policy policy,
+				      struct netlink_ext_ack *extack)
 {
-	struct mlxsw_env *mlxsw_env = mlxsw_core_env(mlxsw_core);
 	struct mlxsw_env_module_info *module_info;
 	bool low_power;
 	int err = 0;
 
-	if (policy != ETHTOOL_MODULE_POWER_MODE_POLICY_HIGH &&
-	    policy != ETHTOOL_MODULE_POWER_MODE_POLICY_AUTO) {
-		NL_SET_ERR_MSG_MOD(extack, "Unsupported power mode policy");
-		return -EOPNOTSUPP;
-	}
-
-	mutex_lock(&mlxsw_env->line_cards_lock);
-
 	err = __mlxsw_env_validate_module_type(mlxsw_core, slot_index, module);
 	if (err) {
 		NL_SET_ERR_MSG_MOD(extack,
@@ -691,7 +682,29 @@ mlxsw_env_set_module_power_mode(struct mlxsw_core *mlxsw_core, u8 slot_index,
 out_set_policy:
 	module_info->power_mode_policy = policy;
 out:
+	return err;
+}
+
+int
+mlxsw_env_set_module_power_mode(struct mlxsw_core *mlxsw_core, u8 slot_index,
+				u8 module,
+				enum ethtool_module_power_mode_policy policy,
+				struct netlink_ext_ack *extack)
+{
+	struct mlxsw_env *mlxsw_env = mlxsw_core_env(mlxsw_core);
+	int err;
+
+	if (policy != ETHTOOL_MODULE_POWER_MODE_POLICY_HIGH &&
+	    policy != ETHTOOL_MODULE_POWER_MODE_POLICY_AUTO) {
+		NL_SET_ERR_MSG_MOD(extack, "Unsupported power mode policy");
+		return -EOPNOTSUPP;
+	}
+
+	mutex_lock(&mlxsw_env->line_cards_lock);
+	err = mlxsw_env_set_module_power_mode_apply(mlxsw_core, slot_index,
+						    module, policy, extack);
 	mutex_unlock(&mlxsw_env->line_cards_lock);
+
 	return err;
 }
 EXPORT_SYMBOL(mlxsw_env_set_module_power_mode);
-- 
2.33.1

