Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF4724793D3
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 19:18:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240331AbhLQSSL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 13:18:11 -0500
Received: from mail-mw2nam10lp2106.outbound.protection.outlook.com ([104.47.55.106]:30377
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240271AbhLQSR7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 13:17:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HNN/DdXwEV9cD6RJEw2/CvskyAskUmaVGfybE9c0Fg2E34kB3v11ZlCFsMZ8Phh/883kCOvSv10DJ5SYZK3i/csnXpI5+ToMqdUT0Nk9A9UI3rfIyseoVrj0Gv048uLmxI9rxup60i5txkJyVHIXgqGVrUjd74WgHHdaKgrcbfCgBCYfeCUa5qjmfILHg4R6BSYxSGiq37Aqe1Vts4Ud8yh3/SUGCi/Na+8Ogh4RA5QAnfajsBjx2Lfe5K94M3OVKRN0hh15MgbYD01ccs2HQ+QTWSWlZduS/UH4vCOhiwfoEdL5DGB3LxYQ3FwO1vh7X6YE6rEjQ8F/jWJ7d7qr4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mlHJG9PTyxekjfMaYmGsORCLGiNZbLZ5jccegE0GeLI=;
 b=muRcifua53n5ISfphpzUbqmpWNUauUODeMz0ZCraWOw8No3YChxIN3CnFc0XdzyBUaISpIwb2IgXmgbcjTw9oJKEpyUG4E0yXs7/ZaHBn0QTGiLJeIJlSTWq4SOZfQ6MVtAjY9LDEZM3Qe7bQL5w8lTo9nl7JRpt0KRGx6JOMD6g32Fu0LRV5CmWdQeMvcoSwdh8AyNWh8VxJTn7cGMq4ZHj7hvwT5ol4Fe7fj8EBbuDOPnfQvlU7lZ4MgeHj3e4x3VLVG3fwFrIiatNjQVvnII6mjIfZK/UrsQpM+o8/GJy1vIHQnJ5/zp0oVgCjd7CLFIPJux31gOXXafNErDF9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mlHJG9PTyxekjfMaYmGsORCLGiNZbLZ5jccegE0GeLI=;
 b=XJXT2AnndnUerIs3SORh7U7YRQkWGIMYVV/OI4IDCEgi/up6LgxX5+sWI5j4TNT+F7e9hVA7CZv3Ypn+cECPxg78+8bdWRSHiaEn4J47T0tBvQw6IWOrz4phknTuK2WCpWmhKijpuqrYioSbTVYacmZryCqbkJMrIWecZ0NRS5I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5004.namprd13.prod.outlook.com (2603:10b6:510:7b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.12; Fri, 17 Dec
 2021 18:17:58 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c%9]) with mapi id 15.20.4801.014; Fri, 17 Dec 2021
 18:17:58 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Leon Romanovsky <leon@kernel.org>,
        Michael Chan <michael.chan@broadcom.com>,
        Oz Shlomo <ozsh@nvidia.com>, Petr Machata <petrm@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        UNGLinuxDriver@microchip.com, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v8 net-next 11/13] flow_offload: add reoffload process to update hw_count
