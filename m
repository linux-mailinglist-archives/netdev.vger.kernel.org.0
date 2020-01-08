Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC7BB13474F
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 17:12:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729060AbgAHQMP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 11:12:15 -0500
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:49516 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726186AbgAHQMO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 11:12:14 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us5.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 979688008D;
        Wed,  8 Jan 2020 16:12:12 +0000 (UTC)
Received: from amm-opti7060.uk.solarflarecom.com (10.17.20.147) by
 ukex01.SolarFlarecom.com (10.17.10.4) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Wed, 8 Jan 2020 16:12:06 +0000
From:   "Alex Maftei (amaftei)" <amaftei@solarflare.com>
Subject: [PATCH net-next 07/14] sfc: move struct init and fini code
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>
CC:     <linux-net-drivers@solarflare.com>, <scrum-linux@solarflare.com>
References: <a0cfb828-b98e-3a63-15d9-592675e81b5f@solarflare.com>
Message-ID: <bed426b2-d149-f83c-1e69-a061216546e0@solarflare.com>
Date:   Wed, 8 Jan 2020 16:12:04 +0000
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
X-TM-AS-Result: No-11.229400-8.000000-10
X-TMASE-MatchedRID: 4wYMBKCGNduRehYFOG64KFD5LQ3Tl9H7b1d/zpzApVpJfyfUaPjAAao6
        hcXA9s6k7JomkRyzJ+a8qDSHGfAtQQOHPc/ffp++qJSK+HSPY+/pVMb1xnESMnAal2A1DQmscij
        MZrr2iZ2t2gtuWr1LmmbpUJbxMF84DD20H1S9BwiuG6vp8tkx52KA1HVKZBuTSMg2Oe/b8Ew+8d
        s1xt/z+Apr4p4pYh/KGd2UI8O3xotYQsNwrAY7btB/IoRhBzVHDmTV5r5yWnriYlKox3ryNMMyc
        r0b1vBAuklxe7zEIvu/yiQR3O/7eA719kpOO37PQpQ0V8cen8ruo8ooMQqOsnuUPOHxn4SGUUC/
        RVa7+PnQmeWkZUje+7x7ItMx/irKEv/Xa9jWN3dH+PTjR9EWkg/o5bNHEsCTKBVvFbsUM5VuNRG
        oPKGToc7hI1PRlDUz+yQTaI9uX4oE7MuQrZP2o0Wj1375/pHqUkCyfz2KH3hm2eQt5E7eChadJ9
        rAyuvsM8FOMjG14/V6p3UUV82FSQ11Y9MzIaU2Pja3w1ExF8QJeGz38vkhr//rgj9ncWz9z0dbn
        dAEvQA5WWY+qEsr4BYNCJqEaMjLwAswe0QGYTkPe5gzF3TVt+qhuTPUDQDtq4++j0vqJogysnXx
        UIjx+x+kJIjijNkRGlFRWBGJJQUHqGm/F4f6TzCMW7zNwFaIrFP4l9ANsI9E6qvV2uOcuZt+dMP
        P5rY5op2eWgzdZT/LaciFEFJ+KBG2YNqApJiYGhRbJzT/dqPLRD51bz5RZAVQtPavvwzPp/lgQk
        7Kv5Aj6N0N/yu0R3iL3ziUctCZfMalxiFMN0qrm7DrUlmNkJGTpe1iiCJqb5ic6rRyh49t1O49r
        1VEa8RB0bsfrpPIXzYxeQR1DvvTvPjpYePVr1sslRQGFScJuPCJQF31uaXsuZvlU9OOcUrJT6Hj
        J3zT
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--11.229400-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25154.003
X-MDID: 1578499933-w1N5bpfjBP1T
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The hardware monitor code and the reset work queue code were also
moved, with supporting macros and parameters, because they are assigned
to function pointers in the struct.
Small code styling fixes included.

Signed-off-by: Alexandru-Mihai Maftei <amaftei@solarflare.com>
---
 drivers/net/ethernet/sfc/efx.c        | 375 +----------------------
 drivers/net/ethernet/sfc/efx_common.c | 411 ++++++++++++++++++++++++++
 2 files changed, 415 insertions(+), 371 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 40d1e8ef672d..a1af42dde450 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -43,56 +43,6 @@
  **************************************************************************
  */
 
