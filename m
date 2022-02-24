Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A7744C2D3D
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 14:35:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235014AbiBXNe4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 08:34:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234991AbiBXNez (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 08:34:55 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2066.outbound.protection.outlook.com [40.107.236.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14F181704DE
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 05:34:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=edAVS8gEHFF/FYzBht4PYfDreu0AKfZWbzBxYnbODOq7hoxrXx4KudykKC6ok045kZw7h0GvVsp6kACi26aPVNqpCrCz86tqrLVYjH0YwT24RPBov2x7p0ueMoYTT27IjNItNN0aL/3zfyD9B01Kn9HgKzAoOWcp3H7CJy3ylRUy27l/boO+iF57w1S4uy9oNxQoW9GmkpeRjD31wAM/FX5+WIlEIvsG0WeQ8f+hLgQzt5LqosL9FwA3JrUsF71w/nRO7Oy82csfB0JjAb+SBEaodZFnaRttURaku5DSfac14CEO4r9YdKWCFZr/K7WVIa/I9/w/Yzob++JiKJaDWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YoEMhKPlYRsqzRuKrci3gheE7HZ6oprmS0kJD9zxF50=;
 b=HIPep+XZqnGby4x/sWjK/coFQ8vzHtQIdKpJGO2qBpczeX0aTMDuvWpSxh/xJuWI7hmzS5EmovcJt3GsvNO7rVS2gZ/+kzGdbEi9vJ64ZcVwd7y3u43PVLkv2l3l9VX2uVHrNSq5DPmF/DaUluGYdm2azdx0do1onLjwf19E81od6PXBxR3d+Lj6WK4q1Lg5UrEqFuuVtnN565jLgAyhKHx20sUpc8rm5iCZoyf/xgyXTA8/7Y5hPbRxH5joPV5SDnIAs+u+eV5NlKkdBknRp2SraQR52OLMgVeDvynrkOVyt8vR5gj5KJgAyx9+ZxHMVvzoTzan3hg5zSMGZRAksw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YoEMhKPlYRsqzRuKrci3gheE7HZ6oprmS0kJD9zxF50=;
 b=YD/b88jR/m5BebD/7i4H/V9CwN+rxud5OYPLbKGfh83l1gwFDr8Ju7vDtaV8rnFFjlnHSj3eZ00TKPYN5ZnrwnTNHEzah900OyuJuE4vRLopb6b68bK8TGtiDcIFLdsQwzZYNzYhxPiZY5XGBpIlGE0Rh9eDjzQAhlmSGYqK5nMREhGFFgEtrPWcT/H9mft7CE9xUGV79+2wsOTOnNXl3mQluPFO5r3h8CSAnR6AMYOubvyAd+O6KzPmJCCwEDnR5qGc5I5QEmgjNOfLR2W3+Fq7Evda18UKk15E6yU8RhPDfMpEeXcQ0iUbCf8gpoUiwwYfJFT3LnzXyJ/yfpLeHw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by DM8PR12MB5416.namprd12.prod.outlook.com (2603:10b6:8:28::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Thu, 24 Feb
 2022 13:34:24 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581%7]) with mapi id 15.20.5017.025; Thu, 24 Feb 2022
 13:34:24 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        jiri@nvidia.com, razor@blackwall.org, roopa@nvidia.com,
        dsahern@gmail.com, andrew@lunn.ch, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 04/14] net: rtnetlink: Propagate extack to rtnl_offload_xstats_fill()
Date:   Thu, 24 Feb 2022 15:33:25 +0200
Message-Id: <20220224133335.599529-5-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220224133335.599529-1-idosch@nvidia.com>
References: <20220224133335.599529-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0302CA0004.eurprd03.prod.outlook.com
 (2603:10a6:800:e9::14) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5f333194-5d39-4aa2-6a19-08d9f79a5eee
