Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDFE14830B0
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 12:45:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231671AbiACLpI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 06:45:08 -0500
Received: from mail-bn7nam10on2072.outbound.protection.outlook.com ([40.107.92.72]:22401
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229788AbiACLpG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jan 2022 06:45:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nsnxtebOSu7EOUNjZgZLt6yHyHVegR5B0l1RlJn2NbypbCn+D55Vfntr+2jDy0CIGKSGaMRh4jUVq4QACHNA0Xc43SjiVZ+0HNbpczV/ph3eHPC3Ll6waahDJHvHvuue4OYEVj/IhWDmr0ZCpiXLEhFRUv/SWAHkdmJYSVw7O5g6zuV237+3baXSb3uaIj5zkIcSAae6+S2GkXmHaMxBYq7SJzu8/35oFmoIG6zG8KuJk1Gnf8et7rexUyakG2WXIQqblAiHg3PpKDpShIET7egSMIcwB/nRmMBXwhXOcH9TJlmppnZD700+FyUetL+WGASqnLOYVKS2s0EeRSRkYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F3SJBsHeXDsRQmalvxRUU8i2NXM6ouqLD1RV6Y5qqcI=;
 b=dN+YxipHiG+kEmxkh7vpsFaqM3bKAEpvaGsvggzjTPxQSRRYU2AQjV4s9taSDlp/MoyBvmXCVUqnc2NbgD3R9MjwV6bSD20pye4mQCpw7Kkr/bSr1zQSyjhtJ6kuQPIUIIPy2A1BodX80xXidYA5VP8wT4B2xuPJpfjtvNlIkwo5LUMUBsc2dx8gHi7FVibl8wHwwqbgjpPeJwFmHhS/2aeJdEnIHuSfaslf2cPH99U20FIwevFFfTBuD7BBOzSeqQz9WQaW7Zli1LwvksRlkEieiCGRGrh1Eq3u1dZR3m/y0dC1b8+gUDBpiKjauQgGyQiuMAz4FnhC1EtQ/z55Fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=ovn.org smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F3SJBsHeXDsRQmalvxRUU8i2NXM6ouqLD1RV6Y5qqcI=;
 b=B345/7HBkrWm7ZXrFCVxHatG4HT4bowORNPgNUyUKk4UFHHB6iGPrDkms+hX3BaYznrm1JiwkwYX1HpLO2TUxNluI8v0jxlgI8n2YdVqVG1lQZqBqERLAZBOryffyLhgf5O0jwVGWfD4J8Rs26DkOZJycRL9UCroU6hLfGe/pkm4Z0Mbr6mXwRRlcANsaRvBXLmnmBeYQd4ORPis5sVWJmPlL7a3Vj2DuqEDcFSDWuY3j+6wRBR4vcwFpDhPPvA3b9vRkRzzr1uCNG3KDQRsC+PzyCcUvu5/9w00D8xe4iWL00XKlyx7Td7PFPOvMPSbpM5NsZQB+nyGenRQZNl/5Q==
Received: from BN6PR16CA0025.namprd16.prod.outlook.com (2603:10b6:405:14::11)
 by DM6PR12MB4944.namprd12.prod.outlook.com (2603:10b6:5:1ba::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.14; Mon, 3 Jan
 2022 11:45:03 +0000
Received: from BN8NAM11FT052.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:14:cafe::c6) by BN6PR16CA0025.outlook.office365.com
 (2603:10b6:405:14::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.14 via Frontend
 Transport; Mon, 3 Jan 2022 11:45:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 BN8NAM11FT052.mail.protection.outlook.com (10.13.177.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4844.14 via Frontend Transport; Mon, 3 Jan 2022 11:45:03 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 3 Jan
 2022 11:45:02 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 3 Jan
 2022 11:45:02 +0000
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (172.20.187.6) by
 mail.nvidia.com (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.18
 via Frontend Transport; Mon, 3 Jan 2022 11:44:59 +0000
From:   Paul Blakey <paulb@nvidia.com>
To:     Paul Blakey <paulb@nvidia.com>, <dev@openvswitch.org>,
        <netdev@vger.kernel.org>, Saeed Mahameed <saeedm@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "Pravin B Shelar" <pshelar@ovn.org>, <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
CC:     Oz Shlomo <ozsh@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Roi Dayan <roid@nvidia.com>
Subject: [PATCH net-next 1/3] net/sched: act_ct: Fill offloading tuple iifidx
Date:   Mon, 3 Jan 2022 13:44:50 +0200
Message-ID: <20220103114452.406-2-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20220103114452.406-1-paulb@nvidia.com>
References: <20220103114452.406-1-paulb@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3a4e22a4-c504-4a0d-b4fe-08d9ceae7b36
X-MS-TrafficTypeDiagnostic: DM6PR12MB4944:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB4944FE7D925239580693341EC2499@DM6PR12MB4944.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:189;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /T+SJJSbjh75QQwaJ+ERrCK3yu8GXRtrwB6fs+S+TTtwUk01kjYpTN0mLA+DLkZpjKMYHHmpYVtGScQRx/Ned2Z4TQfxGsbnmaU4hEcg206qhR+F47fY4h4PBlVBG4e4MY0p/cFjIoCG6YNFWC7svUKP/Sone+o5+QTmRVtd3FPfrH1lUSxq9Uh0//OuOIGoXAwikvxCQWdwMVKohfs1KjYPjS0ojMOKRwxHrUWH8dkuHRzs+wq5hyfHxcFzvlnCYRsSD0QrCnJFTtXz0fxttvBbU2FzVuMnJ2TwjUbqnDtmVg7DM5Ix4HIEEnHh+RZ4ZOkWkPPBaeEcPLxj83t5UaX4BZH5xvkQm8LVqsrHpc95Z8T7QjwTK0w1BWl0UYDW07WXWc0zHIuGgwFSIN5QzA5aC0TmcZzpcTh7h5NzKxSuv5O69+gU0342SiLeupujHmtLbkMgkacOnLCjHFU8wMqEL+Q8+YtSG36U7sQzc130vIRE9u4ays38gwhfZltTw9l7RGFIFvSKhxVH2d0x2AgXnp6Sjcf02Dw49gf67U6LDfc7bEoD+P8xKO6WTi6d79hMMRSf/o45zxbvdqnWeo7Oy45PwgyfnXoU3n9HYxiHSbIQFzjOufY0Q/nRS4XaJjBMqMAZ0LrfZc7V5LjIOCqXV8TKeqDggkJb9jNkcB7jFM2UgtmcC3dH4wZqJOzx/hWOY02t7c42n8rBJvg4XbTZDtak6xRnPSYt+p5gPGYhx6ES7pvRAQQ0B/rHvv/KG7WuQrey1zOatK7h2lpAWwyurokia1G/nWmDTAiRj1TfL75OhQHQUjhZJIrhzucz
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(46966006)(40470700002)(36840700001)(26005)(186003)(70586007)(81166007)(5660300002)(8676002)(70206006)(316002)(6666004)(508600001)(4326008)(8936002)(107886003)(2616005)(54906003)(336012)(36860700001)(426003)(2906002)(110136005)(36756003)(1076003)(921005)(86362001)(83380400001)(47076005)(82310400004)(356005)(40460700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jan 2022 11:45:03.4575
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a4e22a4-c504-4a0d-b4fe-08d9ceae7b36
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT052.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4944
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Driver offloading ct tuples can use the information of which devices
received the packets that created the offloaded connections, to
more efficiently offload them only to the relevant device.

Add new act_ct nf conntrack extension, which is used to store the skb
devices before offloading the connection, and then fill in the tuple
iifindex so drivers can get the device via metadata dissector match.

Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
Signed-off-by: Paul Blakey <paulb@nvidia.com>
---
 include/net/netfilter/nf_conntrack_act_ct.h | 50 +++++++++++++++++++++
 include/net/netfilter/nf_conntrack_extend.h |  4 ++
 net/netfilter/nf_conntrack_core.c           |  6 ++-
 net/sched/act_ct.c                          | 27 +++++++++++
 4 files changed, 86 insertions(+), 1 deletion(-)
 create mode 100644 include/net/netfilter/nf_conntrack_act_ct.h

diff --git a/include/net/netfilter/nf_conntrack_act_ct.h b/include/net/netfilter/nf_conntrack_act_ct.h
new file mode 100644
index 000000000000..078d3c52c03f
--- /dev/null
+++ b/include/net/netfilter/nf_conntrack_act_ct.h
@@ -0,0 +1,50 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef _NF_CONNTRACK_ACT_CT_H
+#define _NF_CONNTRACK_ACT_CT_H
+
+#include <net/netfilter/nf_conntrack.h>
+#include <linux/netfilter/nf_conntrack_common.h>
+#include <net/netfilter/nf_conntrack_extend.h>
+
+struct nf_conn_act_ct_ext {
+	int ifindex[IP_CT_DIR_MAX];
+};
+
+static inline struct nf_conn_act_ct_ext *nf_conn_act_ct_ext_find(const struct nf_conn *ct)
+{
+#if IS_ENABLED(CONFIG_NET_ACT_CT)
+	return nf_ct_ext_find(ct, NF_CT_EXT_ACT_CT);
+#else
+	return NULL;
+#endif
+}
+
+static inline struct nf_conn_act_ct_ext *nf_conn_act_ct_ext_add(struct nf_conn *ct)
+{
+#if IS_ENABLED(CONFIG_NET_ACT_CT)
+	struct nf_conn_act_ct_ext *act_ct = nf_ct_ext_find(ct, NF_CT_EXT_ACT_CT);
+
+	if (act_ct)
+		return act_ct;
+
+	act_ct = nf_ct_ext_add(ct, NF_CT_EXT_ACT_CT, GFP_ATOMIC);
+	return act_ct;
+#else
+	return NULL;
+#endif
+}
+
+static inline void nf_conn_act_ct_ext_fill(struct sk_buff *skb, struct nf_conn *ct,
+					   enum ip_conntrack_info ctinfo)
+{
+#if IS_ENABLED(CONFIG_NET_ACT_CT)
+	struct nf_conn_act_ct_ext *act_ct_ext;
+
+	act_ct_ext = nf_conn_act_ct_ext_find(ct);
+	if (dev_net(skb->dev) == &init_net && act_ct_ext)
+		act_ct_ext->ifindex[CTINFO2DIR(ctinfo)] = skb->dev->ifindex;
+#endif
+}
+
+#endif /* _NF_CONNTRACK_ACT_CT_H */
diff --git a/include/net/netfilter/nf_conntrack_extend.h b/include/net/netfilter/nf_conntrack_extend.h
index e1e588387103..c7515d82ab06 100644
--- a/include/net/netfilter/nf_conntrack_extend.h
+++ b/include/net/netfilter/nf_conntrack_extend.h
@@ -27,6 +27,9 @@ enum nf_ct_ext_id {
 #endif
 #if IS_ENABLED(CONFIG_NETFILTER_SYNPROXY)
 	NF_CT_EXT_SYNPROXY,
+#endif
+#if IS_ENABLED(CONFIG_NET_ACT_CT)
+	NF_CT_EXT_ACT_CT,
 #endif
 	NF_CT_EXT_NUM,
 };
@@ -40,6 +43,7 @@ enum nf_ct_ext_id {
 #define NF_CT_EXT_TIMEOUT_TYPE struct nf_conn_timeout
 #define NF_CT_EXT_LABELS_TYPE struct nf_conn_labels
 #define NF_CT_EXT_SYNPROXY_TYPE struct nf_conn_synproxy
+#define NF_CT_EXT_ACT_CT_TYPE struct nf_conn_act_ct_ext
 
 /* Extensions: optional stuff which isn't permanently in struct. */
 struct nf_ct_ext {
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index d7e313548066..01d6589fba6e 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -47,6 +47,7 @@
 #include <net/netfilter/nf_conntrack_timeout.h>
 #include <net/netfilter/nf_conntrack_labels.h>
 #include <net/netfilter/nf_conntrack_synproxy.h>
+#include <net/netfilter/nf_conntrack_act_ct.h>
 #include <net/netfilter/nf_nat.h>
 #include <net/netfilter/nf_nat_helper.h>
 #include <net/netns/hash.h>
@@ -2626,7 +2627,7 @@ int nf_conntrack_set_hashsize(const char *val, const struct kernel_param *kp)
 static __always_inline unsigned int total_extension_size(void)
 {
 	/* remember to add new extensions below */
-	BUILD_BUG_ON(NF_CT_EXT_NUM > 9);
+	BUILD_BUG_ON(NF_CT_EXT_NUM > 10);
 
 	return sizeof(struct nf_ct_ext) +
 	       sizeof(struct nf_conn_help)
@@ -2649,6 +2650,9 @@ static __always_inline unsigned int total_extension_size(void)
 #endif
 #if IS_ENABLED(CONFIG_NETFILTER_SYNPROXY)
 		+ sizeof(struct nf_conn_synproxy)
+#endif
+#if IS_ENABLED(CONFIG_NET_ACT_CT)
+		+ sizeof(struct nf_conn_act_ct_ext)
 #endif
 	;
 };
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index f9afb5abff21..ebdf7caf7084 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -32,6 +32,7 @@
 #include <net/netfilter/nf_conntrack_helper.h>
 #include <net/netfilter/nf_conntrack_acct.h>
 #include <net/netfilter/ipv6/nf_defrag_ipv6.h>
+#include <net/netfilter/nf_conntrack_act_ct.h>
 #include <uapi/linux/netfilter/nf_nat.h>
 
 static struct workqueue_struct *act_ct_wq;
@@ -56,6 +57,12 @@ static const struct rhashtable_params zones_params = {
 	.automatic_shrinking = true,
 };
 
+static struct nf_ct_ext_type act_ct_extend __read_mostly = {
+	.len		= sizeof(struct nf_conn_act_ct_ext),
+	.align		= __alignof__(struct nf_conn_act_ct_ext),
+	.id		= NF_CT_EXT_ACT_CT,
+};
+
 static struct flow_action_entry *
 tcf_ct_flow_table_flow_action_get_next(struct flow_action *flow_action)
 {
@@ -358,6 +365,7 @@ static void tcf_ct_flow_table_add(struct tcf_ct_flow_table *ct_ft,
 				  struct nf_conn *ct,
 				  bool tcp)
 {
+	struct nf_conn_act_ct_ext *act_ct_ext;
 	struct flow_offload *entry;
 	int err;
 
@@ -375,6 +383,14 @@ static void tcf_ct_flow_table_add(struct tcf_ct_flow_table *ct_ft,
 		ct->proto.tcp.seen[1].flags |= IP_CT_TCP_FLAG_BE_LIBERAL;
 	}
 
+	act_ct_ext = nf_conn_act_ct_ext_find(ct);
+	if (act_ct_ext) {
+		entry->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.iifidx =
+			act_ct_ext->ifindex[IP_CT_DIR_ORIGINAL];
+		entry->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.iifidx =
+			act_ct_ext->ifindex[IP_CT_DIR_REPLY];
+	}
+
 	err = flow_offload_add(&ct_ft->nf_ft, entry);
 	if (err)
 		goto err_add;
@@ -1027,6 +1043,7 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
 	if (!ct)
 		goto out_push;
 	nf_ct_deliver_cached_events(ct);
+	nf_conn_act_ct_ext_fill(skb, ct, ctinfo);
 
 	err = tcf_ct_act_nat(skb, ct, ctinfo, p->ct_action, &p->range, commit);
 	if (err != NF_ACCEPT)
@@ -1036,6 +1053,9 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
 		tcf_ct_act_set_mark(ct, p->mark, p->mark_mask);
 		tcf_ct_act_set_labels(ct, p->labels, p->labels_mask);
 
+		if (!nf_ct_is_confirmed(ct))
+			nf_conn_act_ct_ext_add(ct);
+
 		/* This will take care of sending queued events
 		 * even if the connection is already confirmed.
 		 */
@@ -1583,10 +1603,16 @@ static int __init ct_init_module(void)
 	if (err)
 		goto err_register;
 
+	err = nf_ct_extend_register(&act_ct_extend);
+	if (err)
+		goto err_register_extend;
+
 	static_branch_inc(&tcf_frag_xmit_count);
 
 	return 0;
 
+err_register_extend:
+	tcf_unregister_action(&act_ct_ops, &ct_net_ops);
 err_register:
 	tcf_ct_flow_tables_uninit();
 err_tbl_init:
@@ -1597,6 +1623,7 @@ static int __init ct_init_module(void)
 static void __exit ct_cleanup_module(void)
 {
 	static_branch_dec(&tcf_frag_xmit_count);
+	nf_ct_extend_unregister(&act_ct_extend);
 	tcf_unregister_action(&act_ct_ops, &ct_net_ops);
 	tcf_ct_flow_tables_uninit();
 	destroy_workqueue(act_ct_wq);
-- 
2.30.1

