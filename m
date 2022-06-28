Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C13355DAEA
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343906AbiF1KUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 06:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243381AbiF1KUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 06:20:19 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2044.outbound.protection.outlook.com [40.107.243.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B29572F666
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 03:19:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LHO5A96pFfKGybU3o7P7LECTC+Y5bvmW/jpGS06kxjI49L7wxz0swi9zcgYrr80hPla5O0JK4HM5z2oIFs6viHzZk9Qrejw/UV2NU6B2/R4+WLo8Q6Ewg8vYPnNGRLuHalhGBxQXd8mZ5hzzDaEJF5tW8dMKUuO3TWbLb7JWJR7I8kXpj6dYE1eEwGKCcizB5ZSgzSk5jmVQDmwAU5NyZJsjZL3SUnw6QqgjkK8uJajlMNRlsvtULF6hEVxIDy0Wt4gFtAk+8H8Urrz9sQX1WS7fZIgCP9bhwTBotlIl+FejlEavwcJrMzT+17vICHkaZrG9Sb7z2jBEWIZFQADZrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a9WT4NOmNqz9nK26GhQnUOOUdRnSO/+UZk2CzuIu75c=;
 b=cdA/JklaLLGiY1+peReTH4cORwK9Dah+9PhEiIzdZkFN6nPBCzkaWff/EfJsz+8Ky2OVnBoHzz7h8JYa9I7DtiNMI8gGM51mX/TQxs0Y6wrLtrg5OfJrAg8ecJDd1IZIdXZHDuDmaC402mM3vsjeVyMI3MxXKK/JLj3ZuiCPGCNVGnBebEx5SrA8dxlsXWeyL9HOGGgOM8RofBNmpmBXjsnGcetENgNQGkbEsGbap45/+KU8keCXvrnZTg+u1bpcC/j2YvqHcAg1HB8LshdC5h2qoeFhE2fW3vVkyZQsQ9bknZr8F+mkwClQC+wI0CTesWTmod/YyiarEZKW9Kx+4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=networkplumber.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a9WT4NOmNqz9nK26GhQnUOOUdRnSO/+UZk2CzuIu75c=;
 b=G/J+kR8txMiVuS6vKL4ia/LWV9as+CRoBmXbRqLnhZr84wtiVnIzjXTfQzZ7HGxNDVgmaDif03OyhGtV1APQig1N5/N5Djk4TTpbYtUJ0ic6NjP3krsy+ZfBMnUDDQO4Zhvk/yQ/kuRSRlpWKjRtMyUomQQ6ahxqxk1xHgmG8qyeY2XqWrgtt1eKRvngHGW5USKEVy4STXNqx+jAn36WlmugLG6BzYHGt2Ldmt+tyl+2AjQ9SHL3ZyZE7luYCLgnOl3Kc8nYvPCUWE6NWUGmBysIxgQVeLjX3kC4RI4QKJULNLiqq55mLX49/7u/aS0AGrSHBRpxlMFdEiaiSLHt1w==
Received: from DM5PR08CA0039.namprd08.prod.outlook.com (2603:10b6:4:60::28) by
 MN2PR12MB4222.namprd12.prod.outlook.com (2603:10b6:208:19a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17; Tue, 28 Jun
 2022 10:19:40 +0000
Received: from DM6NAM11FT024.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:60:cafe::4d) by DM5PR08CA0039.outlook.office365.com
 (2603:10b6:4:60::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14 via Frontend
 Transport; Tue, 28 Jun 2022 10:19:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT024.mail.protection.outlook.com (10.13.172.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5373.15 via Frontend Transport; Tue, 28 Jun 2022 10:19:40 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 28 Jun
 2022 10:19:39 +0000
Received: from localhost.localdomain (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Tue, 28 Jun
 2022 03:19:37 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Petr Machata <petrm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Itay Aveksis <itayav@nvidia.com>
Subject: [PATCH iproute2-next v2] ip: Fix rx_otherhost_dropped support
Date:   Tue, 28 Jun 2022 12:19:11 +0200
Message-ID: <4148bef3a4e4f259aa9fa7936062a4416a035fec.1656411498.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 69b08d77-356f-414e-9420-08da58efb64d
X-MS-TrafficTypeDiagnostic: MN2PR12MB4222:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9YrB+B/Kw6R+VHDZSdj3mLwS7CGEUGSEWXXMKKt7EpjdjKgRLNbA3aQf3HMSjVeUgHlXPcoEGBypVBmxrs6w+K6qLVdfZ3FNSBVftSt404vAUy6EQjs5pNF2OtbwoGt1hY7Tlu601FpbTJr3UOv8J9YlyoEHU1NJX8E3iBxAMLwqUucGdhQukNNKJWGnM/MMu89GJbw5cRMsMwo5oE9r3J9KpUrGYdFFnYhsubBLF1ww1jgGAEr56mYvQEKiscEZZVpVnaI2AUM305RfH0w7UrAFZ7L2OOGrWw1mbpllV+/8cT9+kWegAHCphmi6plhmpz8pLuzimNs8cBR0NgZF0fS0wxSDgfIoac213XVwCie11DaJ0owH60eYq8FRZGnvpeVZzR78QWLQc+OUuFhF3d5KcE0WSUYqbGMVDUgbmqwDzJcJmwBAaykf7CYdm4CUsU/Rj3ll69R8n5NkUzwGCt5az7WAxcrDAYUN8dYY08aJ5MTML/PuMLkvoAfZnEnjuwEtgw1uob/ECqeiUPhICfhk9vaIKeSyHqXhSRqhr2kze162jspsClliyO+qnLpPKehAo7kNUlDwcwvijpipxCs3/oQWpmTU8uB4uqXAWWTypPSZ4if+vFQcB06NkrHoLSh6+WZZx/ktvhQwu7mARbqJAdkImuaSlqfePh0I93XSUSxVkUVC2KkLkFp6idMNLg6ZdYKbo/4tH7kjrBXSKrxT+9eFQf72TjEM6gkZH0NsXBMSF6gPUTXd4Mj61Cisf9HdiRnDuyDMn2CLV98ufrBv2CLEpbA2iw6r1FYlc5KGl0OtuTYH7Qj0hGMp9rsGjgJaVeO+Uj2KJxOGeMHoCg==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(136003)(39860400002)(396003)(36840700001)(46966006)(40470700004)(26005)(8676002)(86362001)(2906002)(6666004)(70586007)(4326008)(40460700003)(426003)(36860700001)(41300700001)(82740400003)(70206006)(82310400005)(478600001)(316002)(36756003)(81166007)(6916009)(107886003)(186003)(2616005)(336012)(5660300002)(54906003)(356005)(16526019)(40480700001)(47076005)(8936002)(83380400001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 10:19:40.4062
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 69b08d77-356f-414e-9420-08da58efb64d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT024.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4222
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The commit cited below added a new column to print_stats64(). However it
then updated only one size_columns() call site, neglecting to update the
remaining three. As a result, in those not-updated invocations,
size_columns() now accesses a vararg argument that is not being passed,
which is undefined behavior.

Fixes: cebf67a35d8a ("show rx_otherehost_dropped stat in ip link show")
CC: Tariq Toukan <tariqt@nvidia.com>
CC: Itay Aveksis <itayav@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---

Notes:
    v2:
    - Adjust to changes in the "32-bit quantity" patch
    - Tweak the commit message for clarity

 ip/ipaddress.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/ip/ipaddress.c b/ip/ipaddress.c
index a288341c..8a78d02c 100644
--- a/ip/ipaddress.c
+++ b/ip/ipaddress.c
@@ -770,10 +770,12 @@ void print_stats64(FILE *fp, struct rtnl_link_stats64 *s,
 		if (what)
 			close_json_object();
 	} else {
+		uint64_t zero64 = 0;
+
 		size_columns(cols, ARRAY_SIZE(cols),
 			     s->rx_bytes, s->rx_packets, s->rx_errors,
 			     s->rx_dropped, s->rx_missed_errors,
-			     s->multicast, s->rx_compressed);
+			     s->multicast, s->rx_compressed, zero64);
 		if (show_stats > 1)
 			size_columns(cols, ARRAY_SIZE(cols), 0,
 				     s->rx_length_errors, s->rx_crc_errors,
@@ -782,7 +784,7 @@ void print_stats64(FILE *fp, struct rtnl_link_stats64 *s,
 		size_columns(cols, ARRAY_SIZE(cols),
 			     s->tx_bytes, s->tx_packets, s->tx_errors,
 			     s->tx_dropped, s->tx_carrier_errors,
-			     s->collisions, s->tx_compressed);
+			     s->collisions, s->tx_compressed, zero64);
 		if (show_stats > 1) {
 			uint64_t cc = carrier_changes ?
 				      rta_getattr_u32(carrier_changes) : 0;
@@ -790,7 +792,7 @@ void print_stats64(FILE *fp, struct rtnl_link_stats64 *s,
 			size_columns(cols, ARRAY_SIZE(cols), 0, 0,
 				     s->tx_aborted_errors, s->tx_fifo_errors,
 				     s->tx_window_errors,
-				     s->tx_heartbeat_errors, cc);
+				     s->tx_heartbeat_errors, cc, zero64);
 		}
 
 		/* RX stats */
-- 
2.35.3

