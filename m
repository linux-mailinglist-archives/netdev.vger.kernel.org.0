Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1C806477D0
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 22:15:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbiLHVPy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 16:15:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbiLHVPk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 16:15:40 -0500
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E675A5061
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 13:15:36 -0800 (PST)
Received: by mail-il1-x136.google.com with SMTP id y2so1751934ily.5
        for <netdev@vger.kernel.org>; Thu, 08 Dec 2022 13:15:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=irch5lN8WsbvYCUItzF8KFRt4PzZvlIQQdFtmIxshxA=;
        b=Mea4h46Oo+E52D1d7AHqorVMzy7d7bp2fUxMrrNWaUe0LDMrXfgOu65EoXpK2ULjI4
         faAW88OAxIoMDKFVUieoSlEalORDDzJ2l4C3S94zIuV/bWFEz036YsB4Dhm+YNq/OrK/
         KWZNjE46MXHZNOzRWaiRktBDf/ISJ9capfPnf/IrKjm48ghEtF7CjIAn/GVLT4228N+E
         ++O5SryFW+T4+9bpaWOPlCi6b4DG0s7x5V1GDgDFxUxsmLMaXjis5WERc1gyq7RRzMMY
         118juMn+vlpqUF2gQkZDbIvW90BCF+KhkoBDDzYHy1if1+BRXGZtwj+4NVaVyEIvQteu
         rOEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=irch5lN8WsbvYCUItzF8KFRt4PzZvlIQQdFtmIxshxA=;
        b=TGanqvw9zrs+fYbhYJdjWRY9tQdc3PnphMQ3rBf1+cPOb+HHMnW0UzV6h5DuzbSG7U
         firoyfeUoXb6z8Yom7giR06Rea/TPIx9ksX54EU2MIq/kz9sQSmF4mYhLDWVmB9Qslc7
         MA4YAenlINcyZAt0pJ6oYMEoGToJeRD3vCwfkxmicFNujMw85TakwXMnQyWvN7fk45lN
         cop4vnwFNbBZLXs3FtuE0/1VdmAxhx/+rSSseeDIkgo0z1Sb+oawMBX3cGxZErwdGLtS
         br9M1st8WqWClqmMXkd1/haEkl4YZGwPCNFpHWR4uA0JcdNQ+hLG9SueY1Fuo54sy8E5
         W0Fw==
X-Gm-Message-State: ANoB5pl6mpWMRmmZQMggiQAVE8HR1Vq7l4gpWiiPWH1OWPy2C+qsT1dk
        jCtn+MtbaYbWZFXqdF0UshLCqw==
X-Google-Smtp-Source: AA0mqf5HrPB5v40/WkplXZYh19LUAl3BStaGYuIh3XDbukHoQbnron/NOhSK0ZyjYMOj5zgj2wtRug==
X-Received: by 2002:a92:4a03:0:b0:303:568:2f1a with SMTP id m3-20020a924a03000000b0030305682f1amr2008839ilf.8.1670534135469;
        Thu, 08 Dec 2022 13:15:35 -0800 (PST)
Received: from localhost.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id k5-20020a92c245000000b002e85e8b8d1dsm1099821ilo.5.2022.12.08.13.15.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 13:15:35 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     andersson@kernel.org, konrad.dybcio@linaro.org, agross@kernel.org,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        elder@kernel.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Luca Weiss <luca.weiss@fairphone.com>
Subject: [PATCH net-next 2/2] net: ipa: add IPA v4.7 support
Date:   Thu,  8 Dec 2022 15:15:29 -0600
Message-Id: <20221208211529.757669-3-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221208211529.757669-1-elder@linaro.org>
References: <20221208211529.757669-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the necessary register and data definitions needed for IPA v4.7,
which is found on the SM6350 SoC.

Co-developed-by: Luca Weiss <luca.weiss@fairphone.com>
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/Makefile             |   2 +-
 drivers/net/ipa/data/ipa_data-v4.7.c | 405 +++++++++++++++++++++
 drivers/net/ipa/ipa_data.h           |   1 +
 drivers/net/ipa/ipa_main.c           |   4 +
 drivers/net/ipa/ipa_reg.c            |   2 +
 drivers/net/ipa/ipa_reg.h            |   1 +
 drivers/net/ipa/ipa_version.h        |   1 +
 drivers/net/ipa/reg/ipa_reg-v4.7.c   | 507 +++++++++++++++++++++++++++
 8 files changed, 922 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ipa/data/ipa_data-v4.7.c
 create mode 100644 drivers/net/ipa/reg/ipa_reg-v4.7.c

diff --git a/drivers/net/ipa/Makefile b/drivers/net/ipa/Makefile
index 48255fc4b25c3..8cdcaaf58ae34 100644
--- a/drivers/net/ipa/Makefile
+++ b/drivers/net/ipa/Makefile
@@ -2,7 +2,7 @@
 #
 # Makefile for the Qualcomm IPA driver.
 
-IPA_VERSIONS		:=	3.1 3.5.1 4.2 4.5 4.9 4.11
+IPA_VERSIONS		:=	3.1 3.5.1 4.2 4.5 4.7 4.9 4.11
 
 obj-$(CONFIG_QCOM_IPA)	+=	ipa.o
 
