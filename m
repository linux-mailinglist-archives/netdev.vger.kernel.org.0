Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8644135A540
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 20:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234377AbhDISHx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 14:07:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234510AbhDISHo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 14:07:44 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15946C061762
        for <netdev@vger.kernel.org>; Fri,  9 Apr 2021 11:07:31 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id e186so6795544iof.7
        for <netdev@vger.kernel.org>; Fri, 09 Apr 2021 11:07:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=txa2iok90+y/pvPIZBlzCT/IEohPrGV3y36Mz3PtV64=;
        b=aUv8EWTzIsjPL4rqCmm9cuSj8dZK6mnibC+lCQ4zx0lHTGkZnVLhOclHsC23P3KSQO
         ULnOsw2UX7aDYH70sggtqawxxEtp0pvWqNtr0ecJaufTdeA+fuISu92hEGBcyhyani5F
         QLjprdtVi1NlkxosnPQr5/JK/mBU/HhPoJCQUFCfBeBODBP8bBhqYpJY6BwyQRbrgI8c
         CU7+kB2fx/FEG12IL8AC8l7/FSDsxlmT9LSETaUYiRv5lMyZDAk4fhXIyg/jGHtjwRN/
         vrkwgqDl7+H+qxgYEWZUeevqF1Srs43kBFAvjqpuQw7bUWUz68WeNk1VXvSBW8O/Z3Ca
         91rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=txa2iok90+y/pvPIZBlzCT/IEohPrGV3y36Mz3PtV64=;
        b=bsVOjR6Nu7qlvTsB3y4MLNBPPsubXvp/ORwVNJ6ao2ew/eJEEFwf3VWn/wcN7D4SZP
         cszDZjwjmmVD9c4Npe6MJQPQlPv1ep2LYixCUXk9FWZrUSGzpv9XdQL9uKiwny9MWluq
         xK347CTLxFNjaDGNHOVvNDPFy4X81bZh/q2w5ky7A0/sbeDAIk85OKWLOw9z5XkyGDvD
         28mWPQWkqesMleoQ/Cc0jIws5wOY3D7J9WGmOYs1oa5l4i/jdmlhvsfFMsCzjTTLWq4w
         n3VxqVEzTyHHIx+mxF+sCZbx5fxk9up/PRJIJpq0IVJXEIvFgpphLYUJtEUtJWD9eSct
         NvpA==
X-Gm-Message-State: AOAM5330L8oEP4mDLJl6iq+gSsHmVKj14vERs2E1fxj6HZjXm/8K0kY1
        NXSCd+c3stEhgmQF6dtHKfDwJQ==
X-Google-Smtp-Source: ABdhPJz0P/ys8iLE0roHraKKW2Nma2MYmC9/w4K7hqGvrZaoMUeGAK/VUQOg4pofDmGN39R1X+xlxw==
X-Received: by 2002:a05:6638:3a8:: with SMTP id z8mr15834642jap.111.1617991650507;
        Fri, 09 Apr 2021 11:07:30 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id g12sm1412786ile.71.2021.04.09.11.07.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Apr 2021 11:07:30 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 5/7] net: ipa: get rid of empty IPA functions
Date:   Fri,  9 Apr 2021 13:07:20 -0500
Message-Id: <20210409180722.1176868-6-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210409180722.1176868-1-elder@linaro.org>
References: <20210409180722.1176868-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are place holder functions in the IPA code that do nothing.
For the most part these are inverse functions, for example, once the
routing or filter tables are set up there is no need to perform any
matching teardown activity at shutdown, or in the case of an error.

These can be safely removed, resulting in some code simplification.
Add comments in these spots making it explicit that there is no
inverse.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_main.c     | 29 +++++++++--------------------
 drivers/net/ipa/ipa_mem.c      |  9 +++------
 drivers/net/ipa/ipa_mem.h      |  5 ++---
 drivers/net/ipa/ipa_resource.c |  8 +-------
 drivers/net/ipa/ipa_resource.h |  8 ++------
 drivers/net/ipa/ipa_table.c    | 26 +++-----------------------
 drivers/net/ipa/ipa_table.h    | 16 ++++------------
 7 files changed, 24 insertions(+), 77 deletions(-)

diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index a970d10e650ef..bfed151f5d6dc 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -147,13 +147,13 @@ int ipa_setup(struct ipa *ipa)
 	if (ret)
 		goto err_endpoint_teardown;
 
-	ret = ipa_mem_setup(ipa);
+	ret = ipa_mem_setup(ipa);	/* No matching teardown required */
 	if (ret)
 		goto err_command_disable;
 
-	ret = ipa_table_setup(ipa);
+	ret = ipa_table_setup(ipa);	/* No matching teardown required */
 	if (ret)
-		goto err_mem_teardown;
+		goto err_command_disable;
 
 	/* Enable the exception handling endpoint, and tell the hardware
 	 * to use it by default.
@@ -161,7 +161,7 @@ int ipa_setup(struct ipa *ipa)
 	exception_endpoint = ipa->name_map[IPA_ENDPOINT_AP_LAN_RX];
 	ret = ipa_endpoint_enable_one(exception_endpoint);
 	if (ret)
-		goto err_table_teardown;
+		goto err_command_disable;
 
 	ipa_endpoint_default_route_set(ipa, exception_endpoint->endpoint_id);
 
@@ -179,10 +179,6 @@ int ipa_setup(struct ipa *ipa)
 err_default_route_clear:
 	ipa_endpoint_default_route_clear(ipa);
 	ipa_endpoint_disable_one(exception_endpoint);
-err_table_teardown:
-	ipa_table_teardown(ipa);
-err_mem_teardown:
-	ipa_mem_teardown(ipa);
 err_command_disable:
 	ipa_endpoint_disable_one(command_endpoint);
 err_endpoint_teardown:
@@ -211,8 +207,6 @@ static void ipa_teardown(struct ipa *ipa)
 	ipa_endpoint_default_route_clear(ipa);
 	exception_endpoint = ipa->name_map[IPA_ENDPOINT_AP_LAN_RX];
 	ipa_endpoint_disable_one(exception_endpoint);
-	ipa_table_teardown(ipa);
-	ipa_mem_teardown(ipa);
 	command_endpoint = ipa->name_map[IPA_ENDPOINT_AP_COMMAND_TX];
 	ipa_endpoint_disable_one(command_endpoint);
 	ipa_endpoint_teardown(ipa);
@@ -480,23 +474,20 @@ static int ipa_config(struct ipa *ipa, const struct ipa_data *data)
 	if (ret)
 		goto err_endpoint_deconfig;
 
-	ipa_table_config(ipa);
+	ipa_table_config(ipa);		/* No deconfig required */
 
-	/* Assign resource limitation to each group */
+	/* Assign resource limitation to each group; no deconfig required */
 	ret = ipa_resource_config(ipa, data->resource_data);
 	if (ret)
-		goto err_table_deconfig;
+		goto err_mem_deconfig;
 
 	ret = ipa_modem_config(ipa);
 	if (ret)
-		goto err_resource_deconfig;
+		goto err_mem_deconfig;
 
 	return 0;
 
-err_resource_deconfig:
-	ipa_resource_deconfig(ipa);
-err_table_deconfig:
-	ipa_table_deconfig(ipa);
+err_mem_deconfig:
 	ipa_mem_deconfig(ipa);
 err_endpoint_deconfig:
 	ipa_endpoint_deconfig(ipa);
@@ -514,8 +505,6 @@ static int ipa_config(struct ipa *ipa, const struct ipa_data *data)
 static void ipa_deconfig(struct ipa *ipa)
 {
 	ipa_modem_deconfig(ipa);
-	ipa_resource_deconfig(ipa);
-	ipa_table_deconfig(ipa);
 	ipa_mem_deconfig(ipa);
 	ipa_endpoint_deconfig(ipa);
 	ipa_hardware_deconfig(ipa);
diff --git a/drivers/net/ipa/ipa_mem.c b/drivers/net/ipa/ipa_mem.c
index 32907dde5dc6a..c5c3b1b7e67d5 100644
--- a/drivers/net/ipa/ipa_mem.c
+++ b/drivers/net/ipa/ipa_mem.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 
 /* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
- * Copyright (C) 2019-2020 Linaro Ltd.
+ * Copyright (C) 2019-2021 Linaro Ltd.
  */
 
 #include <linux/types.h>
@@ -53,6 +53,8 @@ ipa_mem_zero_region_add(struct gsi_trans *trans, const struct ipa_mem *mem)
  * The AP informs the modem where its portions of memory are located
  * in a QMI exchange that occurs at modem startup.
  *
+ * There is no need for a matching ipa_mem_teardown() function.
+ *
  * Return:	0 if successful, or a negative error code
  */
 int ipa_mem_setup(struct ipa *ipa)
@@ -97,11 +99,6 @@ int ipa_mem_setup(struct ipa *ipa)
 	return 0;
 }
 
