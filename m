Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC0DA6B310C
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 23:41:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231799AbjCIWkD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 17:40:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229989AbjCIWj0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 17:39:26 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C76B26CC5;
        Thu,  9 Mar 2023 14:38:20 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id j3so2257134wms.2;
        Thu, 09 Mar 2023 14:38:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678401497;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hKTAoz/5c2gh8Y+1xcGszVL+VPGe5qIqtDhWxElzHg8=;
        b=Lz9RBu9CNknt0QOl1Aljn3cwAQU50LY+AV7pSEK2Fj8y3Hddbp4bpOTZi5rdS139F9
         8ptUcoz9oF26o4TdIU880734mFr6D//0Pup+yhl4sl+qWhzxl1EQsry/0hWIrecGVCYX
         irkJVeam6BQf1XKfDhMOAItTSlHyiuUnGkQIZ69rZJp9rLO7ToxONC/5gBKjkgcQYWSn
         aEgSeFeD1BuSXWBATUry4dvmFsB+d+jTHeR+0pf9nT6vw1LcZ1N5nbxeVBRBAl57csCT
         E61stkETe6G9jYvNriFX3ip8Yen/ibpiuilcO10mTst/5qyra0K1kpwYzwAC22YbidoR
         1EsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678401497;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hKTAoz/5c2gh8Y+1xcGszVL+VPGe5qIqtDhWxElzHg8=;
        b=kEcujqqqkijUj054l9C65d3BYTAubaAtZqRFgtOeHs3QyUtz5aqXWNTmkiydFMo2SC
         CwAbtBQjt8WIpVNvZs6mViXyjFz8bPMkE8YfoIm6NvHek3wU1AD8V/NVGYCLn/UWi7YS
         J6sEHzkqyK1Vl9qKc1ifxaLgVkc5AGiTnhOw4kFmo9PFjCLT/G/RTr7Z42eSOxrEWExk
         n8phLQAXr7IEWxX5MLKJ//TM2Pvqv83gN07TkAsloVCi4pISdcO0JU+RnnGRRCyB2b+Y
         l+VnLkus75FalDRthkJDC0bIGpMw9LowcM8Eu20qj0JoA10Kd2I5jXWdaHIhylLKpF2P
         MJGg==
X-Gm-Message-State: AO0yUKW49xoQZ9bEjANu8wxWWFCoOoKX2l44u8mqpJFZ5YqZ5DwS/tbh
        2CyXWVafnruB4ogXDbm1jYM=
X-Google-Smtp-Source: AK7set9nJyc40zKBJjx/+yRO/PvBUSMQMAtbQH41bk/GikMpPlZvCnoCom8HjfPdmlaTb9H2ybUlWQ==
X-Received: by 2002:a05:600c:3c8f:b0:3ea:bc08:b63e with SMTP id bg15-20020a05600c3c8f00b003eabc08b63emr808544wmb.2.1678401496818;
        Thu, 09 Mar 2023 14:38:16 -0800 (PST)
Received: from localhost.localdomain (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.googlemail.com with ESMTPSA id g12-20020a05600c310c00b003e209b45f6bsm1183981wmo.29.2023.03.09.14.38.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 14:38:16 -0800 (PST)
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
Subject: [net-next PATCH v2 14/14] arm: mvebu: dt: Add PHY LED support for 370-rd WAN port
Date:   Thu,  9 Mar 2023 23:35:24 +0100
Message-Id: <20230309223524.23364-15-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230309223524.23364-1-ansuelsmth@gmail.com>
References: <20230309223524.23364-1-ansuelsmth@gmail.com>
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

From: Andrew Lunn <andrew@lunn.ch>

The WAN port of the 370-RD has a Marvell PHY, with one LED on
the front panel. List this LED in the device tree.

Set the LED default state to "keep" to not change any blink rule
set by default.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 arch/arm/boot/dts/armada-370-rd.dts | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/arm/boot/dts/armada-370-rd.dts b/arch/arm/boot/dts/armada-370-rd.dts
index be005c9f42ef..ccd4699b219f 100644
--- a/arch/arm/boot/dts/armada-370-rd.dts
+++ b/arch/arm/boot/dts/armada-370-rd.dts
@@ -20,6 +20,7 @@
 /dts-v1/;
 #include <dt-bindings/input/input.h>
 #include <dt-bindings/interrupt-controller/irq.h>
+#include <dt-bindings/leds/common.h>
 #include <dt-bindings/gpio/gpio.h>
 #include "armada-370.dtsi"
 
@@ -135,6 +136,19 @@ &mdio {
 	pinctrl-names = "default";
 	phy0: ethernet-phy@0 {
 		reg = <0>;
+		leds {
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			led@0 {
+				reg = <0>;
+				label = "WAN";
+				color = <LED_COLOR_ID_WHITE>;
+				function = LED_FUNCTION_LAN;
+				function-enumerator = <1>;
+				default-state = "keep";
+			};
+		};
 	};
 
 	switch: switch@10 {
-- 
2.39.2

