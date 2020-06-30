Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5566120F455
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 14:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387571AbgF3MPW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 08:15:22 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:43540 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387554AbgF3MPT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 08:15:19 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.143])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 0DCD620052;
        Tue, 30 Jun 2020 12:15:19 +0000 (UTC)
Received: from us4-mdac16-1.at1.mdlocal (unknown [10.110.49.147])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 0F2C58009B;
        Tue, 30 Jun 2020 12:15:19 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.109])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 93BA340058;
        Tue, 30 Jun 2020 12:15:18 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 5ADDDB40063;
        Tue, 30 Jun 2020 12:15:18 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 30 Jun
 2020 13:15:13 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 13/14] sfc: commonise initialisation of efx->vport_id
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <14a93b71-3d4e-4663-82be-a2281cd1105e@solarflare.com>
Message-ID: <12334d73-7797-c638-7602-aaa66917d569@solarflare.com>
Date:   Tue, 30 Jun 2020 13:15:10 +0100
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
X-TM-AS-Result: No-7.507600-8.000000-10
X-TMASE-MatchedRID: BwBVF9uPMIrjtwtQtmXE5bsHVDDM5xAP1JP9NndNOkUGmHr1eMxt2UAc
        6DyoS2rIj6kCfX0Edc4mQHxxqFX9+R1pRstOIPc+52cbj4/WmPtC61vu00HIv7ytS1u1Z7z6QDo
        v87hVw1IbRhC5hIy4iEOkSEpTIJCMjJBSOECLn6o3KH0bqm8JUjGk13qHn7yc0SxMhOhuA0S7im
        J4LbFoqcrqJH3Kw4BAXx8nA3I3SFQEL+qFx24Qup4CIKY/Hg3AtOt1ofVlaoLWRN8STJpl3PoLR
        4+zsDTtqFhHt/jREamAYNL5iXeLvCIm2a0d56FIW5Qw786owOiIR1hxvHZVXFZca9RSYo/b
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--7.507600-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25512.003
X-MDID: 1593519319-DJ40tDCK4KRi
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/ef10.c       | 2 --
 drivers/net/ethernet/sfc/efx_common.c | 1 +
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index a3bf9d8023d7..5faf2f0e4d62 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -554,8 +554,6 @@ static int efx_ef10_probe(struct efx_nic *efx)
 
 	efx->rss_context.context_id = EFX_MCDI_RSS_CONTEXT_INVALID;
 
-	efx->vport_id = EVB_PORT_ID_ASSIGNED;
-
 	/* In case we're recovering from a crash (kexec), we want to
 	 * cancel any outstanding request by the previous user of this
 	 * function.  We send a special message using the least
diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index 822e9e147404..a2f744377aaa 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -1018,6 +1018,7 @@ int efx_init_struct(struct efx_nic *efx,
 		efx->type->rx_ts_offset - efx->type->rx_prefix_size;
 	INIT_LIST_HEAD(&efx->rss_context.list);
 	mutex_init(&efx->rss_lock);
+	efx->vport_id = EVB_PORT_ID_ASSIGNED;
 	spin_lock_init(&efx->stats_lock);
 	efx->vi_stride = EFX_DEFAULT_VI_STRIDE;
 	efx->num_mac_stats = MC_CMD_MAC_NSTATS;

