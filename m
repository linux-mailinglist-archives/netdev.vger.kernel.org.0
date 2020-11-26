Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D1922C585E
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 16:36:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391261AbgKZPfV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 10:35:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730240AbgKZPfU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 10:35:20 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A97EC0613D4;
        Thu, 26 Nov 2020 07:35:19 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id p6so1299437plr.7;
        Thu, 26 Nov 2020 07:35:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Dc7JJx80pBYdsjDpGiOmvHfjrFMwvg2cJ8xkpNMVpdg=;
        b=DU0Ep4ioKFT9FvzMoNIGsT//Fl88M3TKyyZoy5mNx/mVoIAAcCFDw76vKHwNRsnBqe
         bfgwdkDgs55HZUeYZI4rIeiSMJekrKxu8pkkZyYjuIgOKdGev1Ypk4FioeFUDR+ZHGED
         GAcr3Jp9kZnREIZkx1d5uer0UV4jg1nD/Dsj3/3f5JN55A1Lo2uSy9keRcA5gik/QUhx
         Wq9ZpezCLGxNiD4cyTeXwUgrgnFuydzIujus+kAZ7dgL36HJ8CcDHJfpZMQ/JjWtvssk
         T9ahbEbTSifbvu+5pd5AuZB8pRBPW3FCJ1rJvhOV7AEZMwf5ha5rxFp5qRowC4/UBcTx
         oldw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Dc7JJx80pBYdsjDpGiOmvHfjrFMwvg2cJ8xkpNMVpdg=;
        b=fvnvzoAK1qx9Ss+9THjuTf8oBRQU0v7EaU2Pwpzs/FlYmCjBS4I17ju1QYZDIJ9Bi0
         hfn0UFyaNvkJPirrBgzbew2XG0optJP/wXmbhoKLCdRMmDvvYTBta3tFldzc6qpJQ6Ic
         xuy6oRCl0j0PTamFesoQR5CV9SXv4AFErTTrNmI/UTHLKjMKFhng13hagBYY6VKtIyyj
         o6h2N0HtU5c6c1/WjWp1SkPXVnPHSLya0HIzxb60THgIcVO/dLppaNJjX27TtaHcfDIU
         GpzgZzVeaWSWQfXBZ9y8xm5CHcs0OMaOPtPjBVgGpaNFwYwM8fwHA2fHMKsyKCDvnour
         LENQ==
X-Gm-Message-State: AOAM530vozEK9pBi/KkM2mbArUm2JEEjv9YtTEURxAhVy2KUAEGrD4bp
        /QwH2VN3eg41tJOfxJhguEc=
X-Google-Smtp-Source: ABdhPJyqIPfncr0tVQgJL1oW4nmaf622lAceTcjO4d5qjJCLw0s2jH1jIu0/3iEmIVEzLjj6IRotoA==
X-Received: by 2002:a17:902:164:b029:d6:a42a:a952 with SMTP id 91-20020a1709020164b02900d6a42aa952mr3177123plb.44.1606404918801;
        Thu, 26 Nov 2020 07:35:18 -0800 (PST)
Received: from localhost.localdomain ([182.226.226.37])
        by smtp.googlemail.com with ESMTPSA id g6sm6506481pjd.3.2020.11.26.07.35.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 26 Nov 2020 07:35:18 -0800 (PST)
From:   bongsu.jeon2@gmail.com
X-Google-Original-From: bongsu.jeon@samsung.com
To:     krzk@kernel.org, k.opasiak@samsung.com
Cc:     linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: [PATCH net-next 3/3] nfc: s3fwrn5: extract the common phy blocks
Date:   Fri, 27 Nov 2020 00:33:39 +0900
Message-Id: <1606404819-30647-3-git-send-email-bongsu.jeon@samsung.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1606404819-30647-1-git-send-email-bongsu.jeon@samsung.com>
References: <1606404819-30647-1-git-send-email-bongsu.jeon@samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bongsu Jeon <bongsu.jeon@samsung.com>

Extract the common phy blocks to reuse it.
The UART module will use the common blocks.

Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
---
 drivers/nfc/s3fwrn5/i2c.c        | 111 ++++++++++++---------------------------
 drivers/nfc/s3fwrn5/phy_common.h |  86 ++++++++++++++++++++++++++++++
 2 files changed, 119 insertions(+), 78 deletions(-)
 create mode 100644 drivers/nfc/s3fwrn5/phy_common.h

diff --git a/drivers/nfc/s3fwrn5/i2c.c b/drivers/nfc/s3fwrn5/i2c.c
index 9a64eea..cd1b2a7 100644
--- a/drivers/nfc/s3fwrn5/i2c.c
+++ b/drivers/nfc/s3fwrn5/i2c.c
@@ -15,75 +15,30 @@
 
 #include <net/nfc/nfc.h>
 
