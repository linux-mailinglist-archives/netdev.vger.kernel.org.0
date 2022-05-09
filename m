Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA5B751FF24
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 16:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236814AbiEIOFk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 10:05:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236816AbiEIOF3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 10:05:29 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2079.outbound.protection.outlook.com [40.107.93.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCDDC26ADD
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 07:01:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SryRbJBhiAr/SmTdWqiyoJoc+oZ0WlTsBvfv72ibzlKejGmOBIuGgaNo1GCEpxEhGU4iJz0gbwT84/m42ibnXUEOhDneELuTTqIH70k0Bf453X7vhuHVcjsO5Wklh70yaZpiLNu40scwzzzYGKCM74Fe3lcL8XLKwOjuc/5T23Y3H5si9OtoUItPRIpVVSK6eI76JTbtn7fm1KiL+80aE+HAyjjsnNhBifepv1KiWywtMTvSzLDoNP2z6aKLdefvzF5vztH3Ryi+btC5whH0WbJSYSD8EOTZsxzH9mVdidYAW9Nw82Ko3BS/wSer65ZyK23RsQdQmL0bSYPzssnEQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mrbAFJ2ABCvJOnDoGrXzdJ+UQUJPcc2obILRvVdo6Jw=;
 b=DSCdOrZyfUgkkPre71eLhUMmSjTHqcILn+5TpMZRfxH9iASgk1D415wPsb2F4vrIr80la48lh9PrNwzlXtLFjpeMnj8srVYhyACk34IfYwD+OZur8jyt2hzjA99epvsgnTWEJ+uT3uLTPE4kfJ0ozCHUQU3pkD0lTEHFtf+Ohku5QS+66x5iWsyp8poOkMHuJJkX7ylpZ0kbASy76T7ti9hCsVl3rKMl41zXlSg0tEVrKgb59kWNDVIi8T4oh70emaTACFs9yThVl9qebxetdUFNGDltEsod58xY5MjUVyiOpYa/wg4oOVe54giimBnsqMYkkGpiNwzlnXts9uUxeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mrbAFJ2ABCvJOnDoGrXzdJ+UQUJPcc2obILRvVdo6Jw=;
 b=jnIbvP89dbjEqPHoUHDYMMyc94J9OfTktj93dOqA399YADDOsgFECYW2SO6ozTrpcsi0rQ62xrwj1/krJzbFNi/rEM48diBvwaNVIsh9NUwZT2UW2QoiLqtQ8qth0bY/z7QhgGOTbicLaVODO9K/joiRUevJzoQlE8IZwQZjlfj4Ot8S+yBYfYoRilbFAff1Wiz1N8gFYZ2SlkL/0kCbVrCgJ7MYFJUXLk3+7eWSLIGVnfeGtWPxIq0h3R719qViQ4BhWujs79pjtsHO9Uc/tYBfINLoK1DASRVFwY4pl2R3L2aiQTg6SAJkJBPfxkTC6sjP3ZSKn/1QfWC8XvIPhQ==
Received: from DM6PR02CA0139.namprd02.prod.outlook.com (2603:10b6:5:332::6) by
 MN2PR12MB3136.namprd12.prod.outlook.com (2603:10b6:208:d1::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5227.20; Mon, 9 May 2022 14:01:34 +0000
Received: from DM6NAM11FT050.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:332:cafe::d5) by DM6PR02CA0139.outlook.office365.com
 (2603:10b6:5:332::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23 via Frontend
 Transport; Mon, 9 May 2022 14:01:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT050.mail.protection.outlook.com (10.13.173.111) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5227.15 via Frontend Transport; Mon, 9 May 2022 14:01:34 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Mon, 9 May
 2022 14:01:11 +0000
Received: from localhost.localdomain (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Mon, 9 May 2022
 07:01:09 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@gmail.com>, Ido Schimmel <idosch@nvidia.com>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH iproute2-next 02/10] iplink: Publish a function to format MPLS stats
Date:   Mon, 9 May 2022 15:59:55 +0200
Message-ID: <8c523ff76968b72df235c76a27fa9c3d96cf3b2b.1652104101.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1652104101.git.petrm@nvidia.com>
References: <cover.1652104101.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e6357841-0312-48c3-3fc1-08da31c46d56
X-MS-TrafficTypeDiagnostic: MN2PR12MB3136:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB3136C47EA050F3B33039F00ED6C69@MN2PR12MB3136.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MRCfFRVcWIEZ3/IAZ3SDTygMd5Y6XTlBKRghTZ659qoOx2WpKJ/asT6kUxMgqysfMEGb+xQvxH3GfuleTVhzZ4R91XNuO0IBrQgRGojLwuH8IKmvTiHqnseu6Wd/57tQ4Q/TKX7wnYlXgAy/A8HO591Q32FnKCIHNt2cE7IQhvB4P4ASuLuWDeGVcxYN9XYVdF9TWjm5V6FugBneN8KDRM479aqSJ4P8h6tWSJddFjrCRQvo8YWbvNcaLB0Mt015pqUOe/VVjmY6il5gzCDaRk/zGcxqpWbQQePqVggfP8ZyA9eocSk/fWC4A+c6gepjyCviHZsPxjhjT9WIa4yhhUZ45uFfbZD5WXQmi0aE/H/khwDFE6z386Sr16RhlBPgdXNJuaJylUI/4H3WXCJAmD3ZlF0lpzbyfgfX6Gkmejwg8brVyZd6wXW5oIisGBPHQcgjeqYUzwmzcPiDq8Cw0+gtwccPlRf1xeDTRoxnEE3JadAfWh1oUSzM97L90/ImuSN1R7NUQzjhDgFgsWz7ZcH3lVgRHw8utCNDcfpmsCbVQubDLKx4+PUz93vyWQnKyASiq3p9In1/DnrHWkGI6kEXCta1uL5VHW/oHjB1x48FvJk2w0oFkyD5mHNL62uSvyxhlYHq1oOVmRThr2nWhy7T3+yjZpWXgnpPD80QHC4dzXaP5BwchB6AEXGOebhREMEVcTzAWyOAwu3qTTqhJQ==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(6666004)(86362001)(2906002)(8936002)(5660300002)(356005)(81166007)(83380400001)(508600001)(26005)(107886003)(2616005)(36860700001)(40460700003)(186003)(47076005)(426003)(16526019)(336012)(70206006)(54906003)(316002)(70586007)(4326008)(6916009)(36756003)(8676002)(82310400005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2022 14:01:34.2660
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e6357841-0312-48c3-3fc1-08da31c46d56
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT050.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3136
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extract from print_mpls_stats() a new function, print_mpls_link_stats(),
make it non-static and publish in the header file.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 ip/ip_common.h |  3 +++
 ip/iplink.c    | 36 +++++++++++++++++++++---------------
 2 files changed, 24 insertions(+), 15 deletions(-)

diff --git a/ip/ip_common.h b/ip/ip_common.h
index 9eeeb387..63618f0f 100644
--- a/ip/ip_common.h
+++ b/ip/ip_common.h
@@ -3,6 +3,7 @@
 #define _IP_COMMON_H_
 
 #include <stdbool.h>
+#include <linux/mpls.h>
 
 #include "json_print.h"
 
@@ -202,4 +203,6 @@ void print_rta_gateway(FILE *fp, unsigned char family,
 void size_columns(unsigned int cols[], unsigned int n, ...);
 void print_stats64(FILE *fp, struct rtnl_link_stats64 *s,
 		   const struct rtattr *carrier_changes, const char *what);
+void print_mpls_link_stats(FILE *fp, const struct mpls_link_stats *stats,
+			   const char *indent);
 #endif /* _IP_COMMON_H_ */
diff --git a/ip/iplink.c b/ip/iplink.c
index b87d9bcd..c3ff8a5a 100644
--- a/ip/iplink.c
+++ b/ip/iplink.c
@@ -1517,10 +1517,9 @@ static int do_set(int argc, char **argv)
 }
 #endif /* IPLINK_IOCTL_COMPAT */
 
-static void print_mpls_stats(FILE *fp, struct rtattr *attr)
+void print_mpls_link_stats(FILE *fp, const struct mpls_link_stats *stats,
+			   const char *indent)
 {
-	struct rtattr *mrtb[MPLS_STATS_MAX+1];
-	struct mpls_link_stats *stats;
 	unsigned int cols[] = {
 		strlen("*X: bytes"),
 		strlen("packets"),
@@ -1529,14 +1528,6 @@ static void print_mpls_stats(FILE *fp, struct rtattr *attr)
 		strlen("noroute"),
 	};
 
-	parse_rtattr(mrtb, MPLS_STATS_MAX, RTA_DATA(attr),
-		     RTA_PAYLOAD(attr));
-	if (!mrtb[MPLS_STATS_LINK])
-		return;
-
-	stats = RTA_DATA(mrtb[MPLS_STATS_LINK]);
-	fprintf(fp, "    mpls:\n");
-
 	size_columns(cols, ARRAY_SIZE(cols),
 		     stats->rx_bytes, stats->rx_packets, stats->rx_errors,
 		     stats->rx_dropped, stats->rx_noroute);
@@ -1544,11 +1535,11 @@ static void print_mpls_stats(FILE *fp, struct rtattr *attr)
 		     stats->tx_bytes, stats->tx_packets, stats->tx_errors,
 		     stats->tx_dropped, 0);
 
-	fprintf(fp, "        RX: %*s %*s %*s %*s %*s%s",
+	fprintf(fp, "%sRX: %*s %*s %*s %*s %*s%s", indent,
 		cols[0] - 4, "bytes", cols[1], "packets",
 		cols[2], "errors", cols[3], "dropped",
 		cols[4], "noroute", _SL_);
-	fprintf(fp, "        ");
+	fprintf(fp, "%s", indent);
 	print_num(fp, cols[0], stats->rx_bytes);
 	print_num(fp, cols[1], stats->rx_packets);
 	print_num(fp, cols[2], stats->rx_errors);
@@ -1556,10 +1547,10 @@ static void print_mpls_stats(FILE *fp, struct rtattr *attr)
 	print_num(fp, cols[4], stats->rx_noroute);
 	fprintf(fp, "\n");
 
-	fprintf(fp, "        TX: %*s %*s %*s %*s%s",
+	fprintf(fp, "%sTX: %*s %*s %*s %*s%s", indent,
 		cols[0] - 4, "bytes", cols[1], "packets",
 		cols[2], "errors", cols[3], "dropped", _SL_);
-	fprintf(fp, "        ");
+	fprintf(fp, "%s", indent);
 	print_num(fp, cols[0], stats->tx_bytes);
 	print_num(fp, cols[1], stats->tx_packets);
 	print_num(fp, cols[2], stats->tx_errors);
@@ -1567,6 +1558,21 @@ static void print_mpls_stats(FILE *fp, struct rtattr *attr)
 	fprintf(fp, "\n");
 }
 
+static void print_mpls_stats(FILE *fp, struct rtattr *attr)
+{
+	struct rtattr *mrtb[MPLS_STATS_MAX+1];
+	struct mpls_link_stats *stats;
+
+	parse_rtattr(mrtb, MPLS_STATS_MAX, RTA_DATA(attr),
+		     RTA_PAYLOAD(attr));
+	if (!mrtb[MPLS_STATS_LINK])
+		return;
+
+	stats = RTA_DATA(mrtb[MPLS_STATS_LINK]);
+	fprintf(fp, "    mpls:\n");
+	print_mpls_link_stats(fp, stats, "        ");
+}
+
 static void print_af_stats_attr(FILE *fp, int ifindex, struct rtattr *attr)
 {
 	bool if_printed = false;
-- 
2.31.1

