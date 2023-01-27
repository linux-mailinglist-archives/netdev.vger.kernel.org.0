Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07D8767EDB5
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 19:39:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234326AbjA0Sjh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 13:39:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235125AbjA0Sj0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 13:39:26 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2067.outbound.protection.outlook.com [40.107.220.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FAF8A25E;
        Fri, 27 Jan 2023 10:39:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y+MUr+Chg62AS9DgVJf9gtoFF17LuVI7LOcazZdoqcchZOeaGYP9o2EvMoUXb4q3EfBikoKva9BcoznVLNq0/gtvdgcEEwwgTFr+i6xvaVHR1mBcnAV03AQmhfZz1SrW487LiVTzz2Bfp9zap2EtF41RKDonDN9ZCLhzKqjmjwXsQ2VslrULrmDIz60LM2RkvOHQKbkqPUfAhysvQUyJav/s23sZFvOMEh1Bfy0MlrSgZhe3kF2a386YPCGJ6gmuw2BuYacw566INU0a0t0v2ZOhU6J4xYLHXYH1ARJ7uJSz+WzLMe2NBVU2usVzUlWnZ+9ARdFhwS8AZgE+I7M+3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6hRCCIrcOIvrOs9yZYI2nP2cP9hmUlhGTKjvzGb2BZs=;
 b=PopgrspVIWM5zsr+54jte2mL9ExGT4kgzXk6BzfEn+jD3gZClF2k0uK77naQG9cFFY26cLsSDv4RDLGAirDko3QaBtuQmYSdplw/8/9oNPAjs8RNCz4332mkrs6z+/Y1rraTh/c7KCsjX+MyllNKpQy1zWqShbQeJgoCWiplmqGNLf6Uso2k9fkpAtpBYVx+jU5Z9KLNzRaxoaYj3GEe2YvYzrAKv/4hlM1st14RCaMUwr8tWmA9oTyONOFsk12kgN34H4C+1ugtwaQi3RdhEAcEeOWAX8p+j3f/tIFMn21FwgbegloiQ9Gtmxtkfs419sTrRg2Ez5ZGXWcItZNGQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6hRCCIrcOIvrOs9yZYI2nP2cP9hmUlhGTKjvzGb2BZs=;
 b=C0CY1keEVo4FAKrLsXLtjPGK0kJqgJ9KOZFfIHnWO0NOXHj2SNyGOd1KxNde+D2Mw9+9CC4K1JMzTJpE/AhcRZP6K9Ic8bP4IlBMmJ95KSRMe49s/9KnZnCiv8amQCXvflPfRz+nPv1IaRNQvizzRZmFM3cnxtDJDitNesrvCRhK0Q9xbUpKlahFR42nli/bOt84lnf9isZVZsnKZtRr3aTC9m0XUZX0fSDpdjuSV8u95UXNp/+d4Qwecn8WR4upTjdcN+1Z6INzn2yj2c9SAflEIb+8ffUijlWHv68jVaFuE14HHsU8WmgvcoreDXTdonWqESJy29eckS06egkWag==
Received: from BN0PR02CA0031.namprd02.prod.outlook.com (2603:10b6:408:e5::6)
 by BN9PR12MB5291.namprd12.prod.outlook.com (2603:10b6:408:104::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.25; Fri, 27 Jan
 2023 18:39:16 +0000
Received: from BN8NAM11FT044.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e5:cafe::8d) by BN0PR02CA0031.outlook.office365.com
 (2603:10b6:408:e5::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.23 via Frontend
 Transport; Fri, 27 Jan 2023 18:39:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT044.mail.protection.outlook.com (10.13.177.219) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.25 via Frontend Transport; Fri, 27 Jan 2023 18:39:15 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 27 Jan
 2023 10:39:06 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 27 Jan
 2023 10:39:06 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Fri, 27 Jan
 2023 10:39:02 -0800
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <pablo@netfilter.org>
CC:     <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <ozsh@nvidia.com>, <marcelo.leitner@gmail.com>,
        <simon.horman@corigine.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next v5 2/7] netfilter: flowtable: fixup UDP timeout depending on ct state
Date:   Fri, 27 Jan 2023 19:38:40 +0100
Message-ID: <20230127183845.597861-3-vladbu@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230127183845.597861-1-vladbu@nvidia.com>
References: <20230127183845.597861-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT044:EE_|BN9PR12MB5291:EE_
X-MS-Office365-Filtering-Correlation-Id: 44e315ca-84eb-4217-3a8d-08db0095cb0a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +MDlX9DLlSDegHi+2Q/oHUBXS/2OIEoyyZzZBHcyRdMp/Q7c4NWWT4ZsX/xgmXlN380xbUIzQbvbfec4ITOjaOo7MmImK5Ue83XWa9BCO1wj1muGdkHu/WJYITjkNMcyW5VRoFJtgLLLLRYM2tJ/Ar8Js2n24ThxBimaIrsjyh68sKBdrId12ZaXX07aaDQzj46yeq1zCa4lZdMaRDIVlN5EAgCHTU3BDOUK/TUEm9mU/Ed6qt+OJqqby/ZYia5JExvyIgIZavJvXysxsjWnWsB5GD6bdxfdpqmq3MPCyaCuL66Y49r8TW5Zi8ZJYJchMqD6i8U5iQIuXZDpxwqUN8209J/kbhNzpWZgcq5KREx6i6UZLpEfOH033CN6DxaIQs7vxhfgQX/oOoBplZ5uJ2XsciqgtGTj1sVfNJvZJl1OYB1jHTKS8PM9iB4Pfl+TIyDJvPkMgtzWU7Xk2O+pMyqXSbXUEjdVv9hBaTlasw5R4WbImUnmncfi2ze4Xot/ItPh4NCkHfwmrNHP8Nzc+kXMlOwmtqMf9wTzYI6n0x2JC1VXCQSyR7t49kPG7q+PqlFQHw+KnTJfaX5RPENFDRXD2kPNUozaPBOTXqWM+KdvsbcYUqdAnjGL8Ra0GyiooNLqDDkHWV5ve1Z9t58IbnPXdEXC4H/Seg7hI3VQ5VNju5EGSQjXuUT7eJR/3RVyLRr0UA4UhQCEAbT2y0hrQVz+4bP01QlhBO5fmOWSbgw=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(136003)(396003)(346002)(376002)(451199018)(40470700004)(46966006)(36840700001)(7696005)(6666004)(107886003)(478600001)(26005)(1076003)(186003)(7636003)(5660300002)(8676002)(4326008)(70586007)(2906002)(110136005)(54906003)(36860700001)(316002)(2616005)(83380400001)(47076005)(356005)(8936002)(86362001)(41300700001)(40460700003)(70206006)(36756003)(7416002)(82740400003)(82310400005)(426003)(336012)(40480700001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 18:39:15.7754
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 44e315ca-84eb-4217-3a8d-08db0095cb0a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT044.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5291
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently flow_offload_fixup_ct() function assumes that only replied UDP
connections can be offloaded and hardcodes UDP_CT_REPLIED timeout value.
Allow users to modify timeout calculation by implementing new flowtable
type callback 'timeout' and use the existing algorithm otherwise.

To enable UDP NEW connection offload in following patches implement
'timeout' callback in flowtable_ct of act_ct which extracts the actual
connections state from ct->status and set the timeout according to it.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
---

Notes:
    Changes V3 -> V4:
    
    - Rework the patch to decouple netfilter and act_ct timeout fixup
    algorithms.

 include/net/netfilter/nf_flow_table.h |  6 +++-
 net/netfilter/nf_flow_table_core.c    | 40 +++++++++++++++++++--------
 net/netfilter/nf_flow_table_ip.c      | 17 ++++++------
 net/sched/act_ct.c                    | 35 ++++++++++++++++++++++-
 4 files changed, 76 insertions(+), 22 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index cd982f4a0f50..a3e4b5127ad0 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -61,6 +61,9 @@ struct nf_flowtable_type {
 						  enum flow_offload_tuple_dir dir,
 						  struct nf_flow_rule *flow_rule);
 	void				(*free)(struct nf_flowtable *ft);
+	bool				(*timeout)(struct nf_flowtable *ft,
+						   struct flow_offload *flow,
+						   s32 *val);
 	nf_hookfn			*hook;
 	struct module			*owner;
 };
@@ -278,7 +281,8 @@ void nf_flow_table_cleanup(struct net_device *dev);
 int nf_flow_table_init(struct nf_flowtable *flow_table);
 void nf_flow_table_free(struct nf_flowtable *flow_table);
 
-void flow_offload_teardown(struct flow_offload *flow);
+void flow_offload_teardown(struct nf_flowtable *flow_table,
+			   struct flow_offload *flow);
 
 void nf_flow_snat_port(const struct flow_offload *flow,
 		       struct sk_buff *skb, unsigned int thoff,
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 81c26a96c30b..e3eeea349c8d 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -178,28 +178,43 @@ static void flow_offload_fixup_tcp(struct ip_ct_tcp *tcp)
 	tcp->seen[1].td_maxwin = 0;
 }
 
-static void flow_offload_fixup_ct(struct nf_conn *ct)
+static bool flow_offload_timeout_default(struct nf_conn *ct, s32 *timeout)
 {
 	struct net *net = nf_ct_net(ct);
 	int l4num = nf_ct_protonum(ct);
-	s32 timeout;
 
 	if (l4num == IPPROTO_TCP) {
 		struct nf_tcp_net *tn = nf_tcp_pernet(net);
 
 		flow_offload_fixup_tcp(&ct->proto.tcp);
 
-		timeout = tn->timeouts[ct->proto.tcp.state];
-		timeout -= tn->offload_timeout;
+		*timeout = tn->timeouts[ct->proto.tcp.state];
+		*timeout -= tn->offload_timeout;
 	} else if (l4num == IPPROTO_UDP) {
 		struct nf_udp_net *tn = nf_udp_pernet(net);
 
-		timeout = tn->timeouts[UDP_CT_REPLIED];
-		timeout -= tn->offload_timeout;
+		*timeout = tn->timeouts[UDP_CT_REPLIED];
+		*timeout -= tn->offload_timeout;
 	} else {
-		return;
+		return false;
 	}
 
+	return true;
+}
+
+static void flow_offload_fixup_ct(struct nf_flowtable *flow_table,
+				  struct flow_offload *flow)
+{
+	struct nf_conn *ct = flow->ct;
+	bool needs_fixup;
+	s32 timeout;
+
+	needs_fixup = flow_table->type->timeout ?
+		flow_table->type->timeout(flow_table, flow, &timeout) :
+		flow_offload_timeout_default(ct, &timeout);
+	if (!needs_fixup)
+		return;
+
 	if (timeout < 0)
 		timeout = 0;
 
@@ -348,11 +363,12 @@ static void flow_offload_del(struct nf_flowtable *flow_table,
 	flow_offload_free(flow);
 }
 
-void flow_offload_teardown(struct flow_offload *flow)
+void flow_offload_teardown(struct nf_flowtable *flow_table,
+			   struct flow_offload *flow)
 {
 	clear_bit(IPS_OFFLOAD_BIT, &flow->ct->status);
 	set_bit(NF_FLOW_TEARDOWN, &flow->flags);
-	flow_offload_fixup_ct(flow->ct);
+	flow_offload_fixup_ct(flow_table, flow);
 }
 EXPORT_SYMBOL_GPL(flow_offload_teardown);
 
@@ -421,7 +437,7 @@ static void nf_flow_offload_gc_step(struct nf_flowtable *flow_table,
 {
 	if (nf_flow_has_expired(flow) ||
 	    nf_ct_is_dying(flow->ct))
-		flow_offload_teardown(flow);
+		flow_offload_teardown(flow_table, flow);
 
 	if (test_bit(NF_FLOW_TEARDOWN, &flow->flags)) {
 		if (test_bit(NF_FLOW_HW, &flow->flags)) {
@@ -569,14 +585,14 @@ static void nf_flow_table_do_cleanup(struct nf_flowtable *flow_table,
 	struct net_device *dev = data;
 
 	if (!dev) {
-		flow_offload_teardown(flow);
+		flow_offload_teardown(flow_table, flow);
 		return;
 	}
 
 	if (net_eq(nf_ct_net(flow->ct), dev_net(dev)) &&
 	    (flow->tuplehash[0].tuple.iifidx == dev->ifindex ||
 	     flow->tuplehash[1].tuple.iifidx == dev->ifindex))
-		flow_offload_teardown(flow);
+		flow_offload_teardown(flow_table, flow);
 }
 
 void nf_flow_table_gc_cleanup(struct nf_flowtable *flowtable,
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 19efba1e51ef..9c97b9994a96 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -18,7 +18,8 @@
 #include <linux/tcp.h>
 #include <linux/udp.h>
 
-static int nf_flow_state_check(struct flow_offload *flow, int proto,
+static int nf_flow_state_check(struct nf_flowtable *flow_table,
+			       struct flow_offload *flow, int proto,
 			       struct sk_buff *skb, unsigned int thoff)
 {
 	struct tcphdr *tcph;
@@ -28,7 +29,7 @@ static int nf_flow_state_check(struct flow_offload *flow, int proto,
 
 	tcph = (void *)(skb_network_header(skb) + thoff);
 	if (unlikely(tcph->fin || tcph->rst)) {
-		flow_offload_teardown(flow);
+		flow_offload_teardown(flow_table, flow);
 		return -1;
 	}
 
@@ -373,11 +374,11 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 
 	iph = (struct iphdr *)(skb_network_header(skb) + offset);
 	thoff = (iph->ihl * 4) + offset;
-	if (nf_flow_state_check(flow, iph->protocol, skb, thoff))
+	if (nf_flow_state_check(flow_table, flow, iph->protocol, skb, thoff))
 		return NF_ACCEPT;
 
 	if (!nf_flow_dst_check(&tuplehash->tuple)) {
-		flow_offload_teardown(flow);
+		flow_offload_teardown(flow_table, flow);
 		return NF_ACCEPT;
 	}
 
@@ -419,7 +420,7 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 	case FLOW_OFFLOAD_XMIT_DIRECT:
 		ret = nf_flow_queue_xmit(state->net, skb, tuplehash, ETH_P_IP);
 		if (ret == NF_DROP)
-			flow_offload_teardown(flow);
+			flow_offload_teardown(flow_table, flow);
 		break;
 	default:
 		WARN_ON_ONCE(1);
@@ -639,11 +640,11 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 
 	ip6h = (struct ipv6hdr *)(skb_network_header(skb) + offset);
 	thoff = sizeof(*ip6h) + offset;
-	if (nf_flow_state_check(flow, ip6h->nexthdr, skb, thoff))
+	if (nf_flow_state_check(flow_table, flow, ip6h->nexthdr, skb, thoff))
 		return NF_ACCEPT;
 
 	if (!nf_flow_dst_check(&tuplehash->tuple)) {
-		flow_offload_teardown(flow);
+		flow_offload_teardown(flow_table, flow);
 		return NF_ACCEPT;
 	}
 
@@ -684,7 +685,7 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 	case FLOW_OFFLOAD_XMIT_DIRECT:
 		ret = nf_flow_queue_xmit(state->net, skb, tuplehash, ETH_P_IPV6);
 		if (ret == NF_DROP)
-			flow_offload_teardown(flow);
+			flow_offload_teardown(flow_table, flow);
 		break;
 	default:
 		WARN_ON_ONCE(1);
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 0ca2bb8ed026..861305c9c079 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -274,8 +274,41 @@ static int tcf_ct_flow_table_fill_actions(struct net *net,
 	return err;
 }
 
+static bool tcf_ct_flow_table_get_timeout(struct nf_flowtable *ft,
+					  struct flow_offload *flow,
+					  s32 *val)
+{
+	struct nf_conn *ct = flow->ct;
+	int l4num =
+		nf_ct_protonum(ct);
+	struct net *net =
+		nf_ct_net(ct);
+
+	if (l4num == IPPROTO_TCP) {
+		struct nf_tcp_net *tn = nf_tcp_pernet(net);
+
+		ct->proto.tcp.seen[0].td_maxwin = 0;
+		ct->proto.tcp.seen[1].td_maxwin = 0;
+		*val = tn->timeouts[ct->proto.tcp.state];
+		*val -= tn->offload_timeout;
+	} else if (l4num == IPPROTO_UDP) {
+		struct nf_udp_net *tn = nf_udp_pernet(net);
+		enum udp_conntrack state =
+			test_bit(IPS_SEEN_REPLY_BIT, &ct->status) ?
+			UDP_CT_REPLIED : UDP_CT_UNREPLIED;
+
+		*val = tn->timeouts[state];
+		*val -= tn->offload_timeout;
+	} else {
+		return false;
+	}
+
+	return true;
+}
+
 static struct nf_flowtable_type flowtable_ct = {
 	.action		= tcf_ct_flow_table_fill_actions,
+	.timeout	= tcf_ct_flow_table_get_timeout,
 	.owner		= THIS_MODULE,
 };
 
@@ -622,7 +655,7 @@ static bool tcf_ct_flow_table_lookup(struct tcf_ct_params *p,
 	ct = flow->ct;
 
 	if (tcph && (unlikely(tcph->fin || tcph->rst))) {
-		flow_offload_teardown(flow);
+		flow_offload_teardown(nf_ft, flow);
 		return false;
 	}
 
-- 
2.38.1