-#include "s3fwrn5.h"
+#include "phy_common.h"
 
 #define S3FWRN5_I2C_DRIVER_NAME "s3fwrn5_i2c"
 
-#define S3FWRN5_EN_WAIT_TIME 20
-
 struct s3fwrn5_i2c_phy {
+	struct phy_common common;
 	struct i2c_client *i2c_dev;
-	struct nci_dev *ndev;
-
-	int gpio_en;
-	int gpio_fw_wake;
-
-	struct mutex mutex;
 
-	enum s3fwrn5_mode mode;
 	unsigned int irq_skip:1;
 };
 
-static void s3fwrn5_i2c_set_wake(void *phy_id, bool wake)
-{
-	struct s3fwrn5_i2c_phy *phy = phy_id;
-
-	mutex_lock(&phy->mutex);
-	gpio_set_value(phy->gpio_fw_wake, wake);
-	msleep(S3FWRN5_EN_WAIT_TIME);
-	mutex_unlock(&phy->mutex);
-}
-
 static void s3fwrn5_i2c_set_mode(void *phy_id, enum s3fwrn5_mode mode)
 {
 	struct s3fwrn5_i2c_phy *phy = phy_id;
 
-	mutex_lock(&phy->mutex);
+	mutex_lock(&phy->common.mutex);
 
-	if (phy->mode == mode)
+	if (s3fwrn5_phy_power_ctrl(&phy->common, mode) == false)
 		goto out;
 
-	phy->mode = mode;
-
-	gpio_set_value(phy->gpio_en, 1);
-	gpio_set_value(phy->gpio_fw_wake, 0);
-	if (mode == S3FWRN5_MODE_FW)
-		gpio_set_value(phy->gpio_fw_wake, 1);
-
-	if (mode != S3FWRN5_MODE_COLD) {
-		msleep(S3FWRN5_EN_WAIT_TIME);
-		gpio_set_value(phy->gpio_en, 0);
-		msleep(S3FWRN5_EN_WAIT_TIME);
-	}
-
 	phy->irq_skip = true;
 
 out:
-	mutex_unlock(&phy->mutex);
-}
-
-static enum s3fwrn5_mode s3fwrn5_i2c_get_mode(void *phy_id)
-{
-	struct s3fwrn5_i2c_phy *phy = phy_id;
-	enum s3fwrn5_mode mode;
-
-	mutex_lock(&phy->mutex);
-
-	mode = phy->mode;
-
-	mutex_unlock(&phy->mutex);
-
-	return mode;
+	mutex_unlock(&phy->common.mutex);
 }
 
 static int s3fwrn5_i2c_write(void *phy_id, struct sk_buff *skb)
@@ -91,7 +46,7 @@ static int s3fwrn5_i2c_write(void *phy_id, struct sk_buff *skb)
 	struct s3fwrn5_i2c_phy *phy = phy_id;
 	int ret;
 
-	mutex_lock(&phy->mutex);
+	mutex_lock(&phy->common.mutex);
 
 	phy->irq_skip = false;
 
@@ -102,7 +57,7 @@ static int s3fwrn5_i2c_write(void *phy_id, struct sk_buff *skb)
 		ret  = i2c_master_send(phy->i2c_dev, skb->data, skb->len);
 	}
 
-	mutex_unlock(&phy->mutex);
+	mutex_unlock(&phy->common.mutex);
 
 	if (ret < 0)
 		return ret;
@@ -114,9 +69,9 @@ static int s3fwrn5_i2c_write(void *phy_id, struct sk_buff *skb)
 }
 
 static const struct s3fwrn5_phy_ops i2c_phy_ops = {
-	.set_wake = s3fwrn5_i2c_set_wake,
+	.set_wake = s3fwrn5_phy_set_wake,
 	.set_mode = s3fwrn5_i2c_set_mode,
-	.get_mode = s3fwrn5_i2c_get_mode,
+	.get_mode = s3fwrn5_phy_get_mode,
 	.write = s3fwrn5_i2c_write,
 };
 
@@ -128,7 +83,7 @@ static int s3fwrn5_i2c_read(struct s3fwrn5_i2c_phy *phy)
 	char hdr[4];
 	int ret;
 
-	hdr_size = (phy->mode == S3FWRN5_MODE_NCI) ?
+	hdr_size = (phy->common.mode == S3FWRN5_MODE_NCI) ?
 		NCI_CTRL_HDR_SIZE : S3FWRN5_FW_HDR_SIZE;
 	ret = i2c_master_recv(phy->i2c_dev, hdr, hdr_size);
 	if (ret < 0)
