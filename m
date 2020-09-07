Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D779025FE61
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 18:15:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730486AbgIGQPI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 12:15:08 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:43238 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729949AbgIGQPD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 12:15:03 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.62])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 6632260093;
        Mon,  7 Sep 2020 16:15:02 +0000 (UTC)
Received: from us4-mdac16-69.ut7.mdlocal (unknown [10.7.64.188])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 6332B80094;
        Mon,  7 Sep 2020 16:15:02 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.39])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id BDB6728004D;
        Mon,  7 Sep 2020 16:15:01 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 54DEE8006B;
        Mon,  7 Sep 2020 16:15:01 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 7 Sep 2020
 17:14:56 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 3/6] sfc: add ethtool ops and miscellaneous ndos to
 EF100
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <4634ee2f-728d-fa64-aa2c-490f607fc9fd@solarflare.com>
Message-ID: <d8c9fe3a-2d2b-ff69-a7ad-ccab5ae8d725@solarflare.com>
Date:   Mon, 7 Sep 2020 17:14:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <4634ee2f-728d-fa64-aa2c-490f607fc9fd@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25650.007
X-TM-AS-Result: No-7.168000-8.000000-10
X-TMASE-MatchedRID: I3Jzj/JB0j70gpEqM7fvYbsHVDDM5xAP1JP9NndNOkUGmHr1eMxt2VMe
        5Blkpry7rdoLblq9S5qxpjy1K0tDfqmAajvlhIzWx5sgyUhLCNv54F/2i/DwjVVkJxysad/I7X6
        x+u30BYjGfcd6Jh2MDxfRej1lriKkXLwtm0/T/c41VHP4fCovgjCNjbQPaq5iCuSPuSVW5+5d7Q
        PXAJ51ogngL/PVSBvRYQ+hUiwa86zlbHXjaXb4vwe06kQGFaIWMOhRB5C/8I/fc2Xd6VJ+yt3UU
        MDGwMwTsUAaGm+KM59SvI22waayflGHWGuC3y6xxi///JpaHQPdXhRKGhNdp4oij12xHbPuEgtI
        At1bntIigAsGa3qgmr+oXdOhZlrckfRhdidsajM5f9Xw/xqKXXJnzNw42kCxxEHRux+uk8h+ICq
        uNi0WJEV/DICM2gjrPys0GMqdZwrGDeLl/OqmhfugS5CQwb/XftwZ3X11IV0=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--7.168000-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25650.007
X-MDID: 1599495302-k5qSq_W2VBYX
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mostly just calls to existing common functions.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/ef100_ethtool.c | 41 ++++++++++++++++++++++++
 drivers/net/ethernet/sfc/ef100_netdev.c  |  4 +++
 drivers/net/ethernet/sfc/ef100_nic.c     |  7 +++-
 3 files changed, 51 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/ef100_ethtool.c b/drivers/net/ethernet/sfc/ef100_ethtool.c
index 729c425d0f78..835c838b7dfa 100644
--- a/drivers/net/ethernet/sfc/ef100_ethtool.c
+++ b/drivers/net/ethernet/sfc/ef100_ethtool.c
@@ -17,8 +17,49 @@
 #include "ef100_ethtool.h"
 #include "mcdi_functions.h"
 
