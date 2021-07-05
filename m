Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12A783BBB9C
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 12:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231264AbhGEK5g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 06:57:36 -0400
Received: from mail-dm6nam08on2082.outbound.protection.outlook.com ([40.107.102.82]:55136
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230511AbhGEK5g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Jul 2021 06:57:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gMv+7iukrLAIfjVJTvAQkTfLQFOcqECI4d5l3+mg2COV3T2eNurxf5PGz7jW4/q7gVCvD+vj5lVjx41vH/CPqTlhonnvR4qQxGNEGA5g1TCGYjfJMJ/HogCkKD/pwGXZKxfI+vhv9s7OjuIYWUVZNB7SaWE62G79kjgNS7LKALcQ0bljsOEwOy2oCvDCWa/AFpYRQSzua6AeGrAkXrzi4Dv+zHlqJVBlXCUuYPz/8MXm1PL0+6QcRhRVBxKUlwky23MUmnK3w7D55x5YCjTawT4fj8ZxM2kIt4xixcSmt+R+k2m56G/5sqZzwwL0PumvE2cLUADQh28kwr5cMxpPIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2FF0JXY2H0fgHQgg2W7hNEgKr+IEHWhywpRieUJ6s2U=;
 b=JnOGOwueZ6Fo+HyATpCJXU1yzFgbIB31a53iiagQ3ODZIFG9MPBdaoSzgA00eFNCj+DL3z5XC6FB6z4+Ic4sNxinE2Cm5icoIxSkscF3OVBjwQodhjlFmfS3hkjMe/O6PTMzU7Bsb2Pls4cyjIdJhjMYujkaMFq6z/pW7hGF8vCc4y949Qy4Mvg+B1K3P2+FvGadAwuwGu5cukxj0pbMKvTp8FUvpCSneN7wZNVA3JBhWJFu6/5LQOsfwB04bnJAKBDPO8RLQC26Fa3FWK/EBZQEWrSx65jsEe8zKfVSmAs6AMTlQKTeMtGaKZUIFjrMDIeevxroXxpswA3X8PEgMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2FF0JXY2H0fgHQgg2W7hNEgKr+IEHWhywpRieUJ6s2U=;
 b=jaoItmEvC0FRX/YeF1D3PWFjV+CNfctJtFfwQPd921ZbfxJ/AoZ/h/y+sgVbVJ66A52vujdPq37vy30mXdSmrD2XzPdV/1vfC4pzwNY/eyQOdha0BFcBQgYB8l2aBC/g6X0yq4WttGJ32Mr5CtbypTRaq29WY+6iFUXdfSQPs/aK7Hi/GFebBXIuGr9jnNCzlwXxWpfupsOjRAApCg3EIYRySJ+FuaPtP9jT7GThJq7GBG4JZyG7gzQOngmJ6Y3DSm5TRbVaWYOCI2xvsRZQu/jIu+XRPk8XETfan57wRFxaZncztRPPmnVLCPFMXNL2kwJ1zBAoMRjMeM2aDd1INg==
Received: from BN6PR17CA0002.namprd17.prod.outlook.com (2603:10b6:404:65::12)
 by DM6PR12MB4156.namprd12.prod.outlook.com (2603:10b6:5:218::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.23; Mon, 5 Jul
 2021 10:54:58 +0000
Received: from BN8NAM11FT036.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:65:cafe::8e) by BN6PR17CA0002.outlook.office365.com
 (2603:10b6:404:65::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.23 via Frontend
 Transport; Mon, 5 Jul 2021 10:54:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT036.mail.protection.outlook.com (10.13.177.168) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4287.22 via Frontend Transport; Mon, 5 Jul 2021 10:54:58 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 5 Jul
 2021 03:54:57 -0700
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (172.20.187.5) by
 mail.nvidia.com (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.2 via
 Frontend Transport; Mon, 5 Jul 2021 10:54:54 +0000
From:   Paul Blakey <paulb@nvidia.com>
To:     Paul Blakey <paulb@nvidia.com>, <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        mika penttila <mika.penttila@nextfour.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        "Saeed Mahameed" <saeedm@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net v3] skbuff: Release nfct refcount on napi stolen or re-used skbs
Date:   Mon, 5 Jul 2021 13:54:51 +0300
Message-ID: <1625482491-17536-1-git-send-email-paulb@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f88a557e-ee9b-47ed-92bd-08d93fa354db
X-MS-TrafficTypeDiagnostic: DM6PR12MB4156:
X-Microsoft-Antispam-PRVS: <DM6PR12MB415675C0FAB6A19091FAA9CBC21C9@DM6PR12MB4156.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GcqNOydcjrBpSsoPqmWZsxXbwVG2PSIvTEoh6Il+Y8+5RU17rk+e3q9HYxRFy73RA/tZv9opo+lr3weKqmT4yYnCkBw5AcKiJV2PoUNaH51Hd8HTgyizmoARBCZwFAyZiXBKqr8/rfEl/HScf8H8Lrk55VEmqAvXAIiS+cz9Wxb/y+OIosXhqV4I+HdUf4wQLqVgDQw175lM6GwhuHR9rtfMV6s5pfamKq9jU0STAEdmOMr41z1Uug11oFJQKwDvGN3k/+9T5BthT3giA7ZgQGueLQBau9pG92KTGr84Ji9CRyuZtJUnm6AQCNYmWde5zMznEG2vE5XPVyT9P3bfXLZ72B9nXJR+Sl9PZtAy+7nYWg4tNsdoavBhtz107goL0XiyeFK5SiyEMH9bZOx3Pupqz2YdM+n335SCDImlRxZ1V8oXWGWgSARNk6HLbTJfnqUZDPjjFDniq1/hOFE9FdUpjCa+OHiow0I9VCE3MPexVt5JEvBco/1ibKy1nAI1OKAhYqN0xsEfKgM6bpEO+KkdMpboEk+CXSPPiLJ52k8/7MMv45Pri19E8RGBFOsgp1rBNt5sJfqm84BAs7XNd9Ngbnq4BPs5E9AH3k9sjTg3SiuNAME4kI5YDoesikX7gaB12FS4EMC9p8EkzspI1Je6T4/39ZhTRqlx+xFQHQc6sbdtdNUd1sZnyhn1Uw0a/fETk9BdB2CjWg8/rY7DNA==
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(39860400002)(346002)(396003)(136003)(46966006)(36840700001)(4326008)(47076005)(478600001)(6666004)(26005)(5660300002)(82740400003)(110136005)(36756003)(54906003)(70206006)(36860700001)(2616005)(8936002)(107886003)(2906002)(356005)(8676002)(336012)(426003)(82310400003)(316002)(70586007)(7636003)(86362001)(186003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2021 10:54:58.3672
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f88a557e-ee9b-47ed-92bd-08d93fa354db
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT036.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4156
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When multiple SKBs are merged to a new skb under napi GRO,
or SKB is re-used by napi, if nfct was set for them in the
driver, it will not be released while freeing their stolen
head state or on re-use.

Release nfct on napi's stolen or re-used SKBs, and
in gro_list_prepare, check conntrack metadata diff.

Fixes: 5c6b94604744 ("net/mlx5e: CT: Handle misses after executing CT action")
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Paul Blakey <paulb@nvidia.com>
---
Changelog:
	v2->v1:
	 in napi_skb_free_stolen_head() use nf_reset_ct(skb) instead, so we also zero nfct ptr.
	v1->v2:
	 Check for different flows based on CT and chain metadata in gro_list_prepare

 net/core/dev.c    | 13 +++++++++++++
 net/core/skbuff.c |  1 +
 2 files changed, 14 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index 439faadab0c2..bf62cb2ec6da 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5981,6 +5981,18 @@ static void gro_list_prepare(const struct list_head *head,
 			diffs = memcmp(skb_mac_header(p),
 				       skb_mac_header(skb),
 				       maclen);
+
+		diffs |= skb_get_nfct(p) ^ skb_get_nfct(skb);
+
+		if (!diffs) {
+			struct tc_skb_ext *skb_ext = skb_ext_find(skb, TC_SKB_EXT);
+			struct tc_skb_ext *p_ext = skb_ext_find(p, TC_SKB_EXT);
+
+			diffs |= (!!p_ext) ^ (!!skb_ext);
+			if (!diffs && unlikely(skb_ext))
+				diffs |= p_ext->chain ^ skb_ext->chain;
+		}
+
 		NAPI_GRO_CB(p)->same_flow = !diffs;
 	}
 }
@@ -6243,6 +6255,7 @@ static void napi_reuse_skb(struct napi_struct *napi, struct sk_buff *skb)
 	skb_shinfo(skb)->gso_type = 0;
 	skb->truesize = SKB_TRUESIZE(skb_end_offset(skb));
 	skb_ext_reset(skb);
+	nf_reset_ct(skb);
 
 	napi->skb = skb;
 }
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index bbc3b4b62032..30ca61d91b69 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -939,6 +939,7 @@ void __kfree_skb_defer(struct sk_buff *skb)
 
 void napi_skb_free_stolen_head(struct sk_buff *skb)
 {
+	nf_reset_ct(skb);
 	skb_dst_drop(skb);
 	skb_ext_put(skb);
 	napi_skb_cache_put(skb);
-- 
2.30.1

