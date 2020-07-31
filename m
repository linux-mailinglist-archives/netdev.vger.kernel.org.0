Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46C50234664
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 15:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730807AbgGaNAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 09:00:47 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:53300 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727040AbgGaNAq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 09:00:46 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.137])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 3878E200B9;
        Fri, 31 Jul 2020 13:00:45 +0000 (UTC)
Received: from us4-mdac16-21.at1.mdlocal (unknown [10.110.49.203])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 36E6F600A1;
        Fri, 31 Jul 2020 13:00:45 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.109])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id AFBE6220072;
        Fri, 31 Jul 2020 13:00:44 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 60635B400A3;
        Fri, 31 Jul 2020 13:00:44 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 31 Jul
 2020 14:00:27 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH v2 net-next 08/11] sfc_ef100: statistics gathering
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <31de2e73-bce7-6c9d-0c20-49b32e2043cc@solarflare.com>
Message-ID: <64c11143-4749-5891-85eb-c312f1de721e@solarflare.com>
Date:   Fri, 31 Jul 2020 14:00:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <31de2e73-bce7-6c9d-0c20-49b32e2043cc@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25574.002
X-TM-AS-Result: No-1.852500-8.000000-10
X-TMASE-MatchedRID: 5EJ+L1ocBmGWY/h1I6tB9uI50E6g+As0Msovp/h9OdFjLp8Cm8vwFwoe
        RRhCZWIBnvBWG5GT8Jdw5T4Iaj538mJZXQNDzktSGjzBgnFZvQ6Siza26cvwNFIxScKXZnK0qhy
        W5ZNFJA5Fleyg8cB7ZnFelCTBDfkGV16ctsfQT/8+NrfDUTEXxD2ZWRUZEDj5f5tFqTvENXu+mF
        UWJD5GAnV9M9tBZb9b+hmED59HKaEwaD7CCdj96UNsgQWRiIpMo5KBmcJozDbfWY93w59GDgJjL
        DMzzZnzPaLEIfsP6BlAZ7LaEEV3JnqqAs/pRzaGVnzlQiaE21rdhJoeWdkvzV7OLL/a8shjKJmm
        yOSQ0ruLUdMGIz6m9OGl87K9Bdw4xB4g7OBWY2x+NQIFduF53zk4wzLIKf/BX1Ahz57P/j5E0vA
        S+f87pLtrdYL/xU2bj/WhJQN4WWflaM4oGVf1NI0JVVcEm48nUrOQOil6Z+zJrP9MePs1nKPFjJ
        EFr+olA9Mriq0CDAg9wJeM2pSaRVgXepbcl7r7S87Z8yS6WmbCpDeHxb75LiYV4pHnhjyM1kIJL
        k5y5CHW6WRdhdzs36WDm2uHu5k0hQCarUyKFdZSNjq+/5ILIWo32ZT0cbRrMcKpXuu/1jVAMwW4
        rY/0WO2hZq8RbsdETdnyMokJ1HTiaosWHm9+bH7cGd19dSFd
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--1.852500-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25574.002
X-MDID: 1596200445-z1ALpeX2COuE
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MAC stats work much the same as on EF10, with a periodic DMA to a region
 specified via an MCDI.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/ef100_netdev.c |   6 +
 drivers/net/ethernet/sfc/ef100_nic.c    | 171 ++++++++++++++++++++++++
 drivers/net/ethernet/sfc/ef100_nic.h    |  41 ++++++
 3 files changed, 218 insertions(+)

diff --git a/drivers/net/ethernet/sfc/ef100_netdev.c b/drivers/net/ethernet/sfc/ef100_netdev.c
index 362a915c836a..63c311ba28b9 100644
--- a/drivers/net/ethernet/sfc/ef100_netdev.c
+++ b/drivers/net/ethernet/sfc/ef100_netdev.c
@@ -86,6 +86,7 @@ static int ef100_net_stop(struct net_device *net_dev)
 
 	netif_stop_queue(net_dev);
 	efx_stop_all(efx);
