Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A3C2398995
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 14:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbhFBMdT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 08:33:19 -0400
Received: from mail-mw2nam10on2087.outbound.protection.outlook.com ([40.107.94.87]:37665
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230036AbhFBMdH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 08:33:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G5D4BfWCKr0cNzqDTFQUSx0VKe4yZbh6/NxIwKK3Aa6kTvP8jb2B3Uoh2c6iIGYgKVFKfaZbMovpHMyRhWzfCPe67lQl3D0J60BDKXGg2qjdz4UYj0WGnAw78mQJZrphubBSgO3MAqaaBVZZ7u7PSrDLp6e9dg3Uutv0l8uPx35FW1KLTrfUBN+MGOPbGFHWIyK7w5aAuT2HvJwV/HcxrGjG5fd5uYlM/QnnTwDzvkHIh7T+O644r6BfTD6reZwF8My0ND/NunLQlX8G4Buc3M/QxeZQhM+zdi7CC2s0yV3t+K0No8SocF+uCcIkE4aBYrXS0kz2CdCCm5SEBolRdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fCDmQqOIV8z4zUqk/o5vxPlq1Itwgnzcxh++1RPBlEU=;
 b=eyrSuQ14eD82p5XIVetjO7eF8TTAY5jDEVjzpDnCku/DOiP4G/JvWTSjLkeV9q8qA0/wkrgsCk5fKqapnyeZO/BVtsES/z3y1Awzzf5lL9E8GEQ7DzN6S7WbaGs64buoT7391YTNF2QNoYDldG62RHSeF+qHV/ruyFvNRztOROJEDAN3OQLNhsLuCg7iN9Ju1KDY0TTiUw25sefGkGS5OTBrdQRaWzV7yVryYb9U5UAc7HbC/cO7YE3yROV4gujEYSdQrG1e6gJVAvqSe/LCOF+KoOoZVke+7xNaHJ1gEheIQwtmvHlYKr2GSOp20MCG9Wcr6gPwW3JitLcQXwSPZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fCDmQqOIV8z4zUqk/o5vxPlq1Itwgnzcxh++1RPBlEU=;
 b=tTXcwpzO+8wG2sR7I7iVbqaNpmqbXuSBlJFU8gxxQLAp3m9hMVb/02FDa9r/bGYkqVmxS9UK7NHVYEAboSRWD8T9qF+x0vfG2MF12olHv4OBJczYgtHz9UiN00ClCYuTELMVxRttTcCWWh259ZzB3z0Ekd/HBLGQgE8rqMWqLpVtoqakIU7MP9tgmeaUkF4th2tnVUQjGix5pX0pySUDL6VfWCCv/7sTXe2f9t1seuLcsjztqSs6NXaGGh3J/XIF0T3ZWzGPhG2VbaPI4iqlCWNSPrW7uqqqSYF7iOvcSB4X0DR8j8lRduRPSl6/J6fqa5DcqpleaiAdUEJBZNqwnA==
Received: from MW4PR03CA0292.namprd03.prod.outlook.com (2603:10b6:303:b5::27)
 by MN2PR12MB4606.namprd12.prod.outlook.com (2603:10b6:208:3f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.21; Wed, 2 Jun
 2021 12:31:22 +0000
Received: from CO1NAM11FT018.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b5:cafe::53) by MW4PR03CA0292.outlook.office365.com
 (2603:10b6:303:b5::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.21 via Frontend
 Transport; Wed, 2 Jun 2021 12:31:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 CO1NAM11FT018.mail.protection.outlook.com (10.13.175.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4150.30 via Frontend Transport; Wed, 2 Jun 2021 12:31:21 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 2 Jun
 2021 12:31:21 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 2 Jun
 2021 12:31:20 +0000
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 2 Jun 2021 12:31:18 +0000
From:   Dmytro Linkin <dlinkin@nvidia.com>
To:     <dlinkin@nvidia.com>
CC:     <davem@davemloft.net>, <dsahern@gmail.com>, <huyn@nvidia.com>,
        <jiri@nvidia.com>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <parav@nvidia.com>, <stephen@networkplumber.org>,
        <vladbu@nvidia.com>
Subject: [PATCH RESEND iproute2 net-next 4/4] devlink: Add ISO/IEC switch
Date:   Wed, 2 Jun 2021 15:31:05 +0300
Message-ID: <1622637065-30803-5-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1622637065-30803-1-git-send-email-dlinkin@nvidia.com>
References: <1622636251-29892-1-git-send-email-dlinkin@nvidia.com>
 <1622637065-30803-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1ba7fc85-5ee3-400e-4bf9-08d925c2547b
X-MS-TrafficTypeDiagnostic: MN2PR12MB4606:
X-Microsoft-Antispam-PRVS: <MN2PR12MB46068A3820ED77768FEF92C7CB3D9@MN2PR12MB4606.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:626;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NP0VkLVpjtV60EYsBRAWXgVoL7OBD00moQ81DTLFYJkTj2RhR4xPr6HcHyUGW2uR9e52poBA7h0FM1uCEBxx8247oQ6cs0VbhTTav+SuF/fz4t97C++mbwat7SBu9vNICmPoQZZHhxL1ZPssrA3N3ruT/hzXaee7J6VTF3xKzQp04wp6n2HIcIHG9sTMauLcdmNgRD80oH5SgURqJujGGi/kPAPEpSjtbuIc1fOYAiUYqptKL4229pAd7ingn4trjlUk5ND1jlu107ND/vq473PUUDCiwTYbKy4hu11zLn94hmFQQYW8Lgm5tIjVUZg3pOluc4BbQ52n8hrHn8c6g3p2xtYvgCta/+xDjijbuqG4cuWqZPItIszgr8Uv3/hJZmTOgGN5amskOAn4Ew2Yv6d17lKoNhCznQslppleXZQdqiLCAGh0U6V4XTCrSzpmifEt8SlHpRmyduOuYn4I8XmPrnouWIVZKqNG0VpQpEpyRI/oWIo/N1oXkUj9118tnBCbN5h78EPtQ0l0eDWyXCUnR3GEUGUwI8ywS8JxE7SjWur7MD+cCzLR9SBjh72TyxcanTunE8Lru7iADcj7/APkDob8Nk5mBkgU59OQRqSWYjBMO1gzrEfXP0Dx9lEFNDaLaRRtqGv77L7l3qwH5caba3dWDdx4ZEQAAct3S5Q=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(39860400002)(396003)(46966006)(36840700001)(82310400003)(36906005)(8676002)(54906003)(7049001)(4326008)(8936002)(107886003)(5660300002)(6862004)(7636003)(356005)(6666004)(37006003)(82740400003)(478600001)(316002)(83380400001)(336012)(7696005)(2616005)(426003)(70586007)(26005)(70206006)(2906002)(47076005)(6200100001)(36860700001)(36756003)(86362001)(186003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 12:31:21.9816
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ba7fc85-5ee3-400e-4bf9-08d925c2547b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT018.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4606
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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

