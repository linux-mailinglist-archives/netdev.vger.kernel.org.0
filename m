Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 826F44CAA49
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 17:33:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242249AbiCBQdl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 11:33:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242652AbiCBQdi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 11:33:38 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2071.outbound.protection.outlook.com [40.107.243.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D48BD3EBAD
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 08:32:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZmWqFpLqKFH1OGucN+CKdefB0QtUyM4vwk2dfE5N5SV3kvi1wa+CdaotnhpmxTDf+3GaKwpdQ73rkWxibJyIcFdcrwNMuOexJcAaFBr3tT7xYr+ZLezZ+zIqG9VkFWNfyeySkpf0FAgZT4wyMaNQFv+c1825sQxqh6fvOeDR11wzyGBBIE84FlssjgJd8R7PxP94t62sA2V53YT44Lidg7Se+mCnDvU/9yXs1kdJmvfVJVg2pqgR+r5uxme+/7JC9LMfUdnq2m1sczUs8SV98mwLRhYG4zau916jr8ecaNiNfaYU0jC2uy+w5eP/6G9cBJ0gHkmkBtKePkHNYIO4KA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4RT8+Di9h6DqcuvqzvwtaniGNfHINMhBtbS49HHCR4E=;
 b=dvOZneq2YsQ426A6JgOKQurKHKi+3d4UakcibO511bI/mVW/GFmMJDr+ws+x3ZYZP/SpB9GTloqNngYLeyi0aMnfarQ87ulDYq+lqbs/gfavImpEMwCHzemhtUwpN9X1IL7axw7owRHwVMjLFt0yYzHjGEKRIp6n+gWEAuJFqaisENiOchqiGyXbA5NX/cn1o036LCYFaHI7m6CSu0+upLyUvgR/QxOXVsdKAu6HhLIeGxJ7l9bZE5O2gExARCAYGIQqO1dPS0UiHki7H3W8y4mDG6RfewhTN+tzDT5t8+noCkV7db/2Pe4wm5w5fpVL1biE43Sq95jb9rVeExNAZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4RT8+Di9h6DqcuvqzvwtaniGNfHINMhBtbS49HHCR4E=;
 b=dRzg8LtLjG192tZ6je4mg6o+MDcUx6l6aIwuwxTKAp//BoA4CDxAwJvzlpK2SR9jTDX+LHLDUs6QrvOJLVcMmCoS+KssnFv5CaC7CR+AkOQ5Z0FPwV8j/Uvp5tr59BPULU/6NChu+MLTToZybLbqF6DsbpfF+ceXMjkAO78slLiq8LBBgvW4/9js66diuyvRvw4xmZbwN4gb6yZZ7u5m8fG9PvYvYX/4RQ3oFGH1/+jYiZa+dNQ5obFvtYxHfYPGjAZ2G5mdpGOHK9PROFveHMedOwVhWBqU57v5cYDlyPD1Ow2qdCgl1efpF36gVwdH3FKvaFgRWyjaYpsfNY3rIw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by MN2PR12MB3998.namprd12.prod.outlook.com (2603:10b6:208:16d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.23; Wed, 2 Mar
 2022 16:32:38 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581%6]) with mapi id 15.20.5038.014; Wed, 2 Mar 2022
 16:32:38 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        jiri@nvidia.com, roopa@nvidia.com, razor@blackwall.org,
        dsahern@gmail.com, andrew@lunn.ch, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 07/14] net: rtnetlink: Add UAPI for obtaining L3 offload xstats
Date:   Wed,  2 Mar 2022 18:31:21 +0200
Message-Id: <20220302163128.218798-8-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220302163128.218798-1-idosch@nvidia.com>
References: <20220302163128.218798-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0286.eurprd07.prod.outlook.com
 (2603:10a6:800:130::14) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3e93c8ca-f68e-4993-a0bc-08d9fc6a43ad