+	efx_mcdi_mac_fini_stats(efx);
 	efx_disable_interrupts(efx);
 	efx_clear_interrupt_affinity(efx);
 	efx_nic_fini_interrupt(efx);
@@ -157,6 +158,10 @@ static int ef100_net_open(struct net_device *net_dev)
 	 */
 	(void) efx_mcdi_poll_reboot(efx);
 
+	rc = efx_mcdi_mac_init_stats(efx);
+	if (rc)
+		goto fail;
+
 	efx_start_all(efx);
 
 	/* Link state detection is normally event-driven; we have
@@ -212,6 +217,7 @@ static const struct net_device_ops ef100_netdev_ops = {
 	.ndo_open               = ef100_net_open,
 	.ndo_stop               = ef100_net_stop,
 	.ndo_start_xmit         = ef100_hard_start_xmit,
+	.ndo_get_stats64        = efx_net_stats,
 	.ndo_validate_addr      = eth_validate_addr,
 	.ndo_set_rx_mode        = efx_set_rx_mode, /* Lookout */
 	.ndo_get_phys_port_id   = efx_get_phys_port_id,
diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index c96cbf3e0111..1c93091609bd 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -453,6 +453,172 @@ static int ef100_reset(struct efx_nic *efx, enum reset_type reset_type)
 	return rc;
 }
 
