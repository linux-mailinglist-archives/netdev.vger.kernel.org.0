Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDA815188C1
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 17:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238663AbiECPkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 11:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238637AbiECPkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 11:40:13 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C14F43054F;
        Tue,  3 May 2022 08:36:35 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id l7so34236396ejn.2;
        Tue, 03 May 2022 08:36:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HxnwmUt5XXOQZLtedBMlDA6s9oP05DqI/7RXSR5ri4c=;
        b=cM0U2RFj32GEW1ILlg1yfmSdYa3AuHHmdzDbV1IAM4fdtu9AlN2s22sESTs+zDQidd
         L06dY9drgbavLz55lW8lt6dKonpDvE5lDCAU6hSRTPFcDzQR8QcPQWsCGJqeWuQ6OIbR
         Xqnkya/gneIhcDexqNiZsj9CIrUM3t8NXWrbv2utsh7I0TkZvJ7QIuBojAHcVoUp8+Gm
         cXULc5zsN+aKys2ibzN5z933r2KPZowMZXcnacBsW5GvrNoMoeh516KS193U5Amm9riQ
         Z8IBWwG8R/REwVqgGvkeHc2WvEf+pfQZ1R3so5XdVCNabHRLArKWeXPC0KPQQ6Ev2IQV
         Cb4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HxnwmUt5XXOQZLtedBMlDA6s9oP05DqI/7RXSR5ri4c=;
        b=p7dYvvFo7rZWWeGYG+s7BEu3Z1auP53ydyV+dMVDQoVL2V1ouAlnL5fEAXmdzT6vmZ
         zgjfeQid5LV2hYM1oPodzIOgN0BW+683B9fPVwuQr+mOAwqtBmPHCxERQWTDFh0Rf128
         usoI2WVm8QfbQwfLit8rLqSxIOZLDlVraV/U5lZKetkxki7odUPi2pBRYjC8nvrvx/9J
         GJDs7oLQuXtaDirlF0XADdk2LnwbdqbajlS64yB/D7c6WYIxYgvdXKXevpokMYn82Gw0
         M+qQRq4AIlHDucXqOlGn1YbrCbpjAqHAflDXSkC8yv8+0rn6jlVNzfvkvpn5nsmATtZU
         /fSA==
X-Gm-Message-State: AOAM530yO5F7WguLkUcTDwFyONb38MprlbBE1OV3eiBV/NUVTzXoLBI7
        0h7ci9tDy6qEMmrDb5uVGjA=
X-Google-Smtp-Source: ABdhPJxNBzYQuUyb1KloWpt4FU5+9Zx8momroPTJWceimkMlPE5juKGMGDeyc1y84IgnNFmzwpDvJg==
X-Received: by 2002:a17:907:97cc:b0:6df:83bc:314c with SMTP id js12-20020a17090797cc00b006df83bc314cmr16170442ejc.587.1651592194344;
        Tue, 03 May 2022 08:36:34 -0700 (PDT)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id yl1-20020a17090693e100b006f3ef214dd1sm4693395ejb.55.2022.05.03.08.36.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 08:36:34 -0700 (PDT)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     Pavel Machek <pavel@ucw.cz>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH 4/4] ARM: dts: BCM5301X: Add triggers for Luxul XWR-1200 network LEDs
Date:   Tue,  3 May 2022 17:36:13 +0200
Message-Id: <20220503153613.15320-4-zajec5@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220503153613.15320-1-zajec5@gmail.com>
References: <20220503153613.15320-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

Those LEDs are not hardware controlled so bootloader / operating system
may want to control them manually depending on switch ports state.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 arch/arm/boot/dts/bcm47081-luxul-xwr-1200.dts | 22 ++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/arch/arm/boot/dts/bcm47081-luxul-xwr-1200.dts b/arch/arm/boot/dts/bcm47081-luxul-xwr-1200.dts
index 9316a36434f7..ee1b0fd3eb86 100644
--- a/arch/arm/boot/dts/bcm47081-luxul-xwr-1200.dts
+++ b/arch/arm/boot/dts/bcm47081-luxul-xwr-1200.dts
@@ -5,6 +5,8 @@
 
 /dts-v1/;
 
+#include <dt-bindings/net/eth.h>
+
 #include "bcm47081.dtsi"
 #include "bcm5301x-nand-cs0-bch4.dtsi"
 
@@ -38,24 +40,28 @@ power {
 		lan3 {
 			label = "bcm53xx:green:lan3";
 			gpios = <&chipcommon 1 GPIO_ACTIVE_LOW>;
+			trigger-sources = <&port_lan3 SPEED_UNSPEC>;
 			linux,default-trigger = "none";
 		};
 
 		lan4 {
 			label = "bcm53xx:green:lan4";
 			gpios = <&chipcommon 2 GPIO_ACTIVE_LOW>;
+			trigger-sources = <&port_lan4 SPEED_UNSPEC>;
 			linux,default-trigger = "none";
 		};
 
 		wan {
 			label = "bcm53xx:green:wan";
 			gpios = <&chipcommon 3 GPIO_ACTIVE_LOW>;
+			trigger-sources = <&port_wan SPEED_UNSPEC>;
 			linux,default-trigger = "none";
 		};
 
 		lan2 {
 			label = "bcm53xx:green:lan2";
 			gpios = <&chipcommon 6 GPIO_ACTIVE_LOW>;
+			trigger-sources = <&port_lan2 SPEED_UNSPEC>;
 			linux,default-trigger = "none";
 		};
 
@@ -87,6 +93,7 @@ status {
 		lan1 {
 			label = "bcm53xx:green:lan1";
 			gpios = <&chipcommon 15 GPIO_ACTIVE_LOW>;
+			trigger-sources = <&port_lan1 SPEED_UNSPEC>;
 			linux,default-trigger = "none";
 		};
 	};
@@ -114,29 +121,34 @@ &srab {
 	status = "okay";
 
 	ports {
-		port@0 {
+		port_lan4: port@0 {
 			reg = <0>;
 			label = "lan4";
+			#trigger-source-cells = <1>;
 		};
 
-		port@1 {
+		port_lan3: port@1 {
 			reg = <1>;
 			label = "lan3";
+			#trigger-source-cells = <1>;
 		};
 
-		port@2 {
+		port_lan2: port@2 {
 			reg = <2>;
 			label = "lan2";
+			#trigger-source-cells = <1>;
 		};
 
-		port@3 {
+		port_lan1: port@3 {
 			reg = <3>;
 			label = "lan1";
+			#trigger-source-cells = <1>;
 		};
 
-		port@4 {
+		port_wan: port@4 {
 			reg = <4>;
 			label = "wan";
+			#trigger-source-cells = <1>;
 		};
 
 		port@5 {
-- 
2.34.1

