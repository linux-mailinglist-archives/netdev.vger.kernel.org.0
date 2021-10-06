Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76DD6423690
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 05:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237708AbhJFD4w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 23:56:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237486AbhJFD4W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 23:56:22 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4441AC061794
        for <netdev@vger.kernel.org>; Tue,  5 Oct 2021 20:54:22 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id r19so4459524lfe.10
        for <netdev@vger.kernel.org>; Tue, 05 Oct 2021 20:54:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gLxBTtcfVl4dtJ5J9RXz2IWihrIE1icg8208P8LI768=;
        b=o7/Ze/q0htXc3MD9r6CcG3LU411fiLFkjclIYt5gxydc/GKQKyTk+c7fhvbcoYtnXY
         7/e9Y6P+WvNC7PaRnuR6Fs8f/HGSu4cm8HPQMOPF+D42Ao70Z9MCpH+fqsIDFK5zJkDR
         R6gWSvzoe/3HsUDPDcO1qFwjWV7xhaNAeaxJGZ4Ca0smcF2WjV7pCfl0Im0ofCDBFxmf
         ZqpC8OxUr+Gjxy55TUUZGalgayt6UEOiDNBvCOqr7z2uJPL94ZyCRoG6wWTIlDvMj9/F
         Fom9EcqTv3xJHX1Gutf93jM/YB4tttS/qRFlfCz1mTrwIXBMkWVUSeIxW/9VKgUMzgNQ
         ExTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gLxBTtcfVl4dtJ5J9RXz2IWihrIE1icg8208P8LI768=;
        b=wW+TPQ2V7v+Gq+gPvi51WO4fIVNlVr/8e76RxHyjXUfRiGPzjPfu9SiO5ftj2w8Tak
         G5p7DwxiXv0gKL/uaI19Smi/To46bHv1/7Toozm5puxWFKcYeL1L619sN/HI65QwoWcu
         PGifChi9tFw3k8zmv0VEPObGQf7pccx2Lgj5z3fYLf6quwxvUEwOHAT3AZTYrIj0tc1/
         BV5+JVOfYkwdwYn2yWY0CeSfWdN5iTrxUAOFJ+5JVfHsmpQVc4V4wSh+L66mVDSQ1Fmo
         CvcsBEi93HhI3pirZARSD2V5irLnHAc8FVA4YGvV74hcvuMdDCwAsZpmZLZIohGUPX7H
         TNuw==
X-Gm-Message-State: AOAM531cXRiGvQMvWE58Cp1MTKGb1QQVhqS6mzlegzBCuvN171IiRLSU
        mhhmco9/GxQSd7TiMehtyEEC9w==
X-Google-Smtp-Source: ABdhPJy89+pMq9hJpLFoCh7hciqRs5MkSybaUyFLo80FMybatgUVnxZf/pBhBn/cocZ6nF3Qd4LzIg==
X-Received: by 2002:ac2:4c51:: with SMTP id o17mr7353777lfk.457.1633492460649;
        Tue, 05 Oct 2021 20:54:20 -0700 (PDT)
Received: from eriador.lan ([37.153.55.125])
        by smtp.gmail.com with ESMTPSA id s4sm2142967lfd.103.2021.10.05.20.54.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 20:54:19 -0700 (PDT)
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
Subject: [PATCH v1 10/15] ath10k: add support for pwrseq sequencing
Date:   Wed,  6 Oct 2021 06:54:02 +0300
Message-Id: <20211006035407.1147909-11-dmitry.baryshkov@linaro.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211006035407.1147909-1-dmitry.baryshkov@linaro.org>
References: <20211006035407.1147909-1-dmitry.baryshkov@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Power sequencing for Qualcomm WiFi+BT chipsets are being reworked to use
pwrseq rather than individually handling all the regulators. Add support
for pwrseq to ath10k SNOC driver.

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
---
 drivers/net/wireless/ath/ath10k/snoc.c | 45 +++++++++++++-------------
 drivers/net/wireless/ath/ath10k/snoc.h |  4 +--
 2 files changed, 25 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
index ea00fbb15601..8578c56982df 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -14,6 +14,7 @@
 #include <linux/regulator/consumer.h>
 #include <linux/of_address.h>
 #include <linux/iommu.h>
+#include <linux/pwrseq/consumer.h>
 
 #include "ce.h"
 #include "coredump.h"
@@ -41,14 +42,6 @@ static char *const ce_name[] = {
 	"WLAN_CE_11",
 };
 
-static const char * const ath10k_regulators[] = {
-	"vdd-0.8-cx-mx",
-	"vdd-1.8-xo",
-	"vdd-1.3-rfa",
-	"vdd-3.3-ch0",
-	"vdd-3.3-ch1",
-};
-
 static const char * const ath10k_clocks[] = {
 	"cxo_ref_clk_pin", "qdss",
 };
