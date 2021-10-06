Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4874042367E
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 05:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237600AbhJFD4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 23:56:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237389AbhJFD4L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 23:56:11 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CFCDC061755
        for <netdev@vger.kernel.org>; Tue,  5 Oct 2021 20:54:20 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id y15so4540092lfk.7
        for <netdev@vger.kernel.org>; Tue, 05 Oct 2021 20:54:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=20pfiPj2Llz4cGLyPgKlOrfQmUN7w2lzAc5IpSkv3GI=;
        b=IXkrOb5Iz/JfPhzwI6v3Kgqqknyi/+bInvUv07kFzlxnKMk7JFNeHghZz54DiHXAIs
         Zhuj6VbGzDcX16B0S3Gf44y4VWWpqDq/uN3SHSd9RXjCx7bMgdiLf0skAmQj5ibRB+SP
         bMr8EDVuYCvdaAVEvrY6+z63Q/Vdb+mAL5YNkN+e0Ef7X0Y+psZvfNO2+41l1qiCx9MW
         wZlre7qC58F/fnFMGA+c/nzKZ7BjHhtKSDPzsID+876qdzyc2jcb7OokLuxaaEDGi/Up
         NIfEoUCeX3eCvIRWnv6ylatWevkMaY+xdMXtmguz5z6yj5/eZe6cDBzSIi8MUReYCyIj
         /aaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=20pfiPj2Llz4cGLyPgKlOrfQmUN7w2lzAc5IpSkv3GI=;
        b=4e9bq/fCLtA0n7jc2TiPKyBcqOcu81XQupSEBrjDZt6h/5BlYYfR3L8HCKz6BGP2fP
         8fIKigE4VGI3RU+MJD7Qo3Oz5njqGi5Q0vPxUB1XnAbxJwZYp/wJn6cyZVP6P5c1Nrks
         o6a5xByp8d/Zoo4ytVbGzx3FNYyyStjH0a5Qed/ffFpF0112V5uRHGLeVXeG6I7gpEHl
         q/v3q9UG70VbGMhrI3zR+uJB/pZmneRCHKkYRe1jHkIgu5Kd9vh8ynw6xQBerv/oMCZr
         vgVgCWnwaESojT+lN8et//ILILqR/rF56JcydN/2FRMSWYmLtm46uuxr8HGqkyg3ZZVD
         7hlw==
X-Gm-Message-State: AOAM533XzpL0h3PGyIJZbjDLoQKlVVP4n0dN5KdMJft8PZb5F3apelAy
        p90oLxbJHnyryNaIqd1lrAzt2g==
X-Google-Smtp-Source: ABdhPJx2PiFO+bVt8FwHx7jFT762AVaMkoQ2aY0tZJ1LZSdXu3KJP7oFaqeQQPTPuEqluhV/4Q2+3A==
X-Received: by 2002:a05:6512:1293:: with SMTP id u19mr7205262lfs.218.1633492458405;
        Tue, 05 Oct 2021 20:54:18 -0700 (PDT)
Received: from eriador.lan ([37.153.55.125])
        by smtp.gmail.com with ESMTPSA id s4sm2142967lfd.103.2021.10.05.20.54.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 20:54:17 -0700 (PDT)
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
Subject: [PATCH v1 08/15] pwrseq: pwrseq_qca: implement fallback support
Date:   Wed,  6 Oct 2021 06:54:00 +0300
Message-Id: <20211006035407.1147909-9-dmitry.baryshkov@linaro.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211006035407.1147909-1-dmitry.baryshkov@linaro.org>
References: <20211006035407.1147909-1-dmitry.baryshkov@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While we are waiting for all users of wcn399x-bt to be converted to the
pwrseq declaration in the device tree, provide support for the pwrseq
fallback: if the regulators are declared in the device itself, create
pwrseq instance. This way the hci_qca driver doesn't have to cope with
old and new dts bindings.

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
---
 drivers/power/pwrseq/pwrseq_qca.c | 155 +++++++++++++++++++++++++++++-
 1 file changed, 154 insertions(+), 1 deletion(-)

diff --git a/drivers/power/pwrseq/pwrseq_qca.c b/drivers/power/pwrseq/pwrseq_qca.c
index c15508cc80d2..f237cf2f1880 100644
--- a/drivers/power/pwrseq/pwrseq_qca.c
+++ b/drivers/power/pwrseq/pwrseq_qca.c
@@ -11,9 +11,11 @@
 #include <linux/delay.h>
 #include <linux/gpio/consumer.h>
 #include <linux/mod_devicetable.h>
+#include <linux/of_device.h>
 #include <linux/platform_device.h>
 #include <linux/property.h>
 #include <linux/pwrseq/driver.h>
+#include <linux/pwrseq/fallback.h>
 #include <linux/regulator/consumer.h>
 
 /* susclk rate */
@@ -369,5 +371,156 @@ static struct platform_driver pwrseq_qca_driver = {
 	},
 };
 
