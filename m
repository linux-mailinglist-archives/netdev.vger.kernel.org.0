Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 402E733F0C2
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 13:56:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbhCQMze (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 08:55:34 -0400
Received: from mail-bn8nam08on2076.outbound.protection.outlook.com ([40.107.100.76]:50305
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230159AbhCQMzS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Mar 2021 08:55:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wl7haLmLjfXxOhuwU98lqvewKtJi5qe3b5B5QwC2oyW3sbezKhsSHcxHYpnTfpYvDx/RH1DBRVOQYqzkFvOHO63CIVnff75WaisEUqxlXgCNdO0RLP/gJz24T/rUgwpnMHbhn15YyDPt0rxIdi5RG+wY5l/CMaxlWoEqsqwHd+/NtadaB9lYI+AJOu4prWhjVc+wySNPwDhuYiHipxmtrD44QJFE0gIxKcM3YVOILKBbIWkMCU3bUufYMyZBKzlJ5IoEbBIVrKC+ckZ/fh/7MYz3hBr6xeNkx7iHrOsMAkIFHR/Qcn/lMczSxGJ6jBjXLPrThGb6Z/HrbE3Q1ce9aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iXtqQs559FC5Z+lEf5ustyJUlprH/RyBpQf8ch0xDCg=;
 b=oCn99eQaNSHWZAjxPYLay8Hqd1w092Sjl+N5yvyOX57p25d6kGB9ujYNLyfCJ5BNNCXdKkmR6//cSnBDg8WCfbvA/ZodrMRqoM6fs5ozigbEfBm7H84IQA6BgykFwIyEYKwD0CYRSyWmXxitQ1DlMc4qv06eSXMTUbst9b12SRovqQXxmJmBVLPyl8xoTHTme/2jvOzeEkQAwbfEVXr5PlfqPhVDD4LC8ewh8NPrgBSahc3yoP6wk41HbSHmYFVtiRAtZkzN1FkMAiAjhHyenm9frMWoeQmprRZm0KF4KYCMqpxsQfaA2qUv/9p6aNkuw2cAE7Rv8UrWQK7r9j8E/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iXtqQs559FC5Z+lEf5ustyJUlprH/RyBpQf8ch0xDCg=;
 b=DHDDCP/gtecxlmDxrpDlz8PFhf0/Je9OEAKNkLYIo1X44hjmqNgAW+oTj833Fi7pOCqh3ZekX3M/H1aY1VvKLijr3yAx2+4qiTPM9fNiZtOOTgaan9l9+EG5aKD3Yvs8WCE/mXs77jLxutnv+ICiQXCNENTBrn5Q90C6pURHeJfYkcKMUy9Cps1VvZCoIwmGr2IgtBTFbxjdCasszk1VhKTdAekUatrvF+oPgKviOtXjt4HcdJqNVc5++5t7lVPpSgLSZEMJb6uhcTntmcE2F6MKcfhFEqJdARjp80/BsnG1OfsQni2HxH3fNnIMSAbQG1Uzi0Zlt9M1HHzfL85RwA==
Received: from DM5PR13CA0068.namprd13.prod.outlook.com (2603:10b6:3:117::30)
 by SA0PR12MB4541.namprd12.prod.outlook.com (2603:10b6:806:9e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Wed, 17 Mar
 2021 12:55:16 +0000
Received: from DM6NAM11FT034.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:117:cafe::99) by DM5PR13CA0068.outlook.office365.com
 (2603:10b6:3:117::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.9 via Frontend
 Transport; Wed, 17 Mar 2021 12:55:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT034.mail.protection.outlook.com (10.13.173.47) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3955.18 via Frontend Transport; Wed, 17 Mar 2021 12:55:15 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 17 Mar
 2021 12:55:13 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>, <dsahern@gmail.com>,
        <stephen@networkplumber.org>
CC:     Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>
Subject: [PATCH iproute2-next v4 5/6] nexthop: Add support for resilient nexthop groups
Date:   Wed, 17 Mar 2021 13:54:34 +0100
Message-ID: <116739754636a46035948d92f8db06f7267a5fd2.1615985531.git.petrm@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: 17661123-a133-4228-1c31-08d8e943e96c
X-MS-TrafficTypeDiagnostic: SA0PR12MB4541:
X-Microsoft-Antispam-PRVS: <SA0PR12MB454135C3FD1E7F1A61650659D66A9@SA0PR12MB4541.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gSegTVrruBGJY9Lsm9mnSKf4ankWLXeWHYUcfin6AD3Z0wFmTfUBAq2uoyPcOTaWtPJlehqpF0ZaMt2mNCv2M+p9BWCqj/AtkpQ12DDixkXbkAyqGH+Mi7oFWM4y3Eh+pRfgZZ9L/gdgi0CHSmzFZl87ff8SQHI/y2jwfZtA6qptuSSNafzA9msQCerZfYkNhBumyoECnIjtfvU+JTogAnfY8DEsVE/1eCTBtc3pcORx7vQ1Rm3kOpwgGtwd3+KrDrjx3oZTtHqd2Dvyw1svGaLeiHxylDSO0KzoVuhaCD9LuTEBkbESptW10pGHOcLUNd6awmADqT76J/jhHVGlfXI1ZFsUi8oBO0Aw+TtMQRkJFNhD1nOjWGGoZcXVDw7kULxC4NPFXqIXgqJxF+jL+fuxzWA52NP3BkJQ+ib7YXc2vO1qP085PSpPSprbZUdNgAkO7nfRob+T2cwmspbLTW+fIzqEFtELjCMpQJxFfoThLIDW4xWX5zTzFi0XV7+fTtXwhZemk1AYcc63h+T/zB5N5wSm9ufD88i1n1p4ag0ebD6IXzME+DIoD4wal6+S9qZIC8O/O/PiAqyHjn07xKBP6PV2bWJ/3de+4PTJu/IzBjnvFNJQkfqESLdOANpGq8Gm54d78P0kJKjLFFxJYTM8YsQ0xTbTbo2e7ValhDH2vSmRHf0MHRUGrnerF0Ct
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(136003)(39860400002)(346002)(376002)(36840700001)(46966006)(36756003)(316002)(83380400001)(70586007)(36860700001)(34020700004)(426003)(186003)(336012)(82310400003)(16526019)(54906003)(36906005)(70206006)(110136005)(26005)(6666004)(5660300002)(8936002)(107886003)(356005)(2616005)(2906002)(8676002)(47076005)(4326008)(86362001)(82740400003)(478600001)(7636003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2021 12:55:15.9663
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 17661123-a133-4228-1c31-08d8e943e96c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT034.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4541
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Add ability to configure resilient nexthop groups and show their current
configuration. Example:

 # ip nexthop add id 10 group 1/2 type resilient buckets 8
 # ip nexthop show id 10
 id 10 group 1/2 type resilient buckets 8 idle_timer 120 unbalanced_timer 0
 # ip -j -p nexthop show id 10
 [ {
         "id": 10,
         "group": [ {
                 "id": 1
             },{
                 "id": 2
             } ],
         "type": "resilient",
         "resilient_args": {
             "buckets": 8,
             "idle_timer": 120,
             "unbalanced_timer": 0
         },
         "flags": [ ]
     } ]

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 ip/ipnexthop.c        | 144 +++++++++++++++++++++++++++++++++++++++++-
 man/man8/ip-nexthop.8 |  55 +++++++++++++++-
 2 files changed, 193 insertions(+), 6 deletions(-)

diff --git a/ip/ipnexthop.c b/ip/ipnexthop.c
index 5aae32629edd..1d50bf7529c4 100644
--- a/ip/ipnexthop.c
+++ b/ip/ipnexthop.c
@@ -43,9 +43,12 @@ static void usage(void)
 		"            [ groups ] [ fdb ]\n"
 		"NH := { blackhole | [ via ADDRESS ] [ dev DEV ] [ onlink ]\n"
 		"        [ encap ENCAPTYPE ENCAPHDR ] |\n"
-		"        group GROUP [ fdb ] [ type TYPE ] }\n"
+		"        group GROUP [ fdb ] [ type TYPE [ TYPE_ARGS ] ] }\n"
 		"GROUP := [ <id[,weight]>/<id[,weight]>/... ]\n"
-		"TYPE := { mpath }\n"
+		"TYPE := { mpath | resilient }\n"
+		"TYPE_ARGS := [ RESILIENT_ARGS ]\n"
+		"RESILIENT_ARGS := [ buckets BUCKETS ] [ idle_timer IDLE ]\n"
+		"                  [ unbalanced_timer UNBALANCED ]\n"
 		"ENCAPTYPE := [ mpls ]\n"
 		"ENCAPHDR := [ MPLSLABEL ]\n");
 	exit(-1);
@@ -203,6 +206,66 @@ static void print_nh_group(FILE *fp, const struct rtattr *grps_attr)
 	close_json_array(PRINT_JSON, NULL);
 }
 
+static const char *nh_group_type_name(__u16 type)
+{
+	switch (type) {
+	case NEXTHOP_GRP_TYPE_MPATH:
+		return "mpath";
+	case NEXTHOP_GRP_TYPE_RES:
+		return "resilient";
+	default:
+		return "<unknown type>";
+	}
+}
+
+static void print_nh_group_type(FILE *fp, const struct rtattr *grp_type_attr)
+{
+	__u16 type = rta_getattr_u16(grp_type_attr);
+
+	if (type == NEXTHOP_GRP_TYPE_MPATH)
+		/* Do not print type in order not to break existing output. */
+		return;
+
+	print_string(PRINT_ANY, "type", "type %s ", nh_group_type_name(type));
+}
+
+static void print_nh_res_group(FILE *fp, const struct rtattr *res_grp_attr)
+{
+	struct rtattr *tb[NHA_RES_GROUP_MAX + 1];
+	struct rtattr *rta;
+	struct timeval tv;
+
+	parse_rtattr_nested(tb, NHA_RES_GROUP_MAX, res_grp_attr);
+
+	open_json_object("resilient_args");
+
+	if (tb[NHA_RES_GROUP_BUCKETS])
+		print_uint(PRINT_ANY, "buckets", "buckets %u ",
+			   rta_getattr_u16(tb[NHA_RES_GROUP_BUCKETS]));
+
+	if (tb[NHA_RES_GROUP_IDLE_TIMER]) {
+		rta = tb[NHA_RES_GROUP_IDLE_TIMER];
+		__jiffies_to_tv(&tv, rta_getattr_u32(rta));
+		print_tv(PRINT_ANY, "idle_timer", "idle_timer %g ", &tv);
+	}
+
+	if (tb[NHA_RES_GROUP_UNBALANCED_TIMER]) {
+		rta = tb[NHA_RES_GROUP_UNBALANCED_TIMER];
+		__jiffies_to_tv(&tv, rta_getattr_u32(rta));
+		print_tv(PRINT_ANY, "unbalanced_timer", "unbalanced_timer %g ",
+			 &tv);
+	}
+
+	if (tb[NHA_RES_GROUP_UNBALANCED_TIME]) {
+		rta = tb[NHA_RES_GROUP_UNBALANCED_TIME];
+		__jiffies_to_tv(&tv, rta_getattr_u32(rta));
+		print_tv(PRINT_ANY, "unbalanced_time", "unbalanced_time %g ",
+			 &tv);
+	}
+
+	close_json_object();
+}
+
 int print_nexthop(struct nlmsghdr *n, void *arg)
 {
 	struct nhmsg *nhm = NLMSG_DATA(n);
@@ -229,7 +292,7 @@ int print_nexthop(struct nlmsghdr *n, void *arg)
 	if (filter.proto && filter.proto != nhm->nh_protocol)
 		return 0;
 
-	parse_rtattr(tb, NHA_MAX, RTM_NHA(nhm), len);
+	parse_rtattr_flags(tb, NHA_MAX, RTM_NHA(nhm), len, NLA_F_NESTED);
 
 	open_json_object(NULL);
 
@@ -243,6 +306,12 @@ int print_nexthop(struct nlmsghdr *n, void *arg)
 	if (tb[NHA_GROUP])
 		print_nh_group(fp, tb[NHA_GROUP]);
 
+	if (tb[NHA_GROUP_TYPE])
+		print_nh_group_type(fp, tb[NHA_GROUP_TYPE]);
+
+	if (tb[NHA_RES_GROUP])
+		print_nh_res_group(fp, tb[NHA_RES_GROUP]);
+
 	if (tb[NHA_ENCAP])
 		lwt_print_encap(fp, tb[NHA_ENCAP_TYPE], tb[NHA_ENCAP]);
 
@@ -333,10 +402,70 @@ static int read_nh_group_type(const char *name)
 {
 	if (strcmp(name, "mpath") == 0)
 		return NEXTHOP_GRP_TYPE_MPATH;
+	else if (strcmp(name, "resilient") == 0)
+		return NEXTHOP_GRP_TYPE_RES;
 
 	return __NEXTHOP_GRP_TYPE_MAX;
 }
 
+static void parse_nh_group_type_res(struct nlmsghdr *n, int maxlen, int *argcp,
+				    char ***argvp)
+{
+	char **argv = *argvp;
+	struct rtattr *nest;
+	int argc = *argcp;
+
+	if (!NEXT_ARG_OK())
+		return;
+
+	nest = addattr_nest(n, maxlen, NHA_RES_GROUP);
+	nest->rta_type |= NLA_F_NESTED;
+
+	NEXT_ARG_FWD();
+	while (argc > 0) {
+		if (strcmp(*argv, "buckets") == 0) {
+			__u16 buckets;
+
+			NEXT_ARG();
+			if (get_u16(&buckets, *argv, 0))
+				invarg("invalid buckets value", *argv);
+
+			addattr16(n, maxlen, NHA_RES_GROUP_BUCKETS, buckets);
+		} else if (strcmp(*argv, "idle_timer") == 0) {
+			__u32 idle_timer;
+
+			NEXT_ARG();
+			if (get_unsigned(&idle_timer, *argv, 0) ||
+			    idle_timer >= ~0UL / 100)
+				invarg("invalid idle timer value", *argv);
+
+			addattr32(n, maxlen, NHA_RES_GROUP_IDLE_TIMER,
+				  idle_timer * 100);
+		} else if (strcmp(*argv, "unbalanced_timer") == 0) {
+			__u32 unbalanced_timer;
+
+			NEXT_ARG();
+			if (get_unsigned(&unbalanced_timer, *argv, 0) ||
+			    unbalanced_timer >= ~0UL / 100)
+				invarg("invalid unbalanced timer value", *argv);
+
+			addattr32(n, maxlen, NHA_RES_GROUP_UNBALANCED_TIMER,
+				  unbalanced_timer * 100);
+		} else {
+			break;
+		}
+		argc--; argv++;
+	}
+
+	/* argv is currently the first unparsed argument, but ipnh_modify()
+	 * will move to the next, so step back.
+	 */
+	*argcp = argc + 1;
+	*argvp = argv - 1;
+
+	addattr_nest_end(n, nest);
+}
+
 static void parse_nh_group_type(struct nlmsghdr *n, int maxlen, int *argcp,
 				char ***argvp)
 {
@@ -349,6 +478,15 @@ static void parse_nh_group_type(struct nlmsghdr *n, int maxlen, int *argcp,
 	if (type > NEXTHOP_GRP_TYPE_MAX)
 		invarg("\"type\" value is invalid\n", *argv);
 
+	switch (type) {
+	case NEXTHOP_GRP_TYPE_MPATH:
+		/* No additional arguments */
+		break;
+	case NEXTHOP_GRP_TYPE_RES:
+		parse_nh_group_type_res(n, maxlen, &argc, &argv);
+		break;
+	}
+
 	*argcp = argc;
 	*argvp = argv;
 
diff --git a/man/man8/ip-nexthop.8 b/man/man8/ip-nexthop.8
index b86f307fef35..c1ac130c2a2f 100644
--- a/man/man8/ip-nexthop.8
+++ b/man/man8/ip-nexthop.8
@@ -56,7 +56,7 @@ ip-nexthop \- nexthop object management
 .IR GROUP " [ "
 .BR fdb " ] [ "
 .B type
-.IR TYPE " ] } "
+.IR TYPE " [ " TYPE_ARGS " ] ] }"
 
 .ti -8
 .IR ENCAP " := [ "
@@ -75,7 +75,20 @@ ip-nexthop \- nexthop object management
 
 .ti -8
 .IR TYPE " := { "
-.BR mpath " }"
+.BR mpath " | " resilient " }"
+
+.ti -8
+.IR TYPE_ARGS " := [ "
+.IR RESILIENT_ARGS " ] "
+
+.ti -8
+.IR RESILIENT_ARGS " := "
+.RB "[ " buckets
+.IR BUCKETS " ] [ "
+.B  idle_timer
+.IR IDLE " ] [ "
+.B  unbalanced_timer
+.IR UNBALANCED " ]"
 
 .SH DESCRIPTION
 .B ip nexthop
@@ -128,7 +141,7 @@ is a set of encapsulation attributes specific to the
 .in -2
 
 .TP
-.BI group " GROUP [ " type " TYPE ]"
+.BI group " GROUP [ " type " TYPE [ TYPE_ARGS ] ]"
 create a nexthop group. Group specification is id with an optional
 weight (id,weight) and a '/' as a separator between entries.
 .sp
@@ -139,6 +152,37 @@ is a string specifying the nexthop group type. Namely:
 .BI mpath
 - Multipath nexthop group backed by the hash-threshold algorithm. The
 default when the type is unspecified.
+.sp
+.BI resilient
+- Resilient nexthop group. Group is resilient to addition and deletion of
+nexthops.
+
+.sp
+.in -8
+.I TYPE_ARGS
+is a set of attributes specific to the
+.I TYPE.
+
+.in +8
+.B resilient
+.in +2
+.B buckets
+.I BUCKETS
+- Number of nexthop buckets. Cannot be changed for an existing group
+.sp
+
+.B idle_timer
+.I IDLE
+- Time in seconds in which a nexthop bucket does not see traffic and is
+therefore considered idle. Default is 120 seconds
+
+.B unbalanced_timer
+.I UNBALANCED
+- Time in seconds in which a nexthop group is unbalanced and is therefore
+considered unbalanced. The kernel will try to rebalance unbalanced groups, which
+might result in some flows being reset. A value of 0 means that no
+rebalancing will take place. Default is 0 seconds
+.in -2
 
 .TP
 .B blackhole
@@ -225,6 +269,11 @@ ip nexthop add id 7 group 5/6 fdb
 Adds a fdb nexthop group with id 7. A fdb nexthop group can only have
 fdb nexthops.
 .RE
+.PP
+ip nexthop add id 10 group 1/2 type resilient buckets 32
+.RS 4
+Add a resilient nexthop group with id 10 and 32 nexthop buckets.
+.RE
 .SH SEE ALSO
 .br
 .BR ip (8)
-- 
2.26.2

