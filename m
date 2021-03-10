Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58187334118
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 16:05:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233167AbhCJPEl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 10:04:41 -0500
Received: from mail-mw2nam10on2081.outbound.protection.outlook.com ([40.107.94.81]:42368
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232965AbhCJPEW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 10:04:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N1nrzNj8pCW3r1gjXCmu9+gMzy5Q5Sn3U3XMRlYPlMZY+407hAmTIihVRKxIAajZielNr4bJSUi7gnqPbMDXqlV1Ac7PJLyI2GcjBaHVoitOSP6EbJo6fQm/e/StPzdJ4DJsQl8n7mnEQO7j5DcCofGqE+Hi8TUPgmbMgGW2Hce1agnqME8gJQJ8sUP2SKm/PQsNOCogOsjDzaN+o+J5tdL0VM4rYxWZtjPaRaWo+u3AdU5CXAw559SsXmRHw8ZYjYzPWQROFo6dW+K8bm7z3E5kxE7sluumDjhvFqraRbyLtC29T5yBfYvQ/1MCq/hwj1vHtgj4MB6RkRAM0NB0Jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wm8Ybh0UilIXboV2ZsGDyug/u4bVsWnL8SzI6C7/iJg=;
 b=BUlctblOJTQ7mseSnfJQvdtT3gyNLU6J5LU1MuTPFCo7dyBL5rX3SWmiZV9vgsxiygkGBRDCRL5iBTlWvCKqINJVIzfGKl95nNs11aS+9+CPp2r5RpqyJ0VKWSnIx6yUVtecHMfuAmHkF0gRag07KYvb/pjW/JUUmVg3sV9SA1Hl4m5IZu7892dKxLlAcHQCQgWTunnYvnBC++WaCJ8StxEx9b98qameVd1pnuPX7q/6ukbq+ULpKWTyoIq5cPoBeZIfUH7+ndA8ADd5+16FsINppONSLjjaQeYl9e5Z2nvF3yPwBnqTyyDi6SPQHXvk+vz81rrQJfPp1tFhh02FYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wm8Ybh0UilIXboV2ZsGDyug/u4bVsWnL8SzI6C7/iJg=;
 b=gyDv53cdJrFDAwEfFTNP3oiWT4NzvID4XUI9aDuCcLrY8sHwYqaATZqsWgqY61x5LRUP8kA0+95gMx+aBimS6KLiuKjO5lZPHrrOuscO+0rVLFkQ8fyWPmvQjA8iqaok9t5ZXdEnX/rjvdJAqnunEt25/6DXfbyftSnPR90uIxh3aHgmulwPfokwBW3SgywunTx8lwB1SjV49TAWK+AP7GQdB7ytFR39xrM/1yr9TKRZJV88dQn32ZChmeNqSwB6OOeho4+/ema/IUYs5Fp1QDhfqe354G/uNvsKCuVj98Re56huArmyFiFgZGhMy2yXYqMPjAOqNdx6KuDYmIiAXQ==
Received: from BN9PR03CA0876.namprd03.prod.outlook.com (2603:10b6:408:13c::11)
 by BY5PR12MB3812.namprd12.prod.outlook.com (2603:10b6:a03:1a7::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Wed, 10 Mar
 2021 15:04:20 +0000
Received: from BN8NAM11FT041.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13c:cafe::77) by BN9PR03CA0876.outlook.office365.com
 (2603:10b6:408:13c::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend
 Transport; Wed, 10 Mar 2021 15:04:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT041.mail.protection.outlook.com (10.13.177.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Wed, 10 Mar 2021 15:04:19 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 10 Mar
 2021 15:04:16 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH net-next 10/14] nexthop: Add netlink handlers for resilient nexthop groups
Date:   Wed, 10 Mar 2021 16:03:01 +0100
Message-ID: <ab2c9b2de2d0454b38e81580fdc10866eb85aa9f.1615387786.git.petrm@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: acf49f38-85b7-454e-ee2b-08d8e3d5c7fa
X-MS-TrafficTypeDiagnostic: BY5PR12MB3812:
X-Microsoft-Antispam-PRVS: <BY5PR12MB3812D0403377D6B510B0657CD6919@BY5PR12MB3812.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2512;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PM0ktyJ2AUb+M19w49hGEKqA9pHXf8+saS94NMj2P4Vr4Y4rc03d8TLtzbyMvrbL/+YKDySuy1UQCZhSoipDRp7WM8UFZrIw8qVi1L+t7mQezzWR3rkBSCYMhHF8zIahBV+/6faM1Ft/XrH93NA9uGRZs2cuyZlhAcOSE/sP4hop0epiM9Srs4jlbx8jaexLktemgCAPHg63yTMMxQD6IgNp4ctTZIIHb3S507qgUSIil+bor1kgKAGLqqCbZiBOFip5Swa4sDdyo6iQEpc8gRxLjG3EePo52k+4idf4EbG+6A4d1BpgaJ7FSMCwu6mF8PGj8NmmVjDfXUsCEV8RHGAs5a+JbAqtAfKo5RgbnLvWpPZeWq/oCLf9VW8+P9en4VdA0UlnkTlvc0cgcGdsqwlKVz6iOt1E+FR/kZ9LXu3WoR2HsHRbXXu/Aduty50U/L7mkXtQw3jM74Qzw592tbBTfVJurVDKEFAAehu0HB+GoBzP/UGYBCSCfM13NEOKMeD+nCml3tEoiXgym6LH4DE22LtcCPzacunr4URMb1kJIvH+++QXxpJfjih/E1HIq+LFCa28+A/AWlBW9WOlDX/3AKbrcFW9TCPkoHdLt0OX51U/bZJdHb/ak69JtcFpElcU3XFARM8hDqc+h4w/FySa6OsXZkuUma2mXqvHt3c93wp/gwmdG3+O1qefB+K7
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(376002)(136003)(346002)(39860400002)(36840700001)(46966006)(70586007)(70206006)(54906003)(36860700001)(34020700004)(478600001)(336012)(16526019)(5660300002)(36906005)(426003)(8936002)(316002)(47076005)(107886003)(26005)(2906002)(7636003)(356005)(36756003)(82740400003)(2616005)(6666004)(8676002)(4326008)(6916009)(186003)(83380400001)(82310400003)(86362001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2021 15:04:19.3286
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: acf49f38-85b7-454e-ee2b-08d8e3d5c7fa
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT041.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3812
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement the netlink messages that allow creation and dumping of resilient
nexthop groups.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---

Notes:
    v1 (changes since RFC):
    - u32 -> u16 for bucket counts / indices

 net/ipv4/nexthop.c | 150 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 145 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 495b5e69ffcd..439bf3b7ced5 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -16,6 +16,9 @@
 #include <net/route.h>
 #include <net/sock.h>
 
+#define NH_RES_DEFAULT_IDLE_TIMER	(120 * HZ)
+#define NH_RES_DEFAULT_UNBALANCED_TIMER	0	/* No forced rebalancing. */
+
 static void remove_nexthop(struct net *net, struct nexthop *nh,
 			   struct nl_info *nlinfo);
 
@@ -32,6 +35,7 @@ static const struct nla_policy rtm_nh_policy_new[] = {
 	[NHA_ENCAP_TYPE]	= { .type = NLA_U16 },
 	[NHA_ENCAP]		= { .type = NLA_NESTED },
 	[NHA_FDB]		= { .type = NLA_FLAG },
+	[NHA_RES_GROUP]		= { .type = NLA_NESTED },
 };
 
 static const struct nla_policy rtm_nh_policy_get[] = {
@@ -45,6 +49,12 @@ static const struct nla_policy rtm_nh_policy_dump[] = {
 	[NHA_FDB]		= { .type = NLA_FLAG },
 };
 
+static const struct nla_policy rtm_nh_res_policy_new[] = {
+	[NHA_RES_GROUP_BUCKETS]			= { .type = NLA_U16 },
+	[NHA_RES_GROUP_IDLE_TIMER]		= { .type = NLA_U32 },
+	[NHA_RES_GROUP_UNBALANCED_TIMER]	= { .type = NLA_U32 },
+};
+
 static bool nexthop_notifiers_is_empty(struct net *net)
 {
 	return !net->nexthop.notifier_chain.head;
@@ -588,6 +598,41 @@ static void nh_res_time_set_deadline(unsigned long next_time,
 		*deadline = next_time;
 }
 
+static clock_t nh_res_table_unbalanced_time(struct nh_res_table *res_table)
+{
+	if (list_empty(&res_table->uw_nh_entries))
+		return 0;
+	return jiffies_delta_to_clock_t(jiffies - res_table->unbalanced_since);
+}
+
+static int nla_put_nh_group_res(struct sk_buff *skb, struct nh_group *nhg)
+{
+	struct nh_res_table *res_table = rtnl_dereference(nhg->res_table);
+	struct nlattr *nest;
+
+	nest = nla_nest_start(skb, NHA_RES_GROUP);
+	if (!nest)
+		return -EMSGSIZE;
+
+	if (nla_put_u16(skb, NHA_RES_GROUP_BUCKETS,
+			res_table->num_nh_buckets) ||
+	    nla_put_u32(skb, NHA_RES_GROUP_IDLE_TIMER,
+			jiffies_to_clock_t(res_table->idle_timer)) ||
+	    nla_put_u32(skb, NHA_RES_GROUP_UNBALANCED_TIMER,
+			jiffies_to_clock_t(res_table->unbalanced_timer)) ||
+	    nla_put_u64_64bit(skb, NHA_RES_GROUP_UNBALANCED_TIME,
+			      nh_res_table_unbalanced_time(res_table),
+			      NHA_RES_GROUP_PAD))
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
 static int nla_put_nh_group(struct sk_buff *skb, struct nh_group *nhg)
 {
 	struct nexthop_grp *p;
@@ -598,6 +643,8 @@ static int nla_put_nh_group(struct sk_buff *skb, struct nh_group *nhg)
 
 	if (nhg->mpath)
 		group_type = NEXTHOP_GRP_TYPE_MPATH;
+	else if (nhg->resilient)
+		group_type = NEXTHOP_GRP_TYPE_RES;
 
 	if (nla_put_u16(skb, NHA_GROUP_TYPE, group_type))
 		goto nla_put_failure;
@@ -613,6 +660,9 @@ static int nla_put_nh_group(struct sk_buff *skb, struct nh_group *nhg)
 		p += 1;
 	}
 
+	if (nhg->resilient && nla_put_nh_group_res(skb, nhg))
+		goto nla_put_failure;
+
 	return 0;
 
 nla_put_failure:
@@ -700,13 +750,26 @@ static int nh_fill_node(struct sk_buff *skb, struct nexthop *nh,
 	return -EMSGSIZE;
 }
 
+static size_t nh_nlmsg_size_grp_res(struct nh_group *nhg)
+{
+	return nla_total_size(0) +	/* NHA_RES_GROUP */
+		nla_total_size(2) +	/* NHA_RES_GROUP_BUCKETS */
+		nla_total_size(4) +	/* NHA_RES_GROUP_IDLE_TIMER */
+		nla_total_size(4) +	/* NHA_RES_GROUP_UNBALANCED_TIMER */
+		nla_total_size_64bit(8);/* NHA_RES_GROUP_UNBALANCED_TIME */
+}
+
 static size_t nh_nlmsg_size_grp(struct nexthop *nh)
 {
 	struct nh_group *nhg = rtnl_dereference(nh->nh_grp);
 	size_t sz = sizeof(struct nexthop_grp) * nhg->num_nh;
+	size_t tot = nla_total_size(sz) +
+		nla_total_size(2); /* NHA_GROUP_TYPE */
+
+	if (nhg->resilient)
+		tot += nh_nlmsg_size_grp_res(nhg);
 
-	return nla_total_size(sz) +
-	       nla_total_size(2);  /* NHA_GROUP_TYPE */
+	return tot;
 }
 
 static size_t nh_nlmsg_size_single(struct nexthop *nh)
@@ -876,7 +939,7 @@ static int nh_check_attr_fdb_group(struct nexthop *nh, u8 *nh_family,
 
 static int nh_check_attr_group(struct net *net,
 			       struct nlattr *tb[], size_t tb_size,
-			       struct netlink_ext_ack *extack)
+			       u16 nh_grp_type, struct netlink_ext_ack *extack)
 {
 	unsigned int len = nla_len(tb[NHA_GROUP]);
 	u8 nh_family = AF_UNSPEC;
@@ -937,8 +1000,14 @@ static int nh_check_attr_group(struct net *net,
 	for (i = NHA_GROUP_TYPE + 1; i < tb_size; ++i) {
 		if (!tb[i])
 			continue;
-		if (i == NHA_FDB)
+		switch (i) {
+		case NHA_FDB:
 			continue;
+		case NHA_RES_GROUP:
+			if (nh_grp_type == NEXTHOP_GRP_TYPE_RES)
+				continue;
+			break;
+		}
 		NL_SET_ERR_MSG(extack,
 			       "No other attributes can be set in nexthop groups");
 		return -EINVAL;
@@ -2475,6 +2544,70 @@ static struct nexthop *nexthop_add(struct net *net, struct nh_config *cfg,
 	return nh;
 }
 
+static int rtm_nh_get_timer(struct nlattr *attr, unsigned long fallback,
+			    unsigned long *timer_p, bool *has_p,
+			    struct netlink_ext_ack *extack)
+{
+	unsigned long timer;
+	u32 value;
+
+	if (!attr) {
+		*timer_p = fallback;
+		*has_p = false;
+		return 0;
+	}
+
+	value = nla_get_u32(attr);
+	timer = clock_t_to_jiffies(value);
+	if (timer == ~0UL) {
+		NL_SET_ERR_MSG(extack, "Timer value too large");
+		return -EINVAL;
+	}
+
+	*timer_p = timer;
+	*has_p = true;
+	return 0;
+}
+
+static int rtm_to_nh_config_grp_res(struct nlattr *res, struct nh_config *cfg,
+				    struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[ARRAY_SIZE(rtm_nh_res_policy_new)] = {};
+	int err;
+
+	if (res) {
+		err = nla_parse_nested(tb,
+				       ARRAY_SIZE(rtm_nh_res_policy_new) - 1,
+				       res, rtm_nh_res_policy_new, extack);
+		if (err < 0)
+			return err;
+	}
+
+	if (tb[NHA_RES_GROUP_BUCKETS]) {
+		cfg->nh_grp_res_num_buckets =
+			nla_get_u16(tb[NHA_RES_GROUP_BUCKETS]);
+		cfg->nh_grp_res_has_num_buckets = true;
+		if (!cfg->nh_grp_res_num_buckets) {
+			NL_SET_ERR_MSG(extack, "Number of buckets needs to be non-0");
+			return -EINVAL;
+		}
+	}
+
+	err = rtm_nh_get_timer(tb[NHA_RES_GROUP_IDLE_TIMER],
+			       NH_RES_DEFAULT_IDLE_TIMER,
+			       &cfg->nh_grp_res_idle_timer,
+			       &cfg->nh_grp_res_has_idle_timer,
+			       extack);
+	if (err)
+		return err;
+
+	return rtm_nh_get_timer(tb[NHA_RES_GROUP_UNBALANCED_TIMER],
+				NH_RES_DEFAULT_UNBALANCED_TIMER,
+				&cfg->nh_grp_res_unbalanced_timer,
+				&cfg->nh_grp_res_has_unbalanced_timer,
+				extack);
+}
+
 static int rtm_to_nh_config(struct net *net, struct sk_buff *skb,
 			    struct nlmsghdr *nlh, struct nh_config *cfg,
 			    struct netlink_ext_ack *extack)
@@ -2553,7 +2686,14 @@ static int rtm_to_nh_config(struct net *net, struct sk_buff *skb,
 			NL_SET_ERR_MSG(extack, "Invalid group type");
 			goto out;
 		}
-		err = nh_check_attr_group(net, tb, ARRAY_SIZE(tb), extack);
+		err = nh_check_attr_group(net, tb, ARRAY_SIZE(tb),
+					  cfg->nh_grp_type, extack);
+		if (err)
+			goto out;
+
+		if (cfg->nh_grp_type == NEXTHOP_GRP_TYPE_RES)
+			err = rtm_to_nh_config_grp_res(tb[NHA_RES_GROUP],
+						       cfg, extack);
 
 		/* no other attributes should be set */
 		goto out;
-- 
2.26.2

