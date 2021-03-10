Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF1A334112
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 16:05:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233099AbhCJPEg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 10:04:36 -0500
Received: from mail-co1nam11on2050.outbound.protection.outlook.com ([40.107.220.50]:37109
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232284AbhCJPEH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 10:04:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JAr0kG/qGOElufKGJeu5vMuzteiFTbjAlsR9FjubO7DBRj48pbmb3sRz16cMDMr5s87jv6gdLy6m5BtV2xrJ+F42eu3rMcicgOkrwvkrmRW9KZ7d0poxkHL8/BznBd+/Pz7oufg4cYv1dY90dw9iO3dw4QrU/Gp5xRP/OTxfjxr6MSzKyxGk27LgHQRX5I0rd7HGXfM72TaJfTTXrTX37YpiftRI12nKh1wFXjpHn9j1ymAWQe7EXQyZPKfvKXlAdOy1FfhIdyNnJcZQAlFYQJo4li1ngRyqzqG1Vl/uYYZanPGqvf+1WaEgZhAOtvaenhoUB8alhLkTUNNLEf5BRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xGJF4RreBZcDqdKCGN92rBxFlSTmDHfrrPP0AsrhtyU=;
 b=JX+ZsA98ckUbQ8+AieUetSEY6qW0yl7N8LLPHnniLJhYFJOfv6QVmKLuCAqgaU1KP9/W1uKv15reathHFq9590T+heDVRilONCOlPv7CdIpFMRjdTdhXntgWTpolnXAQeJb4AgKichi9s9F9SkddFeebmvLfLgmlNDizHMPWIdk6oXfYTwPPFyp6FMUKPYPj0dUZMWyHDSLTg6d6f2kPvFJDDeo5zpSBU4ANvEUVkELoBlqFnDoMHau3D5PrH0HCFrpu/18C1aW25C0UbCptpmk7oIl1zjKV+RyemLWRHfLphj+X3mVXW5rcB9UHQSP5VTkpjl94FjIdNAfnLaWz8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xGJF4RreBZcDqdKCGN92rBxFlSTmDHfrrPP0AsrhtyU=;
 b=e8wECYFZAvZvzKudCBV6qoUAg4cc2wFuAF3nUi5oGuAO7PwlHpJSB8gFqex28VMfXMf9RjWZd0dKnbT9soZWLSFfCv/PU+vBkAXFgquovDe/GOKK+TUIIVsFxG+Tgb/Hxys5ZnIw4UYnto7+o5XNs6XwBsFMH8leUkefi2hLK7QQwgD1HFNQSxR945hH7uBxpaWmaY+55O6kfSCmuVBAheK//T5l46JZKpZOO8sqofCJWkZnQWfFfxB7zLhnusWn1C/jShAn0m1NGB1MTsN9xaL1pSiNgJpv+1UQma4AZFo7CQbsn+UG18qUGY4/pSmWvMtMc/krz2PsJkhzm6Xsug==
Received: from DM5PR06CA0086.namprd06.prod.outlook.com (2603:10b6:3:4::24) by
 SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3890.20; Wed, 10 Mar 2021 15:04:03 +0000
Received: from DM6NAM11FT052.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:4:cafe::a0) by DM5PR06CA0086.outlook.office365.com
 (2603:10b6:3:4::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend
 Transport; Wed, 10 Mar 2021 15:04:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT052.mail.protection.outlook.com (10.13.172.111) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3912.17 via Frontend Transport; Wed, 10 Mar 2021 15:04:02 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 10 Mar
 2021 15:03:59 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH net-next 04/14] nexthop: Add netlink defines and enumerators for resilient NH groups
