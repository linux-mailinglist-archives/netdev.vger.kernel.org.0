Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51A9F3944A1
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 16:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236492AbhE1O6Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 10:58:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47171 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236590AbhE1O6E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 10:58:04 -0400
Received: from mail-ua1-f70.google.com ([209.85.222.70])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lmduV-0004Cj-Cc
        for netdev@vger.kernel.org; Fri, 28 May 2021 14:56:27 +0000
Received: by mail-ua1-f70.google.com with SMTP id d22-20020ab031960000b0290223019877e7so2023174uan.11
        for <netdev@vger.kernel.org>; Fri, 28 May 2021 07:56:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=j+dadvxhKr9M8DJyOltCeC2IGkgvG/BUqwA8QIFSNMA=;
        b=RNxyviSErlRL457HjR3HsjKyG1by17QejpCFlwuYMs4eQsxxXanoi4RzXINUbQ6qkC
         Vde8msHg0Rji3R3Ha9NC7+l4NTZ59ypCupNsnecTUPBBaipYBmqIIZMedk5fBbBvoszg
         yiyMwVyrLxKAlkBV4yQoUlfF43sKYspFM9ZTqoFOIC7yHafb8BcGmhW0bYzXO/NifLmr
         fr/jtXN888osIn5dMmTB9Pj6rtvsLKV8FmJKSRcXPffPFH0N9pKpF9mrWRTCdPabBGES
         62PcQv9cD7xHDoIhnpg4QoEl6cjprIif87/CeLq9ICpE/wdTcci1vLPPLrbSlEIjpo+m
         gcfw==
X-Gm-Message-State: AOAM533EmH5k9uLhQOIzyPan1vzTE4Ta3Peeqz5F3PcYfmejc1BdwvvZ
        so3ZreCawJsyB61xEQJCgNTKa7ZSb+1uR3br5Sk8SOP8jjVYvItE3pzFb6IKvTgRw5wCz/yQ1s6
        UctvSVqAXvWlgS8CuC347CJz9+Sn40DsiEA==
X-Received: by 2002:ab0:784f:: with SMTP id y15mr1771854uaq.60.1622213786528;
        Fri, 28 May 2021 07:56:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwyHSIj3RddiIF4GdX53OPJYJVeWiyudWqy6hwbTM0Ky1LEO3HZhHoiUl8wApzZ3ufLbvD2yw==
X-Received: by 2002:ab0:784f:: with SMTP id y15mr1771838uaq.60.1622213786400;
        Fri, 28 May 2021 07:56:26 -0700 (PDT)
Received: from localhost.localdomain ([45.237.48.3])
        by smtp.gmail.com with ESMTPSA id c15sm743661vko.15.2021.05.28.07.56.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 May 2021 07:56:25 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Randy Dunlap <rdunlap@infradead.org>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 08/11] nfc: pn544: drop ftrace-like debugging messages
Date:   Fri, 28 May 2021 10:55:31 -0400
Message-Id: <20210528145534.125460-5-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210528145534.125460-1-krzysztof.kozlowski@canonical.com>
References: <20210528145330.125055-1-krzysztof.kozlowski@canonical.com>
 <20210528145534.125460-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that the kernel has ftrace, any debugging calls that just do "made
it to this function!" and "leaving this function!" can be removed.
Better to use standard debugging tools.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 drivers/nfc/pn544/i2c.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/nfc/pn544/i2c.c b/drivers/nfc/pn544/i2c.c
index aac778c5ddd2..de59e439c369 100644
--- a/drivers/nfc/pn544/i2c.c
+++ b/drivers/nfc/pn544/i2c.c
@@ -241,8 +241,6 @@ static int pn544_hci_i2c_enable(void *phy_id)
 {
 	struct pn544_i2c_phy *phy = phy_id;
 
-	pr_info("%s\n", __func__);
-
 	pn544_hci_i2c_enable_mode(phy, PN544_HCI_MODE);
 
 	phy->powered = 1;
@@ -875,9 +873,6 @@ static int pn544_hci_i2c_probe(struct i2c_client *client,
 	struct pn544_i2c_phy *phy;
 	int r = 0;
 
-	dev_dbg(&client->dev, "%s\n", __func__);
-	dev_dbg(&client->dev, "IRQ: %d\n", client->irq);
-
 	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
 		nfc_err(&client->dev, "Need I2C_FUNC_I2C\n");
 		return -ENODEV;
@@ -937,8 +932,6 @@ static int pn544_hci_i2c_remove(struct i2c_client *client)
 {
 	struct pn544_i2c_phy *phy = i2c_get_clientdata(client);
 
-	dev_dbg(&client->dev, "%s\n", __func__);
-
 	cancel_work_sync(&phy->fw_work);
 	if (phy->fw_work_state != FW_WORK_STATE_IDLE)
 		pn544_hci_i2c_fw_work_complete(phy, -ENODEV);
-- 
2.27.0

