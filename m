Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BB1920F41A
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 14:03:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733296AbgF3MDJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 08:03:09 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:41058 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729647AbgF3MDI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 08:03:08 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.60])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id C402D6009B;
        Tue, 30 Jun 2020 12:03:07 +0000 (UTC)
Received: from us4-mdac16-61.ut7.mdlocal (unknown [10.7.66.58])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id C2A2C2009A;
        Tue, 30 Jun 2020 12:03:07 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.36])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 4BB321C0052;
        Tue, 30 Jun 2020 12:03:07 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 0157AB4008A;
        Tue, 30 Jun 2020 12:03:07 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 30 Jun
 2020 13:02:59 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 02/14] sfc: commonise MCDI MAC stats handling
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <14a93b71-3d4e-4663-82be-a2281cd1105e@solarflare.com>
Message-ID: <57fe362d-3484-211a-85f2-71093c6733f9@solarflare.com>
Date:   Tue, 30 Jun 2020 13:02:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <14a93b71-3d4e-4663-82be-a2281cd1105e@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25512.003
X-TM-AS-Result: No-2.710700-8.000000-10
X-TMASE-MatchedRID: LLuk46qspz+h9oPbMj7PPPCoOvLLtsMhP6Tki+9nU38HZBaLwEXlKCzy
        bVqWyY2Nt2xdJtKGhfeA09CmksvZPcFBoCgEV4LyU8KO1ajdBDzYuVu0X/rOkNlQi8bdhFy+q3c
        ttlDobAyBBOV1lQPMkgbLpwFD9LrSDp/ENh8slsBTLFbi+a8u3am9/6ObPjnDGP0M/F8V3KgGBC
        u+/kGwD2CDgyxr6iiknFuZBk6z1w68U6c9s1viyQ/5L1pUR3v2XGjQf7uckKtOS1V6oZBCu34OF
        rQCV6cJ5WAS33a1RrIm7Z/9ET2jm83f9xf5QhHOngIgpj8eDcC063Wh9WVqgtZE3xJMmmXc+gtH
        j7OwNO2eVW/ZdL52j03ET5lhD/AKArW7f5RpipAttTiwN+2CNuBrcfLdRR2VyFTlprNAwgpcJU7
        Oua2tkGTRgHR9FhNN+B0fgjy0tTLRLOBGZTwYFXzm6hivSaZZop2lf3StGhISt1bcvKF7ZKbNmF
        ZyaXzY
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--2.710700-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25512.003
X-MDID: 1593518587-fTSTLlbgh6rL
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Most of it was already declared in mcdi_port_common.h, so just move the
 implementations to mcdi_port_common.c.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/mcdi_port.c        |  91 +----------------
 drivers/net/ethernet/sfc/mcdi_port_common.c | 105 ++++++++++++++++++++
 drivers/net/ethernet/sfc/mcdi_port_common.h |   2 +
 3 files changed, 109 insertions(+), 89 deletions(-)

diff --git a/drivers/net/ethernet/sfc/mcdi_port.c b/drivers/net/ethernet/sfc/mcdi_port.c
index 212ff80e923b..133f8b8ec3b3 100644
--- a/drivers/net/ethernet/sfc/mcdi_port.c
+++ b/drivers/net/ethernet/sfc/mcdi_port.c
@@ -692,80 +692,6 @@ bool efx_mcdi_mac_check_fault(struct efx_nic *efx)
 	return MCDI_DWORD(outbuf, GET_LINK_OUT_MAC_FAULT) != 0;
 }
 
