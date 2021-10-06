Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25031423678
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 05:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237574AbhJFD41 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 23:56:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237379AbhJFD4L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 23:56:11 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45507C061786
        for <netdev@vger.kernel.org>; Tue,  5 Oct 2021 20:54:19 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id n8so4532400lfk.6
        for <netdev@vger.kernel.org>; Tue, 05 Oct 2021 20:54:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NeHIhsZMUr5ykJB6Caqyp6Vh5XIKp8x7h5mO8Gk2lJA=;
        b=JUxbS46H6NBi4pyhUO9ZGHUxljkmmFsu0pJ1MztZTmIx0lOvzlLsrza/qzXhdcfkqA
         tzHNBu7cho4Ik8BtD9OCsxGoTX0Zhkwq7V+9F31Nt/K4XnLL1j9MSWzoIl+BfwAi2zvB
         cnoAJpYHzi8Km7qVHJnTMsUttYGJWKqH5V5h3gMpzb4xJ14mpDQrGrl7RvE2hInpCSoP
         MSAkuk5ii1PH1RSLcCglGm7JDtaOdzA5caqSLHHPViXNkIbGS7xeO+YNFWkqoYHM5IAS
         MMI7xXBA/oj04pXU6xndAQjW3s2+1gueXHAu78GYMaidhyyqvCgOyGi6JYaoeHC87Xo2
         bLQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NeHIhsZMUr5ykJB6Caqyp6Vh5XIKp8x7h5mO8Gk2lJA=;
        b=cZRoTIeVAFE2ZVrVD6cLPPZZsmAq3giTVlDbA9W9NYsVFbyx0t0lAQpedK9YC9u9Fa
         hAazA6n8h2n768rcyPH5B64A7f7ydt0B0XaqsnhmFUaQSZghmQUzYnie9wL7W1j9N5l0
         Wg4yZqX2ve5XNHjU73b4N/36EmzUheblrNoPi75OcsRjaTVIB1/EegYJhVoJy3HVS2lg
         S+ZOxBaqgkmyWJJOAQPxgyGdboUPbO+PpcbXmIiD9jXIa2q1oFb6oj+iL/0n/AhNCM8Q
         yVbBRgv0PGls19YN2efHIRaD7q+WfpoDvLVteJOTk/ku+HdrY/XQ8VdfNrJVoW5Gxkdy
         YSag==
X-Gm-Message-State: AOAM531HPERywoE4cVRYsKiogSKLVTNeUXTdQ3ipNwEj0J5U5/af8ZGh
        NH7ksj+eDaTZQPGGWn/rsMOpqsikm73jyg==
X-Google-Smtp-Source: ABdhPJyK9tu7tnCJm/AWi0OyoXXi8YhLObOtc76v0sfowxgHmlXe9CSRMktSA+i8KUxBsBoAP8bIPg==
X-Received: by 2002:a19:7109:: with SMTP id m9mr7621114lfc.112.1633492457604;
        Tue, 05 Oct 2021 20:54:17 -0700 (PDT)
Received: from eriador.lan ([37.153.55.125])
        by smtp.gmail.com with ESMTPSA id s4sm2142967lfd.103.2021.10.05.20.54.16
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
Subject: [PATCH v1 07/15] pwrseq: add fallback support
Date:   Wed,  6 Oct 2021 06:53:59 +0300
Message-Id: <20211006035407.1147909-8-dmitry.baryshkov@linaro.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211006035407.1147909-1-dmitry.baryshkov@linaro.org>
References: <20211006035407.1147909-1-dmitry.baryshkov@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Power sequencer support requires changing device tree. To ease migration
to pwrseq, add support for pwrseq 'fallback': let the power sequencer
driver register special handler that if matched will create pwrseq
instance basing on the consumer device tree data.

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
---
 drivers/power/pwrseq/Makefile   |  2 +-
 drivers/power/pwrseq/core.c     |  3 ++
 drivers/power/pwrseq/fallback.c | 88 +++++++++++++++++++++++++++++++++
 include/linux/pwrseq/fallback.h | 60 ++++++++++++++++++++++
 4 files changed, 152 insertions(+), 1 deletion(-)
 create mode 100644 drivers/power/pwrseq/fallback.c
 create mode 100644 include/linux/pwrseq/fallback.h

diff --git a/drivers/power/pwrseq/Makefile b/drivers/power/pwrseq/Makefile
index 556bf5582d47..949ec848cf00 100644
--- a/drivers/power/pwrseq/Makefile
+++ b/drivers/power/pwrseq/Makefile
@@ -3,7 +3,7 @@
 # Makefile for power sequencer drivers.
 #
 
-obj-$(CONFIG_PWRSEQ) += core.o
+obj-$(CONFIG_PWRSEQ) += core.o fallback.o
 
 obj-$(CONFIG_PWRSEQ_EMMC)	+= pwrseq_emmc.o
 obj-$(CONFIG_PWRSEQ_QCA)	+= pwrseq_qca.o
diff --git a/drivers/power/pwrseq/core.c b/drivers/power/pwrseq/core.c
index 3dffa52f65ee..30380ca6159a 100644
--- a/drivers/power/pwrseq/core.c
+++ b/drivers/power/pwrseq/core.c
@@ -14,6 +14,7 @@
 #include <linux/of.h>
 #include <linux/pwrseq/consumer.h>
 #include <linux/pwrseq/driver.h>
+#include <linux/pwrseq/fallback.h>
 #include <linux/slab.h>
 
 #define	to_pwrseq(a)	(container_of((a), struct pwrseq, dev))
@@ -120,6 +121,8 @@ struct pwrseq * pwrseq_get(struct device *dev, const char *id)
 	struct pwrseq *pwrseq;
 
 	pwrseq = _of_pwrseq_get(dev, id);
