Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9ED621A78
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 18:26:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234488AbiKHR0X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 12:26:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234504AbiKHR0R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 12:26:17 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2079.outbound.protection.outlook.com [40.107.100.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F7F84C24B
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 09:26:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VDY9b81rMY6mw+Ky6Iur2eccZbfz6KvVBA2D0gMsMup4S7tytJzBoucrJzZofQPc8wJr/zyVtWj9dLJGjUu9A5pXm+JUhKOLX2YpI6RK8/aygVenC89IVXpByW6LICIBIj/d/frU72zqLZ0T6nWlYx+CidxmaauknUar6og/apEgQI2MWeDPu1Jv6jiml1hWcLGL9mQbQ/V+1J/qGCU8hImKQEN72YxZHEtoOa5mwYLVOBSuHhuCRFut4uM8ubkECBnFhKgvlrfa5NNZxr6yTTWGMwn8S/zNkIZlWesfKf6/yG2VVjEFOogVWJULATMxkneAZdRpL7IEr2GzMg6axQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TK8+jJEsnxXYC4XXgI4jJ5mB8zMC0i8kdqzlaOpGhJM=;
 b=ej6wpan1HSETikLxiqM8iDIwryo5pnOb7gKo5viTDb+PxWODnZrzyAJs+DfqTk2Z8NjF+w/q2vSSGxeJnp/XGLO8nsep3MGuaECwuOvD5yujYLZ2Z/nKY0ATN9nIrfswTNW0YN4F3NXg0wWIpzUaW1Aps5whmC2z4xqRyMPnz5xwG9NhLwS1mt59J7NftKNfJf+NsRoEGL/1to8cTpXgEoJ4MYx2o7HksHwW28qH9QtL0DfTNVQLdBU/d4B+xiQYkErRBEkQM9iioOmKTbqwlweEE4wkBgcchAodsz0Rk6mzT7V1O+8Ztj/7JG/eH7tvgZG+RCSR6ctpjQP0tZwyag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TK8+jJEsnxXYC4XXgI4jJ5mB8zMC0i8kdqzlaOpGhJM=;
 b=3feCc7dWmeawmHdTZ7bK2O0mTbDacPk7ltE/c8yby49tCLBM9dkhXUC+MtxzOJQ07dHDYvuopKzp7mSWbUj6eeBtbk/k4+5nDvXwX8Tvgxk9CLbUCL8ZNOCvcLzA+LQKadgL91kuBPSEsV2mUCIAzo6gKaloLfTbHF/lwaayhDY=
Received: from MW4PR04CA0298.namprd04.prod.outlook.com (2603:10b6:303:89::33)
 by BY5PR12MB4210.namprd12.prod.outlook.com (2603:10b6:a03:203::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Tue, 8 Nov
 2022 17:26:13 +0000
Received: from CO1NAM11FT077.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:89:cafe::96) by MW4PR04CA0298.outlook.office365.com
 (2603:10b6:303:89::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27 via Frontend
 Transport; Tue, 8 Nov 2022 17:26:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT077.mail.protection.outlook.com (10.13.175.55) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5813.12 via Frontend Transport; Tue, 8 Nov 2022 17:26:12 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 8 Nov
 2022 11:26:12 -0600
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 8 Nov
 2022 09:26:12 -0800
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31 via Frontend
 Transport; Tue, 8 Nov 2022 11:26:10 -0600
From:   <edward.cree@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH net-next 01/11] sfc: add ability for an RXQ to grant credits on refill
Date:   Tue, 8 Nov 2022 17:24:42 +0000
Message-ID: <e4836d19950fd06ea33bca213408215bb64020d6.1667923490.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1667923490.git.ecree.xilinx@gmail.com>
References: <cover.1667923490.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT077:EE_|BY5PR12MB4210:EE_
X-MS-Office365-Filtering-Correlation-Id: c058736e-e871-4f4a-e741-08dac1ae5597
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /pP0Q+Gw6ddS68tH8NxM3rVlxCepCOGyTBpFjMtx+FC770pwnWaMeqa3kxE5LySvRVvMrl+JDERlV+vNp7filv8ECkdfakCG/BVx+fd5+mabmS1fFSOXixsask9uiG2pj6sbKJVJZI75KGSsadAdUjLxJD8G4jFdyjN8nCCs5AF+2jtO30OmHNe+aXAhhCf2NeUD7X5yDWuWfZ+pMVO9cntPHShEE6jrzw+AOOQ00zEuFIjLQOv63aSlgP4ALusg0h+/7VrFVB4dcOWf9j7a6fjtUGWJN3RE2toqd/LOAqVFk2jizQ2Y7hk6C2tbH0PFRkJsfEhwa18+wm44ZoBW0sxQFizIPHmxNgNHNost/bTaK5ym3+3VXMt9qcFUEpPFI2spUF5XJFA1P6b9vZ+fU/MSNL5+VLwkHc/N5s8scQW8EvIrkB3rN0iB9l7qqBB/MQ/vuo+3n/nardTUk0Qh6VBeAg9wXehKj9AeZ5XfBC+EK+omyLlfMNNiRhYMwN91TdaUgjPlL7ZSQbi+dFEYrBY+YXnQsSSlFIrRB8iKqLvqrUfmeMpxMGJUfrzmIOcx9Ut+6RfRj1fASoq1yRQUSysG2x+4NyP12gKod7TCxlLRZHYB8V6mcHb0b3zVcS92hCpPypI5uy7ztxOVLqCmRF3RvOHdsxpLXv9Gm5xcTeMAg4wFqenzPSEPbGNT6PFjAkeLzj7cmKGwDZq0ut8fTggxiJHdxFy/h48QGNEiTQ0F8dVb9WXcS+FYDT0EcJdeyV+CySXwC2dGv6A9Yfvt5E97zOBe3E/QLwV4l5OSYJw=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(136003)(39860400002)(346002)(451199015)(46966006)(40470700004)(36840700001)(9686003)(70206006)(70586007)(4326008)(36756003)(8676002)(26005)(8936002)(40460700003)(5660300002)(356005)(41300700001)(316002)(6636002)(110136005)(83380400001)(2876002)(54906003)(55446002)(86362001)(36860700001)(82740400003)(186003)(336012)(81166007)(426003)(2906002)(82310400005)(478600001)(47076005)(40480700001)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2022 17:26:12.9272
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c058736e-e871-4f4a-e741-08dac1ae5597
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT077.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4210
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree.xilinx@gmail.com>

EF100 hardware streams MAE counter updates to the driver over a dedicated
 RX queue; however, the MCPU is not able to detect when RX buffers have
 been posted to the ring.  Thus, the driver must call
 MC_CMD_MAE_COUNTERS_STREAM_GIVE_CREDITS; this patch adds the
 infrastructure to support that to the core RXQ handling code.

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/ef100_rx.c   | 14 +++++++++++---
 drivers/net/ethernet/sfc/net_driver.h |  8 ++++++++
 drivers/net/ethernet/sfc/rx_common.c  |  3 +++
 3 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef100_rx.c b/drivers/net/ethernet/sfc/ef100_rx.c
index 65bbe37753e6..24db44210acc 100644
--- a/drivers/net/ethernet/sfc/ef100_rx.c
+++ b/drivers/net/ethernet/sfc/ef100_rx.c
@@ -183,24 +183,32 @@ void efx_ef100_ev_rx(struct efx_channel *channel, const efx_qword_t *p_event)
 
 void ef100_rx_write(struct efx_rx_queue *rx_queue)
 {
+	unsigned int notified_count = rx_queue->notified_count;
 	struct efx_rx_buffer *rx_buf;
 	unsigned int idx;
 	efx_qword_t *rxd;
 	efx_dword_t rxdb;
 
-	while (rx_queue->notified_count != rx_queue->added_count) {
-		idx = rx_queue->notified_count & rx_queue->ptr_mask;
+	while (notified_count != rx_queue->added_count) {
+		idx = notified_count & rx_queue->ptr_mask;
 		rx_buf = efx_rx_buffer(rx_queue, idx);
 		rxd = efx_rx_desc(rx_queue, idx);
 
 		EFX_POPULATE_QWORD_1(*rxd, ESF_GZ_RX_BUF_ADDR, rx_buf->dma_addr);
 
-		++rx_queue->notified_count;
+		++notified_count;
 	}
+	if (notified_count == rx_queue->notified_count)
+		return;
 
 	wmb();
 	EFX_POPULATE_DWORD_1(rxdb, ERF_GZ_RX_RING_PIDX,
 			     rx_queue->added_count & rx_queue->ptr_mask);
 	efx_writed_page(rx_queue->efx, &rxdb,
 			ER_GZ_RX_RING_DOORBELL, efx_rx_queue_index(rx_queue));
+	if (rx_queue->grant_credits)
+		wmb();
+	rx_queue->notified_count = notified_count;
+	if (rx_queue->grant_credits)
+		schedule_work(&rx_queue->grant_work);
 }
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index 7ef823d7a89a..efb867b6556a 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -363,8 +363,12 @@ struct efx_rx_page_state {
  * @refill_enabled: Enable refill whenever fill level is low
  * @flush_pending: Set when a RX flush is pending. Has the same lifetime as
  *	@rxq_flush_pending.
+ * @grant_credits: Posted RX descriptors need to be granted to the MAE with
+ *	%MC_CMD_MAE_COUNTERS_STREAM_GIVE_CREDITS.  For %EFX_EXTRA_CHANNEL_TC,
+ *	and only supported on EF100.
  * @added_count: Number of buffers added to the receive queue.
  * @notified_count: Number of buffers given to NIC (<= @added_count).
+ * @granted_count: Number of buffers granted to the MAE (<= @notified_count).
  * @removed_count: Number of buffers removed from the receive queue.
  * @scatter_n: Used by NIC specific receive code.
  * @scatter_len: Used by NIC specific receive code.
@@ -385,6 +389,7 @@ struct efx_rx_page_state {
  *	refill was triggered.
  * @recycle_count: RX buffer recycle counter.
  * @slow_fill: Timer used to defer efx_nic_generate_fill_event().
+ * @grant_work: workitem used to grant credits to the MAE if @grant_credits
  * @xdp_rxq_info: XDP specific RX queue information.
  * @xdp_rxq_info_valid: Is xdp_rxq_info valid data?.
  */
@@ -396,9 +401,11 @@ struct efx_rx_queue {
 	unsigned int ptr_mask;
 	bool refill_enabled;
 	bool flush_pending;
+	bool grant_credits;
 
 	unsigned int added_count;
 	unsigned int notified_count;
+	unsigned int granted_count;
 	unsigned int removed_count;
 	unsigned int scatter_n;
 	unsigned int scatter_len;
@@ -416,6 +423,7 @@ struct efx_rx_queue {
 	unsigned int recycle_count;
 	struct timer_list slow_fill;
 	unsigned int slow_fill_count;
+	struct work_struct grant_work;
 	/* Statistics to supplement MAC stats */
 	unsigned long rx_packets;
 	struct xdp_rxq_info xdp_rxq_info;
diff --git a/drivers/net/ethernet/sfc/rx_common.c b/drivers/net/ethernet/sfc/rx_common.c
index 9220afeddee8..d2f35ee15eff 100644
--- a/drivers/net/ethernet/sfc/rx_common.c
+++ b/drivers/net/ethernet/sfc/rx_common.c
@@ -229,6 +229,7 @@ void efx_init_rx_queue(struct efx_rx_queue *rx_queue)
 	/* Initialise ptr fields */
 	rx_queue->added_count = 0;
 	rx_queue->notified_count = 0;
+	rx_queue->granted_count = 0;
 	rx_queue->removed_count = 0;
 	rx_queue->min_fill = -1U;
 	efx_init_rx_recycle_ring(rx_queue);
@@ -281,6 +282,8 @@ void efx_fini_rx_queue(struct efx_rx_queue *rx_queue)
 		  "shutting down RX queue %d\n", efx_rx_queue_index(rx_queue));
 
 	del_timer_sync(&rx_queue->slow_fill);
+	if (rx_queue->grant_credits)
+		flush_work(&rx_queue->grant_work);
 
 	/* Release RX buffers from the current read ptr to the write ptr */
 	if (rx_queue->buffer) {
