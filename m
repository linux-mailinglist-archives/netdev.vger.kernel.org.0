Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 479B92CBF58
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 15:16:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730244AbgLBOPx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 09:15:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728065AbgLBOPw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 09:15:52 -0500
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA390C0617A7
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 06:15:05 -0800 (PST)
Received: by mail-il1-x144.google.com with SMTP id w8so1630196ilg.12
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 06:15:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Z4tstK0yqPb2/7JG4Zvyh0/BHtCKh0NvGTuUjF86KO8=;
        b=hi0ZCu9a/qhdCc/pSu+owQ9WlAOD9fALklksTCXzjDJta5mR5asDZqsMf4LYrp1xhk
         NQVP4eFXo7nt5IOjz5bMVcOMzrgzUKbME0kK4NoTr5itiCUCe3elSS4DjeP1p1pTfYDN
         sjYXyXVo9JEd49AegFuR50gvoZiYdClbcPKKnEQZaPuOfWwn80kDHS0P/aSbbO5N+Brl
         i7cfu/14F0wXK1W4oQj33c+ow+rXmmHJSqSgq1wiTYpw4rAa1lX8C7YFxZwCHtbULIV6
         2rfvpLhd+okSPKxLXZgfe4qyn0iToCc/TuTZ0MtTdt+utL1M3HVkdr6aNBw/Yfc4Fu7M
         Bd+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Z4tstK0yqPb2/7JG4Zvyh0/BHtCKh0NvGTuUjF86KO8=;
        b=phIjQKxY4/Xf3iW8MuivQ5TPweUdqVR4Es+4IanOG1QowyLxdwbp7WbbsnqdwQe+lT
         nBm/CLZAx8ZG9PLsbgwSBzhYAoytszSEon+v/eNjozsryU2TiC7EwlsJ8zupFBu2dL2O
         6+vgw5woZHNCqbEG7wn3e0AwnRqj/GRQhirpvjE3ITrgNZZHlUiGtocu1+YCbjFtF8XN
         ylZP6kPQ/Qkn7oK2VkteBX2o50rS/2ncGTbprw+LcQaKrLl/y7MqD6V7GpfrpKR67f+C
         //YvhBHj4MCWQMLboCI8HAfYWzoeOFjFPMcw5W1D6KzGgQ/aILzj0NNDe37nfpm/cHe9
         xtLg==
X-Gm-Message-State: AOAM532qszvIA0rGBVFq+MZ/tqKpBAHeP+xndhVtTl6ZIaMs0m1FtIIN
        c6aILUUvUbmcdN0RsYon9asJvw==
X-Google-Smtp-Source: ABdhPJyqpvXdZVu3cyMSHDhHV4Q0ygSPRGs9U4eTo0CySNT0sdCtks1N5D9pZJ1GkPbNPd2JzxOXfQ==
X-Received: by 2002:a92:ab02:: with SMTP id v2mr2507769ilh.184.1606918504945;
        Wed, 02 Dec 2020 06:15:04 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id e18sm1209151ilc.52.2020.12.02.06.15.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 06:15:04 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     jonathanh@nvidia.com, evgreen@chromium.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        subashab@codeaurora.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next] net: ipa: fix build-time bug in ipa_hardware_config_qsb()
Date:   Wed,  2 Dec 2020 08:15:02 -0600
Message-Id: <20201202141502.21265-1-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jon Hunter reported observing a build bug in the IPA driver:
  https://lore.kernel.org/netdev/5b5d9d40-94d5-5dad-b861-fd9bef8260e2@nvidia.com

The problem is that the QMB0 max read value set for IPA v4.5 (16) is
too large to fit in the 4-bit field.

The actual value we want is 0, which requests that the hardware use
the maximum it is capable of.

Reported-by: Jon Hunter <jonathanh@nvidia.com>
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Alex Elder <elder@linaro.org>
---
v2: Got confirmation that 0 is the desired value to use (with comment).

 drivers/net/ipa/ipa_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index d0768452c15cf..84bb8ae927252 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -288,7 +288,7 @@ static void ipa_hardware_config_qsb(struct ipa *ipa)
 		max1 = 0;		/* PCIe not present */
 		break;
 	case IPA_VERSION_4_5:
-		max0 = 16;
+		max0 = 0;		/* No limit (hardware maximum) */
 		break;
 	}
 	val = u32_encode_bits(max0, GEN_QMB_0_MAX_READS_FMASK);
-- 
2.20.1

