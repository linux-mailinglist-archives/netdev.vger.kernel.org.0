Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21E6B42366F
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 05:54:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237407AbhJFD4M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 23:56:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237313AbhJFD4I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 23:56:08 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4866FC061787
        for <netdev@vger.kernel.org>; Tue,  5 Oct 2021 20:54:16 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id j5so4511619lfg.8
        for <netdev@vger.kernel.org>; Tue, 05 Oct 2021 20:54:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9lmj4z2XmvtgOeyuCcLAR8+/FQoqDUZMLX1DvXWCDtk=;
        b=cMeYaNyTbMR8bGLWrM98suMs6L0Yshkz2dJCZMFbLzamLV+tOYwNg1q0EFd9rZZwzK
         s8gV/uthkE5+RN9/bQV52t78R7tU+hMwu5HPOWsXPtkNGO7hLm/LNVw8Hp2TBYl00uzz
         iymzZ1siy3Li2jScYl44aSSBG9jSWzs9v/KmkCDSZz9zzaaglKVqTaly7cIpwImQleY3
         Jt4e6dBAOpLzYca9ka7Px/snHAZI4r9SdZ+9YGAvn14Rplfp5SBZVVELE7D81vuDlhfm
         aT8G1R+idv20rIeIr63bDBletPmiwDxaQNaFYqFaWNUbKY54EfayHITiwHWGc7opOUh9
         we0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9lmj4z2XmvtgOeyuCcLAR8+/FQoqDUZMLX1DvXWCDtk=;
        b=SHzhtt4f0S6Dh8O+X+exmwcTz/W7Ix+frb60+kUR65yHihhT0c0Pvx13oxJ7wDFXsn
         DBId7XRPrKHYLWBkvg1SW0vn8QeohrQLy+ipQ6DrR/z95DpciHS2LCjQD3yrAh+kgSsA
         carwSz2U80HFedq4kdkLEG9Hv0mn4VGqYB6TvJpjfbEQs6V+2UKi7jFazcf5awBqkKNz
         IENagewFUXQndp/PAfflkgTPF+lTdRKAWAZ6MF/qsRnXhbNXg057JHn1tz2hGUKLqt/g
         sljaFK2Po5tJiGFZpSq0dtLWzgBFkFthmnBIhQXjNh4PsqKaafJHLx0DPriHH427k9Zb
         Aptw==
X-Gm-Message-State: AOAM533N7Dahc3S8LaL83esoXOcZJxMw6DCfJxlIgLMfKJtBSPuMPo8w
        qyKIIV7GWz5uX3vhMrXpAKwdcw==
X-Google-Smtp-Source: ABdhPJzaab7eXLdHwpE+7i1SfolFjAbanjbGoslkWp1x8IKRGRFcoRzPguB7/mw2H4Kzt92jpXGVqA==
X-Received: by 2002:a2e:7f14:: with SMTP id a20mr27460466ljd.259.1633492454543;
        Tue, 05 Oct 2021 20:54:14 -0700 (PDT)
Received: from eriador.lan ([37.153.55.125])
        by smtp.gmail.com with ESMTPSA id s4sm2142967lfd.103.2021.10.05.20.54.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 20:54:14 -0700 (PDT)
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
Subject: [PATCH v1 04/15] mmc: core: switch to new pwrseq subsystem
Date:   Wed,  6 Oct 2021 06:53:56 +0300
Message-Id: <20211006035407.1147909-5-dmitry.baryshkov@linaro.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211006035407.1147909-1-dmitry.baryshkov@linaro.org>
References: <20211006035407.1147909-1-dmitry.baryshkov@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drop old MMC pwrseq code and use new pwrseq subsystem instead.
Individual drivers are already ported to new subsystem.

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
---
 drivers/mmc/core/Makefile   |   1 -
 drivers/mmc/core/core.c     |   9 ++-
 drivers/mmc/core/host.c     |   8 ++-
 drivers/mmc/core/mmc.c      |   3 +-
 drivers/mmc/core/pwrseq.c   | 117 ------------------------------------
 drivers/mmc/core/pwrseq.h   |  58 ------------------
 drivers/power/pwrseq/core.c |   8 +++
 include/linux/mmc/host.h    |   4 +-
 8 files changed, 20 insertions(+), 188 deletions(-)
 delete mode 100644 drivers/mmc/core/pwrseq.c
 delete mode 100644 drivers/mmc/core/pwrseq.h