diff --git a/drivers/net/ipa/data/ipa_data-v4.7.c b/drivers/net/ipa/data/ipa_data-v4.7.c
new file mode 100644
index 0000000000000..7552c400961eb
--- /dev/null
+++ b/drivers/net/ipa/data/ipa_data-v4.7.c
@@ -0,0 +1,405 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/* Copyright (C) 2022 Linaro Ltd. */
+
+#include <linux/log2.h>
+
+#include "../gsi.h"
+#include "../ipa_data.h"
+#include "../ipa_endpoint.h"
+#include "../ipa_mem.h"
+
+/** enum ipa_resource_type - IPA resource types for an SoC having IPA v4.7 */
+enum ipa_resource_type {
+	/* Source resource types; first must have value 0 */
+	IPA_RESOURCE_TYPE_SRC_PKT_CONTEXTS		= 0,
+	IPA_RESOURCE_TYPE_SRC_DESCRIPTOR_LISTS,
+	IPA_RESOURCE_TYPE_SRC_DESCRIPTOR_BUFF,
+	IPA_RESOURCE_TYPE_SRC_HPS_DMARS,
+	IPA_RESOURCE_TYPE_SRC_ACK_ENTRIES,
+
+	/* Destination resource types; first must have value 0 */
+	IPA_RESOURCE_TYPE_DST_DATA_SECTORS		= 0,
+	IPA_RESOURCE_TYPE_DST_DPS_DMARS,
+};
+
+/* Resource groups used for an SoC having IPA v4.7 */
+enum ipa_rsrc_group_id {
+	/* Source resource group identifiers */
+	IPA_RSRC_GROUP_SRC_UL_DL			= 0,
+	IPA_RSRC_GROUP_SRC_UC_RX_Q,
+	IPA_RSRC_GROUP_SRC_COUNT,	/* Last in set; not a source group */
+
+	/* Destination resource group identifiers */
+	IPA_RSRC_GROUP_DST_UL_DL_DPL			= 0,
+	IPA_RSRC_GROUP_DST_UNUSED_1,
+	IPA_RSRC_GROUP_DST_COUNT,	/* Last; not a destination group */
+};
+
+/* QSB configuration data for an SoC having IPA v4.7 */
+static const struct ipa_qsb_data ipa_qsb_data[] = {
+	[IPA_QSB_MASTER_DDR] = {
+		.max_writes		= 8,
+		.max_reads		= 0,	/* no limit (hardware max) */
+		.max_reads_beats	= 120,
+	},
+};
+
+/* Endpoint configuration data for an SoC having IPA v4.7 */
+static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
+	[IPA_ENDPOINT_AP_COMMAND_TX] = {
+		.ee_id		= GSI_EE_AP,
+		.channel_id	= 5,
+		.endpoint_id	= 7,
+		.toward_ipa	= true,
+		.channel = {
+			.tre_count	= 256,
+			.event_count	= 256,
+			.tlv_count	= 20,
+		},
+		.endpoint = {
+			.config = {
+				.resource_group	= IPA_RSRC_GROUP_SRC_UL_DL,
+				.dma_mode	= true,
+				.dma_endpoint	= IPA_ENDPOINT_AP_LAN_RX,
+				.tx = {
+					.seq_type = IPA_SEQ_DMA,
+				},
+			},
+		},
+	},
+	[IPA_ENDPOINT_AP_LAN_RX] = {
+		.ee_id		= GSI_EE_AP,
+		.channel_id	= 14,
+		.endpoint_id	= 9,
+		.toward_ipa	= false,
+		.channel = {
+			.tre_count	= 256,
+			.event_count	= 256,
+			.tlv_count	= 9,
+		},
+		.endpoint = {
+			.config = {
+				.resource_group	= IPA_RSRC_GROUP_DST_UL_DL_DPL,
+				.aggregation	= true,
+				.status_enable	= true,
+				.rx = {
+					.buffer_size	= 8192,
+					.pad_align	= ilog2(sizeof(u32)),
+					.aggr_time_limit = 500,
+				},
+			},
+		},
+	},
+	[IPA_ENDPOINT_AP_MODEM_TX] = {
+		.ee_id		= GSI_EE_AP,
+		.channel_id	= 2,
+		.endpoint_id	= 2,
+		.toward_ipa	= true,
+		.channel = {
+			.tre_count	= 512,
+			.event_count	= 512,
+			.tlv_count	= 16,
+		},
+		.endpoint = {
+			.filter_support	= true,
+			.config = {
+				.resource_group	= IPA_RSRC_GROUP_SRC_UL_DL,
+				.qmap		= true,
+				.status_enable	= true,
+				.tx = {
+					.seq_type = IPA_SEQ_2_PASS_SKIP_LAST_UC,
+					.status_endpoint =
+						IPA_ENDPOINT_MODEM_AP_RX,
+				},
+			},
+		},
+	},
+	[IPA_ENDPOINT_AP_MODEM_RX] = {
+		.ee_id		= GSI_EE_AP,
+		.channel_id	= 7,
+		.endpoint_id	= 16,
+		.toward_ipa	= false,
+		.channel = {
+			.tre_count	= 256,
+			.event_count	= 256,
+			.tlv_count	= 9,
+		},
+		.endpoint = {
+			.config = {
+				.resource_group	= IPA_RSRC_GROUP_DST_UL_DL_DPL,
+				.qmap		= true,
+				.aggregation	= true,
+				.rx = {
+					.buffer_size	= 8192,
+					.aggr_time_limit = 500,
+					.aggr_close_eof	= true,
+				},
+			},
+		},
+	},
+	[IPA_ENDPOINT_MODEM_AP_TX] = {
+		.ee_id		= GSI_EE_MODEM,
+		.channel_id	= 0,
+		.endpoint_id	= 5,
+		.toward_ipa	= true,
+		.endpoint = {
+			.filter_support	= true,
+		},
+	},
+	[IPA_ENDPOINT_MODEM_AP_RX] = {
+		.ee_id		= GSI_EE_MODEM,
+		.channel_id	= 7,
+		.endpoint_id	= 14,
+		.toward_ipa	= false,
+	},
+	[IPA_ENDPOINT_MODEM_DL_NLO_TX] = {
+		.ee_id		= GSI_EE_MODEM,
+		.channel_id	= 2,
+		.endpoint_id	= 8,
+		.toward_ipa	= true,
+		.endpoint = {
+			.filter_support	= true,
+		},
+	},
+};
+
+/* Source resource configuration data for an SoC having IPA v4.7 */
+static const struct ipa_resource ipa_resource_src[] = {
+	[IPA_RESOURCE_TYPE_SRC_PKT_CONTEXTS] = {
+		.limits[IPA_RSRC_GROUP_SRC_UL_DL] = {
+			.min = 8,	.max = 8,
+		},
+	},
+	[IPA_RESOURCE_TYPE_SRC_DESCRIPTOR_LISTS] = {
+		.limits[IPA_RSRC_GROUP_SRC_UL_DL] = {
+			.min = 8,	.max = 8,
+		},
+	},
+	[IPA_RESOURCE_TYPE_SRC_DESCRIPTOR_BUFF] = {
+		.limits[IPA_RSRC_GROUP_SRC_UL_DL] = {
+			.min = 18,	.max = 18,
+		},
+	},
+	[IPA_RESOURCE_TYPE_SRC_HPS_DMARS] = {
+		.limits[IPA_RSRC_GROUP_SRC_UL_DL] = {
+			.min = 2,	.max = 2,
+		},
+	},
+	[IPA_RESOURCE_TYPE_SRC_ACK_ENTRIES] = {
+		.limits[IPA_RSRC_GROUP_SRC_UL_DL] = {
+			.min = 15,	.max = 15,
+		},
+	},
+};
+
+/* Destination resource configuration data for an SoC having IPA v4.7 */
+static const struct ipa_resource ipa_resource_dst[] = {
+	[IPA_RESOURCE_TYPE_DST_DATA_SECTORS] = {
+		.limits[IPA_RSRC_GROUP_DST_UL_DL_DPL] = {
+			.min = 7,	.max = 7,
+		},
+	},
+	[IPA_RESOURCE_TYPE_DST_DPS_DMARS] = {
+		.limits[IPA_RSRC_GROUP_DST_UL_DL_DPL] = {
+			.min = 2,	.max = 2,
+		},
+	},
+};
+
+/* Resource configuration data for an SoC having IPA v4.7 */
+static const struct ipa_resource_data ipa_resource_data = {
+	.rsrc_group_dst_count	= IPA_RSRC_GROUP_DST_COUNT,
+	.rsrc_group_src_count	= IPA_RSRC_GROUP_SRC_COUNT,
+	.resource_src_count	= ARRAY_SIZE(ipa_resource_src),
+	.resource_src		= ipa_resource_src,
+	.resource_dst_count	= ARRAY_SIZE(ipa_resource_dst),
+	.resource_dst		= ipa_resource_dst,
+};
+
+/* IPA-resident memory region data for an SoC having IPA v4.7 */
+static const struct ipa_mem ipa_mem_local_data[] = {
+	{
+		.id		= IPA_MEM_UC_SHARED,
+		.offset		= 0x0000,
+		.size		= 0x0080,
+		.canary_count	= 0,
+	},
+	{
+		.id		= IPA_MEM_UC_INFO,
+		.offset		= 0x0080,
+		.size		= 0x0200,
+		.canary_count	= 0,
+	},
+	{
+		.id		= IPA_MEM_V4_FILTER_HASHED,
+		.offset		= 0x0288,
+		.size		= 0x0078,
+		.canary_count	= 2,
+	},
+	{
+		.id		= IPA_MEM_V4_FILTER,
+		.offset		= 0x0308,
+		.size		= 0x0078,
+		.canary_count	= 2,
+	},
+	{
+		.id		= IPA_MEM_V6_FILTER_HASHED,
+		.offset		= 0x0388,
+		.size		= 0x0078,
+		.canary_count	= 2,
+	},
+	{
+		.id		= IPA_MEM_V6_FILTER,
+		.offset		= 0x0408,
+		.size		= 0x0078,
+		.canary_count	= 2,
+	},
+	{
+		.id		= IPA_MEM_V4_ROUTE_HASHED,
+		.offset		= 0x0488,
+		.size		= 0x0078,
+		.canary_count	= 2,
+	},
+	{
+		.id		= IPA_MEM_V4_ROUTE,
+		.offset		= 0x0508,
+		.size		= 0x0078,
+		.canary_count	= 2,
+	},
+	{
+		.id		= IPA_MEM_V6_ROUTE_HASHED,
+		.offset		= 0x0588,
+		.size		= 0x0078,
+		.canary_count	= 2,
+	},
+	{
+		.id		= IPA_MEM_V6_ROUTE,
+		.offset		= 0x0608,
+		.size		= 0x0078,
+		.canary_count	= 2,
+	},
+	{
+		.id		= IPA_MEM_MODEM_HEADER,
+		.offset		= 0x0688,
+		.size		= 0x0240,
+		.canary_count	= 2,
+	},
+	{
+		.id		= IPA_MEM_AP_HEADER,
+		.offset		= 0x08c8,
+		.size		= 0x0200,
+		.canary_count	= 0,
+	},
+	{
+		.id		= IPA_MEM_MODEM_PROC_CTX,
+		.offset		= 0x0ad0,
+		.size		= 0x0200,
+		.canary_count	= 2,
+	},
+	{
+		.id		= IPA_MEM_AP_PROC_CTX,
+		.offset		= 0x0cd0,
+		.size		= 0x0200,
+		.canary_count	= 0,
+	},
+	{
+		.id		= IPA_MEM_NAT_TABLE,
+		.offset		= 0x0ee0,
+		.size		= 0x0d00,
+		.canary_count	= 4,
+	},
+	{
+		.id		= IPA_MEM_PDN_CONFIG,
+		.offset		= 0x1be8,
+		.size		= 0x0050,
+		.canary_count	= 0,
+	},
+	{
+		.id		= IPA_MEM_STATS_QUOTA_MODEM,
+		.offset		= 0x1c40,
+		.size		= 0x0030,
+		.canary_count	= 4,
+	},
+	{
+		.id		= IPA_MEM_STATS_QUOTA_AP,
+		.offset		= 0x1c70,
+		.size		= 0x0048,
+		.canary_count	= 0,
+	},
+	{
+		.id		= IPA_MEM_STATS_TETHERING,
+		.offset		= 0x1cb8,
+		.size		= 0x0238,
+		.canary_count	= 0,
+	},
+	{
+		.id		= IPA_MEM_STATS_DROP,
+		.offset		= 0x1ef0,
+		.size		= 0x0020,
+		.canary_count	= 0,
+	},
+	{
+		.id		= IPA_MEM_MODEM,
+		.offset		= 0x1f18,
+		.size		= 0x100c,
+		.canary_count	= 2,
+	},
+	{
+		.id		= IPA_MEM_END_MARKER,
+		.offset		= 0x3000,
+		.size		= 0x0000,
+		.canary_count	= 1,
+	},
+};
+
+/* Memory configuration data for an SoC having IPA v4.7 */
+static const struct ipa_mem_data ipa_mem_data = {
+	.local_count	= ARRAY_SIZE(ipa_mem_local_data),
+	.local		= ipa_mem_local_data,
+	.imem_addr	= 0x146a9000,
+	.imem_size	= 0x00002000,
+	.smem_id	= 497,
+	.smem_size	= 0x00009000,
+};
+
+/* Interconnect rates are in 1000 byte/second units */
+static const struct ipa_interconnect_data ipa_interconnect_data[] = {
+	{
+		.name			= "memory",
+		.peak_bandwidth		= 600000,	/* 600 MBps */
+		.average_bandwidth	= 150000,	/* 150 MBps */
+	},
+	/* Average rate is unused for the next two interconnects */
+	{
+		.name			= "imem",
+		.peak_bandwidth		= 450000,	/* 450 MBps */
+		.average_bandwidth	= 75000,	/* 75 MBps (unused?) */
+	},
+	{
+		.name			= "config",
+		.peak_bandwidth		= 171400,	/* 171.4 MBps */
+		.average_bandwidth	= 0,		/* unused */
+	},
+};
+
+/* Clock and interconnect configuration data for an SoC having IPA v4.7 */
+static const struct ipa_power_data ipa_power_data = {
+	/* XXX Downstream code says 150 MHz (DT SVS2), 60 MHz (code) */
+	.core_clock_rate	= 100 * 1000 * 1000,	/* Hz (150?  60?) */
+	.interconnect_count	= ARRAY_SIZE(ipa_interconnect_data),
+	.interconnect_data	= ipa_interconnect_data,
+};
+
+/* Configuration data for an SoC having IPA v4.7 */
+const struct ipa_data ipa_data_v4_7 = {
+	.version		= IPA_VERSION_4_7,
+	.qsb_count		= ARRAY_SIZE(ipa_qsb_data),
+	.qsb_data		= ipa_qsb_data,
+	.modem_route_count	= 8,
+	.endpoint_count		= ARRAY_SIZE(ipa_gsi_endpoint_data),
+	.endpoint_data		= ipa_gsi_endpoint_data,
+	.resource_data		= &ipa_resource_data,
+	.mem_data		= &ipa_mem_data,
+	.power_data		= &ipa_power_data,
+};
diff --git a/drivers/net/ipa/ipa_data.h b/drivers/net/ipa/ipa_data.h
index 412edbfac7862..818e64114ed50 100644
--- a/drivers/net/ipa/ipa_data.h
+++ b/drivers/net/ipa/ipa_data.h
@@ -246,6 +246,7 @@ extern const struct ipa_data ipa_data_v3_1;
 extern const struct ipa_data ipa_data_v3_5_1;
 extern const struct ipa_data ipa_data_v4_2;
 extern const struct ipa_data ipa_data_v4_5;
