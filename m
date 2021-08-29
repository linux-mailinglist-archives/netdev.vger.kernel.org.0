Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22DAA3FABD3
	for <lists+netdev@lfdr.de>; Sun, 29 Aug 2021 15:14:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235755AbhH2NPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Aug 2021 09:15:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235459AbhH2NOH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Aug 2021 09:14:07 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74F80C0617AF
        for <netdev@vger.kernel.org>; Sun, 29 Aug 2021 06:13:15 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id l18so20659765lji.12
        for <netdev@vger.kernel.org>; Sun, 29 Aug 2021 06:13:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kOLT9BadebYXeYAB7hIlHQlCOenxQnkUWJLGubnr1rE=;
        b=eXVXijIbP24TAYlaMs97dBBt/U2QEctczDjX6jgLsE/+39va8+QbJ3d1g8XTXECnBR
         jv6X0xYRx9wzh/XMYRccym81uwwlP1jFN8rRs09+hCFR8XDGQIziptoimz2J+G7aLEaz
         FTtdWGwnHtqnZjm0iR28gqPWjQAuubYJqIOpV7vnxuaPL7VjxcsNHgFyF0fTSofSCdas
         Cgw2hcG2ClQJs90DhbGMyDD99/nx+UG1XBOk81n9nEJ0fl8A0U1kzLYNfn+S1U/pQxnD
         /Zm2R7qAggMiYEVrF7HsMShfDo9q+JHJr160fzacnq4ORh+tPTYT+DbxpGZNP19azS01
         JQag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kOLT9BadebYXeYAB7hIlHQlCOenxQnkUWJLGubnr1rE=;
        b=A2M5GLmRTRiOwSXQqm66ZtAfpzTfF8yB+qXpn/XxuwvzxKIjhDu68lba/fR0E/XS5y
         j9fwTMsC7hEXCDaQNI/EcouS2GdB5oXuWCxcjmbQyrq366j1KhplO3bMJqOp0Bk3QikI
         L1pXHvy/+X1H2GIj86LcqbtGUtk9lCQtWxFhZNrIQ+Z/rYyo7aSg2fGWDQNPmvvpfAuf
         17I2WppXp3J1pLVzAg21jui1gcWUXyh0ZqCpmYzaZ1djUIVrTB8qX1UAwvBPygHdbBBW
         ryMUyczFPzEmi5dvTlAeippM7sush4LvBBf0FckPcKrFLfBKPU1r2CEK+XfNvDHrxJlC
         JXOA==
X-Gm-Message-State: AOAM531iXeiPhMDswqQeumkuVK+I+QfDqbKTP4t15IIZRL7IfPEFZ5Bq
        nRe4lW0iaubkaNPmdkyV0Cd4XA==
X-Google-Smtp-Source: ABdhPJz8h3Dug/hv7iINEs/urnSJJdflsvlIbTNNoxvsJmsBCzWXK5+pypfAp26PxquIGMP1uLb1AQ==
X-Received: by 2002:a2e:2417:: with SMTP id k23mr16282098ljk.256.1630242793832;
        Sun, 29 Aug 2021 06:13:13 -0700 (PDT)
Received: from eriador.lan ([37.153.55.125])
        by smtp.gmail.com with ESMTPSA id x13sm712503lfq.262.2021.08.29.06.13.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Aug 2021 06:13:13 -0700 (PDT)
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
Subject: [RFC v2 05/13] pwrseq: add fallback support
Date:   Sun, 29 Aug 2021 16:12:57 +0300
Message-Id: <20210829131305.534417-6-dmitry.baryshkov@linaro.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210829131305.534417-1-dmitry.baryshkov@linaro.org>
References: <20210829131305.534417-1-dmitry.baryshkov@linaro.org>
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
 drivers/power/pwrseq/fallback.c | 75 +++++++++++++++++++++++++++++++++
 include/linux/pwrseq/fallback.h | 36 ++++++++++++++++
 4 files changed, 115 insertions(+), 1 deletion(-)
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
index 2e4e9d123e60..a43977a0eed8 100644
--- a/drivers/power/pwrseq/core.c
+++ b/drivers/power/pwrseq/core.c
@@ -15,6 +15,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/pwrseq/consumer.h>
 #include <linux/pwrseq/driver.h>
+#include <linux/pwrseq/fallback.h>
 #include <linux/slab.h>
 
 #define	to_pwrseq(a)	(container_of((a), struct pwrseq, dev))
@@ -108,6 +109,8 @@ struct pwrseq * __pwrseq_get(struct device *dev, const char *id, bool optional)
 	struct device_link *link;
 
 	pwrseq = _of_pwrseq_get(dev, id);
+	if (pwrseq == NULL)
+		pwrseq = pwrseq_fallback_get(dev, id);
 	if (pwrseq == NULL)
 		return optional ? NULL : ERR_PTR(-ENODEV);
 	else if (IS_ERR(pwrseq))
diff --git a/drivers/power/pwrseq/fallback.c b/drivers/power/pwrseq/fallback.c
new file mode 100644
index 000000000000..6ecf24dd8f29
--- /dev/null
+++ b/drivers/power/pwrseq/fallback.c
@@ -0,0 +1,75 @@
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
index 000000000000..616049df179f
--- /dev/null
+++ b/include/linux/pwrseq/fallback.h
@@ -0,0 +1,36 @@
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
+#define pwrseq_fallback_register(fallback) __pwrseq_fallback_register(fallback, THIS_MODULE)
+
+void pwrseq_fallback_unregister(struct pwrseq_fallback *fallback);
+
+/* internal interface */
+struct pwrseq *pwrseq_fallback_get(struct device *dev, const char *id);
+
+#endif /* __LINUX_PWRSEQ_DRIVER_H__ */
-- 
2.33.0

