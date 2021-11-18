Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8E0C455C55
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 14:09:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229957AbhKRNLr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 08:11:47 -0500
Received: from mail-dm6nam10on2122.outbound.protection.outlook.com ([40.107.93.122]:47280
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229732AbhKRNLm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 08:11:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PnOP4DD2XrcasOitlmxXz30IF9f4KZsb8WU0XfwiC14IyQTqgKWfK0DeauhPZ4Um84U8/lhcdY8oncAFKyJv/qRq+pHtRVTSPOX3oFGwQWN1KiwBsymY5OTi/SJH1Io5qN6xBGHWD8xm1GQMxG6ePC8thqdoihzDKA9Psz0yuMuBGIv6zgldtrTRQ2EP0QO26TN3d461KTZCsiSUrhqnwFiCPSRVMzpHfWMT/4MYqq+FPchwahxuK8I9y+3jxZj9RIzBU4DWNgWSqMH7Yf2QQMmChBZmV9t/jrYCjl1g+ajcKD9rttdD5Ws5uFQvDNQ7Jy3/2YSU0bHFMPiIu1FmjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6oP3UUnV8L/QrVlzpQVtIOS7nz5c8izoyFXmJaDgUGs=;
 b=PlM5cPwC36LEwbKBkmI2wlkSBzyIWvZ19VBKcNsPJC7LSOnEkJhJ0hb/w8rK734maukxH0mv190PVzMKyopoUnVXViSVmCEby9MMH5RMLl41PgeNNTujmShGt7plCzy/Sl8riPDIyxwGBMnSj3RBMQLVMKXxsMgcAV7NltyTkOIoWKf1obpaPnNfwk68dKxs6g8Ym6JzN9KrUJ1MRJIJGRh9hryJ1FSYJ1YThZERPcGPTtnL+/Xw1W7NwPKBnzOwcGUkHsiQoG9z/faCuVdZ+lJRRz4EYWvppb11jB6+F8x95tvLPdbn6M5NZVIziM8UpJa8eij43V2Qj+DZ2fI68w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6oP3UUnV8L/QrVlzpQVtIOS7nz5c8izoyFXmJaDgUGs=;
 b=QxpvDJVrM0ao2Y576OOv/5DbpYohVWNMQby/iqJSXfUtTlmedn/Qg1CdBfO4SXtUt4Ctel2+l/FdQcCnGCmneZjUHvko3JU/51DoQY4wC7oRNUsGMye3QPk/VqAacVCmo/I8fVnUE8H0QFLksGHN/UvPL79wmjyKVRWoVlbxtY8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5780.namprd13.prod.outlook.com (2603:10b6:510:11b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.7; Thu, 18 Nov
 2021 13:08:36 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::3152:9426:f3b1:6fd7]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::3152:9426:f3b1:6fd7%7]) with mapi id 15.20.4713.016; Thu, 18 Nov 2021
 13:08:36 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers@corigine.com
Subject: [PATCH v4 08/10] flow_offload: add reoffload process to update hw_count
Date:   Thu, 18 Nov 2021 14:08:03 +0100
Message-Id: <20211118130805.23897-9-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211118130805.23897-1-simon.horman@corigine.com>
References: <20211118130805.23897-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0202CA0021.eurprd02.prod.outlook.com
 (2603:10a6:200:89::31) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
