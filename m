Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D316250B2F8
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 10:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445520AbiDVIea (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 04:34:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1445056AbiDVIe1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 04:34:27 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2046.outbound.protection.outlook.com [40.107.223.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5FCF44A11
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 01:31:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hwWaPj6Wmc2fGZpDkCNmPpslGbgQKPBphN2PmYK1Vjvg+gmxyUbqQwYI/RHhMjmI0LkmcBIaealo2LIEMnD1QAFRT9ZxZduOC8i+67Nk5ooUVedOXY/ZXP1Ptwl5/fG3+bbDgG3B/a4jwHLf+C3U6diuP53KrKM4qGPsDg4cnht+HZPn/Rmn3tqzyrOaZr39BV+Hm01OCVtxut4bKTSqYW0VURUgVbdo3He32IsEWimkKZv0It/D04H+cWx+KZcsPWWzM+/bKUYdupTovc+6w2dWrkV52+Am21sz1n6tGzysiwuhdY3T7bcJnXsYgGUMHbndaILuOE10n3agJbgT6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lMAe0IeKIypUNUHs6oO8rt0D9rLkwWYY76SX/PJZ+xs=;
 b=Pk0wlZynxBa4Gb/BD3hDM2KeL+6Yky4aNaFbEa6qyBVq8ajWmHNr0V5IFMOxWPX5NCA9VOZO0WR1v04yFWsCjWWPXtSQGIbM9GDTPtg6OCyALCAsgkwLd4hG9USuSnGUuNc0xgS4i/zVcKOyVGdtWldVkYnYf5/UArf7jvqtEyzYlyUvCSfYqNToSx8WFE6fgANU/IYLsHyJv48mKaJruxW6+KGTTqH0XepbIXzo0zJ9Q38odQuAtvjOD+ak9QMixIhskk0rJrfqePwMEqOGp9RaggsLS56U+P6c8tPA9Swk4rAkbelFTpfGu2sSr27SXlfRN9ZFIhLZNLdwAQ1KjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=networkplumber.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lMAe0IeKIypUNUHs6oO8rt0D9rLkwWYY76SX/PJZ+xs=;
 b=g96ZxTPhuTECOCM5R9+3yNP7M8TiBA+xziQsLiiRv3WPBV61+xHfkQvn9YItSddkBxPLvc5nsac5PCb53cFVEmi1Os4iUpblONuTZW84URoYXV4EG3r2vTuI2ESIjlWoHCt8gqbE+5suQM8SGySO9gV+ja4ohbAb9uk9rWZo4t+Dd/zOJoQUzJpl78C525kPFVDouGMGiQOAQpng7SoMSAJ5bj3txBaMfnWycaTDyMxRWFyb36uA7ksnzqZpmwem9xT0MQkarqDKHmWE7FcGyUhWqAjlXlKs1LkXSQQOJBG11Gi13Vo4vFMPyevpcp/7S0kZwdzwozjqmLwybjzylg==
Received: from BN9PR03CA0922.namprd03.prod.outlook.com (2603:10b6:408:107::27)
 by BN8PR12MB3298.namprd12.prod.outlook.com (2603:10b6:408:69::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13; Fri, 22 Apr
 2022 08:31:33 +0000
Received: from BN8NAM11FT052.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:107:cafe::3d) by BN9PR03CA0922.outlook.office365.com
 (2603:10b6:408:107::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13 via Frontend
 Transport; Fri, 22 Apr 2022 08:31:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT052.mail.protection.outlook.com (10.13.177.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5186.14 via Frontend Transport; Fri, 22 Apr 2022 08:31:32 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Fri, 22 Apr
 2022 08:31:32 +0000
Received: from localhost.localdomain (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Fri, 22 Apr
 2022 01:31:30 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH iproute2-next 02/11] ip: Publish functions for stats formatting
Date:   Fri, 22 Apr 2022 10:30:51 +0200
Message-ID: <f50f609ec3c1d1db1092b97392f8fd9011ec4b9d.1650615982.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1650615982.git.petrm@nvidia.com>
References: <cover.1650615982.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cc94e508-53ca-422c-cf62-08da243a81c9
X-MS-TrafficTypeDiagnostic: BN8PR12MB3298:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB32988E4296F7EAEE9E36F64AD6F79@BN8PR12MB3298.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wZ4cJYdhQY2QSK5CxrDDGCqHz7o2hm+4LDKDCCAi6i1C8bs8bSOu1VfWQz0lICVO3BiTSXfVHT6NgfdGqm0M4+eeV+ZGnz66wsdxV/ocebcE3ggc78ftgW91FdvvZvSbzLRqgYBpkIZj80kI1l/GfQuM+slRFtWsZPznjP6MO8J0syq5eBCqDxpl7VtaY7suGFTDsti2UnbC2W7eh3x0fqNFI1AfGTJg+hPFbxatp27WEBUPfcOFyHCisRUrfGJJ5Z/68PZl+OMqPt59fxvmStc5ys3hs/cG1L/WmjZgjfKpkMcU7JM8WO7O0ysCq1s0MMR6maO2+KMYL0lty+K0mlZ86ZlOQuH18bPuK+E1grXFqNbKUbNdmGiMvmlxCcfqk2SJINaxUp6MFrLKlSutjlUvSJ1BRhxqb6Zud6/wgwd2uJ8HiHemC3p94Qt3L/aP0F+g4bym6qlK7wA+9VNrTzEueNyiExKioyDreRsuFtakcjIXYULTkDcwdEWfXFCs4Bjv4QrqJerpobxGglS+KIZV2MNrJZZ7mQZdgM4Gymn2qsQL2eV7ROtxZTeQd+SO5i5PzGz6ygCqIuWUqBgJFvop1krjAyFLB0zmovhSJh7czxQqTvnuT+kksqx8DFgo3iUNA9RxW0wpr3fh9QMmp7JUsnXB1sx+ZQkRi7ZTiDj1Xltjt/No5Hwkgre9w+QrbLVFGpXHUJqtYWZAWT7sVg==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(4326008)(8676002)(40460700003)(81166007)(336012)(426003)(47076005)(26005)(86362001)(8936002)(5660300002)(508600001)(70206006)(70586007)(356005)(36860700001)(83380400001)(186003)(82310400005)(16526019)(6666004)(107886003)(2906002)(2616005)(36756003)(54906003)(316002)(6916009)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2022 08:31:32.8661
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cc94e508-53ca-422c-cf62-08da243a81c9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT052.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3298
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Formatting struct rtnl_link_stats64 will be useful outside of iplink.c as
well. Extract from __print_link_stats() a new function, print_stats64(),
make it non-static and publish in the header file.

Additionally, publish the helper size_columns(), which will be useful for
formatting the new struct rtnl_hw_stats64.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 ip/ip_common.h |  3 +++
 ip/ipaddress.c | 33 ++++++++++++++++++++++-----------
 2 files changed, 25 insertions(+), 11 deletions(-)

diff --git a/ip/ip_common.h b/ip/ip_common.h
index ea04c8ff..51a7edc7 100644
--- a/ip/ip_common.h
+++ b/ip/ip_common.h
@@ -171,4 +171,7 @@ void print_rta_ifidx(FILE *fp, __u32 ifidx, const char *prefix);
 void __print_rta_gateway(FILE *fp, unsigned char family, const char *gateway);
 void print_rta_gateway(FILE *fp, unsigned char family,
 		       const struct rtattr *rta);
+void size_columns(unsigned int cols[], unsigned int n, ...);
+void print_stats64(FILE *fp, struct rtnl_link_stats64 *s,
+		   const struct rtattr *carrier_changes, const char *what);
 #endif /* _IP_COMMON_H_ */
diff --git a/ip/ipaddress.c b/ip/ipaddress.c
index a80996ef..17341d28 100644
--- a/ip/ipaddress.c
+++ b/ip/ipaddress.c
@@ -546,7 +546,7 @@ static void print_vfinfo(FILE *fp, struct ifinfomsg *ifi, struct rtattr *vfinfo)
 		print_vf_stats64(fp, vf[IFLA_VF_STATS]);
 }
 
-static void size_columns(unsigned int cols[], unsigned int n, ...)
+void size_columns(unsigned int cols[], unsigned int n, ...)
 {
 	unsigned int i, len;
 	uint64_t val, powi;
@@ -680,10 +680,10 @@ static void print_vf_stats64(FILE *fp, struct rtattr *vfstats)
 	}
 }
 
-static void __print_link_stats(FILE *fp, struct rtattr *tb[])
+void print_stats64(FILE *fp, struct rtnl_link_stats64 *s,
+		   const struct rtattr *carrier_changes,
+		   const char *what)
 {
-	const struct rtattr *carrier_changes = tb[IFLA_CARRIER_CHANGES];
-	struct rtnl_link_stats64 _s, *s = &_s;
 	unsigned int cols[] = {
 		strlen("*X errors:"),
 		strlen("packets"),
@@ -693,14 +693,10 @@ static void __print_link_stats(FILE *fp, struct rtattr *tb[])
 		strlen("overrun"),
 		strlen("compressed"),
 	};
-	int ret;
-
-	ret = get_rtnl_link_stats_rta(s, tb);
-	if (ret < 0)
-		return;
 
 	if (is_json_context()) {
-		open_json_object((ret == sizeof(*s)) ? "stats64" : "stats");
+		if (what)
+			open_json_object(what);
 
 		/* RX stats */
 		open_json_object("rx");
@@ -771,7 +767,8 @@ static void __print_link_stats(FILE *fp, struct rtattr *tb[])
 		}
 
 		close_json_object();
-		close_json_object();
+		if (what)
+			close_json_object();
 	} else {
 		size_columns(cols, ARRAY_SIZE(cols),
 			     s->rx_bytes, s->rx_packets, s->rx_errors,
@@ -870,6 +867,20 @@ static void __print_link_stats(FILE *fp, struct rtattr *tb[])
 	}
 }
 
+static void __print_link_stats(FILE *fp, struct rtattr *tb[])
+{
+	const struct rtattr *carrier_changes = tb[IFLA_CARRIER_CHANGES];
+	struct rtnl_link_stats64 _s, *s = &_s;
+	int ret;
+
+	ret = get_rtnl_link_stats_rta(s, tb);
+	if (ret < 0)
+		return;
+
+	print_stats64(fp, s, carrier_changes,
+		      (ret == sizeof(*s)) ? "stats64" : "stats");
+}
+
 static void print_link_stats(FILE *fp, struct nlmsghdr *n)
 {
 	struct ifinfomsg *ifi = NLMSG_DATA(n);
-- 
2.31.1

