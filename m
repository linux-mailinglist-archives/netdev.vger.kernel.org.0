Return-Path: <netdev+bounces-6153-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DF4C714E93
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 18:38:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E948E1C20AC8
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 16:38:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE2288C13;
	Mon, 29 May 2023 16:35:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1DA41118C
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 16:35:02 +0000 (UTC)
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6CABA3;
	Mon, 29 May 2023 09:34:57 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id ffacd0b85a97d-30ae95c4e75so1398747f8f.2;
        Mon, 29 May 2023 09:34:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685378096; x=1687970096;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2brWjtv6jnUkszMlshgHY3ZyYZyBqSw+5iV+JVswSb0=;
        b=PjaUxclvYxLTW+lF+DMGV+Jv8MEZNZ48mOXSHw8P4awEet1eXJ5A0YPEO3/8Eqevmw
         blDshi3XLKUYNdwRqfPDn8d7ahZMcI40Hg/lvp17xkG6LsKo7J1shlFx7IstEZoOL/Pt
         3sq86mz8+BFxA5kx1vZnOALKb/NdvyChZ/I9eP6LArMu4kfTVoEWyr0/U0UOHvLuXlr1
         a9bGeCMGf3Urc/0+PRvtBsi6U8ozhpcGAAWUuEGuAkBak6qHWyqXWzr1iOs+2LWHZn8/
         QpEEDgdT6U2YMbkHq2YHi4oh5zqjrQSoo5lYDLqgKiIpvNc+GTBYuEAumwZ7Zqjmnkc6
         KxTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685378096; x=1687970096;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2brWjtv6jnUkszMlshgHY3ZyYZyBqSw+5iV+JVswSb0=;
        b=Aa6LMu7OYe3pPHNLLjMu48zja1sa2LWeas5uozPU7R5Wafw4EzSwqVC2dR1Ksjndwu
         cNJElt7aTc62ndA8MBXtqSamMh1DTxadhNif57caU08bdsxO194JCWtn9hwxq/NECUlZ
         VfivfGIaQvmsOsFXaGA1V0Eodnh+TR5RoL34x82tz/RCLo6vXLD0hwMw6oHqGHh3sGjl
         O5MHcwnRxZom9P6QCS75CUNxKN154vpAkM4DTeovDnVPby/TxFp1jLiN5GGk8EKqOGdJ
         kC2ydiW3lQJ+8WI7XDGTtOh5PEhTj9oxeN4IUqS3jqgIFK0QEMrvxu/iXib083eS8iWN
         BPSA==
X-Gm-Message-State: AC+VfDytNtnzUCpbi8bI8gevQMI551CxRHsM8OxkZXZ2sgVUu5M4dwg1
	9+Q7eKbLzjNuIsJUMx/dfB8=
X-Google-Smtp-Source: ACHHUZ6RL7TiSPhTjCPyiPugSHdtdBflwvIkfNfQqsCcVJduqysNI6L2eRQsrRql66UqpTpkmKCiiQ==
X-Received: by 2002:a5d:6e53:0:b0:2f8:2d4:74ef with SMTP id j19-20020a5d6e53000000b002f802d474efmr9368337wrz.43.1685378096172;
        Mon, 29 May 2023 09:34:56 -0700 (PDT)
Received: from localhost.localdomain (93-34-93-173.ip49.fastwebnet.it. [93.34.93.173])
        by smtp.googlemail.com with ESMTPSA id h14-20020a5d6e0e000000b002ff2c39d072sm417513wrz.104.2023.05.29.09.34.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 May 2023 09:34:55 -0700 (PDT)
From: Christian Marangi <ansuelsmth@gmail.com>
To: Pavel Machek <pavel@ucw.cz>,
	Lee Jones <lee@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Christian Marangi <ansuelsmth@gmail.com>,
	linux-leds@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [net-next PATCH v4 13/13] net: dsa: qca8k: add op to get ports netdev
Date: Mon, 29 May 2023 18:32:43 +0200
Message-Id: <20230529163243.9555-14-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230529163243.9555-1-ansuelsmth@gmail.com>
References: <20230529163243.9555-1-ansuelsmth@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Andrew Lunn <andrew@lunn.ch>

In order that the LED trigger can blink the switch MAC ports LED, it
needs to know the netdev associated to the port. Add the callback to
return the struct device of the netdev.

Add an helper function qca8k_phy_to_port() to convert the phy back to
dsa_port index, as we reference LED port based on the internal PHY
index and needs to be converted back.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca/qca8k-leds.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/net/dsa/qca/qca8k-leds.c b/drivers/net/dsa/qca/qca8k-leds.c
index 1e0c61726487..6f02029b454b 100644
--- a/drivers/net/dsa/qca/qca8k-leds.c
+++ b/drivers/net/dsa/qca/qca8k-leds.c
@@ -5,6 +5,18 @@
 #include "qca8k.h"
 #include "qca8k_leds.h"
 
+static u32 qca8k_phy_to_port(int phy)
+{
+	/* Internal PHY 0 has port at index 1.
+	 * Internal PHY 1 has port at index 2.
+	 * Internal PHY 2 has port at index 3.
+	 * Internal PHY 3 has port at index 4.
+	 * Internal PHY 4 has port at index 5.
+	 */
+
+	return phy + 1;
+}
+
 static int
 qca8k_get_enable_led_reg(int port_num, int led_num, struct qca8k_led_pattern_en *reg_info)
 {
@@ -314,6 +326,20 @@ qca8k_cled_hw_control_get(struct led_classdev *ldev, unsigned long *rules)
 	return 0;
 }
 
+static struct device *qca8k_cled_hw_control_get_device(struct led_classdev *ldev)
+{
+	struct qca8k_led *led = container_of(ldev, struct qca8k_led, cdev);
+	struct qca8k_priv *priv = led->priv;
+	struct dsa_port *dp;
+
+	dp = dsa_to_port(priv->ds, qca8k_phy_to_port(led->port_num));
+	if (!dp)
+		return NULL;
+	if (dp->slave)
+		return &dp->slave->dev;
+	return NULL;
+}
+
 static int
 qca8k_parse_port_leds(struct qca8k_priv *priv, struct fwnode_handle *port, int port_num)
 {
@@ -377,6 +403,7 @@ qca8k_parse_port_leds(struct qca8k_priv *priv, struct fwnode_handle *port, int p
 		port_led->cdev.hw_control_is_supported = qca8k_cled_hw_control_is_supported;
 		port_led->cdev.hw_control_set = qca8k_cled_hw_control_set;
 		port_led->cdev.hw_control_get = qca8k_cled_hw_control_get;
+		port_led->cdev.hw_control_get_device = qca8k_cled_hw_control_get_device;
 		port_led->cdev.hw_control_trigger = "netdev";
 		init_data.default_label = ":port";
 		init_data.fwnode = led;
-- 
2.39.2


