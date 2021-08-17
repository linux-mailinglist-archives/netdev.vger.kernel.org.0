Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9F733EE1DE
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 02:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235708AbhHQA5T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 20:57:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235511AbhHQAzt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 20:55:49 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2BE0C0613CF
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 17:55:15 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id y7so30167093ljp.3
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 17:55:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qnH5wm74aQQYkbbYsHGpsKxsAK5V3pMJGAfubtjXjRY=;
        b=cC4o/hrQ02ISSmttLJwBudvzBxdgJ7lq9XoYmMU3TumY8yehcdwky82yrf60zYVc3a
         7nX1ZONTpwKb8zWb8VzOBNTch3O+6O0HWFf6Ld58mOlWANtH2OkRM+6V8FV7lVOvjWzx
         Urldw7oXrcjAYZqwklTPMae92K1UXReMh27tfz1YIILg8LZQ57iYmP6GgCO/Ls7sb7HC
         crhlLdaiax4C3XWCq//gF3oWlNuBBsaLfr3yBaPVog0K+8vsMRpM+5O/aemvE9ZD93Xb
         oFZug7ynWcw87L5I5OJrPrSbG6OwCsoPbd/KrSXaKLU/5JZKSIHKI9B8/q7sGy/E2CiR
         F9IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qnH5wm74aQQYkbbYsHGpsKxsAK5V3pMJGAfubtjXjRY=;
        b=kmMArfiJXHA7+UMzNApdn4Twm0WdnaaNB67LHrQrvoyJD1TvBxthTIOeiuhvoGMwQ1
         0z6UNTT4R5fVMXigAzlzJWp7iez8DefVtHmLeSrBVN8CJ1vMRkrhCQ53j0npqf2XGZzs
         ycfwHKcfrVVWIXnOgvD3ONsTH/hF6nonRvY/Xh5cRRMKlz5Rtxd8VsEqTFt2Mqhv0csm
         lrr2KNE+Q45VH+HXMJyGKM9+Hl7zxcGtnEnqIlIKnIa6rz6VZ/ZslTHwkWYukisUFNfs
         rvHMpE7Tn+J1mFCfO88Ra7WhPuPB5FSaQFRUac3tz1pAsuTIRAf+E2SLL4GI75L8H1ue
         yDNQ==
X-Gm-Message-State: AOAM533fl8GRrRwo4yOwvz6d89172wSL/m/8v5hDOTMcXzErYljohJwG
        9/Q7S+APCGdOxNATjYsSTG6Kbw==
X-Google-Smtp-Source: ABdhPJwPJ57miR3CMHOwti9+8/OX4IldFiBjVxpgeeZE5hh99p2iu46HrH7fiQwilyAdwnIQCO1LNw==
X-Received: by 2002:a05:651c:211b:: with SMTP id a27mr766103ljq.191.1629161714184;
        Mon, 16 Aug 2021 17:55:14 -0700 (PDT)
