Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (unknown [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4BC5BBAE5
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 00:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbiIQWwe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Sep 2022 18:52:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiIQWwc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Sep 2022 18:52:32 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC3252B1B7
        for <netdev@vger.kernel.org>; Sat, 17 Sep 2022 15:52:29 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1oZgfY-0001LJ-Nv; Sun, 18 Sep 2022 00:52:16 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1oZgfX-001MDd-MU; Sun, 18 Sep 2022 00:52:14 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1oZgfV-001bTk-Ix; Sun, 18 Sep 2022 00:52:13 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH] net: fjes: Reorder symbols to get rid of a few forward declarations
Date:   Sun, 18 Sep 2022 00:51:42 +0200
Message-Id: <20220917225142.473770-1-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=42005; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=67MkBNEmKqtXkZpizcfWe6pE8hbkC+LDWt6XkhCJHes=; b=owEBbQGS/pANAwAKAcH8FHityuwJAcsmYgBjJk91/YpLXnP9whKFlpIoiJXFzN8HC9ESjOzzzAKr StJ4AhaJATMEAAEKAB0WIQR+cioWkBis/z50pAvB/BR4rcrsCQUCYyZPdQAKCRDB/BR4rcrsCQVLB/ 91Px3KaNLwSJAJR64ICeb/4qgMKpavhVEAF+c50/8df3LgqKh/uGX3ekjltlctGtOKnLKgEUh78tQe s/cAoFwYwXc2zcFcZCBEGFR32tDm5w57uQ1jGH3jvZf7yOgZtBbzuzt8MZhJT01RoViDrQv2CW4WUs mCgBfjHfQtthYuIN/ixdwLE5MerCg8nJqw3+cAiT93EHhKRx9Wu3sGvtRQT+jIHrHrMetla9qGuI9M uWS4eQ4kw3giSASg4cFmLKoID6ht4nvf4AegLCiKlGxdvZDIOr6pSNh1Q/wizqFPSo3X22GrEyvlOw SmeorC86JCsE/47rTiSGaKYI/zYcqw
X-Developer-Key: i=u.kleine-koenig@pengutronix.de; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quite a few of the functions and other symbols defined in this driver had
forward declarations. They can all be dropped after reordering them.

This saves a few lines of code and reduces code duplication.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
Hello,

this patch triggers a few checkpatch warnings, but these are all not new
problems. I just moved around functions and structs 1:1.

Best regards
Uwe

 drivers/net/fjes/fjes_main.c | 1258 +++++++++++++++++-----------------
 1 file changed, 613 insertions(+), 645 deletions(-)

diff --git a/drivers/net/fjes/fjes_main.c b/drivers/net/fjes/fjes_main.c
index 5805e4a56385..2e2fac0e84da 100644
--- a/drivers/net/fjes/fjes_main.c
+++ b/drivers/net/fjes/fjes_main.c
@@ -32,68 +32,12 @@ MODULE_VERSION(DRV_VERSION);
 
 #define ACPI_MOTHERBOARD_RESOURCE_HID "PNP0C02"
 
-static int fjes_request_irq(struct fjes_adapter *);
-static void fjes_free_irq(struct fjes_adapter *);
-
-static int fjes_open(struct net_device *);
-static int fjes_close(struct net_device *);
-static int fjes_setup_resources(struct fjes_adapter *);
-static void fjes_free_resources(struct fjes_adapter *);
-static netdev_tx_t fjes_xmit_frame(struct sk_buff *, struct net_device *);
-static void fjes_raise_intr_rxdata_task(struct work_struct *);
-static void fjes_tx_stall_task(struct work_struct *);
-static void fjes_force_close_task(struct work_struct *);
-static irqreturn_t fjes_intr(int, void*);
-static void fjes_get_stats64(struct net_device *, struct rtnl_link_stats64 *);
-static int fjes_change_mtu(struct net_device *, int);
-static int fjes_vlan_rx_add_vid(struct net_device *, __be16 proto, u16);
-static int fjes_vlan_rx_kill_vid(struct net_device *, __be16 proto, u16);
-static void fjes_tx_retry(struct net_device *, unsigned int txqueue);
-
-static int fjes_acpi_add(struct acpi_device *);
-static int fjes_acpi_remove(struct acpi_device *);
-static acpi_status fjes_get_acpi_resource(struct acpi_resource *, void*);
-
-static int fjes_probe(struct platform_device *);
-static int fjes_remove(struct platform_device *);
-
-static int fjes_sw_init(struct fjes_adapter *);
-static void fjes_netdev_setup(struct net_device *);
-static void fjes_irq_watch_task(struct work_struct *);
-static void fjes_watch_unshare_task(struct work_struct *);
-static void fjes_rx_irq(struct fjes_adapter *, int);
-static int fjes_poll(struct napi_struct *, int);
-
 static const struct acpi_device_id fjes_acpi_ids[] = {
 	{ACPI_MOTHERBOARD_RESOURCE_HID, 0},
 	{"", 0},
 };
 MODULE_DEVICE_TABLE(acpi, fjes_acpi_ids);
 
-static struct acpi_driver fjes_acpi_driver = {
-	.name = DRV_NAME,
-	.class = DRV_NAME,
-	.owner = THIS_MODULE,
-	.ids = fjes_acpi_ids,
-	.ops = {
-		.add = fjes_acpi_add,
-		.remove = fjes_acpi_remove,
-	},
-};
-
-static struct platform_driver fjes_driver = {
-	.driver = {
-		.name = DRV_NAME,
-	},
-	.probe = fjes_probe,
-	.remove = fjes_remove,
-};
-
-static struct resource fjes_resource[] = {
-	DEFINE_RES_MEM(0, 1),
-	DEFINE_RES_IRQ(0)
-};
-
 static bool is_extended_socket_device(struct acpi_device *device)
 {
 	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL};
@@ -139,43 +83,6 @@ static int acpi_check_extended_socket_status(struct acpi_device *device)
 	return 0;
 }
 
-static int fjes_acpi_add(struct acpi_device *device)
-{
-	struct platform_device *plat_dev;
-	acpi_status status;
-
-	if (!is_extended_socket_device(device))
-		return -ENODEV;
-
-	if (acpi_check_extended_socket_status(device))
-		return -ENODEV;
-
-	status = acpi_walk_resources(device->handle, METHOD_NAME__CRS,
-				     fjes_get_acpi_resource, fjes_resource);
-	if (ACPI_FAILURE(status))
-		return -ENODEV;
-
-	/* create platform_device */
-	plat_dev = platform_device_register_simple(DRV_NAME, 0, fjes_resource,
-						   ARRAY_SIZE(fjes_resource));
-	if (IS_ERR(plat_dev))
-		return PTR_ERR(plat_dev);
-
-	device->driver_data = plat_dev;
-
-	return 0;
-}
-
-static int fjes_acpi_remove(struct acpi_device *device)
-{
-	struct platform_device *plat_dev;
-
-	plat_dev = (struct platform_device *)acpi_driver_data(device);
-	platform_device_unregister(plat_dev);
-
-	return 0;
-}
-
 static acpi_status
 fjes_get_acpi_resource(struct acpi_resource *acpi_res, void *data)
 {
@@ -206,143 +113,59 @@ fjes_get_acpi_resource(struct acpi_resource *acpi_res, void *data)
 	return AE_OK;
 }
 
