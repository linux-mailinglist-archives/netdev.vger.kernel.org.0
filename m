Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8495242367C
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 05:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237535AbhJFD4Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 23:56:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237360AbhJFD4K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 23:56:10 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DF6FC06178C
        for <netdev@vger.kernel.org>; Tue,  5 Oct 2021 20:54:18 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id b20so4612441lfv.3
        for <netdev@vger.kernel.org>; Tue, 05 Oct 2021 20:54:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mcNit0g6jUmmUjsU7FAtIRduJRJ7wpPHtyysZeeAHFY=;
        b=Xh2nneBb/87+tArNL4Ub5gViAzfXJDIt0nN7Bymb9OpZLb9P/imlrckWJlA/M+3cTt
         7c8eGMzP7lXSIDLkTnIlfWXLR6Xt8rclJjKYOUk4e73SzYY5wYBvp2wpcbGuRMrQRVAv
         pNJ0hBoGw9uU0TfZASPIBvt36O//ykJfspidjcIBqyIqYOZBX/QzyrooyiirypL/kuXu
         8tdfTQXThfx9NQsFJCPxqhgIjTpcA6bKlxLAp0JTBCeEwhnvOiswNRfaC3Rhbx2jvg2N
         enaYRfssXa/hK05/CkZxpLji7C7cni+x1/ooPHyZAFJhfzZw6eKLiuxEBSKAx79g7fSf
         cqyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mcNit0g6jUmmUjsU7FAtIRduJRJ7wpPHtyysZeeAHFY=;
        b=xBfyHxGdBdDkzVXbqFRKVUMwLbIMWt/3GYFduec4IK7RIJlbcu3+6NAQcWQve9cXqa
         dXLQRlDBkBeqBeSfLEMcliL2KuxbofETzGEY8NibgqUxeL3tDD/eRzCWJs1JNyglA/2u
         Puvn7o5FXsjfsIiKM5I7/QyeY0sAPFIE9IoBkixp6hZKoqXdwsPl6Ovlr1YZqOWzD/rr
         3Ut8sUs/fFtpEHykeROzunWeLzF5P39m+VP8YAb/XppAaFXtMEvQ6SUm4ZUis4Nhh0Ve
         wZpcocdOB2JbpXeOU63EKj/iMW13zn8sLSwahO92fQ/t1VEJQOlauHi44zcPqM66glVA
         ML/g==
X-Gm-Message-State: AOAM532Rsvlc1PzC9AGltmGzsE0ojjy8V3W58QEhGYSYPCPWaAWwATVY
        HgAxwTyKOMP4sAPnK6A9W5HUKg==
X-Google-Smtp-Source: ABdhPJz1kFyKYOWjo2k7SexA6deiKwcYASU6DfLmY4tB7DuImqXPFUkuj8BoRxRFiJxUQoWHk0T4Xg==
X-Received: by 2002:a05:651c:1615:: with SMTP id f21mr11860995ljq.318.1633492456613;
        Tue, 05 Oct 2021 20:54:16 -0700 (PDT)
Received: from eriador.lan ([37.153.55.125])
        by smtp.gmail.com with ESMTPSA id s4sm2142967lfd.103.2021.10.05.20.54.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 20:54:16 -0700 (PDT)
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
Subject: [PATCH v1 06/15] pwrseq: add support for QCA BT+WiFi power sequencer
Date:   Wed,  6 Oct 2021 06:53:58 +0300
Message-Id: <20211006035407.1147909-7-dmitry.baryshkov@linaro.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211006035407.1147909-1-dmitry.baryshkov@linaro.org>
References: <20211006035407.1147909-1-dmitry.baryshkov@linaro.org>
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
 drivers/power/pwrseq/pwrseq_qca.c | 373 ++++++++++++++++++++++++++++++
 3 files changed, 388 insertions(+)
 create mode 100644 drivers/power/pwrseq/pwrseq_qca.c

