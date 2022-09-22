Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 815725E6F98
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 00:21:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231675AbiIVWVQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 18:21:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231388AbiIVWVK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 18:21:10 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 507D610D0EA
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 15:21:09 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id i16so2637730ilq.0
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 15:21:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=DxN4skl57Ip6n+jQkYaK3Z/OC9a58fagmXeHv9SstKE=;
        b=f0OWnnq6haiADOzRDBqpglUAw/QpO4xOSvS3uO0z1+eiKD+5DAD3rZnm/JJk59CXRm
         X6xN/ft/h8HudpguVdNk2QVteTUI6i8v8JMR+QtxwczYFdjLtq5gZhsDmPrTa9G765/t
         Ml7/fJl1fRpeJX5ZLKbtnVuUrNlhy6VZTn4t1yyc0MwK6CEGy44OmNCazBi3amkgrvBt
         FKstrxkA9mPmpUmc2k++YqQXqcbaY7G6QbalvnPQAWG3/aME/dKu20T+rnSUtHGL3K5I
         WLH3k6YKaayPZbhryrz7ZFuUrcQcuR+kgo/oDe3aQt1mlUS2QjX7vTHICmpmOIgtIcF/
         7Q9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=DxN4skl57Ip6n+jQkYaK3Z/OC9a58fagmXeHv9SstKE=;
        b=bPcDnjSS6bNuuBRzfSfFDYwUfJx6SQn1Svcut8on1m4lihcYnjQHij/LWHmnvhYPr+
         28FQNhsmjo/MGstmkKPe3hGB50U9C5Xn+A/T+lnncm2VI+fJOuuGajoKaf1XqW77A/Rl
         tnAC6aRwmxdU2CFx6CUtEAHiXso0t4VvsnyO93h2WFKabNoyjMxk3IStf/9TD+MIILf7
         qxY9ndU6ia0X5u+oBO3JUGCh2h4YAhwEfM+uyOi05ZK22HDTxgsWdslimcfMVEcmDi30
         ZDP9n8IzXzb8BEs0IrqJ7sLFwKkLrE6FnB7jLA0dURluSpvVO5QyBHCBRMKGBvJEmhTT
         yOAw==
X-Gm-Message-State: ACrzQf1ddt505O38nLGBQiQpqEJLgYOfVzzsCrMR890Ow+SoSlGHAmvX
        PMz/KFyzC5JjAUBpu8uX9o89lA==
X-Google-Smtp-Source: AMsMyM55tKcBQjxn0AOH07fVF51W4vb3otwirDCFcdPawDCpeJ6Vc4rJGLjSXT1CSbwHYRmVRlqQrw==
X-Received: by 2002:a05:6e02:1c24:b0:2f6:2fae:a4b with SMTP id m4-20020a056e021c2400b002f62fae0a4bmr2929727ilh.131.1663885268500;
        Thu, 22 Sep 2022 15:21:08 -0700 (PDT)
Received: from localhost.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id g12-20020a92d7cc000000b002f592936fbfsm2483332ilq.41.2022.09.22.15.21.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 15:21:08 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 4/8] net: ipa: define BCR values using an enum
Date:   Thu, 22 Sep 2022 17:20:56 -0500
Message-Id: <20220922222100.2543621-5-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220922222100.2543621-1-elder@linaro.org>
References: <20220922222100.2543621-1-elder@linaro.org>
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

The backward compatibility register (BCR) has a set of bit flags
that indicate ways in which the IPA hardware should operate in a
backward compatible way.  The register is not supported starting
with IPA v4.5, and where it is supported, defined bits all have the
same numeric value.

Redefine these flags using an enumerated type, with each member's
value representing the bit position that encodes it in the BCR.
This replaces all of the single-bit field masks previously defined.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/data/ipa_data-v3.1.c   |  2 +-
 drivers/net/ipa/data/ipa_data-v3.5.1.c | 10 +++++-----
 drivers/net/ipa/ipa_reg.h              | 26 ++++++++++++--------------
 3 files changed, 18 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ipa/data/ipa_data-v3.1.c b/drivers/net/ipa/data/ipa_data-v3.1.c