+static void ef100_common_stat_mask(unsigned long *mask)
+{
+	__set_bit(EF100_STAT_port_tx_bytes, mask);
+	__set_bit(EF100_STAT_port_tx_packets, mask);
+	__set_bit(EF100_STAT_port_tx_pause, mask);
+	__set_bit(EF100_STAT_port_tx_unicast, mask);
+	__set_bit(EF100_STAT_port_tx_multicast, mask);
+	__set_bit(EF100_STAT_port_tx_broadcast, mask);
+	__set_bit(EF100_STAT_port_tx_lt64, mask);
+	__set_bit(EF100_STAT_port_tx_64, mask);
+	__set_bit(EF100_STAT_port_tx_65_to_127, mask);
+	__set_bit(EF100_STAT_port_tx_128_to_255, mask);
+	__set_bit(EF100_STAT_port_tx_256_to_511, mask);
+	__set_bit(EF100_STAT_port_tx_512_to_1023, mask);
+	__set_bit(EF100_STAT_port_tx_1024_to_15xx, mask);
+	__set_bit(EF100_STAT_port_tx_15xx_to_jumbo, mask);
+	__set_bit(EF100_STAT_port_rx_bytes, mask);
+	__set_bit(EF100_STAT_port_rx_packets, mask);
+	__set_bit(EF100_STAT_port_rx_good, mask);
+	__set_bit(EF100_STAT_port_rx_bad, mask);
+	__set_bit(EF100_STAT_port_rx_pause, mask);
+	__set_bit(EF100_STAT_port_rx_unicast, mask);
+	__set_bit(EF100_STAT_port_rx_multicast, mask);
+	__set_bit(EF100_STAT_port_rx_broadcast, mask);
+	__set_bit(EF100_STAT_port_rx_lt64, mask);
+	__set_bit(EF100_STAT_port_rx_64, mask);
+	__set_bit(EF100_STAT_port_rx_65_to_127, mask);
+	__set_bit(EF100_STAT_port_rx_128_to_255, mask);
+	__set_bit(EF100_STAT_port_rx_256_to_511, mask);
+	__set_bit(EF100_STAT_port_rx_512_to_1023, mask);
+	__set_bit(EF100_STAT_port_rx_1024_to_15xx, mask);
+	__set_bit(EF100_STAT_port_rx_15xx_to_jumbo, mask);
+	__set_bit(EF100_STAT_port_rx_gtjumbo, mask);
+	__set_bit(EF100_STAT_port_rx_bad_gtjumbo, mask);
+	__set_bit(EF100_STAT_port_rx_align_error, mask);
+	__set_bit(EF100_STAT_port_rx_length_error, mask);
+	__set_bit(EF100_STAT_port_rx_overflow, mask);
+	__set_bit(EF100_STAT_port_rx_nodesc_drops, mask);
+	__set_bit(GENERIC_STAT_rx_nodesc_trunc, mask);
+	__set_bit(GENERIC_STAT_rx_noskb_drops, mask);
+}
+
+#define EF100_DMA_STAT(ext_name, mcdi_name)			\
+	[EF100_STAT_ ## ext_name] =				\
+	{ #ext_name, 64, 8 * MC_CMD_MAC_ ## mcdi_name }
+
+static const struct efx_hw_stat_desc ef100_stat_desc[EF100_STAT_COUNT] = {
+	EF100_DMA_STAT(port_tx_bytes, TX_BYTES),
+	EF100_DMA_STAT(port_tx_packets, TX_PKTS),
+	EF100_DMA_STAT(port_tx_pause, TX_PAUSE_PKTS),
+	EF100_DMA_STAT(port_tx_unicast, TX_UNICAST_PKTS),
+	EF100_DMA_STAT(port_tx_multicast, TX_MULTICAST_PKTS),
+	EF100_DMA_STAT(port_tx_broadcast, TX_BROADCAST_PKTS),
+	EF100_DMA_STAT(port_tx_lt64, TX_LT64_PKTS),
+	EF100_DMA_STAT(port_tx_64, TX_64_PKTS),
+	EF100_DMA_STAT(port_tx_65_to_127, TX_65_TO_127_PKTS),
+	EF100_DMA_STAT(port_tx_128_to_255, TX_128_TO_255_PKTS),
+	EF100_DMA_STAT(port_tx_256_to_511, TX_256_TO_511_PKTS),
+	EF100_DMA_STAT(port_tx_512_to_1023, TX_512_TO_1023_PKTS),
+	EF100_DMA_STAT(port_tx_1024_to_15xx, TX_1024_TO_15XX_PKTS),
+	EF100_DMA_STAT(port_tx_15xx_to_jumbo, TX_15XX_TO_JUMBO_PKTS),
+	EF100_DMA_STAT(port_rx_bytes, RX_BYTES),
+	EF100_DMA_STAT(port_rx_packets, RX_PKTS),
+	EF100_DMA_STAT(port_rx_good, RX_GOOD_PKTS),
+	EF100_DMA_STAT(port_rx_bad, RX_BAD_FCS_PKTS),
+	EF100_DMA_STAT(port_rx_pause, RX_PAUSE_PKTS),
+	EF100_DMA_STAT(port_rx_unicast, RX_UNICAST_PKTS),
+	EF100_DMA_STAT(port_rx_multicast, RX_MULTICAST_PKTS),
+	EF100_DMA_STAT(port_rx_broadcast, RX_BROADCAST_PKTS),
+	EF100_DMA_STAT(port_rx_lt64, RX_UNDERSIZE_PKTS),
+	EF100_DMA_STAT(port_rx_64, RX_64_PKTS),
+	EF100_DMA_STAT(port_rx_65_to_127, RX_65_TO_127_PKTS),
+	EF100_DMA_STAT(port_rx_128_to_255, RX_128_TO_255_PKTS),
+	EF100_DMA_STAT(port_rx_256_to_511, RX_256_TO_511_PKTS),
+	EF100_DMA_STAT(port_rx_512_to_1023, RX_512_TO_1023_PKTS),
+	EF100_DMA_STAT(port_rx_1024_to_15xx, RX_1024_TO_15XX_PKTS),
+	EF100_DMA_STAT(port_rx_15xx_to_jumbo, RX_15XX_TO_JUMBO_PKTS),
+	EF100_DMA_STAT(port_rx_gtjumbo, RX_GTJUMBO_PKTS),
+	EF100_DMA_STAT(port_rx_bad_gtjumbo, RX_JABBER_PKTS),
+	EF100_DMA_STAT(port_rx_align_error, RX_ALIGN_ERROR_PKTS),
+	EF100_DMA_STAT(port_rx_length_error, RX_LENGTH_ERROR_PKTS),
+	EF100_DMA_STAT(port_rx_overflow, RX_OVERFLOW_PKTS),
+	EF100_DMA_STAT(port_rx_nodesc_drops, RX_NODESC_DROPS),
+	EFX_GENERIC_SW_STAT(rx_nodesc_trunc),
+	EFX_GENERIC_SW_STAT(rx_noskb_drops),
+};
+
+static void ef100_get_stat_mask(struct efx_nic *efx, unsigned long *mask)
+{
+	ef100_common_stat_mask(mask);
+}
+
+static size_t ef100_describe_stats(struct efx_nic *efx, u8 *names)
+{
+	DECLARE_BITMAP(mask, EF100_STAT_COUNT);
+
+	ef100_get_stat_mask(efx, mask);
+	return efx_nic_describe_stats(ef100_stat_desc, EF100_STAT_COUNT,
+				      mask, names);
+}
+
+static size_t ef100_update_stats_common(struct efx_nic *efx, u64 *full_stats,
+					struct rtnl_link_stats64 *core_stats)
+{
+	struct ef100_nic_data *nic_data = efx->nic_data;
+	DECLARE_BITMAP(mask, EF100_STAT_COUNT);
+	size_t stats_count = 0, index;
+	u64 *stats = nic_data->stats;
+
+	ef100_get_stat_mask(efx, mask);
+
+	if (full_stats) {
+		for_each_set_bit(index, mask, EF100_STAT_COUNT) {
+			if (ef100_stat_desc[index].name) {
+				*full_stats++ = stats[index];
+				++stats_count;
+			}
+		}
+	}
+
+	if (!core_stats)
+		return stats_count;
+
+	core_stats->rx_packets = stats[EF100_STAT_port_rx_packets];
+	core_stats->tx_packets = stats[EF100_STAT_port_tx_packets];
+	core_stats->rx_bytes = stats[EF100_STAT_port_rx_bytes];
+	core_stats->tx_bytes = stats[EF100_STAT_port_tx_bytes];
+	core_stats->rx_dropped = stats[EF100_STAT_port_rx_nodesc_drops] +
+				 stats[GENERIC_STAT_rx_nodesc_trunc] +
+				 stats[GENERIC_STAT_rx_noskb_drops];
+	core_stats->multicast = stats[EF100_STAT_port_rx_multicast];
+	core_stats->rx_length_errors =
+			stats[EF100_STAT_port_rx_gtjumbo] +
+			stats[EF100_STAT_port_rx_length_error];
+	core_stats->rx_crc_errors = stats[EF100_STAT_port_rx_bad];
+	core_stats->rx_frame_errors =
+			stats[EF100_STAT_port_rx_align_error];
+	core_stats->rx_fifo_errors = stats[EF100_STAT_port_rx_overflow];
+	core_stats->rx_errors = (core_stats->rx_length_errors +
+				 core_stats->rx_crc_errors +
+				 core_stats->rx_frame_errors);
+
+	return stats_count;
+}
+
+static size_t ef100_update_stats(struct efx_nic *efx,
+				 u64 *full_stats,
+				 struct rtnl_link_stats64 *core_stats)
+{
+	struct ef100_nic_data *nic_data = efx->nic_data;
+	DECLARE_BITMAP(mask, EF100_STAT_COUNT);
+	__le64 *mc_stats = kmalloc(efx->num_mac_stats * sizeof(__le64),
+				   GFP_ATOMIC);
+	u64 *stats = nic_data->stats;
+
+	ef100_get_stat_mask(efx, mask);
+
+	efx_nic_copy_stats(efx, mc_stats);
+	efx_nic_update_stats(ef100_stat_desc, EF100_STAT_COUNT, mask,
+			     stats, mc_stats, false);
+
+	kfree(mc_stats);
+
+	return ef100_update_stats_common(efx, full_stats, core_stats);
+}
+
 static int efx_ef100_get_phys_port_id(struct efx_nic *efx,
 				      struct netdev_phys_item_id *ppid)
 {
@@ -557,6 +723,11 @@ const struct efx_nic_type ef100_pf_nic_type = {
 	.rx_restore_rss_contexts = efx_mcdi_rx_restore_rss_contexts,
 
 	.reconfigure_mac = ef100_reconfigure_mac,
+	.describe_stats = ef100_describe_stats,
+	.start_stats = efx_mcdi_mac_start_stats,
+	.update_stats = ef100_update_stats,
+	.pull_stats = efx_mcdi_mac_pull_stats,
+	.stop_stats = efx_mcdi_mac_stop_stats,
 
 	/* Per-type bar/size configuration not used on ef100. Location of
 	 * registers is defined by extended capabilities.
diff --git a/drivers/net/ethernet/sfc/ef100_nic.h b/drivers/net/ethernet/sfc/ef100_nic.h
index c8816bc6ae78..7c2d37490074 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.h
+++ b/drivers/net/ethernet/sfc/ef100_nic.h
@@ -17,6 +17,46 @@ extern const struct efx_nic_type ef100_pf_nic_type;
 int ef100_probe_pf(struct efx_nic *efx);
 void ef100_remove(struct efx_nic *efx);
 
+enum {
+	EF100_STAT_port_tx_bytes = GENERIC_STAT_COUNT,
+	EF100_STAT_port_tx_packets,
+	EF100_STAT_port_tx_pause,
+	EF100_STAT_port_tx_unicast,
+	EF100_STAT_port_tx_multicast,
+	EF100_STAT_port_tx_broadcast,
+	EF100_STAT_port_tx_lt64,
+	EF100_STAT_port_tx_64,
+	EF100_STAT_port_tx_65_to_127,
+	EF100_STAT_port_tx_128_to_255,
+	EF100_STAT_port_tx_256_to_511,
+	EF100_STAT_port_tx_512_to_1023,
+	EF100_STAT_port_tx_1024_to_15xx,
+	EF100_STAT_port_tx_15xx_to_jumbo,
+	EF100_STAT_port_rx_bytes,
+	EF100_STAT_port_rx_packets,
+	EF100_STAT_port_rx_good,
+	EF100_STAT_port_rx_bad,
+	EF100_STAT_port_rx_pause,
+	EF100_STAT_port_rx_unicast,
+	EF100_STAT_port_rx_multicast,
+	EF100_STAT_port_rx_broadcast,
+	EF100_STAT_port_rx_lt64,
+	EF100_STAT_port_rx_64,
+	EF100_STAT_port_rx_65_to_127,
+	EF100_STAT_port_rx_128_to_255,
+	EF100_STAT_port_rx_256_to_511,
+	EF100_STAT_port_rx_512_to_1023,
+	EF100_STAT_port_rx_1024_to_15xx,
+	EF100_STAT_port_rx_15xx_to_jumbo,
+	EF100_STAT_port_rx_gtjumbo,
+	EF100_STAT_port_rx_bad_gtjumbo,
+	EF100_STAT_port_rx_align_error,
+	EF100_STAT_port_rx_length_error,
+	EF100_STAT_port_rx_overflow,
+	EF100_STAT_port_rx_nodesc_drops,
+	EF100_STAT_COUNT
+};
+
 struct ef100_nic_data {
 	struct efx_nic *efx;
 	struct efx_buffer mcdi_buf;
@@ -26,6 +66,7 @@ struct ef100_nic_data {
 	u16 warm_boot_count;
 	u8 port_id[ETH_ALEN];
 	DECLARE_BITMAP(evq_phases, EFX_MAX_CHANNELS);
+	u64 stats[EF100_STAT_COUNT];
 	u16 tso_max_hdr_len;
 	u16 tso_max_payload_num_segs;
 	u16 tso_max_frames;

