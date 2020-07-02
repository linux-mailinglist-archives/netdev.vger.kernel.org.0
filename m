Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 265C0212235
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 13:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728776AbgGBLZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 07:25:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728732AbgGBLZp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 07:25:45 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ED72C08C5DC
        for <netdev@vger.kernel.org>; Thu,  2 Jul 2020 04:25:45 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id a11so15622270ilk.0
        for <netdev@vger.kernel.org>; Thu, 02 Jul 2020 04:25:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rR58cBjanAUUwIaKuqJhjnKAVxmgw030sKlpPy2ZOVM=;
        b=dJdvXMMgpr8N4bUkWkmdBpT4XYQBJE+U6C0mgHD7bH0wNCQLXscuLv490ZHRWkOL/n
         sgyf9bMWAYV8RoF4fb1su+z7+g80GGo9BuGGWgO43WS+7Ol3Q9ffmMEUxb9F0xslVcS4
         gQXeJS+SibKI+4p/h4LWXX1J1DhkqozTBXqu6NKVdoUvjRzg5mb7TicBkUiZl7+uaTYX
         Q98K0ViIPRPisdBzOTzxPUH9+b0rSaSpEjyIlN6ssnJ5vKobDk3QistVneJhbcjMH6UT
         gg3UoQ5rL5yWCE51BQV1VYmKJg6DeyqSIsN+D25zm0nDST+oMO/6GUBBQU0T0rLvwBTO
         T/sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rR58cBjanAUUwIaKuqJhjnKAVxmgw030sKlpPy2ZOVM=;
        b=Ts/iXOYtreiP0KvNGNQJrebdGJuhRaX90jSbKltzlLtH0K8dO8uXmpL2rJwm479U0e
         7h6p8hTZxCtZeaXCzqxwdTC3mCGTSlOF1z0jXMXjcw3hvAkIVWoHFzdBPnislX3nhw+h
         Xwe2Knmg8vKQ4RMh6tLX7g++8iTOCQYSbTKgc2d/iowrhULNUWw8L5KtlQW4ykjvxq2q
         f+cux2kRXX9DoHKQhXAVnmR6oeTqKhdyQ53P/sbxm64YElcGEFzF9JSee9GmTLQu0xyI
         MWQkXpXS3wHV7ZuQxMCrlr8JqemjhhiO8P6m9U8HhkOHC6VyAYX7P/GM3C7G6HSwHARY
         puqg==
X-Gm-Message-State: AOAM530pe5j5mzQs+luLYRUUSEWYwur0cetQh0XAvM6+hVtubDa15Q/N
        /r+dbR3jYEIDlLJRGSDttxNHMQ==
X-Google-Smtp-Source: ABdhPJwEA7/RU/orhQxNAvBXxikBGea257nKE0EU7AuCwesXC94lXAsAYkjhr0t7E117oJ9ZJ1QHjA==
X-Received: by 2002:a92:91c2:: with SMTP id e63mr11612997ill.64.1593689144910;
        Thu, 02 Jul 2020 04:25:44 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id c3sm4692842ilj.31.2020.07.02.04.25.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2020 04:25:44 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/4] net: ipa: move version test inside ipa_endpoint_program_suspend()
