Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 566B43A3D0D
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 09:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbhFKH1q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 03:27:46 -0400
Received: from mail-co1nam11on2048.outbound.protection.outlook.com ([40.107.220.48]:62984
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231174AbhFKH1n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Jun 2021 03:27:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SNn3IblJEZCHQzA1ztSSlb2M8H+QRquholmsDc4nBnO1uzdAieMkuCejf2s4JYezN0P28ysetA/RYFajfF1I6TiE1MVbgxoyDs0A415aCAXEeSM4FVxVP+jhghLyFwWPtjTGNoc4wPAcn/w+Mibm5B8QRpjAzftJGxHgw2TXE6VxAAMVJFrDerjOH7GP69M4rNS3fZYF2m3c6SBiUQ6LP/1GI+DJ4P8XgrJgzvDjw4da0I9oz7ALkuKaYEA5mCdS5zQGominVFieM2oZgcGOpdglQSnvXj98A8MsDaffCUUFAeTKLdSK1KR2pbFICH8Mkt5q4wwxSiK9Og7Dd800Cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hH33ZakXp8hZzWUjnlufBKWHVtPyKWoh8fjBOQbdm2g=;
 b=em6UgAqu2QU8HQ+U66spcGN+R3SPOlrhzaxVtVfEHLKP+guTzJ0m8IojusyIJ6J64O52zH+b4A/lPLVX/vpiNsGEEgcUuxEMlht48n4bD+SvLhOl9TRtFAICfiQaAH+He4pot/GM/o9XUF7mbOsL7xqASu6YHx9Fb6pYbS9/08btMT4Iu+yw6SLxbdYjYWJOrBNmZJpGr2/cwZuab8yhW8u4ALBva0qjsToQvdgBv0upLIAEBkVHUq/Q94qW+CYlwdeVc2WljBhCl27NEDLpCY7pAN1qApIADuA3K1PoovElpuGHBSXUSHBTaDGAx1LrgBhHTxy6/jnI1RGJhBDgXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hH33ZakXp8hZzWUjnlufBKWHVtPyKWoh8fjBOQbdm2g=;
 b=dDv8De4FaU1DZk+jhlovJ2YU2UvI17hOcQxC34lY86VSaC7Xi7BxWGfiCureko26eV7izEhRROI17AKZ/XizT37mwel3MUXjWciMb5F+4IrY0LEfUpKTDzMc/61l3aGM5K3XWInXYes0AM3TurrsoOCUxXyvRPw/EcovI/YtNnj+lDB1CZcpNEoTSELbUVjrTbJtznMqvOddcv7YQ18PBfG9RwhZ0ToEul+FvRAib6WiXHkCvh9m5nU44s2kynjT7ZmhvZvTutyygCCZH2l341mPiHGzsziGHNyIINoL4NT5RTTQMK8rVXGuI7hzDW5+BJVFUfO5tLZarFBXx7QG7Q==
Received: from BN0PR04CA0054.namprd04.prod.outlook.com (2603:10b6:408:e8::29)
 by CY4PR12MB1254.namprd12.prod.outlook.com (2603:10b6:903:41::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.26; Fri, 11 Jun
 2021 07:25:45 +0000
Received: from BN8NAM11FT038.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e8:cafe::1c) by BN0PR04CA0054.outlook.office365.com
 (2603:10b6:408:e8::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20 via Frontend
 Transport; Fri, 11 Jun 2021 07:25:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT038.mail.protection.outlook.com (10.13.176.246) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4219.21 via Frontend Transport; Fri, 11 Jun 2021 07:25:44 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 11 Jun
 2021 07:25:44 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 11 Jun 2021 07:25:41 +0000
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <dsahern@gmail.com>, <stephen@networkplumber.org>,
        <vladbu@nvidia.com>, <parav@nvidia.com>, <huyn@nvidia.com>,
        <dlinkin@nvidia.com>
Subject: [PATCH RESEND2 iproute2 net-next 1/3] devlink: Add helper function to validate object handler
Date:   Fri, 11 Jun 2021 10:25:35 +0300
Message-ID: <1623396337-30106-2-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1623396337-30106-1-git-send-email-dlinkin@nvidia.com>
References: <1623396337-30106-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1bd7949d-6543-49a8-01a6-08d92caa205d
X-MS-TrafficTypeDiagnostic: CY4PR12MB1254:
X-Microsoft-Antispam-PRVS: <CY4PR12MB12541164B02CB4F2470196D6CB349@CY4PR12MB1254.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1923;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qREA+zIZnUuQjhxze0eoJV3qUKlhVF6Ju+l9QAnsGeeZ3ob5mVNqA2cBhiUFFGjYAj2pirrgEoOennTVBoa9DK/kxcZqQb0E0Rs1YVmJ9NQToakzVJefdXdGrXFtZ0VBYdpaNL2ATJcnPWzqDxqQRouy/wiK0GGj38fM9UwWUqZfeocOIL+Hc1TzX91yugD/7vYctsXeadqrS4mRgV4TIOErDpRpTHUlHEqyvRcF111XXP/F3vfkxF6O2J9wBw9oLGp654M2iWD8kdIdcHd8XerAJCaDerXR03SsdMaJJED51xbHrXVkzBM+GVY4l6PRzLGhEkG7qznBonndeKqu26mDY1woJLTT+g+xgKFLNpyymiCu40vtFsDRt74VODJf0wJMdIIi6zmSJvacZke3Nfr8ZI/0f3DSMO2BXcEtie+WohirVkybmNbuQGucvu7Na5a+dzg8dssVgbpUGk99NjtqBYLYJ1d7TzEmTdAwpWbjgnfzfWUfD9d9Ltk0OFrrzFfKdRmCNMH77xmx8HmM3CFKDuwRHm65Ti4lFXtCHFN0LbnWerIMhyjG1rEW2BubHM+9qx9D/phE7rLrCSxDy/8yt///zunlA7EpDtGD59vv38hbXObw9rQ0mdSnbtBMOfYdxkhZAAqwUXFDlQZtEgOdf0447E8Pj9Wq4T1F9+I=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(136003)(346002)(396003)(376002)(46966006)(36840700001)(7696005)(2906002)(426003)(15650500001)(6666004)(70206006)(356005)(6916009)(336012)(5660300002)(316002)(47076005)(36906005)(8936002)(478600001)(70586007)(26005)(2616005)(7636003)(4326008)(83380400001)(2876002)(54906003)(82310400003)(186003)(86362001)(8676002)(36756003)(107886003)(82740400003)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2021 07:25:44.6805
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bd7949d-6543-49a8-01a6-08d92caa205d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT038.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1254
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmytro Linkin <dlinkin@nvidia.com>

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
index 9218576..96a1cf0 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -917,6 +917,19 @@ static int strtobool(const char *str, bool *p_val)
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
 	int err;
@@ -932,15 +945,12 @@ static int __dl_argv_handle(char *str, char **p_bus_name, char **p_dev_name)
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
@@ -1075,18 +1085,12 @@ static int dl_argv_handle_region(struct dl *dl, char **p_bus_name,
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

