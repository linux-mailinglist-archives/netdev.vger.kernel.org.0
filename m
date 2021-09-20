Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D4B2410EC0
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 05:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235007AbhITDMt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Sep 2021 23:12:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234515AbhITDM3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Sep 2021 23:12:29 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2753C0617BA;
        Sun, 19 Sep 2021 20:10:17 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id on12-20020a17090b1d0c00b001997c60aa29so11115847pjb.1;
        Sun, 19 Sep 2021 20:10:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TiVOZ2Q/tlFKYvHdNz90hwJpJvi2U953jPl9nmU6Kdo=;
        b=l6CL+t2GdHNaHgYvSAziVSAt9eN6B6pUFbx0amR+MdaEmSZMhTH5qL2oRUUaHUeVj3
         gwdL8vuN/3aVI7Ja+YOVtfUwgavAwJnlnK5PDwidylZoOR3kATJl2zUisj4BWgdBXojL
         mrpOLlReJz3kgm7VxEx5+m7c5/td0CFOhX5dVADbgnPEU5BG3UBKaqu+QWSxVCaJbSzg
         Z1zgGMfK9E5u/8UHlDLUVwpA7Oz7pwlCMV7V3rMnVpp8Tnev08D9fOsYF+kleMd7h03n
         SxnNrReyAlD+8qP9GmH/cy4RwyCuzo6wfWjB/CXChcTsGk5+7R9tswPbIbD+GR94qjXd
         ykUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TiVOZ2Q/tlFKYvHdNz90hwJpJvi2U953jPl9nmU6Kdo=;
        b=yuJacLNuGnC0WS/OLnMiQmjNArWd55TLcMQyWzaYjHgY6E3kDXdgV3OU/+TII1oTgI
         uStFE16RDddFWXMrAQybe/qoZAnHGpc3jjRTjHJCeOr83oSHqfo5Zt+g/HXsKJ/0AXaC
         4vFeoK9fnJL5Y9PHWWI2jn5d5QkV+dcTtfbQQsXZBoOifYsN+zgp2BvkjTwQjenZ0Q/f
         tjOWGno1k6+ze365PLtm/B1zFJNUuWZoPgDQpADbKuYO7q6whj6bopEFJTZsS+d6BcVM
         DwjhyzUlDxtF289bQ9SCtfCRVlIxn8FHethogkKY2ARI5GxFcnYXq8Ty6k8Ykipv9edL
         wvWA==
X-Gm-Message-State: AOAM531FvGmgRWkXbFcwTIJMf92SNdl5zwlDInrwrg+DKEDUa9X08Lof
        xjou/CWsFKWfclBTcKYKtFbzCfsnVldEOL1n
X-Google-Smtp-Source: ABdhPJzEp7WSBTpujmr4zlGxDju8VcySMROlcorxyx985uw5YX2iqhYeLnA/AMCA1cDLVuTDD6+8Ng==
X-Received: by 2002:a17:902:d2c8:b0:13a:54b2:81c9 with SMTP id n8-20020a170902d2c800b0013a54b281c9mr20477803plc.21.1632107417124;
        Sun, 19 Sep 2021 20:10:17 -0700 (PDT)
Received: from skynet-linux.local ([106.201.127.154])
        by smtp.googlemail.com with ESMTPSA id l11sm16295065pjg.22.2021.09.19.20.10.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Sep 2021 20:10:16 -0700 (PDT)
From:   Sireesh Kodali <sireeshkodali1@gmail.com>
To:     phone-devel@vger.kernel.org, ~postmarketos/upstreaming@lists.sr.ht,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, elder@kernel.org
Cc:     Sireesh Kodali <sireeshkodali1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFC PATCH 16/17] net: ipa: Add hw config describing IPA v2.x hardware
Date:   Mon, 20 Sep 2021 08:38:10 +0530
Message-Id: <20210920030811.57273-17-sireeshkodali1@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920030811.57273-1-sireeshkodali1@gmail.com>
References: <20210920030811.57273-1-sireeshkodali1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit adds the config for IPA v2.0, v2.5, v2.6L. IPA v2.5 is found
on msm8996. IPA v2.6L hardware is found on following SoCs: msm8920,
msm8940, msm8952, msm8953, msm8956, msm8976, sdm630, sdm660. No
SoC-specific configuration in ipa driver is required.

