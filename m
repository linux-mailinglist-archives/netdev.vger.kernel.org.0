Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D1FC467752
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 13:25:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244247AbhLCM2l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 07:28:41 -0500
Received: from mail-mw2nam10on2100.outbound.protection.outlook.com ([40.107.94.100]:55489
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244538AbhLCM2k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Dec 2021 07:28:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LaDNRldCIduyQvHSBAwW7PTnoPirirQCcyof5S37mlfQdYUmXIjX0u9938M/AwywhOkBsuTw6A5rfpS+lF1ybuTt1NWK12zcMafATZPCiNr0nKjQ5CVRb2uGvIHZEt1bhjJXfyEcksogr3ZIUcCKQuRAhGPDoXEqHgG/Y0YZMlYXVePtiooxMDVDR+bigoGSyslKkHELo790dJseANEiWLjO0EslcTQt2R+A+wGJ9CPYS1mjsNXtUodCwI0iinh2rtmXV9lDKu6XS1pDeFmL1fHoCBIddSMKx1N66p18zMNxIWovRAbCp67HLWUWSE1VpR23TINjdx8D3BdFc3Ee+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KnB7WVGHd7JN7xLxjRizJF50qOlzkzaf598O+3qEPtM=;
 b=Fi1pN8rg946/7cYyn3/BEEY9tPUOZQwcnl0CxgVR5UqkNDSZ9zkCdcf0L55270d1Jk2GYKdaOI7tx2rh6hMUvgk7ta6/7iJxxAAdfCjNAIL9eiLhe8fSDuFj1V/1dWE1yhSXkysRaQgtp0lxGLMs81USOZhUDA/mGxTgM9Z5Y2Min52hTiips5UKmj02Fdk2N+IlmslcPZU9GeGt8sLrwxWYvIFZLq+KbMzwucrnv32awayTlghcLskCwEB3+PRyjszrzUjKzNd8979+fkClJmGfKigRlCcKmxFfP75ZrMcXd9cp3rnEl5WjI04Ybn6jrNav/szEKCywdgZhqpYSnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KnB7WVGHd7JN7xLxjRizJF50qOlzkzaf598O+3qEPtM=;
 b=s4MT6mU0BFT6En8a9LOyiT6g7rqbn1VIfUc2j6+b2rYE73WSVEWpcQReQTGuRxGBqta61ZqkI+hodVSp7mcv5wD56g6jNB8DMgRmLpDqa2ppNJcfLmfl4W6rNJPNnz/CGvzhyKDWVg0ToLnTYePLNrpUH1nszyDkONp4HyK8nSg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5423.namprd13.prod.outlook.com (2603:10b6:510:12a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.7; Fri, 3 Dec
 2021 12:25:15 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c%9]) with mapi id 15.20.4755.015; Fri, 3 Dec 2021
 12:25:15 +0000
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
Subject: [PATCH v5 net-next 06/12] flow_offload: allow user to offload tc action to net device
Date:   Fri,  3 Dec 2021 13:24:38 +0100
Message-Id: <20211203122444.11756-7-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211203122444.11756-1-simon.horman@corigine.com>
References: <20211203122444.11756-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR03CA0059.eurprd03.prod.outlook.com
 (2603:10a6:207:5::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
Received: from madeliefje.horms.nl (2001:982:7ed1:403:201:8eff:fe22:8fea) by AM3PR03CA0059.eurprd03.prod.outlook.com (2603:10a6:207:5::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11 via Frontend Transport; Fri, 3 Dec 2021 12:25:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ee9bd261-82d6-4a7a-3c3b-08d9b657f59e
X-MS-TrafficTypeDiagnostic: PH0PR13MB5423:EE_
X-Microsoft-Antispam-PRVS: <PH0PR13MB54236051773C298ED802398FE86A9@PH0PR13MB5423.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:989;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nJzqFK/8Wjj4Gf7PoMHzNQaw4BQFaylKD2+P/cKhRLBySU6TiHOlzYMlTwHXsbvU1AP2dx1lIfxgHpSjq3lmgNUhmiGjAPpZn/+X80jXLszSSD2V81Gw/yXelGo+ehN53ycIL1FpyYOauWZ4W3rl3dMN8dmod2Vj2KVgLmf1EoN+LNlzejVF02HAOyWvFf8I+7CHUQX5qjvoK/YWOv4dxWBtDHaG9W0LUN5vxdHK1A0jUzGZ8aKAZ8K7F0MCLiXrPSuTHXsOvOV3of4Df9gFZ5X3Yob2kYh5/xgSKMB+LaECwLLmBjm+TWNdl+zYI5zMVdUMG78071BOWnMmJBTluuozx0xVFV3FdfEwJmgobgrGNTY5lytpEso1k+8taZ4NXbyWh4v+yZDH+QQ5cz9KC8WDNkMsINRC3CQR2WcCn2MpjUrLdOpcUosHD2UT8c/eMnyJK44nVXXaSxB1WmdE7yJnDeSn1AtSIcR2lC0N4QGB0tpjlLnDKxufFo4OhoBkJGa/TOy/LLexUotERzaDF4XVSCmNvbLeL7s3K5I8fmJUqZtzObkSdQb/7uiTVIuktwct4O/E1HtZMvsUgwDGtcjOU3w6AOAX+3YxXYlAn5Uv2l/m7cf+GBJQMYHk8o472hcunUYeQJO4YbCDZQfEvg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(376002)(39830400003)(396003)(136003)(6666004)(8936002)(38100700002)(2616005)(30864003)(6506007)(4326008)(66946007)(66556008)(8676002)(36756003)(186003)(316002)(1076003)(44832011)(6486002)(508600001)(66476007)(5660300002)(107886003)(54906003)(52116002)(86362001)(83380400001)(6916009)(6512007)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?S4xjouXuln9fewhNB1WnAHlFiXow5DKsHCG9q9E8HfUQImIUkKaQTFkKGVXy?=
 =?us-ascii?Q?ZbfaKgoA8mhq7I39aTj0BF8Ab2/18cVQmklQd1WXRVDqHwOjaZ3ncMsILJO6?=
 =?us-ascii?Q?TfgVP4pKbJNlEkC3iquAG1nDmNK7Ue08KLmgj0Eu4mqXH/yvbPWE92RxcYKH?=
 =?us-ascii?Q?/POxQWtJXbkOWleAb4dQ6N2+JprUAtrD90dXTvDeKHjhoAYAARyjNvAjf2PC?=
 =?us-ascii?Q?ogBADgazHLIj53eWO9V75AxyNqe6/9oN1auxCt276C6DQAouOJgskF3j+0OV?=
 =?us-ascii?Q?9PHv+YHS00fOUzYUH0mZtc/GXxpDu/Q4UmdsDNr5gHts+skhTvXcrLNSx/3w?=
 =?us-ascii?Q?3I4Umn2gZIB0SWUAotTMTrAC3AYe/yu/yGGAACneKl0yTilfHZ4224n66i55?=
 =?us-ascii?Q?7sfPm0tDdOX4WDjwpgHELDcL74zjPiua5KsWdYeCzxWF+QzpiduXaPQTKA5/?=
 =?us-ascii?Q?jnchqp/maRfnrxZOE4vdmuU02atknygEEJwQjkWw7bzUkIGgKND8lMqYAWk0?=
 =?us-ascii?Q?y1NKEGuQ4RCYGE4NYeO3mnYIuzBa4OBKRRx2E+qLODt41ou5/iutZsIJlVXv?=
 =?us-ascii?Q?As2ppb95dEbqp6fvhB3vArmm1xQu060+vBH8g+LUhyxgIyOCWRtpqzlUTzJZ?=
 =?us-ascii?Q?EpRoJigrVM7YobxeJxy9PLpR8Bnj6rXlVr8A9Q//LZ6ACdJcZCrpUUJlRKEh?=
 =?us-ascii?Q?Ro4Jrbx28Qv1Nmlqo2cLbMCADT4/aJVAFswmkCVl4HZYXmIaNDbhyUkdv/As?=
 =?us-ascii?Q?QRFmQooPFReP54faBmiUEgNNofwGCo0hsGU4pyhQpYxhTkiZnlsui9+zxf5Z?=
 =?us-ascii?Q?JJiJd1RihL6tjgoi973F/ZKc8OSGjLr/lyBmSnLHg5bS3VSTpdswfoN9Xp3V?=
 =?us-ascii?Q?PtD4PaMXYvG9YZEue6y7EORu92Cs7bTdh5VJn28XbjFF9k2CukYl8Nl0omKk?=
 =?us-ascii?Q?SMP9a57hKRj9pPR0HMeTaaRlgTO0aPpb+Cn6Iudar8tfhZnC5Isg6mhy1UtB?=
 =?us-ascii?Q?xppEuhMvj6eV/x7TLQyPJISROysQ6cFSJdfuwxVNq1NJgHQg32O3w7IxzSv7?=
 =?us-ascii?Q?/SY/Eih0N7/OdJCzarF8MTkcdGjzpCUl+uAM18gHn1LDGuGCpAN2CDc/OmMv?=
 =?us-ascii?Q?o+F4y8ErvY3TSWoKEmuzYjFxg4svqAIm7RIDU4Y0fhaSo49ZQfkIJqSgGeM5?=
 =?us-ascii?Q?shgs2iuzG1ey/UBjvKygmDYSPmmMc7GkquNuEhcKDtu2xB66Kx10mAYTB2T8?=
 =?us-ascii?Q?2tZ7Xb5cY5evutRnoFnvseSGhvhilPISojslYZP7I9C5ug7g/IaR/lF7r8Of?=
 =?us-ascii?Q?wg+ppUHgU+W1f/zRRUvEFYqwvMsDvUJdAjcB5pDke2XL1NLkRxZKjIjFMITK?=
 =?us-ascii?Q?lpjlPiwAwl79k4ygvbN39DIEFveasEwC1Obpc3GmqVo3z7nmjuU+nLpJEn+A?=
 =?us-ascii?Q?dWZqjhtgX1XygQoaKMSmADlRtQRVzfcaYi2XSezjDTwrs97HjoTORPybhorT?=
 =?us-ascii?Q?D3ZUeRIqAHa8fXaNRU4sTeS6a7nfZbiqoe/F8gK5Gz1WsbnHMmBejVOdh1//?=
 =?us-ascii?Q?KvDcAWXJdU+Y/a/02DbmpgiQPgW6SDk/t6gfq7Dl+SiB9JVgJ9QPJ6CUSB4Z?=
 =?us-ascii?Q?9G6U6lmbScYV5D0IrinHH79nACOHtJ0tXb2Vvq8ElOwgBdEi0hI/EmJ7vH6m?=
 =?us-ascii?Q?nbX3ZCXm2HeYRt0sd9qLnfFy6eVy+Qj9sskOht7IIMQevU5YXv3l2gu5qVyJ?=
 =?us-ascii?Q?WxXEzQRevbtuLLK2EJtAcM2BCSUQx5E=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee9bd261-82d6-4a7a-3c3b-08d9b657f59e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2021 12:25:15.0267
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pOb5XyzwHywpEVoOBcBw1aZXRJHmMzafO7cTeqn3Q7inx6LIQRdKmSlXQjdzL4E/zBZeHEZ4vDnxPPmKhUHmbPtrgPK4M3kdIQvyLoyI03I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5423
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baowen Zheng <baowen.zheng@corigine.com>

Use flow_indr_dev_register/flow_indr_dev_setup_offload to
offload tc action.

We need to call tc_cleanup_flow_action to clean up tc action entry since
in tc_setup_action, some actions may hold dev refcnt, especially the mirror
action.

Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 include/linux/netdevice.h  |  1 +
 include/net/flow_offload.h | 17 +++++++
 include/net/pkt_cls.h      |  6 +++
 net/core/flow_offload.c    | 42 +++++++++++++----
 net/sched/act_api.c        | 92 ++++++++++++++++++++++++++++++++++++++
 net/sched/act_csum.c       |  4 +-
 net/sched/act_ct.c         |  4 +-
 net/sched/act_gact.c       | 13 +++++-
 net/sched/act_gate.c       |  4 +-
 net/sched/act_mirred.c     | 13 +++++-
 net/sched/act_mpls.c       | 16 ++++++-
 net/sched/act_police.c     |  4 +-
 net/sched/act_sample.c     |  4 +-
 net/sched/act_skbedit.c    | 11 ++++-
 net/sched/act_tunnel_key.c |  9 +++-
 net/sched/act_vlan.c       | 16 ++++++-
 net/sched/cls_api.c        | 21 +++++++--
 17 files changed, 254 insertions(+), 23 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 65117f01d5f2..037577cbe3f0 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -916,6 +916,7 @@ enum tc_setup_type {
 	TC_SETUP_QDISC_TBF,
 	TC_SETUP_QDISC_FIFO,
 	TC_SETUP_QDISC_HTB,
+	TC_SETUP_ACT,
 };
 
 /* These structures hold the attributes of bpf state that are being passed
diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index f6970213497a..15662cad5bca 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -551,6 +551,23 @@ struct flow_cls_offload {
 	u32 classid;
 };
 
+enum flow_act_command {
+	FLOW_ACT_REPLACE,
+	FLOW_ACT_DESTROY,
+	FLOW_ACT_STATS,
+};
+
+struct flow_offload_action {
+	struct netlink_ext_ack *extack; /* NULL in FLOW_ACT_STATS process*/
+	enum flow_act_command command;
+	enum flow_action_id id;
+	u32 index;
+	struct flow_stats stats;
+	struct flow_action action;
+};
+
+struct flow_offload_action *flow_action_alloc(unsigned int num_actions);
+
 static inline struct flow_rule *
 flow_cls_offload_flow_rule(struct flow_cls_offload *flow_cmd)
 {
diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 193f88ebf629..13f0e4a3a136 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -258,6 +258,9 @@ static inline void tcf_exts_put_net(struct tcf_exts *exts)
 	for (; 0; (void)(i), (void)(a), (void)(exts))
 #endif
 
+#define tcf_act_for_each_action(i, a, actions) \
+	for (i = 0; i < TCA_ACT_MAX_PRIO && ((a) = actions[i]); i++)
+
 static inline void
 tcf_exts_stats_update(const struct tcf_exts *exts,
 		      u64 bytes, u64 packets, u64 drops, u64 lastuse,
@@ -534,6 +537,9 @@ tcf_match_indev(struct sk_buff *skb, int ifindex)
 
 int tc_setup_flow_action(struct flow_action *flow_action,
 			 const struct tcf_exts *exts);
+
+int tc_setup_action(struct flow_action *flow_action,
+		    struct tc_action *actions[]);
 void tc_cleanup_flow_action(struct flow_action *flow_action);
 
 int tc_setup_cb_call(struct tcf_block *block, enum tc_setup_type type,
diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index 6beaea13564a..31273a10086e 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -27,6 +27,26 @@ struct flow_rule *flow_rule_alloc(unsigned int num_actions)
 }
 EXPORT_SYMBOL(flow_rule_alloc);
 
+struct flow_offload_action *flow_action_alloc(unsigned int num_actions)
+{
+	struct flow_offload_action *fl_action;
+	int i;
+
+	fl_action = kzalloc(struct_size(fl_action, action.entries, num_actions),
+			    GFP_KERNEL);
+	if (!fl_action)
+		return NULL;
+
+	fl_action->action.num_entries = num_actions;
+	/* Pre-fill each action hw_stats with DONT_CARE.
+	 * Caller can override this if it wants stats for a given action.
+	 */
+	for (i = 0; i < num_actions; i++)
+		fl_action->action.entries[i].hw_stats = FLOW_ACTION_HW_STATS_DONT_CARE;
+
+	return fl_action;
+}
+
 #define FLOW_DISSECTOR_MATCH(__rule, __type, __out)				\
 	const struct flow_match *__m = &(__rule)->match;			\
 	struct flow_dissector *__d = (__m)->dissector;				\
@@ -549,19 +569,25 @@ int flow_indr_dev_setup_offload(struct net_device *dev,	struct Qdisc *sch,
 				void (*cleanup)(struct flow_block_cb *block_cb))
 {
 	struct flow_indr_dev *this;
+	u32 count = 0;
+	int err;
 
 	mutex_lock(&flow_indr_block_lock);
+	if (bo) {
+		if (bo->command == FLOW_BLOCK_BIND)
+			indir_dev_add(data, dev, sch, type, cleanup, bo);
+		else if (bo->command == FLOW_BLOCK_UNBIND)
+			indir_dev_remove(data);
+	}
 
-	if (bo->command == FLOW_BLOCK_BIND)
-		indir_dev_add(data, dev, sch, type, cleanup, bo);
-	else if (bo->command == FLOW_BLOCK_UNBIND)
-		indir_dev_remove(data);
-
-	list_for_each_entry(this, &flow_block_indr_dev_list, list)
-		this->cb(dev, sch, this->cb_priv, type, bo, data, cleanup);
+	list_for_each_entry(this, &flow_block_indr_dev_list, list) {
+		err = this->cb(dev, sch, this->cb_priv, type, bo, data, cleanup);
+		if (!err)
+			count++;
+	}
 
 	mutex_unlock(&flow_indr_block_lock);
 
-	return list_empty(&bo->cb_list) ? -EOPNOTSUPP : 0;
+	return (bo && list_empty(&bo->cb_list)) ? -EOPNOTSUPP : count;
 }
 EXPORT_SYMBOL(flow_indr_dev_setup_offload);
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 3258da3d5bed..120e72d8502c 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -19,8 +19,10 @@
 #include <net/sock.h>
 #include <net/sch_generic.h>
 #include <net/pkt_cls.h>
+#include <net/tc_act/tc_pedit.h>
 #include <net/act_api.h>
 #include <net/netlink.h>
+#include <net/flow_offload.h>
 
 #ifdef CONFIG_INET
 DEFINE_STATIC_KEY_FALSE(tcf_frag_xmit_count);
@@ -129,8 +131,91 @@ static void free_tcf(struct tc_action *p)
 	kfree(p);
 }
 
+static unsigned int tcf_act_num_actions_single(struct tc_action *act)
+{
+	if (is_tcf_pedit(act))
+		return tcf_pedit_nkeys(act);
+	else
+		return 1;
+}
+
+static int flow_action_init(struct flow_offload_action *fl_action,
+			    struct tc_action *act,
+			    enum flow_act_command cmd,
+			    struct netlink_ext_ack *extack)
+{
+	fl_action->extack = extack;
+	fl_action->command = cmd;
+	fl_action->index = act->tcfa_index;
+
+	if (act->ops->flow_act_setup)
+		return act->ops->flow_act_setup(act, fl_action, NULL, false);
+
+	return -EOPNOTSUPP;
+}
+
+static int tcf_action_offload_cmd(struct flow_offload_action *fl_act,
+				  struct netlink_ext_ack *extack)
+{
+	int err;
+
+	err = flow_indr_dev_setup_offload(NULL, NULL, TC_SETUP_ACT,
+					  fl_act, NULL, NULL);
+	if (err < 0)
+		return err;
+
+	return 0;
+}
+
+/* offload the tc command after inserted */
+static int tcf_action_offload_add(struct tc_action *action,
+				  struct netlink_ext_ack *extack)
+{
+	struct tc_action *actions[TCA_ACT_MAX_PRIO] = {
+		[0] = action,
+	};
+	struct flow_offload_action *fl_action;
+	int err = 0;
+
+	fl_action = flow_action_alloc(tcf_act_num_actions_single(action));
+	if (!fl_action)
+		return -ENOMEM;
+
+	err = flow_action_init(fl_action, action, FLOW_ACT_REPLACE, extack);
+	if (err)
+		goto fl_err;
+
+	err = tc_setup_action(&fl_action->action, actions);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Failed to setup tc actions for offload\n");
+		goto fl_err;
+	}
+
+	err = tcf_action_offload_cmd(fl_action, extack);
+	tc_cleanup_flow_action(&fl_action->action);
+
+fl_err:
+	kfree(fl_action);
+
+	return err;
+}
+
+static int tcf_action_offload_del(struct tc_action *action)
+{
+	struct flow_offload_action fl_act = {};
+	int err = 0;
+
+	err = flow_action_init(&fl_act, action, FLOW_ACT_DESTROY, NULL);
+	if (err)
+		return err;
+
+	return tcf_action_offload_cmd(&fl_act, NULL);
+}
+
 static void tcf_action_cleanup(struct tc_action *p)
 {
+	tcf_action_offload_del(p);
 	if (p->ops->cleanup)
 		p->ops->cleanup(p);
 
@@ -1061,6 +1146,11 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 	return ERR_PTR(err);
 }
 
+static bool tc_act_bind(u32 flags)
+{
+	return !!(flags & TCA_ACT_FLAGS_BIND);
+}
+
 /* Returns numbers of initialized actions or negative error. */
 
 int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
@@ -1103,6 +1193,8 @@ int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
 		sz += tcf_action_fill_size(act);
 		/* Start from index 0 */
 		actions[i - 1] = act;
+		if (!tc_act_bind(flags))
+			tcf_action_offload_add(act, extack);
 	}
 
 	/* We have to commit them all together, because if any error happened in
diff --git a/net/sched/act_csum.c b/net/sched/act_csum.c
index b55d687e3adc..26e9036240d9 100644
--- a/net/sched/act_csum.c
+++ b/net/sched/act_csum.c
@@ -705,7 +705,9 @@ static int tcf_csum_flow_act_setup(struct tc_action *act, void *entry_data,
 		entry->csum_flags = tcf_csum_update_flags(act);
 		*index_inc = 1;
 	} else {
-		return -EOPNOTSUPP;
+		struct flow_offload_action *fl_action = entry_data;
+
+		fl_action->id = FLOW_ACTION_CSUM;
 	}
 
 	return 0;
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 9edfed3b0f4b..485e4c7a086d 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -1505,7 +1505,9 @@ static int tcf_ct_flow_act_setup(struct tc_action *act, void *entry_data,
 		entry->ct.flow_table = tcf_ct_ft(act);
 		*index_inc = 1;
 	} else {
-		return -EOPNOTSUPP;
+		struct flow_offload_action *fl_action = entry_data;
+
+		fl_action->id = FLOW_ACTION_CT;
 	}
 
 	return 0;
diff --git a/net/sched/act_gact.c b/net/sched/act_gact.c
index 2342aa5d8284..7d2f0c9587c8 100644
--- a/net/sched/act_gact.c
+++ b/net/sched/act_gact.c
@@ -272,7 +272,18 @@ static int tcf_gact_flow_act_setup(struct tc_action *act, void *entry_data,
 		}
 		*index_inc = 1;
 	} else {
-		return -EOPNOTSUPP;
+		struct flow_offload_action *fl_action = entry_data;
+
+		if (is_tcf_gact_ok(act))
+			fl_action->id = FLOW_ACTION_ACCEPT;
+		else if (is_tcf_gact_shot(act))
+			fl_action->id = FLOW_ACTION_DROP;
+		else if (is_tcf_gact_trap(act))
+			fl_action->id = FLOW_ACTION_TRAP;
+		else if (is_tcf_gact_goto_chain(act))
+			fl_action->id = FLOW_ACTION_GOTO;
+		else
+			return -EOPNOTSUPP;
 	}
 
 	return 0;
diff --git a/net/sched/act_gate.c b/net/sched/act_gate.c
index cbdcbe4376bb..f149135c2e10 100644
--- a/net/sched/act_gate.c
+++ b/net/sched/act_gate.c
@@ -637,7 +637,9 @@ static int tcf_gate_flow_act_setup(struct tc_action *act, void *entry_data,
 			return err;
 		*index_inc = 1;
 	} else {
-		return -EOPNOTSUPP;
+		struct flow_offload_action *fl_action = entry_data;
+
+		fl_action->id = FLOW_ACTION_GATE;
 	}
 
 	return 0;
diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index 8c953b2dc2d5..7104dca72469 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -480,7 +480,18 @@ static int tcf_mirred_flow_act_setup(struct tc_action *act, void *entry_data,
 		}
 		*index_inc = 1;
 	} else {
-		return -EOPNOTSUPP;
+		struct flow_offload_action *fl_action = entry_data;
+
+		if (is_tcf_mirred_egress_redirect(act))
+			fl_action->id = FLOW_ACTION_REDIRECT;
+		else if (is_tcf_mirred_egress_mirror(act))
+			fl_action->id = FLOW_ACTION_MIRRED;
+		else if (is_tcf_mirred_ingress_redirect(act))
+			fl_action->id = FLOW_ACTION_REDIRECT_INGRESS;
+		else if (is_tcf_mirred_ingress_mirror(act))
+			fl_action->id = FLOW_ACTION_MIRRED_INGRESS;
+		else
+			return -EOPNOTSUPP;
 	}
 
 	return 0;
diff --git a/net/sched/act_mpls.c b/net/sched/act_mpls.c
index 69bc9e10ee3e..720f57ec9a48 100644
--- a/net/sched/act_mpls.c
+++ b/net/sched/act_mpls.c
@@ -415,7 +415,21 @@ static int tcf_mpls_flow_act_setup(struct tc_action *act, void *entry_data,
 		}
 		*index_inc = 1;
 	} else {
-		return -EOPNOTSUPP;
+		struct flow_offload_action *fl_action = entry_data;
+
+		switch (tcf_mpls_action(act)) {
+		case TCA_MPLS_ACT_PUSH:
+			fl_action->id = FLOW_ACTION_MPLS_PUSH;
+			break;
+		case TCA_MPLS_ACT_POP:
+			fl_action->id = FLOW_ACTION_MPLS_POP;
+			break;
+		case TCA_MPLS_ACT_MODIFY:
+			fl_action->id = FLOW_ACTION_MPLS_MANGLE;
+			break;
+		default:
+			return -EOPNOTSUPP;
+		}
 	}
 
 	return 0;
diff --git a/net/sched/act_police.c b/net/sched/act_police.c
index f48e9765b70e..b8b64c72d686 100644
--- a/net/sched/act_police.c
+++ b/net/sched/act_police.c
@@ -421,7 +421,9 @@ static int tcf_police_flow_act_setup(struct tc_action *act, void *entry_data,
 		entry->police.mtu = tcf_police_tcfp_mtu(act);
 		*index_inc = 1;
 	} else {
-		return -EOPNOTSUPP;
+		struct flow_offload_action *fl_action = entry_data;
+
+		fl_action->id = FLOW_ACTION_POLICE;
 	}
 
 	return 0;
diff --git a/net/sched/act_sample.c b/net/sched/act_sample.c
index 1b0bb501218e..df7bfa688372 100644
--- a/net/sched/act_sample.c
+++ b/net/sched/act_sample.c
@@ -303,7 +303,9 @@ static int tcf_sample_flow_act_setup(struct tc_action *act, void *entry_data,
 		tcf_flow_sample_get_group(entry, act);
 		*index_inc = 1;
 	} else {
-		return -EOPNOTSUPP;
+		struct flow_offload_action *fl_action = entry_data;
+
+		fl_action->id = FLOW_ACTION_SAMPLE;
 	}
 
 	return 0;
diff --git a/net/sched/act_skbedit.c b/net/sched/act_skbedit.c
index b0d791560aa6..c4fd5dc21bbc 100644
--- a/net/sched/act_skbedit.c
+++ b/net/sched/act_skbedit.c
@@ -347,7 +347,16 @@ static int tcf_skbedit_flow_act_setup(struct tc_action *act, void *entry_data,
 		}
 		*index_inc = 1;
 	} else {
-		return -EOPNOTSUPP;
+		struct flow_offload_action *fl_action = entry_data;
+
+		if (is_tcf_skbedit_mark(act))
+			fl_action->id = FLOW_ACTION_MARK;
+		else if (is_tcf_skbedit_ptype(act))
+			fl_action->id = FLOW_ACTION_PTYPE;
+		else if (is_tcf_skbedit_priority(act))
+			fl_action->id = FLOW_ACTION_PRIORITY;
+		else
+			return -EOPNOTSUPP;
 	}
 
 	return 0;
diff --git a/net/sched/act_tunnel_key.c b/net/sched/act_tunnel_key.c
index 14d8307c31a5..2ebc797c047a 100644
--- a/net/sched/act_tunnel_key.c
+++ b/net/sched/act_tunnel_key.c
@@ -827,7 +827,14 @@ static int tcf_tunnel_key_flow_act_setup(struct tc_action *act,
 		}
 		*index_inc = 1;
 	} else {
-		return -EOPNOTSUPP;
+		struct flow_offload_action *fl_action = entry_data;
+
+		if (is_tcf_tunnel_set(act))
+			fl_action->id = FLOW_ACTION_TUNNEL_ENCAP;
+		else if (is_tcf_tunnel_release(act))
+			fl_action->id = FLOW_ACTION_TUNNEL_DECAP;
+		else
+			return -EOPNOTSUPP;
 	}
 
 	return 0;
diff --git a/net/sched/act_vlan.c b/net/sched/act_vlan.c
index 5de24a995020..5f0ed3b5a5ac 100644
--- a/net/sched/act_vlan.c
+++ b/net/sched/act_vlan.c
@@ -395,7 +395,21 @@ static int tcf_vlan_flow_act_setup(struct tc_action *act, void *entry_data,
 		}
 		*index_inc = 1;
 	} else {
-		return -EOPNOTSUPP;
+		struct flow_offload_action *fl_action = entry_data;
+
+		switch (tcf_vlan_action(act)) {
+		case TCA_VLAN_ACT_PUSH:
+			fl_action->id = FLOW_ACTION_VLAN_PUSH;
+			break;
+		case TCA_VLAN_ACT_POP:
+			fl_action->id = FLOW_ACTION_VLAN_POP;
+			break;
+		case TCA_VLAN_ACT_MODIFY:
+			fl_action->id = FLOW_ACTION_VLAN_MANGLE;
+			break;
+		default:
+			return -EOPNOTSUPP;
+		}
 	}
 
 	return 0;
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 33b81c867ac0..2a1cc7fe2dd9 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3488,8 +3488,8 @@ static int tc_setup_flow_act(struct tc_action *act,
 #endif
 }
 
-int tc_setup_flow_action(struct flow_action *flow_action,
-			 const struct tcf_exts *exts)
+int tc_setup_action(struct flow_action *flow_action,
+		    struct tc_action *actions[])
 {
 	int i, j, index, err = 0;
 	struct tc_action *act;
@@ -3498,11 +3498,11 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 	BUILD_BUG_ON(TCA_ACT_HW_STATS_IMMEDIATE != FLOW_ACTION_HW_STATS_IMMEDIATE);
 	BUILD_BUG_ON(TCA_ACT_HW_STATS_DELAYED != FLOW_ACTION_HW_STATS_DELAYED);
 
-	if (!exts)
+	if (!actions)
 		return 0;
 
 	j = 0;
-	tcf_exts_for_each_action(i, act, exts) {
+	tcf_act_for_each_action(i, act, actions) {
 		struct flow_action_entry *entry;
 
 		entry = &flow_action->entries[j];
@@ -3531,6 +3531,19 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 	spin_unlock_bh(&act->tcfa_lock);
 	goto err_out;
 }
+
+int tc_setup_flow_action(struct flow_action *flow_action,
+			 const struct tcf_exts *exts)
+{
+#ifdef CONFIG_NET_CLS_ACT
+	if (!exts)
+		return 0;
+
+	return tc_setup_action(flow_action, exts->actions);
+#else
+	return 0;
+#endif
+}
 EXPORT_SYMBOL(tc_setup_flow_action);
 
 unsigned int tcf_exts_num_actions(struct tcf_exts *exts)
-- 
2.20.1

