Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 204FB33411A
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 16:05:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233176AbhCJPEo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 10:04:44 -0500
Received: from mail-dm6nam10on2067.outbound.protection.outlook.com ([40.107.93.67]:4065
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232357AbhCJPEa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 10:04:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L0I9/FdAkQtuM86f7xfMkhhr8jZEXV3OgsLhfDshuIChLXfkHk7gLyI/qZyqZQoKQDKKhO5P6VRmfXCZ8JDItyZ9s8j6uiLBXBEKB+z95VFdlSbqFCxyATqawUfSb/BbjHORcFOKFZDKqAnuh4gihSmGjwqk+fgZQdIC+M6yvMCYup46001pS93a0ca6H3AIYD186TJCuqOyya3RqZLAkdXPYAOB8jCZgXDXebOi6co623FPiRwgwoG4VbQa9o+CJ6b1P39rY6lo9lKt7WBUCak7rwiBT/u/iP6w+53nJTo6nHqTlSlgBzMmFf5fIW5Cljnrk79/dmrA1VbkQvGBVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fPYPlPsQt/jwWEfKeZxHwMgqC1BlYQ9p618Nuwlll5Q=;
 b=ACnUyqbBI3SgTy44mTPJhY5zp+NBxARv7ccEtvdHsisH7WLWnRrsVGYXNSODncRByNm9KgM7Tun08YIL5krABfVNcxpMXGdeNQhQdFRQqkobIUC4fu3WoG27LE1zgQfq4bRRzA2754NpdNMMxAFXIPvgXKlYWGNq8uKrU+EVRW5ljdMKwwlZITXD8WBohL9wRXia4Nh4jC0ZOx+tra8Ght21lB8J0KiEa6QEPuGjJ6aQOzP7yrwjH3kH6R6vzFOysds2eZukVWHmWcnZ+aK7QZfK/8Vet1+CSCVyrwzV1dwoOMNPtk1JJelE91E67AnwBeG1g1wzwplqP4ff6j0bSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fPYPlPsQt/jwWEfKeZxHwMgqC1BlYQ9p618Nuwlll5Q=;
 b=C23pcu5EPrmxMJRbCGPzccLqi8CgehB3u8Di84ois0rEA6wZknBtZIcs8SPfwTpdvsh+qycXzp2lQ1VR9m5VfZ3BHUTz868GLKbzkjJe8dwUoE7018relwwiwjyEc8To4+mK2G0w3uzr7+n+QmCRI3ijNyvGKsAmy9BDV2pYXbpzCMJixxJdHy+1YCh+iCqM522LRQjIeFk2XJ+nmg1l5rvn62xEXht0rudPoxDv3rR+oZ8b9grNQXcwnFsBMzhGPSGQO5OF6BxCEwvQRdOCM4/YCu/+Rhx5oJpmuBmg/l9xF2OopkdfsYb1IQd7RT8xfHl7arAmImpFfzIyL74+mw==
Received: from BN0PR02CA0008.namprd02.prod.outlook.com (2603:10b6:408:e4::13)
 by DM6PR12MB3945.namprd12.prod.outlook.com (2603:10b6:5:1c2::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Wed, 10 Mar
 2021 15:04:25 +0000
Received: from BN8NAM11FT021.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e4:cafe::b7) by BN0PR02CA0008.outlook.office365.com
 (2603:10b6:408:e4::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend
 Transport; Wed, 10 Mar 2021 15:04:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT021.mail.protection.outlook.com (10.13.177.114) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Wed, 10 Mar 2021 15:04:24 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 10 Mar
 2021 15:04:22 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH net-next 12/14] nexthop: Add netlink handlers for bucket get
Date:   Wed, 10 Mar 2021 16:03:03 +0100
Message-ID: <85186adc516de72219b72d0dbfb957554371eed8.1615387786.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1615387786.git.petrm@nvidia.com>
References: <cover.1615387786.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 57c6baa4-a03b-472b-9dee-08d8e3d5cb56
X-MS-TrafficTypeDiagnostic: DM6PR12MB3945:
X-Microsoft-Antispam-PRVS: <DM6PR12MB3945E7F5199A664BF81E71D8D6919@DM6PR12MB3945.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aPceGqzoCJppSBvGJ8HnDQWcjPmWlcVi0K52OqL2tUaS1XjVjxPH6VQi30aUNbRGeiuTxzhL1S1pChaWQ6VKhkVQv9sTUrw+zmvMSchWXyTiUtLqgTGEVrSXdvjFVkPNXH7mANAHGo+Pm/HO2czQrvYz0PJQrTxaKnrLH9adUS8tCJmuPjglE02otWS7n+FSmQi8thxMer1r5zon1+ufTUwAzz+c5nGhI60zLbZsruDP7DAaAAsdtoSBRJ8pZyJdLbZ95t7egZZIlt9w9TNRaS+wdT2CcApkJJhpint2iELfOI4LF7/DmvABgOVZ2Vmg2Y68aFAoVYIUA10K1eTFgvRMj3Apo1qIAOJn0uVDbPrhXVGBN/uv2FmIEM8774O0SwWolLv/Lh/uXyusWsJsrFFqyO6Cd0+UmH5VeLn2JkE0PjeU9OsjLJrs4epCMs8+uDxXNQwZAtpRj9UWhkYcCHK2ng8mcULk9M/auGklT+r91qT6rW2H69B8hD2s2eTUlWEO0Wr72HgwyevBdJsj1W1MjrVR7XQrptrx53TSL8w+HzySJCPwgcjGoR7G+aPj6lLHi02tAyI0kyzihQnuCfIs2jQ6tMZ7yARJ9FUOkIp2YAOslmXL75MnE55rbsRPQFjBtn9rYNPIGP7HtyvNGDTcl3ucwUgrQsoVjWUW/cQ5GT+IToYPa+YVdDY2MMnK
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(136003)(39860400002)(46966006)(36840700001)(426003)(47076005)(36906005)(2616005)(36860700001)(107886003)(6666004)(316002)(8676002)(8936002)(82740400003)(70586007)(83380400001)(70206006)(2906002)(336012)(36756003)(356005)(54906003)(4326008)(26005)(5660300002)(86362001)(16526019)(186003)(478600001)(6916009)(82310400003)(34020700004)(7636003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2021 15:04:24.9517
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 57c6baa4-a03b-472b-9dee-08d8e3d5cb56
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT021.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3945
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow getting (but not setting) individual buckets to inspect the next hop
mapped therein, idle time, and flags.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---

Notes:
    v1 (changes since RFC):
    - u32 -> u16 for bucket counts / indices

 net/ipv4/nexthop.c | 110 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 109 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index ed2745708f9d..3d602ef6f2c1 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -66,6 +66,15 @@ static const struct nla_policy rtm_nh_res_bucket_policy_dump[] = {
 	[NHA_RES_BUCKET_NH_ID]	= { .type = NLA_U32 },
 };
 
+static const struct nla_policy rtm_nh_policy_get_bucket[] = {
+	[NHA_ID]		= { .type = NLA_U32 },
+	[NHA_RES_BUCKET]	= { .type = NLA_NESTED },
+};
+
+static const struct nla_policy rtm_nh_res_bucket_policy_get[] = {
+	[NHA_RES_BUCKET_INDEX]	= { .type = NLA_U16 },
+};
+
 static bool nexthop_notifiers_is_empty(struct net *net)
 {
 	return !net->nexthop.notifier_chain.head;
@@ -3381,6 +3390,105 @@ static int rtm_dump_nexthop_bucket(struct sk_buff *skb,
 	return err;
 }
 
+static int nh_valid_get_bucket_req_res_bucket(struct nlattr *res,
+					      u16 *bucket_index,
+					      struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[ARRAY_SIZE(rtm_nh_res_bucket_policy_get)];
+	int err;
+
+	err = nla_parse_nested(tb, ARRAY_SIZE(rtm_nh_res_bucket_policy_get) - 1,
+			       res, rtm_nh_res_bucket_policy_get, extack);
+	if (err < 0)
+		return err;
+
+	if (!tb[NHA_RES_BUCKET_INDEX]) {
+		NL_SET_ERR_MSG(extack, "Bucket index is missing");
+		return -EINVAL;
+	}
+
+	*bucket_index = nla_get_u16(tb[NHA_RES_BUCKET_INDEX]);
+	return 0;
+}
+
+static int nh_valid_get_bucket_req(const struct nlmsghdr *nlh,
+				   u32 *id, u16 *bucket_index,
+				   struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[ARRAY_SIZE(rtm_nh_policy_get_bucket)];
+	int err;
+
+	err = nlmsg_parse(nlh, sizeof(struct nhmsg), tb,
+			  ARRAY_SIZE(rtm_nh_policy_get_bucket) - 1,
+			  rtm_nh_policy_get_bucket, extack);
+	if (err < 0)
+		return err;
+
+	err = __nh_valid_get_del_req(nlh, tb, id, extack);
+	if (err)
+		return err;
+
+	if (!tb[NHA_RES_BUCKET]) {
+		NL_SET_ERR_MSG(extack, "Bucket information is missing");
+		return -EINVAL;
+	}
+
+	err = nh_valid_get_bucket_req_res_bucket(tb[NHA_RES_BUCKET],
+						 bucket_index, extack);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+/* rtnl */
+static int rtm_get_nexthop_bucket(struct sk_buff *in_skb, struct nlmsghdr *nlh,
+				  struct netlink_ext_ack *extack)
+{
+	struct net *net = sock_net(in_skb->sk);
+	struct nh_res_table *res_table;
+	struct sk_buff *skb = NULL;
+	struct nh_group *nhg;
+	struct nexthop *nh;
+	u16 bucket_index;
+	int err;
+	u32 id;
+
+	err = nh_valid_get_bucket_req(nlh, &id, &bucket_index, extack);
+	if (err)
+		return err;
+
+	nh = nexthop_find_group_resilient(net, id, extack);
+	if (IS_ERR(nh))
+		return PTR_ERR(nh);
+
+	nhg = rtnl_dereference(nh->nh_grp);
+	res_table = rtnl_dereference(nhg->res_table);
+	if (bucket_index >= res_table->num_nh_buckets) {
+		NL_SET_ERR_MSG(extack, "Bucket index out of bounds");
+		return -ENOENT;
+	}
+
+	skb = alloc_skb(NLMSG_GOODSIZE, GFP_KERNEL);
+	if (!skb)
+		return -ENOBUFS;
+
+	err = nh_fill_res_bucket(skb, nh, &res_table->nh_buckets[bucket_index],
+				 bucket_index, RTM_NEWNEXTHOPBUCKET,
+				 NETLINK_CB(in_skb).portid, nlh->nlmsg_seq,
+				 0, extack);
+	if (err < 0) {
+		WARN_ON(err == -EMSGSIZE);
+		goto errout_free;
+	}
+
+	return rtnl_unicast(skb, net, NETLINK_CB(in_skb).portid);
+
+errout_free:
+	kfree_skb(skb);
+	return err;
+}
+
 static void nexthop_sync_mtu(struct net_device *dev, u32 orig_mtu)
 {
 	unsigned int hash = nh_dev_hashfn(dev->ifindex);
@@ -3604,7 +3712,7 @@ static int __init nexthop_init(void)
 	rtnl_register(PF_INET6, RTM_NEWNEXTHOP, rtm_new_nexthop, NULL, 0);
 	rtnl_register(PF_INET6, RTM_GETNEXTHOP, NULL, rtm_dump_nexthop, 0);
 
-	rtnl_register(PF_UNSPEC, RTM_GETNEXTHOPBUCKET, NULL,
+	rtnl_register(PF_UNSPEC, RTM_GETNEXTHOPBUCKET, rtm_get_nexthop_bucket,
 		      rtm_dump_nexthop_bucket, 0);
 
 	return 0;
-- 
2.26.2

