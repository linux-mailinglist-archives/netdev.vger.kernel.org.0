Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 103444AB04A
	for <lists+netdev@lfdr.de>; Sun,  6 Feb 2022 16:37:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242568AbiBFPhf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Feb 2022 10:37:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244001AbiBFPhd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Feb 2022 10:37:33 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2082.outbound.protection.outlook.com [40.107.93.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BB05C0401C0
        for <netdev@vger.kernel.org>; Sun,  6 Feb 2022 07:37:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QM/YV+xR4g33zEzXM8y96+hrkJPixzJmKvKP1BApKINT4m90saNPP9eta8kp1NJUThUEFNtUkz5mYzpl1MujD74htsWkBRdV/LJNahwf5B1T38XZPPY++rnPQtvXA1TADIJXSlwwP4NTm2qa4/yHlMlYjChgz4k32nyLU/zu+/5ZdVqr0ohqBi7X7QPfjG4cmHaJQe4bXiVcTuEVJjzOqGPdaOniX5PNbjd72fzFbgxL3unTuQNFZRUiZNyHUv/DbzW66cKMT8phmOgBIw6gFLdg1ULF0OufoRDBF8xpYkfoH2VqGh7Fs9D4BSUbIwCW7B//BzYBBsGWVB/GGd/+jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PZ1lNa/9Y2vLJpfKZ3Pdmmwn0ZpPfS1/5Wory5HZKig=;
 b=l6WdQBQ4MbyEOSUqxxu4qPHPB0zonf1CgKtbJodc0tWieWfvyEQxWGpXq4lWqj5lkSD97PnFaN+ipMCPcdNpGDw++6/4WgmVTSoZiOAoeMjv1OKljttkKIpc1/4XSj9qaE4LYvpnNAcKQrUEyaBfhIXicTbqqtsOjL2QuQwFxUWuRv2S5hEHNgFn8Lpn4tUpKuJ5inIu2v/T515opknZOZWOXBz2Kcv0pFbFeDrakK/l03AyTMdW92ihuijfnAOTHrlRQhx5/ykL/C2I8QioEXd83kRruE7xbRSQEtiIUedLXbiBklp8St0ohdwqOo/jw1ebHdL+yMVcyaBuCpmIXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PZ1lNa/9Y2vLJpfKZ3Pdmmwn0ZpPfS1/5Wory5HZKig=;
 b=EeqSNUWVrVFPTouivdZ3Baq86iEzwquSdNdL0YGvU2oMW553ky/E/CFHNZY4Q0f6PWRIholkmovV8sjnDpa5Rf6+s30p9FprnSpCwtx4UwBBTbR2BV2sGm5vnDeKp7XAk4Bd38qE/LCoRTroJdj/pS7AsKMtA16CT+Cyfu6Ji62GSimbXhCinoB8ItZIB1QPGKMY5weNvmudr6Je1y8GLg3wmeUxn/8T2t6l4XdXQs5lc/LhwssGIzU2RQ3n8Dl/JRPOWSvm79EKShJg5lJMF+zDlxcWiMUFR8jtHiP6e93/jNAz+Gp5lBVMe6GWbCL4O3iLv2i1u+iF4T5JRcewzQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by BN8PR12MB3395.namprd12.prod.outlook.com (2603:10b6:408:43::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Sun, 6 Feb
 2022 15:37:29 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::5cff:a12b:dfa4:3eff]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::5cff:a12b:dfa4:3eff%3]) with mapi id 15.20.4951.018; Sun, 6 Feb 2022
 15:37:29 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        danieller@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 3/4] mlxsw: Support FLOW_ACTION_MANGLE for SIP and DIP IPv6 addresses
