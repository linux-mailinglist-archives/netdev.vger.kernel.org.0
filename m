Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1C4720D798
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 22:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733118AbgF2TbR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 15:31:17 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:45068 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733097AbgF2TbO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:31:14 -0400
Received: from dispatch1-us1.ppe-hosted.com (localhost.localdomain [127.0.0.1])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 2815A4DE6B
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 13:35:06 +0000 (UTC)
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.137])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 186612008C;
        Mon, 29 Jun 2020 13:35:06 +0000 (UTC)
Received: from us4-mdac16-8.at1.mdlocal (unknown [10.110.49.190])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 16A1D600A1;
        Mon, 29 Jun 2020 13:35:06 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.105])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 9F147220075;
        Mon, 29 Jun 2020 13:35:05 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 51BEC9C008D;
        Mon, 29 Jun 2020 13:35:05 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 29 Jun
 2020 14:35:00 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH v2 net-next 07/15] sfc: commonise ethtool link handling
 functions
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <3750523f-1c2f-628d-1f71-39b355cf6661@solarflare.com>
Message-ID: <a8b267e3-5131-4725-914d-1053d2bba67b@solarflare.com>
Date:   Mon, 29 Jun 2020 14:34:50 +0100
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
X-TM-AS-Result: No-3.765800-8.000000-10
X-TMASE-MatchedRID: jgNy+cJhIFHjtwtQtmXE5bsHVDDM5xAP1JP9NndNOkUGmHr1eMxt2UAc
        6DyoS2rIj6kCfX0Edc6tL1mMSnuv1/LETRWl+wGPpqbreSinCdPcVi8qZmJWc1eIuu+Gkot8/zS
        kYr7c6qBfaf9viEQZNB5pG1lPrPh8ZH34p2+CxhLVsW2YGqoUtAqiBO2qhCIGdLv/+WrG6tOcXp
        v2z7jW5eMecwql2rDBIgh5J3RnkhW39BLh6Bkc7mY+xOrx57jW4OB3iDG6ikmKIo9dsR2z7unQI
        3/RZPRqTI35t8Xee++50l7unAEmSUohWBZ4QV+6SVHYMTQ1F1rMMe1W2YBpiiNGK7UC7ElMfWlr
        04vVSkq4oPkqxH17jOvcAbd0RotA9XUyefCCihBSFqtD2wqeMR+26QzoWaY2jj2Kah8Ix0ajxYy
        RBa/qJQPTK4qtAgwIPcCXjNqUmkVYF3qW3Je6+1x79brRFeOJz990DXiZa2uCdkuQ7bDbtPVZdG
        GWa93Ccp7PsyhSWy5C3J2x4m/IiNt7a6FqVNALbBJwm7psm1bqgKuj261VqDHCqV7rv9Y1QDMFu
        K2P9FjtoWavEW7HRE3Z8jKJCdR04mqLFh5vfmx+3BndfXUhXQ==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--3.765800-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25510.003
X-MDID: 1593437706-3nrpcOUyLmur
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Link speeds, FEC, and autonegotiation are all things EF100 will share.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/ethtool.c        | 148 ----------------------
 drivers/net/ethernet/sfc/ethtool_common.c | 146 +++++++++++++++++++++
 drivers/net/ethernet/sfc/ethtool_common.h |  12 +-
 3 files changed, 157 insertions(+), 149 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ethtool.c b/drivers/net/ethernet/sfc/ethtool.c
index 04e88d05e8ff..55413d451ac3 100644
--- a/drivers/net/ethernet/sfc/ethtool.c
+++ b/drivers/net/ethernet/sfc/ethtool.c
@@ -54,58 +54,6 @@ static int efx_ethtool_phys_id(struct net_device *net_dev,
 	return 0;
 }
 
