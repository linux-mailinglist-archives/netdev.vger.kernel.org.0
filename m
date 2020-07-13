Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88D2721DE0D
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 18:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730407AbgGMQ7O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 12:59:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730179AbgGMQ7K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 12:59:10 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E2E2C08C5DF
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 09:59:08 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id n26so18072224ejx.0
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 09:59:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lHuvX8jsEPw6DIvNPolaBEfeQZn0WxgbVcqt40u51Qk=;
        b=CGFryYum/1URRMkWMLxadsqjw83xvuWORX8YbaE2lozXCqwaO9/1f+YYOo5//auT5C
         Bx0TLGT+k/pRpcZVvhHeNXI/IBL7Lq9WMtcsZPJafQwhMpYPG49VjsChP2JrRqSsvUUD
         VAHBLwKzEZGltECaebPdgCkeG9XlypQ2/z4Ae1YYgw755lz7yiIl6Y2SOKbQKc66agGF
         PsqcuMJTHhB2wMQqSbr9f6px97HeifWhGUtWD4/CnbAgocPmTtTkr9D0mZWqRkdoDUyl
         p7mdIOaCGkW8TR/9ZLUZDuQoK37Y51EByqm1Re9pz+jTme57LNlJ8Bw8AIm+XSyySweF
         4pQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lHuvX8jsEPw6DIvNPolaBEfeQZn0WxgbVcqt40u51Qk=;
        b=ST9dUzBIa5pQPFNRozqyoME0BTFx3p3Y79JdG4Xb9104fagH68s/wfQzbB/vkWpPPN
         mEjHJ1WyLi/Hzfx930HqvIuMLC7JRdi0+0Y6E+PKwpdBBWHv//qkuRhtXVqf6NiNyAyU
         VtPcIzG/+wR/gxhv24aAkLULLIcXl0iHDAhTwnzPVwBH6PLQ7tXE3nFEdEt447v9R5qg
         qCeJ2jN1YuT3sKmgX2/WwVgC/2B+VPV+Lu8q1XQkDvlUmWB2/5H+kWu+RzQYu6PgifdK
         EcaMGAnezrHW7XER1JarnI2HLdjXW5pfBXr3g+y39PrskwPBk15Ry/kjnnEq32HQQ2bX
         OaoA==
X-Gm-Message-State: AOAM5336nknuT3CsWMYJVf/tu8XkJTrsw7tpKq0og2KBZcwaETmG1U4R
        wMGofVXCL1A1MutAgLNfH8Y=
X-Google-Smtp-Source: ABdhPJwQtLt8IL5dyZpoxBuW9YOyiYL67QSD6dj4V2PjRRHN6+G2mkiiaLGh/5Mjk8Mld3Sz0IKgeg==
X-Received: by 2002:a17:906:3009:: with SMTP id 9mr640949ejz.220.1594659546876;
        Mon, 13 Jul 2020 09:59:06 -0700 (PDT)
Received: from localhost.localdomain ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id y1sm12986732ede.7.2020.07.13.09.59.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 09:59:06 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, antoine.tenart@bootlin.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        madalin.bucur@oss.nxp.com, radu-andrei.bulie@nxp.com,
        fido_max@inbox.ru
Subject: [PATCH v4 net-next 11/11] docs: devicetree: add bindings for Seville DSA switch inside Felix driver
Date:   Mon, 13 Jul 2020 19:57:11 +0300
Message-Id: <20200713165711.2518150-12-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200713165711.2518150-1-olteanv@gmail.com>
References: <20200713165711.2518150-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

There are no non-standard bindings being used. However Felix is a PCI
device and Seville is a platform device. So give an example of device
tree for this switch and document its compatible string.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v4:
Patch is new (split from 10/11).

 .../devicetree/bindings/net/dsa/ocelot.txt    | 105 +++++++++++++++++-
 1 file changed, 101 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/ocelot.txt b/Documentation/devicetree/bindings/net/dsa/ocelot.txt
index 66a129fea705..7a271d070b72 100644
--- a/Documentation/devicetree/bindings/net/dsa/ocelot.txt
+++ b/Documentation/devicetree/bindings/net/dsa/ocelot.txt
@@ -4,10 +4,15 @@ Microchip Ocelot switch driver family
 Felix
 -----
 
-The VSC9959 core is currently the only switch supported by the driver, and is
-found in the NXP LS1028A. It is a PCI device, part of the larger ENETC root
-complex. As a result, the ethernet-switch node is a sub-node of the PCIe root
-complex node and its "reg" property conforms to the parent node bindings:
+Currently the switches supported by the felix driver are:
+
+- VSC9959 (Felix)
+- VSC9953 (Seville)
+
+The VSC9959 switch is found in the NXP LS1028A. It is a PCI device, part of the
+larger ENETC root complex. As a result, the ethernet-switch node is a sub-node
+of the PCIe root complex node and its "reg" property conforms to the parent
+node bindings:
 
 * reg: Specifies PCIe Device Number and Function Number of the endpoint device,
   in this case for the Ethernet L2Switch it is PF5 (of device 0, bus 0).
@@ -114,3 +119,95 @@ Example:
 		};
 	};
 };
+
+The VSC9953 switch is found inside NXP T1040. It is a platform device with the
+following required properties:
+
+- compatible:
+	Must be "mscc,vsc9953-switch".
+
+Supported PHY interface types (appropriate SerDes protocol setting changes are
+needed in the RCW binary):
+
+* phy_mode = "internal": on ports 8 and 9
+* phy_mode = "sgmii": on ports 0, 1, 2, 3, 4, 5, 6, 7
+* phy_mode = "qsgmii": on ports 0, 1, 2, 3, 4, 5, 6, 7
+
+Example:
+
+&soc {
+	ethernet-switch@800000 {
+		#address-cells = <0x1>;
+		#size-cells = <0x0>;
+		compatible = "mscc,vsc9953-switch";
+		little-endian;
+		reg = <0x800000 0x290000>;
+
+		ports {
+			#address-cells = <0x1>;
+			#size-cells = <0x0>;
+
+			port@0 {
+				reg = <0x0>;
+				label = "swp0";
+			};
+
+			port@1 {
+				reg = <0x1>;
+				label = "swp1";
+			};
+
+			port@2 {
+				reg = <0x2>;
+				label = "swp2";
+			};
+
+			port@3 {
+				reg = <0x3>;
+				label = "swp3";
+			};
+
+			port@4 {
+				reg = <0x4>;
+				label = "swp4";
+			};
+
+			port@5 {
+				reg = <0x5>;
+				label = "swp5";
+			};
+
+			port@6 {
+				reg = <0x6>;
+				label = "swp6";
+			};
+
+			port@7 {
+				reg = <0x7>;
+				label = "swp7";
+			};
+
+			port@8 {
+				reg = <0x8>;
+				phy-mode = "internal";
+				ethernet = <&enet0>;
+
+				fixed-link {
+					speed = <2500>;
+					full-duplex;
+				};
+			};
+
+			port@9 {
+				reg = <0x9>;
+				phy-mode = "internal";
+				status = "disabled";
+
+				fixed-link {
+					speed = <2500>;
+					full-duplex;
+				};
+			};
+		};
+	};
+};
-- 
2.25.1

