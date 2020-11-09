Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3381F2AC182
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 17:57:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730956AbgKIQ4v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 11:56:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730914AbgKIQ4p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 11:56:45 -0500
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E905C0613D4
        for <netdev@vger.kernel.org>; Mon,  9 Nov 2020 08:56:44 -0800 (PST)
Received: by mail-io1-xd41.google.com with SMTP id n12so10508612ioc.2
        for <netdev@vger.kernel.org>; Mon, 09 Nov 2020 08:56:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=e5NRbYsOo+mspumDtpUEM/+OEsVGUUWKaYNV+1cLmV4=;
        b=n2hLQ7PHR3cMzHVOFkT8wDfl5WJbEyE2GW1mdy0w/0zYQtDrGdHtRa5QQkWlZxb5Hr
         ZiWMQ4SWjn76IQEWW6bs+66vkbmPjrt3SckLb2CZHkW+p9Wak7QEf5bBuj4VzDJAYANR
         26uzhkzrwmiuiGFzwkT2T2MfSJkJlOlFCVp/kYBmRTh15+fi74ulQZ7XJvWatsnYDW0Y
         T2bG7COiMZqnbvoXO+dF9fb6msEE0blbS5ZJ5IFPkB5PVOHlp3sfiSmFSGsqhdje+l6q
         lV7Clecaxjr4+g+ck1g54xmyck3PQ7MnZd+oNon49VOoPdS5EzO3Xa5SMgMhdBJ2VOSm
         MYjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=e5NRbYsOo+mspumDtpUEM/+OEsVGUUWKaYNV+1cLmV4=;
        b=s1+IZCmqOO6ggY3cTlH6LvCzB/o7d2Z5n877HA+7Ap/a/aQlreIagTLt+UHT2YRl34
         Q8Tf6Yw0WYGtPYj3LBo+BduZAp4XpUGTgRu0q/7T6SGjucFxgFPDry4b4JYFDl/q/Wrp
         ToJggIZduCp9ZvUCPlMFGhQe6tGdS1Xnxe5AT4V49UrO2Ox57DBxIMYRBR7mWvrGH5sf
         8H+KDLhTSJOAtrt1vMqwKY4CWQUhDbtY0Ph3sT8GBM+M9vUHdulqlAXhbOT04re5FoWG
         9Hh70b7p58t5zvL4XaD+B/3h7l/rWQDHCZOn/nsa1OX65CvDfa0whlUB9/9wSr8n2Esd
         +kMw==
X-Gm-Message-State: AOAM530kpCBs0uWyOafukv16LOw8q+ML/EBkpB5b8FvLXPhIACMqGRgl
        MFRfmSrS8xb5xgRBqx81TJVsZRhwwu9uwvq8
X-Google-Smtp-Source: ABdhPJyvpQkup+PqYKcGOz1XWcaLrFZp3jPITkhcqvG5RUmPyI6LkmNKk9zVqFmftzPFPVRQpOtY+g==
X-Received: by 2002:a05:6602:21c2:: with SMTP id c2mr10882933ioc.184.1604941003739;
        Mon, 09 Nov 2020 08:56:43 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id j85sm7576556ilg.82.2020.11.09.08.56.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 08:56:43 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 4/4] net: ipa: drop an error message
Date:   Mon,  9 Nov 2020 10:56:35 -0600
Message-Id: <20201109165635.5449-5-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201109165635.5449-1-elder@linaro.org>
References: <20201109165635.5449-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no need for gsi_modem_channel_halt() to report an error,
because gsi_generic_command() will already have done that if the
command times out.  So get rid of the extra message.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 961a11d4fb270..3a5998a037dab 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -1661,12 +1661,7 @@ static int gsi_modem_channel_alloc(struct gsi *gsi, u32 channel_id)
 
 static void gsi_modem_channel_halt(struct gsi *gsi, u32 channel_id)
 {
-	int ret;
-
-	ret = gsi_generic_command(gsi, channel_id, GSI_GENERIC_HALT_CHANNEL);
-	if (ret)
-		dev_err(gsi->dev, "error %d halting modem channel %u\n",
-			ret, channel_id);
+	(void)gsi_generic_command(gsi, channel_id, GSI_GENERIC_HALT_CHANNEL);
 }
 
 /* Setup function for channels */
-- 
2.20.1

