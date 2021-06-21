Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 246763AF4BD
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 20:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232628AbhFUSSE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 14:18:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231740AbhFUSRM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 14:17:12 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EF9FC061226
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 10:56:37 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id b5so4129297ilc.12
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 10:56:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FsAurCoNFFJayoeiLx6rofwwsjk1qR9gtCLQMlN5NdA=;
        b=zduiZR3a2hwthG/uvXbBl1BwtfLILzjgki15moIehapr9EevwYAR1UjWWK1MZVWUtq
         sETdu4l0qi05VoaeOMoyf9USVSjgUu+WzLfqxDNlnCsBF8fsC0EFEIXAJT3CJifhvlsE
         zNDJFuR7MyPBjiFivnHg7JgE+boLglIzoQ8WIxe1sKMAsP4ei66zOObXqM2XYENB8gQi
         JRTSkIBd+E8dmFKORIQA3MN1qMhlDIgDEjKxTM24E5hsPjMYDuqtTTlt0e658ncIK5Cy
         +1VKeomToQNCj35KnWbQyTtTPptIqi72U7hkSN4b6SIH8X1A8Uu2m8BabRHfB40OeNYI
         OnOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FsAurCoNFFJayoeiLx6rofwwsjk1qR9gtCLQMlN5NdA=;
        b=LTFjxg9PWuhEz8fG2ajKONdj+rdOWcXAvLTtJg+v5qYFwj5+z/lA/+4LLtmx+NeRI0
         FmQWd940HA3Y4QL0kT1pDlpCz7ydMYALdjjwCOB3rXofUUchEGMNC9n+m5gIotJU2wL5
         VzdpOtEIBo5Ej6nnbxjp/LQz3i6E3UbcTGljwPWuVdmIML4ZNkyCAplw7+JdwT/wqE1r
         4aM30oNatqdn2UFSAjNtGBZ9gp5BWCDjChApeYhQdI8J5sli1tU8M2lXD8UqDDl/nykq
         MT57ePa5hV3/GsA0jxcC09tXtnIQgAapCHtv3FvY/KQpetBqspBM89naL2VariaZ7AYv
         JZ2A==
X-Gm-Message-State: AOAM530W794miBIL/PDbubOB8PnvPdQC2gkbjrhauPnUXFWC6+77omrG
        WKnZg6ED4WrxpX5UqahcGa72rYZNNplMUg==
X-Google-Smtp-Source: ABdhPJxTcQ+Uh6wh8PPbLoBUVdYH1ICynPtmdNPXywY9Mtj87L3QAbWs5vXv6WFEa6rgWrxlyz0Jaw==
X-Received: by 2002:a05:6e02:1be1:: with SMTP id y1mr19727287ilv.204.1624298196914;
        Mon, 21 Jun 2021 10:56:36 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id m13sm6259264iob.35.2021.06.21.10.56.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 10:56:36 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     robh+dt@kernel.org, angelogioacchino.delregno@somainline.org,
        jamipkettunen@gmail.com, bjorn.andersson@linaro.org,
        agross@kernel.org, elder@kernel.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 6/6] net: ipa: add IPA v3.1 configuration data
Date:   Mon, 21 Jun 2021 12:56:27 -0500
Message-Id: <20210621175627.238474-7-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210621175627.238474-1-elder@linaro.org>
References: <20210621175627.238474-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for the MSM8998 SoC, which includes IPA version 3.1.

Originally proposed by AngeloGioacchino Del Regno.

Link: https://lore.kernel.org/netdev/20210211175015.200772-6-angelogioacchino.delregno@somainline.org
Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/Makefile        |   6 +-
 drivers/net/ipa/ipa_data-v3.1.c | 533 ++++++++++++++++++++++++++++++++
 drivers/net/ipa/ipa_data.h      |   1 +
 drivers/net/ipa/ipa_main.c      |   4 +
 4 files changed, 541 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/ipa/ipa_data-v3.1.c

