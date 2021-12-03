Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39A6A467754
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 13:25:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352003AbhLCM2t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 07:28:49 -0500
Received: from mail-mw2nam10on2132.outbound.protection.outlook.com ([40.107.94.132]:46432
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244731AbhLCM2q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Dec 2021 07:28:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RD9VqbKU9OTIL5kKWEoPR656XdAQKJgLUvgxdzJ6+iTOlcJWPUURuxBrArrEsNn8TCk6YKHD0k4PqFfd8AWiTW0rOLQQSO9ezGnP1aYtV6MbqZnzlDF6bfG1Lawzx7OHoYYyQZwBfCcMfRfokq5C54WXoFWV3EWiaisOzrOLibwRdBxGwLBk86lOQm26oiTZBz0TFH15mCGDgc1fC3Qpu96IlbgODJ/wPC4+6Yndf9HGJl/kaN03GtC9D3JZ5fiGipltiK8zc2nyR7apHh6iq5gzyBw1BgPM5DrdSKmss4JQ/sw8NmR6pyRwXP3Da+wossqwPs3l9Lz3kprO18R1ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YK04thQSIKcMbJnQL2ZpOwKD9hwAAD3KhRtWiyq6MSU=;
 b=WJNZ4C2IrVH3pf5JTHKyg8TLamY+q6YDmHZ/ydxAntlabI0r/ok+csVHbJQ1iHM9Bc5yQWXIPqYvofKjAAZ+vHa5MrVQ2P+cJ0SWcAjaEPMf4yqYIA77Yl0aRdsCcp+LeDzLk6cMengmsa5ojdu3BhtNns0iGmci0i+bZQ8onswFiEs6H/iIX+qN4yLsbLOtIeo6ns3zpB9N4djxPddjNe5QHddcUVZJcupO/5QkHZX+Ycm4svAfZfJzclrPsUcCLE/Y1M0GOHi0Do6ZUZYfrITuht7uCAXIUbB53y4UIensD86LSRucGrNlNFulPcLPzuwF/k36mqgVMYOmlAXKqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YK04thQSIKcMbJnQL2ZpOwKD9hwAAD3KhRtWiyq6MSU=;
 b=k5gJfNgUce5fawlmBeOfDlZQyaCQPw7pExOl4dMN1/rfDyMPxjIq84AefC3WmELMO5QlyJpUFmsN2vD3i2g5IiTY0ANFPNg45r5Eaiu3LhNd5MXVQvB5+dztq6NpT+VpwR9Fi2GasW43QqZNNgPgAugC8bd7yroZnxzBVMCOFNg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5423.namprd13.prod.outlook.com (2603:10b6:510:12a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.7; Fri, 3 Dec
 2021 12:25:20 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c%9]) with mapi id 15.20.4755.015; Fri, 3 Dec 2021
 12:25:20 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers@corigine.com, Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v5 net-next 08/12] flow_offload: add process to update action stats from hardware
