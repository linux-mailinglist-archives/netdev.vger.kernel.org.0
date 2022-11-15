Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C61D5629286
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 08:36:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232445AbiKOHgU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 02:36:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232414AbiKOHgP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 02:36:15 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31A9E209B5
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 23:36:14 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id v124-20020a1cac82000000b003cf7a4ea2caso12448668wme.5
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 23:36:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U/b/69ztk+aptsMOgAQxQD/dTqenV+HzjSfACGH7onc=;
        b=kfFW7nNBy9y1NH/vtLXH1qcMRSZFvJhZSTlD6RUgpoKsd4z8Xk0zZlCvMM84IDkLz5
         rnkrCf/OidYwiIK4MqFgMco/ZEoxgOmpJQtCcdkyM9OsOWM7YqjFkmXaDrtQwlT3/zeM
         k332/Yry/hrhX6V9epzsOwGUh/xN5IArxlmtqw9wZNSJpVKE7dccUpw/C7n3WUOTRhNG
         XpnGjh86LPFhIhMEJsrmrspLpX48eLRGmaONxfhb6pzoCYqJAAfVM+Qrsz5Nqce57N2L
         POCFZHTouB6elYP25kSjPhK8lVaVmaWxYhKH9+3CWqgDQW8jn0dNCrc5Z3h4Bq4tIMAF
         Q+9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U/b/69ztk+aptsMOgAQxQD/dTqenV+HzjSfACGH7onc=;
        b=1GpjPnMnSR5xajGZYywSBSDGkVG3ZIQg4+jB2HhOSVMkowOUjqBzDvBfnDd/OZIspN
         mNoOjX+y8CjegIajqqywGv9LXja09lTys0bDDUtjGQIR8kPuPqgqFzxkvXapXYVqfhWR
         OrQaag3trJdUxoqGI7F31Nyuk0u7E1x0W+F2BE55jNr8OyS6Uobum8EWJ9fp3rO4HIb/
         3Rdg3xmn/YmXAEgYovHD3gpUcl2xL3w5MQgOuxtlW5cZgeE6AOiPLJSEEqvQEGjIKQFp
         zOcGmaj3VN42Q+RzQRYdUxy8LAJHuCgVr75uVofTOOTOe69PlUQw98G6oqolSuhKfzG/
         N1eQ==
X-Gm-Message-State: ANoB5plDITIYnOh2PWghVbZYYYAiz0KoJQzvjiDgldFs079c5ir+mXqo
        qwruo+NyuQ1SxFUnxS6Qln/lzw==
X-Google-Smtp-Source: AA0mqf4vDMBmEIBp2CbyiDYnvRodtmvrS7dygGvmV0Ij9PhHLo4Ktw9XA/hnsWztipY2d0KQemSYCg==
X-Received: by 2002:a05:600c:4196:b0:3c6:c05a:a50e with SMTP id p22-20020a05600c419600b003c6c05aa50emr433684wmh.81.1668497772752;
        Mon, 14 Nov 2022 23:36:12 -0800 (PST)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id j13-20020a5d452d000000b0022cbf4cda62sm13836811wra.27.2022.11.14.23.36.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 23:36:12 -0800 (PST)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     andrew@lunn.ch, broonie@kernel.org, calvin.johnson@oss.nxp.com,
        davem@davemloft.net, edumazet@google.com, hkallweit1@gmail.com,
        jernej.skrabec@gmail.com, krzysztof.kozlowski+dt@linaro.org,
        kuba@kernel.org, lgirdwood@gmail.com, linux@armlinux.org.uk,
        pabeni@redhat.com, robh+dt@kernel.org, samuel@sholland.org,
        wens@csie.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-sunxi@lists.linux.dev,
        netdev@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v4 1/3] regulator: Add of_regulator_bulk_get_all
Date:   Tue, 15 Nov 2022 07:36:01 +0000
Message-Id: <20221115073603.3425396-2-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221115073603.3425396-1-clabbe@baylibre.com>
References: <20221115073603.3425396-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It work exactly like regulator_bulk_get() but instead of working on a
provided list of names, it seek all consumers properties matching
xxx-supply.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/regulator/of_regulator.c   | 92 ++++++++++++++++++++++++++++++
 include/linux/regulator/consumer.h |  8 +++
 2 files changed, 100 insertions(+)

