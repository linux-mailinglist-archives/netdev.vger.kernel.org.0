Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D08C4CAA4B
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 17:33:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242596AbiCBQdn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 11:33:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242703AbiCBQdi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 11:33:38 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2071.outbound.protection.outlook.com [40.107.243.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 303F34477C
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 08:32:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=khKI7SvYHXHxrOH47Xwls+NhbdpsnUOlJnD8rYKau5q2F2u+QHYBtbIIZrqPwDTmXhj/KAzHQG2gsGEXJbfWGfkjUesK19ZdyRmPB0g3HeEgJ5aJT9JivMxVLLBgrFA1MRZV+BCymb/HHD9z2GpSiLzxB0ieUo3R/APj3G4mcSlQqBQuQAL71wCkmDhHYMY0ZORx8oDmAHvoLxu5fyF+9+g3wj9XcOKTUhFOejwo081vVPV+LPCa3dYq+46//diTV3GYhrtj6fooQ1hxKLGrguUpgvr/91NXpX7mkx5HbqNFpM9yRI3QXQBa8x6IhenRjn6cgP2SE3vF0Rdm5ZULPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GnMId5Dt96gJcgd6j8kKg1opGcT6em7rqjwA6F2glRs=;
 b=P9Td9ugQj2BebMelK8N+jRP6nQc/Dzf9Sqxy1sN88HeVQeH7zTlJZgG9mioVaDCqVg9OYq4Sx5pWmpHz7hG8USJj1vSo0oxQu8cMERizctr7aT8Yw0IONPirISJ58VawTPtoRTAlgKDQsvHNJI8jZkvP9sdfnQYNdDVcAc/64B6bUqOpq0WP1zqR3h+prpsp109goobcughqJk0Qnf0cLJALucj6fK2PHk0wTE+R2N9nEBYqQtAaGAW0yHUu1357nijHTmO8KXbOHijRYpD36lKr2Ox/e0exc/d5oMyFWIGe0gmJE41gx1qip1jBqNbQadQBc0CvYtSuC3MCERoQtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GnMId5Dt96gJcgd6j8kKg1opGcT6em7rqjwA6F2glRs=;
 b=Af1moQqvgYsqyLWzc1eSPBMunmQgR0b1Os2CWTO44uCgwQYQgPY1pkDuvzeNy51E0FG0a+TzN/JrQOzfTwCmVSP6kDV1TOdIX6ahrvhLcNMF/VPMMzfeXqt0WCj1j4xlthxJoKyqa5ZrPX6bu2odPTN+D9MOsTjGyEq1f29wApppCpj7FO3b34nAY68QCCac8T5RW2tAj7fJMvSTdGdqX65tbHXIP0RlU4caEC7xL24/8aYaR08V5PzBvdipzOY143FXNbxMfoZa9LfcRY4C2GQPlNCI1HP7hhxDPworQrCj32SUm7FTlQBpqM7aTh0OVpGhEOpyU8BktMFEupy1lg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by MN2PR12MB3998.namprd12.prod.outlook.com (2603:10b6:208:16d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.23; Wed, 2 Mar
 2022 16:32:45 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581%6]) with mapi id 15.20.5038.014; Wed, 2 Mar 2022
 16:32:45 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        jiri@nvidia.com, roopa@nvidia.com, razor@blackwall.org,
        dsahern@gmail.com, andrew@lunn.ch, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 08/14] net: rtnetlink: Add RTM_SETSTATS
Date:   Wed,  2 Mar 2022 18:31:22 +0200
Message-Id: <20220302163128.218798-9-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220302163128.218798-1-idosch@nvidia.com>
References: <20220302163128.218798-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0801CA0073.eurprd08.prod.outlook.com
 (2603:10a6:800:7d::17) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1b32c26a-6fb2-4119-c486-08d9fc6a47c4
