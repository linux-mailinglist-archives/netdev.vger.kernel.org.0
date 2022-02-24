Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B66E04C2D3E
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 14:35:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235060AbiBXNf0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 08:35:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234967AbiBXNf0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 08:35:26 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2068.outbound.protection.outlook.com [40.107.243.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1B14178690
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 05:34:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I8eB+BGFZQgiKr/UgsQGwuqJ11auIq6nLgpnaIZXt+YUzI4RWMJcmD/CUb7R4Mzov+o5Js7Mrk/WTS++QE3mpir9aAZpl20eF8V1QYoOjQMin7Mx9ZNqzh/sYahexjNEK/xeBqpfR+2txjP9q3zfaI2Hm6W0Dw9EZKX6S+wFbYW5drYitJnATcz2cilus6eo5qZNJQERBtFaepkhz5j3rkM7ZlwIqgpqmOOolCL0s6Y3xN1ZIrn1k/KswSonKfkQcbfEP9dL6Sol2YAjs8O5l4KN/kGXEbs/7gNdPI5Ou3XnqaUw2IcgIHdY1VNKzY2J/lXAiU4Efzbbv1URIJVtKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t9U3gHs0hXcwTkPledM+C5Hf6+XAoI254wQnhP+Rye4=;
 b=kYTJr9E++l7XZPj12s37Vyl7D5zLuOeXP3IBotHYuMTwxJzZg4TcxB3wt5/A3/5Tsa3qjJeYGa+/2b9Hi/8Z0N02SD7A4nXiI8FjjxWMdk4MHYM63b9eVi3ghDdlaGwVPAsSKN2qdcQXdFi4vFr9AFOtV7pDlOtofwLzfZLZXhRStk0wEUQ22k7KIYkmMIXyiEe63ZxOCFMvDIZl5sxzj4j8mwzK/06ILe3JeReh2/CQU7GZDXiPrl+aQutWEY802y1BXzlPkkGJVZ90TNeO4/D0uxXDOYiqZAIWo5WCGMbazCNr71UEHXyDkqzFcyaEtP9swHauaA9ivMiNS85aPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t9U3gHs0hXcwTkPledM+C5Hf6+XAoI254wQnhP+Rye4=;
 b=jxiJ+ApZ8rcXzG85khvN7DTMDrAoqlvNSMQtQYBrYYn9HEAKIXVgOe0CsMlX4IzfWkZoReVSdhQxjYN/SJTHBvwZ/HWiEXrD0FNpdz8e5fOiNn4/X6+GHvGpaBwPNwg1x10c5QF3wDmz4i3tPoYZWcvTuS+fht8K3+Szvl3RKYendRHPRi15h2nNjcpt9HXDrjNeMprQ8DLVCRtV5bIwhT9LtaPBk+Ptey12TazNvBKVLGGGzGo/VppD+AQYL+AmqFbi2CYnVJlYQOsGhe2l0RjdsjEltuAiKxORwmSIZ8IksjlnBU8sVwDqSoWCjipdJt5kKdghCFEziFv5pT4dUw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by DS7PR12MB6008.namprd12.prod.outlook.com (2603:10b6:8:7f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.24; Thu, 24 Feb
 2022 13:34:55 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581%7]) with mapi id 15.20.5017.025; Thu, 24 Feb 2022
 13:34:55 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        jiri@nvidia.com, razor@blackwall.org, roopa@nvidia.com,
        dsahern@gmail.com, andrew@lunn.ch, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 09/14] net: rtnetlink: Add UAPI toggle for IFLA_OFFLOAD_XSTATS_L3_STATS
Date:   Thu, 24 Feb 2022 15:33:30 +0200
Message-Id: <20220224133335.599529-10-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220224133335.599529-1-idosch@nvidia.com>
References: <20220224133335.599529-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0602CA0024.eurprd06.prod.outlook.com
 (2603:10a6:800:bc::34) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4085835e-4606-40c9-2ca3-08d9f79a7189
