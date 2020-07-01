Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77C6E210E1D
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 16:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731679AbgGAOym (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 10:54:42 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:58192 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731518AbgGAOym (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 10:54:42 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.62])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 51C1E600BD;
        Wed,  1 Jul 2020 14:54:41 +0000 (UTC)
Received: from us4-mdac16-66.ut7.mdlocal (unknown [10.7.64.78])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 514798009E;
        Wed,  1 Jul 2020 14:54:41 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.38])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id BBEA528005F;
        Wed,  1 Jul 2020 14:54:40 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 4ACB8800084;
        Wed,  1 Jul 2020 14:54:40 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 1 Jul 2020
 15:54:35 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 10/15] sfc: commonise efx_fini_dmaq
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <3fa88508-024e-2d33-0629-bf63b558b515@solarflare.com>
Message-ID: <1ff33bf5-dacc-fc8f-42ea-bf1ba542de15@solarflare.com>
Date:   Wed, 1 Jul 2020 15:54:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <3fa88508-024e-2d33-0629-bf63b558b515@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25514.003
X-TM-AS-Result: No-6.299600-8.000000-10
X-TMASE-MatchedRID: QFyfAhreVwGh9oPbMj7PPPCoOvLLtsMhP6Tki+9nU38HZBaLwEXlKGlF
        7OhYLlctcWdCnWagr3HhYOxef3ODUzmzjEr3tKb/R/j040fRFpIApu/OILCbuBLf1vz7ecPHujE
        nt/RIabes/MpHYhOcngfuv7WrubShwKhfn+V6PFttawJSSsDgSbp0somlfE2zdLv/+WrG6tN7qL
        CJ87oUjM9C3Lx6G+XHlMaIBm0udyhlJTodqNqEzobV85w+dhNKvupteabB3fVXiLrvhpKLfBrme
        nnBFCn94vM1YF6AJbZFi+KwZZttL42j49Ftap9EOwBXM346/+zRL+Z3gBcDwe1faRdoFPMYd0QK
        gmoqggxdDud2ghJMsGBl0sCralq+
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--6.299600-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25514.003
X-MDID: 1593615281-ODDMnkA5JSyQ
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/ef10.c           | 42 ++---------------------
 drivers/net/ethernet/sfc/mcdi_functions.c | 38 ++++++++++++++++++++
 drivers/net/ethernet/sfc/mcdi_functions.h |  1 +
 3 files changed, 41 insertions(+), 40 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index 790a1f516a15..788a562212b1 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -3117,44 +3117,6 @@ static void efx_ef10_ev_test_generate(struct efx_channel *channel)
 	netif_err(efx, hw, efx->net_dev, "%s: failed rc=%d\n", __func__, rc);
 }
 