X-MS-TrafficTypeDiagnostic: MN2PR12MB3998:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB399844EBE626E3E2CE8AA85CB2039@MN2PR12MB3998.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gWBbrCVtqqXdTelc/bm40JgZcKoZ3mfEwApdVEnnjqZWu6Jm1ezM9WSJ04dAYVKBH/r+Qy2ZwMO9fl0D5xRUCCUUmVst0fZj5mLMF4QajFOwV9M9oZDq7Jpsu4/ogXWMryMED6vnsEUQ2svb/+nfOT4U6QK9iDsCPF+Edmdpfq42SYFBFXS05kgnR4K1NEUpwjJHKbz0Gci4w8NoIIrJgKOswI133i0P/HqpG83WIYCbaHfcsJ6KjJpCgFtwooSUXf5U0Iojm7s5ora0V04l+3aIkeDXzvCNFOwKP12G49igWiwjzzkx59dkr0mbYDULhqhNK7FWOsMecXmX5CHLKw5oNQALNZ2x94OockRcPRjtFAYdJPvFXyy/44Qut0R2+38iO+Cs7yCz2PaDMi//GNLkeXdgDUyMgcrWRrEOMe2iJFXW66vZ3Kr4iJkWJQ8WACKvDNN0SET9qxK2AtPIamHkyUg7vsnblVU0nxlA/FEBqhVf6Rpz8fT+0+CoumdNXH0yUUD/ZyuG0W5rRCQh5YO/FKRD7I97UCBNAlFs+39joBiRvt2Jw+49M9OrHoY6wonyQCYlidWzQFhGbuoD+sDB6w6T3ldWdHsehSfkMLu9KwbfIKSn0yB0hGQ5dk9Y3T71OF+27xKek8brwS+73Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(86362001)(2616005)(316002)(6916009)(6506007)(6666004)(26005)(1076003)(186003)(6512007)(107886003)(83380400001)(38100700002)(8676002)(66556008)(4326008)(66476007)(2906002)(508600001)(66946007)(6486002)(5660300002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rRupLE00jacbI1HAsEhP+yFHHAaoknhUs0TMgGMSve5U47uit23t+WuvDSrz?=
 =?us-ascii?Q?pHyabFgOMQERbgGGRKAVNo+fsyhsC9DO37CkJQ3ZDcwMARTlD0kd6nY20fOx?=
 =?us-ascii?Q?cGS71gE0gDilmUZzNYzvM1RXoWfBKvKvwmV7WMdm2ImAV5rN68fIfYHP4+vR?=
 =?us-ascii?Q?ffhTwUUKeWKk9tQagePNssqLzNIdBCYB6W0N0U9fZWnNA31wGHBuTtbs9dAK?=
 =?us-ascii?Q?qDHBMJ++7CAMqQERbBsXFlE5mTU8UqRlMIsBcuYVNZCwfBgYqjuXx30BIkTI?=
 =?us-ascii?Q?R+0nAZSFkr6jUt931iDjQYLaibecAAQBTo/R3IDSAuhmAUuZo6fsypeuiTdb?=
 =?us-ascii?Q?jG6q5W8HtcAC0flfdl43N3/I/ggIIX+6rUCRSXZ4zpaHDnoAHlIKuaQdyA/x?=
 =?us-ascii?Q?2tck1mqfgv9crPFe0Fbyde+6s6kQIX4/7Eyi1ib4fLZBuIDcREelxMfZZNLB?=
 =?us-ascii?Q?QTXiPfg2962NwxSkz+gsRaLyfiAAtDRVUUyK57qA7ZpUni6z4/EzS3jlFqMo?=
 =?us-ascii?Q?OBPuk1fvWoCJnBzzHeS3P6JsibFLkiAzJlYLnvwH1goANi0f8q5KsJGfOaHx?=
 =?us-ascii?Q?pr53P+LvphlLuLHZadIsVdi4rx0KuBbtPfOM1C/MxFl8d5v+qwpMg4NDsGpN?=
 =?us-ascii?Q?XlXTw2lowZ40DgKyiC28JPhX/neEKm0aidozhiYf+iCRQ+4iFA9ERmDI4gBP?=
 =?us-ascii?Q?CAKqBNmytf6kdEpFSH/kfEI/poCaZLhy9V4HHBA8vXespo9KBM76s3+l/fGP?=
 =?us-ascii?Q?DFKC6r4OEPcRozj2lsbLiucrXJ93EfWiA3obnhX874a7fOQ92Th+Gmo58zSH?=
 =?us-ascii?Q?5ETMgvhfX6iUN16O8DGonA8AdxWA7QAVL2aNPRFOqefxW5Dl0KapeUNWx6cx?=
 =?us-ascii?Q?bJ/Rt3i59++kGh+QUoH/u2QfXUEq97DkTw3eiUf3/+8kKnBtDdWi69jt33p9?=
 =?us-ascii?Q?P8jTO6Zk45iFZN+vC3WpXnv6NDnV3hM1KFAayNEotCk/SlAldeXsOwuV/UA7?=
 =?us-ascii?Q?CRaVGpqMpA7cYjX1p8xC8TPUGIdYaj3bArQ8GabXURKHswdItQZFaY1g9K4v?=
 =?us-ascii?Q?cxA4nMbgzdtVyWH3KuQ6vtXsCGwrQ6+iYYlXEwcIxb4UirtlpRsyzjfMLV3d?=
 =?us-ascii?Q?u3cgbUghJn5MjKD5c287WvMYR2k7M5n/eifq+OIwI75hgg0M60BJSnlRRxyQ?=
 =?us-ascii?Q?VjZiWZ4WqADuDIOPApLiHx710730asHfG8smx50p1CPyJueHaKdG0/C7suem?=
 =?us-ascii?Q?YQow2uffbYVoX94NpksaezPXpA0hZepyvIino3TD+jomAqe2RpWnZa0aSbCw?=
 =?us-ascii?Q?ViSffzplbYGZf8CJwOA/naCtnunzYu3t2AdPFRJbkQj2n41q2IeZxt5paAOz?=
 =?us-ascii?Q?LxTjvy629a7l3rzfRy0i1coLrvwtbWUznPG1EV6yxqXUARfL9CHkFhC7r2CN?=
 =?us-ascii?Q?euSO6KTmcoVtIASdTZ4sDMVvUL2zp7X/52990uoO00IV1vdL9pXSYD3IbbNj?=
 =?us-ascii?Q?ZDJ1z34lOmiRbxtoMv07HZ0mxfkjzvzW/egEQ0aGzTjZNBsdqX57pKjbI2fc?=
 =?us-ascii?Q?lVPrDxTNx99V6cXW6BVdldD5kxGGUBM0+Sn0zOGIZhxK8iGaxUoGBnodwtDm?=
 =?us-ascii?Q?lBL+hAjZavf33WsMsxj+qCA=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b32c26a-6fb2-4119-c486-08d9fc6a47c4
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2022 16:32:45.2321
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kQYTOmjKQ5y8cODsLCDIxBEz6jwjAq4T+lI+BuD45PBLF4CBnC37E1gKp3mhO+AzPYKM18jZSsFSahicMyg07Q==
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

