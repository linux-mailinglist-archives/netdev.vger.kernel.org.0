Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDD9B39F4DC
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 13:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231866AbhFHLYz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 07:24:55 -0400
Received: from mail-bn8nam11on2087.outbound.protection.outlook.com ([40.107.236.87]:4609
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231790AbhFHLYy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Jun 2021 07:24:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IYXg+sEqK2bedfoiI8IU9XUcumim6vqvz4Ah6ploSfMs5QBk9jYgQTV+Yr2QKxaVU4p1+ZRYrJlWMSkbsiS4vz9eNyG1JH4dLxDJt9/N4u1khQ7Dg8Eyj5rO8IFcin7m/qvYqcXWXWb8KpFpcYfKy44duvJ2wIX2vw6s0ArhA8MG6T3nwbQETWnOiYnor+yy4hBefBKKXrEbm63OZPzuNb1tDMsu6Y5WVcfzgfLDvL+ioks4w1aUwNk/sAjQn/ucM+zf3sQV69t7pOA2Vh8qdTwpJOUZktxyadxH1k8KWN5OdcFzGNI8nndd7T1pOJtOhii+6ra0PrMaAVz1aFaXjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Av+jZiq34Y4L5s4TqHcxgJy+HFoRfapdBoFa+53VYM=;
 b=I1ZR6lefPvq5F0EidUuyws9NYdTtBSZuN8H2Xj1H26Hu/meemaumFEZQnbroFHJ5SDzgcofJNBSz7uPJeYoqXNtvswgM3ZNx3X+ZVwhy4VwUkZFCFiKqtlBTjWVINp+njNrrJ63z/mTMRonsYQdF2BmczJHNvJ46yuaSOc2osFLBoi1Hj6QZ1acgI5MVNEP1fPgX/41/3LCEfBlRp/Ywv9ta5sBMKPYONZPkdfQ2aKNClM8V4oTjn/h/pMvvcbZI7ZclWuCZcVrRir+WDeswX3CnMzFlqQQtTL+KnlYw5syALLU7UdiX2/qEbHEGaDYVypza66eDbxiDUGnJcsMU9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Av+jZiq34Y4L5s4TqHcxgJy+HFoRfapdBoFa+53VYM=;
 b=I26VAcu1Bx5g3RLeV/PcNKR9NjKJpMhqafJEKq6ybSypX/X6n5Lldk5ncHJCmNIYMV7QaSe33/j0mtNMrceiYmcIyM5Q9KOcFWbifa9OmXbu0eYcSi9hPYsqrNvlBbtDmRsQu8gkd3K8K1JWPKL4CKzejapgojUaorG5kxliOpLl4a1YoziAmP2Q4/3mhJPIzP0vIttNjxMG40qz9npGRPyABYuEmxnZJyoCrujGFiQHa3HwQ77IWtIG/nSbMTQObX13KQKPgCsmP6A4YdiDaPCOPI8kYvx+K5HYfhWjtBQHvcTUwCt58gRyoruuZV3I0lkeH5Pl5RQnkNtJUhLwkQ==
Received: from BN0PR04CA0181.namprd04.prod.outlook.com (2603:10b6:408:e9::6)
 by MN2PR12MB3326.namprd12.prod.outlook.com (2603:10b6:208:cb::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.23; Tue, 8 Jun
 2021 11:23:00 +0000
Received: from BN8NAM11FT038.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e9:cafe::c4) by BN0PR04CA0181.outlook.office365.com
 (2603:10b6:408:e9::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20 via Frontend
 Transport; Tue, 8 Jun 2021 11:23:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 BN8NAM11FT038.mail.protection.outlook.com (10.13.176.246) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4195.22 via Frontend Transport; Tue, 8 Jun 2021 11:23:00 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 8 Jun
 2021 11:22:59 +0000
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 8 Jun 2021 11:22:52 +0000
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <dsahern@gmail.com>, <stephen@networkplumber.org>,
        <vladbu@nvidia.com>, <parav@nvidia.com>, <huyn@nvidia.com>,
        <dlinkin@nvidia.com>
Subject: [PATCH RESEND iproute2 net-next 4/4] devlink: Add ISO/IEC switch
Date:   Tue, 8 Jun 2021 14:22:34 +0300
Message-ID: <1623151354-30930-5-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1623151354-30930-1-git-send-email-dlinkin@nvidia.com>
References: <1623151354-30930-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 438c7776-6317-4b6a-b44e-08d92a6fc626
X-MS-TrafficTypeDiagnostic: MN2PR12MB3326:
X-Microsoft-Antispam-PRVS: <MN2PR12MB33264D36F06CD8FDEDFF094DCB379@MN2PR12MB3326.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:626;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cYo2dcTUbitenstsFBaGIzYg0w+EsrW3W2nZH1FV62f6FBFj5FwjrO+N3bZtR4A3suYVI3wxxJz0Ap4QfqITsHXqH1MJqETb8aGgMjQwBvXIaCR/iUDDzAbkrCzcOO3Vq5jvOPw96nSmHMAFX+ZDN7PfztafvfPYOFDWMe33do93Xe7YT6niITHOD/ErOEc7vJ4Z02wos2w4F+AXcZdP7WXE97f9nUTHcc2uMpYCRvYL8QDJ8HrbxoRoMCPk/pgJxxJYHBCadzp9TlWbaYbCfCPsMP5gDfiDyx6WQxCAjzQuxaQvk+GNG2t341qdQdnuBZ/gaUbZxTiBg8VZTRi14nlFi3LRsJhe48O/BKzqOdlLmsaH/i1ccyIFcjgDl9jue/iVEf8VvrxdVTrWHmtWvTIZtwwgGcDU2SZsaGc6tg9g85WMNR9BN7MLHiMeHiveKid3K55s1wbqlp6HdoFxaYC4ZmhVzISQmkTkb6ogBjTthskAQ9R3D1WXe1fD7V12xn73F8wYnD3Ot3yMSxf3LcEUGVsA4ZJkRi2NS6JcY976/wK9zRPs0jhSpTm9cpoddleuxDoq7yXBKiQuKG+//7csb4A94BocsVePd97QN/iFfGDyJi/zMcL1uN99sqG3498Dax3XwKmdaN3kidfJ6Ey19XQl/YehCmrBWHJYvaE=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(136003)(376002)(396003)(346002)(36840700001)(46966006)(2616005)(54906003)(86362001)(7696005)(36756003)(2906002)(47076005)(186003)(6916009)(107886003)(36860700001)(5660300002)(478600001)(336012)(426003)(82310400003)(4326008)(2876002)(70206006)(83380400001)(70586007)(8936002)(7636003)(26005)(8676002)(82740400003)(6666004)(316002)(36906005)(356005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2021 11:23:00.2070
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 438c7776-6317-4b6a-b44e-08d92a6fc626
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT038.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3326
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmytro Linkin <dlinkin@nvidia.com>

Add -i/--iec switch to print rate values using binary prefixes.
Update devlink(8) and devlink-rate(8) pages.

Signed-off-by: Dmytro Linkin <dlinkin@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 devlink/devlink.c       | 12 +++++++++---
 man/man8/devlink-rate.8 | 24 +++++++++++++++++++-----
 man/man8/devlink.8      |  4 ++++
 3 files changed, 32 insertions(+), 8 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index f75a707..ba2209c 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -71,6 +71,8 @@ static bool g_indent_newline;
 #define INDENT_STR_MAXLEN 32
 static char g_indent_str[INDENT_STR_MAXLEN + 1] = "";
 
+static bool use_iec = false;
+
 static void __attribute__((format(printf, 1, 2)))
 pr_err(const char *fmt, ...)
 {
@@ -4543,7 +4545,7 @@ static void pr_out_port_fn_rate(struct dl *dl, struct nlattr **tb)
 			mnl_attr_get_u64(tb[DEVLINK_ATTR_RATE_TX_SHARE]);
 
 		if (rate)
-			print_rate(false, PRINT_ANY, "tx_share",
+			print_rate(use_iec, PRINT_ANY, "tx_share",
 				   " tx_share %s", rate);
 	}
 	if (tb[DEVLINK_ATTR_RATE_TX_MAX]) {
@@ -4551,7 +4553,7 @@ static void pr_out_port_fn_rate(struct dl *dl, struct nlattr **tb)
 			mnl_attr_get_u64(tb[DEVLINK_ATTR_RATE_TX_MAX]);
 
 		if (rate)
-			print_rate(false, PRINT_ANY, "tx_max",
+			print_rate(use_iec, PRINT_ANY, "tx_max",
 				   " tx_max %s", rate);
 	}
 	if (tb[DEVLINK_ATTR_RATE_PARENT_NODE_NAME]) {
@@ -9072,6 +9074,7 @@ int main(int argc, char **argv)
 		{ "verbose",		no_argument,		NULL, 'v' },
 		{ "statistics",		no_argument,		NULL, 's' },
 		{ "Netns",		required_argument,	NULL, 'N' },
+		{ "iec",		no_argument,		NULL, 'i' },
 		{ NULL, 0, NULL, 0 }
 	};
 	const char *batch_file = NULL;
@@ -9087,7 +9090,7 @@ int main(int argc, char **argv)
 		return EXIT_FAILURE;
 	}
 
-	while ((opt = getopt_long(argc, argv, "Vfb:njpvsN:",
+	while ((opt = getopt_long(argc, argv, "Vfb:njpvsN:i",
 				  long_options, NULL)) >= 0) {
 
 		switch (opt) {
@@ -9122,6 +9125,9 @@ int main(int argc, char **argv)
 				goto dl_free;
 			}
 			break;
+		case 'i':
+			use_iec = true;
+			break;
 		default:
 			pr_err("Unknown option.\n");
 			help();
diff --git a/man/man8/devlink-rate.8 b/man/man8/devlink-rate.8
index 60244dd..b2dc834 100644
--- a/man/man8/devlink-rate.8
+++ b/man/man8/devlink-rate.8
@@ -15,7 +15,7 @@ devlink-rate \- devlink rate management
 
 .ti -8
 .IR OPTIONS " := { "
-.BR -j [ \fIson "] | " -p [ \fIretty "] }"
+.BR -j [ \fIson "] | " -p [ \fIretty "] | " -i [ \fIec "] }"
 
 .ti -8
 .B devlink port function rate show
@@ -61,9 +61,10 @@ except decimal number, to avoid collisions with leafs.
 .PP
 Command output show rate object identifier, it's type and rate values along with
 parent node name. Rate values printed in SI units which are more suitable to
-represent specific value. JSON (\fB-j\fR) output always print rate values in
-bytes per second. Zero rate values means "unlimited" rates and ommited in
-output, as well as parent node name.
+represent specific value. To print values in IEC units \fB-i\fR switch is
+used. JSON (\fB-j\fR) output always print rate values in bytes per second. Zero
+rate values means "unlimited" rates and ommited in output, as well as parent
+node name.
 
 .SS devlink port function rate set - set rate object parameters.
 Allows set rate object's parameters. If any parameter specified multiple times
@@ -85,7 +86,7 @@ rate group.
 .TP 8
 .I VALUE
 These parameter accept a floating point number, possibly followed by either a
-unit.
+unit (both SI and IEC units supported).
 .RS
 .TP
 bit or a bare number
@@ -117,6 +118,9 @@ Gigabytes per second
 .TP
 tbps
 Terabytes per second
+.P
+To specify in IEC units, replace the SI prefix (k-, m-, g-, t-) with IEC prefix
+(ki-, mi-, gi- and ti-) respectively. Input is case-insensitive.
 .RE
 .PP
 .BI parent " NODE_NAME \fR| " noparent
@@ -169,6 +173,16 @@ pci/0000:03:00.0/1 type leaf
 .RE
 
 .PP
+\fB*\fR Display leaf rate object rate values using IEC units:
+.RS 4
+.PP
+# devlink -i port function rate show pci/0000:03:00.0/2
+.br
+pci/0000:03:00.0/2 type leaf 11718Kibit
+.br
+.RE
+
+.PP
 \fB*\fR Display node rate object with name some_group of the pci/0000:03:00.0 device:
 .RS 4
 .PP
diff --git a/man/man8/devlink.8 b/man/man8/devlink.8
index 866fda5..840cf44 100644
--- a/man/man8/devlink.8
+++ b/man/man8/devlink.8
@@ -59,6 +59,10 @@ Output statistics.
 .BR "\-N", " \-Netns " <NETNSNAME>
 Switches to the specified network namespace.
 
+.TP
+.BR "\-i", " --iec"
+Print human readable rates in IEC units (e.g. 1Ki = 1024).
+
 .SS
 .I OBJECT
 
-- 
1.8.3.1

