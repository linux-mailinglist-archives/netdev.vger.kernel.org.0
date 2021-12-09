Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8A8846E590
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 10:28:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236233AbhLIJcU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 04:32:20 -0500
Received: from mail-bn8nam08on2090.outbound.protection.outlook.com ([40.107.100.90]:64096
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236166AbhLIJcQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 04:32:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nro7JZ1UocQzK+elQGDE+7IdYlBMFGm5Zp8dDJnD7le+H6RgYL6RolB4yJDBclVRmVsVd12zg94mNk0TXW4HE3nW98rsZFouJQQB509AE5UJ01Nk8rkS/YZ1msgT66CjgVGLzyvdoKdPJ7h8gjxDuqpU1Vhk4zohD4qd6Vx3iPExPAtINQWJWrR+UtkpgqXciKnahQS9P5/aYvURF/qtWk68IC5y4JKtB689WfQqgJW+GH/wIJOJZsOXz7CLoBJ0/Ij7t5prbUyhAmzQWtj/fwib+xTJzrUoT3w5lfaC3FNf5FgJL17LrqCWaavTa+toF6/flXLEc78gIEyGrhP5Ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/KJkQqBjRhH/QFtaAHKTqLg4DI9cUk77d+4sWf3WKBY=;
 b=nClz+qJalVF3GwwxUhwIZq45/Kg1uX83tDzQslgffC/Ctp7jrYE7VBV007hSZSqomW0H+frDjoqwIYSKw7Xk4wPHb6X0u0Xzx0/UoBC4HpB/XS2khIiIpugEXCT1TYlKfdDZMjhSsWAHw0eXmKzmAnnhBijxF06Ag0wEB6JBB2hrXXyvngrTKxKmKfBNKteKGVjDH0NHqnmbVHC+9Z9fM/tz2Xsx5tRNsTbxm7KyHu78HiiPGJHRhCZxUvDZufA1+3DDbJP+ZiSi82vsikT4kd61nPnuUL3sDAwVEeRXTmTOke8Eg0F6rqkSBx/ocRtFAY2JjVdr2broGa/lickViA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/KJkQqBjRhH/QFtaAHKTqLg4DI9cUk77d+4sWf3WKBY=;
 b=dcMLc9yJKV2oZj6Y4SFYw/HcbFd33BW+34+4JLY9WD8dt+Iox0R2CB316AT0OvSKipSTJT/Z+RFT+ea3QSO3U5940Z2KNof0OdLCpccCryFPhD82YdtLakyAOpQnEvyM9cGFdfwOSLNcaH3R21H96tT3KFRWcIVM3U7h7ehAK3c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5494.namprd13.prod.outlook.com (2603:10b6:510:128::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.10; Thu, 9 Dec
 2021 09:28:39 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c%9]) with mapi id 15.20.4778.012; Thu, 9 Dec 2021
 09:28:39 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers@corigine.com, Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v6 net-next 05/12] flow_offload: add ops to tc_action_ops for flow action setup
Date:   Thu,  9 Dec 2021 10:27:59 +0100
Message-Id: <20211209092806.12336-6-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211209092806.12336-1-simon.horman@corigine.com>
References: <20211209092806.12336-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR03CA0068.eurprd03.prod.outlook.com
 (2603:10a6:207:5::26) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b70eb062-3c7c-4349-354e-08d9baf6487e
