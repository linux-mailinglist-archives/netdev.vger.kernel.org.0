Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7AFC30B389
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 00:28:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231376AbhBAX1t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 18:27:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231341AbhBAX1f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 18:27:35 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0670C06178C
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 15:26:17 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id s24so7786409iob.6
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 15:26:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Zd7FyycW3KcctLd6KYXPpMsa8mRy7OXVhvVd96yduhE=;
        b=x6Zx5mmOYLrYqyolEVeWMSSoYaHG8qWQD7O50XB1xDGSL2PrfJEyowmL6U6r+cgUKq
         lDYmDHt6c9ReVyZeuBO9n7AaUpr5FE3ZOX22gCjqC2yeiS/cYPPfabOqg6L7+FbGpMaJ
         CtTVONvHCKzHsjLYtY/z6//NHB62Kv4LhoppEUR4543w2/Dtd5CFkHNFSq1ezrfLizqn
         IX9YlmtntIZXVM6ZDll+7wQEMasn1VA3ZTLfSIYx9XGfpyW7rfy3VctuLQ8WAe7RRKXm
         GCx8AKZ4fFQb3DLsw4dVNzp7LBFYGL2xk68PKiC7HCBLjVpRIo3/5jdrffbvkf1v54kt
         bsdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Zd7FyycW3KcctLd6KYXPpMsa8mRy7OXVhvVd96yduhE=;
        b=VGdLjOAKCJzbp+B1P/TQsZVlIjGQqlGJf2hf71oTUIXgNjB27st6CAxzpygl4vseNP
         ObyqyXYcrVg18cCVa+anRz5W26OJn23NNC6JX60QZBgyrO+AjT3GQiZq0GMQJnEE8e4Z
         ficSbrR28hee91CSuXSGSHahAL6zGSJj2ahhZQEmx1Y5jUzp6VRci4OfzVDKhQ7tnPEe
         V0vOlLkjDW74jvUOMplUziD2s7uO/YDj5el9zi1/gs3IM5f8nfjIwM0BphCInAbfjFPo
         QLldPuDcQxbuLycnBDdEDpa1Jrw1DY7+0wzTJQkjb+bJSPazVkjdNzQMmxrAAkKvR9om
         8JaQ==
X-Gm-Message-State: AOAM532vULClq1a0TDG8fCMuMVGDdPEhSttk7Loonq2Tae3ktJ16vNjv
        cKw0ecHfK+ng9xz3oyeTD0KwfQ==
X-Google-Smtp-Source: ABdhPJyaO9e8s9+LRsKruGS69fzHUr6vWkVzpKTYn9TM2WjIlalWUeX5YFy76SzfWy9kkBO320BpVQ==
X-Received: by 2002:a5d:9041:: with SMTP id v1mr14086354ioq.155.1612221977473;
        Mon, 01 Feb 2021 15:26:17 -0800 (PST)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id v18sm10359588ila.29.2021.02.01.15.26.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 15:26:16 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     elder@kernel.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net 4/4] net: ipa: fix two format specifier errors
Date:   Mon,  1 Feb 2021 17:26:09 -0600
Message-Id: <20210201232609.3524451-5-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210201232609.3524451-1-elder@linaro.org>
References: <20210201232609.3524451-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix two format specifiers that used %lu for a size_t in "ipa_mem.c".

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_mem.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ipa/ipa_mem.c b/drivers/net/ipa/ipa_mem.c
index 0cc3a3374caa2..f25029b9ec857 100644
--- a/drivers/net/ipa/ipa_mem.c
+++ b/drivers/net/ipa/ipa_mem.c
@@ -336,7 +336,7 @@ static void ipa_imem_exit(struct ipa *ipa)
 
 		size = iommu_unmap(domain, ipa->imem_iova, ipa->imem_size);
 		if (size != ipa->imem_size)
-			dev_warn(dev, "unmapped %zu IMEM bytes, expected %lu\n",
+			dev_warn(dev, "unmapped %zu IMEM bytes, expected %zu\n",
 				 size, ipa->imem_size);
 	} else {
 		dev_err(dev, "couldn't get IPA IOMMU domain for IMEM\n");
@@ -440,7 +440,7 @@ static void ipa_smem_exit(struct ipa *ipa)
 
 		size = iommu_unmap(domain, ipa->smem_iova, ipa->smem_size);
 		if (size != ipa->smem_size)
-			dev_warn(dev, "unmapped %zu SMEM bytes, expected %lu\n",
+			dev_warn(dev, "unmapped %zu SMEM bytes, expected %zu\n",
 				 size, ipa->smem_size);
 
 	} else {
-- 
2.27.0