Date:   Fri, 17 Dec 2021 19:16:27 +0100
Message-Id: <20211217181629.28081-12-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211217181629.28081-1-simon.horman@corigine.com>
References: <20211217181629.28081-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR06CA0097.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::38) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 86769d6f-9b32-4c46-774e-08d9c1898db0
X-MS-TrafficTypeDiagnostic: PH0PR13MB5004:EE_
X-Microsoft-Antispam-PRVS: <PH0PR13MB50047EEE20EA39D993E4C183E8789@PH0PR13MB5004.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +yu8UaIo79Y2gCiKacQJQAszDa1mTgoI9SV2soMRlOTH+uydJLCghMJ9mNToBwmJUxA3OAPU1SL6MPe1fNBFI8G0l09NibwbcEylxpMJliK4FlNuCXzLJ5N0/iB9Hs3t+mmlgSXnQejorCZwspuneNR9znus4HY7Cel241Olu84vtfqG4KPvfEeZLfcClJs92+vwTpzQ+BHjaTyiljO/Z4ueiqczbsajcmWfRgV102WohHE1HzQUWl5grcuy6BAWb3YG/5w4TMFEKTejvbhMKs5BwZpNHk6WmYj4zdARiBVLm8bmJa8zH127Je4sQpHWwcAq6OtOd0YW+zmnx1AC5W3IOO9hEsV9lOWVIzO3PQ5KqE7ITi4EgKMw3s4yvG69CDRqNW6xwZJMjb6edXaVplghXeX6rkA6Tq52QSz//LWCqnRXwagHGaSyrfODeXZmaO6J171HrvoJE8PEz6Fqu6QnyqTkqhrrfvbjGs2c7ViMn64Tz6uPoXYv5W+fVXNFBL26li2Bq+G+bhThLcW1P30YHKySg2PzBxnYgeqmeAZaBW/X6hV7dssgaLyCNS6so++MpScvQjAZQ5fTcYwCZVrO9untCc9rxykACkd0KvabetdmDJIJEF4/8lCdGBs36jj41D2P2YoWnG9SoDCmR5468ufNzBGYrXPH6BUZnU2laXtSnbg8oUElQ+Pyy/56
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(136003)(396003)(346002)(376002)(39840400004)(366004)(508600001)(36756003)(6486002)(7416002)(5660300002)(186003)(6506007)(38100700002)(2906002)(44832011)(52116002)(6512007)(66476007)(83380400001)(8676002)(54906003)(110136005)(86362001)(107886003)(66556008)(1076003)(2616005)(4326008)(316002)(66946007)(8936002)(6666004)(15650500001)(30864003)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kifq9prUbw17oOXjSbLqzHdQ88FRDGJVywqjBqOxSq/wkNaG6S5V7rS5k0Zd?=
 =?us-ascii?Q?id7bwbsXnlklBjg6eOoAhqEc0KaBrY79qA+d54emdCcZ1X9CmnDEHZY2jDe3?=
 =?us-ascii?Q?PBP7bgOsvmE9fLkgEneeXGIa//CuPsmKcvgQIvPOpYsWt0QLy7DNqpIh9xDK?=
 =?us-ascii?Q?XZzHartNB/VlquPawfMRXCS1OnP9rQ3E8f1AVUdTmMQsOCnaey0lO6Ef2JGq?=
 =?us-ascii?Q?5fUKiS0MJZ7+Ld4w9Ek6IWc+udI5xP6OwQYu9wxSRx5Hm8rN9fIA04yhUKI6?=
 =?us-ascii?Q?f/tVdCB2aiy4FRpo3phpDfiFKD76BaPP82QCespA3ekPRFGlkTacv9WHk8b6?=
 =?us-ascii?Q?pho0DxadEbwTiRylpo/GRzw9x+fRd3J5cbV9Hn8QPQyWQjN5c0u3jCLW0G70?=
 =?us-ascii?Q?M3V+AzLvGub77DDhXI+B2DKO6HLSixdzSfMuR19KPRU1wEtHqGFsV1e6gp0t?=
 =?us-ascii?Q?Od/ZnfavIt941dnnnhoaBIaOceOjxQHFv/bNwJpp2n8RjezS+1faQv60nY5L?=
 =?us-ascii?Q?5IOX+lFfaPJh9BEwcTZOyujPnSc6KjFzAo4ES5UZhxqxSxPoMz7JE/+dp/ej?=
 =?us-ascii?Q?8WtGoXKkHLrnN6Bz0RzTXmVslJMhl+/mdj0aUiKcQeOz2jEZqi7S/BbeTYSV?=
 =?us-ascii?Q?hxm4592wQOEIExpZFMTLcPe2odKThZfsFWJW538LUisABjpbMxX1F7AZ4CKJ?=
 =?us-ascii?Q?8jNZILn8tbvyg1ci4V6bfVnddzScDR4vuE8RIn5qBZPZBrgdBONf4cOPaN+J?=
 =?us-ascii?Q?F49gR0EH7U23RqoMVumokT3poO8RISSejP16Kn3RcYlakD8znyRxzrOEVs6i?=
 =?us-ascii?Q?Yj4uicWYrPIonzpPjp3tHQcXx/GRqt8nvqM1J/414AV1uzUjEyW6lwRhsrtq?=
 =?us-ascii?Q?8/UE1AIjOZ5Xr4PNOR42FM50X72Y1mJeCfAK6Erkt7btAztPSYlQ73ajc/oh?=
 =?us-ascii?Q?qLJspGwDckg4ByCzY8do8jaYk8zqrGdIY5LZ82daNUbP0lJjhYM6Wn0ns6cv?=
 =?us-ascii?Q?lkm7JIawCu5KVBKzlmQw8/hwHg5wyR99sKp6WQhh+XgqRMR7FNg7dMwIWMOx?=
 =?us-ascii?Q?bUEKglO49w5VKu0wuoQZSzrFxfQTVMcEIV1sF25ARkAuDR9sHtitRe5nlEqk?=
 =?us-ascii?Q?S7Vt14xwpjpPvzJ0EdXzY8TPN+kcvs8GdsfvH8sIhdehhvsyMtu09ftf8Vau?=
 =?us-ascii?Q?CGT/4hjvBqhbPkaW+12fk1DNw/fi8gxijPlfs8741K9NSjaF1CXoL+wfHY0H?=
 =?us-ascii?Q?bCqfH8Mzh3XUqna6XJ65SnZubcwhAiqpYfazwgxzDR8Ci77Y0MOCSDxv3x6m?=
 =?us-ascii?Q?oUKo7WkGNn9iz/GRjKuLUrOkmfl1sLTSAylebuVF8ECwVVDJHMVT5PattHsH?=
 =?us-ascii?Q?T5EOeTxf+SMxZqN1MCVbWSr97wMhATZ/lmUhQN5wpEEE8JdaS6HBb5PAChZH?=
 =?us-ascii?Q?sV0Ks7awHNhU6bH6KwczBXJHqNPzz1dT68KE9l4wMZwloZjkHTf813E/cQKl?=
 =?us-ascii?Q?VpC9naeevXQhJx51N9pb3gnn9zt3FQr5rV1IWjV3I35ChKdgleWn/10NoM7V?=
 =?us-ascii?Q?xbI6sGJAXt9WbDmMeeWT5xlOtaeVz5KjuhGx815e7JKxk4fVgcog6PzrJyDg?=
 =?us-ascii?Q?uB5RB8M0lamtD6K1a2uaOM69qOy4fIdZSxIrA2e0sk7k5K85JtlKwnH/g3d2?=
 =?us-ascii?Q?lDtc6Jf0dLUnv+kygnHGNo08MO4EKubxMW2pfgGrwd6A3PNPwecGAWHswieK?=
 =?us-ascii?Q?TIV7w3gHqQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86769d6f-9b32-4c46-774e-08d9c1898db0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2021 18:17:58.3270
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NSSf8vHg96SEg3iGBn6k6eP7X956cK5qjvFw3+ShT8bhVvpmuqBuhj5J+P3hW6JfigqkSj8921ebmTiwIR0zw3WD0IN5ju07yg3UqPLNr1g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5004
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baowen Zheng <baowen.zheng@corigine.com>

