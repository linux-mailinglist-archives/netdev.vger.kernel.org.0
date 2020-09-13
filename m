Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12C41267E8A
	for <lists+netdev@lfdr.de>; Sun, 13 Sep 2020 10:18:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725943AbgIMISK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Sep 2020 04:18:10 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:27191 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725899AbgIMIRz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Sep 2020 04:17:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1599985076; x=1631521076;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=1yqNKvjOVLhEMKvuVci6WcCjnXCKRtndE3WuW/zYJ5I=;
  b=gGURSrZh6yXpIrTWAPVS/RBxY+tVXznmvHrMqscw++obpJ0lzQZWMrHn
   +na0RpaJuLmI9T/S1bjIDCiJzVaA8mQ7nFmvHVzyCDtwsnpV/xIkTHRUE
   1RcE1d5S96VixqC23/5vsvGKiqcLZ2R1HlFvvGOGZwsI7DIg7tYyZJZQV
   s=;
X-IronPort-AV: E=Sophos;i="5.76,421,1592870400"; 
   d="scan'208";a="53643297"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-579b7f5b.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 13 Sep 2020 08:17:55 +0000
Received: from EX13D28EUC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2c-579b7f5b.us-west-2.amazon.com (Postfix) with ESMTPS id 80CC5A195D;
        Sun, 13 Sep 2020 08:17:52 +0000 (UTC)
Received: from u68c7b5b1d2d758.ant.amazon.com (10.43.161.145) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 13 Sep 2020 08:17:43 +0000
From:   Shay Agroskin <shayagr@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Shay Agroskin <shayagr@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <sameehj@amazon.com>,
        <ndagan@amazon.com>, Amit Bernstein <amitbern@amazon.com>
Subject: [PATCH V1 net-next 3/8] net: ena: Change log message to netif/dev function
Date:   Sun, 13 Sep 2020 11:16:35 +0300
Message-ID: <20200913081640.19560-4-shayagr@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200913081640.19560-1-shayagr@amazon.com>
References: <20200913081640.19560-1-shayagr@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.161.145]
X-ClientProxiedBy: EX13D23UWC001.ant.amazon.com (10.43.162.196) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Following the previous patch, make all log prints in ena_netdev use the
same log functions as the rest of the driver.

For the sake of consistency, all prints in ena_netdev file were
converted into netif_* format except where netdev struct isn't yet
defined. For these places, dev_* log functions are used (similar to
the patch for ena_com files).

This commit leaves some corner cases which would be changes in a
future patch.

Signed-off-by: Amit Bernstein <amitbern@amazon.com>
Signed-off-by: Shay Agroskin <shayagr@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 42 +++++++++++---------
 1 file changed, 23 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index dbf0cbffd2fc..d0121aaafa38 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -265,7 +265,7 @@ static int ena_xdp_tx_map_buff(struct ena_ring *xdp_ring,
 	u64_stats_update_begin(&xdp_ring->syncp);
 	xdp_ring->tx_stats.dma_mapping_err++;
 	u64_stats_update_end(&xdp_ring->syncp);
-	netdev_warn(adapter->netdev, "failed to map xdp buff\n");
+	netif_warn(adapter, tx_queued, adapter->netdev, "failed to map xdp buff\n");
 
 	xdp_return_frame_rx_napi(tx_info->xdpf);
 	tx_info->xdpf = NULL;
@@ -1027,9 +1027,9 @@ static int ena_refill_rx_bufs(struct ena_ring *rx_ring, u32 num)
 		u64_stats_update_begin(&rx_ring->syncp);
 		rx_ring->rx_stats.refil_partial++;
 		u64_stats_update_end(&rx_ring->syncp);
-		netdev_warn(rx_ring->netdev,
-			    "refilled rx qid %d with only %d buffers (from %d)\n",
-			    rx_ring->qid, i, num);
+		netif_warn(rx_ring->adapter, rx_err, rx_ring->netdev,
+			   "refilled rx qid %d with only %d buffers (from %d)\n",
+			   rx_ring->qid, i, num);
 	}
 
 	/* ena_com_write_sq_doorbell issues a wmb() */
@@ -1128,14 +1128,14 @@ static void ena_free_tx_bufs(struct ena_ring *tx_ring)
 			continue;
 
 		if (print_once) {
-			netdev_notice(tx_ring->netdev,
-				      "free uncompleted tx skb qid %d idx 0x%x\n",
-				      tx_ring->qid, i);
+			netif_notice(tx_ring->adapter, ifdown, tx_ring->netdev,
+				     "free uncompleted tx skb qid %d idx 0x%x\n",
+				     tx_ring->qid, i);
 			print_once = false;
 		} else {
-			netdev_dbg(tx_ring->netdev,
-				   "free uncompleted tx skb qid %d idx 0x%x\n",
-				   tx_ring->qid, i);
+			netif_dbg(tx_ring->adapter, ifdown, tx_ring->netdev,
+				  "free uncompleted tx skb qid %d idx 0x%x\n",
+				  tx_ring->qid, i);
 		}
 
 		ena_unmap_tx_buff(tx_ring, tx_info);
