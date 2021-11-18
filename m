Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4013455C52
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 14:09:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229461AbhKRNLl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 08:11:41 -0500
Received: from mail-dm6nam12on2124.outbound.protection.outlook.com ([40.107.243.124]:6945
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229887AbhKRNLc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 08:11:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UBf77JcQyOQyZUM3uft2Zs4Sqp7xZn3zE7PhXp7w2Taq2Q6iEHDIsVNF41Ix5bFJvdwYUWzUONOTtb0uo1nhyIZuKkg4AjNL7AX10oRm1cgXXt98pMddpsPEYvK47eqtY1g/ABzQ1rD7MiNWAGcYmbxFJgaMED2NC1pPRaL2XUZCoAqJ18vNxXeqb7OVC1UzGs52QK78nrZlJmU2qfWqK3AaJPAurdDCn+PTAHmOAt1vDMjmYVPf3lYh5VQJ4VYUgzjVhgW+EOvxOU3cFbaiUuyQguS7sopzGXZeqihCnOBkKp3NRDMsiMtegP0KZ8qJyqt2yxVXDqHqBclRnmijJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mgjvcmGQ7V1WPR1zmAfeMLysgmMkCqXP7JmmdCTKJIs=;
 b=fAzzimUB/bTI+/ijOr9+BLGY3xEyMLi6l454IsagX4fHIhsDnRlaQG5NZnJVsAvD78VZqsSE7r1OWHvNIKuN6bvy1ozGMY3mqFybUbxi5nAm3nC6aohS4Cg8/pgybU6kRFOKTX1YfxP3SArjBYw3cTVlK60hYx66yEz0+wkSZlc7IBp2SukYWkraMrccsOVo0ZXcHWFWMt36CDJFW3pfxAwGkeFSBeCguDWQxW4iQgGMauhnmqqRpBZssJo1UIgxnpkT8y+K5ZmieXyW/bTKH2TR5ahZCbRx8/8Q9yUbTAF2CkYec8Rsh6BczvuMaJi6Nv6jC1k5+I9FMf25iJuKeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mgjvcmGQ7V1WPR1zmAfeMLysgmMkCqXP7JmmdCTKJIs=;
 b=cYpFJQugzlkHxk0TUlw5aQIoBcJc2CtqgRAXxtyz5PGHiMPuXzQ+9OOj5pgTMVNsvQey7uff2IJq/RXhl1jIgBFgUfJs7s4YTe7o5l0GfwHUiN/CkWX6Ao0Fl6PC0BCSuBGFV3Mhlo6J5Qop+3jKNepzpUw3HFicWwRaz9aiPLw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5422.namprd13.prod.outlook.com (2603:10b6:510:128::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.10; Thu, 18 Nov
 2021 13:08:26 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::3152:9426:f3b1:6fd7]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::3152:9426:f3b1:6fd7%7]) with mapi id 15.20.4713.016; Thu, 18 Nov 2021
 13:08:26 +0000
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
Subject: [PATCH v4 04/10] flow_offload: allow user to offload tc action to net device
Date:   Thu, 18 Nov 2021 14:07:59 +0100
Message-Id: <20211118130805.23897-5-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211118130805.23897-1-simon.horman@corigine.com>
References: <20211118130805.23897-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0202CA0021.eurprd02.prod.outlook.com
 (2603:10a6:200:89::31) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
