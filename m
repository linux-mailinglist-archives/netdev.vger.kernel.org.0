Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63290681C44
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 22:05:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbjA3VFG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 16:05:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbjA3VFE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 16:05:04 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA589485A7
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 13:04:37 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id e204so4965973iof.1
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 13:04:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hjEtYXJDp6iclp+CacIWVQrUALk4651QlhNhwW9psWc=;
        b=Y07MbFOYxOnlk9zeG1BJM4rCp26i7iCbS7OBlWQEB59AaW7LlF9gqKWobXisdIL/MV
         2z0Q5JOa6hTyJg+QkolsD0W55C9JqLU9nWv+2fEKslgqMOXfmvtgVA+kXUN+GhGG2nYS
         MUamAqiBDqbcmxTtAdjraAICTaftm2lJuYL/lhyfeWlQuNb80ePuX+amS6b/iF/S+Ofq
         KH6MJoZV+8GcO6Xu1GEGa/vYvJ0qxLzmSutUdk7ln/OWKQJ01H82hw89WHDN6ikQyIMl
         ofmaCQVYWXFqs0hqbwK7Qs2x7kB//XUlDIdzwVNwaQE79nAZQHRk9nJbNRM2lACSGu1S
         zOtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hjEtYXJDp6iclp+CacIWVQrUALk4651QlhNhwW9psWc=;
        b=5nMYHdjyDhDUWi0zR8qon+3XOf7yBhn+9a0jDdhZLkHxlH7VNe7KpV9oaC/Gav45ZB
         IcP9RNnEWDJ28iKC1/Wze1gvcdk/xxu2BGltxH1iahc8BMWfBlhvZWfXy6ONa6IcMd5x
         7ny/CACc/Pd8Ya5n2DD5CQDeuL9n1ONmuuw5KKx4E20iPr6r4ASmC81blCHaPDnUkfMZ
         s/B1+kQ4logBeCDbNxOTBzs7n6rtWn59jP093YVUQJgIVwc/4BnH/753We3W/+7K/O6K
         wMvxFZxbAa/gtnjizF//IC4wGfMGDnf+Nnmn1EfmJYhwEgk/oQ5HFYShMQC6sVEaNM0D
         u4/Q==
X-Gm-Message-State: AO0yUKUo9J6cksDEVILGrtjOQ8qY2Wqewk5U0LNV5O1N1/p6bcoTtyHZ
        l/9jC1xDeC/Hop/oj6wZcEalZA==
X-Google-Smtp-Source: AK7set/4Zx2FyQuLsaWj/dxoL1fKfr2CII0LxRm/eqsY5DJPZKWVfrnBRrPd9S+HvrF30wvxH2DPXw==
X-Received: by 2002:a6b:fb16:0:b0:71a:1b72:5afc with SMTP id h22-20020a6bfb16000000b0071a1b725afcmr4556466iog.19.1675112673912;
        Mon, 30 Jan 2023 13:04:33 -0800 (PST)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id a30-20020a02735e000000b003aef8fded9asm1992046jae.127.2023.01.30.13.03.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 13:04:07 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     caleb.connolly@linaro.org, mka@chromium.org, evgreen@chromium.org,
        andersson@kernel.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 8/8] net: ipa: define two new memory regions
Date:   Mon, 30 Jan 2023 15:01:58 -0600
Message-Id: <20230130210158.4126129-9-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230130210158.4126129-1-elder@linaro.org>
References: <20230130210158.4126129-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IPA v5.0 uses two memory regions not previously used.  Define them
and treat them as valid only for IPA v5.0.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_mem.c | 8 +++++++-
 drivers/net/ipa/ipa_mem.h | 8 +++++---
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ipa/ipa_mem.c b/drivers/net/ipa/ipa_mem.c
index 9ec5af323f731..a07776e20cb0d 100644
--- a/drivers/net/ipa/ipa_mem.c
+++ b/drivers/net/ipa/ipa_mem.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 
 /* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
- * Copyright (C) 2019-2022 Linaro Ltd.
+ * Copyright (C) 2019-2023 Linaro Ltd.
  */
 
 #include <linux/types.h>
@@ -163,6 +163,12 @@ static bool ipa_mem_id_valid(struct ipa *ipa, enum ipa_mem_id mem_id)
 			return false;
 		break;
 
+	case IPA_MEM_AP_V4_FILTER:
+	case IPA_MEM_AP_V6_FILTER:
+		if (version != IPA_VERSION_5_0)
+			return false;
+		break;
+
 	case IPA_MEM_NAT_TABLE:
 	case IPA_MEM_STATS_FILTER_ROUTE:
 		if (version < IPA_VERSION_4_5)
diff --git a/drivers/net/ipa/ipa_mem.h b/drivers/net/ipa/ipa_mem.h
index 570bfdd99bffb..868e9c20e8c41 100644
--- a/drivers/net/ipa/ipa_mem.h
+++ b/drivers/net/ipa/ipa_mem.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 
 /* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
- * Copyright (C) 2019-2021 Linaro Ltd.
+ * Copyright (C) 2019-2023 Linaro Ltd.
  */
 #ifndef _IPA_MEM_H_
 #define _IPA_MEM_H_
@@ -62,13 +62,15 @@ enum ipa_mem_id {
 	IPA_MEM_PDN_CONFIG,		/* 0/2 canaries (IPA v4.0+) */
 	IPA_MEM_STATS_QUOTA_MODEM,	/* 2/4 canaries (IPA v4.0+) */
 	IPA_MEM_STATS_QUOTA_AP,		/* 0 canaries, optional (IPA v4.0+) */
-	IPA_MEM_STATS_TETHERING,	/* 0 canaries (IPA v4.0+) */
+	IPA_MEM_STATS_TETHERING,	/* 0 canaries, optional (IPA v4.0+) */
 	IPA_MEM_STATS_DROP,		/* 0 canaries, optional (IPA v4.0+) */
-	/* The next 5 filter and route statistics regions are optional */
+	/* The next 7 filter and route statistics regions are optional */
 	IPA_MEM_STATS_V4_FILTER,	/* 0 canaries (IPA v4.0-v4.2) */
 	IPA_MEM_STATS_V6_FILTER,	/* 0 canaries (IPA v4.0-v4.2) */
 	IPA_MEM_STATS_V4_ROUTE,		/* 0 canaries (IPA v4.0-v4.2) */
 	IPA_MEM_STATS_V6_ROUTE,		/* 0 canaries (IPA v4.0-v4.2) */
+	IPA_MEM_AP_V4_FILTER,		/* 2 canaries (IPA v5.0) */
+	IPA_MEM_AP_V6_FILTER,		/* 0 canaries (IPA v5.0) */
 	IPA_MEM_STATS_FILTER_ROUTE,	/* 0 canaries (IPA v4.5+) */
 	IPA_MEM_NAT_TABLE,		/* 4 canaries, optional (IPA v4.5+) */
 	IPA_MEM_END_MARKER,		/* 1 canary (not a real region) */
-- 
2.34.1

