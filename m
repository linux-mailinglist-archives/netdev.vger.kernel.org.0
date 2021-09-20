Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91FD1411871
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 17:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241745AbhITPjz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 11:39:55 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:60206 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241667AbhITPjw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 11:39:52 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 18KFc76E047462;
        Mon, 20 Sep 2021 10:38:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1632152287;
        bh=4X4Abps+sS4ZjOCXgxuJI51YJFWtB0gSN9du1puoDSQ=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=niXKBhGE+OBrlOT8vPQch7k8rxqvg5z/iYM/Holq0dKrPjFcpB588rOv/XJdpOveo
         CZ0H8jhf6zvrikjBIR+qgtW+lHl7EwbSnPfeZe4iDgxuZuIsoqJaiVAuTxJKkuKTfL
         hD1rhXdNZKtpjcfjzWN/AFNB/TLE6iFA2aigBD3o=
Received: from DFLE113.ent.ti.com (dfle113.ent.ti.com [10.64.6.34])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 18KFc66k012889
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 20 Sep 2021 10:38:06 -0500
Received: from DFLE111.ent.ti.com (10.64.6.32) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Mon, 20
 Sep 2021 10:38:02 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE111.ent.ti.com
 (10.64.6.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Mon, 20 Sep 2021 10:38:02 -0500
Received: from gsaswath-HP-ProBook-640-G5.dal.design.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 18KFbPJm104098;
        Mon, 20 Sep 2021 10:37:56 -0500
From:   Aswath Govindraju <a-govindraju@ti.com>
CC:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Aswath Govindraju <a-govindraju@ti.com>,
        Faiz Abbas <faiz_abbas@ti.com>, Nishanth Menon <nm@ti.com>,
        Tero Kristo <kristo@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
Subject: [PATCH v3 4/6] arm64: dts: ti: k3-j721e-common-proc-board: Add support for mcu and main mcan nodes
Date:   Mon, 20 Sep 2021 21:07:21 +0530
Message-ID: <20210920153724.20203-5-a-govindraju@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210920153724.20203-1-a-govindraju@ti.com>
References: <20210920153724.20203-1-a-govindraju@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Faiz Abbas <faiz_abbas@ti.com>

Add four MCAN nodes present on the common processor board and set a
maximum data rate of 5 Mbps. Disable all other nodes as they
are not brought out on the common processor board.

Signed-off-by: Faiz Abbas <faiz_abbas@ti.com>
Signed-off-by: Aswath Govindraju <a-govindraju@ti.com>
---
 .../dts/ti/k3-j721e-common-proc-board.dts     | 155 ++++++++++++++++++
 1 file changed, 155 insertions(+)

diff --git a/arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts b/arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts
index 8bd02d9e28ad..33d175ca9391 100644
--- a/arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts
+++ b/arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts
@@ -109,6 +109,42 @@
 			      "cpb-codec-scki",
 			      "cpb-codec-scki-48000", "cpb-codec-scki-44100";
 	};
+
+	transceiver1: can-phy0 {
+		compatible = "ti,tcan1043";
+		#phy-cells = <0>;
+		max-bitrate = <5000000>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&mcu_mcan0_gpio_pins_default>;
+		standby-gpios = <&wkup_gpio0 54 GPIO_ACTIVE_LOW>;
+		enable-gpios = <&wkup_gpio0 0 GPIO_ACTIVE_HIGH>;
+	};
+
+	transceiver2: can-phy1 {
+		compatible = "ti,tcan1042";
+		#phy-cells = <0>;
+		max-bitrate = <5000000>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&mcu_mcan1_gpio_pins_default>;
+		standby-gpios = <&wkup_gpio0 2 GPIO_ACTIVE_HIGH>;
+	};
+
+	transceiver3: can-phy2 {
+		compatible = "ti,tcan1043";
+		#phy-cells = <0>;
+		max-bitrate = <5000000>;
+		standby-gpios = <&exp2 7 GPIO_ACTIVE_LOW>;
+		enable-gpios = <&exp2 6 GPIO_ACTIVE_HIGH>;
+	};
+
+	transceiver4: can-phy3 {
+		compatible = "ti,tcan1042";
+		#phy-cells = <0>;
+		max-bitrate = <5000000>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&main_mcan2_gpio_pins_default>;
+		standby-gpios = <&main_gpio0 127 GPIO_ACTIVE_HIGH>;
+	};
 };
 
 &main_pmx0 {
@@ -204,6 +240,26 @@
 			J721E_IOPAD(0x1a4, PIN_OUTPUT, 3) /* (W26) RGMII6_RXC.AUDIO_EXT_REFCLK2 */
 		>;
 	};
