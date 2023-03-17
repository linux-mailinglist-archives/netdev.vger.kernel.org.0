Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6A366BDEDE
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 03:34:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbjCQCeP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 22:34:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbjCQCd6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 22:33:58 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6886E76049;
        Thu, 16 Mar 2023 19:33:37 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id p16so2459524wmq.5;
        Thu, 16 Mar 2023 19:33:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679020415;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4yEvSncVqO5CEElyQ6q0WPYP3z8pHrofnI3Ooo06uR0=;
        b=nITNr7nLrqTYxWL4bn+CtPurpHoc8uOjmWFHoXcjWDzjRK4fS9Y4P23E3xF4gXbUfP
         KpVaQwvuhjx4mzn1d09NeYAzyrdEVO4uGFdpAYiV9YuaQwxNfvOiVk9KNbm795kd9r/B
         HiyZwJNLM+MITtsYOGYUrZtBLfCl9JdMss5hA2s6OmQO097WVFXXZRb8licVShLhKLyZ
         krqCgtkmLS8VQLjo+ZUI38OvmHdDtPXV5uTbB35gt1DPcaj8/u1Mg2Fd/+OX9pyTBmb5
         ibT6P1xkuWKausYDgQ2gVxq3I+1D1US56ryQl1oGERS3yRzp73aCkad6tkeFz6qW5ZyC
         +lDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679020415;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4yEvSncVqO5CEElyQ6q0WPYP3z8pHrofnI3Ooo06uR0=;
        b=YxoeMlN6E58cvW1s7SKKOytrSORK1OUz89L8N1zySMuPE4EyGpOFu98IhpXPtTnDyV
         iMJA3QiGeUs85XW1QaNiJGegwAjbZexcENHL8EGN+Lrq/3iO9FSEuB39YbPmrPP0xBMv
         PAjWZ6xGNcC+Y4eXg4e9oJ7pC4+T4aypZpfVbI8uZQcP2fiSa5oZX9b3JRZGPwbF09rb
         14YuMN6+fTIauk9nEFjLcOK/VMGc6IxfKG7Zp11iYbMfp1zYBd/tYjsPhrluAEx/+GOS
         EVZcDnn/VKYzIijJAoW6SMX2lVT3nSqZ66kbRqsMzNg78wdkhJVJF6drhZVHnMwV96zn
         FIew==
X-Gm-Message-State: AO0yUKVITQnGqmyalG5y7upsjMHOgoKI3sYu/X6XjtrXB0A9g/qBgVG8
        vFqvbDtwL5kVzTxKKC3jYys=
X-Google-Smtp-Source: AK7set+TV3X+/9ZMMNIHAk9vRTQoNHzhcsG6yri6suzQjhKXYo+mQdrkSu1NqHBDoHdDgogb1rCE/Q==
X-Received: by 2002:a05:600c:34c1:b0:3eb:383c:1876 with SMTP id d1-20020a05600c34c100b003eb383c1876mr23460133wmq.6.1679020415624;
        Thu, 16 Mar 2023 19:33:35 -0700 (PDT)
Received: from localhost.localdomain (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.googlemail.com with ESMTPSA id z15-20020a5d44cf000000b002ce9f0e4a8fsm782313wrr.84.2023.03.16.19.33.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 19:33:35 -0700 (PDT)
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
Cc:     Jonathan McDowell <noodles@earth.li>
Subject: [net-next PATCH v4 12/14] arm: qcom: dt: Add Switch LED for each port for rb3011
Date:   Fri, 17 Mar 2023 03:31:23 +0100
Message-Id: <20230317023125.486-13-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230317023125.486-1-ansuelsmth@gmail.com>
References: <20230317023125.486-1-ansuelsmth@gmail.com>
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

