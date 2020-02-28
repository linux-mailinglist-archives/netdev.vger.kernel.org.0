Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2E217426B
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 23:45:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbgB1Wn5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 17:43:57 -0500
Received: from mail-yw1-f68.google.com ([209.85.161.68]:46481 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726992AbgB1WmW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 17:42:22 -0500
Received: by mail-yw1-f68.google.com with SMTP id n1so4406521ywe.13
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 14:42:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dy6rQ4eMObqJkHXDR4c+2Co/ufIH9Vkxn2UrqymA1DE=;
        b=oeEG5s49ighQkbOVmxlHVSaJOP3puRx4Om3NXCgbGYBEWLxTRXxjEvzgoGIzQ1bPlU
         JMNRxbxYcx0541MyL5Jx8/574xFROX7m8dJ1IcddRR7YDKeZAv94OHKcfuQ3/Lm1tTLg
         7PV1BNeBdYspnp/2rrY7+vEvvbosZhFAikFyzxE6x33pOA3JUdCV8/WHuNXceshVozDx
         6aBlbJhY5zkK+2gS4YTfuiOhX7W0bZkSlC+aGBZ096RxheJ6Xusb3mmKhn4SG93jPVVp
         GBErlpapL8NXngpU2aq7jbO2M7nTxs7Ln1+dKKI97+hN0haHY3ctCYe6oSsViW/qyIkn
         pD4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dy6rQ4eMObqJkHXDR4c+2Co/ufIH9Vkxn2UrqymA1DE=;
        b=ajES+evSy8cOxieDmHaRmm5lfr/I6k1axnppyFxQaDUvnJnoJ8qr2fJ9smhe0sPio1
         /KHbUR5Fj29WrHLbxqyv6eLpuchu4wAa1GZ6LqG6Abz4kJMJmupBq4nBCm7Z8dXQ0zAz
         Wf+V6Q7whBSt75iZ3d3pcfzmwxYsTk/3TYvRJE165a6S0o16iG8oSMSENOem7uE+2YFt
         Pqe9buJe6F2k9MsI2F5Ic1YeQZdkkXktA1Ju7H+zCOJV642hUum06Y8rGGtb4czeDTbz
         3aToPFwz6e65DFo7D7Eqh2qjE2QSgwYKVP2At7t1u7BFy+u82jFIUoHlrSjwlUAAY1t8
         FhBg==
X-Gm-Message-State: APjAAAULWPCduBG3EvSLIV1hxccGDFUEajzek2WVfBJXDqO4KrFdUphE
        dxMKOIh3OP/Wd22Lwca+JUoZiA==
X-Google-Smtp-Source: APXvYqxY4dMbBw5dk+AKermRHzX5ZAHb4drnCIZ+Vk2yT4rc10jOenkx14/qy2SIAtrOs8FL/5KxXg==
X-Received: by 2002:a5b:54b:: with SMTP id r11mr5992335ybp.17.1582929740245;
        Fri, 28 Feb 2020 14:42:20 -0800 (PST)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id d188sm4637830ywe.50.2020.02.28.14.42.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2020 14:42:19 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     Arnd Bergmann <arnd@arndb.de>, David Miller <davem@davemloft.net>
Cc:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Dan Williams <dcbw@redhat.com>,
        Evan Green <evgreen@google.com>,
        Eric Caruso <ejcaruso@google.com>,
        Susheel Yadav Yadagiri <syadagir@codeaurora.org>,
        Chaitanya Pratapa <cpratapa@codeaurora.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Siddharth Gupta <sidgup@codeaurora.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 05/17] soc: qcom: ipa: clocking, interrupts, and memory
Date:   Fri, 28 Feb 2020 16:41:52 -0600
Message-Id: <20200228224204.17746-6-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200228224204.17746-1-elder@linaro.org>
References: <20200228224204.17746-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch incorporates three source files (and their headers).  They're
grouped into one patch mainly for the purpose of making the number and
size of patches in this series somewhat reasonable.

  - "ipa_clock.c" and "ipa_clock.h" implement clocking for the IPA device.
    The IPA has a single core clock managed by the common clock framework.
    In addition, the IPA has three buses whose bandwidth is managed by the
    Linux interconnect framework.  At this time the core clock and all
    three buses are either on or off; we don't yet do any more fine-grained
    management than that.  The core clock and interconnects are enabled
    and disabled as a unit, using a unified clock-like abstraction,
    ipa_clock_get()/ipa_clock_put().

  - "ipa_interrupt.c" and "ipa_interrupt.h" implement IPA interrupts.
    There are two hardware IRQs used by the IPA driver (the other is
    the GSI interrupt, described in a separate patch).  Several types
    of interrupt are handled by the IPA IRQ handler; these are not part
    of data/fast path.

  - The IPA has a region of local memory that is accessible by the AP
    (and modem).  Within that region are areas with certain defined
    purposes.  "ipa_mem.c" and "ipa_mem.h" define those regions, and
    implement their initialization.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_clock.c     | 313 +++++++++++++++++++++++++++++++
 drivers/net/ipa/ipa_clock.h     |  53 ++++++
 drivers/net/ipa/ipa_interrupt.c | 253 +++++++++++++++++++++++++
 drivers/net/ipa/ipa_interrupt.h | 117 ++++++++++++
 drivers/net/ipa/ipa_mem.c       | 314 ++++++++++++++++++++++++++++++++
 drivers/net/ipa/ipa_mem.h       |  90 +++++++++
 6 files changed, 1140 insertions(+)
 create mode 100644 drivers/net/ipa/ipa_clock.c
 create mode 100644 drivers/net/ipa/ipa_clock.h
 create mode 100644 drivers/net/ipa/ipa_interrupt.c
 create mode 100644 drivers/net/ipa/ipa_interrupt.h
 create mode 100644 drivers/net/ipa/ipa_mem.c
 create mode 100644 drivers/net/ipa/ipa_mem.h