+
+	main_mcan0_pins_default: main-mcan0-pins-default {
+		pinctrl-single,pins = <
+			J721E_IOPAD(0x208, PIN_INPUT, 0) /* (W5) MCAN0_RX */
+			J721E_IOPAD(0x20c, PIN_OUTPUT, 0) /* (W6) MCAN0_TX */
+		>;
+	};
+
+	main_mcan2_pins_default: main-mcan2-pins-default {
+		pinctrl-single,pins = <
+			J721E_IOPAD(0x01f0, PIN_INPUT, 3) /* (AC2) MCAN2_RX.GPIO0_123 */
+			J721E_IOPAD(0x01f4, PIN_OUTPUT, 3) /* (AB1) MCAN2_TX.GPIO0_124 */
+		>;
+	};
+
+	main_mcan2_gpio_pins_default: main-mcan2-gpio-pins-default {
+		pinctrl-single,pins = <
+			J721E_IOPAD(0x200, PIN_INPUT, 7) /* (AC4) UART1_CTSn.GPIO0_127 */
+		>;
+	};
 };
 
 &wkup_pmx0 {
@@ -249,6 +305,33 @@
 			J721E_WKUP_IOPAD(0x0088, PIN_INPUT, 0) /* MCU_MDIO0_MDIO */
 		>;
 	};
+
+	mcu_mcan0_pins_default: mcu-mcan0-pins-default {
+		pinctrl-single,pins = <
+			J721E_WKUP_IOPAD(0xac, PIN_INPUT, 0) /* (C29) MCU_MCAN0_RX */
+			J721E_WKUP_IOPAD(0xa8, PIN_OUTPUT, 0) /* (D29) MCU_MCAN0_TX */
+		>;
+	};
+
+	mcu_mcan0_gpio_pins_default: mcu-mcan0-gpio-pins-default {
+		pinctrl-single,pins = <
+			J721E_WKUP_IOPAD(0xb0, PIN_INPUT, 7) /* (F26) WKUP_GPIO0_0 */
+			J721E_WKUP_IOPAD(0x98, PIN_INPUT, 7) /* (E28) MCU_SPI0_D1.WKUP_GPIO0_54 */
+		>;
+	};
+
+	mcu_mcan1_pins_default: mcu-mcan1-pins-default {
+		pinctrl-single,pins = <
+			J721E_WKUP_IOPAD(0xc4, PIN_INPUT, 0) /* (G24) WKUP_GPIO0_5.MCU_MCAN1_RX */
+			J721E_WKUP_IOPAD(0xc0, PIN_OUTPUT, 0) /* (G25) WKUP_GPIO0_4.MCU_MCAN1_TX */
+		>;
+	};
+
+	mcu_mcan1_gpio_pins_default: mcu-mcan1-gpio-pins-default {
+		pinctrl-single,pins = <
+			J721E_WKUP_IOPAD(0xb8, PIN_INPUT, 7) /* (F28) WKUP_GPIO0_2 */
+		>;
+	};
 };
 
 &wkup_uart0 {
@@ -770,3 +853,75 @@
 &icssg1_mdio {
 	status = "disabled";
 };
+
+&mcu_mcan0 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&mcu_mcan0_pins_default>;
+	phys = <&transceiver1>;
+};
+
+&mcu_mcan1 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&mcu_mcan1_pins_default>;
+	phys = <&transceiver2>;
+};
+
+&main_mcan0 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&main_mcan0_pins_default>;
+	phys = <&transceiver3>;
+};
+
+&main_mcan1 {
+	status = "disabled";
+};
+
+&main_mcan2 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&main_mcan2_pins_default>;
+	phys = <&transceiver4>;
+};
+
+&main_mcan3 {
+	status = "disabled";
+};
+
+&main_mcan4 {
+	status = "disabled";
+};
+
+&main_mcan5 {
+	status = "disabled";
+};
+
+&main_mcan6 {
+	status = "disabled";
+};
+
+&main_mcan7 {
+	status = "disabled";
+};
+
+&main_mcan8 {
+	status = "disabled";
+};
+
+&main_mcan9 {
+	status = "disabled";
+};
+
+&main_mcan10 {
+	status = "disabled";
+};
+
+&main_mcan11 {
+	status = "disabled";
+};
+
+&main_mcan12 {
+	status = "disabled";
+};
+
+&main_mcan13 {
+	status = "disabled";
+};
-- 
2.17.1

