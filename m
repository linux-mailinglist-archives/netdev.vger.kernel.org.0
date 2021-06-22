Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2233B07A0
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 16:41:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231941AbhFVOnz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 10:43:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231514AbhFVOnw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 10:43:52 -0400
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93940C061574
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 07:41:36 -0700 (PDT)
Received: from localhost.localdomain (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id DBD49829F9;
        Tue, 22 Jun 2021 16:41:32 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1624372893;
        bh=XBmaZ49ciAVJrRh7lkhd3wM4W5Go7mEqDiemcK4VYBw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nMv4RCkB8SmpZkseaZ+tuERG0Y1tv8KPm6g5XNGF5pwrp4yai4xONd/eEC61efNym
         Dka3gfInYEBvrbcTXLTBW2mpCKVYGLgY02H5Z2vwewgOCC9nT10Hms7WplLjp7S1nI
         FU/KTD/JoIgnCo7JpIiJ6R8hSQ+QKZ9Lig/T22JH03NNlKxACJ4DrA0XMD9GInpZ1c
         9IsvXobMG+aECbT5T0jj6gD8EVRghiIDdrBBNXeiMjAt3Zmc/8OjxfefygRTeCOAzT
         JPhxIuKuuXbTP8n2sAAy6PntXyKBm8ucZOwsrJDtDrWElReHdag4vBBy7uBCRYyw+C
         NRna4cbwdSYMw==
From:   Lukasz Majewski <lukma@denx.de>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Mark Einon <mark.einon@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-kernel@lists.infradead.org, Lukasz Majewski <lukma@denx.de>
Subject: [RFC 1/3] ARM: dts: imx28: Add description for L2 switch on XEA board
Date:   Tue, 22 Jun 2021 16:41:09 +0200
Message-Id: <20210622144111.19647-2-lukma@denx.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210622144111.19647-1-lukma@denx.de>
References: <20210622144111.19647-1-lukma@denx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.103.2 at phobos.denx.de
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 'eth_switch' node is now extendfed to enable support for L2
switch.

Moreover, the mac[01] nodes are defined as well and linked to the
former with 'phy-handle' property.

Signed-off-by: Lukasz Majewski <lukma@denx.de>
---
 arch/arm/boot/dts/imx28-xea.dts | 42 +++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/arch/arm/boot/dts/imx28-xea.dts b/arch/arm/boot/dts/imx28-xea.dts
index d649822febed..94ff801669c4 100644
--- a/arch/arm/boot/dts/imx28-xea.dts
+++ b/arch/arm/boot/dts/imx28-xea.dts
@@ -23,6 +23,48 @@
 	status = "okay";
 };
 
+&mac0 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&mac0_pins_a>;
+	phy-mode = "rmii";
+	phy-supply = <&reg_fec_3v3>;
+	phy-reset-gpios = <&gpio2 13 0>;
+	phy-reset-duration = <100>;
+	local-mac-address = [ 00 11 22 AA BB CC ];
+	status = "okay";
+};
+
+&mac1 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&mac1_pins_a>;
+	phy-mode = "rmii";
+	phy-supply = <&reg_fec_3v3>;
+	local-mac-address = [ 00 11 22 AA BB DD ];
+	status = "okay";
+};
+
+&eth_switch {
+	compatible = "imx,mtip-l2switch";
+	reg = <0x800f8000 0x400>, <0x800fC000 0x4000>,  <0x800f8400 0x400>;
+
+	interrupts = <100>;
+	status = "okay";
+
+	ports {
+		port1@1 {
+			reg = <1>;
+			label = "eth0";
+			phy-handle = <&mac0>;
+		};
+
+		port2@2 {
+			reg = <2>;
+			label = "eth1";
+			phy-handle = <&mac1>;
+		};
+	};
+};
+
 &pinctrl {
 	pinctrl-names = "default";
 	pinctrl-0 = <&hog_pins_a &hog_pins_tiva>;
-- 
2.20.1