Received: from eriador.lan ([37.153.55.125])
        by smtp.gmail.com with ESMTPSA id z6sm40719lfb.251.2021.08.16.17.55.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Aug 2021 17:55:13 -0700 (PDT)
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
Subject: [RFC PATCH 01/15] power: add power sequencer subsystem
Date:   Tue, 17 Aug 2021 03:54:53 +0300
Message-Id: <20210817005507.1507580-2-dmitry.baryshkov@linaro.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210817005507.1507580-1-dmitry.baryshkov@linaro.org>
References: <20210817005507.1507580-1-dmitry.baryshkov@linaro.org>
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
 drivers/power/Kconfig           |   1 +
 drivers/power/Makefile          |   1 +
 drivers/power/pwrseq/Kconfig    |  11 +
 drivers/power/pwrseq/Makefile   |   6 +
 drivers/power/pwrseq/core.c     | 411 ++++++++++++++++++++++++++++++++
 include/linux/pwrseq/consumer.h |  88 +++++++
 include/linux/pwrseq/driver.h   |  71 ++++++
 7 files changed, 589 insertions(+)
 create mode 100644 drivers/power/pwrseq/Kconfig
 create mode 100644 drivers/power/pwrseq/Makefile
 create mode 100644 drivers/power/pwrseq/core.c
 create mode 100644 include/linux/pwrseq/consumer.h
 create mode 100644 include/linux/pwrseq/driver.h

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
index 000000000000..8904ec9ed541
--- /dev/null
+++ b/drivers/power/pwrseq/Kconfig
@@ -0,0 +1,11 @@
+# SPDX-License-Identifier: GPL-2.0-only
+menuconfig PWRSEQ
+	bool "Power Sequencer drivers"
+	help
+	  Provides support for special power sequencing drivers.
+
+	  Say Y here to enable support for such devices
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
index 000000000000..20485cae29aa
--- /dev/null
+++ b/drivers/power/pwrseq/core.c
@@ -0,0 +1,411 @@
+// SPDX-License-Identifier: GPL-2.0-only
+//
+// Copyright 2021 (c) Linaro Ltd.
+// Author: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
+//
+// Based on phy-core.c:
+// Copyright (C) 2013 Texas Instruments Incorporated - http://www.ti.com
+
+#include <linux/device.h>
+#include <linux/idr.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/pm_runtime.h>
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
+struct pwrseq_provider {
+	struct device		*dev;
+	struct module		*owner;
+	struct list_head	list;
+	void			*data;
+	struct pwrseq * (*of_xlate)(void *data, struct of_phandle_args *args);
+};
+
+void pwrseq_put(struct device *dev, struct pwrseq *pwrseq)
+{
+	device_link_remove(dev, &pwrseq->dev);
+
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
+	snprintf(prop_name, 64, "%s-pwrseq", id);
+	ret = of_parse_phandle_with_args(dev->of_node, prop_name, "#pwrseq-cells", 0, &args);
+	if (ret) {
+		struct device_node *dn;
+
+		/*
+		 * Parsing failed. Try locating old bindings for mmc-pwrseq,
+		 * which did not use #pwrseq-cells.
+		 */
+		if (strcmp(id, "mmc"))
+			return ERR_PTR(-ENODEV);
+
+		dn = of_parse_phandle(dev->of_node, prop_name, 0);
+		if (!dn)
+			return ERR_PTR(-ENODEV);
+
+		args.np = dn;
+		args.args_count = 0;
+	}
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
+struct pwrseq *__must_check pwrseq_get(struct device *dev, const char *id)
+{
+	struct pwrseq *pwrseq;
+	struct device_link *link;
+
+	pwrseq = _of_pwrseq_get(dev, id);
+	if (IS_ERR(pwrseq))
+		return pwrseq;
+
+	if (!try_module_get(pwrseq->owner))
+		return ERR_PTR(-EPROBE_DEFER);
+
+	get_device(&pwrseq->dev);
+	link = device_link_add(dev, &pwrseq->dev, DL_FLAG_STATELESS);
+	if (!link)
+		dev_dbg(dev, "failed to create device link to %s\n",
+			dev_name(pwrseq->dev.parent));
+
+	return pwrseq;
+}
+EXPORT_SYMBOL_GPL(pwrseq_get);
+
+static void devm_pwrseq_release(struct device *dev, void *res)
+{
+	struct pwrseq *pwrseq = *(struct pwrseq **)res;
+
+	pwrseq_put(dev, pwrseq);
+}
+
+struct pwrseq *__must_check devm_pwrseq_get(struct device *dev, const char *id)
+{
+	struct pwrseq **ptr, *pwrseq;
+
+	ptr = devres_alloc(devm_pwrseq_release, sizeof(*ptr), GFP_KERNEL);
+	if (!ptr)
+		return ERR_PTR(-ENOMEM);
+
+	pwrseq = pwrseq_get(dev, id);
+	if (!IS_ERR(pwrseq)) {
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
+struct pwrseq *__must_check pwrseq_get_optional(struct device *dev, const char *id)
+{
+	struct pwrseq *pwrseq = pwrseq_get(dev, id);
+
+	if (pwrseq == ERR_PTR(-ENODEV))
+		return NULL;
+
+	return pwrseq;
+}
+EXPORT_SYMBOL_GPL(pwrseq_get_optional);
+
+struct pwrseq *__must_check devm_pwrseq_get_optional(struct device *dev, const char *id)
+{
+	struct pwrseq **ptr, *pwrseq;
+
+	ptr = devres_alloc(devm_pwrseq_release, sizeof(*ptr), GFP_KERNEL);
+	if (!ptr)
+		return ERR_PTR(-ENOMEM);
+
+	pwrseq = pwrseq_get_optional(dev, id);
+	if (!IS_ERR_OR_NULL(pwrseq)) {
+		*ptr = pwrseq;
+		devres_add(dev, ptr);
+	} else {
+		devres_free(ptr);
+	}
+
+	return pwrseq;
+}
+EXPORT_SYMBOL_GPL(devm_pwrseq_get_optional);
+
+int pwrseq_pre_power_on(struct pwrseq *pwrseq)
+{
+	if (pwrseq && pwrseq->ops->pre_power_on)
+		return pwrseq->ops->pre_power_on(pwrseq);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pwrseq_pre_power_on);
+
+int pwrseq_power_on(struct pwrseq *pwrseq)
+{
+	if (pwrseq && pwrseq->ops->power_on)
+		return pwrseq->ops->power_on(pwrseq);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pwrseq_power_on);
+
+void pwrseq_power_off(struct pwrseq *pwrseq)
+{
+	if (pwrseq && pwrseq->ops->power_off)
+		pwrseq->ops->power_off(pwrseq);
+}
+EXPORT_SYMBOL_GPL(pwrseq_power_off);
+
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
+struct pwrseq *__pwrseq_create(struct device *dev, struct module *owner, const struct pwrseq_ops *ops, void *data)
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
+	dev_set_drvdata(&pwrseq->dev, data);
+
+	ret = dev_set_name(&pwrseq->dev, "pwrseq-%s.%u", dev_name(dev), pwrseq->id);
+	if (ret)
+		goto put_dev;
+
+	ret = device_add(&pwrseq->dev);
+	if (ret)
+		goto put_dev;
+
+	if (pm_runtime_enabled(dev)) {
+		pm_runtime_enable(&pwrseq->dev);
+		pm_runtime_no_callbacks(&pwrseq->dev);
+	}
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
+	pm_runtime_disable(&pwrseq->dev);
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
+struct pwrseq *__devm_pwrseq_create(struct device *dev, struct module *owner, const struct pwrseq_ops *ops, void *data)
+{
+	struct pwrseq **ptr, *pwrseq;
+
+	ptr = devres_alloc(devm_pwrseq_destroy, sizeof(*ptr), GFP_KERNEL);
+	if (!ptr)
+		return ERR_PTR(-ENOMEM);
+
+	pwrseq = __pwrseq_create(dev, owner, ops, data);
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
+struct pwrseq *of_pwrseq_xlate_onecell(void *data, struct of_phandle_args *args)
+{
+	struct pwrseq_onecell_data *pwrseq_data = data;
+	unsigned int idx;
+
+	if (args->args_count != 1)
+		return ERR_PTR(-EINVAL);
+
+	idx = args->args[0];
+	if (idx >= pwrseq_data->num) {
+		pr_err("%s: invalid index %u\n", __func__, idx);
+		return ERR_PTR(-EINVAL);
+	}
+
+	return pwrseq_data->pwrseqs[idx];
+}
+
+static int __init pwrseq_core_init(void)
+{
+	return class_register(&pwrseq_class);
+}
+device_initcall(pwrseq_core_init);
diff --git a/include/linux/pwrseq/consumer.h b/include/linux/pwrseq/consumer.h
new file mode 100644
index 000000000000..fbcdc1fc0751
--- /dev/null
+++ b/include/linux/pwrseq/consumer.h
@@ -0,0 +1,88 @@
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
+struct pwrseq *__must_check pwrseq_get_optional(struct device *dev, const char *id);
+struct pwrseq *__must_check devm_pwrseq_get_optional(struct device *dev, const char *id);
+
+void pwrseq_put(struct device *dev, struct pwrseq *pwrseq);
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
+	return ERR_PTR(-ENOSYS);
+}
+
+static inline struct pwrseq *__must_check
+devm_pwrseq_get(struct device *dev, const char *id)
+{
+	return ERR_PTR(-ENOSYS);
+}
+
+static inline struct pwrseq *__must_check
+pwrseq_get_optional(struct device *dev, const char *id)
+{
+	return NULL;
+}
+
+static inline struct pwrseq *__must_check
+devm_pwrseq_get_optional(struct device *dev, const char *id)
+{
+	return NULL;
+}
+
+static inline void pwrseq_put(struct device *dev, struct pwrseq *pwrseq)
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
index 000000000000..6d7c66525134
--- /dev/null
+++ b/include/linux/pwrseq/driver.h
@@ -0,0 +1,71 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (c) 2021 Linaro Ltd.
+ */
+
+#ifndef __LINUX_PWRSEQ_DRIVER_H__
+#define __LINUX_PWRSEQ_DRIVER_H__
+
+#include <linux/of.h>
+
+struct pwrseq;
+
+struct pwrseq_ops {
+	int (*pre_power_on)(struct pwrseq *pwrseq);
+	int (*power_on)(struct pwrseq *pwrseq);
+	void (*power_off)(struct pwrseq *pwrseq);
+	void (*reset)(struct pwrseq *pwrseq);
+};
+
+struct pwrseq {
+	struct device dev;
+	const struct pwrseq_ops *ops;
+	unsigned int id;
+	struct module *owner;
+};
+
+struct pwrseq *__pwrseq_create(struct device *dev, struct module *owner, const struct pwrseq_ops *ops, void *data);
+struct pwrseq *__devm_pwrseq_create(struct device *dev, struct module *owner, const struct pwrseq_ops *ops, void *data);
+
+#define pwrseq_create(dev, ops, data) __pwrseq_create((dev), THIS_MODULE, (ops), (data))
+#define devm_pwrseq_create(dev, ops, data) __devm_pwrseq_create((dev), THIS_MODULE, (ops), (data))
+
+void pwrseq_destroy(struct pwrseq *pwrseq);
+
+static inline void *pwrseq_get_data(struct pwrseq *pwrseq)
+{
+	return dev_get_drvdata(&pwrseq->dev);
+}
+
+#define	of_pwrseq_provider_register(dev, xlate, data)	\
+	__of_pwrseq_provider_register((dev), THIS_MODULE, (xlate), (data))
+
+#define	devm_of_pwrseq_provider_register(dev, xlate, data)	\
+	__devm_of_pwrseq_provider_register((dev), THIS_MODULE, (xlate), (data))
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
+static inline struct pwrseq *of_pwrseq_xlate_single(void *data,
+			       struct of_phandle_args *args)
+{
+	return data;
+}
+
+struct pwrseq_onecell_data {
+	unsigned int num;
+	struct pwrseq *pwrseqs[];
+};
+
+struct pwrseq *of_pwrseq_xlate_onecell(void *data, struct of_phandle_args *args);
+
+#endif /* __LINUX_PWRSEQ_DRIVER_H__ */
-- 
2.30.2

