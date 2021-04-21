Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7608366F9D
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 18:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244136AbhDUQAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 12:00:15 -0400
Received: from mail-bn7nam10on2086.outbound.protection.outlook.com ([40.107.92.86]:62222
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243847AbhDUQAN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 12:00:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YI8uowoOuOMS4H0goOqDX1TW+rCDVvscwjns/Fzr5qtCoCQKpYe0oZp5OyGOZ8HhaJg0QfKRdroY+34KDW00PeeymO7MQBfw8ZaJY4K3QMr7cYlAl/LpSb8puW1lVLARisTTpNHQWDBOsP+JaCBc/zQqz2/MI7hhMJ8R1ihWmOBwRN41N7rJFp+/EYXOLxamm21VDj/J1JGo8dcR3YC9v00s19kVw/iCpNstdlWQmvxh2HRZExWe0757kISqduqGAz44mSD+SUEjFd3YdwT/+YM1tB1Ouc4dG789L4XMvovEU0n4GpdL0w2wem8yPRVfHwnBe4ZWzHwSE+6aIKQVUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EMrT72f/Uy5FQZnyloqR9i1zAXAy/ZbU44I/1nk/bYo=;
 b=mmbsV5m0TLeyNFLoDW0wtoa4GZsNPpZkJoj89VG+ryPYrOcEoZbsso2Vm/L7aetH0gTZAgEC+RmkEMwylD4fnQCbS1GxOkaP+fJDPNbVXKflN+/WPfi//PiTowKUI1YCj3053nR9dTGo3Br3CQxAIhOQVQq24hYUfkQ4SFTxsZDOZ6pS7uAQa7/4iGHhymkBExJZ3IiOAYYxCO9ximWHB9x4BoebpwYxk4qN0/RiW2AydfqE4tad9DG7N+X46TiAT7MAn+idjkopkIOBvC0iAuXWUMrWVbXLxmUECxLbI03jYWm33Bk8Uk1KjfJHszCZjcUHUWN7mCwRD9/EcLjHDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EMrT72f/Uy5FQZnyloqR9i1zAXAy/ZbU44I/1nk/bYo=;
 b=eirJ3bNzGYO+GTcYnGzM4d8PZeNVsaec2691gGjP/iiJEG9d/yKspnLe7J0c3RTlm24AG1J04k33VS7fAxZL9N7CV459wq/vO0G0DQsltfpakFtIM14GqQIYma4fwWJzZAcT6PMhfBKI+drw9bbzow1lvmi/lmkZqak6711CEBXa0ZKu/vU8VewHtqkUPYAvbwCSLtaWYGy94IHnEEPNbJMaQcuMvC/5tGv3B6qTp1W+2+y5hRqtiphPaLQ02h/siNQimvY9mm8zWDeD6IiPE0rnz8m41wEZj6z16cdJ5zWh4yinwK6gLyiOGHHr/Beha6iyggb/XrKl77kXnbwiqw==
Received: from MW4PR02CA0018.namprd02.prod.outlook.com (2603:10b6:303:80::16)
 by BY5PR12MB4323.namprd12.prod.outlook.com (2603:10b6:a03:211::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Wed, 21 Apr
 2021 15:59:39 +0000
Received: from CO1NAM11FT018.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:80:cafe::46) by MW4PR02CA0018.outlook.office365.com
 (2603:10b6:303:80::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21 via Frontend
 Transport; Wed, 21 Apr 2021 15:59:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT018.mail.protection.outlook.com (10.13.175.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4065.21 via Frontend Transport; Wed, 21 Apr 2021 15:59:39 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 21 Apr
 2021 15:59:38 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 21 Apr
 2021 15:59:38 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 21 Apr 2021 15:59:36 +0000
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <stephen@networkplumber.org>, <dsahern@gmail.com>,
        <vladbu@nvidia.com>, Dmytro Linkin <dlinkin@nvidia.com>
Subject: [PATCH RESEND RFC iproute2 net-next 4/4] devlink: Add ISO/IEC switch
Date:   Wed, 21 Apr 2021 18:59:25 +0300
Message-ID: <1619020765-20823-5-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1619020765-20823-1-git-send-email-dlinkin@nvidia.com>
References: <1619020765-20823-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 97673759-aaa2-4c17-63e3-08d904de7805
X-MS-TrafficTypeDiagnostic: BY5PR12MB4323:
X-Microsoft-Antispam-PRVS: <BY5PR12MB4323D6EA1CB68E2392823AF9CB479@BY5PR12MB4323.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:626;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mZJ7hNZoq+j4iClNHXtRC1nqEq719n+/v+rkuI6kcHFArkhsYmSnD/9nbJdan1iQoEQqECTBqTcGp2nheOvV0QA4IPEOnfHRGDQWNxG/6H25COg1WX84OHby4apofHxkI8IPQ4pWUN0jU46H5zawdBBrV4/05PQ62Z+u2AMe3+sP4dzUXXOBBtDn2hQXqal82kWBoCTmdmYSbh+FEDGfVKrwqJLpBNFpDY6jovZo/PY87dwjEZXcKKQrP5Bm3jJg10q6nN8geOxGicLzEF6YwU9U+hgRibDoDOLV2YsBYA0234VAn/HwP2wn8s3kvHA5mILsMD4X8lYwQ96LZe1CGlMO+Szhidv+CrVAqwMrgHg/h75AUlgUoP9vKz2rmYKKsJ4RBrg68aGlHnORJ9e9mKZianr7YFuR3MJmqNJiT737eu9QYZRnsAf6DcOqhOsHCiFLqmuIoGHhjgttPfC0Fbm3ZMXicDAm5d2rkRrk29Z6tcLt3dGxlvBOogBBzR7nIaQzTx659g3SS/GH6nryNoy+VAMtr0YzIzJV4ipkkAWclZcVfIPVuGXzFKlYN8CWO4LhgZq7KIVSWXZkbXhIAGBEZq53T5+6zlcXy8lI+TfbWVB9Rjsg4S/WKxYHl+95vpaFBo7kUGrZ4Yn87YKKIA==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(396003)(39860400002)(376002)(346002)(46966006)(36840700001)(316002)(426003)(6666004)(7636003)(36906005)(54906003)(82740400003)(70586007)(86362001)(7696005)(47076005)(2876002)(2906002)(83380400001)(107886003)(356005)(70206006)(6916009)(2616005)(5660300002)(4326008)(336012)(26005)(36860700001)(36756003)(478600001)(8676002)(8936002)(82310400003)(186003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2021 15:59:39.1406
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 97673759-aaa2-4c17-63e3-08d904de7805
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT018.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4323
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmytro Linkin <dlinkin@nvidia.com>

Add -i/--iec switch to print rate values using binary prefixes.
Update devlink(8) and devlink-rate(8) pages.

Change-Id: I8b1896ed087273d96f6cd74eae7b2a3adc5fb846
Signed-off-by: Dmytro Linkin <dlinkin@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 devlink/devlink.c       | 12 +++++++++---
 man/man8/devlink-rate.8 | 24 +++++++++++++++++++-----
 man/man8/devlink.8      |  4 ++++
 3 files changed, 32 insertions(+), 8 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 202359e..0347ac8 100644
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
@@ -4537,7 +4539,7 @@ static void pr_out_port_fn_rate(struct dl *dl, struct nlattr **tb)
 			mnl_attr_get_u64(tb[DEVLINK_ATTR_RATE_TX_SHARE]);
 
 		if (rate)
-			print_rate(false, PRINT_ANY, "tx_share",
+			print_rate(use_iec, PRINT_ANY, "tx_share",
 				   " tx_share %s", rate);
 	}
 	if (tb[DEVLINK_ATTR_RATE_TX_MAX]) {
@@ -4545,7 +4547,7 @@ static void pr_out_port_fn_rate(struct dl *dl, struct nlattr **tb)
 			mnl_attr_get_u64(tb[DEVLINK_ATTR_RATE_TX_MAX]);
 
 		if (rate)
-			print_rate(false, PRINT_ANY, "tx_max",
+			print_rate(use_iec, PRINT_ANY, "tx_max",
 				   " tx_max %s", rate);
 	}
 	if (tb[DEVLINK_ATTR_RATE_PARENT_NODE_NAME]) {
@@ -9066,6 +9068,7 @@ int main(int argc, char **argv)
 		{ "verbose",		no_argument,		NULL, 'v' },
 		{ "statistics",		no_argument,		NULL, 's' },
 		{ "Netns",		required_argument,	NULL, 'N' },
+		{ "iec",		no_argument,		NULL, 'i' },
 		{ NULL, 0, NULL, 0 }
 	};
 	const char *batch_file = NULL;
@@ -9081,7 +9084,7 @@ int main(int argc, char **argv)
 		return EXIT_FAILURE;
 	}
 
-	while ((opt = getopt_long(argc, argv, "Vfb:njpvsN:",
+	while ((opt = getopt_long(argc, argv, "Vfb:njpvsN:i",
 				  long_options, NULL)) >= 0) {
 
 		switch (opt) {
@@ -9116,6 +9119,9 @@ int main(int argc, char **argv)
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
index a6e28ac..76c65a3 100644
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

