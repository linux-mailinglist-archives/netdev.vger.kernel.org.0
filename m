Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22A8B33BD8E
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 15:38:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238199AbhCOOhJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 10:37:09 -0400
Received: from mail-eopbgr770052.outbound.protection.outlook.com ([40.107.77.52]:20803
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236638AbhCOOgC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 10:36:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dWaDeMXwtfl6xbVzSrteEi0YBVDMKGal8zhgvKagLIKAq0VOMnrU+sRBdGF1fPTq4pzWOcJlB5t2awJ5ra307Wtr7TAlof+KGerzZNSCVJ0GSBhV48yUOwCT5FE+LK9MCnCO2UEJmY8yTwgaTj8TNygUCrq1U/tjIHftbbZi1Tuz9bMhyAbHjgAZ7HnqJrMjRn+Er7UWOgE+tMtI0CefYgN2LxZeITvCg2WVL98CSEm3Jg44w+wYT+Q3ucPEsjUcIQ8vkkrK0Z1mOjnsR88KNYDCHEMRjR7+BV2GMRPJi9Zv0DMiVfo885ktzHfeNdLLan7U9tMMWu7IUr2ZZXPAxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sJJ0H2cSUk7/V2Q2G33NCiuMrjri0nRsFbphBjnf+GY=;
 b=e+FZj2/uNxwuwQp925v9yzr2mhzpKF6PB1ZeYKsbSsICZqel+pHcOpsbYtXXfsi/aOt9/iVjVCqS7H85OmNthQ0st/9+BztRsLpeyOExuMsHEuv+Id0kO+P6J+3U/a9ioSfuFeHeHX4hzq+ETTBmuSz3OlGcf089ZZwB0Ls0VUnogcA/U0IV6FhetSIyiDDYnS6PQNyP5UXmQputN8GzNLrjb3ToU9l42cTXubKA7LSaPWyKLlrowzurzjHMdJ23HhPE0//QZHP59AcS9sCY9aIbgsQol6cDy9THlxd4Ae2OMzC6mYYlgYkmUmxwzwKhA4Pfc70MWb2eGIQOF5TOsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sJJ0H2cSUk7/V2Q2G33NCiuMrjri0nRsFbphBjnf+GY=;
 b=VBpc/iDRtBia2qGT26OPKRYV37F7N74UyJY+HJu/FefYufCyYZDD/omTaIxyNNyzYiSvpvFrDhf2ObAdL6MB4XTaeWrl9ZUiUckF22UD3kWVZuo0DgJC+v/v9XnNE2jpZg0LqatkHFdd0rcHvBxajY1NIQ6filmiyIL86xRlj6GwM29ZEzfoDMYmtFtj6tGay7TV6AXu2WuBTIvnd5/MflTMJqJr++ILsOhAz8R8RwNU8dcUM75C/9XjcvXrO4/WQJezrN5sHGeEblhQqFetI4LWqrkBiqCcKtUMt/aZkvWJ0zU8U9cq9Kq47GI+WvfbVZ9tFafd4QfzsTO+oUON4A==
Received: from DM6PR14CA0070.namprd14.prod.outlook.com (2603:10b6:5:18f::47)
 by CH0PR12MB5041.namprd12.prod.outlook.com (2603:10b6:610:e0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Mon, 15 Mar
 2021 14:35:59 +0000
Received: from DM6NAM11FT027.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:18f:cafe::be) by DM6PR14CA0070.outlook.office365.com
 (2603:10b6:5:18f::47) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32 via Frontend
 Transport; Mon, 15 Mar 2021 14:35:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT027.mail.protection.outlook.com (10.13.172.205) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Mon, 15 Mar 2021 14:35:59 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 15 Mar
 2021 14:35:57 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>, <dsahern@gmail.com>,
        <stephen@networkplumber.org>
CC:     Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH iproute2-next v2 4/6] nexthop: Add ability to specify group type
Date:   Mon, 15 Mar 2021 15:34:33 +0100
Message-ID: <2e3328b34e571d00c7ff676624e6af2aebdcec62.1615818031.git.petrm@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: d6db66a5-b9e7-4efb-887b-08d8e7bfa6d3
X-MS-TrafficTypeDiagnostic: CH0PR12MB5041:
X-Microsoft-Antispam-PRVS: <CH0PR12MB50419C5604246D31BEE512FBD66C9@CH0PR12MB5041.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:849;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5DdKDGx8Ukicv8vicDAKtRiiEdLoPJdx0d/F8Zdu/hM5xFuKQRCnYtYMa8ch6l4UtAX7l1kFMzAp1KL75RdeWYTiWPXp2fOKFm5Rco39g8uOi1ilPyZr269GvFa1zJR+LwtB/ALfWBFl9VfxazB0ZkjShFk3qx+xjVKqKJ64gquO/mPgYgk7USZPxzHvqpipuyF8OWq3YysbGIHInpwOCfM8vN+SoeoDxedQBdjOloQ6LuTJJC9OgP/vn+yvRPLyo4OLYiokjgMPFilVVvekTqMpDiXodfmsV8AODxQSPuK4gYgXxXJSA9ZoToT78juQFvgI2ggDyfSuqZySaZfiLvynNjbO2KeQMiRPFFDFNl9bB2BxpnOB8ulP7NQkwfZkq1jwZN7QG6dM62ZhE2wkeF5xKcV/LInLsD2FcAbKtKkBoALvDY5sJeHp2ye8Y767ITWTqqYcFJFBwNCG4IqvkKhTtS3RU5T5FoNGgCmB1QRUgohzEZlpWwB3Ql4iDxvAWTsDd4IXbtItYUAT3br2C/zMFYrC7LnPL/1OTFzxWSH682w5UbyVPNCig92gnXgKjEDApyoEL/v6whByb+pXz5RJx+teCCPW8BJnahPVenEpBbv75WWCPSGjjPLA7jTiNzzAesxdDPRggXdgodVQkE2BzKiAnSdrgtineW/AHQA2Hsf/PCaoSSVa1gJ2umtq
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(396003)(136003)(46966006)(36840700001)(36906005)(110136005)(316002)(83380400001)(70206006)(16526019)(70586007)(82310400003)(47076005)(2906002)(8936002)(82740400003)(86362001)(186003)(107886003)(4326008)(8676002)(336012)(6666004)(426003)(5660300002)(36860700001)(478600001)(26005)(7636003)(36756003)(356005)(34020700004)(2616005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2021 14:35:59.5576
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d6db66a5-b9e7-4efb-887b-08d8e7bfa6d3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT027.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5041
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Next patches are going to add a 'resilient' nexthop group type, so allow
users to specify the type using the 'type' argument. Currently, only
'mpath' type is supported.

These two commands are equivalent:

 # ip nexthop add id 10 group 1/2/3
 # ip nexthop add id 10 group 1/2/3 type mpath

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---

Notes:
    v2:
    - Add a missing example command to commit message
    - Mention in the man page that mpath is the default

 ip/ipnexthop.c        | 32 +++++++++++++++++++++++++++++++-
 man/man8/ip-nexthop.8 | 19 +++++++++++++++++--
 2 files changed, 48 insertions(+), 3 deletions(-)

diff --git a/ip/ipnexthop.c b/ip/ipnexthop.c
index 126b0b17cab4..5aae32629edd 100644
--- a/ip/ipnexthop.c
+++ b/ip/ipnexthop.c
@@ -42,8 +42,10 @@ static void usage(void)
 		"SELECTOR := [ id ID ] [ dev DEV ] [ vrf NAME ] [ master DEV ]\n"
 		"            [ groups ] [ fdb ]\n"
 		"NH := { blackhole | [ via ADDRESS ] [ dev DEV ] [ onlink ]\n"
-		"        [ encap ENCAPTYPE ENCAPHDR ] | group GROUP [ fdb ] }\n"
+		"        [ encap ENCAPTYPE ENCAPHDR ] |\n"
+		"        group GROUP [ fdb ] [ type TYPE ] }\n"
 		"GROUP := [ <id[,weight]>/<id[,weight]>/... ]\n"
+		"TYPE := { mpath }\n"
 		"ENCAPTYPE := [ mpls ]\n"
 		"ENCAPHDR := [ MPLSLABEL ]\n");
 	exit(-1);
