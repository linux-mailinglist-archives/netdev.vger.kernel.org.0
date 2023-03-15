Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F7E06BBD5E
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 20:36:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232943AbjCOTgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 15:36:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232859AbjCOTgH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 15:36:07 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5392C943B1
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 12:36:04 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id i24so1323531qtm.6
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 12:36:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678908963;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wQ1M5e4o784Td5MHB1XQg1XvARHHy1gJJ+s85YY31LE=;
        b=LRZIr8EOtR7vPhVL/8fZKri2FBwpq1DATSDu8qdhg7H/qEa1Bse+g8fzymLPe1dAnr
         +gBIKvIPJoi+Gw3g+bCKvLblHkKjmk7bSNzAb4bQDfxMWdbCPpU6u1sMvS16YSEuGIFz
         FxuffdYg3eNixFWTRdHufKYQgJoBFCStkK85hPp3CzmmnL2ka+uM1gOEaIfKtv0UtdxM
         w3DB4gxpBpfKa8vc4EbYfGjqDTy0qqZE0H4v2gnT9hewy3ABMfhwhuujXvd3/gEgdL/l
         g/OJcSILdNoKIROyMdDP9MlAbt+y2AeaU0Q0DhwHYXMKEcO659B8UJOB7QdlTYKc9r2j
         6kIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678908963;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wQ1M5e4o784Td5MHB1XQg1XvARHHy1gJJ+s85YY31LE=;
        b=fPBVVHCmy9mOGp7iNBj4AxBAfQ0u7Oq5scwsZxKAlI7g/4WgNqgJD0EnQBwFnC6SOM
         ZOjMr6wpbnBkUv7XwpgMWGGrunL4kpML5gl0gpH8lNyWGyNsK5uMemqub+Q6+AgK3vGi
         2PyA4040gBbM17ZWQb8OYXoBCyCZhGwk9GYm8dOOSlDbH48313UpouLnd4ijvKK8xAsH
         bmtPguw/vYFxqoB6QQ9OlFQSYrU35QItQsLSpRAF5rajhWKEe5mJDa6AMFalEe22pf79
         Vftn/ifSsR8KGRn5qYI9fSaKG/WuIh2/clbwH7AuFBmsQBe7+g5p7ynzjfTZkYRClmna
         s8RA==
X-Gm-Message-State: AO0yUKUVUVlevTFfPncz1cBY7E8i0aWbwfR06ZVE2/XyRUge68p+0Dg6
        emxAeLNB+oMW4kWFcd81fJOC2Q==
X-Google-Smtp-Source: AK7set9ep/xUaQg/f9zebgMn0sDUL+eL1TXqjZ3dZ2PbHiaRnTBe1OhUZO+U+feqfGcb7KCyJ3v/9g==
X-Received: by 2002:ac8:7f4e:0:b0:3bf:d149:8966 with SMTP id g14-20020ac87f4e000000b003bfd1498966mr1796958qtk.62.1678908963393;
        Wed, 15 Mar 2023 12:36:03 -0700 (PDT)
Received: from localhost.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id q9-20020a05620a024900b0071eddd3bebbsm4369462qkn.81.2023.03.15.12.36.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 12:36:02 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     caleb.connolly@linaro.org, mka@chromium.org, evgreen@chromium.org,
        andersson@kernel.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net v2 4/4] net: ipa: fix some register validity checks
Date:   Wed, 15 Mar 2023 14:35:52 -0500
Message-Id: <20230315193552.1646892-5-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230315193552.1646892-1-elder@linaro.org>
References: <20230315193552.1646892-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A recent commit defined HW_PARAM_4 as a GSI register ID but did not
add it to gsi_reg_id_valid() to indicate it's valid (for IPA v5.0+).
Add version checks for the HW_PARAM_2 and INTER_EE IRQ GSI registers
there as well.

IPA v5.0 supports up to 8 source and destination resource groups.
Update the validity check (and the comments where the register IDs
are defined) to reflect that.  Similarly update comments and
validity checks for the hash/cache-related registers.

