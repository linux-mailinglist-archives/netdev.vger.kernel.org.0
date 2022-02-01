Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6F794A6301
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 18:53:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233867AbiBARw6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 12:52:58 -0500
Received: from mail-dm6nam12on2065.outbound.protection.outlook.com ([40.107.243.65]:30176
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233089AbiBARw5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Feb 2022 12:52:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C62eyYwLr2ZI2mXU5ueLgr3fXhF8hEQ7HsJezPsne2fiHhz+hOamPOmW+0Hifv/EJYmEfDAffbj2EM1tZTCpr3umai2fXqUQKWqXsV5CEPkyQEIepm9Fdmm+CviU0ECK+AoknJ1e9WKPCsyvhpK7EhXXfyjmRCX8jf0xbOoCl9D82TCOguXNARnAqAxeFxjQ7VFWkd51pI9NaMAykvMldW+3ZFhiBUcygPV6r8CHOTqWL2k8Is4+f7nwf2o6SVH0Qphz1zxezWQnsQqKJ7pS8IH6b2wkB8oVEFK0R05fvIjaupdI8DGs9L2JpR7KzwJk3tQXhqYHAl3mc/+rYR7fqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=89YMor6SdbU+FEB/sn62JMOWApSo2sS99XTFMkxrZ7g=;
 b=bvmvd28rjZj3Wmpx8i3XLsMQ3t0YvLaAv5wg7QEcI1lAZPUXgdHyPLMU/5TndV+hnssVnckGlmN2/0cXQXN+VroMPKKv4wY7twmxDkNv5QJ6Kdc0Ma6w0nwQcdYNj2MhS6YzovzLAOMAyArazoBllcwEao/3Uh1pg5Auos+BZHhBxNFb06PsBsXVA1Ja8YUSLpwKO/x0e9Zul8CaE5QUzAUt3yaMSbuKHXzQzLIIr9evlqNmRbvCZy6uNIgzFGbf/RcJWkMjElzNKcGlzzZt9rRlZav5+/tAkdou+TYW3fYHtyFBYyicbt8KU2Mha59U5Foqqi6f67YXuuHCfGIoUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=89YMor6SdbU+FEB/sn62JMOWApSo2sS99XTFMkxrZ7g=;
 b=IKOsnZc8yn2MFsRUDFOJXSwEjB14t1Y5uULaD68e9zcz4JCtSfafYAQ6HMQx9wedfIkSPo6NU9voi1/AQrTWLTSIeZYFGsfsWNq28uYfRxxj7fLUVCX0Lw3FMKXaF9ojmgert8oAgczHKpskoHyzrZr98ivXIahEgswSOwycOt2fpvob1nCPlgHP0/YqqtSPf1hmX51EjxN652N4SDwGHHjSBel9jSHX6XpIb9DELtnxqWkaQJ6WqLZdLcPNuisqoQ6/0x79CJqZlyxQFbIgcqzsSbBuJJ8Zkk8gQrXfffN6favv5+pIXsfMM9pyQo6fDCouFJ+H+Rreh4ik1LxdwA==
Received: from CO2PR04CA0108.namprd04.prod.outlook.com (2603:10b6:104:6::34)
 by DM6PR12MB2972.namprd12.prod.outlook.com (2603:10b6:5:39::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17; Tue, 1 Feb
 2022 17:52:55 +0000
Received: from CO1NAM11FT040.eop-nam11.prod.protection.outlook.com
 (2603:10b6:104:6:cafe::a3) by CO2PR04CA0108.outlook.office365.com
 (2603:10b6:104:6::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.22 via Frontend
 Transport; Tue, 1 Feb 2022 17:52:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT040.mail.protection.outlook.com (10.13.174.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4951.12 via Frontend Transport; Tue, 1 Feb 2022 17:52:53 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 1 Feb
 2022 17:52:52 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Tue, 1 Feb 2022
 09:52:51 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.9) with Microsoft SMTP Server id 15.2.986.9 via
 Frontend Transport; Tue, 1 Feb 2022 09:52:47 -0800
From:   Paul Blakey <paulb@nvidia.com>
To:     Paul Blakey <paulb@nvidia.com>, <dev@openvswitch.org>,
        <netdev@vger.kernel.org>, Cong Wang <xiyou.wangcong@gmail.com>,
        "Jamal Hadi Salim" <jhs@mojatatu.com>,
        Pravin B Shelar <pshelar@ovn.org>, <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
CC:     Saeed Mahameed <saeedm@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        "Vlad Buslov" <vladbu@nvidia.com>, Roi Dayan <roid@nvidia.com>
Subject: [PATCH net-next v2 1/1] net/sched: Enable tc skb ext allocation on chain miss only when needed
Date:   Tue, 1 Feb 2022 19:52:20 +0200
Message-ID: <20220201175220.7680-1-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d9876939-bb86-4580-fb53-08d9e5abac20
X-MS-TrafficTypeDiagnostic: DM6PR12MB2972:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB29729E219F9A3B976CD6AEEBC2269@DM6PR12MB2972.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:475;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qcLovo/FnXvBoODQkRX7xbW63GTXEsldhEZhEq9ISLDQ7d/0d0oR7TuTBP29BsV9JLwtyCvf7OhKIcjLXaXoCbzSQZrh3hEaqfe/7aXp4+hq761bScZ9/6D3ulncgtOUbZD6pGcJQ6nIn4KBUxXAvaNhBzgp5z7Mz63lK/xFjseHJm2jIKAMveU5H3eqB5Q869TRkISYQr0Fq6KGVQIX57Fi8m5Jv+xZ/sTYnEOREZtMCnaw22E95HGHa8h6hvhlU95UGCpVdOstvz9D0kQxfly6p+7V4s1M4Fo6cVpQ9eaoxgx1ImPEsxti8JInGN6XeY+aPG69O/hIdZo1dkI2GVD7Ju6PMLmXCfWlYxgoaItNjggWgDOumg1KA+gQvvEfZGOFLQp/Raer/6fuuz0DlPQGMGp7WMahZ9kPbu8G6pZAAuuYEVIgsdwQyrLaMxdaQrzGAV45g4Qv7uvgtL+5BlIpabK9/PkxzbczEIWrYA5urbqO5Wgr65C3RVvWWAftR3eq4Nlew/TV/UOizYxcve0G9ae8TZ0dTquZ4t4hlL8NSajsc4LKYSo/VgKgjgWrGksTXVPkJ6ogqtUSHF5MBbhJV4vQ0zos+4j+VS46k6ADrzVS9n66qO+RZJ0lfJo69cvdjEU8AbQM3DWCPYn/voBi3I9H5BQG15S//rEAmJ7YZ03zpvztMYVAL07eYqTJrwiBo9Y7VOqTdfbzWtEEREVY4yR2ejjESHCOIm+C9ig=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(47076005)(36860700001)(356005)(86362001)(81166007)(83380400001)(40460700003)(70586007)(70206006)(921005)(316002)(36756003)(508600001)(8936002)(110136005)(4326008)(8676002)(54906003)(2906002)(2616005)(5660300002)(336012)(6666004)(82310400004)(107886003)(1076003)(186003)(26005)(426003)(36900700001)(20210929001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2022 17:52:53.8396
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d9876939-bb86-4580-fb53-08d9e5abac20
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT040.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2972
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tc skb extension is used to send miss info from tc to ovs datapath
module, and is currently always allocated even if it will not
be used by ovs datapath (as it depends on a requested feature).

Export the static key which is used by openvswitch module to
guard this code path as well, so it will be skipped if ovs
datapath doesn't need it. Enable this code path once
ovs datapath needs it.

Signed-off-by: Paul Blakey <paulb@nvidia.com>
---
 Changelog:
   v1->v2:
     Added ifdef on exports so inline stubs won't be duplicated in !CLS_ACT case

 include/net/pkt_cls.h      | 11 ++++++++++
 net/openvswitch/datapath.c | 18 +++++++++------
 net/openvswitch/datapath.h |  2 --
 net/openvswitch/flow.c     |  3 ++-
 net/sched/cls_api.c        | 45 +++++++++++++++++++++++++++-----------
 5 files changed, 56 insertions(+), 23 deletions(-)

diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 676cb8ea9e15..b4a34d3325d2 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -1028,4 +1028,15 @@ struct tc_fifo_qopt_offload {
 	};
 };
 
+#ifdef CONFIG_NET_CLS_ACT
+DECLARE_STATIC_KEY_FALSE(tc_skb_ext_tc_ovs);
+void tc_skb_ext_tc_ovs_enable(void);
+void tc_skb_ext_tc_ovs_disable(void);
+#define tc_skb_ext_tc_ovs_enabled() static_branch_unlikely(&tc_skb_ext_tc_ovs)
+#else /* CONFIG_NET_CLS_ACT */
+static inline void tc_skb_ext_tc_ovs_enable(void) { }
+static inline void tc_skb_ext_tc_ovs_disable(void) { }
+#define tc_skb_ext_tc_ovs_enabled() false
+#endif
+
 #endif
diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 67ad08320886..4c73a768abc5 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -37,6 +37,7 @@
 #include <net/genetlink.h>
 #include <net/net_namespace.h>
 #include <net/netns/generic.h>
+#include <net/pkt_cls.h>
 
 #include "datapath.h"
 #include "flow.h"
@@ -1601,8 +1602,6 @@ static void ovs_dp_reset_user_features(struct sk_buff *skb,
 	dp->user_features = 0;
 }
 
-DEFINE_STATIC_KEY_FALSE(tc_recirc_sharing_support);
-
 static int ovs_dp_set_upcall_portids(struct datapath *dp,
 			      const struct nlattr *ids)
 {
@@ -1657,7 +1656,7 @@ u32 ovs_dp_get_upcall_portid(const struct datapath *dp, uint32_t cpu_id)
 
 static int ovs_dp_change(struct datapath *dp, struct nlattr *a[])
 {
-	u32 user_features = 0;
+	u32 user_features = 0, old_features = dp->user_features;
 	int err;
 
 	if (a[OVS_DP_ATTR_USER_FEATURES]) {
@@ -1696,10 +1695,12 @@ static int ovs_dp_change(struct datapath *dp, struct nlattr *a[])
 			return err;
 	}
 
-	if (dp->user_features & OVS_DP_F_TC_RECIRC_SHARING)
-		static_branch_enable(&tc_recirc_sharing_support);
-	else
-		static_branch_disable(&tc_recirc_sharing_support);
+	if ((dp->user_features & OVS_DP_F_TC_RECIRC_SHARING) &&
+	    !(old_features & OVS_DP_F_TC_RECIRC_SHARING))
+		tc_skb_ext_tc_ovs_enable();
+	else if (!(dp->user_features & OVS_DP_F_TC_RECIRC_SHARING) &&
+		 (old_features & OVS_DP_F_TC_RECIRC_SHARING))
+		tc_skb_ext_tc_ovs_disable();
 
 	return 0;
 }
@@ -1839,6 +1840,9 @@ static void __dp_destroy(struct datapath *dp)
 	struct flow_table *table = &dp->table;
 	int i;
 
+	if (dp->user_features & OVS_DP_F_TC_RECIRC_SHARING)
+		tc_skb_ext_tc_ovs_disable();
+
 	for (i = 0; i < DP_VPORT_HASH_BUCKETS; i++) {
 		struct vport *vport;
 		struct hlist_node *n;
diff --git a/net/openvswitch/datapath.h b/net/openvswitch/datapath.h
index fcfe6cb46441..0cd29971a907 100644
--- a/net/openvswitch/datapath.h
+++ b/net/openvswitch/datapath.h
@@ -253,8 +253,6 @@ static inline struct datapath *get_dp(struct net *net, int dp_ifindex)
 extern struct notifier_block ovs_dp_device_notifier;
 extern struct genl_family dp_vport_genl_family;
 
-DECLARE_STATIC_KEY_FALSE(tc_recirc_sharing_support);
-
 void ovs_dp_process_packet(struct sk_buff *skb, struct sw_flow_key *key);
 void ovs_dp_detach_port(struct vport *);
 int ovs_dp_upcall(struct datapath *, struct sk_buff *,
diff --git a/net/openvswitch/flow.c b/net/openvswitch/flow.c
index 02096f2ec678..5839b00c99bc 100644
--- a/net/openvswitch/flow.c
+++ b/net/openvswitch/flow.c
@@ -34,6 +34,7 @@
 #include <net/mpls.h>
 #include <net/ndisc.h>
 #include <net/nsh.h>
+#include <net/pkt_cls.h>
 #include <net/netfilter/nf_conntrack_zones.h>
 
 #include "conntrack.h"
@@ -895,7 +896,7 @@ int ovs_flow_key_extract(const struct ip_tunnel_info *tun_info,
 	key->mac_proto = res;
 
 #if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
-	if (static_branch_unlikely(&tc_recirc_sharing_support)) {
+	if (tc_skb_ext_tc_ovs_enabled()) {
 		tc_ext = skb_ext_find(skb, TC_SKB_EXT);
 		key->recirc_id = tc_ext ? tc_ext->chain : 0;
 		OVS_CB(skb)->mru = tc_ext ? tc_ext->mru : 0;
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index d4e27c679123..781dbabdb0df 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -49,6 +49,23 @@ static LIST_HEAD(tcf_proto_base);
 /* Protects list of registered TC modules. It is pure SMP lock. */
 static DEFINE_RWLOCK(cls_mod_lock);
 
+#ifdef CONFIG_NET_CLS_ACT
+DEFINE_STATIC_KEY_FALSE(tc_skb_ext_tc_ovs);
+EXPORT_SYMBOL(tc_skb_ext_tc_ovs);
+
+void tc_skb_ext_tc_ovs_enable(void)
+{
+	static_branch_inc(&tc_skb_ext_tc_ovs);
+}
+EXPORT_SYMBOL(tc_skb_ext_tc_ovs_enable);
+
+void tc_skb_ext_tc_ovs_disable(void)
+{
+	static_branch_dec(&tc_skb_ext_tc_ovs);
+}
+EXPORT_SYMBOL(tc_skb_ext_tc_ovs_disable);
+#endif
+
 static u32 destroy_obj_hashfn(const struct tcf_proto *tp)
 {
 	return jhash_3words(tp->chain->index, tp->prio,
@@ -1615,19 +1632,21 @@ int tcf_classify(struct sk_buff *skb,
 	ret = __tcf_classify(skb, tp, orig_tp, res, compat_mode,
 			     &last_executed_chain);
 
-	/* If we missed on some chain */
-	if (ret == TC_ACT_UNSPEC && last_executed_chain) {
-		struct tc_skb_cb *cb = tc_skb_cb(skb);
-
-		ext = tc_skb_ext_alloc(skb);
-		if (WARN_ON_ONCE(!ext))
-			return TC_ACT_SHOT;
-		ext->chain = last_executed_chain;
-		ext->mru = cb->mru;
-		ext->post_ct = cb->post_ct;
-		ext->post_ct_snat = cb->post_ct_snat;
-		ext->post_ct_dnat = cb->post_ct_dnat;
-		ext->zone = cb->zone;
+	if (tc_skb_ext_tc_ovs_enabled()) {
+		/* If we missed on some chain */
+		if (ret == TC_ACT_UNSPEC && last_executed_chain) {
+			struct tc_skb_cb *cb = tc_skb_cb(skb);
+
+			ext = tc_skb_ext_alloc(skb);
+			if (WARN_ON_ONCE(!ext))
+				return TC_ACT_SHOT;
+			ext->chain = last_executed_chain;
+			ext->mru = cb->mru;
+			ext->post_ct = cb->post_ct;
+			ext->post_ct_snat = cb->post_ct_snat;
+			ext->post_ct_dnat = cb->post_ct_dnat;
+			ext->zone = cb->zone;
+		}
 	}
 
 	return ret;
-- 
2.30.1

