Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00ACA46D929
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 18:03:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237506AbhLHRGu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 12:06:50 -0500
Received: from mail-bn1nam07on2083.outbound.protection.outlook.com ([40.107.212.83]:6027
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237502AbhLHRGt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Dec 2021 12:06:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QEbEfGV9jvkxleju4U509zw2FSL2ViheaQGnMK0Tn5uOnR6kmbFySCT8F+jkUM+LQcglWhQ3J/i0hYNDwEVElJ9xsOuXlw17d0PFR11x1SIzi/V4togceFzHTVfKgXf8a3uEoQ2u6LAIf2XuCW+ktu5oy9IPPLIRz7RpfAV1l1UyfSEHT/1DQAeGKT+yB3QneNFmHYkaV6UbBcMNpaWfBeSH8i5zh//skjtbOVam6xEN6ldddrrzmxZRMBLuMEF9+b7faN8AVTiRMMZcs8V0RYqrKbiZg0xbVc5G4092PiJFBF2DQv7vTm8RyQqyjV9mHqqCUT2kXqCQ9pjZsN09ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZlXXiG8r8e6pbaIRyMH2N1mnF7uK+P+5sq38zsgA03s=;
 b=Wh+QLdZxrkgMwsyQxEF+CuiM766Ek3QeZOHoxctGwW7fdE+sK1expLmIszzFo3isJ2AOt35dLGBLJ4Y1sW0HuA7+xNQuX7SyUAd4l6/1yV20S3xep9kgMDLDtpQIYGmODOe+zg4h1d797lSt3sOTO0wR/k5zTdeQjcErNJ5EuJe7ei/YkEy9O00ECtLu13xDB0biaOQg2TkvhcMVum07EMjazVmme3GelBRNwc6b9q9SoF4sXIMO864O8GgchVewu1Hxz1/2SjHhZRv8GL05hJBy8CQwtRVORzkXVFPgtY91bE6vU52gGnkHYieHDcB8oB5RaYFjI8g4aP0oc4ziBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 203.18.50.14) smtp.rcpttodomain=openvswitch.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZlXXiG8r8e6pbaIRyMH2N1mnF7uK+P+5sq38zsgA03s=;
 b=LvC3RYS+yw3F/A0XCTae1l5jV7FLB1NuaGqhO4KDKzReWshNqpRuIYJXQzRHmC+0Hg1XkJUYqmr/Taf5mZSwnq1TFemcgkaKpfMfyMyMG25I60rW3Y0+iPg7S+PuvA4KQcVIE/9IZ3X831RH5WMFe2ttVttguqLAS1BKS2SXbG49nwWiUZsGhxFsmVvEIMoVUIzuOqd11WrAuQEP+wpeSDvlhF6UKrtUsRQfREv2PPXfHCsa2s7ItZV0QDGEnK4SRlU8gnB5nNEU6qvSeXZpP6CTbsfsnIEcSRJrd0BmDGWWE6LdVocOA4eoqID1XTmr+o5bi7PstJZDZGJtkn3ohA==
Received: from MW4PR04CA0375.namprd04.prod.outlook.com (2603:10b6:303:81::20)
 by SN1PR12MB2352.namprd12.prod.outlook.com (2603:10b6:802:25::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.12; Wed, 8 Dec
 2021 17:03:15 +0000
Received: from CO1NAM11FT028.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:81:cafe::24) by MW4PR04CA0375.outlook.office365.com
 (2603:10b6:303:81::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20 via Frontend
 Transport; Wed, 8 Dec 2021 17:03:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 203.18.50.14)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 203.18.50.14 as permitted sender) receiver=protection.outlook.com;
 client-ip=203.18.50.14; helo=mail.nvidia.com;
