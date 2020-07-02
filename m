Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD23A212958
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 18:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbgGBQ1r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 12:27:47 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:32922 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726199AbgGBQ1q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 12:27:46 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.60])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id E7BA8600F8;
        Thu,  2 Jul 2020 16:27:45 +0000 (UTC)
Received: from us4-mdac16-35.ut7.mdlocal (unknown [10.7.66.154])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id E85B22009A;
        Thu,  2 Jul 2020 16:27:45 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.34])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 635B41C0074;
        Thu,  2 Jul 2020 16:27:45 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 9AD88600070;
        Thu,  2 Jul 2020 16:27:44 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 2 Jul 2020
 17:27:39 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH v2 net-next 01/16] sfc: support setting MTU even if not
 privileged to configure MAC fully
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <52336e78-8f45-7401-9827-6c1fea38656d@solarflare.com>
Message-ID: <cd5f0ea6-675b-ea52-3b96-e939714d60bb@solarflare.com>
Date:   Thu, 2 Jul 2020 17:27:35 +0100
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
X-TM-AS-Result: No-1.286900-8.000000-10
X-TMASE-MatchedRID: M5B1AlKAOJ9qbYNLrGLWoLSkeRV328rMzPMyzZ3J7JUifM7JMNHW68iT
        Wug2C4DNl1M7KT9/aqA0uSYsteWBcvETe0ikDYzDnFVnNmvv47tLXPA26IG0hN9RlPzeVuQQdum
        Vq+Y7nLR5sEut5wZeN/Ti/SmPY4FuwsZtKo32enRIcJTn2HkqsVgy2ozNthE2c3igmsO92YFeau
        djVe6z7Thmj1Bzm+FD4+3MLuVUJGyzV1diHrOnx49BVqQOQlT53znRApB6A3hrRM6wvXgDaY9no
        FgPEO4N39EfN1c7G4lgZsr/IoM9mhuwdhbbhxE78pRHzcG+oi1QYo4xNF42PlIxScKXZnK0OArq
        sGNfHKKdHyMsXu0FtlxY9ab3xJSxyw0dUT70SVFJUdgxNDUXWswx7VbZgGmKI0YrtQLsSUx3Xbg
        5u5YBp8DaY2cH3Ge7h/OVfL/xKVUkW0GoGqxWf9+G9ND+fWcZgsWAdoT0uL2bKItl61J/ycnjLT
        A/UDoASXhbxZVQ5H+OhzOa6g8KrcKSHktHj30lg5YIda1TVOJcrhWn5PYbLxEKgWmXejGLGER6h
        zJTnvU8Xrb71+coHp1zWfxsEukuUGpVe7MXfKqFZHuo9OfV/hfFjqZq7wsbcgmHh0FxTjZ/iGlO
        mgEX0mrEYJLMUP0ysMxa9dfPWWuUTGVAhB5EbQ==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--1.286900-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25516.003
X-MDID: 1593707265-oioqW6PLtalD
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Unprivileged functions (such as VFs) may set their MTU by use of the
 'control' field of MC_CMD_SET_MAC_EXT, as used in efx_mcdi_set_mtu().
If calling efx_ef10_mac_reconfigure() from efx_change_mtu(), and the
 NIC supports the above (SET_MAC_ENHANCED capability), use it rather
 than efx_mcdi_set_mac().

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/ef10.c           | 15 ++++++---------
 drivers/net/ethernet/sfc/efx.c            |  4 ----
 drivers/net/ethernet/sfc/efx_common.c     | 12 ++++++------
 drivers/net/ethernet/sfc/efx_common.h     |  2 +-
 drivers/net/ethernet/sfc/ethtool_common.c |  2 +-
 drivers/net/ethernet/sfc/net_driver.h     |  2 +-
 drivers/net/ethernet/sfc/siena.c          |  2 +-
 7 files changed, 16 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index 5faf2f0e4d62..a51925b45fc7 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -3306,18 +3306,15 @@ static int efx_ef10_set_mac_address(struct efx_nic *efx)
 	return rc;
 }
 
-static int efx_ef10_mac_reconfigure(struct efx_nic *efx)
+static int efx_ef10_mac_reconfigure(struct efx_nic *efx, bool mtu_only)
 {
-	efx_mcdi_filter_sync_rx_mode(efx);
-
-	return efx_mcdi_set_mac(efx);
-}
+	WARN_ON(!mutex_is_locked(&efx->mac_lock));
 
-static int efx_ef10_mac_reconfigure_vf(struct efx_nic *efx)
-{
 	efx_mcdi_filter_sync_rx_mode(efx);
 
-	return 0;
+	if (mtu_only && efx_has_cap(efx, SET_MAC_ENHANCED))
+		return efx_mcdi_set_mtu(efx);
+	return efx_mcdi_set_mac(efx);
 }
 
 static int efx_ef10_start_bist(struct efx_nic *efx, u32 bist_type)
