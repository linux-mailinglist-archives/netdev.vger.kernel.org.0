Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58751676DD3
	for <lists+netdev@lfdr.de>; Sun, 22 Jan 2023 15:55:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbjAVOzi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Jan 2023 09:55:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbjAVOzg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Jan 2023 09:55:36 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2063.outbound.protection.outlook.com [40.107.212.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 474DD1A4A4
        for <netdev@vger.kernel.org>; Sun, 22 Jan 2023 06:55:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Iww4TAUhUfUu+5EgmnLq+384EI+fSgAJqqEYTamDIzPBXiJvo+jq8a4z16V1b6BfGO/hy3gubv6NbpAJeKDZ16cJotCG6apuVlJOqcNkPrb/c7aaNDQeTKiC8FY3GpuqqEIEeMoF4gQQL58FQo/mPQdwguxG/vsME7LzcgCHzt3yNvymeQf++X+p0tehZ85szQiw2/xKUJZiRsN8RK2OKdus36rDOsT9BLqAMLVjWbCrChkSC+O3QrmznpNas4WjhJzBjGrWEkXAVP/RYlqFfL+E/mdkj+yIOD/TsHiXlllJ3dydzx4eaHPrsyzmn9l+bSVOxyEQNNoBJHJMvkCC5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LLkuck+5pykpPSDwi7B8/owPURic2UUT/jT1xEUxb30=;
 b=VJW0JH4Z1IFZpyWrU1zJ99WxZT/4zYymDqKcXnM7xD2dlQkBUHvYUdgYvEDtZ+r+V8naFG93E3clUtJDPEpQiVitG7mI1wNeRKvnYOv+2htxOOZ57m859uAT7J6y6cX72T5yBNkgjsbBGld95vNTvYTUKJreDHpppvxXJzkGk7c5M/Uc+4GEe42xaoeU0Vq82l3Cpd/KzAH8lIc+OcvySxWVX0gXcAKm1msHCm/PN+LFd7ni3CBvonqTzA0dptofLsqPnLn0Cm6HMlvEY8z3zH6Wif3BmUgJrOxKod6Gp1gKUdssw3fq3CZ/QuN36REzrkhnrz5XcanVJ5H0E3y4ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LLkuck+5pykpPSDwi7B8/owPURic2UUT/jT1xEUxb30=;
 b=V7IjHAKlpU7FYmTM8yWzDFO7FfzlNA/yzbLf34WFwca9T/je579nzYRbRoQ/EoYaLG7s1jmmlNQtxMfjDui/0jQdhV5PAZLIG+Y0WAHFoyaWm+HFjmsdUomg8cPkWVnnd4o0kwJJzhuhHlZ7lYjkeLMRid3F6UBUz/xYQmtsJSDjmrSCPYihdGcNJgGmLAL8608SZBsnap8xJzo5fqM/adekmU86Be3gJ2CflkYZyaCa+dA7objuDeQr51IJ0AHqoKb8HhRgiTBHAr9DrUzP4S7awdi9Y4bZF3685zInodkCCsDHxMpAyZohtK6nx+HCcRvD588VsoFCvOvT3+idtg==
Received: from MW2PR2101CA0033.namprd21.prod.outlook.com (2603:10b6:302:1::46)
 by CY5PR12MB6526.namprd12.prod.outlook.com (2603:10b6:930:31::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.28; Sun, 22 Jan
 2023 14:55:31 +0000
Received: from CO1NAM11FT105.eop-nam11.prod.protection.outlook.com
 (2603:10b6:302:1:cafe::cf) by MW2PR2101CA0033.outlook.office365.com
 (2603:10b6:302:1::46) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.3 via Frontend
 Transport; Sun, 22 Jan 2023 14:55:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CO1NAM11FT105.mail.protection.outlook.com (10.13.175.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6023.16 via Frontend Transport; Sun, 22 Jan 2023 14:55:31 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 22 Jan
 2023 06:55:30 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Sun, 22 Jan 2023 06:55:29 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.126.190.181) with Microsoft SMTP Server id 15.2.986.36
 via Frontend Transport; Sun, 22 Jan 2023 06:55:26 -0800
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
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next v4 1/6] net/sched: cls_api: Support hardware miss to tc action
Date:   Sun, 22 Jan 2023 16:55:07 +0200
Message-ID: <20230122145512.8920-2-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230122145512.8920-1-paulb@nvidia.com>
References: <20230122145512.8920-1-paulb@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT105:EE_|CY5PR12MB6526:EE_
X-MS-Office365-Filtering-Correlation-Id: acb87809-03e8-4074-0209-08dafc88b52c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6w3iu+vT856Pifpj4ehOHYI5bG4g6LdibE8sx/qw4MPJxfOUir7o68QkhJ1tOLF5K+B8Is9v2kzqVyInfH18SmjV+xHuzUXBXaOzRJAelR0ZU+a/9qZl1fKlwHRPk/Gzd7EHNIe0EJ+uY2imc8vmuJKr0d2THYOYaGte070NL5Jk6Il4UU/KIQtvZEAwYFexNm9YbhPHIf9hGsvy6R3S2DBN1wmktso0QyjP9buCiqQp2s+emsZKSJKPnCGTaJESGiaeuDsa59I6MECY/xyXuRlK/+9gTsE9ZLWGyK5SQKVsbveJy9SZXP5cVvsBeoky61Zyhzgf0Cc/AJS+ZtKiVVLU7Cb+VDlE5Af8pKBBXcAOOOkjoTaBJ0zVVtgygvhToGXGsz+qvTRPa33N5zLiySnwYezIdn/U561N2iikFWuJsIMXmdBkEA0PIVmU/Ll58cgaVHZcNOfzYWcplq6qYwT+CWt2W5S49P/0uR/LJP48SsIrabREy7P2l9dTx7dGsGVsqri9zCedP+Oi9Y3509131dxMwLWIB1J2+Lqb6MhZAw2SjUbLvR7qrCn41LsS/F7gDTVfOCvpvRQD+mJ7J7r5sLPyiPylgCGUyGtXLhAu+AAgYA9wKGYWfLwOU4TmHoRduUOzJmiw85Lm3Aru18/LZsA4cpdiYdkVV6eUD5HxWUmnG5e8FeMVKcr2tqsE3Qa9tVKnpWIaGdVqhGMHFw==
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(39860400002)(396003)(346002)(451199015)(40470700004)(36840700001)(46966006)(86362001)(2906002)(40480700001)(41300700001)(4326008)(70206006)(70586007)(336012)(186003)(26005)(8676002)(1076003)(478600001)(47076005)(2616005)(426003)(40460700003)(7636003)(6666004)(54906003)(82740400003)(107886003)(110136005)(5660300002)(356005)(8936002)(316002)(83380400001)(36860700001)(30864003)(82310400005)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2023 14:55:31.0877
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: acb87809-03e8-4074-0209-08dafc88b52c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT105.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6526
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
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
---
 include/linux/skbuff.h     |   6 +-
 include/net/flow_offload.h |   1 +
 include/net/pkt_cls.h      |  22 ++--
 include/net/sch_generic.h  |   2 +
 net/openvswitch/flow.c     |   2 +-
 net/sched/act_api.c        |   2 +-
 net/sched/cls_api.c        | 210 +++++++++++++++++++++++++++++++++++--
 7 files changed, 218 insertions(+), 27 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 4c8492401a101..348673dcb6bb9 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -316,12 +316,16 @@ struct nf_bridge_info {
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
index 0400a0ac8a295..88db7346eb7a0 100644
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
index 4cabb32a2ad94..9ef85cf9b5328 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -59,6 +59,8 @@ int tcf_block_get_ext(struct tcf_block **p_block, struct Qdisc *q,
 void tcf_block_put(struct tcf_block *block);
 void tcf_block_put_ext(struct tcf_block *block, struct Qdisc *q,
 		       struct tcf_block_ext_info *ei);
+int tcf_exts_init_ex(struct tcf_exts *exts, struct net *net, int action, int police,
+		     struct tcf_proto *tp, u32 handle, bool used_action_miss);
 
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
@@ -577,6 +570,7 @@ int tc_setup_offload_action(struct flow_action *flow_action,
 void tc_cleanup_offload_action(struct flow_action *flow_action);
 int tc_setup_action(struct flow_action *flow_action,
 		    struct tc_action *actions[],
+		    u32 miss_cookie_base,
 		    struct netlink_ext_ack *extack);
 
 int tc_setup_cb_call(struct tcf_block *block, enum tc_setup_type type,
diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index af4aa66aaa4eb..fab5ba3e61b7c 100644
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
index e20d1a9734175..b1a5eed8d1a9d 100644
--- a/net/openvswitch/flow.c
+++ b/net/openvswitch/flow.c
@@ -1038,7 +1038,7 @@ int ovs_flow_key_extract(const struct ip_tunnel_info *tun_info,
 #if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
 	if (tc_skb_ext_tc_enabled()) {
 		tc_ext = skb_ext_find(skb, TC_SKB_EXT);
-		key->recirc_id = tc_ext ? tc_ext->chain : 0;
+		key->recirc_id = tc_ext && !tc_ext->act_miss ? tc_ext->chain : 0;
 		OVS_CB(skb)->mru = tc_ext ? tc_ext->mru : 0;
 		post_ct = tc_ext ? tc_ext->post_ct : false;
 		post_ct_snat = post_ct ? tc_ext->post_ct_snat : false;
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index cd09ef49df22d..16fd3d30eb121 100644
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
index 5b4a95e8a1ee0..46524ae353c5a 100644
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
@@ -50,6 +51,98 @@ static LIST_HEAD(tcf_proto_base);
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
@@ -1549,6 +1642,8 @@ static inline int __tcf_classify(struct sk_buff *skb,
 				 const struct tcf_proto *orig_tp,
 				 struct tcf_result *res,
 				 bool compat_mode,
+				 struct tcf_exts_miss_cookie_node *n,
+				 int act_index,
 				 u32 *last_executed_chain)
 {
 #ifdef CONFIG_NET_CLS_ACT
@@ -1560,13 +1655,40 @@ static inline int __tcf_classify(struct sk_buff *skb,
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
 
-		err = tc_classify(skb, tp, res);
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
+
+			n = NULL;
+#ifdef CONFIG_NET_CLS_ACT
+			err = tcf_action_exec(skb, exts->actions + act_index,
+					      exts->nr_actions - act_index,
+					      res);
+#endif
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
@@ -1582,6 +1704,9 @@ static inline int __tcf_classify(struct sk_buff *skb,
 			return err;
 	}
 
+	if (unlikely(n))
+		return TC_ACT_SHOT;
+
 	return TC_ACT_UNSPEC; /* signal: continue lookup */
 #ifdef CONFIG_NET_CLS_ACT
 reset:
@@ -1606,21 +1731,33 @@ int tcf_classify(struct sk_buff *skb,
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
+
+			if (ext->act_miss) {
+				n = tcf_exts_miss_cookie_lookup(ext->act_miss_cookie,
+								&act_index);
+				if (!n)
+					return TC_ACT_SHOT;
 
-			fchain = tcf_chain_lookup_rcu(block, ext->chain);
+				chain = n->chain_index;
+			}
+
+			fchain = tcf_chain_lookup_rcu(block, chain);
 			if (!fchain)
 				return TC_ACT_SHOT;
 
@@ -1632,7 +1769,7 @@ int tcf_classify(struct sk_buff *skb,
 		}
 	}
 
-	ret = __tcf_classify(skb, tp, orig_tp, res, compat_mode,
+	ret = __tcf_classify(skb, tp, orig_tp, res, compat_mode, n, act_index,
 			     &last_executed_chain);
 
 	if (tc_skb_ext_tc_enabled()) {
@@ -3056,9 +3193,52 @@ static int tc_dump_chain(struct sk_buff *skb, struct netlink_callback *cb)
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
+#if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
+	err = tcf_exts_miss_cookie_base_alloc(exts, tp, handle);
+#endif
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
+#if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
+	tcf_exts_miss_cookie_base_destroy(exts);
+#endif
+
 	if (exts->actions) {
 		tcf_action_destroy(exts->actions, TCA_ACT_UNBIND);
 		kfree(exts->actions);
@@ -3547,6 +3727,7 @@ static int tc_setup_offload_act(struct tc_action *act,
 
 int tc_setup_action(struct flow_action *flow_action,
 		    struct tc_action *actions[],
+		    u32 miss_cookie_base,
 		    struct netlink_ext_ack *extack)
 {
 	int i, j, k, index, err = 0;
@@ -3577,6 +3758,8 @@ int tc_setup_action(struct flow_action *flow_action,
 		for (k = 0; k < index ; k++) {
 			entry[k].hw_stats = tc_act_hw_stats(act->hw_stats);
 			entry[k].hw_index = act->tcfa_index;
+			entry[k].miss_cookie =
+				tcf_exts_miss_cookie_get(miss_cookie_base, i);
 		}
 
 		j += index;
@@ -3599,10 +3782,15 @@ int tc_setup_offload_action(struct flow_action *flow_action,
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
@@ -3770,6 +3958,8 @@ static int __init tc_filter_init(void)
 	if (err)
 		goto err_register_pernet_subsys;
 
+	xa_init_flags(&tcf_exts_miss_cookies_xa, XA_FLAGS_ALLOC1);
+
 	rtnl_register(PF_UNSPEC, RTM_NEWTFILTER, tc_new_tfilter, NULL,
 		      RTNL_FLAG_DOIT_UNLOCKED);
 	rtnl_register(PF_UNSPEC, RTM_DELTFILTER, tc_del_tfilter, NULL,
-- 
2.30.1

