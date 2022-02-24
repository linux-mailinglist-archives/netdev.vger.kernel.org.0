Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77AF24C2D37
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 14:35:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234879AbiBXNev (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 08:34:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231572AbiBXNet (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 08:34:49 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2058.outbound.protection.outlook.com [40.107.236.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C32CB16DAF7
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 05:34:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cC1qR4x9K+dL17Z4EFPUGzu44Jrpjan5wkxzHO8VAKdBcG2kHCSdRyBmc1w+KfY/cyCeulVfYXopFTZglr+AmPWp9wUSlkWt7wlvsXKdoL+Jua7iGz63IHeJAc+ohqrRUXOsTQ0ZwPgdkZ/LRi/ZW8DtNmW4wcvi1R0tcQCI49eMalDwuJRH8zG5XnRddxqU5tnb8M1p52POatr4Q7268tR01n4GwxFirmqynu86ppxXpU/AMoz9GVU5MtVLYBDXPsyvmu2585i5DbdMf1Gv7fZxRKB/d0dp6/v3ANcN7WJXWW/opfTLC19UYJCE5KiCbTOJ8ACanQPaXQ2GxBwRnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UhadTxx6jgxi35kiOUW+9ToKCcCtHuvp2QJb99wOPws=;
 b=dLxBgjG6+Z6Jr1iHia2Mt8AgHU+SjUXfPoGgQhYBYKTDKocngW+Y5kH9YTaWR2NeQLU7h/B0+9Dkagq5ZDHXI3LeaqTiw695gt1TwSrDgxnsJ4TXHDak3kxqfjj8hD8dBJsVD9N4GGTetXUr6jzWOkeINyflw9fmBjGwOr/IUKbhSjgHQpuhMi+fRNdbT33PTy1ggcthS5SXIYygO+ZHElKDEY9SeXMNo21zHzA3A7wNuB4VqIDurzbGPsHeXmXOprXCQHZ5BTPaoKVw1NObEd05UQT2EoSU3Ys039u52pp/iJXceOucVJ5dFdpRizvXLUDCetVaFPaJNJTseTCDlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UhadTxx6jgxi35kiOUW+9ToKCcCtHuvp2QJb99wOPws=;
 b=tmJIas2dt0pg8Sn0yQ7AKknzcUgTtD62KNpiGZMpNarMUnKl/AVGnGeKzi4Xchl4jicrhPCHSlTN+MAomefCuzRyL/LK0zfOkwLo5jvnwVChHaD6q7NQ8C6f9Fz5b44P7fwhuaSDLcEVVpuaUMLtFYMt/Sw3zXQfIDdHuHvr+045uHDa1FWzNFuWKUPuiTyz4K2g6YGRnEBGVbdzxUyLtAlsbRut13ZNAKsZ9GJQ9rnfGApRJgmlO8Hfo7PUOi34SexmaLuchMGzdrxVZOMQCn3Fd4VWxbXJ2fqHEA5WbxiH6yEyDAS1MS9vEm0dZ1Jftn9skR4NLB0DXHNI0Jn9CA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by DM8PR12MB5416.namprd12.prod.outlook.com (2603:10b6:8:28::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Thu, 24 Feb
 2022 13:34:17 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581%7]) with mapi id 15.20.5017.025; Thu, 24 Feb 2022
 13:34:17 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        jiri@nvidia.com, razor@blackwall.org, roopa@nvidia.com,
        dsahern@gmail.com, andrew@lunn.ch, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 03/14] net: rtnetlink: RTM_GETSTATS: Allow filtering inside nests
Date:   Thu, 24 Feb 2022 15:33:24 +0200
Message-Id: <20220224133335.599529-4-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220224133335.599529-1-idosch@nvidia.com>
References: <20220224133335.599529-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P189CA0017.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:802:2a::30) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ed188090-5271-4399-9465-08d9f79a5aff
X-MS-TrafficTypeDiagnostic: DM8PR12MB5416:EE_
X-Microsoft-Antispam-PRVS: <DM8PR12MB541615157040C03EC5291108B23D9@DM8PR12MB5416.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W+5EC2CLq6pMnRRO/LWIoP7ZIJAT//pJubCCPiUdm1hxNacIiPMwpPBLTuRGuRf4H19R7uQ2cWJv8qW3e7amQcPY9kvcQNvXezk52Q5B4yq2o4V25UFhbeLBpvGzf5Tm2FQr6OO6fImQ4aSlQBcvKa7YRvUVifMi9YdezTF6AS9akASSDM8yQLffU3vMcPpyh/SyOn5qReOFym78Uig1SMizRBqOA/ZB9NnFoxJCIuq+4ORPYEJ735zqm4YCFcRr2MbKIUClfi1J0waAAvvdBRY+OAyz6/I+IwzioHcj/7fv/SasZIs9CADiP3YR4+C5QGiQP8tDlVzL6tVmLBVsEPAM1+wg3zBsuLL1t05LYRZKmayQ0hSUjhkpPyabuAncHW7FeObdOsUHVHMbkGRTsU0GzMxMhXkIG86kt3S85eKWL613O3JPWL3TuTlhH21X+wuv80oqs1rHb5Mm7H8zN/D7uypo1T2/D22iFsHDLUCYF37PW1Z+XrrXtqI3uRIXMMox/OKurWRrH7BXj4wP/CsFqiVtD2VSHzrmEJTGj8Ghm1BjRHj0DvPF+zxK5e0uIrLgzWLLv2U0IS9G2tP3eBno4EYNb6CNg2eGJAfpfevrc0dUBVzwPI2dh76eLuwZ9tDrcZAuCdMf4+aU54WwUo8+cl0eB5HypCCMyxrNfFik/4jdavLB0F77n1FSRxGp/jA7JUxAOImeOuk/xn5COQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(6512007)(1076003)(107886003)(186003)(26005)(5660300002)(2616005)(2906002)(36756003)(30864003)(8936002)(6486002)(38100700002)(508600001)(316002)(6506007)(6666004)(66946007)(66476007)(8676002)(86362001)(66556008)(6916009)(4326008)(21314003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZYn9zTN2GrWyBZ5w/y9IVgGrClHEae/3yaCM/EMN84ncRukitWDFA59yg30j?=
 =?us-ascii?Q?2EL203fxAxBxyZSUG3KWtd6gDjA0D0wHOYBVyNeXERKo3PtYoxg7CobXcFAr?=
 =?us-ascii?Q?K1ZpGqIQclMgMb2syPAwz4NK9WBjpBP+1kZuwbHdHRcpW/IMFwSFXqT2RTYK?=
 =?us-ascii?Q?UZmwKIX9zubMnoP+5NQQInxW11scyL25DpZ5+XYKZy/Gq24LaYD3pn9HUrYt?=
 =?us-ascii?Q?v2xsomfMABNbNKfXDRhb4uowrw0RbPsjpli4fmBbKDbO6jLpoFkGs78TFS9I?=
 =?us-ascii?Q?SvMQBAiv3ef/TnRgoxeck0CFJ6o7lblkW8WYwh7FxeXKUxIS/zCR5fRP1dAM?=
 =?us-ascii?Q?usdoNxImyaPLNM/zm5g37XZdBr7uHFn1GSiwOj7Qh1uLTvlPm817QpZTSRtv?=
 =?us-ascii?Q?GtZ3Ga5BMK7WSmQI5x2bpxUeggz6j/YOsNZq20AdaUkX0t8RHMEOnGCEYAAp?=
 =?us-ascii?Q?VoMxD6XmPRG8v4aGxLPRJei8CDrznltn0COMXo6oyJwQWSgARdqFzniQmGkg?=
 =?us-ascii?Q?jFEUkPJ+f4XGAiQNfJwz7QYWCb5GElBHjFhnxfBqqJp45B6u4xhZDjPKpy/+?=
 =?us-ascii?Q?Ci6e0Kvk5POxDl+Q71HxCaT/cwajAYL5hoQdv+AUkFfsFncyV8IQjt6uVnxy?=
 =?us-ascii?Q?E7HEwSwaNZ8QAH55cgchj9UMnzUQV/TQ3fzf/9SdkCi4LrMKkdDWgTYnrKfB?=
 =?us-ascii?Q?ecS3iJBmhO1PHUqEn+vYqWt3+iVDqZwsSvtGr8GP6BOcQgEme10Sa78mmYon?=
 =?us-ascii?Q?OB3c1LWZJMGxXPedvPqR7nS5jWleGEKP4A2Ehs/i1jjl1newfJSdQFuUebf+?=
 =?us-ascii?Q?yalBhOo6EhDOBqWgJMteWN7klziNIAHRSwqnwtq+Db9Es+It3ss2nan+t/vF?=
 =?us-ascii?Q?dnSF2nRpyD6xvp38mh3LNkvPlWQGeGDFUI9ojgZKF/F5cHQQp3IB/4dViIDV?=
 =?us-ascii?Q?tQq1i5LOkFGCeQgHbGF+H8ZGP8ZzgXPkFGDQVpX+LrNnCT9braNbccK4ezPc?=
 =?us-ascii?Q?spldieac3M23eGYGLL4TZjDDv+HsILHxX2Z+Bm/b/yn4e7EPn1XoPpUbQsCA?=
 =?us-ascii?Q?QU9OCrp6Hz/Ls9ElHAmB3ORxOoQjr+lA7s8xrHCN65XAgxfsMH+/S7vA2ut7?=
 =?us-ascii?Q?vtCmI0KHwjwA55PR/akdxGfpXqvLqQy4iWUHb1IriZESPlU1IuzBFRfa3VSs?=
 =?us-ascii?Q?pA+T5CKvWO5KMtLFU901LIgKKEfIMpRokriFG2p3ImoHvlMyiTmItbLjnQmm?=
 =?us-ascii?Q?4XH/XjeaIejOEJ/Y5/VCkITlI+FtV4GTjPSmPgiZgxtDPJSuRRnkIIDMv2eq?=
 =?us-ascii?Q?UNtoX6pRRrLYvhVVP8ZWfg4ysLJo0sjq8wVgfxqUSs+VqiSnauzEZEIRVZAT?=
 =?us-ascii?Q?3oRMFHal6sOysbFeSB2y3/2oh+lU0K2e5iaCu2Zb3xBbXV8+sQWUZDrr5r0e?=
 =?us-ascii?Q?luiqy+wYLzU3XGAJHaoBAOQ9UoSi3Fc5ZPvDg+YvIqvc+GmqShiUm+TnL+C2?=
 =?us-ascii?Q?hBcp5zs/M4YlLhcLlQh4LkFGpz11KKTtnU+xMIiImckacxg4B3enB5HP3AJW?=
 =?us-ascii?Q?jIzxR7IyfXLOrlOTMKkIClm9kwF9UtulAvdpUDN8fz+ReA9JbAQLfb3bLPBz?=
 =?us-ascii?Q?lBroQdE68rqLoiJHEHuQRvo=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed188090-5271-4399-9465-08d9f79a5aff
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 13:34:17.5233
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +t9HFbotus3oc1uczTn14VbFuBh8KA1vrW+c8DJ62PIOhQw0B5YCI7vB4Fq7xgqOtYPE6hni/Zay8lBQAkDEiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5416
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
		- struct nla_bitfield32 filter_mask

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
 include/uapi/linux/if_link.h |  11 +++
 net/core/rtnetlink.c         | 142 +++++++++++++++++++++++++++++------
 2 files changed, 130 insertions(+), 23 deletions(-)

diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index be09d2ad4b5d..f5d88a7b1c36 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -1158,6 +1158,17 @@ enum {
 
 #define IFLA_STATS_FILTER_BIT(ATTR)	(1 << (ATTR - 1))
 
+enum {
+	IFLA_STATS_GETSET_UNSPEC,
+	IFLA_STATS_GET_FILTERS, /* Nest of IFLA_STATS_LINK_xxx, each a
+				 * bitfield32 with a filter mask for the
+				 * corresponding stat group.
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
index ad858799fd93..a5e2d228df02 100644
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
@@ -5344,6 +5368,75 @@ static size_t if_nlmsg_stats_size(const struct net_device *dev,
 	return size;
 }
 
+static const struct nla_policy
+rtnl_stats_get_policy[IFLA_STATS_GETSET_MAX + 1] = {
+	[IFLA_STATS_GETSET_UNSPEC] = { .strict_start_type = 1 },
+	[IFLA_STATS_GET_FILTERS] = { .type = NLA_NESTED },
+};
+
+#define RTNL_STATS_OFFLOAD_XSTATS_VALID ((1 << __IFLA_OFFLOAD_XSTATS_MAX) - 1)
+
+static const struct nla_policy
+rtnl_stats_get_policy_filters[IFLA_STATS_MAX + 1] = {
+	[IFLA_STATS_UNSPEC] = { .strict_start_type = 1 },
+	[IFLA_STATS_LINK_OFFLOAD_XSTATS] =
+			NLA_POLICY_BITFIELD32(RTNL_STATS_OFFLOAD_XSTATS_VALID),
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
+			filters->mask[at] = nla_get_bitfield32(tb[at]).value;
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
@@ -5366,10 +5459,6 @@ static int rtnl_valid_stats_req(const struct nlmsghdr *nlh, bool strict_check,
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
@@ -5381,12 +5470,12 @@ static int rtnl_valid_stats_req(const struct nlmsghdr *nlh, bool strict_check,
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
@@ -5403,19 +5492,22 @@ static int rtnl_stats_get(struct sk_buff *skb, struct nlmsghdr *nlh,
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
@@ -5431,12 +5523,12 @@ static int rtnl_stats_dump(struct sk_buff *skb, struct netlink_callback *cb)
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
@@ -5451,12 +5543,16 @@ static int rtnl_stats_dump(struct sk_buff *skb, struct netlink_callback *cb)
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
@@ -5466,7 +5562,7 @@ static int rtnl_stats_dump(struct sk_buff *skb, struct netlink_callback *cb)
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

