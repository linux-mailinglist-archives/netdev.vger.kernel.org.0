Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07FF4425462
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 15:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241811AbhJGNkj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 09:40:39 -0400
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:51938
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241710AbhJGNkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 09:40:19 -0400
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id E0C5140005
        for <netdev@vger.kernel.org>; Thu,  7 Oct 2021 13:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1633613904;
        bh=Puh8mRYPY/DpKQ/I9uyYNXcSBWp/u+3lkb87itcd3n8=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=YMmqJynP/vK/w0b9UD580d8EvmF5Vq6I4K+18JlB2rswk1NUiEKQT8sby584hYdLB
         c9+k5lc5xvl6bYWPzdRAS84qDa3vf0QGXLGaTql8+BMSi1FKiNm2/lBXEOInPLuOB1
         wlr0sAJBWxHyY5OSeEjhvLq4y7ZV7sxVDd0z6M9sb3pognPxIkj8pJZU+QZo1tti9z
         v+6AO2ff9NbfSJvivsSPW9EB9lePpHP0iZQfa3FuBUOuPa/LA0HwxjBs6BhiCpDe5t
         izV7VHcq4OVON8QoRtBC8tL+060/hIZQ2XnfZqUvXFwFG9RQB8EDxWYCBk4W+3G3dD
         OYNKe1Gb1aSYA==
Received: by mail-ed1-f69.google.com with SMTP id c7-20020a05640227c700b003d27f41f1d4so5871106ede.16
        for <netdev@vger.kernel.org>; Thu, 07 Oct 2021 06:38:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Puh8mRYPY/DpKQ/I9uyYNXcSBWp/u+3lkb87itcd3n8=;
        b=iVaDzu2JhXP5sOl6MerMMWQfcCQ+VKa0kX3I9V4MMd6SHtc3I17Vo7CQTctkoMiXOF
         iIIxUg4GqNCxd6IZ0Ng1x5WFx8XVyBp5dhevnTAFq7E+u6GR8MxmUgdB6qdNomi/zqn/
         tMOaY4yjDWohhK9Hau68kpiLhpymRCN5khDY0A+4/14Oh/tgiqPSjOP7ygtv6mkuxKXl
         bqnYDy/qN/NRZA8GCLYNDVMIdGfaKcghAzZlo50tsR/XF0XOrNFTmoqereZ45zaQPjDs
         AVw55NLesY+kIQGNki17AnFjJHs+1Q2PIkO/Utd1Z4sT4cFZm9ODXGVklBZVT5gthvOg
         n7PQ==
X-Gm-Message-State: AOAM533tdIxHnnrPIDZGdG/JmfCNvXHzeSN28KvbG2NlD1o49mdppx5Y
        xnExV8ffQffZkv5RmKBf9PFqemAMxT5KzAHfWlfhqKaoaXfyYzvc4smEC9eRvyrmU7evKCXLXFy
        4zqmj1k9ivwqXolUqyp33LlnAyMBotzrXNw==
X-Received: by 2002:a17:906:3a0f:: with SMTP id z15mr5941402eje.42.1633613904638;
        Thu, 07 Oct 2021 06:38:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzVZsfRsmZOsEhr/fwES6UsllaiU8YmaLl7naS0VLYqarKwWGbgvqdOR+dFnFEt2mVLnmtVKg==
X-Received: by 2002:a17:906:3a0f:: with SMTP id z15mr5941370eje.42.1633613904460;
        Thu, 07 Oct 2021 06:38:24 -0700 (PDT)
Received: from localhost.localdomain (xdsl-188-155-186-13.adslplus.ch. [188.155.186.13])
        by smtp.gmail.com with ESMTPSA id ay19sm8585613edb.20.2021.10.07.06.38.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 06:38:23 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Krzysztof Opasiak <k.opasiak@samsung.com>,
        Mark Greer <mgreer@animalcreek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: [RESEND PATCH v2 5/7] nfc: st21nfca: drop unneeded debug prints
Date:   Thu,  7 Oct 2021 15:30:19 +0200
Message-Id: <20211007133021.32704-6-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211007133021.32704-1-krzysztof.kozlowski@canonical.com>
References: <20211007133021.32704-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ftrace is a preferred and standard way to debug entering and exiting
functions so drop useless debug prints.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 drivers/nfc/st21nfca/i2c.c | 4 ----
 drivers/nfc/st21nfca/se.c  | 4 ----
 2 files changed, 8 deletions(-)

diff --git a/drivers/nfc/st21nfca/i2c.c b/drivers/nfc/st21nfca/i2c.c
index 279d88128b2e..f126ce96a7df 100644
--- a/drivers/nfc/st21nfca/i2c.c
+++ b/drivers/nfc/st21nfca/i2c.c
@@ -421,7 +421,6 @@ static int st21nfca_hci_i2c_read(struct st21nfca_i2c_phy *phy,
 static irqreturn_t st21nfca_hci_irq_thread_fn(int irq, void *phy_id)
 {
 	struct st21nfca_i2c_phy *phy = phy_id;
-	struct i2c_client *client;
 
 	int r;
 
@@ -430,9 +429,6 @@ static irqreturn_t st21nfca_hci_irq_thread_fn(int irq, void *phy_id)
 		return IRQ_NONE;
 	}
 
-	client = phy->i2c_dev;
-	dev_dbg(&client->dev, "IRQ\n");
-
 	if (phy->hard_fault != 0)
 		return IRQ_HANDLED;
 
diff --git a/drivers/nfc/st21nfca/se.c b/drivers/nfc/st21nfca/se.c
index c8bdf078d111..a43fc4117fa5 100644
--- a/drivers/nfc/st21nfca/se.c
+++ b/drivers/nfc/st21nfca/se.c
@@ -257,8 +257,6 @@ static void st21nfca_se_wt_timeout(struct timer_list *t)
 	struct st21nfca_hci_info *info = from_timer(info, t,
 						    se_info.bwi_timer);
 
-	pr_debug("\n");
-
 	info->se_info.bwi_active = false;
 
 	if (!info->se_info.xch_error) {
@@ -278,8 +276,6 @@ static void st21nfca_se_activation_timeout(struct timer_list *t)
 	struct st21nfca_hci_info *info = from_timer(info, t,
 						    se_info.se_active_timer);
 
-	pr_debug("\n");
-
 	info->se_info.se_active = false;
 
 	complete(&info->se_info.req_completion);
-- 
2.30.2