X-MS-TrafficTypeDiagnostic: PH0PR13MB5494:EE_
X-Microsoft-Antispam-PRVS: <PH0PR13MB54945D38A9F4AF4C7C9F9526E8709@PH0PR13MB5494.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:586;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1aZtkgOcYBxkm2xanQwFAao3MSq3SlarLcaQyGwiX2Sb1EnkGdi/9460UC5xqeF0YO+FYbWl6kkqYPpagyEk6b5kMeRb3d/ua3ZKVG/Cc3SxiKd4F0Iq36+6BNZQZM1GicJCxu7at33kM2As0lE//0utShN0gSWa04i7+Zs3ZkpT4/Po6KaZJAc3NpadHgjjkU5Pbd6ODymXPcyldLsrHa9Ga5uECpFg0vEhrKL2f2XtVGbdCwzsVn0BXVUuwo7I3xZTcgkk9OP4DnsNZt+suVb8I3em+Pb9Mm4xBqT9Mt+F89tXuH7GEw5Ad+UaqFUFUIofBK+UgAV7AtXWOCf9jFOHD5VQktM1aJpqompq2wvOWILFxRUyli/wjeMRR43tyTLQfO8e7USdQER0BYf1C9cbxWlKZ+phX0oSt7aBdHg5B4KL558BbU2QPtWRDetlvTYiFciN3jMS0HOA3p3N9+aJyvsK0L7K/mHm4UhjMe1r6qRyi2r5FVJ6F8yFvStHxPbNUfrSs7RTScMerjE8abNmquRuNgS9++66xE05Pu0svy+Q1CIcngTCwxW+7Y4KWDo9lZbFy/UBrvYIkFOzRi6qF4NvSQ0o09NppttJpeM4PXht5AOFLLi+KBu2gbsiHI0uowjMgE9yUWtuKrXJwQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(39840400004)(396003)(346002)(136003)(376002)(366004)(6666004)(6512007)(44832011)(38100700002)(6916009)(66556008)(86362001)(52116002)(316002)(1076003)(6506007)(8936002)(8676002)(4326008)(36756003)(2906002)(6486002)(5660300002)(186003)(66476007)(2616005)(83380400001)(30864003)(508600001)(54906003)(66946007)(107886003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RNNcQEtLlkvcAhSqgSQrhBHZdW2f1ela6V6uOHWOxa0wiVqVrmqMsmx3oQKO?=
 =?us-ascii?Q?C4fZ/TbL0SK6A05V+0c8+TyVy+EwIJQHs8xtcpzUVGzVZsDqIm2ZlBtV1BJO?=
 =?us-ascii?Q?NYIpr/NJzMwQEfzaDe/CRtXQrAnrw6H81taSl8vBDk42U8g/AkRwgb9IJkjp?=
 =?us-ascii?Q?OdSfGB2M/fsVDgoRWLnnSWrpqVOA2xn/l6fzILuu3KVGRq5KTdWyrbSlIn98?=
 =?us-ascii?Q?0Y+Af5pEdfPCxoExCRNFC9jetoUSHNuXktMukH5npmO4T8GjbVp9PSJ0opWE?=
 =?us-ascii?Q?MO6DP36p/2FjyjJX1J+mH9LS4RPSL5AZIAufeE37ild5cvsoZadZTVC591lz?=
 =?us-ascii?Q?NenoeXiJhm+37GfUF2LwEtkDLAt9WdDEXu8qCtXqeL5c9FBPOgIoY6Jl+285?=
 =?us-ascii?Q?G4tIO8cdQZjWe71EzP0GhG3pGuDRYsFAZKtCiznzediKi7O2+Yt3XlgcJnnJ?=
 =?us-ascii?Q?0jtbisL8iTeOPGj1+/kQusS67R16fVFK89VarGWZYUPuWiVHEbMEuWKkoR/A?=
 =?us-ascii?Q?qHCKE1P2FscG0TVjqTjOI40Ldv3QpGVoa2qpsw50/WqZMbfRw/aM33scRl02?=
 =?us-ascii?Q?OV4pPam/ctk64NSFsaryuiTM9T24kwheI7ULy9AQkSbpFhQycGAO/czmF2eK?=
 =?us-ascii?Q?z22wRUos3LkVoFOUjxbrp6gYrBAMvsMJl2csU6XQYbFNT1BvJG3hRooObi9a?=
 =?us-ascii?Q?CXJELkj2W0KI7m4sbGO8gPMrSZcIV11ONkNlpMx91P7BBSJDr725TC/g68h7?=
 =?us-ascii?Q?tZQ7X6ao8Jo1Szfg3xFmD6UQ2UpPdhHsgPx7ddekDLnOJiyvG5uKztv53KIH?=
 =?us-ascii?Q?OujlzNo6u2w0VqGXNVUrk6RWpR5ixDI5SxbU9at+zDsJaILPH73Tt3w0MGjX?=
 =?us-ascii?Q?A92kEgAjN5Ky84D4bWFFwUcs4QBEfvkUdJ99GNK7ecice6ZNJgYq0ElnOyyl?=
 =?us-ascii?Q?0OJcOyY4unF3ppRISCQa/KdkLBkGsxgjUYZewnQkNw4CgcmLsa7FSBr/BgN4?=
 =?us-ascii?Q?jraSz+MsaAQBnn+rfUYsh6wnU6lo56EDplAZ5JVP356mFjYnsWUAxiCITUi/?=
 =?us-ascii?Q?icSN4O15k3AVcOcxft+/JuSP5yAxZhP3cJc6d0BhiDdC5MwBiXoWYPV0tX1s?=
 =?us-ascii?Q?va1oAk9c1iDc2Dmp51Knw7D3x+TqnMkKigcl9ZQG+k9pfDFxY9uyYK2+py5O?=
 =?us-ascii?Q?CfrqN2Hfr1DB0J1M1owujrBujbbGq16jsVECQcqsfrneqN4Uv9/0wTTQ+sqs?=
 =?us-ascii?Q?merZY3wJZetGCOqq7bsRCxZ3apvq3QLnsPalU6yKX3DyhVdcVtN9VLgGT1Xx?=
 =?us-ascii?Q?DxdipheRPgY4KD4RE9zB/MvCd2P+qZpWfawPdgxm3BgIUQ8P1dfZvSrijyLE?=
 =?us-ascii?Q?4mR8orfY4KgwEouiaJRmOJvIGh917BklaX/5xnar9qVda5jxxD90HMC/WRAi?=
 =?us-ascii?Q?wN30RBZfW8jrrS6I6Ist5zLFkFtoa02Zj0dDdfw2WCf4fUhvmyH46QoaVJeL?=
 =?us-ascii?Q?OmC9VzOjLoJOHyVKRyu8gKMyTWTfWye/QZ6BJ8uFtM0NRf8mR9yN0OHLOmnf?=
 =?us-ascii?Q?Eg+k+Po/fk1n4b21IAlqEsoFF82OgqCf9vhxfQLgwwnoInNDY3C+99IJijo4?=
 =?us-ascii?Q?+IKoMrrUE0yHyKtvNoPAfSVZ+vCJsFjxmij65jYSaNWPR9O81ROM4tFh8hDR?=
 =?us-ascii?Q?9Tvs8Ue5PYhEtRPBZEBIwqjXI2sRNiRHgW6NZeU5TH8sg3VklO2UJfju/DrW?=
 =?us-ascii?Q?ZeFepeMacgm2VtK324y/NSsbZ8iw03A=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b70eb062-3c7c-4349-354e-08d9baf6487e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2021 09:28:39.2549
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r3pIAgTpv8p/shvCQqnhA1aP2skJBM5jrBT34Bk0NXPpDa/UrliQoG/RsmvdnfKgvAWXz8OGAT47KMM501qSxnXeez8zKfzZdRHs1EMVFsI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5494
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baowen Zheng <baowen.zheng@corigine.com>

Add a new ops to tc_action_ops for flow action setup.

Refactor function tc_setup_flow_action to use this new ops.

We make this change to facilitate to add standalone action module.

We will also use this ops to offload action independent of filter
in following patch.

Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 include/net/act_api.h      |  12 ++
 net/sched/act_csum.c       |  17 +++
 net/sched/act_ct.c         |  19 ++++
 net/sched/act_gact.c       |  27 +++++
 net/sched/act_gate.c       |  47 ++++++++
 net/sched/act_mirred.c     |  39 +++++++
 net/sched/act_mpls.c       |  38 +++++++
 net/sched/act_pedit.c      |  34 ++++++
 net/sched/act_police.c     |  23 ++++
 net/sched/act_sample.c     |  28 +++++
 net/sched/act_skbedit.c    |  27 +++++
 net/sched/act_tunnel_key.c |  47 ++++++++
 net/sched/act_vlan.c       |  34 ++++++
 net/sched/cls_api.c        | 222 +++----------------------------------
 14 files changed, 406 insertions(+), 208 deletions(-)

