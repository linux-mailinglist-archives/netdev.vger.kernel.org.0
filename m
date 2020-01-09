Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C105135D23
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 16:46:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730948AbgAIPp0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 10:45:26 -0500
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:33522 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728293AbgAIPp0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 10:45:26 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 42E3240005C;
        Thu,  9 Jan 2020 15:45:24 +0000 (UTC)
Received: from amm-opti7060.uk.solarflarecom.com (10.17.20.147) by
 ukex01.SolarFlarecom.com (10.17.10.4) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Thu, 9 Jan 2020 15:45:19 +0000
From:   "Alex Maftei (amaftei)" <amaftei@solarflare.com>
Subject: [PATCH net-next 7/9] sfc: move MCDI receive queue management code
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>
CC:     <linux-net-drivers@solarflare.com>, <scrum-linux@solarflare.com>
References: <4d915542-3699-e864-5558-bef616b2fe66@solarflare.com>
Message-ID: <092df53b-1e33-0659-ba61-d602a0112cde@solarflare.com>
Date:   Thu, 9 Jan 2020 15:45:15 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <4d915542-3699-e864-5558-bef616b2fe66@solarflare.com>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.147]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-25156.003
X-TM-AS-Result: No-4.622300-8.000000-10
X-TMASE-MatchedRID: gDKYV1z5qxqcJOjqgavgM5K9FvwQx1hFeouvej40T4gd0WOKRkwsh1ym
        Rv3NQjsEfGzuoVn0Vs6PQi9XuOWoOHI/MxNRI7UkR/j040fRFpJ99ekRHlOQkY+Ixb7djOSCcJj
        /63vxb+aH9eJA08ufnrdmZ+t48sNQTIunQAI8qaKiAZ3zAhQYgqIik2/euMx1R2YNIFh+clF3Xb
        g5u5YBp3y9TPc1V7Ss+5pyml5tX6L56DmUCLEExepKEpRpjeYiGEfoClqBl866pZ/o2Hu2YXjm0
        APnwZU2fhmJ9GaO1RQfHS8wUUuW9UdRJVfWCtkwZRwOP3rSfq+imxpEbADEvJsoi2XrUn/JyeMt
        MD9QOgAYvR9ppOlv1o6HM5rqDwqtiCyixD7AHZURludRZQDt5ytQmx6LXr4e5LPhAE4N1aYAQ+K
        4Sh6HXYZ5+vRu78EgwMPu02WE+FtO//fZp8o71MFwyx69Aj0AF8WOpmrvCxtyCYeHQXFONn+IaU
        6aARfSasRgksxQ/TKwzFr1189Za5RMZUCEHkRt
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--4.622300-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25156.003
X-MDID: 1578584725-7cDSnCKWEAWN
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

One function's prototype was changed in the header.

Signed-off-by: Alexandru-Mihai Maftei <amaftei@solarflare.com>
---
 drivers/net/ethernet/sfc/ef10.c           | 99 ++---------------------
 drivers/net/ethernet/sfc/mcdi_functions.c | 85 +++++++++++++++++++
 drivers/net/ethernet/sfc/mcdi_functions.h |  2 +-
 3 files changed, 93 insertions(+), 93 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index aeb6c2059eb1..dc037dd927f8 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -2967,91 +2967,6 @@ static int efx_ef10_vf_rx_push_rss_config(struct efx_nic *efx, bool user,
 	return efx_ef10_rx_push_shared_rss_config(efx, NULL);
 }
 