+extern const struct ipa_data ipa_data_v4_7;
 extern const struct ipa_data ipa_data_v4_9;
 extern const struct ipa_data ipa_data_v4_11;
 
diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index 8f20825675a1a..4fb92f7719741 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -662,6 +662,10 @@ static const struct of_device_id ipa_match[] = {
 		.compatible	= "qcom,sdx55-ipa",
 		.data		= &ipa_data_v4_5,
 	},
+	{
+		.compatible	= "qcom,sm6350-ipa",
+		.data		= &ipa_data_v4_7,
+	},
 	{
 		.compatible	= "qcom,sm8350-ipa",
 		.data		= &ipa_data_v4_9,
diff --git a/drivers/net/ipa/ipa_reg.c b/drivers/net/ipa/ipa_reg.c
index 22f067741d9b2..ddd529153e15c 100644
--- a/drivers/net/ipa/ipa_reg.c
+++ b/drivers/net/ipa/ipa_reg.c
@@ -86,6 +86,8 @@ static const struct ipa_regs *ipa_regs(enum ipa_version version)
 		return &ipa_regs_v4_2;
 	case IPA_VERSION_4_5:
 		return &ipa_regs_v4_5;
+	case IPA_VERSION_4_7:
+		return &ipa_regs_v4_7;
 	case IPA_VERSION_4_9:
 		return &ipa_regs_v4_9;
 	case IPA_VERSION_4_11:
diff --git a/drivers/net/ipa/ipa_reg.h b/drivers/net/ipa/ipa_reg.h
index 7bf70f70f63fe..ff64b19a4df8b 100644
--- a/drivers/net/ipa/ipa_reg.h
+++ b/drivers/net/ipa/ipa_reg.h
@@ -658,6 +658,7 @@ extern const struct ipa_regs ipa_regs_v3_1;
 extern const struct ipa_regs ipa_regs_v3_5_1;
 extern const struct ipa_regs ipa_regs_v4_2;
 extern const struct ipa_regs ipa_regs_v4_5;
+extern const struct ipa_regs ipa_regs_v4_7;
 extern const struct ipa_regs ipa_regs_v4_9;
 extern const struct ipa_regs ipa_regs_v4_11;
 
diff --git a/drivers/net/ipa/ipa_version.h b/drivers/net/ipa/ipa_version.h
index 7889c310e943d..d15821467743a 100644
--- a/drivers/net/ipa/ipa_version.h
+++ b/drivers/net/ipa/ipa_version.h
@@ -48,6 +48,7 @@ static inline bool ipa_version_supported(enum ipa_version version)
 	case IPA_VERSION_3_5_1:
 	case IPA_VERSION_4_2:
 	case IPA_VERSION_4_5:
+	case IPA_VERSION_4_7:
 	case IPA_VERSION_4_9:
 	case IPA_VERSION_4_11:
 	case IPA_VERSION_5_0:
diff --git a/drivers/net/ipa/reg/ipa_reg-v4.7.c b/drivers/net/ipa/reg/ipa_reg-v4.7.c
new file mode 100644
index 0000000000000..21f8a58e59a02
--- /dev/null
+++ b/drivers/net/ipa/reg/ipa_reg-v4.7.c
@@ -0,0 +1,507 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/* Copyright (C) 2022 Linaro Ltd. */
+
+#include <linux/types.h>
+
+#include "../ipa.h"
+#include "../ipa_reg.h"
+
+static const u32 ipa_reg_comp_cfg_fmask[] = {
+	[RAM_ARB_PRI_CLIENT_SAMP_FIX_DIS]		= BIT(0),
+	[GSI_SNOC_BYPASS_DIS]				= BIT(1),
+	[GEN_QMB_0_SNOC_BYPASS_DIS]			= BIT(2),
+	[GEN_QMB_1_SNOC_BYPASS_DIS]			= BIT(3),
+						/* Bit 4 reserved */
+	[IPA_QMB_SELECT_CONS_EN]			= BIT(5),
+	[IPA_QMB_SELECT_PROD_EN]			= BIT(6),
+	[GSI_MULTI_INORDER_RD_DIS]			= BIT(7),
+	[GSI_MULTI_INORDER_WR_DIS]			= BIT(8),
+	[GEN_QMB_0_MULTI_INORDER_RD_DIS]		= BIT(9),
+	[GEN_QMB_1_MULTI_INORDER_RD_DIS]		= BIT(10),
+	[GEN_QMB_0_MULTI_INORDER_WR_DIS]		= BIT(11),
+	[GEN_QMB_1_MULTI_INORDER_WR_DIS]		= BIT(12),
+	[GEN_QMB_0_SNOC_CNOC_LOOP_PROT_DIS]		= BIT(13),
+	[GSI_SNOC_CNOC_LOOP_PROT_DISABLE]		= BIT(14),
+	[GSI_MULTI_AXI_MASTERS_DIS]			= BIT(15),
+	[IPA_QMB_SELECT_GLOBAL_EN]			= BIT(16),
+	[ATOMIC_FETCHER_ARB_LOCK_DIS]			= GENMASK(20, 17),
+	[FULL_FLUSH_WAIT_RS_CLOSURE_EN]			= BIT(21),
+						/* Bits 22-31 reserved */
+};
+
+IPA_REG_FIELDS(COMP_CFG, comp_cfg, 0x0000003c);
+
+static const u32 ipa_reg_clkon_cfg_fmask[] = {
+	[CLKON_RX]					= BIT(0),
+	[CLKON_PROC]					= BIT(1),
+	[TX_WRAPPER]					= BIT(2),
+	[CLKON_MISC]					= BIT(3),
+	[RAM_ARB]					= BIT(4),
+	[FTCH_HPS]					= BIT(5),
+	[FTCH_DPS]					= BIT(6),
+	[CLKON_HPS]					= BIT(7),
+	[CLKON_DPS]					= BIT(8),
+	[RX_HPS_CMDQS]					= BIT(9),
+	[HPS_DPS_CMDQS]					= BIT(10),
+	[DPS_TX_CMDQS]					= BIT(11),
+	[RSRC_MNGR]					= BIT(12),
+	[CTX_HANDLER]					= BIT(13),
+	[ACK_MNGR]					= BIT(14),
+	[D_DCPH]					= BIT(15),
+	[H_DCPH]					= BIT(16),
+	[CLKON_DCMP]					= BIT(17),
+	[NTF_TX_CMDQS]					= BIT(18),
+	[CLKON_TX_0]					= BIT(19),
+	[CLKON_TX_1]					= BIT(20),
+	[CLKON_FNR]					= BIT(21),
+	[QSB2AXI_CMDQ_L]				= BIT(22),
+	[AGGR_WRAPPER]					= BIT(23),
+	[RAM_SLAVEWAY]					= BIT(24),
+	[CLKON_QMB]					= BIT(25),
+	[WEIGHT_ARB]					= BIT(26),
+	[GSI_IF]					= BIT(27),
+	[CLKON_GLOBAL]					= BIT(28),
+	[GLOBAL_2X_CLK]					= BIT(29),
+	[DPL_FIFO]					= BIT(30),
+	[DRBIP]						= BIT(31),
+};
+
+IPA_REG_FIELDS(CLKON_CFG, clkon_cfg, 0x00000044);
+
+static const u32 ipa_reg_route_fmask[] = {
+	[ROUTE_DIS]					= BIT(0),
+	[ROUTE_DEF_PIPE]				= GENMASK(5, 1),
+	[ROUTE_DEF_HDR_TABLE]				= BIT(6),
+	[ROUTE_DEF_HDR_OFST]				= GENMASK(16, 7),
+	[ROUTE_FRAG_DEF_PIPE]				= GENMASK(21, 17),
+						/* Bits 22-23 reserved */
+	[ROUTE_DEF_RETAIN_HDR]				= BIT(24),
+						/* Bits 25-31 reserved */
+};
+
+IPA_REG_FIELDS(ROUTE, route, 0x00000048);
+
+static const u32 ipa_reg_shared_mem_size_fmask[] = {
+	[MEM_SIZE]					= GENMASK(15, 0),
+	[MEM_BADDR]					= GENMASK(31, 16),
+};
+
+IPA_REG_FIELDS(SHARED_MEM_SIZE, shared_mem_size, 0x00000054);
+
+static const u32 ipa_reg_qsb_max_writes_fmask[] = {
+	[GEN_QMB_0_MAX_WRITES]				= GENMASK(3, 0),
+	[GEN_QMB_1_MAX_WRITES]				= GENMASK(7, 4),
+						/* Bits 8-31 reserved */
+};
+
+IPA_REG_FIELDS(QSB_MAX_WRITES, qsb_max_writes, 0x00000074);
+
+static const u32 ipa_reg_qsb_max_reads_fmask[] = {
+	[GEN_QMB_0_MAX_READS]				= GENMASK(3, 0),
+	[GEN_QMB_1_MAX_READS]				= GENMASK(7, 4),
+						/* Bits 8-15 reserved */
+	[GEN_QMB_0_MAX_READS_BEATS]			= GENMASK(23, 16),
+	[GEN_QMB_1_MAX_READS_BEATS]			= GENMASK(31, 24),
+};
+
+IPA_REG_FIELDS(QSB_MAX_READS, qsb_max_reads, 0x00000078);
+
+static const u32 ipa_reg_filt_rout_hash_en_fmask[] = {
+	[IPV6_ROUTER_HASH]				= BIT(0),
+						/* Bits 1-3 reserved */
+	[IPV6_FILTER_HASH]				= BIT(4),
+						/* Bits 5-7 reserved */
+	[IPV4_ROUTER_HASH]				= BIT(8),
+						/* Bits 9-11 reserved */
+	[IPV4_FILTER_HASH]				= BIT(12),
+						/* Bits 13-31 reserved */
+};
+
+IPA_REG_FIELDS(FILT_ROUT_HASH_EN, filt_rout_hash_en, 0x0000148);
+
+static const u32 ipa_reg_filt_rout_hash_flush_fmask[] = {
+	[IPV6_ROUTER_HASH]				= BIT(0),
+						/* Bits 1-3 reserved */
+	[IPV6_FILTER_HASH]				= BIT(4),
+						/* Bits 5-7 reserved */
+	[IPV4_ROUTER_HASH]				= BIT(8),
+						/* Bits 9-11 reserved */
+	[IPV4_FILTER_HASH]				= BIT(12),
+						/* Bits 13-31 reserved */
+};
+
+IPA_REG_FIELDS(FILT_ROUT_HASH_FLUSH, filt_rout_hash_flush, 0x000014c);
+
+/* Valid bits defined by ipa->available */
+IPA_REG_STRIDE(STATE_AGGR_ACTIVE, state_aggr_active, 0x000000b4, 0x0004);
+
+static const u32 ipa_reg_local_pkt_proc_cntxt_fmask[] = {
+	[IPA_BASE_ADDR]					= GENMASK(17, 0),
+						/* Bits 18-31 reserved */
+};
+
+/* Offset must be a multiple of 8 */
+IPA_REG_FIELDS(LOCAL_PKT_PROC_CNTXT, local_pkt_proc_cntxt, 0x000001e8);
+
+/* Valid bits defined by ipa->available */
+IPA_REG_STRIDE(AGGR_FORCE_CLOSE, aggr_force_close, 0x000001ec, 0x0004);
+
+static const u32 ipa_reg_ipa_tx_cfg_fmask[] = {
+						/* Bits 0-1 reserved */
+	[PREFETCH_ALMOST_EMPTY_SIZE_TX0]		= GENMASK(5, 2),
+	[DMAW_SCND_OUTSD_PRED_THRESHOLD]		= GENMASK(9, 6),
+	[DMAW_SCND_OUTSD_PRED_EN]			= BIT(10),
+	[DMAW_MAX_BEATS_256_DIS]			= BIT(11),
+	[PA_MASK_EN]					= BIT(12),
+	[PREFETCH_ALMOST_EMPTY_SIZE_TX1]		= GENMASK(16, 13),
+	[DUAL_TX_ENABLE]				= BIT(17),
+	[SSPND_PA_NO_START_STATE]			= BIT(18),
+						/* Bits 19-31 reserved */
+};
+
+IPA_REG_FIELDS(IPA_TX_CFG, ipa_tx_cfg, 0x000001fc);
+
+static const u32 ipa_reg_flavor_0_fmask[] = {
+	[MAX_PIPES]					= GENMASK(3, 0),
+						/* Bits 4-7 reserved */
+	[MAX_CONS_PIPES]				= GENMASK(12, 8),
+						/* Bits 13-15 reserved */
+	[MAX_PROD_PIPES]				= GENMASK(20, 16),
+						/* Bits 21-23 reserved */
+	[PROD_LOWEST]					= GENMASK(27, 24),
+						/* Bits 28-31 reserved */
+};
+
+IPA_REG_FIELDS(FLAVOR_0, flavor_0, 0x00000210);
+
+static const u32 ipa_reg_idle_indication_cfg_fmask[] = {
+	[ENTER_IDLE_DEBOUNCE_THRESH]			= GENMASK(15, 0),
+	[CONST_NON_IDLE_ENABLE]				= BIT(16),
+						/* Bits 17-31 reserved */
+};
+
+IPA_REG_FIELDS(IDLE_INDICATION_CFG, idle_indication_cfg, 0x00000240);
+
+static const u32 ipa_reg_qtime_timestamp_cfg_fmask[] = {
+	[DPL_TIMESTAMP_LSB]				= GENMASK(4, 0),
+						/* Bits 5-6 reserved */
+	[DPL_TIMESTAMP_SEL]				= BIT(7),
+	[TAG_TIMESTAMP_LSB]				= GENMASK(12, 8),
+						/* Bits 13-15 reserved */
+	[NAT_TIMESTAMP_LSB]				= GENMASK(20, 16),
+						/* Bits 21-31 reserved */
+};
+
+IPA_REG_FIELDS(QTIME_TIMESTAMP_CFG, qtime_timestamp_cfg, 0x0000024c);
+
+static const u32 ipa_reg_timers_xo_clk_div_cfg_fmask[] = {
+	[DIV_VALUE]					= GENMASK(8, 0),
+						/* Bits 9-30 reserved */
+	[DIV_ENABLE]					= BIT(31),
+};
+
+IPA_REG_FIELDS(TIMERS_XO_CLK_DIV_CFG, timers_xo_clk_div_cfg, 0x00000250);
+
+static const u32 ipa_reg_timers_pulse_gran_cfg_fmask[] = {
+	[PULSE_GRAN_0]					= GENMASK(2, 0),
+	[PULSE_GRAN_1]					= GENMASK(5, 3),
+	[PULSE_GRAN_2]					= GENMASK(8, 6),
+};
+
+IPA_REG_FIELDS(TIMERS_PULSE_GRAN_CFG, timers_pulse_gran_cfg, 0x00000254);
+
+static const u32 ipa_reg_src_rsrc_grp_01_rsrc_type_fmask[] = {
+	[X_MIN_LIM]					= GENMASK(5, 0),
+						/* Bits 6-7 reserved */
+	[X_MAX_LIM]					= GENMASK(13, 8),
+						/* Bits 14-15 reserved */
+	[Y_MIN_LIM]					= GENMASK(21, 16),
+						/* Bits 22-23 reserved */
+	[Y_MAX_LIM]					= GENMASK(29, 24),
+						/* Bits 30-31 reserved */
+};
+
+IPA_REG_STRIDE_FIELDS(SRC_RSRC_GRP_01_RSRC_TYPE, src_rsrc_grp_01_rsrc_type,
+		      0x00000400, 0x0020);
+
+static const u32 ipa_reg_src_rsrc_grp_23_rsrc_type_fmask[] = {
+	[X_MIN_LIM]					= GENMASK(5, 0),
+						/* Bits 6-7 reserved */
+	[X_MAX_LIM]					= GENMASK(13, 8),
+						/* Bits 14-15 reserved */
+	[Y_MIN_LIM]					= GENMASK(21, 16),
+						/* Bits 22-23 reserved */
+	[Y_MAX_LIM]					= GENMASK(29, 24),
+						/* Bits 30-31 reserved */
+};
+
+IPA_REG_STRIDE_FIELDS(SRC_RSRC_GRP_23_RSRC_TYPE, src_rsrc_grp_23_rsrc_type,
+		      0x00000404, 0x0020);
+
+static const u32 ipa_reg_dst_rsrc_grp_01_rsrc_type_fmask[] = {
+	[X_MIN_LIM]					= GENMASK(5, 0),
+						/* Bits 6-7 reserved */
+	[X_MAX_LIM]					= GENMASK(13, 8),
+						/* Bits 14-15 reserved */
+	[Y_MIN_LIM]					= GENMASK(21, 16),
+						/* Bits 22-23 reserved */
+	[Y_MAX_LIM]					= GENMASK(29, 24),
+						/* Bits 30-31 reserved */
+};
+
+IPA_REG_STRIDE_FIELDS(DST_RSRC_GRP_01_RSRC_TYPE, dst_rsrc_grp_01_rsrc_type,
+		      0x00000500, 0x0020);
+
+static const u32 ipa_reg_dst_rsrc_grp_23_rsrc_type_fmask[] = {
+	[X_MIN_LIM]					= GENMASK(5, 0),
+						/* Bits 6-7 reserved */
+	[X_MAX_LIM]					= GENMASK(13, 8),
+						/* Bits 14-15 reserved */
+	[Y_MIN_LIM]					= GENMASK(21, 16),
+						/* Bits 22-23 reserved */
+	[Y_MAX_LIM]					= GENMASK(29, 24),
+						/* Bits 30-31 reserved */
+};
+
+IPA_REG_STRIDE_FIELDS(DST_RSRC_GRP_23_RSRC_TYPE, dst_rsrc_grp_23_rsrc_type,
+		      0x00000504, 0x0020);
+
+static const u32 ipa_reg_endp_init_cfg_fmask[] = {
+	[FRAG_OFFLOAD_EN]				= BIT(0),
+	[CS_OFFLOAD_EN]					= GENMASK(2, 1),
+	[CS_METADATA_HDR_OFFSET]			= GENMASK(6, 3),
+						/* Bit 7 reserved */
+	[CS_GEN_QMB_MASTER_SEL]				= BIT(8),
+						/* Bits 9-31 reserved */
+};
+
+IPA_REG_STRIDE_FIELDS(ENDP_INIT_CFG, endp_init_cfg, 0x00000808, 0x0070);
+
+static const u32 ipa_reg_endp_init_nat_fmask[] = {
+	[NAT_EN]					= GENMASK(1, 0),
+						/* Bits 2-31 reserved */
+};
+
+IPA_REG_STRIDE_FIELDS(ENDP_INIT_NAT, endp_init_nat, 0x0000080c, 0x0070);
+
+static const u32 ipa_reg_endp_init_hdr_fmask[] = {
+	[HDR_LEN]					= GENMASK(5, 0),
+	[HDR_OFST_METADATA_VALID]			= BIT(6),
+	[HDR_OFST_METADATA]				= GENMASK(12, 7),
+	[HDR_ADDITIONAL_CONST_LEN]			= GENMASK(18, 13),
+	[HDR_OFST_PKT_SIZE_VALID]			= BIT(19),
+	[HDR_OFST_PKT_SIZE]				= GENMASK(25, 20),
+	[HDR_A5_MUX]					= BIT(26),
+	[HDR_LEN_INC_DEAGG_HDR]				= BIT(27),
+	[HDR_LEN_MSB]					= GENMASK(29, 28),
+	[HDR_OFST_METADATA_MSB]				= GENMASK(31, 30),
+};
+
+IPA_REG_STRIDE_FIELDS(ENDP_INIT_HDR, endp_init_hdr, 0x00000810, 0x0070);
+
+static const u32 ipa_reg_endp_init_hdr_ext_fmask[] = {
+	[HDR_ENDIANNESS]				= BIT(0),
+	[HDR_TOTAL_LEN_OR_PAD_VALID]			= BIT(1),
+	[HDR_TOTAL_LEN_OR_PAD]				= BIT(2),
+	[HDR_PAYLOAD_LEN_INC_PADDING]			= BIT(3),
+	[HDR_TOTAL_LEN_OR_PAD_OFFSET]			= GENMASK(9, 4),
+	[HDR_PAD_TO_ALIGNMENT]				= GENMASK(13, 10),
+						/* Bits 14-15 reserved */
+	[HDR_TOTAL_LEN_OR_PAD_OFFSET_MSB]		= GENMASK(17, 16),
+	[HDR_OFST_PKT_SIZE_MSB]				= GENMASK(19, 18),
+	[HDR_ADDITIONAL_CONST_LEN_MSB]			= GENMASK(21, 20),
+						/* Bits 22-31 reserved */
+};
+
+IPA_REG_STRIDE_FIELDS(ENDP_INIT_HDR_EXT, endp_init_hdr_ext, 0x00000814, 0x0070);
+
+IPA_REG_STRIDE(ENDP_INIT_HDR_METADATA_MASK, endp_init_hdr_metadata_mask,
+	       0x00000818, 0x0070);
+
+static const u32 ipa_reg_endp_init_mode_fmask[] = {
+	[ENDP_MODE]					= GENMASK(2, 0),
+	[DCPH_ENABLE]					= BIT(3),
+	[DEST_PIPE_INDEX]				= GENMASK(8, 4),
+						/* Bits 9-11 reserved */
+	[BYTE_THRESHOLD]				= GENMASK(27, 12),
+	[PIPE_REPLICATION_EN]				= BIT(28),
+	[PAD_EN]					= BIT(29),
+						/* Bits 30-31 reserved */
+};
+
+IPA_REG_STRIDE_FIELDS(ENDP_INIT_MODE, endp_init_mode, 0x00000820, 0x0070);
+
+static const u32 ipa_reg_endp_init_aggr_fmask[] = {
+	[AGGR_EN]					= GENMASK(1, 0),
+	[AGGR_TYPE]					= GENMASK(4, 2),
+	[BYTE_LIMIT]					= GENMASK(10, 5),
+						/* Bit 11 reserved */
+	[TIME_LIMIT]					= GENMASK(16, 12),
+	[PKT_LIMIT]					= GENMASK(22, 17),
+	[SW_EOF_ACTIVE]					= BIT(23),
+	[FORCE_CLOSE]					= BIT(24),
+						/* Bit 25 reserved */
+	[HARD_BYTE_LIMIT_EN]				= BIT(26),
+	[AGGR_GRAN_SEL]					= BIT(27),
+						/* Bits 28-31 reserved */
+};
+
+IPA_REG_STRIDE_FIELDS(ENDP_INIT_AGGR, endp_init_aggr, 0x00000824, 0x0070);
+
+static const u32 ipa_reg_endp_init_hol_block_en_fmask[] = {
+	[HOL_BLOCK_EN]					= BIT(0),
+						/* Bits 1-31 reserved */
+};
+
+IPA_REG_STRIDE_FIELDS(ENDP_INIT_HOL_BLOCK_EN, endp_init_hol_block_en,
+		      0x0000082c, 0x0070);
+
+static const u32 ipa_reg_endp_init_hol_block_timer_fmask[] = {
+	[TIMER_LIMIT]					= GENMASK(4, 0),
+						/* Bits 5-7 reserved */
+	[TIMER_GRAN_SEL]				= BIT(8),
+						/* Bits 9-31 reserved */
+};
+
+IPA_REG_STRIDE_FIELDS(ENDP_INIT_HOL_BLOCK_TIMER, endp_init_hol_block_timer,
+		      0x00000830, 0x0070);
+
+static const u32 ipa_reg_endp_init_deaggr_fmask[] = {
+	[DEAGGR_HDR_LEN]				= GENMASK(5, 0),
+	[SYSPIPE_ERR_DETECTION]				= BIT(6),
+	[PACKET_OFFSET_VALID]				= BIT(7),
+	[PACKET_OFFSET_LOCATION]			= GENMASK(13, 8),
+	[IGNORE_MIN_PKT_ERR]				= BIT(14),
+						/* Bit 15 reserved */
+	[MAX_PACKET_LEN]				= GENMASK(31, 16),
+};
+
+IPA_REG_STRIDE_FIELDS(ENDP_INIT_DEAGGR, endp_init_deaggr, 0x00000834, 0x0070);
+
+static const u32 ipa_reg_endp_init_rsrc_grp_fmask[] = {
+	[ENDP_RSRC_GRP]					= BIT(0),
+						/* Bits 1-31 reserved */
+};
+
+IPA_REG_STRIDE_FIELDS(ENDP_INIT_RSRC_GRP, endp_init_rsrc_grp,
+		      0x00000838, 0x0070);
+
+static const u32 ipa_reg_endp_init_seq_fmask[] = {
+	[SEQ_TYPE]					= GENMASK(7, 0),
+						/* Bits 8-31 reserved */
+};
+
+IPA_REG_STRIDE_FIELDS(ENDP_INIT_SEQ, endp_init_seq, 0x0000083c, 0x0070);
+
+static const u32 ipa_reg_endp_status_fmask[] = {
+	[STATUS_EN]					= BIT(0),
+	[STATUS_ENDP]					= GENMASK(5, 1),
+						/* Bits 6-8 reserved */
+	[STATUS_PKT_SUPPRESS]				= BIT(9),
+						/* Bits 10-31 reserved */
+};
+
+IPA_REG_STRIDE_FIELDS(ENDP_STATUS, endp_status, 0x00000840, 0x0070);
+
+static const u32 ipa_reg_endp_filter_router_hsh_cfg_fmask[] = {
+	[FILTER_HASH_MSK_SRC_ID]			= BIT(0),
+	[FILTER_HASH_MSK_SRC_IP]			= BIT(1),
+	[FILTER_HASH_MSK_DST_IP]			= BIT(2),
+	[FILTER_HASH_MSK_SRC_PORT]			= BIT(3),
+	[FILTER_HASH_MSK_DST_PORT]			= BIT(4),
+	[FILTER_HASH_MSK_PROTOCOL]			= BIT(5),
+	[FILTER_HASH_MSK_METADATA]			= BIT(6),
+	[FILTER_HASH_MSK_ALL]				= GENMASK(6, 0),
+						/* Bits 7-15 reserved */
+	[ROUTER_HASH_MSK_SRC_ID]			= BIT(16),
+	[ROUTER_HASH_MSK_SRC_IP]			= BIT(17),
+	[ROUTER_HASH_MSK_DST_IP]			= BIT(18),
+	[ROUTER_HASH_MSK_SRC_PORT]			= BIT(19),
+	[ROUTER_HASH_MSK_DST_PORT]			= BIT(20),
+	[ROUTER_HASH_MSK_PROTOCOL]			= BIT(21),
+	[ROUTER_HASH_MSK_METADATA]			= BIT(22),
+	[ROUTER_HASH_MSK_ALL]				= GENMASK(22, 16),
+						/* Bits 23-31 reserved */
+};
+
+IPA_REG_STRIDE_FIELDS(ENDP_FILTER_ROUTER_HSH_CFG, endp_filter_router_hsh_cfg,
+		      0x0000085c, 0x0070);
+
+/* Valid bits defined by enum ipa_irq_id; only used for GSI_EE_AP */
+IPA_REG(IPA_IRQ_STTS, ipa_irq_stts, 0x00003008 + 0x1000 * GSI_EE_AP);
+
+/* Valid bits defined by enum ipa_irq_id; only used for GSI_EE_AP */
+IPA_REG(IPA_IRQ_EN, ipa_irq_en, 0x0000300c + 0x1000 * GSI_EE_AP);
+
+/* Valid bits defined by enum ipa_irq_id; only used for GSI_EE_AP */
+IPA_REG(IPA_IRQ_CLR, ipa_irq_clr, 0x00003010 + 0x1000 * GSI_EE_AP);
+
+static const u32 ipa_reg_ipa_irq_uc_fmask[] = {
+	[UC_INTR]					= BIT(0),
+						/* Bits 1-31 reserved */
+};
+
+IPA_REG_FIELDS(IPA_IRQ_UC, ipa_irq_uc, 0x0000301c + 0x1000 * GSI_EE_AP);
+
+/* Valid bits defined by ipa->available */
+IPA_REG_STRIDE(IRQ_SUSPEND_INFO, irq_suspend_info,
+	       0x00003030 + 0x1000 * GSI_EE_AP, 0x0004);
+
+/* Valid bits defined by ipa->available */
+IPA_REG_STRIDE(IRQ_SUSPEND_EN, irq_suspend_en,
+	       0x00003034 + 0x1000 * GSI_EE_AP, 0x0004);
+
+/* Valid bits defined by ipa->available */
+IPA_REG_STRIDE(IRQ_SUSPEND_CLR, irq_suspend_clr,
+	       0x00003038 + 0x1000 * GSI_EE_AP, 0x0004);
+
+static const struct ipa_reg *ipa_reg_array[] = {
+	[COMP_CFG]			= &ipa_reg_comp_cfg,
+	[CLKON_CFG]			= &ipa_reg_clkon_cfg,
+	[ROUTE]				= &ipa_reg_route,
+	[SHARED_MEM_SIZE]		= &ipa_reg_shared_mem_size,
+	[QSB_MAX_WRITES]		= &ipa_reg_qsb_max_writes,
+	[QSB_MAX_READS]			= &ipa_reg_qsb_max_reads,
+	[FILT_ROUT_HASH_EN]		= &ipa_reg_filt_rout_hash_en,
+	[FILT_ROUT_HASH_FLUSH]		= &ipa_reg_filt_rout_hash_flush,
+	[STATE_AGGR_ACTIVE]		= &ipa_reg_state_aggr_active,
+	[LOCAL_PKT_PROC_CNTXT]		= &ipa_reg_local_pkt_proc_cntxt,
+	[AGGR_FORCE_CLOSE]		= &ipa_reg_aggr_force_close,
+	[IPA_TX_CFG]			= &ipa_reg_ipa_tx_cfg,
+	[FLAVOR_0]			= &ipa_reg_flavor_0,
+	[IDLE_INDICATION_CFG]		= &ipa_reg_idle_indication_cfg,
+	[QTIME_TIMESTAMP_CFG]		= &ipa_reg_qtime_timestamp_cfg,
+	[TIMERS_XO_CLK_DIV_CFG]		= &ipa_reg_timers_xo_clk_div_cfg,
+	[TIMERS_PULSE_GRAN_CFG]		= &ipa_reg_timers_pulse_gran_cfg,
+	[SRC_RSRC_GRP_01_RSRC_TYPE]	= &ipa_reg_src_rsrc_grp_01_rsrc_type,
+	[SRC_RSRC_GRP_23_RSRC_TYPE]	= &ipa_reg_src_rsrc_grp_23_rsrc_type,
+	[DST_RSRC_GRP_01_RSRC_TYPE]	= &ipa_reg_dst_rsrc_grp_01_rsrc_type,
+	[DST_RSRC_GRP_23_RSRC_TYPE]	= &ipa_reg_dst_rsrc_grp_23_rsrc_type,
+	[ENDP_INIT_CFG]			= &ipa_reg_endp_init_cfg,
+	[ENDP_INIT_NAT]			= &ipa_reg_endp_init_nat,
+	[ENDP_INIT_HDR]			= &ipa_reg_endp_init_hdr,
+	[ENDP_INIT_HDR_EXT]		= &ipa_reg_endp_init_hdr_ext,
+	[ENDP_INIT_HDR_METADATA_MASK]	= &ipa_reg_endp_init_hdr_metadata_mask,
+	[ENDP_INIT_MODE]		= &ipa_reg_endp_init_mode,
+	[ENDP_INIT_AGGR]		= &ipa_reg_endp_init_aggr,
+	[ENDP_INIT_HOL_BLOCK_EN]	= &ipa_reg_endp_init_hol_block_en,
+	[ENDP_INIT_HOL_BLOCK_TIMER]	= &ipa_reg_endp_init_hol_block_timer,
+	[ENDP_INIT_DEAGGR]		= &ipa_reg_endp_init_deaggr,
+	[ENDP_INIT_RSRC_GRP]		= &ipa_reg_endp_init_rsrc_grp,
+	[ENDP_INIT_SEQ]			= &ipa_reg_endp_init_seq,
+	[ENDP_STATUS]			= &ipa_reg_endp_status,
+	[ENDP_FILTER_ROUTER_HSH_CFG]	= &ipa_reg_endp_filter_router_hsh_cfg,
+	[IPA_IRQ_STTS]			= &ipa_reg_ipa_irq_stts,
+	[IPA_IRQ_EN]			= &ipa_reg_ipa_irq_en,
+	[IPA_IRQ_CLR]			= &ipa_reg_ipa_irq_clr,
+	[IPA_IRQ_UC]			= &ipa_reg_ipa_irq_uc,
+	[IRQ_SUSPEND_INFO]		= &ipa_reg_irq_suspend_info,
+	[IRQ_SUSPEND_EN]		= &ipa_reg_irq_suspend_en,
+	[IRQ_SUSPEND_CLR]		= &ipa_reg_irq_suspend_clr,
+};
+
+const struct ipa_regs ipa_regs_v4_7 = {
+	.reg_count	= ARRAY_SIZE(ipa_reg_array),
+	.reg		= ipa_reg_array,
+};
-- 
2.34.1

