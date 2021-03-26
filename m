Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B12934AB11
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 16:12:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbhCZPMN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 11:12:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230329AbhCZPLe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 11:11:34 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A96C0C0613AA
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 08:11:33 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id x17so5737356iog.2
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 08:11:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=d6nn2zLKWR0hFTH8zPwibjMvpmzqL8ByDIyW+9Wf32M=;
        b=lPePDFyaeOfIjTrWvk5nsN2PgFGWiNt014D4uETe+MZ7iceHHEdB2X8FCtZzuw6akH
         Sgf6XvYB1vfJdqdi/ea4kaRBc41zkXyGmnp6s8siCMQJwgS7x1Iq8mZOI8dQC4I0IuwH
         D20Ra4cZR+4ooclsSBF+y+LG2NvYT/XwYwdLUE3Fva8yCaO1Y84iR1lmjgSCWtIMemna
         3+JF76ZWOnJKu8p6DI3dVQcW6i4WCYxWK0N7dm09vsS+GANP2wjBAtRmbR9JRaySoPsA
         POWzDa9iRqn6SXA00iYcTFxB3dCXTQvd6utAfyyGO5uA9mCbwqVNrrdl4jQ1qE39w1YQ
         Qz/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=d6nn2zLKWR0hFTH8zPwibjMvpmzqL8ByDIyW+9Wf32M=;
        b=t3xj5bsAvs3H+HwJKGOjxGTojHZnuS2HE/9YrEOA+zUZibpGWISqq5jj9y4JNfvURE
         LcaTrE3vsPq4csjPB0wD/43Uo1HdnQ/h/qUa2RwQm7T38Te0gR5UXTEzPyFsfuBBNK6u
         bCEBB3e0UzaoAb0Fk0rTYceoIehMWen83GIJbKf1l2aPS64HpFWLzZhddBKD8tbn0EJp
         hpAz9xGV6st5DxGaxoiwnP3siaDaD7JJ4DGYru1rJ3I6mVg8zzS10AUKaNwiJIf+U7Kb
         xL9qErelF5jxACy1jYaayCijx5TUMGsCeFpP+wNUoQm3DSwl1montisNqIahct69xHyr
         f3nA==
X-Gm-Message-State: AOAM531RVdTbWhinX5o08II+IXZ1rY4hfIDq0HRLIiP7ieQCKlGj/QKa
        MUJAlH4qv5u4Nfzr51xb79JpAQ==
X-Google-Smtp-Source: ABdhPJyCNvG245pafjvFur+mNDWe5ALvrOUvGVn72cFsqYm/8LeJ0O5M2mTSrcDq/PkOcMkPvMf0nA==
X-Received: by 2002:a05:6638:1914:: with SMTP id p20mr12340457jal.92.1616771493155;
        Fri, 26 Mar 2021 08:11:33 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id j17sm4537706iok.37.2021.03.26.08.11.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 08:11:32 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 07/12] net: ipa: move ipa_resource_type definition
Date:   Fri, 26 Mar 2021 10:11:17 -0500
Message-Id: <20210326151122.3121383-8-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210326151122.3121383-1-elder@linaro.org>
References: <20210326151122.3121383-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Most platforms have the same set of source and destination resource
types.  But some older platforms have some additional ones, and it's
possible different resources will be used in the future.

Move the definition of the ipa_resource_type enumerated type so it
is defined for each platform in its configuration data file.  This
permits each to have a distinct set of resources.

Shorten the data files slightly, by putting the min and max limit
values on the same line.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_data-sc7180.c | 35 ++++++++------
 drivers/net/ipa/ipa_data-sdm845.c | 80 ++++++++++++++-----------------
 drivers/net/ipa/ipa_data.h        | 14 ------
 3 files changed, 57 insertions(+), 72 deletions(-)

diff --git a/drivers/net/ipa/ipa_data-sc7180.c b/drivers/net/ipa/ipa_data-sc7180.c
index eba14d7bc8ac3..24ff315175653 100644
--- a/drivers/net/ipa/ipa_data-sc7180.c
+++ b/drivers/net/ipa/ipa_data-sc7180.c
@@ -9,6 +9,20 @@
 #include "ipa_endpoint.h"
 #include "ipa_mem.h"
 
