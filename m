Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 202DF17424B
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 23:43:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727201AbgB1WnV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 17:43:21 -0500
Received: from mail-yw1-f65.google.com ([209.85.161.65]:39822 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727177AbgB1Wmh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 17:42:37 -0500
Received: by mail-yw1-f65.google.com with SMTP id x184so4942322ywd.6
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 14:42:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xQPHP7soRrVFXmFvhGpBfXcKcLLCCcQxwvCnU1L5Jk4=;
        b=O1c0BIMsHQ+tMXjvNszfTcqe/u1zb8o2ZmZzyjMJU/JO1xrcwSaRhhUiPmrxp2GXnx
         t/2zr8nBqxe1p7zvNb6p3xaDHSyza2Z6Ki0NwyyAuW6bd9jQv46eBAH8Y24mHP/aps1F
         Ke47KoVnAIgb4d0JS6TCo5bO9d/J+cQRO00RVNRW9wikV/O7rHLQx8fQFpRQaWVzyMEn
         Lh8O6wIc0yBHuUqojncsmhxBxB5nDPtPLTr9jhSYget8I3GITzHRL1Se5XYkHzWNMfYx
         UjLzVE3GzULubmk0hdFfCIg6hqHYH2d0l6NilwIVL4u6jDlYviAE/qjUTNhOzDCxHWzA
         dczQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xQPHP7soRrVFXmFvhGpBfXcKcLLCCcQxwvCnU1L5Jk4=;
        b=OaPdxRlC7fe2cqFenjevxjT2nzMO/RZQdWp0/28LtZUz8Yr9E0Vmd+YCYeY6iD7X81
         vqdtMZotP5aV1/v9RxyWLUUNebF2Uj5L7P4HjbH3crOuq5XT6TcTSNCff30rMgTyIYnW
         anIwtoUVStjkIA8bbwDErIKM3fIjvwTiQ+F697znZkvqJvb9XkAxfnFlM5q8GbCkEYwO
         cXQFhj5Ge5XQKvGHDmc06HHHb6GlxR6sHRYfUtxGeKUq/ROKw2dMLAqK8UV524bwYg7o
         LimzC2/7jvTz5hdYR0DvRBcTzA2y3clrhhd+S2JkXSUMb5AU2UlV1arBNDomyHZAqmuU
         OOnQ==
X-Gm-Message-State: APjAAAV57eO9fq4Qd70K8Kc6KsmrylTxNS5K97MATPfb2sc2Rw0EHLKm
        W5XtCq5CuDJ1Sdzsp5keUxpwqg==
X-Google-Smtp-Source: APXvYqzpsoO247v8zO1irTwx28HbZqkNiDCg/69RdpAPmNyYfCtVUuUuQzX8BmHay/N5ttOerOO5kQ==
X-Received: by 2002:a0d:c981:: with SMTP id l123mr6281826ywd.284.1582929755456;
        Fri, 28 Feb 2020 14:42:35 -0800 (PST)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id d188sm4637830ywe.50.2020.02.28.14.42.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2020 14:42:34 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     Arnd Bergmann <arnd@arndb.de>, David Miller <davem@davemloft.net>
Cc:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Dan Williams <dcbw@redhat.com>,
        Evan Green <evgreen@google.com>,
        Eric Caruso <ejcaruso@google.com>,
        Susheel Yadav Yadagiri <syadagir@codeaurora.org>,
        Chaitanya Pratapa <cpratapa@codeaurora.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Siddharth Gupta <sidgup@codeaurora.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 12/17] soc: qcom: ipa: immediate commands
Date:   Fri, 28 Feb 2020 16:41:59 -0600
Message-Id: <20200228224204.17746-13-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200228224204.17746-1-elder@linaro.org>
References: <20200228224204.17746-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

One TX endpoint (per EE) is used for issuing immediate commands to
the IPA.  These commands request activites beyond simple data
transfers to be done by the IPA hardware.  For example, the IPA is
able to manage routing packets among endpoints, and immediate commands
are used to configure tables used for that routing.

Immediate commands are built on top of GSI transactions.  They are
different from normal transfers (in that they use a special endpoint,
and their "payload" is interpreted differently), so separate functions
are used to issue immediate command transactions.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_cmd.c | 680 ++++++++++++++++++++++++++++++++++++++
 drivers/net/ipa/ipa_cmd.h | 195 +++++++++++
 2 files changed, 875 insertions(+)
 create mode 100644 drivers/net/ipa/ipa_cmd.c
 create mode 100644 drivers/net/ipa/ipa_cmd.h

