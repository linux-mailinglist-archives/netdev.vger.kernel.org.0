Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76DF852C432
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 22:22:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242378AbiERUJw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 16:09:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242355AbiERUJu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 16:09:50 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65CE020F4D7
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 13:09:49 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id w4so4131419wrg.12
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 13:09:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0KczXNl/9anABcy3K+RQeZFJPAxsjOIOqB1/DLsrKFc=;
        b=NyHVRqHreDZKcytz8hWSWGRyMBK/Gyu/ugTIj5yEj9xTVltz5sneAJBFLbJHE93iEv
         uIvMsS6cq1K6950Twamwn/p8HkDYu7ytRmsH4Vi1I2PpB86LAsnZhoETu1oBPRwhRKOh
         dw4Z50DfUo5AE1P4eFpaBiXHirzI3xETzvAtYq4mTQhjn5nwog9pVPbJOZ25opwuDjXo
         mN2dHmI6K3B+snsTrb3h8xYMjIHoCy8tMsxUFV0zzeD+IpzqH0R3vJ0AVZTXv0++E3Va
         PNrPpg/QOEQXWoPC1zPW9vuiIjrnUeAKcazOxUgSYb/kQvIEOOim1hSfPDyM7XHUoQqw
         It2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0KczXNl/9anABcy3K+RQeZFJPAxsjOIOqB1/DLsrKFc=;
        b=BbH64ETLnvpPtTQ8PjuuzKQpK2itbUUWXLybZQQlmzKQ8nq4TOk+IIWiV5IuN/rokN
         BLIe7AZkTcMzN9LoQVG0uOJfx4ONL/0WmI3z43gWUvz79TARSrlw+yJd8XdetDyVPqkP
         kz+tktbi16jw6p3qXUKTwnIUu9ywu+PXqfsKWSWJlWHku/PJ/ou8YWHSAY6/6zfSek2P
         5rw5xfWZrjkT5W+X3Rw/7wYXVfly+gRwbYrljhr2Wc7Fi5m9H0jkb53dvY6aQzYsyGjJ
         gDxADqKFmDR0Qz9JAU3R9Bx8SxzXeIcuWFuL2lDjWRnsq9f7vU7rQ5hrLK95uXzhfM8V
         CswA==
X-Gm-Message-State: AOAM5308jOa10LocCdnYpgNJSKBxGqf1LYW7892EbFPpsYVcIonkwKky
        LEs9ZxU5oiZ2knzNVOTR2d2l/Q==
X-Google-Smtp-Source: ABdhPJx1F7rRI2kbz2zJ8CXGzIHQjz1zodLDahnKCtWpusExTDqLaFpDJacqbNurT39m8xSu+p9daQ==
X-Received: by 2002:a5d:47c9:0:b0:20c:80bb:a296 with SMTP id o9-20020a5d47c9000000b0020c80bba296mr1117991wrc.384.1652904587664;
        Wed, 18 May 2022 13:09:47 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id o23-20020a05600c511700b0039456c00ba7sm6859281wms.1.2022.05.18.13.09.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 13:09:47 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     andrew@lunn.ch, broonie@kernel.org, calvin.johnson@oss.nxp.com,
        davem@davemloft.net, edumazet@google.com, hkallweit1@gmail.com,
        jernej.skrabec@gmail.com, krzysztof.kozlowski+dt@linaro.org,
        kuba@kernel.org, lgirdwood@gmail.com, linux@armlinux.org.uk,
        pabeni@redhat.com, robh+dt@kernel.org, samuel@sholland.org,
        wens@csie.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-sunxi@lists.linux.dev,
        netdev@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v2 1/5] regulator: Add of_get_regulator_from_list
Date:   Wed, 18 May 2022 20:09:35 +0000
Message-Id: <20220518200939.689308-2-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220518200939.689308-1-clabbe@baylibre.com>
References: <20220518200939.689308-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

of_get_regulator_from_list() permits to get a regulator from a
regulators list.
Then add support for such list in of_get_regulator()

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/regulator/core.c | 44 ++++++++++++++++++++++++++++++++++++----
 1 file changed, 40 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 1e54a833f2cf..09578c3595de 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -351,6 +351,33 @@ static void regulator_lock_dependent(struct regulator_dev *rdev,
 	mutex_unlock(&regulator_list_mutex);
 }
 
+/**
+ * of_get_regulator_from_list - get a regulator device node based on supply name
+ * from a DT regulators list
+ * @dev: Device pointer for the consumer (of regulator) device
+ * @np: The device node where to search for regulators list
+ * @supply: regulator supply name
+ *
+ * Extract the regulator device node corresponding to the supply name.
+ * returns the device node corresponding to the regulator if found, else
+ * returns NULL.
+ */
+static struct device_node *of_get_regulator_from_list(struct device *dev,
+						      struct device_node *np,
+						      const char *supply)
+{
+	struct of_phandle_args regspec;
+	int index, ret;
+
+	index = of_property_match_string(np, "regulator-names", supply);
+	if (index >= 0) {
+		ret = of_parse_phandle_with_args(np, "regulators", NULL, index, &regspec);
+		if (ret == 0)
+			return regspec.np;
+	}
+	return NULL;
+}
+
 /**
  * of_get_child_regulator - get a child regulator device node
  * based on supply name
@@ -362,17 +389,23 @@ static void regulator_lock_dependent(struct regulator_dev *rdev,
  * returns the device node corresponding to the regulator if found, else
  * returns NULL.
  */
-static struct device_node *of_get_child_regulator(struct device_node *parent,
-						  const char *prop_name)
+static struct device_node *of_get_child_regulator(struct device *dev,
+						  struct device_node *parent,
+						  const char *supply)
 {
 	struct device_node *regnode = NULL;
 	struct device_node *child = NULL;
+	char prop_name[64]; /* 64 is max size of property name */
 
+	snprintf(prop_name, 64, "%s-supply", supply);
 	for_each_child_of_node(parent, child) {
+		regnode = of_get_regulator_from_list(dev, child, supply);
+		if (regnode)
+			return regnode;
 		regnode = of_parse_phandle(child, prop_name, 0);
 
 		if (!regnode) {
-			regnode = of_get_child_regulator(child, prop_name);
+			regnode = of_get_child_regulator(dev, child, prop_name);
 			if (regnode)
 				goto err_node_put;
 		} else {
@@ -401,12 +434,15 @@ static struct device_node *of_get_regulator(struct device *dev, const char *supp
 	char prop_name[64]; /* 64 is max size of property name */
 
 	dev_dbg(dev, "Looking up %s-supply from device tree\n", supply);
+	regnode = of_get_regulator_from_list(dev, dev->of_node, supply);
+	if (regnode)
+		return regnode;
 
 	snprintf(prop_name, 64, "%s-supply", supply);
 	regnode = of_parse_phandle(dev->of_node, prop_name, 0);
 
 	if (!regnode) {
-		regnode = of_get_child_regulator(dev->of_node, prop_name);
+		regnode = of_get_child_regulator(dev, dev->of_node, supply);
 		if (regnode)
 			return regnode;
 
-- 
2.35.1

