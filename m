Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7097460EB5
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 07:20:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235230AbhK2GXc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 01:23:32 -0500
Received: from mail-mw2nam10on2057.outbound.protection.outlook.com ([40.107.94.57]:26976
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232516AbhK2GVa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Nov 2021 01:21:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nCjF9O9m7nhwqSsRyhw61pC+zp4xDQ8m7/lU/X7HyKxcj14c1/nd+ZR8ImhQ3Ob0xWzNRSCNiUvXxEYAYivedkxnmuWWMH26C4ZOJ5+/hofQmKk5+bokNkQRXSjisYXgQgekaqfZyJ9DP38HaRMu94mHlx3u7kEnphQZR7Q0EuUuVDz0z5Eydjelzq+MBA++GNtC6Kkcd9dVmCHlTIA8HNWPa1yo2jJEtgGsJtKFrOPkHcARrB+cFF60XI6jyiK2qR4Q4fRMBybIMzxnLVz0e7tsMwKnuDSXvpYbcZvnQr4zDKyIrQfmaBlKZNs214pLt6/kZ9QSIAEt8mjv8RRH9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z/OzzLhmRgfXagrbB4RlSliIzbYl30TFrjXDpzaCpaw=;
 b=h72pAKvMK0rSUoXIKZcb3UhJCWlGPpsdfWGTaguy8pZ6ICyEPBfl1eIZ+JgfS5rwv47ZafJ+nzxoWNxtXCyz9G+PqaX4r+TpypY/dZn6NJlnG3G8N+UCYyY+WqZ/boM8kFL6VxtP+ap8DW59ZJbU4w4OG3HrxzrtVEuCq3XqmBHFTxjOjWaH4BrTj0q5scSjuhyaGEuUa/CZouzjCT/T4dZQVcIhb/OtyBPFrOJ6weszY2SNyV0j6XfNdKQeISzKoIEu+0np4CrCzRDEI/oOoN6SLpyRaOAz06pxtJeOA1L+UPOd65Cl5PMPhpjnlA8gr8vmvzfvsPZjndlRL3QSNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z/OzzLhmRgfXagrbB4RlSliIzbYl30TFrjXDpzaCpaw=;
 b=cXFG63+J6CfoFvXiyVaE8zWBou15gbQomXMMHVFsrJMth6/VwVZOm4iVzyWml8xXg/45077YTNkNmlzuuzKytq90YGfkV+9JVPsrj2aveW2wYw9bUEyv/qZyWdt/sWGwaLEwuelwfO6oTuri4DNfxAF1u9cz0JYweMKdctkipReDxDbf+syC8hWq7CcOy0+JIoRz1d3A536/fveDV2ZwfM755l7H0680FVzSeN6nc/mr+3SQhF0opP/BeOczKwget+cR2d+1D8YQO1GV6V3OCiroursLhx99D12inBp6QdYYWXWg+4UqnTUxqpuq0PyC96KUFiX06M0nvuiEpup5nA==
Received: from MWHPR19CA0006.namprd19.prod.outlook.com (2603:10b6:300:d4::16)
 by BN9PR12MB5384.namprd12.prod.outlook.com (2603:10b6:408:105::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.24; Mon, 29 Nov
 2021 06:18:11 +0000
Received: from CO1NAM11FT028.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:d4:cafe::92) by MWHPR19CA0006.outlook.office365.com
 (2603:10b6:300:d4::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22 via Frontend
 Transport; Mon, 29 Nov 2021 06:18:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT028.mail.protection.outlook.com (10.13.175.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4734.22 via Frontend Transport; Mon, 29 Nov 2021 06:18:10 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 29 Nov
 2021 06:18:07 +0000
Received: from d3.nvidia.com (172.20.187.5) by mail.nvidia.com (172.20.187.13)
 with Microsoft SMTP Server id 15.0.1497.18 via Frontend Transport; Mon, 29
 Nov 2021 06:18:06 +0000
From:   Benjamin Poirier <bpoirier@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Kangmin Park <l4stpr0gr4m@gmail.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        "Robert Shearman" <rshearma@brocade.com>, <netdev@vger.kernel.org>
Subject: [PATCH net 2/2] net: mpls: Remove rcu protection from nh_dev
Date:   Mon, 29 Nov 2021 15:15:06 +0900
Message-ID: <20211129061506.221430-3-bpoirier@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211129061506.221430-1-bpoirier@nvidia.com>
References: <20211129061506.221430-1-bpoirier@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c2d284b9-d09b-4be0-cc3e-08d9b3000495
X-MS-TrafficTypeDiagnostic: BN9PR12MB5384:
X-Microsoft-Antispam-PRVS: <BN9PR12MB53849B6D9B904AB5F06DE2DEB0669@BN9PR12MB5384.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:96;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zV+NsFPZU2y+yvVF0AgQxjF2SwkNe5R8WXNQh2Y7/q061NHxLfsVpgiULfAl6g6ccxwCpmQdsLagkNbTXqXJWTFAJlVAsJF/61jR7o7uZWxAut36zEmL9v67bXXC/pqhzOLEZH+BYuPYsHTP5LD+vkNeT5IVkYAAlQZaAUqnOWB0x1JQrAkR6AtHBzCtPHgEuXEipYP0s6UDiKblD0CVxEb0tGJ2mVbpKmABwi0C/xrkYyDBEc2wd4kYEjKzUwLa+ZMZNbcqlxJFvoNr1DcefVSzaKELWEeqWJgVIoewrMsfK/lQ/Z08Ny9w/L+wtRk+hqhfpWRnFm3shKF6usvGcaYngtUOIGNOkV9UXCo4sgitPRoax78IP6xV/AewcbkgHxnHRGSv/6FpPopXL5C1rf4Ar8EprY28JBxlDTE2LzKAFElra8KOjblKgLNQrpulWBhtjwCntqeWykV929/hoTA7DC5FiRKtFwGjapcs2DWAQcUQC3sXBko8QS7XHpFQSOuTbFhxGuPp7eEUNM3h/iX4F1G7yVcesquvnFghmIiBztmDkCMy1Jo1Hd++JnJAJGapxspB+Ryq0oldrpRFlylpF/F+sr0I7+rEql8rQNZblkrMt3i4hpq81KhpWnTA7hZd15mGD+FnFkxjDXluZoW+1S+aUWuhFcezWbdtcX5CVMXpc08sa80xfLnE1x3XcCR7J5WpM5s6b6nEF9ufrw==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(2906002)(5660300002)(186003)(7696005)(70206006)(82310400004)(36860700001)(4326008)(316002)(54906003)(47076005)(110136005)(8936002)(7636003)(86362001)(1076003)(83380400001)(336012)(70586007)(26005)(2616005)(356005)(426003)(36756003)(8676002)(508600001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2021 06:18:10.6784
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c2d284b9-d09b-4be0-cc3e-08d9b3000495
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT028.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5384
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Following the previous commit, nh_dev can no longer be accessed and
modified concurrently.

Signed-off-by: Benjamin Poirier <bpoirier@nvidia.com>
---
 net/mpls/af_mpls.c  | 39 +++++++++++++++------------------------
 net/mpls/internal.h |  2 +-
 2 files changed, 16 insertions(+), 25 deletions(-)

diff --git a/net/mpls/af_mpls.c b/net/mpls/af_mpls.c
index 6e587feb705c..0c7bde1c14a6 100644
--- a/net/mpls/af_mpls.c
+++ b/net/mpls/af_mpls.c
@@ -409,7 +409,7 @@ static int mpls_forward(struct sk_buff *skb, struct net_device *dev,
 		goto err;
 
 	/* Find the output device */
-	out_dev = rcu_dereference(nh->nh_dev);
+	out_dev = nh->nh_dev;
 	if (!mpls_output_possible(out_dev))
 		goto tx_err;
 
@@ -698,7 +698,7 @@ static int mpls_nh_assign_dev(struct net *net, struct mpls_route *rt,
 	    (dev->addr_len != nh->nh_via_alen))
 		goto errout;
 
-	RCU_INIT_POINTER(nh->nh_dev, dev);
+	nh->nh_dev = dev;
 
 	if (!(dev->flags & IFF_UP)) {
 		nh->nh_flags |= RTNH_F_DEAD;
@@ -1510,12 +1510,9 @@ static int mpls_ifdown(struct net_device *dev, int event)
 			u8 deleted = 0;
 
 			for_nexthops(rt) {
-				struct net_device *nh_dev =
-					rtnl_dereference(nh->nh_dev);
-
-				if (!nh_dev || nh_dev == dev)
+				if (!nh->nh_dev || nh->nh_dev == dev)
 					deleted++;
-				if (nh_dev == dev)
+				if (nh->nh_dev == dev)
 					nh_del = true;
 			} endfor_nexthops(rt);
 
@@ -1540,7 +1537,7 @@ static int mpls_ifdown(struct net_device *dev, int event)
 		change_nexthops(rt) {
 			unsigned int nh_flags = nh->nh_flags;
 
-			if (rtnl_dereference(nh->nh_dev) != dev)
+			if (nh->nh_dev != dev)
 				goto next;
 
 			switch (event) {
@@ -1553,7 +1550,7 @@ static int mpls_ifdown(struct net_device *dev, int event)
 				break;
 			}
 			if (event == NETDEV_UNREGISTER)
-				RCU_INIT_POINTER(nh->nh_dev, NULL);
+				nh->nh_dev = NULL;
 
 			if (nh->nh_flags != nh_flags)
 				WRITE_ONCE(nh->nh_flags, nh_flags);
@@ -1588,14 +1585,12 @@ static void mpls_ifup(struct net_device *dev, unsigned int flags)
 		alive = 0;
 		change_nexthops(rt) {
 			unsigned int nh_flags = nh->nh_flags;
-			struct net_device *nh_dev =
-				rtnl_dereference(nh->nh_dev);
 
 			if (!(nh_flags & flags)) {
 				alive++;
 				continue;
 			}
-			if (nh_dev != dev)
+			if (nh->nh_dev != dev)
 				continue;
 			alive++;
 			nh_flags &= ~flags;
@@ -2030,7 +2025,7 @@ static int mpls_dump_route(struct sk_buff *skb, u32 portid, u32 seq, int event,
 		    nla_put_via(skb, nh->nh_via_table, mpls_nh_via(rt, nh),
 				nh->nh_via_alen))
 			goto nla_put_failure;
-		dev = rtnl_dereference(nh->nh_dev);
+		dev = nh->nh_dev;
 		if (dev && nla_put_u32(skb, RTA_OIF, dev->ifindex))
 			goto nla_put_failure;
 		if (nh->nh_flags & RTNH_F_LINKDOWN)
@@ -2048,7 +2043,7 @@ static int mpls_dump_route(struct sk_buff *skb, u32 portid, u32 seq, int event,
 			goto nla_put_failure;
 
 		for_nexthops(rt) {
-			dev = rtnl_dereference(nh->nh_dev);
+			dev = nh->nh_dev;
 			if (!dev)
 				continue;
 
@@ -2159,18 +2154,14 @@ static int mpls_valid_fib_dump_req(struct net *net, const struct nlmsghdr *nlh,
 static bool mpls_rt_uses_dev(struct mpls_route *rt,
 			     const struct net_device *dev)
 {
-	struct net_device *nh_dev;
-
 	if (rt->rt_nhn == 1) {
 		struct mpls_nh *nh = rt->rt_nh;
 
-		nh_dev = rtnl_dereference(nh->nh_dev);
-		if (dev == nh_dev)
+		if (nh->nh_dev == dev)
 			return true;
 	} else {
 		for_nexthops(rt) {
-			nh_dev = rtnl_dereference(nh->nh_dev);
-			if (nh_dev == dev)
+			if (nh->nh_dev == dev)
 				return true;
 		} endfor_nexthops(rt);
 	}
@@ -2258,7 +2249,7 @@ static inline size_t lfib_nlmsg_size(struct mpls_route *rt)
 		size_t nhsize = 0;
 
 		for_nexthops(rt) {
-			if (!rtnl_dereference(nh->nh_dev))
+			if (!nh->nh_dev)
 				continue;
 			nhsize += nla_total_size(sizeof(struct rtnexthop));
 			/* RTA_VIA */
@@ -2504,7 +2495,7 @@ static int mpls_getroute(struct sk_buff *in_skb, struct nlmsghdr *in_nlh,
 	    nla_put_via(skb, nh->nh_via_table, mpls_nh_via(rt, nh),
 			nh->nh_via_alen))
 		goto nla_put_failure;
-	dev = rtnl_dereference(nh->nh_dev);
+	dev = nh->nh_dev;
 	if (dev && nla_put_u32(skb, RTA_OIF, dev->ifindex))
 		goto nla_put_failure;
 
@@ -2543,7 +2534,7 @@ static int resize_platform_label_table(struct net *net, size_t limit)
 		rt0 = mpls_rt_alloc(1, lo->addr_len, 0);
 		if (IS_ERR(rt0))
 			goto nort0;
-		RCU_INIT_POINTER(rt0->rt_nh->nh_dev, lo);
+		rt0->rt_nh->nh_dev = lo;
 		rt0->rt_protocol = RTPROT_KERNEL;
 		rt0->rt_payload_type = MPT_IPV4;
 		rt0->rt_ttl_propagate = MPLS_TTL_PROP_DEFAULT;
@@ -2557,7 +2548,7 @@ static int resize_platform_label_table(struct net *net, size_t limit)
 		rt2 = mpls_rt_alloc(1, lo->addr_len, 0);
 		if (IS_ERR(rt2))
 			goto nort2;
-		RCU_INIT_POINTER(rt2->rt_nh->nh_dev, lo);
+		rt2->rt_nh->nh_dev = lo;
 		rt2->rt_protocol = RTPROT_KERNEL;
 		rt2->rt_payload_type = MPT_IPV6;
 		rt2->rt_ttl_propagate = MPLS_TTL_PROP_DEFAULT;
diff --git a/net/mpls/internal.h b/net/mpls/internal.h
index 838cdfc10e47..893df00b77b6 100644
--- a/net/mpls/internal.h
+++ b/net/mpls/internal.h
@@ -87,7 +87,7 @@ enum mpls_payload_type {
 };
 
 struct mpls_nh { /* next hop label forwarding entry */
-	struct net_device __rcu *nh_dev;
+	struct net_device	*nh_dev;
 
 	/* nh_flags is accessed under RCU in the packet path; it is
 	 * modified handling netdev events with rtnl lock held
-- 
2.33.1

