Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02C23648F57
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 15:58:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbiLJO6n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Dec 2022 09:58:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbiLJO62 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Dec 2022 09:58:28 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2060.outbound.protection.outlook.com [40.107.92.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 102AA1A398
        for <netdev@vger.kernel.org>; Sat, 10 Dec 2022 06:58:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MZX26KGMaGC02GNsqrVRFifmaim9YoM+bfBlA/URCA0D55vZ7qC+AzBke6KqoinDu4L+3FfMS1+G5SEbQRD1eVZe+ZvQOJV6/fwC0oRtRg1jj0HgIDGHba6vPjzSKyBlepHC/TXVvwUofS+gjtTLbozYHUDJspuUk79IbdJ4T6p5GdetLVf4QphKjtSBz9z6bthO/I8oFp0z8+LJRxH2nBwln2VfRiyawkJbt/foPW0U4msEwQmg8hBcOhYzZQKD64jpJkO8rMeHkiUJ/RVvKEkff2n6DMMZ87pP5pP2DrV3JuVkmfGXOYRFRRYKijMS9JMAkmgT60xB3q7C6SL9rA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Prt3U8OQ1/aCcOV92KzZD0IF4LtS8oQDmLJTpiae5qI=;
 b=hYFCmXxvDO3bXkc9NsFgM8pyA05l0+05eqaOrHmv0nDx4E1upSamTS+7XiyaK2KbsUDnARj1j9AGSnpuchSsZBrC3hXFDYHGLdWOdGhWhTjxfCHhb9GVH2CNLzF99bu+Q3XNbzbARIOP0rxSZcfwIswRetOcVL18rdIgkOSVkD5aIkc5IBEbSFWOpC+6Sl1iBbgNCp5pjEj6xKUBzP8xIOSJRUBbxv5MahjtlBVzAKB+Sparqxg4adnLqIvAutqxiQpR/enm8ENxhJwAQwqhLtLqDoz3hKViMHHkQ5TY/fLfy9Ff5luUUiNTBkYx983CQHghMNYYtziqSqHrbNgu8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Prt3U8OQ1/aCcOV92KzZD0IF4LtS8oQDmLJTpiae5qI=;
 b=DsJ3Z9tx4jEen5KtN8+aqtaLQ712+DSRZIhDCPJLzKJG8FTKUitnfiqrShIF2ivNMjR8EXt62WjLzTIWZt1rdDRHjV0Pmf2oTyYnd+fmCRnUugGoBdc0zJtcqr1ZdBfCqLT59qFwXS6cS504tWAEmnzUTo931Vme7VqTeL1ZEp43w5OxeGvbLREcewXLiCQuzN24Fd5BA5w8gAW+eKqZ9vKVXcIdOl7LNzUnSEyi+DZQ3ezedxXERP8ASQ8ZVyAatPu1dOz0mzoxZct/EzUDFgqaBapZDAM1H5vvckeIXGJZtsVQ0oQUeVQFzjBouxVfvKifLPBhxOTOY8/dx4OjGw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by PH0PR12MB8128.namprd12.prod.outlook.com (2603:10b6:510:294::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Sat, 10 Dec
 2022 14:58:25 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a%3]) with mapi id 15.20.5880.014; Sat, 10 Dec 2022
 14:58:25 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 10/14] bridge: mcast: Allow user space to add (*, G) with a source list and filter mode