Add reoffload process to update hw_count when driver
is inserted or removed.

We will delete the action if it is with skip_sw flag and
not offloaded to any hardware in reoffload process.

When reoffloading actions, we still offload the actions
that are added independent of filters.

Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 include/net/act_api.h   |  11 ++
 net/core/flow_offload.c |   4 +
 net/sched/act_api.c     | 252 +++++++++++++++++++++++++++++++++++++---
 3 files changed, 250 insertions(+), 17 deletions(-)

diff --git a/include/net/act_api.h b/include/net/act_api.h
index 20104dfdd57c..0f5f69deb3ce 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -7,6 +7,7 @@
 */
 
 #include <linux/refcount.h>
+#include <net/flow_offload.h>
 #include <net/sch_generic.h>
 #include <net/pkt_sched.h>
 #include <net/net_namespace.h>
@@ -254,6 +255,8 @@ void tcf_action_update_stats(struct tc_action *a, u64 bytes, u64 packets,
 int tcf_action_copy_stats(struct sk_buff *, struct tc_action *, int);
 
 int tcf_action_update_hw_stats(struct tc_action *action);
+int tcf_action_reoffload_cb(flow_indr_block_bind_cb_t *cb,
+			    void *cb_priv, bool add);
 int tcf_action_check_ctrlact(int action, struct tcf_proto *tp,
 			     struct tcf_chain **handle,
 			     struct netlink_ext_ack *newchain);
@@ -265,6 +268,14 @@ DECLARE_STATIC_KEY_FALSE(tcf_frag_xmit_count);
 #endif
 
 int tcf_dev_queue_xmit(struct sk_buff *skb, int (*xmit)(struct sk_buff *skb));
+
+#else /* !CONFIG_NET_CLS_ACT */
+
+static inline int tcf_action_reoffload_cb(flow_indr_block_bind_cb_t *cb,
+					  void *cb_priv, bool add) {
+	return 0;
+}
+
 #endif /* CONFIG_NET_CLS_ACT */
 
 static inline void tcf_action_stats_update(struct tc_action *a, u64 bytes,
diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index 022c945817fa..73f68d4625f3 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #include <linux/kernel.h>
 #include <linux/slab.h>
+#include <net/act_api.h>
 #include <net/flow_offload.h>
 #include <linux/rtnetlink.h>
 #include <linux/mutex.h>
@@ -417,6 +418,8 @@ int flow_indr_dev_register(flow_indr_block_bind_cb_t *cb, void *cb_priv)
 	existing_qdiscs_register(cb, cb_priv);
 	mutex_unlock(&flow_indr_block_lock);
 
+	tcf_action_reoffload_cb(cb, cb_priv, true);
+
 	return 0;
 }
 EXPORT_SYMBOL(flow_indr_dev_register);
@@ -469,6 +472,7 @@ void flow_indr_dev_unregister(flow_indr_block_bind_cb_t *cb, void *cb_priv,
 	__flow_block_indr_cleanup(release, cb_priv, &cleanup_list);
 	mutex_unlock(&flow_indr_block_lock);
 
+	tcf_action_reoffload_cb(cb, cb_priv, false);
 	flow_block_indr_notify(&cleanup_list);
 	kfree(indr_dev);
 }
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index b32680ad75d3..99f998be2040 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -137,6 +137,19 @@ static void offload_action_hw_count_set(struct tc_action *act,
 	act->in_hw_count = hw_count;
 }
 
+static void offload_action_hw_count_inc(struct tc_action *act,
+					u32 hw_count)
+{
+	act->in_hw_count += hw_count;
+}
+
+static void offload_action_hw_count_dec(struct tc_action *act,
+					u32 hw_count)
+{
+	act->in_hw_count = act->in_hw_count > hw_count ?
+			   act->in_hw_count - hw_count : 0;
+}
+
 static unsigned int tcf_offload_act_num_actions_single(struct tc_action *act)
 {
 	if (is_tcf_pedit(act))
@@ -183,9 +196,8 @@ static int offload_action_init(struct flow_offload_action *fl_action,
 	return -EOPNOTSUPP;
 }
 
-static int tcf_action_offload_cmd(struct flow_offload_action *fl_act,
-				  u32 *hw_count,
-				  struct netlink_ext_ack *extack)
+static int tcf_action_offload_cmd_ex(struct flow_offload_action *fl_act,
+				     u32 *hw_count)
 {
 	int err;
 
@@ -200,9 +212,37 @@ static int tcf_action_offload_cmd(struct flow_offload_action *fl_act,
 	return 0;
 }
 
-/* offload the tc action after it is inserted */
-static int tcf_action_offload_add(struct tc_action *action,
-				  struct netlink_ext_ack *extack)
+static int tcf_action_offload_cmd_cb_ex(struct flow_offload_action *fl_act,
+					u32 *hw_count,
+					flow_indr_block_bind_cb_t *cb,
+					void *cb_priv)
+{
+	int err;
+
+	err = cb(NULL, NULL, cb_priv, TC_SETUP_ACT, NULL, fl_act, NULL);
+	if (err < 0)
+		return err;
+
+	if (hw_count)
+		*hw_count = 1;
+
+	return 0;
+}
+
+static int tcf_action_offload_cmd(struct flow_offload_action *fl_act,
+				  u32 *hw_count,
+				  flow_indr_block_bind_cb_t *cb,
+				  void *cb_priv)
+{
+	return cb ? tcf_action_offload_cmd_cb_ex(fl_act, hw_count,
+						 cb, cb_priv) :
+		    tcf_action_offload_cmd_ex(fl_act, hw_count);
+}
+
+static int tcf_action_offload_add_ex(struct tc_action *action,
+				     struct netlink_ext_ack *extack,
+				     flow_indr_block_bind_cb_t *cb,
+				     void *cb_priv)
 {
 	bool skip_sw = tc_act_skip_sw(action->tcfa_flags);
 	struct tc_action *actions[TCA_ACT_MAX_PRIO] = {
@@ -231,9 +271,10 @@ static int tcf_action_offload_add(struct tc_action *action,
 		goto fl_err;
 	}
 
-	err = tcf_action_offload_cmd(fl_action, &in_hw_count, extack);
+	err = tcf_action_offload_cmd(fl_action, &in_hw_count, cb, cb_priv);
 	if (!err)
-		offload_action_hw_count_set(action, in_hw_count);
+		cb ? offload_action_hw_count_inc(action, in_hw_count) :
+		     offload_action_hw_count_set(action, in_hw_count);
 
 	if (skip_sw && !tc_act_in_hw(action))
 		err = -EINVAL;
@@ -246,6 +287,13 @@ static int tcf_action_offload_add(struct tc_action *action,
 	return err;
 }
 
+/* offload the tc action after it is inserted */
+static int tcf_action_offload_add(struct tc_action *action,
+				  struct netlink_ext_ack *extack)
+{
+	return tcf_action_offload_add_ex(action, extack, NULL, NULL);
+}
+
 int tcf_action_update_hw_stats(struct tc_action *action)
 {
 	struct flow_offload_action fl_act = {};
@@ -258,7 +306,7 @@ int tcf_action_update_hw_stats(struct tc_action *action)
 	if (err)
 		return err;
 
-	err = tcf_action_offload_cmd(&fl_act, NULL, NULL);
+	err = tcf_action_offload_cmd(&fl_act, NULL, NULL, NULL);
 	if (!err) {
 		preempt_disable();
 		tcf_action_stats_update(action, fl_act.stats.bytes,
@@ -277,7 +325,9 @@ int tcf_action_update_hw_stats(struct tc_action *action)
 }
 EXPORT_SYMBOL(tcf_action_update_hw_stats);
 
-static int tcf_action_offload_del(struct tc_action *action)
+static int tcf_action_offload_del_ex(struct tc_action *action,
+				     flow_indr_block_bind_cb_t *cb,
+				     void *cb_priv)
 {
 	struct flow_offload_action fl_act = {};
 	u32 in_hw_count = 0;
@@ -290,16 +340,25 @@ static int tcf_action_offload_del(struct tc_action *action)
 	if (err)
 		return err;
 
-	err = tcf_action_offload_cmd(&fl_act, &in_hw_count, NULL);
-	if (err)
+	err = tcf_action_offload_cmd(&fl_act, &in_hw_count, cb, cb_priv);
+	if (err < 0)
 		return err;
 
-	if (action->in_hw_count != in_hw_count)
+	if (!cb && action->in_hw_count != in_hw_count)
 		return -EINVAL;
 
+	/* do not need to update hw state when deleting action */
+	if (cb && in_hw_count)
+		offload_action_hw_count_dec(action, in_hw_count);
+
 	return 0;
 }
 
+static int tcf_action_offload_del(struct tc_action *action)
+{
+	return tcf_action_offload_del_ex(action, NULL, NULL);
+}
+
 static void tcf_action_cleanup(struct tc_action *p)
 {
 	tcf_action_offload_del(p);
@@ -794,6 +853,59 @@ EXPORT_SYMBOL(tcf_idrinfo_destroy);
 
 static LIST_HEAD(act_base);
 static DEFINE_RWLOCK(act_mod_lock);
+/* since act ops id is stored in pernet subsystem list,
+ * then there is no way to walk through only all the action
+ * subsystem, so we keep tc action pernet ops id for
+ * reoffload to walk through.
+ */
+static LIST_HEAD(act_pernet_id_list);
+static DEFINE_MUTEX(act_id_mutex);
+struct tc_act_pernet_id {
+	struct list_head list;
+	unsigned int id;
+};
+
+static int tcf_pernet_add_id_list(unsigned int id)
+{
+	struct tc_act_pernet_id *id_ptr;
+	int ret = 0;
+
+	mutex_lock(&act_id_mutex);
+	list_for_each_entry(id_ptr, &act_pernet_id_list, list) {
+		if (id_ptr->id == id) {
+			ret = -EEXIST;
+			goto err_out;
+		}
+	}
+
+	id_ptr = kzalloc(sizeof(*id_ptr), GFP_KERNEL);
+	if (!id_ptr) {
+		ret = -ENOMEM;
+		goto err_out;
+	}
+	id_ptr->id = id;
+
+	list_add_tail(&id_ptr->list, &act_pernet_id_list);
+
+err_out:
+	mutex_unlock(&act_id_mutex);
+	return ret;
+}
+
+static void tcf_pernet_del_id_list(unsigned int id)
+{
+	struct tc_act_pernet_id *id_ptr;
+
+	mutex_lock(&act_id_mutex);
+	list_for_each_entry(id_ptr, &act_pernet_id_list, list) {
+		if (id_ptr->id == id) {
+			list_del(&id_ptr->list);
+			kfree(id_ptr);
+			break;
+		}
+	}
+	mutex_unlock(&act_id_mutex);
+}
 
 int tcf_register_action(struct tc_action_ops *act,
 			struct pernet_operations *ops)
@@ -812,18 +924,31 @@ int tcf_register_action(struct tc_action_ops *act,
 	if (ret)
 		return ret;
 
+	if (ops->id) {
+		ret = tcf_pernet_add_id_list(*ops->id);
+		if (ret)
+			goto err_id;
+	}
+
 	write_lock(&act_mod_lock);
 	list_for_each_entry(a, &act_base, head) {
 		if (act->id == a->id || (strcmp(act->kind, a->kind) == 0)) {
-			write_unlock(&act_mod_lock);
-			unregister_pernet_subsys(ops);
-			return -EEXIST;
+			ret = -EEXIST;
+			goto err_out;
 		}
 	}
 	list_add_tail(&act->head, &act_base);
 	write_unlock(&act_mod_lock);
 
 	return 0;
+
+err_out:
+	write_unlock(&act_mod_lock);
+	if (ops->id)
+		tcf_pernet_del_id_list(*ops->id);
+err_id:
+	unregister_pernet_subsys(ops);
+	return ret;
 }
 EXPORT_SYMBOL(tcf_register_action);
 
@@ -842,8 +967,11 @@ int tcf_unregister_action(struct tc_action_ops *act,
 		}
 	}
 	write_unlock(&act_mod_lock);
-	if (!err)
+	if (!err) {
 		unregister_pernet_subsys(ops);
+		if (ops->id)
+			tcf_pernet_del_id_list(*ops->id);
+	}
 	return err;
 }
 EXPORT_SYMBOL(tcf_unregister_action);
@@ -1595,6 +1723,96 @@ static int tcf_action_delete(struct net *net, struct tc_action *actions[])
 	return 0;
 }
 
+static int
+tcf_reoffload_del_notify(struct net *net, struct tc_action *action)
+{
+	size_t attr_size = tcf_action_fill_size(action);
+	struct tc_action *actions[TCA_ACT_MAX_PRIO] = {
+		[0] = action,
+	};
+	const struct tc_action_ops *ops = action->ops;
+	struct sk_buff *skb;
+	int ret;
+
+	skb = alloc_skb(attr_size <= NLMSG_GOODSIZE ? NLMSG_GOODSIZE : attr_size,
+			GFP_KERNEL);
+	if (!skb)
+		return -ENOBUFS;
+
+	if (tca_get_fill(skb, actions, 0, 0, 0, RTM_DELACTION, 0, 1) <= 0) {
+		kfree_skb(skb);
+		return -EINVAL;
+	}
+
+	ret = tcf_idr_release_unsafe(action);
+	if (ret == ACT_P_DELETED) {
+		module_put(ops->owner);
+		ret = rtnetlink_send(skb, net, 0, RTNLGRP_TC, 0);
+	} else {
+		kfree_skb(skb);
+	}
+
+	return ret;
+}
+
+int tcf_action_reoffload_cb(flow_indr_block_bind_cb_t *cb,
+			    void *cb_priv, bool add)
+{
+	struct tc_act_pernet_id *id_ptr;
+	struct tcf_idrinfo *idrinfo;
+	struct tc_action_net *tn;
+	struct tc_action *p;
+	unsigned int act_id;
+	unsigned long tmp;
+	unsigned long id;
+	struct idr *idr;
+	struct net *net;
+	int ret;
+
+	if (!cb)
+		return -EINVAL;
+
+	down_read(&net_rwsem);
+	mutex_lock(&act_id_mutex);
+
+	for_each_net(net) {
+		list_for_each_entry(id_ptr, &act_pernet_id_list, list) {
+			act_id = id_ptr->id;
+			tn = net_generic(net, act_id);
+			if (!tn)
+				continue;
+			idrinfo = tn->idrinfo;
+			if (!idrinfo)
+				continue;
+
+			mutex_lock(&idrinfo->lock);
+			idr = &idrinfo->action_idr;
+			idr_for_each_entry_ul(idr, p, tmp, id) {
+				if (IS_ERR(p) || tc_act_bind(p->tcfa_flags))
+					continue;
+				if (add) {
+					tcf_action_offload_add_ex(p, NULL, cb,
+								  cb_priv);
+					continue;
+				}
+
+				/* cb unregister to update hw count */
+				ret = tcf_action_offload_del_ex(p, cb, cb_priv);
+				if (ret < 0)
+					continue;
+				if (tc_act_skip_sw(p->tcfa_flags) &&
+				    !tc_act_in_hw(p))
+					tcf_reoffload_del_notify(net, p);
+			}
+			mutex_unlock(&idrinfo->lock);
+		}
+	}
+	mutex_unlock(&act_id_mutex);
+	up_read(&net_rwsem);
+
+	return 0;
+}
+
 static int
 tcf_del_notify(struct net *net, struct nlmsghdr *n, struct tc_action *actions[],
 	       u32 portid, size_t attr_size, struct netlink_ext_ack *extack)
-- 
2.20.1

