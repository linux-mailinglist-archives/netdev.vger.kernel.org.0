Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 142FA21296B
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 18:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726660AbgGBQ3u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 12:29:50 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:57450 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726140AbgGBQ3u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 12:29:50 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.62])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id D3F2B6008F;
        Thu,  2 Jul 2020 16:29:49 +0000 (UTC)
Received: from us4-mdac16-21.ut7.mdlocal (unknown [10.7.65.245])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id D0E128009B;
        Thu,  2 Jul 2020 16:29:49 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.38])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 5C35C280054;
        Thu,  2 Jul 2020 16:29:49 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 0E95280008E;
        Thu,  2 Jul 2020 16:29:49 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 2 Jul 2020
 17:29:44 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH v2 net-next 06/16] sfc: commonise
 netif_set_real_num[tr]x_queues calls
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <52336e78-8f45-7401-9827-6c1fea38656d@solarflare.com>
Message-ID: <2c57c5d6-44a4-c06b-4a26-d1c76f533739@solarflare.com>
Date:   Thu, 2 Jul 2020 17:29:40 +0100
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
X-TM-AS-Result: No-4.172400-8.000000-10
X-TMASE-MatchedRID: BHMzc8xg4D5rFdvBEmTnvKiUivh0j2Pv6VTG9cZxEjJwGpdgNQ0JrHQS
        9xnw8IBXfGzuoVn0Vs6PQi9XuOWoOHI/MxNRI7UkCWlWR223da6mJtY0iSfJ/dEsTITobgNE8fX
        8/dcuseVvRKiSChY28V8fJwNyN0hUnrHF1xoSkxKPQVakDkJU+VDa/ZycwN1k9rtqCyVBZhhljN
        mCIkXOCnayr8VW/BvWukODB/hp/ilNfs8n85Te8oMbH85DUZXy3QfwsVk0UbsIoUKaF27lxTuNO
        FFuwsf5BEgfQMDAGbhcnxX77Iixn+BxQUKIIXJZ46TJAaRfDJnkpq8Mrxt/mk58fs9dSfq0VFSz
        KysDJMlZMqLCBuaTAlrMCKBXF1d6I2VNggMWJCP4LggrmsRgvTwNB+BE7Pnlnqg/VrSZEiM=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--4.172400-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25516.003
X-MDID: 1593707389-0AY5dWc5DBiK
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While we're at it, also check them for failure.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/efx.c          | 3 ---
 drivers/net/ethernet/sfc/efx_channels.c | 7 ++++++-
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 6094f59d49a7..befd253af918 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -336,9 +336,6 @@ static int efx_probe_nic(struct efx_nic *efx)
 				    sizeof(efx->rss_context.rx_hash_key));
 	efx_set_default_rx_indir_table(efx, &efx->rss_context);
 
-	netif_set_real_num_tx_queues(efx->net_dev, efx->n_tx_channels);
-	netif_set_real_num_rx_queues(efx->net_dev, efx->n_rx_channels);
-
 	/* Initialise the interrupt moderation settings */
 	efx->irq_mod_step_us = DIV_ROUND_UP(efx->timer_quantum_ns, 1000);
 	efx_init_irq_moderation(efx, tx_irq_mod_usec, rx_irq_mod_usec, true,
diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
index c3edebf523b6..30358f3f48ca 100644
--- a/drivers/net/ethernet/sfc/efx_channels.c
+++ b/drivers/net/ethernet/sfc/efx_channels.c
@@ -856,6 +856,7 @@ int efx_set_channels(struct efx_nic *efx)
 	struct efx_channel *channel;
 	struct efx_tx_queue *tx_queue;
 	int xdp_queue_number;
+	int rc;
 
 	efx->tx_channel_offset =
 		efx_separate_tx_channels ?
@@ -894,7 +895,11 @@ int efx_set_channels(struct efx_nic *efx)
 			}
 		}
 	}
-	return 0;
+
+	rc = netif_set_real_num_tx_queues(efx->net_dev, efx->n_tx_channels);
+	if (rc)
+		return rc;
+	return netif_set_real_num_rx_queues(efx->net_dev, efx->n_rx_channels);
 }
 
 bool efx_default_channel_want_txqs(struct efx_channel *channel)

