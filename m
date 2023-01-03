Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 879B465C07C
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 14:12:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237657AbjACNMg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 08:12:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233197AbjACNMf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 08:12:35 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9438FFAF4;
        Tue,  3 Jan 2023 05:12:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672751554; x=1704287554;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2vu7l/6K0nvkzNmUjyptRlngyguT+RoN4sYZnyNxAgU=;
  b=Swr37CLj2gh1BsOP9p5cf1C484uGxngOH57/mgOpKpilAQKS1YFXs1Bs
   0ObO9JcQVrQRJ7JKS+4171kNy05X0JDL6792qxriiEZGg/9yvhmoZ7//J
   bFu2jKsyTO3/3CDdERqxQIN7SKRC4usiB9o7ODkvKMp/Ia2C9mT1+8mmp
   Ja6b64A8xZRAX/MeVIWhnp72MgmcFGXu3mERgV1YGRFDaYE8fPWCMV3Ct
   kbIqFhHm6WnmQhjyzBb6PZ8sjYS9yUMJIFPfOlqjihlTxN6b2os6O9s4L
   /RgfcYO363IPmYwW1Y1erlNI6MFWWytRD5vdL5FzqkJ67hudyLCkmeLsy
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10579"; a="320367246"
X-IronPort-AV: E=Sophos;i="5.96,297,1665471600"; 
   d="scan'208";a="320367246"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2023 05:12:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10579"; a="654781131"
X-IronPort-AV: E=Sophos;i="5.96,297,1665471600"; 
   d="scan'208";a="654781131"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga002.jf.intel.com with ESMTP; 03 Jan 2023 05:12:28 -0800
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 91CA1220; Tue,  3 Jan 2023 15:13:00 +0200 (EET)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Gene Chen <gene_chen@richtek.com>, linux-leds@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH v4 03/11] leds: an30259a: Get rid of custom led_init_default_state_get()
Date:   Tue,  3 Jan 2023 15:12:48 +0200
Message-Id: <20230103131256.33894-4-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230103131256.33894-1-andriy.shevchenko@linux.intel.com>
References: <20230103131256.33894-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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

