Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70591379CAD
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 04:10:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231621AbhEKCKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 22:10:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231317AbhEKCJZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 22:09:25 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 673FBC06135B;
        Mon, 10 May 2021 19:07:44 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id m9so18491680wrx.3;
        Mon, 10 May 2021 19:07:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AvmCOiUNL/J1Z55AamjlG9ZqLZyqiT6b00mxThZzYLg=;
        b=ivJQh3q/DDvzpo1Oq69+kgli2nrFXYzISJnHIXJ8WDH1S7aogzm/9r2xYWvg+Y1vAg
         JEQWJrCAeWzVmcT+I6iotXp/OvP2B+eKPAOyk7dBAutBAeSQHHpC0R+VxU9Mq8CX4HFN
         /JfuNGtgSsnrN/1pLHB6iiBBpW2lWG8ShGY1MCZWZ9m6WYx/5lrtNLxAWq55pn/32OXM
         woDB8OCFOzSwRBROiq49LplOFnHbUH8VUN+78tSL9SjAOBYPsPOpfH9+09hxWJqUXnK8
         +yRl3wkTEjFo20BtOZEFacV31QWiTG9dWbVh4pVKrSuEve6BFud3ABuKSOzv/NXnmyll
         7ADA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AvmCOiUNL/J1Z55AamjlG9ZqLZyqiT6b00mxThZzYLg=;
        b=fQQcLYKtaTNv7gsw7Ffz6Mq/xSXvimWCyQ2ErXsO6qMRyJ5lRdJvtttBlt7jXGSolA
         LHbqM3LCy90Spvw6V5DbI1GWoyChRbmq7HcIwkOhXQqD0C0MoxQThUJiX1oiLrg/55vA
         YMKdZ/h8+rvQs/FSPGYkd6+GsdN5eUEWykEofsak8HeHZ3l9hbBUSwe5BcYiEDd3GPlK
         I/XVmM+JTMp/GpCdUz1G3bYHyEswAIWHyM7hwSdj4T4L+bsRrLDeehJtuT1xdf/4yZWy
         qtW8IsuZ565cCUPgEvUow+7PiutZFx/i7UcSV2uuOBvvP8zC9tQfT2vY6DPhvvw6NFOJ
         4Lhw==
X-Gm-Message-State: AOAM531eTNwgbisx3/SYrX6pqACXh+KKksnU0g2Ee57coUR+SZHNVgKa
        6AnHI4XK7JuGdoPAeEDBN4Y=
X-Google-Smtp-Source: ABdhPJxvP9hwMWXlXCj/uiagioo2payquVWLbu8S1bsjrESvx83zcnmy0zLDqcVaSwsn2GwG24Q/mQ==
X-Received: by 2002:adf:f192:: with SMTP id h18mr33300328wro.270.1620698863073;
        Mon, 10 May 2021 19:07:43 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id q20sm2607436wmq.2.2021.05.10.19.07.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 19:07:42 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS), linux-kernel@vger.kernel.org (open list)
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [RFC PATCH net-next v5 21/25] devicetree: bindings: dsa: qca8k: Document internal mdio definition
Date:   Tue, 11 May 2021 04:04:56 +0200
Message-Id: <20210511020500.17269-22-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210511020500.17269-1-ansuelsmth@gmail.com>
References: <20210511020500.17269-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document new way of declare mapping of internal PHY to port.
The new implementation directly declare the PHY connected to the port
by adding a node in the switch node. The driver detect this and register
an internal mdiobus using the mapping defined in the mdio node.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 .../devicetree/bindings/net/dsa/qca8k.txt     | 39 +++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.txt b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
index 1daf68e7ae19..3973a9d3e426 100644
--- a/Documentation/devicetree/bindings/net/dsa/qca8k.txt
+++ b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
@@ -21,6 +21,10 @@ described in dsa/dsa.txt. If the QCA8K switch is connect to a SoC's external
 mdio-bus each subnode describing a port needs to have a valid phandle
 referencing the internal PHY it is connected to. This is because there's no
 N:N mapping of port and PHY id.
+To declare the internal mdio-bus configuration, declare a mdio node in the
+switch node and declare the phandle for the port referencing the internal
+PHY is connected to. In this config a internal mdio-bus is registred and
+the mdio MASTER is used as communication.
 
 Don't use mixed external and internal mdio-bus configurations, as this is
 not supported by the hardware.
@@ -150,26 +154,61 @@ for the internal master mdio-bus configuration:
 				port@1 {
 					reg = <1>;
 					label = "lan1";
+					phy-mode = "internal";
+					phy-handle = <&phy_port1>;
 				};
 
 				port@2 {
 					reg = <2>;
 					label = "lan2";
+					phy-mode = "internal";
+					phy-handle = <&phy_port2>;
 				};
 
 				port@3 {
 					reg = <3>;
 					label = "lan3";
+					phy-mode = "internal";
+					phy-handle = <&phy_port3>;
 				};
 
 				port@4 {
 					reg = <4>;
 					label = "lan4";
+					phy-mode = "internal";
+					phy-handle = <&phy_port4>;
 				};
 
 				port@5 {
 					reg = <5>;
 					label = "wan";
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
 				};
 			};
 		};
-- 
2.30.2