diff --git a/drivers/mmc/core/Makefile b/drivers/mmc/core/Makefile
index 322eb69bd00e..a504d873cf8e 100644
--- a/drivers/mmc/core/Makefile
+++ b/drivers/mmc/core/Makefile
@@ -9,7 +9,6 @@ mmc_core-y			:= core.o bus.o host.o \
 				   sdio.o sdio_ops.o sdio_bus.o \
 				   sdio_cis.o sdio_io.o sdio_irq.o \
 				   slot-gpio.o regulator.o
-mmc_core-$(CONFIG_OF)		+= pwrseq.o
 mmc_core-$(CONFIG_DEBUG_FS)	+= debugfs.o
 obj-$(CONFIG_MMC_BLOCK)		+= mmc_block.o
 mmc_block-objs			:= block.o queue.o
diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 240c5af793dc..c4b08067ab9f 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -41,7 +41,6 @@
 #include "bus.h"
 #include "host.h"
 #include "sdio_bus.h"
-#include "pwrseq.h"
 
 #include "mmc_ops.h"
 #include "sd_ops.h"
@@ -1322,7 +1321,7 @@ void mmc_power_up(struct mmc_host *host, u32 ocr)
 	if (host->ios.power_mode == MMC_POWER_ON)
 		return;
 
-	mmc_pwrseq_pre_power_on(host);
+	pwrseq_pre_power_on(host->pwrseq);
 
 	host->ios.vdd = fls(ocr) - 1;
 	host->ios.power_mode = MMC_POWER_UP;
@@ -1337,7 +1336,7 @@ void mmc_power_up(struct mmc_host *host, u32 ocr)
 	 */
 	mmc_delay(host->ios.power_delay_ms);
 
-	mmc_pwrseq_post_power_on(host);
+	pwrseq_power_on(host->pwrseq);
 
 	host->ios.clock = host->f_init;
 
@@ -1356,7 +1355,7 @@ void mmc_power_off(struct mmc_host *host)
 	if (host->ios.power_mode == MMC_POWER_OFF)
 		return;
 
-	mmc_pwrseq_power_off(host);
+	pwrseq_power_off(host->pwrseq);
 
 	host->ios.clock = 0;
 	host->ios.vdd = 0;
@@ -1986,7 +1985,7 @@ EXPORT_SYMBOL(mmc_set_blocklen);
 
 static void mmc_hw_reset_for_init(struct mmc_host *host)
 {
-	mmc_pwrseq_reset(host);
+	pwrseq_reset(host->pwrseq);
 
 	if (!(host->caps & MMC_CAP_HW_RESET) || !host->ops->hw_reset)
 		return;
diff --git a/drivers/mmc/core/host.c b/drivers/mmc/core/host.c
index d4683b1d263f..aa5326db7c60 100644
--- a/drivers/mmc/core/host.c
+++ b/drivers/mmc/core/host.c
@@ -28,7 +28,6 @@
 #include "crypto.h"
 #include "host.h"
 #include "slot-gpio.h"
-#include "pwrseq.h"
 #include "sdio_ops.h"
 
 #define cls_dev_to_mmc_host(d)	container_of(d, struct mmc_host, class_dev)
@@ -422,7 +421,11 @@ int mmc_of_parse(struct mmc_host *host)
 	device_property_read_u32(dev, "post-power-on-delay-ms",
 				 &host->ios.power_delay_ms);
 
-	return mmc_pwrseq_alloc(host);
+	host->pwrseq = devm_pwrseq_get(dev, "mmc");
+	if (IS_ERR(host->pwrseq))
+		return PTR_ERR(host->pwrseq);
+
+	return 0;
 }
 
 EXPORT_SYMBOL(mmc_of_parse);
@@ -641,7 +644,6 @@ EXPORT_SYMBOL(mmc_remove_host);
  */
 void mmc_free_host(struct mmc_host *host)
 {
-	mmc_pwrseq_free(host);
 	put_device(&host->class_dev);
 }
 
diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
index 29e58ffae379..d7e1c083fa12 100644
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -24,7 +24,6 @@
 #include "mmc_ops.h"
 #include "quirks.h"
 #include "sd_ops.h"
-#include "pwrseq.h"
 
 #define DEFAULT_CMD6_TIMEOUT_MS	500
 #define MIN_CACHE_EN_TIMEOUT_MS 1600
