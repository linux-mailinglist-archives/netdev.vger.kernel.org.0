Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80B863A3D0F
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 09:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231500AbhFKH14 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 03:27:56 -0400
Received: from mail-mw2nam12on2052.outbound.protection.outlook.com ([40.107.244.52]:33794
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231466AbhFKH1v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Jun 2021 03:27:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f0Jb1rxUTP4Kd9N1gDz03ONm7ZMHgvWENyyIjXwqV6J4Q3q4zzg8Jl24AUADU1vjUVODSd/K6uN57ijcQgYrlu/AzuwTPLxpG4ltP8DBxIXn1BFSBI5tvg4Qgj/owkMxCL7Dvd1w31fVtp916yGGqyrxTyZLipVewIeDj1JffxC7xe/B/NeReTmvXf6ce3gCu+n8c0Y2RDt934VaLAYEhLHomym6n87YYApaZryV7Co78Ql8sJq5u4hri/kz+RJQl+0vXDsYfdls2LqjX63Gn6OuJnNlXemf2EWkW7yRD+V6I7DUfPewCZMOVzsR4xtLRmbfb/GXMBVHW5Uce/o29g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MwF15Hr4B3Qrs14mXROJuEbwmL/JtvzANjbjIdrCW7M=;
 b=eQZUatqBAC56yw803uKCmSc74jcm4QZOSJUXgGvL6AfKIIk19TRQ4ABDcvAWDHJ4ZRSRH84iw+0r/eQAJXrdQZcYbB/UK7IhKizTVj1EQ4XK7mqkTVPTqkiPwEzjQGIEjO0llTLlsJpKHoBsicjO8FYC45QOh6d6mnCyggW7NFmItVToTAiWCqYvf1Qm48PEDMrSRM2d4KRMcE4MVLnca/AHi9s3wrAVFj7i9tmK9xRpemlULywzh/M205skUW4Z6Hs1IyHSHWbLHOf9xCisBCfx84oBIbCSN5hBmf/p/HXDDN8Lxg0MiaVeBNcpMPtJoiyuGX6LhGGlBydfmT/W6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MwF15Hr4B3Qrs14mXROJuEbwmL/JtvzANjbjIdrCW7M=;
 b=IVy+yoF8LQIUwuI+8vcSRcCXbJhIYHahIsdQiqwQthm+xau60Txkm6I3KEaSFT0HjccdYzjztElxm+F3l23VSe5vC+mrSGwz4D+XE9vkMkwcTye3so6BgUT4t2ANtaYO4dS8mERL5uzJgwn8masDw5+P8EQ6zbBoNWHbr3XjsZJlL768P51fk2hGJU7YRlHOWu1g7q9JnEht8iIEg/8YxE+nGms2859M5hjcg7NhzVei2sN/hge0JMUay3Wu8W5SdiFaFl84TLFKe7g44l7NQcXSvvXZ+HB6OholiI48vS33eSNGBME39Pl8WagcMZonddNwbe4yt6vAo5U4KJaPUg==
Received: from BN6PR2001CA0033.namprd20.prod.outlook.com
 (2603:10b6:405:16::19) by DM5PR12MB1852.namprd12.prod.outlook.com
 (2603:10b6:3:10a::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22; Fri, 11 Jun
 2021 07:25:51 +0000
Received: from BN8NAM11FT026.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:16:cafe::2d) by BN6PR2001CA0033.outlook.office365.com
 (2603:10b6:405:16::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20 via Frontend
 Transport; Fri, 11 Jun 2021 07:25:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT026.mail.protection.outlook.com (10.13.177.51) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4219.21 via Frontend Transport; Fri, 11 Jun 2021 07:25:50 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 11 Jun
 2021 07:25:49 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 11 Jun 2021 07:25:47 +0000
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <dsahern@gmail.com>, <stephen@networkplumber.org>,
        <vladbu@nvidia.com>, <parav@nvidia.com>, <huyn@nvidia.com>,
        <dlinkin@nvidia.com>
Subject: [PATCH RESEND2 iproute2 net-next 3/3] devlink: Add ISO/IEC switch
Date:   Fri, 11 Jun 2021 10:25:37 +0300
Message-ID: <1623396337-30106-4-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1623396337-30106-1-git-send-email-dlinkin@nvidia.com>
References: <1623396337-30106-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 696b118a-71a2-4090-2354-08d92caa240f
X-MS-TrafficTypeDiagnostic: DM5PR12MB1852:
X-Microsoft-Antispam-PRVS: <DM5PR12MB1852A4E9A35D9E501734BF2BCB349@DM5PR12MB1852.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:626;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /pv5rGiIrBZWHLZTuHePSEyMDIhIiSi48Q8xyva7lGF8FGuXjw0Ibby0P0r82mLoknMKSEKOh2e1uiPOxjT+nFs6PQIzuBUMBD8+RCmXEv+Hbu/h+yfyQc6Qyr4W7/vRr9J8GyVsMmLurCN0ukm8+zbYjJmSoK4oncfUf1PRS953sI6GVy8YAL3zthJNF6NMb0LWn/Z1vyFNEqay3CF3q2we/xTNdff2KUbpgTBi2OK3Jfoo1HRN/P9MxZDSLhyb2waSMTDUyqXbBlEy5h3tgI2BgIOaN7+6SZrKGA67FHsr3unh+8zO+CHI1902DGGXpIu0i1itBCouxtBmHB+974f3KzNG8RFtRMIHG/SFbyIFQ0pGC7TWsInoIlwg8o3/aMQNTcQ3PKmEiwkBSJosDdclgo9BqqJROk01MvSe2klkExdd+mg+W6CqYQHGk7+MpRW5AIPcjEiq5FlBOTxile6WAR7UNS2Kr4QOw3iueISOZ6kOTi57/mbqHrK0nry0vlSMNfEacDOb/0bqhnv6ctRIKOe2dw3QII+dZleHQIHxh62ykU/w/cg79FJszPUyO3f9hDQT2p1MEsSWGBVMVAP+/ik4h0LoqSimmP+9ZfpxDxoq1nNsYwmKVdHwUEsVuhP0V3VtS5QpOM44Z2GJHqLK0NbC3spyLtaZq5M5vbQ=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(376002)(346002)(39850400004)(136003)(36840700001)(46966006)(8676002)(336012)(478600001)(36756003)(70586007)(36860700001)(6916009)(7696005)(6666004)(2876002)(82740400003)(26005)(86362001)(4326008)(82310400003)(54906003)(2906002)(70206006)(2616005)(107886003)(36906005)(356005)(83380400001)(8936002)(186003)(7636003)(426003)(47076005)(316002)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2021 07:25:50.8871
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 696b118a-71a2-4090-2354-08d92caa240f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT026.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1852
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
index 4d8d880..e5294d5 100644
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
@@ -4555,7 +4557,7 @@ static void pr_out_port_fn_rate(struct dl *dl, struct nlattr **tb)
 			mnl_attr_get_u64(tb[DEVLINK_ATTR_RATE_TX_SHARE]);
 
 		if (rate)
-			print_rate(false, PRINT_ANY, "tx_share",
+			print_rate(use_iec, PRINT_ANY, "tx_share",
 				   " tx_share %s", rate);
 	}
 	if (tb[DEVLINK_ATTR_RATE_TX_MAX]) {
@@ -4563,7 +4565,7 @@ static void pr_out_port_fn_rate(struct dl *dl, struct nlattr **tb)
 			mnl_attr_get_u64(tb[DEVLINK_ATTR_RATE_TX_MAX]);
 
 		if (rate)
-			print_rate(false, PRINT_ANY, "tx_max",
+			print_rate(use_iec, PRINT_ANY, "tx_max",
 				   " tx_max %s", rate);
 	}
 	if (tb[DEVLINK_ATTR_RATE_PARENT_NODE_NAME]) {
@@ -9085,6 +9087,7 @@ int main(int argc, char **argv)
 		{ "verbose",		no_argument,		NULL, 'v' },
 		{ "statistics",		no_argument,		NULL, 's' },
 		{ "Netns",		required_argument,	NULL, 'N' },
+		{ "iec",		no_argument,		NULL, 'i' },
 		{ NULL, 0, NULL, 0 }
 	};
 	const char *batch_file = NULL;
@@ -9100,7 +9103,7 @@ int main(int argc, char **argv)
 		return EXIT_FAILURE;
 	}
 
-	while ((opt = getopt_long(argc, argv, "Vfb:njpvsN:",
+	while ((opt = getopt_long(argc, argv, "Vfb:njpvsN:i",
 				  long_options, NULL)) >= 0) {
 
 		switch (opt) {
@@ -9135,6 +9138,9 @@ int main(int argc, char **argv)
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