diff --git a/drivers/power/pwrseq/Kconfig b/drivers/power/pwrseq/Kconfig
index 1985f13d9193..7983e37c7855 100644
--- a/drivers/power/pwrseq/Kconfig
+++ b/drivers/power/pwrseq/Kconfig
@@ -22,6 +22,20 @@ config PWRSEQ_EMMC
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
index 000000000000..c15508cc80d2
--- /dev/null
+++ b/drivers/power/pwrseq/pwrseq_qca.c
@@ -0,0 +1,373 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2021, Linaro Ltd.
+ *
+ * Author: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
+ *
+ * Power Sequencer for Qualcomm WiFi + BT SoCs
+ */
+
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/gpio/consumer.h>
+#include <linux/mod_devicetable.h>
+#include <linux/platform_device.h>
+#include <linux/property.h>
+#include <linux/pwrseq/driver.h>
+#include <linux/regulator/consumer.h>
+
+/* susclk rate */
+#define SUSCLK_RATE_32KHZ	32768
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
+	bool has_enable_gpios;
+
+	/*
+	 * VDDIO has to be enabled before the rest of regulators, so we treat
+	 * it separately
+	 */
+	struct qca_vreg vddio;
+
+	size_t num_vregs;
+	struct qca_vreg vregs[];
+};
+
+struct pwrseq_qca_common {
+	struct gpio_desc *sw_ctrl;
+	struct clk *susclk;
+
+	/*
+	 * Again vddio is separate so that it can be enabled before enabling
+	 * other regulators.
+	 */
+	struct regulator *vddio;
+	int num_vregs;
+	struct regulator_bulk_data vregs[];
+};
+
+struct pwrseq_qca_one {
+	struct pwrseq_qca_common *common;
+	struct gpio_desc *enable;
+};
+
+#define PWRSEQ_QCA_WIFI 0
+#define PWRSEQ_QCA_BT 1
+
+#define PWRSEQ_QCA_MAX 2
+
+struct pwrseq_qca {
+	struct pwrseq_qca_one pwrseq_qcas[PWRSEQ_QCA_MAX];
+	struct pwrseq_qca_common common;
+};
+
+static int pwrseq_qca_pre_power_on(struct pwrseq *pwrseq)
+{
+	struct pwrseq_qca_one *qca_one = pwrseq_get_drvdata(pwrseq);
+
+	if (qca_one->enable) {
+		gpiod_set_value_cansleep(qca_one->enable, 0);
+		msleep(50);
+	}
+
+	return 0;
+}
+
+static int pwrseq_qca_power_on(struct pwrseq *pwrseq)
+{
+	struct pwrseq_qca_one *qca_one = pwrseq_get_drvdata(pwrseq);
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
+		goto err_bulk;
+
+	ret = clk_prepare_enable(qca_one->common->susclk);
+	if (ret)
+		goto err_clk;
+
+	if (qca_one->enable) {
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
+err_clk:
+	regulator_bulk_disable(qca_one->common->num_vregs, qca_one->common->vregs);
+err_bulk:
+	regulator_disable(qca_one->common->vddio);
+
+	return ret;
+}
+
+static void pwrseq_qca_power_off(struct pwrseq *pwrseq)
+{
+	struct pwrseq_qca_one *qca_one = pwrseq_get_drvdata(pwrseq);
+
+	if (qca_one->enable) {
+		gpiod_set_value_cansleep(qca_one->enable, 0);
+		msleep(50);
+	}
+
+	clk_disable_unprepare(qca_one->common->susclk);
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
+	.pre_power_on = pwrseq_qca_pre_power_on,
+	.power_on = pwrseq_qca_power_on,
+	.power_off = pwrseq_qca_power_off,
+};
+
+static int pwrseq_qca_common_init(struct device *dev, struct pwrseq_qca_common *qca_common,
+		const struct qca_device_data *data)
+{
+	int ret, i;
+
+	if (data->vddio.name) {
+		qca_common->vddio = devm_regulator_get(dev, data->vddio.name);
+		if (IS_ERR(qca_common->vddio))
+			return PTR_ERR(qca_common->vddio);
+
+		ret = regulator_set_load(qca_common->vddio, data->vddio.load_uA);
+		if (ret)
+			return ret;
+	}
+
+	qca_common->num_vregs = data->num_vregs;
+
+	for (i = 0; i < qca_common->num_vregs; i++)
+		qca_common->vregs[i].supply = data->vregs[i].name;
+
+	ret = devm_regulator_bulk_get(dev, qca_common->num_vregs, qca_common->vregs);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < qca_common->num_vregs; i++) {
+		if (!data->vregs[i].load_uA)
+			continue;
+
+		ret = regulator_set_load(qca_common->vregs[i].consumer, data->vregs[i].load_uA);
+		if (ret)
+			return ret;
+	}
+
+	qca_common->susclk = devm_clk_get_optional(dev, NULL);
+	if (IS_ERR(qca_common->susclk)) {
+		dev_err(dev, "failed to acquire clk\n");
+		return PTR_ERR(qca_common->susclk);
+	}
+
+	qca_common->sw_ctrl = devm_gpiod_get_optional(dev, "swctrl", GPIOD_IN);
+	if (IS_ERR(qca_common->sw_ctrl)) {
+		return dev_err_probe(dev, PTR_ERR(qca_common->sw_ctrl),
+				"failed to acquire SW_CTRL gpio\n");
+	} else if (!qca_common->sw_ctrl)
+		dev_info(dev, "No SW_CTRL gpio\n");
+
+	return 0;
+}
+
+static void pwrseq_qca_unprepare_susclk(void *data)
+{
+	struct pwrseq_qca_common *qca_common = data;
+
+	clk_disable_unprepare(qca_common->susclk);
+}
+
+static const struct qca_device_data qca_soc_data_default = {
+	.num_vregs = 0,
+	.has_enable_gpios = true,
+};
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
+		data = &qca_soc_data_default;
+
+	pwrseq_qca = devm_kzalloc(dev, struct_size(pwrseq_qca, common.vregs, data->num_vregs), GFP_KERNEL);
+	if (!pwrseq_qca)
+		return -ENOMEM;
+
+	onecell = devm_kzalloc(dev, struct_size(onecell, pwrseqs, PWRSEQ_QCA_MAX), GFP_KERNEL);
+	if (!onecell)
+		return -ENOMEM;
+
+	ret = pwrseq_qca_common_init(dev, &pwrseq_qca->common, data);
+	if (ret)
+		return ret;
+
+	if (data->has_enable_gpios) {
+		struct gpio_desc *gpiod;
+
+		gpiod = devm_gpiod_get_optional(dev, "wifi-enable", GPIOD_OUT_LOW);
+		if (IS_ERR(gpiod))
+			return dev_err_probe(dev, PTR_ERR(gpiod), "failed to acquire WIFI enable GPIO\n");
+		else if (!gpiod)
+			dev_warn(dev, "No WiFi enable GPIO declared\n");
+
+		pwrseq_qca->pwrseq_qcas[PWRSEQ_QCA_WIFI].enable = gpiod;
+
+		gpiod = devm_gpiod_get_optional(dev, "bt-enable", GPIOD_OUT_LOW);
+		if (IS_ERR(gpiod))
+			return dev_err_probe(dev, PTR_ERR(gpiod), "failed to acquire BT enable GPIO\n");
+		else if (!gpiod)
+			dev_warn(dev, "No BT enable GPIO declared\n");
+
+		pwrseq_qca->pwrseq_qcas[PWRSEQ_QCA_BT].enable = gpiod;
+	}
+
+	/* If we have no control over device's enablement, make sure that sleep clock is always running */
+	if (!pwrseq_qca->common.vddio ||
+	    !pwrseq_qca->common.num_vregs ||
+	    !(pwrseq_qca->pwrseq_qcas[PWRSEQ_QCA_BT].enable &&
+	      pwrseq_qca->pwrseq_qcas[PWRSEQ_QCA_WIFI].enable)) {
+		ret = clk_set_rate(pwrseq_qca->common.susclk, SUSCLK_RATE_32KHZ);
+		if (ret)
+			return ret;
+
+		ret = clk_prepare_enable(pwrseq_qca->common.susclk);
+		if (ret)
+			return ret;
+
+		ret = devm_add_action_or_reset(dev, pwrseq_qca_unprepare_susclk, &pwrseq_qca->common);
+		if (ret)
+			return ret;
+	}
+
+	for (i = 0; i < PWRSEQ_QCA_MAX; i++) {
+		pwrseq_qca->pwrseq_qcas[i].common = &pwrseq_qca->common;
+
+		pwrseq = devm_pwrseq_create(dev, &pwrseq_qca_ops);
+		if (IS_ERR(pwrseq))
+			return PTR_ERR(pwrseq);
+
+		pwrseq_set_drvdata(pwrseq, &pwrseq_qca->pwrseq_qcas[i]);
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
+	.vregs = {
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
+	.has_enable_gpios = true,
+};
+
+/* Shared between wcn3990 and wcn3991 */
+static const struct qca_device_data qca_soc_data_wcn3990 = {
+	.vddio = { "vddio", 15000 },
+	.vregs = {
+		{ "vddxo", 80000  },
+		{ "vddrf", 300000 },
+		{ "vddch0", 450000 },
+		{ "vddch1", 450000 },
+	},
+	.num_vregs = 4,
+};
+
+static const struct qca_device_data qca_soc_data_wcn3998 = {
+	.vddio = { "vddio", 10000 },
+	.vregs = {
+		{ "vddxo", 80000  },
+		{ "vddrf", 300000 },
+		{ "vddch0", 450000 },
+		{ "vddch1", 450000 },
+	},
+	.num_vregs = 4,
+};
+
+static const struct qca_device_data qca_soc_data_wcn6750 = {
+	.vddio = { "vddio", 5000 },
+	.vregs = {
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
+	.has_enable_gpios = true,
+};
+
+static const struct of_device_id pwrseq_qca_of_match[] = {
+	{ .compatible = "qcom,qca6174-pwrseq", },
+	{ .compatible = "qcom,qca6390-pwrseq", .data = &qca_soc_data_qca6390 },
+	{ .compatible = "qcom,qca9377-pwrseq" },
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
2.33.0

