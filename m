Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D046318467C
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 13:06:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbgCMMGT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 08:06:19 -0400
Received: from mail-eopbgr60072.outbound.protection.outlook.com ([40.107.6.72]:5591
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726718AbgCMMGS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Mar 2020 08:06:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ln4OGSLJ8/r34jdfvxWjNTo6Fy2HPJS3HQdfdYM1u1e1h/s0cWg/drvats2jSP3wkMCklBYE1E/MpYrBA0hmyqfjMe+q97EmjJeYKPp7lvSzBUFqYfI/hlxgtUlk4ukWb8M5hvnR3OJ+wF/xnqk/4DfgdHcBV5V6VkBOQ7xtmM7UURNcYsfq29uvaxwNPwUibuyTdbP1V8wZYEMeGiCL4MVrd7U56ShS62Rd87Cd/n35JyQ+iK5S8wL9/iCcLwi53GLCwGOWDKyin0mumX1DG9Rdl6+gIsbsK3VFeTnVwEtFcIC8DmwKm/7Xi6OiTGibc6p08GaeN37Qpvqv6I93yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WSHsVWRUA6h4cuuomr4qxEx7OIT0l7kCD3VFppJlrdQ=;
 b=GIpAiavzfbXJJEm4iYE8QyQ7KcNeavi3KSJFQGkJcqRr2O10c1WQqh14ogavfzhss9f7W06PlCfUDMiXxo7F/HPTdH9z4Zb2DACaY3aXfh98tYlHL/E7eLWD48/950RVLGH3ujY7fHvoc/UAtEEn8TnjmtNYtVM+bb5eeHzxVx/lGrSasvtKXLH7xQ1C7Ck+68o5qV68h99m0VtuoHWIh+nnIdkJ6hdaPZK2AOJ97kwnBR/zMbmiVsvtIzcSbPlYsBkGPNaz4b+5qx9Y6XonEAMEPMCT6b2eTgXZOiL3Li80/fcqa16Q1zO/KSU5A7MifQ/tdxkrXbs+l73CDC56Ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WSHsVWRUA6h4cuuomr4qxEx7OIT0l7kCD3VFppJlrdQ=;
 b=gKoFfEoNubM4O2/mQO86kpnJOMcCey7UMQUTh1BDa8WFNTizNPs7Nc5Bc+J6MJBRALR/FPuZINQNXfGL/KG7UZImkDHoaAxkldNUGN/cTOJuz/TB8dtsmnGl5yvvr6SNsZ8olmZ4CjxiVuCtdWDOUk1QthPevUtWMwLEiWuEPKk=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (20.176.168.150) by
 HE1PR05MB3289.eurprd05.prod.outlook.com (10.170.247.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.17; Fri, 13 Mar 2020 12:06:12 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::c146:9acd:f4dc:4e32]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::c146:9acd:f4dc:4e32%7]) with mapi id 15.20.2793.018; Fri, 13 Mar 2020
 12:06:12 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     Petr Machata <petrm@mellanox.com>, Xin Long <lucien.xin@gmail.com>,
        William Tu <u9012063@gmail.com>
