Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EC6A2CBBE8
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 12:51:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729807AbgLBLsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 06:48:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbgLBLsv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 06:48:51 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A482C0613CF;
        Wed,  2 Dec 2020 03:48:26 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id o4so952246pgj.0;
        Wed, 02 Dec 2020 03:48:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=IWMD7vFQDE3dKjrJ5XFuzoTrjZa7gBX9cFb3+yR1d+8=;
        b=BsKRDthqpCWElnALMhhgFRW+JFt7QVAqQVHgT5yBiJVnJcM+ezBZyvuIwap2ubHWlS
         qB+C6X4WvJvYWg2DHaLaDT+hAl2CYMa4l8JZVDxb6fiqQp/0zNR6qED0U2oj3WGyTgnF
         NyOv9ve8YurmSNKSjHeitAhfPl4zWFb2Kd8HfcnDLCH+jIOfBaoIYaIKLD2XYBJtyZY1
         /kkdLfmAx3MHiENyezhkZe6TLjz/+RsxjBZUwJS6CJ6Vj2q/+ssBa+3hsruefMHKD8Gw
         VEuxyMJ8TiJuHxUEBF7lcoGpI9ZRXSBIP8J1Ky4U+bGQ4X891XJhfAwdlDG1unIq1s/G
         Gd8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=IWMD7vFQDE3dKjrJ5XFuzoTrjZa7gBX9cFb3+yR1d+8=;
        b=OasvdvBrCFAPMKcfhh8XNjegz7976PwDTeqrsEGyb4fdcfAWCHYIEXNJ/OJlGqn1Gd
         m2wkGjNlBl7CByt+7peWFUl46SwlaB7YD0bqNs53h6/LMJ+mQPtvDfANwd/Irz33qkbS
         CbhSQQZbxSMB/qEU3szq/cr487QiqO0gJ+4M2F3hHCnvRykNg7RVE2DxzkPmLdT+M9I1
         mEeQiNj1GOsfyH/3jWsy6uk3hRHrq22Rve9sWMAQNd/ifOZzqSBK6CMRRWt48f4BTzeJ
         ZTv8hC50eU7ajPR0M1sS4/LnCHLNgGjJxJPQTpQWBVQ3Gh3Qr6+X5Qasdv/OGlhvdLLd
         YyNQ==
X-Gm-Message-State: AOAM5334WTYwfWjGdAzXN2gAwiklmZsl4XVjBuIqwnP2+UuJZMPHzn/S
        v4aUI9511KnMyw4sdyfabDY=
X-Google-Smtp-Source: ABdhPJxeddcFaXwAbXrlyR6Xx/8+le3SUNb5EAGC+bU8Mseu/hhfNkJZylS1rWMfqflW9RvnwNFRtg==
X-Received: by 2002:a63:6e0d:: with SMTP id j13mr2341946pgc.236.1606909706161;
        Wed, 02 Dec 2020 03:48:26 -0800 (PST)
Received: from localhost.localdomain ([182.226.226.37])
        by smtp.googlemail.com with ESMTPSA id q18sm2108806pfs.150.2020.12.02.03.48.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 02 Dec 2020 03:48:25 -0800 (PST)
From:   Bongsu Jeon <bongsu.jeon2@gmail.com>
X-Google-Original-From: Bongsu Jeon
To:     krzk@kernel.org
Cc:     linux-nfc@lists.01.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: [PATCH v5 net-next 4/4] nfc: s3fwrn5: Support a UART interface
Date:   Wed,  2 Dec 2020 20:47:41 +0900
Message-Id: <1606909661-3814-5-git-send-email-bongsu.jeon@samsung.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1606909661-3814-1-git-send-email-bongsu.jeon@samsung.com>
References: <1606909661-3814-1-git-send-email-bongsu.jeon@samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bongsu Jeon <bongsu.jeon@samsung.com>

