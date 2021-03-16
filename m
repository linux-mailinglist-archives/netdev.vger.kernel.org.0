Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D33133D1B1
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 11:21:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236650AbhCPKVd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 06:21:33 -0400
Received: from mail-bn7nam10on2061.outbound.protection.outlook.com ([40.107.92.61]:10624
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236515AbhCPKVT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 06:21:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k4FI6S0WkBIe5DwCZvN43+PfF5Ec3IYSzN5cNHPts2O+FP3Pqvf3l5LGsEtxdWURl5lDJhYHs2Z+viP803/wLMZtYHbZA5kFYx/YN6T6jvw05Qt28wsN3xxZlUHzgW3n+FDu+Vcd3X3TdfUz4IreMa2XrkDIV0ys4Nj9KoLNYsIJhx0gKxNlGnVsL2aO7kN4UqGe8RT/qTkeE6HtHEh16Ndh/mw959daV5hXC93HOyZkJwFLv1N0GXUyDJ0hskarlYtS6D3tt+tp1Fx72qRk1yj80sZBAfzDlRcnra/OW+oG6hXqZkl3Z1zF3kslZLx8pdZ3wZ+DWvzuQN+Qfi9E0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kbK56gGFmoBORbU13R8xybyktbdidQJWj1OJjfiYu54=;
 b=dh3RCcpkry8xmM6xEfTiK5YC/cZBH9Tm1RqvVTn35tPCa1upUte1xzrA6xPReM0jlfQnHfJ+mVLxW71ipH72tC0yBXm5XGdY9Etg3NYL+gyi6W+3CvWu80HkUL4l2b2faljJeH0jJqwV29O6LDXX95j68tf/Z3FJqVBEtJX20JlvlAOkGZtEUDqbA5nD2TNrGfrsmRU5j9qnCTrtAFNG82273s4PQV/kr3uP+zREawMO0tHp5hzqbdf0IMtJGf3yjeUjMoAxbcrg8rTIjoVa+TtlP07RouaxQzYzoyr5I6HAT/e885fPRN385cmbt6jl9pElzcEome+IE6pqPavqjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kbK56gGFmoBORbU13R8xybyktbdidQJWj1OJjfiYu54=;
 b=HWSVvxsDlSF1iYayEWv5rPwdLexh5NyVxsggkmmCdBTJUUvf7fbtaHEMNLnPpfKANIL3DDpIdncKibTTk1JyouyXTxdjshORCs0+lErTTAniHe0DBOZs/pqTdCH1Ew67nr7O3fqXKkEmbZEbLVbu/iAEhQcWZNz7ZIgHaPI8WqSkHaDObhGgwkPwRTK7eSMcmbo8QQdiCWTHkI6mLU2HcAnnap1IOKbzz5iCurYtcKiRmEcImQr7pVP0muEg8D/S/7jOMbAOuEryXPGgghhyqTuqAyAygOfQCR7yi5z7YIUX2eQMjVfMqSzhaeUxf6/4SknrS3W8Zz0vyiBqQtQAfw==
Received: from BN6PR2001CA0020.namprd20.prod.outlook.com
 (2603:10b6:404:b4::30) by DM5PR12MB1609.namprd12.prod.outlook.com
 (2603:10b6:4:10::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Tue, 16 Mar
 2021 10:21:16 +0000
Received: from BN8NAM11FT066.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:b4:cafe::52) by BN6PR2001CA0020.outlook.office365.com
 (2603:10b6:404:b4::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend
 Transport; Tue, 16 Mar 2021 10:21:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT066.mail.protection.outlook.com (10.13.177.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Tue, 16 Mar 2021 10:21:16 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 16 Mar
 2021 10:21:09 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>, <dsahern@gmail.com>,
        <stephen@networkplumber.org>
CC:     Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>
Subject: [PATCH iproute2-next v3 4/6] nexthop: Add ability to specify group type
Date:   Tue, 16 Mar 2021 11:20:14 +0100
Message-ID: <c5d5098bebdb7012855199b7feedc3b9ce40f3bb.1615889875.git.petrm@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: 45315b63-b33c-4772-c77e-08d8e8653beb
X-MS-TrafficTypeDiagnostic: DM5PR12MB1609:
X-Microsoft-Antispam-PRVS: <DM5PR12MB160980BBD9A337FF68E699BCD66B9@DM5PR12MB1609.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:849;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xw++PTmXdUh6Kh0xP/lmPet1uW9/vdyRpFFevTbPh+GBTNsxF4pZ0RSUPuKI3J86v9DDlUMIBUH0/o1zIHhDOhu5m4WPhB/X1gdi3/UW7JgXEDoeWHllDhFw8MDmbECJJhMGhrjaKDFeC3/zk7Fez6s+4ZJ9efABnQ50w7HQmREWbjjYeGdLqzzMjAt9rmXdW98nCti5mJpkhArN2hgRtu2mXG7Qg93+oUb8JaDb3USGzKINH+FI1T9XecOC83+9osnUy+H5ximE1N+b7cvmuBdZBsawS70exhlr5V3eHv12f+R/6ACMeU8bhH70B8yADs38ECUMOjKoKDtS8BwNKqxWqYpX9/rNPM2CVUM4JUwqidO6h2aOFhw60XfvpYmF9Rh+j47YGHYN+7MkiVL7joYYcau+Z4bE5JT4SOc7YsUNrkBCud0aQgqG6lbtO2400F6ujOiOElv4Ju8zZ1iiQo9kn7fsmFPE2rPyeQ7G989wMXpmRggLx90cBNNycN3fL+BMCLKJVjAlKkQhxOW2yoNYYqSsJA9MmQjGgaLXBUln12urZNUGJ3sT648lnXlKXJ1SWCmiQNhgdtuWiio0CAE++zw0yRzQ16V/SFgwNCTIQXYkOMrwUyDhZ1PO5PV5U7kAapV7sn95BrjcBj7rZiRGPO+uJs6tcXGLhusRWGw2PCTpVxN4U0e3Ca3BlSxM
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(39860400002)(346002)(396003)(136003)(36840700001)(46966006)(26005)(36906005)(4326008)(478600001)(110136005)(186003)(6666004)(54906003)(16526019)(8936002)(316002)(36860700001)(2906002)(70586007)(86362001)(8676002)(107886003)(47076005)(426003)(83380400001)(36756003)(82740400003)(7636003)(2616005)(5660300002)(70206006)(34020700004)(356005)(336012)(82310400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2021 10:21:16.5844
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 45315b63-b33c-4772-c77e-08d8e8653beb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT066.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1609
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
Signed-off-by: Petr Machata <petrm@nvidia.com>
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

