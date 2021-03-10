Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8DC5334119
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 16:05:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233170AbhCJPEm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 10:04:42 -0500
Received: from mail-mw2nam08on2085.outbound.protection.outlook.com ([40.107.101.85]:32666
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232587AbhCJPEZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 10:04:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jCqij3TgWOz0qWNMlknIPDbxwbUrFo9sf/7iBzfooa09QScfrKidFQBywYBK2bnQp+T+vUwuBhdbhbygaj7jMbvcjuZ5yrWYb2Ty0RRgWccCyJo8OBkGZSV76JktK+freshmBAy7MKhKqEVKCgDuoHwxHvF/nELcQDyhLNBTags7LiURzMxpasR7XdhDiEAwU4tD/x4JO0ZSM47/ZYH0Yu32yVkKfKK9phdYdWJOu3VbHVXe5eV7ueB1cfDdO/xwEQ9SJpvPkmeEdmNllTvTj8DRLIaEMecUJNOOUG/6T1l2Cuj4kgSmTPeiZ8LNopzxP34dobsTks9x/3pIlyhasw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wxFq/2jSpb/brpZaXa3cthY1m2wpOAiayCOC+uEl+xk=;
 b=ZF1x/vnOYDjkT36lV1nsC5Mp3zn6PK6Od4n2AvF5Vf4RTJFIMfWVYU1l/vyqVId+3wBbFFiGyTGJN1TfpAUlfOzmMnRIb0c4dhG/z8XxqIsn1qZaw36LbvcLT0qRlz++9d2YtgU15v6A3W+d0GiS5rjbBo6BYhdvZcfmkVWtDFeNObMH5h2IQ9o4ug4YOtPsQso6+5w/7OPoxdNFHmcnERMSbnMSjPUEWOft6prkeq2PQckh8DhYdYGP0xWqy79R+hdhrsjbC5f81gvxiHWaFIPtyQh5ictdGiJxBSb+tHaQbwNpiPOoRnJQlYTBRb3HKqSgrQdvb91TY1MNHMSrSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wxFq/2jSpb/brpZaXa3cthY1m2wpOAiayCOC+uEl+xk=;
 b=hDPutfUY/xEI94t/bdLHo4kv69/LkBZGOUH5GzAEm7Hj8MqqSMDy8a1Rw6PueKbxLiiBraDe3MwvcLelyvTydnLjOQ8MjJke6hxSO4t/Xfc8ngRzoSerxfVrNxVeJb3R0Xr6Z6KAUr9g0VCqDsH9Icv3YA8Lk4rGqKUEjPubWzCO7usYuyNPjtHgQPSH++KbfsuhncWRPDQd4Oxvzl3Bw+pKjhGAD1Crhxtz//OObE+v+X2h5qHXCLoIskWA/WIOawqqu7uKFFK5384J44+YaB5gxu3GeNDGxnyuM9b5oFvJS5JK4y/sJSge0ge6HFPS7nA8eYcIKX+Vur80+kpZwA==
Received: from BN6PR1701CA0023.namprd17.prod.outlook.com
 (2603:10b6:405:15::33) by MW3PR12MB4347.namprd12.prod.outlook.com
 (2603:10b6:303:2e::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.19; Wed, 10 Mar
 2021 15:04:22 +0000
Received: from BN8NAM11FT056.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:15:cafe::86) by BN6PR1701CA0023.outlook.office365.com
 (2603:10b6:405:15::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend
 Transport; Wed, 10 Mar 2021 15:04:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT056.mail.protection.outlook.com (10.13.177.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Wed, 10 Mar 2021 15:04:22 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 10 Mar
 2021 15:04:19 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH net-next 11/14] nexthop: Add netlink handlers for bucket dump
Date:   Wed, 10 Mar 2021 16:03:02 +0100
Message-ID: <21f3a52cbe29cacc7aef1f4e559de64b6687ce91.1615387786.git.petrm@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: 03b17347-300d-49d8-d52c-08d8e3d5c9a2
X-MS-TrafficTypeDiagnostic: MW3PR12MB4347:
X-Microsoft-Antispam-PRVS: <MW3PR12MB434722A3ED3CB60396171248D6919@MW3PR12MB4347.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2089;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Cpw9MKinG0oaKoWlANFaGlaZWBlRymvAblyKE/dXFwYZog4Aon1OL1qyqyTITs52Fcxs8lbD44zByQM91mkXUsCJFu+6Z53W4NPqn3J+Pj6JPUHymW/AqEUEFLqDo1wan/aprVn9lZQb+vuTQdcDPwijUtOJSciTwseUMAsEyS9HTQP2/Dh0Z5PysXF/yhi7yFQHp0MRFDEhskEXJTivpcDHJQJUslaHzCUSSq1cu7P8AfqAbUmynuDIhZfsD+0Tiwuxfn5qMBVrkyKt74IObn70RF0zqvdF/YQ7FxUAEnaMfz3dN4WWBNY+AvMdMpiINNQZ9g5YOgc3e97/zU799WL8P8rtEycRbXZLpaQFFpE6Rq/DLQat6EYNrDTysTcpFQMxlVh9+GcbGH5/8zhmQUxOUJ/JEmXTpIS0Or0Ov8LTkj++44pUdmaJXgruoUBZ/y5QsJOsjBjNgLtosTYSEiFV1qmALTtUFKzlKOMExYX/atZ0N/r0uK3WSOtuzwQhsUeGkolZ/3zLem+WEYSCMZwcMV0IYP+jA7In9EPoBNI2NYNXCcoUc84VjHz7bxSrRDxyKsieR/nFd1TUpqMQZ/JhS/QVS5cAfFld0DuY9zjTu+/SVb0NXxOC6KhgwJG6a4gIyOEBG/pj2gHx+Zhy5IOjlmgLmB6xYdkxgC7icQN6Nc+NwEyC9BSDSgvCLtXe
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(376002)(346002)(136003)(39860400002)(36840700001)(46966006)(70586007)(82740400003)(5660300002)(2906002)(70206006)(336012)(8936002)(54906003)(426003)(26005)(36906005)(6916009)(478600001)(316002)(16526019)(186003)(8676002)(86362001)(107886003)(47076005)(36860700001)(83380400001)(4326008)(36756003)(7636003)(356005)(2616005)(34020700004)(6666004)(82310400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2021 15:04:22.1157
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 03b17347-300d-49d8-d52c-08d8e3d5c9a2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT056.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4347
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a dump handler for resilient next hop buckets. When next-hop group ID
is given, it walks buckets of that group, otherwise it walks buckets of all
groups. It then dumps the buckets whose next hops match the given filtering
criteria.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
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