index 1c1895aea8118..e0d71f6092729 100644
--- a/drivers/net/ipa/data/ipa_data-v3.1.c
+++ b/drivers/net/ipa/data/ipa_data-v3.1.c
@@ -526,7 +526,7 @@ static const struct ipa_power_data ipa_power_data = {
 /* Configuration data for an SoC having IPA v3.1 */
 const struct ipa_data ipa_data_v3_1 = {
 	.version	= IPA_VERSION_3_1,
-	.backward_compat = BCR_CMDQ_L_LACK_ONE_ENTRY_FMASK,
+	.backward_compat = BIT(BCR_CMDQ_L_LACK_ONE_ENTRY),
 	.qsb_count	= ARRAY_SIZE(ipa_qsb_data),
 	.qsb_data	= ipa_qsb_data,
 	.endpoint_count	= ARRAY_SIZE(ipa_gsi_endpoint_data),
diff --git a/drivers/net/ipa/data/ipa_data-v3.5.1.c b/drivers/net/ipa/data/ipa_data-v3.5.1.c
index 58b708d2fc75d..383ef18900654 100644
--- a/drivers/net/ipa/data/ipa_data-v3.5.1.c
+++ b/drivers/net/ipa/data/ipa_data-v3.5.1.c
@@ -407,11 +407,11 @@ static const struct ipa_power_data ipa_power_data = {
 /* Configuration data for an SoC having IPA v3.5.1 */
 const struct ipa_data ipa_data_v3_5_1 = {
 	.version	= IPA_VERSION_3_5_1,
-	.backward_compat = BCR_CMDQ_L_LACK_ONE_ENTRY_FMASK |
-			   BCR_TX_NOT_USING_BRESP_FMASK |
-			   BCR_SUSPEND_L2_IRQ_FMASK |
-			   BCR_HOLB_DROP_L2_IRQ_FMASK |
-			   BCR_DUAL_TX_FMASK,
+	.backward_compat = BIT(BCR_CMDQ_L_LACK_ONE_ENTRY) |
+			   BIT(BCR_TX_NOT_USING_BRESP) |
+			   BIT(BCR_SUSPEND_L2_IRQ) |
+			   BIT(BCR_HOLB_DROP_L2_IRQ) |
+			   BIT(BCR_DUAL_TX),
 	.qsb_count	= ARRAY_SIZE(ipa_qsb_data),
 	.qsb_data	= ipa_qsb_data,
 	.endpoint_count	= ARRAY_SIZE(ipa_gsi_endpoint_data),
diff --git a/drivers/net/ipa/ipa_reg.h b/drivers/net/ipa/ipa_reg.h
index 3e24bddc682ef..2aa1d1dd0adf5 100644
--- a/drivers/net/ipa/ipa_reg.h
+++ b/drivers/net/ipa/ipa_reg.h
@@ -220,20 +220,18 @@ static inline u32 ipa_reg_state_aggr_active_offset(enum ipa_version version)
 
 /* The next register is not present for IPA v4.5+ */
 #define IPA_REG_BCR_OFFSET				0x000001d0
-/* The next two fields are not present for IPA v4.2+ */
-#define BCR_CMDQ_L_LACK_ONE_ENTRY_FMASK		GENMASK(0, 0)
-#define BCR_TX_NOT_USING_BRESP_FMASK		GENMASK(1, 1)
-/* The next field is invalid for IPA v4.0+ */
-#define BCR_TX_SUSPEND_IRQ_ASSERT_ONCE_FMASK	GENMASK(2, 2)
-/* The next two fields are not present for IPA v4.2+ */
-#define BCR_SUSPEND_L2_IRQ_FMASK		GENMASK(3, 3)
-#define BCR_HOLB_DROP_L2_IRQ_FMASK		GENMASK(4, 4)
-/* The next five fields are present for IPA v3.5+ */
-#define BCR_DUAL_TX_FMASK			GENMASK(5, 5)
-#define BCR_ENABLE_FILTER_DATA_CACHE_FMASK	GENMASK(6, 6)
-#define BCR_NOTIF_PRIORITY_OVER_ZLT_FMASK	GENMASK(7, 7)
-#define BCR_FILTER_PREFETCH_EN_FMASK		GENMASK(8, 8)
-#define BCR_ROUTER_PREFETCH_EN_FMASK		GENMASK(9, 9)
+enum ipa_bcr_compat {
+	BCR_CMDQ_L_LACK_ONE_ENTRY		= 0x0,	/* Not IPA v4.2+ */
+	BCR_TX_NOT_USING_BRESP			= 0x1,	/* Not IPA v4.2+ */
+	BCR_TX_SUSPEND_IRQ_ASSERT_ONCE		= 0x2,	/* Not IPA v4.0+ */
+	BCR_SUSPEND_L2_IRQ			= 0x3,	/* Not IPA v4.2+ */
+	BCR_HOLB_DROP_L2_IRQ			= 0x4,	/* Not IPA v4.2+ */
+	BCR_DUAL_TX				= 0x5,	/* IPA v3.5+ */
+	BCR_ENABLE_FILTER_DATA_CACHE		= 0x6,	/* IPA v3.5+ */
+	BCR_NOTIF_PRIORITY_OVER_ZLT		= 0x7,	/* IPA v3.5+ */
+	BCR_FILTER_PREFETCH_EN			= 0x8,	/* IPA v3.5+ */
+	BCR_ROUTER_PREFETCH_EN			= 0x9,	/* IPA v3.5+ */
+};
 
 /* The value of the next register must be a multiple of 8 (bottom 3 bits 0) */
 #define IPA_REG_LOCAL_PKT_PROC_CNTXT_OFFSET		0x000001e8
-- 
2.34.1

