Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF18351FF19
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 16:08:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236791AbiEIOFI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 10:05:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236790AbiEIOFH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 10:05:07 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2056.outbound.protection.outlook.com [40.107.223.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CE8310C
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 07:01:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lcdw61avKfI0s8IleHqz0hTgy9wMu8BDEpbg+G2pZdE6kLXViYoHjkepqznNd+He6IIvynIXFsgNIQGWsRDDk86EfIzpUZSYQnvfKJMCwJKBCFQf5NfBwkfJeQBmCJkymU4oGHkobLteg1Ll1aq9UrtzNFIsqCQ/0P3AWzQ4lyXLGmjz/COXkF4/oF/8I0cMTndmxVGZ/Xl/YX9ndqbtaVo8l6qzGi3p+UZZAmsKPhlUCPXeSvzKkdNfcMcLh5vqK90r8bS2meWZhRuTs0ic+8M84plQnxCKurNIZWFl+olt1pHdvvmme2WC6EG85wx+Dn6q/RyXBia2FYvsnENflg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MGc96EnJNXVzw28qzy6TsyF6buO9li/EhmtanjECt9Y=;
 b=PI0aZ2Lv8fIQ7eI/E+hyGOg8/oPlZVUD2gkrHwaBJIdPddO63lphCpkx1YNCzy4HlhfeUhgkpVCOURLfLh/yzoh9be78rBprXmx7gEOejcyXc60aCHxBJlS7o8bukM3oozkMhjb1H1BSak9IdgUdlFvP1l2uZH6FFCmlDkVZrqnwY/cfPSAvVuLCIBfDWCy8w3OVnjDkI26SDLolwVVXuQu+5fs3gEvYffDxcLk4VRQEUxARDP//L/2bLnimzWOeVusaddqu7qaQQYyXiFfhOzISXjwW5YT1nuPc8YczhBR3zalvAABdSoIVUP513mhA3Pacpahg5NH9IqKOxuBIDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MGc96EnJNXVzw28qzy6TsyF6buO9li/EhmtanjECt9Y=;
 b=G+TLw+q6xQrbG0pQLnk8egQnzX88H0ynCQ8XNYKh7TReEbE5AcQAMv7kHnbviqIC+UlM3TxpqdBeRmelwQn8imkrMcOYQDMXycfoo1JfYmujOFGEQQ90rQ6qdXdzT/F+MxsrdQcZhI7FPhHn6IvfescZV/mSpyNZnodEiAFeExYS5H8v3lhYMhFcZ5OYHfRyZae1cA2QXXzsLFS3ULATMGXpy5TLoAud8qUwx5uNZCgR8fy5wZL0if/TnlkwvHE4sj6zOI5KyWQ1mrzoIt4Zd0I8A+NY0RWFmnHVuFQgeXxdeAz39PJsSEdQkSDArYxYtfH1W5NozIC2Dz7gwOZGGg==
Received: from MWH0EPF00056D12.namprd21.prod.outlook.com
 (2603:10b6:30f:fff2:0:1:0:15) by MN2PR12MB4520.namprd12.prod.outlook.com
 (2603:10b6:208:26f::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Mon, 9 May
 2022 14:01:10 +0000
Received: from CO1NAM11FT014.eop-nam11.prod.protection.outlook.com
 (2a01:111:f400:7eab::207) by MWH0EPF00056D12.outlook.office365.com
 (2603:1036:d20::b) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.4 via Frontend
 Transport; Mon, 9 May 2022 14:01:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT014.mail.protection.outlook.com (10.13.175.99) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5227.15 via Frontend Transport; Mon, 9 May 2022 14:01:10 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Mon, 9 May
 2022 14:01:09 +0000
Received: from localhost.localdomain (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Mon, 9 May 2022
 07:01:07 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@gmail.com>, Ido Schimmel <idosch@nvidia.com>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH iproute2-next 01/10] iplink: Fix formatting of MPLS stats
Date:   Mon, 9 May 2022 15:59:54 +0200
Message-ID: <dfded37d94dc8db764f00fae062d02504885c858.1652104101.git.petrm@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: 794f290e-a25d-416a-8644-08da31c45ef6
X-MS-TrafficTypeDiagnostic: MN2PR12MB4520:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB4520057586741F583AA25E03D6C69@MN2PR12MB4520.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VIemWb3bj/J43uzgxQnKIKl/mrqbx7bf/HgiPmdxZNMTAPHn1+dpC/lbrLOg2BrMbEtB4fLUBRGGKLHNCL6Vz3cflquZMNhPKhU6ube+IYr0g8NBdQMBo5g5JWVhnhmEzkdkz9BJpxUaEItxauHM7ExgVkPjz63HGlys2B/N9kx4vColmpg00Qh/oTFAWZIbKA8oFnah4OxECX6Vhp+hv/rJS8UoJRco6V2A66/+uIARfH02UKfxfyVr9zRT0AeAwR6TzryjXdwxvxggyeHNDA78lC3MMpytA+DadJ6gs2xTzqVakLw1NwZNk8ivztYCVINrW2P3ITZKHq62C/vPWTDs5xTWiT3h1LQ68zlEquQM8ucq0ueN7aduDsD74gZbjAyzQuNSgy97qbHSnpi98mbtA7pXINn6pRRGNQ1Igt4tWVrLshTSzxitUHr0nwBsJi58SxnVfIcgF9tzVRd7mj3+LEes7IFA+RLxGf3LEEiHb0t9Wd7UATpVajfMoGbm7+juwS5JPu5jXhj7c9POC305qrKixV3xzPKsBfjV6rEo0DT5x8Ug+9poiuKCUKPUE0dVrT/Pa6uEx8d5hFN6Scil5tIfz/3sNjqhyBDP9uvNYPSwJLLnuYx1eSZMR6ouM3XZJUw6uw+UVhqUnZiNtYCsucz/anPx79GoYPMO8Sk9QI0uR9ouEScOrihGdYwzVfVODd1axURy7OAX40QWMQ==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(86362001)(81166007)(4326008)(8676002)(2616005)(36860700001)(26005)(2906002)(6666004)(356005)(83380400001)(8936002)(316002)(40460700003)(5660300002)(6916009)(508600001)(186003)(36756003)(16526019)(82310400005)(70586007)(70206006)(54906003)(426003)(107886003)(47076005)(336012)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2022 14:01:10.1974
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 794f290e-a25d-416a-8644-08da31c45ef6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT014.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4520
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, MPLS stats are formatted this way:

 # ip -n ns0-DBZpxj8I link afstats dev veth01
 3: veth01
     mpls:
         RX: bytes  packets  errors  dropped  noroute
                  0        0       0        0       0
         TX: bytes  packets  errors  dropped
                216        2       0       0

Note how most numbers are not aligned properly under their column headers.
Fix by converting the code to use size_columns() to dynamically determine
the necessary width of individual columns, which also takes care of
formatting the table properly in case the counter values are high.
After the fix, the formatting looks as follows:

 # ip -n ns0-Y1PyEc55 link afstats dev veth01
 3: veth01
     mpls:
         RX: bytes packets errors dropped noroute
                 0       0      0       0       0
         TX: bytes packets errors dropped
               108       1      0       0

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 ip/iplink.c | 44 ++++++++++++++++++++++++++++++++------------
 1 file changed, 32 insertions(+), 12 deletions(-)

diff --git a/ip/iplink.c b/ip/iplink.c
index 23eb6c6e..b87d9bcd 100644
--- a/ip/iplink.c
+++ b/ip/iplink.c
@@ -1521,6 +1521,13 @@ static void print_mpls_stats(FILE *fp, struct rtattr *attr)
 {
 	struct rtattr *mrtb[MPLS_STATS_MAX+1];
 	struct mpls_link_stats *stats;
+	unsigned int cols[] = {
+		strlen("*X: bytes"),
+		strlen("packets"),
+		strlen("errors"),
+		strlen("dropped"),
+		strlen("noroute"),
+	};
 
 	parse_rtattr(mrtb, MPLS_STATS_MAX, RTA_DATA(attr),
 		     RTA_PAYLOAD(attr));
@@ -1528,22 +1535,35 @@ static void print_mpls_stats(FILE *fp, struct rtattr *attr)
 		return;
 
 	stats = RTA_DATA(mrtb[MPLS_STATS_LINK]);
-
 	fprintf(fp, "    mpls:\n");
-	fprintf(fp, "        RX: bytes  packets  errors  dropped  noroute\n");
+
+	size_columns(cols, ARRAY_SIZE(cols),
+		     stats->rx_bytes, stats->rx_packets, stats->rx_errors,
+		     stats->rx_dropped, stats->rx_noroute);
+	size_columns(cols, ARRAY_SIZE(cols),
+		     stats->tx_bytes, stats->tx_packets, stats->tx_errors,
+		     stats->tx_dropped, 0);
+
+	fprintf(fp, "        RX: %*s %*s %*s %*s %*s%s",
+		cols[0] - 4, "bytes", cols[1], "packets",
+		cols[2], "errors", cols[3], "dropped",
+		cols[4], "noroute", _SL_);
 	fprintf(fp, "        ");
-	print_num(fp, 10, stats->rx_bytes);
-	print_num(fp, 8, stats->rx_packets);
-	print_num(fp, 7, stats->rx_errors);
-	print_num(fp, 8, stats->rx_dropped);
-	print_num(fp, 7, stats->rx_noroute);
+	print_num(fp, cols[0], stats->rx_bytes);
+	print_num(fp, cols[1], stats->rx_packets);
+	print_num(fp, cols[2], stats->rx_errors);
+	print_num(fp, cols[3], stats->rx_dropped);
+	print_num(fp, cols[4], stats->rx_noroute);
 	fprintf(fp, "\n");
-	fprintf(fp, "        TX: bytes  packets  errors  dropped\n");
+
+	fprintf(fp, "        TX: %*s %*s %*s %*s%s",
+		cols[0] - 4, "bytes", cols[1], "packets",
+		cols[2], "errors", cols[3], "dropped", _SL_);
 	fprintf(fp, "        ");
-	print_num(fp, 10, stats->tx_bytes);
-	print_num(fp, 8, stats->tx_packets);
-	print_num(fp, 7, stats->tx_errors);
-	print_num(fp, 7, stats->tx_dropped);
+	print_num(fp, cols[0], stats->tx_bytes);
+	print_num(fp, cols[1], stats->tx_packets);
+	print_num(fp, cols[2], stats->tx_errors);
+	print_num(fp, cols[3], stats->tx_dropped);
 	fprintf(fp, "\n");
 }
 
-- 
2.31.1