-void ipa_mem_teardown(struct ipa *ipa)
-{
-	/* Nothing to do */
-}
-
 #ifdef IPA_VALIDATE
 
 static bool ipa_mem_valid(struct ipa *ipa, enum ipa_mem_id mem_id)
diff --git a/drivers/net/ipa/ipa_mem.h b/drivers/net/ipa/ipa_mem.h
index df61ef48df365..9ca8a47bd4afd 100644
--- a/drivers/net/ipa/ipa_mem.h
+++ b/drivers/net/ipa/ipa_mem.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 
 /* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
- * Copyright (C) 2019-2020 Linaro Ltd.
+ * Copyright (C) 2019-2021 Linaro Ltd.
  */
 #ifndef _IPA_MEM_H_
 #define _IPA_MEM_H_
@@ -88,8 +88,7 @@ struct ipa_mem {
 int ipa_mem_config(struct ipa *ipa);
 void ipa_mem_deconfig(struct ipa *ipa);
 
-int ipa_mem_setup(struct ipa *ipa);
-void ipa_mem_teardown(struct ipa *ipa);
+int ipa_mem_setup(struct ipa *ipa);	/* No ipa_mem_teardown() needed */
 
 int ipa_mem_zero_modem(struct ipa *ipa);
 
diff --git a/drivers/net/ipa/ipa_resource.c b/drivers/net/ipa/ipa_resource.c
index 85f922d6f222f..3b2dc216d3a68 100644
--- a/drivers/net/ipa/ipa_resource.c
+++ b/drivers/net/ipa/ipa_resource.c
@@ -158,7 +158,7 @@ static void ipa_resource_config_dst(struct ipa *ipa, u32 resource_type,
 	ipa_resource_config_common(ipa, offset, &resource->limits[6], ylimits);
 }
 
-/* Configure resources */
+/* Configure resources; there is no ipa_resource_deconfig() */
 int ipa_resource_config(struct ipa *ipa, const struct ipa_resource_data *data)
 {
 	u32 i;
@@ -174,9 +174,3 @@ int ipa_resource_config(struct ipa *ipa, const struct ipa_resource_data *data)
 
 	return 0;
 }
-
-/* Inverse of ipa_resource_config() */
-void ipa_resource_deconfig(struct ipa *ipa)
-{
-	/* Nothing to do */
-}
diff --git a/drivers/net/ipa/ipa_resource.h b/drivers/net/ipa/ipa_resource.h
index 9f74036fb95c5..ef5818bff180d 100644
--- a/drivers/net/ipa/ipa_resource.h
+++ b/drivers/net/ipa/ipa_resource.h
@@ -14,14 +14,10 @@ struct ipa_resource_data;
  * @ipa:	IPA pointer
  * @data:	IPA resource configuration data
  *
+ * There is no need for a matching ipa_resource_deconfig() function.
+ *
  * Return:	true if all regions are valid, false otherwise
  */
 int ipa_resource_config(struct ipa *ipa, const struct ipa_resource_data *data);
 
-/**
- * ipa_resource_deconfig() - Inverse of ipa_resource_config()
- * @ipa:	IPA pointer
- */
-void ipa_resource_deconfig(struct ipa *ipa);
-
 #endif /* _IPA_RESOURCE_H_ */
diff --git a/drivers/net/ipa/ipa_table.c b/drivers/net/ipa/ipa_table.c
index 401b568df6a34..3168d72f42450 100644
--- a/drivers/net/ipa/ipa_table.c
+++ b/drivers/net/ipa/ipa_table.c
@@ -497,11 +497,6 @@ int ipa_table_setup(struct ipa *ipa)
 	return 0;
 }
 
