Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 141644CAA4D
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 17:33:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242502AbiCBQd6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 11:33:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242446AbiCBQdj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 11:33:39 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2052.outbound.protection.outlook.com [40.107.223.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 037C52191
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 08:32:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U0i+MFwWobSqzMXiVoSkcpYyDYpYqdVWewiWnR2GrXIQH+wE9RROfy542+SvB/CGZePrtzqH5sgLvdVBVO6WZPIb8oKfo63W3TJU1vLeSWIqeiTEDaZN+mJHDZzd/36OuztRo2Tql3Bt3npSAGhdm/JWx7lwdGbgciAarq9PQVww1qEAlDebCnApdaqGz7GI0FhQB3IXu9K4qF2F6vw1JZQzpzUkRMow0+N26+Sg6bw5dNMAMcAM/cu82tpcU5Tf+ueQk3ji7EbTDh6WWZZdpPg3wj/iumXEa7QJR5ypyiJF6riM+vndKbYEEkU0ME4rDrn3Kbp8U0HvB5XRo38q0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xqWbRTTi+2VDNTs2GUwsZGvraIsdsdKpZTgVRCtqLcE=;
 b=V77ezCo+Shr3Yuqq9vUFWSoag1CNLDvluo+u41tMdbbhbyyHd2X+SYG4S8dywKHPa+7TY0rr4i654rpnDlj46VlsCgG2uwQcubVG21nVNaxXVsCtX55Wsy3nR8JJqGFMZAOG8tnEb04LTI7j4ieTLtqPqnMbdqGV1yzKgYjRHYQNtK7D0nMp4Vv0iR820cSf7av/+q/Sz+n7C+f0acuPeok4DIn1+36l3+IHEKtmz67VrFhfrAQp2XYdKbcEMjKORzWUmxJXpwG9PUz6RbhdxiVtiwiKpUBUKskBNDOuQ146xslbckiT1RlAW95kAC25VBDOWHXFJ2NxRvlemIjW8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xqWbRTTi+2VDNTs2GUwsZGvraIsdsdKpZTgVRCtqLcE=;
 b=gSy+4o3s6V15RDn/mob4dN9na9+nlCTuU1JIu4YfJA7aJokSJbPozHvwNXAdPBXDezdSz5jicYbsn+2djzJVj+loj6MF85+9baNWRdk7GbT+uGR6K+97QHDkU5eI4L5hgDSvv8TizhcyVTZsJaEMtKeYIkqGBnrS39O/fgCigc7ys/9oES4MSIRgJGQfIWDbWH+im54fdkKcPsygLC4SokX2XOtYbFPNVyG7xDF5fP7Ar/khe1BvWukcw6gCXiEHx0+9jSTVidMn6K62OJ36NzpzpTy3a/0fsxpuWJffT0IKWKjsmRoPMipNd1ZvKjrAS2N/qt+nnBXCsPRs9hm+PQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by BN8PR12MB3057.namprd12.prod.outlook.com (2603:10b6:408:64::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24; Wed, 2 Mar
 2022 16:32:52 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581%6]) with mapi id 15.20.5038.014; Wed, 2 Mar 2022
 16:32:52 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        jiri@nvidia.com, roopa@nvidia.com, razor@blackwall.org,
        dsahern@gmail.com, andrew@lunn.ch, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 09/14] net: rtnetlink: Add UAPI toggle for IFLA_OFFLOAD_XSTATS_L3_STATS
Date:   Wed,  2 Mar 2022 18:31:23 +0200
Message-Id: <20220302163128.218798-10-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220302163128.218798-1-idosch@nvidia.com>
References: <20220302163128.218798-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR09CA0062.eurprd09.prod.outlook.com
 (2603:10a6:802:28::30) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0338816b-f7dd-40f8-62c2-08d9fc6a4c09
