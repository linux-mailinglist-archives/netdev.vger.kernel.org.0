Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A38A2337BB1
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 19:05:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230354AbhCKSEq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 13:04:46 -0500
Received: from mail-bn7nam10on2074.outbound.protection.outlook.com ([40.107.92.74]:19248
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230033AbhCKSEd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 13:04:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IffTfRmB64DdphhNiI6TcotTw/v9AsCWSGgB4tJvbcDGz3WNj2Jgig07w5fzbQMZu5145+jD4vqSPlMgGgaaDcIxBb2ThC3x2T8VB7txlai40YDX1FGBdoDzPpg6xUaf+TqJR/SJ1IQoFiy6hnrXp20AnDcxeeKOdyv8CmnlHd6Q6Lk0YrnRe7qLveCY8kExCSFzk8ZLUHyXElY1oUgGZXxFQkPunNAZFSo7VrGXS2kRhalKgy/4Qm7pW6ZYTwdLg+D6UOM2Cy/Bra4IZQLK0G3O+IdMegmTa+lf1Jai+b7ERLXk8CJzSj2i6rsEzlIva2R5/lIphvyBeelLX0FX7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ACTE62HcPbLeqVNb159l+/cBIZeNtkeZqfJRtA7kkLA=;
 b=MsC+UTvV64H4PCjgzL3DKGXHVCRSa2u/x702yrzHvoIidOZFQq3VK85v/BZzKbkyMHST+yBKTGuTv7f8zvGkNbX0NVR3QZTUJwNMeYYLaTm+L6vNKsU3q3moc6VwoumeG2/rgg3kGRftGTqk50I2NdiA9mTHHI+BJ1571hR+AUqHxu+8OKVu/KgO+E2CO450oZBwBMQ8hJFVFs7WTijK22IrjQnCwmbee7vffAw4Pebj3vkQ1JyB/pa6IpT1X3xAzIaPuVrcmLwgi9aCeGn3fgx96REoiLFPzh8qv+1/guXuAdeICpw0hn+JtQcAkgrwDiV5GYkvPOk/c1Y5AJv04g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ACTE62HcPbLeqVNb159l+/cBIZeNtkeZqfJRtA7kkLA=;
 b=BvTHR2d7X6hkNtvdDBkFTPYSqOURJ59Gse1LC5A1n9HS8H9Ei7sH/mCeK/5/BSRan3vZuDgIVARq6S1vN3Vz7cm2H5YLkNgcKJRdqg86um1gvPxxisJCNcDgKaN2VldQh2RUtcrY+EXdVbVQh59XKLWrHOQYrTSRwNHAU30nPVbgoEVsZvDvzPT4mrrxXqonPpFLr6jUq+Ek6Yid61qGRnsaKAPYdDNls3ntpfYY2gks5G21rfb3bX0nTMjJpASp7LjlnXYY3pnVrb/76MS3CUX6DIxWx+5uiol+uYK5RpGdWU+/4urGavAuB5FmqrmX04C9RkHmpOqUZFxdJjqGEg==
Received: from BN6PR13CA0037.namprd13.prod.outlook.com (2603:10b6:404:13e::23)
 by BN9PR12MB5241.namprd12.prod.outlook.com (2603:10b6:408:11e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.30; Thu, 11 Mar
 2021 18:04:29 +0000
Received: from BN8NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:13e:cafe::43) by BN6PR13CA0037.outlook.office365.com
 (2603:10b6:404:13e::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.10 via Frontend
 Transport; Thu, 11 Mar 2021 18:04:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT060.mail.protection.outlook.com (10.13.177.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Thu, 11 Mar 2021 18:04:28 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Mar
 2021 18:04:24 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH net-next v2 11/14] nexthop: Add netlink handlers for bucket dump
Date:   Thu, 11 Mar 2021 19:03:22 +0100
Message-ID: <52363e987d4412512cfef60114953c0af9f02085.1615485052.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1615485052.git.petrm@nvidia.com>
References: <cover.1615485052.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3235fdaf-829f-4b00-79da-08d8e4b81d4c
X-MS-TrafficTypeDiagnostic: BN9PR12MB5241:
X-Microsoft-Antispam-PRVS: <BN9PR12MB52414403D4A2891485D9F898D6909@BN9PR12MB5241.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2089;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K7eBNKXsTQGN5b90rPrkCrYkgWgkg4i4rUwVvzM8krWyhhtQSwpJdjww/AV25NY6IX3o8C8GC9wxaI7AcgmgLqbrUPpSZrigL/99sZcbPpefg7QNXJYk4ttXmjerAOSbBMOF8T6c4+IVGqmbtqB4FSM9wi/e8lGIyHi2jELa2hCdlh6W8J/mB88Wjb9skWXdKDO8+7iLPd9SYeA/5PM7D0Eh+/sdCcR9eas2QXajjjR//OopN/vvbhkT1a0gYL3GhD+lfxXAoS2/go15RRWlXwUeN1dPKi8t6A69xOF/ZVBSGZk/kZnphvhxXN1PT7V3OTlhN3OofonbkpsgO0I1+Ih2jJ7AksrnAAU6ZQYKzDtI5mGHOf/aZupQzhTLtNc1Nxcy6wEIlQwyJ7Q6/cfYNFLeWCbBaTWtY/6IDR8RNJjeJq9HquUH2ahAfAS1DQXZeVI+ipGfqyd4yle+CBe4GeTORcdnmY4gRqxs4TxL91ymvrb9YveifkHqxOh1xDO37OYQaEuu1x4Fa6x8NCx/zou37b691ggv7CKf20SNrZbOwxBGbIp6U1qAQyqdnB/Hg8QzD12wACbcdojFFmfKsGC9k7yPv6eKbKhZSUSJSWrvYIhM1xmy/0YFM1H7ICOPAM6qfWYqkJ4Rtp2a3kBeYIMZiB9WgUj2aYzFZ8p0sX0ZI1P7AbMTAJZ4VnEgmzBf
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(346002)(376002)(136003)(39860400002)(46966006)(36840700001)(107886003)(70206006)(426003)(47076005)(70586007)(478600001)(316002)(36906005)(83380400001)(36860700001)(5660300002)(16526019)(26005)(54906003)(4326008)(186003)(2616005)(34020700004)(8936002)(82740400003)(2906002)(86362001)(356005)(8676002)(7636003)(82310400003)(336012)(6916009)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 18:04:28.7782
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3235fdaf-829f-4b00-79da-08d8e4b81d4c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5241
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a dump handler for resilient next hop buckets. When next-hop group ID
is given, it walks buckets of that group, otherwise it walks buckets of all
groups. It then dumps the buckets whose next hops match the given filtering
criteria.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
---

Notes:
    v1 (changes since RFC):
    - u32 -> u16 for bucket counts / indices

 net/ipv4/nexthop.c | 283 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 283 insertions(+)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 439bf3b7ced5..ed2745708f9d 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -55,6 +55,17 @@ static const struct nla_policy rtm_nh_res_policy_new[] = {
 	[NHA_RES_GROUP_UNBALANCED_TIMER]	= { .type = NLA_U32 },
 };
 
+static const struct nla_policy rtm_nh_policy_dump_bucket[] = {
+	[NHA_ID]		= { .type = NLA_U32 },
+	[NHA_OIF]		= { .type = NLA_U32 },
+	[NHA_MASTER]		= { .type = NLA_U32 },
+	[NHA_RES_BUCKET]	= { .type = NLA_NESTED },
+};
+
+static const struct nla_policy rtm_nh_res_bucket_policy_dump[] = {
+	[NHA_RES_BUCKET_NH_ID]	= { .type = NLA_U32 },
+};
+
 static bool nexthop_notifiers_is_empty(struct net *net)
 {
 	return !net->nexthop.notifier_chain.head;
@@ -883,6 +894,60 @@ static void nh_res_bucket_set_busy(struct nh_res_bucket *bucket)
 	atomic_long_set(&bucket->used_time, (long)jiffies);
 }
 
+static clock_t nh_res_bucket_idle_time(const struct nh_res_bucket *bucket)
+{
+	unsigned long used_time = nh_res_bucket_used_time(bucket);
+
+	return jiffies_delta_to_clock_t(jiffies - used_time);
+}
+
+static int nh_fill_res_bucket(struct sk_buff *skb, struct nexthop *nh,
+			      struct nh_res_bucket *bucket, u16 bucket_index,
+			      int event, u32 portid, u32 seq,
+			      unsigned int nlflags,
+			      struct netlink_ext_ack *extack)
+{
+	struct nh_grp_entry *nhge = nh_res_dereference(bucket->nh_entry);
+	struct nlmsghdr *nlh;
+	struct nlattr *nest;
+	struct nhmsg *nhm;
+
+	nlh = nlmsg_put(skb, portid, seq, event, sizeof(*nhm), nlflags);
+	if (!nlh)
+		return -EMSGSIZE;
+
+	nhm = nlmsg_data(nlh);
+	nhm->nh_family = AF_UNSPEC;
+	nhm->nh_flags = bucket->nh_flags;
+	nhm->nh_protocol = nh->protocol;
+	nhm->nh_scope = 0;
+	nhm->resvd = 0;
+
+	if (nla_put_u32(skb, NHA_ID, nh->id))
+		goto nla_put_failure;
+
+	nest = nla_nest_start(skb, NHA_RES_BUCKET);
+	if (!nest)
+		goto nla_put_failure;
+
+	if (nla_put_u16(skb, NHA_RES_BUCKET_INDEX, bucket_index) ||
+	    nla_put_u32(skb, NHA_RES_BUCKET_NH_ID, nhge->nh->id) ||
+	    nla_put_u64_64bit(skb, NHA_RES_BUCKET_IDLE_TIME,
+			      nh_res_bucket_idle_time(bucket),
+			      NHA_RES_BUCKET_PAD))
+		goto nla_put_failure_nest;
+
+	nla_nest_end(skb, nest);
+	nlmsg_end(skb, nlh);
+	return 0;
+
+nla_put_failure_nest:
+	nla_nest_cancel(skb, nest);
+nla_put_failure:
+	nlmsg_cancel(skb, nlh);
+	return -EMSGSIZE;
+}
+
 static bool valid_group_nh(struct nexthop *nh, unsigned int npaths,
 			   bool *is_fdb, struct netlink_ext_ack *extack)
 {
@@ -2918,10 +2983,12 @@ static int rtm_get_nexthop(struct sk_buff *in_skb, struct nlmsghdr *nlh,
 }
 
 struct nh_dump_filter {
+	u32 nh_id;
 	int dev_idx;
 	int master_idx;
 	bool group_filter;
 	bool fdb_filter;
+	u32 res_bucket_nh_id;
 };
 
 static bool nh_dump_filtered(struct nexthop *nh,
@@ -3101,6 +3168,219 @@ static int rtm_dump_nexthop(struct sk_buff *skb, struct netlink_callback *cb)
 	return err;
 }
 
+static struct nexthop *
+nexthop_find_group_resilient(struct net *net, u32 id,
+			     struct netlink_ext_ack *extack)
+{
+	struct nh_group *nhg;
+	struct nexthop *nh;
+
+	nh = nexthop_find_by_id(net, id);
+	if (!nh)
+		return ERR_PTR(-ENOENT);
+
+	if (!nh->is_group) {
+		NL_SET_ERR_MSG(extack, "Not a nexthop group");
+		return ERR_PTR(-EINVAL);
+	}
+
+	nhg = rtnl_dereference(nh->nh_grp);
+	if (!nhg->resilient) {
+		NL_SET_ERR_MSG(extack, "Nexthop group not of type resilient");
+		return ERR_PTR(-EINVAL);
+	}
+
+	return nh;
+}
+
+static int nh_valid_dump_nhid(struct nlattr *attr, u32 *nh_id_p,
+			      struct netlink_ext_ack *extack)
+{
+	u32 idx;
+
+	if (attr) {
+		idx = nla_get_u32(attr);
+		if (!idx) {
+			NL_SET_ERR_MSG(extack, "Invalid nexthop id");
+			return -EINVAL;
+		}
+		*nh_id_p = idx;
+	} else {
+		*nh_id_p = 0;
+	}
+
+	return 0;
+}
+
+static int nh_valid_dump_bucket_req(const struct nlmsghdr *nlh,
+				    struct nh_dump_filter *filter,
+				    struct netlink_callback *cb)
+{
+	struct nlattr *res_tb[ARRAY_SIZE(rtm_nh_res_bucket_policy_dump)];
+	struct nlattr *tb[ARRAY_SIZE(rtm_nh_policy_dump_bucket)];
+	int err;
+
+	err = nlmsg_parse(nlh, sizeof(struct nhmsg), tb,
+			  ARRAY_SIZE(rtm_nh_policy_dump_bucket) - 1,
+			  rtm_nh_policy_dump_bucket, NULL);
+	if (err < 0)
+		return err;
+
+	err = nh_valid_dump_nhid(tb[NHA_ID], &filter->nh_id, cb->extack);
+	if (err)
+		return err;
+
+	if (tb[NHA_RES_BUCKET]) {
+		size_t max = ARRAY_SIZE(rtm_nh_res_bucket_policy_dump) - 1;
+
+		err = nla_parse_nested(res_tb, max,
+				       tb[NHA_RES_BUCKET],
+				       rtm_nh_res_bucket_policy_dump,
+				       cb->extack);
+		if (err < 0)
+			return err;
+
+		err = nh_valid_dump_nhid(res_tb[NHA_RES_BUCKET_NH_ID],
+					 &filter->res_bucket_nh_id,
+					 cb->extack);
+		if (err)
+			return err;
+	}
+
+	return __nh_valid_dump_req(nlh, tb, filter, cb->extack);
+}
+
+struct rtm_dump_res_bucket_ctx {
+	struct rtm_dump_nh_ctx nh;
+	u16 bucket_index;
+	u32 done_nh_idx; /* 1 + the index of the last fully processed NH. */
+};
+
+static struct rtm_dump_res_bucket_ctx *
+rtm_dump_res_bucket_ctx(struct netlink_callback *cb)
+{
+	struct rtm_dump_res_bucket_ctx *ctx = (void *)cb->ctx;
+
+	BUILD_BUG_ON(sizeof(*ctx) > sizeof(cb->ctx));
+	return ctx;
+}
+
+struct rtm_dump_nexthop_bucket_data {
+	struct rtm_dump_res_bucket_ctx *ctx;
+	struct nh_dump_filter filter;
+};
+
+static int rtm_dump_nexthop_bucket_nh(struct sk_buff *skb,
+				      struct netlink_callback *cb,
+				      struct nexthop *nh,
+				      struct rtm_dump_nexthop_bucket_data *dd)
+{
+	u32 portid = NETLINK_CB(cb->skb).portid;
+	struct nhmsg *nhm = nlmsg_data(cb->nlh);
+	struct nh_res_table *res_table;
+	struct nh_group *nhg;
+	u16 bucket_index;
+	int err;
+
+	if (dd->ctx->nh.idx < dd->ctx->done_nh_idx)
+		return 0;
+
+	nhg = rtnl_dereference(nh->nh_grp);
+	res_table = rtnl_dereference(nhg->res_table);
+	for (bucket_index = dd->ctx->bucket_index;
+	     bucket_index < res_table->num_nh_buckets;
+	     bucket_index++) {
+		struct nh_res_bucket *bucket;
+		struct nh_grp_entry *nhge;
+
+		bucket = &res_table->nh_buckets[bucket_index];
+		nhge = rtnl_dereference(bucket->nh_entry);
+		if (nh_dump_filtered(nhge->nh, &dd->filter, nhm->nh_family))
+			continue;
+
+		if (dd->filter.res_bucket_nh_id &&
+		    dd->filter.res_bucket_nh_id != nhge->nh->id)
+			continue;
+
+		err = nh_fill_res_bucket(skb, nh, bucket, bucket_index,
+					 RTM_NEWNEXTHOPBUCKET, portid,
+					 cb->nlh->nlmsg_seq, NLM_F_MULTI,
+					 cb->extack);
+		if (err < 0) {
+			if (likely(skb->len))
+				goto out;
+			goto out_err;
+		}
+	}
+
+	dd->ctx->done_nh_idx = dd->ctx->nh.idx + 1;
+	bucket_index = 0;
+
+out:
+	err = skb->len;
+out_err:
+	dd->ctx->bucket_index = bucket_index;
+	return err;
+}
+
+static int rtm_dump_nexthop_bucket_cb(struct sk_buff *skb,
+				      struct netlink_callback *cb,
+				      struct nexthop *nh, void *data)
+{
+	struct rtm_dump_nexthop_bucket_data *dd = data;
+	struct nh_group *nhg;
+
+	if (!nh->is_group)
+		return 0;
+
+	nhg = rtnl_dereference(nh->nh_grp);
+	if (!nhg->resilient)
+		return 0;
+
+	return rtm_dump_nexthop_bucket_nh(skb, cb, nh, dd);
+}
+
+/* rtnl */
+static int rtm_dump_nexthop_bucket(struct sk_buff *skb,
+				   struct netlink_callback *cb)
+{
+	struct rtm_dump_res_bucket_ctx *ctx = rtm_dump_res_bucket_ctx(cb);
+	struct rtm_dump_nexthop_bucket_data dd = { .ctx = ctx };
+	struct net *net = sock_net(skb->sk);
+	struct nexthop *nh;
+	int err;
+
+	err = nh_valid_dump_bucket_req(cb->nlh, &dd.filter, cb);
+	if (err)
+		return err;
+
+	if (dd.filter.nh_id) {
+		nh = nexthop_find_group_resilient(net, dd.filter.nh_id,
+						  cb->extack);
+		if (IS_ERR(nh))
+			return PTR_ERR(nh);
+		err = rtm_dump_nexthop_bucket_nh(skb, cb, nh, &dd);
+	} else {
+		struct rb_root *root = &net->nexthop.rb_root;
+
+		err = rtm_dump_walk_nexthops(skb, cb, root, &ctx->nh,
+					     &rtm_dump_nexthop_bucket_cb, &dd);
+	}
+
+	if (err < 0) {
+		if (likely(skb->len))
+			goto out;
+		goto out_err;
+	}
+
+out:
+	err = skb->len;
+out_err:
+	cb->seq = net->nexthop.seq;
+	nl_dump_check_consistent(cb, nlmsg_hdr(skb));
+	return err;
+}
+
 static void nexthop_sync_mtu(struct net_device *dev, u32 orig_mtu)
 {
 	unsigned int hash = nh_dev_hashfn(dev->ifindex);
@@ -3324,6 +3604,9 @@ static int __init nexthop_init(void)
 	rtnl_register(PF_INET6, RTM_NEWNEXTHOP, rtm_new_nexthop, NULL, 0);
 	rtnl_register(PF_INET6, RTM_GETNEXTHOP, NULL, rtm_dump_nexthop, 0);
 
+	rtnl_register(PF_UNSPEC, RTM_GETNEXTHOPBUCKET, NULL,
+		      rtm_dump_nexthop_bucket, 0);
+
 	return 0;
 }
 subsys_initcall(nexthop_init);
-- 
2.26.2

