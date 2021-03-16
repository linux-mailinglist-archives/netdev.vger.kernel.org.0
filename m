Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2C7733D1AF
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 11:21:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236638AbhCPKVa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 06:21:30 -0400
Received: from mail-dm6nam12on2080.outbound.protection.outlook.com ([40.107.243.80]:8463
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234782AbhCPKVL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 06:21:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QWrZ6UTCZgh+2462W4Zp0l7vY5jHzpx7Z9RbdVwAPXtZRwR6kPuY7ri9B04rM1NgB3VbfIQI7EktUoTCqtxVvLnC3FG5+IkjiaKH5jPk2CQhRy+ul9pfDGiUjWdL8gB23uPwFS91M8+d71h3st4IUZD5QnSnluFfkMmq6TPryrNmy4s2pFCtoBuSXEqfgnrzLfMbmtz5jv/1IRjiER9OLeOmaDm+zLML/Xs0hAF4KCGRyAoFpi9mXEYcWpHLgoukczoRMCmVg78PIl4oIj/BPYCGd6X1ot2f5gyIJZFQz+ADAXjK5zl92IbJd87TeYOltZ/ZuzRcpIptbQQypC1TeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=orKrKWhrp7NT6BGrZmtid8GI7yYCLyAvm8tDvJ7Moik=;
 b=f1ogemWqiFUDhT4NjxNB0Jp6n4gTzz+jiEIdpK8hI+GThvs4uwaPA/ovvBEzYR/aW2NRaEbIXkPZPrpU0pv+BA/4mx6yulfnFJ1Y/sn/nG6di26iz8EdSVS5skdjwou5Ws2x28eHE9x+9DLNNx7WGTyWNCQlbG8CSlxaBgiPP/HQotkNBGV4QxNjk4orkyfSBT+ehQTVqLsX18FBNGjhsIRW1WvoAr5qQnUY2GCdF39tr0PViBFntPJ836Z0Ja0b+KpG/EhNc6ou6SiEmgcs/156YpDqQboZEV7whIQbXYQ4yW5mz5s43wOs1fGThur1Z92U3vkad+iToHqyDHIM4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=orKrKWhrp7NT6BGrZmtid8GI7yYCLyAvm8tDvJ7Moik=;
 b=EJEJrfp9uH4LdsE04yZQyXw2awRPSVA5bH5/CU26s3QErcPBPU2ZlWgKo58oPn/qGosSIVXNCaL4aseKqCNH0Hhf12IAlhiVlWxydUdlYbiuCBPSTQm87hDd10UqCQQWsjm56srHAkxntSEO9+tDvnQSwOhmkzJWZLltOZdZnukovsvjT/y0YJI5E5H4FO267yC4+NmFkuPABVytvCIS3kjeBQRlLEHIADbRB6ekWC+efEt1xrgNbGmNdYpWshZODLfijdSoTOm+SYicaxl5MtrlwDOXPuZ6AL3TXKG5gZ/UECI1oKDFD68IJaXWKwn/GZ2a7vOxcgjPOLq1/JEceA==
Received: from BN9PR03CA0193.namprd03.prod.outlook.com (2603:10b6:408:f9::18)
 by SA0PR12MB4543.namprd12.prod.outlook.com (2603:10b6:806:9d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Tue, 16 Mar
 2021 10:21:07 +0000
Received: from BN8NAM11FT036.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f9:cafe::4e) by BN9PR03CA0193.outlook.office365.com
 (2603:10b6:408:f9::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31 via Frontend
 Transport; Tue, 16 Mar 2021 10:21:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT036.mail.protection.outlook.com (10.13.177.168) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Tue, 16 Mar 2021 10:21:06 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 16 Mar
 2021 10:20:58 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>, <dsahern@gmail.com>,
        <stephen@networkplumber.org>
CC:     Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>
Subject: [PATCH iproute2-next v3 1/6] nexthop: Synchronize uAPI files
Date:   Tue, 16 Mar 2021 11:20:11 +0100
Message-ID: <b74fd131ad979234044f15422279ffa81cfbfb48.1615889875.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1615889875.git.petrm@nvidia.com>
References: <cover.1615889875.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e8aafc96-2389-4cf4-c473-08d8e865361e
X-MS-TrafficTypeDiagnostic: SA0PR12MB4543:
X-Microsoft-Antispam-PRVS: <SA0PR12MB45431D88CEE5B162C1564A78D66B9@SA0PR12MB4543.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zjnf7W0Rb64yRoyWreaoLmbjs0QrQWcJ5rcYYm0gjg7bUrbaQqWXo+KEQU1JRqarwzjp3LO4oFgWDt0+XRzIGSO4FVUaa5AwoPRawHxCWDReH+3V1DCA7zzwUSbcx+lgv/75nPPYVvGZmf0ShfeDauO4jFHfSbhRwBgqgh5cab7CBZYbnaCjqghAnpyj1DbqPNAKDI+/wct7MghDddw296yJC55Ko63x3BVJyR7IV8r/Z3ogiBWG0PbjTuheSRWH7dX1ZkFVoWWnpc8phbUdCdeKwJPwyxMFKY/b+ObnVknAy8qr1MXn9jgYV5t/8DBVzdsZfmk0l2+KRmb1kxZaCfUuu7yl2Sg6YXKwJMHv9U0ZTr6+cgOEkqsG/4hFTRO1qLnnVHIZvJwPBtzAP7EdvBYDxcQOaPwgTIhP8SZaQu/lk739URlnU70FCLkHURLgMAJ4yngJzyUqetRORkG+SsvNuLjkV9mQJVTlId1wc/me7dc0kE91YGSFx78bcSBzST5QzQ6GIq2zdte4rtXIjZu18uTqNN3iYEEKeubYSAi1yalzpaE5p+xGhbwKqA+riYwNldLhvNElNjlBgfAN1II8/vqRMqBkWNBxcDfFylV1XIdndXLzdg14ON1tQzSKhjjUu0XPsaGDG4ektoBP6b9Nt3JLUgwaXDnOO+7tRVEcVpH/ioyWfRzEBLLZNY9f
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(136003)(376002)(396003)(39860400002)(46966006)(36840700001)(83380400001)(316002)(36906005)(47076005)(5660300002)(336012)(6666004)(36860700001)(2906002)(16526019)(2616005)(478600001)(426003)(86362001)(34020700004)(70586007)(82740400003)(8936002)(8676002)(107886003)(4326008)(36756003)(70206006)(110136005)(186003)(26005)(82310400003)(7636003)(54906003)(356005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2021 10:21:06.8593
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e8aafc96-2389-4cf4-c473-08d8e865361e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT036.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4543
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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

