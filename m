Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B05B6C0447
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 20:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbjCSTUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 15:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230055AbjCSTT2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 15:19:28 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD22E13DFD;
        Sun, 19 Mar 2023 12:18:53 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id m2so8523884wrh.6;
        Sun, 19 Mar 2023 12:18:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679253533;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4yEvSncVqO5CEElyQ6q0WPYP3z8pHrofnI3Ooo06uR0=;
        b=IEuKXDTAa6hltMwYOaxaLEfjS/L6pjoOh9pQfVsYlDApA/0FvXwqKjj5h6orO7yFrA
         bjdV/ddoq8pgW0zFsYheecn7U8YVLlqNKWL/Xf1q/r6GWl+iNzShls8AHTs53V0y2WbS
         L4R/iqB9WlIP0XEieQvAanN6H8jBPkVU+K9mpi/hHjKaY3b9AQaU8spZo1Rh0ohqU94T
         QY7KCQVKq40jQtbmqCFgKh8pdFTPygVnAydOLAa0qLq2O3XKGkG4igsiVdvnyYrt/ndl
         aZ2TMGYylTl3HctKc32bQa7yI662/Tut7GFY9FfzMJmAxVZpe/Ah5r1U9hNlwcfcWU1g
         DShg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679253533;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4yEvSncVqO5CEElyQ6q0WPYP3z8pHrofnI3Ooo06uR0=;
        b=tZzP+Y52x5bVb/bdZ1lltAOyhWNVKCY9vpzSHUeRzR47C3didxw4PQJGcc2IKo9rYb
         xwWdY9QPx+8IplfgYCPqae1NJHrkcSWEqao8ssgCtKc9J7F+kMyabHMIF973KFjFljzq
         2pSknfML9EN3hGGiAmsj7KXmox3vSG9aWipC8jt12ReRkhfPMLZg0qBRCsQylB2moABN
         bVQ69RA2mB8bTmIiOiXd+L3NCNOHc+LyBDsoWvkNYXUdI9YCchoBsf5u6kzuNsLby7vA
         iiU2kPeecA2DUW9zImgzdTM3xKoDf/Icmiovi7/XW/d/4tnM0PuXYXtXx02B5Iwqv3F7
         nYIQ==
X-Gm-Message-State: AO0yUKXJxSX+ip8emWiPNSOFTq20FNsbmg8RpLuvYUGS7I8vl7Qw1tSd
        5KqkltsA7hT7VTXcfNEyziY=
X-Google-Smtp-Source: AK7set9EIQRt+Vy8WI+P6a0TnkZWagWQpwPbVaebWx3xDMHd5YbC77qduULziSM514V5eiH6+OfwIA==
X-Received: by 2002:a5d:4b0b:0:b0:2d1:9ce9:2b99 with SMTP id v11-20020a5d4b0b000000b002d19ce92b99mr8896950wrq.18.1679253532979;
        Sun, 19 Mar 2023 12:18:52 -0700 (PDT)
