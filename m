Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0681834AB19
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 16:12:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231235AbhCZPMY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 11:12:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230046AbhCZPLi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 11:11:38 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42AB8C0613AA
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 08:11:38 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id u10so5363403ilb.0
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 08:11:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9ZnJjMZ3j1jPK7KyRsp3AHHKqIeEkct5/pc3t9X9wys=;
        b=L15UEagCnDLpE6eOQf1L+E3tQwhY+xffEXGrsTI7J7yQLZvaiBtsixRtCpc4YJI4DR
         RLpp4hituhJQbFKNgQbgoIpP53kUtR+wpNEu7HW32dmYnyZ95oHsHy2fH4lAQziRZBCf
         1R/YfCDfgjnv4EDY1Zq3B7BoD/NShraqFjArRIWFdV96GlxoD8oiKpGhM09qUpL1gApM
         qxEE1b7orHCCGrg02s6rACCHHVx4PjlWr/uw0/qcI8MMOI5EPchrA+zZNHmFaJ3LuzOO
         8es50kHcWercjS6jGVftQJssxVypISwcSkiapZKmsYOO1Rl+ujTVQZHqqj9BcvN/SN/E
         Rlcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9ZnJjMZ3j1jPK7KyRsp3AHHKqIeEkct5/pc3t9X9wys=;
        b=nK6J9NCMmtuKtplca4LrLwmsOT2R9J0iaO17byxfwA5NXLdLdTaxqPrU6+M7lIA5n9
         CxlNG06He8w1hnRX/TqrprDTdqVlQ47Ymnmm0il1FB54ZpIyxKVED6NdhZjqvNcyK+zt
         IxPmzzYg2J4OvZWN2IHAzLeqDmqQDwjc84OkBJN0AnVkLxtLUpByv2tSVh7J2ecxlT5Z
         73gBrnyVFf6LZzfxiyYDl5pWum9+DZKdReG+Tp48UlS1iw93xvIe9hkXocAMlPd2ugdf
         RziO4wMoSkTe5u9fjJ3riciPbo33tfL8LPskJl1jyb1Ose8PAjxWLD86n+l0/tDswGxc
         Xq8A==
X-Gm-Message-State: AOAM533CFMbmSaQj7D+iggrdmmk7365mUwWuic4bwjtfRaQSk0mPJ1/a
        sxT03Dbrg8njZNoC7P1Onm9E7fUJ9gviS7zN
X-Google-Smtp-Source: ABdhPJzQmfYKcVxnMSx/B7GrFjEZFqQfYJGrsDlms1yDgTTpWPyC7clq8NlQh3j0kge4szkZ2ehB/g==
X-Received: by 2002:a05:6e02:1ba5:: with SMTP id n5mr11350090ili.4.1616771497683;
        Fri, 26 Mar 2021 08:11:37 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id j17sm4537706iok.37.2021.03.26.08.11.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 08:11:37 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 12/12] net: ipa: support more than 6 resource groups
Date:   Fri, 26 Mar 2021 10:11:22 -0500
Message-Id: <20210326151122.3121383-13-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210326151122.3121383-1-elder@linaro.org>
References: <20210326151122.3121383-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IPA versions 3.0 and 3.1 support up to 8 resource groups.  There is
some interest in supporting these older versions of the hardware, so
update the resource configuration code to program resource limits
for these groups if specified.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_data.h     |  4 ++--
 drivers/net/ipa/ipa_reg.h      |  4 ++++
 drivers/net/ipa/ipa_resource.c | 18 ++++++++++++++++--
 3 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ipa/ipa_data.h b/drivers/net/ipa/ipa_data.h
index c5d763a3782fd..ea8f99286228e 100644
--- a/drivers/net/ipa/ipa_data.h
+++ b/drivers/net/ipa/ipa_data.h
@@ -46,8 +46,8 @@
  * the IPA endpoint.
  */
 
