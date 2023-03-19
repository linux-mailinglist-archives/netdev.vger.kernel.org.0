Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 590836C044B
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 20:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbjCSTUS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 15:20:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230058AbjCSTT2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 15:19:28 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A71B1421D;
        Sun, 19 Mar 2023 12:18:54 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id i9so8531111wrp.3;
        Sun, 19 Mar 2023 12:18:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679253531;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y2fNz2U3Pb1myw1nW6JzmHX3WnYBSrD+c2lY+3aHW8M=;
        b=d1ZVZcTj1LPbhIOYtLntFoqX0VTsDE05zKvaqALog6jvGiqCywjPne8LoKvI2qrDAd
         kCsKwPYoPCLwTHOrpCfHlNJmPYKqiNfPGS7c1bLQ/6s4lPzVL8Pw3skHVQWFXa0Pv061
         XiYvFj90z1+4XfvFVTm1jiyPGb2npdlAR5D52cCAxpiYr75unrLycHKDzxlYC5taY+ru
         nmHF2KoCgHsQ7cGShMge6RRhCb7/LzSpeYxzt5nDxsfTSwMLDPHMsd/aom6lhh6fHZvq
         2dlnrYoTFFIW1VmuR4U6JwQ2sg0Zban4OA8FAQAx8H21c0hlml94GpOq34qlFoJaNXuh
         cCFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679253531;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y2fNz2U3Pb1myw1nW6JzmHX3WnYBSrD+c2lY+3aHW8M=;
        b=ZPSdi35tuSqAqhqQZuTpDB9Y3G+OTKOGbWO3NHlT0SXLB27AB6hJuW+BjFIjSheO+d
         Cp3UGAjJ44gYWbH6DOLR8O7nkJoanC4XqzhmnYWThPXvaiWFHvFMLcQZSRkVBuXRkmIY
         ReO+tIREQ84XPMfjHwRlwaJoMGbN7WXj/yEbOlfS/ACed8k+PMJFPk4PCoecM0IdP6mv
         1T3fNxNMQQY//Duygu6i8KiCzbjDAeipdsfxKSFG0fruLt6G3YZ8jt8AIBdsnwj7t6fK
         hYMdUX143nUz6OfCmOm2fLJOkc3oPs2E8Tjb/qKG0G95DZh9KKgJSuehPg3SIVvp1vC6
         cBbA==
X-Gm-Message-State: AO0yUKUiK0cUBzwiTrFYt4Zu36l85I287biYf1P7uBHmVngQMctZkrxU
        BwUHbFIyLV100TmRA5/o87CA9MnnCwA=
X-Google-Smtp-Source: AK7set/3O7C3Es1N1wEdf1ZRK3axSCJX4Dfqg2I56oADb/R8Vu/tWsJomc3xnKQ6cwcdy4GspqURZg==
X-Received: by 2002:adf:d0cb:0:b0:2ce:aa69:c9a7 with SMTP id z11-20020adfd0cb000000b002ceaa69c9a7mr11490176wrh.8.1679253531529;
        Sun, 19 Mar 2023 12:18:51 -0700 (PDT)
Received: from localhost.localdomain (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.googlemail.com with ESMTPSA id b7-20020a5d4b87000000b002cfe0ab1246sm7165167wrt.20.2023.03.19.12.18.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Mar 2023 12:18:51 -0700 (PDT)
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
Subject: [net-next PATCH v5 12/15] arm: qcom: dt: Drop unevaluated properties in switch nodes for rb3011
Date:   Sun, 19 Mar 2023 20:18:11 +0100
Message-Id: <20230319191814.22067-13-ansuelsmth@gmail.com>
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

IPQ8064 MikroTik RB3011UiAS-RM DT have currently unevaluted properties
in the 2 switch nodes. The bindings #address-cells and #size-cells are
redundant and cause warning for 'Unevaluated properties are not
allowed'.

Drop these bindings to mute these warning as they should not be there
from the start.

Cc: Jonathan McDowell <noodles@earth.li>
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 arch/arm/boot/dts/qcom-ipq8064-rb3011.dts | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/arm/boot/dts/qcom-ipq8064-rb3011.dts b/arch/arm/boot/dts/qcom-ipq8064-rb3011.dts
index f908889c4f95..47a5d1849c72 100644
--- a/arch/arm/boot/dts/qcom-ipq8064-rb3011.dts
+++ b/arch/arm/boot/dts/qcom-ipq8064-rb3011.dts
@@ -38,8 +38,6 @@ mdio0: mdio-0 {
 
 		switch0: switch@10 {
 			compatible = "qca,qca8337";
-			#address-cells = <1>;
-			#size-cells = <0>;
 
 			dsa,member = <0 0>;
 
@@ -105,8 +103,6 @@ mdio1: mdio-1 {
 
 		switch1: switch@14 {
 			compatible = "qca,qca8337";
-			#address-cells = <1>;
-			#size-cells = <0>;
 
 			dsa,member = <1 0>;
 
-- 
2.39.2