-enum efx_stats_action {
-	EFX_STATS_ENABLE,
-	EFX_STATS_DISABLE,
-	EFX_STATS_PULL,
-};
-
-static int efx_mcdi_mac_stats(struct efx_nic *efx,
-			      enum efx_stats_action action, int clear)
-{
-	MCDI_DECLARE_BUF(inbuf, MC_CMD_MAC_STATS_IN_LEN);
-	int rc;
-	int change = action == EFX_STATS_PULL ? 0 : 1;
-	int enable = action == EFX_STATS_ENABLE ? 1 : 0;
-	int period = action == EFX_STATS_ENABLE ? 1000 : 0;
-	dma_addr_t dma_addr = efx->stats_buffer.dma_addr;
-	u32 dma_len = action != EFX_STATS_DISABLE ?
-		efx->num_mac_stats * sizeof(u64) : 0;
-
-	BUILD_BUG_ON(MC_CMD_MAC_STATS_OUT_DMA_LEN != 0);
-
-	MCDI_SET_QWORD(inbuf, MAC_STATS_IN_DMA_ADDR, dma_addr);
-	MCDI_POPULATE_DWORD_7(inbuf, MAC_STATS_IN_CMD,
-			      MAC_STATS_IN_DMA, !!enable,
-			      MAC_STATS_IN_CLEAR, clear,
-			      MAC_STATS_IN_PERIODIC_CHANGE, change,
-			      MAC_STATS_IN_PERIODIC_ENABLE, enable,
-			      MAC_STATS_IN_PERIODIC_CLEAR, 0,
-			      MAC_STATS_IN_PERIODIC_NOEVENT, 1,
-			      MAC_STATS_IN_PERIOD_MS, period);
-	MCDI_SET_DWORD(inbuf, MAC_STATS_IN_DMA_LEN, dma_len);
-
-	if (efx_nic_rev(efx) >= EFX_REV_HUNT_A0)
-		MCDI_SET_DWORD(inbuf, MAC_STATS_IN_PORT_ID, efx->vport_id);
-
-	rc = efx_mcdi_rpc_quiet(efx, MC_CMD_MAC_STATS, inbuf, sizeof(inbuf),
-				NULL, 0, NULL);
-	/* Expect ENOENT if DMA queues have not been set up */
-	if (rc && (rc != -ENOENT || atomic_read(&efx->active_queues)))
-		efx_mcdi_display_error(efx, MC_CMD_MAC_STATS, sizeof(inbuf),
-				       NULL, 0, rc);
-	return rc;
-}
-
-void efx_mcdi_mac_start_stats(struct efx_nic *efx)
-{
-	__le64 *dma_stats = efx->stats_buffer.addr;
-
-	dma_stats[efx->num_mac_stats - 1] = EFX_MC_STATS_GENERATION_INVALID;
-
-	efx_mcdi_mac_stats(efx, EFX_STATS_ENABLE, 0);
-}
-
-void efx_mcdi_mac_stop_stats(struct efx_nic *efx)
-{
-	efx_mcdi_mac_stats(efx, EFX_STATS_DISABLE, 0);
-}
-
-#define EFX_MAC_STATS_WAIT_US 100
-#define EFX_MAC_STATS_WAIT_ATTEMPTS 10
-
-void efx_mcdi_mac_pull_stats(struct efx_nic *efx)
-{
-	__le64 *dma_stats = efx->stats_buffer.addr;
-	int attempts = EFX_MAC_STATS_WAIT_ATTEMPTS;
-
-	dma_stats[efx->num_mac_stats - 1] = EFX_MC_STATS_GENERATION_INVALID;
-	efx_mcdi_mac_stats(efx, EFX_STATS_PULL, 0);
-
-	while (dma_stats[efx->num_mac_stats - 1] ==
-				EFX_MC_STATS_GENERATION_INVALID &&
-			attempts-- != 0)
-		udelay(EFX_MAC_STATS_WAIT_US);
-}
-
 int efx_mcdi_port_probe(struct efx_nic *efx)
 {
 	int rc;
@@ -783,24 +709,11 @@ int efx_mcdi_port_probe(struct efx_nic *efx)
 	if (rc != 0)
 		return rc;
 
-	/* Allocate buffer for stats */
-	rc = efx_nic_alloc_buffer(efx, &efx->stats_buffer,
-				  efx->num_mac_stats * sizeof(u64), GFP_KERNEL);
-	if (rc)
-		return rc;
-	netif_dbg(efx, probe, efx->net_dev,
-		  "stats buffer at %llx (virt %p phys %llx)\n",
-		  (u64)efx->stats_buffer.dma_addr,
-		  efx->stats_buffer.addr,
-		  (u64)virt_to_phys(efx->stats_buffer.addr));
-
-	efx_mcdi_mac_stats(efx, EFX_STATS_DISABLE, 1);
-
-	return 0;
+	return efx_mcdi_mac_init_stats(efx);
 }
 
 void efx_mcdi_port_remove(struct efx_nic *efx)
 {
 	efx->phy_op->remove(efx);
-	efx_nic_free_buffer(efx, &efx->stats_buffer);
+	efx_mcdi_mac_fini_stats(efx);
 }