-static int efx_ef10_fini_dmaq(struct efx_nic *efx)
-{
-	struct efx_tx_queue *tx_queue;
-	struct efx_rx_queue *rx_queue;
-	struct efx_channel *channel;
-	int pending;
-
-	/* If the MC has just rebooted, the TX/RX queues will have already been
-	 * torn down, but efx->active_queues needs to be set to zero.
-	 */
-	if (efx->must_realloc_vis) {
-		atomic_set(&efx->active_queues, 0);
-		return 0;
-	}
-
-	/* Do not attempt to write to the NIC during EEH recovery */
-	if (efx->state != STATE_RECOVERY) {
-		efx_for_each_channel(channel, efx) {
-			efx_for_each_channel_rx_queue(rx_queue, channel)
-				efx_mcdi_rx_fini(rx_queue);
-			efx_for_each_channel_tx_queue(tx_queue, channel)
-				efx_mcdi_tx_fini(tx_queue);
-		}
-
-		wait_event_timeout(efx->flush_wq,
-				   atomic_read(&efx->active_queues) == 0,
-				   msecs_to_jiffies(EFX_MAX_FLUSH_TIME));
-		pending = atomic_read(&efx->active_queues);
-		if (pending) {
-			netif_err(efx, hw, efx->net_dev, "failed to flush %d queues\n",
-				  pending);
-			return -ETIMEDOUT;
-		}
-	}
-
-	return 0;
-}
-
 static void efx_ef10_prepare_flr(struct efx_nic *efx)
 {
 	atomic_set(&efx->active_queues, 0);
@@ -4029,7 +3991,7 @@ const struct efx_nic_type efx_hunt_a0_vf_nic_type = {
 	.reset = efx_ef10_reset,
 	.probe_port = efx_mcdi_port_probe,
 	.remove_port = efx_mcdi_port_remove,
-	.fini_dmaq = efx_ef10_fini_dmaq,
+	.fini_dmaq = efx_fini_dmaq,
 	.prepare_flr = efx_ef10_prepare_flr,
 	.finish_flr = efx_port_dummy_op_void,
 	.describe_stats = efx_ef10_describe_stats,
@@ -4137,7 +4099,7 @@ const struct efx_nic_type efx_hunt_a0_nic_type = {
 	.reset = efx_ef10_reset,
 	.probe_port = efx_mcdi_port_probe,
 	.remove_port = efx_mcdi_port_remove,
-	.fini_dmaq = efx_ef10_fini_dmaq,
+	.fini_dmaq = efx_fini_dmaq,
 	.prepare_flr = efx_ef10_prepare_flr,
 	.finish_flr = efx_port_dummy_op_void,
 	.describe_stats = efx_ef10_describe_stats,
diff --git a/drivers/net/ethernet/sfc/mcdi_functions.c b/drivers/net/ethernet/sfc/mcdi_functions.c
index b3a8aa88db06..92b9a741c286 100644
--- a/drivers/net/ethernet/sfc/mcdi_functions.c
+++ b/drivers/net/ethernet/sfc/mcdi_functions.c
@@ -341,6 +341,44 @@ void efx_mcdi_rx_fini(struct efx_rx_queue *rx_queue)
 			       outbuf, outlen, rc);
 }
 
+int efx_fini_dmaq(struct efx_nic *efx)
+{
+	struct efx_tx_queue *tx_queue;
+	struct efx_rx_queue *rx_queue;
+	struct efx_channel *channel;
+	int pending;
+
+	/* If the MC has just rebooted, the TX/RX queues will have already been
+	 * torn down, but efx->active_queues needs to be set to zero.
+	 */
+	if (efx->must_realloc_vis) {
+		atomic_set(&efx->active_queues, 0);
+		return 0;
+	}
+
+	/* Do not attempt to write to the NIC during EEH recovery */
+	if (efx->state != STATE_RECOVERY) {
+		efx_for_each_channel(channel, efx) {
+			efx_for_each_channel_rx_queue(rx_queue, channel)
+				efx_mcdi_rx_fini(rx_queue);
+			efx_for_each_channel_tx_queue(tx_queue, channel)
+				efx_mcdi_tx_fini(tx_queue);
+		}
+
+		wait_event_timeout(efx->flush_wq,
+				   atomic_read(&efx->active_queues) == 0,
+				   msecs_to_jiffies(EFX_MAX_FLUSH_TIME));
+		pending = atomic_read(&efx->active_queues);
+		if (pending) {
+			netif_err(efx, hw, efx->net_dev, "failed to flush %d queues\n",
+				  pending);
+			return -ETIMEDOUT;
+		}
+	}
+
+	return 0;
+}
+
 int efx_mcdi_window_mode_to_stride(struct efx_nic *efx, u8 vi_window_mode)
 {
 	switch (vi_window_mode) {
diff --git a/drivers/net/ethernet/sfc/mcdi_functions.h b/drivers/net/ethernet/sfc/mcdi_functions.h
index ca4a5ac1a66b..687be8b00cd8 100644
--- a/drivers/net/ethernet/sfc/mcdi_functions.h
+++ b/drivers/net/ethernet/sfc/mcdi_functions.h
@@ -26,6 +26,7 @@ int efx_mcdi_rx_probe(struct efx_rx_queue *rx_queue);
 void efx_mcdi_rx_init(struct efx_rx_queue *rx_queue);
 void efx_mcdi_rx_remove(struct efx_rx_queue *rx_queue);
 void efx_mcdi_rx_fini(struct efx_rx_queue *rx_queue);
+int efx_fini_dmaq(struct efx_nic *efx);
 int efx_mcdi_window_mode_to_stride(struct efx_nic *efx, u8 vi_window_mode);
 int efx_get_pf_index(struct efx_nic *efx, unsigned int *pf_index);
 