diff --git a/drivers/net/ipa/Makefile b/drivers/net/ipa/Makefile
index bd34fce8f6e63..506f8d5cd4eeb 100644
--- a/drivers/net/ipa/Makefile
+++ b/drivers/net/ipa/Makefile
@@ -10,6 +10,6 @@ ipa-y			:=	ipa_main.o ipa_clock.o ipa_reg.o ipa_mem.o \
 				ipa_resource.o ipa_qmi.o ipa_qmi_msg.o \
 				ipa_sysfs.o
 
-ipa-y			+=	ipa_data-v3.5.1.o ipa_data-v4.2.o \
-				ipa_data-v4.5.o ipa_data-v4.9.o \
-				ipa_data-v4.11.o
+ipa-y			+=	ipa_data-v3.1.o ipa_data-v3.5.1.o \
+				ipa_data-v4.2.o ipa_data-v4.5.o \
+				ipa_data-v4.9.o ipa_data-v4.11.o
diff --git a/drivers/net/ipa/ipa_data-v3.1.c b/drivers/net/ipa/ipa_data-v3.1.c
new file mode 100644
index 0000000000000..4c28189462a70
--- /dev/null
+++ b/drivers/net/ipa/ipa_data-v3.1.c
@@ -0,0 +1,533 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
+ * Copyright (C) 2019-2021 Linaro Ltd.
+ */
+
+#include <linux/log2.h>
+
+#include "gsi.h"
+#include "ipa_data.h"
+#include "ipa_endpoint.h"
+#include "ipa_mem.h"
+
+/** enum ipa_resource_type - IPA resource types for an SoC having IPA v3.1 */
+enum ipa_resource_type {
+	/* Source resource types; first must have value 0 */
+	IPA_RESOURCE_TYPE_SRC_PKT_CONTEXTS		= 0,
+	IPA_RESOURCE_TYPE_SRC_HDR_SECTORS,
+	IPA_RESOURCE_TYPE_SRC_HDRI1_BUFFER,
+	IPA_RESOURCE_TYPE_SRC_DESCRIPTOR_LISTS,
+	IPA_RESOURCE_TYPE_SRC_DESCRIPTOR_BUFF,
+	IPA_RESOURCE_TYPE_SRC_HDRI2_BUFFERS,
+	IPA_RESOURCE_TYPE_SRC_HPS_DMARS,
+	IPA_RESOURCE_TYPE_SRC_ACK_ENTRIES,
+
+	/* Destination resource types; first must have value 0 */
+	IPA_RESOURCE_TYPE_DST_DATA_SECTORS		= 0,
+	IPA_RESOURCE_TYPE_DST_DATA_SECTOR_LISTS,
+	IPA_RESOURCE_TYPE_DST_DPS_DMARS,
+};
+
+/* Resource groups used for an SoC having IPA v3.1 */
+enum ipa_rsrc_group_id {
+	/* Source resource group identifiers */
+	IPA_RSRC_GROUP_SRC_UL		= 0,
+	IPA_RSRC_GROUP_SRC_DL,
+	IPA_RSRC_GROUP_SRC_DIAG,
+	IPA_RSRC_GROUP_SRC_DMA,
+	IPA_RSRC_GROUP_SRC_UNUSED,
+	IPA_RSRC_GROUP_SRC_UC_RX_Q,
+	IPA_RSRC_GROUP_SRC_COUNT,	/* Last in set; not a source group */
+
+	/* Destination resource group identifiers */
+	IPA_RSRC_GROUP_DST_UL		= 0,
+	IPA_RSRC_GROUP_DST_DL,
+	IPA_RSRC_GROUP_DST_DIAG_DPL,
+	IPA_RSRC_GROUP_DST_DMA,
+	IPA_RSRC_GROUP_DST_Q6ZIP_GENERAL,
+	IPA_RSRC_GROUP_DST_Q6ZIP_ENGINE,
+	IPA_RSRC_GROUP_DST_COUNT,	/* Last; not a destination group */
+};
+
+/* QSB configuration data for an SoC having IPA v3.1 */
+static const struct ipa_qsb_data ipa_qsb_data[] = {
+	[IPA_QSB_MASTER_DDR] = {
+		.max_writes	= 8,
+		.max_reads	= 8,
+	},
+	[IPA_QSB_MASTER_PCIE] = {
+		.max_writes	= 2,
+		.max_reads	= 8,
+	},
+};
+
+/* Endpoint data for an SoC having IPA v3.1 */
+static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
+	[IPA_ENDPOINT_AP_COMMAND_TX] = {
+		.ee_id		= GSI_EE_AP,
+		.channel_id	= 6,
+		.endpoint_id	= 22,
+		.toward_ipa	= true,
+		.channel = {
+			.tre_count	= 256,
+			.event_count	= 256,
+			.tlv_count	= 18,
+		},
+		.endpoint = {
+			.config = {
+				.resource_group	= IPA_RSRC_GROUP_SRC_UL,
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
+		.channel_id	= 7,
+		.endpoint_id	= 15,
+		.toward_ipa	= false,
+		.channel = {
+			.tre_count	= 256,
+			.event_count	= 256,
+			.tlv_count	= 8,
+		},
+		.endpoint = {
+			.config = {
+				.resource_group	= IPA_RSRC_GROUP_SRC_UL,
+				.aggregation	= true,
+				.status_enable	= true,
+				.rx = {
+					.pad_align	= ilog2(sizeof(u32)),
+				},
+			},
+		},
+	},
+	[IPA_ENDPOINT_AP_MODEM_TX] = {
+		.ee_id		= GSI_EE_AP,
+		.channel_id	= 5,
+		.endpoint_id	= 3,
+		.toward_ipa	= true,
+		.channel = {
+			.tre_count	= 512,
+			.event_count	= 512,
+			.tlv_count	= 16,
+		},
+		.endpoint = {
+			.filter_support	= true,
+			.config = {
+				.resource_group	= IPA_RSRC_GROUP_SRC_UL,
+				.checksum	= true,
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
+		.channel_id	= 8,
+		.endpoint_id	= 16,
+		.toward_ipa	= false,
+		.channel = {
+			.tre_count	= 256,
+			.event_count	= 256,
+			.tlv_count	= 8,
+		},
+		.endpoint = {
+			.config = {
+				.resource_group	= IPA_RSRC_GROUP_DST_DL,
+				.checksum	= true,
+				.qmap		= true,
+				.aggregation	= true,
+				.rx = {
+					.aggr_close_eof	= true,
+				},
+			},
+		},
+	},
+	[IPA_ENDPOINT_MODEM_LAN_TX] = {
+		.ee_id		= GSI_EE_MODEM,
+		.channel_id	= 4,
+		.endpoint_id	= 9,
+		.toward_ipa	= true,
+		.endpoint = {
+			.filter_support	= true,
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
+		.channel_id	= 5,
+		.endpoint_id	= 18,
+		.toward_ipa	= false,
+	},
+};
+
+/* Source resource configuration data for an SoC having IPA v3.1 */
+static const struct ipa_resource ipa_resource_src[] = {
+	[IPA_RESOURCE_TYPE_SRC_PKT_CONTEXTS] = {
+		.limits[IPA_RSRC_GROUP_SRC_UL] = {
+			.min = 3,	.max = 255,
+		},
+		.limits[IPA_RSRC_GROUP_SRC_DL] = {
+			.min = 3,	.max = 255,
+		},
+		.limits[IPA_RSRC_GROUP_SRC_DIAG] = {
+			.min = 1,	.max = 255,
+		},
+		.limits[IPA_RSRC_GROUP_SRC_DMA] = {
+			.min = 1,	.max = 255,
+		},
+		.limits[IPA_RSRC_GROUP_SRC_UC_RX_Q] = {
+			.min = 2,	.max = 255,
+		},
+	},
+	[IPA_RESOURCE_TYPE_SRC_HDR_SECTORS] = {
+		.limits[IPA_RSRC_GROUP_SRC_UL] = {
+			.min = 0,	.max = 255,
+		},
+		.limits[IPA_RSRC_GROUP_SRC_DL] = {
+			.min = 0,	.max = 255,
+		},
+		.limits[IPA_RSRC_GROUP_SRC_DIAG] = {
+			.min = 0,	.max = 255,
+		},
+		.limits[IPA_RSRC_GROUP_SRC_DMA] = {
+			.min = 0,	.max = 255,
+		},
+		.limits[IPA_RSRC_GROUP_SRC_UC_RX_Q] = {
+			.min = 0,	.max = 255,
+		},
+	},
+	[IPA_RESOURCE_TYPE_SRC_HDRI1_BUFFER] = {
+		.limits[IPA_RSRC_GROUP_SRC_UL] = {
+			.min = 0,	.max = 255,
+		},
+		.limits[IPA_RSRC_GROUP_SRC_DL] = {
+			.min = 0,	.max = 255,
+		},
+		.limits[IPA_RSRC_GROUP_SRC_DIAG] = {
+			.min = 0,	.max = 255,
+		},
+		.limits[IPA_RSRC_GROUP_SRC_DMA] = {
+			.min = 0,	.max = 255,
+		},
+		.limits[IPA_RSRC_GROUP_SRC_UC_RX_Q] = {
+			.min = 0,	.max = 255,
+		},
+	},
+	[IPA_RESOURCE_TYPE_SRC_DESCRIPTOR_LISTS] = {
+		.limits[IPA_RSRC_GROUP_SRC_UL] = {
+			.min = 14,	.max = 14,
+		},
+		.limits[IPA_RSRC_GROUP_SRC_DL] = {
+			.min = 16,	.max = 16,
+		},
+		.limits[IPA_RSRC_GROUP_SRC_DIAG] = {
+			.min = 5,	.max = 5,
+		},
+		.limits[IPA_RSRC_GROUP_SRC_DMA] = {
+			.min = 5,	.max = 5,
+		},
+		.limits[IPA_RSRC_GROUP_SRC_UC_RX_Q] = {
+			.min = 8,	.max = 8,
+		},
+	},
+	[IPA_RESOURCE_TYPE_SRC_DESCRIPTOR_BUFF] = {
+		.limits[IPA_RSRC_GROUP_SRC_UL] = {
+			.min = 19,	.max = 19,
+		},
+		.limits[IPA_RSRC_GROUP_SRC_DL] = {
+			.min = 26,	.max = 26,
+		},
+		.limits[IPA_RSRC_GROUP_SRC_DIAG] = {
+			.min = 5,	.max = 5,	/* 3 downstream */
+		},
+		.limits[IPA_RSRC_GROUP_SRC_DMA] = {
+			.min = 5,	.max = 5,	/* 7 downstream */
+		},
+		.limits[IPA_RSRC_GROUP_SRC_UC_RX_Q] = {
+			.min = 8,	.max = 8,
+		},
+	},
+	[IPA_RESOURCE_TYPE_SRC_HDRI2_BUFFERS] = {
+		.limits[IPA_RSRC_GROUP_SRC_UL] = {
+			.min = 0,	.max = 255,
+		},
+		.limits[IPA_RSRC_GROUP_SRC_DL] = {
+			.min = 0,	.max = 255,
+		},
+		.limits[IPA_RSRC_GROUP_SRC_DIAG] = {
+			.min = 0,	.max = 255,
+		},
+		.limits[IPA_RSRC_GROUP_SRC_DMA] = {
+			.min = 0,	.max = 255,
+		},
+		.limits[IPA_RSRC_GROUP_SRC_UC_RX_Q] = {
+			.min = 0,	.max = 255,
+		},
+	},
+	[IPA_RESOURCE_TYPE_SRC_HPS_DMARS] = {
+		.limits[IPA_RSRC_GROUP_SRC_UL] = {
+			.min = 0,	.max = 255,
+		},
+		.limits[IPA_RSRC_GROUP_SRC_DL] = {
+			.min = 0,	.max = 255,
+		},
+		.limits[IPA_RSRC_GROUP_SRC_DIAG] = {
+			.min = 0,	.max = 255,
+		},
+		.limits[IPA_RSRC_GROUP_SRC_DMA] = {
+			.min = 0,	.max = 255,
+		},
+		.limits[IPA_RSRC_GROUP_SRC_UC_RX_Q] = {
+			.min = 0,	.max = 255,
+		},
+	},
+	[IPA_RESOURCE_TYPE_SRC_ACK_ENTRIES] = {
+		.limits[IPA_RSRC_GROUP_SRC_UL] = {
+			.min = 19,	.max = 19,
+		},
+		.limits[IPA_RSRC_GROUP_SRC_DL] = {
+			.min = 26,	.max = 26,
+		},
+		.limits[IPA_RSRC_GROUP_SRC_DIAG] = {
+			.min = 5,	.max = 5,
+		},
+		.limits[IPA_RSRC_GROUP_SRC_DMA] = {
+			.min = 5,	.max = 5,
+		},
+		.limits[IPA_RSRC_GROUP_SRC_UC_RX_Q] = {
+			.min = 8,	.max = 8,
+		},
+	},
+};
+
+/* Destination resource configuration data for an SoC having IPA v3.1 */
+static const struct ipa_resource ipa_resource_dst[] = {
+	[IPA_RESOURCE_TYPE_DST_DATA_SECTORS] = {
+		.limits[IPA_RSRC_GROUP_DST_UL] = {
+			.min = 3,	.max = 3,	/* 2 downstream */
+		},
+		.limits[IPA_RSRC_GROUP_DST_DL] = {
+			.min = 3,	.max = 3,
+		},
+		.limits[IPA_RSRC_GROUP_DST_DIAG_DPL] = {
+			.min = 1,	.max = 1,	/* 0 downstream */
+		},
+		/* IPA_RSRC_GROUP_DST_DMA uses 2 downstream */
+		.limits[IPA_RSRC_GROUP_DST_Q6ZIP_GENERAL] = {
+			.min = 3,	.max = 3,
+		},
+		.limits[IPA_RSRC_GROUP_DST_Q6ZIP_ENGINE] = {
+			.min = 3,	.max = 3,
+		},
+	},
+	[IPA_RESOURCE_TYPE_DST_DATA_SECTOR_LISTS] = {
+		.limits[IPA_RSRC_GROUP_DST_UL] = {
+			.min = 0,	.max = 255,
+		},
+		.limits[IPA_RSRC_GROUP_DST_DL] = {
+			.min = 0,	.max = 255,
+		},
+		.limits[IPA_RSRC_GROUP_DST_DIAG_DPL] = {
+			.min = 0,	.max = 255,
+		},
+		.limits[IPA_RSRC_GROUP_DST_DMA] = {
+			.min = 0,	.max = 255,
+		},
+		.limits[IPA_RSRC_GROUP_DST_Q6ZIP_GENERAL] = {
+			.min = 0,	.max = 255,
+		},
+		.limits[IPA_RSRC_GROUP_DST_Q6ZIP_ENGINE] = {
+			.min = 0,	.max = 255,
+		},
+	},
+	[IPA_RESOURCE_TYPE_DST_DPS_DMARS] = {
+		.limits[IPA_RSRC_GROUP_DST_UL] = {
+			.min = 1,	.max = 1,
+		},
+		.limits[IPA_RSRC_GROUP_DST_DL] = {
+			.min = 1,	.max = 1,
+		},
+		.limits[IPA_RSRC_GROUP_DST_DIAG_DPL] = {
+			.min = 1,	.max = 1,
+		},
+		.limits[IPA_RSRC_GROUP_DST_DMA] = {
+			.min = 1,	.max = 1,
+		},
+		.limits[IPA_RSRC_GROUP_DST_Q6ZIP_GENERAL] = {
+			.min = 1,	.max = 1,
+		},
+	},
+};
+
+/* Resource configuration data for an SoC having IPA v3.1 */
+static const struct ipa_resource_data ipa_resource_data = {
+	.rsrc_group_src_count	= IPA_RSRC_GROUP_SRC_COUNT,
+	.rsrc_group_dst_count	= IPA_RSRC_GROUP_DST_COUNT,
+	.resource_src_count	= ARRAY_SIZE(ipa_resource_src),
+	.resource_src		= ipa_resource_src,
+	.resource_dst_count	= ARRAY_SIZE(ipa_resource_dst),
+	.resource_dst		= ipa_resource_dst,
+};
+
+/* IPA-resident memory region data for an SoC having IPA v3.1 */
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
+		.size		= 0x0140,
+		.canary_count	= 2,
+	},
+	{
+		.id		= IPA_MEM_MODEM_PROC_CTX,
+		.offset		= 0x07d0,
+		.size		= 0x0200,
+		.canary_count	= 2,
+	},
+	{
+		.id		= IPA_MEM_AP_PROC_CTX,
+		.offset		= 0x09d0,
+		.size		= 0x0200,
+		.canary_count	= 0,
+	},
+	{
+		.id		= IPA_MEM_MODEM,
+		.offset		= 0x0bd8,
+		.size		= 0x1424,
+		.canary_count	= 0,
+	},
+	{
+		.id		= IPA_MEM_END_MARKER,
+		.offset		= 0x2000,
+		.size		= 0,
+		.canary_count	= 1,
+	},
+};
+
+/* Memory configuration data for an SoC having IPA v3.1 */
+static const struct ipa_mem_data ipa_mem_data = {
+	.local_count	= ARRAY_SIZE(ipa_mem_local_data),
+	.local		= ipa_mem_local_data,
+	.imem_addr	= 0x146bd000,
+	.imem_size	= 0x00002000,
+	.smem_id	= 497,
+	.smem_size	= 0x00002000,
+};
+
+/* Interconnect bandwidths are in 1000 byte/second units */
+static const struct ipa_interconnect_data ipa_interconnect_data[] = {
+	{
+		.name			= "memory",
+		.peak_bandwidth		= 640000,	/* 640 MBps */
+		.average_bandwidth	= 80000,	/* 80 MBps */
+	},
+	{
+		.name			= "imem",
+		.peak_bandwidth		= 640000,	/* 640 MBps */
+		.average_bandwidth	= 80000,	/* 80 MBps */
+	},
+	/* Average bandwidth is unused for the next interconnect */
+	{
+		.name			= "config",
+		.peak_bandwidth		= 80000,	/* 80 MBps */
+		.average_bandwidth	= 0,		/* unused */
+	},
+};
+
+/* Clock and interconnect configuration data for an SoC having IPA v3.1 */
+static const struct ipa_clock_data ipa_clock_data = {
+	.core_clock_rate	= 16 * 1000 * 1000,	/* Hz */
+	.interconnect_count	= ARRAY_SIZE(ipa_interconnect_data),
+	.interconnect_data	= ipa_interconnect_data,
+};
+
+/* Configuration data for an SoC having IPA v3.1 */
+const struct ipa_data ipa_data_v3_1 = {
+	.version	= IPA_VERSION_3_1,
+	.backward_compat = BCR_CMDQ_L_LACK_ONE_ENTRY_FMASK,
+	.qsb_count	= ARRAY_SIZE(ipa_qsb_data),
+	.qsb_data	= ipa_qsb_data,
+	.endpoint_count	= ARRAY_SIZE(ipa_gsi_endpoint_data),
+	.endpoint_data	= ipa_gsi_endpoint_data,
+	.resource_data	= &ipa_resource_data,
+	.mem_data	= &ipa_mem_data,
+	.clock_data	= &ipa_clock_data,
+};
diff --git a/drivers/net/ipa/ipa_data.h b/drivers/net/ipa/ipa_data.h
index 5c4c8d72d7d87..5bc244c8f94e7 100644
--- a/drivers/net/ipa/ipa_data.h
+++ b/drivers/net/ipa/ipa_data.h
@@ -300,6 +300,7 @@ struct ipa_data {
 	const struct ipa_clock_data *clock_data;
 };
 
+extern const struct ipa_data ipa_data_v3_1;
 extern const struct ipa_data ipa_data_v3_5_1;
 extern const struct ipa_data ipa_data_v4_2;
 extern const struct ipa_data ipa_data_v4_5;
diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index 20a83c7f671f3..9810c61a03202 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -578,6 +578,10 @@ static int ipa_firmware_load(struct device *dev)
 }
 
 static const struct of_device_id ipa_match[] = {
+	{
+		.compatible	= "qcom,msm8998-ipa",
+		.data		= &ipa_data_v3_1,
+	},
 	{
 		.compatible	= "qcom,sdm845-ipa",
 		.data		= &ipa_data_v3_5_1,
-- 
2.27.0

