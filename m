Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACEEB1B6F03
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 09:28:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726753AbgDXH2M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 03:28:12 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:55784 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726743AbgDXH2J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 03:28:09 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03O7QKUw021188;
        Fri, 24 Apr 2020 00:28:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=FZM+HHWXS5YuySGYw3nh7B/UF4a5ZqALmOWuFRXjccI=;
 b=VnKsUpBKXghdAUcvzg2Q6SfAyKc7C91RJjACNfyKvekRcgcpXH0C00vtC1bmcRtd+lrf
 Am3ZljyhBZcCmcx9nF7X/9JEIM1CPdUvqu1/ADPS3Cj3pH4JmmKD2/MB9lpuih5FI22v
 jNsceCQo3eGs27rWK62wHQrF7K2kS/i+4kOT47KO74QP7dFxfjdYik/b9J/igJOsAmON
 GE4QBnado6ZPJpZCLa9fkeiVTLqg6XAo9Los8siOPTsH18Rx50ez3QskLC4Ej2lzyK0u
 7l1IjgKdba617fmuJSqiGB/hlRLohGAhIwZjCt8etrYFr3dDtj+uFiokD0qkOBcKr1xQ ZQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 30kfdsb47w-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 24 Apr 2020 00:28:06 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 24 Apr
 2020 00:28:04 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 24 Apr 2020 00:28:04 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.46.2])
        by maili.marvell.com (Postfix) with ESMTP id C0D413F7041;
        Fri, 24 Apr 2020 00:28:02 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Dmitry Bogdanov <dbogdanov@marvell.com>,
        "Igor Russkikh" <irusskikh@marvell.com>
Subject: [PATCH net-next 10/17] net: atlantic: minimal A2 fw_ops
Date:   Fri, 24 Apr 2020 10:27:22 +0300
Message-ID: <20200424072729.953-11-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200424072729.953-1-irusskikh@marvell.com>
References: <20200424072729.953-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-24_02:2020-04-23,2020-04-24 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmitry Bogdanov <dbogdanov@marvell.com>

This patch adds the minimum set of FW ops for A2.

Signed-off-by: Dmitry Bogdanov <dbogdanov@marvell.com>
Co-developed-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
---
 .../net/ethernet/aquantia/atlantic/Makefile   |   1 +
 .../atlantic/hw_atl2/hw_atl2_internal.h       |  17 +
 .../aquantia/atlantic/hw_atl2/hw_atl2_utils.h |   5 +
 .../atlantic/hw_atl2/hw_atl2_utils_fw.c       | 329 ++++++++++++++++++
 4 files changed, 352 insertions(+)
 create mode 100644 drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_internal.h
 create mode 100644 drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c

diff --git a/drivers/net/ethernet/aquantia/atlantic/Makefile b/drivers/net/ethernet/aquantia/atlantic/Makefile
index 86824f1868ab..fa845c15d0e1 100644
--- a/drivers/net/ethernet/aquantia/atlantic/Makefile
+++ b/drivers/net/ethernet/aquantia/atlantic/Makefile
@@ -25,6 +25,7 @@ atlantic-objs := aq_main.o \
 	hw_atl/hw_atl_utils.o \
 	hw_atl/hw_atl_utils_fw2x.o \
 	hw_atl/hw_atl_llh.o \
