Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD2463075C
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 05:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727172AbfEaDzN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 23:55:13 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:41450 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726917AbfEaDyL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 23:54:11 -0400
Received: by mail-io1-f66.google.com with SMTP id w25so6993413ioc.8
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 20:54:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7J80d6jDGrLdHzifPJ0VY7ucmc99kOnuWbfGNwYA58Y=;
        b=RLHVhF/SfM9tmoUTrmHx3ze5aJYIIe8t21/QRU3xsQBo/WeBTPW3NWHTf2qE2noqKM
         A+H7kliAEs8blGxJWwv4ErSRAyvAqdlpDRD3NboA1EOOet9W1FcP+iY/zq5dViCCxxi5
         PjOJ0OYw60BNaSqpdo7xGBq6Tz9xQYTIYUSUQyre8mX4F5yUM6LVXtE/fwxn7jahhh/I
         MVO1mLsZUwe+/AAlWTaM7iWpPXXCXVBocX9EoNKNg6EAEs6KuKtxRF/qCOgjvCPMzVEE
         8DF1WFGgQdVTv6tLPNpKpaNTcvATqgazIe7emrHRTE14t3GPxDWLy3DSEWZx5ZnHSjZK
         AjMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7J80d6jDGrLdHzifPJ0VY7ucmc99kOnuWbfGNwYA58Y=;
        b=SY0ruhcnZKe1+EyH1Qvlzvvdmr5NIhLKGVYAWApEKoufmyHq5PC9gViVNER3JqhcpD
         vI5XvPTmcTpikIvYHweEWZZ689B2UqXFfsGd5tpwhvU8q4SxkEUsPuYQksh2xkdieUUB
         P05E6nlOiwDuR0uw6lgzRxNCVZPaTGi35mguH0MfGzbCjdTZwvOLlDwNx8xNPPpjehjV
         y3ARBl0L5DE4/pHF+kXWEoTIf4QIxmGwkDoXn9B08naOyKw1UxpCT/Tk4rssb3Jpuc8t
         hMCnWuwnVlVpGd2NeEZRwltpv56BuPh0Xp54gqj+f/LvDpo9HcnxPmxewtzwcqM5MddV
         EuBw==
X-Gm-Message-State: APjAAAU1eJpd3JKK4BWnccfjxe9K3Id8XnCmo5tcxbu1XlaNn9tMAgKX
        FJukzsNlycpnIUbqbzAJPnGzCg==
X-Google-Smtp-Source: APXvYqxVQ7YNDZ7hDqC9Mk1Teg/q2QTpDMa4tS3LmtqCqCXCZLI1bRW00YghKvxhOf+XfLGHzxN8yw==
X-Received: by 2002:a05:6602:2245:: with SMTP id o5mr3638781ioo.59.1559274849286;
        Thu, 30 May 2019 20:54:09 -0700 (PDT)
Received: from localhost.localdomain (c-71-195-29-92.hsd1.mn.comcast.net. [71.195.29.92])
        by smtp.gmail.com with ESMTPSA id q15sm1626947ioi.15.2019.05.30.20.54.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 20:54:08 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, arnd@arndb.de, bjorn.andersson@linaro.org,
        ilias.apalodimas@linaro.org
Cc:     evgreen@chromium.org, benchan@google.com, ejcaruso@google.com,
        cpratapa@codeaurora.org, syadagir@codeaurora.org,
        subashab@codeaurora.org, abhishek.esse@gmail.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org
Subject: [PATCH v2 10/17] soc: qcom: ipa: IPA endpoints
Date:   Thu, 30 May 2019 22:53:41 -0500
Message-Id: <20190531035348.7194-11-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190531035348.7194-1-elder@linaro.org>
References: <20190531035348.7194-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch includes the code implementing an IPA endpoint.  This is
the primary abstraction implemented by the IPA.  An endpoint is one
end of a network connection between two entities physically
connected to the IPA.  Specifically, the AP and the modem implement
endpoints, and an (AP endpoint, modem endpoint) pair implements the
transfer of network data in one direction between the AP and modem.