X-MS-TrafficTypeDiagnostic: DM8PR12MB5416:EE_
X-Microsoft-Antispam-PRVS: <DM8PR12MB5416D10415601B8BFE513FA3B23D9@DM8PR12MB5416.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nVvAbci48WVQPlOAWqCIbZyNWnbqshGInfqoH2UBglzQ8Pq+Is40SLAGLEyklH3HGJmZMo0HSgq8qK4Ha5ci9R3kHRsxd7LwSdYR1CHDm6FOipIxNze58kOaRwmyNlO/a76LT4RN8ptWfV7BbXn31p1PvMPnRVwi8EPDKvhy0K2if0gGqdQdR+aWJUY0OwqdwNWzY1MgBIJskdYgaMyKY0O2TmZuLn8Be47HCYEoXWplHj12KOUf2Ga8wwTux/fEhdEarEqHhyHtmuzqod0XM2azU3U7UctlEI9Vas9FDlMWNTax3ri+wTtF3kgQLQLTrm94wL7rw72fxup/F1Z92vz+TohXHuAnrL3bNlZOYxhR2xjefW0M8QU2NnV4aT9PYGcu9DsbeNi2GMwJQ5ysdvWOIGEomk7kuS7uzE2ASFS7ybLFwqHDwm0htwxHE4F+Z4l55Oznvtk0nvBdnGQEjpqzJvJP2tPkyKfCnItbr49t35EAyrDzUuj0IdyCrUyNHmlsryQE/hQGIQToSD5x4OAsF3b/83hNrkFDNrP79QZ2oztoLLKY2IPnOl4szBXh0i2AIZw5xDyiTkVjhf0Fe68YvXPiq2/TWkEjvub086+ZCxXOqYe31LzN3BMkz0YP+EnZSFVZPCUl1r/BwDu4iw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(6512007)(1076003)(107886003)(186003)(26005)(5660300002)(2616005)(2906002)(36756003)(8936002)(6486002)(38100700002)(508600001)(316002)(6506007)(66946007)(66476007)(8676002)(86362001)(66556008)(6916009)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SPX1YygVz/iO0mj13k7faS0hso7QC8r08sO0hJtD293QTKvnDbp0POfpynVD?=
 =?us-ascii?Q?vSJ5Hzhvca+YCVbDSdh+p4EMMsF7XlnoVlf5ncTwJOwHW/mxoPixp6gmNGSG?=
 =?us-ascii?Q?JtQCrI4JYRIEsiATTKGwf6p6rNiDrMfTEctfbKx6/ZJPzf7H+gchBD5pbzQo?=
 =?us-ascii?Q?hu+8vCXym5uAysfswma1jBIeEbE3ykXB+tb9O1YeooOZpgUx8nDeKQeuBOqb?=
 =?us-ascii?Q?5z5igKkQrlWY2jvo1lhE/KPDQuGhEeNTumkOYYJGEGGg20LOQ/ROt6N/tB1K?=
 =?us-ascii?Q?Vy1QGUhzix+viwLLwwBsGOGtLDmWizPVo5dhnNcL5077mMwB+OKu8V1+hmHB?=
 =?us-ascii?Q?tx1ih4ZHXsAULJxfFtju6+X5727P2c39jGyvByMlimhNAFrUgzxBNUZIpAIs?=
 =?us-ascii?Q?7YV46A/3lOIyXiDBvANBAbgTvMsZuEmNNd1EuqpImUU6e1KyLsaN6aslHT5l?=
 =?us-ascii?Q?Ok4/FVyVo4/NCZUwN1+y05EX86F/eMOsbEgHH5Vugb4f3nAVCchqJgtkj/na?=
 =?us-ascii?Q?0ddGK7Vopfxg+9KBv5jkgNjwEZpnCTa8mlJKpt3uRjA8hZ9S2X/2x6TtCldZ?=
 =?us-ascii?Q?bpsiHQcUcW9pfE700fvZ2wsGovB21jYfFPY3TQNd4wq+0W6MvPQH8bH/CcJl?=
 =?us-ascii?Q?FJMTaTRXqWTupqCWC/8j3Mem8i7s0RxSZq3qNgw80rMJ96HmDOgPYTGdS805?=
 =?us-ascii?Q?x+H8far8DWKr21vJ4zXtQXX7rtAilrlcPMAaWn8WT8aV414aTO1kobOBcCPo?=
 =?us-ascii?Q?FiiAvYrLmShzEevHX/See0pRRx1tzrD+BMnHzMt8SgE/M7cO2MOGw63BcJts?=
 =?us-ascii?Q?NYvxpVRm6fVxhU0xXPihMT1NDkeW4888XrTNlDsX7GlPb+yU12vGqhJ9o4Cv?=
 =?us-ascii?Q?Bp0O4yv8aH6TIPUeoUK6ZLht00xrdmgh5syiEtcA/DK+L57Sm8MjZhXeOifF?=
 =?us-ascii?Q?/6Ms28qwDL0edlC/XcUuDaHgBvOK8W92qMUfsbhPfoyk1OUIi/tjhE20mjKR?=
 =?us-ascii?Q?hWtfWiWHssJ5QWTPFOYo+9bWUmLiW1LXN53jIu1bjeAWd07NDwXYXCeTheXY?=
 =?us-ascii?Q?o25iym+1z5OFQ8dnqPVn6YvAR5sQSTpPD0svC57u9LZFiU0fcgGgZcY7mTIY?=
 =?us-ascii?Q?gKQAmkmuZnSQnw5vi+8/dslQ/+gh8K0yRDwZFZl6onayt/Y88Rxsepudlp+u?=
 =?us-ascii?Q?0+iMATIZtVKG7a8T5Z+d8O2SROcMpca+HUMyWpfpL2pr0EbcLuOEWpqUX8sh?=
 =?us-ascii?Q?1QI7eTvN8IO8yIX+XLLikpr8J053VYg+dRic/677hoYXE0h28UuE+sxHkYsy?=
 =?us-ascii?Q?ZizWUYCSD8czq0czbLXuPjxeDUqJ1gOZiyDbwQ1ll7rDvj+FRGUzKs9zMNtA?=
 =?us-ascii?Q?S97LV5A6/4qYJHaKkO6XTSHXx9XIQYmPpngRidbttjzUwxjC0ZmzP0dJ/H8M?=
 =?us-ascii?Q?mfo0t9rcxIX7fg6NFKqkANgENRctWFPKLIz2mJZkX1HaXja1LWsZ1y//sEGL?=
 =?us-ascii?Q?vfahrDbq7Dkb1IR6wPJVwTnuGUfozrDyO+7WfAqU8hLGYk8AdO2ueORUSdKX?=
 =?us-ascii?Q?92os69OI0HjXKvEzlQxiDTk4EzVQ/K5WwgKLcpqYVRdmiF8SeBaSURGpHcvY?=
 =?us-ascii?Q?cgZ6ce8LKw7Rhz/ptII8fsk=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f333194-5d39-4aa2-6a19-08d9f79a5eee
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 13:34:24.0124
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /RIaycb5iv5BiJLGLM7JRAzRLEMh0tranFwIaS/ozZIVK6Qu71yihJXX/0P9yq66v6ZUXfJAxOLGdrplDJ1w2g==
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