X-MS-TrafficTypeDiagnostic: DS7PR12MB6008:EE_
X-Microsoft-Antispam-PRVS: <DS7PR12MB60089D71D12AF01E3AE8FC58B23D9@DS7PR12MB6008.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FPc6IyoPJ5sm1zafWOWV/KPbOARw6mb0qCSmTyaGncz80tPaWzouve2SgMDWUBydC9otCI4qBscfVBIanqE4daWIckWdodQt8l9wLHVt2b5JOvts51rP4T/+IUmL91/aG1zjN/KN7+vXWCif3mlDYXSlZucileRutPJEh2FogpoCDtSqvdicj+IRyt1XjBoq3dWcLsF+NYI3wk8QLFlt8+W/E2z6I4WzJ6XAb8LtwvQum3JCT87wIxMf0fTgTBJa+M8cFSSKfeek5q+9pkgBSMigPfHXKkVG6PRx7tgJJ33WhPZu3GbHFJl7E3imCB6cDctUpTyn5wFGqx7xgFA4mj9D7WDi70Sqw3+0W1vO8TXqtjmY0V/Sci0upcYEDxa0KKryjN/G+7RS/eB/1dSYNnZhieoxQJDbzCnCD844AY4K3N9CX+TpH7dwbOLWKHHA005rr2rCHOnxFa2m+uou75iPyGr2Ncl+BDz/ZpGJkyxKXWGQwnNp02JM6HrZpZsZGsDSILh1sWeggrbqwYHyLnBv8SIa+hkD9KtOObzu0lR3zQopxmADQj9m33I46qvQWcwQ1QHvz0R61RjbieolpXOZeP1Frz8dWrSqbym+ojIUi4wv7Zsfq+sP1e8jEGq/o+iMAjBijATffxBLhAZWwA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(2616005)(66476007)(66946007)(316002)(38100700002)(186003)(6916009)(4326008)(8676002)(86362001)(66556008)(36756003)(6512007)(1076003)(107886003)(5660300002)(83380400001)(508600001)(6666004)(2906002)(8936002)(6486002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fI/8kU0rT5G5x1g7+zUu0j4oRczVjV6b9ExVe3ZFCNuJDnmadRLAN62Ue0Ym?=
 =?us-ascii?Q?SGioZq2b9tXXdJrqZvFwykVI4/+T4U+NdOD3ENrjNk73r8277LItyc7W3r45?=
 =?us-ascii?Q?3VtRHnqM4Q4mYgxU6I05koVzTIelT0owgL87Wp5QPMSFGUlG/x1q3DdQ+2yG?=
 =?us-ascii?Q?sosbeV12WBAVNiFNq57B4h4tGw/+3dp1X2WJRzN02DoabCgQro21JnDxoX2c?=
 =?us-ascii?Q?5dt99Dio0CRwYB0k1+GNx5DsYowVVPlvIAOBkZ+jdRQr1KgtdBB9yfOSC0IF?=
 =?us-ascii?Q?Vzmp/XEbFVZ/RxMPXNjpQE0VHYOmWAxtffCEiVxbU+OtK36IhZlzNOz9Xdex?=
 =?us-ascii?Q?Uaz2Dhf5uTNe+QcAreaHZR5xxbbRdtKoQk4KFsPjjAhPXwqOaasNhKhwNB3R?=
 =?us-ascii?Q?+EP0rBwEvBpmnho5IqXHfTctO0bX/jNZ/0+ZidFfuQ4/R2t+0vdSAGH1NI4L?=
 =?us-ascii?Q?8shzSjqWm/AHxkIY5l51CXi1zp7w7g4YO0n00HoPUJkgjx+NEvCK2JzWr2EM?=
 =?us-ascii?Q?uhlRwRcNxc7JONH9sdAxv0n9XAbIZrpxM59wqj3eEVQKKLvclm0EeDbVAKAs?=
 =?us-ascii?Q?hc9eaMfWk4yIVhL5zIGwf1pCm8jbEJp1Qs9DFZ8I9GquS8s3QSMrnM7tEZXb?=
 =?us-ascii?Q?HnZ244FDCyMy2UQOLY9AsElA89a8WqOU4w9/Rv7ndMlban4Filfj+/aErcVx?=
 =?us-ascii?Q?wo6Hs1VLnkm7te/iXlR2abUywAsJzp+2R4FE39192j0p0lgvz+qDwqi9TafQ?=
 =?us-ascii?Q?abo6LQxGNG2KXFe1KdG7Fu0u25JRl5TQgKnreBorZXxGsb4VuwpkNS93bXDN?=
 =?us-ascii?Q?TPI6b1CtHwNL3tCgYMMLaUcheMMLq7lY7sLePHNOckTOe457evrIfRr4zqTU?=
 =?us-ascii?Q?7V+wl5/r6ccYz+1tXgOYM4TM0Uv965pPwipVc69N+Uzo3i/PqVhtKnm9/i97?=
 =?us-ascii?Q?N4LidupIKyf4CT2l3uonKulJgp0SQgymdJyVfg4Wf5B9gmNIiyRI2h+68+eG?=
 =?us-ascii?Q?4LfF+3Nruz6Oj/b6zR2ZJyt6QbpsfbcdBp8E7sD/IqJFRipGU2UU3SgAQ6f9?=
 =?us-ascii?Q?nLRouYBbfad8gVLA74WFo/bEmfvGHdJQEfzWQIScaDS4W1dhrCk7XtAPUQHU?=
 =?us-ascii?Q?gD2Em+LRecrOIzFHyXO2RyD8KEJxUubKVH9O/ck2LAF4ddoiYyppNCHfe9WJ?=
 =?us-ascii?Q?I5cG7pHnkiPMrR1QSXpRM+ML8TEJCY4jT0eVg2xnrcKV5XTAwvec8OYjtCxf?=
 =?us-ascii?Q?TWy8Ogw4u4cpdjbcPxaMyCabdtwRGcK1qIEtR2gXPLmbWBonnzSyhAD4Cw15?=
 =?us-ascii?Q?hv6lKZ7wrKdRkwXz2mGO0eUIjgpOLsPpgjCdrOuTp7+5oQ7LCpNKT+8lr7qm?=
 =?us-ascii?Q?U5Mq3o4SzbQfSVNZ+yTArEJQU/I2Ozb6vhnby5PcJKQpOsQuVyuac4cWJ8jt?=
 =?us-ascii?Q?B9b+O+nVb6gLMvJKV/I89B4i00IC2fg5E8s3EFCIAxWFLSCnEDpD+B34fbCi?=
 =?us-ascii?Q?tM+y4JBjJ7WpjnNMfX3ERc3wjCDlK7mPSvKDgaRsBNqHcNMIjwXSrIwGDhcW?=
 =?us-ascii?Q?fiOqZukBpJpds5E5UuOmU7VwgAuK+T5l0mM/Bk0QUL13s3wC83MValgcgHzh?=
 =?us-ascii?Q?V8UABfXM4iVrH8NU2owhfp8=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4085835e-4606-40c9-2ca3-08d9f79a7189
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 13:34:55.2412
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aBIAv7tu5+EAExarciafzf9Ld1BPmWbW4a6Eh87IQONrpsy2A6D2Th/6pTcxSv0GimEuaCn2rDmTYVchiOjeag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6008
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

The offloaded HW stats are designed to allow per-netdevice enablement and
disablement. Add an attribute, IFLA_STATS_SET_OFFLOAD_XSTATS_L3_STATS,
which should be carried by the RTM_SETSTATS message, and expresses a desire
to toggle L3 offload xstats on or off.

As part of the above, add an exported function rtnl_offload_xstats_notify()
that drivers can use when they have installed or deinstalled the counters
backing the HW stats.

At this point, it is possible to enable, disable and query L3 offload
xstats on netdevices. (However there is no driver actually implementing
these.)

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 include/linux/rtnetlink.h      |  3 ++
 include/uapi/linux/if_link.h   |  1 +
 include/uapi/linux/rtnetlink.h |  2 +
 net/core/rtnetlink.c           | 75 ++++++++++++++++++++++++++--------
 4 files changed, 64 insertions(+), 17 deletions(-)

diff --git a/include/linux/rtnetlink.h b/include/linux/rtnetlink.h
index bb9cb84114c1..7f970b16da3a 100644
--- a/include/linux/rtnetlink.h
+++ b/include/linux/rtnetlink.h
@@ -134,4 +134,7 @@ extern int ndo_dflt_bridge_getlink(struct sk_buff *skb, u32 pid, u32 seq,
 				   int (*vlan_fill)(struct sk_buff *skb,
 						    struct net_device *dev,
 						    u32 filter_mask));
+
+extern void rtnl_offload_xstats_notify(struct net_device *dev);
+
 #endif	/* __LINUX_RTNETLINK_H */
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 704e32bbf160..4d35d5fed8e1 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -1164,6 +1164,7 @@ enum {
 				 * bitfield32 with a filter mask for the
 				 * corresponding stat group.
 				 */
+	IFLA_STATS_SET_OFFLOAD_XSTATS_L3_STATS, /* 0 or 1 as u8 */
 	__IFLA_STATS_GETSET_MAX,
 };
 
diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.h
index d6615b78f5d9..ad317037c8c9 100644
--- a/include/uapi/linux/rtnetlink.h
+++ b/include/uapi/linux/rtnetlink.h
@@ -758,6 +758,8 @@ enum rtnetlink_groups {
 #define RTNLGRP_BRVLAN		RTNLGRP_BRVLAN
 	RTNLGRP_MCTP_IFADDR,
 #define RTNLGRP_MCTP_IFADDR	RTNLGRP_MCTP_IFADDR
+	RTNLGRP_STATS,
+#define RTNLGRP_STATS		RTNLGRP_STATS
 	__RTNLGRP_MAX
 };
 #define RTNLGRP_MAX	(__RTNLGRP_MAX - 1)
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index daab2d246e90..d5a1195a5d1a 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -5568,6 +5568,7 @@ rtnl_stats_get_policy_filters[IFLA_STATS_MAX + 1] = {
 static const struct nla_policy
 ifla_stats_set_policy[IFLA_STATS_GETSET_MAX + 1] = {
 	[IFLA_STATS_GETSET_UNSPEC] = { .strict_start_type = 1 },
+	[IFLA_STATS_SET_OFFLOAD_XSTATS_L3_STATS] = NLA_POLICY_MAX(NLA_U8, 1),
 };
 
 static int rtnl_stats_get_parse_filters(struct nlattr *ifla_filters,
@@ -5775,16 +5776,51 @@ static int rtnl_stats_dump(struct sk_buff *skb, struct netlink_callback *cb)
 	return skb->len;
 }
 
+void rtnl_offload_xstats_notify(struct net_device *dev)
+{
+	struct rtnl_stats_dump_filters response_filters = {};
+	struct net *net = dev_net(dev);
+	int idxattr = 0, prividx = 0;
+	struct sk_buff *skb;
+	int err = -ENOBUFS;
+
+	ASSERT_RTNL();
+
+	response_filters.mask[0] |=
+		IFLA_STATS_FILTER_BIT(IFLA_STATS_LINK_OFFLOAD_XSTATS);
+	response_filters.mask[IFLA_STATS_LINK_OFFLOAD_XSTATS] |=
+		IFLA_STATS_FILTER_BIT(IFLA_OFFLOAD_XSTATS_HW_S_INFO);
+
+	skb = nlmsg_new(if_nlmsg_stats_size(dev, &response_filters),
+			GFP_KERNEL);
+	if (!skb)
+		goto errout;
+
+	err = rtnl_fill_statsinfo(skb, dev, RTM_NEWSTATS, 0, 0, 0, 0,
+				  &response_filters, &idxattr, &prividx, NULL);
+	if (err < 0) {
+		kfree_skb(skb);
+		goto errout;
+	}
+
+	rtnl_notify(skb, net, 0, RTNLGRP_STATS, NULL, GFP_KERNEL);
+	return;
+
+errout:
+	rtnl_set_sk_err(net, RTNLGRP_STATS, err);
+}
+EXPORT_SYMBOL(rtnl_offload_xstats_notify);
+
 static int rtnl_stats_set(struct sk_buff *skb, struct nlmsghdr *nlh,
 			  struct netlink_ext_ack *extack)
 {
+	enum netdev_offload_xstats_type t_l3 = NETDEV_OFFLOAD_XSTATS_TYPE_L3;
 	struct rtnl_stats_dump_filters response_filters = {};
 	struct nlattr *tb[IFLA_STATS_GETSET_MAX + 1];
 	struct net *net = sock_net(skb->sk);
 	struct net_device *dev = NULL;
-	int idxattr = 0, prividx = 0;
 	struct if_stats_msg *ifsm;
-	struct sk_buff *nskb;
+	bool notify = false;
 	int err;
 
 	err = rtnl_valid_stats_req(nlh, netlink_strict_get_check(skb),
@@ -5816,24 +5852,29 @@ static int rtnl_stats_set(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (err < 0)
 		return err;
 
-	nskb = nlmsg_new(if_nlmsg_stats_size(dev, &response_filters),
-			 GFP_KERNEL);
-	if (!nskb)
-		return -ENOBUFS;
+	if (tb[IFLA_STATS_SET_OFFLOAD_XSTATS_L3_STATS]) {
+		u8 req = nla_get_u8(tb[IFLA_STATS_SET_OFFLOAD_XSTATS_L3_STATS]);
 
-	err = rtnl_fill_statsinfo(nskb, dev, RTM_NEWSTATS,
-				  NETLINK_CB(skb).portid, nlh->nlmsg_seq, 0,
-				  0, &response_filters, &idxattr, &prividx,
-				  extack);
-	if (err < 0) {
-		/* -EMSGSIZE implies BUG in if_nlmsg_stats_size */
-		WARN_ON(err == -EMSGSIZE);
-		kfree_skb(nskb);
-	} else {
-		err = rtnl_unicast(nskb, net, NETLINK_CB(skb).portid);
+		if (req)
+			err = netdev_offload_xstats_enable(dev, t_l3, extack);
+		else
+			err = netdev_offload_xstats_disable(dev, t_l3);
+
+		if (!err)
+			notify = true;
+		else if (err != -EALREADY)
+			return err;
+
+		response_filters.mask[0] |=
+			IFLA_STATS_FILTER_BIT(IFLA_STATS_LINK_OFFLOAD_XSTATS);
+		response_filters.mask[IFLA_STATS_LINK_OFFLOAD_XSTATS] |=
+			IFLA_STATS_FILTER_BIT(IFLA_OFFLOAD_XSTATS_HW_S_INFO);
 	}
 
-	return err;
+	if (notify)
+		rtnl_offload_xstats_notify(dev);
+
+	return 0;
 }
 
 /* Process one rtnetlink message. */
-- 
2.33.1

