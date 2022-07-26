Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00AE7580BCE
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 08:45:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237815AbiGZGpg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 02:45:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237690AbiGZGpd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 02:45:33 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2053.outbound.protection.outlook.com [40.107.95.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B963620BD6
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 23:45:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GqBaOP0yimDqbJsivRR2pgisyGWKtC8mpeL0huJvPmr7zUkmVtwUTuY4JU5uTTx2qzo/5VHtBs847q2tpQNoChYoDE9ZOUaagahJ0xZB8CqZETX8fJuDyhPTn5q+KSJKOpY7qZ1PeHC1oXj4jh1wzRUy+8nGqBbgt36OwbdW7eZBuE1Y0/qIqDVz9Vf5S8Rkfdq9BkQK7+wIaafbe2cG0LbagDyLfwKvgOiEO7FPXr9B21G+tn9qI916F61ULyFI6AtdqltxfSKSY2KFGqJeMT8VlTWCPqe/VdWmykpkUDhdJbhK7WJWzy1KihZXI/FIZexfJ/4SGnVirxYDf5oo2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dO1cSsXTJbmLLBbik37x9HOyKJgvify0vFjPvEHsLjc=;
 b=R5OT9/0NOUtR1op9+uE8VwIDCLn7glvR2uvikk6kAZJh+5XO3YRfPP73YnIuBtzndibE3nv+MBOGYJG+mHLBEaRC/dnrTT1x6NICzVn3qiDlW4OVvlFBiSWfsBCLRtBejaL36nnlHxoxi5Ia4KYoT3F+iBdp2fzluDKBPVTV1x3OdPKJue1qJ87MZKlkVRYv2PXYMUz5dzvgbQnRDfAbKq4juqI6JVguQukk0pfqca40B5Ko90XtKG6M5De2VFzliSx0w8uXL527owP1YRz8abuJs/Y6Bm+vHEDnHcX/ggT+TD67BStGUqGzxV3fJ2OBlQLSb4OVeP1ILS8mYvEL7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dO1cSsXTJbmLLBbik37x9HOyKJgvify0vFjPvEHsLjc=;
 b=0iTFUNherQqp5YT4utNRjy2coq6+2+/M7fEBWh1+Tmeod5uSICgM1vHAMRWTZzwpNTCerp0r8kitg5Cgn2Hl407quoFE6i0tMOv9GTQXdYMib8aRT716Vwv+sMxPpyMqzgCSQ40IlTxFV8hTETCrHCJIMgskZfQpMmIDZ8j12yo=
Received: from MW4PR04CA0070.namprd04.prod.outlook.com (2603:10b6:303:6b::15)
 by DM6PR12MB4546.namprd12.prod.outlook.com (2603:10b6:5:2ae::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.18; Tue, 26 Jul
 2022 06:45:30 +0000
Received: from CO1NAM11FT004.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6b:cafe::d1) by MW4PR04CA0070.outlook.office365.com
 (2603:10b6:303:6b::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.14 via Frontend
 Transport; Tue, 26 Jul 2022 06:45:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT004.mail.protection.outlook.com (10.13.175.89) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5458.17 via Frontend Transport; Tue, 26 Jul 2022 06:45:29 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Tue, 26 Jul
 2022 01:45:25 -0500
Received: from xcbalucerop41x.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Tue, 26 Jul 2022 01:45:24 -0500
From:   <alejandro.lucero-palau@amd.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-net-drivers@amd.com>
CC:     <netdev@vger.kernel.org>, <ecree.xilinx@gmail.com>,
        <habetsm.xilinx@gmail.com>, <edumazet@google.com>, <fw@strlen.de>,
        "Alejandro Lucero" <alejandro.lucero-palau@amd.com>
Subject: [PATCH v3 net] sfc: disable softirqs for ptp TX
Date:   Tue, 26 Jul 2022 08:45:04 +0200
Message-ID: <20220726064504.49613-1-alejandro.lucero-palau@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aa4fc77a-5390-4b83-fa77-08da6ed26e14
X-MS-TrafficTypeDiagnostic: DM6PR12MB4546:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Mahj8WdtcMygi3vlPdfvKiQJ3T8Xj0c9rMOZpvi+6e4oJdxZ7hsm8OQEEevuQmbXTh9pvXTmyWFfmEwc3UkVCsHOycSbwFVX1M62HAovRG6A5WVlAGqEAqGsIBkH6peHwiSoHdeS36gSOYNFrVSNzj4ABqDTRLjuAOehlVUKyFHk0GxqBNmJqRBu6Xn90iO2OqI9qHV053qRQiWtXdMFi0BTBsc8wkP+5DOo9q8rPI0mUgxwT56jtNOUctRve37Ay6PMXGJdXEOo7BFwcwTfNbIZxYXGZGrtGnrY6kfzv5n/vagtT4Fb4wC0OWgGPOskynnqsKfXMV4AHiQbUI0WqPwQk/5ym8KseUT5trnHUBRu8BBW/61gR932TXHL/kmUSc/80lHtmd7ma/emtKOU+JJmrisV4LOeAuOPtZrD6HQ76rMoVWvQJtpu8mu4e6u40+7JRuWbGrkJ01ej/y5jx+G1k0+7ClHeWJMkDav4ljg4/Ps3EsTGgGgnVSR4/1zyFNBd5Lts77zpVyhlU0hJP4SgHmPh5+fm0HG2vDwz//hXciQeH+hcu5orxEXA+XRvWqsva4bXJ/ZBki15rPnAICLt/ovuIY/hmrax0RAIyOifiuwHo/rBvHrUAkfU7xC9wNGQ31EKItw2jgYpTQydAKmf5Kx+XHIMAol4E2SLignl4EoCBhvfYblS8m7vD6LR0GzRNuV4iyZhtN3zX4goZkbCVV/L4AdSas1HsMh27ZwenCLHN8Cnx95IPlP2qiHTWKZwZR3PD2Jy1c2A5wLXm7bqvaLhJy6BygEHdNxdKo77EXH8fRXij0kCS4w/GJ00ArBHr7Wi1tsexl2RVuaU9A==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(136003)(396003)(39860400002)(40470700004)(46966006)(36840700001)(36860700001)(82310400005)(40460700003)(86362001)(81166007)(82740400003)(478600001)(8936002)(356005)(5660300002)(316002)(83380400001)(6636002)(110136005)(54906003)(70206006)(70586007)(4326008)(47076005)(426003)(336012)(1076003)(2616005)(186003)(40480700001)(8676002)(2876002)(6666004)(41300700001)(2906002)(26005)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2022 06:45:29.2902
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: aa4fc77a-5390-4b83-fa77-08da6ed26e14
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT004.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4546
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alejandro Lucero <alejandro.lucero-palau@amd.com>

Sending a PTP packet can imply to use the normal TX driver datapath but
invoked from the driver's ptp worker. The kernel generic TX code
disables softirqs and preemption before calling specific driver TX code,
but the ptp worker does not. Although current ptp driver functionality
does not require it, there are several reasons for doing so:

   1) The invoked code is always executed with softirqs disabled for non
      PTP packets.
   2) Better if a ptp packet transmission is not interrupted by softirq
      handling which could lead to high latencies.
   3) netdev_xmit_more used by the TX code requires preemption to be
      disabled.