@@ -4038,7 +4035,7 @@ const struct efx_nic_type efx_hunt_a0_vf_nic_type = {
 	.stop_stats = efx_port_dummy_op_void,
 	.set_id_led = efx_mcdi_set_id_led,
 	.push_irq_moderation = efx_ef10_push_irq_moderation,
-	.reconfigure_mac = efx_ef10_mac_reconfigure_vf,
+	.reconfigure_mac = efx_ef10_mac_reconfigure,
 	.check_mac_fault = efx_mcdi_mac_check_fault,
 	.reconfigure_port = efx_mcdi_port_reconfigure,
 	.get_wol = efx_ef10_get_wol_vf,
diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 028d826ab147..418676aba43a 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -169,10 +169,6 @@ static int efx_init_port(struct efx_nic *efx)
 
 	efx->port_initialized = true;
 
-	/* Reconfigure the MAC before creating dma queues (required for
-	 * Falcon/A1 where RX_INGR_EN/TX_DRAIN_EN isn't supported) */
-	efx_mac_reconfigure(efx);
-
 	/* Ensure the PHY advertises the correct flow control settings */
 	rc = efx->phy_op->reconfigure(efx);
 	if (rc && rc != -EPERM)
diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index a2f744377aaa..26dca2f9a363 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -139,11 +139,11 @@ void efx_destroy_reset_workqueue(void)
 /* We assume that efx->type->reconfigure_mac will always try to sync RX
  * filters and therefore needs to read-lock the filter table against freeing
  */
-void efx_mac_reconfigure(struct efx_nic *efx)
+void efx_mac_reconfigure(struct efx_nic *efx, bool mtu_only)
 {
 	if (efx->type->reconfigure_mac) {
 		down_read(&efx->filter_sem);
-		efx->type->reconfigure_mac(efx);
+		efx->type->reconfigure_mac(efx, mtu_only);
 		up_read(&efx->filter_sem);
 	}
 }
@@ -158,7 +158,7 @@ static void efx_mac_work(struct work_struct *data)
 
 	mutex_lock(&efx->mac_lock);
 	if (efx->port_enabled)
-		efx_mac_reconfigure(efx);
+		efx_mac_reconfigure(efx, false);
 	mutex_unlock(&efx->mac_lock);
 }
 
@@ -190,7 +190,7 @@ int efx_set_mac_address(struct net_device *net_dev, void *data)
 
 	/* Reconfigure the MAC */
 	mutex_lock(&efx->mac_lock);
-	efx_mac_reconfigure(efx);
+	efx_mac_reconfigure(efx, false);
 	mutex_unlock(&efx->mac_lock);
 
 	return 0;
@@ -304,7 +304,7 @@ int efx_change_mtu(struct net_device *net_dev, int new_mtu)
 
 	mutex_lock(&efx->mac_lock);
 	net_dev->mtu = new_mtu;
-	efx_mac_reconfigure(efx);
+	efx_mac_reconfigure(efx, true);
 	mutex_unlock(&efx->mac_lock);
 
 	efx_start_all(efx);
@@ -486,7 +486,7 @@ static void efx_start_port(struct efx_nic *efx)
 	efx->port_enabled = true;
 
 	/* Ensure MAC ingress/egress is enabled */
-	efx_mac_reconfigure(efx);
+	efx_mac_reconfigure(efx, false);
 
 	mutex_unlock(&efx->mac_lock);
 }
diff --git a/drivers/net/ethernet/sfc/efx_common.h b/drivers/net/ethernet/sfc/efx_common.h
index 73c355fc2590..4056f68f04e5 100644
--- a/drivers/net/ethernet/sfc/efx_common.h
+++ b/drivers/net/ethernet/sfc/efx_common.h
@@ -95,7 +95,7 @@ static inline void efx_init_mcdi_logging(struct efx_nic *efx) {}
 static inline void efx_fini_mcdi_logging(struct efx_nic *efx) {}
 #endif
 
-void efx_mac_reconfigure(struct efx_nic *efx);
+void efx_mac_reconfigure(struct efx_nic *efx, bool mtu_only);
 int efx_set_mac_address(struct net_device *net_dev, void *data);
 void efx_set_rx_mode(struct net_device *net_dev);
 int efx_set_features(struct net_device *net_dev, netdev_features_t data);
diff --git a/drivers/net/ethernet/sfc/ethtool_common.c b/drivers/net/ethernet/sfc/ethtool_common.c
index c96595e50234..738d9be86899 100644
--- a/drivers/net/ethernet/sfc/ethtool_common.c
+++ b/drivers/net/ethernet/sfc/ethtool_common.c
@@ -241,7 +241,7 @@ int efx_ethtool_set_pauseparam(struct net_device *net_dev,
 	/* Reconfigure the MAC. The PHY *may* generate a link state change event
 	 * if the user just changed the advertised capabilities, but there's no
 	 * harm doing this twice */
-	efx_mac_reconfigure(efx);
+	efx_mac_reconfigure(efx, false);
 
 out:
 	mutex_unlock(&efx->mac_lock);
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index e0b84b2e3bd2..65a106878186 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -1356,7 +1356,7 @@ struct efx_nic_type {
 	void (*push_irq_moderation)(struct efx_channel *channel);
 	int (*reconfigure_port)(struct efx_nic *efx);
 	void (*prepare_enable_fc_tx)(struct efx_nic *efx);
-	int (*reconfigure_mac)(struct efx_nic *efx);
+	int (*reconfigure_mac)(struct efx_nic *efx, bool mtu_only);
 	bool (*check_mac_fault)(struct efx_nic *efx);
 	void (*get_wol)(struct efx_nic *efx, struct ethtool_wolinfo *wol);
 	int (*set_wol)(struct efx_nic *efx, u32 type);
diff --git a/drivers/net/ethernet/sfc/siena.c b/drivers/net/ethernet/sfc/siena.c
index ffe193f03352..a7dcd2d3c09b 100644
--- a/drivers/net/ethernet/sfc/siena.c
+++ b/drivers/net/ethernet/sfc/siena.c
@@ -633,7 +633,7 @@ static size_t siena_update_nic_stats(struct efx_nic *efx, u64 *full_stats,
 	return SIENA_STAT_COUNT;
 }
 
-static int siena_mac_reconfigure(struct efx_nic *efx)
+static int siena_mac_reconfigure(struct efx_nic *efx, bool mtu_only __always_unused)
 {
 	MCDI_DECLARE_BUF(inbuf, MC_CMD_SET_MCAST_HASH_IN_LEN);
 	int rc;

