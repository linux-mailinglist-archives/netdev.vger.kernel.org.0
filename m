Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4DA3394A2
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 18:25:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232859AbhCLRYj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 12:24:39 -0500
Received: from mail-dm6nam11on2063.outbound.protection.outlook.com ([40.107.223.63]:38976
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232627AbhCLRYW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 12:24:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BZXXRI9QVfreb/yNL4heYZVPNGdj2IRQOkmlvO7bpTw9v4S3VgIfB1VloVO+3yqqOAHZK5lF5zHmQm6BWozHl2FfRMqr1lDKgIh7LcNhAVAKIqVRu05nmL9m3a1wT0mXEDd8e9oFYpPn18AIx6sYqKE6Kl7Bsd9UMEtBBgK2O1KrprZywxesYId/hl/yyOnrHgqKubfKBJl+2NRlQtDXJMes2pJimxOTmINchvGrIEYCHnTpctB/eZ+MJ0Iaerh1M4cyMmk3HUPWceqqNaYpioTMDEwSrwVoOCYSS6Bi+vEcV2P0fa+hVi1B2y9w801RpbyMX2biDdqg/pFVTxAy1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6QHLq81fz4D3mIYsSmlD+z+TChfg8JmFwbBAAcprJuE=;
 b=fMjVPUfiFj6hQsainp5Salf+pNA8p6MEiWfSNNc/6JJ/aooCe5LFxg68yGSQNubZsSyWNldlDechjdFHdDMwhZ+IkWpO/Fn12p8IbQqv70ZTSTKhGAC9QOfcblmKxyMM+gFFC1k4ptMlpT/3fRGH2wEzQHQhXoCBmWYnHziEdYFun6cZ1Gb/FUVDlQcEO1G+2rIS3QF21A7RF6MWPsSOpb0gWWA24q8cIhIYK8DH1Ji+J6DyLdrTbqk1Sjx8K9kqKXGPyr8EDgC1ajYI3P2jDlGXVB86ZumJBcSEF+Salm85rhM65QK0aDn1BaT+D03aBPNO8MP/sObP1Y70BBxF3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6QHLq81fz4D3mIYsSmlD+z+TChfg8JmFwbBAAcprJuE=;
 b=rUB/30rPpRhi9akF8AyMUTrhbGEVhGUUSILl3MCIAfYNqqpxv/wBssT0d1dyshkdIu6dGK7Bpjvpd7ggOeQ9UvQv4gagJv+Ao0AFhhfu4B/li/QKsFbVbzShgGY4YhYE3k5tMx7thYWnRuPf87ir6IAPEg3Zr56WzpSH7djEpig10992K+gc2mCB0nu75GwdOg50B5O+g/kUdQZFX3FZXeuPorH46v+PIR16tnJZg/Dr2FSkic+Nqvkyr2FjT7JH0acNiLlA83s6mI1LwdHzRRzFKDbz51TFfN3EsIm9bs5VDrbHFbWGRz/lL+ZaRaE0BREwi7t3VbdNq2mh1gb1Tg==
Received: from MWHPR1601CA0023.namprd16.prod.outlook.com
 (2603:10b6:300:da::33) by MN2PR12MB3120.namprd12.prod.outlook.com
 (2603:10b6:208:cf::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Fri, 12 Mar
 2021 17:24:19 +0000
Received: from CO1NAM11FT045.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:da:cafe::74) by MWHPR1601CA0023.outlook.office365.com
 (2603:10b6:300:da::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.26 via Frontend
 Transport; Fri, 12 Mar 2021 17:24:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT045.mail.protection.outlook.com (10.13.175.181) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Fri, 12 Mar 2021 17:24:19 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 12 Mar
 2021 17:24:16 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>, <dsahern@gmail.com>,
        <stephen@networkplumber.org>
CC:     Ido Schimmel <idosch@nvidia.com>, Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2-next 5/6] nexthop: Add support for resilient nexthop groups
Date:   Fri, 12 Mar 2021 18:23:08 +0100
Message-ID: <50c7ea2e4398f703e9e78c461f8ca7dea3e703f8.1615568866.git.petrm@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: b7ab671e-d6ea-4702-e454-08d8e57bab70
X-MS-TrafficTypeDiagnostic: MN2PR12MB3120:
X-Microsoft-Antispam-PRVS: <MN2PR12MB3120A788EB7B3862478F6C80D66F9@MN2PR12MB3120.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wRT7k9t7QjkFXwq9z0xhtWti2T4Yy3AV8qtYf9wbHagZjDmJgwkt4dku1MnvBpVS63jhctb3i4GxoBnwF2/KsSu6za3y3QI6m0Gr1le1+TIGg+GyGRAPNM14O9OPnVQhgyac+1VHvjxCyl98GNoJ3+Im62gpp7w9m1/IfL6Mf5ZwD/dS4k2xcB/Kj0nxM9QakFwAS2kIiC//Hts8Getjw27CzSyUJo8Lmlyo0uFRwzxnUVusBroH5eKRT1QA4R8qoGbQK+QAMZcgzaNX/cN1AjwyetdHmdKAaxhFXzeCfYrozfYGEPewCUIjcZcc+FLWCd7GC26Vead3Q/9k0FEHNs8TX8h/gOkJaemoa1ezwNVB0zgB3YPA6XhxP7PnTgSmVVZL8euqHlGbOlsTUF5Tp3XfEcf6fmC3yoUYSwqJ79uw3Tv19NGeNcH6/ZzKgiAxQ/3J6ow+EaKjoj/DmzPKxtwjPVqsj4dJe4FP8pJlI2gr585FgAZIAySb6lM4jpETnQUCwCYLV5nXcalU480mGWpAVCQikTpQEvIQkceVn6cICu8J331DuqdULFRotIq+8A51ZnM0ygn+0eJ7TNDKGb1UcA5O8jYfesyLlvpiVkgEDvRptoLZWbTvz8q0PahPh9j2PKpgsjAbTw9hc4rMkxOAmo+rkhZVYVfkz6JCpw/OGZVTsYppFqPeAabw88A9
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(39860400002)(396003)(36840700001)(46966006)(2616005)(34020700004)(82310400003)(36756003)(426003)(316002)(36906005)(336012)(86362001)(36860700001)(83380400001)(47076005)(26005)(186003)(356005)(6666004)(2906002)(82740400003)(478600001)(110136005)(16526019)(5660300002)(8936002)(70206006)(70586007)(54906003)(4326008)(7636003)(8676002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2021 17:24:19.1606
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b7ab671e-d6ea-4702-e454-08d8e57bab70
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT045.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3120
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <me@pmachata.org>

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
index f02e0555a000..c68fcc0f9cf5 100644
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
@@ -138,6 +151,37 @@ is a string specifying the nexthop group type. Namely:
 .in +8
 .BI mpath
 - multipath nexthop group
+.sp
+.BI resilient
+- resilient nexthop group. Group is resilient to addition and deletion of
+nexthops
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
@@ -224,6 +268,11 @@ ip nexthop add id 7 group 5/6 fdb
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

