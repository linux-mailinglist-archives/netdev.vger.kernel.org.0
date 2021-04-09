Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9810F35A809
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 22:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234467AbhDIUk7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 16:40:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234453AbhDIUks (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 16:40:48 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CCC9C0613D7
        for <netdev@vger.kernel.org>; Fri,  9 Apr 2021 13:40:31 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id j26so7209620iog.13
        for <netdev@vger.kernel.org>; Fri, 09 Apr 2021 13:40:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Wk9T4KvvZdm3GpSfmWAgyvpP3nYfC5QTXghRHx/+Shs=;
        b=oEaCmV4LqGd4RLLQKouEay2ce2x9CThcg42oyfB/PHK7cvpg4FEhtEPn5gjLLMYWdP
         JbKv5XEfipQcMeX+NvNxq77Nh8AoOZ9sxrIlsHBbcHTU1lBpXGTGSQCAjX7N5pmjt7wZ
         AjTEl54NOiukJEFA4H5VO5KphwhEbIpe2moYHbpIuHrh0DrnbJbjijKEFCScNobj0iAv
         9JBAEGsa35v9DIMu9ynZpsKqAe2k8dDscoobP6qCjUuSjvoEfUCeNZWdiMtrR9114LJF
         bjNO3Skn0rtnNQXKI6Dq2J56gqL5YGJG4uBbpYHPJzzIOxP3InkzU9wjTwhub79TLnCa
         ewgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Wk9T4KvvZdm3GpSfmWAgyvpP3nYfC5QTXghRHx/+Shs=;
        b=LrxZRCdil9V6J9DS9bLZJtYkaUrnvVLkBhNjqPH8ZQav15b5+p0kGrhHmmeszRTxXn
         C/uRosH9s/p7sOwct/H79vKvJlUuc9eMJCLnHU8QN8o3bs1LEoA9JzYrSbehZ1m3OG/E
         fKgkvBr1suuy2X8Pevv24wFqdipwfcnk1QDfJ91Pmantek7xa/tLwPm5BhpqOeSVw7Hm
         YptEg+5ja/Dz07wvmt64FQdANdKfL9kTgbSFy9pO7z9vjoJh7HNm6gIT+AhHAsOeNKjD
         NKsZPZT6z8HH5Knp2Ey3J1XKqbmHrkt33xqAlSFF3mHEivOVS2iNIlzq+L8XaDPO6kEQ
         adEA==
X-Gm-Message-State: AOAM532thkGFXe7irWkbK0j/4z513ezNybUZxzf7H0SC7rdgBnPfR+yy
        aZOBmWMqF1utejmhrGFxD6WFBg==
X-Google-Smtp-Source: ABdhPJz8pHvYV218s4YI+410qJqFe41z7hyt4B4SnyW5YiE05xCufXJT98T9FBLXi8Ln+I9PzxKZwA==
X-Received: by 2002:a02:a807:: with SMTP id f7mr14610243jaj.54.1618000830796;
        Fri, 09 Apr 2021 13:40:30 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id b9sm1667212ilc.28.2021.04.09.13.40.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Apr 2021 13:40:30 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     agross@kernel.org, bjorn.andersson@linaro.org, robh+dt@kernel.org,
        elder@kernel.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/4] net: ipa: add IPA v4.5 configuration data
Date:   Fri,  9 Apr 2021 15:40:23 -0500
Message-Id: <20210409204024.1255938-4-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210409204024.1255938-1-elder@linaro.org>
References: <20210409204024.1255938-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for the SDX55 SoC, which includes IPA version 4.5.

Starting with IPA v4.5, a few of the memory regions have a different
number of "canary" values; update comments in the where the region
identifers are defined to accurately reflect that.

I'll note three differences in SDX55 versus the other two existing
platforms (SDM845 and SC7180):
  - SDX55 uses a 32-bit Linux kernel
  - SDX55 has four interconnects rather than three
  - SDX55 uses IPA v4.5, which uses inline checksum offload

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/Makefile        |   3 +-
 drivers/net/ipa/ipa_data-v4.5.c | 437 ++++++++++++++++++++++++++++++++
 drivers/net/ipa/ipa_data.h      |   1 +
 drivers/net/ipa/ipa_main.c      |   4 +
 drivers/net/ipa/ipa_mem.h       |   6 +-
 5 files changed, 447 insertions(+), 4 deletions(-)
 create mode 100644 drivers/net/ipa/ipa_data-v4.5.c

