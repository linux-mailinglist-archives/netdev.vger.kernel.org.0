Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F19D868B0C3
	for <lists+netdev@lfdr.de>; Sun,  5 Feb 2023 16:51:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbjBEPvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Feb 2023 10:51:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbjBEPvy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Feb 2023 10:51:54 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on20625.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe59::625])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D1181F5C1
        for <netdev@vger.kernel.org>; Sun,  5 Feb 2023 07:51:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JVRCgB2hgmlBL4hWOYTTuU2X4O3cWWjmA1oMCyoIpFHSFz/g/4MNTTLyj3WTSdjRiBehYLkbJRaJiWmlekpg3Ej9GTu6JPInHEAvcddCPfJcGT6utBIilvoCiB7qK/3HbUX1byOWKO8j7hdLPcKVU6InIbR2qnb7HGZuAAR5NDuMmO2qYsMbNKGoK+0BKr1AAb3O8WjiAhm5GQkeRWc16dqrbdQ9HgCnns2H2RkD9HdQZk5M2fOUxHIG1b1PrKSHQzqJdb+76Fi9j8yEdmevWOX8QlHmfQ2VoA3jRIPUYMw06wz+Hg/HAXsEh/wovx6GaLWodpIX/wYmGhOTg+F5Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BpS8KhCCrEDWvgMUCRMhUqd51k8uUjz+uYQu/0/4YY4=;
 b=BcPFOc+QQxOZAZWbx12hZ5Go/1BL8gNvbVqjkwEIcswRJY9v+soOeV0t7jSC3WGHTTNrD5FP10xawmHL5Dv3KQ6ytj9lOh2ftQ+50t3axzYpNNt+BrVHP+EzYSRTaV5NSxnJWNhc9Co/CIiPRWY0Wmcf7Oh8xS51FGvyKPuS14w51SKSP1sb/gmsbG+Ver1ueqgaTTIsim/gkY/fnxC7z+XTPnrAPHBiBiJACmemghzjWVhJpU8EN8WzbJIP7Rzis6/0R7/W9aR7M9HMuIsv+TuoxCpGJLPKWxhELgHJlxe8JUq+a7osxdHnM+qrNE7FmV/qMW8lE/pchtFPmL9ngA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BpS8KhCCrEDWvgMUCRMhUqd51k8uUjz+uYQu/0/4YY4=;
 b=EoElUZG2sIAMWGDVj+4RvE9qAYeGF5pA8ZdEEL44fUn0zaJJgcIRmdxZbahd2ie0xO0OQOmej6Pg1+vZzbBSSc48n9la0g6sK4LH/qZlsAcdB3BvkzqtQOhDwjPSilj92gdQBJlazXhv/yxAkeJ9VKRhWZlMFaMATNl7n9V/TQu3t7nOUYuGNZLBKoJSAKZFRpgtCiuc32eSKCFJju7HWWIw5ozb9E679zgzrSffC8j3pQjywFBKU7PCUFdK9T0NDW/kaGKCEL4PmFrCRqnEmvdfXgL3HmiGqpvVV7dQva72nSwHKeiEUd/u8Ki4Md+gV5ULLGXEc3fVEnVxxTrqcQ==
Received: from BN0PR04CA0105.namprd04.prod.outlook.com (2603:10b6:408:ec::20)
 by CO6PR12MB5457.namprd12.prod.outlook.com (2603:10b6:5:355::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.32; Sun, 5 Feb
 2023 15:49:51 +0000
Received: from BN8NAM11FT099.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ec:cafe::9a) by BN0PR04CA0105.outlook.office365.com
 (2603:10b6:408:ec::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34 via Frontend
 Transport; Sun, 5 Feb 2023 15:49:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN8NAM11FT099.mail.protection.outlook.com (10.13.177.197) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.34 via Frontend Transport; Sun, 5 Feb 2023 15:49:51 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 5 Feb 2023
 07:49:44 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Sun, 5 Feb 2023 07:49:44 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.126.190.181) with Microsoft SMTP Server id 15.2.986.36
 via Frontend Transport; Sun, 5 Feb 2023 07:49:40 -0800
