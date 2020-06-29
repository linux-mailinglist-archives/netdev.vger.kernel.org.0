Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E703A20D796
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 22:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733110AbgF2TbP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 15:31:15 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:45060 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733096AbgF2TbN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:31:13 -0400
Received: from dispatch1-us1.ppe-hosted.com (localhost.localdomain [127.0.0.1])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 20EDC4DDE8
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 13:34:29 +0000 (UTC)
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.150])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 11353200F4;
        Mon, 29 Jun 2020 13:34:29 +0000 (UTC)
Received: from us4-mdac16-18.at1.mdlocal (unknown [10.110.49.200])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 0E258800A7;
        Mon, 29 Jun 2020 13:34:29 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.102])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id A0A1A100071;
        Mon, 29 Jun 2020 13:34:28 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 522646C007E;
        Mon, 29 Jun 2020 13:34:28 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 29 Jun
 2020 14:34:23 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH v2 net-next 05/15] sfc: refactor EF10 stats handling
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <3750523f-1c2f-628d-1f71-39b355cf6661@solarflare.com>
Message-ID: <56e770db-f4e1-1e40-ca85-3a50fb3cc489@solarflare.com>
Date:   Mon, 29 Jun 2020 14:34:20 +0100
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
X-TM-AS-Result: No-8.926000-8.000000-10
X-TMASE-MatchedRID: D/K/Ifq0XHl7FnefKG6iB0mSRRbSc9s3eouvej40T4gd0WOKRkwsh1ym
        Rv3NQjsEfGzuoVn0Vs6PQi9XuOWoOHI/MxNRI7UkuLt50vtxBA6i8D/o42y/Spl8NETW6pKCPoT
        L90NA+T1Pncvnf9/rJx238RECSCTtobTqT1yfWBXJ1E/nrJFED7vGYJkNeu61DpCUEeEFm7AIPR
        GbB3FI+n9b0LEnkdp7igMIcFldjOufrFd6kw/dZ11B4wg+9pfFyeUl7aCTy8h8vx8dQICa67qjm
        k4TdfSmV0zUTplUZzAoJgC3bbCpe6xVQR/P211REQY87H8wnfn3/H7adAffkmfihW8hWemQXvbV
        /VnUv0pWRNhSC2S3jqgVR1CBhbRvUMt2/UV4TDksisyWO3dp2zeWNSSXCb9unj4yoxsIYn8wV12
        /6ktut/SAdN258YvZf/57oqXw88VFAWNg0/djuub/yj/J/YQcOtlHh2+ppE9D9iPiuXvzgZvwqh
        XQP9LeP4ugMXj9aZeG9lz1CZorVE1+zyfzlN7ygxsfzkNRlfLdB/CxWTRRu25FeHtsUoHuYSrwa
        jfPDnrhArMoFNPteQFyFp50WPFPQ27lFPtyaV3rpcchznD6Bw==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--8.926000-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25510.003
X-MDID: 1593437669-zidaevHiJ4sD
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Separate the generation-count handling from the format conversion, to
 make it easier to re-use both for EF100.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/ef10.c | 68 ++++++++++++++++-----------------
 drivers/net/ethernet/sfc/nic.c  | 45 ++++++++++++++++++++++
 drivers/net/ethernet/sfc/nic.h  |  3 ++
 3 files changed, 82 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index c99fedb315fe..49af06ba7a8e 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -1279,6 +1279,14 @@ static int efx_ef10_dimension_resources(struct efx_nic *efx)
 	return 0;
 }
 
+static void efx_ef10_fini_nic(struct efx_nic *efx)
+{
+	struct efx_ef10_nic_data *nic_data = efx->nic_data;
+
+	kfree(nic_data->mc_stats);
+	nic_data->mc_stats = NULL;
+}
+
 static int efx_ef10_init_nic(struct efx_nic *efx)
 {
 	struct efx_ef10_nic_data *nic_data = efx->nic_data;
@@ -1300,6 +1308,11 @@ static int efx_ef10_init_nic(struct efx_nic *efx)
 		efx->must_realloc_vis = false;
 	}
 
