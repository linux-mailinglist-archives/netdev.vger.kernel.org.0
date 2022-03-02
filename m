Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE18F4CAA41
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 17:32:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242205AbiCBQdJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 11:33:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242353AbiCBQc5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 11:32:57 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2078.outbound.protection.outlook.com [40.107.94.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AA62CD331
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 08:32:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cmWJ03hGGLvfSPKwK0CsBYjm7PoSs5k+IM7oanmG6TL43A5SWau6KpCl31Mqx7K+oCdZyY0R3yyR+AzV6FBH0GVBZ674T6CmaAv26G8nXsEUf7fble2y7+70zsEWYTXSMprVptUAn6ftcl623PYuf1Giu9TK4JYIIGxmFrjwXc+jKAPh4NJgYZt6fvSxvPE+8CVZYQUKmkt4QBp1VKgr/PX+IWZBl5SbGoq3/KzIROLhw1cVT/+s8VvASbiCzT7GmqCbGDsFgLTDBKRXzhC5lNlxqWiX6n/XyE0bGUQJeXTva7/NEsOwf7Zy8O1kLiyqtqHEbkGgadaRgV7g0MoGUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GwrRhRVma3ZW3GvPTWuaYKBI+oAyrQkLndkcbmTOmT0=;
 b=eAbJB5rIHqsp5RNyP/oOLrtBESI5BQiyCmM0EgWdIxmY1yDCoEAcUduWZ41swIrdSiYx7Z4AnS+2D3IrtKDuxeyfJHITcqI/smbeHNEYgim+pEZ2j6N3Lx7w1McyVkFjVHVGZZbV8gpF0Iw6s5hC3MVcV8DyOoInSca+KMf02sqI3c85T17q12Mtc7cOrEO0oafX6jquPKj3xCHTdDSd26TR+ir2L4douQ5KkQ40Tdt+5UCYZg8VVef2iyWkZjgk1dBvMe9I0k58BhL1I6A1GUnWtaH0FgJPo+oT0QJRbBXbdyZV0fucMItzRfwedJ0HOld7GrdlaOeLhi8ahWZXMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GwrRhRVma3ZW3GvPTWuaYKBI+oAyrQkLndkcbmTOmT0=;
 b=i5NH4YgFjrJkGoy2fwd9ow2xQ5ky8t+X3TiRdEQkvbPiCzv44CNajCgRZ4c5vBmUeCy/+CrpXOc6aYwsBrunEo5HdLIE+SNrbJuki9K/WY+toBzy/g2yty/Z8G0NNx3a1NLVTVNRX05LXzfRP0YuUPQPnTIL7P7XWcdXhM7HbpNLQbN2wx9KzGISaO3dmALHi56+OiotC31zUHPwzh4ikhnuc6qCq+UubAxqq8R4gwatnLWRLiZviRFwxSzPdDCfAMvfzGR4bNdhXZlt2Gv3+oQUvZ5loF663Q/csCuI8Zd6z0MnvacBkHJxkwCjHP+1Q5iqnuESRh7oJq6J5WwOYQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by CY4PR12MB1942.namprd12.prod.outlook.com (2603:10b6:903:128::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21; Wed, 2 Mar
 2022 16:32:11 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581%6]) with mapi id 15.20.5038.014; Wed, 2 Mar 2022
 16:32:11 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        jiri@nvidia.com, roopa@nvidia.com, razor@blackwall.org,
        dsahern@gmail.com, andrew@lunn.ch, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 03/14] net: rtnetlink: RTM_GETSTATS: Allow filtering inside nests
Date:   Wed,  2 Mar 2022 18:31:17 +0200
Message-Id: <20220302163128.218798-4-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220302163128.218798-1-idosch@nvidia.com>
References: <20220302163128.218798-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0142.eurprd08.prod.outlook.com
 (2603:10a6:800:d5::20) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2516ecf6-c44c-457f-97cb-08d9fc6a336b