Date:   Wed, 10 Mar 2021 16:02:55 +0100
Message-ID: <674ece8e7d2fcdad3538d34e1db641e0b616cfae.1615387786.git.petrm@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: cbfda048-1fa8-4215-6079-08d8e3d5bdb1
X-MS-TrafficTypeDiagnostic: SN6PR12MB2718:
X-Microsoft-Antispam-PRVS: <SN6PR12MB271837A5583400B8FF07B059D6919@SN6PR12MB2718.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TB6Gq0G5dt6xpr+G6TvxsyYIWbRWgyREdR8mgugmRGgFTLjSMO+61sgbcUCC5rVeMqQYpjeX8KzVaVFjJEKqDHOfghpUSX90N1JtUgUOCN2PBlpRqsG56J7TIcUvqFXQX75OTZRlhSd/VevlhZ56/KnN4VV1nMMWJB18FG7O+UxiwYgg7OuwgJdnIGd7X0K1/p0fUx0fYfGYkTR5DDn54AB1F5Cb01RyzRgslWSspwdGbBkpzqppnQ/mLiFftQwiJbkSqLNN/GhiAsBackNMEPguX8VqQ0At9XQIRQbCMgcHV6Ai3UkaAiUlVIF0kiSYl63vhvafc7EfOK3a5v+LnHqwUPkLGGB5S1v/fyC+L1yP5BYaUZZAnH62oKvqlz6HyrF6EI/XtRU42kNCVc1VTWVpsjWuV0blrWt8WmtG7jPIE8/8I3NX5gAcgHtl5xrdfqLC9PLXUmoiLGdRylJtpa1S6C9L6VuGQA+QpsKxU4xawlamRZX8cqQ93BDEL/IYTFuU79JJyXFDdwhEhawamHm8Ue9sRg7eqQIEW/TKSUyysioHVkoQ/aW1o+rIoAT6Y7AbabDQX4o3FF+MPcKM8nyfd1KNhNN0ecXZncv2Qp5II0/A0c/hLv0nAOiQLfl5NTR1AvgNCDxTd7SVGb6/5uUnOsR5nbMk6R7Ktp6tIkndAmgkyEdqfBGATtlm6iQz
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(396003)(346002)(376002)(39860400002)(46966006)(36840700001)(426003)(8936002)(26005)(8676002)(86362001)(34020700004)(5660300002)(36860700001)(82310400003)(70586007)(70206006)(107886003)(47076005)(4326008)(2616005)(186003)(36906005)(316002)(54906003)(16526019)(82740400003)(6916009)(478600001)(7636003)(83380400001)(336012)(2906002)(36756003)(6666004)(356005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2021 15:04:02.1973
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cbfda048-1fa8-4215-6079-08d8e3d5bdb1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT052.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2718
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

- RTM_NEWNEXTHOP et.al. that handle resilient groups will have a new nested
  attribute, NHA_RES_GROUP, whose elements are attributes NHA_RES_GROUP_*.

- RTM_NEWNEXTHOPBUCKET et.al. is a suite of new messages that will
  currently serve only for dumping of individual buckets of resilient next
  hop groups. For nexthop group buckets, these messages will carry a nested
  attribute NHA_RES_BUCKET, whose elements are attributes NHA_RES_BUCKET_*.

  There are several reasons why a new suite of messages is created for
  nexthop buckets instead of overloading the information on the existing
  RTM_{NEW,DEL,GET}NEXTHOP messages.

  First, a nexthop group can contain a large number of nexthop buckets (4k
  is not unheard of). This imposes limits on the amount of information that
  can be encoded for each nexthop bucket given a netlink message is limited
  to 64k bytes.

  Second, while RTM_NEWNEXTHOPBUCKET is only used for notifications at
  this point, in the future it can be extended to provide user space with
  control over nexthop buckets configuration.

- The new group type is NEXTHOP_GRP_TYPE_RES. Note that nexthop code is
  adjusted to bounce groups with that type for now.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---

Notes:
    v1 (changes since RFC):
    - u32 -> u16 for bucket counts / indices

 include/uapi/linux/nexthop.h   | 43 ++++++++++++++++++++++++++++++++++
 include/uapi/linux/rtnetlink.h |  7 ++++++
 net/ipv4/nexthop.c             |  2 ++
 security/selinux/nlmsgtab.c    |  5 +++-
 4 files changed, 56 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/nexthop.h b/include/uapi/linux/nexthop.h
index 2d4a1e784cf0..8efebf3cb9c7 100644
--- a/include/uapi/linux/nexthop.h
+++ b/include/uapi/linux/nexthop.h
@@ -22,6 +22,7 @@ struct nexthop_grp {
 
 enum {
 	NEXTHOP_GRP_TYPE_MPATH,  /* default type if not specified */
+	NEXTHOP_GRP_TYPE_RES,    /* resilient nexthop group */
 	__NEXTHOP_GRP_TYPE_MAX,
 };
 
@@ -52,8 +53,50 @@ enum {
 	NHA_FDB,	/* flag; nexthop belongs to a bridge fdb */
 	/* if NHA_FDB is added, OIF, BLACKHOLE, ENCAP cannot be set */
 
+	/* nested; resilient nexthop group attributes */
+	NHA_RES_GROUP,
+	/* nested; nexthop bucket attributes */
+	NHA_RES_BUCKET,
+
 	__NHA_MAX,
 };
 
 #define NHA_MAX	(__NHA_MAX - 1)
+
+enum {
+	NHA_RES_GROUP_UNSPEC,
+	/* Pad attribute for 64-bit alignment. */
+	NHA_RES_GROUP_PAD = NHA_RES_GROUP_UNSPEC,
+
+	/* u16; number of nexthop buckets in a resilient nexthop group */
+	NHA_RES_GROUP_BUCKETS,
+	/* clock_t as u32; nexthop bucket idle timer (per-group) */
+	NHA_RES_GROUP_IDLE_TIMER,
+	/* clock_t as u32; nexthop unbalanced timer */
+	NHA_RES_GROUP_UNBALANCED_TIMER,
+	/* clock_t as u64; nexthop unbalanced time */
+	NHA_RES_GROUP_UNBALANCED_TIME,
+
+	__NHA_RES_GROUP_MAX,
+};
+
+#define NHA_RES_GROUP_MAX	(__NHA_RES_GROUP_MAX - 1)
+
+enum {
+	NHA_RES_BUCKET_UNSPEC,
+	/* Pad attribute for 64-bit alignment. */
+	NHA_RES_BUCKET_PAD = NHA_RES_BUCKET_UNSPEC,
+
+	/* u16; nexthop bucket index */
+	NHA_RES_BUCKET_INDEX,
+	/* clock_t as u64; nexthop bucket idle time */
+	NHA_RES_BUCKET_IDLE_TIME,
+	/* u32; nexthop id assigned to the nexthop bucket */
+	NHA_RES_BUCKET_NH_ID,
+
+	__NHA_RES_BUCKET_MAX,
+};
+
+#define NHA_RES_BUCKET_MAX	(__NHA_RES_BUCKET_MAX - 1)
+
 #endif
diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.h
index 91e4ca064d61..d35953bc7d53 100644
--- a/include/uapi/linux/rtnetlink.h
+++ b/include/uapi/linux/rtnetlink.h
@@ -178,6 +178,13 @@ enum {
 	RTM_GETVLAN,
 #define RTM_GETVLAN	RTM_GETVLAN
 
+	RTM_NEWNEXTHOPBUCKET = 116,
+#define RTM_NEWNEXTHOPBUCKET	RTM_NEWNEXTHOPBUCKET
+	RTM_DELNEXTHOPBUCKET,
+#define RTM_DELNEXTHOPBUCKET	RTM_DELNEXTHOPBUCKET
+	RTM_GETNEXTHOPBUCKET,
+#define RTM_GETNEXTHOPBUCKET	RTM_GETNEXTHOPBUCKET
+
 	__RTM_MAX,
 #define RTM_MAX		(((__RTM_MAX + 3) & ~3) - 1)
 };
diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 56c54d0fbacc..7a94591da856 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -1492,6 +1492,8 @@ static struct nexthop *nexthop_create_group(struct net *net,
 	if (cfg->nh_grp_type == NEXTHOP_GRP_TYPE_MPATH) {
 		nhg->mpath = 1;
 		nhg->is_multipath = true;
+	} else if (cfg->nh_grp_type == NEXTHOP_GRP_TYPE_RES) {
+		goto out_no_nh;
 	}
 
 	WARN_ON_ONCE(nhg->mpath != 1);
diff --git a/security/selinux/nlmsgtab.c b/security/selinux/nlmsgtab.c
index b69231918686..d59276f48d4f 100644
--- a/security/selinux/nlmsgtab.c
+++ b/security/selinux/nlmsgtab.c
@@ -88,6 +88,9 @@ static const struct nlmsg_perm nlmsg_route_perms[] =
 	{ RTM_NEWVLAN,		NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
 	{ RTM_DELVLAN,		NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
 	{ RTM_GETVLAN,		NETLINK_ROUTE_SOCKET__NLMSG_READ  },
+	{ RTM_NEWNEXTHOPBUCKET,	NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
+	{ RTM_DELNEXTHOPBUCKET,	NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
+	{ RTM_GETNEXTHOPBUCKET,	NETLINK_ROUTE_SOCKET__NLMSG_READ  },
 };
 
 static const struct nlmsg_perm nlmsg_tcpdiag_perms[] =
@@ -171,7 +174,7 @@ int selinux_nlmsg_lookup(u16 sclass, u16 nlmsg_type, u32 *perm)
 		 * structures at the top of this file with the new mappings
 		 * before updating the BUILD_BUG_ON() macro!
 		 */
-		BUILD_BUG_ON(RTM_MAX != (RTM_NEWVLAN + 3));
+		BUILD_BUG_ON(RTM_MAX != (RTM_NEWNEXTHOPBUCKET + 3));
 		err = nlmsg_perm(nlmsg_type, perm, nlmsg_route_perms,
 				 sizeof(nlmsg_route_perms));
 		break;
-- 
2.26.2

