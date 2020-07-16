Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF6922236E
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 15:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728722AbgGPNET (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 09:04:19 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:59336 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728708AbgGPNES (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 09:04:18 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.61])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 5397B60147;
        Thu, 16 Jul 2020 13:04:18 +0000 (UTC)
Received: from us4-mdac16-75.ut7.mdlocal (unknown [10.7.64.194])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 4E423800B0;
        Thu, 16 Jul 2020 13:04:18 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.30])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id CFD4180051;
        Thu, 16 Jul 2020 13:04:17 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 87440100081;
        Thu, 16 Jul 2020 13:04:17 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 16 Jul
 2020 14:04:12 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH v3 net-next 15/16] sfc_ef100: read device MAC address at probe
 time
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <7bb4f1f4-c67f-8c7b-86ba-7bf9f74ffc28@solarflare.com>
Message-ID: <2ea1ce47-6a42-a824-1766-bb73587b5d1a@solarflare.com>
Date:   Thu, 16 Jul 2020 14:04:09 +0100
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
X-TM-AS-Result: No-4.579900-8.000000-10
X-TMASE-MatchedRID: j27c26fpUlGh9oPbMj7PPPCoOvLLtsMhP6Tki+9nU39YwVHjLI3nekAc
        6DyoS2rIj6kCfX0Edc5xXpQkwQ35BkgMxOkBoMP0ogGd8wIUGIL54F/2i/DwjZGPHiE2kiT4b/r
        Yol6KtTWXwA3ISEGgm2N0jvDhpUVGUYdYa4LfLrGKYdYQLbymTVFtxRexAk5PVI7KaIl9NhciXD
        bdXlJX0HDDRMSfwYdNqtwi3wMnhCMM8jMXjBF+sDl/1fD/GopdcmfM3DjaQLHEQdG7H66TyJ8TM
        nmE+d0Z/bi8QMmvvwzYOTLQ2Ft3R7PgxOETv4A3SGmAqsto6Q3jZMV1EQqpPb3pRd2lOO2QdXaY
        nie2SG7AH5Htusd1bGTK2y021yPTGhBWFwMpQfUlEjOZsGnBpCAkKbrKkYtno6XmhFfKEURWXGv
        UUmKP2w==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--4.579900-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25544.003
X-MDID: 1594904658-lTTw8RgpFplb
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/ef100_nic.c | 40 +++++++++++++++++++++++++++-
 drivers/net/ethernet/sfc/ef100_nic.h |  1 +
 2 files changed, 40 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index aced682a7b08..7c914b2f71c5 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -126,6 +126,26 @@ static void ef100_mcdi_reboot_detected(struct efx_nic *efx)
 
 /*	MCDI calls
  */
+static int ef100_get_mac_address(struct efx_nic *efx, u8 *mac_address)
+{
+	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_MAC_ADDRESSES_OUT_LEN);
+	size_t outlen;
+	int rc;
+
+	BUILD_BUG_ON(MC_CMD_GET_MAC_ADDRESSES_IN_LEN != 0);
+
+	rc = efx_mcdi_rpc(efx, MC_CMD_GET_MAC_ADDRESSES, NULL, 0,
+			  outbuf, sizeof(outbuf), &outlen);
+	if (rc)
+		return rc;
+	if (outlen < MC_CMD_GET_MAC_ADDRESSES_OUT_LEN)
+		return -EIO;
+
+	ether_addr_copy(mac_address,
+			MCDI_PTR(outbuf, GET_MAC_ADDRESSES_OUT_MAC_ADDR_BASE));
+	return 0;
+}
+
 static int efx_ef100_init_datapath_caps(struct efx_nic *efx)
 {
 	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_CAPABILITIES_V7_OUT_LEN);
@@ -541,7 +561,25 @@ static int ef100_probe_main(struct efx_nic *efx)
 
 int ef100_probe_pf(struct efx_nic *efx)
 {
-	return ef100_probe_main(efx);
+	struct net_device *net_dev = efx->net_dev;
+	struct ef100_nic_data *nic_data;
+	int rc = ef100_probe_main(efx);
+
+	if (rc)
+		goto fail;
+
+	nic_data = efx->nic_data;
+	rc = ef100_get_mac_address(efx, net_dev->perm_addr);
+	if (rc)
+		goto fail;
+	/* Assign MAC address */
+	memcpy(net_dev->dev_addr, net_dev->perm_addr, ETH_ALEN);
+	memcpy(nic_data->port_id, net_dev->perm_addr, ETH_ALEN);
+
+	return 0;
+
+fail:
+	return rc;
 }
 
 void ef100_remove(struct efx_nic *efx)
diff --git a/drivers/net/ethernet/sfc/ef100_nic.h b/drivers/net/ethernet/sfc/ef100_nic.h
index 7744ec85bec6..6367bbb2c9b3 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.h
+++ b/drivers/net/ethernet/sfc/ef100_nic.h
@@ -24,6 +24,7 @@ struct ef100_nic_data {
 	u32 datapath_caps2;
 	u32 datapath_caps3;
 	u16 warm_boot_count;
+	u8 port_id[ETH_ALEN];
 	DECLARE_BITMAP(evq_phases, EFX_MAX_CHANNELS);
 };
 

