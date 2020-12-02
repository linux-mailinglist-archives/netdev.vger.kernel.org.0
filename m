Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09A622CBBE5
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 12:51:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729789AbgLBLss (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 06:48:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbgLBLsr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 06:48:47 -0500
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4700CC0617A6;
        Wed,  2 Dec 2020 03:48:22 -0800 (PST)
Received: by mail-pj1-x1042.google.com with SMTP id r20so878761pjp.1;
        Wed, 02 Dec 2020 03:48:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vlL08WpZno5LOnV3el5cKDL1GE0E3GCX5jvhDzMUbFI=;
        b=RWgNJs+WhDJVh2Xplx0rNqAvfmT81H+LFgm2u78tdXzdKd4pnGKwn5gl0zTLjJ/MHO
         +XCqyN33GN+l1x5YwcK6z7YGeMPVOJur1SjoxQXc1tPBbuvUQNbYMqZ283UyQcdiQB5k
         fW410b1RoqJq8GMFFA28slKEwdUBQNxegGUutGf9R1vAzTux2Jn+AFPOQt468KafL4Wn
         /InxbVslWMXTgnWPFg5wX5YtshOAfpG0pR7/1jCDB4MniE0IKYCT/L2MNj6BCxNJ1iIR
         K6tJhatD+M94mAWGlKsEyjgItV9bGFGzf0XzN1TCRtUL1wTJ1hE+9E3BK10Os2SqR0jR
         UkWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=vlL08WpZno5LOnV3el5cKDL1GE0E3GCX5jvhDzMUbFI=;
        b=SfG2espSaAE+8elcCqKdENpYdPSSgVEtfpwz4xiRzNpjMLOhQzeOstMDYDB8y/2IF6
         LUGQKhAM2OIqZaMRkClswAVpPi/Q3Q/SIm/QY+hXyiXI2IIqqa0LDWHMIfZhHWzKgsFx
         x/jb8ghW59klFaNGNSp7RzoX+5YI39apT7tXoOedEReTIZxCaaYHgnNtBHplq8DmHSPU
         gF0HpYef1ze8XagutRYAPqPnJwuZlRtZbMltHKNWDkZ11Njt2vc23VCc2B932EFSAKCA
         08t0OJXs6/j7WpguHGgDfC4QY+Ta/rc9VMi5RY+WKCrGv4AS+nRncd6DLuQZGpbMc7mb
         SGuQ==
X-Gm-Message-State: AOAM532E5gZndrg2+kvV8KW7kUsboGG+wnEyL6U8GWCjicQgH8Jz5ago
        86ic9GV/sU06Ar+8xly3bw6KgEoKjKY=
X-Google-Smtp-Source: ABdhPJwelc9Ed37/Hetlz9joJAUmCMxs8nFlVJqa4IhKZuK4qRoSqs6CLXaIkM9fpJ2JA5DotyZlMQ==
X-Received: by 2002:a17:90a:9e5:: with SMTP id 92mr2085566pjo.176.1606909701869;
        Wed, 02 Dec 2020 03:48:21 -0800 (PST)
Received: from localhost.localdomain ([182.226.226.37])
        by smtp.googlemail.com with ESMTPSA id q18sm2108806pfs.150.2020.12.02.03.48.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 02 Dec 2020 03:48:21 -0800 (PST)
From:   Bongsu Jeon <bongsu.jeon2@gmail.com>
X-Google-Original-From: Bongsu Jeon
To:     krzk@kernel.org
Cc:     linux-nfc@lists.01.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: [PATCH v5 net-next 3/4] nfc: s3fwrn5: extract the common phy blocks
Date:   Wed,  2 Dec 2020 20:47:40 +0900
Message-Id: <1606909661-3814-4-git-send-email-bongsu.jeon@samsung.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1606909661-3814-1-git-send-email-bongsu.jeon@samsung.com>
References: <1606909661-3814-1-git-send-email-bongsu.jeon@samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bongsu Jeon <bongsu.jeon@samsung.com>

Extract the common phy blocks to reuse it.
The UART module will use the common blocks.

Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
---
 drivers/nfc/s3fwrn5/Makefile     |   2 +-
 drivers/nfc/s3fwrn5/i2c.c        | 117 +++++++++++++--------------------------
 drivers/nfc/s3fwrn5/phy_common.c |  63 +++++++++++++++++++++
 drivers/nfc/s3fwrn5/phy_common.h |  36 ++++++++++++
 4 files changed, 139 insertions(+), 79 deletions(-)
 create mode 100644 drivers/nfc/s3fwrn5/phy_common.c
 create mode 100644 drivers/nfc/s3fwrn5/phy_common.h

diff --git a/drivers/nfc/s3fwrn5/Makefile b/drivers/nfc/s3fwrn5/Makefile
index d0ffa35..6b6f52d 100644
--- a/drivers/nfc/s3fwrn5/Makefile
+++ b/drivers/nfc/s3fwrn5/Makefile
@@ -3,7 +3,7 @@
 # Makefile for Samsung S3FWRN5 NFC driver
 #
 
-s3fwrn5-objs = core.o firmware.o nci.o
+s3fwrn5-objs = core.o firmware.o nci.o phy_common.o
 s3fwrn5_i2c-objs = i2c.o
 
 obj-$(CONFIG_NFC_S3FWRN5) += s3fwrn5.o
diff --git a/drivers/nfc/s3fwrn5/i2c.c b/drivers/nfc/s3fwrn5/i2c.c
index 9a64eea..e1bdde1 100644
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
@@ -197,19 +152,23 @@ static int s3fwrn5_i2c_parse_dt(struct i2c_client *client)
 	if (!np)
 		return -ENODEV;
 
-	phy->gpio_en = of_get_named_gpio(np, "en-gpios", 0);
-	if (!gpio_is_valid(phy->gpio_en)) {
+	phy->common.gpio_en = of_get_named_gpio(np, "en-gpios", 0);
+	if (!gpio_is_valid(phy->common.gpio_en)) {
 		/* Support also deprecated property */
-		phy->gpio_en = of_get_named_gpio(np, "s3fwrn5,en-gpios", 0);
-		if (!gpio_is_valid(phy->gpio_en))
+		phy->common.gpio_en = of_get_named_gpio(np,
+							"s3fwrn5,en-gpios",
+							0);
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
+		phy->common.gpio_fw_wake = of_get_named_gpio(np,
+							     "s3fwrn5,fw-gpios",
+							     0);
+		if (!gpio_is_valid(phy->common.gpio_fw_wake))
 			return -ENODEV;
 	}
 
@@ -226,8 +185,8 @@ static int s3fwrn5_i2c_probe(struct i2c_client *client,
 	if (!phy)
 		return -ENOMEM;
 
-	mutex_init(&phy->mutex);
-	phy->mode = S3FWRN5_MODE_COLD;
+	mutex_init(&phy->common.mutex);
+	phy->common.mode = S3FWRN5_MODE_COLD;
 	phy->irq_skip = true;
 
 	phy->i2c_dev = client;
@@ -237,17 +196,19 @@ static int s3fwrn5_i2c_probe(struct i2c_client *client,
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
 
@@ -255,7 +216,7 @@ static int s3fwrn5_i2c_probe(struct i2c_client *client,
 		s3fwrn5_i2c_irq_thread_fn, IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
 		S3FWRN5_I2C_DRIVER_NAME, phy);
 	if (ret)
-		s3fwrn5_remove(phy->ndev);
+		s3fwrn5_remove(phy->common.ndev);
 
 	return ret;
 }
@@ -264,7 +225,7 @@ static int s3fwrn5_i2c_remove(struct i2c_client *client)
 {
 	struct s3fwrn5_i2c_phy *phy = i2c_get_clientdata(client);
 
-	s3fwrn5_remove(phy->ndev);
+	s3fwrn5_remove(phy->common.ndev);
 
 	return 0;
 }
diff --git a/drivers/nfc/s3fwrn5/phy_common.c b/drivers/nfc/s3fwrn5/phy_common.c
new file mode 100644
index 0000000..5cad1f4
--- /dev/null
+++ b/drivers/nfc/s3fwrn5/phy_common.c
@@ -0,0 +1,63 @@
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
+#include <linux/module.h>
+
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
+EXPORT_SYMBOL(s3fwrn5_phy_set_wake);
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
+EXPORT_SYMBOL(s3fwrn5_phy_power_ctrl);
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
+EXPORT_SYMBOL(s3fwrn5_phy_get_mode);
diff --git a/drivers/nfc/s3fwrn5/phy_common.h b/drivers/nfc/s3fwrn5/phy_common.h
new file mode 100644
index 0000000..b98531d
--- /dev/null
+++ b/drivers/nfc/s3fwrn5/phy_common.h
@@ -0,0 +1,36 @@
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
+#include <linux/mutex.h>
+#include <net/nfc/nci_core.h>
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
+void s3fwrn5_phy_set_wake(void *phy_id, bool wake);
+bool s3fwrn5_phy_power_ctrl(struct phy_common *phy, enum s3fwrn5_mode mode);
+enum s3fwrn5_mode s3fwrn5_phy_get_mode(void *phy_id);
+
+#endif /* __NFC_S3FWRN5_PHY_COMMON_H */
-- 
1.9.1

