Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75FB76B9E0F
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 19:17:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbjCNSRw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 14:17:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbjCNSRu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 14:17:50 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6F2BA54D7;
        Tue, 14 Mar 2023 11:17:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678817865; x=1710353865;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=OenIRImHde+pgXvezYAFpYZp8WM0xB5xrRiHzQkLkXs=;
  b=KeE9vMQUKpYbFDIpSa/iwK+DRbZcQQl6NtVe8aAROBhTjvAAw1A/hdio
   6KTwnWAiAskvwtDZDb/VReHVyhnWA/5HxIhPgVNxHLJojJoMQZjlqg30R
   +ktpRpGB4gIK9qxsWrstB5/2q/0Y4F6hkFPsRZaIMKSCkyimr6V21pu9q
   h60SfvmwTetPAVVwG08hJo8x40WdJpi7aQoi0J6OcTmDnjw/VcXCIJRcm
   k+dfZBQ5mCvUn+5j8pujr7MKDf3/I8KshivAl9KxibRCX8GKV1KbOm6IB
   LQ+JuzDjFr/bEjmW5Nq4U2PnC+a40sLMUCdEEh/KV+cQUm3btfY+sS++T
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="317158372"
X-IronPort-AV: E=Sophos;i="5.98,260,1673942400"; 
   d="scan'208";a="317158372"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2023 11:17:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="748103333"
X-IronPort-AV: E=Sophos;i="5.98,260,1673942400"; 
   d="scan'208";a="748103333"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga004.fm.intel.com with ESMTP; 14 Mar 2023 11:17:42 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 64AD8163; Tue, 14 Mar 2023 20:18:27 +0200 (EET)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Kurt Kanzenbach <kurt@linutronix.de>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next v6 1/1] net: dsa: hellcreek: Get rid of custom led_init_default_state_get()
Date:   Tue, 14 Mar 2023 20:18:24 +0200
Message-Id: <20230314181824.56881-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

LED core provides a helper to parse default state from firmware node.
Use it instead of custom implementation.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>
---
v6: wrapped long lines (Simon, Jakub)
 drivers/net/dsa/hirschmann/hellcreek_ptp.c | 45 ++++++++++++----------
 1 file changed, 24 insertions(+), 21 deletions(-)

diff --git a/drivers/net/dsa/hirschmann/hellcreek_ptp.c b/drivers/net/dsa/hirschmann/hellcreek_ptp.c
index b28baab6d56a..3e44ccb7db84 100644
--- a/drivers/net/dsa/hirschmann/hellcreek_ptp.c
+++ b/drivers/net/dsa/hirschmann/hellcreek_ptp.c
@@ -297,7 +297,8 @@ static enum led_brightness hellcreek_led_is_gm_get(struct led_classdev *ldev)
 static int hellcreek_led_setup(struct hellcreek *hellcreek)
 {
 	struct device_node *leds, *led = NULL;
-	const char *label, *state;
+	enum led_default_state state;
+	const char *label;
 	int ret = -EINVAL;
 
 	of_node_get(hellcreek->dev->of_node);
@@ -318,16 +319,17 @@ static int hellcreek_led_setup(struct hellcreek *hellcreek)
 	ret = of_property_read_string(led, "label", &label);
 	hellcreek->led_sync_good.name = ret ? "sync_good" : label;
 
-	ret = of_property_read_string(led, "default-state", &state);
-	if (!ret) {
-		if (!strcmp(state, "on"))
-			hellcreek->led_sync_good.brightness = 1;
-		else if (!strcmp(state, "off"))
-			hellcreek->led_sync_good.brightness = 0;
-		else if (!strcmp(state, "keep"))
-			hellcreek->led_sync_good.brightness =
-				hellcreek_get_brightness(hellcreek,
-							 STATUS_OUT_SYNC_GOOD);
+	state = led_init_default_state_get(of_fwnode_handle(led));
+	switch (state) {
+	case LEDS_DEFSTATE_ON:
+		hellcreek->led_sync_good.brightness = 1;
+		break;
+	case LEDS_DEFSTATE_KEEP:
+		hellcreek->led_sync_good.brightness =
+			hellcreek_get_brightness(hellcreek, STATUS_OUT_SYNC_GOOD);
+		break;
+	default:
+		hellcreek->led_sync_good.brightness = 0;
 	}
 
 	hellcreek->led_sync_good.max_brightness = 1;
@@ -344,16 +346,17 @@ static int hellcreek_led_setup(struct hellcreek *hellcreek)
 	ret = of_property_read_string(led, "label", &label);
 	hellcreek->led_is_gm.name = ret ? "is_gm" : label;
 
-	ret = of_property_read_string(led, "default-state", &state);
-	if (!ret) {
-		if (!strcmp(state, "on"))
-			hellcreek->led_is_gm.brightness = 1;
-		else if (!strcmp(state, "off"))
-			hellcreek->led_is_gm.brightness = 0;
-		else if (!strcmp(state, "keep"))
-			hellcreek->led_is_gm.brightness =
-				hellcreek_get_brightness(hellcreek,
-							 STATUS_OUT_IS_GM);
+	state = led_init_default_state_get(of_fwnode_handle(led));
+	switch (state) {
+	case LEDS_DEFSTATE_ON:
+		hellcreek->led_is_gm.brightness = 1;
+		break;
+	case LEDS_DEFSTATE_KEEP:
+		hellcreek->led_is_gm.brightness =
+			hellcreek_get_brightness(hellcreek, STATUS_OUT_IS_GM);
+		break;
+	default:
+		hellcreek->led_is_gm.brightness = 0;
 	}
 
 	hellcreek->led_is_gm.max_brightness = 1;
-- 
2.39.2

