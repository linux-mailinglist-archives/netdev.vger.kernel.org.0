Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F95655D49F
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:14:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344918AbiF1KSN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 06:18:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344917AbiF1KSC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 06:18:02 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2054.outbound.protection.outlook.com [40.107.92.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BB512FFD5
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 03:18:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X3i8RJXtU+yIxk2L4BgZXfIGmd232Q+ysB5si9JGlEyc8k65HiHWle9i96HI+iHRk3fOpYKzcR8XsCuZX9A5lq/wDIUZ+voTL8x1myNXzWFgAvXTaeCUWj3nv1AH404mDaHX9B4NXuHC0PXJXco3Il13kvGLTPO0dHAYz115EnNBzHSy8CouLMUM5EhGXgSOEHJ4n522h4vcNyXadUd+utRdYsj976LB3ZTsrf3pWndhZnKbR8y9MkZCmWQaZRMTFMoEChqppPh01nJ3MrPSQlEYYpKTF0QyNtlCDCSxeW1RIjZkesUQOmHpyVDkaXFSXSYISXYbu/0QzWycsH/V9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2r6KPXfT2nMhe4rqZjbt7Uk2XQHLMoYeWJTZqC1tT4Q=;
 b=AOq+LuaFpnzXi1/u1gqLLEw6/OcRGHSrL4YArGHDD1ybiKilZVf1vbvoMOi+U9Q1Ig13nC62raWjFUKIR5IY4W0aio3JWrDbgZ7mTehCfFPfZDW+/Q9/G+noj5H6mGsBR3YmOcExX9RfjXbTOs/YO3yEnIUCVt7MUzdf6gHudtDrGIrt6oOMAPbhY+J3idKqsX1U9l56ORET+gYfBbxTjnmqJTT2KCZNGPKr4zt/En1t6kV/vhjvXRwyZVi5nYc9GfwJ493Xh4Tn35W8NUeiB6Xa3QbemLSzHH9423uWzXcTk+4OkraAQwpnTq+e2m6YbE8Dw5N/7M27CxaGBSPbjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=networkplumber.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2r6KPXfT2nMhe4rqZjbt7Uk2XQHLMoYeWJTZqC1tT4Q=;
 b=lZMn9R2JUjuxt5SrkwtvAVz/tyLo7J8NnUC6Kb/xdDphPQzmw4o7MIziBuJk4gVG6MrWXCG8uBiMabAzgWZ+wkEbanBIPz+8eiVY6I9ttL3/OFkZEd+ukl5gvhgV7LjYXH2bDPtmL4r0kiL5dzNU9qOwFefcT8i8qdboaD1M2pePwOT+WBJSfAjDPjATWkjnQkiXF4UCJ+DPiRTuCQL/LJpiRGpoyWF0nLQ1iY+etJWwKiG+4Od5IBLOW4pLwfkpXEhOmngV/UbVLFC5yFYN4z5mU6IVRpQ0dY51j91XaWiPV9W8GZXXRUxnpwUdNY/X54nF3oJ89v2Tin84057ZBg==
Received: from BN9PR03CA0803.namprd03.prod.outlook.com (2603:10b6:408:13f::28)
 by CH2PR12MB4969.namprd12.prod.outlook.com (2603:10b6:610:68::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17; Tue, 28 Jun
 2022 10:17:57 +0000
Received: from BN8NAM11FT022.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13f:cafe::51) by BN9PR03CA0803.outlook.office365.com
 (2603:10b6:408:13f::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15 via Frontend
 Transport; Tue, 28 Jun 2022 10:17:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT022.mail.protection.outlook.com (10.13.176.112) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5373.15 via Frontend Transport; Tue, 28 Jun 2022 10:17:57 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 28 Jun
 2022 10:17:56 +0000
Received: from localhost.localdomain (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Tue, 28 Jun
 2022 03:17:54 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH iproute2 v2] ip: Fix size_columns() invocation that passes a 32-bit quantity
Date:   Tue, 28 Jun 2022 12:17:31 +0200
Message-ID: <2d920d88cf51f48c0201495ce371817523b7ab48.1656411269.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 586e8210-e151-4654-92e4-08da58ef78b6
X-MS-TrafficTypeDiagnostic: CH2PR12MB4969:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j4Uy1/rs4Nxnja7d/4NEQPox7mQSIozXUnIUxJi4HVnw7f0x6bp/LuTv2bWAlq+aTxtQF4G3Jpe+y8AVY8i9FnMhbOrv+0PjM1rWuAzGLsLwRhhx2r6UhKsZuJvbAw998g2fnAcLx/FlUw66SUKcjjL04V6FT1JJJaLlElyEppCutngQHsFjklwRP5qPsI9QFlN4SHGYi7lWbtZrrMPe+UXWr01lnbo4Kcaw0JSMAkk//dpvmFxc/sOxgSQ+ImGc53KtmcafavXu0DBPjXj6CCDvdhukR07s7Q7/Q/A/ldTuRqIoDJlLYbBjJIt6zoYR6ixk4Yi4S4KixbA5TKt9KSRM0y7EnvqJME4bHM9dHPo52XPcAtY0G8gPDPWTs8aF4YLHhz9veuzaXICfCeTiKTXzoMwgDJM56xM2HXWye8rB4BKyF3WTttG0Due0tgo6yLCKKVzpRosplihlTH+fG9HSsgjBs/3Jfq5Svm1EmOwJdWq+LTKIkJ6d3FNUnz4TQtOtM7BC5IaW1ri1hfErKnUEUv5zlbjnDsCiPZknOIWj1LIakaZ04hcZiyi5PIXvHDIi6aP6sbl4Cpbj4XLt/+OTeKF4GmI4bnLcxO9zjVZslh93GrlPGNPjxRfSygvjgNshriIo2RV5haQ64RAJK3yWsM2JBjZHWY1KsebpLpOIKQPPoXMO/XCZHkEKy8xAJkTSmzLmHPl2y9JiNT8Z10ZGII99c/A+Blcm1DyISdoPtqV6+gEG/iQRRCrnrlmOX754UGrqnZ1yMfrNOBVr5ThoGYZeAP/sQSoKcq4YzWERxMkmRg56XLsGuy1tnc0fQhcKGG/Y197i792/wys2jw==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(346002)(136003)(396003)(36840700001)(46966006)(40470700004)(70586007)(82310400005)(86362001)(81166007)(356005)(2616005)(54906003)(40460700003)(16526019)(47076005)(36756003)(426003)(336012)(6916009)(5660300002)(36860700001)(2906002)(186003)(8676002)(478600001)(4326008)(70206006)(316002)(41300700001)(40480700001)(8936002)(82740400003)(83380400001)(6666004)(107886003)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 10:17:57.0286
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 586e8210-e151-4654-92e4-08da58ef78b6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT022.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4969
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In print_stats64(), the last size_columns() invocation passes number of
carrier changes as one of the arguments. The value is decoded as a 32-bit
quantity, but size_columns() expects a 64-bit one. This is undefined
behavior.

The reason valgrind does not cite this is that the previous size_columns()
invocations prime the ABI area used for the value transfer. When these
other invocations are commented away, valgrind does complain that
"conditional jump or move depends on uninitialised value", as would be
expected.

Fixes: 49437375b6c1 ("ip: dynamically size columns when printing stats")
Signed-off-by: Petr Machata <petrm@nvidia.com>
---

Notes:
    v2:
    - Use a temporary to hold the number of carrier changes.

 ip/ipaddress.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/ip/ipaddress.c b/ip/ipaddress.c
index 5a3b1cae..a288341c 100644
--- a/ip/ipaddress.c
+++ b/ip/ipaddress.c
@@ -783,13 +783,15 @@ void print_stats64(FILE *fp, struct rtnl_link_stats64 *s,
 			     s->tx_bytes, s->tx_packets, s->tx_errors,
 			     s->tx_dropped, s->tx_carrier_errors,
 			     s->collisions, s->tx_compressed);
-		if (show_stats > 1)
+		if (show_stats > 1) {
+			uint64_t cc = carrier_changes ?
+				      rta_getattr_u32(carrier_changes) : 0;
+
 			size_columns(cols, ARRAY_SIZE(cols), 0, 0,
 				     s->tx_aborted_errors, s->tx_fifo_errors,
 				     s->tx_window_errors,
-				     s->tx_heartbeat_errors,
-				     carrier_changes ?
-				     rta_getattr_u32(carrier_changes) : 0);
+				     s->tx_heartbeat_errors, cc);
+		}
 
 		/* RX stats */
 		fprintf(fp, "    RX: %*s %*s %*s %*s %*s %*s %*s%s",
-- 
2.35.3

