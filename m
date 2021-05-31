Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9002395664
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 09:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230322AbhEaHlp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 03:41:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60640 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230345AbhEaHlE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 03:41:04 -0400
Received: from mail-wm1-f70.google.com ([209.85.128.70])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lncWC-00039w-8K
        for netdev@vger.kernel.org; Mon, 31 May 2021 07:39:24 +0000
Received: by mail-wm1-f70.google.com with SMTP id w3-20020a1cf6030000b0290195fd5fd0f2so2870573wmc.4
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 00:39:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=g1FAyvgyu/qVXx6L5siomBosL8eH4sVo53XTzJaTdO0=;
        b=G+bKR4nn1QujcEeG0QV6eQpLcr7k3ubNlsdUFVOgQirE0ILCE4ZXsS2dd113LtQ9as
         mD62lBT7hqQXf0XaDV6jsZZImz3ObyZFPtHNwI/zkvFrcSEJYw0HLFQ4zzOr5H6IlKHw
         Vaeecs2ZdS6NB8dSFQBW1/iggRtc7lGzsLp8J2slvPrHwWdf/VkkFbOB+uVEiSLGTXix
         MBMPIppB4b6sbdKoHNrXjXH0dGAbblB5Rbl7AWXRsGKJN8PB8xEySsJ7wVZLrC85LZgd
         He5SlOM97DvgTAOU66phTef469YSfcxf93sXuK51E+UL951hXYFL3tX3LcNd/LoGRUAT
         fWVQ==
X-Gm-Message-State: AOAM531Z7QtSZDv7vFyuq2hZZVP3yE9r9wT5e2jqQumeRPBk9sZGVfvW
        JVCz2eOG8JLrbaFmJ8GGCn/bna7Gr8eUNELfdORGg8HLAWVYtnH+fi0i7uJhsiskyqbqZT0RcAs
        U95RTw7znZkKGeYyh0G4KGo3rfbux9FokLQ==
X-Received: by 2002:a05:600c:231a:: with SMTP id 26mr13555907wmo.92.1622446763251;
        Mon, 31 May 2021 00:39:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwsV8autLYEr9eV5Wyus99mhUBr9uj33Y8pykWfReCEKmHjnGozrIsUQTth2S6tBaa77HTFEQ==
X-Received: by 2002:a05:600c:231a:: with SMTP id 26mr13555897wmo.92.1622446763135;
        Mon, 31 May 2021 00:39:23 -0700 (PDT)
Received: from localhost.localdomain (xdsl-188-155-185-9.adslplus.ch. [188.155.185.9])
        by smtp.gmail.com with ESMTPSA id a1sm9168911wrg.92.2021.05.31.00.39.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 May 2021 00:39:22 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RESEND PATCH 10/11] nfc: st-nci: drop ftrace-like debugging messages
Date:   Mon, 31 May 2021 09:39:01 +0200
Message-Id: <20210531073902.7111-6-krzysztof.kozlowski@canonical.com>
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
 drivers/nfc/st-nci/i2c.c | 5 -----
 drivers/nfc/st-nci/se.c  | 6 ------
 drivers/nfc/st-nci/spi.c | 5 -----
 3 files changed, 16 deletions(-)

diff --git a/drivers/nfc/st-nci/i2c.c b/drivers/nfc/st-nci/i2c.c
index 663d1cc19b81..46981405e8b1 100644
--- a/drivers/nfc/st-nci/i2c.c
+++ b/drivers/nfc/st-nci/i2c.c
@@ -206,9 +206,6 @@ static int st_nci_i2c_probe(struct i2c_client *client,
 	struct st_nci_i2c_phy *phy;
 	int r;
 
-	dev_dbg(&client->dev, "%s\n", __func__);
-	dev_dbg(&client->dev, "IRQ: %d\n", client->irq);
-
 	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
 		nfc_err(&client->dev, "Need I2C_FUNC_I2C\n");
 		return -ENODEV;
@@ -261,8 +258,6 @@ static int st_nci_i2c_remove(struct i2c_client *client)
 {
 	struct st_nci_i2c_phy *phy = i2c_get_clientdata(client);
 
-	dev_dbg(&client->dev, "%s\n", __func__);
-
 	ndlc_remove(phy->ndlc);
 
 	return 0;
diff --git a/drivers/nfc/st-nci/se.c b/drivers/nfc/st-nci/se.c
index 8657e025166f..5fd89f72969d 100644
--- a/drivers/nfc/st-nci/se.c
+++ b/drivers/nfc/st-nci/se.c
@@ -470,8 +470,6 @@ int st_nci_disable_se(struct nci_dev *ndev, u32 se_idx)
 {
 	int r;
 
-	pr_debug("st_nci_disable_se\n");
-
 	/*
 	 * According to upper layer, se_idx == NFC_SE_UICC when
 	 * info->se_info.se_status->is_uicc_enable is true should never happen
@@ -496,8 +494,6 @@ int st_nci_enable_se(struct nci_dev *ndev, u32 se_idx)
 {
 	int r;
 
-	pr_debug("st_nci_enable_se\n");
-
 	/*
 	 * According to upper layer, se_idx == NFC_SE_UICC when
 	 * info->se_info.se_status->is_uicc_enable is true should never happen.
@@ -602,8 +598,6 @@ int st_nci_discover_se(struct nci_dev *ndev)
 	int se_count = 0;
 	struct st_nci_info *info = nci_get_drvdata(ndev);
 
-	pr_debug("st_nci_discover_se\n");
-
 	r = st_nci_hci_network_init(ndev);
 	if (r != 0)
 		return r;
diff --git a/drivers/nfc/st-nci/spi.c b/drivers/nfc/st-nci/spi.c
index 5f1a2173b2e7..250d56f204c3 100644
--- a/drivers/nfc/st-nci/spi.c
+++ b/drivers/nfc/st-nci/spi.c
@@ -216,9 +216,6 @@ static int st_nci_spi_probe(struct spi_device *dev)
 	struct st_nci_spi_phy *phy;
 	int r;
 
-	dev_dbg(&dev->dev, "%s\n", __func__);
-	dev_dbg(&dev->dev, "IRQ: %d\n", dev->irq);
-
 	/* Check SPI platform functionnalities */
 	if (!dev) {
 		pr_debug("%s: dev is NULL. Device is not accessible.\n",
@@ -274,8 +271,6 @@ static int st_nci_spi_remove(struct spi_device *dev)
 {
 	struct st_nci_spi_phy *phy = spi_get_drvdata(dev);
 
-	dev_dbg(&dev->dev, "%s\n", __func__);
-
 	ndlc_remove(phy->ndlc);
 
 	return 0;
-- 
2.27.0

