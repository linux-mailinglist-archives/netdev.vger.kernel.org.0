Return-Path: <netdev+bounces-9528-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C6CDC7299FA
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 14:29:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 23C141C2112B
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 12:29:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E525A171C2;
	Fri,  9 Jun 2023 12:29:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2359171A4
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 12:29:37 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on20631.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e89::631])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79C2BE50;
	Fri,  9 Jun 2023 05:29:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KLYzy6TQo/fW06i/YFXGtOR3dUZ+3voTLPbXlDBEnMI5omt2IomuEQZgM5/E7Bpdflb83u9r3fAgsk3SViwQSVHQ1FhEOV+HlUY0HzUsMml8NOoS50VCHv/S/ROsHfI4VXqm62OpS7atcXuS+ghWbhllhiDdpJTmuqk95+8GfACnf3gVwhVRR7QTx82GOnU4Qb7rGfMAAKzveqRsgKoa0GPorWYhHN469jkTkDYKw0kx5G/w/wnHglq37ty1bzHCR5cWSxxhWwpLcgDD8zHE3b7BmuH5d/sA7O6QSbtOtcEaTIbaMDIvjltoHH/y/pBOXQyWG4sL+Vbavs56VGOWCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VbjcLNYHdqvve5/tXtRfi+CJMG56Jyfd9G6Pe47K2nI=;
 b=NAnJApCtt7RQOXGAsbuPd+S/u3FJZjLm38mkv5Vh8K7UxPhjjRwz6ro5jbCL5vas/Tc8OuuA7sphC46zwRfafzlm2We24/tSQFerLo9AY+pI9OoTQ3anzzUBpm9uolTF8rUFVQ9hr/Q1AUBngSs4P1BQWo9y1IzsxH7kF5580V6xEvLazkOxbMWVRsRg9aeQ/8FIphTp5eBBMogZg2SgLdT5kxbwg2hDxh5IP3IjUkY+06bM5UBtxQHb+6Z0RyHxM2suNV5rILpFtgKEpzlfLO6xu3jxcKJptrCeGgYn3M+/QzUAW9joyNz21N24/1L8sl5AvR59NevYuzBftTx5NQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=mojatatu.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VbjcLNYHdqvve5/tXtRfi+CJMG56Jyfd9G6Pe47K2nI=;
 b=X5lY6YJLERmdsZ5rP8FoA0jNHE2m9cssUUfZ+RecgF1kMNBdT9BUF2Oc+OaTSzqQ6v9dvFwO469gB0V4QL5+YBzm7XkYELz06H0Qs3ozprAvXKmm8DsF3JR/VSOK4ypjdN2KSzkGOeBisiWZD8vtjmcu5B7qicy6XtLUgR+WXdzJ5339Nx/fN7jI2xWoFx1JajLAtwdaxmyde2yuAE+8t9ndeobgTPP+5udHwBocWekQNpJ4LHoUGvU7d6AIJMC8rNvfpqllfoW47XCsEm8oM9aMzN0Bhv2mbRAgFZm0fYVVoFtNc5hK0wFZjv+4MfTnnHKkWd8g4jkb01+4JmwOww==
