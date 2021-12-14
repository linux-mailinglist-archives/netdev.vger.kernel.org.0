Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C126747493E
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 18:25:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236437AbhLNRZD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 12:25:03 -0500
Received: from mail-dm6nam10on2071.outbound.protection.outlook.com ([40.107.93.71]:6145
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231625AbhLNRZC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Dec 2021 12:25:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qrk9EshXiDUREiShsXRPkyvfMNNLyqEi8nQ424Pmo2fZpqYf4l/ZQacHpGxY2XkIaXAYcbuxl6L64idU+sM3+8SRkD6YROg1X+060tFRqVJc2DsG6ea/GPC+EoY25Dw2XhmuHyng3wgRcNf0hXdImmq3qeC+34iAT7mrRkphdYgpDajlvh7MoyHoQZ5bbgJrShipdcfU9CLBqdeU9qziWWUMzh2iujTo1AWMWH105s8irXqM+vXMSQ8/RF3X3d2iCDnscfV0VQS4xzEQxlgko5+qVIonCAdaW+O9XsSfmsXlAMFbG0MWyOj5ZiU/peCks+B9Y9VdAbx1TWBQq88cNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VdH2gDBNBnZSkAIRTtdbBVAtafQMO3dtKO1ZiKtHByc=;
 b=n3sRnbtfzsSBKgI6MhUWhcMSWs5+mBzSiy/5vlt68UiXKtFaIG3Ffb6lU+7AMzkeJbRGPH4OSTArDN33qrxLPO547B4NYzcmwtYi2XO0oBcdm3LJkf7iDoRd/2/YIrHYPpY+OIb3BrYOzZ3WpVvHVUz+aZj0qlL8H/Z2ChqQHpj991s/xocVxD21SOMDdDVvdk9iyKV8ZSLzqcwOtBg5mYYRoiQmiprggZVq5/07QyiCK81QHR+oTdKjl3qNgXQtJHByygensPtcVVX9ZppoCdZQ2WQjAJDp+vWzY9hTmq62E0rDr5QUNyA+NPaC8mAIa1iOQkgbvv4OqXsBs5qAvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 203.18.50.13) smtp.rcpttodomain=ovn.org smtp.mailfrom=nvidia.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VdH2gDBNBnZSkAIRTtdbBVAtafQMO3dtKO1ZiKtHByc=;
 b=McwFiyYNrBRM564DBr3QO/qZtlGikjsr2hkCc+MrdvoZ6TVLFJWIgl69QFVu20KRxcSto9OZarVKB0S3oy8qcsDLCBpC/uNhlnWvt2eOBYCrfd46S74mGReKropHrrYD6wThGVyt8S2yi0X0X04NMDWbr31yJ2iDSOXxVzOUDlGOh4px7m831sdygAhCbT3yW5N1/e0BUHkXM+MeQ2q8tdompU3u32ICLj8jbWPSdOVmxFZDloQi45NvhqJLynOcoYg3JFcj3HdbIJjPcK9kainbiEAn9aDBuNl6Oq82RVikMrOEm23X+T+AT8yU3a0Z24YWg7CflduTHFk0xRuC3Q==
Received: from MW4PR04CA0218.namprd04.prod.outlook.com (2603:10b6:303:87::13)
 by CH2PR12MB3944.namprd12.prod.outlook.com (2603:10b6:610:21::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.18; Tue, 14 Dec
 2021 17:24:58 +0000
Received: from CO1NAM11FT043.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:87:cafe::5) by MW4PR04CA0218.outlook.office365.com
 (2603:10b6:303:87::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17 via Frontend
 Transport; Tue, 14 Dec 2021 17:24:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 203.18.50.13)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 203.18.50.13 as permitted sender) receiver=protection.outlook.com;
 client-ip=203.18.50.13; helo=mail.nvidia.com;
