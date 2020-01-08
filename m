Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B15E213474C
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 17:11:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729036AbgAHQLk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 11:11:40 -0500
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:39950 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727618AbgAHQLk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 11:11:40 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us2.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id D461B700098;
        Wed,  8 Jan 2020 16:11:37 +0000 (UTC)
Received: from amm-opti7060.uk.solarflarecom.com (10.17.20.147) by
 ukex01.SolarFlarecom.com (10.17.10.4) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Wed, 8 Jan 2020 16:11:32 +0000
From:   "Alex Maftei (amaftei)" <amaftei@solarflare.com>
Subject: [PATCH net-next 05/14] sfc: move datapath management code
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>
CC:     <linux-net-drivers@solarflare.com>, <scrum-linux@solarflare.com>
References: <a0cfb828-b98e-3a63-15d9-592675e81b5f@solarflare.com>
Message-ID: <597fd5b1-10f7-b746-3958-c86f21cdbde9@solarflare.com>
Date:   Wed, 8 Jan 2020 16:11:29 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <a0cfb828-b98e-3a63-15d9-592675e81b5f@solarflare.com>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.147]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-25154.003
X-TM-AS-Result: No-9.813900-8.000000-10
X-TMASE-MatchedRID: Dfm6MwZEehZsMVyAAdvrLbBZAi3nrnzbfhrkUjP10lNW/Z+zkKZQo3h0
        psEsz2/KSgJB0j15cgZTvVffeIwvQwUcfW/oedmqPwKTD1v8YV5MkOX0UoduuRpX1zEL4nq3dBL
        3GfDwgFc5DMhaYtGyT74agoH9nQ8LYTyt9zWQpTMwYApm54/SZmcCy3wC35zd0SxMhOhuA0Tygx
        +IRquskBZpZqDuNEN2eiBv/L4i0xAoGsCID/XH5ZK9FvwQx1hFUHV7v8X++rmo8aocg8ZmI4opg
        HeEYgzITbj7ZuBkpoiRvev4WycxTfWGuKlZ9MVSfc7cX82yHHlITFAcgVBxK0sdqJmf7mJ0ee+p
        suSMY7r5FGNheH+Pun+3pSKK4h3y9Lx+1Xe7ffeKR0fcRBoRNd9GcpCvqzHahMZOnOKs8fLccF+
        vY4fYYTcXL74M2tRpMsTFI4iGNTmHWAZx0LGJkV7Sq0XKoGHrQt4kQKXEUArHN9tnHHgXhFk0uh
        bVrhisb2/BU61FVSMNxcYy/bAom6acba0/6+pRq0reih3E9rF+CWCcHScOE+D0a1g8E91LY0kwZ
        RxIQCaCXoRNGj51F6BO6HZx9xBZ9juqgbPpsfGPQVakDkJU+dxWLypmYlZzyzyspHLq+J9koPm7
        JRrAs20UE1UndaNY8XG3zT5yERnvl7ZvLqtgspzEHTUOuMX3ZAGtCJE23YhXy6SPHzrw7tShvIc
        hwjOuW7bq9gwZaCC/UvVB4i+TYghPSs3fzpSMO8xKBrjenTTnEl/YQBxicK0ke9m+oOm0R0hOfM
        hcLSthcaGxbMucnwZksWsMqIQUSs5dDi8K1lirm7DrUlmNkJGTpe1iiCJqb5ic6rRyh48LbigRn
        pKlKTpcQTtiHDgWovh7GMKhDRSJB3X3VzMiuJenp1c+s80TNUB0OvkzpPUmaVoIh9BM9g==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--9.813900-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25154.003
X-MDID: 1578499898-WED-mOV4V9_2
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The code that manages the datapath (starting, stopping, including the
port-related bits) will be common.
Three functions have been added that contain bits from other
functions. These will be moved to their final files in later patches.
Small code styling fixes included.

Signed-off-by: Alexandru-Mihai Maftei <amaftei@solarflare.com>
---
 drivers/net/ethernet/sfc/efx.c        | 310 +-----------------------
 drivers/net/ethernet/sfc/efx_common.c | 328 ++++++++++++++++++++++++++
 2 files changed, 335 insertions(+), 303 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 752470baf4be..988687a80abe 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -618,152 +618,6 @@ int efx_probe_channels(struct efx_nic *efx)
 	return rc;
 }
 