Received: from DS7PR05CA0056.namprd05.prod.outlook.com (2603:10b6:8:2f::17) by
 DM4PR12MB6039.namprd12.prod.outlook.com (2603:10b6:8:aa::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.32; Fri, 9 Jun 2023 12:23:30 +0000
Received: from DM6NAM11FT113.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2f:cafe::90) by DS7PR05CA0056.outlook.office365.com
 (2603:10b6:8:2f::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.15 via Frontend
 Transport; Fri, 9 Jun 2023 12:23:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT113.mail.protection.outlook.com (10.13.173.5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6477.29 via Frontend Transport; Fri, 9 Jun 2023 12:23:30 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Fri, 9 Jun 2023
 05:23:17 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Fri, 9 Jun 2023
 05:23:16 -0700
Received: from localhost.localdomain (10.127.8.14) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server id 15.2.986.37 via Frontend
 Transport; Fri, 9 Jun 2023 05:23:11 -0700
From: Paul Blakey <paulb@nvidia.com>
To: Paul Blakey <paulb@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
	<netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Oz Shlomo <ozsh@nvidia.com>, Roi Dayan <roid@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Pablo Neira Ayuso <pablo@netfilter.org>, "Jozsef
 Kadlecsik" <kadlec@netfilter.org>, Florian Westphal <fw@strlen.de>, "David S.
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, "Jakub
 Kicinski" <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Jamal Hadi
 Salim <jhs@mojatatu.com>, Cong Wang <xiyou.wangcong@gmail.com>, Jiri Pirko
	<jiri@resnulli.us>
Subject: [PATCH net 1/1] net/sched: act_ct: Fix promotion of offloaded unreplied tuple
Date: Fri, 9 Jun 2023 15:22:59 +0300
Message-ID: <1686313379-117663-1-git-send-email-paulb@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT113:EE_|DM4PR12MB6039:EE_
X-MS-Office365-Filtering-Correlation-Id: 87d91b50-a4c5-44d7-7bb6-08db68e455a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	CaJPf77nX2GzZsdR0RT8nRF1TK2Mf1ympPU4Lrgd8Nn8ugW6/2V4zzw4jYJ2Ug9KMKeNuRP/2U0fEDXa8I96IEmwi60G8P3RY3pXRx22eWcj2+BXAwaYniWQmnIkYWA3SozD5OrewKD8ZyzUcNV5fOVeDsqiaxAsW/MPStO387t8bal8dPyayiTYwmq0QLAnks0S2RqTRYz2q7M10CWVJYFRKfKol39sOADWiXBrtt/67aIIaF9w1cIAYdK6dXHKs54nz3COouYv7mECVDL2JIkSYlmKve5oQWz6s9KvhB4l8q0MjhbDY+HhHMl5s5yTAUKHo/xwnMS4ScaOyi837VMI2XL8A9jNUDqfXuk3Uo3uANl+8Gl4rdid2nQ7yJB7gDlcEQ+bYeTUCo8+kVaSfv5AhumNuObUR5CEEGvnJBBDcmkbYojUAh708qPUEmdh8fxSe1bc3oJMTKtsqxz8nalXYwbB+JqjX2PhRrI3LbITtHHP+Gv4CScXhnnvlrjKE4AsCMLCMDngR7NEgT2Q8V69KWuPzra9X/CwagMwN/wTkwc0X00kevx2beJAdJYE1mIzm5udkqKepo6i4mTnqKssR+NRFm3aYtrCMdocEkwYzBO5QnF8bxxcNOnw0G2u0xy3gx8NmiGojRVLWe9fC4CdoR/7R9CgHC+fL40MczSiyKVd/oPze3yvnhQN/GOCFZywpwLs5AGGNcABe6OWlbmXycTXYZQa9DH4n2Q5h4hBoWpAyQHxSuKIS2sizH1G
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(39860400002)(376002)(346002)(451199021)(40470700004)(46966006)(36840700001)(54906003)(110136005)(40460700003)(40480700001)(478600001)(7416002)(8676002)(2906002)(8936002)(5660300002)(36756003)(86362001)(70206006)(316002)(82740400003)(70586007)(82310400005)(7636003)(356005)(4326008)(41300700001)(2616005)(36860700001)(47076005)(26005)(83380400001)(186003)(336012)(6666004)(426003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2023 12:23:30.0522
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 87d91b50-a4c5-44d7-7bb6-08db68e455a7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM6NAM11FT113.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6039
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Currently UNREPLIED and UNASSURED connections are added to the nf flow
table. This causes the following connection packets to be processed
by the flow table which then skips conntrack_in(), and thus such the
connections will remain UNREPLIED and UNASSURED even if reply traffic
is then seen. Even still, the unoffloaded reply packets are the ones
triggering hardware update from new to established state, and if
there aren't any to triger an update and/or previous update was
missed, hardware can get out of sync with sw and still mark
packets as new.

Fix the above by:
1) Not skipping conntrack_in() for UNASSURED packets, but still
   refresh for hardware, as before the cited patch.
2) Try and force a refresh by reply-direction packets that update
   the hardware rules from new to established state.
3) Remove any bidirectional flows that didn't failed to update in
   hardware for re-insertion as bidrectional once any new packet
   arrives.

