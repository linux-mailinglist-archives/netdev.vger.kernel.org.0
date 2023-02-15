Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CFE569871A
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 22:11:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbjBOVLU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 16:11:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjBOVKw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 16:10:52 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2060.outbound.protection.outlook.com [40.107.92.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E11E16337
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 13:10:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bdT852VTY0N3NhDn71RUhykn6y7Q/crZuDTYjXKUnhdAVflJi0zCejoQncBLtlNZ/3Dd7t1Hk1tOwBuO6nfAlL+bOLUveOylQzENoeIL/BscbdPpJguhc53bXuAU7u8uGp9dIfPoAu2W3GG4M1QtEyqkCqI9EzZ+aMulP2+6sB9HqdgVJ+g0/g5QmPeE7+GK4o1Gilmm7oYMgfBEwil38Rj4heb046LicuqXiNqCO7wnOtpFwJX6dnXdPJ5VsRgJpaoeIhULk3n7Em+UB1FqPF4qY90GzdPWPz69l2QnHSxjP9vxTeT3Wf0uBtEG3QsKgt+PEILiCT7Hh1IIVt9H3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RHRBMEpDDOacBaSaME6YO0dsCl8Ro1arPDUxO94QCt4=;
 b=nsUKeH1F+6WPvJ3ePhA63bbi7ugQyTGj55EBFQsHiyxKdaYuv/rtmPIuZ/u5II11aHlk4EQso72eDnKBAa9m+IyJjLHuUy9qYRabiJN6DtoojuxvH49PNZp5Ls6Ui0Z9xzOlCa/l8q2kHt40egobnxuXIDvySiQ9GjywpDwEwQL7Vpp2jrqZgccE0sYrT7gF1cm3oYBOVeB9FtcOAbFAhybWkcmDOTgziKFWtrdBHRtbQ2bzbVm5oJCFYH8R7y175ylz5X5bRY1iH2QK02LM8c6TjD+K7ZC9zVJAXiO+qMM0u9/i3OAv0TdNDnqPXlYVdW0P2FUvmuGC9t7fEh362A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RHRBMEpDDOacBaSaME6YO0dsCl8Ro1arPDUxO94QCt4=;
 b=RWhD022K7Vau2LxOcaRc8hThAtqRINQTNJ56CjFYWIyIM+EGLAsQG6r0tuGnlGTtMgrZmiOSc7u2j2Bdnsb/+0JE8gSGLTQvsltRDQhOMJIPQDKFeSnzZX+5rNvKow7SKKvY9AFHN/ZcKaioc/o8qAkihEZ+OzBjer9Lkupc1Yp09RuWG+x+HgB2N2WZLhbNUgxOSMMA5Kn5Qp0OzfUB4jeiUzhHfSv5PI/6q4PsQb6eLE/Fw7/rIiwTxKFIW+RHO1Pv7aSGnfyNoGuh2ROIE4lK7TqWJAMVBxAUcZ3Zt62y8t5+akiChmrCF6pvYiiXpvgD5mx9Ctwgk4eGid54fA==
Received: from BN7PR02CA0033.namprd02.prod.outlook.com (2603:10b6:408:20::46)
 by PH7PR12MB6977.namprd12.prod.outlook.com (2603:10b6:510:1b7::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.12; Wed, 15 Feb
 2023 21:10:44 +0000
Received: from BN8NAM11FT077.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:20:cafe::a4) by BN7PR02CA0033.outlook.office365.com
 (2603:10b6:408:20::46) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26 via Frontend
 Transport; Wed, 15 Feb 2023 21:10:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT077.mail.protection.outlook.com (10.13.177.232) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6111.12 via Frontend Transport; Wed, 15 Feb 2023 21:10:44 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 15 Feb
 2023 13:10:29 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 15 Feb
 2023 13:10:28 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.7) with Microsoft SMTP Server id 15.2.986.36 via
 Frontend Transport; Wed, 15 Feb 2023 13:10:25 -0800
