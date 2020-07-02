Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A566212996
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 18:32:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbgGBQce (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 12:32:34 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:33840 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726147AbgGBQce (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 12:32:34 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.60])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id AE5CE6008D;
        Thu,  2 Jul 2020 16:32:33 +0000 (UTC)
Received: from us4-mdac16-34.ut7.mdlocal (unknown [10.7.66.153])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id AF219200A0;
        Thu,  2 Jul 2020 16:32:33 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.32])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 4BA3F1C0067;
        Thu,  2 Jul 2020 16:32:33 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id EDF0CB40093;
        Thu,  2 Jul 2020 16:32:32 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 2 Jul 2020
 17:32:28 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH v2 net-next 14/16] sfc_ef100: populate BUFFER_SIZE_BYTES in
 INIT_RXQ
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <52336e78-8f45-7401-9827-6c1fea38656d@solarflare.com>
Message-ID: <eb41b8f3-6215-7323-1ae5-d71ae5067afa@solarflare.com>
Date:   Thu, 2 Jul 2020 17:32:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <52336e78-8f45-7401-9827-6c1fea38656d@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25516.003
X-TM-AS-Result: No-1.753300-8.000000-10
X-TMASE-MatchedRID: w+oUc/DX3ai7QVALX3eqYaiUivh0j2Pv6VTG9cZxEjJwGpdgNQ0JrEAc
        6DyoS2rITvVMSfL26EnA5599fjNR3G8BU9XGR8QhogGd8wIUGIKiIpNv3rjMdUdmDSBYfnJR0HT
        LLuKQyhiF+JQZo0Bj2O3E2S4X+GlWAcW5/WSZaiCU2iZ1nIhYorpKkQnaF6lamyiLZetSf8nJ4y
        0wP1A6AAOkBnb8H8GW5MIx11wv+COujVRFkkVsm6kAShzxf+FgiV69lBSX0hfG86f8C5qglTgEP
        988SypI5DEWkNQUGVkkhB0D9y2qbFVHXDtG50EX/m2vejY1oDN1MnUMCJVX2ZBEcrkRxYJ4UjKn
        O1KVKKwSkbDwum07zqq0MV8nSMBvkLxsYTGf9c0=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--1.753300-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25516.003
X-MDID: 1593707553-fztT9EHyf8oV
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The QDMA subsystem on EF100 needs this information.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/mcdi_functions.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/sfc/mcdi_functions.c b/drivers/net/ethernet/sfc/mcdi_functions.c
index 92b9a741c286..d8a3af86ef78 100644
--- a/drivers/net/ethernet/sfc/mcdi_functions.c
+++ b/drivers/net/ethernet/sfc/mcdi_functions.c
@@ -267,20 +267,22 @@ int efx_mcdi_rx_probe(struct efx_rx_queue *rx_queue)
 
 void efx_mcdi_rx_init(struct efx_rx_queue *rx_queue)
 {
-	MCDI_DECLARE_BUF(inbuf,
-			 MC_CMD_INIT_RXQ_IN_LEN(EFX_MAX_DMAQ_SIZE * 8 /
-						EFX_BUF_SIZE));
 	struct efx_channel *channel = efx_rx_queue_channel(rx_queue);
 	size_t entries = rx_queue->rxd.buf.len / EFX_BUF_SIZE;
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_INIT_RXQ_V4_IN_LEN);
 	struct efx_nic *efx = rx_queue->efx;
+	unsigned int buffer_size;
 	dma_addr_t dma_addr;
-	size_t inlen;
 	int rc;
 	int i;
 	BUILD_BUG_ON(MC_CMD_INIT_RXQ_OUT_LEN != 0);
 
 	rx_queue->scatter_n = 0;
 	rx_queue->scatter_len = 0;
+	if (efx->type->revision == EFX_REV_EF100)
+		buffer_size = efx->rx_page_buf_step;
+	else
+		buffer_size = 0;
 
 	MCDI_SET_DWORD(inbuf, INIT_RXQ_IN_SIZE, rx_queue->ptr_mask + 1);
 	MCDI_SET_DWORD(inbuf, INIT_RXQ_IN_TARGET_EVQ, channel->channel);
@@ -292,6 +294,7 @@ void efx_mcdi_rx_init(struct efx_rx_queue *rx_queue)
 			      INIT_RXQ_IN_FLAG_TIMESTAMP, 1);
 	MCDI_SET_DWORD(inbuf, INIT_RXQ_IN_OWNER_ID, 0);
 	MCDI_SET_DWORD(inbuf, INIT_RXQ_IN_PORT_ID, efx->vport_id);
+	MCDI_SET_DWORD(inbuf, INIT_RXQ_V4_IN_BUFFER_SIZE_BYTES, buffer_size);
 
 	dma_addr = rx_queue->rxd.buf.dma_addr;
 
@@ -303,9 +306,7 @@ void efx_mcdi_rx_init(struct efx_rx_queue *rx_queue)
 		dma_addr += EFX_BUF_SIZE;
 	}
 
-	inlen = MC_CMD_INIT_RXQ_IN_LEN(entries);
-
-	rc = efx_mcdi_rpc(efx, MC_CMD_INIT_RXQ, inbuf, inlen,
+	rc = efx_mcdi_rpc(efx, MC_CMD_INIT_RXQ, inbuf, sizeof(inbuf),
 			  NULL, 0, NULL);
 	if (rc)
 		netdev_WARN(efx->net_dev, "failed to initialise RXQ %d\n",

