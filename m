Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 684E546E597
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 10:29:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236281AbhLIJcq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 04:32:46 -0500
Received: from mail-bn8nam08on2090.outbound.protection.outlook.com ([40.107.100.90]:64096
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236295AbhLIJck (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 04:32:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YgmDAXx0812EeX6bXouDUYGlKYBLTFkr30zv6lglMZGWeNxR6p3BxIA4EAZTTZVBRm2CvFR+5tw6Zf25OjJPZkuA3idTgg0xUsmmDyOM9y8sLJ3QZyRIwUr9WENmMzh0G9Pz1SoIrKccUdsMJgVtrwv4WbEpTp9/WfDyJ4Lp825rsUVDnpu8yyTN8CfwxJP4QN0QLxi1MV+Jxfd8A9xoZfA3k2qjXK5v15U1DkdF3DZPKa0xrssJpiM28MS8Rjb4BDKwq7CdDqxMWD0Wb8SZrXZ6+H2bzj1r2Znu+LMbyByETB6vuD2J8Gue96vsG0CPylIgAhY2SguoY0ZxZGhIUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HvpaDlMK2X3ry/GlYCjwdbRvVPvTH+SSfhoqeMONDno=;
 b=VEaUobJAHxAL8RMDMWiyIguq9xv92Bv94LmUy/RklaG6Wa63NipDntZ8KqEDm+5kwNgCTUHHNJ1+2QUSVfajRcmQ4xxaNlk/VPhzCoPiOrZadc9nurVJ6f6aJBB/0XuSjqCsNI59ww3MURjML4gJQiA4fkxHvpdDGWiv9K8kDUcxH82tdo/+1YUL3tdx7GFRkuCe8bNNhixx/MQHGaDbBHNyeDR5c2bVcMFZtA7YM1/YnY7QTMwTdG29MnqtIF3Gm0f0uUP2x5z6iYcBEc/bVOI1AZoPKWAyjsPIDxw6xy1XmDODUZq4X9Hb+GXrDjUZ1pMN2ekARporTgkvmLeeBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HvpaDlMK2X3ry/GlYCjwdbRvVPvTH+SSfhoqeMONDno=;
 b=GavY+6ptRsuNv7d4w7Zc6n7Nvd6ACD+yjlVC+y/e/cBAyu/zjfTabTuW5zti4cdUFrS52Kw9Z4lfuhbiCmDYkRRsLE5PKDuIOmtlKxn1N0gNqKL0u5aReNvZir3oEhMnArJG8QaSk5qgrhWluF13xY06VVnV5BrkFVWw3kR2Hr4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5494.namprd13.prod.outlook.com (2603:10b6:510:128::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.10; Thu, 9 Dec
 2021 09:28:53 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c%9]) with mapi id 15.20.4778.012; Thu, 9 Dec 2021
 09:28:53 +0000
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
Subject: [PATCH v6 net-next 10/12] flow_offload: add reoffload process to update hw_count
Date:   Thu,  9 Dec 2021 10:28:04 +0100
Message-Id: <20211209092806.12336-11-simon.horman@corigine.com>
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
X-MS-Office365-Filtering-Correlation-Id: 745a40f0-f6fb-41be-d78a-08d9baf650bc
X-MS-TrafficTypeDiagnostic: PH0PR13MB5494:EE_
X-Microsoft-Antispam-PRVS: <PH0PR13MB549448D4A21EF85F26974ED3E8709@PH0PR13MB5494.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lP1zW0ZcbzCqe1WAZUtPFMdb7BlV/eTFa/7KeEiXOwoY0k6bem/CMgVHoxBaqIM2zEZ2tYybcCI78E04OVUyZE0ZDI9mCDbdOhtHdeyUFuFyfg8M+glyz0rIcIClov9IUJbF3KL8/fjmVUDbBf1Z1iZnTr43T7BqByk3nzaxTV3x7LSWW21Zx9mlthMsev1XrB6e1zEq7wKKh19ZJR+q5Toa2TNnoO+eu0SbeWTuL139Nq33uic0r1OpWA7jLWbT++68YGmz0BBvVW3eiSWiMk42s3J9mo/NkzZ07MpKVo05mqmJf5EDKlOzERBgyrLdgAVe4remfPRhQ1XLIgbarWXedQR5vcWsrf/ow0TyuvfjVJXozc2pYE2ZL7fBhKKfNb6p+FjsjhZ5u2GThGRLj9YT2m+A4bPTvA5J6A0bg+dS/SprXcBPdoyJYv8pFbpVhe9VX+9njjtlD164Pei0l8dp6VvArnXJQbzuNEIx4lHb/4TNa6/J71hCN+3dKsdvgeujc9xVrn8zHvI+SbYOKhRa2fYLu7uzAau0+PKAaU4IVZEbQ8zdx2epqH+zM7g98VrLFXkdFSTl1Y3VnD4wvsrJV3ztJw+sKrUsH07OfeF62Y76nhA69B8ksnw4Mp+PaBq2KNkKLxpjKuXRTdSc3A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(39840400004)(396003)(346002)(136003)(376002)(366004)(6666004)(6512007)(44832011)(38100700002)(6916009)(66556008)(86362001)(15650500001)(52116002)(316002)(1076003)(6506007)(8936002)(8676002)(4326008)(36756003)(2906002)(6486002)(5660300002)(186003)(66476007)(2616005)(83380400001)(30864003)(508600001)(54906003)(66946007)(107886003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+drf0qHf4pvOeVld9WTIbptFAqjO5tzOXFVFyRJRbgt63TxXdyElg0S6O5dM?=
 =?us-ascii?Q?o7k7cf8c84xyV8jt4++XgVHac2brAAerIdyGFzSe8W+f9MI4OWvKbdFP5MFo?=
 =?us-ascii?Q?UTYQnC4kjMoykT7dN1PgMIzslayqjKDf63Q7BwC9QWIQPgatAqbGq1H3zeTM?=
 =?us-ascii?Q?HCJqmZ+Uxg9ppLC/cwZn98E8CZtywa1aEQvix60rrYuxUZZZnQKTuSIBckAa?=
 =?us-ascii?Q?TGegCDw9ff7so04heMA6ws/q46fOTsIwB8SGatIfz5b7WaIcYyLjXY/9RP1S?=
 =?us-ascii?Q?kgh1FDXSVl6LrwpDL7uQddsp/VBMFxxxqxTdvc/H7UnRZJJTE3/hP7Re7kgh?=
 =?us-ascii?Q?M5jvZNY4NtOck1zMjEyB70r5nlNvx+FV+hzMoisZbHR+2TvBjv1GCw0SRlAp?=
 =?us-ascii?Q?sGTmd93+/SeMGjlCUGzZEXyO8EFVIpnVpdM4ZwSRMucF/LzZeCrnGTiWthAO?=
 =?us-ascii?Q?Ap1RhLA/pejeC9PGp+HPUEGsYBZ+dlberbT0SV1MPhfv5Ex68r42nGffWxU1?=
 =?us-ascii?Q?b5bXO8zoD2AfcqhT6hgthAwoZBVFZ//C7Q98Yb2TAKUqn3CLYrydENPp/ZDq?=
 =?us-ascii?Q?kd6EOYf18e9tux66LjubSqYW760ZqWvNcQy1FT7GqFk+OslXVV0WLq+PgyFC?=
 =?us-ascii?Q?w6R3WosQr2UVb2pb+YqXiHP902+UnIerRoR87MQUYnSO+qnBSdKh0InRDq0O?=
 =?us-ascii?Q?Nh1/VDy3UPEo8qBekwMFibEhM2r7OYbfxohX9HxhlAu5OLAMOq54Keyo6an4?=
 =?us-ascii?Q?Y0WH/r2XV/BgD2OyYjLyw+43q+3e0h99xHIU8pmxkW0wUpcx65tdRsFggKma?=
 =?us-ascii?Q?1LU2eI38lot6dcNnuLUVHWT8fs8QhuOX3+aO7WaEvrtojg7YTVSuFhQgvGlV?=
 =?us-ascii?Q?EjoU+DPuVq9rSkGJ315iLq298o6nVDEa3/gWUHfV9O1I1NAdzpzegnv/upMl?=
 =?us-ascii?Q?52SUes7Je4FEeIyqwaCtf5bnMFua+1Kd2YObm3hwO0dG7Ky2eo3WqZN0gBOU?=
 =?us-ascii?Q?LxvimaufyvH5IfaQ2x7OCDULx0TJOQePPGnujPgJDmEgSFAXXPzmD2Hsnolw?=
 =?us-ascii?Q?3Z2UMm2PT4NQDo4gaF9a5e4gdlHLDjWJvzWApWK0CyMeZPiSq+A0DfZswCZ+?=
 =?us-ascii?Q?eSrER+3ry52tbC80GeUZwwGrtXYtFo3qp2WcFK39Mcpsm9vMK5Tf+YMtv7O+?=
 =?us-ascii?Q?mAWfG4vkP5X1vYGW/Kv15Et0+9BAD0Ji8Kz/rekRkTqxvBT1qr3qq/uT9NEZ?=
 =?us-ascii?Q?hS0zhlOgDQ4Q/+il9MBPC3P0Mu17XVbnvg/YpgFxpNA5bk05+r1rVzCu/Y/t?=
 =?us-ascii?Q?91Rb+iSn81QNomYQ8DZLxyoaVJs+2p7eAprm2hcD9DCUJHDcgx9r3eZHRRTg?=
 =?us-ascii?Q?t2uffB+srIsS7aq2Efso8PiHCiWSYlJK5ZxrNWh5MbmlrbH72O9EjdoZGV7q?=
 =?us-ascii?Q?XLVC07Gga/Qq936dwT2/uPlYAquesQUBGFU6mJcup5Mo1TDosRs3n+mgNkMP?=
 =?us-ascii?Q?Dh2qShkvGCUea5E2uIb1zivSBFG4uXavWAU2dqVmeFp+vLKIq+sf7996kHeu?=
 =?us-ascii?Q?sanMHUWwTL5h7LiM/KSbDUGuZCiUyJc2NEUqeOAewIoGaHT7TCo2v2Dw8YCh?=
 =?us-ascii?Q?YaY5Q3RaKjhD5YFKDLktZOqZM6jZEFq4D7BUaMb1/JD+bcnfBg6q3kMXH3Kx?=
 =?us-ascii?Q?CVpm0WUJMRrogLG9wNMsU33NbgRJRgLSI3HlUnZ6D+hw/WbEnzzSJ2oDSvGU?=
 =?us-ascii?Q?i7pZm41ZzIs/CAUmnjr8xkUBuOk0k34=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 745a40f0-f6fb-41be-d78a-08d9baf650bc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2021 09:28:53.1966
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uU0HeEH5IAX6D+7t+WCxHieI4eAgfMD9dgrI+ySBguE7JhbpTVTApsW70S3EwXtMn8DnzpaoJnC81cXLCZH/VC1gGdOuf41eVuWKBY3/cgo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5494
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
 net/sched/act_api.c     | 250 +++++++++++++++++++++++++++++++++++++---
 3 files changed, 249 insertions(+), 16 deletions(-)

diff --git a/include/net/act_api.h b/include/net/act_api.h
index ce094e79f722..87ad1d3f2063 100644
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
index 31273a10086e..5538b289cd54 100644
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
index e11a73b5934c..668e596b539c 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -137,6 +137,19 @@ static void flow_action_hw_count_set(struct tc_action *act,
 	act->in_hw_count = hw_count;
 }
 
+static void flow_action_hw_count_inc(struct tc_action *act,
+				     u32 hw_count)
+{
+	act->in_hw_count += hw_count;
+}
+
+static void flow_action_hw_count_dec(struct tc_action *act,
+				     u32 hw_count)
+{
+	act->in_hw_count = act->in_hw_count > hw_count ?
+			   act->in_hw_count - hw_count : 0;
+}
+
 static unsigned int tcf_act_num_actions_single(struct tc_action *act)
 {
 	if (is_tcf_pedit(act))
@@ -183,9 +196,8 @@ static int flow_action_init(struct flow_offload_action *fl_action,
 	return -EOPNOTSUPP;
 }
 
-static int tcf_action_offload_cmd(struct flow_offload_action *fl_act,
-				  u32 *hw_count,
-				  struct netlink_ext_ack *extack)
+static int tcf_action_offload_cmd_ex(struct flow_offload_action *fl_act,
+				     u32 *hw_count)
 {
 	int err;
 
@@ -200,9 +212,38 @@ static int tcf_action_offload_cmd(struct flow_offload_action *fl_act,
 	return 0;
 }
 
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
 /* offload the tc command after inserted */
-static int tcf_action_offload_add(struct tc_action *action,
-				  struct netlink_ext_ack *extack)
+static int tcf_action_offload_add_ex(struct tc_action *action,
+				     struct netlink_ext_ack *extack,
+				     flow_indr_block_bind_cb_t *cb,
+				     void *cb_priv)
 {
 	bool skip_sw = tc_act_skip_sw(action->tcfa_flags);
 	struct tc_action *actions[TCA_ACT_MAX_PRIO] = {
@@ -230,9 +271,10 @@ static int tcf_action_offload_add(struct tc_action *action,
 		goto fl_err;
 	}
 
-	err = tcf_action_offload_cmd(fl_action, &in_hw_count, extack);
+	err = tcf_action_offload_cmd(fl_action, &in_hw_count, cb, cb_priv);
 	if (!err)
-		flow_action_hw_count_set(action, in_hw_count);
+		cb ? flow_action_hw_count_inc(action, in_hw_count) :
+		     flow_action_hw_count_set(action, in_hw_count);
 
 	if (skip_sw && !tc_act_in_hw(action))
 		err = -EINVAL;
@@ -245,6 +287,12 @@ static int tcf_action_offload_add(struct tc_action *action,
 	return err;
 }
 
+static int tcf_action_offload_add(struct tc_action *action,
+				  struct netlink_ext_ack *extack)
+{
+	return tcf_action_offload_add_ex(action, extack, NULL, NULL);
+}
+
 int tcf_action_update_hw_stats(struct tc_action *action)
 {
 	struct flow_offload_action fl_act = {};
@@ -257,7 +305,7 @@ int tcf_action_update_hw_stats(struct tc_action *action)
 	if (err)
 		return err;
 
-	err = tcf_action_offload_cmd(&fl_act, NULL, NULL);
+	err = tcf_action_offload_cmd(&fl_act, NULL, NULL, NULL);
 	if (!err) {
 		preempt_disable();
 		tcf_action_stats_update(action, fl_act.stats.bytes,
@@ -276,7 +324,9 @@ int tcf_action_update_hw_stats(struct tc_action *action)
 }
 EXPORT_SYMBOL(tcf_action_update_hw_stats);
 
-static int tcf_action_offload_del(struct tc_action *action)
+static int tcf_action_offload_del_ex(struct tc_action *action,
+				     flow_indr_block_bind_cb_t *cb,
+				     void *cb_priv)
 {
 	struct flow_offload_action fl_act = {};
 	u32 in_hw_count = 0;
@@ -289,16 +339,25 @@ static int tcf_action_offload_del(struct tc_action *action)
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
+		flow_action_hw_count_dec(action, in_hw_count);
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
@@ -793,6 +852,59 @@ EXPORT_SYMBOL(tcf_idrinfo_destroy);
 
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
@@ -811,18 +923,31 @@ int tcf_register_action(struct tc_action_ops *act,
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
 
@@ -841,8 +966,11 @@ int tcf_unregister_action(struct tc_action_ops *act,
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
@@ -1594,6 +1722,96 @@ static int tcf_action_delete(struct net *net, struct tc_action *actions[])
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