Since S3FWRN82 NFC Chip, The UART interface can be used.
S3FWRN82 uses NCI protocol and supports I2C and UART interface.

Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
---
 drivers/nfc/s3fwrn5/Kconfig      |  12 +++
 drivers/nfc/s3fwrn5/Makefile     |   2 +
 drivers/nfc/s3fwrn5/phy_common.c |  12 +++
 drivers/nfc/s3fwrn5/phy_common.h |   1 +
 drivers/nfc/s3fwrn5/uart.c       | 196 +++++++++++++++++++++++++++++++++++++++
 5 files changed, 223 insertions(+)
 create mode 100644 drivers/nfc/s3fwrn5/uart.c

diff --git a/drivers/nfc/s3fwrn5/Kconfig b/drivers/nfc/s3fwrn5/Kconfig
index 3f8b6da..8a6b1a7 100644
--- a/drivers/nfc/s3fwrn5/Kconfig
+++ b/drivers/nfc/s3fwrn5/Kconfig
@@ -20,3 +20,15 @@ config NFC_S3FWRN5_I2C
 	  To compile this driver as a module, choose m here. The module will
 	  be called s3fwrn5_i2c.ko.
 	  Say N if unsure.
+
+config NFC_S3FWRN82_UART
+        tristate "Samsung S3FWRN82 UART support"
+        depends on NFC_NCI && SERIAL_DEV_BUS
+        select NFC_S3FWRN5
+        help
+          This module adds support for a UART interface to the S3FWRN82 chip.
+          Select this if your platform is using the UART bus.
+
+          To compile this driver as a module, choose m here. The module will
+          be called s3fwrn82_uart.ko.
+          Say N if unsure.
diff --git a/drivers/nfc/s3fwrn5/Makefile b/drivers/nfc/s3fwrn5/Makefile
index 6b6f52d..7da827a 100644
--- a/drivers/nfc/s3fwrn5/Makefile
+++ b/drivers/nfc/s3fwrn5/Makefile
@@ -5,6 +5,8 @@
 
 s3fwrn5-objs = core.o firmware.o nci.o phy_common.o
 s3fwrn5_i2c-objs = i2c.o
+s3fwrn82_uart-objs = uart.o
 
 obj-$(CONFIG_NFC_S3FWRN5) += s3fwrn5.o
 obj-$(CONFIG_NFC_S3FWRN5_I2C) += s3fwrn5_i2c.o
+obj-$(CONFIG_NFC_S3FWRN82_UART) += s3fwrn82_uart.o
diff --git a/drivers/nfc/s3fwrn5/phy_common.c b/drivers/nfc/s3fwrn5/phy_common.c
index 5cad1f4..497b02b 100644
--- a/drivers/nfc/s3fwrn5/phy_common.c
+++ b/drivers/nfc/s3fwrn5/phy_common.c
@@ -47,6 +47,18 @@ bool s3fwrn5_phy_power_ctrl(struct phy_common *phy, enum s3fwrn5_mode mode)
 }
 EXPORT_SYMBOL(s3fwrn5_phy_power_ctrl);
 
