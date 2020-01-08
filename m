Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34B5C134758
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 17:13:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728913AbgAHQNV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 11:13:21 -0500
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:59822 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726186AbgAHQNV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 11:13:21 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us5.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 84A0C80050;
        Wed,  8 Jan 2020 16:13:19 +0000 (UTC)
Received: from amm-opti7060.uk.solarflarecom.com (10.17.20.147) by
 ukex01.SolarFlarecom.com (10.17.10.4) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Wed, 8 Jan 2020 16:13:13 +0000
From:   "Alex Maftei (amaftei)" <amaftei@solarflare.com>
Subject: [PATCH net-next 11/14] sfc: move channel interrupt management code
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>
CC:     <linux-net-drivers@solarflare.com>, <scrum-linux@solarflare.com>
References: <a0cfb828-b98e-3a63-15d9-592675e81b5f@solarflare.com>
Message-ID: <aa885225-2f64-8676-927e-47dc4c75170e@solarflare.com>
Date:   Wed, 8 Jan 2020 16:13:10 +0000
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
X-TM-AS-Result: No-3.425000-8.000000-10
X-TMASE-MatchedRID: 47cwfUuc0GyRpSeUCslIgvGSfx66m+aMeouvej40T4gd0WOKRkwsh0t6
        JYcPAsrWogSQgg+Gc51w5T4Iaj538mJZXQNDzktSGjzBgnFZvQ5KgIbix5+XxJENCSFlrm7vd5P
        xQFrCT9fHk2vEHTXTpu03npH1yTi1JHTgf0XC7IsqsMfMfrOZRUcA1Ouvduu85c+BtAuDGzjioA
        GxQy4eNTpOoYYobMkbJE/QPvgmUtJBZRZcGhF8oWY+xOrx57jWui/Hcpfcv4S6pZ/o2Hu2YTpG/
        1g33tjmHyHw0Mpa+ixlHrRm9Que9i+O0w9NM5ryPPQ52FQZE7S+w4q0qTmLyMj0QMA/92m2de5u
        OkkKYE9xQ7iXEO3hbA0+N8q2MiERLJEoELHgoqHobINHZkH5xvsfnerj08xD33Nl3elSfsqL3Co
        p5c8l9Wa7sK4//MlProt7DvFIawqwu4wxWH6dci0x8J2DopENNW8jQhzoALVpsnGGIgWMmeInpD
        ovMXJSusxjYhw464Gz22/BtuLHwpunn1YXpmkKCuDAUX+yO6b17lqbebntfUYza41dGqxSrJrD1
        ltfnAa8S7v+cm8Ds/u+aLdrMby3wG9P01lFxWXi8zVgXoAltlwtzewu2M63uRuWSuAIu/jdB/Cx
        WTRRuzBqYATSOgWjPs6NLQtO6Cm/yWsp3hM+pHUaVBtF+MEXhDPLdPEk2RUE6G9Oj9BGuYlOO9R
        987zDLUqCfAvlKqG5o8v04SxqJwxz0AcYlN++McKpXuu/1jVAMwW4rY/0WO2hZq8RbsdETdnyMo
        kJ1HTiaosWHm9+bH7cGd19dSFd
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--3.425000-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25154.003
X-MDID: 1578500000-Ou7Yopk8rimW
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Small code styling fixes included.

Signed-off-by: Alexandru-Mihai Maftei <amaftei@solarflare.com>
---
 drivers/net/ethernet/sfc/efx.c          | 316 -----------------------
 drivers/net/ethernet/sfc/efx_channels.c | 322 ++++++++++++++++++++++++
 2 files changed, 322 insertions(+), 316 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 955fcf714992..8ac299373ee5 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -96,17 +96,6 @@ static unsigned int rx_irq_mod_usec = 60;
  */
 static unsigned int tx_irq_mod_usec = 150;
 
-/* This is the requested number of CPUs to use for Receive-Side Scaling (RSS),
- * i.e. the number of CPUs among which we may distribute simultaneous
- * interrupt handling.
- *
- * Cards without MSI-X will only target one CPU via legacy or MSI interrupt.
- * The default (0) means to assign an interrupt to each core.
- */
-static unsigned int rss_cpus;
-module_param(rss_cpus, uint, 0444);
-MODULE_PARM_DESC(rss_cpus, "Number of CPUs to use for Receive-Side Scaling");
-
 static bool phy_flash_cfg;
 module_param(phy_flash_cfg, bool, 0644);
 MODULE_PARM_DESC(phy_flash_cfg, "Set PHYs into reflash mode initially");
