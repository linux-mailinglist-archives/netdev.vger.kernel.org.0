Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59C2151C193
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 15:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380179AbiEEN7U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 09:59:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380360AbiEEN7L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 09:59:11 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 345631834B;
        Thu,  5 May 2022 06:55:32 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id b24so5291411edu.10;
        Thu, 05 May 2022 06:55:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JuRsVVqEUdtcZTaqe1dOvQJoNCUAzBZXwnxfkTQiX94=;
        b=W/5UaXxDAqcyJs7vU252H7GvKSWg0c/fiI5EtvVqQfvbbPoDgxZeoXXz2Bgk//+mch
         8qTUnwBd0j2CIEhPg/aS4YTarFuuVfBGllA8yzs84ycZDVCyOTpXIptNc42tOPCz4bJ5
         G4qBDcunfd4lFqKQXpcXd1p7ZPDRbz1YTdnhFD3UVZsw0EdVd6t6mOQkTvUbFeuyyhi+
         KBPyzJUQv7RpdP7/H9jVZW+yKVEZfCeDO9cmF157c2iIt02b+3+CtN86kfjCVVC1+ZVw
         LS+UMchVLfARzZsy9nsMQoagGcQ5TlLJ6F9G12/UQkZ3H9uRyUhbgGQJpWvM+/y93GgN
         l/Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JuRsVVqEUdtcZTaqe1dOvQJoNCUAzBZXwnxfkTQiX94=;
        b=b/l3ej1DiCFCdYFM7rr6P/R1+zRtYRGMNX3mjOEBDaexQFs2ImN8Yin+6MTcLhpjEw
         lDvEfJznOKkUL+m3vjNO5PO3BIX/2f33gXwLP2G8iWDNpETvirK1CVj/R/pMWWaszA5i
         GvmoM/BpySOq82BmFd7u74tivPmsR9HMZHJRaypo91EpiRaoNOiSI6xWIu4KqVMWl4FV
         UaErHHnkVYH+Qox6Lar3p6hZS+Pq8Q7zn1i2H690mXmiv5evYWv9xBTxD7ZJTWYHTc21
         9kv973BXyzAYknaPb91XCnbdB9WCNgyIKwtRLO/+kR43BromnrnKHrbqrsjKCSbb+AA4
         LbyQ==
X-Gm-Message-State: AOAM530L+tXXK6sCg7nWzyXLgi2vuAruYKZ8c3pJwIoWR9huMtlhBDxN
        RFSSe47qzZHk/uKtyo1rxOc=
X-Google-Smtp-Source: ABdhPJzTLEuqMS0XXlAUBVlv48aIfbTihrqnsUKYIVW/6h2dIhYSa6hS2trVlUxvL1OW4mGnO/lzDw==
X-Received: by 2002:a05:6402:f25:b0:427:bf59:ad72 with SMTP id i37-20020a0564020f2500b00427bf59ad72mr23149749eda.231.1651758930769;
        Thu, 05 May 2022 06:55:30 -0700 (PDT)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id e15-20020a50e44f000000b0042617ba63c7sm877949edm.81.2022.05.05.06.55.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 06:55:30 -0700 (PDT)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     Pavel Machek <pavel@ucw.cz>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com, ansuelsmth@gmail.com,
        andrew@lunn.ch, vivien.didelot@gmail.com,
        Vladimir Oltean <olteanv@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        John Crispin <john@phrozen.org>, linux-doc@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH RESEND 3/5] dt-bindings: leds: add Ethernet triggered LEDs to example
Date:   Thu,  5 May 2022 15:55:10 +0200
Message-Id: <20220505135512.3486-4-zajec5@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220505135512.3486-1-zajec5@gmail.com>
References: <20220505135512.3486-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

This adds 3 entries to existing example:
1. LED triggered by switch port in 10 / 100 Mbps link state
2. LED triggered by switch port in 1000 Mbps link
3. LED triggered by Ethernet interface (any speed)

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 .../devicetree/bindings/leds/common.yaml      | 21 +++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/Documentation/devicetree/bindings/leds/common.yaml b/Documentation/devicetree/bindings/leds/common.yaml
index 328952d7acbb..6c72121a1656 100644
--- a/Documentation/devicetree/bindings/leds/common.yaml
+++ b/Documentation/devicetree/bindings/leds/common.yaml
@@ -168,6 +168,7 @@ examples:
   - |
     #include <dt-bindings/gpio/gpio.h>
     #include <dt-bindings/leds/common.h>
+    #include <dt-bindings/net/eth.h>
 
     led-controller {
         compatible = "gpio-leds";
@@ -183,6 +184,26 @@ examples:
             gpios = <&gpio0 1 GPIO_ACTIVE_HIGH>;
             trigger-sources = <&ohci_port1>, <&ehci_port1>;
         };
+
+        led-2 {
+            function = LED_FUNCTION_WAN;
+            color = <LED_COLOR_ID_AMBER>;
+            gpios = <&gpio0 2 GPIO_ACTIVE_LOW>;
+            trigger-sources = <&wan_port (SPEED_10 | SPEED_100)>;
+        };
+
+        led-3 {
+            function = LED_FUNCTION_WAN;
+            color = <LED_COLOR_ID_GREEN>;
+            gpios = <&gpio0 3 GPIO_ACTIVE_LOW>;
+            trigger-sources = <&wan_port SPEED_1000>;
+        };
+
+        led-4 {
+            function = LED_FUNCTION_LAN;
+            gpios = <&gpio0 4 GPIO_ACTIVE_LOW>;
+            trigger-sources = <&gmac 0>;
+        };
     };
 
   - |
-- 
2.34.1

