Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D07AF460EBD
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 07:26:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240314AbhK2G3L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 01:29:11 -0500
Received: from mail-dm3nam07on2065.outbound.protection.outlook.com ([40.107.95.65]:34217
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237089AbhK2G06 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Nov 2021 01:26:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J4wswMZfOa23lHiaLoiwSH+lbey5ZiwzjW7Hk3BJiC+1qlmI1HmACxGWGbH+YVe1Ps+hCNvxwrUvk5TWck7K6K26BOLMKTgjId2mfgc66t3R+TR5IQPEG1TTmmQ/y9pmrr/E0mYuR4ZdO2HU06YDc1CZAwDaF+zCw77apNeadE+X1ADbVNCFikJvv7DTCH1VX2yJYyhs7g28tXDE9a4+KZhHmlWynunMhEXj/+xjd2XJdJG8zj0SDVs1mrbSPBANdM8Hgfe7ZXtrbho5To/zDDjExjwqkzNnQMi33f8gB3lcBSgNA0B7g/wn5dTytGXe07oD9b0yE49zKHMBEWyexw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ToWanTLHn6Kc2h4r1exCcQwWpexIG37/q+lqjv2Gdz0=;
 b=YwDpJJSJvYFKgYw/1EG5Igj4IiFSIW89bv5wza4K3iriBWzQNadOlRoDRNFikMDG0VJesRL2pWtmUmInSuI8C7v3ArlSl8mkobPNjHKxYrA2CUYfORCn2jBdgIuH6y6Mv2wVAMLgXHAKwd4n3lilrXDVhJxJE6WpJjbFkgyd9mvtuArsmZFCuHg/6Mzk6t5XTgGEmbfPWLf3AbdOslLLE62mH4pbigolKI2D8Uda75byTT6rcFwQHR8gkIAvg4ujHOakAnown17lf94OqP77Lgh5jdQihNrDl482R1di5giLg4ihrL7tfxJRuyOu3KnPpZdIDeJDpJkYbXYszoy5Ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=linux.alibaba.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ToWanTLHn6Kc2h4r1exCcQwWpexIG37/q+lqjv2Gdz0=;
 b=ktOb7/o6K49XE/oYWQtsHLOtAAtqZT+dyqS9q5uLJui/Ci7nc2NjbPBeBk5sa/1gFMioR883VX+UyEVFDCS+/SjpmvxzulwkNpEkRlCf+sDvznTJBbRE6DWVijZxF1LbjFLPGRP+F6Y8kATHf/Kxh1qw0UGn0Udxt3HhjRV4dm2raBi0DOe2ak8K0z2qon4ffDBB9se5cc0kq9k2IQLLHf8nB+zpLV47+JEkh+jRHhzLhQMZ7qUU5oO5gnJE5LeLnjmrGZISLXxIMoFZtGSyEkq8zXlw5c+4yd64g5jFXWc7rsv9SWhrlcsILF86neSUIOx2HkzzZwyN+xvRGTFS3g==
Received: from CO2PR04CA0121.namprd04.prod.outlook.com (2603:10b6:104:7::23)
 by BN7PR12MB2658.namprd12.prod.outlook.com (2603:10b6:408:25::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Mon, 29 Nov
 2021 06:23:39 +0000
Received: from CO1NAM11FT059.eop-nam11.prod.protection.outlook.com
 (2603:10b6:104:7:cafe::17) by CO2PR04CA0121.outlook.office365.com
 (2603:10b6:104:7::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22 via Frontend
 Transport; Mon, 29 Nov 2021 06:23:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 CO1NAM11FT059.mail.protection.outlook.com (10.13.174.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4734.22 via Frontend Transport; Mon, 29 Nov 2021 06:23:39 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 28 Nov
 2021 22:23:38 -0800
Received: from d3.nvidia.com (172.20.187.6) by mail.nvidia.com (172.20.187.10)
 with Microsoft SMTP Server id 15.0.1497.18 via Frontend Transport; Mon, 29
 Nov 2021 06:23:38 +0000
From:   Benjamin Poirier <bpoirier@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Kangmin Park <l4stpr0gr4m@gmail.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        <netdev@vger.kernel.org>, Roopa Prabhu <roopa@nvidia.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next 2/2] net: mpls: Make for_nexthops iterator const
Date:   Mon, 29 Nov 2021 15:23:16 +0900
Message-ID: <20211129062316.221653-3-bpoirier@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211129062316.221653-1-bpoirier@nvidia.com>
References: <20211129062316.221653-1-bpoirier@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f19880fd-f878-4667-4f7f-08d9b300c895
X-MS-TrafficTypeDiagnostic: BN7PR12MB2658:
X-Microsoft-Antispam-PRVS: <BN7PR12MB26586E17FAB868C61F82AB5FB0669@BN7PR12MB2658.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kLOcK+iduo/ab29YP80f9PCPwkzPhnl45b5OIhhZww3iv9xbJAex9xWyH0zMkcWP8r9FGr3Pvy4W4QV5yyGJR/PnC3HJ9B8QbyIs3evy0XhsUZWC6YRdX9G/DdRlSn2nqKQBR4foGeYXEvqXOujiMVtaLnbmbSd9UkDESELIq6kQj3KNlBtrOxLekd10k9XAIpSmczF85Q9x9IMp2DsO0p4ZZ0wSMxXvFjeNFWSjDvfPHWsQw1V4Qp/14AasNTqCDGuYilSAfIhHuYnEvBUneYtuXoerytRGJkoqUh7OZ4RTb6E5tTn4tdQoiEPXhM8PY3mXejxcR4TTPfL1sErMWLgTaQ6m/AFbExFlxYpp47k37AhVWKEva9wihjgLYqrv/TRDfWaH41ThhXMgGlnxmoucdWwLCjTkpEPaH87fferzwoe3A4nvM3kiY967J3jnAXH0B68FJVMSKyBYoRgQiL89rDh4PlGH+pwMPWQvq8QzfBxUXEW9HSy3kgkHKvC79/ewvalHxmLIw7zJ+aBoGklzANWBPEKmtip52IwBMUY25K/gPxbB6raZ9h1wwyNfzh+/ZMKkNj/2/gfiTiJj5js1cYb/psFTcXCTRP1pIf7KacI6KOvTo9z8GeBzPk+oHkU8SIEHFGsJ4PpwHc+4dyMrlPeXL7Y7r5chl8I7z6nfO0j4ZHHtkLMyBajkYIf0bY1xaQYj+enSbbNBdg96mg==
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(8676002)(508600001)(83380400001)(86362001)(7636003)(186003)(82310400004)(336012)(70586007)(70206006)(5660300002)(426003)(4326008)(8936002)(356005)(47076005)(2906002)(36860700001)(54906003)(26005)(1076003)(6666004)(2616005)(110136005)(316002)(36756003)(7696005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2021 06:23:39.5176
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f19880fd-f878-4667-4f7f-08d9b300c895
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT059.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR12MB2658
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are separate for_nexthops and change_nexthops iterators. The
for_nexthops variant should use const.

Signed-off-by: Benjamin Poirier <bpoirier@nvidia.com>
---
 net/mpls/af_mpls.c  | 8 ++++----
 net/mpls/internal.h | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/mpls/af_mpls.c b/net/mpls/af_mpls.c
index ffeb2df8be7a..9fab40aa5c84 100644
--- a/net/mpls/af_mpls.c
+++ b/net/mpls/af_mpls.c
@@ -230,8 +230,8 @@ static struct mpls_nh *mpls_get_nexthop(struct mpls_route *rt, u8 index)
  * Since those fields can change at any moment, use READ_ONCE to
  * access both.
  */
-static struct mpls_nh *mpls_select_multipath(struct mpls_route *rt,
-					     struct sk_buff *skb)
+static const struct mpls_nh *mpls_select_multipath(struct mpls_route *rt,
+						   struct sk_buff *skb)
 {
 	u32 hash = 0;
 	int nh_index = 0;
@@ -343,8 +343,8 @@ static int mpls_forward(struct sk_buff *skb, struct net_device *dev,
 {
 	struct net *net = dev_net(dev);
 	struct mpls_shim_hdr *hdr;
+	const struct mpls_nh *nh;
 	struct mpls_route *rt;
-	struct mpls_nh *nh;
 	struct mpls_entry_decoded dec;
 	struct net_device *out_dev;
 	struct mpls_dev *out_mdev;
@@ -2333,12 +2333,12 @@ static int mpls_getroute(struct sk_buff *in_skb, struct nlmsghdr *in_nlh,
 	u32 labels[MAX_NEW_LABELS];
 	struct mpls_shim_hdr *hdr;
 	unsigned int hdr_size = 0;
+	const struct mpls_nh *nh;
 	struct net_device *dev;
 	struct mpls_route *rt;
 	struct rtmsg *rtm, *r;
 	struct nlmsghdr *nlh;
 	struct sk_buff *skb;
-	struct mpls_nh *nh;
 	u8 n_labels;
 	int err;
 
diff --git a/net/mpls/internal.h b/net/mpls/internal.h
index 218138f5b491..56c5cad3a230 100644
--- a/net/mpls/internal.h
+++ b/net/mpls/internal.h
@@ -158,7 +158,7 @@ struct mpls_route { /* next hop label forwarding entry */
 };
 
 #define for_nexthops(rt) {						\
-	int nhsel; struct mpls_nh *nh;					\
+	int nhsel; const struct mpls_nh *nh;				\
 	for (nhsel = 0, nh = (rt)->rt_nh;				\
 	     nhsel < (rt)->rt_nhn;					\
 	     nh = (void *)nh + (rt)->rt_nh_size, nhsel++)
-- 
2.33.1

