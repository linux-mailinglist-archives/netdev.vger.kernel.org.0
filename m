Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9136339F4DA
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 13:22:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231560AbhFHLYo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 07:24:44 -0400
Received: from mail-bn7nam10on2049.outbound.protection.outlook.com ([40.107.92.49]:28385
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230190AbhFHLYn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Jun 2021 07:24:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SzRIQtyv8fHvJTMTBclDFNeMq4PYv0zphPtTjdY85U1J8l4e0SRbz9Dx9LVG4P4aTiplaT94F94L+1o1lcbQFCh9HmErPj8coCIz4rnEHi9YJRWh+CONoQXfd6e7lMsvT+UGahRoFeqyN8gOR5r+C193HR1AkhbmwJGHzsW3Oon3cWe+gs6tXjFWYC9r0FkBWnyf8Wilzo6ZioTFZ7IDkf47bgCykLVmGZXfyLir/1GvtXp3FqRusSgOpLprvPi8LBfHMuWBV3r9UFlZKbESoA6Z0RRvG6e77EUvFlm0wc/515sOD/QCV1Hh2R4DMxtt/g/2fdcnTb2dInLhjdbrvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hA46qcSrKUe62XMnMD4DwtX8je0/Owru9t3jx3nHiok=;
 b=IZ0n+LuXG6tFeYeWJYUkhZ0t5z9J1pV9Ywt56RxBELgwuMzyh1UaFDryWpWrnqiTppM0FZnTQS+C5KU9QEjZE+/Y2emyfBG39wlylsiSymh2UVoUxl0t0bLsrtM3ajDqZjmpwB5cL68khbxWMSZoA7bgtlY8Hz1beyi79aCkmk14VcLFFsJgyhSPBCbzHeyT1lesY5X8g/aByKV8pG5GuF2WMyUpSVf49+wiQQevfpjMlu78ZkW/h8OIBErxlU0BUPJNJhrOMVF3KZwpVj0miHik1cFMbsi8p1pdw/7oEfsqJV624b+vEcQyYqNwBu0YDbsXHlgtmSwOlJ1l7owxPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hA46qcSrKUe62XMnMD4DwtX8je0/Owru9t3jx3nHiok=;
 b=GuWiVWo+2u88KxgKrrcaeWXeqNb358akmRHDFGCM5F4KjghQZ6qcGQRm0QSYDL0hKJZK04IV3JtppLSF++VrJN7CuG5RNOoYyv8z5+vO4IwNk9Mt8N3OxK6SFc+AeXdAvgdxal9HE+6xiw4/9nE/es+1X8RmBIEjfIi2fodaaTMd7tpjISCci/4+gRc4UlA5EHCqc6Dw6O5osxmldKR5626st1U+E6ISJ56bNbkGRDkUMh5VB5mhWKHcXCL0AIh1yZgVddGHcLGAMzltFUqkSL9629+/Yx7tWNTRg6gY4x3Ni1OMhjZABi/lLkwsI2Op6rl3/IrGJeV6qbSki4+LbA==
Received: from DS7PR03CA0195.namprd03.prod.outlook.com (2603:10b6:5:3b6::20)
 by DM5PR12MB1419.namprd12.prod.outlook.com (2603:10b6:3:77::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Tue, 8 Jun
 2021 11:22:49 +0000
Received: from DM6NAM11FT036.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b6:cafe::34) by DS7PR03CA0195.outlook.office365.com
 (2603:10b6:5:3b6::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.22 via Frontend
 Transport; Tue, 8 Jun 2021 11:22:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT036.mail.protection.outlook.com (10.13.172.64) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4195.22 via Frontend Transport; Tue, 8 Jun 2021 11:22:49 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 8 Jun
 2021 11:22:49 +0000
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 8 Jun 2021 11:22:42 +0000
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <dsahern@gmail.com>, <stephen@networkplumber.org>,
        <vladbu@nvidia.com>, <parav@nvidia.com>, <huyn@nvidia.com>,
        <dlinkin@nvidia.com>
Subject: [PATCH RESEND iproute2 net-next 2/4] devlink: Add helper function to validate object handler
Date:   Tue, 8 Jun 2021 14:22:32 +0300
Message-ID: <1623151354-30930-3-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1623151354-30930-1-git-send-email-dlinkin@nvidia.com>
References: <1623151354-30930-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d08c8daf-4428-408e-a9c4-08d92a6fbfca
X-MS-TrafficTypeDiagnostic: DM5PR12MB1419:
X-Microsoft-Antispam-PRVS: <DM5PR12MB14194511CDFA34D668553D08CB379@DM5PR12MB1419.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1923;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7Ws5GQOjlSViw421Ao9dY0CsqAzWCwxLOXlNLyeNLc/lp3yTCXl0qyLntq5ZdZvWpSvqsasc6sgNOjNUnyRCjRbsbFbxji/fHOfS683mFeqv7NBsowH8x48tF8JqtiOMhN1ULYvqQ5BpMB9EGzHLsDGRtMGSxRWRwdRWlp61Dqrh57IVn8KOZZvRq7ajd9HxJ/U5foO5cUftMMpwvwhim7oT4MPBQgQTEmxm+Ry02Mq3G5bQDH9qqEGfNXchgn54TzO/2Fh9MhM6cxupXYYMmDrxdRbYpBKBFEXt4rVr0oQnXwvRL96VyRVFXl3S9hW968klDqXyZrgKlfCXpuUtvhbNygpppMHVjEld6ijdHz5WIe9Rz8byPskcJWKO/hOv5u1fxwpgCnQibSUiXmltsKJIzgJDr90rG/HuS1cbnmnoEWRusIHFqc1AxMhMV15NkY1oLuRHEPw+CG9hLpulrJQ0pYQN+26B261roDaEj1zsJlfSsjvn2DiwEqv7co3ij7EgB2HixB+p3/Illiw2zvP76NiYHZD/tjP9E+N1O7YW/PY5OaN481Yac46RvSyR8Dl6H5NOR9Kt4UaML8kly6rCmWR9zJfNw+LkI7nqGw4TGfxX1mb97k4SNAnM/HVey6MLe7kLKXETd+rV2os+zg==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(39860400002)(376002)(36840700001)(46966006)(2906002)(8936002)(8676002)(15650500001)(6666004)(47076005)(82310400003)(70206006)(36860700001)(426003)(336012)(2616005)(4326008)(186003)(478600001)(26005)(54906003)(7696005)(316002)(36906005)(86362001)(83380400001)(107886003)(70586007)(82740400003)(36756003)(7636003)(2876002)(5660300002)(6916009)(356005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2021 11:22:49.6014
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d08c8daf-4428-408e-a9c4-08d92a6fbfca
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT036.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1419
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
index 0b5548f..5b6f059 100644
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
 	int err;
@@ -930,15 +943,12 @@ static int __dl_argv_handle(char *str, char **p_bus_name, char **p_dev_name)
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
@@ -1073,18 +1083,12 @@ static int dl_argv_handle_region(struct dl *dl, char **p_bus_name,
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

