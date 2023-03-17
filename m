Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 417B26BDEEA
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 03:34:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbjCQCe1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 22:34:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230091AbjCQCeL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 22:34:11 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8EF48A4E;
        Thu, 16 Mar 2023 19:33:42 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id w11so1410295wmo.2;
        Thu, 16 Mar 2023 19:33:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679020418;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oy4rJp/0zV8uQx96aqdFOna+cm21IPd+B8/oErRDE1c=;
        b=DiYT5S/jOvNwe4CzhjdiIkvIKBggeGR7CexVNd4rd/sjT5lAPS1XWF1W+7fLOFMLc9
         +M+nVvH/VqGoT3HRVUevSaiDK++YKjOvPsz8umYJfLqED/NO2vBkV/scUd1luER6cra4
         MU9TLGEoBzC2egkV45V3/dkoR/6reCXuIEI/4Onu6ISM86v2ODghCyVpzQR3QShPKWAL
         9jZ7MIgNa9bnV7GstyBvBvcr169haI0sCUfFl73RZ7foJuE+TayH+Tf6hYDaMGLkB/kS
         fhVvp3xBGubVX6uhvop1IHbnljGIKuh1xuXwPSH1/oNVSjdbVXXZJzhlDpDrUqMIbqpC
         kXqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679020418;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oy4rJp/0zV8uQx96aqdFOna+cm21IPd+B8/oErRDE1c=;
        b=rPGCMwC5lEyATn2XIj9TYWwccH0ijOOKbKu505DFQ/yntSXE6LIM+EsgjTXDIXWnox
         9cLKLknfWu6BSGE2ITyTfOhv9M70nO/2ZvtwMRzfH9vIMtt3xV+KEZYpVQRw7MusGQMM
         ssK3BE95Wo+oBu6l6dEdmH4FBvVpGcLlC9scX4+3XFLpHY9qRL2QjNqdXI2rG6ZSRox2
         Y0iW5oBHh17kNGyYokI3ow/r8/awDBnZEXsXuvVGT8/VlxGPqNO2PwngLQkxwgpoAnvK
         kZ/h+gPd4Kotz6NPaetljhabqCjm8XnFJ5HFWGkGVy6KVlkGr88N5SJxgiI7kPzRp2Rv
         3btQ==
X-Gm-Message-State: AO0yUKXldj1G0urmL+gT+amy9DmOIpf1b1/2Er6nlJS/QRdIop5mG1Vd
        81TqJpwJiEqY863/WopY24o=
X-Google-Smtp-Source: AK7set/vLpvKe0YMV6V4xFFxWeIDZxral5oel3M8ZEVRVHfcThgwCE2w0hq0lN0ZZ/FAMivfH7aOVw==
X-Received: by 2002:a1c:7215:0:b0:3ed:5d41:f9a7 with SMTP id n21-20020a1c7215000000b003ed5d41f9a7mr3675091wmc.2.1679020418287;
        Thu, 16 Mar 2023 19:33:38 -0700 (PDT)
Received: from localhost.localdomain (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.googlemail.com with ESMTPSA id z15-20020a5d44cf000000b002ce9f0e4a8fsm782313wrr.84.2023.03.16.19.33.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 19:33:38 -0700 (PDT)
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
Subject: [net-next PATCH v4 14/14] arm: mvebu: dt: Add PHY LED support for 370-rd WAN port
Date:   Fri, 17 Mar 2023 03:31:25 +0100
Message-Id: <20230317023125.486-15-ansuelsmth@gmail.com>
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

From: Andrew Lunn <andrew@lunn.ch>

The WAN port of the 370-RD has a Marvell PHY, with one LED on
the front panel. List this LED in the device tree.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 arch/arm/boot/dts/armada-370-rd.dts | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/arm/boot/dts/armada-370-rd.dts b/arch/arm/boot/dts/armada-370-rd.dts
index be005c9f42ef..15b36aa34ef4 100644
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
+				linux,default-trigger = "netdev";
+			};
+		};
 	};
 
 	switch: switch@10 {
-- 
2.39.2

