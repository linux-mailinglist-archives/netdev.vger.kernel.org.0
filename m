Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33E946BA0DE
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 21:38:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229475AbjCNUix (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 16:38:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230307AbjCNUiu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 16:38:50 -0400
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D3621B322
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 13:38:49 -0700 (PDT)
Received: by mail-qv1-xf2a.google.com with SMTP id y3so13323549qvn.4
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 13:38:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678826329;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iA+I7Vbmw4P4QtwsVcv32pq9bGfwOxM9ux+hNncPv6w=;
        b=Xw84vR/rrW0uvmiI8/T/aJYVNdL+PYeQaYy4WwbQsdlLSUd78+PcMH/C/aGFklRNwJ
         1HCz0y254ewOR1sOi0vzHR2WPwnMGX47qcaQZN1EmZ4WhYofEQee6jEfxCZ063qu3sM/
         DGZNziqFE6SNOmM8stDGXBW2q8MoCQiMjSisbccfBUicjOHk75tHGHxcSKC5Mmnwed9g
         51ykK6hJHKUm3kYSmFGL1CcdlFf8oB239aQCON4VkvxyMMmLCm+qwD1k+7mEMsHfoYHU
         bAEZb+Q2M2D88MEUr06Bt8e22cIhsozIRSFjzZJEJnfU91nSpaCLeZ8TBkfdrAavplF7
         p+3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678826329;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iA+I7Vbmw4P4QtwsVcv32pq9bGfwOxM9ux+hNncPv6w=;
        b=rv+iP9hHyUEN951Y69nXwRgwC0rzlOBie4EyIBlqRIbCEVZO6XQwucGaMsykFkkFiG
         3vJChaAXl3fvWq7FfLkOaPnZ6JjVNMzHoAny6zPBlmPdNuzKqNhRcxvOh5G2hb6PBcmn
         owTZl65Kw6zLZCO7QloK30Ss/SxD837iudVSRFcXdAZ8LpW/UlyVcz0umJjqoTokh43F
         5FhZ+BkIcqyZ1yX57k6igCqwnk6CrblaW+ZGto4nUTAsX9qeGfunfH8/ZnWJflqC1ZbI
         dC+XdEgOf9NAzwX67jf+vNy9FMFgiMfb2ogOqpZYyo1xEISQsYipYWkhn79A0S98a5ZI
         76RQ==
X-Gm-Message-State: AO0yUKU0Kv/YMafU+fpqYC+E6cNYppsO/nyToug45GYDOnRmGrqhse3U
        bUwWkJ9P+HLpZHr2GeXgDudvxA==
X-Google-Smtp-Source: AK7set/H+aTAGGQNuHTwbkDgRL8IF55BNAhI0jTHvBKYZ3J3IMOZIsv5joJ3KoTkN8GLprogJIebuA==
X-Received: by 2002:a05:6214:29ef:b0:56e:9f05:6265 with SMTP id jv15-20020a05621429ef00b0056e9f056265mr19021056qvb.39.1678826329253;
        Tue, 14 Mar 2023 13:38:49 -0700 (PDT)
Received: from localhost.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id c2-20020a379a02000000b00745ca1c0eb6sm1947828qke.2.2023.03.14.13.38.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 13:38:49 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     caleb.connolly@linaro.org, mka@chromium.org, evgreen@chromium.org,
        andersson@kernel.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net 2/4] net: ipa: add two missing declarations
Date:   Tue, 14 Mar 2023 15:38:39 -0500
Message-Id: <20230314203841.1574172-3-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230314203841.1574172-1-elder@linaro.org>
References: <20230314203841.1574172-1-elder@linaro.org>
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

When gsi_reg_init() got added, its declaration was added to
"gsi_reg.h" without declaring the two struct pointer types it uses.
Add these struct declarations to "gsi_reg.h".

Fixes: e68cef8906ea ("net: ipa: introduce gsi_reg_init()")
Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi_reg.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ipa/gsi_reg.h b/drivers/net/ipa/gsi_reg.h
index f62f0a5c653d1..48fde65fa2e8a 100644
--- a/drivers/net/ipa/gsi_reg.h
+++ b/drivers/net/ipa/gsi_reg.h
@@ -10,6 +10,10 @@
 
 #include <linux/bits.h>
 
+struct platform_device;
+
+struct gsi;
+
 /**
  * DOC: GSI Registers
  *
-- 
2.34.1

