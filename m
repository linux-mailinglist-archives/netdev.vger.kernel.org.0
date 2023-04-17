Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DFE66E4D00
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 17:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231428AbjDQPXd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 11:23:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231355AbjDQPWn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 11:22:43 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 923A8CC25;
        Mon, 17 Apr 2023 08:21:48 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id he13so18998039wmb.2;
        Mon, 17 Apr 2023 08:21:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681744904; x=1684336904;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LhGkMARR1a9DNNYz4k2QeApxkMgfh0i/guZRUWxeU60=;
        b=D4QSsQBP+mnP5UtJNy9wwGzv5UTiUqX/kMD5cCgnHxGH7w3WR2mDK73Hq3ieG0j4v7
         N7tFh9E/dBzu3hhTT3CuH3IT1ZzxyXd3ZROnbMO/UKRrSxTElOjoLSAbzjwU3bjc7kbZ
         b1Xc8I+vEgpfJtXxctiCa/0hbvDoOX90GG090xY8VH4o+bHZlNr7sjd2VEqwaZ0mWb0C
         Qpc1UxIZPVEsfHVvZvGR/l+umqBSmUwZ+OwDeHXbRixLmB5ccC45WI3+sr3ihSnQ9SGs
         9xeXc5u8WuJgJ/0Z42JanZJd0v4uuSXGh/oZYHyvIJdh8+CThaXeFcbUS2zSrCxYoAME
         bAkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681744904; x=1684336904;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LhGkMARR1a9DNNYz4k2QeApxkMgfh0i/guZRUWxeU60=;
        b=gDv8XxtzODyz7s8gfNCdYx5doS6+H8QBpzeuwIlPMSkc7tGBsL9/VlbQUDtpdZmWZP
         aWhprAzkDdObcVMZSFzOnotspJkHSulCq6Y84/NcTqhl1Kr7eW+Q7cgAuZLH/tfqt+3q
         XV3sx4qtvPwFvCG8sh+FWE5yQgmkd5X+1vaTlxv8eYIF7D9fZiond4WwUfSN7SWoRBYO
         pzBXLS/LDg6CEn4UuydflIS8UphiwhBiT4mgYa4mXDQF6VA8Hp9ZTmKKX9aKyXo9kAXH
         6AOpMLu7d9A0dAoQLUnhCsTIWIcAQHv9zo7OJeK9LGFCQBrVIZt43CTXf8w+DADmKGgi
         TeGg==
X-Gm-Message-State: AAQBX9eXuXklEvocLHGUGCDQ33rTlFtGfYonL2GTk82MgXnb5Y3hk0U+
        K2KN8jO6z7Xx1YS2iVl2Wzc=
X-Google-Smtp-Source: AKy350aEH12wQLoQ17P4yBixcua0xBsFibbcv+7CC1rPFi+97EIoA2sD6RLp7ulAuzNKvCimm7Uj8Q==
X-Received: by 2002:a05:600c:229a:b0:3ee:9909:acc8 with SMTP id 26-20020a05600c229a00b003ee9909acc8mr11277706wmf.32.1681744903477;
        Mon, 17 Apr 2023 08:21:43 -0700 (PDT)
Received: from localhost.localdomain (host-87-7-13-196.retail.telecomitalia.it. [87.7.13.196])
        by smtp.googlemail.com with ESMTPSA id j15-20020a05600c1c0f00b003f173be2ccfsm3501354wms.2.2023.04.17.08.21.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 08:21:41 -0700 (PDT)
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
        Jonathan Corbet <corbet@lwn.net>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-leds@vger.kernel.org
Subject: [net-next PATCH v7 15/16] arm: mvebu: dt: Add PHY LED support for 370-rd WAN port
Date:   Mon, 17 Apr 2023 17:17:37 +0200
Message-Id: <20230417151738.19426-16-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230417151738.19426-1-ansuelsmth@gmail.com>
References: <20230417151738.19426-1-ansuelsmth@gmail.com>
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

From: Andrew Lunn <andrew@lunn.ch>

The WAN port of the 370-RD has a Marvell PHY, with one LED on
the front panel.y List this LED in the device tree.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 arch/arm/boot/dts/armada-370-rd.dts | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm/boot/dts/armada-370-rd.dts b/arch/arm/boot/dts/armada-370-rd.dts
index be005c9f42ef..2586f32a3e21 100644
--- a/arch/arm/boot/dts/armada-370-rd.dts
+++ b/arch/arm/boot/dts/armada-370-rd.dts
@@ -20,6 +20,7 @@
 /dts-v1/;
 #include <dt-bindings/input/input.h>
 #include <dt-bindings/interrupt-controller/irq.h>
+#include <dt-bindings/leds/common.h>
 #include <dt-bindings/gpio/gpio.h>
 #include "armada-370.dtsi"
 
@@ -135,6 +136,17 @@ &mdio {
 	pinctrl-names = "default";
 	phy0: ethernet-phy@0 {
 		reg = <0>;
+		leds {
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			led@0 {
+				reg = <0>;
+				color = <LED_COLOR_ID_WHITE>;
+				function = LED_FUNCTION_WAN;
+				default-state = "keep";
+			};
+		};
 	};
 
 	switch: switch@10 {
-- 
2.39.2