Date:   Fri,  3 Dec 2021 13:24:40 +0100
Message-Id: <20211203122444.11756-9-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211203122444.11756-1-simon.horman@corigine.com>
References: <20211203122444.11756-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR03CA0059.eurprd03.prod.outlook.com
 (2603:10a6:207:5::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
Received: from madeliefje.horms.nl (2001:982:7ed1:403:201:8eff:fe22:8fea) by AM3PR03CA0059.eurprd03.prod.outlook.com (2603:10a6:207:5::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11 via Frontend Transport; Fri, 3 Dec 2021 12:25:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a926f687-94dd-4277-0b17-08d9b657f89e
X-MS-TrafficTypeDiagnostic: PH0PR13MB5423:EE_
X-Microsoft-Antispam-PRVS: <PH0PR13MB54233DE5D139706118B8FEF8E86A9@PH0PR13MB5423.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:363;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZwZHpO4rNWrsFEVptrxL9g1A6+dfcWajWlOWag/v433wbmO0dxfThjntcyVWmG07zbhDQWpn7NHq/YQa8MWdwKCpSmy/+sbimoPoNz/cC546TyxbzSQkEHK5XjmHqIOhf2aNfwevZbAhUFXccMF5vrfoCo93o1W1lq3MAzs4AAPEkBRYeYJAtnDB1ei6i3DfGp5FLW4uxlZJsOWrX4IP6TNH5dmeTeAuD+CcVCsAJyxspHy+W0y9CBACsS7mCriILBqGpROus+cTnZ+Er8JeBltk1uyWMduViOXZbvibPsYO8U9qjUIA9EYsBYJEYb1ATgwHkhOm166xOfOmalRiMEUT4AjNjj8wYcSoU7Y0z4qHo+V+2e+NAEtUQpTOVBQkkC5vkY+2OIWW7YAii6xv1I0R4X0suwG/B9/RQfsGeX+uuRcw8MYpvzno7uQpkt/QOYwEhnnW5aKLQ3O+F2bq7lPfnu7Zw+Z/lIx5a/9bswcGZpWzAV6aY8WdDxA0nofEYOrheMt8kXV5wNJtbPbS3B5Y0yA9QQDKydyCfBPoezb8IC87qR2N2Lq1+rALMJzmT7HHLOejh9qM5/YUvC1gpv76hjwsPUE1wk/USpjHQHXOmSpsD3rdHqfeokIAZHGNYWiT50C7Jgckn+r9RxOXCQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(39840400004)(366004)(346002)(376002)(396003)(136003)(6666004)(8936002)(38100700002)(2616005)(6506007)(4326008)(66946007)(66556008)(15650500001)(8676002)(36756003)(186003)(316002)(1076003)(44832011)(6486002)(508600001)(66476007)(5660300002)(107886003)(54906003)(52116002)(86362001)(83380400001)(6916009)(6512007)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sTbTrKpROrlIj6XAEANMUnOFsylgSeKzlPiOUOrb7xvj+wGD38Qky/7B8Quk?=
 =?us-ascii?Q?OI7c+GqOyoek1wZugN8+7JnQQIa7P9hYnqGCfpcEPou2s00Brf0+LPwndfsf?=
 =?us-ascii?Q?n98lytrwaAzSDQ1l7q/OD0H8LUprsSgbvMlw2Dx7OW+VPR0hwmu750vcv8NT?=
 =?us-ascii?Q?1f+hcoY2UiVnfsP+dbQ2hBcN8j9T+GkpBwuNbo3UJUmR+RbN+Hib0m4uO0Qv?=
 =?us-ascii?Q?XjmmgtJNiYd9rWDMJSJiwlvLnph07S+EyzcpuQ7ehFbcc79VaFb3eQsZI1U4?=
 =?us-ascii?Q?K3qef3vYuHK9xAvCZnBoCgMrhseFezTOqwwS48zuYg90NljZZg+jTwJ2Ywxt?=
 =?us-ascii?Q?tYpLyWqFPm0ehkDnF0B7uzSx5JTsOX5XQnI0CeK1nL3K8iXm5u7UKHrzGW02?=
 =?us-ascii?Q?DTklmCrOrl9N77+/BAgN/8giouoSnGIP8SJIZ442Z/EnqU+wkOMPpi6r/6Xn?=
 =?us-ascii?Q?So7MAzXQMkQkyMMxuY2qp9kWZV9ei7FszjF2frSvuU8JWIg6xKi3cXv9/AhD?=
 =?us-ascii?Q?hYf/9QdScyns9FJym+XlBrYfz79YPKyhyy8MY2hrruP7bQmyn3yxtTn0g/yH?=
 =?us-ascii?Q?7Z8e1ZdGztsi2BMxZzhM2B4cRcTRnBxSkq5MGgyyCm/0cXGb2hg+Z6+ZcFI3?=
 =?us-ascii?Q?EbVhPDNk7DH9qx1nCqVii23gO9W96xKYSv711ClkCWvwAvhaE8yAVOSBGJ1l?=
 =?us-ascii?Q?RM9C9Yjg6dT1KyGlMUcjvSMYPz73LdVUg1Afx+2oImG+K+63l6RA/ihEHdHs?=
 =?us-ascii?Q?X2lDoFwgNkXdEUyhzyr3z2LtESTe1YuLPE8fekScgWmy0b8mtm2rMb+GzTgf?=
 =?us-ascii?Q?bnBRsZnZZs56q4+ayFUx3aak56oBrICMuDmgOfa5sRvvVFcqNcWdAOcZrn+E?=
 =?us-ascii?Q?6GAW9TWmI2Evz8C5hcokWOo2YKU1XPp3oB3mdB0coNiyNMjpblaexQlEdZmp?=
 =?us-ascii?Q?NB8ikA0QemaGB3gvjOvHFbIPtuy9JOPlqtAs7ZwrnA2QrE6sci7e2OEhW1K7?=
 =?us-ascii?Q?pyUXdOMTqEYRjwwF/hdNGEvpUmp/lZd49oUvQP3ICIyUhqxF5aumARcKWres?=
 =?us-ascii?Q?kvu78CqdycR37OE+2phyZSWlK6oUxFPg0jGyeEzJjDWRCafZ+dfygYlciYcL?=
 =?us-ascii?Q?R82MlQWNotmhYlbVwKqVV6ewU82DLovG6qIPDyn5Vgk/84b1p04Fs4O8VOJg?=
 =?us-ascii?Q?pc/V6xxhpNfp0wVjGfT2yOhaE5U8Gs/3YPjU0aY10rlNS0CluMHcWxUSjLzF?=
 =?us-ascii?Q?WF06o1Z841Qow9tG+B+Iz0274n6iuidzZChifjwioC6XAqpPcGbpeSiHsPV3?=
 =?us-ascii?Q?PsvWZZzpwyXjUjXqC2QNVL0w89feO0HwAef2FexI7hHVEhYLpurUrOdir6uQ?=
 =?us-ascii?Q?dNkqd7dI/OX67IcZGv99AjWjGC4RLdnl3yHo82MHBh+GN9LjNA2f2Ooizo5Y?=
 =?us-ascii?Q?xTS7ARNP+BvQ/3G2oZuN+I1bdk++a128KzQSHmKSG1EzoUP8mWLocqxjMhnl?=
 =?us-ascii?Q?X1Fa+ZPjH+0XV2KpietWF1iLrzSq/XSs6z2SsnROAfMXfr4K7AEfRu9RxI/I?=
 =?us-ascii?Q?DXYuINd6TjlABOSn3nLkfmfOszRgkZfTG+alsKj7dy8wJuu2eHC74qcevMVG?=
 =?us-ascii?Q?9d92b47QggY5oOhi64oMk8d9Y25cEuKaaXEVd8ToJ8VMoDqdEW8tL1xVraWZ?=
 =?us-ascii?Q?QlTHQNk887Pg5vE9yVIWu1t1sO6YWJeSLtlvvubX7erORot2abQEfDHv6BwZ?=
 =?us-ascii?Q?zGb4C9ceSKqXLfhDGst2zxzK7Bmg1WU=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a926f687-94dd-4277-0b17-08d9b657f89e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2021 12:25:20.1124
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BEqsvKGTjxyEPsyo/saEdsyEwaYaPD3tOCiazX1AvitNmO1U+32o5dtwpVE/ulYyltYQGczJl3q0PcgL4ypXLyymVfVIG+JX1RL6uuhONGE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5423
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baowen Zheng <baowen.zheng@corigine.com>

When collecting stats for actions update them using both
hardware and software counters.

Stats update process should not run in context of preempt_disable.

Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 include/net/act_api.h |  1 +
 include/net/pkt_cls.h | 18 ++++++++++--------
 net/sched/act_api.c   | 34 ++++++++++++++++++++++++++++++++++
 3 files changed, 45 insertions(+), 8 deletions(-)

diff --git a/include/net/act_api.h b/include/net/act_api.h
index 7e4e79b50216..ce094e79f722 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -253,6 +253,7 @@ void tcf_action_update_stats(struct tc_action *a, u64 bytes, u64 packets,
 			     u64 drops, bool hw);
 int tcf_action_copy_stats(struct sk_buff *, struct tc_action *, int);
 
+int tcf_action_update_hw_stats(struct tc_action *action);
 int tcf_action_check_ctrlact(int action, struct tcf_proto *tp,
 			     struct tcf_chain **handle,
 			     struct netlink_ext_ack *newchain);
diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 13f0e4a3a136..1942fe72b3e3 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -269,18 +269,20 @@ tcf_exts_stats_update(const struct tcf_exts *exts,
 #ifdef CONFIG_NET_CLS_ACT
 	int i;
 
-	preempt_disable();
-
 	for (i = 0; i < exts->nr_actions; i++) {
 		struct tc_action *a = exts->actions[i];
 
-		tcf_action_stats_update(a, bytes, packets, drops,
-					lastuse, true);
-		a->used_hw_stats = used_hw_stats;
-		a->used_hw_stats_valid = used_hw_stats_valid;
-	}
+		/* if stats from hw, just skip */
+		if (tcf_action_update_hw_stats(a)) {
+			preempt_disable();
+			tcf_action_stats_update(a, bytes, packets, drops,
+						lastuse, true);
+			preempt_enable();
 
-	preempt_enable();
+			a->used_hw_stats = used_hw_stats;
+			a->used_hw_stats_valid = used_hw_stats_valid;
+		}
+	}
 #endif
 }
 
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 1d469029f2cd..4e309b8e49bb 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -245,6 +245,37 @@ static int tcf_action_offload_add(struct tc_action *action,
 	return err;
 }
 
+int tcf_action_update_hw_stats(struct tc_action *action)
+{
+	struct flow_offload_action fl_act = {};
+	int err;
+
+	if (!tc_act_in_hw(action))
+		return -EOPNOTSUPP;
+
+	err = flow_action_init(&fl_act, action, FLOW_ACT_STATS, NULL);
+	if (err)
+		return err;
+
+	err = tcf_action_offload_cmd(&fl_act, NULL, NULL);
+	if (!err) {
+		preempt_disable();
+		tcf_action_stats_update(action, fl_act.stats.bytes,
+					fl_act.stats.pkts,
+					fl_act.stats.drops,
+					fl_act.stats.lastused,
+					true);
+		preempt_enable();
+		action->used_hw_stats = fl_act.stats.used_hw_stats;
+		action->used_hw_stats_valid = true;
+	} else {
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(tcf_action_update_hw_stats);
+
 static int tcf_action_offload_del(struct tc_action *action)
 {
 	struct flow_offload_action fl_act = {};
@@ -1317,6 +1348,9 @@ int tcf_action_copy_stats(struct sk_buff *skb, struct tc_action *p,
 	if (p == NULL)
 		goto errout;
 
+	/* update hw stats for this action */
+	tcf_action_update_hw_stats(p);
+
 	/* compat_mode being true specifies a call that is supposed
 	 * to add additional backward compatibility statistic TLVs.
 	 */
-- 
2.20.1

