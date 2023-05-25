Return-Path: <netdev+bounces-5356-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F383710ED6
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 16:56:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F00731C20F14
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 14:56:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 565A5156FD;
	Thu, 25 May 2023 14:55:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AF5D1953B
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 14:55:03 +0000 (UTC)
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BF351A2;
	Thu, 25 May 2023 07:54:58 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id ffacd0b85a97d-30950eecc1eso2201946f8f.0;
        Thu, 25 May 2023 07:54:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685026497; x=1687618497;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DnUn0MEBWwXZf1tNVwC84UFbfwX24B+J30/BoHmbFJQ=;
        b=L9qwhIRWPN7xyd6AokoG8VTDGdDWR0L7KqH3rLfrbc5v1iJ0RyI/+ZbyjyaqdQ+IMw
         oZIZ9fDJb9afTTL9au7yZ3fBpDKj0ReZdoE3UaKYjdCOpNlxFwkUiYBomJXTRuz2L1R3
         Rjo3HG6I/yuzEEWkB5xdQhOhodUR0HGbRrhRZPpD/GxBSrm1sv3Bj9I406qKDXE7O/HN
         cRFg3c0VULqJWe/x7KIKX0vQul/HDrrz9zzIJnQRwtrneYu7BbZnqZ9qhDQyoJ/IXGGh
         DHk4wWtlfzCix5OLsnSuswYeuKSbpmvIkjL4RLffO/sHMK4kLOJz2xqnHtLN+XXTqq8o
         SjBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685026497; x=1687618497;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DnUn0MEBWwXZf1tNVwC84UFbfwX24B+J30/BoHmbFJQ=;
        b=CqauxSNpFBzgy1mo/jo5q9XWJhX/iE2avJFxwsyagHaHuD1lCRWB1Vi9qyUBsusfIA
         X+GeYiFbDHdzPrmiAaFUTxlGwiNZ5tmGDAriU07xLgqevflaNX1oaca+xNw4aZyVt8Iu
         PEVjFXMJtWM8O/lzwWyYMe4d41TmHbpi0I5+3TDTqQwnaazzw4FgyefwajMXwO3iN59D
         r2jSIU/lUrd+PxjTCQzwoG/mZ9OfwRUBjBysSMm3F2zKdqgdQHBRJRoSIo/0WWzkyJbA
         0IN/7lrzHHhYpwfA5I4hSo6GkEVvsypsiYsjoVpNM79qq4UrFvWwBiWkdpKoxCxS9Lnb
         Iu4g==
X-Gm-Message-State: AC+VfDxfBkX1Z/mu0xZSyJUFYckRfGtvAfCoRXAuMs5ClOvM0hc9N7Ca
	gNBf7gCXUCvYc41vZ5VLkhM=
X-Google-Smtp-Source: ACHHUZ5CVkcObPO9Hg/AfVvSZBzuvp2/TDjypLE6kc/nI7adGWqjTwT6zmI91cCpLsiTNe1cCLlROQ==
X-Received: by 2002:adf:e889:0:b0:307:8b3e:285a with SMTP id d9-20020adfe889000000b003078b3e285amr2532887wrm.67.1685026496547;
        Thu, 25 May 2023 07:54:56 -0700 (PDT)
Received: from localhost.localdomain (93-34-93-173.ip49.fastwebnet.it. [93.34.93.173])
        by smtp.googlemail.com with ESMTPSA id t11-20020a5d49cb000000b0030732d6e104sm2048043wrs.105.2023.05.25.07.54.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 May 2023 07:54:56 -0700 (PDT)
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
Subject: [net-next PATCH v2 05/13] leds: trigger: netdev: introduce check for possible hw control
Date: Thu, 25 May 2023 16:53:53 +0200
Message-Id: <20230525145401.27007-6-ansuelsmth@gmail.com>
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

Introduce function to check if the requested mode can use hw control in
preparation for hw control support. Currently everything is handled in
software so can_hw_control will always return false.

Add knob with the new value hw_control in trigger_data struct to
set hw control possible. Useful for future implementation to implement
in set_baseline_state() the required function to set the requested mode
using LEDs hw control ops and in other function to reject set if hw
control is currently active.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
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


