Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA8A6BD2B7
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 15:51:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbjCPOvv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 10:51:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231245AbjCPOvs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 10:51:48 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFB15AA24D
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 07:51:45 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id i24so1958376qtm.6
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 07:51:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678978305;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n9PDFYuVYy1JnFh9er4YyEDGQhbBjgJ9zKhwhKEYADA=;
        b=NAmUYBwLeXTIs4g0JI6sodFDifpu5ZrHU//Zvo1zLl9HLFYQ7jwcwd3kCkMaOg183s
         h5F9VjYLgk14uQoUg852KqZ4tzhp/ffH908wU1YDMrl0b4cPj16No4IN2jDrooHtWH2m
         ChxBseknq8oIMV37IwbPvDgS1DZc8NKCTCOZsAuGCgey+T3K9L/kNKUGNbkOWA1Worv6
         c1KpPuhkPVpFyVSNAlEC1uUad0iZ0kyocqn6qOGiB7If5CtHuNLjeufNMXfyU1M5wg6W
         Orq+FFdaLK3oWXXa+gGyvAd+uFEBdNCWh0u4Tz78uZh40EiDKFR7sgB3PzRwJYKf1l98
         4R0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678978305;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n9PDFYuVYy1JnFh9er4YyEDGQhbBjgJ9zKhwhKEYADA=;
        b=QcgBwoNUXBhpEgBA1kIET3+gRpeDIhH5otJ8VvvQYJQycWrdqLYX/dtBn8Vljesxhi
         2tTFsAhp0Q6qvmhHEhWN2MBvvphkBzI0jmduSlYQ5vAvc9jaKSkNVZi7FrU8jjTGlttr
         u9ikjAAsX7YIXjWRcgqITLLOSyP2Gji0AB6eDJQ6n047TT+bqowBvZoW0LsacEms8oBi
         2IbMdPfXMq5pDnk6u2WNiKJ5K8yw/COG+h9AQ3RIXqg8EfvSm8ojF3DWoBHKAMQJNQ5I
         VUTfqdE2ywb1MEQX+yhZyJzKYHKLhCDo8olYkvQGyuRVzjBBUHZRvlwoi9gQmrri0VeA
         QUnQ==
X-Gm-Message-State: AO0yUKXK044hkVRW4d2bzyMFAWcIW3kQKJNB8P1uYQzPCIYKJkKK5mRN
        Dkwht9Xgd1AiwtwaEtU+aqUgew==
X-Google-Smtp-Source: AK7set8LmiWDbj5mwlXi7S1W1OQjFZhCe/12/deUZwZTSnD3fAGCampp2J12L4WtAPl3jpdNAGp+Zg==
X-Received: by 2002:a05:622a:174c:b0:3d4:6185:72d4 with SMTP id l12-20020a05622a174c00b003d4618572d4mr6332476qtk.7.1678978304754;
        Thu, 16 Mar 2023 07:51:44 -0700 (PDT)
Received: from localhost.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id n129-20020a37bd87000000b007456b2759efsm2844070qkf.28.2023.03.16.07.51.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 07:51:44 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     caleb.connolly@linaro.org, mka@chromium.org, evgreen@chromium.org,
        andersson@kernel.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net v3 3/4] net: ipa: kill FILT_ROUT_CACHE_CFG IPA register
Date:   Thu, 16 Mar 2023 09:51:35 -0500
Message-Id: <20230316145136.1795469-4-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230316145136.1795469-1-elder@linaro.org>
References: <20230316145136.1795469-1-elder@linaro.org>
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

A recent commit defined a few IPA registers used for IPA v5.0+.
One of those was a mistake.  Although the filter and router caches
get *flushed* using a single register, they use distinct registers
(ENDP_FILTER_CACHE_CFG and ENDP_ROUTER_CACHE_CFG) for configuration.

And although there *exists* a FILT_ROUT_CACHE_CFG register, it is
not needed in upstream code.  So get rid of definitions related to
FILT_ROUT_CACHE_CFG, because they are not needed.

Fixes: 8ba59716d16a ("net: ipa: define IPA v5.0+ registers")
Signed-off-by: Alex Elder <elder@linaro.org>
---
v3: "Fixes" tag now refers to the proper upstream commit.

 drivers/net/ipa/ipa_reg.c | 4 ++--
 drivers/net/ipa/ipa_reg.h | 9 ---------
 2 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ipa/ipa_reg.c b/drivers/net/ipa/ipa_reg.c
index 735fa65916097..463a31dfa9f47 100644
--- a/drivers/net/ipa/ipa_reg.c
+++ b/drivers/net/ipa/ipa_reg.c
@@ -39,7 +39,8 @@ static bool ipa_reg_id_valid(struct ipa *ipa, enum ipa_reg_id reg_id)
 		return version <= IPA_VERSION_3_1;
 
 	case ENDP_FILTER_ROUTER_HSH_CFG:
-		return version != IPA_VERSION_4_2;
+		return version < IPA_VERSION_5_0 &&
+			version != IPA_VERSION_4_2;
 
 	case IRQ_SUSPEND_EN:
 	case IRQ_SUSPEND_CLR:
@@ -52,7 +53,6 @@ static bool ipa_reg_id_valid(struct ipa *ipa, enum ipa_reg_id reg_id)
 	case QSB_MAX_WRITES:
 	case QSB_MAX_READS:
 	case FILT_ROUT_HASH_EN:
-	case FILT_ROUT_CACHE_CFG:
 	case FILT_ROUT_HASH_FLUSH:
 	case FILT_ROUT_CACHE_FLUSH:
 	case STATE_AGGR_ACTIVE:
diff --git a/drivers/net/ipa/ipa_reg.h b/drivers/net/ipa/ipa_reg.h
index 28aa1351dd488..ff2be8be0f683 100644
--- a/drivers/net/ipa/ipa_reg.h
+++ b/drivers/net/ipa/ipa_reg.h
@@ -61,7 +61,6 @@ enum ipa_reg_id {
 	QSB_MAX_WRITES,
 	QSB_MAX_READS,
 	FILT_ROUT_HASH_EN,				/* Not IPA v5.0+ */
-	FILT_ROUT_CACHE_CFG,				/* IPA v5.0+ */
 	FILT_ROUT_HASH_FLUSH,				/* Not IPA v5.0+ */
 	FILT_ROUT_CACHE_FLUSH,				/* IPA v5.0+ */
 	STATE_AGGR_ACTIVE,
@@ -206,14 +205,6 @@ enum ipa_reg_qsb_max_reads_field_id {
 	GEN_QMB_1_MAX_READS_BEATS,			/* IPA v4.0+ */
 };
 
-/* FILT_ROUT_CACHE_CFG register */
-enum ipa_reg_filt_rout_cache_cfg_field_id {
-	ROUTER_CACHE_EN,
-	FILTER_CACHE_EN,
-	LOW_PRI_HASH_HIT_DISABLE,
-	LRU_EVICTION_THRESHOLD,
-};
-
 /* FILT_ROUT_HASH_EN and FILT_ROUT_HASH_FLUSH registers */
 enum ipa_reg_filt_rout_hash_field_id {
 	IPV6_ROUTER_HASH,
-- 
2.34.1

