Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C703366F9A
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 18:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243794AbhDUQAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 12:00:11 -0400
Received: from mail-bn7nam10on2047.outbound.protection.outlook.com ([40.107.92.47]:23264
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241397AbhDUQAI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 12:00:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NNvLaFelRSsqsXP5ZK5vounOgaxlJnujr4EkUpOFFCg5DSZV+cy2oW+AhwRIuBY9D6lcK2e7ndoP6/VyjvcXMQ2BFwnLqMXlXPD/VnasAx9hRzgpzIFznMFYvf2lRM7vyuQwFdmuJo8Z0e6/WO0RLT0fh40zMW+H9DgDsN7y1B2biNwNH8dwd+e5nZh1L9d1cc2e+aTJOLAJzj19cJLmOZAeWWwzt6llvSaRY2YYcCkbRiVsdz3Vq0SDlIRtCKntbFPiaYm7OWJSrocqv3a4kwOKaeoxzXjFPzqlHzY1cxrMzOefGEsMhc0Knaz5pxcmn+n7y8vi6SIFM7IcjH2QTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kEgfrUfrD0aOk4soCLjfzfRxraMpfGFu2+d8qZHTJK4=;
 b=jatBhqI26acf2XKG9aJQLJy5VaaGADtonZc8g3asewWvAdFrc08ioqGxrLu0CbuXeztOqjAYGah+s7WpRr9jSM5s8e6nEzYgTEoiRXjsIk+8Q2Aav/g3zImYsfr2olXTTjRwZpiahsotZfmbgfMed/DH+qtoECv+nToKzUFTmtgepuLQj7uU9Luds9FQmpYaDL558X9Z+96Sh4HeiudTh2M8pL2ebqzIZf/uVhCOU085csfazzOHyIERx/8HisVAB2a8+C8/BkYesZiexOIfPhcEu5VRNkJg/DL9MZ4rF6T3W/xKiwkKplQd4oGjxbViQs72Cc7ZUJRmKhjo1E2OUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kEgfrUfrD0aOk4soCLjfzfRxraMpfGFu2+d8qZHTJK4=;
 b=Rway+IIdTkbJL5vTLdkSAP4AFQNPFE+Oj65JF2JpYLa0v/y6Ad7DvDo6D1pCb8eWChkbrW2sgLPCZsAzj8QcSsqcL2NPhAlpG/R7PX3zvpE0NJUqsH8cJYdm1r2fY8WBzWrC6MTYtpzS3SfWRaNrbF2OPBe8AXz1GIM+UT8VCMPPyhFZ7xXMRwLxxs+SV6F67F493v8Wi2NH/+F7+dxC5Fla5pAKEbRsMUF8pKp6BLn4jbcz1NT+3JGw/U1QJcNvE63Fd7H93DPnc0WFMIz2xOf/qKvKL/eCZ3vi2alIp8bLzrh90FpzYW93kFinD9bEmI08pZweRoDla2E1/2fjkA==
Received: from CO1PR15CA0113.namprd15.prod.outlook.com (2603:10b6:101:21::33)
 by DM6PR12MB2603.namprd12.prod.outlook.com (2603:10b6:5:49::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.18; Wed, 21 Apr
 2021 15:59:34 +0000
Received: from CO1NAM11FT052.eop-nam11.prod.protection.outlook.com
 (2603:10b6:101:21:cafe::a) by CO1PR15CA0113.outlook.office365.com
 (2603:10b6:101:21::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21 via Frontend
 Transport; Wed, 21 Apr 2021 15:59:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 CO1NAM11FT052.mail.protection.outlook.com (10.13.174.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4065.21 via Frontend Transport; Wed, 21 Apr 2021 15:59:34 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 21 Apr
 2021 15:59:33 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 21 Apr
 2021 15:59:33 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 21 Apr 2021 15:59:31 +0000
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <stephen@networkplumber.org>, <dsahern@gmail.com>,
        <vladbu@nvidia.com>, Dmytro Linkin <dlinkin@nvidia.com>
Subject: [PATCH RESEND RFC iproute2 net-next 2/4] devlink: Add helper function to validate object handler
Date:   Wed, 21 Apr 2021 18:59:23 +0300
Message-ID: <1619020765-20823-3-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1619020765-20823-1-git-send-email-dlinkin@nvidia.com>
References: <1619020765-20823-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0d7174d7-9ed5-4af8-f281-08d904de7511
X-MS-TrafficTypeDiagnostic: DM6PR12MB2603:
X-Microsoft-Antispam-PRVS: <DM6PR12MB26036CADADCC04965565E0F6CB479@DM6PR12MB2603.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1923;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MBxsu63BMWB7QZhbJreXDdCt3kGSonFMdhy2o2hzZ+YdZpCwHF8J98s5dJ8xPLB/LQMLqf8K42ppG+s5nERtu26HNEjTohNT7VTV0lRm4ArmFQq/f5waQK7FxCfCo+BfOEm31/FJ+JCZ8rFzK97po7sycxIC5gMuSoJvPEyR9KEQEII/1PaSbiGQSgfaMpba48hgBnyfZdGNx6xOBJx/D4MMxUE8dY8/fMEjvEJ6OHrPzu4pscUfBz66SNte8tsu6/1pKC9CC/jPKQj8mfra+M4P67LFF1KORahugdRl4EoonHdLPeyOlYIDrUjY0dGjOhiLgrKmubcfxyqhBXMiShmuHzu2vbATTfbdrEZmdmjuFJZHCus5BbDlBzY520/tLJJ7aZevuzWwL6JLcFjnGiXj05vpBnbcKBADlKpm85+6IdIWU8AbcROFj/Gq+ykic10e6g4ydEyI777xvve3JIqNjiUjUvNTDFSfTqTKy9hxHh/lEGasQR58p1Qx3JjgqSr8309pWuDfEihrbr5gkC9kevyGj59EmmygFGGAeUoKccUor/C8LMxXcFp7UU9L6qt6YCl3ls8OLLUw/EQnUJpmE1QMVBlRctjh0Lji7KbieR7WqiPCnsHdcMLgGBZLZ1RD8iuyM1HSIncL81m/b4HAAW61wVmNJ3SEuL+EDNE=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(39860400002)(136003)(376002)(396003)(36840700001)(46966006)(82310400003)(26005)(7636003)(8676002)(83380400001)(86362001)(15650500001)(70586007)(6666004)(6916009)(356005)(36860700001)(8936002)(36906005)(4326008)(478600001)(36756003)(316002)(186003)(107886003)(82740400003)(54906003)(2906002)(2876002)(2616005)(7696005)(336012)(426003)(5660300002)(47076005)(70206006);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2021 15:59:34.1907
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d7174d7-9ed5-4af8-f281-08d904de7511
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT052.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2603
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmytro Linkin <dlinkin@nvidia.com>

Every handler argument validated in two steps, first of which, form
checking, expects identifier is few words separated by slashes.
For device and region handlers just checked if identifier have expected
number of slashes.
Add generic function to do that and make code cleaner & consistent.

Change-Id: Ib44aa2adc2b287c879cebfae82071ed56f3f011b
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