Subject: [PATCH iproute2-next] ip: link_gre: Do not send ERSPAN attributes to GRE tunnels
Date:   Fri, 13 Mar 2020 14:05:50 +0200
Message-Id: <404ccbc9216441393063948ad762f4ab3339fa44.1584101053.git.petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR2P264CA0040.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:101:1::28) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by PR2P264CA0040.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101:1::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.14 via Frontend Transport; Fri, 13 Mar 2020 12:06:11 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 011e162d-0d45-4fd0-0388-08d7c746ec73
X-MS-TrafficTypeDiagnostic: HE1PR05MB3289:|HE1PR05MB3289:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB3289290E0E38DF0AE9CBAC46DBFA0@HE1PR05MB3289.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:635;
X-Forefront-PRVS: 034119E4F6
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(376002)(366004)(136003)(396003)(199004)(54906003)(66556008)(5660300002)(6512007)(66946007)(316002)(956004)(478600001)(6666004)(66476007)(6506007)(86362001)(36756003)(16526019)(6916009)(26005)(2616005)(52116002)(4326008)(2906002)(186003)(8936002)(81166006)(8676002)(6486002)(81156014);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR05MB3289;H:HE1PR05MB4746.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bi+UYSpNdwTCkZiwikbYETVEAwimTOLC2ut3gCZ5jBn/q94GLKHenn6v5SqazMkb+MP3h9slaC1K81AvdRXGnKSu2issA+MLLVivXdqZ68yrqWhKpGRZZfOfBmw4XRL/hD4o26YYky1FkrEEI4NRerOHn8PjXjqGMMhUKbU1DyHc00qfy+7feCqBJWH/RXme5FT4zAj7EMOo5znIaH7Cs4YoSRuGzV66F91yFlCOKa0xBDn2zY6JvqR3lhX2zg3zp2CtIxpx4Sx+J7jErvrTvPk5EcK1SoieH+CfibQ7pn3c1HH8BgngBbSF7gNE4MymO1TA6+ssdPE8TwcwGpv+i/QJ+k/CqM+PYmg9KoQ9gH7v+pO89+f7PTwaPkuWYwtbwRE3auXVkkFEzYlDR2kCCSA74LJfTPLTzPmsvR05UW1YlnHiwAdpJ8qZuDaGAVxt
X-MS-Exchange-AntiSpam-MessageData: N0JqUWxNGiqejv+7Apu5k0yAK2jocpdUe0dQidlM11JCbnXDdfa9wOQQcaoGu7DDI3Ug+YaR4GE1Tl5n9thyqRAm37yehOo35Xim9IOGXmjK9fVmvEWQWyJNGfCnW4WrhL3SK7rfffkTsQWwNUpvnw==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 011e162d-0d45-4fd0-0388-08d7c746ec73
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2020 12:06:12.7311
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S5MT/C22G8lbPVCiQgyNtYprIZ8FwZ3D/w0qEKpV7+KqMWYauhumAsjMqKDas+F/6kjGPKQmRCr3y9TM+de8uA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3289
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the commit referenced below, ip link started sending ERSPAN-specific
attributes even for GRE and gretap tunnels. Fix by more carefully
distinguishing between the GRE/tap and ERSPAN modes. Do not show
ERSPAN-related help in GRE/tap mode, likewise do not accept ERSPAN
arguments, or send ERSPAN attributes.

Fixes: 83c543af872e ("erspan: set erspan_ver to 1 by default")
Signed-off-by: Petr Machata <petrm@mellanox.com>
---
 ip/link_gre.c | 34 ++++++++++++++++++++++------------
 1 file changed, 22 insertions(+), 12 deletions(-)

diff --git a/ip/link_gre.c b/ip/link_gre.c
index e42f21ae..d616a970 100644
--- a/ip/link_gre.c
+++ b/ip/link_gre.c
@@ -23,8 +23,15 @@
 #include "ip_common.h"
 #include "tunnel.h"
 