+/* This is the maximum number of descriptor rings supported by the QDMA */
+#define EFX_EF100_MAX_DMAQ_SIZE 16384UL
+
+static void ef100_ethtool_get_ringparam(struct net_device *net_dev,
+					struct ethtool_ringparam *ring)
+{
+	struct efx_nic *efx = netdev_priv(net_dev);
+
+	ring->rx_max_pending = EFX_EF100_MAX_DMAQ_SIZE;
+	ring->tx_max_pending = EFX_EF100_MAX_DMAQ_SIZE;
+	ring->rx_pending = efx->rxq_entries;
+	ring->tx_pending = efx->txq_entries;
+}
+
 /*	Ethtool options available
  */
 const struct ethtool_ops ef100_ethtool_ops = {
 	.get_drvinfo		= efx_ethtool_get_drvinfo,
+	.get_msglevel		= efx_ethtool_get_msglevel,
+	.set_msglevel		= efx_ethtool_set_msglevel,
+	.get_pauseparam         = efx_ethtool_get_pauseparam,
+	.set_pauseparam         = efx_ethtool_set_pauseparam,
+	.get_sset_count		= efx_ethtool_get_sset_count,
+	.self_test		= efx_ethtool_self_test,
+	.get_strings		= efx_ethtool_get_strings,
+	.get_link_ksettings	= efx_ethtool_get_link_ksettings,
+	.set_link_ksettings	= efx_ethtool_set_link_ksettings,
+	.get_link		= ethtool_op_get_link,
+	.get_ringparam		= ef100_ethtool_get_ringparam,
+	.get_fecparam		= efx_ethtool_get_fecparam,
+	.set_fecparam		= efx_ethtool_set_fecparam,
+	.get_ethtool_stats	= efx_ethtool_get_stats,
+	.get_rxnfc              = efx_ethtool_get_rxnfc,
+	.set_rxnfc              = efx_ethtool_set_rxnfc,
+	.reset                  = efx_ethtool_reset,
+
+	.get_rxfh_indir_size	= efx_ethtool_get_rxfh_indir_size,
+	.get_rxfh_key_size	= efx_ethtool_get_rxfh_key_size,
+	.get_rxfh		= efx_ethtool_get_rxfh,
+	.set_rxfh		= efx_ethtool_set_rxfh,
+	.get_rxfh_context	= efx_ethtool_get_rxfh_context,
+	.set_rxfh_context	= efx_ethtool_set_rxfh_context,
+
+	.get_module_info	= efx_ethtool_get_module_info,
+	.get_module_eeprom	= efx_ethtool_get_module_eeprom,
 };
diff --git a/drivers/net/ethernet/sfc/ef100_netdev.c b/drivers/net/ethernet/sfc/ef100_netdev.c
index 63c311ba28b9..67fe44db6b61 100644
--- a/drivers/net/ethernet/sfc/ef100_netdev.c
+++ b/drivers/net/ethernet/sfc/ef100_netdev.c
@@ -217,9 +217,13 @@ static const struct net_device_ops ef100_netdev_ops = {
 	.ndo_open               = ef100_net_open,
 	.ndo_stop               = ef100_net_stop,
 	.ndo_start_xmit         = ef100_hard_start_xmit,
+	.ndo_tx_timeout         = efx_watchdog,
 	.ndo_get_stats64        = efx_net_stats,
+	.ndo_change_mtu         = efx_change_mtu,
 	.ndo_validate_addr      = eth_validate_addr,
+	.ndo_set_mac_address    = efx_set_mac_address,
 	.ndo_set_rx_mode        = efx_set_rx_mode, /* Lookout */
+	.ndo_set_features       = efx_set_features,
 	.ndo_get_phys_port_id   = efx_get_phys_port_id,
 	.ndo_get_phys_port_name = efx_get_phys_port_name,
 #ifdef CONFIG_RFS_ACCEL
diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index 9cf5b8f8fab9..fb7752d62ce0 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -684,7 +684,7 @@ static unsigned int ef100_check_caps(const struct efx_nic *efx,
 /*	NIC level access functions
  */
 #define EF100_OFFLOAD_FEATURES	(NETIF_F_HW_CSUM | NETIF_F_RXCSUM |	\
-	NETIF_F_HIGHDMA | NETIF_F_SG | NETIF_F_FRAGLIST |		\
+	NETIF_F_HIGHDMA | NETIF_F_SG | NETIF_F_FRAGLIST | NETIF_F_NTUPLE | \
 	NETIF_F_RXHASH | NETIF_F_RXFCS | NETIF_F_TSO_ECN | NETIF_F_RXALL | \
 	NETIF_F_TSO_MANGLEID | NETIF_F_HW_VLAN_CTAG_TX)
 
@@ -757,6 +757,7 @@ const struct efx_nic_type ef100_pf_nic_type = {
 	.rx_restore_rss_contexts = efx_mcdi_rx_restore_rss_contexts,
 
 	.reconfigure_mac = ef100_reconfigure_mac,
+	.reconfigure_port = efx_mcdi_port_reconfigure,
 	.test_nvram = efx_new_mcdi_nvram_test_all,
 	.describe_stats = ef100_describe_stats,
 	.start_stats = efx_mcdi_mac_start_stats,
@@ -1158,6 +1159,10 @@ static int ef100_probe_main(struct efx_nic *efx)
 		goto fail;
 	/* Reset (most) configuration for this function */
 	rc = efx_mcdi_reset(efx, RESET_TYPE_ALL);
+	if (rc)
+		goto fail;
+	/* Enable event logging */
+	rc = efx_mcdi_log_ctrl(efx, true, false, 0);
 	if (rc)
 		goto fail;
 

