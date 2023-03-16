Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76BC16BD2B8
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 15:51:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231314AbjCPOvu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 10:51:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231174AbjCPOvp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 10:51:45 -0400
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 833D9ACB8B
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 07:51:44 -0700 (PDT)
Received: by mail-qv1-xf30.google.com with SMTP id m6so1411600qvq.0
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 07:51:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678978303;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PKqWcLfcs3UmhMvL5K01K9FuLeIx9ZVjwoD0JyqWTuo=;
        b=DNNVsRdstp9GXxAlTzZMwPKZHrhjXBxXrr41KyXv4TaGZT2jG+NcsGXMPSCVa2Vn7h
         42JQDHB5hHosaVozlRoRXNGAaC7JcNdX45C623KL2WDwO4s+iE8yb/8I9nI2BHPaWYgZ
         ZbJS6MGBAUwEtYavojtBFoPnYcGKRO5vw7HtLHmko8Y6Cm2fviTDjpLp6kitG0dbF3Yj
         NzsEtq78ubo1utWJ3RU0QB/Syf/pQeTdFPE7nEtH6AhzaAcjUehwa55jFaNKnTxfXJhI
         ygVttIHqnynljMGWOF6Ry23rS8xFdh+qO2oEvXKfKtBQhWl7Hmbr34Yk68EITfCfAQMT
         hAsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678978303;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PKqWcLfcs3UmhMvL5K01K9FuLeIx9ZVjwoD0JyqWTuo=;
        b=7lkjMlXhbkSjUk281IyJctdfekZQKBnDf0rzEOla+iM5YB5muujmtdUa9xusKthlXB
         tvflsOvskKgOpI/ymXFFAjKMu0o57HH3564aE88eicXyMjJr/VHqTVOeHDHI4OyNgUm2
         ZIEVxW9d3PM1TkMY2VTCvXJ8EsmSbPAlR0MzBZ9g0/9QJQV+hMYcl8dLY6zUkS47B48x
         0O+n7VrlETgy/SAVJ0IohggzucFqv54Z66DXFOCCv+4yQ2E2uPMwHgn7utHsWqQH9Rza
         KmOHe1EDuGaRnI5iI2Q6Ds207OpODQ+/p3GpdUKUsn4AdxRgTfW5RpSmGDBkVvaxBynB
         FWTQ==
X-Gm-Message-State: AO0yUKVvtL5MBAxmMqaisnn++/f7kN5EgB3YesuUEdELAbwKIQVBPDzj
        2ArnI9YoWGY/iejsTu6x2+N2OQ==
X-Google-Smtp-Source: AK7set9ennyVepKlBZYOOwCBNDuA2JSfxamJtSEn8L4rLCJ5oK6uxISaeI6s+YWNUNU3Rpdlud1iiA==
X-Received: by 2002:a05:6214:23cd:b0:56b:fb58:c350 with SMTP id hr13-20020a05621423cd00b0056bfb58c350mr25263549qvb.26.1678978303262;
        Thu, 16 Mar 2023 07:51:43 -0700 (PDT)
Received: from localhost.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id n129-20020a37bd87000000b007456b2759efsm2844070qkf.28.2023.03.16.07.51.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 07:51:42 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     caleb.connolly@linaro.org, mka@chromium.org, evgreen@chromium.org,
        andersson@kernel.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net v3 2/4] net: ipa: add two missing declarations
Date:   Thu, 16 Mar 2023 09:51:34 -0500
Message-Id: <20230316145136.1795469-3-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230316145136.1795469-1-elder@linaro.org>
References: <20230316145136.1795469-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When gsi_reg_init() got added, its declaration was added to
"gsi_reg.h" without declaring the two struct pointer types it uses.
Add these struct declarations to "gsi_reg.h".

Fixes: 3c506add35c7 ("net: ipa: introduce gsi_reg_init()")
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

