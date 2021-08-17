Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B541C3EE1C4
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 02:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237308AbhHQA4s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 20:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236274AbhHQAz6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 20:55:58 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11CD1C06179A
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 17:55:23 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id x27so38052736lfu.5
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 17:55:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OyMcME5CPxd5fEDXOPivzdNGVP2TOxFQZsKew1Sf58Y=;
        b=Czi0W4Nhq43NtkSUG+X51s0lmTQg+bbrUi1EttZ1loEmsFgomXBNVuPFl0Q1mjvkTA
         KGBVpKs4/A8VK1L37AQqiD0bc20FrR03junR3sQHmXqoA1Nt1Jpmfw11JC9NvOtp3Y1/
         mOFcmbn8lfJ+NCdLUu3dVhA4C5gsVhPkkQw6Kyfv+fFhblpU/ZwqwJ+UZ8pkAzHH9+63
         SO/x5NmnKniSGedqUC03UzH0e8TrsJEk9Cjkhu/57I5wUkHk+SHWL91LJaXjlinhWGT3
         NqWEeXCvuSiwUYiDmjUhux67G34rqEd8OubHTffuxitjc88jxy+yPM/ERVT19tii2idL
         KpGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OyMcME5CPxd5fEDXOPivzdNGVP2TOxFQZsKew1Sf58Y=;
        b=kEgnz/30eZ6KRVs59YWmryR6GhWM8nvca8tmDu5mPlLSsmJ6XqzngpQrRUPvD7yrO9
         WOevt01m+K+SmsbVN8hCA6v6atLUW9XPdTpwIeBYol2IaGO0Yqzi4Sda6X4tIW7i3N9S
         uq3YHLZZH0alUShOb7ub1qUDJGwMNn1kAmnY4uxfAc+sHHfDsJDPbAV9BvqwcQHUgywA
         slKIbdTePo+Xq0VyK9ydjLXTGyQZlXd9Y8Q1qfH/z2BzlJ4cBg4qRs1QI5LLqqaQyiat
         NjJggEYUgPl7jdP+e7pCB4HDQSbxcKB1WzaQ1VkqCy1CZ5GmWPkdqA2zZGmvtfSTubpC
         xA4w==
X-Gm-Message-State: AOAM532LPhBgqYqfDgDFQm2eR4nGnxF6iNu+PORPsbPYpadcyp/teeve
        lJ31dedYJ20K/hPBJCbW+kqTPA==
X-Google-Smtp-Source: ABdhPJzlD7npfSA11fru0oQjFEQU2xdEJ1zr2fVBLDpj54foXqcHc0pnM+9JI8M/ZAGlr6Km3w2I+Q==
X-Received: by 2002:a05:6512:98c:: with SMTP id w12mr406590lft.638.1629161721349;
        Mon, 16 Aug 2021 17:55:21 -0700 (PDT)
Received: from eriador.lan ([37.153.55.125])
        by smtp.gmail.com with ESMTPSA id z6sm40719lfb.251.2021.08.16.17.55.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Aug 2021 17:55:21 -0700 (PDT)
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
Subject: [RFC PATCH 10/15] pwrseq: add support for QCA BT+WiFi power sequencer
Date:   Tue, 17 Aug 2021 03:55:02 +0300
Message-Id: <20210817005507.1507580-11-dmitry.baryshkov@linaro.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210817005507.1507580-1-dmitry.baryshkov@linaro.org>
References: <20210817005507.1507580-1-dmitry.baryshkov@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for power sequencer used in the Qualcomm BT+WiFi SoCs. They
require several external volate regulators and some of them use separate
BT and WiFi enable GPIO pins. This code is mostly extracted from the
hci_qca.c bluetooth driver and ath10k WiFi driver. Instead of having
each of them manage pins, different requirements, regulator types, move
this knowledge to the common power sequencer driver. Currently original
drivers are not stripped from the regulator code, this will be done
later (to keep compatibility with the old device trees).

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
---
 drivers/power/pwrseq/Kconfig      |  14 ++
 drivers/power/pwrseq/Makefile     |   1 +
 drivers/power/pwrseq/pwrseq_qca.c | 290 ++++++++++++++++++++++++++++++
 3 files changed, 305 insertions(+)
 create mode 100644 drivers/power/pwrseq/pwrseq_qca.c

diff --git a/drivers/power/pwrseq/Kconfig b/drivers/power/pwrseq/Kconfig
index 36339a456b03..990c3164144e 100644
--- a/drivers/power/pwrseq/Kconfig
+++ b/drivers/power/pwrseq/Kconfig
@@ -19,6 +19,20 @@ config PWRSEQ_EMMC
 	  This driver can also be built as a module. If so, the module
 	  will be called pwrseq_emmc.
 