+	nic_data->mc_stats = kmalloc(efx->num_mac_stats * sizeof(__le64),
+				     GFP_KERNEL);
+	if (!nic_data->mc_stats)
+		return -ENOMEM;
+
 	if (nic_data->must_restore_piobufs && nic_data->n_piobufs) {
 		rc = efx_ef10_alloc_piobufs(efx, nic_data->n_piobufs);
 		if (rc == 0) {
@@ -1775,55 +1788,42 @@ static size_t efx_ef10_update_stats_common(struct efx_nic *efx, u64 *full_stats,
 	return stats_count;
 }
 
-static int efx_ef10_try_update_nic_stats_pf(struct efx_nic *efx)
+static size_t efx_ef10_update_stats_pf(struct efx_nic *efx, u64 *full_stats,
+				       struct rtnl_link_stats64 *core_stats)
 {
 	struct efx_ef10_nic_data *nic_data = efx->nic_data;
 	DECLARE_BITMAP(mask, EF10_STAT_COUNT);
-	__le64 generation_start, generation_end;
 	u64 *stats = nic_data->stats;
-	__le64 *dma_stats;
 
 	efx_ef10_get_stat_mask(efx, mask);
 
-	dma_stats = efx->stats_buffer.addr;
-
-	generation_end = dma_stats[efx->num_mac_stats - 1];
-	if (generation_end == EFX_MC_STATS_GENERATION_INVALID)
-		return 0;
-	rmb();
-	efx_nic_update_stats(efx_ef10_stat_desc, EF10_STAT_COUNT, mask,
-			     stats, efx->stats_buffer.addr, false);
-	rmb();
-	generation_start = dma_stats[MC_CMD_MAC_GENERATION_START];
-	if (generation_end != generation_start)
-		return -EAGAIN;
+	efx_nic_copy_stats(efx, nic_data->mc_stats);
+	efx_nic_update_stats(efx_ef10_stat_desc, EF10_STAT_COUNT,
+			     mask, stats, nic_data->mc_stats, false);
 
 	/* Update derived statistics */
 	efx_nic_fix_nodesc_drop_stat(efx,
 				     &stats[EF10_STAT_port_rx_nodesc_drops]);
+	/* MC Firmware reads RX_BYTES and RX_GOOD_BYTES from the MAC.
+	 * It then calculates RX_BAD_BYTES and DMAs it to us with RX_BYTES.
+	 * We report these as port_rx_ stats. We are not given RX_GOOD_BYTES.
+	 * Here we calculate port_rx_good_bytes.
+	 */
 	stats[EF10_STAT_port_rx_good_bytes] =
 		stats[EF10_STAT_port_rx_bytes] -
 		stats[EF10_STAT_port_rx_bytes_minus_good_bytes];
+
+	/* The asynchronous reads used to calculate RX_BAD_BYTES in
+	 * MC Firmware are done such that we should not see an increase in
+	 * RX_BAD_BYTES when a good packet has arrived. Unfortunately this
+	 * does mean that the stat can decrease at times. Here we do not
+	 * update the stat unless it has increased or has gone to zero
+	 * (In the case of the NIC rebooting).
+	 * Please see Bug 33781 for a discussion of why things work this way.
+	 */
 	efx_update_diff_stat(&stats[EF10_STAT_port_rx_bad_bytes],
 			     stats[EF10_STAT_port_rx_bytes_minus_good_bytes]);
 	efx_update_sw_stats(efx, stats);
-	return 0;
-}
-
-
-static size_t efx_ef10_update_stats_pf(struct efx_nic *efx, u64 *full_stats,
-				       struct rtnl_link_stats64 *core_stats)
-{
-	int retry;
-
-	/* If we're unlucky enough to read statistics during the DMA, wait
-	 * up to 10ms for it to finish (typically takes <500us)
-	 */
-	for (retry = 0; retry < 100; ++retry) {
-		if (efx_ef10_try_update_nic_stats_pf(efx) == 0)
-			break;
-		udelay(100);
-	}
 
 	return efx_ef10_update_stats_common(efx, full_stats, core_stats);
 }
@@ -4033,7 +4033,7 @@ const struct efx_nic_type efx_hunt_a0_vf_nic_type = {
 	.remove = efx_ef10_remove,
 	.dimension_resources = efx_ef10_dimension_resources,
 	.init = efx_ef10_init_nic,
-	.fini = efx_port_dummy_op_void,
+	.fini = efx_ef10_fini_nic,
 	.map_reset_reason = efx_ef10_map_reset_reason,
 	.map_reset_flags = efx_ef10_map_reset_flags,
 	.reset = efx_ef10_reset,
@@ -4142,7 +4142,7 @@ const struct efx_nic_type efx_hunt_a0_nic_type = {
 	.remove = efx_ef10_remove,
 	.dimension_resources = efx_ef10_dimension_resources,
 	.init = efx_ef10_init_nic,
-	.fini = efx_port_dummy_op_void,
+	.fini = efx_ef10_fini_nic,
 	.map_reset_reason = efx_ef10_map_reset_reason,
 	.map_reset_flags = efx_ef10_map_reset_flags,
 	.reset = efx_ef10_reset,
diff --git a/drivers/net/ethernet/sfc/nic.c b/drivers/net/ethernet/sfc/nic.c
index b0baa70fbba7..ac6630510324 100644
--- a/drivers/net/ethernet/sfc/nic.c
+++ b/drivers/net/ethernet/sfc/nic.c
@@ -20,6 +20,8 @@
 #include "farch_regs.h"
 #include "io.h"
 #include "workarounds.h"
+#include "mcdi_port_common.h"
+#include "mcdi_pcol.h"
 
 /**************************************************************************
  *
@@ -470,6 +472,49 @@ size_t efx_nic_describe_stats(const struct efx_hw_stat_desc *desc, size_t count,
 	return visible;
 }
 
+/**
+ * efx_nic_copy_stats - Copy stats from the DMA buffer in to an
+ *	intermediate buffer. This is used to get a consistent
+ *	set of stats while the DMA buffer can be written at any time
+ *	by the NIC.
+ * @efx: The associated NIC.
+ * @dest: Destination buffer. Must be the same size as the DMA buffer.
+ */
+int efx_nic_copy_stats(struct efx_nic *efx, __le64 *dest)
+{
+	__le64 *dma_stats = efx->stats_buffer.addr;
+	__le64 generation_start, generation_end;
+	int rc = 0, retry;
+
+	if (!dest)
+		return 0;
+
+	if (!dma_stats)
+		goto return_zeroes;
+
+	/* If we're unlucky enough to read statistics during the DMA, wait
+	 * up to 10ms for it to finish (typically takes <500us)
+	 */
+	for (retry = 0; retry < 100; ++retry) {
+		generation_end = dma_stats[efx->num_mac_stats - 1];
+		if (generation_end == EFX_MC_STATS_GENERATION_INVALID)
+			goto return_zeroes;
+		rmb();
+		memcpy(dest, dma_stats, efx->num_mac_stats * sizeof(__le64));
+		rmb();
+		generation_start = dma_stats[MC_CMD_MAC_GENERATION_START];
+		if (generation_end == generation_start)
+			return 0; /* return good data */
+		udelay(100);
+	}
+
+	rc = -EIO;
+
+return_zeroes:
+	memset(dest, 0, efx->num_mac_stats * sizeof(u64));
+	return rc;
+}
+
 /**
  * efx_nic_update_stats - Convert statistics DMA buffer to array of u64
  * @desc: Array of &struct efx_hw_stat_desc describing the DMA buffer
diff --git a/drivers/net/ethernet/sfc/nic.h b/drivers/net/ethernet/sfc/nic.h
index 8f73c5d996eb..792907aeeb75 100644
--- a/drivers/net/ethernet/sfc/nic.h
+++ b/drivers/net/ethernet/sfc/nic.h
@@ -368,6 +368,7 @@ enum {
  * @piobuf_size: size of a single PIO buffer
  * @must_restore_piobufs: Flag: PIO buffers have yet to be restored after MC
  *	reboot
+ * @mc_stats: Scratch buffer for converting statistics to the kernel's format
  * @stats: Hardware statistics
  * @workaround_35388: Flag: firmware supports workaround for bug 35388
  * @workaround_26807: Flag: firmware supports workaround for bug 26807
@@ -404,6 +405,7 @@ struct efx_ef10_nic_data {
 	unsigned int piobuf_handle[EF10_TX_PIOBUF_COUNT];
 	u16 piobuf_size;
 	bool must_restore_piobufs;
+	__le64 *mc_stats;
 	u64 stats[EF10_STAT_COUNT];
 	bool workaround_35388;
 	bool workaround_26807;
@@ -674,6 +676,7 @@ void efx_nic_get_regs(struct efx_nic *efx, void *buf);
 
 size_t efx_nic_describe_stats(const struct efx_hw_stat_desc *desc, size_t count,
 			      const unsigned long *mask, u8 *names);
+int efx_nic_copy_stats(struct efx_nic *efx, __le64 *dest);
 void efx_nic_update_stats(const struct efx_hw_stat_desc *desc, size_t count,
 			  const unsigned long *mask, u64 *stats,
 			  const void *dma_buf, bool accumulate);