-static int efx_ef10_rx_probe(struct efx_rx_queue *rx_queue)
-{
-	return efx_nic_alloc_buffer(rx_queue->efx, &rx_queue->rxd.buf,
-				    (rx_queue->ptr_mask + 1) *
-				    sizeof(efx_qword_t),
-				    GFP_KERNEL);
-}
-
-static void efx_ef10_rx_init(struct efx_rx_queue *rx_queue)
-{
-	MCDI_DECLARE_BUF(inbuf,
-			 MC_CMD_INIT_RXQ_IN_LEN(EFX_MAX_DMAQ_SIZE * 8 /
-						EFX_BUF_SIZE));
-	struct efx_channel *channel = efx_rx_queue_channel(rx_queue);
-	size_t entries = rx_queue->rxd.buf.len / EFX_BUF_SIZE;
-	struct efx_nic *efx = rx_queue->efx;
-	struct efx_ef10_nic_data *nic_data = efx->nic_data;
-	size_t inlen;
-	dma_addr_t dma_addr;
-	int rc;
-	int i;
-	BUILD_BUG_ON(MC_CMD_INIT_RXQ_OUT_LEN != 0);
-
-	rx_queue->scatter_n = 0;
-	rx_queue->scatter_len = 0;
-
-	MCDI_SET_DWORD(inbuf, INIT_RXQ_IN_SIZE, rx_queue->ptr_mask + 1);
-	MCDI_SET_DWORD(inbuf, INIT_RXQ_IN_TARGET_EVQ, channel->channel);
-	MCDI_SET_DWORD(inbuf, INIT_RXQ_IN_LABEL, efx_rx_queue_index(rx_queue));
-	MCDI_SET_DWORD(inbuf, INIT_RXQ_IN_INSTANCE,
-		       efx_rx_queue_index(rx_queue));
-	MCDI_POPULATE_DWORD_2(inbuf, INIT_RXQ_IN_FLAGS,
-			      INIT_RXQ_IN_FLAG_PREFIX, 1,
-			      INIT_RXQ_IN_FLAG_TIMESTAMP, 1);
-	MCDI_SET_DWORD(inbuf, INIT_RXQ_IN_OWNER_ID, 0);
-	MCDI_SET_DWORD(inbuf, INIT_RXQ_IN_PORT_ID, nic_data->vport_id);
-
-	dma_addr = rx_queue->rxd.buf.dma_addr;
-
-	netif_dbg(efx, hw, efx->net_dev, "pushing RXQ %d. %zu entries (%llx)\n",
-		  efx_rx_queue_index(rx_queue), entries, (u64)dma_addr);
-
-	for (i = 0; i < entries; ++i) {
-		MCDI_SET_ARRAY_QWORD(inbuf, INIT_RXQ_IN_DMA_ADDR, i, dma_addr);
-		dma_addr += EFX_BUF_SIZE;
-	}
-
-	inlen = MC_CMD_INIT_RXQ_IN_LEN(entries);
-
-	rc = efx_mcdi_rpc(efx, MC_CMD_INIT_RXQ, inbuf, inlen,
-			  NULL, 0, NULL);
-	if (rc)
-		netdev_WARN(efx->net_dev, "failed to initialise RXQ %d\n",
-			    efx_rx_queue_index(rx_queue));
-}
-
-static void efx_ef10_rx_fini(struct efx_rx_queue *rx_queue)
-{
-	MCDI_DECLARE_BUF(inbuf, MC_CMD_FINI_RXQ_IN_LEN);
-	MCDI_DECLARE_BUF_ERR(outbuf);
-	struct efx_nic *efx = rx_queue->efx;
-	size_t outlen;
-	int rc;
-
-	MCDI_SET_DWORD(inbuf, FINI_RXQ_IN_INSTANCE,
-		       efx_rx_queue_index(rx_queue));
-
-	rc = efx_mcdi_rpc_quiet(efx, MC_CMD_FINI_RXQ, inbuf, sizeof(inbuf),
-			  outbuf, sizeof(outbuf), &outlen);
-
-	if (rc && rc != -EALREADY)
-		goto fail;
-
-	return;
-
-fail:
-	efx_mcdi_display_error(efx, MC_CMD_FINI_RXQ, MC_CMD_FINI_RXQ_IN_LEN,
-			       outbuf, outlen, rc);
-}
-
-static void efx_ef10_rx_remove(struct efx_rx_queue *rx_queue)
-{
-	efx_nic_free_buffer(rx_queue->efx, &rx_queue->rxd.buf);
-}
-
 /* This creates an entry in the RX descriptor queue */
 static inline void
 efx_ef10_build_rx_desc(struct efx_rx_queue *rx_queue, unsigned int index)
