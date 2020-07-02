Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A9C2212960
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 18:28:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbgGBQ2C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 12:28:02 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:39704 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726793AbgGBQ2B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 12:28:01 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.62])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id D6085600AB;
        Thu,  2 Jul 2020 16:28:00 +0000 (UTC)
Received: from us4-mdac16-71.ut7.mdlocal (unknown [10.7.64.190])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id D3A028009B;
        Thu,  2 Jul 2020 16:28:00 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.37])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 64023280059;
        Thu,  2 Jul 2020 16:28:00 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 14A85B40092;
        Thu,  2 Jul 2020 16:28:00 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 2 Jul 2020
 17:27:55 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH v2 net-next 02/16] sfc: remove max_interrupt_mode
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <52336e78-8f45-7401-9827-6c1fea38656d@solarflare.com>
Message-ID: <42175a6b-a2b5-dc84-c853-0db452b663ba@solarflare.com>
Date:   Thu, 2 Jul 2020 17:27:51 +0100
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
X-TM-AS-Result: No-3.735700-8.000000-10
X-TMASE-MatchedRID: hP+FeBC8A+7z37tR7WIR1brbxxduc6FP4OB3iDG6ikkLJKBkFcV+xFTt
        suqdDP8M3UJTYve4D89TvVffeIwvQwUcfW/oedmqjQlVVwSbjyfuo8ooMQqOsgaYevV4zG3ZQBz
        oPKhLashO9UxJ8vboSexW7q8lE2DjvKcA55DXCb9tJYfOb0q5O1dEEmf6TRVBJt7ZZwvxOlTtmK
        Wc5t/VPgpr4p4pYh/KiOLFer9P5iB7VmZpMW0Kt4ph1hAtvKZN/Md+OvVRT/mynk7TnYzMuuTsR
        vdKfAuC3yWpPyd+la370Aj4svCBHE1+zyfzlN7ygxsfzkNRlfLdB/CxWTRRuwihQpoXbuXFKrvF
        nDrK5uzVrxo/5UL8Nj4Le7LvKxAHOGp8fDx6sB7IzbUlGPipVaGnSsb1i4Kr7J/I4b/zr/mfIT+
        pTpRvCCnNjMfApmw5WswIoFcXV3ojZU2CAxYkI/guCCuaxGC9PA0H4ETs+eX6svlVb6h9lw==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10-3.735700-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25516.003
X-MDID: 1593707280-mXoV9nBBFLqE
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All NICs supported by this driver are capable of MSI-X interrupts (only
 Falcon A1 wasn't, and that's now hived off into its own driver), so no
 need for a nic-type parameter.  Besides, the code that checked it was
 buggy anyway (the following assignment that checked min_interrupt_mode
 overrode it).

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/ef10.c         | 2 --
 drivers/net/ethernet/sfc/efx_channels.c | 6 ------
 drivers/net/ethernet/sfc/net_driver.h   | 3 ---
 drivers/net/ethernet/sfc/siena.c        | 1 -
 4 files changed, 12 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index a51925b45fc7..88522b683cc7 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -4108,7 +4108,6 @@ const struct efx_nic_type efx_hunt_a0_vf_nic_type = {
 	.can_rx_scatter = true,
 	.always_rx_scatter = true,
 	.min_interrupt_mode = EFX_INT_MODE_MSIX,
-	.max_interrupt_mode = EFX_INT_MODE_MSIX,
 	.timer_period_max = 1 << ERF_DD_EVQ_IND_TIMER_VAL_WIDTH,
 	.offload_features = EF10_OFFLOAD_FEATURES,
 	.mcdi_max_ver = 2,
@@ -4245,7 +4244,6 @@ const struct efx_nic_type efx_hunt_a0_nic_type = {
 	.always_rx_scatter = true,
 	.option_descriptors = true,
 	.min_interrupt_mode = EFX_INT_MODE_LEGACY,
-	.max_interrupt_mode = EFX_INT_MODE_MSIX,
 	.timer_period_max = 1 << ERF_DD_EVQ_IND_TIMER_VAL_WIDTH,
 	.offload_features = EF10_OFFLOAD_FEATURES,
 	.mcdi_max_ver = 2,
diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
index 2f9db219513a..2220b9507336 100644
--- a/drivers/net/ethernet/sfc/efx_channels.c
+++ b/drivers/net/ethernet/sfc/efx_channels.c
@@ -557,12 +557,6 @@ int efx_init_channels(struct efx_nic *efx)
 	}
 
 	/* Higher numbered interrupt modes are less capable! */
-	if (WARN_ON_ONCE(efx->type->max_interrupt_mode >
-			 efx->type->min_interrupt_mode)) {
-		return -EIO;
-	}
-	efx->interrupt_mode = max(efx->type->max_interrupt_mode,
-				  interrupt_mode);
 	efx->interrupt_mode = min(efx->type->min_interrupt_mode,
 				  interrupt_mode);
 
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index 65a106878186..e536c1e12f86 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -1317,8 +1317,6 @@ struct efx_udp_tunnel {
  * @option_descriptors: NIC supports TX option descriptors
  * @min_interrupt_mode: Lowest capability interrupt mode supported
  *	from &enum efx_int_mode.
- * @max_interrupt_mode: Highest capability interrupt mode supported
- *	from &enum efx_int_mode.
  * @timer_period_max: Maximum period of interrupt timer (in ticks)
  * @offload_features: net_device feature flags for protocol offload
  *	features implemented in hardware
@@ -1492,7 +1490,6 @@ struct efx_nic_type {
 	bool always_rx_scatter;
 	bool option_descriptors;
 	unsigned int min_interrupt_mode;
-	unsigned int max_interrupt_mode;
 	unsigned int timer_period_max;
 	netdev_features_t offload_features;
 	int mcdi_max_ver;
diff --git a/drivers/net/ethernet/sfc/siena.c b/drivers/net/ethernet/sfc/siena.c
index a7dcd2d3c09b..e438853f64a3 100644
--- a/drivers/net/ethernet/sfc/siena.c
+++ b/drivers/net/ethernet/sfc/siena.c
@@ -1085,7 +1085,6 @@ const struct efx_nic_type siena_a0_nic_type = {
 	.can_rx_scatter = true,
 	.option_descriptors = false,
 	.min_interrupt_mode = EFX_INT_MODE_LEGACY,
-	.max_interrupt_mode = EFX_INT_MODE_MSIX,
 	.timer_period_max = 1 << FRF_CZ_TC_TIMER_VAL_WIDTH,
 	.offload_features = (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
 			     NETIF_F_RXHASH | NETIF_F_NTUPLE),

