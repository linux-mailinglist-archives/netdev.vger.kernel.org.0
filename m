Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C38E7398993
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 14:31:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbhFBMdM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 08:33:12 -0400
Received: from mail-bn8nam11on2062.outbound.protection.outlook.com ([40.107.236.62]:21473
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229844AbhFBMdD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 08:33:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bxVA1DQ8j3ugIzQ0ASWKrYGSQdCzq95pOs7X8usrzxiZTbzabuUzvNJsJc3tI4Bv6YohW2puD+CvtAc5O7lN/uc08I5NRRJs2pQ6clyjKoOTBpIAi6u6KkgEkxsYgwbhwOdJsSFqDTF+uVLslZ3N5w2tPaXwKWd3CSQ6etAtPgx92EhNu/iygnyBa8VIVhN9FC+bi0i9ALntV3INff1rESy3cKdbrNOs7TQ1qRE8xK9p9sj8kBlYOV7Y/oKN9NyI2FoETaMEFPFr/zMlNZJQIPSj5Y8JqPuI9jeJJAbrClR3fIMAPmPSsiWTcd9GTut7bkna1CD2CnBKktYOkhlMYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4yWZZkamS5pmvG7OQWTCd1O5esXpxib4sRwGtP6Y7kM=;
 b=SPE9OM/XeJKQg3TuMB8qotxN8yr0qBmlYvTpvq8xnsgBPzizTFowBlj2FURtUHpZU9GW4GJFmgTcCSvog+qxngXzKWKk9dLP1gONIvddmit59xlL+vwTPACAbLqYsdCQXeM2MRnlezy4q3HCZUf3Fi8Tc7L5Hqm2iw94A0ezbSAyKdcmd0duaBcSPgFNffOakY5pHBVVCiaI+fjvHXcyfN9ktcJClHB3zTlDB+tJGhFJiQo+at/I1UokdLO4sKRAzRUl9NcABGbpm+14SXksm9PJzF0OdHadVx0D9BNU9NHjpappg5JMB6wGucdRk+Hc9X5ylSaKUfLm2ynF33sd1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4yWZZkamS5pmvG7OQWTCd1O5esXpxib4sRwGtP6Y7kM=;
 b=O84D0N47IgjyWUGGXKCIsvjx1xe9LHYNr4svD/bikkTj0hY5eWv/PYsoxxDcay+hRtDHlrZeoZP62XwUb5l+eMatufk0Bw/p1/TdnWQ1nTDp3a/GAuQbIVxRenTkMiZWw+vKH20WLWdoJmjGg8aGnRHTriVsh31UnnP0LOPMCdVbIZ5/LW3hCo0y4uHpHJztosn4hh+2lIQO+uc5ZUxPmbGonG1hgo9IVI54HEB2dfIfa7tjK19/ROtSw1VbQDFyMkL9LnCUsViYrou4suzDQbNmRy4auYoO1z58O60fFED3iZns8iG68M4xY4UBjYYOMxNZ4dB2jtb5SqMEghhDkQ==
Received: from CO2PR18CA0063.namprd18.prod.outlook.com (2603:10b6:104:2::31)
 by DM6PR12MB3148.namprd12.prod.outlook.com (2603:10b6:5:11c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.26; Wed, 2 Jun
 2021 12:31:18 +0000
Received: from CO1NAM11FT022.eop-nam11.prod.protection.outlook.com
 (2603:10b6:104:2:cafe::f6) by CO2PR18CA0063.outlook.office365.com
 (2603:10b6:104:2::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.15 via Frontend
 Transport; Wed, 2 Jun 2021 12:31:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 CO1NAM11FT022.mail.protection.outlook.com (10.13.175.199) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4150.30 via Frontend Transport; Wed, 2 Jun 2021 12:31:18 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 2 Jun
 2021 12:31:15 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 2 Jun
 2021 12:31:15 +0000
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 2 Jun 2021 12:31:12 +0000
From:   Dmytro Linkin <dlinkin@nvidia.com>
To:     <dlinkin@nvidia.com>
CC:     <davem@davemloft.net>, <dsahern@gmail.com>, <huyn@nvidia.com>,
        <jiri@nvidia.com>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <parav@nvidia.com>, <stephen@networkplumber.org>,
        <vladbu@nvidia.com>
Subject: [PATCH RESEND iproute2 net-next 2/4] devlink: Add helper function to validate object handler
Date:   Wed, 2 Jun 2021 15:31:03 +0300
Message-ID: <1622637065-30803-3-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1622637065-30803-1-git-send-email-dlinkin@nvidia.com>
References: <1622636251-29892-1-git-send-email-dlinkin@nvidia.com>
 <1622637065-30803-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 55b8d877-e7d0-480c-4972-08d925c2522e
X-MS-TrafficTypeDiagnostic: DM6PR12MB3148:
X-Microsoft-Antispam-PRVS: <DM6PR12MB3148D4C5B322BFDABE77F812CB3D9@DM6PR12MB3148.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1923;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3MW1pwQIBGj3ss4PPF+8X4fNrQRCrdR3q/RDIrx67MHOJNa40vnO3cKEds0xb2ovlFxUE02Z9RgdcUbr2OrhQUx2JdbxhWuu6tPyaSBrIlzOWWNUAPNgSdBfqjv33cHWF3R+J0R6+a0nY5M94xFN9nTUcWTe5AHd8gWrLiPkZFYHyl/P86p0H04dlBcxASAXaxhOpVNGnNars7Pw1k5IF9R5v7o7s42LTDErDeAI90twlUhfgQGU3gFcuhVXiblEbR1VSQF/QpU8d7er18NbFh+OMUE0giTD96v1QtMcxCOOxHvMHfYOvEqS9VldaWuUW51zfWa9O0MFt5F4B28RRvMsw9ODadcOk0kf84virudguO1dV0+I8zkiubTKWa/o98rXxdlB3pgrcGgfvUtBYNUr/H23ZC40X40HTj8/hJvHhyBpum+6VU9EHURWIKYdxrRzKDD0dA5kHZAeKPMLo0coSpOBT2YT/TQUdOITX3bspTFeU0dpFaiJAn3MKg+tAi7F+xXF4wId3AE1L363w9vDKUfRWH7eus/Df5D+542yH77CPpkAnYJvFRP5c+OaVaMVisd1AplNAQIVzXKgRY+sjzoMP1UKj0ZtwbKj23nvFowWnKuC4n9cllw8U3m92R/6sc1Dx+rlxkkYPE3QfClCJt4zo+p8NWNWhhBEe6c=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(346002)(396003)(39860400002)(376002)(46966006)(36840700001)(7636003)(8936002)(6200100001)(82740400003)(478600001)(6666004)(316002)(7696005)(6862004)(86362001)(426003)(2616005)(70586007)(37006003)(36906005)(186003)(107886003)(336012)(4326008)(54906003)(36756003)(83380400001)(36860700001)(26005)(5660300002)(15650500001)(47076005)(7049001)(8676002)(356005)(70206006)(2906002)(82310400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 12:31:18.1064
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 55b8d877-e7d0-480c-4972-08d925c2522e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT022.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3148
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Every handler argument validated in two steps, first of which, form
checking, expects identifier is few words separated by slashes.
For device and region handlers just checked if identifier have expected
number of slashes.
Add generic function to do that and make code cleaner & consistent.

Signed-off-by: Dmytro Linkin <dlinkin@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 devlink/devlink.c | 38 +++++++++++++++++++++-----------------
 1 file changed, 21 insertions(+), 17 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 16eca4f..f435fc8 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -915,6 +915,19 @@ static int strtobool(const char *str, bool *p_val)
 	return 0;
 }
 
+static int ident_str_validate(char *str, unsigned int expected)
+{
+	if (!str)
+		return -EINVAL;
+
+	if (get_str_char_count(str, '/') != expected) {
+		pr_err("Wrong identification string format.\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int __dl_argv_handle(char *str, char **p_bus_name, char **p_dev_name)
 {
 	str_split_by_char(str, p_bus_name, p_dev_name, '/');
@@ -924,15 +937,12 @@ static int __dl_argv_handle(char *str, char **p_bus_name, char **p_dev_name)
 static int dl_argv_handle(struct dl *dl, char **p_bus_name, char **p_dev_name)
 {
 	char *str = dl_argv_next(dl);
+	int err;
 
-	if (!str) {
+	err = ident_str_validate(str, 1);
+	if (err) {
 		pr_err("Devlink identification (\"bus_name/dev_name\") expected\n");
-		return -EINVAL;
-	}
-	if (get_str_char_count(str, '/') != 1) {
-		pr_err("Wrong devlink identification string format.\n");
-		pr_err("Expected \"bus_name/dev_name\".\n");
-		return -EINVAL;
+		return err;
 	}
 	return __dl_argv_handle(str, p_bus_name, p_dev_name);
 }
@@ -1067,18 +1077,12 @@ static int dl_argv_handle_region(struct dl *dl, char **p_bus_name,
 					char **p_dev_name, char **p_region)
 {
 	char *str = dl_argv_next(dl);
-	unsigned int slash_count;
+	int err;
 
-	if (!str) {
-		pr_err("Expected \"bus_name/dev_name/region\" identification.\n");
-		return -EINVAL;
-	}
-
-	slash_count = get_str_char_count(str, '/');
-	if (slash_count != 2) {
-		pr_err("Wrong region identification string format.\n");
+	err = ident_str_validate(str, 2);
+	if (err) {
 		pr_err("Expected \"bus_name/dev_name/region\" identification.\n"".\n");
-		return -EINVAL;
+		return err;
 	}
 
 	return __dl_argv_handle_region(str, p_bus_name, p_dev_name, p_region);
-- 
1.8.3.1

