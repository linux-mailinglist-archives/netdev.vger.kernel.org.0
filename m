Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F0CA2C63DD
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 12:23:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729601AbgK0LWc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 06:22:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727431AbgK0LW3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 06:22:29 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ACB5C0613D1;
        Fri, 27 Nov 2020 03:22:29 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id b63so4283419pfg.12;
        Fri, 27 Nov 2020 03:22:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=wB5T7Wp0ow9d0QwWjAdr6c4gTHpCK7FafPVR7HcGCF8=;
        b=IpbJlPqVae3CmPPmlSJxt6YHHwtp2BqjLM/a8W8S7NWQtZ/q8XMRdDuQoaLlrwMZwJ
         4/9jq2Y/YDd5CNrWUA2KtKe5Dkqydja+jtWkeXpHa/GVYbiKTJHf4yRH1H09hb0/7YQR
         9Ny2ums6rfMXm2yWDOhUb6oIgrRJu6aOH3RKZVZtxbAbhb59HWYI4macd+BP8ISGB9pl
         dgvxAnmhqWz4Bj6RtN31Pa1cU/YtViW1y/k59wcGhyW7qmg5lvRIHkkF1VWQAsOayUrW
         XHf6yGftg87Q49MGTx7Jg1CT7AFSadgFhfNxCzzMYZlSpnOH9RsusZO0Kk/Bqz59wCCY
         q5cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=wB5T7Wp0ow9d0QwWjAdr6c4gTHpCK7FafPVR7HcGCF8=;
        b=E6wYw12XdfJ42VQ+ykyYNniDROxGX+cXdq4z/OED0kkIxlxlJxdM1t1D1wm9f/0YKs
         ku43YXjaLEcz/s4pO16KUOANLmouXtY/+hSKJyDgT86P5iL6hgwiBrI0AcaXgifoEYUF
         lqX6D4et65yHL9HbxdYK60Jh3gwzucEqND6TbdY9/2bzAivKkCuYCClXroIAu47opJDa
         I+zb/PLoAQu+b/ASUH3mnyViMVUU9Iagcgp+3Op/icPg5S2lUloW839MDZICOW/F1Fug
         kSW5+qUGZ3xVXTb/fdtXBPV41YptpWPKFtOJyEOG6fKE46KUHQz7p+sfaDm4W4S7ma7h
         U48g==
X-Gm-Message-State: AOAM530yHX6IxjUS0OHZRiAh6FseqJP4svNqbkzbArsDKdU+SdH7J9fE
        bnt5RRhKN5ZefSkkruXv7YcrVl7HFBs=
X-Google-Smtp-Source: ABdhPJw5EmDqGJIdSBSir8q7juqWDVXq0VKVC2HR+HiJiC0TFm3TJDOAnczyz9O39u2Z1o1ck82atw==
X-Received: by 2002:a62:8006:0:b029:196:33f2:4dd7 with SMTP id j6-20020a6280060000b029019633f24dd7mr6555715pfd.38.1606476148972;
        Fri, 27 Nov 2020 03:22:28 -0800 (PST)
Received: from localhost.localdomain ([182.226.226.37])
        by smtp.googlemail.com with ESMTPSA id k9sm7193197pfi.188.2020.11.27.03.22.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 27 Nov 2020 03:22:28 -0800 (PST)
From:   bongsu.jeon2@gmail.com
To:     krzk@kernel.org, k.opasiak@samsung.com
Cc:     linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: [PATCH v2 net-next 3/3] nfc: s3fwrn5: extract the common phy blocks
Date:   Fri, 27 Nov 2020 20:22:18 +0900
Message-Id: <1606476138-31992-1-git-send-email-bongsu.jeon2@gmail.com>
X-Mailer: git-send-email 1.9.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bongsu Jeon <bongsu.jeon@samsung.com>

Extract the common phy blocks to reuse it.
The UART module will use the common blocks.

Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
---
Changes in v2:
 - remove the common function's definition in common header file.
 - make the common phy_common.c file to define the common function.
 - wrap the lines.
 - change the Header guard.
 - remove the unused common function.

 drivers/nfc/s3fwrn5/Makefile     |   2 +-
 drivers/nfc/s3fwrn5/i2c.c        | 114 +++++++++++++--------------------------
 drivers/nfc/s3fwrn5/phy_common.c |  60 +++++++++++++++++++++
 drivers/nfc/s3fwrn5/phy_common.h |  31 +++++++++++
 4 files changed, 129 insertions(+), 78 deletions(-)
 create mode 100644 drivers/nfc/s3fwrn5/phy_common.c
 create mode 100644 drivers/nfc/s3fwrn5/phy_common.h

