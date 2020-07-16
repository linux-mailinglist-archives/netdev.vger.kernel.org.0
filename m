Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F00322236B
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 15:04:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728683AbgGPNEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 09:04:05 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:56852 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728237AbgGPNEE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 09:04:04 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.60])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id A05C260090;
        Thu, 16 Jul 2020 13:04:04 +0000 (UTC)
Received: from us4-mdac16-20.ut7.mdlocal (unknown [10.7.65.244])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 9F1312009A;
        Thu, 16 Jul 2020 13:04:04 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.32])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 305E31C005E;
        Thu, 16 Jul 2020 13:04:04 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id DC23CB400A2;
        Thu, 16 Jul 2020 13:04:03 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 16 Jul
 2020 14:03:58 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH v3 net-next 14/16] sfc_ef100: probe the PHY and configure the
 MAC
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <7bb4f1f4-c67f-8c7b-86ba-7bf9f74ffc28@solarflare.com>
Message-ID: <cbed944c-5076-4107-879e-2e738e9b8217@solarflare.com>
Date:   Thu, 16 Jul 2020 14:03:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <7bb4f1f4-c67f-8c7b-86ba-7bf9f74ffc28@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25544.003
X-TM-AS-Result: No-3.785900-8.000000-10
X-TMASE-MatchedRID: Yr6Na9Mx/dKh9oPbMj7PPPCoOvLLtsMhljgw/8s6b3cHZBaLwEXlKGlF
        7OhYLlct4Bf6QB/uLAsKcKXSCIuKCdIo0YBrKTWVj0FWpA5CVPlQYo4xNF42PrxgMf9QE2eb45N
        KjsoDTQ9YHxG6vTRI6n5srx3ISKqWN9rojbjxBkwHtOpEBhWiFoiuaoNXJrK/V4i674aSi3zN6o
        aSBNupLxG19haWtoGpEbtwIm1ojqVxZyTdPoSZXSi9uJ8hAvsa+eBf9ovw8I3mWHHSYEnI8WBSh
        v8puDpLQ4vndhhaKjThB5Iilm/06U1+zyfzlN7ygxsfzkNRlfLdB/CxWTRRuwihQpoXbuXFOW9l
        5ncQDgNrR6KYO3kauPqSCDHw74M3smyDvQgIOzlAJ9yzyMJocuqyT56QntFJa2wS7sB5lROQFAH
        uBxny4VY3wfVeK8yPWswIoFcXV3ojZU2CAxYkI/guCCuaxGC9PA0H4ETs+eWeqD9WtJkSIw==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--3.785900-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25544.003
X-MDID: 1594904644-jH4c6JKXURBF
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/ef100_nic.c | 42 +++++++++++++++++++++++++++-
 1 file changed, 41 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index f449960e5b02..aced682a7b08 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -291,16 +291,54 @@ static irqreturn_t ef100_msi_interrupt(int irq, void *dev_id)
 
 static int ef100_phy_probe(struct efx_nic *efx)
 {
-	/* stub: allocate the phy_data */
+	struct efx_mcdi_phy_data *phy_data;
+	int rc;
+
+	/* Probe for the PHY */
 	efx->phy_data = kzalloc(sizeof(struct efx_mcdi_phy_data), GFP_KERNEL);
 	if (!efx->phy_data)
 		return -ENOMEM;
 
+	rc = efx_mcdi_get_phy_cfg(efx, efx->phy_data);
+	if (rc)
+		return rc;
+
+	/* Populate driver and ethtool settings */
+	phy_data = efx->phy_data;
+	mcdi_to_ethtool_linkset(phy_data->media, phy_data->supported_cap,
+				efx->link_advertising);
+	efx->fec_config = mcdi_fec_caps_to_ethtool(phy_data->supported_cap,
+						   false);
+
+	/* Default to Autonegotiated flow control if the PHY supports it */
+	efx->wanted_fc = EFX_FC_RX | EFX_FC_TX;
+	if (phy_data->supported_cap & (1 << MC_CMD_PHY_CAP_AN_LBN))
+		efx->wanted_fc |= EFX_FC_AUTO;
+	efx_link_set_wanted_fc(efx, efx->wanted_fc);
+
+	/* Push settings to the PHY. Failure is not fatal, the user can try to
+	 * fix it using ethtool.
+	 */
+	rc = efx_mcdi_port_reconfigure(efx);
+	if (rc && rc != -EPERM)
+		netif_warn(efx, drv, efx->net_dev,
+			   "could not initialise PHY settings\n");
+
 	return 0;
 }
 
 /*	Other
  */
+static int ef100_reconfigure_mac(struct efx_nic *efx, bool mtu_only)
+{
+	WARN_ON(!mutex_is_locked(&efx->mac_lock));
+
+	efx_mcdi_filter_sync_rx_mode(efx);
+
+	if (mtu_only && efx_has_cap(efx, SET_MAC_ENHANCED))
+		return efx_mcdi_set_mtu(efx);
+	return efx_mcdi_set_mac(efx);
+}
 
 static enum reset_type ef100_map_reset_reason(enum reset_type reason)
 {
@@ -402,6 +440,8 @@ const struct efx_nic_type ef100_pf_nic_type = {
 	.rx_remove = efx_mcdi_rx_remove,
 	.rx_write = ef100_rx_write,
 
+	.reconfigure_mac = ef100_reconfigure_mac,
+
 	/* Per-type bar/size configuration not used on ef100. Location of
 	 * registers is defined by extended capabilities.
 	 */

