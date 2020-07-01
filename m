Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21DBA210E08
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 16:52:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731519AbgGAOwJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 10:52:09 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:58770 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730264AbgGAOwI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 10:52:08 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.62])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 1402D60055;
        Wed,  1 Jul 2020 14:52:08 +0000 (UTC)
Received: from us4-mdac16-56.ut7.mdlocal (unknown [10.7.64.50])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 13E1A8009B;
        Wed,  1 Jul 2020 14:52:08 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.41])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 93DA328004D;
        Wed,  1 Jul 2020 14:52:07 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 44E5A4C0072;
        Wed,  1 Jul 2020 14:52:07 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 1 Jul 2020
 15:51:59 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 02/15] sfc: remove max_interrupt_mode
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <3fa88508-024e-2d33-0629-bf63b558b515@solarflare.com>
Message-ID: <8b3ca1de-86f7-eb74-7522-fa637bb6feba@solarflare.com>
Date:   Wed, 1 Jul 2020 15:51:55 +0100
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
X-TM-AS-Result: No-3.735700-8.000000-10
X-TMASE-MatchedRID: hP+FeBC8A+7z37tR7WIR1brbxxduc6FP4OB3iDG6ikkLJKBkFcV+xFTt
        suqdDP8M3UJTYve4D89TvVffeIwvQwUcfW/oedmqjQlVVwSbjyfuo8ooMQqOsgaYevV4zG3ZQBz
        oPKhLashO9UxJ8vboSexW7q8lE2DjvKcA55DXCb9tJYfOb0q5O1dEEmf6TRVBJt7ZZwvxOlTtmK
        Wc5t/VPgpr4p4pYh/KiOLFer9P5iB7VmZpMW0Kt4ph1hAtvKZN/Md+OvVRT/mynk7TnYzMuuTsR
        vdKfAuC3yWpPyd+la370Aj4svCBHE1+zyfzlN7ygxsfzkNRlfLdB/CxWTRRuwihQpoXbuXFKrvF
        nDrK5uzVrxo/5UL8Nj4Le7LvKxAHOGp8fDx6sB5kcxX79KkaPvq4WFp8NrW0uKWQLw4vniujNGT
        wgo16AFucfiyp/Ad5WswIoFcXV3ojZU2CAxYkI/guCCuaxGC9PA0H4ETs+eX6svlVb6h9lw==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10-3.735700-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25514.003
X-MDID: 1593615128-ebt1ThiVDVDr
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
index d162df382dc5..a34aaecc609c 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -4111,7 +4111,6 @@ const struct efx_nic_type efx_hunt_a0_vf_nic_type = {
 	.can_rx_scatter = true,
 	.always_rx_scatter = true,
 	.min_interrupt_mode = EFX_INT_MODE_MSIX,
-	.max_interrupt_mode = EFX_INT_MODE_MSIX,
 	.timer_period_max = 1 << ERF_DD_EVQ_IND_TIMER_VAL_WIDTH,
 	.offload_features = EF10_OFFLOAD_FEATURES,
 	.mcdi_max_ver = 2,
@@ -4248,7 +4247,6 @@ const struct efx_nic_type efx_hunt_a0_nic_type = {
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

