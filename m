Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F2203944A8
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 16:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236859AbhE1O6e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 10:58:34 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47192 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236666AbhE1O6K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 10:58:10 -0400
Received: from mail-vs1-f71.google.com ([209.85.217.71])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lmdub-0004Eb-K2
        for netdev@vger.kernel.org; Fri, 28 May 2021 14:56:33 +0000
Received: by mail-vs1-f71.google.com with SMTP id d26-20020a67c49a0000b0290245e5a5d320so1090503vsk.8
        for <netdev@vger.kernel.org>; Fri, 28 May 2021 07:56:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=g1FAyvgyu/qVXx6L5siomBosL8eH4sVo53XTzJaTdO0=;
        b=KBfWDXVbbX2vYt5Jm+sUwxsC8R50/32LREK3hlpcX16f8GLnB0fbgekQFw+X30NvEA
         +5u6GLq9kdGciwOUV6WETXkrG8xZaEZeZtdwQxZlGZ1sNv/VPkwP8O86I3eXC27UqdRH
         AL1FlHqaPQLbaasrpwuox4lKpNXLehd249sV0SzDy4gP5bNdotiOXxdRsqWHx6z6b5iD
         SsNCsgAsGouDvW1L4DmZZT0z2+FwTtNpwpL3bjZnZwZqEXoVG1jdd7wTcUSeQ6P8Krv0
         KWmZe+JD8YgpdhRkNjcIYT8Wh9FQn2/CpHTCbmtu41GeiFblEUBeXZnQKfKBNjcwOt68
         PdDA==
X-Gm-Message-State: AOAM531NP4k35vAzPaaabc7/vNkqU03jd0YVIk2zsrWSTJ6WtYZ/mP6E
        cotK/E9NSQt+ccFQyactAcx+BwONcn0kPiWgeupgPaAselMKkzDiJU7yLsMDEpf+BBDM8tfO2tv
        uNKsTwj30VY7NeHqD9xBx/2z11P8oPs6J6A==
X-Received: by 2002:a67:33cf:: with SMTP id z198mr7481782vsz.26.1622213791436;
        Fri, 28 May 2021 07:56:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxZhcUy/Eyxiw7e6U4bQ98nUY4VVuGrJOajsdjwsm6PruHAj7+t20RSsLFzmTRv6CfhQnNdzA==
X-Received: by 2002:a67:33cf:: with SMTP id z198mr7481747vsz.26.1622213791169;
        Fri, 28 May 2021 07:56:31 -0700 (PDT)
Received: from localhost.localdomain ([45.237.48.3])
        by smtp.gmail.com with ESMTPSA id c15sm743661vko.15.2021.05.28.07.56.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 May 2021 07:56:30 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Randy Dunlap <rdunlap@infradead.org>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 10/11] nfc: st-nci: drop ftrace-like debugging messages
Date:   Fri, 28 May 2021 10:55:33 -0400
Message-Id: <20210528145534.125460-7-krzysztof.kozlowski@canonical.com>
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

