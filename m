Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C23DA2650EA
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 22:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbgIJUgW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 16:36:22 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:38264 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726680AbgIJUcm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 16:32:42 -0400
Received: from dispatch1-us1.ppe-hosted.com (localhost.localdomain [127.0.0.1])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id D9C0FB2244
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 20:32:40 +0000 (UTC)
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.61])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id B6048600C3;
        Thu, 10 Sep 2020 20:32:20 +0000 (UTC)
Received: from us4-mdac16-23.ut7.mdlocal (unknown [10.7.65.247])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id B4A4F8009E;
        Thu, 10 Sep 2020 20:32:20 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.33])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 3B0E48007B;
        Thu, 10 Sep 2020 20:32:20 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id E4129A8007F;
        Thu, 10 Sep 2020 20:32:19 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 10 Sep
 2020 21:31:43 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 2/7] sfc: define inner/outer csum offload TXQ types
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <6fbc3a86-0afd-6e6d-099b-fca9af48d019@solarflare.com>
Message-ID: <0bbb8672-451c-9911-1218-b650a005b5f0@solarflare.com>
Date:   Thu, 10 Sep 2020 21:31:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <6fbc3a86-0afd-6e6d-099b-fca9af48d019@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25656.007
X-TM-AS-Result: No-8.362100-8.000000-10
X-TMASE-MatchedRID: 4Tp1OMnl6hVWSqhPlGB837lH8bL998dvWw/S0HB7eoNjLp8Cm8vwFwoe
        RRhCZWIByf4UUiPmFLqKNuN8MZd1RCHhSBQfglfsA9lly13c/gHYuVu0X/rOkJiQXtm0V8JThnO
        LyflyxrPFrhrZZKM6u+VjZfUAW8R7jn1ntZAcVYCiAZ3zAhQYgqIik2/euMx1R2YNIFh+clEROZ
        MTSr6u3KIEkIIPhnOd0Zph/VplUEFdwKvR2QLJ9jxKEn0iLGa77qPKKDEKjrKnMb4m7aAqtxMnv
        ir+JcmK9GC5Cf4sr7Gxcw+oNQoH1Ry/DZ8tz1CLimHWEC28pk19LQinZ4QefL6qvLNjDYTwmTDw
        p0zM3zoqtq5d3cxkNb+lvA9RJhnILSwhlh7/7q0BD1hX54A6J0qk1I8JOzjcm5M1fCNQWjnAvpL
        E+mvX8g==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--8.362100-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25656.007