-/* Loopback mode names (see LOOPBACK_MODE()) */
-const unsigned int efx_loopback_mode_max = LOOPBACK_MAX;
-const char *const efx_loopback_mode_names[] = {
-	[LOOPBACK_NONE]		= "NONE",
-	[LOOPBACK_DATA]		= "DATAPATH",
-	[LOOPBACK_GMAC]		= "GMAC",
-	[LOOPBACK_XGMII]	= "XGMII",
-	[LOOPBACK_XGXS]		= "XGXS",
-	[LOOPBACK_XAUI]		= "XAUI",
-	[LOOPBACK_GMII]		= "GMII",
-	[LOOPBACK_SGMII]	= "SGMII",
-	[LOOPBACK_XGBR]		= "XGBR",
-	[LOOPBACK_XFI]		= "XFI",
-	[LOOPBACK_XAUI_FAR]	= "XAUI_FAR",
-	[LOOPBACK_GMII_FAR]	= "GMII_FAR",
-	[LOOPBACK_SGMII_FAR]	= "SGMII_FAR",
-	[LOOPBACK_XFI_FAR]	= "XFI_FAR",
-	[LOOPBACK_GPHY]		= "GPHY",
-	[LOOPBACK_PHYXS]	= "PHYXS",
-	[LOOPBACK_PCS]		= "PCS",
-	[LOOPBACK_PMAPMD]	= "PMA/PMD",
-	[LOOPBACK_XPORT]	= "XPORT",
-	[LOOPBACK_XGMII_WS]	= "XGMII_WS",
-	[LOOPBACK_XAUI_WS]	= "XAUI_WS",
-	[LOOPBACK_XAUI_WS_FAR]  = "XAUI_WS_FAR",
-	[LOOPBACK_XAUI_WS_NEAR] = "XAUI_WS_NEAR",
-	[LOOPBACK_GMII_WS]	= "GMII_WS",
-	[LOOPBACK_XFI_WS]	= "XFI_WS",
-	[LOOPBACK_XFI_WS_FAR]	= "XFI_WS_FAR",
-	[LOOPBACK_PHYXS_WS]	= "PHYXS_WS",
-};
-
-const unsigned int efx_reset_type_max = RESET_TYPE_MAX;
-const char *const efx_reset_type_names[] = {
-	[RESET_TYPE_INVISIBLE]          = "INVISIBLE",
-	[RESET_TYPE_ALL]                = "ALL",
-	[RESET_TYPE_RECOVER_OR_ALL]     = "RECOVER_OR_ALL",
-	[RESET_TYPE_WORLD]              = "WORLD",
-	[RESET_TYPE_RECOVER_OR_DISABLE] = "RECOVER_OR_DISABLE",
-	[RESET_TYPE_DATAPATH]           = "DATAPATH",
-	[RESET_TYPE_MC_BIST]		= "MC_BIST",
-	[RESET_TYPE_DISABLE]            = "DISABLE",
-	[RESET_TYPE_TX_WATCHDOG]        = "TX_WATCHDOG",
-	[RESET_TYPE_INT_ERROR]          = "INT_ERROR",
-	[RESET_TYPE_DMA_ERROR]          = "DMA_ERROR",
-	[RESET_TYPE_TX_SKIP]            = "TX_SKIP",
-	[RESET_TYPE_MC_FAILURE]         = "MC_FAILURE",
-	[RESET_TYPE_MCDI_TIMEOUT]	= "MCDI_TIMEOUT (FLR)",
-};
-
 /* UDP tunnel type names */
 static const char *const efx_udp_tunnel_type_names[] = {
 	[TUNNEL_ENCAP_UDP_PORT_ENTRY_VXLAN] = "vxlan",
@@ -108,12 +58,6 @@ void efx_get_udp_tunnel_type_name(u16 type, char *buf, size_t buflen)
 		snprintf(buf, buflen, "type %d", type);
 }
 
-/* How often and how many times to poll for a reset while waiting for a
- * BIST that another function started to complete.
- */
-#define BIST_WAIT_DELAY_MS	100
-#define BIST_WAIT_DELAY_COUNT	100
-
 /**************************************************************************
  *
  * Configurable values
@@ -138,16 +82,6 @@ MODULE_PARM_DESC(efx_separate_tx_channels,
  */
 static int napi_weight = 64;
 
-/* This is the time (in jiffies) between invocations of the hardware
- * monitor.
- * On Falcon-based NICs, this will:
- * - Check the on-board hardware monitor;
- * - Poll the link state and reconfigure the hardware as necessary.
- * On Siena-based NICs for power systems with EEH support, this will give EEH a
- * chance to start.
- */
-static unsigned int efx_monitor_interval = 1 * HZ;
-
 /* Initial interrupt moderation settings.  They can be modified after
  * module load with ethtool.
  *
@@ -830,19 +764,6 @@ void efx_link_set_wanted_fc(struct efx_nic *efx, u8 wanted_fc)
 
 static void efx_fini_port(struct efx_nic *efx);
 
-/* Asynchronous work item for changing MAC promiscuity and multicast
- * hash.  Avoid a drain/rx_ingress enable by reconfiguring the current
- * MAC directly. */
-static void efx_mac_work(struct work_struct *data)
-{
-	struct efx_nic *efx = container_of(data, struct efx_nic, mac_work);
-
-	mutex_lock(&efx->mac_lock);
-	if (efx->port_enabled)
-		efx_mac_reconfigure(efx);
-	mutex_unlock(&efx->mac_lock);
-}
-
 static int efx_probe_port(struct efx_nic *efx)
 {
 	int rc;
@@ -994,94 +915,6 @@ static void efx_dissociate(struct efx_nic *efx)
 	}
 }
 