diff --git a/drivers/net/ipa/Makefile b/drivers/net/ipa/Makefile
index 6abd1db9fe330..ccc4924881ac4 100644
--- a/drivers/net/ipa/Makefile
+++ b/drivers/net/ipa/Makefile
@@ -9,4 +9,5 @@ ipa-y			:=	ipa_main.o ipa_clock.o ipa_reg.o ipa_mem.o \
 				ipa_endpoint.o ipa_cmd.o ipa_modem.o \
 				ipa_resource.o ipa_qmi.o ipa_qmi_msg.o
 
-ipa-y			+=	ipa_data-v3.5.1.o ipa_data-v4.2.o
+ipa-y			+=	ipa_data-v3.5.1.o ipa_data-v4.2.o \
+				ipa_data-v4.5.o
diff --git a/drivers/net/ipa/ipa_data-v4.5.c b/drivers/net/ipa/ipa_data-v4.5.c
new file mode 100644
index 0000000000000..5f67a3a909ee0
--- /dev/null
+++ b/drivers/net/ipa/ipa_data-v4.5.c
@@ -0,0 +1,437 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/* Copyright (C) 2021 Linaro Ltd. */
+
+#include <linux/log2.h>
+
+#include "gsi.h"
+#include "ipa_data.h"
+#include "ipa_endpoint.h"
+#include "ipa_mem.h"
+
+/** enum ipa_resource_type - IPA resource types for an SoC having IPA v4.5 */
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
+/* Resource groups used for an SoC having IPA v4.5 */
+enum ipa_rsrc_group_id {
+	/* Source resource group identifiers */
+	IPA_RSRC_GROUP_SRC_UNUSED_0		= 0,
+	IPA_RSRC_GROUP_SRC_UL_DL,
+	IPA_RSRC_GROUP_SRC_UNUSED_2,
+	IPA_RSRC_GROUP_SRC_UNUSED_3,
+	IPA_RSRC_GROUP_SRC_UC_RX_Q,
+	IPA_RSRC_GROUP_SRC_COUNT,	/* Last in set; not a source group */
+
+	/* Destination resource group identifiers */
+	IPA_RSRC_GROUP_DST_UNUSED_0		= 0,
+	IPA_RSRC_GROUP_DST_UL_DL_DPL,
+	IPA_RSRC_GROUP_DST_UNUSED_2,
+	IPA_RSRC_GROUP_DST_UNUSED_3,
+	IPA_RSRC_GROUP_DST_UC,
+	IPA_RSRC_GROUP_DST_COUNT,	/* Last; not a destination group */
+};
+
+/* QSB configuration data for an SoC having IPA v4.5 */
+static const struct ipa_qsb_data ipa_qsb_data[] = {
+	[IPA_QSB_MASTER_DDR] = {
+		.max_writes		= 8,
+		.max_reads		= 0,	/* no limit (hardware max) */
+		.max_reads_beats	= 120,
+	},
+	[IPA_QSB_MASTER_PCIE] = {
+		.max_writes		= 8,
+		.max_reads		= 12,
+		/* no outstanding read byte (beat) limit */
+	},
+};
+
+/* Endpoint configuration data for an SoC having IPA v4.5 */
+static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
+	[IPA_ENDPOINT_AP_COMMAND_TX] = {
+		.ee_id		= GSI_EE_AP,
+		.channel_id	= 9,
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
+		.channel_id	= 10,
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
+		.channel_id	= 7,
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
+		.channel_id	= 1,
+		.endpoint_id	= 14,
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
+		.endpoint_id	= 21,
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
+/* Source resource configuration data for an SoC having IPA v4.5 */
+static const struct ipa_resource ipa_resource_src[] = {
+	[IPA_RESOURCE_TYPE_SRC_PKT_CONTEXTS] = {
+		.limits[IPA_RSRC_GROUP_SRC_UL_DL] = {
+			.min = 1,	.max = 11,
+		},
+		.limits[IPA_RSRC_GROUP_SRC_UC_RX_Q] = {
+			.min = 1,	.max = 63,
+		},
+	},
+	[IPA_RESOURCE_TYPE_SRC_DESCRIPTOR_LISTS] = {
+		.limits[IPA_RSRC_GROUP_SRC_UL_DL] = {
+			.min = 14,	.max = 14,
+		},
+		.limits[IPA_RSRC_GROUP_SRC_UC_RX_Q] = {
+			.min = 3,	.max = 3,
+		},
+	},
+	[IPA_RESOURCE_TYPE_SRC_DESCRIPTOR_BUFF] = {
+		.limits[IPA_RSRC_GROUP_SRC_UL_DL] = {
+			.min = 18,	.max = 18,
+		},
+		.limits[IPA_RSRC_GROUP_SRC_UC_RX_Q] = {
+			.min = 8,	.max = 8,
+		},
+	},
+	[IPA_RESOURCE_TYPE_SRC_HPS_DMARS] = {
+		.limits[IPA_RSRC_GROUP_SRC_UNUSED_0] = {
+			.min = 0,	.max = 63,
+		},
+		.limits[IPA_RSRC_GROUP_SRC_UL_DL] = {
+			.min = 0,	.max = 63,
+		},
+		.limits[IPA_RSRC_GROUP_SRC_UNUSED_2] = {
+			.min = 0,	.max = 63,
+		},
+		.limits[IPA_RSRC_GROUP_SRC_UNUSED_3] = {
+			.min = 0,	.max = 63,
+		},
+		.limits[IPA_RSRC_GROUP_SRC_UC_RX_Q] = {
+			.min = 0,	.max = 63,
+		},
+	},
+	[IPA_RESOURCE_TYPE_SRC_ACK_ENTRIES] = {
+		.limits[IPA_RSRC_GROUP_SRC_UL_DL] = {
+			.min = 24,	.max = 24,
+		},
+		.limits[IPA_RSRC_GROUP_SRC_UC_RX_Q] = {
+			.min = 8,	.max = 8,
+		},
+	},
+};
+
+/* Destination resource configuration data for an SoC having IPA v4.5 */
+static const struct ipa_resource ipa_resource_dst[] = {
+	[IPA_RESOURCE_TYPE_DST_DATA_SECTORS] = {
+		.limits[IPA_RSRC_GROUP_DST_UL_DL_DPL] = {
+			.min = 16,	.max = 16,
+		},
+		.limits[IPA_RSRC_GROUP_DST_UNUSED_2] = {
+			.min = 2,	.max = 2,
+		},
+		.limits[IPA_RSRC_GROUP_DST_UNUSED_3] = {
+			.min = 2,	.max = 2,
+		},
+	},
+	[IPA_RESOURCE_TYPE_DST_DPS_DMARS] = {
+		.limits[IPA_RSRC_GROUP_DST_UL_DL_DPL] = {
+			.min = 2,	.max = 63,
+		},
+		.limits[IPA_RSRC_GROUP_DST_UNUSED_2] = {
+			.min = 1,	.max = 2,
+		},
+		.limits[IPA_RSRC_GROUP_DST_UNUSED_3] = {
+			.min = 1,	.max = 2,
+		},
+		.limits[IPA_RSRC_GROUP_DST_UC] = {
+			.min = 0,	.max = 2,
+		},
+	},
+};
+
+/* Resource configuration data for an SoC having IPA v4.5 */
+static const struct ipa_resource_data ipa_resource_data = {
+	.rsrc_group_src_count	= IPA_RSRC_GROUP_SRC_COUNT,
+	.rsrc_group_dst_count	= IPA_RSRC_GROUP_DST_COUNT,
+	.resource_src_count	= ARRAY_SIZE(ipa_resource_src),
+	.resource_src		= ipa_resource_src,
+	.resource_dst_count	= ARRAY_SIZE(ipa_resource_dst),
+	.resource_dst		= ipa_resource_dst,
+};
+
+/* IPA-resident memory region data for an SoC having IPA v4.5 */
+static const struct ipa_mem ipa_mem_local_data[] = {
+	[IPA_MEM_UC_SHARED] = {
+		.offset		= 0x0000,
+		.size		= 0x0080,
+		.canary_count	= 0,
+	},
+	[IPA_MEM_UC_INFO] = {
+		.offset		= 0x0080,
+		.size		= 0x0200,
+		.canary_count	= 0,
+	},
+	[IPA_MEM_V4_FILTER_HASHED] = {
+		.offset		= 0x0288,
+		.size		= 0x0078,
+		.canary_count	= 2,
+	},
+	[IPA_MEM_V4_FILTER] = {
+		.offset		= 0x0308,
+		.size		= 0x0078,
+		.canary_count	= 2,
+	},
+	[IPA_MEM_V6_FILTER_HASHED] = {
+		.offset		= 0x0388,
+		.size		= 0x0078,
+		.canary_count	= 2,
+	},
+	[IPA_MEM_V6_FILTER] = {
+		.offset		= 0x0408,
+		.size		= 0x0078,
+		.canary_count	= 2,
+	},
+	[IPA_MEM_V4_ROUTE_HASHED] = {
+		.offset		= 0x0488,
+		.size		= 0x0078,
+		.canary_count	= 2,
+	},
+	[IPA_MEM_V4_ROUTE] = {
+		.offset		= 0x0508,
+		.size		= 0x0078,
+		.canary_count	= 2,
+	},
+	[IPA_MEM_V6_ROUTE_HASHED] = {
+		.offset		= 0x0588,
+		.size		= 0x0078,
+		.canary_count	= 2,
+	},
+	[IPA_MEM_V6_ROUTE] = {
+		.offset		= 0x0608,
+		.size		= 0x0078,
+		.canary_count	= 2,
+	},
+	[IPA_MEM_MODEM_HEADER] = {
+		.offset		= 0x0688,
+		.size		= 0x0240,
+		.canary_count	= 2,
+	},
+	[IPA_MEM_AP_HEADER] = {
+		.offset		= 0x08c8,
+		.size		= 0x0200,
+		.canary_count	= 0,
+	},
+	[IPA_MEM_MODEM_PROC_CTX] = {
+		.offset		= 0x0ad0,
+		.size		= 0x0b20,
+		.canary_count	= 2,
+	},
+	[IPA_MEM_AP_PROC_CTX] = {
+		.offset		= 0x15f0,
+		.size		= 0x0200,
+		.canary_count	= 0,
+	},
+	[IPA_MEM_NAT_TABLE] = {
+		.offset		= 0x1800,
+		.size		= 0x0d00,
+		.canary_count	= 4,
+	},
+	[IPA_MEM_STATS_QUOTA_MODEM] = {
+		.offset		= 0x2510,
+		.size		= 0x0030,
+		.canary_count	= 4,
+	},
+	[IPA_MEM_STATS_QUOTA_AP] = {
+		.offset		= 0x2540,
+		.size		= 0x0048,
+		.canary_count	= 0,
+	},
+	[IPA_MEM_STATS_TETHERING] = {
+		.offset		= 0x2588,
+		.size		= 0x0238,
+		.canary_count	= 0,
+	},
+	[IPA_MEM_STATS_FILTER_ROUTE] = {
+		.offset		= 0x27c0,
+		.size		= 0x0800,
+		.canary_count	= 0,
+	},
+	[IPA_MEM_STATS_DROP] = {
+		.offset		= 0x2fc0,
+		.size		= 0x0020,
+		.canary_count	= 0,
+	},
+	[IPA_MEM_MODEM] = {
+		.offset		= 0x2fe8,
+		.size		= 0x0800,
+		.canary_count	= 2,
+	},
+	[IPA_MEM_UC_EVENT_RING] = {
+		.offset		= 0x3800,
+		.size		= 0x1000,
+		.canary_count	= 1,
+	},
+	[IPA_MEM_PDN_CONFIG] = {
+		.offset		= 0x4800,
+		.size		= 0x0050,
+		.canary_count	= 0,
+	},
+};
+
+/* Memory configuration data for an SoC having IPA v4.5 */
+static const struct ipa_mem_data ipa_mem_data = {
+	.local_count	= ARRAY_SIZE(ipa_mem_local_data),
+	.local		= ipa_mem_local_data,
+	.imem_addr	= 0x14688000,
+	.imem_size	= 0x00003000,
+	.smem_id	= 497,
+	.smem_size	= 0x00009000,
+};
+
+/* Interconnect rates are in 1000 byte/second units */
+static const struct ipa_interconnect_data ipa_interconnect_data[] = {
+	{
+		.name			= "memory-a",
+		.peak_bandwidth		= 600000,	/* 600 MBps */
+		.average_bandwidth	= 150000,	/* 150 MBps */
+	},
+	{
+		.name			= "memory-b",
+		.peak_bandwidth		= 1804000,	/* 1.804 GBps */
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
+/* Clock and interconnect configuration data for an SoC having IPA v4.5 */
+static const struct ipa_clock_data ipa_clock_data = {
+	.core_clock_rate	= 150 * 1000 * 1000,	/* Hz (150?  60?) */
+	.interconnect_count	= ARRAY_SIZE(ipa_interconnect_data),
+	.interconnect_data	= ipa_interconnect_data,
+};
+
+/* Configuration data for an SoC having IPA v4.5 */
+const struct ipa_data ipa_data_v4_5 = {
+	.version	= IPA_VERSION_4_5,
+	.qsb_count	= ARRAY_SIZE(ipa_qsb_data),
+	.qsb_data	= ipa_qsb_data,
+	.endpoint_count	= ARRAY_SIZE(ipa_gsi_endpoint_data),
+	.endpoint_data	= ipa_gsi_endpoint_data,
+	.resource_data	= &ipa_resource_data,
+	.mem_data	= &ipa_mem_data,
+	.clock_data	= &ipa_clock_data,
+};
diff --git a/drivers/net/ipa/ipa_data.h b/drivers/net/ipa/ipa_data.h
index 769f68923527f..4bbb978fefdb7 100644
--- a/drivers/net/ipa/ipa_data.h
+++ b/drivers/net/ipa/ipa_data.h
@@ -302,5 +302,6 @@ struct ipa_data {
 
 extern const struct ipa_data ipa_data_v3_5_1;
 extern const struct ipa_data ipa_data_v4_2;
+extern const struct ipa_data ipa_data_v4_5;
 
 #endif /* _IPA_DATA_H_ */
diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index a970d10e650ef..b3ee79e07309e 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -584,6 +584,10 @@ static const struct of_device_id ipa_match[] = {
 		.compatible	= "qcom,sc7180-ipa",
 		.data		= &ipa_data_v4_2,
 	},
+	{
+		.compatible	= "qcom,sdx55-ipa",
+		.data		= &ipa_data_v4_5,
+	},
 	{ },
 };
 MODULE_DEVICE_TABLE(of, ipa_match);
diff --git a/drivers/net/ipa/ipa_mem.h b/drivers/net/ipa/ipa_mem.h
index df61ef48df365..a6abe0866c7ad 100644
--- a/drivers/net/ipa/ipa_mem.h
+++ b/drivers/net/ipa/ipa_mem.h
@@ -58,8 +58,8 @@ enum ipa_mem_id {
 	IPA_MEM_MODEM_PROC_CTX,		/* 2 canaries */
 	IPA_MEM_AP_PROC_CTX,		/* 0 canaries */
 	IPA_MEM_NAT_TABLE,		/* 4 canaries (IPA v4.5 and above) */
-	IPA_MEM_PDN_CONFIG,		/* 2 canaries (IPA v4.0 and above) */
-	IPA_MEM_STATS_QUOTA_MODEM,	/* 2 canaries (IPA v4.0 and above) */
+	IPA_MEM_PDN_CONFIG,		/* 0/2 canaries (IPA v4.0 and above) */
+	IPA_MEM_STATS_QUOTA_MODEM,	/* 2/4 canaries (IPA v4.0 and above) */
 	IPA_MEM_STATS_QUOTA_AP,		/* 0 canaries (IPA v4.0 and above) */
 	IPA_MEM_STATS_TETHERING,	/* 0 canaries (IPA v4.0 and above) */
 	IPA_MEM_STATS_V4_FILTER,	/* 0 canaries (IPA v4.0-v4.2) */
@@ -68,7 +68,7 @@ enum ipa_mem_id {
 	IPA_MEM_STATS_V6_ROUTE,		/* 0 canaries (IPA v4.0-v4.2) */
 	IPA_MEM_STATS_FILTER_ROUTE,	/* 0 canaries (IPA v4.5 and above) */
 	IPA_MEM_STATS_DROP,		/* 0 canaries (IPA v4.0 and above) */
-	IPA_MEM_MODEM,			/* 0 canaries */
+	IPA_MEM_MODEM,			/* 0/2 canaries */
 	IPA_MEM_UC_EVENT_RING,		/* 1 canary */
 	IPA_MEM_COUNT,			/* Number of regions (not an index) */
 };
-- 
2.27.0