X-MS-TrafficTypeDiagnostic: CY4PR12MB1942:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB194277FA4574D8AA4FCFE943B2039@CY4PR12MB1942.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RlNSURkRojD40f99ZK2Q61uR7hebaW6MpYh+LDxMq/LC+ErfSbgmVW7UA5l/0LwVQgiFkzwFRjTFB7di1J1rvYRXpD9j4biV63w3dssH5WhFVejL6ng3XuE1kDO6ZdDYqeWN28YMtMNYsvWNHKisxBn60xoj0iRm0tX4wE5otwXlzLic694cMFmuAQ+9JAioEkwe8uUGyusJGgBaAAXRhkjB/GAyCMfdv3N2BTXj39S7C7zLfa/l91Eyiwifc2+SS8O+weI/beV68Sy6vR2DBnBSlVZAgrKKSVaTBp1snVvMLwr0ATGfVuzJy4lpKE+ySdZ0lIvaF6dBpmOXyGGauOIpyqyg0OKvJak1Vz5LNi7crztLh5eKmPf5mb88DYVyloTOO5hdnrT9d8c8xHeX+tRwlm+Zc2kz1PCJ8Obn7qhoXxxBZl/IebQKDKC5RNdzIrx0D1KMK1Ke1xBhC1JTGCVLxG5PMPiJAiux+fVxWAVUdeZIMfgjTR/gbKiGRcLtY7TvO2j0ZswWQCzIfvCmo+66BnbBC+W8QIBXL7jamZztw0oontqmXCJ8TkZ8YOLhiMqvZwlRDeXMkavIm3m3qv88vOXR2V+zivjRU21iGCpCyuaYdoeQu1n93kZnE1mVrEbQPT8QswiDDmdbq32rnNYQZ7TGgD8iDCb9Ya6zBKpNKG1BDpWIWP79XRpJrJQLVSreVleYvW4fFU3MZnMpZQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(36756003)(2616005)(86362001)(26005)(186003)(1076003)(6916009)(316002)(107886003)(4326008)(66476007)(6506007)(66946007)(6512007)(66556008)(8676002)(6486002)(508600001)(2906002)(83380400001)(30864003)(8936002)(5660300002)(21314003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0QVMsRpZEiGsXbWLxI0KwYo57aHe69gy5LjawqN3EpPkxswjoN+80vcXN/cd?=
 =?us-ascii?Q?JIixoVn1dzOQ2jdYYz6Cq3prtVS//ClOsD3r0wVA1TRm/5CqgdbHeeLgejlg?=
 =?us-ascii?Q?fD93Ej0hGSg8ej5wodF05bbHmz+iVEm9iCA2G60vEm/1QlllAnU59+HCmy9B?=
 =?us-ascii?Q?U2gaqZbqMNMZCpJ7giR9IjhPFNZ+nRkgKGZlMy9OIeBxKhuDhssWLve7h37b?=
 =?us-ascii?Q?wGcmuynQNnmtayRW4oVhmOfgyk189W5RIbPzANA0wicuFGzDoAeCfkrol4AZ?=
 =?us-ascii?Q?/UT2SQyKNTzMg6nyMaGox8vECDb7+pYpSV7fTf6eaSCMlYhEj25PJp2uSjLy?=
 =?us-ascii?Q?b2Rfbso34BMShYroGPlWht3lCvA1+Pvuh9wjEa1JiguitJZnLCSmEEN7d2RR?=
 =?us-ascii?Q?fLhtDXP/R+x50E4a/ggs3/daVQtW6GE6XqtcgrTkMHxugyrcLeX2fcJ2Kosu?=
 =?us-ascii?Q?ly0F0Cm3maGoFo/1oEwZSRGIhqm9JYZ2N8wbnxcYsILnvy3UVk1v5wuyorvM?=
 =?us-ascii?Q?FfyBIJhlwm/LWFzpwmUK0T+oLtEzlOTTb1mbGCB3Hzp7ePJd6jENH/Rjhj4g?=
 =?us-ascii?Q?gj1OUoQYZyfNQbifmrnTPvrVx7C0XW/V8j9uI/+gqquZhH2dqGVeGjvs11Kl?=
 =?us-ascii?Q?1f1MOn1kKHnPyThI4jziTfe6fmAWwMsKeJt09aj13znGDRxbbrdkXnCgfLcn?=
 =?us-ascii?Q?JP6h9+E/KCQ32qG4bhnUFjWmdKjkv5aHlLSZd9RLtpiWP+okE1equx6q9D/Y?=
 =?us-ascii?Q?fU3uVxHNUTfYi9b9l+LmkQ1bP1nhOspltc183U+ne5WVUUcFGQMF8Cknyvqg?=
 =?us-ascii?Q?lAVKK2srHczog9pyXTPHguWdadoySm77+115HRo/pvR07Xl/kH2LA0KibB07?=
 =?us-ascii?Q?t7J/c4u/akqJLy+SuUuEA4o2I6T12IvyiMaPDmll/59hNxJBMnWOYujvqgHX?=
 =?us-ascii?Q?z9M0Mzi3TXYuGoIDIipQKItjYgwY+5/JvYtOKZNCgZ3OFavxFXzcS2YomqMi?=
 =?us-ascii?Q?R7z0Qz6N+A2zXOkseuwLI4VHIfq2nvkpY/NafPJuRg5RABbmYbC0aQK2luf8?=
 =?us-ascii?Q?IRgNz2DUnGf8p3z7zMJt5EKrIme9id+4YhwJdTnbt9UM0rzmzkW9k3abUjBP?=
 =?us-ascii?Q?q/o+aL4R/Z1PT/jCuDW7r3La8MTv2SnOpfJgNlHHGsfOGPbBSOXSKzhi7Nn/?=
 =?us-ascii?Q?dIK7EvbkYBUuuqaC5HkpIN8dxFAWmRzkyX2KjN9PMDIdgtFfKP9QGqnM78oJ?=
 =?us-ascii?Q?ECZiGQcJFMqVMatQqh/NPt5OkjFQSZugiDsSYjlznoCSw859LgJc0uVG2OIw?=
 =?us-ascii?Q?DwcmHzi0f2lMAK59cT2j2qB8Kguipgequpdx0BnJDas+hbqN+BDzsrTFQqiM?=
 =?us-ascii?Q?4aR5BlpIA7ecJfCeesqNGQKuPCFB6Gr6ddn7cF234KvJaPu4NF/sjnFFv3WN?=
 =?us-ascii?Q?aQ9T/VhI9ySnLCWgs6hvlnXWVAOZL04uAX6tA47F4ewAkNaMLoibxC8DrTQT?=
 =?us-ascii?Q?ZAsXDVIucJ17FQi0rsCMv6Tp2J74tqigi0fPsTEpYyk4yxWyaILixg2yOTWp?=
 =?us-ascii?Q?5uce/whoZr42ltN7H0qhyWHfCK1B1S+fwmn4fCKUOY+PjlYmKIyDxtSQGKyh?=
 =?us-ascii?Q?0X2svUToP0M79LSAqOvIbgE=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2516ecf6-c44c-457f-97cb-08d9fc6a336b
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2022 16:32:11.1557
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1GAEBcU6rLbpJUpu80EYE7oTD5SWx+eUDyB1lYt4jx5P9b1NH+zEgd52qmQYSNuQB/gPP/DzqJgzXAq/GyRLdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1942
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

The filter_mask field of RTM_GETSTATS header determines which top-level
attributes should be included in the netlink response. This saves
processing time by only including the bits that the user cares about
instead of always dumping everything. This is doubly important for
HW-backed statistics that would typically require a trip to the device to
fetch the stats.

So far there was only one HW-backed stat suite per attribute. However,
IFLA_STATS_LINK_OFFLOAD_XSTATS is a nest, and will gain a new stat suite in
the following patches. It would therefore be advantageous to be able to
filter within that nest, and select just one or the other HW-backed
statistics suite.

Extend rtnetlink so that RTM_GETSTATS permits attributes in the payload.
The scheme is as follows:

    - RTM_GETSTATS
	- struct if_stats_msg
	- attr nest IFLA_STATS_GET_FILTERS
	    - attr IFLA_STATS_LINK_OFFLOAD_XSTATS
		- u32 filter_mask

This scheme reuses the existing enumerators by nesting them in a dedicated
context attribute. This is covered by policies as usual, therefore a
gradual opt-in is possible. Currently only IFLA_STATS_LINK_OFFLOAD_XSTATS
nest has filtering enabled, because for the SW counters the issue does not
seem to be that important.

rtnl_offload_xstats_get_size() and _fill() are extended to observe the
requested filters.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 include/uapi/linux/if_link.h |  10 +++
 net/core/rtnetlink.c         | 141 +++++++++++++++++++++++++++++------
 2 files changed, 128 insertions(+), 23 deletions(-)

diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index e315e53125f4..4d62ea6e1288 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -1207,6 +1207,16 @@ enum {
 
 #define IFLA_STATS_FILTER_BIT(ATTR)	(1 << (ATTR - 1))
 
+enum {
+	IFLA_STATS_GETSET_UNSPEC,
+	IFLA_STATS_GET_FILTERS, /* Nest of IFLA_STATS_LINK_xxx, each a u32 with
+				 * a filter mask for the corresponding group.
+				 */
+	__IFLA_STATS_GETSET_MAX,
+};
+
+#define IFLA_STATS_GETSET_MAX (__IFLA_STATS_GETSET_MAX - 1)
+
 /* These are embedded into IFLA_STATS_LINK_XSTATS:
  * [IFLA_STATS_LINK_XSTATS]
  * -> [LINK_XSTATS_TYPE_xxx]
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index ad858799fd93..31aa26062070 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -5092,13 +5092,15 @@ rtnl_offload_xstats_fill_ndo(struct net_device *dev, int attr_id,
 }
 
 static int rtnl_offload_xstats_fill(struct sk_buff *skb, struct net_device *dev,
-				    int *prividx)
+				    int *prividx, u32 off_filter_mask)
 {
 	int attr_id_cpu_hit = IFLA_OFFLOAD_XSTATS_CPU_HIT;
 	bool have_data = false;
 	int err;
 
-	if (*prividx <= attr_id_cpu_hit) {
+	if (*prividx <= attr_id_cpu_hit &&
+	    (off_filter_mask &
+	     IFLA_STATS_FILTER_BIT(attr_id_cpu_hit))) {
 		err = rtnl_offload_xstats_fill_ndo(dev, attr_id_cpu_hit, skb);
 		if (!err) {
 			have_data = true;
@@ -5115,14 +5117,18 @@ static int rtnl_offload_xstats_fill(struct sk_buff *skb, struct net_device *dev,
 	return 0;
 }
 
-static int rtnl_offload_xstats_get_size(const struct net_device *dev)
+static int rtnl_offload_xstats_get_size(const struct net_device *dev,
+					u32 off_filter_mask)
 {
 	int attr_id_cpu_hit = IFLA_OFFLOAD_XSTATS_CPU_HIT;
 	int nla_size = 0;
 	int size;
 
-	size = rtnl_offload_xstats_get_size_ndo(dev, attr_id_cpu_hit);
-	nla_size += nla_total_size_64bit(size);
+	if (off_filter_mask &
+	    IFLA_STATS_FILTER_BIT(attr_id_cpu_hit)) {
+		size = rtnl_offload_xstats_get_size_ndo(dev, attr_id_cpu_hit);
+		nla_size += nla_total_size_64bit(size);
+	}
 
 	if (nla_size != 0)
 		nla_size += nla_total_size(0);
@@ -5130,11 +5136,20 @@ static int rtnl_offload_xstats_get_size(const struct net_device *dev)
 	return nla_size;
 }
 
+struct rtnl_stats_dump_filters {
+	/* mask[0] filters outer attributes. Then individual nests have their
+	 * filtering mask at the index of the nested attribute.
+	 */
+	u32 mask[IFLA_STATS_MAX + 1];
+};
+
 static int rtnl_fill_statsinfo(struct sk_buff *skb, struct net_device *dev,
 			       int type, u32 pid, u32 seq, u32 change,
-			       unsigned int flags, unsigned int filter_mask,
+			       unsigned int flags,
+			       const struct rtnl_stats_dump_filters *filters,
 			       int *idxattr, int *prividx)
 {
+	unsigned int filter_mask = filters->mask[0];
 	struct if_stats_msg *ifsm;
 	struct nlmsghdr *nlh;
 	struct nlattr *attr;
@@ -5210,13 +5225,17 @@ static int rtnl_fill_statsinfo(struct sk_buff *skb, struct net_device *dev,
 
 	if (stats_attr_valid(filter_mask, IFLA_STATS_LINK_OFFLOAD_XSTATS,
 			     *idxattr)) {
+		u32 off_filter_mask;
+
+		off_filter_mask = filters->mask[IFLA_STATS_LINK_OFFLOAD_XSTATS];
 		*idxattr = IFLA_STATS_LINK_OFFLOAD_XSTATS;
 		attr = nla_nest_start_noflag(skb,
 					     IFLA_STATS_LINK_OFFLOAD_XSTATS);
 		if (!attr)
 			goto nla_put_failure;
 
-		err = rtnl_offload_xstats_fill(skb, dev, prividx);
+		err = rtnl_offload_xstats_fill(skb, dev, prividx,
+					       off_filter_mask);
 		if (err == -ENODATA)
 			nla_nest_cancel(skb, attr);
 		else
@@ -5281,9 +5300,10 @@ static int rtnl_fill_statsinfo(struct sk_buff *skb, struct net_device *dev,
 }
 
 static size_t if_nlmsg_stats_size(const struct net_device *dev,
-				  u32 filter_mask)
+				  const struct rtnl_stats_dump_filters *filters)
 {
 	size_t size = NLMSG_ALIGN(sizeof(struct if_stats_msg));
+	unsigned int filter_mask = filters->mask[0];
 
 	if (stats_attr_valid(filter_mask, IFLA_STATS_LINK_64, 0))
 		size += nla_total_size_64bit(sizeof(struct rtnl_link_stats64));
@@ -5319,8 +5339,12 @@ static size_t if_nlmsg_stats_size(const struct net_device *dev,
 		}
 	}
 
-	if (stats_attr_valid(filter_mask, IFLA_STATS_LINK_OFFLOAD_XSTATS, 0))
-		size += rtnl_offload_xstats_get_size(dev);
+	if (stats_attr_valid(filter_mask, IFLA_STATS_LINK_OFFLOAD_XSTATS, 0)) {
+		u32 off_filter_mask;
+
+		off_filter_mask = filters->mask[IFLA_STATS_LINK_OFFLOAD_XSTATS];
+		size += rtnl_offload_xstats_get_size(dev, off_filter_mask);
+	}
 
 	if (stats_attr_valid(filter_mask, IFLA_STATS_AF_SPEC, 0)) {
 		struct rtnl_af_ops *af_ops;
@@ -5344,6 +5368,74 @@ static size_t if_nlmsg_stats_size(const struct net_device *dev,
 	return size;
 }
 
+#define RTNL_STATS_OFFLOAD_XSTATS_VALID ((1 << __IFLA_OFFLOAD_XSTATS_MAX) - 1)
+
+static const struct nla_policy
+rtnl_stats_get_policy_filters[IFLA_STATS_MAX + 1] = {
+	[IFLA_STATS_LINK_OFFLOAD_XSTATS] =
+		    NLA_POLICY_MASK(NLA_U32, RTNL_STATS_OFFLOAD_XSTATS_VALID),
+};
+
+static const struct nla_policy
+rtnl_stats_get_policy[IFLA_STATS_GETSET_MAX + 1] = {
+	[IFLA_STATS_GET_FILTERS] =
+		    NLA_POLICY_NESTED(rtnl_stats_get_policy_filters),
+};
+
+static int rtnl_stats_get_parse_filters(struct nlattr *ifla_filters,
+					struct rtnl_stats_dump_filters *filters,
+					struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[IFLA_STATS_MAX + 1];
+	int err;
+	int at;
+
+	err = nla_parse_nested(tb, IFLA_STATS_MAX, ifla_filters,
+			       rtnl_stats_get_policy_filters, extack);
+	if (err < 0)
+		return err;
+
+	for (at = 1; at <= IFLA_STATS_MAX; at++) {
+		if (tb[at]) {
+			if (!(filters->mask[0] & IFLA_STATS_FILTER_BIT(at))) {
+				NL_SET_ERR_MSG(extack, "Filtered attribute not enabled in filter_mask");
+				return -EINVAL;
+			}
+			filters->mask[at] = nla_get_u32(tb[at]);
+		}
+	}
+
+	return 0;
+}
+
+static int rtnl_stats_get_parse(const struct nlmsghdr *nlh,
+				u32 filter_mask,
+				struct rtnl_stats_dump_filters *filters,
+				struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[IFLA_STATS_GETSET_MAX + 1];
+	int err;
+	int i;
+
+	filters->mask[0] = filter_mask;
+	for (i = 1; i < ARRAY_SIZE(filters->mask); i++)
+		filters->mask[i] = -1U;
+
+	err = nlmsg_parse(nlh, sizeof(struct if_stats_msg), tb,
+			  IFLA_STATS_GETSET_MAX, rtnl_stats_get_policy, extack);
+	if (err < 0)
+		return err;
+
+	if (tb[IFLA_STATS_GET_FILTERS]) {
+		err = rtnl_stats_get_parse_filters(tb[IFLA_STATS_GET_FILTERS],
+						   filters, extack);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
 static int rtnl_valid_stats_req(const struct nlmsghdr *nlh, bool strict_check,
 				bool is_dump, struct netlink_ext_ack *extack)
 {
@@ -5366,10 +5458,6 @@ static int rtnl_valid_stats_req(const struct nlmsghdr *nlh, bool strict_check,
 		NL_SET_ERR_MSG(extack, "Invalid values in header for stats dump request");
 		return -EINVAL;
 	}
-	if (nlmsg_attrlen(nlh, sizeof(*ifsm))) {
-		NL_SET_ERR_MSG(extack, "Invalid attributes after stats header");
-		return -EINVAL;
-	}
 	if (ifsm->filter_mask >= IFLA_STATS_FILTER_BIT(IFLA_STATS_MAX + 1)) {
 		NL_SET_ERR_MSG(extack, "Invalid stats requested through filter mask");
 		return -EINVAL;
@@ -5381,12 +5469,12 @@ static int rtnl_valid_stats_req(const struct nlmsghdr *nlh, bool strict_check,
 static int rtnl_stats_get(struct sk_buff *skb, struct nlmsghdr *nlh,
 			  struct netlink_ext_ack *extack)
 {
+	struct rtnl_stats_dump_filters filters;
 	struct net *net = sock_net(skb->sk);
 	struct net_device *dev = NULL;
 	int idxattr = 0, prividx = 0;
 	struct if_stats_msg *ifsm;
 	struct sk_buff *nskb;
-	u32 filter_mask;
 	int err;
 
 	err = rtnl_valid_stats_req(nlh, netlink_strict_get_check(skb),
@@ -5403,19 +5491,22 @@ static int rtnl_stats_get(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (!dev)
 		return -ENODEV;
 
-	filter_mask = ifsm->filter_mask;
-	if (!filter_mask) {
+	if (!ifsm->filter_mask) {
 		NL_SET_ERR_MSG(extack, "Filter mask must be set for stats get");
 		return -EINVAL;
 	}
 
-	nskb = nlmsg_new(if_nlmsg_stats_size(dev, filter_mask), GFP_KERNEL);
+	err = rtnl_stats_get_parse(nlh, ifsm->filter_mask, &filters, extack);
+	if (err)
+		return err;
+
+	nskb = nlmsg_new(if_nlmsg_stats_size(dev, &filters), GFP_KERNEL);
 	if (!nskb)
 		return -ENOBUFS;
 
 	err = rtnl_fill_statsinfo(nskb, dev, RTM_NEWSTATS,
 				  NETLINK_CB(skb).portid, nlh->nlmsg_seq, 0,
-				  0, filter_mask, &idxattr, &prividx);
+				  0, &filters, &idxattr, &prividx);
 	if (err < 0) {
 		/* -EMSGSIZE implies BUG in if_nlmsg_stats_size */
 		WARN_ON(err == -EMSGSIZE);
@@ -5431,12 +5522,12 @@ static int rtnl_stats_dump(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	struct netlink_ext_ack *extack = cb->extack;
 	int h, s_h, err, s_idx, s_idxattr, s_prividx;
+	struct rtnl_stats_dump_filters filters;
 	struct net *net = sock_net(skb->sk);
 	unsigned int flags = NLM_F_MULTI;
 	struct if_stats_msg *ifsm;
 	struct hlist_head *head;
 	struct net_device *dev;
-	u32 filter_mask = 0;
 	int idx = 0;
 
 	s_h = cb->args[0];
@@ -5451,12 +5542,16 @@ static int rtnl_stats_dump(struct sk_buff *skb, struct netlink_callback *cb)
 		return err;
 
 	ifsm = nlmsg_data(cb->nlh);
-	filter_mask = ifsm->filter_mask;
-	if (!filter_mask) {
+	if (!ifsm->filter_mask) {
 		NL_SET_ERR_MSG(extack, "Filter mask must be set for stats dump");
 		return -EINVAL;
 	}
 
+	err = rtnl_stats_get_parse(cb->nlh, ifsm->filter_mask, &filters,
+				   extack);
+	if (err)
+		return err;
+
 	for (h = s_h; h < NETDEV_HASHENTRIES; h++, s_idx = 0) {
 		idx = 0;
 		head = &net->dev_index_head[h];
@@ -5466,7 +5561,7 @@ static int rtnl_stats_dump(struct sk_buff *skb, struct netlink_callback *cb)
 			err = rtnl_fill_statsinfo(skb, dev, RTM_NEWSTATS,
 						  NETLINK_CB(cb->skb).portid,
 						  cb->nlh->nlmsg_seq, 0,
-						  flags, filter_mask,
+						  flags, &filters,
 						  &s_idxattr, &s_prividx);
 			/* If we ran out of room on the first message,
 			 * we're in trouble
-- 
2.33.1