The offloaded HW stats are designed to allow per-netdevice enablement and
disablement. These stats are only accessible through RTM_GETSTATS, and
therefore should be toggled by a RTM_SETSTATS message. Add it, and the
necessary skeleton handler.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 include/uapi/linux/rtnetlink.h |  2 ++
 net/core/rtnetlink.c           | 66 ++++++++++++++++++++++++++++++++++
 security/selinux/nlmsgtab.c    |  1 +
 3 files changed, 69 insertions(+)

diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.h
index 0970cb4b1b88..14462dc159fd 100644
--- a/include/uapi/linux/rtnetlink.h
+++ b/include/uapi/linux/rtnetlink.h
@@ -146,6 +146,8 @@ enum {
 #define RTM_NEWSTATS RTM_NEWSTATS
 	RTM_GETSTATS = 94,
 #define RTM_GETSTATS RTM_GETSTATS
+	RTM_SETSTATS,
+#define RTM_SETSTATS RTM_SETSTATS
 
 	RTM_NEWCACHEREPORT = 96,
 #define RTM_NEWCACHEREPORT RTM_NEWCACHEREPORT
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 9ce894a9454c..d09354514355 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -5564,6 +5564,10 @@ rtnl_stats_get_policy[IFLA_STATS_GETSET_MAX + 1] = {
 		    NLA_POLICY_NESTED(rtnl_stats_get_policy_filters),
 };
 
+static const struct nla_policy
+ifla_stats_set_policy[IFLA_STATS_GETSET_MAX + 1] = {
+};
+
 static int rtnl_stats_get_parse_filters(struct nlattr *ifla_filters,
 					struct rtnl_stats_dump_filters *filters,
 					struct netlink_ext_ack *extack)
@@ -5769,6 +5773,67 @@ static int rtnl_stats_dump(struct sk_buff *skb, struct netlink_callback *cb)
 	return skb->len;
 }
 