-static int fjes_request_irq(struct fjes_adapter *adapter)
-{
-	struct net_device *netdev = adapter->netdev;
-	int result = -1;
-
-	adapter->interrupt_watch_enable = true;
-	if (!delayed_work_pending(&adapter->interrupt_watch_task)) {
-		queue_delayed_work(adapter->control_wq,
-				   &adapter->interrupt_watch_task,
-				   FJES_IRQ_WATCH_DELAY);
-	}
-
-	if (!adapter->irq_registered) {
-		result = request_irq(adapter->hw.hw_res.irq, fjes_intr,
-				     IRQF_SHARED, netdev->name, adapter);
-		if (result)
-			adapter->irq_registered = false;
-		else
-			adapter->irq_registered = true;
-	}
-
-	return result;
-}
-
-static void fjes_free_irq(struct fjes_adapter *adapter)
-{
-	struct fjes_hw *hw = &adapter->hw;
-
-	adapter->interrupt_watch_enable = false;
-	cancel_delayed_work_sync(&adapter->interrupt_watch_task);
-
-	fjes_hw_set_irqmask(hw, REG_ICTL_MASK_ALL, true);
-
-	if (adapter->irq_registered) {
-		free_irq(adapter->hw.hw_res.irq, adapter);
-		adapter->irq_registered = false;
-	}
-}
-
-static const struct net_device_ops fjes_netdev_ops = {
-	.ndo_open		= fjes_open,
-	.ndo_stop		= fjes_close,
-	.ndo_start_xmit		= fjes_xmit_frame,
-	.ndo_get_stats64	= fjes_get_stats64,
-	.ndo_change_mtu		= fjes_change_mtu,
-	.ndo_tx_timeout		= fjes_tx_retry,
-	.ndo_vlan_rx_add_vid	= fjes_vlan_rx_add_vid,
-	.ndo_vlan_rx_kill_vid = fjes_vlan_rx_kill_vid,
+static struct resource fjes_resource[] = {
+	DEFINE_RES_MEM(0, 1),
+	DEFINE_RES_IRQ(0)
 };
 
-/* fjes_open - Called when a network interface is made active */
-static int fjes_open(struct net_device *netdev)
+static int fjes_acpi_add(struct acpi_device *device)
 {
-	struct fjes_adapter *adapter = netdev_priv(netdev);
-	struct fjes_hw *hw = &adapter->hw;
-	int result;
-
-	if (adapter->open_guard)
-		return -ENXIO;
-
-	result = fjes_setup_resources(adapter);
-	if (result)
-		goto err_setup_res;
-
-	hw->txrx_stop_req_bit = 0;
-	hw->epstop_req_bit = 0;
+	struct platform_device *plat_dev;
+	acpi_status status;
 
-	napi_enable(&adapter->napi);
+	if (!is_extended_socket_device(device))
+		return -ENODEV;
 
-	fjes_hw_capture_interrupt_status(hw);
+	if (acpi_check_extended_socket_status(device))
+		return -ENODEV;
 
-	result = fjes_request_irq(adapter);
-	if (result)
-		goto err_req_irq;
+	status = acpi_walk_resources(device->handle, METHOD_NAME__CRS,
+				     fjes_get_acpi_resource, fjes_resource);
+	if (ACPI_FAILURE(status))
+		return -ENODEV;
 
-	fjes_hw_set_irqmask(hw, REG_ICTL_MASK_ALL, false);
+	/* create platform_device */
+	plat_dev = platform_device_register_simple(DRV_NAME, 0, fjes_resource,
+						   ARRAY_SIZE(fjes_resource));
+	if (IS_ERR(plat_dev))
+		return PTR_ERR(plat_dev);
 
-	netif_tx_start_all_queues(netdev);
-	netif_carrier_on(netdev);
+	device->driver_data = plat_dev;
 
 	return 0;
-
-err_req_irq:
-	fjes_free_irq(adapter);
-	napi_disable(&adapter->napi);
-
-err_setup_res:
-	fjes_free_resources(adapter);
-	return result;
 }
 
-/* fjes_close - Disables a network interface */
-static int fjes_close(struct net_device *netdev)
+static int fjes_acpi_remove(struct acpi_device *device)
 {
-	struct fjes_adapter *adapter = netdev_priv(netdev);
-	struct fjes_hw *hw = &adapter->hw;
-	unsigned long flags;
-	int epidx;
-
-	netif_tx_stop_all_queues(netdev);
-	netif_carrier_off(netdev);
-
-	fjes_hw_raise_epstop(hw);
-
-	napi_disable(&adapter->napi);
-
-	spin_lock_irqsave(&hw->rx_status_lock, flags);
-	for (epidx = 0; epidx < hw->max_epid; epidx++) {
-		if (epidx == hw->my_epid)
-			continue;
-
-		if (fjes_hw_get_partner_ep_status(hw, epidx) ==
-		    EP_PARTNER_SHARED)
-			adapter->hw.ep_shm_info[epidx]
-				   .tx.info->v1i.rx_status &=
-				~FJES_RX_POLL_WORK;
-	}
-	spin_unlock_irqrestore(&hw->rx_status_lock, flags);
-
-	fjes_free_irq(adapter);
-
-	cancel_delayed_work_sync(&adapter->interrupt_watch_task);
-	cancel_work_sync(&adapter->unshare_watch_task);
-	adapter->unshare_watch_bitmask = 0;
-	cancel_work_sync(&adapter->raise_intr_rxdata_task);
-	cancel_work_sync(&adapter->tx_stall_task);
-
-	cancel_work_sync(&hw->update_zone_task);
-	cancel_work_sync(&hw->epstop_task);
-
-	fjes_hw_wait_epstop(hw);
+	struct platform_device *plat_dev;
 
-	fjes_free_resources(adapter);
+	plat_dev = (struct platform_device *)acpi_driver_data(device);
+	platform_device_unregister(plat_dev);
 
 	return 0;
 }
 
+static struct acpi_driver fjes_acpi_driver = {
+	.name = DRV_NAME,
+	.class = DRV_NAME,
+	.owner = THIS_MODULE,
+	.ids = fjes_acpi_ids,
+	.ops = {
+		.add = fjes_acpi_add,
+		.remove = fjes_acpi_remove,
+	},
+};
+
 static int fjes_setup_resources(struct fjes_adapter *adapter)
 {
 	struct net_device *netdev = adapter->netdev;
@@ -421,38 +244,220 @@ static int fjes_setup_resources(struct fjes_adapter *adapter)
 	return 0;
 }
 
-static void fjes_free_resources(struct fjes_adapter *adapter)
+static void fjes_rx_irq(struct fjes_adapter *adapter, int src_epid)
 {
-	struct net_device *netdev = adapter->netdev;
-	struct fjes_device_command_param param;
-	struct ep_share_mem_info *buf_pair;
 	struct fjes_hw *hw = &adapter->hw;
-	bool reset_flag = false;
-	unsigned long flags;
-	int result;
-	int epidx;
-
-	for (epidx = 0; epidx < hw->max_epid; epidx++) {
-		if (epidx == hw->my_epid)
-			continue;
 
-		mutex_lock(&hw->hw_info.lock);
-		result = fjes_hw_unregister_buff_addr(hw, epidx);
-		mutex_unlock(&hw->hw_info.lock);
+	fjes_hw_set_irqmask(hw, REG_ICTL_MASK_RX_DATA, true);
 
-		hw->ep_shm_info[epidx].ep_stats.com_unregist_buf_exec += 1;
+	adapter->unset_rx_last = true;
+	napi_schedule(&adapter->napi);
+}
 
-		if (result)
-			reset_flag = true;
+static void fjes_stop_req_irq(struct fjes_adapter *adapter, int src_epid)
+{
+	struct fjes_hw *hw = &adapter->hw;
+	enum ep_partner_status status;
+	unsigned long flags;
 
-		buf_pair = &hw->ep_shm_info[epidx];
+	set_bit(src_epid, &hw->hw_info.buffer_unshare_reserve_bit);
 
+	status = fjes_hw_get_partner_ep_status(hw, src_epid);
+	trace_fjes_stop_req_irq_pre(hw, src_epid, status);
+	switch (status) {
+	case EP_PARTNER_WAITING:
 		spin_lock_irqsave(&hw->rx_status_lock, flags);
-		fjes_hw_setup_epbuf(&buf_pair->tx,
-				    netdev->dev_addr, netdev->mtu);
+		hw->ep_shm_info[src_epid].tx.info->v1i.rx_status |=
+				FJES_RX_STOP_REQ_DONE;
 		spin_unlock_irqrestore(&hw->rx_status_lock, flags);
-
-		clear_bit(epidx, &hw->txrx_stop_req_bit);
+		clear_bit(src_epid, &hw->txrx_stop_req_bit);
+		fallthrough;
+	case EP_PARTNER_UNSHARE:
+	case EP_PARTNER_COMPLETE:
+	default:
+		set_bit(src_epid, &adapter->unshare_watch_bitmask);
+		if (!work_pending(&adapter->unshare_watch_task))
+			queue_work(adapter->control_wq,
+				   &adapter->unshare_watch_task);
+		break;
+	case EP_PARTNER_SHARED:
+		set_bit(src_epid, &hw->epstop_req_bit);
+
+		if (!work_pending(&hw->epstop_task))
+			queue_work(adapter->control_wq, &hw->epstop_task);
+		break;
+	}
+	trace_fjes_stop_req_irq_post(hw, src_epid);
+}
+
+static void fjes_txrx_stop_req_irq(struct fjes_adapter *adapter,
+				   int src_epid)
+{
+	struct fjes_hw *hw = &adapter->hw;
+	enum ep_partner_status status;
+	unsigned long flags;
+
+	status = fjes_hw_get_partner_ep_status(hw, src_epid);
+	trace_fjes_txrx_stop_req_irq_pre(hw, src_epid, status);
+	switch (status) {
+	case EP_PARTNER_UNSHARE:
+	case EP_PARTNER_COMPLETE:
+	default:
+		break;
+	case EP_PARTNER_WAITING:
+		if (src_epid < hw->my_epid) {
+			spin_lock_irqsave(&hw->rx_status_lock, flags);
+			hw->ep_shm_info[src_epid].tx.info->v1i.rx_status |=
+				FJES_RX_STOP_REQ_DONE;
+			spin_unlock_irqrestore(&hw->rx_status_lock, flags);
+
+			clear_bit(src_epid, &hw->txrx_stop_req_bit);
+			set_bit(src_epid, &adapter->unshare_watch_bitmask);
+
+			if (!work_pending(&adapter->unshare_watch_task))
+				queue_work(adapter->control_wq,
+					   &adapter->unshare_watch_task);
+		}
+		break;
+	case EP_PARTNER_SHARED:
+		if (hw->ep_shm_info[src_epid].rx.info->v1i.rx_status &
+		    FJES_RX_STOP_REQ_REQUEST) {
+			set_bit(src_epid, &hw->epstop_req_bit);
+			if (!work_pending(&hw->epstop_task))
+				queue_work(adapter->control_wq,
+					   &hw->epstop_task);
+		}
+		break;
+	}
+	trace_fjes_txrx_stop_req_irq_post(hw, src_epid);
+}
+
+static void fjes_update_zone_irq(struct fjes_adapter *adapter,
+				 int src_epid)
+{
+	struct fjes_hw *hw = &adapter->hw;
+
+	if (!work_pending(&hw->update_zone_task))
+		queue_work(adapter->control_wq, &hw->update_zone_task);
+}
+
+static irqreturn_t fjes_intr(int irq, void *data)
+{
+	struct fjes_adapter *adapter = data;
+	struct fjes_hw *hw = &adapter->hw;
+	irqreturn_t ret;
+	u32 icr;
+
+	icr = fjes_hw_capture_interrupt_status(hw);
+
+	if (icr & REG_IS_MASK_IS_ASSERT) {
+		if (icr & REG_ICTL_MASK_RX_DATA) {
+			fjes_rx_irq(adapter, icr & REG_IS_MASK_EPID);
+			hw->ep_shm_info[icr & REG_IS_MASK_EPID].ep_stats
+				.recv_intr_rx += 1;
+		}
+
+		if (icr & REG_ICTL_MASK_DEV_STOP_REQ) {
+			fjes_stop_req_irq(adapter, icr & REG_IS_MASK_EPID);
+			hw->ep_shm_info[icr & REG_IS_MASK_EPID].ep_stats
+				.recv_intr_stop += 1;
+		}
+
+		if (icr & REG_ICTL_MASK_TXRX_STOP_REQ) {
+			fjes_txrx_stop_req_irq(adapter, icr & REG_IS_MASK_EPID);
+			hw->ep_shm_info[icr & REG_IS_MASK_EPID].ep_stats
+				.recv_intr_unshare += 1;
+		}
+
+		if (icr & REG_ICTL_MASK_TXRX_STOP_DONE)
+			fjes_hw_set_irqmask(hw,
+					    REG_ICTL_MASK_TXRX_STOP_DONE, true);
+
+		if (icr & REG_ICTL_MASK_INFO_UPDATE) {
+			fjes_update_zone_irq(adapter, icr & REG_IS_MASK_EPID);
+			hw->ep_shm_info[icr & REG_IS_MASK_EPID].ep_stats
+				.recv_intr_zoneupdate += 1;
+		}
+
+		ret = IRQ_HANDLED;
+	} else {
+		ret = IRQ_NONE;
+	}
+
+	return ret;
+}
+
+static int fjes_request_irq(struct fjes_adapter *adapter)
+{
+	struct net_device *netdev = adapter->netdev;
+	int result = -1;
+
+	adapter->interrupt_watch_enable = true;
+	if (!delayed_work_pending(&adapter->interrupt_watch_task)) {
+		queue_delayed_work(adapter->control_wq,
+				   &adapter->interrupt_watch_task,
+				   FJES_IRQ_WATCH_DELAY);
+	}
+
+	if (!adapter->irq_registered) {
+		result = request_irq(adapter->hw.hw_res.irq, fjes_intr,
+				     IRQF_SHARED, netdev->name, adapter);
+		if (result)
+			adapter->irq_registered = false;
+		else
+			adapter->irq_registered = true;
+	}
+
+	return result;
+}
+
+static void fjes_free_irq(struct fjes_adapter *adapter)
+{
+	struct fjes_hw *hw = &adapter->hw;
+
+	adapter->interrupt_watch_enable = false;
+	cancel_delayed_work_sync(&adapter->interrupt_watch_task);
+
+	fjes_hw_set_irqmask(hw, REG_ICTL_MASK_ALL, true);
+
+	if (adapter->irq_registered) {
+		free_irq(adapter->hw.hw_res.irq, adapter);
+		adapter->irq_registered = false;
+	}
+}
+
+static void fjes_free_resources(struct fjes_adapter *adapter)
+{
+	struct net_device *netdev = adapter->netdev;
+	struct fjes_device_command_param param;
+	struct ep_share_mem_info *buf_pair;
+	struct fjes_hw *hw = &adapter->hw;
+	bool reset_flag = false;
+	unsigned long flags;
+	int result;
+	int epidx;
+
+	for (epidx = 0; epidx < hw->max_epid; epidx++) {
+		if (epidx == hw->my_epid)
+			continue;
+
+		mutex_lock(&hw->hw_info.lock);
+		result = fjes_hw_unregister_buff_addr(hw, epidx);
+		mutex_unlock(&hw->hw_info.lock);
+
+		hw->ep_shm_info[epidx].ep_stats.com_unregist_buf_exec += 1;
+
+		if (result)
+			reset_flag = true;
+
+		buf_pair = &hw->ep_shm_info[epidx];
+
+		spin_lock_irqsave(&hw->rx_status_lock, flags);
+		fjes_hw_setup_epbuf(&buf_pair->tx,
+				    netdev->dev_addr, netdev->mtu);
+		spin_unlock_irqrestore(&hw->rx_status_lock, flags);
+
+		clear_bit(epidx, &hw->txrx_stop_req_bit);
 	}
 
 	if (reset_flag || adapter->force_reset) {
@@ -477,121 +482,91 @@ static void fjes_free_resources(struct fjes_adapter *adapter)
 	}
 }
 
-static void fjes_tx_stall_task(struct work_struct *work)
+/* fjes_open - Called when a network interface is made active */
+static int fjes_open(struct net_device *netdev)
 {
-	struct fjes_adapter *adapter = container_of(work,
-			struct fjes_adapter, tx_stall_task);
-	struct net_device *netdev = adapter->netdev;
+	struct fjes_adapter *adapter = netdev_priv(netdev);
 	struct fjes_hw *hw = &adapter->hw;
-	int all_queue_available, sendable;
-	enum ep_partner_status pstatus;
-	int max_epid, my_epid, epid;
-	union ep_buffer_info *info;
-	int i;
-
-	if (((long)jiffies -
-		dev_trans_start(netdev)) > FJES_TX_TX_STALL_TIMEOUT) {
-		netif_wake_queue(netdev);
-		return;
-	}
-
-	my_epid = hw->my_epid;
-	max_epid = hw->max_epid;
+	int result;
 
-	for (i = 0; i < 5; i++) {
-		all_queue_available = 1;
+	if (adapter->open_guard)
+		return -ENXIO;
 
-		for (epid = 0; epid < max_epid; epid++) {
-			if (my_epid == epid)
-				continue;
+	result = fjes_setup_resources(adapter);
+	if (result)
+		goto err_setup_res;
 
-			pstatus = fjes_hw_get_partner_ep_status(hw, epid);
-			sendable = (pstatus == EP_PARTNER_SHARED);
-			if (!sendable)
-				continue;
+	hw->txrx_stop_req_bit = 0;
+	hw->epstop_req_bit = 0;
 
-			info = adapter->hw.ep_shm_info[epid].tx.info;
+	napi_enable(&adapter->napi);
 
-			if (!(info->v1i.rx_status & FJES_RX_MTU_CHANGING_DONE))
-				return;
+	fjes_hw_capture_interrupt_status(hw);
 
-			if (EP_RING_FULL(info->v1i.head, info->v1i.tail,
-					 info->v1i.count_max)) {
-				all_queue_available = 0;
-				break;
-			}
-		}
+	result = fjes_request_irq(adapter);
+	if (result)
+		goto err_req_irq;
 
-		if (all_queue_available) {
-			netif_wake_queue(netdev);
-			return;
-		}
-	}
+	fjes_hw_set_irqmask(hw, REG_ICTL_MASK_ALL, false);
 
-	usleep_range(50, 100);
+	netif_tx_start_all_queues(netdev);
+	netif_carrier_on(netdev);
 
-	queue_work(adapter->txrx_wq, &adapter->tx_stall_task);
-}
+	return 0;
 
-static void fjes_force_close_task(struct work_struct *work)
-{
-	struct fjes_adapter *adapter = container_of(work,
-			struct fjes_adapter, force_close_task);
-	struct net_device *netdev = adapter->netdev;
+err_req_irq:
+	fjes_free_irq(adapter);
+	napi_disable(&adapter->napi);
 
-	rtnl_lock();
-	dev_close(netdev);
-	rtnl_unlock();
+err_setup_res:
+	fjes_free_resources(adapter);
+	return result;
 }
 
-static void fjes_raise_intr_rxdata_task(struct work_struct *work)
+/* fjes_close - Disables a network interface */
+static int fjes_close(struct net_device *netdev)
 {
-	struct fjes_adapter *adapter = container_of(work,
-			struct fjes_adapter, raise_intr_rxdata_task);
+	struct fjes_adapter *adapter = netdev_priv(netdev);
 	struct fjes_hw *hw = &adapter->hw;
-	enum ep_partner_status pstatus;
-	int max_epid, my_epid, epid;
+	unsigned long flags;
+	int epidx;
 
-	my_epid = hw->my_epid;
-	max_epid = hw->max_epid;
+	netif_tx_stop_all_queues(netdev);
+	netif_carrier_off(netdev);
 
-	for (epid = 0; epid < max_epid; epid++)
-		hw->ep_shm_info[epid].tx_status_work = 0;
+	fjes_hw_raise_epstop(hw);
 
-	for (epid = 0; epid < max_epid; epid++) {
-		if (epid == my_epid)
-			continue;
+	napi_disable(&adapter->napi);
 
-		pstatus = fjes_hw_get_partner_ep_status(hw, epid);
-		if (pstatus == EP_PARTNER_SHARED) {
-			hw->ep_shm_info[epid].tx_status_work =
-				hw->ep_shm_info[epid].tx.info->v1i.tx_status;
+	spin_lock_irqsave(&hw->rx_status_lock, flags);
+	for (epidx = 0; epidx < hw->max_epid; epidx++) {
+		if (epidx == hw->my_epid)
+			continue;
 
-			if (hw->ep_shm_info[epid].tx_status_work ==
-				FJES_TX_DELAY_SEND_PENDING) {
-				hw->ep_shm_info[epid].tx.info->v1i.tx_status =
-					FJES_TX_DELAY_SEND_NONE;
-			}
-		}
+		if (fjes_hw_get_partner_ep_status(hw, epidx) ==
+		    EP_PARTNER_SHARED)
+			adapter->hw.ep_shm_info[epidx]
+				   .tx.info->v1i.rx_status &=
+				~FJES_RX_POLL_WORK;
 	}
+	spin_unlock_irqrestore(&hw->rx_status_lock, flags);
 
-	for (epid = 0; epid < max_epid; epid++) {
-		if (epid == my_epid)
-			continue;
+	fjes_free_irq(adapter);
 
-		pstatus = fjes_hw_get_partner_ep_status(hw, epid);
-		if ((hw->ep_shm_info[epid].tx_status_work ==
-		     FJES_TX_DELAY_SEND_PENDING) &&
-		    (pstatus == EP_PARTNER_SHARED) &&
-		    !(hw->ep_shm_info[epid].rx.info->v1i.rx_status &
-		      FJES_RX_POLL_WORK)) {
-			fjes_hw_raise_interrupt(hw, epid,
-						REG_ICTL_MASK_RX_DATA);
-			hw->ep_shm_info[epid].ep_stats.send_intr_rx += 1;
-		}
-	}
+	cancel_delayed_work_sync(&adapter->interrupt_watch_task);
+	cancel_work_sync(&adapter->unshare_watch_task);
+	adapter->unshare_watch_bitmask = 0;
+	cancel_work_sync(&adapter->raise_intr_rxdata_task);
+	cancel_work_sync(&adapter->tx_stall_task);
 
-	usleep_range(500, 1000);
+	cancel_work_sync(&hw->update_zone_task);
+	cancel_work_sync(&hw->epstop_task);
+
+	fjes_hw_wait_epstop(hw);
+
+	fjes_free_resources(adapter);
+
+	return 0;
 }
 
 static int fjes_tx_send(struct fjes_adapter *adapter, int dest,
@@ -787,13 +762,6 @@ fjes_xmit_frame(struct sk_buff *skb, struct net_device *netdev)
 	return ret;
 }
 
-static void fjes_tx_retry(struct net_device *netdev, unsigned int txqueue)
-{
-	struct netdev_queue *queue = netdev_get_tx_queue(netdev, 0);
-
-	netif_tx_wake_queue(queue);
-}
-
 static void
 fjes_get_stats64(struct net_device *netdev, struct rtnl_link_stats64 *stats)
 {
@@ -867,177 +835,76 @@ static int fjes_change_mtu(struct net_device *netdev, int new_mtu)
 		napi_enable(&adapter->napi);
 		napi_schedule(&adapter->napi);
 	}
-
-	return ret;
-}
-
-static int fjes_vlan_rx_add_vid(struct net_device *netdev,
-				__be16 proto, u16 vid)
-{
-	struct fjes_adapter *adapter = netdev_priv(netdev);
-	bool ret = true;
-	int epid;
-
-	for (epid = 0; epid < adapter->hw.max_epid; epid++) {
-		if (epid == adapter->hw.my_epid)
-			continue;
-
-		if (!fjes_hw_check_vlan_id(
-			&adapter->hw.ep_shm_info[epid].tx, vid))
-			ret = fjes_hw_set_vlan_id(
-				&adapter->hw.ep_shm_info[epid].tx, vid);
-	}
-
-	return ret ? 0 : -ENOSPC;
-}
-
-static int fjes_vlan_rx_kill_vid(struct net_device *netdev,
-				 __be16 proto, u16 vid)
-{
-	struct fjes_adapter *adapter = netdev_priv(netdev);
-	int epid;
-
-	for (epid = 0; epid < adapter->hw.max_epid; epid++) {
-		if (epid == adapter->hw.my_epid)
-			continue;
-
-		fjes_hw_del_vlan_id(&adapter->hw.ep_shm_info[epid].tx, vid);
-	}
-
-	return 0;
-}
-
-static void fjes_txrx_stop_req_irq(struct fjes_adapter *adapter,
-				   int src_epid)
-{
-	struct fjes_hw *hw = &adapter->hw;
-	enum ep_partner_status status;
-	unsigned long flags;
-
-	status = fjes_hw_get_partner_ep_status(hw, src_epid);
-	trace_fjes_txrx_stop_req_irq_pre(hw, src_epid, status);
-	switch (status) {
-	case EP_PARTNER_UNSHARE:
-	case EP_PARTNER_COMPLETE:
-	default:
-		break;
-	case EP_PARTNER_WAITING:
-		if (src_epid < hw->my_epid) {
-			spin_lock_irqsave(&hw->rx_status_lock, flags);
-			hw->ep_shm_info[src_epid].tx.info->v1i.rx_status |=
-				FJES_RX_STOP_REQ_DONE;
-			spin_unlock_irqrestore(&hw->rx_status_lock, flags);
-
-			clear_bit(src_epid, &hw->txrx_stop_req_bit);
-			set_bit(src_epid, &adapter->unshare_watch_bitmask);
-
-			if (!work_pending(&adapter->unshare_watch_task))
-				queue_work(adapter->control_wq,
-					   &adapter->unshare_watch_task);
-		}
-		break;
-	case EP_PARTNER_SHARED:
-		if (hw->ep_shm_info[src_epid].rx.info->v1i.rx_status &
-		    FJES_RX_STOP_REQ_REQUEST) {
-			set_bit(src_epid, &hw->epstop_req_bit);
-			if (!work_pending(&hw->epstop_task))
-				queue_work(adapter->control_wq,
-					   &hw->epstop_task);
-		}
-		break;
-	}
-	trace_fjes_txrx_stop_req_irq_post(hw, src_epid);
-}
-
-static void fjes_stop_req_irq(struct fjes_adapter *adapter, int src_epid)
-{
-	struct fjes_hw *hw = &adapter->hw;
-	enum ep_partner_status status;
-	unsigned long flags;
-
-	set_bit(src_epid, &hw->hw_info.buffer_unshare_reserve_bit);
-
-	status = fjes_hw_get_partner_ep_status(hw, src_epid);
-	trace_fjes_stop_req_irq_pre(hw, src_epid, status);
-	switch (status) {
-	case EP_PARTNER_WAITING:
-		spin_lock_irqsave(&hw->rx_status_lock, flags);
-		hw->ep_shm_info[src_epid].tx.info->v1i.rx_status |=
-				FJES_RX_STOP_REQ_DONE;
-		spin_unlock_irqrestore(&hw->rx_status_lock, flags);
-		clear_bit(src_epid, &hw->txrx_stop_req_bit);
-		fallthrough;
-	case EP_PARTNER_UNSHARE:
-	case EP_PARTNER_COMPLETE:
-	default:
-		set_bit(src_epid, &adapter->unshare_watch_bitmask);
-		if (!work_pending(&adapter->unshare_watch_task))
-			queue_work(adapter->control_wq,
-				   &adapter->unshare_watch_task);
-		break;
-	case EP_PARTNER_SHARED:
-		set_bit(src_epid, &hw->epstop_req_bit);
-
-		if (!work_pending(&hw->epstop_task))
-			queue_work(adapter->control_wq, &hw->epstop_task);
-		break;
-	}
-	trace_fjes_stop_req_irq_post(hw, src_epid);
+
+	return ret;
 }
 
-static void fjes_update_zone_irq(struct fjes_adapter *adapter,
-				 int src_epid)
+static void fjes_tx_retry(struct net_device *netdev, unsigned int txqueue)
 {
-	struct fjes_hw *hw = &adapter->hw;
+	struct netdev_queue *queue = netdev_get_tx_queue(netdev, 0);
 
-	if (!work_pending(&hw->update_zone_task))
-		queue_work(adapter->control_wq, &hw->update_zone_task);
+	netif_tx_wake_queue(queue);
 }
 
-static irqreturn_t fjes_intr(int irq, void *data)
+static int fjes_vlan_rx_add_vid(struct net_device *netdev,
+				__be16 proto, u16 vid)
 {
-	struct fjes_adapter *adapter = data;
-	struct fjes_hw *hw = &adapter->hw;
-	irqreturn_t ret;
-	u32 icr;
-
-	icr = fjes_hw_capture_interrupt_status(hw);
+	struct fjes_adapter *adapter = netdev_priv(netdev);
+	bool ret = true;
+	int epid;
 
-	if (icr & REG_IS_MASK_IS_ASSERT) {
-		if (icr & REG_ICTL_MASK_RX_DATA) {
-			fjes_rx_irq(adapter, icr & REG_IS_MASK_EPID);
-			hw->ep_shm_info[icr & REG_IS_MASK_EPID].ep_stats
-				.recv_intr_rx += 1;
-		}
+	for (epid = 0; epid < adapter->hw.max_epid; epid++) {
+		if (epid == adapter->hw.my_epid)
+			continue;
 
-		if (icr & REG_ICTL_MASK_DEV_STOP_REQ) {
-			fjes_stop_req_irq(adapter, icr & REG_IS_MASK_EPID);
-			hw->ep_shm_info[icr & REG_IS_MASK_EPID].ep_stats
-				.recv_intr_stop += 1;
-		}
+		if (!fjes_hw_check_vlan_id(
+			&adapter->hw.ep_shm_info[epid].tx, vid))
+			ret = fjes_hw_set_vlan_id(
+				&adapter->hw.ep_shm_info[epid].tx, vid);
+	}
 
-		if (icr & REG_ICTL_MASK_TXRX_STOP_REQ) {
-			fjes_txrx_stop_req_irq(adapter, icr & REG_IS_MASK_EPID);
-			hw->ep_shm_info[icr & REG_IS_MASK_EPID].ep_stats
-				.recv_intr_unshare += 1;
-		}
+	return ret ? 0 : -ENOSPC;
+}
 
-		if (icr & REG_ICTL_MASK_TXRX_STOP_DONE)
-			fjes_hw_set_irqmask(hw,
-					    REG_ICTL_MASK_TXRX_STOP_DONE, true);
+static int fjes_vlan_rx_kill_vid(struct net_device *netdev,
+				 __be16 proto, u16 vid)
+{
+	struct fjes_adapter *adapter = netdev_priv(netdev);
+	int epid;
 
-		if (icr & REG_ICTL_MASK_INFO_UPDATE) {
-			fjes_update_zone_irq(adapter, icr & REG_IS_MASK_EPID);
-			hw->ep_shm_info[icr & REG_IS_MASK_EPID].ep_stats
-				.recv_intr_zoneupdate += 1;
-		}
+	for (epid = 0; epid < adapter->hw.max_epid; epid++) {
+		if (epid == adapter->hw.my_epid)
+			continue;
 
-		ret = IRQ_HANDLED;
-	} else {
-		ret = IRQ_NONE;
+		fjes_hw_del_vlan_id(&adapter->hw.ep_shm_info[epid].tx, vid);
 	}
 
-	return ret;
+	return 0;
+}
+
+static const struct net_device_ops fjes_netdev_ops = {
+	.ndo_open		= fjes_open,
+	.ndo_stop		= fjes_close,
+	.ndo_start_xmit		= fjes_xmit_frame,
+	.ndo_get_stats64	= fjes_get_stats64,
+	.ndo_change_mtu		= fjes_change_mtu,
+	.ndo_tx_timeout		= fjes_tx_retry,
+	.ndo_vlan_rx_add_vid	= fjes_vlan_rx_add_vid,
+	.ndo_vlan_rx_kill_vid = fjes_vlan_rx_kill_vid,
+};
+
+/* fjes_netdev_setup - netdevice initialization routine */
+static void fjes_netdev_setup(struct net_device *netdev)
+{
+	ether_setup(netdev);
+
+	netdev->watchdog_timeo = FJES_TX_RETRY_INTERVAL;
+	netdev->netdev_ops = &fjes_netdev_ops;
+	fjes_set_ethtool_ops(netdev);
+	netdev->mtu = fjes_support_mtu[3];
+	netdev->min_mtu = fjes_support_mtu[0];
+	netdev->max_mtu = fjes_support_mtu[3];
+	netdev->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
 }
 
 static int fjes_rxframe_search_exist(struct fjes_adapter *adapter,
@@ -1087,16 +954,6 @@ static void fjes_rxframe_release(struct fjes_adapter *adapter, int cur_epid)
 	fjes_hw_epbuf_rx_curpkt_drop(&adapter->hw.ep_shm_info[cur_epid].rx);
 }
 
-static void fjes_rx_irq(struct fjes_adapter *adapter, int src_epid)
-{
-	struct fjes_hw *hw = &adapter->hw;
-
-	fjes_hw_set_irqmask(hw, REG_ICTL_MASK_RX_DATA, true);
-
-	adapter->unset_rx_last = true;
-	napi_schedule(&adapter->napi);
-}
-
 static int fjes_poll(struct napi_struct *napi, int budget)
 {
 	struct fjes_adapter *adapter =
@@ -1196,182 +1053,130 @@ static int fjes_poll(struct napi_struct *napi, int budget)
 	return work_done;
 }
 
-/* fjes_probe - Device Initialization Routine */
-static int fjes_probe(struct platform_device *plat_dev)
+static int fjes_sw_init(struct fjes_adapter *adapter)
 {
-	struct fjes_adapter *adapter;
-	struct net_device *netdev;
-	struct resource *res;
-	struct fjes_hw *hw;
-	u8 addr[ETH_ALEN];
-	int err;
-
-	err = -ENOMEM;
-	netdev = alloc_netdev_mq(sizeof(struct fjes_adapter), "es%d",
-				 NET_NAME_UNKNOWN, fjes_netdev_setup,
-				 FJES_MAX_QUEUES);
-
-	if (!netdev)
-		goto err_out;
-
-	SET_NETDEV_DEV(netdev, &plat_dev->dev);
-
-	dev_set_drvdata(&plat_dev->dev, netdev);
-	adapter = netdev_priv(netdev);
-	adapter->netdev = netdev;
-	adapter->plat_dev = plat_dev;
-	hw = &adapter->hw;
-	hw->back = adapter;
-
-	/* setup the private structure */
-	err = fjes_sw_init(adapter);
-	if (err)
-		goto err_free_netdev;
+	struct net_device *netdev = adapter->netdev;
 
-	INIT_WORK(&adapter->force_close_task, fjes_force_close_task);
-	adapter->force_reset = false;
-	adapter->open_guard = false;
+	netif_napi_add(netdev, &adapter->napi, fjes_poll, 64);
 
-	adapter->txrx_wq = alloc_workqueue(DRV_NAME "/txrx", WQ_MEM_RECLAIM, 0);
-	if (unlikely(!adapter->txrx_wq)) {
-		err = -ENOMEM;
-		goto err_free_netdev;
-	}
+	return 0;
+}
 
-	adapter->control_wq = alloc_workqueue(DRV_NAME "/control",
-					      WQ_MEM_RECLAIM, 0);
-	if (unlikely(!adapter->control_wq)) {
-		err = -ENOMEM;
-		goto err_free_txrx_wq;
-	}
+static void fjes_force_close_task(struct work_struct *work)
+{
+	struct fjes_adapter *adapter = container_of(work,
+			struct fjes_adapter, force_close_task);
+	struct net_device *netdev = adapter->netdev;
 
-	INIT_WORK(&adapter->tx_stall_task, fjes_tx_stall_task);
-	INIT_WORK(&adapter->raise_intr_rxdata_task,
-		  fjes_raise_intr_rxdata_task);
-	INIT_WORK(&adapter->unshare_watch_task, fjes_watch_unshare_task);
-	adapter->unshare_watch_bitmask = 0;
+	rtnl_lock();
+	dev_close(netdev);
+	rtnl_unlock();
+}
 
-	INIT_DELAYED_WORK(&adapter->interrupt_watch_task, fjes_irq_watch_task);
-	adapter->interrupt_watch_enable = false;
+static void fjes_tx_stall_task(struct work_struct *work)
+{
+	struct fjes_adapter *adapter = container_of(work,
+			struct fjes_adapter, tx_stall_task);
+	struct net_device *netdev = adapter->netdev;
+	struct fjes_hw *hw = &adapter->hw;
+	int all_queue_available, sendable;
+	enum ep_partner_status pstatus;
+	int max_epid, my_epid, epid;
+	union ep_buffer_info *info;
+	int i;
 
-	res = platform_get_resource(plat_dev, IORESOURCE_MEM, 0);
-	if (!res) {
-		err = -EINVAL;
-		goto err_free_control_wq;
-	}
-	hw->hw_res.start = res->start;
-	hw->hw_res.size = resource_size(res);
-	hw->hw_res.irq = platform_get_irq(plat_dev, 0);
-	if (hw->hw_res.irq < 0) {
-		err = hw->hw_res.irq;
-		goto err_free_control_wq;
+	if (((long)jiffies -
+		dev_trans_start(netdev)) > FJES_TX_TX_STALL_TIMEOUT) {
+		netif_wake_queue(netdev);
+		return;
 	}
 
-	err = fjes_hw_init(&adapter->hw);
-	if (err)
-		goto err_free_control_wq;
-
-	/* setup MAC address (02:00:00:00:00:[epid])*/
-	addr[0] = 2;
-	addr[1] = 0;
-	addr[2] = 0;
-	addr[3] = 0;
-	addr[4] = 0;
-	addr[5] = hw->my_epid; /* EPID */
-	eth_hw_addr_set(netdev, addr);
-
-	err = register_netdev(netdev);
-	if (err)
-		goto err_hw_exit;
-
-	netif_carrier_off(netdev);
-
-	fjes_dbg_adapter_init(adapter);
-
-	return 0;
-
-err_hw_exit:
-	fjes_hw_exit(&adapter->hw);
-err_free_control_wq:
-	destroy_workqueue(adapter->control_wq);
-err_free_txrx_wq:
-	destroy_workqueue(adapter->txrx_wq);
-err_free_netdev:
-	free_netdev(netdev);
-err_out:
-	return err;
-}
+	my_epid = hw->my_epid;
+	max_epid = hw->max_epid;
 
-/* fjes_remove - Device Removal Routine */
-static int fjes_remove(struct platform_device *plat_dev)
-{
-	struct net_device *netdev = dev_get_drvdata(&plat_dev->dev);
-	struct fjes_adapter *adapter = netdev_priv(netdev);
-	struct fjes_hw *hw = &adapter->hw;
+	for (i = 0; i < 5; i++) {
+		all_queue_available = 1;
 
-	fjes_dbg_adapter_exit(adapter);
+		for (epid = 0; epid < max_epid; epid++) {
+			if (my_epid == epid)
+				continue;
 
-	cancel_delayed_work_sync(&adapter->interrupt_watch_task);
-	cancel_work_sync(&adapter->unshare_watch_task);
-	cancel_work_sync(&adapter->raise_intr_rxdata_task);
-	cancel_work_sync(&adapter->tx_stall_task);
-	if (adapter->control_wq)
-		destroy_workqueue(adapter->control_wq);
-	if (adapter->txrx_wq)
-		destroy_workqueue(adapter->txrx_wq);
+			pstatus = fjes_hw_get_partner_ep_status(hw, epid);
+			sendable = (pstatus == EP_PARTNER_SHARED);
+			if (!sendable)
+				continue;
 
-	unregister_netdev(netdev);
+			info = adapter->hw.ep_shm_info[epid].tx.info;
 
-	fjes_hw_exit(hw);
+			if (!(info->v1i.rx_status & FJES_RX_MTU_CHANGING_DONE))
+				return;
 
-	netif_napi_del(&adapter->napi);
+			if (EP_RING_FULL(info->v1i.head, info->v1i.tail,
+					 info->v1i.count_max)) {
+				all_queue_available = 0;
+				break;
+			}
+		}
 
-	free_netdev(netdev);
+		if (all_queue_available) {
+			netif_wake_queue(netdev);
+			return;
+		}
+	}
 
-	return 0;
+	usleep_range(50, 100);
+
+	queue_work(adapter->txrx_wq, &adapter->tx_stall_task);
 }
 
-static int fjes_sw_init(struct fjes_adapter *adapter)
+static void fjes_raise_intr_rxdata_task(struct work_struct *work)
 {
-	struct net_device *netdev = adapter->netdev;
-
-	netif_napi_add(netdev, &adapter->napi, fjes_poll, 64);
+	struct fjes_adapter *adapter = container_of(work,
+			struct fjes_adapter, raise_intr_rxdata_task);
+	struct fjes_hw *hw = &adapter->hw;
+	enum ep_partner_status pstatus;
+	int max_epid, my_epid, epid;
 
-	return 0;
-}
+	my_epid = hw->my_epid;
+	max_epid = hw->max_epid;
 
-/* fjes_netdev_setup - netdevice initialization routine */
-static void fjes_netdev_setup(struct net_device *netdev)
-{
-	ether_setup(netdev);
+	for (epid = 0; epid < max_epid; epid++)
+		hw->ep_shm_info[epid].tx_status_work = 0;
 
-	netdev->watchdog_timeo = FJES_TX_RETRY_INTERVAL;
-	netdev->netdev_ops = &fjes_netdev_ops;
-	fjes_set_ethtool_ops(netdev);
-	netdev->mtu = fjes_support_mtu[3];
-	netdev->min_mtu = fjes_support_mtu[0];
-	netdev->max_mtu = fjes_support_mtu[3];
-	netdev->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
-}
+	for (epid = 0; epid < max_epid; epid++) {
+		if (epid == my_epid)
+			continue;
 
-static void fjes_irq_watch_task(struct work_struct *work)
-{
-	struct fjes_adapter *adapter = container_of(to_delayed_work(work),
-			struct fjes_adapter, interrupt_watch_task);
+		pstatus = fjes_hw_get_partner_ep_status(hw, epid);
+		if (pstatus == EP_PARTNER_SHARED) {
+			hw->ep_shm_info[epid].tx_status_work =
+				hw->ep_shm_info[epid].tx.info->v1i.tx_status;
 
-	local_irq_disable();
-	fjes_intr(adapter->hw.hw_res.irq, adapter);
-	local_irq_enable();
+			if (hw->ep_shm_info[epid].tx_status_work ==
+				FJES_TX_DELAY_SEND_PENDING) {
+				hw->ep_shm_info[epid].tx.info->v1i.tx_status =
+					FJES_TX_DELAY_SEND_NONE;
+			}
+		}
+	}
 
-	if (fjes_rxframe_search_exist(adapter, 0) >= 0)
-		napi_schedule(&adapter->napi);
+	for (epid = 0; epid < max_epid; epid++) {
+		if (epid == my_epid)
+			continue;
 
-	if (adapter->interrupt_watch_enable) {
-		if (!delayed_work_pending(&adapter->interrupt_watch_task))
-			queue_delayed_work(adapter->control_wq,
-					   &adapter->interrupt_watch_task,
-					   FJES_IRQ_WATCH_DELAY);
+		pstatus = fjes_hw_get_partner_ep_status(hw, epid);
+		if ((hw->ep_shm_info[epid].tx_status_work ==
+		     FJES_TX_DELAY_SEND_PENDING) &&
+		    (pstatus == EP_PARTNER_SHARED) &&
+		    !(hw->ep_shm_info[epid].rx.info->v1i.rx_status &
+		      FJES_RX_POLL_WORK)) {
+			fjes_hw_raise_interrupt(hw, epid,
+						REG_ICTL_MASK_RX_DATA);
+			hw->ep_shm_info[epid].ep_stats.send_intr_rx += 1;
+		}
 	}
+
+	usleep_range(500, 1000);
 }
 
 static void fjes_watch_unshare_task(struct work_struct *work)
@@ -1508,6 +1313,169 @@ static void fjes_watch_unshare_task(struct work_struct *work)
 	}
 }
 
+static void fjes_irq_watch_task(struct work_struct *work)
+{
+	struct fjes_adapter *adapter = container_of(to_delayed_work(work),
+			struct fjes_adapter, interrupt_watch_task);
+
+	local_irq_disable();
+	fjes_intr(adapter->hw.hw_res.irq, adapter);
+	local_irq_enable();
+
+	if (fjes_rxframe_search_exist(adapter, 0) >= 0)
+		napi_schedule(&adapter->napi);
+
+	if (adapter->interrupt_watch_enable) {
+		if (!delayed_work_pending(&adapter->interrupt_watch_task))
+			queue_delayed_work(adapter->control_wq,
+					   &adapter->interrupt_watch_task,
+					   FJES_IRQ_WATCH_DELAY);
+	}
+}
+
+/* fjes_probe - Device Initialization Routine */
+static int fjes_probe(struct platform_device *plat_dev)
+{
+	struct fjes_adapter *adapter;
+	struct net_device *netdev;
+	struct resource *res;
+	struct fjes_hw *hw;
+	u8 addr[ETH_ALEN];
+	int err;
+
+	err = -ENOMEM;
+	netdev = alloc_netdev_mq(sizeof(struct fjes_adapter), "es%d",
+				 NET_NAME_UNKNOWN, fjes_netdev_setup,
+				 FJES_MAX_QUEUES);
+
+	if (!netdev)
+		goto err_out;
+
+	SET_NETDEV_DEV(netdev, &plat_dev->dev);
+
+	dev_set_drvdata(&plat_dev->dev, netdev);
+	adapter = netdev_priv(netdev);
+	adapter->netdev = netdev;
+	adapter->plat_dev = plat_dev;
+	hw = &adapter->hw;
+	hw->back = adapter;
+
+	/* setup the private structure */
+	err = fjes_sw_init(adapter);
+	if (err)
+		goto err_free_netdev;
+
+	INIT_WORK(&adapter->force_close_task, fjes_force_close_task);
+	adapter->force_reset = false;
+	adapter->open_guard = false;
+
+	adapter->txrx_wq = alloc_workqueue(DRV_NAME "/txrx", WQ_MEM_RECLAIM, 0);
+	if (unlikely(!adapter->txrx_wq)) {
+		err = -ENOMEM;
+		goto err_free_netdev;
+	}
+
+	adapter->control_wq = alloc_workqueue(DRV_NAME "/control",
+					      WQ_MEM_RECLAIM, 0);
+	if (unlikely(!adapter->control_wq)) {
+		err = -ENOMEM;
+		goto err_free_txrx_wq;
+	}
+
+	INIT_WORK(&adapter->tx_stall_task, fjes_tx_stall_task);
+	INIT_WORK(&adapter->raise_intr_rxdata_task,
+		  fjes_raise_intr_rxdata_task);
+	INIT_WORK(&adapter->unshare_watch_task, fjes_watch_unshare_task);
+	adapter->unshare_watch_bitmask = 0;
+
+	INIT_DELAYED_WORK(&adapter->interrupt_watch_task, fjes_irq_watch_task);
+	adapter->interrupt_watch_enable = false;
+
+	res = platform_get_resource(plat_dev, IORESOURCE_MEM, 0);
+	if (!res) {
+		err = -EINVAL;
+		goto err_free_control_wq;
+	}
+	hw->hw_res.start = res->start;
+	hw->hw_res.size = resource_size(res);
+	hw->hw_res.irq = platform_get_irq(plat_dev, 0);
+	if (hw->hw_res.irq < 0) {
+		err = hw->hw_res.irq;
+		goto err_free_control_wq;
+	}
+
+	err = fjes_hw_init(&adapter->hw);
+	if (err)
+		goto err_free_control_wq;
+
+	/* setup MAC address (02:00:00:00:00:[epid])*/
+	addr[0] = 2;
+	addr[1] = 0;
+	addr[2] = 0;
+	addr[3] = 0;
+	addr[4] = 0;
+	addr[5] = hw->my_epid; /* EPID */
+	eth_hw_addr_set(netdev, addr);
+
+	err = register_netdev(netdev);
+	if (err)
+		goto err_hw_exit;
+
+	netif_carrier_off(netdev);
+
+	fjes_dbg_adapter_init(adapter);
+
+	return 0;
+
+err_hw_exit:
+	fjes_hw_exit(&adapter->hw);
+err_free_control_wq:
+	destroy_workqueue(adapter->control_wq);
+err_free_txrx_wq:
+	destroy_workqueue(adapter->txrx_wq);
+err_free_netdev:
+	free_netdev(netdev);
+err_out:
+	return err;
+}
+
+/* fjes_remove - Device Removal Routine */
+static int fjes_remove(struct platform_device *plat_dev)
+{
+	struct net_device *netdev = dev_get_drvdata(&plat_dev->dev);
+	struct fjes_adapter *adapter = netdev_priv(netdev);
+	struct fjes_hw *hw = &adapter->hw;
+
+	fjes_dbg_adapter_exit(adapter);
+
+	cancel_delayed_work_sync(&adapter->interrupt_watch_task);
+	cancel_work_sync(&adapter->unshare_watch_task);
+	cancel_work_sync(&adapter->raise_intr_rxdata_task);
+	cancel_work_sync(&adapter->tx_stall_task);
+	if (adapter->control_wq)
+		destroy_workqueue(adapter->control_wq);
+	if (adapter->txrx_wq)
+		destroy_workqueue(adapter->txrx_wq);
+
+	unregister_netdev(netdev);
+
+	fjes_hw_exit(hw);
+
+	netif_napi_del(&adapter->napi);
+
+	free_netdev(netdev);
+
+	return 0;
+}
+
+static struct platform_driver fjes_driver = {
+	.driver = {
+		.name = DRV_NAME,
+	},
+	.probe = fjes_probe,
+	.remove = fjes_remove,
+};
+
 static acpi_status
 acpi_find_extended_socket_device(acpi_handle obj_handle, u32 level,
 				 void *context, void **return_value)
-- 
2.37.2