-module_platform_driver(pwrseq_qca_driver);
+struct pwrseq_qca_fallback {
+	struct pwrseq_qca_one qca_one;
+	struct pwrseq_qca_common common;
+};
+
+static const struct of_device_id pwrseq_qca_bt_of_match[] = {
+	{ .compatible = "qcom,qca6174-bt" },
+	{ .compatible = "qcom,qca6390-bt", .data = &qca_soc_data_qca6390},
+	{ .compatible = "qcom,qca9377-bt" },
+	{ .compatible = "qcom,wcn3990-bt", .data = &qca_soc_data_wcn3990 },
+	{ .compatible = "qcom,wcn3991-bt", .data = &qca_soc_data_wcn3990 },
+	{ .compatible = "qcom,wcn3998-bt", .data = &qca_soc_data_wcn3998 },
+	{ .compatible = "qcom,wcn6750-bt", .data = &qca_soc_data_wcn6750 },
+	{ /* sentinel */ },
+};
+
+static const struct qca_device_data qca_soc_data_wifi = {
+	.vregs = {
+		{ "vdd-1.8-xo", 80000  },
+		{ "vdd-1.3-rfa", 300000 },
+		{ "vdd-3.3-ch0", 450000 },
+		{ "vdd-3.3-ch1", 450000 },
+	},
+	.num_vregs = 4,
+};
+
+static const struct of_device_id pwrseq_qca_wifi_of_match[] = {
+	{ .compatible = "qcom,wcn3990-wifi", .data = &qca_soc_data_wifi },
+	{ /* sentinel */ }
+};
+
+static struct pwrseq * pwrseq_qca_fallback_get(struct device *dev)
+{
+	struct pwrseq_qca_fallback *fallback;
+	struct pwrseq *pwrseq;
+	const struct of_device_id *match;
+	const struct qca_device_data *data;
+	struct gpio_desc *gpiod;
+	int ret;
+
+	match = of_match_device(pwrseq_qca_bt_of_match, dev);
+	if (!match)
+		return ERR_PTR(-ENODEV);
+
+	data = match->data;
+	if (!data)
+		data = &qca_soc_data_default;
+
+	fallback = devm_kzalloc(dev, struct_size(fallback, common.vregs, data->num_vregs), GFP_KERNEL);
+	if (!data)
+		return ERR_PTR(-ENOMEM);
+
+	fallback->qca_one.common = &fallback->common;
+
+	ret = pwrseq_qca_common_init(dev, &fallback->common, data);
+	if (ret)
+		return ERR_PTR(ret);
+
+	if (data->has_enable_gpios) {
+		gpiod = devm_gpiod_get(dev, "enable", GPIOD_OUT_LOW);
+		if (IS_ERR(gpiod))
+			return ERR_PTR(dev_err_probe(dev, PTR_ERR(gpiod), "failed to acquire enable GPIO\n"));
+		fallback->qca_one.enable = gpiod;
+	}
+
+	/* If we have no control over device's enablement, make sure that sleep clock is always running */
+	if (!fallback->common.vddio ||
+	    !fallback->common.num_vregs ||
+	    !fallback->qca_one.enable) {
+		ret = clk_set_rate(fallback->common.susclk, SUSCLK_RATE_32KHZ);
+		if (ret)
+			return ERR_PTR(ret);
+
+		ret = clk_prepare_enable(fallback->common.susclk);
+		if (ret)
+			return ERR_PTR(ret);
+
+		ret = devm_add_action_or_reset(dev, pwrseq_qca_unprepare_susclk, &fallback->common);
+		if (ret)
+			return ERR_PTR(ret);
+	}
+
+	pwrseq = devm_pwrseq_create(dev, &pwrseq_qca_ops);
+	if (IS_ERR(pwrseq))
+		return pwrseq;
+
+	pwrseq_set_drvdata(pwrseq, &fallback->qca_one);
+
+	return pwrseq;
+}
+
+static struct pwrseq * pwrseq_qca_fallback_get_bt(struct device *dev, const char *id)
+{
+	if (strcmp(id, "bt"))
+		return ERR_PTR(-ENODEV);
+
+	return pwrseq_qca_fallback_get(dev);
+}
+
+static struct pwrseq * pwrseq_qca_fallback_get_wifi(struct device *dev, const char *id)
+{
+	if (strcmp(id, "wifi"))
+		return ERR_PTR(-ENODEV);
+
+	return pwrseq_qca_fallback_get(dev);
+}
+
+static struct pwrseq_fallback pwrseq_qca_fallback_bt = {
+	.get = pwrseq_qca_fallback_get_bt,
+	.of_match_table = pwrseq_qca_bt_of_match,
+};
+
+static struct pwrseq_fallback pwrseq_qca_fallback_wifi = {
+	.get = pwrseq_qca_fallback_get_wifi,
+	.of_match_table = pwrseq_qca_wifi_of_match,
+};
+
+static int __init pwrseq_qca_init(void)
+{
+	int ret;
+
+	ret = platform_driver_register(&pwrseq_qca_driver);
+	if (ret)
+		return ret;
+
+	ret = pwrseq_fallback_register(&pwrseq_qca_fallback_bt);
+	if (ret)
+		goto err_bt;
+
+	ret = pwrseq_fallback_register(&pwrseq_qca_fallback_wifi);
+	if (ret)
+		goto err_wifi;
+
+	return 0;
+
+err_wifi:
+	pwrseq_fallback_unregister(&pwrseq_qca_fallback_bt);
+err_bt:
+	platform_driver_unregister(&pwrseq_qca_driver);
+
+	return ret;
+}
+module_init(pwrseq_qca_init);
+
+static void __exit pwrseq_qca_exit(void)
+{
+	pwrseq_fallback_unregister(&pwrseq_qca_fallback_wifi);
+	pwrseq_fallback_unregister(&pwrseq_qca_fallback_bt);
+	platform_driver_unregister(&pwrseq_qca_driver);
+}
+module_exit(pwrseq_qca_exit);
+
 MODULE_LICENSE("GPL v2");
-- 
2.33.0

