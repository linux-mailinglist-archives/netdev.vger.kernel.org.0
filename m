Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78B236C0456
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 20:20:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbjCSTUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 15:20:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230122AbjCSTTu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 15:19:50 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6252F1E9E3;
        Sun, 19 Mar 2023 12:18:58 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id v1so2417893wrv.1;
        Sun, 19 Mar 2023 12:18:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679253536;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oy4rJp/0zV8uQx96aqdFOna+cm21IPd+B8/oErRDE1c=;
        b=ITt6syLmwNGy0ZbUxm216tTbp3mY9GEm/3lMvbbE2Rt2AmFNDP+lDlVo9z74NODKkT
         PFUABL92MyqFqXD0IsdwgSVPYtr+hzSbiu2N45Nr+n8QX8AmyN8POiYqe5G/DajGXsJc
         67FzzJrp7CrMFY4Y3HeIEpyujtlfFQpZokxqSIZ0j8ktmSZK1E7YZqfLTa/KyiYMHoCi
         T4VCPN2ZwK6nDdX3L3rI6l6bJJY4SzMN+vB0EOUrtkw+1Dbccm31xymXbmoBaT0mARDG
         M0OzS1dz+KV8WVgJiqN4sFnIBVzzEuNQ9Nb7uGwFagkzmu7y1OC0cB+tPyIYFnF2eRVd
         Ry8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679253536;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oy4rJp/0zV8uQx96aqdFOna+cm21IPd+B8/oErRDE1c=;
        b=BmLFh8WV1M+TZGUnzvPeSsGVXAQ6/vYpkGdESvvjYjJpD6zO5usE8f0HYBQ9kjZpzk
         niBLr8jLmqTwOUNznKVsVTBt4TNb1Tcd/qA8WPpFIMpn2lM24BJ0Het5MI9QYB1Tcg9X
         Df29M5/57Gx2gsnDYWV+Vo3vE25bLcs9ycXX5pee4VIPvgX03ATGu9JxtzNI5WEG/dnZ
         9wvt9XeHx5AccaQduvXM+eGlHgUM8p0GO6za2z4DALIO0QTD5xOVMtKiNCEzL3/mbcoL
         zkPWBeStNNEGL9aMYApF1jldrxQmMEqao3pO7+JSQo4D2fDeFuvgJyzOmL0fVoMNHeuc
         Shtg==
X-Gm-Message-State: AO0yUKWJIiv0ypZ1vCMrP5r0EYrVVKgE/DyGT9Yf+/MebxsCvgUzieD0
        YbWyqO0hwFUmUMcBU0Svb/Q=
X-Google-Smtp-Source: AK7set9RJTHUU3x+cB1vPG2tx4D/cF6g7trZnQtZGucpSHSmKWi61gPafYkIpRGJ4EUPGiGlo3eKQw==
X-Received: by 2002:a5d:4205:0:b0:2cf:fd6:b83f with SMTP id n5-20020a5d4205000000b002cf0fd6b83fmr7367868wrq.8.1679253535952;
        Sun, 19 Mar 2023 12:18:55 -0700 (PDT)
Received: from localhost.localdomain (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.googlemail.com with ESMTPSA id b7-20020a5d4b87000000b002cfe0ab1246sm7165167wrt.20.2023.03.19.12.18.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Mar 2023 12:18:55 -0700 (PDT)
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
        Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-leds@vger.kernel.org
Subject: [net-next PATCH v5 15/15] arm: mvebu: dt: Add PHY LED support for 370-rd WAN port
Date:   Sun, 19 Mar 2023 20:18:14 +0100
Message-Id: <20230319191814.22067-16-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230319191814.22067-1-ansuelsmth@gmail.com>
References: <20230319191814.22067-1-ansuelsmth@gmail.com>
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

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 arch/arm/boot/dts/armada-370-rd.dts | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/arm/boot/dts/armada-370-rd.dts b/arch/arm/boot/dts/armada-370-rd.dts
index be005c9f42ef..15b36aa34ef4 100644
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
+				linux,default-trigger = "netdev";
+			};
+		};
 	};
 
 	switch: switch@10 {
-- 
2.39.2

