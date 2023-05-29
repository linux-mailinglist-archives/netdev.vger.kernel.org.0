Return-Path: <netdev+bounces-6144-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 81E50714E80
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 18:36:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3D71B280F63
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 16:36:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B72BCC2D1;
	Mon, 29 May 2023 16:34:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6432C8D2
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 16:34:49 +0000 (UTC)
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F6A9AD;
	Mon, 29 May 2023 09:34:48 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id ffacd0b85a97d-30addbb1b14so1753872f8f.2;
        Mon, 29 May 2023 09:34:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685378086; x=1687970086;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=v7RZChTfO9Ux9viKPzKi7S1xLwMfKhuE6t9va88Kj50=;
        b=AGsYyhVI5kNmN5PnHbyAXfKvH5U3q97ntL9KrHbuSjhfLQY8cpbNEdjVyTw7hqsTpn
         lvxaldiA3oamz7vZBmwo+MWN9rLMHR7wILiIC/Hfh2rgw3YIdhAKTkq9ZxS5ml21id8P
         eDPsvJRMGePqXg2dFvbK4VWRIng/L892IN0Pa9oWyenjnmagENGaz1zYzgcKGDZGNR8B
         zRWfJSgT74T26+Hwz2v4/hleOyEW3lKQmVY/RwGlcF8PFwp5Ih+IPP8+329xPfO3zrGX
         KnZxGQF7A6KNLQk1a8JJESnbJsRMvMRBS+b3GFHqwEkjwdYQJyNsb9RABVdqRr0FpWSv
         RZJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685378086; x=1687970086;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v7RZChTfO9Ux9viKPzKi7S1xLwMfKhuE6t9va88Kj50=;
        b=GK4sYtpp0esVw83PNJZySPV2G5+TfeJFdoZW8YiWsJfou6hXN0BjpHOn40IutNCw79
         dKIr3lQYPRWfpokw5qGkaVLjyzep4g5wi9EpFxBWuRqqRBoGCUc8e8mep4jS74D9f1fk
         oro78TdnAkfq/lXa9pAner1CHGDuHCdeeJTM95mZM9XQ8BPIc2MVlq0wVYRgG6vFJjw8
         h6S8eturMUCLP1DHK2Bym7zXfzmr5PIEmyCCWE2pXehQ5XitFxGo47JYSSN4Zysl6hqV
         naEKUdrp8h75Y0mThXN6jOeMq7bELPDEqYhfARBxp94vK01H1dKDNZqnunr1lL5fafJY
         fdhA==
X-Gm-Message-State: AC+VfDxhLUOrJDckY90osPm93yqjl3qjW/ma3vMsn5v52aEVKtGAbH4V
	96wJkHO7vOfCIZ2dMuoelsw=
X-Google-Smtp-Source: ACHHUZ7EQ27ufb9yRv07KB/RaaMNYy3yoCBZn/kDDSMKdcDvOKtbZzfr6rT4CKjth5yKt5FwoYaVZg==
X-Received: by 2002:adf:e792:0:b0:306:340c:4737 with SMTP id n18-20020adfe792000000b00306340c4737mr8892359wrm.67.1685378086515;
        Mon, 29 May 2023 09:34:46 -0700 (PDT)
Received: from localhost.localdomain (93-34-93-173.ip49.fastwebnet.it. [93.34.93.173])
        by smtp.googlemail.com with ESMTPSA id h14-20020a5d6e0e000000b002ff2c39d072sm417513wrz.104.2023.05.29.09.34.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 May 2023 09:34:46 -0700 (PDT)
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
Subject: [net-next PATCH v4 04/13] leds: trigger: netdev: refactor code setting device name
Date: Mon, 29 May 2023 18:32:34 +0200
Message-Id: <20230529163243.9555-5-ansuelsmth@gmail.com>
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

Move the code into a helper, ready for it to be called at
other times. No intended behaviour change.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/leds/trigger/ledtrig-netdev.c | 29 ++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/leds/trigger/ledtrig-netdev.c b/drivers/leds/trigger/ledtrig-netdev.c
index 305eb543ba84..c93ac3bc85a6 100644
--- a/drivers/leds/trigger/ledtrig-netdev.c
+++ b/drivers/leds/trigger/ledtrig-netdev.c
@@ -104,15 +104,9 @@ static ssize_t device_name_show(struct device *dev,
 	return len;
 }
 
-static ssize_t device_name_store(struct device *dev,
-				 struct device_attribute *attr, const char *buf,
-				 size_t size)
+static int set_device_name(struct led_netdev_data *trigger_data,
+			   const char *name, size_t size)
 {
-	struct led_netdev_data *trigger_data = led_trigger_get_drvdata(dev);
-
-	if (size >= IFNAMSIZ)
-		return -EINVAL;
-
 	cancel_delayed_work_sync(&trigger_data->work);
 
 	mutex_lock(&trigger_data->lock);
@@ -122,7 +116,7 @@ static ssize_t device_name_store(struct device *dev,
 		trigger_data->net_dev = NULL;
 	}
 
-	memcpy(trigger_data->device_name, buf, size);
+	memcpy(trigger_data->device_name, name, size);
 	trigger_data->device_name[size] = 0;
 	if (size > 0 && trigger_data->device_name[size - 1] == '\n')
 		trigger_data->device_name[size - 1] = 0;
@@ -140,6 +134,23 @@ static ssize_t device_name_store(struct device *dev,
 	set_baseline_state(trigger_data);
 	mutex_unlock(&trigger_data->lock);
 
+	return 0;
+}
+
+static ssize_t device_name_store(struct device *dev,
+				 struct device_attribute *attr, const char *buf,
+				 size_t size)
+{
+	struct led_netdev_data *trigger_data = led_trigger_get_drvdata(dev);
+	int ret;
+
+	if (size >= IFNAMSIZ)
+		return -EINVAL;
+
+	ret = set_device_name(trigger_data, buf, size);
+
+	if (ret < 0)
+		return ret;
 	return size;
 }
 
-- 
2.39.2