Received: from madeliefje.horms.nl (2001:982:7ed1:404:a2a4:c5ff:fe4c:9ce9) by AM4PR0202CA0021.eurprd02.prod.outlook.com (2603:10a6:200:89::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend Transport; Thu, 18 Nov 2021 13:08:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3fb55770-714e-4d07-e75c-08d9aa9487c7
X-MS-TrafficTypeDiagnostic: PH0PR13MB5780:
X-Microsoft-Antispam-PRVS: <PH0PR13MB5780BD11EC90DF91DAC2CAACE89B9@PH0PR13MB5780.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g3MEelB8uLXlpDI0u1C36vNovwOItPMe7fGzJEHApSx15h6P/WI04w8NxOAVjwv1IKRnW5gZMAp43vnhdg95p0qphiyzUkV4rF/JBK2fxRk3ji/+G7rrUXgP925M8jafLRJ2J9mr7cmegHPRfGCs9IQEKkqQ1UfU1MpODyhSUeAwGOyO0fDULkRwwR+h8GCqZy5nWngc7vtrvYo5YL/qmSNuVxnvr3QlZQFIp1LzcSR84hbUkxmpjLAMUfrJ+pGYrQvooh80UaXyfAXfKzXZ0+ZAUW069GOC1NTGv3DkAn6/8x8/2NzCZt27XBUWuqdsWBwKVktTAZ7h7Of5FjUGLSc5o9NSunWbZFYQ0/7SEtgzWyX6RfeLwwexvSKa7VyA26uNstgBRznYUftQBiiJ8qV/3njzshb+0mFn8ZWIT+MTgOssRfyTYs01Xp3iPHLjTMgfpYno2vXkgNxh/7OxhoSlzFsUf57RQmIpcNNEOTrDKLAFSfRxRFR40yX7xdNkq0ARUPz7b7dM4Lj75BW2jJkKDBL+nBiVG6sjzrBpcpBiaXuUbQK5Hcd77bHyogajM+dNA6nkXk99qLk7wts/zzwrB8bx1t28HR91e01k913iPH92Jmtnl0GvRd2Lc1oFtByH+XpT3C0SP0tSThtnRA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(39840400004)(346002)(396003)(366004)(376002)(136003)(316002)(66476007)(6916009)(54906003)(66946007)(52116002)(6506007)(8676002)(6486002)(66556008)(186003)(30864003)(86362001)(4326008)(15650500001)(6666004)(44832011)(6512007)(83380400001)(107886003)(38100700002)(8936002)(2616005)(508600001)(5660300002)(36756003)(1076003)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+iMO6QiLXVhlXeC2QbQZSgryoq8nr7azSMF+uW57KVZZr9dWicQdmneb+tK8?=
 =?us-ascii?Q?lSvyUfhpApqhPwpKAgwlL6r734c1mFLINXnkhDlrwKFr3QDwrp+fhPBYWE7X?=
 =?us-ascii?Q?KNxRSEuLeCs+gW0nsMdEdYyM3NlK0LH2C8FHTi4592YOWV5crs9Rrvnt53vl?=
 =?us-ascii?Q?owCzY2tUNEG7PHBgPaqzHtwwk+G5zO+gbriizDJcllDKKqJmf1kWXr04Bd0m?=
 =?us-ascii?Q?9olHKUBAeUK8OB5Dlx/m60YYBODDhSaGQBI+E/2ie8qy3PRpyIPR/qdx2cO8?=
 =?us-ascii?Q?azgDLN3kV2r3xpeAP0T/NlhqXb3BlGnXw22DiKfgDnD5i8huwsWkm2v6dz6n?=
 =?us-ascii?Q?/UkhRUDTPfYN2r/VKGJfJgBMl0mmdVzmOs/EwPeWDpyN7cOkkS3HR9jYavF1?=
 =?us-ascii?Q?k6u26Nfb4Uq9ebYjn45WNMPiu4Qpt3t1aTNJmw5CH32ufANcfSaIztwwkV1P?=
 =?us-ascii?Q?TXQwCbnNzol+5FJeIvdO6M5LFVZMnYfHCLYn2083iIyBxjQpBISo7mmjhOEO?=
 =?us-ascii?Q?ZpvTQUQt48izBDDLxn5iGdpGkQMsDAZeEN6PeRxNyxh653b3RH9Fxv3joGAU?=
 =?us-ascii?Q?8bZRG0P2ILgsOwhcFY1pqht0X+FEttXfQOiLRa/RQgB/bUvTi+/CFMRx2mTJ?=
 =?us-ascii?Q?fBvXHvSFvxugBW4P9M0SnXUsPZ62ywSvMRpEeYyRVQ9YBNrQ/fk1sI6gCtwe?=
 =?us-ascii?Q?0wOZld/SYjnJG4gk8y/8KLhUrF1dQbaD0pUIBV9y3yFWaTvd2Spd59ogSjzx?=
 =?us-ascii?Q?LjFIWItjTFpnL6/V9dSq9z07pvQW8/MIjGc9sLLah+SG5IBtxZRR39RaC26Q?=
 =?us-ascii?Q?6EyHV2Pe5JVfWA7WFjeg9elLd0/WXMp7cmxGrxNzs9AO/+o2Y4m5MaWK0ADf?=
 =?us-ascii?Q?Jpyz5RfV6nU5Y4LT7cA4GVIj+d2F3Ey7ICdoi4jP9LUZ6u2AgKsJmJ+5laM7?=
 =?us-ascii?Q?lj3xzU7xoBD7a1S7cLAoUWqtvebhymZcBfgVULKyYt4bJPselWy9a5bgiP+Q?=
 =?us-ascii?Q?KeFANSs2rdd9c/QtUVb1T80yqDFbZ1gwVyTpB7Whi8G2tyCvekz8WBSY5kTE?=
 =?us-ascii?Q?iwQnmYDR9obwXAbSUMtgL14b3S3tVUnrxPcw1U4f4EZbShVwLsTbPvn9w/Hr?=
 =?us-ascii?Q?AwxL568dB/7fK0ZbzOX713gEM2gkbs61ngMMqVCKrQx+8DsX4V5KNPRrY7Fi?=
 =?us-ascii?Q?zl2MoBbT7YEBXkA7EWaJ3IXDjmpT4b07yoMUkOxtj9Sirkswjy6ZG3UyGwZQ?=
 =?us-ascii?Q?sQZ2NKMFJHQvrk6mDPIhhh9GMhq7v8DfPIXmcjK4zn9Dar9gtq/YCUF+5HCx?=
 =?us-ascii?Q?B8/9mvjEHz98UJR0B6vKFgqqjsKsJiTW8Kmerji29oIskkQETqJOpZ32XejT?=
 =?us-ascii?Q?V/bJQaWrWXmCQnS4uqnPbNRadhv6RvLW5FiTuG2rn735m9RdUMMeV7ipDTQL?=
 =?us-ascii?Q?jQqFSNhRVHiUdcB/q5lTxjC8B4khOZnMG6LahP8V+blP47PykpZBukeMo3H5?=
 =?us-ascii?Q?kEnJv8iZDB8pavb3965A8OWKRK0B4yFJoiOApO17h7xPz0PtZBTbIeeA3TS+?=
 =?us-ascii?Q?HMvGDSxywbIUxjgXRetwwdW1l1chzXq2QtDDvk0f8GLuoP2EOMCRCdlgQh+g?=
 =?us-ascii?Q?ptoDwmx0YpGOWu+9N+49oXGN9YYdq6AAQzTqvliO576MEheIVOhhzWMW0VPP?=
 =?us-ascii?Q?D0j6xCl86Kzhjk1aS5S8LCaGd8ZAdTlz8r0BdlKE/ceroP9DcvxuLgzpyFyJ?=
 =?us-ascii?Q?upWRd+QQGysJe6AcglOSAjky3KrhXVY=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fb55770-714e-4d07-e75c-08d9aa9487c7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2021 13:08:36.2310
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XqkyPshkj9A8cmaGc5INtJt/N8J984/KtAwXshDVPu1+JBw5gXDQg9qQfVgrvGMiP268EUOZsxTCP0s1x8d9BjZBuGIIzb86ndiBj96T5/0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5780
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baowen Zheng <baowen.zheng@corigine.com>

Add reoffload process to update hw_count when driver
is inserted or removed.

When reoffloading actions, we still offload the actions
that are added independent of filters.

Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 include/net/act_api.h   |  24 +++++
 net/core/flow_offload.c |   4 +
 net/sched/act_api.c     | 213 ++++++++++++++++++++++++++++++++++++----
 3 files changed, 222 insertions(+), 19 deletions(-)

diff --git a/include/net/act_api.h b/include/net/act_api.h
index 7900598d2dd3..e5e6e58df618 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -7,6 +7,7 @@
 */
 
 #include <linux/refcount.h>
+#include <net/flow_offload.h>
 #include <net/sch_generic.h>
 #include <net/pkt_sched.h>
 #include <net/net_namespace.h>
@@ -243,11 +244,26 @@ static inline void flow_action_hw_count_set(struct tc_action *act,
 	act->in_hw_count = hw_count;
 }
 
+static inline void flow_action_hw_count_inc(struct tc_action *act,
+					    u32 hw_count)
+{
+	act->in_hw_count += hw_count;
+}
+
+static inline void flow_action_hw_count_dec(struct tc_action *act,
+					    u32 hw_count)
+{
+	act->in_hw_count = act->in_hw_count > hw_count ?
+			   act->in_hw_count - hw_count : 0;
+}
+
 void tcf_action_update_stats(struct tc_action *a, u64 bytes, u64 packets,
 			     u64 drops, bool hw);
 int tcf_action_copy_stats(struct sk_buff *, struct tc_action *, int);
 
 int tcf_action_update_hw_stats(struct tc_action *action);
+int tcf_action_reoffload_cb(flow_indr_block_bind_cb_t *cb,
+			    void *cb_priv, bool add);
 int tcf_action_check_ctrlact(int action, struct tcf_proto *tp,
 			     struct tcf_chain **handle,
 			     struct netlink_ext_ack *newchain);
@@ -259,6 +275,14 @@ DECLARE_STATIC_KEY_FALSE(tcf_frag_xmit_count);
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
index 6676431733ef..92000164ac37 100644
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
@@ -418,6 +419,8 @@ int flow_indr_dev_register(flow_indr_block_bind_cb_t *cb, void *cb_priv)
 	existing_qdiscs_register(cb, cb_priv);
 	mutex_unlock(&flow_indr_block_lock);
 
+	tcf_action_reoffload_cb(cb, cb_priv, true);
+
 	return 0;
 }
 EXPORT_SYMBOL(flow_indr_dev_register);
