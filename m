Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B81A4A6046
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 16:37:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240489AbiBAPh4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 10:37:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240488AbiBAPhp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 10:37:45 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCEC7C06173B
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 07:37:45 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id e79so21630220iof.13
        for <netdev@vger.kernel.org>; Tue, 01 Feb 2022 07:37:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yBiZZz1/NPVKpecgM8sZYmPy5LVgZiPd3RTXAo466MU=;
        b=HPCWdCGi+HlGqTGBgUD0GIrUJF9YEObheXYdQRvjKoYrSFb+C5jhR+2iPEZHFXZTMR
         /LjZS3Opk4mgz/lVEHdcjT4rNe4IzgwuPbU9Vg9WpkZGZlfBPdk5v4DPW5+STiAQtO5y
         F7rn/fGb7gczkCxzXEiOqMbY9jsYri9LbgxKWxgTBBWbhnwMbT9zwSOzDSW3PFUPv14r
         0dZ7R+qcr50Ag2pRo9jDTFO79aLiTP9u+wDl/b9jJI45NGTwWOZo4tX/8x7JHW6f4Nx3
         kGWWBA7peoWg292nz2bQRxtEhL24AaiOpIA5rS0NMd6XTIqjTbwbsw9L0hBYX6/iGo44
         HZDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yBiZZz1/NPVKpecgM8sZYmPy5LVgZiPd3RTXAo466MU=;
        b=jZLLsVboLNbxOMOKMrHq98KtAYC1N6xjgjQyZZK4/VmCR0weXeTDZqx/l584d5LDpB
         qgvHjP2LwDP8yRUuKSlK9aFCnYGaKq2eq5voCcVvYJl6/7MnLT9qj+05D9VR+tPOnizP
         4Qzc0GtReVKy2/0Q/gay9ALfnIHKLWfJolBkdzgZbF/yHLDszx4Mvsd0V2yBU29x/lE1
         Y8uUv7FMdzT7PEpYhnYsrVJpGw2lAWpTtElLlhcLkF5FPbOPG2QkX7ydqHPZO1pZy7vU
         xfRxAQ5iScCDmenfJl42Yr5Fu8vPQzq2qTqgW4/mbU5Zv19Md3vOW/BW7sX+oH56kB73
         fsPQ==
X-Gm-Message-State: AOAM533qS+83kXOygeraY9p5wCUBoHs71Pr9ahpDxlXGHP2OS6jjfDYH
        dZFMA72HlS75jAfaEEz/6UbOeg==
X-Google-Smtp-Source: ABdhPJz//G7nSbZNcFnRLJQppjxJN5pz9lAKJVKU6Kz4Fxatt/29OjsY/I4QaMTX7LixQuRhUvhPGg==
X-Received: by 2002:a02:cab8:: with SMTP id e24mr8654963jap.33.1643729864828;
        Tue, 01 Feb 2022 07:37:44 -0800 (PST)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id n12sm1234583ili.69.2022.02.01.07.37.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 07:37:44 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, agross@kernel.org, mka@chromium.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        avuyyuru@codeaurora.org, jponduru@codeaurora.org,
        subashab@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/2] net: ipa: set IPA v4.11 AP<-modem RX buffer size to 32KB
Date:   Tue,  1 Feb 2022 09:37:37 -0600
Message-Id: <20220201153737.601149-3-elder@linaro.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220201153737.601149-1-elder@linaro.org>
References: <20220201153737.601149-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Increase the receive buffer size used for data received from the
modem to 32KB, to improve download performance by allowing much
greater aggregation.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_data-v4.11.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ipa/ipa_data-v4.11.c b/drivers/net/ipa/ipa_data-v4.11.c
index 8f67c44e19529..b1991cc6f0ca6 100644
--- a/drivers/net/ipa/ipa_data-v4.11.c
+++ b/drivers/net/ipa/ipa_data-v4.11.c
@@ -134,7 +134,7 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 				.qmap		= true,
 				.aggregation	= true,
 				.rx = {
-					.buffer_size	= 8192,
+					.buffer_size	= 32768,
 					.aggr_close_eof	= true,
 				},
 			},
-- 
2.32.0