-/* This configures the PCI device to enable I/O and DMA. */
-int efx_init_io(struct efx_nic *efx, int bar, dma_addr_t dma_mask,
-		unsigned int mem_map_size)
-{
-	struct pci_dev *pci_dev = efx->pci_dev;
-	int rc;
-
-	netif_dbg(efx, probe, efx->net_dev, "initialising I/O\n");
-
-	rc = pci_enable_device(pci_dev);
-	if (rc) {
-		netif_err(efx, probe, efx->net_dev,
-			  "failed to enable PCI device\n");
-		goto fail1;
-	}
-
-	pci_set_master(pci_dev);
-
-	/* Set the PCI DMA mask.  Try all possibilities from our genuine mask
-	 * down to 32 bits, because some architectures will allow 40 bit
-	 * masks event though they reject 46 bit masks.
-	 */
-	while (dma_mask > 0x7fffffffUL) {
-		rc = dma_set_mask_and_coherent(&pci_dev->dev, dma_mask);
-		if (rc == 0)
-			break;
-		dma_mask >>= 1;
-	}
-	if (rc) {
-		netif_err(efx, probe, efx->net_dev,
-			  "could not find a suitable DMA mask\n");
-		goto fail2;
-	}
-	netif_dbg(efx, probe, efx->net_dev,
-		  "using DMA mask %llx\n", (unsigned long long) dma_mask);
-
-	efx->membase_phys = pci_resource_start(efx->pci_dev, bar);
-	rc = pci_request_region(pci_dev, bar, "sfc");
-	if (rc) {
-		netif_err(efx, probe, efx->net_dev,
-			  "request for memory BAR failed\n");
-		rc = -EIO;
-		goto fail3;
-	}
-	efx->membase = ioremap_nocache(efx->membase_phys, mem_map_size);
-	if (!efx->membase) {
-		netif_err(efx, probe, efx->net_dev,
-			  "could not map memory BAR at %llx+%x\n",
-			  (unsigned long long)efx->membase_phys, mem_map_size);
-		rc = -ENOMEM;
-		goto fail4;
-	}
-	netif_dbg(efx, probe, efx->net_dev,
-		  "memory BAR at %llx+%x (virtual %p)\n",
-		  (unsigned long long)efx->membase_phys, mem_map_size,
-		  efx->membase);
-
-	return 0;
-
- fail4:
-	pci_release_region(efx->pci_dev, bar);
- fail3:
-	efx->membase_phys = 0;
- fail2:
-	pci_disable_device(efx->pci_dev);
- fail1:
-	return rc;
-}
-
-void efx_fini_io(struct efx_nic *efx, int bar)
-{
-	netif_dbg(efx, drv, efx->net_dev, "shutting down I/O\n");
-
-	if (efx->membase) {
-		iounmap(efx->membase);
-		efx->membase = NULL;
-	}
-
-	if (efx->membase_phys) {
-		pci_release_region(efx->pci_dev, bar);
-		efx->membase_phys = 0;
-	}
-
-	/* Don't disable bus-mastering if VFs are assigned */
-	if (!pci_vfs_assigned(efx->pci_dev))
-		pci_disable_device(efx->pci_dev);
-}
-
 void efx_set_default_rx_indir_table(struct efx_nic *efx,
 				    struct efx_rss_context *ctx)
 {
@@ -1855,43 +1688,6 @@ void efx_get_irq_moderation(struct efx_nic *efx, unsigned int *tx_usecs,
 	}
 }
 
-/**************************************************************************
- *
- * Hardware monitor
- *
- **************************************************************************/
-
-/* Run periodically off the general workqueue */
-static void efx_monitor(struct work_struct *data)
-{
-	struct efx_nic *efx = container_of(data, struct efx_nic,
-					   monitor_work.work);
-
-	netif_vdbg(efx, timer, efx->net_dev,
-		   "hardware monitor executing on CPU %d\n",
-		   raw_smp_processor_id());
-	BUG_ON(efx->type->monitor == NULL);
-
-	/* If the mac_lock is already held then it is likely a port
-	 * reconfiguration is already in place, which will likely do
-	 * most of the work of monitor() anyway. */
-	if (mutex_trylock(&efx->mac_lock)) {
-		if (efx->port_enabled)
-			efx->type->monitor(efx);
-		mutex_unlock(&efx->mac_lock);
-	}
-
-	queue_delayed_work(efx->workqueue, &efx->monitor_work,
-			   efx_monitor_interval);
-}
-
-void efx_start_monitor(struct efx_nic *efx)
-{
-	if (efx->type->monitor)
-		queue_delayed_work(efx->workqueue, &efx->monitor_work,
-				   efx_monitor_interval);
-}
-
 /**************************************************************************
  *
  * ioctls
@@ -2477,65 +2273,6 @@ static void efx_unregister_netdev(struct efx_nic *efx)
 	}
 }
 
-/**************************************************************************
- *
- * Device reset and suspend
- *
- **************************************************************************/
-
-static void efx_wait_for_bist_end(struct efx_nic *efx)
-{
-	int i;
-
-	for (i = 0; i < BIST_WAIT_DELAY_COUNT; ++i) {
-		if (efx_mcdi_poll_reboot(efx))
-			goto out;
-		msleep(BIST_WAIT_DELAY_MS);
-	}
-
-	netif_err(efx, drv, efx->net_dev, "Warning: No MC reboot after BIST mode\n");
-out:
-	/* Either way unset the BIST flag. If we found no reboot we probably
-	 * won't recover, but we should try.
-	 */
-	efx->mc_bist_for_other_fn = false;
-}
-
-/* The worker thread exists so that code that cannot sleep can
- * schedule a reset for later.
- */
-static void efx_reset_work(struct work_struct *data)
-{
-	struct efx_nic *efx = container_of(data, struct efx_nic, reset_work);
-	unsigned long pending;
-	enum reset_type method;
-
-	pending = READ_ONCE(efx->reset_pending);
-	method = fls(pending) - 1;
-
-	if (method == RESET_TYPE_MC_BIST)
-		efx_wait_for_bist_end(efx);
-
-	if ((method == RESET_TYPE_RECOVER_OR_DISABLE ||
-	     method == RESET_TYPE_RECOVER_OR_ALL) &&
-	    efx_try_recovery(efx))
-		return;
-
-	if (!pending)
-		return;
-
-	rtnl_lock();
-
-	/* We checked the state in efx_schedule_reset() but it may
-	 * have changed by now.  Now that we have the RTNL lock,
-	 * it cannot change again.
-	 */
-	if (efx->state == STATE_READY)
-		(void)efx_reset(efx, method);
-
-	rtnl_unlock();
-}
-
 /**************************************************************************
  *
  * List of NICs we support
@@ -2567,93 +2304,20 @@ static const struct pci_device_id efx_pci_table[] = {
 	{0}			/* end of list */
 };
 
