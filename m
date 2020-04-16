Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9698B1AD01B
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 21:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731207AbgDPTGP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 15:06:15 -0400
Received: from mailoutvs42.siol.net ([185.57.226.233]:37050 "EHLO
        mail.siol.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730693AbgDPTGM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 15:06:12 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.siol.net (Postfix) with ESMTP id C3EFA5246A7;
        Thu, 16 Apr 2020 20:58:18 +0200 (CEST)
X-Virus-Scanned: amavisd-new at psrvmta09.zcs-production.pri
Received: from mail.siol.net ([127.0.0.1])
        by localhost (psrvmta09.zcs-production.pri [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id AfVCf8zZKDrT; Thu, 16 Apr 2020 20:58:18 +0200 (CEST)
Received: from mail.siol.net (localhost [127.0.0.1])
        by mail.siol.net (Postfix) with ESMTPS id 7F20552469F;
        Thu, 16 Apr 2020 20:58:18 +0200 (CEST)
Received: from localhost.localdomain (cpe-194-152-20-232.static.triera.net [194.152.20.232])
        (Authenticated sender: 031275009)
        by mail.siol.net (Postfix) with ESMTPSA id DEC325246A5;
        Thu, 16 Apr 2020 20:58:15 +0200 (CEST)
From:   Jernej Skrabec <jernej.skrabec@siol.net>
To:     robh+dt@kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Cc:     mripard@kernel.org, wens@csie.org, lee.jones@linaro.org,
        linux@armlinux.org.uk, davem@davemloft.net,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [RFC PATCH 4/4] arm64: dts: allwinner: h6: tanix-tx6: Enable ethernet
Date:   Thu, 16 Apr 2020 20:57:58 +0200
Message-Id: <20200416185758.1388148-5-jernej.skrabec@siol.net>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200416185758.1388148-1-jernej.skrabec@siol.net>
References: <20200416185758.1388148-1-jernej.skrabec@siol.net>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tanix TX6 uses ethernet PHY from copackaged AC200 IC.

Enable it.

Signed-off-by: Jernej Skrabec <jernej.skrabec@siol.net>
---
 .../dts/allwinner/sun50i-h6-tanix-tx6.dts     | 32 +++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h6-tanix-tx6.dts b/arch=
/arm64/boot/dts/allwinner/sun50i-h6-tanix-tx6.dts
index 83e6cb0e59ce..41a2e3454be5 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-h6-tanix-tx6.dts
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h6-tanix-tx6.dts
@@ -12,6 +12,7 @@ / {
 	compatible =3D "oranth,tanix-tx6", "allwinner,sun50i-h6";
=20
 	aliases {
+		ethernet0 =3D &emac;
 		serial0 =3D &uart0;
 	};
=20
@@ -39,6 +40,14 @@ reg_vcc3v3: vcc3v3 {
 	};
 };
=20
+&ac200_ephy {
+	status =3D "okay";
+};
+
+&ac200_pwm_clk {
+	status =3D "okay";
+};
+
 &de {
 	status =3D "okay";
 };
@@ -47,6 +56,14 @@ &dwc3 {
 	status =3D "okay";
 };
=20
+&emac {
+	pinctrl-names =3D "default";
+	pinctrl-0 =3D <&ext_rmii_pins>;
+	phy-mode =3D "rmii";
+	phy-handle =3D <&ext_rmii_phy>;
+	status =3D "okay";
+};
+
 &ehci0 {
 	status =3D "okay";
 };
@@ -69,6 +86,17 @@ hdmi_out_con: endpoint {
 	};
 };
=20
+&i2c3 {
+	status =3D "okay";
+};
+
+&mdio {
+	ext_rmii_phy: ethernet-phy@1 {
+		compatible =3D "ethernet-phy-ieee802.3-c22";
+		reg =3D <1>;
+	};
+};
+
 &mmc0 {
 	pinctrl-names =3D "default";
 	pinctrl-0 =3D <&mmc0_pins>;
@@ -86,6 +114,10 @@ &ohci3 {
 	status =3D "okay";
 };
=20
+&pwm {
+	status =3D "okay";
+};
+
 &r_ir {
 	linux,rc-map-name =3D "rc-tanix-tx5max";
 	status =3D "okay";
--=20
2.26.0