@@ -2222,7 +2221,7 @@ static int _mmc_hw_reset(struct mmc_host *host)
 	} else {
 		/* Do a brute force power cycle */
 		mmc_power_cycle(host, card->ocr);
-		mmc_pwrseq_reset(host);
+		pwrseq_reset(host->pwrseq);
 	}
 	return mmc_init_card(host, card->ocr, card);
 }
diff --git a/drivers/mmc/core/pwrseq.c b/drivers/mmc/core/pwrseq.c
deleted file mode 100644
index ef675f364bf0..000000000000
--- a/drivers/mmc/core/pwrseq.c
+++ /dev/null
@@ -1,117 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- *  Copyright (C) 2014 Linaro Ltd
- *
- * Author: Ulf Hansson <ulf.hansson@linaro.org>
- *
- *  MMC power sequence management
- */
-#include <linux/kernel.h>
-#include <linux/err.h>
-#include <linux/module.h>
-#include <linux/of.h>
-
-#include <linux/mmc/host.h>
-
-#include "pwrseq.h"
-
-static DEFINE_MUTEX(pwrseq_list_mutex);
-static LIST_HEAD(pwrseq_list);
-
-int mmc_pwrseq_alloc(struct mmc_host *host)
-{
-	struct device_node *np;
-	struct mmc_pwrseq *p;
-
-	np = of_parse_phandle(host->parent->of_node, "mmc-pwrseq", 0);
-	if (!np)
-		return 0;
-
-	mutex_lock(&pwrseq_list_mutex);
-	list_for_each_entry(p, &pwrseq_list, pwrseq_node) {
-		if (p->dev->of_node == np) {
-			if (!try_module_get(p->owner))
-				dev_err(host->parent,
-					"increasing module refcount failed\n");
-			else
-				host->pwrseq = p;
-
-			break;
-		}
-	}
-
-	of_node_put(np);
-	mutex_unlock(&pwrseq_list_mutex);
-
-	if (!host->pwrseq)
-		return -EPROBE_DEFER;
-
-	dev_info(host->parent, "allocated mmc-pwrseq\n");
-
-	return 0;
-}
-
-void mmc_pwrseq_pre_power_on(struct mmc_host *host)
-{
-	struct mmc_pwrseq *pwrseq = host->pwrseq;
-
-	if (pwrseq && pwrseq->ops->pre_power_on)
-		pwrseq->ops->pre_power_on(host);
-}
-
-void mmc_pwrseq_post_power_on(struct mmc_host *host)
-{
-	struct mmc_pwrseq *pwrseq = host->pwrseq;
-
-	if (pwrseq && pwrseq->ops->post_power_on)
-		pwrseq->ops->post_power_on(host);
-}
-
-void mmc_pwrseq_power_off(struct mmc_host *host)
-{
-	struct mmc_pwrseq *pwrseq = host->pwrseq;
-
-	if (pwrseq && pwrseq->ops->power_off)
-		pwrseq->ops->power_off(host);
-}
-
-void mmc_pwrseq_reset(struct mmc_host *host)
-{
-	struct mmc_pwrseq *pwrseq = host->pwrseq;
-
-	if (pwrseq && pwrseq->ops->reset)
-		pwrseq->ops->reset(host);
-}
-
-void mmc_pwrseq_free(struct mmc_host *host)
-{
-	struct mmc_pwrseq *pwrseq = host->pwrseq;
-
-	if (pwrseq) {
-		module_put(pwrseq->owner);
-		host->pwrseq = NULL;
-	}
-}
-
-int mmc_pwrseq_register(struct mmc_pwrseq *pwrseq)
-{
-	if (!pwrseq || !pwrseq->ops || !pwrseq->dev)
-		return -EINVAL;
-
-	mutex_lock(&pwrseq_list_mutex);
-	list_add(&pwrseq->pwrseq_node, &pwrseq_list);
-	mutex_unlock(&pwrseq_list_mutex);
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(mmc_pwrseq_register);
-
-void mmc_pwrseq_unregister(struct mmc_pwrseq *pwrseq)
-{
-	if (pwrseq) {
-		mutex_lock(&pwrseq_list_mutex);
-		list_del(&pwrseq->pwrseq_node);
-		mutex_unlock(&pwrseq_list_mutex);
-	}
-}
-EXPORT_SYMBOL_GPL(mmc_pwrseq_unregister);
diff --git a/drivers/mmc/core/pwrseq.h b/drivers/mmc/core/pwrseq.h
deleted file mode 100644
index f3bb103db9ad..000000000000
--- a/drivers/mmc/core/pwrseq.h
+++ /dev/null
@@ -1,58 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-/*
- * Copyright (C) 2014 Linaro Ltd
- *
- * Author: Ulf Hansson <ulf.hansson@linaro.org>
- */
-#ifndef _MMC_CORE_PWRSEQ_H
-#define _MMC_CORE_PWRSEQ_H
-
-#include <linux/types.h>
-
-struct mmc_host;
-struct device;
-struct module;
-
-struct mmc_pwrseq_ops {
-	void (*pre_power_on)(struct mmc_host *host);
-	void (*post_power_on)(struct mmc_host *host);
-	void (*power_off)(struct mmc_host *host);
-	void (*reset)(struct mmc_host *host);
-};
-
-struct mmc_pwrseq {
-	const struct mmc_pwrseq_ops *ops;
-	struct device *dev;
-	struct list_head pwrseq_node;
-	struct module *owner;
-};
-
-#ifdef CONFIG_OF
-
-int mmc_pwrseq_register(struct mmc_pwrseq *pwrseq);
-void mmc_pwrseq_unregister(struct mmc_pwrseq *pwrseq);
-
-int mmc_pwrseq_alloc(struct mmc_host *host);
-void mmc_pwrseq_pre_power_on(struct mmc_host *host);
-void mmc_pwrseq_post_power_on(struct mmc_host *host);
-void mmc_pwrseq_power_off(struct mmc_host *host);
-void mmc_pwrseq_reset(struct mmc_host *host);
-void mmc_pwrseq_free(struct mmc_host *host);
-
-#else
-
-static inline int mmc_pwrseq_register(struct mmc_pwrseq *pwrseq)
-{
-	return -ENOSYS;
-}
-static inline void mmc_pwrseq_unregister(struct mmc_pwrseq *pwrseq) {}
-static inline int mmc_pwrseq_alloc(struct mmc_host *host) { return 0; }
-static inline void mmc_pwrseq_pre_power_on(struct mmc_host *host) {}
-static inline void mmc_pwrseq_post_power_on(struct mmc_host *host) {}
-static inline void mmc_pwrseq_power_off(struct mmc_host *host) {}
-static inline void mmc_pwrseq_reset(struct mmc_host *host) {}
-static inline void mmc_pwrseq_free(struct mmc_host *host) {}
-
-#endif
-
-#endif
diff --git a/drivers/power/pwrseq/core.c b/drivers/power/pwrseq/core.c
index d29b4b97b95c..0aaba4e79a44 100644
--- a/drivers/power/pwrseq/core.c
+++ b/drivers/power/pwrseq/core.c
@@ -68,6 +68,14 @@ static struct pwrseq *_of_pwrseq_get(struct device *dev, const char *id)
 
 	snprintf(prop_name, sizeof(prop_name), "%s-pwrseq", id);
 	ret = of_parse_phandle_with_args(dev->of_node, prop_name, "#pwrseq-cells", 0, &args);
+
+	/*
+	 * Parsing failed. Try locating old bindings for mmc-pwrseq, which did
+	 * not use #pwrseq-cells.
+	 */
+	if (ret == -EINVAL && !strcmp(id, "mmc"))
+		ret = of_parse_phandle_with_args(dev->of_node, prop_name, NULL, 0, &args);
+
 	if (ret == -ENOENT)
 		return NULL;
 	else if (ret < 0)
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index 0c0c9a0fdf57..f5daee6c1d7b 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -16,6 +16,7 @@
 #include <linux/mmc/pm.h>
 #include <linux/dma-direction.h>
 #include <linux/keyslot-manager.h>
+#include <linux/pwrseq/consumer.h>
 
 struct mmc_ios {
 	unsigned int	clock;			/* clock rate */
@@ -278,7 +279,6 @@ struct mmc_context_info {
 };
 
 struct regulator;
-struct mmc_pwrseq;
 
 struct mmc_supply {
 	struct regulator *vmmc;		/* Card power supply */
@@ -294,7 +294,7 @@ struct mmc_host {
 	struct device		class_dev;
 	int			index;
 	const struct mmc_host_ops *ops;
-	struct mmc_pwrseq	*pwrseq;
+	struct pwrseq		*pwrseq;
 	unsigned int		f_min;
 	unsigned int		f_max;
 	unsigned int		f_init;
-- 
2.33.0

