Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E96FE691F74
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 14:04:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232101AbjBJND6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 08:03:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231685AbjBJND5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 08:03:57 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2065.outbound.protection.outlook.com [40.107.237.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 396A376D06
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 05:03:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OJ84prNtStF/qqhFAYT10Qkl2gpGEmc1cVIEbhuTm06VbWx/NY4xe81FMtMGebWvQo8DbvlPXghDKuI5MAuzVN1yfh+J6tMy7wvaxUiEchQXcqWm86tkpcSQn4cwp7qUoNY7dYIUE9XQ4gOWwBQFL1MlH5nLE2fwBnDwA4YvwNSHFfx6o5wLewKnSIDknVdQyeNpIEwQM2TfParpdq9U4fJTNYGhlNZopFMpIF6UJZ5jVveHe5Fbb5ng1pS4MZLfKCHVIhdp+1vBjp7YH+1ZivRJ+YK8dvSd9o4o4Kf9sMk1sZvWpeqAFfvWzNYe7uhWqW9KcgYNF4e35nkHOA0PpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p4jtEBViYEQsvod9I8IGElFJRCLjaUX3zWkW+LwKYk4=;
 b=D61e5AzNB54C1eqGuPo0ym4numRCFAQFjKaK4rlayOd4etlvrx5uE5UYoJHAyKgMB8zSmSnrvIWwLNPcUmj2c4iZyGGqIT7mE04L1/gSe4QqxGAs2N1HatnmQFdz/J1sFtB+wP8HIzL1B1ECSHXOL4qNYxqBJ9IyHi1XGqIAypRcJleVj2iraXqgydBS7uVTxCmrvzzVVq2MTSR/l5I/yRc65D1tvZYH+tCaWd2L29eoxBUMe134dL23O6K6L3j5OFurrzfmB4hpYGO9nkFGf5n65d/fnZKjbi8aDRWq+WegNlrwmQTEP6N8yIZzqyJCfB2SYC2Y2qb/xAxrV8eJxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p4jtEBViYEQsvod9I8IGElFJRCLjaUX3zWkW+LwKYk4=;
 b=x8fiVyJkYw7Yk5Tkp6Yn1VZvC77YwNYVTHLJJvcDDf8oZtOjceFQCji4c5+EdmKAx2H+le2Dqd7S7a1clowErcxaRvHenGMSmaeQcvRD3Y9cG5DipwjY3UfT6GIafSTsuN8yMUL0KC9AYfvxXmFHljRNnnXv32ZGirxT+lQA36U=
Received: from DS7PR03CA0203.namprd03.prod.outlook.com (2603:10b6:5:3b6::28)
 by DM6PR12MB4124.namprd12.prod.outlook.com (2603:10b6:5:221::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19; Fri, 10 Feb
 2023 13:03:44 +0000
Received: from DM6NAM11FT009.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b6:cafe::b2) by DS7PR03CA0203.outlook.office365.com
 (2603:10b6:5:3b6::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.21 via Frontend
 Transport; Fri, 10 Feb 2023 13:03:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT009.mail.protection.outlook.com (10.13.173.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6086.19 via Frontend Transport; Fri, 10 Feb 2023 13:03:44 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 10 Feb
 2023 07:03:43 -0600
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 10 Feb
 2023 05:03:42 -0800
Received: from xhdipdslab59.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Fri, 10 Feb 2023 07:03:39 -0600
From:   Harsh Jain <h.jain@amd.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <thomas.lendacky@amd.com>,
        <Raju.Rangoju@amd.com>, <Shyam-sundar.S-k@amd.com>,
        <harshjain.prof@gmail.com>, <abhijit.gangurde@amd.com>,
        <puneet.gupta@amd.com>, <nikhil.agarwal@amd.com>,
        <tarak.reddy@amd.com>, <netdev@vger.kernel.org>
CC:     Harsh Jain <h.jain@amd.com>
Subject: [PATCH  2/6] net: ethernet: efct: Add datapath
Date:   Fri, 10 Feb 2023 18:33:17 +0530
Message-ID: <20230210130321.2898-3-h.jain@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230210130321.2898-1-h.jain@amd.com>
References: <20230210130321.2898-1-h.jain@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT009:EE_|DM6PR12MB4124:EE_
X-MS-Office365-Filtering-Correlation-Id: d1fa5e7e-40e0-4ecc-4466-08db0b673d53
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gOnQ0wAVnQGrWxhAGWVOBg3ntZ5SIdmed4pHDR5YYTEZuJZJ1keXdJ4NqEn/uX26Yv0GI2S+zOxcndISlV9ile5pHaaZ8OLvF8wlgpkWodsagukdjn/oHUVs+4sRG0lWp9i4HT6J4j/EgbiWm443A/6lBVwBezaPDvGoUTJh22z+DOy/e7i0Qcg0b+NVLc7hOLycURRGknccFCDc98MDdnca/j87Ol42EctDG744IZ+rMO+pE3GC27go2dIM49KnB5hsPpjHaeILBlgO1q/aR81YKSn++unJftZNVp1z0S5ibsMQ2uONtbHUM47qmnLupM1iuhGTE4IFIDYtAcUoSqljBFD3S2slRXOZeWFYn3JbuS+6CvnAnkPWobcj/TktxzhYou+8rplPzA8LkX0bVF1hh3Y1vPxJ74IHcByk/fcLh3pOOM1E9+sX22AKtuiqdU1S+61moNz3K3uEJJmRnp4kgfTdEYgmZ5bvDCNqdrsR5amAws+yGL0gJNVlrb7W1fylVANdGutJkGPrxB+MLSvmm6Fbask59rxXQVeSg+eO5xQvrn9cYxgRyel3lMkLCfyGQZm9AmGfXnpMp9o8YIxujI23sNruBny1AqvztEBpug42e+ldPz9sI9GU4FRWz5vQ+yo7PAfVDnhme3wsPVMtRlZS9JHoqoXt3g57MOQ28QZO127jxpOManZ2N5Esx7pKWYFCLqWGbrSV0VuGI9s0PzSDKx0Bx6U/gTpndDenqOUwycBubGhJtoY2mKGY
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(39860400002)(396003)(376002)(451199018)(40470700004)(36840700001)(46966006)(36756003)(2906002)(82310400005)(40480700001)(36860700001)(6666004)(2616005)(478600001)(47076005)(426003)(336012)(26005)(83380400001)(40460700003)(70586007)(70206006)(8676002)(4326008)(86362001)(30864003)(1076003)(186003)(41300700001)(81166007)(5660300002)(316002)(82740400003)(110136005)(921005)(356005)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 13:03:44.0680
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d1fa5e7e-40e0-4ecc-4466-08db0b673d53
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT009.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4124
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds the driver's data path.

Tx:
TX path operates in Cut Through Programmed Input/Output (CTPIO).
packets are streamed directly from the PCIe interface to the
adapter port to deliver in lowest TX latency. It waits for certain
threshold bytes to be available before starting to stream packet
data from the FIFO to the MAC. The NIC computes the FCS for the
Ethernet frame and host is expected to supply the packet with all
other checksums.

Rx:
Driver posts 1MB buffer to NIC. NIC will split those buffer into fixed
size(configured in queue setup) packet buffers. NIC DMA the packet in
along with metadata(length, timestamp, checksum etc) of previous packet.
In case there is no following packet H/W will only write metadata in packet
buffer.

Signed-off-by: Abhijit Gangurde<abhijit.gangurde@amd.com>
Signed-off-by: Puneet Gupta <puneet.gupta@amd.com>
Signed-off-by: Nikhil Agarwal<nikhil.agarwal@amd.com>
Signed-off-by: Tarak Reddy<tarak.reddy@amd.com>
Signed-off-by: Harsh Jain <h.jain@amd.com>
---
 drivers/net/ethernet/amd/efct/efct_netdev.c |  17 +
 drivers/net/ethernet/amd/efct/efct_nic.c    | 197 +++++++
 drivers/net/ethernet/amd/efct/efct_rx.c     | 556 ++++++++++++++++++++
 drivers/net/ethernet/amd/efct/efct_rx.h     |  22 +
 drivers/net/ethernet/amd/efct/efct_tx.c     | 313 +++++++++++
 drivers/net/ethernet/amd/efct/efct_tx.h     |  17 +
 6 files changed, 1122 insertions(+)
 create mode 100644 drivers/net/ethernet/amd/efct/efct_rx.c
 create mode 100644 drivers/net/ethernet/amd/efct/efct_rx.h
 create mode 100644 drivers/net/ethernet/amd/efct/efct_tx.c
 create mode 100644 drivers/net/ethernet/amd/efct/efct_tx.h

diff --git a/drivers/net/ethernet/amd/efct/efct_netdev.c b/drivers/net/ethernet/amd/efct/efct_netdev.c
index 41aa4e28c676..23a776ab88a3 100644
--- a/drivers/net/ethernet/amd/efct/efct_netdev.c
+++ b/drivers/net/ethernet/amd/efct/efct_netdev.c
@@ -221,6 +221,22 @@ static int efct_net_stop(struct net_device *net_dev)
 	return 0;
 }
 
+static netdev_tx_t efct_start_xmit(struct sk_buff *skb, struct net_device *net_dev)
+{
+	struct efct_nic *efct = efct_netdev_priv(net_dev);
+	struct efct_tx_queue *tx_queue;
+	int qid;
+	int rc;
+
+	qid = skb_get_queue_mapping(skb);
+	tx_queue = &efct->txq[qid];
+	rc = efct_enqueue_skb(tx_queue, skb, net_dev);
+	if (rc)
+		atomic64_inc(&tx_queue->efct->n_tx_sw_drops);
+
+	return NETDEV_TX_OK;
+}
+
 /* Context: netif_tx_lock held, BHs disabled. */
 static void efct_watchdog(struct net_device *net_dev, unsigned int txqueue)
 {
@@ -304,6 +320,7 @@ static void efct_net_stats(struct net_device *net_dev, struct rtnl_link_stats64
 static const struct net_device_ops efct_netdev_ops = {
 	.ndo_open               = efct_net_open,
 	.ndo_stop               = efct_net_stop,
+	.ndo_start_xmit         = efct_start_xmit,
 	.ndo_tx_timeout         = efct_watchdog,
 	.ndo_get_stats64        = efct_net_stats,
 	.ndo_eth_ioctl		= efct_eth_ioctl,
diff --git a/drivers/net/ethernet/amd/efct/efct_nic.c b/drivers/net/ethernet/amd/efct/efct_nic.c
index 0be2bea0c903..0610b4633e15 100644
--- a/drivers/net/ethernet/amd/efct/efct_nic.c
+++ b/drivers/net/ethernet/amd/efct/efct_nic.c
@@ -518,6 +518,125 @@ static int efct_ev_init(struct efct_ev_queue *eventq)
 	return 0;
 }
 
+//TX queue initialization
+static int efct_tx_probe(struct efct_nic *efct, u32 evq_index, int txq_index)
+{
+	if (!efct)
+		return -EINVAL;
+	if (txq_index == -1)
+		txq_index = txq_get_free_index(efct);
+	else
+		if (test_and_set_bit(txq_index, &efct->txq_active_mask))
+			txq_index = -EINVAL;
+
+	if (txq_index < 0) {
+		netif_err(efct, drv, efct->net_dev,
+			  "Failed to find the free Tx index\n");
+		return txq_index;
+	}
+	efct->txq[txq_index].piobuf = efct->wc_membase +
+				      (txq_index * efct->efct_dev->params.ctpio_stride);
+	efct->txq[txq_index].evq_index = evq_index;
+	efct->txq[txq_index].label = txq_index;
+	if (efct->evq[evq_index].type != EVQ_T_AUX)
+		efct->txq[txq_index].core_txq = netdev_get_tx_queue(efct->net_dev, 0);
+	else
+		efct->txq[txq_index].core_txq = NULL;
+	efct->txq[txq_index].aperture_qword = efct->efct_dev->params.tx_aperture_size / 8;
+	efct->txq[txq_index].fifo_size = efct->efct_dev->params.tx_fifo_size;
+
+	return txq_index;
+}
+
+static int efct_tx_init(struct efct_tx_queue *tx_queue)
+{
+	int rc;
+
+	if (!tx_queue)
+		return -EINVAL;
+
+	tx_queue->completed_sequence = 255;
+	tx_queue->added_sequence = 0;
+	tx_queue->piobuf_offset = 0;
+	tx_queue->ct_thresh = tx_queue->efct->ct_thresh;
+	tx_queue->pkts = 0;
+	tx_queue->bytes = 0;
+	atomic_set(&tx_queue->inuse_fifo_bytes, 0);
+	atomic_set(&tx_queue->inflight_pkts, 0);
+
+	rc = efct_mcdi_tx_init(tx_queue);
+	if (rc) {
+		netif_err(tx_queue->efct, drv, tx_queue->efct->net_dev,
+			  "MCDI init failed for tx queue index = %d\n", tx_queue->txq_index);
+		return rc;
+	}
+	return 0;
+}
+
+//RX queue initialization
+static int efct_rx_probe(struct efct_nic *efct, u16 index, u16 evq_index)
+{
+	struct efct_rx_queue *rxq;
+	int rc;
+
+	if (!efct)
+		return -EINVAL;
+
+	if (test_and_set_bit(index, &efct->rxq_active_mask)) {
+		netif_err(efct, drv, efct->net_dev,
+			  "Rx queue index %d is already in use\n", index);
+		return -EINVAL;
+	}
+
+	rxq = &efct->rxq[index];
+
+	rxq->evq_index = evq_index;
+	rxq->label = index;
+	rxq->cpu = index;
+	rxq->n_rx_eth_crc_err = 0;
+	rxq->n_rx_ip_hdr_chksum_err = 0;
+	rxq->n_rx_tcp_udp_chksum_err = 0;
+	rxq->receive_base = efct->membase + ER_HZ_PORT0_REG_HOST_RX_BUFFER_POST
+			+ (index * efct->efct_dev->params.rx_stride);
+
+	efct->evq[evq_index].type = EVQ_T_RX;
+
+	rc = dbl_init(rxq);
+	if (rc) {
+		clear_bit(index, &efct->rxq_active_mask);
+		return rc;
+	}
+
+	nbl_init(rxq);
+	return 0;
+}
+
+static int efct_rx_init(struct efct_rx_queue *rx_queue)
+{
+	int rc;
+
+	if (!rx_queue)
+		return -EINVAL;
+	rc = efct_mcdi_rx_init(rx_queue);
+	if (rc) {
+		netif_err(rx_queue->efct, ifup, rx_queue->efct->net_dev,
+			  "MCDI init failed for rx queue index = %d\n", rx_queue->index);
+		return rc;
+	}
+	rx_queue->enable = true;
+
+	/* Post buffers in rx queue */
+	rc = efct_fill_rx_buffs(rx_queue);
+	if (rc) {
+		netif_err(rx_queue->efct, ifup, rx_queue->efct->net_dev,
+			  "Failed to fill rx queue index = %d\n", rx_queue->index);
+		rx_queue->enable = false;
+		efct_mcdi_rx_fini(rx_queue);
+	}
+
+	return rc;
+}
+
 static void efct_ev_fini(struct efct_ev_queue *ev_queue)
 {
 	if (!ev_queue || !ev_queue->efct) {
@@ -740,6 +859,22 @@ static int efct_ev_process(struct efct_ev_queue *evq, int quota)
 		ev_type = EFCT_QWORD_FIELD(*p_event, ESF_HZ_EV_TYPE);
 
 		switch (ev_type) {
+		case ESE_HZ_XN_EVENT_TYPE_RX_PKTS: {
+			qlabel = EFCT_QWORD_FIELD(*p_event, ESF_HZ_EV_RXPKTS_LABEL);
+			netif_vdbg(efct, drv, efct->net_dev,
+				   "RX completion event received for queue %d\n", qlabel);
+			efct_ev_rx(&efct->rxq[qlabel], p_event);
+			++spent;
+			break;
+		}
+		case ESE_HZ_XN_EVENT_TYPE_TX_COMPLETION: {
+			qlabel = EFCT_QWORD_FIELD(*p_event, ESF_HZ_EV_TXCMPL_LABEL);
+			netif_vdbg(efct, drv, efct->net_dev,
+				   "TX completion event received for queue %d\n", qlabel);
+			efct_ev_tx(&efct->txq[qlabel], p_event, false);
+			++spent;
+			break;
+		}
 		case ESE_HZ_XN_EVENT_TYPE_CONTROL:
 			spent += efct_ev_control(evq, p_event, quota - spent);
 			break;
@@ -786,6 +921,58 @@ static int efct_ev_process(struct efct_ev_queue *evq, int quota)
 	return spent;
 }
 
+static void efct_rx_fini(struct efct_rx_queue *rx_queue)
+{
+	rx_queue->enable = false;
+
+	efct_mcdi_rx_fini(rx_queue);
+}
+
+static void efct_purge_rxq(struct efct_rx_queue *rxq)
+{
+	nbl_reset(rxq);
+}
+
+static void efct_rx_remove(struct efct_rx_queue *rx_queue)
+{
+	struct efct_nic *efct = rx_queue->efct;
+
+	/* Free driver buffers */
+	dbl_fini(rx_queue);
+
+	if (!test_and_clear_bit(rx_queue->index, &efct->rxq_active_mask)) {
+		netif_err(efct, drv, efct->net_dev,
+			  "Rx queue is already removed, index = %d\n", rx_queue->index);
+	}
+}
+
+static void efct_purge_txq(struct efct_tx_queue *txq)
+{
+	if (txq->core_txq) {
+		_efct_ev_tx(txq, txq->added_sequence - 1, 0, 0, true);
+		txq->pkts = 0;
+		txq->bytes = 0;
+
+		netdev_tx_reset_queue(txq->core_txq);
+	}
+}
+
+static void efct_tx_fini(struct efct_tx_queue *tx_queue)
+{
+	efct_mcdi_tx_fini(tx_queue);
+}
+
+static void efct_tx_remove(struct efct_tx_queue *tx_queue)
+{
+	struct efct_nic *efct = tx_queue->efct;
+
+	efct->evq[tx_queue->evq_index].type = EVQ_T_NONE;
+	if (!test_and_clear_bit(tx_queue->txq_index, &efct->txq_active_mask)) {
+		netif_err(efct, drv, efct->net_dev,
+			  "Tx queue is already removed\n");
+	}
+}
+
 static irqreturn_t efct_msix_handler(int irq, void *dev_id)
 {
 	struct efct_ev_queue *evq = (struct efct_ev_queue *)dev_id;
@@ -1283,6 +1470,16 @@ const struct efct_nic_type efct_nic_type = {
 	.ev_fini = efct_ev_fini,
 	.ev_purge = efct_ev_purge,
 	.ev_process = efct_ev_process,
+	.tx_probe = efct_tx_probe,
+	.tx_init = efct_tx_init,
+	.tx_remove = efct_tx_remove,
+	.tx_fini = efct_tx_fini,
+	.tx_purge = efct_purge_txq,
+	.rx_probe = efct_rx_probe,
+	.rx_init = efct_rx_init,
+	.rx_remove = efct_rx_remove,
+	.rx_fini = efct_rx_fini,
+	.rx_purge = efct_purge_rxq,
 	.irq_handle_msix = efct_msix_handler,
 	.describe_stats = efct_describe_stats,
 	.update_stats = efct_update_stats,
diff --git a/drivers/net/ethernet/amd/efct/efct_rx.c b/drivers/net/ethernet/amd/efct/efct_rx.c
new file mode 100644
index 000000000000..a715344c5a3d
--- /dev/null
+++ b/drivers/net/ethernet/amd/efct/efct_rx.c
@@ -0,0 +1,556 @@
+// SPDX-License-Identifier: GPL-2.0
+/****************************************************************************
+ * Driver for AMD/Xilinx network controllers and boards
+ * Copyright (C) 2021, Xilinx, Inc.
+ * Copyright (C) 2022-2023, Advanced Micro Devices, Inc.
+ */
+
+#include <linux/highmem.h>
+#include <linux/module.h>
+#include <net/busy_poll.h>
+
+#include "efct_rx.h"
+#include "efct_common.h"
+#include "efct_reg.h"
+#include "efct_io.h"
+
+/* Post buffer to NIC */
+static void efct_rx_buff_post(struct efct_rx_queue *rxq, struct efct_buffer *buffer, bool rollover)
+{
+	union efct_qword qword;
+	u64 value;
+
+	rxq->n_rx_buffers_posted++;
+	value = buffer->dma_addr >> 12;
+	EFCT_POPULATE_QWORD_3(qword,
+			      ERF_HZ_PAGE_ADDRESS, value,
+			     ERF_HZ_SENTINEL_VALUE, buffer->sentinel,
+			     ERF_HZ_ROLLOVER, rollover);
+	_efct_writeq(qword.u64[0], rxq->receive_base);
+}
+
+/* Initialize driver buffer list.
+ * Allocate driver DMA buffers.
+ *
+ * Context : Driver
+ *
+ * Return :  0 - Success
+ *          -1 - Failure
+ */
+int dbl_init(struct efct_rx_queue *rxq)
+{
+	struct efct_driver_buffer_list *dbl = &rxq->dbl;
+	struct efct_nic *efct = rxq->efct;
+	int rc, i, j;
+
+	/* Allocate driver DMA buffers */
+	for (i = 0; i < rxq->num_rx_buffs; ++i) {
+		rc = efct_nic_alloc_buffer(efct, &dbl->db[i].dma_buffer,
+					   rxq->buffer_size, GFP_KERNEL);
+		if (rc)
+			goto fail;
+		/* Expect alloc call to memset to zero. So set original
+		 * sentinel to zero.
+		 */
+		dbl->db[i].dma_buffer.sentinel = 0;
+	}
+
+	/* Add all buffers to free list */
+	for (i = 0; i < rxq->num_rx_buffs - 1; ++i)
+		dbl->db[i].next = &dbl->db[i + 1];
+
+	dbl->db[i].next = NULL;
+	dbl->free_list = &dbl->db[0];
+
+	return 0;
+fail:
+	for (j = 0; j < i; ++j)
+		efct_nic_free_buffer(efct, &dbl->db[j].dma_buffer);
+
+	return rc;
+}
+
+/* Free driver DMA buffers
+ *
+ * Context : Driver
+ *
+ * Return : None
+ */
+void dbl_fini(struct efct_rx_queue *rxq)
+{
+	int i;
+
+	for (i = 0; i < rxq->num_rx_buffs; ++i)
+		efct_nic_free_buffer(rxq->efct, &rxq->dbl.db[i].dma_buffer);
+}
+
+/* Allocate buffer from free list */
+static int dbl_alloc_buff(struct efct_rx_queue *rxq, struct efct_buffer *buffer)
+{
+	struct efct_driver_buffer_list *dbl = &rxq->dbl;
+	int id;
+
+	if (dbl->free_list) {
+		memcpy(buffer, &dbl->free_list->dma_buffer, sizeof(*buffer));
+		id = dbl->free_list - &dbl->db[0];
+		dbl->free_list = dbl->free_list->next;
+		return id;
+	}
+
+	return -ENOSPC;
+}
+
+/* Move buffer to free list */
+static void dbl_free_buff(struct efct_rx_queue *rxq, int id)
+{
+	struct efct_driver_buffer_list *dbl = &rxq->dbl;
+
+	/* Flip the original sentinel value */
+	dbl->db[id].dma_buffer.sentinel = !dbl->db[id].dma_buffer.sentinel;
+	dbl->db[id].next = dbl->free_list;
+	dbl->free_list = &dbl->db[id];
+}
+
+/* Initialize NBL
+ *
+ * Context : Driver
+ *
+ * Return : 0 - Success
+ */
+int nbl_init(struct efct_rx_queue *rxq)
+{
+	struct efct_nic_buffer_list *nbl = &rxq->nbl;
+
+	memset(&nbl->nb[0], 0, ARRAY_SIZE(nbl->nb) * sizeof(nbl->nb[0]));
+	nbl->head_index = 0u;
+	nbl->tail_index = 0u;
+	nbl->seq_no = 0u;
+	/* Packet meta starts at next packet location */
+	nbl->meta_offset = rxq->pkt_stride;
+	nbl->prev_meta_offset = 0u;
+	nbl->active_nic_buffs = 0u;
+	nbl->frame_offset_fixed = rxq->efct->efct_dev->params.frame_offset_fixed;
+	return 0;
+}
+
+/* Add buffer to NBL */
+static int nbl_buff_push(struct efct_rx_queue *rxq, struct efct_buffer *buffer,
+			 int id, bool is_dbl, bool rollover)
+{
+	struct efct_nic_buffer_list *nbl = &rxq->nbl;
+
+	WARN_ON_ONCE(id < 0);
+	if (nbl->head_index == ((nbl->tail_index + 1) % NIC_BUFFS_PER_QUEUE)) {
+		netif_err(rxq->efct, drv, rxq->efct->net_dev,
+			  "Rx queue %d nbl full\n", rxq->index);
+		return EFCT_FAILURE;
+	}
+
+	memcpy(&nbl->nb[nbl->tail_index].dma_buffer, buffer, sizeof(*buffer));
+	nbl->nb[nbl->tail_index].id = id;
+	nbl->nb[nbl->tail_index].is_dbl = is_dbl;
+
+	efct_rx_buff_post(rxq, buffer, rollover);
+
+	nbl->tail_index = (nbl->tail_index + 1) % NIC_BUFFS_PER_QUEUE;
+	++nbl->active_nic_buffs;
+	return 0;
+}
+
+/* Remove buffer from NBL */
+static int nbl_buff_pop(struct efct_rx_queue *rxq, bool is_rollover, int *id, bool *is_dbl)
+{
+	struct efct_nic_buffer_list *nbl = &rxq->nbl;
+
+	if (nbl->head_index == nbl->tail_index) {
+		netif_err(rxq->efct, drv, rxq->efct->net_dev,
+			  "Rx queue %d nbl empty\n", rxq->index);
+		return -1;
+	}
+
+	*id = nbl->nb[nbl->head_index].id;
+	*is_dbl = nbl->nb[nbl->head_index].is_dbl;
+
+	if (is_rollover) {
+		nbl->meta_offset = rxq->pkt_stride;
+		nbl->prev_meta_offset = 0u;
+	}
+
+	/* Rollover to next buffer */
+	nbl->head_index = (nbl->head_index + 1) % NIC_BUFFS_PER_QUEUE;
+	++nbl->seq_no;
+	--nbl->active_nic_buffs;
+	return 0;
+}
+
+/* Return current packet meta header and packet start location */
+static int nbl_buff_pkt_peek(struct efct_rx_queue *rxq, u8 **pkt_start)
+{
+	struct efct_nic_buffer_list *nbl = &rxq->nbl;
+	u32 frame_loc;
+
+	/* TODO: Make below check with likely or unlikely
+	 * based on default design param.
+	 */
+	if (nbl->frame_offset_fixed) {
+		frame_loc = nbl->frame_offset_fixed;
+	} else {
+		frame_loc = EFCT_QWORD_FIELD(*((union efct_qword *)*pkt_start),
+					     ESF_HZ_RX_PREFIX_NEXT_FRAME_LOC);
+
+		if (frame_loc == ESE_HZ_XN_NEXT_FRAME_LOC_SEPARATELY) {
+			frame_loc = 64;
+		} else if (frame_loc == ESE_HZ_XN_NEXT_FRAME_LOC_TOGETHER) {
+			frame_loc = 16;
+		} else {
+			netif_err(rxq->efct, drv, rxq->efct->net_dev,
+				  "Rx queue %d Unknown frame location %0X\n",
+				  rxq->index, frame_loc);
+			frame_loc = 16;
+		}
+	}
+
+	*pkt_start = (*pkt_start + frame_loc + 2);
+
+	return 0;
+}
+
+static int nbl_buff_pkt_extract_meta(struct efct_rx_queue *rxq, union efct_qword **p_meta,
+				     u8 **pkt_start, bool *is_sentinel_mismatch)
+{
+	struct efct_nic_buffer_list *nbl = &rxq->nbl;
+	unsigned char head_index;
+
+	if (nbl->meta_offset < nbl->prev_meta_offset) {
+		/* We are in split */
+		if (nbl->head_index == nbl->tail_index) {
+			/* Oh no */
+			netif_err(rxq->efct, drv, rxq->efct->net_dev,
+				  "Rx queue %d nbl empty for packet metadata\n", rxq->index);
+			return EFCT_FAILURE;
+		}
+
+		head_index = (nbl->head_index + 1) % NIC_BUFFS_PER_QUEUE;
+	} else {
+		head_index = nbl->head_index;
+	}
+
+	/* Pick next buffer for metadata */
+	*p_meta = (union efct_qword *)((u8 *)nbl->nb[head_index].dma_buffer.addr +
+	nbl->meta_offset);
+	*pkt_start = (void *)(((u8 *)nbl->nb[nbl->head_index].dma_buffer.addr) +
+	nbl->prev_meta_offset);
+
+	if (nbl->nb[head_index].dma_buffer.sentinel
+			!= EFCT_QWORD_FIELD(*(*p_meta), ESF_HZ_RX_PREFIX_SENTINEL))
+		*is_sentinel_mismatch = true;
+	return 0;
+}
+
+/* Consume packet from nic buffer.
+ * This function returns true when nic buffer needs rollover
+ * else false
+ */
+static bool nbl_buff_pkt_consume(struct efct_rx_queue *rxq)
+{
+	struct efct_nic_buffer_list *nbl = &rxq->nbl;
+
+	nbl->meta_offset += rxq->pkt_stride;
+	if (rxq->buffer_size <= nbl->meta_offset)
+		nbl->meta_offset = 0u;
+
+	nbl->prev_meta_offset += rxq->pkt_stride;
+	if (rxq->buffer_size <= nbl->prev_meta_offset) {
+		nbl->prev_meta_offset = 0u;
+		/* Once prev meta offset moves to next buffer, we
+		 * can rollover to next buffer
+		 */
+		return true;
+	}
+
+	return false;
+}
+
+/* Free the buffer to appropriate pool */
+static void
+rx_free_buffer(struct efct_rx_queue *rxq, int id, bool is_dbl, bool is_internal_ref)
+{
+	WARN_ON_ONCE(id < 0);
+	if (is_dbl)
+		dbl_free_buff(rxq, id);
+}
+
+/* Remove buffer from NBL */
+void nbl_reset(struct efct_rx_queue *rxq)
+{
+	struct efct_nic_buffer_list *nbl = &rxq->nbl;
+	bool is_dbl;
+	int id;
+
+	while (nbl->head_index != nbl->tail_index) {
+		nbl_buff_pop(rxq, true, &id, &is_dbl);
+		rx_free_buffer(rxq, id, is_dbl, true);
+	}
+}
+
+/* Allocate rx buffer and push to nbl */
+static void rx_push_buffer_to_nbl(struct efct_rx_queue *rxq, int id,
+				  struct efct_buffer *buffer, bool is_dbl)
+{
+	int rc;
+
+	rc = nbl_buff_push(rxq, buffer, id, is_dbl, false);
+	if (unlikely(rc)) {
+		rx_free_buffer(rxq, id, is_dbl, false);
+		return;
+	}
+}
+
+static void rx_add_buffer(struct efct_rx_queue *rxq)
+{
+	struct efct_buffer buffer;
+	int id;
+
+	if (!rxq->enable)
+		return;
+	id = dbl_alloc_buff(rxq, &buffer);
+	if (unlikely(id < 0))
+		return;
+	rx_push_buffer_to_nbl(rxq, id, &buffer, true);
+}
+
+/* Fill receive queue with receive buffers */
+int efct_fill_rx_buffs(struct efct_rx_queue *rxq)
+{
+	struct efct_buffer buffer;
+	int id, filled_buffs;
+
+	filled_buffs = 0;
+	for (filled_buffs = 0; filled_buffs < rxq->num_rx_buffs; ++filled_buffs) {
+		id = dbl_alloc_buff(rxq, &buffer);
+		if (id < 0)
+			break;
+		rx_push_buffer_to_nbl(rxq, id, &buffer, true);
+	}
+
+	netif_dbg(rxq->efct, ifup, rxq->efct->net_dev, "Rxq %d filled with %d buffers\n",
+		  rxq->index, filled_buffs);
+
+	if (filled_buffs == 0)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static __wsum get_csum(union efct_qword *p_meta)
+{
+	__u16 hw1;
+
+	hw1 = be16_to_cpu((__force __be16)EFCT_QWORD_FIELD(*p_meta, ESF_HZ_RX_PREFIX_CSUM_FRAME));
+	WARN_ON_ONCE(!hw1);
+
+	return (__force __wsum)hw1;
+}
+
+static bool check_fcs(struct efct_rx_queue *rx_queue, union efct_qword *p_meta)
+{
+	u16 l2_status;
+
+	l2_status = EFCT_QWORD_FIELD(*p_meta, ESF_HZ_RX_PREFIX_L2_STATUS);
+	if (l2_status == ESE_HZ_X3_L2_STATUS_FCS_ERR) {
+		rx_queue->n_rx_eth_crc_err++;
+		return 1;
+	}
+
+	return 0;
+}
+
+/* Deliver packet to stack */
+static void efct_rx_deliver(struct efct_rx_queue *rxq, u8 *pkt_start, union efct_qword *p_meta)
+{
+	struct sk_buff *skb = NULL;
+	struct efct_nic *efct;
+	struct ethhdr *eth;
+	__wsum csum = 0;
+	u16 len;
+
+	efct = rxq->efct;
+
+	len = EFCT_QWORD_FIELD(*p_meta, ESF_HZ_RX_PREFIX_LENGTH);
+	if (unlikely(check_fcs(rxq, p_meta))) {
+		if (!(efct->net_dev->features & NETIF_F_RXALL))
+			goto drop;
+	}
+
+	/* RX checksum offload */
+	if (EFCT_QWORD_FIELD(*p_meta, ESF_HZ_RX_PREFIX_L2_CLASS) ==
+				ESE_HZ_X3_L2_CLASS_ETH_01VLAN) {
+		if (EFCT_QWORD_FIELD(*p_meta, ESF_HZ_RX_PREFIX_L3_CLASS) ==
+				ESE_HZ_X3_L3_CLASS_IP4) {
+			if (EFCT_QWORD_FIELD(*p_meta, ESF_HZ_RX_PREFIX_L3_STATUS) ==
+					ESE_HZ_X3_L3_STATUS_BAD_OR_UNKNOWN) {
+				rxq->n_rx_ip_hdr_chksum_err++;
+			} else {
+				if (likely(efct->net_dev->features & NETIF_F_RXCSUM))
+					csum = get_csum(p_meta);
+				switch (EFCT_QWORD_FIELD(*p_meta, ESF_HZ_RX_PREFIX_L4_CLASS)) {
+				case ESE_HZ_X3_L4_CLASS_TCP:
+				case ESE_HZ_X3_L4_CLASS_UDP:
+					if (EFCT_QWORD_FIELD(*p_meta, ESF_HZ_RX_PREFIX_L4_STATUS) ==
+						ESE_HZ_X3_L4_STATUS_BAD_OR_UNKNOWN)
+						rxq->n_rx_tcp_udp_chksum_err++;
+					break;
+				}
+			}
+		}
+	}
+
+	skb = napi_alloc_skb(&efct->evq[rxq->evq_index].napi, len);
+	if (unlikely(!skb)) {
+		rxq->n_rx_alloc_skb_fail++;
+		goto drop;
+	}
+	/* Copy packet from rx buffer to skb */
+	memcpy(skb_put(skb, len), pkt_start, len);
+	skb_mark_napi_id(skb, &efct->evq[rxq->evq_index].napi);
+	skb->protocol = eth_type_trans(skb, efct->net_dev);
+
+	if (csum) {
+		skb->csum = csum;
+		skb->ip_summed = CHECKSUM_COMPLETE;
+	} else {
+		skb->ip_summed = CHECKSUM_NONE;
+	}
+
+	eth = eth_hdr(skb);
+	do {
+		/* Accept all packets */
+		if (efct->net_dev->flags & IFF_PROMISC)
+			break;
+		if (skb->pkt_type == PACKET_BROADCAST) {
+			/* Accept all broadcast packets */
+			if (efct->net_dev->flags & IFF_BROADCAST)
+				break;
+			rxq->n_rx_broadcast_drop++;
+			goto drop;
+		} else if (skb->pkt_type == PACKET_MULTICAST) {
+			if ((efct->net_dev->flags & IFF_MULTICAST) &&
+			    (netdev_mc_count(efct->net_dev))) {
+				struct netdev_hw_addr *hw_addr;
+				int found_mc_addr = 0;
+
+				netdev_for_each_mc_addr(hw_addr, efct->net_dev) {
+					if (ether_addr_equal(eth->h_dest, hw_addr->addr)) {
+						found_mc_addr = 1;
+						break;
+					}
+				}
+
+				if (!found_mc_addr) {
+					rxq->n_rx_mcast_mismatch++;
+					goto drop;
+				}
+			}
+		} else if (skb->pkt_type == PACKET_HOST) {
+			break;
+		} else if (skb->pkt_type == PACKET_OTHERHOST) {
+			bool found_uc_addr = false;
+
+			if ((efct->net_dev->priv_flags & IFF_UNICAST_FLT) &&
+			    netdev_uc_count(efct->net_dev)) {
+				struct netdev_hw_addr *uc;
+
+				netdev_for_each_uc_addr(uc, efct->net_dev) {
+					if (ether_addr_equal(eth->h_dest, uc->addr)) {
+						found_uc_addr = true;
+						break;
+					}
+				}
+			}
+
+			if (!found_uc_addr) {
+				rxq->n_rx_other_host_drop++;
+				goto drop;
+			}
+		}
+	} while (0);
+
+	napi_gro_receive(&efct->evq[rxq->evq_index].napi, skb);
+	++rxq->rx_packets;
+	return;
+drop:
+	if (skb)
+		dev_kfree_skb_any(skb);
+	atomic64_inc(&efct->n_rx_sw_drops);
+}
+
+/* Process rx event
+ * This function return number of packets processed
+ */
+void efct_ev_rx(struct efct_rx_queue *rxq, const union efct_qword *p_event)
+{
+	bool is_dbl, rollover, pkt_handled = false, is_sentinel_mismatch;
+	u16 i, n_pkts;
+	int rc, id;
+
+	rollover = EFCT_QWORD_FIELD(*p_event, ESF_HZ_EV_RXPKTS_ROLLOVER);
+	if (rollover) {
+		rc = nbl_buff_pop(rxq, true, &id, &is_dbl);
+		if (!rc) {
+			rx_free_buffer(rxq, id, is_dbl, true);
+			rx_add_buffer(rxq);
+		}
+		rxq->n_rx_rollover_events++;
+		return;
+	}
+
+	n_pkts = EFCT_QWORD_FIELD(*p_event, ESF_HZ_EV_RXPKTS_NUM_PACKETS);
+	rxq->efct->evq[rxq->evq_index].irq_mod_score += 2 * n_pkts;
+
+	if (n_pkts > 1) {
+		++rxq->n_rx_merge_events;
+		rxq->n_rx_merge_packets += n_pkts;
+	}
+
+	for (i = 0; i < n_pkts; ++i) {
+		/* Packet belong to stack */
+		union efct_qword *p_meta;
+		u8 *pkt_start;
+
+		is_sentinel_mismatch = false;
+
+		rc = nbl_buff_pkt_extract_meta(rxq, &p_meta, &pkt_start, &is_sentinel_mismatch);
+		if (unlikely(rc)) {
+			rxq->n_rx_nbl_empty++;
+			/* Drop the event */
+			return;
+		}
+		if (pkt_handled) {
+			rxq->n_rx_aux_pkts++;
+		} else if (is_sentinel_mismatch) {
+			pr_err_once("Interface %s, Rx queue %d: Packet dropped due to sentinel mismatch\n",
+				    rxq->efct->net_dev->name, rxq->index);
+			rxq->n_rx_sentinel_drop_count++;
+			atomic64_inc(&rxq->efct->n_rx_sw_drops);
+		} else {
+			rc = nbl_buff_pkt_peek(rxq, &pkt_start);
+			if (unlikely(rc)) {
+				/* Drop the event */
+				return;
+			}
+
+			efct_rx_deliver(rxq, pkt_start, p_meta);
+		}
+
+		if (nbl_buff_pkt_consume(rxq)) {
+			/* Pop out buffer from nbl and free to approp list */
+
+			rc = nbl_buff_pop(rxq, false, &id, &is_dbl);
+			if (unlikely(rc))
+				return;
+
+			rx_free_buffer(rxq, id, is_dbl, true);
+			rx_add_buffer(rxq);
+		}
+	}
+}
diff --git a/drivers/net/ethernet/amd/efct/efct_rx.h b/drivers/net/ethernet/amd/efct/efct_rx.h
new file mode 100644
index 000000000000..ffa84a588217
--- /dev/null
+++ b/drivers/net/ethernet/amd/efct/efct_rx.h
@@ -0,0 +1,22 @@
+/* SPDX-License-Identifier: GPL-2.0
+ ****************************************************************************
+ * Driver for AMD/Xilinx network controllers and boards
+ * Copyright (C) 2021, Xilinx, Inc.
+ * Copyright (C) 2022-2023, Advanced Micro Devices, Inc.
+ */
+
+#ifndef EFCT_EFCT_RX_H
+#define EFCT_EFCT_RX_H
+
+#include "efct_driver.h"
+/*Count to wait for in case of sentinel mismatch*/
+#define SENTINEL_MISMATCH_COUNT 2000
+
+int dbl_init(struct efct_rx_queue *rxq);
+void dbl_fini(struct efct_rx_queue *rxq);
+int nbl_init(struct efct_rx_queue *rxq);
+void nbl_reset(struct efct_rx_queue *rxq);
+int efct_fill_rx_buffs(struct efct_rx_queue *rxq);
+void efct_ev_rx(struct efct_rx_queue *rxq, const union efct_qword *p_event);
+
+#endif
diff --git a/drivers/net/ethernet/amd/efct/efct_tx.c b/drivers/net/ethernet/amd/efct/efct_tx.c
new file mode 100644
index 000000000000..29b09726d122
--- /dev/null
+++ b/drivers/net/ethernet/amd/efct/efct_tx.c
@@ -0,0 +1,313 @@
+// SPDX-License-Identifier: GPL-2.0
+/****************************************************************************
+ * Driver for AMD/Xilinx network controllers and boards
+ * Copyright (C) 2021, Xilinx, Inc.
+ * Copyright (C) 2022-2023, Advanced Micro Devices, Inc.
+ */
+
+#include <linux/highmem.h>
+#include "efct_tx.h"
+#include "efct_reg.h"
+#include "efct_io.h"
+
+/* Transmit header size in bytes */
+#define EFCT_TX_HEADER_BYTES (ESE_HZ_XN_CTPIO_HDR_STRUCT_SIZE / 8)
+
+/* Tx packet alignment */
+#define EFCT_TX_PACKET_ALIGN 64
+
+#define EFCT_PKT_DATA_WRITE_ALIGN 8
+
+/* Minimum frame alignment */
+#define EFCT_MIN_FRAME_ALIGN 32
+
+static size_t txq_available(struct efct_tx_queue *txq)
+{
+	/* Make sure least EFCT_TX_PACKET_ALIGN are left extra so FIFO is not overflown */
+	return (txq->fifo_size - EFCT_TX_PACKET_ALIGN) - atomic_read(&txq->inuse_fifo_bytes);
+}
+
+static void txq_may_restart(struct efct_tx_queue *txq)
+{
+	if ((txq_available(txq) >
+	     ALIGN((txq->efct->mtu + ETH_HLEN + VLAN_HLEN + EFCT_TX_HEADER_BYTES),
+		   EFCT_TX_PACKET_ALIGN)) &&
+	    atomic_read(&txq->inflight_pkts) < (MAX_TX_BUFFERS - 1))
+		netif_tx_wake_queue(txq->core_txq);
+}
+
+static void txq_may_stop(struct efct_tx_queue *txq)
+{
+	if ((likely(txq_available(txq) >
+		ALIGN((txq->efct->mtu + ETH_HLEN + VLAN_HLEN + EFCT_TX_HEADER_BYTES),
+		      EFCT_TX_PACKET_ALIGN))) &&
+		(atomic_read(&txq->inflight_pkts) < (MAX_TX_BUFFERS - 1)))
+		return;
+
+	netif_tx_stop_queue(txq->core_txq);
+	txq->n_tx_stop_queue++;
+}
+
+static bool txq_can_transmit(struct efct_tx_queue *txq, size_t len)
+{
+	return (txq_available(txq) > ALIGN((len + EFCT_TX_HEADER_BYTES), EFCT_TX_PACKET_ALIGN));
+}
+
+struct efct_short_copy_buffer {
+	int used;
+	u8 buf[64];
+};
+
+static uint64_t efct_tx_header(u16 pkt_len, u8 ct_thresh,
+			       u8 ts_flag, u8 warm_flag, u8 action)
+{
+	union efct_qword hdr;
+
+	EFCT_POPULATE_QWORD_5(hdr,
+			      ESF_HZ_CTPIO_HDR_PACKET_LENGTH, pkt_len,
+			     ESF_HZ_CTPIO_HDR_CT_THRESH, ct_thresh,
+			     ESF_HZ_CTPIO_HDR_TIMESTAMP_FLAG, ts_flag,
+			     ESF_HZ_CTPIO_HDR_WARM_FLAG, warm_flag,
+			     ESF_HZ_CTPIO_HDR_ACTION, action);
+
+	return le64_to_cpu(hdr.u64[0]);
+}
+
+static uint64_t efct_tx_pkt_header(u16 pkt_len, u8 ct_thresh, bool ts_flag)
+{
+	return efct_tx_header(pkt_len, ct_thresh, ts_flag, 0, 0);
+}
+
+/* Copy in explicit 64-bit writes. */
+static void txq_piobuf_w64(struct efct_tx_queue *txq, u64 val)
+{
+	u64 __iomem *dest64 = txq->piobuf + txq->piobuf_offset;
+
+	writeq(val, dest64);
+	++txq->piobuf_offset;
+
+	if (unlikely(txq->piobuf_offset == txq->aperture_qword))
+		txq->piobuf_offset = 0;
+}
+
+#define ER_HZ_PORT0_REG_HOST_NOOP_WRITE  0x12004
+static void txq_noop_write(struct efct_ev_queue *eventq)
+{
+	_efct_writeq(cpu_to_le64(1), (eventq->efct->membase + ER_HZ_PORT0_REG_HOST_NOOP_WRITE +
+			(eventq->index * eventq->efct->efct_dev->params.evq_stride)));
+}
+
+static void txq_piobuf_pad64(struct efct_tx_queue *txq, int skb_len)
+{
+	size_t len;
+	size_t l64;
+	size_t i;
+
+	len = EFCT_TX_PACKET_ALIGN - ((ALIGN(skb_len + EFCT_TX_HEADER_BYTES,
+				       EFCT_PKT_DATA_WRITE_ALIGN)) % EFCT_TX_PACKET_ALIGN);
+	l64 = (len % EFCT_TX_PACKET_ALIGN) / 8;
+	for (i = 0; i < l64; i++)
+		txq_piobuf_w64(txq, 0L);
+#ifdef __x86_64__
+	__asm__ __volatile__ ("sfence");
+#endif
+	txq_noop_write(&txq->efct->evq[txq->evq_index]);
+}
+
+static void txq_piobuf_wblock(struct efct_tx_queue *txq, void *src, size_t len)
+{
+	size_t l64 = len / EFCT_PKT_DATA_WRITE_ALIGN;
+	u64 *src64 = src;
+	size_t i;
+
+	WARN_ON_ONCE((len % EFCT_PKT_DATA_WRITE_ALIGN) != 0);
+
+	for (i = 0; i < l64; i++)
+		txq_piobuf_w64(txq, src64[i]);
+}
+
+/*Copy data from src to piobuffer and remaining unaligned bytes to copy_buf*/
+
+static void txq_copyto_piobuf(struct efct_tx_queue *txq, void *src, size_t len,
+			      struct efct_short_copy_buffer *copy_buf)
+{
+	size_t block_len = len & ~(sizeof(copy_buf->buf) - 1);
+
+	txq_piobuf_wblock(txq, src, block_len);
+	len -= block_len;
+
+	if (len) {
+		src = (u8 *)src + block_len;
+		memcpy(copy_buf->buf, src, len);
+		copy_buf->used = len;
+	}
+}
+
+/*Copy data from copy_buf then src to piobuf and remaining unaligned bytes to copy_buf*/
+static void txq_copyto_piobuf_cb(struct efct_tx_queue *txq, void *src, size_t len,
+				 struct efct_short_copy_buffer *copy_buf)
+{
+	if (copy_buf->used) {
+		/* If copy buffer is partially filled, fill it up and write */
+		int fill_bytes =
+			min_t(int, sizeof(copy_buf->buf) - copy_buf->used, len);
+
+		memcpy(copy_buf->buf + copy_buf->used, src, fill_bytes);
+		copy_buf->used += fill_bytes;
+
+		if (copy_buf->used < sizeof(copy_buf->buf))
+			return;
+
+		txq_piobuf_wblock(txq, copy_buf->buf, sizeof(copy_buf->buf));
+		src = (u8 *)src + fill_bytes;
+		len -= fill_bytes;
+		copy_buf->used = 0;
+	}
+
+	txq_copyto_piobuf(txq, src, len, copy_buf);
+}
+
+static void txq_copy_skb_frags(struct efct_tx_queue *txq, struct sk_buff *skb)
+{
+	struct efct_short_copy_buffer copy_buf;
+	int i;
+
+	copy_buf.used = 0;
+
+	/* Copy skb header */
+	txq_copyto_piobuf(txq, skb->data, skb_headlen(skb), &copy_buf);
+
+	/* Copy fragments */
+	for (i = 0; i < skb_shinfo(skb)->nr_frags; ++i) {
+		skb_frag_t *f = &skb_shinfo(skb)->frags[i];
+		struct page *p;
+		u32 p_off;
+		u8 *vaddr;
+		/* We need to adjust page and offset in case offset points to somewhere
+		 * in-between page + n. Case of skb->len > PAGE_SIZE is not handled
+		 * since MTU < PAGE_SIZE
+		 */
+		p = skb_frag_page(f) + (skb_frag_off(f) >> PAGE_SHIFT);
+		p_off = (skb_frag_off(f)) & (PAGE_SIZE - 1);
+		vaddr = kmap_local_page(p);
+		txq_copyto_piobuf_cb(txq, vaddr + p_off, skb_frag_size(f), &copy_buf);
+		kunmap_local(vaddr);
+	}
+
+	if (copy_buf.used)
+		txq_piobuf_wblock(txq, copy_buf.buf, ALIGN(copy_buf.used, 8));
+}
+
+int efct_enqueue_skb(struct efct_tx_queue *txq, struct sk_buff *skb, struct net_device *net_dev)
+{
+	bool ts = false;
+	u64 pkt_header;
+	int skb_len;
+
+	skb_len = skb->len;
+	if (!txq_can_transmit(txq, skb_len)) {
+		netif_err(txq->efct, drv, txq->efct->net_dev,
+			  "Exceeding txq FIFO. skb len : %u In use FIFO Bytes : %u\n",
+				skb_len, atomic_read(&txq->inuse_fifo_bytes));
+		netif_tx_stop_queue(txq->core_txq);
+		dev_kfree_skb_any(skb);
+		return -EBUSY;
+	}
+
+	netdev_tx_sent_queue(txq->core_txq, skb_len);
+	txq->tx_buffer[txq->added_sequence].skb = skb;
+	++txq->added_sequence;
+
+	atomic_add(ALIGN((skb_len + EFCT_TX_HEADER_BYTES), EFCT_TX_PACKET_ALIGN),
+		   &txq->inuse_fifo_bytes);
+	atomic_inc(&txq->inflight_pkts);
+
+	txq_may_stop(txq);
+
+	pkt_header = efct_tx_pkt_header(skb_len < EFCT_MIN_FRAME_ALIGN ?
+			EFCT_MIN_FRAME_ALIGN : skb_len, txq->ct_thresh, ts);
+
+	skb_tx_timestamp(skb);
+
+	/* Write Header */
+	txq_piobuf_w64(txq, pkt_header);
+	/* Write packet data */
+	if (skb_shinfo(skb)->nr_frags) {
+		txq_copy_skb_frags(txq, skb);
+		txq_piobuf_pad64(txq, skb_len);
+	} else {
+		/* Pad the write to 8 bytes align.
+		 * We can do this because we know the skb_shared_info struct is
+		 * after the source, and the destination buffer is big enough.
+		 */
+		BUILD_BUG_ON(EFCT_PKT_DATA_WRITE_ALIGN >
+			     SKB_DATA_ALIGN(sizeof(struct skb_shared_info)));
+		txq_piobuf_wblock(txq, skb->data, ALIGN(skb_len, EFCT_PKT_DATA_WRITE_ALIGN));
+		txq_piobuf_pad64(txq, skb_len);
+	}
+
+	return 0;
+}
+
+void _efct_ev_tx(struct efct_tx_queue *txq, u8 seq, bool __always_unused ts_status, u64 partial_ts,
+		 bool purge)
+{
+	u32 pkts = 0, bytes = 0;
+	u8 process_pkt, cur_seq;
+	struct sk_buff *skb;
+
+	cur_seq = txq->completed_sequence;
+
+	if (cur_seq > seq)
+		process_pkt = MAX_TX_BUFFERS - cur_seq + seq;
+	else
+		process_pkt = seq - cur_seq;
+	while (process_pkt) {
+		//Being u8 type cur_seq will wrap itself on reaching MAX_TX_BUFFERS
+		cur_seq += 1;
+		skb = txq->tx_buffer[cur_seq].skb;
+		if (unlikely(!skb))  {
+			--process_pkt;
+			netif_err(txq->efct, drv, txq->efct->net_dev, "Error: skb should not be null\n");
+			continue;
+		}
+		pkts++;
+		bytes += skb->len;
+
+		atomic_sub(ALIGN((skb->len + EFCT_TX_HEADER_BYTES), EFCT_TX_PACKET_ALIGN),
+			   &txq->inuse_fifo_bytes);
+		atomic_dec(&txq->inflight_pkts);
+		if (unlikely(purge))
+			dev_kfree_skb_any(skb);
+		else
+			dev_consume_skb_any(skb);
+		txq->tx_buffer[cur_seq].skb = NULL;
+		--process_pkt;
+	}
+
+	/*stat for ethtool reporting*/
+	txq->tx_packets += pkts;
+	/*Used for BQL*/
+	txq->pkts += pkts;
+	txq->bytes += bytes;
+
+	txq->completed_sequence = seq;
+	if (unlikely(netif_tx_queue_stopped(txq->core_txq))) {
+		txq_may_restart(txq);
+		//TODO update relevant stats
+	}
+}
+
+void efct_ev_tx(struct efct_tx_queue *txq, union efct_qword *p_event, bool purge)
+{
+	bool ts_status;
+	u64 partial_ts;
+	u8 seq;
+
+	seq = EFCT_QWORD_FIELD(*p_event, ESF_HZ_EV_TXCMPL_SEQUENCE);
+	ts_status = EFCT_QWORD_FIELD(*p_event, ESF_HZ_EV_TXCMPL_TIMESTAMP_STATUS);
+	partial_ts = EFCT_QWORD_FIELD(*p_event, ESF_HZ_EV_TXCMPL_PARTIAL_TSTAMP);
+
+	_efct_ev_tx(txq, seq, ts_status, partial_ts, purge);
+}
+
diff --git a/drivers/net/ethernet/amd/efct/efct_tx.h b/drivers/net/ethernet/amd/efct/efct_tx.h
new file mode 100644
index 000000000000..9d6bcc67264a
--- /dev/null
+++ b/drivers/net/ethernet/amd/efct/efct_tx.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0
+ ****************************************************************************
+ * Driver for AMD/Xilinx network controllers and boards
+ * Copyright (C) 2021, Xilinx, Inc.
+ * Copyright (C) 2022-2023, Advanced Micro Devices, Inc.
+ */
+
+#ifndef EFCT_EFCT_TX_H
+#define EFCT_EFCT_TX_H
+
+#include "efct_driver.h"
+
+int efct_enqueue_skb(struct efct_tx_queue *tx_queue, struct sk_buff *skb,
+		     struct net_device *net_dev);
+void efct_ev_tx(struct efct_tx_queue *txq, union efct_qword *p_event, bool purge);
+void _efct_ev_tx(struct efct_tx_queue *txq, u8 seq, bool ts_status, u64 partial_ts, bool purge);
+#endif
-- 
2.25.1

