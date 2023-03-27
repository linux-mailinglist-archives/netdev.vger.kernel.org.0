Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D5B26CA730
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 16:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233049AbjC0ONe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 10:13:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232866AbjC0OMo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 10:12:44 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 725CE658D;
        Mon, 27 Mar 2023 07:11:29 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id i9so8959448wrp.3;
        Mon, 27 Mar 2023 07:11:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679926285;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oy4rJp/0zV8uQx96aqdFOna+cm21IPd+B8/oErRDE1c=;
        b=N1+9G3TumKrPZKtDgnUYD6HDreYZGrsnCsG3x6VR1o6zsdlKygYn5Z2B/6MK7uSEib
         /66G9qTuGKBx/QqmSMP7T42XAs/7GFQk8nHeM2yzmROF/lCWibWpheeY7B2GIYdPhN1b
         9GOlfffc+AZNhfrEsFIJ3yAaWe0xtdGPgJ7Kl/Hxs1k3JTD2gzvl09ggMzmHbEwGGjX0
         5zZz5BzkFOFGFyvfTTjuPhvEr8tGjp/IpmshsxkTYQ/MxRyhYQnC07KfzFJlhNkTtrfr
         U+DjoUUgEiUUffoufrfwBWTA2WZQ8MQAdVmgCLlpPjCWptllhVOFI+HVVbkY+10eJdED
         7MAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679926285;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oy4rJp/0zV8uQx96aqdFOna+cm21IPd+B8/oErRDE1c=;
        b=FMq992CpDPrMpcuoNU7v2pHnJ5WKkCjoRtruPc5m3muB4eg9xCAjexKkTsEroi+5hA
         durhU+5iBGOl/FoytHyGN6pLTqSDuY/4oc/vvpXD/yiORs9XLlExHXAFxEoVc8L4An/G
         +i61vETMfq9ZVUVG0vFD5rqTdjroN+gwJx2tmmH6zzDJZsXG0In7PZQKEk1cOmWrcK1u
         lqFFSjWFvUcKg/TBdi4lENPhFWZwAD+ogrU07Prv5zqlTQ+F/eC3wTnfl+jpwj86RfOh
         jr5rHMMI5fZZqc+W/WHSHoTm/Vq876gIIEmaHN3OH7NB8RINqn+WicFilTAO6HzRXXZ2
         dlKg==
X-Gm-Message-State: AAQBX9cRRe04NsHN3WvViu0vNRBelz/muQ6LV/Mpp7RhuKm7OiKkH2KZ
        qdll3xKrzazm0df3Kq7B0nA=
X-Google-Smtp-Source: AKy350bY2vBFHRJIpmB9jjsdfXbR2+U5xce8+gKxuwZJYB+85/mF1ngen08oj5b5T/J/Vu/xGqkEyw==
X-Received: by 2002:adf:e5d1:0:b0:2ce:a7f5:ff10 with SMTP id a17-20020adfe5d1000000b002cea7f5ff10mr8517757wrn.57.1679926285261;
        Mon, 27 Mar 2023 07:11:25 -0700 (PDT)
Received: from localhost.localdomain (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.googlemail.com with ESMTPSA id p17-20020adfcc91000000b002c71dd1109fsm25307591wrj.47.2023.03.27.07.11.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 07:11:24 -0700 (PDT)
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
Subject: [net-next PATCH v6 16/16] arm: mvebu: dt: Add PHY LED support for 370-rd WAN port
Date:   Mon, 27 Mar 2023 16:10:31 +0200
Message-Id: <20230327141031.11904-17-ansuelsmth@gmail.com>
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

