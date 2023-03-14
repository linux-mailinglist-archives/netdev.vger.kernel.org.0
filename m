Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B87F86B9B1F
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 17:19:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbjCNQS5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 12:18:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231162AbjCNQST (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 12:18:19 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC0ECB371D;
        Tue, 14 Mar 2023 09:17:42 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id r29so6855425wra.13;
        Tue, 14 Mar 2023 09:17:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678810661;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hKTAoz/5c2gh8Y+1xcGszVL+VPGe5qIqtDhWxElzHg8=;
        b=A5QGX8g9qQHcZkkrcXMDsdj7A9cZmBMtVmbBwkVTk60r6OctUe5QoRW20dNyop4WVQ
         YtLS0ZcqTYuR1ABV7ZpJH3/Pdm8IgAfWdFzB/usawxLOF8dtCK0vHHBtjcdDQS1H+NnJ
         LO/6QnazNKOsKlnOcMIp4O/P23DYUaV6Dk43savUOfuwIcmoRffjGEhxlhgr6hqmT0DQ
         czXSPywGk5chD6etCr6asQ3uoITHJZo0Dv5mqdkE4eJgp4Y7n1kTInqlr2Ppisek9jAY
         MNxO3rHz/oqxF7VPoeL0iWi//D5S49ti4Vewd7XA3Xq24ivCGCT6gTnczzNmYiv/ToCo
         GW5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678810661;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hKTAoz/5c2gh8Y+1xcGszVL+VPGe5qIqtDhWxElzHg8=;
        b=ixn7F8YHpGDw0ZZWG0i2NlZ014c4rrlI8YOlaY3Ctndw6TFHkIQY1HxJo7FAUWvUpA
         Sp1NVmCJ1TcsRVTUyIbJ/oXZ5R6WyXsYtf9x6lz/bccKY552CO/z2AStNAXR4PYKyS0A
         JEBxDQTxpToX5/4XTf1GKFXz8/k43oKHDuDy/MNsawCIZVQH8UvncO6k+abkjWoavAib
         VRQhJvFP/Ig0ZCeJ8Wb9VnhC8xNSyKNNTMpwfwAyYuW9SP/mMAWgEXiu8eIWU0bgwP9Z
         TsorZCjjafKlRXaCiXJsAYDkXq7a3uhdSmWlo8pddDjYE82d1no/cJPOU4PqLfBLrH8H
         fGsg==
X-Gm-Message-State: AO0yUKWTuAwIvF5Q3nUxUtcxuJ0yXuTbkK5uwVZdK6WEOQ4ALQtJDlWm
        Et5ezd1XTDw2OH8yPHcxLKs=
X-Google-Smtp-Source: AK7set+ph3aBjOKKtAXH2OiXBAVPuXd2TznYURmQDMIGFuquVDB5MaS//G76s78xOLPrdTOUHvSofA==
X-Received: by 2002:adf:fe49:0:b0:2cf:e645:aa60 with SMTP id m9-20020adffe49000000b002cfe645aa60mr3923843wrs.19.1678810661174;
        Tue, 14 Mar 2023 09:17:41 -0700 (PDT)
Received: from localhost.localdomain (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.googlemail.com with ESMTPSA id a16-20020a5d4570000000b002c5539171d1sm2426821wrc.41.2023.03.14.09.17.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 09:17:40 -0700 (PDT)
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
Subject: [net-next PATCH v3 14/14] arm: mvebu: dt: Add PHY LED support for 370-rd WAN port
Date:   Tue, 14 Mar 2023 11:15:16 +0100
Message-Id: <20230314101516.20427-15-ansuelsmth@gmail.com>
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

