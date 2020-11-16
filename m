Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 335F52B553B
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 00:40:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731029AbgKPXiZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 18:38:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731010AbgKPXiW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 18:38:22 -0500
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52A95C0613CF
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 15:38:22 -0800 (PST)
Received: by mail-il1-x143.google.com with SMTP id y18so9648120ilp.13
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 15:38:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZH5sOdTOj86/wQG8Zy+0PJEx+Cikj8yoT/DUHhKt2CM=;
        b=Ga5B61HujCbuzWzeVIN84MRs3uKvfowbu9mpGpErQrQmXpBkp9cuLeQ6M1Zuy7mMUG
         0YJV8xXWJhEdaj4rVqrEBDKZNJNotP6PLPPScO+Zhrqp+lOAj7FB3UWOMfjmzTjKngfb
         3gTQxnBX3+LyYYKPTeVasJKfWF7rEXKOdeNHOJYeShTOrAa5QQpAKFfXeUtnPIh8RNh4
         spF71U1PYDEwrfyi6/jcMrqLit5TTpQWs5SxQSUp/DU+Gh/Eh8jH6+Lw5TZ6yVhzA9ak
         Z9kTm7NTNy9eHayy02KJ4+jGwBncJHmq4nJkH9vCym+OJ64GyEhu7PstbrY5gZu458Ls
         20DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZH5sOdTOj86/wQG8Zy+0PJEx+Cikj8yoT/DUHhKt2CM=;
        b=mkNua1eECh5XzwZlkm6O55q6uZoHPe3hCgqVqk3K6r2PZ2T0KgN6PhAzzGlskuiC45
         sfadkm7yk7zRp0c4zvkKNcZ6EJb70Lmjj/sUAcH5TCOvZFlC2pSf599GFpNtXfTGMBXR
         5csxqAHrz1qlsvYW72NFp6K1/7zbowqBbkGKT3CtLnXsP8IO+Ana7VbNkGlLLxTtKmG+
         a5LgNWhVASy2W5z88b4xBUCPG1IZ0tezZqxiocugZ1ikvIVotShzWw0cHEpfAEf8Xdw3
         QN+/NLVz73MdsJeJ8xyss2OWLdJUSxiwqGk/41D1Dkc7c5o3DP9s7SQz6Vi/5jnHWz5k
         HeEA==
X-Gm-Message-State: AOAM530NG1U4s4ILdegZWxkIIASnYkxhUjaC8cYV2iSFOk1j7KBDiv7F
        oRCk9MlHoDSR9IAFOzTbGF+NaA==
X-Google-Smtp-Source: ABdhPJzs71fCZs3viuh8SR93IpcEqDierOr8dmCtXJOkPo5uI9U992gpr4K9J7AVUOnT4/QcKXkssA==
X-Received: by 2002:a92:50e:: with SMTP id q14mr9869970ile.306.1605569901684;
        Mon, 16 Nov 2020 15:38:21 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id f18sm10180099ill.22.2020.11.16.15.38.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 15:38:21 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 06/11] net: ipa: fix BCR register field definitions
Date:   Mon, 16 Nov 2020 17:38:00 -0600
Message-Id: <20201116233805.13775-7-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201116233805.13775-1-elder@linaro.org>
References: <20201116233805.13775-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The backward compatibility register field masks are defined using
single-bit masks defined with BIT(x) rather than GENMASK(x, x).
Change this one set of definitions to follow the GENMASK() pattern
used everywhere else.  Add a few missing field definitions for this
register as well.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_reg.h | 31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ipa/ipa_reg.h b/drivers/net/ipa/ipa_reg.h
index 9e92fe022c6f9..a05684785e577 100644
--- a/drivers/net/ipa/ipa_reg.h
+++ b/drivers/net/ipa/ipa_reg.h
@@ -174,22 +174,35 @@ static inline u32 ipa_reg_filt_rout_hash_flush_offset(enum ipa_version version)
 #define IPV4_FILTER_HASH_FMASK			GENMASK(12, 12)
 
 #define IPA_REG_BCR_OFFSET				0x000001d0
-#define BCR_CMDQ_L_LACK_ONE_ENTRY		BIT(0)
-#define BCR_TX_NOT_USING_BRESP			BIT(1)
-#define BCR_SUSPEND_L2_IRQ			BIT(3)
-#define BCR_HOLB_DROP_L2_IRQ			BIT(4)
-#define BCR_DUAL_TX				BIT(5)
+/* The next two fields are not present for IPA v4.2 */
+#define BCR_CMDQ_L_LACK_ONE_ENTRY_FMASK		GENMASK(0, 0)
+#define BCR_TX_NOT_USING_BRESP_FMASK		GENMASK(1, 1)
+/* The next field is invalid for IPA v4.1 */
+#define BCR_TX_SUSPEND_IRQ_ASSERT_ONCE_FMASK	GENMASK(2, 2)
+/* The next two fields are not present for IPA v4.2 */
+#define BCR_SUSPEND_L2_IRQ_FMASK		GENMASK(3, 3)
+#define BCR_HOLB_DROP_L2_IRQ_FMASK		GENMASK(4, 4)
+#define BCR_DUAL_TX_FMASK			GENMASK(5, 5)
+#define BCR_ENABLE_FILTER_DATA_CACHE_FMASK	GENMASK(6, 6)
+#define BCR_NOTIF_PRIORITY_OVER_ZLT_FMASK	GENMASK(7, 7)
+#define BCR_FILTER_PREFETCH_EN_FMASK		GENMASK(8, 8)
+#define BCR_ROUTER_PREFETCH_EN_FMASK		GENMASK(9, 9)
 
 /* Backward compatibility register value to use for each version */
 static inline u32 ipa_reg_bcr_val(enum ipa_version version)
 {
 	if (version == IPA_VERSION_3_5_1)
-		return BCR_CMDQ_L_LACK_ONE_ENTRY | BCR_TX_NOT_USING_BRESP |
-		       BCR_SUSPEND_L2_IRQ | BCR_HOLB_DROP_L2_IRQ | BCR_DUAL_TX;
+		return BCR_CMDQ_L_LACK_ONE_ENTRY_FMASK |
+			BCR_TX_NOT_USING_BRESP_FMASK |
+			BCR_SUSPEND_L2_IRQ_FMASK |
+			BCR_HOLB_DROP_L2_IRQ_FMASK |
+			BCR_DUAL_TX_FMASK;
 
 	if (version == IPA_VERSION_4_0 || version == IPA_VERSION_4_1)
-		return BCR_CMDQ_L_LACK_ONE_ENTRY | BCR_SUSPEND_L2_IRQ |
-		       BCR_HOLB_DROP_L2_IRQ | BCR_DUAL_TX;
+		return BCR_CMDQ_L_LACK_ONE_ENTRY_FMASK |
+			BCR_SUSPEND_L2_IRQ_FMASK |
+			BCR_HOLB_DROP_L2_IRQ_FMASK |
+			BCR_DUAL_TX_FMASK;
 
 	return 0x00000000;
 }
-- 
2.20.1

