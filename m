Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37962408DFF
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 15:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242395AbhIMNa7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 09:30:59 -0400
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:58004
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241260AbhIMNXn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 09:23:43 -0400
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 8B16C4026E
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 13:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1631539262;
        bh=Puh8mRYPY/DpKQ/I9uyYNXcSBWp/u+3lkb87itcd3n8=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=uLvp7vZqM1PzcVV1bWXHT0vsi4fjOP7t/AwL+w+L5kpIfHIkG9q9kt3rcDRjPcN0w
         oG2c6lj5RkLdCg3walId7JQHq1Skpa17JA6+pk6Nmvo8TAY6neYCcv0HUKL429toMy
         WZyQUj6MqN2XpQNQF5jq5L8BBQEH07nOFFk4WRCrDPmVyM05sLWHd33/SBjk7Na28+
         Ojo9N3rKktZLrm9Dq2THtdAtxT6Ig9SDPaAQw3H2OHbE2kAznmYUsPYzM9O7kD3MfQ
         wZPiUvBf9pikq1wjqGUpOb6XUNoDyHdi3TZeeQLpF4POto5BmqpjnRNQuOkn+DsSpe
         4e+vwAfsk8PJg==
Received: by mail-wm1-f69.google.com with SMTP id k29-20020a05600c1c9d00b00304e40495b2so2250257wms.9
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 06:21:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Puh8mRYPY/DpKQ/I9uyYNXcSBWp/u+3lkb87itcd3n8=;
        b=cdJnHrk7vWh3FFDqnNshC9NpRdG3Y8S3U6jKcRYUNtdlPuWMXiSUFlbPYImh2wA3PK
         GhxAkde8PfuMPySCFVj12B9cH/tzeGBq6nMQLk0l4n1uhUm1qmXSyTnLiQN+LTBVa94+
         sK9xKgPqQartFDhJ1a6F/GP+rpKPWh7DnzkacVLN+2GIaXmNACikUNGMGr3ZD7xZKg1k
         8rlS5ZZ5YWQetRrZlYXYM5HkQBB6CcaHofErfNXBT0GTc7hgFVErcOKm2evjVoUBf9tN
         JytWMYJjtCwACO3ZTwVHxCuk5LgTfZW12wZ16+TLoF+CW6Af2id6JgjsCagmcb0pShRc
         Evfw==
X-Gm-Message-State: AOAM532CvY0fam77vx0a5jxPYLJPfh6F4c6GFv1oGLXe3HtEQpL+Z+ZD
        HYJ0Ti4pJRjBvjFwlwenSzsaVf/4jM00cHW1adwRV2emPBvtGJpqlnZfAIXjVoXt67gUFyt98VY
        1DIgXNs09tKUz1KDyYBk/MhCErgx5PHAijg==
X-Received: by 2002:adf:e603:: with SMTP id p3mr12101604wrm.357.1631539262218;
        Mon, 13 Sep 2021 06:21:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJygqJruRSYR9Q9zBFsSsLJSWGwT+Q/2eIRUa8zP6I8mSGmE1siN2j4h18qxV+UlfZLC8c6o7Q==
X-Received: by 2002:adf:e603:: with SMTP id p3mr12101586wrm.357.1631539262084;
        Mon, 13 Sep 2021 06:21:02 -0700 (PDT)
Received: from kozik-lap.lan (lk.84.20.244.219.dc.cable.static.lj-kabel.net. [84.20.244.219])
        by smtp.gmail.com with ESMTPSA id n3sm7195888wmi.0.2021.09.13.06.21.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 06:21:01 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Krzysztof Opasiak <k.opasiak@samsung.com>,
        Mark Greer <mgreer@animalcreek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: [PATCH v2 11/15] nfc: st21nfca: drop unneeded debug prints
Date:   Mon, 13 Sep 2021 15:20:31 +0200
Message-Id: <20210913132035.242870-12-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210913132035.242870-1-krzysztof.kozlowski@canonical.com>
References: <20210913132035.242870-1-krzysztof.kozlowski@canonical.com>
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

