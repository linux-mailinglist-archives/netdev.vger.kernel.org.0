Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B92A527B79F
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 01:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727182AbgI1XOI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 19:14:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727090AbgI1XNn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 19:13:43 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF06EC05BD1A
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 16:04:58 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id v13so826468ilc.7
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 16:04:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=y3er6mNwMu5Sx26fZeVu6K2o8G6XAAQwU5jOGoe2b5s=;
        b=iWp1yNl750KTH5K1EKPuDUL4V06zOqAX2I7JtzpibswLAMpqw4c8Adpj2G81Z8pUKS
         xX5E+Uk67BKU61O2f1AfG1HvriDxeMP3SJuwVp4FiFId5vnKmHmijTasdMvBP6z4RMfy
         Y/vBhbEvZCKTXfJHIMgJX7c0V8nBtbwBxRc/jNonuNb9a+RdXbt+nZSpyFlkYlBQnS79
         SHNwsOau3+DCAYEYBnkyx4EdNM+9V9Pd9U/vnjhkB/JcjEhMe0I12n2qVt+PU175Fcu2
         WWsbrSXmp3VjBILjFT5pZTRIoD8qmKpAIjKnilPUfBHwplq42UcnLZ6JWjj6cHz0CmO2
         uw4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y3er6mNwMu5Sx26fZeVu6K2o8G6XAAQwU5jOGoe2b5s=;
        b=M/TwGNi2t02tVdWIPwsivSydM+6RKMasbKJo9TLI+aqlqTqWVdHKOK14XYHzHV8ps2
         lhrN90HOCgukiR598/w0CGbpPpc6GK95u7eA0xKAJCO1kiz5pFXt6oHcQnwgyJfC1Pax
         iCZI8eAGHi3csvNDN8mgyhHVhDJyVvZB3SmIjStM9QA4K8nOFvTSVeNQqGGpNW/o4wOv
         nIWUfXpQ2sLMsEHGnc50tNgmeglQvP594kiX2xY7sI2W5OJUNwtnp+miU6RwfYqjRqBt
         XOX3BFkD0fzwJ7SxQ9pjaMddtvBML/ZMH4WZ7arcjUNJsxR4Yp5xng7FXwkbUxo8Iann
         t5SA==
X-Gm-Message-State: AOAM533q1BSNfMVo/C6CLOC6sRE90j0xUXtyuAame00piO16/5U8SUdL
        TfKQ8RL5dHuvTuV88Cr23VPvvQ==
X-Google-Smtp-Source: ABdhPJxlQl3tMX0qEez6qvL7U8ZHeXxnadQbaiO9g8p6vD9qn3PaTsXyHvtqfWSN4yNWUntZ726TVA==
X-Received: by 2002:a92:2602:: with SMTP id n2mr631739ile.82.1601334298144;
        Mon, 28 Sep 2020 16:04:58 -0700 (PDT)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id 137sm1009039ioc.20.2020.09.28.16.04.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2020 16:04:57 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 08/10] net: ipa: fix two mild warnings
Date:   Mon, 28 Sep 2020 18:04:44 -0500
Message-Id: <20200928230446.20561-9-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200928230446.20561-1-elder@linaro.org>
References: <20200928230446.20561-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix two spots where a variable "channel_id" is unnecessarily
redefined inside loops in "gsi.c".  This is warned about if
"W=2" is added to the build command.

Note that this problem is harmless, so there's no need to backport
it as a bugfix.

Remove a comment in gsi_init() about waking the system; the GSI
interrupt does not wake the system any more.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index cb676083dfa73..6bfac1efe037c 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -1600,7 +1600,7 @@ static int gsi_channel_setup(struct gsi *gsi, bool legacy)
 	/* Compute which modem channels need to be deallocated */
 	mask ^= gsi->modem_channel_bitmap;
 	while (mask) {
-		u32 channel_id = __fls(mask);
+		channel_id = __fls(mask);
 
 		mask ^= BIT(channel_id);
 
@@ -1628,7 +1628,7 @@ static void gsi_channel_teardown(struct gsi *gsi)
 	mutex_lock(&gsi->mutex);
 
 	while (mask) {
-		u32 channel_id = __fls(mask);
+		channel_id = __fls(mask);
 
 		mask ^= BIT(channel_id);
 
@@ -1972,7 +1972,6 @@ int gsi_init(struct gsi *gsi, struct platform_device *pdev, bool prefetch,
 	 */
 	init_dummy_netdev(&gsi->dummy_dev);
 
-	/* Get the GSI IRQ and request for it to wake the system */
 	ret = platform_get_irq_byname(pdev, "gsi");
 	if (ret <= 0) {
 		dev_err(dev, "DT error %d getting \"gsi\" IRQ property\n", ret);
-- 
2.20.1

