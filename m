Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 234F4136E08
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 14:28:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727951AbgAJN2e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 08:28:34 -0500
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:58842 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727835AbgAJN2d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 08:28:33 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us3.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 951FC480064;
        Fri, 10 Jan 2020 13:28:32 +0000 (UTC)
Received: from amm-opti7060.uk.solarflarecom.com (10.17.20.147) by
 ukex01.SolarFlarecom.com (10.17.10.4) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 10 Jan 2020 13:28:27 +0000
From:   "Alex Maftei (amaftei)" <amaftei@solarflare.com>
Subject: [PATCH net-next 8/9] sfc: move yet more functions
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>
CC:     <linux-net-drivers@solarflare.com>, <scrum-linux@solarflare.com>
References: <95eb1347-0b8d-b8f7-3f32-cc4006a88303@solarflare.com>
Message-ID: <6ce2ac8b-9a59-9cc7-539d-0e8d4c2426e2@solarflare.com>
Date:   Fri, 10 Jan 2020 13:28:23 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <95eb1347-0b8d-b8f7-3f32-cc4006a88303@solarflare.com>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.147]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-25158.003
X-TM-AS-Result: No-5.823400-8.000000-10
X-TMASE-MatchedRID: quLY/TzSg7Ch9oPbMj7PPPCoOvLLtsMhP6Tki+9nU38HZBaLwEXlKGlF
        7OhYLlctUgWG15Uc3lfR/gCW3zphYqp6j8fdApwVydRP56yRRA+i8D/o42y/ShpX1zEL4nq37X6
        x+u30BYhqnO9psKKvH+adQ66dOqessdoCspOmzJZWfOVCJoTbWkqAhuLHn5fEOzrXChUtBASP4m
        /HHSQw+W0wftqo5QChGr7o1vK0faHFiifGreoVtkhwlOfYeSqx9fvWztwgm5MLFqt+tcr8+DqjN
        w4JUi0VHCAL7XkBDzaXMgn25/IXtqNNwGJVK9VSxd9CXnue78a+6m15psHd9VeIuu+Gkot81i/r
        klr8+so/5M3bvm/7z5GTpe1iiCJqb5ic6rRyh48LbigRnpKlKSPzRlrdFGDwTIoLHduaocTKOmv
        0MGwF1+xzpScWX9anvbANel51to0TN7VX9PRPJQ==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--5.823400-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25158.003
X-MDID: 1578662913-Lf0sOc6UwxSX
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Functions are not related.

Signed-off-by: Alexandru-Mihai Maftei <amaftei@solarflare.com>
---
 drivers/net/ethernet/sfc/ef10.c           | 20 +---------
 drivers/net/ethernet/sfc/efx.c            | 45 -----------------------
 drivers/net/ethernet/sfc/efx_common.c     | 45 +++++++++++++++++++++++
 drivers/net/ethernet/sfc/efx_common.h     |  2 +
 drivers/net/ethernet/sfc/mcdi_functions.c | 17 +++++++++
 drivers/net/ethernet/sfc/mcdi_functions.h |  1 +
 6 files changed, 66 insertions(+), 64 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index 6853b5cb3ac8..06045e181c8f 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -189,24 +189,6 @@ static bool efx_ef10_is_vf(struct efx_nic *efx)
 	return efx->type->is_vf;
 }
 
-static int efx_ef10_get_pf_index(struct efx_nic *efx)
-{
-	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_FUNCTION_INFO_OUT_LEN);
-	struct efx_ef10_nic_data *nic_data = efx->nic_data;
-	size_t outlen;
-	int rc;
-
-	rc = efx_mcdi_rpc(efx, MC_CMD_GET_FUNCTION_INFO, NULL, 0, outbuf,
-			  sizeof(outbuf), &outlen);
-	if (rc)
-		return rc;
-	if (outlen < sizeof(outbuf))
-		return -EIO;
-
-	nic_data->pf_index = MCDI_DWORD(outbuf, GET_FUNCTION_INFO_OUT_PF);
-	return 0;
-}
-
 #ifdef CONFIG_SFC_SRIOV
 static int efx_ef10_get_vf_index(struct efx_nic *efx)
 {
@@ -714,7 +696,7 @@ static int efx_ef10_probe(struct efx_nic *efx)
 	if (rc)
 		goto fail4;
 
-	rc = efx_ef10_get_pf_index(efx);
+	rc = efx_get_pf_index(efx, &nic_data->pf_index);
 	if (rc)
 		goto fail5;
 
diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index a997f3d720ab..87b784c207bd 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -695,51 +695,6 @@ static void efx_watchdog(struct net_device *net_dev, unsigned int txqueue)
 	efx_schedule_reset(efx, RESET_TYPE_TX_WATCHDOG);
 }
 