Received: from localhost.localdomain (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.googlemail.com with ESMTPSA id b7-20020a5d4b87000000b002cfe0ab1246sm7165167wrt.20.2023.03.19.12.18.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Mar 2023 12:18:52 -0700 (PDT)
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
Cc:     Jonathan McDowell <noodles@earth.li>
Subject: [net-next PATCH v5 13/15] arm: qcom: dt: Add Switch LED for each port for rb3011
Date:   Sun, 19 Mar 2023 20:18:12 +0100
Message-Id: <20230319191814.22067-14-ansuelsmth@gmail.com>
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

Add Switch LED for each port for MikroTik RB3011UiAS-RM.

MikroTik RB3011UiAS-RM is a 10 port device with 2 qca8337 switch chips
connected.

It was discovered that in the hardware design all 3 Switch LED trace of
the related port is connected to the same LED. This was discovered by
setting to 'always on' the related led in the switch regs and noticing
that all 3 LED for the specific port (for example for port 1) cause the
connected LED for port 1 to turn on. As an extra test we tried enabling
2 different LED for the port resulting in the LED turned off only if
every led in the reg was off.

Aside from this funny and strange hardware implementation, the device
itself have one green LED for each port, resulting in 10 green LED one
for each of the 10 supported port.

Cc: Jonathan McDowell <noodles@earth.li>
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 arch/arm/boot/dts/qcom-ipq8064-rb3011.dts | 120 ++++++++++++++++++++++
 1 file changed, 120 insertions(+)

diff --git a/arch/arm/boot/dts/qcom-ipq8064-rb3011.dts b/arch/arm/boot/dts/qcom-ipq8064-rb3011.dts
index 47a5d1849c72..472b5a2912a1 100644
--- a/arch/arm/boot/dts/qcom-ipq8064-rb3011.dts
+++ b/arch/arm/boot/dts/qcom-ipq8064-rb3011.dts
@@ -65,26 +65,86 @@ fixed-link {
 				port@1 {
 					reg = <1>;
 					label = "sw1";
+
+					leds {
+						#address-cells = <1>;
+						#size-cells = <0>;
+
+						led@0 {
+							reg = <0>;
+							color = <LED_COLOR_ID_GREEN>;
+							function = LED_FUNCTION_LAN;
+							function-enumerator = <1>;
+						};
+					};
 				};
 
 				port@2 {
 					reg = <2>;
 					label = "sw2";
+
+					leds {
+						#address-cells = <1>;
+						#size-cells = <0>;
+
+						led@0 {
+							reg = <0>;
+							color = <LED_COLOR_ID_GREEN>;
+							function = LED_FUNCTION_LAN;
+							function-enumerator = <2>;
+						};
+					};
 				};
 
 				port@3 {
 					reg = <3>;
 					label = "sw3";
+
+					leds {
+						#address-cells = <1>;
+						#size-cells = <0>;
+
+						led@0 {
+							reg = <0>;
+							color = <LED_COLOR_ID_GREEN>;
+							function = LED_FUNCTION_LAN;
+							function-enumerator = <3>;
+						};
+					};
 				};
 
 				port@4 {
 					reg = <4>;
 					label = "sw4";
+
+					leds {
+						#address-cells = <1>;
+						#size-cells = <0>;
+
+						led@0 {
+							reg = <0>;
+							color = <LED_COLOR_ID_GREEN>;
+							function = LED_FUNCTION_LAN;
+							function-enumerator = <4>;
+						};
+					};
 				};
 
 				port@5 {
 					reg = <5>;
 					label = "sw5";
+
+					leds {
+						#address-cells = <1>;
+						#size-cells = <0>;
+
+						led@0 {
+							reg = <0>;
+							color = <LED_COLOR_ID_GREEN>;
+							function = LED_FUNCTION_LAN;
+							function-enumerator = <5>;
+						};
+					};
 				};
 			};
 		};
@@ -130,26 +190,86 @@ fixed-link {
 				port@1 {
 					reg = <1>;
 					label = "sw6";
+
+					leds {
+						#address-cells = <1>;
+						#size-cells = <0>;
+
+						led@0 {
+							reg = <0>;
+							color = <LED_COLOR_ID_GREEN>;
+							function = LED_FUNCTION_LAN;
+							function-enumerator = <6>;
+						};
+					};
 				};
 
 				port@2 {
 					reg = <2>;
 					label = "sw7";
+
+					leds {
+						#address-cells = <1>;
+						#size-cells = <0>;
+
+						led@0 {
+							reg = <0>;
+							color = <LED_COLOR_ID_GREEN>;
+							function = LED_FUNCTION_LAN;
+							function-enumerator = <7>;
+						};
+					};
 				};
 
 				port@3 {
 					reg = <3>;
 					label = "sw8";
+
+					leds {
+						#address-cells = <1>;
+						#size-cells = <0>;
+
+						led@0 {
+							reg = <0>;
+							color = <LED_COLOR_ID_GREEN>;
+							function = LED_FUNCTION_LAN;
+							function-enumerator = <8>;
+						};
+					};
 				};
 
 				port@4 {
 					reg = <4>;
 					label = "sw9";
+
+					leds {
+						#address-cells = <1>;
+						#size-cells = <0>;
+
+						led@0 {
+							reg = <0>;
+							color = <LED_COLOR_ID_GREEN>;
+							function = LED_FUNCTION_LAN;
+							function-enumerator = <9>;
+						};
+					};
 				};
 
 				port@5 {
 					reg = <5>;
 					label = "sw10";
+
+					leds {
+						#address-cells = <1>;
+						#size-cells = <0>;
+
+						led@0 {
+							reg = <0>;
+							color = <LED_COLOR_ID_GREEN>;
+							function = LED_FUNCTION_LAN;
+							function-enumerator = <10>;
+						};
+					};
 				};
 			};
 		};
-- 
2.39.2

