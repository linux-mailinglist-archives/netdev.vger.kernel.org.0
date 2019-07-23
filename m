Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A373D713A6
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 10:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731938AbfGWINm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 04:13:42 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:39721 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726405AbfGWINm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 04:13:42 -0400
Received: by mail-pl1-f195.google.com with SMTP id b7so20337507pls.6;
        Tue, 23 Jul 2019 01:13:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=obZilEP52opY5jpftYWjHMQed1ZMJ+r+EMQoImR6PmE=;
        b=RFrpPA5rPbTn78xatZKRi/cfsqcVUj18wS/s40wian+qMNKWu/6D4EQvS98x0FoQT/
         siF3Bx7TVHMII85anle2of2nHe9ASQDbsO3egvG8Xuj0WpUPseDlBzK0m/DdWSmtsHI5
         1vJ/tJOGzEofMMam+kdnorI4u2x0B57/gVaf4VoC8HMJno494F5XvTZPWdJIhLxHANVJ
         +sA6g8n60kR/KZLIlwFQh09RnfQWWcRbnfrkK2SCa8Z7zUjtL0xBS2ZKCLEFcP64PdNH
         ENXldH2ccLGuMqIqn/vVqcXPZE+dxHSoV6cfH71Csaijxq+yZldsfoFc1StMT5jdfzOm
         b9Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=obZilEP52opY5jpftYWjHMQed1ZMJ+r+EMQoImR6PmE=;
        b=c7KN+GT02vs/hHh4oA8T6ALoPnsBnvseIouKj1nUuKX7LmG8VXYNOkjmsuykzZ7ly+
         CfhunP0c4upzK7ncW1ph5zvxYS51QNpXvzJt1UGJs73TUpNxFrTIzBS2vywhGKo/0hhq
         3S983uDiW8vrbCPBfRdpAGcF7D7CJYJgxBbSpOpZkpcsnA+e70efebzq3+6Yv0m9lbmU
         dLpWvK3ZICix7KPqp8Jtw46hSaaD87k/V9g0D4tQD6AJxghj6U5i5SQ4D3qsP7v6efD/
         VhapYRvCltKvCTK0CzWiVeZQGUzAzXtD0WEIxD6+zOv9eavxpXGzB5ZMqJOzevssimbI
         4LLQ==
X-Gm-Message-State: APjAAAXyzjdPQVwqga7W8vhd7FlBCIyvZAQ59T+oK8MkcJcQJ0pp4Tzx
        1JMxeujxL9NaGAm+IhkNgeY=
X-Google-Smtp-Source: APXvYqxNj5hZA9upOU9YlIxhRkMuskCNc/+lR11pWpZ+uOCv4NNwPEWYb65Vuf9MX1sGRm06GhB95g==
X-Received: by 2002:a17:902:1e2:: with SMTP id b89mr81314288plb.7.1563869621920;
        Tue, 23 Jul 2019 01:13:41 -0700 (PDT)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([89.31.126.54])
        by smtp.gmail.com with ESMTPSA id k64sm22913758pge.65.2019.07.23.01.13.39
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 23 Jul 2019 01:13:41 -0700 (PDT)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     Chas Williams <3chas3@gmail.com>,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH] atm: Use dev_get_drvdata
Date:   Tue, 23 Jul 2019 16:13:14 +0800
Message-Id: <20190723081313.18552-1-hslester96@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of using to_pci_dev + pci_get_drvdata,
use dev_get_drvdata to make code simpler.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
---
 drivers/atm/solos-pci.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/atm/solos-pci.c b/drivers/atm/solos-pci.c
index 5c4c6eeb505c..c32f7dd9879a 100644
--- a/drivers/atm/solos-pci.c
+++ b/drivers/atm/solos-pci.c
@@ -516,9 +516,8 @@ struct geos_gpio_attr {
 static ssize_t geos_gpio_store(struct device *dev, struct device_attribute *attr,
 			       const char *buf, size_t count)
 {
-	struct pci_dev *pdev = to_pci_dev(dev);
 	struct geos_gpio_attr *gattr = container_of(attr, struct geos_gpio_attr, attr);
-	struct solos_card *card = pci_get_drvdata(pdev);
+	struct solos_card *card = dev_get_drvdata(dev);
 	uint32_t data32;
 
 	if (count != 1 && (count != 2 || buf[1] != '\n'))
@@ -542,9 +541,8 @@ static ssize_t geos_gpio_store(struct device *dev, struct device_attribute *attr
 static ssize_t geos_gpio_show(struct device *dev, struct device_attribute *attr,
 			      char *buf)
 {
-	struct pci_dev *pdev = to_pci_dev(dev);
 	struct geos_gpio_attr *gattr = container_of(attr, struct geos_gpio_attr, attr);
-	struct solos_card *card = pci_get_drvdata(pdev);
+	struct solos_card *card = dev_get_drvdata(dev);
 	uint32_t data32;
 
 	data32 = ioread32(card->config_regs + GPIO_STATUS);
@@ -556,9 +554,8 @@ static ssize_t geos_gpio_show(struct device *dev, struct device_attribute *attr,
 static ssize_t hardware_show(struct device *dev, struct device_attribute *attr,
 			     char *buf)
 {
-	struct pci_dev *pdev = to_pci_dev(dev);
 	struct geos_gpio_attr *gattr = container_of(attr, struct geos_gpio_attr, attr);
-	struct solos_card *card = pci_get_drvdata(pdev);
+	struct solos_card *card = dev_get_drvdata(dev);
 	uint32_t data32;
 
 	data32 = ioread32(card->config_regs + GPIO_STATUS);
-- 
2.20.1