-static unsigned int efx_xdp_max_mtu(struct efx_nic *efx)
-{
-	/* The maximum MTU that we can fit in a single page, allowing for
-	 * framing, overhead and XDP headroom.
-	 */
-	int overhead = EFX_MAX_FRAME_LEN(0) + sizeof(struct efx_rx_page_state) +
-		       efx->rx_prefix_size + efx->type->rx_buffer_padding +
-		       efx->rx_ip_align + XDP_PACKET_HEADROOM;
-
-	return PAGE_SIZE - overhead;
-}
-
-/* Context: process, rtnl_lock() held. */
-static int efx_change_mtu(struct net_device *net_dev, int new_mtu)
-{
-	struct efx_nic *efx = netdev_priv(net_dev);
-	int rc;
-
-	rc = efx_check_disabled(efx);
-	if (rc)
-		return rc;
-
-	if (rtnl_dereference(efx->xdp_prog) &&
-	    new_mtu > efx_xdp_max_mtu(efx)) {
-		netif_err(efx, drv, efx->net_dev,
-			  "Requested MTU of %d too big for XDP (max: %d)\n",
-			  new_mtu, efx_xdp_max_mtu(efx));
-		return -EINVAL;
-	}
-
-	netif_dbg(efx, drv, efx->net_dev, "changing MTU to %d\n", new_mtu);
-
-	efx_device_detach_sync(efx);
-	efx_stop_all(efx);
-
-	mutex_lock(&efx->mac_lock);
-	net_dev->mtu = new_mtu;
-	efx_mac_reconfigure(efx);
-	mutex_unlock(&efx->mac_lock);
-
-	efx_start_all(efx);
-	efx_device_attach_if_not_resetting(efx);
-	return 0;
-}
-
 static int efx_set_mac_address(struct net_device *net_dev, void *data)
 {
 	struct efx_nic *efx = netdev_priv(net_dev);
diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index 0875507efd0a..ab0ce62f81c1 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -197,6 +197,51 @@ void efx_link_status_changed(struct efx_nic *efx)
 		netif_info(efx, link, efx->net_dev, "link down\n");
 }
 
+unsigned int efx_xdp_max_mtu(struct efx_nic *efx)
+{
+	/* The maximum MTU that we can fit in a single page, allowing for
+	 * framing, overhead and XDP headroom.
+	 */
+	int overhead = EFX_MAX_FRAME_LEN(0) + sizeof(struct efx_rx_page_state) +
+		       efx->rx_prefix_size + efx->type->rx_buffer_padding +
+		       efx->rx_ip_align + XDP_PACKET_HEADROOM;
+
+	return PAGE_SIZE - overhead;
+}
+
+/* Context: process, rtnl_lock() held. */
+int efx_change_mtu(struct net_device *net_dev, int new_mtu)
+{
+	struct efx_nic *efx = netdev_priv(net_dev);
+	int rc;
+
+	rc = efx_check_disabled(efx);
+	if (rc)
+		return rc;
+
+	if (rtnl_dereference(efx->xdp_prog) &&
+	    new_mtu > efx_xdp_max_mtu(efx)) {
+		netif_err(efx, drv, efx->net_dev,
+			  "Requested MTU of %d too big for XDP (max: %d)\n",
+			  new_mtu, efx_xdp_max_mtu(efx));
+		return -EINVAL;
+	}
+
+	netif_dbg(efx, drv, efx->net_dev, "changing MTU to %d\n", new_mtu);
+
+	efx_device_detach_sync(efx);
+	efx_stop_all(efx);
+
+	mutex_lock(&efx->mac_lock);
+	net_dev->mtu = new_mtu;
+	efx_mac_reconfigure(efx);
+	mutex_unlock(&efx->mac_lock);
+
+	efx_start_all(efx);
+	efx_device_attach_if_not_resetting(efx);
+	return 0;
+}
+
 /**************************************************************************
  *
  * Hardware monitor
diff --git a/drivers/net/ethernet/sfc/efx_common.h b/drivers/net/ethernet/sfc/efx_common.h
index 32a23ec9b104..fa2fc681e7f9 100644
--- a/drivers/net/ethernet/sfc/efx_common.h
+++ b/drivers/net/ethernet/sfc/efx_common.h
@@ -67,5 +67,7 @@ static inline void efx_fini_mcdi_logging(struct efx_nic *efx) {}
 
 void efx_mac_reconfigure(struct efx_nic *efx);
 void efx_link_status_changed(struct efx_nic *efx);
+unsigned int efx_xdp_max_mtu(struct efx_nic *efx);
+int efx_change_mtu(struct net_device *net_dev, int new_mtu);
 
 #endif
diff --git a/drivers/net/ethernet/sfc/mcdi_functions.c b/drivers/net/ethernet/sfc/mcdi_functions.c
index 0f571864df22..f5dad8bffc3d 100644
--- a/drivers/net/ethernet/sfc/mcdi_functions.c
+++ b/drivers/net/ethernet/sfc/mcdi_functions.c
@@ -370,3 +370,20 @@ int efx_mcdi_window_mode_to_stride(struct efx_nic *efx, u8 vi_window_mode)
 		  efx->vi_stride);
 	return 0;
 }
+
+int efx_get_pf_index(struct efx_nic *efx, unsigned int *pf_index)
+{
+	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_FUNCTION_INFO_OUT_LEN);
+	size_t outlen;
+	int rc;
+
+	rc = efx_mcdi_rpc(efx, MC_CMD_GET_FUNCTION_INFO, NULL, 0, outbuf,
+			  sizeof(outbuf), &outlen);
+	if (rc)
+		return rc;
+	if (outlen < sizeof(outbuf))
+		return -EIO;
+
+	*pf_index = MCDI_DWORD(outbuf, GET_FUNCTION_INFO_OUT_PF);
+	return 0;
+}
diff --git a/drivers/net/ethernet/sfc/mcdi_functions.h b/drivers/net/ethernet/sfc/mcdi_functions.h
index 0396294bfdcd..ca4a5ac1a66b 100644
--- a/drivers/net/ethernet/sfc/mcdi_functions.h
+++ b/drivers/net/ethernet/sfc/mcdi_functions.h
@@ -27,5 +27,6 @@ void efx_mcdi_rx_init(struct efx_rx_queue *rx_queue);
 void efx_mcdi_rx_remove(struct efx_rx_queue *rx_queue);
 void efx_mcdi_rx_fini(struct efx_rx_queue *rx_queue);
 int efx_mcdi_window_mode_to_stride(struct efx_nic *efx, u8 vi_window_mode);
+int efx_get_pf_index(struct efx_nic *efx, unsigned int *pf_index);
 
 #endif
-- 
2.20.1


