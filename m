Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5215D698A06
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 02:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbjBPBgy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 20:36:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbjBPBgl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 20:36:41 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B77AA46086;
        Wed, 15 Feb 2023 17:36:24 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id hg24-20020a05600c539800b003e1f5f2a29cso3002644wmb.4;
        Wed, 15 Feb 2023 17:36:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nxNF0bdXrLOqlvz3FHeM2ekp+a2C9OgjFl1GP6LPucY=;
        b=ZSdgv0lhnvn0Amu7Rj460scpIcG3vg0ZFEjEJsfdlvmnFlOb3TXBTAY46uRgeyaWn7
         ChxyOx24SHi2HVI/lEOmj8XjDYuVGu+j4F1a02BdpdGfnJVVhG3qzTwq6g9ZSh6ulTby
         swZqWtCzDvUHMOk/yNLoIZbBrjlmuxd8Cmp38Au2mcG2mUjajVlBmBwAHRiKezVhpPWs
         17+XP5vwvN0gbutGgE25IFVCAYHCaK4AI2miBQUhkgQAnr242NZTzGPYv7OYFEKavlv/
         9wD+GXDIZPMU3SnBUmasPE4/nSzUK0kQaEeEcDYNGHwBMEBPvciNeRR9xRyjcUXmZSsF
         wbEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nxNF0bdXrLOqlvz3FHeM2ekp+a2C9OgjFl1GP6LPucY=;
        b=yqXdEdov0KDOlL0eazVXcgf8weUs1bKn7pp540p5U5VtQfML+2P+PG4IvWEQRKqxb/
         U39hqvAVykf4VMKMmObHnStrA9v0W6IptuPeK+ZAyCnwjcWpTEB1g+oUHz/LGdGwbddX
         J9km624CLR1WfgECst251+Pv5B+u/PkP3DVmfNTV83IBKXXh2fbw53Nek7ycUJZrIXxo
         N0ylU5IxLFUdbW0qBwf4UlYx1VF5/avWOMt79+TvuVk1Hvbv4e7dnbzuclQ1hsehqcIZ
         CQUPr3nCLLUt27GmaPgjDpBqAx1ov6v5p/Z8+oytyij8el/DOQ1ahkvCYVUcEH9aWA8+
         Tchw==
X-Gm-Message-State: AO0yUKUdtCtxJA1wdLngFR6X8IT1aLM9luJj8iaSSWpnPZdHjRQrnZFB
        GbY2rjVzfJ9pd1P3amaYPhI=
X-Google-Smtp-Source: AK7set+Lhqbx2SxRTVH5CpuI73WwZU+6n02S7W6HEFNYdAGo5K2JdhTcugqhNAdnYhaCI1Cb9QQzOA==
X-Received: by 2002:a05:600c:3094:b0:3df:f85a:4724 with SMTP id g20-20020a05600c309400b003dff85a4724mr3216285wmn.39.1676511383008;
        Wed, 15 Feb 2023 17:36:23 -0800 (PST)
Received: from localhost.localdomain (93-34-91-73.ip49.fastwebnet.it. [93.34.91.73])
        by smtp.googlemail.com with ESMTPSA id v15-20020a05600c214f00b003e1fb31fc2bsm64189wml.37.2023.02.15.17.36.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 17:36:22 -0800 (PST)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jonathan Corbet <corbet@lwn.net>,
        Christian Marangi <ansuelsmth@gmail.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        John Crispin <john@phrozen.org>, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        Tim Harvey <tharvey@gateworks.com>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        Arun.Ramadoss@microchip.com
Subject: [PATCH v8 05/13] leds: trigger: netdev: convert device attr to macro
Date:   Thu, 16 Feb 2023 02:32:22 +0100
Message-Id: <20230216013230.22978-6-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230216013230.22978-1-ansuelsmth@gmail.com>
References: <20230216013230.22978-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert link tx and rx device attr to a common macro to reduce common
code and in preparation for additional attr.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/leds/trigger/ledtrig-netdev.c | 57 ++++++++-------------------
 1 file changed, 16 insertions(+), 41 deletions(-)

diff --git a/drivers/leds/trigger/ledtrig-netdev.c b/drivers/leds/trigger/ledtrig-netdev.c
index 6872da08676b..dd63cadb896e 100644
--- a/drivers/leds/trigger/ledtrig-netdev.c
+++ b/drivers/leds/trigger/ledtrig-netdev.c
@@ -189,47 +189,22 @@ static ssize_t netdev_led_attr_store(struct device *dev, const char *buf,
 	return size;
 }
 
-static ssize_t link_show(struct device *dev,
-	struct device_attribute *attr, char *buf)
-{
-	return netdev_led_attr_show(dev, buf, NETDEV_ATTR_LINK);
-}
-
-static ssize_t link_store(struct device *dev,
-	struct device_attribute *attr, const char *buf, size_t size)
-{
-	return netdev_led_attr_store(dev, buf, size, NETDEV_ATTR_LINK);
-}
-
-static DEVICE_ATTR_RW(link);
-
-static ssize_t tx_show(struct device *dev,
-	struct device_attribute *attr, char *buf)
-{
-	return netdev_led_attr_show(dev, buf, NETDEV_ATTR_TX);
-}
-
-static ssize_t tx_store(struct device *dev,
-	struct device_attribute *attr, const char *buf, size_t size)
-{
-	return netdev_led_attr_store(dev, buf, size, NETDEV_ATTR_TX);
-}
-
-static DEVICE_ATTR_RW(tx);
-
-static ssize_t rx_show(struct device *dev,
-	struct device_attribute *attr, char *buf)
-{
-	return netdev_led_attr_show(dev, buf, NETDEV_ATTR_RX);
-}
-
-static ssize_t rx_store(struct device *dev,
-	struct device_attribute *attr, const char *buf, size_t size)
-{
-	return netdev_led_attr_store(dev, buf, size, NETDEV_ATTR_RX);
-}
-
-static DEVICE_ATTR_RW(rx);
+#define DEFINE_NETDEV_TRIGGER(trigger_name, trigger) \
+	static ssize_t trigger_name##_show(struct device *dev, \
+		struct device_attribute *attr, char *buf) \
+	{ \
+		return netdev_led_attr_show(dev, buf, trigger); \
+	} \
+	static ssize_t trigger_name##_store(struct device *dev, \
+		struct device_attribute *attr, const char *buf, size_t size) \
+	{ \
+		return netdev_led_attr_store(dev, buf, size, trigger); \
+	} \
+	static DEVICE_ATTR_RW(trigger_name)
+
+DEFINE_NETDEV_TRIGGER(link, TRIGGER_NETDEV_LINK);
+DEFINE_NETDEV_TRIGGER(tx, TRIGGER_NETDEV_TX);
+DEFINE_NETDEV_TRIGGER(rx, TRIGGER_NETDEV_RX);
 
 static ssize_t interval_show(struct device *dev,
 			     struct device_attribute *attr, char *buf)
-- 
2.38.1