Received: from madeliefje.horms.nl (2001:982:7ed1:404:a2a4:c5ff:fe4c:9ce9) by AM4PR0202CA0021.eurprd02.prod.outlook.com (2603:10a6:200:89::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend Transport; Thu, 18 Nov 2021 13:08:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 81ccfb55-9384-40f6-59a0-08d9aa948218
X-MS-TrafficTypeDiagnostic: PH0PR13MB5422:
X-Microsoft-Antispam-PRVS: <PH0PR13MB54225F33CD1F800CA75D2EEEE89B9@PH0PR13MB5422.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:565;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tFsPPFYMDUX1vfElZTsmKf8Z0+UE0/289WJ/byq263vKL+xhRhODQPmT+CuMnwLb5AC1GqmgyXsfh0RiYvpn88+OnOHe9KDCSRbIO6C1MhVZaKHHFG08bz8opXxer0Jk0Lsn0u4sLQxBYVdhDKqCnmDg8FUohb0llnmiG/BoQMuO7DIJHeg9EuxK7xno6Zoc37B5SWCuA/aYU0JU75xvFoM/wxujPfvE/97gFvput50Eqsu9SRsk8xowWGqhg0ne3pdg915V2nkHubHmIpvKi0d55Y4kkqs7emipoyBcKH2lhNgWDkhQcTRxehs55K3wVCjZ4oXK4ri2HCSClyg8Q+m/TOfXeGAgWWot0oPlVK0WZ2wZiRE71FLBiY6pz1u34sOwCuoy7/6S8KWhsbf62fiJa6EENwN/hILFKEfp01i2zGO5NGL1GZ6m1E+vVQjT4OBwHn9qvrWAJI+kuvLhLwJLP1fXXsnhEJ0rld0I2FwZ2c56CDu/haIBFSLfB4c3mnvs8YxmNF+jhSctbKX4He2iYcQyJH2upzrbjA41guWvy2nlYIOzQd4c4UxyT3DAFNVOHmEiv6BGKPr8K3E8bH+KCATPy8cVD8zQVh/Ye3dW2HwB4xtBdINS3S88DGcKA+tukNoHfIMDicgWlI2B1g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(39830400003)(136003)(376002)(346002)(6486002)(2906002)(54906003)(6666004)(316002)(30864003)(86362001)(52116002)(6506007)(1076003)(38100700002)(186003)(6916009)(107886003)(2616005)(44832011)(5660300002)(4326008)(8676002)(508600001)(66946007)(8936002)(36756003)(83380400001)(6512007)(66556008)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?o98FOawFHbQ1JbBbVnA+8Jy+ZhQZcM2AMwTtB92k7+x0Hu6HuWzQJd3iWS2e?=
 =?us-ascii?Q?eWPvtQ63QDKGCsgFUpLrHvbmFCm4HcAtQSfbQYPqV2JWG9kTsXlDSFwqR0/J?=
 =?us-ascii?Q?OseWT77pV3M7WEQSBtKTm2XTTYDrP6/3cqT6creE/tJ8GtINApXtHNHsAhiB?=
 =?us-ascii?Q?r+C76KKwKZJFAw74GXxPKINSimGviAjhcP4NP5YA+tVEaSrpZXLV0Xcg497h?=
 =?us-ascii?Q?fR7InyCQDLN4oFsQIBlXzGafYmGUf3TfJCwQQ+SCNTKMdHTMPB3OGADi38jZ?=
 =?us-ascii?Q?4AJqXJCtqk2i8Pjm55mXBp3eiC4TvnMrokV87kBUdHjWHodTAKrOid8Pwf+3?=
 =?us-ascii?Q?0d3hclw8guV3ZVe1ION5EzxhuDNN1+gbtc4XU8KzAPg+aQNOnJDHLj24N8xw?=
 =?us-ascii?Q?Uw6FnlV+WIbdciU5ppEndPdlCfyz/LDIwBcBHrDyupj9+rp2fMFqpHAFLpCj?=
 =?us-ascii?Q?DG9CmW23dAjmnNFh9t5x9JNLrfCvVpAMzPJR1rDxR6YnICamojTqHVUTkW/d?=
 =?us-ascii?Q?PqPwMBAxGY7lFsTpiq1uOKrX9w8CZPRE+yO9l8jazYk07GpctxMlFIFheFyr?=
 =?us-ascii?Q?AFAoIMwgBfHO2tFKW1QX3DTg0WgA2+ccrKUJ8wV0TKgSkR72hPz5CAgX/ri8?=
 =?us-ascii?Q?OTxdjX662Rwox7ZGQfzG44bqrZ2dIWroGMEZIES17ZficuPxymWHTjQMPQkH?=
 =?us-ascii?Q?AVUwZP8yMgwFMYV4C1r9iIhM2iT7QJj8RttuaoR17xFZ3qyYAzaVs9SMjFE5?=
 =?us-ascii?Q?vDo7IkZ2Qzz90kAGOB0dWlC+srdviuLAPakDU9vem094vwY5LPAvMuivBruc?=
 =?us-ascii?Q?JbtxfHwrxsSob4YVmYbEMFdBLPB8qougMvzbfUQ4XrIUqqqgmXGuyltvREHb?=
 =?us-ascii?Q?LUoyiH1qQ94CCp10tYkGBMSlBa3/yWPTrQTPooyMEbsd7NNletDkaWZz+A/P?=
 =?us-ascii?Q?WJImq40gnQjuIytSmWpXv4Q1gjGjqilS8UHZys43LCzInnLjoQ8R8nwlgsnD?=
 =?us-ascii?Q?tcfkNDdX9StiZh6aN+DpsOQ8AIlwPP8wKqWNkuErCKQdivYc1yBtFJ3AswEP?=
 =?us-ascii?Q?BD9du79Zskp1ix2mt7EmxWhbgfAhKJAb/dk/MuzOM/+IONrx2qXcrOIVE7xZ?=
 =?us-ascii?Q?kBjD8gxYuBp/NVINNC3BTYZZrrrLc/yvcUCbJtfSM9IGau1+oWII22QX+a0O?=
 =?us-ascii?Q?xf+zwI+SvV2sSTbyD3PoGFwkK5sNfxGdHAQfa5W8dU8rcnRvmkPhuHpsUTGq?=
 =?us-ascii?Q?4R9ug0k/8kwepRPWTQnO02AVjYRRxewky9G58F6A8oEvhAYeGtLUdIxifn+M?=
 =?us-ascii?Q?eMFHAbRnwYokOq5dU43uCdr53hByZsbrmCtmdfJ//Ox3EHpTUMkKX7Wx0QqL?=
 =?us-ascii?Q?BHfhFpGzNZLUUPUFkldkjsqYuchEGxUYxmLYN5HBQd4yhBIVef/VhI+SAtFp?=
 =?us-ascii?Q?q1ACIVDogt3zHWoLZ5rWOknXNqne3BvN/bMIQXgEnd8e0iLXgHYyjGiU5xzf?=
 =?us-ascii?Q?UtQ1EQkzzXfoeKBFTLmv+IeRXZ/evIzKrJX/6U5FgSznlQT15AhsY2aRMxqA?=
 =?us-ascii?Q?6RZ79nu4XTxGRcQKkhNtpK8176TKUNW3NdDj2/eCkUE6QfDibdLlmHue4lDh?=
 =?us-ascii?Q?ZcFXIPlO3pxaCFerB/4GTBQBg6hLLT/eKpJN4oTKMdeBTN+ylFJgp0zM8qoa?=
 =?us-ascii?Q?wpeW4IILMiTi/Qbp+SulyW2MTv0SWZLwPeHpZvR8b4kM8pu1/ZX2pCHkhbNe?=
 =?us-ascii?Q?RriK6zJqJxQBoXYKhH3Ue2tgD3HES0I=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81ccfb55-9384-40f6-59a0-08d9aa948218
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2021 13:08:26.5475
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hevctfop+UP0Ff5zk+76xMEHLxvOpoh7IjkPxL866Mw/XMaGyZAbqKMC/u00vmcBWfsWQqjUAp6Kd2oI9Htfkklo5JiytpOrUDVat5hjc3o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5422
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
 include/linux/netdevice.h  |   1 +
 include/net/flow_offload.h |  17 ++++
 include/net/pkt_cls.h      |  12 +++
 net/core/flow_offload.c    |  43 ++++++++--
 net/sched/act_api.c        | 164 +++++++++++++++++++++++++++++++++++++
 net/sched/cls_api.c        |  31 ++++++-
 6 files changed, 256 insertions(+), 12 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 4f4a299e92de..ae189fcff3c6 100644
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
index 193f88ebf629..14d098a887d0 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -258,6 +258,14 @@ static inline void tcf_exts_put_net(struct tcf_exts *exts)
 	for (; 0; (void)(i), (void)(a), (void)(exts))
 #endif
 
+#define tcf_act_for_each_action(i, a, actions) \
+	for (i = 0; i < TCA_ACT_MAX_PRIO && ((a) = actions[i]); i++)
+
+static inline bool tc_act_bind(u32 flags)
+{
+	return !!(flags & TCA_ACT_FLAGS_BIND);
+}
+
 static inline void
 tcf_exts_stats_update(const struct tcf_exts *exts,
 		      u64 bytes, u64 packets, u64 drops, u64 lastuse,
@@ -534,6 +542,9 @@ tcf_match_indev(struct sk_buff *skb, int ifindex)
 
 int tc_setup_flow_action(struct flow_action *flow_action,
 			 const struct tcf_exts *exts);
+
+int tc_setup_action(struct flow_action *flow_action,
+		    struct tc_action *actions[]);
 void tc_cleanup_flow_action(struct flow_action *flow_action);
 
 int tc_setup_cb_call(struct tcf_block *block, enum tc_setup_type type,
@@ -554,6 +565,7 @@ int tc_setup_cb_reoffload(struct tcf_block *block, struct tcf_proto *tp,
 			  enum tc_setup_type type, void *type_data,
 			  void *cb_priv, u32 *flags, unsigned int *in_hw_count);
 unsigned int tcf_exts_num_actions(struct tcf_exts *exts);
+unsigned int tcf_act_num_actions_single(struct tc_action *act);
 
 #ifdef CONFIG_NET_CLS_ACT
 int tcf_qevent_init(struct tcf_qevent *qe, struct Qdisc *sch,
diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index 6beaea13564a..6676431733ef 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -27,6 +27,27 @@ struct flow_rule *flow_rule_alloc(unsigned int num_actions)
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
+EXPORT_SYMBOL(flow_action_alloc);
+
 #define FLOW_DISSECTOR_MATCH(__rule, __type, __out)				\
 	const struct flow_match *__m = &(__rule)->match;			\
 	struct flow_dissector *__d = (__m)->dissector;				\
@@ -549,19 +570,25 @@ int flow_indr_dev_setup_offload(struct net_device *dev,	struct Qdisc *sch,
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
index 3258da3d5bed..c3d08b710661 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -21,6 +21,19 @@
 #include <net/pkt_cls.h>
 #include <net/act_api.h>
 #include <net/netlink.h>
+#include <net/tc_act/tc_pedit.h>
+#include <net/tc_act/tc_mirred.h>
+#include <net/tc_act/tc_vlan.h>
+#include <net/tc_act/tc_tunnel_key.h>
+#include <net/tc_act/tc_csum.h>
+#include <net/tc_act/tc_gact.h>
+#include <net/tc_act/tc_police.h>
+#include <net/tc_act/tc_sample.h>
+#include <net/tc_act/tc_skbedit.h>
+#include <net/tc_act/tc_ct.h>
+#include <net/tc_act/tc_mpls.h>
+#include <net/tc_act/tc_gate.h>
+#include <net/flow_offload.h>
 
 #ifdef CONFIG_INET
 DEFINE_STATIC_KEY_FALSE(tcf_frag_xmit_count);
@@ -129,8 +142,157 @@ static void free_tcf(struct tc_action *p)
 	kfree(p);
 }
 
+static int flow_action_init(struct flow_offload_action *fl_action,
+			    struct tc_action *act,
+			    enum flow_act_command cmd,
+			    struct netlink_ext_ack *extack)
+{
+	if (!fl_action)
+		return -EINVAL;
+
+	fl_action->extack = extack;
+	fl_action->command = cmd;
+	fl_action->index = act->tcfa_index;
+
+	if (is_tcf_gact_ok(act)) {
+		fl_action->id = FLOW_ACTION_ACCEPT;
+	} else if (is_tcf_gact_shot(act)) {
+		fl_action->id = FLOW_ACTION_DROP;
+	} else if (is_tcf_gact_trap(act)) {
+		fl_action->id = FLOW_ACTION_TRAP;
+	} else if (is_tcf_gact_goto_chain(act)) {
+		fl_action->id = FLOW_ACTION_GOTO;
+	} else if (is_tcf_mirred_egress_redirect(act)) {
+		fl_action->id = FLOW_ACTION_REDIRECT;
+	} else if (is_tcf_mirred_egress_mirror(act)) {
+		fl_action->id = FLOW_ACTION_MIRRED;
+	} else if (is_tcf_mirred_ingress_redirect(act)) {
+		fl_action->id = FLOW_ACTION_REDIRECT_INGRESS;
+	} else if (is_tcf_mirred_ingress_mirror(act)) {
+		fl_action->id = FLOW_ACTION_MIRRED_INGRESS;
+	} else if (is_tcf_vlan(act)) {
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
+	} else if (is_tcf_tunnel_set(act)) {
+		fl_action->id = FLOW_ACTION_TUNNEL_ENCAP;
+	} else if (is_tcf_tunnel_release(act)) {
+		fl_action->id = FLOW_ACTION_TUNNEL_DECAP;
+	} else if (is_tcf_csum(act)) {
+		fl_action->id = FLOW_ACTION_CSUM;
+	} else if (is_tcf_skbedit_mark(act)) {
+		fl_action->id = FLOW_ACTION_MARK;
+	} else if (is_tcf_sample(act)) {
+		fl_action->id = FLOW_ACTION_SAMPLE;
+	} else if (is_tcf_police(act)) {
+		fl_action->id = FLOW_ACTION_POLICE;
+	} else if (is_tcf_ct(act)) {
+		fl_action->id = FLOW_ACTION_CT;
+	} else if (is_tcf_mpls(act)) {
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
+	} else if (is_tcf_skbedit_ptype(act)) {
+		fl_action->id = FLOW_ACTION_PTYPE;
+	} else if (is_tcf_skbedit_priority(act)) {
+		fl_action->id = FLOW_ACTION_PRIORITY;
+	} else if (is_tcf_gate(act)) {
+		fl_action->id = FLOW_ACTION_GATE;
+	} else {
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+static int tcf_action_offload_cmd(struct flow_offload_action *fl_act,
+				  struct netlink_ext_ack *extack)
+{
+	int err;
+
+	if (IS_ERR(fl_act))
+		return PTR_ERR(fl_act);
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
+	struct flow_offload_action fl_act;
+	int err = 0;
+
+	if (!action)
+		return -EINVAL;
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
 
@@ -1103,6 +1265,8 @@ int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
 		sz += tcf_action_fill_size(act);
 		/* Start from index 0 */
 		actions[i - 1] = act;
+		if (!tc_act_bind(flags))
+			tcf_action_offload_add(act, extack);
 	}
 
 	/* We have to commit them all together, because if any error happened in
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index d9d6ff0bf361..55fa48999d43 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3544,8 +3544,8 @@ static enum flow_action_hw_stats tc_act_hw_stats(u8 hw_stats)
 	return hw_stats;
 }
 
-int tc_setup_flow_action(struct flow_action *flow_action,
-			 const struct tcf_exts *exts)
+int tc_setup_action(struct flow_action *flow_action,
+		    struct tc_action *actions[])
 {
 	struct tc_action *act;
 	int i, j, k, err = 0;
@@ -3554,11 +3554,11 @@ int tc_setup_flow_action(struct flow_action *flow_action,
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
@@ -3724,6 +3724,20 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 	spin_unlock_bh(&act->tcfa_lock);
 	goto err_out;
 }
+EXPORT_SYMBOL(tc_setup_action);
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
@@ -3742,6 +3756,15 @@ unsigned int tcf_exts_num_actions(struct tcf_exts *exts)
 }
 EXPORT_SYMBOL(tcf_exts_num_actions);
 
+unsigned int tcf_act_num_actions_single(struct tc_action *act)
+{
+	if (is_tcf_pedit(act))
+		return tcf_pedit_nkeys(act);
+	else
+		return 1;
+}
+EXPORT_SYMBOL(tcf_act_num_actions_single);
+
 #ifdef CONFIG_NET_CLS_ACT
 static int tcf_qevent_parse_block_index(struct nlattr *block_index_attr,
 					u32 *p_block_index,
-- 
2.20.1

