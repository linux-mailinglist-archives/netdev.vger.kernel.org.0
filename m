Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ABFD4A808F
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 09:44:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349559AbiBCIok (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 03:44:40 -0500
Received: from mail-mw2nam10on2043.outbound.protection.outlook.com ([40.107.94.43]:18400
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229696AbiBCIoi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Feb 2022 03:44:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nr0pGEhNyM9w0YZ6f3fkBfVKw1Hgj26Z4MjdVq97tuxV7jYt0h1U6Hm6Hhpmyxus8d0GDQHQceICR9Q6GOOzn8ucLJg3WFbkMu00P05YbEoANgD4YxsoH0GmNAnEUmFtcYBVU2scthUEoUcItWg+wUHHqfxzsu03g2UjM1SpxfBXvZ7SgogiKNBNskorVDYUM4R2loHaWvg3Cy/B9JHK2BcvmiahdK/0J2wciTHLBRzZ6auMsguhXS2wDRoRpYOBoJUPBXuY9Wku8LGO0dIspVgFo4O8qn44m+WQInCNy2YRAisOgxsBlhoFrSRj1g8R2BsuACu47YyK0ONpNWkeKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NTR0Klhiew34R+Z5aBzKRgZ0tegbFWqZ7DVbNyeU0QM=;
 b=UmK4jGqcjz5+EG1VAkX8kz9zhEMQObbriJhQePjV22li6oCcRSHwlDcLknJosyZIGP3Ov/qL3zxR3LZ0zlajR8fRcWhzYB927yQXNTGqi8oY5qAiUIvY2qOFoy5Ty42qAKKpPFmMT3X7xThWoG/oC361vm6rSJETCxVGb2XtgxCClacGzQOpN6sCKJFyGcqUglmdeQAMknyZPzi2w0PrB7kVzpPJTOMLLVYvhxFBbJ/1r3aOvi1g7NUOgwmcKtFYXiY8PtwoODrlr8aYhKK04OT2xrXWo/eCJ9rf4nW8vANHkuJ17crTfk17kQBgYaiV0QwVAPlOuyovaxBGVAauZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NTR0Klhiew34R+Z5aBzKRgZ0tegbFWqZ7DVbNyeU0QM=;
 b=Y9BcM+fiEFhsKRZOqzyzTs3TsFHWelnFNArXwSw3vyn2lVmEH0uCmAzfM542i8+dbe5gooN4SmaNqH76sxcrG0paSY2DQUtC/+p/mBS0sDadFCFze2nkatnHwmZLlT7ZfAdV2JirAVF+DRCMmUEWAqI69qqshWSzeLrf99zXRFi2xXkwZ9oqzKC9E9GWw6DX7O4bmpxOQMaHku6hft6RGo304HPxxhI6+t9UER67sivlptm5VoY9M0m5jVWsz9qvpLzA5TnmOJuub5mK3OY3roFJSsmdK1yI1/B47hhUryMncJgW2RaE0KmrlGJ6LrHmsSWe9qx8vZ/QChpbmgHg9A==
Received: from DM6PR02CA0089.namprd02.prod.outlook.com (2603:10b6:5:1f4::30)
 by CH0PR12MB5121.namprd12.prod.outlook.com (2603:10b6:610:bc::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Thu, 3 Feb
 2022 08:44:36 +0000
Received: from DM6NAM11FT052.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1f4:cafe::1a) by DM6PR02CA0089.outlook.office365.com
 (2603:10b6:5:1f4::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12 via Frontend
 Transport; Thu, 3 Feb 2022 08:44:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT052.mail.protection.outlook.com (10.13.172.111) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4951.12 via Frontend Transport; Thu, 3 Feb 2022 08:44:36 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 3 Feb
 2022 08:44:35 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Thu, 3 Feb 2022
 00:44:35 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.7) with Microsoft SMTP Server id 15.2.986.9 via
 Frontend Transport; Thu, 3 Feb 2022 00:44:31 -0800
From:   Paul Blakey <paulb@nvidia.com>
To:     Paul Blakey <paulb@nvidia.com>, <dev@openvswitch.org>,
        <netdev@vger.kernel.org>, Cong Wang <xiyou.wangcong@gmail.com>,
        "Jamal Hadi Salim" <jhs@mojatatu.com>,
        Pravin B Shelar <pshelar@ovn.org>, <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
CC:     Saeed Mahameed <saeedm@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        "Vlad Buslov" <vladbu@nvidia.com>, Roi Dayan <roid@nvidia.com>
Subject: [PATCH net-next v3 1/1] net/sched: Enable tc skb ext allocation on chain miss only when needed
Date:   Thu, 3 Feb 2022 10:44:30 +0200
Message-ID: <20220203084430.25339-1-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5a11663d-121e-402b-2e3d-08d9e6f16894
X-MS-TrafficTypeDiagnostic: CH0PR12MB5121:EE_
X-Microsoft-Antispam-PRVS: <CH0PR12MB51218A86B7C9138086E5A5C5C2289@CH0PR12MB5121.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7CZymIy2BXbOSdjFoZvjShfANEIaeo2siSHkByDYlTNN1nYlDZBBjXk5gL6h+Iu5AjJFCjM2e6dOpOWsy3Cf9JY47nG3Y8hA5PPzL19d3g0GE+I/YxMVn1gKhxxKT3tFUDKwaxA9wQQoZXBAmbci+yHyhHr32DQVubhab1CoyEN20a31wOCc6RRUiw68Fvhx+7mB060OFm26DFG1pJF5f5KnRk52XrBoTnYTH2H7QsISea6z1v6rMb8P1lvv/pr/J9hl9tppGdt2ZWtsPl0W3C37xuj+Ko33dhrvtQk7zHtBcO5qggG+tzI3OFmNjFXP47Rl/ihg6/piB3bu/MVzq/Caf4r+uLSOOj4gmWEIQWFMzMykAXZdca6yOW3ItQhB7B8Dkkru11bWsT2JvrkBPMtZNNDlG7ItV6ILYPpRNwzsSxvvFI2KmLJY6+07eHfIdeIgWYRs6HO5yvEpTLnfr9duM/gFfO0SSvixrVtltiFAYkbIupNoC6RHyenVNu7CmQdGELWwiNS6H20z4jp0CxTlxWi9S41ZBObD1H587NXAAckHE8bl83Zt35DGiaioOhnTydeVSWNHL4zexIQDehucsgabZ8XS9FmR7kP6jINOsrHoTDIsWgunrRa/fmH/j7dtVNz4xAApHSSpEH+rhsmjlMiwCPOJdMEpIj+nCt0j3qviwvr6N+2woAxKxDfxsjk1o7PWd+FSOPwVaP9FiUw8IEj1VNXXy8AIp4WJRKI=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(54906003)(508600001)(36860700001)(86362001)(110136005)(316002)(47076005)(40460700003)(36756003)(426003)(336012)(921005)(26005)(186003)(1076003)(70206006)(83380400001)(70586007)(82310400004)(8676002)(8936002)(2906002)(2616005)(4326008)(356005)(5660300002)(107886003)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2022 08:44:36.4434
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a11663d-121e-402b-2e3d-08d9e6f16894
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT052.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5121
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently tc skb extension is used to send miss info from
tc to ovs datapath module, and driver to tc. For the tc to ovs
miss it is currently always allocated even if it will not
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
   v2->v3:
     Renamed funcs 's/tc_skb_ext_tc_ovs/tc_skb_ext_tc/'

 include/net/pkt_cls.h      | 11 ++++++++++
 net/openvswitch/datapath.c | 18 +++++++++------
 net/openvswitch/datapath.h |  2 --
 net/openvswitch/flow.c     |  3 ++-
 net/sched/cls_api.c        | 45 +++++++++++++++++++++++++++-----------
 5 files changed, 56 insertions(+), 23 deletions(-)

diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 676cb8ea9e15..a3b57a93228a 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -1028,4 +1028,15 @@ struct tc_fifo_qopt_offload {
 	};
 };
 
+#ifdef CONFIG_NET_CLS_ACT
+DECLARE_STATIC_KEY_FALSE(tc_skb_ext_tc);
+void tc_skb_ext_tc_enable(void);
+void tc_skb_ext_tc_disable(void);
+#define tc_skb_ext_tc_enabled() static_branch_unlikely(&tc_skb_ext_tc)
+#else /* CONFIG_NET_CLS_ACT */
+static inline void tc_skb_ext_tc_enable(void) { }
+static inline void tc_skb_ext_tc_disable(void) { }
+#define tc_skb_ext_tc_enabled() false
+#endif
+
 #endif
diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 67ad08320886..7e8a39a35627 100644
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
+		tc_skb_ext_tc_enable();
+	else if (!(dp->user_features & OVS_DP_F_TC_RECIRC_SHARING) &&
+		 (old_features & OVS_DP_F_TC_RECIRC_SHARING))
+		tc_skb_ext_tc_disable();
 
 	return 0;
 }
