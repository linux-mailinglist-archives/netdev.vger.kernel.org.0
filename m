Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A6F745CDF0
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 21:25:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231846AbhKXU2d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 15:28:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230138AbhKXU21 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 15:28:27 -0500
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 683AFC06174A
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 12:25:17 -0800 (PST)
Received: by mail-il1-x12d.google.com with SMTP id l8so3711396ilv.3
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 12:25:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PKb4x2fpJvvWj1MWlAu+w+srbFDuwrfT34Vp4ykdpr8=;
        b=O86KK2Nj8/wXBRuHWHOrbwrdi0QsUisBg2JVReNmc6zCcf+K0HY6eoqNUfI5G8GGQ3
         yDLDtXP4pgJzRjyjqHaOgfM+8kP/DNp9fPcKfu9rhEOAv67nY7uSoTrXFiZa7sszCIV3
         KvizyqdpTuT+DoXkrzClZLma3Nov/EAFhx67WaoZlLRutvCJG7HjJ46xIu9oo03Zv/+v
         xG10UMR01OCNMPA20TyLbdChHo8qkU0ugPGKa9ZqhmrrHjYABLSMiSTZz7Zfj4zq9aOB
         s07Fp1isYjJOa9CxhviEcuV2oBtnRGhRicyGdmUZW1qnXJZazBEGA/KOIVMm4ZbakwaS
         lMYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PKb4x2fpJvvWj1MWlAu+w+srbFDuwrfT34Vp4ykdpr8=;
        b=GepOYwS39VGUk5b+iQZtnPRnQlMscFf4BcIaYuBo+td7e8cWRrS+ymA9BpcW2RJtzx
         irGWcjl1RSx39cIY+DpoLPDzCFW4f3P/PqwJtzaf+WgDEpNL8/PsK97wEpA16wQPxtfd
         V0gqAHa8TP03kNEle1QcVQMakaOX/+cJEav+a0KQGZdxGv3T2KDuXLdWCXl/bNw9erKj
         j4/CUgUEQwI9pMMkpmhV+nUQLJhdv56a0xQhmNHh3HJok47t7yLEaSq/tc220qbzbIJ+
         1dFC7awSlyRI8+EIj5BU4yawJDSbWTde376AhIvJ+AS6RD0EI8y3DgHZq+rngm5Vyvaq
         yfnA==
X-Gm-Message-State: AOAM530N8lo25yme3WyAHKZ+o3j/fJam00i9tLAbP0n70U9cCOjL71lC
        i+NpC8HguPh12WEti0BKHCHFvw==
X-Google-Smtp-Source: ABdhPJyd+OVmy3R6937TpVoq3X9au4fNktICf3CQtIjGFIHIvIcTHEPc2zMJ0RqeHdTEjOhfdEGnLA==
X-Received: by 2002:a92:cd51:: with SMTP id v17mr15125016ilq.191.1637785516823;
        Wed, 24 Nov 2021 12:25:16 -0800 (PST)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id x2sm312795ile.29.2021.11.24.12.25.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 12:25:16 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     pkurapat@codeaurora.org, avuyyuru@codeaurora.org,
        bjorn.andersson@linaro.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, evgreen@chromium.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/7] net: ipa: kill ipa_modem_init()
Date:   Wed, 24 Nov 2021 14:25:05 -0600
Message-Id: <20211124202511.862588-2-elder@linaro.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211124202511.862588-1-elder@linaro.org>
References: <20211124202511.862588-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A recent commit made disabling the SMP2P "setup ready" interrupt
unrelated to ipa_modem_stop().  Given that, it seems fitting to get
rid of ipa_modem_init() and ipa_modem_exit() (which are trivial
wrapper functions), and call ipa_smp2p_init() and ipa_smp2p_exit()
directly instead.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_main.c  |  7 ++++---
 drivers/net/ipa/ipa_modem.c | 10 ----------
 drivers/net/ipa/ipa_modem.h |  3 ---
 3 files changed, 4 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index cdfa98a76e1f4..6960efbe66ddb 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -29,6 +29,7 @@
 #include "ipa_mem.h"
 #include "ipa_table.h"
 #include "ipa_modem.h"
+#include "ipa_smp2p.h"
 #include "ipa_uc.h"
 #include "ipa_interrupt.h"
 #include "gsi_trans.h"
@@ -733,7 +734,7 @@ static int ipa_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_endpoint_exit;
 
-	ret = ipa_modem_init(ipa, modem_init);
+	ret = ipa_smp2p_init(ipa, modem_init);
 	if (ret)
 		goto err_table_exit;
 
@@ -775,7 +776,7 @@ static int ipa_probe(struct platform_device *pdev)
 	ipa_deconfig(ipa);
 err_power_put:
 	pm_runtime_put_noidle(dev);
-	ipa_modem_exit(ipa);
+	ipa_smp2p_exit(ipa);
 err_table_exit:
 	ipa_table_exit(ipa);
 err_endpoint_exit:
@@ -821,7 +822,7 @@ static int ipa_remove(struct platform_device *pdev)
 	ipa_deconfig(ipa);
 out_power_put:
 	pm_runtime_put_noidle(dev);
-	ipa_modem_exit(ipa);
+	ipa_smp2p_exit(ipa);
 	ipa_table_exit(ipa);
 	ipa_endpoint_exit(ipa);
 	gsi_exit(&ipa->gsi);
diff --git a/drivers/net/ipa/ipa_modem.c b/drivers/net/ipa/ipa_modem.c
index ad116bcc0580e..33ac626bd803e 100644
--- a/drivers/net/ipa/ipa_modem.c
+++ b/drivers/net/ipa/ipa_modem.c
@@ -442,16 +442,6 @@ static int ipa_modem_notify(struct notifier_block *nb, unsigned long action,
 	return NOTIFY_OK;
 }
 
-int ipa_modem_init(struct ipa *ipa, bool modem_init)
-{
-	return ipa_smp2p_init(ipa, modem_init);
-}
-
-void ipa_modem_exit(struct ipa *ipa)
-{
-	ipa_smp2p_exit(ipa);
-}
-
 int ipa_modem_config(struct ipa *ipa)
 {
 	void *notifier;
diff --git a/drivers/net/ipa/ipa_modem.h b/drivers/net/ipa/ipa_modem.h
index 5e6e3d234454a..e64ccc2402e9d 100644
--- a/drivers/net/ipa/ipa_modem.h
+++ b/drivers/net/ipa/ipa_modem.h
@@ -18,9 +18,6 @@ void ipa_modem_skb_rx(struct net_device *netdev, struct sk_buff *skb);
 void ipa_modem_suspend(struct net_device *netdev);
 void ipa_modem_resume(struct net_device *netdev);
 
-int ipa_modem_init(struct ipa *ipa, bool modem_init);
-void ipa_modem_exit(struct ipa *ipa);
-
 int ipa_modem_config(struct ipa *ipa);
 void ipa_modem_deconfig(struct ipa *ipa);
 
-- 
2.32.0

