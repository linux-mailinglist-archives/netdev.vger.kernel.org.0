Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86374395662
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 09:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230339AbhEaHlg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 03:41:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60630 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230354AbhEaHlE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 03:41:04 -0400
Received: from mail-wr1-f69.google.com ([209.85.221.69])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lncW9-00038p-Rq
        for netdev@vger.kernel.org; Mon, 31 May 2021 07:39:21 +0000
Received: by mail-wr1-f69.google.com with SMTP id u5-20020adf9e050000b029010df603f280so3615374wre.18
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 00:39:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=j+dadvxhKr9M8DJyOltCeC2IGkgvG/BUqwA8QIFSNMA=;
        b=Pbz5N8xUIJfKYg3EB7MVU25fS18htAM8ybrZD4DMWelcJQfZay/T47Sf7kNihQp3N+
         X3j5AQBqRUTXvqdHPrvzRClEzhg9KBvIQWBAu663eFxEvfeGNp5ZueMEXd4hxm+4SWcO
         ujVEJf3V0q0QVGzQkcjXEG7HLlrO+1ZzKu8hBqvaSymnMPdQHyUEPxdMXLkEDnp0Bn7s
         ghE8FTDyb6SF05ZURkp6shtvz9iIp52D6KjGm+p4eHcpMRtjedgQtoR60ChOR+ZMcv5X
         uEOAsu9psM+JM7vOcZRUPYi4Ij+O79fu/CxYow2vJU5knl7Ctw4e8QYsr9YR/YX8YuAl
         1Zxg==
X-Gm-Message-State: AOAM533vhmRQ7DxrD14EpynDmQkV9QVFc1WY4Ay9Wku5l0d903aLRwId
        qfGiyW5C6d4h1CJLLxQ0TBVBojtOneObWf//LkYkkYdXfJtKOL1PbGycUZZtrs3FYOl/a6sSa6G
        N1oXBbDNUYQP2jc6QR7UFq+LFzZ+vVvHsVw==
X-Received: by 2002:a7b:cf23:: with SMTP id m3mr25335316wmg.24.1622446761286;
        Mon, 31 May 2021 00:39:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzb6o1VPKOFpplOXi79XWh6sSwmdcjRCTi34hGnidyYynLUfs94/VRLJuSItxs2w47msn94Yg==
X-Received: by 2002:a7b:cf23:: with SMTP id m3mr25335309wmg.24.1622446761179;
        Mon, 31 May 2021 00:39:21 -0700 (PDT)
Received: from localhost.localdomain (xdsl-188-155-185-9.adslplus.ch. [188.155.185.9])
        by smtp.gmail.com with ESMTPSA id a1sm9168911wrg.92.2021.05.31.00.39.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 May 2021 00:39:20 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RESEND PATCH 08/11] nfc: pn544: drop ftrace-like debugging messages
Date:   Mon, 31 May 2021 09:38:59 +0200
Message-Id: <20210531073902.7111-4-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210531073522.6720-1-krzysztof.kozlowski@canonical.com>
References: <20210531073522.6720-1-krzysztof.kozlowski@canonical.com>
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