@@ -1839,6 +1840,9 @@ static void __dp_destroy(struct datapath *dp)
 	struct flow_table *table = &dp->table;
 	int i;
 
+	if (dp->user_features & OVS_DP_F_TC_RECIRC_SHARING)
+		tc_skb_ext_tc_disable();
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
index 02096f2ec678..f6cd24fd530c 100644
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
+	if (tc_skb_ext_tc_enabled()) {
 		tc_ext = skb_ext_find(skb, TC_SKB_EXT);
 		key->recirc_id = tc_ext ? tc_ext->chain : 0;
 		OVS_CB(skb)->mru = tc_ext ? tc_ext->mru : 0;
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index d4e27c679123..29af45964b99 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -49,6 +49,23 @@ static LIST_HEAD(tcf_proto_base);
 /* Protects list of registered TC modules. It is pure SMP lock. */
 static DEFINE_RWLOCK(cls_mod_lock);
 
+#ifdef CONFIG_NET_CLS_ACT
+DEFINE_STATIC_KEY_FALSE(tc_skb_ext_tc);
+EXPORT_SYMBOL(tc_skb_ext_tc);
+
+void tc_skb_ext_tc_enable(void)
+{
+	static_branch_inc(&tc_skb_ext_tc);
+}
+EXPORT_SYMBOL(tc_skb_ext_tc_enable);
+
+void tc_skb_ext_tc_disable(void)
+{
+	static_branch_dec(&tc_skb_ext_tc);
+}
+EXPORT_SYMBOL(tc_skb_ext_tc_disable);
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
+	if (tc_skb_ext_tc_enabled()) {
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

