Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 879766B9B24
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 17:19:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230429AbjCNQTF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 12:19:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231387AbjCNQSB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 12:18:01 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADE55ACE31;
        Tue, 14 Mar 2023 09:17:36 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id p4so8688761wre.11;
        Tue, 14 Mar 2023 09:17:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678810655;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1wDcE5BTiRUWu5IpXdTXJGaa7mTD/67d24QZlEDxG4g=;
        b=LXKopah/Gf7/RWEpDVCAEg8KcTcd/6vUHT+j9K7zjvuJS+Y9V0VXs1Yxc9wKcMHXhl
         BB0LiPIIgVlqUSBjIL8gsZaGh9lm9NORfeuUUB48dyeMkKTa+ifpo4dJ/+9WioT99ggG
         j8z/UWwqq3qfzU527ACMJc0lnEV86RZ8dFj5OUMlB9dOYbfabxeOEFw+9nRRgD8JcP7p
         0ME5PcOjMgas2KKv5AibDhC5iNYdMiTOn21Wjv6/iT+Uq08yJioWr7ZUVET+uCRCAtxE
         n/ItvWDM09v82MtQGaeTRVXC9PPPMSoJHd/JZEC/5TaMrKVcx4qDrNqagNIeXQqb8ckm
         amSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678810655;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1wDcE5BTiRUWu5IpXdTXJGaa7mTD/67d24QZlEDxG4g=;
        b=W0Qxs+K5omDfFZkqj5ZKx2kE0R96IZ4HezOi9j1nR+lHcS5HnxbhzFiNSD3Drg8xoh
         uwGoaS36Q4qXl/HvMRPZHpQ7oADnqD4+N0RNID3vAPto5zntePmdF9kYlVDIvLTIL1Iu
         1HY2dsWIAflswlnibwtST209a5YDSqZI0oh6ibI+Y8FDBNeR7ot8q0eUphLm1xTo+I6Y
         5HV/gqLpndpmkCVPFXemXmICBSHt5cgxBibFATJWi+KVwJdVqmQQ9E4vGcxVnBMzGylI
         XwA0P+URvmMynNWd2VZuxxFHSpC0XcMg8uTPzouI+OZs3WWupITrpbU0LwJoAfq7tqcm
         yVRQ==
X-Gm-Message-State: AO0yUKWcLZCzrgQerVML1tDk5tGUIzOW3Psom1kk9CY521+Mx4RbNnWs
        ClxPOz95/gHXkVvQD33lAsg=
X-Google-Smtp-Source: AK7set/Py17xJdAHaKc9J1xLWW5hoZb6Z2NABG0h4vlp94vfirRYvARukA5VFwBRrxWLBwL/DTaieQ==
X-Received: by 2002:a5d:530d:0:b0:2c5:510b:8f9c with SMTP id e13-20020a5d530d000000b002c5510b8f9cmr25423697wrv.52.1678810654984;
        Tue, 14 Mar 2023 09:17:34 -0700 (PDT)
Received: from localhost.localdomain (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.googlemail.com with ESMTPSA id a16-20020a5d4570000000b002c5539171d1sm2426821wrc.41.2023.03.14.09.17.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 09:17:34 -0700 (PDT)
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
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, Lee Jones <lee@kernel.org>,
        linux-leds@vger.kernel.org
Subject: [net-next PATCH v3 10/14] dt-bindings: net: dsa: qca8k: add LEDs definition example
Date:   Tue, 14 Mar 2023 11:15:12 +0100
Message-Id: <20230314101516.20427-11-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230314101516.20427-1-ansuelsmth@gmail.com>
References: <20230314101516.20427-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DATE_IN_PAST_06_12,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add LEDs definition example for qca8k Switch Family to describe how they
should be defined for a correct usage.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 .../devicetree/bindings/net/dsa/qca8k.yaml    | 24 +++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.yaml b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
index 389892592aac..866b3cc73216 100644
--- a/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
@@ -18,6 +18,8 @@ description:
   PHY it is connected to. In this config, an internal mdio-bus is registered and
   the MDIO master is used for communication. Mixed external and internal
   mdio-bus configurations are not supported by the hardware.
+  Each phy have at least 3 LEDs connected and can be declared
+  using the standard LEDs structure.
 
 properties:
   compatible:
@@ -117,6 +119,7 @@ unevaluatedProperties: false
 examples:
   - |
     #include <dt-bindings/gpio/gpio.h>
+    #include <dt-bindings/leds/common.h>
 
     mdio {
         #address-cells = <1>;
@@ -226,6 +229,27 @@ examples:
                     label = "lan1";
                     phy-mode = "internal";
                     phy-handle = <&internal_phy_port1>;
+
+                    leds {
+                        #address-cells = <1>;
+                        #size-cells = <0>;
+
+                        led@0 {
+                            reg = <0>;
+                            color = <LED_COLOR_ID_WHITE>;
+                            function = LED_FUNCTION_LAN;
+                            function-enumerator = <1>;
+                            default-state = "keep";
+                        };
+
+                        led@1 {
+                            reg = <1>;
+                            color = <LED_COLOR_ID_AMBER>;
+                            function = LED_FUNCTION_LAN;
+                            function-enumerator = <1>;
+                            default-state = "keep";
+                        };
+                    };
                 };
 
                 port@2 {
-- 
2.39.2

