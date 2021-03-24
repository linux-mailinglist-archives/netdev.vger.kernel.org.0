Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45EDC347957
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 14:16:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235142AbhCXNQM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 09:16:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234706AbhCXNPf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 09:15:35 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37E44C0613E1
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 06:15:34 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id b10so21392203iot.4
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 06:15:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qKrY3MtVV0SjI4PDoOYPSEatpvEs6DJpVc9j1EaE/t0=;
        b=L3n+VQn1qdXmxu7Rh61rfDoILCtfUVK8hsLTP4ZuGECASWlB/wKK/f4aTw45pgnN/f
         wZfqgjPdz4HRKnfe5cY2R6U09qIFv0jmaldskybBClMKo71rqSOanamk5DEuJiozGnYK
         872KCjNsmphXPIwu5VXGGKgXFDkYUyo+n8FQvvTIuvpMXM2Oqj620Ws5Nk/ygbo5KdJd
         C5J+3q2h1TwWN2VYe+xtXAwStuoJ48o3cAnm7hVw38SZVOlsCasDJW4tkG29fphO3yXW
         NW29fzaEa4d4dZjpVoFh2O+ubJ5bnyjeRerzbus0PG/169Zr/bVRg6wX7JzGcIup0NST
         /Vgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qKrY3MtVV0SjI4PDoOYPSEatpvEs6DJpVc9j1EaE/t0=;
        b=tGrZ4jHnSUuMhF7Qi7bR7hSpbSEQPYwHiFtHKTjibrH+3kFMNdzpm6zj5rfHfdN8So
         3ExbpxdMaX834vaSTd6EL7S7Rf0G+h2xpJQ4sNvoY8N1PFRZdUwxAC7CA8XHcbFTvo6/
         zvi/NSgtLa2SCiBlI+AlgGxFwaeYE3ednKJH6+ARmabR8B6O4bBi39pw7PNPleTdt14C
         RWqp1rSxCAVlyyMUNCXnEUnQZVti7pmIP8MgveQReNqsEwLW95YqiJSLRjVvYCJ/bOWr
         sSEvy6Awjuk6MmxYLePgeiAV2ua0VbK0MO8gNazKaBghCX9RmrBSaQJ+crwsUYk9O6i+
         iA4A==
X-Gm-Message-State: AOAM532fr3wEYHUsGL1RJkB/14x5FoU6FiuFe8uNeyp3QmpHKSEOwKfC
        jEShzEqgSpJeTYHJYipWIUICxw==
X-Google-Smtp-Source: ABdhPJy9LIgxH4R/07ozWEIAcUy8IHgGKJ07llkCBlBWankLC6a6R2mdT8gd0OUb1dls93yKhRzBQA==
X-Received: by 2002:a5e:8c16:: with SMTP id n22mr2423380ioj.156.1616591733651;
        Wed, 24 Mar 2021 06:15:33 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id n7sm1160486ile.12.2021.03.24.06.15.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 06:15:33 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 3/6] net: ipa: define the ENDP_INIT_NAT register
Date:   Wed, 24 Mar 2021 08:15:25 -0500
Message-Id: <20210324131528.2369348-4-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210324131528.2369348-1-elder@linaro.org>
References: <20210324131528.2369348-1-elder@linaro.org>
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

