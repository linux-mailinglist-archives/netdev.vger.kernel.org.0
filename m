Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9395D638A8B
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 13:50:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229463AbiKYMuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 07:50:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiKYMuG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 07:50:06 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2073.outbound.protection.outlook.com [40.107.243.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1198C1C101
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 04:50:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AYZKAcuX+kenTG/vPpFy/C2qzvoPBqlpm9vW2en9wvmtyMz3tgZnGDybacwN/wyvG+JqAUWINXuUq1qOS/G4ecvRgQwoB2vyL7A4MybQz7n3yz2C/nrbD9arLGwKE4emCvEbRX77jd0lKlnfvIWqOxrofVWXqWVt9v8Nhqc+/2eZhAXjioeV7elXkurMQsLCYx287rkvql8/hn6WTBDDkuFZ50Gk29jDtrXKPkvu0UDttKUKIk4d12moVg1C/+w7R3MgAR1nvOEuy7HzYg/hE0+m1SRqDPCxTx5spRtfSWWFhiE8MMlLEZnEv68iP6hiTbRfAoq15bIm0C2726PUpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gLUDcRXIeRlLM8nFqj0C1koMKsAnZKhZMxZGwdPSY9I=;
 b=bNwAGflBDCyPWDW/DP7AzmDT6YeWs1Os+8g98ZKB7bYdEDXfq/xKSP5EQlTbrJ5x/GsjqgRAmXNlq0t+9ED4vnTEwAZhVV2zV3c+xbVtQwyZAR6QCm3rXXC8uOa0hve/J/jBqqSE+RXa1cJQZLAmxDXThdpbj17JzpolZvMVwEmX/2aghi90NyBZn49Fo5Aj95nIJMwbiwhwu4cKcDh9CoyET7AT/DZIZoHAVPhxRU++v08jmSiKQ2kcqN11YKpwkes9yfF8OjtQJ8xwn7LwVfQ4w1ZqCuT9BuGjBkZ4gGBc55Bui9CIwA9GvIsA3WfCHhXhmylKwmF8q3mksEfeTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=corigine.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gLUDcRXIeRlLM8nFqj0C1koMKsAnZKhZMxZGwdPSY9I=;
 b=cYDfJytVRyaLtaeyA1dMMAmQr8Inkwf7n0ybEr7L6hkDxQWsZKFJhZvXyvQDpl6cosPUuvCXN30q+q07jwAT7U2bKIY+B3vFV0a6TDo6QL9DsJK1V8/ly7zGs30U3EcQREtmsFpb6bP0qfbL2F3LdjaS8eZR2VoLrWEQ3vylPshyC4wZXNgev7VCr1AuBkPd2RGujATGN3IwkRFp8p8T6kXOcFoFSZVxGugDr7KJLI8iR2Ih90IxAGJdIKpn99P3Jwo/KK26pEHgDdiaK55DOITK4QSiBY8WGvOsj8FgmwAqXOW/BdtHgvMMvo3nAlEFSLWGfKd4w7SLQGajMuXuRQ==
Received: from MW4PR03CA0077.namprd03.prod.outlook.com (2603:10b6:303:b6::22)
 by PH7PR12MB6659.namprd12.prod.outlook.com (2603:10b6:510:210::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.18; Fri, 25 Nov
 2022 12:50:01 +0000
Received: from CO1NAM11FT043.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b6:cafe::45) by MW4PR03CA0077.outlook.office365.com
 (2603:10b6:303:b6::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19 via Frontend
 Transport; Fri, 25 Nov 2022 12:50:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CO1NAM11FT043.mail.protection.outlook.com (10.13.174.193) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.20 via Frontend Transport; Fri, 25 Nov 2022 12:50:01 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 25 Nov
 2022 04:49:50 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Fri, 25 Nov 2022 04:49:50 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Fri, 25 Nov 2022 04:49:46 -0800
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <tianyu.yuan@corigine.com>
CC:     <jhs@mojatatu.com>, <simon.horman@corigine.com>,
        <netdev@vger.kernel.org>, <xiyou.wangcong@gmail.com>,
        <dcaratti@redhat.com>, <edward.cree@amd.com>,
        <echaudro@redhat.com>, <i.maximets@ovn.org>, <mleitner@redhat.com>,
        <ozsh@nvidia.com>, <paulb@nvidia.com>, <dev@openvswitch.org>,
        <oss-drivers@corigine.com>, <ziyang.chen@corigine.com>,
        <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH] tc: allow gact pipe action offload
Date:   Fri, 25 Nov 2022 13:49:32 +0100
Message-ID: <20221125124932.2877006-1-vladbu@nvidia.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <87y1rzqkgf.fsf@nvidia.com>
References: <87y1rzqkgf.fsf@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT043:EE_|PH7PR12MB6659:EE_
X-MS-Office365-Filtering-Correlation-Id: 835819b4-6155-4a79-0230-08dacee39103
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MKSpYkALmY9cpXedINZHahhGY7V3IknaB3seuvS6qsyFkva7Bd8ZBcEjEK83q6xS7AiYysSexwdrAMMFkYZvmEDEEI7BO+xZGayWmVuVVB3izRjb1Fqpy4H/mf6N0NEr44K05qe1r0nhLAHNezgQXIBK5ApYTjj3zOG+lalNj+HQPHWWN7JbxfxC1DpzSqKaOzZWPSr7iRA2eCOtmDFbBld3fpy4NEs9pnsw/3tbYPFa9izTbUGDcLc6apuLmFe74i6fDUSNp5ZFi8vFQS0x2JblngTQrbYXRGVhAl7dzy430eUOql0+OyNYzCgRGfnJ+oo24rKVRt6cMwdSLYeqDyImvPDF9HtNcyeN2ww2uRhQE7QJizcKoxuQYvAX7F5f0E4/UgbUj8I8U76XG0djIdPQzrUEaB0RIK2uT4UZjcQVQjucqmnw+1KMaWBRTG9YQkjpIMu49B85V5Mc5vN7Uz7/gwH0DdaKola6QvgHs+W0pbYynfIcweHaPmbuZHs++IuxbM2NjdADq+uz6mWLaG99n9WbZZteMtwDL+/0q1BpHQBKQtxiOsRYd00/dMoX6Nzzm6R3T9X2hGyx8gWsdD9HuM71zhUJ3aIFhK71ZBGoMK0PF0Gb9ArfBgLn0XOnRvkB0eMH3e3r345K9pgpIE2imvoB+lFugsvUvX1s1pTSmptLTN6PfxvqtE1tqjePW5xr2KvA8em9aRLjmKjaWg==
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(39860400002)(346002)(376002)(451199015)(36840700001)(46966006)(40470700004)(7636003)(2616005)(40480700001)(6916009)(6666004)(86362001)(54906003)(356005)(316002)(426003)(4326008)(36756003)(40460700003)(7696005)(8676002)(70206006)(47076005)(26005)(70586007)(107886003)(41300700001)(82310400005)(83380400001)(2906002)(336012)(186003)(8936002)(1076003)(5660300002)(7416002)(82740400003)(36860700001)(478600001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2022 12:50:01.1200
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 835819b4-6155-4a79-0230-08dacee39103
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT043.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6659
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Flow action infrastructure and mlx5 only.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |  3 +-
 .../mellanox/mlx5/core/en/tc/act/act.c        |  2 ++
 .../mellanox/mlx5/core/en/tc/act/act.h        |  1 +
 .../mellanox/mlx5/core/en/tc/act/pipe.c       | 28 +++++++++++++++++++
 net/sched/act_gact.c                          |  7 +++--
 5 files changed, 37 insertions(+), 4 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/pipe.c

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index a22c32aabf11..566a03e80cf8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -55,7 +55,8 @@ mlx5_core-$(CONFIG_MLX5_CLS_ACT)     += en/tc/act/act.o en/tc/act/drop.o en/tc/a
 					en/tc/act/vlan.o en/tc/act/vlan_mangle.o en/tc/act/mpls.o \
 					en/tc/act/mirred.o en/tc/act/mirred_nic.o \
 					en/tc/act/ct.o en/tc/act/sample.o en/tc/act/ptype.o \
-					en/tc/act/redirect_ingress.o en/tc/act/police.o
+					en/tc/act/redirect_ingress.o en/tc/act/police.o \
+					en/tc/act/pipe.o
 
 ifneq ($(CONFIG_MLX5_TC_CT),)
 	mlx5_core-y			     += en/tc_ct.o en/tc/ct_fs_dmfs.o
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c
index 3337241cfd84..e8fcc18c7074 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c
@@ -28,6 +28,7 @@ static struct mlx5e_tc_act *tc_acts_fdb[NUM_FLOW_ACTIONS] = {
 	[FLOW_ACTION_CT] = &mlx5e_tc_act_ct,
 	[FLOW_ACTION_MPLS_PUSH] = &mlx5e_tc_act_mpls_push,
 	[FLOW_ACTION_MPLS_POP] = &mlx5e_tc_act_mpls_pop,
+	[FLOW_ACTION_PIPE] = &mlx5e_tc_act_pipe,
 	[FLOW_ACTION_VLAN_PUSH_ETH] = &mlx5e_tc_act_vlan,
 	[FLOW_ACTION_VLAN_POP_ETH] = &mlx5e_tc_act_vlan,
 };
@@ -42,6 +43,7 @@ static struct mlx5e_tc_act *tc_acts_nic[NUM_FLOW_ACTIONS] = {
 	[FLOW_ACTION_CSUM] = &mlx5e_tc_act_csum,
 	[FLOW_ACTION_MARK] = &mlx5e_tc_act_mark,
 	[FLOW_ACTION_CT] = &mlx5e_tc_act_ct,
+	[FLOW_ACTION_PIPE] = &mlx5e_tc_act_pipe,
 };
 
 /**
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
index e1570ff056ae..dd863e84a925 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
@@ -87,6 +87,7 @@ extern struct mlx5e_tc_act mlx5e_tc_act_sample;
 extern struct mlx5e_tc_act mlx5e_tc_act_ptype;
 extern struct mlx5e_tc_act mlx5e_tc_act_redirect_ingress;
 extern struct mlx5e_tc_act mlx5e_tc_act_police;
+extern struct mlx5e_tc_act mlx5e_tc_act_pipe;
 
 struct mlx5e_tc_act *
 mlx5e_tc_act_get(enum flow_action_id act_id,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/pipe.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/pipe.c
new file mode 100644
index 000000000000..75207b57bec2
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/pipe.c
@@ -0,0 +1,28 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+// Copyright (c) 2022, NVIDIA CORPORATION & AFFILIATES. All rights reserved.
+
+#include "act.h"
+#include "en/tc_priv.h"
+
+static bool
+tc_act_can_offload_pipe(struct mlx5e_tc_act_parse_state *parse_state,
+			const struct flow_action_entry *act,
+			int act_index,
+			struct mlx5_flow_attr *attr)
+{
+	return true;
+}
+
+static int
+tc_act_parse_pipe(struct mlx5e_tc_act_parse_state *parse_state,
+		  const struct flow_action_entry *act,
+		  struct mlx5e_priv *priv,
+		  struct mlx5_flow_attr *attr)
+{
+	return 0;
+}
+
+struct mlx5e_tc_act mlx5e_tc_act_pipe = {
+	.can_offload = tc_act_can_offload_pipe,
+	.parse_action = tc_act_parse_pipe,
+};
diff --git a/net/sched/act_gact.c b/net/sched/act_gact.c
index 62d682b96b88..82d1371e251e 100644
--- a/net/sched/act_gact.c
+++ b/net/sched/act_gact.c
@@ -250,15 +250,14 @@ static int tcf_gact_offload_act_setup(struct tc_action *act, void *entry_data,
 		} else if (is_tcf_gact_goto_chain(act)) {
 			entry->id = FLOW_ACTION_GOTO;
 			entry->chain_index = tcf_gact_goto_chain_index(act);
+		} else if (is_tcf_gact_pipe(act)) {
+			entry->id = FLOW_ACTION_PIPE;
 		} else if (is_tcf_gact_continue(act)) {
 			NL_SET_ERR_MSG_MOD(extack, "Offload of \"continue\" action is not supported");
 			return -EOPNOTSUPP;
 		} else if (is_tcf_gact_reclassify(act)) {
 			NL_SET_ERR_MSG_MOD(extack, "Offload of \"reclassify\" action is not supported");
 			return -EOPNOTSUPP;
-		} else if (is_tcf_gact_pipe(act)) {
-			NL_SET_ERR_MSG_MOD(extack, "Offload of \"pipe\" action is not supported");
-			return -EOPNOTSUPP;
 		} else {
 			NL_SET_ERR_MSG_MOD(extack, "Unsupported generic action offload");
 			return -EOPNOTSUPP;
@@ -275,6 +274,8 @@ static int tcf_gact_offload_act_setup(struct tc_action *act, void *entry_data,
 			fl_action->id = FLOW_ACTION_TRAP;
 		else if (is_tcf_gact_goto_chain(act))
 			fl_action->id = FLOW_ACTION_GOTO;
+		else if (is_tcf_gact_pipe(act))
+			fl_action->id = FLOW_ACTION_PIPE;
 		else
 			return -EOPNOTSUPP;
 	}
-- 
2.37.2