@@ -327,6 +329,32 @@ static int add_nh_group_attr(struct nlmsghdr *n, int maxlen, char *argv)
 	return addattr_l(n, maxlen, NHA_GROUP, grps, count * sizeof(*grps));
 }
 
+static int read_nh_group_type(const char *name)
+{
+	if (strcmp(name, "mpath") == 0)
+		return NEXTHOP_GRP_TYPE_MPATH;
+
+	return __NEXTHOP_GRP_TYPE_MAX;
+}
+
+static void parse_nh_group_type(struct nlmsghdr *n, int maxlen, int *argcp,
+				char ***argvp)
+{
+	char **argv = *argvp;
+	int argc = *argcp;
+	__u16 type;
+
+	NEXT_ARG();
+	type = read_nh_group_type(*argv);
+	if (type > NEXTHOP_GRP_TYPE_MAX)
+		invarg("\"type\" value is invalid\n", *argv);
+
+	*argcp = argc;
+	*argvp = argv;
+
+	addattr16(n, maxlen, NHA_GROUP_TYPE, type);
+}
+
 static int ipnh_parse_id(const char *argv)
 {
 	__u32 id;
@@ -409,6 +437,8 @@ static int ipnh_modify(int cmd, unsigned int flags, int argc, char **argv)
 
 			if (add_nh_group_attr(&req.n, sizeof(req), *argv))
 				invarg("\"group\" value is invalid\n", *argv);
+		} else if (!strcmp(*argv, "type")) {
+			parse_nh_group_type(&req.n, sizeof(req), &argc, &argv);
 		} else if (matches(*argv, "protocol") == 0) {
 			__u32 prot;
 
diff --git a/man/man8/ip-nexthop.8 b/man/man8/ip-nexthop.8
index 4d55f4dbcc75..b86f307fef35 100644
--- a/man/man8/ip-nexthop.8
+++ b/man/man8/ip-nexthop.8
@@ -54,7 +54,9 @@ ip-nexthop \- nexthop object management
 .BR fdb " ] | "
 .B  group
 .IR GROUP " [ "
-.BR fdb " ] } "
+.BR fdb " ] [ "
+.B type
+.IR TYPE " ] } "
 
 .ti -8
 .IR ENCAP " := [ "
@@ -71,6 +73,10 @@ ip-nexthop \- nexthop object management
 .IR GROUP " := "
 .BR id "[," weight "[/...]"
 
+.ti -8
+.IR TYPE " := { "
+.BR mpath " }"
+
 .SH DESCRIPTION
 .B ip nexthop
 is used to manipulate entries in the kernel's nexthop tables.
@@ -122,9 +128,18 @@ is a set of encapsulation attributes specific to the
 .in -2
 
 .TP
-.BI group " GROUP"
+.BI group " GROUP [ " type " TYPE ]"
 create a nexthop group. Group specification is id with an optional
 weight (id,weight) and a '/' as a separator between entries.
+.sp
+.I TYPE
+is a string specifying the nexthop group type. Namely:
+
+.in +8
+.BI mpath
+- Multipath nexthop group backed by the hash-threshold algorithm. The
+default when the type is unspecified.
+
 .TP
 .B blackhole
 create a blackhole nexthop
-- 
2.26.2