-void ipa_table_teardown(struct ipa *ipa)
-{
-	/* Nothing to do */	/* XXX Maybe reset the tables? */
-}
-
 /**
  * ipa_filter_tuple_zero() - Zero an endpoint's hashed filter tuple
  * @endpoint:	Endpoint whose filter hash tuple should be zeroed
@@ -525,6 +520,7 @@ static void ipa_filter_tuple_zero(struct ipa_endpoint *endpoint)
 	iowrite32(val, endpoint->ipa->reg_virt + offset);
 }
 
+/* Configure a hashed filter table; there is no ipa_filter_deconfig() */
 static void ipa_filter_config(struct ipa *ipa, bool modem)
 {
 	enum gsi_ee_id ee_id = modem ? GSI_EE_MODEM : GSI_EE_AP;
@@ -545,11 +541,6 @@ static void ipa_filter_config(struct ipa *ipa, bool modem)
 	}
 }
 
-static void ipa_filter_deconfig(struct ipa *ipa, bool modem)
-{
-	/* Nothing to do */
-}
-
 static bool ipa_route_id_modem(u32 route_id)
 {
 	return route_id >= IPA_ROUTE_MODEM_MIN &&
@@ -576,6 +567,7 @@ static void ipa_route_tuple_zero(struct ipa *ipa, u32 route_id)
 	iowrite32(val, ipa->reg_virt + offset);
 }
 
+/* Configure a hashed route table; there is no ipa_route_deconfig() */
 static void ipa_route_config(struct ipa *ipa, bool modem)
 {
 	u32 route_id;
@@ -588,11 +580,7 @@ static void ipa_route_config(struct ipa *ipa, bool modem)
 			ipa_route_tuple_zero(ipa, route_id);
 }
 
-static void ipa_route_deconfig(struct ipa *ipa, bool modem)
-{
-	/* Nothing to do */
-}
-
+/* Configure a filter and route tables; there is no ipa_table_deconfig() */
 void ipa_table_config(struct ipa *ipa)
 {
 	ipa_filter_config(ipa, false);
@@ -601,14 +589,6 @@ void ipa_table_config(struct ipa *ipa)
 	ipa_route_config(ipa, true);
 }
 
-void ipa_table_deconfig(struct ipa *ipa)
-{
-	ipa_route_deconfig(ipa, true);
-	ipa_route_deconfig(ipa, false);
-	ipa_filter_deconfig(ipa, true);
-	ipa_filter_deconfig(ipa, false);
-}
-
 /*
  * Initialize a coherent DMA allocation containing initialized filter and
  * route table data.  This is used when initializing or resetting the IPA
diff --git a/drivers/net/ipa/ipa_table.h b/drivers/net/ipa/ipa_table.h
index 018045b95aad8..1e2be9fce2f81 100644
--- a/drivers/net/ipa/ipa_table.h
+++ b/drivers/net/ipa/ipa_table.h
@@ -74,27 +74,19 @@ int ipa_table_hash_flush(struct ipa *ipa);
 /**
  * ipa_table_setup() - Set up filter and route tables
  * @ipa:	IPA pointer
+ *
+ * There is no need for a matching ipa_table_teardown() function.
  */
 int ipa_table_setup(struct ipa *ipa);
 
-/**
- * ipa_table_teardown() - Inverse of ipa_table_setup()
- * @ipa:	IPA pointer
- */
-void ipa_table_teardown(struct ipa *ipa);
-
 /**
  * ipa_table_config() - Configure filter and route tables
  * @ipa:	IPA pointer
+ *
+ * There is no need for a matching ipa_table_deconfig() function.
  */
 void ipa_table_config(struct ipa *ipa);
 
-/**
- * ipa_table_deconfig() - Inverse of ipa_table_config()
- * @ipa:	IPA pointer
- */
-void ipa_table_deconfig(struct ipa *ipa);
-
 /**
  * ipa_table_init() - Do early initialization of filter and route tables
  * @ipa:	IPA pointer
-- 
2.27.0

