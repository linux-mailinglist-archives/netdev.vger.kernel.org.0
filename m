Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69E54213C9A
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 17:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbgGCPdU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 11:33:20 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:45738 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726098AbgGCPdT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 11:33:19 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.137])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 9B06120098;
        Fri,  3 Jul 2020 15:33:18 +0000 (UTC)
Received: from us4-mdac16-10.at1.mdlocal (unknown [10.110.49.192])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 99B9A6009B;
        Fri,  3 Jul 2020 15:33:18 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.107])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 21232220072;
        Fri,  3 Jul 2020 15:33:18 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id C7750280093;
        Fri,  3 Jul 2020 15:33:17 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 3 Jul 2020
 16:33:13 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 07/15] sfc_ef100: implement MCDI transport
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <14d4694e-2493-abd3-b76e-09e38a01b588@solarflare.com>
Message-ID: <28868be6-e0fb-f48c-b1ca-4cc318da7f6c@solarflare.com>
Date:   Fri, 3 Jul 2020 16:33:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <14d4694e-2493-abd3-b76e-09e38a01b588@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25518.003
X-TM-AS-Result: No-11.319900-8.000000-10
X-TMASE-MatchedRID: YNw1G8ZMFRKh9oPbMj7PPPCoOvLLtsMhP6Tki+9nU38HZBaLwEXlKCzy
        bVqWyY2NQpbnr2qRsUlc8y3w14AFDNvWh31RtNY81bFtmBqqFLTcVi8qZmJWc4+Ixb7djOSCSb8
        Woy4yLo4IAEZnJGXRA/tnnh8+7vvDb7QFkjVAWhaqDSBu0tUhr+ZM8S4DYUopR2YNIFh+clETJ7
        4q/iXJiipu7calyAo9bTV/KYdB9WCt7MyBjLt7zjn/wcdfjLjCVCGp3g4/hjuRjx4hNpIk+NkbV
        xyiYfRTt2M/b0y5tZwhoTAGY824W/KSiKFBFYghPja3w1ExF8RcaNB/u5yQq/a7agslQWYYRyqM
        LIj/WA3gYsxc0Oenakj4YJn2mzfPUYdYa4LfLrGfG8+bi+/3vIv8yhR3Ab/7bDD7i2QfyEcnDf+
        57mBigX4+xG7OCBs/MSPjUMycTXefO8RAj0nqTsmR5yDJkPg4hnpDm0ThsHRUjspoiX02F7FmLU
        uqedKxPE7FMRuDJPKRk6XtYogiau9c69BWUTGwC24oEZ6SpSkj80Za3RRg8K+JpMvWhNHbA3mYy
        Okat2Qs0g/gwyNOib5kRQcoTNRmEze1V/T0TyU=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--11.319900-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25518.003
X-MDID: 1593790398-TjOa-R3mybyf
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/ef100_nic.c | 106 +++++++++++++++++++++++++++
 drivers/net/ethernet/sfc/ef100_nic.h |   1 +
 2 files changed, 107 insertions(+)

diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index 27e00b003039..57e56a3f9b14 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -25,11 +25,23 @@
 #include "ef100_netdev.h"
 
 #define EF100_MAX_VIS 4096
+#define EF100_NUM_MCDI_BUFFERS	1
+#define MCDI_BUF_LEN (8 + MCDI_CTL_SDU_LEN_MAX)
 
 #define EF100_RESET_PORT ((ETH_RESET_MAC | ETH_RESET_PHY) << ETH_RESET_SHARED_SHIFT)
 
 /*	MCDI
  */
+static u8 *ef100_mcdi_buf(struct efx_nic *efx, u8 bufid, dma_addr_t *dma_addr)
+{
+	struct ef100_nic_data *nic_data = efx->nic_data;
+
+	if (dma_addr)
+		*dma_addr = nic_data->mcdi_buf.dma_addr +
+			    bufid * ALIGN(MCDI_BUF_LEN, 256);
+	return nic_data->mcdi_buf.addr + bufid * ALIGN(MCDI_BUF_LEN, 256);
+}
+
 static int ef100_get_warm_boot_count(struct efx_nic *efx)
 {
 	efx_dword_t reg;
@@ -46,6 +58,72 @@ static int ef100_get_warm_boot_count(struct efx_nic *efx)
 	}
 }
 