Date:   Sun,  6 Feb 2022 17:36:12 +0200
Message-Id: <20220206153613.763944-4-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220206153613.763944-1-idosch@nvidia.com>
References: <20220206153613.763944-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P18901CA0016.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:801::26) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5c70beeb-88cb-4126-45bb-08d9e986958d
X-MS-TrafficTypeDiagnostic: BN8PR12MB3395:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB3395556DCAFC4429461F4800B22B9@BN8PR12MB3395.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:747;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CZ33ySPW7EOn1ZU+jLRTVt9QxZSD0RuhIOgX4FUFoMRW4nU0t/gxNwR3xTNC85BTf+7EaBXq22Wp4BCNPNLEa2Be6zdsYiwayXbXmqxytT57LfSdAP+elUNizm50HZkzKXNmtoTnguz5MymcmgLRM3Z8DxYUbAdUNzsiG85ZwZqAz7F0IrtaI6KlTn2+2TwwsY9rUuZnvUgSWrza7+AU7jLvHl3rGgA4VHN3QXjg8B+KcSRNvkFjM+nLXPk+409tZiiSA0DNsWbpNTdqN4dtG9WZxa+Lf8RNXa9IglMEuCa+RcbYHMi+VyzgJc5OZYB9M6ZHOBQFka/4hg5k8y4xB1crm7QLAbFDTiGnhKrkJd5ZqjnE0FBjbg77NiRspCdysWu5+RJnBCmBqbWxVvGVs4nphR25gFZgvVNk38UKNbsJSWn96V9kLKFAvTO4yPRoChxpZlRnfmL8yK4y+slpqmLGsfdMRwJ97NTQhK+2UOkWltIFGQYiB+HnPYnH+ojMgTFvKgZdK1+tU9jy475drIJ1Z/e8QXK9YR8qMwkddWJ8HzvhwEvPu1YxlG1j+Ba8Hn10deDH67rZmG84rtSveX713fTGH6WKg9vOW0Xg+ibiuZHV9G5aP/wYyko31v4EQPobSB7eQ0G2ttW8osKkRA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(26005)(186003)(83380400001)(6506007)(6666004)(6512007)(5660300002)(6916009)(316002)(36756003)(8676002)(4326008)(2906002)(66556008)(66476007)(86362001)(8936002)(66946007)(508600001)(107886003)(1076003)(2616005)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rrxTURnIufke+A92dbdZ8ICIdY5Z9do/hKDI80UOWElCtz94gwS9RAD+S9Ip?=
 =?us-ascii?Q?4/EUdBg6gUkNnB3rIsQ8YiwNqrqvj0GWK+K7NZl6cNY9IMRU6QJQP41+faeC?=
 =?us-ascii?Q?ESbJCAnZi9+LiDu+yhmT0x6ChapQvkLAnngY6pJnmTajvcRpUGeXym61zcJO?=
 =?us-ascii?Q?SXFt/Ftbys6H4j7Y5ywogNQPWSg0gvhG5Vc4gzKRZAcrslO1KGcn6E+mDt5U?=
 =?us-ascii?Q?8JTYO1sOxMxPSMg09PTSi6dZooY8ngsI0wRpPu1WxyO6iGAzNF3Oc6Dtmg9W?=
 =?us-ascii?Q?m1b0L3vw9w9CRHn721OdMznIGsiMHWmaxFGnCav5hO1vLlf3T6Uis36WkF4X?=
 =?us-ascii?Q?UycGJVOe5JlQJjXxK4ryDFov5OktSCLb9+alU93ehaRFxSY9XGARkzj65HRy?=
 =?us-ascii?Q?N+aqOA5dxxyi+6y4/xjX4BCI2A9wVs+FiChSqVs7jtlosr2yx3MAcuJuymhh?=
 =?us-ascii?Q?moKaS/3OU4LAimiwPgVTuy9YT21r68kUuW7HmyfqwCdmgGsK5fodnyGRPssz?=
 =?us-ascii?Q?43RGFgQ84jJMBZWTCLAkoiWjuD/5GF1bgaAItrZEUDjKtlLXIH37OV7DNMzX?=
 =?us-ascii?Q?EaVWoTv4d181y/qCjWUg3UUmjXETl03YmFkJr6eDg2H4qsQ/WHGJeKwq3coN?=
 =?us-ascii?Q?c3/X3AGqF8Wb/PA+JKILezCXa0ff5XgQm33GmWzK/OgWqD9jLoSU0VCUvOaC?=
 =?us-ascii?Q?0Jls7tZaBhHain85GSpN1owOvtKEoKKP7IEOTjIZ2d1vW2ijSbgToraI3rLS?=
 =?us-ascii?Q?X2xk7sHHmI77rWms7XEQpaNb/4uqprYoXdNFwmKggqeEQAfIeAy3hYHyfEba?=
 =?us-ascii?Q?GbT/jtW/eww/jDltSgdBpimyf59ZrgAQkHWFTbPITuLsMXzyXGhWENi68DQW?=
 =?us-ascii?Q?8QRdLINmZTYwwtvLhGy46izE4BiddvK9wirpYYuL7NJYrr/nLRyUCn+lA90Z?=
 =?us-ascii?Q?kod93k538WJGt/0usS+NT3cYH7oPUhmYERQI3JKBnZMKuS1GEt0x8/Qej1cX?=
 =?us-ascii?Q?ts02dzFKCJiK3DJ9Vid6HR8OQnSEVkPsyQFM9XHoexiO35Xq//l5QaNF2fmr?=
 =?us-ascii?Q?lhBF5oZD80C+Q8zzYAzWgADfHizNyf+qJAokbwfGkFRPGPGfJtI4UWBfLwyV?=
 =?us-ascii?Q?E3EI8MTBNOmYMJcLVVfpw03eDV5nWqIiqgME9qW9l/6+N0xfyKJkkXeLw8Sx?=
 =?us-ascii?Q?wT7c4QMnevea5MojtF/3qcGuq2IsU0I235HJKamXeF2K++Wn75121fFtL5CD?=
 =?us-ascii?Q?/z2Fuqwzmyq1dgjSXGSSc016czORKb5v/Ep8ZHx1etljegIT1//PkBPfr46J?=
 =?us-ascii?Q?bTsQQWTvJMBwJxzWPuz37VXeuIopz4eeDU4dwPuXy6EX+P3Zs5TxPS1PuolC?=
 =?us-ascii?Q?AtPk8mP9bc9E/ZpE19lDvZIzCf0M4n13TDDUcGj/wSkF7t5Q3/88qD+13n6y?=
 =?us-ascii?Q?UOo4GLDwMoZaz2521M+kUQ2uEKGR11OkuUiDb/QWGKYv2OkIutdKlAALcGjg?=
 =?us-ascii?Q?90snqpxjwBQRcpxPz1UzXd0YcdvnByHMVOJfaGJyLQrxVn7a2ChuHhIaA3Sg?=
 =?us-ascii?Q?Ce338hejavjjvs/O9Tu7fUZvL5G9VKTofC/xbuShqQXTFNEG8Xh1tH7/5iA7?=
 =?us-ascii?Q?S4O7mDI4RhNhFCWgJg2trvE=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c70beeb-88cb-4126-45bb-08d9e986958d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2022 15:37:29.4682
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fJIrGt+Ps0og01lM+iHoYQ8/lEi8t5+13h3lUHgh48ppaTVFiYTxNSIXx/Pntg6UrnrcT1GWaVHo0ZrixRru4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3395
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

