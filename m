Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D78B0234668
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 15:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731922AbgGaNBe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 09:01:34 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:41184 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727040AbgGaNBd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 09:01:33 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.144])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id A8D9E2013F;
        Fri, 31 Jul 2020 13:01:32 +0000 (UTC)
Received: from us4-mdac16-65.at1.mdlocal (unknown [10.110.50.184])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id A5CE6800AD;
        Fri, 31 Jul 2020 13:01:32 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.48.236])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 2D8DC40089;
        Fri, 31 Jul 2020 13:01:32 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 535234000D0;
        Fri, 31 Jul 2020 13:01:31 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 31 Jul
 2020 14:01:23 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH v2 net-next 11/11] sfc_ef100: add nic-type for VFs, and bind
 to them
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <31de2e73-bce7-6c9d-0c20-49b32e2043cc@solarflare.com>
Message-ID: <51c6d62a-40f3-228f-05b4-b408f8f632df@solarflare.com>
Date:   Fri, 31 Jul 2020 14:01:20 +0100
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
X-TM-AS-Result: No-7.976800-8.000000-10
X-TMASE-MatchedRID: qjW9V/Hb/oHMdO/aI0cjorsHVDDM5xAP1JP9NndNOkUGmHr1eMxt2UAc
        6DyoS2rIj6kCfX0Edc4mQHxxqFX9+dJGUnV5uUQk5x61kcWHbRZJaD67iKvY0yJcTqMCib7FOkb
        /WDfe2OYHtdkqavJrPHQBcSHhv1FA6799S5AV4EYgCPGiZqtI8OHCwRwMNQUWSMg2Oe/b8ExVR4
        kqiI6BgY9QLvd1dyp55knayZl8+1iRehYFOG64KEhwlOfYeSqxMVx/3ZYby79tfQJzq1p8Jqip1
        8v0DWYVXK9FoQ/9VZ62ZXRrhevIb+rio6p+t0cn4WAObM1VUqhfAXPuWnqbjwk6S8C293Smt1oy
        FZpewUdSrEIb6WWZAem8dcFmTYdoRuJGaNfpGiIHtOpEBhWiFlsP0tBwe3qDq012kWtld3xn4/n
        MWJ1Bm/Pe1KADdXu8PDyxXK7R6Xi8BgGfZhePrQnxCJVNCszYvMRNh9hLjFn5+tteD5RzhR5E67
        yReou74vM1YF6AJbZFi+KwZZttL42j49Ftap9EOwBXM346/+yOdv9lYnXv3uDxDQiNeNtIY782m
        /5aKcze2HL0ro/TNnteM6Mm3XQR
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--7.976800-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25574.002
X-MDID: 1596200492-tpTOa3b6l_Nu
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We don't yet have a .sriov_configure() to create them, though.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/ef100.c     |  2 +
 drivers/net/ethernet/sfc/ef100_nic.c | 77 ++++++++++++++++++++++++++++
 drivers/net/ethernet/sfc/ef100_nic.h |  2 +
 3 files changed, 81 insertions(+)