+static void ef100_mcdi_request(struct efx_nic *efx,
+			       const efx_dword_t *hdr, size_t hdr_len,
+			       const efx_dword_t *sdu, size_t sdu_len)
+{
+	dma_addr_t dma_addr;
+	u8 *pdu = ef100_mcdi_buf(efx, 0, &dma_addr);
+
+	memcpy(pdu, hdr, hdr_len);
+	memcpy(pdu + hdr_len, sdu, sdu_len);
+	wmb();
+
+	/* The hardware provides 'low' and 'high' (doorbell) registers
+	 * for passing the 64-bit address of an MCDI request to
+	 * firmware.  However the dwords are swapped by firmware.  The
+	 * least significant bits of the doorbell are then 0 for all
+	 * MCDI requests due to alignment.
+	 */
+	_efx_writed(efx, cpu_to_le32((u64)dma_addr >> 32),  efx_reg(efx, ER_GZ_MC_DB_LWRD));
+	_efx_writed(efx, cpu_to_le32((u32)dma_addr),  efx_reg(efx, ER_GZ_MC_DB_HWRD));
+}
+
+static bool ef100_mcdi_poll_response(struct efx_nic *efx)
+{
+	const efx_dword_t hdr =
+		*(const efx_dword_t *)(ef100_mcdi_buf(efx, 0, NULL));
+
+	rmb();
+	return EFX_DWORD_FIELD(hdr, MCDI_HEADER_RESPONSE);
+}
+
+static void ef100_mcdi_read_response(struct efx_nic *efx,
+				     efx_dword_t *outbuf, size_t offset,
+				     size_t outlen)
+{
+	const u8 *pdu = ef100_mcdi_buf(efx, 0, NULL);
+
+	memcpy(outbuf, pdu + offset, outlen);
+}
+
+static int ef100_mcdi_poll_reboot(struct efx_nic *efx)
+{
+	struct ef100_nic_data *nic_data = efx->nic_data;
+	int rc;
+
+	rc = ef100_get_warm_boot_count(efx);
+	if (rc < 0) {
+		/* The firmware is presumably in the process of
+		 * rebooting.  However, we are supposed to report each
+		 * reboot just once, so we must only do that once we
+		 * can read and store the updated warm boot count.
+		 */
+		return 0;
+	}
+
+	if (rc == nic_data->warm_boot_count)
+		return 0;
+
+	nic_data->warm_boot_count = rc;
+
+	return -EIO;
+}
+
+static void ef100_mcdi_reboot_detected(struct efx_nic *efx)
+{
+}
+
 /*	Event handling
  */
 static int ef100_ev_probe(struct efx_channel *channel)
@@ -142,6 +220,11 @@ const struct efx_nic_type ef100_pf_nic_type = {
 	.is_vf = false,
 	.probe = ef100_probe_pf,
 	.mcdi_max_ver = 2,
+	.mcdi_request = ef100_mcdi_request,
+	.mcdi_poll_response = ef100_mcdi_poll_response,
+	.mcdi_read_response = ef100_mcdi_read_response,
+	.mcdi_poll_reboot = ef100_mcdi_poll_reboot,
+	.mcdi_reboot_detected = ef100_mcdi_reboot_detected,
 	.irq_enable_master = efx_port_dummy_op_void,
 	.irq_disable_non_ev = efx_port_dummy_op_void,
 	.push_irq_moderation = efx_channel_dummy_op_void,
@@ -181,6 +264,15 @@ static int ef100_probe_main(struct efx_nic *efx)
 	net_dev->features |= efx->type->offload_features;
 	net_dev->hw_features |= efx->type->offload_features;
 
+	/* we assume later that we can copy from this buffer in dwords */
+	BUILD_BUG_ON(MCDI_CTL_SDU_LEN_MAX_V2 % 4);
+
+	/* MCDI buffers must be 256 byte aligned. */
+	rc = efx_nic_alloc_buffer(efx, &nic_data->mcdi_buf, MCDI_BUF_LEN,
+				  GFP_KERNEL);
+	if (rc)
+		goto fail;
+
 	/* Get the MC's warm boot count.  In case it's rebooting right
 	 * now, be prepared to retry.
 	 */
@@ -204,6 +296,16 @@ static int ef100_probe_main(struct efx_nic *efx)
 
 	/* Post-IO section. */
 
+	rc = efx_mcdi_init(efx);
+	if (!rc && efx->mcdi->fn_flags &
+		   (1 << MC_CMD_DRV_ATTACH_EXT_OUT_FLAG_NO_ACTIVE_PORT)) {
+		netif_info(efx, probe, efx->net_dev,
+			   "No network port on this PCI function");
+		rc = -ENODEV;
+	}
+	if (rc)
+		goto fail;
+
 	efx->max_vis = EF100_MAX_VIS;
 
 	rc = ef100_phy_probe(efx);
@@ -236,6 +338,10 @@ void ef100_remove(struct efx_nic *efx)
 	efx_fini_channels(efx);
 	kfree(efx->phy_data);
 	efx->phy_data = NULL;
+	efx_mcdi_detach(efx);
+	efx_mcdi_fini(efx);
+	if (nic_data)
+		efx_nic_free_buffer(efx, &nic_data->mcdi_buf);
 	kfree(nic_data);
 	efx->nic_data = NULL;
 }
diff --git a/drivers/net/ethernet/sfc/ef100_nic.h b/drivers/net/ethernet/sfc/ef100_nic.h
index 643111aebba5..a4290d183879 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.h
+++ b/drivers/net/ethernet/sfc/ef100_nic.h
@@ -19,6 +19,7 @@ void ef100_remove(struct efx_nic *efx);
 
 struct ef100_nic_data {
 	struct efx_nic *efx;
+	struct efx_buffer mcdi_buf;
 	u16 warm_boot_count;
 };
 