+void s3fwrn5_phy_set_mode(void *phy_id, enum s3fwrn5_mode mode)
+{
+	struct phy_common *phy = phy_id;
+
+	mutex_lock(&phy->mutex);
+
+	s3fwrn5_phy_power_ctrl(phy, mode);
+
+	mutex_unlock(&phy->mutex);
+}
+EXPORT_SYMBOL(s3fwrn5_phy_set_mode);
+
 enum s3fwrn5_mode s3fwrn5_phy_get_mode(void *phy_id)
 {
 	struct phy_common *phy = phy_id;
diff --git a/drivers/nfc/s3fwrn5/phy_common.h b/drivers/nfc/s3fwrn5/phy_common.h
index b98531d..99749c9 100644
--- a/drivers/nfc/s3fwrn5/phy_common.h
+++ b/drivers/nfc/s3fwrn5/phy_common.h
@@ -31,6 +31,7 @@ struct phy_common {
 
 void s3fwrn5_phy_set_wake(void *phy_id, bool wake);
 bool s3fwrn5_phy_power_ctrl(struct phy_common *phy, enum s3fwrn5_mode mode);
+void s3fwrn5_phy_set_mode(void *phy_id, enum s3fwrn5_mode mode);
 enum s3fwrn5_mode s3fwrn5_phy_get_mode(void *phy_id);
 
 #endif /* __NFC_S3FWRN5_PHY_COMMON_H */
diff --git a/drivers/nfc/s3fwrn5/uart.c b/drivers/nfc/s3fwrn5/uart.c
new file mode 100644
index 0000000..82ea35d
--- /dev/null
+++ b/drivers/nfc/s3fwrn5/uart.c
@@ -0,0 +1,196 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * UART Link Layer for S3FWRN82 NCI based Driver
+ *
+ * Copyright (C) 2015 Samsung Electronics
+ * Robert Baldyga <r.baldyga@samsung.com>
+ * Copyright (C) 2020 Samsung Electronics
+ * Bongsu Jeon <bongsu.jeon@samsung.com>
+ */
+
+#include <linux/device.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/nfc.h>
+#include <linux/netdevice.h>
+#include <linux/of.h>
+#include <linux/serdev.h>
+#include <linux/gpio.h>
+#include <linux/of_gpio.h>
+
+#include "phy_common.h"
+
+#define S3FWRN82_NCI_HEADER 3
+#define S3FWRN82_NCI_IDX 2
+#define NCI_SKB_BUFF_LEN 258
+
+struct s3fwrn82_uart_phy {
+	struct phy_common common;
+	struct serdev_device *ser_dev;
+	struct sk_buff *recv_skb;
+};
+
+static int s3fwrn82_uart_write(void *phy_id, struct sk_buff *out)
+{
+	struct s3fwrn82_uart_phy *phy = phy_id;
+	int err;
+
+	err = serdev_device_write(phy->ser_dev,
+				  out->data, out->len,
+				  MAX_SCHEDULE_TIMEOUT);
+	if (err < 0)
+		return err;
+
+	return 0;
+}
+
+static const struct s3fwrn5_phy_ops uart_phy_ops = {
+	.set_wake = s3fwrn5_phy_set_wake,
+	.set_mode = s3fwrn5_phy_set_mode,
+	.get_mode = s3fwrn5_phy_get_mode,
+	.write = s3fwrn82_uart_write,
+};
+
+static int s3fwrn82_uart_read(struct serdev_device *serdev,
+			      const unsigned char *data,
+			      size_t count)
+{
+	struct s3fwrn82_uart_phy *phy = serdev_device_get_drvdata(serdev);
+	size_t i;
+
+	for (i = 0; i < count; i++) {
+		skb_put_u8(phy->recv_skb, *data++);
+
+		if (phy->recv_skb->len < S3FWRN82_NCI_HEADER)
+			continue;
+
+		if ((phy->recv_skb->len - S3FWRN82_NCI_HEADER)
+				< phy->recv_skb->data[S3FWRN82_NCI_IDX])
+			continue;
+
+		s3fwrn5_recv_frame(phy->common.ndev, phy->recv_skb,
+				   phy->common.mode);
+		phy->recv_skb = alloc_skb(NCI_SKB_BUFF_LEN, GFP_KERNEL);
+		if (!phy->recv_skb)
+			return 0;
+	}
+
+	return i;
+}
+
+static const struct serdev_device_ops s3fwrn82_serdev_ops = {
+	.receive_buf = s3fwrn82_uart_read,
+	.write_wakeup = serdev_device_write_wakeup,
+};
+
+static const struct of_device_id s3fwrn82_uart_of_match[] = {
+	{ .compatible = "samsung,s3fwrn82", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, s3fwrn82_uart_of_match);
+
+static int s3fwrn82_uart_parse_dt(struct serdev_device *serdev)
+{
+	struct s3fwrn82_uart_phy *phy = serdev_device_get_drvdata(serdev);
+	struct device_node *np = serdev->dev.of_node;
+
+	if (!np)
+		return -ENODEV;
+
+	phy->common.gpio_en = of_get_named_gpio(np, "en-gpios", 0);
+	if (!gpio_is_valid(phy->common.gpio_en))
+		return -ENODEV;
+
+	phy->common.gpio_fw_wake = of_get_named_gpio(np, "wake-gpios", 0);
+	if (!gpio_is_valid(phy->common.gpio_fw_wake))
+		return -ENODEV;
+
+	return 0;
+}
+
+static int s3fwrn82_uart_probe(struct serdev_device *serdev)
+{
+	struct s3fwrn82_uart_phy *phy;
+	int ret = -ENOMEM;
+
+	phy = devm_kzalloc(&serdev->dev, sizeof(*phy), GFP_KERNEL);
+	if (!phy)
+		goto err_exit;
+
+	phy->recv_skb = alloc_skb(NCI_SKB_BUFF_LEN, GFP_KERNEL);
+	if (!phy->recv_skb)
+		goto err_exit;
+
+	mutex_init(&phy->common.mutex);
+	phy->common.mode = S3FWRN5_MODE_COLD;
+
+	phy->ser_dev = serdev;
+	serdev_device_set_drvdata(serdev, phy);
+	serdev_device_set_client_ops(serdev, &s3fwrn82_serdev_ops);
+	ret = serdev_device_open(serdev);
+	if (ret) {
+		dev_err(&serdev->dev, "Unable to open device\n");
+		goto err_skb;
+	}
+
+	ret = serdev_device_set_baudrate(serdev, 115200);
+	if (ret != 115200) {
+		ret = -EINVAL;
+		goto err_serdev;
+	}
+
+	serdev_device_set_flow_control(serdev, false);
+
+	ret = s3fwrn82_uart_parse_dt(serdev);
+	if (ret < 0)
+		goto err_serdev;
+
+	ret = devm_gpio_request_one(&phy->ser_dev->dev, phy->common.gpio_en,
+				    GPIOF_OUT_INIT_HIGH, "s3fwrn82_en");
+	if (ret < 0)
+		goto err_serdev;
+
+	ret = devm_gpio_request_one(&phy->ser_dev->dev,
+				    phy->common.gpio_fw_wake,
+				    GPIOF_OUT_INIT_LOW, "s3fwrn82_fw_wake");
+	if (ret < 0)
+		goto err_serdev;
+
+	ret = s3fwrn5_probe(&phy->common.ndev, phy, &phy->ser_dev->dev,
+			    &uart_phy_ops);
+	if (ret < 0)
+		goto err_serdev;
+
+	return ret;
+
+err_serdev:
+	serdev_device_close(serdev);
+err_skb:
+	kfree_skb(phy->recv_skb);
+err_exit:
+	return ret;
+}
+
+static void s3fwrn82_uart_remove(struct serdev_device *serdev)
+{
+	struct s3fwrn82_uart_phy *phy = serdev_device_get_drvdata(serdev);
+
+	s3fwrn5_remove(phy->common.ndev);
+	serdev_device_close(serdev);
+	kfree_skb(phy->recv_skb);
+}
+
+static struct serdev_device_driver s3fwrn82_uart_driver = {
+	.probe = s3fwrn82_uart_probe,
+	.remove = s3fwrn82_uart_remove,
+	.driver = {
+		.name = "s3fwrn82_uart",
+		.of_match_table = s3fwrn82_uart_of_match,
+	},
+};
+
+module_serdev_device_driver(s3fwrn82_uart_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("UART driver for Samsung NFC");
+MODULE_AUTHOR("Bongsu Jeon <bongsu.jeon@samsung.com>");
-- 
1.9.1