diff --git a/drivers/net/ipa/ipa_cmd.c b/drivers/net/ipa/ipa_cmd.c
new file mode 100644
index 000000000000..e14a384f2886
--- /dev/null
+++ b/drivers/net/ipa/ipa_cmd.c
@@ -0,0 +1,680 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
+ * Copyright (C) 2019-2020 Linaro Ltd.
+ */
+
+#include <linux/types.h>
+#include <linux/device.h>
+#include <linux/slab.h>
+#include <linux/bitfield.h>
+#include <linux/dma-direction.h>
+
+#include "gsi.h"
+#include "gsi_trans.h"
+#include "ipa.h"
+#include "ipa_endpoint.h"
+#include "ipa_table.h"
+#include "ipa_cmd.h"
+#include "ipa_mem.h"
+
+/**
+ * DOC:  IPA Immediate Commands
+ *
+ * The AP command TX endpoint is used to issue immediate commands to the IPA.
+ * An immediate command is generally used to request the IPA do something
+ * other than data transfer to another endpoint.
+ *
+ * Immediate commands are represented by GSI transactions just like other
+ * transfer requests, represented by a single GSI TRE.  Each immediate
+ * command has a well-defined format, having a payload of a known length.
+ * This allows the transfer element's length field to be used to hold an
+ * immediate command's opcode.  The payload for a command resides in DRAM
+ * and is described by a single scatterlist entry in its transaction.
+ * Commands do not require a transaction completion callback.  To commit
+ * an immediate command transaction, either gsi_trans_commit_wait() or
+ * gsi_trans_commit_wait_timeout() is used.
+ */
+
+/* Some commands can wait until indicated pipeline stages are clear */
+enum pipeline_clear_options {
+	pipeline_clear_hps	= 0,
+	pipeline_clear_src_grp	= 1,
+	pipeline_clear_full	= 2,
+};
+
+/* IPA_CMD_IP_V{4,6}_{FILTER,ROUTING}_INIT */
+
+struct ipa_cmd_hw_ip_fltrt_init {
+	__le64 hash_rules_addr;
+	__le64 flags;
+	__le64 nhash_rules_addr;
+};
+
+/* Field masks for ipa_cmd_hw_ip_fltrt_init structure fields */
+#define IP_FLTRT_FLAGS_HASH_SIZE_FMASK			GENMASK_ULL(11, 0)
+#define IP_FLTRT_FLAGS_HASH_ADDR_FMASK			GENMASK_ULL(27, 12)
+#define IP_FLTRT_FLAGS_NHASH_SIZE_FMASK			GENMASK_ULL(39, 28)
+#define IP_FLTRT_FLAGS_NHASH_ADDR_FMASK			GENMASK_ULL(55, 40)
+
+/* IPA_CMD_HDR_INIT_LOCAL */
+
+struct ipa_cmd_hw_hdr_init_local {
+	__le64 hdr_table_addr;
+	__le32 flags;
+	__le32 reserved;
+};
+
+/* Field masks for ipa_cmd_hw_hdr_init_local structure fields */
+#define HDR_INIT_LOCAL_FLAGS_TABLE_SIZE_FMASK		GENMASK(11, 0)
+#define HDR_INIT_LOCAL_FLAGS_HDR_ADDR_FMASK		GENMASK(27, 12)
+
+/* IPA_CMD_REGISTER_WRITE */
+
+/* For IPA v4.0+, this opcode gets modified with pipeline clear options */
+
+#define REGISTER_WRITE_OPCODE_SKIP_CLEAR_FMASK		GENMASK(8, 8)
+#define REGISTER_WRITE_OPCODE_CLEAR_OPTION_FMASK	GENMASK(10, 9)
+
+struct ipa_cmd_register_write {
+	__le16 flags;		/* Unused/reserved for IPA v3.5.1 */
+	__le16 offset;
+	__le32 value;
+	__le32 value_mask;
+	__le32 clear_options;	/* Unused/reserved for IPA v4.0+ */
+};
+
+/* Field masks for ipa_cmd_register_write structure fields */
+/* The next field is present for IPA v4.0 and above */
+#define REGISTER_WRITE_FLAGS_OFFSET_HIGH_FMASK		GENMASK(14, 11)
+/* The next field is present for IPA v3.5.1 only */
+#define REGISTER_WRITE_FLAGS_SKIP_CLEAR_FMASK		GENMASK(15, 15)
+
+/* The next field and its values are present for IPA v3.5.1 only */
+#define REGISTER_WRITE_CLEAR_OPTIONS_FMASK		GENMASK(1, 0)
+
+/* IPA_CMD_IP_PACKET_INIT */
+
+struct ipa_cmd_ip_packet_init {
+	u8 dest_endpoint;
+	u8 reserved[7];
+};
+
+/* Field masks for ipa_cmd_ip_packet_init dest_endpoint field */
+#define IPA_PACKET_INIT_DEST_ENDPOINT_FMASK		GENMASK(4, 0)
+
+/* IPA_CMD_DMA_TASK_32B_ADDR */
+
+/* This opcode gets modified with a DMA operation count */
+
+#define DMA_TASK_32B_ADDR_OPCODE_COUNT_FMASK		GENMASK(15, 8)
+
+struct ipa_cmd_hw_dma_task_32b_addr {
+	__le16 flags;
+	__le16 size;
+	__le32 addr;
+	__le16 packet_size;
+	u8 reserved[6];
+};
+
+/* Field masks for ipa_cmd_hw_dma_task_32b_addr flags field */
+#define DMA_TASK_32B_ADDR_FLAGS_SW_RSVD_FMASK		GENMASK(10, 0)
+#define DMA_TASK_32B_ADDR_FLAGS_CMPLT_FMASK		GENMASK(11, 11)
+#define DMA_TASK_32B_ADDR_FLAGS_EOF_FMASK		GENMASK(12, 12)
+#define DMA_TASK_32B_ADDR_FLAGS_FLSH_FMASK		GENMASK(13, 13)
+#define DMA_TASK_32B_ADDR_FLAGS_LOCK_FMASK		GENMASK(14, 14)
+#define DMA_TASK_32B_ADDR_FLAGS_UNLOCK_FMASK		GENMASK(15, 15)
+
+/* IPA_CMD_DMA_SHARED_MEM */
+
+/* For IPA v4.0+, this opcode gets modified with pipeline clear options */
+
+#define DMA_SHARED_MEM_OPCODE_SKIP_CLEAR_FMASK		GENMASK(8, 8)
+#define DMA_SHARED_MEM_OPCODE_CLEAR_OPTION_FMASK	GENMASK(10, 9)
+
+struct ipa_cmd_hw_dma_mem_mem {
+	__le16 clear_after_read; /* 0 or DMA_SHARED_MEM_CLEAR_AFTER_READ */
+	__le16 size;
+	__le16 local_addr;
+	__le16 flags;
+	__le64 system_addr;
+};
+
+/* Flag allowing atomic clear of target region after reading data (v4.0+)*/
+#define DMA_SHARED_MEM_CLEAR_AFTER_READ			GENMASK(15, 15)
+
+/* Field masks for ipa_cmd_hw_dma_mem_mem structure fields */
+#define DMA_SHARED_MEM_FLAGS_DIRECTION_FMASK		GENMASK(0, 0)
+/* The next two fields are present for IPA v3.5.1 only. */
+#define DMA_SHARED_MEM_FLAGS_SKIP_CLEAR_FMASK		GENMASK(1, 1)
+#define DMA_SHARED_MEM_FLAGS_CLEAR_OPTIONS_FMASK	GENMASK(3, 2)
+
+/* IPA_CMD_IP_PACKET_TAG_STATUS */
+
+struct ipa_cmd_ip_packet_tag_status {
+	__le64 tag;
+};
+
+#define IP_PACKET_TAG_STATUS_TAG_FMASK			GENMASK(63, 16)
+
+/* Immediate command payload */
+union ipa_cmd_payload {
+	struct ipa_cmd_hw_ip_fltrt_init table_init;
+	struct ipa_cmd_hw_hdr_init_local hdr_init_local;
+	struct ipa_cmd_register_write register_write;
+	struct ipa_cmd_ip_packet_init ip_packet_init;
+	struct ipa_cmd_hw_dma_task_32b_addr dma_task_32b_addr;
+	struct ipa_cmd_hw_dma_mem_mem dma_shared_mem;
+	struct ipa_cmd_ip_packet_tag_status ip_packet_tag_status;
+};
+
+static void ipa_cmd_validate_build(void)
+{
+	/* The sizes of a filter and route tables need to fit into fields
+	 * in the ipa_cmd_hw_ip_fltrt_init structure.  Although hashed tables
+	 * might not be used, non-hashed and hashed tables have the same
+	 * maximum size.  IPv4 and IPv6 filter tables have the same number
+	 * of entries, as and IPv4 and IPv6 route tables have the same number
+	 * of entries.
+	 */
+#define TABLE_SIZE	(TABLE_COUNT_MAX * IPA_TABLE_ENTRY_SIZE)
+#define TABLE_COUNT_MAX	max_t(u32, IPA_ROUTE_COUNT_MAX, IPA_FILTER_COUNT_MAX)
+	BUILD_BUG_ON(TABLE_SIZE > field_max(IP_FLTRT_FLAGS_HASH_SIZE_FMASK));
+	BUILD_BUG_ON(TABLE_SIZE > field_max(IP_FLTRT_FLAGS_NHASH_SIZE_FMASK));
+#undef TABLE_COUNT_MAX
+#undef TABLE_SIZE
+}
+
+#ifdef IPA_VALIDATE
+
+/* Validate a memory region holding a table */
+bool ipa_cmd_table_valid(struct ipa *ipa, const struct ipa_mem *mem,
+			 bool route, bool ipv6, bool hashed)
+{
+	struct device *dev = &ipa->pdev->dev;
+	u32 offset_max;
+
+	offset_max = hashed ? field_max(IP_FLTRT_FLAGS_HASH_ADDR_FMASK)
+			    : field_max(IP_FLTRT_FLAGS_NHASH_ADDR_FMASK);
+	if (mem->offset > offset_max ||
+	    ipa->mem_offset > offset_max - mem->offset) {
+		dev_err(dev, "IPv%c %s%s table region offset too large "
+			      "(0x%04x + 0x%04x > 0x%04x)\n",
+			      ipv6 ? '6' : '4', hashed ? "hashed " : "",
+			      route ? "route" : "filter",
+			      ipa->mem_offset, mem->offset, offset_max);
+		return false;
+	}
+
+	if (mem->offset > ipa->mem_size ||
+	    mem->size > ipa->mem_size - mem->offset) {
+		dev_err(dev, "IPv%c %s%s table region out of range "
+			      "(0x%04x + 0x%04x > 0x%04x)\n",
+			      ipv6 ? '6' : '4', hashed ? "hashed " : "",
+			      route ? "route" : "filter",
+			      mem->offset, mem->size, ipa->mem_size);
+		return false;
+	}
+
+	return true;
+}
+
+/* Validate the memory region that holds headers */
+static bool ipa_cmd_header_valid(struct ipa *ipa)
+{
+	const struct ipa_mem *mem = &ipa->mem[IPA_MEM_MODEM_HEADER];
+	struct device *dev = &ipa->pdev->dev;
+	u32 offset_max;
+	u32 size_max;
+	u32 size;
+
+	offset_max = field_max(HDR_INIT_LOCAL_FLAGS_HDR_ADDR_FMASK);
+	if (mem->offset > offset_max ||
+	    ipa->mem_offset > offset_max - mem->offset) {
+		dev_err(dev, "header table region offset too large "
+			      "(0x%04x + 0x%04x > 0x%04x)\n",
+			      ipa->mem_offset + mem->offset, offset_max);
+		return false;
+	}
+
+	size_max = field_max(HDR_INIT_LOCAL_FLAGS_TABLE_SIZE_FMASK);
+	size = ipa->mem[IPA_MEM_MODEM_HEADER].size;
+	size += ipa->mem[IPA_MEM_AP_HEADER].size;
+	if (mem->offset > ipa->mem_size || size > ipa->mem_size - mem->offset) {
+		dev_err(dev, "header table region out of range "
+			      "(0x%04x + 0x%04x > 0x%04x)\n",
+			      mem->offset, size, ipa->mem_size);
+		return false;
+	}
+
+	return true;
+}
+
+/* Indicate whether an offset can be used with a register_write command */
+static bool ipa_cmd_register_write_offset_valid(struct ipa *ipa,
+						const char *name, u32 offset)
+{
+	struct ipa_cmd_register_write *payload;
+	struct device *dev = &ipa->pdev->dev;
+	u32 offset_max;
+	u32 bit_count;
+
+	/* The maximum offset in a register_write immediate command depends
+	 * on the version of IPA.  IPA v3.5.1 supports a 16 bit offset, but
+	 * newer versions allow some additional high-order bits.
+	 */
+	bit_count = BITS_PER_BYTE * sizeof(payload->offset);
+	if (ipa->version != IPA_VERSION_3_5_1)
+		bit_count += hweight32(REGISTER_WRITE_FLAGS_OFFSET_HIGH_FMASK);
+	BUILD_BUG_ON(bit_count > 32);
+	offset_max = ~0 >> (32 - bit_count);
+
+	if (offset > offset_max || ipa->mem_offset > offset_max - offset) {
+		dev_err(dev, "%s offset too large 0x%04x + 0x%04x > 0x%04x)\n",
+				ipa->mem_offset + offset, offset_max);
+		return false;
+	}
+
+	return true;
+}
+
+/* Check whether offsets passed to register_write are valid */
+static bool ipa_cmd_register_write_valid(struct ipa *ipa)
+{
+	const char *name;
+	u32 offset;
+
+	offset = ipa_reg_filt_rout_hash_flush_offset(ipa->version);
+	name = "filter/route hash flush";
+	if (!ipa_cmd_register_write_offset_valid(ipa, name, offset))
+		return false;
+
+	offset = IPA_REG_ENDP_STATUS_N_OFFSET(IPA_ENDPOINT_COUNT);
+	name = "maximal endpoint status";
+	if (!ipa_cmd_register_write_offset_valid(ipa, name, offset))
+		return false;
+
+	return true;
+}
+
+bool ipa_cmd_data_valid(struct ipa *ipa)
+{
+	if (!ipa_cmd_header_valid(ipa))
+		return false;
+
+	if (!ipa_cmd_register_write_valid(ipa))
+		return false;
+
+	return true;
+}
+
+#endif /* IPA_VALIDATE */
+
+int ipa_cmd_pool_init(struct gsi_channel *channel, u32 tre_max)
+{
+	struct gsi_trans_info *trans_info = &channel->trans_info;
+	struct device *dev = channel->gsi->dev;
+	int ret;
+
+	/* This is as good a place as any to validate build constants */
+	ipa_cmd_validate_build();
+
+	/* Even though command payloads are allocated one at a time,
+	 * a single transaction can require up to tlv_count of them,
+	 * so we treat them as if that many can be allocated at once.
+	 */
+	ret = gsi_trans_pool_init_dma(dev, &trans_info->cmd_pool,
+				      sizeof(union ipa_cmd_payload),
+				      tre_max, channel->tlv_count);
+	if (ret)
+		return ret;
+
+	/* Each TRE needs a command info structure */
+	ret = gsi_trans_pool_init(&trans_info->info_pool,
+				   sizeof(struct ipa_cmd_info),
+				   tre_max, channel->tlv_count);
+	if (ret)
+		gsi_trans_pool_exit_dma(dev, &trans_info->cmd_pool);
+
+	return ret;
+}
+
+void ipa_cmd_pool_exit(struct gsi_channel *channel)
+{
+	struct gsi_trans_info *trans_info = &channel->trans_info;
+	struct device *dev = channel->gsi->dev;
+
+	gsi_trans_pool_exit(&trans_info->info_pool);
+	gsi_trans_pool_exit_dma(dev, &trans_info->cmd_pool);
+}
+
+static union ipa_cmd_payload *
+ipa_cmd_payload_alloc(struct ipa *ipa, dma_addr_t *addr)
+{
+	struct gsi_trans_info *trans_info;
+	struct ipa_endpoint *endpoint;
+
+	endpoint = ipa->name_map[IPA_ENDPOINT_AP_COMMAND_TX];
+	trans_info = &ipa->gsi.channel[endpoint->channel_id].trans_info;
+
+	return gsi_trans_pool_alloc_dma(&trans_info->cmd_pool, addr);
+}
+
+/* If hash_size is 0, hash_offset and hash_addr ignored. */
+void ipa_cmd_table_init_add(struct gsi_trans *trans,
+			    enum ipa_cmd_opcode opcode, u16 size, u32 offset,
+			    dma_addr_t addr, u16 hash_size, u32 hash_offset,
+			    dma_addr_t hash_addr)
+{
+	struct ipa *ipa = container_of(trans->gsi, struct ipa, gsi);
+	enum dma_data_direction direction = DMA_TO_DEVICE;
+	struct ipa_cmd_hw_ip_fltrt_init *payload;
+	union ipa_cmd_payload *cmd_payload;
+	dma_addr_t payload_addr;
+	u64 val;
+
+	/* Record the non-hash table offset and size */
+	offset += ipa->mem_offset;
+	val = u64_encode_bits(offset, IP_FLTRT_FLAGS_NHASH_ADDR_FMASK);
+	val |= u64_encode_bits(size, IP_FLTRT_FLAGS_NHASH_SIZE_FMASK);
+
+	/* The hash table offset and address are zero if its size is 0 */
+	if (hash_size) {
+		/* Record the hash table offset and size */
+		hash_offset += ipa->mem_offset;
+		val |= u64_encode_bits(hash_offset,
+				       IP_FLTRT_FLAGS_HASH_ADDR_FMASK);
+		val |= u64_encode_bits(hash_size,
+				       IP_FLTRT_FLAGS_HASH_SIZE_FMASK);
+	}
+
+	cmd_payload = ipa_cmd_payload_alloc(ipa, &payload_addr);
+	payload = &cmd_payload->table_init;
+
+	/* Fill in all offsets and sizes and the non-hash table address */
+	if (hash_size)
+		payload->hash_rules_addr = cpu_to_le64(hash_addr);
+	payload->flags = cpu_to_le64(val);
+	payload->nhash_rules_addr = cpu_to_le64(addr);
+
+	gsi_trans_cmd_add(trans, payload, sizeof(*payload), payload_addr,
+			  direction, opcode);
+}
+
+/* Initialize header space in IPA-local memory */
+void ipa_cmd_hdr_init_local_add(struct gsi_trans *trans, u32 offset, u16 size,
+				dma_addr_t addr)
+{
+	struct ipa *ipa = container_of(trans->gsi, struct ipa, gsi);
+	enum ipa_cmd_opcode opcode = IPA_CMD_HDR_INIT_LOCAL;
+	enum dma_data_direction direction = DMA_TO_DEVICE;
+	struct ipa_cmd_hw_hdr_init_local *payload;
+	union ipa_cmd_payload *cmd_payload;
+	dma_addr_t payload_addr;
+	u32 flags;
+
+	offset += ipa->mem_offset;
+
+	/* With this command we tell the IPA where in its local memory the
+	 * header tables reside.  The content of the buffer provided is
+	 * also written via DMA into that space.  The IPA hardware owns
+	 * the table, but the AP must initialize it.
+	 */
+	cmd_payload = ipa_cmd_payload_alloc(ipa, &payload_addr);
+	payload = &cmd_payload->hdr_init_local;
+
+	payload->hdr_table_addr = cpu_to_le64(addr);
+	flags = u32_encode_bits(size, HDR_INIT_LOCAL_FLAGS_TABLE_SIZE_FMASK);
+	flags |= u32_encode_bits(offset, HDR_INIT_LOCAL_FLAGS_HDR_ADDR_FMASK);
+	payload->flags = cpu_to_le32(flags);
+
+	gsi_trans_cmd_add(trans, payload, sizeof(*payload), payload_addr,
+			  direction, opcode);
+}
+
+void ipa_cmd_register_write_add(struct gsi_trans *trans, u32 offset, u32 value,
+				u32 mask, bool clear_full)
+{
+	struct ipa *ipa = container_of(trans->gsi, struct ipa, gsi);
+	struct ipa_cmd_register_write *payload;
+	union ipa_cmd_payload *cmd_payload;
+	u32 opcode = IPA_CMD_REGISTER_WRITE;
+	dma_addr_t payload_addr;
+	u32 clear_option;
+	u32 options;
+	u16 flags;
+
+	/* pipeline_clear_src_grp is not used */
+	clear_option = clear_full ? pipeline_clear_full : pipeline_clear_hps;
+
+	if (ipa->version != IPA_VERSION_3_5_1) {
+		u16 offset_high;
+		u32 val;
+
+		/* Opcode encodes pipeline clear options */
+		/* SKIP_CLEAR is always 0 (don't skip pipeline clear) */
+		val = u16_encode_bits(clear_option,
+				      REGISTER_WRITE_OPCODE_CLEAR_OPTION_FMASK);
+		opcode |= val;
+
+		/* Extract the high 4 bits from the offset */
+		offset_high = (u16)u32_get_bits(offset, GENMASK(19, 16));
+		offset &= (1 << 16) - 1;
+
+		/* Extract the top 4 bits and encode it into the flags field */
+		flags = u16_encode_bits(offset_high,
+				REGISTER_WRITE_FLAGS_OFFSET_HIGH_FMASK);
+		options = 0;	/* reserved */
+
+	} else {
+		flags = 0;	/* SKIP_CLEAR flag is always 0 */
+		options = u16_encode_bits(clear_option,
+					  REGISTER_WRITE_CLEAR_OPTIONS_FMASK);
+	}
+
+	cmd_payload = ipa_cmd_payload_alloc(ipa, &payload_addr);
+	payload = &cmd_payload->register_write;
+
+	payload->flags = cpu_to_le16(flags);
+	payload->offset = cpu_to_le16((u16)offset);
+	payload->value = cpu_to_le32(value);
+	payload->value_mask = cpu_to_le32(mask);
+	payload->clear_options = cpu_to_le32(options);
+
+	gsi_trans_cmd_add(trans, payload, sizeof(*payload), payload_addr,
+			  DMA_NONE, opcode);
+}
+
+/* Skip IP packet processing on the next data transfer on a TX channel */
+static void ipa_cmd_ip_packet_init_add(struct gsi_trans *trans, u8 endpoint_id)
+{
+	struct ipa *ipa = container_of(trans->gsi, struct ipa, gsi);
+	enum ipa_cmd_opcode opcode = IPA_CMD_IP_PACKET_INIT;
+	enum dma_data_direction direction = DMA_TO_DEVICE;
+	struct ipa_cmd_ip_packet_init *payload;
+	union ipa_cmd_payload *cmd_payload;
+	dma_addr_t payload_addr;
+
+	/* assert(endpoint_id <
+		  field_max(IPA_PACKET_INIT_DEST_ENDPOINT_FMASK)); */
+
+	cmd_payload = ipa_cmd_payload_alloc(ipa, &payload_addr);
+	payload = &cmd_payload->ip_packet_init;
+
+	payload->dest_endpoint = u8_encode_bits(endpoint_id,
+					IPA_PACKET_INIT_DEST_ENDPOINT_FMASK);
+
+	gsi_trans_cmd_add(trans, payload, sizeof(*payload), payload_addr,
+			  direction, opcode);
+}
+
+/* Use a 32-bit DMA command to zero a block of memory */
+void ipa_cmd_dma_task_32b_addr_add(struct gsi_trans *trans, u16 size,
+				   dma_addr_t addr, bool toward_ipa)
+{
+	struct ipa *ipa = container_of(trans->gsi, struct ipa, gsi);
+	enum ipa_cmd_opcode opcode = IPA_CMD_DMA_TASK_32B_ADDR;
+	struct ipa_cmd_hw_dma_task_32b_addr *payload;
+	union ipa_cmd_payload *cmd_payload;
+	enum dma_data_direction direction;
+	dma_addr_t payload_addr;
+	u16 flags;
+
+	/* assert(addr <= U32_MAX); */
+	addr &= GENMASK_ULL(31, 0);
+
+	/* The opcode encodes the number of DMA operations in the high byte */
+	opcode |= u16_encode_bits(1, DMA_TASK_32B_ADDR_OPCODE_COUNT_FMASK);
+
+	direction = toward_ipa ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
+
+	/* complete: 0 = don't interrupt; eof: 0 = don't assert eot */
+	flags = DMA_TASK_32B_ADDR_FLAGS_FLSH_FMASK;
+	/* lock: 0 = don't lock endpoint; unlock: 0 = don't unlock */
+
+	cmd_payload = ipa_cmd_payload_alloc(ipa, &payload_addr);
+	payload = &cmd_payload->dma_task_32b_addr;
+
+	payload->flags = cpu_to_le16(flags);
+	payload->size = cpu_to_le16(size);
+	payload->addr = cpu_to_le32((u32)addr);
+	payload->packet_size = cpu_to_le16(size);
+
+	gsi_trans_cmd_add(trans, payload, sizeof(*payload), payload_addr,
+			  direction, opcode);
+}
+
+/* Use a DMA command to read or write a block of IPA-resident memory */
+void ipa_cmd_dma_shared_mem_add(struct gsi_trans *trans, u32 offset, u16 size,
+				dma_addr_t addr, bool toward_ipa)
+{
+	struct ipa *ipa = container_of(trans->gsi, struct ipa, gsi);
+	enum ipa_cmd_opcode opcode = IPA_CMD_DMA_SHARED_MEM;
+	struct ipa_cmd_hw_dma_mem_mem *payload;
+	union ipa_cmd_payload *cmd_payload;
+	enum dma_data_direction direction;
+	dma_addr_t payload_addr;
+	u16 flags;
+
+	/* size and offset must fit in 16 bit fields */
+	/* assert(size > 0 && size <= U16_MAX); */
+	/* assert(offset <= U16_MAX && ipa->mem_offset <= U16_MAX - offset); */
+
+	offset += ipa->mem_offset;
+
+	cmd_payload = ipa_cmd_payload_alloc(ipa, &payload_addr);
+	payload = &cmd_payload->dma_shared_mem;
+
+	/* payload->clear_after_read was reserved prior to IPA v4.0.  It's
+	 * never needed for current code, so it's 0 regardless of version.
+	 */
+	payload->size = cpu_to_le16(size);
+	payload->local_addr = cpu_to_le16(offset);
+	/* payload->flags:
+	 *   direction:		0 = write to IPA, 1 read from IPA
+	 * Starting at v4.0 these are reserved; either way, all zero:
+	 *   pipeline clear:	0 = wait for pipeline clear (don't skip)
+	 *   clear_options:	0 = pipeline_clear_hps
+	 * Instead, for v4.0+ these are encoded in the opcode.  But again
+	 * since both values are 0 we won't bother OR'ing them in.
+	 */
+	flags = toward_ipa ? 0 : DMA_SHARED_MEM_FLAGS_DIRECTION_FMASK;
+	payload->flags = cpu_to_le16(flags);
+	payload->system_addr = cpu_to_le64(addr);
+
+	direction = toward_ipa ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
+
+	gsi_trans_cmd_add(trans, payload, sizeof(*payload), payload_addr,
+			  direction, opcode);
+}
+
+static void ipa_cmd_ip_tag_status_add(struct gsi_trans *trans, u64 tag)
+{
+	struct ipa *ipa = container_of(trans->gsi, struct ipa, gsi);
+	enum ipa_cmd_opcode opcode = IPA_CMD_IP_PACKET_TAG_STATUS;
+	enum dma_data_direction direction = DMA_TO_DEVICE;
+	struct ipa_cmd_ip_packet_tag_status *payload;
+	union ipa_cmd_payload *cmd_payload;
+	dma_addr_t payload_addr;
+
+	/* assert(tag <= field_max(IP_PACKET_TAG_STATUS_TAG_FMASK)); */
+
+	cmd_payload = ipa_cmd_payload_alloc(ipa, &payload_addr);
+	payload = &cmd_payload->ip_packet_tag_status;
+
+	payload->tag = u64_encode_bits(tag, IP_PACKET_TAG_STATUS_TAG_FMASK);
+
+	gsi_trans_cmd_add(trans, payload, sizeof(*payload), payload_addr,
+			  direction, opcode);
+}
+
+/* Issue a small command TX data transfer */
+static void ipa_cmd_transfer_add(struct gsi_trans *trans, u16 size)
+{
+	struct ipa *ipa = container_of(trans->gsi, struct ipa, gsi);
+	enum dma_data_direction direction = DMA_TO_DEVICE;
+	enum ipa_cmd_opcode opcode = IPA_CMD_NONE;
+	union ipa_cmd_payload *payload;
+	dma_addr_t payload_addr;
+
+	/* assert(size <= sizeof(*payload)); */
+
+	/* Just transfer a zero-filled payload structure */
+	payload = ipa_cmd_payload_alloc(ipa, &payload_addr);
+
+	gsi_trans_cmd_add(trans, payload, sizeof(*payload), payload_addr,
+			  direction, opcode);
+}
+
+void ipa_cmd_tag_process_add(struct gsi_trans *trans)
+{
+	ipa_cmd_register_write_add(trans, 0, 0, 0, true);
+#if 1
+	/* Reference these functions to avoid a compile error */
+	(void)ipa_cmd_ip_packet_init_add;
+	(void)ipa_cmd_ip_tag_status_add;
+	(void) ipa_cmd_transfer_add;
+#else
+	struct ipa *ipa = container_of(trans->gsi, struct ipa, gsi);
+	struct gsi_endpoint *endpoint;
+
+	endpoint = ipa->name_map[IPA_ENDPOINT_AP_LAN_RX];
+	ipa_cmd_ip_packet_init_add(trans, endpoint->endpoint_id);
+
+	ipa_cmd_ip_tag_status_add(trans, 0xcba987654321);
+
+	ipa_cmd_transfer_add(trans, 4);
+#endif
+}
+
+/* Returns the number of commands required for the tag process */
+u32 ipa_cmd_tag_process_count(void)
+{
+	return 4;
+}
+
+static struct ipa_cmd_info *
+ipa_cmd_info_alloc(struct ipa_endpoint *endpoint, u32 tre_count)
+{
+	struct gsi_channel *channel;
+
+	channel = &endpoint->ipa->gsi.channel[endpoint->channel_id];
+
+	return gsi_trans_pool_alloc(&channel->trans_info.info_pool, tre_count);
+}
+
+/* Allocate a transaction for the command TX endpoint */
+struct gsi_trans *ipa_cmd_trans_alloc(struct ipa *ipa, u32 tre_count)
+{
+	struct ipa_endpoint *endpoint;
+	struct gsi_trans *trans;
+
+	endpoint = ipa->name_map[IPA_ENDPOINT_AP_COMMAND_TX];
+
+	trans = gsi_channel_trans_alloc(&ipa->gsi, endpoint->channel_id,
+					tre_count, DMA_NONE);
+	if (trans)
+		trans->info = ipa_cmd_info_alloc(endpoint, tre_count);
+
+	return trans;
+}
diff --git a/drivers/net/ipa/ipa_cmd.h b/drivers/net/ipa/ipa_cmd.h
new file mode 100644
index 000000000000..4917525b3a47
--- /dev/null
+++ b/drivers/net/ipa/ipa_cmd.h
@@ -0,0 +1,195 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
+ * Copyright (C) 2019-2020 Linaro Ltd.
+ */
+#ifndef _IPA_CMD_H_
+#define _IPA_CMD_H_
+
+#include <linux/types.h>
+#include <linux/dma-direction.h>
+
+struct sk_buff;
+struct scatterlist;
+
+struct ipa;
+struct ipa_mem;
+struct gsi_trans;
+struct gsi_channel;
+
+/**
+ * enum ipa_cmd_opcode:	IPA immediate commands
+ *
+ * All immediate commands are issued using the AP command TX endpoint.
+ * The numeric values here are the opcodes for IPA v3.5.1 hardware.
+ *
+ * IPA_CMD_NONE is a special (invalid) value that's used to indicate
+ * a request is *not* an immediate command.
+ */
+enum ipa_cmd_opcode {
+	IPA_CMD_NONE			= 0,
+	IPA_CMD_IP_V4_FILTER_INIT	= 3,
+	IPA_CMD_IP_V6_FILTER_INIT	= 4,
+	IPA_CMD_IP_V4_ROUTING_INIT	= 7,
+	IPA_CMD_IP_V6_ROUTING_INIT	= 8,
+	IPA_CMD_HDR_INIT_LOCAL		= 9,
+	IPA_CMD_REGISTER_WRITE		= 12,
+	IPA_CMD_IP_PACKET_INIT		= 16,
+	IPA_CMD_DMA_TASK_32B_ADDR	= 17,
+	IPA_CMD_DMA_SHARED_MEM		= 19,
+	IPA_CMD_IP_PACKET_TAG_STATUS	= 20,
+};
+
+/**
+ * struct ipa_cmd_info - information needed for an IPA immediate command
+ *
+ * @opcode:	The command opcode.
+ * @direction:	Direction of data transfer for DMA commands
+ */
+struct ipa_cmd_info {
+	enum ipa_cmd_opcode opcode;
+	enum dma_data_direction direction;
+};
+
+
+#ifdef IPA_VALIDATE
+
+/**
+ * ipa_cmd_table_valid() - Validate a memory region holding a table
+ * @ipa:	- IPA pointer
+ * @mem:	- IPA memory region descriptor
+ * @route:	- Whether the region holds a route or filter table
+ * @ipv6:	- Whether the table is for IPv6 or IPv4
+ * @hashed:	- Whether the table is hashed or non-hashed
+ *
+ * @Return:	true if region is valid, false otherwise
+ */
+bool ipa_cmd_table_valid(struct ipa *ipa, const struct ipa_mem *mem,
+			    bool route, bool ipv6, bool hashed);
+
+/**
+ * ipa_cmd_data_valid() - Validate command-realted configuration is valid
+ * @ipa:	- IPA pointer
+ *
+ * @Return:	true if assumptions required for command are valid
+ */
+bool ipa_cmd_data_valid(struct ipa *ipa);
+
+#else /* !IPA_VALIDATE */
+
+static inline bool ipa_cmd_table_valid(struct ipa *ipa,
+				       const struct ipa_mem *mem, bool route,
+				       bool ipv6, bool hashed)
+{
+	return true;
+}
+
+static inline bool ipa_cmd_data_valid(struct ipa *ipa)
+{
+	return true;
+}
+
+#endif /* !IPA_VALIDATE */
+
+/**
+ * ipa_cmd_pool_init() - initialize command channel pools
+ * @channel:	AP->IPA command TX GSI channel pointer
+ * @tre_count:	Number of pool elements to allocate
+ *
+ * @Return:	0 if successful, or a negative error code
+ */
+int ipa_cmd_pool_init(struct gsi_channel *gsi_channel, u32 tre_count);
+
+/**
+ * ipa_cmd_pool_exit() - Inverse of ipa_cmd_pool_init()
+ * @channel:	AP->IPA command TX GSI channel pointer
+ */
+void ipa_cmd_pool_exit(struct gsi_channel *channel);
+
+/**
+ * ipa_cmd_table_init_add() - Add table init command to a transaction
+ * @trans:	GSI transaction
+ * @opcode:	IPA immediate command opcode
+ * @size:	Size of non-hashed routing table memory
+ * @offset:	Offset in IPA shared memory of non-hashed routing table memory
+ * @addr:	DMA address of non-hashed table data to write
+ * @hash_size:	Size of hashed routing table memory
+ * @hash_offset: Offset in IPA shared memory of hashed routing table memory
+ * @hash_addr:	DMA address of hashed table data to write
+ *
+ * If hash_size is 0, hash_offset and hash_addr are ignored.
+ */
+void ipa_cmd_table_init_add(struct gsi_trans *trans, enum ipa_cmd_opcode opcode,
+			    u16 size, u32 offset, dma_addr_t addr,
+			    u16 hash_size, u32 hash_offset,
+			    dma_addr_t hash_addr);
+
+/**
+ * ipa_cmd_hdr_init_local_add() - Add a header init command to a transaction
+ * @ipa:	IPA structure
+ * @offset:	Offset of header memory in IPA local space
+ * @size:	Size of header memory
+ * @addr:	DMA address of buffer to be written from
+ *
+ * Defines and fills the location in IPA memory to use for headers.
+ */
+void ipa_cmd_hdr_init_local_add(struct gsi_trans *trans, u32 offset, u16 size,
+				dma_addr_t addr);
+
+/**
+ * ipa_cmd_register_write_add() - Add a register write command to a transaction
+ * @trans:	GSI transaction
+ * @offset:	Offset of register to be written
+ * @value:	Value to be written
+ * @mask:	Mask of bits in register to update with bits from value
+ * @clear_full: Pipeline clear option; true means full pipeline clear
+ */
+void ipa_cmd_register_write_add(struct gsi_trans *trans, u32 offset, u32 value,
+				u32 mask, bool clear_full);
+
+/**
+ * ipa_cmd_dma_task_32b_addr_add() - Add a 32-bit DMA command to a transaction
+ * @trans:	GSi transaction
+ * @size:	Number of bytes to be memory to be transferred
+ * @addr:	DMA address of buffer to be read into or written from
+ * @toward_ipa:	true means write to IPA memory; false means read
+ */
+void ipa_cmd_dma_task_32b_addr_add(struct gsi_trans *trans, u16 size,
+				   dma_addr_t addr, bool toward_ipa);
+
+/**
+ * ipa_cmd_dma_shared_mem_add() - Add a DMA memory command to a transaction
+ * @trans:	GSI transaction
+ * @offset:	Offset of IPA memory to be read or written
+ * @size:	Number of bytes of memory to be transferred
+ * @addr:	DMA address of buffer to be read into or written from
+ * @toward_ipa:	true means write to IPA memory; false means read
+ */
+void ipa_cmd_dma_shared_mem_add(struct gsi_trans *trans, u32 offset,
+				u16 size, dma_addr_t addr, bool toward_ipa);
+
+/**
+ * ipa_cmd_tag_process_add() - Add IPA tag process commands to a transaction
+ * @trans:	GSI transaction
+ */
+void ipa_cmd_tag_process_add(struct gsi_trans *trans);
+
+/**
+ * ipa_cmd_tag_process_add_count() - Number of commands in a tag process
+ *
+ * @Return:	The number of elements to allocate in a transaction
+ *		to hold tag process commands
+ */
+u32 ipa_cmd_tag_process_count(void);
+
+/**
+ * ipa_cmd_trans_alloc() - Allocate a transaction for the command TX endpoint
+ * @ipa:	IPA pointer
+ * @tre_count:	Number of elements in the transaction
+ *
+ * @Return:	A GSI transaction structure, or a null pointer if all
+ *		available transactions are in use
+ */
+struct gsi_trans *ipa_cmd_trans_alloc(struct ipa *ipa, u32 tre_count);
+
+#endif /* _IPA_CMD_H_ */
-- 
2.20.1

