Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49654169A10
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 21:48:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727326AbgBWUrz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 15:47:55 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46646 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727188AbgBWUr3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 15:47:29 -0500
Received: by mail-wr1-f65.google.com with SMTP id g4so1645131wro.13;
        Sun, 23 Feb 2020 12:47:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Sv8jsEDNCFEDM8odFJWiRtPKsZJBV3sbBHzIM26MUDA=;
        b=LByWPWncpyh0fl9q5MQGiNZ3TN0DL0kQn3wDO4l+kNOmL+BQivgXgiM+ZF31Ot7Pvp
         pICQTxBM+xWe3/Usw+HtBNBRZp2j/8uD3Z0nOCsPFvkHh/txrSID4s65V0RhLUKWn3C5
         Occ25OJ60b50E4E2vtinwe62G84STsrgi/6av4FhFftk24sB517U/t1MeQ0mh4NegGXH
         v9rowHIkBfldL7dXflYQvrkGP7Wl94BqHwTcJdHdIgGtzbB9lrau71SHXRd3de6UHWWs
         Dzz3S20a5IKidkaurR3+O45/wISKw1jivmhISgEd9hIQly5ktWY6li0M1dez4mYOBs1d
         Ap2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Sv8jsEDNCFEDM8odFJWiRtPKsZJBV3sbBHzIM26MUDA=;
        b=HwSSKn99IE1BSjTtpx74+WLPy9U7mVKd3Uh0ETNRXIbeZbnbQQVkEdzHH1A9UVW/bG
         4xzkjAM2TPa7VWoDIsquJgRvnI+jZ7s6oeYAqmLj7xvvwIDcoXSrNoPl5sO4OZWwDd7u
         sF4ifKu7FDsw9m99//EMN7SQop1udsIQB7QF64k5rRdrGrsfJOt0xnz+C+iWZDmkKW6m
         5SdSxaoyRJ/zv2GHz8oK49mjkkDiL0zsc1C2hM8IMi9FXFEnDl+VkIgYSfr40k3/B0Ro
         FtPv7tqFAiTq+Mu+Zw/GzBJE1iI6FU+b/N/FNtEmoESty6OfCeBTbaRtvXcqIaVARaql
         gqbQ==
X-Gm-Message-State: APjAAAWtFM9OzMkJbwoh/vhNyIVYgEdC1e3DzOBMydR7NMAQYc3qFMIy
        ciLNEj1P4zOoJEd8f7F/JiU=
X-Google-Smtp-Source: APXvYqz9BRcLgtmNXrCiLnXwc44nHuiohUPLa+G7d5UwS5JCClSsN/2vlwkClCklXj7ED3Fyrxo6qg==
X-Received: by 2002:adf:ea42:: with SMTP id j2mr3149619wrn.377.1582490845979;
        Sun, 23 Feb 2020 12:47:25 -0800 (PST)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id z8sm14817927wrq.22.2020.02.23.12.47.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Feb 2020 12:47:25 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     shawnguo@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        devicetree@vger.kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        michael@walle.cc, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 devicetree 2/6] arm64: dts: fsl: ls1028a: disable all enetc ports by default
Date:   Sun, 23 Feb 2020 22:47:12 +0200
Message-Id: <20200223204716.26170-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200223204716.26170-1-olteanv@gmail.com>
References: <20200223204716.26170-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

There are few boards that enable all ENETC ports, so instead of having
board DTs disable them, do so in the DTSI and have the boards enable the
ports they use.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v3:
Patch is new.

 arch/arm64/boot/dts/freescale/fsl-ls1028a-qds.dts | 1 +
 arch/arm64/boot/dts/freescale/fsl-ls1028a-rdb.dts | 5 +----
 arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi    | 5 +++++
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1028a-qds.dts b/arch/arm64/boot/dts/freescale/fsl-ls1028a-qds.dts
index ca409d907b36..dd69c5b821e9 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1028a-qds.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a-qds.dts
@@ -225,6 +225,7 @@
 &enetc_port1 {
 	phy-handle = <&qds_phy1>;
 	phy-connection-type = "rgmii-id";
+	status = "okay";
 };
 
 &sai1 {
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1028a-rdb.dts b/arch/arm64/boot/dts/freescale/fsl-ls1028a-rdb.dts
index afb55653850d..14efe3b06042 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1028a-rdb.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a-rdb.dts
@@ -180,6 +180,7 @@
 &enetc_port0 {
 	phy-handle = <&sgmii_phy0>;
 	phy-connection-type = "sgmii";
+	status = "okay";
 
 	mdio {
 		#address-cells = <1>;
@@ -190,10 +191,6 @@
 	};
 };
 
-&enetc_port1 {
-	status = "disabled";
-};
-
 &sai4 {
 	status = "okay";
 };
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
index dfead691e509..1b330b7cce62 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
@@ -705,17 +705,22 @@
 			enetc_port0: ethernet@0,0 {
 				compatible = "fsl,enetc";
 				reg = <0x000000 0 0 0 0>;
+				status = "disabled";
 			};
+
 			enetc_port1: ethernet@0,1 {
 				compatible = "fsl,enetc";
 				reg = <0x000100 0 0 0 0>;
+				status = "disabled";
 			};
+
 			enetc_mdio_pf3: mdio@0,3 {
 				compatible = "fsl,enetc-mdio";
 				reg = <0x000300 0 0 0 0>;
 				#address-cells = <1>;
 				#size-cells = <0>;
 			};
+
 			ethernet@0,4 {
 				compatible = "fsl,enetc-ptp";
 				reg = <0x000400 0 0 0 0>;
-- 
2.17.1

