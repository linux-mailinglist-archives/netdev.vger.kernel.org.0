Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEB526B9B27
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 17:19:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbjCNQS4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 12:18:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231448AbjCNQSE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 12:18:04 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B33C4B2555;
        Tue, 14 Mar 2023 09:17:39 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id t15so14876087wrz.7;
        Tue, 14 Mar 2023 09:17:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678810658;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4yEvSncVqO5CEElyQ6q0WPYP3z8pHrofnI3Ooo06uR0=;
        b=K+mLMUl0yoH5CirM02UvggJLlSVXwFmixzghnFZQfwQxlZ4QvmI7bl9d/svg/6pmMp
         aDULurfPwfxvXNqYpSlDfCQjFrO0nnzvnXcEDbw0SOX+3zQY1iHLYhUiaGhWhe234DEs
         Md5SPcTHRbnoBNCKsDwEjWmDRiMppyPqKNGCllPkhUe2SPOgOu5GUBulS+qQ0SBiMuI3
         H2d8Y0bvzw4rBcWkaZBNxzGrkjXJTqui1j6xiG2AxvupTtdTE5v3+D9fzMoJvPwAhSCo
         Kkcf//mL9Lyc+oKVhfhrrc0YoNC5tqKFb8wNaz0XJYH4IE+LKXLfJWdTduA2rgY3V4hD
         a/Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678810658;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4yEvSncVqO5CEElyQ6q0WPYP3z8pHrofnI3Ooo06uR0=;
        b=STOUgshWYrfSzQAT6iCjef7OIntOY+QQaBkik/PlsM65Jq6einqG/IEd8YGLk6B/7N
         Gcgq+WdnhZo06UZ6I0VsQ8i57lOrmsk5jFyyDGrJ9p7dnOF91wPqVV0aKQhug8LqK/i8
         c+eEjdCR+sl7aizt1je17szzlgWApZ6n2a/jRPqDaIW62YvYynZy9oPFlIlcTaueTako
         PIIugcWoQdCPsNi37FGzlHZEFkdHN8UUNkcY8OkDwz8LZro/OTNSgmfUJVWXokpKEC2W
         Rcn8IJFhw9Hp9rKnSg2LyGrSKhEWz0GVRUKez9wFkUdAq7tbSAzQ600XE8oxZonxwmmv
         2S/g==
X-Gm-Message-State: AO0yUKV5lNSOeGl4rR1/cwVb2hMOCDcI/42kigaMv6eNtr9Zmom2wI7M
        gtihjQEKpqQaMy4BlkxM61M=
X-Google-Smtp-Source: AK7set+q1pki70n1ymc46lf0MXKuI84bGML7ZPXJbNEMqNYR9zZe3I9xajlWlLZS/BM5t0Kr88ZOXg==
X-Received: by 2002:a05:6000:12c9:b0:2cc:4dad:e484 with SMTP id l9-20020a05600012c900b002cc4dade484mr24744498wrx.42.1678810658079;
        Tue, 14 Mar 2023 09:17:38 -0700 (PDT)
Received: from localhost.localdomain (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.googlemail.com with ESMTPSA id a16-20020a5d4570000000b002c5539171d1sm2426821wrc.41.2023.03.14.09.17.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 09:17:37 -0700 (PDT)
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
Subject: [net-next PATCH v3 12/14] arm: qcom: dt: Add Switch LED for each port for rb3011
Date:   Tue, 14 Mar 2023 11:15:14 +0100
Message-Id: <20230314101516.20427-13-ansuelsmth@gmail.com>
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

