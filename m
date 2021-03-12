Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A04B33949F
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 18:25:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbhCLRYh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 12:24:37 -0500
Received: from mail-bn7nam10on2041.outbound.protection.outlook.com ([40.107.92.41]:23329
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232553AbhCLRYP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 12:24:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dSpah8scX6HO3oIYWzpO9JP6sN43g/TlrmVpmjCLEbGUVlNiyeos70fJgw2B+42OCEJrh1IqjWUPkzGlDDbFdLhPOBO+MrqC7jTikFItXSgAtxHMp5/WV/J6KEhh80djnbxIiKERrylavua70TS22mX4a/XS3x/NObCcHb+13s0vxu+qnU/BjeaIGeWhlEmeI0Ss+opAXuQW+AYGIdoqKiUHHMay0rGPq/ebHWxJFi5IZLVyNwI3QNEgY4xR+ixMd2xYDfS+iuKJ/vwYuW3sO90IdXT331aYPsMB+zoXObpQ+P4DJ0p7gw/r//fGeZHyjJc8f9u4qrLjsw3izE2MmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qfLTnOVFGTg8SGQKogtpYedrhEsufuokgsnAKpXT6iE=;
 b=B0qvkDMHZM7ffymcTV9lgTcS6PgkyLhy1VIvjl02Se3kr5AEYWG3lsEfmU1HgmvswtGjqobqrHzzUV0EYCYmtGrDQ7W37A4QfqRGP6KKntXnL8+6KEacIktKp5KTNNJLjF4qZwYPRc4M17Gk7+uKcksQnCTrroQcyV4BKMURxxzBELSDanvbvUPwo+cMCtLn8ZBvDDq9uSnx5Xx95Ga5mcZo+95JuB44Ey9owIyzqxgXOTUeD/5TDZhin9/Try3DhupjK6CaN+Pf7yiNb2UYTreBoMa4u4IwaixQ0PcK8PdymwqDUqaiFvaCp7i8M0Dy0j/pPH2pn/6XrcZDPVzTtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qfLTnOVFGTg8SGQKogtpYedrhEsufuokgsnAKpXT6iE=;
 b=n5PVaEXva0xB//ARURVcSm59c86yO3f6ZFpvnvXU/M1qth26YQnZyAkmZhPoMj1FMOtrw9xoieBEbfXVVw6yyo6+dKVmjxpf+hqKkhmiD46suF0UTQr7bXnvdqiNYqkd+5cXmHkYzFd9j4i4bkNEbRAdlvYqcX4TLjmpQtKyNEpjucK4y1bwxCLcenBBWLU0zeKPorZyd2vWgUMFJ1tVIUGWljrhVg1gW1X4gpfYtQXOEl9GQfPxTri3oAbSmUWY6tXYbUMILQaEsw6NDKd68J5VS/DJaDpiSc4msuUumKG1TAN4xj7ZGBb45dQo8Z/faZCa3ZCEQImmFkd8zcE0xQ==
Received: from MW4PR03CA0007.namprd03.prod.outlook.com (2603:10b6:303:8f::12)
 by SN6PR12MB4717.namprd12.prod.outlook.com (2603:10b6:805:e2::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Fri, 12 Mar
 2021 17:24:09 +0000
Received: from CO1NAM11FT003.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8f:cafe::fd) by MW4PR03CA0007.outlook.office365.com
 (2603:10b6:303:8f::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend
 Transport; Fri, 12 Mar 2021 17:24:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT003.mail.protection.outlook.com (10.13.175.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Fri, 12 Mar 2021 17:24:08 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 12 Mar
 2021 17:24:05 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>, <dsahern@gmail.com>,
        <stephen@networkplumber.org>
CC:     Ido Schimmel <idosch@nvidia.com>, Petr Machata <me@pmachata.org>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH iproute2-next 1/6] nexthop: Synchronize uAPI files
Date:   Fri, 12 Mar 2021 18:23:04 +0100
Message-ID: <5d05fcf97867f9dbf096f5849708ba645e0f96a9.1615568866.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1615568866.git.petrm@nvidia.com>
References: <cover.1615568866.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 21e672a0-4b87-4a0d-dfc4-08d8e57ba53a
X-MS-TrafficTypeDiagnostic: SN6PR12MB4717:
X-Microsoft-Antispam-PRVS: <SN6PR12MB4717365A8295014829402E2FD66F9@SN6PR12MB4717.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q5+sLUHCX5CeYmrshB1g8RgNTc26KIdosM25IFS5uSaY571plDLeA0Xp5+BUajVveAjJovvmBFUTDOqIlV4bbYk31M16iOOAOhUNsLlbxlri6n4nNHa4wpy2c2nIP43mYURiusYiiv/YMe/ku29Fb3zNaBQDwGpuW353UGBptNOTPy0KzPSSi1DtdYVAsapPugbXVcmEYM1JtTCr4D9fIYBRkgpH4Jgz1auwGJ7p5CI0kwV8Cq/HBge8aiyoHzo9VbNC9FfdtmKKzAAmyJCYoffDMA2CRUAgrcx7GMAj7arLCd8brXVKm3cp00ektvzHgnaUgjG6K967KNo1/4VboxwR/3uqB+3lBxb20ZLspTbiRmOQmrS3XDy5bxnILUTsfkx/X8ASzLVi84Ltp4XOtnxyXbMvaLpPSeZuZvIEFmGlf4snbb8xqwHn5KbsaSSuhH6MPntO8nHvk8dG9sfW2DO/nySaqXuqiR0vIbV4yAh3T5uncJKywbTKqRVBFkq2yVOUnpbyIimfTwnk9WxpNsR6mZvLb00i40HO4z6BivQEZsikPqaEZMQivRehSBUy0i9B39/yQ87uXUccfK5/y1VsqYcf5929cuaiw4k7jnm+EyUgfe+dOt2+09BjQP2uv2Yo9NxYqIqPGq91q6D8Bk1cimXw17oPaYNriDs/991is6Hp99gOaUnV/2s4sV1U
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(39860400002)(396003)(46966006)(36840700001)(34020700004)(36860700001)(82310400003)(356005)(36756003)(7636003)(83380400001)(82740400003)(70206006)(70586007)(86362001)(47076005)(5660300002)(36906005)(478600001)(16526019)(54906003)(8676002)(107886003)(316002)(2906002)(8936002)(2616005)(426003)(4326008)(110136005)(336012)(186003)(26005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2021 17:24:08.7652
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 21e672a0-4b87-4a0d-dfc4-08d8e57ba53a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT003.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB4717
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <me@pmachata.org>

From: Ido Schimmel <idosch@nvidia.com>

Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 include/uapi/linux/nexthop.h   | 47 +++++++++++++++++++++++++++++++++-
 include/uapi/linux/rtnetlink.h |  7 +++++
 2 files changed, 53 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/nexthop.h b/include/uapi/linux/nexthop.h
index b0a5613905ef..37b14b4ea6c4 100644
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
index b34b9add5f65..f62cccc17651 100644
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
-- 
2.26.2