Endpoints are built on top of GSI channels, but IPA endpoints
represent the higher-level functionality that the IPA provides.
Data can be sent through a GSI channel, but it is the IPA endpoint
that represents what is on the "other end" to receive that data.
Other functionality, including aggregation, checksum offload and
(at some future date) IP routing and filtering are all associated
with the IPA endpoint.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_endpoint.c | 1283 ++++++++++++++++++++++++++++++++
 drivers/net/ipa/ipa_endpoint.h |   97 +++
 2 files changed, 1380 insertions(+)
 create mode 100644 drivers/net/ipa/ipa_endpoint.c
 create mode 100644 drivers/net/ipa/ipa_endpoint.h

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
new file mode 100644
index 000000000000..0185db35033d
--- /dev/null
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -0,0 +1,1283 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
+ * Copyright (C) 2019 Linaro Ltd.
+ */
+
+#include <linux/types.h>
+#include <linux/device.h>
+#include <linux/slab.h>
+#include <linux/bitfield.h>
+#include <linux/if_rmnet.h>
+
+#include "gsi.h"
+#include "gsi_trans.h"
+#include "ipa.h"
+#include "ipa_data.h"
+#include "ipa_endpoint.h"
+#include "ipa_cmd.h"
+#include "ipa_mem.h"
+#include "ipa_netdev.h"
+
+#define atomic_dec_not_zero(v)	atomic_add_unless((v), -1, 0)
+
+#define IPA_REPLENISH_BATCH	16
+
+#define IPA_RX_BUFFER_SIZE	(PAGE_SIZE << IPA_RX_BUFFER_ORDER)
+#define IPA_RX_BUFFER_ORDER	1	/* 8KB endpoint RX buffers (2 pages) */
+
+/* The amount of RX buffer space consumed by standard skb overhead */
+#define IPA_RX_BUFFER_OVERHEAD	(PAGE_SIZE - SKB_MAX_ORDER(NET_SKB_PAD, 0))
+
+#define IPA_ENDPOINT_STOP_RETRY_MAX		10
+#define IPA_ENDPOINT_STOP_RX_SIZE		1	/* bytes */
+
+#define IPA_ENDPOINT_RESET_AGGR_RETRY_MAX	3
+#define IPA_AGGR_TIME_LIMIT_DEFAULT		1	/* milliseconds */
+
+/** enum ipa_status_opcode - status element opcode hardware values */
+enum ipa_status_opcode {
+	IPA_STATUS_OPCODE_PACKET		= 0x01,
+	IPA_STATUS_OPCODE_NEW_FRAG_RULE		= 0x02,
+	IPA_STATUS_OPCODE_DROPPED_PACKET	= 0x04,
+	IPA_STATUS_OPCODE_SUSPENDED_PACKET	= 0x08,
+	IPA_STATUS_OPCODE_LOG			= 0x10,
+	IPA_STATUS_OPCODE_DCMP			= 0x20,
+	IPA_STATUS_OPCODE_PACKET_2ND_PASS	= 0x40,
+};
+
+/** enum ipa_status_exception - status element exception type */
+enum ipa_status_exception {
+	IPA_STATUS_EXCEPTION_NONE,
+	IPA_STATUS_EXCEPTION_DEAGGR,
+	IPA_STATUS_EXCEPTION_IPTYPE,
+	IPA_STATUS_EXCEPTION_PACKET_LENGTH,
+	IPA_STATUS_EXCEPTION_PACKET_THRESHOLD,
+	IPA_STATUS_EXCEPTION_FRAG_RULE_MISS,
+	IPA_STATUS_EXCEPTION_SW_FILT,
+	IPA_STATUS_EXCEPTION_NAT,
+	IPA_STATUS_EXCEPTION_IPV6CT,
+	IPA_STATUS_EXCEPTION_MAX,
+};
+
+/**
+ * struct ipa_status - Abstracted IPA status element
+ * @opcode:		Status element type
+ * @exception:		The first exception that took place
+ * @pkt_len:		Payload length
+ * @dst_endpoint:	Destination endpoint
+ * @metadata:		32-bit metadata value used by packet
+ * @rt_miss:		Flag; if 1, indicates there was a routing rule miss
+ *
+ * Note that the hardware status element supplies additional information
+ * that is currently unused.
+ */
+struct ipa_status {
+	enum ipa_status_opcode opcode;
+	enum ipa_status_exception exception;
+	u32 pkt_len;
+	u32 dst_endpoint;
+	u32 metadata;
+	u32 rt_miss;
+};
+
+/* Field masks for struct ipa_status_raw structure fields */
+
+#define IPA_STATUS_SRC_IDX_FMASK		GENMASK(4, 0)
+
+#define IPA_STATUS_DST_IDX_FMASK		GENMASK(4, 0)
+
+#define IPA_STATUS_FLAGS1_FLT_LOCAL_FMASK	GENMASK(0, 0)
+#define IPA_STATUS_FLAGS1_FLT_HASH_FMASK	GENMASK(1, 1)
+#define IPA_STATUS_FLAGS1_FLT_GLOBAL_FMASK	GENMASK(2, 2)
+#define IPA_STATUS_FLAGS1_FLT_RET_HDR_FMASK	GENMASK(3, 3)
+#define IPA_STATUS_FLAGS1_FLT_RULE_ID_FMASK	GENMASK(13, 4)
+#define IPA_STATUS_FLAGS1_RT_LOCAL_FMASK	GENMASK(14, 14)
+#define IPA_STATUS_FLAGS1_RT_HASH_FMASK		GENMASK(15, 15)
+#define IPA_STATUS_FLAGS1_UCP_FMASK		GENMASK(16, 16)
+#define IPA_STATUS_FLAGS1_RT_TBL_IDX_FMASK	GENMASK(21, 17)
+#define IPA_STATUS_FLAGS1_RT_RULE_ID_FMASK	GENMASK(31, 22)
+
+#define IPA_STATUS_FLAGS2_NAT_HIT_FMASK		GENMASK_ULL(0, 0)
+#define IPA_STATUS_FLAGS2_NAT_ENTRY_IDX_FMASK	GENMASK_ULL(13, 1)
+#define IPA_STATUS_FLAGS2_NAT_TYPE_FMASK	GENMASK_ULL(15, 14)
+#define IPA_STATUS_FLAGS2_TAG_INFO_FMASK	GENMASK_ULL(63, 16)
+
+#define IPA_STATUS_FLAGS3_SEQ_NUM_FMASK		GENMASK(7, 0)
+#define IPA_STATUS_FLAGS3_TOD_CTR_FMASK		GENMASK(31, 8)
+
+#define IPA_STATUS_FLAGS4_HDR_LOCAL_FMASK	GENMASK(0, 0)
+#define IPA_STATUS_FLAGS4_HDR_OFFSET_FMASK	GENMASK(10, 1)
+#define IPA_STATUS_FLAGS4_FRAG_HIT_FMASK	GENMASK(11, 11)
+#define IPA_STATUS_FLAGS4_FRAG_RULE_FMASK	GENMASK(15, 12)
+#define IPA_STATUS_FLAGS4_HW_SPECIFIC_FMASK	GENMASK(31, 16)
+
+/* Status element provided by hardware */
+struct ipa_status_raw {
+	u8 opcode;
+	u8 exception;
+	u16 mask;
+	u16 pkt_len;
+	u8 endp_src_idx;	/* Only bottom 5 bits valid */
+	u8 endp_dst_idx;	/* Only bottom 5 bits valid */
+	u32 metadata;
+	u32 flags1;
+	u64 flags2;
+	u32 flags3;
+	u32 flags4;
+};
+
+static void ipa_endpoint_replenish(struct ipa_endpoint *endpoint, bool add_one);
+
+/* suspend_delay represents suspend for RX, delay for TX endpoints */
+bool ipa_endpoint_init_ctrl(struct ipa_endpoint *endpoint, bool suspend_delay)
+{
+	u32 offset = IPA_REG_ENDP_INIT_CTRL_N_OFFSET(endpoint->endpoint_id);
+	u32 mask;
+	u32 val;
+
+	mask = endpoint->toward_ipa ? ENDP_DELAY_FMASK : ENDP_SUSPEND_FMASK;
+
+	val = ioread32(endpoint->ipa->reg_virt + offset);
+	if (suspend_delay == !!(val & mask))
+		return false;	/* Already set to desired state */
+
+	val ^= mask;
+	iowrite32(val, endpoint->ipa->reg_virt + offset);
+
+	return true;
+}
+
+static void ipa_endpoint_init_cfg(struct ipa_endpoint *endpoint)
+{
+	u32 offset = IPA_REG_ENDP_INIT_CFG_N_OFFSET(endpoint->endpoint_id);
+	u32 val = 0;
+
+	/* FRAG_OFFLOAD_EN is 0 */
+	if (endpoint->data->config.checksum) {
+		if (endpoint->toward_ipa) {
+			u32 checksum_offset;
+
+			val |= u32_encode_bits(IPA_CS_OFFLOAD_UL,
+					       CS_OFFLOAD_EN_FMASK);
+			/* Checksum header offset is in 4-byte units */
+			checksum_offset = sizeof(struct rmnet_map_header);
+			checksum_offset /= sizeof(u32);
+			val |= u32_encode_bits(checksum_offset,
+					       CS_METADATA_HDR_OFFSET_FMASK);
+		} else {
+			val |= u32_encode_bits(IPA_CS_OFFLOAD_DL,
+					       CS_OFFLOAD_EN_FMASK);
+		}
+	} else {
+		val |= u32_encode_bits(IPA_CS_OFFLOAD_NONE,
+				       CS_OFFLOAD_EN_FMASK);
+	}
+	/* CS_GEN_QMB_MASTER_SEL is 0 */
+
+	iowrite32(val, endpoint->ipa->reg_virt + offset);
+}
+
+static void ipa_endpoint_init_hdr(struct ipa_endpoint *endpoint)
+{
+	u32 offset = IPA_REG_ENDP_INIT_HDR_N_OFFSET(endpoint->endpoint_id);
+	u32 val = 0;
+
+	if (endpoint->data->config.qmap) {
+		size_t header_size = sizeof(struct rmnet_map_header);
+
+		if (endpoint->toward_ipa && endpoint->data->config.checksum)
+			header_size += sizeof(struct rmnet_map_ul_csum_header);
+
+		val |= u32_encode_bits(header_size, HDR_LEN_FMASK);
+		/* metadata is the 4 byte rmnet_map header itself */
+		val |= HDR_OFST_METADATA_VALID_FMASK;
+		val |= u32_encode_bits(0, HDR_OFST_METADATA_FMASK);
+		/* HDR_ADDITIONAL_CONST_LEN is 0; (IPA->AP only) */
+		if (!endpoint->toward_ipa) {
+			u32 size_offset = offsetof(struct rmnet_map_header,
+						   pkt_len);
+
+			val |= HDR_OFST_PKT_SIZE_VALID_FMASK;
+			val |= u32_encode_bits(size_offset,
+					       HDR_OFST_PKT_SIZE_FMASK);
+		}
+		/* HDR_A5_MUX is 0 */
+		/* HDR_LEN_INC_DEAGG_HDR is 0 */
+		/* HDR_METADATA_REG_VALID is 0; (AP->IPA only) */
+	}
+
+	iowrite32(val, endpoint->ipa->reg_virt + offset);
+}
+
+static void ipa_endpoint_init_hdr_ext(struct ipa_endpoint *endpoint)
+{
+	u32 offset = IPA_REG_ENDP_INIT_HDR_EXT_N_OFFSET(endpoint->endpoint_id);
+	u32 pad_align = endpoint->data->config.rx.pad_align;
+	u32 val = 0;
+
+	val |= HDR_ENDIANNESS_FMASK;		/* big endian */
+	val |= HDR_TOTAL_LEN_OR_PAD_VALID_FMASK;
+	/* HDR_TOTAL_LEN_OR_PAD is 0 (pad, not total_len) */
+	/* HDR_PAYLOAD_LEN_INC_PADDING is 0 */
+	/* HDR_TOTAL_LEN_OR_PAD_OFFSET is 0 */
+	if (!endpoint->toward_ipa)
+		val |= u32_encode_bits(pad_align, HDR_PAD_TO_ALIGNMENT_FMASK);
+
+	iowrite32(val, endpoint->ipa->reg_virt + offset);
+}
+
+/**
+ * Generate a metadata mask value that will select only the mux_id
+ * field in an rmnet_map header structure.  The mux_id is at offset
+ * 1 byte from the beginning of the structure, but the metadata
+ * value is treated as a 4-byte unit.  So this mask must be computed
+ * with endianness in mind.  Note that ipa_endpoint_init_hdr_metadata_mask()
+ * will convert this value to the proper byte order.
+ *
+ * Marked __always_inline because this is really computing a
+ * constant value.
+ */
+static __always_inline __be32 ipa_rmnet_mux_id_metadata_mask(void)
+{
+	size_t mux_id_offset = offsetof(struct rmnet_map_header, mux_id);
+	u32 mux_id_mask = 0;
+	u8 *bytes;
+
+	bytes = (u8 *)&mux_id_mask;
+	bytes[mux_id_offset] = 0xff;	/* mux_id is 1 byte */
+
+	return cpu_to_be32(mux_id_mask);
+}
+
+static void ipa_endpoint_init_hdr_metadata_mask(struct ipa_endpoint *endpoint)
+{
+	u32 endpoint_id = endpoint->endpoint_id;
+	u32 val = 0;
+	u32 offset;
+
+	offset = IPA_REG_ENDP_INIT_HDR_METADATA_MASK_N_OFFSET(endpoint_id);
+
+	if (!endpoint->toward_ipa && endpoint->data->config.qmap)
+		val = ipa_rmnet_mux_id_metadata_mask();
+
+	iowrite32(val, endpoint->ipa->reg_virt + offset);
+}
+
+/* Compute the aggregation size value to use for a given buffer size */
+static u32 ipa_aggr_size_kb(u32 rx_buffer_size)
+{
+	BUILD_BUG_ON(IPA_RX_BUFFER_SIZE >
+		     field_max(AGGR_BYTE_LIMIT_FMASK) * SZ_1K +
+		     IPA_MTU + IPA_RX_BUFFER_OVERHEAD);
+
+	/* Because we don't have the "hard byte limit" enabled, we
+	 * need to make sure there's enough space in the buffer to
+	 * receive a complete MTU (plus normal skb overhead) beyond
+	 * the aggregated size limit we specify.
+	 */
+	rx_buffer_size -= IPA_MTU + IPA_RX_BUFFER_OVERHEAD;
+
+	return rx_buffer_size / SZ_1K;
+}
+
+static void ipa_endpoint_init_aggr(struct ipa_endpoint *endpoint)
+{
+	const struct ipa_endpoint_config_data *config = &endpoint->data->config;
+	u32 offset = IPA_REG_ENDP_INIT_AGGR_N_OFFSET(endpoint->endpoint_id);
+	u32 val = 0;
+
+	if (config->aggregation) {
+		if (!endpoint->toward_ipa) {
+			u32 aggr_size = ipa_aggr_size_kb(IPA_RX_BUFFER_SIZE);
+
+			val |= u32_encode_bits(IPA_ENABLE_AGGR, AGGR_EN_FMASK);
+			val |= u32_encode_bits(IPA_GENERIC, AGGR_TYPE_FMASK);
+			val |= u32_encode_bits(aggr_size,
+					       AGGR_BYTE_LIMIT_FMASK);
+			val |= u32_encode_bits(IPA_AGGR_TIME_LIMIT_DEFAULT,
+					       AGGR_TIME_LIMIT_FMASK);
+			val |= u32_encode_bits(0, AGGR_PKT_LIMIT_FMASK);
+			if (config->rx.aggr_close_eof)
+				val |= AGGR_SW_EOF_ACTIVE_FMASK;
+			/* AGGR_HARD_BYTE_LIMIT_ENABLE is 0 */
+		} else {
+			val |= u32_encode_bits(IPA_ENABLE_DEAGGR,
+					       AGGR_EN_FMASK);
+			val |= u32_encode_bits(IPA_QCMAP, AGGR_TYPE_FMASK);
+			/* other fields ignored */
+		}
+		/* AGGR_FORCE_CLOSE is 0 */
+	} else {
+		val |= u32_encode_bits(IPA_BYPASS_AGGR, AGGR_EN_FMASK);
+		/* other fields ignored */
+	}
+
+	iowrite32(val, endpoint->ipa->reg_virt + offset);
+}
+
+static void ipa_endpoint_init_mode(struct ipa_endpoint *endpoint)
+{
+	u32 offset = IPA_REG_ENDP_INIT_MODE_N_OFFSET(endpoint->endpoint_id);
+	u32 val = 0;
+
+	if (endpoint->toward_ipa && endpoint->data->config.dma_mode) {
+		u32 dma_endpoint_id = endpoint->data->config.dma_endpoint;
+
+		val |= u32_encode_bits(IPA_DMA, MODE_FMASK);
+		val |= u32_encode_bits(dma_endpoint_id, DEST_PIPE_INDEX_FMASK);
+	} else {
+		val |= u32_encode_bits(IPA_BASIC, MODE_FMASK);
+	}
+	/* Other bitfields unspecified (and 0) */
+
+	iowrite32(val, endpoint->ipa->reg_virt + offset);
+}
+
+static void ipa_endpoint_init_deaggr(struct ipa_endpoint *endpoint)
+{
+	u32 offset = IPA_REG_ENDP_INIT_DEAGGR_N_OFFSET(endpoint->endpoint_id);
+	u32 val = 0;
+
+	/* DEAGGR_HDR_LEN is 0 */
+	/* PACKET_OFFSET_VALID is 0 */
+	/* PACKET_OFFSET_LOCATION is ignored (not valid) */
+	/* MAX_PACKET_LEN is 0 (not enforced) */
+
+	iowrite32(val, endpoint->ipa->reg_virt + offset);
+}
+
+static void ipa_endpoint_init_seq(struct ipa_endpoint *endpoint)
+{
+	u32 offset = IPA_REG_ENDP_INIT_SEQ_N_OFFSET(endpoint->endpoint_id);
+	u32 seq_type = endpoint->data->seq_type;
+	u32 val = 0;
+
+	val |= u32_encode_bits(seq_type & 0xf, HPS_SEQ_TYPE_FMASK);
+	val |= u32_encode_bits((seq_type >> 4) & 0xf, DPS_SEQ_TYPE_FMASK);
+	/* HPS_REP_SEQ_TYPE is 0 */
+	/* DPS_REP_SEQ_TYPE is 0 */
+
+	iowrite32(val, endpoint->ipa->reg_virt + offset);
+}
+
+/* Complete transaction initiated in ipa_endpoint_skb_tx() */
+void ipa_endpoint_skb_tx_complete(struct gsi_trans *trans)
+{
+	struct sk_buff *skb = trans->data;
+
+	dev_kfree_skb_any(skb);
+}
+
+/**
+ * ipa_endpoint_skb_tx() - Transmit a socket buffer
+ * @endpoint:	Endpoint pointer
+ * @skb:	Socket buffer to send
+ *
+ * Returns:	0 if successful, or a negative error code
+ */
+int ipa_endpoint_skb_tx(struct ipa_endpoint *endpoint, struct sk_buff *skb)
+{
+	struct gsi_trans *trans;
+	u32 nr_frags;
+	int ret;
+
+	/* Make sure source endpoint's TLV FIFO has enough entries to
+	 * hold the linear portion of the skb and all its fragments.
+	 * If not, see if we can linearize it before giving up.
+	 */
+	nr_frags = skb_shinfo(skb)->nr_frags;
+	if (1 + nr_frags > endpoint->trans_tre_max) {
+		if (skb_linearize(skb))
+			return -ENOMEM;
+		nr_frags = 0;
+	}
+
+	trans = gsi_channel_trans_alloc(&endpoint->ipa->gsi,
+					endpoint->channel_id, nr_frags + 1);
+	if (!trans)
+		return -EBUSY;
+	trans->data = skb;
+
+	ret = skb_to_sgvec(skb, trans->sgl, 0, skb->len);
+	if (ret < 0)
+		goto err_trans_free;
+	trans->sgc = ret;
+
+	ret = gsi_trans_commit(trans, !netdev_xmit_more());
+	if (ret)
+		goto err_trans_free;
+	return 0;
+
+err_trans_free:
+	gsi_trans_free(trans);
+
+	return -ENOMEM;
+}
+
+static void ipa_endpoint_status(struct ipa_endpoint *endpoint)
+{
+	const struct ipa_endpoint_config_data *config = &endpoint->data->config;
+	enum ipa_endpoint_id endpoint_id = endpoint->endpoint_id;
+	u32 val = 0;
+	u32 offset;
+
+	offset = IPA_REG_ENDP_STATUS_N_OFFSET(endpoint_id);
+
+	if (endpoint->data->config.status_enable) {
+		val |= STATUS_EN_FMASK;
+		if (endpoint->toward_ipa) {
+			u32 status_endpoint_id = config->tx.status_endpoint;
+
+			val |= u32_encode_bits(status_endpoint_id,
+					       STATUS_ENDP_FMASK);
+		}
+		/* STATUS_LOCATION is 0 (status element precedes packet) */
+		/* STATUS_PKT_SUPPRESS_FMASK */
+	}
+
+	iowrite32(val, endpoint->ipa->reg_virt + offset);
+}
+
+static void ipa_endpoint_skb_copy(struct ipa_endpoint *endpoint,
+				  void *data, u32 len, u32 extra)
+{
+	struct sk_buff *skb;
+
+	skb = __dev_alloc_skb(len, GFP_ATOMIC);
+	if (skb) {
+		skb_put(skb, len);
+		memcpy(skb->data, data, len);
+		skb->truesize += extra;
+	}
+
+	/* Now receive it, or drop it if there's no netdev */
+	if (endpoint->netdev)
+		ipa_netdev_skb_rx(endpoint->netdev, skb);
+	else if (skb)
+		dev_kfree_skb_any(skb);
+}
+
+static void ipa_endpoint_skb_build(struct ipa_endpoint *endpoint,
+				   struct page *page, u32 len)
+{
+	struct sk_buff *skb;
+
+	/* assert(len <= SKB_WITH_OVERHEAD(IPA_RX_BUFFER_SIZE-NET_SKB_PAD)); */
+	skb = build_skb(page_address(page), IPA_RX_BUFFER_SIZE);
+	if (skb) {
+		/* Reserve the headroom and account for the data */
+		skb_reserve(skb, NET_SKB_PAD);
+		skb_put(skb, len);
+	}
+
+	/* Now receive it, or drop it if there's no netdev */
+	if (endpoint->netdev)
+		ipa_netdev_skb_rx(endpoint->netdev, skb);
+	else if (skb)
+		dev_kfree_skb_any(skb);
+
+	/* If no socket buffer took the pages, free them */
+	if (!skb)
+		__free_pages(page, IPA_RX_BUFFER_ORDER);
+}
+
+/* Maps an exception type returned in a ipa_status_raw structure
+ * to the ipa_status_exception value that represents it in
+ * the exception field of a ipa_status structure.  Returns
+ * IPA_STATUS_EXCEPTION_MAX for an unrecognized value.
+ */
+static enum ipa_status_exception exception_map(u8 exception, bool is_ipv6)
+{
+	switch (exception) {
+	case 0x00:	return IPA_STATUS_EXCEPTION_NONE;
+	case 0x01:	return IPA_STATUS_EXCEPTION_DEAGGR;
+	case 0x04:	return IPA_STATUS_EXCEPTION_IPTYPE;
+	case 0x08:	return IPA_STATUS_EXCEPTION_PACKET_LENGTH;
+	case 0x10:	return IPA_STATUS_EXCEPTION_FRAG_RULE_MISS;
+	case 0x20:	return IPA_STATUS_EXCEPTION_SW_FILT;
+	case 0x40:	return is_ipv6 ? IPA_STATUS_EXCEPTION_IPV6CT
+				       : IPA_STATUS_EXCEPTION_NAT;
+	default:	return IPA_STATUS_EXCEPTION_MAX;
+	}
+}
+
+/* A rule miss is indicated as an all-1's value in the rt_rule_id
+ * or flt_rule_id field of the ipa_status structure.
+ */
+static bool ipa_rule_miss_id(u32 id)
+{
+	return id == field_max(IPA_STATUS_FLAGS1_RT_RULE_ID_FMASK);
+}
+
+size_t ipa_status_parse(struct ipa_status *status, void *data, u32 count)
+{
+	const struct ipa_status_raw *status_raw = data;
+	bool is_ipv6;
+	u32 val;
+
+	BUILD_BUG_ON(sizeof(*status_raw) % 4);
+	if (WARN_ON(count < sizeof(*status_raw)))
+		return 0;
+
+	status->opcode = status_raw->opcode;
+	is_ipv6 = status_raw->mask & BIT(7) ? false : true;
+	status->exception = exception_map(status_raw->exception, is_ipv6);
+	status->pkt_len = status_raw->pkt_len;
+	val = u32_get_bits(status_raw->endp_dst_idx, IPA_STATUS_DST_IDX_FMASK);
+	status->dst_endpoint = val;
+	status->metadata = status_raw->metadata;
+	val = u32_get_bits(status_raw->flags1,
+			   IPA_STATUS_FLAGS1_RT_RULE_ID_FMASK);
+	status->rt_miss = ipa_rule_miss_id(val) ? 1 : 0;
+
+	return sizeof(*status_raw);
+}
+
+/* The format of a packet status element is the same for several status
+ * types (opcodes).  The NEW_FRAG_RULE, LOG, DCMP (decompression) types
+ * aren't currently supported
+ */
+static bool ipa_status_format_packet(enum ipa_status_opcode opcode)
+{
+	switch (opcode) {
+	case IPA_STATUS_OPCODE_PACKET:
+	case IPA_STATUS_OPCODE_DROPPED_PACKET:
+	case IPA_STATUS_OPCODE_SUSPENDED_PACKET:
+	case IPA_STATUS_OPCODE_PACKET_2ND_PASS:
+		return true;
+	default:
+		return false;
+	}
+}
+
+static bool ipa_endpoint_status_skip(struct ipa_endpoint *endpoint,
+				     struct ipa_status *status)
+{
+	if (!ipa_status_format_packet(status->opcode))
+		return true;
+	if (!status->pkt_len)
+		return true;
+	if (status->dst_endpoint != endpoint->endpoint_id)
+		return true;
+
+	return false;	/* Don't skip this packet, process it */
+}
+
+static void ipa_endpoint_status_parse(struct ipa_endpoint *endpoint,
+				      struct page *page, u32 total_len)
+{
+	void *data = page_address(page) + NET_SKB_PAD;
+	u32 unused = IPA_RX_BUFFER_SIZE - total_len;
+	u32 resid = total_len;
+
+	while (resid) {
+		struct ipa_status status;
+		bool drop_packet = false;
+		size_t status_size;
+		u32 align;
+		u32 len;
+
+		status_size = ipa_status_parse(&status, data, resid);
+
+		/* Skip over status packets that lack packet data */
+		if (ipa_endpoint_status_skip(endpoint, &status)) {
+			data += status_size;
+			resid -= status_size;
+			continue;
+		}
+
+		/* Packet data follows the status structure.  Unless
+		 * the packet failed to match a routing rule, or it
+		 * had a deaggregation exception, we'll consume it.
+		 */
+		if (status.exception == IPA_STATUS_EXCEPTION_NONE) {
+			if (status.rt_miss)
+				drop_packet = true;
+		} else if (status.exception == IPA_STATUS_EXCEPTION_DEAGGR) {
+			drop_packet = true;
+		}
+
+		/* Compute the amount of buffer space consumed by the
+		 * packet, including the status element.  If the hardware
+		 * is configured to pad packet data to an aligned boundary,
+		 * account for that.  And if checksum offload is is enabled
+		 * a trailer containing computed checksum information will
+		 * be appended.
+		 */
+		align = endpoint->data->config.rx.pad_align ? : 1;
+		len = status_size + ALIGN(status.pkt_len, align);
+		if (endpoint->data->config.checksum)
+			len += sizeof(struct rmnet_map_dl_csum_trailer);
+
+		/* Charge the new packet with a proportional fraction of
+		 * the unused space in the original receive buffer.
+		 * XXX Charge a proportion of the *whole* receive buffer?
+		 */
+		if (!drop_packet) {
+			u32 extra = unused * len / total_len;
+			void *data2 = data + status_size;
+			u32 len2 = status.pkt_len;
+
+			/* Client receives only packet data (no status) */
+			ipa_endpoint_skb_copy(endpoint, data2, len2, extra);
+		}
+
+		/* Consume status and the full packet it describes */
+		data += len;
+		resid -= len;
+	}
+
+	__free_pages(page, IPA_RX_BUFFER_ORDER);
+}
+
+/* Complete transaction initiated in ipa_endpoint_replenish_one() */
+void ipa_endpoint_rx_complete(struct gsi_trans *trans)
+{
+	struct page *page = trans->data;
+	struct ipa_endpoint *endpoint;
+	struct ipa *ipa;
+
+	ipa = container_of(trans->gsi, struct ipa, gsi);
+	endpoint = ipa->endpoint_map[trans->channel_id];
+
+	ipa_endpoint_replenish(endpoint, true);
+
+	if (trans->result == -ECANCELED) {
+		__free_pages(page, IPA_RX_BUFFER_ORDER);
+		return;
+	}
+
+	/* Parse or build a socket buffer using the actual received length */
+	if (endpoint->data->config.status_enable)
+		ipa_endpoint_status_parse(endpoint, page, trans->len);
+	else
+		ipa_endpoint_skb_build(endpoint, page, trans->len);
+}
+
+static int ipa_endpoint_replenish_one(struct ipa_endpoint *endpoint)
+{
+	struct gsi_trans *trans;
+	bool doorbell = false;
+	struct page *page;
+	u32 offset;
+	u32 len;
+
+	page = dev_alloc_pages(IPA_RX_BUFFER_ORDER);
+	if (!page)
+		return -ENOMEM;
+	offset = NET_SKB_PAD;
+	len = IPA_RX_BUFFER_SIZE - offset;
+
+	trans = gsi_channel_trans_alloc(&endpoint->ipa->gsi,
+					endpoint->channel_id, 1);
+	if (!trans)
+		goto err_page_free;
+	trans->data = page;
+
+	/* Set up and map a scatterlist entry representing the buffer */
+	sg_init_table(trans->sgl, trans->sgc);
+	sg_set_page(trans->sgl, page, len, offset);
+
+	if (++endpoint->replenish_ready == IPA_REPLENISH_BATCH) {
+		doorbell = true;
+		endpoint->replenish_ready = 0;
+	}
+
+	if (!gsi_trans_commit(trans, doorbell))
+		return 0;
+
+err_page_free:
+	__free_pages(page, IPA_RX_BUFFER_ORDER);
+
+	return -ENOMEM;
+}
+
+/**
+ * ipa_endpoint_replenish() - Replenish the Rx packets cache.
+ *
+ * Allocate RX packet wrapper structures with maximal socket buffers
+ * for an endpoint.  These are supplied to the hardware, which fills
+ * them with incoming data.
+ */
+static void ipa_endpoint_replenish(struct ipa_endpoint *endpoint, bool add_one)
+{
+	struct gsi *gsi;
+	u32 backlog;
+
+	if (add_one) {
+		if (endpoint->replenish_enabled)
+			atomic_inc(&endpoint->replenish_backlog);
+		else
+			atomic_inc(&endpoint->replenish_saved);
+	}
+
+	if (!endpoint->replenish_enabled)
+		return;
+
+	while (atomic_dec_not_zero(&endpoint->replenish_backlog))
+		if (ipa_endpoint_replenish_one(endpoint))
+			goto try_again_later;
+
+	return;
+
+try_again_later:
+	/* The last one didn't succeed, so fix the backlog */
+	backlog = atomic_inc_return(&endpoint->replenish_backlog);
+
+	/* Whenever a receive buffer transaction completes we'll try to
+	 * replenish again.  It's unlikely, but if we fail to supply even
+	 * one buffer, nothing will trigger another replenish attempt.
+	 * If this happens, schedule work to try again.
+	 */
+	gsi = &endpoint->ipa->gsi;
+	if (backlog == gsi_channel_trans_max(gsi, endpoint->channel_id))
+		schedule_delayed_work(&endpoint->replenish_work,
+				      msecs_to_jiffies(1));
+}
+
+static void ipa_endpoint_replenish_enable(struct ipa_endpoint *endpoint)
+{
+	struct gsi *gsi = &endpoint->ipa->gsi;
+	u32 max_backlog;
+	u32 saved;
+
+	endpoint->replenish_enabled = true;
+	while ((saved = atomic_xchg(&endpoint->replenish_saved, 0)))
+		atomic_add(saved, &endpoint->replenish_backlog);
+
+	/* Start replenishing if hardware currently has no buffers */
+	max_backlog = gsi_channel_trans_max(gsi, endpoint->channel_id);
+	if (atomic_read(&endpoint->replenish_backlog) == max_backlog) {
+		ipa_endpoint_replenish(endpoint, false);
+		return;
+	}
+}
+
+static void ipa_endpoint_replenish_disable(struct ipa_endpoint *endpoint)
+{
+	endpoint->replenish_enabled = false;
+}
+
+static void ipa_endpoint_replenish_work(struct work_struct *work)
+{
+	struct delayed_work *dwork = to_delayed_work(work);
+	struct ipa_endpoint *endpoint;
+
+	endpoint = container_of(dwork, struct ipa_endpoint, replenish_work);
+
+	ipa_endpoint_replenish(endpoint, false);
+}
+
+static bool ipa_endpoint_set_up(struct ipa_endpoint *endpoint)
+{
+	struct ipa *ipa = endpoint->ipa;
+
+	return ipa && (ipa->set_up & BIT(endpoint->endpoint_id));
+}
+
+static void ipa_endpoint_default_route_set(struct ipa *ipa,
+					   enum ipa_endpoint_id endpoint_id)
+{
+	u32 val;
+
+	/* ROUTE_DIS is 0 */
+	val = u32_encode_bits(endpoint_id, ROUTE_DEF_PIPE_FMASK);
+	val |= ROUTE_DEF_HDR_TABLE_FMASK;
+	val |= u32_encode_bits(0, ROUTE_DEF_HDR_OFST_FMASK);
+	val |= u32_encode_bits(endpoint_id, ROUTE_FRAG_DEF_PIPE_FMASK);
+	val |= ROUTE_DEF_RETAIN_HDR_FMASK;
+
+	iowrite32(val, ipa->reg_virt + IPA_REG_ROUTE_OFFSET);
+}
+/**
+ * ipa_endpoint_default_route_init() - Configure IPA default route
+ * @ipa:	IPA pointer
+ * @client:	Client to which exceptions should be directed
+ */
+void ipa_endpoint_default_route_setup(struct ipa_endpoint *endpoint)
+{
+	ipa_endpoint_default_route_set(endpoint->ipa, endpoint->endpoint_id);
+}
+
+/**
+ * ipa_endpoint_default_route_teardown() -
+ *			Inverse of ipa_endpoint_default_route_setup()
+ * @ipa:	IPA pointer
+ */
+void ipa_endpoint_default_route_teardown(struct ipa_endpoint *endpoint)
+{
+	ipa_endpoint_default_route_set(endpoint->ipa, 0);
+}
+
+/**
+ * ipa_endpoint_stop()- Stops a GSI channel in IPA
+ * @client:	Client whose endpoint should be stopped
+ *
+ * This function implements the sequence to stop a GSI channel
+ * in IPA. This function returns when the channel is is STOP state.
+ *
+ * Return value: 0 on success, negative otherwise
+ */
+int ipa_endpoint_stop(struct ipa_endpoint *endpoint)
+{
+	struct device *dev = &endpoint->ipa->pdev->dev;
+	size_t size = IPA_ENDPOINT_STOP_RX_SIZE;
+	struct gsi *gsi = &endpoint->ipa->gsi;
+	void *virt = NULL;
+	dma_addr_t addr;
+	int ret;
+	int i;
+
+	/* An RX endpoint might not stop right away.  In that case we issue
+	 * a small (1-byte) DMA command, delay for a bit (1-2 milliseconds),
+	 * and try again.  Allocate the DMA buffer in case this is needed.
+	 */
+	if (!endpoint->toward_ipa) {
+		virt = dma_alloc_coherent(dev, size, &addr, GFP_KERNEL);
+		if (!virt)
+			return -ENOMEM;
+	}
+
+	for (i = 0; i < IPA_ENDPOINT_STOP_RETRY_MAX; i++) {
+		ret = gsi_channel_stop(gsi, endpoint->channel_id);
+		if (ret != -EAGAIN)
+			break;
+
+		if (endpoint->toward_ipa)
+			continue;
+
+		/* Send a 1 byte 32-bit DMA task and try again after a delay */
+		ret = ipa_cmd_dma_task_32(endpoint->ipa, size, addr);
+		if (ret)
+			break;
+
+		usleep_range(USEC_PER_MSEC, 2 * USEC_PER_MSEC);
+	}
+	if (i >= IPA_ENDPOINT_STOP_RETRY_MAX)
+		ret = -EIO;
+
+	if (!endpoint->toward_ipa)
+		dma_free_coherent(dev, size, virt, addr);
+
+	return ret;
+}
+
+bool ipa_endpoint_enabled(struct ipa_endpoint *endpoint)
+{
+	return !!(endpoint->ipa->enabled & BIT(endpoint->endpoint_id));
+}
+
+int ipa_endpoint_enable_one(struct ipa_endpoint *endpoint)
+{
+	struct ipa *ipa = endpoint->ipa;
+	int ret;
+
+	if (WARN_ON(!ipa_endpoint_set_up(endpoint)))
+		return -EINVAL;
+
+	ret = gsi_channel_start(&ipa->gsi, endpoint->channel_id);
+	if (ret)
+		return ret;
+
+	ipa_interrupt_suspend_enable(ipa->interrupt, endpoint->endpoint_id);
+
+	if (!endpoint->toward_ipa)
+		ipa_endpoint_replenish_enable(endpoint);
+
+	ipa->enabled |= BIT(endpoint->endpoint_id);
+
+	return 0;
+}
+
+void ipa_endpoint_disable_one(struct ipa_endpoint *endpoint)
+{
+	struct ipa *ipa = endpoint->ipa;
+	int ret;
+
+	if (WARN_ON(!ipa_endpoint_enabled(endpoint)))
+		return;
+
+	if (!endpoint->toward_ipa)
+		ipa_endpoint_replenish_disable(endpoint);
+
+	ipa_interrupt_suspend_disable(ipa->interrupt, endpoint->endpoint_id);
+
+	ret = ipa_endpoint_stop(endpoint);
+	WARN(ret, "error %d attempting to stop endpoint %u\n", ret,
+	     endpoint->endpoint_id);
+
+	if (!ret)
+		endpoint->ipa->enabled &= ~BIT(endpoint->endpoint_id);
+}
+
+static bool ipa_endpoint_aggr_active(struct ipa_endpoint *endpoint)
+{
+	u32 mask = BIT(endpoint->endpoint_id);
+	struct ipa *ipa = endpoint->ipa;
+	u32 val;
+
+	val = ioread32(ipa->reg_virt + IPA_REG_STATE_AGGR_ACTIVE_OFFSET);
+
+	return !!(val & mask);
+}
+
+static void ipa_endpoint_force_close(struct ipa_endpoint *endpoint)
+{
+	u32 mask = BIT(endpoint->endpoint_id);
+	struct ipa *ipa = endpoint->ipa;
+	u32 val;
+
+	val = u32_encode_bits(mask, PIPE_BITMAP_FMASK);
+	iowrite32(val, ipa->reg_virt + IPA_REG_AGGR_FORCE_CLOSE_OFFSET);
+}
+
+/**
+ * ipa_endpoint_reset_rx_aggr() - Reset RX endpoint with aggregation active
+ * @endpoint:	Endpoint to be reset
+ *
+ * If aggregation is active on an RX endpoint when a reset is performed
+ * on its underlying GSI channel, a special sequence of actions must be
+ * taken to ensure the IPA pipeline is properly cleared.
+ *
+ * @Return:	0 if successful, or a negative error code
+ */
+static int ipa_endpoint_reset_rx_aggr(struct ipa_endpoint *endpoint)
+{
+	struct device *dev = &endpoint->ipa->pdev->dev;
+	struct ipa *ipa = endpoint->ipa;
+	bool endpoint_suspended = false;
+	struct gsi *gsi = &ipa->gsi;
+	dma_addr_t addr;
+	u32 len = 1;
+	void *virt;
+	int ret;
+	int i;
+
+	virt = kzalloc(len, GFP_KERNEL);
+	if (!virt)
+		return -ENOMEM;
+
+	addr = dma_map_single(dev, virt, len, DMA_FROM_DEVICE);
+	if (dma_mapping_error(dev, addr)) {
+		ret = -ENOMEM;
+		goto out_free_virt;
+	}
+
+	/* Force close aggregation before issuing the reset */
+	ipa_endpoint_force_close(endpoint);
+
+	/* Reset and reconfigure the channel with the doorbell engine
+	 * disabled.  Then poll until we know aggregation is no longer
+	 * active.  We'll re-enable the doorbell when we reset below.
+	 */
+	ret = gsi_channel_reset(gsi, endpoint->channel_id, false);
+	if (ret)
+		goto out_unmap_addr;
+
+	if (ipa_endpoint_init_ctrl(endpoint, false))
+		endpoint_suspended = true;
+
+	/* Start channel and do a 1 byte read */
+	ret = gsi_channel_start(gsi, endpoint->channel_id);
+	if (ret)
+		goto out_suspend_again;
+
+	ret = gsi_trans_read_byte(gsi, endpoint->channel_id, addr);
+	if (ret)
+		goto err_stop_channel;
+
+	/* Wait for aggregation to be closed on the channel */
+	for (i = 0; i < IPA_ENDPOINT_RESET_AGGR_RETRY_MAX; i++) {
+		if (!ipa_endpoint_aggr_active(endpoint))
+			break;
+		usleep_range(USEC_PER_MSEC, 2 * USEC_PER_MSEC);
+	}
+	WARN_ON(ipa_endpoint_aggr_active(endpoint));
+	gsi_trans_read_byte_done(gsi, endpoint->channel_id);
+
+	ret = ipa_endpoint_stop(endpoint);
+	if (ret)
+		goto out_suspend_again;
+
+	/* Finally, reset and reconfigure the channel again (this time with
+	 * the doorbell engine enabled).  Sleep for 1 millisecond to complete
+	 * the channel reset sequence.  Finish by suspending the channel
+	 * again (if necessary).
+	 */
+	ret = gsi_channel_reset(gsi, endpoint->channel_id, true);
+
+	usleep_range(USEC_PER_MSEC, 2 * USEC_PER_MSEC);
+
+	goto out_suspend_again;
+
+err_stop_channel:
+	ipa_endpoint_stop(endpoint);
+out_suspend_again:
+	if (endpoint_suspended)
+		(void)ipa_endpoint_init_ctrl(endpoint, true);
+out_unmap_addr:
+	dma_unmap_single(dev, addr, len, DMA_FROM_DEVICE);
+out_free_virt:
+	kfree(virt);
+
+	return ret;
+}
+
+static void ipa_endpoint_reset(struct ipa_endpoint *endpoint)
+{
+	u32 channel_id = endpoint->channel_id;
+	struct ipa *ipa = endpoint->ipa;
+	struct gsi *gsi = &ipa->gsi;
+	int ret;
+
+	/* For TX endpoints, or RX endpoints without aggregation active,
+	 * we only need to reset the underlying GSI channel.
+	 */
+	if (!endpoint->toward_ipa && endpoint->data->config.aggregation) {
+		if (ipa_endpoint_aggr_active(endpoint))
+			ret = ipa_endpoint_reset_rx_aggr(endpoint);
+		else
+			ret = gsi_channel_reset(gsi, channel_id, true);
+	} else {
+		ret = gsi_channel_reset(gsi, channel_id, true);
+	}
+	WARN(ret, "error %d attempting to reset channel %u\n", ret,
+	     endpoint->channel_id);
+}
+
+static bool ipa_endpoint_suspended(struct ipa_endpoint *endpoint)
+{
+	return !!(endpoint->ipa->suspended & BIT(endpoint->endpoint_id));
+}
+
+/**
+ * ipa_endpoint_suspend_aggr() - Emulate suspend interrupt
+ * @endpoint_id:	Endpoint on which to emulate a suspend
+ *
+ *  Emulate suspend IPA interrupt to unsuspend an endpoint suspended
+ *  with an open aggregation frame.  This is to work around a hardware
+ *  issue where the suspend interrupt will not be generated when it
+ *  should be.
+ */
+static void ipa_endpoint_suspend_aggr(struct ipa_endpoint *endpoint)
+{
+	struct ipa *ipa = endpoint->ipa;
+
+	/* Nothing to do if the endpoint doesn't have aggregation open */
+	if (!ipa_endpoint_aggr_active(endpoint))
+		return;
+
+	/* Force close aggregation */
+	ipa_endpoint_force_close(endpoint);
+
+	ipa_interrupt_simulate_suspend(ipa->interrupt);
+}
+
+void ipa_endpoint_suspend(struct ipa_endpoint *endpoint)
+{
+	struct gsi *gsi = &endpoint->ipa->gsi;
+
+	if (!ipa_endpoint_enabled(endpoint))
+		return;
+
+	if (!endpoint->toward_ipa) {
+		if (!ipa_endpoint_init_ctrl(endpoint, true))
+			return;
+
+		ipa_endpoint_replenish_disable(endpoint);
+
+		/* Due to a hardware bug, a client suspended with an open
+		 * aggregation frame will not generate a SUSPEND IPA interrupt.
+		 * We work around this by force-closing the aggregation frame,
+		 * then simulating the arrival of such an interrupt.
+		*/
+		if (endpoint->data->config.aggregation)
+			ipa_endpoint_suspend_aggr(endpoint);
+	}
+
+	gsi_channel_trans_quiesce(gsi, endpoint->channel_id);
+
+	endpoint->ipa->suspended |= BIT(endpoint->endpoint_id);
+}
+
+void ipa_endpoint_resume(struct ipa_endpoint *endpoint)
+{
+	if (!ipa_endpoint_suspended(endpoint))
+		return;
+
+	if (endpoint->toward_ipa)
+		ipa_endpoint_replenish_enable(endpoint);
+	else
+		WARN_ON(ipa_endpoint_init_ctrl(endpoint, false));
+
+	endpoint->ipa->suspended &= ~BIT(endpoint->endpoint_id);
+}
+
+static void ipa_endpoint_program(struct ipa_endpoint *endpoint)
+{
+	if (endpoint->toward_ipa) {
+		bool delay_mode = !!endpoint->data->config.tx.delay;
+
+		(void)ipa_endpoint_init_ctrl(endpoint, delay_mode);
+		ipa_endpoint_init_hdr_ext(endpoint);
+		ipa_endpoint_init_aggr(endpoint);
+		ipa_endpoint_init_deaggr(endpoint);
+		ipa_endpoint_init_seq(endpoint);
+	} else {
+		(void)ipa_endpoint_init_ctrl(endpoint, false);
+		ipa_endpoint_init_hdr_ext(endpoint);
+		ipa_endpoint_init_aggr(endpoint);
+	}
+	ipa_endpoint_init_cfg(endpoint);
+	ipa_endpoint_init_hdr(endpoint);
+	ipa_endpoint_init_hdr_metadata_mask(endpoint);
+	ipa_endpoint_init_mode(endpoint);
+	ipa_endpoint_status(endpoint);
+}
+
+static void ipa_endpoint_setup_one(struct ipa_endpoint *endpoint)
+{
+	struct gsi *gsi = &endpoint->ipa->gsi;
+	u32 channel_id = endpoint->channel_id;
+
+	/* Only AP endpoints get configured */
+	if (endpoint->ee_id != GSI_EE_AP)
+		return;
+
+	endpoint->trans_tre_max = gsi_channel_trans_tre_max(gsi, channel_id);
+	if (!endpoint->toward_ipa) {
+		endpoint->replenish_enabled = false;
+		atomic_set(&endpoint->replenish_saved,
+			   gsi_channel_trans_max(gsi, endpoint->channel_id));
+		atomic_set(&endpoint->replenish_backlog, 0);
+		INIT_DELAYED_WORK(&endpoint->replenish_work,
+				  ipa_endpoint_replenish_work);
+	}
+
+	ipa_endpoint_program(endpoint);
+
+	endpoint->ipa->set_up |= BIT(endpoint->endpoint_id);
+}
+
+static void ipa_endpoint_teardown_one(struct ipa_endpoint *endpoint)
+{
+	if (!endpoint->toward_ipa)
+		cancel_delayed_work_sync(&endpoint->replenish_work);
+
+	ipa_endpoint_reset(endpoint);
+
+	endpoint->ipa->set_up &= ~BIT(endpoint->endpoint_id);
+}
+
+void ipa_endpoint_setup(struct ipa *ipa)
+{
+	u32 initialized = ipa->initialized;
+
+	ipa->set_up = 0;
+	while (initialized) {
+		enum ipa_endpoint_id endpoint_id = __ffs(initialized);
+
+		initialized ^= BIT(endpoint_id);
+
+		ipa_endpoint_setup_one(&ipa->endpoint[endpoint_id]);
+	}
+}
+
+void ipa_endpoint_teardown(struct ipa *ipa)
+{
+	u32 set_up = ipa->set_up;
+
+	while (set_up) {
+		enum ipa_endpoint_id endpoint_id = __fls(set_up);
+
+		set_up ^= BIT(endpoint_id);
+
+		ipa_endpoint_teardown_one(&ipa->endpoint[endpoint_id]);
+	}
+}
+
+static int ipa_endpoint_init_one(struct ipa *ipa,
+				 const struct gsi_ipa_endpoint_data *data)
+{
+	struct ipa_endpoint *endpoint;
+
+	if (data->endpoint_id >= IPA_ENDPOINT_MAX)
+		return -EIO;
+	endpoint = &ipa->endpoint[data->endpoint_id];
+
+	if (data->ee_id == GSI_EE_AP)
+		ipa->endpoint_map[data->channel_id] = endpoint;
+
+	endpoint->ipa = ipa;
+	endpoint->ee_id = data->ee_id;
+	endpoint->channel_id = data->channel_id;
+	endpoint->endpoint_id = data->endpoint_id;
+	endpoint->toward_ipa = data->toward_ipa;
+	endpoint->data = &data->endpoint;
+
+	if (endpoint->data->support_flt)
+		ipa->filter_support |= BIT(endpoint->endpoint_id);
+
+	ipa->initialized |= BIT(endpoint->endpoint_id);
+
+	return 0;
+}
+
+void ipa_endpoint_exit_one(struct ipa_endpoint *endpoint)
+{
+	endpoint->ipa->initialized &= ~BIT(endpoint->endpoint_id);
+}
+
+int ipa_endpoint_init(struct ipa *ipa, u32 data_count,
+		      const struct gsi_ipa_endpoint_data *data)
+{
+	u32 initialized;
+	int ret;
+	u32 i;
+
+	ipa->initialized = 0;
+
+	ipa->filter_support = 0;
+	for (i = 0; i < data_count; i++) {
+		ret = ipa_endpoint_init_one(ipa, &data[i]);
+		if (ret)
+			goto err_endpoint_unwind;
+	}
+	dev_dbg(&ipa->pdev->dev, "initialized 0x%08x\n", ipa->initialized);
+
+	/* Verify the bitmap of endpoints that support filtering. */
+	dev_dbg(&ipa->pdev->dev, "filter_support 0x%08x\n",
+		ipa->filter_support);
+	if (!ipa->filter_support)
+		goto err_endpoint_unwind;
+	if (hweight32(ipa->filter_support) > IPA_SMEM_FLT_COUNT)
+		goto err_endpoint_unwind;
+
+	return 0;
+
+err_endpoint_unwind:
+	initialized = ipa->initialized;
+	while (initialized) {
+		enum ipa_endpoint_id endpoint_id = __fls(initialized);
+
+		initialized ^= BIT(endpoint_id);
+
+		ipa_endpoint_exit_one(&ipa->endpoint[endpoint_id]);
+	}
+
+	return ret;
+}
+
+void ipa_endpoint_exit(struct ipa *ipa)
+{
+	u32 initialized = ipa->initialized;
+
+	while (initialized) {
+		enum ipa_endpoint_id endpoint_id = __fls(initialized);
+
+		initialized ^= BIT(endpoint_id);
+
+		ipa_endpoint_exit_one(&ipa->endpoint[endpoint_id]);
+	}
+}
diff --git a/drivers/net/ipa/ipa_endpoint.h b/drivers/net/ipa/ipa_endpoint.h
new file mode 100644
index 000000000000..c9f7ccc59a5a
--- /dev/null
+++ b/drivers/net/ipa/ipa_endpoint.h
@@ -0,0 +1,97 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
+ * Copyright (C) 2019 Linaro Ltd.
+ */
+#ifndef _IPA_ENDPOINT_H_
+#define _IPA_ENDPOINT_H_
+
+#include <linux/types.h>
+#include <linux/workqueue.h>
+#include <linux/if_ether.h>
+
+#include "gsi.h"
+#include "ipa_reg.h"
+
+struct net_device;
+struct sk_buff;
+
+struct ipa;
+struct gsi_ipa_endpoint_data;
+
+#define IPA_MTU	ETH_DATA_LEN
+
+enum ipa_endpoint_id {
+	IPA_ENDPOINT_INVALID		= 0,
+	IPA_ENDPOINT_AP_MODEM_TX	= 2,
+	IPA_ENDPOINT_MODEM_LAN_TX	= 3,
+	IPA_ENDPOINT_MODEM_COMMAND_TX	= 4,
+	IPA_ENDPOINT_AP_COMMAND_TX	= 5,
+	IPA_ENDPOINT_MODEM_AP_TX	= 6,
+	IPA_ENDPOINT_AP_LAN_RX		= 9,
+	IPA_ENDPOINT_AP_MODEM_RX	= 10,
+	IPA_ENDPOINT_MODEM_AP_RX	= 12,
+	IPA_ENDPOINT_MODEM_LAN_RX	= 13,
+};
+
+#define IPA_ENDPOINT_MAX		32	/* Max supported */
+
+/**
+ * struct ipa_endpoint - IPA endpoint information
+ * @client:	Client associated with the endpoint
+ * @channel_id:	EP's GSI channel
+ * @evt_ring_id: EP's GSI channel event ring
+ */
+struct ipa_endpoint {
+	struct ipa *ipa;
+	enum ipa_seq_type seq_type;
+	enum gsi_ee_id ee_id;
+	u32 channel_id;
+	enum ipa_endpoint_id endpoint_id;
+	u32 toward_ipa;		/* Boolean */
+	const struct ipa_endpoint_data *data;
+
+	u32 trans_tre_max;	/* maximum descriptors per transaction */
+	u32 evt_ring_id;
+
+	/* Net device this endpoint is associated with, if any */
+	struct net_device *netdev;
+
+	/* Receive buffer replenishing for RX endpoints */
+	u32 replenish_enabled;	/* Boolean */
+	u32 replenish_ready;
+	atomic_t replenish_saved;
+	atomic_t replenish_backlog;
+	struct delayed_work replenish_work;		/* global wq */
+};
+
+bool ipa_endpoint_init_ctrl(struct ipa_endpoint *endpoint, bool suspend_delay);
+
+int ipa_endpoint_skb_tx(struct ipa_endpoint *endpoint, struct sk_buff *skb);
+
+int ipa_endpoint_stop(struct ipa_endpoint *endpoint);
+
+void ipa_endpoint_exit_one(struct ipa_endpoint *endpoint);
+
+bool ipa_endpoint_enabled(struct ipa_endpoint *endpoint);
+int ipa_endpoint_enable_one(struct ipa_endpoint *endpoint);
+void ipa_endpoint_disable_one(struct ipa_endpoint *endpoint);
+
+void ipa_endpoint_default_route_setup(struct ipa_endpoint *endpoint);
+void ipa_endpoint_default_route_teardown(struct ipa_endpoint *endpoint);
+
+void ipa_endpoint_suspend(struct ipa_endpoint *endpoint);
+void ipa_endpoint_resume(struct ipa_endpoint *endpoint);
+
+void ipa_endpoint_setup(struct ipa *ipa);
+void ipa_endpoint_teardown(struct ipa *ipa);
+
+int ipa_endpoint_init(struct ipa *ipa, u32 data_count,
+		      const struct gsi_ipa_endpoint_data *data);
+void ipa_endpoint_exit(struct ipa *ipa);
+
+void ipa_endpoint_skb_tx_complete(struct gsi_trans *trans);
+void ipa_endpoint_rx_complete(struct gsi_trans *trans);
+
+
+#endif /* _IPA_ENDPOINT_H_ */
-- 
2.20.1

