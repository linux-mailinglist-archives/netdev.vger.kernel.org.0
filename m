Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5125433F0BF
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 13:56:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230226AbhCQMz3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 08:55:29 -0400
Received: from mail-bn8nam11on2053.outbound.protection.outlook.com ([40.107.236.53]:61646
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230037AbhCQMzH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Mar 2021 08:55:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XRYCkVkF08IuaSeFktJN4DdILF1q4yRn6jFnCVPacfG3SP5QxKpqJ7kB9e5Lx7968sWUb4otE1It2NgPYh6zK0MGbWyB2By8DWI7sGCUToseAXnsmZ4D4ftbslhoiiJ8HWko7tbMEpvpmjTTGFJJxjY5p2qdzhduaXlBI4Ta7qJYV/WSXhFYaTqzTIBJGnLvzPs2Y03mfXsx/b+j42XARFvIsJ5adnsKPzqZPlQ7UFGq0n8DLVE51DYD4WwyWeu9jA2R7HvioE4nyNv/it0wE0V8I3ZbmggHmyZIHTxFoR9suqlpMWo3qIcRp4UH08ytJr8rbX3Y4UBs2W70h+RFUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=orKrKWhrp7NT6BGrZmtid8GI7yYCLyAvm8tDvJ7Moik=;
 b=Q9PbjU45GXXqDjA4GXLBjm8XDiMC1lcQ+gWtF9EeJJ5P33MdOhHqci5D0wbYkuF9Dy/MyYcWyQJW5rG4u6hGKDljSJmV7mgPAdkcznO6c5zI4YWzZiGUWfn1sru/CaI19CIAY79FmvxEC/byKpxGl2W468TSfz91AqGKj1tnp2gDPVaIArmqrTPEA2IrkN1CpVO9P5WFsuq631UjKf0On2Lg/D+X1dBRbAL11nfvZqITMolevIVLyqLN0U0wPwA474G1y+XH5j+zRRrdXJs0fp+pxZl99OZEalMB1K+DrgzoMhUa+9d7Diq2vxN/VjBCYGmtBCH2Lv4ksD0Bs50csQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=orKrKWhrp7NT6BGrZmtid8GI7yYCLyAvm8tDvJ7Moik=;
 b=IhqU5VDIClmCVFuvawsykU76vELv+784JOlf5y4Y1kkQpPgqxOL6SKvpF3UVzvt2i3/tP3HTa1RoBXd+vu9YqOSKTMkJuYUU8wBBZA0DMIw6aJiAwERJfzM0NJL5ljkHqYXwrQS6Yu2IudG4joMOXL5UxZOxFim8DWyfPAwVMSkqZWJpWLNtsd2oliJUm1dn37GvhbxkMUbZeBAdc9dJzlGLtOUsciejtlvVWJ++7JhVDtjeucuxGZkPpKsQ7+sWJPbIY6RnElszR75xk+kbaaoMeJ5PdUAYhOHoxeloKOD2ExDNtbVfsXowQzCNpBbYBHmf9C1guUGaSeEY2FXrhQ==
Received: from DM5PR16CA0030.namprd16.prod.outlook.com (2603:10b6:4:15::16) by
 CH2PR12MB4230.namprd12.prod.outlook.com (2603:10b6:610:aa::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3933.32; Wed, 17 Mar 2021 12:55:05 +0000
Received: from DM6NAM11FT050.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:15:cafe::27) by DM5PR16CA0030.outlook.office365.com
 (2603:10b6:4:15::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend
 Transport; Wed, 17 Mar 2021 12:55:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT050.mail.protection.outlook.com (10.13.173.111) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3955.18 via Frontend Transport; Wed, 17 Mar 2021 12:55:05 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 17 Mar
 2021 12:55:02 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>, <dsahern@gmail.com>,
        <stephen@networkplumber.org>
CC:     Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>
Subject: [PATCH iproute2-next v4 1/6] nexthop: Synchronize uAPI files
Date:   Wed, 17 Mar 2021 13:54:30 +0100
Message-ID: <ad9b63d5c76d9ef045dfed6dc9b5ab946e62e450.1615985531.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1615985531.git.petrm@nvidia.com>
References: <cover.1615985531.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 11f220f5-3b49-4ec0-3222-08d8e943e32f
X-MS-TrafficTypeDiagnostic: CH2PR12MB4230:
X-Microsoft-Antispam-PRVS: <CH2PR12MB42301B8C92C0DED8B0A1F136D66A9@CH2PR12MB4230.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HeOMiHa1WHT/Jy4yaEKgdlDJdJ+HPExwxPGSlSdBKIusxcQ36Sdpa0J7fEDYHYp1KN5HLRC8SGOjlZaaMcmk0RxaaF/AFe87i2xHsXv/pxuNahF5EeY4oXHJKIQmHegxX+Ng9cJXi8qZsVTUNKAJlt/6dC25Qa8pcOGGFANgMX9sKFPfIvAwN5uRqCTB/A6GFx+2wxpIb9oEdcbHVluXB1wAFGe18iCWN26623EUP67ZSWkITWip73k/P7dA5EZ1WtGlO65s6MwVgIEpwaK5LWxPZkl50320KHSXNix9dxcmyAC4ilDdCj3nIAg8XAmpMSFqIKAMnGEUS2/e59xgPBv8Ee5ydekkG9JVg+BY4A/c+vqXyaB4PtPSFo9Y/+w9u84Ar1QBBVdrC2OUMfspW5r6+mYHKv3GghM5xV2lmovl4Pf3L0yilCE1i+N5DhzgF4VL94S1tI52BNeCXKWRDzyOZ++gE4KwNOnU0EmAHp4p5fU8kGxcpYLoENDejjl3dhul+CPwAoiMcwmfTXQbYl2OBfdmHYsr93fTULk8xptlnk0sf7JCby8vYtqhytO35Y3tiJn0McI0C+g18u0Nxvyj+mOkgBJrIEpVT07fU2eLpV5387po9oGTRCamnHJlYgdzuW5UtG54PMiW6HaEzXsTfQc+DoB8oLiVpf2mCo/oMApSa7JOqlHdVM6JB5sj
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(136003)(396003)(376002)(39860400002)(46966006)(36840700001)(356005)(2906002)(36860700001)(7636003)(4326008)(70206006)(86362001)(6666004)(107886003)(2616005)(54906003)(26005)(36756003)(110136005)(478600001)(8936002)(5660300002)(82740400003)(16526019)(47076005)(36906005)(70586007)(186003)(83380400001)(316002)(336012)(34020700004)(8676002)(426003)(82310400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2021 12:55:05.5387
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 11f220f5-3b49-4ec0-3222-08d8e943e32f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT050.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4230
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

