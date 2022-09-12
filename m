Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B270C5B635E
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 00:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbiILWOO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 18:14:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230224AbiILWOB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 18:14:01 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57F374D4EB
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 15:13:53 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id g12so4751903ilj.5
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 15:13:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=3uDqqQLadf+Q4dxkpeGNAoSWXram8pBlD4j9m2Kej5M=;
        b=QDgIKpygFm+/ci0feBHniL5UXDT+mjZcbNH+LBXtMrVa5FhdElfIe+RCM5gyV5QUab
         2YzjmgLnpPnOLOxsYBx8PZNhxBh/uBpxuSAB+8OSFO6K5dC5tzaCdgxrHmQMzZC+1bpm
         y8Fgs+Mj1a+C5lytSVx0JDQk8kmJzYRnMoS8I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=3uDqqQLadf+Q4dxkpeGNAoSWXram8pBlD4j9m2Kej5M=;
        b=YExVsqM8j0uQ/n8PvzZ9yqmfePkAEM/SW84MW5gw34ojLpmvaLiLXKFVqlV+mGu6WJ
         zEFYo21jRZvSC07DA2Vb8eiKCH84hjq55gXaMX6n68ppHMNHQ3u9c4o3UbcdfdrdnC7a
         EfdFQomZ+xTZKUvwXKTCXtQGIZulJ/6PENHnzsMpy0xRjoqqx20XobAIRxY0BLqAZ5Cw
         uBFw127RcTvFmkQS3AjNIZtTscVhRSwK1SEz5q4xHLd2jXfVm3hNn9krKLR0SCddLPn3
         Sv2LfUiRU1CEQR6+SGBbDIr8P/ZC+/0oUw97qfwbNQgrYGHZU4RYEz+I5wnR+WCqs19B
         KO3A==
X-Gm-Message-State: ACgBeo1JU2VurhpxO0hSJrRyV99CcS1fV+z5zIsQz+lVNmE0yffhmUK5
        4v8UlSSuJ9iH16M+9ChPFjgRUw==
X-Google-Smtp-Source: AA6agR7agdo7PlW4YRPijpy3hRMuWiP64xZsFFOm/+sbvHDvnZNAbs0iD7Q1SA3jeeo6dNNqQ/k1vg==
X-Received: by 2002:a05:6e02:1449:b0:2f1:a7dc:5c53 with SMTP id p9-20020a056e02144900b002f1a7dc5c53mr11000780ilo.106.1663020832596;
        Mon, 12 Sep 2022 15:13:52 -0700 (PDT)
Received: from rrangel920.bld.corp.google.com (h24-56-189-219.arvdco.broadband.dynamic.tds.net. [24.56.189.219])
        by smtp.gmail.com with ESMTPSA id 18-20020a056e020cb200b002f16e7021f6sm4077334ilg.22.2022.09.12.15.13.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Sep 2022 15:13:51 -0700 (PDT)
From:   Raul E Rangel <rrangel@chromium.org>
To:     linux-acpi@vger.kernel.org, linux-input@vger.kernel.org
Cc:     andriy.shevchenko@linux.intel.com, jingle.wu@emc.com.tw,
        mario.limonciello@amd.com, timvp@google.com,
        linus.walleij@linaro.org, hdegoede@redhat.com, rafael@kernel.org,
        Raul E Rangel <rrangel@chromium.org>,
        Asmaa Mnebhi <asmaa@nvidia.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        "David S. Miller" <davem@davemloft.net>,
        David Thompson <davthompson@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, Len Brown <lenb@kernel.org>,
        Lu Wei <luwei32@huawei.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v2 05/13] gpiolib: acpi: Add wake_capable parameter to acpi_dev_gpio_irq_get_by
Date:   Mon, 12 Sep 2022 16:13:09 -0600
Message-Id: <20220912160931.v2.5.I4ff95ba7e884a486d7814ee888bf864be2ebdef4@changeid>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
In-Reply-To: <20220912221317.2775651-1-rrangel@chromium.org>
References: <20220912221317.2775651-1-rrangel@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ACPI spec defines the SharedAndWake and ExclusiveAndWake share type
keywords. This is an indication that the GPIO IRQ can also be used as a
wake source. This change exposes the wake_capable bit so drivers can
correctly enable wake functionality instead of making an assumption.

Signed-off-by: Raul E Rangel <rrangel@chromium.org>
---

Changes in v2:
- Fixed call site in mlxbf_gige_probe

 drivers/gpio/gpio-pca953x.c                        |  3 ++-
 drivers/gpio/gpiolib-acpi.c                        | 11 ++++++++++-
 drivers/gpio/gpiolib-acpi.h                        |  2 ++
 .../ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c |  3 ++-
 include/linux/acpi.h                               | 14 +++++++++++---
 5 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index ecd7d169470b06..df02c3eb34a294 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -130,7 +130,8 @@ static int pca953x_acpi_get_irq(struct device *dev)
 	if (ret)
 		dev_warn(dev, "can't add GPIO ACPI mapping\n");
 
-	ret = acpi_dev_gpio_irq_get_by(ACPI_COMPANION(dev), "irq-gpios", 0);
+	ret = acpi_dev_gpio_irq_get_by(ACPI_COMPANION(dev), "irq-gpios", 0,
+				       NULL);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/gpio/gpiolib-acpi.c b/drivers/gpio/gpiolib-acpi.c
index 9be1376f9a627f..5cda2fcf7f43df 100644
--- a/drivers/gpio/gpiolib-acpi.c
+++ b/drivers/gpio/gpiolib-acpi.c
@@ -741,6 +741,7 @@ static int acpi_populate_gpio_lookup(struct acpi_resource *ares, void *data)
 		lookup->info.pin_config = agpio->pin_config;
 		lookup->info.debounce = agpio->debounce_timeout;
 		lookup->info.gpioint = gpioint;
