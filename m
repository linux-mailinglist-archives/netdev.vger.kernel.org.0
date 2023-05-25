Return-Path: <netdev+bounces-5364-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D22CE710EE1
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 16:59:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 87BE928123D
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 14:59:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 469CF1DDCF;
	Thu, 25 May 2023 14:55:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32B771DDC7
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 14:55:16 +0000 (UTC)
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AF68E5B;
	Thu, 25 May 2023 07:55:07 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id ffacd0b85a97d-30abe551605so571687f8f.0;
        Thu, 25 May 2023 07:55:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685026506; x=1687618506;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2brWjtv6jnUkszMlshgHY3ZyYZyBqSw+5iV+JVswSb0=;
        b=ATW5FjSkc8+LeJen8N96L64Cv/XuM3/+5piHXR5L9DCEwvhve894Mj3u9Lq4qXpl/R
         Escdv7P9zeYiO0rcIcXpExtAXBYESfM5e4Nrn8bVIfkLBX4A9EAfeP1gfWR1qnxW70jz
         uVpJeJ/eT05fcOzj2TYh3g77krIItZfH1omqVZy84vdbA9YDOPsdcUlwpYSpx/G5qZpE
         LHKrB3Sc+sogLi69zxFail268I2eanBEQLm6yf3/4yVicFoYFnLcXsFqKiOQFwfoS1pF
         ZskHcC6tob4Cn9xsAsFVDSepvUMDBB+X4ocpU27Vf+d7c4tEPDXO1KhzRG7NxgKR3Scb
         VMBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685026506; x=1687618506;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2brWjtv6jnUkszMlshgHY3ZyYZyBqSw+5iV+JVswSb0=;
        b=Yjud0isSa43NSAnxfdi2Csdz2XfUT4o6nMmmrdQwaoNG/ZlxzyEnrcPat4ngw4E5V1
         OT0s2bmx7SXykaMgFgM6UPP0tEeaA7XEsVIxULSLxoHC+r12C9jq3bIkguwDK/Ej5PZe
         G7lekALOtxpDHdwnjGsRAPejx3495jK7A0ljk37dZsmwUf4JNul13/ov4qUB/Ek6he3/
         Hy4GFDTrESsb6SLjkUpdzR1eCbQIfvNqx6HIwyA/ZZiu8BJvH8yAP+FlwiSaGEw4uYoS
         h43w0dAOJc94iODSdrAayoC4XSXZYhFFGDYEdy9lS4R1oRu9/FbddKnkqMcwSxKucwHm
         /J9A==
X-Gm-Message-State: AC+VfDwu9D/Bxq19PIf6UV6sBKhrgTh5p2QrB4kIeUDtnTSErxn/4FVD
	csSpGuEUAjTnKg8HJDqhXlg=
X-Google-Smtp-Source: ACHHUZ58P0U9MxDchr+fThvUXgeeJk51K21NM20v427978A+OBHbHJ9eKQ3aZ9NHaULcDORs4dHUYQ==
X-Received: by 2002:a5d:550e:0:b0:30a:8999:3b9 with SMTP id b14-20020a5d550e000000b0030a899903b9mr2375180wrv.28.1685026505540;
        Thu, 25 May 2023 07:55:05 -0700 (PDT)
Received: from localhost.localdomain (93-34-93-173.ip49.fastwebnet.it. [93.34.93.173])
        by smtp.googlemail.com with ESMTPSA id t11-20020a5d49cb000000b0030732d6e104sm2048043wrs.105.2023.05.25.07.55.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 May 2023 07:55:05 -0700 (PDT)
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
Subject: [net-next PATCH v2 13/13] net: dsa: qca8k: add op to get ports netdev
Date: Thu, 25 May 2023 16:54:01 +0200
Message-Id: <20230525145401.27007-14-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230525145401.27007-1-ansuelsmth@gmail.com>
References: <20230525145401.27007-1-ansuelsmth@gmail.com>
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