diff --git a/include/net/act_api.h b/include/net/act_api.h
index b5b624c7e488..73f15c4ff928 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -88,6 +88,16 @@ static inline void tcf_tm_dump(struct tcf_t *dtm, const struct tcf_t *stm)
 	dtm->expires = jiffies_to_clock_t(stm->expires);
 }
 
+static inline enum flow_action_hw_stats tc_act_hw_stats(u8 hw_stats)
+{
+	if (WARN_ON_ONCE(hw_stats > TCA_ACT_HW_STATS_ANY))
+		return FLOW_ACTION_HW_STATS_DONT_CARE;
+	else if (!hw_stats)
+		return FLOW_ACTION_HW_STATS_DISABLED;
+
+	return hw_stats;
+}
+
 #ifdef CONFIG_NET_CLS_ACT
 
 #define ACT_P_CREATED 1
@@ -121,6 +131,8 @@ struct tc_action_ops {
 	struct psample_group *
 	(*get_psample_group)(const struct tc_action *a,
 			     tc_action_priv_destructor *destructor);
+	int     (*flow_act_setup)(struct tc_action *act, void *entry_data,
+				  u32 *index_inc, bool bind);
 };
 
 struct tc_action_net {
diff --git a/net/sched/act_csum.c b/net/sched/act_csum.c
index a15ec95e69c3..b55d687e3adc 100644
--- a/net/sched/act_csum.c
+++ b/net/sched/act_csum.c
@@ -695,6 +695,22 @@ static size_t tcf_csum_get_fill_size(const struct tc_action *act)
 	return nla_total_size(sizeof(struct tc_csum));
 }
 