@@ -3779,7 +3694,7 @@ static int efx_ef10_fini_dmaq(struct efx_nic *efx)
 	if (efx->state != STATE_RECOVERY) {
 		efx_for_each_channel(channel, efx) {
 			efx_for_each_channel_rx_queue(rx_queue, channel)
-				efx_ef10_rx_fini(rx_queue);
+				efx_mcdi_rx_fini(rx_queue);
 			efx_for_each_channel_tx_queue(tx_queue, channel)
 				efx_mcdi_tx_fini(tx_queue);
 		}
@@ -6458,9 +6373,9 @@ const struct efx_nic_type efx_hunt_a0_vf_nic_type = {
 	.tx_limit_len = efx_ef10_tx_limit_len,
 	.rx_push_rss_config = efx_ef10_vf_rx_push_rss_config,
 	.rx_pull_rss_config = efx_ef10_rx_pull_rss_config,
-	.rx_probe = efx_ef10_rx_probe,
-	.rx_init = efx_ef10_rx_init,
-	.rx_remove = efx_ef10_rx_remove,
+	.rx_probe = efx_mcdi_rx_probe,
+	.rx_init = efx_mcdi_rx_init,
+	.rx_remove = efx_mcdi_rx_remove,
 	.rx_write = efx_ef10_rx_write,
 	.rx_defer_refill = efx_ef10_rx_defer_refill,
 	.ev_probe = efx_mcdi_ev_probe,
@@ -6570,9 +6485,9 @@ const struct efx_nic_type efx_hunt_a0_nic_type = {
 	.rx_push_rss_context_config = efx_ef10_rx_push_rss_context_config,
 	.rx_pull_rss_context_config = efx_ef10_rx_pull_rss_context_config,
 	.rx_restore_rss_contexts = efx_ef10_rx_restore_rss_contexts,
-	.rx_probe = efx_ef10_rx_probe,
-	.rx_init = efx_ef10_rx_init,
-	.rx_remove = efx_ef10_rx_remove,
+	.rx_probe = efx_mcdi_rx_probe,
+	.rx_init = efx_mcdi_rx_init,
+	.rx_remove = efx_mcdi_rx_remove,
 	.rx_write = efx_ef10_rx_write,
 	.rx_defer_refill = efx_ef10_rx_defer_refill,
 	.ev_probe = efx_mcdi_ev_probe,
diff --git a/drivers/net/ethernet/sfc/mcdi_functions.c b/drivers/net/ethernet/sfc/mcdi_functions.c
index 9dc1395e5f68..f022e2b9e975 100644
--- a/drivers/net/ethernet/sfc/mcdi_functions.c
+++ b/drivers/net/ethernet/sfc/mcdi_functions.c
@@ -262,3 +262,88 @@ void efx_mcdi_tx_fini(struct efx_tx_queue *tx_queue)
 	efx_mcdi_display_error(efx, MC_CMD_FINI_TXQ, MC_CMD_FINI_TXQ_IN_LEN,
 			       outbuf, outlen, rc);
 }
+
+int efx_mcdi_rx_probe(struct efx_rx_queue *rx_queue)
+{
+	return efx_nic_alloc_buffer(rx_queue->efx, &rx_queue->rxd.buf,
+				    (rx_queue->ptr_mask + 1) *
+				    sizeof(efx_qword_t),
+				    GFP_KERNEL);
+}
+
+void efx_mcdi_rx_init(struct efx_rx_queue *rx_queue)
+{
+	MCDI_DECLARE_BUF(inbuf,
+			 MC_CMD_INIT_RXQ_IN_LEN(EFX_MAX_DMAQ_SIZE * 8 /
+						EFX_BUF_SIZE));
+	struct efx_channel *channel = efx_rx_queue_channel(rx_queue);
+	size_t entries = rx_queue->rxd.buf.len / EFX_BUF_SIZE;
+	struct efx_nic *efx = rx_queue->efx;
+	struct efx_ef10_nic_data *nic_data = efx->nic_data;
+	dma_addr_t dma_addr;
+	size_t inlen;
+	int rc;
+	int i;
+	BUILD_BUG_ON(MC_CMD_INIT_RXQ_OUT_LEN != 0);
+
+	rx_queue->scatter_n = 0;
+	rx_queue->scatter_len = 0;
+
+	MCDI_SET_DWORD(inbuf, INIT_RXQ_IN_SIZE, rx_queue->ptr_mask + 1);
+	MCDI_SET_DWORD(inbuf, INIT_RXQ_IN_TARGET_EVQ, channel->channel);
+	MCDI_SET_DWORD(inbuf, INIT_RXQ_IN_LABEL, efx_rx_queue_index(rx_queue));
+	MCDI_SET_DWORD(inbuf, INIT_RXQ_IN_INSTANCE,
+		       efx_rx_queue_index(rx_queue));
+	MCDI_POPULATE_DWORD_2(inbuf, INIT_RXQ_IN_FLAGS,
+			      INIT_RXQ_IN_FLAG_PREFIX, 1,
+			      INIT_RXQ_IN_FLAG_TIMESTAMP, 1);
+	MCDI_SET_DWORD(inbuf, INIT_RXQ_IN_OWNER_ID, 0);
+	MCDI_SET_DWORD(inbuf, INIT_RXQ_IN_PORT_ID, nic_data->vport_id);
+
+	dma_addr = rx_queue->rxd.buf.dma_addr;
+
+	netif_dbg(efx, hw, efx->net_dev, "pushing RXQ %d. %zu entries (%llx)\n",
+		  efx_rx_queue_index(rx_queue), entries, (u64)dma_addr);
+
+	for (i = 0; i < entries; ++i) {
+		MCDI_SET_ARRAY_QWORD(inbuf, INIT_RXQ_IN_DMA_ADDR, i, dma_addr);
+		dma_addr += EFX_BUF_SIZE;
+	}
+
+	inlen = MC_CMD_INIT_RXQ_IN_LEN(entries);
+
+	rc = efx_mcdi_rpc(efx, MC_CMD_INIT_RXQ, inbuf, inlen,
+			  NULL, 0, NULL);
+	if (rc)
+		netdev_WARN(efx->net_dev, "failed to initialise RXQ %d\n",
+			    efx_rx_queue_index(rx_queue));
+}
+
+void efx_mcdi_rx_remove(struct efx_rx_queue *rx_queue)
+{
+	efx_nic_free_buffer(rx_queue->efx, &rx_queue->rxd.buf);
+}
+
+void efx_mcdi_rx_fini(struct efx_rx_queue *rx_queue)
+{
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_FINI_RXQ_IN_LEN);
+	MCDI_DECLARE_BUF_ERR(outbuf);
+	struct efx_nic *efx = rx_queue->efx;
+	size_t outlen;
+	int rc;
+
+	MCDI_SET_DWORD(inbuf, FINI_RXQ_IN_INSTANCE,
+		       efx_rx_queue_index(rx_queue));
+
+	rc = efx_mcdi_rpc_quiet(efx, MC_CMD_FINI_RXQ, inbuf, sizeof(inbuf),
+				outbuf, sizeof(outbuf), &outlen);
+
+	if (rc && rc != -EALREADY)
+		goto fail;
+
+	return;
+
+fail:
+	efx_mcdi_display_error(efx, MC_CMD_FINI_RXQ, MC_CMD_FINI_RXQ_IN_LEN,
+			       outbuf, outlen, rc);
+}
diff --git a/drivers/net/ethernet/sfc/mcdi_functions.h b/drivers/net/ethernet/sfc/mcdi_functions.h
index f0726c71698b..3c9e760238e7 100644
--- a/drivers/net/ethernet/sfc/mcdi_functions.h
+++ b/drivers/net/ethernet/sfc/mcdi_functions.h
@@ -23,7 +23,7 @@ int efx_mcdi_tx_init(struct efx_tx_queue *tx_queue, bool tso_v2);
 void efx_mcdi_tx_remove(struct efx_tx_queue *tx_queue);
 void efx_mcdi_tx_fini(struct efx_tx_queue *tx_queue);
 int efx_mcdi_rx_probe(struct efx_rx_queue *rx_queue);
-int efx_mcdi_rx_init(struct efx_rx_queue *rx_queue, bool want_outer_classes);
+void efx_mcdi_rx_init(struct efx_rx_queue *rx_queue);
 void efx_mcdi_rx_remove(struct efx_rx_queue *rx_queue);
 void efx_mcdi_rx_fini(struct efx_rx_queue *rx_queue);
 
-- 
2.20.1