Fixes: 6a9bad0069cf ("net/sched: act_ct: offload UDP NEW connections")
Co-developed-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Paul Blakey <paulb@nvidia.com>
---
 include/net/netfilter/nf_flow_table.h |  2 +-
 net/netfilter/nf_flow_table_core.c    | 13 ++++++++++---
 net/netfilter/nf_flow_table_ip.c      |  4 ++--
 net/sched/act_ct.c                    |  9 ++++++++-
 4 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index ebb28ec5b6fa..f37f9f34430c 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -268,7 +268,7 @@ int flow_offload_route_init(struct flow_offload *flow,
 
 int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow);
 void flow_offload_refresh(struct nf_flowtable *flow_table,
-			  struct flow_offload *flow);
+			  struct flow_offload *flow, bool force);
 
 struct flow_offload_tuple_rhash *flow_offload_lookup(struct nf_flowtable *flow_table,
 						     struct flow_offload_tuple *tuple);
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 04bd0ed4d2ae..b0ef48b21dcb 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -317,12 +317,12 @@ int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow)
 EXPORT_SYMBOL_GPL(flow_offload_add);
 
 void flow_offload_refresh(struct nf_flowtable *flow_table,
-			  struct flow_offload *flow)
+			  struct flow_offload *flow, bool force)
 {
 	u32 timeout;
 
 	timeout = nf_flowtable_time_stamp + flow_offload_get_timeout(flow);
-	if (timeout - READ_ONCE(flow->timeout) > HZ)
+	if (force || timeout - READ_ONCE(flow->timeout) > HZ)
 		WRITE_ONCE(flow->timeout, timeout);
 	else
 		return;
@@ -334,6 +334,12 @@ void flow_offload_refresh(struct nf_flowtable *flow_table,
 }
 EXPORT_SYMBOL_GPL(flow_offload_refresh);
 
+static bool nf_flow_is_outdated(const struct flow_offload *flow)
+{
+	return test_bit(IPS_SEEN_REPLY_BIT, &flow->ct->status) &&
+		!test_bit(NF_FLOW_HW_ESTABLISHED, &flow->flags);
+}
+
 static inline bool nf_flow_has_expired(const struct flow_offload *flow)
 {
 	return nf_flow_timeout_delta(flow->timeout) <= 0;
@@ -423,7 +429,8 @@ static void nf_flow_offload_gc_step(struct nf_flowtable *flow_table,
 				    struct flow_offload *flow, void *data)
 {
 	if (nf_flow_has_expired(flow) ||
-	    nf_ct_is_dying(flow->ct))
+	    nf_ct_is_dying(flow->ct) ||
+	    nf_flow_is_outdated(flow))
 		flow_offload_teardown(flow);
 
 	if (test_bit(NF_FLOW_TEARDOWN, &flow->flags)) {
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 19efba1e51ef..3bbaf9c7ea46 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -384,7 +384,7 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 	if (skb_try_make_writable(skb, thoff + hdrsize))
 		return NF_DROP;
 
-	flow_offload_refresh(flow_table, flow);
+	flow_offload_refresh(flow_table, flow, false);
 
 	nf_flow_encap_pop(skb, tuplehash);
 	thoff -= offset;
@@ -650,7 +650,7 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 	if (skb_try_make_writable(skb, thoff + hdrsize))
 		return NF_DROP;
 
-	flow_offload_refresh(flow_table, flow);
+	flow_offload_refresh(flow_table, flow, false);
 
 	nf_flow_encap_pop(skb, tuplehash);
 
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 9cc0bc7c71ed..abc71a06d634 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -610,6 +610,7 @@ static bool tcf_ct_flow_table_lookup(struct tcf_ct_params *p,
 	struct flow_offload_tuple tuple = {};
 	enum ip_conntrack_info ctinfo;
 	struct tcphdr *tcph = NULL;
+	bool force_refresh = false;
 	struct flow_offload *flow;
 	struct nf_conn *ct;
 	u8 dir;
@@ -647,6 +648,7 @@ static bool tcf_ct_flow_table_lookup(struct tcf_ct_params *p,
 			 * established state, then don't refresh.
 			 */
 			return false;
+		force_refresh = true;
 	}
 
 	if (tcph && (unlikely(tcph->fin || tcph->rst))) {
@@ -660,7 +662,12 @@ static bool tcf_ct_flow_table_lookup(struct tcf_ct_params *p,
 	else
 		ctinfo = IP_CT_ESTABLISHED_REPLY;
 
-	flow_offload_refresh(nf_ft, flow);
+	flow_offload_refresh(nf_ft, flow, force_refresh);
+	if (!test_bit(IPS_ASSURED_BIT, &ct->status)) {
+		/* Process this flow in SW to allow promoting to ASSURED */
+		return false;
+	}
+
 	nf_conntrack_get(&ct->ct_general);
 	nf_ct_set(skb, ct, ctinfo);
 	if (nf_ft->flags & NF_FLOWTABLE_COUNTER)
-- 
2.37.1


