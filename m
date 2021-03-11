Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFF90337BAA
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 19:05:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbhCKSEj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 13:04:39 -0500
Received: from mail-mw2nam12on2040.outbound.protection.outlook.com ([40.107.244.40]:34785
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229887AbhCKSEJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 13:04:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eNaFsmOsABsXkqr2JK9JJs8taceP/JvKvS4xmYNTEs9GrI3cfgoh+bnGZpsZKgSieb07MkeRfp3opIlXk+TRPrzj/tbFNVz1vctW7Jkrn/d+oVBYcOc1hiZKm9wq4ViwfLRhbnWzuEP5rLW0LxrFGlKD6vjJNvz968pioMWkBHdw5vQ4yrpD4coEpF1W43gINZscclt30p/9syOUyM1ax1NohMrdmdBl4AA1Ftub/U0N13dBmrDOWYn+fiKchqZ51aeb29R/oOzaiNBCY+OE43CDxMjyvSCAe1meDjeJqh3ChLPuweT0bO/dgGfHQ96Ep77hVo4WjtnFwVzB4J3xlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IgiJoOC+hcOwF5f1OH8YEPGLoduTP1S0FhQdB0tHBF4=;
 b=SmWfdh0ImHCQilHbG/x67UVlzxCJfNIwfZRFIWqg2ScHve+JoUym7ec/y9zHkbCgveTd81Nl6BkjSbsV3CxOLv5sPHqWVIJLuwcDu8TDHX9wI97CwwfzB7LlfZX8TFBB0jUov6zTwrAIl9AAFBK5PCyHtHW7Rz1KqFIO3zFJjhR3+Vv1U7fpZz65ZLpQwVIapP4exLkn7fOxB6LEr19Q8ZRjBDEwGEc9eclCZTgZ3dFKlJbiFhSO1bOyCTw6kmzLIKqI0+L72f8qopUZXLdezywh5Uz9J5zv3MxDBx/numQhrw6v0iLgh7xSoUeBbqBHK6Z+otbcfOY8upFueZS/Cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IgiJoOC+hcOwF5f1OH8YEPGLoduTP1S0FhQdB0tHBF4=;
 b=t9A9jVaGb/kL3AKl2boenZB6FUI3zEXa5Is4g45usqO7+etHyWg8PNMUnxrWlmSNsMXqQNswxdvoIsovLi2zoURZT69CM/1FGOUex7y2PbzNEuUBgq5hxyL7jDvPwsLd4Yw/l3xHoT3sBzf2eQ08K7DBD3Gy9pfX01VGoz5l9VsSGslX/rx+q6BfpmhmqvZMWN5MYQd0UBHzs9Gc2duEjk16U+XOvbqG316OYDw31aUzXbUlqKT7rx0FTEuPltSDJ0qJ0ynwTuohG3Ugghs4Q65ywY8iuxtIujEtgVdy11LFCRp78VZ/vPvPrKhfVCvfNt1ZMHqKpqVjMst7wBUwKg==
Received: from BN0PR03CA0025.namprd03.prod.outlook.com (2603:10b6:408:e6::30)
 by BY5PR12MB4002.namprd12.prod.outlook.com (2603:10b6:a03:1ad::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Thu, 11 Mar
 2021 18:04:07 +0000
Received: from BN8NAM11FT051.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e6:cafe::f5) by BN0PR03CA0025.outlook.office365.com
 (2603:10b6:408:e6::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend
 Transport; Thu, 11 Mar 2021 18:04:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT051.mail.protection.outlook.com (10.13.177.66) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Thu, 11 Mar 2021 18:04:06 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Mar
 2021 18:04:03 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH net-next v2 04/14] nexthop: Add netlink defines and enumerators for resilient NH groups
Date:   Thu, 11 Mar 2021 19:03:15 +0100
Message-ID: <ecf407100dfda6f8943b8d8e71860085803d730e.1615485052.git.petrm@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: 02b81a72-22f7-4937-0789-08d8e4b81028
X-MS-TrafficTypeDiagnostic: BY5PR12MB4002:
X-Microsoft-Antispam-PRVS: <BY5PR12MB4002B286591FC1D7144409CAD6909@BY5PR12MB4002.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sGGWQXsTdQ5jADSJJBsgEeHb4OowlimhBjrt9cdxnmWbl2GfsPCxmnZIF+dSVgHtecVdxCHOKCjEzEciXuZb0BAXpUHWneO5/BM7vvrwPCvKaNsYpzwd5igxswSo/XhypTTPHQSJqfBOjgFtTx2WLbtNbVzx4OfDesphf2XsXdTKV8uIlrERYyL6Ho0XK/eXc9DoyjIHkLHoydQYq1saHaSeOeFb4Jtwo+EojyqsORGf/kPV8vvvXpetaIhbeR4d+rpo8Zld9rWY19g7XjJMTMyxU9zj2d9JGfCqHMK0dQBci4OR7M14zg76LzZxQp2sUy9fI9b4hgBQTT0o0F5+RkCSBkOircgttEjp/J2LqKRJGaG2LDPtRQTpTwNjuTu7Ptq1nI0ezfNOQQYBMapdH5c6+sUmwlTACPRGETnayQx+SQcbKEBxFByWSnnGxXWuikmEa4wQWa4+EVfuzYxt3/8GiReQeSd8MMBRhd3HgMCDUfcMnHQcAh9gWsmbYxBk7pqIpS6woNmhDgGBRFsHwGLYzZR9QxFsrBJssS+5sVUBcnnoXxIIMFcvXOG4B0OKEubY22sZ4YvmiVvYVdproCsVfIEEcJWLDV+Dt887Ep5tfcKE15okaoqurOW91IJITTzM/TG3BrWb1GPLFZR5A1cdE5dTHwsDYNxUnhRVZ4Z5elS/g7FeXsbwJ/vThLX8
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(136003)(39860400002)(376002)(346002)(36840700001)(46966006)(186003)(426003)(16526019)(6916009)(478600001)(36756003)(47076005)(82740400003)(5660300002)(336012)(82310400003)(36860700001)(7636003)(356005)(54906003)(70206006)(26005)(316002)(70586007)(8936002)(107886003)(8676002)(4326008)(83380400001)(2616005)(2906002)(6666004)(34020700004)(86362001)(36906005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 18:04:06.7510
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 02b81a72-22f7-4937-0789-08d8e4b81028
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT051.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4002
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
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---

Notes:
    v2:
    - Comment at NEXTHOP_GRP_TYPE_MPATH that it's for the hash-threshold
      groups.
    
    v1 (changes since RFC):
    - u32 -> u16 for bucket counts / indices

 include/uapi/linux/nexthop.h   | 47 +++++++++++++++++++++++++++++++++-
 include/uapi/linux/rtnetlink.h |  7 +++++
 net/ipv4/nexthop.c             |  2 ++
 security/selinux/nlmsgtab.c    |  5 +++-
 4 files changed, 59 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/nexthop.h b/include/uapi/linux/nexthop.h
index 2d4a1e784cf0..d8ffa8c9ca78 100644
--- a/include/uapi/linux/nexthop.h
+++ b/include/uapi/linux/nexthop.h
@@ -21,7 +21,10 @@ struct nexthop_grp {
 };
 
 enum {
-	NEXTHOP_GRP_TYPE_MPATH,  /* default type if not specified */
+	NEXTHOP_GRP_TYPE_MPATH,  /* hash-threshold nexthop group
+				  * default type if not specified
+				  */
+	NEXTHOP_GRP_TYPE_RES,    /* resilient nexthop group */
 	__NEXTHOP_GRP_TYPE_MAX,
 };
 
@@ -52,8 +55,50 @@ enum {
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