X-MS-TrafficTypeDiagnostic: MN2PR12MB3998:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB3998B6F873A89BF5E96533CFB2039@MN2PR12MB3998.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XEIFWGQ1qby818ouRFeUA5hiCEDODXcGDaxAqSYTcqOCbiZ7JE9coFINhMhQzWvMVMMFN2gIGATHJ5mC8cW7yKc+Uxx1LgAk+uV5CcEOvZbnk6WmNQO62ctR/bb9P/jqSbp6dUQsqNNdL/bFN+DMrBJ2r6YTpbp0uhS+FsjV7rT9shgijIgVSiYbgALEoDlKdpGEXDQwUBhHdxRc07+X0/q25fihIqU5n5Uc+GSFf71eelW8Ukner25lsis5xL7EdAYUA9KGCjTVf/qTV30UbpnAszufmhN5xrV/OlaFrhS2HFy7YJpcVX2/PgWZ9Be2al634mAXK4qHL6qc1ZLoeUGMsGcrOI73JB7BZQFSTNP9stOt6aen4oUeil8HuK0w+tktSBgkCX4eeI6OYQJfKV6TVgXrgSSsbU6RE78yV2zKEPFmWRvfqFsJK8knGhYJSP+Yz8pShMj6JdjBiyDIdMwvP8ID809I+Ykzq5HupGdhjoksMXnCI7WjdVZH+1GMJl536e7V0tIHtcXUCMgiXMGzg1qow4r0Xftv9BRi9rOGEN4z05CEg9WUbrNGF9lLnkZqQKLOXQbSD1C44tDhJ+5p4dDPz3inbPMzXxldeKaU2MX23oaeStBqrJERrx6uetqyqELLn0K7x4QjtFbjEA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(86362001)(66574015)(2616005)(316002)(6916009)(6506007)(6666004)(26005)(1076003)(186003)(6512007)(107886003)(83380400001)(38100700002)(8676002)(66556008)(4326008)(66476007)(2906002)(508600001)(66946007)(6486002)(5660300002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?moLfRKAD24aOXkRwBNVbJ+WsEqIhwccu/4OKNs9Ei8Z0GC3HN9wtl6GGHDDr?=
 =?us-ascii?Q?IDKXev6mksxjbXBB5ZZy+d5LXUsN0HjJq34jAU5pp4f9E7e5e1R6N35V2lYN?=
 =?us-ascii?Q?QEqSwBu/VwP35+7oVMCl3mTUI/wVksi30pL6nbYLkk8l8dfVc9d/V4Ma4bWG?=
 =?us-ascii?Q?x4PIaMp9/ywySe8PHjYdXZGFKOuzfxT/W0nK6+WQ/d4ELmdL08yzHJIA3nS/?=
 =?us-ascii?Q?Y9DQpqA5XL+MayaRc8TEXjiCDzOD60cVcGm89qo6uifFw+gyNFau16JGVo2Y?=
 =?us-ascii?Q?kse2YKEoh66DIpUiGBy5adjEn2PzPD53Krn+VCw+TtOFeC5XXGmgjQNnnnMV?=
 =?us-ascii?Q?OAIKmOICLr+ijT+w6kWbn+qNz2MPlEk5sRi3CpB+ihW/c3SJLaQVo8nDUvNw?=
 =?us-ascii?Q?cKDjB4E2QCZ8J1IX2iwMPRsH9ndQOP5UrAYboyZiiP4nrTA11G0USJxYjsDY?=
 =?us-ascii?Q?l1CONSCWRGt3lrjCPdBOH/KjXkbPGQwOpi5UOPZNtSgeFFtOabeaOCls21OV?=
 =?us-ascii?Q?xMLhzyII34CpX3/E5nQMbe39zt/Ni0GK8JmXb8Usimhhl+Pwnxa+X0KH2+T8?=
 =?us-ascii?Q?V0OS6TteynxEXvr4j9E1qe7x/DTHA+OItPYjPQ3/H6ai09k3fDAqim0U1LrX?=
 =?us-ascii?Q?SP9rKduV9b/fVJwy0rBGgkQHUvuH7hKCmIK79Pu+IiMf+d7D0XEToVVMAo8T?=
 =?us-ascii?Q?WThGy5/oBvaKOkxFT9iGq+yGJvuwz6mZFrpwdHnZ9T/rp9UwVz/KDn99iHjO?=
 =?us-ascii?Q?tAYKVvjH17jQOO5QB394QC8VS/gw5Qe7H2qHYYXnjIguF0+P3jvYD5gn9s7r?=
 =?us-ascii?Q?DoTK5FSNaZtdG9+WoHmVGie18DKm64FxSWSDLAlvM4SF97DoFGh6kssL2+NV?=
 =?us-ascii?Q?CcUuuplf53tzriE392tx/KHzt228bT7kXsaxJ3GFqBcd/y30CpvsWKc2/Zrh?=
 =?us-ascii?Q?4RbBjepHtlxPZA8OXPw0hog1Cut/clZ3l38jJAH6f5riUYKxGa5HKAbwQurX?=
 =?us-ascii?Q?4Dy9lQ0KWN2WnAnMy0CXRsr7Hvd2cyyS0hQRIYGqAaeEkge9a7m9u195Tvi3?=
 =?us-ascii?Q?QHRNGRXEVVRwMfeX0E1EurK7aheRvwK0orVJBOcPi1P9r7bniPRjC62cnXzf?=
 =?us-ascii?Q?iJELiK5qG5ELNLTQvBtb3VTsdoQAyPeFSkvrhajqIm67rk64BDrtnFpwfyBE?=
 =?us-ascii?Q?VPJL1+IoOw99oVYJlP+JJv/LVgzeCbigVY4G3qg5l4Q4rAOmFtQAWm66Dezp?=
 =?us-ascii?Q?VEcBLf/NMtXpZJdBTZ3fjDwC4wf1dxkz/+S1A8XyP07cILOHFIGknUE21NoQ?=
 =?us-ascii?Q?Tz9RBSHzZPYEUhBGPDE58HpsUyHP79pCBI5vGF4uSYupVddAAeYbZ6a6YJwf?=
 =?us-ascii?Q?O3TZUzQYEFnYONZ0q3Z2wM0KAXhY4JrQZXRIUsZ4ge3dvlEY2R0JARwRQk51?=
 =?us-ascii?Q?OMdom8vWj32ome2zKGKNXrY0HG3lzcQpylghatwhsctcVrqgc75+Zy8Jo8ZX?=
 =?us-ascii?Q?ZP7xL1lrAtE7F15oqRcXoU/UCFla+aB5+ThY31L6tKFr6PAK2qrqSXW1MYxQ?=
 =?us-ascii?Q?AR5+VvEJAuDhmJhPxDdWWfAPwAU6+FPgyrmoFm/HWEDDmCfKpYvBF7GZUMjR?=
 =?us-ascii?Q?8IPTULbH9fep+xHvOEg69dk=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e93c8ca-f68e-4993-a0bc-08d9fc6a43ad
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2022 16:32:38.3227
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IGxCFMF4Xxa+3wZYJ8+VEQb24bvUWx8ABpxnEWZfAciD+kaYFtj2EtQtpmiXCySxKTeumLCBKBNZwrk2ryzsTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3998
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

Add a new IFLA_STATS_LINK_OFFLOAD_XSTATS child attribute,
IFLA_OFFLOAD_XSTATS_L3_STATS, to carry statistics for traffic that takes
place in a HW router.

The offloaded HW stats are designed to allow per-netdevice enablement and
disablement. Additionally, as a netdevice is configured, it may become or
cease being suitable for binding of a HW counter. Both of these aspects
need to be communicated to the userspace. To that end, add another child
attribute, IFLA_OFFLOAD_XSTATS_HW_S_INFO:

    - attr nest IFLA_OFFLOAD_XSTATS_HW_S_INFO
	- attr nest IFLA_OFFLOAD_XSTATS_L3_STATS
 	    - attr IFLA_OFFLOAD_XSTATS_HW_S_INFO_REQUEST
	      - {0,1} as u8
 	    - attr IFLA_OFFLOAD_XSTATS_HW_S_INFO_USED
	      - {0,1} as u8

Thus this one attribute is a nest that can be used to carry information
about various types of HW statistics, and indexing is very simply done by
wrapping the information for a given statistics suite into the attribute
that carries the suite is the RTM_GETSTATS query. At the same time, because
_HW_S_INFO is nested directly below IFLA_STATS_LINK_OFFLOAD_XSTATS, it is
possible through filtering to request only the metadata about individual
statistics suites, without having to hit the HW to get the actual counters.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 include/uapi/linux/if_link.h |  11 +++
 net/core/rtnetlink.c         | 170 +++++++++++++++++++++++++++++++++++
 2 files changed, 181 insertions(+)

diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index ef6a62a2e15d..b1031f481d2f 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -1249,10 +1249,21 @@ enum {
 enum {
 	IFLA_OFFLOAD_XSTATS_UNSPEC,
 	IFLA_OFFLOAD_XSTATS_CPU_HIT, /* struct rtnl_link_stats64 */
+	IFLA_OFFLOAD_XSTATS_HW_S_INFO,	/* HW stats info. A nest */
+	IFLA_OFFLOAD_XSTATS_L3_STATS,	/* struct rtnl_hw_stats64 */
 	__IFLA_OFFLOAD_XSTATS_MAX
 };
 #define IFLA_OFFLOAD_XSTATS_MAX (__IFLA_OFFLOAD_XSTATS_MAX - 1)
 
+enum {
+	IFLA_OFFLOAD_XSTATS_HW_S_INFO_UNSPEC,
+	IFLA_OFFLOAD_XSTATS_HW_S_INFO_REQUEST,		/* u8 */
+	IFLA_OFFLOAD_XSTATS_HW_S_INFO_USED,		/* u8 */
+	__IFLA_OFFLOAD_XSTATS_HW_S_INFO_MAX,
+};
+#define IFLA_OFFLOAD_XSTATS_HW_S_INFO_MAX \
+	(__IFLA_OFFLOAD_XSTATS_HW_S_INFO_MAX - 1)
+
 /* XDP section */
 
 #define XDP_FLAGS_UPDATE_IF_NOEXIST	(1U << 0)
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 4db1d6c01a7d..9ce894a9454c 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -5091,10 +5091,110 @@ rtnl_offload_xstats_fill_ndo(struct net_device *dev, int attr_id,
 	return 0;
 }
 
+static unsigned int
+rtnl_offload_xstats_get_size_stats(const struct net_device *dev,
+				   enum netdev_offload_xstats_type type)
+{
+	bool enabled = netdev_offload_xstats_enabled(dev, type);
+
+	return enabled ? sizeof(struct rtnl_hw_stats64) : 0;
+}
+
+struct rtnl_offload_xstats_request_used {
+	bool request;
+	bool used;
+};
+
+static int
+rtnl_offload_xstats_get_stats(struct net_device *dev,
+			      enum netdev_offload_xstats_type type,
+			      struct rtnl_offload_xstats_request_used *ru,
+			      struct rtnl_hw_stats64 *stats,
+			      struct netlink_ext_ack *extack)
+{
+	bool request;
+	bool used;
+	int err;
+
+	request = netdev_offload_xstats_enabled(dev, type);
+	if (!request) {
+		used = false;
+		goto out;
+	}
+
+	err = netdev_offload_xstats_get(dev, type, stats, &used, extack);
+	if (err)
+		return err;
+
+out:
+	if (ru) {
+		ru->request = request;
+		ru->used = used;
+	}
+	return 0;
+}
+
+static int
+rtnl_offload_xstats_fill_hw_s_info_one(struct sk_buff *skb, int attr_id,
+				       struct rtnl_offload_xstats_request_used *ru)
+{
+	struct nlattr *nest;
+
+	nest = nla_nest_start(skb, attr_id);
+	if (!nest)
+		return -EMSGSIZE;
+
+	if (nla_put_u8(skb, IFLA_OFFLOAD_XSTATS_HW_S_INFO_REQUEST, ru->request))
+		goto nla_put_failure;
+
+	if (nla_put_u8(skb, IFLA_OFFLOAD_XSTATS_HW_S_INFO_USED, ru->used))
+		goto nla_put_failure;
+
+	nla_nest_end(skb, nest);
+	return 0;
+
+nla_put_failure:
+	nla_nest_cancel(skb, nest);
+	return -EMSGSIZE;
+}
+
+static int
+rtnl_offload_xstats_fill_hw_s_info(struct sk_buff *skb, struct net_device *dev,
+				   struct netlink_ext_ack *extack)
+{
+	enum netdev_offload_xstats_type t_l3 = NETDEV_OFFLOAD_XSTATS_TYPE_L3;
+	struct rtnl_offload_xstats_request_used ru_l3;
+	struct nlattr *nest;
+	int err;
+
+	err = rtnl_offload_xstats_get_stats(dev, t_l3, &ru_l3, NULL, extack);
+	if (err)
+		return err;
+
+	nest = nla_nest_start(skb, IFLA_OFFLOAD_XSTATS_HW_S_INFO);
+	if (!nest)
+		return -EMSGSIZE;
+
+	if (rtnl_offload_xstats_fill_hw_s_info_one(skb,
+						   IFLA_OFFLOAD_XSTATS_L3_STATS,
+						   &ru_l3))
+		goto nla_put_failure;
+
+	nla_nest_end(skb, nest);
+	return 0;
+
+nla_put_failure:
+	nla_nest_cancel(skb, nest);
+	return -EMSGSIZE;
+}
+
 static int rtnl_offload_xstats_fill(struct sk_buff *skb, struct net_device *dev,
 				    int *prividx, u32 off_filter_mask,
 				    struct netlink_ext_ack *extack)
 {
+	enum netdev_offload_xstats_type t_l3 = NETDEV_OFFLOAD_XSTATS_TYPE_L3;
+	int attr_id_hw_s_info = IFLA_OFFLOAD_XSTATS_HW_S_INFO;
+	int attr_id_l3_stats = IFLA_OFFLOAD_XSTATS_L3_STATS;
 	int attr_id_cpu_hit = IFLA_OFFLOAD_XSTATS_CPU_HIT;
 	bool have_data = false;
 	int err;
@@ -5111,6 +5211,40 @@ static int rtnl_offload_xstats_fill(struct sk_buff *skb, struct net_device *dev,
 		}
 	}
 
+	if (*prividx <= attr_id_hw_s_info &&
+	    (off_filter_mask & IFLA_STATS_FILTER_BIT(attr_id_hw_s_info))) {
+		*prividx = attr_id_hw_s_info;
+
+		err = rtnl_offload_xstats_fill_hw_s_info(skb, dev, extack);
+		if (err)
+			return err;
+
+		have_data = true;
+		*prividx = 0;
+	}
+
+	if (*prividx <= attr_id_l3_stats &&
+	    (off_filter_mask & IFLA_STATS_FILTER_BIT(attr_id_l3_stats))) {
+		unsigned int size_l3;
+		struct nlattr *attr;
+
+		*prividx = attr_id_l3_stats;
+
+		size_l3 = rtnl_offload_xstats_get_size_stats(dev, t_l3);
+		attr = nla_reserve_64bit(skb, attr_id_l3_stats, size_l3,
+					 IFLA_OFFLOAD_XSTATS_UNSPEC);
+		if (!attr)
+			return -EMSGSIZE;
+
+		err = rtnl_offload_xstats_get_stats(dev, t_l3, NULL,
+						    nla_data(attr), extack);
+		if (err)
+			return err;
+
+		have_data = true;
+		*prividx = 0;
+	}
+
 	if (!have_data)
 		return -ENODATA;
 
@@ -5118,9 +5252,35 @@ static int rtnl_offload_xstats_fill(struct sk_buff *skb, struct net_device *dev,
 	return 0;
 }
 
+static unsigned int
+rtnl_offload_xstats_get_size_hw_s_info_one(const struct net_device *dev,
+					   enum netdev_offload_xstats_type type)
+{
+	bool enabled = netdev_offload_xstats_enabled(dev, type);
+
+	return nla_total_size(0) +
+		/* IFLA_OFFLOAD_XSTATS_HW_S_INFO_REQUEST */
+		nla_total_size(sizeof(u8)) +
+		/* IFLA_OFFLOAD_XSTATS_HW_S_INFO_USED */
+		(enabled ? nla_total_size(sizeof(u8)) : 0) +
+		0;
+}
+
+static unsigned int
+rtnl_offload_xstats_get_size_hw_s_info(const struct net_device *dev)
+{
+	enum netdev_offload_xstats_type t_l3 = NETDEV_OFFLOAD_XSTATS_TYPE_L3;
+
+	return nla_total_size(0) +
+		/* IFLA_OFFLOAD_XSTATS_L3_STATS */
+		rtnl_offload_xstats_get_size_hw_s_info_one(dev, t_l3) +
+		0;
+}
+
 static int rtnl_offload_xstats_get_size(const struct net_device *dev,
 					u32 off_filter_mask)
 {
+	enum netdev_offload_xstats_type t_l3 = NETDEV_OFFLOAD_XSTATS_TYPE_L3;
 	int attr_id_cpu_hit = IFLA_OFFLOAD_XSTATS_CPU_HIT;
 	int nla_size = 0;
 	int size;
@@ -5131,6 +5291,16 @@ static int rtnl_offload_xstats_get_size(const struct net_device *dev,
 		nla_size += nla_total_size_64bit(size);
 	}
 
+	if (off_filter_mask &
+	    IFLA_STATS_FILTER_BIT(IFLA_OFFLOAD_XSTATS_HW_S_INFO))
+		nla_size += rtnl_offload_xstats_get_size_hw_s_info(dev);
+
+	if (off_filter_mask &
+	    IFLA_STATS_FILTER_BIT(IFLA_OFFLOAD_XSTATS_L3_STATS)) {
+		size = rtnl_offload_xstats_get_size_stats(dev, t_l3);
+		nla_size += nla_total_size_64bit(size);
+	}
+
 	if (nla_size != 0)
 		nla_size += nla_total_size(0);
 
-- 
2.33.1

