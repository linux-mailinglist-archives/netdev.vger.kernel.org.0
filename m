Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D75A733BD90
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 15:38:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238277AbhCOOhL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 10:37:11 -0400
Received: from mail-bn7nam10on2066.outbound.protection.outlook.com ([40.107.92.66]:36173
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236985AbhCOOgE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 10:36:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iHg3nkVUyNnXABhBN9ytgf6imFUplk0ORyS2knicZnbmJqFKW2AvCzhp/gf+UWejExl9v2L+qwYVokhYr1JSVNiW9sXlsMuF+DnZYpNw7E7T9f25fBbNKqpj4bpMGfwn5Al1G0a1Rs1YhWvtCXbKRxKKyB08pXQkxiw9yBweOLwjA3Gu/dBOxc0DtArNTdg9w+o4VjUmCh/KlZtE7Jz/NPBJt0RWQ/pb2C6SzAp8OYxJj6VR14vBkDhYMZamGBB0r5j9kUWeY3A67xUzvorVwspsMzRF+FI2G1HjFGYtOoArJqJKPYZfyi7u993Ukazd4JCq26S/1b2pF3TeJ2DXHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mnY+ycZrej6yMXYMbLb7ySBOcXaoBbbASSyP9+I/UUM=;
 b=MkJyh0QpzbZOP3YdzGSKs6Ct92RyhOtMLMK8KW01EHlqFvE7jKCJ/8WpBZDMwir4L5+ywejV/QvMctsQ38C0QWDPKobnK7jXtvymqjq+lz9bwiWWfRKigGY+I46iTweXFLoLCLlRB+W+YRYRbbvCQ7/1NhhXMVKjlUtYgq4V6syuWU1UgbpatEmuEGxd+1J9RYuh1vn/rFmB8Kf5Ta7hNxpQ9phsw+F80VUsDg/MYNqaN5z8B5d7b7XXB5KxZHjx4dhktb1eJVHCt9lkCvnOz3E+1m1qPklYOczhbPLV62wFW1C+NQwJU3J7qSeY6WExIQR5Dcx7yzagRY1WrmqJ/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mnY+ycZrej6yMXYMbLb7ySBOcXaoBbbASSyP9+I/UUM=;
 b=DDM0q7X8kZTAkR5HZJkRPJeZA4P2MfYnz2Fu4yFYMpSW57FfJCrmSi5Uz+iLwiM6qF+MPTcuRg2RmoKIcl/CeciXEzLniV6ieF6B9cKX+gjdfOnAhyz1/DjT99GH4JT7a6uJ1waWgmxXeHrlr+oomEvIn1bYU2Vf/FTP8UtF5V3sgltokVXmPCunXFhRvCMf4NJX06NXE9uVe3ZixVFbEcwvYzaOZZln2FgqmZKsYZgGbftGPF69DlsL04gRj7COa1/yVs1QCRbFpHmmvVa28FSO8QMIe0gw6v8SBpuCeS4EXv44CeyXAWAZFQhERmv/WY4ajScidiCqkZ8mKRtjiQ==
Received: from DM6PR03CA0055.namprd03.prod.outlook.com (2603:10b6:5:100::32)
 by SA0PR12MB4541.namprd12.prod.outlook.com (2603:10b6:806:9e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Mon, 15 Mar
 2021 14:36:02 +0000
Received: from DM6NAM11FT062.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:100:cafe::e8) by DM6PR03CA0055.outlook.office365.com
 (2603:10b6:5:100::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32 via Frontend
 Transport; Mon, 15 Mar 2021 14:36:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT062.mail.protection.outlook.com (10.13.173.40) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Mon, 15 Mar 2021 14:36:02 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 15 Mar
 2021 14:35:59 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>, <dsahern@gmail.com>,
        <stephen@networkplumber.org>
CC:     Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH iproute2-next v2 5/6] nexthop: Add support for resilient nexthop groups
Date:   Mon, 15 Mar 2021 15:34:34 +0100
Message-ID: <5d6b10405404674d01d6edb601a6028ddc9a9b6f.1615818031.git.petrm@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: ac35e1b4-1192-4f01-014a-08d8e7bfa878
X-MS-TrafficTypeDiagnostic: SA0PR12MB4541:
X-Microsoft-Antispam-PRVS: <SA0PR12MB4541E4F27E0707EDF3AF31F2D66C9@SA0PR12MB4541.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i63IK6W2fvDFbwu6Ye1PVK7kj1xy9KWC0Q/lTwp+MQSHWN1ytfdLFlScCUANyLLBzJfHUNSUD7NnAXuvthpJvN4Nl2Ee7f8cpFdg6ro6f8NHQs+v9S+puRHKWx1lsvItAhK5C8gffnQsEgmt8vuy29I91KttScO3oniW3/wtxAR038NMXRK5EAA4oKIuzpWvIz1QaArl839Iki63LkIb3UFEqZQFKakRzPmOgX3G3JGNWgXGty3j7wRWQTrMPNKfLEANlNQeyOvl8yjpwVMMKEtEnIonx6Mn/a72iRUHJx2+nDRO3u95vYx1irtxsVifCgIj41qxemTOTlbdRYNdP681MMN9btutAnyND9Ksd5kAGZKkTQZlG946rNRTz2NQQVMuOoMWO6CxqkcENfIXKXaJMLR43LkWe4/98thkaXhJ9M45uU/OinTlsOKpHdqlme5CZw85xpaSli3i+K1zKTzOTCjPCq1/UHAPqdHOrNi5rk/cqN+w9MbCD0pbkEOjctltOWV5xfmpj8Io0udZEmQEKE0JARA1EAXT4pA7skQNIstbVxthOn4Va4N3cQXOuTirXlqcUbuYi7p4c7SUyr/wqACHXdODiqNVRGRUsDDNG+TBlC1cN11yorZGQdY1n4X/iNZDltF5zWK6/8Ey1cZifSrQ3W3/JPbiEuVDfGKt9TBz8VzVnMzResM8Rg1s
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(136003)(346002)(39860400002)(376002)(36840700001)(46966006)(83380400001)(36756003)(316002)(186003)(336012)(82310400003)(36906005)(26005)(70586007)(70206006)(36860700001)(34020700004)(4326008)(7636003)(16526019)(5660300002)(426003)(8936002)(6666004)(8676002)(356005)(2906002)(107886003)(110136005)(47076005)(2616005)(86362001)(82740400003)(478600001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2021 14:36:02.1923
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ac35e1b4-1192-4f01-014a-08d8e7bfa878
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT062.eop-nam11.prod.protection.outlook.com
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

