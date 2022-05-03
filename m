Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13A81518854
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 17:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238248AbiECPWQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 11:22:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238127AbiECPVz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 11:21:55 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B68223AA6C;
        Tue,  3 May 2022 08:18:22 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id b24so20232982edu.10;
        Tue, 03 May 2022 08:18:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=vZu+dgzlKwppLB3egL+X7UEd+cjxbmEGUvyruw8gqlQ=;
        b=W6jUVBwWlR6/s9Tqy/8aDQnEZF+1Qw/bTsfTkGk/OCJ6UISFtZOWsm0WLfB6HOutcA
         wZsP5rCuwEArTcvj+KqPT84LsKegMo9r7mXBz18zn2uN4bLEKEtd17k8hyYkfrQtiCsE
         A/kbA4vG0AM2d41v/tyBVvToOsjBBbx58qXZn31PUJs+A/rakuB/hs9JGylDlzkUA+N7
         9nyF0HPbH/vbuGZXlUGPzNM5UwBVPCKKStpJd+xL3Ey/bp9BYEb94ALlGDokeeijk8cg
         GhAUdoKlB9H2gclMKblqV0tmbx/LRjOwrjm0JH2XrIl4cAkJ8nUl29Dw7vNE5kT/Vpo8
         Srng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vZu+dgzlKwppLB3egL+X7UEd+cjxbmEGUvyruw8gqlQ=;
        b=i4ZpOMaXfFhYe0qZiVQExU4WWWTqEfk6pOtrSE1XWaFB3MGNHwgfGg580bniTxAkRS
         sKHe+K8/rX8ffwq/nl8lNKuyA1Ogny5qsMYh4yFNxb+I6LNwO7hMu9vtyn/MpaGQ7FpK
         2nM8BUHaX2uL09NMpwvTKSXKifBTBu9n0FWl09Aum/55ToB/grM76fFaHDqeOPgeWCYy
         +bHNZTpbtf4TWS940REFDOvg+02tXMCrGul/g9Ih9ln79ZiavozdkePdDLqnuaQed/DI
         tPZaIFTqcglOfK5R+gT1/AscWSUh+3h/VKX0KwhmVpmEki6krrgrL5ml1h3y/srVZpzY
         H2Mw==
X-Gm-Message-State: AOAM533yE4oyI1IUYoBYTXjpc+QsJr+cES3EHt693MbrtBuQXXg1uJbe
        8Wtt4d50aDUiQXLFDNVr3ec=
X-Google-Smtp-Source: ABdhPJwHfusILH15MfLZeKkPb5tq2Grc5B4Y5QkVzE7S9wkdLcNfzJCCSNXZLbw24BRVN84FlcrRCw==
X-Received: by 2002:a05:6402:1254:b0:426:2439:ceb7 with SMTP id l20-20020a056402125400b004262439ceb7mr18461553edw.47.1651591101100;
        Tue, 03 May 2022 08:18:21 -0700 (PDT)
Received: from localhost.localdomain (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.googlemail.com with ESMTPSA id v3-20020aa7d9c3000000b0042617ba63cesm7947507eds.88.2022.05.03.08.18.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 08:18:20 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org
Subject: [RFC PATCH v6 05/11] leds: trigger: netdev: convert device attr to macro
Date:   Tue,  3 May 2022 17:16:27 +0200
Message-Id: <20220503151633.18760-6-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220503151633.18760-1-ansuelsmth@gmail.com>
References: <20220503151633.18760-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert link tx and rx device attr to a common macro to reduce common
code and in preparation for additional attr.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
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
2.34.1

