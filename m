Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A0886AF8F9
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 23:36:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231776AbjCGWgu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 17:36:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231679AbjCGWg2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 17:36:28 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E51F9B06C8;
        Tue,  7 Mar 2023 14:35:20 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id r19-20020a05600c459300b003eb3e2a5e7bso102480wmo.0;
        Tue, 07 Mar 2023 14:35:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678228471;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hKTAoz/5c2gh8Y+1xcGszVL+VPGe5qIqtDhWxElzHg8=;
        b=bmWCwUNdPhKNN9p+nZQXhBFaHDLu+KgOmPb24fbdtT0mjRUG1KrEYzNhG67eD3YIMH
         /cwjoZaxdjSmPGdNDHV/Ty5YXutJ/Z6U0jwovIhA+QwS0TNDBbtc4dOulwXkQV/pMIWo
         BA9j6RNiSm+ZHaPe/YXNdki+nqv8nbR16iX7Z0Rv3u3wpA/T9AG/tCpyZDMwY21VaFbf
         phHxbG/u4fqzHz2CE/3+zZgmMr3qrJHV4w3CMd2two27XYe1aGM4wsVluuBhVx33WiI2
         phMKoNiN6HSr/0H5lX5zB91Qup2Y/fubRWzJah0w65AXTTF4e+jB3hKE8Ly/72IYVXi7
         zA1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678228471;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hKTAoz/5c2gh8Y+1xcGszVL+VPGe5qIqtDhWxElzHg8=;
        b=ozHeJHW5E/+S91PlAF81gzn9aiCrLREa58QWD4CAw8kDPvkSmE/CtMqRGWoBg1bOSj
         ws4FLqXrw0W4DU0sxfKaI+HaUeK69cNgKvI7TfZydFzRJmPUJ14ZzbUeUa/VuDYoJh5y
         TG4Q6Ro4HS7j6ok8+hbmbSC9aDg+OOPsrO5gUZmXzJug1qxmATJ4V3C7+8m40dPPyBTb
         JoK3+qRGbnPVLRTuyyFqL05gtHDqNIy5QxbR/1uwG30X0NKHB5M49D89jkvlWL+n2sZu
         CY6Na6VzxtRLZmE/8dlSvX7IXvhXEjO09SfQZ2UpUQEtlapATGdUKPWGj19eImDM0X2A
         iihA==
X-Gm-Message-State: AO0yUKW57cjvi9od4czPnbrkKZ+QZlEmJ6q4h0TWjElNCPM4Ohdp4XBj
        8O/NG8MlieKsZ56IGhiUuVE=
X-Google-Smtp-Source: AK7set97ILq+tPtPnouKud8rXPxJOPNvTRK+NaUnkpwLzM9tqFszkITYpw1Y2fNyPsx/kSnTlPE3rw==
X-Received: by 2002:a05:600c:5491:b0:3eb:5739:7591 with SMTP id iv17-20020a05600c549100b003eb57397591mr14801310wmb.23.1678228470804;
        Tue, 07 Mar 2023 14:34:30 -0800 (PST)
Received: from localhost.localdomain (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.googlemail.com with ESMTPSA id q11-20020a05600c46cb00b003dc1d668866sm19233101wmo.10.2023.03.07.14.33.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 14:34:30 -0800 (PST)
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
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Lee Jones <lee@kernel.org>,
        linux-leds@vger.kernel.org
Subject: [net-next PATCH 11/11] arm: mvebu: dt: Add PHY LED support for 370-rd WAN port
Date:   Tue,  7 Mar 2023 18:00:46 +0100
Message-Id: <20230307170046.28917-12-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170046.28917-1-ansuelsmth@gmail.com>
References: <20230307170046.28917-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
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

