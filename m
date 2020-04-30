Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E19B91C097E
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 23:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728140AbgD3Vf0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 17:35:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727077AbgD3VfW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 17:35:22 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 223ADC035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 14:35:21 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id i68so6422174qtb.5
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 14:35:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=C4NZHd20DqH/vMopbnAr3CvIxlhLY+CMbHfzvIpU5fo=;
        b=FAkKib5UEUdJ8vrJ3fEKyY/s8lgMD7f5u4GS4xdPjhvVpDtOAC8ykkeJnOk9FbzU3b
         kmwrBahaK3+c+ARuIT6QoV3cVvis5z4O4onUhhXh2d8K3Q+GngbIOhXHY3/WTLU6J+6V
         fM6JoA3LMLm7BWJkOiU5uB0Hwsfc4WwZiBxQ8K4nPkWZHUc4Fr1ugvPHifEUl8bbBBSY
         cmZtYlfn+btahEQeH4+Ht8tRliKWoZf3Cg8juMNLcyqZWrfCk2hzMvuTxlrns1XwGGzy
         vOJGflAAQL7XqHv6DcYQxjS2I6ArwHEy7PEy9gDKdC48OReAKAvOmiDA7xP54KrJRo48
         LJVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=C4NZHd20DqH/vMopbnAr3CvIxlhLY+CMbHfzvIpU5fo=;
        b=WcYmYhKb92fXYEqbzeNt+SiK8hDGhEOlWo6GEeZ6TfZrEOZed5X/V4anKPJ3xNZJow
         TGrxViiLZAERn2Yp/7bu4JYN3cMCIq/EzKvRe51i325OF+lh0VdUVhu+TC52WvMqYjwP
         HFvbYhN79goun18/wMCttIpw/yhwO8j8Qa3psKUoqmhPoxBMRsGTK9hbipv2ETfKp/pt
         ctw3K191MDvPOdcyquOI0QOD6hiwTNVOCma2Za0AWU4+ZkQzqIvzHGFso6hgHIl/tJyY
         NL6qzy9vMR5A+zxnjXUJg/RoCl3xllPddlUIHjDTOj1hoR2UiyCOXU7dfgDt6xTcg42V
         +z9g==
X-Gm-Message-State: AGi0Puae8gb1Hikt8aT3P1y7uV0Eq5vuhB8PCEI6A8ePY+aLioGDahqg
        H+5iB5dXz2EoQi+1rI6kN/M6AA==
X-Google-Smtp-Source: APiQypI9hbKnj1Bz3fAGJul0OELxHEBWAad+NzSj8OX1wtfY7PAuFyORwlaik3yuLFedpJoPks83Hw==
X-Received: by 2002:ac8:312e:: with SMTP id g43mr625184qtb.256.1588282520338;
        Thu, 30 Apr 2020 14:35:20 -0700 (PDT)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id s190sm1112543qkh.23.2020.04.30.14.35.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2020 14:35:19 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net
Cc:     evgreen@chromium.org.net, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net 2/3] net: ipa: fix an error message in gsi_channel_init_one()
Date:   Thu, 30 Apr 2020 16:35:11 -0500
Message-Id: <20200430213512.3434-3-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200430213512.3434-1-elder@linaro.org>
References: <20200430213512.3434-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

An error message about limiting the number of TREs used prints the
wrong value.  Fix this bug.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 845478a19a4f..b4206fda0b22 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -1798,9 +1798,9 @@ static int gsi_channel_init_one(struct gsi *gsi,
 
 	/* Worst case we need an event for every outstanding TRE */
 	if (data->channel.tre_count > data->channel.event_count) {
-		dev_warn(gsi->dev, "channel %u limited to %u TREs\n",
-			data->channel_id, data->channel.tre_count);
 		tre_count = data->channel.event_count;
+		dev_warn(gsi->dev, "channel %u limited to %u TREs\n",
+			 data->channel_id, tre_count);
 	} else {
 		tre_count = data->channel.tre_count;
 	}
-- 
2.20.1