+		lookup->info.wake_capable = agpio->wake_capable;
 
 		/*
 		 * Polarity and triggering are only specified for GpioInt
@@ -991,6 +992,7 @@ struct gpio_desc *acpi_node_get_gpiod(struct fwnode_handle *fwnode,
  * @adev: pointer to a ACPI device to get IRQ from
  * @name: optional name of GpioInt resource
  * @index: index of GpioInt resource (starting from %0)
+ * @wake_capable: Set to 1 if the IRQ is wake capable
  *
  * If the device has one or more GpioInt resources, this function can be
  * used to translate from the GPIO offset in the resource to the Linux IRQ
@@ -1002,9 +1004,13 @@ struct gpio_desc *acpi_node_get_gpiod(struct fwnode_handle *fwnode,
  * The function takes optional @name parameter. If the resource has a property
  * name, then only those will be taken into account.
  *
+ * The GPIO is considered wake capable if GpioInt specifies SharedAndWake or
+ * ExclusiveAndWake.
+ *
  * Return: Linux IRQ number (> %0) on success, negative errno on failure.
  */
-int acpi_dev_gpio_irq_get_by(struct acpi_device *adev, const char *name, int index)
+int acpi_dev_gpio_irq_get_by(struct acpi_device *adev, const char *name,
+			     int index, int *wake_capable)
 {
 	int idx, i;
 	unsigned int irq_flags;
@@ -1061,6 +1067,9 @@ int acpi_dev_gpio_irq_get_by(struct acpi_device *adev, const char *name, int ind
 				dev_dbg(&adev->dev, "IRQ %d already in use\n", irq);
 			}
 
+			if (wake_capable)
+				*wake_capable = info.wake_capable;
+
 			return irq;
 		}
 
diff --git a/drivers/gpio/gpiolib-acpi.h b/drivers/gpio/gpiolib-acpi.h
index e476558d947136..1ac6816839dbce 100644
--- a/drivers/gpio/gpiolib-acpi.h
+++ b/drivers/gpio/gpiolib-acpi.h
@@ -18,6 +18,7 @@ struct acpi_device;
  * @pin_config: pin bias as provided by ACPI
  * @polarity: interrupt polarity as provided by ACPI
  * @triggering: triggering type as provided by ACPI
+ * @wake_capable: wake capability as provided by ACPI
  * @debounce: debounce timeout as provided by ACPI
  * @quirks: Linux specific quirks as provided by struct acpi_gpio_mapping
  */
@@ -28,6 +29,7 @@ struct acpi_gpio_info {
 	int pin_config;
 	int polarity;
 	int triggering;
+	bool wake_capable;
 	unsigned int debounce;
 	unsigned int quirks;
 };
diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
index b03e1c66bac0d9..fa38271718d9e7 100644
--- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
@@ -340,7 +340,8 @@ static int mlxbf_gige_probe(struct platform_device *pdev)
 	priv->rx_irq = platform_get_irq(pdev, MLXBF_GIGE_RECEIVE_PKT_INTR_IDX);
 	priv->llu_plu_irq = platform_get_irq(pdev, MLXBF_GIGE_LLU_PLU_INTR_IDX);
 
-	phy_irq = acpi_dev_gpio_irq_get_by(ACPI_COMPANION(&pdev->dev), "phy-gpios", 0);
+	phy_irq = acpi_dev_gpio_irq_get_by(ACPI_COMPANION(&pdev->dev),
+					   "phy-gpios", 0, NULL);
 	if (phy_irq < 0) {
 		dev_err(&pdev->dev, "Error getting PHY irq. Use polling instead");
 		phy_irq = PHY_POLL;
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 6f64b2f3dc5479..7ee946758c5bcc 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -1202,7 +1202,8 @@ bool acpi_gpio_get_irq_resource(struct acpi_resource *ares,
 				struct acpi_resource_gpio **agpio);
 bool acpi_gpio_get_io_resource(struct acpi_resource *ares,
 			       struct acpi_resource_gpio **agpio);
-int acpi_dev_gpio_irq_get_by(struct acpi_device *adev, const char *name, int index);
+int acpi_dev_gpio_irq_get_by(struct acpi_device *adev, const char *name,
+			     int index, int *wake_capable);
 #else
 static inline bool acpi_gpio_get_irq_resource(struct acpi_resource *ares,
 					      struct acpi_resource_gpio **agpio)
@@ -1215,7 +1216,8 @@ static inline bool acpi_gpio_get_io_resource(struct acpi_resource *ares,
 	return false;
 }
 static inline int acpi_dev_gpio_irq_get_by(struct acpi_device *adev,
-					   const char *name, int index)
+					   const char *name, int index,
+					   int *wake_capable)
 {
 	return -ENXIO;
 }
@@ -1223,7 +1225,13 @@ static inline int acpi_dev_gpio_irq_get_by(struct acpi_device *adev,
 
 static inline int acpi_dev_gpio_irq_get(struct acpi_device *adev, int index)
 {
-	return acpi_dev_gpio_irq_get_by(adev, NULL, index);
+	return acpi_dev_gpio_irq_get_by(adev, NULL, index, NULL);
+}
+
+static inline int acpi_dev_gpio_irq_get_wake(struct acpi_device *adev,
+					     int index, int *wake_capable)
+{
+	return acpi_dev_gpio_irq_get_by(adev, NULL, index, wake_capable);
 }
 
 /* Device properties */
-- 
2.37.2.789.g6183377224-goog