@@ -470,6 +473,7 @@ void flow_indr_dev_unregister(flow_indr_block_bind_cb_t *cb, void *cb_priv,
 	__flow_block_indr_cleanup(release, cb_priv, &cleanup_list);
 	mutex_unlock(&flow_indr_block_lock);
 
+	tcf_action_reoffload_cb(cb, cb_priv, false);
 	flow_block_indr_notify(&cleanup_list);
 	kfree(indr_dev);
 }
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index f5834d47a392..ada51b2df851 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -225,15 +225,11 @@ static int flow_action_init(struct flow_offload_action *fl_action,
 	return 0;
 }
 
-static int tcf_action_offload_cmd(struct flow_offload_action *fl_act,
-				  u32 *hw_count,
-				  struct netlink_ext_ack *extack)
+static int tcf_action_offload_cmd_ex(struct flow_offload_action *fl_act,
+				     u32 *hw_count)
 {
 	int err;
 
-	if (IS_ERR(fl_act))
-		return PTR_ERR(fl_act);
-
 	err = flow_indr_dev_setup_offload(NULL, NULL, TC_SETUP_ACT,
 					  fl_act, NULL, NULL);
 	if (err < 0)
@@ -245,9 +241,41 @@ static int tcf_action_offload_cmd(struct flow_offload_action *fl_act,
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
+	if (IS_ERR(fl_act))
+		return PTR_ERR(fl_act);
+
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
@@ -275,9 +303,10 @@ static int tcf_action_offload_add(struct tc_action *action,
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
@@ -290,6 +319,12 @@ static int tcf_action_offload_add(struct tc_action *action,
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
@@ -302,7 +337,7 @@ int tcf_action_update_hw_stats(struct tc_action *action)
 	if (err)
 		return err;
 
-	err = tcf_action_offload_cmd(&fl_act, NULL, NULL);
+	err = tcf_action_offload_cmd(&fl_act, NULL, NULL, NULL);
 	if (!err) {
 		preempt_disable();
 		tcf_action_stats_update(action, fl_act.stats.bytes,
@@ -321,7 +356,9 @@ int tcf_action_update_hw_stats(struct tc_action *action)
 }
 EXPORT_SYMBOL(tcf_action_update_hw_stats);
 
-static int tcf_action_offload_del(struct tc_action *action)
+static int tcf_action_offload_del_ex(struct tc_action *action,
+				     flow_indr_block_bind_cb_t *cb,
+				     void *cb_priv)
 {
 	struct flow_offload_action fl_act;
 	u32 in_hw_count = 0;
@@ -337,16 +374,25 @@ static int tcf_action_offload_del(struct tc_action *action)
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
@@ -841,6 +887,59 @@ EXPORT_SYMBOL(tcf_idrinfo_destroy);
 
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
@@ -859,18 +958,30 @@ int tcf_register_action(struct tc_action_ops *act,
 	if (ret)
 		return ret;
 
+	if (ops->id) {
+		ret = tcf_pernet_add_id_list(*ops->id);
+		if (ret)
+			goto id_err;
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
+	tcf_pernet_del_id_list(*ops->id);
+id_err:
+	unregister_pernet_subsys(ops);
+	return ret;
 }
 EXPORT_SYMBOL(tcf_register_action);
 
@@ -889,12 +1000,76 @@ int tcf_unregister_action(struct tc_action_ops *act,
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
+				    !tc_act_in_hw(p)) {
+					ret = tcf_idr_release_unsafe(p);
+					if (ret == ACT_P_DELETED)
+						module_put(p->ops->owner);
+				}
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
 /* lookup by name */
 static struct tc_action_ops *tc_lookup_action_n(char *kind)
 {
-- 
2.20.1

