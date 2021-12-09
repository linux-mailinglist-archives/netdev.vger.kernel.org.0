Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6211B46E394
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 08:57:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234117AbhLIIB1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 03:01:27 -0500
Received: from mail-dm6nam11on2045.outbound.protection.outlook.com ([40.107.223.45]:12385
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234131AbhLIIB0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 03:01:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gxCpmRAT6Se8wnC5EfgbPEE7O/ye+6gU8r/5qGQ7Sb+CstGo6SCt1nrchPh/s5d/sHtX9bMlCESJw7VZMfuSnFU3Cnu1CbS+d1IIjezWaNX97F+rhi+u57Tj6NbBE9xHOaY1eLi5FDOEewXR4nGTEL7Fgsdc4so1qQJiyyOCaKSkNORa0uDyAiOXz3WzuQkjBHWw447bcdZktoIL4Ko6AAwmObX4LYPgpDoqVXvnRpHW6MjmZhY///hpnIl8kYQuxeZ9QM1kywHi8lcSYD57ptfyu8xnek1QYPqQ5j7sb4wyEAeo8PpxgYuL6gyoAMlhboOZBy9WwDp8unq/sSGv9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZlXXiG8r8e6pbaIRyMH2N1mnF7uK+P+5sq38zsgA03s=;
 b=h0ZChlYHaiFXcz8EQMM5STKdy/j9e3oN3JmUyMpGbaa67Bavpb+NNUtZaK34Rm7Zn1uXxkSWTFHWhuZeLHzf0EuttjKoLvhTqDKFbwt32AAYTi5XXDDE/ExEIDvCnjRqKCaJlUaymF1D9cH1/V2KsG7wj0LdLfbYn4c8a3msmzLiZnkO28qRSz2laEZKdNPxQw9Ii8N+ijeXig81pA59gOlqyk7wDTYDD0jG5EdiTjvGGBUsZ7Os9IRMstYhUVl/EXYZwjs1NX213PvPwBS/J/eWtP/CatYaLqyBYLffr39nTZe9bANsGNsZzqZU6yjCvz6L/EXRcB7SHtopQycq+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 203.18.50.14) smtp.rcpttodomain=ovn.org smtp.mailfrom=nvidia.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZlXXiG8r8e6pbaIRyMH2N1mnF7uK+P+5sq38zsgA03s=;
 b=K7N564DPNk+cYm2vdF07hss6J8TX2lIMGDbKPj2R6ICQ9uC/UVFpsiyAuyUqwP5fWDbUdKPccG6awSvoqlKBPqIYAQFz/7c9dpP64/lOJnVqebi+BuanUlWA0MezRtUzFxYpnjS744AWY2zeSd6AlZWXFA/DSXODDj915kgDAbg24H8UdgPfPKMWl9Z87ZJY+sRSWRnNjTKLuj2BL06/XaBCZJsf1encF7vxpP5cv7BG/g6mT9nynVpCjMOPXvJAQZCGyEWmjKb3aNv4WejeFnYETfjcFbVRoNZIw1hfaE48evNwXGWecj4DAVNxVZ7U5BJg3UZFp3J/2Zf+kpmhTw==
Received: from DM5PR06CA0082.namprd06.prod.outlook.com (2603:10b6:3:4::20) by
 DM5PR12MB4677.namprd12.prod.outlook.com (2603:10b6:4:a4::27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4778.11; Thu, 9 Dec 2021 07:57:51 +0000
Received: from DM6NAM11FT029.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:4:cafe::2b) by DM5PR06CA0082.outlook.office365.com
 (2603:10b6:3:4::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20 via Frontend
 Transport; Thu, 9 Dec 2021 07:57:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 203.18.50.14)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 203.18.50.14 as permitted sender) receiver=protection.outlook.com;
 client-ip=203.18.50.14; helo=mail.nvidia.com;
