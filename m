Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9CF5467756
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 13:25:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244687AbhLCM2u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 07:28:50 -0500
Received: from mail-mw2nam10on2113.outbound.protection.outlook.com ([40.107.94.113]:9754
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244538AbhLCM2u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Dec 2021 07:28:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=avHOtRwzPPoQRWAwxoi9V6XgVJ+SRIjUg6Vi4K+iLq+oDy2a88Hkz+Q32HTo6ftM2Nxl7ZfHCwzqLufb0uqiT6vZy3h9Oim2lRVBLO5nOBRV/jDEqblg1p1enpmJ+ew3aWsciOHDPQI2GRTCJJG3Z5ljoVZtqwswnuCvWkE4gEA9EzC+mIHStMmkeqcArQ67l8tKos6tnl4bCcVoZD8ZxS3Bw9Fkq9Z7wuLrgtDYo1L1PJNcLfzOM1f98ox+mGIeaa2+AXtC6mDGctZaVPVcZ7jRzR5v3kLHkbLObdaXpxVn1qCfP1bO29cvFAJwlAdJB7otNLzbyFNFQ2zlOz4iNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LGg9bi+IKJ99qOlGxEQbQgloJRsSsZ3+7gSZrBfAdMM=;
 b=TzT+39/O/3xi3/xsG2aDwGYYpCvzkwwHuiqy0pSmsPr3ec1lwvr9+T69PW7c7S0tBvjcT6R8YModKK3VVFka5J2jfU93SoMTnMFx8K300/exRemgG/2Jzaf76jK/MLVD0FwspMPPipQhmoamJbd/orDuOzMAZizMdhBM/E7NSuXIcRNFzSW5fsBRXOyBnrmhTc5skZjXoru6RKPay1r9YuTPymjPsmfP/Ilq12m0g/2k+cAAfANfoAjrc3+jD3FsUKZFttBzPyh6b92rIxm5zvKpezGTobdRSzHlMlMIeBec+HSRFcRZmSzx4vzISO4fuH2rqNW2OgbMDKv1zFEmow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LGg9bi+IKJ99qOlGxEQbQgloJRsSsZ3+7gSZrBfAdMM=;
 b=VvtUlBsa56zsWjBokofBtJZtmtswTjg6ZL4OU9cpsb9bShjQoVWztLS+payXLkklQ8LpTia7mCJujYUl5J7PGEk14Rln9AHXX+QsJBPrwfo3uJKSxsaRECB3Bo7lykoldYYHhqIGuloZd1RnM/KdvEfvcNOTBonITH9BwbwiKcQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5423.namprd13.prod.outlook.com (2603:10b6:510:12a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.7; Fri, 3 Dec
 2021 12:25:25 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c%9]) with mapi id 15.20.4755.015; Fri, 3 Dec 2021
 12:25:25 +0000
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
Subject: [PATCH v5 net-next 10/12] flow_offload: add reoffload process to update hw_count
Date:   Fri,  3 Dec 2021 13:24:42 +0100
Message-Id: <20211203122444.11756-11-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211203122444.11756-1-simon.horman@corigine.com>
References: <20211203122444.11756-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR03CA0059.eurprd03.prod.outlook.com
 (2603:10a6:207:5::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
Received: from madeliefje.horms.nl (2001:982:7ed1:403:201:8eff:fe22:8fea) by AM3PR03CA0059.eurprd03.prod.outlook.com (2603:10a6:207:5::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11 via Frontend Transport; Fri, 3 Dec 2021 12:25:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 75ff977e-c589-4452-dfe8-08d9b657fb8f
X-MS-TrafficTypeDiagnostic: PH0PR13MB5423:EE_
X-Microsoft-Antispam-PRVS: <PH0PR13MB5423CC3B4B31E17EEC3099DEE86A9@PH0PR13MB5423.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +ufPpXjqJPsCkbPTZryqIIN6AFV1pujljPphgUurYTsop8HRKM0MrTh+a7GgEzVgjlUDja3yeaA2pvkinMemzfxaBIiYsbnVuoopFU+r0vJlOQfMrkH2Yvawu/98U0bFDbtwiboSJTrNXykfHnchXmqABTI+L8GMfWe0wXQ4bxAN3qLqztdIwHdrZMsCktFZ/R7XnQZSLNF2dN1VjbBaqI1hHCYSSKsUUp5DLVUWQCvOllPrbT61tCa1JonGJzFsS5hxdFOQQLxRdE+LfNUcpNTqDyPk9pMyV2izKQJq5ZgyNhEDN0EaFNLFza6LNDYSnAay7PEgtGrPqocX7dywqNumcTDskknZASpjZ1Tr5Ei9pcaj9dspEPBGHluLucMdaO7bAqU6WPGGlLf12OVq0sGdfwBKLdTv/Zgxl84SOo7SIH4Hb3FrXZVkD026CV00xdQ1vX71ZOtjcknH+KaqbQVpst6yJJiLGKp8N06hWtvbty6esN+ZQ6c3qLR0TqWOe1L0BN0wE78oCcpyy/iByiIK9ZgCnwr74ok8XT8vgx4C9v19swWxskM9hsBSesotZKyFLCjoXocGTEC/lL6HNHtYUjamYqvCu5mcViks4wpnM4j4mN9jDp9zvP9Eg/o1je7mvwuwNa8i9atTPRTNjw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(39840400004)(366004)(346002)(376002)(396003)(136003)(6666004)(8936002)(38100700002)(2616005)(30864003)(6506007)(4326008)(66946007)(66556008)(15650500001)(8676002)(36756003)(186003)(316002)(1076003)(44832011)(6486002)(508600001)(66476007)(5660300002)(107886003)(54906003)(52116002)(86362001)(83380400001)(6916009)(6512007)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CeHgHQ6clOASSpCcs9VE845vSXkkZxmUoYyRxzoKNsV5+wQ+V6WxWPWtQQr3?=
 =?us-ascii?Q?dEtFKu8FLHNif7HQE5Ce4tm8RHcdmdjP5AXkADdlb+bbrE+l2jkXvGDtK3ck?=
 =?us-ascii?Q?TlhejF3wBXNLvlf2EEjuBu7nNU8DI4KksOCbxf5RaiBramCxtBvkJL5f5yNQ?=
 =?us-ascii?Q?Rqc3m0UwxPxMhsny1c7TLkDWtxw5mMgJzWL0+lfMfnMDwAVKBwsU10Mel/cK?=
 =?us-ascii?Q?Fc8MpQg2bi7C/QRNk4spMjMjXFoghk/ra6kVKAE/Fnkq3y2z8fTPp/FqA9xw?=
 =?us-ascii?Q?E+EtkV8IJ+SEurZc9rtAYuikJsZtf0EenhSiYc3QEpanwbHnToLJUi6IqI8j?=
 =?us-ascii?Q?5Z4Viyi187/BXVHNk6nVnd8LJi+C9livB+ZD3H/s9oSWL9PYlFNFVTOzSGoV?=
 =?us-ascii?Q?JPTKCodJxcGxEa4iwA9iOOTvMBEgi/JKfBbH+abMF0s8fyLR22DaAfF/5TmJ?=
 =?us-ascii?Q?6HiM1cUKnZy5MmkMiv+B0cNFaVq8Vnq5Wepw9kU7jT3qiNLyh4n2tVOs8n7k?=
 =?us-ascii?Q?wzZF269Bzw3sC2+Ei29QUoU0R7EbXFILMobaCAfDz0PnN1VM2gWABz3cQi7t?=
 =?us-ascii?Q?bBK/o0pTt1eJbhii/EMSUHDLuIIm1nADqvPw/kHQtUBkSeEdm8roqRQhTx13?=
 =?us-ascii?Q?/Ww7bH3aYeGc/B4zND8bhAe1mo21cj1IQlEdxoiWE4zJiO0QnTHWcIFplnBC?=
 =?us-ascii?Q?vsJuifUZETIh58HX9dCahv+6LmVPb0ctHqzPMQ0cbZkT/KsQJjdFZSF7UiGT?=
 =?us-ascii?Q?j8kLaQR/Z+ihDx9D4mZpSvl05O8a1PfyB8okEFIVwgjSblZBtvBp2u0YxWQd?=
 =?us-ascii?Q?OTg3dQqPLRM2yvoR8hCR7n1M3oj/NAt+NHOOq+gq6Hqf6KXhPrh67LwGdgFE?=
 =?us-ascii?Q?FcKq+0RSp2LFat6RIad8goYw9ZFRCsd/h99DdTKQz64ICgP3FTAzZwG+pB/v?=
 =?us-ascii?Q?cXuCcrye/jr/U6oO9s7fgbsPdrKRRiRnCi0r024p6YIbK2rBFxSOOpw6qzY8?=
 =?us-ascii?Q?3052/L4QPfRoQx6mY1OGwcVuAV7fdUOic4FzEcFazjW9krjKhCIGeg45kL8a?=
 =?us-ascii?Q?PJL19F+Fd2jfgizBjai2/Bft4h3OxGhXj6jBUv9PN5lRF+L9fi7n90KaYpWN?=
 =?us-ascii?Q?BN+iRNPUA7JvUBtNxZd4VI0yM2VDCLfs3tOEdOM78bvI7GG5qnoU+09xFJMv?=
 =?us-ascii?Q?yGi5SNcFnVLjlXYbLe6VK3e1fR566X7Nt6OkA+riMw/onzH3r0hJqMENLtqu?=
 =?us-ascii?Q?NW14UqvBtGa3kGOd2kZTe5esex3X70PZV3+3dX91Z1u/LI+zAh/WL4Ir2wA5?=
 =?us-ascii?Q?vHkomCuqcSwzf5bzm/QMJwnKphtDE/PLP9lymZtTUDWgJ4Hqdrm5ta41fjMe?=
 =?us-ascii?Q?qm14SeM2qNRL1GGCCj3ujRFMsxHOt/+RZQpn3zvymmE1vXyhETGG/7rsLQsL?=
 =?us-ascii?Q?RCrTCTa3QBeXn2rFKyS2/6Ap46OklQJmDYgyTWGXp67os42cXt1J8Ksr9bTF?=
 =?us-ascii?Q?ZX8GaAUPwyu3PVIujuxDn8WT4ETGzCM8XF9M+7MaNuhEy6EiLXLXFRqkdBr8?=
 =?us-ascii?Q?4xA3QwirxkLA9yE622tLAQCxLzmRGam9jLXT/R2mXoZFyELDFi5s7RWSVqGd?=
 =?us-ascii?Q?uE0S/yuuVKl6Go/r7N/IWgB5I5dr8LvqOrildR7ducfM8qCzhwv3M/2x7z0J?=
 =?us-ascii?Q?JOL8AJ4E9COCHoLuC32Umr0JdJVaUnI+HpnoJ3jFTQAmzoY+73vABQe/c/Sf?=
 =?us-ascii?Q?gKZQPTdalyXnKj3BREkfrIZYybDqWkc=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75ff977e-c589-4452-dfe8-08d9b657fb8f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2021 12:25:25.0298
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: he/+YfZkRSX+tp7Iz+ChBqmq/s6b1l9FPiBUoDnGoztqaSqdSK249632I/grjt5oz7BKxUdgNQwtxmG0NJsT9EMf3CALyK5dugvxD0j+tEk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5423
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
 net/sched/act_api.c     | 249 +++++++++++++++++++++++++++++++++++++---
 3 files changed, 248 insertions(+), 16 deletions(-)

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
index e11a73b5934c..ec80b5411a62 100644
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
@@ -811,18 +923,30 @@ int tcf_register_action(struct tc_action_ops *act,
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
+	tcf_pernet_del_id_list(*ops->id);
+err_id:
+	unregister_pernet_subsys(ops);
+	return ret;
 }
 EXPORT_SYMBOL(tcf_register_action);
 
@@ -841,8 +965,11 @@ int tcf_unregister_action(struct tc_action_ops *act,
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
@@ -1594,6 +1721,96 @@ static int tcf_action_delete(struct net *net, struct tc_action *actions[])
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