-/* The maximum value returned by ipa_resource_group_{src,dst}_count() */
-#define IPA_RESOURCE_GROUP_MAX	5
+/* The maximum possible number of source or destination resource groups */
+#define IPA_RESOURCE_GROUP_MAX	8
 
 /** enum ipa_qsb_master_id - array index for IPA QSB configuration data */
 enum ipa_qsb_master_id {
diff --git a/drivers/net/ipa/ipa_reg.h b/drivers/net/ipa/ipa_reg.h
index 9c798cef7b2e2..de2a944bad86b 100644
--- a/drivers/net/ipa/ipa_reg.h
+++ b/drivers/net/ipa/ipa_reg.h
@@ -353,12 +353,16 @@ enum ipa_pulse_gran {
 					(0x00000404 + 0x0020 * (rt))
 #define IPA_REG_SRC_RSRC_GRP_45_RSRC_TYPE_N_OFFSET(rt) \
 					(0x00000408 + 0x0020 * (rt))
+#define IPA_REG_SRC_RSRC_GRP_67_RSRC_TYPE_N_OFFSET(rt) \
+					(0x0000040c + 0x0020 * (rt))
 #define IPA_REG_DST_RSRC_GRP_01_RSRC_TYPE_N_OFFSET(rt) \
 					(0x00000500 + 0x0020 * (rt))
 #define IPA_REG_DST_RSRC_GRP_23_RSRC_TYPE_N_OFFSET(rt) \
 					(0x00000504 + 0x0020 * (rt))
 #define IPA_REG_DST_RSRC_GRP_45_RSRC_TYPE_N_OFFSET(rt) \
 					(0x00000508 + 0x0020 * (rt))
+#define IPA_REG_DST_RSRC_GRP_67_RSRC_TYPE_N_OFFSET(rt) \
+					(0x0000050c + 0x0020 * (rt))
 /* The next four fields are used for all resource group registers */
 #define X_MIN_LIM_FMASK				GENMASK(5, 0)
 #define X_MAX_LIM_FMASK				GENMASK(13, 8)
diff --git a/drivers/net/ipa/ipa_resource.c b/drivers/net/ipa/ipa_resource.c
index 578ff070d4055..85f922d6f222f 100644
--- a/drivers/net/ipa/ipa_resource.c
+++ b/drivers/net/ipa/ipa_resource.c
@@ -34,8 +34,8 @@ static bool ipa_resource_limits_valid(struct ipa *ipa,
 	u32 i;
 	u32 j;
 
-	/* We program at most 6 source or destination resource group limits */
-	BUILD_BUG_ON(IPA_RESOURCE_GROUP_MAX > 6);
+	/* We program at most 8 source or destination resource group limits */
+	BUILD_BUG_ON(IPA_RESOURCE_GROUP_MAX > 8);
 
 	group_count = data->rsrc_group_src_count;
 	if (!group_count || group_count > IPA_RESOURCE_GROUP_MAX)
@@ -113,6 +113,13 @@ static void ipa_resource_config_src(struct ipa *ipa, u32 resource_type,
 	offset = IPA_REG_SRC_RSRC_GRP_45_RSRC_TYPE_N_OFFSET(resource_type);
 	ylimits = group_count == 5 ? NULL : &resource->limits[5];
 	ipa_resource_config_common(ipa, offset, &resource->limits[4], ylimits);
+
+	if (group_count < 7)
+		return;
+
+	offset = IPA_REG_SRC_RSRC_GRP_67_RSRC_TYPE_N_OFFSET(resource_type);
+	ylimits = group_count == 7 ? NULL : &resource->limits[7];
+	ipa_resource_config_common(ipa, offset, &resource->limits[6], ylimits);
 }
 
 static void ipa_resource_config_dst(struct ipa *ipa, u32 resource_type,
@@ -142,6 +149,13 @@ static void ipa_resource_config_dst(struct ipa *ipa, u32 resource_type,
 	offset = IPA_REG_DST_RSRC_GRP_45_RSRC_TYPE_N_OFFSET(resource_type);
 	ylimits = group_count == 5 ? NULL : &resource->limits[5];
 	ipa_resource_config_common(ipa, offset, &resource->limits[4], ylimits);
+
+	if (group_count < 7)
+		return;
+
+	offset = IPA_REG_DST_RSRC_GRP_67_RSRC_TYPE_N_OFFSET(resource_type);
+	ylimits = group_count == 7 ? NULL : &resource->limits[7];
+	ipa_resource_config_common(ipa, offset, &resource->limits[6], ylimits);
 }
 
 /* Configure resources */
-- 
2.27.0