X-MDID: 1599769940-CJau_bfgTXNk
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nothing yet creates inner csum TXQs; just change all references to
 EFX_TXQ_TYPE_OFFLOAD to the new EFX_TXQ_TYPE_OUTER_CSUM.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/ef10.c           | 4 ++--
 drivers/net/ethernet/sfc/farch.c          | 4 ++--
 drivers/net/ethernet/sfc/mcdi_functions.c | 2 +-
 drivers/net/ethernet/sfc/net_driver.h     | 8 +++++---
 drivers/net/ethernet/sfc/ptp.c            | 2 +-
 drivers/net/ethernet/sfc/selftest.c       | 2 +-
 drivers/net/ethernet/sfc/tx.c             | 2 +-
 7 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index c9b6d23580a8..2ae85d3aa4b2 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -2146,7 +2146,7 @@ static int efx_ef10_irq_test_generate(struct efx_nic *efx)
 
 static int efx_ef10_tx_probe(struct efx_tx_queue *tx_queue)
 {
-	tx_queue->type = tx_queue->label & EFX_TXQ_TYPE_OFFLOAD;
+	tx_queue->type = tx_queue->label & EFX_TXQ_TYPE_OUTER_CSUM;
 	return efx_nic_alloc_buffer(tx_queue->efx, &tx_queue->txd.buf,
 				    (tx_queue->ptr_mask + 1) *
 				    sizeof(efx_qword_t),
@@ -2255,7 +2255,7 @@ static u32 efx_ef10_tso_versions(struct efx_nic *efx)
 
 static void efx_ef10_tx_init(struct efx_tx_queue *tx_queue)
 {
-	bool csum_offload = tx_queue->type & EFX_TXQ_TYPE_OFFLOAD;
+	bool csum_offload = tx_queue->type & EFX_TXQ_TYPE_OUTER_CSUM;
 	struct efx_channel *channel = tx_queue->channel;
 	struct efx_nic *efx = tx_queue->efx;
 	struct efx_ef10_nic_data *nic_data;
diff --git a/drivers/net/ethernet/sfc/farch.c b/drivers/net/ethernet/sfc/farch.c
index 2f36622627d5..bb5c45a0291b 100644
--- a/drivers/net/ethernet/sfc/farch.c
+++ b/drivers/net/ethernet/sfc/farch.c
@@ -372,7 +372,7 @@ int efx_farch_tx_probe(struct efx_tx_queue *tx_queue)
 	struct efx_nic *efx = tx_queue->efx;
 	unsigned entries;
 
-	tx_queue->type = ((tx_queue->label & 1) ? EFX_TXQ_TYPE_OFFLOAD : 0) |
+	tx_queue->type = ((tx_queue->label & 1) ? EFX_TXQ_TYPE_OUTER_CSUM : 0) |
 			 ((tx_queue->label & 2) ? EFX_TXQ_TYPE_HIGHPRI : 0);
 	entries = tx_queue->ptr_mask + 1;
 	return efx_alloc_special_buffer(efx, &tx_queue->txd,
@@ -381,7 +381,7 @@ int efx_farch_tx_probe(struct efx_tx_queue *tx_queue)
 
 void efx_farch_tx_init(struct efx_tx_queue *tx_queue)
 {
-	int csum = tx_queue->type & EFX_TXQ_TYPE_OFFLOAD;
+	int csum = tx_queue->type & EFX_TXQ_TYPE_OUTER_CSUM;
 	struct efx_nic *efx = tx_queue->efx;
 	efx_oword_t reg;
 
diff --git a/drivers/net/ethernet/sfc/mcdi_functions.c b/drivers/net/ethernet/sfc/mcdi_functions.c
index 684471cd7598..c80246e6dee8 100644
--- a/drivers/net/ethernet/sfc/mcdi_functions.c
+++ b/drivers/net/ethernet/sfc/mcdi_functions.c
@@ -164,7 +164,7 @@ int efx_mcdi_tx_init(struct efx_tx_queue *tx_queue, bool tso_v2)
 {
 	MCDI_DECLARE_BUF(inbuf, MC_CMD_INIT_TXQ_IN_LEN(EFX_MAX_DMAQ_SIZE * 8 /
 						       EFX_BUF_SIZE));
-	bool csum_offload = tx_queue->type & EFX_TXQ_TYPE_OFFLOAD;
+	bool csum_offload = tx_queue->type & EFX_TXQ_TYPE_OUTER_CSUM;
 	size_t entries = tx_queue->txd.buf.len / EFX_BUF_SIZE;
 	struct efx_channel *channel = tx_queue->channel;
 	struct efx_nic *efx = tx_queue->efx;
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index 5a25ef09dcef..ed444e1274ae 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -63,9 +63,11 @@
  * queues. */
 #define EFX_MAX_TX_TC		2
 #define EFX_MAX_CORE_TX_QUEUES	(EFX_MAX_TX_TC * EFX_MAX_CHANNELS)
-#define EFX_TXQ_TYPE_OFFLOAD	1	/* flag */
-#define EFX_TXQ_TYPE_HIGHPRI	2	/* flag */
-#define EFX_TXQ_TYPES		4
+#define EFX_TXQ_TYPE_OUTER_CSUM	1	/* Outer checksum offload */
+#define EFX_TXQ_TYPE_INNER_CSUM	2	/* Inner checksum offload */
+#define EFX_TXQ_TYPE_HIGHPRI	4	/* High-priority (for TC) */
+#define EFX_TXQ_TYPES		8
+/* HIGHPRI is Siena-only, and INNER_CSUM is EF10, so no need for both */
 #define EFX_MAX_TXQ_PER_CHANNEL	4
 #define EFX_MAX_TX_QUEUES	(EFX_MAX_TXQ_PER_CHANNEL * EFX_MAX_CHANNELS)
 
diff --git a/drivers/net/ethernet/sfc/ptp.c b/drivers/net/ethernet/sfc/ptp.c
index 044e3f2637e4..bd99517f06db 100644
--- a/drivers/net/ethernet/sfc/ptp.c
+++ b/drivers/net/ethernet/sfc/ptp.c
@@ -1081,9 +1081,9 @@ static int efx_ptp_synchronize(struct efx_nic *efx, unsigned int num_readings)
 /* Transmit a PTP packet via the dedicated hardware timestamped queue. */
 static void efx_ptp_xmit_skb_queue(struct efx_nic *efx, struct sk_buff *skb)
 {
+	u8 type = skb->ip_summed == CHECKSUM_PARTIAL ? EFX_TXQ_TYPE_OUTER_CSUM : 0;
 	struct efx_ptp_data *ptp_data = efx->ptp_data;
 	struct efx_tx_queue *tx_queue;
-	u8 type = skb->ip_summed == CHECKSUM_PARTIAL ? EFX_TXQ_TYPE_OFFLOAD : 0;
 
 	tx_queue = efx_channel_get_tx_queue(ptp_data->channel, type);
 	if (tx_queue && tx_queue->timestamping) {
diff --git a/drivers/net/ethernet/sfc/selftest.c b/drivers/net/ethernet/sfc/selftest.c
index 3ec315a0d1bd..3c5227afd497 100644
--- a/drivers/net/ethernet/sfc/selftest.c
+++ b/drivers/net/ethernet/sfc/selftest.c
@@ -657,7 +657,7 @@ static int efx_test_loopbacks(struct efx_nic *efx, struct efx_self_tests *tests,
 		/* Test all enabled types of TX queue */
 		efx_for_each_channel_tx_queue(tx_queue, channel) {
 			state->offload_csum = (tx_queue->type &
-					       EFX_TXQ_TYPE_OFFLOAD);
+					       EFX_TXQ_TYPE_OUTER_CSUM);
 			rc = efx_test_loopback(tx_queue,
 					       &tests->loopback[mode]);
 			if (rc)
diff --git a/drivers/net/ethernet/sfc/tx.c b/drivers/net/ethernet/sfc/tx.c
index b0a08d9f4773..ca64a8123e76 100644
--- a/drivers/net/ethernet/sfc/tx.c
+++ b/drivers/net/ethernet/sfc/tx.c
@@ -509,7 +509,7 @@ netdev_tx_t efx_hard_start_xmit(struct sk_buff *skb,
 	EFX_WARN_ON_PARANOID(!netif_device_present(net_dev));
 
 	index = skb_get_queue_mapping(skb);
-	type = skb->ip_summed == CHECKSUM_PARTIAL ? EFX_TXQ_TYPE_OFFLOAD : 0;
+	type = skb->ip_summed == CHECKSUM_PARTIAL ? EFX_TXQ_TYPE_OUTER_CSUM : 0;
 	if (index >= efx->n_tx_channels) {
 		index -= efx->n_tx_channels;
 		type |= EFX_TXQ_TYPE_HIGHPRI;

