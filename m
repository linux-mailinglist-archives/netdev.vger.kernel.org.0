Return-Path: <netdev+bounces-5880-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E5988713473
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 13:31:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A1F49281298
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 11:31:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE30111CA3;
	Sat, 27 May 2023 11:29:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1E4911CA1
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 11:29:25 +0000 (UTC)
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 404C710E;
	Sat, 27 May 2023 04:29:22 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id 5b1f17b1804b1-3f6094cb2d2so16690365e9.2;
        Sat, 27 May 2023 04:29:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685186960; x=1687778960;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DnUn0MEBWwXZf1tNVwC84UFbfwX24B+J30/BoHmbFJQ=;
        b=WDG8dMQW2OJkDbZJwqovUVF48h94OIk058AqmVj43fg7xKPIaWYRt9Bwx8HNbSCHAr
         TlUCxKk8z35xCy7U+Nbu91//2NJz6krRzUhYXe/e6IeURArepUOYjtlaFDtFJXNYoel9
         osOGqPPt5DvKQ4f2UUh5GN/UY5NuOioubpYsuTE6VxH51Ax7t+y3GMTUOE/MfQFcMajO
         nMITJWFN0uk0vMLCYza86euM7GigVDEy3xAE963zR6sz6AeTizSNUl8ysB/BnRoBoca4
         10lWB6jCuVtTFoFF2DTNMrEFWateUji3hHDI/P/mz+SoSr/3fiViZY3d/uWzACfSceFw
         maqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685186960; x=1687778960;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DnUn0MEBWwXZf1tNVwC84UFbfwX24B+J30/BoHmbFJQ=;
        b=NlCEKwMugop4lw9CewOkvDXahK4owqibc7Yjn0P84lghWw8OofWf2JwPc/RYTJagX2
         Oxjj3c6wFeUsS8pNWM1KC1OF8o03NFtFTwbMH9nQLHDXoFaQFixWqzBkp2QeDW+6ZcEL
         ugtZFihgkKji3AJ0agbKdqw06GWRE88J59KRg8wmRU9WR+9DvinzdTj/bV1Qc0iQH4zU
         orpbqqVBrqWHq0LWhxMxE6xEyJoDkosSCoT6R1sUZh1uaddf6tK7D8VY37V3P8Jt5ilp
         +YDtlvrqPArVKFPnH8L2/LzOASOXEUwf8HM2TC4KrRllpUFt91bit4uqgEBPk/COEw0F
         KmuA==
X-Gm-Message-State: AC+VfDyMrBFgPj/eoHMn998dkM9gdHcfO+iNDl3owsfLw7yx5sIMRt9V
	Y3pXfjmCmMI2DmHJKS6Y9MY=
X-Google-Smtp-Source: ACHHUZ6JTM8XbpmvCJlxYj8Rtvz6dBuZ+ot4DFiudILzmBmNW2iG45IvJ6F2Xx2tycvqnv61PTr8bg==
X-Received: by 2002:a05:600c:22d7:b0:3f5:fb98:729e with SMTP id 23-20020a05600c22d700b003f5fb98729emr4048371wmg.22.1685186960578;
        Sat, 27 May 2023 04:29:20 -0700 (PDT)
Received: from localhost.localdomain (93-34-93-173.ip49.fastwebnet.it. [93.34.93.173])
        by smtp.googlemail.com with ESMTPSA id q13-20020a7bce8d000000b003f43f82001asm11711000wmj.31.2023.05.27.04.29.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 May 2023 04:29:20 -0700 (PDT)
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
Subject: [net-next PATCH v3 05/13] leds: trigger: netdev: introduce check for possible hw control
Date: Sat, 27 May 2023 13:28:46 +0200
Message-Id: <20230527112854.2366-6-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230527112854.2366-1-ansuelsmth@gmail.com>
References: <20230527112854.2366-1-ansuelsmth@gmail.com>
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


