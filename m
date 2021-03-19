Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F0063420E9
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 16:25:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbhCSPZF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 11:25:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230218AbhCSPYa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 11:24:30 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3A4BC06174A
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 08:24:29 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id v26so6481239iox.11
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 08:24:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AkAIkwKnHKlHjriaSzDP0d59Qoo4Ts3Lr/GHkUvhrrE=;
        b=GM0LzDP98p/0+cCI2Hy4w6dKNVA0yX++upe3JaTimCZF2EBhxNO7pRoRpuz+dvjxIw
         rcIO6L6ihpCA/ArOmTIQZP9edaAf1pKFvY1uXRjwRxtGsUnVC9LTH/tZ30a7xnl7sKe3
         jmFxIojYi/KdxFUxRe9chnldEEwLTNVnycyVh0xLCf4d4lwq5Sk3eYjoBijzTDP7CmOA
         ZsDKU3hL8SWAbJzWCdAMKQXa9aHr2cEWKrWBunS8aKILxrVSThsJOdJEifAfvO8PlgZf
         vzpibmcfQ7PklzuiEGs4GrSAIHmx81dxrwLr9a16x5n+ckNw4iljVdUwuodxmjwNi5+9
         I3ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AkAIkwKnHKlHjriaSzDP0d59Qoo4Ts3Lr/GHkUvhrrE=;
        b=Gef2/HJ3fdhjHjqONpaiwa+arG1XJh5wrvnlwxehlcmbHsEuyd0phl8M4NYqW4BkJu
         ehosBB0/6gO/pcxE3TFUEj7BFWszj+I0ohLKAodEpWFW7yN0FAXYxoxsZUz7cjuSTOVY
         oa4Wh6w9ejTMRbpm42E8aNi8xFLELOVE72OTLxFl/uhYDiU4zHzlXcPEOHdlaJW5MaL6
         7HyEEOu1ODLx6qbLBzOcNcIkq0BX+kmLCiWjK9/YQs7Bp9ZCSsp2kEjAvgt4YDMV0v6H
         JjtEdRGhJxjGgB9ToL8aejhUFpSQyoaMsJRP3mOu0CYehjs8zUxifu5rUbMVnflLyLAI
         yICQ==
X-Gm-Message-State: AOAM533+RitDwl8F/Rmn9/KcUJr0wuogjm6E2s7AtBXMNL3RxMdx50NG
        C8M4waLY7vGAr7JUWB0gKcWjvg==
X-Google-Smtp-Source: ABdhPJzL0MqwiO2Bx/yuXfWytZzMkOa7KzbIv6YLsJhxO8/G1B2RLhYkUmI3padcw+pMwIixijdq3g==
X-Received: by 2002:a05:6602:2f0c:: with SMTP id q12mr3131098iow.82.1616167469400;
        Fri, 19 Mar 2021 08:24:29 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id b5sm2686887ioq.7.2021.03.19.08.24.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Mar 2021 08:24:29 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 5/5] net: ipa: define QSB limits in configuration data
Date:   Fri, 19 Mar 2021 10:24:22 -0500
Message-Id: <20210319152422.1803714-6-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210319152422.1803714-1-elder@linaro.org>
References: <20210319152422.1803714-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define the maximum number of reads and writes to configure for the
QSB masters used for IPA in configuration data.

We don't use these values yet; the next commit takes care of that.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_data-sc7180.c | 10 ++++++++++
 drivers/net/ipa/ipa_data-sdm845.c | 14 ++++++++++++++
 drivers/net/ipa/ipa_data.h        | 24 ++++++++++++++++++++++--
 3 files changed, 46 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ipa/ipa_data-sc7180.c b/drivers/net/ipa/ipa_data-sc7180.c
index f65abc19ae9d7..216f790b22b66 100644
--- a/drivers/net/ipa/ipa_data-sc7180.c
+++ b/drivers/net/ipa/ipa_data-sc7180.c
@@ -9,6 +9,14 @@
 #include "ipa_endpoint.h"
 #include "ipa_mem.h"
 
