Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E50B051C1B9
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 15:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232613AbiEEN70 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 09:59:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351058AbiEEN7Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 09:59:16 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 339A51834B;
        Thu,  5 May 2022 06:55:35 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id be20so5275643edb.12;
        Thu, 05 May 2022 06:55:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HxnwmUt5XXOQZLtedBMlDA6s9oP05DqI/7RXSR5ri4c=;
        b=f74uBA86yjxvRibJ5/m+mK0DKh+ITswdWnRayKUptZ68YBTe6giJ2U/Lff31CW9f2n
         9xGhm2wejuObPDBrG/3iASSUq9QfrBEHo9CHcJOx+LtXaAk3kBaC8NYeHavBp9JJPJW3
         4/jU+k7P7Nv51sG3CBKYgFLbUSE8DJyl8s3/o7mtfgrioAjbcaESnqnMPYUzvVVgwt99
         I2JWRpZiaWk/V5OWWuYafMakfSJUZBXNhnJ/0ExZAUI+CKp7mWEh7WdkidS8L9exbXd0
         TkBYmGpCOIIezWpQPkCXVDhGeP9ylbzvBrrpUNYBUv6B4SIsypPPL2nb5wfM+F1LFumY
         aD/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HxnwmUt5XXOQZLtedBMlDA6s9oP05DqI/7RXSR5ri4c=;
        b=cPtLxMJgCQ7e59Qy1y0MRo7O1zTWbmp+i1uCjFLZCnUcw+5XH6R7sXBbBqVMBd4PaV
         Uemc2aWgooB6Ktn4ZMuuEqeO8gESiG6gaIBaJBWQeOOTYnJvfdx7L8G1IyrdTul1G2W6
         mUvJTDJ2L+dqS0wbjuLk5Is7Zw4N22GFldbA5QUOlEwB0CFhnFIeNo3QVtmErSJJD5XJ
         M8eXJPHpoOzG+ZvXYeK/tgoAnarD1GXeAlIm6Z4jFBG6ekm879rinbcFZjBJlOm4FiWR
         lJIIC2pK5tPa+4A2I+5a4MMDboDCYQqhxY2nDXw44YjoUPkaSbB8O3BivmPxtdM59VcF
         Ss7w==
X-Gm-Message-State: AOAM533nCwuK4vIAa78mFBrPuyuvaegwFHzcylNT04B+mg5MXNJMDDCz
        WOfkkLDlVwmnSK8mRnVeu6c=
X-Google-Smtp-Source: ABdhPJzKQ4doBuTShpt/bqmUap9zPNLxvV2r0btNGW4wF9eKsbrNNiPReGQVLou27wEe566MwrMcEg==
X-Received: by 2002:a05:6402:26d3:b0:427:c571:86fe with SMTP id x19-20020a05640226d300b00427c57186femr22415605edd.133.1651758933825;
        Thu, 05 May 2022 06:55:33 -0700 (PDT)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id e15-20020a50e44f000000b0042617ba63c7sm877949edm.81.2022.05.05.06.55.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 06:55:33 -0700 (PDT)
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
        bcm-kernel-feedback-list@broadcom.com, ansuelsmth@gmail.com,
        andrew@lunn.ch, vivien.didelot@gmail.com,
        Vladimir Oltean <olteanv@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        John Crispin <john@phrozen.org>, linux-doc@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH RESEND 4/5] ARM: dts: BCM5301X: Add triggers for Luxul XWR-1200 network LEDs
Date:   Thu,  5 May 2022 15:55:11 +0200
Message-Id: <20220505135512.3486-5-zajec5@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220505135512.3486-1-zajec5@gmail.com>
References: <20220505135512.3486-1-zajec5@gmail.com>
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

