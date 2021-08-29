Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 207783FABD1
	for <lists+netdev@lfdr.de>; Sun, 29 Aug 2021 15:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235742AbhH2NPP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Aug 2021 09:15:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235485AbhH2NOJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Aug 2021 09:14:09 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17AC5C06129F
        for <netdev@vger.kernel.org>; Sun, 29 Aug 2021 06:13:17 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id l18so20659916lji.12
        for <netdev@vger.kernel.org>; Sun, 29 Aug 2021 06:13:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gdZGnwzEHVfU1lQviDSHFvhmNm98xNMbizrp42xP5ec=;
        b=UokfyIpM+vjrkS6Rz5X3836JY8QaZc8srNRwNGsKSzrkJxRSLfQiiK0TvOQaGTC599
         R7niZ/jIWguW0cMTLNDguWkDkFSaHGHNRwnFk8pGrnzbsYhbDcnWIHBztBxpfZrr5P6i
         3KJBfAJNUz0o8GptHt6piSYNBPOEBrAngYh5h+U2HtvGi/zlO4FkmOFFZq/aZuWDhA5f
         SEUJB7NjfnGs8CMK/EWh1aVL/HplOSVrVK1UMnNmvOLRXfWIVTuveeKjX18VUovqbwdX
         otHxBpuo0xDwXASLSxeiHR8PXJj4z9yHNQw2wGbk571v6REiXYo4b7TOBpMkfq5H6csd
         2wow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gdZGnwzEHVfU1lQviDSHFvhmNm98xNMbizrp42xP5ec=;
        b=FCYk04qwfHQfT30tw83BOdAjnr5ukKiUx/ORIKHK8hSYkONFymtLvm26HW5DcMCNgO
         tR7n+/KC91g7lKpuTgLLv/ffHiBQzX8qnfK1ImhceNsY4ETIc1zi4+JW9SW2PSNnJcxx
         sZTj71oCnw3jx5wBL4QpA8FKoSAOvi8M98oDYJ9Fr+lbNNKbJpK/rUo8Ck8AvAkyNQJi
         cqiLOz4j9BQDLClAppjd98E80Huqw4Snl34x86pmCfkCVYWMPiYDL7lH2TgsuaVOyBVk
         SWgNdttHnBxX6JUxZO7kIS6Xqsh/jlvCU4vWZ9+DFXiufuvtTk9T5YSg/r6eMYvLTrk6
         1ZdA==
X-Gm-Message-State: AOAM530/p5uIOiopb8EJBt1QtgPkngJEMkFPBO/Yff7ra644XBWJlfy9
        6evHaPEMhkzQ49S6AymSX4DoWQ==
X-Google-Smtp-Source: ABdhPJySbEnkoqU5QeLit6tykd+q4XRc5h5Fnb9NLiRf6BwmkwQhAIxMSSNWPaPDqTPbj7oR8eyH/w==
X-Received: by 2002:a2e:a30d:: with SMTP id l13mr16482973lje.193.1630242795389;
        Sun, 29 Aug 2021 06:13:15 -0700 (PDT)
Received: from eriador.lan ([37.153.55.125])
        by smtp.gmail.com with ESMTPSA id x13sm712503lfq.262.2021.08.29.06.13.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Aug 2021 06:13:15 -0700 (PDT)
From:   Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stanimir Varbanov <svarbanov@mm-sol.com>
Cc:     linux-arm-msm@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [RFC v2 07/13] Bluetooth: hci_qca: switch to using pwrseq
Date:   Sun, 29 Aug 2021 16:12:59 +0300
Message-Id: <20210829131305.534417-8-dmitry.baryshkov@linaro.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210829131305.534417-1-dmitry.baryshkov@linaro.org>
References: <20210829131305.534417-1-dmitry.baryshkov@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
---
 drivers/bluetooth/hci_qca.c | 260 +++++-------------------------------
 1 file changed, 37 insertions(+), 223 deletions(-)

diff --git a/drivers/bluetooth/hci_qca.c b/drivers/bluetooth/hci_qca.c
index 53deea2eb7b4..1e4416916533 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -16,19 +16,17 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/clk.h>
 #include <linux/completion.h>
 #include <linux/debugfs.h>
 #include <linux/delay.h>
 #include <linux/devcoredump.h>
 #include <linux/device.h>