@@ -2536,7 +2536,7 @@ static int ena_up(struct ena_adapter *adapter)
 {
 	int io_queue_count, rc, i;
 
-	netdev_dbg(adapter->netdev, "%s\n", __func__);
+	netif_dbg(adapter, ifup, adapter->netdev, "%s\n", __func__);
 
 	io_queue_count = adapter->num_io_queues + adapter->xdp_num_queues;
 	ena_setup_io_intr(adapter);
@@ -2620,7 +2620,8 @@ static void ena_down(struct ena_adapter *adapter)
 
 		rc = ena_com_dev_reset(adapter->ena_dev, adapter->reset_reason);
 		if (rc)
-			dev_err(&adapter->pdev->dev, "Device reset failed\n");
+			netif_err(adapter, ifdown, adapter->netdev,
+				  "Device reset failed\n");
 		/* stop submitting admin commands on a device that was reset */
 		ena_com_set_admin_running_state(adapter->ena_dev, false);
 	}
@@ -2942,7 +2943,7 @@ static int ena_tx_map_skb(struct ena_ring *tx_ring,
 	u64_stats_update_begin(&tx_ring->syncp);
 	tx_ring->tx_stats.dma_mapping_err++;
 	u64_stats_update_end(&tx_ring->syncp);
-	netdev_warn(adapter->netdev, "failed to map skb\n");
+	netif_warn(adapter, tx_queued, adapter->netdev, "failed to map skb\n");
 
 	tx_info->skb = NULL;
 
@@ -3080,13 +3081,14 @@ static u16 ena_select_queue(struct net_device *dev, struct sk_buff *skb,
 
 static void ena_config_host_info(struct ena_com_dev *ena_dev, struct pci_dev *pdev)
 {
+	struct device *dev = &pdev->dev;
 	struct ena_admin_host_info *host_info;
 	int rc;
 
 	/* Allocate only the host info */
 	rc = ena_com_allocate_host_info(ena_dev);
 	if (rc) {
-		pr_err("Cannot allocate host info\n");
+		dev_err(dev, "Cannot allocate host info\n");
 		return;
 	}
 
@@ -3116,9 +3118,9 @@ static void ena_config_host_info(struct ena_com_dev *ena_dev, struct pci_dev *pd
 	rc = ena_com_set_host_attributes(ena_dev);
 	if (rc) {
 		if (rc == -EOPNOTSUPP)
-			pr_warn("Cannot set host attributes\n");
+			dev_warn(dev, "Cannot set host attributes\n");
 		else
-			pr_err("Cannot set host attributes\n");
+			dev_err(dev, "Cannot set host attributes\n");
 
 		goto err;
 	}
@@ -3146,7 +3148,8 @@ static void ena_config_debug_area(struct ena_adapter *adapter)
 
 	rc = ena_com_allocate_debug_area(adapter->ena_dev, debug_area_size);
 	if (rc) {
-		pr_err("Cannot allocate debug area\n");
+		netif_err(adapter, drv, adapter->netdev,
+			  "Cannot allocate debug area\n");
 		return;
 	}
 
@@ -3573,9 +3576,10 @@ static int ena_restore_device(struct ena_adapter *adapter)
 		netif_carrier_on(adapter->netdev);
 
 	mod_timer(&adapter->timer_service, round_jiffies(jiffies + HZ));
-	dev_err(&pdev->dev, "Device reset completed successfully\n");
 	adapter->last_keep_alive_jiffies = jiffies;
 
+	dev_err(&pdev->dev, "Device reset completed successfully\n");
+
 	return rc;
 err_disable_msix:
 	ena_free_mgmnt_irq(adapter);
@@ -4537,7 +4541,7 @@ static void ena_update_on_link_change(void *adapter_data,
 		ENA_ADMIN_AENQ_LINK_CHANGE_DESC_LINK_STATUS_MASK;
 
 	if (status) {
-		netdev_dbg(adapter->netdev, "%s\n", __func__);
+		netif_dbg(adapter, ifup, adapter->netdev, "%s\n", __func__);
 		set_bit(ENA_FLAG_LINK_UP, &adapter->flags);
 		if (!test_bit(ENA_FLAG_ONGOING_RESET, &adapter->flags))
 			netif_carrier_on(adapter->netdev);
-- 
2.17.1

