Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BD6B20D92E
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 22:11:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388029AbgF2TpO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 15:45:14 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:54968 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387819AbgF2Tkp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:40:45 -0400
Received: from dispatch1-us1.ppe-hosted.com (localhost.localdomain [127.0.0.1])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 4C057209264
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 13:35:45 +0000 (UTC)
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.144])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 3409E2009F;
        Mon, 29 Jun 2020 13:35:45 +0000 (UTC)
Received: from us4-mdac16-53.at1.mdlocal (unknown [10.110.48.102])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id E669F800D3;
        Mon, 29 Jun 2020 13:35:44 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.9])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id E8D6C40071;
        Mon, 29 Jun 2020 13:35:43 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 4018258012A;
        Mon, 29 Jun 2020 13:35:37 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 29 Jun
 2020 14:35:28 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH v2 net-next 10/15] sfc: commonise FC advertising
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <3750523f-1c2f-628d-1f71-39b355cf6661@solarflare.com>
Message-ID: <f3ad7330-b61e-634b-2e0a-bf4919e5463d@solarflare.com>
Date:   Mon, 29 Jun 2020 14:35:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <3750523f-1c2f-628d-1f71-39b355cf6661@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25510.003
X-TM-AS-Result: No-0.954600-8.000000-10
X-TMASE-MatchedRID: oKlKY1QNFwah9oPbMj7PPPCoOvLLtsMhP6Tki+9nU38HZBaLwEXlKGlF
        7OhYLlcthIhJxBzgKNa1w7fWeJeZa5fHSmcYT/h1uoibJpHRrFn3/H7adAffkleIuu+Gkot8kg3
        cPb9+H4R9JkPUJMTfJk4RWc6tg0JKlQHiGh4j0EoWqJ/PBjhtWo6ESGgCXvgoVzlS2D8whfCjxY
        yRBa/qJQPTK4qtAgwIPcCXjNqUmkUnRE+fI6etkr2PjCgusxjy/Dsr7oOrq5ijp9qM2Ot4Xta86
        edqgJ0dgk3bIVLBoPHDcJllsoD3iSnY6MPYRUW6xclag+p13qntvECbBKmimTHCqV7rv9Y1QDMF
        uK2P9FjtoWavEW7HRE3Z8jKJCdR0Rfwnj+uLV5w=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--0.954600-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25510.003
X-MDID: 1593437744-iuYeKDMVBxgY
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/efx.c        | 24 ------------------------
 drivers/net/ethernet/sfc/efx.h        |  3 ---
 drivers/net/ethernet/sfc/efx_common.c | 24 ++++++++++++++++++++++++
 drivers/net/ethernet/sfc/efx_common.h |  3 +++
 4 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 256807c28ff7..474cfce5c042 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -133,30 +133,6 @@ static int efx_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **xdpfs,
  *
  **************************************************************************/
 
-/* Equivalent to efx_link_set_advertising with all-zeroes, except does not
- * force the Autoneg bit on.
- */
-void efx_link_clear_advertising(struct efx_nic *efx)
-{
-	bitmap_zero(efx->link_advertising, __ETHTOOL_LINK_MODE_MASK_NBITS);
-	efx->wanted_fc &= ~(EFX_FC_TX | EFX_FC_RX);
-}
-
-void efx_link_set_wanted_fc(struct efx_nic *efx, u8 wanted_fc)
-{
-	efx->wanted_fc = wanted_fc;
-	if (efx->link_advertising[0]) {
-		if (wanted_fc & EFX_FC_RX)
-			efx->link_advertising[0] |= (ADVERTISED_Pause |
-						     ADVERTISED_Asym_Pause);
-		else
-			efx->link_advertising[0] &= ~(ADVERTISED_Pause |
-						      ADVERTISED_Asym_Pause);
-		if (wanted_fc & EFX_FC_TX)
-			efx->link_advertising[0] ^= ADVERTISED_Asym_Pause;
-	}
-}
-
 static void efx_fini_port(struct efx_nic *efx);
 
 static int efx_probe_port(struct efx_nic *efx)
diff --git a/drivers/net/ethernet/sfc/efx.h b/drivers/net/ethernet/sfc/efx.h
index 66dcab140449..8aadec02407c 100644
--- a/drivers/net/ethernet/sfc/efx.h
+++ b/drivers/net/ethernet/sfc/efx.h
@@ -216,9 +216,6 @@ static inline void efx_schedule_channel_irq(struct efx_channel *channel)
 	efx_schedule_channel(channel);
 }
 
-void efx_link_clear_advertising(struct efx_nic *efx);
-void efx_link_set_wanted_fc(struct efx_nic *efx, u8);
-
 static inline void efx_device_detach_sync(struct efx_nic *efx)
 {
 	struct net_device *dev = efx->net_dev;
diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index 1799ff9a45d9..02459d90afb0 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -383,6 +383,30 @@ static void efx_stop_datapath(struct efx_nic *efx)
  *
  **************************************************************************/
 
+/* Equivalent to efx_link_set_advertising with all-zeroes, except does not
+ * force the Autoneg bit on.
+ */
+void efx_link_clear_advertising(struct efx_nic *efx)
+{
+	bitmap_zero(efx->link_advertising, __ETHTOOL_LINK_MODE_MASK_NBITS);
+	efx->wanted_fc &= ~(EFX_FC_TX | EFX_FC_RX);
+}
+
+void efx_link_set_wanted_fc(struct efx_nic *efx, u8 wanted_fc)
+{
+	efx->wanted_fc = wanted_fc;
+	if (efx->link_advertising[0]) {
+		if (wanted_fc & EFX_FC_RX)
+			efx->link_advertising[0] |= (ADVERTISED_Pause |
+						     ADVERTISED_Asym_Pause);
+		else
+			efx->link_advertising[0] &= ~(ADVERTISED_Pause |
+						      ADVERTISED_Asym_Pause);
+		if (wanted_fc & EFX_FC_TX)
+			efx->link_advertising[0] ^= ADVERTISED_Asym_Pause;
+	}
+}
+
 static void efx_start_port(struct efx_nic *efx)
 {
 	netif_dbg(efx, ifup, efx->net_dev, "start port\n");
diff --git a/drivers/net/ethernet/sfc/efx_common.h b/drivers/net/ethernet/sfc/efx_common.h
index fa2fc681e7f9..c522a5be43d2 100644
--- a/drivers/net/ethernet/sfc/efx_common.h
+++ b/drivers/net/ethernet/sfc/efx_common.h
@@ -18,6 +18,9 @@ int efx_init_struct(struct efx_nic *efx, struct pci_dev *pci_dev,
 		    struct net_device *net_dev);
 void efx_fini_struct(struct efx_nic *efx);
 
+void efx_link_clear_advertising(struct efx_nic *efx);
+void efx_link_set_wanted_fc(struct efx_nic *efx, u8);
+
 void efx_start_all(struct efx_nic *efx);
 void efx_stop_all(struct efx_nic *efx);
 