Spectrum-2 supports an ACL action SIP_DIP, which allows IPv4 and IPv6
source and destination addresses change. Offload suitable mangles to
the IPv6 address change action.

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.h    | 25 +++++-
 .../ethernet/mellanox/mlxsw/spectrum_acl.c    | 83 ++++++++++++++++---
 .../ethernet/mellanox/mlxsw/spectrum_flower.c |  6 ++
 3 files changed, 103 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 30942b6ffcf9..20588e699588 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -820,6 +820,24 @@ int mlxsw_sp1_kvdl_resources_register(struct mlxsw_core *mlxsw_core);
 /* spectrum2_kvdl.c */
 extern const struct mlxsw_sp_kvdl_ops mlxsw_sp2_kvdl_ops;
 
+enum mlxsw_sp_acl_mangle_field {
+	MLXSW_SP_ACL_MANGLE_FIELD_IP_DSFIELD,
+	MLXSW_SP_ACL_MANGLE_FIELD_IP_DSCP,
+	MLXSW_SP_ACL_MANGLE_FIELD_IP_ECN,
+	MLXSW_SP_ACL_MANGLE_FIELD_IP_SPORT,
+	MLXSW_SP_ACL_MANGLE_FIELD_IP_DPORT,
+	MLXSW_SP_ACL_MANGLE_FIELD_IP4_SIP,
+	MLXSW_SP_ACL_MANGLE_FIELD_IP4_DIP,
+	MLXSW_SP_ACL_MANGLE_FIELD_IP6_SIP_1,
+	MLXSW_SP_ACL_MANGLE_FIELD_IP6_SIP_2,
+	MLXSW_SP_ACL_MANGLE_FIELD_IP6_SIP_3,
+	MLXSW_SP_ACL_MANGLE_FIELD_IP6_SIP_4,
+	MLXSW_SP_ACL_MANGLE_FIELD_IP6_DIP_1,
+	MLXSW_SP_ACL_MANGLE_FIELD_IP6_DIP_2,
+	MLXSW_SP_ACL_MANGLE_FIELD_IP6_DIP_3,
+	MLXSW_SP_ACL_MANGLE_FIELD_IP6_DIP_4,
+};
+
 struct mlxsw_sp_acl_rule_info {
 	unsigned int priority;
 	struct mlxsw_afk_element_values values;
@@ -828,9 +846,14 @@ struct mlxsw_sp_acl_rule_info {
 	   ingress_bind_blocker:1,
 	   egress_bind_blocker:1,
 	   counter_valid:1,
-	   policer_index_valid:1;
+	   policer_index_valid:1,
+	   ipv6_valid:1;
 	unsigned int counter_index;
 	u16 policer_index;
+	struct {
+		u32 prev_val;
+		enum mlxsw_sp_acl_mangle_field prev_field;
+	} ipv6;
 };
 
 /* spectrum_flow.c */
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
index 6e43a6ba09bd..6c5af018546f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
@@ -505,16 +505,6 @@ int mlxsw_sp_acl_rulei_act_priority(struct mlxsw_sp *mlxsw_sp,
 						      extack);
 }
 
