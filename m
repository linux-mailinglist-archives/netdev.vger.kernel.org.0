Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 020E33394A0
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 18:25:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232804AbhCLRYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 12:24:38 -0500
Received: from mail-dm6nam12on2064.outbound.protection.outlook.com ([40.107.243.64]:36896
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232590AbhCLRYT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 12:24:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fsqGNaQfG8d/7trjd/XqmNqNow1FeH7t6mjLqfHEzhErzb8+jZd/SxHRanrJO3FrjEEZ+fGxtm10EEVkyVgOZy8QE9EHemugfl5IhmbQFLNDgrRcTA//IOVl+l/fSqE0gswDLTtgs6d2lHxQks0BplUqAfMjGNYnfmbeJbnSPhGu5tJ5sh7hSjWIs30BD8IMZVrBddPGcQ37bYKpqb8UEjslRhK6tJTnJYr2/wOaWfsCpJSnfmHeyZcyhvB7ka0enWScIZ0tOeFyg2u1NZb74NrlNSh2S/8jXYaaPBxD4+hjo139Uyvj7zbwZN+w4w5vm54nKM526E8g9gOEMbAm7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pwd5zm7DY9tbzAkTvovHNlt/ssa2LcupvbcS35NeCJQ=;
 b=HkUo/2yfqlnNnL03s2QcfeFShUmdPS740IxWovp+pW0WmsyAtbjKK+LZLK3TYgeef+XtCQdLVi8DoXRjFoGNQeaB40hEOnu8vMuuRl3IDbVl86rKgXfV+NNxpmiYdP/1AemjEbpUchwByadzHowlMRO/jJcCWrny0PNYpmWMj4ZShSPBjI0xVmgIK2bZwM1eJJQP7WlvtJWl2KE92Eb7O/Ja8TAiE3gmgi8QeZ5lNTFGugC436rUK08WXo1JdIPYa79T3lGAZ4xP33erAjZeMMSTYYliZIzQNWFVtmqLq28A8D9gnsrJv0OwztSr1KOSMNy46JkrBqLqOQ8oAF+czQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pwd5zm7DY9tbzAkTvovHNlt/ssa2LcupvbcS35NeCJQ=;
 b=cA+7HQWYxg+d73h3QN98ELGRg9d4aZKbAI8rKlUchVNK1S1oc5cRJ3BKrH09zQo2WfKLvRER8TyEB///lJhyWQtol2hrA6deg+GYKDxctuLoJU9n7UFHn7+ljG9n6cR/IdgKYLF5rYNjmz7Rx8y4FIMVdjNCKlHOfo82uuy+sYnivyREN131KJDaJYfY+FrTgFfJJZZovoJZ5h1OC7vB1cyNUFJVNHRC9m14d/2wSOFy1bn+3BoSp69TNmKyAQqP+Jq+G5gj6zivlHiZ/360TbWkwDQvfEqDRnjDyJL21BmgoJyUedPxoFbIjNhGhTXxGfRF7M07p2rPtoqjHU/Dzw==
Received: from MWHPR14CA0031.namprd14.prod.outlook.com (2603:10b6:300:12b::17)
 by BY5PR12MB3906.namprd12.prod.outlook.com (2603:10b6:a03:1a9::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.26; Fri, 12 Mar
 2021 17:24:16 +0000
Received: from CO1NAM11FT058.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:12b:cafe::4d) by MWHPR14CA0031.outlook.office365.com
 (2603:10b6:300:12b::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31 via Frontend
 Transport; Fri, 12 Mar 2021 17:24:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT058.mail.protection.outlook.com (10.13.174.164) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Fri, 12 Mar 2021 17:24:16 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 12 Mar
 2021 17:24:13 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>, <dsahern@gmail.com>,
        <stephen@networkplumber.org>
CC:     Ido Schimmel <idosch@nvidia.com>, Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2-next 4/6] nexthop: Add ability to specify group type
Date:   Fri, 12 Mar 2021 18:23:07 +0100
Message-ID: <b614d787896a33481e09487deec42b482fdc8643.1615568866.git.petrm@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: 3b14b46e-804c-406c-5a41-08d8e57ba9d4
X-MS-TrafficTypeDiagnostic: BY5PR12MB3906:
X-Microsoft-Antispam-PRVS: <BY5PR12MB39069CE102981D3AE5817D36D66F9@BY5PR12MB3906.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tITje3HVE7eVBXJQbxjjxn9s94T0eUcJU894NdBQo64xo4BdJOdhOfpIRTamnABo3yCbh8EcSZ5zPPCLX3YUBzQf+ixb39uaKuM/PR1XpHaY1YTWcr1y3Dgs0H30ApQIFuUtdeFzDWxBNGxVLRtufTMboa4qbTtIOq3FX9tZgacdaBhX/uqdGV6kCgCyL4mxTQlAPeeQFY0HFxDyerDJgExfyv19qwkiQscxkEf/xGRgvTpb/wLddYnUQQFIMhh82yEjvxre0rdggkiThLQS37/Ulby1sovACOX9ccS/yUri43InTi5rxJjPGjck72C5onhqYrHQVbEb5MptGAuLqDocFaRbdWX2k/TIQRY3JJHbcnu04l1o1haoiNpMG81pekshZILt20P/cCydkve0DhJ1vPngqpgXB8yw5gEFETDFiJjsmlBWpJ0AJyVJvYCbZpnOX/5nlLfC1nyVM/go80H1xhV/h1Gi8tlPOtiMfEOcAAQ5gD2BUjxZBKdSWmNHEXE9APliiOD4lwyXe1ibWeRQLnXZOO+k+3bdclxMd1iooS2BYx7zvZvz1OdnWiMj/LSSUht1N+ESCpQkBSNsbCvGaxkAlpaCUeeo+xJC4LEpSLBl9CBAoLNqXzix3IbJ0UCJGyJgyWES44k5zZYp1jt3/l0zG2RkUROPvp2IMqFIVY0LvcJD17dyzcV5woGC
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(396003)(136003)(36840700001)(46966006)(70206006)(82310400003)(47076005)(110136005)(356005)(34020700004)(83380400001)(7636003)(16526019)(6666004)(70586007)(36906005)(8676002)(54906003)(478600001)(2906002)(2616005)(5660300002)(316002)(336012)(36860700001)(186003)(82740400003)(426003)(86362001)(4326008)(26005)(8936002)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2021 17:24:16.4860
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b14b46e-804c-406c-5a41-08d8e57ba9d4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT058.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3906
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <me@pmachata.org>

From: Ido Schimmel <idosch@nvidia.com>

Next patches are going to add a 'resilient' nexthop group type, so allow
users to specify the type using the 'type' argument. Currently, only
'mpath' type is supported.

These two command are equivalent:

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 ip/ipnexthop.c        | 32 +++++++++++++++++++++++++++++++-
 man/man8/ip-nexthop.8 | 18 ++++++++++++++++--
 2 files changed, 47 insertions(+), 3 deletions(-)

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
index 4d55f4dbcc75..f02e0555a000 100644
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
@@ -122,9 +128,17 @@ is a set of encapsulation attributes specific to the
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
+- multipath nexthop group
+
 .TP
 .B blackhole
 create a blackhole nexthop
-- 
2.26.2

