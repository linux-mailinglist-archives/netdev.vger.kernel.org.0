Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F6FF381274
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 23:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234106AbhENVDP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 17:03:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232778AbhENVB4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 17:01:56 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE7C5C061350;
        Fri, 14 May 2021 14:00:38 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id i13so42571edb.9;
        Fri, 14 May 2021 14:00:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cMbbIPoz/E9mCPWCX+knh4B7/pIPz9y1MYvr/nHZTTg=;
        b=P95rgzTerBSmqkuABXDs9YFSAYACNqf2Uf+wqkKs0N0Q803OHsY0VNVlvQAGfRVgGE
         H13xJ4Vu+JJo0BmtQNdYAzidxq3cM5aQ//XWONsffAT+RRXY2uUWqNkwUumIpX8xHGuD
         beCmRCQZZD7az0QLqtbUTkvrPqPlLCeAT7IL/Mm7YwfGT3Wt2Vpi2tNS6l1axJB0BIGw
         qtM18+PwWnM9xg5FAuhWUnxo+SwL6wNfAChsGMFrjfiWtgX/G8GzWvvAG1kgPxsL9v2T
         0wzrHWiMlqV4l9J3xpN5buPEqLyutFpitcTkAkP1o4Jm/8rXbhYhCCYIb+ycKFHu87fT
         dtAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cMbbIPoz/E9mCPWCX+knh4B7/pIPz9y1MYvr/nHZTTg=;
        b=PalyVj9+TOXv1YiuJ2ERuE0fNPO5NY358kKIyUMMpQ0NM3aL11js/qEgHLeFJOya5g
         TLjqPQ5tJ3v/8sLcwhFfhophtV9BtOIpUO+at4GUkjAfeZk0wNYDT3xN43YYreOYL4Gw
         auZP7LZQmwJHLbLB50rJDI5L5sQ+ToxupU3Z+IrDeyS04EutxyerCmEL+gnSgXOhK3ME
         WfXamXs7pV8SKwtij9f270vepSfrkWuwbcQi2deRj0TOUkJjf0fHuQwT1GsO504A8IMs
         /NIKuvdtEkiljvqg4dLVp1biETdclNLFLymJHb4qFrGy2yvz0RfD5yAjivgw6Z41zpl+
         pb7Q==
X-Gm-Message-State: AOAM530u6r3RzR/VVrrZfOJj7VoavCLK2kMlGA/B6Z7oIb/2yQPcT/5s
        p24Ya9B5qqiFfSrUXl1ME7k=
X-Google-Smtp-Source: ABdhPJx5Xh9CHKQWvazJa1WAhYY7WQ3M27VUb7UTya/v5a/zQzItG+OCXJ6Lgk2v+HwemwU+JEZBAg==
X-Received: by 2002:aa7:cc98:: with SMTP id p24mr33565381edt.353.1621026037540;
        Fri, 14 May 2021 14:00:37 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id c3sm5455237edn.16.2021.05.14.14.00.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:00:37 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Rob Herring <robh@kernel.org>
Subject: [PATCH net-next v6 21/25] devicetree: bindings: dsa: qca8k: Document internal mdio definition
Date:   Fri, 14 May 2021 23:00:11 +0200
Message-Id: <20210514210015.18142-22-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210514210015.18142-1-ansuelsmth@gmail.com>
References: <20210514210015.18142-1-ansuelsmth@gmail.com>
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
Reviewed-by: Rob Herring <robh@kernel.org>
---
 .../devicetree/bindings/net/dsa/qca8k.txt     | 39 +++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.txt b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
index 1daf68e7ae19..8c73f67c43ca 100644
--- a/Documentation/devicetree/bindings/net/dsa/qca8k.txt
+++ b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
@@ -21,6 +21,10 @@ described in dsa/dsa.txt. If the QCA8K switch is connect to a SoC's external
 mdio-bus each subnode describing a port needs to have a valid phandle
 referencing the internal PHY it is connected to. This is because there's no
 N:N mapping of port and PHY id.
+To declare the internal mdio-bus configuration, declare a mdio node in the
+switch node and declare the phandle for the port referencing the internal
+PHY is connected to. In this config a internal mdio-bus is registered and
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

