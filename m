Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C690933BD89
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 15:38:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236562AbhCOOg6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 10:36:58 -0400
Received: from mail-dm6nam10on2069.outbound.protection.outlook.com ([40.107.93.69]:28256
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236558AbhCOOfz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 10:35:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jqkm5uylnu7bMuCVAW1+2psO6Inaubpby6Qf35/Xl+LN+5FGjA0B3oWijPqsZ1vtR0JxpN3BTE+aeS2m1/gtHxj7neqIAjbLWkfBz79VnKvtP8DMgB+eOInMZTwWI0i9tF5dGvuzSgyzo9jYtEQI0fkB4F4KpJ9bN+jSr3STm9GMlmDph+tzzDCycjWa3S9SBgei/gBxJQmD0gRFQarDZoXxF3ycmYFTTKUbmYigOtbeO8VGdn70Wy2NMnVJAhreXDDqQkkVisbtM5Nifvz7x+SVt12wU4LZpc6K5cjmpgVoayOwxPQWEjjPzsxL+5fCI0wFA/uXUQztYgWoa/zOiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=orKrKWhrp7NT6BGrZmtid8GI7yYCLyAvm8tDvJ7Moik=;
 b=koKhVoq1psgCVt+afCWJlDPzWDvDTwH4HD77FKLyXT5DzCrwONeAm0DLyE4ljuFhsXQVZp3yINxz3JxdylfuSNlzR0Pc28P6SsEOYOKuS3ZOjQSCvdnspZkAyI3wvc1UJPQco/yAFR6qosgPRYvwBAYV//XeA4T7eAy1Y10sLIWddfVTFX6TGW2ijpk1iT0dIzSAHauJ4RGm5VeADfHtLFUiXt6x0r1catfPLHSLWNbIrhQnBOhL+L4LYUPLj+s1fD3DmxdFk6laejEj8BrXEYo4IZ4tfMwwm7TGDIkvIo7+q6+w58ZyPaf1gToVMeDcG2IxKh3HEdsY1vJ0/79RKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=orKrKWhrp7NT6BGrZmtid8GI7yYCLyAvm8tDvJ7Moik=;
 b=mJRHZfQYoFIlwld8TJe9j17UuhIuLULyRshFvf8uvDSwvvASdG9/f0wmAFPvBD9EA1N26fVS8uuKKt8G6PggAcXQ0z6/lZBcdbXsRAWe/qqDOvEwQv89QWKeopHQpbUKWRCX6D2auY9g+FnhzRpk5vnv5LR+DXxBUwWEkCrRChTl28I2QBfEmkr+rB6RbFtMJv2KYbE6lw0ECTCq75Nu4GOXQV/t4qhDpB37DTeNDlBMsxh7MF09aQy4J20WGLmnxsRhZTvoD4tES42sbBio5HL6JSrCKM7zmFNcF9e1z0yjU+U5muG+ZkJ4+EO5TOy4J/ev/BWNhnpmSbyasgcWpw==
Received: from DM6PR10CA0007.namprd10.prod.outlook.com (2603:10b6:5:60::20) by
 BL1PR12MB5064.namprd12.prod.outlook.com (2603:10b6:208:30a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Mon, 15 Mar
 2021 14:35:53 +0000
Received: from DM6NAM11FT052.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:60:cafe::72) by DM6PR10CA0007.outlook.office365.com
 (2603:10b6:5:60::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31 via Frontend
 Transport; Mon, 15 Mar 2021 14:35:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT052.mail.protection.outlook.com (10.13.172.111) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Mon, 15 Mar 2021 14:35:52 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 15 Mar
 2021 14:35:49 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>, <dsahern@gmail.com>,
        <stephen@networkplumber.org>
CC:     Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>
Subject: [PATCH iproute2-next v2 1/6] nexthop: Synchronize uAPI files
Date:   Mon, 15 Mar 2021 15:34:30 +0100
Message-ID: <b74fd131ad979234044f15422279ffa81cfbfb48.1615818031.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1615818031.git.petrm@nvidia.com>
References: <cover.1615818031.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e0d0f6c0-4aff-4bbf-ac72-08d8e7bfa2b6
X-MS-TrafficTypeDiagnostic: BL1PR12MB5064:
X-Microsoft-Antispam-PRVS: <BL1PR12MB506468BD2256B9AC5C09FEEBD66C9@BL1PR12MB5064.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9GJQo73O5RyrcArtLUvW9UJBvI4LPK+Ri1JEcp2JJ4w8ikGiqE4Ds7eXqJt1QpYi/9jRutQoduRqWVrM5H+ALscj6sEaFuz6v+pf3ZMPN81gM7QQIg7tfmEvrBzh6kSF3dEfuH/YSGHEzaTsxsvkeoK7NQvsRwvCMJ0Krg56JtV6Aipsz72OXpbkYCYZkS1yT6NUrO0vlYbKc+VLOcZZFTQgiJ1oqltjKBPheXCTGAqY8kaL0pDWhLs7AK6xlYHutCx+NREJGugXLndNG3WtTczKWckJGSoLLDjfj0hErFjBfDMHZrVYoPwybBJB5eKEwfnaVeIUgkxIDLN0cY60hxBw3uir580eTjMMYIN/qhuBxJqIciFVLE8SOhggh5BQICF9nwb/q4UfK9xYpjgPDS9mJ8VrEIHo1GcXbqEWhJenpDkySRjO8/l0VHEXSAXhCtCnrltMqBJxPZq84x4htkTPHACo/UyOmCYfRY5aE3s0JqUN9PYqmTYI5J8e5xTbA2r5jPRYynRb/FlILHpRE6EAF1nfer+cqh/2QjrgskmQrleM/W51ALaplHGwk7za6EiUIPWhMP7WmJN5pCrtpUgjw0b7Tlr/fdlFZXt2pZWxsKCU6MuC6/eyMNe7h1d5Va/HtszoBK6U90rBGlrTRaA0kgNGAqFvlaUayKAg0wT8+fjPLMehqEGj/ixZdtpk
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(376002)(136003)(396003)(346002)(36840700001)(46966006)(26005)(186003)(36906005)(316002)(16526019)(107886003)(6666004)(86362001)(5660300002)(110136005)(70586007)(70206006)(82740400003)(54906003)(2906002)(356005)(7636003)(8936002)(36860700001)(34020700004)(4326008)(8676002)(478600001)(336012)(426003)(2616005)(83380400001)(47076005)(82310400003)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2021 14:35:52.6586
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e0d0f6c0-4aff-4bbf-ac72-08d8e7bfa2b6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT052.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5064
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