-/* Channels are shutdown and reinitialised whilst the NIC is running
- * to propagate configuration changes (mtu, checksum offload), or
- * to clear hardware error conditions
- */
-static void efx_start_datapath(struct efx_nic *efx)
-{
-	netdev_features_t old_features = efx->net_dev->features;
-	bool old_rx_scatter = efx->rx_scatter;
-	struct efx_tx_queue *tx_queue;
-	struct efx_rx_queue *rx_queue;
-	struct efx_channel *channel;
-	size_t rx_buf_len;
-
-	/* Calculate the rx buffer allocation parameters required to
-	 * support the current MTU, including padding for header
-	 * alignment and overruns.
-	 */
-	efx->rx_dma_len = (efx->rx_prefix_size +
-			   EFX_MAX_FRAME_LEN(efx->net_dev->mtu) +
-			   efx->type->rx_buffer_padding);
-	rx_buf_len = (sizeof(struct efx_rx_page_state) + XDP_PACKET_HEADROOM +
-		      efx->rx_ip_align + efx->rx_dma_len);
-	if (rx_buf_len <= PAGE_SIZE) {
-		efx->rx_scatter = efx->type->always_rx_scatter;
-		efx->rx_buffer_order = 0;
-	} else if (efx->type->can_rx_scatter) {
-		BUILD_BUG_ON(EFX_RX_USR_BUF_SIZE % L1_CACHE_BYTES);
-		BUILD_BUG_ON(sizeof(struct efx_rx_page_state) +
-			     2 * ALIGN(NET_IP_ALIGN + EFX_RX_USR_BUF_SIZE,
-				       EFX_RX_BUF_ALIGNMENT) >
-			     PAGE_SIZE);
-		efx->rx_scatter = true;
-		efx->rx_dma_len = EFX_RX_USR_BUF_SIZE;
-		efx->rx_buffer_order = 0;
-	} else {
-		efx->rx_scatter = false;
-		efx->rx_buffer_order = get_order(rx_buf_len);
-	}
-
-	efx_rx_config_page_split(efx);
-	if (efx->rx_buffer_order)
-		netif_dbg(efx, drv, efx->net_dev,
-			  "RX buf len=%u; page order=%u batch=%u\n",
-			  efx->rx_dma_len, efx->rx_buffer_order,
-			  efx->rx_pages_per_batch);
-	else
-		netif_dbg(efx, drv, efx->net_dev,
-			  "RX buf len=%u step=%u bpp=%u; page batch=%u\n",
-			  efx->rx_dma_len, efx->rx_page_buf_step,
-			  efx->rx_bufs_per_page, efx->rx_pages_per_batch);
-
-	/* Restore previously fixed features in hw_features and remove
-	 * features which are fixed now
-	 */
-	efx->net_dev->hw_features |= efx->net_dev->features;
-	efx->net_dev->hw_features &= ~efx->fixed_features;
-	efx->net_dev->features |= efx->fixed_features;
-	if (efx->net_dev->features != old_features)
-		netdev_features_change(efx->net_dev);
-
-	/* RX filters may also have scatter-enabled flags */
-	if (efx->rx_scatter != old_rx_scatter)
-		efx->type->filter_update_rx_scatter(efx);
-
-	/* We must keep at least one descriptor in a TX ring empty.
-	 * We could avoid this when the queue size does not exactly
-	 * match the hardware ring size, but it's not that important.
-	 * Therefore we stop the queue when one more skb might fill
-	 * the ring completely.  We wake it when half way back to
-	 * empty.
-	 */
-	efx->txq_stop_thresh = efx->txq_entries - efx_tx_max_skb_descs(efx);
-	efx->txq_wake_thresh = efx->txq_stop_thresh / 2;
-
-	/* Initialise the channels */
-	efx_for_each_channel(channel, efx) {
-		efx_for_each_channel_tx_queue(tx_queue, channel) {
-			efx_init_tx_queue(tx_queue);
-			atomic_inc(&efx->active_queues);
-		}
-
-		efx_for_each_channel_rx_queue(rx_queue, channel) {
-			efx_init_rx_queue(rx_queue);
-			atomic_inc(&efx->active_queues);
-			efx_stop_eventq(channel);
-			efx_fast_push_rx_descriptors(rx_queue, false);
-			efx_start_eventq(channel);
-		}
-
-		WARN_ON(channel->rx_pkt_n_frags);
-	}
-
-	efx_ptp_start_datapath(efx);
-
-	if (netif_device_present(efx->net_dev))
-		netif_tx_wake_all_queues(efx->net_dev);
-}
-
-static void efx_stop_datapath(struct efx_nic *efx)
-{
-	struct efx_channel *channel;
-	struct efx_tx_queue *tx_queue;
-	struct efx_rx_queue *rx_queue;
-	int rc;
-
-	EFX_ASSERT_RESET_SERIALISED(efx);
-	BUG_ON(efx->port_enabled);
-
-	efx_ptp_stop_datapath(efx);
-
-	/* Stop RX refill */
-	efx_for_each_channel(channel, efx) {
-		efx_for_each_channel_rx_queue(rx_queue, channel)
-			rx_queue->refill_enabled = false;
-	}
-
-	efx_for_each_channel(channel, efx) {
-		/* RX packet processing is pipelined, so wait for the
-		 * NAPI handler to complete.  At least event queue 0
-		 * might be kept active by non-data events, so don't
-		 * use napi_synchronize() but actually disable NAPI
-		 * temporarily.
-		 */
-		if (efx_channel_has_rx_queue(channel)) {
-			efx_stop_eventq(channel);
-			efx_start_eventq(channel);
-		}
-	}
-
-	rc = efx->type->fini_dmaq(efx);
-	if (rc) {
-		netif_err(efx, drv, efx->net_dev, "failed to flush queues\n");
-	} else {
-		netif_dbg(efx, drv, efx->net_dev,
-			  "successfully flushed all queues\n");
-	}
-
-	efx_for_each_channel(channel, efx) {
-		efx_for_each_channel_rx_queue(rx_queue, channel)
-			efx_fini_rx_queue(rx_queue);
-		efx_for_each_possible_channel_tx_queue(tx_queue, channel)
-			efx_fini_tx_queue(tx_queue);
-	}
-	efx->xdp_rxq_info_failed = false;
-}
-
 void efx_remove_channel(struct efx_channel *channel)
 {
 	struct efx_tx_queue *tx_queue;
@@ -976,50 +830,6 @@ void efx_link_set_wanted_fc(struct efx_nic *efx, u8 wanted_fc)
 
 static void efx_fini_port(struct efx_nic *efx);
 
-/* Push loopback/power/transmit disable settings to the PHY, and reconfigure
- * the MAC appropriately. All other PHY configuration changes are pushed
- * through phy_op->set_settings(), and pushed asynchronously to the MAC
- * through efx_monitor().
- *
- * Callers must hold the mac_lock
- */
-int __efx_reconfigure_port(struct efx_nic *efx)
-{
-	enum efx_phy_mode phy_mode;
-	int rc;
-
-	WARN_ON(!mutex_is_locked(&efx->mac_lock));
-
-	/* Disable PHY transmit in mac level loopbacks */
-	phy_mode = efx->phy_mode;
-	if (LOOPBACK_INTERNAL(efx))
-		efx->phy_mode |= PHY_MODE_TX_DISABLED;
-	else
-		efx->phy_mode &= ~PHY_MODE_TX_DISABLED;
-
-	rc = efx->type->reconfigure_port(efx);
-
-	if (rc)
-		efx->phy_mode = phy_mode;
-
-	return rc;
-}
-
-/* Reinitialise the MAC to pick up new PHY settings, even if the port is
- * disabled. */
-int efx_reconfigure_port(struct efx_nic *efx)
-{
-	int rc;
-
-	EFX_ASSERT_RESET_SERIALISED(efx);
-
-	mutex_lock(&efx->mac_lock);
-	rc = __efx_reconfigure_port(efx);
-	mutex_unlock(&efx->mac_lock);
-
-	return rc;
-}
-
 /* Asynchronous work item for changing MAC promiscuity and multicast
  * hash.  Avoid a drain/rx_ingress enable by reconfiguring the current
  * MAC directly. */
@@ -1086,44 +896,6 @@ static int efx_init_port(struct efx_nic *efx)
 	return rc;
 }
 