+static bool gre_is_erspan(struct link_util *lu)
+{
+	return !strcmp(lu->id, "erspan");
+}
+
 static void gre_print_help(struct link_util *lu, int argc, char **argv, FILE *f)
 {
+	bool is_erspan = gre_is_erspan(lu);
+
 	fprintf(f,
 		"Usage: ... %-9s	[ remote ADDR ]\n"
 		"			[ local ADDR ]\n"
@@ -44,18 +51,20 @@ static void gre_print_help(struct link_util *lu, int argc, char **argv, FILE *f)
 		"			[ encap-dport PORT ]\n"
 		"			[ [no]encap-csum ]\n"
 		"			[ [no]encap-csum6 ]\n"
-		"			[ [no]encap-remcsum ]\n"
-		"			[ erspan_ver version ]\n"
-		"			[ erspan IDX ]\n"
-		"			[ erspan_dir { ingress | egress } ]\n"
-		"			[ erspan_hwid hwid ]\n"
+		"			[ [no]encap-remcsum ]\n", lu->id);
+	if (is_erspan)
+		fprintf(f,
+			"			[ erspan_ver version ]\n"
+			"			[ erspan IDX ]\n"
+			"			[ erspan_dir { ingress | egress } ]\n"
+			"			[ erspan_hwid hwid ]\n");
+	fprintf(f,
 		"\n"
 		"Where:	ADDR := { IP_ADDRESS | any }\n"
 		"	TOS  := { NUMBER | inherit }\n"
 		"	TTL  := { 1..255 | inherit }\n"
 		"	KEY  := { DOTTED_QUAD | NUMBER }\n"
-		"	MARK := { 0x0..0xffffffff }\n",
-		lu->id);
+		"	MARK := { 0x0..0xffffffff }\n");
 }
 
 static int gre_parse_opt(struct link_util *lu, int argc, char **argv,
@@ -93,6 +102,7 @@ static int gre_parse_opt(struct link_util *lu, int argc, char **argv,
 	__u16 encapdport = 0;
 	__u8 metadata = 0;
 	__u32 fwmark = 0;
+	bool is_erspan = gre_is_erspan(lu);
 	__u32 erspan_idx = 0;
 	__u8 erspan_ver = 1;
 	__u8 erspan_dir = 0;
@@ -334,19 +344,19 @@ get_failed:
 			NEXT_ARG();
 			if (get_u32(&fwmark, *argv, 0))
 				invarg("invalid fwmark\n", *argv);
-		} else if (strcmp(*argv, "erspan") == 0) {
+		} else if (is_erspan && strcmp(*argv, "erspan") == 0) {
 			NEXT_ARG();
 			if (get_u32(&erspan_idx, *argv, 0))
 				invarg("invalid erspan index\n", *argv);
 			if (erspan_idx & ~((1<<20) - 1) || erspan_idx == 0)
 				invarg("erspan index must be > 0 and <= 20-bit\n", *argv);
-		} else if (strcmp(*argv, "erspan_ver") == 0) {
+		} else if (is_erspan && strcmp(*argv, "erspan_ver") == 0) {
 			NEXT_ARG();
 			if (get_u8(&erspan_ver, *argv, 0))
 				invarg("invalid erspan version\n", *argv);
 			if (erspan_ver != 1 && erspan_ver != 2)
 				invarg("erspan version must be 1 or 2\n", *argv);
-		} else if (strcmp(*argv, "erspan_dir") == 0) {
+		} else if (is_erspan && strcmp(*argv, "erspan_dir") == 0) {
 			NEXT_ARG();
 			if (matches(*argv, "ingress") == 0)
 				erspan_dir = 0;
@@ -354,7 +364,7 @@ get_failed:
 				erspan_dir = 1;
 			else
 				invarg("Invalid erspan direction.", *argv);
-		} else if (strcmp(*argv, "erspan_hwid") == 0) {
+		} else if (is_erspan && strcmp(*argv, "erspan_hwid") == 0) {
 			NEXT_ARG();
 			if (get_u16(&erspan_hwid, *argv, 0))
 				invarg("invalid erspan hwid\n", *argv);
@@ -402,7 +412,7 @@ get_failed:
 		addattr32(n, 1024, IFLA_GRE_LINK, link);
 	addattr_l(n, 1024, IFLA_GRE_TTL, &ttl, 1);
 	addattr32(n, 1024, IFLA_GRE_FWMARK, fwmark);
-	if (erspan_ver) {
+	if (is_erspan) {
 		addattr8(n, 1024, IFLA_GRE_ERSPAN_VER, erspan_ver);
 		if (erspan_ver == 1 && erspan_idx != 0) {
 			addattr32(n, 1024, IFLA_GRE_ERSPAN_INDEX, erspan_idx);
-- 
2.20.1

