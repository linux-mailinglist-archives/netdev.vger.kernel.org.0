Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EAB042369D
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 05:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237870AbhJFD5M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 23:57:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231985AbhJFD4H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 23:56:07 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B93AC061765
        for <netdev@vger.kernel.org>; Tue,  5 Oct 2021 20:54:15 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id r19so4458702lfe.10
        for <netdev@vger.kernel.org>; Tue, 05 Oct 2021 20:54:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=00n7CaYRtB/oPVPJyhNLQU99dusIfQvK/8kpoba23hk=;
        b=zX40LljGN0ujw8Ut02so9lFStCBV0UifqUNXL0ScIn+t056lOtA+NXl2HUma6WEbyT
         iHzvQr0fA86NTJ4WX5zvV5ZnwjUSwpP/AwO/AwfBrPb1A8whPKrmDYhypIwS4dCm5FoD
         bmfAAvbSh4JeEKf64NBq1URR/KeBWwDXLtCFaQynpl06NivcC6ju2RPI7kY1Ob5KKcVz
         bXnsCjZCPmcAj2ljhIDXY54cOk34otVfOdrOChtE0ZWY/q5NJ/7iIwEdU9+ZHTzTOkmu
         qwOnrOaBCTqAqiCzzhD7u6T0KPw3Q0+yWQ4cJRx0JymQl+BaZAaA7vUcHz3TvNhFsiX3
         uNMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=00n7CaYRtB/oPVPJyhNLQU99dusIfQvK/8kpoba23hk=;
        b=zFprBw9FSppHVrH2uiTLjk17j/O/wLObbP8llZibVsZnhkK9hTt4wEN2F40oKSPNI4
         eLvCYP/BluOCVJDXyOMFDvb0zhzFu1Is81epTW9MzV8pcZ5KtAWQuGwrgC7ZXE4CbVgu
         nIcvOkYME+yS7G19pfQdUUjPBBwd+UTbi3BfxRfSi4YarXxoRFXLnApbhDEOKiuhiPy/
         LUrgteGp5swr0kpU1qRr8Eek2JO9xvmk5cc59NbiY422sHO3/gq0fcIeLxufibWS6xXa
         1Z2jk+gJjxE08QFlIGR1FxP3AhesNAR4oC4/fN9CIljxY803tuiIsWdwCd9QbBKNvVLG
         rHqg==
X-Gm-Message-State: AOAM531Yf/dBTk0BjAtXWM9gvq9wkUoR3FnGY6BwlW69XPOY8hxVp1r9
        uB6rChg+bmn9IycmgQBErCGFzA==
X-Google-Smtp-Source: ABdhPJy3e+mVycCeMiNKlisUqhg9bBIUp1+fzuK3w4Wx3UkS+S2PGMaTnxZyiwjLhZdx7FUZNywDSw==
X-Received: by 2002:a05:6512:2614:: with SMTP id bt20mr7043195lfb.506.1633492453152;
        Tue, 05 Oct 2021 20:54:13 -0700 (PDT)
Received: from eriador.lan ([37.153.55.125])
        by smtp.gmail.com with ESMTPSA id s4sm2142967lfd.103.2021.10.05.20.54.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 20:54:12 -0700 (PDT)
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
Subject: [PATCH v1 02/15] power: add power sequencer subsystem
Date:   Wed,  6 Oct 2021 06:53:54 +0300
Message-Id: <20211006035407.1147909-3-dmitry.baryshkov@linaro.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211006035407.1147909-1-dmitry.baryshkov@linaro.org>
References: <20211006035407.1147909-1-dmitry.baryshkov@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Basing on MMC's pwrseq support code, add separate power sequencer
subsystem. It will be used by other drivers to handle device power up
requirements.

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
---
 Documentation/driver-api/index.rst  |   1 +
 Documentation/driver-api/pwrseq.rst |  77 +++++
 drivers/power/Kconfig               |   1 +
 drivers/power/Makefile              |   1 +
 drivers/power/pwrseq/Kconfig        |  14 +
 drivers/power/pwrseq/Makefile       |   6 +
 drivers/power/pwrseq/core.c         | 448 ++++++++++++++++++++++++++++
 include/linux/pwrseq/consumer.h     |  82 +++++
 include/linux/pwrseq/driver.h       | 160 ++++++++++
 9 files changed, 790 insertions(+)
 create mode 100644 Documentation/driver-api/pwrseq.rst
 create mode 100644 drivers/power/pwrseq/Kconfig
 create mode 100644 drivers/power/pwrseq/Makefile
 create mode 100644 drivers/power/pwrseq/core.c
 create mode 100644 include/linux/pwrseq/consumer.h
 create mode 100644 include/linux/pwrseq/driver.h

