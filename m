Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C0773461E8
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 15:53:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232299AbhCWOwv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 10:52:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232371AbhCWOvm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 10:51:42 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAF9FC061764
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 07:51:41 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id n21so17951506ioa.7
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 07:51:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qKrY3MtVV0SjI4PDoOYPSEatpvEs6DJpVc9j1EaE/t0=;
        b=xr5F6b0jzMcdtb25nE8qq+l1Lq9BZQ0TiuVgB5++E9JrA3X9c4TYPqg8HrSbjB1+jP
         Ovm/UizpzgVrhwVWkK8AhUh/aY0sYLQnXoy4SBiBEns0TU3X6OU6t0hv0mJkj76/o8QY
         SNxRbk60ua9cp6F6L3+p0vx3PUDMIVb1bFuzUgHMkp2/Fu0gM+MZmb5eDVzM69YydM0B
         MG6e7DVPu8efjfOX6NWu9AFR5EzGeuWmh/Y3BId2FtDAWOfefGW9LgaKonMkzf6DvcE4
         OCboA8VW0AJSYCmEstAAsFQaHahpt3dSbeWpJ2Jiq2oLOb4G/H53kXC45pccBzIx6nYn
         lg9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qKrY3MtVV0SjI4PDoOYPSEatpvEs6DJpVc9j1EaE/t0=;
        b=idgwj1fD06ZjFMJ2JgmCvIYvYOQt/8adR+AKPMNL5NseTM7h9+4xENKnLjC6BNpreE
         rzLhY+rxgbO12wzwro1hX7YyCs5kYDpM1hkak4za3FoTGwZ0L3CIX3vsUvojQDA5ozrY
         dXdhD1SNc0ElsKeM8I/GzeKcgis9jwf0Lz5SKi4ztpHiDhTyESk+zQzYMJCwhAbXeFAR
         ra1uO5ZYHKNtg4WGI7VdnaiPR925xmiyPItqaqUZxaveekc1o1ZsfIWRtJPfLzV89WYU
         3z0GnyomS2oJHjf1LETNAAI1sohbEhUAvfQ+U7/0QsAsC7Jv4KjSdHzwwuxE1oETnyC6
         6y4w==
X-Gm-Message-State: AOAM531iNX8qPcdxMSOyppvDam3FJM+WoGaJbze8tiBv49PBUk9Mav5i
        xbXsYX/Y5bAZ8keuP9N+F41fYg==
X-Google-Smtp-Source: ABdhPJz+Jy1m/FXq+SngoR4DIiWlUFWHB7giybpxdyupVe410iMlyxi0fharmg6Vi+EmUQj06gw62g==
X-Received: by 2002:a05:6638:58f:: with SMTP id a15mr4754658jar.35.1616511101089;
        Tue, 23 Mar 2021 07:51:41 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id o13sm8961147iob.17.2021.03.23.07.51.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Mar 2021 07:51:40 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/6] net: ipa: define the ENDP_INIT_NAT register
Date:   Tue, 23 Mar 2021 09:51:29 -0500
Message-Id: <20210323145132.2291316-4-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210323145132.2291316-1-elder@linaro.org>
References: <20210323145132.2291316-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define the ENDP_INIT_NAT register for setting up the NAT
configuration for an endpoint.  We aren't using NAT at this
time, so explicitly set the type to BYPASS for all endpoints.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_endpoint.c | 17 ++++++++++++++++-
 drivers/net/ipa/ipa_reg.h      | 14 +++++++++++++-
 2 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 5f93bd60c7586..38e83cd467b52 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 
 /* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
- * Copyright (C) 2019-2020 Linaro Ltd.
+ * Copyright (C) 2019-2021 Linaro Ltd.
  */
 
 #include <linux/types.h>
@@ -468,6 +468,20 @@ static void ipa_endpoint_init_cfg(struct ipa_endpoint *endpoint)
 	iowrite32(val, endpoint->ipa->reg_virt + offset);
 }
 
+static void ipa_endpoint_init_nat(struct ipa_endpoint *endpoint)
+{
+	u32 offset;
+	u32 val;
+
+	if (!endpoint->toward_ipa)
+		return;
+
+	offset = IPA_REG_ENDP_INIT_NAT_N_OFFSET(endpoint->endpoint_id);
+	val = u32_encode_bits(IPA_NAT_BYPASS, NAT_EN_FMASK);
+
+	iowrite32(val, endpoint->ipa->reg_virt + offset);
+}
+
 /**
  * ipa_endpoint_init_hdr() - Initialize HDR endpoint configuration register
  * @endpoint:	Endpoint pointer
@@ -1488,6 +1502,7 @@ static void ipa_endpoint_program(struct ipa_endpoint *endpoint)
 	else
 		(void)ipa_endpoint_program_suspend(endpoint, false);
 	ipa_endpoint_init_cfg(endpoint);
+	ipa_endpoint_init_nat(endpoint);
 	ipa_endpoint_init_hdr(endpoint);
 	ipa_endpoint_init_hdr_ext(endpoint);
 	ipa_endpoint_init_hdr_metadata_mask(endpoint);
diff --git a/drivers/net/ipa/ipa_reg.h b/drivers/net/ipa/ipa_reg.h
index 36fe746575f6b..bba088e80cd1e 100644
--- a/drivers/net/ipa/ipa_reg.h
+++ b/drivers/net/ipa/ipa_reg.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 
 /* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
- * Copyright (C) 2018-2020 Linaro Ltd.
+ * Copyright (C) 2018-2021 Linaro Ltd.
  */
 #ifndef _IPA_REG_H_
 #define _IPA_REG_H_
@@ -388,6 +388,18 @@ enum ipa_cs_offload_en {
 	IPA_CS_OFFLOAD_DL		= 0x2,
 };
 
+/* Valid only for TX (IPA consumer) endpoints */
+#define IPA_REG_ENDP_INIT_NAT_N_OFFSET(ep) \
+					(0x0000080c + 0x0070 * (ep))
+#define NAT_EN_FMASK				GENMASK(1, 0)
+
+/** enum ipa_nat_en - ENDP_INIT_NAT register NAT_EN field value */
+enum ipa_nat_en {
+	IPA_NAT_BYPASS			= 0x0,
+	IPA_NAT_SRC			= 0x1,
+	IPA_NAT_DST			= 0x2,
+};
+
 #define IPA_REG_ENDP_INIT_HDR_N_OFFSET(ep) \
 					(0x00000810 + 0x0070 * (ep))
 #define HDR_LEN_FMASK				GENMASK(5, 0)
-- 
2.27.0