-static void efx_start_port(struct efx_nic *efx)
-{
-	netif_dbg(efx, ifup, efx->net_dev, "start port\n");
-	BUG_ON(efx->port_enabled);
-
-	mutex_lock(&efx->mac_lock);
-	efx->port_enabled = true;
-
-	/* Ensure MAC ingress/egress is enabled */
-	efx_mac_reconfigure(efx);
-
-	mutex_unlock(&efx->mac_lock);
-}
-
-/* Cancel work for MAC reconfiguration, periodic hardware monitoring
- * and the async self-test, wait for them to finish and prevent them
- * being scheduled again.  This doesn't cover online resets, which
- * should only be cancelled when removing the device.
- */
-static void efx_stop_port(struct efx_nic *efx)
-{
-	netif_dbg(efx, ifdown, efx->net_dev, "stop port\n");
-
-	EFX_ASSERT_RESET_SERIALISED(efx);
-
-	mutex_lock(&efx->mac_lock);
-	efx->port_enabled = false;
-	mutex_unlock(&efx->mac_lock);
-
-	/* Serialise against efx_set_multicast_list() */
-	netif_addr_lock_bh(efx->net_dev);
-	netif_addr_unlock_bh(efx->net_dev);
-
-	cancel_delayed_work_sync(&efx->monitor_work);
-	efx_selftest_async_cancel(efx);
-	cancel_work_sync(&efx->mac_work);
-}
-
 static void efx_fini_port(struct efx_nic *efx)
 {
 	netif_dbg(efx, drv, efx->net_dev, "shut down port\n");
@@ -1990,81 +1762,6 @@ static int efx_probe_all(struct efx_nic *efx)
 	return rc;
 }
 
