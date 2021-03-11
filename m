Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C6FC337BB0
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 19:05:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230341AbhCKSEp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 13:04:45 -0500
Received: from mail-eopbgr760088.outbound.protection.outlook.com ([40.107.76.88]:37186
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230027AbhCKSE3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 13:04:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CFC5T0Y4EW2TNLUVHZUhGhqxFKkwzr80UwXsI9mRdgs4kK+S6R+FbYDzeKtCy+2PhGEAupREHFbSrmMHiBak1YNK7PUUGGlfdpJHcnkH7jL61HZ0XYpiwcEdAtrJaKQJTiIqOcHOU2oc4SIahhBaZLzx9f8o3vwQRQ6hdv15BoU2RncExLOLKTGjYIEaRz85kGB7dint48uQp1nfzH/5G5N3zKuxi+R9ikLf2wzIpHvDajmLaLbKdpGeLQpY6ha/bPsTgBjWfUUskrqvBhdHMLoaTqNvaeKy4h+98DyTnUv4ZF51MkcVvNUJAGqbVGzR4bTSW+X2pKvw+rGUkTnavQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+iEIhWv93XkRMZcREWmCT9yJKfTxzZlo+la4U1XUcGM=;
 b=JpbVtERqqWicHM7lbqM7iKsQNmEdChSkfq++H2QKU66LQnaedrgW4x+QG/ifizHnKuraFtIEepZXOqUqh1wWwlsP78F9Pnr3yidTzP3hCiejXVs+KIQWWK21yQG/oWAo2t27MifExMMTtkopWrMOlFEM6QpjoZ+VCAvPPeibE98RFRILjc4b1dh5QL3llD9u43hHmr8rjJ5IM2Zq3RxFWpmG8eHC8lfyx8+GGds3em2rnM49hJldJCF+xDgH3dBBk2v7Yfr8CC/1Kk05j4Wr6ghAY/DgkhbwbEl5/yUYJefxkt6zHrIlZPtME4CVmOD/FVqh+OeMrZBP1EJUeBiXlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+iEIhWv93XkRMZcREWmCT9yJKfTxzZlo+la4U1XUcGM=;
 b=nqcCavm5NJRtI9XsysBTLdjgkKEY3w/h35Ke3n61sFonKG2qj41SFbriHAgIJhmFIZaSd8nrsXJ9vZ+FrqW5XQTo81Lu94YtNKIsfp6Q4upC0+Vykvn64ZXvm+ozNcEYF5wOVGJcPl+X3FIc2ZD0spmlImoxkX9eGFCrpBNR8rlNOKCfg8V3CbcxI7ctnN5km7MJbEcHw565UjShEMVjR1i79OUoaiJEyQHWJdHhZMHuD92HrJFGubPz5ITj5uLj5D3g8LWy9GCr7Wu1O8WGGCIa1an6P3ThLRmNeoO2iKFDlo1LQ9hC602a50E6CSW6uIDpCSZteT/3JzzkvNhyqg==
Received: from BN6PR13CA0046.namprd13.prod.outlook.com (2603:10b6:404:13e::32)
 by BY5PR12MB4966.namprd12.prod.outlook.com (2603:10b6:a03:1da::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Thu, 11 Mar
 2021 18:04:27 +0000
Received: from BN8NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:13e:cafe::d3) by BN6PR13CA0046.outlook.office365.com
 (2603:10b6:404:13e::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.11 via Frontend
 Transport; Thu, 11 Mar 2021 18:04:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT060.mail.protection.outlook.com (10.13.177.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Thu, 11 Mar 2021 18:04:26 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Mar
 2021 18:04:21 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH net-next v2 10/14] nexthop: Add netlink handlers for resilient nexthop groups
Date:   Thu, 11 Mar 2021 19:03:21 +0100
Message-ID: <85c90b43f567a62d40bdf58465e174d774e4be4f.1615485052.git.petrm@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: c70c380e-3ff5-4e8e-96b4-08d8e4b81c16
X-MS-TrafficTypeDiagnostic: BY5PR12MB4966:
X-Microsoft-Antispam-PRVS: <BY5PR12MB4966F87537BD4A7DFE138EA4D6909@BY5PR12MB4966.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2512;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: saj/Jmko2jhVTyc2hRKHsYK3bq3LXsbJbTG3C09rgAp09KgH8LXqAAknANp9zTJHdgTlVnhgrXYIKW1anDA/wOq7MVM84LUMW4+KK008KKX2QpY1P3PEhFq7apkkKgqcdINvlw6Lk4xqhYlwiX9reWFQIrr+2i/NtogewTgMW7sXcvdpz+3k6Pu9v8JfrHq9AA2IgCRz5XpRQH5sNKiICQOxLUpxn4j5w5KB13V6I47ji2RL2gPEqyzDoN8AjBPPPAO4++WCqVqWb/xBl1UsZUud2lp02PInFLqGjNRA+8cvawMH/dYLQSSFs6NFR2zYwYG+p4j2MqE9axRpm+Fg9x5925deKgh3wAyY5WNAi5FGctM2TVvCm3M8w3yFuhCjNKCVHJmW017cymdpEYmS8OdFlMnLgDaQd5ednJeSygBIgfBRM/CJlOqHVltTxKmx+YQR98ioLLVse/PKBfaLtMfwHAex8nnJMln4NHArFYbnY52QPRBXI7xJTgYFQihhI7RVrrwqu/S6jykJwQQOLTuHRYnCvuY5ukPpOOoDsECIEQzGdaAR6c+eTGDMpMTPQ5CZ+xZYwARrxjeiIQI5+JtPfp4e/UkrXLp32DElYbVEC16C7a8ymZvGrQM9qTo6AlJsb7gEe92odl/el2u3jnLydoX5y91DZVOqSVSODd7ETNjVIOwekPZ0+8MvQ8rd
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(396003)(346002)(136003)(39860400002)(46966006)(36840700001)(83380400001)(82740400003)(70586007)(36906005)(82310400003)(2616005)(36756003)(7636003)(70206006)(316002)(356005)(34020700004)(6916009)(36860700001)(478600001)(8936002)(16526019)(5660300002)(186003)(2906002)(426003)(54906003)(8676002)(336012)(26005)(107886003)(4326008)(86362001)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 18:04:26.7673
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c70c380e-3ff5-4e8e-96b4-08d8e4b81c16
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4966
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement the netlink messages that allow creation and dumping of resilient
nexthop groups.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
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

