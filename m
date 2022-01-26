Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E98A49C79B
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 11:32:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240042AbiAZKcG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 05:32:06 -0500
Received: from mail-mw2nam12on2065.outbound.protection.outlook.com ([40.107.244.65]:2593
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240029AbiAZKcB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jan 2022 05:32:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EqdQ5SwV9YtZnMYZMU04lkeK3MNFf4gMXDsYCe+3i3B9HFuz7MwFIkrngan6WqWBav8MEEdu1Piwu9zWFfdjLUaml+mY+Sny8MUq8AWcT6tcCoPi8i/PKot0ejZCF0SxPnibLW0mf+GOvzioLjUEbK9gDrokCLRDI0lxUAVfw2kTXkholz+HpkYnyUT27zsQb/s8pkhSq5ImGEARZxdGMJLiXerpPWM4H6WGf6aI0EamXbjBfaa6hX/arxYKrkGGxYvuf8znGeegcyj0fYoKGNMbNxsgFRlHuAbGWGhrD2QXYaufKd3qhh+oaem+xFh2I560ScV2QvX0EiC9SZlusA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zX0Nbzha89xwBjlqwgz7aizf06vesWROK+56A4cFpsg=;
 b=iGoELT5kz7t5sTJbYT5K+HpNykYpnKlEhdBLn09XDRQ7D+6fWLpsiiPiQvD3fhWkk6NVOc9Uw43J97vvHtYza6SJD+HC6TTIyW23KBj02WFqfe0wQ508prDPM33AObvE4cDZv8+2vCdDBsEsYvabxC+72lvdFHzz5XheKPv2uFHqQ86RT8QZacvae4On5tJaL675TDhvQgQGy7pcRY8uoNZ1T+dQfgp/tHofBk5xlhu0ssbmPwJh6MY5ylQG+io1jD/kmjbL3KnCmcoNVryB30USwSP/OnjzAQBUPPSNnOL9a5xM/iRuieVblO4+cTe+wmjr8SxYLLU0IC70yzdxMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zX0Nbzha89xwBjlqwgz7aizf06vesWROK+56A4cFpsg=;
 b=KH4iWnb0JGkdgNvTkfGvu9qeNmAwmt30s89p+Oz7rtaL9X6sEBGAS6+qWbrZoPDi50npfc8iLPVay4qT+0VwZr764/3sDqilD1nHYgWpAxTaZaau6xrHKyTeuDDKJDKFkdcM0xwOY+jJ/Nis7/2A0f2xzJlbEUuiF6+hOn6b8j48ZY1OeMxJMW5+NM9+C8rnYAciNKe0ut37syQXtgG3Wz8u1jmA9n9JILSzo2GvKer9qV2/pXH70Wbc0i/J4DfzzllfokaSDYKIx5wNbEedPnOKXpU0SEZ/63NVtlsUf3/ttBlPoRisnLBKcDiK7Cwl4gSJqVGOI0i3UwGKs7tvjQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3527.namprd12.prod.outlook.com (2603:10b6:a03:13c::12)
 by BN8PR12MB3620.namprd12.prod.outlook.com (2603:10b6:408:49::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.12; Wed, 26 Jan
 2022 10:31:58 +0000
Received: from BYAPR12MB3527.namprd12.prod.outlook.com
 ([fe80::3dfb:4df1:dcf1:4561]) by BYAPR12MB3527.namprd12.prod.outlook.com
 ([fe80::3dfb:4df1:dcf1:4561%5]) with mapi id 15.20.4909.017; Wed, 26 Jan 2022
 10:31:57 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        danieller@nvidia.com, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 6/9] mlxsw: core_env: Query and store port module's type during initialization
Date:   Wed, 26 Jan 2022 12:30:34 +0200
Message-Id: <20220126103037.234986-7-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220126103037.234986-1-idosch@nvidia.com>
References: <20220126103037.234986-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR09CA0156.eurprd09.prod.outlook.com
 (2603:10a6:803:12c::40) To BYAPR12MB3527.namprd12.prod.outlook.com
 (2603:10b6:a03:13c::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8b4b5986-961d-4c88-d9fc-08d9e0b71443
X-MS-TrafficTypeDiagnostic: BN8PR12MB3620:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB36207009A37ABFCD638C9239B2209@BN8PR12MB3620.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /mi8Yf+x//2Fl17g9gYBLI+MtD+KvQ2ruv4dmOvibXYbDTi/zUAM+RpLlnS/JDmt1SXgs1KEaLMpJI6Wsk7FfJce8zq1KmeqKZGFRnyW5p9SjKrNRvw/XM5MfAJ4/Zg18p38YY6EqjbTy6XlVJbXLGdHP4X90TE7D/Oef+ghdvAUGLYEbBIJdoEytqYvLRXCBJUX6DzSRJ89g3h49KXyigao+62+SWkPkQFhul3+81pC8RBnUuEpxCHLog3dbOMiCLoRqyQh5x+GC3fmakcEVOJUPLedsvHTqkfiupT9z4eHoY6izqqiDT/aCDcckUjLn1XAudYhFPOw1Edd1/ToFvv3OHPijbchjrX3WuaDVBdh0ZTgPcaLY4kY3y48wYW25NdBWQevOMSOkciipjc9TzOvdMh+CpiV6xnaqtco3xTKg5NQ4chRF0NZvOyFXru47LycegF8jewQzZ9hr27zbdqb9TpSMRBWMu7eOH0DoNfLdeAm44rx5uTLeTkprM26sXvE6PPbU2d5uXg8gk01PPArORs8HMj25pSGTx8FI6RQo7HQAqeu9TRB61FrulNbZ8t0lG/UjcclrTcPtS3/p31BccbWXr+NkObdB/c9YQLuhto+K+e3D/aBxiUOh87m+5w6giRfBTBkDaDjJsCIkw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3527.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(26005)(6512007)(8936002)(316002)(2616005)(508600001)(36756003)(186003)(66476007)(38100700002)(6486002)(107886003)(6506007)(4326008)(6916009)(86362001)(1076003)(66556008)(2906002)(6666004)(66946007)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tQCgCTtGU3Ejk+4EX09FLgDqbOK40bTWrp5viEZIenK2kwPQMna/Px0rwwU/?=
 =?us-ascii?Q?lFMzum6VZH9lHW0sFBg9f5QfpdTcMwE3yCRHVvjmfYyrZ7IRDEruQLNVUnsu?=
 =?us-ascii?Q?IGpDS2lv81yctHS7cl/frUvViadNPWe66WlQNgwLJZBMrRR8Xcnt0Unesp5T?=
 =?us-ascii?Q?EeNP7ONIMHRkd3Vs6O1kVGmLjtnEg2xeqkQ7R9Az4KVhs44KIXr5vVjSw2/g?=
 =?us-ascii?Q?dYecEGpa4gq4STcu/UrIXicdhiZV94oKitKeEmlurSVTF/fNgfxWlIYx4keH?=
 =?us-ascii?Q?a5bqlV44G4emulznvpzffbQSeJXwCOiBoQJZJaP+ehSza+5RzeYzpXF+C8ZM?=
 =?us-ascii?Q?d2DIU4T2MH6IL2rzM/6+4wP1UcfS2J5OPg+19ZMIlMUHf1cgrkLh6P3cNC8I?=
 =?us-ascii?Q?Sl6/6QRB+8lMnjkIV6KfiQhhNBhhGvP2u+yEnVOMgLNA5M7G48k1aMqlFJ/M?=
 =?us-ascii?Q?uZfCmY+2+zSmqQj9HgwGc8XuuduKAO0VBRh1GxnTMYK3MSzAm9olxyhDm3qa?=
 =?us-ascii?Q?veCAbp7csa2GomNQpXascedlpjYbmFJygH4BfaRkUTVT6gDGtTzuaxemoFlo?=
 =?us-ascii?Q?XAlDoQNNkEy1XBzFK3+89IlvMwkQZdMPU+R0a7EEW7zGTGJTViSg5XhWSAUc?=
 =?us-ascii?Q?OhM0o9RhXqrmkJLw8kcpqVGnPG6BiuKKy3y+P0PaJDde64kM6Va65QfAOwNc?=
 =?us-ascii?Q?o5F1LeJ+Ui1Kaim9RAOygbqRw8zkjbtRQWdcdMPPN0T3fTGjBwzmU1qC/9Xt?=
 =?us-ascii?Q?ifh67hNZB7jNIuQefVDZ0ING0nLLLnkhDyV6mpGNW9rPSw07pnvxkVHwGuQA?=
 =?us-ascii?Q?HmxKnazQBhnQvdOdnfnwneeTiv8mfICJhFSEVWqfEApIx5lX/dYGycx44MDx?=
 =?us-ascii?Q?7ndBtP5IUzRMBoDZyjrWHboZCR5KTpsxnIlE5odmAqI4NVq38FC63RjAovST?=
 =?us-ascii?Q?1WxS0HKeoOuQa8uRYafKQEXanG66yTfEN8whWhZgpXheyME4/boXZdprY5Cx?=
 =?us-ascii?Q?0tAD7g6CaNx8hlaEnFry4I89yzfiIOfDnnKRfw3tmA54Nfh8KVeMrw3SpFhu?=
 =?us-ascii?Q?/P0NUHWtpThG8KykOiZDgkfU+5VD56BpLYP8RQhPnoGZ2QUeP9PhHpXY1qV2?=
 =?us-ascii?Q?RfsA09D0WvE+H0UuVPThVJ+d4axqOgePotoK6uJY0l9MrSyEnlWvaaLopB3w?=
 =?us-ascii?Q?g1qiT/7fBqY2IRBY0iXm6jQMhpoQ1hg0DvLY/6aP7ve4cUhtpzq3uSFK8CvL?=
 =?us-ascii?Q?j0zJT83uOrn5obqXQ2wRhQDVJL3WVV0e05IoiU33IZ8cJDSRv8RXES37fA2H?=
 =?us-ascii?Q?x2iEn7zCQARyQFMPOqO48JMoi9fC2rd+Kj2rXHEn9q63kyYYqAaxwPw6HmHK?=
 =?us-ascii?Q?uErlBrR4YCza5HoyEhFnyYG4VWfZfuCKXgCGyGWeJQGGyWjjv7tTqcDAWnf7?=
 =?us-ascii?Q?T0O0YdoAy2LIHjNogGPMLB69OWloJ74u21e+0lcbruOtoJN3kfO93TtpY49B?=
 =?us-ascii?Q?jK7hsGYUFxTjWu/y3891CRBliriUur8Cal6/sWCLPeDiVwJXw27SJo20jMSH?=
 =?us-ascii?Q?G9yiIQtrnZhP/ULouU+VLQ4TJNbhA29kp6bCEUST8Uj5tn02ZzAtPksJple2?=
 =?us-ascii?Q?N3RFkbsVYgridRoDvEr6Z5k=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b4b5986-961d-4c88-d9fc-08d9e0b71443
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3527.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2022 10:31:57.6232
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BEXV95rJTaThtAdkwwMg8BrChHsjs08k47oTq8r2h+Dd+8Lz20bOA/th99lPYz0hLx9HasedKyFv5Gdhvhu93Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3620
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

Query and store port module's type during initialization so that it
could be later used to determine if certain configurations are allowed
based on the type.

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/core_env.c    | 28 +++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_env.c b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
index 06b6acc028e0..5a9c98b94b33 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_env.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
@@ -18,6 +18,7 @@ struct mlxsw_env_module_info {
 	int num_ports_mapped;
 	int num_ports_up;
 	enum ethtool_module_power_mode_policy power_mode_policy;
+	enum mlxsw_reg_pmtm_module_type type;
 };
 
 struct mlxsw_env {
@@ -998,6 +999,28 @@ void mlxsw_env_module_port_down(struct mlxsw_core *mlxsw_core, u8 module)
 }
 EXPORT_SYMBOL(mlxsw_env_module_port_down);
 
+static int
+mlxsw_env_module_type_set(struct mlxsw_core *mlxsw_core)
+{
+	struct mlxsw_env *mlxsw_env = mlxsw_core_env(mlxsw_core);
+	int i;
+
+	for (i = 0; i < mlxsw_env->module_count; i++) {
+		char pmtm_pl[MLXSW_REG_PMTM_LEN];
+		int err;
+
+		mlxsw_reg_pmtm_pack(pmtm_pl, 0, i);
+		err = mlxsw_reg_query(mlxsw_core, MLXSW_REG(pmtm), pmtm_pl);
+		if (err)
+			return err;
+
+		mlxsw_env->module_info[i].type =
+			mlxsw_reg_pmtm_module_type_get(pmtm_pl);
+	}
+
+	return 0;
+}
+
 int mlxsw_env_init(struct mlxsw_core *mlxsw_core, struct mlxsw_env **p_env)
 {
 	char mgpir_pl[MLXSW_REG_MGPIR_LEN];
@@ -1044,8 +1067,13 @@ int mlxsw_env_init(struct mlxsw_core *mlxsw_core, struct mlxsw_env **p_env)
 	if (err)
 		goto err_temp_event_enable;
 
+	err = mlxsw_env_module_type_set(mlxsw_core);
+	if (err)
+		goto err_type_set;
+
 	return 0;
 
+err_type_set:
 err_temp_event_enable:
 err_oper_state_event_enable:
 	mlxsw_env_module_plug_event_unregister(env);
-- 
2.33.1

