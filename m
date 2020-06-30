Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E36EE20F5B0
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 15:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387782AbgF3Nd1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 09:33:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732971AbgF3NdO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 09:33:14 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4158C08C5DB
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 06:33:13 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id k1so16541463ils.2
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 06:33:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NLGLXbQMNnc8WjfyUZyG3CP5YRJLw4TctWKcG9p/1fY=;
        b=Og34JDlmtuj4ZWyd3kF6svBJGNitRgk6p5FKsa/nN75Ah9a3Es3O+eZM45muel+Rhk
         dleUbXgNYLtuEu1EZhtXgIohsx1jZkZShfZo42mG8DCqJhU0xFQzto/2o+ZbGDXBYHk1
         AVqPGWNnIHeMOhdemIMtMrRAXGDaH4D8dUUd5TjvCS7pKPEAzsYqIU7pmeIY2sOJBMiP
         BgejmR7zkKReFMxWg7zwE03VaaPK2SW/Pl9iKISDjDuGn+lGXm4YjDOgjSR7FHVGVEo7
         1b+HDCEPXjfzWLI+SyDHcekCsXTeFmOi6fKfP6gQfm6Yi2Z7JLZcbSBhGUR+xTlTiEZI
         Bkxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NLGLXbQMNnc8WjfyUZyG3CP5YRJLw4TctWKcG9p/1fY=;
        b=fBLh58K7vWqHLlk10r0RSe2rcXvfPaNa8sjKNJLvikj+nwlceOBUlMy5pUpviob3D+
         z+LDyCoy/h8PeDISJvziD3299m7aZOGj1+O7iawVwjb0pORS2tMOvefuQOoijexEdRAv
         fuiJlqG6SUW0CZHUHjnhW2R7kV6lKv6nEDNmPl3zuPt6HADkS9OUFrV8sDbTBfHsGHXv
         Vv9ToXyKRXqAK6jiEel2fFY4JPIylcWbTzXCviW9PVsYDx9hXJ8O1KRcCAk26quci015
         rfiaNXTZ85Sv+oDPhIK8xAMPIWlYh0PcMxEN9Iz0zxRA6YhAtJzM8DtxzHpno1lo/eBv
         erlg==
X-Gm-Message-State: AOAM531F/BqbLimhxS909RpLOqR2iScibDuRpllqgY6tGp1wRHEMm/HT
        haIYjlftGDQbzLZbUSLVZgUu2g==
X-Google-Smtp-Source: ABdhPJw66g+pzD6SChh6fz8L9HaekvjhhDK3h3faS6u77tdaxPXovHmZ0aCeUuLIB3ugdqbs5445Gw==
X-Received: by 2002:a92:9f0e:: with SMTP id u14mr2460094ili.277.1593523993143;
        Tue, 30 Jun 2020 06:33:13 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id u15sm1538776iog.18.2020.06.30.06.33.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2020 06:33:12 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 5/5] net: ipa: HOL_BLOCK_EN_FMASK is a 1-bit mask
Date:   Tue, 30 Jun 2020 08:33:04 -0500
Message-Id: <20200630133304.1331058-6-elder@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200630133304.1331058-1-elder@linaro.org>
References: <20200630133304.1331058-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The convention throughout the IPA driver is to directly use
single-bit field mask values, rather than using (for example)
u32_encode_bits() to set or clear them.

Fix the one place that doesn't follow that convention, which sets
HOL_BLOCK_EN_FMASK in ipa_endpoint_init_hol_block_enable().

Signed-off-by: Alex Elder <elder@linaro.org>
---
v2: No change from version 1.

 drivers/net/ipa/ipa_endpoint.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 566ff6a09e65..0332dcbcaaae 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -671,7 +671,7 @@ ipa_endpoint_init_hol_block_enable(struct ipa_endpoint *endpoint, bool enable)
 	u32 offset;
 	u32 val;
 
-	val = u32_encode_bits(enable ? 1 : 0, HOL_BLOCK_EN_FMASK);
+	val = enable ? HOL_BLOCK_EN_FMASK : 0;
 	offset = IPA_REG_ENDP_INIT_HOL_BLOCK_EN_N_OFFSET(endpoint_id);
 	iowrite32(val, endpoint->ipa->reg_virt + offset);
 }
-- 
2.25.1