+static int rtnl_stats_set(struct sk_buff *skb, struct nlmsghdr *nlh,
+			  struct netlink_ext_ack *extack)
+{
+	struct rtnl_stats_dump_filters response_filters = {};
+	struct nlattr *tb[IFLA_STATS_GETSET_MAX + 1];
+	struct net *net = sock_net(skb->sk);
+	struct net_device *dev = NULL;
+	int idxattr = 0, prividx = 0;
+	struct if_stats_msg *ifsm;
+	struct sk_buff *nskb;
+	int err;
+
+	err = rtnl_valid_stats_req(nlh, netlink_strict_get_check(skb),
+				   false, extack);
+	if (err)
+		return err;
+
+	ifsm = nlmsg_data(nlh);
+	if (ifsm->family != AF_UNSPEC) {
+		NL_SET_ERR_MSG(extack, "Address family should be AF_UNSPEC");
+		return -EINVAL;
+	}
+
+	if (ifsm->ifindex > 0)
+		dev = __dev_get_by_index(net, ifsm->ifindex);
+	else
+		return -EINVAL;
+
+	if (!dev)
+		return -ENODEV;
+
+	if (ifsm->filter_mask) {
+		NL_SET_ERR_MSG(extack, "Filter mask must be 0 for stats set");
+		return -EINVAL;
+	}
+
+	err = nlmsg_parse(nlh, sizeof(*ifsm), tb, IFLA_STATS_GETSET_MAX,
+			  ifla_stats_set_policy, extack);
+	if (err < 0)
+		return err;
+
+	nskb = nlmsg_new(if_nlmsg_stats_size(dev, &response_filters),
+			 GFP_KERNEL);
+	if (!nskb)
+		return -ENOBUFS;
+
+	err = rtnl_fill_statsinfo(nskb, dev, RTM_NEWSTATS,
+				  NETLINK_CB(skb).portid, nlh->nlmsg_seq, 0,
+				  0, &response_filters, &idxattr, &prividx,
+				  extack);
+	if (err < 0) {
+		/* -EMSGSIZE implies BUG in if_nlmsg_stats_size */
+		WARN_ON(err == -EMSGSIZE);
+		kfree_skb(nskb);
+	} else {
+		err = rtnl_unicast(nskb, net, NETLINK_CB(skb).portid);
+	}
+
+	return err;
+}
+
 /* Process one rtnetlink message. */
 
 static int rtnetlink_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
@@ -5994,4 +6059,5 @@ void __init rtnetlink_init(void)
 
 	rtnl_register(PF_UNSPEC, RTM_GETSTATS, rtnl_stats_get, rtnl_stats_dump,
 		      0);
+	rtnl_register(PF_UNSPEC, RTM_SETSTATS, rtnl_stats_set, NULL, 0);
 }
diff --git a/security/selinux/nlmsgtab.c b/security/selinux/nlmsgtab.c
index 6ad3ee02e023..d8ceee9e0d6f 100644
--- a/security/selinux/nlmsgtab.c
+++ b/security/selinux/nlmsgtab.c
@@ -76,6 +76,7 @@ static const struct nlmsg_perm nlmsg_route_perms[] =
 	{ RTM_GETNSID,		NETLINK_ROUTE_SOCKET__NLMSG_READ  },
 	{ RTM_NEWSTATS,		NETLINK_ROUTE_SOCKET__NLMSG_READ },
 	{ RTM_GETSTATS,		NETLINK_ROUTE_SOCKET__NLMSG_READ  },
+	{ RTM_SETSTATS,		NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
 	{ RTM_NEWCACHEREPORT,	NETLINK_ROUTE_SOCKET__NLMSG_READ },
 	{ RTM_NEWCHAIN,		NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
 	{ RTM_DELCHAIN,		NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
-- 
2.33.1