@@ -137,7 +92,7 @@ static int s3fwrn5_i2c_read(struct s3fwrn5_i2c_phy *phy)
 	if (ret < hdr_size)
 		return -EBADMSG;
 
-	data_len = (phy->mode == S3FWRN5_MODE_NCI) ?
+	data_len = (phy->common.mode == S3FWRN5_MODE_NCI) ?
 		((struct nci_ctrl_hdr *)hdr)->plen :
 		((struct s3fwrn5_fw_header *)hdr)->len;
 
@@ -157,24 +112,24 @@ static int s3fwrn5_i2c_read(struct s3fwrn5_i2c_phy *phy)
 	}
 
 out:
-	return s3fwrn5_recv_frame(phy->ndev, skb, phy->mode);
+	return s3fwrn5_recv_frame(phy->common.ndev, skb, phy->common.mode);
 }
 
 static irqreturn_t s3fwrn5_i2c_irq_thread_fn(int irq, void *phy_id)
 {
 	struct s3fwrn5_i2c_phy *phy = phy_id;
 
-	if (!phy || !phy->ndev) {
+	if (!phy || !phy->common.ndev) {
 		WARN_ON_ONCE(1);
 		return IRQ_NONE;
 	}
 
-	mutex_lock(&phy->mutex);
+	mutex_lock(&phy->common.mutex);
 
 	if (phy->irq_skip)
 		goto out;
 
-	switch (phy->mode) {
+	switch (phy->common.mode) {
 	case S3FWRN5_MODE_NCI:
 	case S3FWRN5_MODE_FW:
 		s3fwrn5_i2c_read(phy);
@@ -184,7 +139,7 @@ static irqreturn_t s3fwrn5_i2c_irq_thread_fn(int irq, void *phy_id)
 	}
 
 out:
-	mutex_unlock(&phy->mutex);
+	mutex_unlock(&phy->common.mutex);
 
 	return IRQ_HANDLED;
 }
@@ -197,19 +152,19 @@ static int s3fwrn5_i2c_parse_dt(struct i2c_client *client)
 	if (!np)
 		return -ENODEV;
 
-	phy->gpio_en = of_get_named_gpio(np, "en-gpios", 0);
-	if (!gpio_is_valid(phy->gpio_en)) {
+	phy->common.gpio_en = of_get_named_gpio(np, "en-gpios", 0);
+	if (!gpio_is_valid(phy->common.gpio_en)) {
 		/* Support also deprecated property */
-		phy->gpio_en = of_get_named_gpio(np, "s3fwrn5,en-gpios", 0);
-		if (!gpio_is_valid(phy->gpio_en))
+		phy->common.gpio_en = of_get_named_gpio(np, "s3fwrn5,en-gpios", 0);
+		if (!gpio_is_valid(phy->common.gpio_en))
 			return -ENODEV;
 	}
 
-	phy->gpio_fw_wake = of_get_named_gpio(np, "wake-gpios", 0);
-	if (!gpio_is_valid(phy->gpio_fw_wake)) {
+	phy->common.gpio_fw_wake = of_get_named_gpio(np, "wake-gpios", 0);
+	if (!gpio_is_valid(phy->common.gpio_fw_wake)) {
 		/* Support also deprecated property */
-		phy->gpio_fw_wake = of_get_named_gpio(np, "s3fwrn5,fw-gpios", 0);
-		if (!gpio_is_valid(phy->gpio_fw_wake))
+		phy->common.gpio_fw_wake = of_get_named_gpio(np, "s3fwrn5,fw-gpios", 0);
+		if (!gpio_is_valid(phy->common.gpio_fw_wake))
 			return -ENODEV;
 	}
 
@@ -226,8 +181,8 @@ static int s3fwrn5_i2c_probe(struct i2c_client *client,
 	if (!phy)
 		return -ENOMEM;
 
-	mutex_init(&phy->mutex);
-	phy->mode = S3FWRN5_MODE_COLD;
+	mutex_init(&phy->common.mutex);
+	phy->common.mode = S3FWRN5_MODE_COLD;
 	phy->irq_skip = true;
 
 	phy->i2c_dev = client;
@@ -237,17 +192,17 @@ static int s3fwrn5_i2c_probe(struct i2c_client *client,
 	if (ret < 0)
 		return ret;
 
-	ret = devm_gpio_request_one(&phy->i2c_dev->dev, phy->gpio_en,
-		GPIOF_OUT_INIT_HIGH, "s3fwrn5_en");
+	ret = devm_gpio_request_one(&phy->i2c_dev->dev, phy->common.gpio_en,
+				    GPIOF_OUT_INIT_HIGH, "s3fwrn5_en");
 	if (ret < 0)
 		return ret;
 
-	ret = devm_gpio_request_one(&phy->i2c_dev->dev, phy->gpio_fw_wake,
-		GPIOF_OUT_INIT_LOW, "s3fwrn5_fw_wake");
+	ret = devm_gpio_request_one(&phy->i2c_dev->dev, phy->common.gpio_fw_wake,
+				    GPIOF_OUT_INIT_LOW, "s3fwrn5_fw_wake");
 	if (ret < 0)
 		return ret;
 
-	ret = s3fwrn5_probe(&phy->ndev, phy, &phy->i2c_dev->dev, &i2c_phy_ops);
+	ret = s3fwrn5_probe(&phy->common.ndev, phy, &phy->i2c_dev->dev, &i2c_phy_ops);
 	if (ret < 0)
 		return ret;
 
@@ -255,7 +210,7 @@ static int s3fwrn5_i2c_probe(struct i2c_client *client,
 		s3fwrn5_i2c_irq_thread_fn, IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
 		S3FWRN5_I2C_DRIVER_NAME, phy);
 	if (ret)
-		s3fwrn5_remove(phy->ndev);
+		s3fwrn5_remove(phy->common.ndev);
 
 	return ret;
 }
@@ -264,7 +219,7 @@ static int s3fwrn5_i2c_remove(struct i2c_client *client)
 {
 	struct s3fwrn5_i2c_phy *phy = i2c_get_clientdata(client);
 
-	s3fwrn5_remove(phy->ndev);
+	s3fwrn5_remove(phy->common.ndev);
 
 	return 0;
 }
diff --git a/drivers/nfc/s3fwrn5/phy_common.h b/drivers/nfc/s3fwrn5/phy_common.h
new file mode 100644
index 0000000..14f7690
--- /dev/null
+++ b/drivers/nfc/s3fwrn5/phy_common.h
@@ -0,0 +1,86 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later
+ *
+ * Link Layer for Samsung S3FWRN5 NCI based Driver
+ *
+ * Copyright (C) 2015 Samsung Electrnoics
+ * Robert Baldyga <r.baldyga@samsung.com>
+ * Copyright (C) 2020 Samsung Electrnoics
+ * Bongsu Jeon <bongsu.jeon@samsung.com>
+ */
+
+#ifndef __LOCAL_PHY_COMMON_H
+#define __LOCAL_PHY_COMMON_H
+
+#include "s3fwrn5.h"
+
+#define S3FWRN5_EN_WAIT_TIME 20
+
+struct phy_common {
+	struct nci_dev *ndev;
+
+	int gpio_en;
+	int gpio_fw_wake;
+
+	struct mutex mutex;
+
+	enum s3fwrn5_mode mode;
+};
+
+static inline void s3fwrn5_phy_set_wake(void *phy_id, bool wake)
+{
+	struct phy_common *phy = phy_id;
+
+	mutex_lock(&phy->mutex);
+	gpio_set_value(phy->gpio_fw_wake, wake);
+	msleep(S3FWRN5_EN_WAIT_TIME);
+	mutex_unlock(&phy->mutex);
+}
+
+static inline bool s3fwrn5_phy_power_ctrl(struct phy_common *phy,
+					  enum s3fwrn5_mode mode)
+{
+	if (phy->mode == mode)
+		return false;
+
+	phy->mode = mode;
+
+	gpio_set_value(phy->gpio_en, 1);
+	gpio_set_value(phy->gpio_fw_wake, 0);
+	if (mode == S3FWRN5_MODE_FW)
+		gpio_set_value(phy->gpio_fw_wake, 1);
+
+	if (mode != S3FWRN5_MODE_COLD) {
+		msleep(S3FWRN5_EN_WAIT_TIME);
+		gpio_set_value(phy->gpio_en, 0);
+		msleep(S3FWRN5_EN_WAIT_TIME);
+	}
+
+	return true;
+}
+
+static inline void s3fwrn5_phy_set_mode(void *phy_id, enum s3fwrn5_mode mode)
+{
+	struct phy_common *phy = phy_id;
+
+	mutex_lock(&phy->mutex);
+
+	s3fwrn5_phy_power_ctrl(phy, mode);
+
+	mutex_unlock(&phy->mutex);
+}
+
+static inline enum s3fwrn5_mode s3fwrn5_phy_get_mode(void *phy_id)
+{
+	struct phy_common *phy = phy_id;
+	enum s3fwrn5_mode mode;
+
+	mutex_lock(&phy->mutex);
+
+	mode = phy->mode;
+
+	mutex_unlock(&phy->mutex);
+
+	return mode;
+}
+
+#endif /* __LOCAL_PHY_COMMON_H_ */
-- 
1.9.1

