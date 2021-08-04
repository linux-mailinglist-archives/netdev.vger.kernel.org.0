Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14A3D3E044F
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 17:37:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239244AbhHDPgz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 11:36:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239156AbhHDPgs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 11:36:48 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43735C061798
        for <netdev@vger.kernel.org>; Wed,  4 Aug 2021 08:36:35 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id y1so2867995iod.10
        for <netdev@vger.kernel.org>; Wed, 04 Aug 2021 08:36:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RHFa5uneH1vgnhwjmwIiYRoaj+badEIlp+PqhNvxBfY=;
        b=NbPemvyST8+o1EEm6g4AUqDNA4UOkufttCTvpmuvtoVSMvYMu33Xd9J/W6BQwhExRk
         cr6tmnNkQBVa5ORry17OcdY9xMAau76uDk5m5h6nWFOakKuwbX+fuOWgsTc3D7qdK6Pu
         OjWZOma8TSuQhuk2gXySr2+x06PqiAiNWQdktNeybjJ+c6TDcWUbQovRwldz/OPC9cOQ
         mtsXC09pZyFu5RrIDYPjLEWmOtv4jGuRomrLfPcUgyKD/ZlMxGrSSEbI5SX6iUvJX6Ka
         3T+voiuaSJthEOqVLQy/TLpgC3cWaw+DCw/PEFBswjB1x99w5zifGP7dE7Rm0P8P34aF
         1e2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RHFa5uneH1vgnhwjmwIiYRoaj+badEIlp+PqhNvxBfY=;
        b=k7Bt9b4iS87NuWNt2j/Ftc4NnDOqdcxzmgPVryTDpks8auvtnwnS9zar2GYmkSyWub
         nEL+zet+GcP55EDeIWdpawGnWc+9gO92I8tmKeNKDWEiRx5a5yJM1R7wMtsq1OGFv1u8
         P4ZBkbF5ycYcUBRHJ7GnV1tXMWkRQbkYRjRjDUA0hL+ElDe+NbIyHkWZdE/DZ2jgEgjt
         oGRNksgikpBcdUTqZXU0atKG1/UxGbvkQBp46//laXRMGJF3A5hdCUEI4aPasfqQ5M2x
         hZvSubZa3n93E8Aljb0uEekaMtWp+P8K7jJ67dhWaTklIVQRxCWEde6zjXW1vzJBnzw0
         PZNw==
X-Gm-Message-State: AOAM530XP3hGSH/pboZgplLlF98VOK/TSOmQ91ReErrYt34quz5ZNupG
        5QhbUAa6GbgVUdi2jZWaP6mdWg==
X-Google-Smtp-Source: ABdhPJyGK9nAp6yitWYvBXlJg5Pf++WJSVN5DwWCgY98JKpNt+pT2bVX6ZHyRxC8duvoYpFWpZ5yHA==
X-Received: by 2002:a5e:9747:: with SMTP id h7mr789038ioq.92.1628091394745;
        Wed, 04 Aug 2021 08:36:34 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id z11sm1687480ioh.14.2021.08.04.08.36.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Aug 2021 08:36:34 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 6/6] net: ipa: move IPA flags field
Date:   Wed,  4 Aug 2021 10:36:26 -0500
Message-Id: <20210804153626.1549001-7-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210804153626.1549001-1-elder@linaro.org>
References: <20210804153626.1549001-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ipa->flags field is only ever used in "ipa_clock.c", related to
suspend/resume activity.

Move the definition of the ipa_flag enumerated type to "ipa_clock.c".
And move the flags field from the ipa structure and to the ipa_clock
structure.  Rename the type and its values to include "power" or
"POWER" in the name.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa.h       | 12 ------------
 drivers/net/ipa/ipa_clock.c | 16 ++++++++++++++--
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ipa/ipa.h b/drivers/net/ipa/ipa.h
index 71ba996096bb9..34152fe02963d 100644
--- a/drivers/net/ipa/ipa.h
+++ b/drivers/net/ipa/ipa.h
@@ -27,20 +27,9 @@ struct ipa_clock;
 struct ipa_smp2p;
 struct ipa_interrupt;
 
-/**
- * enum ipa_flag - IPA state flags
- * @IPA_FLAG_RESUMED:	Whether resume from suspend has been signaled
- * @IPA_FLAG_COUNT:	Number of defined IPA flags
- */
-enum ipa_flag {
-	IPA_FLAG_RESUMED,
-	IPA_FLAG_COUNT,		/* Last; not a flag */
-};
-
 /**
  * struct ipa - IPA information
  * @gsi:		Embedded GSI structure
- * @flags:		Boolean state flags
  * @version:		IPA hardware version
  * @pdev:		Platform device
  * @completion:		Used to signal pipeline clear transfer complete
@@ -83,7 +72,6 @@ enum ipa_flag {
  */
 struct ipa {
 	struct gsi gsi;
-	DECLARE_BITMAP(flags, IPA_FLAG_COUNT);
 	enum ipa_version version;
 	struct platform_device *pdev;
 	struct completion completion;
diff --git a/drivers/net/ipa/ipa_clock.c b/drivers/net/ipa/ipa_clock.c
index 9e77d4854fe03..a67b6136e3c01 100644
--- a/drivers/net/ipa/ipa_clock.c
+++ b/drivers/net/ipa/ipa_clock.c
@@ -45,11 +45,22 @@ struct ipa_interconnect {
 	u32 peak_bandwidth;
 };
 
+/**
+ * enum ipa_power_flag - IPA power flags
+ * @IPA_POWER_FLAG_RESUMED:	Whether resume from suspend has been signaled
+ * @IPA_POWER_FLAG_COUNT:	Number of defined power flags
+ */
+enum ipa_power_flag {
+	IPA_POWER_FLAG_RESUMED,
+	IPA_POWER_FLAG_COUNT,		/* Last; not a flag */
+};
+
 /**
  * struct ipa_clock - IPA clocking information
  * @count:		Clocking reference count
  * @mutex:		Protects clock enable/disable
  * @core:		IPA core clock
+ * @flags:		Boolean state flags
  * @interconnect_count:	Number of elements in interconnect[]
  * @interconnect:	Interconnect array
  */
@@ -57,6 +68,7 @@ struct ipa_clock {
 	refcount_t count;
 	struct mutex mutex; /* protects clock enable/disable */
 	struct clk *core;
+	DECLARE_BITMAP(flags, IPA_POWER_FLAG_COUNT);
 	u32 interconnect_count;
 	struct ipa_interconnect *interconnect;
 };
@@ -295,7 +307,7 @@ static void ipa_suspend_handler(struct ipa *ipa, enum ipa_irq_id irq_id)
 	 * More than one endpoint could signal this; if so, ignore
 	 * all but the first.
 	 */
-	if (!test_and_set_bit(IPA_FLAG_RESUMED, ipa->flags))
+	if (!test_and_set_bit(IPA_POWER_FLAG_RESUMED, ipa->clock->flags))
 		pm_wakeup_dev_event(&ipa->pdev->dev, 0, true);
 
 	/* Acknowledge/clear the suspend interrupt on all endpoints */
@@ -388,7 +400,7 @@ static int ipa_suspend(struct device *dev)
 
 	/* Endpoints aren't usable until setup is complete */
 	if (ipa->setup_complete) {
-		__clear_bit(IPA_FLAG_RESUMED, ipa->flags);
+		__clear_bit(IPA_POWER_FLAG_RESUMED, ipa->clock->flags);
 		ipa_endpoint_suspend(ipa);
 		gsi_suspend(&ipa->gsi);
 	}
-- 
2.27.0