+/** enum ipa_resource_type - IPA resource types */
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
 /* Resource groups used for the SC7180 SoC */
 enum ipa_rsrc_group_id {
 	/* Source resource group identifiers */
@@ -152,32 +166,27 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 static const struct ipa_resource_src ipa_resource_src[] = {
 	[IPA_RESOURCE_TYPE_SRC_PKT_CONTEXTS] = {
 		.limits[IPA_RSRC_GROUP_SRC_UL_DL] = {
-			.min = 3,
-			.max = 63,
+			.min = 3,	.max = 63,
 		},
 	},
 	[IPA_RESOURCE_TYPE_SRC_DESCRIPTOR_LISTS] = {
 		.limits[IPA_RSRC_GROUP_SRC_UL_DL] = {
-			.min = 3,
-			.max = 3,
+			.min = 3,	.max = 3,
 		},
 	},
 	[IPA_RESOURCE_TYPE_SRC_DESCRIPTOR_BUFF] = {
 		.limits[IPA_RSRC_GROUP_SRC_UL_DL] = {
-			.min = 10,
-			.max = 10,
+			.min = 10,	.max = 10,
 		},
 	},
 	[IPA_RESOURCE_TYPE_SRC_HPS_DMARS] = {
 		.limits[IPA_RSRC_GROUP_SRC_UL_DL] = {
-			.min = 1,
-			.max = 1,
+			.min = 1,	.max = 1,
 		},
 	},
 	[IPA_RESOURCE_TYPE_SRC_ACK_ENTRIES] = {
 		.limits[IPA_RSRC_GROUP_SRC_UL_DL] = {
-			.min = 5,
-			.max = 5,
+			.min = 5,	.max = 5,
 		},
 	},
 };
@@ -186,14 +195,12 @@ static const struct ipa_resource_src ipa_resource_src[] = {
 static const struct ipa_resource_dst ipa_resource_dst[] = {
 	[IPA_RESOURCE_TYPE_DST_DATA_SECTORS] = {
 		.limits[IPA_RSRC_GROUP_DST_UL_DL_DPL] = {
-			.min = 3,
-			.max = 3,
+			.min = 3,	.max = 3,
 		},
 	},
 	[IPA_RESOURCE_TYPE_DST_DPS_DMARS] = {
 		.limits[IPA_RSRC_GROUP_DST_UL_DL_DPL] = {
-			.min = 1,
-			.max = 63,
+			.min = 1,	.max = 63,
 		},
 	},
 };
diff --git a/drivers/net/ipa/ipa_data-sdm845.c b/drivers/net/ipa/ipa_data-sdm845.c
index 4a4b3bd8a17c0..357e8ba43a364 100644
--- a/drivers/net/ipa/ipa_data-sdm845.c
+++ b/drivers/net/ipa/ipa_data-sdm845.c
@@ -11,6 +11,20 @@
 #include "ipa_endpoint.h"
 #include "ipa_mem.h"
 
+/** enum ipa_resource_type - IPA resource types */
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
 /* Resource groups used for the SDM845 SoC */
 enum ipa_rsrc_group_id {
 	/* Source resource group identifiers */
@@ -170,76 +184,60 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 static const struct ipa_resource_src ipa_resource_src[] = {
 	[IPA_RESOURCE_TYPE_SRC_PKT_CONTEXTS] = {
 		.limits[IPA_RSRC_GROUP_SRC_LWA_DL] = {
-			.min = 1,
-			.max = 255,
+			.min = 1,	.max = 255,
 		},
 		.limits[IPA_RSRC_GROUP_SRC_UL_DL] = {
-			.min = 1,
-			.max = 255,
+			.min = 1,	.max = 255,
 		},
 		.limits[IPA_RSRC_GROUP_SRC_UC_RX_Q] = {
-			.min = 1,
-			.max = 63,
+			.min = 1,	.max = 63,
 		},
 	},
 	[IPA_RESOURCE_TYPE_SRC_DESCRIPTOR_LISTS] = {
 		.limits[IPA_RSRC_GROUP_SRC_LWA_DL] = {
-			.min = 10,
-			.max = 10,
+			.min = 10,	.max = 10,
 		},
 		.limits[IPA_RSRC_GROUP_SRC_UL_DL] = {
-			.min = 10,
-			.max = 10,
+			.min = 10,	.max = 10,
 		},
 		.limits[IPA_RSRC_GROUP_SRC_UC_RX_Q] = {
-			.min = 8,
-			.max = 8,
+			.min = 8,	.max = 8,
 		},
 	},
 	[IPA_RESOURCE_TYPE_SRC_DESCRIPTOR_BUFF] = {
 		.limits[IPA_RSRC_GROUP_SRC_LWA_DL] = {
-			.min = 12,
-			.max = 12,
+			.min = 12,	.max = 12,
 		},
 		.limits[IPA_RSRC_GROUP_SRC_UL_DL] = {
-			.min = 14,
-			.max = 14,
+			.min = 14,	.max = 14,
 		},
 		.limits[IPA_RSRC_GROUP_SRC_UC_RX_Q] = {
-			.min = 8,
-			.max = 8,
+			.min = 8,	.max = 8,
 		},
 	},
 	[IPA_RESOURCE_TYPE_SRC_HPS_DMARS] = {
 		.limits[IPA_RSRC_GROUP_SRC_LWA_DL] = {
-			.min = 0,
-			.max = 63,
+			.min = 0,	.max = 63,
 		},
 		.limits[IPA_RSRC_GROUP_SRC_UL_DL] = {
-			.min = 0,
-			.max = 63,
+			.min = 0,	.max = 63,
 		},
 		.limits[IPA_RSRC_GROUP_SRC_MHI_DMA] = {
-			.min = 0,
-			.max = 63,
+			.min = 0,	.max = 63,
 		},
 		.limits[IPA_RSRC_GROUP_SRC_UC_RX_Q] = {
-			.min = 0,
-			.max = 63,
+			.min = 0,	.max = 63,
 		},
 	},
 	[IPA_RESOURCE_TYPE_SRC_ACK_ENTRIES] = {
 		.limits[IPA_RSRC_GROUP_SRC_LWA_DL] = {
-			.min = 14,
-			.max = 14,
+			.min = 14,	.max = 14,
 		},
 		.limits[IPA_RSRC_GROUP_SRC_UL_DL] = {
-			.min = 20,
-			.max = 20,
+			.min = 20,	.max = 20,
 		},
 		.limits[IPA_RSRC_GROUP_SRC_UC_RX_Q] = {
-			.min = 14,
-			.max = 14,
+			.min = 14,	.max = 14,
 		},
 	},
 };
@@ -248,30 +246,24 @@ static const struct ipa_resource_src ipa_resource_src[] = {
 static const struct ipa_resource_dst ipa_resource_dst[] = {
 	[IPA_RESOURCE_TYPE_DST_DATA_SECTORS] = {
 		.limits[IPA_RSRC_GROUP_DST_LWA_DL] = {
-			.min = 4,
-			.max = 4,
+			.min = 4,	.max = 4,
 		},
 		.limits[1] = {
-			.min = 4,
-			.max = 4,
+			.min = 4,	.max = 4,
 		},
 		.limits[IPA_RSRC_GROUP_DST_UNUSED_2] = {
-			.min = 3,
-			.max = 3,
+			.min = 3,	.max = 3,
 		}
 	},
 	[IPA_RESOURCE_TYPE_DST_DPS_DMARS] = {
 		.limits[IPA_RSRC_GROUP_DST_LWA_DL] = {
-			.min = 2,
-			.max = 63,
+			.min = 2,	.max = 63,
 		},
 		.limits[IPA_RSRC_GROUP_DST_UL_DL_DPL] = {
-			.min = 1,
-			.max = 63,
+			.min = 1,	.max = 63,
 		},
 		.limits[IPA_RSRC_GROUP_DST_UNUSED_2] = {
-			.min = 1,
-			.max = 2,
+			.min = 1,	.max = 2,
 		}
 	},
 };
diff --git a/drivers/net/ipa/ipa_data.h b/drivers/net/ipa/ipa_data.h
index 44b93f93ee608..e1096d8ba5751 100644
--- a/drivers/net/ipa/ipa_data.h
+++ b/drivers/net/ipa/ipa_data.h
@@ -194,20 +194,6 @@ struct ipa_gsi_endpoint_data {
 	struct ipa_endpoint_data endpoint;
 };
 
-/** enum ipa_resource_type - IPA resource types */
-enum ipa_resource_type {
-	/* Source resource types; first must have value 0 */
-	IPA_RESOURCE_TYPE_SRC_PKT_CONTEXTS		= 0,
-	IPA_RESOURCE_TYPE_SRC_DESCRIPTOR_LISTS,
-	IPA_RESOURCE_TYPE_SRC_DESCRIPTOR_BUFF,
-	IPA_RESOURCE_TYPE_SRC_HPS_DMARS,
-	IPA_RESOURCE_TYPE_SRC_ACK_ENTRIES,
-
-	/* Destination resource types; first must have value 0 */
-	IPA_RESOURCE_TYPE_DST_DATA_SECTORS		= 0,
-	IPA_RESOURCE_TYPE_DST_DPS_DMARS,
-};
-
 /**
  * struct ipa_resource_limits - minimum and maximum resource counts
  * @min:	minimum number of resources of a given type
-- 
2.27.0