Received: from mail.nvidia.com (203.18.50.14) by
 DM6NAM11FT029.mail.protection.outlook.com (10.13.173.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4755.13 via Frontend Transport; Thu, 9 Dec 2021 07:57:51 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HKMAIL103.nvidia.com
 (10.18.16.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 9 Dec
 2021 07:57:49 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 9 Dec
 2021 07:57:46 +0000
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (172.20.187.5) by
 mail.nvidia.com (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.18
 via Frontend Transport; Thu, 9 Dec 2021 07:57:43 +0000
From:   Paul Blakey <paulb@nvidia.com>
To:     Paul Blakey <paulb@nvidia.com>, <dev@openvswitch.org>,
        <netdev@vger.kernel.org>, Saeed Mahameed <saeedm@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "Pravin B Shelar" <pshelar@ovn.org>, <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>, wenxu <wenxu@ucloud.cn>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
CC:     Oz Shlomo <ozsh@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Roi Dayan <roid@nvidia.com>
Subject: [PATCH net v2 2/3] net/sched: flow_dissector: Fix matching on zone id for invalid conns
Date:   Thu, 9 Dec 2021 09:57:33 +0200
Message-ID: <20211209075734.10199-3-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20211209075734.10199-1-paulb@nvidia.com>
References: <20211209075734.10199-1-paulb@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3499898b-fc9a-4452-1eeb-08d9bae9999c
X-MS-TrafficTypeDiagnostic: DM5PR12MB4677:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB4677D6743AB519F051CC29B0C2709@DM5PR12MB4677.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SYsAG5dukzK0U3oJOjE6ukZ+xToc4/gOSylEWMQp1fiK70UTw3y1hfldhLaKRqok0sv1eF9txjcjEQlX/Mc6aAReWSAYqSmCZ8raGk2aHfOYx/hOEcyhoG3dni58+gw2WUqLileuk1nogEpkC5KpGT64HYwxQ7Wln1z9FH10mOTCOPXALbXKpPFCj6xlVvC5O8d6e7+xt03E89AMrCCz9MYysAWRjMZa7luF/C1ZM4qyLUXHJIptcrw4HTl0LLhTQ8pc4KvrH3RxSKnHcWa29y/i88wJmksyXyUrcBvZ4l1IM37CPSlQKJsdyApSHjGOi+COtGiCBitb6PhoyIcHk8w5NsmB0Gh+uT8GPPn0czWsrbtbI8bH4GUyMtahMdANkKNtLomdyzbk/Yj8vKGzyhUA/7I7J84RXZf+6pJEyPbKO+k4Ea4V/ygaKOZQ1Zp+3vRKK7nm75cQ/SzdloeVktVycW4UcsmS/F1r0cUb9vqstZCp/EbhF2hLZcLAxCGh9Kn8fgebdRw46yR8W+tRZvaKGUkASHola46+h6XAY+4FrT2/VJ5fJFojzJCYtMBWz7TExUhgE5TDUdZPjEIRxQHEV6PKm0IVU/6vQJ4x6vZ5V5NVepjO6gKRkiVYv0QnNkNSVHByNXAf07kv1sB1Km7pXkr2M/zkKmpmymn+0bqm3d3yG2CW/ttff/87Cn4TajgGG79WuPVwCh+Khcf8Gms89Q3j7hTlfbOsUWGw1sNfILcYOVwUKtWjJ0SO3dSYX6LYFcrcSS8Hz1OvrJdF50Ty7kYBbfM01Uj41xESvVS0ZwW6hSgOBp1sFCgZAQnv
X-Forefront-Antispam-Report: CIP:203.18.50.14;CTRY:HK;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:hkhybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700001)(336012)(70586007)(508600001)(40460700001)(7636003)(8676002)(8936002)(2906002)(70206006)(86362001)(316002)(110136005)(34070700002)(6666004)(2616005)(426003)(5660300002)(82310400004)(186003)(54906003)(356005)(36756003)(4326008)(921005)(47076005)(1076003)(26005)(36860700001)(83380400001)(107886003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2021 07:57:51.2396
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3499898b-fc9a-4452-1eeb-08d9bae9999c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[203.18.50.14];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT029.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB4677
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If ct rejects a flow, it removes the conntrack info from the skb.
act_ct sets the post_ct variable so the dissector will see this case
as an +tracked +invalid state, but the zone id is lost with the
conntrack info.

To restore the zone id on such cases, set the last executed zone,
via the tc control block, when passing ct, and read it back in the
dissector if there is no ct info on the skb (invalid connection).

Fixes: 7baf2429a1a9 ("net/sched: cls_flower add CT_FLAGS_INVALID flag support")
Signed-off-by: Paul Blakey <paulb@nvidia.com>
---
 include/linux/skbuff.h    | 3 +--
 include/net/pkt_sched.h   | 1 +
 net/core/flow_dissector.c | 6 +++++-
 net/sched/act_ct.c        | 1 +
 net/sched/cls_flower.c    | 5 ++---
 5 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index c8cb7e697d47..155eb2ec54d8 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1379,8 +1379,7 @@ void
 skb_flow_dissect_ct(const struct sk_buff *skb,
 		    struct flow_dissector *flow_dissector,
 		    void *target_container,
-		    u16 *ctinfo_map, size_t mapsize,
-		    bool post_ct);
+		    u16 *ctinfo_map, size_t mapsize);
 void
 skb_flow_dissect_tunnel_info(const struct sk_buff *skb,
 			     struct flow_dissector *flow_dissector,
diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
index 05f18e81f3e8..9e71691c491b 100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -198,6 +198,7 @@ struct tc_skb_cb {
 
 	u16 mru;
 	bool post_ct;
+	u16 zone; /* Only valid if post_ct = true */
 };
 
 static inline struct tc_skb_cb *tc_skb_cb(const struct sk_buff *skb)
diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 3255f57f5131..b52a4370162b 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -12,6 +12,7 @@
 #include <net/gre.h>
 #include <net/pptp.h>
 #include <net/tipc.h>
+#include <net/pkt_sched.h>
 #include <linux/igmp.h>
 #include <linux/icmp.h>
 #include <linux/sctp.h>
@@ -238,10 +239,12 @@ void
 skb_flow_dissect_ct(const struct sk_buff *skb,
 		    struct flow_dissector *flow_dissector,
 		    void *target_container, u16 *ctinfo_map,
-		    size_t mapsize, bool post_ct)
+		    size_t mapsize)
 {
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
+	bool post_ct = tc_skb_cb(skb)->post_ct;
 	struct flow_dissector_key_ct *key;
+	u16 zone = tc_skb_cb(skb)->zone;
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn_labels *cl;
 	struct nf_conn *ct;
@@ -260,6 +263,7 @@ skb_flow_dissect_ct(const struct sk_buff *skb,
 	if (!ct) {
 		key->ct_state = TCA_FLOWER_KEY_CT_FLAGS_TRACKED |
 				TCA_FLOWER_KEY_CT_FLAGS_INVALID;
+		key->ct_zone = zone;
 		return;
 	}
 
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 98e248b9c0b1..ab3591408419 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -1049,6 +1049,7 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
 	skb_push_rcsum(skb, nh_ofs);
 
 	tc_skb_cb(skb)->post_ct = true;
+	tc_skb_cb(skb)->zone = p->zone;
 out_clear:
 	if (defrag)
 		qdisc_skb_cb(skb)->pkt_len = skb->len;
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 9782b93db1b3..c1a017822c6e 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -310,7 +310,6 @@ static int fl_classify(struct sk_buff *skb, const struct tcf_proto *tp,
 		       struct tcf_result *res)
 {
 	struct cls_fl_head *head = rcu_dereference_bh(tp->root);
-	bool post_ct = tc_skb_cb(skb)->post_ct;
 	struct fl_flow_key skb_key;
 	struct fl_flow_mask *mask;
 	struct cls_fl_filter *f;
@@ -327,8 +326,8 @@ static int fl_classify(struct sk_buff *skb, const struct tcf_proto *tp,
 		skb_flow_dissect_tunnel_info(skb, &mask->dissector, &skb_key);
 		skb_flow_dissect_ct(skb, &mask->dissector, &skb_key,
 				    fl_ct_info_to_flower_map,
-				    ARRAY_SIZE(fl_ct_info_to_flower_map),
-				    post_ct);
+				    ARRAY_SIZE(fl_ct_info_to_flower_map));
+
 		skb_flow_dissect_hash(skb, &mask->dissector, &skb_key);
 		skb_flow_dissect(skb, &mask->dissector, &skb_key,
 				 FLOW_DISSECTOR_F_STOP_BEFORE_ENCAP);
-- 
2.30.1