+config PWRSEQ_QCA
+	tristate "Power Sequencer for Qualcomm WiFi + BT SoCs"
+	depends on OF
+	help
+	  If you say yes to this option, support will be included for Qualcomm
+	  WCN399x,QCA639x,QCA67xx families of hybrid WiFi and Bluetooth SoCs.
+	  Note, this driver supports only power control for these SoC, you
+	  still have to enable individual Bluetooth and WiFi drivers. This
+	  driver is only necessary on ARM platforms with these chips. PCIe
+	  cards handle power sequencing on their own.
+
+	  Say M here if you want to include support for Qualcomm WiFi+BT SoCs
+	  as a module. This will build a module called "pwrseq_qca".
+
 config PWRSEQ_SD8787
 	tristate "HW reset support for SD8787 BT + Wifi module"
 	depends on OF
diff --git a/drivers/power/pwrseq/Makefile b/drivers/power/pwrseq/Makefile
index 6f359d228843..556bf5582d47 100644
--- a/drivers/power/pwrseq/Makefile
+++ b/drivers/power/pwrseq/Makefile
@@ -6,5 +6,6 @@
 obj-$(CONFIG_PWRSEQ) += core.o
 
 obj-$(CONFIG_PWRSEQ_EMMC)	+= pwrseq_emmc.o
+obj-$(CONFIG_PWRSEQ_QCA)	+= pwrseq_qca.o
 obj-$(CONFIG_PWRSEQ_SD8787)	+= pwrseq_sd8787.o
 obj-$(CONFIG_PWRSEQ_SIMPLE)	+= pwrseq_simple.o
