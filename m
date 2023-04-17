Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4E5F6E4CF3
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 17:23:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231390AbjDQPXM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 11:23:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231158AbjDQPWf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 11:22:35 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F892CC0A;
        Mon, 17 Apr 2023 08:21:39 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id 5b1f17b1804b1-3f09b9ac51dso44193835e9.0;
        Mon, 17 Apr 2023 08:21:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681744894; x=1684336894;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uo9NeRox2kKaV6EedLI2eZW+lysXw2QxnOyywslULt4=;
        b=emXly7tMcVulCwtHdgRBKdzlZK74cPjTMaLFLkBeS5R/Ej26fWeR0jwlKJlYtRhduh
         ULn6NyC1S9BxTPiO8QcFWKgNv2lPmbOzTAyDaTcfBWM8Qcg+vS5KD26itECBt8l1x0xc
         Agu1iqMmXS1YvM+/xiCG4JlAB023R5TmPTdSl0FrvrmSIdk93toMXZyrTshlfEUT6HZl
         QR8rCckx/3vdxbGMQby0eSHnEh3Zm/y73xSlGEUd4FKcJP6/ZCwR+Z+f+9oYiC1gX54D
         8DDKetmF7uVjnvrAlbGpjM9Jm2eW4RGOJAXQ/+KnOTcPfv1PQvcq61toLN2RjDnXS5Br
         FEhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681744894; x=1684336894;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uo9NeRox2kKaV6EedLI2eZW+lysXw2QxnOyywslULt4=;
        b=Nf+MxHyYEGlT1PqJ2uxWMQp4SXWiX8ytwWHHjChkU8zzUCtSHqPdlNGlGCUL3e0olY
         S6hiE5AO1UP108hX6i+eT2mA7P1jNOHug3Bjl3GvwOX0ytkCXBlxTTIjV/bx8KOL252o
         uS48xfaN1j9BjqNXJRUEi+8Jv+U7DsOUxwgpKqBxNT+CDdS+uGaxJJ04mqvxN92uy8rW
         93ZKTOzxc0kHMhOng3xmsU2cqaivJImGFKI8IblCz/pPwQoM3oaWuiNZ7C7JxgbuWwYx
         0CPzViNquAJUW9IBvInkiHL4Gqlaxy2PGcfW7FnWt3cXY9pfmk4NVRIPHL/gjSWyoIYK
         lf5Q==
X-Gm-Message-State: AAQBX9fK669MgmfEcptEn12lT2ZSJZEIDzTD81vOiVGDZS/5JrcugAzu
        BlFVlUobNUkml1yiWKZuyWc=
X-Google-Smtp-Source: AKy350ZkN8k4WRz16WTIl1fWsH+BlMhqoCkn8fA0qyImErw0tC1bPi0oEm7HUBt5/Z7wylzg4/LhrQ==
X-Received: by 2002:a05:6000:100f:b0:2d9:10e7:57e8 with SMTP id a15-20020a056000100f00b002d910e757e8mr5223990wrx.16.1681744893773;
        Mon, 17 Apr 2023 08:21:33 -0700 (PDT)
Received: from localhost.localdomain (host-87-7-13-196.retail.telecomitalia.it. [87.7.13.196])
        by smtp.googlemail.com with ESMTPSA id j15-20020a05600c1c0f00b003f173be2ccfsm3501354wms.2.2023.04.17.08.21.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 08:21:32 -0700 (PDT)
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
Cc:     Jonathan McDowell <noodles@earth.li>
Subject: [net-next PATCH v7 13/16] ARM: dts: qcom: ipq8064-rb3011: Add Switch LED for each port
Date:   Mon, 17 Apr 2023 17:17:35 +0200
Message-Id: <20230417151738.19426-14-ansuelsmth@gmail.com>
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
index 47a5d1849c72..4d509876294b 100644
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
+							default-state = "keep";
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
+							default-state = "keep";
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
+							default-state = "keep";
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
+							default-state = "keep";
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
+							default-state = "keep";
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
+							default-state = "keep";
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
+							default-state = "keep";
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
+							default-state = "keep";
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
+							default-state = "keep";
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
+							default-state = "keep";
+						};
+					};
 				};
 			};
 		};
-- 
2.39.2