From:   Paul Blakey <paulb@nvidia.com>
To:     Paul Blakey <paulb@nvidia.com>, <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
CC:     Oz Shlomo <ozsh@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next v12 2/8] net/sched: cls_api: Support hardware miss to tc action
Date:   Wed, 15 Feb 2023 23:10:08 +0200
Message-ID: <20230215211014.6485-3-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230215211014.6485-1-paulb@nvidia.com>
References: <20230215211014.6485-1-paulb@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT077:EE_|PH7PR12MB6977:EE_
X-MS-Office365-Filtering-Correlation-Id: 70fd50a4-3b01-43f6-8ead-08db0f991a20
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 766weuOv8iPSxxhTxYkJA5ByvfDwQAn5gW7XEqleM/7n8GonwMcqk/lYGY2PgL1X07I/U1lxHYzqfxX6vtox2HsDWPuSWFlVfkpWR3+5okaEm0XcCn/VMvevZA8Eh2bVh32FoSvWM5EpnEjuoeF53AaQkbesItNQ3H1ZQKmsscOjaqCLkMxOSNoqKk+WIQ4zUkNGbjsgE/mnyeFnKrZi36Ii0aX24sz8AxvNjdc3kL5LKCig2sr34/QUO1/AYhrcFQaBqXb1IXI6DrPuxZispg0T6v5zEN7Ra0P+V7Ji6EGKebj8RZTtMgm0Yl00pddGdN1jCpRdmhN4zbdWCBvmD86A6EUh4Oq7rbSSnV2OaimY+vw+XjQ+gsROo8YpT6ixezBPCiFX1s1IytQv3ESExTCSlimhUxvzpgLs6NngfB+0aCRHcSiILF39YO8n8aLtCu4EMXlvHZTK4A5mokzg5cGbx/022V90SPfM0kRl7/0mKIsEWzkCPfMjS1Y3wJ+MUppj4A3HWxJTTbycy/Af36TWuN94JkJI0ZYbN2uzazRc2aIl9T/t2HU3Io703J8bXCqAL87+Ch8dBTQ26f2Nub1ConRZySB2WHTml2jZxGmQ+Q8KybO8V4Dh7AybTgs17GSPGOM/MXPFQoep9TOj2Ui+Ys12j1WxjzC6zGBrRx4Z7XBLHW7xyk7rnXa3p9MngJElh/ghwl0r136BZqs25GyyOyOLC+uwc1ei1Zlz6dM=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(376002)(346002)(136003)(396003)(451199018)(46966006)(36840700001)(40470700004)(83380400001)(7636003)(921005)(356005)(8676002)(4326008)(70586007)(41300700001)(82740400003)(426003)(8936002)(47076005)(316002)(70206006)(54906003)(36860700001)(30864003)(110136005)(5660300002)(2616005)(336012)(82310400005)(40460700003)(36756003)(86362001)(40480700001)(6666004)(2906002)(186003)(26005)(478600001)(1076003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2023 21:10:44.3311
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 70fd50a4-3b01-43f6-8ead-08db0f991a20
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT077.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6977
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For drivers to support partial offload of a filter's action list,
add support for action miss to specify an action instance to
continue from in sw.

CT action in particular can't be fully offloaded, as new connections
need to be handled in software. This imposes other limitations on
the actions that can be offloaded together with the CT action, such
as packet modifications.

Assign each action on a filter's action list a unique miss_cookie
which drivers can then use to fill action_miss part of the tc skb
extension. On getting back this miss_cookie, find the action
instance with relevant cookie and continue classifying from there.

Signed-off-by: Paul Blakey <paulb@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Paul Blakey <paulb@nvidia.com>
---
 include/linux/skbuff.h     |   6 +-
 include/net/flow_offload.h |   1 +
 include/net/pkt_cls.h      |  34 +++---
 include/net/sch_generic.h  |   2 +
 net/openvswitch/flow.c     |   3 +-
 net/sched/act_api.c        |   2 +-
 net/sched/cls_api.c        | 215 +++++++++++++++++++++++++++++++++++--
 7 files changed, 236 insertions(+), 27 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index d5602b15c714..ff7ad331fb82 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -319,12 +319,16 @@ struct nf_bridge_info {
  * and read by ovs to recirc_id.
  */
 struct tc_skb_ext {
-	__u32 chain;
+	union {
+		u64 act_miss_cookie;
+		__u32 chain;
+	};
 	__u16 mru;
 	__u16 zone;
 	u8 post_ct:1;
 	u8 post_ct_snat:1;
 	u8 post_ct_dnat:1;
+	u8 act_miss:1; /* Set if act_miss_cookie is used */
 };
 #endif
 
diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 9c5cb12f8a90..118082eae48c 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -229,6 +229,7 @@ struct flow_action_entry {
 	enum flow_action_id		id;
 	u32				hw_index;
 	unsigned long			cookie;
+	u64				miss_cookie;
 	enum flow_action_hw_stats	hw_stats;
 	action_destr			destructor;
 	void				*destructor_priv;
diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index ace437c6754b..b3b5b0b62f16 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -59,6 +59,8 @@ int tcf_block_get_ext(struct tcf_block **p_block, struct Qdisc *q,
 void tcf_block_put(struct tcf_block *block);
 void tcf_block_put_ext(struct tcf_block *block, struct Qdisc *q,
 		       struct tcf_block_ext_info *ei);
+int tcf_exts_init_ex(struct tcf_exts *exts, struct net *net, int action,
+		     int police, struct tcf_proto *tp, u32 handle, bool used_action_miss);
 
 static inline bool tcf_block_shared(struct tcf_block *block)
 {
@@ -229,6 +231,7 @@ struct tcf_exts {
 	struct tc_action **actions;
 	struct net	*net;
 	netns_tracker	ns_tracker;
+	struct tcf_exts_miss_cookie_node *miss_cookie_node;
 #endif
 	/* Map to export classifier specific extension TLV types to the
 	 * generic extensions API. Unsupported extensions must be set to 0.
@@ -240,21 +243,11 @@ struct tcf_exts {
 static inline int tcf_exts_init(struct tcf_exts *exts, struct net *net,
 				int action, int police)
 {
-#ifdef CONFIG_NET_CLS_ACT
-	exts->type = 0;
-	exts->nr_actions = 0;
-	/* Note: we do not own yet a reference on net.
-	 * This reference might be taken later from tcf_exts_get_net().
-	 */
-	exts->net = net;
-	exts->actions = kcalloc(TCA_ACT_MAX_PRIO, sizeof(struct tc_action *),
-				GFP_KERNEL);
-	if (!exts->actions)
-		return -ENOMEM;
+#ifdef CONFIG_NET_CLS
+	return tcf_exts_init_ex(exts, net, action, police, NULL, 0, false);
+#else
+	return -EOPNOTSUPP;
 #endif
-	exts->action = action;
-	exts->police = police;
-	return 0;
 }
 
 /* Return false if the netns is being destroyed in cleanup_net(). Callers
@@ -360,6 +353,18 @@ tcf_exts_exec(struct sk_buff *skb, struct tcf_exts *exts,
 	return TC_ACT_OK;
 }
 
+static inline int
+tcf_exts_exec_ex(struct sk_buff *skb, struct tcf_exts *exts, int act_index,
+		 struct tcf_result *res)
+{
+#ifdef CONFIG_NET_CLS_ACT
+	return tcf_action_exec(skb, exts->actions + act_index,
+			       exts->nr_actions - act_index, res);
+#else
+	return TC_ACT_OK;
+#endif
+}
+
 int tcf_exts_validate(struct net *net, struct tcf_proto *tp,
 		      struct nlattr **tb, struct nlattr *rate_tlv,
 		      struct tcf_exts *exts, u32 flags,
@@ -584,6 +589,7 @@ int tc_setup_offload_action(struct flow_action *flow_action,
 void tc_cleanup_offload_action(struct flow_action *flow_action);
 int tc_setup_action(struct flow_action *flow_action,
 		    struct tc_action *actions[],
+		    u32 miss_cookie_base,
 		    struct netlink_ext_ack *extack);
 
 int tc_setup_cb_call(struct tcf_block *block, enum tc_setup_type type,
diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index af4aa66aaa4e..fab5ba3e61b7 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -369,6 +369,8 @@ struct tcf_proto_ops {
 						struct nlattr **tca,
 						struct netlink_ext_ack *extack);
 	void			(*tmplt_destroy)(void *tmplt_priv);
+	struct tcf_exts *	(*get_exts)(const struct tcf_proto *tp,
+					    u32 handle);
 
 	/* rtnetlink specific */
 	int			(*dump)(struct net*, struct tcf_proto*, void *,
diff --git a/net/openvswitch/flow.c b/net/openvswitch/flow.c
index 416976f70322..33b21a0c0548 100644
--- a/net/openvswitch/flow.c
+++ b/net/openvswitch/flow.c
@@ -1041,7 +1041,8 @@ int ovs_flow_key_extract(const struct ip_tunnel_info *tun_info,
 #if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
 	if (tc_skb_ext_tc_enabled()) {
 		tc_ext = skb_ext_find(skb, TC_SKB_EXT);
-		key->recirc_id = tc_ext ? tc_ext->chain : 0;
+		key->recirc_id = tc_ext && !tc_ext->act_miss ?
+				 tc_ext->chain : 0;
 		OVS_CB(skb)->mru = tc_ext ? tc_ext->mru : 0;
 		post_ct = tc_ext ? tc_ext->post_ct : false;
 		post_ct_snat = post_ct ? tc_ext->post_ct_snat : false;
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index e67ebc939901..fce522886099 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -268,7 +268,7 @@ static int tcf_action_offload_add_ex(struct tc_action *action,
 	if (err)
 		goto fl_err;
 
-	err = tc_setup_action(&fl_action->action, actions, extack);
+	err = tc_setup_action(&fl_action->action, actions, 0, extack);
 	if (err) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "Failed to setup tc actions for offload");
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 656049ead8bb..3569e2c3660c 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -22,6 +22,7 @@
 #include <linux/idr.h>
 #include <linux/jhash.h>
 #include <linux/rculist.h>
+#include <linux/rhashtable.h>
 #include <net/net_namespace.h>
 #include <net/sock.h>
 #include <net/netlink.h>
@@ -50,6 +51,109 @@ static LIST_HEAD(tcf_proto_base);
 /* Protects list of registered TC modules. It is pure SMP lock. */
 static DEFINE_RWLOCK(cls_mod_lock);
 
+static struct xarray tcf_exts_miss_cookies_xa;
+struct tcf_exts_miss_cookie_node {
+	const struct tcf_chain *chain;
+	const struct tcf_proto *tp;
+	const struct tcf_exts *exts;
+	u32 chain_index;
+	u32 tp_prio;
+	u32 handle;
+	u32 miss_cookie_base;
+	struct rcu_head rcu;
+};
+
+/* Each tc action entry cookie will be comprised of 32bit miss_cookie_base +
+ * action index in the exts tc actions array.
+ */
+union tcf_exts_miss_cookie {
+	struct {
+		u32 miss_cookie_base;
+		u32 act_index;
+	};
+	u64 miss_cookie;
+};
+
+#if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
+static int
+tcf_exts_miss_cookie_base_alloc(struct tcf_exts *exts, struct tcf_proto *tp,
+				u32 handle)
+{
+	struct tcf_exts_miss_cookie_node *n;
+	static u32 next;
+	int err;
+
+	if (WARN_ON(!handle || !tp->ops->get_exts))
+		return -EINVAL;
+
+	n = kzalloc(sizeof(*n), GFP_KERNEL);
+	if (!n)
+		return -ENOMEM;
+
+	n->chain_index = tp->chain->index;
+	n->chain = tp->chain;
+	n->tp_prio = tp->prio;
+	n->tp = tp;
+	n->exts = exts;
+	n->handle = handle;
+
+	err = xa_alloc_cyclic(&tcf_exts_miss_cookies_xa, &n->miss_cookie_base,
+			      n, xa_limit_32b, &next, GFP_KERNEL);
+	if (err)
+		goto err_xa_alloc;
+
+	exts->miss_cookie_node = n;
+	return 0;
+
+err_xa_alloc:
+	kfree(n);
+	return err;
+}
+
+static void tcf_exts_miss_cookie_base_destroy(struct tcf_exts *exts)
+{
+	struct tcf_exts_miss_cookie_node *n;
+
+	if (!exts->miss_cookie_node)
+		return;
+
+	n = exts->miss_cookie_node;
+	xa_erase(&tcf_exts_miss_cookies_xa, n->miss_cookie_base);
+	kfree_rcu(n, rcu);
+}
+
+static struct tcf_exts_miss_cookie_node *
+tcf_exts_miss_cookie_lookup(u64 miss_cookie, int *act_index)
+{
+	union tcf_exts_miss_cookie mc = { .miss_cookie = miss_cookie, };
+
+	*act_index = mc.act_index;
+	return xa_load(&tcf_exts_miss_cookies_xa, mc.miss_cookie_base);
+}
+#else /* IS_ENABLED(CONFIG_NET_TC_SKB_EXT) */
+static int
+tcf_exts_miss_cookie_base_alloc(struct tcf_exts *exts, struct tcf_proto *tp,
+				u32 handle)
+{
+	return 0;
+}
+
+static void tcf_exts_miss_cookie_base_destroy(struct tcf_exts *exts)
+{
+}
+#endif /* IS_ENABLED(CONFIG_NET_TC_SKB_EXT) */
+
+static u64 tcf_exts_miss_cookie_get(u32 miss_cookie_base, int act_index)
+{
+	union tcf_exts_miss_cookie mc = { .act_index = act_index, };
+
+	if (!miss_cookie_base)
+		return 0;
+
+	mc.miss_cookie_base = miss_cookie_base;
+	return mc.miss_cookie;
+}
+
 #ifdef CONFIG_NET_CLS_ACT
 DEFINE_STATIC_KEY_FALSE(tc_skb_ext_tc);
 EXPORT_SYMBOL(tc_skb_ext_tc);
@@ -1549,6 +1653,8 @@ static inline int __tcf_classify(struct sk_buff *skb,
 				 const struct tcf_proto *orig_tp,
 				 struct tcf_result *res,
 				 bool compat_mode,
+				 struct tcf_exts_miss_cookie_node *n,
+				 int act_index,
 				 u32 *last_executed_chain)
 {
 #ifdef CONFIG_NET_CLS_ACT
@@ -1560,13 +1666,36 @@ static inline int __tcf_classify(struct sk_buff *skb,
 #endif
 	for (; tp; tp = rcu_dereference_bh(tp->next)) {
 		__be16 protocol = skb_protocol(skb, false);
-		int err;
+		int err = 0;
 
-		if (tp->protocol != protocol &&
-		    tp->protocol != htons(ETH_P_ALL))
-			continue;
+		if (n) {
+			struct tcf_exts *exts;
+
+			if (n->tp_prio != tp->prio)
+				continue;
+
+			/* We re-lookup the tp and chain based on index instead
+			 * of having hard refs and locks to them, so do a sanity
+			 * check if any of tp,chain,exts was replaced by the
+			 * time we got here with a cookie from hardware.
+			 */
+			if (unlikely(n->tp != tp || n->tp->chain != n->chain ||
+				     !tp->ops->get_exts))
+				return TC_ACT_SHOT;
+
+			exts = tp->ops->get_exts(tp, n->handle);
+			if (unlikely(!exts || n->exts != exts))
+				return TC_ACT_SHOT;
 
-		err = tc_classify(skb, tp, res);
+			n = NULL;
+			err = tcf_exts_exec_ex(skb, exts, act_index, res);
+		} else {
+			if (tp->protocol != protocol &&
+			    tp->protocol != htons(ETH_P_ALL))
+				continue;
+
+			err = tc_classify(skb, tp, res);
+		}
 #ifdef CONFIG_NET_CLS_ACT
 		if (unlikely(err == TC_ACT_RECLASSIFY && !compat_mode)) {
 			first_tp = orig_tp;
@@ -1582,6 +1711,9 @@ static inline int __tcf_classify(struct sk_buff *skb,
 			return err;
 	}
 
+	if (unlikely(n))
+		return TC_ACT_SHOT;
+
 	return TC_ACT_UNSPEC; /* signal: continue lookup */
 #ifdef CONFIG_NET_CLS_ACT
 reset:
@@ -1606,21 +1738,35 @@ int tcf_classify(struct sk_buff *skb,
 #if !IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
 	u32 last_executed_chain = 0;
 
-	return __tcf_classify(skb, tp, tp, res, compat_mode,
+	return __tcf_classify(skb, tp, tp, res, compat_mode, NULL, 0,
 			      &last_executed_chain);
 #else
 	u32 last_executed_chain = tp ? tp->chain->index : 0;
+	struct tcf_exts_miss_cookie_node *n = NULL;
 	const struct tcf_proto *orig_tp = tp;
 	struct tc_skb_ext *ext;
+	int act_index = 0;
 	int ret;
 
 	if (block) {
 		ext = skb_ext_find(skb, TC_SKB_EXT);
 
-		if (ext && ext->chain) {
+		if (ext && (ext->chain || ext->act_miss)) {
 			struct tcf_chain *fchain;
+			u32 chain;
+
+			if (ext->act_miss) {
+				n = tcf_exts_miss_cookie_lookup(ext->act_miss_cookie,
+								&act_index);
+				if (!n)
+					return TC_ACT_SHOT;
 
-			fchain = tcf_chain_lookup_rcu(block, ext->chain);
+				chain = n->chain_index;
+			} else {
+				chain = ext->chain;
+			}
+
+			fchain = tcf_chain_lookup_rcu(block, chain);
 			if (!fchain)
 				return TC_ACT_SHOT;
 
@@ -1632,7 +1778,7 @@ int tcf_classify(struct sk_buff *skb,
 		}
 	}
 
-	ret = __tcf_classify(skb, tp, orig_tp, res, compat_mode,
+	ret = __tcf_classify(skb, tp, orig_tp, res, compat_mode, n, act_index,
 			     &last_executed_chain);
 
 	if (tc_skb_ext_tc_enabled()) {
@@ -3056,9 +3202,48 @@ static int tc_dump_chain(struct sk_buff *skb, struct netlink_callback *cb)
 	return skb->len;
 }
 
+int tcf_exts_init_ex(struct tcf_exts *exts, struct net *net, int action,
+		     int police, struct tcf_proto *tp, u32 handle,
+		     bool use_action_miss)
+{
+	int err = 0;
+
+#ifdef CONFIG_NET_CLS_ACT
+	exts->type = 0;
+	exts->nr_actions = 0;
+	/* Note: we do not own yet a reference on net.
+	 * This reference might be taken later from tcf_exts_get_net().
+	 */
+	exts->net = net;
+	exts->actions = kcalloc(TCA_ACT_MAX_PRIO, sizeof(struct tc_action *),
+				GFP_KERNEL);
+	if (!exts->actions)
+		return -ENOMEM;
+#endif
+
+	exts->action = action;
+	exts->police = police;
+
+	if (!use_action_miss)
+		return 0;
+
+	err = tcf_exts_miss_cookie_base_alloc(exts, tp, handle);
+	if (err)
+		goto err_miss_alloc;
+
+	return 0;
+
+err_miss_alloc:
+	tcf_exts_destroy(exts);
+	return err;
+}
+EXPORT_SYMBOL(tcf_exts_init_ex);
+
 void tcf_exts_destroy(struct tcf_exts *exts)
 {
 #ifdef CONFIG_NET_CLS_ACT
+	tcf_exts_miss_cookie_base_destroy(exts);
+
 	if (exts->actions) {
 		tcf_action_destroy(exts->actions, TCA_ACT_UNBIND);
 		kfree(exts->actions);
@@ -3547,6 +3732,7 @@ static int tc_setup_offload_act(struct tc_action *act,
 
 int tc_setup_action(struct flow_action *flow_action,
 		    struct tc_action *actions[],
+		    u32 miss_cookie_base,
 		    struct netlink_ext_ack *extack)
 {
 	int i, j, k, index, err = 0;
@@ -3578,6 +3764,8 @@ int tc_setup_action(struct flow_action *flow_action,
 			entry[k].hw_stats = tc_act_hw_stats(act->hw_stats);
 			entry[k].hw_index = act->tcfa_index;
 			entry[k].cookie = (unsigned long)act;
+			entry[k].miss_cookie =
+				tcf_exts_miss_cookie_get(miss_cookie_base, i);
 		}
 
 		j += index;
@@ -3600,10 +3788,15 @@ int tc_setup_offload_action(struct flow_action *flow_action,
 			    struct netlink_ext_ack *extack)
 {
 #ifdef CONFIG_NET_CLS_ACT
+	u32 miss_cookie_base;
+
 	if (!exts)
 		return 0;
 
-	return tc_setup_action(flow_action, exts->actions, extack);
+	miss_cookie_base = exts->miss_cookie_node ?
+			   exts->miss_cookie_node->miss_cookie_base : 0;
+	return tc_setup_action(flow_action, exts->actions, miss_cookie_base,
+			       extack);
 #else
 	return 0;
 #endif
@@ -3771,6 +3964,8 @@ static int __init tc_filter_init(void)
 	if (err)
 		goto err_register_pernet_subsys;
 
+	xa_init_flags(&tcf_exts_miss_cookies_xa, XA_FLAGS_ALLOC1);
+
 	rtnl_register(PF_UNSPEC, RTM_NEWTFILTER, tc_new_tfilter, NULL,
 		      RTNL_FLAG_DOIT_UNLOCKED);
 	rtnl_register(PF_UNSPEC, RTM_DELTFILTER, tc_del_tfilter, NULL,
-- 
2.30.1