diff --git a/drivers/nfc/s3fwrn5/Makefile b/drivers/nfc/s3fwrn5/Makefile
index d0ffa35..a5279c6 100644
--- a/drivers/nfc/s3fwrn5/Makefile
+++ b/drivers/nfc/s3fwrn5/Makefile
@@ -4,7 +4,7 @@
 #
 
 s3fwrn5-objs = core.o firmware.o nci.o
-s3fwrn5_i2c-objs = i2c.o
+s3fwrn5_i2c-objs = i2c.o phy_common.o
 
 obj-$(CONFIG_NFC_S3FWRN5) += s3fwrn5.o
 obj-$(CONFIG_NFC_S3FWRN5_I2C) += s3fwrn5_i2c.o
diff --git a/drivers/nfc/s3fwrn5/i2c.c b/drivers/nfc/s3fwrn5/i2c.c
index 9a64eea..207f970 100644
--- a/drivers/nfc/s3fwrn5/i2c.c
+++ b/drivers/nfc/s3fwrn5/i2c.c
@@ -16,74 +16,30 @@
 #include <net/nfc/nfc.h>
 
 #include "s3fwrn5.h"
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
@@ -91,7 +47,7 @@ static int s3fwrn5_i2c_write(void *phy_id, struct sk_buff *skb)
 	struct s3fwrn5_i2c_phy *phy = phy_id;
 	int ret;
 
-	mutex_lock(&phy->mutex);
+	mutex_lock(&phy->common.mutex);
 
 	phy->irq_skip = false;
 
@@ -102,7 +58,7 @@ static int s3fwrn5_i2c_write(void *phy_id, struct sk_buff *skb)
 		ret  = i2c_master_send(phy->i2c_dev, skb->data, skb->len);
 	}
 
-	mutex_unlock(&phy->mutex);
+	mutex_unlock(&phy->common.mutex);
 
 	if (ret < 0)
 		return ret;
@@ -114,9 +70,9 @@ static int s3fwrn5_i2c_write(void *phy_id, struct sk_buff *skb)
 }
 
 static const struct s3fwrn5_phy_ops i2c_phy_ops = {
-	.set_wake = s3fwrn5_i2c_set_wake,
+	.set_wake = s3fwrn5_phy_set_wake,
 	.set_mode = s3fwrn5_i2c_set_mode,
-	.get_mode = s3fwrn5_i2c_get_mode,
+	.get_mode = s3fwrn5_phy_get_mode,
 	.write = s3fwrn5_i2c_write,
 };
 
@@ -128,7 +84,7 @@ static int s3fwrn5_i2c_read(struct s3fwrn5_i2c_phy *phy)
 	char hdr[4];
 	int ret;
 
-	hdr_size = (phy->mode == S3FWRN5_MODE_NCI) ?
+	hdr_size = (phy->common.mode == S3FWRN5_MODE_NCI) ?
 		NCI_CTRL_HDR_SIZE : S3FWRN5_FW_HDR_SIZE;
 	ret = i2c_master_recv(phy->i2c_dev, hdr, hdr_size);
 	if (ret < 0)
@@ -137,7 +93,7 @@ static int s3fwrn5_i2c_read(struct s3fwrn5_i2c_phy *phy)
 	if (ret < hdr_size)
 		return -EBADMSG;
 
-	data_len = (phy->mode == S3FWRN5_MODE_NCI) ?
+	data_len = (phy->common.mode == S3FWRN5_MODE_NCI) ?
 		((struct nci_ctrl_hdr *)hdr)->plen :
 		((struct s3fwrn5_fw_header *)hdr)->len;
 
@@ -157,24 +113,24 @@ static int s3fwrn5_i2c_read(struct s3fwrn5_i2c_phy *phy)
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
@@ -184,7 +140,7 @@ static irqreturn_t s3fwrn5_i2c_irq_thread_fn(int irq, void *phy_id)
 	}
 
 out:
-	mutex_unlock(&phy->mutex);
+	mutex_unlock(&phy->common.mutex);
 
 	return IRQ_HANDLED;
 }
@@ -197,19 +153,21 @@ static int s3fwrn5_i2c_parse_dt(struct i2c_client *client)
 	if (!np)
 		return -ENODEV;
 