diff --git a/drivers/net/ethernet/sfc/ef100.c b/drivers/net/ethernet/sfc/ef100.c
index de611c0f94e7..9729983f4840 100644
--- a/drivers/net/ethernet/sfc/ef100.c
+++ b/drivers/net/ethernet/sfc/ef100.c
@@ -527,6 +527,8 @@ static int ef100_pci_probe(struct pci_dev *pci_dev,
 static const struct pci_device_id ef100_pci_table[] = {
 	{PCI_DEVICE(PCI_VENDOR_ID_XILINX, 0x0100),  /* Riverhead PF */
 		.driver_data = (unsigned long) &ef100_pf_nic_type },
+	{PCI_DEVICE(PCI_VENDOR_ID_XILINX, 0x1100),  /* Riverhead VF */
+		.driver_data = (unsigned long) &ef100_vf_nic_type },
 	{0}                     /* end of list */
 };
 
diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index 0872ad0aec33..a3d01a28da2d 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -784,6 +784,78 @@ const struct efx_nic_type ef100_pf_nic_type = {
 
 };
 
+const struct efx_nic_type ef100_vf_nic_type = {
+	.revision = EFX_REV_EF100,
+	.is_vf = true,
+	.probe = ef100_probe_vf,
+	.offload_features = EF100_OFFLOAD_FEATURES,
+	.mcdi_max_ver = 2,
+	.mcdi_request = ef100_mcdi_request,
+	.mcdi_poll_response = ef100_mcdi_poll_response,
+	.mcdi_read_response = ef100_mcdi_read_response,
+	.mcdi_poll_reboot = ef100_mcdi_poll_reboot,
+	.mcdi_reboot_detected = ef100_mcdi_reboot_detected,
+	.irq_enable_master = efx_port_dummy_op_void,
+	.irq_test_generate = efx_ef100_irq_test_generate,
+	.irq_disable_non_ev = efx_port_dummy_op_void,
+	.push_irq_moderation = efx_channel_dummy_op_void,
+	.min_interrupt_mode = EFX_INT_MODE_MSIX,
+	.map_reset_reason = ef100_map_reset_reason,
+	.map_reset_flags = ef100_map_reset_flags,
+	.reset = ef100_reset,
+	.check_caps = ef100_check_caps,
+	.ev_probe = ef100_ev_probe,
+	.ev_init = ef100_ev_init,
+	.ev_fini = efx_mcdi_ev_fini,
+	.ev_remove = efx_mcdi_ev_remove,
+	.irq_handle_msi = ef100_msi_interrupt,
+	.ev_process = ef100_ev_process,
+	.ev_read_ack = ef100_ev_read_ack,
+	.ev_test_generate = efx_ef100_ev_test_generate,
+	.tx_probe = ef100_tx_probe,
+	.tx_init = ef100_tx_init,
+	.tx_write = ef100_tx_write,
+	.tx_enqueue = ef100_enqueue_skb,
+	.rx_probe = efx_mcdi_rx_probe,
+	.rx_init = efx_mcdi_rx_init,
+	.rx_remove = efx_mcdi_rx_remove,
+	.rx_write = ef100_rx_write,
+	.rx_packet = __ef100_rx_packet,
+	.fini_dmaq = efx_fini_dmaq,
+	.max_rx_ip_filters = EFX_MCDI_FILTER_TBL_ROWS,
+	.filter_table_probe = ef100_filter_table_up,
+	.filter_table_restore = efx_mcdi_filter_table_restore,
+	.filter_table_remove = ef100_filter_table_down,
+	.filter_insert = efx_mcdi_filter_insert,
+	.filter_remove_safe = efx_mcdi_filter_remove_safe,
+	.filter_get_safe = efx_mcdi_filter_get_safe,
+	.filter_clear_rx = efx_mcdi_filter_clear_rx,
+	.filter_count_rx_used = efx_mcdi_filter_count_rx_used,
+	.filter_get_rx_id_limit = efx_mcdi_filter_get_rx_id_limit,
+	.filter_get_rx_ids = efx_mcdi_filter_get_rx_ids,
+	.filter_rfs_expire_one = efx_mcdi_filter_rfs_expire_one,
+
+	.rx_prefix_size = ESE_GZ_RX_PKT_PREFIX_LEN,
+	.rx_hash_offset = ESF_GZ_RX_PREFIX_RSS_HASH_LBN / 8,
+	.rx_ts_offset = ESF_GZ_RX_PREFIX_PARTIAL_TSTAMP_LBN / 8,
+	.rx_hash_key_size = 40,
+	.rx_pull_rss_config = efx_mcdi_rx_pull_rss_config,
+	.rx_push_rss_config = efx_mcdi_pf_rx_push_rss_config,
+	.rx_restore_rss_contexts = efx_mcdi_rx_restore_rss_contexts,
+
+	.reconfigure_mac = ef100_reconfigure_mac,
+	.test_nvram = efx_new_mcdi_nvram_test_all,
+	.describe_stats = ef100_describe_stats,
+	.start_stats = efx_mcdi_mac_start_stats,
+	.update_stats = ef100_update_stats,
+	.pull_stats = efx_mcdi_mac_pull_stats,
+	.stop_stats = efx_mcdi_mac_stop_stats,
+
+	.mem_bar = NULL,
+	.mem_map_size = NULL,
+
+};
+
 static int compare_versions(const char *a, const char *b)
 {
 	int a_major, a_minor, a_point, a_patch;
@@ -1164,6 +1236,11 @@ int ef100_probe_pf(struct efx_nic *efx)
 	return rc;
 }
 
+int ef100_probe_vf(struct efx_nic *efx)
+{
+	return ef100_probe_main(efx);
+}
+
 void ef100_remove(struct efx_nic *efx)
 {
 	struct ef100_nic_data *nic_data = efx->nic_data;
diff --git a/drivers/net/ethernet/sfc/ef100_nic.h b/drivers/net/ethernet/sfc/ef100_nic.h
index 4a64c9438493..e799688d5264 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.h
+++ b/drivers/net/ethernet/sfc/ef100_nic.h
@@ -13,8 +13,10 @@
 #include "nic_common.h"
 
 extern const struct efx_nic_type ef100_pf_nic_type;
+extern const struct efx_nic_type ef100_vf_nic_type;
 
 int ef100_probe_pf(struct efx_nic *efx);
+int ef100_probe_vf(struct efx_nic *efx);
 void ef100_remove(struct efx_nic *efx);
 
 enum {
