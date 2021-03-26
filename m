Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75E9634AB0F
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 16:12:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230505AbhCZPML (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 11:12:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230240AbhCZPLc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 11:11:32 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2F5DC0613B1
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 08:11:31 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id r8so5291763ilo.8
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 08:11:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sC24X9eVETwq1UezdzZlfsOF0sx5rw5KK7vWBUXE6Qw=;
        b=a1DLZNjXzLglvrjS707eab2z4YMmQqszsW+Qkqf8QxRSpabUnPDUO2Upakkswdvc6G
         Z/mQMQ88Rm8n2456b4oIKhQ2JCQwj7EbptIgAFd8In594QEC50uXB1U5+6rz6DL/ANz/
         wZ3tHc8itohB0cCBiDi9VoO5wfeG/zywquPdSAiUAw3DLAxzDA4y5d40flB8JIUdF26Z
         mMjn8/pYVr9dgbd4lPzrG9uiS69YLl+lfbzM4BNKex9mNgbhY8WTgKKx6fQ0/7Cej45+
         dbfaDIm7zhu3DzYRRvWONF9an0qKcTRiRu8i7mnKAxe+43ZL0pU3MGkOoRVfiLCsyHFk
         vgRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sC24X9eVETwq1UezdzZlfsOF0sx5rw5KK7vWBUXE6Qw=;
        b=jWaIvOiquhy+799W0wgYmdlZViIPQvBW+s2sFy/1x1UuPL+n6gTaCMmv5MQPk1KD7x
         AU3nAAiKbQUZXuUDjMwAe46cDFAfXZh3hW94RHyScEfJyPeKjeGAbJa+gtjUu1ZZxM0b
         XqpxODJvO0Pq1dX/rH9Tim8/J+vPA5zkCB6segC/O6dcVq3U3mJanlmkJHU/39uXL38K
         y++/V0K5d0noNTTbP8YNk/N6J7cg1cYeeC0CEwCM/ieDe/TiDZMNzyTQQ8vtInbN4R8x
         JHc9H2iK8sYpk2OQKsDVOfamhB0/P2vJ/MtKiNaG50piuNCuqJh4kzvKeWpAmPtKiblX
         7KkQ==
X-Gm-Message-State: AOAM531IuGRpRycOqbiRmbhQeEup6cu7aW9Jq9tItDD4gtaPSog+IBLo
        oMmtgiIPLn5rTkfqh/06iVsrIg==
X-Google-Smtp-Source: ABdhPJykgPIydnVZ654PTLD7tp5Keszfc2ORXYplRWi+IwZNF+eRCYnaAWUjht9G/5pd1P4UUPdWxA==
X-Received: by 2002:a05:6e02:1564:: with SMTP id k4mr10575019ilu.65.1616771491284;
        Fri, 26 Mar 2021 08:11:31 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id j17sm4537706iok.37.2021.03.26.08.11.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 08:11:30 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 05/12] net: ipa: combine resource type definitions
Date:   Fri, 26 Mar 2021 10:11:15 -0500
Message-Id: <20210326151122.3121383-6-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210326151122.3121383-1-elder@linaro.org>
References: <20210326151122.3121383-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Combine the ipa_resource_type_src and ipa_resource_type_dst
enumerated types into a single enumerated type, ipa_resource_type.

Assign value 0 to the first element for the source and destination
types, so their numeric values are preserved.  Add some additional
commentary where these are defined, stating explicitly that code
assumes the first source and first destination member must have
numeric value 0.

Fix the kerneldoc comments for the ipa_gsi_endpoint_data structure.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_data.h | 31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ipa/ipa_data.h b/drivers/net/ipa/ipa_data.h
index 7816583fc14aa..ccd7fd0b801aa 100644
--- a/drivers/net/ipa/ipa_data.h
+++ b/drivers/net/ipa/ipa_data.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 
 /* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
- * Copyright (C) 2019-2020 Linaro Ltd.
+ * Copyright (C) 2019-2021 Linaro Ltd.
  */
 #ifndef _IPA_DATA_H_
 #define _IPA_DATA_H_
@@ -177,12 +177,12 @@ struct ipa_endpoint_data {
 
 /**
  * struct ipa_gsi_endpoint_data - GSI channel/IPA endpoint data
- * ee:		GSI execution environment ID
- * channel_id:	GSI channel ID
- * endpoint_id:	IPA endpoint ID
- * toward_ipa:	direction of data transfer
- * gsi:		GSI channel configuration data (see above)
- * ipa:		IPA endpoint configuration data (see above)
+ * @ee_id:	GSI execution environment ID
+ * @channel_id:	GSI channel ID
+ * @endpoint_id: IPA endpoint ID
+ * @toward_ipa:	direction of data transfer
+ * @channel:	GSI channel configuration data (see above)
+ * @endpoint:	IPA endpoint configuration data (see above)
  */
 struct ipa_gsi_endpoint_data {
 	u8 ee_id;		/* enum gsi_ee_id */
@@ -194,18 +194,17 @@ struct ipa_gsi_endpoint_data {
 	struct ipa_endpoint_data endpoint;
 };
 
-/** enum ipa_resource_type_src - source resource types */
-enum ipa_resource_type_src {
-	IPA_RESOURCE_TYPE_SRC_PKT_CONTEXTS,
+/** enum ipa_resource_type - IPA resource types */
+enum ipa_resource_type {
+	/* Source resource types; first must have value 0 */
+	IPA_RESOURCE_TYPE_SRC_PKT_CONTEXTS		= 0,
 	IPA_RESOURCE_TYPE_SRC_DESCRIPTOR_LISTS,
 	IPA_RESOURCE_TYPE_SRC_DESCRIPTOR_BUFF,
 	IPA_RESOURCE_TYPE_SRC_HPS_DMARS,
 	IPA_RESOURCE_TYPE_SRC_ACK_ENTRIES,
-};
 
-/** enum ipa_resource_type_dst - destination resource types */
-enum ipa_resource_type_dst {
-	IPA_RESOURCE_TYPE_DST_DATA_SECTORS,
+	/* Destination resource types; first must have value 0 */
+	IPA_RESOURCE_TYPE_DST_DATA_SECTORS		= 0,
 	IPA_RESOURCE_TYPE_DST_DPS_DMARS,
 };
 
@@ -225,7 +224,7 @@ struct ipa_resource_limits {
  * @limits:	array of limits to use for each resource group
  */
 struct ipa_resource_src {
-	enum ipa_resource_type_src type;
+	enum ipa_resource_type type;	/* IPA_RESOURCE_TYPE_SRC_* */
 	struct ipa_resource_limits limits[IPA_RESOURCE_GROUP_SRC_MAX];
 };
 
@@ -235,7 +234,7 @@ struct ipa_resource_src {
  * @limits:	array of limits to use for each resource group
  */
 struct ipa_resource_dst {
-	enum ipa_resource_type_dst type;
+	enum ipa_resource_type type;	/* IPA_RESOURCE_TYPE_DST_* */
 	struct ipa_resource_limits limits[IPA_RESOURCE_GROUP_DST_MAX];
 };
 
-- 
2.27.0

