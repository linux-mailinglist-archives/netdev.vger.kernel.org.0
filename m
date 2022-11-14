Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59E0C628105
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 14:16:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237278AbiKNNQ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 08:16:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237315AbiKNNQY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 08:16:24 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2066.outbound.protection.outlook.com [40.107.92.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 096ED63F0
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 05:16:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LWFWP39rNFVguNJGV9D9iTsO+SH0KKLe2zW+uC5pJtLjJ+F5Li3XuI51pOu+Q+5t5onMSlJSBwfoEdC6Vsk9SHM5/OGw20XDyZvl8DU0JX3vNQniaOaUSLeEulVdJRWw5oecmAXhDcCx82jqKk5eOHpswj+Ax8BREQ5w9ZsqnT261lV1N6nAn4/PYbMXyXqiE3gCfi4m20IJXN2x4h1hZGXh5XAhTPiXTy9YA3xV/pdjRKhnjPW/O6pdC6lLziu8sw6LEtiZBYQPEDz5PFpO7a0ysvORevdSmO8bfJYz0S6XJNwdXZsoYPWott3+FTcczPWedsP1b13J4MNJQTu6Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=grtmzp0U1Zf9iUgMMkIwcHdk+0p8o2pteSwJc7qlW2c=;
 b=VVngj4Q/4whinDtbzOBeCK0T7xf3j9TQJCIhWVOlrIYXh7iGGGUIyd0MXvdhF//RD0pXhONkAlHfL92/metdUCb+GhFmvczyUmJVdndIQ2NRKgCMROrkxIqC6GwU9KcdT3+6K+KOeX0frUISQou1+HreESQOBXP1tLiTXaou7wEvaGoL2ehDdnbp55OMJmUswUcklh8tynR2bN35lZrxeXDhSxLxCCzYSLZNG5JcsdyM39QFq2DztLy8rMoadS8o0EpTUpIxWb8pIyDbmk2WVXZELCCoPKpmNYixKNLsZNbVUKNlP48UOkBrc5NARBDaWotbcjNFE3r+YBNGonasAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=grtmzp0U1Zf9iUgMMkIwcHdk+0p8o2pteSwJc7qlW2c=;
 b=fSzDWso8q2ylt6rSfpM9LjLBvWL9ejeb/CBMUgD+MX3+9oaYzwz126mKqaE0jsggjdCU09PmAr/3+7Opc2Ema/8huX6pLY2yG6YjbD8KjHYNk/v1+bmDtbEJ+BnmM2/IREITyk2CT9l+xttZJ0FplfPLuWWQ6US/yXZpTnef79Y=
Received: from DM6PR12CA0021.namprd12.prod.outlook.com (2603:10b6:5:1c0::34)
 by SN7PR12MB7953.namprd12.prod.outlook.com (2603:10b6:806:345::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Mon, 14 Nov
 2022 13:16:18 +0000
Received: from DM6NAM11FT076.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1c0:cafe::dc) by DM6PR12CA0021.outlook.office365.com
 (2603:10b6:5:1c0::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17 via Frontend
 Transport; Mon, 14 Nov 2022 13:16:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT076.mail.protection.outlook.com (10.13.173.204) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5813.12 via Frontend Transport; Mon, 14 Nov 2022 13:16:18 +0000
Received: from SATLEXMB07.amd.com (10.181.41.45) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 14 Nov
 2022 07:16:17 -0600
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB07.amd.com
 (10.181.41.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 14 Nov
 2022 05:16:17 -0800
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34 via Frontend
 Transport; Mon, 14 Nov 2022 07:16:16 -0600
From:   <edward.cree@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH v2 net-next 02/12] sfc: add ability for an RXQ to grant credits on refill
Date:   Mon, 14 Nov 2022 13:15:51 +0000
Message-ID: <7c4eaba1a50db266e7567657a7ec47375eb2b941.1668430870.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1668430870.git.ecree.xilinx@gmail.com>
References: <cover.1668430870.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT076:EE_|SN7PR12MB7953:EE_
X-MS-Office365-Filtering-Correlation-Id: 57964e3c-5274-4ef8-0668-08dac6426a6e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5qzpALPgnqTF4+RZfyT7hcBhDlvMdodruOeEeRHJ85j66u7PZt+v/kfoCWXvK6/Em+urITmaf7zLdxJhda+CziiHjsY5BpdW6qVJR50UCYA966qc5eFw5SfV5TXEVtIgq02zuda9SO0hvsPnGmESnGYisiFmcQA1fFSeVESCIUv4xyVUbmS2fAASaC7plBWHQkdM/WNp+n6Eaok6Za3xakMis+3dM6Nxyq5RGnYh/RND2g5dSdsgDqUl6kmrva6Dk99IsM3QdQBVaWJ6vr/kt+tsjXzsZoyAtcESJ7IhIJCbM4CL4paqz8Y5fK7hMxU/bEsHyL269oNjHWIo/P3sJy3nB3ZDfczU3Zh6roRyN9w1U2nngZVwa56iH1HMe0PKC1spJRVZLOosthwr3olCzHLP0rTQBD7XvCuT0dms2O3usUJJxISRbghXiXCAA+FsOz0AE4+j4njwMMVSPyJ9+mHT+xAtY7xceBbeDeW+H3iE6vFyFj2ihUCsmUVLgwUkxZ0Fs7gGPKRDbqLRCJdc2MxL98uLrVmzzDoxFnQit7LJPUpMiw5+uDEkNNzt+C4t9GjgYDgUJ9AIvMyXL2n/vJP/wyf5ns8VL7/wofzHdv5rJ14Fr5C+nqVD/SHYV2VFXkiibR8pdDXQGsZERrlI9WlAruDw19SJhKgBjKuWUB1S/ZDfIUH+kfGDt7mfUV28HpWUxOCatIF4LrmHmip3aKTbKfpmAkGI+BOqywfVn/KSD1Ot2pp0eaY4KGehXRLXuYvC5TmrfnzyHOW3OFvpBiexCjZBmtOYsOl8/EA19yU=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(136003)(376002)(39860400002)(451199015)(40470700004)(46966006)(36840700001)(9686003)(8676002)(336012)(5660300002)(26005)(186003)(4326008)(8936002)(40480700001)(36756003)(41300700001)(316002)(70206006)(70586007)(82740400003)(55446002)(86362001)(356005)(83380400001)(40460700003)(2876002)(82310400005)(2906002)(426003)(36860700001)(47076005)(81166007)(478600001)(6666004)(6636002)(110136005)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2022 13:16:18.1301
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 57964e3c-5274-4ef8-0668-08dac6426a6e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT076.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7953
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
index 0721260cf2da..735f50385919 100644
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
