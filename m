Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E50C3BB832
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 09:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbhGEHvw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 03:51:52 -0400
Received: from mail-dm6nam10on2051.outbound.protection.outlook.com ([40.107.93.51]:48897
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229884AbhGEHvv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Jul 2021 03:51:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kAo14dVcteVPyHSAwInVy2/rEu/JkLSIs91oE7fugRU+Waheq8ot05ooI9/x0kc0rhwQ1pSJulITagiY2s/4EQNqJ4MjvhJtNu0mKQqCVUOqqq8mTHFe++JWFv5oEj6yf3FGnmWg9Q27B/504dXSusY4t3HneH1fIy9wfDHLdWYIEe0Lfe24L8T+ifpBy0BtI/kYsx1JOo78ntoSYXWBBRQE4878/ZKfT2a2YRgYBsLY679JHuu2clN9WWG/gqiy4wpPFC8fn9rZI1a0rpws+3p9geKTu9Zx4If0ZhXMRERbYFi8d3cmjR/Jgme3NtHO8ypf/B2u0yMyqg0r8Dtk5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pD75l1dbCFnn7z1SSZY5GxO/X6MQAVH9OojLhaWBcsQ=;
 b=G02Mq1ey/FO/XIcK0uMnaaQ7Avf6ewMb8T6GoeOOGFGgVM1Bu8/E5FHbOuujzkCOs0bbnbIEhY8NnjB/T810DQQHc3CR5gTG4pQX8+yXlMW1Bt3e0/jC/+CInoEP2a0gOpdk7H6Gruwx4eGNhPn71zAxz4DcJqqjxmLsMWggg8Smu74ds5HZ4O3ozsVedtn0H+mkQNjOC1GGRgnhPQp4wa6rL06KA/WWk3xb1S1knEHjjlpzTOsyPXVynjWZ6OXKfwOWt4oatRRpjC9Xgdz/DtsgeVKk8oDWoWTa27aOaSygBiQ1uOrCrfmCQ0Msl2c5BZ6UKQwuS6/Jg1ae331/5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pD75l1dbCFnn7z1SSZY5GxO/X6MQAVH9OojLhaWBcsQ=;
 b=h9uqDPCD1B0sEaJM7ViNyCau3ICIxDASz8rzhh1tEGdeTAupdSUC/PufWaZjPbSosehVItT4i3MoOTRVSZTNmuceN6RtDwYQTPLFZwUxM8JpJRzSSnWrYMt8mSncGVIKXCqZ+ZqddrOubSj+7l4i0RWced7OaxO30LfU0iQ1NYeCugZcvQNS4ZS6r6dmC4sUIKotv1Z5IxDOdfCiEutPI5OPVN+vtgFvSegnI02sVlJTnKA9PyjDwpQrpxwEgWXwPkpnnSJQoQfovZ0hlR/bXMtII5uZmgaFQmlJjSFk13Y/j/YimRSrRKo3d3xx8keRGkkRACwkYeLLR696cdLuqg==
Received: from MWHPR17CA0064.namprd17.prod.outlook.com (2603:10b6:300:93::26)
 by PH0PR12MB5404.namprd12.prod.outlook.com (2603:10b6:510:d7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.23; Mon, 5 Jul
 2021 07:49:13 +0000
Received: from CO1NAM11FT029.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:93:cafe::bd) by MWHPR17CA0064.outlook.office365.com
 (2603:10b6:300:93::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.22 via Frontend
 Transport; Mon, 5 Jul 2021 07:49:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT029.mail.protection.outlook.com (10.13.174.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4287.22 via Frontend Transport; Mon, 5 Jul 2021 07:49:13 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 5 Jul
 2021 07:49:12 +0000
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (172.20.187.6) by
 mail.nvidia.com (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.2 via
 Frontend Transport; Mon, 5 Jul 2021 07:49:09 +0000
From:   Paul Blakey <paulb@nvidia.com>
To:     Paul Blakey <paulb@nvidia.com>, <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        "Saeed Mahameed" <saeedm@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net v2] skbuff: Release nfct refcount on napi stolen or re-used skbs
Date:   Mon, 5 Jul 2021 10:49:07 +0300
Message-ID: <1625471347-21730-1-git-send-email-paulb@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 694b9863-faa9-4bbf-8161-08d93f8961d3
X-MS-TrafficTypeDiagnostic: PH0PR12MB5404:
X-Microsoft-Antispam-PRVS: <PH0PR12MB5404790BFF1B0FE6DF614784C21C9@PH0PR12MB5404.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S+TTMFeuXSnf0SqYIklZZJ0+Ncu+TU6pa/EARpWElfoZWzNkGhwFEUR66jOX4sdx9pSEhHvyuyjJN0kn6qRtPBwv7JcLadeSUqeCJZR/p7qfnvHe89SM4IETLHAPsr6/hwUUMEi+bBfswDCoLn4AAUuVyQxaQPhx3RxGrG+80MjBIPaZA94rSNX5E0opRaN3RdpceokSfWjGtC85lPLICxW5g/JkoqRlB4nuQ6rtblWsXNmQ6AB78jX6kODJzZpdfslfq/bzP3TIskgXi3H0j5+GrQx8+Js9C07lP7KRYrF56nIJf6kFAGVXoCj+FcS+9/XlgllWNTH5MpSvNIYJzPjuyO36rj7+1ym3ebCOyepDKNz/snpxuqTCift1YPZitlkwpDlyKeaCyBDTJQ7hk3GHPQ/JXI7J27yUx3M7PHC+LqU62oyr7Q5p4TuKimVxxV83X39qTJWu/cPkArhn4GnVeYFyYh4mTNLRGxLf2bKusmesLnxZcW+FEzR05XLYlAU4gytSpnR6CoqVXvr8HyoFpkRqG4/91ZivjNzAPSaORgdcCdPlte8PqcBc7jnycD1i/PbyB1a+WpX5ReupSK48SEygO69JSkNIuPHHK0oAJd1sYRpLW6TDuegLeNuaey6DgUTSw8TKkG4Rp16nr5cXbZpKbT7tWNIpNJTMYbsqH+hOhgib7iVFrVTBmrztZbppMHrneD4pD9OtMT+73g==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(346002)(376002)(396003)(136003)(46966006)(36840700001)(70586007)(36756003)(70206006)(478600001)(82310400003)(82740400003)(36860700001)(2906002)(26005)(5660300002)(186003)(110136005)(54906003)(47076005)(107886003)(4326008)(86362001)(426003)(8676002)(36906005)(316002)(7636003)(2616005)(8936002)(336012)(356005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2021 07:49:13.2857
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 694b9863-faa9-4bbf-8161-08d93f8961d3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT029.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5404
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
index bbc3b4b62032..239eb2fba255 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -939,6 +939,7 @@ void __kfree_skb_defer(struct sk_buff *skb)
 
 void napi_skb_free_stolen_head(struct sk_buff *skb)
 {
+	nf_conntrack_put(skb_nfct(skb));
 	skb_dst_drop(skb);
 	skb_ext_put(skb);
 	napi_skb_cache_put(skb);
-- 
2.30.1

