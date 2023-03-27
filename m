Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F0ED6CA220
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 13:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232406AbjC0LHO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 07:07:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232366AbjC0LHM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 07:07:12 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2075.outbound.protection.outlook.com [40.107.93.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA3354C18;
        Mon, 27 Mar 2023 04:07:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AGMdvSBW4c1KT4NcoHiJDZgU8aU9ifVtEV46qmCjA8NPr7G17JxXQQ0oiWUQGTKt59TwgDuvLys1u115BiksXn6GK35cLLdH8adaB7V9eqC1SqmcFX14Zghf3+GTvCGDG9mlSmo42SnNaRg8G+XlyYPSF6m8Ovh2l2RQn+i9kxI3MhaAs5uwSE0VQwEdSvXHuVSVi9vC5YdKpREwd0yP9hUe8UugP/lR1V1kZgcrm3wrqaJ/tZTMHK/CF04h5yTC0tiRzMwnM4kO8pD5tko6kaJV/kn5tByXe0ZT1pjAyldOfoJ7+Xcmt2ikYCY7+0caJ2tIgAmn3WtW5DpbGdmMhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sZM9LHbl9/pdkshnCwgZ1Td4H1TAYtRXnqKnaU2BhJc=;
 b=ItwCT9erIAPt3kSlmqIoWg8C7uR3PzNfTYfjGBNG8mp+k1N1UARWoEpggJfqHbuMK41beBaFY9eUEmemKHJPKMN3EZPIp3mXoeheGqcs5Me8Nhvk1fpBQ6qXKQenlzHYSyFi0B68RkVgUBB55XOFqhAn5lMQeVxMyhXNRijxYC0QQE2GJ7q5l0nX3KZIyYyq5E8hwcYC56ZrEKJT5g/MilqtFIvHrejSm23+8XH1hTBBmTp272FKoXYHIBI/4158ZfW6pN0CtO3g04dXuq2jDoj/u0Rlbh8PnXLkqObwBHZ2AtfqELGlN5AwKnILKP8dPjRs6wwtIXImKXUHwnAsJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=microchip.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sZM9LHbl9/pdkshnCwgZ1Td4H1TAYtRXnqKnaU2BhJc=;
 b=GKbO5AgcokeV1vLJ82B2Gk9GEQTBEG53vugzjAqZFPPOBQvtHG79GRdPv40yGjbl+HUI/Y2yr1nd0QsapD6rx7X77ByUadT+1/gNOeC29zy7ffeyVsWJJv6o544v2XJ03ODmsPftZpcgT0r4fDLYN4hZEY9sUdiRLlr1aEwDgXc=
Received: from DM6PR10CA0010.namprd10.prod.outlook.com (2603:10b6:5:60::23) by
 SJ1PR12MB6073.namprd12.prod.outlook.com (2603:10b6:a03:488::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41; Mon, 27 Mar
 2023 11:07:03 +0000
Received: from DS1PEPF0000E650.namprd02.prod.outlook.com
 (2603:10b6:5:60:cafe::1e) by DM6PR10CA0010.outlook.office365.com
 (2603:10b6:5:60::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.43 via Frontend
 Transport; Mon, 27 Mar 2023 11:07:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF0000E650.mail.protection.outlook.com (10.167.18.6) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6178.30 via Frontend Transport; Mon, 27 Mar 2023 11:07:03 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 27 Mar
 2023 06:07:02 -0500
Received: from xhdharinik40.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Mon, 27 Mar 2023 06:06:19 -0500
From:   Harini Katakam <harini.katakam@amd.com>
To:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <richardcochran@gmail.com>, <claudiu.beznea@microchip.com>,
        <andrei.pistirica@microchip.com>, <kuba@kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <michal.simek@amd.com>, <harinikatakamlinux@gmail.com>,
        <harini.katakam@amd.com>
Subject: [PATCH net-next v3 3/3] net: macb: Optimize reading HW timestamp
Date:   Mon, 27 Mar 2023 16:36:07 +0530
Message-ID: <20230327110607.21964-4-harini.katakam@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230327110607.21964-1-harini.katakam@amd.com>
References: <20230327110607.21964-1-harini.katakam@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E650:EE_|SJ1PR12MB6073:EE_
X-MS-Office365-Filtering-Correlation-Id: fbefec9d-b77b-4cb2-d2a7-08db2eb3653d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PQiB+OmwRHnuz1+RhiFJNXXrQB9WIB8REnzgp7owubUjKfy5TWyTWoJcBywCoyP2Js+CXsDh403AwaiiYs5hiqImD9mUHt4a9AaemyhSOAyaeCYJD8KJ1esiupoI/L/KWauTkyZ5//Wr0FJHhbsGy+18JXS1uKyJ/RW25wZckavdWBQfMHwRqmXLxoTRnBcQcb56vOtlwtOvC26N5or9WYueWCey/gkBo5QtjF4zDFDNv78X+/4kxbFNzIlNSz3bjI1cH7dGIgwMOEJrB2F9ARzORhr1VfwSAMVLyed1Vn0tLPvij/g8G8A+BflY0+66xHBgdnFG8olz/bcOOicxdUQ8cQRh+OuxcsOt+2349M/XD1/7M1XQFHr63367nw1up3bDvqVpKloLjBp4KUMNjK1ScuvedthhnUz3I8m4h3MOKENIE6RlfZkMQ3s0kX1aB1dtTtpsqxkon0g/NJ1wpkq+atCRN+n3qGq1vqIoDPHu0y54BTH3MO7DqWxhj1a58xU8pdrDEItNa0ybZL1B0TSOMek5Fj18KwS8Q75UPnLgszQKtGYT13s6F9gRjlwjHhNnVDSJynxdhjZE1ASkrK9Kv1vrdCsfhhRpjHKKyZ+rzPN9+LWelUyo8RpHyK1tRuf3dn/UedfHtMnK9xrUL/nIQrSb/7Jc/X9Y04k5lfMAI+JjK+bc+rbtTY8nfvB5PKh+Mpsh+XdceKPtUNVdaHD+FsIax0DMq0YSNJubu10=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(376002)(346002)(39860400002)(451199021)(36840700001)(40470700004)(46966006)(40460700003)(41300700001)(70586007)(70206006)(4326008)(186003)(36756003)(2906002)(83380400001)(5660300002)(7416002)(36860700001)(336012)(44832011)(82310400005)(426003)(47076005)(356005)(86362001)(82740400003)(2616005)(81166007)(8936002)(40480700001)(6666004)(8676002)(54906003)(110136005)(478600001)(26005)(1076003)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2023 11:07:03.4850
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fbefec9d-b77b-4cb2-d2a7-08db2eb3653d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E650.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6073
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Harini Katakam <harini.katakam@xilinx.com>

The seconds input from BD (6 bits) just needs to be ORed with the
upper bits from timer in this function. Avoid addition operation
every single time. Seconds rollover handling is left untouched.

Signed-off-by: Harini Katakam <harini.katakam@xilinx.com>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
---
v3:
No change
v2:
- Update HW timestamp logic to remove sec_rollover variable as per
Cladiu's comment
- Remove Richard Cochran's ACK on original patch as the patch changed

 drivers/net/ethernet/cadence/macb_ptp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_ptp.c b/drivers/net/ethernet/cadence/macb_ptp.c
index f962a95068a0..51d26fa190d7 100644
--- a/drivers/net/ethernet/cadence/macb_ptp.c
+++ b/drivers/net/ethernet/cadence/macb_ptp.c
@@ -258,6 +258,8 @@ static int gem_hw_timestamp(struct macb *bp, u32 dma_desc_ts_1,
 	 */
 	gem_tsu_get_time(&bp->ptp_clock_info, &tsu, NULL);
 
+	ts->tv_sec |= ((~GEM_DMA_SEC_MASK) & tsu.tv_sec);
+
 	/* If the top bit is set in the timestamp,
 	 * but not in 1588 timer, it has rolled over,
 	 * so subtract max size
@@ -266,8 +268,6 @@ static int gem_hw_timestamp(struct macb *bp, u32 dma_desc_ts_1,
 	    !(tsu.tv_sec & (GEM_DMA_SEC_TOP >> 1)))
 		ts->tv_sec -= GEM_DMA_SEC_TOP;
 
-	ts->tv_sec += ((~GEM_DMA_SEC_MASK) & tsu.tv_sec);
-
 	return 0;
 }
 
-- 
2.17.1

