Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7546C5188C0
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 17:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238644AbiECPkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 11:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238632AbiECPkG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 11:40:06 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AD222FE4D;
        Tue,  3 May 2022 08:36:34 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id a21so20298824edb.1;
        Tue, 03 May 2022 08:36:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JuRsVVqEUdtcZTaqe1dOvQJoNCUAzBZXwnxfkTQiX94=;
        b=BRArI0GcCu4Ce05SnXkZg0daGlzie5NRXUDkV1Lr192k5CWtnRR5IYBTZ9jCJF5NV5
         oYINrBDN+xg5CrgkZ+ij7xmWHycrwyTAk6SD4Tr4p1P4mYGB3RzXah89Kmf1ONiML7+n
         fLl2gttPlv3Jqvs2t2WisdUJ31poWq+jw32Djz5QFVvXYHWsKWqJgyGlwoAzmWxUlMms
         2yDRbN/36WlMwwNfD+w7bhoYspqkNmmPOETwNV98BNCXgYQKXCUwWcPV0zlacOCxNm9R
         10lO5yJ0fe+cS3aKodyIdl2BZ9uuYNurdKoApObiHGVTG60alfNDMcwE7fD4J42RPuU6
         zjMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JuRsVVqEUdtcZTaqe1dOvQJoNCUAzBZXwnxfkTQiX94=;
        b=7Rkf7ZmNTNAqrNSxkPOlcv0OUTnE49Q90peAsqosditTWyGv3RVhM2sqan03X+L2wA
         4tyIG9DhU3IC6B6kH/t2bg9nNqwmzeZc/mql6lqqHiYtJU1mihG4bO47jN3vddUDfUlo
         MSKR90iK89wXu2inAixkFVos6KvnKmWKimnoHJca/9NfqAZ8uDDrpwYOFQfOir07N47K
         s8VZEySGMPeCESGF613MZL1fGyT+7EIcddi5mNS37k8von20tj7OBaiEiy53fmM0xMGF
         DUeD6beoEjVfozN+osNhzqeGlBSyXIxElNvZUzSRJdVt4/a44sdCuCnuggHSUYLLpQQq
         PCnw==
X-Gm-Message-State: AOAM5301UsKebNB0kWXBvFhYoHb+gWzOcRiQ7aXm5tQFeCpuEcy60V/P
        FpWf80tXTLcn3WdYuO2xX9A=
X-Google-Smtp-Source: ABdhPJy4DPM17zPyvjTpRiksTw2yQVmQVsw9kTtZhpCWfe2/iq1eq++c9Q4Ba/UweKwkOXNIsoCR6Q==
X-Received: by 2002:a05:6402:35c3:b0:423:f765:4523 with SMTP id z3-20020a05640235c300b00423f7654523mr18336737edc.311.1651592192529;
        Tue, 03 May 2022 08:36:32 -0700 (PDT)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id yl1-20020a17090693e100b006f3ef214dd1sm4693395ejb.55.2022.05.03.08.36.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 08:36:32 -0700 (PDT)
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
        bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH 3/4] dt-bindings: leds: add Ethernet triggered LEDs to example
Date:   Tue,  3 May 2022 17:36:12 +0200
Message-Id: <20220503153613.15320-3-zajec5@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220503153613.15320-1-zajec5@gmail.com>
References: <20220503153613.15320-1-zajec5@gmail.com>
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

