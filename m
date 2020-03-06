Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D4C817B5B1
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 05:31:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727399AbgCFEac (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 23:30:32 -0500
Received: from mail-yw1-f68.google.com ([209.85.161.68]:39554 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726974AbgCFE2k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 23:28:40 -0500
Received: by mail-yw1-f68.google.com with SMTP id x184so1086548ywd.6
        for <netdev@vger.kernel.org>; Thu, 05 Mar 2020 20:28:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lsl9uUeVXVFev0pr72IiS4wSx+T+dt+j5N8Q5snoWc4=;
        b=hpxLlEnqh3cBFo/xoDkNmA/6zyHRuaVTMieAIMgbR7/YU6RoRqp9ErFcWegiVlWSYT
         gaSDvjjl2o7FmJpZ1OoeqIqivqROGdBrjsd8lLUrJtwKNQpmseLeEn7Yn9x0gQduKoae
         g1dEC8sId362ONpMrYixof82EPoSW3SqlgJxRq5Y5iCeEM9Au7xuxP8oJV1Mx9u2JOkK
         Pi0IcXyIgD7i5eYJiPVR4M10vJGAbE1v3JwqA6cx8J/kyX9K+DnlnTsffwAS/A9Unzy+
         Rr11prIMbuTUMiNjgcRSdEFFUkIXvv7cDAyz8uGaKt99PDNOHt238m7g7fy87OW1VmJP
         PYDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lsl9uUeVXVFev0pr72IiS4wSx+T+dt+j5N8Q5snoWc4=;
        b=PQZJtPhKQYKNYUdPSj2vLjPX4NpN2Kl8gVsXdne1r5BdjyqFpdYLzWQYuJF7ImZbiZ
         2dQxMvl8HYRUPhKeOaLlubz64ijjhvQv03Cms2osczB5tAtT/nLASB5tQiSzRFQnO8bm
         nl8joQgwVcQ7VAwcgpuhs8lBcZepKyGYzzo5n9s1sUiPIWg9Cum/F6ZIBXnFwQDG9TF8
         8+8UPaFPt0IqHa5oq7Jnlz8CdJYgDFDEV2xPbBYrZV23wx3oG8gSC26LKz8F0XWRKbSa
         Vh/nspRXHo6DHawM4iFzKZdXVAkTH7jzF6Rt7RnnwoHXzRHjqDlRgUslSjRw0HOg7H3O
         Fm+g==
X-Gm-Message-State: ANhLgQ1Y1ecG1jDQkIxLP7UZdnnydw6NgZrNHt/LukToyUR3w62DH9cz
        CNPpkW4VasNWLq2BaKzaS7KGB1IqZoM=
X-Google-Smtp-Source: ADFU+vuRYxZOZPphsdvOnDb45ug/CKm8ATDPH49kPWOEMK/i/l1B0Dp71eC1VbLDKPxgRxBTLDrE3w==
X-Received: by 2002:a25:3255:: with SMTP id y82mr1799048yby.208.1583468918320;
        Thu, 05 Mar 2020 20:28:38 -0800 (PST)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id x2sm12581836ywa.32.2020.03.05.20.28.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2020 20:28:37 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        David Miller <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>
Cc:     Andy Gross <agross@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Dan Williams <dcbw@redhat.com>,
        Evan Green <evgreen@google.com>,
        Eric Caruso <ejcaruso@google.com>,
        Susheel Yadav Yadagiri <syadagir@codeaurora.org>,
        Chaitanya Pratapa <cpratapa@codeaurora.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Siddharth Gupta <sidgup@codeaurora.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 01/17] remoteproc: add IPA notification to q6v5 driver
Date:   Thu,  5 Mar 2020 22:28:15 -0600
Message-Id: <20200306042831.17827-2-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200306042831.17827-1-elder@linaro.org>
References: <20200306042831.17827-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set up a subdev in the q6v5 modem remoteproc driver that generates
event notifications for the IPA driver to use for initialization and
recovery following a modem shutdown or crash.

A pair of new functions provides a way for the IPA driver to register
and deregister a notification callback function that will be called
whenever modem events (about to boot, running, about to shut down,
etc.) occur.  A void pointer value (provided by the IPA driver at
registration time) and an event type are supplied to the callback
function.

One event, MODEM_REMOVING, is signaled whenever the q6v5 driver is
about to remove the notification subdevice.  It requires the IPA
driver de-register its callback.

This sub-device is only used by the modem subsystem (MSS) driver,
so the code that adds the new subdev and allows registration and
deregistration of the notifier is found in "qcom_q6v6_mss.c".

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/remoteproc/Kconfig                    |  6 ++
 drivers/remoteproc/Makefile                   |  1 +
 drivers/remoteproc/qcom_q6v5_ipa_notify.c     | 85 +++++++++++++++++++
 drivers/remoteproc/qcom_q6v5_mss.c            | 38 +++++++++
 .../linux/remoteproc/qcom_q6v5_ipa_notify.h   | 82 ++++++++++++++++++
 5 files changed, 212 insertions(+)
 create mode 100644 drivers/remoteproc/qcom_q6v5_ipa_notify.c
 create mode 100644 include/linux/remoteproc/qcom_q6v5_ipa_notify.h

diff --git a/drivers/remoteproc/Kconfig b/drivers/remoteproc/Kconfig
index de3862c15fcc..56084635dd63 100644
--- a/drivers/remoteproc/Kconfig
+++ b/drivers/remoteproc/Kconfig
@@ -167,6 +167,12 @@ config QCOM_Q6V5_WCSS
 	  Say y here to support the Qualcomm Peripheral Image Loader for the
 	  Hexagon V5 based WCSS remote processors.
 
+config QCOM_Q6V5_IPA_NOTIFY
+	tristate
+	depends on QCOM_IPA
+	depends on QCOM_Q6V5_MSS
+	default QCOM_IPA
+
 config QCOM_SYSMON
 	tristate "Qualcomm sysmon driver"
 	depends on RPMSG
diff --git a/drivers/remoteproc/Makefile b/drivers/remoteproc/Makefile
index e30a1b15fbac..0effd3825035 100644
--- a/drivers/remoteproc/Makefile
+++ b/drivers/remoteproc/Makefile
@@ -21,6 +21,7 @@ obj-$(CONFIG_QCOM_Q6V5_ADSP)		+= qcom_q6v5_adsp.o
 obj-$(CONFIG_QCOM_Q6V5_MSS)		+= qcom_q6v5_mss.o
 obj-$(CONFIG_QCOM_Q6V5_PAS)		+= qcom_q6v5_pas.o
 obj-$(CONFIG_QCOM_Q6V5_WCSS)		+= qcom_q6v5_wcss.o
+obj-$(CONFIG_QCOM_Q6V5_IPA_NOTIFY)	+= qcom_q6v5_ipa_notify.o
 obj-$(CONFIG_QCOM_SYSMON)		+= qcom_sysmon.o
 obj-$(CONFIG_QCOM_WCNSS_PIL)		+= qcom_wcnss_pil.o
 qcom_wcnss_pil-y			+= qcom_wcnss.o
diff --git a/drivers/remoteproc/qcom_q6v5_ipa_notify.c b/drivers/remoteproc/qcom_q6v5_ipa_notify.c
new file mode 100644
index 000000000000..e1c10a128bfd
--- /dev/null
+++ b/drivers/remoteproc/qcom_q6v5_ipa_notify.c
@@ -0,0 +1,85 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Qualcomm IPA notification subdev support
+ *
+ * Copyright (C) 2019 Linaro Ltd.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/remoteproc.h>
+#include <linux/remoteproc/qcom_q6v5_ipa_notify.h>
+
+static void
+ipa_notify_common(struct rproc_subdev *subdev, enum qcom_rproc_event event)
+{
+	struct qcom_rproc_ipa_notify *ipa_notify;
+	qcom_ipa_notify_t notify;
+
+	ipa_notify = container_of(subdev, struct qcom_rproc_ipa_notify, subdev);
+	notify = ipa_notify->notify;
+	if (notify)
+		notify(ipa_notify->data, event);
+}
+
+static int ipa_notify_prepare(struct rproc_subdev *subdev)
+{
+	ipa_notify_common(subdev, MODEM_STARTING);
+
+	return 0;
+}
+
+static int ipa_notify_start(struct rproc_subdev *subdev)
+{
+	ipa_notify_common(subdev, MODEM_RUNNING);
+
+	return 0;
+}
+
+static void ipa_notify_stop(struct rproc_subdev *subdev, bool crashed)
+
+{
+	ipa_notify_common(subdev, crashed ? MODEM_CRASHED : MODEM_STOPPING);
+}
+
+static void ipa_notify_unprepare(struct rproc_subdev *subdev)
+{
+	ipa_notify_common(subdev, MODEM_OFFLINE);
+}
+
+static void ipa_notify_removing(struct rproc_subdev *subdev)
+{
+	ipa_notify_common(subdev, MODEM_REMOVING);
+}
+
+/* Register the IPA notification subdevice with the Q6V5 MSS remoteproc */
+void qcom_add_ipa_notify_subdev(struct rproc *rproc,
+		struct qcom_rproc_ipa_notify *ipa_notify)
+{
+	ipa_notify->notify = NULL;
+	ipa_notify->data = NULL;
+	ipa_notify->subdev.prepare = ipa_notify_prepare;
+	ipa_notify->subdev.start = ipa_notify_start;
+	ipa_notify->subdev.stop = ipa_notify_stop;
+	ipa_notify->subdev.unprepare = ipa_notify_unprepare;
+
+	rproc_add_subdev(rproc, &ipa_notify->subdev);
+}
+EXPORT_SYMBOL_GPL(qcom_add_ipa_notify_subdev);
+
+/* Remove the IPA notification subdevice */
+void qcom_remove_ipa_notify_subdev(struct rproc *rproc,
+		struct qcom_rproc_ipa_notify *ipa_notify)
+{
+	struct rproc_subdev *subdev = &ipa_notify->subdev;
+
+	ipa_notify_removing(subdev);
+
+	rproc_remove_subdev(rproc, subdev);
+	ipa_notify->notify = NULL;	/* Make it obvious */
+}
+EXPORT_SYMBOL_GPL(qcom_remove_ipa_notify_subdev);
+
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("Qualcomm IPA notification remoteproc subdev");
diff --git a/drivers/remoteproc/qcom_q6v5_mss.c b/drivers/remoteproc/qcom_q6v5_mss.c
index a1cc9cbe038f..f9ccce76e44b 100644
--- a/drivers/remoteproc/qcom_q6v5_mss.c
+++ b/drivers/remoteproc/qcom_q6v5_mss.c
@@ -22,6 +22,7 @@
 #include <linux/regmap.h>
 #include <linux/regulator/consumer.h>
 #include <linux/remoteproc.h>
+#include "linux/remoteproc/qcom_q6v5_ipa_notify.h"
 #include <linux/reset.h>
 #include <linux/soc/qcom/mdt_loader.h>
 #include <linux/iopoll.h>
@@ -201,6 +202,7 @@ struct q6v5 {
 	struct qcom_rproc_glink glink_subdev;
 	struct qcom_rproc_subdev smd_subdev;
 	struct qcom_rproc_ssr ssr_subdev;
+	struct qcom_rproc_ipa_notify ipa_notify_subdev;
 	struct qcom_sysmon *sysmon;
 	bool need_mem_protection;
 	bool has_alt_reset;
@@ -1540,6 +1542,39 @@ static int q6v5_alloc_memory_region(struct q6v5 *qproc)
 	return 0;
 }
 
+#if IS_ENABLED(CONFIG_QCOM_Q6V5_IPA_NOTIFY)
+
+/* Register IPA notification function */
+int qcom_register_ipa_notify(struct rproc *rproc, qcom_ipa_notify_t notify,
+			     void *data)
+{
+	struct qcom_rproc_ipa_notify *ipa_notify;
+	struct q6v5 *qproc = rproc->priv;
+
+	if (!notify)
+		return -EINVAL;
+
+	ipa_notify = &qproc->ipa_notify_subdev;
+	if (ipa_notify->notify)
+		return -EBUSY;
+
+	ipa_notify->notify = notify;
+	ipa_notify->data = data;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(qcom_register_ipa_notify);
+
+/* Deregister IPA notification function */
+void qcom_deregister_ipa_notify(struct rproc *rproc)
+{
+	struct q6v5 *qproc = rproc->priv;
+
+	qproc->ipa_notify_subdev.notify = NULL;
+}
+EXPORT_SYMBOL_GPL(qcom_deregister_ipa_notify);
+#endif /* !IS_ENABLED(CONFIG_QCOM_Q6V5_IPA_NOTIFY) */
+
 static int q6v5_probe(struct platform_device *pdev)
 {
 	const struct rproc_hexagon_res *desc;
@@ -1664,6 +1699,7 @@ static int q6v5_probe(struct platform_device *pdev)
 	qcom_add_glink_subdev(rproc, &qproc->glink_subdev);
 	qcom_add_smd_subdev(rproc, &qproc->smd_subdev);
 	qcom_add_ssr_subdev(rproc, &qproc->ssr_subdev, "mpss");
+	qcom_add_ipa_notify_subdev(rproc, &qproc->ipa_notify_subdev);
 	qproc->sysmon = qcom_add_sysmon_subdev(rproc, "modem", 0x12);
 	if (IS_ERR(qproc->sysmon)) {
 		ret = PTR_ERR(qproc->sysmon);
@@ -1677,6 +1713,7 @@ static int q6v5_probe(struct platform_device *pdev)
 	return 0;
 
 detach_proxy_pds:
+	qcom_remove_ipa_notify_subdev(qproc->rproc, &qproc->ipa_notify_subdev);
 	q6v5_pds_detach(qproc, qproc->proxy_pds, qproc->proxy_pd_count);
 detach_active_pds:
 	q6v5_pds_detach(qproc, qproc->active_pds, qproc->active_pd_count);
@@ -1693,6 +1730,7 @@ static int q6v5_remove(struct platform_device *pdev)
 	rproc_del(qproc->rproc);
 
 	qcom_remove_sysmon_subdev(qproc->sysmon);
+	qcom_remove_ipa_notify_subdev(qproc->rproc, &qproc->ipa_notify_subdev);
 	qcom_remove_glink_subdev(qproc->rproc, &qproc->glink_subdev);
 	qcom_remove_smd_subdev(qproc->rproc, &qproc->smd_subdev);
 	qcom_remove_ssr_subdev(qproc->rproc, &qproc->ssr_subdev);
diff --git a/include/linux/remoteproc/qcom_q6v5_ipa_notify.h b/include/linux/remoteproc/qcom_q6v5_ipa_notify.h
new file mode 100644
index 000000000000..0820edc0ab7d
--- /dev/null
+++ b/include/linux/remoteproc/qcom_q6v5_ipa_notify.h
@@ -0,0 +1,82 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/* Copyright (C) 2019 Linaro Ltd. */
+
+#ifndef __QCOM_Q6V5_IPA_NOTIFY_H__
+#define __QCOM_Q6V5_IPA_NOTIFY_H__
+
+#if IS_ENABLED(CONFIG_QCOM_Q6V5_IPA_NOTIFY)
+
+#include <linux/remoteproc.h>
+
+enum qcom_rproc_event {
+	MODEM_STARTING	= 0,	/* Modem is about to be started */
+	MODEM_RUNNING	= 1,	/* Startup complete; modem is operational */
+	MODEM_STOPPING	= 2,	/* Modem is about to shut down */
+	MODEM_CRASHED	= 3,	/* Modem has crashed (implies stopping) */
+	MODEM_OFFLINE	= 4,	/* Modem is now offline */
+	MODEM_REMOVING	= 5,	/* Modem is about to be removed */
+};
+
+typedef void (*qcom_ipa_notify_t)(void *data, enum qcom_rproc_event event);
+
+struct qcom_rproc_ipa_notify {
+	struct rproc_subdev subdev;
+
+	qcom_ipa_notify_t notify;
+	void *data;
+};
+
+/**
+ * qcom_add_ipa_notify_subdev() - Register IPA notification subdevice
+ * @rproc:	rproc handle
+ * @ipa_notify:	IPA notification subdevice handle
+ *
+ * Register the @ipa_notify subdevice with the @rproc so modem events
+ * can be sent to IPA when they occur.
+ *
+ * This is defined in "qcom_q6v5_ipa_notify.c".
+ */
+void qcom_add_ipa_notify_subdev(struct rproc *rproc,
+		struct qcom_rproc_ipa_notify *ipa_notify);
+
+/**
+ * qcom_remove_ipa_notify_subdev() - Remove IPA SSR subdevice
+ * @rproc:	rproc handle
+ * @ipa_notify:	IPA notification subdevice handle
+ *
+ * This is defined in "qcom_q6v5_ipa_notify.c".
+ */
+void qcom_remove_ipa_notify_subdev(struct rproc *rproc,
+		struct qcom_rproc_ipa_notify *ipa_notify);
+
+/**
+ * qcom_register_ipa_notify() - Register IPA notification function
+ * @rproc:	Remote processor handle
+ * @notify:	Non-null IPA notification callback function pointer
+ * @data:	Data supplied to IPA notification callback function
+ *
+ * @Return: 0 if successful, or a negative error code otherwise
+ *
+ * This is defined in "qcom_q6v5_mss.c".
+ */
+int qcom_register_ipa_notify(struct rproc *rproc, qcom_ipa_notify_t notify,
+			     void *data);
+/**
+ * qcom_deregister_ipa_notify() - Deregister IPA notification function
+ * @rproc:	Remote processor handle
+ *
+ * This is defined in "qcom_q6v5_mss.c".
+ */
+void qcom_deregister_ipa_notify(struct rproc *rproc);
+
+#else /* !IS_ENABLED(CONFIG_QCOM_Q6V5_IPA_NOTIFY) */
+
+struct qcom_rproc_ipa_notify { /* empty */ };
+
+#define qcom_add_ipa_notify_subdev(rproc, ipa_notify)		/* no-op */
+#define qcom_remove_ipa_notify_subdev(rproc, ipa_notify)	/* no-op */
+
+#endif /* !IS_ENABLED(CONFIG_QCOM_Q6V5_IPA_NOTIFY) */
+
+#endif /* !__QCOM_Q6V5_IPA_NOTIFY_H__ */
-- 
2.20.1