-	phy->gpio_en = of_get_named_gpio(np, "en-gpios", 0);
-	if (!gpio_is_valid(phy->gpio_en)) {
+	phy->common.gpio_en = of_get_named_gpio(np, "en-gpios", 0);
+	if (!gpio_is_valid(phy->common.gpio_en)) {
 		/* Support also deprecated property */
-		phy->gpio_en = of_get_named_gpio(np, "s3fwrn5,en-gpios", 0);
-		if (!gpio_is_valid(phy->gpio_en))
+		phy->common.gpio_en =
+				of_get_named_gpio(np, "s3fwrn5,en-gpios", 0);
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
+		phy->common.gpio_fw_wake =
+				of_get_named_gpio(np, "s3fwrn5,fw-gpios", 0);
+		if (!gpio_is_valid(phy->common.gpio_fw_wake))
 			return -ENODEV;
 	}
 
@@ -226,8 +184,8 @@ static int s3fwrn5_i2c_probe(struct i2c_client *client,
 	if (!phy)
 		return -ENOMEM;
 
-	mutex_init(&phy->mutex);
-	phy->mode = S3FWRN5_MODE_COLD;
+	mutex_init(&phy->common.mutex);
+	phy->common.mode = S3FWRN5_MODE_COLD;
 	phy->irq_skip = true;
 
 	phy->i2c_dev = client;
@@ -237,17 +195,19 @@ static int s3fwrn5_i2c_probe(struct i2c_client *client,
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
+	ret = devm_gpio_request_one(&phy->i2c_dev->dev,
+				    phy->common.gpio_fw_wake,
+				    GPIOF_OUT_INIT_LOW, "s3fwrn5_fw_wake");
 	if (ret < 0)
 		return ret;
 
-	ret = s3fwrn5_probe(&phy->ndev, phy, &phy->i2c_dev->dev, &i2c_phy_ops);
+	ret = s3fwrn5_probe(&phy->common.ndev, phy, &phy->i2c_dev->dev,
+			    &i2c_phy_ops);
 	if (ret < 0)
 		return ret;
 
@@ -255,7 +215,7 @@ static int s3fwrn5_i2c_probe(struct i2c_client *client,
 		s3fwrn5_i2c_irq_thread_fn, IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
 		S3FWRN5_I2C_DRIVER_NAME, phy);
 	if (ret)
-		s3fwrn5_remove(phy->ndev);
+		s3fwrn5_remove(phy->common.ndev);
 
 	return ret;
 }
@@ -264,7 +224,7 @@ static int s3fwrn5_i2c_remove(struct i2c_client *client)
 {
 	struct s3fwrn5_i2c_phy *phy = i2c_get_clientdata(client);
 
-	s3fwrn5_remove(phy->ndev);
+	s3fwrn5_remove(phy->common.ndev);
 
 	return 0;
 }
diff --git a/drivers/nfc/s3fwrn5/phy_common.c b/drivers/nfc/s3fwrn5/phy_common.c
new file mode 100644
index 0000000..e333764
--- /dev/null
+++ b/drivers/nfc/s3fwrn5/phy_common.c
@@ -0,0 +1,60 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Link Layer for Samsung S3FWRN5 NCI based Driver
+ *
+ * Copyright (C) 2015 Samsung Electrnoics
+ * Robert Baldyga <r.baldyga@samsung.com>
+ * Copyright (C) 2020 Samsung Electrnoics
+ * Bongsu Jeon <bongsu.jeon@samsung.com>
+ */
+
+#include <linux/gpio.h>
+#include <linux/delay.h>
+
+#include "s3fwrn5.h"
+#include "phy_common.h"
+
+void s3fwrn5_phy_set_wake(void *phy_id, bool wake)
+{
+	struct phy_common *phy = phy_id;
+
+	mutex_lock(&phy->mutex);
+	gpio_set_value(phy->gpio_fw_wake, wake);
+	msleep(S3FWRN5_EN_WAIT_TIME);
+	mutex_unlock(&phy->mutex);
+}
+
+bool s3fwrn5_phy_power_ctrl(struct phy_common *phy, enum s3fwrn5_mode mode)
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
+enum s3fwrn5_mode s3fwrn5_phy_get_mode(void *phy_id)
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
diff --git a/drivers/nfc/s3fwrn5/phy_common.h b/drivers/nfc/s3fwrn5/phy_common.h
new file mode 100644
index 0000000..b920f7f
--- /dev/null
+++ b/drivers/nfc/s3fwrn5/phy_common.h
@@ -0,0 +1,31 @@
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
+#ifndef __NFC_S3FWRN5_PHY_COMMON_H
+#define __NFC_S3FWRN5_PHY_COMMON_H
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
+void s3fwrn5_phy_set_wake(void *phy_id, bool wake);
+bool s3fwrn5_phy_power_ctrl(struct phy_common *phy, enum s3fwrn5_mode mode);
+enum s3fwrn5_mode s3fwrn5_phy_get_mode(void *phy_id);
+
+#endif /* __NFC_S3FWRN5_PHY_COMMON_H */
-- 
1.9.1