diff --git a/Documentation/driver-api/index.rst b/Documentation/driver-api/index.rst
index c57c609ad2eb..15f51c08db1f 100644
--- a/Documentation/driver-api/index.rst
+++ b/Documentation/driver-api/index.rst
@@ -94,6 +94,7 @@ available subsections can be seen below.
    ptp
    phy/index
    pwm
+   pwrseq
    pldmfw/index
    rfkill
    serial/index
diff --git a/Documentation/driver-api/pwrseq.rst b/Documentation/driver-api/pwrseq.rst
new file mode 100644
index 000000000000..df7cfce0f792
--- /dev/null
+++ b/Documentation/driver-api/pwrseq.rst
@@ -0,0 +1,77 @@
+.. Copyright 2021 Linaro Ltd.
+
+..   This documentation is free software; you can redistribute
+..   it and/or modify it under the terms of the GNU General Public
+..   License version 2 as published by the Free Software Foundation.
+
+====================
+Power Sequencing API
+====================
+
+:Author: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
+:Author: Ulf Hansson <ulf.hansson@linaro.org> (original MMC pwrseq)
+
+Introduction
+============
+
+This framework is designed to provide a standard kernel interface to
+handle power sequencing requirements for different devices.
+
+The intention is to provide a generic way to handle power sequencing of complex
+devices sitting on a variety of busses. First implementation comes from MMC
+SDIO/eMMC code, not generified to support other kinds of devices.
+
+Glossary
+--------
+
+The pwrseq API uses a number of terms which may not be familiar:
+
+Power sequencer
+
+    Electronic device (or part of it) that supplies power to other devices.
+    Unlike regulators (which typically handle single voltage), power sequencer
+    handles several voltage inputs. Also it does not provide an exact voltage
+    output. Instead it makes sure that the consumers (see below) are powered on
+    when required.
+
+Consumer
+
+    Electronic device which consumes power provided by a power sequencer.
+
+Consumer driver interface
+=========================
+
+This offers a similar API to the kernel clock or regulator framework. Consumer
+drivers use `get <#API-pwrseq-get>`__ and
+`put <#API-pwrseq-put>`__ operations to acquire and release
+power sequencers. Functions are provided to `power on
+<#API-pwrseq-full-power-on>`__ and `power off <#API-pwrseq-power-off>`__ the
+power sequencer.
+
+A stub version of this API is provided when the power sequencer framework is
+not in use in order to minimise the need to use ifdefs.
+
+Power sequencer driver interface
+================================
+
+Drivers for power sequencers register the sequencer within the pwrseq
+core, providing operations structures to the core.
+
+API reference
+=============
+
+Due to limitations of the kernel documentation framework and the
+existing layout of the source code the entire regulator API is
+documented here.
+
+.. kernel-doc:: include/linux/pwrseq/consumer.h
+   :internal:
+
+.. kernel-doc:: include/linux/pwrseq/driver.h
+   :internal:
+
+.. kernel-doc:: include/linux/pwrseq/fallback.h
+   :internal:
+
+.. kernel-doc:: drivers/power/pwrseq/core.c
+   :export:
diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index 696bf77a7042..c87cd2240a74 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -1,3 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
+source "drivers/power/pwrseq/Kconfig"
 source "drivers/power/reset/Kconfig"
 source "drivers/power/supply/Kconfig"
diff --git a/drivers/power/Makefile b/drivers/power/Makefile
index effbf0377f32..1dbce454a8c4 100644
--- a/drivers/power/Makefile
+++ b/drivers/power/Makefile
@@ -1,3 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
 obj-$(CONFIG_POWER_RESET)	+= reset/
 obj-$(CONFIG_POWER_SUPPLY)	+= supply/