Date:   Sat, 10 Dec 2022 16:56:29 +0200
Message-Id: <20221210145633.1328511-11-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221210145633.1328511-1-idosch@nvidia.com>
References: <20221210145633.1328511-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P191CA0005.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:800:1ba::12) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|PH0PR12MB8128:EE_
X-MS-Office365-Filtering-Correlation-Id: af3825a2-5ef8-413e-d8c8-08dadabefd12
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MrY3fGNyyDGmg4r1JOVyNvHaIHGZ1gqJSuy0kmHI+UzujpnOZQeaFjpSdXsD0z5JZxVG1SiloD5vuM97Fe4XR0Z7qZ/WIToSKfZtdtRavbxC0UPBwfddEe9RpAUpzyqWoMnUNz+bocMxNwQ2pGRIl/yGrpvPIexeIy9B0jEfeN+YEVZrc/Yk8O0gig7kvHCbFGjOJGEPCx3+tsZ1yh9+59DV1FOIZrix1keT/SfNdLHW87MEdJH7V0UQsuddpuI3jC86GrUARGVMfbzlAFD5hcimctfKt/8ZI7kxp4HIcef8q0VriPEGPKrdn9xkdOe4KK73vy3cjOs5jh3yyGJYRFymfNWuzdjnd5wgfKO6dDrLHbWpdEk0uBdC4uS4aEQx4nhNq6z3IlP3OljB8ODI4kmiHTxUGV4FCRcQv+QAtpyeYwqPq/jEnJBa3x+VENN3f4TJyGMa4lAs5SmiJL1Nzv/dD9xi+SIP2lJ19r3v+79fjaJJBi9pPJujloJUHEGNVw4gVcOH08hFa+Fhb4bfJC190Xq9++FT1jWRf8d+dQq8UPfFIU1X+ZsHi9sDdRl9pE70MWHicSaoBV9Ag+1AdxnVXAdWy7MvBum4qUHwo0exxYvqXU9an6YvlUPHkLKDhpGP/FcFkGrK0hm40dNRUw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(366004)(136003)(376002)(346002)(451199015)(6512007)(186003)(26005)(478600001)(2616005)(1076003)(6486002)(6506007)(107886003)(38100700002)(83380400001)(66946007)(66556008)(66476007)(8676002)(4326008)(41300700001)(316002)(2906002)(5660300002)(8936002)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1jAHCJ1xh3OQ26ixjbU3J8cS8CkchZ3gTvR/uYtge1W7X4OoMYcX02E+9g7v?=
 =?us-ascii?Q?ccW3r4pfAhkE5oIQXGsBCDlaaOVm0WNmVsvL+cGTk3yHjtqT1E0ETheVWg79?=
 =?us-ascii?Q?5tfktdFx82BHpBteQIYEjxJOiFybXaEMhcH6xp5hjP85ti2CcIIivcx/St/b?=
 =?us-ascii?Q?pGKrlyatGWgzutXPRQXDIDmH9kuNSqXKkoxiXu0YK4hmhkuDuAxclvQ64pgz?=
 =?us-ascii?Q?Ky+Jm4yBf7t0/5WnDFfD0RiJcawqAvI4z7Le6DoUc2gQ54IJ59HzzmPm3AOV?=
 =?us-ascii?Q?QV0dkgDClI5XMPYrJ+Hv9g+B47zx/ch0LkeO3tYVs3frcmzwjg3BY1Gugofp?=
 =?us-ascii?Q?LL6u7u1fSUlkwSRSPz2q6j9Gxsrzwcv2KtR/UhdWryneyuA5SlSA9dQGsRf2?=
 =?us-ascii?Q?oDeZdyxBomyvYg54WdPr4YiBipNQfq2HeX2qrTDZWbvsLBSpN4YdxT7yx55C?=
 =?us-ascii?Q?HNQuTY4IIZRW1b4aCjqeS7t3KAJtl/UsPdYLi9SUnc4HCJVxkfDR662ZMsGE?=
 =?us-ascii?Q?kG1NMPBJhdOoBt0kU4JlkEuQtuAmUCAOjGKwspx/W+w43jViseoWj3GIQ2st?=
 =?us-ascii?Q?nZRJ4W4iDuvC3lABchMAy44cen2m5HGoW10rgLtKvVyknTYGIWtJDgB4zM91?=
 =?us-ascii?Q?LW+lzB6OE1rPZTuDQ9tXZ3mV4VnrRlQf6SY26x16KRuxARYdfw2fKEp/+l1D?=
 =?us-ascii?Q?lwzYLGjf2vJ6Nel4CEvNy8BWA8qDYGS8bIpfVmrTjO6OiIZNvkypMRi7cDvm?=
 =?us-ascii?Q?lFlaeYWYJiE1CCD1T/Frn0qTorkEYTIHiZTZwR2H2AS/pcDH8aDIZWRSe7B/?=
 =?us-ascii?Q?5A8FhggnDezPp4gYpSu4G1oU0CY54yd+eCLKeECuyImzQHwQ4jIXG8QWXkBo?=
 =?us-ascii?Q?WBrhW47t6hxY6gUnoy6hq6Ri63zZXoJ1gYYQMbeLLzXd+lfUwuVLUkkGt+/U?=
 =?us-ascii?Q?JAIw74hvTJ5MBgPPNjSkvSxfKl1BSCPkcbtse6nXhnQ0QwYGoyG0OOUP/sHX?=
 =?us-ascii?Q?gJiUpdoRhKxL7VfHzPMDHr5qXk3V6W5wv+RajvXBWkdMZdTl6nUBH7x1KTMN?=
 =?us-ascii?Q?OXU7NCgoxX/m3YV2ZIAvTCmuiK01GCm658vmgabA6IutMeZc+S0wtgnK8WMl?=
 =?us-ascii?Q?gu6w70v6k2vY0Kmx7zSFAIL1cu0bUr3wNacSbQ/Dx1wPW5f32tpWosKAx/iK?=
 =?us-ascii?Q?e5eAhW9/Tsyvn++SG+8d8ewCDi5s9YxcQHBkpTTF8Tr/l7CBkAid1/ze8Ggj?=
 =?us-ascii?Q?giZOAe5tfsieLqglMnQlSZVTObTeYotPVEGByYEJ8N94SfbJWWRmJbTycLxu?=
 =?us-ascii?Q?pO230po/wcEB9+7ovP0dLk1jJ4ErzsLk+UfMnjUuph2NoCUu8li7QKlaUYga?=
 =?us-ascii?Q?T+tRsSW4G4X3JImNxnRgCsBWoJhZpe8bgHL1wXb2idpdOAXlrlqklD4Nz00H?=
 =?us-ascii?Q?5TWqHsD/dOKclqWRUDBHS/WplbE3JIHL8UU5I0dxDDhXQ2c3UGVh7+WtVmaj?=
 =?us-ascii?Q?AAcnOyUQRpFfbNt7kTFVHUmQEKwfwAUhcro5txF3mhAjuHzpGWgQ8z3lU84V?=
 =?us-ascii?Q?RlkllXq0hprExgAoxdEOT6oVzs1vREKjyD77C+NZ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af3825a2-5ef8-413e-d8c8-08dadabefd12
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2022 14:58:25.3358
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1xPnmjAdtePKN/1b7aFAXdt71fORgL1kues0ZRHZbIEuY2ubUCDi6FybdQ4ymidloCT6ufEo8TAXAi2NedEcvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8128
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add new netlink attributes to the RTM_NEWMDB request that allow user
space to add (*, G) with a source list and filter mode.

