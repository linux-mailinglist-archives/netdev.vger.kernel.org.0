Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBF662F7AAF
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 13:55:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388453AbhAOMwS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 07:52:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388436AbhAOMwQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 07:52:16 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B39FC06179E
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 04:50:59 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id u17so17892348iow.1
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 04:50:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XfRJBAuwxkFe9MRJG/5cSKWNhxAuQvwcEflUN1LY3nE=;
        b=UnfYX33Fna0JZ/2Df+rkQOYbUBXHbLOe8AFwOyVCwgCfPnskCF5080GcDYg5UZqMic
         ppKwX00Z2MdsoiuYJtLOhzQY16GUJTypFje5NeApz+kBNwtIn7Gg349lFfLi+a9pUF/Y
         0OtqPCHdH6S+gO0OojIYHXJWx8JS2jYO0Xv5phbiyhFhUw385Gl482XLLyP8LQbqKQ7T
         sKaQuxgblQwscKM70rwBneOmSF+WPL6FTkxT6d/ZffHk1QSybC9aLbgOopYjEcGxn/+j
         6fAub15nhCmX4Qsenh1QABpwW+NJfe+Lj1x0fjnenIkYKzkYbmJERdIt+LNPJN5biOnR
         elQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XfRJBAuwxkFe9MRJG/5cSKWNhxAuQvwcEflUN1LY3nE=;
        b=e7DYwsd5GQaDZhvUdR4yHGT5KgIJiIbnqb/lopJQ971W4FHgivCiSw+TkD/4Wu7mEO
         S6dXCH4fZD3D93sUbR+2952l5wZd2U+E34OydAH4QMx1iHLdFcIyUAKT2octA5R721lK
         y8vFkag9+FrXlkrkthdEfY0ZdFQCsKboF4I/rrHUr8S84Ouj4m4TxfAIqqkr49fLeSP4
         Ajxs/6TCIqXDzaY4MaVxVL7XX/uTCxVNHiYg7X4YhI/JbtG6BgL8k8VCQ8U+gt5rzDQj
         6qPd2DNEdHElFVlCOlXsV/EPTMtUT8REAH15R2jaVOWb40hgw2zjVXDvEWs4vO7QbXnE
         VLFg==
X-Gm-Message-State: AOAM532VBo+vFKS7bGlrfZ06EohDaS1uqoYEM25rPz76uto+HDZ2mA/4
        tGgTtJnj1ubqLT/G/ibWTx0mVg==
X-Google-Smtp-Source: ABdhPJwmvXu2xJbc3vh8OWCqcuGwIKYln30n3CyDkyqZpDfqYIrkReZzvZbd1wGqAqjOxt3bao6Xwg==
X-Received: by 2002:a92:154f:: with SMTP id v76mr10637337ilk.272.1610715058829;
        Fri, 15 Jan 2021 04:50:58 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id f13sm3952450iog.18.2021.01.15.04.50.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 04:50:58 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 5/7] net: ipa: add interconnect name to configuration data
Date:   Fri, 15 Jan 2021 06:50:48 -0600
Message-Id: <20210115125050.20555-6-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210115125050.20555-1-elder@linaro.org>
References: <20210115125050.20555-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the name to the configuration data for each interconnect.  Use
this information rather than a constant string during initialization.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_clock.c       | 6 +++---
 drivers/net/ipa/ipa_data-sc7180.c | 3 +++
 drivers/net/ipa/ipa_data-sdm845.c | 3 +++
 drivers/net/ipa/ipa_data.h        | 2 ++
 4 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ipa/ipa_clock.c b/drivers/net/ipa/ipa_clock.c
