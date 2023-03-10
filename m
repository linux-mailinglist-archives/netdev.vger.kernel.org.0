Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC986B4D57
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 17:43:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231493AbjCJQm5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 11:42:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231263AbjCJQmh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 11:42:37 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0E2B3C33;
        Fri, 10 Mar 2023 08:40:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678466422; x=1710002422;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=xmjvRkk2u1w6wR6YUli7dg1Fh8HG6Z/p1SZNWVWgCDU=;
  b=bxH3twfzKf58a3MRBumNLFY010XYa7WynZo5kSPjbAlfvsQ8PcMP5vgI
   7QfNBHPL2jJ7oOf0jAJmg4ZcZG0xqxpR/qazqyo/lqRmxtf9rPLsiEEcR
   9UhHMQlr/5dO5MdsMzttCMatidutUOiV9VO1BnVp6x54+uE/WFtOMxjPv
   vZyPoKxqa2JCEcJqlYRW98ioWnh6JrpfPi7JJTCHQEqs6+E2773/ts+xL
   qauniqM6K2TLQLU7RDEn6RmzRF+osj0+KQOWvmDac7TXMUIzn9etpt6jS
   OW34KI+36731cwpKUh0qqMavgyiZqHy3fYPLoR3Qv2JaNUvW6ta/9t6ib
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10645"; a="338322249"
X-IronPort-AV: E=Sophos;i="5.98,250,1673942400"; 
   d="scan'208";a="338322249"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2023 08:38:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10645"; a="671144118"
X-IronPort-AV: E=Sophos;i="5.98,250,1673942400"; 
   d="scan'208";a="671144118"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga007.jf.intel.com with ESMTP; 10 Mar 2023 08:38:14 -0800
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 28B06143; Fri, 10 Mar 2023 18:38:57 +0200 (EET)
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
Subject: [PATCH net-next v5 1/1] net: dsa: hellcreek: Get rid of custom led_init_default_state_get()
Date:   Fri, 10 Mar 2023 18:38:55 +0200
Message-Id: <20230310163855.21757-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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
v5: resent after v6.3-rc1 with proper net-next prefix
 drivers/net/dsa/hirschmann/hellcreek_ptp.c | 45 ++++++++++++----------
 1 file changed, 24 insertions(+), 21 deletions(-)

diff --git a/drivers/net/dsa/hirschmann/hellcreek_ptp.c b/drivers/net/dsa/hirschmann/hellcreek_ptp.c
index b28baab6d56a..793b2c296314 100644
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
+				hellcreek_get_brightness(hellcreek, STATUS_OUT_SYNC_GOOD);
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
+				hellcreek_get_brightness(hellcreek, STATUS_OUT_IS_GM);
+		break;
+	default:
+		hellcreek->led_is_gm.brightness = 0;
 	}
 
 	hellcreek->led_is_gm.max_brightness = 1;
-- 
2.39.1

