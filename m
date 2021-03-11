Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F058A337BB2
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 19:05:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230372AbhCKSEr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 13:04:47 -0500
Received: from mail-dm6nam10on2049.outbound.protection.outlook.com ([40.107.93.49]:31773
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230031AbhCKSEd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 13:04:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h4ev7hOO4esQAXgS3z6h4/wpNnxKDp8LFfH2fhESqhr3gVpDY7nnngn8NJOLlC8gqdWyfCHyJhjfWLcxagohhuWzPbfRZN4I5HLp4fbuUFqC6d1NxjnPV46DWoT4RCCeKhWNYcQWtZ+6c5eTAAJVn6a0AWAkYM5mgFqPOky53XYc//Pk7UHpLQqKwDPY+A2wDtlcVjqKMHzuDdz5X6SIOC1HuDaWT5kcr0m4ukGeoMpL6r298ddxAJHBan+vCXKwx4N64TYhhajJcb/tZ5BYCqNTkNkhI0ksipyKp2Ekih3np/DPnn1M9Jd2dhdorKkTZa5HH5Y81RhsqqJubwLBRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LTB4XOBcpDuVmE7KhNhMiGXsivMlwtsKJkLIc7Ic250=;
 b=W83HikA9WbKHJnnnAitErXsWOgjxT7Iik/j0VW4lJibRW7x2m2wqXHqjCDAIAZ/sJmRfABo3Cy0vEC5BvD+FV49Ye9IJHwjKmCRHyDmG4gbc9Laxg2SFI+5OiJ5oJugRdqwoCRdn54dWFb4Pke2B1czywBmBaq1nuJgp8j2orggR5eMoZc29f63cDGZOdf8FUSrlB6KTwWoy7UTnX+wP3tkxDrOtPuY3CeTNm57ufeJj6eJUVkNY3wytruyxcOKSpjmJw7+jEaiO95AgFNCG0XVAoDHRP/lMxaFlY0EWvzgFkYTQOohgCVbS/CSBcjLRPQasjo3VDHAsQZ8j6+8/aQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LTB4XOBcpDuVmE7KhNhMiGXsivMlwtsKJkLIc7Ic250=;
 b=kZx5VS3X0+QjOaj4MtT4dVVQhK4PkaUDdWc4rdkxiRLQ7fVrNMC6zQQfDRiEN3z6GQV8GIMFVpqw/W5z8ulEym/HaUgpfE9GZLE9FXvHA5A4Rhnk7cxZCY89Ghd1aRbH4RvE0g7RdO343+GEareigJGKvbRUTRd+cY4dnATwm+8skU/tTQ2+myySsl7ehEd89b19Buy1l5GOIkGKCqUxxjaeKZrIvvDXlYLJ83nqG9pPasehzqKc3JDoG4Bg66uYor+bAwZPQE13kC5IOzenOK+I+E2qRfL1gda9BpRKEINdt3SdelRdbqatG3k92njhSEGytwkPaM3GDg4JuS2gLQ==
Received: from BN9PR03CA0259.namprd03.prod.outlook.com (2603:10b6:408:ff::24)
 by MN2PR12MB2864.namprd12.prod.outlook.com (2603:10b6:208:ac::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.30; Thu, 11 Mar
 2021 18:04:30 +0000
Received: from BN8NAM11FT025.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ff:cafe::d6) by BN9PR03CA0259.outlook.office365.com
 (2603:10b6:408:ff::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend
 Transport; Thu, 11 Mar 2021 18:04:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT025.mail.protection.outlook.com (10.13.177.136) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Thu, 11 Mar 2021 18:04:30 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Mar
 2021 18:04:27 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH net-next v2 12/14] nexthop: Add netlink handlers for bucket get
Date:   Thu, 11 Mar 2021 19:03:23 +0100
Message-ID: <67fbb9b09d35a3ae196e0f9c096652e8ec7413fa.1615485052.git.petrm@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: 920d4404-37e2-4a93-b341-08d8e4b81e43
X-MS-TrafficTypeDiagnostic: MN2PR12MB2864:
X-Microsoft-Antispam-PRVS: <MN2PR12MB2864BA7A69E255679576A169D6909@MN2PR12MB2864.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ywTuVrpyGVptChdoXeqRYawJcjRLXv6hT2baZ0oc6OA1fuuP0ZWsvhAit+fin4G8LeRhOzs1nQtuBJYeOLORcN+JpwNA8wGOnVPngag0JRofJB6rRRaiWaL6osedXZtyWyz5ZVwoOREWco2eu2hzkC5k7wKD1ibxeW6qRKMvUKLjD2Y0v2vr134ZMuIiVKHjk3+r6fdklp/lNlzvH9Qbxo6abpAdoIAx8ybKKpuy7+qyrtHGSWmf7b1syxsFhtv5B/NC7ETy/PX+wkG1jjRuEe2j0tDbAEPT+miniPMnmEkoB1uwk0Qo/j0rwkD/D3jY4H0VJRcnWsjp57PIPGGw7/eNRKVcv+L5RF4AQdGDegRgzsLLxDSClNXp8DirqGy52iXLr7ynP3mMFit1E3/pKnhoRNUnojA4v7bcUn2djzn3KJDDMO7lhrEfhcxLqWfweQRpxpn3jzlqOEvDz0XmRXGaqkNey+3lp5CKdJs5G+8hVxSpi0+vfZXiQxRtV9zii9gZCOKCo+7WPZewTvtYC1BK+K6ojOrz/Yo/+YekKmIqy2rrrK9XxqqTsQdoX24L4AGEUB7e/euEAoo+QXDoufZCuFJFwkS9hRDqcmrAQg+O21lK33FmdMUwZj7SlUfIwV0T2HWDUIQXMcs3uRe3ctpf4dDkt4AYXPtu1n2kbviRy5+DzlgtrZWfXf/OEYaU
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(136003)(396003)(46966006)(36840700001)(316002)(478600001)(36906005)(54906003)(336012)(5660300002)(426003)(8676002)(107886003)(36860700001)(36756003)(356005)(7636003)(6916009)(86362001)(83380400001)(47076005)(82740400003)(2616005)(34020700004)(6666004)(70586007)(70206006)(16526019)(82310400003)(26005)(4326008)(8936002)(2906002)(186003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 18:04:30.3295
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 920d4404-37e2-4a93-b341-08d8e4b81e43
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT025.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB2864
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow getting (but not setting) individual buckets to inspect the next hop
mapped therein, idle time, and flags.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
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