X-MS-TrafficTypeDiagnostic: BN8PR12MB3057:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB305714E0197564615C6AD3D1B2039@BN8PR12MB3057.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MOC/ksm7hj0+R4i9i2GJnRjH5xBpr5TtRDeS5a9jVy8kWmuj1/5P5VAqKvug1vbk3q/DsEW8RHkyCUD5DCKPvXF97AJgUzbtmhY+9vhqXo6BJHExBcHBlEiGsbVDp5j60gW6kc9YyIrVew4i+f+UIYDEsGmaRAfe5B5rIcwqoAj8v6N/DBhvNJWFegRnD8ZYPMeEe0NgodvVzgVju2GXA6AihlUmpapr6FUtBeKGtFwaqYkw1RpQn01eEpzSRNwyKqe9cFHCAKPC9YdLPGkcq6+7Qi2hoNpjzSPDErJbzAbn43Q38goSlD1TRTMhDQosoiyaXUoq6si26ml/4E4SpyoYMLdnTWxQkAuEOeI7tH7kMZKLP1AsNkeN7I13HJBf/3kMgXP1teGiCAspfuZwl+d9KheNU+G8KM8N3gUqJIOVCeqBYlMjOYKuJwL6j3Mpf1VzqSpPaas27sP2aAmrfWwv2BZ7ZRzbbH/X+m9QecCSw+o0/SK3wm3azPk5MH4nsCb+ADsPcdfDkyzbVPoCteE1g3x+kHSxRM/EFymGxxfzITLcMmME2KR1MqIt8IW+GgaEjKZ25jxqV5+//wBMuZofTiqePBuxmxo+DY+0hso9/u0bCENCOPQAhUfPI7pdBJZfjeC5sh0cWbcw668WXCtlFnGjNrF1DtAgoHYbwRfKoWoSHw0K8HW2GQCRwzE9ETUWj4gkBCIqypm8BTT8kA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(6666004)(6506007)(36756003)(38100700002)(83380400001)(508600001)(6916009)(2616005)(6512007)(1076003)(107886003)(316002)(8936002)(86362001)(5660300002)(26005)(186003)(66476007)(66946007)(8676002)(66556008)(2906002)(4326008)(21314003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?efg1/RM9atkZFyvsD3Mrye84KdPxoZ3XPPN3pU9gn3+OIaXtYCrRIbpEDz9P?=
 =?us-ascii?Q?LTeY4QjwONAnDOGTnYHVMQ6HSZMp66nrjSaLPg1dE4eHdw14qnKpr7n29K7c?=
 =?us-ascii?Q?pDdeMy7SET6yiMTfJuvZtgrWcG8KsGD764IDKNroNhcvLM+GFSXcOrpKQBp3?=
 =?us-ascii?Q?0nQTo9zrZ/U8JOE/mZ48TGe1H6feYfHyhNFqWQWHOFz+7P+uXGMBL5Bbasx1?=
 =?us-ascii?Q?/t4sbwGi6s5Kfe1eonupmGBkkubhnpud+wakOl6GXGdqAaunruY5o+tp1C1B?=
 =?us-ascii?Q?inCm60Wco1fPRh6I64zlqKzGSrxpK+tHbD1qJSz8kdv332TOhPZ1uGgVVPZr?=
 =?us-ascii?Q?lQVvCyxoR6/E1CswA9VumKu6YBNXTAl3cKn8IG7B0a6o3EYOy9TjYiCwX+YA?=
 =?us-ascii?Q?MlAJfHLHVzY4cSmM/R/aEWswvLPSjb/xv1fz5hiuzN/qpsN0n/gKy0dPU0mL?=
 =?us-ascii?Q?IoHGg/uFuPi8GvM7JYMm80wmHYhq1L1nml4smgo5U8Re2+Bv8T5VFIIu4e8l?=
 =?us-ascii?Q?UWVYvf8leeKg5Vzc2vczdgcz0CLzNnQj0AFdOZTmOd95EU1vChu+YqU9OQ3T?=
 =?us-ascii?Q?WsyOgcwlYg3K0hUrIIECSieyR0LjoPlaS0Q/IBhXZYDpYkpZbeteVzlzQXh2?=
 =?us-ascii?Q?GqMmWDDyMrctLwFJHrlvkjnSAU2YWptv89pmGG5ZfOiE5EVVwVwXCY3RXiFF?=
 =?us-ascii?Q?9X7ZI0bAbZciw4sQKL32mE9ugDpLwNv2OlNKgxSudievYXSg0avoj2ycYnhS?=
 =?us-ascii?Q?66hEdh/2uJLQDMEwkRrCmXEoA4UZ2ucOoT4VWUXvvbp7VAhFNiGC54U1ohGG?=
 =?us-ascii?Q?JgT1wt47gSzAQu9Cz2xaxFWxWPR6aBU/KkJlT3j76TjhcYXdJVuiCZuyZ/+d?=
 =?us-ascii?Q?BxXirG28W840LCN9fCmrR9ok1UDLujuT1+KU+zbZKBZQPHIksVOfNacNdPFd?=
 =?us-ascii?Q?aocHaRtfZEPOE+4KJ54fesWaeLMW3rmNqKXOmqTkNF5qDSNzqOcjj/1fexS/?=
 =?us-ascii?Q?l2Cv2CvpsMRqOEjq/Oxxo5NxhzG1L/ckJOlVQfWdA9COOpzlcMTUtynvI5PJ?=
 =?us-ascii?Q?w6wHUASGv8cycVdWu7qQEz0ZGWdykEng1IFiSWq7V9tlKVFSHeTyYGWOQpzb?=
 =?us-ascii?Q?eZh2moWjvlah2f1ucLP+Wl6q8P7FyYyF0f8fNFVdsFisZwMO05c1iXlF9CLO?=
 =?us-ascii?Q?htWaIRV/Fdx2RzziAAw+2jBT8FeTC+I4QEZOnuyQfzSZrpW33uo0p2Vdhl9h?=
 =?us-ascii?Q?uERjhhZmmE3egfJuMT5O1KEo+R5W5iXCct9TFbjZLh11oKXQPcLaTeMnlLQH?=
 =?us-ascii?Q?/DO5al+dJaO4/DGL712wughJbUzteAId+GARDf0VK+nqTURWtsBZsC+dOkIK?=
 =?us-ascii?Q?FJBDttkpawTFgm/tQNkSIhRaQVdh5XI1o53niOlzefymwjW32H8es5U5f5Th?=
 =?us-ascii?Q?mT7X4uy4jIhdZwBPAYP5WSPhNV8NLgXpUiMzCeTDeid3V+S0TBzR5qYCUr18?=
 =?us-ascii?Q?U/si4V7sw1kddrRz4IZUSM7Cb76cb+WCh9BBE/Gf4FiM9FkXsyy93kc14ShB?=
 =?us-ascii?Q?dXiU1uDqjz683U/DXh6DBr19sg3kYb38sSYsBlOIPuKRillVaUOmoURH4+Wj?=
 =?us-ascii?Q?iRDfnz7oeYKAAa8p9tR5GDo=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0338816b-f7dd-40f8-62c2-08d9fc6a4c09
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2022 16:32:52.4708
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CcU20QnMuN+069M74NgKzIDIWpyDqsYL1qN5OU0+tL7ThJITR5YY2GLSPP4xkU8QXDbiKus0uC5UkmPtFk4dLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3057
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index b1031f481d2f..ddca20357e7e 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -1227,6 +1227,7 @@ enum {
 	IFLA_STATS_GET_FILTERS, /* Nest of IFLA_STATS_LINK_xxx, each a u32 with
 				 * a filter mask for the corresponding group.
 				 */
+	IFLA_STATS_SET_OFFLOAD_XSTATS_L3_STATS, /* 0 or 1 as u8 */
 	__IFLA_STATS_GETSET_MAX,
 };
 
diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.h
index 14462dc159fd..51530aade46e 100644
--- a/include/uapi/linux/rtnetlink.h
+++ b/include/uapi/linux/rtnetlink.h
@@ -767,6 +767,8 @@ enum rtnetlink_groups {
 #define RTNLGRP_MCTP_IFADDR	RTNLGRP_MCTP_IFADDR
 	RTNLGRP_TUNNEL,
 #define RTNLGRP_TUNNEL		RTNLGRP_TUNNEL
+	RTNLGRP_STATS,
+#define RTNLGRP_STATS		RTNLGRP_STATS
 	__RTNLGRP_MAX
 };
 #define RTNLGRP_MAX	(__RTNLGRP_MAX - 1)
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index d09354514355..a66b6761b88b 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -5566,6 +5566,7 @@ rtnl_stats_get_policy[IFLA_STATS_GETSET_MAX + 1] = {
 
 static const struct nla_policy
 ifla_stats_set_policy[IFLA_STATS_GETSET_MAX + 1] = {
+	[IFLA_STATS_SET_OFFLOAD_XSTATS_L3_STATS] = NLA_POLICY_MAX(NLA_U8, 1),
 };
 
 static int rtnl_stats_get_parse_filters(struct nlattr *ifla_filters,
@@ -5773,16 +5774,51 @@ static int rtnl_stats_dump(struct sk_buff *skb, struct netlink_callback *cb)
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
@@ -5814,24 +5850,29 @@ static int rtnl_stats_set(struct sk_buff *skb, struct nlmsghdr *nlh,
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

