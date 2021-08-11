Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2F603E9326
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 15:59:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232154AbhHKOAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 10:00:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231781AbhHKOAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 10:00:15 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40790C061765
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 06:59:52 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id d22so3720221ioy.11
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 06:59:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G3+CVK8r94N1sJaYl4cTeuh/cF4j3sRvIlNBySKEKgY=;
        b=UvGovQgQKWUzbDOXmQsvIcU8ygpRqh4fGDHVh1WZ6N85572t1rBjrInpFRa4khdKY5
         3ir4Y1ftdGzTYbi6xgDSa/QYDH7vJgrUqIso09Z1Xd5HvjRusTCEpB8r6zZcHQ61Fxlx
         OI/+OsJ98gw9mcRYUuqHx0/wxIPnK/jYi0rkw7IyBSEjb9xsOg6YuiYO8GzjHvam9+rQ
         Wa3r0ft5fUJffGYHi9vc+gmAte/NaKn15PR7K+6Kg6uAT/2qT0veb2Xc7Iui/SYJe0bb
         CpGov3Sk6IQ0AZWwtg40eAx5oSt0xtyS/fNU4oh5Pg/gr9+VehPfdDOB/Ug9GNvXXwKA
         +GUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G3+CVK8r94N1sJaYl4cTeuh/cF4j3sRvIlNBySKEKgY=;
        b=mzHSJ31m3IODGf32nOrNOjpm9/PnXvWeW6kIeyE1hbU9DEDhhCPpNAEjf1epcd244c
         NEwzP1jR3s3eT49VY2YgZf0HPuSvbCsNWmAARqnKP4L6H04gML+6D05/YX7LjTjPUVIj
         VcYMrj//5u9hcd6Cfvrg8GLfRp9W/82Ohs1LtVni0PUH2D3nFZ8RnXdmtY9CFny7AUfU
         zVr5YKWync5mqaKNwaD7at9Y0/JoBpED7FM8Nln0hdUirBHA8EJW1DGDk9Utvt+Uogtl
         2C4hIU4a1PBqlIAmfUcpV03oekyYn6q/VGqgIHgR3TRHtuLenNhMY+Bl36x0R7zAdb9B
         K62w==
X-Gm-Message-State: AOAM533lnUNXZel8oJ+HkZLBIz45jfnfRWIPLl9accwoK3e0CnsbltjF
        7q/4+b9doUxAFZ0sEZKXvjzq+zkXbQbOgQ==
X-Google-Smtp-Source: ABdhPJyNYBQRIlZS3VNVkzqaDxzSpyNry4pJECFYY9t/dYAQRaILavwYMsWL5nAmW8mzn+M8eictaQ==
X-Received: by 2002:a05:6638:2590:: with SMTP id s16mr28628567jat.121.1628690391653;
        Wed, 11 Aug 2021 06:59:51 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id i18sm4915165ilk.84.2021.08.11.06.59.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 06:59:51 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     leon@kernel.org, bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, lkp@intel.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2] net: ipa: always inline ipa_aggr_granularity_val()
Date:   Wed, 11 Aug 2021 08:59:48 -0500
Message-Id: <20210811135948.2634264-1-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It isn't required, but all callers of ipa_aggr_granularity_val()
pass a constant value (IPA_AGGR_GRANULARITY) as the usec argument.
Two of those callers are in ipa_validate_build(), with the result
being passed to BUILD_BUG_ON().

Evidently the "sparc64-linux-gcc" compiler (at least) doesn't always
inline ipa_aggr_granularity_val(), so the result of the function is
not constant at compile time, and that leads to build errors.

Define the function with the __always_inline attribute to avoid the
errors.  We can see by inspection that the value passed is never
zero, so we can just remove its WARN_ON() call.

Fixes: 5bc5588466a1f ("net: ipa: use WARN_ON() rather than assertions")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Alex Elder <elder@linaro.org>
---
v2: Drop WARN_ON() call, as suggested by Leon Romanovsky

David/Jakub, the bug this fixes is only in net-next/master.

 drivers/net/ipa/ipa_main.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index f332210ce5354..581b75488c6fe 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -253,12 +253,11 @@ ipa_hardware_config_qsb(struct ipa *ipa, const struct ipa_data *data)
 /* Compute the value to use in the COUNTER_CFG register AGGR_GRANULARITY
  * field to represent the given number of microseconds.  The value is one
  * less than the number of timer ticks in the requested period.  0 is not
- * a valid granularity value.
+ * a valid granularity value (so for example @usec must be at least 16 for
+ * a TIMER_FREQUENCY of 32000).
  */
-static u32 ipa_aggr_granularity_val(u32 usec)
+static __always_inline u32 ipa_aggr_granularity_val(u32 usec)
 {
-	WARN_ON(!usec);
-
 	return DIV_ROUND_CLOSEST(usec * TIMER_FREQUENCY, USEC_PER_SEC) - 1;
 }
 
-- 
2.27.0