@@ -1010,10 +1003,14 @@ static int ath10k_hw_power_on(struct ath10k *ar)
 
 	ath10k_dbg(ar, ATH10K_DBG_SNOC, "soc power on\n");
 
-	ret = regulator_bulk_enable(ar_snoc->num_vregs, ar_snoc->vregs);
+	ret = pwrseq_full_power_on(ar_snoc->pwrseq);
 	if (ret)
 		return ret;
 
+	ret = regulator_enable(ar_snoc->vreg_cx_mx);
+	if (ret)
+		goto vreg_pwrseq_off;
+
 	ret = clk_bulk_prepare_enable(ar_snoc->num_clks, ar_snoc->clks);
 	if (ret)
 		goto vreg_off;
@@ -1021,11 +1018,14 @@ static int ath10k_hw_power_on(struct ath10k *ar)
 	return ret;
 
 vreg_off:
-	regulator_bulk_disable(ar_snoc->num_vregs, ar_snoc->vregs);
+	regulator_disable(ar_snoc->vreg_cx_mx);
+vreg_pwrseq_off:
+	pwrseq_power_off(ar_snoc->pwrseq);
+
 	return ret;
 }
 
-static int ath10k_hw_power_off(struct ath10k *ar)
+static void ath10k_hw_power_off(struct ath10k *ar)
 {
 	struct ath10k_snoc *ar_snoc = ath10k_snoc_priv(ar);
 
@@ -1033,7 +1033,9 @@ static int ath10k_hw_power_off(struct ath10k *ar)
 
 	clk_bulk_disable_unprepare(ar_snoc->num_clks, ar_snoc->clks);
 
-	return regulator_bulk_disable(ar_snoc->num_vregs, ar_snoc->vregs);
+	regulator_disable(ar_snoc->vreg_cx_mx);
+
+	pwrseq_power_off(ar_snoc->pwrseq);
 }
 
 static void ath10k_snoc_wlan_disable(struct ath10k *ar)
@@ -1691,20 +1693,19 @@ static int ath10k_snoc_probe(struct platform_device *pdev)
 		goto err_release_resource;
 	}
 
-	ar_snoc->num_vregs = ARRAY_SIZE(ath10k_regulators);
-	ar_snoc->vregs = devm_kcalloc(&pdev->dev, ar_snoc->num_vregs,
-				      sizeof(*ar_snoc->vregs), GFP_KERNEL);
-	if (!ar_snoc->vregs) {
-		ret = -ENOMEM;
+	ar_snoc->pwrseq = devm_pwrseq_get(&pdev->dev, "wifi");
+	if (IS_ERR(ar_snoc->pwrseq)) {
+		ret = PTR_ERR(ar_snoc->pwrseq);
+		if (ret != -EPROBE_DEFER)
+			ath10k_warn(ar, "failed to acquire pwrseq: %d\n", ret);
 		goto err_free_irq;
 	}
-	for (i = 0; i < ar_snoc->num_vregs; i++)
-		ar_snoc->vregs[i].supply = ath10k_regulators[i];
 
-	ret = devm_regulator_bulk_get(&pdev->dev, ar_snoc->num_vregs,
-				      ar_snoc->vregs);
-	if (ret < 0)
+	ar_snoc->vreg_cx_mx = devm_regulator_get(&pdev->dev, "vdd-0.8-cx-mx");
+	if (IS_ERR(ar_snoc->vreg_cx_mx)) {
+		ret = PTR_ERR(ar_snoc->vreg_cx_mx);
 		goto err_free_irq;
+	}
 
 	ar_snoc->num_clks = ARRAY_SIZE(ath10k_clocks);
 	ar_snoc->clks = devm_kcalloc(&pdev->dev, ar_snoc->num_clks,
diff --git a/drivers/net/wireless/ath/ath10k/snoc.h b/drivers/net/wireless/ath/ath10k/snoc.h
index 5095d1893681..5188d6f6f850 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.h
+++ b/drivers/net/wireless/ath/ath10k/snoc.h
@@ -70,10 +70,10 @@ struct ath10k_snoc {
 	struct ath10k_snoc_ce_irq ce_irqs[CE_COUNT_MAX];
 	struct ath10k_ce ce;
 	struct timer_list rx_post_retry;
-	struct regulator_bulk_data *vregs;
-	size_t num_vregs;
+	struct regulator *vreg_cx_mx;
 	struct clk_bulk_data *clks;
 	size_t num_clks;
+	struct pwrseq *pwrseq;
 	struct ath10k_qmi *qmi;
 	unsigned long flags;
 	bool xo_cal_supported;
-- 
2.33.0