Received: from mail.nvidia.com (203.18.50.13) by
 CO1NAM11FT043.mail.protection.outlook.com (10.13.174.193) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4778.13 via Frontend Transport; Tue, 14 Dec 2021 17:24:57 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HKMAIL102.nvidia.com
 (10.18.16.11) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 14 Dec
 2021 17:24:54 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 14 Dec
 2021 17:24:52 +0000
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (172.20.187.6) by
 mail.nvidia.com (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.18
 via Frontend Transport; Tue, 14 Dec 2021 17:24:49 +0000
From:   Paul Blakey <paulb@nvidia.com>
To:     Paul Blakey <paulb@nvidia.com>, <dev@openvswitch.org>,
        <netdev@vger.kernel.org>, Saeed Mahameed <saeedm@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "Pravin B Shelar" <pshelar@ovn.org>, <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>, wenxu <wenxu@ucloud.cn>,
        Jakub Kicinski <kuba@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
CC:     Oz Shlomo <ozsh@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Roi Dayan <roid@nvidia.com>
Subject: [PATCH net v3 2/3] net/sched: flow_dissector: Fix matching on zone id for invalid conns
Date:   Tue, 14 Dec 2021 19:24:34 +0200
Message-ID: <20211214172435.24207-3-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20211214172435.24207-1-paulb@nvidia.com>
References: <20211214172435.24207-1-paulb@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cc0719c4-359c-43df-f1c2-08d9bf26a709
X-MS-TrafficTypeDiagnostic: CH2PR12MB3944:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB3944901F360016F97287C1E1C2759@CH2PR12MB3944.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /ibyFth4m79ddihjJxt+vKLGTVXTKgNOh2wwMuuUF5LLSRGvgsEYIY7Ablj3HMjG4Imsms49ekr2RU58bAwywDTrSNxvax3sLYYsNs1xqL6OjXwnS5SoxSuvDyAmDTZuDGSTumI7zCmnYb+ENQvqNwAz99DIsggAKjtGdQpcoXrLks5oN2ZTIBOMzHkabw9bYqUbH034Nmztnlq+JHmF91LRG4jjQeSvw3KRHLHltk84wK3tVrj77PmPVdQXmT2e8cv3LnIqc+mMC3NbznVYV5nG8QZHqjyw42QZUFB4zGDgJ+muITXdGtb/VWe32Q2QvMFXpY3tNOt1teJGA0DZRC4bUlPgWvMAOoqaz43kbOGgorX3xIYLPd+AAoA0NyEN9RuxZuiZ7GHQx2qP4GBq5FGX0BV150je8EFrVuDKuL5/cGMS7so1L9voPeix5GZMvS5u4q26vZ8NRsl7l3sLHygxPyY2zCzmvq7sZ0DMIp0X271GD9v/HMJV8xhFhKviuEUIjFXymrghZ0YsykR/9lSVTBqVRwkJK/QHYEFoBJpZc3y8JKjBaW8b6UhBq3ogN06anYz1sL4A7SrSoQLs5Gl7jRs08lh8NkuhbanqSzKnsQ9C/2VvWXoJr88kGSqZXmBQ8dOUdH8w13wZIYZY/DWzhLIzro2HGz4bdu1C307akiKGKV18BuGSlTyn6Q8CgvcTVXmpMpGqXI6NPLfpj2xwndHmV3fsmedoh8bGm08atBE5AAw6BwZX4W+5MSqu7H3UFiqz3GtF7wYypZs4x9yjpiwel9ODxS8b6l7JilPXXrSHqdvgd/VdrNrbnw6/
X-Forefront-Antispam-Report: CIP:203.18.50.13;CTRY:HK;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:hkhybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700001)(107886003)(2616005)(36860700001)(186003)(26005)(36756003)(1076003)(70586007)(70206006)(7636003)(316002)(82310400004)(6666004)(40460700001)(86362001)(34020700004)(4326008)(2906002)(8936002)(47076005)(336012)(83380400001)(426003)(54906003)(5660300002)(110136005)(508600001)(921005)(8676002)(356005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 17:24:57.7995
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cc0719c4-359c-43df-f1c2-08d9bf26a709
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[203.18.50.13];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT043.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3944
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
 include/linux/skbuff.h    | 2 +-
 include/net/pkt_sched.h   | 1 +
 net/core/flow_dissector.c | 3 ++-
 net/sched/act_ct.c        | 1 +
 net/sched/cls_flower.c    | 3 ++-
 5 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index c8cb7e697d47..2ecf8cfd2223 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1380,7 +1380,7 @@ skb_flow_dissect_ct(const struct sk_buff *skb,
 		    struct flow_dissector *flow_dissector,
 		    void *target_container,
 		    u16 *ctinfo_map, size_t mapsize,
-		    bool post_ct);
+		    bool post_ct, u16 zone);
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
index 3255f57f5131..1b094c481f1d 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -238,7 +238,7 @@ void
 skb_flow_dissect_ct(const struct sk_buff *skb,
 		    struct flow_dissector *flow_dissector,
 		    void *target_container, u16 *ctinfo_map,
-		    size_t mapsize, bool post_ct)
+		    size_t mapsize, bool post_ct, u16 zone)
 {
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
 	struct flow_dissector_key_ct *key;
@@ -260,6 +260,7 @@ skb_flow_dissect_ct(const struct sk_buff *skb,
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
index 9782b93db1b3..ef54ed395874 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -311,6 +311,7 @@ static int fl_classify(struct sk_buff *skb, const struct tcf_proto *tp,
 {
 	struct cls_fl_head *head = rcu_dereference_bh(tp->root);
 	bool post_ct = tc_skb_cb(skb)->post_ct;
+	u16 zone = tc_skb_cb(skb)->zone;
 	struct fl_flow_key skb_key;
 	struct fl_flow_mask *mask;
 	struct cls_fl_filter *f;
@@ -328,7 +329,7 @@ static int fl_classify(struct sk_buff *skb, const struct tcf_proto *tp,
 		skb_flow_dissect_ct(skb, &mask->dissector, &skb_key,
 				    fl_ct_info_to_flower_map,
 				    ARRAY_SIZE(fl_ct_info_to_flower_map),
-				    post_ct);
+				    post_ct, zone);
 		skb_flow_dissect_hash(skb, &mask->dissector, &skb_key);
 		skb_flow_dissect(skb, &mask->dissector, &skb_key,
 				 FLOW_DISSECTOR_F_STOP_BEFORE_ENCAP);
-- 
2.30.1