+/* QSB configuration for the SC7180 SoC. */
+static const struct ipa_qsb_data ipa_qsb_data[] = {
+	[IPA_QSB_MASTER_DDR] = {
+		.max_writes	= 8,
+		.max_reads	= 12,
+	},
+};
+
 /* Endpoint configuration for the SC7180 SoC. */
 static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 	[IPA_ENDPOINT_AP_COMMAND_TX] = {
@@ -328,6 +336,8 @@ static const struct ipa_clock_data ipa_clock_data = {
 /* Configuration data for the SC7180 SoC. */
 const struct ipa_data ipa_data_sc7180 = {
 	.version	= IPA_VERSION_4_2,
+	.qsb_count	= ARRAY_SIZE(ipa_qsb_data),
+	.qsb_data	= ipa_qsb_data,
 	.endpoint_count	= ARRAY_SIZE(ipa_gsi_endpoint_data),
 	.endpoint_data	= ipa_gsi_endpoint_data,
 	.resource_data	= &ipa_resource_data,
diff --git a/drivers/net/ipa/ipa_data-sdm845.c b/drivers/net/ipa/ipa_data-sdm845.c
index 8cae9325eb08e..d9659fd22322a 100644
--- a/drivers/net/ipa/ipa_data-sdm845.c
+++ b/drivers/net/ipa/ipa_data-sdm845.c
@@ -11,6 +11,18 @@
 #include "ipa_endpoint.h"
 #include "ipa_mem.h"
 
+/* QSB configuration for the SDM845 SoC. */
+static const struct ipa_qsb_data ipa_qsb_data[] = {
+	[IPA_QSB_MASTER_DDR] = {
+		.max_writes	= 8,
+		.max_reads	= 8,
+	},
+	[IPA_QSB_MASTER_PCIE] = {
+		.max_writes	= 4,
+		.max_reads	= 12,
+	},
+};
+
 /* Endpoint configuration for the SDM845 SoC. */
 static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 	[IPA_ENDPOINT_AP_COMMAND_TX] = {
@@ -353,6 +365,8 @@ static const struct ipa_clock_data ipa_clock_data = {
 /* Configuration data for the SDM845 SoC. */
 const struct ipa_data ipa_data_sdm845 = {
 	.version	= IPA_VERSION_3_5_1,
+	.qsb_count	= ARRAY_SIZE(ipa_qsb_data),
+	.qsb_data	= ipa_qsb_data,
 	.endpoint_count	= ARRAY_SIZE(ipa_gsi_endpoint_data),
 	.endpoint_data	= ipa_gsi_endpoint_data,
 	.resource_data	= &ipa_resource_data,
diff --git a/drivers/net/ipa/ipa_data.h b/drivers/net/ipa/ipa_data.h
index b476fc373f7fe..d50cd5ae7714f 100644
--- a/drivers/net/ipa/ipa_data.h
+++ b/drivers/net/ipa/ipa_data.h
@@ -49,6 +49,22 @@
 #define IPA_RESOURCE_GROUP_SRC_MAX	5
 #define IPA_RESOURCE_GROUP_DST_MAX	5
 
+/** enum ipa_qsb_master_id - array index for IPA QSB configuration data */
+enum ipa_qsb_master_id {
+	IPA_QSB_MASTER_DDR,
+	IPA_QSB_MASTER_PCIE,
+};
+
+/**
+ * struct ipa_qsb_data - Qualcomm System Bus configuration data
+ * @max_writes:	Maximum outstanding write requests for this master
+ * @max_reads:	Maximum outstanding read requests for this master
+ */
+struct ipa_qsb_data {
+	u8 max_writes;
+	u8 max_reads;
+};
+
 /**
  * struct gsi_channel_data - GSI channel configuration data
  * @tre_count:		number of TREs in the channel ring
@@ -285,14 +301,18 @@ struct ipa_clock_data {
 /**
  * struct ipa_data - combined IPA/GSI configuration data
  * @version:		IPA hardware version
- * @endpoint_count:	number of entries in endpoint_data array
+ * @qsb_count:		number of entries in the qsb_data array
+ * @qsb_data:		Qualcomm System Bus configuration data
+ * @endpoint_count:	number of entries in the endpoint_data array
  * @endpoint_data:	IPA endpoint/GSI channel data
  * @resource_data:	IPA resource configuration data
- * @mem_count:		number of entries in mem_data array
+ * @mem_count:		number of entries in the mem_data array
  * @mem_data:		IPA-local shared memory region data
  */
 struct ipa_data {
 	enum ipa_version version;
+	u32 qsb_count;		/* # entries in qsb_data[] */
+	const struct ipa_qsb_data *qsb_data;
 	u32 endpoint_count;	/* # entries in endpoint_data[] */
 	const struct ipa_gsi_endpoint_data *endpoint_data;
 	const struct ipa_resource_data *resource_data;
-- 
2.27.0