@@ -450,311 +439,6 @@ void efx_set_default_rx_indir_table(struct efx_nic *efx,
 			ethtool_rxfh_indir_default(i, efx->rss_spread);
 }
 
-static unsigned int efx_wanted_parallelism(struct efx_nic *efx)
-{
-	cpumask_var_t thread_mask;
-	unsigned int count;
-	int cpu;
-
-	if (rss_cpus) {
-		count = rss_cpus;
-	} else {
-		if (unlikely(!zalloc_cpumask_var(&thread_mask, GFP_KERNEL))) {
-			netif_warn(efx, probe, efx->net_dev,
-				   "RSS disabled due to allocation failure\n");
-			return 1;
-		}
-
-		count = 0;
-		for_each_online_cpu(cpu) {
-			if (!cpumask_test_cpu(cpu, thread_mask)) {
-				++count;
-				cpumask_or(thread_mask, thread_mask,
-					   topology_sibling_cpumask(cpu));
-			}
-		}
-
-		free_cpumask_var(thread_mask);
-	}
-
-	if (count > EFX_MAX_RX_QUEUES) {
-		netif_cond_dbg(efx, probe, efx->net_dev, !rss_cpus, warn,
-			       "Reducing number of rx queues from %u to %u.\n",
-			       count, EFX_MAX_RX_QUEUES);
-		count = EFX_MAX_RX_QUEUES;
-	}
-
-	/* If RSS is requested for the PF *and* VFs then we can't write RSS
-	 * table entries that are inaccessible to VFs
-	 */
-#ifdef CONFIG_SFC_SRIOV
-	if (efx->type->sriov_wanted) {
-		if (efx->type->sriov_wanted(efx) && efx_vf_size(efx) > 1 &&
-		    count > efx_vf_size(efx)) {
-			netif_warn(efx, probe, efx->net_dev,
-				   "Reducing number of RSS channels from %u to %u for "
-				   "VF support. Increase vf-msix-limit to use more "
-				   "channels on the PF.\n",
-				   count, efx_vf_size(efx));
-			count = efx_vf_size(efx);
-		}
-	}
-#endif
-
-	return count;
-}
-
-static int efx_allocate_msix_channels(struct efx_nic *efx,
-				      unsigned int max_channels,
-				      unsigned int extra_channels,
-				      unsigned int parallelism)
-{
-	unsigned int n_channels = parallelism;
-	int vec_count;
-	int n_xdp_tx;
-	int n_xdp_ev;
-
-	if (efx_separate_tx_channels)
-		n_channels *= 2;
-	n_channels += extra_channels;
-
-	/* To allow XDP transmit to happen from arbitrary NAPI contexts
-	 * we allocate a TX queue per CPU. We share event queues across
-	 * multiple tx queues, assuming tx and ev queues are both
-	 * maximum size.
-	 */
-
-	n_xdp_tx = num_possible_cpus();
-	n_xdp_ev = DIV_ROUND_UP(n_xdp_tx, EFX_TXQ_TYPES);
-
-	vec_count = pci_msix_vec_count(efx->pci_dev);
-	if (vec_count < 0)
-		return vec_count;
-
-	max_channels = min_t(unsigned int, vec_count, max_channels);
-
-	/* Check resources.
-	 * We need a channel per event queue, plus a VI per tx queue.
-	 * This may be more pessimistic than it needs to be.
-	 */
-	if (n_channels + n_xdp_ev > max_channels) {
-		netif_err(efx, drv, efx->net_dev,
-			  "Insufficient resources for %d XDP event queues (%d other channels, max %d)\n",
-			  n_xdp_ev, n_channels, max_channels);
-		efx->n_xdp_channels = 0;
-		efx->xdp_tx_per_channel = 0;
-		efx->xdp_tx_queue_count = 0;
-	} else {
-		efx->n_xdp_channels = n_xdp_ev;
-		efx->xdp_tx_per_channel = EFX_TXQ_TYPES;
-		efx->xdp_tx_queue_count = n_xdp_tx;
-		n_channels += n_xdp_ev;
-		netif_dbg(efx, drv, efx->net_dev,
-			  "Allocating %d TX and %d event queues for XDP\n",
-			  n_xdp_tx, n_xdp_ev);
-	}
-
-	if (vec_count < n_channels) {
-		netif_err(efx, drv, efx->net_dev,
-			  "WARNING: Insufficient MSI-X vectors available (%d < %u).\n",
-			  vec_count, n_channels);
-		netif_err(efx, drv, efx->net_dev,
-			  "WARNING: Performance may be reduced.\n");
-		n_channels = vec_count;
-	}
-
-	n_channels = min(n_channels, max_channels);
-
-	efx->n_channels = n_channels;
-
-	/* Ignore XDP tx channels when creating rx channels. */
-	n_channels -= efx->n_xdp_channels;
-
-	if (efx_separate_tx_channels) {
-		efx->n_tx_channels =
-			min(max(n_channels / 2, 1U),
-			    efx->max_tx_channels);
-		efx->tx_channel_offset =
-			n_channels - efx->n_tx_channels;
-		efx->n_rx_channels =
-			max(n_channels -
-			    efx->n_tx_channels, 1U);
-	} else {
-		efx->n_tx_channels = min(n_channels, efx->max_tx_channels);
-		efx->tx_channel_offset = 0;
-		efx->n_rx_channels = n_channels;
-	}
-
-	efx->n_rx_channels = min(efx->n_rx_channels, parallelism);
-	efx->n_tx_channels = min(efx->n_tx_channels, parallelism);
-
-	efx->xdp_channel_offset = n_channels;
-
-	netif_dbg(efx, drv, efx->net_dev,
-		  "Allocating %u RX channels\n",
-		  efx->n_rx_channels);
-
-	return efx->n_channels;
-}
-
-/* Probe the number and type of interrupts we are able to obtain, and
- * the resulting numbers of channels and RX queues.
- */
-int efx_probe_interrupts(struct efx_nic *efx)
-{
-	unsigned int extra_channels = 0;
-	unsigned int rss_spread;
-	unsigned int i, j;
-	int rc;
-
-	for (i = 0; i < EFX_MAX_EXTRA_CHANNELS; i++)
-		if (efx->extra_channel_type[i])
-			++extra_channels;
-
-	if (efx->interrupt_mode == EFX_INT_MODE_MSIX) {
-		unsigned int parallelism = efx_wanted_parallelism(efx);
-		struct msix_entry xentries[EFX_MAX_CHANNELS];
-		unsigned int n_channels;
-
-		rc = efx_allocate_msix_channels(efx, efx->max_channels,
-						extra_channels, parallelism);
-		if (rc >= 0) {
-			n_channels = rc;
-			for (i = 0; i < n_channels; i++)
-				xentries[i].entry = i;
-			rc = pci_enable_msix_range(efx->pci_dev, xentries, 1,
-						   n_channels);
-		}
-		if (rc < 0) {
-			/* Fall back to single channel MSI */
-			netif_err(efx, drv, efx->net_dev,
-				  "could not enable MSI-X\n");
-			if (efx->type->min_interrupt_mode >= EFX_INT_MODE_MSI)
-				efx->interrupt_mode = EFX_INT_MODE_MSI;
-			else
-				return rc;
-		} else if (rc < n_channels) {
-			netif_err(efx, drv, efx->net_dev,
-				  "WARNING: Insufficient MSI-X vectors"
-				  " available (%d < %u).\n", rc, n_channels);
-			netif_err(efx, drv, efx->net_dev,
-				  "WARNING: Performance may be reduced.\n");
-			n_channels = rc;
-		}
-
-		if (rc > 0) {
-			for (i = 0; i < efx->n_channels; i++)
-				efx_get_channel(efx, i)->irq =
-					xentries[i].vector;
-		}
-	}
-
-	/* Try single interrupt MSI */
-	if (efx->interrupt_mode == EFX_INT_MODE_MSI) {
-		efx->n_channels = 1;
-		efx->n_rx_channels = 1;
-		efx->n_tx_channels = 1;
-		efx->n_xdp_channels = 0;
-		efx->xdp_channel_offset = efx->n_channels;
-		rc = pci_enable_msi(efx->pci_dev);
-		if (rc == 0) {
-			efx_get_channel(efx, 0)->irq = efx->pci_dev->irq;
-		} else {
-			netif_err(efx, drv, efx->net_dev,
-				  "could not enable MSI\n");
-			if (efx->type->min_interrupt_mode >= EFX_INT_MODE_LEGACY)
-				efx->interrupt_mode = EFX_INT_MODE_LEGACY;
-			else
-				return rc;
-		}
-	}
-
-	/* Assume legacy interrupts */
-	if (efx->interrupt_mode == EFX_INT_MODE_LEGACY) {
-		efx->n_channels = 1 + (efx_separate_tx_channels ? 1 : 0);
-		efx->n_rx_channels = 1;
-		efx->n_tx_channels = 1;
-		efx->n_xdp_channels = 0;
-		efx->xdp_channel_offset = efx->n_channels;
-		efx->legacy_irq = efx->pci_dev->irq;
-	}
-
-	/* Assign extra channels if possible, before XDP channels */
-	efx->n_extra_tx_channels = 0;
-	j = efx->xdp_channel_offset;
-	for (i = 0; i < EFX_MAX_EXTRA_CHANNELS; i++) {
-		if (!efx->extra_channel_type[i])
-			continue;
-		if (j <= efx->tx_channel_offset + efx->n_tx_channels) {
-			efx->extra_channel_type[i]->handle_no_channel(efx);
-		} else {
-			--j;
-			efx_get_channel(efx, j)->type =
-				efx->extra_channel_type[i];
-			if (efx_channel_has_tx_queues(efx_get_channel(efx, j)))
-				efx->n_extra_tx_channels++;
-		}
-	}
-
-	rss_spread = efx->n_rx_channels;
-	/* RSS might be usable on VFs even if it is disabled on the PF */
-#ifdef CONFIG_SFC_SRIOV
-	if (efx->type->sriov_wanted) {
-		efx->rss_spread = ((rss_spread > 1 ||
-				    !efx->type->sriov_wanted(efx)) ?
-				   rss_spread : efx_vf_size(efx));
-		return 0;
-	}
-#endif
-	efx->rss_spread = rss_spread;
-
-	return 0;
-}
-
-#if defined(CONFIG_SMP)
-void efx_set_interrupt_affinity(struct efx_nic *efx)
-{
-	struct efx_channel *channel;
-	unsigned int cpu;
-
-	efx_for_each_channel(channel, efx) {
-		cpu = cpumask_local_spread(channel->channel,
-					   pcibus_to_node(efx->pci_dev->bus));
-		irq_set_affinity_hint(channel->irq, cpumask_of(cpu));
-	}
-}
-
-void efx_clear_interrupt_affinity(struct efx_nic *efx)
-{
-	struct efx_channel *channel;
-
-	efx_for_each_channel(channel, efx)
-		irq_set_affinity_hint(channel->irq, NULL);
-}
-#else
-void efx_set_interrupt_affinity(struct efx_nic *efx __attribute__ ((unused)))
-{
-}
-
-void efx_clear_interrupt_affinity(struct efx_nic *efx __attribute__ ((unused)))
-{
-}
-#endif /* CONFIG_SMP */
-
-void efx_remove_interrupts(struct efx_nic *efx)
-{
-	struct efx_channel *channel;
-
-	/* Remove MSI/MSI-X interrupts */
-	efx_for_each_channel(channel, efx)
-		channel->irq = 0;
-	pci_disable_msi(efx->pci_dev);
-	pci_disable_msix(efx->pci_dev);
-
-	/* Remove legacy interrupt */
-	efx->legacy_irq = 0;
-}
-
 static int efx_probe_nic(struct efx_nic *efx)
 {
 	int rc;
diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
index bd5bc77a1d5a..65006af28210 100644
--- a/drivers/net/ethernet/sfc/efx_channels.c
+++ b/drivers/net/ethernet/sfc/efx_channels.c
@@ -28,6 +28,17 @@ module_param(interrupt_mode, uint, 0444);
 MODULE_PARM_DESC(interrupt_mode,
 		 "Interrupt mode (0=>MSIX 1=>MSI 2=>legacy)");
 
+/* This is the requested number of CPUs to use for Receive-Side Scaling (RSS),
+ * i.e. the number of CPUs among which we may distribute simultaneous
+ * interrupt handling.
+ *
+ * Cards without MSI-X will only target one CPU via legacy or MSI interrupt.
+ * The default (0) means to assign an interrupt to each core.
+ */
+static unsigned int rss_cpus;
+module_param(rss_cpus, uint, 0444);
+MODULE_PARM_DESC(rss_cpus, "Number of CPUs to use for Receive-Side Scaling");
+
 static unsigned int irq_adapt_low_thresh = 8000;
 module_param(irq_adapt_low_thresh, uint, 0644);
 MODULE_PARM_DESC(irq_adapt_low_thresh,
@@ -66,6 +77,317 @@ static const struct efx_channel_type efx_default_channel_type = {
 	.want_pio		= true,
 };
 
+/*************
+ * INTERRUPTS
+ *************/
+
+static unsigned int efx_wanted_parallelism(struct efx_nic *efx)
+{
+	cpumask_var_t thread_mask;
+	unsigned int count;
+	int cpu;
+
+	if (rss_cpus) {
+		count = rss_cpus;
+	} else {
+		if (unlikely(!zalloc_cpumask_var(&thread_mask, GFP_KERNEL))) {
+			netif_warn(efx, probe, efx->net_dev,
+				   "RSS disabled due to allocation failure\n");
+			return 1;
+		}
+
+		count = 0;
+		for_each_online_cpu(cpu) {
+			if (!cpumask_test_cpu(cpu, thread_mask)) {
+				++count;
+				cpumask_or(thread_mask, thread_mask,
+					   topology_sibling_cpumask(cpu));
+			}
+		}
+
+		free_cpumask_var(thread_mask);
+	}
+
+	if (count > EFX_MAX_RX_QUEUES) {
+		netif_cond_dbg(efx, probe, efx->net_dev, !rss_cpus, warn,
+			       "Reducing number of rx queues from %u to %u.\n",
+			       count, EFX_MAX_RX_QUEUES);
+		count = EFX_MAX_RX_QUEUES;
+	}
+
+	/* If RSS is requested for the PF *and* VFs then we can't write RSS
+	 * table entries that are inaccessible to VFs
+	 */
+#ifdef CONFIG_SFC_SRIOV
+	if (efx->type->sriov_wanted) {
+		if (efx->type->sriov_wanted(efx) && efx_vf_size(efx) > 1 &&
+		    count > efx_vf_size(efx)) {
+			netif_warn(efx, probe, efx->net_dev,
+				   "Reducing number of RSS channels from %u to %u for "
+				   "VF support. Increase vf-msix-limit to use more "
+				   "channels on the PF.\n",
+				   count, efx_vf_size(efx));
+			count = efx_vf_size(efx);
+		}
+	}
+#endif
+
+	return count;
+}
+
+static int efx_allocate_msix_channels(struct efx_nic *efx,
+				      unsigned int max_channels,
+				      unsigned int extra_channels,
+				      unsigned int parallelism)
+{
+	unsigned int n_channels = parallelism;
+	int vec_count;
+	int n_xdp_tx;
+	int n_xdp_ev;
+
+	if (efx_separate_tx_channels)
+		n_channels *= 2;
+	n_channels += extra_channels;
+
+	/* To allow XDP transmit to happen from arbitrary NAPI contexts
+	 * we allocate a TX queue per CPU. We share event queues across
+	 * multiple tx queues, assuming tx and ev queues are both
+	 * maximum size.
+	 */
+
+	n_xdp_tx = num_possible_cpus();
+	n_xdp_ev = DIV_ROUND_UP(n_xdp_tx, EFX_TXQ_TYPES);
+
+	vec_count = pci_msix_vec_count(efx->pci_dev);
+	if (vec_count < 0)
+		return vec_count;
+
+	max_channels = min_t(unsigned int, vec_count, max_channels);
+
+	/* Check resources.
+	 * We need a channel per event queue, plus a VI per tx queue.
+	 * This may be more pessimistic than it needs to be.
+	 */
+	if (n_channels + n_xdp_ev > max_channels) {
+		netif_err(efx, drv, efx->net_dev,
+			  "Insufficient resources for %d XDP event queues (%d other channels, max %d)\n",
+			  n_xdp_ev, n_channels, max_channels);
+		efx->n_xdp_channels = 0;
+		efx->xdp_tx_per_channel = 0;
+		efx->xdp_tx_queue_count = 0;
+	} else {
+		efx->n_xdp_channels = n_xdp_ev;
+		efx->xdp_tx_per_channel = EFX_TXQ_TYPES;
+		efx->xdp_tx_queue_count = n_xdp_tx;
+		n_channels += n_xdp_ev;
+		netif_dbg(efx, drv, efx->net_dev,
+			  "Allocating %d TX and %d event queues for XDP\n",
+			  n_xdp_tx, n_xdp_ev);
+	}
+
+	if (vec_count < n_channels) {
+		netif_err(efx, drv, efx->net_dev,
+			  "WARNING: Insufficient MSI-X vectors available (%d < %u).\n",
+			  vec_count, n_channels);
+		netif_err(efx, drv, efx->net_dev,
+			  "WARNING: Performance may be reduced.\n");
+		n_channels = vec_count;
+	}
+
+	n_channels = min(n_channels, max_channels);
+
+	efx->n_channels = n_channels;
+
+	/* Ignore XDP tx channels when creating rx channels. */
+	n_channels -= efx->n_xdp_channels;
+
+	if (efx_separate_tx_channels) {
+		efx->n_tx_channels =
+			min(max(n_channels / 2, 1U),
+			    efx->max_tx_channels);
+		efx->tx_channel_offset =
+			n_channels - efx->n_tx_channels;
+		efx->n_rx_channels =
+			max(n_channels -
+			    efx->n_tx_channels, 1U);
+	} else {
+		efx->n_tx_channels = min(n_channels, efx->max_tx_channels);
+		efx->tx_channel_offset = 0;
+		efx->n_rx_channels = n_channels;
+	}
+
+	efx->n_rx_channels = min(efx->n_rx_channels, parallelism);
+	efx->n_tx_channels = min(efx->n_tx_channels, parallelism);
+
+	efx->xdp_channel_offset = n_channels;
+
+	netif_dbg(efx, drv, efx->net_dev,
+		  "Allocating %u RX channels\n",
+		  efx->n_rx_channels);
+
+	return efx->n_channels;
+}
+
+/* Probe the number and type of interrupts we are able to obtain, and
+ * the resulting numbers of channels and RX queues.
+ */
+int efx_probe_interrupts(struct efx_nic *efx)
+{
+	unsigned int extra_channels = 0;
+	unsigned int rss_spread;
+	unsigned int i, j;
+	int rc;
+
+	for (i = 0; i < EFX_MAX_EXTRA_CHANNELS; i++)
+		if (efx->extra_channel_type[i])
+			++extra_channels;
+
+	if (efx->interrupt_mode == EFX_INT_MODE_MSIX) {
+		unsigned int parallelism = efx_wanted_parallelism(efx);
+		struct msix_entry xentries[EFX_MAX_CHANNELS];
+		unsigned int n_channels;
+
+		rc = efx_allocate_msix_channels(efx, efx->max_channels,
+						extra_channels, parallelism);
+		if (rc >= 0) {
+			n_channels = rc;
+			for (i = 0; i < n_channels; i++)
+				xentries[i].entry = i;
+			rc = pci_enable_msix_range(efx->pci_dev, xentries, 1,
+						   n_channels);
+		}
+		if (rc < 0) {
+			/* Fall back to single channel MSI */
+			netif_err(efx, drv, efx->net_dev,
+				  "could not enable MSI-X\n");
+			if (efx->type->min_interrupt_mode >= EFX_INT_MODE_MSI)
+				efx->interrupt_mode = EFX_INT_MODE_MSI;
+			else
+				return rc;
+		} else if (rc < n_channels) {
+			netif_err(efx, drv, efx->net_dev,
+				  "WARNING: Insufficient MSI-X vectors"
+				  " available (%d < %u).\n", rc, n_channels);
+			netif_err(efx, drv, efx->net_dev,
+				  "WARNING: Performance may be reduced.\n");
+			n_channels = rc;
+		}
+
+		if (rc > 0) {
+			for (i = 0; i < efx->n_channels; i++)
+				efx_get_channel(efx, i)->irq =
+					xentries[i].vector;
+		}
+	}
+
+	/* Try single interrupt MSI */
+	if (efx->interrupt_mode == EFX_INT_MODE_MSI) {
+		efx->n_channels = 1;
+		efx->n_rx_channels = 1;
+		efx->n_tx_channels = 1;
+		efx->n_xdp_channels = 0;
+		efx->xdp_channel_offset = efx->n_channels;
+		rc = pci_enable_msi(efx->pci_dev);
+		if (rc == 0) {
+			efx_get_channel(efx, 0)->irq = efx->pci_dev->irq;
+		} else {
+			netif_err(efx, drv, efx->net_dev,
+				  "could not enable MSI\n");
+			if (efx->type->min_interrupt_mode >= EFX_INT_MODE_LEGACY)
+				efx->interrupt_mode = EFX_INT_MODE_LEGACY;
+			else
+				return rc;
+		}
+	}
+
+	/* Assume legacy interrupts */
+	if (efx->interrupt_mode == EFX_INT_MODE_LEGACY) {
+		efx->n_channels = 1 + (efx_separate_tx_channels ? 1 : 0);
+		efx->n_rx_channels = 1;
+		efx->n_tx_channels = 1;
+		efx->n_xdp_channels = 0;
+		efx->xdp_channel_offset = efx->n_channels;
+		efx->legacy_irq = efx->pci_dev->irq;
+	}
+
+	/* Assign extra channels if possible, before XDP channels */
+	efx->n_extra_tx_channels = 0;
+	j = efx->xdp_channel_offset;
+	for (i = 0; i < EFX_MAX_EXTRA_CHANNELS; i++) {
+		if (!efx->extra_channel_type[i])
+			continue;
+		if (j <= efx->tx_channel_offset + efx->n_tx_channels) {
+			efx->extra_channel_type[i]->handle_no_channel(efx);
+		} else {
+			--j;
+			efx_get_channel(efx, j)->type =
+				efx->extra_channel_type[i];
+			if (efx_channel_has_tx_queues(efx_get_channel(efx, j)))
+				efx->n_extra_tx_channels++;
+		}
+	}
+
+	rss_spread = efx->n_rx_channels;
+	/* RSS might be usable on VFs even if it is disabled on the PF */
+#ifdef CONFIG_SFC_SRIOV
+	if (efx->type->sriov_wanted) {
+		efx->rss_spread = ((rss_spread > 1 ||
+				    !efx->type->sriov_wanted(efx)) ?
+				   rss_spread : efx_vf_size(efx));
+		return 0;
+	}
+#endif
+	efx->rss_spread = rss_spread;
+
+	return 0;
+}
+
+#if defined(CONFIG_SMP)
+void efx_set_interrupt_affinity(struct efx_nic *efx)
+{
+	struct efx_channel *channel;
+	unsigned int cpu;
+
+	efx_for_each_channel(channel, efx) {
+		cpu = cpumask_local_spread(channel->channel,
+					   pcibus_to_node(efx->pci_dev->bus));
+		irq_set_affinity_hint(channel->irq, cpumask_of(cpu));
+	}
+}
+
+void efx_clear_interrupt_affinity(struct efx_nic *efx)
+{
+	struct efx_channel *channel;
+
+	efx_for_each_channel(channel, efx)
+		irq_set_affinity_hint(channel->irq, NULL);
+}
+#else
+void
+efx_set_interrupt_affinity(struct efx_nic *efx __attribute__ ((unused)))
+{
+}
+
+void
+efx_clear_interrupt_affinity(struct efx_nic *efx __attribute__ ((unused)))
+{
+}
+#endif /* CONFIG_SMP */
+
+void efx_remove_interrupts(struct efx_nic *efx)
+{
+	struct efx_channel *channel;
+
+	/* Remove MSI/MSI-X interrupts */
+	efx_for_each_channel(channel, efx)
+		channel->irq = 0;
+	pci_disable_msi(efx->pci_dev);
+	pci_disable_msix(efx->pci_dev);
+
+	/* Remove legacy interrupt */
+	efx->legacy_irq = 0;
+}
+
 /**************************************************************************
  *
  * Channel handling
-- 
2.20.1