Received: from mail.nvidia.com (203.18.50.14) by
 CO1NAM11FT028.mail.protection.outlook.com (10.13.175.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4755.13 via Frontend Transport; Wed, 8 Dec 2021 17:03:14 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HKMAIL103.nvidia.com
 (10.18.16.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 8 Dec
 2021 17:02:59 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 8 Dec
 2021 09:02:56 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (172.20.187.6) by
 mail.nvidia.com (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.18
 via Frontend Transport; Wed, 8 Dec 2021 17:02:54 +0000
From:   Paul Blakey <paulb@nvidia.com>
To:     Paul Blakey <paulb@nvidia.com>, <dev@openvswitch.org>,
        <netdev@vger.kernel.org>, Saeed Mahameed <saeedm@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "Pravin B Shelar" <pshelar@ovn.org>, <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>
CC:     Oz Shlomo <ozsh@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Roi Dayan <roid@nvidia.com>
Subject: [PATCH net 2/3] net/sched: flow_dissector: Fix matching on zone id for invalid conns
Date:   Wed, 8 Dec 2021 19:02:39 +0200
Message-ID: <20211208170240.13458-3-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20211208170240.13458-1-paulb@nvidia.com>
References: <20211208170240.13458-1-paulb@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b180868f-23e2-4d8d-5adf-08d9ba6c9fc3
X-MS-TrafficTypeDiagnostic: SN1PR12MB2352:EE_
X-Microsoft-Antispam-PRVS: <SN1PR12MB235275EBF889A357839C18F9C26F9@SN1PR12MB2352.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8vXeLWD/wwZcbU4/9DnCt7GhaYcgOQvW2dZ4YIvrZroxNhyEBVLNXRlDAGeMBr1e/6ceDGD0AMbkxSAW5H558rNldyO1ATtYsSeV+V9s6v5Ude5I8a22lTc87b60wk5k3lNeu4aJHHb1YfTzVzAQ1BvgnkEZctYDLybFj+DNjDteQOn3O6hJPywuD+rZNMxM1H3J0Bd+ejgNmQBMtUZ2kPsYqI5JyaoeSXsTeLF68j5xgsst1vGRfmH0Yedo4+HdckN/7WIs8DP8xCvVs5i9RT4v1WmBXF1jpDmbfUSKAhIZcW90OA4QZb7nnJAQLN9DDqOlVgpe7z99shNyVIiV7ipk+TV4qBeNRjCRKxEQN48I7AH8vQMymEkiN9x1NcEl/6Z+4sHnr/UdHoyBlL3VARTuk6cvxpnHaviv2IeffImxwzfAf99qm8vg1eNfMdU+F0l4m1TkUGcGpUr7ajia3EQouLGEwQoQ5/oqp184cTGRCMRetDjV26j82E9K62Zucl9Fzqp/oCTBGpcpKbg6Bpy7IfkO009TJ702SNQKmEEfS7uzWEWZkEnma/0JVcfFGeJrVa1F4deIou/yyahtaTQIT4O87oxO3lnQGqfjOq8Ckgg9P+54rNiOnFfzDxzfs3D+hc8t5rxfLbd6W9dUKwFm78C3lSxPozg5Ct0LqZlzfM5i6q1wsWFBvcDjSpQ4tJSq2mdVmuFctlMOD7Zkzrpck3S4DBCu/DgXctgfG9qEJbD5EzKCQqV0unQGpOiu26bEUEeNGcXzMiXM9yr57pfhiGj4G6TlOmU1dcu0H3g=
X-Forefront-Antispam-Report: CIP:203.18.50.14;CTRY:HK;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:hkhybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700001)(508600001)(8676002)(2906002)(47076005)(34070700002)(336012)(36860700001)(8936002)(70206006)(70586007)(4326008)(5660300002)(316002)(107886003)(1076003)(54906003)(6636002)(426003)(36756003)(6666004)(2616005)(7636003)(86362001)(110136005)(26005)(356005)(40460700001)(82310400004)(83380400001)(186003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2021 17:03:14.5812
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b180868f-23e2-4d8d-5adf-08d9ba6c9fc3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[203.18.50.14];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT028.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2352
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