From:   Paul Blakey <paulb@nvidia.com>
To:     Paul Blakey <paulb@nvidia.com>, <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     Oz Shlomo <ozsh@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next v8 1/7] net/sched: cls_api: Support hardware miss to tc action
Date:   Sun, 5 Feb 2023 17:49:28 +0200
Message-ID: <20230205154934.22040-2-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230205154934.22040-1-paulb@nvidia.com>
References: <20230205154934.22040-1-paulb@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT099:EE_|CO6PR12MB5457:EE_
X-MS-Office365-Filtering-Correlation-Id: 49c7c971-a41d-47d8-d4c1-08db07909e2d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4uVOoDc+Ul7FCsNOCO8L0M7C8L9KWQlYw8Ii2KgNGupLdu68VMiKDqnsYtj+KkxzlOW/MEvjx0RdZy4O9hUnqvz4w2ApY2KIX8LWiwKoUd08nI6cLo+CJiZ4DvCLJDoU78SGV9z1O87wn85pV4u0BF/t7XdJxaW6yE1ATMs5bhcc71wYphv9GZP578geu0GW6TRGanTD25DgnOM1CxWf3JA8x+HEde2C1KkjrLmS3gRictvf0mpjXiwPC/OqYe0e3FhdqCrb36O6ubmCeSGiGeLlVpmXw7TlAau4U+GjYKlbmWIgMbl+YopI5+XskMhccj/MCuM1hN61UD2yz9ZYtGLokcmAlJryoD9SWGpotjTORGxJUCHO5ssIuQ6MppgLyuGXdkbRAvtaaOpMBRaU6RSgKpSjBgBJiI3u1x7x/uD4lWFGgGFazb4JNHi6C90go1yc2aMhFQ+BLe0oBxIyZ2NYYZ59Tvi0uDPlLex7M7ICdxiNECY6nmrzSIk0fiuULoetsgVlPBvqK7mzmTOnh3ZPKQPA1pcXnqDoKDndFSv7sB7N/rDX4gZ4iyfdSzOnL1MFS1v83CBx/KNQ9FsWq6M/1cNcjGPTcCuE8awpDdwsMSt49wfRpfRFFr7Y8dWxKcxAfr9+Fxyg36Ytw+ah3m2BYy0Q7/pXFesYdR2J7p0/lpYF/gJ3RI2gyUuLWVI3jtBy1qJPGx3SLq/98DGy6g==
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(396003)(346002)(136003)(376002)(451199018)(46966006)(40470700004)(36840700001)(40460700003)(1076003)(26005)(186003)(356005)(2616005)(6666004)(36860700001)(478600001)(7636003)(82740400003)(83380400001)(426003)(47076005)(336012)(36756003)(82310400005)(70206006)(40480700001)(86362001)(8936002)(41300700001)(70586007)(110136005)(54906003)(316002)(4326008)(8676002)(2906002)(5660300002)(30864003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2023 15:49:51.1671
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 49c7c971-a41d-47d8-d4c1-08db07909e2d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT099.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5457
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
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
---
 include/linux/skbuff.h     |   6 +-
 include/net/flow_offload.h |   1 +
 include/net/pkt_cls.h      |  34 +++---
 include/net/sch_generic.h  |   2 +
 net/openvswitch/flow.c     |   3 +-
 net/sched/act_api.c        |   2 +-
 net/sched/cls_api.c        | 213 +++++++++++++++++++++++++++++++++++--
 7 files changed, 234 insertions(+), 27 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 5ba12185f43e..5804ab031c96 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -311,12 +311,16 @@ struct nf_bridge_info {
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
index 0400a0ac8a29..88db7346eb7a 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -228,6 +228,7 @@ void flow_action_cookie_destroy(struct flow_action_cookie *cookie);
 struct flow_action_entry {
 	enum flow_action_id		id;
 	u32				hw_index;
+	u64				miss_cookie;
 	enum flow_action_hw_stats	hw_stats;
 	action_destr			destructor;
 	void				*destructor_priv;
diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 4cabb32a2ad9..7346a90e0842 100644
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
@@ -353,6 +346,18 @@ tcf_exts_exec(struct sk_buff *skb, struct tcf_exts *exts,
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
@@ -577,6 +582,7 @@ int tc_setup_offload_action(struct flow_action *flow_action,
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
index e20d1a973417..69f91460a55c 100644
--- a/net/openvswitch/flow.c
+++ b/net/openvswitch/flow.c
@@ -1038,7 +1038,8 @@ int ovs_flow_key_extract(const struct ip_tunnel_info *tun_info,
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
index cd09ef49df22..16fd3d30eb12 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -272,7 +272,7 @@ static int tcf_action_offload_add_ex(struct tc_action *action,
 	if (err)
 		goto fl_err;
 
-	err = tc_setup_action(&fl_action->action, actions, extack);
+	err = tc_setup_action(&fl_action->action, actions, 0, extack);
 	if (err) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "Failed to setup tc actions for offload");
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 5b4a95e8a1ee..8ff9530fef68 100644
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
@@ -1606,21 +1738,33 @@ int tcf_classify(struct sk_buff *skb,
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
+			u32 chain = ext->chain;
 
-			fchain = tcf_chain_lookup_rcu(block, ext->chain);
+			if (ext->act_miss) {
+				n = tcf_exts_miss_cookie_lookup(ext->act_miss_cookie,
+								&act_index);
+				if (!n)
+					return TC_ACT_SHOT;
+
+				chain = n->chain_index;
+			}
+
+			fchain = tcf_chain_lookup_rcu(block, chain);
 			if (!fchain)
 				return TC_ACT_SHOT;
 
@@ -1632,7 +1776,7 @@ int tcf_classify(struct sk_buff *skb,
 		}
 	}
 
-	ret = __tcf_classify(skb, tp, orig_tp, res, compat_mode,
+	ret = __tcf_classify(skb, tp, orig_tp, res, compat_mode, n, act_index,
 			     &last_executed_chain);
 
 	if (tc_skb_ext_tc_enabled()) {
@@ -3056,9 +3200,48 @@ static int tc_dump_chain(struct sk_buff *skb, struct netlink_callback *cb)
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
@@ -3547,6 +3730,7 @@ static int tc_setup_offload_act(struct tc_action *act,
 
 int tc_setup_action(struct flow_action *flow_action,
 		    struct tc_action *actions[],
+		    u32 miss_cookie_base,
 		    struct netlink_ext_ack *extack)
 {
 	int i, j, k, index, err = 0;
@@ -3577,6 +3761,8 @@ int tc_setup_action(struct flow_action *flow_action,
 		for (k = 0; k < index ; k++) {
 			entry[k].hw_stats = tc_act_hw_stats(act->hw_stats);
 			entry[k].hw_index = act->tcfa_index;
+			entry[k].miss_cookie =
+				tcf_exts_miss_cookie_get(miss_cookie_base, i);
 		}
 
 		j += index;
@@ -3599,10 +3785,15 @@ int tc_setup_offload_action(struct flow_action *flow_action,
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
@@ -3770,6 +3961,8 @@ static int __init tc_filter_init(void)
 	if (err)
 		goto err_register_pernet_subsys;
 
+	xa_init_flags(&tcf_exts_miss_cookies_xa, XA_FLAGS_ALLOC1);
+
 	rtnl_register(PF_UNSPEC, RTM_NEWTFILTER, tc_new_tfilter, NULL,
 		      RTNL_FLAG_DOIT_UNLOCKED);
 	rtnl_register(PF_UNSPEC, RTM_DELTFILTER, tc_del_tfilter, NULL,
-- 
2.30.1