-/**************************************************************************
- *
- * Dummy PHY/MAC operations
- *
- * Can be used for some unimplemented operations
- * Needed so all function pointers are valid and do not have to be tested
- * before use
- *
- **************************************************************************/
-int efx_port_dummy_op_int(struct efx_nic *efx)
-{
-	return 0;
-}
-void efx_port_dummy_op_void(struct efx_nic *efx) {}
-
-static bool efx_port_dummy_op_poll(struct efx_nic *efx)
-{
-	return false;
-}
-
-static const struct efx_phy_operations efx_dummy_phy_operations = {
-	.init		 = efx_port_dummy_op_int,
-	.reconfigure	 = efx_port_dummy_op_int,
-	.poll		 = efx_port_dummy_op_poll,
-	.fini		 = efx_port_dummy_op_void,
-};
-
 /**************************************************************************
  *
  * Data housekeeping
  *
  **************************************************************************/
 
-/* This zeroes out and then fills in the invariants in a struct
- * efx_nic (including all sub-structures).
- */
-int efx_init_struct(struct efx_nic *efx, struct pci_dev *pci_dev,
-		    struct net_device *net_dev)
+int efx_init_channels(struct efx_nic *efx)
 {
-	int rc = -ENOMEM, i;
-
-	/* Initialise common structures */
-	INIT_LIST_HEAD(&efx->node);
-	INIT_LIST_HEAD(&efx->secondary_list);
-	spin_lock_init(&efx->biu_lock);
-#ifdef CONFIG_SFC_MTD
-	INIT_LIST_HEAD(&efx->mtd_list);
-#endif
-	INIT_WORK(&efx->reset_work, efx_reset_work);
-	INIT_DELAYED_WORK(&efx->monitor_work, efx_monitor);
-	INIT_DELAYED_WORK(&efx->selftest_work, efx_selftest_async_work);
-	efx->pci_dev = pci_dev;
-	efx->msg_enable = debug;
-	efx->state = STATE_UNINIT;
-	strlcpy(efx->name, pci_name(pci_dev), sizeof(efx->name));
-
-	efx->net_dev = net_dev;
-	efx->rx_prefix_size = efx->type->rx_prefix_size;
-	efx->rx_ip_align =
-		NET_IP_ALIGN ? (efx->rx_prefix_size + NET_IP_ALIGN) % 4 : 0;
-	efx->rx_packet_hash_offset =
-		efx->type->rx_hash_offset - efx->type->rx_prefix_size;
-	efx->rx_packet_ts_offset =
-		efx->type->rx_ts_offset - efx->type->rx_prefix_size;
-	INIT_LIST_HEAD(&efx->rss_context.list);
-	mutex_init(&efx->rss_lock);
-	spin_lock_init(&efx->stats_lock);
-	efx->vi_stride = EFX_DEFAULT_VI_STRIDE;
-	efx->num_mac_stats = MC_CMD_MAC_NSTATS;
-	BUILD_BUG_ON(MC_CMD_MAC_NSTATS - 1 != MC_CMD_MAC_GENERATION_END);
-	mutex_init(&efx->mac_lock);
-#ifdef CONFIG_RFS_ACCEL
-	mutex_init(&efx->rps_mutex);
-	spin_lock_init(&efx->rps_hash_lock);
-	/* Failure to allocate is not fatal, but may degrade ARFS performance */
-	efx->rps_hash_table = kcalloc(EFX_ARFS_HASH_TABLE_SIZE,
-				      sizeof(*efx->rps_hash_table), GFP_KERNEL);
-#endif
-	efx->phy_op = &efx_dummy_phy_operations;
-	efx->mdio.dev = net_dev;
-	INIT_WORK(&efx->mac_work, efx_mac_work);
-	init_waitqueue_head(&efx->flush_wq);
+	unsigned int i;
 
 	for (i = 0; i < EFX_MAX_CHANNELS; i++) {
 		efx->channel[i] = efx_alloc_channel(efx, i, NULL);
 		if (!efx->channel[i])
-			goto fail;
+			return -ENOMEM;
 		efx->msi_context[i].efx = efx;
 		efx->msi_context[i].index = i;
 	}
@@ -2661,45 +2325,14 @@ int efx_init_struct(struct efx_nic *efx, struct pci_dev *pci_dev,
 	/* Higher numbered interrupt modes are less capable! */
 	if (WARN_ON_ONCE(efx->type->max_interrupt_mode >
 			 efx->type->min_interrupt_mode)) {
-		rc = -EIO;
-		goto fail;
+		return -EIO;
 	}
 	efx->interrupt_mode = max(efx->type->max_interrupt_mode,
 				  interrupt_mode);
 	efx->interrupt_mode = min(efx->type->min_interrupt_mode,
 				  interrupt_mode);
 
-	/* Would be good to use the net_dev name, but we're too early */
-	snprintf(efx->workqueue_name, sizeof(efx->workqueue_name), "sfc%s",
-		 pci_name(pci_dev));
-	efx->workqueue = create_singlethread_workqueue(efx->workqueue_name);
-	if (!efx->workqueue)
-		goto fail;
-
 	return 0;
-
-fail:
-	efx_fini_struct(efx);
-	return rc;
-}
-
-void efx_fini_struct(struct efx_nic *efx)
-{
-	int i;
-
-#ifdef CONFIG_RFS_ACCEL
-	kfree(efx->rps_hash_table);
-#endif
-
-	for (i = 0; i < EFX_MAX_CHANNELS; i++)
-		kfree(efx->channel[i]);
-
-	kfree(efx->vpd_sn);
-
-	if (efx->workqueue) {
-		destroy_workqueue(efx->workqueue);
-		efx->workqueue = NULL;
-	}
 }
 
 void efx_update_sw_stats(struct efx_nic *efx, u64 *stats)
diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index 813ebdda50f6..f1c487de3f04 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -22,6 +22,85 @@
 #include "io.h"
 #include "mcdi_pcol.h"
 
+static unsigned int debug = (NETIF_MSG_DRV | NETIF_MSG_PROBE |
+			     NETIF_MSG_LINK | NETIF_MSG_IFDOWN |
+			     NETIF_MSG_IFUP | NETIF_MSG_RX_ERR |
+			     NETIF_MSG_TX_ERR | NETIF_MSG_HW);
+module_param(debug, uint, 0);
+MODULE_PARM_DESC(debug, "Bitmapped debugging message enable value");
+
+/* This is the time (in jiffies) between invocations of the hardware
+ * monitor.
+ * On Falcon-based NICs, this will:
+ * - Check the on-board hardware monitor;
+ * - Poll the link state and reconfigure the hardware as necessary.
+ * On Siena-based NICs for power systems with EEH support, this will give EEH a
+ * chance to start.
+ */
+static unsigned int efx_monitor_interval = 1 * HZ;
+
+/* How often and how many times to poll for a reset while waiting for a
+ * BIST that another function started to complete.
+ */
+#define BIST_WAIT_DELAY_MS	100
+#define BIST_WAIT_DELAY_COUNT	100
+
+/* Default stats update time */
+#define STATS_PERIOD_MS_DEFAULT 1000
+
+const unsigned int efx_reset_type_max = RESET_TYPE_MAX;
+const char *const efx_reset_type_names[] = {
+	[RESET_TYPE_INVISIBLE]          = "INVISIBLE",
+	[RESET_TYPE_ALL]                = "ALL",
+	[RESET_TYPE_RECOVER_OR_ALL]     = "RECOVER_OR_ALL",
+	[RESET_TYPE_WORLD]              = "WORLD",
+	[RESET_TYPE_RECOVER_OR_DISABLE] = "RECOVER_OR_DISABLE",
+	[RESET_TYPE_DATAPATH]           = "DATAPATH",
+	[RESET_TYPE_MC_BIST]		= "MC_BIST",
+	[RESET_TYPE_DISABLE]            = "DISABLE",
+	[RESET_TYPE_TX_WATCHDOG]        = "TX_WATCHDOG",
+	[RESET_TYPE_INT_ERROR]          = "INT_ERROR",
+	[RESET_TYPE_DMA_ERROR]          = "DMA_ERROR",
+	[RESET_TYPE_TX_SKIP]            = "TX_SKIP",
+	[RESET_TYPE_MC_FAILURE]         = "MC_FAILURE",
+	[RESET_TYPE_MCDI_TIMEOUT]	= "MCDI_TIMEOUT (FLR)",
+};
+
+#define RESET_TYPE(type) \
+	STRING_TABLE_LOOKUP(type, efx_reset_type)
+
+/* Loopback mode names (see LOOPBACK_MODE()) */
+const unsigned int efx_loopback_mode_max = LOOPBACK_MAX;
+const char *const efx_loopback_mode_names[] = {
+	[LOOPBACK_NONE]		= "NONE",
+	[LOOPBACK_DATA]		= "DATAPATH",
+	[LOOPBACK_GMAC]		= "GMAC",
+	[LOOPBACK_XGMII]	= "XGMII",
+	[LOOPBACK_XGXS]		= "XGXS",
+	[LOOPBACK_XAUI]		= "XAUI",
+	[LOOPBACK_GMII]		= "GMII",
+	[LOOPBACK_SGMII]	= "SGMII",
+	[LOOPBACK_XGBR]		= "XGBR",
+	[LOOPBACK_XFI]		= "XFI",
+	[LOOPBACK_XAUI_FAR]	= "XAUI_FAR",
+	[LOOPBACK_GMII_FAR]	= "GMII_FAR",
+	[LOOPBACK_SGMII_FAR]	= "SGMII_FAR",
+	[LOOPBACK_XFI_FAR]	= "XFI_FAR",
+	[LOOPBACK_GPHY]		= "GPHY",
+	[LOOPBACK_PHYXS]	= "PHYXS",
+	[LOOPBACK_PCS]		= "PCS",
+	[LOOPBACK_PMAPMD]	= "PMA/PMD",
+	[LOOPBACK_XPORT]	= "XPORT",
+	[LOOPBACK_XGMII_WS]	= "XGMII_WS",
+	[LOOPBACK_XAUI_WS]	= "XAUI_WS",
+	[LOOPBACK_XAUI_WS_FAR]  = "XAUI_WS_FAR",
+	[LOOPBACK_XAUI_WS_NEAR] = "XAUI_WS_NEAR",
+	[LOOPBACK_GMII_WS]	= "GMII_WS",
+	[LOOPBACK_XFI_WS]	= "XFI_WS",
+	[LOOPBACK_XFI_WS_FAR]	= "XFI_WS_FAR",
+	[LOOPBACK_PHYXS_WS]	= "PHYXS_WS",
+};
+
 /* Reset workqueue. If any NIC has a hardware failure then a reset will be
  * queued onto this work queue. This is not a per-nic work queue, because
  * efx_reset_work() acquires the rtnl lock, so resets are naturally serialised.
@@ -67,6 +146,20 @@ void efx_mac_reconfigure(struct efx_nic *efx)
 	up_read(&efx->filter_sem);
 }
 
+/* Asynchronous work item for changing MAC promiscuity and multicast
+ * hash.  Avoid a drain/rx_ingress enable by reconfiguring the current
+ * MAC directly.
+ */
+static void efx_mac_work(struct work_struct *data)
+{
+	struct efx_nic *efx = container_of(data, struct efx_nic, mac_work);
+
+	mutex_lock(&efx->mac_lock);
+	if (efx->port_enabled)
+		efx_mac_reconfigure(efx);
+	mutex_unlock(&efx->mac_lock);
+}
+
 /* This ensures that the kernel is kept informed (via
  * netif_carrier_on/off) of the link status, and also maintains the
  * link status's stop on the port's TX queue.
@@ -102,6 +195,43 @@ void efx_link_status_changed(struct efx_nic *efx)
 		netif_info(efx, link, efx->net_dev, "link down\n");
 }
 
+/**************************************************************************
+ *
+ * Hardware monitor
+ *
+ **************************************************************************/
+
+/* Run periodically off the general workqueue */
+static void efx_monitor(struct work_struct *data)
+{
+	struct efx_nic *efx = container_of(data, struct efx_nic,
+					   monitor_work.work);
+
+	netif_vdbg(efx, timer, efx->net_dev,
+		   "hardware monitor executing on CPU %d\n",
+		   raw_smp_processor_id());
+	BUG_ON(efx->type->monitor == NULL);
+
+	/* If the mac_lock is already held then it is likely a port
+	 * reconfiguration is already in place, which will likely do
+	 * most of the work of monitor() anyway.
+	 */
+	if (mutex_trylock(&efx->mac_lock)) {
+		if (efx->port_enabled && efx->type->monitor)
+			efx->type->monitor(efx);
+		mutex_unlock(&efx->mac_lock);
+	}
+
+	efx_start_monitor(efx);
+}
+
+void efx_start_monitor(struct efx_nic *efx)
+{
+	if (efx->type->monitor)
+		queue_delayed_work(efx->workqueue, &efx->monitor_work,
+				   efx_monitor_interval);
+}
+
 /**************************************************************************
  *
  * Event queue processing
@@ -436,6 +566,24 @@ int efx_reconfigure_port(struct efx_nic *efx)
  *
  **************************************************************************/
 
+static void efx_wait_for_bist_end(struct efx_nic *efx)
+{
+	int i;
+
+	for (i = 0; i < BIST_WAIT_DELAY_COUNT; ++i) {
+		if (efx_mcdi_poll_reboot(efx))
+			goto out;
+		msleep(BIST_WAIT_DELAY_MS);
+	}
+
+	netif_err(efx, drv, efx->net_dev, "Warning: No MC reboot after BIST mode\n");
+out:
+	/* Either way unset the BIST flag. If we found no reboot we probably
+	 * won't recover, but we should try.
+	 */
+	efx->mc_bist_for_other_fn = false;
+}
+
 /* Try recovery mechanisms.
  * For now only EEH is supported.
  * Returns 0 if the recovery mechanisms are unsuccessful.
@@ -617,6 +765,41 @@ int efx_reset(struct efx_nic *efx, enum reset_type method)
 	return rc;
 }
 
+/* The worker thread exists so that code that cannot sleep can
+ * schedule a reset for later.
+ */
+static void efx_reset_work(struct work_struct *data)
+{
+	struct efx_nic *efx = container_of(data, struct efx_nic, reset_work);
+	unsigned long pending;
+	enum reset_type method;
+
+	pending = READ_ONCE(efx->reset_pending);
+	method = fls(pending) - 1;
+
+	if (method == RESET_TYPE_MC_BIST)
+		efx_wait_for_bist_end(efx);
+
+	if ((method == RESET_TYPE_RECOVER_OR_DISABLE ||
+	     method == RESET_TYPE_RECOVER_OR_ALL) &&
+	    efx_try_recovery(efx))
+		return;
+
+	if (!pending)
+		return;
+
+	rtnl_lock();
+
+	/* We checked the state in efx_schedule_reset() but it may
+	 * have changed by now.  Now that we have the RTNL lock,
+	 * it cannot change again.
+	 */
+	if (efx->state == STATE_READY)
+		(void)efx_reset(efx, method);
+
+	rtnl_unlock();
+}
+
 void efx_schedule_reset(struct efx_nic *efx, enum reset_type type)
 {
 	enum reset_type method;
@@ -666,3 +849,231 @@ void efx_schedule_reset(struct efx_nic *efx, enum reset_type type)
 
 	efx_queue_reset_work(efx);
 }
+
+/**************************************************************************
+ *
+ * Dummy PHY/MAC operations
+ *
+ * Can be used for some unimplemented operations
+ * Needed so all function pointers are valid and do not have to be tested
+ * before use
+ *
+ **************************************************************************/
+int efx_port_dummy_op_int(struct efx_nic *efx)
+{
+	return 0;
+}
+void efx_port_dummy_op_void(struct efx_nic *efx) {}
+
+static bool efx_port_dummy_op_poll(struct efx_nic *efx)
+{
+	return false;
+}
+
+static const struct efx_phy_operations efx_dummy_phy_operations = {
+	.init		 = efx_port_dummy_op_int,
+	.reconfigure	 = efx_port_dummy_op_int,
+	.poll		 = efx_port_dummy_op_poll,
+	.fini		 = efx_port_dummy_op_void,
+};
+
+/**************************************************************************
+ *
+ * Data housekeeping
+ *
+ **************************************************************************/
+
+/* This zeroes out and then fills in the invariants in a struct
+ * efx_nic (including all sub-structures).
+ */
+int efx_init_struct(struct efx_nic *efx,
+		    struct pci_dev *pci_dev, struct net_device *net_dev)
+{
+	int rc = -ENOMEM;
+
+	/* Initialise common structures */
+	INIT_LIST_HEAD(&efx->node);
+	INIT_LIST_HEAD(&efx->secondary_list);
+	spin_lock_init(&efx->biu_lock);
+#ifdef CONFIG_SFC_MTD
+	INIT_LIST_HEAD(&efx->mtd_list);
+#endif
+	INIT_WORK(&efx->reset_work, efx_reset_work);
+	INIT_DELAYED_WORK(&efx->monitor_work, efx_monitor);
+	INIT_DELAYED_WORK(&efx->selftest_work, efx_selftest_async_work);
+	efx->pci_dev = pci_dev;
+	efx->msg_enable = debug;
+	efx->state = STATE_UNINIT;
+	strlcpy(efx->name, pci_name(pci_dev), sizeof(efx->name));
+
+	efx->net_dev = net_dev;
+	efx->rx_prefix_size = efx->type->rx_prefix_size;
+	efx->rx_ip_align =
+		NET_IP_ALIGN ? (efx->rx_prefix_size + NET_IP_ALIGN) % 4 : 0;
+	efx->rx_packet_hash_offset =
+		efx->type->rx_hash_offset - efx->type->rx_prefix_size;
+	efx->rx_packet_ts_offset =
+		efx->type->rx_ts_offset - efx->type->rx_prefix_size;
+	INIT_LIST_HEAD(&efx->rss_context.list);
+	mutex_init(&efx->rss_lock);
+	spin_lock_init(&efx->stats_lock);
+	efx->vi_stride = EFX_DEFAULT_VI_STRIDE;
+	efx->num_mac_stats = MC_CMD_MAC_NSTATS;
+	BUILD_BUG_ON(MC_CMD_MAC_NSTATS - 1 != MC_CMD_MAC_GENERATION_END);
+	mutex_init(&efx->mac_lock);
+#ifdef CONFIG_RFS_ACCEL
+	mutex_init(&efx->rps_mutex);
+	spin_lock_init(&efx->rps_hash_lock);
+	/* Failure to allocate is not fatal, but may degrade ARFS performance */
+	efx->rps_hash_table = kcalloc(EFX_ARFS_HASH_TABLE_SIZE,
+				      sizeof(*efx->rps_hash_table), GFP_KERNEL);
+#endif
+	efx->phy_op = &efx_dummy_phy_operations;
+	efx->mdio.dev = net_dev;
+	INIT_WORK(&efx->mac_work, efx_mac_work);
+	init_waitqueue_head(&efx->flush_wq);
+
+	rc = efx_init_channels(efx);
+	if (rc)
+		goto fail;
+
+	/* Would be good to use the net_dev name, but we're too early */
+	snprintf(efx->workqueue_name, sizeof(efx->workqueue_name), "sfc%s",
+		 pci_name(pci_dev));
+	efx->workqueue = create_singlethread_workqueue(efx->workqueue_name);
+	if (!efx->workqueue) {
+		rc = -ENOMEM;
+		goto fail;
+	}
+
+	return 0;
+
+fail:
+	efx_fini_struct(efx);
+	return rc;
+}
+
+void efx_fini_channels(struct efx_nic *efx)
+{
+	unsigned int i;
+
+	for (i = 0; i < EFX_MAX_CHANNELS; i++)
+		if (efx->channel[i]) {
+			kfree(efx->channel[i]);
+			efx->channel[i] = NULL;
+		}
+}
+
+void efx_fini_struct(struct efx_nic *efx)
+{
+#ifdef CONFIG_RFS_ACCEL
+	kfree(efx->rps_hash_table);
+#endif
+
+	efx_fini_channels(efx);
+
+	kfree(efx->vpd_sn);
+
+	if (efx->workqueue) {
+		destroy_workqueue(efx->workqueue);
+		efx->workqueue = NULL;
+	}
+}
+
+/* This configures the PCI device to enable I/O and DMA. */
+int efx_init_io(struct efx_nic *efx, int bar, dma_addr_t dma_mask,
+		unsigned int mem_map_size)
+{
+	struct pci_dev *pci_dev = efx->pci_dev;
+	int rc;
+
+	netif_dbg(efx, probe, efx->net_dev, "initialising I/O\n");
+
+	rc = pci_enable_device(pci_dev);
+	if (rc) {
+		netif_err(efx, probe, efx->net_dev,
+			  "failed to enable PCI device\n");
+		goto fail1;
+	}
+
+	pci_set_master(pci_dev);
+
+	/* Set the PCI DMA mask.  Try all possibilities from our
+	 * genuine mask down to 32 bits, because some architectures
+	 * (e.g. x86_64 with iommu_sac_force set) will allow 40 bit
+	 * masks event though they reject 46 bit masks.
+	 */
+	while (dma_mask > 0x7fffffffUL) {
+		rc = dma_set_mask_and_coherent(&pci_dev->dev, dma_mask);
+		if (rc == 0)
+			break;
+		dma_mask >>= 1;
+	}
+	if (rc) {
+		netif_err(efx, probe, efx->net_dev,
+			  "could not find a suitable DMA mask\n");
+		goto fail2;
+	}
+	netif_dbg(efx, probe, efx->net_dev,
+		  "using DMA mask %llx\n", (unsigned long long)dma_mask);
+
+	efx->membase_phys = pci_resource_start(efx->pci_dev, bar);
+	if (!efx->membase_phys) {
+		netif_err(efx, probe, efx->net_dev,
+			  "ERROR: No BAR%d mapping from the BIOS. "
+			  "Try pci=realloc on the kernel command line\n", bar);
+		rc = -ENODEV;
+		goto fail3;
+	}
+
+	rc = pci_request_region(pci_dev, bar, "sfc");
+	if (rc) {
+		netif_err(efx, probe, efx->net_dev,
+			  "request for memory BAR failed\n");
+		rc = -EIO;
+		goto fail3;
+	}
+
+	efx->membase = ioremap_nocache(efx->membase_phys, mem_map_size);
+	if (!efx->membase) {
+		netif_err(efx, probe, efx->net_dev,
+			  "could not map memory BAR at %llx+%x\n",
+			  (unsigned long long)efx->membase_phys, mem_map_size);
+		rc = -ENOMEM;
+		goto fail4;
+	}
+	netif_dbg(efx, probe, efx->net_dev,
+		  "memory BAR at %llx+%x (virtual %p)\n",
+		  (unsigned long long)efx->membase_phys, mem_map_size,
+		  efx->membase);
+
+	return 0;
+
+fail4:
+	pci_release_region(efx->pci_dev, bar);
+fail3:
+	efx->membase_phys = 0;
+fail2:
+	pci_disable_device(efx->pci_dev);
+fail1:
+	return rc;
+}
+
+void efx_fini_io(struct efx_nic *efx, int bar)
+{
+	netif_dbg(efx, drv, efx->net_dev, "shutting down I/O\n");
+
+	if (efx->membase) {
+		iounmap(efx->membase);
+		efx->membase = NULL;
+	}
+
+	if (efx->membase_phys) {
+		pci_release_region(efx->pci_dev, bar);
+		efx->membase_phys = 0;
+	}
+
+	/* Don't disable bus-mastering if VFs are assigned */
+	if (!pci_vfs_assigned(efx->pci_dev))
+		pci_disable_device(efx->pci_dev);
+}
-- 
2.20.1


