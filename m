Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF1941CD9E2
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 14:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730003AbgEKMaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 08:30:16 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:60774 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729022AbgEKMaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 08:30:14 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.61])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id BC8B6600DB;
        Mon, 11 May 2020 12:30:13 +0000 (UTC)
Received: from us4-mdac16-69.ut7.mdlocal (unknown [10.7.64.188])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id A6B96800BB;
        Mon, 11 May 2020 12:30:13 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.35])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id CEBF280077;
        Mon, 11 May 2020 12:30:12 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id C2666480084;
        Mon, 11 May 2020 12:30:11 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 11 May
 2020 13:30:03 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 8/8] sfc: make firmware-variant printing a nic_type
 function
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <8154dba6-b312-7dcf-7d49-cd6c6801ffc2@solarflare.com>
Message-ID: <5a1d0886-43f3-77bc-3daf-4b9977aadb63@solarflare.com>
Date:   Mon, 11 May 2020 13:30:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <8154dba6-b312-7dcf-7d49-cd6c6801ffc2@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25412.003
X-TM-AS-Result: No-3.183000-8.000000-10
X-TMASE-MatchedRID: YQVLwZ4rohAfKML5AJtfLZzEHTUOuMX3ZAGtCJE23YhjLp8Cm8vwFwoe
        RRhCZWIByf4UUiPmFLqKNuN8MZd1RCHhSBQfglfsA9lly13c/gFnAst8At+c3TnZfxjBVQRbSOo
        omvBCWS4doHUo6v4sGhQQOjWISxzFyGOiXr1rOL4wjFu8zcBWiH6NJZ3HRhRTCuSPuSVW5+4zvj
        wZb2VO2L9hlgfH7/u0oBmAR+FUbO1UdrkDHQOEiJqvoi7RQmPSeXZz1at5bOwS39b8+3nDx/DXI
        SiX9pqQFTBB/IBXpeFTGQDC2c/bxWE8rfc1kKUzbBMSu4v05tPBmIRgpCavmJsoi2XrUn/JyeMt
        MD9QOgBJeFvFlVDkf46HM5rqDwqtZBEYzhxSe7dyvYAMeJlHG/1AUK8tkdWu5EGvsF+UbQu0iq4
        U8ofwshSJw6IU1zxeEL4mMC54UbRK1E82XL6Eg6tP4NfInWJQF8WOpmrvCxtyCYeHQXFONn+IaU
        6aARfSasRgksxQ/TKwzFr1189Za5RMZUCEHkRt
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--3.183000-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25412.003
X-MDID: 1589200213-2X23VzuEldUb
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of having efx_mcdi_print_fwver() look at efx_nic_rev and
 conditionally poke around inside ef10-specific nic_data, add a new
 efx->type->print_additional_fwver() method to do this work.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/ef10.c       | 15 +++++++++++++++
 drivers/net/ethernet/sfc/mcdi.c       | 25 +++++++++----------------
 drivers/net/ethernet/sfc/net_driver.h |  3 +++
 3 files changed, 27 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index d7d2edc4d81a..e634e8110585 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -3978,6 +3978,19 @@ static int efx_ef10_udp_tnl_del_port(struct efx_nic *efx,
 	return rc;
 }
 
+/* EF10 may have multiple datapath firmware variants within a
+ * single version.  Report which variants are running.
+ */
+static size_t efx_ef10_print_additional_fwver(struct efx_nic *efx, char *buf,
+					      size_t len)
+{
+	struct efx_ef10_nic_data *nic_data = efx->nic_data;
+
+	return scnprintf(buf, len, " rx%x tx%x",
+			 nic_data->rx_dpcpu_fw_id,
+			 nic_data->tx_dpcpu_fw_id);
+}
+
 static unsigned int ef10_check_caps(const struct efx_nic *efx,
 				    u8 flag,
 				    u32 offset)
@@ -4107,6 +4120,7 @@ const struct efx_nic_type efx_hunt_a0_vf_nic_type = {
 			    1 << HWTSTAMP_FILTER_ALL,
 	.rx_hash_key_size = 40,
 	.check_caps = ef10_check_caps,
+	.print_additional_fwver = efx_ef10_print_additional_fwver,
 };
 
 const struct efx_nic_type efx_hunt_a0_nic_type = {
@@ -4243,4 +4257,5 @@ const struct efx_nic_type efx_hunt_a0_nic_type = {
 			    1 << HWTSTAMP_FILTER_ALL,
 	.rx_hash_key_size = 40,
 	.check_caps = ef10_check_caps,
+	.print_additional_fwver = efx_ef10_print_additional_fwver,
 };
diff --git a/drivers/net/ethernet/sfc/mcdi.c b/drivers/net/ethernet/sfc/mcdi.c
index 15c731d04065..a8cc3881edce 100644
--- a/drivers/net/ethernet/sfc/mcdi.c
+++ b/drivers/net/ethernet/sfc/mcdi.c
@@ -1425,23 +1425,16 @@ void efx_mcdi_print_fwver(struct efx_nic *efx, char *buf, size_t len)
 			   le16_to_cpu(ver_words[2]),
 			   le16_to_cpu(ver_words[3]));
 
-	/* EF10 may have multiple datapath firmware variants within a
-	 * single version.  Report which variants are running.
-	 */
-	if (efx_nic_rev(efx) >= EFX_REV_HUNT_A0) {
-		struct efx_ef10_nic_data *nic_data = efx->nic_data;
-
-		offset += scnprintf(buf + offset, len - offset, " rx%x tx%x",
-				    nic_data->rx_dpcpu_fw_id,
-				    nic_data->tx_dpcpu_fw_id);
+	if (efx->type->print_additional_fwver)
+		offset += efx->type->print_additional_fwver(efx, buf + offset,
+							    len - offset);
 
-		/* It's theoretically possible for the string to exceed 31
-		 * characters, though in practice the first three version
-		 * components are short enough that this doesn't happen.
-		 */
-		if (WARN_ON(offset >= len))
-			buf[0] = 0;
-	}
+	/* It's theoretically possible for the string to exceed 31
+	 * characters, though in practice the first three version
+	 * components are short enough that this doesn't happen.
+	 */
+	if (WARN_ON(offset >= len))
+		buf[0] = 0;
 
 	return;
 
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index ae9756811dfe..1afb58feb9ab 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -1296,6 +1296,7 @@ struct efx_udp_tunnel {
  * @udp_tnl_add_port: Add a UDP tunnel port
  * @udp_tnl_has_port: Check if a port has been added as UDP tunnel
  * @udp_tnl_del_port: Remove a UDP tunnel port
+ * @print_additional_fwver: Dump NIC-specific additional FW version info
  * @revision: Hardware architecture revision
  * @txd_ptr_tbl_base: TX descriptor ring base address
  * @rxd_ptr_tbl_base: RX descriptor ring base address
@@ -1469,6 +1470,8 @@ struct efx_nic_type {
 	int (*udp_tnl_add_port)(struct efx_nic *efx, struct efx_udp_tunnel tnl);
 	bool (*udp_tnl_has_port)(struct efx_nic *efx, __be16 port);
 	int (*udp_tnl_del_port)(struct efx_nic *efx, struct efx_udp_tunnel tnl);
+	size_t (*print_additional_fwver)(struct efx_nic *efx, char *buf,
+					 size_t len);
 
 	int revision;
 	unsigned int txd_ptr_tbl_base;