+static int tcf_csum_flow_act_setup(struct tc_action *act, void *entry_data,
+				   u32 *index_inc, bool bind)
+{
+	if (bind) {
+		struct flow_action_entry *entry = entry_data;
+
+		entry->id = FLOW_ACTION_CSUM;
+		entry->csum_flags = tcf_csum_update_flags(act);
+		*index_inc = 1;
+	} else {
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 static struct tc_action_ops act_csum_ops = {
 	.kind		= "csum",
 	.id		= TCA_ID_CSUM,
@@ -706,6 +722,7 @@ static struct tc_action_ops act_csum_ops = {
 	.walk		= tcf_csum_walker,
 	.lookup		= tcf_csum_search,
 	.get_fill_size  = tcf_csum_get_fill_size,
+	.flow_act_setup = tcf_csum_flow_act_setup,
 	.size		= sizeof(struct tcf_csum),
 };
 
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index ab1810f2e660..9edfed3b0f4b 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -1493,6 +1493,24 @@ static void tcf_stats_update(struct tc_action *a, u64 bytes, u64 packets,
 	c->tcf_tm.lastuse = max_t(u64, c->tcf_tm.lastuse, lastuse);
 }
 
+static int tcf_ct_flow_act_setup(struct tc_action *act, void *entry_data,
+				 u32 *index_inc, bool bind)
+{
+	if (bind) {
+		struct flow_action_entry *entry = entry_data;
+
+		entry->id = FLOW_ACTION_CT;
+		entry->ct.action = tcf_ct_action(act);
+		entry->ct.zone = tcf_ct_zone(act);
+		entry->ct.flow_table = tcf_ct_ft(act);
+		*index_inc = 1;
+	} else {
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 static struct tc_action_ops act_ct_ops = {
 	.kind		=	"ct",
 	.id		=	TCA_ID_CT,
@@ -1504,6 +1522,7 @@ static struct tc_action_ops act_ct_ops = {
 	.walk		=	tcf_ct_walker,
 	.lookup		=	tcf_ct_search,
 	.stats_update	=	tcf_stats_update,
+	.flow_act_setup =	tcf_ct_flow_act_setup,
 	.size		=	sizeof(struct tcf_ct),
 };
 
diff --git a/net/sched/act_gact.c b/net/sched/act_gact.c
index d8dce173df37..2342aa5d8284 100644
--- a/net/sched/act_gact.c
+++ b/net/sched/act_gact.c
@@ -252,6 +252,32 @@ static size_t tcf_gact_get_fill_size(const struct tc_action *act)
 	return sz;
 }
 
+static int tcf_gact_flow_act_setup(struct tc_action *act, void *entry_data,
+				   u32 *index_inc, bool bind)
+{
+	if (bind) {
+		struct flow_action_entry *entry = entry_data;
+
+		if (is_tcf_gact_ok(act)) {
+			entry->id = FLOW_ACTION_ACCEPT;
+		} else if (is_tcf_gact_shot(act)) {
+			entry->id = FLOW_ACTION_DROP;
+		} else if (is_tcf_gact_trap(act)) {
+			entry->id = FLOW_ACTION_TRAP;
+		} else if (is_tcf_gact_goto_chain(act)) {
+			entry->id = FLOW_ACTION_GOTO;
+			entry->chain_index = tcf_gact_goto_chain_index(act);
+		} else {
+			return -EOPNOTSUPP;
+		}
+		*index_inc = 1;
+	} else {
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 static struct tc_action_ops act_gact_ops = {
 	.kind		=	"gact",
 	.id		=	TCA_ID_GACT,
@@ -263,6 +289,7 @@ static struct tc_action_ops act_gact_ops = {
 	.walk		=	tcf_gact_walker,
 	.lookup		=	tcf_gact_search,
 	.get_fill_size	=	tcf_gact_get_fill_size,
+	.flow_act_setup =	tcf_gact_flow_act_setup,
 	.size		=	sizeof(struct tcf_gact),
 };
 
diff --git a/net/sched/act_gate.c b/net/sched/act_gate.c
index ac985c53ebaf..cbdcbe4376bb 100644
--- a/net/sched/act_gate.c
+++ b/net/sched/act_gate.c
@@ -597,6 +597,52 @@ static size_t tcf_gate_get_fill_size(const struct tc_action *act)
 	return nla_total_size(sizeof(struct tc_gate));
 }
 
+static void tcf_gate_entry_destructor(void *priv)
+{
+	struct action_gate_entry *oe = priv;
+
+	kfree(oe);
+}
+
+static int tcf_gate_get_entries(struct flow_action_entry *entry,
+				const struct tc_action *act)
+{
+	entry->gate.entries = tcf_gate_get_list(act);
+
+	if (!entry->gate.entries)
+		return -EINVAL;
+
+	entry->destructor = tcf_gate_entry_destructor;
+	entry->destructor_priv = entry->gate.entries;
+
+	return 0;
+}
+
+static int tcf_gate_flow_act_setup(struct tc_action *act, void *entry_data,
+				   u32 *index_inc, bool bind)
+{
+	int err;
+
+	if (bind) {
+		struct flow_action_entry *entry = entry_data;
+
+		entry->id = FLOW_ACTION_GATE;
+		entry->gate.prio = tcf_gate_prio(act);
+		entry->gate.basetime = tcf_gate_basetime(act);
+		entry->gate.cycletime = tcf_gate_cycletime(act);
+		entry->gate.cycletimeext = tcf_gate_cycletimeext(act);
+		entry->gate.num_entries = tcf_gate_num_entries(act);
+		err = tcf_gate_get_entries(entry, act);
+		if (err)
+			return err;
+		*index_inc = 1;
+	} else {
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 static struct tc_action_ops act_gate_ops = {
 	.kind		=	"gate",
 	.id		=	TCA_ID_GATE,
@@ -609,6 +655,7 @@ static struct tc_action_ops act_gate_ops = {
 	.stats_update	=	tcf_gate_stats_update,
 	.get_fill_size	=	tcf_gate_get_fill_size,
 	.lookup		=	tcf_gate_search,
+	.flow_act_setup =	tcf_gate_flow_act_setup,
 	.size		=	sizeof(struct tcf_gate),
 };
 
diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index 952416bd65e6..3d96ee9bbfd8 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -450,6 +450,44 @@ static size_t tcf_mirred_get_fill_size(const struct tc_action *act)
 	return nla_total_size(sizeof(struct tc_mirred));
 }
 
+static void tcf_flow_mirred_get_dev(struct flow_action_entry *entry,
+				    const struct tc_action *act)
+{
+	entry->dev = act->ops->get_dev(act, &entry->destructor);
+	if (!entry->dev)
+		return;
+	entry->destructor_priv = entry->dev;
+}
+
+static int tcf_mirred_flow_act_setup(struct tc_action *act, void *entry_data,
+				     u32 *index_inc, bool bind)
+{
+	if (bind) {
+		struct flow_action_entry *entry = entry_data;
+
+		if (is_tcf_mirred_egress_redirect(act)) {
+			entry->id = FLOW_ACTION_REDIRECT;
+			tcf_flow_mirred_get_dev(entry, act);
+		} else if (is_tcf_mirred_egress_mirror(act)) {
+			entry->id = FLOW_ACTION_MIRRED;
+			tcf_flow_mirred_get_dev(entry, act);
+		} else if (is_tcf_mirred_ingress_redirect(act)) {
+			entry->id = FLOW_ACTION_REDIRECT_INGRESS;
+			tcf_flow_mirred_get_dev(entry, act);
+		} else if (is_tcf_mirred_ingress_mirror(act)) {
+			entry->id = FLOW_ACTION_MIRRED_INGRESS;
+			tcf_flow_mirred_get_dev(entry, act);
+		} else {
+			return -EOPNOTSUPP;
+		}
+		*index_inc = 1;
+	} else {
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 static struct tc_action_ops act_mirred_ops = {
 	.kind		=	"mirred",
 	.id		=	TCA_ID_MIRRED,
@@ -462,6 +500,7 @@ static struct tc_action_ops act_mirred_ops = {
 	.walk		=	tcf_mirred_walker,
 	.lookup		=	tcf_mirred_search,
 	.get_fill_size	=	tcf_mirred_get_fill_size,
+	.flow_act_setup =	tcf_mirred_flow_act_setup,
 	.size		=	sizeof(struct tcf_mirred),
 	.get_dev	=	tcf_mirred_get_dev,
 };
diff --git a/net/sched/act_mpls.c b/net/sched/act_mpls.c
index 2b30dc562743..69bc9e10ee3e 100644
--- a/net/sched/act_mpls.c
+++ b/net/sched/act_mpls.c
@@ -384,6 +384,43 @@ static int tcf_mpls_search(struct net *net, struct tc_action **a, u32 index)
 	return tcf_idr_search(tn, a, index);
 }
 
+static int tcf_mpls_flow_act_setup(struct tc_action *act, void *entry_data,
+				   u32 *index_inc, bool bind)
+{
+	if (bind) {
+		struct flow_action_entry *entry = entry_data;
+
+		switch (tcf_mpls_action(act)) {
+		case TCA_MPLS_ACT_PUSH:
+			entry->id = FLOW_ACTION_MPLS_PUSH;
+			entry->mpls_push.proto = tcf_mpls_proto(act);
+			entry->mpls_push.label = tcf_mpls_label(act);
+			entry->mpls_push.tc = tcf_mpls_tc(act);
+			entry->mpls_push.bos = tcf_mpls_bos(act);
+			entry->mpls_push.ttl = tcf_mpls_ttl(act);
+			break;
+		case TCA_MPLS_ACT_POP:
+			entry->id = FLOW_ACTION_MPLS_POP;
+			entry->mpls_pop.proto = tcf_mpls_proto(act);
+			break;
+		case TCA_MPLS_ACT_MODIFY:
+			entry->id = FLOW_ACTION_MPLS_MANGLE;
+			entry->mpls_mangle.label = tcf_mpls_label(act);
+			entry->mpls_mangle.tc = tcf_mpls_tc(act);
+			entry->mpls_mangle.bos = tcf_mpls_bos(act);
+			entry->mpls_mangle.ttl = tcf_mpls_ttl(act);
+			break;
+		default:
+			return -EOPNOTSUPP;
+		}
+		*index_inc = 1;
+	} else {
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 static struct tc_action_ops act_mpls_ops = {
 	.kind		=	"mpls",
 	.id		=	TCA_ID_MPLS,
@@ -394,6 +431,7 @@ static struct tc_action_ops act_mpls_ops = {
 	.cleanup	=	tcf_mpls_cleanup,
 	.walk		=	tcf_mpls_walker,
 	.lookup		=	tcf_mpls_search,
+	.flow_act_setup =	tcf_mpls_flow_act_setup,
 	.size		=	sizeof(struct tcf_mpls),
 };
 
diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index cd3b8aad3192..ddd93909636b 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -487,6 +487,39 @@ static int tcf_pedit_search(struct net *net, struct tc_action **a, u32 index)
 	return tcf_idr_search(tn, a, index);
 }
 
+static int tcf_pedit_flow_act_setup(struct tc_action *act, void *entry_data,
+				    u32 *index_inc, bool bind)
+{
+	if (bind) {
+		struct flow_action_entry *entry = entry_data;
+		int k;
+
+		for (k = 0; k < tcf_pedit_nkeys(act); k++) {
+			switch (tcf_pedit_cmd(act, k)) {
+			case TCA_PEDIT_KEY_EX_CMD_SET:
+				entry->id = FLOW_ACTION_MANGLE;
+				break;
+			case TCA_PEDIT_KEY_EX_CMD_ADD:
+				entry->id = FLOW_ACTION_ADD;
+				break;
+			default:
+				return -EOPNOTSUPP;
+			}
+			entry->mangle.htype = tcf_pedit_htype(act, k);
+			entry->mangle.mask = tcf_pedit_mask(act, k);
+			entry->mangle.val = tcf_pedit_val(act, k);
+			entry->mangle.offset = tcf_pedit_offset(act, k);
+			entry->hw_stats = tc_act_hw_stats(act->hw_stats);
+			entry++;
+		}
+		*index_inc = k;
+	} else {
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 static struct tc_action_ops act_pedit_ops = {
 	.kind		=	"pedit",
 	.id		=	TCA_ID_PEDIT,
@@ -498,6 +531,7 @@ static struct tc_action_ops act_pedit_ops = {
 	.init		=	tcf_pedit_init,
 	.walk		=	tcf_pedit_walker,
 	.lookup		=	tcf_pedit_search,
+	.flow_act_setup =	tcf_pedit_flow_act_setup,
 	.size		=	sizeof(struct tcf_pedit),
 };
 
diff --git a/net/sched/act_police.c b/net/sched/act_police.c
index c13a6245dfba..f48e9765b70e 100644
--- a/net/sched/act_police.c
+++ b/net/sched/act_police.c
@@ -405,6 +405,28 @@ static int tcf_police_search(struct net *net, struct tc_action **a, u32 index)
 	return tcf_idr_search(tn, a, index);
 }
 
+static int tcf_police_flow_act_setup(struct tc_action *act, void *entry_data,
+				     u32 *index_inc, bool bind)
+{
+	if (bind) {
+		struct flow_action_entry *entry = entry_data;
+
+		entry->id = FLOW_ACTION_POLICE;
+		entry->police.burst = tcf_police_burst(act);
+		entry->police.rate_bytes_ps =
+			tcf_police_rate_bytes_ps(act);
+		entry->police.burst_pkt = tcf_police_burst_pkt(act);
+		entry->police.rate_pkt_ps =
+			tcf_police_rate_pkt_ps(act);
+		entry->police.mtu = tcf_police_tcfp_mtu(act);
+		*index_inc = 1;
+	} else {
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 MODULE_AUTHOR("Alexey Kuznetsov");
 MODULE_DESCRIPTION("Policing actions");
 MODULE_LICENSE("GPL");
@@ -420,6 +442,7 @@ static struct tc_action_ops act_police_ops = {
 	.walk		=	tcf_police_walker,
 	.lookup		=	tcf_police_search,
 	.cleanup	=	tcf_police_cleanup,
+	.flow_act_setup =	tcf_police_flow_act_setup,
 	.size		=	sizeof(struct tcf_police),
 };
 
diff --git a/net/sched/act_sample.c b/net/sched/act_sample.c
index 91a7a93d5f6a..1b0bb501218e 100644
--- a/net/sched/act_sample.c
+++ b/net/sched/act_sample.c
@@ -282,6 +282,33 @@ tcf_sample_get_group(const struct tc_action *a,
 	return group;
 }
 
+static void tcf_flow_sample_get_group(struct flow_action_entry *entry,
+				      const struct tc_action *act)
+{
+	entry->sample.psample_group =
+		act->ops->get_psample_group(act, &entry->destructor);
+	entry->destructor_priv = entry->sample.psample_group;
+}
+
+static int tcf_sample_flow_act_setup(struct tc_action *act, void *entry_data,
+				     u32 *index_inc, bool bind)
+{
+	if (bind) {
+		struct flow_action_entry *entry = entry_data;
+
+		entry->id = FLOW_ACTION_SAMPLE;
+		entry->sample.trunc_size = tcf_sample_trunc_size(act);
+		entry->sample.truncate = tcf_sample_truncate(act);
+		entry->sample.rate = tcf_sample_rate(act);
+		tcf_flow_sample_get_group(entry, act);
+		*index_inc = 1;
+	} else {
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 static struct tc_action_ops act_sample_ops = {
 	.kind	  = "sample",
 	.id	  = TCA_ID_SAMPLE,
@@ -294,6 +321,7 @@ static struct tc_action_ops act_sample_ops = {
 	.walk	  = tcf_sample_walker,
 	.lookup	  = tcf_sample_search,
 	.get_psample_group = tcf_sample_get_group,
+	.flow_act_setup    = tcf_sample_flow_act_setup,
 	.size	  = sizeof(struct tcf_sample),
 };
 
diff --git a/net/sched/act_skbedit.c b/net/sched/act_skbedit.c
index cb2d10d3dcc0..b0d791560aa6 100644
--- a/net/sched/act_skbedit.c
+++ b/net/sched/act_skbedit.c
@@ -327,6 +327,32 @@ static size_t tcf_skbedit_get_fill_size(const struct tc_action *act)
 		+ nla_total_size_64bit(sizeof(u64)); /* TCA_SKBEDIT_FLAGS */
 }
 
+static int tcf_skbedit_flow_act_setup(struct tc_action *act, void *entry_data,
+				      u32 *index_inc, bool bind)
+{
+	if (bind) {
+		struct flow_action_entry *entry = entry_data;
+
+		if (is_tcf_skbedit_mark(act)) {
+			entry->id = FLOW_ACTION_MARK;
+			entry->mark = tcf_skbedit_mark(act);
+		} else if (is_tcf_skbedit_ptype(act)) {
+			entry->id = FLOW_ACTION_PTYPE;
+			entry->ptype = tcf_skbedit_ptype(act);
+		} else if (is_tcf_skbedit_priority(act)) {
+			entry->id = FLOW_ACTION_PRIORITY;
+			entry->priority = tcf_skbedit_priority(act);
+		} else {
+			return -EOPNOTSUPP;
+		}
+		*index_inc = 1;
+	} else {
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 static struct tc_action_ops act_skbedit_ops = {
 	.kind		=	"skbedit",
 	.id		=	TCA_ID_SKBEDIT,
@@ -339,6 +365,7 @@ static struct tc_action_ops act_skbedit_ops = {
 	.walk		=	tcf_skbedit_walker,
 	.get_fill_size	=	tcf_skbedit_get_fill_size,
 	.lookup		=	tcf_skbedit_search,
+	.flow_act_setup =	tcf_skbedit_flow_act_setup,
 	.size		=	sizeof(struct tcf_skbedit),
 };
 
diff --git a/net/sched/act_tunnel_key.c b/net/sched/act_tunnel_key.c
index d9cd174eecb7..14d8307c31a5 100644
--- a/net/sched/act_tunnel_key.c
+++ b/net/sched/act_tunnel_key.c
@@ -787,6 +787,52 @@ static int tunnel_key_search(struct net *net, struct tc_action **a, u32 index)
 	return tcf_idr_search(tn, a, index);
 }
 
+static void tcf_tunnel_encap_put_tunnel(void *priv)
+{
+	struct ip_tunnel_info *tunnel = priv;
+
+	kfree(tunnel);
+}
+
+static int tcf_tunnel_encap_get_tunnel(struct flow_action_entry *entry,
+				       const struct tc_action *act)
+{
+	entry->tunnel = tcf_tunnel_info_copy(act);
+	if (!entry->tunnel)
+		return -ENOMEM;
+	entry->destructor = tcf_tunnel_encap_put_tunnel;
+	entry->destructor_priv = entry->tunnel;
+	return 0;
+}
+
+static int tcf_tunnel_key_flow_act_setup(struct tc_action *act,
+					 void *entry_data,
+					 u32 *index_inc,
+					 bool bind)
+{
+	int err;
+
+	if (bind) {
+		struct flow_action_entry *entry = entry_data;
+
+		if (is_tcf_tunnel_set(act)) {
+			entry->id = FLOW_ACTION_TUNNEL_ENCAP;
+			err = tcf_tunnel_encap_get_tunnel(entry, act);
+			if (err)
+				return err;
+		} else if (is_tcf_tunnel_release(act)) {
+			entry->id = FLOW_ACTION_TUNNEL_DECAP;
+		} else {
+			return -EOPNOTSUPP;
+		}
+		*index_inc = 1;
+	} else {
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 static struct tc_action_ops act_tunnel_key_ops = {
 	.kind		=	"tunnel_key",
 	.id		=	TCA_ID_TUNNEL_KEY,
@@ -797,6 +843,7 @@ static struct tc_action_ops act_tunnel_key_ops = {
 	.cleanup	=	tunnel_key_release,
 	.walk		=	tunnel_key_walker,
 	.lookup		=	tunnel_key_search,
+	.flow_act_setup =	tcf_tunnel_key_flow_act_setup,
 	.size		=	sizeof(struct tcf_tunnel_key),
 };
 
diff --git a/net/sched/act_vlan.c b/net/sched/act_vlan.c
index e4dc5a555bd8..5de24a995020 100644
--- a/net/sched/act_vlan.c
+++ b/net/sched/act_vlan.c
@@ -368,6 +368,39 @@ static size_t tcf_vlan_get_fill_size(const struct tc_action *act)
 		+ nla_total_size(sizeof(u8)); /* TCA_VLAN_PUSH_VLAN_PRIORITY */
 }
 
+static int tcf_vlan_flow_act_setup(struct tc_action *act, void *entry_data,
+				   u32 *index_inc, bool bind)
+{
+	if (bind) {
+		struct flow_action_entry *entry = entry_data;
+
+		switch (tcf_vlan_action(act)) {
+		case TCA_VLAN_ACT_PUSH:
+			entry->id = FLOW_ACTION_VLAN_PUSH;
+			entry->vlan.vid = tcf_vlan_push_vid(act);
+			entry->vlan.proto = tcf_vlan_push_proto(act);
+			entry->vlan.prio = tcf_vlan_push_prio(act);
+			break;
+		case TCA_VLAN_ACT_POP:
+			entry->id = FLOW_ACTION_VLAN_POP;
+			break;
+		case TCA_VLAN_ACT_MODIFY:
+			entry->id = FLOW_ACTION_VLAN_MANGLE;
+			entry->vlan.vid = tcf_vlan_push_vid(act);
+			entry->vlan.proto = tcf_vlan_push_proto(act);
+			entry->vlan.prio = tcf_vlan_push_prio(act);
+			break;
+		default:
+			return -EOPNOTSUPP;
+		}
+		*index_inc = 1;
+	} else {
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 static struct tc_action_ops act_vlan_ops = {
 	.kind		=	"vlan",
 	.id		=	TCA_ID_VLAN,
@@ -380,6 +413,7 @@ static struct tc_action_ops act_vlan_ops = {
 	.stats_update	=	tcf_vlan_stats_update,
 	.get_fill_size	=	tcf_vlan_get_fill_size,
 	.lookup		=	tcf_vlan_search,
+	.flow_act_setup =	tcf_vlan_flow_act_setup,
 	.size		=	sizeof(struct tcf_vlan),
 };
 
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 7a680cae0bae..33b81c867ac0 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3474,81 +3474,25 @@ void tc_cleanup_flow_action(struct flow_action *flow_action)
 }
 EXPORT_SYMBOL(tc_cleanup_flow_action);
 
-static void tcf_mirred_get_dev(struct flow_action_entry *entry,
-			       const struct tc_action *act)
+static int tc_setup_flow_act(struct tc_action *act,
+			     struct flow_action_entry *entry,
+			     u32 *index_inc)
 {
 #ifdef CONFIG_NET_CLS_ACT
-	entry->dev = act->ops->get_dev(act, &entry->destructor);
-	if (!entry->dev)
-		return;
-	entry->destructor_priv = entry->dev;
-#endif
-}
-
-static void tcf_tunnel_encap_put_tunnel(void *priv)
-{
-	struct ip_tunnel_info *tunnel = priv;
-
-	kfree(tunnel);
-}
-
-static int tcf_tunnel_encap_get_tunnel(struct flow_action_entry *entry,
-				       const struct tc_action *act)
-{
-	entry->tunnel = tcf_tunnel_info_copy(act);
-	if (!entry->tunnel)
-		return -ENOMEM;
-	entry->destructor = tcf_tunnel_encap_put_tunnel;
-	entry->destructor_priv = entry->tunnel;
+	if (act->ops->flow_act_setup)
+		return act->ops->flow_act_setup(act, entry, index_inc, true);
+	else
+		return -EOPNOTSUPP;
+#else
 	return 0;
-}
-
-static void tcf_sample_get_group(struct flow_action_entry *entry,
-				 const struct tc_action *act)
-{
-#ifdef CONFIG_NET_CLS_ACT
-	entry->sample.psample_group =
-		act->ops->get_psample_group(act, &entry->destructor);
-	entry->destructor_priv = entry->sample.psample_group;
 #endif
 }
 
-static void tcf_gate_entry_destructor(void *priv)
-{
-	struct action_gate_entry *oe = priv;
-
-	kfree(oe);
-}
-
-static int tcf_gate_get_entries(struct flow_action_entry *entry,
-				const struct tc_action *act)
-{
-	entry->gate.entries = tcf_gate_get_list(act);
-
-	if (!entry->gate.entries)
-		return -EINVAL;
-
-	entry->destructor = tcf_gate_entry_destructor;
-	entry->destructor_priv = entry->gate.entries;
-
-	return 0;
-}
-
-static enum flow_action_hw_stats tc_act_hw_stats(u8 hw_stats)
-{
-	if (WARN_ON_ONCE(hw_stats > TCA_ACT_HW_STATS_ANY))
-		return FLOW_ACTION_HW_STATS_DONT_CARE;
-	else if (!hw_stats)
-		return FLOW_ACTION_HW_STATS_DISABLED;
-
-	return hw_stats;
-}
-
 int tc_setup_flow_action(struct flow_action *flow_action,
 			 const struct tcf_exts *exts)
 {
+	int i, j, index, err = 0;
 	struct tc_action *act;
-	int i, j, k, err = 0;
 
 	BUILD_BUG_ON(TCA_ACT_HW_STATS_ANY != FLOW_ACTION_HW_STATS_ANY);
 	BUILD_BUG_ON(TCA_ACT_HW_STATS_IMMEDIATE != FLOW_ACTION_HW_STATS_IMMEDIATE);
@@ -3569,151 +3513,13 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 
 		entry->hw_stats = tc_act_hw_stats(act->hw_stats);
 		entry->index = act->tcfa_index;
-
-		if (is_tcf_gact_ok(act)) {
-			entry->id = FLOW_ACTION_ACCEPT;
-		} else if (is_tcf_gact_shot(act)) {
-			entry->id = FLOW_ACTION_DROP;
-		} else if (is_tcf_gact_trap(act)) {
-			entry->id = FLOW_ACTION_TRAP;
-		} else if (is_tcf_gact_goto_chain(act)) {
-			entry->id = FLOW_ACTION_GOTO;
-			entry->chain_index = tcf_gact_goto_chain_index(act);
-		} else if (is_tcf_mirred_egress_redirect(act)) {
-			entry->id = FLOW_ACTION_REDIRECT;
-			tcf_mirred_get_dev(entry, act);
-		} else if (is_tcf_mirred_egress_mirror(act)) {
-			entry->id = FLOW_ACTION_MIRRED;
-			tcf_mirred_get_dev(entry, act);
-		} else if (is_tcf_mirred_ingress_redirect(act)) {
-			entry->id = FLOW_ACTION_REDIRECT_INGRESS;
-			tcf_mirred_get_dev(entry, act);
-		} else if (is_tcf_mirred_ingress_mirror(act)) {
-			entry->id = FLOW_ACTION_MIRRED_INGRESS;
-			tcf_mirred_get_dev(entry, act);
-		} else if (is_tcf_vlan(act)) {
-			switch (tcf_vlan_action(act)) {
-			case TCA_VLAN_ACT_PUSH:
-				entry->id = FLOW_ACTION_VLAN_PUSH;
-				entry->vlan.vid = tcf_vlan_push_vid(act);
-				entry->vlan.proto = tcf_vlan_push_proto(act);
-				entry->vlan.prio = tcf_vlan_push_prio(act);
-				break;
-			case TCA_VLAN_ACT_POP:
-				entry->id = FLOW_ACTION_VLAN_POP;
-				break;
-			case TCA_VLAN_ACT_MODIFY:
-				entry->id = FLOW_ACTION_VLAN_MANGLE;
-				entry->vlan.vid = tcf_vlan_push_vid(act);
-				entry->vlan.proto = tcf_vlan_push_proto(act);
-				entry->vlan.prio = tcf_vlan_push_prio(act);
-				break;
-			default:
-				err = -EOPNOTSUPP;
-				goto err_out_locked;
-			}
-		} else if (is_tcf_tunnel_set(act)) {
-			entry->id = FLOW_ACTION_TUNNEL_ENCAP;
-			err = tcf_tunnel_encap_get_tunnel(entry, act);
-			if (err)
-				goto err_out_locked;
-		} else if (is_tcf_tunnel_release(act)) {
-			entry->id = FLOW_ACTION_TUNNEL_DECAP;
-		} else if (is_tcf_pedit(act)) {
-			for (k = 0; k < tcf_pedit_nkeys(act); k++) {
-				switch (tcf_pedit_cmd(act, k)) {
-				case TCA_PEDIT_KEY_EX_CMD_SET:
-					entry->id = FLOW_ACTION_MANGLE;
-					break;
-				case TCA_PEDIT_KEY_EX_CMD_ADD:
-					entry->id = FLOW_ACTION_ADD;
-					break;
-				default:
-					err = -EOPNOTSUPP;
-					goto err_out_locked;
-				}
-				entry->mangle.htype = tcf_pedit_htype(act, k);
-				entry->mangle.mask = tcf_pedit_mask(act, k);
-				entry->mangle.val = tcf_pedit_val(act, k);
-				entry->mangle.offset = tcf_pedit_offset(act, k);
-				entry->hw_stats = tc_act_hw_stats(act->hw_stats);
-				entry = &flow_action->entries[++j];
-			}
-		} else if (is_tcf_csum(act)) {
-			entry->id = FLOW_ACTION_CSUM;
-			entry->csum_flags = tcf_csum_update_flags(act);
-		} else if (is_tcf_skbedit_mark(act)) {
-			entry->id = FLOW_ACTION_MARK;
-			entry->mark = tcf_skbedit_mark(act);
-		} else if (is_tcf_sample(act)) {
-			entry->id = FLOW_ACTION_SAMPLE;
-			entry->sample.trunc_size = tcf_sample_trunc_size(act);
-			entry->sample.truncate = tcf_sample_truncate(act);
-			entry->sample.rate = tcf_sample_rate(act);
-			tcf_sample_get_group(entry, act);
-		} else if (is_tcf_police(act)) {
-			entry->id = FLOW_ACTION_POLICE;
-			entry->police.burst = tcf_police_burst(act);
-			entry->police.rate_bytes_ps =
-				tcf_police_rate_bytes_ps(act);
-			entry->police.burst_pkt = tcf_police_burst_pkt(act);
-			entry->police.rate_pkt_ps =
-				tcf_police_rate_pkt_ps(act);
-			entry->police.mtu = tcf_police_tcfp_mtu(act);
-		} else if (is_tcf_ct(act)) {
-			entry->id = FLOW_ACTION_CT;
-			entry->ct.action = tcf_ct_action(act);
-			entry->ct.zone = tcf_ct_zone(act);
-			entry->ct.flow_table = tcf_ct_ft(act);
-		} else if (is_tcf_mpls(act)) {
-			switch (tcf_mpls_action(act)) {
-			case TCA_MPLS_ACT_PUSH:
-				entry->id = FLOW_ACTION_MPLS_PUSH;
-				entry->mpls_push.proto = tcf_mpls_proto(act);
-				entry->mpls_push.label = tcf_mpls_label(act);
-				entry->mpls_push.tc = tcf_mpls_tc(act);
-				entry->mpls_push.bos = tcf_mpls_bos(act);
-				entry->mpls_push.ttl = tcf_mpls_ttl(act);
-				break;
-			case TCA_MPLS_ACT_POP:
-				entry->id = FLOW_ACTION_MPLS_POP;
-				entry->mpls_pop.proto = tcf_mpls_proto(act);
-				break;
-			case TCA_MPLS_ACT_MODIFY:
-				entry->id = FLOW_ACTION_MPLS_MANGLE;
-				entry->mpls_mangle.label = tcf_mpls_label(act);
-				entry->mpls_mangle.tc = tcf_mpls_tc(act);
-				entry->mpls_mangle.bos = tcf_mpls_bos(act);
-				entry->mpls_mangle.ttl = tcf_mpls_ttl(act);
-				break;
-			default:
-				err = -EOPNOTSUPP;
-				goto err_out_locked;
-			}
-		} else if (is_tcf_skbedit_ptype(act)) {
-			entry->id = FLOW_ACTION_PTYPE;
-			entry->ptype = tcf_skbedit_ptype(act);
-		} else if (is_tcf_skbedit_priority(act)) {
-			entry->id = FLOW_ACTION_PRIORITY;
-			entry->priority = tcf_skbedit_priority(act);
-		} else if (is_tcf_gate(act)) {
-			entry->id = FLOW_ACTION_GATE;
-			entry->gate.prio = tcf_gate_prio(act);
-			entry->gate.basetime = tcf_gate_basetime(act);
-			entry->gate.cycletime = tcf_gate_cycletime(act);
-			entry->gate.cycletimeext = tcf_gate_cycletimeext(act);
-			entry->gate.num_entries = tcf_gate_num_entries(act);
-			err = tcf_gate_get_entries(entry, act);
-			if (err)
-				goto err_out_locked;
-		} else {
-			err = -EOPNOTSUPP;
+		index = 0;
+		err = tc_setup_flow_act(act, entry, &index);
+		if (!err)
+			j += index;
+		else
 			goto err_out_locked;
-		}
 		spin_unlock_bh(&act->tcfa_lock);
-
-		if (!is_tcf_pedit(act))
-			j++;
 	}
 
 err_out:
-- 
2.20.1