Later patches add handlers for more HW-backed statistics. An extack will be
useful when communicating HW / driver errors to the client. Add the
arguments as appropriate.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/core/rtnetlink.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index a5e2d228df02..67451ec587ee 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -5092,7 +5092,8 @@ rtnl_offload_xstats_fill_ndo(struct net_device *dev, int attr_id,
 }
 
 static int rtnl_offload_xstats_fill(struct sk_buff *skb, struct net_device *dev,
-				    int *prividx, u32 off_filter_mask)
+				    int *prividx, u32 off_filter_mask,
+				    struct netlink_ext_ack *extack)
 {
 	int attr_id_cpu_hit = IFLA_OFFLOAD_XSTATS_CPU_HIT;
 	bool have_data = false;
@@ -5147,7 +5148,8 @@ static int rtnl_fill_statsinfo(struct sk_buff *skb, struct net_device *dev,
 			       int type, u32 pid, u32 seq, u32 change,
 			       unsigned int flags,
 			       const struct rtnl_stats_dump_filters *filters,
-			       int *idxattr, int *prividx)
+			       int *idxattr, int *prividx,
+			       struct netlink_ext_ack *extack)
 {
 	unsigned int filter_mask = filters->mask[0];
 	struct if_stats_msg *ifsm;
@@ -5235,7 +5237,7 @@ static int rtnl_fill_statsinfo(struct sk_buff *skb, struct net_device *dev,
 			goto nla_put_failure;
 
 		err = rtnl_offload_xstats_fill(skb, dev, prividx,
-					       off_filter_mask);
+					       off_filter_mask, extack);
 		if (err == -ENODATA)
 			nla_nest_cancel(skb, attr);
 		else
@@ -5507,7 +5509,7 @@ static int rtnl_stats_get(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 	err = rtnl_fill_statsinfo(nskb, dev, RTM_NEWSTATS,
 				  NETLINK_CB(skb).portid, nlh->nlmsg_seq, 0,
-				  0, &filters, &idxattr, &prividx);
+				  0, &filters, &idxattr, &prividx, extack);
 	if (err < 0) {
 		/* -EMSGSIZE implies BUG in if_nlmsg_stats_size */
 		WARN_ON(err == -EMSGSIZE);
@@ -5563,7 +5565,8 @@ static int rtnl_stats_dump(struct sk_buff *skb, struct netlink_callback *cb)
 						  NETLINK_CB(cb->skb).portid,
 						  cb->nlh->nlmsg_seq, 0,
 						  flags, &filters,
-						  &s_idxattr, &s_prividx);
+						  &s_idxattr, &s_prividx,
+						  extack);
 			/* If we ran out of room on the first message,
 			 * we're in trouble
 			 */
-- 
2.33.1

