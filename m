Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E47854A5ED2
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 16:02:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239634AbiBAPCN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 10:02:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239649AbiBAPCM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 10:02:12 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B594EC06173D
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 07:02:12 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id d188so21505876iof.7
        for <netdev@vger.kernel.org>; Tue, 01 Feb 2022 07:02:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Psa2zXq9CIoesnxGhdNYAKpIpdpvJqYiAj5N20pw5fs=;
        b=TobaHrqBNR77g0qOCWpypBwg6HIQxMn5bYtPxAZU+bHbGruKW9uW52W9KgiWE8kIcP
         d2IUU8goU9kJ732v1Ii8+DCWuMxBXow5I/R+EN5jDHKpYpXf9wZfdfkWSPTlpFFweFkD
         ClqPnk8MaECrlDi00jonB1myC0RsRdRcGdIf9IzT+lfxwvmfUX929HX8ayazCiQQffKe
         vWgJtjxZJG1XZfVUGxSBpaRFYIr+LXiKlF0icAQO7Nhr5k8K+YNM7IlgTYOenc7A8m1o
         StNvSYBDjHY5k3qhrSopYtzmO1pgmqChluk4mY3iuYOQrce8998Zqj8d3CvzhpyVRO5Z
         3aZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Psa2zXq9CIoesnxGhdNYAKpIpdpvJqYiAj5N20pw5fs=;
        b=q9jekpBeeeba8ZjSm3O9Ud5WWvIGH3Xp0Ag9xnIatJeDsaglu3d3gtfppAB03xRrO5
         9WmfyI0BrDnhf8UsEgjqYtsvzkm2Xe3XuNXzvr3useis1N62DBMg23PgIrTek2Z5ZpO0
         jU0mfSq9advbUziMWxk87J6/BEuPGPaDMLpjL0uPueOKOchwGkHPC3pKWS6YmBkH69BU
         6idNdPpOw3BE24JG8c/tsXkp3iG9sbnBoiqcw5NaMLYnSFe9IE1oBEXMCML7/v/RlwaX
         spR1mLgZQb95HtK1E5TdrRwCGd8h0o+biHi07se0WBnoyR2u6uzs1ifyq0CuLgU+WTl4
         Tc7g==
X-Gm-Message-State: AOAM532uYYAO5sAVRkL34WFrKDeMjIbe4zlnhRQfmLe47Yq4M3oLt5fc
        /M11l9gRng6WEfcZJ1jfECsRww==
X-Google-Smtp-Source: ABdhPJxnl2G6CdXw3UYQ2ueHlyZJNFOqm5B7PDylM0/r8g3VNPQFCfDE6WqyJy9+yyOOXXw+cnJRKQ==
X-Received: by 2002:a05:6638:3591:: with SMTP id v17mr11788085jal.277.1643727732147;
        Tue, 01 Feb 2022 07:02:12 -0800 (PST)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id e17sm19141307ilm.67.2022.02.01.07.02.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 07:02:11 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     robh+dt@kernel.org, bjorn.andersson@linaro.org, agross@kernel.org,
        mka@chromium.org, evgreen@chromium.org, cpratapa@codeaurora.org,
        avuyyuru@codeaurora.org, jponduru@codeaurora.org,
        subashab@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net v2 2/2] net: ipa: request IPA register values be retained
Date:   Tue,  1 Feb 2022 09:02:05 -0600
Message-Id: <20220201150205.468403-3-elder@linaro.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220201150205.468403-1-elder@linaro.org>
References: <20220201150205.468403-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In some cases, the IPA hardware needs to request the always-on
subsystem (AOSS) to coordinate with the IPA microcontroller to
retain IPA register values at power collapse.  This is done by
issuing a QMP request to the AOSS microcontroller.  A similar
request ondoes that request.

We must get and hold the "QMP" handle early, because we might get
back EPROBE_DEFER for that.  But the actual request should be sent
while we know the IPA clock is active, and when we know the
microcontroller is operational.

Fixes: 2775cbc5afeb6 ("net: ipa: rename "ipa_clock.c"")
Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_power.c | 52 +++++++++++++++++++++++++++++++++++++
 drivers/net/ipa/ipa_power.h |  7 +++++
 drivers/net/ipa/ipa_uc.c    |  5 ++++
 3 files changed, 64 insertions(+)

diff --git a/drivers/net/ipa/ipa_power.c b/drivers/net/ipa/ipa_power.c
index b1c6c0fcb654f..f2989aac47a62 100644
--- a/drivers/net/ipa/ipa_power.c
+++ b/drivers/net/ipa/ipa_power.c
@@ -11,6 +11,8 @@
 #include <linux/pm_runtime.h>
 #include <linux/bitops.h>
 
+#include "linux/soc/qcom/qcom_aoss.h"
+
 #include "ipa.h"
 #include "ipa_power.h"
 #include "ipa_endpoint.h"