-/* If the interface is supposed to be running but is not, start
- * the hardware and software data path, regular activity for the port
- * (MAC statistics, link polling, etc.) and schedule the port to be
- * reconfigured.  Interrupts must already be enabled.  This function
- * is safe to call multiple times, so long as the NIC is not disabled.
- * Requires the RTNL lock.
- */
-void efx_start_all(struct efx_nic *efx)
-{
-	EFX_ASSERT_RESET_SERIALISED(efx);
-	BUG_ON(efx->state == STATE_DISABLED);
-
-	/* Check that it is appropriate to restart the interface. All
-	 * of these flags are safe to read under just the rtnl lock */
-	if (efx->port_enabled || !netif_running(efx->net_dev) ||
-	    efx->reset_pending)
-		return;
-
-	efx_start_port(efx);
-	efx_start_datapath(efx);
-
-	/* Start the hardware monitor if there is one */
-	if (efx->type->monitor != NULL)
-		queue_delayed_work(efx->workqueue, &efx->monitor_work,
-				   efx_monitor_interval);
-
-	/* Link state detection is normally event-driven; we have
-	 * to poll now because we could have missed a change
-	 */
-	mutex_lock(&efx->mac_lock);
-	if (efx->phy_op->poll(efx))
-		efx_link_status_changed(efx);
-	mutex_unlock(&efx->mac_lock);
-
-	efx->type->start_stats(efx);
-	efx->type->pull_stats(efx);
-	spin_lock_bh(&efx->stats_lock);
-	efx->type->update_stats(efx, NULL, NULL);
-	spin_unlock_bh(&efx->stats_lock);
-}
-
-/* Quiesce the hardware and software data path, and regular activity
- * for the port without bringing the link down.  Safe to call multiple
- * times with the NIC in almost any state, but interrupts should be
- * enabled.  Requires the RTNL lock.
- */
-void efx_stop_all(struct efx_nic *efx)
-{
-	EFX_ASSERT_RESET_SERIALISED(efx);
-
-	/* port_enabled can be read safely under the rtnl lock */
-	if (!efx->port_enabled)
-		return;
-
-	/* update stats before we go down so we can accurately count
-	 * rx_nodesc_drops
-	 */
-	efx->type->pull_stats(efx);
-	spin_lock_bh(&efx->stats_lock);
-	efx->type->update_stats(efx, NULL, NULL);
-	spin_unlock_bh(&efx->stats_lock);
-	efx->type->stop_stats(efx);
-	efx_stop_port(efx);
-
-	/* Stop the kernel transmit interface.  This is only valid if
-	 * the device is stopped or detached; otherwise the watchdog
-	 * may fire immediately.
-	 */
-	WARN_ON(netif_running(efx->net_dev) &&
-		netif_device_present(efx->net_dev));
-	netif_tx_disable(efx->net_dev);
-
-	efx_stop_datapath(efx);
-}
-
 static void efx_remove_all(struct efx_nic *efx)
 {
 	rtnl_lock();
@@ -2188,6 +1885,13 @@ static void efx_monitor(struct work_struct *data)
 			   efx_monitor_interval);
 }
 