+obj-$(CONFIG_PWRSEQ)		+= pwrseq/
diff --git a/drivers/power/pwrseq/Kconfig b/drivers/power/pwrseq/Kconfig
new file mode 100644
index 000000000000..dab8f4d860fe
--- /dev/null
+++ b/drivers/power/pwrseq/Kconfig
@@ -0,0 +1,14 @@
+# SPDX-License-Identifier: GPL-2.0-only
+menuconfig PWRSEQ
+	bool "Power Sequencer drivers"
+	help
+	  Provides support for special power sequencing drivers. Power
+	  sequencer is an entity providing abstraced power on/power off/reset
+	  operations for the connected devices. Possible usages include MMC
+	  SDIO devices, some complex WiFi/BT chips, controlled USB hubs, etc.
+
+	  Say Y here to enable support for such devices.
+
+if PWRSEQ
+
+endif
diff --git a/drivers/power/pwrseq/Makefile b/drivers/power/pwrseq/Makefile
new file mode 100644
index 000000000000..108429ff6445
--- /dev/null
+++ b/drivers/power/pwrseq/Makefile
@@ -0,0 +1,6 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Makefile for power sequencer drivers.
+#
+
+obj-$(CONFIG_PWRSEQ) += core.o
diff --git a/drivers/power/pwrseq/core.c b/drivers/power/pwrseq/core.c
new file mode 100644
index 000000000000..d29b4b97b95c
--- /dev/null
+++ b/drivers/power/pwrseq/core.c
@@ -0,0 +1,448 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright 2021 (c) Linaro Ltd.
+ * Author: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
+ *
+ * Based on phy-core.c:
+ * Copyright (C) 2013 Texas Instruments Incorporated - http://www.ti.com
+ */
+
+#include <linux/device.h>
+#include <linux/idr.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/of.h>
+#include <linux/pwrseq/consumer.h>
+#include <linux/pwrseq/driver.h>
+#include <linux/slab.h>
+
+#define	to_pwrseq(a)	(container_of((a), struct pwrseq, dev))
+
+static DEFINE_IDA(pwrseq_ida);
+static DEFINE_MUTEX(pwrseq_provider_mutex);
+static LIST_HEAD(pwrseq_provider_list);
+
+/**
+ * struct pwrseq_provider - a 
+ */
+struct pwrseq_provider {
+	struct device		*dev;
+	struct module		*owner;
+	struct list_head	list;
+	void			*data;
+	struct pwrseq * (*of_xlate)(void *data, struct of_phandle_args *args);
+};
+
+/**
+ * pwrseq_put() - release the pwrseq
+ * @pwrseq: the pwrseq returned by pwrseq_get()
+ *
+ * Releases a refcount on the pwrseq instance received from pwrseq_get().
+ */
+void pwrseq_put(struct pwrseq *pwrseq)
+{
+	module_put(pwrseq->owner);
+	put_device(&pwrseq->dev);
+}
+EXPORT_SYMBOL_GPL(pwrseq_put);
+
+static struct pwrseq_provider *of_pwrseq_provider_lookup(struct device_node *node)
+{
+	struct pwrseq_provider *pwrseq_provider;
+
+	list_for_each_entry(pwrseq_provider, &pwrseq_provider_list, list) {
+		if (pwrseq_provider->dev->of_node == node)
+			return pwrseq_provider;
+	}
+
+	return ERR_PTR(-EPROBE_DEFER);
+}
+
+static struct pwrseq *_of_pwrseq_get(struct device *dev, const char *id)
+{
+	struct pwrseq_provider *pwrseq_provider;
+	struct pwrseq *pwrseq;
+	struct of_phandle_args args;
+	char prop_name[64]; /* 64 is max size of property name */
+	int ret;
+
+	snprintf(prop_name, sizeof(prop_name), "%s-pwrseq", id);
+	ret = of_parse_phandle_with_args(dev->of_node, prop_name, "#pwrseq-cells", 0, &args);
+	if (ret == -ENOENT)
+		return NULL;
+	else if (ret < 0)
+		return ERR_PTR(ret);
+
+	mutex_lock(&pwrseq_provider_mutex);
+	pwrseq_provider = of_pwrseq_provider_lookup(args.np);
+	if (IS_ERR(pwrseq_provider) || !try_module_get(pwrseq_provider->owner)) {
+		pwrseq = ERR_PTR(-EPROBE_DEFER);
+		goto out_unlock;
+	}
+
+	if (!of_device_is_available(args.np)) {
+		dev_warn(pwrseq_provider->dev, "Requested pwrseq is disabled\n");
+		pwrseq = ERR_PTR(-ENODEV);
+		goto out_put_module;
+	}
+
+	pwrseq = pwrseq_provider->of_xlate(pwrseq_provider->data, &args);
+
+out_put_module:
+	module_put(pwrseq_provider->owner);
+
+out_unlock:
+	mutex_unlock(&pwrseq_provider_mutex);
+	of_node_put(args.np);
+
+	return pwrseq;
+}
+
+/**
+ * pwrseq_get() - lookup and obtain a reference to a pwrseq
+ * @dev: device for which to get the pwrseq
+ * @id: name of the pwrseq from device's point of view
+ *
+ * Returns the pwrseq instance, after getting a refcount to it; or
+ * NULL if there is no such pwrseq. The caller is responsible for
+ * calling pwrseq_put() to release that count.
+ */
+struct pwrseq * pwrseq_get(struct device *dev, const char *id)
+{
+	struct pwrseq *pwrseq;
+
+	pwrseq = _of_pwrseq_get(dev, id);
+	if (IS_ERR_OR_NULL(pwrseq))
+		return pwrseq;
+
+	if (!try_module_get(pwrseq->owner))
+		return ERR_PTR(-EPROBE_DEFER);
+
+	get_device(&pwrseq->dev);
+
+	return pwrseq;
+}
+EXPORT_SYMBOL_GPL(pwrseq_get);
+
+static void devm_pwrseq_release(struct device *dev, void *res)
+{
+	struct pwrseq *pwrseq = *(struct pwrseq **)res;
+
+	pwrseq_put(pwrseq);
+}
+
+/**
+ * devm_pwrseq_get() - lookup and obtain a reference to a pwrseq
+ * @dev: device for which to get the pwrseq
+ * @id: name of the pwrseq from device's point of view
+ *
+ * Devres-managed variant of pwrseq_get().
+ * Returns the pwrseq instance, after getting a refcount to it; or
+ * NULL if there is no such pwrseq. Gets the pwrseq using pwrseq_get(), and
+ * associates it with the a device using devres. On driver detach, returned
+ * pwrseq is automatically put using pwrseq_put(), removing the need to call it
+ * manually.
+ */
+struct pwrseq * devm_pwrseq_get(struct device *dev, const char *id)
+{
+	struct pwrseq **ptr, *pwrseq;
+
+	ptr = devres_alloc(devm_pwrseq_release, sizeof(*ptr), GFP_KERNEL);
+	if (!ptr)
+		return ERR_PTR(-ENOMEM);
+
+	pwrseq = pwrseq_get(dev, id);
+	if (!IS_ERR_OR_NULL(pwrseq)) {
+		*ptr = pwrseq;
+		devres_add(dev, ptr);
+	} else {
+		devres_free(ptr);
+	}
+
+	return pwrseq;
+}
+EXPORT_SYMBOL_GPL(devm_pwrseq_get);
+
+/**
+ * pwrseq_pre_power_on() - perform pre-power on actions
+ * @pwrseq: pwrseq instance
+ *
+ * Perform pre-powering on actions, like pulling reset pin.  This function
+ * should be called before device is being powered on. Typical usage would
+ * include MMC cards, where pwrseq subsystem is combined with the MMC power
+ * controls.
+ * In most cases there is no need to call it directly, use
+ * @pwrseq_full_power_on() instead.
+ */
+int pwrseq_pre_power_on(struct pwrseq *pwrseq)
+{
+	if (pwrseq && pwrseq->ops->pre_power_on)
+		return pwrseq->ops->pre_power_on(pwrseq);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pwrseq_pre_power_on);
+
+/**
+ * pwrseq_power_on() - power on the device
+ * @pwrseq: pwrseq instance
+ *
+ * Power on the device and perform post-power on actions, like pulling reset
+ * or enable pin. In most cases there is no need to call it directly, use
+ * @pwrseq_full_power_on() instead.
+ */
+int pwrseq_power_on(struct pwrseq *pwrseq)
+{
+	if (pwrseq && pwrseq->ops->power_on)
+		return pwrseq->ops->power_on(pwrseq);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pwrseq_power_on);
+
+/**
+ * pwrseq_power_off() - power off the device
+ * @pwrseq: pwrseq instance
+ *
+ * Power off the device clearly.
+ */
+void pwrseq_power_off(struct pwrseq *pwrseq)
+{
+	if (pwrseq && pwrseq->ops->power_off)
+		pwrseq->ops->power_off(pwrseq);
+}
+EXPORT_SYMBOL_GPL(pwrseq_power_off);
+
+/**
+ * pwrseq_reset() - reset powered device
+ * @pwrseq: pwrseq instance
+ *
+ * Reset the device controlled by the power sequencer.
+ */
+void pwrseq_reset(struct pwrseq *pwrseq)
+{
+	if (pwrseq && pwrseq->ops->reset)
+		pwrseq->ops->reset(pwrseq);
+}
+EXPORT_SYMBOL_GPL(pwrseq_reset);
+
+static void pwrseq_dev_release(struct device *dev)
+{
+	struct pwrseq *pwrseq = to_pwrseq(dev);
+
+	ida_free(&pwrseq_ida, pwrseq->id);
+	of_node_put(dev->of_node);
+	kfree(pwrseq);
+}
+
+static struct class pwrseq_class = {
+	.name = "pwrseq",
+	.dev_release = pwrseq_dev_release,
+};
+
+/**
+ * __pwrseq_create() - internal helper for pwrseq_create
+ * @dev: parent device
+ * @owner: the module providing callbacks.
+ * @ops: pwrseq device callbacks
+ *
+ * This is an internal helper for pwrseq_create which should not be called
+ * directly.
+ *
+ * Return: created instance or the wrapped error code.
+ */
+struct pwrseq *__pwrseq_create(struct device *dev, struct module *owner, const struct pwrseq_ops *ops)
+{
+	struct pwrseq *pwrseq;
+	int ret;
+
+	if (WARN_ON(!dev))
+		return ERR_PTR(-EINVAL);
+
+	pwrseq = kzalloc(sizeof(*pwrseq), GFP_KERNEL);
+	if (!pwrseq)
+		return ERR_PTR(-ENOMEM);
+
+	ret = ida_alloc(&pwrseq_ida, GFP_KERNEL);
+	if (ret < 0)
+		goto free_pwrseq;
+
+	pwrseq->id = ret;
+
+	device_initialize(&pwrseq->dev);
+
+	pwrseq->dev.class = &pwrseq_class;
+	pwrseq->dev.parent = dev;
+	pwrseq->dev.of_node = of_node_get(dev->of_node);
+	pwrseq->ops = ops;
+	pwrseq->owner = owner;
+
+	ret = dev_set_name(&pwrseq->dev, "pwrseq-%s.%u", dev_name(dev), pwrseq->id);
+	if (ret)
+		goto put_dev;
+
+	ret = device_add(&pwrseq->dev);
+	if (ret)
+		goto put_dev;
+
+	return pwrseq;
+
+put_dev:
+	/* will call pwrseq_dev_release() to free resources */
+	put_device(&pwrseq->dev);
+
+	return ERR_PTR(ret);
+
+free_pwrseq:
+	kfree(pwrseq);
+
+	return ERR_PTR(ret);
+}
+EXPORT_SYMBOL_GPL(__pwrseq_create);
+
+void pwrseq_destroy(struct pwrseq *pwrseq)
+{
+	device_unregister(&pwrseq->dev);
+}
+EXPORT_SYMBOL_GPL(pwrseq_destroy);
+
+static void devm_pwrseq_destroy(struct device *dev, void *res)
+{
+	struct pwrseq *pwrseq = *(struct pwrseq **)res;
+
+	pwrseq_destroy(pwrseq);
+}
+
+/**
+ * __devm_pwrseq_create() - devres-managed version of __pwrseq_create
+ * @dev: parent device
+ * @owner: the module providing callbacks.
+ * @ops: pwrseq device callbacks
+ *
+ * This is the devres-managed version of __pwrseq_create(). It is an internal
+ * helper which should not be called directly.
+ *
+ * Return: created instance or the wrapped error code.
+ */
+struct pwrseq *__devm_pwrseq_create(struct device *dev, struct module *owner, const struct pwrseq_ops *ops)
+{
+	struct pwrseq **ptr, *pwrseq;
+
+	ptr = devres_alloc(devm_pwrseq_destroy, sizeof(*ptr), GFP_KERNEL);
+	if (!ptr)
+		return ERR_PTR(-ENOMEM);
+
+	pwrseq = __pwrseq_create(dev, owner, ops);
+	if (!IS_ERR(pwrseq)) {
+		*ptr = pwrseq;
+		devres_add(dev, ptr);
+	} else {
+		devres_free(ptr);
+	}
+
+	return pwrseq;
+}
+EXPORT_SYMBOL_GPL(__devm_pwrseq_create);
+
+/**
+ * __of_pwrseq_provider_register - internal version of of_pwrseq_provider_register
+ * @dev: handling device
+ * @owner: the module providing callbacks.
+ * @xlate: xlate function returning pwrseq instance corresponding to OF args
+ * @data: provider-specific data to be passed to xlate function
+ *
+ * This is an internal helper of of_pwrseq_provider_register, it should not be
+ * called directly.
+ */
+struct pwrseq_provider *__of_pwrseq_provider_register(struct device *dev,
+	struct module *owner,
+	struct pwrseq * (*of_xlate)(void *data,
+				    struct of_phandle_args *args),
+	void *data)
+{
+	struct pwrseq_provider *pwrseq_provider;
+
+	pwrseq_provider = kzalloc(sizeof(*pwrseq_provider), GFP_KERNEL);
+	if (!pwrseq_provider)
+		return ERR_PTR(-ENOMEM);
+
+	if (!fwnode_property_present(dev->fwnode, "#pwrseq-cells"))
+		dev_warn(dev, "no #pwrseq-cells property found, please add the property to the provider\n");
+
+	pwrseq_provider->dev = dev;
+	pwrseq_provider->owner = owner;
+	pwrseq_provider->of_xlate = of_xlate;
+	pwrseq_provider->data = data;
+
+	mutex_lock(&pwrseq_provider_mutex);
+	list_add_tail(&pwrseq_provider->list, &pwrseq_provider_list);
+	mutex_unlock(&pwrseq_provider_mutex);
+
+	return pwrseq_provider;
+}
+EXPORT_SYMBOL_GPL(__of_pwrseq_provider_register);
+
+/**
+ * of_pwrseq_provider_unregister() - unregister pwrseq provider
+ * @pwrseq_provider: pwrseq provider to unregister
+ *
+ * Unregister pwrseq provider previously registered by of_pwrseq_provider_register().
+ */
+void of_pwrseq_provider_unregister(struct pwrseq_provider *pwrseq_provider)
+{
+	if (IS_ERR(pwrseq_provider))
+		return;
+
+	mutex_lock(&pwrseq_provider_mutex);
+	list_del(&pwrseq_provider->list);
+	kfree(pwrseq_provider);
+	mutex_unlock(&pwrseq_provider_mutex);
+}
+EXPORT_SYMBOL_GPL(of_pwrseq_provider_unregister);
+
+static void devm_pwrseq_provider_unregister(struct device *dev, void *res)
+{
+	struct pwrseq_provider *pwrseq_provider = *(struct pwrseq_provider **)res;
+
+	of_pwrseq_provider_unregister(pwrseq_provider);
+}
+
+/**
+ * __devm_of_pwrseq_provider_register - internal version of devm_of_pwrseq_provider_register
+ * @dev: handling device
+ * @owner: the module providing callbacks.
+ * @xlate: xlate function returning pwrseq instance corresponding to OF args
+ * @data: provider-specific data to be passed to xlate function
+ *
+ * This is an internal helper of devm_of_pwrseq_provider_register, it should
+ * not be called directly.
+ */
+struct pwrseq_provider *__devm_of_pwrseq_provider_register(struct device *dev,
+	struct module *owner,
+	struct pwrseq * (*of_xlate)(void *data,
+				    struct of_phandle_args *args),
+	void *data)
+{
+	struct pwrseq_provider **ptr, *pwrseq_provider;
+
+	ptr = devres_alloc(devm_pwrseq_provider_unregister, sizeof(*ptr), GFP_KERNEL);
+	if (!ptr)
+		return ERR_PTR(-ENOMEM);
+
+	pwrseq_provider = __of_pwrseq_provider_register(dev, owner, of_xlate, data);
+	if (!IS_ERR(pwrseq_provider)) {
+		*ptr = pwrseq_provider;
+		devres_add(dev, ptr);
+	} else {
+		devres_free(ptr);
+	}
+
+	return pwrseq_provider;
+}
+EXPORT_SYMBOL_GPL(__devm_of_pwrseq_provider_register);
+
+static int __init pwrseq_core_init(void)
+{
+	return class_register(&pwrseq_class);
+}
+device_initcall(pwrseq_core_init);
diff --git a/include/linux/pwrseq/consumer.h b/include/linux/pwrseq/consumer.h
new file mode 100644
index 000000000000..7c8efefd3184
--- /dev/null
+++ b/include/linux/pwrseq/consumer.h
@@ -0,0 +1,82 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (c) 2021 Linaro Ltd.
+ */
+
+#ifndef __LINUX_PWRSEQ_CONSUMER_H__
+#define __LINUX_PWRSEQ_CONSUMER_H__
+
+struct pwrseq;
+struct device;
+
+#if defined(CONFIG_PWRSEQ)
+
+struct pwrseq *__must_check pwrseq_get(struct device *dev, const char *id);
+struct pwrseq *__must_check devm_pwrseq_get(struct device *dev, const char *id);
+
+void pwrseq_put(struct pwrseq *pwrseq);
+
+int pwrseq_pre_power_on(struct pwrseq *pwrseq);
+int pwrseq_power_on(struct pwrseq *pwrseq);
+void pwrseq_power_off(struct pwrseq *pwrseq);
+void pwrseq_reset(struct pwrseq *pwrseq);
+
+#else
+
+static inline struct pwrseq *__must_check
+pwrseq_get(struct device *dev, const char *id)
+{
+	return NULL;
+}
+
+static inline struct pwrseq *__must_check
+devm_pwrseq_get(struct device *dev, const char *id)
+{
+	return NULL;
+}
+
+static inline void pwrseq_put(struct pwrseq *pwrseq)
+{
+}
+
+static inline int pwrseq_pre_power_on(struct pwrseq *pwrseq)
+{
+	return -ENOSYS;
+}
+
+static inline int pwrseq_power_on(struct pwrseq *pwrseq)
+{
+	return -ENOSYS;
+}
+
+static inline void pwrseq_power_off(struct pwrseq *pwrseq)
+{
+}
+
+static inline void pwrseq_reset(struct pwrseq *pwrseq)
+{
+}
+
+#endif
+
+/**
+ * pwrseq_full_power_on() - Perform full power on of the sequencer
+ * @pwrseq: the power sequencer to power on
+ *
+ * Perform full power on of the sequencer, including pre power on and
+ * power on steps.
+ *
+ * Return: 0 upon no error; -error upon error.
+ */
+static inline int pwrseq_full_power_on(struct pwrseq *pwrseq)
+{
+	int ret;
+
+	ret = pwrseq_pre_power_on(pwrseq);
+	if (ret)
+		return ret;
+
+	return pwrseq_power_on(pwrseq);
+}
+
+#endif /* __LINUX_PWRSEQ_CONSUMER_H__ */
diff --git a/include/linux/pwrseq/driver.h b/include/linux/pwrseq/driver.h
new file mode 100644
index 000000000000..bdb8a25a8504
--- /dev/null
+++ b/include/linux/pwrseq/driver.h
@@ -0,0 +1,160 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (c) 2021 Linaro Ltd.
+ */
+
+#ifndef __LINUX_PWRSEQ_DRIVER_H__
+#define __LINUX_PWRSEQ_DRIVER_H__
+
+#include <linux/device.h>
+
+struct pwrseq;
+
+/**
+ * struct pwrseq_ops - power sequencer operations.
+ *
+ * @pre_power_on: Perform pre powering operations (like ensuring that the
+ *                device will be held in the reset)
+ * @power_on: Power on the sequencer, making sure that the consumer
+ *            devices can be operated
+ * @power_off: Power off the sequencer, removing power from the comsumer
+ *             device (if possible)
+ * @reset: Reset the consumer device
+ */
+struct pwrseq_ops {
+	int (*pre_power_on)(struct pwrseq *pwrseq);
+	int (*power_on)(struct pwrseq *pwrseq);
+	void (*power_off)(struct pwrseq *pwrseq);
+	void (*reset)(struct pwrseq *pwrseq);
+};
+
+struct module;
+
+/**
+ * struct pwrseq - private pwrseq data
+ *
+ * Power sequencer device, one for each power sequencer.
+ *
+ * This should *not* be used directly by anything except the pwrseq core.
+ */
+struct pwrseq {
+	struct device dev;
+	const struct pwrseq_ops *ops;
+	unsigned int id;
+	struct module *owner;
+};
+
+struct pwrseq *__pwrseq_create(struct device *dev, struct module *owner, const struct pwrseq_ops *ops);
+struct pwrseq *__devm_pwrseq_create(struct device *dev, struct module *owner, const struct pwrseq_ops *ops);
+
+/**
+ * pwrseq_create() - create pwrseq instance
+ * @dev: parent device
+ * @ops: pwrseq device callbacks
+ *
+ * Create new pwrseq instance parenting with @dev using provided @ops set of
+ * callbacks. Create instance should be destroyed using @pwrseq_destroy().
+ *
+ * Return: created instance or the wrapped error code.
+ */
+#define pwrseq_create(dev, ops, data) __pwrseq_create((dev), THIS_MODULE, (ops))
+
+/**
+ * devm_pwrseq_create() - devres-managed version of pwrseq_create
+ * @dev: parent device
+ * @ops: pwrseq device callbacks
+ *
+ * This is the devres-managed version of pwrseq_create(). It creates new
+ * pwrseq instance parenting with @dev using provided @ops set of
+ * callbacks. Returned object is destroyed automatically, one must not call
+ * pwrseq_destroy().
+ *
+ * Return: created instance or the wrapped error code.
+ */
+#define devm_pwrseq_create(dev, ops, data) __devm_pwrseq_create((dev), THIS_MODULE, (ops))
+
+void pwrseq_destroy(struct pwrseq *pwrseq);
+
+/**
+ * pwrseq_set_data() - get drv-specific data for the pwrseq
+ * @pwrseq: the pwrseq to get driver data for
+ * @data: the data to set
+ *
+ * Sets the driver-specific data for the provided powrseq instance.
+ */
+static inline void pwrseq_set_drvdata(struct pwrseq *pwrseq, void *data)
+{
+	dev_set_drvdata(&pwrseq->dev, data);
+}
+
+/**
+ * pwrseq_get_data() - get drv-specific data for the pwrseq
+ * @pwrseq: the pwrseq to get driver data for
+ *
+ * Returns driver-specific data for the provided powrseq instance.
+ */
+static inline void *pwrseq_get_drvdata(struct pwrseq *pwrseq)
+{
+	return dev_get_drvdata(&pwrseq->dev);
+}
+
+/**
+ * of_pwrseq_provider_register() - register OF pwrseq provider
+ * @dev: handling device
+ * @xlate: xlate function returning pwrseq instance corresponding to OF args
+ * @data: provider-specific data to be passed to xlate function
+ *
+ * This macros registers OF-specific pwrseq provider. Pwrseq core will call
+ * specified @xlate function to retrieve pwrseq instance corresponding to
+ * device tree arguments. Returned pwrseq provider should be unregistered using
+ * of_pwrseq_provider_unregister().
+ */
+#define of_pwrseq_provider_register(dev, xlate, data)	\
+	__of_pwrseq_provider_register((dev), THIS_MODULE, (xlate), (data))
+
+/**
+ * devm_of_pwrseq_provider_register() - devres-managed version of of_pwrseq_provider_register
+ * @dev: handling device
+ * @xlate: xlate function returning pwrseq instance corresponding to OF args
+ * @data: provider-specific data to be passed to xlate function
+ *
+ * This is a devres-managed version of of_pwrseq_provider_register().
+ * This macros registers OF-specific pwrseq provider. Pwrseq core will call
+ * specified @xlate function to retrieve pwrseq instance corresponding to
+ * device tree arguments. Returned pwrseq provider is automatically
+ * unregistered, without the need to call of_pwrseq_provider_unregister().
+ */
+#define devm_of_pwrseq_provider_register(dev, xlate, data)	\
+	__devm_of_pwrseq_provider_register((dev), THIS_MODULE, (xlate), (data))
+
+struct of_phandle_args;
+
+struct pwrseq_provider *__of_pwrseq_provider_register(struct device *dev,
+	struct module *owner,
+	struct pwrseq * (*of_xlate)(void *data,
+				    struct of_phandle_args *args),
+	void *data);
+struct pwrseq_provider *__devm_of_pwrseq_provider_register(struct device *dev,
+	struct module *owner,
+	struct pwrseq * (*of_xlate)(void *data,
+				    struct of_phandle_args *args),
+	void *data);
+void of_pwrseq_provider_unregister(struct pwrseq_provider *pwrseq_provider);
+
+/**
+ * of_pwrseq_xlate_single() - returns the pwrseq instance from pwrseq provider
+ * @data: the pwrseq provider data
+ * @args: of_phandle_args (not used here)
+ *
+ * Intended to be used by pwrseq provider for the common case where
+ * #pwrseq-cells is 0. For other cases where #pwrseq-cells is greater than '0',
+ * the pwrseq provider should provide a custom of_xlate function that reads the
+ * *args* and returns the appropriate pwrseq.
+ */
+static inline struct pwrseq *of_pwrseq_xlate_single(void *data,
+						    struct of_phandle_args *args)
+{
+	return data;
+}
+
+#endif /* __LINUX_PWRSEQ_DRIVER_H__ */
-- 
2.33.0

