Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3070492456
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 12:10:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237944AbiARLK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 06:10:26 -0500
Received: from mail-co1nam11on2069.outbound.protection.outlook.com ([40.107.220.69]:18817
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234061AbiARLKZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jan 2022 06:10:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cXaCHvmNaWtoGJsvLj6bZZ8SNLnT3RqAcmosrv5cdNN/2SOR11kXfsU7hU/Wxzqjo0tat7DH+KR2lmPvnOLg/euerUWZy69DzGuKVhJdsc2wANsGAhntJhQPjMWa16oP/P3mdC4vFnvoxwNc19CRGRtZSgd7lsOy0OW1IHA+jXc+8THpW57Ja0TLhXBEgsD5o1xKDQl2H6M66MsS/KlCki290wRir9Zd9xKyVBQXSfb2pO7b6HniMKzdBV+MlYfM358ltBQXBWjCOsq7MkQYO1sO/e8mGUFuVD4oFCHfGp4ml6rodqyUVtLyZzNVK15WdEPEilnAXFKyY4ajyE/81Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qx1N/0f9jSvuMtuXVTY2Dawr0OZcBEdZwEZE33VFYA8=;
 b=WSfh7eHWsKQeZzvjrjq0dOyMbAf5X8t4St0O/pR2W+wOtZgkpzEbn6X89E7VyeaDW2kFze8Am3JrdlrORyI+IVDmneCN35vuLV87D/FNXO4q3vie0XeFqkaHxvbb+NHs6V4m5z7iRYhe4Gtk10ZnyfdwQnPmj91JHAEK4IJURSLXzsNSU+BjoMprFipFTPVPaTbPRBWpnw32eIpWunaY/2SqSy8ktjQbeB6dv42sjxyYRdYboFpMDjEIFSfcMEbqChl4YJWQyHOneAgP9w0sLFyJxtEtt+J+HxOYkDbWakHx0OYkP3BaIkfpDXUe1nWeDnI+HXaj1MRFJoEfvilABg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=networkplumber.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qx1N/0f9jSvuMtuXVTY2Dawr0OZcBEdZwEZE33VFYA8=;
 b=rop896m40UdYP3XOTCu0Nx8DOqTbT8lxKckwZT+IWqAOOQGOyvSshHlVzFBbq7OXQ627liuqphkQmLh8Z3M1Rdl6qbktRLfYNSNczfCMgfM/TWOz79jFw+dVWSpoVSQWzXkAB4BVHGLhZ11nLsa826qQerEg1YYdHYnB3PozZLTzcPOXLKiVjMWfKhYbI/IAIpO//TY9P2tU8o/0+n5DxJ6i79YfCN6Anin2+kB8PTQfv1sdhOpvdoS2odIUUw3bSW3x7B3TMvsT4eqqVy6En5AWkhDtYfhFvrwBcpQJAFJ+AoFXK1fmkUxh/312Xte+H8H5KPOJlDiEAOdqtIs//Q==
Received: from DM5PR12CA0053.namprd12.prod.outlook.com (2603:10b6:3:103::15)
 by MWHPR1201MB0255.namprd12.prod.outlook.com (2603:10b6:301:4f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.10; Tue, 18 Jan
 2022 11:10:23 +0000
Received: from DM6NAM11FT017.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:103:cafe::8) by DM5PR12CA0053.outlook.office365.com
 (2603:10b6:3:103::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.9 via Frontend
 Transport; Tue, 18 Jan 2022 11:10:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT017.mail.protection.outlook.com (10.13.172.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4888.9 via Frontend Transport; Tue, 18 Jan 2022 11:10:23 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 18 Jan
 2022 11:10:18 +0000
Received: from yaviefel.vdiclient.nvidia.com (10.126.230.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9;
 Tue, 18 Jan 2022 03:10:16 -0800
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@gmail.com>, Petr Machata <petrm@nvidia.com>,
        "Stephen Hemminger" <stephen@networkplumber.org>
Subject: [PATCH iproute2-next] dcb: Rewrite array-formatting code to not cause warnings with Clang
Date:   Tue, 18 Jan 2022 12:09:30 +0100
Message-ID: <7993322e608a08f85dc12026412ee6ef345dc7f6.1642503727.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b515d2dd-5fde-4610-54f6-08d9da731f88
X-MS-TrafficTypeDiagnostic: MWHPR1201MB0255:EE_
X-Microsoft-Antispam-PRVS: <MWHPR1201MB02555716F84C840B2A0D38ACD6589@MWHPR1201MB0255.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:605;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sB/cx7oJrbYCEP7+07BAHE3mKOICWUBEj6O+9CphXQxxG9JBWQ5MaWAEXhl8sL/28LKgCHbrc86tJIf6SmZQWOC4knTn/EfeCZALtV1v6s3QA8m8tknQMkB/Sg+IC7nRAz47Mea4CUGetC3836JkNG4sAHlb7EBj0tdy9XWUjoLIGjfO0cUH0KN7apnkS+fIu8rppcNGfGepK3OEND4+m/60jab8JYVMdm/aiCRp+r3MBuOBuD5oH55zqwitEXwCet/3FBxiVRFvoD0F4tZfvKbq3NUHIf+X/AnP+MsBUdZmqPlG2p1jDSUIewoCPoB6pZLkd5C30/IqMBDJOhL6xy3/aPL/tRhjfvfTmOu3s14wjAGkuY62FEDbrjjOUOOtJIsx1nT/wzSNnjJClrkOWabWsLaAQEkBNR+AhAD1vm0w5hU4UBOXnviBysR3R4uNS0Gd9ktJ3rWGPkAriDq7uD03RfAG1vJyK5Jj7rX+p9n7i6CIdgOoLpdx/oTe61VHN95cSXQBoZSXhavQp2/MlfuxVVye1iAN179ezAZOibXjtWJF5etZSctU21qkV/RGwFVaoZfqH7Nd9jqndtRw4JPdGHjiZpFhzTTi9HssJ5wGYZxU8RRNMZO0sq3tg0L/WNsI9mwmiQS8QwrshB50Xvgihv7TMvt3cIDy5AT/+SvtZjkPykZj0uak8fTiNyLYcWXZ8TFuqx9GyDraioszNR3B4JNasG4OKNwAQz2O3a2o7JU/FlO3UySaf/BFM4CzGlRhtBDXFHUh2TufATlHucSfebjvDvtpbsrjy9TZxX4=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(36840700001)(40470700002)(46966006)(6666004)(70586007)(2616005)(356005)(5660300002)(426003)(16526019)(4326008)(7696005)(508600001)(70206006)(8676002)(186003)(36860700001)(81166007)(82310400004)(26005)(83380400001)(316002)(8936002)(54906003)(2906002)(86362001)(336012)(40460700001)(6916009)(47076005)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2022 11:10:23.3352
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b515d2dd-5fde-4610-54f6-08d9da731f88
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT017.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0255
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some installation of Clang are unhappy about the use of a hand-rolled
formatting strings, and emit warnings such as this one:

	dcb.c:334:31: warning: format string is not a string literal
	[-Wformat-nonliteral]

Rewrite the impacted code so that it always uses literal format strings.

Reported-by: Stephen Hemminger <stephen@networkplumber.org>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 dcb/dcb.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/dcb/dcb.c b/dcb/dcb.c
index 696f00e4..b7c2df54 100644
--- a/dcb/dcb.c
+++ b/dcb/dcb.c
@@ -326,51 +326,51 @@ int dcb_set_attribute_bare(struct dcb *dcb, int command, const char *dev,
 
 void dcb_print_array_u8(const __u8 *array, size_t size)
 {
-	SPRINT_BUF(b);
 	size_t i;
 
 	for (i = 0; i < size; i++) {
-		snprintf(b, sizeof(b), "%zd:%%d ", i);
-		print_uint(PRINT_ANY, NULL, b, array[i]);
+		print_uint(PRINT_JSON, NULL, NULL, array[i]);
+		print_uint(PRINT_FP, NULL, "%zd:", i);
+		print_uint(PRINT_FP, NULL, "%d ", array[i]);
 	}
 }
 
 void dcb_print_array_u64(const __u64 *array, size_t size)
 {
-	SPRINT_BUF(b);
 	size_t i;
 
 	for (i = 0; i < size; i++) {
-		snprintf(b, sizeof(b), "%zd:%%" PRIu64 " ", i);
-		print_u64(PRINT_ANY, NULL, b, array[i]);
+		print_u64(PRINT_JSON, NULL, NULL, array[i]);
+		print_uint(PRINT_FP, NULL, "%zd:", i);
+		print_u64(PRINT_FP, NULL, "%" PRIu64 " ", array[i]);
 	}
 }
 
 void dcb_print_array_on_off(const __u8 *array, size_t size)
 {
-	SPRINT_BUF(b);
 	size_t i;
 
 	for (i = 0; i < size; i++) {
-		snprintf(b, sizeof(b), "%zd:%%s ", i);
-		print_on_off(PRINT_ANY, NULL, b, array[i]);
+		print_on_off(PRINT_JSON, NULL, NULL, array[i]);
+		print_uint(PRINT_FP, NULL, "%zd:", i);
+		print_on_off(PRINT_FP, NULL, "%s ", array[i]);
 	}
 }
 
 void dcb_print_array_kw(const __u8 *array, size_t array_size,
 			const char *const kw[], size_t kw_size)
 {
-	SPRINT_BUF(b);
 	size_t i;
 
 	for (i = 0; i < array_size; i++) {
+		const char *str = "???";
 		__u8 emt = array[i];
 
-		snprintf(b, sizeof(b), "%zd:%%s ", i);
 		if (emt < kw_size && kw[emt])
-			print_string(PRINT_ANY, NULL, b, kw[emt]);
-		else
-			print_string(PRINT_ANY, NULL, b, "???");
+			str = kw[emt];
+		print_string(PRINT_JSON, NULL, NULL, str);
+		print_uint(PRINT_FP, NULL, "%zd:", i);
+		print_string(PRINT_FP, NULL, "%s ", str);
 	}
 }
 
-- 
2.31.1