+	hw_atl2/hw_atl2_utils_fw.o \
 	hw_atl2/hw_atl2_llh.o \
 	macsec/macsec_api.o
 
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_internal.h b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_internal.h
new file mode 100644
index 000000000000..233db3222bb8
--- /dev/null
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_internal.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Atlantic Network Driver
+ * Copyright (C) 2020 Marvell International Ltd.
+ */
+
+#ifndef HW_ATL2_INTERNAL_H
+#define HW_ATL2_INTERNAL_H
+
+#include "hw_atl2_utils.h"
+
+#define HW_ATL2_MTU_JUMBO  16352U
+
+struct hw_atl2_priv {
+	struct statistics_s last_stats;
+};
+
+#endif /* HW_ATL2_INTERNAL_H */
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils.h b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils.h
index 90a1e7c723b1..9c830f6d1494 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils.h
@@ -528,4 +528,9 @@ struct fw_interface_out {
 #define  AQ_HOST_MODE_LOW_POWER    3U
 #define  AQ_HOST_MODE_SHUTDOWN     4U
 
+int hw_atl2_utils_get_action_resolve_table_caps(struct aq_hw_s *self,
+						u8 *base_index, u8 *count);
+
+extern const struct aq_fw_ops aq_a2_fw_ops;
+
 #endif /* HW_ATL2_UTILS_H */
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c
new file mode 100644
index 000000000000..9f51b7d144f8
--- /dev/null
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c
@@ -0,0 +1,329 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Atlantic Network Driver
+ * Copyright (C) 2020 Marvell International Ltd.
+ */
+
+#include <linux/iopoll.h>
+
+#include "aq_hw.h"
+#include "hw_atl/hw_atl_llh.h"
+#include "hw_atl2_utils.h"
+#include "hw_atl2_llh.h"
+#include "hw_atl2_internal.h"
+
+#define AQ_A2_FW_READ_TRY_MAX 1000
+
+#define hw_atl2_shared_buffer_write(HW, ITEM, VARIABLE) \
+	hw_atl2_mif_shared_buf_write(HW,\
+		(offsetof(struct fw_interface_in, ITEM) / sizeof(u32)),\
+		(u32 *)&(VARIABLE), sizeof(VARIABLE) / sizeof(u32))
+
+#define hw_atl2_shared_buffer_get(HW, ITEM, VARIABLE) \
+	hw_atl2_mif_shared_buf_get(HW, \
+		(offsetof(struct fw_interface_in, ITEM) / sizeof(u32)),\
+		(u32 *)&(VARIABLE), \
+		sizeof(VARIABLE) / sizeof(u32))
+
+/* This should never be used on non atomic fields,
+ * treat any > u32 read as non atomic.
+ */
+#define hw_atl2_shared_buffer_read(HW, ITEM, VARIABLE) \
+{\
+	BUILD_BUG_ON_MSG((offsetof(struct fw_interface_out, ITEM) % \
+			 sizeof(u32)) != 0,\
+			 "Non aligned read " # ITEM);\
+	BUILD_BUG_ON_MSG(sizeof(VARIABLE) > sizeof(u32),\
+			 "Non atomic read " # ITEM);\
+	hw_atl2_mif_shared_buf_read(HW, \
+		(offsetof(struct fw_interface_out, ITEM) / sizeof(u32)),\
+		(u32 *)&(VARIABLE), sizeof(VARIABLE) / sizeof(u32));\
+}
+
+#define hw_atl2_shared_buffer_read_safe(HW, ITEM, DATA) \
+	hw_atl2_shared_buffer_read_block((HW), \
+		(offsetof(struct fw_interface_out, ITEM) / sizeof(u32)),\
+		sizeof(((struct fw_interface_out *)0)->ITEM) / sizeof(u32),\
+		(DATA))
+
+static int hw_atl2_shared_buffer_read_block(struct aq_hw_s *self,
+					    u32 offset, u32 dwords, void *data)
+{
+	struct transaction_counter_s tid1, tid2;
+	int cnt = 0;
+
+	do {
+		do {
+			hw_atl2_shared_buffer_read(self, transaction_id, tid1);
+			cnt++;
+			if (cnt > AQ_A2_FW_READ_TRY_MAX)
+				return -ETIME;
+			if (tid1.transaction_cnt_a != tid1.transaction_cnt_b)
+				udelay(1);
+		} while (tid1.transaction_cnt_a != tid1.transaction_cnt_b);
+
+		hw_atl2_mif_shared_buf_read(self, offset, (u32 *)data, dwords);
+
+		hw_atl2_shared_buffer_read(self, transaction_id, tid2);
+
+		cnt++;
+		if (cnt > AQ_A2_FW_READ_TRY_MAX)
+			return -ETIME;
+	} while (tid2.transaction_cnt_a != tid2.transaction_cnt_b ||
+		 tid1.transaction_cnt_a != tid2.transaction_cnt_a);
+
+	return 0;
+}
+
+static inline int hw_atl2_shared_buffer_finish_ack(struct aq_hw_s *self)
+{
+	u32 val;
+	int err;
+
+	hw_atl2_mif_host_finished_write_set(self, 1U);
+	err = readx_poll_timeout_atomic(hw_atl2_mif_mcp_finished_read_get,
+					self, val, val == 0U,
+					100, 100000U);
+	WARN(err, "hw_atl2_shared_buffer_finish_ack");
+
+	return err;
+}
+
+static int aq_a2_fw_init(struct aq_hw_s *self)
+{
+	struct link_control_s link_control;
+	u32 mtu;
+	u32 val;
+	int err;
+
+	hw_atl2_shared_buffer_get(self, link_control, link_control);
+	link_control.mode = AQ_HOST_MODE_ACTIVE;
+	hw_atl2_shared_buffer_write(self, link_control, link_control);
+
+	hw_atl2_shared_buffer_get(self, mtu, mtu);
+	mtu = HW_ATL2_MTU_JUMBO;
+	hw_atl2_shared_buffer_write(self, mtu, mtu);
+
+	hw_atl2_mif_host_finished_write_set(self, 1U);
+	err = readx_poll_timeout_atomic(hw_atl2_mif_mcp_finished_read_get,
+					self, val, val == 0U,
+					100, 5000000U);
+	WARN(err, "hw_atl2_shared_buffer_finish_ack");
+
+	return err;
+}
+
+static int aq_a2_fw_deinit(struct aq_hw_s *self)
+{
+	struct link_control_s link_control;
+
+	hw_atl2_shared_buffer_get(self, link_control, link_control);
+	link_control.mode = AQ_HOST_MODE_SHUTDOWN;
+	hw_atl2_shared_buffer_write(self, link_control, link_control);
+
+	return hw_atl2_shared_buffer_finish_ack(self);
+}
+
+static void a2_link_speed_mask2fw(u32 speed,
+				  struct link_options_s *link_options)
+{
+	link_options->rate_10G = !!(speed & AQ_NIC_RATE_10G);
+	link_options->rate_5G = !!(speed & AQ_NIC_RATE_5G);
+	link_options->rate_N5G = !!(speed & AQ_NIC_RATE_5GSR);
+	link_options->rate_2P5G = !!(speed & AQ_NIC_RATE_2GS);
+	link_options->rate_N2P5G = link_options->rate_2P5G;
+	link_options->rate_1G = !!(speed & AQ_NIC_RATE_1G);
+	link_options->rate_100M = !!(speed & AQ_NIC_RATE_100M);
+	link_options->rate_10M = !!(speed & AQ_NIC_RATE_10M);
+}
+
+static int aq_a2_fw_set_link_speed(struct aq_hw_s *self, u32 speed)
+{
+	struct link_options_s link_options;
+
+	hw_atl2_shared_buffer_get(self, link_options, link_options);
+	link_options.link_up = 1U;
+	a2_link_speed_mask2fw(speed, &link_options);
+	hw_atl2_shared_buffer_write(self, link_options, link_options);
+
+	return hw_atl2_shared_buffer_finish_ack(self);
+}
+
+static int aq_a2_fw_set_state(struct aq_hw_s *self,
+			      enum hal_atl_utils_fw_state_e state)
+{
+	struct link_options_s link_options;
+
+	hw_atl2_shared_buffer_get(self, link_options, link_options);
+
+	switch (state) {
+	case MPI_INIT:
+		link_options.link_up = 1U;
+		break;
+	case MPI_DEINIT:
+		link_options.link_up = 0U;
+		break;
+	case MPI_RESET:
+	case MPI_POWER:
+		/* No actions */
+		break;
+	}
+
+	hw_atl2_shared_buffer_write(self, link_options, link_options);
+
+	return hw_atl2_shared_buffer_finish_ack(self);
+}
+
+static int aq_a2_fw_update_link_status(struct aq_hw_s *self)
+{
+	struct link_status_s link_status;
+
+	hw_atl2_shared_buffer_read(self, link_status, link_status);
+
+	switch (link_status.link_rate) {
+	case AQ_A2_FW_LINK_RATE_10G:
+		self->aq_link_status.mbps = 10000;
+		break;
+	case AQ_A2_FW_LINK_RATE_5G:
+		self->aq_link_status.mbps = 5000;
+		break;
+	case AQ_A2_FW_LINK_RATE_2G5:
+		self->aq_link_status.mbps = 2500;
+		break;
+	case AQ_A2_FW_LINK_RATE_1G:
+		self->aq_link_status.mbps = 1000;
+		break;
+	case AQ_A2_FW_LINK_RATE_100M:
+		self->aq_link_status.mbps = 100;
+		break;
+	case AQ_A2_FW_LINK_RATE_10M:
+		self->aq_link_status.mbps = 10;
+		break;
+	default:
+		self->aq_link_status.mbps = 0;
+	}
+
+	return 0;
+}
+
+static int aq_a2_fw_get_mac_permanent(struct aq_hw_s *self, u8 *mac)
+{
+	struct mac_address_s mac_address;
+
+	hw_atl2_shared_buffer_get(self, mac_address, mac_address);
+	ether_addr_copy(mac, (u8 *)mac_address.mac_address);
+
+	if ((mac[0] & 0x01U) || ((mac[0] | mac[1] | mac[2]) == 0x00U)) {
+		unsigned int rnd = 0;
+		u32 h;
+		u32 l;
+
+		get_random_bytes(&rnd, sizeof(unsigned int));
+
+		l = 0xE3000000U | (0xFFFFU & rnd) | (0x00 << 16);
+		h = 0x8001300EU;
+
+		mac[5] = (u8)(0xFFU & l);
+		l >>= 8;
+		mac[4] = (u8)(0xFFU & l);
+		l >>= 8;
+		mac[3] = (u8)(0xFFU & l);
+		l >>= 8;
+		mac[2] = (u8)(0xFFU & l);
+		mac[1] = (u8)(0xFFU & h);
+		h >>= 8;
+		mac[0] = (u8)(0xFFU & h);
+	}
+
+	return 0;
+}
+
+static int aq_a2_fw_update_stats(struct aq_hw_s *self)
+{
+	struct hw_atl2_priv *priv = (struct hw_atl2_priv *)self->priv;
+	struct statistics_s stats;
+
+	hw_atl2_shared_buffer_read_safe(self, stats, &stats);
+
+#define AQ_SDELTA(_N_, _F_) (self->curr_stats._N_ += \
+			stats.msm._F_ - priv->last_stats.msm._F_)
+
+	if (self->aq_link_status.mbps) {
+		AQ_SDELTA(uprc, rx_unicast_frames);
+		AQ_SDELTA(mprc, rx_multicast_frames);
+		AQ_SDELTA(bprc, rx_broadcast_frames);
+		AQ_SDELTA(erpr, rx_error_frames);
+
+		AQ_SDELTA(uptc, tx_unicast_frames);
+		AQ_SDELTA(mptc, tx_multicast_frames);
+		AQ_SDELTA(bptc, tx_broadcast_frames);
+		AQ_SDELTA(erpt, tx_errors);
+
+		AQ_SDELTA(ubrc, rx_unicast_octets);
+		AQ_SDELTA(ubtc, tx_unicast_octets);
+		AQ_SDELTA(mbrc, rx_multicast_octets);
+		AQ_SDELTA(mbtc, tx_multicast_octets);
+		AQ_SDELTA(bbrc, rx_broadcast_octets);
+		AQ_SDELTA(bbtc, tx_broadcast_octets);
+	}
+#undef AQ_SDELTA
+	self->curr_stats.dma_pkt_rc =
+		hw_atl_stats_rx_dma_good_pkt_counter_get(self);
+	self->curr_stats.dma_pkt_tc =
+		hw_atl_stats_tx_dma_good_pkt_counter_get(self);
+	self->curr_stats.dma_oct_rc =
+		hw_atl_stats_rx_dma_good_octet_counter_get(self);
+	self->curr_stats.dma_oct_tc =
+		hw_atl_stats_tx_dma_good_octet_counter_get(self);
+	self->curr_stats.dpc = hw_atl_rpb_rx_dma_drop_pkt_cnt_get(self);
+
+	memcpy(&priv->last_stats, &stats, sizeof(stats));
+
+	return 0;
+}
+
+static int aq_a2_fw_renegotiate(struct aq_hw_s *self)
+{
+	struct link_options_s link_options;
+	int err;
+
+	hw_atl2_shared_buffer_get(self, link_options, link_options);
+	link_options.link_renegotiate = 1U;
+	hw_atl2_shared_buffer_write(self, link_options, link_options);
+
+	err = hw_atl2_shared_buffer_finish_ack(self);
+
+	/* We should put renegotiate status back to zero
+	 * after command completes
+	 */
+	link_options.link_renegotiate = 0U;
+	hw_atl2_shared_buffer_write(self, link_options, link_options);
+
+	return err;
+}
+
+int hw_atl2_utils_get_action_resolve_table_caps(struct aq_hw_s *self,
+						u8 *base_index, u8 *count)
+{
+	struct filter_caps_s filter_caps;
+	int err;
+
+	err = hw_atl2_shared_buffer_read_safe(self, filter_caps, &filter_caps);
+	if (err)
+		return err;
+
+	*base_index = filter_caps.rslv_tbl_base_index;
+	*count = filter_caps.rslv_tbl_count;
+	return 0;
+}
+
+const struct aq_fw_ops aq_a2_fw_ops = {
+	.init               = aq_a2_fw_init,
+	.deinit             = aq_a2_fw_deinit,
+	.reset              = NULL,
+	.renegotiate        = aq_a2_fw_renegotiate,
+	.get_mac_permanent  = aq_a2_fw_get_mac_permanent,
+	.set_link_speed     = aq_a2_fw_set_link_speed,
+	.set_state          = aq_a2_fw_set_state,
+	.update_link_status = aq_a2_fw_update_link_status,
+	.update_stats       = aq_a2_fw_update_stats,
+};
-- 
2.17.1