diff --git a/drivers/power/pwrseq/pwrseq_qca.c b/drivers/power/pwrseq/pwrseq_qca.c
new file mode 100644
index 000000000000..3421a4821126
--- /dev/null
+++ b/drivers/power/pwrseq/pwrseq_qca.c
@@ -0,0 +1,290 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2021, Linaro Ltd.
+ *
+ * Author: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
+ *
+ * Power Sequencer for Qualcomm WiFi + BT SoCs
+ */
+
+#include <linux/delay.h>
+#include <linux/gpio/consumer.h>
+#include <linux/platform_device.h>
+#include <linux/pwrseq/driver.h>
+#include <linux/regulator/consumer.h>
+
+/*
+ * Voltage regulator information required for configuring the
+ * QCA WiFi+Bluetooth chipset
+ */
+struct qca_vreg {
+	const char *name;
+	unsigned int load_uA;
+};
+
+struct qca_device_data {
+	struct qca_vreg vddio;
+	struct qca_vreg *vregs;
+	size_t num_vregs;
+	bool has_bt_en;
+	bool has_wifi_en;
+};
+
+struct pwrseq_qca;
+struct pwrseq_qca_one {
+	struct pwrseq_qca *common;
+	struct gpio_desc *enable;
+};
+
+#define PWRSEQ_QCA_WIFI 0
+#define PWRSEQ_QCA_BT 1
+
+#define PWRSEQ_QCA_MAX 2
+
+struct pwrseq_qca {
+	struct regulator *vddio;
+	struct gpio_desc *sw_ctrl;
+	struct pwrseq_qca_one pwrseq_qcas[PWRSEQ_QCA_MAX];
+	int num_vregs;
+	struct regulator_bulk_data vregs[];
+};
+
+static int pwrseq_qca_power_on(struct pwrseq *pwrseq)
+{
+	struct pwrseq_qca_one *qca_one = pwrseq_get_data(pwrseq);
+	int ret;
+
+	if (qca_one->common->vddio) {
+		ret = regulator_enable(qca_one->common->vddio);
+		if (ret)
+			return ret;
+	}
+
+	ret = regulator_bulk_enable(qca_one->common->num_vregs, qca_one->common->vregs);
+	if (ret)
+		goto vddio_off;
+
+	if (qca_one->enable) {
+		gpiod_set_value_cansleep(qca_one->enable, 0);
+		msleep(50);
+		gpiod_set_value_cansleep(qca_one->enable, 1);
+		msleep(150);
+	}
+
+	if (qca_one->common->sw_ctrl) {
+		bool sw_ctrl_state = gpiod_get_value_cansleep(qca_one->common->sw_ctrl);
+		dev_dbg(&pwrseq->dev, "SW_CTRL is %d", sw_ctrl_state);
+	}
+
+	return 0;
+
+vddio_off:
+	regulator_disable(qca_one->common->vddio);
+
+	return ret;
+}
+
+static void pwrseq_qca_power_off(struct pwrseq *pwrseq)
+{
+	struct pwrseq_qca_one *qca_one = pwrseq_get_data(pwrseq);
+
+	if (qca_one->enable) {
+		gpiod_set_value_cansleep(qca_one->enable, 0);
+		msleep(50);
+	}
+
+	regulator_bulk_disable(qca_one->common->num_vregs, qca_one->common->vregs);
+	regulator_disable(qca_one->common->vddio);
+
+	if (qca_one->common->sw_ctrl) {
+		bool sw_ctrl_state = gpiod_get_value_cansleep(qca_one->common->sw_ctrl);
+		dev_dbg(&pwrseq->dev, "SW_CTRL is %d", sw_ctrl_state);
+	}
+}
+
+static const struct pwrseq_ops pwrseq_qca_ops = {
+	.power_on = pwrseq_qca_power_on,
+	.power_off = pwrseq_qca_power_off,
+};
+
+static int pwrseq_qca_regulators_init(struct device *dev, struct pwrseq_qca *pwrseq_qca,
+		const struct qca_device_data *data)
+{
+	int ret, i;
+
+	pwrseq_qca->vddio = devm_regulator_get(dev, data->vddio.name);
+	if (IS_ERR(pwrseq_qca->vddio))
+		return PTR_ERR(pwrseq_qca->vddio);
+
+	ret = regulator_set_load(pwrseq_qca->vddio, data->vddio.load_uA);
+	if (ret)
+		return ret;
+
+	pwrseq_qca->num_vregs = data->num_vregs;
+
+	for (i = 0; i < pwrseq_qca->num_vregs; i++)
+		pwrseq_qca->vregs[i].supply = data->vregs[i].name;
+
+	ret = devm_regulator_bulk_get(dev, pwrseq_qca->num_vregs, pwrseq_qca->vregs);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < pwrseq_qca->num_vregs; i++) {
+		if (!data->vregs[i].load_uA)
+			continue;
+
+		ret = regulator_set_load(pwrseq_qca->vregs[i].consumer, data->vregs[i].load_uA);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int pwrseq_qca_probe(struct platform_device *pdev)
+{
+	struct pwrseq_qca *pwrseq_qca;
+	struct pwrseq *pwrseq;
+	struct pwrseq_provider *provider;
+	struct device *dev = &pdev->dev;
+	struct pwrseq_onecell_data *onecell;
+	const struct qca_device_data *data;
+	int ret, i;
+
+	data = device_get_match_data(dev);
+	if (!data)
+		return -EINVAL;
+
+	pwrseq_qca = devm_kzalloc(dev, struct_size(pwrseq_qca, vregs, data->num_vregs), GFP_KERNEL);
+	if (!pwrseq_qca)
+		return -ENOMEM;
+
+	onecell = devm_kzalloc(dev, struct_size(onecell, pwrseqs, PWRSEQ_QCA_MAX), GFP_KERNEL);
+	if (!onecell)
+		return -ENOMEM;
+
+	ret = pwrseq_qca_regulators_init(dev, pwrseq_qca, data);
+	if (ret)
+		return ret;
+
+	if (data->has_wifi_en) {
+		pwrseq_qca->pwrseq_qcas[PWRSEQ_QCA_WIFI].enable = devm_gpiod_get(dev, "wifi-enable", GPIOD_OUT_LOW);
+		if (IS_ERR(pwrseq_qca->pwrseq_qcas[PWRSEQ_QCA_WIFI].enable)) {
+			return dev_err_probe(dev, PTR_ERR(pwrseq_qca->pwrseq_qcas[PWRSEQ_QCA_WIFI].enable),
+					"failed to acquire WIFI enable GPIO\n");
+		}
+	}
+
+	if (data->has_bt_en) {
+		pwrseq_qca->pwrseq_qcas[PWRSEQ_QCA_BT].enable = devm_gpiod_get(dev, "bt-enable", GPIOD_OUT_LOW);
+		if (IS_ERR(pwrseq_qca->pwrseq_qcas[PWRSEQ_QCA_BT].enable)) {
+			return dev_err_probe(dev, PTR_ERR(pwrseq_qca->pwrseq_qcas[PWRSEQ_QCA_BT].enable),
+					"failed to acquire BT enable GPIO\n");
+		}
+	}
+
+	pwrseq_qca->sw_ctrl = devm_gpiod_get_optional(dev, "swctrl", GPIOD_IN);
+	if (IS_ERR(pwrseq_qca->sw_ctrl)) {
+		return dev_err_probe(dev, PTR_ERR(pwrseq_qca->sw_ctrl),
+				"failed to acquire SW_CTRL gpio\n");
+	} else if (!pwrseq_qca->sw_ctrl)
+		dev_info(dev, "No SW_CTRL gpio\n");
+
+	for (i = 0; i < PWRSEQ_QCA_MAX; i++) {
+		pwrseq_qca->pwrseq_qcas[i].common = pwrseq_qca;
+
+		pwrseq = devm_pwrseq_create(dev, &pwrseq_qca_ops, &pwrseq_qca->pwrseq_qcas[i]);
+		if (IS_ERR(pwrseq))
+			return PTR_ERR(pwrseq);
+
+		onecell->pwrseqs[i] = pwrseq;
+	}
+
+	onecell->num = PWRSEQ_QCA_MAX;
+
+	provider = devm_of_pwrseq_provider_register(dev, of_pwrseq_xlate_onecell, onecell);
+
+	return PTR_ERR_OR_ZERO(provider);
+}
+
+static const struct qca_device_data qca_soc_data_qca6390 = {
+	.vddio = { "vddio", 20000 },
+	.vregs = (struct qca_vreg []) {
+		/* 2.0 V */
+		{ "vddpcie2", 15000 },
+		{ "vddrfa3", 400000 },
+
+		/* 0.95 V */
+		{ "vddaon", 100000 },
+		{ "vddpmu", 1250000 },
+		{ "vddrfa1", 200000 },
+
+		/* 1.35 V */
+		{ "vddrfa2", 400000 },
+		{ "vddpcie1", 35000 },
+	},
+	.num_vregs = 7,
+	.has_bt_en = true,
+	.has_wifi_en = true,
+};
+
+/* Shared between wcn3990 and wcn3991 */
+static const struct qca_device_data qca_soc_data_wcn3990 = {
+	.vddio = { "vddio", 15000 },
+	.vregs = (struct qca_vreg []) {
+		{ "vddxo", 80000  },
+		{ "vddrfa", 300000 },
+		{ "vddch0", 450000 },
+		{ "vddch1", 450000 },
+	},
+	.num_vregs = 4,
+};
+
+static const struct qca_device_data qca_soc_data_wcn3998 = {
+	.vddio = { "vddio", 10000 },
+	.vregs = (struct qca_vreg []) {
+		{ "vddxo", 80000  },
+		{ "vddrfa", 300000 },
+		{ "vddch0", 450000 },
+		{ "vddch1", 450000 },
+	},
+	.num_vregs = 4,
+};
+
+static const struct qca_device_data qca_soc_data_wcn6750 = {
+	.vddio = { "vddio", 5000 },
+	.vregs = (struct qca_vreg []) {
+		{ "vddaon", 26000 },
+		{ "vddbtcxmx", 126000 },
+		{ "vddrfacmn", 12500 },
+		{ "vddrfa0p8", 102000 },
+		{ "vddrfa1p7", 302000 },
+		{ "vddrfa1p2", 257000 },
+		{ "vddrfa2p2", 1700000 },
+		{ "vddasd", 200 },
+	},
+	.num_vregs = 8,
+	.has_bt_en = true,
+	.has_wifi_en = true,
+};
+
+static const struct of_device_id pwrseq_qca_of_match[] = {
+	{ .compatible = "qcom,qca6390-pwrseq", .data = &qca_soc_data_qca6390 },
+	{ .compatible = "qcom,wcn3990-pwrseq", .data = &qca_soc_data_wcn3990 },
+	{ .compatible = "qcom,wcn3991-pwrseq", .data = &qca_soc_data_wcn3990 },
+	{ .compatible = "qcom,wcn3998-pwrseq", .data = &qca_soc_data_wcn3998 },
+	{ .compatible = "qcom,wcn6750-pwrseq", .data = &qca_soc_data_wcn6750 },
+	{ /* sentinel */ },
+};
+MODULE_DEVICE_TABLE(of, pwrseq_qca_of_match);
+
+static struct platform_driver pwrseq_qca_driver = {
+	.probe = pwrseq_qca_probe,
+	.driver = {
+		.name = "pwrseq_qca",
+		.of_match_table = pwrseq_qca_of_match,
+	},
+};
+
+module_platform_driver(pwrseq_qca_driver);
+MODULE_LICENSE("GPL v2");
-- 
2.30.2

