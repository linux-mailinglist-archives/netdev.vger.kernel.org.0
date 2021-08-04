Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 395963E0279
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 15:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238415AbhHDNyY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 09:54:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238406AbhHDNyX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 09:54:23 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E128CC0613D5
        for <netdev@vger.kernel.org>; Wed,  4 Aug 2021 06:54:10 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id i13so1716720ilm.11
        for <netdev@vger.kernel.org>; Wed, 04 Aug 2021 06:54:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=g50hMA8civVRQsXmP2D/YUX+vZIHViVyDmuVOssC7Q4=;
        b=w30c93KUxVwBZ3VBYyjcQ5MRZNYgMyjG3joOSYAjPkcGbx20slrAlpUcwJK3ymPSY0
         Esfmr/2LqmnuJibtqthwzXWppseDwGodWk8FQBv4oA2HIEaUMYhKwHs7qHw9RYXYeZ+0
         mMLj5dniy1j9q/Dn3FdV5KNnUFUYxsJN4InedxNviIgAR4VseFUFx/t4w0g9n4wZ/xNl
         Yhqh1oAnX3I3z9BWONJoUg2HVip7b6ro0yufEN961cNy9T041HFIAkkJMDFk+LsgxNkd
         qXJ20dR9Eum9RlUnXtBs3vATn0Qofa9xvOUNWEGtEtun1j6h4MOxwGAseJIoKJYT00O4
         O2lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=g50hMA8civVRQsXmP2D/YUX+vZIHViVyDmuVOssC7Q4=;
        b=rTsKH8rzo0eCAb6UeEHR73+DBr3nFs4GUgNWnE5yD+N1CohwGLTwXrqNQKmnQQbBFz
         ETTpQiDtIivm4DD7bZb4a2fsFktEBqOhR6lQkCSKhi3lJQezsUiL7EY7nyYdamaDaysY
         x4wfEPVGrUfzXY9e0yBdjB5cDfNPMKhwoQfNAywQZNzukjvNRBjFfGGCrAvzsDhjSqFC
         CODXrcp8tzQUERSR4BswRO7ZObiV98hgkHClAe4MVL8iJ6w8pAcBMWeqrgRVhhmzwKx2
         oGyqotqxbm750b/BBFSgztZmrIefzcAOkSYlaA+dW9P9enfl+8Fb2SVhT9Q9tsHghXp9
         yoLw==
X-Gm-Message-State: AOAM531yoHqliPwC6YC+Y1aaNnij5LgpOD21FFrSAsdP9iti2aXLmwla
        dvPzdOXbdjOe9SwhbjpppzzZKA==
X-Google-Smtp-Source: ABdhPJzex53u8AjjVTmpXuIDf7FPBhso4k/tfZ8vBiCbthjtgJhftF6AheWv9bgVaAaMPr4Dg/tvgw==
X-Received: by 2002:a92:dacf:: with SMTP id o15mr211090ilq.27.1628085250311;
        Wed, 04 Aug 2021 06:54:10 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id w8sm1062088ill.50.2021.08.04.06.54.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Aug 2021 06:54:09 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: ipa: fix IPA v4.9 interconnects
Date:   Wed,  4 Aug 2021 08:54:07 -0500
Message-Id: <20210804135407.1358606-1-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Three interconnects are defined for IPA version 4.9, but there
should only be two.  They should also use names that match what's
used for other platforms (and specified in the Device Tree binding).

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_data-v4.9.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ipa/ipa_data-v4.9.c b/drivers/net/ipa/ipa_data-v4.9.c
index 6ab928266b5c1..8d83e14819e29 100644
--- a/drivers/net/ipa/ipa_data-v4.9.c
+++ b/drivers/net/ipa/ipa_data-v4.9.c
@@ -418,18 +418,13 @@ static const struct ipa_mem_data ipa_mem_data = {
 /* Interconnect rates are in 1000 byte/second units */
 static const struct ipa_interconnect_data ipa_interconnect_data[] = {
 	{
-		.name			= "ipa_to_llcc",
+		.name			= "memory",
 		.peak_bandwidth		= 600000,	/* 600 MBps */
 		.average_bandwidth	= 150000,	/* 150 MBps */
 	},
-	{
-		.name			= "llcc_to_ebi1",
-		.peak_bandwidth		= 1804000,	/* 1.804 GBps */
-		.average_bandwidth	= 150000,	/* 150 MBps */
-	},
 	/* Average rate is unused for the next interconnect */
 	{
-		.name			= "appss_to_ipa",
+		.name			= "config",
 		.peak_bandwidth		= 74000,	/* 74 MBps */
 		.average_bandwidth	= 0,		/* unused */
 	},
-- 
2.27.0