+	if (pwrseq == NULL)
+		pwrseq = pwrseq_fallback_get(dev, id);
 	if (IS_ERR_OR_NULL(pwrseq))
 		return pwrseq;
 
diff --git a/drivers/power/pwrseq/fallback.c b/drivers/power/pwrseq/fallback.c
new file mode 100644
index 000000000000..b83bd5795ccb
--- /dev/null
+++ b/drivers/power/pwrseq/fallback.c
@@ -0,0 +1,88 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright 2021 (c) Linaro Ltd.
+ * Author: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
+ */
+
+#include <linux/device.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/of_device.h>
+#include <linux/pwrseq/fallback.h>
+#include <linux/slab.h>
+
+static DEFINE_MUTEX(pwrseq_fallback_mutex);
+static LIST_HEAD(pwrseq_fallback_list);
+
+/**
+ * __pwrseq_fallback_register - internal helper for pwrseq_fallback_register
+ * @fallback - struct pwrseq_fallback to be registered
+ * @owner: module containing fallback callback
+ *
+ * Internal helper for pwrseq_fallback_register. It should not be called directly.
+ */
+int __pwrseq_fallback_register(struct pwrseq_fallback *fallback, struct module *owner)
+{
+	if (!try_module_get(owner))
+		return -EPROBE_DEFER;
+
+	fallback->owner = owner;
+
+	mutex_lock(&pwrseq_fallback_mutex);
+	list_add_tail(&fallback->list, &pwrseq_fallback_list);
+	mutex_unlock(&pwrseq_fallback_mutex);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(__pwrseq_fallback_register);
+
+/**
+ * pwrseq_fallback_unregister() - unregister fallback helper
+ * @fallback - struct pwrseq_fallback to unregister
+ *
+ * Unregister pwrseq fallback handler registered by pwrseq_fallback_handler.
+ */
+void pwrseq_fallback_unregister(struct pwrseq_fallback *fallback)
+{
+	mutex_lock(&pwrseq_fallback_mutex);
+	list_del(&fallback->list);
+	mutex_unlock(&pwrseq_fallback_mutex);
+
+	module_put(fallback->owner);
+
+	kfree(fallback);
+}
+EXPORT_SYMBOL_GPL(pwrseq_fallback_unregister);
+
+static bool pwrseq_fallback_match(struct device *dev, struct pwrseq_fallback *fallback)
+{
+	if (of_match_device(fallback->of_match_table, dev) != NULL)
+		return true;
+
+	/* We might add support for other matching options later */
+
+	return false;
+}
+
+struct pwrseq *pwrseq_fallback_get(struct device *dev, const char *id)
+{
+	struct pwrseq_fallback *fallback;
+	struct pwrseq *pwrseq = ERR_PTR(-ENODEV);
+
+	mutex_lock(&pwrseq_fallback_mutex);
+
+	list_for_each_entry(fallback, &pwrseq_fallback_list, list) {
+		if (!pwrseq_fallback_match(dev, fallback))
+			continue;
+
+		pwrseq = fallback->get(dev, id);
+		break;
+	}
+
+	mutex_unlock(&pwrseq_fallback_mutex);
+
+	if (!IS_ERR_OR_NULL(pwrseq))
+		dev_warn(dev, "legacy pwrseq support used for the device\n");
+
+	return pwrseq;
+}
diff --git a/include/linux/pwrseq/fallback.h b/include/linux/pwrseq/fallback.h
new file mode 100644
index 000000000000..14f9aa527692
--- /dev/null
+++ b/include/linux/pwrseq/fallback.h
@@ -0,0 +1,60 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (c) 2021 Linaro Ltd.
+ */
+
+#ifndef __LINUX_PWRSEQ_FALLBACK_H__
+#define __LINUX_PWRSEQ_FALLBACK_H__
+
+#include <linux/list.h>
+
+struct pwrseq;
+
+struct device;
+struct module;
+struct of_device_id;
+
+/**
+ * struct pwrseq_fallback - structure providing fallback data/
+ * @list: a list node for the fallback handlers
+ * @owner: module containing fallback callback
+ * @of_match_table: match table for this fallback
+ *
+ * Pwrseq fallback is a mechanism for handling backwards compatibility in the
+ * case device tree was not updated to use proper pwrseq providers.
+ *
+ * In case the pwrseq instance is not registered, core will automatically try
+ * locating and calling fallback getter. If the requesting device matches
+ * against @of_match_table, the @get callback will be called to retrieve pwrseq
+ * instance.
+ *
+ * The driver should fill of_match_table and @get fields only. @list and @owner
+ * will be filled by the core code.
+ */
+struct pwrseq_fallback {
+	struct list_head list;
+	struct module *owner;
+
+	const struct of_device_id *of_match_table;
+
+	struct pwrseq *(*get)(struct device *dev, const char *id);
+};
+
+/* provider interface */
+
+int __pwrseq_fallback_register(struct pwrseq_fallback *fallback, struct module *owner);
+
+/**
+ * pwrseq_fallback_register() - register fallback helper
+ * @fallback - struct pwrseq_fallback to be registered
+ *
+ * Register pwrseq fallback handler to assist pwrseq core.
+ */
+#define pwrseq_fallback_register(fallback) __pwrseq_fallback_register(fallback, THIS_MODULE)
+
+void pwrseq_fallback_unregister(struct pwrseq_fallback *fallback);
+
+/* internal interface to be used by pwrseq core */
+struct pwrseq *pwrseq_fallback_get(struct device *dev, const char *id);
+
+#endif /* __LINUX_PWRSEQ_DRIVER_H__ */
-- 
2.33.0