Date:   Thu,  2 Jul 2020 06:25:36 -0500
Message-Id: <20200702112537.347994-4-elder@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200702112537.347994-1-elder@linaro.org>
References: <20200702112537.347994-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IPA version 4.0+ does not support endpoint suspend.  Put a test at
the top of ipa_endpoint_program_suspend() that returns immediately
if suspend is not supported rather than making that check in the caller.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_endpoint.c | 29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index d6ef5b8647bf..df4202794e69 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -378,6 +378,9 @@ ipa_endpoint_program_suspend(struct ipa_endpoint *endpoint, bool enable)
 {
 	bool suspended;
 
+	if (endpoint->ipa->version != IPA_VERSION_3_5_1)
+		return enable;	/* For IPA v4.0+, no change made */
+
 	/* assert(!endpoint->toward_ipa); */
 
 	suspended = ipa_endpoint_init_ctrl(endpoint, enable);
@@ -395,26 +398,22 @@ ipa_endpoint_program_suspend(struct ipa_endpoint *endpoint, bool enable)
 /* Enable or disable delay or suspend mode on all modem endpoints */
 void ipa_endpoint_modem_pause_all(struct ipa *ipa, bool enable)
 {
-	bool support_suspend;
 	u32 endpoint_id;
 
 	/* DELAY mode doesn't work correctly on IPA v4.2 */
 	if (ipa->version == IPA_VERSION_4_2)
 		return;
 
-	/* Only IPA v3.5.1 supports SUSPEND mode on RX endpoints */
-	support_suspend = ipa->version == IPA_VERSION_3_5_1;
-
 	for (endpoint_id = 0; endpoint_id < IPA_ENDPOINT_MAX; endpoint_id++) {
 		struct ipa_endpoint *endpoint = &ipa->endpoint[endpoint_id];
 
 		if (endpoint->ee_id != GSI_EE_MODEM)
 			continue;
 
-		/* Set TX delay mode, or for IPA v3.5.1 RX suspend mode */
+		/* Set TX delay mode or RX suspend mode */
 		if (endpoint->toward_ipa)
 			ipa_endpoint_program_delay(endpoint, enable);
-		else if (support_suspend)
+		else
 			(void)ipa_endpoint_program_suspend(endpoint, enable);
 	}
 }
@@ -1248,8 +1247,7 @@ static int ipa_endpoint_reset_rx_aggr(struct ipa_endpoint *endpoint)
 	gsi_channel_reset(gsi, endpoint->channel_id, false);
 
 	/* Make sure the channel isn't suspended */
-	if (endpoint->ipa->version == IPA_VERSION_3_5_1)
-		suspended = ipa_endpoint_program_suspend(endpoint, false);
+	suspended = ipa_endpoint_program_suspend(endpoint, false);
 
 	/* Start channel and do a 1 byte read */
 	ret = gsi_channel_start(gsi, endpoint->channel_id);
@@ -1340,8 +1338,7 @@ static void ipa_endpoint_program(struct ipa_endpoint *endpoint)
 		ipa_endpoint_init_seq(endpoint);
 		ipa_endpoint_init_mode(endpoint);
 	} else {
-		if (endpoint->ipa->version == IPA_VERSION_3_5_1)
-			(void)ipa_endpoint_program_suspend(endpoint, false);
+		(void)ipa_endpoint_program_suspend(endpoint, false);
 		ipa_endpoint_init_hdr_ext(endpoint);
 		ipa_endpoint_init_aggr(endpoint);
 		ipa_endpoint_init_hdr_metadata_mask(endpoint);
@@ -1416,11 +1413,11 @@ void ipa_endpoint_suspend_one(struct ipa_endpoint *endpoint)
 	if (!endpoint->toward_ipa)
 		ipa_endpoint_replenish_disable(endpoint);
 
+	if (!endpoint->toward_ipa)
+		(void)ipa_endpoint_program_suspend(endpoint, true);
+
 	/* IPA v3.5.1 doesn't use channel stop for suspend */
 	stop_channel = endpoint->ipa->version != IPA_VERSION_3_5_1;
-	if (!endpoint->toward_ipa && !stop_channel)
-		(void)ipa_endpoint_program_suspend(endpoint, true);
-
 	ret = gsi_channel_suspend(gsi, endpoint->channel_id, stop_channel);
 	if (ret)
 		dev_err(dev, "error %d suspending channel %u\n", ret,
@@ -1437,11 +1434,11 @@ void ipa_endpoint_resume_one(struct ipa_endpoint *endpoint)
 	if (!(endpoint->ipa->enabled & BIT(endpoint->endpoint_id)))
 		return;
 
+	if (!endpoint->toward_ipa)
+		(void)ipa_endpoint_program_suspend(endpoint, false);
+
 	/* IPA v3.5.1 doesn't use channel start for resume */
 	start_channel = endpoint->ipa->version != IPA_VERSION_3_5_1;
-	if (!endpoint->toward_ipa && !start_channel)
-		(void)ipa_endpoint_program_suspend(endpoint, false);
-
 	ret = gsi_channel_resume(gsi, endpoint->channel_id, start_channel);
 	if (ret)
 		dev_err(dev, "error %d resuming channel %u\n", ret,
-- 
2.25.1