Indeed a solution for dealing with kernel preemption state based on static
kernel configuration is not possible since the introduction of dynamic
preemption level configuration at boot time using the static calls
functionality.

Fixes: f79c957a0b537 ("drivers: net: sfc: use netdev_xmit_more helper")
Signed-off-by: Alejandro Lucero <alejandro.lucero-palau@amd.com>
---
 drivers/net/ethernet/sfc/ptp.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/net/ethernet/sfc/ptp.c b/drivers/net/ethernet/sfc/ptp.c
index 4625f85acab2..10ad0b93d283 100644
--- a/drivers/net/ethernet/sfc/ptp.c
+++ b/drivers/net/ethernet/sfc/ptp.c
@@ -1100,7 +1100,29 @@ static void efx_ptp_xmit_skb_queue(struct efx_nic *efx, struct sk_buff *skb)
 
 	tx_queue = efx_channel_get_tx_queue(ptp_data->channel, type);
 	if (tx_queue && tx_queue->timestamping) {
+		/* This code invokes normal driver TX code which is always
+		 * protected from softirqs when called from generic TX code,
+		 * which in turn disables preemption. Look at __dev_queue_xmit
+		 * which uses rcu_read_lock_bh disabling preemption for RCU
+		 * plus disabling softirqs. We do not need RCU reader
+		 * protection here.
+		 *
+		 * Although it is theoretically safe for current PTP TX/RX code
+		 * running without disabling softirqs, there are three good
+		 * reasond for doing so:
+		 *
+		 *      1) The code invoked is mainly implemented for non-PTP
+		 *         packets and it is always executed with softirqs
+		 *         disabled.
+		 *      2) This being a single PTP packet, better to not
+		 *         interrupt its processing by softirqs which can lead
+		 *         to high latencies.
+		 *      3) netdev_xmit_more checks preemption is disabled and
+		 *         triggers a BUG_ON if not.
+		 */
+		local_bh_disable();
 		efx_enqueue_skb(tx_queue, skb);
+		local_bh_enable();
 	} else {
 		WARN_ONCE(1, "PTP channel has no timestamped tx queue\n");
 		dev_kfree_skb_any(skb);
-- 
2.17.1

