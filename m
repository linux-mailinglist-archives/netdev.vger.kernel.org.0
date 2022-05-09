Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25D3951FF17
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 16:08:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236806AbiEIOF2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 10:05:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236807AbiEIOF0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 10:05:26 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2073.outbound.protection.outlook.com [40.107.92.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9176226137
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 07:01:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=axZdRgzr8IA9JVjDxHBFILfqZVULqV7aluwVeMRIY0WLu2Pw53g5wp2xUzjSls1ITaBbWQOsGTrLCBvPT4aULgDV+UZ3yGjxHVnh+ooOwKDrNv7VnBZeCSXeudFPpMIKuGAwMz9+DoISaRIK4HTMwCD6IPPj4/zTMM5liLYagqoCI8Ur/b4KY2ZS2XbrURrATi7qEXo10MGFID7e98QftmbEBk0UskEUTwT23q6ngeGN1F43J8aqAbayxCZkgSVrY6l/Nj0x1SZ6zzzyBTnF/YDnQ4JJYDccO8jZHGzRymWwGhSAYsBA/oDTJ5oJvNvzzNyZVt98ZE3uXKci9nVbug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IsLdGiMnO/zo26p3FeKpyEit06ffVklBF7BsEc1+Xk8=;
 b=ob6PPRlvwjDhbwa08Y/IO1UMxwEo/oybIPHGEkEbUpol7MDRW/yfb46pcvbNHF8hyb5DxWIMqSu1B79mcZoa4mLPlvK8FOCLeaEAIk59LorosoADG8XU4Yn2ee09sNVk7PRaAOpfe9vhO/FW/2nJSylZpyfJIvSKYPGbp8DIZNDxpNJXFt2bzkWpLwfy3eoiGlGOHyNmFdycDr2nEY6/KbNooQusRl+32AXXxdkTsXtMNMrhxh2+ILVIpxU/n9cCpEZFtWzTLx7N42s6h8EP1SnI0G/DFt2vQYQUufj0YGW5ib17Rcr0UKQOAK3tTJNOjsSveNLNL3UoXwHHkbMRQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IsLdGiMnO/zo26p3FeKpyEit06ffVklBF7BsEc1+Xk8=;
 b=FpG53LzQv7TJcYTATwCiazjjL5JbinnVPnDxMKwUPQX0SYGidCV1lBuCjJCio1/jQ8uXKopGRLSUMXeZeWXTwlO5a/DtlVzPjYBWKOCdwqpUQKoWzzJ89BzuP2Zua910hg6XeQfdNYF4vmYS3LxgjFYTfgn8WkWAnCEi84dbet/bAG4WSQP665dptDWXO1Rw8F6LnX5n0zLGuXM6hI9tLT3g3KPYPwZCQbD7G+tg89LR7LO+Jz2r8NyoQKpKdMHb+gFC0vU2JK3lgRaX6waHJRT6LjZSbNOFJDo/Idu9/qsh/5QqL/lTRDnwgtKASNvH07iweYHpJVheVmbL4exa3Q==
Received: from MW4PR03CA0041.namprd03.prod.outlook.com (2603:10b6:303:8e::16)
 by SN6PR12MB4765.namprd12.prod.outlook.com (2603:10b6:805:e4::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.22; Mon, 9 May
 2022 14:01:24 +0000
Received: from CO1NAM11FT022.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8e:cafe::eb) by MW4PR03CA0041.outlook.office365.com
 (2603:10b6:303:8e::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.22 via Frontend
 Transport; Mon, 9 May 2022 14:01:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT022.mail.protection.outlook.com (10.13.175.199) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5227.15 via Frontend Transport; Mon, 9 May 2022 14:01:24 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Mon, 9 May
 2022 14:01:14 +0000
Received: from localhost.localdomain (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Mon, 9 May 2022
 07:01:12 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@gmail.com>, Ido Schimmel <idosch@nvidia.com>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH iproute2-next 04/10] iplink: Add JSON support to MPLS stats formatter
Date:   Mon, 9 May 2022 15:59:57 +0200
Message-ID: <fc7e739575767e427053e191e6cd40868378d320.1652104101.git.petrm@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: baa4eec7-b181-46d8-f2ad-08da31c4679e
X-MS-TrafficTypeDiagnostic: SN6PR12MB4765:EE_
X-Microsoft-Antispam-PRVS: <SN6PR12MB4765164C7E02B7A5481FDCCAD6C69@SN6PR12MB4765.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4RIIyqzomlMy+cTO0WuPZbWipu1TO1wECd1jlMF7B3fybUzK/ZAxiMMGSPiDA2kQOhX0IE3DBIY/b0Kyvzw0NtqDAu3dGKkIwdr0h3zDy51Wd3A+udR0aygSsI0six3PPH7BSbfle6bDqqd8CDflg8baXA2ptjseRsGDOFkRFWOmvwi3dcyFXKDCoyxPmEngX6sVq8nbqYz4swOcQBzqfFl9eEIXZmLYmnfcoOo+2OMuBDIzCMeO1CCURM/R4+htG+LSPMNcSvAuVg8yU1qY9rp/Nh/wxOIsoJBIWUK+immgSOtkzQ8EJXLn7UYgcLcfF3q2mo3OVQZJqCNt2dlqmmqVZYO0IfaGSpM8pwzW+eVTXLTQYSg+rc93G1gTOQO61ZGrdmwzhKKQrET7mcBnZPN6eNkc1q5F1k0XOHWgQd9eomBoPQNDZE9S35zpjZT8jxVCvxPCW9koUcwAjy7RaTflCr/MYOxdlHOJ5dE+sy4hqXRCPJNenPfiDxzgrHB3qZ/6L+46OtZCF/AXjHRyzEFDvkiY4Myo87SFWuoSjwoKlrCKuU1tl1RZBNnNsRjUu2wcQJAb1Bc3MMUtyRTHdpv8pgWpUjUR2wX1NOJUU6qPMS8ODyYOy/7hLquFh2dX7wjoC0/Il+aKom8VN1Exi2ZkKqb6Y71eCJbZeEqNz/1NUMDLr0DM/PK4nxlfbglCB+n+YnsvIbXJyNAZ6CVwCg==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(186003)(40460700003)(83380400001)(2616005)(6916009)(54906003)(107886003)(86362001)(16526019)(356005)(508600001)(336012)(26005)(426003)(47076005)(81166007)(6666004)(316002)(36860700001)(8936002)(2906002)(36756003)(82310400005)(70206006)(8676002)(70586007)(4326008)(5660300002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2022 14:01:24.7073
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: baa4eec7-b181-46d8-f2ad-08da31c4679e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT022.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB4765
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MPLS stats currently do not support dumping in JSON format. Recognize when
JSON is requested and dump in an obvious manner:

 # ip -n ns0-2G8Ozd9z -j stats show dev veth01 group afstats | jq
 [
   {
     "ifindex": 3,
     "ifname": "veth01",
     "group": "afstats",
     "subgroup": "mpls",
     "mpls_stats": {
       "rx": {
         "bytes": 0,
         "packets": 0,
         "errors": 0,
         "dropped": 0,
         "noroute": 0
       },
       "tx": {
         "bytes": 216,
         "packets": 2,
         "errors": 0,
         "dropped": 0
       }
     }
   }
 ]

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 ip/iplink.c | 69 ++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 44 insertions(+), 25 deletions(-)

diff --git a/ip/iplink.c b/ip/iplink.c
index d6662343..fbdf542a 100644
--- a/ip/iplink.c
+++ b/ip/iplink.c
@@ -1528,33 +1528,52 @@ void print_mpls_link_stats(FILE *fp, const struct mpls_link_stats *stats,
 		strlen("noroute"),
 	};
 
-	size_columns(cols, ARRAY_SIZE(cols),
-		     stats->rx_bytes, stats->rx_packets, stats->rx_errors,
-		     stats->rx_dropped, stats->rx_noroute);
-	size_columns(cols, ARRAY_SIZE(cols),
-		     stats->tx_bytes, stats->tx_packets, stats->tx_errors,
-		     stats->tx_dropped, 0);
+	if (is_json_context()) {
+		/* RX stats */
+		open_json_object("rx");
+		print_u64(PRINT_JSON, "bytes", NULL, stats->rx_bytes);
+		print_u64(PRINT_JSON, "packets", NULL, stats->rx_packets);
+		print_u64(PRINT_JSON, "errors", NULL, stats->rx_errors);
+		print_u64(PRINT_JSON, "dropped", NULL, stats->rx_dropped);
+		print_u64(PRINT_JSON, "noroute", NULL, stats->rx_noroute);
+		close_json_object();
 
-	fprintf(fp, "%sRX: %*s %*s %*s %*s %*s%s", indent,
-		cols[0] - 4, "bytes", cols[1], "packets",
-		cols[2], "errors", cols[3], "dropped",
-		cols[4], "noroute", _SL_);
-	fprintf(fp, "%s", indent);
-	print_num(fp, cols[0], stats->rx_bytes);
-	print_num(fp, cols[1], stats->rx_packets);
-	print_num(fp, cols[2], stats->rx_errors);
-	print_num(fp, cols[3], stats->rx_dropped);
-	print_num(fp, cols[4], stats->rx_noroute);
-	fprintf(fp, "\n");
+		/* TX stats */
+		open_json_object("tx");
+		print_u64(PRINT_JSON, "bytes", NULL, stats->tx_bytes);
+		print_u64(PRINT_JSON, "packets", NULL, stats->tx_packets);
+		print_u64(PRINT_JSON, "errors", NULL, stats->tx_errors);
+		print_u64(PRINT_JSON, "dropped", NULL, stats->tx_dropped);
+		close_json_object();
+	} else {
+		size_columns(cols, ARRAY_SIZE(cols), stats->rx_bytes,
+			     stats->rx_packets, stats->rx_errors,
+			     stats->rx_dropped, stats->rx_noroute);
+		size_columns(cols, ARRAY_SIZE(cols), stats->tx_bytes,
+			     stats->tx_packets, stats->tx_errors,
+			     stats->tx_dropped, 0);
 
-	fprintf(fp, "%sTX: %*s %*s %*s %*s%s", indent,
-		cols[0] - 4, "bytes", cols[1], "packets",
-		cols[2], "errors", cols[3], "dropped", _SL_);
-	fprintf(fp, "%s", indent);
-	print_num(fp, cols[0], stats->tx_bytes);
-	print_num(fp, cols[1], stats->tx_packets);
-	print_num(fp, cols[2], stats->tx_errors);
-	print_num(fp, cols[3], stats->tx_dropped);
+		fprintf(fp, "%sRX: %*s %*s %*s %*s %*s%s", indent,
+			cols[0] - 4, "bytes", cols[1], "packets",
+			cols[2], "errors", cols[3], "dropped",
+			cols[4], "noroute", _SL_);
+		fprintf(fp, "%s", indent);
+		print_num(fp, cols[0], stats->rx_bytes);
+		print_num(fp, cols[1], stats->rx_packets);
+		print_num(fp, cols[2], stats->rx_errors);
+		print_num(fp, cols[3], stats->rx_dropped);
+		print_num(fp, cols[4], stats->rx_noroute);
+		fprintf(fp, "\n");
+
+		fprintf(fp, "%sTX: %*s %*s %*s %*s%s", indent,
+			cols[0] - 4, "bytes", cols[1], "packets",
+			cols[2], "errors", cols[3], "dropped", _SL_);
+		fprintf(fp, "%s", indent);
+		print_num(fp, cols[0], stats->tx_bytes);
+		print_num(fp, cols[1], stats->tx_packets);
+		print_num(fp, cols[2], stats->tx_errors);
+		print_num(fp, cols[3], stats->tx_dropped);
+	}
 }
 
 static void print_mpls_stats(FILE *fp, struct rtattr *attr)
-- 
2.31.1