Note that this patch fixes an omission and constrains things
further, but these don't technically represent bugs.

Fixes: f651334e1ef5 ("net: ipa: add HW_PARAM_4 GSI register")
Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi_reg.c |  9 ++++++++-
 drivers/net/ipa/ipa_reg.c | 24 ++++++++++++++++--------
 drivers/net/ipa/ipa_reg.h | 12 ++++++------
 3 files changed, 30 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ipa/gsi_reg.c b/drivers/net/ipa/gsi_reg.c
index 1412b67304c8e..1651fbad4bd54 100644
--- a/drivers/net/ipa/gsi_reg.c
+++ b/drivers/net/ipa/gsi_reg.c
@@ -15,6 +15,14 @@ static bool gsi_reg_id_valid(struct gsi *gsi, enum gsi_reg_id reg_id)
 	switch (reg_id) {
 	case INTER_EE_SRC_CH_IRQ_MSK:
 	case INTER_EE_SRC_EV_CH_IRQ_MSK:
+		return gsi->version >= IPA_VERSION_3_5;
+
+	case HW_PARAM_2:
+		return gsi->version >= IPA_VERSION_3_5_1;
+
+	case HW_PARAM_4:
+		return gsi->version >= IPA_VERSION_5_0;
+
 	case CH_C_CNTXT_0:
 	case CH_C_CNTXT_1:
 	case CH_C_CNTXT_2:
@@ -43,7 +51,6 @@ static bool gsi_reg_id_valid(struct gsi *gsi, enum gsi_reg_id reg_id)
 	case CH_CMD:
 	case EV_CH_CMD:
 	case GENERIC_CMD:
-	case HW_PARAM_2:
 	case CNTXT_TYPE_IRQ:
 	case CNTXT_TYPE_IRQ_MSK:
 	case CNTXT_SRC_CH_IRQ:
diff --git a/drivers/net/ipa/ipa_reg.c b/drivers/net/ipa/ipa_reg.c
index 463a31dfa9f47..3f475428ddddb 100644
--- a/drivers/net/ipa/ipa_reg.c
+++ b/drivers/net/ipa/ipa_reg.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 
 /* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
- * Copyright (C) 2019-2022 Linaro Ltd.
+ * Copyright (C) 2019-2023 Linaro Ltd.
  */
 
 #include <linux/io.h>
@@ -15,6 +15,17 @@ static bool ipa_reg_id_valid(struct ipa *ipa, enum ipa_reg_id reg_id)
 	enum ipa_version version = ipa->version;
 
 	switch (reg_id) {
+	case FILT_ROUT_HASH_EN:
+		return version == IPA_VERSION_4_2;
+
+	case FILT_ROUT_HASH_FLUSH:
+		return version < IPA_VERSION_5_0 && version != IPA_VERSION_4_2;
+
+	case FILT_ROUT_CACHE_FLUSH:
+	case ENDP_FILTER_CACHE_CFG:
+	case ENDP_ROUTER_CACHE_CFG:
+		return version >= IPA_VERSION_5_0;
+
 	case IPA_BCR:
 	case COUNTER_CFG:
 		return version < IPA_VERSION_4_5;
@@ -32,11 +43,13 @@ static bool ipa_reg_id_valid(struct ipa *ipa, enum ipa_reg_id reg_id)
 	case SRC_RSRC_GRP_45_RSRC_TYPE:
 	case DST_RSRC_GRP_45_RSRC_TYPE:
 		return version <= IPA_VERSION_3_1 ||
-		       version == IPA_VERSION_4_5;
+		       version == IPA_VERSION_4_5 ||
+		       version == IPA_VERSION_5_0;
 
 	case SRC_RSRC_GRP_67_RSRC_TYPE:
 	case DST_RSRC_GRP_67_RSRC_TYPE:
-		return version <= IPA_VERSION_3_1;
+		return version <= IPA_VERSION_3_1 ||
+		       version == IPA_VERSION_5_0;
 
 	case ENDP_FILTER_ROUTER_HSH_CFG:
 		return version < IPA_VERSION_5_0 &&
@@ -52,9 +65,6 @@ static bool ipa_reg_id_valid(struct ipa *ipa, enum ipa_reg_id reg_id)
 	case SHARED_MEM_SIZE:
 	case QSB_MAX_WRITES:
 	case QSB_MAX_READS:
-	case FILT_ROUT_HASH_EN:
-	case FILT_ROUT_HASH_FLUSH:
-	case FILT_ROUT_CACHE_FLUSH:
 	case STATE_AGGR_ACTIVE:
 	case LOCAL_PKT_PROC_CNTXT:
 	case AGGR_FORCE_CLOSE:
@@ -76,8 +86,6 @@ static bool ipa_reg_id_valid(struct ipa *ipa, enum ipa_reg_id reg_id)
 	case ENDP_INIT_RSRC_GRP:
 	case ENDP_INIT_SEQ:
 	case ENDP_STATUS:
-	case ENDP_FILTER_CACHE_CFG:
-	case ENDP_ROUTER_CACHE_CFG:
 	case IPA_IRQ_STTS:
 	case IPA_IRQ_EN:
 	case IPA_IRQ_CLR:
diff --git a/drivers/net/ipa/ipa_reg.h b/drivers/net/ipa/ipa_reg.h
index ff2be8be0f683..7dd65d39333dd 100644
--- a/drivers/net/ipa/ipa_reg.h
+++ b/drivers/net/ipa/ipa_reg.h
@@ -60,8 +60,8 @@ enum ipa_reg_id {
 	SHARED_MEM_SIZE,
 	QSB_MAX_WRITES,
 	QSB_MAX_READS,
-	FILT_ROUT_HASH_EN,				/* Not IPA v5.0+ */
-	FILT_ROUT_HASH_FLUSH,				/* Not IPA v5.0+ */
+	FILT_ROUT_HASH_EN,				/* IPA v4.2 */
+	FILT_ROUT_HASH_FLUSH,			/* Not IPA v4.2 nor IPA v5.0+ */
 	FILT_ROUT_CACHE_FLUSH,				/* IPA v5.0+ */
 	STATE_AGGR_ACTIVE,
 	IPA_BCR,					/* Not IPA v4.5+ */
@@ -76,12 +76,12 @@ enum ipa_reg_id {
 	TIMERS_PULSE_GRAN_CFG,				/* IPA v4.5+ */
 	SRC_RSRC_GRP_01_RSRC_TYPE,
 	SRC_RSRC_GRP_23_RSRC_TYPE,
-	SRC_RSRC_GRP_45_RSRC_TYPE,		/* Not IPA v3.5+, IPA v4.5 */
-	SRC_RSRC_GRP_67_RSRC_TYPE,			/* Not IPA v3.5+ */
+	SRC_RSRC_GRP_45_RSRC_TYPE,	/* Not IPA v3.5+; IPA v4.5, IPA v5.0 */
+	SRC_RSRC_GRP_67_RSRC_TYPE,		/* Not IPA v3.5+; IPA v5.0 */
 	DST_RSRC_GRP_01_RSRC_TYPE,
 	DST_RSRC_GRP_23_RSRC_TYPE,
-	DST_RSRC_GRP_45_RSRC_TYPE,		/* Not IPA v3.5+, IPA v4.5 */
-	DST_RSRC_GRP_67_RSRC_TYPE,			/* Not IPA v3.5+ */
+	DST_RSRC_GRP_45_RSRC_TYPE,	/* Not IPA v3.5+; IPA v4.5, IPA v5.0 */
+	DST_RSRC_GRP_67_RSRC_TYPE,		/* Not IPA v3.5+; IPA v5.0 */
 	ENDP_INIT_CTRL,		/* Not IPA v4.2+ for TX, not IPA v4.0+ for RX */
 	ENDP_INIT_CFG,
 	ENDP_INIT_NAT,			/* TX only */
-- 
2.34.1

