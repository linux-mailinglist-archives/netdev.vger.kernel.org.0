Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C465F5AECCC
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 16:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241558AbiIFOUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 10:20:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242247AbiIFOUE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 10:20:04 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E8762125F;
        Tue,  6 Sep 2022 06:51:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662472289; x=1694008289;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2vu7l/6K0nvkzNmUjyptRlngyguT+RoN4sYZnyNxAgU=;
  b=lRpy2C8F5k3gteHoI7LzQzY1HYFQcYvVxjUSsZIX/NHiz+2RtlOHU1Im
   dHvXt1eRbKcOPS67mVvWYudM+o7koDIsq/mpkm9/mjehBr/S36mCBHhgO
   eZ0ftE1Y0jEFuhbnLilaDGBogQc5eJvG/LP3PqfxcpGhfscmFoiGrrza0
   +SN8EqxS7L1y0ayvmmadYoS3U5g+2YcQCOAiZpm8Td6+5BNXtL3GkQTtf
   IckA7YINkx2vHFnndbLkG/iY/6clODhrfrRFORBmtJ8hrQerW0ZrDAGs4
   2Xi1y1tbg8VY+UYGLlq18SuPTAX21D7fCsBvueM1YJXuVhQrBDcG9OioG
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10462"; a="279610086"
X-IronPort-AV: E=Sophos;i="5.93,294,1654585200"; 
   d="scan'208";a="279610086"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2022 06:50:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,294,1654585200"; 
   d="scan'208";a="756372523"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga001.fm.intel.com with ESMTP; 06 Sep 2022 06:49:54 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 6F82145C; Tue,  6 Sep 2022 16:50:10 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Gene Chen <gene_chen@richtek.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Andrew Jeffery <andrew@aj.id.au>, linux-leds@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Pavel Machek <pavel@ucw.cz>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Lee Jones <lee@kernel.org>
Subject: [PATCH v3 03/11] leds: an30259a: Get rid of custom led_init_default_state_get()
Date:   Tue,  6 Sep 2022 16:49:56 +0300
Message-Id: <20220906135004.14885-4-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220906135004.14885-1-andriy.shevchenko@linux.intel.com>
References: <20220906135004.14885-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

LED core provides a helper to parse default state from firmware node.
Use it instead of custom implementation.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/leds/leds-an30259a.c | 21 ++++-----------------
 1 file changed, 4 insertions(+), 17 deletions(-)

diff --git a/drivers/leds/leds-an30259a.c b/drivers/leds/leds-an30259a.c
index e072ee5409f7..89df267853a9 100644
--- a/drivers/leds/leds-an30259a.c
+++ b/drivers/leds/leds-an30259a.c
@@ -55,10 +55,6 @@
 
 #define AN30259A_NAME "an30259a"
 
-#define STATE_OFF 0
-#define STATE_KEEP 1
-#define STATE_ON 2
-
 struct an30259a;
 
 struct an30259a_led {
@@ -66,7 +62,7 @@ struct an30259a_led {
 	struct fwnode_handle *fwnode;
 	struct led_classdev cdev;
 	u32 num;
-	u32 default_state;
+	enum led_default_state default_state;
 	bool sloping;
 };
 
@@ -205,7 +201,6 @@ static int an30259a_dt_init(struct i2c_client *client,
 	struct device_node *np = dev_of_node(&client->dev), *child;
 	int count, ret;
 	int i = 0;
-	const char *str;
 	struct an30259a_led *led;
 
 	count = of_get_available_child_count(np);
@@ -228,15 +223,7 @@ static int an30259a_dt_init(struct i2c_client *client,
 		led->num = source;
 		led->chip = chip;
 		led->fwnode = of_fwnode_handle(child);
-
-		if (!of_property_read_string(child, "default-state", &str)) {
-			if (!strcmp(str, "on"))
-				led->default_state = STATE_ON;
-			else if (!strcmp(str, "keep"))
-				led->default_state = STATE_KEEP;
-			else
-				led->default_state = STATE_OFF;
-		}
+		led->default_state = led_init_default_state_get(led->fwnode);
 
 		i++;
 	}
@@ -261,10 +248,10 @@ static void an30259a_init_default_state(struct an30259a_led *led)
 	int led_on, err;
 
 	switch (led->default_state) {
-	case STATE_ON:
+	case LEDS_DEFSTATE_ON:
 		led->cdev.brightness = LED_FULL;
 		break;
-	case STATE_KEEP:
+	case LEDS_DEFSTATE_KEEP:
 		err = regmap_read(chip->regmap, AN30259A_REG_LED_ON, &led_on);
 		if (err)
 			break;
-- 
2.35.1