The RTM_NEWMDB message can already dump such entries (created by the
kernel) so there is no need to add dump support. However, the message
contains a different set of attributes depending if it is a request or a
response. The naming and structure of the new attributes try to follow
the existing ones used in the response.

Request:

[ struct nlmsghdr ]
[ struct br_port_msg ]
[ MDBA_SET_ENTRY ]
	struct br_mdb_entry
[ MDBA_SET_ENTRY_ATTRS ]
	[ MDBE_ATTR_SOURCE ]
		struct in_addr / struct in6_addr
	[ MDBE_ATTR_SRC_LIST ]		// new
		[ MDBE_SRC_LIST_ENTRY ]
			[ MDBE_SRCATTR_ADDRESS ]
				struct in_addr / struct in6_addr
		[ ...]
	[ MDBE_ATTR_GROUP_MODE ]	// new
		u8

Response:

[ struct nlmsghdr ]
[ struct br_port_msg ]
[ MDBA_MDB ]
	[ MDBA_MDB_ENTRY ]
		[ MDBA_MDB_ENTRY_INFO ]
			struct br_mdb_entry
		[ MDBA_MDB_EATTR_TIMER ]
			u32
		[ MDBA_MDB_EATTR_SOURCE ]
			struct in_addr / struct in6_addr
		[ MDBA_MDB_EATTR_RTPROT ]
			u8
		[ MDBA_MDB_EATTR_SRC_LIST ]
			[ MDBA_MDB_SRCLIST_ENTRY ]
				[ MDBA_MDB_SRCATTR_ADDRESS ]
					struct in_addr / struct in6_addr
				[ MDBA_MDB_SRCATTR_TIMER ]
					u8
			[...]
		[ MDBA_MDB_EATTR_GROUP_MODE ]
			u8

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
---

Notes:
    v1:
    * Use an array instead of list to store source entries.
    * Drop br_mdb_config_attrs_fini().

 include/uapi/linux/if_bridge.h |  20 +++++
 net/bridge/br_mdb.c            | 130 +++++++++++++++++++++++++++++++++
 2 files changed, 150 insertions(+)

diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index a86a7e7b811f..0d9fe73fc48c 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -723,10 +723,30 @@ enum {
 enum {
 	MDBE_ATTR_UNSPEC,
 	MDBE_ATTR_SOURCE,
+	MDBE_ATTR_SRC_LIST,
+	MDBE_ATTR_GROUP_MODE,
 	__MDBE_ATTR_MAX,
 };
 #define MDBE_ATTR_MAX (__MDBE_ATTR_MAX - 1)
 
+/* per mdb entry source */
+enum {
+	MDBE_SRC_LIST_UNSPEC,
+	MDBE_SRC_LIST_ENTRY,
+	__MDBE_SRC_LIST_MAX,
+};
+#define MDBE_SRC_LIST_MAX (__MDBE_SRC_LIST_MAX - 1)
+
+/* per mdb entry per source attributes
+ * these are embedded in MDBE_SRC_LIST_ENTRY
+ */
+enum {
+	MDBE_SRCATTR_UNSPEC,
+	MDBE_SRCATTR_ADDRESS,
+	__MDBE_SRCATTR_MAX,
+};
+#define MDBE_SRCATTR_MAX (__MDBE_SRCATTR_MAX - 1)
+
 /* Embedded inside LINK_XSTATS_TYPE_BRIDGE */
 enum {
 	BRIDGE_XSTATS_UNSPEC,
diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index e9a4b7e247e7..61d46b0a31b6 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -663,10 +663,25 @@ void br_rtr_notify(struct net_device *dev, struct net_bridge_mcast_port *pmctx,
 	rtnl_set_sk_err(net, RTNLGRP_MDB, err);
 }
 
+static const struct nla_policy
+br_mdbe_src_list_entry_pol[MDBE_SRCATTR_MAX + 1] = {
+	[MDBE_SRCATTR_ADDRESS] = NLA_POLICY_RANGE(NLA_BINARY,
+						  sizeof(struct in_addr),
+						  sizeof(struct in6_addr)),
+};
+
+static const struct nla_policy
+br_mdbe_src_list_pol[MDBE_SRC_LIST_MAX + 1] = {
+	[MDBE_SRC_LIST_ENTRY] = NLA_POLICY_NESTED(br_mdbe_src_list_entry_pol),
+};
+
 static const struct nla_policy br_mdbe_attrs_pol[MDBE_ATTR_MAX + 1] = {
 	[MDBE_ATTR_SOURCE] = NLA_POLICY_RANGE(NLA_BINARY,
 					      sizeof(struct in_addr),
 					      sizeof(struct in6_addr)),
+	[MDBE_ATTR_GROUP_MODE] = NLA_POLICY_RANGE(NLA_U8, MCAST_EXCLUDE,
+						  MCAST_INCLUDE),
+	[MDBE_ATTR_SRC_LIST] = NLA_POLICY_NESTED(br_mdbe_src_list_pol),
 };
 
 static bool is_valid_mdb_entry(struct br_mdb_entry *entry,
@@ -1051,6 +1066,76 @@ static int __br_mdb_add(const struct br_mdb_config *cfg,
 	return ret;
 }
 
+static int br_mdb_config_src_entry_init(struct nlattr *src_entry,
+					struct br_mdb_src_entry *src,
+					__be16 proto,
+					struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[MDBE_SRCATTR_MAX + 1];
+	int err;
+
+	err = nla_parse_nested(tb, MDBE_SRCATTR_MAX, src_entry,
+			       br_mdbe_src_list_entry_pol, extack);
+	if (err)
+		return err;
+
+	if (NL_REQ_ATTR_CHECK(extack, src_entry, tb, MDBE_SRCATTR_ADDRESS))
+		return -EINVAL;
+
+	if (!is_valid_mdb_source(tb[MDBE_SRCATTR_ADDRESS], proto, extack))
+		return -EINVAL;
+
+	src->addr.proto = proto;
+	nla_memcpy(&src->addr.src, tb[MDBE_SRCATTR_ADDRESS],
+		   nla_len(tb[MDBE_SRCATTR_ADDRESS]));
+
+	return 0;
+}
+
+static int br_mdb_config_src_list_init(struct nlattr *src_list,
+				       struct br_mdb_config *cfg,
+				       struct netlink_ext_ack *extack)
+{
+	struct nlattr *src_entry;
+	int rem, err;
+	int i = 0;
+
+	nla_for_each_nested(src_entry, src_list, rem)
+		cfg->num_src_entries++;
+
+	if (cfg->num_src_entries >= PG_SRC_ENT_LIMIT) {
+		NL_SET_ERR_MSG_FMT_MOD(extack, "Exceeded maximum number of source entries (%u)",
+				       PG_SRC_ENT_LIMIT - 1);
+		return -EINVAL;
+	}
+
+	cfg->src_entries = kcalloc(cfg->num_src_entries,
+				   sizeof(struct br_mdb_src_entry), GFP_KERNEL);
+	if (!cfg->src_entries)
+		return -ENOMEM;
+
+	nla_for_each_nested(src_entry, src_list, rem) {
+		err = br_mdb_config_src_entry_init(src_entry,
+						   &cfg->src_entries[i],
+						   cfg->entry->addr.proto,
+						   extack);
+		if (err)
+			goto err_src_entry_init;
+		i++;
+	}
+
+	return 0;
+
+err_src_entry_init:
+	kfree(cfg->src_entries);
+	return err;
+}
+
+static void br_mdb_config_src_list_fini(struct br_mdb_config *cfg)
+{
+	kfree(cfg->src_entries);
+}
+
 static int br_mdb_config_attrs_init(struct nlattr *set_attrs,
 				    struct br_mdb_config *cfg,
 				    struct netlink_ext_ack *extack)
@@ -1070,6 +1155,44 @@ static int br_mdb_config_attrs_init(struct nlattr *set_attrs,
 
 	__mdb_entry_to_br_ip(cfg->entry, &cfg->group, mdb_attrs);
 
+	if (mdb_attrs[MDBE_ATTR_GROUP_MODE]) {
+		if (!cfg->p) {
+			NL_SET_ERR_MSG_MOD(extack, "Filter mode cannot be set for host groups");
+			return -EINVAL;
+		}
+		if (!br_multicast_is_star_g(&cfg->group)) {
+			NL_SET_ERR_MSG_MOD(extack, "Filter mode can only be set for (*, G) entries");
+			return -EINVAL;
+		}
+		cfg->filter_mode = nla_get_u8(mdb_attrs[MDBE_ATTR_GROUP_MODE]);
+	} else {
+		cfg->filter_mode = MCAST_EXCLUDE;
+	}
+
+	if (mdb_attrs[MDBE_ATTR_SRC_LIST]) {
+		if (!cfg->p) {
+			NL_SET_ERR_MSG_MOD(extack, "Source list cannot be set for host groups");
+			return -EINVAL;
+		}
+		if (!br_multicast_is_star_g(&cfg->group)) {
+			NL_SET_ERR_MSG_MOD(extack, "Source list can only be set for (*, G) entries");
+			return -EINVAL;
+		}
+		if (!mdb_attrs[MDBE_ATTR_GROUP_MODE]) {
+			NL_SET_ERR_MSG_MOD(extack, "Source list cannot be set without filter mode");
+			return -EINVAL;
+		}
+		err = br_mdb_config_src_list_init(mdb_attrs[MDBE_ATTR_SRC_LIST],
+						  cfg, extack);
+		if (err)
+			return err;
+	}
+
+	if (!cfg->num_src_entries && cfg->filter_mode == MCAST_INCLUDE) {
+		NL_SET_ERR_MSG_MOD(extack, "Cannot add (*, G) INCLUDE with an empty source list");
+		return -EINVAL;
+	}
+
 	return 0;
 }
 
@@ -1162,6 +1285,11 @@ static int br_mdb_config_init(struct net *net, const struct nlmsghdr *nlh,
 	return 0;
 }
 
+static void br_mdb_config_fini(struct br_mdb_config *cfg)
+{
+	br_mdb_config_src_list_fini(cfg);
+}
+
 static int br_mdb_add(struct sk_buff *skb, struct nlmsghdr *nlh,
 		      struct netlink_ext_ack *extack)
 {
@@ -1220,6 +1348,7 @@ static int br_mdb_add(struct sk_buff *skb, struct nlmsghdr *nlh,
 	}
 
 out:
+	br_mdb_config_fini(&cfg);
 	return err;
 }
 
@@ -1295,6 +1424,7 @@ static int br_mdb_del(struct sk_buff *skb, struct nlmsghdr *nlh,
 		err = __br_mdb_del(&cfg);
 	}
 
+	br_mdb_config_fini(&cfg);
 	return err;
 }
 
-- 
2.37.3