diff --git a/drivers/net/ethernet/sfc/mcdi_port_common.c b/drivers/net/ethernet/sfc/mcdi_port_common.c
index a6a072ba46d3..e0608d0d961b 100644
--- a/drivers/net/ethernet/sfc/mcdi_port_common.c
+++ b/drivers/net/ethernet/sfc/mcdi_port_common.c
@@ -10,6 +10,7 @@
 
 #include "mcdi_port_common.h"
 #include "efx_common.h"
+#include "nic.h"
 
 int efx_mcdi_get_phy_cfg(struct efx_nic *efx, struct efx_mcdi_phy_data *cfg)
 {
@@ -520,6 +521,110 @@ int efx_mcdi_set_mac(struct efx_nic *efx)
 			    NULL, 0, NULL);
 }
 
+enum efx_stats_action {
+	EFX_STATS_ENABLE,
+	EFX_STATS_DISABLE,
+	EFX_STATS_PULL,
+};
+
+static int efx_mcdi_mac_stats(struct efx_nic *efx,
+			      enum efx_stats_action action, int clear)
+{
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_MAC_STATS_IN_LEN);
+	int rc;
+	int change = action == EFX_STATS_PULL ? 0 : 1;
+	int enable = action == EFX_STATS_ENABLE ? 1 : 0;
+	int period = action == EFX_STATS_ENABLE ? 1000 : 0;
+	dma_addr_t dma_addr = efx->stats_buffer.dma_addr;
+	u32 dma_len = action != EFX_STATS_DISABLE ?
+		efx->num_mac_stats * sizeof(u64) : 0;
+
+	BUILD_BUG_ON(MC_CMD_MAC_STATS_OUT_DMA_LEN != 0);
+
+	MCDI_SET_QWORD(inbuf, MAC_STATS_IN_DMA_ADDR, dma_addr);
+	MCDI_POPULATE_DWORD_7(inbuf, MAC_STATS_IN_CMD,
+			      MAC_STATS_IN_DMA, !!enable,
+			      MAC_STATS_IN_CLEAR, clear,
+			      MAC_STATS_IN_PERIODIC_CHANGE, change,
+			      MAC_STATS_IN_PERIODIC_ENABLE, enable,
+			      MAC_STATS_IN_PERIODIC_CLEAR, 0,
+			      MAC_STATS_IN_PERIODIC_NOEVENT, 1,
+			      MAC_STATS_IN_PERIOD_MS, period);
+	MCDI_SET_DWORD(inbuf, MAC_STATS_IN_DMA_LEN, dma_len);
+
+	if (efx_nic_rev(efx) >= EFX_REV_HUNT_A0)
+		MCDI_SET_DWORD(inbuf, MAC_STATS_IN_PORT_ID, efx->vport_id);
+
+	rc = efx_mcdi_rpc_quiet(efx, MC_CMD_MAC_STATS, inbuf, sizeof(inbuf),
+				NULL, 0, NULL);
+	/* Expect ENOENT if DMA queues have not been set up */
+	if (rc && (rc != -ENOENT || atomic_read(&efx->active_queues)))
+		efx_mcdi_display_error(efx, MC_CMD_MAC_STATS, sizeof(inbuf),
+				       NULL, 0, rc);
+	return rc;
+}
+
+void efx_mcdi_mac_start_stats(struct efx_nic *efx)
+{
+	__le64 *dma_stats = efx->stats_buffer.addr;
+
+	dma_stats[efx->num_mac_stats - 1] = EFX_MC_STATS_GENERATION_INVALID;
+
+	efx_mcdi_mac_stats(efx, EFX_STATS_ENABLE, 0);
+}
+
+void efx_mcdi_mac_stop_stats(struct efx_nic *efx)
+{
+	efx_mcdi_mac_stats(efx, EFX_STATS_DISABLE, 0);
+}
+
+#define EFX_MAC_STATS_WAIT_US 100
+#define EFX_MAC_STATS_WAIT_ATTEMPTS 10
+
+void efx_mcdi_mac_pull_stats(struct efx_nic *efx)
+{
+	__le64 *dma_stats = efx->stats_buffer.addr;
+	int attempts = EFX_MAC_STATS_WAIT_ATTEMPTS;
+
+	dma_stats[efx->num_mac_stats - 1] = EFX_MC_STATS_GENERATION_INVALID;
+	efx_mcdi_mac_stats(efx, EFX_STATS_PULL, 0);
+
+	while (dma_stats[efx->num_mac_stats - 1] ==
+				EFX_MC_STATS_GENERATION_INVALID &&
+			attempts-- != 0)
+		udelay(EFX_MAC_STATS_WAIT_US);
+}
+
+int efx_mcdi_mac_init_stats(struct efx_nic *efx)
+{
+	int rc;
+
+	if (!efx->num_mac_stats)
+		return 0;
+
+	/* Allocate buffer for stats */
+	rc = efx_nic_alloc_buffer(efx, &efx->stats_buffer,
+				  efx->num_mac_stats * sizeof(u64), GFP_KERNEL);
+	if (rc) {
+		netif_warn(efx, probe, efx->net_dev,
+			   "failed to allocate DMA buffer: %d\n", rc);
+		return rc;
+	}
+
+	netif_dbg(efx, probe, efx->net_dev,
+		  "stats buffer at %llx (virt %p phys %llx)\n",
+		  (u64) efx->stats_buffer.dma_addr,
+		  efx->stats_buffer.addr,
+		  (u64) virt_to_phys(efx->stats_buffer.addr));
+
+	return 0;
+}
+
+void efx_mcdi_mac_fini_stats(struct efx_nic *efx)
+{
+	efx_nic_free_buffer(efx, &efx->stats_buffer);
+}
+
 /* Get physical port number (EF10 only; on Siena it is same as PF number) */
 int efx_mcdi_port_get_number(struct efx_nic *efx)
 {
diff --git a/drivers/net/ethernet/sfc/mcdi_port_common.h b/drivers/net/ethernet/sfc/mcdi_port_common.h
index b16f11265269..54c0acf8e243 100644
--- a/drivers/net/ethernet/sfc/mcdi_port_common.h
+++ b/drivers/net/ethernet/sfc/mcdi_port_common.h
@@ -51,6 +51,8 @@ int efx_mcdi_phy_get_fecparam(struct efx_nic *efx,
 			      struct ethtool_fecparam *fec);
 int efx_mcdi_phy_test_alive(struct efx_nic *efx);
 int efx_mcdi_set_mac(struct efx_nic *efx);
+int efx_mcdi_mac_init_stats(struct efx_nic *efx);
+void efx_mcdi_mac_fini_stats(struct efx_nic *efx);
 int efx_mcdi_port_get_number(struct efx_nic *efx);
 void efx_mcdi_process_link_change(struct efx_nic *efx, efx_qword_t *ev);
 

