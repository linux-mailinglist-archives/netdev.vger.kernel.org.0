Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3926F6CA724
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 16:13:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232209AbjC0ONB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 10:13:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232786AbjC0OMU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 10:12:20 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 640D819BE;
        Mon, 27 Mar 2023 07:11:24 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id r11so8933903wrr.12;
        Mon, 27 Mar 2023 07:11:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679926282;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4yEvSncVqO5CEElyQ6q0WPYP3z8pHrofnI3Ooo06uR0=;
        b=Aau3bKl0Faip1gZpIvhQqkrG6yIvReZj3HRfyt8/bwDm0ntA7hfwBmbFP+w/G7/DDN
         TvGLpV0smiqMuRXKg47C4/SsBzcm2zbrAJ4mwqrXKDjlyeHVvUik6O0NSx/ntBVPKE4i
         GRdlPm1qINSLCl4/VAnVf0RWskvSPgdZ7n2/EeWuXlzZE3faTAEv17XsqO4JoPqYr70u
         e0pBaY5kgXnLmVPb6gPGMHAlUEpW/eL5HWafIaxfdszcqdJcewyVk953gl07ouH9wQCA
         GHfZCuN9QkllVSVghdxrlOM0T2Xzoox63vfwhytFVhitG411GqC4jmtOcB9el95zQtzs
         OJEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679926282;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4yEvSncVqO5CEElyQ6q0WPYP3z8pHrofnI3Ooo06uR0=;
        b=udv46BsxG5jMZzUJ4/U8QfLI6pJcBDdyyiFQUBSqrZGY/vlzPuzPKweAkR45gT7Im5
         AHv10XXacg1Wzop2zYwJ3jgTIwrCNlOjuMxVdAJuN3WaiY2TzDoAaXdZw5n50Chi3QRX
         6QsrWFSfvQZJ9uNQtUds0/eLI8Rx2mOr6C0z6EaxQtLkcBsUnrgBHoTgKncdW34CpiID
         ly3HT4aw2IKPSajFyFbu0TeIJ8F5m78MhAbPyOG7A5GB7QebueHulVzZOaOBy3TM0T3E
         VaB90LHAB1ZLm110Tj6oJfEmu1Vb+4CykvJASo+4Pi/Oxf0aYW2tfZAqYfgGIhdkTgzp
         Gz4A==
X-Gm-Message-State: AAQBX9f9u5QDbOvz5tu4yEvQvOz2KJCJNaoIBrFJX0gQOixrEZA1W7WN
        w2eMwGrFvgeVcehgKGz45ME=
X-Google-Smtp-Source: AKy350YHlc8AI6Nqu9Q31UafJx1CAVWY9j6gnMTbeorrlwXQKAdUx5tbc4eqm+2e4z82qaDUMunUoA==
X-Received: by 2002:adf:f6c9:0:b0:2da:de23:b555 with SMTP id y9-20020adff6c9000000b002dade23b555mr9981054wrp.51.1679926281981;
        Mon, 27 Mar 2023 07:11:21 -0700 (PDT)
Received: from localhost.localdomain (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.googlemail.com with ESMTPSA id p17-20020adfcc91000000b002c71dd1109fsm25307591wrj.47.2023.03.27.07.11.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 07:11:20 -0700 (PDT)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org
Cc:     Jonathan McDowell <noodles@earth.li>
Subject: [net-next PATCH v6 14/16] ARM: dts: qcom: ipq8064-rb3011: Add Switch LED for each port
Date:   Mon, 27 Mar 2023 16:10:29 +0200
Message-Id: <20230327141031.11904-15-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230327141031.11904-1-ansuelsmth@gmail.com>
References: <20230327141031.11904-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
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