-#include <linux/gpio/consumer.h>
 #include <linux/mod_devicetable.h>
 #include <linux/module.h>
 #include <linux/of_device.h>
 #include <linux/acpi.h>
 #include <linux/platform_device.h>
-#include <linux/regulator/consumer.h>
+#include <linux/pwrseq/consumer.h>
 #include <linux/serdev.h>
 #include <linux/mutex.h>
 #include <asm/unaligned.h>
@@ -54,9 +52,6 @@
 	(MEMDUMP_TIMEOUT_MS + FW_DOWNLOAD_TIMEOUT_MS)
 #define FW_DOWNLOAD_TIMEOUT_MS		3000
 
-/* susclk rate */
-#define SUSCLK_RATE_32KHZ	32768
-
 /* Controller debug log header */
 #define QCA_DEBUG_HANDLE	0x2EDC
 
@@ -200,28 +195,17 @@ struct qca_vreg {
 
 struct qca_device_data {
 	enum qca_btsoc_type soc_type;
-	struct qca_vreg *vregs;
-	size_t num_vregs;
 	uint32_t capabilities;
 };
 
 /*
  * Platform data for the QCA Bluetooth power driver.
  */
-struct qca_power {
-	struct device *dev;
-	struct regulator_bulk_data *vreg_bulk;
-	int num_vregs;
-	bool vregs_on;
-};
-
 struct qca_serdev {
 	struct hci_uart	 serdev_hu;
-	struct gpio_desc *bt_en;
-	struct gpio_desc *sw_ctrl;
-	struct clk	 *susclk;
 	enum qca_btsoc_type btsoc_type;
-	struct qca_power *bt_power;
+	struct pwrseq *pwrseq;
+	bool vregs_on;
 	u32 init_speed;
 	u32 oper_speed;
 	const char *firmware_name;
@@ -1596,13 +1580,12 @@ static int qca_regulator_init(struct hci_uart *hu)
 	enum qca_btsoc_type soc_type = qca_soc_type(hu);
 	struct qca_serdev *qcadev;
 	int ret;
-	bool sw_ctrl_state;
 
 	/* Check for vregs status, may be hci down has turned
 	 * off the voltage regulator.
 	 */
 	qcadev = serdev_device_get_drvdata(hu->serdev);
-	if (!qcadev->bt_power->vregs_on) {
+	if (!qcadev->vregs_on) {
 		serdev_device_close(hu->serdev);
 		ret = qca_regulator_enable(qcadev);
 		if (ret)
@@ -1623,19 +1606,9 @@ static int qca_regulator_init(struct hci_uart *hu)
 			return ret;
 	}
 
-	/* For wcn6750 need to enable gpio bt_en */
-	if (qcadev->bt_en) {
-		gpiod_set_value_cansleep(qcadev->bt_en, 0);
-		msleep(50);
-		gpiod_set_value_cansleep(qcadev->bt_en, 1);
-		msleep(50);
-		if (qcadev->sw_ctrl) {
-			sw_ctrl_state = gpiod_get_value_cansleep(qcadev->sw_ctrl);
-			bt_dev_dbg(hu->hdev, "SW_CTRL is %d", sw_ctrl_state);
-		}
-	}
-
-	qca_set_speed(hu, QCA_INIT_SPEED);
+	if (qca_is_wcn399x(soc_type) ||
+	    qca_is_wcn6750(soc_type))
+		qca_set_speed(hu, QCA_INIT_SPEED);
 
 	if (qca_is_wcn399x(soc_type)) {
 		ret = qca_send_power_pulse(hu, true);
@@ -1655,7 +1628,9 @@ static int qca_regulator_init(struct hci_uart *hu)
 		return ret;
 	}
 
-	hci_uart_set_flow_control(hu, false);
+	if (qca_is_wcn399x(soc_type) ||
+	    qca_is_wcn6750(soc_type))
+		hci_uart_set_flow_control(hu, false);
 
 	return 0;
 }
@@ -1663,8 +1638,6 @@ static int qca_regulator_init(struct hci_uart *hu)
 static int qca_power_on(struct hci_dev *hdev)
 {
 	struct hci_uart *hu = hci_get_drvdata(hdev);
-	enum qca_btsoc_type soc_type = qca_soc_type(hu);
-	struct qca_serdev *qcadev;
 	struct qca_data *qca = hu->priv;
 	int ret = 0;
 
@@ -1674,17 +1647,7 @@ static int qca_power_on(struct hci_dev *hdev)
 	if (!hu->serdev)
 		return 0;
 
-	if (qca_is_wcn399x(soc_type) ||
-	    qca_is_wcn6750(soc_type)) {
-		ret = qca_regulator_init(hu);
-	} else {
-		qcadev = serdev_device_get_drvdata(hu->serdev);
-		if (qcadev->bt_en) {
-			gpiod_set_value_cansleep(qcadev->bt_en, 1);
-			/* Controller needs time to bootup. */
-			msleep(150);
-		}
-	}
+	ret = qca_regulator_init(hu);
 
 	clear_bit(QCA_BT_OFF, &qca->flags);
 	return ret;
@@ -1820,57 +1783,23 @@ static const struct hci_uart_proto qca_proto = {
 
 static const struct qca_device_data qca_soc_data_wcn3990 = {
 	.soc_type = QCA_WCN3990,
-	.vregs = (struct qca_vreg []) {
-		{ "vddio", 15000  },
-		{ "vddxo", 80000  },
-		{ "vddrf", 300000 },
-		{ "vddch0", 450000 },
-	},
-	.num_vregs = 4,
 };
 
 static const struct qca_device_data qca_soc_data_wcn3991 = {
 	.soc_type = QCA_WCN3991,
-	.vregs = (struct qca_vreg []) {
-		{ "vddio", 15000  },
-		{ "vddxo", 80000  },
-		{ "vddrf", 300000 },
-		{ "vddch0", 450000 },
-	},
-	.num_vregs = 4,
 	.capabilities = QCA_CAP_WIDEBAND_SPEECH | QCA_CAP_VALID_LE_STATES,
 };
 
 static const struct qca_device_data qca_soc_data_wcn3998 = {
 	.soc_type = QCA_WCN3998,
-	.vregs = (struct qca_vreg []) {
-		{ "vddio", 10000  },
-		{ "vddxo", 80000  },
-		{ "vddrf", 300000 },
-		{ "vddch0", 450000 },
-	},
-	.num_vregs = 4,
 };
 
 static const struct qca_device_data qca_soc_data_qca6390 = {
 	.soc_type = QCA_QCA6390,
-	.num_vregs = 0,
 };
 
 static const struct qca_device_data qca_soc_data_wcn6750 = {
 	.soc_type = QCA_WCN6750,
-	.vregs = (struct qca_vreg []) {
-		{ "vddio", 5000 },
-		{ "vddaon", 26000 },
-		{ "vddbtcxmx", 126000 },
-		{ "vddrfacmn", 12500 },
-		{ "vddrfa0p8", 102000 },
-		{ "vddrfa1p7", 302000 },
-		{ "vddrfa1p2", 257000 },
-		{ "vddrfa2p2", 1700000 },
-		{ "vddasd", 200 },
-	},
-	.num_vregs = 9,
 	.capabilities = QCA_CAP_WIDEBAND_SPEECH | QCA_CAP_VALID_LE_STATES,
 };
 
@@ -1880,7 +1809,6 @@ static void qca_power_shutdown(struct hci_uart *hu)
 	struct qca_data *qca = hu->priv;
 	unsigned long flags;
 	enum qca_btsoc_type soc_type = qca_soc_type(hu);
-	bool sw_ctrl_state;
 
 	/* From this point we go into power off state. But serial port is
 	 * still open, stop queueing the IBS data and flush all the buffered
@@ -1902,19 +1830,10 @@ static void qca_power_shutdown(struct hci_uart *hu)
 	if (qca_is_wcn399x(soc_type)) {
 		host_set_baudrate(hu, 2400);
 		qca_send_power_pulse(hu, false);
-		qca_regulator_disable(qcadev);
-	} else if (soc_type == QCA_WCN6750) {
-		gpiod_set_value_cansleep(qcadev->bt_en, 0);
-		msleep(100);
-		qca_regulator_disable(qcadev);
-		if (qcadev->sw_ctrl) {
-			sw_ctrl_state = gpiod_get_value_cansleep(qcadev->sw_ctrl);
-			bt_dev_dbg(hu->hdev, "SW_CTRL is %d", sw_ctrl_state);
-		}
-	} else if (qcadev->bt_en) {
-		gpiod_set_value_cansleep(qcadev->bt_en, 0);
 	}
 
+	qca_regulator_disable(qcadev);
+
 	set_bit(QCA_BT_OFF, &qca->flags);
 }
 
@@ -1940,75 +1859,34 @@ static int qca_power_off(struct hci_dev *hdev)
 
 static int qca_regulator_enable(struct qca_serdev *qcadev)
 {
-	struct qca_power *power = qcadev->bt_power;
 	int ret;
 
 	/* Already enabled */
-	if (power->vregs_on)
+	if (qcadev->vregs_on)
 		return 0;
 
-	BT_DBG("enabling %d regulators)", power->num_vregs);
+	BT_DBG("enabling regulators)");
 
-	ret = regulator_bulk_enable(power->num_vregs, power->vreg_bulk);
+	ret = pwrseq_full_power_on(qcadev->pwrseq);
 	if (ret)
 		return ret;
 
-	power->vregs_on = true;
-
-	ret = clk_prepare_enable(qcadev->susclk);
-	if (ret)
-		qca_regulator_disable(qcadev);
+	qcadev->vregs_on = true;
 
 	return ret;
 }
 
 static void qca_regulator_disable(struct qca_serdev *qcadev)
 {
-	struct qca_power *power;
-
 	if (!qcadev)
 		return;
 
-	power = qcadev->bt_power;
-
 	/* Already disabled? */
-	if (!power->vregs_on)
+	if (!qcadev->vregs_on)
 		return;
 
-	regulator_bulk_disable(power->num_vregs, power->vreg_bulk);
-	power->vregs_on = false;
-
-	clk_disable_unprepare(qcadev->susclk);
-}
-
-static int qca_init_regulators(struct qca_power *qca,
-				const struct qca_vreg *vregs, size_t num_vregs)
-{
-	struct regulator_bulk_data *bulk;
-	int ret;
-	int i;
-
-	bulk = devm_kcalloc(qca->dev, num_vregs, sizeof(*bulk), GFP_KERNEL);
-	if (!bulk)
-		return -ENOMEM;
-
-	for (i = 0; i < num_vregs; i++)
-		bulk[i].supply = vregs[i].name;
-
-	ret = devm_regulator_bulk_get(qca->dev, num_vregs, bulk);
-	if (ret < 0)
-		return ret;
-
-	for (i = 0; i < num_vregs; i++) {
-		ret = regulator_set_load(bulk[i].consumer, vregs[i].load_uA);
-		if (ret)
-			return ret;
-	}
-
-	qca->vreg_bulk = bulk;
-	qca->num_vregs = num_vregs;
-
-	return 0;
+	pwrseq_power_off(qcadev->pwrseq);
+	qcadev->vregs_on = false;
 }
 
 static int qca_serdev_probe(struct serdev_device *serdev)
@@ -2017,7 +1895,6 @@ static int qca_serdev_probe(struct serdev_device *serdev)
 	struct hci_dev *hdev;
 	const struct qca_device_data *data;
 	int err;
-	bool power_ctrl_enabled = true;
 
 	qcadev = devm_kzalloc(&serdev->dev, sizeof(*qcadev), GFP_KERNEL);
 	if (!qcadev)
@@ -2033,89 +1910,29 @@ static int qca_serdev_probe(struct serdev_device *serdev)
 	if (!qcadev->oper_speed)
 		BT_DBG("UART will pick default operating speed");
 
-	if (data &&
-	    (qca_is_wcn399x(data->soc_type) ||
-	    qca_is_wcn6750(data->soc_type))) {
-		qcadev->btsoc_type = data->soc_type;
-		qcadev->bt_power = devm_kzalloc(&serdev->dev,
-						sizeof(struct qca_power),
-						GFP_KERNEL);
-		if (!qcadev->bt_power)
-			return -ENOMEM;
-
-		qcadev->bt_power->dev = &serdev->dev;
-		err = qca_init_regulators(qcadev->bt_power, data->vregs,
-					  data->num_vregs);
-		if (err) {
-			BT_ERR("Failed to init regulators:%d", err);
-			return err;
-		}
-
-		qcadev->bt_power->vregs_on = false;
-
-		qcadev->bt_en = devm_gpiod_get_optional(&serdev->dev, "enable",
-					       GPIOD_OUT_LOW);
-		if (!qcadev->bt_en && data->soc_type == QCA_WCN6750) {
-			dev_err(&serdev->dev, "failed to acquire BT_EN gpio\n");
-			power_ctrl_enabled = false;
-		}
 
-		qcadev->sw_ctrl = devm_gpiod_get_optional(&serdev->dev, "swctrl",
-					       GPIOD_IN);
-		if (!qcadev->sw_ctrl && data->soc_type == QCA_WCN6750)
-			dev_warn(&serdev->dev, "failed to acquire SW_CTRL gpio\n");
-
-		qcadev->susclk = devm_clk_get_optional(&serdev->dev, NULL);
-		if (IS_ERR(qcadev->susclk)) {
-			dev_err(&serdev->dev, "failed to acquire clk\n");
-			return PTR_ERR(qcadev->susclk);
-		}
-
-		err = hci_uart_register_device(&qcadev->serdev_hu, &qca_proto);
-		if (err) {
-			BT_ERR("wcn3990 serdev registration failed");
-			return err;
-		}
-	} else {
-		if (data)
-			qcadev->btsoc_type = data->soc_type;
-		else
-			qcadev->btsoc_type = QCA_ROME;
+	if (data)
+		qcadev->btsoc_type = data->soc_type;
+	else
+		qcadev->btsoc_type = QCA_ROME;
 
-		qcadev->bt_en = devm_gpiod_get_optional(&serdev->dev, "enable",
-					       GPIOD_OUT_LOW);
-		if (!qcadev->bt_en) {
-			dev_warn(&serdev->dev, "failed to acquire enable gpio\n");
-			power_ctrl_enabled = false;
-		}
+	qcadev->pwrseq = devm_pwrseq_get(&serdev->dev, "bt");
+	if (IS_ERR(qcadev->pwrseq)) {
+		dev_err(&serdev->dev, "failed to acquire pwrseq\n");
+		return PTR_ERR(qcadev->pwrseq);
+	}
+	qcadev->vregs_on = false;
 
-		qcadev->susclk = devm_clk_get_optional(&serdev->dev, NULL);
-		if (IS_ERR(qcadev->susclk)) {
-			dev_warn(&serdev->dev, "failed to acquire clk\n");
-			return PTR_ERR(qcadev->susclk);
-		}
-		err = clk_set_rate(qcadev->susclk, SUSCLK_RATE_32KHZ);
-		if (err)
-			return err;
-
-		err = clk_prepare_enable(qcadev->susclk);
-		if (err)
-			return err;
-
-		err = hci_uart_register_device(&qcadev->serdev_hu, &qca_proto);
-		if (err) {
-			BT_ERR("Rome serdev registration failed");
-			clk_disable_unprepare(qcadev->susclk);
-			return err;
-		}
+	err = hci_uart_register_device(&qcadev->serdev_hu, &qca_proto);
+	if (err) {
+		BT_ERR("wcn3990 serdev registration failed");
+		return err;
 	}
 
 	hdev = qcadev->serdev_hu.hdev;
 
-	if (power_ctrl_enabled) {
-		set_bit(HCI_QUIRK_NON_PERSISTENT_SETUP, &hdev->quirks);
-		hdev->shutdown = qca_power_off;
-	}
+	set_bit(HCI_QUIRK_NON_PERSISTENT_SETUP, &hdev->quirks);
+	hdev->shutdown = qca_power_off;
 
 	if (data) {
 		/* Wideband speech support must be set per driver since it can't
@@ -2135,14 +1952,11 @@ static int qca_serdev_probe(struct serdev_device *serdev)
 static void qca_serdev_remove(struct serdev_device *serdev)
 {
 	struct qca_serdev *qcadev = serdev_device_get_drvdata(serdev);
-	struct qca_power *power = qcadev->bt_power;
 
 	if ((qca_is_wcn399x(qcadev->btsoc_type) ||
 	     qca_is_wcn6750(qcadev->btsoc_type)) &&
-	     power->vregs_on)
+	     qcadev->vregs_on)
 		qca_power_shutdown(&qcadev->serdev_hu);
-	else if (qcadev->susclk)
-		clk_disable_unprepare(qcadev->susclk);
 
 	hci_uart_unregister_device(&qcadev->serdev_hu);
 }
-- 
2.33.0