diff --git a/drivers/net/ipa/ipa_clock.c b/drivers/net/ipa/ipa_clock.c
new file mode 100644
index 000000000000..a60ffb801285
--- /dev/null
+++ b/drivers/net/ipa/ipa_clock.c
@@ -0,0 +1,313 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
+ * Copyright (C) 2018-2020 Linaro Ltd.
+ */
+
+#include <linux/atomic.h>
+#include <linux/mutex.h>
+#include <linux/clk.h>
+#include <linux/device.h>
+#include <linux/interconnect.h>
+
+#include "ipa.h"
+#include "ipa_clock.h"
+#include "ipa_modem.h"
+
+/**
+ * DOC: IPA Clocking
+ *
+ * The "IPA Clock" manages both the IPA core clock and the interconnects
+ * (buses) the IPA depends on as a single logical entity.  A reference count
+ * is incremented by "get" operations and decremented by "put" operations.
+ * Transitions of that count from 0 to 1 result in the clock and interconnects
+ * being enabled, and transitions of the count from 1 to 0 cause them to be
+ * disabled.  We currently operate the core clock at a fixed clock rate, and
+ * all buses at a fixed average and peak bandwidth.  As more advanced IPA
+ * features are enabled, we can make better use of clock and bus scaling.
+ *
+ * An IPA clock reference must be held for any access to IPA hardware.
+ */
+
+#define	IPA_CORE_CLOCK_RATE		(75UL * 1000 * 1000)	/* Hz */
+
+/* Interconnect path bandwidths (each times 1000 bytes per second) */
+#define IPA_MEMORY_AVG			(80 * 1000)	/* 80 MBps */
+#define IPA_MEMORY_PEAK			(600 * 1000)
+
+#define IPA_IMEM_AVG			(80 * 1000)
+#define IPA_IMEM_PEAK			(350 * 1000)
+
+#define IPA_CONFIG_AVG			(40 * 1000)
+#define IPA_CONFIG_PEAK			(40 * 1000)
+
+/**
+ * struct ipa_clock - IPA clocking information
+ * @count:		Clocking reference count
+ * @mutex;		Protects clock enable/disable
+ * @core:		IPA core clock
+ * @memory_path:	Memory interconnect
+ * @imem_path:		Internal memory interconnect
+ * @config_path:	Configuration space interconnect
+ */
+struct ipa_clock {
+	atomic_t count;
+	struct mutex mutex; /* protects clock enable/disable */
+	struct clk *core;
+	struct icc_path *memory_path;
+	struct icc_path *imem_path;
+	struct icc_path *config_path;
+};
+
+static struct icc_path *
+ipa_interconnect_init_one(struct device *dev, const char *name)
+{
+	struct icc_path *path;
+
+	path = of_icc_get(dev, name);
+	if (IS_ERR(path))
+		dev_err(dev, "error %d getting memory interconnect\n",
+			PTR_ERR(path));
+
+	return path;
+}
+
+/* Initialize interconnects required for IPA operation */
+static int ipa_interconnect_init(struct ipa_clock *clock, struct device *dev)
+{
+	struct icc_path *path;
+
+	path = ipa_interconnect_init_one(dev, "memory");
+	if (IS_ERR(path))
+		goto err_return;
+	clock->memory_path = path;
+
+	path = ipa_interconnect_init_one(dev, "imem");
+	if (IS_ERR(path))
+		goto err_memory_path_put;
+	clock->imem_path = path;
+
+	path = ipa_interconnect_init_one(dev, "config");
+	if (IS_ERR(path))
+		goto err_imem_path_put;
+	clock->config_path = path;
+
+	return 0;
+
+err_imem_path_put:
+	icc_put(clock->imem_path);
+err_memory_path_put:
+	icc_put(clock->memory_path);
+err_return:
+	return PTR_ERR(path);
+}
+
+/* Inverse of ipa_interconnect_init() */
+static void ipa_interconnect_exit(struct ipa_clock *clock)
+{
+	icc_put(clock->config_path);
+	icc_put(clock->imem_path);
+	icc_put(clock->memory_path);
+}
+
+/* Currently we only use one bandwidth level, so just "enable" interconnects */
+static int ipa_interconnect_enable(struct ipa *ipa)
+{
+	struct ipa_clock *clock = ipa->clock;
+	int ret;
+
+	ret = icc_set_bw(clock->memory_path, IPA_MEMORY_AVG, IPA_MEMORY_PEAK);
+	if (ret)
+		return ret;
+
+	ret = icc_set_bw(clock->imem_path, IPA_IMEM_AVG, IPA_IMEM_PEAK);
+	if (ret)
+		goto err_memory_path_disable;
+
+	ret = icc_set_bw(clock->config_path, IPA_CONFIG_AVG, IPA_CONFIG_PEAK);
+	if (ret)
+		goto err_imem_path_disable;
+
+	return 0;
+
+err_imem_path_disable:
+	(void)icc_set_bw(clock->imem_path, 0, 0);
+err_memory_path_disable:
+	(void)icc_set_bw(clock->memory_path, 0, 0);
+
+	return ret;
+}
+
+/* To disable an interconnect, we just its bandwidth to 0 */
+static int ipa_interconnect_disable(struct ipa *ipa)
+{
+	struct ipa_clock *clock = ipa->clock;
+	int ret;
+
+	ret = icc_set_bw(clock->memory_path, 0, 0);
+	if (ret)
+		return ret;
+
+	ret = icc_set_bw(clock->imem_path, 0, 0);
+	if (ret)
+		goto err_memory_path_reenable;
+
+	ret = icc_set_bw(clock->config_path, 0, 0);
+	if (ret)
+		goto err_imem_path_reenable;
+
+	return 0;
+
+err_imem_path_reenable:
+	(void)icc_set_bw(clock->imem_path, IPA_IMEM_AVG, IPA_IMEM_PEAK);
+err_memory_path_reenable:
+	(void)icc_set_bw(clock->memory_path, IPA_MEMORY_AVG, IPA_MEMORY_PEAK);
+
+	return ret;
+}
+
+/* Turn on IPA clocks, including interconnects */
+static int ipa_clock_enable(struct ipa *ipa)
+{
+	int ret;
+
+	ret = ipa_interconnect_enable(ipa);
+	if (ret)
+		return ret;
+
+	ret = clk_prepare_enable(ipa->clock->core);
+	if (ret)
+		ipa_interconnect_disable(ipa);
+
+	return ret;
+}
+
+/* Inverse of ipa_clock_enable() */
+static void ipa_clock_disable(struct ipa *ipa)
+{
+	clk_disable_unprepare(ipa->clock->core);
+	(void)ipa_interconnect_disable(ipa);
+}
+
+/* Get an IPA clock reference, but only if the reference count is
+ * already non-zero.  Returns true if the additional reference was
+ * added successfully, or false otherwise.
+ */
+bool ipa_clock_get_additional(struct ipa *ipa)
+{
+	return !!atomic_inc_not_zero(&ipa->clock->count);
+}
+
+/* Get an IPA clock reference.  If the reference count is non-zero, it is
+ * incremented and return is immediate.  Otherwise it is checked again
+ * under protection of the mutex, and if appropriate the clock (and
+ * interconnects) are enabled suspended endpoints (if any) are resumed
+ * before returning.
+ *
+ * Incrementing the reference count is intentionally deferred until
+ * after the clock is running and endpoints are resumed.
+ */
+void ipa_clock_get(struct ipa *ipa)
+{
+	struct ipa_clock *clock = ipa->clock;
+	int ret;
+
+	/* If the clock is running, just bump the reference count */
+	if (ipa_clock_get_additional(ipa))
+		return;
+
+	/* Otherwise get the mutex and check again */
+	mutex_lock(&clock->mutex);
+
+	/* A reference might have been added before we got the mutex. */
+	if (ipa_clock_get_additional(ipa))
+		goto out_mutex_unlock;
+
+	ret = ipa_clock_enable(ipa);
+	if (ret) {
+		dev_err(&ipa->pdev->dev, "error %d enabling IPA clock\n", ret);
+		goto out_mutex_unlock;
+	}
+
+	ipa_endpoint_resume(ipa);
+
+	atomic_inc(&clock->count);
+
+out_mutex_unlock:
+	mutex_unlock(&clock->mutex);
+}
+
+/* Attempt to remove an IPA clock reference.  If this represents the last
+ * reference, suspend endpoints and disable the clock (and interconnects)
+ * under protection of a mutex.
+ */
+void ipa_clock_put(struct ipa *ipa)
+{
+	struct ipa_clock *clock = ipa->clock;
+
+	/* If this is not the last reference there's nothing more to do */
+	if (!atomic_dec_and_mutex_lock(&clock->count, &clock->mutex))
+		return;
+
+	ipa_endpoint_suspend(ipa);
+
+	ipa_clock_disable(ipa);
+
+	mutex_unlock(&clock->mutex);
+}
+
+/* Initialize IPA clocking */
+struct ipa_clock *ipa_clock_init(struct device *dev)
+{
+	struct ipa_clock *clock;
+	struct clk *clk;
+	int ret;
+
+	clk = clk_get(dev, "core");
+	if (IS_ERR(clk)) {
+		dev_err(dev, "error %d getting core clock\n", PTR_ERR(clk));
+		return ERR_CAST(clk);
+	}
+
+	ret = clk_set_rate(clk, IPA_CORE_CLOCK_RATE);
+	if (ret) {
+		dev_err(dev, "error setting core clock rate to %u\n",
+			ret, IPA_CORE_CLOCK_RATE);
+		goto err_clk_put;
+	}
+
+	clock = kzalloc(sizeof(*clock), GFP_KERNEL);
+	if (!clock) {
+		ret = -ENOMEM;
+		goto err_clk_put;
+	}
+	clock->core = clk;
+
+	ret = ipa_interconnect_init(clock, dev);
+	if (ret)
+		goto err_kfree;
+
+	mutex_init(&clock->mutex);
+	atomic_set(&clock->count, 0);
+
+	return clock;
+
+err_kfree:
+	kfree(clock);
+err_clk_put:
+	clk_put(clk);
+
+	return ERR_PTR(ret);
+}
+
+/* Inverse of ipa_clock_init() */
+void ipa_clock_exit(struct ipa_clock *clock)
+{
+	struct clk *clk = clock->core;
+
+	WARN_ON(atomic_read(&clock->count) != 0);
+	mutex_destroy(&clock->mutex);
+	ipa_interconnect_exit(clock);
+	kfree(clock);
+	clk_put(clk);
+}
diff --git a/drivers/net/ipa/ipa_clock.h b/drivers/net/ipa/ipa_clock.h
new file mode 100644
index 000000000000..bc52b35e6bb2
--- /dev/null
+++ b/drivers/net/ipa/ipa_clock.h
@@ -0,0 +1,53 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
+ * Copyright (C) 2018-2020 Linaro Ltd.
+ */
+#ifndef _IPA_CLOCK_H_
+#define _IPA_CLOCK_H_
+
+struct device;
+
+struct ipa;
+
+/**
+ * ipa_clock_init() - Initialize IPA clocking
+ * @dev:	IPA device
+ *
+ * @Return:	A pointer to an ipa_clock structure, or a pointer-coded error
+ */
+struct ipa_clock *ipa_clock_init(struct device *dev);
+
+/**
+ * ipa_clock_exit() - Inverse of ipa_clock_init()
+ * @clock:	IPA clock pointer
+ */
+void ipa_clock_exit(struct ipa_clock *clock);
+
+/**
+ * ipa_clock_get() - Get an IPA clock reference
+ * @ipa:	IPA pointer
+ *
+ * This call blocks if this is the first reference.
+ */
+void ipa_clock_get(struct ipa *ipa);
+
+/**
+ * ipa_clock_get_additional() - Get an IPA clock reference if not first
+ * @ipa:	IPA pointer
+ *
+ * This returns immediately, and only takes a reference if not the first
+ */
+bool ipa_clock_get_additional(struct ipa *ipa);
+
+/**
+ * ipa_clock_put() - Drop an IPA clock reference
+ * @ipa:	IPA pointer
+ *
+ * This drops a clock reference.  If the last reference is being dropped,
+ * the clock is stopped and RX endpoints are suspended.  This call will
+ * not block unless the last reference is dropped.
+ */
+void ipa_clock_put(struct ipa *ipa);
+
+#endif /* _IPA_CLOCK_H_ */
diff --git a/drivers/net/ipa/ipa_interrupt.c b/drivers/net/ipa/ipa_interrupt.c
new file mode 100644
index 000000000000..90353987c45f
--- /dev/null
+++ b/drivers/net/ipa/ipa_interrupt.c
@@ -0,0 +1,253 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/* Copyright (c) 2014-2018, The Linux Foundation. All rights reserved.
+ * Copyright (C) 2018-2020 Linaro Ltd.
+ */
+
+/* DOC: IPA Interrupts
+ *
+ * The IPA has an interrupt line distinct from the interrupt used by the GSI
+ * code.  Whereas GSI interrupts are generally related to channel events (like
+ * transfer completions), IPA interrupts are related to other events related
+ * to the IPA.  Some of the IPA interrupts come from a microcontroller
+ * embedded in the IPA.  Each IPA interrupt type can be both masked and
+ * acknowledged independent of the others.
+ *
+ * Two of the IPA interrupts are initiated by the microcontroller.  A third
+ * can be generated to signal the need for a wakeup/resume when an IPA
+ * endpoint has been suspended.  There are other IPA events, but at this
+ * time only these three are supported.
+ */
+
+#include <linux/types.h>
+#include <linux/interrupt.h>
+
+#include "ipa.h"
+#include "ipa_clock.h"
+#include "ipa_reg.h"
+#include "ipa_endpoint.h"
+#include "ipa_interrupt.h"
+
+/**
+ * struct ipa_interrupt - IPA interrupt information
+ * @ipa:		IPA pointer
+ * @irq:		Linux IRQ number used for IPA interrupts
+ * @enabled:		Mask indicating which interrupts are enabled
+ * @handler:		Array of handlers indexed by IPA interrupt ID
+ */
+struct ipa_interrupt {
+	struct ipa *ipa;
+	u32 irq;
+	u32 enabled;
+	ipa_irq_handler_t handler[IPA_IRQ_COUNT];
+};
+
+/* Returns true if the interrupt type is associated with the microcontroller */
+static bool ipa_interrupt_uc(struct ipa_interrupt *interrupt, u32 irq_id)
+{
+	return irq_id == IPA_IRQ_UC_0 || irq_id == IPA_IRQ_UC_1;
+}
+
+/* Process a particular interrupt type that has been received */
+static void ipa_interrupt_process(struct ipa_interrupt *interrupt, u32 irq_id)
+{
+	bool uc_irq = ipa_interrupt_uc(interrupt, irq_id);
+	struct ipa *ipa = interrupt->ipa;
+	u32 mask = BIT(irq_id);
+
+	/* For microcontroller interrupts, clear the interrupt right away,
+	 * "to avoid clearing unhandled interrupts."
+	 */
+	if (uc_irq)
+		iowrite32(mask, ipa->reg_virt + IPA_REG_IRQ_CLR_OFFSET);
+
+	if (irq_id < IPA_IRQ_COUNT && interrupt->handler[irq_id])
+		interrupt->handler[irq_id](interrupt->ipa, irq_id);
+
+	/* Clearing the SUSPEND_TX interrupt also clears the register
+	 * that tells us which suspended endpoint(s) caused the interrupt,
+	 * so defer clearing until after the handler has been called.
+	 */
+	if (!uc_irq)
+		iowrite32(mask, ipa->reg_virt + IPA_REG_IRQ_CLR_OFFSET);
+}
+
+/* Process all IPA interrupt types that have been signaled */
+static void ipa_interrupt_process_all(struct ipa_interrupt *interrupt)
+{
+	struct ipa *ipa = interrupt->ipa;
+	u32 enabled = interrupt->enabled;
+	u32 mask;
+
+	/* The status register indicates which conditions are present,
+	 * including conditions whose interrupt is not enabled.  Handle
+	 * only the enabled ones.
+	 */
+	mask = ioread32(ipa->reg_virt + IPA_REG_IRQ_STTS_OFFSET);
+	while ((mask &= enabled)) {
+		do {
+			u32 irq_id = __ffs(mask);
+
+			mask ^= BIT(irq_id);
+
+			ipa_interrupt_process(interrupt, irq_id);
+		} while (mask);
+		mask = ioread32(ipa->reg_virt + IPA_REG_IRQ_STTS_OFFSET);
+	}
+}
+
+/* Threaded part of the IPA IRQ handler */
+static irqreturn_t ipa_isr_thread(int irq, void *dev_id)
+{
+	struct ipa_interrupt *interrupt = dev_id;
+
+	ipa_clock_get(interrupt->ipa);
+
+	ipa_interrupt_process_all(interrupt);
+
+	ipa_clock_put(interrupt->ipa);
+
+	return IRQ_HANDLED;
+}
+
+/* Hard part (i.e., "real" IRQ handler) of the IRQ handler */
+static irqreturn_t ipa_isr(int irq, void *dev_id)
+{
+	struct ipa_interrupt *interrupt = dev_id;
+	struct ipa *ipa = interrupt->ipa;
+	u32 mask;
+
+	mask = ioread32(ipa->reg_virt + IPA_REG_IRQ_STTS_OFFSET);
+	if (mask & interrupt->enabled)
+		return IRQ_WAKE_THREAD;
+
+	/* Nothing in the mask was supposed to cause an interrupt */
+	iowrite32(mask, ipa->reg_virt + IPA_REG_IRQ_CLR_OFFSET);
+
+	dev_err(&ipa->pdev->dev, "%s: unexpected interrupt, mask 0x%08x\n",
+		__func__, mask);
+
+	return IRQ_HANDLED;
+}
+
+/* Common function used to enable/disable TX_SUSPEND for an endpoint */
+static void ipa_interrupt_suspend_control(struct ipa_interrupt *interrupt,
+					  u32 endpoint_id, bool enable)
+{
+	struct ipa *ipa = interrupt->ipa;
+	u32 mask = BIT(endpoint_id);
+	u32 val;
+
+	/* assert(mask & ipa->available); */
+	val = ioread32(ipa->reg_virt + IPA_REG_SUSPEND_IRQ_EN_OFFSET);
+	if (enable)
+		val |= mask;
+	else
+		val &= ~mask;
+	iowrite32(val, ipa->reg_virt + IPA_REG_SUSPEND_IRQ_EN_OFFSET);
+}
+
+/* Enable TX_SUSPEND for an endpoint */
+void
+ipa_interrupt_suspend_enable(struct ipa_interrupt *interrupt, u32 endpoint_id)
+{
+	ipa_interrupt_suspend_control(interrupt, endpoint_id, true);
+}
+
+/* Disable TX_SUSPEND for an endpoint */
+void
+ipa_interrupt_suspend_disable(struct ipa_interrupt *interrupt, u32 endpoint_id)
+{
+	ipa_interrupt_suspend_control(interrupt, endpoint_id, false);
+}
+
+/* Clear the suspend interrupt for all endpoints that signaled it */
+void ipa_interrupt_suspend_clear_all(struct ipa_interrupt *interrupt)
+{
+	struct ipa *ipa = interrupt->ipa;
+	u32 val;
+
+	val = ioread32(ipa->reg_virt + IPA_REG_IRQ_SUSPEND_INFO_OFFSET);
+	iowrite32(val, ipa->reg_virt + IPA_REG_SUSPEND_IRQ_CLR_OFFSET);
+}
+
+/* Simulate arrival of an IPA TX_SUSPEND interrupt */
+void ipa_interrupt_simulate_suspend(struct ipa_interrupt *interrupt)
+{
+	ipa_interrupt_process(interrupt, IPA_IRQ_TX_SUSPEND);
+}
+
+/* Add a handler for an IPA interrupt */
+void ipa_interrupt_add(struct ipa_interrupt *interrupt,
+		       enum ipa_irq_id ipa_irq, ipa_irq_handler_t handler)
+{
+	struct ipa *ipa = interrupt->ipa;
+
+	/* assert(ipa_irq < IPA_IRQ_COUNT); */
+	interrupt->handler[ipa_irq] = handler;
+
+	/* Update the IPA interrupt mask to enable it */
+	interrupt->enabled |= BIT(ipa_irq);
+	iowrite32(interrupt->enabled, ipa->reg_virt + IPA_REG_IRQ_EN_OFFSET);
+}
+
+/* Remove the handler for an IPA interrupt type */
+void
+ipa_interrupt_remove(struct ipa_interrupt *interrupt, enum ipa_irq_id ipa_irq)
+{
+	struct ipa *ipa = interrupt->ipa;
+
+	/* assert(ipa_irq < IPA_IRQ_COUNT); */
+	/* Update the IPA interrupt mask to disable it */
+	interrupt->enabled &= ~BIT(ipa_irq);
+	iowrite32(interrupt->enabled, ipa->reg_virt + IPA_REG_IRQ_EN_OFFSET);
+
+	interrupt->handler[ipa_irq] = NULL;
+}
+
+/* Set up the IPA interrupt framework */
+struct ipa_interrupt *ipa_interrupt_setup(struct ipa *ipa)
+{
+	struct device *dev = &ipa->pdev->dev;
+	struct ipa_interrupt *interrupt;
+	unsigned int irq;
+	int ret;
+
+	ret = platform_get_irq_byname(ipa->pdev, "ipa");
+	if (ret <= 0) {
+		dev_err(dev, "DT error %d getting \"ipa\" IRQ property\n",
+			ret);
+		return ERR_PTR(ret ? : -EINVAL);
+	}
+	irq = ret;
+
+	interrupt = kzalloc(sizeof(*interrupt), GFP_KERNEL);
+	if (!interrupt)
+		return ERR_PTR(-ENOMEM);
+	interrupt->ipa = ipa;
+	interrupt->irq = irq;
+
+	/* Start with all IPA interrupts disabled */
+	iowrite32(0, ipa->reg_virt + IPA_REG_IRQ_EN_OFFSET);
+
+	ret = request_threaded_irq(irq, ipa_isr, ipa_isr_thread, IRQF_ONESHOT,
+				   "ipa", interrupt);
+	if (ret) {
+		dev_err(dev, "error %d requesting \"ipa\" IRQ\n", ret);
+		goto err_kfree;
+	}
+
+	return interrupt;
+
+err_kfree:
+	kfree(interrupt);
+
+	return ERR_PTR(ret);
+}
+
+/* Tear down the IPA interrupt framework */
+void ipa_interrupt_teardown(struct ipa_interrupt *interrupt)
+{
+	free_irq(interrupt->irq, interrupt);
+	kfree(interrupt);
+}
diff --git a/drivers/net/ipa/ipa_interrupt.h b/drivers/net/ipa/ipa_interrupt.h
new file mode 100644
index 000000000000..d4f4c1c9f0b1
--- /dev/null
+++ b/drivers/net/ipa/ipa_interrupt.h
@@ -0,0 +1,117 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
+ * Copyright (C) 2018-2020 Linaro Ltd.
+ */
+#ifndef _IPA_INTERRUPT_H_
+#define _IPA_INTERRUPT_H_
+
+#include <linux/types.h>
+#include <linux/bits.h>
+
+struct ipa;
+struct ipa_interrupt;
+
+/**
+ * enum ipa_irq_id - IPA interrupt type
+ * @IPA_IRQ_UC_0:	Microcontroller event interrupt
+ * @IPA_IRQ_UC_1:	Microcontroller response interrupt
+ * @IPA_IRQ_TX_SUSPEND:	Data ready interrupt
+ *
+ * The data ready interrupt is signaled if data has arrived that is destined
+ * for an AP RX endpoint whose underlying GSI channel is suspended/stopped.
+ */
+enum ipa_irq_id {
+	IPA_IRQ_UC_0		= 2,
+	IPA_IRQ_UC_1		= 3,
+	IPA_IRQ_TX_SUSPEND	= 14,
+	IPA_IRQ_COUNT,		/* Number of interrupt types (not an index) */
+};
+
+/**
+ * typedef ipa_irq_handler_t - IPA interrupt handler function type
+ * @ipa:	IPA pointer
+ * @irq_id:	interrupt type
+ *
+ * Callback function registered by ipa_interrupt_add() to handle a specific
+ * IPA interrupt type
+ */
+typedef void (*ipa_irq_handler_t)(struct ipa *ipa, enum ipa_irq_id irq_id);
+
+/**
+ * ipa_interrupt_add() - Register a handler for an IPA interrupt type
+ * @irq_id:	IPA interrupt type
+ * @handler:	Handler function for the interrupt
+ *
+ * Add a handler for an IPA interrupt and enable it.  IPA interrupt
+ * handlers are run in threaded interrupt context, so are allowed to
+ * block.
+ */
+void ipa_interrupt_add(struct ipa_interrupt *interrupt, enum ipa_irq_id irq_id,
+		       ipa_irq_handler_t handler);
+
+/**
+ * ipa_interrupt_remove() - Remove the handler for an IPA interrupt type
+ * @interrupt:	IPA interrupt structure
+ * @irq_id:	IPA interrupt type
+ *
+ * Remove an IPA interrupt handler and disable it.
+ */
+void ipa_interrupt_remove(struct ipa_interrupt *interrupt,
+			  enum ipa_irq_id irq_id);
+
+/**
+ * ipa_interrupt_suspend_enable - Enable TX_SUSPEND for an endpoint
+ * @interrupt:		IPA interrupt structure
+ * @endpoint_id:	Endpoint whose interrupt should be enabled
+ *
+ * Note:  The "TX" in the name is from the perspective of the IPA hardware.
+ * A TX_SUSPEND interrupt arrives on an AP RX enpoint when packet data can't
+ * be delivered to the endpoint because it is suspended (or its underlying
+ * channel is stopped).
+ */
+void ipa_interrupt_suspend_enable(struct ipa_interrupt *interrupt,
+				  u32 endpoint_id);
+
+/**
+ * ipa_interrupt_suspend_disable - Disable TX_SUSPEND for an endpoint
+ * @interrupt:		IPA interrupt structure
+ * @endpoint_id:	Endpoint whose interrupt should be disabled
+ */
+void ipa_interrupt_suspend_disable(struct ipa_interrupt *interrupt,
+				   u32 endpoint_id);
+
+/**
+ * ipa_interrupt_suspend_clear_all - clear all suspend interrupts
+ * @interrupt:	IPA interrupt structure
+ *
+ * Clear the TX_SUSPEND interrupt for all endpoints that signaled it.
+ */
+void ipa_interrupt_suspend_clear_all(struct ipa_interrupt *interrupt);
+
+/**
+ * ipa_interrupt_simulate_suspend() - Simulate TX_SUSPEND IPA interrupt
+ * @interrupt:	IPA interrupt structure
+ *
+ * This calls the TX_SUSPEND interrupt handler, as if such an interrupt
+ * had been signaled.  This is needed to work around a hardware quirk
+ * that occurs if aggregation is active on an endpoint when its underlying
+ * channel is suspended.
+ */
+void ipa_interrupt_simulate_suspend(struct ipa_interrupt *interrupt);
+
+/**
+ * ipa_interrupt_setup() - Set up the IPA interrupt framework
+ * @ipa:	IPA pointer
+ *
+ * @Return:	Pointer to IPA SMP2P info, or a pointer-coded error
+ */
+struct ipa_interrupt *ipa_interrupt_setup(struct ipa *ipa);
+
+/**
+ * ipa_interrupt_teardown() - Tear down the IPA interrupt framework
+ * @interrupt:	IPA interrupt structure
+ */
+void ipa_interrupt_teardown(struct ipa_interrupt *interrupt);
+
+#endif /* _IPA_INTERRUPT_H_ */
diff --git a/drivers/net/ipa/ipa_mem.c b/drivers/net/ipa/ipa_mem.c
new file mode 100644
index 000000000000..42d2c29d9f0c
--- /dev/null
+++ b/drivers/net/ipa/ipa_mem.c
@@ -0,0 +1,314 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
+ * Copyright (C) 2019-2020 Linaro Ltd.
+ */
+
+#include <linux/types.h>
+#include <linux/bitfield.h>
+#include <linux/bug.h>
+#include <linux/dma-mapping.h>
+#include <linux/io.h>
+
+#include "ipa.h"
+#include "ipa_reg.h"
+#include "ipa_cmd.h"
+#include "ipa_mem.h"
+#include "ipa_data.h"
+#include "ipa_table.h"
+#include "gsi_trans.h"
+
+/* "Canary" value placed between memory regions to detect overflow */
+#define IPA_MEM_CANARY_VAL		cpu_to_le32(0xdeadbeef)
+
+/* Add an immediate command to a transaction that zeroes a memory region */
+static void
+ipa_mem_zero_region_add(struct gsi_trans *trans, const struct ipa_mem *mem)
+{
+	struct ipa *ipa = container_of(trans->gsi, struct ipa, gsi);
+	dma_addr_t addr = ipa->zero_addr;
+
+	if (!mem->size)
+		return;
+
+	ipa_cmd_dma_shared_mem_add(trans, mem->offset, mem->size, addr, true);
+}
+
+/**
+ * ipa_mem_setup() - Set up IPA AP and modem shared memory areas
+ *
+ * Set up the shared memory regions in IPA local memory.  This involves
+ * zero-filling memory regions, and in the case of header memory, telling
+ * the IPA where it's located.
+ *
+ * This function performs the initial setup of this memory.  If the modem
+ * crashes, its regions are re-zeroed in ipa_mem_zero_modem().
+ *
+ * The AP informs the modem where its portions of memory are located
+ * in a QMI exchange that occurs at modem startup.
+ *
+ * @Return:	0 if successful, or a negative error code
+ */
+int ipa_mem_setup(struct ipa *ipa)
+{
+	dma_addr_t addr = ipa->zero_addr;
+	struct gsi_trans *trans;
+	u32 offset;
+	u16 size;
+
+	/* Get a transaction to define the header memory region and to zero
+	 * the processing context and modem memory regions.
+	 */
+	trans = ipa_cmd_trans_alloc(ipa, 4);
+	if (!trans) {
+		dev_err(&ipa->pdev->dev, "no transaction for memory setup\n");
+		return -EBUSY;
+	}
+
+	/* Initialize IPA-local header memory.  The modem and AP header
+	 * regions are contiguous, and initialized together.
+	 */
+	offset = ipa->mem[IPA_MEM_MODEM_HEADER].offset;
+	size = ipa->mem[IPA_MEM_MODEM_HEADER].size;
+	size += ipa->mem[IPA_MEM_AP_HEADER].size;
+
+	ipa_cmd_hdr_init_local_add(trans, offset, size, addr);
+
+	ipa_mem_zero_region_add(trans, &ipa->mem[IPA_MEM_MODEM_PROC_CTX]);
+
+	ipa_mem_zero_region_add(trans, &ipa->mem[IPA_MEM_AP_PROC_CTX]);
+
+	ipa_mem_zero_region_add(trans, &ipa->mem[IPA_MEM_MODEM]);
+
+	gsi_trans_commit_wait(trans);
+
+	/* Tell the hardware where the processing context area is located */
+	iowrite32(ipa->mem_offset + offset,
+		  ipa->reg_virt + IPA_REG_LOCAL_PKT_PROC_CNTXT_BASE_OFFSET);
+
+	return 0;
+}
+
+void ipa_mem_teardown(struct ipa *ipa)
+{
+	/* Nothing to do */
+}
+
+#ifdef IPA_VALIDATE
+
+static bool ipa_mem_valid(struct ipa *ipa, enum ipa_mem_id mem_id)
+{
+	const struct ipa_mem *mem = &ipa->mem[mem_id];
+	struct device *dev = &ipa->pdev->dev;
+	u16 size_multiple;
+
+	/* Other than modem memory, sizes must be a multiple of 8 */
+	size_multiple = mem_id == IPA_MEM_MODEM ? 4 : 8;
+	if (mem->size % size_multiple)
+		dev_err(dev, "region %u size not a multiple of %u bytes\n",
+			mem_id, size_multiple);
+	else if (mem->offset % 8)
+		dev_err(dev, "region %u offset not 8-byte aligned\n", mem_id);
+	else if (mem->offset < mem->canary_count * sizeof(__le32))
+		dev_err(dev, "region %u offset too small for %hu canaries\n",
+			mem_id, mem->canary_count);
+	else if (mem->offset + mem->size > ipa->mem_size)
+		dev_err(dev, "region %u ends beyond memory limit (0x%08x)\n",
+			mem_id, ipa->mem_size);
+	else
+		return true;
+
+	return false;
+}
+
+#else /* !IPA_VALIDATE */
+
+static bool ipa_mem_valid(struct ipa *ipa, enum ipa_mem_id mem_id)
+{
+	return true;
+}
+
+#endif /*! IPA_VALIDATE */
+
+/**
+ * ipa_mem_config() - Configure IPA shared memory
+ *
+ * @Return:	0 if successful, or a negative error code
+ */
+int ipa_mem_config(struct ipa *ipa)
+{
+	struct device *dev = &ipa->pdev->dev;
+	enum ipa_mem_id mem_id;
+	dma_addr_t addr;
+	u32 mem_size;
+	void *virt;
+	u32 val;
+
+	/* Check the advertised location and size of the shared memory area */
+	val = ioread32(ipa->reg_virt + IPA_REG_SHARED_MEM_SIZE_OFFSET);
+
+	/* The fields in the register are in 8 byte units */
+	ipa->mem_offset = 8 * u32_get_bits(val, SHARED_MEM_BADDR_FMASK);
+	/* Make sure the end is within the region's mapped space */
+	mem_size = 8 * u32_get_bits(val, SHARED_MEM_SIZE_FMASK);
+
+	/* If the sizes don't match, issue a warning */
+	if (ipa->mem_offset + mem_size > ipa->mem_size) {
+		dev_warn(dev, "ignoring larger reported memory size: 0x%08x\n",
+			mem_size);
+	} else if (ipa->mem_offset + mem_size < ipa->mem_size) {
+		dev_warn(dev, "limiting IPA memory size to 0x%08x\n",
+			 mem_size);
+		ipa->mem_size = mem_size;
+	}
+
+	/* Prealloc DMA memory for zeroing regions */
+	virt = dma_alloc_coherent(dev, IPA_MEM_MAX, &addr, GFP_KERNEL);
+	if (!virt)
+		return -ENOMEM;
+	ipa->zero_addr = addr;
+	ipa->zero_virt = virt;
+	ipa->zero_size = IPA_MEM_MAX;
+
+	/* Verify each defined memory region is valid, and if indicated
+	 * for the region, write "canary" values in the space prior to
+	 * the region's base address.
+	 */
+	for (mem_id = 0; mem_id < IPA_MEM_COUNT; mem_id++) {
+		const struct ipa_mem *mem = &ipa->mem[mem_id];
+		u16 canary_count;
+		__le32 *canary;
+
+		/* Validate all regions (even undefined ones) */
+		if (!ipa_mem_valid(ipa, mem_id))
+			goto err_dma_free;
+
+		/* Skip over undefined regions */
+		if (!mem->offset && !mem->size)
+			continue;
+
+		canary_count = mem->canary_count;
+		if (!canary_count)
+			continue;
+
+		/* Write canary values in the space before the region */
+		canary = ipa->mem_virt + ipa->mem_offset + mem->offset;
+		do
+			*--canary = IPA_MEM_CANARY_VAL;
+		while (--canary_count);
+	}
+
+	/* Make sure filter and route table memory regions are valid */
+	if (!ipa_table_valid(ipa))
+		goto err_dma_free;
+
+	/* Validate memory-related properties relevant to immediate commands */
+	if (!ipa_cmd_data_valid(ipa))
+		goto err_dma_free;
+
+	/* Verify the microcontroller ring alignment (0 is OK too) */
+	if (ipa->mem[IPA_MEM_UC_EVENT_RING].offset % 1024) {
+		dev_err(dev, "microcontroller ring not 1024-byte aligned\n");
+		goto err_dma_free;
+	}
+
+	return 0;
+
+err_dma_free:
+	dma_free_coherent(dev, IPA_MEM_MAX, ipa->zero_virt, ipa->zero_addr);
+
+	return -EINVAL;
+}
+
+/* Inverse of ipa_mem_config() */
+void ipa_mem_deconfig(struct ipa *ipa)
+{
+	struct device *dev = &ipa->pdev->dev;
+
+	dma_free_coherent(dev, ipa->zero_size, ipa->zero_virt, ipa->zero_addr);
+	ipa->zero_size = 0;
+	ipa->zero_virt = NULL;
+	ipa->zero_addr = 0;
+}
+
+/**
+ * ipa_mem_zero_modem() - Zero IPA-local memory regions owned by the modem
+ *
+ * Zero regions of IPA-local memory used by the modem.  These are configured
+ * (and initially zeroed) by ipa_mem_setup(), but if the modem crashes and
+ * restarts via SSR we need to re-initialize them.  A QMI message tells the
+ * modem where to find regions of IPA local memory it needs to know about
+ * (these included).
+ */
+int ipa_mem_zero_modem(struct ipa *ipa)
+{
+	struct gsi_trans *trans;
+
+	/* Get a transaction to zero the modem memory, modem header,
+	 * and modem processing context regions.
+	 */
+	trans = ipa_cmd_trans_alloc(ipa, 3);
+	if (!trans) {
+		dev_err(&ipa->pdev->dev,
+			"no transaction to zero modem memory\n");
+		return -EBUSY;
+	}
+
+	ipa_mem_zero_region_add(trans, &ipa->mem[IPA_MEM_MODEM_HEADER]);
+
+	ipa_mem_zero_region_add(trans, &ipa->mem[IPA_MEM_MODEM_PROC_CTX]);
+
+	ipa_mem_zero_region_add(trans, &ipa->mem[IPA_MEM_MODEM]);
+
+	gsi_trans_commit_wait(trans);
+
+	return 0;
+}
+
+/* Perform memory region-related initialization */
+int ipa_mem_init(struct ipa *ipa, u32 count, const struct ipa_mem *mem)
+{
+	struct device *dev = &ipa->pdev->dev;
+	struct resource *res;
+	int ret;
+
+	if (count > IPA_MEM_COUNT) {
+		dev_err(dev, "to many memory regions (%u > %u)\n",
+			count, IPA_MEM_COUNT);
+		return -EINVAL;
+	}
+
+	ret = dma_set_mask_and_coherent(&ipa->pdev->dev, DMA_BIT_MASK(64));
+	if (ret) {
+		dev_err(dev, "error %d setting DMA mask\n", ret);
+		return ret;
+	}
+
+	res = platform_get_resource_byname(ipa->pdev, IORESOURCE_MEM,
+					   "ipa-shared");
+	if (!res) {
+		dev_err(dev,
+			"DT error getting \"ipa-shared\" memory property\n");
+		return -ENODEV;
+	}
+
+	ipa->mem_virt = memremap(res->start, resource_size(res), MEMREMAP_WC);
+	if (!ipa->mem_virt) {
+		dev_err(dev, "unable to remap \"ipa-shared\" memory\n");
+		return -ENOMEM;
+	}
+
+	ipa->mem_addr = res->start;
+	ipa->mem_size = resource_size(res);
+
+	/* The ipa->mem[] array is indexed by enum ipa_mem_id values */
+	ipa->mem = mem;
+
+	return 0;
+}
+
+/* Inverse of ipa_mem_init() */
+void ipa_mem_exit(struct ipa *ipa)
+{
+	memunmap(ipa->mem_virt);
+}
diff --git a/drivers/net/ipa/ipa_mem.h b/drivers/net/ipa/ipa_mem.h
new file mode 100644
index 000000000000..065cb499ebe5
--- /dev/null
+++ b/drivers/net/ipa/ipa_mem.h
@@ -0,0 +1,90 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
+ * Copyright (C) 2019-2020 Linaro Ltd.
+ */
+#ifndef _IPA_MEM_H_
+#define _IPA_MEM_H_
+
+struct ipa;
+
+/**
+ * DOC: IPA Local Memory
+ *
+ * The IPA has a block of shared memory, divided into regions used for
+ * specific purposes.
+ *
+ * The regions within the shared block are bounded by an offset (relative to
+ * the "ipa-shared" memory range) and size found in the IPA_SHARED_MEM_SIZE
+ * register.
+ *
+ * Each region is optionally preceded by one or more 32-bit "canary" values.
+ * These are meant to detect out-of-range writes (if they become corrupted).
+ * A given region (such as a filter or routing table) has the same number
+ * of canaries for all IPA hardware versions.  Still, the number used is
+ * defined in the config data, allowing for generic handling of regions.
+ *
+ * The set of memory regions is defined in configuration data.  They are
+ * subject to these constraints:
+ * - a zero offset and zero size represents and undefined region
+ * - a region's offset is defined to be *past* all "canary" values
+ * - offset must be large enough to account for all canaries
+ * - a region's size may be zero, but may still have canaries
+ * - all offsets must be 8-byte aligned
+ * - most sizes must be a multiple of 8
+ * - modem memory size must be a multiple of 4
+ * - the microcontroller ring offset must be a multiple of 1024
+ */
+
+/* The maximum allowed size for any memory region */
+#define IPA_MEM_MAX	(2 * PAGE_SIZE)
+
+/* IPA-resident memory region ids */
+enum ipa_mem_id {
+	IPA_MEM_UC_SHARED,		/* 0 canaries */
+	IPA_MEM_UC_INFO,		/* 0 canaries */
+	IPA_MEM_V4_FILTER_HASHED,	/* 2 canaries */
+	IPA_MEM_V4_FILTER,		/* 2 canaries */
+	IPA_MEM_V6_FILTER_HASHED,	/* 2 canaries */
+	IPA_MEM_V6_FILTER,		/* 2 canaries */
+	IPA_MEM_V4_ROUTE_HASHED,	/* 2 canaries */
+	IPA_MEM_V4_ROUTE,		/* 2 canaries */
+	IPA_MEM_V6_ROUTE_HASHED,	/* 2 canaries */
+	IPA_MEM_V6_ROUTE,		/* 2 canaries */
+	IPA_MEM_MODEM_HEADER,		/* 2 canaries */
+	IPA_MEM_AP_HEADER,		/* 0 canaries */
+	IPA_MEM_MODEM_PROC_CTX,		/* 2 canaries */
+	IPA_MEM_AP_PROC_CTX,		/* 0 canaries */
+	IPA_MEM_PDN_CONFIG,		/* 2 canaries (IPA v4.0 and above) */
+	IPA_MEM_STATS_QUOTA,		/* 2 canaries (IPA v4.0 and above) */
+	IPA_MEM_STATS_TETHERING,	/* 0 canaries (IPA v4.0 and above) */
+	IPA_MEM_STATS_DROP,		/* 0 canaries (IPA v4.0 and above) */
+	IPA_MEM_MODEM,			/* 0 canaries */
+	IPA_MEM_UC_EVENT_RING,		/* 1 canary */
+	IPA_MEM_COUNT,			/* Number of regions (not an index) */
+};
+
+/**
+ * struct ipa_mem - IPA local memory region description
+ * @offset:		offset in IPA memory space to base of the region
+ * @size:		size in bytes base of the region
+ * @canary_count	# 32-bit "canary" values that precede region
+ */
+struct ipa_mem {
+	u32 offset;
+	u16 size;
+	u16 canary_count;
+};
+
+int ipa_mem_config(struct ipa *ipa);
+void ipa_mem_deconfig(struct ipa *ipa);
+
+int ipa_mem_setup(struct ipa *ipa);
+void ipa_mem_teardown(struct ipa *ipa);
+
+int ipa_mem_zero_modem(struct ipa *ipa);
+
+int ipa_mem_init(struct ipa *ipa, u32 count, const struct ipa_mem *mem);
+void ipa_mem_exit(struct ipa *ipa);
+
+#endif /* _IPA_MEM_H_ */
-- 
2.20.1