index 537c72b5267f6..07069dbc6d033 100644
--- a/drivers/net/ipa/ipa_clock.c
+++ b/drivers/net/ipa/ipa_clock.c
@@ -76,7 +76,7 @@ static int ipa_interconnect_init(struct ipa_clock *clock, struct device *dev,
 	struct ipa_interconnect *interconnect;
 	struct icc_path *path;
 
-	path = ipa_interconnect_init_one(dev, "memory");
+	path = ipa_interconnect_init_one(dev, data->name);
 	if (IS_ERR(path))
 		goto err_return;
 	interconnect = &clock->interconnect[IPA_INTERCONNECT_MEMORY];
@@ -85,7 +85,7 @@ static int ipa_interconnect_init(struct ipa_clock *clock, struct device *dev,
 	interconnect->peak_bandwidth = data->peak_bandwidth;
 	data++;
 
-	path = ipa_interconnect_init_one(dev, "imem");
+	path = ipa_interconnect_init_one(dev, data->name);
 	if (IS_ERR(path))
 		goto err_memory_path_put;
 	interconnect = &clock->interconnect[IPA_INTERCONNECT_IMEM];
@@ -94,7 +94,7 @@ static int ipa_interconnect_init(struct ipa_clock *clock, struct device *dev,
 	interconnect->peak_bandwidth = data->peak_bandwidth;
 	data++;
 
-	path = ipa_interconnect_init_one(dev, "config");
+	path = ipa_interconnect_init_one(dev, data->name);
 	if (IS_ERR(path))
 		goto err_imem_path_put;
 	interconnect = &clock->interconnect[IPA_INTERCONNECT_CONFIG];
diff --git a/drivers/net/ipa/ipa_data-sc7180.c b/drivers/net/ipa/ipa_data-sc7180.c
index 491572c0a34dc..1936ecb4c1104 100644
--- a/drivers/net/ipa/ipa_data-sc7180.c
+++ b/drivers/net/ipa/ipa_data-sc7180.c
@@ -314,15 +314,18 @@ static struct ipa_clock_data ipa_clock_data = {
 	/* Interconnect bandwidths are in 1000 byte/second units */
 	.interconnect = {
 		[IPA_INTERCONNECT_MEMORY] = {
+			.name			= "memory",
 			.peak_bandwidth		= 465000,	/* 465 MBps */
 			.average_bandwidth	= 80000,	/* 80 MBps */
 		},
 		/* Average bandwidth unused for the next two interconnects */
 		[IPA_INTERCONNECT_IMEM] = {
+			.name			= "imem",
 			.peak_bandwidth		= 68570,	/* 68.57 MBps */
 			.average_bandwidth	= 0,		/* unused */
 		},
 		[IPA_INTERCONNECT_CONFIG] = {
+			.name			= "config",
 			.peak_bandwidth		= 30000,	/* 30 MBps */
 			.average_bandwidth	= 0,		/* unused */
 		},
diff --git a/drivers/net/ipa/ipa_data-sdm845.c b/drivers/net/ipa/ipa_data-sdm845.c
index c62b86171b929..3b556b5a63406 100644
--- a/drivers/net/ipa/ipa_data-sdm845.c
+++ b/drivers/net/ipa/ipa_data-sdm845.c
@@ -334,15 +334,18 @@ static struct ipa_clock_data ipa_clock_data = {
 	/* Interconnect bandwidths are in 1000 byte/second units */
 	.interconnect = {
 		[IPA_INTERCONNECT_MEMORY] = {
+			.name			= "memory",
 			.peak_bandwidth		= 600000,	/* 600 MBps */
 			.average_bandwidth	= 80000,	/* 80 MBps */
 		},
 		/* Average bandwidth unused for the next two interconnects */
 		[IPA_INTERCONNECT_IMEM] = {
+			.name			= "imem",
 			.peak_bandwidth		= 350000,	/* 350 MBps */
 			.average_bandwidth	= 0,		/* unused */
 		},
 		[IPA_INTERCONNECT_CONFIG] = {
+			.name			= "config",
 			.peak_bandwidth		= 40000,	/* 40 MBps */
 			.average_bandwidth	= 0,		/* unused */
 		},
diff --git a/drivers/net/ipa/ipa_data.h b/drivers/net/ipa/ipa_data.h
index 96a9771a6cc05..d8ea6266dc6a1 100644
--- a/drivers/net/ipa/ipa_data.h
+++ b/drivers/net/ipa/ipa_data.h
@@ -268,10 +268,12 @@ enum ipa_interconnect_id {
 
 /**
  * struct ipa_interconnect_data - description of IPA interconnect bandwidths
+ * @name:		Interconnect name (matches interconnect-name in DT)
  * @peak_bandwidth:	Peak interconnect bandwidth (in 1000 byte/sec units)
  * @average_bandwidth:	Average interconnect bandwidth (in 1000 byte/sec units)
  */
 struct ipa_interconnect_data {
+	const char *name;
 	u32 peak_bandwidth;
 	u32 average_bandwidth;
 };
-- 
2.20.1

