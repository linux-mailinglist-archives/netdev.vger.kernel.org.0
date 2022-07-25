Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED22857FDCA
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 12:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234334AbiGYKo4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 06:44:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234772AbiGYKoz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 06:44:55 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2067.outbound.protection.outlook.com [40.107.92.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DA6C17A81
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 03:44:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jahCnuA9lda9QQj7f2QM1je77Hfyieol6eVU0grQ1h5GZwGoN7/tk9L9cv0Jj0NBNdGJfHGibUWCFg1wEbp7+Z4cYXtoAc/mmZox278xd/7UnHKEk908y0m3jvjPvM2eNgAnsW2a/Q3IFGpsauseN5awregULFD0CTwoMmp9+d4XQL1P+8t5106wsqKsNvdJzCezAnvJgMuJ1JuFFtRq+0EvH5XjomjuNhYRw9TJC5qeNDz470y0onKQKoEbY0zFI5XWIMttn7qJ4AvaC4m5oPaxx6JhRXBJr3mYn4VVwRbc+KskFGzOiC/FzcgxXLLLfCSP8cG5E4BDqT2quQX77Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CtWviqhZABb3coVOHdYBLnwsKrUMVinNreSWqEabn38=;
 b=BJDg6G/FTpYOMDCamK3Zt6TY+rDNRmSZ1V6e7rgjGdNdDjojCQOPCIjmyxHvl0Sr7/XX7nsTVN8QEqPGAdpMTjxTM+A1hMym0XNqW0UYMvpi25Exv2Y2Ghhglx/biMGyvl5UKlzN2+YVKz34zd+XpknEZHEMzbkLxxS/HblmTbpw8C7UjKjJHSCr+C58s63icKXMiIheVaLpDENZ4s+YI2f9VPA293z8yZEXXWEpMg6Njz+Pi//kGJKMaV6CGyk2r93FkmOT4xPdrZC7KfpPXHf/QblgkuAMuFYQRbydH6No1VDR2PgpQ0QBm35yarNXyY6EnyGonB30GTlI6mXeNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CtWviqhZABb3coVOHdYBLnwsKrUMVinNreSWqEabn38=;
 b=XF0/wZmPVhXTWRlxQ23w0sutcsPxMFRqwilw7XbUgNIXINfkcWAQqtr5z8xtcp+jTFDO0U+M1UJ8/Df4fjZ8j/gKg/kAmcAFqCHLPTk3qUh21TWVJ1Pby5DXYl6unMeXO1pmiNCbyU3g+dtnK7C4Kdf7MqlVDAjl91r76146n/8=
Received: from BN8PR12CA0024.namprd12.prod.outlook.com (2603:10b6:408:60::37)
 by DM6PR12MB3434.namprd12.prod.outlook.com (2603:10b6:5:3b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Mon, 25 Jul
 2022 10:44:51 +0000
Received: from BN8NAM11FT055.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:60:cafe::6a) by BN8PR12CA0024.outlook.office365.com
 (2603:10b6:408:60::37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.24 via Frontend
 Transport; Mon, 25 Jul 2022 10:44:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT055.mail.protection.outlook.com (10.13.177.62) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5458.17 via Frontend Transport; Mon, 25 Jul 2022 10:44:50 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Mon, 25 Jul
 2022 05:44:42 -0500
Received: from xcbalucerop41x.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Mon, 25 Jul 2022 05:44:41 -0500
From:   <alejandro.lucero-palau@amd.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-net-drivers@amd.com>
CC:     <netdev@vger.kernel.org>, <ecree.xilinx@gmail.com>,
        <habetsm.xilinx@gmail.com>, <edumazet@google.com>,
        Alejandro Lucero <alejandro.lucero-palau@amd.com>
Subject: [PATCH v2 net] sfc: disable softirqs for ptp TX
Date:   Mon, 25 Jul 2022 12:44:33 +0200
Message-ID: <20220725104433.34129-1-alejandro.lucero-palau@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a1720f26-5ca7-4c3e-f04c-08da6e2ab393
X-MS-TrafficTypeDiagnostic: DM6PR12MB3434:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8vno4J8pW55wuFg9ycKswD+s7urnNwXmZRmHiEY0VacNLhv4QklE+ckvXVrtgxA46cj+HEEgaFQfCovbuLu5DE3Q5bHO9UACH3DPt3do0f2R/Rl0sI97ejIxm6FrcgI2c316DQCh1bxbyCDEsvF7Qa6fDXHToyVkaBobJ7Azb6TmvI/gE883bnG8/VsfS9i0gu5gKy7j9c609cRaxNXw7YtKGoVGQ3GbmK7eaJqZhAJ5/ODsOJ73Rh6OLS2NmuCi7F2wHy3EmuwmqLwzPWBy6CxqjOYoU2Zn2DXK9AsQJDWE1nw/4UZqTU+EpueT2NaY1cah6lYHPcZqw5o5qqddb0PcPXcT3mJQO9X3Zg4y/SsU95lyTc45trH2xvP4l1ak9aeUU24qZXvxppdtZSirIwPAMLm9z/uRmxEggqff/sSHetcQamM2kvXkLtURRAdWpc/JCnJqcJLhxu1//MKvAzZSRvL1AlLkLhbqSyWZZoEPpAdhDn5p8b1PB39OYM+xrvpSWEw50gZgMePtVt86NLIE7C+Jr0qc5TBvUO+wMEUWFMgvqJCScSVrYQCoVby5tMQqxuk3I8Idme2zzdMiwxETTZmuD6F6Ak6k5TqMjUOJvXd8dFPrwIRUGYmMC4dCtyfg3YbCK29F686whkFCJp88zXwnn9vdpJhfxuwp6LJKhuFzEIJTolyEhsB+wKw5gbmT/5zf2wG9Eo1ngTROvxDhux2eGgUNYtdeV5YmlJDA/ZptwSb2FrxRz5xvisctqnhtyWAPx+JnOGOW4UB181uKOgPcSZXVawztQ3LC5tXasiXWiHlC7YrXgdfJbEb3TcRkMXWiwS1IOvdIs/ywUw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(136003)(396003)(376002)(39860400002)(346002)(40470700004)(36840700001)(46966006)(47076005)(336012)(86362001)(426003)(186003)(83380400001)(1076003)(36860700001)(82740400003)(40460700003)(110136005)(8676002)(4326008)(6666004)(2616005)(2876002)(316002)(36756003)(70206006)(8936002)(5660300002)(2906002)(81166007)(478600001)(41300700001)(40480700001)(26005)(356005)(6636002)(70586007)(54906003)(82310400005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2022 10:44:50.6064
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a1720f26-5ca7-4c3e-f04c-08da6e2ab393
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT055.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3434
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

