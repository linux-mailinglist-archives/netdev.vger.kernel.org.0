Return-Path: <netdev+bounces-6145-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 19723714E81
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 18:36:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C6B4A280F97
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 16:36:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2519D50B;
	Mon, 29 May 2023 16:34:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96C0DD30B
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 16:34:50 +0000 (UTC)
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B60DA3;
	Mon, 29 May 2023 09:34:49 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id ffacd0b85a97d-30ae967ef74so839283f8f.0;
        Mon, 29 May 2023 09:34:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685378088; x=1687970088;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Gfvrz5G3XlnZ2Vf1vClzhgeEjYoUMrP7las42y0bA9Q=;
        b=Etqzt3m1D0bdS7EJCaFaYCnfOToBbs2idvHlXP9DUF0SI74sS/sQvkccvcvNwVNp9V
         QhkpbtiTro0KWvvvTgDn/avcEwI7wi6o4O2U31SsGtyeNsXzj7Aey3HEIdZiQPoh2wt0
         PZjIJezCeUcKrF++EI9kwmjIKeCdbYyhJsktPfkz91TrS/npaOzImsDK/icmwXhnkRbx
         vz4oRECuV71wONKIhbwI1X86Xxl/I7nH043o7//5Z87LWaXbUYIkEplaa6WTSGsjr+Bk
         o+4VVUvyOPYqsVw6HpAQEWkXIFc4vrRB5he1VLoaQh8y4PAKjDnYMGH6Bj1sYcZTQKVM
         wfUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685378088; x=1687970088;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Gfvrz5G3XlnZ2Vf1vClzhgeEjYoUMrP7las42y0bA9Q=;
        b=TpInGGrfD6QUXuspxtC0yCS5XF5rb5Fwr4ZDZGeu5/vbhbE3KskFHP3EscJpVx1MQs
         RbmIZgb2Nex3XL2cQa3syPxGy3bpeTY+fJRJnVruBmKfY5k6wGnwddZ7QtO3tkQYHrOE
         XEjZtZa6pur9FLhBXsslbCrme5Qpjm8k5CRtulLXqyzqUaBGXsvPMzmo/lM32oGnmABS
         /E8PyH/U8+rtsvUxXR5L7XUZzEua/heIgNIRIofV5Homo+YQIh1+9p1c7LS0SN+A5k6l
         vPbKrBnQe1KB2pErDj20iL1XXjJR2Su9hcaaEhZf5MwCYH0RtBfbpVLj3pnkAzGxqSTO
         +G8g==
X-Gm-Message-State: AC+VfDw6GdbgTtm0abQU/CELwgaJbnVHTFdPAEd3prx9doNRAfkFo01T
	TlfSx3C4WoZCAJEFVBANeoM=
X-Google-Smtp-Source: ACHHUZ7+larGJmqw2AZBA7u9cay97RHZujQ31A+rcyfXytbbFvHbHQe/P/4ZHvEqu4ZrI8xBA4ZUPg==
X-Received: by 2002:adf:fc50:0:b0:30a:bdfd:5c3c with SMTP id e16-20020adffc50000000b0030abdfd5c3cmr10863252wrs.17.1685378087601;
        Mon, 29 May 2023 09:34:47 -0700 (PDT)
Received: from localhost.localdomain (93-34-93-173.ip49.fastwebnet.it. [93.34.93.173])
        by smtp.googlemail.com with ESMTPSA id h14-20020a5d6e0e000000b002ff2c39d072sm417513wrz.104.2023.05.29.09.34.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 May 2023 09:34:47 -0700 (PDT)
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
Subject: [net-next PATCH v4 05/13] leds: trigger: netdev: introduce check for possible hw control
Date: Mon, 29 May 2023 18:32:35 +0200
Message-Id: <20230529163243.9555-6-ansuelsmth@gmail.com>
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

Introduce function to check if the requested mode can use hw control in
preparation for hw control support. Currently everything is handled in
software so can_hw_control will always return false.

Add knob with the new value hw_control in trigger_data struct to
set hw control possible. Useful for future implementation to implement
in set_baseline_state() the required function to set the requested mode
using LEDs hw control ops and in other function to reject set if hw
control is currently active.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/leds/trigger/ledtrig-netdev.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/leds/trigger/ledtrig-netdev.c b/drivers/leds/trigger/ledtrig-netdev.c
index c93ac3bc85a6..e1f3cedd5d57 100644
--- a/drivers/leds/trigger/ledtrig-netdev.c
+++ b/drivers/leds/trigger/ledtrig-netdev.c
@@ -51,6 +51,7 @@ struct led_netdev_data {
 
 	unsigned long mode;
 	bool carrier_link_up;
+	bool hw_control;
 };
 
 enum led_trigger_netdev_modes {
@@ -91,6 +92,11 @@ static void set_baseline_state(struct led_netdev_data *trigger_data)
 	}
 }
 
+static bool can_hw_control(struct led_netdev_data *trigger_data)
+{
+	return false;
+}
+
 static ssize_t device_name_show(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
@@ -204,6 +210,8 @@ static ssize_t netdev_led_attr_store(struct device *dev, const char *buf,
 	else
 		clear_bit(bit, &trigger_data->mode);
 
+	trigger_data->hw_control = can_hw_control(trigger_data);
+
 	set_baseline_state(trigger_data);
 
 	return size;
-- 
2.39.2


