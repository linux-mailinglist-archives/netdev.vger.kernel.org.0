Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FCA06DDB02
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 14:37:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbjDKMhy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 08:37:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230102AbjDKMhn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 08:37:43 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2047.outbound.protection.outlook.com [40.107.92.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD01C4C2E;
        Tue, 11 Apr 2023 05:37:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zgj+h9Mn3VUHBXr6PPOnVcKXGWvO1qA/ZP5wRm3i/xuYtQcwzDmX/SOJuQSSjQLWlaW5JILfvSCC26y2Q2cIBGVwDSTsLZAmV+M4qGXRG3eY7f4S2/uKFkPWCLCtXcU6gUXyLgBTaEt2psNfPmr4Pyp4+rCsJ2tFZCChSg3uXf8nFvHWhJcbPZpYAx1NEL66h4d6G1vNvPuytX4lJoKk48Cuq2Pw9sbKJgmfbwijJZxdV72hyDanL+5qH2WknYSQld7YdnS02MSdfTnDe0GSkvy1y/z69u7vasP2jL1YPFB4ZhuFrI0aeM7cXDH10WzuOkZft3vRT9PFAADKHuMKVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8i90a2xWVVDrtB/5v5OBXa8ysFre5aYy9+409ypsDdw=;
 b=cRRNd2UHTvnmNCAEPlczTaNj9DCmI5GN1lW+uhX+5hHu4KN+HQjnWHR4ESssXpFlOqxCyKtg7hWHLqlECFZszqWCsIz5olVd+cIsZS/q4iZkQ3Sg0EMM/RQPcmgUTR2fCl3+qIhVR3A0N89PNbZTtcLOyUX8TBNNhDGVKpuYkoSkL3j8CG3lPbie6QZkGthtkR/zlySsi1YYCZAqnFocFTqmauxtySJhGnHSGCjco3xyfwBc9zp/Og/4C/TgswerkYyhNWhVGLIJ0F8v9H4iGuSrSEwqCJnu/CXmvPK7F0ToVuo7qo6WXNKYYVSyNazRjW5Wyl1e8xMvk0F3V0VWmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=microchip.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8i90a2xWVVDrtB/5v5OBXa8ysFre5aYy9+409ypsDdw=;
 b=41/+s+u5kwxRU196kmWy6gfafx1vN0JJwT4jnfAkpDR7VD+f/XdiHVomfIZDw4wZ66K5WUesIBfjqAgA+zvyGcbb0P718wYcBOPdZkpvlP41TKTO0Q9/zxg7jZ3bi4Qo74Yz2ml7lkxGOpEkotE18xCOW3gETBW5ud49b//tF9U=
Received: from MW4PR04CA0263.namprd04.prod.outlook.com (2603:10b6:303:88::28)
 by DM4PR12MB7670.namprd12.prod.outlook.com (2603:10b6:8:105::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Tue, 11 Apr
 2023 12:37:34 +0000
Received: from CO1NAM11FT070.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:88:cafe::2b) by MW4PR04CA0263.outlook.office365.com
 (2603:10b6:303:88::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38 via Frontend
 Transport; Tue, 11 Apr 2023 12:37:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT070.mail.protection.outlook.com (10.13.175.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6298.28 via Frontend Transport; Tue, 11 Apr 2023 12:37:34 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 11 Apr
 2023 07:37:33 -0500
Received: from xhdharinik40.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Tue, 11 Apr 2023 07:37:30 -0500
From:   Harini Katakam <harini.katakam@amd.com>
To:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <richardcochran@gmail.com>, <claudiu.beznea@microchip.com>,
        <andrei.pistirica@microchip.com>, <kuba@kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <michal.simek@amd.com>, <harinikatakamlinux@gmail.com>,
        <harini.katakam@amd.com>
Subject: [PATCH net-next v5 3/3] net: macb: Optimize reading HW timestamp
Date:   Tue, 11 Apr 2023 18:07:12 +0530
Message-ID: <20230411123712.11459-4-harini.katakam@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230411123712.11459-1-harini.katakam@amd.com>
References: <20230411123712.11459-1-harini.katakam@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT070:EE_|DM4PR12MB7670:EE_
X-MS-Office365-Filtering-Correlation-Id: cb8e8b03-9a01-4f5c-2f0d-08db3a8986b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TyDJ4znphyRf/JPHC7sveZIbqCxKjIWP+q3gssf1Z/uO2g5c4aZvMyFpH+V6cAWNd2zGK/6DV1seYSmWYYZ97HIoaLKtIrLz2VwWPDHdyE2qEAIdLpXNRlQbfbklWRpV0sKVjkjAsBQtIm4SFXvEufJjs2A13sIRgL1tjhxBTliVRFK9epCvLGUKXGwpDcPoAkbBm+UlzJ/G+PBSwMwekoS+ta6dv7cavW8LCd5aWOwJ3oaHNYB9229PmkTytWVXpBmFJOUbsK97QsOFzCsa6XpErnHTldj+dVILosS9THrFnwjOJCrNz6MZB2ARkUuRME9VUEGMHkvpsSFlrBBGf00ihvRCvVk/7ult1yLFzZnjSwESyyPx0ZVmg0il1c4cMySHnPlYLtGjbqCShHf+MAeaxScuA91+io6LprP/MFqFJotM6sO04rIrFIYW+BHv+qcWHPruG+2MK5KNLiUn/0TQI0ebda0QB9a+wOYei9E/Ol0nb3Lk3TmSgUUdcfmzca/G+JXJ8zr+oaX0CmEN+NcJPZ0qobayJaT2gr0sGLtKcYlA7UzhU63LhlTMx+J69mEoPL7l7qiqK+Yiq/fTtnrLDbYolMxB7Gl0b84Teb8vuhKjvf0YgkP3NbNzW7C1RijtfSrw2PaebetpazRGKtnh9fTcpzouJti/zPnBdqM1tJ5tHOR+3HPpkldVglEK9++qw3tK6cGIz1bRcj/07HDKW+wcSZGC4mAAwEb/oz8=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(39860400002)(346002)(376002)(396003)(451199021)(40470700004)(46966006)(36840700001)(36756003)(110136005)(44832011)(40460700003)(82310400005)(2906002)(5660300002)(7416002)(8936002)(40480700001)(86362001)(8676002)(26005)(6666004)(1076003)(54906003)(36860700001)(478600001)(47076005)(2616005)(336012)(83380400001)(426003)(186003)(70206006)(70586007)(82740400003)(81166007)(41300700001)(356005)(4326008)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 12:37:34.6380
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cb8e8b03-9a01-4f5c-2f0d-08db3a8986b4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT070.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7670
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=no
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
v5 and v4:
No change
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

