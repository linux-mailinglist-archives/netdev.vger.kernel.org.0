Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FFA751C3FD
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 17:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243039AbiEEPfw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 11:35:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbiEEPfv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 11:35:51 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2044.outbound.protection.outlook.com [40.107.236.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D26395994F
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 08:32:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BZpj0QaCHiliXhOUoaBot0Xkrm+EPEFd/Zqe2+GS3YoW3zRsaler04yLnhoMnBzAZbUGSP8m+QU7zgrCWFR2+gj6xD/7J9ZZbLuT+OhsDe8kIV+UOY+1JhZkK42BMqgzDzKO29LEhASg2BPwl//IBuglzHG2sY0Gp7VOp9CWrCo2q02qswiZ4vuNyhjM12AoomYgrMatfop1A+tRRrzE6tcaTwKvkgaOfH9mkPSC1ULaUHATMwjTr026TJXBE4vSlk4e0XqYpZ3oE0GLr6A2gbeGMRWNP2J3ykj+zvpwNWzitjCvGZl0gcF1czRZZo3LDX6r1/h1+i8Kqw3/7gM8Mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NGqvC/mxaLZ2/2sR6C5TyD9MjJdRw7tlyN5z7XPHIJo=;
 b=TsXwXJYype///V/MQpGMqv3QWdTUny0dOJ96PGr9hM9hwST9hz2+U3xkE9juyLgihiryy/Ra/i1TEEmhEV4hNIkcfiBmcDKrC+FPJWSZuR5CrsWX/KMqsqN+0XKQI+B4Xrb3UGMfdWvlVoljfz6zv4+kxxRj/jD9thXqv37h7kvT8o8rux6k62by68dP7C7iiA1x9iYm1g1ngbLm2NcVZKtS7DV37Lb0hVYFZHsWe60zTg9qlXxUzZHVAjyq4n/kyEB43oxCzmlKMb9JkTyNlLDPjgEqogr1kayQSrdq83Tocc7b04VG0GA2od0Xkp36FjlAgVIEYwdCiy0PTKpo+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NGqvC/mxaLZ2/2sR6C5TyD9MjJdRw7tlyN5z7XPHIJo=;
 b=lqc1NUGLl99xE7WDZxZtFsEPqi536x0SpYCaaWZT7hW5qY7Q3UvLUyuL1y0dQe+Q2GMUaVhZH+KDbNxm0kxPqOAymjhSpJXX2fUv66brkFAY+xDdQzHF7SZGayW0CvOw9j06sDjaAYnbf8fNbIoXNrDxFaWdqHyIQ0pEJFd8kjAurgbi4l2XjHgXcAs1XKZYBSN+1Ds3cwAtgbrVLYYdqcjKaCbeT8Fs75XDUFWriIenq1VIbK5X+8xDuKC1iKpgw6Ay1+FikYPi0cWHc7EZlkhTiDpXBhOTWAjite1WlxYJBtiHruSJWXPSWVW1Tcqp/1NXA8xPLD3NRgKRjehnHQ==
Received: from MW4P221CA0030.NAMP221.PROD.OUTLOOK.COM (2603:10b6:303:8b::35)
 by DM4PR12MB5312.namprd12.prod.outlook.com (2603:10b6:5:39d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Thu, 5 May
 2022 15:32:02 +0000
Received: from CO1NAM11FT005.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8b:cafe::26) by MW4P221CA0030.outlook.office365.com
 (2603:10b6:303:8b::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.14 via Frontend
 Transport; Thu, 5 May 2022 15:32:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT005.mail.protection.outlook.com (10.13.174.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5227.15 via Frontend Transport; Thu, 5 May 2022 15:32:02 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Thu, 5 May
 2022 15:32:02 +0000
Received: from localhost.localdomain (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Thu, 5 May 2022
 08:32:00 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@gmail.com>, Ido Schimmel <idosch@nvidia.com>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH iproute2-next] ip: ipstats: Do not assume length of response attribute payload
Date:   Thu, 5 May 2022 17:31:34 +0200
Message-ID: <354708bc6198a082432f1119ab4336fdaf5e5342.1651764420.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 18783e91-cc3e-4167-dafd-08da2eac672b
X-MS-TrafficTypeDiagnostic: DM4PR12MB5312:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB53128E2A7A590BBBB1152272D6C29@DM4PR12MB5312.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mA6DJ7Eia8AStbtl5S66IExIwea9st10mheMM/h0+d6WG+xpVL7InyonYFVGPxayW30wjvERfQiHtxolTKBWmzf/etGRaHKEU3/EtHbZnraUONQNkPmS6LeG/xTnDmWM9ILBbeoR6dCt6KLtLZdx4M+3S26H+E7xBrGN3L3Ndnb3u0vVdHh9itfZbQmj30gictskH2bcKSPrAyV8z8dw/TqRlBMJ1wT4lwz0IsoMihlftNztiZyfJSeW0e10bVusNkPlgF8Jjvq9cfuX1Jw+vMNQRLjTY2qvqOo0eksuDv/kPoR5Crg7c54pTDtXwaXp8bQbp8bA5NfTXxPPmmz9HvhCibF3pv6qoySMs3MDg3JCy7qko7GS3q5odI9sDnK15IRDlXA2xoIC3fxf1hsF+GhCpqN8byzJKe2ZrQK4BH8C6F/fLG433Y7QlLah+WmiB2QmBjr6YAy9Qd8EoyNyly1lAYeUCun0nD18T6jOumSqJSjOgKSc8W7AXJauYDc8Bu3OBXy4lwVSeJ8+jwYTzYRrj7ocXWiaRR7M1/TyV0ytyqbrz1EnnD+Od/OGLRegnn22kp0MjfMFRpmwAOacoI7h6ctX1we5y8MU5NkeBbrjnycodjpF0du8+p26Yko7t3ykSHsvxI2AhH6aoIMZKQhJ8VGFszkElvfYEwA0ooIGoLyXQ7eAFLeNTKJX4T3A+fCcxtXUxvXdOIbwRRbkFA==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(186003)(107886003)(47076005)(2616005)(16526019)(36756003)(2906002)(426003)(6916009)(40460700003)(336012)(54906003)(508600001)(6666004)(26005)(316002)(4326008)(5660300002)(356005)(8676002)(36860700001)(86362001)(82310400005)(8936002)(70206006)(81166007)(70586007)(83380400001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2022 15:32:02.5276
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 18783e91-cc3e-4167-dafd-08da2eac672b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT005.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5312
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In Linux kernel commit 794c24e9921f ("net-core: rx_otherhost_dropped to
core_stats"), struct rtnl_link_stats64 got a new member. This change got to
iproute2 through commit bba95837524d ("Update kernel headers").

"ip stats" makes the assumption that the payload of attributes that carry
structures is at least as long as the size of the given structure as
iproute2 knows it. But that will not hold when a newer iproute2 is used
against an older kernel: since such kernel misses some fields on the tail
end of the structure, "ip stats" bails out:

 # ip stats show group link
 1: lo: group link
 Error: attribute payload too shortDump terminated

Instead, be tolerant of responses that are both longer and shorter than
what is expected. Instead of forming a pointer directly into the payload,
allocate the stats structure on the stack, zero it, and then copy over the
portion from the response.

Reported-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Tested-by: Ido Schimmel <idosch@nvidia.com>
---
 ip/ipstats.c | 37 ++++++++++++++-----------------------
 1 file changed, 14 insertions(+), 23 deletions(-)

diff --git a/ip/ipstats.c b/ip/ipstats.c
index 39ddca01..5b9689f4 100644
--- a/ip/ipstats.c
+++ b/ip/ipstats.c
@@ -130,21 +130,21 @@ ipstats_stat_show_attrs_free(struct ipstats_stat_show_attrs *attrs)
 		free(attrs->tbs[i]);
 }
 
-#define IPSTATS_RTA_PAYLOAD(TYPE, AT)					\
-	({								\
+#define IPSTATS_RTA_PAYLOAD(VAR, AT)					\
+	do {								\
 		const struct rtattr *__at = (AT);			\
-		TYPE *__ret = NULL;					\
+		size_t __at_sz = __at->rta_len - RTA_LENGTH(0);		\
+		size_t __var_sz = sizeof(VAR);				\
+		typeof(VAR) *__dest = &VAR;				\
 									\
-		if (__at != NULL &&					\
-		    __at->rta_len - RTA_LENGTH(0) >= sizeof(TYPE))	\
-			__ret = RTA_DATA(__at);				\
-		__ret;							\
-	})
+		memset(__dest, 0, __var_sz);				\
+		memcpy(__dest, RTA_DATA(__at), MIN(__at_sz, __var_sz));	\
+	} while (0)
 
 static int ipstats_show_64(struct ipstats_stat_show_attrs *attrs,
 			   unsigned int group, unsigned int subgroup)
 {
-	struct rtnl_link_stats64 *stats;
+	struct rtnl_link_stats64 stats;
 	const struct rtattr *at;
 	int err;
 
@@ -152,14 +152,10 @@ static int ipstats_show_64(struct ipstats_stat_show_attrs *attrs,
 	if (at == NULL)
 		return err;
 
-	stats = IPSTATS_RTA_PAYLOAD(struct rtnl_link_stats64, at);
-	if (stats == NULL) {
-		fprintf(stderr, "Error: attribute payload too short");
-		return -EINVAL;
-	}
+	IPSTATS_RTA_PAYLOAD(stats, at);
 
 	open_json_object("stats64");
-	print_stats64(stdout, stats, NULL, NULL);
+	print_stats64(stdout, &stats, NULL, NULL);
 	close_json_object();
 	return 0;
 }
@@ -228,15 +224,10 @@ static void print_hw_stats64(FILE *fp, struct rtnl_hw_stats64 *s)
 
 static int ipstats_show_hw64(const struct rtattr *at)
 {
-	struct rtnl_hw_stats64 *stats;
+	struct rtnl_hw_stats64 stats;
 
-	stats = IPSTATS_RTA_PAYLOAD(struct rtnl_hw_stats64, at);
-	if (stats == NULL) {
-		fprintf(stderr, "Error: attribute payload too short");
-		return -EINVAL;
-	}
-
-	print_hw_stats64(stdout, stats);
+	IPSTATS_RTA_PAYLOAD(stats, at);
+	print_hw_stats64(stdout, &stats);
 	return 0;
 }
 
-- 
2.31.1

