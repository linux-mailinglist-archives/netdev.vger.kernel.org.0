Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 634A3412BC9
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 04:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349991AbhIUChn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 22:37:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241021AbhIUCBQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 22:01:16 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7B84C02FF52;
        Mon, 20 Sep 2021 11:09:16 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id t8so25221027wri.1;
        Mon, 20 Sep 2021 11:09:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=t94BhcQCEr5+Zru01oWCvt2gb3JR6v0ba0MU26fnZcM=;
        b=DpkIdUw0YLbE60FB2DNkmwWI51/4a4e0bT8trDK3n3uJ7fOLbH2PXLNOMnXbzZbzXx
         NmZSCqv64nAE2vBkT8gW0IXfI1dqOkON0l/LqNiypqhiQTwuWCXONRIw4q0oaZOfQiCW
         p2lrEPGwq13CSmRMgdPtMvW25YYHEyP3CMHLV6zAOvVha67zZxNSOQWqJdygne2Yatld
         qtKj6z6mFeX9411GpEWgaeEqJhVXSTqUOJF78yCRr09EVVOjFmCgsKa4d7cl6cmeEvTH
         5za5cSwxnL/lNfPixGX1dGdLnmN8Q921XLX68Koxb6K2qrRCP729GL44TVMzOzEp7U5U
         O8WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=t94BhcQCEr5+Zru01oWCvt2gb3JR6v0ba0MU26fnZcM=;
        b=cfT4MgmpQYWv/smM2QaMmq1/KWniqrouKQLhNpmwgvLv8WYuGq7IXWMaSKWKWq5Dmm
         FfGm86BpJZ6ygUJOynK0Z3SuvIDtbUiypfg69hnHDRlHqLZdp5lZLLi7UBkPlMSvTmOU
         ssaD3g4ZbGx5coilGSzt+IeYY5BWUjapBHcXbTKUfVYHkb57Iq0xdy1sDw9L3Pw0lWhV
         5unude8OjwJeSeDRvd66qKDosIx5xW5SpzK36sZ5GZq6kLREI9nY0sVayQ/9g9Sfw1c7
         crCTvx2G37C3klvVy22a/ehgg89FMNdnqQ/Ytl3H7xPwRpEt+I1GPPyUl5Smkzih0fvH
         ELAA==
X-Gm-Message-State: AOAM530QwNjWM/3pvDMOri9ONCbhDs6WPvv66WD34IgiWmSrOfVGx7dk
        2gGWWDnOTSI0Ovep221q7wc=
X-Google-Smtp-Source: ABdhPJynredCh7mGqIuOol4IHH/74ST6tECEuvraaBmqd42g9xmexXNMWl4oI0EuI8uuOOSAKk2hPg==
X-Received: by 2002:a5d:4cc6:: with SMTP id c6mr30059663wrt.108.1632161355359;
        Mon, 20 Sep 2021 11:09:15 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-67-254.ip85.fastwebnet.it. [93.42.67.254])
        by smtp.googlemail.com with ESMTPSA id w14sm16618646wro.8.2021.09.20.11.09.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Sep 2021 11:09:15 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next RFC PATCH 2/2] Documentation: devicetree: net: dsa: qca8k: document configurable led support
Date:   Mon, 20 Sep 2021 20:08:51 +0200
Message-Id: <20210920180851.30762-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210920180851.30762-1-ansuelsmth@gmail.com>
References: <20210920180851.30762-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document binding for configurable led. Ports led can now be set on/off
and the blink/on rules can be configured using the "qca,led_rules"
binding. Refer to the Documentation on how to configure them.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 .../devicetree/bindings/net/dsa/qca8k.txt     | 249 ++++++++++++++++++
 1 file changed, 249 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.txt b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
index 8c73f67c43ca..233f02cd9e98 100644
--- a/Documentation/devicetree/bindings/net/dsa/qca8k.txt
+++ b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
@@ -29,6 +29,45 @@ the mdio MASTER is used as communication.
 Don't use mixed external and internal mdio-bus configurations, as this is
 not supported by the hardware.
 
+A leds subnode can be declared to configure leds port behaviour.
+The leds subnode must declare the port with the mdio reg that will have the
+attached led. Each port can have a max of 3 different leds. (Refer to example)
+A led can have 4 different settings:
+- Always off
+- Always on
+- Blink at 4hz
+- Hw_mode: This special mode follow control_rule rules and blink based on switch
+event.
+A sysfs entry for control_rule and hw_mode is provided for each led.
+Control rule for phy0-3 are shared and refer to the same reg. That means that
+phy0-3 will blink based on the same rules. Phy4 have its dedicated control_rules.
+
+Each led can have the following binding:
+The binding "default-state" can be declared to set them off by default or to
+follow leds control_rule using the keep value. By default hw_mode is set as it's
+the default switch setting.
+The binding "qca,led_rules" can be used to declare the control_rule set on
+switch setup. The following rules can be applied decalred in an array of string
+in the dts:
+- tx-blink: Led blink on tx traffic for the port
+- rx-blink: Led blink on rx traffic for the port
+- collision-blink: Led blink when a collision is detected for the port
+- link-10M: Led is turned on when a link of 10M is detected for the port
+- link-100M: Led is turned on when a link of 100M is detected for the port
+- link-1000M: Led is turned on when a link of 1000M is detected for the port
+- half-duplex: Led is turned on when a half-duplex link is detected for the port
+- full-duplex: Led is turned on when a full-duplex link is detected for the port
+- linkup-over: Led blinks only when the linkup led is on, ignore blink otherwise
+- power-on-reset: Reset led on switch reset
+- One of
+	- blink-2hz: Led blinks at 2hz frequency
+	- blink-4hz: Led blinks at 4hz frequency
+	- blink-8hz: Led blinks at 8hz frequency
+	- blink-auto: Led blinks at 2hz frequency with 10M, 4hz with 100M, 8hz
+	  with 1000M
+Due to the phy0-3 limitation, multiple use of 'qca8k_led_rules' will result in
+the last defined one to be applied.
+
 The CPU port of this switch is always port 0.
 
 A CPU port node has the following optional node:
@@ -213,3 +252,213 @@ for the internal master mdio-bus configuration:
 			};
 		};
 	};
+
+for the leds declaration example:
+
+#include <dt-bindings/leds/common.h>
+
+	&mdio0 {
+		switch@10 {
+			compatible = "qca,qca8337";
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			reset-gpios = <&gpio 42 GPIO_ACTIVE_LOW>;
+			reg = <0x10>;
+
+			ports {
+				#address-cells = <1>;
+				#size-cells = <0>;
+
+				port@0 {
+					reg = <0>;
+					label = "cpu";
+					ethernet = <&gmac1>;
+					phy-mode = "rgmii";
+					fixed-link {
+						speed = 1000;
+						full-duplex;
+					};
+				};
+
+				port@1 {
+					reg = <1>;
+					label = "lan1";
+					phy-mode = "internal";
+					phy-handle = <&phy_port1>;
+				};
+
+				port@2 {
+					reg = <2>;
+					label = "lan2";
+					phy-mode = "internal";
+					phy-handle = <&phy_port2>;
+				};
+
+				port@3 {
+					reg = <3>;
+					label = "lan3";
+					phy-mode = "internal";
+					phy-handle = <&phy_port3>;
+				};
+
+				port@4 {
+					reg = <4>;
+					label = "lan4";
+					phy-mode = "internal";
+					phy-handle = <&phy_port4>;
+				};
+
+				port@5 {
+					reg = <5>;
+					label = "wan";
+					phy-mode = "internal";
+					phy-handle = <&phy_port5>;
+				};
+			};
+
+			mdio {
+				#address-cells = <1>;
+				#size-cells = <0>;
+
+				phy_port1: phy@0 {
+					reg = <0>;
+				};
+
+				phy_port2: phy@1 {
+					reg = <1>;
+				};
+
+				phy_port3: phy@2 {
+					reg = <2>;
+				};
+
+				phy_port4: phy@3 {
+					reg = <3>;
+				};
+
+				phy_port5: phy@4 {
+					reg = <4>;
+				};
+			};
+
+			leds {
+				#address-cells = <1>;
+				#size-cells = <0>;
+
+				phy@0 {
+					#address-cells = <1>;
+					#size-cells = <0>;
+
+					reg = <0>;
+
+					led@0 {
+						reg = <0>;
+						color = <LED_COLOR_ID_GREEN>;
+						default-state = "keep";
+						function = LED_FUNCTION_LAN;
+						function-enumerator = <1>;
+					};
+
+					led@1 {
+						reg = <1>;
+						color = <LED_COLOR_ID_AMBER>;
+						default-state = "keep";
+						function = LED_FUNCTION_LAN;
+						function-enumerator = <1>;
+					};
+				};
+
+				phy@1 {
+					#address-cells = <1>;
+					#size-cells = <0>;
+
+					reg = <1>;
+
+					led@0 {
+						reg = <0>;
+						color = <LED_COLOR_ID_GREEN>;
+						default-state = "keep";
+						function = LED_FUNCTION_LAN;
+						function-enumerator = <2>;
+					};
+
+					led@1 {
+						reg = <1>;
+						color = <LED_COLOR_ID_AMBER>;
+						default-state = "keep";
+						function = LED_FUNCTION_LAN;
+						function-enumerator = <2>;
+					};
+				};
+
+				phy@2 {
+					#address-cells = <1>;
+					#size-cells = <0>;
+
+					reg = <2>;
+
+					led@0 {
+						reg = <0>;
+						color = <LED_COLOR_ID_GREEN>;
+						default-state = "keep";
+						function = LED_FUNCTION_LAN;
+						function-enumerator = <3>;
+					};
+
+					led@1 {
+						reg = <1>;
+						color = <LED_COLOR_ID_AMBER>;
+						default-state = "keep";
+						function = LED_FUNCTION_LAN;
+						function-enumerator = <3>;
+					};
+				};
+
+				phy@3 {
+					#address-cells = <1>;
+					#size-cells = <0>;
+
+					reg = <3>;
+
+					led@0 {
+						reg = <0>;
+						color = <LED_COLOR_ID_GREEN>;
+						default-state = "keep";
+						function = LED_FUNCTION_LAN;
+						function-enumerator = <4>;
+					};
+
+					led@1 {
+						reg = <1>;
+						color = <LED_COLOR_ID_AMBER>;
+						default-state = "keep";
+						function = LED_FUNCTION_LAN;
+						function-enumerator = <4>;
+					};
+				};
+
+				phy@4 {
+					#address-cells = <1>;
+					#size-cells = <0>;
+
+					reg = <4>;
+
+					led@0 {
+						reg = <0>;
+						color = <LED_COLOR_ID_GREEN>;
+						default-state = "keep";
+						function = LED_FUNCTION_WAN;
+						qca,led_rules = "tx-blink", "rx-blink", "link-1000M", "full-duplex", "linkup-over", "blink-8hz";
+					};
+
+					led@1 {
+						reg = <1>;
+						color = <LED_COLOR_ID_AMBER>;
+						default-state = "keep";
+						function = LED_FUNCTION_WAN;
+					};
+				};
+			};
+		};
+	};
\ No newline at end of file
-- 
2.32.0