-/* This must be called with rtnl_lock held. */
-static int
-efx_ethtool_get_link_ksettings(struct net_device *net_dev,
-			       struct ethtool_link_ksettings *cmd)
-{
-	struct efx_nic *efx = netdev_priv(net_dev);
-	struct efx_link_state *link_state = &efx->link_state;
-	u32 supported;
-
-	mutex_lock(&efx->mac_lock);
-	efx->phy_op->get_link_ksettings(efx, cmd);
-	mutex_unlock(&efx->mac_lock);
-
-	/* Both MACs support pause frames (bidirectional and respond-only) */
-	ethtool_convert_link_mode_to_legacy_u32(&supported,
-						cmd->link_modes.supported);
-
-	supported |= SUPPORTED_Pause | SUPPORTED_Asym_Pause;
-
-	ethtool_convert_legacy_u32_to_link_mode(cmd->link_modes.supported,
-						supported);
-
-	if (LOOPBACK_INTERNAL(efx)) {
-		cmd->base.speed = link_state->speed;
-		cmd->base.duplex = link_state->fd ? DUPLEX_FULL : DUPLEX_HALF;
-	}
-
-	return 0;
-}
-
-/* This must be called with rtnl_lock held. */
-static int
-efx_ethtool_set_link_ksettings(struct net_device *net_dev,
-			       const struct ethtool_link_ksettings *cmd)
-{
-	struct efx_nic *efx = netdev_priv(net_dev);
-	int rc;
-
-	/* GMAC does not support 1000Mbps HD */
-	if ((cmd->base.speed == SPEED_1000) &&
-	    (cmd->base.duplex != DUPLEX_FULL)) {
-		netif_dbg(efx, drv, efx->net_dev,
-			  "rejecting unsupported 1000Mbps HD setting\n");
-		return -EINVAL;
-	}
-
-	mutex_lock(&efx->mac_lock);
-	rc = efx->phy_op->set_link_ksettings(efx, cmd);
-	mutex_unlock(&efx->mac_lock);
-	return rc;
-}
-
 static int efx_ethtool_get_regs_len(struct net_device *net_dev)
 {
 	return efx_nic_get_regs_len(netdev_priv(net_dev));
@@ -168,14 +116,6 @@ static void efx_ethtool_self_test(struct net_device *net_dev,
 		test->flags |= ETH_TEST_FL_FAILED;
 }
 
-/* Restart autonegotiation */
-static int efx_ethtool_nway_reset(struct net_device *net_dev)
-{
-	struct efx_nic *efx = netdev_priv(net_dev);
-
-	return mdio45_nway_restart(&efx->mdio);
-}
-
 /*
  * Each channel has a single IRQ and moderation timer, started by any
  * completion (or other event).  Unless the module parameter
@@ -300,64 +240,6 @@ static int efx_ethtool_set_ringparam(struct net_device *net_dev,
 	return efx_realloc_channels(efx, ring->rx_pending, txq_entries);
 }
 
-static int efx_ethtool_set_pauseparam(struct net_device *net_dev,
-				      struct ethtool_pauseparam *pause)
-{
-	struct efx_nic *efx = netdev_priv(net_dev);
-	u8 wanted_fc, old_fc;
-	u32 old_adv;
-	int rc = 0;
-
-	mutex_lock(&efx->mac_lock);
-
-	wanted_fc = ((pause->rx_pause ? EFX_FC_RX : 0) |
-		     (pause->tx_pause ? EFX_FC_TX : 0) |
-		     (pause->autoneg ? EFX_FC_AUTO : 0));
-
-	if ((wanted_fc & EFX_FC_TX) && !(wanted_fc & EFX_FC_RX)) {
-		netif_dbg(efx, drv, efx->net_dev,
-			  "Flow control unsupported: tx ON rx OFF\n");
-		rc = -EINVAL;
-		goto out;
-	}
-
-	if ((wanted_fc & EFX_FC_AUTO) && !efx->link_advertising[0]) {
-		netif_dbg(efx, drv, efx->net_dev,
-			  "Autonegotiation is disabled\n");
-		rc = -EINVAL;
-		goto out;
-	}
-
-	/* Hook for Falcon bug 11482 workaround */
-	if (efx->type->prepare_enable_fc_tx &&
-	    (wanted_fc & EFX_FC_TX) && !(efx->wanted_fc & EFX_FC_TX))
-		efx->type->prepare_enable_fc_tx(efx);
-
-	old_adv = efx->link_advertising[0];
-	old_fc = efx->wanted_fc;
-	efx_link_set_wanted_fc(efx, wanted_fc);
-	if (efx->link_advertising[0] != old_adv ||
-	    (efx->wanted_fc ^ old_fc) & EFX_FC_AUTO) {
-		rc = efx->phy_op->reconfigure(efx);
-		if (rc) {
-			netif_err(efx, drv, efx->net_dev,
-				  "Unable to advertise requested flow "
-				  "control setting\n");
-			goto out;
-		}
-	}
-
-	/* Reconfigure the MAC. The PHY *may* generate a link state change event
-	 * if the user just changed the advertised capabilities, but there's no
-	 * harm doing this twice */
-	efx_mac_reconfigure(efx);
-
-out:
-	mutex_unlock(&efx->mac_lock);
-
-	return rc;
-}
-
 static void efx_ethtool_get_wol(struct net_device *net_dev,
 				struct ethtool_wolinfo *wol)
 {
@@ -1104,36 +986,6 @@ static int efx_ethtool_get_module_info(struct net_device *net_dev,
 	return ret;
 }
 
-static int efx_ethtool_get_fecparam(struct net_device *net_dev,
-				    struct ethtool_fecparam *fecparam)
-{
-	struct efx_nic *efx = netdev_priv(net_dev);
-	int rc;
-
-	if (!efx->phy_op || !efx->phy_op->get_fecparam)
-		return -EOPNOTSUPP;
-	mutex_lock(&efx->mac_lock);
-	rc = efx->phy_op->get_fecparam(efx, fecparam);
-	mutex_unlock(&efx->mac_lock);
-
-	return rc;
-}
-
-static int efx_ethtool_set_fecparam(struct net_device *net_dev,
-				    struct ethtool_fecparam *fecparam)
-{
-	struct efx_nic *efx = netdev_priv(net_dev);
-	int rc;
-
-	if (!efx->phy_op || !efx->phy_op->get_fecparam)
-		return -EOPNOTSUPP;
-	mutex_lock(&efx->mac_lock);
-	rc = efx->phy_op->set_fecparam(efx, fecparam);
-	mutex_unlock(&efx->mac_lock);
-
-	return rc;
-}
-
 const struct ethtool_ops efx_ethtool_ops = {
 	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
 				     ETHTOOL_COALESCE_USECS_IRQ |
diff --git a/drivers/net/ethernet/sfc/ethtool_common.c b/drivers/net/ethernet/sfc/ethtool_common.c
index b8d281ab6c7a..b91961126eeb 100644
--- a/drivers/net/ethernet/sfc/ethtool_common.c
+++ b/drivers/net/ethernet/sfc/ethtool_common.c
@@ -124,6 +124,14 @@ void efx_ethtool_set_msglevel(struct net_device *net_dev, u32 msg_enable)
 	efx->msg_enable = msg_enable;
 }
 
+/* Restart autonegotiation */
+int efx_ethtool_nway_reset(struct net_device *net_dev)
+{
+	struct efx_nic *efx = netdev_priv(net_dev);
+
+	return mdio45_nway_restart(&efx->mdio);
+}
+
 void efx_ethtool_get_pauseparam(struct net_device *net_dev,
 				struct ethtool_pauseparam *pause)
 {
@@ -134,6 +142,64 @@ void efx_ethtool_get_pauseparam(struct net_device *net_dev,
 	pause->autoneg = !!(efx->wanted_fc & EFX_FC_AUTO);
 }
 
+int efx_ethtool_set_pauseparam(struct net_device *net_dev,
+			       struct ethtool_pauseparam *pause)
+{
+	struct efx_nic *efx = netdev_priv(net_dev);
+	u8 wanted_fc, old_fc;
+	u32 old_adv;
+	int rc = 0;
+
+	mutex_lock(&efx->mac_lock);
+
+	wanted_fc = ((pause->rx_pause ? EFX_FC_RX : 0) |
+		     (pause->tx_pause ? EFX_FC_TX : 0) |
+		     (pause->autoneg ? EFX_FC_AUTO : 0));
+
+	if ((wanted_fc & EFX_FC_TX) && !(wanted_fc & EFX_FC_RX)) {
+		netif_dbg(efx, drv, efx->net_dev,
+			  "Flow control unsupported: tx ON rx OFF\n");
+		rc = -EINVAL;
+		goto out;
+	}
+
+	if ((wanted_fc & EFX_FC_AUTO) && !efx->link_advertising[0]) {
+		netif_dbg(efx, drv, efx->net_dev,
+			  "Autonegotiation is disabled\n");
+		rc = -EINVAL;
+		goto out;
+	}
+
+	/* Hook for Falcon bug 11482 workaround */
+	if (efx->type->prepare_enable_fc_tx &&
+	    (wanted_fc & EFX_FC_TX) && !(efx->wanted_fc & EFX_FC_TX))
+		efx->type->prepare_enable_fc_tx(efx);
+
+	old_adv = efx->link_advertising[0];
+	old_fc = efx->wanted_fc;
+	efx_link_set_wanted_fc(efx, wanted_fc);
+	if (efx->link_advertising[0] != old_adv ||
+	    (efx->wanted_fc ^ old_fc) & EFX_FC_AUTO) {
+		rc = efx->phy_op->reconfigure(efx);
+		if (rc) {
+			netif_err(efx, drv, efx->net_dev,
+				  "Unable to advertise requested flow "
+				  "control setting\n");
+			goto out;
+		}
+	}
+
+	/* Reconfigure the MAC. The PHY *may* generate a link state change event
+	 * if the user just changed the advertised capabilities, but there's no
+	 * harm doing this twice */
+	efx_mac_reconfigure(efx);
+
+out:
+	mutex_unlock(&efx->mac_lock);
+
+	return rc;
+}
+
 /**
  * efx_fill_test - fill in an individual self-test entry
  * @test_index:		Index of the test
@@ -455,3 +521,83 @@ void efx_ethtool_get_stats(struct net_device *net_dev,
 
 	efx_ptp_update_stats(efx, data);
 }
+
+/* This must be called with rtnl_lock held. */
+int efx_ethtool_get_link_ksettings(struct net_device *net_dev,
+				   struct ethtool_link_ksettings *cmd)
+{
+	struct efx_nic *efx = netdev_priv(net_dev);
+	struct efx_link_state *link_state = &efx->link_state;
+	u32 supported;
+
+	mutex_lock(&efx->mac_lock);
+	efx->phy_op->get_link_ksettings(efx, cmd);
+	mutex_unlock(&efx->mac_lock);
+
+	/* Both MACs support pause frames (bidirectional and respond-only) */
+	ethtool_convert_link_mode_to_legacy_u32(&supported,
+						cmd->link_modes.supported);
+
+	supported |= SUPPORTED_Pause | SUPPORTED_Asym_Pause;
+
+	ethtool_convert_legacy_u32_to_link_mode(cmd->link_modes.supported,
+						supported);
+
+	if (LOOPBACK_INTERNAL(efx)) {
+		cmd->base.speed = link_state->speed;
+		cmd->base.duplex = link_state->fd ? DUPLEX_FULL : DUPLEX_HALF;
+	}
+
+	return 0;
+}
+
+/* This must be called with rtnl_lock held. */
+int efx_ethtool_set_link_ksettings(struct net_device *net_dev,
+				   const struct ethtool_link_ksettings *cmd)
+{
+	struct efx_nic *efx = netdev_priv(net_dev);
+	int rc;
+
+	/* GMAC does not support 1000Mbps HD */
+	if ((cmd->base.speed == SPEED_1000) &&
+	    (cmd->base.duplex != DUPLEX_FULL)) {
+		netif_dbg(efx, drv, efx->net_dev,
+			  "rejecting unsupported 1000Mbps HD setting\n");
+		return -EINVAL;
+	}
+
+	mutex_lock(&efx->mac_lock);
+	rc = efx->phy_op->set_link_ksettings(efx, cmd);
+	mutex_unlock(&efx->mac_lock);
+	return rc;
+}
+
+int efx_ethtool_get_fecparam(struct net_device *net_dev,
+			     struct ethtool_fecparam *fecparam)
+{
+	struct efx_nic *efx = netdev_priv(net_dev);
+	int rc;
+
+	if (!efx->phy_op || !efx->phy_op->get_fecparam)
+		return -EOPNOTSUPP;
+	mutex_lock(&efx->mac_lock);
+	rc = efx->phy_op->get_fecparam(efx, fecparam);
+	mutex_unlock(&efx->mac_lock);
+
+	return rc;
+}
+
+int efx_ethtool_set_fecparam(struct net_device *net_dev,
+			     struct ethtool_fecparam *fecparam)
+{
+	struct efx_nic *efx = netdev_priv(net_dev);
+	int rc;
+
+	if (!efx->phy_op || !efx->phy_op->get_fecparam)
+		return -EOPNOTSUPP;
+	mutex_lock(&efx->mac_lock);
+	rc = efx->phy_op->set_fecparam(efx, fecparam);
+	mutex_unlock(&efx->mac_lock);
+
+	return rc;
+}
diff --git a/drivers/net/ethernet/sfc/ethtool_common.h b/drivers/net/ethernet/sfc/ethtool_common.h
index fa624313f330..eaa1fd9157f8 100644
--- a/drivers/net/ethernet/sfc/ethtool_common.h
+++ b/drivers/net/ethernet/sfc/ethtool_common.h
@@ -15,8 +15,11 @@ void efx_ethtool_get_drvinfo(struct net_device *net_dev,
 			     struct ethtool_drvinfo *info);
 u32 efx_ethtool_get_msglevel(struct net_device *net_dev);
 void efx_ethtool_set_msglevel(struct net_device *net_dev, u32 msg_enable);
+int efx_ethtool_nway_reset(struct net_device *net_dev);
 void efx_ethtool_get_pauseparam(struct net_device *net_dev,
 				struct ethtool_pauseparam *pause);
+int efx_ethtool_set_pauseparam(struct net_device *net_dev,
+			       struct ethtool_pauseparam *pause);
 int efx_ethtool_fill_self_tests(struct efx_nic *efx,
 				struct efx_self_tests *tests,
 				u8 *strings, u64 *data);
@@ -26,5 +29,12 @@ void efx_ethtool_get_strings(struct net_device *net_dev, u32 string_set,
 void efx_ethtool_get_stats(struct net_device *net_dev,
 			   struct ethtool_stats *stats __attribute__ ((unused)),
 			   u64 *data);
-
+int efx_ethtool_get_link_ksettings(struct net_device *net_dev,
+				   struct ethtool_link_ksettings *out);
+int efx_ethtool_set_link_ksettings(struct net_device *net_dev,
+				   const struct ethtool_link_ksettings *settings);
+int efx_ethtool_get_fecparam(struct net_device *net_dev,
+			     struct ethtool_fecparam *fecparam);
+int efx_ethtool_set_fecparam(struct net_device *net_dev,
+			     struct ethtool_fecparam *fecparam);
 #endif

