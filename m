Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CFBE33F0C0
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 13:56:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230317AbhCQMzd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 08:55:33 -0400
Received: from mail-bn8nam12on2041.outbound.protection.outlook.com ([40.107.237.41]:31923
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230035AbhCQMzP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Mar 2021 08:55:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=clV/vJ0dmg5btxa/yz29yw1uwPUp6S3kQDGU3ep0mCo7fxIq5vNMYQNxGUcmnGygHwUzlI29QFftru46WmpRzPfKSVZTzDSYuylVbAcQ6+uAVXSUrm9XeeXaKNr4u2oO3XWbRRZR4A2av9b52s56bcI4ewaD2TI4k9wACGiioL8QhHmbg31WAj9fFaorcKd6DaYsG9RWjiT6peTdvWVYtHyZ/hbPasmzG8XEPfXFjktoOrs5cTwVy+L0SvpwEYF0DoXCMNDtuGajwtZ6X7Fl/zDWOYFDA3hSiOj8nKlf0hTcLMsIt/iZtMdqCWRuxQdcm6GfD/G6je0CyXAL51wvBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kbK56gGFmoBORbU13R8xybyktbdidQJWj1OJjfiYu54=;
 b=AU9pYjVc7eIksxW4xXTFx126wuUD1lb44UYyXSqA1Kzg4sC3vakh/V1Nmrpnzks01XdxZrbcFb6uvnx0j5OldejjhYYo7F1gscGuimN+Bsrf9sH1f1EnLpVswKpYpqKeh/qVYVPTHH4YWUj2g3lrGRf6HYeO3m2bhAEqcp5BWrj0ay3tpThcmN68R7CO5jRJqLO4E+SqJhl6Ui4z1RiqMZMHGDg2ebCfr0Ala0Y75UztEaRJrxadxA4rlWF4fdzSf/LgIG8merKVxoxvt6ClOGqyYbGDWq4colIa10uUvJcB4YIlJrhInWZhVBdRt9m0kgL+FDKMG05papulG9g+Bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kbK56gGFmoBORbU13R8xybyktbdidQJWj1OJjfiYu54=;
 b=lYXwfqdvCq/6pMBbbcUTUSsBcCsnOjN9TJUgsCKNK/vw84FB/zxcnKptLsxtlhFkrLLLyNkyYKTxOhR/tDwbnHGq1vOngZlc8VB2/OnSsmRcUGytyozISLMQiwMhDyRe2u8z2GuPP5yWSx7TG4JQH8VSFdILx87ec5hd641xINtFfcNGioKE5iRBbOcTQRtFaXWtZE356O8E6F4LZ68uma0qwFk6JNEDHDpS/E1hcv38JoY0T2WzB+PUBBA2LjU6xH4UbuwMrOBml8vxIKMkozFo6Zidl2KTpd5kxqHkmdkrWHGv7moC+uujfBA2elk9K+alLA+LpSXu12ISkjt2mQ==
Received: from DM5PR06CA0033.namprd06.prod.outlook.com (2603:10b6:3:5d::19) by
 DM6PR12MB3724.namprd12.prod.outlook.com (2603:10b6:5:1c9::31) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3933.32; Wed, 17 Mar 2021 12:55:13 +0000
Received: from DM6NAM11FT021.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:5d:cafe::9) by DM5PR06CA0033.outlook.office365.com
 (2603:10b6:3:5d::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend
 Transport; Wed, 17 Mar 2021 12:55:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT021.mail.protection.outlook.com (10.13.173.76) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3955.18 via Frontend Transport; Wed, 17 Mar 2021 12:55:13 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 17 Mar
 2021 12:55:10 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>, <dsahern@gmail.com>,
        <stephen@networkplumber.org>
CC:     Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>
Subject: [PATCH iproute2-next v4 4/6] nexthop: Add ability to specify group type
Date:   Wed, 17 Mar 2021 13:54:33 +0100
Message-ID: <c4c5f1e9896eaea88e9178f48a43d573d8401242.1615985531.git.petrm@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: 561cf974-7c30-416a-7b32-08d8e943e7ca
X-MS-TrafficTypeDiagnostic: DM6PR12MB3724:
X-Microsoft-Antispam-PRVS: <DM6PR12MB372422E921C165D363624D7DD66A9@DM6PR12MB3724.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:849;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cGBpJHX568mic2kT/+ZMor5d5tCn810qipR9T+HVjeFwmHXD2TjZnLX6GJfq0zZ7NULfPZj6QM17cQWh2W7wdMvcl9AaAx4oo3jAn0xpdd7F43rHXS5NAPGoD+3DamoHB4jQpqesKIYTu3Dx8BDoiJk6ms5Tn+3E5uBYaeK6mRh/4k94PGxuSwbRC/YBnnVzHxk381z/J3hlX9/iRiFoC8Jv2oFAIT+quVfGnvla52dS1/vzrHiyi/43vpcOwF8cJTs9wEhOaVywiupGmHGWFch5+WSso8p9RExG2ApzROzjjjdLYPLPnYVLnbcoECqt8F0U3RdaiLFMABrkTStTqOiOxUog1tQzGqjN5+jUv0rzO8Ch7Hqygbefm1mTipIpPuRkA8N6NCxrqJZgUmam3E1f9YEgzebO5U4SQE7v5U2IEHCoHRnaSCnQlAd7PQqZugGH5cneeupICQlTHA4dpslVO2uoWzgi9Yq94DK7ANE4vh0GajyjTroqFAoq6KkQJjEHHu64RHZy/prjTg5tPlaQGlB3pb/SP6khkgVPG/V1jSyo63N5B7lWZj+VP9GsIY+oq+AUFAVWv6qgbe0Rega1TDTRFxH7eZWDJF/rBa2ZgjF1mx9LLbsMMAgX9TT+Xaj9vimXGU0/GKcjjJs0DUFiTa+gvWM2+gDCa0YIxpmRXJrCmEivVCOL9VPYpJiT
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(39860400002)(396003)(136003)(376002)(36840700001)(46966006)(70206006)(8936002)(107886003)(5660300002)(7636003)(316002)(8676002)(36906005)(86362001)(356005)(47076005)(70586007)(478600001)(82740400003)(16526019)(82310400003)(2616005)(186003)(26005)(36756003)(6666004)(2906002)(426003)(34020700004)(36860700001)(4326008)(54906003)(110136005)(83380400001)(336012);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2021 12:55:13.2743
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 561cf974-7c30-416a-7b32-08d8e943e7ca
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT021.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3724
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