@@ -64,6 +66,7 @@ enum ipa_power_flag {
  * struct ipa_power - IPA power management information
  * @dev:		IPA device pointer
  * @core:		IPA core clock
+ * @qmp:		QMP handle for AOSS communication
  * @spinlock:		Protects modem TX queue enable/disable
  * @flags:		Boolean state flags
  * @interconnect_count:	Number of elements in interconnect[]
@@ -72,6 +75,7 @@ enum ipa_power_flag {
 struct ipa_power {
 	struct device *dev;
 	struct clk *core;
+	struct qmp *qmp;
 	spinlock_t spinlock;	/* used with STOPPED/STARTED power flags */
 	DECLARE_BITMAP(flags, IPA_POWER_FLAG_COUNT);
 	u32 interconnect_count;
@@ -382,6 +386,47 @@ void ipa_power_modem_queue_active(struct ipa *ipa)
 	clear_bit(IPA_POWER_FLAG_STARTED, ipa->power->flags);
 }
 
+static int ipa_power_retention_init(struct ipa_power *power)
+{
+	struct qmp *qmp = qmp_get(power->dev);
+
+	if (IS_ERR(qmp)) {
+		if (PTR_ERR(qmp) == -EPROBE_DEFER)
+			return -EPROBE_DEFER;
+
+		/* We assume any other error means it's not defined/needed */
+		qmp = NULL;
+	}
+	power->qmp = qmp;
+
+	return 0;
+}
+
+static void ipa_power_retention_exit(struct ipa_power *power)
+{
+	qmp_put(power->qmp);
+	power->qmp = NULL;
+}
+
+/* Control register retention on power collapse */
+void ipa_power_retention(struct ipa *ipa, bool enable)
+{
+	static const char fmt[] = "{ class: bcm, res: ipa_pc, val: %c }";
+	struct ipa_power *power = ipa->power;
+	char buf[36];	/* Exactly enough for fmt[]; size a multiple of 4 */
+	int ret;
+
+	if (!power->qmp)
+		return;		/* Not needed on this platform */
+
+	(void)snprintf(buf, sizeof(buf), fmt, enable ? '1' : '0');
+
+	ret = qmp_send(power->qmp, buf, sizeof(buf));
+	if (ret)
+		dev_err(power->dev, "error %d sending QMP %sable request\n",
+			ret, enable ? "en" : "dis");
+}
+
 int ipa_power_setup(struct ipa *ipa)
 {
 	int ret;
@@ -438,12 +483,18 @@ ipa_power_init(struct device *dev, const struct ipa_power_data *data)
 	if (ret)
 		goto err_kfree;
 
+	ret = ipa_power_retention_init(power);
+	if (ret)
+		goto err_interconnect_exit;
+
 	pm_runtime_set_autosuspend_delay(dev, IPA_AUTOSUSPEND_DELAY);
 	pm_runtime_use_autosuspend(dev);
 	pm_runtime_enable(dev);
 
 	return power;
 
+err_interconnect_exit:
+	ipa_interconnect_exit(power);
 err_kfree:
 	kfree(power);
 err_clk_put:
@@ -460,6 +511,7 @@ void ipa_power_exit(struct ipa_power *power)
 
 	pm_runtime_disable(dev);
 	pm_runtime_dont_use_autosuspend(dev);
+	ipa_power_retention_exit(power);
 	ipa_interconnect_exit(power);
 	kfree(power);
 	clk_put(clk);
diff --git a/drivers/net/ipa/ipa_power.h b/drivers/net/ipa/ipa_power.h
index 2151805d7fbb0..6f84f057a2095 100644
--- a/drivers/net/ipa/ipa_power.h
+++ b/drivers/net/ipa/ipa_power.h
@@ -40,6 +40,13 @@ void ipa_power_modem_queue_wake(struct ipa *ipa);
  */
 void ipa_power_modem_queue_active(struct ipa *ipa);
 
+/**
+ * ipa_power_retention() - Control register retention on power collapse
+ * @ipa:	IPA pointer
+ * @enable:	Whether retention should be enabled or disabled
+ */
+void ipa_power_retention(struct ipa *ipa, bool enable);
+
 /**
  * ipa_power_setup() - Set up IPA power management
  * @ipa:	IPA pointer
diff --git a/drivers/net/ipa/ipa_uc.c b/drivers/net/ipa/ipa_uc.c
index 856e55a080a7f..fe11910518d95 100644
--- a/drivers/net/ipa/ipa_uc.c
+++ b/drivers/net/ipa/ipa_uc.c
@@ -11,6 +11,7 @@
 
 #include "ipa.h"
 #include "ipa_uc.h"
+#include "ipa_power.h"
 
 /**
  * DOC:  The IPA embedded microcontroller
@@ -154,6 +155,7 @@ static void ipa_uc_response_hdlr(struct ipa *ipa, enum ipa_irq_id irq_id)
 	case IPA_UC_RESPONSE_INIT_COMPLETED:
 		if (ipa->uc_powered) {
 			ipa->uc_loaded = true;
+			ipa_power_retention(ipa, true);
 			pm_runtime_mark_last_busy(dev);
 			(void)pm_runtime_put_autosuspend(dev);
 			ipa->uc_powered = false;
@@ -184,6 +186,9 @@ void ipa_uc_deconfig(struct ipa *ipa)
 
 	ipa_interrupt_remove(ipa->interrupt, IPA_IRQ_UC_1);
 	ipa_interrupt_remove(ipa->interrupt, IPA_IRQ_UC_0);
+	if (ipa->uc_loaded)
+		ipa_power_retention(ipa, false);
+
 	if (!ipa->uc_powered)
 		return;
 
-- 
2.32.0