Signed-off-by: Sireesh Kodali <sireeshkodali1@gmail.com>
---
 drivers/net/ipa/Makefile        |   7 +-
 drivers/net/ipa/ipa_data-v2.c   | 369 ++++++++++++++++++++++++++++++++
 drivers/net/ipa/ipa_data-v3.1.c |   2 +-
 drivers/net/ipa/ipa_data.h      |   3 +
 drivers/net/ipa/ipa_main.c      |  15 ++
 drivers/net/ipa/ipa_sysfs.c     |   6 +
 6 files changed, 398 insertions(+), 4 deletions(-)
 create mode 100644 drivers/net/ipa/ipa_data-v2.c

diff --git a/drivers/net/ipa/Makefile b/drivers/net/ipa/Makefile
index 4abebc667f77..858fbf76cff3 100644
--- a/drivers/net/ipa/Makefile
+++ b/drivers/net/ipa/Makefile
@@ -7,6 +7,7 @@ ipa-y			:=	ipa_main.o ipa_power.o ipa_reg.o ipa_mem.o \
 				ipa_resource.o ipa_qmi.o ipa_qmi_msg.o \
 				ipa_sysfs.o
 
-ipa-y			+=	ipa_data-v3.1.o ipa_data-v3.5.1.o \
-				ipa_data-v4.2.o ipa_data-v4.5.o \
-				ipa_data-v4.9.o ipa_data-v4.11.o
+ipa-y			+=	ipa_data-v2.o ipa_data-v3.1.o \
+				ipa_data-v3.5.1.o ipa_data-v4.2.o \
+				ipa_data-v4.5.o ipa_data-v4.9.o \
+				ipa_data-v4.11.o
diff --git a/drivers/net/ipa/ipa_data-v2.c b/drivers/net/ipa/ipa_data-v2.c
new file mode 100644
index 000000000000..869b8a1a45d6
--- /dev/null
+++ b/drivers/net/ipa/ipa_data-v2.c
@@ -0,0 +1,369 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
+ * Copyright (C) 2019-2020 Linaro Ltd.
+ */
+
+#include <linux/log2.h>
+
+#include "ipa_data.h"
+#include "ipa_endpoint.h"
+#include "ipa_mem.h"
+
+/* Endpoint configuration for the IPA v2 hardware. */
+static const struct ipa_gsi_endpoint_data ipa_endpoint_data[] = {
+	[IPA_ENDPOINT_AP_COMMAND_TX] = {
+		.ee_id		= GSI_EE_AP,
+		.channel_id	= 3,
+		.endpoint_id	= 3,
+		.channel_name	= "cmd_tx",
+		.toward_ipa	= true,
+		.channel = {
+			.tre_count	= 256,
+			.event_count	= 256,
+			.tlv_count	= 20,
+		},
+		.endpoint = {
+			.config	= {
+				.dma_mode	= true,
+				.dma_endpoint	= IPA_ENDPOINT_AP_LAN_RX,
+			},
+		},
+	},
+	[IPA_ENDPOINT_AP_LAN_RX] = {
+		.ee_id		= GSI_EE_AP,
+		.channel_id	= 2,
+		.endpoint_id	= 2,
+		.channel_name	= "ap_lan_rx",
+		.channel = {
+			.tre_count	= 256,
+			.event_count	= 256,
+			.tlv_count	= 8,
+		},
+		.endpoint	= {
+			.config	= {
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
+		.channel_id	= 4,
+		.endpoint_id	= 4,
+		.channel_name	= "ap_modem_tx",
+		.toward_ipa	= true,
+		.channel = {
+			.tre_count	= 256,
+			.event_count	= 256,
+			.tlv_count	= 8,
+		},
+		.endpoint	= {
+			.config	= {
+				.qmap		= true,
+				.status_enable	= true,
+				.tx = {
+					.status_endpoint =
+						IPA_ENDPOINT_AP_LAN_RX,
+				},
+			},
+		},
+	},
+	[IPA_ENDPOINT_AP_MODEM_RX] = {
+		.ee_id		= GSI_EE_AP,
+		.channel_id	= 5,
+		.endpoint_id	= 5,
+		.channel_name	= "ap_modem_rx",
+		.toward_ipa	= false,
+		.channel = {
+			.tre_count	= 256,
+			.event_count	= 256,
+			.tlv_count	= 8,
+		},
+		.endpoint	= {
+			.config = {
+				.aggregation	= true,
+				.qmap		= true,
+			},
+		},
+	},
+	[IPA_ENDPOINT_MODEM_LAN_TX] = {
+		.ee_id		= GSI_EE_MODEM,
+		.channel_id	= 6,
+		.endpoint_id	= 6,
+		.channel_name	= "modem_lan_tx",
+		.toward_ipa	= true,
+	},
+	[IPA_ENDPOINT_MODEM_COMMAND_TX] = {
+		.ee_id		= GSI_EE_MODEM,
+		.channel_id	= 7,
+		.endpoint_id	= 7,
+		.channel_name	= "modem_cmd_tx",
+		.toward_ipa	= true,
+	},
+	[IPA_ENDPOINT_MODEM_LAN_RX] = {
+		.ee_id		= GSI_EE_MODEM,
+		.channel_id	= 8,
+		.endpoint_id	= 8,
+		.channel_name	= "modem_lan_rx",
+		.toward_ipa	= false,
+	},
+	[IPA_ENDPOINT_MODEM_AP_RX] = {
+		.ee_id		= GSI_EE_MODEM,
+		.channel_id	= 9,
+		.endpoint_id	= 9,
+		.channel_name	= "modem_ap_rx",
+		.toward_ipa	= false,
+	},
+};
+
+static struct ipa_interconnect_data ipa_interconnect_data[] = {
+	{
+		.name = "memory",
+		.peak_bandwidth	= 1200000,	/* 1200 MBps */
+		.average_bandwidth = 100000,	/* 100 MBps */
+	},
+	{
+		.name = "imem",
+		.peak_bandwidth	= 350000,	/* 350 MBps */
+		.average_bandwidth  = 0,	/* unused */
+	},
+	{
+		.name = "config",
+		.peak_bandwidth	= 40000,	/* 40 MBps */
+		.average_bandwidth = 0,		/* unused */
+	},
+};
+
+static struct ipa_power_data ipa_power_data = {
+	.core_clock_rate	= 200 * 1000 * 1000,	/* Hz */
+	.interconnect_count	= ARRAY_SIZE(ipa_interconnect_data),
+	.interconnect_data	= ipa_interconnect_data,
+};
+
+/* IPA-resident memory region configuration for v2.0 */
+static const struct ipa_mem ipa_mem_local_data_v2_0[IPA_MEM_COUNT] = {
+	[IPA_MEM_UC_SHARED] = {
+		.offset         = 0,
+		.size           = 0x80,
+		.canary_count   = 0,
+	},
+	[IPA_MEM_V4_FILTER] = {
+		.offset		= 0x0080,
+		.size		= 0x0058,
+		.canary_count	= 0,
+	},
+	[IPA_MEM_V6_FILTER] = {
+		.offset		= 0x00e0,
+		.size		= 0x0058,
+		.canary_count	= 2,
+	},
+	[IPA_MEM_V4_ROUTE] = {
+		.offset		= 0x0140,
+		.size		= 0x002c,
+		.canary_count	= 2,
+	},
+	[IPA_MEM_V6_ROUTE] = {
+		.offset		= 0x0170,
+		.size		= 0x002c,
+		.canary_count	= 1,
+	},
+	[IPA_MEM_MODEM_HEADER] = {
+		.offset		= 0x01a0,
+		.size		= 0x0140,
+		.canary_count	= 1,
+	},
+	[IPA_MEM_AP_HEADER] = {
+		.offset		= 0x02e0,
+		.size		= 0x0048,
+		.canary_count	= 0,
+	},
+	[IPA_MEM_MODEM] = {
+		.offset		= 0x032c,
+		.size		= 0x0dcc,
+		.canary_count	= 1,
+	},
+	[IPA_MEM_V4_FILTER_AP] = {
+		.offset		= 0x10fc,
+		.size		= 0x0780,
+		.canary_count	= 1,
+	},
+	[IPA_MEM_V6_FILTER_AP] = {
+		.offset		= 0x187c,
+		.size		= 0x055c,
+		.canary_count	= 0,
+	},
+	[IPA_MEM_UC_INFO] = {
+		.offset		= 0x1ddc,
+		.size		= 0x0124,
+		.canary_count	= 1,
+	},
+};
+
+static struct ipa_mem_data ipa_mem_data_v2_0 = {
+	.local		= ipa_mem_local_data_v2_0,
+	.smem_id	= 497,
+	.smem_size	= 0x00001f00,
+};
+
+/* Configuration data for IPAv2.0 */
+const struct ipa_data ipa_data_v2_0  = {
+	.version	= IPA_VERSION_2_0,
+	.endpoint_count	= ARRAY_SIZE(ipa_endpoint_data),
+	.endpoint_data	= ipa_endpoint_data,
+	.mem_data	= &ipa_mem_data_v2_0,
+	.power_data	= &ipa_power_data,
+};
+
+/* IPA-resident memory region configuration for v2.5 */
+static const struct ipa_mem ipa_mem_local_data_v2_5[IPA_MEM_COUNT] = {
+	[IPA_MEM_UC_SHARED] = {
+		.offset         = 0,
+		.size           = 0x80,
+		.canary_count   = 0,
+	},
+	[IPA_MEM_UC_INFO] = {
+		.offset		= 0x0080,
+		.size		= 0x0200,
+		.canary_count	= 0,
+	},
+	[IPA_MEM_V4_FILTER] = {
+		.offset		= 0x0288,
+		.size		= 0x0058,
+		.canary_count	= 2,
+	},
+	[IPA_MEM_V6_FILTER] = {
+		.offset		= 0x02e8,
+		.size		= 0x0058,
+		.canary_count	= 2,
+	},
+	[IPA_MEM_V4_ROUTE] = {
+		.offset		= 0x0348,
+		.size		= 0x003c,
+		.canary_count	= 2,
+	},
+	[IPA_MEM_V6_ROUTE] = {
+		.offset		= 0x0388,
+		.size		= 0x003c,
+		.canary_count	= 1,
+	},
+	[IPA_MEM_MODEM_HEADER] = {
+		.offset		= 0x03c8,
+		.size		= 0x0140,
+		.canary_count	= 1,
+	},
+	[IPA_MEM_MODEM_PROC_CTX] = {
+		.offset		= 0x0510,
+		.size		= 0x0200,
+		.canary_count	= 2,
+	},
+	[IPA_MEM_AP_PROC_CTX] = {
+		.offset		= 0x0710,
+		.size		= 0x0200,
+		.canary_count	= 0,
+	},
+	[IPA_MEM_MODEM] = {
+		.offset		= 0x0914,
+		.size		= 0x16a8,
+		.canary_count	= 1,
+	},
+};
+
+static struct ipa_mem_data ipa_mem_data_v2_5 = {
+	.local		= ipa_mem_local_data_v2_5,
+	.smem_id	= 497,
+	.smem_size	= 0x00002000,
+};
+
+/* Configuration data for IPAv2.5 */
+const struct ipa_data ipa_data_v2_5  = {
+	.version	= IPA_VERSION_2_5,
+	.endpoint_count	= ARRAY_SIZE(ipa_endpoint_data),
+	.endpoint_data	= ipa_endpoint_data,
+	.mem_data	= &ipa_mem_data_v2_5,
+	.power_data	= &ipa_power_data,
+};
+
+/* IPA-resident memory region configuration for v2.6L */
+static const struct ipa_mem ipa_mem_local_data_v2_6L[IPA_MEM_COUNT] = {
+	{
+		.id		= IPA_MEM_UC_SHARED,
+		.offset         = 0,
+		.size           = 0x80,
+		.canary_count   = 0,
+	},
+	{
+		.id 		= IPA_MEM_UC_INFO,
+		.offset		= 0x0080,
+		.size		= 0x0200,
+		.canary_count	= 0,
+	},
+	{
+		.id		= IPA_MEM_V4_FILTER,
+		.offset		= 0x0288,
+		.size		= 0x0058,
+		.canary_count	= 2,
+	},
+	{
+		.id		= IPA_MEM_V6_FILTER,
+		.offset		= 0x02e8,
+		.size		= 0x0058,
+		.canary_count	= 2,
+	},
+	{
+		.id		= IPA_MEM_V4_ROUTE,
+		.offset		= 0x0348,
+		.size		= 0x003c,
+		.canary_count	= 2,
+	},
+	{
+		.id		= IPA_MEM_V6_ROUTE,
+		.offset		= 0x0388,
+		.size		= 0x003c,
+		.canary_count	= 1,
+	},
+	{
+		.id		= IPA_MEM_MODEM_HEADER,
+		.offset		= 0x03c8,
+		.size		= 0x0140,
+		.canary_count	= 1,
+	},
+	{
+		.id		= IPA_MEM_ZIP,
+		.offset		= 0x0510,
+		.size		= 0x0200,
+		.canary_count	= 2,
+	},
+	{
+		.id		= IPA_MEM_MODEM,
+		.offset		= 0x0714,
+		.size		= 0x18e8,
+		.canary_count	= 1,
+	},
+	{
+		.id		= IPA_MEM_END_MARKER,
+		.offset		= 0x2000,
+		.size		= 0,
+		.canary_count	= 1,
+	},
+};
+
+static struct ipa_mem_data ipa_mem_data_v2_6L = {
+	.local		= ipa_mem_local_data_v2_6L,
+	.smem_id	= 497,
+	.smem_size	= 0x00002000,
+};
+
+/* Configuration data for IPAv2.6L */
+const struct ipa_data ipa_data_v2_6L  = {
+	.version	= IPA_VERSION_2_6L,
+	/* Unfortunately we don't know what this BCR value corresponds to */
+	.backward_compat = 0x1fff7f,
+	.endpoint_count	= ARRAY_SIZE(ipa_endpoint_data),
+	.endpoint_data	= ipa_endpoint_data,
+	.mem_data	= &ipa_mem_data_v2_6L,
+	.power_data	= &ipa_power_data,
+};
diff --git a/drivers/net/ipa/ipa_data-v3.1.c b/drivers/net/ipa/ipa_data-v3.1.c
index 06ddb85f39b2..12d231232756 100644
--- a/drivers/net/ipa/ipa_data-v3.1.c
+++ b/drivers/net/ipa/ipa_data-v3.1.c
@@ -6,7 +6,7 @@
 
 #include <linux/log2.h>
 
-#include "gsi.h"
+#include "ipa_dma.h"
 #include "ipa_data.h"
 #include "ipa_endpoint.h"
 #include "ipa_mem.h"
diff --git a/drivers/net/ipa/ipa_data.h b/drivers/net/ipa/ipa_data.h
index 7d62d49f414f..e7ce2e9388b6 100644
--- a/drivers/net/ipa/ipa_data.h
+++ b/drivers/net/ipa/ipa_data.h
@@ -301,6 +301,9 @@ struct ipa_data {
 	const struct ipa_power_data *power_data;
 };
 
+extern const struct ipa_data ipa_data_v2_0;
+extern const struct ipa_data ipa_data_v2_5;
+extern const struct ipa_data ipa_data_v2_6L;
 extern const struct ipa_data ipa_data_v3_1;
 extern const struct ipa_data ipa_data_v3_5_1;
 extern const struct ipa_data ipa_data_v4_2;
diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index b437fbf95edf..3ae5c5c6734b 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -560,6 +560,18 @@ static int ipa_firmware_load(struct device *dev)
 }
 
 static const struct of_device_id ipa_match[] = {
+	{
+		.compatible	= "qcom,ipa-v2.0",
+		.data		= &ipa_data_v2_0,
+	},
+	{
+		.compatible	= "qcom,msm8996-ipa",
+		.data		= &ipa_data_v2_5,
+	},
+	{
+		.compatible	= "qcom,msm8953-ipa",
+		.data		= &ipa_data_v2_6L,
+	},
 	{
 		.compatible	= "qcom,msm8998-ipa",
 		.data		= &ipa_data_v3_1,
@@ -632,6 +644,9 @@ static void ipa_validate_build(void)
 static bool ipa_version_valid(enum ipa_version version)
 {
 	switch (version) {
+	case IPA_VERSION_2_0:
+	case IPA_VERSION_2_5:
+	case IPA_VERSION_2_6L:
 	case IPA_VERSION_3_0:
 	case IPA_VERSION_3_1:
 	case IPA_VERSION_3_5:
diff --git a/drivers/net/ipa/ipa_sysfs.c b/drivers/net/ipa/ipa_sysfs.c
index ff61dbdd70d8..f5d159f6bc06 100644
--- a/drivers/net/ipa/ipa_sysfs.c
+++ b/drivers/net/ipa/ipa_sysfs.c
@@ -14,6 +14,12 @@
 static const char *ipa_version_string(struct ipa *ipa)
 {
 	switch (ipa->version) {
+	case IPA_VERSION_2_0:
+		return "2.0";
+	case IPA_VERSION_2_5:
+		return "2.5";
+	case IPA_VERSION_2_6L:
+		"return 2.6L";
 	case IPA_VERSION_3_0:
 		return "3.0";
 	case IPA_VERSION_3_1:
-- 
2.33.0

