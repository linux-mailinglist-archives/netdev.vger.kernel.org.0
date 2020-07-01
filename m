Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77F71210E16
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 16:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731669AbgGAOxZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 10:53:25 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:34874 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731652AbgGAOxZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 10:53:25 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.60])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id C5A85600E6;
        Wed,  1 Jul 2020 14:53:24 +0000 (UTC)
Received: from us4-mdac16-8.ut7.mdlocal (unknown [10.7.65.76])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id C46672009A;
        Wed,  1 Jul 2020 14:53:24 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.197])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 4F92A1C0064;
        Wed,  1 Jul 2020 14:53:24 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 0144BA40064;
        Wed,  1 Jul 2020 14:53:24 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 1 Jul 2020
 15:53:18 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 06/15] sfc: commonise netif_set_real_num[tr]x_queues
 calls
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <3fa88508-024e-2d33-0629-bf63b558b515@solarflare.com>
Message-ID: <f58eb18e-8b7a-5b79-be31-ec794f3262e1@solarflare.com>
Date:   Wed, 1 Jul 2020 15:53:15 +0100
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
X-TM-AS-Result: No-1.539600-8.000000-10
X-TMASE-MatchedRID: S0aY/Qt01zWh9oPbMj7PPPCoOvLLtsMhqnabhLgnhmgGmHr1eMxt2UAc
        6DyoS2rIj6kCfX0Edc4mQHxxqFX9+R1pRstOIPc+R/j040fRFpJ+jSWdx0YUUwrkj7klVufua3A
        6hcNu8nCHUUm9FGrCb0Q0rmvFqtf+XXLUFzmRlmieAiCmPx4NwLTrdaH1ZWqC1kTfEkyaZdz6C0
        ePs7A07a10/0DMlNjcIIUmlVmI+2bga/f2A8enwk3qSAxU0ayEjN9XuKHBRhsH7rxK/yCkTPN7B
        5mCP1uCCUqGPDEAe7pq+XzFE8MSQmf7WfO6asOAfObqGK9JplminaV/dK0aEhK3Vty8oXtk2SsL
        yY4gH4vAvpLE+mvX8g==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--1.539600-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25514.003
X-MDID: 1593615204-0JTvtylvzmPd
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/efx.c          | 3 ---
 drivers/net/ethernet/sfc/efx_channels.c | 4 ++++
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index f4173f855438..9f659cc34252 100644
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
index 41bf18f2b081..dd6ee60b66a0 100644
--- a/drivers/net/ethernet/sfc/efx_channels.c
+++ b/drivers/net/ethernet/sfc/efx_channels.c
@@ -894,6 +894,10 @@ int efx_set_channels(struct efx_nic *efx)
 			}
 		}
 	}
+
+	netif_set_real_num_tx_queues(efx->net_dev, efx->n_tx_channels);
+	netif_set_real_num_rx_queues(efx->net_dev, efx->n_rx_channels);
+
 	return 0;
 }
 