+void efx_start_monitor(struct efx_nic *efx)
+{
+	if (efx->type->monitor)
+		queue_delayed_work(efx->workqueue, &efx->monitor_work,
+				   efx_monitor_interval);
+}
+
 /**************************************************************************
  *
  * ioctls
diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index be8e80c9d513..445340c903b1 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -101,3 +101,331 @@ void efx_link_status_changed(struct efx_nic *efx)
 	else
 		netif_info(efx, link, efx->net_dev, "link down\n");
 }
+
+/**************************************************************************
+ *
+ * Event queue processing
+ *
+ *************************************************************************/
+
+void efx_start_channels(struct efx_nic *efx)
+{
+	struct efx_tx_queue *tx_queue;
+	struct efx_rx_queue *rx_queue;
+	struct efx_channel *channel;
+
+	efx_for_each_channel(channel, efx) {
+		efx_for_each_channel_tx_queue(tx_queue, channel) {
+			efx_init_tx_queue(tx_queue);
+			atomic_inc(&efx->active_queues);
+		}
+
+		efx_for_each_channel_rx_queue(rx_queue, channel) {
+			efx_init_rx_queue(rx_queue);
+			atomic_inc(&efx->active_queues);
+			efx_stop_eventq(channel);
+			efx_fast_push_rx_descriptors(rx_queue, false);
+			efx_start_eventq(channel);
+		}
+
+		WARN_ON(channel->rx_pkt_n_frags);
+	}
+}
+
+/* Channels are shutdown and reinitialised whilst the NIC is running
+ * to propagate configuration changes (mtu, checksum offload), or
+ * to clear hardware error conditions
+ */
+static void efx_start_datapath(struct efx_nic *efx)
+{
+	netdev_features_t old_features = efx->net_dev->features;
+	bool old_rx_scatter = efx->rx_scatter;
+	size_t rx_buf_len;
+
+	/* Calculate the rx buffer allocation parameters required to
+	 * support the current MTU, including padding for header
+	 * alignment and overruns.
+	 */
+	efx->rx_dma_len = (efx->rx_prefix_size +
+			   EFX_MAX_FRAME_LEN(efx->net_dev->mtu) +
+			   efx->type->rx_buffer_padding);
+	rx_buf_len = (sizeof(struct efx_rx_page_state) + XDP_PACKET_HEADROOM +
+		      efx->rx_ip_align + efx->rx_dma_len);
+	if (rx_buf_len <= PAGE_SIZE) {
+		efx->rx_scatter = efx->type->always_rx_scatter;
+		efx->rx_buffer_order = 0;
+	} else if (efx->type->can_rx_scatter) {
+		BUILD_BUG_ON(EFX_RX_USR_BUF_SIZE % L1_CACHE_BYTES);
+		BUILD_BUG_ON(sizeof(struct efx_rx_page_state) +
+			     2 * ALIGN(NET_IP_ALIGN + EFX_RX_USR_BUF_SIZE,
+				       EFX_RX_BUF_ALIGNMENT) >
+			     PAGE_SIZE);
+		efx->rx_scatter = true;
+		efx->rx_dma_len = EFX_RX_USR_BUF_SIZE;
+		efx->rx_buffer_order = 0;
+	} else {
+		efx->rx_scatter = false;
+		efx->rx_buffer_order = get_order(rx_buf_len);
+	}
+
+	efx_rx_config_page_split(efx);
+	if (efx->rx_buffer_order)
+		netif_dbg(efx, drv, efx->net_dev,
+			  "RX buf len=%u; page order=%u batch=%u\n",
+			  efx->rx_dma_len, efx->rx_buffer_order,
+			  efx->rx_pages_per_batch);
+	else
+		netif_dbg(efx, drv, efx->net_dev,
+			  "RX buf len=%u step=%u bpp=%u; page batch=%u\n",
+			  efx->rx_dma_len, efx->rx_page_buf_step,
+			  efx->rx_bufs_per_page, efx->rx_pages_per_batch);
+
+	/* Restore previously fixed features in hw_features and remove
+	 * features which are fixed now
+	 */
+	efx->net_dev->hw_features |= efx->net_dev->features;
+	efx->net_dev->hw_features &= ~efx->fixed_features;
+	efx->net_dev->features |= efx->fixed_features;
+	if (efx->net_dev->features != old_features)
+		netdev_features_change(efx->net_dev);
+
+	/* RX filters may also have scatter-enabled flags */
+	if (efx->rx_scatter != old_rx_scatter)
+		efx->type->filter_update_rx_scatter(efx);
+
+	/* We must keep at least one descriptor in a TX ring empty.
+	 * We could avoid this when the queue size does not exactly
+	 * match the hardware ring size, but it's not that important.
+	 * Therefore we stop the queue when one more skb might fill
+	 * the ring completely.  We wake it when half way back to
+	 * empty.
+	 */
+	efx->txq_stop_thresh = efx->txq_entries - efx_tx_max_skb_descs(efx);
+	efx->txq_wake_thresh = efx->txq_stop_thresh / 2;
+
+	/* Initialise the channels */
+	efx_start_channels(efx);
+
+	efx_ptp_start_datapath(efx);
+
+	if (netif_device_present(efx->net_dev))
+		netif_tx_wake_all_queues(efx->net_dev);
+}
+
+void efx_stop_channels(struct efx_nic *efx)
+{
+	struct efx_tx_queue *tx_queue;
+	struct efx_rx_queue *rx_queue;
+	struct efx_channel *channel;
+	int rc = 0;
+
+	/* Stop RX refill */
+	efx_for_each_channel(channel, efx) {
+		efx_for_each_channel_rx_queue(rx_queue, channel)
+			rx_queue->refill_enabled = false;
+	}
+
+	efx_for_each_channel(channel, efx) {
+		/* RX packet processing is pipelined, so wait for the
+		 * NAPI handler to complete.  At least event queue 0
+		 * might be kept active by non-data events, so don't
+		 * use napi_synchronize() but actually disable NAPI
+		 * temporarily.
+		 */
+		if (efx_channel_has_rx_queue(channel)) {
+			efx_stop_eventq(channel);
+			efx_start_eventq(channel);
+		}
+	}
+
+	if (efx->type->fini_dmaq)
+		rc = efx->type->fini_dmaq(efx);
+
+	if (rc) {
+		netif_err(efx, drv, efx->net_dev, "failed to flush queues\n");
+	} else {
+		netif_dbg(efx, drv, efx->net_dev,
+			  "successfully flushed all queues\n");
+	}
+
+	efx_for_each_channel(channel, efx) {
+		efx_for_each_channel_rx_queue(rx_queue, channel)
+			efx_fini_rx_queue(rx_queue);
+		efx_for_each_possible_channel_tx_queue(tx_queue, channel)
+			efx_fini_tx_queue(tx_queue);
+	}
+	efx->xdp_rxq_info_failed = false;
+}
+
+static void efx_stop_datapath(struct efx_nic *efx)
+{
+	EFX_ASSERT_RESET_SERIALISED(efx);
+	BUG_ON(efx->port_enabled);
+
+	efx_ptp_stop_datapath(efx);
+
+	efx_stop_channels(efx);
+}
+
+/**************************************************************************
+ *
+ * Port handling
+ *
+ **************************************************************************/
+
+static void efx_start_port(struct efx_nic *efx)
+{
+	netif_dbg(efx, ifup, efx->net_dev, "start port\n");
+	BUG_ON(efx->port_enabled);
+
+	mutex_lock(&efx->mac_lock);
+	efx->port_enabled = true;
+
+	/* Ensure MAC ingress/egress is enabled */
+	efx_mac_reconfigure(efx);
+
+	mutex_unlock(&efx->mac_lock);
+}
+
+/* Cancel work for MAC reconfiguration, periodic hardware monitoring
+ * and the async self-test, wait for them to finish and prevent them
+ * being scheduled again.  This doesn't cover online resets, which
+ * should only be cancelled when removing the device.
+ */
+static void efx_stop_port(struct efx_nic *efx)
+{
+	netif_dbg(efx, ifdown, efx->net_dev, "stop port\n");
+
+	EFX_ASSERT_RESET_SERIALISED(efx);
+
+	mutex_lock(&efx->mac_lock);
+	efx->port_enabled = false;
+	mutex_unlock(&efx->mac_lock);
+
+	/* Serialise against efx_set_multicast_list() */
+	netif_addr_lock_bh(efx->net_dev);
+	netif_addr_unlock_bh(efx->net_dev);
+
+	cancel_delayed_work_sync(&efx->monitor_work);
+	efx_selftest_async_cancel(efx);
+	cancel_work_sync(&efx->mac_work);
+}
+
+/* If the interface is supposed to be running but is not, start
+ * the hardware and software data path, regular activity for the port
+ * (MAC statistics, link polling, etc.) and schedule the port to be
+ * reconfigured.  Interrupts must already be enabled.  This function
+ * is safe to call multiple times, so long as the NIC is not disabled.
+ * Requires the RTNL lock.
+ */
+void efx_start_all(struct efx_nic *efx)
+{
+	EFX_ASSERT_RESET_SERIALISED(efx);
+	BUG_ON(efx->state == STATE_DISABLED);
+
+	/* Check that it is appropriate to restart the interface. All
+	 * of these flags are safe to read under just the rtnl lock
+	 */
+	if (efx->port_enabled || !netif_running(efx->net_dev) ||
+	    efx->reset_pending)
+		return;
+
+	efx_start_port(efx);
+	efx_start_datapath(efx);
+
+	/* Start the hardware monitor if there is one */
+	efx_start_monitor(efx);
+
+	/* Link state detection is normally event-driven; we have
+	 * to poll now because we could have missed a change
+	 */
+	mutex_lock(&efx->mac_lock);
+	if (efx->phy_op->poll(efx))
+		efx_link_status_changed(efx);
+	mutex_unlock(&efx->mac_lock);
+
+	efx->type->start_stats(efx);
+	efx->type->pull_stats(efx);
+	spin_lock_bh(&efx->stats_lock);
+	efx->type->update_stats(efx, NULL, NULL);
+	spin_unlock_bh(&efx->stats_lock);
+}
+
+/* Quiesce the hardware and software data path, and regular activity
+ * for the port without bringing the link down.  Safe to call multiple
+ * times with the NIC in almost any state, but interrupts should be
+ * enabled.  Requires the RTNL lock.
+ */
+void efx_stop_all(struct efx_nic *efx)
+{
+	EFX_ASSERT_RESET_SERIALISED(efx);
+
+	/* port_enabled can be read safely under the rtnl lock */
+	if (!efx->port_enabled)
+		return;
+
+	/* update stats before we go down so we can accurately count
+	 * rx_nodesc_drops
+	 */
+	efx->type->pull_stats(efx);
+	spin_lock_bh(&efx->stats_lock);
+	efx->type->update_stats(efx, NULL, NULL);
+	spin_unlock_bh(&efx->stats_lock);
+	efx->type->stop_stats(efx);
+	efx_stop_port(efx);
+
+	/* Stop the kernel transmit interface.  This is only valid if
+	 * the device is stopped or detached; otherwise the watchdog
+	 * may fire immediately.
+	 */
+	WARN_ON(netif_running(efx->net_dev) &&
+		netif_device_present(efx->net_dev));
+	netif_tx_disable(efx->net_dev);
+
+	efx_stop_datapath(efx);
+}
+
+/* Push loopback/power/transmit disable settings to the PHY, and reconfigure
+ * the MAC appropriately. All other PHY configuration changes are pushed
+ * through phy_op->set_settings(), and pushed asynchronously to the MAC
+ * through efx_monitor().
+ *
+ * Callers must hold the mac_lock
+ */
+int __efx_reconfigure_port(struct efx_nic *efx)
+{
+	enum efx_phy_mode phy_mode;
+	int rc;
+
+	WARN_ON(!mutex_is_locked(&efx->mac_lock));
+
+	/* Disable PHY transmit in mac level loopbacks */
+	phy_mode = efx->phy_mode;
+	if (LOOPBACK_INTERNAL(efx))
+		efx->phy_mode |= PHY_MODE_TX_DISABLED;
+	else
+		efx->phy_mode &= ~PHY_MODE_TX_DISABLED;
+
+	rc = efx->type->reconfigure_port(efx);
+
+	if (rc)
+		efx->phy_mode = phy_mode;
+
+	return rc;
+}
+
+/* Reinitialise the MAC to pick up new PHY settings, even if the port is
+ * disabled.
+ */
+int efx_reconfigure_port(struct efx_nic *efx)
+{
+	int rc;
+
+	EFX_ASSERT_RESET_SERIALISED(efx);
+
+	mutex_lock(&efx->mac_lock);
+	rc = __efx_reconfigure_port(efx);
+	mutex_unlock(&efx->mac_lock);
+
+	return rc;
+}
-- 
2.20.1


