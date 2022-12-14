Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B475564D42B
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 00:59:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbiLNX7f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 18:59:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbiLNX6t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 18:58:49 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE74A5D6A8;
        Wed, 14 Dec 2022 15:55:45 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id u12so1427819wrr.11;
        Wed, 14 Dec 2022 15:55:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ERnunlg4Are2RjzI+mRhVTdhmnhLu7rf9W2UfAXj16A=;
        b=Y5c1IhUoOOWervZyFKkPlyf3ICr6PsF7TStOeqbI7ka4EtTbxdISRWxmia6va6VoVz
         aH9sxUTaGNziC4i8fyV6SDtgbFhnwbamFZmDP4QESPZLoCaF+4fcGuf4Xcj3QqHpIwIP
         Rs3XRlVQKHd5qI7HOmqaVPrELXMYZwL6OrQBC8RGTCtRwqGAN9XXLUXyi4kU6uJEWuSd
         nA9xwruhPfwGZUkFtALC3fYsap7QZ2ckrXHK6zb28SF76pRomJJ/MgTRduwWDntrOL5S
         eaO+LDRuNMecENWWEUcjP2rBydr6jlI+l3UCqOdjTlvi9C/LUB53DGTMjJmMO5/BEzpI
         mpag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ERnunlg4Are2RjzI+mRhVTdhmnhLu7rf9W2UfAXj16A=;
        b=zAwl59Y1RDs/zz3sXNeA7886IS7GFuAu9+yy7+vy926NnElG/NxFbAyiYBp3C61Cmx
         2YOMOLmKF6+CAEWgDKin6nOA0WWc/OQPLLyVdvFXw8NhBvTRZE+hL3mHPGKntTVQT9ml
         GB/j/sxjOoLUaLfNfKdGbsvrDOurpfTkuS19jg077gcGJAIa6mx71K58jN4tsQmWAW53
         BWdHcgOjBLV9UXJ+YAuYS1HgtloBAJBYcgJ1rZeasl12g9udmYa6boi1PJ53jr2AkRh9
         7wCSFCLrmTh/L2x49aCujw87Ne9mO71GcvNZyg27llLAHn6KyESa80yyLTAwMBE/kyfg
         bYfA==
X-Gm-Message-State: ANoB5plUdD2Kl04TbXxWglLce1Cxzt1P/KwF4AqDb1W1kOiYfQrhwCRe
        gnbfa82+9h17qrHPznZoOnw=
X-Google-Smtp-Source: AA0mqf4GXLQZX1ebAeL145nIzjkfwLXs43y5ktVVWt+Z3d+aqkhYIKbFZY9Vemcm3a+rJoRtw3vmYQ==
X-Received: by 2002:adf:ea0d:0:b0:242:b6a:1c9b with SMTP id q13-20020adfea0d000000b002420b6a1c9bmr15565115wrm.59.1671062114938;
        Wed, 14 Dec 2022 15:55:14 -0800 (PST)
Received: from localhost.localdomain (93-42-71-18.ip85.fastwebnet.it. [93.42.71.18])
        by smtp.googlemail.com with ESMTPSA id u2-20020adff882000000b00241d21d4652sm4163549wrp.21.2022.12.14.15.55.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Dec 2022 15:55:14 -0800 (PST)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        Christian Marangi <ansuelsmth@gmail.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org,
        Tim Harvey <tharvey@gateworks.com>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: [PATCH v7 05/11] leds: trigger: netdev: convert device attr to macro
Date:   Thu, 15 Dec 2022 00:54:32 +0100
Message-Id: <20221214235438.30271-6-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221214235438.30271-1-ansuelsmth@gmail.com>
References: <20221214235438.30271-1-ansuelsmth@gmail.com>
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
2.37.2