-enum mlxsw_sp_acl_mangle_field {
-	MLXSW_SP_ACL_MANGLE_FIELD_IP_DSFIELD,
-	MLXSW_SP_ACL_MANGLE_FIELD_IP_DSCP,
-	MLXSW_SP_ACL_MANGLE_FIELD_IP_ECN,
-	MLXSW_SP_ACL_MANGLE_FIELD_IP_SPORT,
-	MLXSW_SP_ACL_MANGLE_FIELD_IP_DPORT,
-	MLXSW_SP_ACL_MANGLE_FIELD_IP4_SIP,
-	MLXSW_SP_ACL_MANGLE_FIELD_IP4_DIP,
-};
-
 struct mlxsw_sp_acl_mangle_action {
 	enum flow_action_mangle_base htype;
 	/* Offset is u32-aligned. */
@@ -566,6 +556,15 @@ static struct mlxsw_sp_acl_mangle_action mlxsw_sp_acl_mangle_actions[] = {
 
 	MLXSW_SP_ACL_MANGLE_ACTION_IP4(12, 0x00000000, 0, IP4_SIP),
 	MLXSW_SP_ACL_MANGLE_ACTION_IP4(16, 0x00000000, 0, IP4_DIP),
+
+	MLXSW_SP_ACL_MANGLE_ACTION_IP6(8, 0x00000000, 0, IP6_SIP_1),
+	MLXSW_SP_ACL_MANGLE_ACTION_IP6(12, 0x00000000, 0, IP6_SIP_2),
+	MLXSW_SP_ACL_MANGLE_ACTION_IP6(16, 0x00000000, 0, IP6_SIP_3),
+	MLXSW_SP_ACL_MANGLE_ACTION_IP6(20, 0x00000000, 0, IP6_SIP_4),
+	MLXSW_SP_ACL_MANGLE_ACTION_IP6(24, 0x00000000, 0, IP6_DIP_1),
+	MLXSW_SP_ACL_MANGLE_ACTION_IP6(28, 0x00000000, 0, IP6_DIP_2),
+	MLXSW_SP_ACL_MANGLE_ACTION_IP6(32, 0x00000000, 0, IP6_DIP_3),
+	MLXSW_SP_ACL_MANGLE_ACTION_IP6(36, 0x00000000, 0, IP6_DIP_4),
 };
 
 static int
@@ -604,6 +603,22 @@ static int mlxsw_sp1_acl_rulei_act_mangle_field(struct mlxsw_sp *mlxsw_sp,
 	return err;
 }
 
+static int
+mlxsw_sp2_acl_rulei_act_mangle_field_ip_odd(struct mlxsw_sp_acl_rule_info *rulei,
+					    enum mlxsw_sp_acl_mangle_field field,
+					    u32 val, struct netlink_ext_ack *extack)
+{
+	if (!rulei->ipv6_valid) {
+		rulei->ipv6.prev_val = val;
+		rulei->ipv6_valid = true;
+		rulei->ipv6.prev_field = field;
+		return 0;
+	}
+
+	NL_SET_ERR_MSG_MOD(extack, "Unsupported mangle field order");
+	return -EOPNOTSUPP;
+}
+
 static int mlxsw_sp2_acl_rulei_act_mangle_field(struct mlxsw_sp *mlxsw_sp,
 						struct mlxsw_sp_acl_rule_info *rulei,
 						struct mlxsw_sp_acl_mangle_action *mact,
@@ -627,6 +642,54 @@ static int mlxsw_sp2_acl_rulei_act_mangle_field(struct mlxsw_sp *mlxsw_sp,
 	case MLXSW_SP_ACL_MANGLE_FIELD_IP4_DIP:
 		return mlxsw_afa_block_append_ip(rulei->act_block, true,
 						 true, val, 0, extack);
+	/* IPv6 fields */
+	case MLXSW_SP_ACL_MANGLE_FIELD_IP6_SIP_1:
+	case MLXSW_SP_ACL_MANGLE_FIELD_IP6_SIP_3:
+	case MLXSW_SP_ACL_MANGLE_FIELD_IP6_DIP_1:
+	case MLXSW_SP_ACL_MANGLE_FIELD_IP6_DIP_3:
+		return mlxsw_sp2_acl_rulei_act_mangle_field_ip_odd(rulei,
+								   mact->field,
+								   val, extack);
+	case MLXSW_SP_ACL_MANGLE_FIELD_IP6_SIP_2:
+		if (rulei->ipv6_valid &&
+		    rulei->ipv6.prev_field == MLXSW_SP_ACL_MANGLE_FIELD_IP6_SIP_1) {
+			rulei->ipv6_valid = false;
+			return mlxsw_afa_block_append_ip(rulei->act_block,
+							 false, false, val,
+							 rulei->ipv6.prev_val,
+							 extack);
+		}
+		break;
+	case MLXSW_SP_ACL_MANGLE_FIELD_IP6_SIP_4:
+		if (rulei->ipv6_valid &&
+		    rulei->ipv6.prev_field == MLXSW_SP_ACL_MANGLE_FIELD_IP6_SIP_3) {
+			rulei->ipv6_valid = false;
+			return mlxsw_afa_block_append_ip(rulei->act_block,
+							 false, true, val,
+							 rulei->ipv6.prev_val,
+							 extack);
+		}
+		break;
+	case MLXSW_SP_ACL_MANGLE_FIELD_IP6_DIP_2:
+		if (rulei->ipv6_valid &&
+		    rulei->ipv6.prev_field == MLXSW_SP_ACL_MANGLE_FIELD_IP6_DIP_1) {
+			rulei->ipv6_valid = false;
+			return mlxsw_afa_block_append_ip(rulei->act_block,
+							 true, false, val,
+							 rulei->ipv6.prev_val,
+							 extack);
+		}
+		break;
+	case MLXSW_SP_ACL_MANGLE_FIELD_IP6_DIP_4:
+		if (rulei->ipv6_valid &&
+		    rulei->ipv6.prev_field == MLXSW_SP_ACL_MANGLE_FIELD_IP6_DIP_3) {
+			rulei->ipv6_valid = false;
+			return mlxsw_afa_block_append_ip(rulei->act_block,
+							 true, true, val,
+							 rulei->ipv6.prev_val,
+							 extack);
+		}
+		break;
 	default:
 		break;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
index bb417db773b9..f54af3d9a03b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
@@ -233,6 +233,12 @@ static int mlxsw_sp_flower_parse_actions(struct mlxsw_sp *mlxsw_sp,
 			return -EOPNOTSUPP;
 		}
 	}
+
+	if (rulei->ipv6_valid) {
+		NL_SET_ERR_MSG_MOD(extack, "Unsupported mangle field");
+		return -EOPNOTSUPP;
+	}
+
 	return 0;
 }
 
-- 
2.33.1

