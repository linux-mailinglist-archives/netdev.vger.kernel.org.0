Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75207667081
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 12:08:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233250AbjALLIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 06:08:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230113AbjALLHv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 06:07:51 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2056.outbound.protection.outlook.com [40.107.93.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4550D47330
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 02:59:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OrdiPPNq4jGlVn3viQiFCYNcqsR3L2xgdUQsouC+R50kQ6Ret2QWTItEQqU67HeFeXKa3ZVPozZjhSlKQAUF0VWV+97DOVvyvGG4cJ55WPYeFyfSBEkuOipPBoMgIQcAfFmYoZfk23fF/z98ck9wtUVP7VYYnK7brwKDNRK7yGl4aIO/vhWmc4jNB03WH/bWRkS40bTUBhMoaPYcvbemV9DuHPluG9Jr/SCt2s8Awl2X8L4XWhevQJNOtl7GGUVPIhzXjIHsrFpPD3d61xXZ6XsmBw5+nBL4RbQShF1Zf2DsV6znQhEajuE/cuK9hPB35uTQOnRD7ZhaKDGGQoZlkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q3oz0idnPPYIcORaStUY2Z5WMhLAVmTsHSQLo0eMoCA=;
 b=Sfu1joJO8uh6APkKvQRYdefwYdWeLIZ7Ep/upbd2jhSe2+pYfmBGc+YZmyOCtLS3ubsVTwzrDbV3GN1pLBrKmgvdF5FPsJCDLPzHS+1d92XwPwh62X4jruXFCe728kAThmHS/XnfGvqNDJ59NM+CXIzrlaRLXDm8/HY6POeb7KuwgCtz/SbqZqN4qxWeLTKlL2/p9X37QuI5P34ezWUS4Sij7s1283KXbYHTQ8dBOeiFSenKi5Oqamzi4x/ICug3Y280/e2XKFAuRmS3XpJl4t5D5gm4tlmD4M4cD9FiuBMdOcRegFBepPIfuyVrfBXKDhAQI5a2foTmOf7H0J2TMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q3oz0idnPPYIcORaStUY2Z5WMhLAVmTsHSQLo0eMoCA=;
 b=P3KmqqO8cut91zs1npqeKON/6jzifE9WnTai+5d1iXmhJDyyNQh5cvJij2LCAQNla/dkcma4DaQfY2+KVGaccjiAgDN+lDCYca6YF/TgInnNwvm4layeWVhksRAYUUubySfoE87bC5Cye8oSgBeSfMvBMcOxl/JiVQ7+F6/tPOfy7A9mTRES8XKq/jCapXzSh/NqiQYsFyt9td0PcUkN7z3AAGWXwX/DTI32Ro7BY6CPJ0ROEY9AiLNM0wCdlI205twMHoH52jKqRwSyL/dQBiki79I2HEUgDIcLb9NqhsQCQO3X64cV3nCTFZ08AoWpAwXQjNpaqL0WpRQjP4ffug==
Received: from MW2PR16CA0056.namprd16.prod.outlook.com (2603:10b6:907:1::33)
 by BL1PR12MB5945.namprd12.prod.outlook.com (2603:10b6:208:398::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Thu, 12 Jan
 2023 10:59:33 +0000
Received: from CO1NAM11FT093.eop-nam11.prod.protection.outlook.com
 (2603:10b6:907:1:cafe::9a) by MW2PR16CA0056.outlook.office365.com
 (2603:10b6:907:1::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13 via Frontend
 Transport; Thu, 12 Jan 2023 10:59:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT093.mail.protection.outlook.com (10.13.175.59) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.12 via Frontend Transport; Thu, 12 Jan 2023 10:59:32 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 12 Jan
 2023 02:59:17 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 12 Jan
 2023 02:59:17 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.9) with Microsoft SMTP Server id 15.2.986.36 via
 Frontend Transport; Thu, 12 Jan 2023 02:59:14 -0800
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
Subject: [PATCH net-next 1/6] net/sched: cls_api: Support hardware miss to tc action
Date:   Thu, 12 Jan 2023 12:59:00 +0200
Message-ID: <20230112105905.1738-2-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230112105905.1738-1-paulb@nvidia.com>
References: <20230112105905.1738-1-paulb@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT093:EE_|BL1PR12MB5945:EE_
X-MS-Office365-Filtering-Correlation-Id: e7c59501-7765-43a2-0f4a-08daf48c1611
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dVS7NN8oZsytXdeG7b7Y0Euvt8CSXYbYxdskQhqdRGbD49xvR3FHyO46HE6mKtQAyDOY4vl+VYtfWTbOb5/HGiGxLlt4MI29iCAAaeToS2AlceBVJLyTuBZlJtXyIG8UI8EfpJC0uilr25s5sNlyPlUfPZZq6WQZ2cg6AMy2OCvYzi7snA6uMSiTkVdDlaG/Qyo7mBNdGg26iYoKI6heUoLoWPhXPtGW4IsEOYIjm5+b3IFMD7uA13Rx9Pbw22DYzlSv2nxQ4qwWBkadRxwZrlkaYzkeSyPPK/ugTAh2UBGtBlkiQnzFJmTSJxnJmwKwGiwvtGcU13gulAVPlt+rl708A8x3gvcR3YPk/oLxPm4HxLZ1v20ZHCn5/y5+M2P8ZM9jJfEgdnhuaMGfwtBsMq2EWub+nAyEHN9yMCaVuodJ5AFr8Hfnj+0u2iAsBAvMYdkYWSDRe0b2Nx7si/Hni0B4XUeo/tSBc8NMfsA+D3hntZVX9iAHc1Jpdwelofj3/ulyWfirMLixi0HCw/31/Iv9XVWWDGBwovuepTs9aseBOJam7/IR07wkcrgfZUk2cPfd30TLSABVFlkUFaweRxYvsc+hoAkIloWn8VHW+5buWTcVRX76nlBpNTnB78Gwcu7yaH3u9Q/lXu1hMF/pvhYnrSlN+qwsTO/0RR9mQJT6fvsShFTzT1FQWppOolUyeuAcDIG6Gn/h/PEYk/YM1Q==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(396003)(376002)(39860400002)(451199015)(40470700004)(46966006)(36840700001)(36860700001)(107886003)(6666004)(2906002)(70206006)(36756003)(4326008)(5660300002)(83380400001)(8936002)(30864003)(8676002)(82740400003)(426003)(41300700001)(356005)(47076005)(478600001)(7636003)(336012)(40480700001)(26005)(70586007)(82310400005)(186003)(1076003)(40460700003)(86362001)(2616005)(316002)(54906003)(110136005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 10:59:32.7599
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e7c59501-7765-43a2-0f4a-08daf48c1611
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT093.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5945
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
---
 include/linux/skbuff.h     |   6 +-
 include/net/flow_offload.h |   1 +
 include/net/pkt_cls.h      |  20 +---
 include/net/sch_generic.h  |   2 +
 net/openvswitch/flow.c     |   2 +-
 net/sched/act_api.c        |   2 +-
 net/sched/cls_api.c        | 208 +++++++++++++++++++++++++++++++++++--
 7 files changed, 214 insertions(+), 27 deletions(-)

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
index 4cabb32a2ad94..a5d17b103328d 100644
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
@@ -240,21 +243,7 @@ struct tcf_exts {
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
-#endif
-	exts->action = action;
-	exts->police = police;
-	return 0;
+	return tcf_exts_init_ex(exts, net, action, police, NULL, 0, false);
 }
 
 /* Return false if the netns is being destroyed in cleanup_net(). Callers
@@ -577,6 +566,7 @@ int tc_setup_offload_action(struct flow_action *flow_action,
 void tc_cleanup_offload_action(struct flow_action *flow_action);
 int tc_setup_action(struct flow_action *flow_action,
 		    struct tc_action *actions[],
+		    u32 miss_cookie_base,
 		    struct netlink_ext_ack *extack);
 
 int tc_setup_cb_call(struct tcf_block *block, enum tc_setup_type type,
diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index d5517719af4ef..d2b859e3c8602 100644
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
index 5b3c0ac495bee..e28148015fbb5 100644
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
index 668130f089034..7d9fab24a8417 100644
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
@@ -1548,6 +1641,8 @@ static inline int __tcf_classify(struct sk_buff *skb,
 				 const struct tcf_proto *orig_tp,
 				 struct tcf_result *res,
 				 bool compat_mode,
+				 struct tcf_exts_miss_cookie_node *n,
+				 int act_index,
 				 u32 *last_executed_chain)
 {
 #ifdef CONFIG_NET_CLS_ACT
@@ -1561,11 +1656,38 @@ static inline int __tcf_classify(struct sk_buff *skb,
 		__be16 protocol = skb_protocol(skb, false);
 		int err;
 
-		if (tp->protocol != protocol &&
-		    tp->protocol != htons(ETH_P_ALL))
-			continue;
+		if (n) {
+			struct tcf_exts *exts;
+
+			if (n->tp_prio != tp->prio)
+				continue;
 
-		err = tc_classify(skb, tp, res);
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
@@ -1581,6 +1703,9 @@ static inline int __tcf_classify(struct sk_buff *skb,
 			return err;
 	}
 
+	if (unlikely(n))
+		return TC_ACT_SHOT;
+
 	return TC_ACT_UNSPEC; /* signal: continue lookup */
 #ifdef CONFIG_NET_CLS_ACT
 reset:
@@ -1605,21 +1730,33 @@ int tcf_classify(struct sk_buff *skb,
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
 
@@ -1631,7 +1768,7 @@ int tcf_classify(struct sk_buff *skb,
 		}
 	}
 
-	ret = __tcf_classify(skb, tp, orig_tp, res, compat_mode,
+	ret = __tcf_classify(skb, tp, orig_tp, res, compat_mode, n, act_index,
 			     &last_executed_chain);
 
 	if (tc_skb_ext_tc_enabled()) {
@@ -3040,9 +3177,52 @@ static int tc_dump_chain(struct sk_buff *skb, struct netlink_callback *cb)
 	return skb->len;
 }
 
+int tcf_exts_init_ex(struct tcf_exts *exts, struct net *net, int action,
+		     int police, struct tcf_proto *tp, u32 handle,
+		     bool use_action_miss)
+{
+	int err;
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
@@ -3531,6 +3711,7 @@ static int tc_setup_offload_act(struct tc_action *act,
 
 int tc_setup_action(struct flow_action *flow_action,
 		    struct tc_action *actions[],
+		    u32 miss_cookie_base,
 		    struct netlink_ext_ack *extack)
 {
 	int i, j, k, index, err = 0;
@@ -3561,6 +3742,8 @@ int tc_setup_action(struct flow_action *flow_action,
 		for (k = 0; k < index ; k++) {
 			entry[k].hw_stats = tc_act_hw_stats(act->hw_stats);
 			entry[k].hw_index = act->tcfa_index;
+			entry[k].miss_cookie =
+				tcf_exts_miss_cookie_get(miss_cookie_base, i);
 		}
 
 		j += index;
@@ -3583,10 +3766,15 @@ int tc_setup_offload_action(struct flow_action *flow_action,
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
@@ -3754,6 +3942,8 @@ static int __init tc_filter_init(void)
 	if (err)
 		goto err_register_pernet_subsys;
 
+	xa_init_flags(&tcf_exts_miss_cookies_xa, XA_FLAGS_ALLOC1);
+
 	rtnl_register(PF_UNSPEC, RTM_NEWTFILTER, tc_new_tfilter, NULL,
 		      RTNL_FLAG_DOIT_UNLOCKED);
 	rtnl_register(PF_UNSPEC, RTM_DELTFILTER, tc_del_tfilter, NULL,
-- 
2.30.1

