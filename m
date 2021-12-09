Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E558646E592
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 10:29:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236300AbhLIJcc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 04:32:32 -0500
Received: from mail-bn8nam08on2090.outbound.protection.outlook.com ([40.107.100.90]:64096
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236244AbhLIJc0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 04:32:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FsaDsUO8piu3xiGv4sY/KVPmNNh0oPqSF7Rk8QSzstsV437FOQOvlQNf2282zZzckrzO2Xg4IaHaTlIejRMnxjEnFbG68Dcy15aY+IQGVunNqo64UO1rbR9HeDx/q3vL5bGzR02gQRUkE5AjY4iU4W8MwCSI5OzjNz6lBfMV/TPoYSk7Gd8vS3rC5+2bzOYyH1nezc565Jr9VzyCbZ8E2ZtOguzJJnNMUx+MtgbHsEWTNBdz7RJ3dgB/gxBxA0VKBRcIXa0GMuQkljLb1iiqgYyFZsUzA30xEXBUELv01bSow78Ux7wyAUtQzhtgED1std84jF0d7opU8zCYzIeqfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YK04thQSIKcMbJnQL2ZpOwKD9hwAAD3KhRtWiyq6MSU=;
 b=iUOuDffqeZLIOaCVZJgkQsJbS71H/QALXb39jjx6EnFUEpiwhcDRQ7jgu8fGJlVjSxipsRzyvjKnQUZTHi4xOo0GnNqJXgqcYGdlAu+tO7FzbtXYg5B0tqF5RQvwW8JeW8D7qquwUhE3sA5jfpV3A2PVpC/GE2XZAsQHudzXPworkxKECFJDyVY5CWjI3zJ0/7X/UpbvzBiXicqY5kEfqWEqJrx6pUW+X7SoZ2acDC+3xZuRYGbyfWgtC1sZsEWqVEwUjgAEKoJV5Ng4vQ6jAPQUD7+oGOuVIh9yooXP/Izt1iHg06vrqchoquymmsrJia8u7UAStWCS4X9EEVAnqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YK04thQSIKcMbJnQL2ZpOwKD9hwAAD3KhRtWiyq6MSU=;
 b=hPrROG2O9zIgp3Cuuw6ap+p1NMQKKDsGER2p88SoNor/h772lskkogPPoBpxLVHlhowp1lH1/iZdr7J135vNGxLwVVqwiRhk/rU6qpxwWvHkWdBKqousuMbTTmuXLmFIQ1EI+n5l9NCaMU6R0ABevsRCM9vGxGu30BKL6tnbyIA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5494.namprd13.prod.outlook.com (2603:10b6:510:128::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.10; Thu, 9 Dec
 2021 09:28:47 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c%9]) with mapi id 15.20.4778.012; Thu, 9 Dec 2021
 09:28:47 +0000
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
Subject: [PATCH v6 net-next 08/12] flow_offload: add process to update action stats from hardware
Date:   Thu,  9 Dec 2021 10:28:02 +0100
Message-Id: <20211209092806.12336-9-simon.horman@corigine.com>
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
X-MS-Office365-Filtering-Correlation-Id: 9824fbbc-8d8d-474c-0c1e-08d9baf64d5b
X-MS-TrafficTypeDiagnostic: PH0PR13MB5494:EE_
X-Microsoft-Antispam-PRVS: <PH0PR13MB54947344BCA146144473A6EAE8709@PH0PR13MB5494.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:363;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VXOcZGP7Ds9abEk9AOG+15bJZL87XA39XSeb5CSIrt4pN7sdef7Stbrxz5YMYTc9SZf3XlTu3RNYujfbzeL0iedV77e7NN99QXdFloAC6LZgPXkmjqdYskkKsCjIJ3YGzU/9eZfcCr7QZpfns+OxPvtxMbpbrWcbhCdmfhH2rzEC4Y59K+E/7eYI4FOkA/dpUwPoUyDVbm0SmzhAbSuWWIyfP1hl/+9KOpq19dWB4FTtsGf0bMXqpUrRD1qdfgXJPudxTL/F9AfZRAdRrJu/z5M7qx9dz9QKGqSUeG8OVrrgYIamTauen9p4aF0XCrfIksL3rEvLrjHlUWDTf2zJFr8V0EAqui7Ax8FmJBgH1L4nVYLWVq9NroYIM1a/qI/dpVXs6gUzd9Sah0TPaLVayx6ImPZSQeyu93I3kxJ1NUBQvGAaIqGphePvE+I+57KAb7p6Q/SlKZfk4ZNU2B7OLWoOFBHj92kJBIpCsCLFNv5vtpg75sNBr+L3jubFi9j5orBMnwiVneB7xa16pwbShfGjRfd6dQtkcMMU2vXLSP5pqUOKVEZUVnp+/N8ovwlvBCE8DEr4L7h5AQZbeMA9vCyIQXh2FBlMnBKX4K9sJ511oF3lXFBTltFza8odGhgqwDDoLss0AcWa/Rs2JQtrhA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(39840400004)(396003)(346002)(136003)(376002)(366004)(6666004)(6512007)(44832011)(38100700002)(6916009)(66556008)(86362001)(15650500001)(52116002)(316002)(1076003)(6506007)(8936002)(8676002)(4326008)(36756003)(2906002)(6486002)(5660300002)(186003)(66476007)(2616005)(83380400001)(508600001)(54906003)(66946007)(107886003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hHop6kytSUTokZZhS3tRnGQAG+d1MQon1oR6U1DdDwFBw5DMcH4knce3i/Ys?=
 =?us-ascii?Q?MwREyhGeYxTR1Q+8Nbn3nlkXeKeq9h6k2K/qK4Lhrc84Nllg9sE4kM2cD+hW?=
 =?us-ascii?Q?oroqUy/qpLsxatHdMhBXJLdBu230tcCAn2di0ppe1jx8PUHoGXmjnNaUK8aU?=
 =?us-ascii?Q?87yXXsCkoxMudgPBqg3p4JHghqT711AUrbr8hbtMNyGqBDFVqIaqVvFXHIsy?=
 =?us-ascii?Q?W8oNbvICOzEuYyeYivEh9r1ZbKZTuoZNNH4LmtegoKHY1aQn7RPP7mqrilaz?=
 =?us-ascii?Q?H8+ydfg487MM0oX2rVMd4mVhE7FujWhGaUFtAfgQ6PyxuuXuvW+fc3xEa4+W?=
 =?us-ascii?Q?1d809df4gV02UCzgXPVV9dwETsXCeRwRtKJhofITLpSEnRc16V91GNao7wrt?=
 =?us-ascii?Q?Wy87/N1sdVibZgkUhiHJx35z8OL0RN0jnpGdksWMz0EccY/bo8offLWEjS5D?=
 =?us-ascii?Q?l0Q5K1WaOALHpODdLhnwHWczQ7mTsJRn1zpT5u3qYxjgrm2ar5TxLpUMoKcm?=
 =?us-ascii?Q?ipYEn8sp95wTezGO//VakhJldDZmbp7WMiw78p3iLZLCi0HDht4wDK7X9uUE?=
 =?us-ascii?Q?Ns4QGZeEHrOyZQfomtJZiWRIb5FbraefCqpBMCPUWBic1OQRyM1rLFmAQE/Y?=
 =?us-ascii?Q?4m/zXH+HnL0wFxdaB/nwUu4xpGolzCw4nq/lVrt5Kw83oG9S+CChgLVfxhPL?=
 =?us-ascii?Q?4b6sde9so2cyOn+YR6TUELbjWbkuXLR4a6+cA94VT+24K1OLnj9hNMAHuCfV?=
 =?us-ascii?Q?MZVGRmqmIang9v5+qOQfvklpMQ2KcbLsfEc5WuH7Ew77Q5rzdwRm4Q93RqPQ?=
 =?us-ascii?Q?6oM6s3D3QAG9QZYnPB8lSWr/1/NPEqlF6UWWpSs59N2XDAv7xbGPXUBd/6yg?=
 =?us-ascii?Q?wcx717zuX1+xq71o1rd6tjdxfr15jOceN7rVHsyGHPsgN2s21yYAk7K/m15C?=
 =?us-ascii?Q?qvgcfgBFXLRpnL5dJiadAbk87iyfps0U+HTplUaaPNlRNwj+tRk480BScHPm?=
 =?us-ascii?Q?WSveUCA39c8SkTpGGidM/gsPWHJperS+fQQx3TKmzKI1cLQTMM6/2qowGGSK?=
 =?us-ascii?Q?Maznh7VWzRbFpNfd3sV+0iDEZuq1OChJvplwuakkvv/bKgiWZz/KD8LYVS0m?=
 =?us-ascii?Q?SNbMJF33+C2DpKJ9Co1v9jG/VZExXISRpoA5kOfTUckl3hBXVky27tKwprJR?=
 =?us-ascii?Q?Vkv2VLvKoJ12CkXRyUI1HEW8dXnDkLDyXQeH+MQs6jtThBC0yif87E3VYGzL?=
 =?us-ascii?Q?z1ImCRj8HjXXc4ch1dJphDOA85Ua2tAuK7whar/aSoxaw7PIleK2B1pNATwM?=
 =?us-ascii?Q?sliDqQEFNissxk5L4kZJzfO+HatoKCbUOykD0reSXv6pwJ/Mi8tOetSsVoxW?=
 =?us-ascii?Q?JDd80f4qMiyatdQ+zXE8GatX0llITqCDWZjKapuu7jsjCHI/8glN2+EEvdqv?=
 =?us-ascii?Q?Lcg/Gs03GxNnqKGBeWCRX7ejUlz9KJqb9qGc2Cy40nT7n//j+doI1yHrp8Mx?=
 =?us-ascii?Q?t012vLrd6cQFldDuwQ6olJgCn4vb6dq+vWjAjXuFMHMDCD6Ebgi4apLefzae?=
 =?us-ascii?Q?tbHN4S/HPDHoRSFFM4I3mZqemZDq/2hv3eyPP7jwQRHty7623u7OxSFqu6+2?=
 =?us-ascii?Q?Hy9rq7a8IVTWBu19SEMRUNZt5pF0ANjcjynnQ+2bsLM85buCN2kHn9/6JQYy?=
 =?us-ascii?Q?HBJ/TlfrUA9BzZGIsEtFOGslq9lDT2UACG2nbGZ64Z746tIfuyz2yrE445a6?=
 =?us-ascii?Q?YaYNnlMMZB4ggyFT+RIlf3MX9yIMvbk=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9824fbbc-8d8d-474c-0c1e-08d9baf64d5b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2021 09:28:47.4857
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9mxNfpsAgqMYv5NEKdjpcpHa8Q1WmcdwyPc8epZ1ZqkOifm1qgrQjjjg2fBmcCoOafCywo+0Hi0Np+4+9FxPMMRCkMbWIbrffJHxjQaq1dI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5494
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