diff --git a/drivers/regulator/of_regulator.c b/drivers/regulator/of_regulator.c
index 0aff1c2886b5..584c92f1a317 100644
--- a/drivers/regulator/of_regulator.c
+++ b/drivers/regulator/of_regulator.c
@@ -701,3 +701,95 @@ struct regulator_dev *of_parse_coupled_regulator(struct regulator_dev *rdev,
 
 	return c_rdev;
 }
+
+/*
+ * Check if name is a supply name according to the '*-supply' pattern
+ * return 0 if false
+ * return length of supply name without the -supply
+ */
+static int is_supply_name(const char *name)
+{
+	int strs, i;
+
+	strs = strlen(name);
+	/* string need to be at minimum len(x-supply) */
+	if (strs < 8)
+		return 0;
+	for (i = strs - 6; i > 0; i--) {
+		/* find first '-' and check if right part is supply */
+		if (name[i] != '-')
+			continue;
+		if (strcmp(name + i + 1, "supply") != 0)
+			return 0;
+		return i;
+	}
+	return 0;
+}
+
+/*
+ * of_regulator_bulk_get_all - get multiple regulator consumers
+ *
+ * @dev:	Device to supply
+ * @np:		device node to search for consumers
+ * @consumers:  Configuration of consumers; clients are stored here.
+ *
+ * @return number of regulators on success, an errno on failure.
+ *
+ * This helper function allows drivers to get several regulator
+ * consumers in one operation.  If any of the regulators cannot be
+ * acquired then any regulators that were allocated will be freed
+ * before returning to the caller.
+ */
+int of_regulator_bulk_get_all(struct device *dev, struct device_node *np,
+			      struct regulator_bulk_data **consumers)
+{
+	int num_consumers = 0;
+	struct regulator *tmp;
+	struct property *prop;
+	int i, n = 0, ret;
+	char name[64];
+
+	*consumers = NULL;
+
+	/*
+	 * first pass: get numbers of xxx-supply
+	 * second pass: fill consumers
+	 */
+restart:
+	for_each_property_of_node(np, prop) {
+		i = is_supply_name(prop->name);
+		if (i == 0)
+			continue;
+		if (!*consumers) {
+			num_consumers++;
+			continue;
+		} else {
+			memcpy(name, prop->name, i);
+			name[i] = '\0';
+			tmp = regulator_get(dev, name);
+			if (!tmp) {
+				ret = -EINVAL;
+				goto error;
+			}
+			(*consumers)[n].consumer = tmp;
+			n++;
+			continue;
+		}
+	}
+	if (*consumers)
+		return num_consumers;
+	if (num_consumers == 0)
+		return 0;
+	*consumers = kmalloc_array(num_consumers,
+				   sizeof(struct regulator_bulk_data),
+				   GFP_KERNEL);
+	if (!*consumers)
+		return -ENOMEM;
+	goto restart;
+
+error:
+	while (--n >= 0)
+		regulator_put(consumers[n]->consumer);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(of_regulator_bulk_get_all);
diff --git a/include/linux/regulator/consumer.h b/include/linux/regulator/consumer.h
index 628a52b8e63f..39b666b40ea6 100644
--- a/include/linux/regulator/consumer.h
+++ b/include/linux/regulator/consumer.h
@@ -244,6 +244,8 @@ int regulator_disable_deferred(struct regulator *regulator, int ms);
 
 int __must_check regulator_bulk_get(struct device *dev, int num_consumers,
 				    struct regulator_bulk_data *consumers);
+int __must_check of_regulator_bulk_get_all(struct device *dev, struct device_node *np,
+					   struct regulator_bulk_data **consumers);
 int __must_check devm_regulator_bulk_get(struct device *dev, int num_consumers,
 					 struct regulator_bulk_data *consumers);
 void devm_regulator_bulk_put(struct regulator_bulk_data *consumers);
@@ -481,6 +483,12 @@ static inline int devm_regulator_bulk_get(struct device *dev, int num_consumers,
 	return 0;
 }
 
+static inline int of_regulator_bulk_get_all(struct device *dev, struct device_node *np,
+					    struct regulator_bulk_data **consumers)
+{
+	return 0;
+}
+
 static inline int regulator_bulk_enable(int num_consumers,
 					struct regulator_bulk_data *consumers)
 {
-- 
2.37.4

